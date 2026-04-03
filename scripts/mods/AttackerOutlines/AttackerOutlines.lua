local mod = get_mod("AttackerOutlines")

-- ========== 导入所有模块 ==========
-- 导入UI模块
local ui = mod:io_dofile("AttackerOutlines/scripts/mods/AttackerOutlines/modules/ui")
-- 导入攻击时机模块
local damage_timings = mod:io_dofile("AttackerOutlines/scripts/mods/AttackerOutlines/modules/damage_timings")
-- 导入日志模块
local log = mod:io_dofile("AttackerOutlines/scripts/mods/AttackerOutlines/modules/log")
-- 导入event_index缓存管理模块
local event_index_cache_manager = mod:io_dofile("AttackerOutlines/scripts/mods/AttackerOutlines/modules/event_index_cache_manager")
-- 导入攻击处理模块
local attack_handler = mod:io_dofile("AttackerOutlines/scripts/mods/AttackerOutlines/modules/attack_handler")
-- 导入轮廓线管理模块
local outline_manager = mod:io_dofile("AttackerOutlines/scripts/mods/AttackerOutlines/modules/outline_manager")
-- 导入单位跟踪模块
local unit_tracker = mod:io_dofile("AttackerOutlines/scripts/mods/AttackerOutlines/modules/unit_tracker")

-- ========== 模块初始化 ==========
-- 初始化event_index缓存
event_index_cache_manager.load_event_index_cache()

-- ========== event_index 收集功能（混合缓存机制） ==========
local function collect_event_indices(unit)
    -- 检查是否启用了event_index收集功能
    local collect_event_indices_enabled = mod:get("collect_event_indices_enabled")
    if not collect_event_indices_enabled then
        return
    end
    
    -- 获取breed_name
    local breed_name = attack_handler.get_breed_name(unit)
    if not breed_name then
        return
    end
    
    -- 获取damage_timings表中该breed的数据
    local breed_data = damage_timings[breed_name]
    if not breed_data then
        if ui.debug_mode then
            log.debug_output(string.format("[event_index收集] Breed %s 不在damage_timings表中", breed_name))
        end
        return
    end
    
    -- 开始记录event_index收集
    local log_file = log.log_event_index_collection_start(unit, breed_name)
    if not log_file then
        return  -- 不需要记录
    end
    
    -- 检查缓存中是否已有该breed的数据
    local cached_breed_data = event_index_cache_manager.event_index_cache[breed_name]
    local need_update_cache = false
    
    -- 遍历该breed的所有动作名称
    local collected_count = 0
    for anim_event_name, _ in pairs(breed_data) do
        -- 检查缓存中是否已有该映射
        if cached_breed_data and cached_breed_data[anim_event_name] then
            -- 已有缓存，使用缓存数据
            local event_index = cached_breed_data[anim_event_name]
            log.log_event_index_mapping(log_file, anim_event_name, event_index, true)
        else
            -- 缓存中没有，需要动态获取
            local event_index = Unit.animation_event(unit, anim_event_name)
            
            -- 记录结果
            log.log_event_index_mapping(log_file, anim_event_name, event_index, false)
            
            -- 只记录有效的event_index
            if event_index and event_index ~= -361245183 then
                -- 更新缓存
                event_index_cache_manager.cache_event_mapping(breed_name, anim_event_name, event_index)
                need_update_cache = true
            end
        end
        
        collected_count = collected_count + 1
    end
    
    -- 如果需要更新缓存文件
    if need_update_cache then
        event_index_cache_manager.save_event_index_cache()
    end
    
    -- 结束记录
    log.log_event_index_collection_end(log_file, collected_count)
end

-- ========== 敌人初始化处理函数（包含event_index收集） ==========
local function handle_enemy_init_with_event_index(unit, is_online)
    -- 处理敌人初始化
    unit_tracker.handle_enemy_init(unit, is_online)
    
    -- 收集event_index
    collect_event_indices(unit)
end

-- ========== 攻击动画处理函数（统一入口） ==========
local function handle_attack_animation(unit, anim_event_name)
    attack_handler.handle_attack_animation(
        unit,
        anim_event_name,
        outline_manager.add_outline,
        outline_manager.remove_outline,
        unit_tracker.unit_animation_states
    )
end

-- ========== 模块主函数 ==========
-- 回调函数，每帧更新
function mod.update(dt)
    -- 更新单位跟踪
    unit_tracker.update_tracked_units()
    
    -- 处理添加队列
    outline_manager.process_outlines_add_queue()
    
    -- 处理待处理攻击
    attack_handler.process_pending_attacks(outline_manager.add_outline, outline_manager.remove_outline)
    
    -- 清理死亡单位的轮廓
    outline_manager.cleanup_dead_units()
    
    -- 清理死亡单位的跟踪数据
    unit_tracker.cleanup_dead_tracked_units()
end

-- ========== Hook函数 ==========
-- Hook Unit.animation_event 函数来检测所有动画事件
mod:hook_safe("Unit", "animation_event", function(unit, event_name)
    -- 记录动画事件到日志
    log.log_anim_event(unit, event_name)
    -- 处理攻击动画
    handle_attack_animation(unit, event_name)
end)

-- Hook Unit.animation_event_by_index 函数来处理在线单位的动画事件
mod:hook_safe("Unit", "animation_event_by_index", function(unit, event_index)
    local event_index = event_index or 0
    
    -- 检查单位是否是敌人
    if not attack_handler.is_enemy(unit) then
        return
    end
    
    -- 获取breed_name
    local breed_name = attack_handler.get_breed_name(unit)
    if not breed_name then
        return
    end
    
    -- 从缓存中查找event_name
    local event_name = event_index_cache_manager.get_event_name_from_index(breed_name, event_index)
    
    if event_name then
        -- 找到对应的event_name，处理攻击动画
        if ui.debug_mode then
            log.debug_output(string.format("[在线单位动画事件] 单位: %s, Breed: %s, event_index: %d -> event_name: %s", 
                tostring(unit), breed_name, event_index, event_name))
        end
        
        -- 处理攻击动画
        handle_attack_animation(unit, event_name)
    else
        -- 未找到对应的event_name
        if ui.debug_mode then
            log.debug_output(string.format("[在线单位动画事件] 单位: %s, Breed: %s, event_index: %d -> 未知的event_name", 
                tostring(unit), breed_name, event_index))
        end
    end
end)

-- Hook HealthExtension 的 init 函数来检测本地敌人被创建
mod:hook_safe("HealthExtension", "init", function(self, extension_init_context, unit)
    handle_enemy_init_with_event_index(unit, false)  -- false表示本地敌人
end)

-- Hook HuskHealthExtension 的 init 函数来检测在线敌人被创建
mod:hook_safe("HuskHealthExtension", "init", function(self, extension_init_context, unit)
    handle_enemy_init_with_event_index(unit, true)  -- true表示在线敌人
end)

-- ========== 模块设置和初始化 ==========
-- 更新轮廓线设置的函数（委托给UI模块）
mod.update_outline_settings = function(self, instance)
    ui.update_outline_settings(instance)
end

mod.on_setting_changed = function(id)
    -- 将设置变更委托给UI模块处理
    ui.on_setting_changed(id)
end

-- 初始设置轮廓线（使用UI模块）
mod:update_outline_settings()

-- 初始化RGB滑块显示
ui.update_rgb_sliders()

-- Hook轮廓线设置，确保自定义轮廓线类型始终可用（参考outline_colours.lua）
mod:hook_require("scripts/settings/outline/outline_settings", function(instance)
    mod:update_outline_settings(instance)
end)

-- 重置所有数据（用于游戏状态变化时）
local function reset_all_data()
    -- 重置轮廓管理器数据
    outline_manager.reset_outline_data()
    
    -- 重置攻击处理器数据
    attack_handler.reset_attack_data()
    
    -- 重置单位跟踪器数据
    unit_tracker.reset_tracking_data()
    
    if ui.debug_mode then
        log.debug_output("[游戏状态] 任务开始，重置所有数据")
    end
end

-- 游戏状态变化回调函数（参考AttackOutlines模组）
function mod.on_game_state_changed(status, state_name)
    -- 当进入游戏状态时重置所有数据
    if state_name == "StateGameplay" and status == "enter" then
        reset_all_data()
        
        if ui.debug_mode then
            mod:echo("[AttackerOutlines] 任务开始，重置所有数据")
        end
    end
end

-- 导出模块接口（用于其他模块访问）
mod.get_event_index_cache_manager = function()
    return event_index_cache_manager
end

mod.get_attack_handler = function()
    return attack_handler
end

mod.get_outline_manager = function()
    return outline_manager
end

mod.get_unit_tracker = function()
    return unit_tracker
end

mod.get_log_module = function()
    return log
end

-- 导出重置函数（用于测试）
mod.reset_all_data = reset_all_data
