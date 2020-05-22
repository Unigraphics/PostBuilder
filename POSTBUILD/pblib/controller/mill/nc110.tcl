########################## TCL Event Handlers ##########################
#
#  Created by ChudoyakovEB68  @  Thu Dec 06 13:31:27 2007 Владивосток (лето)
#  with Post Builder version  3.3.0.
#
########################################################################

  set cam_post_dir [MOM_ask_env_var UGII_CAM_POST_DIR]


  if { ![info exists mom_sys_post_initialized] } {

     source ${cam_post_dir}ugpost_base.tcl

     proc MOM_before_each_add_var {} {}
     proc MOM_before_each_event {} {}

#     set cam_debug_dir [MOM_ask_env_var UGII_CAM_DEBUG_DIR]
#     source ${cam_debug_dir}mom_review.tcl

     MOM_set_debug_mode OFF


   ####  Listing File variables
     set mom_sys_list_output                       "OFF"
     set mom_sys_header_output                     "OFF"
     set mom_sys_list_file_rows                    "120"
     set mom_sys_list_file_columns                 "80"
     set mom_sys_warning_output                    "ON"
     set mom_sys_group_output                      "OFF"
     set mom_sys_list_file_suffix                  "lpt"
     set mom_sys_output_file_suffix                "ptp"
     set mom_sys_commentary_output                 "ON"
     set mom_sys_commentary_list                   "x y z feed speed"

     set mom_sys_control_out                       ";"
     set mom_sys_control_in                        ""

     set mom_sys_post_initialized 1
  }


########## SYSTEM VARIABLE DECLARATIONS ##############
  set mom_sys_rapid_code                        "0"
  set mom_sys_linear_code                       "1"
  set mom_sys_circle_code(CLW)                  "2"
  set mom_sys_circle_code(CCLW)                 "3"
  set mom_sys_delay_code(SECONDS)               "4"
  set mom_sys_delay_code(REVOLUTIONS)           "4"
  set mom_sys_delay_code(SLOWDN)                "9"
  set mom_sys_cutcom_plane_code(XY)             "17"
  set mom_sys_cutcom_plane_code(ZX)             "18"
  set mom_sys_cutcom_plane_code(XZ)             "18"
  set mom_sys_cutcom_plane_code(YZ)             "19"
  set mom_sys_cutcom_plane_code(ZY)             "19"
  set mom_sys_cutcom_code(OFF)                  "40"
  set mom_sys_cutcom_code(LEFT)                 "41"
  set mom_sys_cutcom_code(RIGHT)                "42"
  set mom_sys_adjust_code                       "48"
  set mom_sys_adjust_code_minus                 "49"
  set mom_sys_adjust_cancel_code                "47"
  set mom_sys_unit_code(IN)                     "70"
  set mom_sys_unit_code(MM)                     "71"
  set mom_sys_cycle_start_code                  "79"
  set mom_sys_cycle_off                         "80"
  set mom_sys_cycle_drill_code                  "81"
  set mom_sys_cycle_drill_dwell_code            "83"
  set mom_sys_cycle_drill_deep_code             "83"
  set mom_sys_cycle_drill_break_chip_code       "83"
  set mom_sys_cycle_tap_code                    "84"
  set mom_sys_cycle_bore_code                   "86"
  set mom_sys_cycle_bore_drag_code              "82"
  set mom_sys_cycle_bore_no_drag_code           "82"
  set mom_sys_cycle_bore_dwell_code             "82"
  set mom_sys_cycle_bore_manual_code            "82"
  set mom_sys_cycle_bore_back_code              "82"
  set mom_sys_cycle_bore_manual_dwell_code      "82"
  set mom_sys_output_code(ABSOLUTE)             "90"
  set mom_sys_output_code(INCREMENTAL)          "91"
  set mom_sys_cycle_ret_code(AUTO)              "98"
  set mom_sys_cycle_ret_code(MANUAL)            "99"
  set mom_sys_reset_code                        "79"
  set mom_sys_feed_rate_mode_code(IPM)          "94"
  set mom_sys_feed_rate_mode_code(IPR)          "95"
  set mom_sys_feed_rate_mode_code(FRN)          "93"
  set mom_sys_spindle_mode_code(SFM)            "96"
  set mom_sys_spindle_mode_code(RPM)            "97"
  set mom_sys_return_code                       "28"
  set mom_sys_feed_rate_mode_code(MMPM)         "94"
  set mom_sys_feed_rate_mode_code(MMPR)         "95"
  set mom_sys_program_stop_code                 "0"
  set mom_sys_optional_stop_code                "1"
  set mom_sys_end_of_program_code               "2"
  set mom_sys_spindle_direction_code(CLW)       "3"
  set mom_sys_spindle_direction_code(CCLW)      "4"
  set mom_sys_spindle_direction_code(OFF)       "5"
  set mom_sys_spindle_direction_code(ORIENT)    "19"
  set mom_sys_tool_change_code                  "6"
  set mom_sys_coolant_code(ON)                  "8"
  set mom_sys_coolant_code(FLOOD)               "8"
  set mom_sys_coolant_code(MIST)                "7"
  set mom_sys_coolant_code(THRU)                "8"
  set mom_sys_coolant_code(TAP)                 "8"
  set mom_sys_coolant_code(OFF)                 "9"
  set mom_sys_rewind_code                       "30"
  set mom_sys_spindle_range_code(1)             "41"
  set mom_sys_spindle_param(1,max)              "400"
  set mom_sys_spindle_param(1,min)              "20"
  set mom_sys_spindle_range_code(2)             "42"
  set mom_sys_spindle_param(2,max)              "2500"
  set mom_sys_spindle_param(2,min)              "125"
  set mom_sys_spindle_range_code(3)             "43"
  set mom_sys_spindle_param(3,max)              "0"
  set mom_sys_spindle_param(3,min)              "0"
  set mom_sys_spindle_range_code(4)             "44"
  set mom_sys_spindle_param(4,max)              "0"
  set mom_sys_spindle_param(4,min)              "0"
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
  set mom_sys_cir_vector                        "Vector - Absolute Arc Center"
  set mom_sys_spindle_ranges                    "4"
  set mom_sys_rewind_stop_code                  "%"
  set mom_sys_home_pos(0)                       "0"
  set mom_sys_home_pos(1)                       "0"
  set mom_sys_home_pos(2)                       "0"
  set mom_sys_zero                              "0"
  set mom_sys_opskip_block_leader               "/"
  set mom_sys_seqnum_start                      "1"
  set mom_sys_seqnum_incr                       "1"
  set mom_sys_seqnum_freq                       "1"
  set mom_sys_seqnum_max                        "9999"
  set mom_sys_lathe_x_double                    "1"
  set mom_sys_lathe_i_double                    "1"
  set mom_sys_lathe_y_double                    "1"
  set mom_sys_lathe_j_double                    "1"
  set mom_sys_lathe_x_factor                    "1"
  set mom_sys_lathe_y_factor                    "1"
  set mom_sys_lathe_z_factor                    "1"
  set mom_sys_lathe_i_factor                    "1"
  set mom_sys_lathe_j_factor                    "1"
  set mom_sys_lathe_k_factor                    "1"
  set mom_sys_leader(N)                         "N"
  set mom_sys_leader(X)                         "X"
  set mom_sys_leader(Y)                         "Y"
  set mom_sys_leader(Z)                         "Z"
  set mom_sys_leader(I)                         "I"
  set mom_sys_leader(J)                         "J"
  set mom_sys_leader(K)                         "K"
  set mom_sys_leader(fourth_axis)               "B"
  set mom_sys_leader(fifth_axis)                "B"
  set mom_sys_contour_feed_mode(LINEAR)         "MMPM"
  set mom_sys_rapid_feed_mode(LINEAR)           "MMPM"
  set mom_sys_cycle_feed_mode                   "MMPM"
  set mom_sys_feed_param(IPM,format)            "Feed_IPM"
  set mom_sys_feed_param(IPR,format)            "Feed_IPR"
  set mom_sys_feed_param(FRN,format)            "Feed_INV"
  set mom_sys_vnc_rapid_dogleg                  "1"
  set mom_sys_prev_mach_head                    ""
  set mom_sys_curr_mach_head                    ""
  set mom_sys_feed_param(MMPM,format)           "Feed_MMPM"
  set mom_sys_feed_param(MMPR,format)           "Feed_MMPR"
  set mom_sys_post_description                  "Постпроцессор для ... с УЧПУ NC110-NC210\n\
                                                 Автор: Кондратенко Е.И."

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
  set mom_kin_arc_valid_plane                   "XY"
  set mom_kin_clamp_time                        "2.0"
  set mom_kin_flush_time                        "2.0"
  set mom_kin_linearization_flag                "0"
  set mom_kin_linearization_tol                 "0.01"
  set mom_kin_machine_resolution                "0.001"
  set mom_kin_machine_type                      "3_axis_mill"
  set mom_kin_max_arc_radius                    "99998.999"
  set mom_kin_max_dpm                           "10"
  set mom_kin_max_fpm                           "3000."
  set mom_kin_max_fpr                           "30."
  set mom_kin_max_frn                           "3000."
  set mom_kin_min_arc_length                    "0.025"
  set mom_kin_min_arc_radius                    "0.016"
  set mom_kin_min_dpm                           "0.0"
  set mom_kin_min_fpm                           "0.01"
  set mom_kin_min_fpr                           "0.01"
  set mom_kin_min_frn                           "0.01"
  set mom_kin_output_unit                       "MM"
  set mom_kin_pivot_gauge_offset                "0.0"
  set mom_kin_pivot_guage_offset                ""
  set mom_kin_post_data_unit                    "MM"
  set mom_kin_rapid_feed_rate                   "3000."
  set mom_kin_tool_change_time                  "30.0"
  set mom_kin_x_axis_limit                      "900"
  set mom_kin_y_axis_limit                      "300"
  set mom_kin_z_axis_limit                      "120"




if [llength [info commands MOM_SYS_do_template] ] {
   if [llength [info commands MOM_do_template] ] {
      rename MOM_do_template ""
   }
   rename MOM_SYS_do_template MOM_do_template
}




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
  global mom_wire_cutcom_status

    set pb_start_of_program_flag 0
    set mom_coolant_status UNDEFINED
    set mom_cutcom_status  UNDEFINED
    set mom_clamp_status   UNDEFINED
    set mom_cycle_status   UNDEFINED
    set mom_spindle_status UNDEFINED
    set mom_cutcom_plane   UNDEFINED
    set mom_wire_cutcom_status  UNDEFINED

    catch {unset mom_cutcom_adjust_register}
    catch {unset mom_tool_adjust_register}
    catch {unset mom_tool_length_adjust_register}
    catch {unset mom_length_comp_register}
    catch {unset mom_flush_register}
    catch {unset mom_wire_cutcom_adjust_register}

    set is_from ""

    catch { OPEN_files } ; #open warning and listing files
    LIST_FILE_HEADER ; #list header in commentary listing



  global mom_sys_post_initialized
  if { $mom_sys_post_initialized > 1 } { return }


#************
uplevel #0 {


#=============================================================
proc MOM_sync {} {
#=============================================================
  if [llength [info commands PB_CMD_kin_handle_sync_event] ] {
    PB_CMD_kin_handle_sync_event
  }
}


#=============================================================
proc MOM_set_csys {} {
#=============================================================
  if [llength [info commands PB_CMD_kin_set_csys] ] {
    PB_CMD_kin_set_csys
  }
}


#=============================================================
proc MOM_msys {} {
#=============================================================
}


#=============================================================
proc MOM_end_of_program { } {
#=============================================================
   PB_CMD_end_of_program
   MOM_set_seq_off
   PB_CMD_reprocess

#**** The following procedure lists the tool list with time in commentary data
   LIST_FILE_TRAILER

#**** The following procedure closes the warning and listing files
   CLOSE_files
}


  incr mom_sys_post_initialized


} ;# uplevel
#***********


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
      RETRACT  {PB_retract_move}
      RETURN   {PB_return_move}
    }

    if [llength [info commands PB_CMD_kin_before_motion] ] { PB_CMD_kin_before_motion }
    if [llength [info commands PB_CMD_before_motion] ]     { PB_CMD_before_motion }
}


#=============================================================
proc MOM_start_of_group {} {
#=============================================================
  global mom_sys_group_output mom_group_name group_level ptp_file_name
  global mom_sequence_number mom_sequence_increment mom_sequence_frequency
  global mom_sys_ptp_output pb_start_of_program_flag

    if {![hiset group_level]} {set group_level 0 ; return}

    if {[hiset mom_sys_group_output]} {if {$mom_sys_group_output == "OFF"} {set group_level 0 ; return}}

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
  global mom_operation_name mom_sys_change_mach_operation_name

   set mom_sys_change_mach_operation_name $mom_operation_name

    if {$pb_start_of_program_flag == 0} {PB_start_of_program ; set pb_start_of_program_flag 1}

    if [llength [info commands PB_machine_mode] ] {
       if [catch {PB_machine_mode} res] {
          global mom_warning_info
          set mom_warning_info "$res"
          MOM_catch_warning
       }
    }
}


#=============================================================
proc PB_FORCE { option args } {
#=============================================================
   set adds [join $args]
   if { [info exists option] && [llength $adds] } {
      lappend cmd MOM_force
      lappend cmd $option
      lappend cmd [join $adds]
      eval [join $cmd]
   }
}


#=============================================================
proc PB_SET_RAPID_MOD { mod_list blk_list ADDR NEW_MOD_LIST } {
#=============================================================
  upvar $ADDR addr
  upvar $NEW_MOD_LIST new_mod_list
  global mom_cycle_spindle_axis traverse_axis1 traverse_axis2


   set new_mod_list [list]

   foreach mod $mod_list {
      switch $mod {
         "rapid1" {
            set elem $addr($traverse_axis1)
            if { [lsearch $blk_list $elem] >= 0 } {
               lappend new_mod_list $elem
            }
         }
         "rapid2" {
            set elem $addr($traverse_axis2)
            if { [lsearch $blk_list $elem] >= 0 } {
               lappend new_mod_list $elem
            }
         }
         "rapid3" {
            set elem $addr($mom_cycle_spindle_axis)
            if { [lsearch $blk_list $elem] >= 0 } {
               lappend new_mod_list $elem
            }
         }
         default {
            set elem $mod
            if { [lsearch $blk_list $elem] >= 0 } {
               lappend new_mod_list $elem
            }
         }
      }
   }
}


########################
# Redefine FEEDRATE_SET
########################
if [llength [info commands ugpost_FEEDRATE_SET] ] {
   rename ugpost_FEEDRATE_SET ""
}

if [llength [info commands FEEDRATE_SET] ] {
   rename FEEDRATE_SET ugpost_FEEDRATE_SET
} else {
   proc ugpost_FEEDRATE_SET {} {}
}


#=============================================================
proc FEEDRATE_SET {} {
#=============================================================
   if [llength [info commands PB_CMD_kin_feedrate_set] ] {
      PB_CMD_kin_feedrate_set
   } else {
      ugpost_FEEDRATE_SET
   }
}


############## EVENT HANDLING SECTION ################


#=============================================================
proc PB_start_of_program { } {
#=============================================================

   if [llength [info commands PB_CMD_kin_start_of_program] ] {
      PB_CMD_kin_start_of_program
   }

   PB_CMD_start_of_header
   PB_CMD_initial_move_init
   PB_CMD_init_helix
   PB_CMD_start_of_program
}


#=============================================================
proc MOM_start_of_path { } {
#=============================================================
  global mom_sys_in_operation
   set mom_sys_in_operation 1

  global first_linear_move ; set first_linear_move 0
   TOOL_SET MOM_start_of_path

   if [llength [info commands PB_CMD_kin_start_of_path] ] {
      PB_CMD_kin_start_of_path
   }

   PB_CMD_start_of_operation_force_addresses
   PB_CMD_start_of_path
}


#=============================================================
proc MOM_from_move { } {
#=============================================================
  global mom_feed_rate mom_feed_rate_per_rev  mom_motion_type mom_kin_max_fpm
   COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET
   PB_CMD_from_move
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
   PB_CMD_auto_tool_change
}


#=============================================================
proc PB_manual_tool_change { } {
#=============================================================
   PB_CMD_manual_tool_change
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
proc PB_retract_move { } {
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

   if [llength [info commands PB_CMD_kin_end_of_path] ] {
      PB_CMD_kin_end_of_path
   }

   global mom_sys_in_operation
   set mom_sys_in_operation 0
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
   PB_CMD_length_compensation
}


#=============================================================
proc MOM_set_modes { } {
#=============================================================
   MODES_SET
   PB_CMD_set_modes
}


#=============================================================
proc MOM_spindle_rpm { } {
#=============================================================
   SPINDLE_SET
   PB_CMD_spindle_on
}


#=============================================================
proc MOM_spindle_off { } {
#=============================================================
   PB_CMD_spindle_off
   MOM_do_template spindle_off
}


#=============================================================
proc MOM_coolant_on { } {
#=============================================================
   COOLANT_SET
   MOM_force Once M_coolant
   MOM_do_template coolant_on
}


#=============================================================
proc MOM_coolant_off { } {
#=============================================================
   COOLANT_SET
   PB_CMD_coolant_off
   MOM_do_template coolant_off
}


#=============================================================
proc PB_feedrates { } {
#=============================================================
}


#=============================================================
proc MOM_cutcom_on { } {
#=============================================================
  global mom_cutcom_status

   if {$mom_cutcom_status != "SAME"} { MOM_cutcom_off }
   CUTCOM_SET
   PB_CMD_cutcom_on
}


#=============================================================
proc MOM_cutcom_off { } {
#=============================================================
   CUTCOM_SET
   PB_CMD_cutcom_off
}


#=============================================================
proc MOM_delay { } {
#=============================================================
   PB_DELAY_TIME_SET
   PB_CMD_delay
}


#=============================================================
proc MOM_opstop { } {
#=============================================================
   PB_CMD_opstop
}


#=============================================================
proc MOM_auxfun { } {
#=============================================================
   PB_CMD_auxfun
}


#=============================================================
proc MOM_prefun { } {
#=============================================================
   PB_CMD_prefun
}


#=============================================================
proc MOM_load_tool { } {
#=============================================================
  global mom_tool_change_type mom_manual_tool_change
   PB_CMD_load_tool
}


#=============================================================
proc MOM_stop { } {
#=============================================================
   PB_CMD_stop
}


#=============================================================
proc MOM_tool_preselect { } {
#=============================================================
  global mom_tool_preselect_number mom_tool_number mom_next_tool_number
   if {[info exists mom_tool_preselect_number]} {
      set mom_next_tool_number $mom_tool_preselect_number
   }
   PB_CMD_tool_preselect
}


#=============================================================
proc MOM_text { } {
#=============================================================
   PB_CMD_text
}


#=============================================================
proc MOM_pprint { } {
#=============================================================
   PB_CMD_pprint
}


#=============================================================
proc MOM_operator_message { } {
#=============================================================
   PB_CMD_operator_message
}


#=============================================================
proc MOM_insert { } {
#=============================================================
   PB_CMD_insert
}


#=============================================================
proc MOM_origin { } {
#=============================================================
   PB_CMD_origin
}


#=============================================================
proc MOM_zero { } {
#=============================================================
   PB_CMD_zero
}


#=============================================================
proc MOM_linear_move { } {
#=============================================================
  global feed_mode mom_feed_rate mom_kin_rapid_feed_rate

   if { $feed_mode == "IPM" || $feed_mode == "MMPM" } {
      if { [EQ_is_ge $mom_feed_rate $mom_kin_rapid_feed_rate] } {
         MOM_rapid_move
         return
      }
   }

  global first_linear_move

   if { !$first_linear_move } {
      PB_first_linear_move
      incr first_linear_move
   }

   PB_CMD_linear_move
}


#=============================================================
proc MOM_circular_move { } {
#=============================================================
   CIRCLE_SET
   PB_CMD_circular_move
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
   PB_CMD_rapid_move
   set rapid_traverse_blk {G_cutcom G_motion G_mode X Y Z}
   set rapid_traverse_mod {}
   PB_SET_RAPID_MOD $rapid_traverse_mod $rapid_traverse_blk aa mod_traverse
   PB_FORCE Once $mod_traverse
   MOM_do_template rapid_traverse
}


#=============================================================
proc MOM_nurbs_move { } {
#=============================================================
   PB_CMD_nurbs_move
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
proc PB_CMD_auto_tool_change { } {
#=============================================================
  global mom_update_post_cmds_from_tool
  set event [MOM_ask_event_type]
  if {[info exists mom_update_post_cmds_from_tool]} {
    #MOM_output_to_listing_device "mom_update_post_cmds_from_tool=$mom_update_post_cmds_from_tool"
    #MOM_output_to_listing_device "event=$event"
    if {$mom_update_post_cmds_from_tool==0} {
      if {[regexp -nocase -- "MOM_load_tool" $event]==0} { return }
    }
   } else {
    if {[regexp -nocase -- "MOM_load_tool" $event]==1} { return }
  }

  global g_plane ;   set g_plane [CHECK_PLANE]
  ;# Вывод плоскости обработки
  ;#if {$g_plane != "NONE"}  { MOM_do_template plane }

   PB_CMD_start_of_alignment_character

  set line ""
  if [llength [info commands PB_CMD_tool_info] ] {
    set line [ PB_CMD_tool_info ]
  }
  global  mom_sys_control_out  mom_sys_control_in
  MOM_suppress ONCE N
  MOM_output_literal " ${mom_sys_control_out} $line ${mom_sys_control_in}"

  global mom_tool_adjust_register
  if {![info exists mom_tool_adjust_register]} { set mom_tool_adjust_register 0 ; }

  global mom_cutcom_adjust_register
  if {[info exists mom_cutcom_adjust_register]} {
  	if {$mom_tool_adjust_register!=$mom_cutcom_adjust_register} {
  	  set mom_tool_adjust_register $mom_cutcom_adjust_register
    }
  }

   MOM_force Once T M
   catch { MOM_do_template tool_change } errMes ; MOM_log_message "$errMes"
   catch { MOM_do_template tool_change_next CREATE } errMes ; MOM_log_message "$errMes"

   PB_CMD_end_of_alignment_character

;#MOM_output_literal "(UAO,1)"
}


#=============================================================
proc PB_CMD_auxfun { } {
#=============================================================
# This procedure is executed when the Auxiliary command is activated.
 global mom_auxfun_text
 MOM_suppress once Text
 if {[info exists  mom_auxfun_text]} {
    if {$mom_auxfun_text != ""} { MOM_force  once  Text }
 }
 MOM_do_template auxfun
}


#=============================================================
proc PB_CMD_before_motion { } {
#=============================================================
global mom_pos mom_prev_pos
global mom_current_motion
global mom_nxt_motion_event mom_nxt_mcs_goto

#===============================================================================

  global g_plane  ;  set g_plane [CHECK_PLANE]

  global  mom_spindle_speed
  if {[info exists mom_spindle_speed]} {
    if {$mom_spindle_speed==0.0} { MOM_suppress once S M_spindle ; }
  }

 if {[llength [info commands PB_CMD_calc_minmax] ]} {  PB_CMD_calc_minmax  }

 #if {[llength [info commands PB_CMD_calc_delta_axis] ]} {  PB_CMD_calc_delta_axis  }

 global dp dpn
 if {![info exists dp]} {
     for { set ii 0 } { $ii<3 } { incr ii } { set dp($ii) 0. ; }
 }
 if {[info exists mom_current_motion]} {
   if {![info exists mom_prev_pos]} {
     for { set ii 0 } { $ii<3 } { incr ii } { set mom_prev_pos($ii) $mom_pos($ii) ; }
   }
   VEC3_sub mom_pos mom_prev_pos dp
 }
 for { set ii 0 } { $ii<3 } { incr ii } { set dpn($ii) $dp($ii) ; }
 if {[info exists mom_nxt_motion_event]} {
   #if {[string compare $mom_nxt_motion_event "none" ]!=0} { ; }
   VEC3_sub mom_nxt_mcs_goto mom_pos dpn
 } ; # end [info exists mom_nxt_motion_event]
 for { set ii 0 } { $ii<3 } { incr ii } {
   set dp($ii)  [ format "%.4f" $dp($ii) ] ;
   set dpn($ii) [ format "%.4f" $dpn($ii) ] ;
 }

 if {[llength [info commands PB_CMD_calc_motion_distance] ]} {  PB_CMD_calc_motion_distance  }

  global mom_motion_event
  global mom_imported_path_status
  if {[info exists mom_imported_path_status]==1} {
    if {"YES"==[string toupper "$mom_imported_path_status"]} {
     ; #
     if {[info exists mom_motion_event]==1} {
       if {$mom_motion_event!="rapid_move"} {
         global feed ;
         if {$feed>1200.0} {
           set feed 1500.0 ;
           global mom_warning_info
           set mom_warning_info "WARNING: при перекодировке занижена подача до максимальной рабочей =$feed (для Н33)"
           MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
         }
       }
     }
     ; #
   }
  }
}


#=============================================================
proc PB_CMD_circular_move { } {
#=============================================================
# This procedure is executed for each circular move. It gets called after
# the circle data are loaded (end point and center).

 ;# Вывод плоскости обработки
 global g_plane
 if {$g_plane != "NONE"}  { MOM_do_template plane }

 global mom_output_circular_radius
 if {[info exists mom_output_circular_radius]==0} { set mom_output_circular_radius "OFF" ; }

 MOM_suppress once G_slowdn
 catch { PB_slowdn_move } err ; # Учет торможения на углах

 PB_CMD_cutcom

 PB_CMD_cutcom_check

 set str "" ; # строка вывода

 global mom_arc_angle
 if {$mom_output_circular_radius=="ON"} {
     ;#
     SET_SIGN_OF_RADIUS
     MOM_force once Radius
     set str [ MOM_do_template circular_move_radius ]
     ;#
  } else {
     ;#
     global mom_sys_leader
     switch $g_plane {
      "17" { ;# XY
      	   set mom_sys_leader(I) "I"
      	   set mom_sys_leader(J) "J"
      	   set mom_sys_leader(K) "K"
    	  }
      "18" { ;# XZ !!!!!!!!!!!!!!!!!!
          }
      "19" { ;# YZ !!!!!!!!!!!!!!!!!!
        }
     }
     MOM_suppress once K ; MOM_force always  I J
     global mom_output_mode
     switch $mom_output_mode {
      ABSOLUTE { set str [ MOM_do_template circular_move ] }
      default { set str [ MOM_do_template circular_move_incr ] }
     }
     ;#
 }

 if {0!=[regexp -nocase -- {(G)(41)+|(G)(42)+} $str ]} {
     set str1 "\nError! Ошибка включения коррекции\n\tКоррекция включена на окружности - $str"
     CATCH_WARNING $str1
 }

 MOM_suppress off I J K G_slowdn
}


#=============================================================
proc PB_CMD_coolant_off { } {
#=============================================================
   global mom_coolant_mode mom_coolant_status
   if {$mom_coolant_status != "SAME"} {  set mom_coolant_mode OFF ; }
   set mom_coolant_status $mom_coolant_mode
}


#=============================================================
proc PB_CMD_cutcom { } {
#=============================================================
global  flagCutcom_end 	  ; # Переменная конца коррекции
global  flagCutcom_begin  ; # Переменная начала коррекции
global  flagCutcom_output ; # Переменная вывода коррекции
global  countCutcom  ;

  global prev_cutcom_status
  global prev_cutcom_mode
  ;#
  global mom_cutcom_status mom_cutcom_mode
  global mom_nxt_event_count mom_nxt_event

  if {![info exists mom_nxt_event_count]} { return 0 }
  if {$mom_nxt_event_count==0} { return 0 }

  for { set i 0 } {$i<$mom_nxt_event_count} { incr i } {
    if {$mom_nxt_event($i)=="cutcom_off"} {
      if {$flagCutcom_end==0} {
        set flagCutcom_end  1 ; # !!!!!!!!!!!
        ;#if {$countCutcom>1} {

            set prev_cutcom_status $mom_cutcom_status ;
            set prev_cutcom_mode   $mom_cutcom_mode ;

            set mom_cutcom_status "OFF" ;
            set mom_cutcom_mode "OFF" ;
            MOM_force once G_cutcom
         ;#}
       }
    }
    ;# специально ошибся в названии события
    if {$mom_nxt_event($i)=="cutcom"} {
         MOM_suppress once G_cutcom
    }
 }
}


#=============================================================
proc PB_CMD_cutcom_check { } {
#=============================================================
global  flagCutcom_end 	  ; # Переменная конца коррекции
global  flagCutcom_begin  ; # Переменная начала коррекции
global  flagCutcom_output ; # Переменная вывода коррекции
global  countCutcom

 if {$flagCutcom_begin!=1} { return 0 ; }

 incr countCutcom
 if {$flagCutcom_output!=0} { return 0 ; }

 MOM_suppress once G_cutcom

 global dp dpn
 set fl 1
 global g_plane
 switch $g_plane {
     "17" { ;# XY
            if {![ EQ_is_zero $dp(2) ] && [ EQ_is_zero $dp(0) ] && [ EQ_is_zero $dp(1) ]} { set fl 0 }
      	  }
     "18" { ;# XZ
 	    if {![ EQ_is_zero $dp(1) ] && [ EQ_is_zero $dp(0) ] && [ EQ_is_zero $dp(2) ]} { set fl 0 }
     	  }
     "19" { ;# YZ
            if {![ EQ_is_zero $dp(0) ] && [ EQ_is_zero $dp(1) ] && [ EQ_is_zero $dp(2) ]} { set fl 0 }
      	  }
 }
 set flagCutcom_output $fl

 if {$flagCutcom_output==1} {
  	set countCutcom 0 ; # !!!!!!! важно
   	MOM_force once G_cutcom
    PB_CMD_cutcom_div_move
  } else {
   	global mom_seqnum
   	set nm  0 ; catch { set nm [format "%.0f" $mom_seqnum ] }
   	set str1 "Предупреждение!: Включение коррекции (G41|G42) было произведено в кадре N$nm вместе с осью инструмента."
   	append str1 "\n\t !Включение коррекции (G41|G42) должно быть при подходе перпендикулярно к первому элементу контура!"
   	CATCH_WARNING $str1
 }
}


#=============================================================
proc PB_CMD_cutcom_div_move { } {
#=============================================================
 global mom_pos  mom_prev_pos

 return

#
#  Re-calcualte the pos
#
  for {set i 0} {$i < 3} {incr i} {
    set save_pos($i) $mom_pos($i)
    set save_prev_pos($i) $mom_prev_pos($i)
    set mid_pos($i) [expr ($mom_prev_pos($i)+$mom_pos($i))/2.0]
    set mom_pos($i) $mid_pos($i)
  }

  MOM_before_motion

  global mom_motion_event mom_motion_type
  #switch $mom_motion_type {
  #    RAPID   { MOM_rapid_move }
  #    default { MOM_linear_move }
  #}

  if {$mom_motion_event == "rapid_move"} {
       MOM_rapid_move
  } else {
     if {$mom_motion_type == "RAPID"} { MOM_rapid_move ; } else { MOM_linear_move ; }
  }


  for {set i 0} {$i < 3} {incr i} {
    set mom_pos($i) $save_pos($i)
    set mom_prev_pos($i) $mid_pos($i)
  }
}


#=============================================================
proc PB_CMD_cutcom_off { } {
#=============================================================
global mom_cutcom_status  mom_cutcom_mode
# catch {unset mom_cutcom_mode}

  global prev_cutcom_status
  global prev_cutcom_mode

  if {[info exists prev_cutcom_status]} {
    #set mom_cutcom_status "OFF" ; # "OFF" $prev_cutcom_status
    set mom_cutcom_mode   $prev_cutcom_mode   ;
    catch {unset prev_cutcom_status}
    catch {unset prev_cutcom_mode}

    CUTCOM_SET

  }

global  flagCutcom_end 	  ; set flagCutcom_end 	 	0 ; # Переменная конца коррекции
global  flagCutcom_begin  ; set flagCutcom_begin 	0 ; # Переменная начала коррекции
global  flagCutcom_output ; set flagCutcom_output 	0 ; # Переменная вывода коррекции
}


#=============================================================
proc PB_CMD_cutcom_on { } {
#=============================================================
global g_plane ; set g_plane [CHECK_PLANE] ;
set bl [ MOM_do_template plane_cutcom ]
if {$bl==""} { MOM_do_template plane ; }

global  flagCutcom_end 	  ; set flagCutcom_end 	 	0 ; # Переменная конца коррекции
global  flagCutcom_begin  ; set flagCutcom_begin 	1 ; # Переменная начала коррекции
global  flagCutcom_output ; set flagCutcom_output 	0 ; # Переменная вывода коррекции
global  flagCutcom_single ; set flagCutcom_single 	0 ;
global  countCutcom  ; 	    set countCutcom 		0 ;
}


#=============================================================
proc PB_CMD_delay { } {
#=============================================================
  global mom_sys_delay_param mom_delay_value
  global mom_delay_revs mom_delay_mode delay_time
  global mom_warning_info

  switch $mom_delay_mode {
      SECONDS { ; }
      default {
         set mom_warning_info "WARNING: Выдержка времени задана не в СЕКУНДАХ. !"
         MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
      }
  }
  MOM_do_template  delayTMR
  MOM_do_template  delay
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
proc PB_CMD_end_of_program { } {
#=============================================================
# This procedure is executed at the end of the program after all the paths are traversed.
  global  mom_sys_control_out  mom_sys_control_in

  global mom_output_mode
  set mom_output_mode  "ABSOLUTE" ;   # "ABSOLUTE", "INCREMENTAL"
  MOM_set_modes

  global mom_coolant_status
  if {$mom_coolant_status=="UNDEFINED" ||  $mom_coolant_status=="SAME"} { MOM_suppress once M_coolant }

  MOM_do_template  return_motion

  #MOM_output_literal  "(DPI,X,Y)"

#  global mom_tool_number
#  if {$mom_tool_number==0} {
#    MOM_suppress once Text M ; # T
#  } else {
#     MOM_force once Z Text M ; # T
#   }
#  MOM_set_line_leader always  "${mom_sys_control_out} "
#  MOM_do_template  end_of_program_1
#  MOM_force once   Text
#  MOM_do_template  end_of_program_2
#  MOM_force  once  G_motion Z
#  MOM_do_template  end_of_program_3
#  MOM_force  once  X Y
#  MOM_do_template  end_of_program_4
#  MOM_set_line_leader off  "${mom_sys_control_out} "
  MOM_do_template end_of_program_rewind
  MOM_set_seq_off
  global mom_machine_time
  set str0 [format "%.1f" $mom_machine_time ]
  set str2 ""
  if [llength [info commands outTime] ] { set str2 [ outTime $mom_machine_time ] }
  MOM_output_literal "${mom_sys_control_out} Time=${str0}' $str2${mom_sys_control_in}"
}


#=============================================================
proc PB_CMD_from_move { } {
#=============================================================
 set errMes [ MOM_do_template from CREATE ] ;
 MOM_log_message "$errMes" ; # строка вставлена - для не вывода Z из точки FROM....
 MOM_force ONCE G_motion X Y
}


#=============================================================
proc PB_CMD_gohome_move { } {
#=============================================================
# This procedure is called for a GOHOME move
  global mom_sys_home_pos
  MOM_do_template gohome
}


#=============================================================
proc PB_CMD_handle_sync_event { } {
#=============================================================
  global mom_sync_code
  global mom_sync_index
  global mom_sync_start
  global mom_sync_incr
  global mom_sync_max


  set mom_sync_start 	99
  set mom_sync_incr   	1
  set mom_sync_max	199


  if {![info exists mom_sync_code] } {
    set mom_sync_code $mom_sync_start
  }

  set mom_sync_code [expr $mom_sync_code + $mom_sync_incr]

  MOM_output_literal "M$mom_sync_code"
}


#=============================================================
proc PB_CMD_init_helix { } {
#=============================================================
uplevel #0 {
#
# This procedure will be executed automatically at the start of program and
# anytime it is loaded as a slave post of a linked post.
#
# This procedure can be used to enable your post to output helix.
# You can choose from the following options to format the circle
# block template to output the helix parameters.
#

set mom_sys_helix_pitch_type	"rise_radian"

#
# The default setting for mom_sys_helix_pitch_type is "rise_radian".
# This is the most common.  Other choices are:
#
#    "rise_radian"              Measures the rise over one radian.
#    "rise_revolution"          Measures the rise over 360 degrees.
#    "none"                     Will suppress the output of pitch.
#    "other"                    Allows you to calculate the pitch
#                               using your own formula.
#
# This custom command uses the block template circular_move to output
# the helix block.  If your post uses a block template with a different
# name, you must edit the line that outputs the helix block.

#
#  The following variable deines the output mode for helical records.
#
#  FULL_CIRCLE  -- This mode will output a helix record for each 360
#                  degrees of the helix.
#  QUADRANT  --    This mode will output a helix record for each 90
#                  degrees of the helix.
#  LINEAR  --      This mode will output the entire helix as linear gotos.
#  END_POINT --    This mode will assume the control can define an entire
#                  helix in a single block.

   set mom_kin_helical_arc_output_mode FULL_CIRCLE

   MOM_reload_kinematics



#=============================================================
proc MOM_helix_move { } {
#=============================================================
   global mom_pos_arc_plane
   global mom_sys_cir_vector
   global mom_sys_helix_pitch_type
   global mom_helix_pitch
   global mom_prev_pos mom_pos_arc_center
   global PI

   switch $mom_pos_arc_plane {
      XY { MOM_suppress once K ; set cir_index 2 }
      YZ { MOM_suppress once I ; set cir_index 0 }
      ZX { MOM_suppress once J ; set cir_index 1 }
   }

   switch $mom_sys_helix_pitch_type {
      none { }
      rise_revolution { set pitch $mom_helix_pitch }
      rise_radian { set pitch [expr $mom_helix_pitch / ($PI * 2.0)]}
      other {
#
#	Place your custom helix pitch code here
#
      }
      default { set mom_sys_helix_pitch_type "none" }
   }

   MOM_force once X Y Z

   if {$mom_sys_helix_pitch_type != "none"} {
      MOM_force once I J K

      switch $mom_sys_cir_vector {
         "Vector - Arc Center to Start" {
            set mom_prev_pos($cir_index) $pitch
            set mom_pos_arc_center($cir_index) 0.0
         }
         "Vector - Arc Start to Center" {
            set mom_prev_pos($cir_index) 0.0
            set mom_pos_arc_center($cir_index) $pitch
         }
         "Unsigned Vector - Arc Center to Start" {
            set mom_prev_pos($cir_index) 0.0
            set mom_pos_arc_center($cir_index) $pitch
         }
         "Vector - Absolute Arc Center" {
            set mom_pos_arc_center($cir_index) $pitch
         }
      }
   }


#
# You may need to edit this line if you output more than one block
# or if you have changed the name of your circular_move block template
#
    global mom_output_mode
    switch $mom_output_mode {
     ABSOLUTE { MOM_do_template helix_move ; }
     default { MOM_do_template helix_move_incr ; }
    }

    MOM_suppress off I J K


} ;# MOM_helix_move


} ;# uplevel
}


#=============================================================
proc PB_CMD_initial_move_init { } {
#=============================================================
uplevel #0 {

#=============================================================
proc MOM_initial_move { } {
#=============================================================
# This procedure is executed for the initial move of each operation.  It
# assumes the tool is moving from a safe position at rapid to the start of
# the operation.
  global mom_feed_rate mom_feed_rate_per_rev mom_motion_type
  global mom_kin_max_fpm mom_motion_event
  catch { COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET }

  global mom_update_post_cmds_from_tool
  if {[info exists mom_update_post_cmds_from_tool]} {
    if {$mom_update_post_cmds_from_tool==1} {

        global mom_spindle_rpm
        if {[info exists mom_spindle_rpm] != 0} {
         if {$mom_spindle_rpm != 0.0} {
	         MOM_spindle_rpm
         } else {
 	         set mom_warning_info "Warning: SPINDLE RPM IS 0"
 	         MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
         }
        }

    }
   }

  MOM_force once X Y ; # Z
  MOM_force once G_motion G_mode ;

  global mom_motion_event  mom_motion_type
  global mom_programmed_feed_rate  mom_feed_rate  mom_kin_rapid_feed_rate
  if { [EQ_is_equal $mom_programmed_feed_rate 0.0] || [EQ_is_ge $mom_feed_rate $mom_kin_rapid_feed_rate ] } {
      MOM_rapid_move
   } else {
      if {$mom_motion_event == "rapid_move"} { MOM_rapid_move; return ;  }
  	  if {$mom_motion_type == "RAPID"} { MOM_rapid_move ; return ; }
      MOM_linear_move
  }

}

}
}


#=============================================================
proc PB_CMD_insert { } {
#=============================================================
# This procedure is executed when the Insert command is activated.
   global mom_Instruction
   set str [ MOM_string_toupper $mom_Instruction ]
   MOM_output_literal "$str"
   global mom_warning_info
   set mom_warning_info "WARNING: лексический разбор команды 'INSERT/$mom_Instruction' - не производится"
   MOM_output_to_listing_device $mom_warning_info  ; #  MOM_catch_warning ;
}


#=============================================================
proc PB_CMD_kin_before_motion { } {
#=============================================================
}


#=============================================================
proc PB_CMD_kin_end_of_path { } {
#=============================================================
  # Record tool time for this operation.
   if [llength [info commands PB_CMD_set_oper_tool_time] ] {
      PB_CMD_set_oper_tool_time
   }
}


#=============================================================
proc PB_CMD_kin_feedrate_set { } {
#=============================================================
# This procedure supercedes the functionalites provided by the
# FEEDRATE_SET in ugpost_base.tcl.  Post Builder automatically
# generates proper call sequences to this procedure in the
# Event handlers.
#
# This procedure must be used in conjunction with ugpost_base.tcl.
#
  global   feed com_feed_rate
  global   mom_feed_rate_output_mode super_feed_mode feed_mode
  global   mom_cycle_feed_rate_mode mom_cycle_feed_rate
  global   mom_cycle_feed_rate_per_rev
  global   mom_motion_type
  global   mom_warning_info
  global   Feed_IPM Feed_IPR Feed_MMPM Feed_MMPR Feed_INV
  global   mom_sys_feed_param
  global   mom_sys_cycle_feed_mode

  global mom_path_name

  set super_feed_mode $mom_feed_rate_output_mode

  set f_pm [ASK_FEEDRATE_FPM] ; set f_pr [ASK_FEEDRATE_FPR]

  switch $mom_motion_type {

    CYCLE {
      if [info exists mom_sys_cycle_feed_mode] {
         if { $mom_sys_cycle_feed_mode != "Auto" } {
            set mom_cycle_feed_rate_mode $mom_sys_cycle_feed_mode
         }
      }
      if {[hiset mom_cycle_feed_rate_mode]} { set super_feed_mode $mom_cycle_feed_rate_mode }
      if {[hiset mom_cycle_feed_rate]} { set f_pm $mom_cycle_feed_rate }
      if {[hiset mom_cycle_feed_rate_per_rev]} { set f_pr $mom_cycle_feed_rate_per_rev }
    }

    FROM -
    RETRACT -
    RETURN -
    LIFT -
    TRAVERSAL -
    GOHOME -
    GOHOME_DEFAULT -
    RAPID {
      SUPER_FEED_MODE_SET RAPID
    }

    default {
      if {[EQ_is_zero $f_pm] && [EQ_is_zero $f_pr]} {
        SUPER_FEED_MODE_SET RAPID
      } else {
        SUPER_FEED_MODE_SET CONTOUR
      }
    }
  }


  set feed_mode $super_feed_mode


 # Adjust feedrate format per Post output unit again.
  global mom_kin_output_unit
  if { $mom_kin_output_unit == "IN" } {
     switch $feed_mode {
       MMPM {
         set feed_mode "IPM"
         CATCH_WARNING "Feedrate mode MMPM changed to IPM"
       }
       MMPR {
         set feed_mode "IPR"
         CATCH_WARNING "Feedrate mode MMPR changed to IPR"
       }
     }
  } else {
     switch $feed_mode {
       IPM {
         set feed_mode "MMPM"
         CATCH_WARNING "Feedrate mode IPM changed to MMPM"
       }
       IPR {
         set feed_mode "MMPR"
         CATCH_WARNING "Feedrate mode IPR changed to MMPR"
       }
     }
  }


  switch $feed_mode {
    IPM     -
    MMPM    { set feed $f_pm }
    IPR     -
    MMPR    {
    	      #set feed $f_pr
    	      CATCH_WARNING "Operation $mom_path_name \nFeedrate mode MMPR changed to MMPM"
    	      set feed $f_pm
    	      set feed_mode "MMPM"
     }
    DPM     {
    	# set feed [PB_CMD_FEEDRATE_DPM]
    	#returns feed rate in degrees per min
    	CATCH_WARNING "УЧПУ не поддерживает cкорость движения в - DPM. Operation $mom_path_name \nFeedrate mode DPM changed to MMPM"
    	set feed $f_pm
    	set feed_mode "MMPM"
    	#set feed [PB_CMD_FEEDRATE_DPM]
     }
    FRN     -
    INVERSE {
    	# set feed [PB_CMD_FEEDRATE_NUMBER]
    	# returns feed rate number in inverse time
    	CATCH_WARNING "Operation $mom_path_name.- Feedrate mode FRN or INVERSE changed to MMPM"
    	set feed $f_pm
    	set feed_mode "MMPM"
    	#set feed [PB_CMD_FEEDRATE_NUMBER]
     }
    default { set mom_warning_info "INVALID FEED RATE MODE" ; MOM_catch_warning ; return }
  }


 # Post Builder provided format for the current mode:
  if [info exists mom_sys_feed_param(${feed_mode},format)] {
    MOM_set_address_format F $mom_sys_feed_param(${feed_mode},format)
  } else {
    switch $feed_mode {
      IPM     -
      MMPM    -
      IPR     -
      MMPR    -
      DPM     -
      FRN     { MOM_set_address_format F Feed_${feed_mode} }
      INVERSE { MOM_set_address_format F Feed_INV }
    }
  }

 # Commentary output
  set com_feed_rate $f_pm


 # Execute user's commnad, if any.
  if [llength [info commands "PB_CMD_FEEDRATE_SET"]] {
     PB_CMD_FEEDRATE_SET
  }
}


#=============================================================
proc PB_CMD_kin_handle_sync_event { } {
#=============================================================
  PB_CMD_handle_sync_event
}


#=============================================================
proc PB_CMD_kin_init_mill_turn { } {
#=============================================================
}


#=============================================================
proc PB_CMD_kin_init_mill_xzc { } {
#=============================================================
}


#=============================================================
proc PB_CMD_kin_init_rotary { } {
#=============================================================
}


#=============================================================
proc PB_CMD_kin_linearize_motion { } {
#=============================================================
}


#=============================================================
proc PB_CMD_kin_mill_turn_initialize { } {
#=============================================================
}


#=============================================================
proc PB_CMD_kin_mill_xzc_init { } {
#=============================================================
}


#=============================================================
proc PB_CMD_kin_set_csys { } {
#=============================================================
   if [llength [info commands PB_CMD_set_csys] ] {
      PB_CMD_set_csys
   }
}


#=============================================================
proc PB_CMD_kin_start_of_path { } {
#=============================================================
#
#  This procedure is executed at the start of every operation.
#  It will check to see if a new head (post) was loaded and
#  will then initialize any functionality specific to that post.
#
#  It will also restore the initial Start of Program or End
#  of program event procedures.
#
#  DO NOT CHANGE THIS FILE UNLESS YOU KNOW WHAT YOU ARE DOING.
#  DO NOT CALL THIS PROCEDURE FROM ANY OTHER CUSTOM COMMAND.
#
  global mom_sys_head_change_init_program

   if [info exists mom_sys_head_change_init_program] {

      PB_CMD_kin_start_of_program
      unset mom_sys_head_change_init_program


     #<06-17-03 gsl> Moved from MOM_head to
     # execute start of head callback in new post's context.
      global CURRENT_HEAD
      if { [info exists CURRENT_HEAD] &&  [llength [info commands PB_start_of_HEAD__$CURRENT_HEAD]] } {
         PB_start_of_HEAD__$CURRENT_HEAD
      }

      # Restore master start & end of program handlers
      if [llength [info commands "MOM_start_of_program_save"]] {
         if [llength [info commands "MOM_start_of_program"]] {
            rename MOM_start_of_program ""
         }
         rename MOM_start_of_program_save MOM_start_of_program
      }
      if [llength [info commands "MOM_end_of_program_save"]] {
         if [llength [info commands "MOM_end_of_program"]] {
            rename MOM_end_of_program ""
         }
         rename MOM_end_of_program_save MOM_end_of_program
      }

     # Restore master head change event handler
      if [llength [info commands "MOM_head_save"]] {
         if [llength [info commands "MOM_head"]] {
            rename MOM_head ""
         }
         rename MOM_head_save MOM_head
      }
   }

  # Initialize tool time accumulator for this operation.
   if [llength [info commands PB_CMD_init_oper_tool_time] ] {
      PB_CMD_init_oper_tool_time
   }

  # Force out motion G code at the start of path.
   MOM_force once G_motion
}


#=============================================================
proc PB_CMD_kin_start_of_program { } {
#=============================================================
#
#  This procedure will execute the following custom commands for
#  initialization.  They will be executed once at the start of
#  program and again each time they are loaded as a linked post.
#  After execution they will be deleted so that they are not
#  present when a different post is loaded.  You may add a call
#  to a procedure that you want executed when a linked post is
#  loaded.
#
#  Note that when a linked post is called in, the Start of Program
#  event marker is not executed again, neither is this procedure.
#
#  DO NOT REMOVE ANY LINES FROM THIS PROCEDURE UNLESS YOU KNOW
#  WHAT YOU ARE DOING.  DO NOT CALL THIS PROCEDURE FROM ANY
#  OTHER CUSTOM COMMAND.
#
   global mom_kin_machine_type


   set command_list [list]

   if [info exists mom_kin_machine_type] {
      if { ![string match "*3_axis_mill*" $mom_kin_machine_type] &&  ![string match "*lathe*" $mom_kin_machine_type] } {

         lappend command_list  PB_CMD_kin_init_rotary
      }
   }

   lappend command_list  PB_CMD_init_pivot_offsets
   lappend command_list  PB_CMD_init_auto_retract
   lappend command_list  PB_CMD_initialize_parallel_zw_mode
   lappend command_list  PB_CMD_init_parallel_zw_mode
   lappend command_list  PB_CMD_initialize_tool_list
   lappend command_list  PB_CMD_init_tool_list
   lappend command_list  PB_CMD_init_tape_break
   lappend command_list  PB_CMD_initialize_spindle_axis
   lappend command_list  PB_CMD_init_spindle_axis
   lappend command_list  PB_CMD_initialize_helix
   lappend command_list  PB_CMD_init_helix
   lappend command_list  PB_CMD_pq_cutcom_initialize
   lappend command_list  PB_CMD_init_pq_cutcom
   lappend command_list  PB_CMD_init_new_iks

   if [info exists mom_kin_machine_type] {
      if { [string match "*3_axis_mill_turn*" $mom_kin_machine_type] } {

          lappend command_list  PB_CMD_kin_init_mill_xzc
          lappend command_list  PB_CMD_kin_mill_xzc_init
          lappend command_list  PB_CMD_kin_init_mill_turn
          lappend command_list  PB_CMD_kin_mill_turn_initialize
      }
   }

   foreach cmd $command_list {

      if [llength [info commands "$cmd"]] {

         # <PB v2.0.2>
         # Old init commands for XZC/MILL_TURN posts are not executed.
         # Parameters set by these commands in the v2.0 legacy posts
         # will need to be transfered to PB_CMD_init_mill_xzc &
         # PB_CMD_init_mill_turn commands respectively.

         switch $cmd {
            "PB_CMD_kin_mill_xzc_init" -
            "PB_CMD_kin_mill_turn_initialize" {}
            default { $cmd }
         }
         rename $cmd ""
         proc $cmd { args } {}
      }
   }
}


#=============================================================
proc PB_CMD_length_compensation { } {
#=============================================================
  MOM_force once G_motion G Z T M
  catch { MOM_do_template tool_length_adjust } errMes ; MOM_log_message $errMes
}


#=============================================================
proc PB_CMD_linear_move { } {
#=============================================================
 MOM_suppress once G_slowdn
 catch { PB_slowdn_move } err ; # Учет торможения на углах

# мне кажется что все что мы сделали насчет коррекции это лабуда!!
# можно спокойно выводить просто как на обычных УЧПУ
#

 PB_CMD_cutcom

 PB_CMD_cutcom_check

 MOM_do_template linear_move

 MOM_suppress off G_slowdn
}


#=============================================================
proc PB_CMD_linearize_motion { } {
#=============================================================
}


#=============================================================
proc PB_CMD_load_tool { } {
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
proc PB_CMD_machine_mode { } {
#=============================================================
  global mom_output_mode mom_arc_mode mom_prev_machine_mode mom_machine_mode mom_feed_set_mode
  set mom_output_mode     	"ABSOLUTE"
  set mom_prev_machine_mode  	"MILL"
  set mom_machine_mode 		"MILL"
  set mom_arc_mode     		"CIRCULAR"
  set mom_feed_set_mode 	"MMPR"

  MOM_force Once G_plane G_mode
}


#=============================================================
proc PB_CMD_manual_tool_change { } {
#=============================================================
   MOM_force once  G_motion Z
   MOM_do_template machine_system_move
   MOM_do_template stop
   MOM_force once G_motion

   PB_CMD_start_of_alignment_character

   MOM_force Once T M
   catch { MOM_do_template tool_change } errMes ; MOM_log_message "$errMes"
   catch { MOM_do_template tool_change_next CREATE } errMes ; MOM_log_message "$errMes"

   PB_CMD_end_of_alignment_character
}


#=============================================================
proc PB_CMD_nurbs_move { } {
#=============================================================
#_______________________________________________________________________________
# This procedure is executed for each nurbs move.
#_______________________________________________________________________________
  global mom_nurbs_knot_count
  global mom_nurbs_point_count
  global mom_nurbs_order

  global mom_warning_info
  set mom_warning_info "Система УЧПУ не поддерживает nurbs-интерполяцию\n - используйте обычную линейно-круговую интерполяцию."
  MOM_output_to_listing_device $mom_warning_info  ; MOM_catch_warning
  MOM_abort "\n\n\t $mom_warning_info \n\n"
}


#=============================================================
proc PB_CMD_operator_message { } {
#=============================================================
#__This procedure is executed when the Operator Message command is activated.
 global  mom_operator_message  mom_operator_message_defined
 global  mom_operator_message_type ;
 if {![info exists mom_operator_message]} { return }
 if {$mom_operator_message==""} {
    MOM_output_literal "(DIS,\"....\")"
    return
 }
 set var0 ""
 if {0==[regexp -- {(UCG)+}  $mom_operator_message  var0 ]} {
    MOM_output_literal "(DIS,\"$mom_operator_message\")" ;
 }
}


#=============================================================
proc PB_CMD_opstop { } {
#=============================================================
   MOM_do_template opstop
}


#=============================================================
proc PB_CMD_origin { } {
#=============================================================
  global mom_origin_point ;
  global mom_warning_info ;
  set mom_warning_info "WARNING: Смещение координат X, Y, Z - будьте внимательны"
  MOM_output_to_listing_device $mom_warning_info  ; #  MOM_catch_warning ;
}


#=============================================================
proc PB_CMD_pause { } {
#=============================================================
# This command enables you to pause the UG/Post processing.
#
  PAUSE
}


#=============================================================
proc PB_CMD_pprint { } {
#=============================================================
#___ This procedure is executed when the Text command is activated.
 global  mom_sys_control_out  mom_sys_control_in
 global mom_pprint
 MOM_set_seq_off
 MOM_output_literal  "${mom_sys_control_out} $mom_pprint ${mom_sys_control_in}"
 MOM_set_seq_on
}


#=============================================================
proc PB_CMD_prefun { } {
#=============================================================
# This procedure is executed when the Preparatory function command is activated.
  global mom_prefun_text
  MOM_suppress once Text
  if {[info exists  mom_prefun_text]} {
     if {$mom_prefun_text != ""} { MOM_force  once  Text }
  }
  MOM_do_template prefun
}


#=============================================================
proc PB_CMD_rapid_move { } {
#=============================================================
  #global rapid_spindle_inhibit rapid_traverse_inhibit
  #global spindle_first is_from
  #global mom_cycle_spindle_axis traverse_axis1 traverse_axis2
  #global mom_motion_event

  #set aa(0) X ; set aa(1) Y ; set aa(2) Z

  #set rapid_traverse_blk {G_cutcom G_motion G_mode X Y Z}
  #set rapid_traverse_mod {}
  #PB_SET_RAPID_MOD $rapid_traverse_mod $rapid_traverse_blk aa mod_traverse
  #PB_FORCE Once $mod_traverse

  PB_CMD_cutcom

  PB_CMD_cutcom_check

  #MOM_do_template rapid_traverse
}


#=============================================================
proc PB_CMD_reprocess { } {
#=============================================================

return

global mom_sys_control_out mom_sys_control_in
global mom_warning_info
global ptp_file_name
global mom_machine_time

set tmp_file_name "${ptp_file_name}_.nc110"
if {[file exists $tmp_file_name]} { MOM_remove_file $tmp_file_name ; }

MOM_close_output_file $ptp_file_name

set err ""
catch { file rename $ptp_file_name $tmp_file_name } err
if {$err!=""} {
  set mom_warning_info "\n\n\n ВНИМАНИЕ: невозможно заменить или создать УП !!\n УП где-то используется (в Vericut'e ?)!!\n\n"
  MOM_abort $mom_warning_info
}

set ifile [open $tmp_file_name r]
set ofile [open $ptp_file_name w]

set minStr ""
set maxStr ""
set osi { X Y Z B C }
global min_pos  max_pos
for { set ii 0 } { $ii<3 } { incr ii } {
     set min_pos($ii) [format "%+.3f" $min_pos($ii) ]
     set max_pos($ii) [format "%+.3f" $max_pos($ii) ]
     if [llength [info commands int_value] ] {
        set min_pos($ii) [ int_value $min_pos($ii) ] ;
        set max_pos($ii) [ int_value $max_pos($ii) ] ;
      }
}
for { set ii 0 } { $ii<3 } { incr ii } {
     set min_pos($ii) [ expr ceil($min_pos($ii))-1.0 ]
     append minStr " [ lindex $osi $ii ][format "%+.0f" $min_pos($ii) ]"
     set max_pos($ii) [ expr ceil($max_pos($ii)) ]
     append maxStr " [ lindex $osi $ii ][format "%+.0f" $max_pos($ii) ]"
}

#===================================
  set str2 ""
  if [llength [info commands outTime ]] { set str2 [ outTime $mom_machine_time ]  }

  set tm1 [ expr ceil($mom_machine_time) ]
  set line1 [format "${mom_sys_control_out}Time=%.1f' %s ${mom_sys_control_in}" $tm1 $str2 ]
#===================================

set fl_tm 0 ; # флаг вывода времени
set fl_blk 0 ; # флаг вывода blk
set i 1
set buf ""
while { [gets $ifile buf] > 0 } {

  ;# Обработка кадров с комментариями
  if {$fl_tm==0} {
  	if {[regexp -nocase -- "${mom_sys_control_out}Time="  $buf ]} {
       set bufstr ""
       regsub -nocase -- "${mom_sys_control_out}Time=" $buf  "$line1"  bufstr
       set buf $bufstr
       set fl_tm 1
    }
  }

  ;# Обработка кадров с UGC
  if {$fl_blk==0} {
       set fl_blk 1
  }

	puts $ofile $buf
}

  close $ifile
  flush $ofile
  close $ofile
  MOM_remove_file $tmp_file_name
  MOM_open_output_file $ptp_file_name
  return
}


#=============================================================
proc PB_CMD_set_csys { } {
#=============================================================
#  This custom command is provided as the default to nullify
#  the same command in a linked post that may have been
#  imported from pb_cmd_coordinate_system_rotation.tcl.
}


#=============================================================
proc PB_CMD_set_cycle_plane { } {
#=============================================================
#
# Use this command to determine and output proper plane code
# when G17/18/19 is used in the cycle definition.
#


 #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 # This option can be set to 1, if the address of cycle's
 # principal axis needs to be suppressed. (Ex. siemens controller)
 #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  set suppress_principal_axis 0


 #++++++++++++++++++++++++++++++++++++++++++++++++++++++
 # This option can be set to 1, if the plane code needs
 # to be forced out @ the start of every set of cycles.
 #++++++++++++++++++++++++++++++++++++++++++++++++++++++
  set force_plane_code 0


  global mom_kin_machine_type
  global mom_kin_4th_axis_type mom_kin_4th_axis_plane
  global mom_kin_5th_axis_type
  global mom_tool_axis mom_sys_spindle_axis mom_kin_spindle_axis
  global mom_pos
  global mom_cycle_spindle_axis mom_cutcom_plane mom_pos_arc_plane


 # Default cycle spindle axis to Z
  set mom_cycle_spindle_axis 2


  if { ![string match "*3_axis_mill*" $mom_kin_machine_type] } {

    if { $mom_kin_4th_axis_type == "Head" } {

      if [EQ_is_equal [expr abs($mom_tool_axis(0))] 1.0] {
        set mom_cycle_spindle_axis 0
      }

      if [EQ_is_equal [expr abs($mom_tool_axis(1))] 1.0] {
        set mom_cycle_spindle_axis 1
      }

      if { $mom_kin_5th_axis_type == "Table" } {

        if { [EQ_is_equal [expr abs($mom_pos(3))] 90.0] || [EQ_is_equal [expr abs($mom_pos(3))] 270.0] } {

          switch $mom_kin_4th_axis_plane {
            "YZ" {
              set mom_cycle_spindle_axis 1
            }
            "ZX" {
              set mom_cycle_spindle_axis 0
            }
          }
        }
      }
    }
  }


  switch $mom_cycle_spindle_axis {
    0 {
      set mom_cutcom_plane  YZ
      set mom_pos_arc_plane YZ
      set principal_axis X
    }
    1 {
      set mom_cutcom_plane  ZX
      set mom_pos_arc_plane ZX
      set principal_axis Y
    }
    2 {
      set mom_cutcom_plane  XY
      set mom_pos_arc_plane XY
      set principal_axis Z
    }
    default {
      set mom_cutcom_plane  UNDEFINED
      set mom_pos_arc_plane UNDEFINED
      set principal_axis ""
    }
  }


  if { $suppress_principal_axis && [string length $principal_axis] > 0 } {
    MOM_suppress once $principal_axis
  }


  if { $force_plane_code } {
    global cycle_init_flag

    if { [info exists cycle_init_flag] && [string match "TRUE" $cycle_init_flag] } {
      MOM_force once G_plane
    }
  }
}


#=============================================================
proc PB_CMD_set_modes { } {
#=============================================================
   global mom_machine_mode  mom_feed_set_mode  mom_feed_rate_output_mode
   global mom_output_mode  mom_arc_mode
   global mom_parallel_to_axis  mom_modes_text
   global mom_warning_info

; # "ABSOLUTE", "INCREMENTAL"
  switch $mom_output_mode {
    ABSOLUTE { set isincr OFF }
    default  { set isincr ON }
  }
  MOM_incremental $isincr X Y Z

; # "LINEAR", "CIRCULAR"
  if {$mom_arc_mode == "LINEAR"} {
  } elseif {$mom_arc_mode == "CIRCULAR"} {
  }

# "OFF", "IPM", "IPR", "MMPM", "MMPR", "INVERSE"
  switch $mom_feed_rate_output_mode {
    MMPM { ; }
    OFF  { ; }
    default  { ; }
  }

# "ZAXIS", "WAXIS", "UAXIS"
  switch $mom_parallel_to_axis {
    ZAXIS { ; }
    default  {
       set mom_warning_info "WARNING: Осью инструмента является Ось Z (принудительно будет установлена ось Z)"
       MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
       set mom_parallel_to_axis  "ZAXIS"
     }
  }

# "MILL", "TURN", "PUNCH", "LASER", "TORCH", "WIRE"
  switch $mom_machine_mode {
    MILL { ; }
    TURN { MOM_output_literal "(CTL, T)" ; }
    default  {
       set mom_warning_info "WARNING: данный постпроцессор разработан для токарно-фрезерного станка типа 2.5 (принудительно будет установлен станок MILL)"
       MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
       set  mom_machine_mode  "MILL"
     }
  }

   global mom_prefun  mom_prefun_text
   ;# Обработка COARSE/FINE
   if {[info exists  mom_modes_text]} {
      switch [string toupper $mom_modes_text] {
        COARSE {
            set mom_prefun 27 ; MOM_prefun ;
            set mom_warning_info "WARNING: Включена стандартная обработка углов в режимах линейной и круговой интерполяции. (По умолчанию код G$mom_prefun)\n"
            append mom_warning_info "\t Непрерывный режим обработки с автоматическим замедлением скорости на углах\n"
            append mom_warning_info "\t - Для данного режима рекомендуем установить режим вывода круговой интерполяции mom_arc_mode=CIRCULAR"
            MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
          }
        FINE {
            set mom_prefun 28 ; MOM_prefun ;
            set mom_warning_info "WARNING: Включена обработка углов в режимах линейной и круговой интерполяции (Код G$mom_prefun)\n"
            append mom_warning_info "\t Непрерывный режим обработки без замедления скорости на углах\n"
            append mom_warning_info "\t Для данного режима рекомендуем установить режим вывода круговой интерполяции mom_arc_mode=LINEAR"
            MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
          }
         default {
          set mom_warning_info "WARNING: Неизвестная команда \[$mom_modes_text\]. Событие \[MOM_set_modes\]"
          MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
         }
      }
   }
}


#=============================================================
proc PB_CMD_small_motion { } {
#=============================================================
  global mom_motion_distance mom_kin_machine_resolution ;
  set fl 0 ;
  if {$mom_motion_distance<$mom_kin_machine_resolution} { set fl 1 ; }
  return $fl
}


#=============================================================
proc PB_CMD_spindle_off { } {
#=============================================================
# This procedure is executed when the Spindle command is deactivated.
   global mom_spindle_text   mom_spindle_direction
   if {[info exists  mom_spindle_text]} {
      if {[string toupper $mom_spindle_text]=="ORIENT"} {
           set mom_warning_info "WARNING: включена ориентация шпинделя (M19)"
           MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
           MOM_force once M_spindle
           MOM_do_template spindle_orient
      	}
   }
}


#=============================================================
proc PB_CMD_spindle_on { } {
#=============================================================
# This procedure is executed when the Spindle command is activated.
   global mom_spindle_text   mom_spindle_direction
   global mom_spindle_speed

   if {[info exists  mom_spindle_direction]} {
      if {[string toupper $mom_spindle_direction]=="ORIENT"} {
           set mom_warning_info "WARNING: включена ориентация шпинделя (M19)\n"
           MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
           MOM_do_template spindle_orient
           return ;
      	}
   }

   if {[info exists  mom_spindle_text]} {
      if {[string toupper $mom_spindle_text]=="ORIENT"} {
      	   set mom_spindle_direction  "ORIENT" ;
           set mom_warning_info "WARNING: включена ориентация шпинделя (M19)\n"
           MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
           MOM_do_template spindle_orient
           return ;
      	}
   }

  if [llength [info commands PB_CMD_spindle_rpm_range_select] ] {
    PB_CMD_spindle_rpm_range_select
  }

  MOM_force Once S M_spindle M_range
  MOM_do_template  spindle_range
  MOM_do_template  spindle_rpm
}


#=============================================================
proc PB_CMD_spindle_rpm_range_select { } {
#=============================================================
#
#  This procedure will output RPM mode only.  use this in mill posts.
#
#  This procedure will select the appropriate spindle range based
#  on the spindle table provided in post builder.  This procedure
#  will generate the mom variable mom_spindle_range which is
#  used in the WORD M_range.  The user must define the code for the
#  mom_variable mom_sys_spindle_range_code($mom_range_code).  By
#  default this is an m code.  You can change it to any code desired
#  by making the M_range leader blank, the format string and the  code any text needed.
#
#  You must place the word M_range in the appropriate block template.
#  You must place this custom command in a block before you output the spindle range code.
#

 global mom_sys_spindle_param   mom_sys_spindle_ranges
 global mom_spindle_mode  mom_spindle_range
 global mom_spindle_rpm mom_spindle_sfm mom_spindle_speed

 if {[info exists mom_spindle_range]} {
   if [catch {expr {2 * $mom_spindle_range}}] { set mom_spindle_range 1 ; }
 } else { set mom_spindle_range 1 ; }

 if {![info exists mom_sys_spindle_param]} { return ; }

 if {[info exists mom_spindle_rpm] && $mom_spindle_rpm > 0.0} {
    set speed $mom_spindle_rpm
  } else {
    set speed $mom_spindle_speed
 }

 if {![info exists mom_sys_spindle_ranges]} { set mom_sys_spindle_ranges 2 ; }

 for {set i 1} {$i <= $mom_sys_spindle_ranges} {incr i} {
  if {$speed > $mom_sys_spindle_param($i,min) && $speed < $mom_sys_spindle_param($i,max) } {

    if {$speed > $mom_sys_spindle_param(2,min) && $speed < $mom_sys_spindle_param(1,max) } {
       MOM_output_to_listing_device "Предупреждение! Заданная скорость вращения шпинделя находится в 2-х диапазонах"
       MOM_output_to_listing_device "\tУточните диапазон!(? Задайте скорость, диапазон - через ПостПроцессорные команды)"
       return
    }
    set mom_spindle_range $i
    return
  }

 }
  set mom_spindle_range 1 ;
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
  #set mom_sys_leader(N) ":"
}


#=============================================================
proc PB_CMD_start_of_header { } {
#=============================================================
  global  mom_warning_info

  return

  set mom_warning_info "\nПостпроцессор для системы NC110-210 (коды ISO)."
  MOM_output_to_listing_device $mom_warning_info  ; #  MOM_catch_warning ;

  set mom_warning_info "\nИсходные функции:\n"
  append mom_warning_info "\tG00 - быстрое позиционирование осей\n"
  append mom_warning_info "\tG17 - выбор плоскости (XY)\n"
  append mom_warning_info "\tG27 - Непрерывный режим обработки с автоматическим замедлением скорости на углах (черновой режим)\n"
  append mom_warning_info "\tG20 - выход из программы GTL\n"
  append mom_warning_info "\tG40 - отмена коррекции радиуса инструмента\n"
  append mom_warning_info "\tG71 - программа в mm\n"
  append mom_warning_info "\tG80 - отмена постоянных циклов\n"
  append mom_warning_info "\tG90 - размер в абсолютных координатах\n"
  append mom_warning_info "\tG95 - скорость подачи в мм/об или (дюйм/об)\n"
  append mom_warning_info "\tG96 - скорость резания в м/мин или (фут/мин)\n"
  MOM_output_to_listing_device $mom_warning_info  ; #  MOM_catch_warning ;

#  set mom_warning_info "Используемые коды:\n"
#  append mom_warning_info " 1. Коды назначения глобальных переменных системы:\n"
#  append mom_warning_info "\tTMR - определение выдержки времени: TMR=n\n"
#  append mom_warning_info "\tUOV - определение припуска: UOV=n\n"
#  append mom_warning_info "\tERF - максимальная ошибка формы: ERF=n n-предел отклонения от профиля при торможении (при активной G27)\n"
#  append mom_warning_info "\tMCD - максимальное отклонение направляющих косинусов: MCD={1 2} -максимальный угол для осей для торможения (при активной G27)\n"
#  append mom_warning_info " 2. Коды, модифицирующие систему отсчета осей:\n"
#  append mom_warning_info "\tUAO - использование абсолютных начальных точек: (UAO,n\[,ось1,ось2,..,осьn\])\n"
#  append mom_warning_info "\tUOT - определение и использование временных начальных точек: (UOT,n,ось1\[,ось2,..,осьn\])\n"
#  append mom_warning_info "\tUIO - определение и использование начальных точек по приращениям: (UIO,ось1\[,ось2,..,осьn\])\n"
#  append mom_warning_info "\tMIR - зеркальная обработка: (MIR \[,ось1,.,осьn\])\n"
#  append mom_warning_info "\tURT - поворот плоскости: (URT, n) n-угол\n"
#  append mom_warning_info "\tSCF - масштабирование: (SCF\[n \[,ось1,ось2,..,осьm\] \])\n"
#  append mom_warning_info "\tRQO - модификация начальной точки: (RQO,n,ось1 \[,ось2,..,осьn\])\n"
#  append mom_warning_info " 3. Коды, изменяющие последовательность выполнения программы:\n"
#  append mom_warning_info "\tRPT - повторение частей программы: (RPT,n) n-число повторений\n"
#  append mom_warning_info "\tERP - конец повторения части программы: (ERP)\n"
#  append mom_warning_info "\tEPP - повторение части программы между метками: (EPP,метка_начала,метка_конца)\n"
#  append mom_warning_info "\tCLS - использование подпрограммы : (CLS,имя_файла/директория)\n"
#  append mom_warning_info " 4. Трехбуквенные операторы ввода/вывода:\n"
#  append mom_warning_info "\tDIS - вывод переменной на экран: (DIS,\"сообщение\",var)\n"
#  append mom_warning_info "\tDLY - выдержка времени: (DLY,n) - n=0..32 (нуждается в синхронизации - #)\n"
#  append mom_warning_info "\tUCG - определение графического дисплея (UCG,{1,2},ось1min ось1max ,ось2min ось2max \[,ось3\]) \n"
#  append mom_warning_info "\tCLG - очистка графического дисплея: (CLG)\n"
#  append mom_warning_info "\tDCG - отмена графического дисплея: (DCG)\n"
#  append mom_warning_info " 5. Трехбуквенные смешанные операторы:\n"
#  append mom_warning_info "\tDSA - определяет защищенную зону: (DSA,n,ось1min ось1max ,ось2min ось2max)\n"
#  append mom_warning_info "\tASC - активизирует защищенную зону: (ASC,n)\n"
#  append mom_warning_info "\tDSC - деактивизирует защищенную зону: (DSC,n)\n"
#  append mom_warning_info "\tRQU - изменение коррекции инструмента и файла корректоров :(RQU,№номер_инструмента,№номер_корректора,Zизменение_длины,Kизменение_диаметра)\n"
#  append mom_warning_info "\tRQP - изменение коррекции инструмента (файл корректоров не изменяется):(RQP,№номер_инструмента,№номер_корректора,Zизменение_длины,Kизменение_диаметра)\n"
#  append mom_warning_info "********************************************************************************\n"
#
#  MOM_output_to_listing_device $mom_warning_info  ; #  MOM_catch_warning ;
  set mom_warning_info ""
}


#=============================================================
proc PB_CMD_start_of_operation_force_addresses { } {
#=============================================================
  MOM_force once S M_spindle X Y Z F
}


#=============================================================
proc PB_CMD_start_of_path { } {
#=============================================================
  global mom_operation_name
  global mom_warning_info
  global mom_sys_control_out  mom_sys_control_in

  catch { CHECK_OPER_TYPE } err

  global mom_imported_path_status
  global mom_kin_arc_output_mode
  if {[info exists mom_imported_path_status]==1} {
     if {"YES"==[string toupper "$mom_imported_path_status"]} {
       set mom_warning_info "WARNING: операция=$mom_operation_name - является импортированной (пожалуйста - будьте внимательны !)"
       MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
       set mom_kin_arc_output_mode  "QUADRANT"  ;   #QUADRANT  FULL_CIRCLE , LINEAR
       MOM_reload_kinematics
     }
  }

  MOM_set_seq_off
  MOM_output_literal " ${mom_sys_control_out} $mom_operation_name ${mom_sys_control_in}"
  MOM_set_seq_on
}


#=============================================================
proc PB_CMD_start_of_program { } {
#=============================================================
  global  mom_warning_info
  global  mom_output_file_basename
  global  mom_logname  mom_date
  global  mom_part_name
  global  mom_machine_name
  global  mom_ug_version
  global  mom_sys_control_out  mom_sys_control_in

# для расчета мини-макс положения
global min_pos  max_pos
for { set ii 0 } {$ii<5} { incr ii } {
  set min_pos($ii) 99999.999
  set max_pos($ii) -99999.999
}

uplevel #0 {
  set mom_kin_nurbs_output_type                 "BSPLINE"
  set mom_kin_coordinate_type                   "CARTESIAN"
  set mom_kin_read_ahead_next_motion            "1"
  MOM_reload_kinematics
}

# Переменные для вывода коррекции
global  flagCutcom_end 	  ; set flagCutcom_end 	 	0 ; # Переменная конца коррекции
global  flagCutcom_begin  ; set flagCutcom_begin 	0 ; # Переменная начала коррекции
global  flagCutcom_output ; set flagCutcom_output 	0 ; # Переменная вывода коррекции
global  flagCutcom_single ; set flagCutcom_single 	0 ;
global  countCutcom  ; 	    set countCutcom 		0 ;

  ;# Переменная отвечающая за вид вывода кадра с окружностью
  global mom_output_circular_radius ;
  set mom_output_circular_radius "OFF" ; # OFF - {G2|G3}{X Y Z}{I J};  ON - {G2|G3}{X Y Z} R ;
  ;# если устанавливать переменную в "ON", то неох
  ;#   установить mom_kin_arc_output_mode="QUADRANT"

  global mom_sys_rewind_stop_code
  set str "$mom_sys_rewind_stop_code"

  global partno_program
  if {[info exists partno_program]} {
    if {$partno_program != ""} { append str $partno_program }
   }

  MOM_set_seq_off
  MOM_output_literal "$str"
  set strname ""
  if [llength [info commands PB_part_name_ex] ] {
       set strname [ PB_part_name_ex ]
       set strname [ MOM_string_toupper $strname ]
  } else {
  	if [llength [info commands MOM_ask_part_attr] ] {
  	   set strname [ MOM_ask_part_attr ]
  	}
  }
  set strmaterial "" ;
  if [llength [info commands PB_part_material] ] { set strmaterial [ PB_part_material ] ; }
  MOM_output_literal "${mom_sys_control_out}Part: $strname ${mom_sys_control_in}"
  MOM_output_literal "${mom_sys_control_out}Program: $mom_output_file_basename ${mom_sys_control_in}"
  MOM_output_literal "${mom_sys_control_out}Material: $strmaterial ${mom_sys_control_in}"
  MOM_output_literal "${mom_sys_control_out}MACHINE: $mom_machine_name ${mom_sys_control_in}"
  MOM_output_literal "${mom_sys_control_out}$mom_logname, Date:$mom_date ${mom_sys_control_in}"
  MOM_output_literal "${mom_sys_control_out}GENERATE:${mom_ug_version} ${mom_sys_control_in}"
  MOM_output_literal "${mom_sys_control_out}Time=${mom_sys_control_in}"
  MOM_output_literal "    "
  MOM_set_seq_on

  MOM_output_literal "(UAO,1)"

  global mom_sys_leader
  MOM_output_literal "(UCG,2, $mom_sys_leader(X)-100 $mom_sys_leader(X)100, $mom_sys_leader(Y)-100 $mom_sys_leader(Y)100 ,$mom_sys_leader(Z))"

  #MOM_output_literal "(DPI,X,V)"

# Константы для торможения
 global   SLOWDN_MIN_ANGLE  SLOWDN_MAX_FEED  SLOWDN_ACCELERATION
 global   mom_modes_slowdn  mom_modes_slowdn_feed
 global   mom_slowdn_min_angle  mom_slowdn_max_feed
  set SLOWDN_MIN_ANGLE     "180.0"
  set SLOWDN_MAX_FEED      "600.0"
  set SLOWDN_ACCELERATION  "5"
# Включен режим торможения
  set mom_modes_slowdn       "ON" ;
  set mom_modes_slowdn_feed  "ON"  ;
  set mom_slowdn_min_angle $SLOWDN_MIN_ANGLE ;
  set mom_slowdn_max_feed  $SLOWDN_MAX_FEED ;

  if [llength [info commands PB_slowdn_load] ] { PB_slowdn_load }
}


#=============================================================
proc PB_CMD_stop { } {
#=============================================================
  MOM_spindle_off
  MOM_do_template stop
}


#=============================================================
proc PB_CMD_text { } {
#=============================================================
# This procedure is executed when the Text command is activated.
#=============================================================
  global mom_sys_control_out mom_sys_control_in
  global mom_user_defined_text mom_record_fields mom_field_count mom_record_text
  global mom_Instruction
  global mom_pprint mom_pprint_defined
  global mom_operator_message_defined mom_operator_message
  global mom_warning_info

  switch [string toupper $mom_record_fields(0)] {
   "SET"  { ; }
  "PPRINT" {
           set mom_pprint_defined 1
           set mom_pprint $mom_record_text
           MOM_pprint
           }
  "DISPLY" {
           set mom_operator_message_defined 1
           set mom_operator_message $mom_record_text
           MOM_operator_message
          }
  "INSERT" {
           if {[info exists mom_record_fields(1)]}  {
              set mom_Instruction [string toupper $mom_record_text ] ; #$mom_record_fields(1)] ;
              MOM_insert
              set mom_warning_info "WARNING: лексический разбор команды 'INSERT/$mom_Instruction' - не производится"
              MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
           }
         }
  "PARTNO" { ; # Наименование программы (заголовок)
           global partno_program ; set partno_program  "" ;
           set str "User Defined"
           if {[info exists  mom_record_fields(1)]} {
             set partno_program $mom_record_text ; # $mom_record_fields(1)
           }  else  {
              set RNseed [clock clicks] ;
              set RNseed [expr (30903 * ($RNseed & 65535) + ($RNseed>>16))]
              set RNseed [expr (($RNseed & 65535)/65535.0)]
              set RNseed [expr $RNseed*100000.0]
              set RNseed [expr int($RNseed)]
              set partno_program [format "%5d" $RNseed]
              set str "случ."
           }
           set mom_warning_info "<!--\n PARTNO->Опция \[Наименование программы (заголовок) - ! только для группы\]=$partno_program ($str)\n-->"
           MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
         }
  "END" {
  	        global mom_sys_end_of_program_code  mom_sys_rewind_code
  	        set mom_sys_rewind_code  $mom_sys_end_of_program_code ;
            set mom_warning_info "<!--\n END->Опция \[Конец программы\]=M02;\n-->"
            MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
           }
 "MIRROR" {  ; # Зеркальное отображение
             #catch { PB_mirror }
             set mom_warning_info "WARNING: для задания зеркальной программы - мы рекомендуем воспользоваться \n встроенной функцией  MIR -> (MIR \[,ось1,.,осьn\]) \n отмена (MIR) \n\t данные функции рекомендуем вставлять Insert\/... \n"
             MOM_output_to_listing_device $mom_warning_info  ; #  MOM_catch_warning ;
        }
 "MACALL" { ; # Вызов подпрограммы
            set str "" ;
            if {[info exists  mom_record_fields(1)]} {
              set str $mom_record_text ; # $mom_record_fields(1)
            }
            MOM_output_literal "(CLS,$str)"
            set mom_warning_info "<!--\n MACALL->Опция \[Вызов подпрограммы\]=$str ;\n-->"
            MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
          }
  "MACND" { ; # Конец подпрограммы
           MOM_output_literal "(ERP)"
           set mom_warning_info "<!--\n MACND->Опция \[Конец подпрограммы\];\n-->" ; MOM_output_to_listing_device $mom_warning_info  ; MOM_catch_warning ;
           }
  "MACST" {
           set mom_warning_info "<!--\n MACST->Опция \[Начало (объявление) подпрограммы\] - не обрабатывается;\n-->" ; MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
           }
  "STLOOP" { ; # Вызов повторения последовательности
           set n 0
           if {[info exists mom_record_fields(1)]} {
             set str  $mom_record_fields(1);
             if [catch {expr {2 * $str}}] { set str 0 ; }
             if {$str<0} { set str 0 ; }
             set n [ expr int($str) ] ;
           }
           set str "" ;
           for { set i 2 } { $i<$mom_field_count } { incr i } {
            if {[info exists mom_record_fields($i)]} { append str [string toupper $mom_record_fields($i)]; }
           }
           MOM_output_literal "(RPT,$n) ; $str"
           set mom_warning_info "<!--\n STLOOP->Опция \[Вызов повторения последовательности\] число повторов=$n\n-->"
           MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
          }
  "NDLOOP" { ; # Конец повторения последовательности
            MOM_output_literal "(ERP)"
            set mom_warning_info "<!--\n NDLOOP->Опция \[Конец повторения последовательности\]\n-->"
            MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
           }
  "SAFETY" { ; # Разрешение коррекции скорости главного двигателя и шпинделя
           switch [string toupper $mom_record_fields(1)] {
            "FEED" { set str 20 ; }
            "SPINDLE" { set str 21 ; }
            "ON" { set str 22 ; }
            "OFF" { set str 23 ; }
            default {
              set mom_warning_info "WARNING: не обрабатываемая команда!($mom_user_defined_text)"
              MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
              MOM_output_literal $mom_user_defined_text
              return ;
              }
            }
           global mom_prefun mom_prefun_text ; set mom_prefun $str ; set mom_prefun_text "" ;
           MOM_prefun ;
           set mom_warning_info "<!--\n SAFETY->Опция [string toupper $mom_record_fields(1)] \[Разрешение коррекции скорости главного двигателя и шпинделя\]=$str ;\n-->"
           MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
         }
  "SELECT" { ; # Смена Паллет
           switch [string toupper $mom_record_fields(1)] {
             "PALLET" {
                       if {[info exists mom_record_fields(2)]} {
                          set str  $mom_record_fields(2);
                          if [catch {expr {2 * $str}}] { set str 0 ; }
                          global mom_auxfun mom_auxfun_text ;
                          if {$str<60 || $str>63} {
                            if {$str<0} { set str 0 ; }
                            if {$str>3} { set str 3 ; }
                            set str [expr 60 + $str] ;
                           }
                          set mom_auxfun [expr $str] ; set mom_auxfun_text "" ; MOM_auxfun  ; #MOM_output_literal "M$str"
                          set mom_warning_info "<!--\n SELECT->Опция PALLET \[Смена Паллет\]\n Режим=$mom_auxfun ;\n-->"
                          MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
                        }
                      }
              default {
                       set mom_warning_info "WARNING: не обрабатываемая команда!($mom_user_defined_text)\n"
                       MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
                      }
            }
          }
  "SLOWDN" {  ; # Режим торможения на углах
               catch { PB_slowdn }
          }
  "TIME" { ; }
  "ZERO" {
           global  mom_work_coordinate_number
           set mom_work_coordinate_number $mom_record_fields(1)
           MOM_zero
         }
 default {
            set mom_warning_info "WARNING: не обрабатываемая команда!($mom_user_defined_text)\n"
            MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
            MOM_output_literal "${mom_sys_control_out}${mom_user_defined_text}${mom_sys_control_in}"
         }
  }
}


#=============================================================
proc PB_CMD_tool_change_force_addresses { } {
#=============================================================
  MOM_force once G_adjust H ; # X Y Z S fourth_axis fifth_axis
}


#=============================================================
proc PB_CMD_tool_preselect { } {
#=============================================================
  global mom_tool_preselect_number mom_tool_number mom_next_tool_number
  global mom_warning_info
  set mom_warning_info "WARNING: Предвыбор инструмента в системе 'NC110' не предусмотрен \[Событие tool_preselect\]"
  MOM_output_to_listing_device $mom_warning_info  ;   MOM_catch_warning ;
}


#=============================================================
proc PB_CMD_zero { } {
#=============================================================
#Эта команда позволяет Вам определять G код который выводится перед смещением нуля.
#Эта опция прежде всего используется для систем ЧПУ фирмы Fanuc.
#Вы можете определить G коды для ZERO/CHECK, ZERO/ON, ZERO/OFF, ZERO/THRU, и основного G кода для ZERO/n.
#
  global mom_sys_wcs_change_code mom_work_coordinate_number
  if {![info exists mom_work_coordinate_number]} { set	mom_work_coordinate_number 0 }
  if {$mom_work_coordinate_number==""} { set mom_work_coordinate_number 0 }
  MOM_output_literal "(UAO,$mom_work_coordinate_number)"
}


#=============================================================
proc PAUSE { args } {
#=============================================================
  global env

  if { [info exists env(PB_SUPPRESS_UGPOST_DEBUG)] &&  $env(PB_SUPPRESS_UGPOST_DEBUG) == 1 } {
return
  }


  set cam_aux_dir  [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]

  global tcl_platform

  if [string match "*windows*" $tcl_platform(platform)] {
     set ug_wish "ugwish.exe"
  } else {
     set ug_wish ugwish
  }

  if { [file exists ${cam_aux_dir}$ug_wish] && [file exists ${cam_aux_dir}mom_pause.tcl] } {

     set title ""
     set msg ""

     if { [llength $args] == 1 } {
       set msg [lindex $args 0]
     }

     if { [llength $args] > 1 } {
       set title [lindex $args 0]
       set msg [lindex $args 1]
     }

     exec ${cam_aux_dir}$ug_wish ${cam_aux_dir}mom_pause.tcl $title $msg
  }
}


#=============================================================
proc EQ_is_zero { s } {
#=============================================================
   global mom_system_tolerance

   if [info exists mom_system_tolerance] {
      if { [expr abs($s)] <= $mom_system_tolerance } { return 1 } else { return 0 }
   } else {
      return 0
   }
}


#=============================================================
proc CATCH_WARNING { msg } {
#=============================================================
  global mom_warning_info
  global mom_motion_event
  global mom_event_number

   set level [info level]
   set call_stack ""
   for {set i 1} {$i < $level} {incr i} {
      set call_stack "$call_stack\[ [lindex [info level $i] 0] \]"
   }
   set mom_warning_info "$msg ($mom_motion_event $mom_event_number) $call_stack"
   MOM_catch_warning
}


#=============================================================
proc WORKPLANE_SET {  } {
#=============================================================
   global mom_cycle_spindle_axis
   global mom_sys_spindle_axis
   global traverse_axis1 traverse_axis2

   if { ![info exists mom_sys_spindle_axis] } {
      set mom_sys_spindle_axis(0) 0.0
      set mom_sys_spindle_axis(1) 0.0
      set mom_sys_spindle_axis(2) 1.0
   }

   if { ![info exists mom_cycle_spindle_axis] } {
      set x $mom_sys_spindle_axis(0)
      set y $mom_sys_spindle_axis(1)
      set z $mom_sys_spindle_axis(2)

      if { [EQ_is_zero $y] && [EQ_is_zero $z] } {
         set mom_cycle_spindle_axis 0
      } elseif { [EQ_is_zero $x] && [EQ_is_zero $z] } {
         set mom_cycle_spindle_axis 1
      } else {
         set mom_cycle_spindle_axis 2
      }
   }

   if { $mom_cycle_spindle_axis == 2 } {
      set traverse_axis1 0 ; set traverse_axis2 1
   } elseif { $mom_cycle_spindle_axis == 0 } {
      set traverse_axis1 1 ; set traverse_axis2 2
   } elseif { $mom_cycle_spindle_axis == 1 } {
      set traverse_axis1 0 ; set traverse_axis2 2
   }
}


#=============================================================
proc EQ_is_equal { s t } {
#=============================================================
   global mom_system_tolerance

   if [info exists mom_system_tolerance] {
      if { [expr abs($s - $t)] <= $mom_system_tolerance } { return 1 } else { return 0 }
   } else {
      return 0
   }
}






#================================================
proc CHECK_PLANE {  } {
#================================================
  global mom_arc_axis

  set g_plane 17
  if {[format "%.6f" $mom_arc_axis(2)] == "1" || [format "%.6f" $mom_arc_axis(2)] == "-1"} {
        set g_plane 17
  } elseif {[format "%.6f" $mom_arc_axis(1)] == "1" || [format "%.6f" $mom_arc_axis(1)] == "-1"} {
        set g_plane 18
  } elseif {[format "%.6f" $mom_arc_axis(0)] == "1" || [format "%.6f" $mom_arc_axis(0)] == "-1"} {
        set g_plane 19
  }

  return $g_plane
}


#=============================================================
proc SET_SIGN_OF_RADIUS {  } {
#=============================================================
  global mom_arc_radius
  global mom_arc_angle

  if {$mom_arc_angle > 180.0} {
      set mom_arc_radius [expr (-1.0 * $mom_arc_radius)]
  } else {
      set mom_arc_radius [expr abs($mom_arc_radius)]
  }
}


#=============================================================
proc TRACE {  } {
#=============================================================
   set start_idx 1

   set str ""
   set level [info level]
   for {set i $start_idx} {$i < $level} {incr i} {
      set str "${str}[lindex [info level $i] 0]\n"
   }

return $str
}


if [info exists mom_sys_start_of_program_flag] {
   if [llength [info commands PB_CMD_kin_start_of_program] ] {
      PB_CMD_kin_start_of_program
   }
} else {
   set mom_sys_head_change_init_program 1
   set mom_sys_start_of_program_flag 1
}






#***************************
# Source in user's tcl file.
#***************************
 set user_tcl_file ${cam_post_dir}nc100_users.tcl
 if { [file exists $user_tcl_file] } {
    source $user_tcl_file
 }


