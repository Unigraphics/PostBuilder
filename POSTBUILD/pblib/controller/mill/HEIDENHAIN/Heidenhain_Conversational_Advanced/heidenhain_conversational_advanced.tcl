########################## TCL Event Handlers ##########################
#
#  heidenhain_conversational_advanced.tcl - 5_axis_head_table
#
#    This is a 5-Axis Milling Machine With
#     Rotary Head and Table.
#
#  Created by w5ygvn @ Wednesday, September 02, 2015 10:26:51 AM China Standard Time
#  with Post Builder version 10.0.3.
#
########################################################################



#=============================================================
proc PB_CMD___log_revisions { } {
#=============================================================
# Dummy command to log revisions history of this post -
#
# 02-26-09 gsl - Initial version
# 08-26-09 gsl - Replaced PB_CMD_fix_RAPID_SET & PB_CMD_set_cycle_plane
#              - Added PB_CMD_set_principal_axis
# 06-18-10 gsl - Cleaned up for PB v752 template post
# 07-29-10 gsl - Also remove trailing in-line comments & { } in PB_CMD_before_output
# 08-18-10 gsl - Enhanced handling of PB_CMD_before_rapid & PB_CMD_after_rapid
#              - Populated new utility commands from PB base file
# 03-15-11 gsl - Don not remove trailing comments in PB_CMD_before_output by default
# 05-24-11 gsl - Use mom_arc_angle to compute total helix angle in PB_CMD_helix_move
# 10-18-13 JSF - Behavior change: no home return in the end of path if there is no tool change in next operation.
#                Home return if it is the last operation. Modified in PB_CMD_check_block_return_to_reference_point.
#              - Behavior change: table axis will not return to zero if the tool vector turn to be along Z axis
#                in cycle plane change or in rapid move. Modified in PB_CMD_cycle_coord_rotation &
#                PB_CMD_check_plane_change_in_rapid_move.
#              - Bug fix in general proc: 4th and 5th axis and related mom motion variable should be switched
#                for head head machine when changing the kinematics. Fixed in DPP_GE_COOR_ROT_AUTO3D and DPP_GE_RESTORE_KINEMATICS.
# 06-04-14 Allen - PR7143300 fix: check if variable mom_next_oper_has_tool_change and mom_current_oper_is_last_oper_in_program
#                  exists for PB_CMD__check_block_return_to_reference_point
# 30-04-15 ljt - add PB_CMD_spindle_orient and add PB_CMD__check_block_cycle_rapidtoZ to fix PR7162261, enable spindle_rpm in MOM_spindle_rpm, fix PR7281995
# 17-Aug-2015 gsl - Resurrected blocks of new tapping cycles and refiled in PB v10.03
# 18-Aug-2015 gsl - Updated PB_CMD_fix_RAPID_SET
# 08-21-2015 szl - Fix PR7471332:Parse error during machine code simulation if the UDE Operator Message is added.
# 08-21-2015 szl - Enhance the warning message when users set wrong pitch and wrong spindle speed,fix PR7463004
}



  set cam_post_dir [MOM_ask_env_var UGII_CAM_POST_DIR]
  set this_post_dir "[file dirname [info script]]"


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
 
     MOM_set_debug_mode $mom_sys_debug_mode


   ####  Listing File variables 
     set mom_sys_list_output                       "OFF"
     set mom_sys_header_output                     "OFF"
     set mom_sys_list_file_rows                    "40"
     set mom_sys_list_file_columns                 "30"
     set mom_sys_warning_output                    "OFF"
     set mom_sys_warning_output_option             "FILE"
     set mom_sys_group_output                      "OFF"
     set mom_sys_list_file_suffix                  "lpt"
     set mom_sys_output_file_suffix                "h"
     set mom_sys_commentary_output                 "ON"
     set mom_sys_commentary_list                   "x y z 4axis 5axis feed speed"
     set mom_sys_pb_link_var_mode                  "OFF"


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

   ######### The following procedure invokes the listing file with warnings.

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


     set mom_sys_control_out                       "; "
     set mom_sys_control_in                        ""


    # Retain UDE handlers of ugpost_base
     foreach ude_handler { MOM_insert \
                           MOM_operator_message \
                           MOM_opskip_off \
                           MOM_opskip_on \
                           MOM_pprint \
                           MOM_text \
                         } \
     {
        if { [llength [info commands $ude_handler]] &&\
            ![llength [info commands ugpost_${ude_handler}]] } {
           rename $ude_handler ugpost_${ude_handler}
        }
     }


     set mom_sys_post_initialized 1
  }


  set mom_sys_use_default_unit_fragment         "ON"
  set mom_sys_alt_unit_post_name                "heidenhain_conversational_advanced__MM.pui"


########## SYSTEM VARIABLE DECLARATIONS ##############
  set mom_sys_rapid_code                        "L"
  set mom_sys_linear_code                       "L"
  set mom_sys_circle_code(CLW)                  "DR-"
  set mom_sys_circle_code(CCLW)                 "DR+"
  set mom_sys_delay_code(SECONDS)               "4"
  set mom_sys_delay_code(REVOLUTIONS)           "4"
  set mom_sys_cutcom_plane_code(XY)             "17"
  set mom_sys_cutcom_plane_code(ZX)             "18"
  set mom_sys_cutcom_plane_code(XZ)             "18"
  set mom_sys_cutcom_plane_code(YZ)             "19"
  set mom_sys_cutcom_plane_code(ZY)             "19"
  set mom_sys_cutcom_code(OFF)                  "R0"
  set mom_sys_cutcom_code(LEFT)                 "RL"
  set mom_sys_cutcom_code(RIGHT)                "RR"
  set mom_sys_adjust_code                       "43"
  set mom_sys_adjust_code_minus                 "44"
  set mom_sys_adjust_cancel_code                "49"
  set mom_sys_unit_code(IN)                     "70"
  set mom_sys_unit_code(MM)                     "71"
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
  set mom_sys_feed_rate_mode_code(MMPM)         "94"
  set mom_sys_feed_rate_mode_code(MMPR)         "95"
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
  set mom_sys_coolant_code(TAP)                 "25"
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
  set mom_sys_cir_vector                        "Vector - Absolute Arc Center"
  set mom_sys_spindle_ranges                    "0"
  set mom_sys_rewind_stop_code                  "\#"
  set mom_sys_home_pos(0)                       "0"
  set mom_sys_home_pos(1)                       "0"
  set mom_sys_home_pos(2)                       "0"
  set mom_sys_zero                              "0"
  set mom_sys_opskip_block_leader               "/"
  set mom_sys_seqnum_start                      "1"
  set mom_sys_seqnum_incr                       "1"
  set mom_sys_seqnum_freq                       "1"
  set mom_sys_seqnum_max                        "99999"
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
  set mom_sys_leader(N)                         ""
  set mom_sys_leader(X)                         "X"
  set mom_sys_leader(Y)                         "Y"
  set mom_sys_leader(Z)                         "Z"
  set mom_sys_leader(fourth_axis)               "B"
  set mom_sys_leader(fifth_axis)                "C"
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
  set mom_sys_feed_param(MMPM,format)           "Feed_MMPM"
  set mom_sys_feed_param(MMPR,format)           "Feed_MMPR"
  set mom_sys_retract_distance                  "10"
  set mom_sys_linearization_method              "angle"
  set mom_sys_tool_number_max                   "32"
  set mom_sys_tool_number_min                   "1"
  set mom_sys_post_description                  "This is a 5-Axis Milling Machine With\n\
                                                  Rotary Head and Table."
  set mom_sys_ugpadvkins_used                   "0"
  set mom_sys_post_builder_version              "10.0.3"

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
  set mom_kin_4th_axis_type                     "Head"
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
  set mom_kin_5th_axis_leader                   "C"
  set mom_kin_5th_axis_limit_action             "Warning"
  set mom_kin_5th_axis_max_limit                "360"
  set mom_kin_5th_axis_min_incr                 "0.001"
  set mom_kin_5th_axis_min_limit                "0"
  set mom_kin_5th_axis_plane                    "XY"
  set mom_kin_5th_axis_point(0)                 "0.0"
  set mom_kin_5th_axis_point(1)                 "0.0"
  set mom_kin_5th_axis_point(2)                 "0.0"
  set mom_kin_5th_axis_rotation                 "standard"
  set mom_kin_5th_axis_type                     "Table"
  set mom_kin_5th_axis_vector(0)                "0"
  set mom_kin_5th_axis_vector(1)                "0"
  set mom_kin_5th_axis_vector(2)                "1"
  set mom_kin_5th_axis_zero                     "0.0"
  set mom_kin_arc_output_mode                   "FULL_CIRCLE"
  set mom_kin_arc_valid_plane                   "XY"
  set mom_kin_clamp_time                        "2.0"
  set mom_kin_cycle_plane_change_per_axis       "1"
  set mom_kin_cycle_plane_change_to_lower       "1"
  set mom_kin_flush_time                        "2.0"
  set mom_kin_linearization_flag                "1"
  set mom_kin_linearization_tol                 "0.001"
  set mom_kin_machine_resolution                ".0001"
  set mom_kin_machine_type                      "5_axis_head_table"
  set mom_kin_machine_zero_offset(0)            "0.0"
  set mom_kin_machine_zero_offset(1)            "0.0"
  set mom_kin_machine_zero_offset(2)            "0.0"
  set mom_kin_max_arc_radius                    "9999.9999"
  set mom_kin_max_dpm                           "10"
  set mom_kin_max_fpm                           "600"
  set mom_kin_max_fpr                           "100"
  set mom_kin_max_frn                           "1000"
  set mom_kin_min_arc_length                    "0.01"
  set mom_kin_min_arc_radius                    "0.0001"
  set mom_kin_min_dpm                           "0.0"
  set mom_kin_min_fpm                           "0.1"
  set mom_kin_min_fpr                           "0.01"
  set mom_kin_min_frn                           "0.01"
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
  set mom_kin_tool_change_time                  "10.0"
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
   MOM_do_template coolant_off
   MOM_do_template end_of_program_3
   MOM_do_template end_of_program
   MOM_do_template end_of_program_1
   MOM_set_seq_off

#**** The following procedure lists the tool list with time in commentary data
   LIST_FILE_TRAILER

#**** The following procedure closes the warning and listing files
   CLOSE_files

   if [llength [info commands PB_CMD_kin_end_of_program] ] {
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

  # For simple mill-turn
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


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_set_cycle_plane
      PB_CMD_init_cycle
      PB_call_macro CYCL_201
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_force Once G_motion
   MOM_do_template cycle_parameters
   if { [PB_CMD__check_block_cycle_rapid_to] } {
      MOM_force Once G_motion
      MOM_do_template cycle_parameters_1
   }
   PB_call_macro CYCL_CALL
   if { [PB_CMD__check_block_tap_cycle] } {
      MOM_force Once M_spindle
      MOM_do_template cycle_parameters_2
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


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


  global mom_heidenhain_depth_of_counterbore
  global mom_heidenhain_material_thickness
  global mom_heidenhain_off_center_distance
  global mom_heidenhain_tool_edge_height
  global mom_heidenhain_prepositioning_feedrate
  global mom_heidenhain_disengaging_direction
  global mom_heidenhain_spindile_angle

   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_set_cycle_plane
      PB_CMD_init_cycle
      if { [PB_CMD__check_block_CYCL_202] } {
         PB_call_macro CYCL_202
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_force Once G_motion
   MOM_do_template cycle_parameters
   if { [PB_CMD__check_block_cycle_rapid_to] } {
      MOM_force Once G_motion
      MOM_do_template cycle_parameters_1
   }
   PB_call_macro CYCL_CALL
   if { [PB_CMD__check_block_tap_cycle] } {
      MOM_force Once M_spindle
      MOM_do_template cycle_parameters_2
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


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_set_cycle_plane
      PB_CMD_init_cycle
      PB_call_macro CYCL_200
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_force Once G_motion
   MOM_do_template cycle_parameters
   if { [PB_CMD__check_block_cycle_rapid_to] } {
      MOM_force Once G_motion
      MOM_do_template cycle_parameters_1
   }
   PB_call_macro CYCL_CALL
   if { [PB_CMD__check_block_tap_cycle] } {
      MOM_force Once M_spindle
      MOM_do_template cycle_parameters_2
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


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_set_cycle_plane
      PB_CMD_init_cycle
      PB_call_macro CYCL_200
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_force Once G_motion
   MOM_do_template cycle_parameters
   if { [PB_CMD__check_block_cycle_rapid_to] } {
      MOM_force Once G_motion
      MOM_do_template cycle_parameters_1
   }
   PB_call_macro CYCL_CALL
   if { [PB_CMD__check_block_tap_cycle] } {
      MOM_force Once M_spindle
      MOM_do_template cycle_parameters_2
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


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_set_cycle_plane
      PB_CMD_init_cycle
      PB_call_macro CYCL_200
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_force Once G_motion
   MOM_do_template cycle_parameters
   if { [PB_CMD__check_block_cycle_rapid_to] } {
      MOM_force Once G_motion
      MOM_do_template cycle_parameters_1
   }
   PB_call_macro CYCL_CALL
   if { [PB_CMD__check_block_tap_cycle] } {
      MOM_force Once M_spindle
      MOM_do_template cycle_parameters_2
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


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_set_cycle_plane
      PB_CMD_init_cycle
      PB_call_macro CYCL_200
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_force Once G_motion
   MOM_do_template cycle_parameters
   if { [PB_CMD__check_block_cycle_rapid_to] } {
      MOM_force Once G_motion
      MOM_do_template cycle_parameters_1
   }
   PB_call_macro CYCL_CALL
   if { [PB_CMD__check_block_tap_cycle] } {
      MOM_force Once M_spindle
      MOM_do_template cycle_parameters_2
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


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_set_cycle_plane
      PB_CMD_init_cycle
      if { [PB_CMD__check_block_CYCL_202] } {
         PB_call_macro CYCL_202
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_force Once G_motion
   MOM_do_template cycle_parameters
   if { [PB_CMD__check_block_cycle_rapid_to] } {
      MOM_force Once G_motion
      MOM_do_template cycle_parameters_1
   }
   PB_call_macro CYCL_CALL
   if { [PB_CMD__check_block_tap_cycle] } {
      MOM_force Once M_spindle
      MOM_do_template cycle_parameters_2
   }
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_circular_move { } {
#=============================================================

   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   CIRCLE_SET
   PB_CMD_set_cycle_plane
   MOM_force Once Text I J
   MOM_do_template circular_move
   MOM_force Once G_motion circle_direction X Y
   MOM_do_template circular_move_1
}


#=============================================================
proc MOM_clamp { } {
#=============================================================
   global mom_clamp_axis
   global mom_clamp_status
   global mom_clamp_text
   PB_CMD_MOM_clamp
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
proc MOM_cutcom_on { } {
#=============================================================
   CUTCOM_SET

   global mom_cutcom_adjust_register
   set cutcom_register_min 1
   set cutcom_register_max 99
   if { [info exists mom_cutcom_adjust_register] } {
      if { $mom_cutcom_adjust_register < $cutcom_register_min ||\
           $mom_cutcom_adjust_register > $cutcom_register_max } {
         CATCH_WARNING "CUTCOM register $mom_cutcom_adjust_register must be within the range between 1 and 99"
      }
   }
}


#=============================================================
proc MOM_cutcom_off { } {
#=============================================================
   CUTCOM_SET
}


#=============================================================
proc MOM_cycle_off { } {
#=============================================================
}


#=============================================================
proc MOM_cycle_plane_change { } {
#=============================================================
  global cycle_init_flag
  global mom_cycle_tool_axis_change
  global mom_cycle_clearance_plane_change

   set cycle_init_flag TRUE
   PB_CMD_cycle_coord_rotation
   PB_CMD_clearance_plane_change
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_datum_output { } {
#=============================================================
   global mom_ude_datum_option
   PB_CMD_UDE_datum_setting
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


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_set_cycle_plane
      PB_CMD_init_cycle
      PB_call_macro CYCL_200
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_force Once G_motion
   MOM_do_template cycle_parameters
   if { [PB_CMD__check_block_cycle_rapid_to] } {
      MOM_force Once G_motion
      MOM_do_template cycle_parameters_1
   }
   PB_call_macro CYCL_CALL
   if { [PB_CMD__check_block_tap_cycle] } {
      MOM_force Once M_spindle
      MOM_do_template cycle_parameters_2
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


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_set_cycle_plane
      PB_CMD_init_cycle
      PB_call_macro CYCL_200
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_force Once G_motion
   MOM_do_template cycle_parameters
   if { [PB_CMD__check_block_cycle_rapid_to] } {
      MOM_force Once G_motion
      MOM_do_template cycle_parameters_1
   }
   PB_call_macro CYCL_CALL
   if { [PB_CMD__check_block_tap_cycle] } {
      MOM_force Once M_spindle
      MOM_do_template cycle_parameters_2
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


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_set_cycle_plane
      PB_CMD_init_cycle
      PB_call_macro CYCL_200
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_force Once G_motion
   MOM_do_template cycle_parameters
   if { [PB_CMD__check_block_cycle_rapid_to] } {
      MOM_force Once G_motion
      MOM_do_template cycle_parameters_1
   }
   PB_call_macro CYCL_CALL
   if { [PB_CMD__check_block_tap_cycle] } {
      MOM_force Once M_spindle
      MOM_do_template cycle_parameters_2
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


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_set_cycle_plane
      PB_CMD_init_cycle
      PB_call_macro CYCL_200
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_force Once G_motion
   MOM_do_template cycle_parameters
   if { [PB_CMD__check_block_cycle_rapid_to] } {
      MOM_force Once G_motion
      MOM_do_template cycle_parameters_1
   }
   PB_call_macro CYCL_CALL
   if { [PB_CMD__check_block_tap_cycle] } {
      MOM_force Once M_spindle
      MOM_do_template cycle_parameters_2
   }
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


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


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

   if [llength [info commands PB_CMD_kin_end_of_path] ] {
      PB_CMD_kin_end_of_path
   }

   PB_CMD_reset_output_mode
   MOM_do_template spindle_off
   MOM_do_template m140
   if { [PB_CMD__check_block_return_to_reference_point] } {
      MOM_force Once M
      MOM_do_template return_home_z
   }
   if { [PB_CMD__check_block_return_to_reference_point] } {
      MOM_force Once M
      MOM_do_template return_home_xy
   }
   if { [PB_CMD__check_block_return_to_reference_point] } {
      MOM_force Once fourth_axis fifth_axis
      MOM_do_template return_home_rotary_both
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
   PB_CMD_detect_tool_path_type
   PB_CMD_detect_csys_rotation
   PB_CMD_detect_local_offset
   PB_CMD_define_fixture_csys
   PB_CMD_verify_RPM
   PB_CMD_output_coordinate_offset
   if { [PB_CMD__check_block_plane_spatial] } {
      MOM_do_template plane_spatial
   }
   if { [PB_CMD__check_block_rapid_rotary] } {
      MOM_do_template rapid_rotary
   }
   if { [PB_CMD__check_block_output_m128] } {
      MOM_do_template output_m128
   }
   PB_CMD_init_force_address
   catch { MOM_$mom_motion_event }
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
proc MOM_head { } {
#=============================================================
   global mom_head_name
}


#=============================================================
proc MOM_Head { } {
#=============================================================
   MOM_head
}


#=============================================================
proc MOM_HEAD { } {
#=============================================================
   MOM_head
}


#=============================================================
proc MOM_helix_move { } {
#=============================================================
   PB_CMD_helix_move
   MOM_do_template helix_move_1
   MOM_force Once circle_direction G_motion
   MOM_do_template helix_move
}


#=============================================================
proc MOM_initial_move { } {
#=============================================================
  global mom_feed_rate mom_feed_rate_per_rev mom_motion_type
  global mom_kin_max_fpm mom_motion_event
   COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET
   PB_CMD_detect_tool_path_type
   PB_CMD_detect_csys_rotation
   PB_CMD_detect_local_offset
   PB_CMD_define_fixture_csys
   PB_CMD_save_RPM
   MOM_force Once G_motion M
   MOM_do_template m126
   PB_CMD_output_coordinate_offset
   if { [PB_CMD__check_block_plane_spatial] } {
      MOM_force Once Text SPA SPB SPC Text
      MOM_do_template plane_spatial
   }
   if { [PB_CMD__check_block_rapid_rotary] } {
      MOM_do_template rapid_rotary
   }
   if { [PB_CMD__check_block_output_m128] } {
      MOM_do_template output_m128
   }
   PB_CMD_init_force_address

  global mom_programmed_feed_rate
   if { [EQ_is_equal $mom_programmed_feed_rate 0] } {
      MOM_rapid_move
   } else {
      MOM_linear_move
   }
}


#=============================================================
proc MOM_insert { } {
#=============================================================
   global mom_Instruction
   PB_CMD_MOM_insert
}


#=============================================================
proc MOM_instance_operation_handler { } {
#=============================================================
   global mom_handle_instanced_operations
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

   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   global first_linear_move

   if { !$first_linear_move } {
      PB_first_linear_move
      incr first_linear_move
   }

   if { [PB_CMD__check_block_rotary_axes] } {
      MOM_force Once G_motion
      MOM_do_template linear_move
   }
   if { [PB_CMD__check_block_vector] } {
      MOM_force Once LN
      MOM_do_template linear_move_2
   }
   PB_CMD_save_last_z
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
proc MOM_lock_axis { } {
#=============================================================
   global mom_lock_axis
   global mom_lock_axis_plane
   global mom_lock_axis_value
   PB_CMD_MOM_lock_axis
}


#=============================================================
proc MOM_nurbs_move { } {
#=============================================================
   PB_CMD_nurbs_move
}


#=============================================================
proc MOM_operator_message { } {
#=============================================================
   global mom_operator_message
   PB_CMD_MOM_operator_message
}


#=============================================================
proc MOM_opskip_off { } {
#=============================================================
   global mom_opskip_text
   PB_CMD_MOM_opskip_off
}


#=============================================================
proc MOM_opskip_on { } {
#=============================================================
   global mom_opskip_text
   PB_CMD_MOM_opskip_on
}


#=============================================================
proc MOM_opstop { } {
#=============================================================
   MOM_do_template opstop
}


#=============================================================
proc MOM_origin { } {
#=============================================================
   global mom_X
   global mom_Y
   global mom_Z
   global mom_origin_text
}


#=============================================================
proc MOM_power { } {
#=============================================================
   global mom_power_value
   global mom_power_text
}


#=============================================================
proc MOM_pprint { } {
#=============================================================
   global mom_pprint
   PB_CMD_MOM_pprint
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


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   set spindle_first NONE

   set aa(0) X ; set aa(1) Y ; set aa(2) Z
   RAPID_SET
   PB_CMD_check_plane_change_in_rapid_move
   set rapid_traverse_blk {G_motion X Y Z fourth_axis fifth_axis G_cutcom FMAX M_spindle}
   set rapid_traverse_mod {G_motion}
   if { [PB_CMD__check_block_rotary_axes] } {
      MOM_force Once G_motion
      MOM_do_template rapid_traverse
   }
   if { [PB_CMD__check_block_vector] } {
      MOM_force Once LN
      MOM_do_template rapid_move
   }
   PB_CMD_save_last_z
   PB_CMD_restore_work_plane_change
}


#=============================================================
proc MOM_rotate { } {
#=============================================================
   global mom_rotate_axis_type
   global mom_rotation_mode
   global mom_rotation_direction
   global mom_rotation_angle
   global mom_rotation_reference_mode
   global mom_rotation_text
   PB_CMD_MOM_rotate
}


#=============================================================
proc MOM_select_head { } {
#=============================================================
   global mom_head_type
   global mom_head_text
}


#=============================================================
proc MOM_sequence_number { } {
#=============================================================
   global mom_sequence_mode
   global mom_sequence_number
   global mom_sequence_increment
   global mom_sequence_frequency
   global mom_sequence_text
   SEQNO_SET
}


#=============================================================
proc MOM_set_axis { } {
#=============================================================
   global mom_axis_position
   global mom_axis_position_value
}


#=============================================================
proc MOM_set_modes { } {
#=============================================================
   MODES_SET
}


#=============================================================
proc MOM_set_polar { } {
#=============================================================
   global mom_coordinate_output_mode
}


#=============================================================
proc MOM_set_tool_path_type { } {
#=============================================================
   global mom_ude_5axis_tool_path
}


#=============================================================
proc MOM_spindle_rpm { } {
#=============================================================
   SPINDLE_SET
   PB_CMD_enable_spindle
   MOM_force Once S M_spindle
   MOM_do_template spindle_rpm
}


#=============================================================
proc MOM_spindle_off { } {
#=============================================================
   MOM_do_template spindle_off
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

   if [llength [info commands PB_CMD_kin_start_of_path] ] {
      PB_CMD_kin_start_of_path
   }

   MOM_do_template start_of_path
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


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_set_cycle_plane
      PB_CMD_init_cycle
      PB_call_macro CYCL_207
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_force Once G_motion
   MOM_do_template cycle_parameters
   if { [PB_CMD__check_block_cycle_rapid_to] } {
      MOM_force Once G_motion
      MOM_do_template cycle_parameters_1
   }
   PB_call_macro CYCL_CALL
   if { [PB_CMD__check_block_tap_cycle] } {
      MOM_force Once M_spindle
      MOM_do_template cycle_parameters_2
   }
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_tap_break_chip { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name TAP_BREAK_CHIP
   CYCLE_SET
}


#=============================================================
proc MOM_tap_break_chip_move { } {
#=============================================================
   global cycle_init_flag


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


  global mom_cycle_step_clearance

   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_set_cycle_plane
      PB_CMD_init_cycle
      PB_call_macro CYCL_209
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_force Once G_motion
   MOM_do_template cycle_parameters
   if { [PB_CMD__check_block_cycle_rapid_to] } {
      MOM_force Once G_motion
      MOM_do_template cycle_parameters_1
   }
   PB_call_macro CYCL_CALL
   if { [PB_CMD__check_block_tap_cycle] } {
      MOM_force Once M_spindle
      MOM_do_template cycle_parameters_2
   }
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_tap_deep { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name TAP_DEEP
   CYCLE_SET
}


#=============================================================
proc MOM_tap_deep_move { } {
#=============================================================
   global cycle_init_flag


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_set_cycle_plane
      PB_CMD_init_cycle
      PB_call_macro CYCL_209
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_force Once G_motion
   MOM_do_template cycle_parameters
   if { [PB_CMD__check_block_cycle_rapid_to] } {
      MOM_force Once G_motion
      MOM_do_template cycle_parameters_1
   }
   PB_call_macro CYCL_CALL
   if { [PB_CMD__check_block_tap_cycle] } {
      MOM_force Once M_spindle
      MOM_do_template cycle_parameters_2
   }
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_tap_float { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name TAP_FLOAT
   CYCLE_SET
}


#=============================================================
proc MOM_tap_float_move { } {
#=============================================================
   global cycle_init_flag


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_set_cycle_plane
      PB_CMD_init_cycle
      PB_call_macro CYCL_206
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_force Once G_motion
   MOM_do_template cycle_parameters
   if { [PB_CMD__check_block_cycle_rapid_to] } {
      MOM_force Once G_motion
      MOM_do_template cycle_parameters_1
   }
   PB_call_macro CYCL_CALL
   if { [PB_CMD__check_block_tap_cycle] } {
      MOM_force Once M_spindle
      MOM_do_template cycle_parameters_2
   }
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_text { } {
#=============================================================
   global mom_user_defined_text
   PB_CMD_MOM_text
}


#=============================================================
proc MOM_thread_mill { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name THREAD_MILL
   CYCLE_SET
}


#=============================================================
proc MOM_thread_mill_move { } {
#=============================================================
  global cycle_init_flag


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   global mom_heidenhain_nominal_diameter
   global mom_heidenhain_threads_per_step
   global mom_heidenhain_prepos_feedrate
   global mom_heidenhain_milling_type
   global mom_heidenhain_milling_feedrate


   PB_CMD_set_cycle_plane
   PB_CMD_init_cycle
   PB_call_macro CYCL_262
   MOM_do_template thread_mill_2
   MOM_do_template thread_mill_3
   PB_call_macro CYCL_CALL
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

}


#=============================================================
proc MOM_workpiece_load { } {
#=============================================================
   global mom_spindle_number
}


#=============================================================
proc MOM_workpiece_takeover { } {
#=============================================================
   global mom_spindle_2_position
   global mom_takeover_csys
}


#=============================================================
proc MOM_workpiece_unload { } {
#=============================================================
   global mom_spindle_number
}


#=============================================================
proc MOM_zero { } {
#=============================================================
   global mom_work_coordinate_number
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

   MOM_do_template plane_reset
   MOM_force Once M_spindle
   MOM_do_template first_tool_spindle_off
   MOM_do_template m140
   MOM_force Once M
   MOM_do_template return_home_z
   MOM_force Once M
   MOM_do_template return_home_xy
   MOM_force Once fourth_axis fifth_axis
   MOM_do_template return_home_rotary_both
   MOM_force Once Text T Text S
   MOM_do_template tool_change
   MOM_do_template spindle_on
   if { [PB_CMD__check_block_tool_preselect] } {
      MOM_do_template tool_preselect_1
   }
}


#=============================================================
proc PB_engage_move { } {
#=============================================================
}


#=============================================================
proc PB_feedrates { } {
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

   if [llength [info commands PB_CMD_kin_start_of_program] ] {
      PB_CMD_kin_start_of_program
   }

   PB_CMD_customize_output_mode
   PB_CMD_set_default_dpp_value
   PB_CMD_fix_RAPID_SET
   PB_CMD_spindle_orient
   PB_CMD_nurbs_initialize
   PB_CMD_init_helix
   MOM_set_seq_on
   if { [PB_CMD__check_block_begin_program] } {
      MOM_do_template begin_program
   }
   MOM_do_template output_homeposition_X
   MOM_do_template output_homeposition_Y
   MOM_do_template output_homeposition_Z
   PB_CMD_uplevel_ROTARY_AXIS_RETRACT

   if [llength [info commands PB_CMD_kin_start_of_program_2] ] {
      PB_CMD_kin_start_of_program_2
   }
}


#=============================================================
proc PB_user_def_axis_limit_action { args } {
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
proc PB_CMD_FEEDRATE_SET { } {
#=============================================================
# This custom command will be executed automatically in
# MOM_before_motion event handler.
# Important! Don't change following sentence unless you know what are you doing.
  global mom_user_feed
  global feed
  global mom_output_unit

  switch $mom_output_unit {
      IN {
          set mom_user_feed [expr $feed*10]
      }
      MM {
          set mom_user_feed $feed
      }
   }
}


#=============================================================
proc PB_CMD_M128_output { } {
#=============================================================
   global mom_operation_type
   global feed last_F
   global mom_5axis_control_mode

   if { [string match "AUTO" $mom_5axis_control_mode] } {

      global mom_tool_axis_type
      global TNC_output_mode

      if { [string match "M128" $TNC_output_mode] } {

         if { $feed != $last_F } {
            MOM_force once G_motion
            MOM_do_template output_m128
            set last_F $feed
            MOM_force once F
         }
        #<02-28-08 gsl> MOM_force Once X Y Z fourth_axis fifth_axis
      }

   } else {

      global mom_5axis_control_pos

      if { !$mom_5axis_control_pos } {
         if { $feed != $last_F } {
            MOM_force once G_motion
            MOM_do_template output_m128
            set last_F $feed
            MOM_force once F
         }
        #<02-28-08 gsl> MOM_force Once X Y Z fourth_axis fifth_axis
      }
   }
}


#=============================================================
proc PB_CMD_MOM_clamp { } {
#=============================================================
# Default handler for UDE MOM_clamp
# - Do not attach it to any event!
#

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
proc PB_CMD_MOM_insert { } {
#=============================================================
# Default handler for UDE MOM_insert
# - Do not attach it to any event!
#
# This procedure is executed when the Insert command is activated.
#
   global mom_Instruction
   MOM_output_literal "$mom_Instruction"
}


#=============================================================
proc PB_CMD_MOM_lock_axis { } {
#=============================================================
# Default handler for UDE MOM_lock_axis
# - Do not attach it to any event!
#

  global mom_sys_lock_value mom_sys_lock_plane
  global mom_sys_lock_axis mom_sys_lock_status

   set status [SET_LOCK axis plane value]
   if { ![string compare "error" $status] } {
      MOM_catch_warning
      set mom_sys_lock_status OFF
   } else {
      set mom_sys_lock_status $status
      if { [string compare "OFF" $status] } {
         set mom_sys_lock_axis $axis
         set mom_sys_lock_plane $plane
         set mom_sys_lock_value $value

         LOCK_AXIS_INITIALIZE
      }
   }
}


#=============================================================
proc PB_CMD_MOM_operator_message { } {
#=============================================================
# Default handler for UDE MOM_operator_message
# - Do not attach it to any event!
#
# This procedure is executed when the Operator Message command is activated.
# 08-21-2015 szl - Fix PR7471332:Parse error during machine code simulation if the UDE Operator Message is added.
#
   global mom_operator_message mom_operator_message_defined
   global mom_operator_message_status
   global ptp_file_name group_output_file mom_group_name
   global mom_sys_commentary_output
   global mom_sys_control_in
   global mom_sys_control_out
   global mom_sys_ptp_output
   global mom_post_in_simulation

   if { [info exists mom_operator_message_defined] } {
      if { $mom_operator_message_defined == 0 } {
return
      }
   }

   if { [string compare "ON" $mom_operator_message] && [string compare "OFF" $mom_operator_message] } {

      set brac_start [string first \( $mom_operator_message]
      set brac_end   [string last \) $mom_operator_message]

      if { $brac_start != 0 } {
         set text_string "("
      } else {
         set text_string ""
      }

      append text_string $mom_operator_message

      if { $brac_end != [expr [string length $mom_operator_message] - 1] } {
         append text_string ")"
      }

      MOM_close_output_file   $ptp_file_name

      if { [info exists mom_group_name] } {
         if { [info exists group_output_file($mom_group_name)] } {
            MOM_close_output_file $group_output_file($mom_group_name)
         }
      }

      MOM_suppress once N

      if { ![info exists mom_post_in_simulation] || $mom_post_in_simulation == 0 } {
                MOM_output_literal $text_string
      }

      if { ![string compare "ON" $mom_sys_ptp_output] } {
         MOM_open_output_file    $ptp_file_name
      }

      if { [info exists mom_group_name] } {
         if { [info exists group_output_file($mom_group_name)] } {
            MOM_open_output_file $group_output_file($mom_group_name)
         }
      }

      set need_commentary $mom_sys_commentary_output
      set mom_sys_commentary_output OFF
      regsub -all {[)]} $text_string $mom_sys_control_in text_string
      regsub -all {[(]} $text_string $mom_sys_control_out text_string

      MOM_output_literal $text_string

      set mom_sys_commentary_output $need_commentary

   } else {
      set mom_operator_message_status $mom_operator_message
   }
}


#=============================================================
proc PB_CMD_MOM_opskip_off { } {
#=============================================================
# Default handler for UDE MOM_opskip_off
# - Do not attach it to any event!
#
# This procedure is executed when the Optional skip command is activated.
#
   global mom_sys_opskip_block_leader
   MOM_set_line_leader off  $mom_sys_opskip_block_leader
}


#=============================================================
proc PB_CMD_MOM_opskip_on { } {
#=============================================================
# Default handler for UDE MOM_opskip_on
# - Do not attach it to any event!
#
# This procedure is executed when the Optional skip command is activated.
#
   global mom_sys_opskip_block_leader
   MOM_set_line_leader always  $mom_sys_opskip_block_leader
}


#=============================================================
proc PB_CMD_MOM_pprint { } {
#=============================================================
# Default handler for UDE MOM_pprint
# - Do not attach it to any event!
#
# This procedure is executed when the PPrint command is activated.
#
   global mom_pprint_defined

   if { [info exists mom_pprint_defined] } {
      if { $mom_pprint_defined == 0 } {
return
      }
   }

   PPRINT_OUTPUT
}


#=============================================================
proc PB_CMD_MOM_rotate { } {
#=============================================================
# Default handler for UDE MOM_rotate
# - Do not attach it to any event!
#

## <rws 04-11-2008>
## If in TURN mode and user invokes "Flip tool aorund Holder" a MOM_rotate event is generated
## When this happens ABORT this event via return
##

   global mom_machine_mode


   if { [info exists mom_machine_mode] && [string match "TURN" $mom_machine_mode] } {
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
            if { ![string compare "5_axis_head_table" $mom_kin_machine_type] || ![string compare "5_AXIS_HEAD_TABLE" $mom_kin_machine_type] } {
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
      global mom_warning_info
      set mom_warning_info "Invalid rotary axis"
      MOM_catch_warning
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
         set mom_out_angle_pos($a) [ROTSET $ang $prev_angles(0) $mom_kin_4th_axis_direction \
                                           $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis) \
                                           $mom_kin_4th_axis_min_limit $mom_kin_4th_axis_max_limit]
      } else {
         set mom_out_angle_pos($a) [ROTSET $ang $prev_angles(1) $mom_kin_5th_axis_direction \
                                           $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis) \
                                           $mom_kin_5th_axis_min_limit $mom_kin_5th_axis_max_limit]
      }


 #     if {$axis == 3} {set prot $prev_angles(0)}
 #     if {$axis == 4} {set prot $prev_angles(1)}
 #     if {$dir == 1 && $mom_out_angle_pos($a) < $prot} {
 #        set mom_out_angle_pos($a) [expr $mom_out_angle_pos($a) + 360.0]
 #     } elseif {$dir == -1 && $mom_out_angle_pos($a) > $prot} {
 #        set mom_out_angle_pos($a) [expr $mom_out_angle_pos($a) - 360.0]
 #     }


   } elseif { [string match "SIGN_DETERMINES_DIRECTION" $dirtype] } {

      if { $dir == -1 } {
         if { $axis == 3 } {
            set mom_sys_leader(fourth_axis) $mom_kin_4th_axis_leader-
         } else {
            set mom_sys_leader(fifth_axis) $mom_kin_5th_axis_leader-
         }
      } elseif { $dir == 0 } {
         if { $axis == 3 } {
            set mom_out_angle_pos($a) [ROTSET $ang $prev_angles(0) $mom_kin_4th_axis_direction \
                                              $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis) \
                                              $mom_kin_4th_axis_min_limit $mom_kin_4th_axis_max_limit]
         } else {
            set mom_out_angle_pos($a) [ROTSET $ang $prev_angles(1) $mom_kin_5th_axis_direction \
                                              $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis) \
                                              $mom_kin_5th_axis_min_limit $mom_kin_5th_axis_max_limit]
         }
      } elseif { $dir == 1 } {
         set mom_out_angle_pos($a) $ang
      }
   }


#<03-02-09 gsl> What's the logic here?
if 1 {
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
   set mom_prev_pos($axis) $ang
   MOM_reload_variable -a mom_prev_pos
   MOM_reload_variable -a mom_out_angle_pos
}


#=============================================================
proc PB_CMD_MOM_text { } {
#=============================================================
# Default handler for UDE MOM_text
# - Do not attach it to any event!
#
# This procedure is executed when the Text command is activated.
#
   global mom_user_defined_text mom_record_fields
   global mom_sys_control_out mom_sys_control_in
   global mom_record_text mom_pprint set mom_Instruction mom_operator_message
   global mom_pprint_defined mom_operator_message_defined

   switch $mom_record_fields(0) {
   "PPRINT"
         {
           set mom_pprint_defined 1
           set mom_pprint $mom_record_text
           MOM_pprint
         }
   "INSERT"
         {
           set mom_Instruction $mom_record_text
           MOM_insert
         }
   "DISPLY"
         {
           set mom_operator_message_defined 1
           set mom_operator_message $mom_record_text
           MOM_operator_message
         }
   default
         {
           if {[info exists mom_user_defined_text]} {
             MOM_output_literal "${mom_sys_control_out}${mom_user_defined_text}${mom_sys_control_in}"
           }
         }
   }
}


#=============================================================
proc PB_CMD_UDE_datum_setting { } {
#=============================================================
  global mom_sys_in_operation
  global dpp_TNC_datum_ude_defined

  if { [info exists mom_sys_in_operation] && $mom_sys_in_operation == 1} {
     MOM_output_to_listing_device "Datum output UDE should be used on the operation group level!"
     MOM_abort
  }
  if { [info exists dpp_TNC_datum_ude_defined] && $dpp_TNC_datum_ude_defined == 1} {
     MOM_output_to_listing_device "Datum output UDE could only be used for once!"
     MOM_abort
  } else {
     set dpp_TNC_datum_ude_defined 1
  }
}


#=============================================================
proc PB_CMD__check_block_CYCL_202 { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_itnc_bore_q214


   if {![info exists mom_itnc_bore_q214]} {
      set mom_itnc_bore_q214 1
   }






 return 1


}


#=============================================================
proc PB_CMD__check_block_begin_program { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_user_output_unit
   global mom_output_file_basename
   global mom_part_name
   global mom_oper_program
   global file_name
   global mom_output_unit
   global mom_user_output_unit

   if {[info exists mom_output_file_basename] && $mom_output_file_basename != ""} {
      set file_name [string toupper $mom_output_file_basename]
   } else {
      if { [string first "\.prt" $mom_part_name] == -1} { ;#Part name in TeamCenter enviorment
         set l [string length $mom_part_name]
         set f [string first "PN=" $mom_part_name]
         set file_name [string range $mom_part_name $f $l]

         set s [expr [string first " " $file_name] -1]
         set file_name [string range $file_name 3 $s]
         if { [string index $file_name 0] == "\""} {
            set l [string length $file_name]
            set file_name [string range $file_name 1 $l]
         } else { ;#In other else cases, uses the operation group name as program name.
            set file_name $mom_oper_program
         }
         set file_name [string toupper $file_name]
      } else {
         regsub "\.prt" [file tail $mom_part_name] "" file_name
         set file_name [string toupper $file_name]
      }
   }

   switch $mom_output_unit {
      IN {
         set mom_user_output_unit INCH
      }
      MM {
         set mom_user_output_unit MM
      }
   }

 return 1

}


#=============================================================
proc PB_CMD__check_block_cycle_rapid_to { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global dpp_cycle_plane_real_change

if {[info exists dpp_cycle_plane_real_change] && $dpp_cycle_plane_real_change == 1} {
   set dpp_cycle_plane_real_change 0
return 0
}
return 1


}


#=============================================================
proc PB_CMD__check_block_cycle_rapidtoZ { } {
#=============================================================
# This custom command should return
#   1 : Output block
#   0 : No output
# 07-May-15 Jintao - fix PR7162261 and PTP/Hole making issues

  global mom_prev_pos
  global mom_tool_axis
  global mom_operation_type
  global mom_cycle_retract_to
  global mom_cycle_clearance_pos
  global mom_cycle_retract_mode

  if { [info exists mom_cycle_retract_mode] && [string match "AUTO" $mom_cycle_retract_mode] } {
     return 0
  }
  if { [string match "Point to Point" $mom_operation_type] ||\
       [string match "Hole Making" $mom_operation_type] } {
     VEC3_scale mom_cycle_retract_to mom_tool_axis retract_to_pos
     VEC3_add mom_prev_pos retract_to_pos retract_to_pos
     VEC3_sub mom_cycle_clearance_pos retract_to_pos delta_vec
     set dist [VEC3_dot delta_vec mom_tool_axis]
     if { [EQ_is_gt $dist 0.0] } {
        return 1
     } else {
        return 0
     }
  } else {
     return 0
  }

}


#=============================================================
proc PB_CMD__check_block_datum_shift { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global pop_datum_shift

   if {[info exists pop_datum_shift] && $pop_datum_shift == 1} {
 return 1
   } else {
 return 0
   }


}


#=============================================================
proc PB_CMD__check_block_output_m128 { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

  global mom_logname
  global mom_pos mom_mcs_goto
  global mom_kin_machine_type
  global mom_mcs_goto mom_pos
  global mom_prev_mcs_goto mom_prev_pos
  global mom_arc_center mom_pos_arc_center
  global mom_kin_arc_output_mode
  global mom_kin_helical_arc_output_mode
  global dpp_ge


  if { $dpp_ge(toolpath_axis_num)=="5" } {
     MOM_force Once fourth_axis fifth_axis
     VMOV 3 mom_mcs_goto mom_pos
     VMOV 3 mom_prev_mcs_goto mom_prev_pos
     VMOV 3 mom_arc_center mom_pos_arc_center
     set mom_kin_arc_output_mode "LINEAR"
     set mom_kin_helical_arc_output_mode "LINEAR"
     MOM_reload_kinematics
return 1
  } else {
return 0
  }
}


#=============================================================
proc PB_CMD__check_block_plane_spatial { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output
   global seq
   global mom_out_angle_pos
   global dpp_ge

   if { $dpp_ge(toolpath_axis_num)=="5" } {
return 0
   }


   if {[EQ_is_lt $mom_out_angle_pos(0) 0]} {
      set seq "SEQ-"
   } else {
      set seq "SEQ+"
   }

   if { $dpp_ge(coord_rot) != "NONE" } {
#<lili 2014-11-24> add following block CREATE to avoid wrong modal rotary axes
      MOM_do_template rapid_rotary CREATE
      MOM_disable_address fourth_axis fifth_axis
      MOM_force Once X Y Z
return 1
   } else {
return 0
   }
}


#=============================================================
proc PB_CMD__check_block_rapid_rotary { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global dpp_ge


   if { $dpp_ge(toolpath_axis_num)=="5" } {
      MOM_enable_address fourth_axis fifth_axis
return 1
   } else {
return 0
   }


}


#=============================================================
proc PB_CMD__check_block_return_home { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_next_oper_has_tool_change
   global mom_current_oper_is_last_oper_in_program

   if {([info exists mom_next_oper_has_tool_change] && $mom_next_oper_has_tool_change == "YES") || \
       ([info exists mom_current_oper_is_last_oper_in_program] && $mom_current_oper_is_last_oper_in_program == "YES")} {
 return 1
   } else {
 return 0
   }



}


#=============================================================
proc PB_CMD__check_block_return_to_reference_point { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

  global mom_next_oper_has_tool_change
  global mom_current_oper_is_last_oper_in_program
  global mom_pos mom_prev_pos
  global mom_out_angle_pos
  global mom_prev_out_angle_pos
   if {([info exists mom_next_oper_has_tool_change] && $mom_next_oper_has_tool_change == "YES") || ([info exists mom_current_oper_is_last_oper_in_program] && $mom_current_oper_is_last_oper_in_program == "YES")} {

     set mom_prev_pos(3) 0
     set mom_prev_pos(4) 0

     set mom_pos(3) 0.0
     set mom_pos(4) 0.0

     set mom_out_angle_pos(0) 0.0
     set mom_out_angle_pos(1) 0.0

     set mom_prev_out_angle_pos(0) 0.0
     set mom_prev_out_angle_pos(1) 0.0

     MOM_reload_variable -a mom_pos
     MOM_reload_variable -a mom_prev_pos
     MOM_reload_variable -a mom_out_angle_pos
     MOM_reload_variable -a mom_prev_out_angle_pos

     return 1
  } else {
     return 0
  }

}


#=============================================================
proc PB_CMD__check_block_rotary_axes { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_output_mode_define


   if {[info exists mom_output_mode_define] && $mom_output_mode_define != "ROTARY AXES" } {
return 0
   } else {
return 1
   }


}


#=============================================================
proc PB_CMD__check_block_tap_cycle { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output


   global mom_logname
   global mom_motion_event

   if { ![string compare "tap_move" $mom_motion_event] ||\
        ![string compare "tap_deep_move" $mom_motion_event] ||\
        ![string compare "tap_break_chip_move" $mom_motion_event] } {
      return 1
   } else {
      return 0
   }

}


#=============================================================
proc PB_CMD__check_block_tool_preselect { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_next_tool_status

   if {[info exists mom_next_tool_status] && $mom_next_tool_status == "NEXT"} {
 return 1
   }
 return 0

}


#=============================================================
proc PB_CMD__check_block_vector { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_output_mode_cmd
   global mom_output_mode_define
   global mom_contact_status



   if {[info exists mom_output_mode_define] && $mom_output_mode_define != "ROTARY AXES"} {

      # Output contact points
      if { [info exists mom_contact_status] && $mom_contact_status == "ON" } {
         if { [info exists mom_contact_point] } {
            VMOV 3 mom_contact_point mom_pos
         }
         MOM_force Once NX NY NZ
      } else {
         MOM_suppress Once NX NY NZ
      }
 return 1
   } else {
 return 0
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
proc PB_CMD__define_debug_msg { } {
#=============================================================
# This special command can be executed at Start of Program to facilitate
# the debugging capability of posts created by Post Builder.
# ==> DO NOT add or call it in any event or command!
# ==> DO NOT change its name!
#
# => Variable "PB_POST__debug" can be set true (1) to activate debug.
#
# => Signature of PB_POST__debug_msg { args } command should not be changed.
#    Calls to this command are embedded in all handlers generated by Post Builder.
#    *** Do Not call it in any before-output commands!!!
#    *** Do Not use it in utility commands e.g. CALLED_BY
#    This command can be called in other custom commands for debugging purpose.
#
# => Contents of debug messages (below) can be configured as desired by the users.
#
#-------------------------------------------------------------
# 01-17-2014 gsl - Initial version (v902)
#
#  ||||||||||||||||||||
#  VVVVVVVVVVVVVVVVVVVV
   set PB_POST__debug 0

   if $PB_POST__debug {
     uplevel #0 {
      proc PB_POST__debug_msg { args } {

         MOM_output_literal ">>> in [info level -1] - [join $args]"

        #+++++++++++++++++++++++++++++++++++++++++++++++++++
        # Configure the details of variables to be observed
        #
         if [info exists ::mom_out_angle_pos(1)] {
            MOM_output_literal ">>>>> mom_out_angle_pos(1): $::mom_out_angle_pos(1)"
         }
        #+++++++++++++++++++++++++++++++++++++++++++++++++++
      }
     }
   } else {
     uplevel #0 {
      proc PB_POST__debug_msg { args } {}
     }
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

   global mom_sys_abort_next_event

   if { [info exists mom_sys_abort_next_event] } {

      switch $mom_sys_abort_next_event {
         1 -
         2 {
            unset mom_sys_abort_next_event
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
proc PB_CMD_after_rapid { } {
#=============================================================
# <02-28-08 gsl>
# Post-process rapid move handler
#
# - This command should be used in conjunction with
#   PB_CMD_before_rapid.
#
# 08-18-10 gsl - Added use of mom_sys_before_rapid_handled to verify
#                if PB_CMD_before_rapid has been called beforehand.

   global mom_sys_before_rapid_handled
   if { ![info exists mom_sys_before_rapid_handled] } {
return
   }

   global mom_motion_type

   switch $mom_motion_type {
      "DEPARTURE" -
      "RETURN" -
      "GOHOME" -
      "GOHOME_DEFAULT" {
         MOM_do_template rapid_rotary
      }
   }

   unset mom_sys_before_rapid_handled
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
#=============================================================
# Pre-process before motion
#
# 06-18-13 Jason - Initial version

   global mom_pos mom_prev_pos
   global mom_mcs_goto mom_prev_mcs_goto
   global mom_arc_center mom_pos_arc_center
   global dpp_ge
   global mom_kin_arc_output_mode
   global mom_kin_helical_arc_output_mode
   global mom_out_angle_pos mom_kin_machine_type

   if { $dpp_ge(toolpath_axis_num)=="5" } {
      VMOV 3 mom_mcs_goto mom_pos
      VMOV 3 mom_prev_mcs_goto mom_prev_pos
      VMOV 3 mom_arc_center mom_pos_arc_center
      set mom_kin_arc_output_mode "LINEAR"
      set mom_kin_helical_arc_output_mode "LINEAR"
      MOM_reload_kinematics
   }

# 10-18-2013 Jason - Commented following codem to avoid wrong mom_out_angle_pos
   #if {[string match "5_axis_dual_head" $mom_kin_machine_type]} {
   #   set mom_out_angle_pos(0) [LIMIT_ANGLE $mom_out_angle_pos(0)]
   #} else {
   #   set mom_out_angle_pos(1) [LIMIT_ANGLE $mom_out_angle_pos(1)]
   #}
}


#=============================================================
proc PB_CMD_before_output { } {
#=============================================================
# This command allows users to massage the NC code (mom_o_buffer) before
# it gets output.  If present in the post, this command is executed
# automatically by MOM_before_output.
#
# - DO NOT overload "MOM_before_output", all customization must be done here!
# - DO NOT call any MOM output commands here, it will become cyclicle!
# - DO NOT attach this command to any event marker!
#

   global mom_o_buffer
   global mom_sys_leader
   global mom_sys_control_out mom_sys_control_in

   set buff $mom_o_buffer

  # Remove trailing in-line comment
   if 0 {
       set i_at [string first "$mom_sys_control_out" $buff]
       if { $i_at > -1 } {
          set buff [string trimright [string range $buff 0 [expr $i_at - 1]]]
       }
   }

  # Process to avoid output of block buffer without any useful address
   regsub -all {[0-9]+} $buff "" buff
   regsub -all {L} $buff "" buff
   regsub -all {F} $buff "" buff
   regsub -all {MAX} $buff "" buff
   regsub -all { } $buff "" buff

   set buff [join $buff ""]
   set l [string length $buff]
   if { $l == 0 } {
      set mom_o_buffer ""
   }
}


#=============================================================
proc PB_CMD_before_rapid { } {
#=============================================================
# <02-28-08 gsl>
# Pre-process rapid move handler
#
# - Rapid motion block(s) should be constructed without rotary axes.
# - This command should be used in conjunction with PB_CMD_after_rapid.
# - This command can be used for rapid motion with or without work plane change.
#
# 08-18-10 gsl - Added use of mom_sys_before_rapid_handled to signal
#                when PB_CMD_before_rapid has been called.
#

   global mom_motion_type mom_motion_event

   if { [string match "initial_move" $mom_motion_event] ||\
        [string match "rapid_move"   $mom_motion_event] ||\
        [string match "first_move"   $mom_motion_event] ||\
        [string match "FROM"         $mom_motion_type]  ||\
        [string match "APPROACH"     $mom_motion_type] } {

     # MOM_do_template rapid_rotary

      if [CMD_EXIST PB_CMD_define_work_plane] {

        # Force output of M128 blocks
         if { [string match "initial_move" $mom_motion_event] } {
            global mom_out_angle_pos mom_prev_out_angle_pos
            set mom_prev_out_angle_pos(0) -939
         }

         PB_CMD_define_work_plane
      }
   }

   global mom_sys_before_rapid_handled
   set mom_sys_before_rapid_handled 1
}


#=============================================================
proc PB_CMD_check_plane_change_in_rapid_move { } {
#=============================================================
#=============================================================
# Check for the tool axis change during rapid move using AUTO_3D function
#
# 06-18-2012 Jason - Initial version
# 10-18-2013 Jason - Behavior change: table axis will not return to zero if the tool vector turn to be along Z axis in rapid move.

  global mom_kin_machine_type
  global save_mom_kin_machine_type
  global mom_pos mom_mcs_goto
  global mom_cycle_spindle_axis
  global dpp_ge
  global seq
  global mom_out_angle_pos mom_prev_out_angle_pos
  global coord_rot_angle
  global dpp_TNC_plane_change_in_rapid ;#This variable is used to record the plane change status in rapid move.
  global mom_result
  global mom_tool_axis

  if { ![string match "*5_axis*" $mom_kin_machine_type] } {
return
  }

  if { $dpp_ge(toolpath_axis_num)=="5" } {
return
  }

  set dpp_ge(coord_rot) [DPP_GE_COOR_ROT "ZYX" coord_rot_angle coord_offset pos]

  if { $dpp_ge(coord_rot) == "NONE" } {
     if {![info exists mom_prev_out_angle_pos(0)] || ![info exists mom_prev_out_angle_pos(1)]} {
return
     }

     if {![EQ_is_equal $mom_out_angle_pos(0) $mom_prev_out_angle_pos(0)] || ![EQ_is_equal $mom_out_angle_pos(1) $mom_prev_out_angle_pos(1)]} {
        MOM_output_literal "PLANE RESET STAY"

        # if it's not auto3d condition, restore the kinematics and recalculate mom_pos
        DPP_GE_RESTORE_KINEMATICS

        if {"1" == [MOM_convert_point mom_mcs_goto mom_tool_axis]} {
           set i 0
           foreach value $mom_result {
              set mom_pos($i) $value
              incr i
           }
        }

        MOM_reload_variable -a mom_pos
        MOM_force Once fourth_axis fifth_axis
        MOM_enable_address fourth_axis fifth_axis
        MOM_force Once fourth_axis fifth_axis
        MOM_do_template rapid_rotary
     }
return
  }
  if {![EQ_is_equal $dpp_ge(prev_coord_rot_angle,0)  $coord_rot_angle(2)] || ![EQ_is_equal $dpp_ge(prev_coord_rot_angle,1)  $coord_rot_angle(1)] || ![EQ_is_equal $dpp_ge(prev_coord_rot_angle,2)  $coord_rot_angle(0)]} {
     set dpp_ge(coord_rot_angle,0) $coord_rot_angle(2)
     set dpp_ge(coord_rot_angle,1) $coord_rot_angle(1)
     set dpp_ge(coord_rot_angle,2) $coord_rot_angle(0)
     set dpp_ge(prev_coord_rot_angle,0)  $coord_rot_angle(2)
     set dpp_ge(prev_coord_rot_angle,1)  $coord_rot_angle(1)
     set dpp_ge(prev_coord_rot_angle,2)  $coord_rot_angle(0)
     VMOV 3  pos mom_pos

     if {[EQ_is_lt $mom_out_angle_pos(0) 0]} {
           set seq "SEQ-"
     } else {
           set seq "SEQ+"
     }
     MOM_do_template plane_spatial_move
     MOM_disable_address fourth_axis fifth_axis

     set dpp_TNC_plane_change_in_rapid 1
  }

}


#=============================================================
proc PB_CMD_clamp_fifth_axis { } {
#=============================================================
#  This command is used by auto clamping to output the code
#  needed to clamp the fifth axis.
#
#  --> Do NOT attach this command to any event marker!
#  --> Do NOT change the name of this command!
#
   MOM_output_literal "M12"
}


#=============================================================
proc PB_CMD_clamp_fourth_axis { } {
#=============================================================
#  This command is used by auto clamping to output the code
#  needed to clamp the fourth axis.
#
#  --> Do NOT attach this command to any event marker!
#  --> Do NOT change the name of this command!
#
   MOM_output_literal "M10"
}


#=============================================================
proc PB_CMD_clearance_plane_change { } {
#=============================================================
# Deal with the clearance plane change conditions.
#
# 06-18-2013 Jason - Initial version
# 05-07-2015 Jintao -  PR7162261,add PB_CMD__check_block_cycle_rapidtoZ


  global mom_cycle_retract_mode mom_cycle_rapid_to_pos mom_pos
  global mom_cycle_clearance_plane_change
  global mom_cycle_tool_axis_change
  global cycle_init_flag
  global dpp_cycle_plane_real_change
  global dpp_ge

  if { [PB_CMD__check_block_cycle_rapidtoZ] && $mom_cycle_tool_axis_change == 0 } {
     MOM_force Once  G_motion
     MOM_do_template cycle_rapidtoZ
  }
  MOM_abort_event

}


#=============================================================
proc PB_CMD_config_cycle_start { } {
#=============================================================

}


#=============================================================
proc PB_CMD_custom_command { } {
#=============================================================
  global mom_ude_feed_definition
  global mom_ude_feed_cutting_var
  global mom_ude_feed_engage_var
  global mom_ude_feed_retract_var
}


#=============================================================
proc PB_CMD_customize_output_mode { } {
#=============================================================
# This custom command is used to initialize some customize mode/value used in TNC controller;
# param mom_ude_datum_option
  # Descrptions: Define the default datum output style in case no datum output UDE is defined.
  # Entries:
     # CYCL 7 XYZ:     CYCL 7 + fixture origin coordinate value.
     # CYCL 7 #:       CYCL 7# + fixture offset value.
     # CYCL 247:       CYCL 247 + fixture offset value.
     # NONE:           No datum shift output.

# param mom_sys_leader(home_?_var)
  # Descrptions: Define the Q parameter to represent the numerical value of home position.
  # The Q value could be customized.

# param dpp_TNC_m128_feed_value
  # Descrptions: Define the default feedrate value of M128 TCP motion.

# 06-18-2013 Jason - Initial version

  global mom_ude_datum_option
  set mom_ude_datum_option "CYCL 7 XYZ"

  global mom_sys_leader

  set mom_sys_leader(home_x_var) "Q501"
  set mom_sys_leader(home_y_var) "Q502"
  set mom_sys_leader(home_z_var) "Q503"

  global dpp_TNC_m128_feed_value
  set dpp_TNC_m128_feed_value 1000

}


#=============================================================
proc PB_CMD_cycle_coord_rotation { } {
#=============================================================
#=============================================================
# Handle variable-axis drilling cycles using AUTO_3D function
#
#06-18-2012 Jason - Initial version
#10-18-2013 Jason - Behavior change: table axis will not return to zero if the tool vector turn to be along Z axis in cycle plane change.

  global mom_kin_machine_type
  global save_mom_kin_machine_type
  global mom_tool_axis mom_tool_axis_type
  global mom_5axis_control_pos
  global mom_pos mom_mcs_goto
  global mom_prev_out_angle_pos mom_out_angle_pos
  global mom_prev_tool_axis
  global mom_cycle_rapid_to_pos mom_cycle_retract_to_pos mom_cycle_feed_to_pos
  global mom_cycle_rapid_to mom_cycle_retract_to mom_cycle_feed_to
  global mom_cycle_spindle_axis
  global mom_kin_machine_type
  global mom_cycle_retract_mode
  global js_return_pos js_prev_pos
  global dpp_ge
  global dpp_cycle_plane_real_change
  global seq
  global mom_out_angle_pos
  global dpp_TNC_plane_change_in_rapid
  global coord_rot_angle
  global mom_result
  global mom_kin_machine_type


  if { ![string match "*5_axis*" $mom_kin_machine_type] } {
return
  }

  set dpp_ge(coord_rot) [DPP_GE_COOR_ROT "ZYX" coord_rot_angle coord_offset pos]

  if { $dpp_ge(coord_rot) == "NONE" } {
     if {![EQ_is_equal $mom_out_angle_pos(0) $mom_prev_out_angle_pos(0)] || ![EQ_is_equal $mom_out_angle_pos(1) $mom_prev_out_angle_pos(1)]} {
        MOM_output_literal "PLANE RESET STAY"

        # if it's not auto3d condition, restore the kinematics and recalculate mom_pos
        DPP_GE_RESTORE_KINEMATICS
        if {"1" == [MOM_convert_point mom_mcs_goto mom_tool_axis]} {
           set i 0
           foreach value $mom_result {
                 set mom_pos($i) $value
                 incr i
           }
        }

        VMOV 3 mom_pos mom_cycle_feed_to_pos
        MOM_reload_variable -a mom_cycle_feed_to_pos
        MOM_reload_variable -a mom_pos

        MOM_enable_address fourth_axis fifth_axis
        MOM_force Once fourth_axis fifth_axis
        MOM_do_template rapid_rotary
     }
return
  }

  if { $dpp_ge(coord_rot) == "LOCAL_CSYS" } {
     if { ![EQ_is_equal $mom_tool_axis(2) 1.0] } {
        MOM_output_to_listing_device "Warning in $mom_operation_name: Wrong Local MCS, Z axis is not parallel to tool axis vector."
       }
return
  }

  if {![EQ_is_equal $dpp_ge(prev_coord_rot_angle,0)  $coord_rot_angle(2)] || ![EQ_is_equal $dpp_ge(prev_coord_rot_angle,1)  $coord_rot_angle(1)] || ![EQ_is_equal $dpp_ge(prev_coord_rot_angle,2)  $coord_rot_angle(0)]} {
     set dpp_cycle_plane_real_change 1
     set dpp_ge(coord_rot_angle,0) $coord_rot_angle(2)
     set dpp_ge(coord_rot_angle,1) $coord_rot_angle(1)
     set dpp_ge(coord_rot_angle,2) $coord_rot_angle(0)
     set dpp_ge(prev_coord_rot_angle,0)  $coord_rot_angle(2)
     set dpp_ge(prev_coord_rot_angle,1)  $coord_rot_angle(1)
     set dpp_ge(prev_coord_rot_angle,2)  $coord_rot_angle(0)
     VMOV 3  pos mom_pos
  } else {
     set dpp_cycle_plane_real_change 0
  }

  if {$dpp_cycle_plane_real_change ==1} {

     set mom_cycle_spindle_axis 2

     if {[EQ_is_lt $mom_out_angle_pos(0) 0]} {
        set seq "SEQ-"
     } else {
        set seq "SEQ+"
     }

     MOM_do_template plane_spatial_move
     MOM_disable_address fourth_axis fifth_axis
  }

  if { $dpp_cycle_plane_real_change ==1 || $dpp_TNC_plane_change_in_rapid ==1 } {
     if { [string match "AUTO" $mom_cycle_retract_mode] } {
        set js_return_pos [expr $js_prev_pos - $mom_pos(2)] ;# calc incr retract
        if { [EQ_is_lt $js_return_pos $mom_cycle_retract_to] } {
           set js_return_pos $mom_cycle_retract_to
        }
     } else {
       set js_return_pos $mom_cycle_retract_to
     }

     VMOV 3 mom_pos mom_cycle_rapid_to_pos
     VMOV 3 mom_pos mom_cycle_feed_to_pos
     VMOV 3 mom_pos mom_cycle_retract_to_pos
     set mom_cycle_rapid_to_pos(2) [expr $mom_pos(2)+$js_return_pos]
     set mom_cycle_retract_to_pos(2) [expr $mom_pos(2)+$mom_cycle_retract_to]
     set mom_cycle_feed_to_pos(2) [expr $mom_pos(2)+$mom_cycle_feed_to]

     set mom_pos(0) [format %.4f "$mom_pos(0)"]
     set mom_pos(1) [format %.4f "$mom_pos(1)"]
     set mom_cycle_rapid_to_pos(2) [format %.4f "$mom_cycle_rapid_to_pos(2)"]

     MOM_force Once X Y Z
     MOM_output_literal "L X$mom_pos(0) Y$mom_pos(1) Z$mom_cycle_rapid_to_pos(2) R0 FMAX"
  }
}


#=============================================================
proc PB_CMD_cycle_plane_change { } {
#=============================================================
# plane change happens when drilling operation goes uphill
# ie - when new hole is higher in Z than prev hole
# retract mode AUTO is return to clearance plane using
# Q204 ( which is like G98 ) so this next bit is only for
# case where cycles stay down

return

   global mom_cycle_retract_mode mom_cycle_rapid_to_pos mom_pos

   if { ![string match "AUTO" $mom_cycle_retract_mode] } {

      MOM_force Once  G_motion     ;# not sure why i need this
      MOM_do_template cycle_rapidtoZ
   }

   MOM_force Once X Y
}


#=============================================================
proc PB_CMD_define_feed_value { } {
#=============================================================
#This command is used to get feed value and define feed rate in variables.
#and PB_CMD_define_feedrate_format which is called from PB_CMD_before_motion.
  global mom_user_feed_value
  global mom_seqnum
  global mom_ude_feed_definition
  global flag
  global mom_current_motion

  if { [info exists mom_ude_feed_definition] && $mom_ude_feed_definition == "ON" } {
     PB_CMD_get_feed_value
     if {[string match $mom_current_motion "initial_move"]} {
        MOM_force Once feed_cut feed_engage feed_retract
     }
     if {![info exists flag(feed_var)]} {
        MOM_do_template feedrate_cut_define
        MOM_do_template feedrate_engage_define
        MOM_do_template feedrate_retract_define
        set flag(feed_var) 1
     } else {
        MOM_do_template feedrate_cut
        MOM_do_template feedrate_engage
        MOM_do_template feedrate_retract
     }
  }
}


#=============================================================
proc PB_CMD_define_feedrate_format { } {
#=============================================================
# This command is used to redefine feedrate output format as string and record feedrate
# value.
# Using mom_sinumerik_feed instead of feed for output in NX7.0. feed cannot be set to a
# string value.
  global mom_ude_feed_definition
  global mom_user_feed_var_num
  global mom_user_feed
  global feed
  global mom_motion_type
  global mom_ude_feed_cut_var
  global mom_ude_feed_engage_var
  global mom_ude_feed_retract_var

  # Feedrate definition in variable
  if {[info exists mom_ude_feed_definition] && $mom_ude_feed_definition == "ON"} {
     MOM_set_address_format F String
     set motion_type [string tolower $mom_motion_type]
     switch $motion_type {
        "cut" -
        "firstcut" -
        "stepover" { set mom_user_feed $mom_ude_feed_cut_var}
        "engage" { set mom_user_feed $mom_ude_feed_engage_var}
        "retract" { set mom_user_feed $mom_ude_feed_retract_var}
        default {
           # set mom_sinumerik_feed 0
           #MOM_set_address_format F Feed
           set mom_user_feed "MAX"
           MOM_force Once F
        }
     }
  }


}


#=============================================================
proc PB_CMD_define_fixture_csys { } {
#=============================================================
# This command is used to define the fixture coordinate system
# Three output styles are supported: cycle 7, cycle 7# and cycle 247
#
# 06-18-2013 Jason - Initial version

  global mom_ude_datum_option
  global IX IY IZ
  global mom_kin_coordinate_system_type
  global mom_fixture_offset_value
  global saved_mom_fixture_offset_value
  global dpp_TNC_local_offset_flag
  global dpp_TNC_reset_last_local_offset
  global dpp_TNC_fixture_origin ;#Fixture origin is calculated in PB_CMD_set_csys
  global dpp_ge

  if { $dpp_TNC_local_offset_flag == 0 && $dpp_TNC_reset_last_local_offset == 0 } {
     if {[info exists saved_mom_fixture_offset_value] && $mom_fixture_offset_value == $saved_mom_fixture_offset_value} {
return
     }
  }

  if { $dpp_TNC_local_offset_flag == 1 && $dpp_TNC_reset_last_local_offset == 0 } {
return
  }

#Cancel previous datum shift in local csys offset situation
  if {[info exists saved_mom_fixture_offset_value] && $dpp_TNC_reset_last_local_offset == 1} {
     MOM_output_literal "CYCL DEF 7.0"
     MOM_output_literal "CYCL DEF 7.1 X+0.0"
     MOM_output_literal "CYCL DEF 7.2 Y+0.0"
     MOM_output_literal "CYCL DEF 7.3 Z+0.0"
  }

  set IX X; set IY Y; set IZ Z
  if {[info exists mom_ude_datum_option]} {
     switch $mom_ude_datum_option {
        "CYCL 7 #" {
            MOM_output_literal "CYCL DEF 7.0"
            MOM_output_literal "CYCL DEF 7.1 \#$mom_fixture_offset_value"
            set IX IX; set IY IY; set IZ IZ
        }
        "CYCL 7 XYZ" {
            if {[info exists mom_kin_coordinate_system_type] && $mom_kin_coordinate_system_type != "MAIN"} {
            MOM_output_literal "CYCL DEF 7.0"
            MOM_output_literal "CYCL DEF 7.1 X$dpp_TNC_fixture_origin(0)"
            MOM_output_literal "CYCL DEF 7.2 Y$dpp_TNC_fixture_origin(1)"
            MOM_output_literal "CYCL DEF 7.3 Z$dpp_TNC_fixture_origin(2)"
            set IX IX; set IY IY; set IZ IZ
            }
        }
        "CYCL 247" {
            MOM_output_literal "CYCL DEF 247 Q339=$mom_fixture_offset_value"
            set IX X; set IY Y; set IZ Z
        }
        default {
           unset mom_ude_datum_option
        }
     }
  }

  set saved_mom_fixture_offset_value $mom_fixture_offset_value


}


#=============================================================
proc PB_CMD_define_work_plane { } {
#=============================================================
   global mom_operation_type
   global mom_5axis_control_mode
   global mom_5axis_control_pos

   global mom_sys_work_plane_change



   if { ![info exists mom_5axis_control_mode] } {
      set mom_5axis_control_mode "AUTO"
      set mom_5axis_control_pos 1
   }


   if { [string match "AUTO" $mom_5axis_control_mode] } {

     #<02-26-08 gsl> Logic here may not be robust enough to cover machine with rotary head(s).
     #               - It may need to invlove machine type and tool axis vector.
      global mom_kin_machine_type
      global mom_tool_axis_type

      global TNC_output_mode
      if { [string match "M128" $TNC_output_mode] } {

         global mom_out_angle_pos last_B last_C
         global mom_prev_out_angle_pos

         if { ![info exists mom_prev_out_angle_pos(0)] } {
            set mom_prev_out_angle_pos(0)    0
            set mom_prev_out_angle_pos(1)    0
         }

         if { ![EQ_is_equal $mom_out_angle_pos(0) $mom_prev_out_angle_pos(0)] ||\
              ![EQ_is_equal $mom_out_angle_pos(1) $mom_prev_out_angle_pos(1)] } {

           # M129
            MOM_do_template initial_move_1
            MOM_force once Z
            MOM_do_template return_home_z
            MOM_do_template rapid_rotary
           # M128
            MOM_force once G_motion
            MOM_do_template initial_move_4
         }

        #<02-28-08 gsl> Disable work plane change for M128 mode
         set mom_sys_work_plane_change 0

      } else {

        #<02-21-08 gsl> Fake machine type for CYCL19
         global mom_user_default_machine_type mom_kin_machine_type
         global mom_kin_4th_axis_type mom_kin_5th_axis_type
         set mom_user_default_machine_type $mom_kin_machine_type

        # set mom_kin_machine_type "5_axis_dual_table"
        # set mom_kin_4th_axis_type                     "Table"
        # set mom_kin_5th_axis_type                     "Table"

         MOM_reload_kinematics


         global mom_out_angle_pos last_B last_C
         global mom_prev_out_angle_pos

         set ang_C    [format %.3f "$mom_out_angle_pos(0)"]
         set ang_A    [format %.3f "$mom_out_angle_pos(1)"]

        #>>>
         if { ![info exists mom_prev_out_angle_pos(0)] } {
            set mom_prev_out_angle_pos(0)    0
            set mom_prev_out_angle_pos(1)    0

            MOM_do_template cycl_def_19_0
            MOM_do_template cycl_def_19_1_null
            MOM_do_template return_home_z
            MOM_do_template return_home_xy
            MOM_output_literal ";"

            MOM_do_template rapid_rotary
            MOM_do_template cycl_def_19_0
            MOM_force Once fourth_axis fifth_axis
            MOM_do_template cycl_def_19_1
           # MOM_output_literal "L A+Q120 C+Q122 R0 FMAX"
            MOM_output_literal ";-------------------------------"

         } elseif { ![EQ_is_equal $mom_out_angle_pos(0) $mom_prev_out_angle_pos(0)] ||\
                    ![EQ_is_equal $mom_out_angle_pos(1) $mom_prev_out_angle_pos(1)] } {

            MOM_do_template cycl_def_19_0
            MOM_do_template cycl_def_19_1_null
            MOM_do_template return_home_z
            MOM_do_template return_home_xy
            MOM_output_literal ";"

            MOM_do_template rapid_rotary
            MOM_do_template cycl_def_19_0
            MOM_force Once fourth_axis fifth_axis
            MOM_do_template cycl_def_19_1
           # MOM_output_literal "L A+Q120 C+Q122 R0 FMAX"
            MOM_output_literal ";-------------------------------"
         }

         MOM_suppress Once fourth_axis fifth_axis
      }

   } else {

      global mom_5axis_control_pos
      if { $mom_5axis_control_pos } {

        #<02-21-08 gsl> Restore machine type after being faked for CYCL19
         global mom_user_default_machine_type mom_kin_machine_type
         global mom_kin_4th_axis_type mom_kin_5th_axis_type
         set mom_user_default_machine_type $mom_kin_machine_type
        # set mom_kin_machine_type "5_axis_dual_table"
        # set mom_kin_4th_axis_type                     "Table"
        # set mom_kin_5th_axis_type                     "Table"

         MOM_reload_kinematics


         global mom_out_angle_pos last_B last_C
         global mom_prev_out_angle_pos

         if { ![info exists mom_prev_out_angle_pos(0)] } {
            set mom_prev_out_angle_pos(0)    0
            set mom_prev_out_angle_pos(1)    0
         }

         set ang_C    [format %.3f "$mom_out_angle_pos(0)"]
         set ang_A    [format %.3f "$mom_out_angle_pos(1)"]

        #>>>

         if { ![EQ_is_equal $mom_out_angle_pos(0) $mom_prev_out_angle_pos(0)] ||\
              ![EQ_is_equal $mom_out_angle_pos(1) $mom_prev_out_angle_pos(1)] } {

            MOM_do_template cycl_def_19_0
            MOM_do_template cycl_def_19_1_null
            MOM_do_template return_home_z
            MOM_do_template return_home_xy
            MOM_output_literal ";"

            MOM_do_template rapid_rotary
            MOM_do_template cycl_def_19_0
            MOM_force Once fourth_axis fifth_axis
            MOM_do_template cycl_def_19_1
           # MOM_output_literal "L A+Q120 C+Q122 R0 FMAX"
            MOM_output_literal ";-------------------------------"
         }

        # MOM_suppress Once fourth_axis fifth_axis

      } else {

         global mom_out_angle_pos last_B last_C
         global mom_prev_out_angle_pos

         if { ![info exists mom_prev_out_angle_pos(0)] } {
            set mom_prev_out_angle_pos(0)    0
            set mom_prev_out_angle_pos(1)    0
         }

         if { ![EQ_is_equal $mom_out_angle_pos(0) $mom_prev_out_angle_pos(0)] ||\
              ![EQ_is_equal $mom_out_angle_pos(1) $mom_prev_out_angle_pos(1)] } {
           # M129
            MOM_do_template initial_move_1
            MOM_force once Z
            MOM_do_template return_home_z
            MOM_do_template rapid_rotary
           # M128
            MOM_do_template initial_move_4
         }

        #<02-28-08 gsl> Disable work plane change for M128 mode
         set mom_sys_work_plane_change 0
      }
   }
}


#=============================================================
proc PB_CMD_define_work_plane_cycle { } {
#=============================================================
   global mom_operation_type
   global mom_5axis_control_mode

   if { [string match "AUTO" $mom_5axis_control_mode] } {

      global mom_tool_axis_type
      global TNC_output_mode

      if { [string match "M128" $TNC_output_mode] } {

         global mom_out_angle_pos last_B last_C
         global mom_prev_out_angle_pos

         if { ![info exists mom_prev_out_angle_pos(0)] } {
             set mom_prev_out_angle_pos(0)    0
             set mom_prev_out_angle_pos(1)    0
         }

         set ang_C    [format %.3f "$mom_out_angle_pos(0)"]
         set ang_A    [format %.3f "$mom_out_angle_pos(1)"]

        #>>>

         if { ![EQ_is_equal $mom_out_angle_pos(0) $mom_prev_out_angle_pos(0)] ||\
              ![EQ_is_equal $mom_out_angle_pos(1) $mom_prev_out_angle_pos(1)] } {

            MOM_do_template cycl_def_19_0
            MOM_do_template cycl_def_19_1_null
           # MOM_do_template return_home_z
           # MOM_do_template return_home_xy
            MOM_output_literal ";"

            MOM_do_template rapid_rotary
            MOM_do_template cycl_def_19_0
            MOM_force Once fourth_axis fifth_axis
            MOM_do_template cycl_def_19_1
           # MOM_output_literal "L A+Q120 C+Q122 R0 FMAX"
            MOM_output_literal ";-------------------------------"
         }

         MOM_suppress Once fourth_axis fifth_axis
      }

   } else {

      global mom_5axis_control_pos

      if { $mom_5axis_control_pos } {
         global mom_out_angle_pos last_B last_C
         global mom_prev_out_angle_pos

         if { ![info exists mom_prev_out_angle_pos(0)] } {
            set mom_prev_out_angle_pos(0)    0
            set mom_prev_out_angle_pos(1)    0
         }

         set ang_C    [format %.3f "$mom_out_angle_pos(0)"]
         set ang_A    [format %.3f "$mom_out_angle_pos(1)"]

        #>>>

         if { ![EQ_is_equal $mom_out_angle_pos(0) $mom_prev_out_angle_pos(0)] ||\
              ![EQ_is_equal $mom_out_angle_pos(1) $mom_prev_out_angle_pos(1)] } {

            MOM_do_template cycl_def_19_0
            MOM_do_template cycl_def_19_1_null
            MOM_do_template return_home_z
            MOM_do_template return_home_xy
            MOM_output_literal ";"

            MOM_do_template rapid_rotary
            MOM_do_template cycl_def_19_0
            MOM_force Once fourth_axis fifth_axis
            MOM_do_template cycl_def_19_1
           # MOM_output_literal "L A+Q120 C+Q122 R0 FMAX"
            MOM_output_literal ";-------------------------------"
         }

         MOM_suppress Once fourth_axis fifth_axis
      }
   }
}


#=============================================================
proc PB_CMD_detect_csys_rotation { } {
#=============================================================
# This command is used to detect csys rotation type and clearance plane existing status.
# Used in initial move and first move
#
# 06-18-2013 Jason - Initial version

  global mom_motion_type
  global mom_current_motion
  global mom_pos
  global dpp_ge
  global dpp_TNC_Q203_pos
  global mom_cycle_rapid_to_pos mom_cycle_retract_to_pos mom_cycle_feed_to_pos
  global mom_cycle_rapid_to mom_cycle_retract_to mom_cycle_feed_to

  set dpp_ge(coord_rot) [DPP_GE_COOR_ROT "ZYX" coord_rot_angle coord_offset pos]
  if { $dpp_ge(coord_rot) !="NONE" } {

     set dpp_ge(coord_rot_angle,0) $coord_rot_angle(2)
     set dpp_ge(coord_rot_angle,1) $coord_rot_angle(1)
     set dpp_ge(coord_rot_angle,2) $coord_rot_angle(0)
     set dpp_ge(prev_coord_rot_angle,0)  $coord_rot_angle(2)
     set dpp_ge(prev_coord_rot_angle,1)  $coord_rot_angle(1)
     set dpp_ge(prev_coord_rot_angle,2)  $coord_rot_angle(0)

     if {$dpp_ge(coord_rot) =="AUTO_3D"} {
        VMOV 3  pos mom_pos
        MOM_reload_variable -a mom_pos
     }

     if {[info exists mom_motion_type] && $mom_motion_type == "CYCLE"} {
        VMOV 3 mom_pos mom_cycle_rapid_to_pos
        VMOV 3 mom_pos mom_cycle_feed_to_pos
        VMOV 3 mom_pos mom_cycle_retract_to_pos
        set mom_cycle_rapid_to_pos(2) [expr $mom_pos(2)+$mom_cycle_rapid_to]
        set mom_cycle_retract_to_pos(2) [expr $mom_pos(2)+$mom_cycle_retract_to]
        set mom_cycle_feed_to_pos(2) [expr $mom_pos(2)+$mom_cycle_feed_to]
     }
  }

  if {[info exists mom_motion_type] && $mom_motion_type == "CYCLE" &&\
        [info exists mom_current_motion] && $mom_current_motion == "initial_move"} {
     if { $dpp_ge(coord_rot) == "AUTO_3D" } {
        set dpp_ge(cycle_clearance_plane) "FALSE"
     } else {
        set dpp_ge(cycle_clearance_plane) "TRUE"
     }
  }

  if { $dpp_ge(cycle_clearance_plane)  == "FALSE"} {
     set dpp_TNC_Q203_pos $mom_pos(2)
     set mom_pos(2) [expr $mom_pos(2)+$mom_cycle_rapid_to]
  }


}


#=============================================================
proc PB_CMD_detect_local_offset { } {
#=============================================================
# This command is used to detect offset in local csys.
# Used in initial move and first move
#
# 06-18-2013 Jason - Initial version


  global mom_kin_coordinate_system_type
  global mom_parent_csys_matrix
  global mom_part_unit mom_output_unit
  global mom_fixture_offset_value
  global saved_mom_fixture_offset_value
  global dpp_ge
  global dpp_TNC_local_offset_flag ;#This variable is used to define whether it is needed to define the local csys and record the status of last local csys definition.
  global dpp_TNC_reset_last_local_offset ;#This variable is used to indicate whether it is needed to reset the last local offset

  set dpp_TNC_reset_last_local_offset 0

  if {[info exists mom_kin_coordinate_system_type] && ![string compare "CSYS" $mom_kin_coordinate_system_type]} {
#################################Calculate local offset########################
     if {[array exists mom_parent_csys_matrix]} {
        if {![string compare $mom_part_unit $mom_output_unit]} {
           set unit_conversion 1
        } elseif { ![string compare "IN" $mom_output_unit] } {
           set unit_conversion [expr 1.0/25.4]
        } else {
           set unit_conversion 25.4
        }
        set dpp_ge(coord_offset,0) [expr $unit_conversion*$mom_parent_csys_matrix(9)]
        set dpp_ge(coord_offset,1) [expr $unit_conversion*$mom_parent_csys_matrix(10)]
        set dpp_ge(coord_offset,2) [expr $unit_conversion*$mom_parent_csys_matrix(11)]
      } else {
        set dpp_ge(coord_offset,0) $mom_csys_origin(0)
        set dpp_ge(coord_offset,1) $mom_csys_origin(1)
        set dpp_ge(coord_offset,2) $mom_csys_origin(2)
     }
################################################################################
     if {![EQ_is_equal $dpp_ge(coord_offset,0) 0.0] ||\
         ![EQ_is_equal $dpp_ge(coord_offset,1) 0.0] ||\
         ![EQ_is_equal $dpp_ge(coord_offset,2) 0.0] } {
        if {![info exists saved_mom_fixture_offset_value] || ![EQ_is_equal $mom_fixture_offset_value $saved_mom_fixture_offset_value]} {
           set dpp_TNC_local_offset_flag 1
           set dpp_TNC_reset_last_local_offset 1
           set dpp_ge(prev_coord_offset,0) $dpp_ge(coord_offset,0)
           set dpp_ge(prev_coord_offset,1) $dpp_ge(coord_offset,1)
           set dpp_ge(prev_coord_offset,2) $dpp_ge(coord_offset,2)
return
        }
        if {[EQ_is_equal $dpp_ge(prev_coord_offset,0) $dpp_ge(coord_offset,0)] &&\
            [EQ_is_equal $dpp_ge(prev_coord_offset,1) $dpp_ge(coord_offset,1)] &&\
            [EQ_is_equal $dpp_ge(prev_coord_offset,2) $dpp_ge(coord_offset,2)]} {
           set dpp_TNC_reset_last_local_offset 0
        } else {
           set dpp_TNC_local_offset_flag 1
           set dpp_TNC_reset_last_local_offset 1
           set dpp_ge(prev_coord_offset,0) $dpp_ge(coord_offset,0)
           set dpp_ge(prev_coord_offset,1) $dpp_ge(coord_offset,1)
           set dpp_ge(prev_coord_offset,2) $dpp_ge(coord_offset,2)
        }
     } else {
        if { $dpp_TNC_local_offset_flag==1 } {
           set dpp_TNC_local_offset_flag 0
           set dpp_TNC_reset_last_local_offset 1
           set dpp_ge(prev_coord_offset,0) $dpp_ge(coord_offset,0)
           set dpp_ge(prev_coord_offset,1) $dpp_ge(coord_offset,1)
           set dpp_ge(prev_coord_offset,2) $dpp_ge(coord_offset,2)
        }
     }
  }

  if {[info exists mom_kin_coordinate_system_type] && ![string compare "LOCAL" $mom_kin_coordinate_system_type]} {
     if { $dpp_TNC_local_offset_flag==1 } {
        set dpp_TNC_local_offset_flag 0
        set dpp_TNC_reset_last_local_offset 1
        set dpp_ge(prev_coord_offset,0) 0
        set dpp_ge(prev_coord_offset,1) 0
        set dpp_ge(prev_coord_offset,2) 0
     }
  }
}


#=============================================================
proc PB_CMD_detect_tool_path_type { } {
#=============================================================
# This command is used to detect tool path type.
# Used in initial move and first move
#
# 06-18-2013 Jason - Initial version

  global mom_ude_5axis_tool_path
  global dpp_ge

# 10-18-2013 Jason - Save kinematics before Auto3D
  DPP_GE_SAVE_KINEMATICS

  if {[DPP_GE_DETECT_5AXIS_TOOL_PATH]} {
     set dpp_ge(toolpath_axis_num) "5"
  } else {
     set dpp_ge(toolpath_axis_num) "3"
  }

  if {[info exists mom_ude_5axis_tool_path] && $mom_ude_5axis_tool_path == "YES"} {
     set dpp_ge(toolpath_axis_num) "5"
  } elseif {[info exists mom_ude_5axis_tool_path] && $mom_ude_5axis_tool_path == "NO"} {
     set dpp_ge(toolpath_axis_num) "3"
  }
}


#=============================================================
proc PB_CMD_enable_spindle { } {
#=============================================================
# call by MOM_spindle_rpm
# 06-25-15 - jintao initial implementation
   MOM_enable_address M_spindle
}


#=============================================================
proc PB_CMD_end_of_alignment_character { } {
#=============================================================
# This command restores sequnece number back to orignal
# This command may be used with the command "PM_CMD_start_of_alignment_character"
#
   global mom_sys_leader saved_seq_num
   if { [info exists saved_seq_num] } {
      set mom_sys_leader(N) $saved_seq_num
   }
}


#=============================================================
proc PB_CMD_fifth_axis_rotate_move { } {
#=============================================================
#  This command is used by the ROTATE ude command to output a
#  fifth axis rotary move.  You can use the NC Data Definitions
#  section of postbuilder to modify the fifth_axis_rotary_move
#  block template.
#
#  --> Do NOT attach this command to any event marker!
#  --> Do NOT change the name of this command!
#

   MOM_force once fifth_axis
   MOM_do_template fifth_axis_rotate_move
}


#=============================================================
proc PB_CMD_final_program { } {
#=============================================================
   global ini_prog

   set ini_prog  "true"
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
              [EQ_is_equal $mom_pos(3) $mom_prev_pos(3)] && [EQ_is_equal $mom_pos(4) $mom_prev_pos(4)] } {

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
#  This command is used by the ROTATE ude command to output a
#  fourth axis rotary move.  You can use the NC Data Definitions
#  section of postbuilder to modify the fourth_axis_rotary_move
#  block template.
#
#  --> Do NOT attach this command to any event marker!
#  --> Do NOT change the name of this command!
#

   MOM_force once fourth_axis
   MOM_do_template fourth_axis_rotate_move
}


#=============================================================
proc PB_CMD_get_feed_value { } {
#=============================================================
# This command is used to get defined feedrate values in NX.
#
  global mom_feed_cut_value mom_feed_cut_unit
  global mom_feed_rapid_value
  global mom_feed_approach_value
  global mom_feed_engage_value mom_feed_engage_unit
  global mom_feed_first_cut_value
  global mom_feed_departure_value
  global mom_feed_retract_value mom_feed_retract_unit
  global mom_feed_return_value
  global mom_feed_stepover_value
  global mom_feed_traversal_value
  global mom_user_feed_var_num
  global mom_user_feed_value
  global mom_ude_feed_definition
  global mom_output_unit mom_part_unit

  if {![string compare $mom_part_unit $mom_output_unit]} {
     set unit_conversion 1
  } elseif { ![string compare "IN" $mom_output_unit] } {
     set unit_conversion [expr 1.0/25.4]
  } else {
     set unit_conversion 25.4
  }

  if {[EQ_is_zero $mom_feed_engage_value]} {set mom_feed_engage_value $mom_feed_cut_value}
  if {[EQ_is_zero $mom_feed_retract_value]} {set mom_feed_retract_value $mom_feed_cut_value}

  set mom_user_feed_value(cut)    [expr $unit_conversion*$mom_feed_cut_value]
  set mom_user_feed_value(engage) [expr $unit_conversion*$mom_feed_engage_value]
  set mom_user_feed_value(retract) [expr $unit_conversion*$mom_feed_retract_value]


  set mom_user_feed_value(cut) [format "%.2f" $mom_user_feed_value(cut)]
  set mom_user_feed_value(engage) [format "%.2f" $mom_user_feed_value(engage)]
  set mom_user_feed_value(retract) [format "%.2f" $mom_user_feed_value(retract)]

}


#=============================================================
proc PB_CMD_go_home_pos { } {
#=============================================================
   global ini_prog
   global mom_operation_type
   global mom_tool_axis_type
   global mom_5axis_control_mode

   if { [string match "AUTO" $mom_5axis_control_mode] } {

      global TNC_output_mode
      if { ![string match "M128" $TNC_output_mode] } {

         MOM_output_literal "M129"

         MOM_do_template return_home_z
         MOM_do_template return_home_xy

         if { $ini_prog == "true" } {
            MOM_force once fourth_axis fifth_axis
            MOM_do_template return_home_bc

            set ini_prog  "false"
         }

         MOM_force once fourth_axis fifth_axis
      }

   } else {

      global mom_5axis_control_pos
      if { !$mom_5axis_control_pos } {

         MOM_output_literal "M129"

         MOM_do_template return_home_z
         MOM_do_template return_home_xy

         if { $ini_prog == "true" } {
            MOM_force once fourth_axis fifth_axis
            MOM_do_template return_home_bc

            set ini_prog  "false"
         }

         MOM_force once fourth_axis fifth_axis
      }
   }
}


#=============================================================
proc PB_CMD_handle_sync_event { } {
#=============================================================
   global mom_sync_code
   global mom_sync_index
   global mom_sync_start
   global mom_sync_incr
   global mom_sync_max

   set mom_sync_start  99
   set mom_sync_incr   1
   set mom_sync_max    199


   if { ![info exists mom_sync_code] } {
      set mom_sync_code $mom_sync_start
   }

   set mom_sync_code [expr $mom_sync_code + $mom_sync_incr]


   MOM_output_literal "M$mom_sync_code"
}


#=============================================================
proc PB_CMD_helix_move { } {
#=============================================================
   global mom_pos_arc_plane
   global mom_sys_cir_vector
   global mom_sys_helix_pitch_type
   global mom_helix_pitch
   global mom_prev_pos mom_pos_arc_center
   global PI

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

   global mom_pos
   global helix_angle
   global helix_height
   global mom_helix_direction
   global mom_arc_angle
   global js_prev_pos

   switch $mom_pos_arc_plane {
      XY { MOM_force Once I J; MOM_suppress Once K; set cir_index 2 }
      YZ { MOM_force Once J K; MOM_suppress Once I; set cir_index 0 }
      ZX { MOM_force Once K I; MOM_suppress Once J; set cir_index 1 }
   }

   set helix_height [expr $mom_pos($cir_index) - $mom_prev_pos(2)]

   switch $mom_helix_direction {
      CLW     { set helix_direction -1 }
      CCLW    { set helix_direction 1  }
      default { }
   }

  # set helix_angle [expr 360*$helix_direction*$helix_height/$mom_helix_pitch]
   set helix_angle [expr $mom_arc_angle * $helix_direction]

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # You will need to construct the required block templates and
  # revise the lines below accordingly.

}


#=============================================================
proc PB_CMD_init_cutcom_status { } {
#=============================================================
#<06-15-10 gsl> Moved code from PB_CMD_before_motion

   global mom_cutcom_status
   if { ![info exist mom_cutcom_status] } {
      set mom_cutcom_status "OFF"
   }
}


#=============================================================
proc PB_CMD_init_cycle { } {
#=============================================================
# This command initializes some drilling cycle variables.
#
# 06-27-2013 Jason - Initial version
# 03-20-2014 Jason - Refine dpp_TNC_cycle_thread_pitch dpp_TNC_cycle_tap_feed and dpp_TNC_cycle_step_clearance
# 08-21-2015 szl - Enhance the warning message when users set wrong pitch and wrong spindle speed,fix PR7463004

   global cycle_init_flag
   global mom_operation_name
   global mom_cycle_delay
   global mom_motion_event
   global mom_cycle_step1
   global mom_cycle_step_clearance
   global mom_cycle_retract_mode
   global mom_cycle_feed_to mom_cycle_rapid_to mom_cycle_retract_to
   global mom_tool_pitch
   global mom_cycle_thread_pitch
   global mom_cycle_thread_right_handed
   global mom_cycle_orient
   global mom_spindle_direction mom_spindle_speed
   global js_prev_pos               ;# diy previous Z height
   global js_return_pos             ;# returnZ incremental from top of hole
   global mom_pos
   global mom_prev_pos
   global mom_output_unit
   global feed
   global dpp_ge
   global dpp_TNC_Q203_pos
   global dpp_TNC_cycle_thread_pitch
   global dpp_TNC_cycle_tap_feed
   global dpp_TNC_cycle_step_clearance
   global dpp_TNC_cycle_feed
   global mom_cycle_feed_rate_mode
   global mom_cycle_feed_rate
   global mom_tool_name
   global mom_feed_cut_unit
   global mom_spindle_rpm

  #--------------------Set default cycle orient------------------------------------------------
   if { ![info exists mom_cycle_orient] } {
      set mom_cycle_orient 0
   }
  #--------------------Set default cycle delay-------------------------------------------------
   if { ![info exists mom_cycle_delay] } {
      set mom_cycle_delay 0.0
   }
  #--------------------Set retract distance----------------------------------------------------
   if { [string match "AUTO" $mom_cycle_retract_mode] } {
      set js_return_pos [expr $js_prev_pos - $mom_pos(2)] ;# calc incr retract
   } else {
      set js_return_pos $mom_cycle_retract_to
   }
  #--------------------Calculate thread pitch---------------------------------------------------
   if { ![string compare "tap_move" $mom_motion_event] ||\
        ![string compare "tap_deep_move" $mom_motion_event] ||\
        ![string compare "tap_float_move" $mom_motion_event] ||\
        ![string compare "tap_break_chip_move" $mom_motion_event] } {
      if { [info exists mom_tool_pitch] } {
         if { [info exists mom_cycle_thread_pitch] } {
             set dpp_TNC_cycle_thread_pitch $mom_cycle_thread_pitch

      } else {
            set dpp_TNC_cycle_thread_pitch $mom_tool_pitch
         }
         } else {
            #---------Warning---------
           # MOM_abort "$mom_operation_name: No thread pitch!"
            MOM_display_message "$mom_operation_name: No pitch defined on the tool. Please use Tap tool. \n Post Processing will be aborted." "Postprocessor error message" "E"
            MOM_abort "*** User Abort Post Processing *** "
         }
      if {![info exists mom_spindle_speed] || [EQ_is_zero $mom_spindle_speed] } {
         MOM_display_message "$mom_operation_name : spindle speed is 0. Post Processing will be aborted." "Postprocessor error message" "E"
         MOM_abort "*** User Abort Post Processing *** "
      }
   }
  #--------------------Calculate thread pitch sign-----------------------------------------------
   if {[info exists mom_cycle_thread_right_handed]} {
      if { $mom_cycle_thread_right_handed == "FALSE" } {
          set dpp_TNC_cycle_thread_pitch  [expr $dpp_TNC_cycle_thread_pitch * (-1)]
      }
   } elseif { $mom_spindle_direction == "CCLW" } {
      set dpp_TNC_cycle_thread_pitch  [expr $dpp_TNC_cycle_thread_pitch * (-1)]
   }
  #--------------------Cycle feed rate multiply by 10 in INCH unit-----------------------------
   switch $mom_output_unit {
      IN {
          set dpp_TNC_cycle_feed [expr $feed*10]
      }
      MM {
          set dpp_TNC_cycle_feed $feed
      }
   }
  #--------------------Calculate tap feed------------------------------------------------------
   if { ![string compare "tap_float_move" $mom_motion_event] } {
      set dpp_TNC_cycle_tap_feed [expr abs($dpp_TNC_cycle_thread_pitch) * $mom_spindle_rpm]
   }
  #--------------------Calculate step clearance------------------------------------------------
   if { ![string compare "tap_deep_move" $mom_motion_event] } {
      set dpp_TNC_cycle_step_clearance 0
   }
   if { ![string compare "tap_break_chip_move" $mom_motion_event] } {
      if {[info exists mom_cycle_step_clearance]} {
         if { ![EQ_is_zero $mom_cycle_step_clearance] } {
            set dpp_TNC_cycle_step_clearance $mom_cycle_step_clearance
         } else {
            MOM_output_to_listing_device "$mom_operation_name: Step clearance is 0, please set a value!"
         }
      } else {
         MOM_output_to_listing_device "$mom_operation_name: No step clearance defined."
      }
   }
  #--------------------Calculate peck sizes-----------------------------------------------------
   global mom_tool_diameter
   global cycle_peck_size cycle_type_number

   set cycle_peck_size [expr ($mom_cycle_feed_to*(-1.0))]     ;# single peck size most cycles

   if { ![string compare "drill_deep_move" $mom_motion_event] ||\
        ![string compare "drill_break_chip_move" $mom_motion_event] } {

      if { $mom_cycle_step1 == 0 } {
         set cycle_peck_size  $mom_tool_diameter  ;# default peck  if not set
      } else {
         set cycle_peck_size  $mom_cycle_step1    ;# real peck
      }
   }

  # Normally cycle_init_flag is only set if this is a new cycle
  # it is specifically unset in cycle_plane_change event, which
  # happens when a drilling operation goes uphill,
  # (drills a hole at a higher Z than the previous hole)
  # it is _not_ set  when drilling downhill.
  # this next bit of code sets the variable for up or downhill
  # so that the new hole is defined - this is absolutely required
  # to ensure the hole Z height Q203 is set correctly.

   if { $mom_pos(2) != $mom_prev_pos(2) } {
      set cycle_init_flag  "TRUE"
   }
   if { $dpp_ge(cycle_clearance_plane) == "FALSE" } {
      set mom_pos(2) $dpp_TNC_Q203_pos
   }
   set dpp_ge(cycle_clearance_plane) "TRUE"

}


#=============================================================
proc PB_CMD_init_force_address { } {
#=============================================================
# Command to force output address in Start of path.
  MOM_force once G_motion X Y Z M_spindle F


}


#=============================================================
proc PB_CMD_init_helix { } {
#=============================================================
uplevel #0 {
#
# This ommand will be executed automatically at the start of program and
# anytime it is loaded as a slave post of a linked post.
#
# This procedure can be used to enable your post to output helix.
# You can choose from the following options to format the circle
# block template to output the helix parameters.
#

   set mom_sys_helix_pitch_type    "rise_revolution"

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

   set mom_kin_helical_arc_output_mode END_POINT

   MOM_reload_kinematics

} ;# uplevel
}


#=============================================================
proc PB_CMD_init_operation { } {
#=============================================================
   global mom_path_name
   global mom_tool_diameter mom_tool_name mom_tool_number
   global mom_sys_control_out mom_sys_control_in
   global mom_tnc_5axis_control_mode


   global mom_spindle_direction tap_direction
   set tap_direction $mom_spindle_direction


   global pop_local_csys
   set pop_local_csys 0

   global pop_datum_shift
   #set pop_datum_shift 0


   set mom_tnc_5axis_control_mode "AUTO"

}


#=============================================================
proc PB_CMD_init_rotary { } {
#=============================================================
#
# Retract and Re-Engage Parameters
#
# This option is activated by setting the Axis Limit Violation
# Handling option on the Machine Tool dialog to Retract/Re-Engage.
#
# The sequence of actions that take place when a rotary limit violation
# occurs is a retract to the clearance geometry at the rapid feedrate,
# reposition the rotary axes so they do not violate, move back to
# the engage point at the retract feedrate and engage into the part again.
#
# You can set additional parameters that will control the retract
# and re-engage motion.
#
#
#  mom_kin_retract_type ------- specifies the method used to
#                               calculate the retract point.
#                               The method can be of
#
#    DISTANCE : The retract will be to a point at a fixed distance
#               along the spindle axis.
#
#    SURFACE  : For a 4-axis rotary head machine, the retract will
#               be to a cylinder.  For a 5-axis dual heads machine,
#               the retract will be to a sphere.  For machine with
#               only rotary table(s), the retract will be to a plane
#               normal & along the spindle axis.
#
#  mom_kin_retract_distance --- specifies the distance or radius for
#                               defining the geometry of retraction.
#
#  mom_kin_reengage_distance -- specifies the re-engage point above
#                               the part.
#
#=============================================================
# Revisions:
# 03-13-09 gsl - Use global declaration in place of "uplevel"
#=============================================================
#
   global mom_kin_retract_type
   global mom_kin_retract_distance
   global mom_kin_reengage_distance
   global mom_kin_spindle_axis
   global mom_sys_spindle_axis
   global mom_sys_lock_status


   set mom_kin_retract_type                "DISTANCE"
   set mom_kin_retract_distance            10.0
   set mom_kin_reengage_distance           .20

#
# The following parameters are used by UG Post.
# --> Do NOT change them unless you know what you are doing!
#
   if { ![info exists mom_kin_spindle_axis] } {
      set mom_kin_spindle_axis(0)                    0.0
      set mom_kin_spindle_axis(1)                    0.0
      set mom_kin_spindle_axis(2)                    1.0
   }

   set spindle_axis_defined 1

   if { ![info exists mom_sys_spindle_axis] } {

      set spindle_axis_defined 0

   } else {
      if { ![array exists mom_sys_spindle_axis] } {

         unset mom_sys_spindle_axis
         set spindle_axis_defined 0
      }
   }

   if { !$spindle_axis_defined } {
      set mom_sys_spindle_axis(0)                    0.0
      set mom_sys_spindle_axis(1)                    0.0
      set mom_sys_spindle_axis(2)                    1.0
   }

   set mom_sys_lock_status                        "OFF"
}


#=============================================================
proc PB_CMD_init_tnc_output_mode { } {
#=============================================================
# This command is called in MOM_start_of_path to set
# the TNC output mode.
#
   global mom_spindle_direction tap_direction

   set tap_direction $mom_spindle_direction


  #<02-28-08 gsl> Determine TNC output mode here
   global mom_operation_type mom_tool_axis_type
   global TNC_output_mode

   if { [string match "Variable-axis Surface Contouring" $mom_operation_type] && $mom_tool_axis_type != 0 } {
      set TNC_output_mode M128
   } else {
      set TNC_output_mode CYCL19
   }

  # If desired, uncomment one of the lines below to force a specific output mode.
  # set TNC_output_mode M128
  # set TNC_output_mode CYCL19
}


#=============================================================
proc PB_CMD_init_vars { } {
#=============================================================
   global rad2deg
   global ini_prog last_F
   global PI

   set rad2deg  [expr 180.0 / $PI]

   set last_F    0
   set ini_prog  "true"



  #<02-26-2008 gsl> Initialize next 2 vars
   global mom_5axis_control_mode mom_5axis_control_pos
   if { ![info exists mom_5axis_control_mode] } {
      set mom_5axis_control_mode "AUTO"
      set mom_5axis_control_pos 1
   }
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
      if [CMD_EXIST PB_CMD_handle_lathe_flash_tool] {
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
   if { [llength [info commands PB_CMD_abort_event]] } {
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
   global mom_kin_machine_type

   if { [info exists mom_kin_machine_type] } {
      if { [string match "*3_axis_mill*" $mom_kin_machine_type] || \
           [string match "*lathe*" $mom_kin_machine_type] } {
return
      }
   }


  # Lock on and not circular move
   global mom_sys_lock_status mom_current_motion
   if { [info exists mom_sys_lock_status] && ![string compare "ON" $mom_sys_lock_status] } {
      if { [info exists mom_current_motion] && [string compare "circular_move" $mom_current_motion] } {

         LOCK_AXIS_MOTION
      }
   }


  # Error and linear move
   global mom_sys_rotary_error mom_motion_event
   if { [info exists mom_sys_rotary_error] && [info exists mom_motion_event] } {
      if { $mom_sys_rotary_error != 0 && ![string compare "linear_move" $mom_motion_event] } {

         ROTARY_AXIS_RETRACT
      }
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
# Broker command ensuring PB_CMD_before_output,if present, gets executed
# by MOM_before_output.
#
   if [llength [info commands PB_CMD_before_output] ] {
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
   if { [llength [info commands PB_CMD_set_oper_tool_time] ] } {
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
         if { [EQ_is_zero $f_pm] && [EQ_is_zero $f_pr] } {
            SUPER_FEED_MODE_SET RAPID
         } else {
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
   if { [llength [info commands "PB_CMD_FEEDRATE_SET"]] } {
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
   global mom_new_iks_exists

  # Revert legacy dual-head kinematic parameters when new IKS is absent.
   if { ![info exists mom_new_iks_exists] } {
      set ugii_version [string trim [MOM_ask_env_var UGII_VERSION]]
      if { ![string match "v3" $ugii_version] } {

         if { [llength [info commands PB_CMD_revert_dual_head_kin_vars] ] } {
            PB_CMD_revert_dual_head_kin_vars
         }
return
      }
   }

  # Initialize new IKS parameters.
   if { [llength [info commands PB_init_new_iks] ] } {
      PB_init_new_iks
   }

  # Users can provide next command to modify or disable new IKS options.
   if { [llength [info commands PB_CMD_revise_new_iks] ] } {
      PB_CMD_revise_new_iks
   }

  # Revert legacy dual-head kinematic parameters when new IKS is disabled.
   global mom_kin_iks_usage
   if { $mom_kin_iks_usage == 0 } {
      if { [llength [info commands PB_CMD_revert_dual_head_kin_vars] ] } {
         PB_CMD_revert_dual_head_kin_vars
      }
   }
}


#=============================================================
proc PB_CMD_kin_init_probing_cycles { } {
#=============================================================
   set cmd PB_CMD_init_probing_cycles
   if { [llength [info commands "$cmd"]] } {
      eval $cmd
   }
}


#=============================================================
proc PB_CMD_kin_init_rotary { } {
#=============================================================

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
### This is the backup of original MOM_clamp handler.
###
### - New command PB_CMD_MOM_clamp is created with the
###   same content of the original command and executed
###   by the new MOM_clamp handler.
###
proc DUMMY_MOM_clamp { } {
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
### This is the backup of original MOM_rotate handler.
###
### - New command PB_CMD_MOM_rotate is created with the
###   same content of the original command and executed
###   by the new MOM_rotate handler.
###
proc DUMMY_MOM_rotate { } {
#=============================================================
## <rws 04-11-2008>
## If in TURN mode and user invokes "Flip tool aorund Holder" a MOM_rotate event is generated
## When this happens ABORT this event via return
##

   global mom_machine_mode


   if { [info exists mom_machine_mode] && [string match "TURN" $mom_machine_mode] } {
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
      global mom_warning_info
      set mom_warning_info "Invalid rotary axis"
      MOM_catch_warning
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


 #     if {$axis == 3} {set prot $prev_angles(0)}
 #     if {$axis == 4} {set prot $prev_angles(1)}
 #     if {$dir == 1 && $mom_out_angle_pos($a) < $prot} {
 #        set mom_out_angle_pos($a) [expr $mom_out_angle_pos($a) + 360.0]
 #     } elseif {$dir == -1 && $mom_out_angle_pos($a) > $prot} {
 #        set mom_out_angle_pos($a) [expr $mom_out_angle_pos($a) - 360.0]
 #     }


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


#<03-02-09 gsl> What is the logic here?
if 1 {
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
   set mom_prev_pos($axis) $ang
   MOM_reload_variable -a mom_prev_pos
   MOM_reload_variable -a mom_out_angle_pos
}





#=============================================================
### This is the backup of original MOM_lock_axis handler.
###
### - New command PB_CMD_MOM_lock_axis is created with the
###   same content of the original command and executed
###   by the new MOM_lock_axis handler.
###
proc DUMMY_MOM_lock_axis { } {
#=============================================================
  global mom_sys_lock_value mom_sys_lock_plane
  global mom_sys_lock_axis mom_sys_lock_status

   set status [SET_LOCK axis plane value]
   if { ![string compare "error" $status] } {
      MOM_catch_warning
      set mom_sys_lock_status OFF
   } else {
      set mom_sys_lock_status $status
      if { [string compare "OFF" $status] } {
         set mom_sys_lock_axis $axis
         set mom_sys_lock_plane $plane
         set mom_sys_lock_value $value

         LOCK_AXIS_INITIALIZE
      }
   }
}


#=============================================================
proc PB_catch_warning { } {
#=============================================================
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
proc MOM_lintol { } {
#=============================================================
   global mom_kin_linearization_flag
   global mom_kin_linearization_tol
   global mom_lintol_status
   global mom_lintol

   if { ![string compare "ON" $mom_lintol_status] } {
      set mom_kin_linearization_flag "TRUE"
      if { [info exists mom_lintol] } {set mom_kin_linearization_tol $mom_lintol}
   } elseif { ![string compare "OFF" $mom_lintol_status] } {
      set mom_kin_linearization_flag "FALSE"
   }
}


} ;# uplevel
#***********

}


#=============================================================
proc PB_CMD_kin_set_csys { } {
#=============================================================
   if [llength [info commands PB_CMD_set_csys] ] {
      PB_CMD_set_csys
   }

   #<02-27-13 lili> Added following codes.
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
      if { ![string match "*3_axis_mill*" $mom_kin_machine_type] && ![string match "*lathe*" $mom_kin_machine_type] } {

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

   lappend command_list PB_DEFINE_MACROS

   if { [info exists mom_kin_machine_type] } {
      if { [string match "*3_axis_mill_turn*" $mom_kin_machine_type] } {

         lappend command_list  PB_CMD_kin_init_mill_xzc
         lappend command_list  PB_CMD_kin_mill_xzc_init
         lappend command_list  PB_CMD_kin_init_mill_turn
         lappend command_list  PB_CMD_kin_mill_turn_initialize
      }
   }


   foreach cmd $command_list {

      if { [llength [info commands "$cmd"]] } {

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
#  This command is executed automatically by other functions
#  to output a linear move.
#
#  --> Do NOT attach this command to any event marker!
#  --> Do NOT change the name of this command!
#
#
#  This command, when present in the post, will be used for
#     simulated cycles feed moves
#     mill/turn mill linearization
#     four and five axis retract and re-engage
#

   MOM_do_template linear_move
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

   global mom_kin_nurbs_output_type

   set mom_kin_nurbs_output_type                  HEIDENHAIN_POLY
   MOM_reload_kinematics
}


#=============================================================
proc PB_CMD_nurbs_move { } {
#=============================================================
#_______________________________________________________________________________
# This procedure is executed for each Nurbs machining move.
#_______________________________________________________________________________
   global mom_nurbs_point_count
   global mom_nurbs_points
   global mom_nurbs_coefficients
   global mom_nurbs_points_x
   global mom_nurbs_points_y
   global mom_nurbs_points_z
   global mom_nurbs_co_efficient_0
   global mom_nurbs_co_efficient_1
   global mom_nurbs_co_efficient_2
   global mom_nurbs_co_efficient_3
   global mom_nurbs_co_efficient_4
   global mom_nurbs_co_efficient_5
   global mom_nurbs_co_efficient_6
   global mom_nurbs_co_efficient_7
   global mom_nurbs_co_efficient_8


   MOM_force once F


   MOM_do_template spline_start

   for { set ii 0 } { $ii < $mom_nurbs_point_count } { incr ii } {

      set mom_nurbs_points_x       $mom_nurbs_points($ii,0)
      set mom_nurbs_points_y       $mom_nurbs_points($ii,1)
      set mom_nurbs_points_z       $mom_nurbs_points($ii,2)
      set mom_nurbs_co_efficient_0 $mom_nurbs_coefficients($ii,0)
      set mom_nurbs_co_efficient_1 $mom_nurbs_coefficients($ii,1)
      set mom_nurbs_co_efficient_2 $mom_nurbs_coefficients($ii,2)
      set mom_nurbs_co_efficient_3 $mom_nurbs_coefficients($ii,3)
      set mom_nurbs_co_efficient_4 $mom_nurbs_coefficients($ii,4)
      set mom_nurbs_co_efficient_5 $mom_nurbs_coefficients($ii,5)
      set mom_nurbs_co_efficient_6 $mom_nurbs_coefficients($ii,6)
      set mom_nurbs_co_efficient_7 $mom_nurbs_coefficients($ii,7)
      set mom_nurbs_co_efficient_8 $mom_nurbs_coefficients($ii,8)

      PB_call_macro CYCL_NURBS
   }
}


#=============================================================
proc PB_CMD_operator_message { } {
#=============================================================
uplevel #0 {



   proc  MOM_operator_message {} {
   #_______________________________________________________________________________
   # This procedure is executed when the Operator Message command is activated.
   #_______________________________________________________________________________
         global mom_operator_message mom_operator_message_defined
         global mom_operator_message_status
         global ptp_file_name group_output_file mom_group_name
         global mom_sys_commentary_output
         global mom_sys_control_in
         global mom_sys_control_out
         global mom_sys_ptp_output


         if {[info exists mom_operator_message_defined]} {
           if {$mom_operator_message_defined == 0} { return }
         }

         if {$mom_operator_message != "ON" && $mom_operator_message != "OFF"} {
             set brac_start [string first \( $mom_operator_message]
             set brac_end [string last \) $mom_operator_message]
             if {$brac_start != 0} {
               set text_string "("
             } else {
               set text_string ""
             }
             append text_string $mom_operator_message
             if {$brac_end != [expr [string length $mom_operator_message] -1]} {
               append text_string ")"
             }

             set st [MOM_set_seq_off]
             MOM_close_output_file   $ptp_file_name
             if {[hiset mom_group_name]} {
                if {[hiset group_output_file($mom_group_name)]} {
                   MOM_close_output_file $group_output_file($mom_group_name)
                }
             }

             MOM_output_literal $text_string

             if {$mom_sys_ptp_output == "ON"} {MOM_open_output_file    $ptp_file_name }
             if {[hiset mom_group_name]} {
                if {[hiset group_output_file($mom_group_name)]} {
                   MOM_open_output_file $group_output_file($mom_group_name)
                }
             }
             if {$st == "on"} {MOM_set_seq_on}
             set need_commentary $mom_sys_commentary_output
             set mom_sys_commentary_output OFF
             regsub -all {[)]} $text_string $mom_sys_control_in text_string
             regsub -all {[(]} $text_string $mom_sys_control_out text_string
             MOM_output_literal $text_string
             set mom_sys_commentary_output $need_commentary
         } else {
             set mom_operator_message_status $mom_operator_message
         }
   }



} ;# uplevel 0
}


#=============================================================
proc PB_CMD_output_coordinate_offset { } {
#=============================================================
# This command is used to define the local csys offset.
#
# 06-05-2013 Jason - Initial version


  global dpp_ge
  global dpp_TNC_local_offset_flag
  global dpp_TNC_reset_last_local_offset

  if {$dpp_TNC_reset_last_local_offset == 1 && $dpp_TNC_local_offset_flag == 1} {
     MOM_do_template cycle_def_70
     MOM_do_template cycle_def_71
     MOM_do_template cycle_def_72
     MOM_do_template cycle_def_73
  }

}


#=============================================================
proc PB_CMD_output_return_home { } {
#=============================================================
#This command is used to return to home position

  MOM_output_literal "M140 MB MAX"
  MOM_force Once M
  MOM_do_template return_home_z
  MOM_force Once M
  MOM_do_template return_home_xy
  MOM_force Once fourth_axis fifth_axis
  MOM_do_template return_home_rotary_both


}


#=============================================================
proc PB_CMD_output_start_of_program { } {
#=============================================================






}


#=============================================================
proc PB_CMD_pause { } {
#=============================================================
# This command enables you to pause the UG/Post processing.
#
   PAUSE
}


#=============================================================
proc PB_CMD_post_name { } {
#=============================================================
# echo back the post file location
# options for full path name, file name only , uppercase

   global mom_event_handler_file_name
   MOM_output_literal ";  POSTPROCESSOR NAME"
   MOM_output_literal ";  [string toupper $mom_event_handler_file_name]"
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
            if { ![string compare "TRUE" [MOM_validate_machine_model]] } {
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
#  This command is used by rotary axis retract to reposition the
#  rotary axes after the tool has been fully retracted.
#
#  You can modify the this command to customize the reposition move.
#  If you need a custom command to be output with this block,
#  you must execute a call a the custom command either before or after
#  the MOM_do_template command.
#
   MOM_suppress once X Y Z
   MOM_do_template rapid_traverse
}


#=============================================================
proc PB_CMD_reset_5axis_control_mode { } {
#=============================================================
   global ini_prog
   global mom_next_oper_has_tool_change
   global mom_current_oper_is_last_oper_in_program

# if {[info exists mom_next_oper_has_tool_change] && [info exists mom_current_oper_is_last_oper_in_program]} {
#    if {$mom_next_oper_has_tool_change == "YES" || $mom_current_oper_is_last_oper_in_program == "YES"} {
#        set ini_prog "true"
#    }
# }



   global mom_5axis_control_mode

   set mom_5axis_control_mode "AUTO"
}


#=============================================================
proc PB_CMD_reset_all_motion_variables_to_zero { } {
#=============================================================
# This command is used to reset all variables to zero.
#
# 06-18-2013 Jason - Initial version

   global mom_prev_pos
   global mom_pos
   global mom_prev_out_angle_pos
   global mom_out_angle_pos
   global mom_prev_rot_ang_4th
   global mom_prev_rot_ang_5th
   global mom_rotation_angle
   global mom_next_oper_has_tool_change
   global mom_current_oper_is_last_oper_in_program


   MOM_reload_kinematics
}


#=============================================================
proc PB_CMD_reset_cycl7 { } {
#=============================================================
  global mom_ude_datum_option

  if {![info exists mom_ude_datum_option] || $mom_ude_datum_option == "CYCL 247" || $mom_ude_datum_option == "CYCL 7 #"} {
     MOM_output_literal "CYCL DEF 7.0"
     MOM_output_literal "CYCL DEF 7.1 X+0.0"
     MOM_output_literal "CYCL DEF 7.2 Y+0.0"
     MOM_output_literal "CYCL DEF 7.3 Z+0.0"
  }
}


#=============================================================
proc PB_CMD_reset_output_mode { } {
#=============================================================
# This command is used to reset some 5-axis functions, reset all the dpp variables and
# restore kinematics at the end of path.
#
# 06-18-2013 Jason - Initial version

  global mom_next_oper_has_tool_change
  global mom_current_oper_is_last_oper_in_program
  global dpp_ge
  global mom_kin_arc_output_mode
  global mom_kin_helical_arc_output_mode
  global save_mom_kin_arc_output_mode
  global save_mom_kin_helical_arc_output_mode
  global save_mom_kin_machine_type
  global mom_kin_machine_type
  global mom_out_angle_pos
  global mom_prev_out_angle_pos
  global mom_pos mom_prev_pos

#Cancel Plane Special
  if {$dpp_ge(coord_rot)!="NONE"} {
     MOM_output_literal "PLANE RESET STAY"
     MOM_enable_address fourth_axis
     MOM_enable_address fifth_axis
  }

#Cancel M128
  if { $dpp_ge(toolpath_axis_num)=="5" } {
     MOM_output_literal "M129"
     if {[info exists save_mom_kin_arc_output_mode]} {
        set mom_kin_arc_output_mode $save_mom_kin_arc_output_mode
     }
     if {[info exists save_mom_kin_helical_arc_output_mode]} {
        set mom_kin_helical_arc_output_mode $save_mom_kin_helical_arc_output_mode
     }
     MOM_reload_kinematics
  }

  global mom_output_mode_cmd
  global mom_output_mode_define
  global mom_ude_5axis_tool_path
  global mom_cycle_option

  catch {unset mom_cycle_option}
  catch {unset mom_output_mode_cmd}
  catch {unset mom_output_mode_define}
  catch {unset mom_ude_5axis_tool_path}

  global js_return_pos js_prev_pos

  set js_return_pos 0.0
  set js_prev_pos 0.0

  PB_CMD_set_default_dpp_value

  DPP_GE_RESTORE_KINEMATICS
}


#=============================================================
proc PB_CMD_restore_kinematics { } {
#=============================================================
# Restore original kinematics variables
  set kin_list {mom_kin_arc_output_mode  mom_kin_helical_arc_output_mode mom_sys_4th_axis_has_limits mom_sys_5th_axis_has_limits mom_kin_machine_type  mom_kin_4th_axis_ang_offset mom_kin_arc_output_mode  mom_kin_4th_axis_direction  mom_kin_4th_axis_incr_switch    mom_kin_4th_axis_leader     mom_kin_4th_axis_limit_action   mom_kin_4th_axis_max_limit  mom_kin_4th_axis_min_incr       mom_kin_4th_axis_min_limit  mom_kin_4th_axis_plane          mom_kin_4th_axis_rotation    mom_kin_4th_axis_type   mom_kin_5th_axis_zero        mom_kin_4th_axis_zero          mom_kin_5th_axis_direction  mom_kin_5th_axis_incr_switch    mom_kin_5th_axis_leader     mom_kin_5th_axis_limit_action   mom_kin_5th_axis_max_limit  mom_kin_5th_axis_min_incr       mom_kin_5th_axis_min_limit  mom_kin_5th_axis_plane          mom_kin_5th_axis_rotation    mom_kin_5th_axis_type          mom_kin_5th_axis_ang_offset   }
  set kin_array_list {mom_kin_spindle_axis  mom_kin_4th_axis_center_offset mom_kin_5th_axis_center_offset   mom_kin_4th_axis_point         mom_kin_5th_axis_point           mom_kin_4th_axis_vector        mom_kin_5th_axis_vector }


  foreach kin_var $kin_list {
    global $kin_var save_$kin_var
    if {[info exists save_$kin_var]} {
       set value [set save_$kin_var]
       set $kin_var $value
       unset save_$kin_var
    }
  }

  foreach kin_var $kin_array_list {
    global $kin_var save_$kin_var
    if {[array exists save_$kin_var]} {
       set save_var save_$kin_var
       VMOV 3 $save_var $kin_var
       UNSET_VARS $save_var
    }
  }

  global mom_sys_leader
  if {[info exists mom_kin_4th_axis_leader] && [info exists mom_kin_5th_axis_leader]} {
    set mom_sys_leader(fourth_axis) $mom_kin_4th_axis_leader
    set mom_sys_leader(fifth_axis) $mom_kin_5th_axis_leader
  }
  MOM_reload_kinematics
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
#  This command is used by rotary axis retract to move away from
#  the part.  This move is a three axis move along the tool axis at
#  a retract feedrate.
#
#  You can modify the this command to customize the retract move.
#  If you need a custom command to be output with this block,
#  you must execute a call to the custom command either before or after
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


   if { ![string match  "5_axis_dual_head"  $mom_kin_machine_type] } {
return
   }


   set var_list { ang_offset\
                  center_offset(0)\
                  center_offset(1)\
                  center_offset(2)\
                  direction\
                  incr_switch\
                  leader\
                  limit_action\
                  max_limit\
                  min_incr\
                  min_limit\
                  plane\
                  rotation\
                  zero }

   set center_offset_set 0

   foreach var $var_list {
     # Global declaration
      if { [string match "center_offset*" $var] } {
         if { !$center_offset_set } {
            global mom_kin_4th_axis_center_offset mom_kin_5th_axis_center_offset
            set center_offset_set 1
         }
      } else {
         global mom_kin_4th_axis_[set var] mom_kin_5th_axis_[set var]
      }

     # Swap values
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
   if { [llength [info commands PB_swap_dual_head_elements] ] } {
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
proc PB_CMD_save_RPM { } {
#=============================================================
   global last_RPM mom_spindle_speed

  #<12-05-07 gsl> Corrected logic
   if { ![info exists last_RPM] } {
      set last_RPM  0
   } else {
      set last_RPM $mom_spindle_speed
   }
}


#=============================================================
proc PB_CMD_save_kinematics { } {
#=============================================================
#This proc is used to save original kinematics variables

  set kin_list { mom_sys_4th_axis_has_limits   mom_sys_5th_axis_has_limits  mom_kin_machine_type \
                 mom_kin_4th_axis_ang_offset   mom_kin_arc_output_mode      mom_kin_4th_axis_direction \
                 mom_kin_4th_axis_incr_switch  mom_kin_4th_axis_leader      mom_kin_4th_axis_limit_action \
                 mom_kin_4th_axis_max_limit    mom_kin_4th_axis_min_incr    mom_kin_4th_axis_min_limit \
                 mom_kin_4th_axis_plane        mom_kin_4th_axis_rotation    mom_kin_4th_axis_type \
                 mom_kin_5th_axis_zero         mom_kin_4th_axis_zero        mom_kin_5th_axis_direction \
                 mom_kin_5th_axis_incr_switch  mom_kin_5th_axis_leader      mom_kin_5th_axis_limit_action \
                 mom_kin_5th_axis_max_limit    mom_kin_5th_axis_min_incr    mom_kin_5th_axis_min_limit \
                 mom_kin_5th_axis_plane        mom_kin_5th_axis_rotation    mom_kin_5th_axis_type \
                 mom_kin_5th_axis_ang_offset   }

  set kin_array_list { mom_kin_4th_axis_center_offset  mom_kin_5th_axis_center_offset   mom_kin_4th_axis_point \
                       mom_kin_5th_axis_point          mom_kin_4th_axis_vector          mom_kin_5th_axis_vector }


 foreach kin_var $kin_list {
    global $kin_var save_$kin_var
    if { [info exists $kin_var] && ![info exists save_$kin_var] } {
       set value [set $kin_var]
       set save_$kin_var $value
    }
 }

 foreach kin_var $kin_array_list {
    global $kin_var save_$kin_var
    if { [array exists $kin_var] && ![array exists save_$kin_var] } {
       set save_var save_$kin_var
       VMOV 3 $kin_var $save_var
    }
 }
}


#=============================================================
proc PB_CMD_save_last_z { } {
#=============================================================
# Capture previous z height for use in cycles and helix move
# can't always use the simple mom_prev_pos in cycles so need
# a dedicated variable

   global mom_pos
   global js_prev_pos            ;# diy previous Z height

   if { [info exists mom_pos(2)] } {
      set js_prev_pos $mom_pos(2)
   } else {
      set js_prev_pos 0           ;# irrelevant if not yet set
   }
}


#=============================================================
proc PB_CMD_set_csys { } {
#=============================================================
# This command is used to get the machine zero point and calculate the local csys origin coord.
   global mom_logname
   global mom_special_output
   global mom_mcs_info
   global mom_mcsname_attach_opr
   global mom_operation_name
   global mom_parent_csys_matrix
   global mom_kin_coordinate_system_type
   global main_mcs_matrix main_mcs_origin
   global mom_csys_origin
   global mom_sim_result mom_sim_result1
   global dpp_TNC_fixture_origin

# get Machine zero matrix and origin
   catch {MOM_ask_machine_zero_junction_name}
   if {[info exists mom_sim_result] && $mom_sim_result != ""} {
      MOM_ask_init_junction_xform $mom_sim_result

   set i 0
   foreach value $mom_sim_result {
      set main_mcs_matrix($i) $value
      incr i
   }

   set i 0
   foreach value $mom_sim_result1 {
      set main_mcs_origin($i) $value
      incr i
   }
   } else {
      MOM_output_to_listing_device "No machine zero junction!"
      set dpp_TNC_fixture_origin(0) 0
      set dpp_TNC_fixture_origin(1) 0
      set dpp_TNC_fixture_origin(2) 0
return
   }

   MOM_ask_mcs_info

   set mcs_name $mom_mcsname_attach_opr($mom_operation_name)

   global operation_csys_origin local_csys_origin
   set operation_csys_origin(0) $mom_mcs_info($mcs_name,org,0)
   set operation_csys_origin(1) $mom_mcs_info($mcs_name,org,1)
   set operation_csys_origin(2) $mom_mcs_info($mcs_name,org,2)

   set local_csys_origin(0) [expr $operation_csys_origin(0)-$main_mcs_origin(0)]
   set local_csys_origin(1) [expr $operation_csys_origin(1)-$main_mcs_origin(1)]
   set local_csys_origin(2) [expr $operation_csys_origin(2)-$main_mcs_origin(2)]

   #Convert offset from ABS to Machine MCS
   set origin_v(0) [expr $mom_mcs_info($mcs_name,org,0) - $main_mcs_origin(0)]
   set origin_v(1) [expr $mom_mcs_info($mcs_name,org,1) - $main_mcs_origin(1)]
   set origin_v(2) [expr $mom_mcs_info($mcs_name,org,2) - $main_mcs_origin(2)]
   MTX3_vec_multiply origin_v main_mcs_matrix local_csys_origin
   if {[info exists mom_kin_coordinate_system_type] && $mom_kin_coordinate_system_type == "CSYS"} {
      global mom_parent_csys_matrix mom_parent_csys_origin
      if {[array exists mom_parent_csys_matrix]} {
         VMOV 12 mom_parent_csys_matrix csys_matrix
         for {set i 0} {$i<3} {incr i} {
            set local_csys_origin($i) [expr $local_csys_origin($i)-$mom_parent_csys_origin($i)  ]
             }
            VMOV 3  mom_parent_csys_origin mom_csys_origin
         }
      }

   set dpp_TNC_fixture_origin(0) [format %.3f "$local_csys_origin(0)"]
   set dpp_TNC_fixture_origin(1) [format %.3f "$local_csys_origin(1)"]
   set dpp_TNC_fixture_origin(2) [format %.3f "$local_csys_origin(2)"]

}


#=============================================================
proc PB_CMD_set_cycle_plane { } {
#=============================================================
# Use this command to determine and output proper plane code
# when G17/18/19 is used in the cycle definition.
#
# <04-15-08 gsl> - Add initialization for protection
# <03-06-08 gsl> - Declare needed global variables
# <02-28-08 gsl> - Make use of mom_spindle_axis
# <06-22-09 gsl> - Call PB_CMD_set_principal_axis
#

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # This option can be set to 1, if the address of cycle's
  # principal axis needs to be suppressed. (Ex. Siemens controller)
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   set suppress_principal_axis 0


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # This option can be set to 1, if the plane code needs
  # to be forced out @ the start of every set of cycles.
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++
   set force_plane_code 0

   global mom_cycle_spindle_axis
   global dpp_clearance_flag

   PB_CMD_set_principal_axis

   switch $mom_cycle_spindle_axis {
      0 {
         set principal_axis X
      }
      1 {
         set principal_axis Y
      }
      2 {
         set principal_axis Z
      }
      default {
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
proc PB_CMD_set_default_dpp_value { } {
#=============================================================
# This command is used to initialize the default value of some status variables used in post processor.
# This command will be called in start of program and end of path.
# Some varialbe should not be reset at the end of path.
# There is no need for customers to change anything in this command, unless you know what you are doing!

# param dpp_TNC_datum_ude_defined
  # Descrptions: This variable is used to record whether datum output setting UDE has been used.
  # This variable should only be reset to zero at the start of program.
  # Entries:
     # 0:     Datum output setting UDE has not been used.
     # 1:     Datum output setting UDE has been used.

# param dpp_TNC_local_offset_flag
  # Descrptions: This variable is used to record the local offset status.
  # Entries:
     # 0:     There is no local offset detected.
     # 1:     Thers is local offset detected.

# param dpp_TNC_plane_change_in_rapid
  # Descrptions: This variable is used to record whether work plane changed in rapid move.
  # Entries:
     # 0:     Work plane didn't change in rapid move.
     # 1:     Work plane changed in rapid move.

# param dpp_TNC_Q203_pos
  # Descrptions: This variable is used to record the surface plane height in drilling cycle, in case mom_pos(2) changes.

# param dpp_ge(toolpath_axis_num)
  # Descrptions: This variable is used to define how many axis move simultaneously.
  # Entries:
     # 3:     3 axis simultaneous tool path
     # 5:     4-5 axis simultaneous tool path

# param dpp_ge(coord_rot)
  # Descrptions: This variable is used to define the programming coordinate system.
  # Entries:
     # NONE
     # LOCAL_CSYS:     The programming coordinate system is CSYS
     # AUTO_3D:        The programming coordinate system is determined by tool axis which is not parallel to Z axis

# param dpp_ge(cycle_clearance_plane)
  # Descrptions: This variable is used to record if clearance plane is defined in drilling cycles.
  # Entries:
     # TRUE:     Clearance plane is defined.
     # FALSE:    Clearance plane is not defined.

# <06-18-2013 Jason> - Initial version

  global dpp_ge
  global last_F
  global last_RPM
  global dpp_TNC_datum_ude_defined
  global dpp_TNC_local_offset_flag

  global mom_sys_in_operation
  if { ![info exists mom_sys_in_operation] } {
     set last_F 0.0
     set last_RPM 0.0
     set dpp_TNC_datum_ude_defined 0
     set dpp_ge(prev_coord_offset,0)   0.0
     set dpp_ge(prev_coord_offset,1)   0.0
     set dpp_ge(prev_coord_offset,2)   0.0
     set dpp_TNC_local_offset_flag 0
  }

  global dpp_TNC_plane_change_in_rapid
  set dpp_TNC_plane_change_in_rapid 0

  global dpp_TNC_Q203_pos
  set dpp_TNC_Q203_pos 0.0

  set dpp_ge(toolpath_axis_num) 3
  set dpp_ge(coord_rot) "NONE"
  set dpp_ge(cycle_clearance_plane) "TRUE"
  set dpp_ge(coord_rot_angle,0) 0.0
  set dpp_ge(coord_rot_angle,1) 0.0
  set dpp_ge(coord_rot_angle,2) 0.0
  set dpp_ge(prev_coord_rot_angle,0) 0.0
  set dpp_ge(prev_coord_rot_angle,1) 0.0
  set dpp_ge(prev_coord_rot_angle,2) 0.0
  set dpp_ge(coord_offset,0)   0.0
  set dpp_ge(coord_offset,1)   0.0
  set dpp_ge(coord_offset,2)   0.0

}


#=============================================================
proc PB_CMD_set_output_unit { } {
#=============================================================
# Defines unit string to be output in "BEGIN PGM" & "END PGM" statements

   global mom_output_unit
   global mom_user_output_unit

   switch $mom_output_unit {
      IN {
         set mom_user_output_unit INCH
      }
      MM {
         set mom_user_output_unit MM
      }
   }
}


#=============================================================
proc PB_CMD_set_principal_axis { } {
#=============================================================
# This command can be used to determine the principal axis.
#
# <06-22-09 gsl> - Extracted from PB_CMD_set_cycle_plane
#

   global mom_cycle_spindle_axis
   global mom_spindle_axis
   global mom_cutcom_plane mom_pos_arc_plane


  # Initialization as protection
   global mom_sys_spindle_axis
   if { ![info exists mom_sys_spindle_axis] } {
      set mom_sys_spindle_axis(0) 0.0
      set mom_sys_spindle_axis(1) 0.0
      set mom_sys_spindle_axis(2) 1.0
   }
   if { ![info exists mom_spindle_axis] } {
      VMOV 3 mom_sys_spindle_axis mom_spindle_axis
   }


  # Default cycle spindle axis to Z
   set mom_cycle_spindle_axis 2


   if { [EQ_is_equal [expr abs($mom_spindle_axis(0))] 1.0] } {
      set mom_cycle_spindle_axis 0
   }

   if { [EQ_is_equal [expr abs($mom_spindle_axis(1))] 1.0] } {
      set mom_cycle_spindle_axis 1
   }


   switch $mom_cycle_spindle_axis {
      0 {
         set mom_cutcom_plane  YZ
         set mom_pos_arc_plane YZ
      }
      1 {
         set mom_cutcom_plane  ZX
         set mom_pos_arc_plane ZX
      }
      2 {
         set mom_cutcom_plane  XY
         set mom_pos_arc_plane XY
      }
      default {
         set mom_cutcom_plane  UNDEFINED
         set mom_pos_arc_plane UNDEFINED
      }
   }
}


#=============================================================
proc PB_CMD_spindle_orient { } {
#=============================================================
# This command is used to add a MOM handler about positioning spindle, should be added to start of program.
# Revisions:
#-----------
# 2015-04-09 Jintao - Initial implementation


 if { ![llength [info commands VECTOR_ROTATE]] } {
uplevel #0 {
     #=============================================================
     proc VECTOR_ROTATE { axis angle input_vector output_vector } {
     #=============================================================
     #This proc is used to rotating a vector about arbitrary axis.
      upvar $axis r; upvar $input_vector input ; upvar $output_vector output
      #set up matrix to rotate about an arbitrary axis
      set m(0) [expr $r(0)*$r(0)*(1-cos($angle))+cos($angle)]
      set m(1) [expr $r(0)*$r(1)*(1-cos($angle))-$r(2)*sin($angle)]
      set m(2) [expr $r(0)*$r(2)*(1-cos($angle))+$r(1)*sin($angle)]
      set m(3) [expr $r(0)*$r(1)*(1-cos($angle))+$r(2)*sin($angle)]
      set m(4) [expr $r(1)*$r(1)*(1-cos($angle))+cos($angle)]
      set m(5) [expr $r(1)*$r(2)*(1-cos($angle))-$r(0)*sin($angle)]
      set m(6) [expr $r(0)*$r(2)*(1-cos($angle))-$r(1)*sin($angle)]
      set m(7) [expr $r(1)*$r(2)*(1-cos($angle))+$r(0)*sin($angle)]
      set m(8) [expr $r(2)*$r(2)*(1-cos($angle))+cos($angle)]
      MTX3_vec_multiply input m output
    }
  };# uplevel
 }

 if { ![llength [info commands SPINDLE_ORIENTATION_ANGLE]] } {
uplevel #0 {
#=======================================================================================================================
proc SPINDLE_ORIENTATION_ANGLE { spindle_orient_ref_axis input_angle rotate_matrix {initial_offset_angle 0} } {
#=======================================================================================================================
# The proc is used to calculate spindle orient output angle value.
# It should be called in MOM_spindle_orient handler.
#
# Input:
#   spindle_orient_ref_axis - X axis of feature csys respect to MCS
#   initial_offset_angle      - initial offset angle between tool insert vector and machine X axis
#                               the default offset angle is 0, post writer can use UDE to customize setting
#   input_angle               - angle between desired insert direction and X axis of feature csys
#   rotate_matrix             - matrix between MTCS and local MCS
#
# Return:
#   angle value of spindle stop position
#
# Revisions:
#-----------
# 2015-04-09 Jintao - Initial implementation

  global mom_kin_machine_type
  global mom_kin_4th_axis_type mom_kin_5th_axis_type
  global mom_kin_4th_axis_direction mom_kin_5th_axis_direction
  global mom_kin_4th_axis_vector mom_kin_5th_axis_vector
  global save_mom_kin_4th_axis_vector save_mom_kin_5th_axis_vector
  global save_mom_kin_machine_type
  global mom_kin_4th_axis_zero mom_kin_5th_axis_zero
  global mom_tool_axis
  global mom_out_angle_pos
  global DEG2RAD
  global RAD2DEG

  upvar $spindle_orient_ref_axis feature_ref_axis
  upvar $rotate_matrix matrix

  if { [string match "3_axis*" $mom_kin_machine_type] } {
     set angle [expr $input_angle - $initial_offset_angle]
     set angle [LIMIT_ANGLE $angle]
     return $angle
  }

  if { ![info exists save_mom_kin_machine_type]} { set save_mom_kin_machine_type $mom_kin_machine_type }

  set v0 0.0; set v1 1.0
  VEC3_init v1 v0 v0 insert_ref_direction
  VEC3_init v0 v0 v0 insert_rotated_direction
  VEC3_init v0 v0 v0 intermediate_vector

# because the rotary axis vector is fliped in core code, when the axis is in the table.
# so we don't need to reverse table angle.
  GET_ROT_ANGLE rot_angle
  if { [info exists mom_kin_4th_axis_type] } {
     if { [string match "SIGN_DETERMINES_DIRECTION" $mom_kin_4th_axis_direction] } {
        set rot_angle(0) [expr abs($rot_angle(0))]
     }
     set rot_angle(0) [expr ($rot_angle(0) - $mom_kin_4th_axis_zero) * $DEG2RAD]
     if { ![info exists save_mom_kin_4th_axis_vector] } {
        VMOV 3 mom_kin_4th_axis_vector save_mom_kin_4th_axis_vector
     }
  }
  if { [info exists mom_kin_5th_axis_type] } {
     if { [string match "SIGN_DETERMINES_DIRECTION" $mom_kin_5th_axis_direction] } {
        set rot_angle(1) [expr abs($rot_angle(1))]
      }
     set rot_angle(1) [expr ($rot_angle(1) - $mom_kin_5th_axis_zero) * $DEG2RAD]
     if { ![info exists save_mom_kin_5th_axis_vector] } {
        VMOV 3 mom_kin_5th_axis_vector save_mom_kin_5th_axis_vector
     }
  }

  switch $save_mom_kin_machine_type {
     5_axis_dual_head {
        global dpp_ge
        if { [info exists dpp_ge(coord_rot)] && [string match "AUTO_3D" $dpp_ge(coord_rot)] } {
           set val $rot_angle(0)
           set rot_angle(0) $rot_angle(1)
           set rot_angle(1) $val
        }
        VECTOR_ROTATE save_mom_kin_5th_axis_vector $rot_angle(1) insert_ref_direction intermediate_vector
        VECTOR_ROTATE save_mom_kin_4th_axis_vector $rot_angle(0) intermediate_vector insert_rotated_direction
     }
     5_axis_head_table -
     5_axis_dual_table {
        VECTOR_ROTATE save_mom_kin_4th_axis_vector $rot_angle(0) insert_ref_direction intermediate_vector
        VECTOR_ROTATE save_mom_kin_5th_axis_vector $rot_angle(1) intermediate_vector insert_rotated_direction
     }
     4_axis_head -
     4_axis_table {
        VECTOR_ROTATE save_mom_kin_4th_axis_vector $rot_angle(0) insert_ref_direction insert_rotated_direction
     }
     default { return 0.0 }
  }
  MTX3_vec_multiply insert_rotated_direction matrix insert_rotated_direction_rot_mcs
  VEC3_unitize insert_rotated_direction_rot_mcs insert_rotated_direction_rot_mcs
  set dot [VEC3_dot insert_rotated_direction_rot_mcs feature_ref_axis]
  if { [EQ_is_ge $dot 1.0] } {
     set angle 0.0
  } elseif { [EQ_is_le $dot -1.0] } {
     set angle 180.0
  } else {
     set angle [expr $RAD2DEG * acos($dot)]
  }
  VEC3_cross feature_ref_axis insert_rotated_direction_rot_mcs cross_vector
  set dot [VEC3_dot cross_vector mom_tool_axis]
  if {  $dot > 0.0 } { set angle [expr -1 * $angle] }
  set angle [expr $input_angle + $angle - $initial_offset_angle]
  set angle [LIMIT_ANGLE $angle]

  return $angle

}; #SPINDLE_ORIENTATION_ANGLE
 };#uplevel
}

 if { ![llength [info commands GET_ROT_LOCAL]] } {
uplevel #0 {
#=======================================
proc GET_ROT_LOCAL { rot_matrix } {
#======================================
# If the operation is under local CSYS rotation, this proc gets the rotation matrix between current coordinate and its parent coordinate
# Otherwise the rotation matrix is unit matrix.
# Revisions:
#-----------
# 2015-04-09 Jintao - Initial implementation

    global mom_parent_csys_matrix
    global mom_kin_coordinate_system_type

    upvar $rot_matrix matrix

    if {[info exists mom_kin_coordinate_system_type] && ![string compare "CSYS" $mom_kin_coordinate_system_type]} {
          VMOV 9 mom_parent_csys_matrix matrix
      } else {
          set matrix(0) 1; set matrix(1) 0; set matrix(2) 0;
          set matrix(3) 0; set matrix(4) 1; set matrix(5) 0;
          set matrix(6) 0; set matrix(7) 0; set matrix(8) 1;
    }
}
 };#uplevel
}
 if { ![llength [info commands GET_ROT_ANGLE]] } {
uplevel #0 {
#============================================
proc GET_ROT_ANGLE { rot_ang } {
#============================================
# This command is used to get rotary axis angle, if the operation is under local CSYS rotation, we need calculate angles, otherwise
# it is mom_out_angle_pos
# Revisions:
#-----------
# 2015-06-08 Jintao - Initial implementation
  global mom_prev_rot_ang_4th mom_kin_4th_axis_direction
  global mom_kin_4th_axis_leader mom_sys_leader
  global mom_kin_4th_axis_min_limit mom_kin_4th_axis_max_limit
  global mom_prev_rot_ang_5th mom_kin_5th_axis_direction
  global mom_kin_5th_axis_leader
  global mom_kin_5th_axis_min_limit mom_kin_5th_axis_max_limit
  global mom_kin_coordinate_system_type
  global mom_parent_csys_matrix
  global mom_kin_machine_type
  global mom_alt_pos
  global mom_mcs_goto
  global mom_out_angle_pos
  global mom_tool_axis
  global seq

  upvar $rot_ang rot_angle
  set rot_angle(0) 0.0; set rot_angle(1) 0.0
  set rot_alt_angle(0) 0.0; set rot_alt_angle(1) 0.0

  if { ![regexp {[0-9]*} $mom_kin_machine_type axis_num] || [EQ_is_lt $axis_num 4] } { return 0 }

  if { [info exists mom_kin_coordinate_system_type] && ![string compare "CSYS" $mom_kin_coordinate_system_type] } {
     MTX3_transpose mom_parent_csys_matrix matrix
     MTX3_vec_multiply mom_tool_axis matrix spindle_axis
     MTX3_vec_multiply mom_mcs_goto matrix mcs_goto
     if { "1" == [MOM_convert_point mcs_goto spindle_axis] } {
        global mom_result
        set i 0
        foreach value $mom_result {
           set pos($i) $value
           incr i
        }
        if { ![info exists mom_prev_rot_ang_4th] } { set mom_prev_rot_ang_4th 0.0 }
           set rot_angle(0)  [ROTSET $pos(3) $mom_prev_rot_ang_4th $mom_kin_4th_axis_direction\
                                     $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)\
                                     $mom_kin_4th_axis_min_limit $mom_kin_4th_axis_max_limit]
        if { [EQ_is_ge $axis_num 5] } {
           if { ![info exists mom_prev_rot_ang_5th] } { set mom_prev_rot_ang_5th 0.0 }
           set rot_angle(1)  [ROTSET $pos(4) $mom_prev_rot_ang_5th $mom_kin_5th_axis_direction\
                                     $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)\
                                     $mom_kin_5th_axis_min_limit $mom_kin_5th_axis_max_limit]
        }
     } else {
        return 0
     }
  } else {
     set rot_angle(0) $mom_out_angle_pos(0)
     set rot_angle(1) $mom_out_angle_pos(1)
  }
  if { [info exists seq] } {
     if { ([string match "SEQ+" $seq] && [EQ_is_lt $rot_angle(0) 0])\
          || ([string match "SEQ-" $seq] && [EQ_is_gt $rot_angle(0) 0]) } {
        global mom_result1

        if { [info exists mom_result1] && [info exists pos] } {
           set i 0
           foreach value $mom_result1 {
              set pos($i) $value
              incr i
           }
        } else {
          set pos(3) $mom_alt_pos(3)
          set pos(4) $mom_alt_pos(4)

        }
        if { ![info exists mom_prev_rot_ang_4th] } { set mom_prev_rot_ang_4th 0.0 }
           set rot_angle(0)  [ROTSET $pos(3) $mom_prev_rot_ang_4th $mom_kin_4th_axis_direction\
                                     $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)\
                                     $mom_kin_4th_axis_min_limit $mom_kin_4th_axis_max_limit]
        if { [EQ_is_ge $axis_num 5] } {
           if { ![info exists mom_prev_rot_ang_5th] } { set mom_prev_rot_ang_5th 0.0 }
           set rot_angle(1)  [ROTSET $pos(4) $mom_prev_rot_ang_5th $mom_kin_5th_axis_direction\
                                     $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)\
                                     $mom_kin_5th_axis_min_limit $mom_kin_5th_axis_max_limit]
        }
      }
  }
  return 1
}
 };#uplevel
}


 if { ![llength [info commands MOM_spindle_orient]] } {
uplevel #0 {
#===============================
proc MOM_spindle_orient { } {
#===============================
# In the back sinking operation, initial tool insert tip is positioned to Machine coordinate X axis positive direction,
# which means the default value of initial offset angle is 0. the post writer can use UDE to customize offset angle
# Revisions:
#-----------
# 2015-04-09 Jintao - Initial implementation
   global mom_spindle_orient_angle
   global mom_spindle_orient_angle_defined
   global mom_spindle_orient_ref_axis
   global mom_msys_matrix

# if mom_kin_coordinate_system_type is "CSYS", then rotate_matrix is mom_parent_csys_matrix. Otherwise it is unit matrix.
#
   GET_ROT_LOCAL rotate_matrix
   MTX3_vec_multiply mom_spindle_orient_ref_axis mom_msys_matrix spindle_orient_ref_axis
   set mom_spindle_orient_angle [SPINDLE_ORIENTATION_ANGLE spindle_orient_ref_axis $mom_spindle_orient_angle rotate_matrix]
   MOM_do_template cycl_def_13_0
   MOM_do_template cycl_def_13_1
   MOM_do_template spindle_orient
   MOM_disable_address M_spindle
} ;# MOM_spindle_orient
 } ;# uplevel
}
}


#=============================================================
proc PB_CMD_start_of_alignment_character { } {
#=============================================================
# Output a special sequence number character. Replace the ":" with any character that you require.
# You must use the command "PB_CMD_end_of_alignment_character" to reset the sequence number back to the original setting.
#
# 07-23-2012 yaoz - Initial version

   global mom_sys_leader saved_seq_num
   set saved_seq_num $mom_sys_leader(N)
   set mom_sys_leader(N) ":"
}


#=============================================================
proc PB_CMD_start_of_operation_force { } {
#=============================================================
   MOM_force once G_motion X Y Z M_spindle F G_cutcom
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
proc PB_CMD_unclamp_fifth_axis { } {
#=============================================================
#  This command is used by auto clamping to output the code
#  needed to unclamp the fifth axis.
#
#  --> Do NOT attach this command to any event marker!
#  --> Do NOT change the name of this command!
#
   MOM_output_literal "M13"
}


#=============================================================
proc PB_CMD_unclamp_fourth_axis { } {
#=============================================================
#  This command is used by auto clamping to output the code
#  needed to unclamp the fourth axis.
#
#  --> Do NOT attach this command to any event marker!
#  --> Do NOT change the name of this command!
#
   MOM_output_literal "M11"
}


#=============================================================
proc PB_CMD_uplevel_ROTARY_AXIS_RETRACT { } {
#=============================================================
  if { ![CMD_EXIST PB_ROTARY_AXIS_RETRACT] && [CMD_EXIST ROTARY_AXIS_RETRACT]} {
     rename ROTARY_AXIS_RETRACT PB_ROTARY_AXIS_RETRACT
  } else {
return
  }

uplevel #0 {
#==============
proc ROTARY_AXIS_RETRACT {} {
#==============
  global mom_prev_pos
  global mom_prev_mcs_goto
  global mom_prev_alt_pos
  global dpp_ge

  if {$dpp_ge(toolpath_axis_num)=="5"} {
     VMOV 3 mom_prev_mcs_goto mom_prev_pos
     VMOV 3 mom_prev_mcs_goto mom_prev_alt_pos
  }
  PB_ROTARY_AXIS_RETRACT

}
};#uplevel 0

}


#=============================================================
proc PB_CMD_verify_RPM { } {
#=============================================================
   global last_RPM mom_spindle_speed

   if { $last_RPM != $mom_spindle_speed } {
      MOM_suppress once T
      MOM_force Once S
      MOM_do_template tool_change
      set last_RPM $mom_spindle_speed
   } else {
      MOM_suppress once M_spindle
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

   if { [EQ_is_equal $min 0.0] && [EQ_is_equal $max 360.0] && ![string compare "MAGNITUDE_DETERMINES_DIRECTION" $dir] } {
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
proc ARR_sort_array_to_list { ARR {by_value 0} } {
#=============================================================
# This command will sort and build a list of elements of an array.
#
#   ARR      : Array Name
#   by_value : 0 Sort elements by names (default)
#              1 Sort elements by values
#
#   Return a list of {name value} couplets
#
   upvar $ARR arr

   set list [list]
   foreach { e v } [array get arr] {
      lappend list "$e $v"
   }

   set val [lindex [lindex $list 0] $by_value]

   if [string is integer "$val"] {
      set list [lsort -integer    -decreasing -index $by_value $list]
   } elseif [string is double "$val"] {
      set list [lsort -real       -decreasing -index $by_value $list]
   } else {
      set list [lsort -dictionary -decreasing -index $by_value $list]
   }

return $list
}


#=============================================================
proc ARR_sort_array_vals { ARR } {
#=============================================================
# This command will sort and build a list of elements of an array.
#
   upvar $ARR arr

   set list [list]
   foreach a [lsort -dictionary [array names arr]] {
      if ![catch {expr $arr($a)}] {
         set val [format "%+.5f" $arr($a)]
      } else {
         set val $arr($a)
      }
      lappend list ($a) $val
   }
return $list
}


#=============================================================
proc AUTO_CLAMP {  } {
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
# called by MOM_rotate & SET_LOCK

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
   if {$num_sol == 0} { return 0 }

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

   if { ![string compare "$caller" [info level -2] ] } {
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
                               $mom_motion_event ($mom_motion_type)\n\    $mom_o_buffer\n\      $call_stack"
      } else {
         set mom_warning_info "$msg\n\  Event $mom_event_number [MOM_ask_event_type] :\
                               $mom_motion_event ($mom_motion_type)\n\    $mom_o_buffer\n\      $call_stack"
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


#=============================================================
proc DELAY_TIME_SET {  } {
#=============================================================
   global mom_sys_delay_param mom_delay_value
   global mom_delay_revs mom_delay_mode delay_time

  # post builder provided format for the current mode:
   if { [info exists mom_sys_delay_param(${mom_delay_mode},format)] } {
      MOM_set_address_format dwell $mom_sys_delay_param(${mom_delay_mode},format)
   }

   switch $mom_delay_mode {
      SECONDS { set delay_time $mom_delay_value }
      default { set delay_time $mom_delay_revs }
   }
}


#=============================================================
proc DPP_GE_CALCULATE_COOR_ROT_ANGLE { mode matrix ang } {
#=============================================================
# The proc is used to is used to calculate the coordinate system rotation angles
# and support coordinate rotation function (G68/ROT/AROT G68.2/CYCLE800/PLANE SPATIAL).
#
# Input:
#   mode   - coordinate rotation mode. Possible value: XYZ, ZXY, ZXZ, ZYX
#   matrix - Local coordinate system 3x3 matrix
#
# Output:
#   ang    - rotation angle array, the order is rotation order
#            ang(0) - first rotation angle value
#            ang(1) - second rotation angle value
#            ang(2) - third rotation angle value
#
# Return:
#   1 - mode is available, 0 - mode is not available
#
# Revisions:
#-----------
# 2013-05-22 lili - Initial implementation
#


    upvar $matrix rotation_matrix
    upvar $ang rot_ang

    global RAD2DEG

    set m0 $rotation_matrix(0)
    set m1 $rotation_matrix(1)
    set m2 $rotation_matrix(2)
    set m3 $rotation_matrix(3)
    set m4 $rotation_matrix(4)
    set m5 $rotation_matrix(5)
    set m6 $rotation_matrix(6)
    set m7 $rotation_matrix(7)
    set m8 $rotation_matrix(8)

    if {$mode == "XYZ"} {
       set cos_b_sq [expr $m0*$m0 + $m3*$m3]

       if { [EQ_is_equal $cos_b_sq 0.0] } {

         set cos_b 0.0
         set cos_a 1.0
         set sin_a 0.0
         set cos_c $m4
         set sin_c [expr -1*$m1]

         if { $m6 < 0.0 } {
           set sin_b 1.0
         } else {
           set sin_b -1.0
         }

       } else {

         set cos_b [expr sqrt($cos_b_sq)]
         set sin_b [expr -$m6]

         set cos_a [expr $m8/$cos_b]
         set sin_a [expr $m7/$cos_b]

         set cos_c [expr $m0/$cos_b]
         set sin_c [expr $m3/$cos_b]

       }

       set A [expr -atan2($sin_a,$cos_a)*$RAD2DEG]
       set B [expr -atan2($sin_b,$cos_b)*$RAD2DEG]
       set C [expr -atan2($sin_c,$cos_c)*$RAD2DEG]

       set rot_ang(0) $A; set rot_ang(1) $B; set rot_ang(2) $C
  return 1
    } elseif {$mode=="ZXY"} {
       set cos_a_sq [expr $m3*$m3 + $m4*$m4]

       if { [EQ_is_equal $cos_a_sq 0.0] } {

          set cos_a 0.0
          set cos_c 1.0
          set sin_c 0.0
          set sin_b $m6
          set cos_b $m0

          if { $m5 < 0.0 } {
             set sin_a -1.0
          } else {
             set sin_a 1.0
          }

        } else {

          set cos_a [expr sqrt($cos_a_sq)]
          set sin_a [expr $m5]

          set cos_b [expr $m8/$cos_a]
          set sin_b [expr -$m2/$cos_a]

          set cos_c [expr $m4/$cos_a]
          set sin_c [expr -$m3/$cos_a]
       }

       set A [expr atan2($sin_a,$cos_a)*$RAD2DEG]
       set B [expr atan2($sin_b,$cos_b)*$RAD2DEG]
       set C [expr atan2($sin_c,$cos_c)*$RAD2DEG]
       set rot_ang(0) $C; set rot_ang(1) $A; set rot_ang(2) $B
  return 1
    } elseif {$mode=="ZYX"} {
        if {[EQ_is_equal [expr abs($m2)] 1.0]} {
           set C [expr atan2([expr -1*$m3],$m4)]
        } else {
           set C [expr atan2($m1,$m0)]
        }

        set length [expr sqrt($m0*$m0 + $m1*$m1)]
        set B [expr -1*atan2($m2,$length)]
        set cos_B [expr cos($B)]

        if {![EQ_is_zero $cos_B]} {
           set A [expr atan2($m5/$cos_B,$m8/$cos_B)]
        } else {
           set A 0.0
        }

        set A [expr $A*$RAD2DEG]
        set B [expr $B*$RAD2DEG]
        set C [expr $C*$RAD2DEG]
        set rot_ang(0) $C; set rot_ang(1) $B; set rot_ang(2) $A
     } elseif {$mode=="ZXZ"} {
        set sin_b_sq [expr $m2*$m2 + $m5*$m5]

        if { [EQ_is_equal $sin_b_sq 0.0] } {
           set cos_b 1.0
           set sin_b 0.0
           set sin_c 0.0
           set cos_c 1.0
           set sin_a $m1
           if {$m8>0} {
              set cos_b 1.0
              set cos_a $m0
           } else {
              set cos_b -1.0
              set cos_a -$m4
           }
        } else {
           set sin_b [expr sqrt($sin_b_sq)]
           set cos_b [expr $m8]

           set cos_a [expr -$m7/$sin_b]
           set sin_a [expr $m6/$sin_b]

           set cos_c [expr $m5/$sin_b]
           set sin_c [expr $m2/$sin_b]
        }

        set A [expr atan2($sin_a,$cos_a)*$RAD2DEG]
        set B [expr atan2($sin_b,$cos_b)*$RAD2DEG]
        set C [expr atan2($sin_c,$cos_c)*$RAD2DEG]

        set rot_ang(0) $A; set rot_ang(1) $B; set rot_ang(2) $C
  return 1
    } else {
  return 0
    }
}


#=============================================================
proc DPP_GE_COOR_ROT { ang_mode rot_angle offset pos } {
#=============================================================
# This proc is used to detect if operation has coordinate rotation.
# DPP_GE_COOR_ROT_LOCAL, DPP_GE_COOR_ROT_AUTO3D, DPP_GE_CALCULATE_COOR_ROT_ANGLE are called in this proc.
#
# Input:
#   ang_mode -  coordinate matrix rotation method. Possible value: XYZ, ZXY, ZXZ, ZYX
#
# Output:
#   rot_angle - rotation angle array
#               rot_angle(0) is first rotation angle value
#               rot_angle(1) is second rotation angle value
#               rot_angle(2) is third rotation angle value
#   coord_offset - linear coordinate offset from current local CSYS rotation coordinate to parent coordinate.
#   pos - linear axes position respect to rotated cooridnate
#
# Return:
#   detected coordinate mode. Possible value: NONE, LOCAL, AUTO_3D
#   NONE - no coordinate rotation
#   LOCAL - coordinate rotation set up by LOCAL CSYS MCS
#   AUTO_3D - coordinate rotation set up by tilt work plane
#
# Revisions:
#-----------
# 2013-05-22 lili - Initial implementation
#

   upvar $rot_angle angle
   upvar $pos rot_pos
   upvar $offset coord_offset

   global mom_pos
   VMOV 3 mom_pos rot_pos

   set v0 0
   VEC3_init v0 v0 v0 coord_offset

   if {[DPP_GE_COOR_ROT_LOCAL rot_matrix coord_offset]} {
      set coord_rot "LOCAL"
   } elseif {[DPP_GE_COOR_ROT_AUTO3D rot_matrix rot_pos]} {
      set coord_rot "AUTO_3D"
   } else {
      set coord_rot "NONE"
   }

   if {[string compare "NONE" $coord_rot]} {
      DPP_GE_CALCULATE_COOR_ROT_ANGLE $ang_mode rot_matrix angle
   } else {
      set angle(0) 0.0
      set angle(1) 0.0
      set angle(2) 0.0
   }
   return $coord_rot
}


#=============================================================
proc DPP_GE_COOR_ROT_AUTO3D { rot_matrix rot_pos } {
#=============================================================
# This proc is used to detect if operation is 3+2 operation without Local CSYS rotation coordinate system.
# It will return rotation matrix and current position respect to rotated coordinate system. The machine kinemtaics
# will be reloaded to dual table machine.
# Rotation matrix calculated by current rotary axes angle and 4th,5th axis vector.
#
# Output:
#   rot_matrix - rotation matrix, mapping from the current rotation coordinate to parent coordinate(G54,G55..).
#   rot_pos    - current position respect to rotated coordinate system
#   * kinemtics - machine's kinematics will be reloaded to 5_axis_dual_table
#
# Return:
#   1 - operation is 3+2 operation without Local CSYS rotation coordinate system.
#   0 - operation is not 3+2 operation without Local CSYS rotation coordinate system.
#
# Revisions:
#-----------
# 2013-05-22 lili - Initial implementation
# 2013-10-16 levi - Reload mom_prev_pos when exchanging the pos of 4th axis and 5th axis for dual head machine.
# 2014-12-04 lili - Fix mom_kin_xth_axis_zero issue.
#
   upvar $rot_matrix matrix
   upvar $rot_pos pos

   global mom_kin_coordinate_system_type
   global mom_kin_machine_type
   global mom_kin_4th_axis_point mom_kin_5th_axis_point
   global mom_kin_4th_axis_vector mom_kin_5th_axis_vector
   global mom_out_angle_pos mom_prev_out_angle_pos
   global DEG2RAD
   global mom_pos mom_mcs_goto mom_prev_pos
   global mom_kin_4th_axis_zero mom_kin_5th_axis_zero

   set v0 0.0; set v1 1.0
   VEC3_init v1 v0 v0 X
   VEC3_init v0 v1 v0 Y
   VEC3_init v0 v0 v1 Z
   MTX3_init_x_y_z X Y Z matrix
   VMOV 3 mom_pos pos

   if { ![string match "*5_axis*" $mom_kin_machine_type] } {
      return 0
   }

   if {[info exists mom_kin_coordinate_system_type] && ![string compare "CSYS" $mom_kin_coordinate_system_type]} {
      return 0
   } else {
      if {(![EQ_is_zero $mom_out_angle_pos(0)] && ![VEC3_is_equal mom_kin_4th_axis_vector Z]) || \
          (![EQ_is_zero $mom_out_angle_pos(1)] && ![VEC3_is_equal mom_kin_5th_axis_vector Z]) } {
      } else {
         return 0
      }
   }


   # Save kinematics
   DPP_GE_SAVE_KINEMATICS

   # get rotation angle
   if { [string match "5_axis_dual_head" $mom_kin_machine_type] } {
      # Swap rotary axes kinematics for dual head machine
      DPP_GE_SWAP_4TH_5TH_KINEMATICS
      set ang_pos(0) $mom_out_angle_pos(1)
      set ang_pos(1) $mom_out_angle_pos(0)
      # Swap rotary axes value due to kinemtics switched
      set mom_out_angle_pos(0) $ang_pos(0)
      set mom_out_angle_pos(1) $ang_pos(1)
      set mom_prev_out_angle_pos(0) $ang_pos(0)
      set mom_prev_out_angle_pos(1) $ang_pos(1)
      set mom_pos(3) $ang_pos(0)
      set mom_pos(4) $ang_pos(1)
      set mom_prev_pos(3) $ang_pos(0)
      set mom_prev_pos(4) $ang_pos(1)
      MOM_reload_variable -a mom_out_angle_pos
      MOM_reload_variable -a mom_prev_out_angle_pos
      MOM_reload_variable -a mom_pos
      MOM_reload_variable -a mom_prev_pos
   } else {
      set ang_pos(0) $mom_out_angle_pos(0)
      set ang_pos(1) $mom_out_angle_pos(1)
   }

   set rot0 [expr ($ang_pos(0)-$mom_kin_4th_axis_zero)*$DEG2RAD]
   set rot1 [expr ($ang_pos(1)-$mom_kin_5th_axis_zero)*$DEG2RAD]

   # Reolad kinematics to dual-table machine
   if { ![string match "5_axis_dual_table" $mom_kin_machine_type] } {
     set mom_kin_machine_type "5_axis_dual_table"
   }

   set v0 0.0
   VEC3_init v0 v0 v0 mom_kin_4th_axis_point
   VEC3_init v0 v0 v0 mom_kin_5th_axis_point
   MOM_reload_kinematics

   # Get current position respect to rotated coordinate
   VECTOR_ROTATE mom_kin_5th_axis_vector [expr -1*$rot1] mom_mcs_goto V
   VECTOR_ROTATE mom_kin_4th_axis_vector [expr -1*$rot0] V pos

if {0} {
   # recalculate Z value for driling cycle initial move without clearance plane.
   global cycle_init_flag mom_current_motion mom_cycle_rapid_to
   if {[info exists cycle_init_flag] && $cycle_init_flag == "TRUE"} {
      if { ![string compare "initial_move" $mom_current_motion]} {
         set pos(2) [expr $pos(2) + $mom_cycle_rapid_to]
      }
   }
}

  # Calculate rotation matrix
   VECTOR_ROTATE mom_kin_4th_axis_vector $rot0 X V1
   VECTOR_ROTATE mom_kin_4th_axis_vector $rot0 Y V2
   VECTOR_ROTATE mom_kin_4th_axis_vector $rot0 Z V3

   VECTOR_ROTATE mom_kin_5th_axis_vector $rot1 V1 X
   VECTOR_ROTATE mom_kin_5th_axis_vector $rot1 V2 Y
   VECTOR_ROTATE mom_kin_5th_axis_vector $rot1 V3 Z

   MTX3_init_x_y_z X Y Z matrix

   return 1

}


#=============================================================
proc DPP_GE_COOR_ROT_LOCAL { rot_matrix coord_offset } {
#=============================================================
# This proc is used to detect if operation is under local CSYS rotation and if the coordinate is rotated.
# It will return rotation matrix.
#
# Output:
#   rot_matrix - rotation matrix, mapping from the current local CSYS rotation coordinate to parent coordinate.
#   coord_offset - linear coordinate offset from current local CSYS rotation coordinate to parent coordinate.
#
# Return:
#   1 - operation is under local CSYS rotation coordinate system and the coordinate is rotated.
#   0 - operation is not under local CSYS rotation coordinate system or the coordinate is not rotated.
#
# Revisions:
#-----------
# 2013-05-22 lili - Initial implementation
#
   upvar $rot_matrix matrix
   upvar $coord_offset offset

   global mom_csys_matrix mom_csys_origin
   global mom_kin_coordinate_system_type
   global mom_parent_csys_matrix
   global mom_part_unit mom_output_unit

   set v0 0; set v1 1
   VEC3_init v1 v0 v0 VX
   VEC3_init v0 v1 v0 VY
   VEC3_init v0 v0 v1 VZ
   MTX3_init_x_y_z VX VY VZ matrix
   MTX3_init_x_y_z VX VY VZ rr_matrix

   if {[info exists mom_kin_coordinate_system_type] && ![string compare "CSYS" $mom_kin_coordinate_system_type]} {
      if {[array exists mom_parent_csys_matrix]} {
         VMOV 9 mom_parent_csys_matrix matrix

         if {![string compare $mom_part_unit $mom_output_unit]} {
            set unit_conversion 1
         } elseif { ![string compare "IN" $mom_output_unit] } {
            set unit_conversion [expr 1.0/25.4]
         } else {
            set unit_conversion 25.4
         }
         set offset(0) [expr $unit_conversion*$mom_parent_csys_matrix(9)]
         set offset(1) [expr $unit_conversion*$mom_parent_csys_matrix(10)]
         set offset(2) [expr $unit_conversion*$mom_parent_csys_matrix(11)]

      } else {
         VMOV 9 mom_csys_matrix matrix
         VMOV 3 mom_csys_origin offset
      }
      if {[MTX3_is_equal matrix rr_matrix]} {
         return 0
      } else {
         return 1
      }
   } else {
      return 0
   }

}


#=============================================================
proc DPP_GE_DEBUG { args } {
#=============================================================
#This proc is used to debug.
#<12-03-2012 Allen> - Initial version
   foreach dpp_input_var  $args {
     upvar $dpp_input_var  dpp_output_var
     MOM_output_to_listing_device " [format "%-30s  %-40s %-30s " $dpp_input_var  $dpp_output_var [info level [expr [info level]-1]] ]"
   }
}


#=============================================================
proc DPP_GE_DETECT_4AXIS_TOOL_PATH {  } {
#=============================================================
# This proc is used to detect the if operation is 5 axis simultaneous milling operation.
# In this command, tool path type is detected by mom_operation_type, mom_tool_path_type and mom_tool_axis_type
# The result may not always match 5-axis simultaneous milling. It is more tolerance.
#
# Return:
#   1 - tool path is 5 axis simultaneous
#   0 - tool path is not 5 axis simultaneous
#
# Revisions:
#-----------
# 2013-05-22 lili - Initial implementation
#

  global mom_tool_axis_type
  global mom_tool_path_type
  global mom_operation_type

  if { ![info exists mom_tool_axis_type] } {
     set mom_tool_axis_type 0
  }
  if {![info exists mom_tool_path_type]} {
     set mom_tool_path_type "undefined"
  }

  if { [DPP_GE_DETECT_HOLE_CUTTING_OPERATION]} {
     return 0
  } elseif { ($mom_tool_axis_type >=2 && [string match "Variable-axis *" $mom_operation_type]) ||\
          ![string compare "Sequential Mill Main Operation" $mom_operation_type] || \
          (![string compare "variable_axis" $mom_tool_path_type] && ![string match "Variable-axis *" $mom_operation_type])} {
     return 1
  } else {
     return 0
  }


}


#=============================================================
proc DPP_GE_DETECT_5AXIS_TOOL_PATH {  } {
#=============================================================
# This proc is used to detect the if operation is 5 axis simultaneous milling operation.
# In this command, tool path type is detected by mom_operation_type, mom_tool_path_type and mom_tool_axis_type
# The result may not always match 5-axis simultaneous milling. It is more tolerance.
#
# Return:
#   1 - tool path is 5 axis simultaneous
#   0 - tool path is not 5 axis simultaneous
#
# Revisions:
#-----------
# 2013-05-22 lili - Initial implementation
#

  global mom_tool_axis_type
  global mom_tool_path_type
  global mom_operation_type

  if { ![info exists mom_tool_axis_type] } {
     set mom_tool_axis_type 0
  }
  if {![info exists mom_tool_path_type]} {
     set mom_tool_path_type "undefined"
  }

  if { [DPP_GE_DETECT_HOLE_CUTTING_OPERATION]} {
     return 0
  } elseif { ($mom_tool_axis_type >=2 && [string match "Variable-axis *" $mom_operation_type]) ||\
          ![string compare "Sequential Mill Main Operation" $mom_operation_type] || \
          (![string compare "variable_axis" $mom_tool_path_type] && ![string match "Variable-axis *" $mom_operation_type])} {
     return 1
  } else {
     return 0
  }

}


#=============================================================
proc DPP_GE_DETECT_HOLE_CUTTING_OPERATION {  } {
#=============================================================
# This proc is used to detect if the operation is a hole cutting operation.
# Hole cutting operation includs Cylinder Milling, Thread Milling, Point to Point,
# Hole Making, Drilling
#
# Return:
#   1 - operation is hole cutting operation
#   0 - operation is not hole cutting operation
#
# Revisions:
#-----------
# 2013-05-22 lili - Initial implementation
# 2015-04-22 Jintao - PR7281995 add Chamfer Milling and Radial Groove Milling
#

  global mom_operation_type
  if {![string compare "Hole Making" $mom_operation_type] || ![string compare "Point to Point" $mom_operation_type] || \
      ![string compare "Cylinder Milling" $mom_operation_type] || ![string compare "Thread Milling" $mom_operation_type] || \
      ![string compare "Drilling" $mom_operation_type] || ![string compare "Chamfer Milling" $mom_operation_type] || \
      ![string compare "Radial Groove Milling" $mom_operation_type]} {
     return 1
  } else {
     return 0
  }

}


#=============================================================
proc DPP_GE_DETECT_TOOL_PATH_TYPE {  } {
#=============================================================
# This proc is used to set dpp_ge(toolpath_axis_num)

  global dpp_ge
  if {[DPP_GE_DETECT_5AXIS_TOOL_PATH]} {
     set dpp_ge(toolpath_axis_num) 5
  } else {
     set dpp_ge(toolpath_axis_num) 3
  }
}


#=============================================================
proc DPP_GE_RESTORE_KINEMATICS {  } {
#=============================================================
#This proc is used to restore original kinematics variables and sys variables.
# 2013-10-16 levi - Exchange the pos of 4th axis and 5th axis when restore kinematics for dual head machine.

 global save_mom_kin_machine_type
 global mom_kin_machine_type
 global mom_out_angle_pos
 global mom_pos
 global mom_prev_out_angle_pos
 global mom_prev_pos

# if it's dual-head machine, exchange the angle pos for 4th axis and 5th axis for the first point after auto3d
 if { [string match "5_axis_dual_head" $save_mom_kin_machine_type] && ![string match $save_mom_kin_machine_type $mom_kin_machine_type]} {
    set temp $mom_out_angle_pos(0)
    set mom_out_angle_pos(0) $mom_out_angle_pos(1)
    set mom_out_angle_pos(1) $temp
 }
 VMOV 2 mom_out_angle_pos mom_prev_out_angle_pos
 set mom_pos(3) $mom_out_angle_pos(0)
 set mom_pos(4) $mom_out_angle_pos(1)
 set mom_prev_pos(3) $mom_out_angle_pos(0)
 set mom_prev_pos(4) $mom_out_angle_pos(1)
 MOM_reload_variable -a mom_out_angle_pos
 MOM_reload_variable -a mom_prev_out_angle_pos
 MOM_reload_variable -a mom_pos
 MOM_reload_variable -a mom_prev_pos

 set kin_list {  mom_sys_4th_axis_has_limits   mom_sys_5th_axis_has_limits  mom_kin_machine_type \
                 mom_kin_4th_axis_ang_offset   mom_kin_arc_output_mode      mom_kin_4th_axis_direction \
                 mom_kin_4th_axis_incr_switch  mom_kin_4th_axis_leader      mom_kin_4th_axis_limit_action \
                 mom_kin_4th_axis_max_limit    mom_kin_4th_axis_min_incr    mom_kin_4th_axis_min_limit \
                 mom_kin_4th_axis_plane        mom_kin_4th_axis_rotation    mom_kin_4th_axis_type \
                 mom_kin_5th_axis_zero         mom_kin_4th_axis_zero        mom_kin_5th_axis_direction \
                 mom_kin_5th_axis_incr_switch  mom_kin_5th_axis_leader      mom_kin_5th_axis_limit_action \
                 mom_kin_5th_axis_max_limit    mom_kin_5th_axis_min_incr    mom_kin_5th_axis_min_limit \
                 mom_kin_5th_axis_plane        mom_kin_5th_axis_rotation    mom_kin_5th_axis_type \
                 mom_kin_5th_axis_ang_offset   mom_kin_helical_arc_output_mode }

  set kin_array_list { mom_kin_4th_axis_center_offset  mom_kin_5th_axis_center_offset   mom_kin_4th_axis_point \
                       mom_kin_5th_axis_point          mom_kin_4th_axis_vector          mom_kin_5th_axis_vector \
                       mom_kin_spindle_axis }



 foreach kin_var $kin_list {
    global $kin_var save_$kin_var
    if {[info exists save_$kin_var]} {
       set value [set save_$kin_var]
       set $kin_var $value
       #unset save_$kin_var
    }
 }

 foreach kin_var $kin_array_list {
    global $kin_var save_$kin_var
    if {[array exists save_$kin_var]} {
       set save_var save_$kin_var
       VMOV 3 $save_var $kin_var
       #UNSET_VARS $save_var
    }
 }

 global mom_sys_leader save_mom_sys_leader
 if {[info exists mom_kin_4th_axis_leader] && [info exists mom_kin_5th_axis_leader]} {
    set mom_sys_leader(fourth_axis) $mom_kin_4th_axis_leader
    set mom_sys_leader(fifth_axis) $mom_kin_5th_axis_leader
 }
 if {[info exists mom_kin_4th_axis_leader] && [info exists mom_kin_5th_axis_leader]} {
    set mom_sys_leader(fourth_axis) $mom_kin_4th_axis_leader
    set mom_sys_leader(fifth_axis) $mom_kin_5th_axis_leader
 }

  if {[info exists save_mom_sys_leader(fourth_axis_home)]} {
     set mom_sys_leader(fourth_axis_home) $save_mom_sys_leader(fourth_axis_home)
  }
  if {[info exists save_mom_sys_leader(fifth_axis_home)]} {
     set mom_sys_leader(fifth_axis_home) $save_mom_sys_leader(fifth_axis_home)
  }

  MOM_reload_kinematics
}


#=============================================================
proc DPP_GE_SAVE_KINEMATICS {  } {
#=============================================================
#This proc is used to save original kinematics variables

  set kin_list { mom_sys_4th_axis_has_limits   mom_sys_5th_axis_has_limits  mom_kin_machine_type \
                 mom_kin_4th_axis_ang_offset   mom_kin_arc_output_mode      mom_kin_4th_axis_direction \
                 mom_kin_4th_axis_incr_switch  mom_kin_4th_axis_leader      mom_kin_4th_axis_limit_action \
                 mom_kin_4th_axis_max_limit    mom_kin_4th_axis_min_incr    mom_kin_4th_axis_min_limit \
                 mom_kin_4th_axis_plane        mom_kin_4th_axis_rotation    mom_kin_4th_axis_type \
                 mom_kin_5th_axis_zero         mom_kin_4th_axis_zero        mom_kin_5th_axis_direction \
                 mom_kin_5th_axis_incr_switch  mom_kin_5th_axis_leader      mom_kin_5th_axis_limit_action \
                 mom_kin_5th_axis_max_limit    mom_kin_5th_axis_min_incr    mom_kin_5th_axis_min_limit \
                 mom_kin_5th_axis_plane        mom_kin_5th_axis_rotation    mom_kin_5th_axis_type \
                 mom_kin_5th_axis_ang_offset   mom_kin_helical_arc_output_mode }
  set kin_array_list { mom_kin_4th_axis_center_offset  mom_kin_5th_axis_center_offset   mom_kin_4th_axis_point \
                       mom_kin_5th_axis_point          mom_kin_4th_axis_vector          mom_kin_5th_axis_vector }


  foreach kin_var $kin_list {
    global $kin_var save_$kin_var
    if {[info exists $kin_var] && ![info exists save_$kin_var]} {
       set value [set $kin_var]
       set save_$kin_var $value
    }
  }

  foreach kin_var $kin_array_list {
    global $kin_var save_$kin_var
    if {[array exists $kin_var] && ![array exists save_$kin_var]} {
       set save_var save_$kin_var
       VMOV 3 $kin_var $save_var
    }
  }

  global mom_sys_leader save_mom_sys_leader
  if {[info exists mom_sys_leader(fourth_axis_home)] && ![info exists save_mom_sys_leader(fourth_axis_home)]} {
     set save_mom_sys_leader(fourth_axis_home) $mom_sys_leader(fourth_axis_home)
  }
  if {[info exists mom_sys_leader(fifth_axis_home)] && ![info exists save_mom_sys_leader(fifth_axis_home)]} {
     set save_mom_sys_leader(fifth_axis_home) $mom_sys_leader(fifth_axis_home)
  }


}


#=============================================================
proc DPP_GE_SWAP_4TH_5TH_KINEMATICS {  } {
#=============================================================
#This proc is used to swap 4th and 5th axis kinematics variables
  set kin_list { ang_offset   direction leader  incr_switch  \
                 limit_action max_limit min_incr min_limit \
                 plane        rotation  zero}

  set kin_array_list { center_offset point vector}

 foreach kin_var $kin_list {
    global mom_kin_4th_axis_$kin_var save_mom_kin_4th_axis_$kin_var
    global mom_kin_5th_axis_$kin_var save_mom_kin_5th_axis_$kin_var
    if {[info exists save_mom_kin_4th_axis_$kin_var] && [info exists save_mom_kin_5th_axis_$kin_var]} {
       set mom_kin_4th_axis_$kin_var [set save_mom_kin_5th_axis_[set kin_var]]
       set mom_kin_5th_axis_$kin_var [set save_mom_kin_4th_axis_[set kin_var]]
    }
 }

 foreach kin_var $kin_array_list {
    global mom_kin_4th_axis_$kin_var save_mom_kin_4th_axis_$kin_var
    global mom_kin_5th_axis_$kin_var save_mom_kin_5th_axis_$kin_var
    if {[array exists save_mom_kin_4th_axis_$kin_var] && [array exists save_mom_kin_5th_axis_$kin_var]} {
       VMOV 3 save_mom_kin_4th_axis_$kin_var mom_kin_5th_axis_$kin_var
       VMOV 3 save_mom_kin_5th_axis_$kin_var mom_kin_4th_axis_$kin_var
    }
 }

 global mom_sys_4th_axis_has_limits save_mom_sys_5th_axis_has_limits
 global mom_sys_5th_axis_has_limits save_mom_sys_4th_axis_has_limits
 global mom_sys_leader save_mom_sys_leader
 if {[info exists save_mom_sys_4th_axis_has_limits] && [info exists save_mom_sys_5th_axis_has_limits]} {
    set mom_sys_4th_axis_has_limits $save_mom_sys_5th_axis_has_limits
    set mom_sys_5th_axis_has_limits $save_mom_sys_4th_axis_has_limits
 }
 if {[info exists save_mom_kin_4th_axis_leader] && [info exists save_mom_kin_5th_axis_leader]} {
    set mom_sys_leader(fourth_axis) $save_mom_kin_5th_axis_leader
    set mom_sys_leader(fifth_axis) $save_mom_kin_4th_axis_leader
 }
 if {[info exists save_mom_sys_leader(fourth_axis_home)] && [info exists save_mom_sys_leader(fifth_axis_home)]} {
    set mom_sys_leader(fourth_axis_home) $save_mom_sys_leader(fifth_axis_home)
    set mom_sys_leader(fifth_axis_home)  $save_mom_sys_leader(fourth_axis_home)
 }

 MOM_reload_kinematics
}


#=============================================================
proc EQ_is_equal { s t } {
#=============================================================
return [EQ_is_zero [expr $s - $t]]
}


#=============================================================
proc EQ_is_zero { s } {
#=============================================================
   global mom_system_tolerance

   if { [info exists mom_system_tolerance] && [expr $mom_system_tolerance > 0.0] } {
      set tol $mom_system_tolerance
   } else {
      set tol 0.0000001
   }

   if { [expr abs($s) <= $tol] } { return 1 } else { return 0 }
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
proc LINEARIZE_LOCK_MOTION {  } {
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
   global mom_pos
   global mom_prev_pos
   global unlocked_pos
   global unlocked_prev_pos
   global mom_kin_linearization_tol
   global mom_kin_machine_resolution
   global mom_out_angle_pos

   VMOV 5 mom_pos locked_pos
   VMOV 5 mom_prev_pos locked_prev_pos

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
            set locked_prev_pos($i) [expr $locked_prev_pos($i)+360.0]
         } elseif {$del < -180.0} {
            set locked_prev_pos($i) [expr $locked_prev_pos($i)-360.0]
         }
      }

      set loop 1

      for { set i 0 } { $i < 5 } { incr i } {
         set mid_unlocked_pos($i) [expr ($unlocked_pos($i)+$unlocked_prev_pos($i))/2.0]
         set mid_locked_pos($i) [expr ($locked_pos($i)+$locked_prev_pos($i))/2.0]
      }

      UNLOCK_AXIS mid_locked_pos temp

      VEC3_sub temp mid_unlocked_pos work

      set error [VEC3_mag work]

      if { $count > 20 } {

         VMOV 5 locked_pos mom_pos
         VMOV 5 unlocked_pos mom_prev_pos

         LINEARIZE_LOCK_OUTPUT $count

      } elseif { $error < $tol } {

         VMOV 5 locked_pos mom_pos
         VMOV 5 unlocked_pos mom_prev_pos

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

         set error [expr sqrt($mom_kin_linearization_tol*.98/$error)]

         if { $error < .5 } { set error .5 }

         for { set i 0 } { $i < 5 } { incr i } {
            set locked_pos($i) [expr $locked_prev_pos($i)+($locked_pos($i)-$locked_prev_pos($i))*$error]
            set unlocked_pos($i) [expr $unlocked_prev_pos($i)+($unlocked_pos($i)-$unlocked_prev_pos($i))*$error]
         }

         LOCK_AXIS unlocked_pos locked_pos mom_outangle_pos

         set loop 0
         incr count
      }
   }
}


#=============================================================
proc LINEARIZE_LOCK_OUTPUT { count } {
#=============================================================
# called by LOCK_AXIS_MOTION & LINEARIZE_LOCK_MOTION

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
   if { [info exists mom_kin_5th_axis_direction] } {
      set mom_out_angle_pos(1)  [ROTSET $mom_pos(4) $mom_prev_rot_ang_5th $mom_kin_5th_axis_direction\
                                        $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)\
                                        $mom_kin_5th_axis_min_limit $mom_kin_5th_axis_max_limit]
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

   FEEDRATE_SET

   if { $count > 0 } { PB_CMD_linear_move }

#   set mom_prev_pos(3) $mom_out_angle_pos(0)
}


#=============================================================
proc LOCK_AXIS { input_point output_point output_rotary } {
#=============================================================
# called by LOCK_AXIS_MOTION & LINEARIZE_LOCK_MOTION

   upvar $input_point ip ; upvar $output_point op ; upvar $output_rotary or

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

   if { ![info exists positive_radius] } { set positive_radius 0 }

   if { $mom_sys_rotary_axis_index == 3 } {
      if { ![info exists mom_prev_rot_ang_4th] } { set mom_prev_rot_ang_4th 0.0 }
      set mom_prev_lock_angle $mom_prev_rot_ang_4th
   } else {
      if { ![info exists mom_prev_rot_ang_5th] } { set mom_prev_rot_ang_5th 0.0 }
      set mom_prev_lock_angle $mom_prev_rot_ang_5th
   }

   if { ![info exists mom_kin_4th_axis_center_offset] } {
      set temp(0) $ip(0)
      set temp(1) $ip(1)
      set temp(2) $ip(2)
   } else {
      VEC3_sub ip mom_kin_4th_axis_center_offset temp
   }

   if { [info exists mom_kin_5th_axis_center_offset] } {
      VEC3_sub temp mom_kin_5th_axis_center_offset temp
   }

   set temp(3) $ip(3)
   set temp(4) $ip(4)

   if { $mom_sys_lock_axis > 2 } {
      set angle [expr ($mom_sys_lock_value-$temp($mom_sys_lock_axis))*$DEG2RAD]
      ROTATE_VECTOR $mom_sys_lock_plane $angle temp temp1
      VMOV 3 temp1 temp
      set temp($mom_sys_lock_axis) $mom_sys_lock_value
   } else {
      if { ![string compare $mom_sys_lock_plane $mom_sys_5th_axis_index] } {
         set angle [expr ($temp(4))*$DEG2RAD]
         ROTATE_VECTOR $mom_sys_5th_axis_index $angle temp temp1
         VMOV 3 temp1 temp
         set temp(4) 0.0
      }
      set rad [expr sqrt($temp($mom_sys_linear_axis_index_1)*$temp($mom_sys_linear_axis_index_1) +\
                         $temp($mom_sys_linear_axis_index_2)*$temp($mom_sys_linear_axis_index_2))]
      set angle [ARCTAN $temp($mom_sys_linear_axis_index_2) $temp($mom_sys_linear_axis_index_1)]

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
      set ang1 [ARCTAN $temp($mom_sys_linear_axis_index_2) $temp($mom_sys_linear_axis_index_1)]
      set ang2 [ARCTAN $temp1($mom_sys_linear_axis_index_2) $temp1($mom_sys_linear_axis_index_1)]
      set temp($mom_sys_rotary_axis_index) [expr ($angle-$ang1)*$RAD2DEG]
      set temp1($mom_sys_rotary_axis_index) [expr ($angle-$ang2)*$RAD2DEG]
      set ang1 [LIMIT_ANGLE [expr $mom_prev_lock_angle-$temp($mom_sys_rotary_axis_index)]]
      set ang2 [LIMIT_ANGLE [expr $mom_prev_lock_angle-$temp1($mom_sys_rotary_axis_index)]]
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

   }

   if { [info exists mom_kin_4th_axis_center_offset] } {
      VEC3_add temp mom_kin_4th_axis_center_offset op
   } else {
      set op(0) $temp(0)
      set op(1) $temp(1)
      set op(2) $temp(2)
   }

   if { [info exists mom_kin_5th_axis_center_offset] } {
      VEC3_add op mom_kin_5th_axis_center_offset op
   }

   if { ![info exists or] } {
      set or(0) 0.0
      set or(1) 0.0
   }

   set mom_prev_lock_angle $temp($mom_sys_rotary_axis_index)
   set op(3) $temp(3)
   set op(4) $temp(4)
}


#=============================================================
proc LOCK_AXIS_INITIALIZE {  } {
#=============================================================
# called by MOM_lock_axis

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

   if { $mom_sys_lock_plane == -1 } {
      if { ![string compare "XY" $mom_kin_4th_axis_plane] } {
         set mom_sys_lock_plane 2
      } elseif { ![string compare "ZX" $mom_kin_4th_axis_plane] } {
         set mom_sys_lock_plane 1
      } elseif { ![string compare "YZ" $mom_kin_4th_axis_plane] } {
         set mom_sys_lock_plane 0
      }
   }

   if { ![string compare "XY" $mom_kin_4th_axis_plane] } {
      set mom_sys_4th_axis_index 2
   } elseif { ![string compare "ZX" $mom_kin_4th_axis_plane] } {
      set mom_sys_4th_axis_index 1
   } elseif { ![string compare "YZ" $mom_kin_4th_axis_plane] } {
      set mom_sys_4th_axis_index 0
   }

   if { [info exists mom_kin_5th_axis_plane] } {
      if { ![string compare "XY" $mom_kin_5th_axis_plane] } {
         set mom_sys_5th_axis_index 2
      } elseif { ![string compare "ZX" $mom_kin_5th_axis_plane] } {
         set mom_sys_5th_axis_index 1
      } elseif { ![string compare "YZ" $mom_kin_5th_axis_plane] } {
         set mom_sys_5th_axis_index 0
      }
   } else {
      set mom_sys_5th_axis_index -1
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

   if { $mom_sys_5th_axis_index == -1 } {
      set mom_sys_rotary_axis_index 3
   } else {
      set mom_sys_rotary_axis_index 4
   }

   set mom_sys_unlocked_axis [expr $mom_sys_linear_axis_index_1 + $mom_sys_linear_axis_index_2 - $mom_sys_lock_axis]
}


#=============================================================
proc LOCK_AXIS_MOTION {  } {
#=============================================================
# called by PB_CMD_kin_before_motion
#
#  The UDE lock_axis must be specified in the tool path
#  for the post to lock the requested axis.  The UDE lock_axis may only
#  be used for four and five axis machine tools.  A four axis post may
#  only lock an axis in the plane of the fourth axis.  For five axis
#  posts only the fifth axis may be locked.  Five axis will only
#  output correctly if the fifth axis is rotated so it is perpendicular
#  to the spindle axis.
#
  global mom_sys_lock_status

   if { [string match "ON" $mom_sys_lock_status] } {

      global mom_pos mom_out_angle_pos
      global mom_current_motion
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


      if { [string match "circular_move" $mom_current_motion] } {
return
      }


      if { ![info exists mom_sys_cycle_after_initial] } {
         set mom_sys_cycle_after_initial "FALSE"
      }

      if { [string match "FALSE" $mom_sys_cycle_after_initial] } {
         LOCK_AXIS mom_pos mom_pos mom_out_angle_pos
      }

      if { [string match "CYCLE" $mom_motion_type] } {

        if { [string match "initial_move" $mom_motion_event] } {
           set mom_sys_cycle_after_initial "TRUE"
return
        }

        if { [string match "TRUE" $mom_sys_cycle_after_initial] } {
           set mom_pos(0) [expr $mom_pos(0) - $mom_cycle_rapid_to * $mom_tool_axis(0)]
           set mom_pos(1) [expr $mom_pos(1) - $mom_cycle_rapid_to * $mom_tool_axis(1)]
           set mom_pos(2) [expr $mom_pos(2) - $mom_cycle_rapid_to * $mom_tool_axis(2)]
        }

        set mom_sys_cycle_after_initial "FALSE"

        if { [string match "Table" $mom_kin_4th_axis_type] } {

           VMOV 3 mom_kin_spindle_axis mom_sys_spindle_axis

        } elseif { [string match "Table" $mom_kin_5th_axis_type] } {

           VMOV 3 mom_tool_axis vec

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

           set len [VEC3_unitize vec mom_sys_spindle_axis]

           if { [EQ_is_zero $len] } {
              set mom_sys_spindle_axis(2) 1.0
           }

        } else {

           VMOV 3 mom_tool_axis mom_sys_spindle_axis
        }

        set mom_cycle_feed_to_pos(0) [expr $mom_pos(0) + $mom_cycle_feed_to * $mom_sys_spindle_axis(0)]
        set mom_cycle_feed_to_pos(1) [expr $mom_pos(1) + $mom_cycle_feed_to * $mom_sys_spindle_axis(1)]
        set mom_cycle_feed_to_pos(2) [expr $mom_pos(2) + $mom_cycle_feed_to * $mom_sys_spindle_axis(2)]

        set mom_cycle_rapid_to_pos(0) [expr $mom_pos(0) + $mom_cycle_rapid_to * $mom_sys_spindle_axis(0)]
        set mom_cycle_rapid_to_pos(1) [expr $mom_pos(1) + $mom_cycle_rapid_to * $mom_sys_spindle_axis(1)]
        set mom_cycle_rapid_to_pos(2) [expr $mom_pos(2) + $mom_cycle_rapid_to * $mom_sys_spindle_axis(2)]

        set mom_cycle_retract_to_pos(0) [expr $mom_pos(0) + $mom_cycle_retract_to * $mom_sys_spindle_axis(0)]
        set mom_cycle_retract_to_pos(1) [expr $mom_pos(1) + $mom_cycle_retract_to * $mom_sys_spindle_axis(1)]
        set mom_cycle_retract_to_pos(2) [expr $mom_pos(2) + $mom_cycle_retract_to * $mom_sys_spindle_axis(2)]

      }
#<07-11-08 gsl> Cleaned up here!!!

      global mom_kin_linearization_flag

      if { ![string compare "TRUE" $mom_kin_linearization_flag] &&\
            [string compare "RAPID" $mom_motion_type] &&\
            [string compare "RETRACT" $mom_motion_type] } {

         LINEARIZE_LOCK_MOTION

      } else {

         if { ![info exists mom_prev_rot_ang_4th] } { set mom_prev_rot_ang_4th 0.0 }
         if { ![info exists mom_prev_rot_ang_5th] } { set mom_prev_rot_ang_5th 0.0 }

         set mom_out_angle_pos(0)  [ROTSET $mom_pos(3) $mom_prev_rot_ang_4th $mom_kin_4th_axis_direction\
                                           $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)\
                                           $mom_kin_4th_axis_min_limit $mom_kin_4th_axis_max_limit]

         if { [info exists mom_kin_5th_axis_direction] } {
            set mom_out_angle_pos(1) [ROTSET $mom_pos(4) $mom_prev_rot_ang_5th $mom_kin_5th_axis_direction\
                                             $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)\
                                             $mom_kin_5th_axis_min_limit $mom_kin_5th_axis_max_limit]
            set mom_prev_rot_ang_5th $mom_out_angle_pos(1)
            MOM_reload_variable mom_prev_rot_ang_5th
         }

         LINEARIZE_LOCK_OUTPUT -1
      }

      set mom_prev_rot_ang_4th $mom_out_angle_pos(0)
      MOM_reload_variable mom_prev_rot_ang_4th
      MOM_reload_variable -a mom_pos
   }
}


#=============================================================
proc LOCK_AXIS_SUB { axis } {
#=============================================================
# called by SET_LOCK

  global mom_pos mom_lock_axis_value_defined mom_lock_axis_value

   if {$mom_lock_axis_value_defined == 1} {
      return $mom_lock_axis_value
   } else {
      return $mom_pos($axis)
   }
}


#=============================================================
proc LOCK_AXIS__pb901 { input_point output_point output_rotary } {
#=============================================================
# called by LOCK_AXIS_MOTION & LINEARIZE_LOCK_MOTION

   upvar $input_point ip ; upvar $output_point op ; upvar $output_rotary or

   global mom_kin_machine_type
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

   if { ![info exists positive_radius] } { set positive_radius 0 }

   if { $mom_sys_rotary_axis_index == 3 } {
      if { ![info exists mom_prev_rot_ang_4th] } { set mom_prev_rot_ang_4th 0.0 }
      set mom_prev_lock_angle $mom_prev_rot_ang_4th
   } else {
      if { ![info exists mom_prev_rot_ang_5th] } { set mom_prev_rot_ang_5th 0.0 }
      set mom_prev_lock_angle $mom_prev_rot_ang_5th
   }

   if { ![info exists mom_kin_4th_axis_center_offset] } {
      set temp(0) $ip(0)
      set temp(1) $ip(1)
      set temp(2) $ip(2)
   } else {
      VEC3_sub ip mom_kin_4th_axis_center_offset temp
   }

   if { [info exists mom_kin_5th_axis_center_offset] } {
      VEC3_sub temp mom_kin_5th_axis_center_offset temp
   }

   set temp(3) $ip(3)
   set temp(4) $ip(4)

   if { $mom_sys_lock_axis > 2 } {
      set angle [expr ( $mom_sys_lock_value - $temp($mom_sys_lock_axis) )*$DEG2RAD]
      ROTATE_VECTOR $mom_sys_lock_plane $angle temp temp1
      VMOV 3 temp1 temp
      set temp($mom_sys_lock_axis) $mom_sys_lock_value
   } else {
      if { ![string compare $mom_sys_lock_plane $mom_sys_5th_axis_index] } {
         set angle [expr $temp(4)*$DEG2RAD]

         # <03-11-10 wbh> 6308668 Check the rotation mode
         if [string match "reverse" $mom_kin_5th_axis_rotation] {
            set angle [expr -$angle]
         }

         ROTATE_VECTOR $mom_sys_5th_axis_index $angle temp temp1
         VMOV 3 temp1 temp
         set temp(4) 0.0
      }

      #<09-06-13 Allen> Lock axis for 4-axis machine.
      if { [string match "4_axis_*" $mom_kin_machine_type] } {
         if { ![string compare $mom_sys_lock_plane $mom_sys_4th_axis_index] } {
            set angle [expr $temp(3) * $DEG2RAD]
            if [string match "reverse" $mom_kin_4th_axis_rotation] {
               set angle [expr -$angle]
            }

            ROTATE_VECTOR $mom_sys_4th_axis_index $angle temp temp1
            VMOV 3 temp1 temp
            set temp(3) 0.0
         }
      }

      set rad [expr sqrt( $temp($mom_sys_linear_axis_index_1) * $temp($mom_sys_linear_axis_index_1) +\
                          $temp($mom_sys_linear_axis_index_2) * $temp($mom_sys_linear_axis_index_2) )]
      set angle [ARCTAN $temp($mom_sys_linear_axis_index_2) $temp($mom_sys_linear_axis_index_1)]

      # <03-11-10 wbh> 6308668 Check the rotation mode
      if { ![string compare $mom_sys_lock_plane $mom_sys_5th_axis_index] } {
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

      set ang1 [ARCTAN $temp($mom_sys_linear_axis_index_2) $temp($mom_sys_linear_axis_index_1)]
      set ang2 [ARCTAN $temp1($mom_sys_linear_axis_index_2) $temp1($mom_sys_linear_axis_index_1)]

      set temp($mom_sys_rotary_axis_index) [expr ($angle-$ang1)*$RAD2DEG]
      set temp1($mom_sys_rotary_axis_index) [expr ($angle-$ang2)*$RAD2DEG]

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
   }

   if { [info exists mom_kin_4th_axis_center_offset] } {
      VEC3_add temp mom_kin_4th_axis_center_offset op
   } else {
      set op(0) $temp(0)
      set op(1) $temp(1)
      set op(2) $temp(2)
   }

   if { [info exists mom_kin_5th_axis_center_offset] } {
      VEC3_add op mom_kin_5th_axis_center_offset op
   }

   if { ![info exists or] } {
      set or(0) 0.0
      set or(1) 0.0
   }

   set mom_prev_lock_angle $temp($mom_sys_rotary_axis_index)
   set op(3) $temp(3)
   set op(4) $temp(4)
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


########################################################################
# DO NOT define any Other Commands before PB_CMD_xxx commands;
# for unknown (yet) reason, they won't get sourced in properly!
########################################################################
#=============================================================
proc OPERATOR_MSG { msg } {
#=============================================================
   MOM_output_text "$::mom_sys_control_out $msg $::mom_sys_control_in"
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
# not called in this script

   global mom_kin_4th_axis_max_limit mom_kin_4th_axis_min_limit
   global mom_kin_5th_axis_max_limit mom_kin_5th_axis_min_limit
   global mom_pos mom_prev_pos mom_alt_pos mom_alt_prev_pos
   global mom_sys_rotary_error mom_warning_info mom_kin_machine_type

   if { [string compare "secondary rotary position being used" $warn] || [string index $mom_kin_machine_type 0] != 5 } {
      set mom_sys_rotary_error $warn
return
   }

   set mom_sys_rotary_error 0

   set a4 [expr $mom_alt_pos(3)+360.0]
   set a5 [expr $mom_alt_pos(4)+360.0]

   while { [expr $a4-$mom_kin_4th_axis_min_limit] > 360.0 } { set a4 [expr $a4-360.0] }
   while { [expr $a5-$mom_kin_5th_axis_min_limit] > 360.0 } { set a5 [expr $a5-360.0] }

   if { $a4 <= $mom_kin_4th_axis_max_limit && $a5 <= $mom_kin_5th_axis_max_limit } {
return
   }

   for { set i 0 } { $i < 2 } { incr i } {
      set rot($i) [expr $mom_pos([expr $i+3]) - $mom_prev_pos([expr $i+3])]
      while { $rot($i) > 180.0 } { set rot($i) [expr $rot($i)-360.0] }
      while { $rot($i) < 180.0 } { set rot($i) [expr $rot($i)+360.0] }
      set rot($i) [expr abs($rot($i))]

      set rotalt($i) [expr $mom_alt_pos([expr $i+3]) - $mom_prev_pos([expr $i+3])]
      while { $rotalt($i) > 180.0 } { set rotalt($i) [expr $rotalt($i)-360.0] }
      while { $rotalt($i) < 180.0 } { set rotalt($i) [expr $rotalt($i)+360.0] }
      set rotalt($i) [expr abs($rotalt($i))]
   }

   if { [EQ_is_equal [expr $rot(0)+$rot(1)] [expr $rotalt(0)+$rotalt(1)]] } {
return
   }

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
proc ROTARY_AXIS_RETRACT {  } {
#=============================================================
# called by PB_CMD_kin_befor_motion

#  This command is used by four and five axis posts to retract
#  from the part when the rotary axis become discontinuous.  This
#  command is activated by setting the axis limit violation
#  action to "retract / re-engage".
#

   global mom_sys_rotary_error
   global mom_motion_event


  #<sws 9-21-06> Make sure mom_sys_rotary_error is always unset.

   if { ![info exists mom_sys_rotary_error] } {
return
   }

   set rotary_error_code $mom_sys_rotary_error
   unset mom_sys_rotary_error


   if { [info exists mom_motion_event] } {
      if { $rotary_error_code != 0 && ![string compare "linear_move" $mom_motion_event] } {
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
            set mom_warning_info  "Rotary axis limit violated, discontinuous motion may result"
            MOM_catch_warning
            return
         } elseif { ![string compare "User Defined" $mom_kin_4th_axis_limit_action] } {
          #<04-17-09 wbh> add the case for user defined
            USER_DEF_AXIS_LIMIT_ACTION
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
        #  "ROTARY CROSSING LIMIT" and a four axis machine tool.  The fourth
        #      axis will be repositioned by either +360 or -360 before
        #      re-engaging. (roterr=0)
        #
        #  "ROTARY CROSSING LIMIT" and a five axis machine tool.  There are two
        #      possible solutions.  If the axis that crossed a limit can be
        #      repositioned by adding or subtracting 360, then that solution
        #      will be used.  (roterr=0) If there is only one position available and it is
        #      not in the valid travel limits, then the alternate position will
        #      be tested.  If valid, then the "secondary rotary position being used"
        #      method will be used. (roterr=2)
        #      If the aternate position cannot be used a warning will be given.
        #
        #  "secondary rotary position being used".  Can only occur with a five
        #      axis machine tool.  The tool will reposition to the alternate
        #      current rotary position and re-engage to the alternate current
        #      linear position.  (roterr=1)
        #
        #      (roterr=0)
        #      Rotary Reposition : mom_prev_pos(3,4) +- 360
        #      Linear Re-Engage : mom_prev_pos(0,1,2)
        #      Final End Point : mom_pos(0-4)
        #
        #      (roterr=1)
        #      Rotary Reposition : mom_prev_alt_pos(3,4)
        #      Linear Re-Engage : mom_prev_alt_pos(0,1,2)
        #      Final End Point : mom_pos(0-4)
        #
        #      (roterr=2)
        #      Rotary Reposition : mom_prev_alt_pos(3,4)
        #      Linear Re-Engage : mom_prev_alt_pos(0,1,2)
        #      Final End Point : mom_alt_pos(0-4)
        #
        #      For all cases, a warning will be given if it is not possible to
        #      to cut from the re-calculated previous position to move end point.
        #      For all valid cases the tool will, retract from the part, reposition
        #      the rotary axis and re-engage back to the part.

         if { ![string compare "ROTARY CROSSING LIMIT." $rotary_error_code] } {
            global mom_kin_machine_type

            set machine_type [string tolower $mom_kin_machine_type]
            switch $machine_type {
               5_axis_dual_table -
               5_axis_dual_head  -
               5_axis_head_table {

                  set d [expr $mom_out_angle_pos(0) - $mom_prev_rot_ang_4th]

                  if { [expr abs($d)] > 180.0 } {
                     set min $mom_kin_4th_axis_min_limit
                     set max $mom_kin_4th_axis_max_limit
                     if { $d > 0.0 } {
                        set ang [expr $mom_prev_rot_ang_4th+360.0]
                     } else {
                        set ang [expr $mom_prev_rot_ang_4th-360.0]
                     }
                  } else {
                     set min $mom_kin_5th_axis_min_limit
                     set max $mom_kin_5th_axis_max_limit
                     set d [expr $mom_out_angle_pos(1) - $mom_prev_rot_ang_5th]
                     if { $d > 0.0 } {
                        set ang [expr $mom_prev_rot_ang_5th+360.0]
                     } else {
                        set ang [expr $mom_prev_rot_ang_5th-360.0]
                     }
                  }

                  if { $ang >= $min && $ang <= $max } {
                     set roterr 0
                  } else {
                     set roterr 2
                  }
               }

               default { set roterr 0 }
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

               if { ![string compare "Table" $mom_kin_4th_axis_type] } {
                  set num_sol [CALC_CYLINDRICAL_RETRACT_POINT mom_prev_pos mom_kin_spindle_axis\
                                                              $mom_kin_retract_distance ret_pt]
               } else {
                  set num_sol [CALC_SPHERICAL_RETRACT_POINT mom_prev_pos mom_prev_tool_axis cen\
                                                            $mom_kin_retract_distance ret_pt]
               }
               if {$num_sol != 0} {VEC3_add ret_pt cen mom_pos}
            }

            DISTANCE -
            default {
               set mom_pos(0) [expr $mom_prev_pos(0)+$mom_kin_retract_distance*$mom_sys_spindle_axis(0)]
               set mom_pos(1) [expr $mom_prev_pos(1)+$mom_kin_retract_distance*$mom_sys_spindle_axis(1)]
               set mom_pos(2) [expr $mom_prev_pos(2)+$mom_kin_retract_distance*$mom_sys_spindle_axis(2)]
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
            if { [EQ_is_equal $mom_feed_rate 0.0] } {set mom_feed_rate [expr $mom_kin_rapid_feed_rate*$mom_sys_unit_conversion]}
            VEC3_sub mom_pos mom_prev_pos del_pos
            set dist [VEC3_mag del_pos]

           #<03-13-08 gsl> Replaced next call
           # global mom_sys_frn_factor
           # set mom_feed_rate_number [expr ($mom_sys_frn_factor*$mom_feed_rate)/ $dist]
            set mom_feed_rate_number [SET_FEEDRATE_NUMBER $dist $mom_feed_rate]
            FEEDRATE_SET
            set retract "yes"
         } else {
            set mom_warning_info "Retraction geometry is defined inside of the current point.  \nNo retraction will be output.\
                                  Set the retraction distance to a greater value."
            MOM_catch_warning
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
           #  move to alternate rotary position
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
           #  position back to part at approach feed rate
           #
            GET_SPINDLE_AXIS mom_prev_tool_axis
            for { set i 0 } { $i < 3 } { incr i } {
               set mom_pos($i) [expr $mom_prev_pos($i) + $mom_kin_reengage_distance * $mom_sys_spindle_axis($i)]
            }
            set mom_feed_rate [expr $mom_feed_approach_value * $mom_sys_unit_conversion]
            if { [EQ_is_equal $mom_feed_rate 0.0] } {
               set mom_feed_rate [expr $mom_kin_rapid_feed_rate*$mom_sys_unit_conversion]
            }
            set dist [expr $dist-$mom_kin_reengage_distance]
            set mom_feed_rate_number [SET_FEEDRATE_NUMBER $dist $mom_feed_rate]
            FEEDRATE_SET
            MOM_suppress once fourth_axis fifth_axis
            PB_CMD_linear_move

           #
           #  feed back to part at engage feed rate
           #
            MOM_suppress once fourth_axis fifth_axis
            if { $mom_feed_engage_value  > 0.0 } {
               set mom_feed_rate [expr $mom_feed_engage_value*$mom_sys_unit_conversion]
            } elseif { $mom_feed_cut_value  > 0.0 } {
               set mom_feed_rate [expr $mom_feed_cut_value*$mom_sys_unit_conversion]
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
               set mom_warning_info "Not possible to position to alternate rotary axis positions.  Gouging may result"
               MOM_catch_warning
               VMOV 5 save_pos mom_pos

             return
            }

            set res [ANGLE_CHECK mom_prev_alt_pos(4) 5]
            if { $res == 1 } {
               set mom_out_angle_pos(1) [ROTSET $mom_prev_alt_pos(4) $mom_prev_rot_ang_5th $mom_kin_5th_axis_direction\
                                                $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)\
                                                $mom_kin_5th_axis_min_limit $mom_kin_5th_axis_max_limit 1]
            } elseif {$res == 0} {
               set mom_out_angle_pos(1) $mom_prev_alt_pos(4)
            } else {
               set mom_warning_info "Not possible to position to alternate rotary axis positions.  Gouging may result"
               MOM_catch_warning
               VMOV 5 save_pos mom_pos

             return
            }

            set mom_prev_pos(3) $mom_pos(3)
            set mom_prev_pos(4) $mom_pos(4)
            FEEDRATE_SET

            if { ![string compare "yes" $retract] } { PB_CMD_retract_move }
           #
           #  move to alternate rotary position
           #
            set mom_pos(3) $mom_prev_alt_pos(3)
            set mom_pos(4) $mom_prev_alt_pos(4)
            set mom_prev_rot_ang_4th $mom_out_angle_pos(0)
            set mom_prev_rot_ang_5th $mom_out_angle_pos(1)
            VMOV 3 mom_prev_pos mom_pos
            FEEDRATE_SET
            PB_CMD_reposition_move

           #
           #  position back to part at approach feed rate
           #
            set mom_prev_pos(3) $mom_pos(3)
            set mom_prev_pos(4) $mom_pos(4)
            for {set i 0} {$i < 3} {incr i} {
              set mom_pos($i) [expr $mom_prev_alt_pos($i)+$mom_kin_reengage_distance*$mom_sys_spindle_axis($i)]
            }
            MOM_suppress once fourth_axis fifth_axis
            set mom_feed_rate [expr $mom_feed_approach_value*$mom_sys_unit_conversion]
            if { [EQ_is_equal $mom_feed_rate 0.0] } {
              set mom_feed_rate [expr $mom_kin_rapid_feed_rate * $mom_sys_unit_conversion]
            }
            set dist [expr $dist-$mom_kin_reengage_distance]
            set mom_feed_rate_number [SET_FEEDRATE_NUMBER $dist $mom_feed_rate]
            FEEDRATE_SET
            PB_CMD_linear_move

           #
           #  feed back to part at engage feed rate
           #
            MOM_suppress once fourth_axis fifth_axis
            if { $mom_feed_engage_value  > 0.0 } {
               set mom_feed_rate [expr $mom_feed_engage_value*$mom_sys_unit_conversion]
            } elseif { $mom_feed_cut_value  > 0.0 } {
               set mom_feed_rate [expr $mom_feed_cut_value*$mom_sys_unit_conversion]
            } else {

#<03-13-08 gsl> - What is the logic here???
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
  upvar $output_vector v ; upvar $input_vector v1

   if {$plane == 0} {
      set v(0) $v1(0)
      set v(1) [expr $v1(1)*cos($angle) - $v1(2)*sin($angle)]
      set v(2) [expr $v1(2)*cos($angle) + $v1(1)*sin($angle)]
   } elseif {$plane == 1} {
      set v(0) [expr $v1(0)*cos($angle) + $v1(2)*sin($angle)]
      set v(1) $v1(1)
      set v(2) [expr $v1(2)*cos($angle) - $v1(0)*sin($angle)]
   } elseif {$plane == 2} {
      set v(0) [expr $v1(0)*cos($angle) - $v1(1)*sin($angle)]
      set v(1) [expr $v1(1)*cos($angle) + $v1(0)*sin($angle)]
      set v(2) $v1(2)
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
#  kin_leader   leader (usually A, B or C) defined by postbuilder
#  sys_leader   leader that is created by rotset.  It could be C-.
#  min          minimum degrees of travel for current axis
#  max          maximum degrees of travel for current axis
#
#  tol_flag     performance comparison with tolerance
#                 0 : No (default)
#                 1 : Yes
#
#
# - This command is called by the following functions.
#   RETRACT_ROTARY_AXIS, LOCK_AXIS_MOTION, LINEARIZE_LOCK_OUTPUT,
#   MOM_rotate, LINEARIZE_OUTPUT and MILL_TURN.
#
#=============================================================
# Revisions
# 02-25-09 mzg - Added optional argument tol_flag to allow
#                performing comparisions with tolerance
#=============================================================

   upvar $sys_leader lead

#
#  Make sure angle is 0-360 to start with.
#
   LIMIT_ANGLE $angle

   if { ![string compare "MAGNITUDE_DETERMINES_DIRECTION" $dir] } {
#
#  If magnitude determines direction and total travel is less than or equal
#  to 360, we can assume there is at most one valid solution.  Find it and
#  leave.  Check for the total travel being less than 360 and give a warning
#  if a valid position cannot be found.
#
      set travel [expr $max - $min]
      if { $travel <= 360.0 } {
         while { $angle < $min } { set angle [expr $angle + 360.0] }
         while { $angle > $max } { set angle [expr $angle - 360.0] }
         if { $angle < $min } {
            global mom_warning_info
            set mom_warning_info "$kin_leader-axis is under minimum or over maximum.  Assumed default."
            MOM_catch_warning
         }
      } else {
#
#  If magnitude determines direction and total travel is greater than
#  360, we need to find the best solution that cause a move of 180 degree
#  or less.
#
         if { $tol_flag == 0 } {
            while { [expr abs([expr $angle - $prev_angle])] > 180.0 } {
               if { [expr $angle - $prev_angle] < -180.0 } {
                  set angle [expr $angle + 360.0]
               } elseif { [expr $angle - $prev_angle] > 180.0 } {
                  set angle [expr $angle - 360.0]
               }
            }
         } else {
            while { [EQ_is_gt [expr abs([expr $angle - $prev_angle])] 180.0] } {
               if { [EQ_is_lt [expr $angle - $prev_angle] -180.0] } {
                  set angle [expr $angle + 360.0]
               } elseif { [EQ_is_gt [expr $angle - $prev_angle] 180.0] } {
                  set angle [expr $angle - 360.0]
               }
            }
         }
#
#  Check for the best solution being out of the travel limits.  Use the
#  next best valid solution.
#
         while { $angle < $min } { set angle [expr $angle + 360.0] }
         while { $angle > $max } { set angle [expr $angle - 360.0] }
      }

   } elseif { ![string compare "SIGN_DETERMINES_DIRECTION" $dir] } {
#
#  Sign determines direction.  Determine whether the shortest distance is
#  clockwise or counterclockwise.  If counterclockwise append a "-" sign
#  to the address leader.
#
      set angle [expr abs($angle)]  ;# This line was not in ROTSET of xzc post.

      set del [expr $angle - $prev_angle]
      if { $tol_flag == 0 } {
         if { ($del < 0.0 && $del > -180.0) || $del > 180.0 } {
            set lead "$kin_leader-"
         } else {
            set lead $kin_leader
         }
      } else {
         if { ([EQ_is_lt $del 0.0] && [EQ_is_gt $del -180.0]) || [EQ_is_gt $del 180.0] } {
            set lead "$kin_leader-"
         } else {
            set lead $kin_leader
         }
      }
#
#  There are no alternate solutions if the position is out of limits.  Give
#  a warning a leave.
#
      if { $angle < $min || $angle > $max } {
         global mom_warning_info
         set mom_warning_info "$kin_leader-axis is under minimum or over maximum.  Assumed default."
         MOM_catch_warning
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
      mill_turn         { set mtype 4 }
      5_axis_dual_table -
      5_axis_dual_head  -
      5_axis_head_table { set mtype 5 }
      default {
         set mom_warning_info "Set lock only vaild for 4 and 5 axis machines"
return "error"
      }
   }

   set p -1

   switch $mom_lock_axis {
      OFF {
         global mom_sys_lock_arc_save
         global mom_kin_arc_output_mode
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


   global mom_sys_lock_arc_save
   global mom_kin_arc_output_mode

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
# up_level to be a negative integer
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

   upvar $locked_point ip ; upvar $unlocked_point op

   global mom_sys_4th_axis_index
   global mom_sys_5th_axis_index
   global mom_sys_lock_plane
   global mom_sys_linear_axis_index_1
   global mom_sys_linear_axis_index_2
   global mom_sys_rotary_axis_index
   global mom_kin_4th_axis_center_offset
   global mom_kin_5th_axis_center_offset
   global DEG2RAD


   if { [info exists mom_kin_4th_axis_center] } {
       VEC3_add ip mom_kin_4th_axis_center_offset temp
   } else {
       set temp(0) $ip(0)
       set temp(1) $ip(1)
       set temp(2) $ip(2)
   }
   if { [info exists mom_kin_5th_axis_center_offset] } {
      VEC3_add temp mom_kin_5th_axis_center_offset temp
   }

   set op(3) $ip(3)
   set op(4) $ip(4)

   set ang [expr $op($mom_sys_rotary_axis_index)*$DEG2RAD]
   ROTATE_VECTOR $mom_sys_lock_plane $ang temp op

   set op($mom_sys_rotary_axis_index) 0.0

   if { [info exists mom_kin_4th_axis_center_offset] } {
      VEC3_sub op mom_kin_4th_axis_center_offset op
   }
   if { [info exists mom_kin_5th_axis_center_offset] } {
      VEC3_sub op mom_kin_5th_axis_center_offset op
   }
}


#=============================================================
proc UNLOCK_AXIS__pb901 { locked_point unlocked_point } {
#=============================================================
# called by LINEARIZE_LOCK_MOTION

   upvar $locked_point ip ; upvar $unlocked_point op

   global mom_sys_lock_plane
   global mom_sys_linear_axis_index_1
   global mom_sys_linear_axis_index_2
   global mom_sys_rotary_axis_index
   global mom_kin_4th_axis_center_offset
   global mom_kin_5th_axis_center_offset
   global DEG2RAD


   if { [info exists mom_kin_4th_axis_center] } {
       VEC3_add ip mom_kin_4th_axis_center_offset temp
   } else {
       set temp(0) $ip(0)
       set temp(1) $ip(1)
       set temp(2) $ip(2)
   }
   if { [info exists mom_kin_5th_axis_center_offset] } {
      VEC3_add temp mom_kin_5th_axis_center_offset temp
   }

   set op(3) $ip(3)
   set op(4) $ip(4)

   set ang [expr $op($mom_sys_rotary_axis_index)*$DEG2RAD]
   ROTATE_VECTOR $mom_sys_lock_plane $ang temp op

   set op($mom_sys_rotary_axis_index) 0.0

   if { [info exists mom_kin_4th_axis_center_offset] } {
      VEC3_sub op mom_kin_4th_axis_center_offset op
   }
   if { [info exists mom_kin_5th_axis_center_offset] } {
      VEC3_sub op mom_kin_5th_axis_center_offset op
   }
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
      upvar $VAR var

      global tcl_version

      if { [array exists var] } {
         if { [expr $tcl_version < 8.4] } {
            foreach a [array names var] {
               if { [info exists var($a)] } {
                  unset var($a)
               }
            }
            unset var
         } else {
            array unset var
         }
      }

      if { [info exists var] } {
         unset var
      }
   }
}


#=============================================================
proc VECTOR_ROTATE { axis angle input_vector output_vector } {
#=============================================================
#This proc is used to rotating a vector about arbitrary axis.
   upvar $axis r; upvar $input_vector input ; upvar $output_vector output
   #set up matrix to rotate about an arbitrary axis
   set m(0) [expr $r(0)*$r(0)*(1-cos($angle))+cos($angle)]
   set m(1) [expr $r(0)*$r(1)*(1-cos($angle))-$r(2)*sin($angle)]
   set m(2) [expr $r(0)*$r(2)*(1-cos($angle))+$r(1)*sin($angle)]
   set m(3) [expr $r(0)*$r(1)*(1-cos($angle))+$r(2)*sin($angle)]
   set m(4) [expr $r(1)*$r(1)*(1-cos($angle))+cos($angle)]
   set m(5) [expr $r(1)*$r(2)*(1-cos($angle))-$r(0)*sin($angle)]
   set m(6) [expr $r(0)*$r(2)*(1-cos($angle))-$r(1)*sin($angle)]
   set m(7) [expr $r(1)*$r(2)*(1-cos($angle))+$r(0)*sin($angle)]
   set m(8) [expr $r(2)*$r(2)*(1-cos($angle))+cos($angle)]
   MTX3_vec_multiply input m output
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
proc PB_DEFINE_MACROS { } {
#=============================================================
   global mom_pb_macro_arr

   set mom_pb_macro_arr(CYCL_200) \
       [list {{CYCL DEF 200} { } { } {} 1 =} \
        {{{$mom_cycle_rapid_to} 1 4 3 1 1 7 4 Q200} \
         {{$mom_cycle_feed_to} 1 4 3 1 1 7 4 Q201} \
         {{$dpp_TNC_cycle_feed} 1 3 3 1 1 6 3 Q206} \
         {{$cycle_peck_size} 1 4 3 1 1 7 4 Q202} \
         {0 0 Q210} \
         {{$mom_pos(2)} 1 4 3 1 1 7 4 Q203} \
         {{$js_return_pos} 1 4 3 1 1 7 4 Q204} \
         {{$mom_cycle_delay} 1 3 3 1 1 6 3 Q211}}]

   set mom_pb_macro_arr(CYCL_201) \
       [list {{CYCL DEF 201} { } { } {} 1 =} \
        {{{$mom_cycle_rapid_to} 1 4 3 1 1 7 4 Q200} \
         {{$mom_cycle_feed_to} 1 4 3 1 1 7 4 Q201} \
         {{$dpp_TNC_cycle_feed} 1 3 3 1 1 6 3 Q206} \
         {{$mom_cycle_delay} 1 3 3 1 1 6 3 Q211} \
         {0 0 Q208} \
         {{$mom_pos(2)} 1 4 3 1 1 7 4 Q203} \
         {{$js_return_pos} 1 4 3 1 1 7 4 Q204}}]

   set mom_pb_macro_arr(CYCL_207) \
       [list {{CYCL DEF 207} { } { } {} 1 =} \
        {{{$mom_cycle_rapid_to} 1 4 3 1 1 7 4 Q200} \
         {{$mom_cycle_feed_to} 1 4 3 1 1 7 4 Q201} \
         {{$dpp_TNC_cycle_thread_pitch} 1 3 3 1 1 6 3 Q239} \
         {{$mom_pos(2)} 1 4 3 1 1 7 4 Q203} \
         {{$js_return_pos} 1 4 3 1 1 7 4 Q204}}]

   set mom_pb_macro_arr(CYCL_209) \
       [list {{CYCL DEF 209} { } { } {} 1 =} \
        {{{$mom_cycle_rapid_to} 1 4 3 1 1 7 4 Q200} \
         {{$mom_cycle_feed_to} 1 4 3 1 1 7 4 Q201} \
         {{$dpp_TNC_cycle_thread_pitch} 1 3 3 1 1 6 3 Q239} \
         {{$mom_pos(2)} 1 4 3 1 1 7 4 Q203} \
         {{$js_return_pos} 1 4 3 1 1 7 4 Q204} \
         {{$mom_cycle_step1} 1 4 3 1 1 7 4 Q257} \
         {{$dpp_TNC_cycle_step_clearance} 1 4 3 1 1 7 4 Q256} \
         {{$mom_cycle_orient} 1 4 3 1 1 7 4 Q336}}]

   set mom_pb_macro_arr(CYCL_262) \
       [list {{CYCL DEF 262} { } { } {} 1 =} \
        {{{$mom_heidenhain_nominal_diameter} 1 4 3 1 1 7 4 Q335} \
         {{$dpp_TNC_cycle_thread_pitch} 1 3 3 1 1 6 3 Q239} \
         {{$mom_cycle_feed_to} 1 4 3 1 1 7 4 Q201} \
         {{$mom_heidenhain_threads_per_step} 1 4 3 1 1 7 4 Q355} \
         {{$mom_heidenhain_prepos_feedrate} 1 4 3 1 1 7 4 Q253} \
         {{$mom_heidenhain_milling_type} 1 4 3 1 1 7 4 Q351} \
         {{$mom_cycle_rapid_to} 1 4 3 1 1 7 4 Q200} \
         {{$mom_pos(2)} 1 4 3 1 1 7 4 Q203} \
         {{$js_return_pos} 1 4 3 1 1 7 4 Q204} \
         {{$mom_heidenhain_milling_feedrate} 1 4 2 1 1 6 4 Q207}}]

   set mom_pb_macro_arr(CYCL_202) \
       [list {{CYCL DEF 202} { } { } {} 1 =} \
        {{{$mom_cycle_rapid_to} 1 4 3 1 1 7 4 Q200} \
         {{$mom_cycle_feed_to} 1 4 3 1 1 7 4 Q201} \
         {{$dpp_TNC_cycle_feed} 1 3 3 1 1 6 3 Q206} \
         {{$mom_cycle_delay} 1 3 3 1 1 6 3 Q211} \
         {0 0 Q208} \
         {{$mom_pos(2)} 1 4 3 1 1 7 4 Q203} \
         {{$js_return_pos} 1 4 3 1 1 7 4 Q204} \
         {{$mom_itnc_bore_q214} 0 Q214} \
         {{$mom_cycle_orient} 1 4 3 1 1 7 4 Q336}}]

   set mom_pb_macro_arr(CYCL_204) \
       [list {{CYCL DEF 204} { } { } {} 1 =} \
        {{{$mom_cycle_rapid_to} 1 4 3 1 1 7 4 Q200} \
         {{$mom_heidenhain_depth_of_counterbore} 1 4 3 1 1 7 4 Q249} \
         {{$mom_heidenhain_material_thickness} 1 3 3 1 1 6 3 Q250} \
         {{$mom_heidenhain_off_center_distance} 1 4 3 1 1 7 4 Q251} \
         {{$mom_heidenhain_tool_edge_height} 1 4 3 1 1 7 4 Q252} \
         {{$mom_heidenhain_prepositioning_feedrate} 1 4 3 1 1 7 4 Q253} \
         {{$dpp_TNC_cycle_feed} 1 4 3 1 1 7 4 Q254} \
         {0 0 Q255} \
         {{$mom_pos(2)} 1 4 3 1 1 7 4 Q203} \
         {{$js_return_pos} 1 4 3 1 1 7 4 Q204} \
         {{$mom_heidenhain_disengaging_direction} 1 3 5 1 1 8 3 Q214} \
         {{$mom_heidenhain_spindile_angle} 1 4 3 1 1 7 4 Q236}}]

   set mom_pb_macro_arr(CYCL_CALL) \
       [list {{CYCL CALL} {} {} {} 0 {}} \
        {}]

   set mom_pb_macro_arr(CYCL_NURBS) \
       [list {SPL {} { } {} 1 {}} \
        {{{$mom_nurbs_points_x} 1 4 4 1 1 8 4 X} \
         {{$mom_nurbs_points_y} 1 4 4 1 1 8 4 Y} \
         {{$mom_nurbs_points_z} 1 4 4 1 1 8 4 Z} \
         {{$mom_nurbs_co_efficient_0} 1 4 4 1 1 8 4 K3X} \
         {{$mom_nurbs_co_efficient_1} 1 4 4 1 1 8 4 K2X} \
         {{$mom_nurbs_co_efficient_2} 1 4 4 1 1 8 4 K1X} \
         {{$mom_nurbs_co_efficient_3} 1 4 4 1 1 8 4 K3Y} \
         {{$mom_nurbs_co_efficient_4} 1 4 4 1 1 8 4 K2Y} \
         {{$mom_nurbs_co_efficient_5} 1 4 4 1 1 8 4 K1Y} \
         {{$mom_nurbs_co_efficient_6} 1 4 4 1 1 8 4 K3Z} \
         {{$mom_nurbs_co_efficient_7} 1 4 4 1 1 8 4 K2Z} \
         {{$mom_nurbs_co_efficient_8} 1 4 4 1 1 8 4 K1Z}}]

   set mom_pb_macro_arr(CYCL_206) \
       [list {{CYCL DEF 206} { } { } {} 1 =} \
        {{{$mom_cycle_rapid_to} 1 4 3 1 1 7 4 Q200} \
         {{$mom_cycle_feed_to} 1 4 3 1 1 7 4 Q201} \
         {{$dpp_TNC_cycle_tap_feed} 1 3 3 1 1 6 3 Q206} \
         {{$mom_cycle_delay} 1 3 3 1 1 6 3 Q211} \
         {{$mom_pos(2)} 1 4 3 1 1 7 4 Q203} \
         {{$js_return_pos} 1 4 3 1 1 7 4 Q204}}]
}


#=============================================================
proc PB_call_macro { macro_name { prefix "" } { suppress_seqno 0 } args } {
#=============================================================
   global mom_pb_macro_arr mom_warning_info
   if { ![info exists mom_pb_macro_arr($macro_name)] } {
      CATCH_WARNING "Macro $macro_name is not defined."
      return
   }

   set macro_attr_list $mom_pb_macro_arr($macro_name)

   set com_attr_list  [lindex $macro_attr_list 0]
   set disp_name      [lindex $com_attr_list 0]
   set start_char     [lindex $com_attr_list 1]
   set separator_char [lindex $com_attr_list 2]
   set end_char       [lindex $com_attr_list 3]
   set link_flag      [lindex $com_attr_list 4]
   set link_char      [lindex $com_attr_list 5]

   set param_list     [lindex $macro_attr_list 1]

   set text_string ""
   if { [string compare $prefix ""] != 0 } {
       append text_string $prefix " "
   }

   append text_string $disp_name $start_char

   set g_vars_list [list]
   set param_text_list [list]
   set last_index 0
   set count 0
   foreach param_attr $param_list {
      incr count
      if { [llength $param_attr] > 0 } {
         set exp [lindex $param_attr 0]
         if { $exp == "" } {
            lappend param_text_list ""
            continue
         }

         set dtype [lindex $param_attr 1]
         if { $dtype } {
            set temp_cmd "set data_val \[expr \$exp\]"
         } else {
            set temp_cmd "set data_string $exp"
         }

         set break_flag 0
         while { 1 } {
            if { [catch {eval $temp_cmd} res_val] } {
               if [string match "*no such variable*" $res_val] {
                  set __idx [string first ":" $res_val]
                  if { $__idx >= 0 } {
                     set temp_res [string range $res_val 0 [expr int($__idx - 1)]]
                     set temp_var [lindex $temp_res end]
                     set temp_var [string trim $temp_var "\""]
                     if { [string index $temp_var [expr [string length $temp_var] - 1]] == ")" } {
                        set __idx [string first "(" $temp_var]
                        set temp_var [string range $temp_var 0 [expr int($__idx - 1)]]
                     }

                     foreach one $g_vars_list {
                        if { [string compare $temp_var $one] == 0 } {
                           set break_flag 1
                        }
                     }
                     lappend g_vars_list $temp_var
                     global $temp_var
                  } else {
                     set break_flag 1
                  }
               } elseif [string match "*no such element*" $res_val] {
                  set break_flag 1
               } else {
                  CATCH_WARNING "Error to evaluate expression $exp in $macro_name: $res_val"
                  return
               }
            } else {
               break
            }

            if $break_flag {
               CATCH_WARNING "Error to evaluate expression $exp in $macro_name: $res_val"
               set data_string ""
               break
            }
         }

         if { !$break_flag && $dtype } {
            set is_double [lindex $param_attr 2]
            set int_width [lindex $param_attr 3]
            set is_decimal [lindex $param_attr 4]

            set max_val "1"
            set min_val "-1"
            set zero_char [string range "000000000" 0 [expr $int_width - 1]]
            append max_val $zero_char
            append min_val $zero_char

            if { [catch { expr $data_val >= $max_val } comp_res] } {
               set data_string ""
               CATCH_WARNING "Wrong data type to evaluate expression $exp in $macro_name: $comp_res"
            } elseif { $comp_res } {
               set data_string [expr $max_val - 1]
               CATCH_WARNING "MAX/MIN WARNING to evaluate expression $exp in $macro_name: MAX: $data_string"
            } elseif { [expr $data_val <= $min_val] } {
               set data_string [expr $min_val + 1]
               CATCH_WARNING "MAX/MIN WARNING to evaluate expression $exp in $macro_name: MIN: $data_string"
            } else {
               if { $is_double } {
                  set total_width [expr $int_width + $is_double]
                  catch { set data_string [format "%${total_width}.${is_double}f" $data_val] }
                  set data_string [string trimleft $data_string]
                  set data_string [string trimright $data_string 0]
                  if { !$is_decimal } {
                     set dec_index [string first . $data_string]
                     set dec_str [string range $data_string 0 [expr $dec_index - 1]]
                     append dec_str [string range $data_string [expr $dec_index + 1] end]
                     set data_string $dec_str
                  }
               } else {
                  set int_data [expr { int($data_val) }]
                  catch { set data_string [format "%${int_width}d" $int_data] }
                  set data_string [string trimleft $data_string]
                  if { $is_decimal } {
                     append data_string "."
                  }
               }
            }
         }

         if { $link_flag } {
            set temp_str ""
            append temp_str [lindex $param_attr end] $link_char $data_string
            set data_string $temp_str
         }
         lappend param_text_list $data_string

         if ![string match "" $data_string] {
            set last_index $count
         }
      } else {
         lappend param_text_list ""
      }
   }

   if { $last_index > 0 } {
      if { $last_index < $count } {
         set param_text_list [lreplace $param_text_list $last_index end]
      }
      append text_string [join $param_text_list $separator_char]
   }

   append text_string $end_char

   if { $suppress_seqno } {
      MOM_suppress once N
      MOM_output_literal $text_string
   } else {
      MOM_output_literal $text_string
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


