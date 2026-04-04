local mod = get_mod("AttackerOutlines")

return {
    name = mod:localize("mod_name"),
    description = mod:localize("mod_description"),
    is_togglable = true,
    options = {
        widgets = {
            {
                setting_id = "debug_mode",
                type = "checkbox",
                default_value = false,
            },
            {
                setting_id = "outline_priority",
                type = "numeric",
                default_value = 1,
                range = {1, 10},
            },
            {
                setting_id = "max_queue_per_frame",
                type = "numeric",
                default_value = 2,
                range = {1, 10},
            },
            {
                setting_id = "dodge_window",
                type = "numeric",
                default_value = 0.5,
                range = {0.3, 1.0},
                decimals_number = 2,
            },
            {
                setting_id = "log_all",
                type = "checkbox",
                default_value = false,
            },
            {
                setting_id = "color_type_selector",
                type = "dropdown",
                default_value = "single_attack",
                options = {
                    {text = "single_attack", value = "single_attack"},
                    {text = "multi_attack", value = "multi_attack"},
                    {text = "special_attack", value = "special_attack"},
                    {text = "ranged_attack", value = "ranged_attack"},
                    {text = "strong_attack", value = "strong_attack"}
                },
            },
            {
                setting_id = "outline_color_current_r",
                type = "numeric",
                default_value = 255,
                range = {0, 255},
            },
            {
                setting_id = "outline_color_current_g",
                type = "numeric",
                default_value = 0,
                range = {0, 255},
            },
            {
                setting_id = "outline_color_current_b",
                type = "numeric",
                default_value = 0,
                range = {0, 255},
            },
            {
                setting_id = "collect_event_indices_enabled",
                type = "checkbox",
                default_value = false,
            },
        }
    }
}
