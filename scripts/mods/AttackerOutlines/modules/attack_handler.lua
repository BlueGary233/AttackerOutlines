-- 攻击处理模块
local mod = get_mod("AttackerOutlines")

-- 导入其他模块
local ui = mod:io_dofile("AttackerOutlines/scripts/mods/AttackerOutlines/modules/ui")
local damage_timings = mod:io_dofile("AttackerOutlines/scripts/mods/AttackerOutlines/modules/damage_timings")
local log = mod:io_dofile("AttackerOutlines/scripts/mods/AttackerOutlines/modules/log")

-- 远程结束动作列表
local RANGED_END_ACTIONS = {"out_of_aim", "shoot_finished"}

-- 攻击数据结构
local pending_attacks = {}     -- 待处理的攻击：{unit = {[attack_id] = {start_time, timings, colors, current_index}}}

-- 基础单位函数
local function get_breed_name(unit)
    local unit_data_ext = ScriptUnit.has_extension(unit, "unit_data_system")
    if unit_data_ext then
        local breed = unit_data_ext._breed
        if breed then
            local breed_name = breed.name or "unknown"
            return breed_name
        end
    end
end

local function is_player(unit)
    local player = Managers.player:local_player(1)
    if not player then return false end
    local player_unit = player and player.player_unit
    return unit == player_unit
end

local function is_enemy(unit)
    local breed_name = get_breed_name(unit)
    if not breed_name then return false end
    if breed_name == "companion_dog" or
        breed_name == "human" or
        breed_name == "ogryn" or
        breed_name == "sand_vortex" or
        breed_name == "nurgle_flies" or
        breed_name == "attack_valkyrie"
    then return false
    else
        return true
    end
end

-- 目标获取函数
local function get_enemy_target(unit)
    -- 检查必要的管理器
    local unit_spawner_manager = Managers.state.unit_spawner
    if not unit_spawner_manager then
        return nil
    end
    
    -- 获取game_object_id
    local game_object_id = unit_spawner_manager:game_object_id(unit)
    if not game_object_id then
        return nil
    end
    
    -- 获取game_session管理器
    local game_session_manager = Managers.state.game_session
    if not game_session_manager then
        return nil
    end
    
    -- 获取实际的game_session对象
    local game_session = game_session_manager:game_session()
    if not game_session then
        return nil
    end
    
    -- 读取target_unit_id
    local target_unit_id = GameSession.game_object_field(game_session, game_object_id, "target_unit_id")
    
    -- 检查是否是有效的target
    if target_unit_id and target_unit_id ~= NetworkConstants.invalid_game_object_id then
        return unit_spawner_manager:unit(target_unit_id)
    end
    
    return nil
end

-- 获取攻击时机数据的函数
local function get_attack_timing(breed_name, anim_event_name)
    if not breed_name or not anim_event_name then
        return nil
    end
    
    local breed_data = damage_timings[breed_name]
    if not breed_data then
        return nil
    end
    
    return breed_data[anim_event_name]
end

-- 判断是否为攻击动画
local function is_attack_animation(anim_event_name)
    if not anim_event_name then
        return false
    end
    
    -- 检查是否是攻击相关的动画
    if anim_event_name:find("aim") or
       anim_event_name:find("fire") or
       anim_event_name:find("throw") or
       anim_event_name:find("heavy") or
       anim_event_name:find("force") or
       anim_event_name:find("push") or
       anim_event_name:find("attack") or
       anim_event_name:find("melee") or
       anim_event_name:find("shoot") or
       anim_event_name:find("ranged") or
       anim_event_name:find("special") or
       anim_event_name:find("charge") or
       anim_event_name:find("swing") or
       anim_event_name:find("hit") or
       anim_event_name:find("combo") then
        return true
    end
    
    return false
end

-- 从damage_timings表获取攻击类型信息
local function get_attack_type_info(breed_name, anim_event_name)
    if not breed_name or not anim_event_name then
        return nil
    end
    
    local breed_data = damage_timings[breed_name]
    if not breed_data then
        return nil
    end
    
    -- 检查是否有_attack_types字段
    if breed_data._attack_types then
        for attack_type, attack_list in pairs(breed_data._attack_types) do
            for _, attack_name in ipairs(attack_list) do
                if anim_event_name:find(attack_name) then
                    return attack_type
                end
            end
        end
    end
    
    return nil
end

-- 判断是否为特殊攻击（不能格挡）
local function is_special_attack(breed_name, anim_event_name)
    if not breed_name or not anim_event_name then
        return false
    end
    
    -- 首先检查damage_timings表中的_attack_types
    local attack_type = get_attack_type_info(breed_name, anim_event_name)
    if attack_type == "special_attacks" then
        return true
    end
    
    -- 后备：特殊攻击列表
    local special_attacks = {
        "attack_grab_start",      -- 小蛋糕吃人
        "attack_lunge",           -- 自爆飞扑
        "attack_grab",            -- 混沌卵抓取
        "attack_grab_player",     -- 混沌卵抓取
        "attack_grab_player_ogryn", -- 混沌卵抓取
        "force_shield_knockback", -- 连长盾击退
        "attack_vomit_start"      -- 小蛋糕呕吐
    }
    
    for _, special_attack in ipairs(special_attacks) do
        if anim_event_name:find(special_attack) then
            return true
        end
    end
    
    return false
end

-- 判断是否为强力攻击
local function is_strong_attack(breed_name, anim_event_name)
    if not breed_name or not anim_event_name then
        return false
    end
    
    -- 检查damage_timings表中的_attack_types
    local attack_type = get_attack_type_info(breed_name, anim_event_name)
    return attack_type == "strong_attacks"
end

-- 判断是否为远程攻击
local function is_ranged_attack(breed_name, anim_event_name)
    if not breed_name or not anim_event_name then
        return false
    end
    
    -- 检查damage_timings表中的_attack_types
    local attack_type = get_attack_type_info(breed_name, anim_event_name)
    return attack_type == "shoot_actions"
end

-- 判断是否为远程结束动作
local function is_ranged_end_action(anim_event_name)
    if not anim_event_name then
        return false
    end
    
    for _, end_action in ipairs(RANGED_END_ACTIONS) do
        if anim_event_name:find(end_action) then
            return true
        end
    end
    
    return false
end


-- 处理普通攻击动画的函数（依赖damage_timing表）
local function handle_normal_attack_animation(unit, anim_event_name, add_outline_func, remove_outline_func)
    -- 检查单位是否是敌人
    if not is_enemy(unit) then
        return
    end
    
    -- 检查是否是攻击动画（排除远程攻击，因为远程攻击已经单独处理）
    if not is_attack_animation(anim_event_name) then
        return
    end
    
    -- 获取breed_name
    local breed_name = get_breed_name(unit)
    if not breed_name then
        return
    end
    
    -- 获取攻击时机数据
    local attack_timing_data = get_attack_timing(breed_name, anim_event_name)
    if not attack_timing_data then
        if ui.debug_mode then
            log.debug_output(string.format("[攻击检测] 单位: %s, Breed: %s, 动画: %s - 无攻击时机数据", 
                tostring(unit), breed_name, anim_event_name))
        end
        return
    end
    
    -- 检查敌人的目标是否是玩家
    local target_unit = get_enemy_target(unit)
    if not target_unit or not is_player(target_unit) then
        if ui.debug_mode then
            log.debug_output(string.format("[攻击检测] 单位: %s, Breed: %s, 动画: %s - 目标不是玩家", 
                tostring(unit), breed_name, anim_event_name))
        end
        return
    end
    
    -- 获取dodge_window配置
    local dodge_window = mod:get("dodge_window") or 0.5
    
    -- 准备攻击数据
    local timings = {}
    local colors = {}
    
    -- 提取时机和颜色数据
    local function extract_timings(data, is_single)
        -- 确定颜色类型
        local color_type = "attacker_outline_multi_attack"  -- 默认多段攻击颜色
        
        -- 检查攻击类型
        if is_special_attack(breed_name, anim_event_name) then
            color_type = "attacker_outline_special_attack"  -- 特殊攻击颜色
        elseif is_strong_attack(breed_name, anim_event_name) then
            color_type = "attacker_outline_strong_attack"   -- 强力攻击颜色
        elseif is_single then
            color_type = "attacker_outline_single_attack"   -- 单段攻击颜色
        end
        
        if type(data) == "table" then
            -- 检查是否是嵌套数组（多组攻击）
            if type(data[1]) == "table" then
                -- 多组攻击
                for _, group in ipairs(data) do
                    if type(group) == "table" then
                        for _, timing in ipairs(group) do
                            if type(timing) == "number" then
                                table.insert(timings, timing)
                                table.insert(colors, color_type)
                            end
                        end
                    elseif type(group) == "number" then
                        table.insert(timings, group)
                        table.insert(colors, color_type)
                    end
                end
            else
                -- 多段攻击
                for _, timing in ipairs(data) do
                    if type(timing) == "number" then
                        table.insert(timings, timing)
                        table.insert(colors, color_type)
                    end
                end
            end
        else
            -- 单段攻击
            table.insert(timings, data)
            table.insert(colors, color_type)
        end
    end
    
    extract_timings(attack_timing_data, type(attack_timing_data) ~= "table")
    
    -- 如果没有时机数据，返回
    if #timings == 0 then
        return
    end
    
    -- 生成唯一的攻击ID
    local current_time = Managers.time and Managers.time:time("main") or 0
    local attack_id = tostring(unit) .. "_" .. anim_event_name .. "_" .. tostring(current_time)
    
    -- 创建攻击数据
    local attack_data = {
        start_time = current_time,
        timings = timings,
        colors = colors,
        dodge_window = dodge_window,
        current_index = 1,
        added = {},
        removed = {}
    }
    
    -- 初始化添加和移除状态
    for i = 1, #timings do
        attack_data.added[i] = false
        attack_data.removed[i] = false
    end
    
    -- 添加到待处理攻击列表
    if not pending_attacks[unit] then
        pending_attacks[unit] = {}
    end
    pending_attacks[unit][attack_id] = attack_data
    
    -- 调试输出
    if ui.debug_mode then
        local attack_type = #timings == 1 and "单段攻击" or "多段攻击"
        if type(attack_timing_data) == "table" and type(attack_timing_data[1]) == "table" then
            attack_type = "多组攻击"
        end
        
        log.debug_output(string.format("[攻击检测成功] 单位: %s, Breed: %s, 动画: %s, 类型: %s, 时机数: %d", 
            tostring(unit), breed_name, anim_event_name, attack_type, #timings))
        
        for i, timing in ipairs(timings) do
            local add_time = timing - dodge_window
            if add_time < 0 then add_time = 0 end
            log.debug_output(string.format("  时机 %d: 总时间 %.2f秒, 添加延迟 %.2f秒, 颜色: %s", 
                i, timing, add_time, colors[i]))
        end
    end
end

-- 处理攻击动画的函数（统一入口）
local function handle_attack_animation(unit, anim_event_name, add_outline_func, remove_outline_func, unit_animation_states)
    -- 获取单位当前的动画状态
    local anim_state = unit_animation_states[unit] or {}
    local last_anim_event = anim_state.last_anim_event
    
    -- 获取breed_name
    local breed_name = get_breed_name(unit)
    
    -- 检查动画是否改变
    if last_anim_event and last_anim_event ~= anim_event_name then
        -- 动画改变了，检查是否需要移除远程攻击轮廓线
        if anim_state.has_ranged_outline then
            -- 之前有远程攻击轮廓线，检查新动画是否还是远程攻击
            local was_ranged = is_ranged_attack(breed_name, last_anim_event)
            local is_ranged = is_ranged_attack(breed_name, anim_event_name)
            
            if was_ranged and not is_ranged then
                -- 之前是远程攻击，现在不是了，移除远程攻击轮廓线
                remove_outline_func(unit, "attacker_outline_ranged_attack")
                
                -- 更新状态
                anim_state.has_ranged_outline = false
                
                if ui.debug_mode then
                    log.debug_output(string.format("[动画改变] 单位: %s, 旧动画: %s, 新动画: %s - 移除远程攻击轮廓线", 
                        tostring(unit), last_anim_event, anim_event_name))
                end
            end
        end
        
        -- 检查是否需要移除特殊攻击轮廓线（timing为-1的攻击）
        if anim_state.has_special_outline then
            -- 之前有特殊攻击轮廓线，检查新动画是否还是特殊攻击
            local was_special = is_special_attack(breed_name, last_anim_event)
            local is_special = is_special_attack(breed_name, anim_event_name)
            
            if was_special and not is_special then
                -- 之前是特殊攻击，现在不是了，移除特殊攻击轮廓线
                remove_outline_func(unit, "attacker_outline_special_attack")
                
                -- 更新状态
                anim_state.has_special_outline = false
                
                if ui.debug_mode then
                    log.debug_output(string.format("[动画改变] 单位: %s, 旧动画: %s, 新动画: %s - 移除特殊攻击轮廓线", 
                        tostring(unit), last_anim_event, anim_event_name))
                end
            end
        end
    end
    
    -- 检查是否是远程攻击
    local is_ranged = is_ranged_attack(breed_name, anim_event_name)
    local is_ranged_end = is_ranged_end_action(anim_event_name)
    
    -- 处理远程攻击
    if is_ranged then
        -- 检查单位是否是敌人
        if is_enemy(unit) then
            -- 检查敌人的目标是否是玩家
            local target_unit = get_enemy_target(unit)
            if target_unit and is_player(target_unit) then
                -- 添加远程攻击轮廓线
                add_outline_func(unit, "attacker_outline_ranged_attack")
                
                -- 更新状态
                anim_state.has_ranged_outline = true
                
                if ui.debug_mode then
                    log.debug_output(string.format("[远程攻击检测成功] 单位: %s, Breed: %s, 动画: %s - 添加远程攻击轮廓线", 
                        tostring(unit), breed_name or "unknown", anim_event_name))
                end
            end
        end
    elseif is_ranged_end and anim_state.has_ranged_outline then
        -- 远程结束动作，移除远程攻击轮廓线
        remove_outline_func(unit, "attacker_outline_ranged_attack")
        
        -- 更新状态
        anim_state.has_ranged_outline = false
        
        if ui.debug_mode then
            log.debug_output(string.format("[远程结束动作] 单位: %s, 动画: %s - 移除远程攻击轮廓线", 
                tostring(unit), anim_event_name))
        end
    end
    
    -- 检查是否是特殊攻击（timing为-1的攻击）
    local is_special = is_special_attack(breed_name, anim_event_name)
    if is_special then
        -- 检查单位是否是敌人
        if is_enemy(unit) then
            -- 检查敌人的目标是否是玩家
            local target_unit = get_enemy_target(unit)
            if target_unit and is_player(target_unit) then
                -- 特殊攻击的轮廓线会在handle_normal_attack_animation中通过process_pending_attacks添加
                -- 这里只设置状态标志
                anim_state.has_special_outline = true
                
                if ui.debug_mode then
                    log.debug_output(string.format("[特殊攻击检测] 单位: %s, Breed: %s, 动画: %s - 标记为特殊攻击", 
                        tostring(unit), breed_name or "unknown", anim_event_name))
                end
            end
        end
    end
    
    -- 更新动画状态
    unit_animation_states[unit] = anim_state
    unit_animation_states[unit].last_anim_event = anim_event_name
    
    -- 处理普通攻击（依赖damage_timing表）
    handle_normal_attack_animation(unit, anim_event_name, add_outline_func, remove_outline_func)
end

-- 处理待处理攻击的函数
local function process_pending_attacks(add_outline_func, remove_outline_func)
    local current_time = Managers.time and Managers.time:time("main") or 0
    
    for unit, attacks in pairs(pending_attacks) do
        -- 检查单位是否存活
        if not HEALTH_ALIVE[unit] then
            -- 单位已死亡，清理所有攻击
            pending_attacks[unit] = nil
            if ui.debug_mode then
                log.debug_output(string.format("[攻击清理] 单位已死亡: %s", tostring(unit)))
            end
        else
            -- 处理每个攻击
            local to_remove = {}
            for attack_id, attack_data in pairs(attacks) do
                local start_time = attack_data.start_time
                local timings = attack_data.timings
                local colors = attack_data.colors
                local current_index = attack_data.current_index or 1
                local dodge_window = attack_data.dodge_window
                
                -- 检查是否还有更多时机需要处理
                if current_index <= #timings then
                    local timing = timings[current_index]
                    local color = colors[current_index]
                    local elapsed_time = current_time - start_time
                    
                    -- 检查是否应该添加轮廓线
                    local add_time = timing - dodge_window
                    if add_time < 0 then add_time = 0 end
                    
                    if elapsed_time >= add_time and not attack_data.added[current_index] then
                        -- 添加轮廓线
                        add_outline_func(unit, color)
                        attack_data.added[current_index] = true
                        
                        if ui.debug_mode then
                            log.debug_output(string.format("[添加轮廓线] 单位: %s, 颜色: %s, 时机: %.2f秒", 
                                tostring(unit), color, timing))
                        end
                    end
                    
                    -- 检查是否应该移除轮廓线
                    -- 特殊处理：如果timing等于-1，表示在整个动画期间持续显示轮廓线，不自动移除
                    if timing ~= -1 and elapsed_time >= timing and not attack_data.removed[current_index] then
                        -- 移除轮廓线
                        remove_outline_func(unit, color)
                        attack_data.removed[current_index] = true
                        
                        if ui.debug_mode then
                            log.debug_output(string.format("[移除轮廓线] 单位: %s, 颜色: %s, 总时间: %.2f秒", 
                                tostring(unit), color, timing))
                        end
                        
                        -- 移动到下一个时机
                        attack_data.current_index = current_index + 1
                    end
                else
                    -- 所有时机都已处理完毕，标记为待移除
                    table.insert(to_remove, attack_id)
                end
            end
            
            -- 移除已完成的攻击
            for _, attack_id in ipairs(to_remove) do
                attacks[attack_id] = nil
            end
            
            if next(attacks) == nil then
                pending_attacks[unit] = nil
            end
        end
    end
end

-- 重置攻击数据（用于游戏状态变化时）
local function reset_attack_data()
    -- 清空所有待处理攻击
    pending_attacks = {}
    
    if ui.debug_mode then
        log.debug_output("[重置] 攻击数据已重置")
    end
end

-- 导出模块接口
return {
    pending_attacks = pending_attacks,
    get_breed_name = get_breed_name,
    is_player = is_player,
    is_enemy = is_enemy,
    get_enemy_target = get_enemy_target,
    is_attack_animation = is_attack_animation,
    is_special_attack = is_special_attack,
    is_ranged_attack = is_ranged_attack,
    handle_normal_attack_animation = handle_normal_attack_animation,
    handle_attack_animation = handle_attack_animation,
    process_pending_attacks = process_pending_attacks,
    reset_attack_data = reset_attack_data
}
