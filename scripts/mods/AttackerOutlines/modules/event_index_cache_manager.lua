-- event_index缓存管理模块
local mod = get_mod("AttackerOutlines")

-- 获取DMF模块以访问_io
local DMF = get_mod("DMF")
local _io = DMF and DMF:persistent_table("_io")
if _io and not _io.initialized then
    _io = DMF.deepcopy(Mods.lua.io)
end
_io = _io or Mods.lua.io
-- 使用Mods.lua.loadstring（与DMF保持一致）
local _loadstring = Mods.lua.loadstring

-- 导入log模块
local log = mod:io_dofile("AttackerOutlines/scripts/mods/AttackerOutlines/modules/log")

-- 缓存数据结构
local event_index_cache = {}
local event_index_to_name_cache = {}  -- 反向缓存：event_index -> event_name

-- 加载 event_index 缓存文件
local function load_event_index_cache()
    local cache_path = "..\\mods\\AttackerOutlines\\scripts\\mods\\AttackerOutlines\\modules\\event_index_cache.lua"
    local file, err = _io.open(cache_path, "r")
    if file then
        local content = file:read("*a")
        file:close()
        
        -- 安全地执行 Lua 代码获取缓存表（使用loadstring函数，与DMF保持一致）
        -- 注意：缓存文件已经返回 EVENT_INDEX_CACHE 表，所以我们直接执行整个文件
        local chunk, load_err = _loadstring(content, cache_path)
        if chunk then
            local success, loaded_cache = pcall(chunk)
            if success and loaded_cache then
                event_index_cache = loaded_cache
                
                -- 构建反向缓存
                event_index_to_name_cache = {}
                for breed_name, breed_data in pairs(loaded_cache) do
                    if not event_index_to_name_cache[breed_name] then
                        event_index_to_name_cache[breed_name] = {}
                    end
                    for anim_event_name, event_index in pairs(breed_data) do
                        event_index_to_name_cache[breed_name][event_index] = anim_event_name
                    end
                end
                
                local total_breeds = 0
                local total_mappings = 0
                for _, breed_data in pairs(event_index_cache) do
                    total_breeds = total_breeds + 1
                    for _ in pairs(breed_data) do
                        total_mappings = total_mappings + 1
                    end
                end
                
                log.debug_output(string.format("[event_index缓存] 已加载 %d 个breed的 %d 个映射", total_breeds, total_mappings))
            else
                log.debug_output("[event_index缓存] 执行缓存文件失败: " .. tostring(loaded_cache))
                event_index_cache = {}
            end
        else
            log.debug_output("[event_index缓存] 缓存文件格式错误: " .. tostring(load_err))
            event_index_cache = {}
        end
    else
        event_index_cache = {}
        log.debug_output("[event_index缓存] 缓存文件不存在，创建空缓存")
    end
end

-- 保存 event_index 缓存到文件
local function save_event_index_cache()
    local cache_path = "..\\mods\\AttackerOutlines\\scripts\\mods\\AttackerOutlines\\modules\\event_index_cache.lua"
    local file, err = _io.open(cache_path, "w")
    if not file then
        log.debug_output("Failed to open event index cache file for writing: " .. tostring(err))
        return
    end
    
    -- 生成 Lua 表格式的字符串
    file:write("-- event_index 缓存文件\n")
    file:write("-- 自动生成\n\n")
    file:write("local EVENT_INDEX_CACHE = {\n")
    
    -- 按 breed 名称排序，便于阅读
    local breed_names = {}
    for breed_name in pairs(event_index_cache) do
        table.insert(breed_names, breed_name)
    end
    table.sort(breed_names)
    
    for _, breed_name in ipairs(breed_names) do
        local breed_data = event_index_cache[breed_name]
        if breed_data and next(breed_data) then
            file:write(string.format('    ["%s"] = {\n', breed_name))
            
            -- 按 anim_event_name 排序
            local anim_names = {}
            for anim_name in pairs(breed_data) do
                table.insert(anim_names, anim_name)
            end
            table.sort(anim_names)
            
            for _, anim_name in ipairs(anim_names) do
                local event_index = breed_data[anim_name]
                file:write(string.format('        ["%s"] = %d,\n', anim_name, event_index))
            end
            
            file:write('    },\n')
        end
    end
    
    file:write("}\n\n")
    file:write("return EVENT_INDEX_CACHE\n")
    file:close()
    
    log.debug_output("[event_index缓存] 缓存已保存到文件")
end

-- 缓存 event_index 映射
local function cache_event_mapping(breed_name, anim_event_name, event_index)
    if not breed_name or not anim_event_name or not event_index then
        return
    end
    
    -- 只记录有效的 event_index
    if event_index < 0 then
        return
    end
    
    -- 更新正向缓存
    if not event_index_cache[breed_name] then
        event_index_cache[breed_name] = {}
    end
    event_index_cache[breed_name][anim_event_name] = event_index
    
    -- 更新反向缓存
    if not event_index_to_name_cache[breed_name] then
        event_index_to_name_cache[breed_name] = {}
    end
    event_index_to_name_cache[breed_name][event_index] = anim_event_name
    
    log.debug_output(string.format("[event_index缓存] 缓存映射: Breed=%s, 动作=%s -> event_index=%d", 
        breed_name, anim_event_name, event_index))
end

-- 从缓存获取 event_index
local function get_cached_event_index(breed_name, anim_event_name)
    if not breed_name or not anim_event_name then
        return nil
    end
    
    local breed_cache = event_index_cache[breed_name]
    if breed_cache then
        return breed_cache[anim_event_name]
    end
    
    return nil
end

-- 从 event_index 反向查找 event_name
local function get_event_name_from_index(breed_name, event_index)
    if not breed_name or not event_index then
        return nil
    end
    
    local breed_reverse_cache = event_index_to_name_cache[breed_name]
    if breed_reverse_cache then
        return breed_reverse_cache[event_index]
    end
    
    return nil
end

-- 统计缓存条目数量
local function count_cache_entries()
    local total = 0
    for _, breed_data in pairs(event_index_cache) do
        for _ in pairs(breed_data) do
            total = total + 1
        end
    end
    return total
end

-- 导出模块接口
return {
    event_index_cache = event_index_cache,
    event_index_to_name_cache = event_index_to_name_cache,
    load_event_index_cache = load_event_index_cache,
    save_event_index_cache = save_event_index_cache,
    cache_event_mapping = cache_event_mapping,
    get_cached_event_index = get_cached_event_index,
    get_event_name_from_index = get_event_name_from_index,
    count_cache_entries = count_cache_entries
}
