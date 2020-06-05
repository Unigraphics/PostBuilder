########################## TCL Event Handlers ##########################
#
#  m4bh.tcl - 4_axis_table
#
#    
#
#  Created by Postino @ Friday, March 09 2018, 18:00:04 -0800
#  with Post Builder version 12.0.2.
#
########################################################################



#=============================================================
proc PB_CMD___log_revisions { } {
#=============================================================
# Dummy command to log changes in this post --
#
# 15-Jul-2014 gsl - Initial version
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
  set mom_sys_alt_unit_post_name                "m4bh__MM.pui"


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
  set mom_sys_feed_rate_mode_code(DPM)          "94"
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
  set mom_sys_leader(fourth_axis)               "B"
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
  set mom_sys_advanced_turbo_output             "0"
  set mom_sys_linearization_method              "angle"
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
  set mom_kin_4th_axis_leader                   "B"
  set mom_kin_4th_axis_limit_action             "Warning"
  set mom_kin_4th_axis_max_limit                "360"
  set mom_kin_4th_axis_min_incr                 "0.001"
  set mom_kin_4th_axis_min_limit                "0"
  set mom_kin_4th_axis_plane                    "ZX"
  set mom_kin_4th_axis_point(0)                 "0.0"
  set mom_kin_4th_axis_point(1)                 "0.0"
  set mom_kin_4th_axis_point(2)                 "0.0"
  set mom_kin_4th_axis_rotation                 "standard"
  set mom_kin_4th_axis_type                     "Table"
  set mom_kin_4th_axis_vector(0)                "0"
  set mom_kin_4th_axis_vector(1)                "1"
  set mom_kin_4th_axis_vector(2)                "0"
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
  set mom_kin_machine_type                      "4_axis_table"
  set mom_kin_machine_zero_offset(0)            "0.0"
  set mom_kin_machine_zero_offset(1)            "0.0"
  set mom_kin_machine_zero_offset(2)            "0.0"
  set mom_kin_max_arc_radius                    "9999.9999"
  set mom_kin_max_dpm                           "100"
  set mom_kin_max_fpm                           "600"
  set mom_kin_max_fpr                           "100"
  set mom_kin_max_frn                           "99999.999"
  set mom_kin_min_arc_length                    "0.0001"
  set mom_kin_min_arc_radius                    "0.0001"
  set mom_kin_min_dpm                           "0.0"
  set mom_kin_min_fpm                           "0.1"
  set mom_kin_min_fpr                           "0.01"
  set mom_kin_min_frn                           "0.001"
  set mom_kin_output_unit                       "IN"
  set mom_kin_pivot_gauge_offset                "0.0"
  set mom_kin_pivot_guage_offset                ""
  set mom_kin_post_data_unit                    "IN"
  set mom_kin_rapid_feed_rate                   "400"
  set mom_kin_retract_distance                  "10"
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
   if { [CMD_EXIST CONFIG_TURBO_OUTPUT] } {
      CONFIG_TURBO_OUTPUT
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
   if { [CMD_EXIST CONFIG_TURBO_OUTPUT] } {
      CONFIG_TURBO_OUTPUT
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

   MOM_do_template linear_move
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

   set rapid_spindle_blk {G_adjust G_feed G_motion G_mode X Y Z H M_coolant}
   set rapid_spindle_x_blk {G_adjust G_feed G_motion G_mode X H M_coolant}
   set rapid_spindle_y_blk {G_adjust G_feed G_motion G_mode Y H M_coolant}
   set rapid_spindle_z_blk {G_adjust G_feed G_motion G_mode Z H M_coolant}
   set rapid_traverse_blk {G_feed G_motion G_mode X Y Z fourth_axis S M_spindle}
   set rapid_traverse_xy_blk {G_feed G_motion G_mode X Y fourth_axis S M_spindle}
   set rapid_traverse_yz_blk {G_feed G_motion G_mode Y Z fourth_axis S M_spindle}
   set rapid_traverse_xz_blk {G_feed G_motion G_mode X Z fourth_axis S M_spindle}
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

   MOM_set_seq_off

   MOM_do_template rewind_stop_code
   MOM_set_seq_on

   MOM_force Once G_cutcom G_plane G_feed G_mode
   MOM_do_template absolute_mode

   if [CMD_EXIST PB_CMD_kin_start_of_program_2] {
      PB_CMD_kin_start_of_program_2
   }
}


#=============================================================
proc PB_user_defined_axis_limit_action { } {
#=============================================================
}


#=============================================================
proc PB_user_def_axis_limit_action { args } {
#=============================================================
}


#=============================================================
proc USER_DEF_AXIS_LIMIT_ACTION { args } {
#=============================================================
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
proc PB_CMD__catch_warning { } {
#=============================================================
# This command will be called by PB_catch_warning when warning
# conditions arise while running a multi-axis post.
#
# - Warning message "mom_warning_info" can be transfered to
#   "mom_sys_rotary_error" to cause ROTARY_AXIS_RETRACT to be
#   executed in MOM_before_motion, which allows the post to
#   interrupt the normal output of a multi-axis linear move.
#   Depending on the option set for handling the rotary axis'
#   limit violation, the rotary angles may be recomputed.
#
# - Certain warning situations require post to abort subsequent event or
#   the entire posting job. This can be carried out by setting the variable
#   "mom_sys_abort_next_event" to different severity levels.
#   PB_CMD_abort_event can be customized to handle the conditions accordingly.
#
#
# REVISIONS
# Oct-26-2017 gsl - Added new condition of "*ROTARY OUT OF LIMIT - Previous rotary position used*"
#

  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Define ::mom_sys_rotary_error to execute ROTARY_AXIS_RETRACT
  #
   set rotary_limit_error 0

   if { [string match "*Previous rotary axis solution degenerated*" $::mom_warning_info] } {
     # Default to "0" to avoid regression
      set rotary_limit_error 0
   }


   if { [string match "*ROTARY OUT OF LIMIT - Previous rotary position used*" $::mom_warning_info] } {
     ## Set next variable to cause current motion to be aborted.
     # - Comment out next line to ignore this condition -
      set ::mom_sys_abort_next_event 1

     ## Uncomment next line to handle this condition with retract/re-engage.
     # set ::mom_warning_info "ROTARY CROSSING LIMIT."
   }


   if { [string match "ROTARY CROSSING LIMIT." $::mom_warning_info] } {
      set rotary_limit_error 1
   }


   if { [string match "secondary rotary position being used" $::mom_warning_info] } {
      set rotary_limit_error 1
   }


   if { $rotary_limit_error } {
      UNSET_VARS ::mom_sys_abort_next_event
      set ::mom_sys_rotary_error $::mom_warning_info
return
   }


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Define ::mom_sys_abort_next_event to abort subsequent event
  #
   if { [string match "WARNING: unable to determine valid rotary positions" $::mom_warning_info] } {

     # To abort next event (in PB_CMD_abort_event)
     #
      set ::mom_sys_abort_next_event 1

     # - Whoever handles the condition MUST unset "::mom_sys_abort_next_event"!
   }
}


#=============================================================
proc PB_CMD__choose_preferred_solution { } {
#=============================================================
# ==> Do not rename this command!
#
#  This command will recompute rotary angles using the alternate solution
#  of a 5-axis motion based on the setting of "mom_preferred_zone_flag"
#  as the preferred delimiter.  The choices are:
#
#    [XPLUS | XMINUS | YPLUS | YMINUS | FOURTH | FIFTH]
#
#
#  => This command may be attached to Rapid Move or Cycle Plane Change
#     to influence the solution of the rotary axes.
#  => Initial rotary angle can be influenced by using a "Rotate" UDE.
#  => May need to recompute FRN, since length of travel may change.
#
#-------------------------------------------------------------
#<04-24-2014 gsl> Attempt to resolve PR#6738915
#<07-13-2015 gsl> Reworked logic for FOURTH & FIFTH cases
#
#return


  #----------------------------------------------------------
  # Preferred zone flag can be set via an UDE or other means.
  #
   #   EVENT preferred_solution
   #   {
   #     UI_LABEL "Preferred Solution"
   #     PARAM choose_preferred_zone
   #     {
   #        TYPE b
   #        DEFVAL "TRUE"
   #        UI_LABEL "Choose Preferred Zone"
   #     }
   #     PARAM preferred_zone_flag
   #     {
   #        TYPE o
   #        DEFVAL "YPLUS"
   #        OPTIONS "XPLUS","XMINUS","YPLUS","YMINUS","FOURTH","FIFTH"
   #        UI_LABEL "Preferred Zone"
   #     }
   #   }


   if { [info exists ::mom_preferred_zone_flag] } {

     # Only handle Rapid & Cycles for the time being,
     # user may add other cases as desired.
      if { [string compare "RAPID" $::mom_motion_type] &&\
           [string compare "CYCLE" $::mom_motion_type] } {
return
      }


      if { ![info exists ::mom_prev_out_angle_pos] } {
         array set ::mom_prev_out_angle_pos [array get ::mom_out_angle_pos]
         MOM_reload_variable -a mom_prev_out_angle_pos
return
      }


      set co "$::mom_sys_control_out"
      set ci "$::mom_sys_control_in"

      set __use_alternate 0

      switch $::mom_preferred_zone_flag {
         XPLUS  {
            if { !([EQ_is_gt $::mom_pos(0) 0.0] || [EQ_is_zero $::mom_pos(0)]) } {
               set __use_alternate 1
            }
         }
         XMINUS {
            if { !([EQ_is_le $::mom_pos(0) 0.0]) } {
               set __use_alternate 1
            }
         }
         YPLUS  {
            if { !([EQ_is_gt $::mom_pos(1) 0.0] || [EQ_is_zero $::mom_pos(1)]) } {
               set __use_alternate 1
            }
         }
         YMINUS {
            if { !([EQ_is_le $::mom_pos(1) 0.0]) } {
               set __use_alternate 1
            }
         }
         FOURTH {
            set del4 [expr abs( $::mom_out_angle_pos(0) - $::mom_prev_out_angle_pos(0) )]

            VMOV 5 ::mom_alt_pos ::mom_pos
            set out_angle_4th [ROTSET $::mom_pos(3) $::mom_prev_out_angle_pos(0) $::mom_kin_4th_axis_direction\
                                      $::mom_kin_4th_axis_leader ::mom_sys_leader(fourth_axis)\
                                      $::mom_kin_4th_axis_min_limit $::mom_kin_4th_axis_max_limit]

            set del4a [expr abs( $out_angle_4th - $::mom_prev_out_angle_pos(0) )]

            if [expr $del4 > $del4a] {
               set __use_alternate 1
            }
         }
         FIFTH  {
            set del5 [expr abs( $::mom_out_angle_pos(1) - $::mom_prev_out_angle_pos(1) )]

            VMOV 5 ::mom_alt_pos ::mom_pos
            set out_angle_5th [ROTSET $::mom_pos(4) $::mom_prev_out_angle_pos(1) $::mom_kin_5th_axis_direction\
                                      $::mom_kin_5th_axis_leader ::mom_sys_leader(fifth_axis)\
                                      $::mom_kin_5th_axis_min_limit $::mom_kin_5th_axis_max_limit]

            set del5a [expr abs( $out_angle_5th - $::mom_prev_out_angle_pos(1) )]

            if [expr $del5 > $del5a] {
               set __use_alternate 1
            }
         }
         default {
            CATCH_WARNING "$co Preferred delimiter \"$::mom_preferred_zone_flag\" is not available! $ci"
         }
      }


     # Recompute output when needed
      if { $__use_alternate } {

         set a4 $::mom_out_angle_pos(0)
         set a5 $::mom_out_angle_pos(1)

         VMOV 5 ::mom_alt_pos ::mom_pos
         set ::mom_out_angle_pos(0) [ROTSET $::mom_pos(3) $::mom_prev_out_angle_pos(0) $::mom_kin_4th_axis_direction\
                                            $::mom_kin_4th_axis_leader ::mom_sys_leader(fourth_axis)\
                                            $::mom_kin_4th_axis_min_limit $::mom_kin_4th_axis_max_limit]
         set ::mom_out_angle_pos(1) [ROTSET $::mom_pos(4) $::mom_prev_out_angle_pos(1) $::mom_kin_5th_axis_direction\
                                            $::mom_kin_5th_axis_leader ::mom_sys_leader(fifth_axis)\
                                            $::mom_kin_5th_axis_min_limit $::mom_kin_5th_axis_max_limit]

         MOM_reload_variable -a mom_out_angle_pos
         MOM_reload_variable -a mom_pos

         set msg "$co Use alternate solution : $::mom_preferred_zone_flag \
                      ($a4 / $a5) -> ($::mom_out_angle_pos(0) / $::mom_out_angle_pos(1)) $ci"

         CATCH_WARNING $msg
      }


     # Recompute output coords for cycles
      if { ![info exists ::mom_sys_cycle_after_initial] } {
         set ::mom_sys_cycle_after_initial "FALSE"
      }

      if { [string match "CYCLE" $::mom_motion_type] } {

         if { [string match "initial_move" $::mom_motion_event] } {
            set ::mom_sys_cycle_after_initial "TRUE"
return
         }

         if { [string match "TRUE" $::mom_sys_cycle_after_initial] } {
            set ::mom_pos(0) [expr $::mom_pos(0) - $::mom_cycle_rapid_to * $::mom_tool_axis(0)]
            set ::mom_pos(1) [expr $::mom_pos(1) - $::mom_cycle_rapid_to * $::mom_tool_axis(1)]
            set ::mom_pos(2) [expr $::mom_pos(2) - $::mom_cycle_rapid_to * $::mom_tool_axis(2)]
         }

         set ::mom_sys_cycle_after_initial "FALSE"

         if { [string match "Table" $::mom_kin_4th_axis_type] } {

           #<04-16-2014 gsl> "mom_spindle_axis" would have incorporated the direction of head attachment already.
            if [info exists ::mom_spindle_axis] {
               VMOV 3 ::mom_spindle_axis ::mom_sys_spindle_axis
            } else {
               VMOV 3 ::mom_kin_spindle_axis ::mom_sys_spindle_axis
            }

         } elseif { [string match "Table" $::mom_kin_5th_axis_type] } {

            VMOV 3 ::mom_tool_axis vec

            switch $::mom_kin_4th_axis_plane {
               XY {
                  set vec(2) 0.0
               }
               ZX {
                  set vec(1) 0.0
               }
               YZ {
                  set vec(0) 0.0
               }
            }

           #<04-16-2014 gsl> Reworked logic to prevent potential error
            set len [VEC3_mag vec]
            if { [EQ_is_gt $len 0.0] } {
               VEC3_unitize vec ::mom_sys_spindle_axis
            } else {
               set ::mom_sys_spindle_axis(0) 0.0
               set ::mom_sys_spindle_axis(1) 0.0
               set ::mom_sys_spindle_axis(2) 1.0
            }

         } else {

            VMOV 3 ::mom_tool_axis ::mom_sys_spindle_axis
         }

         set ::mom_cycle_feed_to_pos(0)    [expr $::mom_pos(0) + $::mom_cycle_feed_to    * $::mom_sys_spindle_axis(0)]
         set ::mom_cycle_feed_to_pos(1)    [expr $::mom_pos(1) + $::mom_cycle_feed_to    * $::mom_sys_spindle_axis(1)]
         set ::mom_cycle_feed_to_pos(2)    [expr $::mom_pos(2) + $::mom_cycle_feed_to    * $::mom_sys_spindle_axis(2)]

         set ::mom_cycle_rapid_to_pos(0)   [expr $::mom_pos(0) + $::mom_cycle_rapid_to   * $::mom_sys_spindle_axis(0)]
         set ::mom_cycle_rapid_to_pos(1)   [expr $::mom_pos(1) + $::mom_cycle_rapid_to   * $::mom_sys_spindle_axis(1)]
         set ::mom_cycle_rapid_to_pos(2)   [expr $::mom_pos(2) + $::mom_cycle_rapid_to   * $::mom_sys_spindle_axis(2)]

         set ::mom_cycle_retract_to_pos(0) [expr $::mom_pos(0) + $::mom_cycle_retract_to * $::mom_sys_spindle_axis(0)]
         set ::mom_cycle_retract_to_pos(1) [expr $::mom_pos(1) + $::mom_cycle_retract_to * $::mom_sys_spindle_axis(1)]
         set ::mom_cycle_retract_to_pos(2) [expr $::mom_pos(2) + $::mom_cycle_retract_to * $::mom_sys_spindle_axis(2)]
      }
   }
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
proc PB_CMD__validate_motion { } {
#=============================================================
# Validate legitimate motion outputs of different post configurations -
# ==> Do not rename this command!
#
# For a 4-axis Table - The spindle axis (Vs) and tool axis (Vt) should be either co-linear or (||)
#                      BOTH on the plane of rotation (Vp).
# For a 4-axis Head  - The spindle axis (Vs) should be identical to the tool axis (Vt) and (&&)
#                      must lie ON the plane of rotation (Vp).
#
# - "mom_spindle_axis" has accounted for the direction change resulted from
#   the angled-head attachment added to the spindle.
# - The max/min of the rotary axis will further constraint the reachability.
# - Vectors' DOT product will be 0 or +/-1. (Vt.Vp => 0 || +/-1)
#
# ==> This command can be enhanced to validate outputs of other post configurations.
#
#   Return: 1 = Motion OK
#           0 = Motion Bad
#-------------------------------------------------------------
# 04-29-2015 gsl - New
#

# return 1


  # "mom_spindle_axis" would include transformation of head attachment.
   if [info exists ::mom_spindle_axis] {
      VMOV 3 ::mom_spindle_axis ::mom_sys_spindle_axis
   } else {
      VMOV 3 ::mom_kin_spindle_axis ::mom_sys_spindle_axis
   }

   if { [string match "4_axis_table" $::mom_kin_machine_type] } {

      if { !( [EQ_is_equal [expr abs([VEC3_dot ::mom_sys_spindle_axis ::mom_tool_axis])] 1.0] || \
              ( [EQ_is_equal [VEC3_dot ::mom_sys_spindle_axis ::mom_kin_4th_axis_vector] 0.0] && \
                [EQ_is_equal [VEC3_dot ::mom_tool_axis        ::mom_kin_4th_axis_vector] 0.0] ) ) } {

         CATCH_WARNING "Illegal motion for 4-axis table machine"
         return 0
      }
   }

   if { [string match "4_axis_head" $::mom_kin_machine_type] } {

      if { !( [EQ_is_equal [VEC3_dot ::mom_sys_spindle_axis ::mom_tool_axis] 1.0] && \
              [EQ_is_equal [VEC3_dot ::mom_sys_spindle_axis ::mom_kin_4th_axis_vector] 0.0] ) } {

         CATCH_WARNING "Illegal motion for 4-axis head machine"
         return 0
      }
   }

   return 1
}


#=============================================================
proc PB_CMD_abort_event { } {
#=============================================================
# This command can be called to abort an event based on the
# flag being set by other handler under certain conditions,
# such as an invalid tool axis vector.
#
# Users can set the global variable mom_sys_abort_next_event to
# different severity levels throughout the post and designate
# how to handle different conditions in this command.
#
# - Rapid, linear, circular and cycle move events have this trigger
#   built in by default in PB6.0.
#
# 06-17-13 gsl - Do not abort event, by default, when signal is "1".
# 07-16-15 gsl - Added level 3 handling

   global mom_sys_abort_next_event

   if { [info exists mom_sys_abort_next_event] } {

      switch $mom_sys_abort_next_event {
         2 -
         3 {
           # User may choose to abort NX/Post
            set __abort_post 0

            if { $__abort_post } {
               set msg "NX/Post Aborted: Illegal Move ($mom_sys_abort_next_event)"

               if { [info exists ::mom_post_in_simulation] && $::mom_post_in_simulation == "MTD" } {
                 # In simulation, user will choose "Cancel" to stop the process.
                  PAUSE MOM_abort $msg
               } else {
                  MOM_abort $msg
               }
            }

           # Level 2 only aborts current event; level 3 will abort entire motion.
            if { $mom_sys_abort_next_event == 2 } {
               unset mom_sys_abort_next_event
            }

            CATCH_WARNING "Event aborted!"
            MOM_abort_event
         }
         default {
            unset mom_sys_abort_next_event
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
# This command can be called to cancel the effect of
# "MOM_force Once" & "MOM_suppress Once" for each event.
#
# => It's to keep the effect of force & suppress once within
#    the scope of the event that issues the commands and
#    eliminate the unexpected residual effect of such commands
#    that may have been issued by other events.
#
# PB v11.02 -
#
   MOM_cancel_suppress_force_once_per_event
}


#=============================================================
proc PB_CMD_clamp_fifth_axis { } {
#=============================================================
#
#  This procedure is used by auto clamping to output the code
#  needed to clamp the fifth axis.
#
#  Do NOT add this block to events or markers.  It is a static
#  block and it is not intended to be added to events.  Do NOT
#  change the name of this custom command.
#
  MOM_output_literal "M12"
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
# Fourth and Fifth Axis Auto Clamping is activated by programming the
# UDE CLAMP/AUTO,ON in your tool path.  Fourth and Fifth Axis Auto
# Clamping may be turned off by programming the UDE CLAMP/AUTO,OFF.
#
# An M10 will be output to clamp the XYZ axis for fourth axis
# motion. An M11 will be output to un-clamp the fourth axis
# when fourth axis motion occurs in the block.  You may edit
# the custom commands PB_CMD_clamp_fourth_axis or
# PB_CMD_unclamp_fourth_axis to output codes other than M10 or M11.
# The same is true for the fifth axis except you must edit the custom
# commands PB_CMD_clamp_fifth_axis or PB_CMD_unclamp_fifth_axis.  If you
# have a five axis machine tool and only want fourth or fifth axis auto
# clamping, you will need to comment out the line that outputs the unneed
# code
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
proc PB_CMD_kin__MOM_lintol { } {
#=============================================================
   global mom_kin_linearization_flag
   global mom_kin_linearization_tol
   global mom_lintol_status
   global mom_lintol

   if { ![string compare "ON" $mom_lintol_status] } {
      set mom_kin_linearization_flag "TRUE"
      if { [info exists mom_lintol] } {
         set mom_kin_linearization_tol $mom_lintol
      }
   } elseif { ![string compare "OFF" $mom_lintol_status] } {
      set mom_kin_linearization_flag "FALSE"
   }
}


#=============================================================
proc PB_CMD_kin__MOM_rotate { } {
#=============================================================
# This command handles a Rotate UDE.
#
# Key parameters set in UDE -
#   mom_rotate_axis_type        :  [ AAXIS | BAXIS   | CAXIS    | HEAD | TABLE | FOURTH_AXIS | FIFTH_AXIS ]
#   mom_rotation_mode           :  [ NONE  | ATANGLE | ABSOLUTE | INCREMENTAL ]
#   mom_rotation_direction      :  [ NONE  | CLW     | CCLW ]
#   mom_rotation_angle          :  Specified angle
#   mom_rotation_reference_mode :  [ ON    | OFF ]
#
#
## <rws 04-11-2008>
## If in TURN mode and user invokes "Flip tool around Holder" a MOM_rotate event is generated
## When this happens ABORT this event via return
##
## 09-12-2013 gsl - Made code & functionality of MOM_rotate sharable among all multi-axis posts.
##

   global mom_machine_mode


   if { [info exists mom_machine_mode] && [string match "TURN" $mom_machine_mode] } {
      if { [CMD_EXIST PB_CMD_handle_lathe_flash_tool] } {
         PB_CMD_handle_lathe_flash_tool
      }
return
   }


   global mom_rotate_axis_type mom_rotation_mode mom_rotation_direction
   global mom_rotation_angle mom_rotation_reference_mode
   global mom_kin_machine_type mom_kin_4th_axis_direction mom_kin_5th_axis_direction
   global mom_kin_4th_axis_leader mom_kin_5th_axis_leader
   global mom_kin_4th_axis_leader mom_kin_5th_axis_leader mom_pos
   global mom_out_angle_pos
   global unlocked_prev_pos mom_sys_leader
   global mom_kin_4th_axis_min_limit mom_kin_4th_axis_max_limit
   global mom_kin_5th_axis_min_limit mom_kin_5th_axis_max_limit
   global mom_prev_pos
   global mom_prev_rot_ang_4th mom_prev_rot_ang_5th


   if { ![info exists mom_rotation_angle] } {
     # Should the event be aborted here???
return
   }


   if { ![info exists mom_kin_5th_axis_direction] } {
      set mom_kin_5th_axis_direction "0"
   }


  #
  #  Determine which rotary axis the UDE has specifid - fourth(3), fifth(4) or invalid(0)
  #
  #
   if { [string match "*3_axis_mill_turn*" $mom_kin_machine_type] } {

      switch $mom_rotate_axis_type {
         CAXIS -
         FOURTH_AXIS -
         TABLE {
            set axis 3
         }
         default {
            set axis 0
         }
      }

   } else {

      switch $mom_rotate_axis_type {
         AAXIS -
         BAXIS -
         CAXIS {
            set axis [AXIS_SET $mom_rotate_axis_type]
         }
         HEAD {
            if { ![string compare "5_axis_head_table" $mom_kin_machine_type] ||\
                 ![string compare "5_AXIS_HEAD_TABLE" $mom_kin_machine_type] } {
               set axis 4
            } else {
               set axis 3
            }
         }
         FIFTH_AXIS {
            set axis 4
         }
         FOURTH_AXIS -
         TABLE -
         default {
            set axis 3
         }
      }
   }

   if { $axis == 0 } {
      CATCH_WARNING "Invalid rotary axis ($mom_rotate_axis_type) has been specified."
      MOM_abort_event
   }

   switch $mom_rotation_mode {
      NONE -
      ATANGLE {
         set angle $mom_rotation_angle
         set mode 0
      }
      ABSOLUTE {
         set angle $mom_rotation_angle
         set mode 1
      }
      INCREMENTAL {
         set angle [expr $mom_pos($axis) + $mom_rotation_angle]
         set mode 0
      }
   }

   switch $mom_rotation_direction {
      NONE {
         set dir 0
      }
      CLW {
         set dir 1
      }
      CCLW {
         set dir -1
      }
   }

   set ang [LIMIT_ANGLE $angle]
   set mom_pos($axis) $ang

   if { $axis == "3" } { ;# Rotate 4th axis

      if { ![info exists mom_prev_rot_ang_4th] } {
         set mom_prev_rot_ang_4th [MOM_ask_address_value fourth_axis]
      }
      if { [string length [string trim $mom_prev_rot_ang_4th]] == 0 } {
         set mom_prev_rot_ang_4th 0.0
      }

      set prev_angles(0) $mom_prev_rot_ang_4th

   } elseif { $axis == "4" } { ;# Rotate 5th axis

      if { ![info exists mom_prev_rot_ang_5th] } {
         set mom_prev_rot_ang_5th [MOM_ask_address_value fifth_axis]
      }
      if { [string length [string trim $mom_prev_rot_ang_5th]] == 0 } {
         set mom_prev_rot_ang_5th 0.0
      }

      set prev_angles(1) $mom_prev_rot_ang_5th
   }

   set p [expr $axis + 1]
   set a [expr $axis - 3]

   if { $axis == 3  &&  [string match "MAGNITUDE_DETERMINES_DIRECTION" $mom_kin_4th_axis_direction] } {

      set dirtype "MAGNITUDE_DETERMINES_DIRECTION"

      global mom_sys_4th_axis_dir_mode

      if { [info exists mom_sys_4th_axis_dir_mode] && ![string compare "ON" $mom_sys_4th_axis_dir_mode] } {

         set del $dir
         if { $del == 0 } {
            set del [expr $ang - $mom_prev_pos(3)]
            if { $del >  180.0 } { set del [expr $del - 360.0] }
            if { $del < -180.0 } { set del [expr $del + 360.0] }
         }

         global mom_sys_4th_axis_cur_dir
         global mom_sys_4th_axis_clw_code mom_sys_4th_axis_cclw_code

         if { $del > 0.0 } {
            set mom_sys_4th_axis_cur_dir $mom_sys_4th_axis_clw_code
         } elseif { $del < 0.0 } {
            set mom_sys_4th_axis_cur_dir $mom_sys_4th_axis_cclw_code
         }
      }

   } elseif { $axis == 4  &&  [string match "MAGNITUDE_DETERMINES_DIRECTION" $mom_kin_5th_axis_direction] } {

      set dirtype "MAGNITUDE_DETERMINES_DIRECTION"

      global mom_sys_5th_axis_dir_mode

      if { [info exists mom_sys_5th_axis_dir_mode] && ![string compare "ON" $mom_sys_5th_axis_dir_mode] } {

         set del $dir
         if { $del == 0 } {
            set del [expr $ang - $mom_prev_pos(4)]
            if { $del >  180.0 } { set del [expr $del - 360.0] }
            if { $del < -180.0 } { set del [expr $del + 360.0] }
         }

         global mom_sys_5th_axis_cur_dir
         global mom_sys_5th_axis_clw_code mom_sys_5th_axis_cclw_code

         if { $del > 0.0 } {
            set mom_sys_5th_axis_cur_dir $mom_sys_5th_axis_clw_code
         } elseif { $del < 0.0 } {
            set mom_sys_5th_axis_cur_dir $mom_sys_5th_axis_cclw_code
         }
      }

   } else {

      set dirtype "SIGN_DETERMINES_DIRECTION"
   }

   if { $mode == 1 } {

      set mom_out_angle_pos($a) $angle

   } elseif { [string match "MAGNITUDE_DETERMINES_DIRECTION" $dirtype] } {

      if { $axis == 3 } {
         set mom_out_angle_pos($a) [ROTSET $ang $prev_angles(0) $mom_kin_4th_axis_direction\
                                                $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)\
                                                $mom_kin_4th_axis_min_limit $mom_kin_4th_axis_max_limit]
      } else {
         set mom_out_angle_pos($a) [ROTSET $ang $prev_angles(1) $mom_kin_5th_axis_direction\
                                                $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)\
                                                $mom_kin_5th_axis_min_limit $mom_kin_5th_axis_max_limit]
      }

   } elseif { [string match "SIGN_DETERMINES_DIRECTION" $dirtype] } {

      if { $dir == -1 } {
         if { $axis == 3 } {
            set mom_sys_leader(fourth_axis) $mom_kin_4th_axis_leader-
         } else {
            set mom_sys_leader(fifth_axis) $mom_kin_5th_axis_leader-
         }
      } elseif { $dir == 0 } {
         if { $axis == 3 } {
            set mom_out_angle_pos($a) [ROTSET $ang $prev_angles(0) $mom_kin_4th_axis_direction\
                                                   $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)\
                                                   $mom_kin_4th_axis_min_limit $mom_kin_4th_axis_max_limit]
         } else {
            set mom_out_angle_pos($a) [ROTSET $ang $prev_angles(1) $mom_kin_5th_axis_direction\
                                                   $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)\
                                                   $mom_kin_5th_axis_min_limit $mom_kin_5th_axis_max_limit]
         }
      } elseif { $dir == 1 } {
         set mom_out_angle_pos($a) $ang
      }
   }


  #<04-25-2013 gsl> No clamp code output when rotation is ref only.
   if { ![string compare "OFF" $mom_rotation_reference_mode] } {
      global mom_sys_auto_clamp

      if { [info exists mom_sys_auto_clamp] && [string match "ON" $mom_sys_auto_clamp] } {

         set out1 "1"
         set out2 "0"

         if { $axis == 3 } { ;# Rotate 4th axis
            AUTO_CLAMP_2 $out1
            AUTO_CLAMP_1 $out2
         } else {
            AUTO_CLAMP_1 $out1
            AUTO_CLAMP_2 $out2
         }
      }
   }


   if { $axis == 3 } {

      ####  <rws>
      ####  Use ROTREF switch ON to not output the actual 4th axis move

      if { ![string compare "OFF" $mom_rotation_reference_mode] } {
         PB_CMD_fourth_axis_rotate_move
      }

      if { ![string compare "SIGN_DETERMINES_DIRECTION" $mom_kin_4th_axis_direction] } {
         set mom_prev_rot_ang_4th [expr abs($mom_out_angle_pos(0))]
      } else {
         set mom_prev_rot_ang_4th $mom_out_angle_pos(0)
      }

      MOM_reload_variable mom_prev_rot_ang_4th

   } else {

      if { [info exists mom_kin_5th_axis_direction] } {

         ####  <rws>
         ####  Use ROTREF switch ON to not output the actual 5th axis move

         if { ![string compare "OFF" $mom_rotation_reference_mode] } {
            PB_CMD_fifth_axis_rotate_move
         }

         if { ![string compare "SIGN_DETERMINES_DIRECTION" $mom_kin_5th_axis_direction] } {
            set mom_prev_rot_ang_5th [expr abs($mom_out_angle_pos(1))]
         } else {
            set mom_prev_rot_ang_5th $mom_out_angle_pos(1)
         }

         MOM_reload_variable mom_prev_rot_ang_5th
      }
   }

  #<05-10-06 sws> pb351 - Uncommented next 3 lines
  #<01-07-10 wbh> Reset mom_prev_pos using the variable mom_out_angle_pos
  # set mom_prev_pos($axis) $ang
   set mom_prev_pos($axis) $mom_out_angle_pos([expr $axis-3])
   MOM_reload_variable -a mom_prev_pos
   MOM_reload_variable -a mom_out_angle_pos
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
#  This custom command is used by UG Post to support Set/Lock,
#  rotary axis limit violation retracts and auto clamping.
#
#  --> Do not change this command!  If you want to improve
#      performance, you may comment out any of these commands.
#
#-------------------------------------------------------------
# Sep-30-2016 gsl - Allow motions to be validated against 3-axis mill post
#

   global mom_kin_machine_type

   if { [info exists mom_kin_machine_type] && [string match "*lathe*" $mom_kin_machine_type] } {
return
   }



  # Validate legitimate motion
   if { ![VALIDATE_MOTION] } {

     # PB_CMD_abort_event should be revised to handle the new abort level.
     # To abort the motion completely, it should not unset mom_sys_abort_next_event immediately.

      set ::mom_sys_abort_next_event 3
      return
   }



   if { [info exists mom_kin_machine_type] && [string match "*3_axis_mill*" $mom_kin_machine_type] } {
return
   }



  # Lock on and not circular move
   global mom_sys_lock_status  ;# Set in MOM_lock_axis
   global mom_current_motion
   if { [info exists mom_sys_lock_status] && ![string compare "ON" $mom_sys_lock_status] } {
      if { [info exists mom_current_motion] && [string compare "circular_move" $mom_current_motion] } {

         LOCK_AXIS_MOTION
      }
   }


  # Handle rotary over travel for linear moves (mom_sys_rotary_error set in PB_CMD__catch_warning)
   global mom_sys_rotary_error mom_motion_event
   if { [info exists mom_sys_rotary_error] } {
      if { $mom_sys_rotary_error != 0 && \
           [info exists mom_motion_event] && ![string compare "linear_move" $mom_motion_event] } {

         ROTARY_AXIS_RETRACT
      }

     # Error state s/b reset every time to avoid residual effect!
      UNSET_VARS mom_sys_rotary_error
   }


  # Auto clamp on
   global mom_sys_auto_clamp
   if { [info exists mom_sys_auto_clamp] && ![string compare "ON" $mom_sys_auto_clamp] } {

      AUTO_CLAMP
   }
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
proc PB_CMD_kin_catch_warning { } {
#=============================================================
# Called by PB_catch_warning
#
# - String with "mom_warning_info" (come from event generator or handlers)
#   may be output by MOM_catch_warning to the message file.
#
# - "mom_warning_info" will be transfered to "mom_sys_rotary_error" for
#   PB_CMD_kin_before_motion to handle the error condition.
#

  global mom_sys_rotary_error mom_warning_info

   if { [string match "ROTARY CROSSING LIMIT." $mom_warning_info] } {
      set mom_sys_rotary_error $mom_warning_info
   }

   if { [string match "secondary rotary position being used" $mom_warning_info] } {
      set mom_sys_rotary_error $mom_warning_info
   }

   if { [string match "WARNING: unable to determine valid rotary positions" $mom_warning_info] } {

     # To abort the current event
     # - Whoever handles this condition MUST unset it to avoid any lingering effect!
     #
      global mom_sys_abort_next_event
      set mom_sys_abort_next_event 1
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
proc PB_CMD_kin_init_rotary { } {
#=============================================================
# Following commands are defined (via uplevel) here:
#
#    MOM_clamp
#    MOM_rotate
#    MOM_lock_axis
#    PB_catch_warning
#    MOM_lintol
#

   global mom_kin_machine_type

   if { [info exists mom_kin_machine_type] } {
      if { [string match "*3_axis_mill*" $mom_kin_machine_type] ||\
           [string match "*lathe*" $mom_kin_machine_type] } {
return
      }
   }


   if { [llength [info commands PB_CMD_init_rotary] ] } {
      PB_CMD_init_rotary
   }


#***********
uplevel #0 {


#=============================================================
proc MOM_clamp { } {
#=============================================================
  global mom_clamp_axis mom_clamp_status mom_sys_auto_clamp

   if { ![string compare "AUTO" $mom_clamp_axis] } {

      if { ![string compare "ON" $mom_clamp_status] } {
         set mom_sys_auto_clamp "ON"
      } elseif { ![string compare "OFF" $mom_clamp_status] } {
         set mom_sys_auto_clamp "OFF"
      }
   } else {
      CATCH_WARNING "$mom_clamp_axis not handled in current implementation!"
   }
}


#=============================================================
proc MOM_rotate { } {
#=============================================================
# This command handles a Rotate UDE.
#
# Key parameters set in UDE -
#   mom_rotate_axis_type        :  [ AAXIS | BAXIS   | CAXIS    | HEAD | TABLE | FOURTH_AXIS | FIFTH_AXIS ]
#   mom_rotation_mode           :  [ NONE  | ATANGLE | ABSOLUTE | INCREMENTAL ]
#   mom_rotation_direction      :  [ NONE  | CLW     | CCLW ]
#   mom_rotation_angle          :  Specified angle
#   mom_rotation_reference_mode :  [ ON    | OFF ]
#
   PB_CMD_kin__MOM_rotate
}


#=============================================================
proc MOM_lock_axis { } {
#=============================================================
# This command handles a Lock Axis UDE.
#
# Key parameters set in UDE -
#   mom_lock_axis               :  [ XAXIS | YAXIS | ZAXIS | AAXIS | BAXIS | CAXIS | FOURTH | FIFTH | OFF ]
#   mom_lock_axis_plane         :  [ XYPLANE | YZPLANE | ZXPLANE | NONE ]
#   mom_lock_axis_value         :  Angle or coordinate value in Absolute Coordinates System
#   mom_lock_axis_value_defined :  [ 0 | 1 ]
#
# 18-Sep-2015 ljt - Reset positive_radius when lock-axis is OFF

  global mom_sys_lock_value mom_sys_lock_plane
  global mom_sys_lock_axis mom_sys_lock_status

 # Check if the rotary axis is the locked axis, it must be the 4th axis for a 4-axis machine,
 # or the 5th axis for a 5-axis machine. Otherwise, an error will be returned, or lock-axis will be turned off.
 #
 # It determines the locked axis  (axis: 0=X, 1=Y, 2=Z, 3=4th, 4=5th),
 #                   locked plane (plane: 0=YZ, 1=ZX, 2=XY), and
 #                   locked value (value: angle or coordinate that can be carried out)
 #
   set status [SET_LOCK axis plane value] ;# ON/OFF/error

   # Handle "error" condition returned from SET_LOCK
   # - Message in mom_warning_info
   if { ![string compare "error" $status] } {
      global mom_warning_info
      CATCH_WARNING $mom_warning_info

      set mom_sys_lock_status OFF
   } else {
      set mom_sys_lock_status $status
      if { ![string compare "ON" $status] } {
         set mom_sys_lock_axis $axis
         set mom_sys_lock_plane $plane
         set mom_sys_lock_value $value

         LOCK_AXIS_INITIALIZE
      } else {
         global positive_radius
         set positive_radius "0"
      }
   }
}


#=============================================================
proc PB_catch_warning { } {
#=============================================================
# This command will be called by MOM_catch_warning (ugpost_base.tcl)
# while running a multi-axis post when warning condition/message
# has been issued by the event generator of NX/Post processor.
#
   PB_CMD__catch_warning
}


#=============================================================
proc MOM_lintol { } {
#=============================================================
   PB_CMD_kin__MOM_lintol
}


} ;# uplevel
#***********

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
proc PB_CMD_reposition_move { } {
#=============================================================
#
#  This procedure is used by rotary axis retract to reposition the
#  rotary axes after the tool has been fully retracted.
#
#  You can modify the this procedure to customize the reposition move.
#  If you need a custom command to be output with this block,
#  you must place a call a the custom command either before or after
#  the MOM_do_template command.
#
   MOM_suppress once X Y Z
   MOM_do_template rapid_traverse
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
proc PB_CMD_retract_move { } {
#=============================================================
#
#  This procedure is used by rotary axis retract to move away from
#  the part.  This move is a three axis move along the tool axis at
#  a retract feedrate.
#
#  You can modify the this procedure to customize the retract move.
#  If you need a custom command to be output with this block,
#  you must place a call to the custom command either before or after
#  the MOM_do_template command.
#
#  If you need to modify the x,y or z locations you will need to do the
#  following.  (without the #)
#
#  global mom_pos
#  set mom_pos(0) 1.0
#  set mom_pos(1) 2.0
#  set mom_pos(2) 3.0

   MOM_do_template linear_move
}


#=============================================================
proc PB_CMD_reverse_rotation_vector { } {
#=============================================================
# This command fixes the vectors of rotary axes.
# It will be executed automatically when present in the post.
#
# --> Do not attach this command to any event marker!
#

   global mom_kin_iks_usage
   global mom_csys_matrix

   set reverse_vector 0

   if { [info exists mom_kin_iks_usage] && $mom_kin_iks_usage == 1 } {
      if { [info exists mom_csys_matrix] } {
         if { [llength [info commands MOM_validate_machine_model] ] } {
            if { ![string compare "TRUE" [MOM_validate_machine_model]] } {
               set reverse_vector 1
            }
         }
      }
   }

   if $reverse_vector {

     global mom_kin_4th_axis_vector mom_kin_5th_axis_vector
     global mom_kin_4th_axis_rotation mom_kin_5th_axis_rotation

      foreach axis { 4th_axis 5th_axis } {

         if { [info exists mom_kin_${axis}_rotation] &&\
              [string match "reverse" [set mom_kin_${axis}_rotation]] } {

            if { [info exists mom_kin_${axis}_vector] } {
               foreach i { 0 1 2 } {
                  set mom_kin_${axis}_vector($i) [expr -1 * [set mom_kin_${axis}_vector($i)]]
               }
            }
         }
      }

      MOM_reload_kinematics
   }
}


#=============================================================
proc PB_CMD_revert_dual_head_kin_vars { } {
#=============================================================
# Only dual-head 5-axis mill posts will be affected by this
# command.
#
# This command reverts kinematic parameters for dual-head 5-axis
# mill posts to maintain compatibility and to allow the posts
# to run in UG/Post prior to NX3.
#
# Attributes of the 4th & 5th Addresses, their locations in
# the Master Word Sequence and all the Blocks that use these
# Addresses will be reconditioned with call to
#
#     PB_swap_dual_head_elements
#
#-------------------------------------------------------------
# 04-15-05 gsl - Added for PB v3.4
#-------------------------------------------------------------

  global mom_kin_machine_type


  if ![string match  "5_axis_dual_head"  $mom_kin_machine_type] {
return
  }


  set var_list { ang_offset center_offset(0) center_offset(1) center_offset(2) direction incr_switch leader limit_action max_limit min_incr min_limit plane rotation zero }

  foreach var $var_list {
    # Global declaration
    if [string match "center_offset*" $var] {
      global mom_kin_4th_axis_center_offset mom_kin_5th_axis_center_offset
    } else {
      global mom_kin_4th_axis_[set var] mom_kin_5th_axis_[set var]
    }

    # Swap values
    set kin_var mom_kin_4th_axis_[set var]
    set val [set mom_kin_4th_axis_[set var]]
    set mom_kin_4th_axis_[set var] [set mom_kin_5th_axis_[set var]]
    set mom_kin_5th_axis_[set var] $val
  }

  # Update kinematic parameters
  MOM_reload_kinematics


  # Swap address leaders
  global mom_sys_leader

  set val $mom_sys_leader(fourth_axis)
  set mom_sys_leader(fourth_axis) $mom_sys_leader(fifth_axis)
  set mom_sys_leader(fifth_axis)  $val

  # Swap elements in definition file
  if [llength [info commands PB_swap_dual_head_elements] ] {
     PB_swap_dual_head_elements
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
# to process the same objects being posted with a secondary post.
#
# ==> It's advisable NOT to use the active post and the same
#     output file for this secondary posting process.
# ==> Ensure legitimate and fully qualified post processor and
#     output file are specified with the command.
#

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# CAUTION - Uncomment next line to activate this function!
return
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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
proc PB_CMD_unclamp_fifth_axis { } {
#=============================================================
#
#  This procedure is used by auto clamping to output the code
#  needed to unclamp the fifth axis.
#
#  Do NOT add this block to events or markers.  It is a static
#  block and it is not intended to be added to events.  Do NOT
#  change the name of this custom command.
#
  MOM_output_literal "M13"
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
proc ACCOUNT_HEAD_OFFSETS { POS flag } {
#=============================================================
# Command to account for the offsets of angled-head attachment.
# There'll be no effect, if head attachment is not in use or
# offsets are zeros.
#
# - Called by LOCK_AXIS & UNLOCK_AXIS
#
# Inputs:
#
#   POS  : Array name (reference) of a position
#   flag : Type of operation
#           1 = Add offsets
#           0 = Remove offsets
#
# Outputs:
#   Updated POS
#
#<04-16-2014 gsl> Inception
#

   upvar $POS pos

   global mom_kin_machine_type
   global mom_head_gauge_point

   if { [info exists mom_head_gauge_point] } {
      set len [VEC3_mag mom_head_gauge_point]

      if [EQ_is_gt $len 0.0] {
         switch $flag {
            1 {
              # Adding offsets
               VEC3_add pos mom_head_gauge_point pos
            }

            0 -
            default {
              # Subtract offsets
               VEC3_sub pos mom_head_gauge_point pos
            }
         }
      }
   }
}


#=============================================================
proc ANGLE_CHECK { a axis } {
#=============================================================
# called by ROTARY_AXIS_RETRACT
#
#   Return:
#     1: Within limits
#    -1: Out of limits
#     0: Special condition (0 ~ 360 & MAGNITUDE_DETERMINES_DIRECTION)
#

   upvar $a ang

   global mom_kin_4th_axis_max_limit
   global mom_kin_5th_axis_max_limit
   global mom_kin_4th_axis_min_limit
   global mom_kin_5th_axis_min_limit
   global mom_kin_4th_axis_direction
   global mom_kin_5th_axis_direction

   if { $axis == 4 } {
      set min $mom_kin_4th_axis_min_limit
      set max $mom_kin_4th_axis_max_limit
      set dir $mom_kin_4th_axis_direction
   } else {
      set min $mom_kin_5th_axis_min_limit
      set max $mom_kin_5th_axis_max_limit
      set dir $mom_kin_5th_axis_direction
   }

   if { [EQ_is_equal $min 0.0] && [EQ_is_equal $max 360.0] &&\
       ![string compare "MAGNITUDE_DETERMINES_DIRECTION" $dir] } {

      return 0

   } else {

      while { $ang > $max && $ang > [expr $min + 360.0] } { set ang [expr $ang - 360.0] }
      while { $ang < $min && $ang < [expr $max - 360.0] } { set ang [expr $ang + 360.0] }

      if { $ang > $max || $ang < $min } {

         return -1

      } else {

         return 1
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
#  This command is used to automatically output clamp and unclamp
#  codes.  This command must be called in the the command
#  << PB_CMD_kin_before_motion >>.  By default this command will
#  output M10 or M11 to do clamping or unclamping for the 4th axis or
#  M12 or M13 for the 5th axis.
#

  # Must be called by PB_CMD_kin_before_motion
   if { ![CALLED_BY "PB_CMD_kin_before_motion"] } {
return
   }


   global mom_pos
   global mom_prev_pos

   global mom_sys_auto_clamp

   if { ![info exists mom_sys_auto_clamp] || ![string match "ON" $mom_sys_auto_clamp] } {
return
   }

   set rotary_out [EQ_is_equal $mom_pos(3) $mom_prev_pos(3)]

   AUTO_CLAMP_1 $rotary_out

   set rotary_out [EQ_is_equal $mom_pos(4) $mom_prev_pos(4)]

   AUTO_CLAMP_2 $rotary_out
}


#=============================================================
proc AUTO_CLAMP_1 { out } {
#=============================================================
# called by AUTO_CLAMP & MOM_rotate

   global clamp_rotary_fourth_status

   if { ![info exists clamp_rotary_fourth_status] ||\
       ( $out == 0 && ![string match "UNCLAMPED" $clamp_rotary_fourth_status] ) } {

      PB_CMD_unclamp_fourth_axis
      set clamp_rotary_fourth_status "UNCLAMPED"

   } elseif { $out == 1 && ![string match "CLAMPED" $clamp_rotary_fourth_status] } {

      PB_CMD_clamp_fourth_axis
      set clamp_rotary_fourth_status "CLAMPED"
   }
}


#=============================================================
proc AUTO_CLAMP_2 { out } {
#=============================================================
# called by AUTO_CLAMP & MOM_rotate

   global mom_kin_machine_type

   set machine_type [string tolower $mom_kin_machine_type]
   switch $machine_type {
      5_axis_dual_table -
      5_axis_dual_head  -
      5_axis_head_table { }

      default           {
return
      }
   }

   global clamp_rotary_fifth_status

   if { ![info exists clamp_rotary_fifth_status] ||\
        ( $out == 0 && ![string match "UNCLAMPED" $clamp_rotary_fifth_status] ) } {

      PB_CMD_unclamp_fifth_axis
      set clamp_rotary_fifth_status "UNCLAMPED"

   } elseif { $out == 1 && ![string match "CLAMPED" $clamp_rotary_fifth_status] } {

      PB_CMD_clamp_fifth_axis
      set clamp_rotary_fifth_status "CLAMPED"
   }
}


#=============================================================
proc AXIS_SET { axis } {
#=============================================================
# Called by MOM_rotate & SET_LOCK to detect if the given axis is the 4th or 5th rotary axis.
# It returns 0, if no match has been found.
#

  global mom_sys_leader

   if { ![string compare "[string index $mom_sys_leader(fourth_axis) 0]AXIS" $axis] } {
      return 3
   } elseif { ![string compare "[string index $mom_sys_leader(fifth_axis) 0]AXIS" $axis] } {
      return 4
   } else {
      return 0
   }
}


#=============================================================
proc CALC_CYLINDRICAL_RETRACT_POINT { refpt axis dist ret_pt } {
#=============================================================
# called by ROTARY_AXIS_RETRACT

  upvar $refpt rfp ; upvar $axis ax ; upvar $ret_pt rtp

#
# Return 0: parallel or lies on plane
#        1: unique intersection
#


#
# Create plane canonical form
#
   VMOV 3 ax plane
   set plane(3) $dist

   set num [expr $plane(3) - [VEC3_dot rfp plane]]
   set dir [VEC3_dot ax plane]

   if { [EQ_is_zero $dir] } {
return 0
   }

   for { set i 0 } { $i < 3 } { incr i } {
      set rtp($i) [expr $rfp($i) + $ax($i)*$num/$dir]
   }

return [RETRACT_POINT_CHECK rfp ax rtp]
}


#=============================================================
proc CALC_SPHERICAL_RETRACT_POINT { refpt axis cen_sphere rad_sphere int_pts } {
#=============================================================
# called by ROTARY_AXIS_RETRACT

  upvar $refpt rp ; upvar $axis ta ; upvar $cen_sphere cs
  upvar $int_pts ip

   set rad [expr $rad_sphere*$rad_sphere]
   VEC3_sub rp cs v1

   set coeff(2) 1.0
   set coeff(1) [expr ($v1(0)*$ta(0) + $v1(1)*$ta(1) + $v1(2)*$ta(2))*2.0]
   set coeff(0) [expr $v1(0)*$v1(0) + $v1(1)*$v1(1) + $v1(2)*$v1(2) - $rad]

   set num_sol [SOLVE_QUADRATIC coeff roots iroots status degree]
   if { $num_sol == 0 } { return 0 }

   if { [expr $roots(0)] > [expr $roots(1)] || $num_sol == 1 } {
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
proc CHECK_LOCK_ROTARY_AXIS { axis mtype } {
#=============================================================
# called by SET_LOCK

   global mom_sys_leader

   set is_valid 0
   set lock_axis_leader ""

   if { $mtype == 4 } {
      # For 4-axis machine, the locked rotary axis must be the fourth axis.
      if { [string match "FIFTH" $axis] } {
         return $is_valid
      }

      set lock_axis_leader [string index $mom_sys_leader(fourth_axis) 0]

   } elseif { $mtype == 5 } {
      # For 5-axis machine, the locked rotary axis must be the fifth axis.
      if { [string match "FOURTH" $axis] } {
         return $is_valid
      }

      set lock_axis_leader [string index $mom_sys_leader(fifth_axis) 0]

   } else {

      return $is_valid
   }

   # Handle the case when axis is "AAXIS", "BAXIS" or "CAXIS"
   set cur_axis_leader [string index $axis 0]
   switch $cur_axis_leader {
      A -
      B -
      C {
         if { [string match $lock_axis_leader $cur_axis_leader] } {
            # The specified rotary axis is valid
            set is_valid 1
         }
      }
      default {
         set is_valid 1
      }
   }

   return $is_valid
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
proc GET_SPINDLE_AXIS { input_tool_axis } {
#=============================================================
# called by ROTARY_AXIS_RETRACT

   upvar $input_tool_axis axis

   global mom_kin_4th_axis_type
   global mom_kin_4th_axis_plane
   global mom_kin_5th_axis_type
   global mom_kin_spindle_axis
   global mom_sys_spindle_axis

   if { ![string compare "Table" $mom_kin_4th_axis_type] } {
      VMOV 3 mom_kin_spindle_axis mom_sys_spindle_axis
   } elseif { ![string compare "Table" $mom_kin_5th_axis_type] } {
      VMOV 3 axis vec
      if { ![string compare "XY" $mom_kin_4th_axis_plane] } {
         set vec(2) 0.0
      } elseif { ![string compare "ZX" $mom_kin_4th_axis_plane] } {
         set vec(1) 0.0
      } elseif { ![string compare "YZ" $mom_kin_4th_axis_plane] } {
         set vec(0) 0.0
      }
      set len [VEC3_unitize vec mom_sys_spindle_axis]
      if { [EQ_is_zero $len] } { set mom_sys_spindle_axis(2) 1.0 }
   } else {
      VMOV 3 axis mom_sys_spindle_axis
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
proc LINEARIZE_LOCK_MOTION { } {
#=============================================================
# called by LOCK_AXIS_MOTION
#
#  This command linearizes the move between two positions that
#  have both linear and rotary motion.  The rotary motion is
#  created by LOCK_AXIS from the coordinates in the locked plane.
#  The combined linear and rotary moves result in non-linear
#  motion.  This command will break the move into shorter moves
#  that do not violate the tolerance.
#
#<04-08-2014 gsl> - Corrected error with use of mom_outangle_pos.
#<12-03-2014 gsl> - Declaration of global unlocked_pos & unlocked_prev_pos were commented out in pb903.
#<09-09-2015 ljt> - Ensure mom_prev_pos is locked, and raise warning
#                   when linearization iteration does not complete.
# Sep-11-2017 gsl - 7698782 Undo revision of <09-09-2015 ljt>. Ref revision in LOCK_AXIS_MOTION.

   global mom_pos
   global mom_prev_pos
   global unlocked_pos
   global unlocked_prev_pos
   global mom_kin_linearization_tol
   global mom_kin_machine_resolution
   global mom_out_angle_pos

   VMOV 5 mom_pos locked_pos

   # <09-Sep-2015 ljt> Make sure mom_prev_pos is locked. If mom_pos has been reloaded and
   #                   when MOM_POST_convert_point is called in core result can be wrong.
   #<Sep-11-2017 gsl> 7698782
    VMOV 5 mom_prev_pos locked_prev_pos
   # LOCK_AXIS mom_prev_pos locked_prev_pos ::mom_prev_out_angle_pos

   UNLOCK_AXIS locked_pos unlocked_pos
   UNLOCK_AXIS locked_prev_pos unlocked_prev_pos

   VMOV 5 unlocked_pos save_unlocked_pos
   VMOV 5 locked_pos save_locked_pos

   set loop 0
   set count 0

   set tol $mom_kin_linearization_tol

   while { $loop == 0 } {

      for { set i 3 } { $i < 5 } { incr i } {
         set del [expr $locked_pos($i) - $locked_prev_pos($i)]
         if { $del > 180.0 } {
            set locked_prev_pos($i) [expr $locked_prev_pos($i) + 360.0]
         } elseif { $del < -180.0 } {
            set locked_prev_pos($i) [expr $locked_prev_pos($i) - 360.0]
         }
      }

      set loop 1

      for { set i 0 } { $i < 5 } { incr i } {
         set mid_unlocked_pos($i) [expr ( $unlocked_pos($i) + $unlocked_prev_pos($i) )/2.0]
         set mid_locked_pos($i) [expr ( $locked_pos($i) + $locked_prev_pos($i) )/2.0]
      }

      UNLOCK_AXIS mid_locked_pos temp

      VEC3_sub temp mid_unlocked_pos work

      set error [VEC3_mag work]

      if { $count > 20 } {

         VMOV 5 locked_pos mom_pos
         VMOV 5 unlocked_pos mom_prev_pos

         CATCH_WARNING "LINEARIZATION ITERATION FAILED."

         LINEARIZE_LOCK_OUTPUT $count

      } elseif { $error < $tol } {

         VMOV 5 locked_pos mom_pos
         VMOV 5 unlocked_pos mom_prev_pos

         CATCH_WARNING "LINEARIZATION ITERATION FAILED."

         LINEARIZE_LOCK_OUTPUT $count

         VMOV 5 unlocked_pos unlocked_prev_pos
         VMOV 5 locked_pos locked_prev_pos

         if { $count != 0 } {
            VMOV 5 save_unlocked_pos unlocked_pos
            VMOV 5 save_locked_pos locked_pos
            set loop 0
            set count 0
         }

      } else {

         if { $error < $mom_kin_machine_resolution } {
            set error $mom_kin_machine_resolution
         }

         set error [expr sqrt( $tol*.98/$error )]

         if { $error < .5 } { set error .5 }

         for { set i 0 } { $i < 5 } { incr i } {
            set locked_pos($i)   [expr $locked_prev_pos($i)   + ( $locked_pos($i)   - $locked_prev_pos($i)   )*$error]
            set unlocked_pos($i) [expr $unlocked_prev_pos($i) + ( $unlocked_pos($i) - $unlocked_prev_pos($i) )*$error]
         }

        #<04-08-2014 gsl> mom_out_angle_pos was mom_outangle_pos.
         LOCK_AXIS unlocked_pos locked_pos mom_out_angle_pos

         set loop 0
         incr count
      }
   }

#<04-08-2014 gsl> Didn't make difference
#   MOM_reload_variable -a mom_pos
#   MOM_reload_variable -a mom_prev_pos
#   MOM_reload_variable -a mom_out_angle_pos
}


#=============================================================
proc LINEARIZE_LOCK_OUTPUT { count } {
#=============================================================
# called by LOCK_AXIS_MOTION & LINEARIZE_LOCK_MOTION
# "count > 0" will cause output.
#
# Jul-16-2013     - pb1003
# Oct-15-2015 ljt - PR6789060, account for reversed rotation, reload mom_prev_rot_ang_4/5th
#
   global mom_out_angle_pos
   global mom_pos
   global mom_prev_rot_ang_4th
   global mom_prev_rot_ang_5th
   global mom_kin_4th_axis_direction
   global mom_kin_5th_axis_direction
   global mom_kin_4th_axis_leader
   global mom_kin_5th_axis_leader
   global mom_sys_leader
   global mom_prev_pos
   global mom_mcs_goto
   global mom_prev_mcs_goto
   global mom_motion_distance
   global mom_feed_rate_number
   global mom_feed_rate
   global mom_kin_machine_resolution
   global mom_kin_max_frn
   global mom_kin_machine_type
   global mom_kin_4th_axis_min_limit mom_kin_4th_axis_max_limit
   global mom_kin_5th_axis_min_limit mom_kin_5th_axis_max_limit
   global mom_out_angle_pos
   global unlocked_pos unlocked_prev_pos



   set mom_out_angle_pos(0)  [ROTSET $mom_pos(3) $mom_prev_rot_ang_4th $mom_kin_4th_axis_direction\
                                     $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)\
                                     $mom_kin_4th_axis_min_limit $mom_kin_4th_axis_max_limit]

  # Make sure previous angles are correct which will be used in next ROTSET.
   set mom_prev_rot_ang_4th $mom_out_angle_pos(0)
   MOM_reload_variable mom_prev_rot_ang_4th

   if { [string match "5_axis_*table" $mom_kin_machine_type] } {

      # Account for reversed rotation, mom_kin_5th_axis_vector is always the positive direction of x/y/z,
      # only fifth axis can be locked for five axis post, and the tool axis is parallel to mom_kin_5th_axis_vector
      # if the tool axis leads to the negative direction, the angle need to be reversed.
      if { [string match "MAGNITUDE_DETERMINES_DIRECTION" $mom_kin_5th_axis_direction]\
           && [VEC3_dot ::mom_tool_axis ::mom_kin_5th_axis_vector] < 0 } {

         set mom_pos(4) [expr -1 * $mom_pos(4)]
      }

      set mom_out_angle_pos(1)  [ROTSET $mom_pos(4) $mom_prev_rot_ang_5th $mom_kin_5th_axis_direction\
                                        $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)\
                                        $mom_kin_5th_axis_min_limit $mom_kin_5th_axis_max_limit]

      set mom_prev_rot_ang_5th $mom_out_angle_pos(1)
      MOM_reload_variable mom_prev_rot_ang_5th
   }

#
#  Re-calcualte the distance and feed rate number
#
   if { $count < 0 } {
      VEC3_sub mom_mcs_goto mom_prev_mcs_goto delta
   } else {
      VEC3_sub unlocked_pos unlocked_prev_pos delta
   }

   set mom_motion_distance [VEC3_mag delta]

   if { [EQ_is_lt $mom_motion_distance $mom_kin_machine_resolution] } {
      set mom_feed_rate_number $mom_kin_max_frn
   } else {
      set mom_feed_rate_number [expr $mom_feed_rate / $mom_motion_distance]
   }

   set mom_pos(3) $mom_out_angle_pos(0)

  # Is it only needed for a 5-axis?
   set mom_pos(4) $mom_out_angle_pos(1)


   FEEDRATE_SET

   if { $count > 0 } { PB_CMD_linear_move }
}


#=============================================================
proc LOCK_AXIS { input_point output_point output_rotary } {
#=============================================================
# called by LOCK_AXIS_MOTION & LINEARIZE_LOCK_MOTION
#
# (pb903)
# 09-06-13 Allen - PR6932644 - implement lock axis for 4 axis machine.
# 04-16-14 gsl   - Account for offsets resulted from right-angled head attachment
# 09-09-15 ljt   - Replace mom_kin_4/5th_axis_center_offset with mom_kin_4/5th_axis_point
# 10-15-15 ljt   - PR6789060, account for reversed rotation of table not perpendicular to spindle axis.

   upvar $input_point in_pos ; upvar $output_point out_pos ; upvar $output_rotary or

   global mom_kin_4th_axis_center_offset
   global mom_kin_5th_axis_center_offset
   global mom_sys_lock_value
   global mom_sys_lock_plane
   global mom_sys_lock_axis
   global mom_sys_unlocked_axis
   global mom_sys_4th_axis_index
   global mom_sys_5th_axis_index
   global mom_sys_linear_axis_index_1
   global mom_sys_linear_axis_index_2
   global mom_sys_rotary_axis_index
   global mom_kin_machine_resolution
   global mom_prev_lock_angle
   global mom_out_angle_pos
   global mom_prev_rot_ang_4th
   global mom_prev_rot_ang_5th
   global positive_radius
   global DEG2RAD
   global RAD2DEG
   global mom_kin_4th_axis_rotation
   global mom_kin_5th_axis_rotation
   global mom_kin_machine_type
   global mom_kin_4th_axis_point
   global mom_kin_5th_axis_point
   global mom_origin


   if { ![info exists positive_radius] } { set positive_radius 0 }

   if { $mom_sys_rotary_axis_index == 3 } {
      if { ![info exists mom_prev_rot_ang_4th] } { set mom_prev_rot_ang_4th 0.0 }
      set mom_prev_lock_angle $mom_prev_rot_ang_4th
   } else {
      if { ![info exists mom_prev_rot_ang_5th] } { set mom_prev_rot_ang_5th 0.0 }
      set mom_prev_lock_angle $mom_prev_rot_ang_5th
   }

  #<04-16-2014 gsl> Add offsets of angled-head attachment to input point
   VMOV 5 in_pos ip
   ACCOUNT_HEAD_OFFSETS ip 1


   # <09-Sep-2015 ljt> Add offsets of 4/5th axis rotary center
   VMOV 3 ip temp
   if { [CMD_EXIST MOM_validate_machine_model] \
        && [string match "TRUE" [MOM_validate_machine_model]] } {

      if { [string match "5_axis_*table" $mom_kin_machine_type] && [info exists mom_kin_5th_axis_point] } {

         VEC3_sub temp mom_kin_5th_axis_point temp

      } elseif { ( [string match "4_axis_table" $mom_kin_machine_type] || [string match "*mill_turn" $mom_kin_machine_type] ) \
                 && [info exists mom_kin_4th_axis_point] } {

         VEC3_sub temp mom_kin_4th_axis_point temp
      }

   } else {

      # mom_origin is a vector from table center to destination MCS
      if { [info exists mom_origin] } {
         VEC3_add temp mom_origin temp
      }

      if { [info exists mom_kin_4th_axis_center_offset] } {
         VEC3_sub temp mom_kin_4th_axis_center_offset temp
      }

      if { [info exists mom_kin_5th_axis_center_offset ] } {
         VEC3_sub temp mom_kin_5th_axis_center_offset temp
      }
   }

   set temp(3) $ip(3)
   set temp(4) $ip(4)

   if { $mom_sys_lock_axis > 2 } {

      set angle [expr ($mom_sys_lock_value - $temp($mom_sys_lock_axis))*$DEG2RAD]
      ROTATE_VECTOR $mom_sys_lock_plane $angle temp temp1
      VMOV 3 temp1 temp
      set temp($mom_sys_lock_axis) $mom_sys_lock_value

   } else {

      # <15-Oct-15 ljt> lock plane is 5th axis plane for 5axis machine
      if { [string match "5_axis_*table" $mom_kin_machine_type] } {
         set angle [expr ($temp(4))*$DEG2RAD]

         # <03-11-10 wbh> 6308668 Check the rotation mode
         if [string match "reverse" $mom_kin_5th_axis_rotation] {
            set angle [expr -$angle]
         }

         ROTATE_VECTOR $mom_sys_5th_axis_index $angle temp temp1
         VMOV 3 temp1 temp
         set temp(4) 0.0
      }


      #<09-06-13 Allen> Fix PR6932644 to implement lock axis for 4 axis machine.
      #<11-15-2013 gsl> ==> Rotation seemed to be reversed!
      if { [string match "4_axis_*" $mom_kin_machine_type] } {
         if { ![string compare $mom_sys_lock_plane $mom_sys_4th_axis_index] } {
            set angle [expr $temp(3)*$DEG2RAD]
            if [string match "reverse" $mom_kin_4th_axis_rotation] {
               set angle [expr -$angle]
            }

            ROTATE_VECTOR $mom_sys_4th_axis_index $angle temp temp1

            VMOV 3 temp1 temp
            set temp(3) 0.0
         }
      }


      set rad [expr sqrt($temp($mom_sys_linear_axis_index_1)*$temp($mom_sys_linear_axis_index_1) +\
                         $temp($mom_sys_linear_axis_index_2)*$temp($mom_sys_linear_axis_index_2))]

      set angle [ARCTAN $temp($mom_sys_linear_axis_index_2) $temp($mom_sys_linear_axis_index_1)]

      # <03-11-10 wbh> 6308668 Check the rotation mode
      # <15-Oct-15 ljt> lock plane is 5th axis plane for 5axis machine
      if { [string match "5_axis_*table" $mom_kin_machine_type] } {
         if [string match "reverse" $mom_kin_5th_axis_rotation] {
            set angle [expr -$angle]
         }
      } elseif { ![string compare $mom_sys_lock_plane $mom_sys_4th_axis_index] } {
         if [string match "reverse" $mom_kin_4th_axis_rotation] {
            set angle [expr -$angle]
         }
      }

      if { $rad < [expr abs($mom_sys_lock_value) + $mom_kin_machine_resolution] } {
         if { $mom_sys_lock_value < 0.0 } {
            set temp($mom_sys_lock_axis) [expr -$rad]
         } else {
            set temp($mom_sys_lock_axis) $rad
         }
      } else {
         set temp($mom_sys_lock_axis) $mom_sys_lock_value
      }

      set temp($mom_sys_unlocked_axis)  [expr sqrt($rad*$rad - $temp($mom_sys_lock_axis)*$temp($mom_sys_lock_axis))]

      VMOV 5 temp temp1
      set temp1($mom_sys_unlocked_axis) [expr -$temp($mom_sys_unlocked_axis)]
      set ang1 [ARCTAN $temp($mom_sys_linear_axis_index_2)  $temp($mom_sys_linear_axis_index_1)]
      set ang2 [ARCTAN $temp1($mom_sys_linear_axis_index_2) $temp1($mom_sys_linear_axis_index_1)]
      set temp($mom_sys_rotary_axis_index)  [expr ($angle - $ang1)*$RAD2DEG]
      set temp1($mom_sys_rotary_axis_index) [expr ($angle - $ang2)*$RAD2DEG]
      set ang1 [LIMIT_ANGLE [expr $mom_prev_lock_angle - $temp($mom_sys_rotary_axis_index)]]
      set ang2 [LIMIT_ANGLE [expr $mom_prev_lock_angle - $temp1($mom_sys_rotary_axis_index)]]

      if { $ang1 > 180.0 } { set ang1 [LIMIT_ANGLE [expr -$ang1]] }
      if { $ang2 > 180.0 } { set ang2 [LIMIT_ANGLE [expr -$ang2]] }

      if { $positive_radius == 0 } {
         if { $ang1 > $ang2 } {
            VMOV 5 temp1 temp
            set positive_radius "-1"
         } else {
            set positive_radius "1"
         }
      } elseif { $positive_radius == -1 } {
         VMOV 5 temp1 temp
      }

     #+++++++++++++++++++++++++++++++++++++++++
     # NOT needed!!! <= will cause misbehavior
     # VMOV 5 temp1 temp
   }


   # <09-Sep-2015 ljt> Remove offsets of the 4/5th axis rotary center
   VMOV 3 temp op
   if { [CMD_EXIST MOM_validate_machine_model] \
        && [string match "TRUE" [MOM_validate_machine_model]] } {

      if { [string match "5_axis_*table" $mom_kin_machine_type] && [info exists mom_kin_5th_axis_point] } {

         VEC3_add op mom_kin_5th_axis_point op

      } elseif { ( [string match "4_axis_table" $mom_kin_machine_type] || [string match "*mill_turn" $mom_kin_machine_type] ) \
                 && [info exists mom_kin_4th_axis_point] } {

         VEC3_add op mom_kin_4th_axis_point op
      }

   } else {

      if { [info exists mom_origin] } {
         VEC3_sub op mom_origin op
      }

      if { [info exists mom_kin_4th_axis_center_offset] } {
         VEC3_add op mom_kin_4th_axis_center_offset op
      }

      if { [info exists mom_kin_5th_axis_center_offset] } {
         VEC3_add op mom_kin_5th_axis_center_offset op
      }

   }

   if { ![info exists or] } {
      set or(0) 0.0
      set or(1) 0.0
   }

   set mom_prev_lock_angle $temp($mom_sys_rotary_axis_index)
   set op(3) $temp(3)
   set op(4) $temp(4)


  #<04-16-2014 gsl> Remove offsets of angled-head attachment from output point
   ACCOUNT_HEAD_OFFSETS op 0
   VMOV 5 op out_pos
}


#=============================================================
proc LOCK_AXIS_INITIALIZE { } {
#=============================================================
# called by MOM_lock_axis
# ==> It's only used by MOM_lock_axis, perhaps it should be defined within.

   global mom_sys_lock_plane
   global mom_sys_lock_axis
   global mom_sys_unlocked_axis
   global mom_sys_unlock_plane
   global mom_sys_4th_axis_index
   global mom_sys_5th_axis_index
   global mom_sys_linear_axis_index_1
   global mom_sys_linear_axis_index_2
   global mom_sys_rotary_axis_index
   global mom_kin_4th_axis_plane
   global mom_kin_5th_axis_plane
   global mom_kin_machine_type

   if { $mom_sys_lock_plane == -1 } {
      if { ![string compare "XY" $mom_kin_4th_axis_plane] } {
         set mom_sys_lock_plane 2
      } elseif { ![string compare "ZX" $mom_kin_4th_axis_plane] } {
         set mom_sys_lock_plane 1
      } elseif { ![string compare "YZ" $mom_kin_4th_axis_plane] } {
         set mom_sys_lock_plane 0
      }
   }

   set mom_sys_4th_axis_index -1
   if { ![string compare "XY" $mom_kin_4th_axis_plane] } {
      set mom_sys_4th_axis_index 2
   } elseif { ![string compare "ZX" $mom_kin_4th_axis_plane] } {
      set mom_sys_4th_axis_index 1
   } elseif { ![string compare "YZ" $mom_kin_4th_axis_plane] } {
      set mom_sys_4th_axis_index 0
   }


  # Check whether the machine type is 5-axis.
   set mom_sys_5th_axis_index -1
   if { [string match "5_axis_*" $mom_kin_machine_type] && [info exists mom_kin_5th_axis_plane] } {
      if { ![string compare "XY" $mom_kin_5th_axis_plane] } {
         set mom_sys_5th_axis_index 2
      } elseif { ![string compare "ZX" $mom_kin_5th_axis_plane] } {
         set mom_sys_5th_axis_index 1
      } elseif { ![string compare "YZ" $mom_kin_5th_axis_plane] } {
         set mom_sys_5th_axis_index 0
      }
   }


   if { $mom_sys_lock_plane == 0 } {
      set mom_sys_linear_axis_index_1 1
      set mom_sys_linear_axis_index_2 2
   } elseif { $mom_sys_lock_plane == 1 } {
      set mom_sys_linear_axis_index_1 2
      set mom_sys_linear_axis_index_2 0
   } elseif { $mom_sys_lock_plane == 2 } {
      set mom_sys_linear_axis_index_1 0
      set mom_sys_linear_axis_index_2 1
   }

   # Can only lock the last rotary axis
   if { $mom_sys_5th_axis_index == -1 } {
      set mom_sys_rotary_axis_index 3
   } else {
      set mom_sys_rotary_axis_index 4
   }

   set mom_sys_unlocked_axis [expr $mom_sys_linear_axis_index_1 +\
                                   $mom_sys_linear_axis_index_2 -\
                                   $mom_sys_lock_axis]


#MOM_output_text "( >>> mom_sys_lock_plane          : $mom_sys_lock_plane )"
#MOM_output_text "( >>> mom_sys_lock_axis           : $mom_sys_lock_axis )"
#MOM_output_text "( >>> mom_sys_unlocked_axis       : $mom_sys_unlocked_axis )"
#MOM_output_text "( >>> mom_sys_4th_axis_index      : $mom_sys_4th_axis_index )"
#MOM_output_text "( >>> mom_sys_5th_axis_index      : $mom_sys_5th_axis_index )"
#MOM_output_text "( >>> mom_sys_linear_axis_index_1 : $mom_sys_linear_axis_index_1 )"
#MOM_output_text "( >>> mom_sys_linear_axis_index_2 : $mom_sys_linear_axis_index_2 )"
#MOM_output_text "( >>> mom_sys_rotary_axis_index   : $mom_sys_rotary_axis_index )"
#MOM_output_text "( >>> mom_kin_4th_axis_plane      : $mom_kin_4th_axis_plane )"
#MOM_output_text "( >>> mom_kin_5th_axis_plane      : $mom_kin_5th_axis_plane )"
#MOM_output_text "( >>> mom_kin_machine_type        : $mom_kin_machine_type )"
}


#=============================================================
proc LOCK_AXIS_MOTION { } {
#=============================================================
# called by PB_CMD_kin_before_motion
#
#  The UDE lock_axis must be specified in the tool path
#  for the post to lock the requested axis.  The UDE lock_axis may only
#  be used for four and five axis machine tools.  A four axis post may
#  only lock an axis in the plane of the fourth axis.  For five axis
#  posts, only the fifth axis may be locked.  Five axis will only
#  output correctly if the fifth axis is rotated so it is perpendicular
#  to the spindle axis.
#
# Mar-29-2016     - Of NX/PB v11.0
# Sep-11-2017 gsl - 7698782 Also recompute mom_prev_pos with LOCK_AXIS

  # Must be called by PB_CMD_kin_before_motion
   if { ![CALLED_BY "PB_CMD_kin_before_motion"] } {
return
   }


   if { [string match "circular_move" $::mom_current_motion] } {
return
   }



   global mom_sys_lock_status

   if { [string match "ON" $mom_sys_lock_status] } {

      global mom_pos mom_out_angle_pos
      global mom_motion_type
      global mom_cycle_feed_to_pos
      global mom_cycle_feed_to mom_tool_axis
      global mom_motion_event
      global mom_cycle_rapid_to_pos
      global mom_cycle_retract_to_pos
      global mom_cycle_rapid_to
      global mom_cycle_retract_to
      global mom_prev_pos
      global mom_kin_4th_axis_type
      global mom_kin_spindle_axis
      global mom_kin_5th_axis_type
      global mom_kin_4th_axis_plane
      global mom_sys_cycle_after_initial
      global mom_kin_4th_axis_min_limit
      global mom_kin_4th_axis_max_limit
      global mom_kin_5th_axis_min_limit
      global mom_kin_5th_axis_max_limit
      global mom_prev_rot_ang_4th
      global mom_prev_rot_ang_5th
      global mom_kin_4th_axis_direction
      global mom_kin_5th_axis_direction
      global mom_kin_4th_axis_leader
      global mom_kin_5th_axis_leader
      global mom_kin_machine_type


      if { ![info exists mom_sys_cycle_after_initial] } {
         set mom_sys_cycle_after_initial "FALSE"
      }

      if { [string match "FALSE" $mom_sys_cycle_after_initial] } {
         LOCK_AXIS mom_pos mom_pos mom_out_angle_pos

        #<Sep-11-2017 gsl> 7698782 Also recompute mom_prev_pos
         LOCK_AXIS mom_prev_pos mom_prev_pos ::mom_prev_out_angle_pos
      }

      if { [string match "CYCLE" $mom_motion_type] } {

         if { [string match "Table" $mom_kin_4th_axis_type] } {

           # "mom_spindle_axis" would have the head attachment incorporated.
            global mom_spindle_axis
            if [info exists mom_spindle_axis] {
               VMOV 3 mom_spindle_axis mom_sys_spindle_axis
            } else {
               VMOV 3 mom_kin_spindle_axis mom_sys_spindle_axis
            }

         } elseif { [string match "Table" $mom_kin_5th_axis_type] } {

            VMOV 3 mom_tool_axis vec

           # Zero component of rotating axis
            switch $mom_kin_4th_axis_plane {
               XY {
                  set vec(2) 0.0
               }
               ZX {
                  set vec(1) 0.0
               }
               YZ {
                  set vec(0) 0.0
               }
            }

           # Reworked logic to prevent potential error
            set len [VEC3_mag vec]
            if { [EQ_is_gt $len 0.0] } {
               VEC3_unitize vec mom_sys_spindle_axis
            } else {
               set mom_sys_spindle_axis(0) 0.0
               set mom_sys_spindle_axis(1) 0.0
               set mom_sys_spindle_axis(2) 1.0
            }

         } else {

            VMOV 3 mom_tool_axis mom_sys_spindle_axis
         }

         set mom_cycle_feed_to_pos(0)    [expr $mom_pos(0) + $mom_cycle_feed_to    * $mom_sys_spindle_axis(0)]
         set mom_cycle_feed_to_pos(1)    [expr $mom_pos(1) + $mom_cycle_feed_to    * $mom_sys_spindle_axis(1)]
         set mom_cycle_feed_to_pos(2)    [expr $mom_pos(2) + $mom_cycle_feed_to    * $mom_sys_spindle_axis(2)]

         set mom_cycle_rapid_to_pos(0)   [expr $mom_pos(0) + $mom_cycle_rapid_to   * $mom_sys_spindle_axis(0)]
         set mom_cycle_rapid_to_pos(1)   [expr $mom_pos(1) + $mom_cycle_rapid_to   * $mom_sys_spindle_axis(1)]
         set mom_cycle_rapid_to_pos(2)   [expr $mom_pos(2) + $mom_cycle_rapid_to   * $mom_sys_spindle_axis(2)]

         set mom_cycle_retract_to_pos(0) [expr $mom_pos(0) + $mom_cycle_retract_to * $mom_sys_spindle_axis(0)]
         set mom_cycle_retract_to_pos(1) [expr $mom_pos(1) + $mom_cycle_retract_to * $mom_sys_spindle_axis(1)]
         set mom_cycle_retract_to_pos(2) [expr $mom_pos(2) + $mom_cycle_retract_to * $mom_sys_spindle_axis(2)]
      }


      global mom_kin_linearization_flag

      if { ![string compare "TRUE"       $mom_kin_linearization_flag] &&\
            [string compare "RAPID"      $mom_motion_type]            &&\
            [string compare "CYCLE"      $mom_motion_type]            &&\
            [string compare "rapid_move" $mom_motion_event] } {

         LINEARIZE_LOCK_MOTION

      } else {

         if { ![info exists mom_prev_rot_ang_4th] } { set mom_prev_rot_ang_4th 0.0 }
         if { ![info exists mom_prev_rot_ang_5th] } { set mom_prev_rot_ang_5th 0.0 }

         LINEARIZE_LOCK_OUTPUT -1
      }


     #VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
     # > Do not reload mom_pos here!
     # MOM_reload_variable -a mom_pos

   } ;# mom_sys_lock_status
}


#=============================================================
proc LOCK_AXIS_SUB { axis } {
#=============================================================
# called by SET_LOCK

  global mom_pos mom_lock_axis_value_defined mom_lock_axis_value

   if { $mom_lock_axis_value_defined == 1 } {
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
proc PREFERRED_SOLUTION { } {
#=============================================================
# To be called by PB_CMD_kin_before_motion
# ==> Perhaps, after the 4-axis output validation!
# ==> Not yet released officially
#
#  UDE "Set Preferred Solution" can be specified with the operation in question.
#  This event will be handled before "Lock Axis" to choose, possibly,
#  the alternate solution of a 5-axis motion based on the perferred
#  delimiter (mom_preferred_zone_flag) such as X/Y-plus(or minus) or
#  4th/5th-angle etc. Choices can be
#
#    [XPLUS | XMINUS | YPLUS | YMINUS | FOURTH | FIFTH].
#
#
#  => Should this flag be in effect forever until cancelled by
#     another instance of the same UDE that turns it off?
#  => Initial rotary angle can be influenced by using a "Rotate" UDE.
#
#
   if [CMD_EXIST PB_CMD__choose_preferred_solution] {
      PB_CMD__choose_preferred_solution
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

  if [EQ_is_equal [expr $rot(0)+$rot(1)] [expr $rotalt(0)+$rotalt(1)]] {return}
  set mom_sys_rotary_error $warn
}


#=============================================================
proc RESET_ROTARY_SIGN { ang pre_ang axis } {
#=============================================================
# Called by ROTARY_AXIS_RETRACT
#
# The input parameters "ang" & "pre_ang" must use same unit. (Both in degree or radian)

   global mom_kin_4th_axis_direction mom_kin_5th_axis_direction
   global mom_kin_4th_axis_rotation mom_kin_5th_axis_rotation
   global mom_rotary_direction_4th mom_rotary_direction_5th

   set abs_ang [expr abs($ang)]
   set abs_pre [expr abs($pre_ang)]
   if { $axis == 3 && ![string compare "SIGN_DETERMINES_DIRECTION" $mom_kin_4th_axis_direction] } {
    # The fourth axis.
      if { $abs_ang > $abs_pre } {
         set mom_rotary_direction_4th 1
      } elseif { $abs_ang < $abs_pre } {
         set mom_rotary_direction_4th -1
      }
   } elseif { $axis == 4 && ![string compare "SIGN_DETERMINES_DIRECTION" $mom_kin_5th_axis_direction] } {
    # The fifth axis.
      if { $abs_ang > $abs_pre } {
         set mom_rotary_direction_5th 1
      } elseif { $abs_ang < $abs_pre } {
         set mom_rotary_direction_5th -1
      }
   }
}


#=============================================================
proc RETRACT_POINT_CHECK { refpt axis retpt } {
#=============================================================
# called by CALC_SPHERICAL_RETRACT_POINT & CALC_CYLINDRICAL_RETRACT_POINT

  upvar $refpt rfp ; upvar $axis ax ; upvar $retpt rtp

#
#  determine if retraction point is "below" the retraction plane
#  if the tool is already in a safe position, do not retract
#
#  return 0    no retract needed
#         1     retraction needed
#

   VEC3_sub rtp rfp vec
   if { [VEC3_is_zero vec] } {
return 0
   }

   set x [VEC3_unitize vec vec1]
   set dir [VEC3_dot ax vec1]

   if { $dir <= 0.0 } {
return 0
   } else {
return 1
   }
}


#=============================================================
proc ROTARY_AXIS_RETRACT { } {
#=============================================================
# called by PB_CMD_kin_before_motion
#
#  This command is used by four and five axis posts to retract
#  from workpiece when the rotary axis become discontinuous.
#  This command is activated by setting the axis limit violation
#  action to "retract / re-engage".
#
#-------------------------------------------------------------
# Nov-30-2016 gsl - (pb11.02) Corrected logic
# Sep-11-2017 gsl - (pb12.01) PB_user_defined_axis_limit_action was PB_user_def_axis_limit_action.
#

  #(pb903) Removed restriction below; command may be used in other situations
  # Must be called by PB_CMD_kin_before_motion
  if 0 {
   if { ![CALLED_BY "PB_CMD_kin_before_motion"] } {
 return
   }
  }

   global mom_sys_rotary_error
   global mom_motion_event


   if { ![info exists mom_sys_rotary_error] } {
return
   }

   set rotary_error_code $mom_sys_rotary_error

  # Make sure mom_sys_rotary_error is always unset.
   unset mom_sys_rotary_error


   if { [info exists mom_motion_event] } {

      if { $rotary_error_code != 0 && ![string compare "linear_move" $mom_motion_event] } {

        #<06-25-12 gsl> The above conditions have been checked in PB_CMD_kin_before_motion already.

         global mom_kin_reengage_distance
         global mom_kin_rotary_reengage_feedrate
         global mom_kin_rapid_feed_rate
         global mom_pos
         global mom_prev_pos
         global mom_prev_rot_ang_4th mom_prev_rot_ang_5th
         global mom_kin_4th_axis_direction mom_kin_4th_axis_leader
         global mom_out_angle_pos mom_kin_5th_axis_direction mom_kin_5th_axis_leader
         global mom_kin_4th_axis_center_offset mom_kin_5th_axis_center_offset
         global mom_sys_leader mom_tool_axis mom_prev_tool_axis mom_kin_4th_axis_type
         global mom_kin_spindle_axis
         global mom_alt_pos mom_prev_alt_pos mom_feed_rate
         global mom_kin_rotary_reengage_feedrate
         global mom_feed_engage_value mom_feed_cut_value
         global mom_kin_4th_axis_limit_action mom_warning_info
         global mom_kin_4th_axis_min_limit mom_kin_4th_axis_max_limit
         global mom_kin_5th_axis_min_limit mom_kin_5th_axis_max_limit

        #
        #  Check for the limit action being warning only.  If so, issue warning and leave
        #
         if { ![string compare "Warning" $mom_kin_4th_axis_limit_action] } {

            CATCH_WARNING "Rotary axis limit violated, discontinuous motion may result."

            return

         } elseif { ![string compare "User Defined" $mom_kin_4th_axis_limit_action] } {

            PB_user_defined_axis_limit_action

            return
         }

        #
        #  The previous rotary info is only available after the first motion.
        #
         if { ![info exists mom_prev_rot_ang_4th] } {
            set mom_prev_rot_ang_4th [MOM_ask_address_value fourth_axis]
         }

         if { ![info exists mom_prev_rot_ang_5th] } {
            set mom_prev_rot_ang_5th [MOM_ask_address_value fifth_axis]
         }

        #
        #  Determine the type of rotary violation encountered.  There are
        #  three distinct possibilities.
        #
        #  "ROTARY CROSSING LIMIT" with a four axis machine tool.  The fourth
        #      axis will be repositioned by either +360 or -360 before
        #      re-engaging (roterr = 0).
        #
        #  "ROTARY CROSSING LIMIT" with a five axis machine tool.  There are two
        #      possible solutions.  If the axis that crossed a limit can be
        #      repositioned by adding or subtracting 360, then that solution
        #      will be used (roterr = 0).  If there is only one position available and it is
        #      not in the valid travel limits, then the alternate position will
        #      be tested.  If valid, then the "secondary rotary position being used"
        #      method will be used (roterr = 2).
        #      If the alternate position cannot be used, a warning will be given.
        #
        #  "secondary rotary position being used" can only occur with a five
        #      axis machine tool.  The tool will reposition to the alternate
        #      current rotary position and re-engage to the alternate current
        #      linear position (roterr = 1).
        #
        #
        #    roterr = 0 :
        #      Rotary Reposition : mom_prev_pos(3,4) +- 360
        #      Linear Re-Engage :  mom_prev_pos(0,1,2)
        #      Final End Point :   mom_pos(0-4)
        #
        #    roterr = 1 :
        #      Rotary Reposition : mom_prev_alt_pos(3,4)
        #      Linear Re-Engage :  mom_prev_alt_pos(0,1,2)
        #      Final End Point :   mom_pos(0-4)
        #
        #    roterr = 2 :
        #      Rotary Reposition : mom_prev_alt_pos(3,4)
        #      Linear Re-Engage :  mom_prev_alt_pos(0,1,2)
        #      Final End Point :   mom_alt_pos(0-4)
        #
        #    For all cases, a warning will be given if it is not possible to
        #    to cut from the re-calculated previous position to move end point.
        #    For all valid cases the tool will, retract from the part, reposition
        #    the rotary axis and re-engage back to the part.
        #

         if { ![string compare "ROTARY CROSSING LIMIT." $rotary_error_code] } {

            global mom_kin_machine_type

            if { [string match "5_axis_*" [string tolower $mom_kin_machine_type]] } {

               set d [expr $mom_out_angle_pos(0) - $mom_prev_rot_ang_4th]

               if { [expr abs($d)] > 180.0 } {
                  set min $mom_kin_4th_axis_min_limit
                  set max $mom_kin_4th_axis_max_limit
                  if { $d > 0.0 } {
                     set ang [expr $mom_prev_rot_ang_4th + 360.0]
                  } else {
                     set ang [expr $mom_prev_rot_ang_4th - 360.0]
                  }
               } else {
                  set min $mom_kin_5th_axis_min_limit
                  set max $mom_kin_5th_axis_max_limit
                  set d [expr $mom_out_angle_pos(1) - $mom_prev_rot_ang_5th]
                  if { $d > 0.0 } {
                     set ang [expr $mom_prev_rot_ang_5th + 360.0]
                  } else {
                     set ang [expr $mom_prev_rot_ang_5th - 360.0]
                  }
               }

               if { $ang >= $min && $ang <= $max } { ;# ==> 5th axis min/max will be used here(?)
                  set roterr 0
               } else {
                  set roterr 2
               }
            } else {
               set roterr 0
            }

         } else {

            set roterr 1
         }

        #
        #  Retract from part
        #
         VMOV 5 mom_pos save_pos
         VMOV 5 mom_prev_pos save_prev_pos
         VMOV 2 mom_out_angle_pos save_out_angle_pos
         set save_feedrate $mom_feed_rate

         global mom_kin_output_unit mom_part_unit
         if { ![string compare $mom_kin_output_unit $mom_part_unit] } {
            set mom_sys_unit_conversion "1.0"
         } elseif { ![string compare "IN" $mom_kin_output_unit] } {
            set mom_sys_unit_conversion [expr 1.0/25.4]
         } else {
            set mom_sys_unit_conversion 25.4
         }

        #<01-07-10 wbh> Fix pr6192146.
        # Declare/Set the variables used to convert the feed rate from MMPR/IPR to MMPM/IPM.
         global mom_spindle_rpm
         global mom_feed_approach_unit mom_feed_cut_unit
         global mom_feed_engage_unit mom_feed_retract_unit

         set mode_convert_scale "1.0"
         if { [info exists mom_spindle_rpm] && [EQ_is_gt $mom_spindle_rpm 0.0] } {
            set mode_convert_scale $mom_spindle_rpm
         }

         global mom_sys_spindle_axis
         GET_SPINDLE_AXIS mom_prev_tool_axis

         global mom_kin_retract_type
         global mom_kin_retract_distance
         global mom_kin_retract_plane

         if { ![info exists mom_kin_retract_distance] } {
            if { [info exists mom_kin_retract_plane] } {
              # Convert legacy variable
               set mom_kin_retract_distance $mom_kin_retract_plane
            } else {
               set mom_kin_retract_distance 10.0
            }
         }

         if { ![info exists mom_kin_retract_type] } {
            set mom_kin_retract_type "DISTANCE"
         }

        #<Nov-30-2016 gsl> (pb1102) Enforce retract type for machines only with table(s).
         set machine_type [string tolower $::mom_kin_machine_type]
         switch $machine_type {
            4_axis_table -
            5_axis_dual_table {
               set mom_kin_retract_type "DISTANCE"
            }
         }

        #
        #  Pre-release type conversion
        #
         if { [string match "PLANE" $mom_kin_retract_type] } {
            set mom_kin_retract_type "SURFACE"
         }

         switch $mom_kin_retract_type {
            SURFACE {
               set cen(0) 0.0
               set cen(1) 0.0
               set cen(2) 0.0

               if { [info exists mom_kin_4th_axis_center_offset] } {
                  VEC3_add cen mom_kin_4th_axis_center_offset cen
               }

              #<Nov-30-2016 gsl> (pb1102) Is logic below proper?
              if 0 {
               if { ![string compare "Table" $mom_kin_4th_axis_type] } {
                  set num_sol [CALC_CYLINDRICAL_RETRACT_POINT mom_prev_pos mom_kin_spindle_axis\
                                                              $mom_kin_retract_distance ret_pt]
               } else {
                  set num_sol [CALC_SPHERICAL_RETRACT_POINT   mom_prev_pos mom_prev_tool_axis cen\
                                                              $mom_kin_retract_distance ret_pt]
               }
              }

               set machine_type [string tolower $::mom_kin_machine_type]
               switch $machine_type {
                  4_axis_head -
                  5_axis_head_table {
                     set num_sol [CALC_CYLINDRICAL_RETRACT_POINT mom_prev_pos mom_kin_spindle_axis\
                                                                 $mom_kin_retract_distance ret_pt]
                  }
                  5_axis_dual_head {
                     set num_sol [CALC_SPHERICAL_RETRACT_POINT   mom_prev_pos mom_prev_tool_axis cen\
                                                                 $mom_kin_retract_distance ret_pt]
                  }
               }

               if { $num_sol != 0 } { VEC3_add ret_pt cen mom_pos }
            }

            DISTANCE -
            default {
               set mom_pos(0) [expr $mom_prev_pos(0) + $mom_kin_retract_distance*$mom_sys_spindle_axis(0)]
               set mom_pos(1) [expr $mom_prev_pos(1) + $mom_kin_retract_distance*$mom_sys_spindle_axis(1)]
               set mom_pos(2) [expr $mom_prev_pos(2) + $mom_kin_retract_distance*$mom_sys_spindle_axis(2)]
               set num_sol 1
            }
         }


         global mom_motion_distance
         global mom_feed_rate_number
         global mom_feed_retract_value
         global mom_feed_approach_value


         set dist [expr $mom_kin_reengage_distance*2.0]

         if { $num_sol != 0 } {
        #
        #  Retract from the part at rapid feed rate.  This is the same for all conditions.
        #
            MOM_suppress once fourth_axis fifth_axis
            set mom_feed_rate [expr $mom_feed_retract_value*$mom_sys_unit_conversion]

           #<01-07-10 wbh> Convert the feed rate from MMPR/IPR to MMPM/IPM
            if { [info exists mom_feed_retract_unit] && [string match "*pr" $mom_feed_retract_unit] } {
               set mom_feed_rate [expr $mom_feed_rate * $mode_convert_scale]
            }
            if { [EQ_is_equal $mom_feed_rate 0.0] } {
               set mom_feed_rate [expr $mom_kin_rapid_feed_rate*$mom_sys_unit_conversion]
            }

            VEC3_sub mom_pos mom_prev_pos del_pos
            set dist [VEC3_mag del_pos]

           #<03-13-08 gsl> Replaced next call
           # global mom_sys_frn_factor
           # set mom_feed_rate_number [expr ($mom_sys_frn_factor*$mom_feed_rate)/ $dist]
            set mom_feed_rate_number [SET_FEEDRATE_NUMBER $dist $mom_feed_rate]
            FEEDRATE_SET
            set retract "yes"

         } else {

            CATCH_WARNING "Retraction geometry is defined inside of the current point.\n\
                           No retraction will be output. Set the retraction distance to a greater value."
            set retract "no"
         }

         if { $roterr == 0 } {
#
#  This section of code handles the case where a limit forces a reposition to an angle
#  by adding or subtracting 360 until the new angle is within the limits.
#  This is either a four axis case or a five axis case where it is not a problem
#  with the inverse kinematics forcing a change of solution.
#  This is only a case of "unwinding" the table.
#
            if { ![string compare "yes"  $retract] } {
               PB_CMD_retract_move
            }

           #
           #  Move to previous rotary position
           #  <04-01-2013 gsl> mom_rev_pos(3,4) may have not been affected, we may just borrow them
           #                   as mom_out_angle_pos for subsequent output instead of recomputing them thru ROTSET(?)
           #
            if { [info exists mom_kin_4th_axis_direction] } {
               set mom_out_angle_pos(0) [ROTSET $mom_prev_pos(3) $mom_out_angle_pos(0) $mom_kin_4th_axis_direction\
                                                $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)\
                                                $mom_kin_4th_axis_min_limit $mom_kin_4th_axis_max_limit]
            }
            if { [info exists mom_kin_5th_axis_direction] } {
               set mom_out_angle_pos(1) [ROTSET $mom_prev_pos(4) $mom_out_angle_pos(1) $mom_kin_5th_axis_direction\
                                                $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)\
                                                $mom_kin_5th_axis_min_limit $mom_kin_5th_axis_max_limit]
            }

            PB_CMD_reposition_move

           #
           #  Position back to part at approach feed rate
           #
            GET_SPINDLE_AXIS mom_prev_tool_axis
            for { set i 0 } { $i < 3 } { incr i } {
               set mom_pos($i) [expr $mom_prev_pos($i) + $mom_kin_reengage_distance * $mom_sys_spindle_axis($i)]
            }
            set mom_feed_rate [expr $mom_feed_approach_value * $mom_sys_unit_conversion]
           #<01-07-10 wbh> Convert the feed rate from MMPR/IPR to MMPM/IPM
            if { [info exists mom_feed_approach_unit] && [string match "*pr" $mom_feed_approach_unit] } {
               set mom_feed_rate [expr $mom_feed_rate * $mode_convert_scale]
            }
            if { [EQ_is_equal $mom_feed_rate 0.0] } {
               set mom_feed_rate [expr $mom_kin_rapid_feed_rate*$mom_sys_unit_conversion]
            }
            set dist [expr $dist-$mom_kin_reengage_distance]
            set mom_feed_rate_number [SET_FEEDRATE_NUMBER $dist $mom_feed_rate]
            FEEDRATE_SET
            MOM_suppress once fourth_axis fifth_axis
            PB_CMD_linear_move

           #
           #  Feed back to part at engage feed rate
           #
            MOM_suppress once fourth_axis fifth_axis
            if { $mom_feed_engage_value  > 0.0 } {
               set mom_feed_rate [expr $mom_feed_engage_value*$mom_sys_unit_conversion]
              #<01-07-10 wbh> Convert the feed rate from MMPR/IPR to MMPM/IPM
               if { [info exists mom_feed_engage_unit] && [string match "*pr" $mom_feed_engage_unit] } {
                  set mom_feed_rate [expr $mom_feed_rate * $mode_convert_scale]
               }
            } elseif { $mom_feed_cut_value  > 0.0 } {
               set mom_feed_rate [expr $mom_feed_cut_value*$mom_sys_unit_conversion]
              #<01-07-10 wbh> Convert the feed rate from MMPR/IPR to MMPM/IPM
               if { [info exists mom_feed_cut_unit] && [string match "*pr" $mom_feed_cut_unit] } {
                  set mom_feed_rate [expr $mom_feed_rate * $mode_convert_scale]
               }
            } else {
               set mom_feed_rate [expr 10.0*$mom_sys_unit_conversion]
            }

            VEC3_sub mom_pos mom_prev_pos del_pos
            set mom_feed_rate_number [SET_FEEDRATE_NUMBER $mom_kin_reengage_distance $mom_feed_rate]
            FEEDRATE_SET
            VMOV 3 mom_prev_pos mom_pos
            PB_CMD_linear_move

            VEC3_sub mom_pos save_pos del_pos
            set dist [VEC3_mag del_pos]
            set mom_feed_rate_number [SET_FEEDRATE_NUMBER $dist $mom_feed_rate]
            FEEDRATE_SET

            VMOV 5 save_pos mom_pos
            VMOV 5 save_prev_pos mom_prev_pos
            VMOV 2 save_out_angle_pos mom_out_angle_pos

         } else {
#
#  This section of code handles the case where there are two solutions to the tool axis inverse kinematics.
#  The post is forced to change from one solution to the other.  This causes a discontinuity in the tool path.
#  The post needs to retract, rotate to the new rotaries, then position back to the part using the alternate
#  solution.
#
            #
            #  Check for rotary axes in limits before retracting
            #
            set res [ANGLE_CHECK mom_prev_alt_pos(3) 4]
            if { $res == 1 } {
               set mom_out_angle_pos(0) [ROTSET $mom_prev_alt_pos(3) $mom_prev_rot_ang_4th $mom_kin_4th_axis_direction\
                                                $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)\
                                                $mom_kin_4th_axis_min_limit  $mom_kin_4th_axis_max_limit 1]
            } elseif { $res == 0 } {
               set mom_out_angle_pos(0) $mom_prev_alt_pos(3)
            } else {
               CATCH_WARNING "Not possible to position to alternate rotary axis positions. Gouging may result"
               VMOV 5 save_pos mom_pos

             return
            }

            set res [ANGLE_CHECK mom_prev_alt_pos(4) 5]
            if { $res == 1 } {
               set mom_out_angle_pos(1) [ROTSET $mom_prev_alt_pos(4) $mom_prev_rot_ang_5th $mom_kin_5th_axis_direction\
                                                $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)\
                                                $mom_kin_5th_axis_min_limit $mom_kin_5th_axis_max_limit 1]
            } elseif { $res == 0 } {
               set mom_out_angle_pos(1) $mom_prev_alt_pos(4)
            } else {
               CATCH_WARNING "Not possible to position to alternate rotary axis positions. Gouging may result"
               VMOV 5 save_pos mom_pos

             return
            }

            set mom_prev_pos(3) $mom_pos(3)
            set mom_prev_pos(4) $mom_pos(4)
            FEEDRATE_SET

            if { ![string compare "yes" $retract] } { PB_CMD_retract_move }
           #
           #  Move to alternate rotary position
           #
            set mom_pos(3) $mom_prev_alt_pos(3)
            set mom_pos(4) $mom_prev_alt_pos(4)
            set mom_prev_rot_ang_4th $mom_out_angle_pos(0)
            set mom_prev_rot_ang_5th $mom_out_angle_pos(1)
            VMOV 3 mom_prev_pos mom_pos
            FEEDRATE_SET
            PB_CMD_reposition_move

           #
           #  Position back to part at approach feed rate
           #
            set mom_prev_pos(3) $mom_pos(3)
            set mom_prev_pos(4) $mom_pos(4)
            for { set i 0 } { $i < 3 } { incr i } {
              set mom_pos($i) [expr $mom_prev_alt_pos($i)+$mom_kin_reengage_distance*$mom_sys_spindle_axis($i)]
            }
            MOM_suppress once fourth_axis fifth_axis
            set mom_feed_rate [expr $mom_feed_approach_value*$mom_sys_unit_conversion]

           #<01-07-10 wbh> Convert the feed rate from MMPR/IPR to MMPM/IPM
            if { [info exists mom_feed_approach_unit] && [string match "*pr" $mom_feed_approach_unit] } {
               set mom_feed_rate [expr $mom_feed_rate * $mode_convert_scale]
            }
            if { [EQ_is_equal $mom_feed_rate 0.0] } {
              set mom_feed_rate [expr $mom_kin_rapid_feed_rate * $mom_sys_unit_conversion]
            }
            set dist [expr $dist-$mom_kin_reengage_distance]
            set mom_feed_rate_number [SET_FEEDRATE_NUMBER $dist $mom_feed_rate]
            FEEDRATE_SET
            PB_CMD_linear_move

           #
           #  Feed back to part at engage feed rate
           #
            MOM_suppress once fourth_axis fifth_axis
            if { $mom_feed_engage_value  > 0.0 } {
               set mom_feed_rate [expr $mom_feed_engage_value*$mom_sys_unit_conversion]
              #<01-07-10 wbh> Convert the feed rate from MMPR/IPR to MMPM/IPM
               if { [info exists mom_feed_engage_unit] && [string match "*pr" $mom_feed_engage_unit] } {
                  set mom_feed_rate [expr $mom_feed_rate * $mode_convert_scale]
               }
            } elseif { $mom_feed_cut_value  > 0.0 } {
               set mom_feed_rate [expr $mom_feed_cut_value*$mom_sys_unit_conversion]
              #<01-07-10 wbh> Convert the feed rate from MMPR/IPR to MMPM/IPM
               if { [info exists mom_feed_cut_unit] && [string match "*pr" $mom_feed_cut_unit] } {
                  set mom_feed_rate [expr $mom_feed_rate * $mode_convert_scale]
               }
            } else {
              # ???
               set mom_feed_rate [expr 10.0*$mom_sys_unit_conversion]
            }

            set mom_feed_rate_number [SET_FEEDRATE_NUMBER $mom_kin_reengage_distance $mom_feed_rate]
            VMOV 3 mom_prev_alt_pos mom_pos
            FEEDRATE_SET
            PB_CMD_linear_move

            VEC3_sub mom_pos save_pos del_pos
            set dist [VEC3_mag del_pos]
            if { $dist <= 0.0 } { set dist $mom_kin_reengage_distance }
            set mom_feed_rate_number [SET_FEEDRATE_NUMBER $dist $mom_feed_rate]
            FEEDRATE_SET

            if { $roterr == 2 } {
               VMOV 5 mom_alt_pos mom_pos
            } else {
               VMOV 5 save_pos mom_pos
            }

           #<01-07-10 wbh> Reset the rotary sign
            RESET_ROTARY_SIGN $mom_pos(3) $mom_out_angle_pos(0) 3
            RESET_ROTARY_SIGN $mom_pos(4) $mom_out_angle_pos(1) 4

            set mom_out_angle_pos(0) [ROTSET $mom_pos(3) $mom_out_angle_pos(0) $mom_kin_4th_axis_direction\
                                             $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)\
                                             $mom_kin_4th_axis_min_limit $mom_kin_4th_axis_max_limit]
            set mom_out_angle_pos(1) [ROTSET $mom_pos(4) $mom_out_angle_pos(1) $mom_kin_5th_axis_direction\
                                             $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)\
                                             $mom_kin_5th_axis_min_limit $mom_kin_5th_axis_max_limit]

            MOM_reload_variable -a mom_out_angle_pos
            MOM_reload_variable -a mom_pos
            MOM_reload_variable -a mom_prev_pos
         }

         set mom_feed_rate $save_feedrate
         FEEDRATE_SET
      }
   }
}


#=============================================================
proc ROTATE_VECTOR { plane angle input_vector output_vector } {
#=============================================================
# Called by LOCK_AXIS & UNLOCK_AXIS

  upvar $output_vector v ; upvar $input_vector v1

   switch $plane {
      0 {
         set v(0) $v1(0)
         set v(1) [expr $v1(1)*cos($angle) - $v1(2)*sin($angle)]
         set v(2) [expr $v1(2)*cos($angle) + $v1(1)*sin($angle)]
      }

      1 {
         set v(0) [expr $v1(0)*cos($angle) + $v1(2)*sin($angle)]
         set v(1) $v1(1)
         set v(2) [expr $v1(2)*cos($angle) - $v1(0)*sin($angle)]
      }

      default {
         set v(0) [expr $v1(0)*cos($angle) - $v1(1)*sin($angle)]
         set v(1) [expr $v1(1)*cos($angle) + $v1(0)*sin($angle)]
         set v(2) $v1(2)
      }
   }
}


#=============================================================
proc ROTSET { angle prev_angle dir kin_leader sys_leader min max {tol_flag 0} } {
#=============================================================
#  This command will take an input angle and format for a specific machine.
#  It will also validate that the angle is within the specified limits of
#  machine.
#
#  angle        angle to be output.
#  prev_angle   previous angle output.  It should be mom_out_angle_pos
#  dir          can be either MAGNITUDE_DETERMINES_DIRECTION or
#               SIGN_DETERMINES_DIRECTION
#  kin_leader   leader (usually A, B or C) defined by Post Builder
#  sys_leader   leader that is created by ROTSET.  It could be "C-".
#  min          minimum degrees of travel for current axis
#  max          maximum degrees of travel for current axis
#
#  tol_flag     performance comparison with tolerance
#                 0 : No (default)
#                 1 : Yes
#
#
# - This command is called by the following functions:
#   RETRACT_ROTARY_AXIS, LOCK_AXIS_MOTION, LINEARIZE_LOCK_OUTPUT,
#   MOM_rotate, LINEARIZE_OUTPUT and MILL_TURN.
#
#=============================================================
# Revisions
# 02-25-2009 mzg - Added optional argument tol_flag to allow
#                  performing comparisions with tolerance
# 03-13-2012 gsl - (pb850) LIMIT_ANGLE should be called by using its return value
#                - Allow comparing max/min with tolerance
# 10-27-2015 gsl - Initialize mom_rotary_direction_4th & mom_rotary_direction_5th
#=============================================================

   upvar $sys_leader lead

  #
  #  Make sure angle is 0~360 to start with.
  #
   set angle [LIMIT_ANGLE $angle]
   set check_solution 0

   if { ![string compare "MAGNITUDE_DETERMINES_DIRECTION" $dir] } {

   #
   #  If magnitude determines direction and total travel is less than or equal
   #  to 360, we can assume there is at most one valid solution.  Find it and
   #  leave.  Check for the total travel being less than 360 and give a warning
   #  if a valid position cannot be found.
   #
      set travel [expr abs($max - $min)]

      if { $travel <= 360.0 } {

         set check_solution 1

      } else {

         if { $tol_flag == 0 } { ;# Exact comparison
            while { [expr abs([expr $angle - $prev_angle])] > 180.0 } {
               if { [expr $angle - $prev_angle] < -180.0 } {
                  set angle [expr $angle + 360.0]
               } elseif { [expr $angle - $prev_angle] > 180.0 } {
                  set angle [expr $angle - 360.0]
               }
            }
         } else { ;# Tolerant comparison
            while { [EQ_is_gt [expr abs([expr $angle - $prev_angle])] 180.0] } {
               if { [EQ_is_lt [expr $angle - $prev_angle] -180.0] } {
                  set angle [expr $angle + 360.0]
               } elseif { [EQ_is_gt [expr $angle - $prev_angle] 180.0] } {
                  set angle [expr $angle - 360.0]
               }
            }
         }
      }

      #<03-13-12 gsl> Fit angle within limits
      if { $tol_flag == 1 } { ;# Tolerant comparison
         while { [EQ_is_lt $angle $min] } { set angle [expr $angle + 360.0] }
         while { [EQ_is_gt $angle $max] } { set angle [expr $angle - 360.0] }
      } else { ;# Legacy direct comparison
         while { $angle < $min } { set angle [expr $angle + 360.0] }
         while { $angle > $max } { set angle [expr $angle - 360.0] }
      }

   } elseif { ![string compare "SIGN_DETERMINES_DIRECTION" $dir] } {

   #
   #  Sign determines direction.  Determine whether the shortest distance is
   #  clockwise or counterclockwise.  If counterclockwise append a "-" sign
   #  to the address leader.
   #
      set check_solution 1

      #<09-15-09 wbh> If angle is negative, we add 360 to it instead of getting the absolute value of it.
      if { $angle < 0 } {
         set angle [expr $angle + 360]
      }

      set minus_flag 0
     # set angle [expr abs($angle)]  ;# This line was not in ROTSET of xzc post.

      set del [expr $angle - $prev_angle]
      if { $tol_flag == 0 } { ;# Exact comparison
         if { ($del < 0.0 && $del > -180.0) || $del > 180.0 } {
           # set lead "$kin_leader-"
            set minus_flag 1
         } else {
            set lead $kin_leader
         }
      } else { ;# Tolerant comparison
         if { ([EQ_is_lt $del 0.0] && [EQ_is_gt $del -180.0]) || [EQ_is_gt $del 180.0] } {
           # set lead "$kin_leader-"
            set minus_flag 1
         } else {
            set lead $kin_leader
         }
      }

      #<04-27-11 wbh> 1819104 Check the rotary axis is 4th axis or 5th axis
      global mom_kin_4th_axis_leader mom_kin_5th_axis_leader
      global mom_rotary_direction_4th mom_rotary_direction_5th
      global mom_prev_rotary_dir_4th mom_prev_rotary_dir_5th

      set is_4th 1
      if { [info exists mom_kin_5th_axis_leader] && [string match "$mom_kin_5th_axis_leader" "$kin_leader"] } {
         set is_4th 0
      }

      if { ![info exists mom_rotary_direction_4th] } { set mom_rotary_direction_4th 1 }
      if { ![info exists mom_rotary_direction_5th] } { set mom_rotary_direction_5th 1 }

      #<09-15-09 wbh>
      if { $minus_flag && [EQ_is_gt $angle 0.0] } {
         set lead "$kin_leader-"

         #<04-27-11 wbh> Since the leader should add a minus, the rotary direction need be reset
         if { $is_4th } {
            set mom_rotary_direction_4th -1
         } else {
            set mom_rotary_direction_5th -1
         }
      }

      #<04-27-11 wbh> If the delta angle is 0 or 180, there has no need to change the rotary direction,
      #               we should reset the current direction with the previous direction
      if { [EQ_is_zero $del] || [EQ_is_equal $del 180.0] || [EQ_is_equal $del -180.0] } {
         if { $is_4th } {
            if { [info exists mom_prev_rotary_dir_4th] } {
               set mom_rotary_direction_4th $mom_prev_rotary_dir_4th
            }
         } else {
            if { [info exists mom_prev_rotary_dir_5th] } {
               set mom_rotary_direction_5th $mom_prev_rotary_dir_5th
            }
         }
      } else {
         # Set the previous direction
         if { $is_4th } {
            set mom_prev_rotary_dir_4th $mom_rotary_direction_4th
         } else {
            set mom_prev_rotary_dir_5th $mom_rotary_direction_5th
         }
      }
   }

   #<03-13-12 gsl> Check solution
   #
   #  There are no alternate solutions.
   #  If the position is out of limits, give a warning and leave.
   #
   if { $check_solution } {
      if { $tol_flag == 1 } {
         if { [EQ_is_gt $angle $max] || [EQ_is_lt $angle $min] } {
            CATCH_WARNING "$kin_leader-axis is under minimum or over maximum. Assumed default."
         }
      } else {
         if { ($angle > $max) || ($angle < $min) } {
            CATCH_WARNING "$kin_leader-axis is under minimum or over maximum. Assumed default."
         }
      }
   }

return $angle
}


#=============================================================
proc SET_FEEDRATE_NUMBER { dist feed } {
#=============================================================
# called by ROTARY_AXIS_RETRACT

#<03-13-08 gsl> FRN factor should not be used here! Leave it to PB_CMD_FEEDRATE_NUMBER
# global mom_sys_frn_factor

  global mom_kin_max_frn

  if { [EQ_is_zero $dist] } {
return $mom_kin_max_frn
  } else {
    set f [expr $feed / $dist ]
    if { [EQ_is_lt $f $mom_kin_max_frn] } {
return $f
    } else {
return $mom_kin_max_frn
    }
  }
}


#=============================================================
proc SET_LOCK { axis plane value } {
#=============================================================
# called by MOM_lock_axis

  upvar $axis a ; upvar $plane p ; upvar $value v

  global mom_kin_machine_type mom_lock_axis mom_lock_axis_plane mom_lock_axis_value
  global mom_warning_info

   set machine_type [string tolower $mom_kin_machine_type]
   switch $machine_type {
      4_axis_head       -
      4_axis_table      -
      3_axis_mill_turn  -
      mill_turn         { set mtype 4 }
      5_axis_dual_table -
      5_axis_dual_head  -
      5_axis_head_table { set mtype 5 }
      default {
         set mom_warning_info "Set lock only vaild for 4 and 5 axis machines"
return "error"
      }
   }

   # Check the locked rotary axis.
   # If the rotary axis is the locked axis, it must be the 4th axis for 4-axis machine,
   # or the 5th axis for 5-axis machine.
   if { ![CHECK_LOCK_ROTARY_AXIS $mom_lock_axis $mtype] } {
      set mom_warning_info "Specified rotary axis is invalid as the lock axis"
      return "error"
   }

   set p -1

   global mom_sys_lock_arc_save
   global mom_kin_arc_output_mode

   switch $mom_lock_axis {
      OFF {
         if { [info exists mom_sys_lock_arc_save] } {
             set mom_kin_arc_output_mode $mom_sys_lock_arc_save
             unset mom_sys_lock_arc_save
             MOM_reload_kinematics
         }
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
               if { $mtype == 5 } {
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
               if { $mtype == 5 } {
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
               if { $mtype == 5 } {
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

   if { ![info exists mom_sys_lock_arc_save] } {
      set mom_sys_lock_arc_save $mom_kin_arc_output_mode
   }

   set mom_kin_arc_output_mode "LINEAR"
   MOM_reload_kinematics

return "ON"
}


#=============================================================
proc SOLVE_QUADRATIC { coeff rcomp icomp status degree } {
#=============================================================
# called by CALC_SPHERICAL_RETRACT_POINT

   upvar $coeff c ; upvar $rcomp rc ; upvar $icomp ic
   upvar $status st ; upvar $degree deg

   set st 1
   set deg 0
   set rc(0) 0.0 ; set rc(1) 0.0
   set ic(0) 0.0 ; set ic(1) 0.0
   set mag [VEC3_mag c]
   if { [EQ_is_zero $mag] } { return 0 }

   set acoeff [expr $c(2)/$mag]
   set bcoeff [expr $c(1)/$mag]
   set ccoeff [expr $c(0)/$mag]

   if { ![EQ_is_zero $acoeff] } {
      set deg 2
      set denom [expr $acoeff*2.]
      set dscrm [expr $bcoeff*$bcoeff - $acoeff*$ccoeff*4.0]
      if { [EQ_is_zero $dscrm] } {
         set dsqrt1 0.0
      } else {
         set dsqrt1 [expr sqrt(abs($dscrm))]
      }
      if { [EQ_is_ge $dscrm 0.0] } {
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
   } elseif { ![EQ_is_zero $bcoeff] } {
      set st 3
      set deg 1
      set rc(0) [expr -$ccoeff/$bcoeff]
      return 1
   } elseif { [EQ_is_zero $ccoeff] } {
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
proc UNLOCK_AXIS { locked_point unlocked_point } {
#=============================================================
# called by LINEARIZE_LOCK_MOTION
#
# (pb903)
# 04-16-14 gsl - Account for offsets resulted from right-angled head attachment
# 09-09-15 ljt - Replace mom_kin_4/5th_axis_center_offset with mom_kin_4/5th_axis_point
#
# (pb1101)
# 08-11-16 gsl - Correct error for removing offsets
#

   upvar $locked_point in_pos ; upvar $unlocked_point out_pos

   global mom_sys_lock_plane
   global mom_sys_linear_axis_index_1
   global mom_sys_linear_axis_index_2
   global mom_sys_rotary_axis_index
   global mom_kin_4th_axis_center_offset
   global mom_kin_5th_axis_center_offset
   global mom_kin_4th_axis_point
   global mom_kin_5th_axis_point
   global mom_kin_machine_type
   global mom_origin
   global DEG2RAD


  #<04-16-2014 gsl> Add offsets of angled-head attachment to input point
   VMOV 5 in_pos ip
   ACCOUNT_HEAD_OFFSETS ip 1


   #<09-Sep-2015 ljt> Add offsets of 4/5th axis rotary center
   VMOV 3 ip temp
   if { [CMD_EXIST MOM_validate_machine_model] \
        && [string match "TRUE" [MOM_validate_machine_model]] } {

      if { [string match "5_axis_*table" $mom_kin_machine_type] && [info exists mom_kin_5th_axis_point] } {

         VEC3_sub temp mom_kin_5th_axis_point temp

      } elseif { ( [string match "4_axis_table" $mom_kin_machine_type] || [string match "*mill_turn" $mom_kin_machine_type] )\
                 && [info exists mom_kin_4th_axis_point] } {

         VEC3_sub temp mom_kin_4th_axis_point temp
      }

   } else {

      if { [info exists mom_origin] } {
         VEC3_sub temp mom_origin temp
      }

      if { [info exists mom_kin_4th_axis_center_offset] } {
         VEC3_add temp mom_kin_4th_axis_center_offset temp
      }

      if { [info exists mom_kin_5th_axis_center_offset] } {
         VEC3_add temp mom_kin_5th_axis_center_offset temp
      }
   }

   set op(3) $ip(3)
   set op(4) $ip(4)

   set ang [expr $op($mom_sys_rotary_axis_index)*$DEG2RAD]
   ROTATE_VECTOR $mom_sys_lock_plane $ang temp op

   set op($mom_sys_rotary_axis_index) 0.0


   #<09-Sep-2015 ljt> Remove offsets of 4/5th axis rotary center
   if { [CMD_EXIST MOM_validate_machine_model] &&\
        [string match "TRUE" [MOM_validate_machine_model]] } {

      if { [string match "5_axis_*table" $mom_kin_machine_type] && [info exists mom_kin_5th_axis_point] } {

         VEC3_add op mom_kin_5th_axis_point op

      } elseif { ( [string match "4_axis_table" $mom_kin_machine_type] || [string match "*mill_turn" $mom_kin_machine_type] ) && \
                 [info exists mom_kin_4th_axis_point] } {

         VEC3_add op mom_kin_4th_axis_point op
      }

   } else {

     #<Aug-11-2016> Reverse next 3 operations
      if { [info exists mom_origin] } {
         VEC3_sub op mom_origin op
      }

      if { [info exists mom_kin_4th_axis_center_offset] } {
         VEC3_add op mom_kin_4th_axis_center_offset op
      }

      if { [info exists mom_kin_5th_axis_center_offset] } {
         VEC3_add op mom_kin_5th_axis_center_offset op
      }
   }


  #<04-16-2014 gsl> Remove offsets of angled-head attachment from output point
   ACCOUNT_HEAD_OFFSETS op 0
   VMOV 5 op out_pos
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
proc VALIDATE_MOTION { } {
#=============================================================
# To be called by PB_CMD_kin_before_motion

   if [CMD_EXIST PB_CMD__validate_motion] {
return [PB_CMD__validate_motion]
   } else {
      # Assume OK, when no validation is done.
return 1
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


