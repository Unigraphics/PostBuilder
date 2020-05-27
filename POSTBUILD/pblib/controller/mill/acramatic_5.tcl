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
  set mom_sys_cycle_start_code                  "79" 
  set mom_sys_cycle_off                         "80" 
  set mom_sys_cycle_drill_code                  "81" 
  set mom_sys_cycle_drill_dwell_code            "82" 
  set mom_sys_cycle_drill_deep_code             "83" 
  set mom_sys_cycle_drill_break_chip_code       "73" 
  set mom_sys_cycle_tap_code                    "84" 
  set mom_sys_cycle_bore_code                   "85" 
  set mom_sys_cycle_bore_drag_code              "86" 
  set mom_sys_cycle_bore_no_drag_code           "76" 
  set mom_sys_cycle_bore_dwell_code             "89" 
  set mom_sys_cycle_bore_manual_code            "88" 
  set mom_sys_cycle_bore_back_code              "87" 
  set mom_sys_cycle_bore_manual_dwell_code      "89" 
  set mom_sys_output_code(ABSOLUTE)             "90" 
  set mom_sys_output_code(INCREMENTAL)          "91" 
  set mom_sys_cycle_ret_code(AUTO)              "99" 
  set mom_sys_cycle_ret_code(MANUAL)            "98" 
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
  set mom_sys_leader(N)                         "N"  
  set mom_sys_leader(fourth_axis)               "B"  
  set mom_sys_leader(fifth_axis)                "B"  
  set mom_sys_contour_feed_mode(LINEAR)         "IPM"
  set mom_sys_contour_feed_mode(ROTARY)         "IPM"
  set mom_sys_contour_feed_mode(LINEAR_ROTARY)  "IPM"
  set mom_sys_rapid_feed_mode(LINEAR)           "IPM"
  set mom_sys_rapid_feed_mode(ROTARY)           "IPM"
  set mom_sys_rapid_feed_mode(LINEAR_ROTARY)    "IPM"
  set mom_sys_feed_param(IPM,format)            "Feed_IPM"
  set mom_sys_feed_param(FRN,format)            "Feed_INV"
  set mom_sys_feed_param(DPM,format)            "Feed_DPM"
  set mom_sys_feed_param(IPR,format)            "Feed_IPR"
  set mom_sys_cycle_feed_mode                   "IPR"
  set mom_sys_control_out                       "("  
  set mom_sys_control_in                        ")"  

####### KINEMATIC VARIABLE DECLARATIONS ##############
  set mom_kin_4th_axis_ang_offset               "0.0"
  set mom_kin_4th_axis_center_offset(0)         "0.0"
  set mom_kin_4th_axis_center_offset(1)         "0.0"
  set mom_kin_4th_axis_center_offset(2)         "0.0"
  set mom_kin_4th_axis_direction                "MAGNITUDE_DETERMINES_DIRECTION"
  set mom_kin_4th_axis_incr_switch              "OFF"
  set mom_kin_4th_axis_leader                   "B"  
  set mom_kin_4th_axis_limit_action             "Warning"
  set mom_kin_4th_axis_max_limit                "360"
  set mom_kin_4th_axis_min_incr                 "0.001"
  set mom_kin_4th_axis_min_limit                "0"  
  set mom_kin_4th_axis_plane                    "ZX" 
  set mom_kin_4th_axis_rotation                 "standard"
  set mom_kin_4th_axis_type                     "Table"
  set mom_kin_4th_axis_zero                     "0.0"
  set mom_kin_5th_axis_incr_switch              "OFF"
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
  set mom_kin_max_fpr                           "100"
  set mom_kin_max_frn                           "99999.999"
  set mom_kin_min_arc_length                    "0.0001"
  set mom_kin_min_arc_radius                    "0.0001"
  set mom_kin_min_dpm                           "0.0"
  set mom_kin_min_fpm                           "0.1"
  set mom_kin_min_fpr                           "0.1"
  set mom_kin_min_frn                           "0.001"
  set mom_kin_output_unit                       "IN" 
  set mom_kin_pivot_gauge_offset                "0.0"
  set mom_kin_pivot_guage_offset                "0.0"
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
      ENGAGE   {PB_engage_move}
      APPROACH {PB_approach_move}
      FIRSTCUT {PB_first_cut}
    }

    if { [llength [info commands PB_CMD_kin_before_motion]] } { PB_CMD_kin_before_motion }
    if { [llength [info commands PB_CMD_before_motion]] }     { PB_CMD_before_motion }
}


#=============================================================
proc MOM_start_of_group {} {
#=============================================================
  global mom_sys_group_output mom_group_name group_level ptp_file_name
  global mom_sequence_number mom_sequence_increment mom_sequence_frequency
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

   if { [llength [info commands PB_CMD_kin_start_of_program]] } {
      PB_CMD_kin_start_of_program
   }

   PB_CMD_init_cycle_gage
   PB_CMD_pq_cutcom_initialize
   MOM_set_seq_off
   MOM_do_template rewind_stop_code
   MOM_set_seq_on
   MOM_force Once G_plane G_feed G_mode
   MOM_do_template absolute_mode
}


#=============================================================
proc MOM_start_of_path { } {
#=============================================================
  global first_linear_move ; set first_linear_move 0
   TOOL_SET MOM_start_of_path

   if { [llength [info commands PB_CMD_kin_start_of_path]] } {
      PB_CMD_kin_start_of_path
   }

   PB_CMD_start_of_operation_force_addresses
}


#=============================================================
proc MOM_from_move { } {
#=============================================================
  global mom_feed_rate mom_feed_rate_per_rev  mom_motion_type mom_kin_max_fpm
   COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET
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
   COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET

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
   COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET
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

#**** The following procedure lists the tool list with time in commentary data
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
   PB_CMD_cutcom_on
}


#=============================================================
proc MOM_cutcom_off { } {
#=============================================================
   CUTCOM_SET
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

   if {!$first_linear_move} { PB_first_linear_move ; incr first_linear_move }

   PB_CMD_pq_motion
   MOM_do_template linear_move_1
}


#=============================================================
proc MOM_circular_move { } {
#=============================================================
   CIRCLE_SET
   PB_CMD_pq_motion
   MOM_do_template circular_move_1
}


#=============================================================
proc MOM_rapid_move { } {
#=============================================================
  global rapid_spindle_inhibit rapid_traverse_inhibit
  global spindle_first is_from
  global mom_cycle_spindle_axis traverse_axis1 traverse_axis2
  global mom_motion_event

   set aa(0) X ; set aa(1) Y ; set aa(2) Z
   RAPID_SET
   MOM_do_template rapid_traverse
   MOM_do_template rapid_spindle
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

  global mom_cycle_rapid_to mom_cycle_retract_to

   if { [EQ_is_lt $mom_cycle_rapid_to $mom_cycle_retract_to] } {
      MOM_do_template post_retracto
      MOM_do_template post_retracto_1
   }

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

  global mom_cycle_rapid_to mom_cycle_retract_to

   if { [EQ_is_lt $mom_cycle_rapid_to $mom_cycle_retract_to] } {
      MOM_do_template post_retracto
      MOM_do_template post_retracto_1
   }

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

  global mom_cycle_rapid_to mom_cycle_retract_to

   if { [EQ_is_lt $mom_cycle_rapid_to $mom_cycle_retract_to] } {
      MOM_do_template post_retracto
      MOM_do_template post_retracto_1
   }

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

  global mom_cycle_rapid_to mom_cycle_retract_to

   if { [EQ_is_lt $mom_cycle_rapid_to $mom_cycle_retract_to] } {
      MOM_do_template post_retracto
      MOM_do_template post_retracto_1
   }

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

  global mom_cycle_rapid_to mom_cycle_retract_to

   if { [EQ_is_lt $mom_cycle_rapid_to $mom_cycle_retract_to] } {
      MOM_do_template post_retracto
      MOM_do_template post_retracto_1
   }

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

  global mom_cycle_rapid_to mom_cycle_retract_to

   if { [EQ_is_lt $mom_cycle_rapid_to $mom_cycle_retract_to] } {
      MOM_do_template post_retracto
      MOM_do_template post_retracto_1
   }

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

  global mom_cycle_rapid_to mom_cycle_retract_to

   if { [EQ_is_lt $mom_cycle_rapid_to $mom_cycle_retract_to] } {
      MOM_do_template post_retracto
      MOM_do_template post_retracto_1
   }

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

  global mom_cycle_rapid_to mom_cycle_retract_to

   if { [EQ_is_lt $mom_cycle_rapid_to $mom_cycle_retract_to] } {
      MOM_do_template post_retracto
      MOM_do_template post_retracto_1
   }

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

  global mom_cycle_rapid_to mom_cycle_retract_to

   if { [EQ_is_lt $mom_cycle_rapid_to $mom_cycle_retract_to] } {
      MOM_do_template post_retracto
      MOM_do_template post_retracto_1
   }

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

  global mom_cycle_rapid_to mom_cycle_retract_to

   if { [EQ_is_lt $mom_cycle_rapid_to $mom_cycle_retract_to] } {
      MOM_do_template post_retracto
      MOM_do_template post_retracto_1
   }

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

  global mom_cycle_rapid_to mom_cycle_retract_to

   if { [EQ_is_lt $mom_cycle_rapid_to $mom_cycle_retract_to] } {
      MOM_do_template post_retracto
      MOM_do_template post_retracto_1
   }

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

  global mom_cycle_rapid_to mom_cycle_retract_to

   if { [EQ_is_lt $mom_cycle_rapid_to $mom_cycle_retract_to] } {
      MOM_do_template post_retracto
      MOM_do_template post_retracto_1
   }

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
proc PB_CMD_cutcom_on { } {
#=============================================================
global mom_sys_cutcom_status
  set mom_sys_cutcom_status "START"
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
proc PB_CMD_init_cycle_gage { } {
#=============================================================
global cycle_gage

set cycle_gage .1
}


#=============================================================
proc PB_CMD_pq_cutcom_initialize { } {
#=============================================================
#  This procedure is used to establish PQ cutter compensation for Cincinnati
#  controllers.  This procedure must be placed in the start of path event marker
#  in order to get the PQ codes.
# 
#  mom_sys_cutcom_status 
#	OFF	Cutcom is off, no action is needed 
#	ON	Cutcom is on, output pq codes
#	START	Cutcom has been turned on, output startup codes
#	END	Cutcom has been turned off, output off codes
#
#  mom_sys_cutcom_type
#
#	G_CODES	Output G40, G41, G42
#	PQ	Output PQ codes
#
#  mom_sys_cutcom_on_type
#
#	NORMAL	Cutcom offset vector is perpendicular to direction of motion
#	TANGENT Cutcom offset vector is parallel to the direction of motion
#
#  mom_sys_cutcom_off_type
#
#	NORMAL	Cutcom vector for last point is perpendicular 
#               to the direction of last motion
#	TANGENT Cutcom vector for last point is parallel to the 
#               direction of last motion
#
global mom_sys_cutcom_status
global mom_sys_cutcom_type
global mom_sys_cutcom_on_type
global mom_sys_cutcom_off_type
global mom_kin_read_ahead_next_motion

  set mom_sys_cutcom_status "OFF"
  set mom_sys_cutcom_type "PQ"
  set mom_sys_cutcom_on_type "NORMAL"
  set mom_sys_cutcom_off_type "NORMAL"
  set mom_kin_read_ahead_next_motion "TRUE"

  MOM_reload_kinematics
}


#=============================================================
proc PB_CMD_pq_motion { } {
#=============================================================
#
#  Process PQ cutcom.  Calculate PQ vectors and force out as needed.

pq_cutcom
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
  MOM_force once S M_spindle X Y Z F cycle_R
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


#=============================================================
proc ARCTAN { y x } {
#=============================================================

  global PI

  if {[EQ_is_zero $y]} {
    if {$x < 0.0} {return $PI}
    return 0.0
  }
  if {[EQ_is_zero $x]} {
    if {$y < 0.0} {return [expr $PI*1.5]}
    return [expr $PI*.5]
  }
  set ang [expr atan ($y/$x)]
  if {$x > 0.0 && $y < 0.0} {return [expr $ang+$PI*2.0]}
  if {$x < 0.0 && $y < 0.0} {return [expr $ang+$PI]}
  if {$x < 0.0 && $y > 0.0} {return [expr $ang+$PI]}
  return $ang
}


#=============================================================
proc pq_cutcom {  } {
#=============================================================

  global mom_mcs_goto mom_prev_mcs_goto mom_nxt_mcs_goto 
  global mom_sys_cutcom_status mom_sys_cutcom_type mom_sys_cutcom_on_type
  global mom_sys_cutcom_off_type pval qval cur_vec nxt_vec
  global mom_nxt_event mom_nxt_event_count mom_nxt_motion_event mom_nxt_arc_center
  global mom_motion_event mom_nxt_arc_axis mom_arc_axis mom_arc_center
  global mom_pos mom_prev_pos mom_kin_machine_resolution
  global mom_cutcom_status PI

if {[info exists mom_sys_cutcom_type] && $mom_sys_cutcom_type == "PQ"} {
 
  if {$mom_sys_cutcom_type == "PQ" && $mom_sys_cutcom_status != "OFF"} {
    if {$mom_nxt_event_count != 0} {
      for {set i 0} {$i < $mom_nxt_event_count} {incr i 1} {
	if {$mom_nxt_event($i) == "cutcom_off"} {set mom_sys_cutcom_status "END"}
      }
    }
    if {$mom_motion_event == "linear_move" || $mom_nxt_motion_event == "rapid_move"} {
      VEC3_sub mom_prev_mcs_goto mom_mcs_goto tmp_vec
      VEC3_unitize tmp_vec cur_vec
    } elseif {$mom_motion_event == "circular_move"} {
      VEC3_sub mom_mcs_goto mom_arc_center cur_vec
      VEC3_unitize cur_vec tmp_vec
      VEC3_cross mom_arc_axis tmp_vec cur_vec
    }
    if {$mom_nxt_motion_event == "linear_move" || $mom_nxt_motion_event == "rapid_move"} {
      VEC3_sub mom_nxt_mcs_goto mom_mcs_goto tmp_vec
      VEC3_unitize tmp_vec nxt_vec
    } elseif {$mom_nxt_motion_event == "circular_move"} {
      VEC3_sub mom_nxt_arc_center mom_mcs_goto nxt_vec
      VEC3_unitize nxt_vec tmp_vec
      VEC3_cross mom_nxt_arc_axis tmp_vec nxt_vec
    }

    if {$mom_sys_cutcom_status != "END" && $mom_sys_cutcom_status != "START"} {
      set xdel [expr abs($mom_pos(0)-$mom_prev_pos(0))]
      if {$xdel > $mom_kin_machine_resolution} {MOM_force once P_cutcom}
      set ydel [expr abs($mom_pos(1)-$mom_prev_pos(1))]
      if {$ydel > $mom_kin_machine_resolution} {MOM_force once Q_cutcom}
    }

    if {$mom_sys_cutcom_status == "START"} {
      if {$mom_sys_cutcom_on_type == "NORMAL"} {
        set cur_vec(0) [expr -$nxt_vec(0)]
        set cur_vec(1) [expr -$nxt_vec(1)]
      } elseif {$mom_sys_cutcom_on_type == "TANGENT"} {
        set cur_vec(0) $nxt_vec(1)
        set cur_vec(1) [expr -$nxt_vec(0)]
        set nxt_vec(0) [expr -$cur_vec(0)]
        set nxt_vec(1) [expr -$cur_vec(1)]
      }
      set mom_sys_cutcom_status "ON"
      MOM_force once X Y P_cutcom Q_cutcom
    } elseif {$mom_sys_cutcom_status == "END"} {
      if {$mom_sys_cutcom_off_type == "NORMAL"} {
        set nxt_vec(0) [expr -$cur_vec(0)]
        set nxt_vec(1) [expr -$cur_vec(1)]
      } elseif {$mom_sys_cutcom_off_type == "TANGENT"} {
        set nxt_vec(0) [expr -$cur_vec(1)]
        set nxt_vec(1) $cur_vec(0)
        set cur_vec(0) [expr -$nxt_vec(0)]
        set cur_vec(1) [expr -$nxt_vec(1)]
      }
      set mom_sys_cutcom_status "OFF"
      MOM_force once X Y P_cutcom Q_cutcom
    }

    set a1 [ARCTAN $cur_vec(1) $cur_vec(0)]
    set a2 [ARCTAN $nxt_vec(1) $nxt_vec(0)]
    set a3 [expr $a1-$a2]
    if {$a3 < 0.0} {set a3 [expr $a3+$PI*2.0]}
    set a4 [expr $a2+($a3/2.0)]
    set cosa [expr cos($a4)]
    set sina [expr sin($a4)]
    set div [expr abs(sin($a3/2.0))]
    if {[EQ_is_zero $div]} {
      if {![EQ_is_zero $cosa]} {
	if {$cosa < 0.0} {
	  set pval -3.2767
        } else {
	  set pval 3.2767
        }
      } else {
	set pval 0.0
      }
      if {![EQ_is_zero $sina]} {
	if {$sina < 0.0} {
	  set qval -3.2767
        } else {
	  set qval 3.2767
        }
      } else {
	set qval 0.0
      }
    } else {
      set pval [expr $cosa/$div]
      if {$pval < -3.2767} {
        set pval -3.2767
      } elseif {$pval > 3.2767} {
        set pval 3.2767
      }
      set qval [expr $sina/$div]
      if {$qval < -3.2767} {
        set qval -3.2767
      } elseif {$qval > 3.2767} {
        set qval 3.2767
      }
    }
    if {$mom_cutcom_status == "RIGHT" } {
      set pval [expr -$pval]
      set qval [expr -$qval]
    }
  }
}
}
