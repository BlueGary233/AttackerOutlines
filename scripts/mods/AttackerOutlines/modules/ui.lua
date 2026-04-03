-- UI相关功能模块
local mod = get_mod("AttackerOutlines")

-- 颜色配置表 - 定义所有颜色类型的默认值
local color_configs = {
    single_attack = {r = 255, g = 255, b = 255, display_name = "单段攻击轮廓颜色"},
    multi_attack = {r = 255, g = 255, b = 0, display_name = "多段攻击轮廓颜色"},
    special_attack = {r = 255, g = 0, b = 255, display_name = "特殊攻击轮廓颜色（不能格挡）"},
    ranged_attack = {r = 0, g = 255, b = 255, display_name = "远程攻击轮廓颜色"},
    strong_attack = {r = 255, g = 128, b = 0, display_name = "强力攻击轮廓颜色"}
}

-- 颜色变量表和映射表（动态生成）
local color_vars = {}
local color_type_mapping = {}

-- 所有配置变量
local debug_mode = mod:get("debug_mode") or false
local log_all = mod:get("log_all") or false
local outline_priority = mod:get("outline_priority") or 1
local max_queue_per_frame = mod:get("max_queue_per_frame") or 2

-- 初始化颜色变量和映射
local function init_color_vars()
    for color_type, config in pairs(color_configs) do
        -- 生成设置ID
        local r_id = "outline_color_" .. color_type .. "_r"
        local g_id = "outline_color_" .. color_type .. "_g"
        local b_id = "outline_color_" .. color_type .. "_b"
        
        -- 获取或使用默认值
        color_vars[color_type] = {
            r = mod:get(r_id) or config.r,
            g = mod:get(g_id) or config.g,
            b = mod:get(b_id) or config.b
        }
        
        -- 创建映射
        color_type_mapping[color_type] = {
            r = r_id,
            g = g_id,
            b = b_id,
            default_r = config.r,
            default_g = config.g,
            default_b = config.b
        }
    end
end

-- 更新RGB滑块显示的函数
local function update_rgb_sliders()
    local selected_type = mod:get("color_type_selector") or "single_attack"
    local mapping = color_type_mapping[selected_type]
    
    if mapping then
        -- 获取当前颜色类型的值，如果未设置则使用默认值
        local r_value = mod:get(mapping.r) or mapping.default_r
        local g_value = mod:get(mapping.g) or mapping.default_g
        local b_value = mod:get(mapping.b) or mapping.default_b
        
        -- 更新RGB滑块的值
        mod:set("outline_color_current_r", r_value, false)  -- false表示不触发on_setting_changed回调
        mod:set("outline_color_current_g", g_value, false)
        mod:set("outline_color_current_b", b_value, false)
        
        if debug_mode then
            mod:echo(string.format("[RGB滑块更新] 类型: %s, 值: R=%d, G=%d, B=%d",
                selected_type, r_value, g_value, b_value))
        end
    else
        -- 如果没有找到映射，使用第一个可用的颜色类型
        for color_type, map in pairs(color_type_mapping) do
            mapping = map
            selected_type = color_type
            break
        end
        
        if mapping then
            local r_value = mod:get(mapping.r) or mapping.default_r
            local g_value = mod:get(mapping.g) or mapping.default_g
            local b_value = mod:get(mapping.b) or mapping.default_b
            
            mod:set("outline_color_current_r", r_value, false)
            mod:set("outline_color_current_g", g_value, false)
            mod:set("outline_color_current_b", b_value, false)
            
            if debug_mode then
                mod:echo(string.format("[RGB滑块更新] 使用默认类型: %s, 值: R=%d, G=%d, B=%d",
                    selected_type, r_value, g_value, b_value))
            end
        end
    end
end

-- 更新轮廓线设置的函数
local function update_outline_settings(instance)
    -- 如果提供了instance参数，则使用它，否则获取轮廓线设置实例
    local outline_settings = instance or require("scripts/settings/outline/outline_settings")
    
    -- 确保MinionOutlineExtension存在
    outline_settings.MinionOutlineExtension = outline_settings.MinionOutlineExtension or {}
    
    -- 辅助函数：创建轮廓设置
    local function create_outline_setting(color_r, color_g, color_b)
        return {
            priority = outline_priority or 1,  -- 使用用户设置的优先级，默认为1
            material_layers = {
                "minion_outline",
                "minion_outline_reversed_depth",
            },
            color = {
                (color_r or 100) / 100,  -- 似乎轮廓线的颜色亮度可以突破1，所以/100让轮廓线更亮。
                (color_g or 0) / 100,
                (color_b or 0) / 100,
            },
            visibility_check = function (unit)
                -- 使用固定的_minion_alive_check
                if not HEALTH_ALIVE[unit] then
                    return false
                end
                return true
            end,
        }
    end
    
-- 为所有颜色类型创建轮廓设置
    outline_settings.MinionOutlineExtension.attacker_outline_single_attack = create_outline_setting(
        color_vars.single_attack.r, color_vars.single_attack.g, color_vars.single_attack.b
    )
    outline_settings.MinionOutlineExtension.attacker_outline_multi_attack = create_outline_setting(
        color_vars.multi_attack.r, color_vars.multi_attack.g, color_vars.multi_attack.b
    )
    outline_settings.MinionOutlineExtension.attacker_outline_special_attack = create_outline_setting(
        color_vars.special_attack.r, color_vars.special_attack.g, color_vars.special_attack.b
    )
    outline_settings.MinionOutlineExtension.attacker_outline_ranged_attack = create_outline_setting(
        color_vars.ranged_attack.r, color_vars.ranged_attack.g, color_vars.ranged_attack.b
    )
    outline_settings.MinionOutlineExtension.attacker_outline_strong_attack = create_outline_setting(
        color_vars.strong_attack.r, color_vars.strong_attack.g, color_vars.strong_attack.b
    )
end

-- 设置变更处理函数
local function on_setting_changed(id)
    if id == "debug_mode" then
        debug_mode = mod:get(id)
        if debug_mode then
            mod:echo("[配置更新] debug_mode: 启用")
            print("[AttackerOutlines] debug_mode: 启用")
        end
    elseif id == "log_all" then
        log_all = mod:get(id)
        if debug_mode then
            if log_all then
                mod:echo("[配置更新] log_all: 启用")
                print("[AttackerOutlines] log_all: 启用")
            else
                mod:echo("[配置更新] log_all: 禁用")
                print("[AttackerOutlines] log_all: 禁用")
            end
        end
    elseif id == "outline_priority" then
        outline_priority = mod:get(id)
        update_outline_settings()
        if debug_mode then
            mod:echo(string.format("[配置更新] 轮廓优先级: %d", outline_priority))
            print(string.format("[AttackerOutlines] 轮廓优先级: %d", outline_priority))
        end
    elseif id == "max_queue_per_frame" then
        max_queue_per_frame = mod:get(id) or 2
        if debug_mode then
            mod:echo(string.format("[配置更新] 每帧最大队列数: %d", max_queue_per_frame))
            print(string.format("[AttackerOutlines] 每帧最大队列数: %d", max_queue_per_frame))
        end
    elseif id == "dodge_window" then
        if debug_mode then
            local dodge_window_value = mod:get(id) or 0.5
            mod:echo(string.format("[配置更新] 闪避窗口: %.2f", dodge_window_value))
            print(string.format("[AttackerOutlines] 闪避窗口: %.2f", dodge_window_value))
        end
    -- 处理颜色选择器和RGB滑块交互
    elseif id == "color_type_selector" then
        -- 当颜色选择器改变时，更新RGB滑块的值
        update_rgb_sliders()
        
        if debug_mode then
            local selected_type = mod:get(id)
            mod:echo(string.format("[颜色选择器] 切换到: %s", selected_type))
        end
    elseif id == "outline_color_current_r" or id == "outline_color_current_g" or id == "outline_color_current_b" then
        -- 当RGB滑块改变时，需要保存到对应的颜色变量
        local selected_type = mod:get("color_type_selector") or "single_attack"
        local mapping = color_type_mapping[selected_type]
        if mapping then
            local r_id = mapping.r
            local g_id = mapping.g
            local b_id = mapping.b
            
            -- 获取当前RGB滑块的值
            local current_r = mod:get("outline_color_current_r")
            local current_g = mod:get("outline_color_current_g")
            local current_b = mod:get("outline_color_current_b")
            
            -- 保存到对应的颜色变量
            mod:set(r_id, current_r)
            mod:set(g_id, current_g)
            mod:set(b_id, current_b)
            
            -- 更新color_vars表中的值
            if color_vars[selected_type] then
                color_vars[selected_type].r = current_r
                color_vars[selected_type].g = current_g
                color_vars[selected_type].b = current_b
            end
            
            -- 更新轮廓设置
            update_outline_settings()
            
            if debug_mode then
                mod:echo(string.format("[RGB滑块] 更新 %s 颜色: R=%d, G=%d, B=%d", 
                    selected_type, current_r, current_g, current_b))
            end
        end
    else
        -- 通用处理：检查是否为颜色变量
        for color_type, mapping in pairs(color_type_mapping) do
            if id == mapping.r or id == mapping.g or id == mapping.b then
                -- 更新color_vars表中的值
                if color_vars[color_type] then
                    if id == mapping.r then
                        color_vars[color_type].r = mod:get(id)
                    elseif id == mapping.g then
                        color_vars[color_type].g = mod:get(id)
                    elseif id == mapping.b then
                        color_vars[color_type].b = mod:get(id)
                    end
                end
                
                -- 更新轮廓设置
                update_outline_settings()
                break
            end
        end
    end
end

-- 初始化
init_color_vars()

-- 导出模块接口
return {
    color_configs = color_configs,
    color_vars = color_vars,
    color_type_mapping = color_type_mapping,
    debug_mode = debug_mode,
    log_all = log_all,
    outline_priority = outline_priority,
    max_queue_per_frame = max_queue_per_frame,
    update_rgb_sliders = update_rgb_sliders,
    update_outline_settings = update_outline_settings,
    on_setting_changed = on_setting_changed,
    init_color_vars = init_color_vars
}
