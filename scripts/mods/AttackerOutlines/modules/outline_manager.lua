-- 轮廓线管理模块
local mod = get_mod("AttackerOutlines")

-- 导入其他模块
local ui = mod:io_dofile("AttackerOutlines/scripts/mods/AttackerOutlines/modules/ui")
local log = mod:io_dofile("AttackerOutlines/scripts/mods/AttackerOutlines/modules/log")

-- 核心数据结构
local outlined_units = {}      -- 当前有轮廓的单位：{unit = {color = color_name}}
local outlines_add_queue = {}  -- 待添加轮廓队列：{{unit = unit, color = color_name}, ...}

-- 获取轮廓系统
local function get_outline_system()
    return Managers.state.extension and Managers.state.extension:system("outline_system")
end

-- 移除轮廓的函数
local function remove_outline(unit, outline_color)
    if not unit then return end
    
    local outline_system = get_outline_system()
    if not outline_system then return end
    
    -- 从outlined_units表中移除
    if outlined_units[unit] and outlined_units[unit].color == outline_color then
        outlined_units[unit] = nil
    end
    
    -- 从轮廓系统中移除
    outline_system:remove_outline(unit, outline_color, true)
    
    -- 从添加队列中移除相同单位的相同颜色请求
    for i = #outlines_add_queue, 1, -1 do
        if outlines_add_queue[i].unit == unit and outlines_add_queue[i].color == outline_color then
            table.remove(outlines_add_queue, i)
        end
    end
    
    if ui.debug_mode then
        log.debug_output(string.format("[移除轮廓] 单位=%s, 颜色=%s", tostring(unit), outline_color))
    end
end

-- 检查单位是否在添加队列中（去重辅助函数）
local function is_unit_in_outlines_add_queue(unit, color)
    for _, item in ipairs(outlines_add_queue) do
        if item.unit == unit and item.color == color then
            return true
        end
    end
    return false
end

-- 添加轮廓的函数
local function add_outline(unit, outline_color)
    if not unit then
        return  -- 如果单位是nil，直接返回
    end
    
    local existing_data = outlined_units[unit]
    
    if existing_data then
        -- 单位已经有轮廓
        if existing_data.color == outline_color then
            -- 颜色相同，不需要重复添加
            if ui.debug_mode then
                log.debug_output(string.format("[直接更新] 轮廓已存在: 单位=%s, 颜色=%s", tostring(unit), outline_color))
            end
            return  -- 不需要进队列
        else
            -- 颜色不同，需要先移除旧轮廓再添加新轮廓
            -- 将新轮廓加入队列，旧轮廓会在process_outlines_add_queue中处理
            if not is_unit_in_outlines_add_queue(unit, outline_color) then
                table.insert(outlines_add_queue, {
                    unit = unit,
                    color = outline_color
                })
                
                if ui.debug_mode then
                    log.debug_output(string.format("[队列] 颜色变化: 单位=%s, 新颜色=%s", tostring(unit), outline_color))
                end
            end
            return
        end
    end
    
    -- 单位没有轮廓，检查是否已经在队列中
    if not is_unit_in_outlines_add_queue(unit, outline_color) then
        table.insert(outlines_add_queue, {
            unit = unit,
            color = outline_color
        })
        
        if ui.debug_mode then
            log.debug_output(string.format("[队列] 新轮廓: 单位=%s, 颜色=%s", tostring(unit), outline_color))
        end
    end
end

-- 处理添加队列函数
local function process_outlines_add_queue()
    local outline_system = get_outline_system()
    if not outline_system then
        return
    end
    
    local processed = 0
    
    -- 处理添加队列
    while #outlines_add_queue > 0 and processed < ui.max_queue_per_frame do
        local request = outlines_add_queue[1]
        table.remove(outlines_add_queue, 1)
        
        local unit = request.unit
        local outline_color = request.color
        
        -- 检查单位是否已经有相同颜色的轮廓
        local existing_data = outlined_units[unit]
        if existing_data and existing_data.color == outline_color then
            -- 已经有相同颜色的轮廓，不需要重复添加
            if ui.debug_mode then
                log.debug_output(string.format("[队列] 轮廓已存在: 单位=%s, 颜色=%s", tostring(unit), outline_color))
            end
        else
            -- 如果单位有不同颜色的轮廓，先移除旧轮廓
            if existing_data then
                outline_system:remove_outline(unit, existing_data.color, true)
                
                if ui.debug_mode then
                    log.debug_output(string.format("[队列] 移除旧轮廓: 单位=%s, 旧颜色=%s", tostring(unit), existing_data.color))
                end
            end
            
            -- 添加新轮廓
            outline_system:add_outline(unit, outline_color, true)
            outlined_units[unit] = {
                color = outline_color
            }
            
            if ui.debug_mode then
                log.debug_output(string.format("[队列] 添加轮廓: 单位=%s, 颜色=%s", tostring(unit), outline_color))
            end
        end
        
        processed = processed + 1
    end
end

-- 清理死亡单位的轮廓
local function cleanup_dead_units()
    for unit, _ in pairs(outlined_units) do
        if not HEALTH_ALIVE[unit] then
            -- 单位已死亡，清理轮廓
            outlined_units[unit] = nil
            
            -- 从添加队列中移除该单位的所有请求
            for i = #outlines_add_queue, 1, -1 do
                if outlines_add_queue[i].unit == unit then
                    table.remove(outlines_add_queue, i)
                end
            end
            
            if ui.debug_mode then
                log.debug_output(string.format("[清理] 移除死亡单位的轮廓: 单位=%s", tostring(unit)))
            end
        end
    end
end

-- 重置轮廓数据（用于游戏状态变化时）
local function reset_outline_data()
    -- 清空所有轮廓数据
    outlined_units = {}
    outlines_add_queue = {}
    
    if ui.debug_mode then
        log.debug_output("[重置] 轮廓数据已重置")
    end
end

-- 导出模块接口
return {
    outlined_units = outlined_units,
    outlines_add_queue = outlines_add_queue,
    get_outline_system = get_outline_system,
    remove_outline = remove_outline,
    add_outline = add_outline,
    process_outlines_add_queue = process_outlines_add_queue,
    cleanup_dead_units = cleanup_dead_units,
    reset_outline_data = reset_outline_data
}
