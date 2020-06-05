set nondecrypted 1
proc postcon_initialize_sys_service {} {
uplevel #0 {
# ########## SYSTEM VARIABLE DECLARATIONS ##############
# set mom_sys_rapid_code "0"
# set mom_sys_linear_code "1"
# set mom_sys_circle_code(CLW) "2"
# set mom_sys_circle_code(CCLW) "3"
# set mom_sys_delay_code(SECONDS) "4"
# set mom_sys_delay_code(REVOLUTIONS) "4"
# set mom_sys_cutcom_plane_code(XY) "17"
# set mom_sys_cutcom_plane_code(ZX) "18"
# set mom_sys_cutcom_plane_code(XZ) "18"
# set mom_sys_cutcom_plane_code(YZ) "19"
# set mom_sys_cutcom_plane_code(ZY) "19"
# set mom_sys_cutcom_code(OFF) "40"
# set mom_sys_cutcom_code(LEFT) "41"
# set mom_sys_cutcom_code(RIGHT) "42"
# set mom_sys_adjust_code "43"
# set mom_sys_adjust_code_minus "44"
# set mom_sys_adjust_cancel_code "49"
# set mom_sys_unit_code(IN) "20"
# set mom_sys_unit_code(MM) "21"
# set mom_sys_cycle_start_code "79"
# set mom_sys_cycle_off "80"
# set mom_sys_cycle_drill_code "81"
# set mom_sys_cycle_drill_dwell_code "82"
# set mom_sys_cycle_drill_deep_code "83"
# set mom_sys_cycle_drill_break_chip_code "73"
# set mom_sys_cycle_tap_code "84"
# set mom_sys_cycle_bore_code "85"
# set mom_sys_cycle_bore_drag_code "86"
# set mom_sys_cycle_bore_no_drag_code "76"
# set mom_sys_cycle_bore_dwell_code "89"
# set mom_sys_cycle_bore_manual_code "88"
# set mom_sys_cycle_bore_back_code "87"
# set mom_sys_cycle_bore_manual_dwell_code "88"
# set mom_sys_output_code(ABSOLUTE) "90"
# set mom_sys_output_code(INCREMENTAL) "91"
# set mom_sys_cycle_ret_code(AUTO) "98"
# set mom_sys_cycle_ret_code(MANUAL) "99"
# set mom_sys_reset_code "92"
# set mom_sys_feed_rate_mode_code(FRN) "93"
# set mom_sys_spindle_mode_code(SFM) "96"
# set mom_sys_spindle_mode_code(RPM) "97"
# set mom_sys_return_code "28"
# set mom_sys_feed_rate_mode_code(MMPM) "94"
# set mom_sys_feed_rate_mode_code(MMPR) "95"
# set mom_sys_program_stop_code "0"
# set mom_sys_optional_stop_code "1"
# set mom_sys_end_of_program_code "2"
# set mom_sys_spindle_direction_code(CLW) "3"
# set mom_sys_spindle_direction_code(CCLW) "4"
# set mom_sys_spindle_direction_code(OFF) "5"
# set mom_sys_tool_change_code "6"
# set mom_sys_coolant_code(ON) "8"
# set mom_sys_coolant_code(FLOOD) "8"
# set mom_sys_coolant_code(MIST) "7"
# set mom_sys_coolant_code(THRU) "26"
# set mom_sys_coolant_code(TAP) "27"
# set mom_sys_coolant_code(OFF) "9"
# set mom_sys_rewind_code "30"
# set mom_sys_4th_axis_has_limits "1"
# set mom_sys_5th_axis_has_limits "1"
# set mom_sys_sim_cycle_drill "0"
# set mom_sys_sim_cycle_drill_dwell "0"
# set mom_sys_sim_cycle_drill_deep "0"
# set mom_sys_sim_cycle_drill_break_chip "0"
# set mom_sys_sim_cycle_tap "1"
# set mom_sys_sim_cycle_bore "0"
# set mom_sys_sim_cycle_bore_drag "0"
# set mom_sys_sim_cycle_bore_nodrag "0"
# set mom_sys_sim_cycle_bore_manual "0"
# set mom_sys_sim_cycle_bore_dwell "0"
# set mom_sys_sim_cycle_bore_manual_dwell "0"
# set mom_sys_sim_cycle_bore_back "0"
# set mom_sys_cir_vector "Vector - Arc Start to Center"
# set mom_sys_helix_pitch_type "rise_revolution"
# set mom_sys_spindle_ranges "9"
# set mom_sys_rewind_stop_code "\#"
# set mom_sys_home_pos(0) "0"
# set mom_sys_home_pos(1) "0"
# set mom_sys_home_pos(2) "0"
# set mom_sys_zero "0"
# set mom_sys_opskip_block_leader "/"
# set mom_sys_seqnum_start "10"
# set mom_sys_seqnum_incr "10"
# set mom_sys_seqnum_freq "1"
# set mom_sys_seqnum_max "9999"
# set mom_sys_lathe_x_double "1"
# set mom_sys_lathe_i_double "1"
# set mom_sys_lathe_y_double "1"
# set mom_sys_lathe_j_double "1"
# set mom_sys_lathe_x_factor "1"
# set mom_sys_lathe_y_factor "1"
# set mom_sys_lathe_z_factor "1"
# set mom_sys_lathe_i_factor "1"
# set mom_sys_lathe_j_factor "1"
# set mom_sys_lathe_k_factor "1"
# set mom_sys_leader(N) "N"
# set mom_sys_leader(X) "X"
# set mom_sys_leader(Y) "Y"
# set mom_sys_leader(Z) "Z"
# set mom_sys_leader(fourth_axis) "A"
# set mom_sys_leader(fifth_axis) "B"
# set mom_sys_leader(sixth_axis) "C"
# set mom_sys_contour_feed_mode(LINEAR) "MMPM"
# set mom_sys_rapid_feed_mode(LINEAR) "MMPM"
# set mom_sys_cycle_feed_mode "MMPM"
# set mom_sys_feed_param(IPM,format) "Feed_IPM"
# set mom_sys_feed_param(IPR,format) "Feed_IPR"
# set mom_sys_feed_param(FRN,format) "Feed_INV"
# set mom_sys_vnc_rapid_dogleg "1"
# set mom_sys_prev_mach_head ""
# set mom_sys_curr_mach_head ""
# set mom_sys_contour_feed_mode(ROTARY) "MMPM"
# set mom_sys_contour_feed_mode(LINEAR_ROTARY) "MMPM"
# set mom_sys_feed_param(DPM,format) "Feed_DPM"
# set mom_sys_rapid_feed_mode(ROTARY) "MMPM"
# set mom_sys_rapid_feed_mode(LINEAR_ROTARY) "MMPM"
# set mom_sys_feed_param(MMPM,format) "Feed_MMPM"
# set mom_sys_feed_param(MMPR,format) "Feed_MMPR"
# set mom_sys_retract_distance "10"
# set mom_sys_linearization_method "angle"
# set mom_sys_post_description "This is a 5-Axis Milling Machine With\n\Dual Rotary Heads."
# set mom_sys_ugpadvkins_used "0"
# set mom_sys_post_builder_version "9.0.1"
#
# ####### KINEMATIC VARIABLE DECLARATIONS ##############
# set mom_kin_4th_axis_ang_offset "0.0"
# set mom_kin_4th_axis_center_offset(0) "0.0"
# set mom_kin_4th_axis_center_offset(1) "0.0"
# set mom_kin_4th_axis_center_offset(2) "0.0"
# set mom_kin_4th_axis_direction "MAGNITUDE_DETERMINES_DIRECTION"
# set mom_kin_4th_axis_incr_switch "OFF"
# set mom_kin_4th_axis_leader "A"
# set mom_kin_4th_axis_limit_action "Warning"
# set mom_kin_4th_axis_max_limit "360"
# set mom_kin_4th_axis_min_incr "0.001"
# set mom_kin_4th_axis_min_limit "0"
# set mom_kin_4th_axis_plane "YZ"
# set mom_kin_4th_axis_point(0) "0.0"
# set mom_kin_4th_axis_point(1) "0.0"
# set mom_kin_4th_axis_point(2) "0.0"
# set mom_kin_4th_axis_rotation "standard"
# set mom_kin_4th_axis_type "Head"
# set mom_kin_4th_axis_vector(0) "1"
# set mom_kin_4th_axis_vector(1) "0"
# set mom_kin_4th_axis_vector(2) "0"
# set mom_kin_4th_axis_zero "0.0"
# set mom_kin_5th_axis_ang_offset "0.0"
# set mom_kin_5th_axis_center_offset(0) "0.0"
# set mom_kin_5th_axis_center_offset(1) "0.0"
# set mom_kin_5th_axis_center_offset(2) "0.0"
# set mom_kin_5th_axis_direction "MAGNITUDE_DETERMINES_DIRECTION"
# set mom_kin_5th_axis_incr_switch "OFF"
# set mom_kin_5th_axis_leader "B"
# set mom_kin_5th_axis_limit_action "Warning"
# set mom_kin_5th_axis_max_limit "360"
# set mom_kin_5th_axis_min_incr "0.001"
# set mom_kin_5th_axis_min_limit "0"
# set mom_kin_5th_axis_plane "ZX"
# set mom_kin_5th_axis_point(0) "0.0"
# set mom_kin_5th_axis_point(1) "0.0"
# set mom_kin_5th_axis_point(2) "0.0"
# set mom_kin_5th_axis_rotation "standard"
# set mom_kin_5th_axis_type "Head"
# set mom_kin_5th_axis_vector(0) "0"
# set mom_kin_5th_axis_vector(1) "1"
# set mom_kin_5th_axis_vector(2) "0"
# set mom_kin_5th_axis_zero "0.0"
# set mom_kin_arc_output_mode "FULL_CIRCLE"
# set mom_kin_arc_valid_plane "XYZ"
# set mom_kin_clamp_time "2.0"
# set mom_kin_cycle_plane_change_per_axis "0"
# set mom_kin_cycle_plane_change_to_lower "0"
# set mom_kin_dependent_head "NONE"
# set mom_kin_flush_time "2.0"
# set mom_kin_helical_arc_output_mode "FULL_CIRCLE"
# set mom_kin_ind_to_dependent_head_x "0"
# set mom_kin_ind_to_dependent_head_z "0"
# set mom_kin_independent_head "NONE"
# set mom_kin_linearization_flag "1"
# set mom_kin_linearization_tol "0.01"
# set mom_kin_machine_resolution "0.001"
# set mom_kin_machine_type "5_axis_dual_head"
# set mom_kin_machine_zero_offset(0) "0.0"
# set mom_kin_machine_zero_offset(1) "0.0"
# set mom_kin_machine_zero_offset(2) "0.0"
# set mom_kin_max_arc_radius "99999.999"
# set mom_kin_max_dpm "10000"
# set mom_kin_max_fpm "15000"
# set mom_kin_max_fpr "1000"
# set mom_kin_max_frn "1000"
# set mom_kin_min_arc_length "0.20"
# set mom_kin_min_arc_radius "0.001"
# set mom_kin_min_dpm "0.0"
# set mom_kin_min_fpm "0.1"
# set mom_kin_min_fpr "0.1"
# set mom_kin_min_frn "0.01"
# set mom_kin_output_unit "MM"
# set mom_kin_pivot_gauge_offset "0.0"
# set mom_kin_pivot_guage_offset ""
# set mom_kin_post_data_unit "MM"
# set mom_kin_rapid_feed_rate "10000"
# set mom_kin_retract_distance "500"
# set mom_kin_rotary_axis_method "PREVIOUS"
# set mom_kin_spindle_axis(0) "0.0"
# set mom_kin_spindle_axis(1) "0.0"
# set mom_kin_spindle_axis(2) "1.0"
# set mom_kin_tool_change_time "12.0"
# set mom_kin_x_axis_limit "1000"
# set mom_kin_y_axis_limit "1000"
# set mom_kin_z_axis_limit "1000"
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

CONF_CTRL_moves set decompose_first_move 0

CONF_CTRL_moves set decompose_first_move_sim 0

CONF_CTRL_moves set decompose_first_move_for_each_tool_path 0

CONF_CTRL_setting set plane_output_supported NONE

CONF_CTRL_setting set tcpm_output_supported NONE

set ::mom_kin_4th_axis_point(0) 0.000000
set ::mom_kin_4th_axis_point(1) 0.000000
set ::mom_kin_4th_axis_point(2) 0.000000

