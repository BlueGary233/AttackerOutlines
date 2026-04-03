-- 单位跟踪模块
local mod = get_mod("AttackerOutlines")

-- 导入其他模块
local ui = mod:io_dofile("AttackerOutlines/scripts/mods/AttackerOutlines/modules/ui")
local log = mod:io_dofile("AttackerOutlines/scripts/mods/AttackerOutlines/modules/log")
local attack_handler = mod:io_dofile("AttackerOutlines/scripts/mods/AttackerOutlines/modules/attack_handler")

-- 跟踪的单位数据：{unit = {breed_name, target_unit, is_online, last_update}}
local tracked_units = {}

-- 单位动画状态：{unit = {last_anim_event = anim_event_name, has_ranged_outline = boolean}}
local unit_animation_states = {}

-- 获取breed_name（从attack_handler模块导入）
local get_breed_name = attack_handler.get_breed_name

-- 获取敌人目标（从attack_handler模块导入）
local get_enemy_target = attack_handler.get_enemy_target

-- 检查是否是玩家（从attack_handler模块导入）
local is_player = attack_handler.is_player

-- 检查是否是敌人（从attack_handler模块导入）
local is_enemy = attack_handler.is_enemy

-- 单位变化日志记录函数
local function log_units_change(unit, data, change_type, old_value, new_value, method_used)
    log.log_units_change(unit, data, change_type, old_value, new_value, method_used)
end

-- 单位跟踪和更新函数
local function update_tracked_units()
    -- 遍历tracked_units表中的所有单位
    for unit, data in pairs(tracked_units) do
        -- 检查unit是否存活
        if unit and HEALTH_ALIVE[unit] then
            -- 获取当前目标
            local current_target = get_enemy_target(unit)
            
            -- 检查目标是否变化
            if current_target ~= data.target_unit then
                local old_target = data.target_unit
                data.target_unit = current_target
                data.last_update = Managers.time and Managers.time:time("main") or 0
                
                -- 记录目标变化
                if ui.debug_mode then
                    local is_online = data.is_online or false
                    local enemy_type = is_online and "在线敌人" or "本地敌人"
                    log.debug_output(string.format("[%s目标变化] Unit: %s, Breed: %s, 旧目标: %s, 新目标: %s", 
                        enemy_type, tostring(unit), data.breed_name or "unknown", tostring(old_target), tostring(current_target)))
                    
                    -- 记录到日志文件
                    log.log_units_change(unit, data, "TARGET_CHANGE", old_target, current_target, "game_object_id.target_unit_id")
                end
            end
        else
            -- unit不再存活，从表中移除
            tracked_units[unit] = nil
            
            if ui.debug_mode then
                log.debug_output(string.format("[数据清理] 移除死亡单位: Unit %s", tostring(unit)))
            end
        end
    end
end

-- 处理敌人初始化的通用函数（包含event_index收集）
local function handle_enemy_init(unit, is_online)
    local breed_name = get_breed_name(unit)
    if breed_name then
        -- 这是敌人单位
        local target_unit = get_enemy_target(unit)
        
        -- 简化的调试输出
        if ui.debug_mode then
            log.debug_output(string.format("[敌人初始化] 单位: %s, 在线: %s, Breed: %s, 目标: %s", 
                tostring(unit), is_online, breed_name, tostring(target_unit)))
        end
        
        -- 记录到日志文件
        if ui.debug_mode then
            local event_type = is_online and "敌人创建(在线)" or "敌人创建"
            log.log_units_change(unit, {breed_name = breed_name}, event_type, nil, target_unit, "game_object_id.target_unit_id")
        end
        
        -- 获取或创建敌人的跟踪数据
        local existing_data = tracked_units[unit]
        
        if not existing_data then
            -- 敌人还没有被跟踪，创建新的跟踪数据
            tracked_units[unit] = {
                breed_name = breed_name,
                target_unit = target_unit,
                is_online = is_online,
                last_update = Managers.time and Managers.time:time("main") or 0
            }
        end
    end
end

-- 清理死亡单位的跟踪数据
local function cleanup_dead_tracked_units()
    for unit, _ in pairs(tracked_units) do
        if not HEALTH_ALIVE[unit] then
            tracked_units[unit] = nil
            unit_animation_states[unit] = nil
            
            if ui.debug_mode then
                log.debug_output(string.format("[清理] 移除死亡单位的跟踪数据: 单位=%s", tostring(unit)))
            end
        end
    end
end

-- 重置跟踪数据（用于游戏状态变化时）
local function reset_tracking_data()
    -- 清空所有跟踪数据
    tracked_units = {}
    unit_animation_states = {}
    
    if ui.debug_mode then
        log.debug_output("[重置] 单位跟踪数据已重置")
    end
end

-- 导出模块接口
return {
    tracked_units = tracked_units,
    unit_animation_states = unit_animation_states,
    update_tracked_units = update_tracked_units,
    handle_enemy_init = handle_enemy_init,
    cleanup_dead_tracked_units = cleanup_dead_tracked_units,
    reset_tracking_data = reset_tracking_data
}
