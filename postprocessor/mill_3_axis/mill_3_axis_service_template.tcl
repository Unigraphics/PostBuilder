

set nondecrypted 1

proc postcon_initialize_sys_service {} {

	uplevel #0 {

#STAY#		########## SYSTEM VARIABLE DECLARATIONS ##############
#STAY#		set mom_sys_rapid_code                        "0"
#STAY#		set mom_sys_linear_code                       "1"
#STAY#		set mom_sys_circle_code(CLW)                  "2"
#STAY#		set mom_sys_circle_code(CCLW)                 "3"
#STAY#		set mom_sys_delay_code(SECONDS)               "4"
#STAY#		set mom_sys_delay_code(REVOLUTIONS)           "4"
#STAY#		set mom_sys_cutcom_plane_code(XY)             "17"
#STAY#		set mom_sys_cutcom_plane_code(ZX)             "18"
#STAY#		set mom_sys_cutcom_plane_code(XZ)             "18"
#STAY#		set mom_sys_cutcom_plane_code(YZ)             "19"
#STAY#		set mom_sys_cutcom_plane_code(ZY)             "19"
#STAY#		set mom_sys_cutcom_code(OFF)                  "40"
#STAY#		set mom_sys_cutcom_code(LEFT)                 "41"
#STAY#		set mom_sys_cutcom_code(RIGHT)                "42"
#STAY#		set mom_sys_adjust_code                       "43"
#STAY#		set mom_sys_adjust_code_minus                 "44"
#STAY#		set mom_sys_adjust_cancel_code                "49"
#STAY#		set mom_sys_unit_code(IN)                     "20"
#STAY#		set mom_sys_unit_code(MM)                     "21"
#STAY#		set mom_sys_cycle_start_code                  "79"
#STAY#		set mom_sys_cycle_off                         "80"
#STAY#		set mom_sys_cycle_drill_code                  "81"
#STAY#		set mom_sys_cycle_drill_dwell_code            "82"
#STAY#		set mom_sys_cycle_drill_deep_code             "83"
#STAY#		set mom_sys_cycle_drill_break_chip_code       "73"
#STAY#		set mom_sys_cycle_tap_code                    "84"
#STAY#		set mom_sys_cycle_bore_code                   "85"
#STAY#		set mom_sys_cycle_bore_drag_code              "86"
#STAY#		set mom_sys_cycle_bore_no_drag_code           "76"
#STAY#		set mom_sys_cycle_bore_dwell_code             "89"
#STAY#		set mom_sys_cycle_bore_manual_code            "88"
#STAY#		set mom_sys_cycle_bore_back_code              "87"
#STAY#		set mom_sys_cycle_bore_manual_dwell_code      "88"
#STAY#		set mom_sys_output_code(ABSOLUTE)             "90"
#STAY#		set mom_sys_output_code(INCREMENTAL)          "91"
#STAY#		set mom_sys_cycle_ret_code(AUTO)              "98"
#STAY#		set mom_sys_cycle_ret_code(MANUAL)            "99"
#STAY#		set mom_sys_reset_code                        "92"
#STAY#		set mom_sys_feed_rate_mode_code(FRN)          "93"
#STAY#		set mom_sys_spindle_mode_code(SFM)            "96"
#STAY#		set mom_sys_spindle_mode_code(RPM)            "97"
#STAY#		set mom_sys_return_code                       "28"
#STAY#		set mom_sys_feed_rate_mode_code(MMPM)         "94"
#STAY#		set mom_sys_feed_rate_mode_code(MMPR)         "95"
#STAY#		set mom_sys_program_stop_code                 "0"
#STAY#		set mom_sys_optional_stop_code                "1"
#STAY#		set mom_sys_end_of_program_code               "2"
#STAY#		set mom_sys_spindle_direction_code(CLW)       "3"
#STAY#		set mom_sys_spindle_direction_code(CCLW)      "4"
#STAY#		set mom_sys_spindle_direction_code(OFF)       "5"
#STAY#		set mom_sys_tool_change_code                  "6"
#STAY#		set mom_sys_coolant_code(ON)                  "8"
#STAY#		set mom_sys_coolant_code(FLOOD)               "8"
#STAY#		set mom_sys_coolant_code(MIST)                "7"
#STAY#		set mom_sys_coolant_code(THRU)                "26"
#STAY#		set mom_sys_coolant_code(TAP)                 "27"
#STAY#		set mom_sys_coolant_code(OFF)                 "9"
#STAY#		set mom_sys_rewind_code                       "30"
#STAY#		set mom_sys_4th_axis_has_limits               "1"
#STAY#		set mom_sys_5th_axis_has_limits               "1"
#STAY#		set mom_sys_sim_cycle_drill                   "0"
#STAY#		set mom_sys_sim_cycle_drill_dwell             "0"
#STAY#		set mom_sys_sim_cycle_drill_deep              "0"
#STAY#		set mom_sys_sim_cycle_drill_break_chip        "0"
#STAY#		set mom_sys_sim_cycle_tap                     "1"
#STAY#		set mom_sys_sim_cycle_bore                    "0"
#STAY#		set mom_sys_sim_cycle_bore_drag               "0"
#STAY#		set mom_sys_sim_cycle_bore_nodrag             "0"
#STAY#		set mom_sys_sim_cycle_bore_manual             "0"
#STAY#		set mom_sys_sim_cycle_bore_dwell              "0"
#STAY#		set mom_sys_sim_cycle_bore_manual_dwell       "0"
#STAY#		set mom_sys_sim_cycle_bore_back               "0"
#STAY#		set mom_sys_cir_vector                        "Vector - Arc Start to Center"
#STAY#  	set mom_sys_helix_pitch_type                  "rise_revolution"
#STAY#		set mom_sys_spindle_ranges                    "9"
#STAY#		set mom_sys_rewind_stop_code                  "\#"
#STAY#		set mom_sys_home_pos(0)                       "0"
#STAY#		set mom_sys_home_pos(1)                       "0"
#STAY#		set mom_sys_home_pos(2)                       "0"
#STAY#		set mom_sys_zero                              "0"
#STAY#		set mom_sys_opskip_block_leader               "/"
#STAY#		set mom_sys_seqnum_start                      "10"
#STAY#		set mom_sys_seqnum_incr                       "10"
#STAY#		set mom_sys_seqnum_freq                       "1"
#STAY#		set mom_sys_seqnum_max                        "9999"
#STAY#		set mom_sys_lathe_x_double                    "1"
#STAY#		set mom_sys_lathe_i_double                    "1"
#STAY#		set mom_sys_lathe_y_double                    "1"
#STAY#		set mom_sys_lathe_j_double                    "1"
#STAY#		set mom_sys_lathe_x_factor                    "1"
#STAY#		set mom_sys_lathe_y_factor                    "1"
#STAY#		set mom_sys_lathe_z_factor                    "1"
#STAY#		set mom_sys_lathe_i_factor                    "1"
#STAY#		set mom_sys_lathe_j_factor                    "1"
#STAY#		set mom_sys_lathe_k_factor                    "1"
#STAY#		set mom_sys_leader(N)                         "N"
#STAY#		set mom_sys_leader(X)                         "X"
#STAY#		set mom_sys_leader(Y)                         "Y"
#STAY#		set mom_sys_leader(Z)                         "Z"
#STAY#		set mom_sys_leader(fourth_axis)               "A"
#STAY#		set mom_sys_leader(fifth_axis)                "B"
#STAY#		set mom_sys_leader(sixth_axis)                "C"
#STAY#		set mom_sys_contour_feed_mode(LINEAR)         "MMPM"
#STAY#		set mom_sys_rapid_feed_mode(LINEAR)           "MMPM"
#STAY#		set mom_sys_cycle_feed_mode                   "MMPM"
#STAY#		set mom_sys_feed_param(IPM,format)            "Feed_IPM"
#STAY#		set mom_sys_feed_param(IPR,format)            "Feed_IPR"
#STAY#		set mom_sys_feed_param(FRN,format)            "Feed_INV"
#STAY#		set mom_sys_vnc_rapid_dogleg                  "1"
#STAY#		set mom_sys_prev_mach_head                    ""
#STAY#		set mom_sys_curr_mach_head                    ""
#STAY#		set mom_sys_contour_feed_mode(ROTARY)         "MMPM"
#STAY#		set mom_sys_contour_feed_mode(LINEAR_ROTARY)  "MMPM"
#STAY#		set mom_sys_feed_param(DPM,format)            "Feed_DPM"
#STAY#		set mom_sys_rapid_feed_mode(ROTARY)           "MMPM"
#STAY#		set mom_sys_rapid_feed_mode(LINEAR_ROTARY)    "MMPM"
#STAY#		set mom_sys_feed_param(MMPM,format)           "Feed_MMPM"
#STAY#		set mom_sys_feed_param(MMPR,format)           "Feed_MMPR"
#STAY#		set mom_sys_retract_distance                  "10"
#STAY#		set mom_sys_linearization_method              "angle"
#STAY#		set mom_sys_post_description                  "This is a 5-Axis Milling Machine With\n\Dual Rotary Heads."
#STAY#		set mom_sys_ugpadvkins_used                   "0"
#STAY#		set mom_sys_post_builder_version              "9.0.1"
#STAY#
#STAY#		####### KINEMATIC VARIABLE DECLARATIONS ##############
#STAY#		set mom_kin_4th_axis_ang_offset               "0.0"
#STAY#		set mom_kin_4th_axis_center_offset(0)         "0.0"
#STAY#		set mom_kin_4th_axis_center_offset(1)         "0.0"
#STAY#		set mom_kin_4th_axis_center_offset(2)         "0.0"
#STAY#		set mom_kin_4th_axis_direction                "MAGNITUDE_DETERMINES_DIRECTION"
#STAY#		set mom_kin_4th_axis_incr_switch              "OFF"
#STAY#		set mom_kin_4th_axis_leader                   "A"
#STAY#		set mom_kin_4th_axis_limit_action             "Warning"
#STAY#		set mom_kin_4th_axis_max_limit                "360"
#STAY#		set mom_kin_4th_axis_min_incr                 "0.001"
#STAY#		set mom_kin_4th_axis_min_limit                "0"
#STAY#		set mom_kin_4th_axis_plane                    "YZ"
#STAY#		set mom_kin_4th_axis_point(0)                 "0.0"
#STAY#		set mom_kin_4th_axis_point(1)                 "0.0"
#STAY#		set mom_kin_4th_axis_point(2)                 "0.0"
#STAY#		set mom_kin_4th_axis_rotation                 "standard"
#STAY#		set mom_kin_4th_axis_type                     "Head"
#STAY#		set mom_kin_4th_axis_vector(0)                "1"
#STAY#		set mom_kin_4th_axis_vector(1)                "0"
#STAY#		set mom_kin_4th_axis_vector(2)                "0"
#STAY#		set mom_kin_4th_axis_zero                     "0.0"
#STAY#		set mom_kin_5th_axis_ang_offset               "0.0"
#STAY#		set mom_kin_5th_axis_center_offset(0)         "0.0"
#STAY#		set mom_kin_5th_axis_center_offset(1)         "0.0"
#STAY#		set mom_kin_5th_axis_center_offset(2)         "0.0"
#STAY#		set mom_kin_5th_axis_direction                "MAGNITUDE_DETERMINES_DIRECTION"
#STAY#		set mom_kin_5th_axis_incr_switch              "OFF"
#STAY#		set mom_kin_5th_axis_leader                   "B"
#STAY#		set mom_kin_5th_axis_limit_action             "Warning"
#STAY#		set mom_kin_5th_axis_max_limit                "360"
#STAY#		set mom_kin_5th_axis_min_incr                 "0.001"
#STAY#		set mom_kin_5th_axis_min_limit                "0"
#STAY#		set mom_kin_5th_axis_plane                    "ZX"
#STAY#		set mom_kin_5th_axis_point(0)                 "0.0"
#STAY#		set mom_kin_5th_axis_point(1)                 "0.0"
#STAY#		set mom_kin_5th_axis_point(2)                 "0.0"
#STAY#		set mom_kin_5th_axis_rotation                 "standard"
#STAY#		set mom_kin_5th_axis_type                     "Head"
#STAY#		set mom_kin_5th_axis_vector(0)                "0"
#STAY#		set mom_kin_5th_axis_vector(1)                "1"
#STAY#		set mom_kin_5th_axis_vector(2)                "0"
#STAY#		set mom_kin_5th_axis_zero                     "0.0"
#STAY#		set mom_kin_arc_output_mode                   "FULL_CIRCLE"
#STAY#		set mom_kin_arc_valid_plane                   "XYZ"
#STAY#		set mom_kin_clamp_time                        "2.0"
#STAY#		set mom_kin_cycle_plane_change_per_axis       "0"
#STAY#		set mom_kin_cycle_plane_change_to_lower       "0"
#STAY#		set mom_kin_dependent_head                    "NONE"
#STAY#		set mom_kin_flush_time                        "2.0"
#STAY#		set mom_kin_helical_arc_output_mode           "FULL_CIRCLE"
#STAY#		set mom_kin_ind_to_dependent_head_x           "0"
#STAY#		set mom_kin_ind_to_dependent_head_z           "0"
#STAY#		set mom_kin_independent_head                  "NONE"
#STAY#		set mom_kin_linearization_flag                "1"
#STAY#		set mom_kin_linearization_tol                 "0.01"
#STAY#		set mom_kin_machine_resolution                "0.001"
#STAY#		set mom_kin_machine_type                      "5_axis_dual_head"
#STAY#		set mom_kin_machine_zero_offset(0)            "0.0"
#STAY#		set mom_kin_machine_zero_offset(1)            "0.0"
#STAY#		set mom_kin_machine_zero_offset(2)            "0.0"
#STAY#		set mom_kin_max_arc_radius                    "99999.999"
#STAY#		set mom_kin_max_dpm                           "10000"
#STAY#		set mom_kin_max_fpm                           "15000"
#STAY#		set mom_kin_max_fpr                           "1000"
#STAY#		set mom_kin_max_frn                           "1000"
#STAY#		set mom_kin_min_arc_length                    "0.20"
#STAY#		set mom_kin_min_arc_radius                    "0.001"
#STAY#		set mom_kin_min_dpm                           "0.0"
#STAY#		set mom_kin_min_fpm                           "0.1"
#STAY#		set mom_kin_min_fpr                           "0.1"
#STAY#		set mom_kin_min_frn                           "0.01"
#STAY#		set mom_kin_output_unit                       "MM"
#STAY#		set mom_kin_pivot_gauge_offset                "0.0"
#STAY#		set mom_kin_pivot_guage_offset                ""
#STAY#		set mom_kin_post_data_unit                    "MM"
#STAY#		set mom_kin_rapid_feed_rate                   "10000"
#STAY#		set mom_kin_retract_distance                  "500"
#STAY#		set mom_kin_rotary_axis_method                "PREVIOUS"
#STAY#		set mom_kin_spindle_axis(0)                   "0.0"
#STAY#		set mom_kin_spindle_axis(1)                   "0.0"
#STAY#		set mom_kin_spindle_axis(2)                   "1.0"
#STAY#		set mom_kin_tool_change_time                  "12.0"
#STAY#		set mom_kin_x_axis_limit                      "1000"
#STAY#		set mom_kin_y_axis_limit                      "1000"
#STAY#		set mom_kin_z_axis_limit                      "1000"

	}
}

postcon_initialize_sys_service

CONF_CTRL_moves set return_tool_change_pos {{}}

CONF_CTRL_moves set return_safety_pos {{}}

CONF_CTRL_moves set return_before_first_tool_change_pos {{}}

CONF_CTRL_moves set safety_motion_when_mcs_changes 0

CONF_CTRL_moves set return_end_of_pgm {{}}

CONF_CTRL_setting set header_name {ignore}

CONF_GE_listing set companyinfo 0

CONF_GE_listing set pclist 0

CONF_GE_listing set postinfo 0

CONF_GE_listing set toollist 0

CONF_GE_listing set operationlist 0

CONF_SPF_warning set no_warningoutput {{--> Each line contains 1 warning message to suppress <--} {SMALL ARC; ABORTED TO LINEAR MOVE}}

set ::mom_kin_output_unit PART