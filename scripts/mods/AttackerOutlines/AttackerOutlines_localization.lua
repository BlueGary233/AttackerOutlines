return {
    mod_name = {
        en = "Attacker Outlines",
        ["zh-cn"] = "攻击者轮廓",
    },
    mod_description = {
        en = "Records target change information to log file when enemies change targets. Debug mode must be enabled for logging.",
        ["zh-cn"] = "当敌人改变目标时，将目标变化信息记录到日志文件中。需要启用调试模式才能记录日志。",
    },
    debug_mode = {
        en = "Debug Mode",
        ["zh-cn"] = "调试模式",
    },
    debug_mode_description = {
        en = "When enabled, show debug information",
        ["zh-cn"] = "启用时，显示调试信息",
    },
    outline_priority = {
        en = "Outline Priority",
        ["zh-cn"] = "轮廓优先级",
    },
    outline_priority_description = {
        en = "Priority level for outline rendering (higher values render on top)",
        ["zh-cn"] = "轮廓渲染的优先级（值越高越在上层渲染）",
    },
    max_queue_per_frame = {
        en = "Max Queue Per Frame",
        ["zh-cn"] = "每帧最大队列数",
    },
    max_queue_per_frame_description = {
        en = "Maximum number of outline requests to process per frame",
        ["zh-cn"] = "每帧处理的最大轮廓请求数量",
    },
    color_type_selector = {
        en = "Color Type Selector",
        ["zh-cn"] = "颜色类型选择器",
    },
    color_type_selector_description = {
        en = "Select which color type to edit",
        ["zh-cn"] = "选择要编辑的颜色类型",
    },
    outline_color_current_r = {
        en = "Current Color Red",
        ["zh-cn"] = "当前颜色红色",
    },
    outline_color_current_r_description = {
        en = "Red component of current color (0-255)",
        ["zh-cn"] = "当前颜色的红色分量（0-255）",
    },
    outline_color_current_g = {
        en = "Current Color Green",
        ["zh-cn"] = "当前颜色绿色",
    },
    outline_color_current_g_description = {
        en = "Green component of current color (0-255)",
        ["zh-cn"] = "当前颜色的绿色分量（0-255）",
    },
    outline_color_current_b = {
        en = "Current Color Blue",
        ["zh-cn"] = "当前颜色蓝色",
    },
    outline_color_current_b_description = {
        en = "Blue component of current color (0-255)",
        ["zh-cn"] = "当前颜色的蓝色分量（0-255）",
    },
    dodge_window = {
        en = "Dodge Window",
        ["zh-cn"] = "闪避窗口",
    },
    dodge_window_description = {
        en = "Time window before attack timing to add outline (0.3-1.0 seconds)",
        ["zh-cn"] = "攻击时机前添加轮廓的时间窗口（0.3-1.0秒）",
    },
    log_all = {
        en = "Log All Events",
        ["zh-cn"] = "记录所有事件",
    },
    log_all_description = {
        en = "When enabled, logs all events to log files even when debug mode is disabled",
        ["zh-cn"] = "启用时，即使调试模式禁用，也会将所有事件记录到日志文件中",
    },
    collect_event_indices_enabled = {
        en = "Collect Event Indices",
        ["zh-cn"] = "收集事件索引",
    },
    collect_event_indices_enabled_description = {
        en = "When enabled, collects event indices for all enemy animations",
        ["zh-cn"] = "启用时，收集所有敌人动画的事件索引",
    },
    -- 单段攻击颜色本地化
    outline_color_single_attack_r = {
        en = "Single Attack Color Red",
        ["zh-cn"] = "单段攻击轮廓红色",
    },
    outline_color_single_attack_r_description = {
        en = "Red component of single attack outline color (0-255)",
        ["zh-cn"] = "单段攻击轮廓颜色的红色分量（0-255）",
    },
    outline_color_single_attack_g = {
        en = "Single Attack Color Green",
        ["zh-cn"] = "单段攻击轮廓绿色",
    },
    outline_color_single_attack_g_description = {
        en = "Green component of single attack outline color (0-255)",
        ["zh-cn"] = "单段攻击轮廓颜色的绿色分量（0-255）",
    },
    outline_color_single_attack_b = {
        en = "Single Attack Color Blue",
        ["zh-cn"] = "单段攻击轮廓蓝色",
    },
    outline_color_single_attack_b_description = {
        en = "Blue component of single attack outline color (0-255)",
        ["zh-cn"] = "单段攻击轮廓颜色的蓝色分量（0-255）",
    },
    -- 多段攻击颜色本地化
    outline_color_multi_attack_r = {
        en = "Multi Attack Color Red",
        ["zh-cn"] = "多段攻击轮廓红色",
    },
    outline_color_multi_attack_r_description = {
        en = "Red component of multi attack outline color (0-255)",
        ["zh-cn"] = "多段攻击轮廓颜色的红色分量（0-255）",
    },
    outline_color_multi_attack_g = {
        en = "Multi Attack Color Green",
        ["zh-cn"] = "多段攻击轮廓绿色",
    },
    outline_color_multi_attack_g_description = {
        en = "Green component of multi attack outline color (0-255)",
        ["zh-cn"] = "多段攻击轮廓颜色的绿色分量（0-255）",
    },
    outline_color_multi_attack_b = {
        en = "Multi Attack Color Blue",
        ["zh-cn"] = "多段攻击轮廓蓝色",
    },
    outline_color_multi_attack_b_description = {
        en = "Blue component of multi attack outline color (0-255)",
        ["zh-cn"] = "多段攻击轮廓颜色的蓝色分量（0-255）",
    },
    -- 特殊攻击颜色本地化
    outline_color_special_attack_r = {
        en = "Special Attack Color Red",
        ["zh-cn"] = "特殊攻击轮廓红色",
    },
    outline_color_special_attack_r_description = {
        en = "Red component of special attack outline color (0-255)",
        ["zh-cn"] = "特殊攻击轮廓颜色的红色分量（0-255）",
    },
    outline_color_special_attack_g = {
        en = "Special Attack Color Green",
        ["zh-cn"] = "特殊攻击轮廓绿色",
    },
    outline_color_special_attack_g_description = {
        en = "Green component of special attack outline color (0-255)",
        ["zh-cn"] = "特殊攻击轮廓颜色的绿色分量（0-255）",
    },
    outline_color_special_attack_b = {
        en = "Special Attack Color Blue",
        ["zh-cn"] = "特殊攻击轮廓蓝色",
    },
    outline_color_special_attack_b_description = {
        en = "Blue component of special attack outline color (0-255)",
        ["zh-cn"] = "特殊攻击轮廓颜色的蓝色分量（0-255）",
    },
    -- 远程攻击颜色本地化
    outline_color_ranged_attack_r = {
        en = "Ranged Attack Color Red",
        ["zh-cn"] = "远程攻击轮廓红色",
    },
    outline_color_ranged_attack_r_description = {
        en = "Red component of ranged attack outline color (0-255)",
        ["zh-cn"] = "远程攻击轮廓颜色的红色分量（0-255）",
    },
    outline_color_ranged_attack_g = {
        en = "Ranged Attack Color Green",
        ["zh-cn"] = "远程攻击轮廓绿色",
    },
    outline_color_ranged_attack_g_description = {
        en = "Green component of ranged attack outline color (0-255)",
        ["zh-cn"] = "远程攻击轮廓颜色的绿色分量（0-255）",
    },
    outline_color_ranged_attack_b = {
        en = "Ranged Attack Color Blue",
        ["zh-cn"] = "远程攻击轮廓蓝色",
    },
    outline_color_ranged_attack_b_description = {
        en = "Blue component of ranged attack outline color (0-255)",
        ["zh-cn"] = "远程攻击轮廓颜色的蓝色分量（0-255）",
    },
    -- 强力攻击颜色本地化
    outline_color_strong_attack_r = {
        en = "Strong Attack Color Red",
        ["zh-cn"] = "强力攻击轮廓红色",
    },
    outline_color_strong_attack_r_description = {
        en = "Red component of strong attack outline color (0-255)",
        ["zh-cn"] = "强力攻击轮廓颜色的红色分量（0-255）",
    },
    outline_color_strong_attack_g = {
        en = "Strong Attack Color Green",
        ["zh-cn"] = "强力攻击轮廓绿色",
    },
    outline_color_strong_attack_g_description = {
        en = "Green component of strong attack outline color (0-255)",
        ["zh-cn"] = "强力攻击轮廓颜色的绿色分量（0-255）",
    },
    outline_color_strong_attack_b = {
        en = "Strong Attack Color Blue",
        ["zh-cn"] = "强力攻击轮廓蓝色",
    },
    outline_color_strong_attack_b_description = {
        en = "Blue component of strong attack outline color (0-255)",
        ["zh-cn"] = "强力攻击轮廓颜色的蓝色分量（0-255）",
    },
    -- 颜色类型选择器选项本地化
    single_attack = {
        en = "Single Attack",
        ["zh-cn"] = "单段攻击",
    },
    multi_attack = {
        en = "Multi Attack",
        ["zh-cn"] = "多段攻击",
    },
    special_attack = {
        en = "Special Attack",
        ["zh-cn"] = "特殊攻击",
    },
    ranged_attack = {
        en = "Ranged Attack",
        ["zh-cn"] = "远程攻击",
    },
    strong_attack = {
        en = "Strong Attack",
        ["zh-cn"] = "强力攻击",
    },
}
