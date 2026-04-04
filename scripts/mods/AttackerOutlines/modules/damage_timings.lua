-- Darktide 攻击时机表格（完整版）
-- 包含所有attack_anim_damage_timings和aim_duration
-- 远程结束动作："out_of_aim","shoot_finished"
local ATTACK_TIMING_TABLE = {

    -- 两种牛牛
    cultist_mutant_mutator = {
        charge_grab_prep = -1,
        _attack_types = {
            special_attacks = {"charge_grab_prep"}
        }
    },

    cultist_mutant = {
        charge_grab_prep = -1,
        _attack_types = {
            special_attacks = {"charge_grab_prep"}
        }
    },

    -- 网子姐
    renegade_netgunner = {
        aim_loop = -1,
        shoot_net = -1,
        _attack_types = {
            special_attacks = {"shoot_net", "aim_loop"}
        }
    },
    -- 三种狗
    chaos_hound_mutator = {
        attack_leap_start = 0.6666666666666666,
        attack_leap_short = 0.8,
        _attack_types = {
            special_attacks = {"attack_leap_start", "attack_leap_short"}
        }
    },
    chaos_hound = {
        attack_leap_start = 0.6666666666666666,
        attack_leap_short = 0.8,
        _attack_types = {
            special_attacks = {"attack_leap_start", "attack_leap_short"}
        }
    },
    chaos_armored_hound = {
        attack_leap_start = 0.6666666666666666,
        attack_leap_short = 0.8,
        _attack_types = {
            special_attacks = {"attack_leap_start", "attack_leap_short"}
        }
    },

    -- chaos_armored_infected
    chaos_armored_infected = {
        attack_01 = 1.2873563218390804,
        attack_02 = 1.264367816091954,
        attack_03 = 1.1954022988505748,
        attack_04 = 0.7654320987654321,
        attack_05 = 0.8148148148148148,
        attack_06 = 0.7126436781609196,
        attack_07 = 0.7,
        attack_down_01 = 1.3333333333333333,
        attack_move_01 = 0.8444444444444444,
        attack_move_02 = 1.0,
        attack_move_03 = 1.0,
        attack_move_04 = 0.9555555555555556,
        attack_reach_up = 1.1794871794871795,
        attack_run_02 = 1.3055555555555556,
        attack_run_03 = 1.25,
    },

    -- chaos_beast_of_nurgle
    chaos_beast_of_nurgle = {
        attack_body_slam = 0.9,
        attack_slam_left = 0.8787878787878788,
        attack_slam_right = 0.9696969696969697,
        attack_sneeze = 0.7333333333333333,
        attack_tail_slam = 0.8181818181818182,
        attack_vomit_start = -1,
        attack_grab_start = 0.43333333333333335,
        attack_tail_whip_right = 1.1388888888888888, -- 小蛋糕甩尾
        attack_tail_whip_left = 1.0277777777777777,
        _attack_types = {
            special_attacks = {"attack_grab_start"}
        }
    },

    -- chaos_daemonhost
    chaos_daemonhost = {
        attack_01 = 1.264367816091954,
        attack_02 = 1.264367816091954,
        attack_03 = 1.1954022988505748,
        attack_04 = 0.6,
        attack_05 = 0.6,
        attack_06 = 0.6,
        attack_07 = 0.6,
        attack_combo = {1.0952380952380953, 2.4523809523809526},
        attack_combo_2 = {0.6904761904761905, 1.5},
        attack_combo_3 = {0.4, 0.8666666666666667, 1.2666666666666666, 1.6, 2.3333333333333335},
        push_sweep = 0.3611111111111111,
        attack_move_01 = 0.3466666666666667,
        attack_move_02 = 0.3466666666666667,
        attack_move_03 = 0.8333333333333334,
        attack_up = 0.6666666666666666,
        attack_down = 0.4666666666666667,
    },

    -- chaos_lesser_mutated_poxwalker
    chaos_lesser_mutated_poxwalker = {
        attack_01 = 1.7037037037037037,
        attack_02 = 1.4074074074074074,
        attack_03 = 1.2592592592592593,
        attack_04 = 1.2345679012345678,
        attack_05 = 0.9876543209876543,
        attack_down_01 = 1.3333333333333333,
        attack_move_01 = 1.7777777777777777,
        attack_move_02 = 1.7471264367816093,
        attack_move_03 = 1.7777777777777777,
        attack_reach_up_01 = 1.1794871794871795,
        attack_run_01 = 2.282051282051282,
        attack_run_02 = 1.8461538461538463,
    },

    -- chaos_mutated_poxwalker
    chaos_mutated_poxwalker = {
        attack_01 = 1.7037037037037037,
        attack_02 = 1.4074074074074074,
        attack_03 = 1.2592592592592593,
        attack_04 = 1.2345679012345678,
        attack_05 = 0.9876543209876543,
        attack_down_01 = 1.3333333333333333,
        attack_move_01 = 1.7777777777777777,
        attack_move_02 = 1.7471264367816093,
        attack_move_03 = 1.7777777777777777,
        attack_reach_up_01 = 1.1794871794871795,
        attack_run_01 = 2.282051282051282,
        attack_run_02 = 1.8461538461538463,
    },

    -- chaos_mutator_daemonhost
    chaos_mutator_daemonhost = {
        attack_01 = 1.264367816091954,
        attack_02 = 1.264367816091954,
        attack_03 = 1.1954022988505748,
        attack_04 = 0.6,
        attack_05 = 0.6,
        attack_06 = 0.6,
        attack_07 = 0.6,
        attack_combo = {1.0952380952380953, 2.4523809523809526},
        attack_combo_2 = {0.6904761904761905, 1.5},
        attack_combo_3 = {0.4, 0.8666666666666667, 1.2666666666666666, 1.6, 2.3333333333333335},
        push_sweep = 0.3611111111111111,
        attack_move_01 = 0.3466666666666667,
        attack_move_02 = 0.3466666666666667,
        attack_move_03 = 0.8333333333333334,
        attack_up = 0.6666666666666666,
        attack_down = 0.4666666666666667,
    },

    -- chaos_newly_infected
    chaos_newly_infected = {
        attack_01 = 1.2873563218390804,
        attack_02 = 1.264367816091954,
        attack_03 = 1.1954022988505748,
        attack_04 = 0.7654320987654321,
        attack_05 = 0.8148148148148148,
        attack_06 = 0.7126436781609196,
        attack_07 = 0.7,
        attack_down_01 = 1.3333333333333333,
        attack_move_01 = 0.8444444444444444,
        attack_move_02 = 1.0,
        attack_move_03 = 1.0,
        attack_move_04 = 0.9555555555555556,
        attack_reach_up = 1.1794871794871795,
        attack_run_02 = 1.3055555555555556,
        attack_run_03 = 1.25,
    },

    -- chaos_ogryn_bulwark
    chaos_ogryn_bulwark = {
        attack_01 = 0.9090909090909091,
        attack_02 = 0.8461538461538461,
        attack_03 = 1.4666666666666666,
        attack_04 = 0.6,
        attack_05 = 0.6,
        attack_06 = 0.6,
        attack_07 = 0.6,
        attack_reach_up = 1.1794871794871795,
        shield_push = 0.4666666666666667,
        attack_move_01 = 1.0606060606060606,
    },

    -- chaos_ogryn_executor
    chaos_ogryn_executor = {
        attack_01 = 1.471264367816092,
        attack_02 = 1.3103448275862069,
        attack_03 = 0.7272727272727273,
        attack_04 = 0.5747126436781609,
        attack_05 = 0.6206896551724138,
        attack_06 = 0.5057471264367817,
        attack_07 = 1.6551724137931034,
        attack_08 = 1.5862068965517242,
        attack_down_01 = 1.0666666666666667,
        attack_move_01 = 1.5308641975308641,
        attack_move_02 = 1.3333333333333333,
        attack_move_03 = 1.0555555555555556,
        attack_pommel_01 = 0.49382716049382713,
        attack_push_kick_01 = 0.7407407407407407,
        attack_push_punch_01 = 0.4444444444444444,
        attack_push_punch_02 = 0.5185185185185185,
        attack_push_punch_03 = 0.41975308641975306,
        attack_push_punch_04 = 0.5679012345679012,
        attack_push_punch_05 = 0.691358024691358,
        attack_push_punch_06 = 0.6944444444444444,
        attack_reach_up = 0.6923076923076923,
        _attack_types = {
            strong_attacks = {"attack_01", "attack_02", "attack_07", "attack_08","attack_move_01"}
        }
    },

    -- chaos_ogryn_gunner
    chaos_ogryn_gunner = {
        aim_standing = -1,
        aim_standing_bwd = -1,
        aim_standing_left = -1,
        aim_standing_right = -1,
        attack_push_01 = 0.691358024691358,
        attack_push_kick_01 = 0.7654320987654321,
        attack_push_punch_01 = 0.5679012345679012,
        _attack_types = {
            shoot_actions = {"hip_fire", "offset_rifle_standing_shoot_loop_01",
                            "move_bwd_walk_aim", "move_fwd_walk_aim", "move_left_walk_aim", "move_right_walk_aim",}
        }
    },

    -- chaos_ogryn_houndmaster
    chaos_ogryn_houndmaster = {
        attack_01 = 0.6,
        attack_02 = 0.6,
        attack_03 = 0.7666666666666667,
        attack_04 = 0.8333333333333334,
        attack_05 = 0.8333333333333334,
        attack_06 = 1.0,
        attack_down_01 = 1.0666666666666667,
        attack_reach_up = 0.9,
        attack_standing_combo = {0.7, 1.7},
        move_attack_06 = 1.2121212121212122,
        move_attack_07 = 1.1111111111111112,
        move_attack_09 = 1.0666666666666667,
        move_attack_cleave = 1.1111111111111112,
        move_attack_cleave_02 = 1.5277777777777777,
        move_attack_cleave_03 = 0.8888888888888888,
        move_attack_cleave_04 = 1.0,
    },

    -- chaos_plague_ogryn
    chaos_plague_ogryn = {
        attack_charge_start_bwd = 0.06060606060606061,
        attack_charge_start_fwd = 0.06060606060606061,
        attack_charge_start_left = 0.06060606060606061,
        attack_charge_start_right = 0.06060606060606061,
        attack_charge_hit_player = 0.06060606060606061,
        attack_sword_combo = {1.0962962962962963, 1.8074074074074074, 2.696296296296296},
        attack_catapult = 0.8253968253968254,
        attack_reach_up = 0.9666666666666667,
        attack_slam = 0.6518518518518519,
        attack_stomp = 1.0606060606060606,
    },

    -- chaos_poxwalker
    chaos_poxwalker = {
        attack_01 = 1.7037037037037037,
        attack_02 = 1.4074074074074074,
        attack_03 = 1.2592592592592593,
        attack_04 = 1.2345679012345678,
        attack_05 = 0.9876543209876543,
        attack_down_01 = 1.3333333333333333,
        attack_move_01 = 1.7777777777777777,
        attack_move_02 = 1.7471264367816093,
        attack_move_03 = 1.7777777777777777,
        attack_reach_up_01 = 1.1794871794871795,
        attack_run_01 = 2.282051282051282,
        attack_run_02 = 1.8461538461538463,
    },

    -- chaos_poxwalker_bomber
    chaos_poxwalker_bomber = {
        attack_01 = 0.6,
        attack_lunge = 1.2222222222222223,
        _attack_types = {
            special_attacks = {"attack_lunge"}
        }
    },

    -- chaos_spawn
    chaos_spawn = {
        attack_melee_claw = 0.6666666666666666,
        attack_melee_claw_02 = 0.6666666666666666,
        attack_grab = 0.7666666666666667,
        attack_grab_player = 0.7666666666666667,
        attack_grab_player_ogryn = 0.7666666666666667,
        attack_melee_combo = {0.43333333333333335, 0.8666666666666667, 1.3, 1.7},
        attack_melee_combo_2 = {0.4444444444444444, 1.0555555555555556, 1.6111111111111112},
        attack_melee_combo_3 = {0.6, 1.0666666666666667, 1.8},
        attack_melee_combo_4 = {1, 2},
        attack_turn_left = {0.5666666666666667, 0.9666666666666667, 1.6666666666666667},
        attack_turn_right = {0.5666666666666667, 0.9333333333333333},
        attack_turn_bwd = {0.6666666666666666, 1.8},
        _attack_types = {
            special_attacks = {"attack_grab", "attack_grab_player", "attack_grab_player_ogryn"}
        }
    },

    -- cultist_assault
    cultist_assault = {
        aim_standing = -1,
        aim_crouching = -1,
        run_into_shoot_bwd = -1,
        run_into_shoot_fwd = -1,
        run_into_shoot_left = -1,
        run_into_shoot_right = -1,
        attack_04 = 0.7654320987654321,
        attack_05 = 0.8148148148148148,
        attack_06 = 0.7126436781609196,
        attack_07 = 0.7,
        attack_down_01 = 1.3333333333333333,
        attack_move_01 = 0.9382716049382716,
        attack_move_02 = 1.1111111111111112,
        attack_move_03 = 1.1111111111111112,
        attack_move_04 = 1.0617283950617284,
        attack_reach_up = 1.1794871794871795,
        turn_shoot_bwd = 0.1,
        turn_shoot_left = 0.1,
        turn_shoot_right = 0.1,
        _attack_types = {
            shoot_actions = {"offset_rifle_standing_shoot_loop_01"}
        },
    },

    -- cultist_berzerker
    cultist_berzerker = {
        attack_01 = 0.43333333333333335,
        attack_02 = 0.4666666666666667,
        attack_03 = 0.4666666666666667,
        attack_04 = 0.5666666666666667,
        attack_combo_standing_06 = {0.4666666666666667, 0.9666666666666667},
        attack_down_01 = 0.7,
        attack_move_01 = 0.9629629629629629,
        attack_move_combo_01_fast = {0.6666666666666666, 1.3571428571428572, 1.4285714285714286, 2.119047619047619, 2.1666666666666665, 2.880952380952381, 2.9523809523809526},
        attack_move_combo_04_fast = {0.4722222222222222, 0.8055555555555556, 1.25, 1.2777777777777777, 1.9722222222222223, 2.5833333333333335},
        attack_move_combo_08_fast = {-1, 1.1944444444444444, 1.25, 2.1666666666666665, 2.888888888888889},
        attack_reach_up = 0.7666666666666667,
        lunge_attack = 1.1111111111111112,
    },

    -- cultist_captain
    cultist_captain = {
        aim_standing = -1,
        aim_standing_bwd = -1,
        aim_standing_left = -1,
        aim_standing_right = -1,
        attack_01 = 1.5172413793103448,
        attack_02 = 1.3103448275862069,
        attack_04 = 0.6458333333333334,
        attack_05 = 0.6875,
        attack_06 = 0.6458333333333334,
        attack_07 = 0.6458333333333334,
        attack_2h_pommel = 0.7333333333333333,
        attack_kick_01 = 0.6666666666666666,
        attack_kick_02 = 0.4266666666666667,
        attack_knee_01 = 0.6133333333333333,
        attack_move_01 = 0.9382716049382716,
        attack_move_02 = 1.1111111111111112,
        attack_move_03 = 1.1111111111111112,
        attack_move_04 = 1.0617283950617284,
        attack_pommel_01 = 0.5432098765432098,
        attack_pommel_02 = 0.7160493827160493,
        attack_pommel_03 = 0.8148148148148148,
        attack_swing_combo_01 = {0.6236559139784946, 1.075268817204301, 1.8709677419354838},
        attack_swing_combo_02 = {0.6021505376344086, 1.075268817204301, 1.7419354838709677, 2.4301075268817205},
        attack_swing_combo_03 = {0.6021505376344086, 1.2043010752688172, 1.7419354838709677, 2.2795698924731185},
        attack_swing_combo_04 = {0.5591397849462365, 1.010752688172043, 1.4838709677419355, 2.129032258064516},
        attack_swing_combo_05 = {0.5376344086021505, 1.075268817204301, 1.5483870967741935, 2.150537634408602},
        cultist_captain_heavy = 1.1,
        attack_heavy_swing = 2.1666666666666665,
        cultist_heavy_moving = 1.1358024691358024,
        cultist_heavy_slam = 1.488888888888889,
        force_shield_knockback = 0.5523809523809524,
        throw_grenade = 1.2916666666666667,
        offset_shotgun_standing_shoot_pump = -1,
        _attack_types = {
            shoot_actions = {"hip_fire", "offset_pistol_standing_shoot_01", "offset_shotgun_standing_shoot_01",
                            "move_bwd_walk_aim", "move_fwd_walk_aim", "move_left_walk_aim", "move_right_walk_aim",},
            strong_attacks = {"attack_heavy_swing", "cultist_heavy_moving", "cultist_heavy_slam", "attack_move_01"},
            special_attacks = {"throw_grenade", "force_shield_knockback"}
        }
    },

    -- cultist_flamer
    cultist_flamer = {
        attack_push_kick_01 = 0.3950617283950617,
        _attack_types = {
            shoot_actions = {"hip_fire", "aim_turn_left", "aim_turn_right"}
        }
    },

    -- cultist_grenadier
    cultist_grenadier = {
        cultist_grenadier_throw_low = -1,
        cultist_grenadier_throw = -1,
        attack_kick_01 = 0.6944444444444444,
        attack_kick_02 = 0.4444444444444444,
        _attack_types = {
            special_attacks = {"cultist_grenadier_throw_low", "cultist_grenadier_throw"}
        }
    },

    -- cultist_gunner
    cultist_gunner = {
        aim_standing = -1,
        aim_standing_bwd = -1,
        aim_standing_left = -1,
        aim_standing_right = -1,
        attack_bayonet_01 = 0.5747126436781609,
        attack_bayonet_02 = 0.7586206896551724,
        attack_bayonet_04 = 1.2222222222222223,
        attack_bayonet_05 = 1.3333333333333333,
        attack_pommel_01 = 0.5185185185185185,
        attack_push_kick_01 = 0.7654320987654321,
        _attack_types = {
            shoot_actions = {"hip_fire", "aim_turn_left", "aim_turn_right", "offset_shotgun_standing_shoot_loop_01",
                            "move_bwd_walk_aim", "move_fwd_walk_aim", "move_left_walk_aim", "move_right_walk_aim",},
        }
    },

    -- cultist_melee
    cultist_melee = {
        attack_01 = 1.264367816091954,
        attack_02 = 1.264367816091954,
        attack_03 = 1.1954022988505748,
        attack_04 = 0.7654320987654321,
        attack_05 = 0.8148148148148148,
        attack_06 = 0.7126436781609196,
        attack_07 = 0.7,
        attack_down_01 = 1.3333333333333333,
        attack_move_01 = 0.9382716049382716,
        attack_move_02 = 1.1111111111111112,
        attack_move_03 = 1.1111111111111112,
        attack_move_04 = 1.0617283950617284,
        attack_reach_up = 1.1794871794871795,
        attack_run_01 = 0.7333333333333333,
        attack_run_02 = 1.5666666666666667,
        attack_run_03 = 1.5,
    },

    -- cultist_shocktrooper
    cultist_shocktrooper = {
        attack_04 = 0.7654320987654321,
        attack_05 = 0.8148148148148148,
        attack_06 = 0.7126436781609196,
        attack_07 = 0.7,
        attack_bayonet_01 = 0.5747126436781609,
        attack_bayonet_02 = 0.7586206896551724,
        attack_bayonet_04 = 1.2222222222222223,
        attack_bayonet_05 = 1.3333333333333333,
        attack_down_01 = 1.3333333333333333,
        attack_move_01 = 0.9382716049382716,
        attack_move_02 = 1.1111111111111112,
        attack_move_03 = 1.1111111111111112,
        attack_move_04 = 1.0617283950617284,
        attack_reach_up = 1.1794871794871795,
        bayonet_charge_hit = 0.4666666666666667,
        bayonet_charge_hit_02 = 0.7222222222222222,
        bayonet_charge_hit_03 = 0.6666666666666666,
        bayonet_charge_hit_04 = 1.3888888888888888,
        bayonet_charge_hit_05 = 1.2222222222222223,
        offset_shotgun_standing_shoot_pump = -1,
        _attack_types = {
            shoot_actions = {"hip_fire", "aim_turn_left", "aim_turn_right", "offset_shotgun_standing_shoot_01"}
        }
    },

    -- renegade_assault
    renegade_assault = {
        run_into_shoot_bwd = -1,
        run_into_shoot_fwd = -1,
        run_into_shoot_left = -1,
        run_into_shoot_right = -1,
        aim_standing = -1,
        aim_standing_bwd = -1,
        aim_standing_left = -1,
        aim_standing_right = -1,
        attack_04 = 0.7654320987654321,
        attack_05 = 0.8148148148148148,
        attack_06 = 0.7126436781609196,
        attack_07 = 0.7,
        attack_down_01 = 1.3333333333333333,
        attack_move_01 = 0.9382716049382716,
        attack_move_02 = 1.1111111111111112,
        attack_move_03 = 1.1111111111111112,
        attack_move_04 = 1.0617283950617284,
        attack_reach_up = 1.1794871794871795,
        throw_grenade = -1,
        _attack_types = {
            shoot_actions = {"offset_rifle_standing_shoot_loop_01",
                            "move_bwd_walk_aim", "move_fwd_walk_aim", "move_left_walk_aim", "move_right_walk_aim",}
        }
    },

    -- renegade_berzerker
    renegade_berzerker = {
        attack_01 = 0.43333333333333335,
        attack_02 = 0.4666666666666667,
        attack_03 = 0.4666666666666667,
        attack_04 = 0.5666666666666667,
        attack_combo_01 = {0.7466666666666667, 1.52, 1.6, 2.3733333333333335, 2.4266666666666667, 3.2266666666666666, 3.3066666666666666},
        attack_combo_04 = {0.5666666666666667, 0.9666666666666667, 1.5, 1.5333333333333334, 2.3666666666666667, 3.1},
        attack_combo_08 = {0.6, 1.4333333333333333, 1.5, 2.6, 3.466666666666667},
        attack_combo_standing_06 = {0.4666666666666667, 0.9666666666666667},
        attack_down_01 = 0.7,
        attack_move_01 = {0.9629629629629629},
        attack_reach_up = 0.7666666666666667,
    },

    -- renegade_captain
    renegade_captain = {
        aim_standing = -1,
        move_bwd_walk_aim = -1,
        move_fwd_walk_aim = -1,
        move_left_walk_aim = -1,
        move_right_walk_aim = -1,
        attack_01 = 1.5172413793103448,
        attack_02 = 1.3103448275862069,
        attack_03 = 0.45977011494252873,
        attack_04 = 0.6458333333333334,
        attack_05 = 0.6875,
        attack_06 = 0.6458333333333334,
        attack_07 = 0.6458333333333334,
        attack_2h_pommel = 0.7333333333333333,
        attack_ground_slam = 2.2333333333333334,
        attack_kick_01 = 0.6666666666666666,
        attack_kick_02 = 0.4266666666666667,
        attack_knee_01 = 0.6133333333333333,
        attack_move_01 = 0.9382716049382716,
        attack_move_02 = 1.1111111111111112,
        attack_move_03 = 1.1111111111111112,
        attack_move_04 = 1.0617283950617284,
        attack_pommel_01 = 0.5432098765432098,
        attack_pommel_02 = 0.7160493827160493,
        attack_pommel_03 = 0.8148148148148148,
        attack_swing_combo_02 = {0.6021505376344086, 1.075268817204301, 1.7419354838709677, 2.4301075268817205},
        attack_swing_combo_03 = {0.6021505376344086, 1.2043010752688172, 1.7419354838709677, 2.2795698924731185},
        attack_swing_combo_04 = {0.5591397849462365, 1.010752688172043, 1.4838709677419355, 2.129032258064516},
        attack_swing_combo_05 = {0.5376344086021505, 1.075268817204301, 1.5483870967741935, 2.150537634408602},
        force_shield_knockback = 0.5523809523809524,
        throw_grenade = -1,
        offset_shotgun_standing_shoot_pump = -1,
        _attack_types = {
            shoot_actions = {"offset_rifle_standing_shoot_loop_01", "hip_fire", "offset_pistol_standing_shoot_01", "offset_shotgun_standing_shoot_01"},
            strong_attacks = {"attack_ground_slam"},
            special_attacks = {"force_shield_knockback", "throw_grenade"}
        }
    },

    -- renegade_executor
    renegade_executor = {
        attack_01 = 1.471264367816092,
        attack_02 = 1.2413793103448276,
        attack_03 = 0.6133333333333333,
        attack_04 = 0.6933333333333334,
        attack_down_01 = 2.1666666666666665,
        attack_move_01 = 1.4814814814814814,
        attack_move_02 = 1.1851851851851851,
        attack_reach_up = 0.6923076923076923,
        _attack_types = {
            strong_attacks = {"attack_02", "attack_move_01", "attack_01", "attack_down_01"}
        }
    },

    -- renegade_flamer
    renegade_flamer = {
        attack_push_kick_01 = 0.3950617283950617,
        hip_fire = 0.1,
        _attack_types = {
            shoot_actions = {"hip_fire", "aim_turn_left", "aim_turn_right"}
        }
    },

    -- renegade_flamer_mutator
    renegade_flamer_mutator = {
        attack_push_kick_01 = 0.3950617283950617,
        hip_fire = 0.1,
    },

    -- renegade_grenadier
    renegade_grenadier = {
        attack_kick_01 = 0.6944444444444444,
        attack_kick_02 = 0.4444444444444444,
        _attack_types = {
            special_attacks = {"attack_throw_backhand_01", "attack_throw_low_01", "attack_throw_long_01", "attack_throw_long_02"}
        }
    },

    -- renegade_gunner
    renegade_gunner = {
        aim_standing = -1,
        aim_standing_bwd = -1,
        aim_standing_left = -1,
        aim_standing_right = -1,
        attack_pommel_01 = 0.5185185185185185,
        attack_push_kick_01 = 0.7654320987654321,
        _attack_types = {
            shoot_actions = {"hip_fire", "aim_turn_left", "aim_turn_right", "offset_shotgun_standing_shoot_loop_01",
                            "move_bwd_walk_aim", "move_fwd_walk_aim", "move_left_walk_aim", "move_right_walk_aim",}
        }
    },

    -- renegade_melee
    renegade_melee = {
        attack_01 = 1.264367816091954,
        attack_02 = 1.264367816091954,
        attack_03 = 1.1954022988505748,
        attack_04 = 0.7654320987654321,
        attack_05 = 0.8148148148148148,
        attack_06 = 0.7126436781609196,
        attack_07 = 0.7,
        attack_down_01 = 1.3333333333333333,
        attack_move_01 = 0.9382716049382716,
        attack_move_02 = 1.1111111111111112,
        attack_move_03 = 1.1111111111111112,
        attack_move_04 = 1.0617283950617284,
        attack_reach_up = 1.1794871794871795,
        attack_run_01 = 0.7333333333333333,
        attack_run_02 = 1.5666666666666667,
        attack_run_03 = 1.5,
    },

    -- renegade_plasma_gunner
    renegade_plasma_gunner = {
        attack_04 = 0.7654320987654321,
        attack_05 = 0.8148148148148148,
        attack_06 = 0.7126436781609196,
        attack_07 = 0.7,
        attack_down_01 = 1.3333333333333333,
        attack_move_01 = 0.9382716049382716,
        attack_move_02 = 1.1111111111111112,
        attack_move_03 = 1.1111111111111112,
        attack_move_04 = 1.0617283950617284,
        attack_reach_up = 1.1794871794871795,
        offset_shotgun_standing_shoot_pump = -1,
        _attack_types = {
            shoot_actions = {"hip_fire", "turn_shoot_bwd", "turn_shoot_left", "turn_shoot_right", "offset_shotgun_standing_shoot_01",
                            "move_bwd_walk_aim", "move_fwd_walk_aim", "move_left_walk_aim", "move_right_walk_aim",}
        }
    },

    -- renegade_radio_operator
    renegade_radio_operator = {
        aim_standing = -1,
        aim_standing_bwd = -1,
        aim_standing_left = -1,
        aim_standing_right = -1,
        attack_pommel_01 = 0.5185185185185185,
        attack_push_kick_01 = 0.7654320987654321,
    },

    -- renegade_rifleman
    renegade_rifleman = {
        aim_crouching = -1,
        aim_standing = -1,
        bayonet_attack_stab = 0.4888888888888889,
        bayonet_attack_stab_02 = 1.2222222222222223,
        bayonet_attack_sweep = 0.6896551724137931,
        bayonet_attack_sweep_02 = 1.4,
        bayonet_charge_hit = 0.4666666666666667,
        bayonet_charge_hit_02 = 0.7222222222222222,
        bayonet_charge_hit_03 = 0.6666666666666666,
        bayonet_charge_hit_04 = 1.3888888888888888,
        bayonet_charge_hit_05 = 1.2222222222222223,
        turn_shoot_bwd = 0.1,
        turn_shoot_left = 0.1,
        turn_shoot_right = 0.1,
        throw_grenade = -1,
        _attack_types = {
            shoot_actions = {"offset_rifle_crouch_shoot_01", "offset_rifle_standing_shoot_01", "turn_shoot_bwd", "turn_shoot_left", "turn_shoot_right"}
        }
    },

    -- renegade_shocktrooper
    renegade_shocktrooper = {
        attack_04 = 0.7654320987654321,
        attack_05 = 0.8148148148148148,
        attack_06 = 0.7126436781609196,
        attack_07 = 0.7,
        attack_down_01 = 1.3333333333333333,
        attack_move_01 = 0.9382716049382716,
        attack_move_02 = 1.1111111111111112,
        attack_move_03 = 1.1111111111111112,
        attack_move_04 = 1.0617283950617284,
        attack_reach_up = 1.1794871794871795,
        offset_shotgun_standing_shoot_pump = -1,
        _attack_types = {
            shoot_actions = {"hip_fire", "turn_shoot_bwd", "turn_shoot_left", "turn_shoot_right", "offset_shotgun_standing_shoot_01"}
        }
    },

    -- renegade_sniper
    renegade_sniper = {
        aim_crouching = -1,
        aim_standing = -1,
        attack_kick_01 = 0.6666666666666666,
        attack_pommel_01 = 0.5185185185185185,
        _attack_types = {
            shoot_actions = {"offset_rifle_crouch_shoot_01"}
        }
    },

    -- renegade_twin_captain
    renegade_twin_captain = {
        move_bwd_walk_aim = -1,
        move_fwd_walk_aim = -1,
        move_left_walk_aim = -1,
        move_right_walk_aim = -1,
        aim_standing = -1,
        attack_kick_01 = 0.6944444444444444,
        attack_kick_02 = 0.4444444444444444,
        force_shield_knockback = 0.5523809523809524,
        throw_grenade = -1,
    },

    -- renegade_twin_captain_two
    renegade_twin_captain_two = {
        attack_kick_01 = 0.6666666666666666,
        attack_kick_02 = 0.4266666666666667,
        attack_knee_01 = 0.6133333333333333,
        attack_move_01 = 0.9382716049382716,
        attack_move_02 = 1.1111111111111112,
        attack_move_03 = 1.1111111111111112,
        attack_move_04 = 1.0617283950617284,
        attack_swing_combo_01 = {0.6236559139784946, 1.075268817204301, 1.8709677419354838},
        attack_swing_combo_02 = {0.6021505376344086, 1.075268817204301, 1.7419354838709677, 2.4301075268817205},
        attack_swing_combo_03 = {0.6021505376344086, 1.2043010752688172, 1.7419354838709677, 2.2795698924731185},
        attack_swing_combo_04 = {0.5591397849462365, 1.010752688172043, 1.4838709677419355, 2.129032258064516},
        attack_swing_combo_05 = {0.5376344086021505, 1.075268817204301, 1.5483870967741935, 2.150537634408602},
        attack_heavy_swing_fast = 0.8333333333333334,
        attack_heavy_swing_fast_02 = 1.3541666666666667,
        attack_heavy_swing_moving = 1.4666666666666666,
    },

}

return ATTACK_TIMING_TABLE
