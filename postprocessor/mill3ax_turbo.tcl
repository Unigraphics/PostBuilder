########################## TCL Event Handlers ##########################
#
#  mill3ax_turbo.tcl - 3_axis_mill
#
#    
#
#  Created by Postino @ Friday, March 09 2018, 18:00:26 -0800
#  with Post Builder version 12.0.2.
#
########################################################################



#=============================================================
proc PB_CMD___log_revisions { } {
#=============================================================
# Dummy command to log changes in this post --
#
# 31-Jan-2017 gsl - (NX/PB v11.02) Use new command to activate legacy turbo mode also
#                   enabled advanced turbo mode
# 15-May-2017 gsl - Fixed problem with MOM_set_turbo_mode in PB_CMD__AdvTurboPost__Customize_Post
#
}



  set cam_post_dir [MOM_ask_env_var UGII_CAM_POST_DIR]

  set mom_sys_this_post_dir  "[file dirname [info script]]"
  set mom_sys_this_post_name "[file rootname [file tail [info script]]]"


  if { ![info exists mom_sys_post_initialized] } {

     if { ![info exists mom_sys_ugpost_base_initialized] } {
        source ${cam_post_dir}ugpost_base.tcl
        set mom_sys_ugpost_base_initialized 1
     }
 
 
     set mom_sys_debug_mode OFF
 
 
     if { ![info exists env(PB_SUPPRESS_UGPOST_DEBUG)] } {
        set env(PB_SUPPRESS_UGPOST_DEBUG) 0
     }
 
     if { $env(PB_SUPPRESS_UGPOST_DEBUG) } {
        set mom_sys_debug_mode OFF
     }
 
     if { ![string compare $mom_sys_debug_mode "OFF"] } {
 
        proc MOM_before_each_add_var {} {}
        proc MOM_before_each_event   {} {}
        proc MOM_before_load_address {} {}
        proc MOM_end_debug {} {}
 
     } else {
 
        set cam_debug_dir [MOM_ask_env_var UGII_CAM_DEBUG_DIR]
        source ${cam_debug_dir}mom_review.tcl
     }


   ####  Listing File variables 
     set mom_sys_list_output                       "OFF"
     set mom_sys_header_output                     "OFF"
     set mom_sys_list_file_rows                    "40"
     set mom_sys_list_file_columns                 "30"
     set mom_sys_warning_output                    "OFF"
     set mom_sys_warning_output_option             "FILE"
     set mom_sys_group_output                      "OFF"
     set mom_sys_list_file_suffix                  "lpt"
     set mom_sys_output_file_suffix                "ptp"
     set mom_sys_commentary_output                 "ON"
     set mom_sys_commentary_list                   "x y z 4axis 5axis feed speed"
     set mom_sys_pb_link_var_mode                  "OFF"


     if { [string match "OFF" $mom_sys_warning_output] } {
        catch { rename MOM__util_print ugpost_MOM__util_print }
        proc MOM__util_print { args } {}
     }


     MOM_set_debug_mode $mom_sys_debug_mode


     if { [string match "OFF" $mom_sys_warning_output] } {
        catch { rename MOM__util_print "" }
        catch { rename ugpost_MOM__util_print MOM__util_print }
     }


   #=============================================================
   proc MOM_before_output { } {
   #=============================================================
   # This command is executed just before every NC block is
   # to be output to a file.
   #
   # - Never overload this command!
   # - Any customization should be done in PB_CMD_before_output!
   #

      if { [llength [info commands PB_CMD_kin_before_output]] &&\
           [llength [info commands PB_CMD_before_output]] } {

         PB_CMD_kin_before_output
      }

     # Write output buffer to the listing file with warnings
      global mom_sys_list_output
      if { [string match "ON" $mom_sys_list_output] } {
         LIST_FILE
      } else {
         global tape_bytes mom_o_buffer
         if { ![info exists tape_bytes] } {
            set tape_bytes [string length $mom_o_buffer]
         } else {
            incr tape_bytes [string length $mom_o_buffer]
         }
      }
   }


     if { [string match "OFF" [MOM_ask_env_var UGII_CAM_POST_LINK_VAR_MODE]] } {
        set mom_sys_link_var_mode                     "OFF"
     } else {
        set mom_sys_link_var_mode                     "$mom_sys_pb_link_var_mode"
     }


     set mom_sys_control_out                       "("
     set mom_sys_control_in                        ")"


     set mom_sys_post_initialized 1
  }


  set mom_sys_use_default_unit_fragment         "ON"
  set mom_sys_alt_unit_post_name                "mill3ax_turbo__MM.pui"


########## SYSTEM VARIABLE DECLARATIONS ##############
  set mom_sys_rapid_code                        "0"
  set mom_sys_linear_code                       "1"
  set mom_sys_circle_code(CLW)                  "2"
  set mom_sys_circle_code(CCLW)                 "3"
  set mom_sys_delay_code(SECONDS)               "4"
  set mom_sys_delay_code(REVOLUTIONS)           "4"
  set mom_sys_cutcom_plane_code(XY)             "17"
  set mom_sys_cutcom_plane_code(ZX)             "18"
  set mom_sys_cutcom_plane_code(XZ)             "18"
  set mom_sys_cutcom_plane_code(YZ)             "19"
  set mom_sys_cutcom_plane_code(ZY)             "19"
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
  set mom_sys_cycle_ret_code(AUTO)              "98"
  set mom_sys_cycle_ret_code(MANUAL)            "99"
  set mom_sys_reset_code                        "92"
  set mom_sys_spindle_mode_code(SFM)            "96"
  set mom_sys_spindle_mode_code(RPM)            "97"
  set mom_sys_return_code                       "28"
  set mom_sys_feed_rate_mode_code(FRN)          "93"
  set mom_sys_feed_rate_mode_code(IPM)          "94"
  set mom_sys_feed_rate_mode_code(IPR)          "95"
  set mom_sys_program_stop_code                 "0"
  set mom_sys_optional_stop_code                "1"
  set mom_sys_end_of_program_code               "2"
  set mom_sys_spindle_direction_code(CLW)       "3"
  set mom_sys_spindle_direction_code(CCLW)      "4"
  set mom_sys_spindle_direction_code(OFF)       "5"
  set mom_sys_tool_change_code                  "6"
  set mom_sys_coolant_code(ON)                  "8"
  set mom_sys_coolant_code(FLOOD)               "8"
  set mom_sys_coolant_code(MIST)                "7"
  set mom_sys_coolant_code(THRU)                "26"
  set mom_sys_coolant_code(TAP)                 "8"
  set mom_sys_coolant_code(OFF)                 "9"
  set mom_sys_rewind_code                       "30"
  set mom_sys_4th_axis_has_limits               "1"
  set mom_sys_5th_axis_has_limits               "1"
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
  set mom_sys_cir_vector                        "Vector - Arc Start to Center"
  set mom_sys_spindle_ranges                    "0"
  set mom_sys_rewind_stop_code                  "\#"
  set mom_sys_home_pos(0)                       "0"
  set mom_sys_home_pos(1)                       "0"
  set mom_sys_home_pos(2)                       "0"
  set mom_sys_zero                              "0"
  set mom_sys_opskip_block_leader               "/"
  set mom_sys_seqnum_start                      "10"
  set mom_sys_seqnum_incr                       "10"
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
  set mom_sys_leader(fourth_axis)               "A"
  set mom_sys_leader(fifth_axis)                "B"
  set mom_sys_contour_feed_mode(LINEAR)         "IPM"
  set mom_sys_rapid_feed_mode(LINEAR)           "IPM"
  set mom_sys_cycle_feed_mode                   "IPM"
  set mom_sys_feed_param(IPM,format)            "Feed_IPM"
  set mom_sys_feed_param(IPR,format)            "Feed_IPR"
  set mom_sys_feed_param(FRN,format)            "Feed_INV"
  set mom_sys_vnc_rapid_dogleg                  "1"
  set mom_sys_prev_mach_head                    ""
  set mom_sys_curr_mach_head                    ""
  set mom_sys_contour_feed_mode(ROTARY)         "IPM"
  set mom_sys_contour_feed_mode(LINEAR_ROTARY)  "IPM"
  set mom_sys_feed_param(DPM,format)            "Feed_DPM"
  set mom_sys_rapid_feed_mode(ROTARY)           "IPM"
  set mom_sys_rapid_feed_mode(LINEAR_ROTARY)    "IPM"
  set mom_sys_advanced_turbo_output             "1"
  set mom_sys_tool_number_max                   "32"
  set mom_sys_tool_number_min                   "1"
  set mom_sys_post_description                  ""
  set mom_sys_word_separator                    " "
  set mom_sys_end_of_block                      ""
  set mom_sys_ugpadvkins_used                   "0"
  set mom_sys_post_builder_version              "12.0.2"

####### KINEMATIC VARIABLE DECLARATIONS ##############
  set mom_kin_4th_axis_ang_offset               "0.0"
  set mom_kin_4th_axis_center_offset(0)         "0.0"
  set mom_kin_4th_axis_center_offset(1)         "0.0"
  set mom_kin_4th_axis_center_offset(2)         "0.0"
  set mom_kin_4th_axis_direction                "MAGNITUDE_DETERMINES_DIRECTION"
  set mom_kin_4th_axis_incr_switch              "OFF"
  set mom_kin_4th_axis_leader                   "A"
  set mom_kin_4th_axis_limit_action             "Warning"
  set mom_kin_4th_axis_max_limit                "360"
  set mom_kin_4th_axis_min_incr                 "0.001"
  set mom_kin_4th_axis_min_limit                "0"
  set mom_kin_4th_axis_plane                    "YZ"
  set mom_kin_4th_axis_point(0)                 "0.0"
  set mom_kin_4th_axis_point(1)                 "0.0"
  set mom_kin_4th_axis_point(2)                 "0.0"
  set mom_kin_4th_axis_rotation                 "standard"
  set mom_kin_4th_axis_type                     "Table"
  set mom_kin_4th_axis_vector(0)                "1.0"
  set mom_kin_4th_axis_vector(1)                "0.0"
  set mom_kin_4th_axis_vector(2)                "0.0"
  set mom_kin_4th_axis_zero                     "0.0"
  set mom_kin_5th_axis_ang_offset               "0.0"
  set mom_kin_5th_axis_center_offset(0)         "0.0"
  set mom_kin_5th_axis_center_offset(1)         "0.0"
  set mom_kin_5th_axis_center_offset(2)         "0.0"
  set mom_kin_5th_axis_direction                "MAGNITUDE_DETERMINES_DIRECTION"
  set mom_kin_5th_axis_incr_switch              "OFF"
  set mom_kin_5th_axis_leader                   "B"
  set mom_kin_5th_axis_limit_action             "Warning"
  set mom_kin_5th_axis_max_limit                "360"
  set mom_kin_5th_axis_min_incr                 "0.001"
  set mom_kin_5th_axis_min_limit                "0"
  set mom_kin_5th_axis_plane                    "ZX"
  set mom_kin_5th_axis_point(0)                 "0.0"
  set mom_kin_5th_axis_point(1)                 "0.0"
  set mom_kin_5th_axis_point(2)                 "0.0"
  set mom_kin_5th_axis_rotation                 "standard"
  set mom_kin_5th_axis_type                     "Table"
  set mom_kin_5th_axis_vector(0)                "0.0"
  set mom_kin_5th_axis_vector(1)                "1.0"
  set mom_kin_5th_axis_vector(2)                "0.0"
  set mom_kin_5th_axis_zero                     "0.0"
  set mom_kin_arc_output_mode                   "FULL_CIRCLE"
  set mom_kin_arc_valid_plane                   "XYZ"
  set mom_kin_clamp_time                        "2.0"
  set mom_kin_cycle_plane_change_per_axis       "0"
  set mom_kin_cycle_plane_change_to_lower       "0"
  set mom_kin_flush_time                        "2.0"
  set mom_kin_linearization_flag                "1"
  set mom_kin_linearization_tol                 "0.001"
  set mom_kin_machine_resolution                ".0001"
  set mom_kin_machine_type                      "3_axis_mill"
  set mom_kin_machine_zero_offset(0)            "0.0"
  set mom_kin_machine_zero_offset(1)            "0.0"
  set mom_kin_machine_zero_offset(2)            "0.0"
  set mom_kin_max_arc_radius                    "9999.9999"
  set mom_kin_max_dpm                           "100"
  set mom_kin_max_fpm                           "800"
  set mom_kin_max_fpr                           "100"
  set mom_kin_max_frn                           "100"
  set mom_kin_min_arc_length                    "0.0001"
  set mom_kin_min_arc_radius                    "0.0001"
  set mom_kin_min_dpm                           "0.0"
  set mom_kin_min_fpm                           "0.1"
  set mom_kin_min_fpr                           "0.1"
  set mom_kin_min_frn                           "0.01"
  set mom_kin_output_unit                       "IN"
  set mom_kin_pivot_gauge_offset                "0.0"
  set mom_kin_pivot_guage_offset                ""
  set mom_kin_post_data_unit                    "IN"
  set mom_kin_rapid_feed_rate                   "800"
  set mom_kin_rotary_axis_method                "PREVIOUS"
  set mom_kin_spindle_axis(0)                   "0.0"
  set mom_kin_spindle_axis(1)                   "0.0"
  set mom_kin_spindle_axis(2)                   "1.0"
  set mom_kin_tool_change_time                  "0.0"
  set mom_kin_x_axis_limit                      "50"
  set mom_kin_y_axis_limit                      "50"
  set mom_kin_z_axis_limit                      "50"




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

    catch { OPEN_files } ;# Open warning and listing files
    LIST_FILE_HEADER     ;# List header in commentary listing



  global mom_sys_post_initialized
  if { $mom_sys_post_initialized > 1 } { return }


  set ::mom_sys_start_program_clock_seconds [clock seconds]

   # Load parameters for alternate output units
    PB_load_alternate_unit_settings
    rename PB_load_alternate_unit_settings ""


#************
uplevel #0 {


#=============================================================
proc MOM_sync { } {
#=============================================================
  if [llength [info commands PB_CMD_kin_handle_sync_event] ] {
    PB_CMD_kin_handle_sync_event
  }
}


#=============================================================
proc MOM_set_csys { } {
#=============================================================
  if [llength [info commands PB_CMD_kin_set_csys] ] {
    PB_CMD_kin_set_csys
  }
}


#=============================================================
proc MOM_msys { } {
#=============================================================
}


#=============================================================
proc MOM_end_of_program { } {
#=============================================================
  global mom_program_aborted mom_event_error
   PB_CMD_nurbs_end_of_program

   MOM_do_template end_of_program
   MOM_set_seq_off

   MOM_do_template rewind_stop_code
   PB_CMD_output_program_elapsed_time

  # Write tool list with time in commentary data
   LIST_FILE_TRAILER

  # Close warning and listing files
   CLOSE_files

   if [CMD_EXIST PB_CMD_kin_end_of_program] {
      PB_CMD_kin_end_of_program
   }
}


  incr mom_sys_post_initialized


} ;# uplevel
#***********


}


#=============================================================
proc PB_init_new_iks { } {
#=============================================================
  global mom_kin_iks_usage mom_kin_spindle_axis
  global mom_kin_4th_axis_vector mom_kin_5th_axis_vector


   set mom_kin_iks_usage 1

  # Override spindle axis vector defined in PB_CMD_init_rotary
   set mom_kin_spindle_axis(0)  0.0
   set mom_kin_spindle_axis(1)  0.0
   set mom_kin_spindle_axis(2)  1.0

  # Unitize vectors
   foreach i { 0 1 2 } {
      set vec($i) $mom_kin_spindle_axis($i)
   }
   VEC3_unitize vec mom_kin_spindle_axis

   foreach i { 0 1 2 } {
      set vec($i) $mom_kin_4th_axis_vector($i)
   }
   VEC3_unitize vec mom_kin_4th_axis_vector

   foreach i { 0 1 2 } {
      set vec($i) $mom_kin_5th_axis_vector($i)
   }
   VEC3_unitize vec mom_kin_5th_axis_vector

  # Reload kinematics
   MOM_reload_kinematics
}


#=============================================================
proc PB_DELAY_TIME_SET { } {
#=============================================================
  global mom_sys_delay_param mom_delay_value
  global mom_delay_revs mom_delay_mode delay_time

  # Post Builder provided format for the current mode:
   if { [info exists mom_sys_delay_param(${mom_delay_mode},format)] != 0 } {
      MOM_set_address_format dwell $mom_sys_delay_param(${mom_delay_mode},format)
   }

   switch $mom_delay_mode {
      SECONDS { set delay_time $mom_delay_value }
      default { set delay_time $mom_delay_revs  }
   }
}


#=============================================================
proc MOM_before_motion { } {
#=============================================================
  global mom_motion_event mom_motion_type

   FEEDRATE_SET

   if [CMD_EXIST PB_CMD__AdvTurboPost__config_before_motion] {
      PB_CMD__AdvTurboPost__config_before_motion
   }

   switch $mom_motion_type {
      ENGAGE   { PB_engage_move }
      APPROACH { PB_approach_move }
      FIRSTCUT { catch {PB_first_cut} }
      RETRACT  { PB_retract_move }
      RETURN   { catch {PB_return_move} }
      default  {}
   }

   if { [llength [info commands PB_CMD_kin_before_motion] ] } { PB_CMD_kin_before_motion }
   if { [llength [info commands PB_CMD_before_motion] ] }     { PB_CMD_before_motion }
}


#=============================================================
proc MOM_start_of_group { } {
#=============================================================
  global mom_sys_group_output mom_group_name group_level ptp_file_name
  global mom_sequence_number mom_sequence_increment mom_sequence_frequency
  global mom_sys_ptp_output pb_start_of_program_flag

   if { ![hiset group_level] } {
      set group_level 0
      return
   }

   if { [hiset mom_sys_group_output] } {
      if { ![string compare $mom_sys_group_output "OFF"] } {
         set group_level 0
         return
      }
   }

   if { [hiset group_level] } {
      incr group_level
   } else {
      set group_level 1
   }

   if { $group_level > 1 } {
      return
   }

   SEQNO_RESET ; #<4133654>
   MOM_reset_sequence $mom_sequence_number $mom_sequence_increment $mom_sequence_frequency

   if { [info exists ptp_file_name] } {
      MOM_close_output_file $ptp_file_name
      MOM_start_of_program
      if { ![string compare $mom_sys_ptp_output "ON"] } {
         MOM_open_output_file $ptp_file_name
      }
   } else {
      MOM_start_of_program
   }

   PB_start_of_program
   set pb_start_of_program_flag 1
}


#=============================================================
proc MOM_machine_mode { } {
#=============================================================
  global pb_start_of_program_flag
  global mom_operation_name mom_sys_change_mach_operation_name

   set mom_sys_change_mach_operation_name $mom_operation_name

   if { $pb_start_of_program_flag == 0 } {
      PB_start_of_program
      set pb_start_of_program_flag 1
   }

  # Reload post for simple mill-turn
   if { [llength [info commands PB_machine_mode] ] } {
      if { [catch {PB_machine_mode} res] } {
         CATCH_WARNING "$res"
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
if { [llength [info commands ugpost_FEEDRATE_SET] ] } {
   rename ugpost_FEEDRATE_SET ""
}

if { [llength [info commands FEEDRATE_SET] ] } {
   rename FEEDRATE_SET ugpost_FEEDRATE_SET
} else {
   proc ugpost_FEEDRATE_SET {} {}
}


#=============================================================
proc FEEDRATE_SET { } {
#=============================================================
   if { [llength [info commands PB_CMD_kin_feedrate_set] ] } {
      PB_CMD_kin_feedrate_set
   } else {
      ugpost_FEEDRATE_SET
   }
}


############## EVENT HANDLING SECTION ################


#=============================================================
proc MOM_auxfun { } {
#=============================================================
   MOM_do_template auxfun
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


   ABORT_EVENT_CHECK

   MOM_do_template cycle_bore
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


   ABORT_EVENT_CHECK

   MOM_do_template cycle_bore_back
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


   ABORT_EVENT_CHECK

   MOM_do_template cycle_bore_drag
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


   ABORT_EVENT_CHECK

   MOM_do_template cycle_bore_dwell
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


   ABORT_EVENT_CHECK

   MOM_do_template cycle_bore_manual
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


   ABORT_EVENT_CHECK

   MOM_do_template cycle_bore_manual_dwell
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


   ABORT_EVENT_CHECK

   MOM_do_template cycle_bore_no_drag
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_circular_move { } {
#=============================================================
   ABORT_EVENT_CHECK

   CIRCLE_SET

   MOM_do_template circular_move
}


#=============================================================
proc PB_config_turbo_circular_move { } {
#=============================================================
   set ::mom_sys_circular_turbo_blocks ""

   if { $::mom_sys_advanced_turbo_option(ABORT_EVENT_CHECK) } {
      lappend ::mom_sys_circular_turbo_blocks ABORT_EVENT_CHECK
   }

   if { $::mom_sys_advanced_turbo_option(CALL_CIRCLE_SET) } {
      lappend ::mom_sys_circular_turbo_blocks CIRCLE_SET
   }

   lappend ::mom_sys_circular_turbo_blocks circular_move

   MOM_set_turbo_blocks CIRCULAR $::mom_sys_circular_turbo_blocks
}


#=============================================================
proc MOM_coolant_off { } {
#=============================================================
   COOLANT_SET

   MOM_do_template coolant_off
}


#=============================================================
proc MOM_coolant_on { } {
#=============================================================
   COOLANT_SET
}


#=============================================================
proc MOM_cutcom_off { } {
#=============================================================
   CUTCOM_SET

   MOM_do_template cutcom_off
}


#=============================================================
proc MOM_cutcom_on { } {
#=============================================================
   CUTCOM_SET

   global mom_cutcom_adjust_register

   if { [info exists mom_cutcom_adjust_register] } {
      set cutcom_register_min 1
      set cutcom_register_max 99

      if { $mom_cutcom_adjust_register < $cutcom_register_min ||\
           $mom_cutcom_adjust_register > $cutcom_register_max } {

         CATCH_WARNING "CUTCOM register $mom_cutcom_adjust_register must be within the range between 1 and 99"

         unset mom_cutcom_adjust_register
      }
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
  global mom_cycle_tool_axis_change
  global mom_cycle_clearance_plane_change

   set cycle_init_flag TRUE
}


#=============================================================
proc MOM_delay { } {
#=============================================================
   PB_DELAY_TIME_SET

   MOM_do_template delay
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


   ABORT_EVENT_CHECK

   MOM_do_template cycle_drill
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


   ABORT_EVENT_CHECK

   MOM_do_template cycle_drill_break_chip
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


   ABORT_EVENT_CHECK

   MOM_do_template cycle_drill_deep
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


   ABORT_EVENT_CHECK

   MOM_do_template cycle_drill_dwell
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_drill_text { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name DRILL_TEXT
   CYCLE_SET
}


#=============================================================
proc MOM_drill_text_move { } {
#=============================================================
   global cycle_init_flag


   ABORT_EVENT_CHECK

   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_end_of_path { } {
#=============================================================
  global mom_sys_add_cutting_time mom_sys_add_non_cutting_time
  global mom_cutting_time mom_machine_time

  # Accumulated time should be in minutes.
   set mom_cutting_time [expr $mom_cutting_time + $mom_sys_add_cutting_time]
   set mom_machine_time [expr $mom_machine_time + $mom_sys_add_cutting_time + $mom_sys_add_non_cutting_time]
   MOM_reload_variable mom_cutting_time
   MOM_reload_variable mom_machine_time

   if [CMD_EXIST PB_CMD_kin_end_of_path] {
      PB_CMD_kin_end_of_path
   }

   global mom_sys_in_operation
   set mom_sys_in_operation 0

   if { [CMD_EXIST PB_CMD__AdvTurboPost__config_end_of_path] } {
      PB_CMD__AdvTurboPost__config_end_of_path
   }
}


#=============================================================
proc MOM_end_of_subop_path { } {
#=============================================================
}


#=============================================================
proc MOM_first_move { } {
#=============================================================
  global mom_feed_rate mom_feed_rate_per_rev mom_motion_type
  global mom_kin_max_fpm mom_motion_event

   COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET

   catch { MOM_$mom_motion_event }

  # Configure turbo output settings
   if { $::mom_sys_advanced_turbo_output } {
      if { [CMD_EXIST PB_CONFIG_ADVANCED_TURBO_OUTPUT] } {
         PB_CONFIG_ADVANCED_TURBO_OUTPUT
      }
   } else {
      if { [CMD_EXIST CONFIG_TURBO_OUTPUT] } {
         CONFIG_TURBO_OUTPUT
      }
   }
}


#=============================================================
proc MOM_first_tool { } {
#=============================================================
  global mom_sys_first_tool_handled

  # First tool only gets handled once
   if { [info exists mom_sys_first_tool_handled] } {
      MOM_tool_change
      return
   }

   set mom_sys_first_tool_handled 1

   MOM_tool_change
}


#=============================================================
proc MOM_from_move { } {
#=============================================================
  global mom_feed_rate mom_feed_rate_per_rev  mom_motion_type mom_kin_max_fpm

   COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET

}


#=============================================================
proc MOM_gohome_move { } {
#=============================================================
   MOM_rapid_move
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

  # Configure turbo output settings
   if { $::mom_sys_advanced_turbo_output } {
      if { [CMD_EXIST PB_CONFIG_ADVANCED_TURBO_OUTPUT] } {
         PB_CONFIG_ADVANCED_TURBO_OUTPUT
      }
   } else {
      if { [CMD_EXIST CONFIG_TURBO_OUTPUT] } {
         CONFIG_TURBO_OUTPUT
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
proc MOM_linear_move { } {
#=============================================================
   ABORT_EVENT_CHECK

   HANDLE_FIRST_LINEAR_MOVE

   # Customize exp of G_cutcom word to also contain G plane code
   MOM_do_template linear_move
}


#=============================================================
proc PB_config_turbo_linear_move { } {
#=============================================================
   set ::mom_sys_linear_turbo_blocks ""

   if { $::mom_sys_advanced_turbo_option(ABORT_EVENT_CHECK) } {
      lappend ::mom_sys_linear_turbo_blocks ABORT_EVENT_CHECK
   }

   if { $::mom_sys_advanced_turbo_option(HANDLE_1ST_LINEAR) } {
      lappend ::mom_sys_linear_turbo_blocks HANDLE_FIRST_LINEAR_MOVE
   }

   lappend ::mom_sys_linear_turbo_blocks linear_move

   MOM_set_turbo_blocks LINEAR $::mom_sys_linear_turbo_blocks
}


#=============================================================
proc MOM_load_tool { } {
#=============================================================
   global mom_tool_change_type mom_manual_tool_change
   global mom_tool_number mom_next_tool_number
   global mom_sys_tool_number_max mom_sys_tool_number_min

   if { $mom_tool_number < $mom_sys_tool_number_min || \
        $mom_tool_number > $mom_sys_tool_number_max } {

      global mom_warning_info
      set mom_warning_info "Tool number to be output ($mom_tool_number) exceeds limits of\
                            ($mom_sys_tool_number_min/$mom_sys_tool_number_max)"
      MOM_catch_warning
   }
}


#=============================================================
proc MOM_opstop { } {
#=============================================================
   MOM_do_template opstop
}


#=============================================================
proc MOM_prefun { } {
#=============================================================
   MOM_do_template prefun
}


#=============================================================
proc MOM_rapid_move { } {
#=============================================================
  global rapid_spindle_inhibit rapid_traverse_inhibit
  global spindle_first is_from
  global mom_cycle_spindle_axis traverse_axis1 traverse_axis2
  global mom_motion_event

   ABORT_EVENT_CHECK

   set spindle_first NONE

   set aa(0) X ; set aa(1) Y ; set aa(2) Z

   RAPID_SET

   set rapid_spindle_blk {G_adjust G_motion G_mode X Y Z H M_coolant}
   set rapid_spindle_x_blk {G_adjust G_motion G_mode X H M_coolant}
   set rapid_spindle_y_blk {G_adjust G_motion G_mode Y H M_coolant}
   set rapid_spindle_z_blk {G_adjust G_motion G_mode Z H M_coolant}
   set rapid_traverse_blk {G_motion G_mode X Y Z S M_spindle}
   set rapid_traverse_xy_blk {G_motion G_mode X Y S M_spindle}
   set rapid_traverse_yz_blk {G_motion G_mode Y Z S M_spindle}
   set rapid_traverse_xz_blk {G_motion G_mode X Z S M_spindle}
   set rapid_traverse_mod {}
   set rapid_spindle_mod {}

   global mom_sys_control_out mom_sys_control_in
   set co "$mom_sys_control_out"
   set ci "$mom_sys_control_in"


   if { ![info exists mom_cycle_spindle_axis] } {
      set mom_cycle_spindle_axis 2
   }
   if { ![info exists spindle_first] } {
      set spindle_first NONE
   }
   if { ![info exists rapid_spindle_inhibit] } {
      set rapid_spindle_inhibit FALSE
   }
   if { ![info exists rapid_traverse_inhibit] } {
      set rapid_traverse_inhibit FALSE
   }

   switch $mom_cycle_spindle_axis {
      0 {
         if [llength $rapid_spindle_x_blk] {
            set spindle_block  rapid_spindle_x
            PB_SET_RAPID_MOD $rapid_spindle_mod $rapid_spindle_x_blk aa mod_spindle
         } else {
            set spindle_block  ""
         }
         if [llength $rapid_traverse_yz_blk] {
            set traverse_block rapid_traverse_yz
            PB_SET_RAPID_MOD $rapid_traverse_mod $rapid_traverse_yz_blk aa mod_traverse
         } else {
            set traverse_block  ""
         }
      }

      1 {
         if [llength $rapid_spindle_y_blk] {
            set spindle_block  rapid_spindle_y
            PB_SET_RAPID_MOD $rapid_spindle_mod $rapid_spindle_y_blk aa mod_spindle
         } else {
            set spindle_block  ""
         }
         if [llength $rapid_traverse_xz_blk] {
            set traverse_block rapid_traverse_xz
            PB_SET_RAPID_MOD $rapid_traverse_mod $rapid_traverse_xz_blk aa mod_traverse
         } else {
            set traverse_block  ""
         }
      }

      2 {
         if [llength $rapid_spindle_z_blk] {
            set spindle_block  rapid_spindle_z
            PB_SET_RAPID_MOD $rapid_spindle_mod $rapid_spindle_z_blk aa mod_spindle
         } else {
            set spindle_block  ""
         }
         if [llength $rapid_traverse_xy_blk] {
            set traverse_block rapid_traverse_xy
            PB_SET_RAPID_MOD $rapid_traverse_mod $rapid_traverse_xy_blk aa mod_traverse
         } else {
            set traverse_block  ""
         }
      }

      default {
         set spindle_block  rapid_spindle
         set traverse_block rapid_traverse
         PB_SET_RAPID_MOD $rapid_spindle_mod $rapid_spindle_blk aa mod_spindle
         PB_SET_RAPID_MOD $rapid_traverse_mod $rapid_traverse_blk aa mod_traverse
      }
   }

   if { ![string compare $spindle_first "TRUE"] } {
      if { ![string compare $rapid_spindle_inhibit "FALSE"] } {
         if { [string compare $spindle_block ""] } {
            PB_FORCE Once $mod_spindle
            MOM_do_template $spindle_block
         } else {
            MOM_output_literal "$co Rapid Spindle Block is empty! $ci"
         }
      }
      if { ![string compare $rapid_traverse_inhibit "FALSE"] } {
         if { [string compare $traverse_block ""] } {
            PB_FORCE Once $mod_traverse
            MOM_do_template $traverse_block
         } else {
            MOM_output_literal "$co Rapid Traverse Block is empty! $ci"
         }
      }
   } elseif { ![string compare $spindle_first "FALSE"] } {
      if { ![string compare $rapid_traverse_inhibit "FALSE"] } {
         if { [string compare $traverse_block ""] } {
            PB_FORCE Once $mod_traverse
            MOM_do_template $traverse_block
         } else {
            MOM_output_literal "$co Rapid Traverse Block is empty! $ci"
         }
      }
      if { ![string compare $rapid_spindle_inhibit "FALSE"] } {
         if { [string compare $spindle_block ""] } {
            PB_FORCE Once $mod_spindle
            MOM_do_template $spindle_block
         } else {
            MOM_output_literal "$co Rapid Spindle Block is empty! $ci"
         }
      }
   } else {
      PB_FORCE Once $mod_traverse
      MOM_do_template rapid_traverse
   }
}


#=============================================================
proc PB_config_turbo_rapid_move { } {
#=============================================================
   set ::mom_sys_rapid_turbo_blocks ""
}


#=============================================================
proc MOM_sequence_number { } {
#=============================================================
   SEQNO_SET
}


#=============================================================
proc MOM_set_modes { } {
#=============================================================
   MODES_SET
}


#=============================================================
proc MOM_spindle_off { } {
#=============================================================
   MOM_do_template spindle_off
}


#=============================================================
proc MOM_spindle_rpm { } {
#=============================================================
   SPINDLE_SET

   MOM_force Once S M_spindle
   MOM_do_template spindle_rpm
}


#=============================================================
proc MOM_start_of_path { } {
#=============================================================
  global mom_sys_in_operation
   set mom_sys_in_operation 1

  global first_linear_move ; set first_linear_move 0
   TOOL_SET MOM_start_of_path

  global mom_sys_add_cutting_time mom_sys_add_non_cutting_time
  global mom_sys_machine_time mom_machine_time
   set mom_sys_add_cutting_time 0.0
   set mom_sys_add_non_cutting_time 0.0
   set mom_sys_machine_time $mom_machine_time

   if [CMD_EXIST PB_CMD_kin_start_of_path] {
      PB_CMD_kin_start_of_path
   }

   PB_CMD_start_of_operation_force_addresses
}


#=============================================================
proc MOM_start_of_subop_path { } {
#=============================================================
}


#=============================================================
proc MOM_stop { } {
#=============================================================
   MOM_do_template stop
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


   ABORT_EVENT_CHECK

   MOM_do_template cycle_tap
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_tool_change { } {
#=============================================================
   global mom_tool_change_type mom_manual_tool_change
   global mom_tool_number mom_next_tool_number
   global mom_sys_tool_number_max mom_sys_tool_number_min

   if { $mom_tool_number < $mom_sys_tool_number_min || \
        $mom_tool_number > $mom_sys_tool_number_max } {

      global mom_warning_info
      set mom_warning_info "Tool number to be output ($mom_tool_number) exceeds limits of\
                            ($mom_sys_tool_number_min/$mom_sys_tool_number_max)"
      MOM_catch_warning
   }

   if { [info exists mom_tool_change_type] } {
      switch $mom_tool_change_type {
         MANUAL { PB_manual_tool_change }
         AUTO   { PB_auto_tool_change }
      }
   } elseif { [info exists mom_manual_tool_change] } {
      if { ![string compare $mom_manual_tool_change "TRUE"] } {
         PB_manual_tool_change
      }
   }
}


#=============================================================
proc MOM_tool_preselect { } {
#=============================================================
   global mom_tool_preselect_number mom_tool_number mom_next_tool_number
   global mom_sys_tool_number_max mom_sys_tool_number_min

   if { [info exists mom_tool_preselect_number] } {
      if { $mom_tool_preselect_number < $mom_sys_tool_number_min || \
           $mom_tool_preselect_number > $mom_sys_tool_number_max } {

         global mom_warning_info
         set mom_warning_info "Preselected Tool number ($mom_tool_preselect_number) exceeds limits of\
                               ($mom_sys_tool_number_min/$mom_sys_tool_number_max)"
         MOM_catch_warning
      }

      set mom_next_tool_number $mom_tool_preselect_number
   }

   MOM_do_template tool_preselect
}


#=============================================================
proc PB_approach_move { } {
#=============================================================
}


#=============================================================
proc PB_auto_tool_change { } {
#=============================================================
   global mom_tool_number mom_next_tool_number
   if { ![info exists mom_next_tool_number] } {
      set mom_next_tool_number $mom_tool_number
   }

   PB_CMD_tool_change_force_addresses

   MOM_force Once G_mode G Z_zero
   MOM_do_template tool_change
   PB_CMD_start_of_alignment_character

   MOM_force Once T M
   MOM_do_template tool_change_1
   PB_CMD_end_of_alignment_character

   MOM_do_template tool_change_2
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
  global mom_sys_first_linear_move

  # Set this variable to signal 1st linear move has been handled.
   set mom_sys_first_linear_move 1

}


#=============================================================
proc PB_manual_tool_change { } {
#=============================================================
   PB_CMD_tool_change_force_addresses

   MOM_do_template stop
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
proc PB_start_of_program { } {
#=============================================================
   if [CMD_EXIST PB_CMD_kin_start_of_program] {
      PB_CMD_kin_start_of_program
   }

   PB_CMD___log_revisions
   MOM_set_seq_off

   MOM_do_template rewind_stop_code
   PB_CMD_init_helix
   MOM_set_seq_on

   MOM_force Once G_cutcom G_plane G_mode
   MOM_do_template absolute_mode
   PB_CMD__activate_Fanuc_turbo_mode

   if { $::mom_sys_advanced_turbo_output } {

      MOM_set_turbo_mode FALSE
      MOM_set_turbo_mode TRUE ADVANCED

      set ::mom_kin_is_turbo_output FALSE

      set ::mom_sys_advanced_turbo_option(ABORT_EVENT_CHECK)  0
      set ::mom_sys_advanced_turbo_option(HANDLE_1ST_LINEAR)  0
      set ::mom_sys_advanced_turbo_option(OUTPUT_OPER_MSG)    0
      set ::mom_sys_advanced_turbo_option(CALL_CIRCLE_SET)    0
      set ::mom_sys_advanced_turbo_option(DO_FORCE_SUPPRESS)  0
      set ::mom_sys_advanced_turbo_option(SET_SEQNUM_ON_OFF)  0
      set ::mom_sys_advanced_turbo_option(EXECUTE_PB_CMD)     0

      MOM_set_turbo_rapid FALSE
   }

   if [CMD_EXIST PB_CMD__AdvTurboPost__Customize_Post] {
      PB_CMD__AdvTurboPost__Customize_Post
   }

   if [CMD_EXIST PB_CMD_kin_start_of_program_2] {
      PB_CMD_kin_start_of_program_2
   }
}


#=============================================================
proc PB_CMD_FEEDRATE_NUMBER { } {
#=============================================================
#
#  This custom command allows you to modify the feed rate number
#  after it has been calculated by the system
#
   global mom_feed_rate_number

   set mom_sys_frn_factor 1.0

   if [info exists mom_feed_rate_number] {
      return [expr $mom_feed_rate_number * $mom_sys_frn_factor]
   } else {
      return 0.0
   }
}


#=============================================================
proc PB_CMD__AdvTurboPost__Customize_Post { } {
#=============================================================
# - For NX11.01 & up -
#
#  This custom command can be used to customize the behavior of
#  a post with the advanced turbo mode enabled by Post Builder.
#
#  Post qualified to be processed in advanced turbo mode, when saved
#  in Post Builder v11.01 & newer, will execute this command automatically.
#  => Do not attach this command to any event marker.
#
#
# Revisions:
# Jan-20-2017 gsl - PB v11.02.
#


#
# Post Builder initializes ::mom_sys_advanced_turbo_output when a post is enabled as an advanced turbo post.
# This variable could then be set per operation when the turbo mode has been subsequently changed via MOM_set_turbo_mode.
#
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## => Uncomment next statement to disable Advanced Turbo mode
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# set ::mom_sys_advanced_turbo_output 0


   if { !$::mom_sys_advanced_turbo_output } {

      INFO "Turn off adv turbo mode"

     # Honor legacy turbo mode
      if { [info exists ::mom_kin_is_turbo_output] } {
         if { $::mom_kin_is_turbo_output } {
            MOM_set_turbo_mode TRUE
         } else {
            MOM_set_turbo_mode FALSE ADVANCED
         }
      } else {
         MOM_set_turbo_mode FALSE ADVANCED
      }
return
   }



  #------------------------------------------------
  # Turbo mode only usable for 3-5 axes mill posts
  #
   if { [string match "*wedm*"      $::mom_kin_machine_type] ||\
        [string match "*lathe*"     $::mom_kin_machine_type] ||\
        [string match "*mill_turn*" $::mom_kin_machine_type] } {

      set msg "Turbo mode can only be activated for 3, 4 & 5-axis mill posts!"

      INFO "$msg"
      CATCH_WARNING $msg

      MOM_set_turbo_mode FALSE ADVANCED
return
   }


  #-------------------------------------------------------
  # Advanced Turbo mode only available in NX11.01 & newer
  #
   set ugii_full_version [string trimleft [MOM_ask_env_var UGII_FULL_VERSION] v]

   if { [COMPARE_NX_VERSION $ugii_full_version "11.0.1"] < 0 } {

      set msg "Advanced Turbo mode is only available in NX v11.0.1 and newer version!"
      CATCH_WARNING $msg

      set res [MOM_display_message "$msg\nYou may continue with the standard mode or abort the job."\
                                   "Advanced Turbo Post Error" E "Continue" "Abort"]
      switch $res {
         2 {
            MOM_abort $msg
         }
         default {
            INFO "Advanced Turbo mode not available in NX v$ugii_full_version"
            set ::mom_sys_advanced_turbo_output 0
            MOM_set_turbo_mode FALSE
         }
      }
return
   }



##===============
## CUSTOMIZATION
##===============
  #
  # By default, Post Builder will configure the RAPID motions without work-plane-change
  # to be processed in turbo mode.  The users may force the rapid motions to always be
  # processed in the standard mode instead to gain better customizability with the post.
  #
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ## Uncomment next statement to process RAPID motions in standard mode
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # MOM_set_turbo_rapid FALSE


  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ## Uncomment next statement to execute MOM_before_motion when motion
  ## type has changed.
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # MOM_set_turbo_before_motion TRUE


  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ## Additional variables to be updated during turbo posting mode -
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   if { ![info exists ::mom_sys_turbo_global_add_vars_list] } {
      set ::mom_sys_turbo_global_add_vars_list [list]
   }
   lappend ::mom_sys_turbo_global_add_vars_list "mom_feedrate"


  ##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ## By default, options below have been disabled to optimize the turbo post performance;
  ## => User may activate any of the options to fine tune the output of a turbo post.
  ##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   set ::mom_sys_advanced_turbo_option(ABORT_EVENT_CHECK)  0
   set ::mom_sys_advanced_turbo_option(HANDLE_1ST_LINEAR)  0
   set ::mom_sys_advanced_turbo_option(OUTPUT_OPER_MSG)    0
   set ::mom_sys_advanced_turbo_option(CALL_CIRCLE_SET)    0
   set ::mom_sys_advanced_turbo_option(DO_FORCE_SUPPRESS)  0
   set ::mom_sys_advanced_turbo_option(SET_SEQNUM_ON_OFF)  0
   set ::mom_sys_advanced_turbo_option(EXECUTE_PB_CMD)     0

}


#=============================================================
proc PB_CMD__AdvTurboPost__config_before_motion { } {
#=============================================================
# - For NX11.01 & up -
#
#  This custom command will be executed automatically in MOM_before_motion
#  of an advanced turbo post to adjust variables, e.g. feedrates',
#  for the output of non-turbo events.
#
#  => Modify this command to accommodate the needs of your post
#
# Jan-20-2017 gsl - PB v11.02.
#

   if { ![info exists ::mom_sys_advanced_turbo_output] || !$::mom_sys_advanced_turbo_output } {
return
   }


  # For iTNC -
   if { ![string compare $::mom_kin_output_unit "IN"] } {
     # set ::mom_sys_feed_rate_factor 10.0
   }


  # In an advanced turbo post, addresses for feed rate & feed mode output have been configured with
  # mom_feedrate & mom_feedrate_mode respectively (See PB_CMD__AdvTurboPost__config_output).
  # When handling non-turbo event, such as MOM_before_motion, these variables need to be filled with
  # values of variables set for the standard posting mode.
  #
  # Other variables may need to be redefined as well.
  #
   if { [info exists ::feed] } {
      set ::mom_feedrate $::feed
   } else {
      set ::mom_feedrate $::mom_feed_rate
   }

   if { [info exists ::feed_mode] } {
      set ::mom_feedrate_mode $::feed_mode
   } else {
      set ::mom_feedrate_mode $::mom_feed_rate_mode
   }

}


#=============================================================
proc PB_CMD__AdvTurboPost__config_end_of_path { } {
#=============================================================
# - For NX11.01 & up -
#
#  This custom command, when present in an advanced turbo post,
#  will be executed automatically at the End-of-Path event handler.
#
# Jan-25-2017 gsl - PB v11.02
#

   if { ![info exists ::mom_sys_advanced_turbo_output] || !$::mom_sys_advanced_turbo_output } {
return
   }


  #++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Restore address expressions that have been altered
  # by PB_CMD__AdvTurboPost__config_output.
  #
   foreach block_list { ::mom_sys_circular_turbo_blocks ::mom_sys_linear_turbo_blocks ::mom_sys_rapid_turbo_blocks } {

      if [info exists ${block_list}] {
         foreach block [set ${block_list}] {

            foreach address { F X Y Z I J K } {
               if { [info exists ::save_address_expression($block,$address)] } {

                  if { [MOM_has_definition_element BLOCK $block] && [MOM_has_definition_element ADDRESS $address] } {
                     MOM_set_address_expression $block $address $::save_address_expression($block,$address)
                     unset ::save_address_expression($block,$address)
                  }
               }
            }
         }
      }
   }

}


#=============================================================
proc PB_CMD__AdvTurboPost__config_output { } {
#=============================================================
# - For NX11.01 & up -
#
#  This custom command, when present in an advanced turbo post,
#  will be executed automatically. It can be used to further
#  configure the output of the post in question.
#
# Jan-25-2017 gsl - PB v11.02
#

   if { ![info exists ::mom_sys_advanced_turbo_output] || !$::mom_sys_advanced_turbo_output } {
return
   }


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Configure address expressions used during turbo mode
  #
  # - Address expressions will be restored at the End-of-Path event handler
  #   automatically via procedures in PB_CMD__AdvTurboPost__config_end_of_path.
  #
  # Similar action is performed in PB_CMD_before_motion for standard posting mode -
  #   if { $dpp_ge(sys_output_coord_mode) == "TCP_FIX_TABLE" && $dpp_ge(toolpath_axis_num) == 5 } {
  #      VMOV 3 mom_mcs_goto mom_pos
  #      VMOV 3 mom_prev_mcs_goto mom_prev_pos
  #      VMOV 3 mom_arc_center mom_pos_arc_center
  #   }
  #

  #=====================================
  # Set address expression for F output
  #
   set address F
   foreach block_list { ::mom_sys_circular_turbo_blocks ::mom_sys_linear_turbo_blocks ::mom_sys_rapid_turbo_blocks } {

      if [info exists ${block_list}] {
         foreach block [set ${block_list}] {

            if { [MOM_has_definition_element BLOCK $block] && [MOM_has_definition_element ADDRESS $address] } {
               set ::save_address_expression($block,$address) \
                        [MOM_set_address_expression $block $address "\$mom_feedrate"]
            }
         }
      }
   }


  #++++++++++++
  # iTNC case -
   set output_mode "MOM_POS"

  # 3axis only need to handle contact output
   if { [string match $::mom_kin_machine_type "3_axis_mill"] } {

      if { [info exists mom_nxt_contact_status] &&\
           $::mom_nxt_contact_status == "ON"} {

         MOM_disable_address G_motion
         set output_mode "MOM_CONTACT_POINT"

      } else {

         MOM_enable_address G_motion
      }

   } else {

     # Enable all addresses
      if { [string match "5_*" $::mom_kin_machine_type] } {
         MOM_enable_address fifth_axis
      }


      if { [info exists ::m128_mode] && $::m128_mode == "ON" } {
         set output_mode "MOM_MCS_GOTO"
      }


      if { [info exists ::mom_output_mode_define] && $::mom_output_mode_define != "ROTARY AXES" } {

        # Output tool axis vectors
         MOM_disable_address fourth_axis G_motion

         if { [string match "5_*" $::mom_kin_machine_type] } {
            MOM_disable_address fifth_axis
         }

        # 3-D ToolComp
         if { [info exists mom_nxt_contact_status] && $mom_nxt_contact_status == "ON" } {
            set output_mode "MOM_CONTACT_POINT"
         }
      }
   }


  #+++++++++++++
  # Fanuc case -
   if { [info exists ::dpp_ge(sys_output_coord_mode)] && [info exists ::dpp_ge(toolpath_axis_num)] &&\
        $::dpp_ge(sys_output_coord_mode) == "TCP_FIX_TABLE" && $::dpp_ge(toolpath_axis_num) == 5 } {

      set output_mode "MOM_MCS_GOTO"
   }

  # Respect legacy method
   if { [info exists ::mom_sys_nc_output_mode] && [string match "PART" $::mom_sys_nc_output_mode] } {
      set output_mode "MOM_MCS_GOTO"
   }


  #===================================================
  # For all, set address expressions per output mode -
  #
   if { ![string match "MOM_POS" $output_mode] } {

      foreach block_list { ::mom_sys_circular_turbo_blocks ::mom_sys_linear_turbo_blocks ::mom_sys_rapid_turbo_blocks } {

         if [info exists ${block_list}] {

            foreach block [set ${block_list}] {

               if { [MOM_has_definition_element BLOCK $block] } {

                  foreach address { X Y Z } idx { 0 1 2 } {
                     if { [MOM_has_definition_element ADDRESS $address] } {
                        switch $output_mode {
                           MOM_MCS_GOTO {
                              set ::save_address_expression($block,$address) \
                                  [MOM_set_address_expression $block $address "\$mom_mcs_goto($idx)"]
                           }
                           MOM_CONTACT_POINT {
                              set ::save_address_expression($block,$address) \
                                  [MOM_set_address_expression $block $address "\$mom_contact_point($idx)"]
                           }
                        }
                     }
                  }

                  foreach address { I J K } idx { 0 1 2 } {
                     if { [MOM_has_definition_element ADDRESS $address] } {
                        switch $output_mode {
                           MOM_MCS_GOTO {
                              set ::save_address_expression($block,$address) \
                                  [MOM_set_address_expression $block $address "\$mom_arc_center($idx)"]
                           }
                        }
                     }
                  }

               }
            }
         }
      }
   }

}


#=============================================================
proc PB_CMD__AdvTurboPost__init { } {
#=============================================================
   if { $::mom_sys_advanced_turbo_output } {

      MOM_set_turbo_mode FALSE
      MOM_set_turbo_mode TRUE ADVANCED

      set ::mom_kin_is_turbo_output FALSE

      set ::mom_sys_advanced_turbo_option(ABORT_EVENT_CHECK)  0
      set ::mom_sys_advanced_turbo_option(HANDLE_1ST_LINEAR)  0
      set ::mom_sys_advanced_turbo_option(OUTPUT_OPER_MSG)    0
      set ::mom_sys_advanced_turbo_option(CALL_CIRCLE_SET)    0
      set ::mom_sys_advanced_turbo_option(DO_FORCE_SUPPRESS)  0
      set ::mom_sys_advanced_turbo_option(SET_SEQNUM_ON_OFF)  0
      set ::mom_sys_advanced_turbo_option(EXECUTE_PB_CMD)     0

      MOM_set_turbo_rapid FALSE
   }

   if [CMD_EXIST PB_CMD__AdvTurboPost__Customize_Post] {
      PB_CMD__AdvTurboPost__Customize_Post
   }
}


#=============================================================
proc PB_CMD__activate_Fanuc_turbo_mode { } {
#=============================================================
#  This custom command will activate the turbo process mode for
#  the posts of FANUC style controllers.  The execution time
#  will be 15 to 20 % of that required in the standard mode.
#
#  This command may only be used with Post Builder 3.2.1 or later
#  and NX2 or newer.
#
#  => Place this command with the "Start of Program" event marker.
#
#  The following turbo blocks are defined in this command:
#
#     linear_move_turbo
#     circular_move_turbo
#     rapid_move_turbo
#     sequence_number_turbo
#
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Definitions file of the post involved MUST have generic turbo blocks defined first.
#  This command will only modify & enhance the construct of the turbo blocks.
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#  => You may re-arrange the words sequence within each block template.
#     However, you MUST NOT edit the expressions within the words,
#     remove or add any other words into these turbo blocks.
#
#  In Post Builder, you may modify the parameters of the Words used
#  with the turbo blocks on the N/C Data Defitions dialogs. You may also
#  modify the parameters of Formats involved for the turbo output.
#
#  Custom commands used in the linear move, circular move & rapid move
#  event handlers will be ignored. MOM_before_motion handler will not be executed.
#
#  By default, rapid motions are also processed in turbo mode where
#  each motion is output in a single block.
#  => "MOM_set_turbo_rapid FALSE" (see below) can be issued in order to process
#     the rapid motions in standard mode instead, of which the customization
#     done for the rapid motions including MOM_before_motion will be executed.
#     This would greatly enhance the customizability of a turbo post.
#
#
# Revisions:
# Jan-19-2017 gsl - (pb11.02) Revised to accommodate advanced turbo mode
#

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
UNSET_VARS ::mom_kin_is_turbo_output
##
## Uncomment a line below to disable Advanced Turbo mode, if enabled.
## => Without setting this variable, Advanced Turbo mode will continue.
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 set ::mom_kin_is_turbo_output TRUE   ;# To post in legacy turbo mode
# set ::mom_kin_is_turbo_output FALSE  ;# To post in standard mode


 if { ![info exists ::mom_kin_is_turbo_output] } {
return
 }


##++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Process RAPID motions in standard mode, when desired.
## => This option can also be configured per operations.
##++++++++++++++++++++++++++++++++++++++++++++++++++++++
 if [CMD_EXIST MOM_set_turbo_rapid] {
   # MOM_set_turbo_rapid "FALSE"
 }


##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Set variable below to "1" to output arc radius for circular moves.
## => This option is not available in turbo mode prior to NX10.0.3.
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 set use_arc_radius_output 0



  #------------------------------------------
  # Verify if legacy turbo mode can proceed -
   if { ![PB_CMD__validate_turbo_mode] } {
return
   }


   set tmp_file $::mom_user_turbo_def_fid
   fconfigure $tmp_file -translation lf

   set ugii_version [string trimleft [MOM_ask_env_var UGII_VERSION] v]
   regexp {[0-9]} $::mom_kin_machine_type machine_axis


  #+++++++++++++++++++++
  # Define turbo blocks
  #+++++++++++++++++++++
   puts $tmp_file { MACHINE mill }
   puts $tmp_file { FORMATTING }
   puts $tmp_file " {"
   puts $tmp_file {   BLOCK_TEMPLATE circular_move_turbo }
   puts $tmp_file "   {"
   puts $tmp_file {       G_mode[^sys_output_code(OUTPUT_MODE)] }

  # ^sys_cutcom_plane_code(ARC_PLANE) implemented in NX11.02.
  # => Changes didn't make it to core code, caused testing to fail!!!
  #
   puts $tmp_file {       G_plane[^sys_cutcom_plane_code(ARC_PLANE)]\opt }
  # puts $tmp_file {       G_plane[^sys_cutcom_plane_code(CUTCOM_PLANE)]\opt }
   puts $tmp_file {       G_feed[^sys_feed_rate_mode_code(FEED_MODE)]\opt }
   puts $tmp_file {       G_motion[^sys_circle_code(ARC_DIRECTION)]\opt }
   puts $tmp_file {       X[^POSX] }
   puts $tmp_file {       Y[^POSY] }
   puts $tmp_file {       Z[^POSZ] }

   if { $use_arc_radius_output } {

      puts $tmp_file {    ARC_RADIUS[^arc_radius] }

   } else {

      puts $tmp_file {    I[^CENTERX] }
      puts $tmp_file {    J[^CENTERY] }
      puts $tmp_file {    K[^CENTERZ] }
   }

   puts $tmp_file {       F[^FEED] }
   puts $tmp_file {       S[^SPINDLE_SPEED] }
   puts $tmp_file {       M_spindle[^sys_spindle_direction_code(SPINDLE_DIRECTION)]\opt }
   puts $tmp_file "   }"

   puts $tmp_file {   BLOCK_TEMPLATE linear_move_turbo }
   puts $tmp_file "   {"
   puts $tmp_file {       G_cutcom[^sys_cutcom_code(CUTCOM_STATUS)]\opt }
   puts $tmp_file {       G_plane[^sys_cutcom_plane_code(CUTCOM_PLANE)]\opt }
   puts $tmp_file {       G_feed[^sys_feed_rate_mode_code(FEED_MODE)]\opt }
   puts $tmp_file {       G_mode[^sys_output_code(OUTPUT_MODE)] }
   puts $tmp_file {       G_motion[^sys_linear_code] }
   puts $tmp_file {       X[^POSX] }
   puts $tmp_file {       Y[^POSY] }
   puts $tmp_file {       Z[^POSZ] }

   if { $machine_axis > 3 } {

      puts $tmp_file {    fourth_axis[^POS4] }

      if { $machine_axis > 4 } {
         puts $tmp_file { fifth_axis[^POS5] }
      }

      puts $tmp_file {    tool_axis_I[^tool_axis0] }
      puts $tmp_file {    tool_axis_J[^tool_axis1] }
      puts $tmp_file {    tool_axis_K[^tool_axis2] }
   }

   puts $tmp_file {       F[^FEED] }
   puts $tmp_file {       D[^cutcom_adjust_register]\opt }
   puts $tmp_file {       S[^SPINDLE_SPEED] }
   puts $tmp_file {       M_spindle[^sys_spindle_direction_code(SPINDLE_DIRECTION)]\opt }
   puts $tmp_file {       M_coolant[^sys_coolant_code(COOLNT_STATUS)]\opt }
   puts $tmp_file "   }"

   puts $tmp_file {   BLOCK_TEMPLATE rapid_move_turbo }
   puts $tmp_file "   {"
   puts $tmp_file {       G_adjust[^sys_adjust_code] }
   puts $tmp_file {       G_motion[^sys_rapid_code] }
   puts $tmp_file {       G_mode[^sys_output_code(OUTPUT_MODE)] }
   puts $tmp_file {       X[^POSX] }
   puts $tmp_file {       Y[^POSY] }
   puts $tmp_file {       Z[^POSZ] }

   if { $machine_axis > 3 } {

      puts $tmp_file {    fourth_axis[^POS4] }

      if { $machine_axis > 4 } {
         puts $tmp_file { fifth_axis[^POS5] }
      }

      puts $tmp_file {    tool_axis_I[^tool_axis0] }
      puts $tmp_file {    tool_axis_J[^tool_axis1] }
      puts $tmp_file {    tool_axis_K[^tool_axis2] }
   }

   puts $tmp_file {       H[^tool_adjust_register]\opt }
   puts $tmp_file {       S[^SPINDLE_SPEED] }
   puts $tmp_file {       M_spindle[^sys_spindle_direction_code(SPINDLE_DIRECTION)]\opt }
   puts $tmp_file {       M_coolant[^sys_coolant_code(COOLNT_STATUS)]\opt }
   puts $tmp_file "   }"

   puts $tmp_file {   BLOCK_TEMPLATE sequence_number_turbo }
   puts $tmp_file "   {"
   puts $tmp_file {       N[^SEQNUM] }
   puts $tmp_file "   }"
   puts $tmp_file "}"

   close $tmp_file


  # Load turbo blocks
   global tcl_platform
   if { [string match "*windows*" $tcl_platform(platform)] } {
      regsub -all {/} $::mom_user_turbo_def_file_name {\\} ::mom_user_turbo_def_file_name
   }

   if { [catch { MOM_load_definition_file  "$::mom_user_turbo_def_file_name" } res] } {

     # If some addresses are not defined, post processing may be broken, a popped up message is needed
      set msg "Failed to load turbo blocks definition. Check if addresses and turbo symbols are correct.\n$res"

      INFO $msg
      CATCH_WARNING $msg

     # Disable turbo mode, if loading failed
      MOM_set_turbo_mode FALSE
   }

   MOM_remove_file  $::mom_user_turbo_def_file_name


  # Bail out, when turbo mode cannot be activated after all.
   if { ![string match "TRUE" $::mom_kin_is_turbo_output] } {
return
   }


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # When needed, define a custom command to reset turbo settings
  # @ Initial Move & First Move events.
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # return

  uplevel #0 {

   #=============================================================
   proc CONFIG_TURBO_OUTPUT { } {
   #=============================================================
   # This command is used during turbo posting mode to configure settings
   # that would affect the NC output. It will be executed automatically
   # by the Initial Move and First Move events.
   #
   # ==> Do not rename or attach it to any event.
   #

     # Bail out when not in turbo mode or multi-axis post
      if { ![info exists ::mom_kin_is_turbo_output] ||\
           ![string match "TRUE" $::mom_kin_is_turbo_output] ||\
            [string match "3_axis_mill" $::mom_kin_machine_type] } {

         return
      }


     # dpp_ge(sys_tcp_tool_axis_output_mode)
     # "AXIS"    output the rotation angle of axis (G43.4)
     # "VECTOR"  output tool axis vector(G43.5)
      if { ![info exists ::dpp_ge(sys_tcp_tool_axis_output_mode)] } {
         set ::dpp_ge(sys_tcp_tool_axis_output_mode) "AXIS"
      }

     # dpp_ge(sys_output_coord_mode)
     # "TCP_FIX_TABLE"    use a coordinate system fixed on the table as the programming coordinate system
     # "TCP_FIX_MACHINE"  use workpiece coordinate system fixed on machine as the programming coordinate system
      if { ![info exists ::dpp_ge(sys_output_coord_mode)] } {
         set ::dpp_ge(sys_output_coord_mode) "TCP_FIX_MACHINE"
      }

      if { ![info exists ::dpp_ge(tool_axis_num)] } {
         set ::dpp_ge(tool_axis_num) "3"
      }


      if { $::dpp_ge(sys_tcp_tool_axis_output_mode) == "VECTOR" } {

        # Output tool axis vectors
         MOM_disable_address fourth_axis

         if { [string match "5_*" $::mom_kin_machine_type] } {
            MOM_disable_address fifth_axis
         }

         MOM_enable_address tool_axis_I tool_axis_J tool_axis_K

      } else {

        # Output rotary angles
         MOM_enable_address fourth_axis

         if { [string match "5_*" $::mom_kin_machine_type] } {
            MOM_enable_address fifth_axis
         }

         MOM_disable_address tool_axis_I tool_axis_J tool_axis_K
      }

      if { $::dpp_ge(sys_output_coord_mode) == "TCP_FIX_TABLE" && $::dpp_ge(tool_axis_num) == "5" } {
         MOM_set_turbo_pos_output "MOM_MCS_GOTO"
      } else {
         MOM_set_turbo_pos_output "MOM_POS"
      }
   }

  } ;# uplevel
}


#=============================================================
proc PB_CMD__config_post_options { } {
#=============================================================
# <PB v10.03>
# This command should be called by Start-of-Program event;
# it enables users to set options (not via UI) that would
# affect the behavior and output of this post.
#
# Comment out next line to activate this command
return

  # <PB v10.03>
  # - Feed mode for RETRACT motion has been handled as RAPID,
  #   next option enables users to treat RETRACT as CONTOURing.
  #
   if { ![info exists ::mom_sys_retract_feed_mode] } {
      set ::mom_sys_retract_feed_mode  "CONTOUR"
   }
}


#=============================================================
proc PB_CMD__manage_part_attributes { } {
#=============================================================
# This command allows the user to manage the MOM variables
# generated for the part attributes, in case of conflicts.
#
# ==> This command is executed automatically when present in
#     the post. DO NOT add or call it in any event or command.
#

  # This command should only be called by MOM__part_attributes!
   if { ![CALLED_BY "MOM__part_attributes"] } {
return
   }

  #+++++++++++++++++++++++++++++++++++++
  # You may manage part attributes here
  #+++++++++++++++++++++++++++++++++++++
}


#=============================================================
proc PB_CMD__validate_turbo_mode { } {
#=============================================================
# This command is called automatically by the activation of
# legacy turbo posts to verify if turbo mode can be performed.
#
# => Do not call this command in any event!
#
#
# Revisions:
# Jan-19-2017 gsl - (pb11.02) Added to accommodate advanced turbo mode
#

  # Define command below to run turbo mode in earlier versions of NX/Post.
  #
   if { ![CMD_EXIST MOM_set_turbo_mode] } {
      #---------------------------------------------
      proc MOM_set_turbo_mode { turbo_mode args } {
      #---------------------------------------------
         set ::mom_kin_is_turbo_output $turbo_mode
         MOM_reload_kinematics
      }
   }


  # Allow legacy turbo mode to override Advanced Turbo mode -
  #
   if { [info exists ::mom_kin_is_turbo_output] } {

      INFO "Disable Advanced Turbo mode"
      set ::mom_sys_advanced_turbo_output 0

      if { [string match "TRUE" $::mom_kin_is_turbo_output] } {

         MOM_set_turbo_mode TRUE

      } else {

         MOM_set_turbo_mode FALSE
         INFO "Disable any turbo mode"
return 0
      }
   }


  # When Advanced Turbo mode is active, skip configuration for legacy turbo post.
  #
   if { [info exists ::mom_sys_advanced_turbo_output] &&\
                    $::mom_sys_advanced_turbo_output } {

      INFO "Skip legacy turbo mode configuration within an Advanced Turbo post."
      MOM_set_turbo_mode FALSE
return 0
   }


  # Disable turbo mode for non-milling posts
  #
   if { [string match "*wedm*"      $::mom_kin_machine_type] ||\
        [string match "*lathe*"     $::mom_kin_machine_type] ||\
        [string match "*mill_turn*" $::mom_kin_machine_type] } {

      set msg "Turbo mode can only be activated for 3, 4 & 5-axis mill posts!"

      INFO $msg
      CATCH_WARNING $msg

      MOM_set_turbo_mode FALSE
return 0
   }


  # Skip multi-axis turbo mode for pre-NX7
  #
   set ugii_version [string trimleft [MOM_ask_env_var UGII_VERSION] v]

   if { ![string match "3_axis_mill" $::mom_kin_machine_type] } {
      if { $ugii_version < 7 } {

         set msg "Multi-axis turbo mode is not available prior to NX7."
         CATCH_WARNING $msg
         INFO $msg

         MOM_set_turbo_mode FALSE
return 0
      }
   }


  # Open scratch file for turbo blocks definition
  #
   set ugii_tmp_dir [MOM_ask_env_var UGII_TMP_DIR]
   set ::mom_user_turbo_def_file_name  [file join $ugii_tmp_dir __${::mom_logname}_turbo_blocks_[clock clicks].def]

   if { [catch { set ::mom_user_turbo_def_fid [open "$::mom_user_turbo_def_file_name" w] } res] } {

      if { ![info exists res] } {
         set res "$::mom_user_turbo_def_file_name\nFile open error!"
      }

      INFO $res
      CATCH_WARNING $res

      MOM_set_turbo_mode FALSE
return 0
   }

return 1
}


#=============================================================
proc PB_CMD_abort_event { } {
#=============================================================
# This command is automatically called by every motion event
# to abort its handler based on the flag set by other events
# under certain conditions, such as an invalid tool axis vector.
#
# Users can set the global variable mom_sys_abort_next_event to
# different severity levels (non-zero) throughout the post and
# designate how to handle different conditions in this command.
#
# - Rapid, linear, circular and cycle move events have this trigger
#   built in by default in PB6.0.
#
# 06-17-13 gsl - Do not abort event, by default, when signal is "1".
# 07-16-15 gsl - Added level 3 handling

   if { [info exists ::mom_sys_abort_next_event] } {

      switch $::mom_sys_abort_next_event {
         2 -
         3 {
           # User may choose to abort NX/Post
            set __abort_post 0

            if { $__abort_post } {
               set msg "NX/Post Aborted: Illegal Move ($::mom_sys_abort_next_event)"

               if { [info exists ::mom_post_in_simulation] && $::mom_post_in_simulation == "MTD" } {
                 # In simulation, user will choose "Cancel" to stop the process.
                  PAUSE MOM_abort $msg
               } else {
                  MOM_abort $msg
               }
            }

           # Level 2 only aborts current event; level 3 will abort entire motion.
            if { $::mom_sys_abort_next_event == 2 } {
               unset ::mom_sys_abort_next_event
            }

            CATCH_WARNING "Event aborted!"
            MOM_abort_event
         }
         default {
            unset ::mom_sys_abort_next_event
            CATCH_WARNING "Event warned!"
         }
      }

   }
}


#=============================================================
proc PB_CMD_ask_machine_type { } {
#=============================================================
# Utility to return machine type per mom_kin_machine_type
#
# Revisions:
#-----------
# 02-26-09 gsl - Initial version
#
   global mom_kin_machine_type

   if { [string match "*wedm*" $mom_kin_machine_type] } {
return WEDM
   } elseif { [string match "*axis*" $mom_kin_machine_type] } {
return MILL
   } elseif { [string match "*lathe*" $mom_kin_machine_type] } {
return TURN
   } else {
return $mom_kin_machine_type
   }
}


#=============================================================
proc PB_CMD_before_motion { } {
#=============================================================
}


#=============================================================
proc PB_CMD_cancel_suppress_force_once_per_event { } {
#=============================================================
   MOM_cancel_suppress_force_once_per_event TRUE
}


#=============================================================
proc PB_CMD_clamp_fourth_axis { } {
#=============================================================
#
#  This procedure is used by auto clamping to output the code
#  needed to clamp the fourth axis.
#
#  Do NOT add this block to events or markers.  It is a static
#  block and it is not intended to be added to events.  Do NOT
#  change the name of this custom command.
#
  MOM_output_literal "M10"
}


#=============================================================
proc PB_CMD_enable_ball_center_output { } {
#=============================================================
# This command can be added to the Start-of-Program event marker
# to enable ball-center output for ANY milling operations that use
# one of the following 3 types (mom_tool_type) of tool:
#  a. "Milling Tool-Ball Mill"
#  b. "Spherical Mill"
#  c. "Milling Tool-5 Parameters" whose tool diameter is 2 times of the corner radius.
#
#  - Only qualified operations will cause NX/Post to produce ball-center outputs.
#  - The condition is verified for every operation.
#  - Ball centers are computed for every move including cutting and non-cutting motions in
#    either standard or turbo process mode.
#  - Legacy command "PB_CMD_center_of_ball_output", if present in the post, will be disabled.
#

   # This command should be called in the Start-of-Program event
   if { ![CALLED_BY "PB_start_of_program"] } {
return
   }

   # This command only works with NX9 & beyond.
   if { [expr [string trim [MOM_ask_env_var UGII_MAJOR_VERSION]] < 9] } {
      CATCH_WARNING "[info level 0] is only functional with NX9 and newer!"
return
   }

   # Disable legacy command
   if { [CMD_EXIST PB_CMD_center_of_ball_output] } {
    uplevel #0 {
      proc PB_CMD_center_of_ball_output { } { }
    }
   }


   # Enable new capability
   global mom_sys_enable_ball_center_output
   set mom_sys_enable_ball_center_output 1


   # Define event handler
   if $mom_sys_enable_ball_center_output {
    uplevel #0 {

      #-------------------------------------------------------------------------------
      proc MOM_ball_center_output { } {
         # This event will be triggered before Start-of-Path when
         # an operation is qualified to produce ball-center outputs.
         #
         # This command may be customized as needed.
         #
      }
      #-------------------------------------------------------------------------------

    }
   }

}


#=============================================================
proc PB_CMD_end_of_alignment_character { } {
#=============================================================
 # Return sequnece number back to orignal
 # This command may be used with the command "PM_CMD_start_of_alignment_character"

  global mom_sys_leader saved_seq_num
  set mom_sys_leader(N) $saved_seq_num
}


#=============================================================
proc PB_CMD_fifth_axis_rotate_move { } {
#=============================================================
#
#  This procedure is used by the ROTATE ude command to output a
#  fifth axis rotary move.  You can use the NC Data Definitions
#  section of postbuilder to modify the fifth_axis_rotary_move
#  block template.
#
#  Do NOT add this block to events or markers.  It is a static
#  block and it is not intended to be added to events.  Do NOT
#  change the name of this custom command.
#

  MOM_force once fifth_axis
  MOM_do_template fifth_axis_rotate_move
}


#=============================================================
proc PB_CMD_fix_RAPID_SET { } {
#=============================================================
# This command is provided to overwrite the system RAPID_SET
# (defined in ugpost_base.tcl) in order to correct the problem
# with workplane change that doesn't account for +/- directions
# along X or Y principal axis.  It also fixes the problem that
# the First Move was never identified correctly to force
# the output of the 1st point.
#
# The original command has been renamed as ugpost_RAPID_SET.
#
# - This command may be attached to the "Start of Program" event marker.
#
#
# Revisions:
#-----------
# 02-18-08 gsl - Initial version
# 02-26-09 gsl - Used mom_kin_machine_type to derive machine mode when it's UNDEFINED.
# 08-18-15 sws - PR7294525 : Use mom_current_motion to detect first move & initial move
#

  # Only redefine RAPID_SET once, since ugpost_base is only loaded once.
  #
   if { ![CMD_EXIST ugpost_RAPID_SET] } {
      if { [CMD_EXIST RAPID_SET] } {
         rename RAPID_SET ugpost_RAPID_SET
      }
   } else {
return
   }


#***********
uplevel #0 {

#====================
proc RAPID_SET { } {
#====================

   if { [CMD_EXIST PB_CMD_set_principal_axis] } {
      PB_CMD_set_principal_axis
   }


   global mom_cycle_spindle_axis mom_sys_work_plane_change
   global traverse_axis1 traverse_axis2 mom_motion_event mom_machine_mode
   global mom_pos mom_prev_pos mom_from_pos mom_last_pos mom_sys_home_pos
   global mom_sys_tool_change_pos
   global spindle_first rapid_spindle_inhibit rapid_traverse_inhibit
   global mom_current_motion


   if { ![info exists mom_from_pos($mom_cycle_spindle_axis)] && \
         [info exists mom_sys_home_pos($mom_cycle_spindle_axis)] } {

      set mom_from_pos(0) $mom_sys_home_pos(0)
      set mom_from_pos(1) $mom_sys_home_pos(1)
      set mom_from_pos(2) $mom_sys_home_pos(2)

   } elseif { ![info exists mom_sys_home_pos($mom_cycle_spindle_axis)] && \
              [info exists mom_from_pos($mom_cycle_spindle_axis)] } {

      set mom_sys_home_pos(0) $mom_from_pos(0)
      set mom_sys_home_pos(1) $mom_from_pos(1)
      set mom_sys_home_pos(2) $mom_from_pos(2)

   } elseif { ![info exists mom_sys_home_pos($mom_cycle_spindle_axis)] && \
             ![info exists mom_from_pos($mom_cycle_spindle_axis)] } {

      set mom_from_pos(0) 0.0 ; set mom_sys_home_pos(0) 0.0
      set mom_from_pos(1) 0.0 ; set mom_sys_home_pos(1) 0.0
      set mom_from_pos(2) 0.0 ; set mom_sys_home_pos(2) 0.0
   }

   if { ![info exists mom_sys_tool_change_pos($mom_cycle_spindle_axis)] } {
      set mom_sys_tool_change_pos($mom_cycle_spindle_axis) 100000.0
   }


   set is_initial_move [string match "initial_move" $mom_current_motion]
   set is_first_move   [string match "first_move"   $mom_current_motion]

   if { $is_initial_move || $is_first_move } {
      set mom_last_pos($mom_cycle_spindle_axis) $mom_sys_tool_change_pos($mom_cycle_spindle_axis)
   } else {
      if { [info exists mom_last_pos($mom_cycle_spindle_axis)] == 0 } {
         set mom_last_pos($mom_cycle_spindle_axis) $mom_sys_home_pos($mom_cycle_spindle_axis)
      }
   }


   if { $mom_machine_mode != "MILL" && $mom_machine_mode != "DRILL" } {
     # When machine mode is UNDEFINED, ask machine type
      if { ![string match "MILL" [PB_CMD_ask_machine_type]] } {
return
      }
   }


   WORKPLANE_SET

   set rapid_spindle_inhibit  FALSE
   set rapid_traverse_inhibit FALSE


   if { [EQ_is_lt $mom_pos($mom_cycle_spindle_axis) $mom_last_pos($mom_cycle_spindle_axis)] } {
      set going_lower 1
   } else {
      set going_lower 0
   }


   if { ![info exists mom_sys_work_plane_change] } {
      set mom_sys_work_plane_change 1
   }


  # Reverse workplane change direction per spindle axis
   global mom_spindle_axis

   if { [info exists mom_spindle_axis] } {

    #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    # User can temporarily disable the work plane change for rapid moves along non-principal
    # spindle axis even when work plane change has been set in the Rapid Move event.
    #
    # Work plane change, if set, will still be in effect for moves along principal axes.
    #
    # - This flag has no effect if the work plane change is not set.
    #

      set disable_non_principal_spindle 0


      switch $mom_cycle_spindle_axis {
         0 {
            if [EQ_is_lt $mom_spindle_axis(0) 0.0] {
               set going_lower [expr abs($going_lower - 1)]
            }
         }
         1 {
            if [EQ_is_lt $mom_spindle_axis(1) 0.0] {
               set going_lower [expr abs($going_lower - 1)]
            }
         }
         2 {
         # Multi-spindle machine
            if [EQ_is_lt $mom_spindle_axis(2) 0.0] {
               set going_lower [expr abs($going_lower - 1)]
            }
         }
      }


     # Per user's choice above, disable work plane change for non-principal spindle axis
     #
      if { $disable_non_principal_spindle } {

         if { ![EQ_is_equal $mom_spindle_axis(0) 1] && \
              ![EQ_is_equal $mom_spindle_axis(1) 1] && \
              ![EQ_is_equal $mom_spindle_axis(0) 1] } {

            global mom_user_work_plane_change
            global mom_user_spindle_first

            set mom_user_work_plane_change $mom_sys_work_plane_change
            set mom_sys_work_plane_change 0

            if [info exists spindle_first] {
               set mom_user_spindle_first $spindle_first
            } else {
               set mom_user_spindle_first NONE
            }
         }
      }
   }


   if { $mom_sys_work_plane_change } {

      if { $going_lower } {
         set spindle_first FALSE
      } else {
         set spindle_first TRUE
      }

     # Force output in Initial Move and First Move.
      if { !$is_initial_move && !$is_first_move } {

         if { [EQ_is_equal $mom_pos($mom_cycle_spindle_axis) $mom_last_pos($mom_cycle_spindle_axis)] } {
            set rapid_spindle_inhibit TRUE
         } else {
            set rapid_spindle_inhibit FALSE
         }

         if { [EQ_is_equal $mom_pos($traverse_axis1) $mom_prev_pos($traverse_axis1)] && \
              [EQ_is_equal $mom_pos($traverse_axis2) $mom_prev_pos($traverse_axis2)] && \
              [EQ_is_equal $mom_pos(3) $mom_prev_pos(3)] && \
              [EQ_is_equal $mom_pos(4) $mom_prev_pos(4)] } {

            set rapid_traverse_inhibit TRUE
         } else {
            set rapid_traverse_inhibit FALSE
         }
      }

   } else {
      set spindle_first NONE
   }

} ;# RAPID_SET

} ;# uplevel
#***********
}


#=============================================================
proc PB_CMD_fourth_axis_rotate_move { } {
#=============================================================
#
#  This procedure is used by the ROTATE ude command to output a
#  fourth axis rotary move.  You can use the NC Data Definitions
#  section of postbuilder to modify the fourth_axis_rotary_move
#  block template.
#
#  Do NOT add this block to events or markers.  It is a static
#  block and it is not intended to be added to events.  Do NOT
#  change the name of this custom command.
#

  MOM_force once fourth_axis
  MOM_do_template fourth_axis_rotate_move
}


#=============================================================
proc PB_CMD_handle_sync_event { } {
#=============================================================
  global mom_sync_code
  global mom_sync_index
  global mom_sync_start
  global mom_sync_incr
  global mom_sync_max


  set mom_sync_start     99
  set mom_sync_incr       1
  set mom_sync_max    199


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

set mom_sys_helix_pitch_type    "rise_radian"

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
#    Place your custom helix pitch code here
#
      }
      default { set mom_sys_helix_pitch_type "none" }
   }

   MOM_force once X Y Z

   if {$mom_sys_helix_pitch_type != "none"} {
      MOM_force once I J K
      if {$mom_sys_cir_vector == "Vector - Arc Center to Start"} {
         set mom_prev_pos($cir_index) 0.0
         set mom_pos_arc_center($cir_index) $pitch
      } elseif {$mom_sys_cir_vector == "Vector - Arc Start to Center"} {
         set mom_prev_pos($cir_index) $pitch
         set mom_pos_arc_center($cir_index) 0.0
      } elseif {$mom_sys_cir_vector == "Unsigned Vector - Arc Center to Start"} {
         set mom_prev_pos($cir_index) 0.0
         set mom_pos_arc_center($cir_index) $pitch
      } elseif {$mom_sys_cir_vector == "Absolute Arc Center"} {
         set mom_pos_arc_center($cir_index) $pitch
      }
   }

#
# You may need to edit this line if you output more than one block
# or if you have changed the name of your circular_move block template
#
   MOM_do_template circular_move


} ;# MOM_helix_move


} ;# uplevel
}


#=============================================================
proc PB_CMD_init_rotary { } {
#=============================================================
uplevel #0 {

#
# Fourth Axis Auto Clamping is activated by programming the
# UDE CLAMP/AUTO,ON in your tool path.  Fourth Axis Auto
# Clamping may be turned off by programming the UDE CLAMP/AUTO,OFF.
#
# An M10 will be output to clamp the XYZ axis for fourth axis
# motion. An M11 will be output to un-clamp the fourth axis
# when fourth axis motion occurs in the block.  You may edit
# the custom commands PB_CMD_clamp_fourth_axis or
# PB_CMD_unclamp_fourth_axis to output codes other than M10 or M11.
#
#
# Retract and Re-Engage Parameters
#
# This option is activated by setting the Axis Limit Violation
# Handling option on the Machine Tool dialog to Retract / Re-Engage.
#
# The sequence of actions that take place when a rotary limit violation
# occurs is a retract to the clearance plane at the rapid feedrate,
# reposition the rotary axes so they do not violate, move back to
# the engage point at the retract feedrate and engage into the part again.
#
# You can set additional parameters that will control the retract
# and re-engage motion.
#
# The parameter "mom_kin_retract_plane" defines the distance
# from the center of rotation that the tool will retract when
# an axis violation occurs.  For a four axis head machine tool the
# retraction will be a cylinder.  For a five axis head machine tool
# the retraction will be to a sphere. For rotary tables the
# retraction will be to a plane along the spindle axis.
#

set mom_kin_retract_plane                      10.0


#
# The parameter "mom_kin_reengage_distance" defines the engage
# point above the part.
#

set mom_kin_reengage_distance                  .1


#
# The following parameters are used by UG Post.  Do NOT change
# them unless you know what you are doing.
#

set mom_kin_spindle_axis(0)                    0.0
set mom_kin_spindle_axis(1)                    0.0
set mom_kin_spindle_axis(2)                    1.0

if [info exists mom_sys_spindle_axis] { unset mom_sys_spindle_axis }

set mom_sys_spindle_axis(0)                    0.0
set mom_sys_spindle_axis(1)                    0.0
set mom_sys_spindle_axis(2)                    1.0

set mom_sys_lock_status                        "OFF"

} ;# uplevel
}


#=============================================================
proc PB_CMD_kin_abort_event { } {
#=============================================================
   if { [CMD_EXIST PB_CMD_abort_event] } {
      PB_CMD_abort_event
   }
}


#=============================================================
proc PB_CMD_kin_before_motion { } {
#=============================================================
}


#=============================================================
proc PB_CMD_kin_before_output { } {
#=============================================================
# Broker command ensuring PB_CMD_before_output, if present, gets executed
# by MOM_before_output.
#
# ==> DO NOT add anything here!
# ==> All customization must be done in PB_CMD_before_output!
# ==> PB_CMD_before_output MUST NOT call any "MOM_output" commands!
#
   if { [CMD_EXIST PB_CMD_before_output] } {
      PB_CMD_before_output
   }
}


#=============================================================
proc PB_CMD_kin_end_of_path { } {
#=============================================================
  # Record tool time for this operation.
   if { [CMD_EXIST PB_CMD_set_oper_tool_time] } {
      PB_CMD_set_oper_tool_time
   }

  # Clear tool holder angle used in operation
   global mom_use_b_axis
   UNSET_VARS mom_use_b_axis
}


#=============================================================
proc PB_CMD_kin_feedrate_set { } {
#=============================================================
# This command supercedes the functionalites provided by the
# FEEDRATE_SET in ugpost_base.tcl.  Post Builder automatically
# generates proper call sequences to this command in the
# Event handlers.
#
# This command must be used in conjunction with ugpost_base.tcl.
#
   global   feed com_feed_rate
   global   mom_feed_rate_output_mode super_feed_mode feed_mode
   global   mom_cycle_feed_rate_mode mom_cycle_feed_rate
   global   mom_cycle_feed_rate_per_rev
   global   mom_motion_type
   global   Feed_IPM Feed_IPR Feed_MMPM Feed_MMPR Feed_INV
   global   mom_sys_feed_param
   global   mom_sys_cycle_feed_mode


   set super_feed_mode $mom_feed_rate_output_mode

   set f_pm [ASK_FEEDRATE_FPM]
   set f_pr [ASK_FEEDRATE_FPR]


  #<12-16-2014 gsl> To determine feed mode for RETRACT per motion type
   global mom_motion_event
   if { ![info exists mom_motion_event] } {
      set mom_motion_event UNDEFINED
   }

   set feed_type RAPID


   switch $mom_motion_type {

      CYCLE {
         if { [info exists mom_sys_cycle_feed_mode] } {
            if { [string compare "Auto" $mom_sys_cycle_feed_mode] } {
               set mom_cycle_feed_rate_mode $mom_sys_cycle_feed_mode
            }
         }
         if { [info exists mom_cycle_feed_rate_mode] }    { set super_feed_mode $mom_cycle_feed_rate_mode }
         if { [info exists mom_cycle_feed_rate] }         { set f_pm $mom_cycle_feed_rate }
         if { [info exists mom_cycle_feed_rate_per_rev] } { set f_pr $mom_cycle_feed_rate_per_rev }
      }

      FROM -
      RETURN -
      LIFT -
      TRAVERSAL -
      GOHOME -
      GOHOME_DEFAULT -
      RAPID {
        #<Sep-07-2016 gsl>
        # SUPER_FEED_MODE_SET RAPID
         if { [string match "linear_move"   $mom_motion_event] ||\
              [string match "circular_move" $mom_motion_event] } {
            set feed_type CONTOUR
         }
      }

      default {
        #<Sep-07-2016 gsl>
         if { !([EQ_is_zero $f_pm] && [EQ_is_zero $f_pr]) } {
            set feed_type CONTOUR
         }
      }
   }

  #<Sep-07-2016 gsl>
   if { ![string match "CYCLE" $mom_motion_type] } {
      SUPER_FEED_MODE_SET $feed_type
   }


  # Treat RETRACT as cutting when specified
   global mom_sys_retract_feed_mode
   if { [string match "RETRACT" $mom_motion_type] } {

      if { [info exist mom_sys_retract_feed_mode] && [string match "CONTOUR" $mom_sys_retract_feed_mode] } {
         if { !([EQ_is_zero $f_pm] && [EQ_is_zero $f_pr]) } {
            SUPER_FEED_MODE_SET CONTOUR
         }
      }
   }


   set feed_mode $super_feed_mode


  # Adjust feedrate format per Post output unit again.
   global mom_kin_output_unit
   if { ![string compare "IN" $mom_kin_output_unit] } {
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
      MMPR    { set feed $f_pr }
      DPM     { set feed [PB_CMD_FEEDRATE_DPM] }
      FRN     -
      INVERSE { set feed [PB_CMD_FEEDRATE_NUMBER] }
      default {
         CATCH_WARNING "INVALID FEED RATE MODE"
         return
      }
   }


  # Post Builder provided format for the current mode:
   if { [info exists mom_sys_feed_param(${feed_mode},format)] } {
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


  # Execute user's command, if any.
   if { [CMD_EXIST PB_CMD_FEEDRATE_SET] } {
      PB_CMD_FEEDRATE_SET
   }
}


#=============================================================
proc PB_CMD_kin_handle_sync_event { } {
#=============================================================
  PB_CMD_handle_sync_event
}


#=============================================================
proc PB_CMD_kin_init_new_iks { } {
#=============================================================
   global mom_kin_machine_type
   global mom_new_iks_exists

  # Revert legacy dual-head kinematic parameters when new IKS is absent.
   if { [string match "5_axis_dual_head" $mom_kin_machine_type] } {
      if { ![info exists mom_new_iks_exists] } {
         set ugii_version [string trim [MOM_ask_env_var UGII_VERSION]]
         if { ![string match "v3" $ugii_version] } {

            if { [CMD_EXIST PB_CMD_revert_dual_head_kin_vars] } {
               PB_CMD_revert_dual_head_kin_vars
            }
return
         }
      }
   }

  # Initialize new IKS parameters.
   if { [CMD_EXIST PB_init_new_iks] } {
      PB_init_new_iks
   }

  # Users can provide next command to modify or disable new IKS options.
   if { [CMD_EXIST PB_CMD_revise_new_iks] } {
      PB_CMD_revise_new_iks
   }

  # Revert legacy dual-head kinematic parameters when new IKS is disabled.
   if { [string match "5_axis_dual_head" $mom_kin_machine_type] } {
      global mom_kin_iks_usage
      if { $mom_kin_iks_usage == 0 } {
         if { [CMD_EXIST PB_CMD_revert_dual_head_kin_vars] } {
            PB_CMD_revert_dual_head_kin_vars
         }
      }
   }
}


#=============================================================
proc PB_CMD_kin_init_probing_cycles { } {
#=============================================================
   set cmd PB_CMD_init_probing_cycles
   if { [CMD_EXIST "$cmd"] } {
      eval $cmd
   }
}


#=============================================================
proc PB_CMD_kin_set_csys { } {
#=============================================================
# - For mill post -
#

  # Output NC code according to CSYS
   if { [CMD_EXIST PB_CMD_set_csys] } {
      PB_CMD_set_csys
   }

  # Overload IKS params from machine model.
   PB_CMD_reload_iks_parameters

  # In case Axis Rotation has been set to "reverse"
   if { [CMD_EXIST PB_CMD_reverse_rotation_vector] } {
      PB_CMD_reverse_rotation_vector
   }
}


#=============================================================
proc PB_CMD_kin_start_of_path { } {
#=============================================================
# - For mill post -
#
#  This command is executed at the start of every operation.
#  It will verify if a new head (post) was loaded and will
#  then initialize any functionality specific to that post.
#
#  It will also restore the master Start of Program &
#  End of Program event handlers.
#
#  --> DO NOT CHANGE THIS COMMAND UNLESS YOU KNOW WHAT YOU ARE DOING.
#  --> DO NOT CALL THIS COMMAND FROM ANY OTHER CUSTOM COMMAND.
#
  global mom_sys_head_change_init_program

   if { [info exists mom_sys_head_change_init_program] } {

      PB_CMD_kin_start_of_program
      unset mom_sys_head_change_init_program


     # Load alternate units' parameters
      if [CMD_EXIST PB_load_alternate_unit_settings] {
         PB_load_alternate_unit_settings
         rename PB_load_alternate_unit_settings ""
      }


     # Execute start of head callback in new post's context.
      global CURRENT_HEAD
      if { [info exists CURRENT_HEAD] && [CMD_EXIST PB_start_of_HEAD__$CURRENT_HEAD] } {
         PB_start_of_HEAD__$CURRENT_HEAD
      }

     # Restore master start & end of program handlers
      if { [CMD_EXIST "MOM_start_of_program_save"] } {
         if { [CMD_EXIST "MOM_start_of_program"] } {
            rename MOM_start_of_program ""
         }
         rename MOM_start_of_program_save MOM_start_of_program
      }
      if { [CMD_EXIST "MOM_end_of_program_save"] } {
         if { [CMD_EXIST "MOM_end_of_program"] } {
            rename MOM_end_of_program ""
         }
         rename MOM_end_of_program_save MOM_end_of_program
      }

     # Restore master head change event handler
      if { [CMD_EXIST "MOM_head_save"] } {
         if { [CMD_EXIST "MOM_head"] } {
            rename MOM_head ""
         }
         rename MOM_head_save MOM_head
      }
   }

  # Overload IKS params from machine model.
   PB_CMD_reload_iks_parameters

  # Incase Axis Rotation has been set to "reverse"
   if { [CMD_EXIST PB_CMD_reverse_rotation_vector] } {
      PB_CMD_reverse_rotation_vector
   }

  # Initialize tool time accumulator for this operation.
   if { [CMD_EXIST PB_CMD_init_oper_tool_time] } {
      PB_CMD_init_oper_tool_time
   }

  # Force out motion G code at the start of path.
   MOM_force once G_motion
}


#=============================================================
proc PB_CMD_kin_start_of_program { } {
#=============================================================
#  This command will execute the following custom commands for
#  initialization.  They will be executed once at the start of
#  program and again each time they are loaded as a linked post.
#  After execution they will be deleted so that they are not
#  present when a different post is loaded.  You may add a call
#  to any command that you want executed when a linked post is
#  loaded.
#
#  Note when a linked post is called in, the Start of Program
#  event marker is not executed again.
#
#  --> DO NOT REMOVE ANY LINES FROM THIS PROCEDURE UNLESS YOU KNOW
#      WHAT YOU ARE DOING.
#  --> DO NOT CALL THIS PROCEDURE FROM ANY
#      OTHER CUSTOM COMMAND.
#
   global mom_kin_machine_type


   set command_list [list]

   if { [info exists mom_kin_machine_type] } {
      if { ![string match "*3_axis_mill*" $mom_kin_machine_type] &&\
           ![string match "*lathe*" $mom_kin_machine_type] } {

         lappend command_list  PB_CMD_kin_init_rotary
      }
   }

   lappend command_list  PB_CMD_kin_init_new_iks

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

   lappend command_list  PB_CMD_kin_init_probing_cycles

   lappend command_list  PB_DEFINE_MACROS

   if { [info exists mom_kin_machine_type] } {
      if { [string match "*3_axis_mill_turn*" $mom_kin_machine_type] } {

         lappend command_list  PB_CMD_kin_init_mill_xzc
         lappend command_list  PB_CMD_kin_mill_xzc_init
         lappend command_list  PB_CMD_kin_init_mill_turn
         lappend command_list  PB_CMD_kin_mill_turn_initialize
      }
   }


   foreach cmd $command_list {

      if { [CMD_EXIST "$cmd"] } {

        # <PB v2.0.2>
        # Old init commands for XZC/MILL_TURN posts are not executed.
        # Parameters set by these commands in the v2.0 legacy posts
        # will need to be transfered to PB_CMD_init_mill_xzc &
        # PB_CMD_init_mill_turn commands respectively.

         switch $cmd {
            "PB_CMD_kin_mill_xzc_init" -
            "PB_CMD_kin_mill_turn_initialize" {}
            default { eval $cmd }
         }
         rename $cmd ""
         proc $cmd { args } {}
      }
   }
}


#=============================================================
proc PB_CMD_linear_move { } {
#=============================================================
#
#  This procedure is used my many automatic postbuilder functions
#  to output a linear move.  Do NOT add this block to events or
#  markers.  It is a static block and it is not intended to be added
#  to events.  Do NOT change the name of this procedure.
#
#  If you need a custom command to be output with a linear move block,
#  you must place a call to the custom command either before or after
#  the MOM_do_template command.
#
#  This proc is used for:
#     simulated cycles feed moves
#     mill/turn mill linearization
#     four and five axis retract and re-engage
#

  MOM_do_template linear_move
}


#=============================================================
proc PB_CMD_negate_R_value { } {
#=============================================================
# This command negates the value of radius when the included angle
# of an arc is greater than 180.
#
# ==> This comamnd may be added to the Circular Move event for a post
#     of Fanuc controller when the R-style circular output format is used.
#
# 10-05-11 gsl - (pb801 IR2178985) Initial version
#

   global mom_arc_angle mom_arc_radius

   if [expr $mom_arc_angle > 180.0] {
      set mom_arc_radius [expr -1*$mom_arc_radius]
   }
}


#=============================================================
proc PB_CMD_nurbs_end_of_program { } {
#=============================================================
  global nurbs_move_flag

  if {[info exists nurbs_move_flag]} {MOM_output_literal "G05 P0"}
}


#=============================================================
proc PB_CMD_nurbs_initialize { } {
#=============================================================
#
#  You will need to activate nurbs motion in Unigraphics CAM under
#  machine control to generate nurbs events.
#
#  This procedure is used to establish nurbs parameters.  It must be
#  placed in the Start of Program marker to output nurbs.
#
uplevel #0 {

  set mom_kin_nurbs_output_type              BSPLINE

  MOM_reload_kinematics

proc MOM_nurbs_move {} {
#_______________________________________________________________________________
# This procedure is executed for each nurbs move.
#_______________________________________________________________________________
  global mom_nurbs_knot_count
  global mom_nurbs_point_count
  global mom_nurbs_order

  global nurbs_knot_count
  global nurbs_precision
  global nurbs_move_flag
  global anchor_flag

  if {![info exists nurbs_move_flag]} {
      MOM_output_literal "G05 P10000"
      set nurbs_move_flag 1
  }

  FEEDRATE_SET
  if {![info exists anchor_flag]} {
      MOM_do_template anchor_point
      set anchor_flag 0
  }

  set nurbs_knot_count 0
  MOM_force once G_motion order X Y Z

  while {$nurbs_knot_count < $mom_nurbs_point_count} {
         MOM_do_template nurbs
         set nurbs_knot_count [expr $nurbs_knot_count + 1]
  }
  while {$nurbs_knot_count < $mom_nurbs_knot_count} {
         MOM_do_template knots
         set nurbs_knot_count [expr $nurbs_knot_count + 1]
  }
}




}
}


#=============================================================
proc PB_CMD_output_program_elapsed_time { } {
#=============================================================
# When the elapsed time tracking has been initiated by calling
# "PB_CMD_init_program_elapsed_time" at Start of Program event,
# this command can be added to the End of Program event to output
# the total execution time (in seconds) for a posting job.
#
# => For PB v11.02, "PB_CMD_init_program_elapsed_time" is not needed.
#

   if { ![info exists ::mom_sys_start_program_clock_seconds] } {
return
   }


   set program_elapsed_seconds [expr [clock seconds] - $::mom_sys_start_program_clock_seconds]

   if { [info exists ::mom_kin_is_turbo_output] && [string match "TRUE" $::mom_kin_is_turbo_output] } {
      set msg "Elapsed time - Turbo mode          : $program_elapsed_seconds (seconds)"
   } elseif { [info exists ::mom_sys_advanced_turbo_output] && $::mom_sys_advanced_turbo_output } {
      set msg "Elapsed time - Advanced Turbo mode : $program_elapsed_seconds (seconds)"
   } else {
      set msg "Elapsed time - Standard mode       : $program_elapsed_seconds (seconds)"
   }

   INFO $msg
   OPERATOR_MSG $msg
}


#=============================================================
proc PB_CMD_pause { } {
#=============================================================
# This command enables you to pause the UG/Post processing.
#
  PAUSE
}


#=============================================================
proc PB_CMD_reload_iks_parameters { } {
#=============================================================
# This command overloads new IKS params from a machine model.(NX4)
# It will be executed automatically at the start of each path
# or when CSYS has changed.
#
   global mom_csys_matrix
   global mom_kin_iks_usage

  #----------------------------------------------------------
  # Set a classification to fetch kinematic parameters from
  # a particular set of K-components of a machine.
  # - Default is NONE.
  #----------------------------------------------------------
   set custom_classification NONE

   if { [info exists mom_kin_iks_usage] && $mom_kin_iks_usage == 1 } {
      if [info exists mom_csys_matrix] {
         if [llength [info commands MOM_validate_machine_model] ] {
            if { [MOM_validate_machine_model] == "TRUE" } {
               MOM_reload_iks_parameters "$custom_classification"
               MOM_reload_kinematics
            }
         }
      }
   }
}


#=============================================================
proc PB_CMD_restore_work_plane_change { } {
#=============================================================
#<02-18-08 gsl> Restore work plane change flag, if being disabled due to a simulated cycle.

   global mom_user_work_plane_change mom_sys_work_plane_change
   global mom_user_spindle_first spindle_first

   if { [info exists mom_user_work_plane_change] } {
      set mom_sys_work_plane_change $mom_user_work_plane_change
      set spindle_first $mom_user_spindle_first
      unset mom_user_work_plane_change
      unset mom_user_spindle_first
   }
}


#=============================================================
proc PB_CMD_revise_new_iks { } {
#=============================================================
# This command is executed automatically, which allows you
# to change the default IKS parameters or disable the IKS
# service completely.
#
# *** Do not attach this command to any event marker! ***
#
   global mom_kin_iks_usage
   global mom_kin_rotary_axis_method
   global mom_kin_spindle_axis
   global mom_kin_4th_axis_vector
   global mom_kin_5th_axis_vector


  # Uncomment next statement to disable new IKS service
  # set mom_kin_iks_usage           0


  # Uncomment next statement to change rotary solution method
  # set mom_kin_rotary_axis_method  "ZERO"


  # Uncomment next statement, if any parameter above has changed.
  # MOM_reload_kinematics
}


#=============================================================
proc PB_CMD_run_postprocess { } {
#=============================================================
# This is an example showing how MOM_run_postprocess can be used.
# It can be called in the Start of Program event (or anywhere)
# to process the same objects being posted using a secondary post.
#
# ==> It's advisable NOT to use the active post and the same
#     output file for this secondary posting job.
# ==> Ensure legitimate and fully qualified post processor and
#     output file path are specified with the command.
#

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# CAUTION - Comment out next line to activate this function!
return
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

   MOM_run_postprocess "[file dirname $::mom_event_handler_file_name]/MORI_HORI_Sub.tcl"\
                       "[file dirname $::mom_event_handler_file_name]/MORI_HORI_Sub.def"\
                       "${::mom_output_file_directory}sub_program.out"
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
 # Next option can be set to 1, if the address of cycle's
 # principal axis needs to be suppressed. (Ex. siemens controller)
 #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  set suppress_principal_axis 0


 #++++++++++++++++++++++++++++++++++++++++++++++++++++++
 # Next option can be set to 1, if the plane code needs
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

        if [EQ_is_equal [expr abs($mom_pos(3))] 90.0] {

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
proc PB_CMD_set_principal_axis { } {
#=============================================================
# This command can be used to determine the principal axis.
#
# => It can be used to determine a proper work plane when the
#    "Work Plane" parameter is not specified with an operation.
#
#
# <06-22-09 gsl> - Extracted from PB_CMD_set_cycle_plane
# <10-09-09 gsl> - Do not define mom_pos_arc_plane unless it doesn't exist.
# <03-10-10 gsl> - Respect tool axis for 3-axis & XZC cases
# <01-21-11 gsl> - Enhance header description
# <07-12-12 gsl> - Find principal axis for XZC-mill from the spindle axis
#

   global mom_cycle_spindle_axis
   global mom_spindle_axis
   global mom_cutcom_plane mom_pos_arc_plane


  # Initialization spindle axis
   global mom_kin_spindle_axis
   global mom_sys_spindle_axis
   if { ![info exists mom_kin_spindle_axis] } {
      set mom_kin_spindle_axis(0) 0.0
      set mom_kin_spindle_axis(1) 0.0
      set mom_kin_spindle_axis(2) 1.0
   }
   if { ![info exists mom_sys_spindle_axis] } {
      VMOV 3 mom_kin_spindle_axis mom_sys_spindle_axis
   }
   if { ![info exists mom_spindle_axis] } {
      VMOV 3 mom_sys_spindle_axis mom_spindle_axis
   }


  # Default cycle spindle axis to Z
   set mom_cycle_spindle_axis 2


  # Respect tool axis only for 3-axis mill
   global mom_kin_machine_type mom_tool_axis
   if [string match "3_axis_mill" $mom_kin_machine_type] {
      VMOV 3 mom_tool_axis spindle_axis
   } else {
      VMOV 3 mom_spindle_axis spindle_axis
   }


   if { [EQ_is_equal [expr abs($spindle_axis(0))] 1.0] } {
      set mom_cycle_spindle_axis 0
   }

   if { [EQ_is_equal [expr abs($spindle_axis(1))] 1.0] } {
      set mom_cycle_spindle_axis 1
   }


   switch $mom_cycle_spindle_axis {
      0 {
         set mom_cutcom_plane  YZ
      }
      1 {
         set mom_cutcom_plane  ZX
      }
      2 {
         set mom_cutcom_plane  XY
      }
      default {
         set mom_cutcom_plane  UNDEFINED
      }
   }

  # Set arc plane when it's not defined
   if { ![info exists mom_pos_arc_plane] || $mom_pos_arc_plane == "" } {
      set mom_pos_arc_plane $mom_cutcom_plane
   }
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
   MOM_force once M_spindle S X Y Z F R fourth_axis fifth_axis
}


#=============================================================
proc PB_CMD_suppress_linear_block_plane_code { } {
#=============================================================
# This command is to be called in the linear move event to suppress
# G_plane address when the cutcom status has not changed.
# -- Assuming G_cutcom address is modal and G_plane exists in the block
#
#<10-11-09 gsl> - New
#<01-20-11 gsl> - Force out plane code for the 1st linear move when CUTCOM is on
#<03-16-12 gsl> - Added use of CALLED_BY
#

  # Restrict this command to be executed only by MOM_linear_move
   if { ![CALLED_BY "MOM_linear_move"] } {
return
   }


   global mom_cutcom_status mom_user_prev_cutcom_status

   if { ![info exists mom_cutcom_status] } {
      set mom_cutcom_status UNDEFINED
   }

   if { ![info exists mom_user_prev_cutcom_status] } {
      set mom_user_prev_cutcom_status UNDEFINED
   }


  # Suppress plane code when no change of CUTCOM status
   if { [string match "UNDEFINED" $mom_cutcom_status] ||\
        [string match $mom_user_prev_cutcom_status $mom_cutcom_status] } {

      MOM_suppress once G_plane

   } else {

     # Force out plane code for the 1st CUTCOM activation of an operation,
     # otherwise plane code will only come out when work plane has changed
     # since last activation.
     #

      set force_1st_plane_code  "1"


      if { $force_1st_plane_code } {

        # This var should have been set in PB_first_linear_move
         global mom_sys_first_linear_move

         if { ![info exists mom_sys_first_linear_move] || $mom_sys_first_linear_move } {

            if { [string match "LEFT"  $mom_cutcom_status] ||\
                 [string match "RIGHT" $mom_cutcom_status] ||\
                 [string match "ON"    $mom_cutcom_status] } {

               MOM_force once G_plane
               set mom_sys_first_linear_move 0
            }
         }
      }
   }


   if { ![string match $mom_user_prev_cutcom_status $mom_cutcom_status] } {
      set mom_user_prev_cutcom_status $mom_cutcom_status
   }
}


#=============================================================
proc PB_CMD_tool_change_force_addresses { } {
#=============================================================
  MOM_force once G_adjust H S
}


#=============================================================
proc PB_CMD_unclamp_fourth_axis { } {
#=============================================================
#
#  This procedure is used by auto clamping to output the code
#  needed to unclamp the fourth axis.
#
#  Do NOT add this block to events or markers.  It is a static
#  block and it is not intended to be added to events.  Do NOT
#  change the name of this custom command.
#
  MOM_output_literal "M11"
}


#=============================================================
proc ABORT_EVENT_CHECK { } {
#=============================================================
# Called by every motion event to abort its handler based on
# the setting of mom_sys_abort_next_event.
#
   if { [info exists ::mom_sys_abort_next_event] && $::mom_sys_abort_next_event } {
      if { [CMD_EXIST PB_CMD_kin_abort_event] } {
         PB_CMD_kin_abort_event
      }
   }
}


#=============================================================
proc ARCTAN { y x } {
#=============================================================
   global PI

   if { [EQ_is_zero $y] } { set y 0 }
   if { [EQ_is_zero $x] } { set x 0 }

   if { [expr $y == 0] && [expr $x == 0] } {
      return 0
   }

   set ang [expr atan2($y,$x)]

   if { $ang < 0 } {
      return [expr $ang + $PI*2]
   } else {
      return $ang
   }
}


#=============================================================
proc ARR_sort_array_to_list { ARR {by_value 0} {by_decr 0} } {
#=============================================================
# This command will sort and build a list of elements of an array.
#
#   ARR      : Array Name
#   by_value : 0 Sort elements by names (default)
#              1 Sort elements by values
#   by_decr  : 0 Sort into increasing order (default)
#              1 Sort into decreasing order
#
#   Return a list of {name value} couplets
#
#-------------------------------------------------------------
# Feb-24-2016 gsl - Added by_decr flag
#
   upvar $ARR arr

   set list [list]
   foreach { e v } [array get arr] {
      lappend list "$e $v"
   }

   set val [lindex [lindex $list 0] $by_value]

   if { $by_decr } {
      set trend "decreasing"
   } else {
      set trend "increasing"
   }

   if [expr $::tcl_version > 8.1] {
      if [string is integer "$val"] {
         set list [lsort -integer    -$trend -index $by_value $list]
      } elseif [string is double "$val"] {
         set list [lsort -real       -$trend -index $by_value $list]
      } else {
         set list [lsort -dictionary -$trend -index $by_value $list]
      }
   } else {
      set list    [lsort -dictionary -$trend -index $by_value $list]
   }

return $list
}


#=============================================================
proc AUTO_CLAMP { } {
#=============================================================
#
#  This procedure is used to automaticaaly output clamp and unclamp
#  codes.  This procedure must be placed in the the procedure
#  PB_CMD_before_motion.  By default this procedure will output
#  M10 or M11 to do the clamping and unclamping.
#
   global clamp_rotary_status mom_pos mom_prev_pos mom_sys_auto_clamp

   if {![info exists mom_sys_auto_clamp]} {return}
   if {$mom_sys_auto_clamp != "ON"} {return}

   if {![info exists clamp_rotary_status]} {set clamp_rotary_status "UNDEFINED"}

   set rotary_out [EQ_is_equal $mom_pos(3) $mom_prev_pos(3)]

   if {$rotary_out  == 0 && $clamp_rotary_status != "UNCLAMPED"} {
      PB_CMD_unclamp_fourth_axis
      set clamp_rotary_status "UNCLAMPED"
   } elseif {$rotary_out == 1 && $clamp_rotary_status != "CLAMPED"} {
      PB_CMD_clamp_fourth_axis
      set clamp_rotary_status "CLAMPED"
   }
}


#=============================================================
proc AXIS_SET { axis } {
#=============================================================

  global mom_sys_leader

   if { $axis == "[string index $mom_sys_leader(fourth_axis) 0]AXIS" } {
      return 3
   } elseif { $axis == "[string index $mom_sys_leader(fifth_axis) 0]AXIS" } {
      return 4
   }
}


#=============================================================
proc CALC_CYLINDRICAL_RETRACT_POINT { refpt axis dist ret_pt } {
#=============================================================
  upvar $refpt rfp ; upvar $axis ax ; upvar $ret_pt rtp

#
# return 0 parallel or lies on plane
#        1 unique intersection
#


#
# create plane canonical form
#
  VMOV 3 ax plane
  set plane(3) $dist

  set num [expr $plane(3)-[VEC3_dot rfp plane]]
  set dir [VEC3_dot ax plane]
  if {[EQ_is_zero $dir]} {return 0}
  for {set i 0} {$i < 3} {incr i} {
    set rtp($i) [expr $rfp($i) + $ax($i)*$num/$dir]
  }
  return [RETRACT_POINT_CHECK rfp ax rtp]
}


#=============================================================
proc CALC_SPHERICAL_RETRACT_POINT { refpt axis cen_sphere rad_sphere int_pts } {
#=============================================================

  upvar $refpt rp ; upvar $axis ta ; upvar $cen_sphere cs
  upvar $int_pts ip

   set rad [expr $rad_sphere*$rad_sphere]
   VEC3_sub rp cs v1

   set coeff(2) 1.0
   set coeff(1) [expr ($v1(0)*$ta(0) + $v1(1)*$ta(1) + $v1(2)*$ta(2))*2.0]
   set coeff(0) [expr $v1(0)*$v1(0) + $v1(1)*$v1(1) + $v1(2)*$v1(2) - $rad]

   set num_sol [SOLVE_QUADRATIC coeff roots iroots status degree]
   if {$num_sol == 0} {return 0}

   if {[expr $roots(0)] > [expr $roots(1)] || $num_sol == 1} {
      set d $roots(0)
   } else {
      set d $roots(1)
   }
   set ip(0) [expr $rp(0) + $d*$ta(0)]
   set ip(1) [expr $rp(1) + $d*$ta(1)]
   set ip(2) [expr $rp(2) + $d*$ta(2)]

return [RETRACT_POINT_CHECK rp ta ip]
}


#=============================================================
proc CALLED_BY { caller {out_warn 0} args } {
#=============================================================
# This command can be used in the beginning of a command
# to designate a specific caller for the command in question.
#
# - Users can set the optional flag "out_warn" to "1" to output
#   warning message when a command is being called by a
#   non-designated caller. By default, warning message is suppressed.
#
#  Syntax:
#    if { ![CALLED_BY "cmd_string"] } { return ;# or do something }
#  or
#    if { ![CALLED_BY "cmd_string" 1] } { return ;# To output warning }
#
# Revisions:
#-----------
# 05-25-10 gsl - Initial implementation
# 03-09-11 gsl - Enhanced description
#

   if { [info level] <= 2 } {
return 0
   }

   if { [string match "$caller*" [info level -2] ] } {
return 1
   } else {
      if { $out_warn } {
         CATCH_WARNING "\"[info level -1]\" can not be executed in \"[info level -2]\". \
                        It must be called by \"$caller\"!"
      }
return 0
   }
}


#=============================================================
proc CATCH_WARNING { msg {output 1} } {
#=============================================================
# This command is called in a post to spice up the message to be output to the warning file.
#
   global mom_warning_info
   global mom_motion_event
   global mom_event_number
   global mom_motion_type
   global mom_operation_name


   if { $output == 1 } {

      set level [info level]
      set call_stack ""
      for { set i 1 } { $i < $level } { incr i } {
         set call_stack "$call_stack\[ [lindex [info level $i] 0] \]"
      }

      global mom_o_buffer
      if { ![info exists mom_o_buffer] } {
         set mom_o_buffer ""
      }

      if { ![info exists mom_motion_event] } {
         set mom_motion_event ""
      }

      if { [info exists mom_operation_name] && [string length $mom_operation_name] } {
         set mom_warning_info "$msg\n\  Operation $mom_operation_name - Event $mom_event_number [MOM_ask_event_type] :\
                               $mom_motion_event ($mom_motion_type)\n\    $mom_o_buffer\n\      $call_stack\n"
      } else {
         set mom_warning_info "$msg\n\  Event $mom_event_number [MOM_ask_event_type] :\
                               $mom_motion_event ($mom_motion_type)\n\    $mom_o_buffer\n\      $call_stack\n"
      }

      MOM_catch_warning
   }

   # Restore mom_warning_info for subsequent use
   set mom_warning_info $msg
}


#=============================================================
proc CMD_EXIST { cmd {out_warn 0} args } {
#=============================================================
# This command can be used to detect the existence of a command
# before executing it.
# - Users can set the optional flag "out_warn" to "1" to output
#   warning message when a command to be called doesn't exist.
#   By default, warning message is suppressed.
#
#  Syntax:
#    if { [CMD_EXIST "cmd_string"] } { cmd_string }
#  or
#    if { [CMD_EXIST "cmd_string" 1] } { cmd_string ;# To output warning }
#
# Revisions:
#-----------
# 05-25-10 gsl - Initial implementation
# 03-09-11 gsl - Enhanced description
#

   if { [llength [info commands "$cmd"] ] } {
return 1
   } else {
      if { $out_warn } {
         CATCH_WARNING "Command \"$cmd\" called by \"[info level -1]\" does not exist!"
      }
return 0
   }
}


#=============================================================================
proc COMPARE_NX_VERSION { this_ver target_ver } {
#=============================================================================
# Compare a given NX version with target version.
# ==> Number of fields will be compared based on the number of "." contained in target.
#
# Return 1: Newer
#        0: Same
#       -1: Older
#

   set vlist_1 [split $this_ver   "."]
   set vlist_2 [split $target_ver "."]

   set ver_check 0

   set idx 0
   foreach v2 $vlist_2 {

      if { $ver_check == 0 } {
         set v1 [lindex $vlist_1 $idx]
         if { $v1 > $v2 } {
            set ver_check 1
         } elseif { $v1 == $v2 } {
            set ver_check 0
         } else {
            set ver_check -1
         }
      }

      if { $ver_check != 0 } {
         break
      }

      incr idx
   }

return $ver_check
}


#=============================================================
proc DELAY_TIME_SET { } {
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


#=============================================================================
proc DO_BLOCK { block args } {
#=============================================================================
# May-10-2017 gsl - New (PB v12.0)
#
   set option [lindex $args 0]

   if { [CMD_EXIST MOM_has_definition_element] } {
      if { [MOM_has_definition_element BLOCK $block] } {
         if { $option == "" } {
            return [MOM_do_template $block]
         } else {
            return [MOM_do_template $block $option]
         }
      } else {
         CATCH_WARNING "Block template $block not found."
      }
   } else {
      if { $option == "" } {
         return [MOM_do_template $block]
      } else {
         return [MOM_do_template $block $option]
      }
   }
}


#=============================================================
proc EXEC { command_string {__wait 1} } {
#=============================================================
# This command can be used in place of the intrinsic Tcl "exec" command
# of which some problems have been reported under Win64 O/S and multi-core
# processors environment.
#
#
# Input:
#   command_string -- command string
#   __wait         -- optional flag
#                     1 (default)   = Caller will wait until execution is complete.
#                     0 (specified) = Caller will not wait.
#
# Return:
#   Results of execution
#
#
# Revisions:
#-----------
# 05-19-10 gsl - Initial implementation
#

   global tcl_platform


   if { $__wait } {

      if { [string match "windows" $tcl_platform(platform)] } {

         global env mom_logname

        # Create a temporary file to collect output
         set result_file "$env(TEMP)/${mom_logname}__EXEC_[clock clicks].out"

        # Clean up existing file
         regsub -all {\\} $result_file {/}  result_file
        #regsub -all { }  $result_file {\ } result_file

         if { [file exists "$result_file"] } {
            file delete -force "$result_file"
         }

        #<11-05-2013> Escape spaces
         set cmd [concat exec $command_string > \"$result_file\"]
         regsub -all {\\} $cmd {\\\\} cmd
         regsub -all { }  $result_file {\\\ } result_file

         eval $cmd

        # Return results & clean up temporary file
         if { [file exists "$result_file"] } {
            set fid [open "$result_file" r]
            set result [read $fid]
            close $fid

            file delete -force "$result_file"

           return $result
         }

      } else {

         set cmd [concat exec $command_string]

        return [eval $cmd]
      }

   } else {

      if { [string match "windows" $tcl_platform(platform)] } {

         set cmd [concat exec $command_string &]
         regsub -all {\\} $cmd {\\\\} cmd

        return [eval $cmd]

      } else {

        return [exec $command_string &]
      }
   }
}




#=============================================================
proc HANDLE_FIRST_LINEAR_MOVE { } {
#=============================================================
# Called by MOM_linear_move to handle the 1st linear move of an operation.
#
   if { ![info exists ::first_linear_move] } {
      set ::first_linear_move 0
   }
   if { !$::first_linear_move } {
      PB_first_linear_move
      incr ::first_linear_move
   }
}


#=============================================================
proc INFO { args } {
#=============================================================
   MOM_output_to_listing_device [join $args]
}


#=============================================================
proc LIMIT_ANGLE { a } {
#=============================================================

   set a [expr fmod($a,360)]
   set a [expr ($a < 0) ? ($a + 360) : $a]

return $a
}


#=============================================================
proc LOCK_AXIS { input_point output_point output_rotary } {
#=============================================================
  upvar $input_point ip ; upvar $output_point op ; upvar $output_rotary or

  global mom_kin_4th_axis_center_offset mom_kin_5th_axis_center_offset
  global mom_pos mom_kin_4th_axis_plane mom_kin_5th_axis_plane
  global mom_sys_lock_value mom_sys_lock_plane
  global mom_sys_lock_axis mom_sys_lock_status
  global mom_out_angle_pos mom_prev_out_angle_pos mom_kin_4th_axis_direction
  global mom_kin_5th_axis_direction mom_kin_4th_axis_leader mom_kin_5th_axis_leader
  global mom_sys_leader
  global DEG2RAD RAD2DEG

   if {$mom_sys_lock_status == "OFF"} {
      return
   }
   VEC3_sub ip mom_kin_4th_axis_center_offset temp
   if [info exists mom_kin_5th_axis_center_offset] {
      VEC3_sub temp mom_kin_5th_axis_center_offset temp
   }
   set temp(3) $ip(3)
   set temp(4) $ip(4)

   if {$mom_sys_lock_plane == -1} {
      if {$mom_kin_4th_axis_plane == "XY"} {
         set mom_sys_lock_plane 2
      } elseif {$mom_kin_4th_axis_plane == "ZX"} {
         set mom_sys_lock_plane 1
      } elseif {$mom_kin_4th_axis_plane == "YZ"} {
         set mom_sys_lock_plane 0
      }
   }

   if {$mom_kin_4th_axis_plane == "XY"} {
      set fourth_axis 2
   } elseif {$mom_kin_4th_axis_plane == "ZX"} {
      set fourth_axis 1
   } elseif {$mom_kin_4th_axis_plane == "YZ"} {
      set fourth_axis 0
   }

   if {[info exists mom_kin_5th_axis_plane]} {
      if {$mom_kin_5th_axis_plane == "XY"} {
         set fifth_axis 2
      } elseif {$mom_kin_5th_axis_plane == "ZX"} {
         set fifth_axis 1
      } elseif {$mom_kin_5th_axis_plane == "YZ"} {
         set fifth_axis 0
      }
   } else {
      set fifth_axis -1
   }


   if {$mom_sys_lock_axis > 2} {
      set angle [expr ($mom_sys_lock_value-$temp($mom_sys_lock_axis))*$DEG2RAD]
      ROTATE_VECTOR $mom_sys_lock_plane $angle temp temp1
      VMOV 3 temp1 temp
      set temp($mom_sys_lock_axis) $mom_sys_lock_value
   } else {
      if {$mom_sys_lock_plane == 0} {
         set i1 1
         set i2 2
      } elseif {$mom_sys_lock_plane == 1} {
         set i1 2
         set i2 0
      } elseif {$mom_sys_lock_plane == 2} {
         set i1 0
         set i2 1
      }
      set unlocked_axis [expr $i1 + $i2 - $mom_sys_lock_axis]
      set rad [expr sqrt($temp($i1)*$temp($i1) + $temp($i2)*$temp($i2))]
      set angle [ARCTAN $temp($i2) $temp($i1)]
      if { $rad < [expr abs($mom_sys_lock_value)]} {
         if {$mom_sys_lock_value < 0.0} {
            set temp($mom_sys_lock_axis) [expr -$rad]
         } else {
            set temp($mom_sys_lock_axis) $rad
         }
      } else {
         set temp($mom_sys_lock_axis) $mom_sys_lock_value
      }

      set temp($unlocked_axis)  [expr sqrt($rad*$rad - $temp($mom_sys_lock_axis)*$temp($mom_sys_lock_axis))]

      if {$mom_sys_lock_plane == $fourth_axis || $mom_sys_lock_plane == $fifth_axis} {
         VMOV 5 temp temp1
         set temp1($unlocked_axis) [expr -$temp($unlocked_axis)]
         set ang1 [ARCTAN $temp($i2) $temp($i1)]
         set ang2 [ARCTAN $temp1($i2) $temp1($i1)]
         if {$mom_sys_lock_plane == $fourth_axis} {
            set i1 3
         } else {
            set i1 4
         }
         set temp($i1) [expr ($angle-$ang1)*$RAD2DEG]
         set temp1($i1) [expr ($angle-$ang2)*$RAD2DEG]
         set ang1 [LIMIT_ANGLE [expr $ip($i1)-$temp($i1)]]
         set ang2 [LIMIT_ANGLE [expr $ip($i1)-$temp1($i1)]]
         if {$ang1 > 180.0} {set ang1 [LIMIT_ANGLE [expr -$ang1]]}
         if {$ang2 > 180.0} {set ang2 [LIMIT_ANGLE [expr -$ang2]]}
         if {$ang1 > $ang2} {VMOV 5 temp1 temp}
      }
   }

   VEC3_add temp mom_kin_4th_axis_center_offset op
   if {[info exists mom_kin_5th_axis_center_offset]} {
      VEC3_add op mom_kin_5th_axis_center_offset op
   }

   if {![info exists or]} {
      set or(0) 0.0
      set or(1) 0.0
   }
   if {![info exists mom_prev_out_angle_pos]} {
      set mom_prev_out_angle_pos(0) $or(0)
      set mom_prev_out_angle_pos(1) $or(1)
   }

   set or(0) [ROTSET $temp(3) $mom_prev_out_angle_pos(0) $mom_kin_4th_axis_direction $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)]
   if {[info exists mom_kin_5th_axis_direction]} {
      set or(1) [ROTSET $temp(4) $mom_prev_out_angle_pos(1) $mom_kin_5th_axis_direction $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)]
   }

   set op(3) $temp(3)
   set op(4) $temp(4)
}


#=============================================================
proc LOCK_AXIS_MOTION { } {
#=============================================================
#
#  The UDE lock_axis must be specified in the tool path
#  for the post to lock the requested axis.  The UDE lock_axis may only
#  be used for four and five axis machine tools.  A four axis post may
#  only lock an axis in the plane of the fourth axis.  If you have a
#  five axis machine you must specify a plane since there are two
#  possible planes.
#
  global mom_pos mom_out_angle_pos mom_current_motion mom_motion_type
  global mom_cycle_feed_to_pos mom_cycle_feed_to mom_tool_axis
  global mom_motion_event mom_sys_lock_status
  global mom_cycle_rapid_to_pos mom_cycle_retract_to_pos
  global mom_cycle_rapid_to mom_cycle_retract_to

  if {$mom_sys_lock_status == "ON"} {
    if {$mom_current_motion != "circular_move"} {
      LOCK_AXIS mom_pos mom_pos mom_out_angle_pos
      MOM_reload_variable -a mom_out_angle_pos
      if {$mom_motion_type == "CYCLE"} {
        if {$mom_motion_event == "initial_move"} {
           set mom_pos(0) [expr $mom_pos(0) - $mom_cycle_rapid_to * $mom_tool_axis(0)]
           set mom_pos(1) [expr $mom_pos(1) - $mom_cycle_rapid_to * $mom_tool_axis(1)]
           set mom_pos(2) [expr $mom_pos(2) - $mom_cycle_rapid_to * $mom_tool_axis(2)]
        }
        set mom_cycle_feed_to_pos(0) [expr $mom_pos(0) + $mom_cycle_feed_to * $mom_tool_axis(0)]
        set mom_cycle_feed_to_pos(1) [expr $mom_pos(1) + $mom_cycle_feed_to * $mom_tool_axis(1)]
        set mom_cycle_feed_to_pos(2) [expr $mom_pos(2) + $mom_cycle_feed_to * $mom_tool_axis(2)]

        set mom_cycle_rapid_to_pos(0) [expr $mom_pos(0) + $mom_cycle_rapid_to * $mom_tool_axis(0)]
        set mom_cycle_rapid_to_pos(1) [expr $mom_pos(1) + $mom_cycle_rapid_to * $mom_tool_axis(1)]
        set mom_cycle_rapid_to_pos(2) [expr $mom_pos(2) + $mom_cycle_rapid_to * $mom_tool_axis(2)]

        set mom_cycle_retract_to_pos(0) [expr $mom_pos(0) + $mom_cycle_retract_to * $mom_tool_axis(0)]
        set mom_cycle_retract_to_pos(1) [expr $mom_pos(1) + $mom_cycle_retract_to * $mom_tool_axis(1)]
        set mom_cycle_retract_to_pos(2) [expr $mom_pos(2) + $mom_cycle_retract_to * $mom_tool_axis(2)]
      }
    }
  }
}


#=============================================================
proc LOCK_AXIS_SUB { axis } {
#=============================================================
  global mom_pos mom_lock_axis_value_defined mom_lock_axis_value

   if {$mom_lock_axis_value_defined == 1} {
      return $mom_lock_axis_value
   } else {
      return $mom_pos($axis)
   }
}


#=============================================================
proc MAXMIN_ANGLE { a max min {tol_flag 0} } {
#=============================================================

   if { $tol_flag == 0 } { ;# Direct comparison

      while { $a < $min } { set a [expr $a + 360.0] }
      while { $a > $max } { set a [expr $a - 360.0] }

   } else { ;# Tolerant comparison

      while { [EQ_is_lt $a $min] } { set a [expr $a + 360.0] }
      while { [EQ_is_gt $a $max] } { set a [expr $a - 360.0] }
   }

return $a
}


#=============================================================
proc OPERATOR_MSG { msg {seq_no 0} } {
#=============================================================
# This command will output a single or a set of operator message(s).
#
#   msg    : Message(s separated by new-line character)
#   seq_no : 0 Output message without sequence number (Default)
#            1 Output message with sequence number
#

   foreach s [split $msg \n] {
      set s1 "$::mom_sys_control_out $s $::mom_sys_control_in"
      if { !$seq_no } {
         MOM_suppress once N
      }
      MOM_output_literal $s1
   }

   set ::mom_o_buffer ""
}


#=============================================================
proc PAUSE { args } {
#=============================================================
# Revisions:
#-----------
# 05-19-10 gsl - Use EXEC command
#

   global env

   if { [info exists env(PB_SUPPRESS_UGPOST_DEBUG)]  &&  $env(PB_SUPPRESS_UGPOST_DEBUG) == 1 } {
  return
   }


   global gPB

   if { [info exists gPB(PB_disable_MOM_pause)]  &&  $gPB(PB_disable_MOM_pause) == 1 } {
  return
   }


   global tcl_platform

   set cam_aux_dir  [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]

   if { [string match "*windows*" $tcl_platform(platform)] } {
      set ug_wish "ugwish.exe"
   } else {
      set ug_wish ugwish
   }

   if { [file exists ${cam_aux_dir}$ug_wish]  &&  [file exists ${cam_aux_dir}mom_pause.tcl] } {

      set title ""
      set msg ""

      if { [llength $args] == 1 } {
         set msg [lindex $args 0]
      }

      if { [llength $args] > 1 } {
         set title [lindex $args 0]
         set msg [lindex $args 1]
      }

      set command_string [concat \"${cam_aux_dir}$ug_wish\" \"${cam_aux_dir}mom_pause.tcl\" \"$title\" \"$msg\"]

      set res [EXEC $command_string]


      switch [string trim $res] {
         no {
            set gPB(PB_disable_MOM_pause) 1
         }
         cancel {
            set gPB(PB_disable_MOM_pause) 1

            uplevel #0 {
               MOM_abort "*** User Abort Post Processing *** "
            }
         }
         default {
            return
         }
      }

   } else {

      CATCH_WARNING "PAUSE not executed -- \"$ug_wish\" or \"mom_pause.tcl\" not found"
   }
}


#=============================================================
proc PAUSE_win64 { args } {
#=============================================================
   global env
   if { [info exists env(PB_SUPPRESS_UGPOST_DEBUG)]  &&  $env(PB_SUPPRESS_UGPOST_DEBUG) == 1 } {
  return
   }

   global gPB
   if { [info exists gPB(PB_disable_MOM_pause)]  &&  $gPB(PB_disable_MOM_pause) == 1 } {
  return
   }


   set cam_aux_dir  [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]
   set ug_wish "ugwish.exe"

   if { [file exists ${cam_aux_dir}$ug_wish] &&\
        [file exists ${cam_aux_dir}mom_pause_win64.tcl] } {

      set title ""
      set msg ""

      if { [llength $args] == 1 } {
         set msg [lindex $args 0]
      }

      if { [llength $args] > 1 } {
         set title [lindex $args 0]
         set msg [lindex $args 1]
      }


     ######
     # Define a scratch file and pass it to mom_pause_win64.tcl script -
     #
     #   A separated process will be created to construct the Tk dialog.
     #   This process will communicate with the main process via the state of a scratch file.
     #   This scratch file will collect the messages that need to be conveyed from the
     #   child process to the main process.
     ######
      global mom_logname
      set pause_file_name "$env(TEMP)/${mom_logname}_mom_pause_[clock clicks].txt"


     ######
     # Path names should be per unix style for "open" command
     ######
      regsub -all {\\} $pause_file_name {/}  pause_file_name
      regsub -all { }  $pause_file_name {\ } pause_file_name
      regsub -all {\\} $cam_aux_dir {/}  cam_aux_dir
      regsub -all { }  $cam_aux_dir {\ } cam_aux_dir

      if [file exists $pause_file_name] {
         file delete -force $pause_file_name
      }


     ######
     # Note that the argument order for mom_pasue.tcl has been changed
     # The assumption at this point is we will always have the communication file as the first
     # argument and optionally the title and message as the second and third arguments
     ######
      open "|${cam_aux_dir}$ug_wish ${cam_aux_dir}mom_pause_win64.tcl ${pause_file_name} {$title} {$msg}"


     ######
     # Waiting for the mom_pause to complete its process...
     # - This is indicated when the scratch file materialized and became read-only.
     ######
      while { ![file exists $pause_file_name] || [file writable $pause_file_name] } { }


     ######
     # Delay a 100 milli-seconds to ensure that sufficient time is given for the other process to complete.
     ######
      after 100


     ######
     # Open the scratch file to read and process the information.  Close it afterward.
     ######
      set fid [open "$pause_file_name" r]

      set res [string trim [gets $fid]]
      switch $res {
         no {
            set gPB(PB_disable_MOM_pause) 1
         }
         cancel {
            close $fid
            file delete -force $pause_file_name

            set gPB(PB_disable_MOM_pause) 1

            uplevel #0 {
               MOM_abort "*** User Abort Post Processing *** "
            }
         }
         default {}
      }


     ######
     # Delete the scratch file
     ######
      close $fid
      file delete -force $pause_file_name
   }
}


#=============================================================
proc PAUSE_x { args } {
#=============================================================
   global env
   if { [info exists env(PB_SUPPRESS_UGPOST_DEBUG)]  &&  $env(PB_SUPPRESS_UGPOST_DEBUG) == 1 } {
  return
   }

   global gPB
   if { [info exists gPB(PB_disable_MOM_pause)]  &&  $gPB(PB_disable_MOM_pause) == 1 } {
  return
   }



  #==========
  # Win64 OS
  #
   global tcl_platform

   if { [string match "*windows*" $tcl_platform(platform)] } {
      global mom_sys_processor_archit

      if { ![info exists mom_sys_processor_archit] } {
         set pVal ""
         set env_vars [array get env]
         set idx [lsearch $env_vars "PROCESSOR_ARCHITE*"]
         if { $idx >= 0 } {
            set pVar [lindex $env_vars $idx]
            set pVal [lindex $env_vars [expr $idx + 1]]
         }
         set mom_sys_processor_archit $pVal
      }

      if { [string match "*64*" $mom_sys_processor_archit] } {

         PAUSE_win64 $args
  return
      }
   }



   set cam_aux_dir  [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]


   if { [string match "*windows*" $tcl_platform(platform)] } {
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

      set res [exec ${cam_aux_dir}$ug_wish ${cam_aux_dir}mom_pause.tcl $title $msg]
      switch $res {
         no {
            set gPB(PB_disable_MOM_pause) 1
         }
         cancel {
            set gPB(PB_disable_MOM_pause) 1

            uplevel #0 {
               MOM_abort "*** User Abort Post Processing *** "
            }
         }
         default { return }
      }
   }
}


#=============================================================
proc REPOSITION_ERROR_CHECK { warn } {
#=============================================================
  global mom_kin_4th_axis_max_limit mom_kin_4th_axis_min_limit
  global mom_kin_5th_axis_max_limit mom_kin_5th_axis_min_limit
  global mom_pos mom_prev_pos mom_alt_pos mom_alt_prev_pos
  global mom_sys_rotary_error mom_warning_info mom_kin_machine_type

  if {$warn != "secondary rotary position being used" || [string index $mom_kin_machine_type 0] != 5} {
    set mom_sys_rotary_error $warn
    return
  }

  set mom_sys_rotary_error 0

  set a4 [expr $mom_alt_pos(3)+360.0]
  set a5 [expr $mom_alt_pos(4)+360.0]
  while {[expr $a4-$mom_kin_4th_axis_min_limit] > 360.0} {set a4 [expr $a4-360.0]}
  while {[expr $a5-$mom_kin_5th_axis_min_limit] > 360.0} {set a5 [expr $a5-360.0]}
  if {$a4 <= $mom_kin_4th_axis_max_limit && $a5 <= $mom_kin_5th_axis_max_limit} {return}

  for {set i 0} {$i < 2} {incr i} {
    set rot($i) [expr $mom_pos([expr $i+3]) - $mom_prev_pos([expr $i+3])]
    while {$rot($i) > 180.0} {set rot($i) [expr $rot($i)-360.0]}
    while {$rot($i) < 180.0} {set rot($i) [expr $rot($i)+360.0]}
    set rot($i) [expr abs($rot($i))]

    set rotalt($i) [expr $mom_alt_pos([expr $i+3]) - $mom_prev_pos([expr $i+3])]
    while {$rotalt($i) > 180.0} {set rotalt($i) [expr $rotalt($i)-360.0]}
    while {$rotalt($i) < 180.0} {set rotalt($i) [expr $rotalt($i)+360.0]}
    set rotalt($i) [expr abs($rotalt($i))]
  }

  if {[EQ_is_equal [expr $rot(0)+$rot(1)] [expr $rotalt(0)+$rotalt(1)]]} {return}
  set mom_sys_rotary_error $warn
}


#=============================================================
proc RETRACT_POINT_CHECK { refpt axis retpt } {
#=============================================================
  upvar $refpt rfp ; upvar $axis ax ; upvar $retpt rtp

#
#  determine if retraction point is "below" the retraction plane
#  if the tool is already in a safe position, do not retract
#
#  return 0    no retract needed
#         1     retraction needed
#

  VEC3_sub rtp rfp vec
  if {[VEC3_is_zero vec]} {return 0}
  set x [VEC3_unitize vec vec1]
  set dir [VEC3_dot ax vec1]
  if {$dir <= 0.0} {
    return 0
  } else {
    return 1
  }
}


#=============================================================
proc ROTARY_AXIS_RETRACT { } {
#=============================================================
#
#  This procedure is used by four and five axis posts to retract
#  from the part when the rotary axis become discontinuous.  This
#  procedure must be placed in the MOM_before_motion event.
#
  global mom_kin_retract_plane mom_kin_reengage_distance
  global mom_kin_rotary_reengage_feedrate mom_kin_rapid_feed_rate
  global mom_sys_rotary_error mom_pos mom_prev_pos
  global mom_prev_out_angle_pos
  global mom_kin_4th_axis_direction mom_kin_4th_axis_leader
  global mom_out_angle_pos mom_kin_5th_axis_direction mom_kin_5th_axis_leader
  global mom_kin_4th_axis_center_offset mom_kin_5th_axis_center_offset
  global mom_sys_leader mom_tool_axis mom_prev_tool_axis mom_kin_4th_axis_type
  global mom_kin_spindle_axis mom_motion_event
  global mom_alt_pos mom_prev_alt_pos mom_feed_rate
  global mom_kin_rotary_reengage_feedrate
  global mom_feed_engage_value mom_feed_cut_value
  global mom_kin_4th_axis_limit_action mom_warning_info


   if {[info exists mom_sys_rotary_error] && [info exists mom_motion_event]} {

      if {$mom_sys_rotary_error != 0 && $mom_motion_event == "linear_move"} {

         if {$mom_kin_4th_axis_limit_action == "Warning"} {
            set mom_warning_info  "Rotary axis limit violated, discontinuos motion may result"
            MOM_catch_warning
            unset mom_sys_rotary_error
            return
         }


         if {$mom_sys_rotary_error == "ROTARY CROSSING LIMIT." } {
            set roterr 0
         } else {
            set roterr 1
         }

         unset mom_sys_rotary_error

        # Retract from part

         VMOV 5 mom_pos save_pos
         VMOV 5 mom_prev_pos save_prev_pos
         VMOV 2 mom_out_angle_pos save_out_angle_pos
         set save_feedrate $mom_feed_rate

         set cen(0) 0.0
         set cen(1) 0.0
         set cen(2) 0.0
         if [info exists mom_kin_4th_axis_center_offset] {
            VEC3_add cen mom_kin_4th_axis_center_offset cen
         }
         if [info exists mom_kin_5th_axis_center_offset] {
            VEC3_sub cen mom_kin_5th_axis_center_offset cen
         }
         if {$mom_kin_4th_axis_type == "Table"} {
            set num_sol [CALC_CYLINDRICAL_RETRACT_POINT mom_prev_pos mom_kin_spindle_axis $mom_kin_retract_plane ret_pt]
         } else {
            set num_sol [CALC_SPHERICAL_RETRACT_POINT mom_prev_pos mom_prev_tool_axis cen $mom_kin_retract_plane ret_pt]
         }


         set mom_feed_rate $mom_kin_rapid_feed_rate
         FEEDRATE_SET


         if {$num_sol != 0} {
            MOM_suppress once fourth_axis fifth_axis
            VEC3_add ret_pt cen mom_pos
            PB_CMD_linear_move
         }

        #
        # temporary fix for missing mom_prev_out_angle_pos(0)
        #
         if {![info exists mom_prev_out_angle_pos(0)]} {
            set mom_prev_out_angle_pos(0) [MOM_ask_address_value fourth_axis]
         }
         if {![info exists mom_prev_out_angle_pos(1)]} {
            set mom_prev_out_angle_pos(1) [MOM_ask_address_value fifth_axis]
         }


         if {$roterr == 0} {
           #
           # unwind table
           #
            if {[info exists mom_kin_4th_axis_direction]} {
               set mom_out_angle_pos(0) [ROTSET $mom_prev_pos(3) $mom_out_angle_pos(0) $mom_kin_4th_axis_direction $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)]
            }
            if {[info exists mom_kin_5th_axis_direction]} {
               set mom_out_angle_pos(1) [ROTSET $mom_prev_pos(4) $mom_out_angle_pos(1) $mom_kin_5th_axis_direction $mom_kin_5th_axis_leader mom_sys_leader(fourth_axis)]
            }
            MOM_suppress once X Y Z
            PB_CMD_linear_move
            for {set i 0} {$i < 3} {incr i} {
               set mom_pos($i) [expr $mom_prev_pos($i)+$mom_kin_reengage_distance*$mom_kin_spindle_axis($i)]
            }
            MOM_suppress once fourth_axis fifth_axis
            PB_CMD_linear_move
            VMOV 3 mom_prev_pos mom_pos
            MOM_suppress once fourth_axis fifth_axis
            if {$mom_feed_engage_value  > 0.0} {
               set mom_feed_rate $mom_feed_engage_value
            } elseif {$mom_feed_cut_value  > 0.0} {
               set mom_feed_rate $mom_feed_cut_value
            } else {
               set mom_feed_rate 10.0
            }
            FEEDRATE_SET
            PB_CMD_linear_move
            VMOV 5 save_pos mom_pos
            VMOV 5 save_prev_pos mom_prev_pos
            VMOV 2 save_out_angle_pos mom_out_angle_pos
         } else {
           #
           # move to alternate rotary position
           #
            set mom_out_angle_pos(0) [ROTSET $mom_prev_alt_pos(3) $mom_prev_out_angle_pos(0) $mom_kin_4th_axis_direction $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)]
            set mom_out_angle_pos(1) [ROTSET $mom_prev_alt_pos(4) $mom_prev_out_angle_pos(1) $mom_kin_5th_axis_direction $mom_kin_5th_axis_leader mom_sys_leader(fourth_axis)]
            MOM_suppress once X Y Z
            PB_CMD_linear_move
            for {set i 0} {$i < 3} {incr i} {
               set mom_pos($i) [expr $mom_prev_alt_pos($i)+$mom_kin_reengage_distance*$mom_prev_tool_axis($i)]
            }
            MOM_suppress once fourth_axis fifth_axis
            PB_CMD_linear_move
            VMOV 3 mom_prev_alt_pos mom_pos
            MOM_suppress once fourth_axis fifth_axis
            if {$mom_feed_engage_value  > 0.0} {
               set mom_feed_rate $mom_feed_engage_value
            } elseif {$mom_feed_cut_value  > 0.0} {
               set mom_feed_rate $mom_feed_cut_value
            } else {
               set mom_feed_rate 10.0
            }
            FEEDRATE_SET
            PB_CMD_linear_move

            VMOV 5 save_pos mom_pos
            VMOV 5 save_prev_pos mom_prev_pos

            set mom_out_angle_pos(0) [ROTSET $mom_pos(3) $mom_out_angle_pos(0) $mom_kin_4th_axis_direction $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)]
            set mom_out_angle_pos(1) [ROTSET $mom_pos(4) $mom_out_angle_pos(1) $mom_kin_5th_axis_direction $mom_kin_5th_axis_leader mom_sys_leader(fourth_axis)]

            MOM_reload_variable -a mom_out_angle_pos
         }

         set save_feedrate $mom_feed_rate
         FEEDRATE_SET
      }
   }
}


#=============================================================
proc ROTATE_VECTOR { plane angle input_vector output_vector } {
#=============================================================
  upvar $output_vector v ; upvar $input_vector v1

   if {$plane == 0} {
      set v(0) $v1(0)
      set v(1) [expr $v1(1)*cos($angle) - $v1(2)*sin($angle)]
      set v(2) [expr $v1(2)*cos($angle) + $v1(1)*sin($angle)]
   } elseif {$plane == 1} {
      set v(0) [expr $v1(0)*cos($angle) + $v1(2)*sin($angle)]
      set v(1) $v1(1)
      set v(2) [expr $v1(2)*cos($angle) - $v1(0)*sin($angle)]
   } elseif {$plane == 1} {
      set v(0) [expr $v1(0)*cos($angle) - $v1(1)*sin($angle)]
      set v(1) [expr $v1(1)*cos($angle) + $v1(0)*sin($angle)]
      set v(2) $v1(2)
   }
}


#=============================================================
proc ROTSET { angle prev_angle dir kin_leader sys_leader } {
#=============================================================

#  This procedure will take an input angle and format for a specific machine.
#
#  angle    angle to be output.
#  prev_angle    previous angle out.  It should be mom_out_angle_pos
#  dir        can be either MAGNITUDE_DETERMINES_DIRECTION or
#        SIGN_DETERMINES_DIRECTION
#  kin_leader    leader (usually A, B or C) defined by postbuilder
#  sys_leader   leader that is created by rotset.  It could be C-.
#
  upvar $sys_leader lead

   while {$angle < 0.0} {set angle [expr $angle+360.0]}
   while {$angle >= 360.0} {set angle [expr $angle-360.0]}

   if {$dir == "MAGNITUDE_DETERMINES_DIRECTION"} {
      while {[expr abs([expr $angle-$prev_angle])] > 180.0} {
         if {[expr $angle-$prev_angle] < -180.0} {
            set angle [expr $angle+360.0]
         } elseif {[expr $angle-$prev_angle] > 180.0} {
            set angle [expr $angle-360.0]
         }
      }
   } elseif {$dir == "SIGN_DETERMINES_DIRECTION"} {
      set del [expr $angle-$prev_angle]
      if {($del < 0.0 && $del > -180.0) || $del > 180.0} {
         set lead "$kin_leader-"
      } else {
         set lead $kin_leader
      }
   }

return $angle
}


#=============================================================
proc SET_LOCK { axis plane value } {
#=============================================================
  upvar $axis a ; upvar $plane p ; upvar $value v

  global mom_kin_machine_type mom_lock_axis mom_lock_axis_plane mom_lock_axis_value
  global mom_warning_info

   switch $mom_kin_machine_type {
      4_axis_head -
      4_AXIS_HEAD -
      4_axis_table -
      4_AXIS_TABLE -
      mill_turn -
      MILL_TURN            {set mtype 4}
      5_axis_dual_table -
      5_AXIS_DUAL_TABLE -
      5_axis_dual_head -
      5_AXIS_DUAL_HEAD -
      5_axis_head_table -
      5_AXIS_HEAD_TABLE    {set mtype 5}
      default {
         set mom_warning_info "Set lock only vaild for 4 and 5 axis machines"
         return "error"
      }
   }

   set p -1

   switch $mom_lock_axis {
      OFF {
         return "OFF"
      }
      XAXIS {
         set a 0
         switch $mom_lock_axis_plane {
            XYPLAN {
               set v [LOCK_AXIS_SUB $a]
               set p 2
            }
            YZPLAN {
               set mom_warning_info "Invalid plane for lock axis"
               return "error"
            }
            ZXPLAN {
               set v [LOCK_AXIS_SUB $a]
               set p 1
            }
            NONE {
               if {$mtype == 5} {
                  set mom_warning_info "Must specify lock axis plane for 5 axis machine"
                  return "error"
               } else {
                  set v [LOCK_AXIS_SUB $a]
               }
            }
         }
      }
      YAXIS {
         set a 1
         switch $mom_lock_axis_plane {
            XYPLAN {
               set v [LOCK_AXIS_SUB $a]
               set p 2
            }
            YZPLAN {
               set v [LOCK_AXIS_SUB $a]
               set p 0
            }
            ZXPLAN {
               set mom_warning_info "Invalid plane for lock axis"
               return "error"
            }
            NONE {
               if {$mtype == 5} {
                  set mom_warning_info "Must specify lock axis plane for 5 axis machine"
                  return "error"
               } else {
                  set v [LOCK_AXIS_SUB $a]
               }
            }
         }
      }
      ZAXIS {
         set a 2
         switch $mom_lock_axis_plane {
            YZPLAN {
               set v [LOCK_AXIS_SUB $a]
               set p 0
            }
            ZXPLAN {
               set v [LOCK_AXIS_SUB $a]
               set p 1
            }
            XYPLAN {
               set mom_warning_info "Invalid plane for lock axis"
               return "error"
            }
            NONE {
               if {$mtype == 5} {
                  set mom_warning_info "Must specify lock axis plane for 5 axis machine"
                  return "error"
               } else {
                  set v [LOCK_AXIS_SUB $a]
               }
            }
         }
      }
      FOURTH {
         set a 3
         set v [LOCK_AXIS_SUB $a]
      }
      FIFTH {
         set a 4
         set v [LOCK_AXIS_SUB $a]
      }
      AAXIS {
         set a [AXIS_SET $mom_lock_axis]
         set v [LOCK_AXIS_SUB $a]
      }
      BAXIS {
         set a [AXIS_SET $mom_lock_axis]
         set v [LOCK_AXIS_SUB $a]
      }
      CAXIS {
         set a [AXIS_SET $mom_lock_axis]
         set v [LOCK_AXIS_SUB $a]
      }
   }

return "ON"
}


#=============================================================
proc SOLVE_QUADRATIC { coeff rcomp icomp status degree } {
#=============================================================

  upvar $coeff c ; upvar $rcomp rc ; upvar $icomp ic
  upvar $status st ; upvar $degree deg

   set st 1
   set deg 0
   set rc(0) 0.0 ; set rc(1) 0.0
   set ic(0) 0.0 ; set ic(1) 0.0
   set mag [VEC3_mag c]
   if {[EQ_is_zero $mag]} {return 0}
   set acoeff [expr $c(2)/$mag]
   set bcoeff [expr $c(1)/$mag]
   set ccoeff [expr $c(0)/$mag]
   if {![EQ_is_zero $acoeff]} {
      set deg 2
      set denom [expr $acoeff*2.]
      set dscrm [expr $bcoeff*$bcoeff - $acoeff*$ccoeff*4.0]
      if {[EQ_is_zero $dscrm]} {
         set dsqrt1 0.0
      } else {
         set dsqrt1 [expr sqrt(abs($dscrm))]
      }
      if {[EQ_is_ge $dscrm 0.0]} {
         set rc(0) [expr (-$bcoeff + $dsqrt1)/$denom]
         set rc(1) [expr (-$bcoeff - $dsqrt1)/$denom]
         set st 3
         return 2
      } else {
         set rc(0) [expr -$bcoeff/$denom]
         set rc(1) $rc(0)
         set ic(0) [expr $dsqrt1/$denom]
         set ic(1) $ic(0)
         set st 2
         return 0
      }
   } elseif {![EQ_is_zero $bcoeff] } {
      set st 3
      set deg 1
      set rc(0) [expr -$ccoeff/$bcoeff]
      return 1
   } elseif {[EQ_is_zero $ccoeff] } {
      return 0
   } else {
      return 0
   }
}


#=============================================================
proc STR_MATCH { VAR str {out_warn 0} } {
#=============================================================
# This command will match a variable with a given string.
#
# - Users can set the optional flag "out_warn" to "1" to produce
#   warning message when the variable is not defined in the scope
#   of the caller of this function.
#
   upvar $VAR var

   if { [info exists var] && [string match "$var" "$str"] } {
return 1
   } else {
      if { $out_warn } {
         CATCH_WARNING "Variable $VAR is not defined in \"[info level -1]\"!"
      }
return 0
   }
}


#=============================================================
proc TRACE { {up_level 0} } {
#=============================================================
# "up_level" to be a negative integer
#
   set start_idx 1

   set str ""
   set level [expr [info level] - int(abs($up_level))]

   for { set i $start_idx } { $i <= $level } { incr i } {
      if { $i < $level } {
         set str "${str}[lindex [info level $i] 0]\n"
      } else {
         set str "${str}[lindex [info level $i] 0]"
      }
   }

return $str
}


#=============================================================
proc UNSET_VARS { args } {
#=============================================================
# Inputs: List of variable names
#

   if { [llength $args] == 0 } {
return
   }

   foreach VAR $args {

      set VAR [string trim $VAR]
      if { $VAR != "" } {

         upvar $VAR var

         if { [array exists var] } {
            if { [expr $::tcl_version > 8.1] } {
               array unset var
            } else {
               foreach a [array names var] {
                  if { [info exists var($a)] } {
                     unset var($a)
                  }
               }
               unset var
            }
         }

         if { [info exists var] } {
            unset var
         }

      }
   }
}


#=============================================================
proc VMOV { n p1 p2 } {
#=============================================================
  upvar $p1 v1 ; upvar $p2 v2

   for { set i 0 } { $i < $n } { incr i } {
      set v2($i) $v1($i)
   }
}


#=============================================================
proc WORKPLANE_SET { } {
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
proc PB_CONFIG_ADVANCED_TURBO_OUTPUT { } {
#=============================================================

   PB_config_turbo_linear_move
   PB_config_turbo_circular_move
   PB_config_turbo_rapid_move

   if { [CMD_EXIST PB_CMD__AdvTurboPost__config_output] } {
      PB_CMD__AdvTurboPost__config_output
   }
}


#=============================================================
proc PB_load_alternate_unit_settings { } {
#=============================================================
   global mom_output_unit mom_kin_output_unit

  # Skip this function when output unit agrees with post unit.
   if { ![info exists mom_output_unit] } {
      set mom_output_unit $mom_kin_output_unit
return
   } elseif { ![string compare $mom_output_unit $mom_kin_output_unit] } {
return
   }


   global mom_event_handler_file_name

  # Set unit conversion factor
   if { ![string compare $mom_output_unit "MM"] } {
      set factor 25.4
   } else {
      set factor [expr 1/25.4]
   }

  # Define unit dependent variables list
   set unit_depen_var_list [list mom_kin_x_axis_limit mom_kin_y_axis_limit mom_kin_z_axis_limit \
                                 mom_kin_pivot_gauge_offset mom_kin_ind_to_dependent_head_x \
                                 mom_kin_ind_to_dependent_head_z]

   set unit_depen_arr_list [list mom_kin_4th_axis_center_offset \
                                 mom_kin_5th_axis_center_offset \
                                 mom_kin_machine_zero_offset \
                                 mom_kin_4th_axis_point \
                                 mom_kin_5th_axis_point \
                                 mom_sys_home_pos]

  # Load unit dependent variables
   foreach var $unit_depen_var_list {
      if { ![info exists $var] } {
         global $var
      }
      if { [info exists $var] } {
         set $var [expr [set $var] * $factor]
         MOM_reload_variable $var
      }
   }

   foreach var $unit_depen_arr_list {
      if { ![info exists $var] } {
         global $var
      }
      foreach item [array names $var] {
         if { [info exists ${var}($item)] } {
            set ${var}($item) [expr [set ${var}($item)] * $factor]
         }
      }

      MOM_reload_variable -a $var
   }


  # Source alternate unit post fragment
   uplevel #0 {
      global mom_sys_alt_unit_post_name
      set alter_unit_post_name \
          "[file join [file dirname $mom_event_handler_file_name] [file rootname $mom_sys_alt_unit_post_name]].tcl"

      if { [file exists $alter_unit_post_name] } {
         source "$alter_unit_post_name"
      }
      unset alter_unit_post_name
   }

   if { [llength [info commands PB_load_address_redefinition]] > 0 } {
      PB_load_address_redefinition
   }

   MOM_reload_kinematics
}


if [info exists mom_sys_start_of_program_flag] {
   if [llength [info commands PB_CMD_kin_start_of_program] ] {
      PB_CMD_kin_start_of_program
   }
} else {
   set mom_sys_head_change_init_program 1
   set mom_sys_start_of_program_flag 1
}


