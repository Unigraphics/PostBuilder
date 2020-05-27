############ TCL FILE ######################################
# USER AND DATE STAMP
############################################################

  set cam_post_dir [MOM_ask_env_var UGII_CAM_POST_DIR]
  set cam_debug_dir [MOM_ask_env_var UGII_CAM_DEBUG_DIR]
  source ${cam_post_dir}ugpost_base.tcl
 
proc MOM_before_each_add_var {} {}
proc MOM_before_each_event {} {}
 
# source ${cam_debug_dir}mom_review.tcl
 
  MOM_set_debug_mode OFF

########## SYSTEM VARIABLE DECLARATIONS ##############
  set mom_sys_sim_cycle_drill                   "0"
  set mom_sys_sim_cycle_drill_dwell             "0"
  set mom_sys_sim_cycle_drill_deep              "0"
  set mom_sys_sim_cycle_drill_break_chip        "0"
  set mom_sys_sim_cycle_tap                     "0"
  set mom_sys_sim_cycle_bore                    "0"
  set mom_sys_sim_cycle_bore_drag               "0"
  set mom_sys_sim_cycle_bore_nodrag             "0"
  set mom_sys_sim_cycle_bore_manual             "0"
  set mom_sys_sim_cycle_bore_dwell              "0"
  set mom_sys_sim_cycle_bore_manual_dwell       "0"
  set mom_sys_sim_cycle_bore_back               "0"

  set mom_sys_cir_vector                        "Vector - Arc Center to Start"

  set mom_sys_rapid_code                        "0"  
  set mom_sys_linear_code                       "1"  
  set mom_sys_circle_code(CLW)                  "2"  
  set mom_sys_circle_code(CCLW)                 "3"  
  set mom_sys_delay_code(SECONDS)               "4"  
  set mom_sys_delay_code(REVOLUTIONS)           "4"  
  set mom_sys_cutcom_plane_code(XY)             "17" 
  set mom_sys_cutcom_plane_code(ZX)             "18" 
  set mom_sys_cutcom_plane_code(YZ)             "19" 
  set mom_sys_cutcom_code(OFF)                  "40" 
  set mom_sys_cutcom_code(LEFT)                 "41" 
  set mom_sys_cutcom_code(RIGHT)                "42" 
  set mom_sys_adjust_code                       "43" 
  set mom_sys_adjust_code_minus                 "44" 
  set mom_sys_adjust_cancel_code                "49" 
  set mom_sys_unit_code(IN)                     "70" 
  set mom_sys_unit_code(MM)                     "71" 
  set mom_sys_cycle_off                         "80" 
  set mom_sys_cycle_drill_code                  "81" 
  set mom_sys_cycle_drill_deep_code             "83" 
  set mom_sys_cycle_drill_dwell_code            "82" 
  set mom_sys_cycle_drill_break_chip_code       "73" 
  set mom_sys_cycle_tap_code                    "84" 
  set mom_sys_cycle_bore_code                   "85" 
  set mom_sys_cycle_bore_drag_code              "86" 
  set mom_sys_cycle_bore_no_drag_code           "76" 
  set mom_sys_cycle_bore_back_code              "87" 
  set mom_sys_cycle_bore_manual_code            "88" 
  set mom_sys_cycle_bore_dwell_code             "89" 
  set mom_sys_cycle_bore_manual_dwell_code      "88" 
  set mom_sys_cycle_start_code                  "79" 
  set mom_sys_output_code(ABSOLUTE)             "90" 
  set mom_sys_output_code(INCREMENTAL)          "91" 
  set mom_sys_cycle_ret_code(AUTO)              "98" 
  set mom_sys_cycle_ret_code(MANUAL)            "99" 
  set mom_sys_reset_code                        "92" 
  set mom_sys_feed_rate_mode_code(IPM)          "94" 
  set mom_sys_feed_rate_mode_code(IPR)          "95" 
  set mom_sys_feed_rate_mode_code(FRN)          "93" 
  set mom_sys_spindle_mode_code(SFM)            "96" 
  set mom_sys_spindle_mode_code(RPM)            "97" 
  set mom_sys_return_code                       "28" 
  set mom_sys_program_stop_code                 "0"  
  set mom_sys_optional_stop_code                "1"  
  set mom_sys_end_of_program_code               "2"  
  set mom_sys_spindle_direction_code(CLW)       "3"  
  set mom_sys_spindle_direction_code(CCLW)      "4"  
  set mom_sys_spindle_direction_code(OFF)       "5"  
  set mom_sys_tool_change_code                  "6"  
  set mom_sys_coolant_code(MIST)                "7"  
  set mom_sys_coolant_code(ON)                  "8"  
  set mom_sys_coolant_code(FLOOD)               "8"  
  set mom_sys_coolant_code(TAP)                 "8"  
  set mom_sys_coolant_code(OFF)                 "9"  
  set mom_sys_rewind_code                       "30" 
  set mom_sys_spindle_ranges                    "0"  
  set mom_sys_rewind_stop_code                  "#"  
  set mom_sys_home_pos(0)                       "0"  
  set mom_sys_home_pos(1)                       "0"  
  set mom_sys_home_pos(2)                       "0"  
  set mom_sys_zero                              "0"  
  set mom_sys_opskip_block_leader               "/"  
  set mom_sys_seqnum_start                      "10" 
  set mom_sys_seqnum_incr                       "10" 
  set mom_sys_seqnum_freq                       "1"  
  set mom_sys_leader(fourth_axis)               "B"  
  set mom_sys_leader(fifth_axis)                "C"  
  set mom_sys_leader(N)                         "N"  
  set mom_sys_contour_feed_mode(LINEAR)         "IPM"
  set mom_sys_contour_feed_mode(ROTARY)         "IPM"
  set mom_sys_contour_feed_mode(LINEAR_ROTARY)  "IPM"
  set mom_sys_rapid_feed_mode(LINEAR)           "IPM"
  set mom_sys_rapid_feed_mode(ROTARY)           "IPM"
  set mom_sys_rapid_feed_mode(LINEAR_ROTARY)    "IPM"
  set mom_sys_feed_param(IPM,format)            "Feed_IPM"
  set mom_sys_feed_param(FRN,format)            "Feed_INV"
  set mom_sys_feed_param(DPM,format)            "Feed_DPM"
  set mom_sys_control_out                       "("  
  set mom_sys_control_in                        ")"  

####### KINEMATIC VARIABLE DECLARATIONS ##############
  set mom_kin_4th_axis_ang_offset               "0.0"
  set mom_kin_4th_axis_center_offset(0)         "0.0"
  set mom_kin_4th_axis_center_offset(1)         "0.0"
  set mom_kin_4th_axis_center_offset(2)         "0.0"
  set mom_kin_4th_axis_direction                "MAGNITUDE_DETERMINES_DIRECTION"
  set mom_kin_4th_axis_leader                   "B"  
  set mom_kin_4th_axis_limit_action             "Warning"
  set mom_kin_4th_axis_max_limit                "360"
  set mom_kin_4th_axis_min_incr                 "0.001"
  set mom_kin_4th_axis_min_limit                "0"  
  set mom_kin_4th_axis_plane                    "ZX" 
  set mom_kin_4th_axis_rotation                 "standard"
  set mom_kin_4th_axis_type                     "Table"
  set mom_kin_4th_axis_zero                     "0.0"
  set mom_kin_arc_output_mode                   "FULL_CIRCLE"
  set mom_kin_arc_valid_planes                  "XYZ"
  set mom_kin_clamp_time                        "2.0"
  set mom_kin_flush_time                        "2.0"
  set mom_kin_linearization_flag                "1"  
  set mom_kin_linearization_tol                 "0.001"
  set mom_kin_machine_resolution                ".0001"
  set mom_kin_machine_type                      "3_axis_mill"
  set mom_kin_max_arc_radius                    "9999.9999"
  set mom_kin_max_dpm                           "10" 
  set mom_kin_max_fpm                           "400"
  set mom_kin_max_frn                           "99999.999"
  set mom_kin_min_arc_radius                    "0.0001"
  set mom_kin_min_dpm                           "0.0"
  set mom_kin_min_fpm                           "0.1"
  set mom_kin_min_frn                           "0.001"
  set mom_kin_output_unit                       "IN" 
  set mom_kin_pivot_gauge_offset                "0.0"
  set mom_kin_pivot_guage_offset                ""   
  set mom_kin_post_data_unit                    "IN" 
  set mom_kin_rapid_feed_rate                   "400"
  set mom_kin_tool_change_time                  "12.0"
  set mom_kin_x_axis_limit                      "40" 
  set mom_kin_y_axis_limit                      "40" 
  set mom_kin_z_axis_limit                      "35" 

####  Listing File variables 
  set mom_sys_list_output                       "OFF"
  set mom_sys_header_output                     "OFF"
  set mom_sys_list_file_rows                    "40" 
  set mom_sys_list_file_columns                 "30" 
  set mom_sys_warning_output                    "OFF"
  set mom_sys_group_output                      "OFF"
  set mom_sys_list_file_suffix                  "lpt"
  set mom_sys_output_file_suffix                "ptp"
  set mom_sys_commentary_output                 "ON" 
  set mom_sys_commentary_list                   "x y z 4axis 5axis feed speed"




#=============================================================
proc MOM_start_of_program { } {
#=============================================================
  global mom_logname mom_date is_from
  global mom_coolant_status mom_cutcom_status
  global mom_clamp_status mom_cycle_status
  global mom_spindle_status mom_cutcom_plane pb_start_of_program_flag
  global mom_cutcom_adjust_register mom_tool_adjust_register
  global mom_tool_length_adjust_register mom_length_comp_register
  global mom_flush_register mom_wire_cutcom_adjust_register
 
    set pb_start_of_program_flag 0
    set mom_coolant_status UNDEFINED
    set mom_cutcom_status  UNDEFINED
    set mom_clamp_status   UNDEFINED
    set mom_cycle_status   UNDEFINED
    set mom_spindle_status UNDEFINED
    set mom_cutcom_plane   UNDEFINED
 
    catch {unset mom_cutcom_adjust_register}
    catch {unset mom_tool_adjust_register}
    catch {unset mom_tool_length_adjust_register}
    catch {unset mom_length_comp_register}
    catch {unset mom_flush_register}
    catch {unset mom_wire_cutcom_adjust_register}
 
    set is_from ""
 
    OPEN_files ; #open warning and listing files
    LIST_FILE_HEADER ; #list header in commentary listing
}


#=============================================================
proc PB_DELAY_TIME_SET { } {
#=============================================================
  global mom_sys_delay_param mom_delay_value
  global mom_delay_revs mom_delay_mode delay_time
 
   # post builder provided format for the current mode:
    if {[info exists mom_sys_delay_param(${mom_delay_mode},format)] != 0} {
      MOM_set_address_format dwell $mom_sys_delay_param(${mom_delay_mode},format)
    }
 
    switch $mom_delay_mode {
      SECONDS {set delay_time $mom_delay_value}
      default {set delay_time $mom_delay_revs}
    }
}


#=============================================================
proc MOM_before_motion { } {
#=============================================================
  global mom_motion_event mom_motion_type
 
    FEEDRATE_SET
 
    switch $mom_motion_type {
      ENGAGE {PB_engage_move}
      APPROACH {PB_approach_move}
      FIRSTCUT {PB_first_cut}
    }
 
    if {[llength [info commands PB_CMD_kin_before_motion]]} {PB_CMD_kin_before_motion}
    if {[llength [info commands PB_CMD_before_motion]]} {PB_CMD_before_motion}
}
 



#=============================================================
proc MOM_start_of_group {} {
#=============================================================
  global mom_sys_group_output mom_group_name group_level ptp_file_name
  global mom_sys_seqnum_start mom_sys_seqnum_freq mom_sys_seqnum_incr
  global mom_sys_ptp_output pb_start_of_program_flag
 
    if {[regexp NC_PROGRAM $mom_group_name] == 1} {set group_level 0 ; return}
 
    if {[hiset mom_sys_group_output]} { if {$mom_sys_group_output == "OFF"} {set group_level 0 ; return}}
    if {[hiset group_level]} {incr group_level} else {set group_level 1}
    if {$group_level > 1} {return}
 
    SEQNO_RESET ; #<4133654>
    MOM_reset_sequence $mom_sequence_number $mom_sequence_increment $mom_sequence_frequency
 
    if {[info exists ptp_file_name]} {
      MOM_close_output_file $ptp_file_name ; MOM_start_of_program
      if {$mom_sys_ptp_output == "ON"} {MOM_open_output_file $ptp_file_name }
    } else {
      MOM_start_of_program
    }
 
    PB_start_of_program ; set pb_start_of_program_flag 1
}


#=============================================================
proc MOM_machine_mode {} {
#=============================================================
  global pb_start_of_program_flag
 
    if {$pb_start_of_program_flag == 0} {PB_start_of_program ; set pb_start_of_program_flag 1}
    catch {PB_CMD_machine_mode}
}
############## EVENT HANDLING SECTION ################


#=============================================================
proc PB_start_of_program { } {
#=============================================================
  MOM_set_seq_off
  MOM_do_template rewind_stop_code
  MOM_set_seq_on
  MOM_force Once G_cutcom G_plane G_feed G_mode
  MOM_do_template absolute_mode
}


#=============================================================
proc MOM_start_of_path { } {
#=============================================================
  global first_linear_move ; set first_linear_move 0
  TOOL_SET MOM_start_of_path
  PB_CMD_start_of_operation_force_addresses
}


#=============================================================
proc MOM_from_move { } {
#=============================================================
  global mom_feed_rate mom_feed_rate_per_rev  mom_motion_type mom_kin_max_fpm
  COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET ;  MODES_SET
}


#=============================================================
proc MOM_first_tool { } {
#=============================================================
  global mom_tool_change_type mom_manual_tool_change
  if {[info exists mom_tool_change_type]} {
    switch $mom_tool_change_type {
         MANUAL { PB_manual_tool_change }
         AUTO   { PB_auto_tool_change }
    }
  } elseif {[info exists mom_manual_tool_change]} {
    if {$mom_manual_tool_change == "TRUE"} {
        PB_manual_tool_change
    }
  }
}


#=============================================================
proc PB_auto_tool_change { } {
#=============================================================
  PB_CMD_tool_change_force_addresses
  MOM_force Once G_mode G Z
  MOM_do_template tool_change
  PB_CMD_start_of_alignment_character
  MOM_force Once T M
  MOM_do_template tool_change_1
  PB_CMD_end_of_alignment_character
  MOM_do_template tool_change_2
}


#=============================================================
proc PB_manual_tool_change { } {
#=============================================================
  PB_CMD_tool_change_force_addresses
  MOM_do_template stop
}


#=============================================================
proc MOM_initial_move { } {
#=============================================================
  global mom_feed_rate mom_feed_rate_per_rev mom_motion_type
  global mom_kin_max_fpm mom_motion_event
  COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET ; MODES_SET
 
  global mom_programmed_feed_rate
  if { [EQ_is_equal $mom_programmed_feed_rate 0] } {
     MOM_rapid_move
  } else {
     MOM_linear_move
  }
}


#=============================================================
proc MOM_first_move { } {
#=============================================================
  global mom_feed_rate mom_feed_rate_per_rev mom_motion_type
  global mom_kin_max_fpm mom_motion_event
  COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET ; MODES_SET
  catch {MOM_$mom_motion_event}
}


#=============================================================
proc PB_approach_move { } {
#=============================================================
}


#=============================================================
proc PB_engage_move { } {
#=============================================================
}


#=============================================================
proc PB_first_cut { } {
#=============================================================
}


#=============================================================
proc PB_first_linear_move { } {
#=============================================================
}


#=============================================================
proc PB_return_move { } {
#=============================================================
}


#=============================================================
proc MOM_gohome_move { } {
#=============================================================
  MOM_rapid_move
}


#=============================================================
proc MOM_end_of_path { } {
#=============================================================
}


#=============================================================
proc MOM_end_of_program { } {
#=============================================================
  MOM_do_template end_of_program
  MOM_set_seq_off
  MOM_do_template rewind_stop_code
#**** The following procedure lists the tool  list with time in commentary data
  LIST_FILE_TRAILER
#**** The following procedure closes the warning and listing files
  CLOSE_files
}


#=============================================================
proc MOM_tool_change { } {
#=============================================================
  global mom_tool_change_type mom_manual_tool_change
  if {[info exists mom_tool_change_type]} {
    switch $mom_tool_change_type {
         MANUAL { PB_manual_tool_change }
         AUTO   { PB_auto_tool_change }
    }
  } elseif {[info exists mom_manual_tool_change]} {
    if {$mom_manual_tool_change == "TRUE"} {
        PB_manual_tool_change
    }
  }
}


#=============================================================
proc MOM_length_compensation { } {
#=============================================================
  TOOL_SET MOM_length_compensation
  MOM_do_template tool_length_adjust
}


#=============================================================
proc MOM_set_modes { } {
#=============================================================
  MODES_SET
}


#=============================================================
proc MOM_spindle_rpm { } {
#=============================================================
  SPINDLE_SET
  MOM_force Once S M_spindle
  MOM_do_template spindle_rpm
}


#=============================================================
proc MOM_spindle_off { } {
#=============================================================
  MOM_do_template spindle_off
}


#=============================================================
proc MOM_coolant_on { } {
#=============================================================
  COOLANT_SET
}


#=============================================================
proc MOM_coolant_off { } {
#=============================================================
  COOLANT_SET
  MOM_do_template coolant_off
}


#=============================================================
proc PB_feedrates { } {
#=============================================================
}


#=============================================================
proc MOM_cutcom_on { } {
#=============================================================
  CUTCOM_SET
}


#=============================================================
proc MOM_cutcom_off { } {
#=============================================================
  CUTCOM_SET
  MOM_do_template cutcom_off
}


#=============================================================
proc MOM_delay { } {
#=============================================================
  PB_DELAY_TIME_SET
  MOM_do_template delay
}


#=============================================================
proc MOM_opstop { } {
#=============================================================
  MOM_do_template opstop
}


#=============================================================
proc MOM_auxfun { } {
#=============================================================
  MOM_do_template auxfun
}


#=============================================================
proc MOM_prefun { } {
#=============================================================
  MOM_do_template prefun
}


#=============================================================
proc MOM_load_tool { } {
#=============================================================
  global mom_tool_change_type mom_manual_tool_change
}


#=============================================================
proc MOM_stop { } {
#=============================================================
  MOM_do_template stop
}


#=============================================================
proc MOM_tool_preselect { } {
#=============================================================
  global mom_tool_preselect_number mom_tool_number mom_next_tool_number
  if {[info exists mom_tool_preselect_number]} {
    set mom_next_tool_number $mom_tool_preselect_number
  }
  MOM_do_template tool_preselect
}


#=============================================================
proc MOM_linear_move { } {
#=============================================================
  global feed_mode mom_feed_rate mom_kin_rapid_feed_rate
 
  if { $feed_mode == "IPM" || $feed_mode == "MMPM" } {
     if { [EQ_is_ge $mom_feed_rate $mom_kin_rapid_feed_rate] } {
        MOM_rapid_move ; return
     }
  }
 
  global first_linear_move
 
  if {!$first_linear_move} {PB_first_linear_move ; incr first_linear_move}
 
  MOM_do_template linear_move_1
}


#=============================================================
proc MOM_circular_move { } {
#=============================================================
  CIRCLE_SET
  MOM_do_template circular_move_1
}


#=============================================================
proc MOM_rapid_move { } {
#=============================================================
  global rapid_spindle_inhibit rapid_traverse_inhibit
  global spindle_first is_from
  global mom_cycle_spindle_axis traverse_axis1 traverse_axis2
  set aa(0) X ; set aa(1) Y ; set aa(2) Z
  RAPID_SET
  set spindle_block rapid_spindle
  set traverse_block rapid_traverse
  if {$spindle_first == "TRUE"} {
    if {$rapid_spindle_inhibit == "FALSE"} {
       MOM_suppress once $aa($traverse_axis1) $aa($traverse_axis2)
       MOM_do_template $spindle_block $is_from
       MOM_suppress off $aa($traverse_axis1) $aa($traverse_axis2)
    }
    if {$rapid_traverse_inhibit == "FALSE"} {
       MOM_suppress once $aa($mom_cycle_spindle_axis)
       MOM_do_template $traverse_block $is_from
       MOM_suppress off $aa($mom_cycle_spindle_axis)
    }
  } elseif {$spindle_first == "FALSE"} {
    if {$rapid_traverse_inhibit == "FALSE"} {
       MOM_suppress once $aa($mom_cycle_spindle_axis)
       MOM_do_template $traverse_block $is_from
       MOM_suppress off $aa($mom_cycle_spindle_axis)
    }
    if {$rapid_spindle_inhibit == "FALSE"} {
       MOM_suppress once $aa($traverse_axis1) $aa($traverse_axis2)
       MOM_do_template $spindle_block $is_from
       MOM_suppress off $aa($traverse_axis1) $aa($traverse_axis2)
    }
  } else {
       MOM_do_template $traverse_block $is_from
  }
}


#=============================================================
proc MOM_cycle_off { } {
#=============================================================
  MOM_do_template cycle_off
}


#=============================================================
proc MOM_cycle_plane_change { } {
#=============================================================
  global cycle_init_flag
  set cycle_init_flag TRUE
}


#=============================================================
proc MOM_drill { } {
#=============================================================
  global cycle_name
  global cycle_init_flag
  set cycle_init_flag TRUE
  set cycle_name DRILL
  CYCLE_SET
}


#=============================================================
proc MOM_drill_move { } {
#=============================================================
  global cycle_init_flag 
  MOM_do_template cycle_drill
  set cycle_init_flag FALSE
}


#=============================================================
proc MOM_drill_dwell { } {
#=============================================================
  global cycle_name
  global cycle_init_flag
  set cycle_init_flag TRUE
  set cycle_name DRILL_DWELL
  CYCLE_SET
}


#=============================================================
proc MOM_drill_dwell_move { } {
#=============================================================
  global cycle_init_flag 
  MOM_do_template cycle_drill_dwell
  set cycle_init_flag FALSE
}


#=============================================================
proc MOM_drill_deep { } {
#=============================================================
  global cycle_name
  global cycle_init_flag
  set cycle_init_flag TRUE
  set cycle_name DRILL_DEEP
  CYCLE_SET
}


#=============================================================
proc MOM_drill_deep_move { } {
#=============================================================
  global cycle_init_flag 
  MOM_do_template cycle_drill_deep
  set cycle_init_flag FALSE
}


#=============================================================
proc MOM_drill_break_chip { } {
#=============================================================
  global cycle_name
  global cycle_init_flag
  set cycle_init_flag TRUE
  set cycle_name DRILL_BREAK_CHIP
  CYCLE_SET
}


#=============================================================
proc MOM_drill_break_chip_move { } {
#=============================================================
  global cycle_init_flag 
  MOM_do_template cycle_drill_break_chip
  set cycle_init_flag FALSE
}


#=============================================================
proc MOM_tap { } {
#=============================================================
  global cycle_name
  global cycle_init_flag
  set cycle_init_flag TRUE
  set cycle_name TAP
  CYCLE_SET
}


#=============================================================
proc MOM_tap_move { } {
#=============================================================
  global cycle_init_flag 
  MOM_do_template cycle_tap
  set cycle_init_flag FALSE
}


#=============================================================
proc MOM_bore { } {
#=============================================================
  global cycle_name
  global cycle_init_flag
  set cycle_init_flag TRUE
  set cycle_name BORE
  CYCLE_SET
}


#=============================================================
proc MOM_bore_move { } {
#=============================================================
  global cycle_init_flag 
  MOM_do_template cycle_bore
  set cycle_init_flag FALSE
}


#=============================================================
proc MOM_bore_drag { } {
#=============================================================
  global cycle_name
  global cycle_init_flag
  set cycle_init_flag TRUE
  set cycle_name BORE_DRAG
  CYCLE_SET
}


#=============================================================
proc MOM_bore_drag_move { } {
#=============================================================
  global cycle_init_flag 
  MOM_do_template cycle_bore_drag
  set cycle_init_flag FALSE
}


#=============================================================
proc MOM_bore_no_drag { } {
#=============================================================
  global cycle_name
  global cycle_init_flag
  set cycle_init_flag TRUE
  set cycle_name BORE_NO_DRAG
  CYCLE_SET
}


#=============================================================
proc MOM_bore_no_drag_move { } {
#=============================================================
  global cycle_init_flag 
  MOM_do_template cycle_bore_no_drag
  set cycle_init_flag FALSE
}


#=============================================================
proc MOM_bore_manual { } {
#=============================================================
  global cycle_name
  global cycle_init_flag
  set cycle_init_flag TRUE
  set cycle_name BORE_MANUAL
  CYCLE_SET
}


#=============================================================
proc MOM_bore_manual_move { } {
#=============================================================
  global cycle_init_flag 
  MOM_do_template cycle_bore_manual
  set cycle_init_flag FALSE
}


#=============================================================
proc MOM_bore_dwell { } {
#=============================================================
  global cycle_name
  global cycle_init_flag
  set cycle_init_flag TRUE
  set cycle_name BORE_DWELL
  CYCLE_SET
}


#=============================================================
proc MOM_bore_dwell_move { } {
#=============================================================
  global cycle_init_flag 
  MOM_do_template cycle_bore_dwell
  set cycle_init_flag FALSE
}


#=============================================================
proc MOM_bore_back { } {
#=============================================================
  global cycle_name
  global cycle_init_flag
  set cycle_init_flag TRUE
  set cycle_name BORE_BACK
  CYCLE_SET
}


#=============================================================
proc MOM_bore_back_move { } {
#=============================================================
  global cycle_init_flag 
  MOM_do_template cycle_bore_back
  set cycle_init_flag FALSE
}


#=============================================================
proc MOM_bore_manual_dwell { } {
#=============================================================
  global cycle_name
  global cycle_init_flag
  set cycle_init_flag TRUE
  set cycle_name BORE_MANUAL_DWELL
  CYCLE_SET
}


#=============================================================
proc MOM_bore_manual_dwell_move { } {
#=============================================================
  global cycle_init_flag 
  MOM_do_template cycle_bore_manual_dwell
  set cycle_init_flag FALSE
}


#=============================================================
proc MOM_sequence_number { } {
#=============================================================
  SEQNO_SET
}


#=============================================================
proc PB_CMD_before_motion { } {
#=============================================================
}


#=============================================================
proc PB_CMD_end_of_alignment_character { } {
#=============================================================
 #  Return sequnece number back to orignal
 #  This command may be used with the command "PM_CMD_start_of_alignment_character"

  global mom_sys_leader saved_seq_num
  set mom_sys_leader(N) $saved_seq_num
}


#=============================================================
proc PB_CMD_start_of_alignment_character { } {
#=============================================================
 # This command can be used to output a special sequence number character.  
 # Replace the ":" with any character that you require.
 # You must use the command "PB_CMD_end_of_alignment_character" to reset
 # the sequence number back to the original setting.

  global mom_sys_leader saved_seq_num
  set saved_seq_num $mom_sys_leader(N)
  set mom_sys_leader(N) ":"
}


#=============================================================
proc PB_CMD_start_of_operation_force_addresses { } {
#=============================================================
  MOM_force once S M_spindle X Y Z F
}


#=============================================================
proc PB_CMD_tool_change_force_addresses { } {
#=============================================================
  MOM_force once G_adjust H
}


#=============================================================
proc DELAY_TIME_SET {  } {
#=============================================================
  global mom_sys_delay_param mom_delay_value
  global mom_delay_revs mom_delay_mode delay_time
 
   # post builder provided format for the current mode:
    if {[info exists mom_sys_delay_param(${mom_delay_mode},format)] != 0} {
      MOM_set_address_format dwell $mom_sys_delay_param(${mom_delay_mode},format)
    }
 
    switch $mom_delay_mode {
      SECONDS {set delay_time $mom_delay_value}
      default {set delay_time $mom_delay_revs}
    }
}
