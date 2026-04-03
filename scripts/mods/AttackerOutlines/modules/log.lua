-- 日志模块
local mod = get_mod("AttackerOutlines")

-- 获取DMF模块以访问_io
local DMF = get_mod("DMF")
local _io = DMF and DMF:persistent_table("_io")
if _io and not _io.initialized then
    _io = DMF.deepcopy(Mods.lua.io)
end
_io = _io or Mods.lua.io
local _os = Mods.lua.os

-- 日志文件路径
local target_change_log_path = "..\\mods\\AttackerOutlines\\target_change.log"
local anim_event_log_path = "..\\mods\\AttackerOutlines\\anim_event.log"
local event_index_log_path = "..\\mods\\AttackerOutlines\\event_index.log"

-- 调试输出函数（同时输出到控制台和print）
local function debug_output(message)
    local debug_mode = mod:get("debug_mode") or false
    
    if debug_mode then
        mod:echo(message)
        print("[AttackerOutlines] " .. message)
    end
end

-- 单位变化日志记录函数
local function log_units_change(unit, data, change_type, old_value, new_value, method_used)
    local log_all = mod:get("log_all") or false
    local debug_mode = mod:get("debug_mode") or false
    
    if not log_all then
        return
    end

    local file, err = _io.open(target_change_log_path, "a")
    if not file then
        debug_output("Failed to open target change log file: " .. tostring(err))
        return
    end
    
    local timestamp = _os.date("%Y-%m-%d %H:%M:%S")
    local current_time = Managers.time and Managers.time:time("main") or 0
    
    file:write(string.format("[%s] Time: %.3f\n", timestamp, current_time))
    file:write(string.format("Change Type: %s\n", change_type))
    file:write(string.format("Unit: %s\n", tostring(unit)))
    
    if data and data.breed_name then
        file:write(string.format("Breed Name: %s\n", data.breed_name))
    else
        file:write("Breed: unknown\n")
    end
    
    -- 根据变化类型记录不同的信息
    if change_type == "TARGET_CHANGE" then
        file:write(string.format("Old Target Unit: %s\n", tostring(old_value)))
        file:write(string.format("New Target Unit: %s\n", tostring(new_value)))
        -- 记录使用的方法
        if method_used then
            file:write(string.format("Method Used: %s\n", method_used))
        end
    end
    
    file:write(string.rep("-", 80) .. "\n\n")
    file:close()

    -- 只在控制台输出关键信息，减少噪音
    if change_type == "TARGET_CHANGE" and debug_mode then
        debug_output(string.format("[目标变化] 单位: %s, 旧目标: %s, 新目标: %s, 方法: %s",
            tostring(unit), tostring(old_value), tostring(new_value), method_used or "unknown"))
    end
end

-- 动画事件日志记录函数
local function log_anim_event(unit, anim_event_name)
    local log_all = mod:get("log_all") or false
    local debug_mode = mod:get("debug_mode") or false
    
    if not log_all then
        return
    end

    local file, err = _io.open(anim_event_log_path, "a")
    if not file then
        debug_output("Failed to open anim event log file: " .. tostring(err))
        return
    end
    
    local timestamp = _os.date("%Y-%m-%d %H:%M:%S")
    local current_time = Managers.time and Managers.time:time("main") or 0
    
    -- 获取breed_name
    local breed_name = "unknown"
    local unit_data_ext = ScriptUnit.has_extension(unit, "unit_data_system")
    if unit_data_ext then
        local breed = unit_data_ext._breed
        if breed then
            breed_name = breed.name or "unknown"
        end
    end
    
    -- 检查是否是敌人
    local is_enemy_unit = false
    if breed_name ~= "companion_dog" and
        breed_name ~= "human" and
        breed_name ~= "ogryn" and
        breed_name ~= "sand_vortex" and
        breed_name ~= "nurgle_flies" and
        breed_name ~= "unknown" and
        breed_name ~= "attack_valkyrie" then
        is_enemy_unit = true
    end
    
    -- 检查是否是攻击相关的动画
    local is_attack = false
    if anim_event_name then
        if anim_event_name:find("attack") or
           anim_event_name:find("melee") or
           anim_event_name:find("shoot") or
           anim_event_name:find("ranged") or
           anim_event_name:find("special") or
           anim_event_name:find("charge") or
           anim_event_name:find("swing") or
           anim_event_name:find("hit") then
            is_attack = true
        end
    end
    
    if is_enemy_unit then
        file:write(string.format("[%s] Time: %.3f\n", timestamp, current_time))
        file:write(string.format("Event: 动画事件\n"))
        file:write(string.format("Unit: %s\n", tostring(unit)))
        file:write(string.format("Anim Event Name: %s\n", anim_event_name or "unknown"))
        file:write(string.format("Is Enemy: %s\n", is_enemy_unit and "是" or "否"))
        file:write(string.format("Breed Name: %s\n", breed_name or "unknown"))
        file:write(string.format("Is Attack: %s\n", is_attack and "是" or "否"))   
        file:write(string.rep("-", 80) .. "\n\n")
        file:close()
    end

    -- 控制台输出（只输出敌人和攻击相关的动画）
    if is_enemy_unit and is_attack and debug_mode then
        debug_output(string.format("[敌人攻击动画] 单位: %s, Breed: %s, 动画: %s",
            tostring(unit), breed_name, anim_event_name or "unknown"))
    elseif debug_mode and is_enemy_unit then
        debug_output(string.format("[敌人动画] 单位: %s, Breed: %s, 动画: %s",
            tostring(unit), breed_name, anim_event_name or "unknown"))
    end
end

-- event_index收集日志记录函数
local function log_event_index_collection_start(unit, breed_name)
    local log_all = mod:get("log_all") or false
    local debug_mode = mod:get("debug_mode") or false
    
    if not log_all then
        return nil  -- 返回nil表示不需要记录
    end

    local file, err = _io.open(event_index_log_path, "a")
    if not file then
        debug_output("Failed to open event index log file: " .. tostring(err))
        return nil
    end
    
    local timestamp = _os.date("%Y-%m-%d %H:%M:%S")
    local current_time = Managers.time and Managers.time:time("main") or 0
    
    file:write(string.format("[%s] Time: %.3f\n", timestamp, current_time))
    file:write(string.format("开始收集event_index: 单位=%s, Breed=%s\n", tostring(unit), breed_name))
    
    return file
end

-- 记录单个event_index映射
local function log_event_index_mapping(file, anim_event_name, event_index, from_cache)
    local log_all = mod:get("log_all") or false
    local debug_mode = mod:get("debug_mode") or false
    
    if not log_all then
        return
    end
    
    if file then
        if from_cache then
            file:write(string.format("  anim_event_name: %s -> event_index: %d (缓存)\n", anim_event_name, event_index))
        else
            file:write(string.format("  anim_event_name: %s -> event_index: %d\n", anim_event_name, event_index))
        end
    end
    
    if debug_mode then
        if from_cache then
            debug_output(string.format("[event_index缓存] 动作: %s -> event_index: %d (缓存)", anim_event_name, event_index))
        else
            debug_output(string.format("[event_index收集] 动作: %s -> event_index: %d", anim_event_name, event_index))
        end
    end
end

-- 结束event_index收集日志
local function log_event_index_collection_end(file, collected_count)
    local log_all = mod:get("log_all") or false
    local debug_mode = mod:get("debug_mode") or false
    
    if not log_all then
        return
    end
    
    if file then
        file:write(string.format("收集完成: 共收集了 %d 个event_index\n", collected_count))
        file:write(string.rep("-", 80) .. "\n\n")
        file:close()
    end
    
    if debug_mode then
        debug_output(string.format("[event_index收集] 完成: 共收集了 %d 个event_index", collected_count))
    end
end

-- 导出模块接口
return {
    debug_output = debug_output,
    log_units_change = log_units_change,
    log_anim_event = log_anim_event,
    log_event_index_collection_start = log_event_index_collection_start,
    log_event_index_mapping = log_event_index_mapping,
    log_event_index_collection_end = log_event_index_collection_end
}
