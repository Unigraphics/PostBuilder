########################## TCL Event Handlers ##########################
#
#  sinumerik_840D_millturn.tcl - 5_axis_head_table
#
#    This is a 5-Axis Milling Machine With
#    Rotary Head and Table.
#
#  Created by Postino @ Thursday, February 16, 2017 2:14:57 PM Pacific Standard Time
#  with Post Builder version 11.0.2.
#
########################################################################



#=============================================================
proc PB_CMD___log_revisions { } {
#=============================================================
# Dummy command to log changes in this post --
#
# 15-Jul-2014 gsl   - Initial version.
# 19-Aug-2015 gsl   - Refiled in PB v10.03 with updated PB_CMD_fix_RAPID_SET.
# 21-Aug-2015 szl   - Fix PR7471332: Parse error during machine code simulation if the UDE Operator Message is added.
# 17-Sep-2015 szl   - Updated PB_CMD_abort_event. Output a warning message in NC output while postprocessor cannot calculate the valid rotary position, fix PR7465721.
# 18-Sep-2015 ljt   - Fix lock axis issues: replace obsolete variables with new iks variables in UNLOCK_AXIS and LOCK_AXIS.
#                   - Fix PR6961328 in PB_CMD_MOM_lock_axis, comment out reload mom_pos in LOCK_AXIS_MOTION and lock mom_prev_pos in LINEARIZE_LOCK_MOTION.
# 20-Jun-2016 szl   - Update PB_CMD_detect_operation_mode to enhance new drilling cycle operation type.
# 15-Aug-2016 szl   - Update PB_CMD_MOM_rotate: remove original contents and call proc PB_CMD_kin__MOM_rotate.
# 10-Nov-2016 gsl   - (6887690) Skip contour output in PB_CMD_init_cycle95_output for non-turning operation.
# 28-Nov-2016 szl   - (1997423) Added condition in PB_CMD_init_cycle95_output to output cycle95, when "Additional Profile" is set
#                     and Profile stocks are the same as Rough stocks; otherwise, output individual motion events instead.
# 01-Dec-2016 szl   - Merge fix from sinumerik_840D_lathe template into sinumerik_840D_millturn template.
#                     PR6801224: Add PB_CMD_uplevel_MOM_generic_cycle and PB_CMD_handle_generic_cycle_start_motion to enhance cycle95,
#                     update PB_CMD_contour_end and PB_CMD_init_cycle95_output. PB_CMD_init_cycle95_output is removed from first Approach move.
# 06-Dec-2016 szl   - Add a new proc "PB_CMD_check_variables_for_turning_rough_cycle" to check some variables for turning rough cycle.
#                     Add a condition check in PB_CMD_init_cycle95_output: check if the operations are supported by CYCLE95.
# 22-Jan-2017 shuai - CYCLE832 enhancement.
#                     1. Add the new macro "CYCLE832_v47".
#                     2. Rename the macro from "CYCLE832" to "CYCLE832_v6".
#                     3. Add the new options "Top Surface Smooth" and "Rotary Tolerance" into UDE "Sinumerik 840D".
#                     4. Add the new command PB_CMD_check_settings_for_cycle832, PB_CMD_detect_5axis_tool_path and PB_CMD_detect_hole_cutting_operation.
#                     5. Update the commands.
#                        PB_CMD_MOM_sinumerik_840D, PB_CMD__check_block_CYCLE832, PB_CMD__check_block_reset_cycle832, PB_CMD_init_high_speed_setting,
#                        PB_CMD_output_V5_Sinumerik_setting, PB_CMD_output_V5_compressor_tol, PB_CMD_output_V5_sinumerik_reset,
#                        PB_CMD_reset_Sinumerik_setting, PB_CMD_reset_sinumerik_setting_in_group, PB_CMD_set_Sinumerik_default_setting and PB_CMD_set_Sinumerik_version.
#                     6. Adjust some codes format in this TCL file to make the logic and description more clear.
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
     set mom_sys_list_file_columns                 "132"
     set mom_sys_warning_output                    "OFF"
     set mom_sys_warning_output_option             "FILE"
     set mom_sys_group_output                      "OFF"
     set mom_sys_list_file_suffix                  "lpt"
     set mom_sys_output_file_suffix                "mpf"
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


     set mom_sys_control_out                       ";"
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
  set mom_sys_alt_unit_post_name                "sinumerik_840D_millturn__IN.pui"


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
  set mom_sys_unit_code(IN)                     "700"
  set mom_sys_unit_code(MM)                     "710"
  set mom_sys_output_code(ABSOLUTE)             "90"
  set mom_sys_output_code(INCREMENTAL)          "91"
  set mom_sys_feed_rate_mode_code(IPM)          "94"
  set mom_sys_feed_rate_mode_code(IPR)          "95"
  set mom_sys_feed_rate_mode_code(FRN)          "93"
  set mom_sys_spindle_mode_code(SFM)            "96"
  set mom_sys_spindle_mode_code(RPM)            "97"
  set mom_sys_feed_rate_mode_code(MMPM)         "94"
  set mom_sys_feed_rate_mode_code(MMPR)         "95"
  set mom_sys_lathe_thread_advance_type(1)      "33"
  set mom_sys_lathe_thread_advance_type(2)      "34"
  set mom_sys_lathe_thread_advance_type(3)      "35"
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
  set mom_sys_seqnum_max                        "99999999"
  set mom_sys_lathe_x_double                    "2"
  set mom_sys_lathe_i_double                    "1"
  set mom_sys_lathe_y_double                    "1"
  set mom_sys_lathe_j_double                    "1"
  set mom_sys_lathe_x_factor                    "-1"
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
  set mom_sys_leader(fifth_axis)                "C"
  set mom_sys_contour_feed_mode(LINEAR)         "MMPM"
  set mom_sys_rapid_feed_mode(LINEAR)           "MMPM"
  set mom_sys_cycle_feed_mode                   "MMPM"
  set mom_sys_feed_param(IPM,format)            "Feed_IPM"
  set mom_sys_feed_param(IPR,format)            "Feed_IPR"
  set mom_sys_feed_param(FRN,format)            "Feed_INV"
  set mom_sys_vnc_rapid_dogleg                  "1"
  set mom_sys_prev_mach_head                    ""
  set mom_sys_curr_mach_head                    ""
  set mom_sys_contour_feed_mode(ROTARY)         "MMPM"
  set mom_sys_contour_feed_mode(LINEAR_ROTARY)  "MMPM"
  set mom_sys_feed_param(DPM,format)            "Feed_DPM"
  set mom_sys_rapid_feed_mode(ROTARY)           "MMPM"
  set mom_sys_rapid_feed_mode(LINEAR_ROTARY)    "MMPM"
  set mom_sys_feed_param(MMPM,format)           "Feed_MMPM"
  set mom_sys_feed_param(MMPR,format)           "Feed_MMPR"
  set mom_sys_retract_distance                  "10"
  set mom_sys_output_cycle95                    "1"
  set mom_sys_advanced_turbo_output             "0"
  set mom_sys_linearization_method              "angle"
  set mom_sys_tool_number_max                   "32"
  set mom_sys_tool_number_min                   "1"
  set mom_sys_post_description                  "This is a 5-Axis Milling Machine With\n\
                                                 Rotary Head and Table."
  set mom_sys_ugpadvkins_used                   "0"
  set mom_sys_post_builder_version              "11.0.2"

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
  set mom_kin_arc_valid_plane                   "XYZ"
  set mom_kin_clamp_time                        "2.0"
  set mom_kin_cycle_plane_change_per_axis       "1"
  set mom_kin_cycle_plane_change_to_lower       "1"
  set mom_kin_flush_time                        "2.0"
  set mom_kin_linearization_flag                "1"
  set mom_kin_linearization_tol                 "0.01"
  set mom_kin_machine_resolution                "0.001"
  set mom_kin_machine_type                      "5_axis_head_table"
  set mom_kin_machine_zero_offset(0)            "0.0"
  set mom_kin_machine_zero_offset(1)            "0.0"
  set mom_kin_machine_zero_offset(2)            "0.0"
  set mom_kin_max_arc_radius                    "99999.999"
  set mom_kin_max_dpm                           "10000"
  set mom_kin_max_fpm                           "10000"
  set mom_kin_max_fpr                           "1000"
  set mom_kin_max_frn                           "1000"
  set mom_kin_min_arc_length                    "0.20"
  set mom_kin_min_arc_radius                    "0.001"
  set mom_kin_min_dpm                           "0.0"
  set mom_kin_min_fpm                           "0.1"
  set mom_kin_min_fpr                           "0.1"
  set mom_kin_min_frn                           "0.01"
  set mom_kin_output_unit                       "MM"
  set mom_kin_pivot_gauge_offset                "0"
  set mom_kin_pivot_guage_offset                ""
  set mom_kin_post_data_unit                    "MM"
  set mom_kin_rapid_feed_rate                   "10000"
  set mom_kin_retract_distance                  "500"
  set mom_kin_rotary_axis_method                "PREVIOUS"
  set mom_kin_spindle_axis(0)                   "0.0"
  set mom_kin_spindle_axis(1)                   "0.0"
  set mom_kin_spindle_axis(2)                   "1.0"
  set mom_kin_tool_change_time                  "0.0"
  set mom_kin_x_axis_limit                      "1000"
  set mom_kin_y_axis_limit                      "1000"
  set mom_kin_z_axis_limit                      "1000"




if [llength [info commands MOM_SYS_do_template] ] {
   if [llength [info commands MOM_do_template] ] {
      rename MOM_do_template ""
   }
   rename MOM_SYS_do_template MOM_do_template
}




if { [llength [info commands MOM_do_template]] == 0 } {
   proc MOM_do_template { args } {}
}


if { ![info exists mom_sys_lathe_x_double] } { set mom_sys_lathe_x_double 1 }
if { ![info exists mom_sys_lathe_y_double] } { set mom_sys_lathe_y_double 1 }
if { ![info exists mom_sys_lathe_i_double] } { set mom_sys_lathe_i_double 1 }
if { ![info exists mom_sys_lathe_j_double] } { set mom_sys_lathe_j_double 1 }
if { ![info exists mom_sys_lathe_x_factor] } { set mom_sys_lathe_x_factor 1 }
if { ![info exists mom_sys_lathe_y_factor] } { set mom_sys_lathe_y_factor 1 }
if { ![info exists mom_sys_lathe_z_factor] } { set mom_sys_lathe_z_factor 1 }
if { ![info exists mom_sys_lathe_i_factor] } { set mom_sys_lathe_i_factor 1 }
if { ![info exists mom_sys_lathe_j_factor] } { set mom_sys_lathe_j_factor 1 }
if { ![info exists mom_sys_lathe_k_factor] } { set mom_sys_lathe_k_factor 1 }


if { $mom_sys_lathe_x_double != 1 || \
     $mom_sys_lathe_y_double != 1 || \
     $mom_sys_lathe_i_double != 1 || \
     $mom_sys_lathe_j_double != 1 || \
     $mom_sys_lathe_x_factor != 1 || \
     $mom_sys_lathe_y_factor != 1 || \
     $mom_sys_lathe_z_factor != 1 || \
     $mom_sys_lathe_i_factor != 1 || \
     $mom_sys_lathe_j_factor != 1 || \
     $mom_sys_lathe_k_factor != 1 } {

   rename MOM_do_template MOM_SYS_do_template

   #====================================
   proc MOM_do_template { block args } {
   #====================================
     global mom_sys_lathe_x_double
     global mom_sys_lathe_y_double
     global mom_sys_lathe_i_double
     global mom_sys_lathe_j_double
     global mom_sys_lathe_x_factor
     global mom_sys_lathe_y_factor
     global mom_sys_lathe_z_factor
     global mom_sys_lathe_i_factor
     global mom_sys_lathe_j_factor
     global mom_sys_lathe_k_factor

     global mom_prev_pos mom_pos mom_pos_arc_center mom_ref_pos_arc_center mom_from_pos mom_from_ref_pos
     global mom_ref_pos mom_prev_ref_pos mom_gohome_pos mom_gohome_ref_pos
     global mom_cycle_rapid_to_pos mom_cycle_feed_to_pos mom_cycle_retract_to_pos
     global mom_cycle_clearance_to_pos
     global mom_cycle_feed_to mom_cycle_rapid_to
     global mom_tool_x_offset mom_tool_y_offset mom_tool_z_offset

     global mom_lathe_thread_lead_i mom_lathe_thread_lead_k


     #-----------------------------------
     # Lists of variables to be modified
     #-----------------------------------
      set var_list_1 { mom_pos(\$i) \
                       mom_ref_pos(\$i) \
                       mom_prev_ref_pos(\$i) \
                       mom_from_pos(\$i) \
                       mom_from_ref_pos(\$i) \
                       mom_gohome_pos(\$i) \
                       mom_gohome_ref_pos(\$i) \
                       mom_cycle_rapid_to_pos(\$i) \
                       mom_cycle_feed_to_pos(\$i) \
                       mom_cycle_retract_to_pos(\$i) \
                       mom_cycle_clearance_to_pos(\$i) }

      set var_list_2 { mom_prev_pos(\$i) \
                       mom_pos_arc_center(\$i) \
                       mom_ref_pos_arc_center(\$i) }

      set var_list_3 { mom_cycle_feed_to \
                       mom_cycle_rapid_to \
                       mom_lathe_thread_lead_i \
                       mom_lathe_thread_lead_k }


     # Retain current values
      set var_list [concat $var_list_1 $var_list_2]

      foreach var $var_list {
         for { set i 0 } { $i < 3 } { incr i } {
            if [eval info exists [set var]] {
               set val [eval format $[set var]]
               eval set __[set var] $val
            }
         }
      }

      foreach var $var_list_3 {
         if [eval info exists [set var]] {
             set val [eval format $[set var]]
             eval set __[set var] $val
         }
      }

     # Adjust X, Y & Z values
      set _factor(0) [expr $mom_sys_lathe_x_double * $mom_sys_lathe_x_factor]
      set _factor(1) [expr $mom_sys_lathe_y_double * $mom_sys_lathe_y_factor]
      set _factor(2) $mom_sys_lathe_z_factor

      foreach var $var_list_1 {
         for { set i 0 } { $i < 3 } { incr i } {
            if [expr $_factor($i) != 1] {
               if [eval info exists [set var]] {
                  set val [eval format $[set var]]
                  eval set [set var] [expr $val * $_factor($i)]
               }
            }
         }
      }

     # Adjust I, J & K
      set _factor(0) [expr $mom_sys_lathe_i_factor * $mom_sys_lathe_i_double]
      set _factor(1) [expr $mom_sys_lathe_j_factor * $mom_sys_lathe_j_double]
      set _factor(2)       $mom_sys_lathe_k_factor

      foreach var $var_list_2 {
         for { set i 0 } { $i < 3 } { incr i } {
            if [expr $_factor($i) != 1] {
               if [eval info exists [set var]] {
                  set val [eval format $[set var]]
                  eval set [set var] [expr $val * $_factor($i)]
               }
            }
         }
      }

     # Adjust Cycle's & threading registers
      foreach var $var_list_3 {
         if [eval info exists [set var]] {

            set val [eval format $[set var]]

            switch "$var" {
               "mom_cycle_feed_to"  -
               "mom_cycle_rapid_to" {
                  eval set [set var] [expr $val * $mom_sys_lathe_z_factor]
               }
               "mom_lathe_thread_lead_i" {
                  eval set [set var] [expr $val * $mom_sys_lathe_i_factor * $mom_sys_lathe_i_double]
               }
               "mom_lathe_thread_lead_k" {
                  eval set [set var] [expr $val * $mom_sys_lathe_k_factor]
               }
            }
         }
      }


     # Neutralize all factors to avoid double multiplication in the legacy posts.
      set _lathe_x_double $mom_sys_lathe_x_double
      set _lathe_y_double $mom_sys_lathe_y_double
      set _lathe_i_double $mom_sys_lathe_i_double
      set _lathe_j_double $mom_sys_lathe_j_double
      set _lathe_x_factor $mom_sys_lathe_x_factor
      set _lathe_y_factor $mom_sys_lathe_y_factor
      set _lathe_z_factor $mom_sys_lathe_z_factor
      set _lathe_i_factor $mom_sys_lathe_i_factor
      set _lathe_j_factor $mom_sys_lathe_j_factor
      set _lathe_k_factor $mom_sys_lathe_k_factor

      set mom_sys_lathe_x_double 1
      set mom_sys_lathe_y_double 1
      set mom_sys_lathe_i_double 1
      set mom_sys_lathe_j_double 1
      set mom_sys_lathe_x_factor 1
      set mom_sys_lathe_y_factor 1
      set mom_sys_lathe_z_factor 1
      set mom_sys_lathe_i_factor 1
      set mom_sys_lathe_j_factor 1
      set mom_sys_lathe_k_factor 1


     #-----------------------
     # Output block template
     #-----------------------
      set block_buffer [MOM_SYS_do_template $block $args]


     # Restore values
      foreach var $var_list {
         for { set i 0 } { $i < 3 } { incr i } {
            if [eval info exists [set var]] {
               set v __[set var]
               set val [eval format $$v]
               eval set [set var] $val
            }
         }
      }
      foreach var $var_list_3 {
         if [eval info exists [set var]] {
            set v __[set var]
            set val [eval format $$v]
            eval set [set var] $val
         }
      }

     # Restore factors
      set mom_sys_lathe_x_double $_lathe_x_double
      set mom_sys_lathe_y_double $_lathe_y_double
      set mom_sys_lathe_i_double $_lathe_i_double
      set mom_sys_lathe_j_double $_lathe_j_double
      set mom_sys_lathe_x_factor $_lathe_x_factor
      set mom_sys_lathe_y_factor $_lathe_y_factor
      set mom_sys_lathe_z_factor $_lathe_z_factor
      set mom_sys_lathe_i_factor $_lathe_i_factor
      set mom_sys_lathe_j_factor $_lathe_j_factor
      set mom_sys_lathe_k_factor $_lathe_k_factor

   return $block_buffer
   }
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

   MOM_output_literal ";End of Program"

   MOM_do_template end_of_program
   PB_CMD_output_cycle95_contour_file
   PB_CMD_end_of_program
   PB_CMD_end_of_extcall_program
   MOM_set_seq_off

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


   ABORT_EVENT_CHECK

   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_rotate_cycle_coordinate
      PB_CMD_set_principal_axis
      PB_CMD_init_cycle_parameters

      MOM_do_template cycle_parameters_2

      if { [PB_CMD__check_block_CYCLE_powerline] } {
         PB_call_macro CYCLE85_Bore MCALL
      }

      if { [PB_CMD__check_block_CYCLE_solutionline] } {
         PB_call_macro CYCLE85_Bore_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }

   if { [PB_CMD__check_block_MILL_rotary] } {
      MOM_do_template cycle_parameters_1
   }

   if { [PB_CMD__check_block_TURN_set_angle] } {
      MOM_do_template cycle_parameters
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


   ABORT_EVENT_CHECK

   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_rotate_cycle_coordinate
      PB_CMD_set_principal_axis
      PB_CMD_init_cycle_parameters

      MOM_do_template cycle_parameters_2

      if { [PB_CMD__check_block_CYCLE_powerline] } {
         PB_call_macro CYCLE86 MCALL
      }

      if { [PB_CMD__check_block_CYCLE_solutionline] } {
         PB_call_macro CYCLE86_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }

   if { [PB_CMD__check_block_MILL_rotary] } {
      MOM_do_template cycle_parameters_1
   }

   if { [PB_CMD__check_block_TURN_set_angle] } {
      MOM_do_template cycle_parameters
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


   ABORT_EVENT_CHECK

   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_rotate_cycle_coordinate
      PB_CMD_set_principal_axis
      PB_CMD_init_cycle_parameters

      MOM_do_template cycle_parameters_2
      PB_call_macro CYCLE89 MCALL
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }

   if { [PB_CMD__check_block_MILL_rotary] } {
      MOM_do_template cycle_parameters_1
   }

   if { [PB_CMD__check_block_TURN_set_angle] } {
      MOM_do_template cycle_parameters
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


   ABORT_EVENT_CHECK

   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_rotate_cycle_coordinate
      PB_CMD_set_principal_axis
      PB_CMD_init_cycle_parameters

      MOM_do_template cycle_parameters_2

      if { [PB_CMD__check_block_CYCLE_powerline] } {
         PB_call_macro CYCLE85_Bore_Dwell MCALL
      }

      if { [PB_CMD__check_block_CYCLE_solutionline] } {
         PB_call_macro CYCLE85_Bore_Dwell_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }

   if { [PB_CMD__check_block_MILL_rotary] } {
      MOM_do_template cycle_parameters_1
   }

   if { [PB_CMD__check_block_TURN_set_angle] } {
      MOM_do_template cycle_parameters
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


   ABORT_EVENT_CHECK

   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_rotate_cycle_coordinate
      PB_CMD_set_principal_axis
      PB_CMD_init_cycle_parameters

      MOM_do_template cycle_parameters_2
      PB_call_macro CYCLE87 MCALL
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }

   if { [PB_CMD__check_block_MILL_rotary] } {
      MOM_do_template cycle_parameters_1
   }

   if { [PB_CMD__check_block_TURN_set_angle] } {
      MOM_do_template cycle_parameters
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


   ABORT_EVENT_CHECK

   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_rotate_cycle_coordinate
      PB_CMD_set_principal_axis
      PB_CMD_init_cycle_parameters

      MOM_do_template cycle_parameters_2
      PB_call_macro CYCLE88 MCALL
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }

   if { [PB_CMD__check_block_MILL_rotary] } {
      MOM_do_template cycle_parameters_1
   }

   if { [PB_CMD__check_block_TURN_set_angle] } {
      MOM_do_template cycle_parameters
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


   ABORT_EVENT_CHECK

   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_rotate_cycle_coordinate
      PB_CMD_set_principal_axis
      PB_CMD_init_cycle_parameters

      MOM_do_template cycle_parameters_2

      if { [PB_CMD__check_block_CYCLE_powerline] } {
         PB_call_macro CYCLE86 MCALL
      }

      if { [PB_CMD__check_block_CYCLE_solutionline] } {
         PB_call_macro CYCLE86_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }

   if { [PB_CMD__check_block_MILL_rotary] } {
      MOM_do_template cycle_parameters_1
   }

   if { [PB_CMD__check_block_TURN_set_angle] } {
      MOM_do_template cycle_parameters
   }
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_circular_move { } {
#=============================================================
   ABORT_EVENT_CHECK

   CIRCLE_SET

   if { [PB_CMD__check_block_MILL_rotary] } {
      MOM_do_template circular_move
   }

   if { [PB_CMD__check_block_TURN] } {
      MOM_do_template circular_move_turn
   }

   if { [PB_CMD__check_block_TURN_circular_for_cycle95] } {
      MOM_do_template circular_move_cycle95
   }
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
proc MOM_contour_end { } {
#=============================================================
   PB_CMD_contour_end
}


#=============================================================
proc MOM_contour_start { } {
#=============================================================
   PB_CMD_contour_start
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

   MOM_do_template cutcom_off
}


#=============================================================
proc MOM_cycle_off { } {
#=============================================================
   if { [PB_CMD__check_block_MCALL] } {
      PB_call_macro MCALL
   }
   PB_CMD_output_thread_cycle
   PB_CMD_cancel_cycle
}


#=============================================================
proc MOM_cycle_plane_change { } {
#=============================================================
  global cycle_init_flag
  global mom_cycle_tool_axis_change
  global mom_cycle_clearance_plane_change

   set cycle_init_flag TRUE
   PB_CMD_check_plane_change

   if { [PB_CMD__check_block_cycle_plane_change] } {
      PB_call_macro MCALL
   }
   PB_CMD_rotate_cycle_coordinate
   PB_CMD_set_cycle_plane_change
   set cycle_init_flag FALSE
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

   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_rotate_cycle_coordinate
      PB_CMD_set_principal_axis
      PB_CMD_init_cycle_parameters

      MOM_do_template cycle_parameters_2

      if { [PB_CMD__check_block_CYCLE_powerline] } {
         PB_call_macro CYCLE81 MCALL
      }

      if { [PB_CMD__check_block_CYCLE_solutionline] } {
         PB_call_macro CYCLE81_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }

   if { [PB_CMD__check_block_MILL_rotary] } {
      MOM_do_template cycle_parameters_1
   }

   if { [PB_CMD__check_block_TURN_set_angle] } {
      MOM_do_template cycle_parameters
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


   ABORT_EVENT_CHECK

   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_rotate_cycle_coordinate
      PB_CMD_set_principal_axis
      PB_CMD_init_cycle_parameters

      MOM_do_template cycle_parameters_2

      if { [PB_CMD__check_block_CYCLE_powerline] } {
         PB_call_macro CYCLE83_Break_Chip MCALL
      }

      if { [PB_CMD__check_block_CYCLE_solutionline] } {
         PB_call_macro CYCLE83_Break_Chip_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }

   if { [PB_CMD__check_block_MILL_rotary] } {
      MOM_do_template cycle_parameters_1
   }

   if { [PB_CMD__check_block_TURN_set_angle] } {
      MOM_do_template cycle_parameters
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


   ABORT_EVENT_CHECK

   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_rotate_cycle_coordinate
      PB_CMD_set_principal_axis
      PB_CMD_init_cycle_parameters

      MOM_do_template cycle_parameters_2

      if { [PB_CMD__check_block_CYCLE_powerline] } {
         PB_call_macro CYCLE83_Deep MCALL
      }

      if { [PB_CMD__check_block_CYCLE_solutionline] } {
         PB_call_macro CYCLE83_Deep_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }

   if { [PB_CMD__check_block_MILL_rotary] } {
      MOM_do_template cycle_parameters_1
   }

   if { [PB_CMD__check_block_TURN_set_angle] } {
      MOM_do_template cycle_parameters
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


   ABORT_EVENT_CHECK

   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_rotate_cycle_coordinate
      PB_CMD_set_principal_axis
      PB_CMD_init_cycle_parameters

      MOM_do_template cycle_parameters_2

      if { [PB_CMD__check_block_CYCLE_powerline] } {
         PB_call_macro CYCLE82 MCALL
      }

      if { [PB_CMD__check_block_CYCLE_solutionline] } {
         PB_call_macro CYCLE82_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }

   if { [PB_CMD__check_block_MILL_rotary] } {
      MOM_do_template cycle_parameters_1
   }

   if { [PB_CMD__check_block_TURN_set_angle] } {
      MOM_do_template cycle_parameters
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


   ABORT_EVENT_CHECK

   PB_CMD_drill_text_move
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

   if { [PB_CMD__check_block_reset_trans] } {
      MOM_do_template reset_trans
   }

   if { [PB_CMD__check_block_reset_cycle800] } {
      MOM_do_template reset_cycle800
   }

   if { [PB_CMD__check_block_reset_cycle832] } {
      MOM_do_template reset_cycle832
   }

   if { [PB_CMD__check_block_trafoof] } {
      MOM_do_template trafoof
   }
   PB_CMD_MILL_output_V5_end_of_path
   PB_CMD_MILL_reset_control_mode
   PB_CMD_TURN_end_of_path

   MOM_do_template return_motion
   PB_CMD_reset_all_motion_variables_to_zero
   PB_CMD_end_of_extcall_operation
   PB_CMD_reset_Sinumerik_setting
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

   PB_CMD_handle_generic_cycle_start_motion
   PB_CMD_MILL_detect_5axis_mode
   PB_CMD_reset_output_digits
   PB_CMD_auto_3D_rotation
   PB_CMD_MILL_output_V5_Sinumerik_setting

   MOM_do_template set_spindle

   if { [PB_CMD__check_block_MILL_rotation_axes] } {
      MOM_do_template rotation_axes
   }

   if { [PB_CMD__check_block_CYCLE832] } {
      PB_call_macro CYCLE832_v7
   }

   if { [PB_CMD__check_block_traori_trafoof] } {
      MOM_do_template traori_trafoof
   }

   if { [PB_CMD__check_block_MILL_fixture_offset] } {
      MOM_force Once G_offset
      MOM_do_template fixture_offset
   }

   if { [PB_CMD__check_block_ori_coordinate] } {
      MOM_do_template oriwks_orimks
   }

   if { [PB_CMD__check_block_ori_interpolation] } {
      MOM_do_template oriaxes_orivector
   }

   if { [PB_CMD__check_block_ORIRESET] } {
      PB_call_macro ORIRESET
   }
   PB_CMD_MILL_output_trans_arot

   if { [PB_CMD__check_block_CYCLE800] } {
      PB_call_macro CYCLE800_sl
   }

   if { [PB_CMD__check_block_TURN_set_angle] } {
      MOM_force Once G_motion fourth_axis
      MOM_do_template turn_rotary
   }

   if { [PB_CMD__check_block_spos] } {
      MOM_do_template spos
   }
   PB_CMD_MILL_output_cutcom_mode
   PB_CMD_TURN_output_spindle
   PB_CMD_move_force_addresses

   if { [PB_CMD__check_block_transmit] } {
      MOM_do_template transmit
   }
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
proc MOM_initial_move { } {
#=============================================================
  global mom_feed_rate mom_feed_rate_per_rev mom_motion_type
  global mom_kin_max_fpm mom_motion_event

   COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET

   PB_CMD_handle_generic_cycle_start_motion
   PB_CMD_MILL_detect_5axis_mode
   PB_CMD_reset_output_digits
   PB_CMD_auto_3D_rotation
   PB_CMD_MILL_output_V5_Sinumerik_setting

   MOM_do_template set_spindle

   if { [PB_CMD__check_block_MILL_rotation_axes] } {
      MOM_do_template rotation_axes
   }

   if { [PB_CMD__check_block_CYCLE832] } {
      PB_call_macro CYCLE832_v7
   }

   if { [PB_CMD__check_block_traori_trafoof] } {
      MOM_force Once transf
      MOM_do_template traori_trafoof
   }

   if { [PB_CMD__check_block_MILL_fixture_offset] } {
      MOM_force Once G_offset
      MOM_do_template fixture_offset
   }

   if { [PB_CMD__check_block_ori_coordinate] } {
      MOM_do_template oriwks_orimks
   }

   if { [PB_CMD__check_block_ori_interpolation] } {
      MOM_do_template oriaxes_orivector
   }

   if { [PB_CMD__check_block_ORIRESET] } {
      PB_call_macro ORIRESET
   }
   PB_CMD_MILL_output_trans_arot

   if { [PB_CMD__check_block_CYCLE800] } {
      PB_call_macro CYCLE800_sl
   }
   PB_CMD_MILL_output_cutcom_mode

   if { [PB_CMD__check_block_TURN_set_angle] } {
      MOM_force Once G_motion fourth_axis
      MOM_do_template turn_rotary
   }

   if { [PB_CMD__check_block_spos] } {
      MOM_force Once spos
      MOM_do_template spos
   }
   PB_CMD_TURN_output_spindle
   PB_CMD_move_force_addresses

   if { [PB_CMD__check_block_transmit] } {
      MOM_do_template transmit
   }

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
proc MOM_lathe_roughing { } {
#=============================================================
   PB_CMD_map_cycle95_param

   MOM_do_template lathe_roughing

   if { [PB_CMD__check_block_CYCLE_powerline] } {
      PB_call_macro CYCLE95
   }

   if { [PB_CMD__check_block_CYCLE_solutionline] } {
      PB_call_macro CYCLE95_sl
   }
}


#=============================================================
proc MOM_lathe_thread { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name LATHE_THREAD
}


#=============================================================
proc MOM_lathe_thread_move { } {
#=============================================================
   global cycle_init_flag


   ABORT_EVENT_CHECK

   PB_LATHE_THREAD_SET
   PB_CMD_fix_thread_cycle
   PB_CMD_lathe_thread_set

   MOM_do_template thread_move
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_length_compensation { } {
#=============================================================
   TOOL_SET MOM_length_compensation
}


#=============================================================
proc MOM_linear_move { } {
#=============================================================
   ABORT_EVENT_CHECK

   HANDLE_FIRST_LINEAR_MOVE

   if { [PB_CMD__check_block_MILL_rotary] } {
      MOM_do_template linear_move
   }

   if { [PB_CMD__check_block_MILL_vector] } {
      MOM_do_template linear_move_2
   }

   if { [PB_CMD__check_block_TURN] } {
      MOM_do_template linear_move_turn
   }

   if { [PB_CMD__check_block_TURN_linear_for_cycle95] } {
      MOM_do_template linear_move_cycle95
   }
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
   PB_CMD_nurbs_spline
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

   ABORT_EVENT_CHECK

   set spindle_first NONE

   set aa(0) X ; set aa(1) Y ; set aa(2) Z
   RAPID_SET
   PB_CMD_rotate_rapid_coordinate

   if { [PB_CMD__check_block_MILL_rotary] } {
      MOM_do_template rapid_traverse
   }

   if { [PB_CMD__check_block_MILL_vector] } {
      MOM_do_template rapid_move_1
   }

   if { [PB_CMD__check_block_TURN_set_angle] } {
      MOM_do_template rapid_move
   }
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
proc MOM_set_transmit { } {
#=============================================================
   global mom_siemens_transmit_mode
   PB_CMD_MOM_set_transmit
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

   PB_CMD_check_variables_for_turning_rough_cycle
   PB_CMD_start_of_extcall_operation
   PB_CMD_output_start_program
   PB_CMD_reset_sinumerik_setting_in_group
   PB_CMD_MILL_setting

   if { [PB_CMD__check_block_MILL] } {
      MOM_do_template start_of_path
   }
   PB_CMD_output_V5_compressor_tol

   if { [PB_CMD__check_block_FGREF] } {
      MOM_do_template start_of_path_1
   }
   PB_CMD_TURN_setting
   PB_CMD_set_resolution
   PB_CMD_set_fixture_offset

   global mom_operation_name
   MOM_output_literal ";Operation : $mom_operation_name"
   PB_CMD_output_diameter_mode
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

   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_rotate_cycle_coordinate
      PB_CMD_set_principal_axis
      PB_CMD_init_cycle_parameters

      MOM_do_template cycle_parameters_2

      if { [PB_CMD__check_block_CYCLE84_powerline] } {
         PB_call_macro CYCLE84 MCALL
      }

      if { [PB_CMD__check_block_CYCLE840_powerline] } {
         PB_call_macro CYCLE840 MCALL
      }

      if { [PB_CMD__check_block_CYCLE84_solutionline] } {
         PB_call_macro CYCLE84_sl MCALL
      }

      if { [PB_CMD__check_block_CYCLE840_solutionline] } {
         PB_call_macro CYCLE840_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }

   if { [PB_CMD__check_block_MILL_rotary] } {
      MOM_do_template cycle_parameters_1
   }

   if { [PB_CMD__check_block_TURN_set_angle] } {
      MOM_do_template cycle_parameters
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


   ABORT_EVENT_CHECK

   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_rotate_cycle_coordinate
      PB_CMD_set_principal_axis
      PB_CMD_init_cycle_parameters

      MOM_do_template cycle_parameters_2
      PB_CMD_cycle_tap

      if { [PB_CMD__check_block_CYCLE_powerline] } {
         PB_call_macro CYCLE840 MCALL
      }

      if { [PB_CMD__check_block_CYCLE_solutionline] } {
         PB_call_macro CYCLE840_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }

   if { [PB_CMD__check_block_MILL_rotary] } {
      MOM_do_template cycle_parameters_1
   }

   if { [PB_CMD__check_block_TURN_set_angle] } {
      MOM_do_template cycle_parameters
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
proc MOM_thread { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name THREAD
}


#=============================================================
proc MOM_thread_move { } {
#=============================================================
   global cycle_init_flag


   ABORT_EVENT_CHECK

   PB_CMD_map_cycle97_param

   if { [PB_CMD__check_block_CYCLE97_Thread] } {
      PB_call_macro CYCLE97_Thread
   }
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
   PB_CMD_output_motion_message
}


#=============================================================
proc PB_auto_tool_change { } {
#=============================================================
   global mom_tool_number mom_next_tool_number
   if { ![info exists mom_next_tool_number] } {
      set mom_next_tool_number $mom_tool_number
   }

   MOM_output_literal ";Tool Change"

   if { [PB_CMD__check_block_MILL] } {
      MOM_force Once G_plane
      MOM_do_template mill_work_plane
   }

   if { [PB_CMD__check_block_turn_work_plane] } {
      MOM_force Once G_plane G
      MOM_do_template turn_work_plane
   }

   MOM_force Once T M
   MOM_do_template auto_tool_change_1
}


#=============================================================
proc PB_engage_move { } {
#=============================================================
   PB_CMD_output_motion_message
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
   PB_CMD_move_force_addresses

   MOM_do_template stop
}


#=============================================================
proc PB_retract_move { } {
#=============================================================
   PB_CMD_output_motion_message
}


#=============================================================
proc PB_return_move { } {
#=============================================================
   PB_CMD_output_motion_message
}


#=============================================================
proc PB_start_of_program { } {
#=============================================================
   if [CMD_EXIST PB_CMD_kin_start_of_program] {
      PB_CMD_kin_start_of_program
   }

   PB_CMD_uplevel_MOM_generic_cycle
   PB_CMD_set_Sinumerik_version
   PB_CMD_set_Sinumerik_default_setting
   MOM_set_seq_off
   PB_CMD_init_variables
   PB_CMD_init_helix
   PB_CMD_init_high_speed_setting
   PB_CMD_init_transmit
   PB_CMD_init_thread
   PB_CMD_init_dnc_header
   PB_CMD_init_ini_files
   PB_CMD_init_extcall
   PB_CMD_fix_RAPID_SET
   PB_CMD_uplevel_lock_axis
   MOM_set_seq_on

   if [CMD_EXIST PB_CMD_kin_start_of_program_2] {
      PB_CMD_kin_start_of_program_2
   }
}


#=============================================================
proc PB_user_def_axis_limit_action { args } {
#=============================================================
}


#=============================================================
proc PB_CMD_FEEDRATE_DPM { } {
#=============================================================
# Returns feed rate in degrees per min
#
#
# - REVISIONS
#<12-15-08 gsl> Handle XZC mill-turn case
#

   global   mom_feed_rate_dpm

  # mom_feed_rate_dpm is always zero in XZC-mill post
  # - Use FRN to compute DPM
   global mom_kin_machine_type mom_sys_coordinate_output_mode

   if { [string match "*mill_turn*" $mom_kin_machine_type] } {

      if { [string match "POLAR" $mom_sys_coordinate_output_mode] } {

         set f_rn [PB_CMD_FEEDRATE_NUMBER]
         set minrot [ASK_SMALLER_OF_4TH_5TH]
         set d_pm [expr $minrot * $f_rn]

return $d_pm
      }
   }

   if { [info exists mom_feed_rate_dpm] } {

return $mom_feed_rate_dpm

   } else {

      set f_rn [PB_CMD_FEEDRATE_NUMBER]
      set minrot [ASK_SMALLER_OF_4TH_5TH]
      set d_pm [expr $minrot * $f_rn]

return $d_pm
   }
}


#=============================================================
proc PB_CMD_FEEDRATE_NUMBER { } {
#=============================================================
# Import this custom command into your post.  It does not need
# to be placed with any event marker. It replaces the default
# calculation for FRN.  This custom command can be used for
# four or five axis posts.
#
#
# - REVISIONS
#<10-09-08 gsl> Correct computation for 5-axis FRN
#<06-05-09 gsl> Prepared for pb7.0 release
#<06-17-09 gsl> Use mcs_goto to calculate distance for multi-axis case
#

   global mom_feed_rate_number
   global mom_mcs_goto
   global mom_prev_mcs_goto
   global mom_feed_rate
   global mom_kin_max_frn
   global mom_kin_min_frn
   global mom_kin_max_dpm
   global mom_warning_info
   global mom_kin_machine_type


  # Original FRN - based on mom_motion_distance
  #
   global mom_feed_rate_number
   global mom_sys_frn_factor
   global mom_kin_max_frn


   if { ![info exists mom_sys_frn_factor] } {
      set mom_sys_frn_factor 1.0
   }

   set frn 0.0

   if { [info exists mom_feed_rate_number] } {

      set frn [expr $mom_feed_rate_number * $mom_sys_frn_factor]
      if { [EQ_is_gt $frn $mom_kin_max_frn] } {
         set frn $mom_kin_max_frn
      }
   }

   set frn_org $frn



  #===============
  # Recompute FRN
  #
   global mom_motion_distance

   if { ![info exists mom_motion_distance] } {
       set mom_motion_distance 0.0
   }

   set dist $mom_motion_distance


   if { [string match "3_axis_mill" $mom_kin_machine_type] } {

      if { $dist < .0001 } { set dist .0001 }
      set frn [expr $mom_feed_rate / $dist]

   } else {

     # - Compute arc length - Account for curvature contributed by each rotary axis
     #
      global mom_rotary_delta_4th mom_rotary_delta_5th DEG2RAD

     # Re-compute linear & rotary delta for XZC mill post
      global mom_sys_coordinate_output_mode
      if { [string match "*mill_turn*" $mom_kin_machine_type] } {
         if { ![string compare "POLAR" $mom_sys_coordinate_output_mode] } {
            ASK_DELTA_4TH_OR_5TH 4
         }
      }

      set a4 [expr abs($mom_rotary_delta_4th) * $DEG2RAD]
      set a5 [expr abs($mom_rotary_delta_5th) * $DEG2RAD]

      set AL4 0.0
      set AL5 0.0

      set BG4 0.0
      set BG5 0.0

      set delta(0) [expr $mom_mcs_goto(0) - $mom_prev_mcs_goto(0)]
      set delta(1) [expr $mom_mcs_goto(1) - $mom_prev_mcs_goto(1)]
      set delta(2) [expr $mom_mcs_goto(2) - $mom_prev_mcs_goto(2)]

      set dist [VEC3_mag delta]

      global mom_kin_4th_axis_vector mom_kin_5th_axis_vector

      if { ![EQ_is_zero $a4] } {
        # - Projected length
         set s [VEC3_dot delta mom_kin_4th_axis_vector]
         set p [expr sqrt(abs($dist*$dist - $s*$s))]

        # - Radius of curvature
         set R4 [expr ($p/2.0) / sin($a4/2.0)]

        # - Arc length
         set AL4 [expr $R4 * $a4]

        # - Bulge
         set BG4 [expr $AL4 - $p]
      }

      if { ![EQ_is_zero $a5] } {
        # - Projected length
         set s [VEC3_dot delta mom_kin_5th_axis_vector]
         set p [expr sqrt(abs($dist*$dist - $s*$s))]

        # - Radius of curvature
         set R5 [expr ($p/2.0) / sin($a5/2.0)]

        # - Arc length
         set AL5 [expr $R5 * $a5]

        # - Bulge
         set BG5 [expr $AL5 - $p]
      }

      set dist_BG [expr sqrt($dist*$dist + $BG4*$BG4 + $BG5*$BG5)]


      set dist_max [lindex [lsort -real [list $dist $AL4 $AL5 $dist_BG]] end]

      if { $dist_max < .0001 } { set dist_max .0001 }

      set frn [expr $mom_feed_rate / $dist_max]



     # Determine the maximum rotary displacement of either 4th or 5th axis.
     # For a 4-axis, x is always zero.
     #
      set rot_del [ASK_DELTA_4TH_OR_5TH 4]
      set x [ASK_DELTA_4TH_OR_5TH 5]
      if { $x > $rot_del } {
         set rot_del $x
      }

     # Calculate DPM.  DPM = delta degrees * FRN
     #
      set dpm [expr $rot_del * $frn]

     # Check for DPM being over max.  If so, calculate the time it
     # will take to move the rotary angles at maximum DPM the
     # required number of degrees.
     #
      if { $dpm > $mom_kin_max_dpm } {
         set frn [expr $mom_kin_max_dpm/$rot_del]
         set mom_warning_info "Maximum degrees per minute exceeded, used maximum"
         MOM_catch_warning
      }

   } ;# multi-axis


   set frn [expr $frn * $mom_sys_frn_factor]


  # Check for FRN being greater than format allows.
  #
   if { $frn > $mom_kin_max_frn } {
      set frn $mom_kin_max_frn
      set mom_warning_info "Over maximum FRN, use maximum"
      MOM_catch_warning
   }

  # Check for FRN being smaller than format allows.
  #
   if { $frn < $mom_kin_min_frn } {
      set frn $mom_kin_min_frn
      set mom_warning_info "Under minimum FRN, use minimum"
      MOM_catch_warning
   }


  # Ensure FRN code comes out.  It is usually not modal.
  #
   MOM_force once F

return $frn
}


#=============================================================
proc PB_CMD_FEEDRATE_SET { } {
#=============================================================
# This custom command will be executed automatically in
# MOM_before_motion event handler.
# Important! Don't change following sentence unless you know what are you doing.

  global mom_spindle_mode
  if { $mom_spindle_mode == "SFM" || $mom_spindle_mode == "SMM" } {
     MOM_disable_address G_feed
  } else {
     MOM_enable_address G_feed
  }

  global mom_sinumerik_feed
  global feed
  set mom_sinumerik_feed $feed

# Define feedrate in variables
  global mom_siemens_feed_definition
  global mom_motion_type
  if { [info exists mom_siemens_feed_definition] && $mom_siemens_feed_definition == "ON" } {
     if { $mom_motion_type != "CYCLE" } {
        PB_CMD_define_feedrate_format
     }
  }

}


#=============================================================
proc PB_CMD_MILL_auto_3D_rotation { } {
#=============================================================
# This command is used to get auto 3D coordinate rotation by tool axis vector.

  global mom_kin_machine_type
  global save_mom_kin_machine_type
  global mom_tool_axis mom_tool_axis_type
  global mom_siemens_coord_rotation
  global mom_kin_coordinate_system_type
  global mom_siemens_5axis_mode
  global mom_operation_type
  global mom_kin_4th_axis_point save_mom_kin_4th_axis_point
  global mom_kin_5th_axis_point save_mom_kin_5th_axis_point
  global mom_kin_4th_axis_vector save_mom_kin_4th_axis_vector
  global mom_kin_5th_axis_vector save_mom_kin_5th_axis_vector
  global mom_sys_4th_axis_has_limits
  global mom_sys_5th_axis_has_limits
  global save_mom_sys_4th_axis_has_limits
  global save_mom_sys_5th_axis_has_limits
  global mom_mcs_goto mom_pos mom_prev_pos
  global mom_out_angle_pos
  global coord_ang_A coord_ang_B coord_ang_C
  global coord_ref_x coord_ref_y coord_ref_z
  global RAD2DEG DEG2RAD
  global mom_machine_mode

  if {[string compare $mom_machine_mode "MILL"]} {
return
  }

  if {![string match "*5_axis*" $mom_kin_machine_type]} {return}
  if {[info exists mom_kin_coordinate_system_type] && [string match "CSYS" $mom_kin_coordinate_system_type]} {return}
  if {[info exists mom_siemens_5axis_mode] && [string match "TRAFOOF" $mom_siemens_5axis_mode]} {return}

  if {![info exists mom_tool_axis_type]} {set mom_tool_axis_type 0}
  if {[EQ_is_equal $mom_tool_axis(2) 1.0] || ($mom_tool_axis_type >=2 &&[string match "Variable-axis *" $mom_operation_type ])  || [string match "Sequential Mill Main Operation" $mom_operation_type] } {
return
  } else {
     set mom_siemens_coord_rotation 2
  }

# Get initial/first point by rotation
  if {[string match "5_axis_dual_head" $mom_kin_machine_type]} {
     set rot0 [expr $mom_out_angle_pos(1)*$DEG2RAD]
     set rot1 [expr $mom_out_angle_pos(0)*$DEG2RAD]
     set mom_pos(3) $mom_out_angle_pos(1)
     set mom_pos(4) $mom_out_angle_pos(0)
  } else {
     set rot0 [expr $mom_out_angle_pos(0)*$DEG2RAD]
     set rot1 [expr $mom_out_angle_pos(1)*$DEG2RAD]
     set mom_pos(3) $mom_out_angle_pos(0)
     set mom_pos(4) $mom_out_angle_pos(1)
  }

# Reolad kinematics to dual-table machine
  PB_CMD_save_kinematics
  if {[string match "5_axis_dual_head" $mom_kin_machine_type]} {
     PB_CMD_swap_4th_5th_kinematics
     set angle_pos(0)         $mom_out_angle_pos(0)
     set mom_out_angle_pos(0) $mom_out_angle_pos(1)
     set mom_out_angle_pos(1) $angle_pos(0)
  }
  if {![string match "5_axis_dual_table" $mom_kin_machine_type]} {
     set mom_kin_machine_type "5_axis_dual_table"
  }
  set x 0.0; set y 0.0; set z 0.0;
  VEC3_init x y z mom_kin_4th_axis_point
  VEC3_init x y z mom_kin_5th_axis_point
  MOM_reload_kinematics

  VECTOR_ROTATE mom_kin_5th_axis_vector [expr -1*$rot1] mom_mcs_goto v
  VECTOR_ROTATE mom_kin_4th_axis_vector [expr -1*$rot0] v mom_pos
  MOM_reload_variable -a mom_pos

# Initialize coordinate rotation angles
  set coord_ang_A 0.0 ; set coord_ang_B 0.0 ; set coord_ang_C 0.0
  set coord_ref_x 0.0 ; set coord_ref_y 0.0 ; set coord_ref_z 0.0
  set X(0) 1.0; set X(1) 0.0; set X(2) 0.0
  set Y(0) 0.0; set Y(1) 1.0; set Y(2) 0.0
  set Z(0) 0.0; set Z(1) 0.0; set Z(2) 1.0

# Calculate rotation matrix
    VECTOR_ROTATE mom_kin_4th_axis_vector [expr $rot0] X v1
    VECTOR_ROTATE mom_kin_4th_axis_vector [expr $rot0] Y v2
    VECTOR_ROTATE mom_kin_4th_axis_vector [expr $rot0] Z v3

    VECTOR_ROTATE mom_kin_5th_axis_vector [expr $rot1] v1 X
    VECTOR_ROTATE mom_kin_5th_axis_vector [expr $rot1] v2 Y
    VECTOR_ROTATE mom_kin_5th_axis_vector [expr $rot1] v3 Z

    MTX3_init_x_y_z X Y Z rotation_matrix

 # Calculate euler angles , rotation order is X->Y->Z
    if {[info exists rotation_matrix]} {
    set m0 $rotation_matrix(0)
    set m1 $rotation_matrix(1)
    set m2 $rotation_matrix(2)
    set m3 $rotation_matrix(3)
    set m4 $rotation_matrix(4)
    set m5 $rotation_matrix(5)
    set m6 $rotation_matrix(6)
    set m7 $rotation_matrix(7)
    set m8 $rotation_matrix(8)

    set cos_b_sq [expr $m0*$m0 + $m3*$m3]

    if {[EQ_is_equal $cos_b_sq 0.0]} {

      set cos_b 0.0
      set cos_c 1.0
      set cos_a $m4
      set sin_c 0.0
      set sin_a [expr -1*$m5]

      if {$m6 < 0.0} {
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

    set coord_ang_A [expr -atan2($sin_a,$cos_a)*$RAD2DEG]
    set coord_ang_B [expr -atan2($sin_b,$cos_b)*$RAD2DEG]
    set coord_ang_C [expr -atan2($sin_c,$cos_c)*$RAD2DEG]

 }
}


#=============================================================
proc PB_CMD_MILL_detect_5axis_mode { } {
#=============================================================
#This command is used to detect 5axis mode at initial move and first move for
#mill operaitons.
  global mom_kin_machine_type
  global mom_siemens_5axis_mode
  global mom_siemens_5axis_output_mode
  global mom_siemens_coord_rotation
  global mom_tool_axis_type
  global mom_operation_type
  global mom_siemens_5axis_output
  global mom_machine_mode

  if {[string compare $mom_machine_mode "MILL"]} {
return
  }

  if {![info exists mom_siemens_5axis_mode]} {
     set mom_siemens_5axis_mode "TRAFOOF"
  }


  switch $mom_siemens_5axis_mode {
     TRAORI    {
        set mom_siemens_5axis_output "TRAORI"   ; set mom_siemens_5axis_output_mode 1
     }
     TRAORI2   {
        set mom_siemens_5axis_output "TRAORI(2)"; set mom_siemens_5axis_output_mode 1
     }
     SWIVELING {
        set mom_siemens_5axis_output "TRAFOOF"  ; set mom_siemens_5axis_output_mode 0
     }
     default {
        set mom_siemens_5axis_output "TRAFOOF"
        set mom_siemens_5axis_output_mode 0
     }
  }

}


#=============================================================
proc PB_CMD_MILL_output_V5_Sinumerik_setting { } {
#=============================================================
# This command is used to output Sinumerik 840D high speed machining and 5 axis codes.
  global mom_siemens_5axis_output_mode
  global mom_siemens_coord_rotation
  global mom_5axis_control_mode
  global mom_oper_method
  global mom_kin_machine_type
  global sinumerik_version
  global mom_operation_type
  global mom_siemens_method
  global mom_siemens_tol_status
  global mom_siemens_tol
  global mom_siemens_smoothing
  global mom_siemens_compressor
  global mom_siemens_feedforward
  global mom_siemens_5axis_mode
  global mom_siemens_ori_coord
  global mom_siemens_ori_inter
  global mom_siemens_ori_def
  global mom_siemens_milling_setting
  global mom_kin_4th_axis_leader
  global mom_kin_5th_axis_leader
  global mom_tool_axis_type
  global mom_warning_info mom_operation_name
  global mom_siemens_5axis_output

  if { ![info exists sinumerik_version] || [string compare "V5" $sinumerik_version] } {
return
  }
# If tolerance is redefined in UDE, output again as User Defined
  if { ![info exists mom_siemens_tol_status] } {
     set mom_siemens_tol_status "System"
  }
  if { ![string match "System" $mom_siemens_tol_status] && [info exists mom_siemens_tol] } {
     set tol [format "%.6f" $mom_siemens_tol]
     MOM_output_literal "_camtolerance=$tol  ;  User Defined"
     # For Sinumerik version 5, output compressor tolerence
      PB_CMD_output_V5_compressor_tol
  }

 # Output High Speed Machining codes
   MOM_output_literal "$mom_siemens_feedforward"
   MOM_output_literal "UPATH"
   MOM_output_literal "SOFT"
   if { ![string match "Point to Point" $mom_operation_type] && ![string match "Hole Making" $mom_operation_type] && \
        ![string match "Drilling" $mom_operation_type]} {
      PB_CMD_arc_compressor_mode
      MOM_output_literal "$mom_siemens_compressor"
      MOM_output_literal "$mom_siemens_smoothing"
   }  else {
      MOM_output_literal "G60"
   }
}


#=============================================================
proc PB_CMD_MILL_output_V5_end_of_path { } {
#=============================================================
 global sinumerik_version
 global mom_machine_mode

  if {[string compare $mom_machine_mode "MILL"]} {
return
  }

 if { [info exists sinumerik_version] && [string match "V5" $sinumerik_version] } {
    MOM_output_literal ";"
    MOM_output_literal "FFWOF"
    MOM_output_literal "UPATH"
    MOM_output_literal "SOFT"
    MOM_output_literal "COMPOF"
    MOM_output_literal "G64"
 }
}


#=============================================================
proc PB_CMD_MILL_output_cutcom_mode { } {
#=============================================================
#This command is used to detect cutcome mode.
  global mom_operation_type
  global mom_tool_axis
  global mom_contact_status
  global mom_cutter_data_output_indicator
  global mom_tool_tracking_type
  global mom_contact_normal
  global mom_drive_method
  global mom_automatic_wall_selection
  global mom_kin_machine_type
  global mom_siemens_3Dcutcom_mode
  global mom_siemens_coord_rotation
  global mom_siemens_5axis_output_mode
  global mom_tool_taper_angle
  global mom_machine_mode
  global mom_tool_axis_type
  global mom_tool_path_type

  if {![info exists mom_tool_path_type]} {
     set mom_tool_path_type "undefined"
  }

  if {[string compare $mom_machine_mode "MILL"]} {
return
  }


  if { [info exists mom_siemens_3Dcutcom_mode] && [string match "OFF" $mom_siemens_3Dcutcom_mode] } {
     if { [info exists mom_cutter_data_output_indicator] && $mom_cutter_data_output_indicator == 2 } {
      # 3axis machine
      if { [string match "3_axis_mill" $mom_kin_machine_type] } {
         MOM_output_literal "CUT3DFF"
         set mom_siemens_3Dcutcom_mode "3DFF"
      # 5axis machine
      } else {
         if { ![info exists mom_tool_taper_angle] } {
            set mom_tool_taper_angle 0.0
         }
         # check tool taper angle, CUT3DC cannot work with taper tool
         if { [EQ_is_zero $mom_tool_taper_angle] && [info exists mom_drive_method] && $mom_drive_method == 120 &&  [info exists mom_automatic_wall_selection] && [string match "No" $mom_automatic_wall_selection] } {
            MOM_output_literal "CUT3DC"
            set mom_siemens_3Dcutcom_mode "3DC"
         }  elseif { $mom_tool_axis_type < 2  ||  (![string match "Variable-axis *" $mom_operation_type])  && \
           ![string match "Sequential Mill Main Operation" $mom_operation_type]  && [string match "fixed_axis" $mom_tool_path_type]} { ;#3 axis or 3+2 axis milling            MOM_output_literal "CUT3DFF"
            set mom_siemens_3Dcutcom_mode "3DFF"
         } else {
            MOM_output_literal "CUT3DF"
            set mom_siemens_3Dcutcom_mode "3DF"
         }
      }
      # Move below command to PB_CMD_before_motion
      # PB_CMD_cutcom_mode
     } elseif { [info exists mom_cutter_data_output_indicator] && $mom_cutter_data_output_indicator == 1 } {

      if { $mom_siemens_5axis_output_mode == 1 } {
         MOM_output_literal "CUT3DC"
         set mom_siemens_3Dcutcom_mode "3DC_3axis"
      #Cutcom 2&1/2
      } else {
         MOM_output_literal "CUT2DF"
         set mom_siemens_3Dcutcom_mode "2DF"
      }
   }
}
}


#=============================================================
proc PB_CMD_MILL_output_trans_arot { } {
#=============================================================
# This custom command is used to output coordinate rotation codes.
# This command is used with PB_CMD_set_csys to output cycle800.
#
  global sinumerik_version
  global mom_operation_type
  global mom_kin_coordinate_system_type
  global mom_out_angle_pos
  global mom_siemens_coord_rotation mom_siemens_5axis_output_mode
  global coord_ref_x coord_ref_y coord_ref_z
  global coord_ang_A coord_ang_B coord_ang_C
  global coord_ang_1 coord_ang_2 coord_ang_3
  global coord_offset
  global cycle800_inc_retract
  global cycle800_tc cycle800_dir
  global cycle800_st cycle800_mode
  global mom_siemens_5axis_mode
  global mom_kin_machine_type
  global mom_siemens_ori_def
  global mom_siemens_ori_inter
  global rot_angle_pos mom_init_pos
  global mom_rotary_direction_4th mom_rotary_direction_5th
  global mom_pos mom_alt_pos mom_out_angle_pos
  global mom_siemens_ori_coord
  global mom_kin_machine_type
  global mom_kin_4th_axis_type
  global mom_kin_5th_axis_type
  global mom_tool_axis_type
  global mom_operation_name
  global mom_tool_axis
  global sinumerik_control_version
  global mom_siemens_cycle_plane
  global mom_machine_mode
  global mom_tool_path_type

  if {[string compare $mom_machine_mode "MILL"]} {
return
  }

  if {[info exists sinumerik_control_version] && [string match $sinumerik_control_version "Solutionline"]} {
      set mom_siemens_cycle_plane 1
  }

  if { [string match "3_axis_mill" $mom_kin_machine_type] } {
return
  }

  if { ![info exists mom_siemens_coord_rotation] } {
     set mom_siemens_coord_rotation 0
  }

  if { $mom_siemens_coord_rotation == 0 } {
     if { [array exists coord_offset] } {
        if { ![EQ_is_zero $coord_offset(0)] || ![EQ_is_zero $coord_offset(1)] || ![EQ_is_zero $coord_offset(2)] } {
           MOM_force once X Y Z
           MOM_do_template frame_trans
           global coord_offset_flag
           set coord_offset_flag 1
        }
     }
  } else {
  #Local csys rotation is setting
     if {$mom_siemens_coord_rotation == 1} {
        if {![EQ_is_equal $mom_tool_axis(2) 1.0]} {
            MOM_output_to_listing_device \
              "Warning in $mom_operation_name: Wrong Local MCS, Z axis is not parallel to tool axis vector."
        }
     }
    # Output TRANS and AROT
     if { ![string match "SWIVELING" $mom_siemens_5axis_mode] } {
        if { [array exists coord_offset] } {
           global mom_out_angle_pos DEG2RAD
           global mom_siemens_5axis_output_mode
           global mom_csys_origin mom_parent_csys_matrix
           if {(![EQ_is_zero $coord_offset(0)] || ![EQ_is_zero $coord_offset(1)]) && $mom_siemens_5axis_output_mode == 0} {
              #set x $mom_csys_origin(0) ; set y $mom_csys_origin(1)
              set x $mom_parent_csys_matrix(9) ; set y $mom_parent_csys_matrix(10)
              set rr [expr sqrt($coord_offset(0)*$coord_offset(0)+$coord_offset(1)*$coord_offset(1))]
              set coord_offset(0) [expr $rr*cos(atan2($y,$x)-$mom_out_angle_pos(1)*$DEG2RAD)]
              set coord_offset(1) [expr $rr*sin(atan2($y,$x)-$mom_out_angle_pos(1)*$DEG2RAD)]
           }

           MOM_force once X Y Z
           MOM_do_template frame_trans
        }


        if {$mom_siemens_5axis_output_mode == 0} {
            set save_coord_ang_C $coord_ang_C
            set coord_ang_C [expr -1*$mom_out_angle_pos(1)]
            MOM_do_template frame_arot_z
            set coord_ang_C $save_coord_ang_C
        }
        if { ![EQ_is_zero $coord_ang_A] } {
           MOM_do_template frame_arot_x
        }
        if { ![EQ_is_zero $coord_ang_B] } {
           MOM_do_template frame_arot_y
        }
        if { ![EQ_is_zero $coord_ang_C] } {
           MOM_do_template frame_arot_z
        }

        # Switch rotary angles reference coordinate
        if { ![info exists mom_tool_axis_type] } {
           set mom_tool_axis_type 0
        }
        if {![info exists mom_tool_path_type]} {
           set mom_tool_path_type "undefined"
        }
        if { [string match "*ROTARY*" $mom_siemens_ori_def] &&\
             (($mom_tool_axis_type >=2 && [string match "Variable-axis *" $mom_operation_type ]) ||\
             [string match "Sequential Mill Main Operation" $mom_operation_type] || \
             ([string match "variable_axis" $mom_tool_path_type] && ![string match "Variable-axis *" $mom_operation_type]))} {
           if { [string match "ORIMKS" $mom_siemens_ori_coord] } {
              if { [string match "*dual_head*" $mom_kin_machine_type] || [string match "*dual_table*" $mom_kin_machine_type] } {
                 if { $mom_siemens_5axis_output_mode == 1 } {
                    global save_mom_kin_machine_type
                    set save_mom_kin_machine_type  $mom_kin_machine_type
                    set mom_pos(3) $mom_init_pos(3)
                    set mom_pos(4) $mom_init_pos(4)
                    MOM_reload_variable -a mom_pos
                    set mom_kin_machine_type "5_axis_head_table"
                 } else {
                    global mom_warning_info
                    set mom_warning_info "$mom_operation_name: Wrong rotary axes with respect to Machine Coordinate.Switch to ORIWKS."
                    MOM_catch_warning
                    MOM_output_literal "ORIWKS"
                 }
              }
           } else {
              if { [string match "*head_table*" $mom_kin_machine_type] } {
                 if { $mom_siemens_5axis_output_mode == 1 } {
                    global save_mom_kin_machine_type
                    set save_mom_kin_machine_type  $mom_kin_machine_type
                    set mom_pos(3) $mom_init_pos(3)
                    set mom_pos(4) $mom_init_pos(4)
                    MOM_reload_variable -a mom_pos
                    set mom_kin_machine_type "5_axis_dual_table"
                 } else {
                    global mom_warning_info
                    set mom_warning_info "$mom_operation_name:Wrong rotary axes with respect to Workpiece Coordinate.Switch to ORIMKS."
                    MOM_catch_warning
                    MOM_output_literal "ORIMKS"
                 }
              }
           }
        }
     }
  }
}


#=============================================================
proc PB_CMD_MILL_output_traori { } {
#=============================================================
   global  mom_siemens_5axis_output
    MOM_output_literal "$mom_siemens_5axis_output"
     MOM_force once G_offset
     MOM_do_template fixture_offset

 # Output 5 axis orientation coordinate and interpolation mode
  global mom_kin_machine_type
  global mom_siemens_ori_coord
  global mom_siemens_ori_inter
  global mom_siemens_5axis_mode
  if { ![string match "3_axis_mill*" $mom_kin_machine_type] && ![string match "SWIVELING" $mom_siemens_5axis_mode] } {
     MOM_output_literal ";"
     if { [info exists mom_siemens_ori_coord] } {
        MOM_output_literal "$mom_siemens_ori_coord"
     }
     if { [info exists mom_siemens_ori_inter] } {
        MOM_output_literal "$mom_siemens_ori_inter"
     }
  }

}


#=============================================================
proc PB_CMD_MILL_reset_control_mode { } {
#=============================================================
#Reset coordinate rotation
  global mom_siemens_coord_rotation
  global mom_kin_machine_type
  global mom_siemens_5axis_mode
  global mom_siemens_5axis_output_mode
  global mom_machine_mode
  global coord_ang_A coord_ang_B coord_ang_C

  if {[string compare $mom_machine_mode "MILL"]} {
return
  }

  if { $mom_siemens_coord_rotation != 0 } {
     if { $mom_siemens_coord_rotation == 2 } {
        set mom_siemens_coord_rotation 0
        set coord_ang_A 0; set coord_ang_B 0; set coord_ang_C 0
     }
  }


  global mom_coordinate_output_mode
  if {[info exist mom_coordinate_output_mode] && $mom_coordinate_output_mode == "TRANSMIT"} {
     set mom_coordinate_output_mode "XY-Z OUTPUT"
  } elseif { $mom_siemens_5axis_output_mode == 1 } {
     set mom_siemens_5axis_output_mode 0
  }

  global mom_lock_axis_value mom_lock_axis_plane
  global mom_lock_axis mom_lock_axis_value_defined
  if {[info exists mom_coordinate_output_mode] && [string match $mom_coordinate_output_mode "CX-Z OUTPUT"]} {
      set mom_lock_axis "OFF"
      set mom_lock_axis_plane "NONE"
      set mom_lock_axis_value_defined 0
      set mom_lock_axis_value 0.0
      set mom_coordinate_output_mode "XY-Z OUTPUT"
      MOM_lock_axis
  }


  # Unset 3Dcutcom mode
  global mom_siemens_3Dcutcom_mode mom_cutter_data_output_indicator
  global mom_cutcom_status
  set mom_cutter_data_output_indicator 0
  set mom_siemens_3Dcutcom_mode "OFF"


  # Motion message flag
  global mom_siemens_pre_motion
  set mom_siemens_pre_motion "end"

  PB_CMD_restore_kinematics
}


#=============================================================
proc PB_CMD_MILL_setting { } {
#=============================================================
  global mom_main_mcs
  global mom_sys_spindle_direction_code
  global mom_kin_machine_type
  global mom_sys_leader
  global mom_sys_trailer
  global mom_fixture_offset_value
  global mom_operation_type
  global mom_channel_id
  global mom_sys_lathe_x_factor
  global mom_sys_lathe_x_double
  global mom_sys_lathe_i_factor
  global spindle
  global mom_machine_mode
  global mom_kin_machine_type

  if {[string compare $mom_machine_mode "MILL"]} {
return
  }

  #set spindle number
  set spindle 1

  #Position in Y axis
  MOM_enable_address Y fourth_axis

  #Mirror Output
  set mom_sys_lathe_x_factor "1"
  set mom_sys_lathe_i_factor "1"

  #set spindle direction codes for milling
  set mom_sys_spindle_direction_code(CLW)  3
  set mom_sys_spindle_direction_code(CCLW) 4

  # Diameter Programming
  set mom_sys_lathe_x_double "1"

  # Reset machine type
  set mom_kin_machine_type "5_axis_head_table"
  MOM_reload_kinematics

  PB_CMD_init_nurbs
# PB_CMD_set_XZC_mode
  MOM_force Once G_feed
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
proc PB_CMD_MOM_dnc_header { } {
#=============================================================

  global mom_dnc_machine_name
  global mom_dnc_program_name
  global mom_dnc_data_type
  global mom_dnc_version_number
  global mom_dnc_release_number
  global mom_dnc_user_name
  global mom_logname
  global mom_oper_program
  global env
  global mom_command_status
  global mom_sys_in_operation
  global mom_operation_name
  global mom_group_name

  if { [info exists mom_sys_in_operation] && $mom_sys_in_operation == 1 } {
    CATCH_WARNING "DNC Header event should not be assigned to an operation ($mom_operation_name)."
return
  }

  if { ![info exists mom_group_name] } {
return
  }

  if { [info exists env(COMPUTERNAME)] } {

         set computer $env(COMPUTERNAME)
  } else {
         set computer ""
  }

  if { ![info exists mom_dnc_machine_name] || [string trim $mom_dnc_machine_name] == "" } {
    set mom_dnc_machine_name $computer
  }

  if { ![info exists mom_dnc_user_name] || [string trim $mom_dnc_user_name] == "" } {
    set mom_dnc_user_name $mom_logname
  }

  if { ![info exists mom_dnc_program_name] || [string trim $mom_dnc_program_name] == "" } {
    set mom_dnc_program_name $mom_oper_program
  }

  if { ![info exists mom_dnc_data_type] || [string trim $mom_dnc_data_type] == "" } {
    set mom_dnc_data_type "MPF"
  }

  if { ![info exists mom_dnc_version_number] || [string trim $mom_dnc_version_number] == "" } {
    set mom_dnc_version_number 1
  }

  if { ![info exists mom_dnc_release_number] || [string trim $mom_dnc_release_number] == "" } {
    set mom_dnc_release_number 1
  }
  MOM_set_seq_off
  MOM_output_literal ";HEADER-START"
  MOM_output_literal ";NODENAME=$mom_dnc_machine_name"
  MOM_output_literal ";NCDATANAME=$mom_dnc_program_name"
  MOM_output_literal ";NCDATATYPE=$mom_dnc_data_type"
  MOM_output_literal ";VERSION=$mom_dnc_version_number"
  MOM_output_literal ";RELEASEID=$mom_dnc_release_number"
  MOM_output_literal ";DEVELNAME=$mom_dnc_user_name"
  MOM_output_literal ";HEADER-END"
  MOM_output_literal ";NC-START"
  MOM_output_literal "%"
  MOM_set_seq_on
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
# 18-Sep-2015 ljt - reset positive_radius, fix PR6961328

  global mom_sys_lock_value mom_sys_lock_plane
  global mom_sys_lock_axis mom_sys_lock_status

   set status [SET_LOCK axis plane value]

   if { ![string compare "error" $status] } {
      global mom_warning_info
      CATCH_WARNING $mom_warning_info

      set mom_sys_lock_status OFF
   } else {
      set mom_sys_lock_status $status
      if { [string compare "OFF" $status] } {
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
proc PB_CMD_MOM_program_control { } {
#=============================================================
  global mom_group_name mom_siemens_program_control
  global mom_sys_in_operation
  global mom_sys_ptp_output ptp_file_name

  if { [info exists mom_sys_in_operation] && $mom_sys_in_operation == 1 } {
           if { [string match "TRUE" $mom_siemens_program_control] } {
              set mom_siemens_program_control "FALSE"
           }
           global mom_operation_name
    CATCH_WARNING "Sinumerik Program Control event should not be assigned to an operatrion ($mom_operation_name)."

return
  }

  if { ![string match "ON" $mom_sys_ptp_output] || ![info exists ptp_file_name] } {
return
  }

  if { [string match "TRUE" $mom_siemens_program_control] } {
           if { ![info exists mom_group_name] } {
              set mom_siemens_program_control "FALSE"
return
           }
           MOM_close_output_file $ptp_file_name
  }
}


#=============================================================
proc PB_CMD_MOM_rotate { } {
#=============================================================
# Default handler for UDE MOM_rotate
# - Do not attach it to any event!
#
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
proc PB_CMD_MOM_set_transmit { } {
#=============================================================
  global mom_coordinate_output_mode
  global mom_siemens_transmit_mode

  switch $mom_siemens_transmit_mode {
     "ON" {
         set mom_coordinate_output_mode "TRANSMIT"
     }
     "OFF" -
     default {
     }
  }

}


#=============================================================
proc PB_CMD_MOM_sinumerik_840D { } {
#=============================================================
# This command is the Sinumerik 840D UDE handler.
#
# The user can use Sinumerik 840 UDE to set Sinumerik 840D advanced features.
#
# 23-Dec-2016 shuai - CYCLE832 enhancement.
#

  global mom_output_unit
  global mom_part_unit
  global mom_siemens_tol
  global mom_siemens_tol_status
  global mom_siemens_tol_defined

  # Set the tolerance.
  if {[info exists mom_siemens_tol_defined] && $mom_siemens_tol_defined == 1} {

     if {![string match $mom_part_unit $mom_output_unit] } {

        switch $mom_output_unit {

           IN {set mom_siemens_tol [expr $mom_siemens_tol/25.4]}
           MM {set mom_siemens_tol [expr $mom_siemens_tol*25.4]}
        }
     }

     set mom_siemens_tol [format "%.6f" $mom_siemens_tol]
     set mom_siemens_tol_status "User"

  } else {

     # <lili 2013-06-20> Add following line to reset tolerance status
     set mom_siemens_tol_status "System"
  }

  # Optimal codes by Sinumerik version.
  global sinumerik_version

  if {![info exists sinumerik_version] } {
    set sinumerik_version "V7"
  }

  # The options (compressor, smoothing and feed foward.) only have effects on V5, V6 and V7.
  global mom_siemens_compressor
  global mom_siemens_smoothing
  global mom_siemens_feedforward

  if {![string compare "V5" $sinumerik_version] || ![string compare "V6" $sinumerik_version] || ![string compare "V7" $sinumerik_version] } {

     # Set the compressor.
     if {[string match "ON" $mom_siemens_compressor]} {

        switch $sinumerik_version {

           "V5"   {set mom_siemens_compressor "COMPCURV"}
           "V6" -
           "V7"   {set mom_siemens_compressor "COMPCAD"}
        }

     } elseif {[string match "OFF" $mom_siemens_compressor]} {

        set mom_siemens_compressor "COMPOF"
     }

     # Set the smoothing.
     if {[string match "ON" $mom_siemens_smoothing]} {

        switch $sinumerik_version {

           "V5" -
           "V6"   {set mom_siemens_smoothing "G642"}
           "V7"   {set mom_siemens_smoothing "G645"}
        }

     } elseif {[string match "OFF" $mom_siemens_smoothing]} {

        switch $sinumerik_version {

           "V5" {set mom_siemens_smoothing "G60"}
           "V6" {set mom_siemens_smoothing "G64"}
           "V7" {set mom_siemens_smoothing "G60"}
        }
     }

     # Set the feed forward.
     if {[string match "ON" $mom_siemens_feedforward]} {
        set mom_siemens_feedforward "FFWON"
     }  elseif {[string match "OFF" $mom_siemens_feedforward]} {
        set mom_siemens_feedforward "FFWOF"
     }
  }

  # Set the top surface smooth.
  global mom_siemens_top_surface_smooth

  if {[string match "TOP*ON" $mom_siemens_top_surface_smooth]} {
     set mom_siemens_top_surface_smooth "_TOP_SURFACE_SMOOTH_ON"
  } elseif {[string match "TOP*OFF" $mom_siemens_top_surface_smooth]} {
     set mom_siemens_top_surface_smooth "_TOP_SURFACE_SMOOTH_OFF"
  } else {
     set mom_siemens_top_surface_smooth ""
  }

  # Set the transformation.
  global mom_siemens_5axis_mode
  global mom_siemens_5axis_output_mode

  if {[info exists mom_siemens_5axis_mode]} {

     switch $mom_siemens_5axis_mode {

        TRAORI -
        TRAORI2 {set mom_siemens_5axis_output_mode 1}
        default {set mom_siemens_5axis_output_mode 0}
     }
  }

  # Set the coordinate system and interpolation.
  global mom_siemens_ori_coord
  global mom_siemens_ori_inter

  if {[string match "MACHINE" $mom_siemens_ori_coord]} {
     set mom_siemens_ori_coord "ORIMKS"
  } elseif {[string match "WORKPIECE" $mom_siemens_ori_coord]} {
     set mom_siemens_ori_coord "ORIWKS"
  }

  if {[string match "LINEAR" $mom_siemens_ori_inter]} {
     set mom_siemens_ori_inter "ORIAXES"
  } elseif {[string match "PLANE" $mom_siemens_ori_inter]} {
     set mom_siemens_ori_inter "ORIVECT"
  }

  # Set the rotary tolerance.
  global mom_siemens_rotary_tol
  global mom_siemens_rotary_tol_status
  global mom_siemens_rotary_tol_defined

  if {[info exists mom_siemens_rotary_tol_defined] && $mom_siemens_rotary_tol_defined == 1} {

     set mom_siemens_rotary_tol [format "%.6f" $mom_siemens_rotary_tol]
     set mom_siemens_rotary_tol_status "User"

  } else {

     set mom_siemens_rotary_tol_status "System"
  }

  # Set the group settings.
  global mom_siemens_ori_def
  global mom_siemens_feed_definition
  global mom_group_name
  global mom_siemens_tol_group
  global mom_siemens_tol_status_group
  global mom_siemens_rotary_tol_group
  global mom_siemens_rotary_tol_status_group
  global mom_sys_in_operation
  global mom_siemens_milling_setting

  if {[info exists mom_sys_in_operation ] && $mom_sys_in_operation == 1} {

     if {[string match "Group*" $mom_siemens_milling_setting]} {
        set mom_siemens_milling_setting "Group_UDE_operation"
     } else {
        set mom_siemens_milling_setting "UDE_operation"
     }

  } else {

     if {[info exists mom_group_name]} {
        set mom_siemens_milling_setting "Group$mom_group_name"
     } else {
        set mom_siemens_milling_setting "Group"
     }

     if {[info exists mom_siemens_tol_status]} {
        set mom_siemens_tol_status_group $mom_siemens_tol_status
     }
     if {[info exists mom_siemens_tol]} {
        set mom_siemens_tol_group $mom_siemens_tol
     }

     global mom_siemens_compressor_group
     global mom_siemens_smoothing_group
     global mom_siemens_feedforward_group
     global mom_siemens_top_surface_smooth_group
     global mom_siemens_5axis_mode_group
     global mom_siemens_ori_coord_group
     global mom_siemens_ori_inter_group
     global mom_siemens_ori_def_group
     global mom_siemens_feed_definition_group

     set mom_siemens_compressor_group $mom_siemens_compressor
     set mom_siemens_smoothing_group $mom_siemens_smoothing
     set mom_siemens_feedforward_group $mom_siemens_feedforward
     set mom_siemens_top_surface_smooth_group $mom_siemens_top_surface_smooth
     set mom_siemens_5axis_mode_group $mom_siemens_5axis_mode
     set mom_siemens_ori_coord_group $mom_siemens_ori_coord
     set mom_siemens_ori_inter_group $mom_siemens_ori_inter
     set mom_siemens_ori_def_group $mom_siemens_ori_def
     set mom_siemens_feed_definition_group $mom_siemens_feed_definition

     if {[info exists mom_siemens_rotary_tol_status]} {
        set mom_siemens_rotary_tol_status_group $mom_siemens_rotary_tol_status
     }
     if {[info exists mom_siemens_rotary_tol]} {
        set mom_siemens_rotary_tol_group $mom_siemens_rotary_tol
     }
  }

  PB_CMD_define_feed_variable_value

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
proc PB_CMD_TURN_end_of_path { } {
#=============================================================
  global mom_machine_mode

  if {[string compare $mom_machine_mode "TURN"]} {
return
  }

  global thread_cycle_flag
  set thread_cycle_flag 0

  global spindle_is_out
  catch {unset spindle_is_out}
}


#=============================================================
proc PB_CMD_TURN_output_coord_offset { } {
#=============================================================
  global mom_operation_type
  global mom_kin_coordinate_system_type
  global mom_siemens_coord_rotation mom_siemens_5axis_output_mode
  global coord_ref_x coord_ref_y coord_ref_z
  global coord_ang_1 coord_ang_2 coord_ang_3
  global coord_offset
  global mom_machine_mode

  if {[string compare $mom_machine_mode "TURN"]} {
return
  }

  if { ![info exists mom_siemens_coord_rotation] } { set mom_siemens_coord_rotation 0 }
  if { $mom_siemens_coord_rotation == 0 } {
     if { [array exists coord_offset] } {
        if { ![EQ_is_zero $coord_offset(0)] || ![EQ_is_zero $coord_offset(1)] || ![EQ_is_zero $coord_offset(2)] } {
           MOM_force once X Y Z
           MOM_do_template frame_trans
           global coord_offset_flag
           set coord_offset_flag 1
        }
     }
  }

}


#=============================================================
proc PB_CMD_TURN_output_spindle { } {
#=============================================================
  global mom_spindle_mode
  global spindle_is_out
  global mom_spindle_maximum_rpm
  global mom_spindle_speed
  global mom_machine_mode

  if {[string compare $mom_machine_mode "TURN"]} {
return
  }

  if {![info exists mom_spindle_speed] ||[EQ_is_zero $mom_spindle_speed]} {
return
  }

      if { $mom_spindle_mode == "RPM" } {
         global mom_part_transfer_flag
         if {[info exists mom_part_transfer_flag] && $mom_part_transfer_flag ==1} {
            MOM_add_to_block_buffer spindle_rpm end [MOM_do_template spindle_sub CREATE]
            MOM_force Once M_spindle_sub S_sub M_spindle S G_spin
         }
         MOM_force once M_spindle S G_feed
         MOM_do_template spindle_rpm
      } elseif { $mom_spindle_mode == "SFM" || $mom_spindle_mode == "SMM" } {

         if { [info exists mom_spindle_maximum_rpm] && [expr $mom_spindle_maximum_rpm > 0] } {
            MOM_do_template spindle_max_rpm
         }
         MOM_force once M_spindle S G G_spin
         MOM_do_template spindle_css
      }
}


#=============================================================
proc PB_CMD_TURN_set_BC_head { } {
#=============================================================
  global mom_channel_id
  global mom_tool_axis
  global mom_out_angle_pos
  global RAD2DEG
  global mom_rotation_angle
  global mom_rotate_axis_type
  global mom_machine_mode

  if {[string compare $mom_machine_mode "TURN"]} {
return
  }

  if {[info exists mom_rotate_axis_type] && [info exists mom_rotation_angle]} {
     if {[string match "AAXIS" $mom_rotate_axis_type]} {
         #MOM_do_template rotate_c1
         unset mom_rotate_axis_type
     } else {
         set mom_rotation_angle 0.0
     }
  } else {
       set mom_rotation_angle 0.0
  }

  if {![array exists mom_tool_axis]} {
      set mom_out_angle_pos(0) 0.0
  } else {
      set mom_out_angle_pos(0) [expr $RAD2DEG*atan2($mom_tool_axis(0),$mom_tool_axis(2))]
  }

}


#=============================================================
proc PB_CMD_TURN_setting { } {
#=============================================================
  global mom_main_mcs
  global mom_sys_spindle_direction_code
  global mom_kin_machine_type
  global spindle
  global mom_fixture_offset_value
  global mom_machine_mode
  global mom_kin_machine_type
  global mom_channel_id
  global mom_sys_lathe_x_factor
  global mom_sys_lathe_x_double
  global mom_sys_lathe_i_factor

  if {[string compare $mom_machine_mode "TURN"]} {
return
  }
   #Set spindle number
   set spindle 4

   #Position in Y axis
   MOM_enable_address Y
   #MOM_disable_address Y

   #Mirror output
   set mom_sys_lathe_x_factor "1"
   set mom_sys_lathe_i_factor "1"

   #Set spindle direction codes for turning
   set mom_sys_spindle_direction_code(CLW)  4
   set mom_sys_spindle_direction_code(CCLW) 3

   #Diameter programming
   set mom_sys_lathe_x_double  "2"

   #Reset machine type to lathe
   set mom_kin_machine_type "lathe"

   MOM_reload_kinematics
}


#=============================================================
proc PB_CMD_TURN_spindle_sfm_start { } {
#=============================================================
  global mom_spindle_mode
  global mom_spindle_speed
  global spindle_is_out
  global mom_machine_mode

  if {[string compare $mom_machine_mode "TURN"]} {
return
  }

  if {![info exists mom_spindle_speed] ||[EQ_is_zero $mom_spindle_speed]} {
return
  }

  if { $mom_spindle_mode == "SFM" || $mom_spindle_mode == "SMM" } {
     MOM_force once G_spin M_spindle S
  #   MOM_do_template spindle_rpm_preset
     if { [info exists spindle_is_out] } {
       unset spindle_is_out
     }
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

  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Define ::mom_sys_rotary_error to execute ROTARY_AXIS_RETRACT
  #
   set rotary_limit_error 0

   if { [string match "*Previous rotary axis solution degenerated*" $::mom_warning_info] } {
      set rotary_limit_error 1
   }

   if { [string match "ROTARY CROSSING LIMIT." $::mom_warning_info] } {
      set rotary_limit_error 1
   }

   if { [string match "secondary rotary position being used" $::mom_warning_info] } {
      set rotary_limit_error 1
   }

   if { $rotary_limit_error } {
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
proc PB_CMD__check_block_CYCLE800 { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global sinumerik_control_version
   global mom_rotary_direction_4th
   global coord_ang_A
   global coord_ang_B
   global coord_ang_C
   global cycle800_inc_retract
   global cycle800_tc cycle800_dir
   global cycle800_st cycle800_mode
   global coord_ang_1 coord_ang_2 coord_ang_3
   global mom_siemens_coord_rotation
   global mom_siemens_5axis_mode
   global mom_siemens_cycle_dmode
   global mom_machine_mode

   if {[string compare $mom_machine_mode "MILL"]} {
return 0
   }

#-----------------------------------------------------------
#Please set your swivel data record
#-----------------------------------------------------------
   set cycle800_tc "\"R_DATA\"" ;# For example,please put your data here

#-----------------------------------------------------------
#Please set your incremental retraction
#-----------------------------------------------------------
   set cycle800_inc_retract "1"

#-----------------------------------------------------------
   if {[info exists sinumerik_control_version] && [string match $sinumerik_control_version "Solutionline"]} {
      set mom_siemens_cycle_dmode 0

   } else {
      if {[info exists mom_siemens_cycle_dmode]} {unset mom_siemens_cycle_dmode}
   }

      if { ![info exists mom_siemens_coord_rotation] } {
         set mom_siemens_coord_rotation 0
      }
      if {$mom_siemens_coord_rotation !=0 && [info exists mom_siemens_5axis_mode] && [string match "SWIVELING" $mom_siemens_5axis_mode] } {
        set cycle800_dir $mom_rotary_direction_4th
        set cycle800_st 0
        set cycle800_mode 57
        set coord_ang_1 $coord_ang_A
        set coord_ang_2 $coord_ang_B
        set coord_ang_3 $coord_ang_C
 return 1
      }
 return 0
}


#=============================================================
proc PB_CMD__check_block_CYCLE832 { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output
#
# 22-Dec-2016 shuai - CYCLE832 enhancement.
#

   global mom_logname
   global mom_operation_type
   global mom_operation_name
   global mom_cutmthd_libref
   global mom_machine_mode
   global mom_siemens_method
   global mom_siemens_smoothing
   global mom_siemens_compressor
   global mom_siemens_feedforward
   global mom_siemens_5axis_output
   global mom_siemens_tol_status
   global mom_siemens_tol
   global mom_siemens_rotary_tol
   global mom_siemens_top_surface_smooth
   global mom_siemens_5axis_output_mode
   global mom_siemens_transmit_mode
   global sinumerik_version
   global cycle832_tolm
   global cycle832_v832
   global cycle832_tol
   global cycle832_otol

   if {[string compare $mom_machine_mode "MILL"]} {

      return 0
   }

   if {[info exists mom_siemens_transmit_mode] && $mom_siemens_transmit_mode == "ON"} {

      return 0
   }

   if {![info exists sinumerik_version] } {

      return 0
   }

   if {[string compare $sinumerik_version "V6"] && \
       [string compare $sinumerik_version "V7"] && \
       [string compare $sinumerik_version "from V26 to V44"] && \
       [string compare $sinumerik_version "V45"] && \
       [string compare $sinumerik_version "V47"]} {

      return 0
   }


   # If tolerance is redefined in UDE, output again as User Defined.
   if {![info exists mom_siemens_tol_status] } {
      set mom_siemens_tol_status "System"
   }

   if {[string compare "System" $mom_siemens_tol_status] && [info exists mom_siemens_tol]} {

      set tol [format "%.6f" $mom_siemens_tol]
      MOM_output_literal "_camtolerance=$tol  ;  User Defined"
   }

   if {[info exists mom_cutmthd_libref]} {

      switch $mom_cutmthd_libref {

         OPD0_00021 {set mom_siemens_method "ROUGHING"}
         OPD0_00022 {set mom_siemens_method "ROUGH-FINISHING"}
         OPD0_00023 {set mom_siemens_method "FINISHING"}
         default    {set mom_siemens_method "DESELECTION"}
      }

   } else {

      set mom_siemens_method "DESELECTION"
   }

   # <lili 2013-06-20> Enhancement for new drilling cycle operation type.
   # Output cycle832 for milling operation.
   if {[string compare "Point to Point" $mom_operation_type] && \
       [string compare "Hole Making" $mom_operation_type] && \
       [string compare "Drilling" $mom_operation_type]} {

      # If compressor is on, set circular and helical motion to linear.
      PB_CMD_arc_compressor_mode

      # <22-Dec-2016 shuai> - Add the output conditions when NCK version is 4.5 and 4.7.
      #                       Adjust the TCL codes format to make the logic more clear.
      switch $sinumerik_version {

         "V6" {

            if {[info exists cycle832_v832]} {unset cycle832_v832}

            set list5 {COMPOF COMPCAD COMPCURV BSPLINE}
            set list4 {FFWOF FFWON BRISK}
            set list3 {G64 G641 G642}
            set list2 {TRAFOOF TRAORI TRAORI2}
            set list0 {DESELECTION FINISHING ROUGH-FINISHING ROUGHING}
            set tolm 0
            set i 0

            foreach b5 $list5 b4 $list4 b3 $list3 b2 $list2 b0 $list0 {

               if {[string match $b5 $mom_siemens_compressor]} {
                  set tolm [expr $tolm+$i*100000]
               }

               if {[string match $b4 $mom_siemens_feedforward]} {
                  set tolm [expr $tolm+$i*10000]
               }

               if {[string match $b3 $mom_siemens_smoothing]} {
                  set tolm [expr $tolm+$i*1000]
               }

               if {[string match $b2 $mom_siemens_5axis_output]} {
                  set tolm [expr $tolm+$i*100]
               }

               if {[string match $b0 $mom_siemens_method]} {
                  set tolm [expr $tolm+$i]
               }

               incr i
            }

            set cycle832_tolm $tolm

            PB_call_macro CYCLE832

            return 0
         }

         "V7" -

         "from V26 to V44" {

            set cycle832_v832 "1"

            switch -- $mom_siemens_method {

               "ROUGHING"        {set cycle832_tolm 3}
               "ROUGH-FINISHING" {set cycle832_tolm 2}
               "FINISHING"       {set cycle832_tolm 1}
               default           {set cycle832_tolm 0}
            }

            if {![string compare "V7" $sinumerik_version] } {
               PB_CMD_check_settings_for_cycle832
            }

            return 1
         }

         "V45" -

         "V47" {

            set rot ""
            set top ""

            set cycle832_tol "_camtolerance"
            set cycle832_otol 1

            if {[PB_CMD_detect_5axis_tool_path]} {

               set rot "_ORI"
               set cycle832_otol $mom_siemens_rotary_tol
            }

            if {![string compare "V47" $sinumerik_version] } {

               if {[info exists mom_siemens_top_surface_smooth] && [string compare "" $mom_siemens_top_surface_smooth]} {
                  set top "${mom_siemens_top_surface_smooth}+"
               }
            }

            switch -- $mom_siemens_method {

               "ROUGHING"        {set cycle832_tolm "_ROUGH"}
               "ROUGH-FINISHING" {set cycle832_tolm "_SEMIFIN"}
               "FINISHING"       {set cycle832_tolm "_FINISH"}

               default           {

                  set cycle832_tolm "_OFF"
                  set top ""
                  set rot ""
                  set cycle832_otol 1
               }
            }

            set cycle832_tolm $top$rot$cycle832_tolm

            PB_call_macro CYCLE832_v47

            return 0
         }
      }
   }

   return 0

}


#=============================================================
proc PB_CMD__check_block_CYCLE840_powerline { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global sinumerik_control_version


   if {[info exists sinumerik_control_version] && [string match $sinumerik_control_version "Powerline"]} {
      if { [info exists mom_cycle_option] && [string match "OPTION" $mom_cycle_option] } {
        PB_CMD_cycle_tap
 return 1
      } else {
 return 0
      }
   } else {
 return 0
   }
}


#=============================================================
proc PB_CMD__check_block_CYCLE840_solutionline { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global sinumerik_control_version
   global mom_siemens_cycle_o_ptab
   global mom_siemens_cycle_dmode
   global mom_siemens_cycle_amode
   global mom_machine_mode

   if {[info exists sinumerik_control_version] && [string match $sinumerik_control_version "Solutionline"]} {
      if { [info exists mom_cycle_option] && [string match "OPTION" $mom_cycle_option] } {
         PB_CMD_cycle_tap
         if {[info exists mom_siemens_cycle_o_ptab] && [string match $mom_siemens_cycle_o_ptab "*Module(*"]} {
            set mom_siemens_cycle_o_ptab 4
         }
         if {[string match $mom_machine_mode "MILL"]} {
            set mom_siemens_cycle_dmode [expr 3-$mom_cycle_spindle_axis]
         } elseif {[string match $mom_machine_mode "TURN"]} {
            set mom_siemens_cycle_dmode 100
         }
         set mom_siemens_cycle_amode 0
 return 1
      } else {
 return 0
      }
   } else {
 return 0
   }
}


#=============================================================
proc PB_CMD__check_block_CYCLE84_powerline { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global sinumerik_control_version


   if {[info exists sinumerik_control_version] && [string match $sinumerik_control_version "Powerline"]} {
      if { [info exists mom_cycle_option] && [string match "OPTION" $mom_cycle_option] } {
 return 0
      } else {
         PB_CMD_cycle_tap
 return 1
      }
   } else {
 return 0
   }

}


#=============================================================
proc PB_CMD__check_block_CYCLE84_solutionline { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global sinumerik_control_version
   global mom_siemens_cycle_o_ptab
   global mom_siemens_cycle_dmode
   global mom_siemens_cycle_amode
   global mom_cycle_spindle_axis

   if {[info exists sinumerik_control_version] && [string match $sinumerik_control_version "Solutionline"]} {
      if { [info exists mom_cycle_option] && [string match "OPTION" $mom_cycle_option] } {
 return 0
      } else {
         PB_CMD_cycle_tap
         if {[info exists mom_siemens_cycle_o_ptab] && [string compare $mom_siemens_cycle_o_ptab "*Module(*"]} {
            set mom_siemens_cycle_o_ptab 4
         }
         set mom_siemens_cycle_dmode [expr 3-$mom_cycle_spindle_axis]
         set mom_siemens_cycle_amode 0
 return 1
      }
   } else {
 return 0
   }
}


#=============================================================
proc PB_CMD__check_block_CYCLE97_Thread { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global thread_cycle_flag

   if { [info exists thread_cycle_flag] && $thread_cycle_flag == 1 } {
 return 1
   } else {
 return 0
   }
}


#=============================================================
proc PB_CMD__check_block_CYCLE_powerline { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global sinumerik_control_version


   if {[info exists sinumerik_control_version] && [string match $sinumerik_control_version "Powerline"]} {
 return 1
   } else {
 return 0
   }



}


#=============================================================
proc PB_CMD__check_block_CYCLE_solutionline { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_cycle_feed_to_pos
   global mom_cycle_spindle_axis
   global mom_cycle_hole_dia
   global mom_siemens_cycle_gmode
   global mom_siemens_cycle_dmode
   global mom_siemens_cycle_amode
   global mom_siemens_cycle_liftoff
   global sinumerik_control_version
   global mom_motion_event
   global mom_machine_mode


   if {[info exists sinumerik_control_version] && [string match $sinumerik_control_version "Solutionline"]} {
      if {![info exists mom_motion_event]} {
  return 0
      }
      switch $mom_motion_event {
         drill_move {
            if {[string match $mom_machine_mode "MILL"]} {
               if {![info exists mom_siemens_cycle_gmode]} {set mom_siemens_cycle_gmode 0}
               if {[string match $mom_siemens_cycle_gmode "Depth"]} {set mom_siemens_cycle_gmode 0}
               if {[string match $mom_siemens_cycle_gmode "Diameter"]} {set mom_siemens_cycle_gmode 1}
            } else {
               if {[info exists mom_depth_type] && $mom_depth_type ==5 } {
                  set mom_siemens_cycle_gmode 1
               } else {
                  set mom_siemens_cycle_gmode 0
               }
            }
            if {$mom_siemens_cycle_gmode ==1 && [info exists mom_cycle_hole_dia] } {
               set mom_cycle_feed_to_pos($mom_cycle_spindle_axis) $mom_cycle_hole_dia
            }
            set mom_siemens_cycle_dmode [expr 3-$mom_cycle_spindle_axis]
            set mom_siemens_cycle_amode 0
         }
         drill_dwell_move {
            set mom_siemens_cycle_gmode 0
            set mom_siemens_cycle_dmode [expr 3-$mom_cycle_spindle_axis]
            set mom_siemens_cycle_amode 0

         }
         drill_deep_move -
         drill_break_chip_move {
            set mom_siemens_cycle_gmode 0
            set mom_siemens_cycle_dmode [expr 3-$mom_cycle_spindle_axis]
            set mom_siemens_cycle_amode 0
         }
         bore_move -
         bore_dwell_move {
            set mom_siemens_cycle_plane [expr 3-$mom_cycle_spindle_axis]
            set mom_siemens_cycle_amode 0
         }
         bore_no_drag_move {
            set mom_siemens_cycle_gmode 0
            set mom_siemens_cycle_dmode [expr 3-$mom_cycle_spindle_axis]
            set mom_siemens_cycle_amode 0
         }
         bore_back_move {
            set mom_siemens_cycle_gmode 0
            if {[info exists mom_siemens_cycle_liftoff] && [string match $mom_siemens_cycle_liftoff "No"]} {
                set mom_siemens_cycle_gmode 1
            }
            set mom_siemens_cycle_dmode [expr 3-$mom_cycle_spindle_axis]
            set mom_siemens_cycle_amode 0
         }
         default {}
      };#switch
 return 1
   } else {
 return 0
   }

}


#=============================================================
proc PB_CMD__check_block_FGREF { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output
#

   global mom_logname
   global sinumerik_version

  # Output reference radius of rotary axis for sinumerik SW version 5.
  if {[info exists sinumerik_version] && ([string match "V5" $sinumerik_version] || [string match "V6" $sinumerik_version])} {

     return 1
  }

  return 0

}


#=============================================================
proc PB_CMD__check_block_MCALL { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname


   global thread_cycle_flag

   if {[info exists thread_cycle_flag] && $thread_cycle_flag == 1} {
return 0
   }

 return 1

}


#=============================================================
proc PB_CMD__check_block_MILL { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

  global mom_machine_mode

  if {[string compare $mom_machine_mode "MILL"]} {
return 0
  } else {
return 1
  }

}


#=============================================================
proc PB_CMD__check_block_MILL_fixture_offset { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname

  global mom_machine_mode

  if {![string compare $mom_machine_mode "MILL"]} {
return 1
  }
return 0

}


#=============================================================
proc PB_CMD__check_block_MILL_rotary { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

# This proc is used to output proper address for current mode.
#
  global mom_kin_machine_type
  global mom_siemens_ori_def
  global mom_siemens_3Dcutcom_mode
  global mom_siemens_coord_rotation
  global mom_siemens_5axis_mode
  global mom_siemens_ori_coord
  global mom_prev_tool_axis
  global mom_tool_axis
  global mom_machine_mode

 if {![string compare $mom_machine_mode "MILL"]} {

  # 5 axis orient definition
  if { ![info exists mom_siemens_ori_def] } {
     set mom_siemens_ori_def "ROTARY AXES"
  }


  if { [string match "*ROTARY*" $mom_siemens_ori_def] } {
     if { [info exists mom_tool_axis] && [info exists mom_prev_tool_axis] } {
        if { [VEC3_is_equal mom_tool_axis mom_prev_tool_axis] } {
       #    MOM_suppress Once fourth_axis fifth_axis
        }
     }
     if { $mom_siemens_coord_rotation != 0 && [string match "SWIVELING" $mom_siemens_5axis_mode] } {
        MOM_suppress Once fourth_axis fifth_axis
     }

     #Cutcom type
     if { [info exists mom_siemens_3Dcutcom_mode] } {
        if { [string match "3DF" $mom_siemens_3Dcutcom_mode] || [string match "3DFF" $mom_siemens_3Dcutcom_mode] } {
           global mom_contact_status
           if { [info exists mom_contact_status] && [string match "ON" $mom_contact_status] } {
              MOM_force Once A5 B5 C5
           } else {
              MOM_suppress Once A5 B5 C5
           }
        } else {
           MOM_suppress Once A5 B5 C5
        }
     }

 return 1
  }
 }
 return 0

}


#=============================================================
proc PB_CMD__check_block_MILL_rotation_axes { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

  global mom_operation_type
  global mom_kin_coordinate_system_type
  global mom_out_angle_pos
  global mom_siemens_5axis_mode
  global mom_kin_machine_type
  global sinumerik_version
  global mom_siemens_ori_def
  global mom_siemens_coord_rotation
  global mom_init_pos
  global mom_sys_leader
  global mom_machine_mode

  if {[string compare $mom_machine_mode "MILL"]} {
return 0
  }

  if { [string match "3_axis_mill" $mom_kin_machine_type] } {
return 0
  }

  if { ![info exists mom_siemens_coord_rotation] } {
     set mom_siemens_coord_rotation 0
  }

  if { ![info exists mom_siemens_5axis_mode] } {
     set mom_siemens_5axis_mode TRAFOOF
  }

  if { $mom_siemens_coord_rotation != 0 && [string match "SWIVELING" $mom_siemens_5axis_mode] } {
return 0
  }

  if { [info exists sinumerik_version] && [string match "V7" $sinumerik_version] && [info exists mom_siemens_ori_def] && ![string match "*ROTARY*" $mom_siemens_ori_def] } {
return 0
  } else {
     #for simulation, in case rotary axis limits are reloaded from machine
     global mom_prev_out_angle_pos mom_sys_leader
     global mom_kin_4th_axis_max_limit mom_kin_4th_axis_direction mom_kin_4th_axis_min_limit mom_kin_4th_axis_leader
     global mom_kin_5th_axis_max_limit mom_kin_5th_axis_direction mom_kin_5th_axis_min_limit mom_kin_5th_axis_leader
     MOM_force once fourth_axis fifth_axis
     if { $mom_siemens_coord_rotation == 1 } {
        if { [info exists mom_init_pos(3)] } {
           set mom_out_angle_pos(0) [ROTSET $mom_init_pos(3) $mom_prev_out_angle_pos(0)  $mom_kin_4th_axis_direction  $mom_kin_4th_axis_leader  mom_sys_leader(fourth_axis)  $mom_kin_4th_axis_min_limit  $mom_kin_4th_axis_max_limit]
        }
        if { [info exists mom_init_pos(4)] } {
          set mom_out_angle_pos(1) [ROTSET $mom_init_pos(4) $mom_prev_out_angle_pos(1)  $mom_kin_5th_axis_direction   $mom_kin_5th_axis_leader   mom_sys_leader(fifth_axis)  $mom_kin_5th_axis_min_limit  $mom_kin_5th_axis_max_limit]
        }
     }
return 1
  }

}


#=============================================================
proc PB_CMD__check_block_MILL_vector { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

# This proc is used to output proper address for current mode.
#
  global mom_kin_machine_type
  global mom_siemens_ori_def
  global mom_siemens_3Dcutcom_mode
  global mom_siemens_coord_rotation
  global mom_siemens_5axis_mode
  global mom_siemens_ori_coord
  global mom_prev_tool_axis
  global mom_tool_axis
  global mom_machine_mode

 if {![string compare $mom_machine_mode "MILL"]} {

  # 5 axis orient definition
  if { ![info exists mom_siemens_ori_def] } {
     set mom_siemens_ori_def "ROTARY AXES"
  }


  if { [string match "*VECTOR*" $mom_siemens_ori_def] && [string compare "3_axis_mill" $mom_kin_machine_type]  } {

     if { [string match "ORIMKS" $mom_siemens_ori_coord] && $mom_siemens_coord_rotation == 1 } {
        global mom_tool_axis mom_csys_matrix csys_matrix tool_axis

        MTX3_transpose mom_csys_matrix csys_matrix
        MTX3_vec_multiply mom_tool_axis csys_matrix tool_axis
        VMOV 3 tool_axis mom_tool_axis
     }
     if { $mom_siemens_coord_rotation != 0 && [string match "SWIVELING" $mom_siemens_5axis_mode] } {
        MOM_suppress Once A3 B3 C3
     }

     #Cutcom type
     if { [info exists mom_siemens_3Dcutcom_mode] } {
        if { [string match "3DF" $mom_siemens_3Dcutcom_mode] || [string match "3DFF" $mom_siemens_3Dcutcom_mode] } {
           global mom_contact_status
           if { [info exists mom_contact_status] && [string match "ON" $mom_contact_status] } {
              MOM_force Once A5 B5 C5
           } else {
              MOM_suppress Once A5 B5 C5
           }
        } else {
           MOM_suppress Once A5 B5 C5
        }
     }
return 1
  }
 }
return 0




}


#=============================================================
proc PB_CMD__check_block_ORIRESET { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output
#

  global mom_init_pos
  global mom_out_angle_pos
  global mom_kin_machine_type
  global mom_machine_mode
  global sinumerik_version
  global mom_siemens_ori_def
  global mom_siemens_coord_rotation
  global mom_siemens_5axis_mode

  if {[string compare $mom_machine_mode "MILL"]} {

     return 0
  }

  if {[string match "3_axis_mill" $mom_kin_machine_type]} {

     return 0
  }

  if {![info exists mom_siemens_coord_rotation] } {
     set mom_siemens_coord_rotation 0
  }

  if {![info exists mom_siemens_5axis_mode] } {
     set mom_siemens_5axis_mode TRAFOOF
  }

  if {$mom_siemens_coord_rotation != 0 && [string match "SWIVELING" $mom_siemens_5axis_mode]} {

     return 0
  }

  if {[info exists sinumerik_version] && ([string match "V7" $sinumerik_version] || [string match "from V26 to V44" $sinumerik_version] || [string match "V45" $sinumerik_version] || [string match "V47" $sinumerik_version]) && \
      [info exists mom_siemens_ori_def] && ![string match "*ROTARY*" $mom_siemens_ori_def]} {

     if {$mom_siemens_coord_rotation == 1} {

        if {[info exists mom_init_pos(3)]} {
           set mom_out_angle_pos(0) $mom_init_pos(3)
        }

        if {[info exists mom_init_pos(4)]} {
           set mom_out_angle_pos(1) $mom_init_pos(4)
        }
     }

     return 1
  }

  return 0

}


#=============================================================
proc PB_CMD__check_block_TURN { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_sys_cycle95_start
   global mom_machine_mode

   if {[string compare $mom_machine_mode "TURN"]} {
   return 0
   } else {
      if { [info exists mom_sys_cycle95_start] && $mom_sys_cycle95_start } {
   return 0
      } else {
   return 1
      }
   }
}


#=============================================================
proc PB_CMD__check_block_TURN_circular_for_cycle95 { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_sys_output_contour_motion
   global mom_siemens_cycle95_output_mode
   global mom_sys_cycle95_start
   global mom_machine_mode

   if {[string compare $mom_machine_mode "TURN"]} {
   return 0
   }

   if { [info exists mom_sys_cycle95_start] && $mom_sys_cycle95_start } {

      if { [info exists mom_siemens_cycle95_output_mode] &&\
           [string match "LBL_END" $mom_siemens_cycle95_output_mode] } {

         global cycle95_contour_file
         set o_buffer [MOM_do_template circular_move_cycle95 CREATE]
         lappend cycle95_contour_file $o_buffer
   return 0
      } else {
   return 1
      }
   } else {
   return 0
   }

}


#=============================================================
proc PB_CMD__check_block_TURN_linear_for_cycle95 { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_machine_mode
   global mom_sys_output_contour_motion
   global mom_siemens_cycle95_output_mode
   global mom_sys_cycle95_start

   if {[string compare $mom_machine_mode "TURN"]} {
   return 0
   }

   if { [info exists mom_sys_cycle95_start] && $mom_sys_cycle95_start } {
      if { [info exists mom_siemens_cycle95_output_mode] && [string match "LBL_END" $mom_siemens_cycle95_output_mode] } {
         global cycle95_contour_file
         set o_buffer [MOM_do_template linear_move_cycle95 CREATE]
         lappend cycle95_contour_file $o_buffer

   return 0
      } else {
   return 1
      }
   } else {
   return 0
   }



 return 1

}


#=============================================================
proc PB_CMD__check_block_TURN_set_angle { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

  global mom_channel_id
  global mom_tool_axis
  global mom_out_angle_pos
  global RAD2DEG
  global mom_rotation_angle
  global mom_rotate_axis_type
  global mom_machine_mode

  if {![string compare $mom_machine_mode "TURN"]} {

  if {![array exists mom_tool_axis]} {
      set mom_out_angle_pos(0) 0.0
  } else {
      set mom_out_angle_pos(0) [expr $RAD2DEG*atan2($mom_tool_axis(0),$mom_tool_axis(2))]
  }

return 1
  } else {
return 0
}

}


#=============================================================
proc PB_CMD__check_block_cycle_plane_change { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_siemens_cycle_count

   if {$mom_siemens_cycle_count==0} {
 return 0
   } else {
 return 1
   }
}


#=============================================================
proc PB_CMD__check_block_g59 { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_special_output
   global mom_mcs_info
   global mom_mcsname_attach_opr
   global mom_operation_name
   global mom_g59_origin
   global mom_parent_csys_matrix

  if {[info exists mom_special_output] && $mom_special_output == 0} {
      set mcs_name $mom_mcsname_attach_opr($mom_operation_name)
      set parent_name $mom_mcs_info($mcs_name,parent)
      if {[string compare $parent_name ""] && $mom_mcs_info($parent_name,purpose)==0} {
         if {$mom_mcs_info($parent_name,output_type) == 2} {
            set mom_g59_origin(0) $mom_parent_csys_matrix(9)
            set mom_g59_origin(1) $mom_parent_csys_matrix(10)
            set mom_g59_origin(2) $mom_parent_csys_matrix(11)
 return 1
         } elseif {$mom_mcs_info($parent_name,output_type) == 0} {
            set g59_name $parent_name
            set fixture $mom_mcs_info($g59_name,parent)
            set point(0) [expr $mom_mcs_info($g59_name,org,0)-$mom_mcs_info($fixture,org,0)]
            set point(1) [expr $mom_mcs_info($g59_name,org,1)-$mom_mcs_info($fixture,org,1)]
            set point(2) [expr $mom_mcs_info($g59_name,org,2)-$mom_mcs_info($fixture,org,2)]

            set matrix(0) $mom_mcs_info($fixture,xvec,0)
            set matrix(1) $mom_mcs_info($fixture,xvec,1)
            set matrix(2) $mom_mcs_info($fixture,xvec,2)
            set matrix(3) $mom_mcs_info($fixture,yvec,0)
            set matrix(4) $mom_mcs_info($fixture,yvec,1)
            set matrix(5) $mom_mcs_info($fixture,yvec,2)
            set matrix(6) $mom_mcs_info($fixture,zvec,0)
            set matrix(7) $mom_mcs_info($fixture,zvec,1)
            set matrix(8) $mom_mcs_info($fixture,zvec,2)

            MTX3_vec_multiply point matrix mom_g59_origin
 return 1
         }
      }
  } else {
      set mcs_name $mom_mcsname_attach_opr($mom_operation_name)
      set parent_name $mom_mcs_info($mcs_name,parent)
      if {[string compare $parent_name ""]} {
          if {$mom_mcs_info($parent_name,purpose)==0} {
              if {$mom_mcs_info($parent_name,output_type) == 0} {
                 set g59_name $parent_name
                 set g59_parent $mom_mcs_info($g59_name,parent)
                 if {$mom_mcs_info($g59_parent,purpose)==0 && $mom_mcs_info($g59_parent,output_type)==2} {
                     set fixture $g59_parent
                 } elseif {$mom_mcs_info($g59_parent,purpose)==0 && $mom_mcs_info($g59_parent,output_type)==0} {
                     set fixture $mom_mcs_info($g59_parent,parent)
                 } else {
                     set fixture $g59_name
                 }
                 set point(0) [expr $mom_mcs_info($g59_name,org,0)-$mom_mcs_info($fixture,org,0)]
                 set point(1) [expr $mom_mcs_info($g59_name,org,1)-$mom_mcs_info($fixture,org,1)]
                 set point(2) [expr $mom_mcs_info($g59_name,org,2)-$mom_mcs_info($fixture,org,2)]

                 set matrix(0) $mom_mcs_info($fixture,xvec,0)
                 set matrix(1) $mom_mcs_info($fixture,xvec,1)
                 set matrix(2) $mom_mcs_info($fixture,xvec,2)
                 set matrix(3) $mom_mcs_info($fixture,yvec,0)
                 set matrix(4) $mom_mcs_info($fixture,yvec,1)
                 set matrix(5) $mom_mcs_info($fixture,yvec,2)
                 set matrix(6) $mom_mcs_info($fixture,zvec,0)
                 set matrix(7) $mom_mcs_info($fixture,zvec,1)
                 set matrix(8) $mom_mcs_info($fixture,zvec,2)

                 MTX3_vec_multiply point matrix mom_g59_origin
  return 1
              }
          }
      }
  }
  return 0
}


#=============================================================
proc PB_CMD__check_block_mill_work_plane { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

  global mom_machine_mode

  if {[string compare $mom_machine_mode "MILL"]} {
return 0
  } else {
return 1
  }

}


#=============================================================
proc PB_CMD__check_block_ori_coordinate { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   # Output 5 axis orientation coordinate
  global mom_kin_machine_type
  global mom_siemens_ori_coord
  global mom_siemens_ori_inter
  global mom_siemens_5axis_output_mode
  global mom_siemens_5axis_mode
  global mom_siemens_transmit_mode
  global mom_machine_mode

  if {[string compare $mom_machine_mode "MILL"]} {
 return 0
  }

  if {[info exist mom_siemens_transmit_mode] && $mom_siemens_transmit_mode == "ON"} {
 return 0
  }

  if { ![string match "3_axis_mill*" $mom_kin_machine_type] && ![string match "SWIVELING" $mom_siemens_5axis_mode] } {
     if { [info exists mom_siemens_ori_coord] && [info exists mom_siemens_5axis_output_mode] && $mom_siemens_5axis_output_mode ==1} {
        return 1
     }
  }
 return 0
}


#=============================================================
proc PB_CMD__check_block_ori_interpolation { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

  # Output 5 axis orientation interpolation
  global mom_kin_machine_type
  global mom_siemens_ori_coord
  global mom_siemens_ori_inter
  global mom_siemens_5axis_mode
  global mom_siemens_5axis_output_mode
  global mom_siemens_transmit_mode
  global mom_machine_mode

  if {[string compare $mom_machine_mode "MILL"]} {
 return 0
  }

  if {[info exist mom_siemens_transmit_mode] && $mom_siemens_transmit_mode == "ON"} {
 return 0
  }

  if { ![string match "3_axis_mill*" $mom_kin_machine_type] && ![string match "SWIVELING" $mom_siemens_5axis_mode] } {
     if { [info exists mom_siemens_ori_inter] && [info exists mom_siemens_5axis_output_mode] && $mom_siemens_5axis_output_mode ==1} {
        return 1
     }
  }
 return 0
}


#=============================================================
proc PB_CMD__check_block_reset_cycle800 { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

  global mom_siemens_coord_rotation
  global mom_kin_machine_type
  global mom_siemens_5axis_mode
  global mom_siemens_5axis_output_mode
  global mom_machine_mode
  global coord_ang_A coord_ang_B coord_ang_C

  if {[string compare $mom_machine_mode "MILL"]} {
return 0
  }

  if { $mom_siemens_coord_rotation != 0 } {
     if { [string match "SWIVELING" $mom_siemens_5axis_mode] } {
return 1
     }
  }

return 0
}


#=============================================================
proc PB_CMD__check_block_reset_cycle832 { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output
#
# 22-Dec-2016 shuai - CYCLE832 enhancement.
#

  global sinumerik_version
  global mom_operation_type
  global mom_machine_mode
  global cycle832_tol
  global cycle832_otol
  global cycle832_tolm

  if {[string compare $mom_machine_mode "MILL"]} {

     return 0
  }

  if {![info exists sinumerik_version] } {

     return 0
  }

  if {[string compare $sinumerik_version "V6"] && \
      [string compare $sinumerik_version "V7"] && \
      [string compare $sinumerik_version "from V26 to V44"] && \
      [string compare $sinumerik_version "V45"] && \
      [string compare $sinumerik_version "V47"]} {

     return 0
  }


  # <lili 2013-06-20> Enhancement for new drilling cycle operation type.
  if {[string compare "Point to Point" $mom_operation_type] && \
      [string compare "Hole Making" $mom_operation_type] && \
      [string compare "Drilling" $mom_operation_type]} {

     return 1

  } else {

     return 0
  }

}


#=============================================================
proc PB_CMD__check_block_reset_trans { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

  global mom_siemens_coord_rotation
  global mom_kin_machine_type
  global mom_siemens_5axis_mode
  global mom_siemens_5axis_output_mode
  global mom_machine_mode
  global coord_ang_A coord_ang_B coord_ang_C
  global coord_offset_flag

  if {[string compare $mom_machine_mode "MILL"]} {
return 0
  }

  if { $mom_siemens_coord_rotation != 0 } {
     if { ![string match "SWIVELING" $mom_siemens_5axis_mode] } {
return 1
     }
  }

  if { [info exists coord_offset_flag] && $coord_offset_flag == 1 } {
return 1
  }

return 0

}


#=============================================================
proc PB_CMD__check_block_rotary { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

# This proc is used to output proper address for current mode.
#
  global mom_kin_machine_type
  global mom_siemens_ori_def
  global mom_siemens_3Dcutcom_mode
  global mom_siemens_coord_rotation
  global mom_siemens_5axis_mode
  global mom_siemens_ori_coord
  global mom_prev_tool_axis
  global mom_tool_axis

  # 5 axis orient definition
  if { ![info exists mom_siemens_ori_def] } {
     set mom_siemens_ori_def "ROTARY AXES"
  }


  if { [string match "*ROTARY*" $mom_siemens_ori_def] } {
     if { [info exists mom_tool_axis] && [info exists mom_prev_tool_axis] } {
        if { [VEC3_is_equal mom_tool_axis mom_prev_tool_axis] } {
           MOM_suppress Once fourth_axis fifth_axis
        }
     }
     if { $mom_siemens_coord_rotation != 0 && [string match "SWIVELING" $mom_siemens_5axis_mode] } {
        MOM_suppress Once fourth_axis fifth_axis
     }

     #Cutcom type
     if { [info exists mom_siemens_3Dcutcom_mode] } {
        if { [string match "3DF" $mom_siemens_3Dcutcom_mode] || [string match "3DFF" $mom_siemens_3Dcutcom_mode] } {
           global mom_contact_status
           if { [info exists mom_contact_status] && [string match "ON" $mom_contact_status] } {
              MOM_force Once A5 B5 C5
           } else {
              MOM_suppress Once A5 B5 C5
           }
        } else {
           MOM_suppress Once A5 B5 C5
        }
     }

 return 1
  }

 return 0
}


#=============================================================
proc PB_CMD__check_block_spos { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

  global mom_channel_id
  global mom_tool_axis
  global mom_out_angle_pos
  global RAD2DEG
  global mom_rotation_angle
  global mom_rotate_axis_type
  global mom_machine_mode

  if {![string compare $mom_machine_mode "TURN"]} {


  if {[info exists mom_rotate_axis_type] && [info exists mom_rotation_angle]} {
     if {[string match "AAXIS" $mom_rotate_axis_type]} {
         unset mom_rotate_axis_type
     } else {
         set mom_rotation_angle 0.0
     }
  } else {
       set mom_rotation_angle 0.0
     }
return 1
  } else {
return 0
}


}


#=============================================================
proc PB_CMD__check_block_trafoof { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

  global mom_coordinate_output_mode
  global mom_siemens_5axis_output_mode
  global mom_machine_mode

  if {[string compare $mom_machine_mode "MILL"]} {
return 0
  }

  if {[info exist mom_coordinate_output_mode] && $mom_coordinate_output_mode == "TRANSMIT"} {
     set mom_coordinate_output_mode "XY-Z OUTPUT"
return 1
  } elseif { $mom_siemens_5axis_output_mode == 1 } {
     set mom_siemens_5axis_output_mode 0
return 1
  } else {
return 0
  }


}


#=============================================================
proc PB_CMD__check_block_transmit { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output


  global mom_siemens_transmit_mode
  global mom_coordinate_output_mode
  global mom_machine_mode

  if {[string compare $mom_machine_mode "MILL"]} {
return 0
  }

  if {[info exist mom_siemens_transmit_mode] && $mom_siemens_transmit_mode == "ON"} {
     set mom_coordinate_output_mode "TRANSMIT"

     global mom_pos mom_out_angle_pos
     global RAD2DEG
     global mom_prev_rot_ang_5th
     global mom_kin_5th_axis_direction
     global mom_kin_5th_axis_leader mom_sys_leader
     global mom_kin_5th_axis_min_limit mom_kin_5th_axis_max_limit

     if {![EQ_is_zero $mom_pos(1)]} {
        if {![info exists mom_prev_rot_ang_5th]} {set mom_prev_rot_ang_5th 0.0}
        set mom_pos(4) [expr atan2($mom_pos(1),$mom_pos(0))*$RAD2DEG]
        set mom_out_angle_pos(1) [ROTSET $mom_pos(4) $mom_prev_rot_ang_5th $mom_kin_5th_axis_direction  $mom_kin_5th_axis_leader  mom_sys_leader(fifth_axis)  $mom_kin_5th_axis_min_limit  $mom_kin_5th_axis_max_limit]
        set mom_pos(0) [expr hypot($mom_pos(0),$mom_pos(1))]
        set mom_pos(1) 0.0
        MOM_do_template transmit_start
        MOM_disable_address fifth_axis
     }

 return 1
  } else {
 return 0
  }
}


#=============================================================
proc PB_CMD__check_block_traori_trafoof { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

  global mom_siemens_transmit_mode
  global mom_coordinate_output_mode
  global mom_machine_mode
  global mom_siemens_5axis_output
  global mom_siemens_5axis_output_mode
  global spindle

  if {[string compare $mom_machine_mode "MILL"]} {
return 0
  }

  if {![info exist mom_siemens_transmit_mode] || $mom_siemens_transmit_mode != "ON"} {
 return 1
  } else {
 return 0
  }

}


#=============================================================
proc PB_CMD__check_block_turn_work_plane { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

  global mom_machine_mode

  if {[string compare $mom_machine_mode "TURN"]} {
return 0
  } else {
return 1
  }
}


#=============================================================
proc PB_CMD__check_block_vector { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

# This proc is used to output proper address for current mode.
#
  global mom_kin_machine_type
  global mom_siemens_ori_def
  global mom_siemens_3Dcutcom_mode
  global mom_siemens_coord_rotation
  global mom_siemens_5axis_mode
  global mom_siemens_ori_coord
  global mom_prev_tool_axis
  global mom_tool_axis

  # 5 axis orient definition
  if { ![info exists mom_siemens_ori_def] } {
     set mom_siemens_ori_def "ROTARY AXES"
  }


  if { [string match "*VECTOR*" $mom_siemens_ori_def] && [string compare "3_axis_mill" $mom_kin_machine_type]  } {

     if { [string match "ORIMKS" $mom_siemens_ori_coord] && $mom_siemens_coord_rotation == 1 } {
        global mom_tool_axis mom_csys_matrix csys_matrix tool_axis

        MTX3_transpose mom_csys_matrix csys_matrix
        MTX3_vec_multiply mom_tool_axis csys_matrix tool_axis
        VMOV 3 tool_axis mom_tool_axis
     }
     if { $mom_siemens_coord_rotation != 0 && [string match "SWIVELING" $mom_siemens_5axis_mode] } {
        MOM_suppress Once A3 B3 C3
     }

     #Cutcom type
     if { [info exists mom_siemens_3Dcutcom_mode] } {
        if { [string match "3DF" $mom_siemens_3Dcutcom_mode] || [string match "3DFF" $mom_siemens_3Dcutcom_mode] } {
           global mom_contact_status
           if { [info exists mom_contact_status] && [string match "ON" $mom_contact_status] } {
              MOM_force Once A5 B5 C5
           } else {
              MOM_suppress Once A5 B5 C5
           }
        } else {
           MOM_suppress Once A5 B5 C5
        }
     }
return 1
  }

return 0


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
# 09-17-2015 szl - Output a warning message in NC output while postprocessor
#                  cannot calculate the valid rotary position.

   global mom_sys_abort_next_event
   global mom_warning_info
   global mom_sys_warning_output
   global mom_sys_warning_output_option

   if { [info exists mom_sys_abort_next_event] } {

      switch $mom_sys_abort_next_event {
        1 {
            unset mom_sys_abort_next_event
            if { ![string compare "WARNING: unable to determine valid rotary positions" $mom_warning_info] } {

               set save_mom_sys_warning_putput $mom_sys_warning_output
               set save_mom_sys_warning_output_option $mom_sys_warning_output_option


               set mom_sys_warning_output "ON"
               set mom_sys_warning_output_option "LIST"

               MOM_catch_warning

               set mom_sys_warning_output $save_mom_sys_warning_putput
               set mom_sys_warning_output_option $save_mom_sys_warning_output_option
            }
        }
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
proc PB_CMD_arc_compressor_mode { } {
#=============================================================
# This procedure is used to set arc mode by Sinumerik compressor.

  global mom_siemens_compressor
  global mom_kin_arc_output_mode save_mom_kin_arc_output_mode
  global mom_kin_helical_arc_output_mode save_mom_kin_helical_arc_output_mode

  if {[info exists mom_siemens_compressor] && [string compare "COMPOF" $mom_siemens_compressor]} {

     if {![info exists save_mom_kin_arc_output_mode] } {

        set save_mom_kin_arc_output_mode $mom_kin_arc_output_mode
        set save_mom_kin_helical_arc_output_mode $mom_kin_helical_arc_output_mode
     }

     set mom_kin_arc_output_mode "LINEAR"
     set mom_kin_helical_arc_output_mode "LINEAR"

     MOM_reload_kinematics
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
proc PB_CMD_auto_3D_rotation { } {
#=============================================================
# This command is used to get auto 3D coordinate rotation by tool axis vector.

  global mom_kin_machine_type
  global save_mom_kin_machine_type
  global mom_tool_axis mom_tool_axis_type
  global mom_siemens_coord_rotation
  global mom_kin_coordinate_system_type
  global mom_siemens_5axis_mode
  global mom_operation_type
  global mom_kin_4th_axis_point save_mom_kin_4th_axis_point
  global mom_kin_5th_axis_point save_mom_kin_5th_axis_point
  global mom_kin_4th_axis_vector save_mom_kin_4th_axis_vector
  global mom_kin_5th_axis_vector save_mom_kin_5th_axis_vector
  global mom_sys_4th_axis_has_limits
  global mom_sys_5th_axis_has_limits
  global save_mom_sys_4th_axis_has_limits
  global save_mom_sys_5th_axis_has_limits
  global mom_mcs_goto mom_pos mom_prev_pos
  global mom_out_angle_pos
  global coord_ang_A coord_ang_B coord_ang_C
  global coord_ref_x coord_ref_y coord_ref_z
  global RAD2DEG DEG2RAD
  global mom_tool_path_type

  if {![string match "*5_axis*" $mom_kin_machine_type]} {return}
  if {[info exists mom_kin_coordinate_system_type] && [string match "CSYS" $mom_kin_coordinate_system_type]} {return}
  if {[info exists mom_siemens_5axis_mode] && [string match "TRAFOOF" $mom_siemens_5axis_mode]} {return}

  if {![info exists mom_tool_axis_type]} {set mom_tool_axis_type 0}
  if { ![info exists mom_tool_axis_type] } {
     set mom_tool_axis_type 0
  }
  if { ![info exists mom_tool_path_type] } {
     set mom_tool_path_type "undefined"
  }
  if { [EQ_is_equal $mom_tool_axis(2) 1.0]  || \
       ($mom_tool_axis_type >= 2  &&  [string match "Variable-axis *" $mom_operation_type])  || \
       [string match "Sequential Mill Main Operation" $mom_operation_type] || \
       ([string match "variable_axis" $mom_tool_path_type] && ![string match "Variable-axis *" $mom_operation_type])} {
return
  } else {
     set mom_siemens_coord_rotation 2
  }

# Get initial/first point by rotation
  if {[string match "5_axis_dual_head" $mom_kin_machine_type]} {
     set rot0 [expr $mom_out_angle_pos(1)*$DEG2RAD]
     set rot1 [expr $mom_out_angle_pos(0)*$DEG2RAD]
     set mom_pos(3) $mom_out_angle_pos(1)
     set mom_pos(4) $mom_out_angle_pos(0)
  } else {
     set rot0 [expr $mom_out_angle_pos(0)*$DEG2RAD]
     set rot1 [expr $mom_out_angle_pos(1)*$DEG2RAD]
     set mom_pos(3) $mom_out_angle_pos(0)
     set mom_pos(4) $mom_out_angle_pos(1)
  }

# Reolad kinematics to dual-table machine
  PB_CMD_save_kinematics
  if {[string match "5_axis_dual_head" $mom_kin_machine_type]} {
     PB_CMD_swap_4th_5th_kinematics
     set angle_pos(0)         $mom_out_angle_pos(0)
     set mom_out_angle_pos(0) $mom_out_angle_pos(1)
     set mom_out_angle_pos(1) $angle_pos(0)
  }
  if {![string match "5_axis_dual_table" $mom_kin_machine_type]} {
     set mom_kin_machine_type "5_axis_dual_table"
  }
  set x 0.0; set y 0.0; set z 0.0;
  VEC3_init x y z mom_kin_4th_axis_point
  VEC3_init x y z mom_kin_5th_axis_point
  MOM_reload_kinematics

  VECTOR_ROTATE mom_kin_5th_axis_vector [expr -1*$rot1] mom_mcs_goto v
  VECTOR_ROTATE mom_kin_4th_axis_vector [expr -1*$rot0] v mom_pos
  MOM_reload_variable -a mom_pos

  global cycle_init_flag mom_current_motion
  global mom_cycle_rapid_to
  if {[info exists cycle_init_flag] && $cycle_init_flag == "TRUE"} {
     if { [string match "initial_move" $mom_current_motion]} {
         set mom_pos(2) [expr $mom_pos(2) + $mom_cycle_rapid_to]
     }
  }

  global mom_prev_out_angle_pos
  set mom_prev_out_angle_pos(0) $mom_out_angle_pos(0)
  set mom_prev_out_angle_pos(1) $mom_out_angle_pos(1)
  MOM_reload_variable -a mom_out_angle_pos
  MOM_reload_variable -a mom_prev_out_angle_pos

# Initialize coordinate rotation angles
  set coord_ang_A 0.0 ; set coord_ang_B 0.0 ; set coord_ang_C 0.0
  set coord_ref_x 0.0 ; set coord_ref_y 0.0 ; set coord_ref_z 0.0
  set X(0) 1.0; set X(1) 0.0; set X(2) 0.0
  set Y(0) 0.0; set Y(1) 1.0; set Y(2) 0.0
  set Z(0) 0.0; set Z(1) 0.0; set Z(2) 1.0

# Calculate rotation matrix
    VECTOR_ROTATE mom_kin_4th_axis_vector [expr $rot0] X v1
    VECTOR_ROTATE mom_kin_4th_axis_vector [expr $rot0] Y v2
    VECTOR_ROTATE mom_kin_4th_axis_vector [expr $rot0] Z v3

    VECTOR_ROTATE mom_kin_5th_axis_vector [expr $rot1] v1 X
    VECTOR_ROTATE mom_kin_5th_axis_vector [expr $rot1] v2 Y
    VECTOR_ROTATE mom_kin_5th_axis_vector [expr $rot1] v3 Z

    MTX3_init_x_y_z X Y Z rotation_matrix

 # Calculate euler angles , rotation order is X->Y->Z
    if {[info exists rotation_matrix]} {
    set m0 $rotation_matrix(0)
    set m1 $rotation_matrix(1)
    set m2 $rotation_matrix(2)
    set m3 $rotation_matrix(3)
    set m4 $rotation_matrix(4)
    set m5 $rotation_matrix(5)
    set m6 $rotation_matrix(6)
    set m7 $rotation_matrix(7)
    set m8 $rotation_matrix(8)

    set cos_b_sq [expr $m0*$m0 + $m3*$m3]

    if {[EQ_is_equal $cos_b_sq 0.0]} {

      set cos_b 0.0
      set cos_c 1.0
      set cos_a $m4
      set sin_c 0.0
      set sin_a [expr -1*$m5]

      if {$m6 < 0.0} {
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

    set coord_ang_A [expr -atan2($sin_a,$cos_a)*$RAD2DEG]
    set coord_ang_B [expr -atan2($sin_b,$cos_b)*$RAD2DEG]
    set coord_ang_C [expr -atan2($sin_c,$cos_c)*$RAD2DEG]

 }
}


#=============================================================
proc PB_CMD_before_motion { } {
#=============================================================

  global mom_machine_mode
  if {[string compare $mom_machine_mode "MILL"]} {
return
  }

# Output motion type for following motions
  global mom_motion_type
  switch $mom_motion_type {
       "FIRSTCUT" -
       "DEPARTURE" -
       "STEPOVER" -
       "CUT" { PB_CMD_output_motion_message}
   }

# Detect operation mode for transformation and XZ_C mode
   PB_CMD_detect_operation_mode

# Output cutcom mode and caculate positions
   PB_CMD_calculate_cutcom

# Output tool tip position independent with machine kinematics(TRAORI).
   PB_CMD_output_5axis

# soft limit control
  # PB_CMD_control_soft_limit
}


#=============================================================
proc PB_CMD_before_output { } {
#=============================================================
# This command allows users to massage the NC data (mom_o_buffer) before
# it finally gets output.  If present in the post, this command gets executed
# by MOM_before_output automatically.
#
# - DO NOT overload MOM_before_output! All customization should be done here!
# - DO NOT call any MOM output commands in this command, it will become cyclicle!
# - No need to attach this command to any event marker.
#

   global mom_o_buffer
   global mom_sys_leader
   global mom_sys_control_out mom_sys_control_in
}


#=============================================================
proc PB_CMD_calculate_R200 { } {
#=============================================================
  global mom_ude_spindles_distance
  global mom_part_transfer_contact_point_pos
  global mom_part_transfer_contact_position
  global mom_csys_origin
  global mom_fixture_offset_value
  global MCS_z_offset

  if {[info exists MCS_z_offset($mom_fixture_offset_value)]} {
      set main_offset [expr $mom_csys_origin(2) + $MCS_z_offset($mom_fixture_offset_value)]
  } else {
      set main_offset $mom_csys_origin(2)
  }

  set mom_part_transfer_contact_position [expr $mom_part_transfer_contact_point_pos(2)-$mom_ude_spindles_distance + $main_offset]
}


#=============================================================
proc PB_CMD_calculate_cutcom { } {
#=============================================================
# This command is used to caculate cutcom mode LEFT/RIGHT for CUT3DC and output contact point.
# For surface 3D cutcom, output default G41 as active motion.
# This command must be added in PB_CMD_before_motion.

  global mom_siemens_3Dcutcom_mode
  global mom_cutcom_mode mom_cutcom_status
  global mom_pos mom_prev_pos mom_mcs_goto mom_prev_mcs_goto
  global mom_contact_point mom_contact_center mom_contact_normal
  global mom_spindle_axis mom_tool_axis
  global mom_contact_status
  global mom_tool_tracking_type
  global mcs_contact_normal
  global mom_cutter_data_output_indicator
  global mom_siemens_5axis_output_mode
  global mom_tool_taper_angle

  if { [info exists mom_siemens_3Dcutcom_mode] && $mom_siemens_3Dcutcom_mode == "OFF" } {
     if { ![info exists mom_cutter_data_output_indicator] || $mom_cutter_data_output_indicator == 0 } {
        if {$mom_cutcom_status == "LEFT" || $mom_cutcom_status == "RIGHT"} {
           if { ![info exists mom_tool_taper_angle] } {
              set mom_tool_taper_angle 0.0
           }
           if { $mom_siemens_5axis_output_mode == 1 && [EQ_is_zero $mom_tool_taper_angle] } {
              MOM_output_literal "CUT3DC"
              set mom_siemens_3Dcutcom_mode "3DC_3axis"
           } else {
           #Cutcom 2&1/2
              MOM_output_literal "CUT2DF"
              set mom_siemens_3Dcutcom_mode "2DF"
           }
        }
     }
  }

  if {![info exists mom_contact_status]} {
return
  }

  if { [info exists mom_siemens_3Dcutcom_mode] && [string match "3D*" $mom_siemens_3Dcutcom_mode]} {
     if {$mom_siemens_3Dcutcom_mode == "3DC_3axis"} {
return
     }
     if {[string match "3DF*" $mom_siemens_3Dcutcom_mode]} {
        set dot [VEC3_dot mom_tool_axis mom_contact_normal]
        if {[EQ_is_zero $dot] } {
           global mom_drive_method
       ##
           if {[info exists mom_drive_method] && $mom_drive_method == 120} {
              if {$mom_siemens_5axis_output_mode == 1} {
                 MOM_output_literal "CUT3DC"
                 set mom_siemens_3Dcutcom_mode "3DC"
              } else {
                 MOM_output_literal "CUT2DF"
                 set mom_siemens_3Dcutcom_mode "2DF"
              }
           } else {
              global mom_sys_abort_next_event
              # set mom_sys_abort_next_event 1
           }
        }
     } elseif {0 && $mom_siemens_3Dcutcom_mode == "3DC"} {
        set dot [VEC3_dot mom_tool_axis mom_contact_normal]
        if {![EQ_is_zero $dot] } {
           MOM_output_literal "CUT3DF"
           set mom_siemens_3Dcutcom_mode "3DF"
        }
     }
     if {$mom_contact_status == "ON"} {
        set mom_cutcom_status "ON"
        set mom_cutcom_mode "LEFT"
        MCS_VECTOR mom_contact_normal mcs_contact_normal;# get contact normal vector reference mcs
        if {$mom_siemens_3Dcutcom_mode == "3DC"} {
           VMOV 3 mom_mcs_goto end_point
           VMOV 3 mom_prev_mcs_goto start_point
           VEC3_sub end_point start_point vec_move ;# get move vector
           VEC3_cross vec_move mcs_contact_normal vec_dir; # crossed product of move and contact normal vector
           set vec_axis [VEC3_dot vec_dir mom_tool_axis];# project to tool axis vector
         if {$vec_axis<0} {
              set mom_cutcom_mode "RIGHT"
           }
        }
        CUTCOM_SET
     } else {
        # handle no contact point scenario after filter
        global mom_motion_type
        if {$mom_motion_type == "CUT"} {
           global mom_sys_abort_next_event
           set mom_sys_abort_next_event 1

           CATCH_WARNING "No contact point generated!"

           MOM_abort_event
        } else {
           set mom_cutcom_status "OFF"
        }
     }
  }

  #Output contact points
   if {[info exists mom_contact_status] && $mom_contact_status == "ON"} {
      if {[info exists mom_contact_point]} {
         VMOV 3 mom_contact_point mom_pos
      }
   }
}


#=============================================================
proc PB_CMD_cancel_cycle { } {
#=============================================================
 # Unset parameters used in current cycle.
  global mom_cycle_delay_sec

  set cycle_param_list {RTP RFP SDIS DP DFR DTB FDEP FDPR DAM DTS FRF VARI O_AXN O_MDEP O_VRT O_DTD O_DIS1 \
                        SDR SDAC MPIT ENC PIT POSS SST SST1 O_PTAB O_TECHNO O_VAR1 O_DAM  FFR RFF SDIR RPA RPO RPAP}

  foreach param $cycle_param_list {
    set param [string tolower $param]
    set param mom_siemens_cycle_$param
    global $param
    if {[info exists $param]} {
       unset $param
    }
  }
  catch {unset mom_cycle_delay_sec}


 # Reset count of cycle move
  global mom_siemens_cycle_count
  set mom_siemens_cycle_count 0

  MOM_force Once X Y Z
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
proc PB_CMD_catch_sub_spindle { } {
#=============================================================
 # mom_part_transfer_flag is used to detect part transfer status
 # 1 means both of main an sub spindle catch the part

  global mom_part_transfer_flag
  set mom_part_transfer_flag 1

   MOM_output_literal "ERR1: IF \$AA_FXS\[Z3\] <> 2 GOTOF CONT1"
   MOM_output_literal "MSG(\"Travel to fixed stop not reached\")"
   MOM_output_literal "M0"
   MOM_output_literal "STOPRE"
   MOM_output_literal "GOTOB ERR1"
   MOM_output_literal "CONT1:"

}


#=============================================================
proc PB_CMD_check_flip_a_axis { } {
#=============================================================
# this proc is used to check whether flip tool is in effect or not
# no flip tool --> tool spindle c-axis = 0
# flip tool --> tool spindle c-axis = 180

  global mom_flip_a_axis
  global tool_holder_spindle_axis


  set tool_holder_spindle_axis 0

  if {![hiset mom_flip_a_axis]} {return}

  if { $mom_flip_a_axis } {

      set tool_holder_spindle_axis 180
  }


}


#=============================================================
proc PB_CMD_check_plane_change { } {
#=============================================================
  global mom_pos mom_prev_pos
  global cycle_init_flag
  global mom_cycle_spindle_axis
  global mom_current_motion
  global mom_siemens_coord_rotation

  if {[string match "first_move" $mom_current_motion]} {
return
  }

  if {[info exists mom_siemens_coord_rotation] && $mom_siemens_coord_rotation == 2} {
return
  }

  if {![info exists mom_cycle_spindle_axis]} {
     set mom_cycle_spindle_axis 2
  }

  if {[EQ_is_equal $mom_pos($mom_cycle_spindle_axis) $mom_prev_pos($mom_cycle_spindle_axis)]} {
      set cycle_init_flag FALSE
      MOM_abort_event
  } elseif {[EQ_is_lt $mom_pos($mom_cycle_spindle_axis) $mom_prev_pos($mom_cycle_spindle_axis)]} {
      set cycle_init_flag TRUE
      MOM_abort_event
  }


}


#=============================================================
proc PB_CMD_check_settings_for_cycle832 { } {
#=============================================================
# This command is used to check the settings for cycle832.
#
# 04-Jan-2017 shuai - CYCLE832 enhancement.
#

  global mom_siemens_compressor
  global mom_siemens_smoothing
  global mom_siemens_feedforward
  global mom_operation_name

  if {[info exists mom_siemens_compressor] && ![string compare "COMPOF" $mom_siemens_compressor]} {

     MOM_output_to_listing_device "Warning in $mom_operation_name: User defined compressor off is conflict with controller default setting in CYCLE832."
     MOM_output_to_listing_device "$mom_siemens_compressor will be output with CYCLE832."
     MOM_output_literal "$mom_siemens_compressor"
  }

  if {[info exists mom_siemens_smoothing] && ![string compare "G60" $mom_siemens_smoothing]} {

     MOM_output_to_listing_device "Warning in $mom_operation_name: User defined smoothing off is conflict with controller default setting in CYCLE832."
     MOM_output_to_listing_device "$mom_siemens_smoothing will be output with CYCLE832."
     MOM_output_literal "$mom_siemens_smoothing"
  }

  if {[info exists mom_siemens_feedforward] && ![string compare "FFWOF" $mom_siemens_feedforward]} {

     MOM_output_to_listing_device "Warning in $mom_operation_name: User defined feed forward off is conflict with controller default setting in CYCLE832."
     MOM_output_to_listing_device "$mom_siemens_feedforward will be output with CYCLE832."
     MOM_output_literal "$mom_siemens_feedforward"
  }

}


#=============================================================
proc PB_CMD_check_subroutine_name { } {
#=============================================================
# This proc is used to check if subroutine's name is valid.
# The first two characters must be letters.
# The others can be letters, numerals or underscore characters.
# Do not use more than 31 characters.
# No separators are to be used.

   global mom_machine_cycle_subroutine_name
   global mom_operation_name
   global mom_siemens_cycle95_output_mode
   global machine_cycle_subroutine_list
   global mom_sys_cycle95_subprogram_name
   global mom_sys_cycle95_subprogram_start
   global mom_sys_cycle95_subprogram_end


   if {[info exists mom_siemens_cycle95_output_mode] && [string match "LBL*" $mom_siemens_cycle95_output_mode]} {
      if {[string length $mom_sys_cycle95_subprogram_start]>31} {
         MOM_output_to_listing_device "Labels name in Operation $mom_operation_name should not more than 31 characters."
         set mom_sys_cycle95_subprogram_start [string range $mom_sys_cycle95_subprogram_start 0 30]
      }
      if {[string length $mom_sys_cycle95_subprogram_end]>31} {
         MOM_output_to_listing_device "Labels name in Operation $mom_operation_name should not more than 31 characters."
         set mom_sys_cycle95_subprogram_end [string range $mom_sys_cycle95_subprogram_end 0 26]_END
      }
      if {![regexp {^[A-Za-z][A-Za-z][A-Za-z0-9_]*$} $mom_sys_cycle95_subprogram_start]} {
         MOM_output_to_listing_device "Labels name in Operation $mom_operation_name should be letters, numerals or underscore characters.\
                                       \n The first two characters must be letters."
      }
      if {![regexp {^[A-Za-z][A-Za-z][A-Za-z0-9_]*$} $mom_sys_cycle95_subprogram_end]} {
         MOM_output_to_listing_device "Labels name in Operation $mom_operation_name should be letters, numerals or underscore characters.\
                                      \n The first two characters must be letters."
      }
   } else {
      if {[string length $mom_sys_cycle95_subprogram_name]>31} {
         MOM_output_to_listing_device "Subroutine name in Operation $mom_operation_name should not more than 31 characters."
         set mom_sys_cycle95_subprogram_name [string range $mom_sys_cycle95_subprogram_name 0 30]
      }
      if {![regexp {^[A-Za-z][A-Za-z][A-Za-z0-9_]*$} $mom_sys_cycle95_subprogram_name]} {
         MOM_output_to_listing_device "Subroutine name in Operation $mom_operation_name should be letters, numerals or underscore characters.\
                                      \n The first two characters must be letters."
      }
   }

   if {![info exists machine_cycle_subroutine_list]} {
      set machine_cycle_subroutine_list [list $mom_machine_cycle_subroutine_name]
   } else {
      foreach subroutine $machine_cycle_subroutine_list {
         if {[string compare $subroutine $mom_machine_cycle_subroutine_name]} {
            lappend machine_cycle_subroutine_list $mom_machine_cycle_subroutine_name
         } else {
            MOM_output_to_listing_device "Subroutine name $mom_machine_cycle_subroutine_name is duplicated in Operation $mom_operation_name"
         }
      }
   }
}


#=============================================================
proc PB_CMD_check_variables_for_turning_rough_cycle { } {
#=============================================================
# This command is used to check whether some variables exists or not.
#
# 06-Dec-2016 szl - Initial version.
#

  global mom_template_subtype

  if {![info exists mom_template_subtype] } {

     set mom_template_subtype "UNDEFINED"
  }

}


#=============================================================
proc PB_CMD_choose_output_mode { } {
#=============================================================
# This proc is used to output proper address for current mode.
#
# 10-Sep-2015 ljt - add mom_sys_lock_status

  global mom_kin_machine_type
  global mom_siemens_ori_def
  global mom_siemens_3Dcutcom_mode
  global mom_siemens_coord_rotation
  global mom_siemens_5axis_mode
  global mom_siemens_ori_coord
  global mom_prev_tool_axis
  global mom_tool_axis
  global mom_sys_lock_status

  # 5 axis orient definition
  if {![info exists mom_siemens_ori_def]} {
     set mom_siemens_ori_def "ROTARY AXES"
  }

  if {[string match "3_axis_mill" $mom_kin_machine_type]} {
     MOM_suppress Once A3 B3 C3
  } else {
     if { [string match "*ROTARY*" $mom_siemens_ori_def] } {
        MOM_suppress Once A3 B3 C3
        if { [info exists mom_tool_axis] && [info exists mom_prev_tool_axis] } {
           if { ( ![info exists mom_sys_lock_status] || [string match "OFF" mom_sys_lock_status] )\
                && [VEC3_is_equal mom_tool_axis mom_prev_tool_axis] } {
              MOM_suppress Once fourth_axis fifth_axis
           }
        }
     } else {
        if { [string match "ORIMKS" $mom_siemens_ori_coord] && $mom_siemens_coord_rotation == 1 } {
           global mom_tool_axis mom_csys_matrix csys_matrix tool_axis
           MTX3_transpose mom_csys_matrix csys_matrix
           MTX3_vec_multiply mom_tool_axis csys_matrix tool_axis
           VMOV 3 tool_axis mom_tool_axis
        }

      #  MOM_force Once A3 B3 C3
        MOM_suppress Once fourth_axis fifth_axis
     }
  }

  if { $mom_siemens_coord_rotation != 0 && [string match "SWIVELING" $mom_siemens_5axis_mode] } {
     MOM_suppress Once fourth_axis fifth_axis
     MOM_suppress Once A3 B3 C3
  }

  #Cutcom type
  if { [info exists mom_siemens_3Dcutcom_mode] } {
     if { [string match "3DF" $mom_siemens_3Dcutcom_mode] || [string match "3DFF" $mom_siemens_3Dcutcom_mode] } {
        global mom_contact_status
        if { [info exists mom_contact_status] && [string match "ON" $mom_contact_status] } {
           MOM_force Once A5 B5 C5
        } else {
       MOM_suppress Once A5 B5 C5
        }
     } else {
        MOM_suppress Once A5 B5 C5
     }
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
proc PB_CMD_config_cycle_start { } {
#=============================================================
# When a post (PUI) is configured to use this command as the
# "post_startblk" parameter, this command will be inserted and
# output as the anchor element for the cycles using "cycle start"
# to execute the cycles.
#
# You can add codes here for the needs of individual cycles or
# any other purposes.
#
# ==> This command may not be deleted or added to other event markers.
#
   PB_CMD_choose_output_mode

   global mom_siemens_cycle_count mom_cycle_spindle_axis
   global mom_siemens_coord_rotation
   if {![info exists mom_siemens_cycle_count]} {
      set mom_siemens_cycle_count 0
   }

   switch $mom_cycle_spindle_axis {
      0 { MOM_suppress Once X }
      1 { MOM_suppress Once Y }
      2 { MOM_suppress Once Z }
      default {}
   }

   if {$mom_siemens_cycle_count == 0} {
      switch $mom_cycle_spindle_axis {
         0 { MOM_force Once Y Z }
         1 { MOM_force Once X Z }
         2 { MOM_force Once X Y }
         default {}
      }
   }

   incr mom_siemens_cycle_count
   if { $mom_siemens_coord_rotation == 1 } {
     MOM_suppress Once fourth_axis fifth_axis A3 B3 C3
   }
}


#=============================================================
proc PB_CMD_contour_end { } {
#=============================================================
   global mom_machine_cycle_subroutine_name
   global mom_operation_name
   global mom_sys_output_contour_motion
   global mom_siemens_cycle95_output_mode

   global mom_sys_cycle95_start
   set mom_sys_cycle95_start 0

   if { [info exists mom_siemens_cycle95_output_mode] && [string match "SUB" $mom_siemens_cycle95_output_mode] } {

      global ptp_file_name
      global mom_output_file_directory
      global cycle95_subroutine_file

      if { [info exists cycle95_subroutine_file] } {

         MOM_output_literal "M17"
         MOM_close_output_file $cycle95_subroutine_file

        # Restore sequence number
         global mom_sequence_number mom_sequence_increment mom_sequence_frequency
         global mom_sequence_number_saved mom_sequence_increment_saved mom_sequence_frequency_saved

         set mom_sequence_number $mom_sequence_number_saved
         set mom_sequence_increment $mom_sequence_increment_saved
         set mom_sequence_frequency $mom_sequence_frequency_saved
         MOM_reset_sequence $mom_sequence_number $mom_sequence_increment $mom_sequence_frequency
      }

      MOM_open_output_file $ptp_file_name

   } elseif { [info exists mom_siemens_cycle95_output_mode] && [string match "LBL" $mom_siemens_cycle95_output_mode] } {

      global mom_sys_cycle95_subprogram_end

     # Output end label for in-line subprogram
      MOM_output_text "${mom_sys_cycle95_subprogram_end}:"

   } else {

      global cycle95_contour_file
      global mom_sys_cycle95_subprogram_end

      lappend cycle95_contour_file "${mom_sys_cycle95_subprogram_end}:"
   }


  #+++++++++++++++++++++++++++++++++++++++++
  # Tell NX/Post to end contour output mode
  #+++++++++++++++++++++++++++++++++++++++++
   set mom_sys_output_contour_motion 0



  #--------------------------
  # Output CYCLE95 statement
  #--------------------------
  # <10-30-2015 szl> Remove cycle95 output here.
    #MOM_lathe_roughing


  #++++++++++++++++++++++++++++++++++++++++++++++++
  # Output return move (X -> Z) after cycle95 call
  # ==> Detail moves may need to be adjusted
  #     according to the nature of the cut.
  #++++++++++++++++++++++++++++++++++++++++++++++++
  # <10-30-2015 szl> Due to MOM_generic_cycle are added for cycle95, now use MOM_skip_handler_to_event instead of
  #                  MOM_abort_operation to handle NC output, so we don't need output return move any more.
  # global mom_pos mom_pos_saved_for_cycle95
  #
  #    VMOV 3 mom_pos_saved_for_cycle95 mom_pos
  #    MOM_reload_variable -a mom_pos
  #
  #    MOM_force once G_motion G_mode X
  #    MOM_suppress once Z
  #    MOM_rapid_move
  #
  #    MOM_force once Z
  #    MOM_rapid_move

  #--------------------------
  # handle machine time
  #--------------------------
   global mom_sys_machine_time mom_machine_time mom_toolpath_time
   if { [info exists mom_sys_machine_time] } {
      set mom_machine_time [expr $mom_sys_machine_time + $mom_toolpath_time]
      MOM_reload_variable mom_machine_time
   }
}


#=============================================================
proc PB_CMD_contour_start { } {
#=============================================================
   global mom_machine_cycle_subroutine_name
   global mom_operation_name
   global mom_siemens_cycle95_output_mode

   global mom_sys_cycle95_subprogram_name
   global mom_sys_cycle95_subprogram_start
   global mom_sys_cycle95_subprogram_end

   global mom_sys_cycle95_start
   set mom_sys_cycle95_start 1

   if { [info exists mom_siemens_cycle95_output_mode] && [string match "SUB" $mom_siemens_cycle95_output_mode] } {

      global ptp_file_name
      global mom_output_file_directory
      global cycle95_subroutine_file

      MOM_close_output_file $ptp_file_name

      set cycle95_subroutine_file "${mom_output_file_directory}${mom_sys_cycle95_subprogram_name}.SPF"

      if { [file exists $cycle95_subroutine_file] } {
         MOM_remove_file $cycle95_subroutine_file
      }

      MOM_open_output_file $cycle95_subroutine_file

      global mom_sequence_number mom_sequence_increment mom_sequence_frequency mom_seqnum
      global mom_sequence_number_saved mom_sequence_increment_saved mom_sequence_frequency_saved

     # Save sequence number
      set mom_sequence_number_saved $mom_seqnum
      set mom_sequence_increment_saved $mom_sequence_increment
      set mom_sequence_frequency_saved $mom_sequence_frequency

     # Set sequence number for subprogram
      set mom_sequence_number     100
      set mom_sequence_increment  10
      set mom_sequence_frequency  1

      MOM_reset_sequence $mom_sequence_number $mom_sequence_increment $mom_sequence_frequency

   } elseif { [info exists mom_siemens_cycle95_output_mode] && [string match "LBL" $mom_siemens_cycle95_output_mode] } {

     # Output instruction for main program to skip over the in-line subprogram
     # - All in-line labels are in upper case.
      MOM_output_literal "GOTOF $mom_sys_cycle95_subprogram_end"

     # Output start lebel for in-line subprogram
      MOM_output_text "${mom_sys_cycle95_subprogram_start}:"

   } else {
      global cycle95_contour_file

      if { ![info exists cycle95_contour_file] } {
         set cycle95_contour_file [list]
      }

      lappend cycle95_contour_file "${mom_sys_cycle95_subprogram_start}:"
   }

   MOM_force Once G_motion X Z

}


#=============================================================
proc PB_CMD_control_soft_limit { } {
#=============================================================
# This command is used to handle X axis positioning area with upper and lower
# turrets. For upper turret, X axis always located in upper quadrant, for lower
# turret, X axis always located in lower quadrant.
  global mom_pos mom_out_angle_pos
  global mom_channel_id
  global mom_coordinate_output_mode
  global mom_pos_arc_plane
  global mom_siemens_coord_rotation
  global mom_cycle_spindle_axis
  global mom_coordinate_output_mode
  global mom_siemens_5axis_output_mode
  global mom_current_motion
  global mom_operation_type
  global mom_sys_lathe_x_factor

  if {[info exists mom_coordinate_output_mode] && $mom_coordinate_output_mode == "TRANSMIT"} {
return
  } elseif {$mom_siemens_5axis_output_mode != 0 || $mom_siemens_coord_rotation != 0} {
return
  }

 if {!([string match $mom_current_motion "circular_move"] && $mom_pos_arc_plane == "XY")} {
  if {$mom_sys_lathe_x_factor == 1} {
    if {[EQ_is_lt $mom_pos(0) 0.0] } {
       set mom_pos(0) [expr -1*$mom_pos(0)]
       set mom_pos(1) [expr -1*$mom_pos(1)]
      if {[string match "Point to Point" $mom_operation_type] || [string match "Hole Making" $mom_operation_type] || \
          [string match "Drilling" $mom_operation_type]} {
         if {[EQ_is_gt $mom_pos(4) 180]} {
            set mom_out_angle_pos(1) [expr $mom_pos(4)-180]
         } else {
            set mom_out_angle_pos(1) [expr $mom_pos(4)+180]
         }
      } else {
          if {[EQ_is_gt $mom_out_angle_pos(1) 180]} {
             set mom_out_angle_pos(1) [expr $mom_out_angle_pos(1)-180]
          } else {
             set mom_out_angle_pos(1) [expr $mom_out_angle_pos(1)+180]
          }
      }
      MOM_reload_variable -a mom_pos
      MOM_reload_variable -a mom_out_angle_pos
    }
  } else {
    if {[EQ_is_gt $mom_pos(0) 0.0] } {
      set mom_pos(0) [expr -1*$mom_pos(0)]
      set mom_pos(1) [expr -1*$mom_pos(1)]
      if {[string match "Point to Point" $mom_operation_type] || [string match "Hole Making" $mom_operation_type] || \
          [string match "Drilling" $mom_operation_type]} {
         PB_CMD_set_principal_axis
         if {[EQ_is_gt $mom_pos(4) 180]} {
            set mom_out_angle_pos(1) [expr $mom_pos(4)-180]
         } else {
            set mom_out_angle_pos(1) [expr $mom_pos(4)+180]
         }
         global mom_motion_type
         if {$mom_cycle_spindle_axis == 0 && ![string match $mom_current_motion "initial_move"] \
             && ![string match $mom_current_motion "first_move"] && [string match $mom_motion_type "CYCLE"] } {
             set mom_pos(0) [expr -1*$mom_pos(0)]
         }
       } else {
          if {[EQ_is_gt $mom_out_angle_pos(1) 180]} {
             set mom_out_angle_pos(1) [expr $mom_out_angle_pos(1)-180]
          } else {
             set mom_out_angle_pos(1) [expr $mom_out_angle_pos(1)+180]
          }
       }


      MOM_reload_variable -a mom_pos
      MOM_reload_variable -a mom_out_angle_pos
    }
  }
 }

}


#=============================================================
proc PB_CMD_creat_tool_list { } {
#=============================================================
#  Place this custom command in either the start of program
#  or the end of program event marker to generate a tool list
#  in your NC file.
#
#  The Shop Doc template file "pb_post_tool_list.tpl" distributed with
#  Post Builder in "POSTBUILD/pblib/misc" directory can be copied
#  to the "mach/resource/postprocessor" or "mach/resource/shop_docs" directory,
#  in case that your UG runtime environment does not have access to the
#  Post Builder installation.
#
#  Accessing "pb_post_tool_list.tpl" in other location can also be accomplished
#  by changing the code below titled "Generate tool list data" in this proc.
#
#  The variable "mom_sys_tool_list_output_type" set in this proc allows you
#  to select the type of tool list to be generated.
#  The options are:
#
#   "ORDER_IN_USE"     - List tools used in the program in the order of operations.
#   "ALL_UNIQUE"       - List all unique tools once for each in the order of use.
#   "GROUP_BY_TYPE"    - List tools in groups of different tool types.
#
# The desired tool list type can be set by changing the code below.
# The default is set to "GROUP_BY_TYPE".
#

   set wfl_global [info globals "mom_*"]
   foreach gv $wfl_global {
      global Twfl_$gv $gv
      if {[info exists $gv]} {
        if {![array exists $gv]} {
           set wfl Twfl_$gv
           set $wfl [set $gv]
        }
     }
   }

   global mom_sys_tool_list_initialized
   global mom_sys_tool_list_output_type


   if { ![info exists mom_sys_tool_list_initialized] || !$mom_sys_tool_list_initialized } {
      MOM_output_to_listing_device "proc PB_CMD_init_tool_list must be executed in the Start of Program before PB_CMD_create_tool_list is called."
return
   }


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Set mom_sys_tool_list_output_type to the desired output fashion.
  #
  #   "ORDER_IN_USE"     - List tools used in the program in the order of operations.
  #   "ALL_UNIQUE"       - List all unique tools once for each in the order of use.
  #   "GROUP_BY_TYPE"    - List tools in groups of different tool types.
  #
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # set mom_sys_tool_list_output_type "ORDER_IN_USE"
  # set mom_sys_tool_list_output_type "ALL_UNIQUE"
   set mom_sys_tool_list_output_type "GROUP_BY_TYPE"


   global mom_sys_control_out mom_sys_control_in
   global current_program_name
   global mom_tool_number mom_tool_length_adjust_register mom_tool_name


  #----------------------------------------------------------------------------
  # Save info for the currently active tool in the program being post-prcessed
  # before starting Shop Doc mechanism for tool list generation.
  #----------------------------------------------------------------------------
   if [llength [info commands PB_CMD_save_active_oper_tool_data] ] {
      PB_CMD_save_active_oper_tool_data
   }


  #-----------------------------------------------------------
  # Create tool list per selected top-level group.
  # Group name is set to blank if no group has been selected.
  #-----------------------------------------------------------
   global mom_parent_group_name

   if [info exists mom_parent_group_name] {
      set current_program_name $mom_parent_group_name
   } else {
      set current_program_name ""
   }


   set ci " "
   set co " "

   if [info exists mom_sys_control_in] { set ci $mom_sys_control_in }
   if [info exists mom_sys_control_out] { set co $mom_sys_control_out }


  #*************************
  # Generate tool list data
  #*************************
   set template_file pb_post_tool_list.tpl

   global tcl_platform
   if [string match "windows" $tcl_platform(platform)] {
      set pb_lib_misc_dir [MOM_ask_env_var UGII_BASE_DIR]\\postbuild\\pblib\\misc\\
   } else {
      set pb_lib_misc_dir [MOM_ask_env_var UGII_BASE_DIR]/postbuild/pblib/misc/
   }

   set cam_post_dir     [MOM_ask_env_var UGII_CAM_POST_DIR]
   set cam_shop_doc_dir [MOM_ask_env_var UGII_CAM_SHOP_DOC_DIR]

   if { [file exists ${pb_lib_misc_dir}${template_file}] } {

      MOM_do_template_file ${pb_lib_misc_dir}${template_file}

   } elseif { [file exists ${cam_post_dir}${template_file}] } {

      MOM_do_template_file ${cam_post_dir}${template_file}

   } elseif { [file exists ${cam_shop_doc_dir}${template_file}] } {

      MOM_do_template_file ${cam_shop_doc_dir}${template_file}

   } else {

      MOM_output_to_listing_device  "ERROR : Template file pb_post_tool_list.tpl is not found in the following directories: \n \n          $pb_lib_misc_dir \n          $cam_post_dir \n          $cam_shop_doc_dir \n \n        Tool list cannot be generated.\n"
return
   }



  #------------------
  # Tool list header
  #------------------
#   shop_doc_output_literal "$co===============================================================================================$ci"
#   shop_doc_output_literal "$co                                   T O O L   L I S T                                           $ci"
#   shop_doc_output_literal "$co===============================================================================================$ci"


  #------------------
  # Output tool list
  #------------------
   global tool_data_buffer
   global mom_sys_tool_stack

   switch $mom_sys_tool_list_output_type {

      "ORDER_IN_USE" {
         set tool_list $mom_sys_tool_stack(IN_USE)
      }

      "GROUP_BY_TYPE" {
         set tool_list [concat $mom_sys_tool_stack(LATHE)  $mom_sys_tool_stack(DRILL)  $mom_sys_tool_stack(MILL)]
      }

      default {
         set tool_list $mom_sys_tool_stack(ALL)
      }
   }


   set prev_tool_type ""

   foreach tool $tool_list {

      set tool_type $tool_data_buffer($tool,type)

     # Output tool type header if it changes.
      if { ![string match "$tool_type" $prev_tool_type] } {
         if { [info exists tool_data_buffer($tool_type,header)] &&  $tool_data_buffer($tool_type,header) != "" } {
            shop_doc_output_literal ";$tool_data_buffer($tool_type,header)"
         }
      }

      if [info exists tool_data_buffer($tool,output)] {
         shop_doc_output_literal ";$tool_data_buffer($tool,output)"
      }
      set prev_tool_type $tool_type
   }



  #------------------
  # Tool list footer
  #------------------
   shop_doc_output_literal ";$co                                                                                               $ci"


  #-------------------------------------------------------------------------------
  # Restore info for the currently active tool in the program being post-prcessed.
  #-------------------------------------------------------------------------------
   if [llength [info commands PB_CMD_restore_active_oper_tool_data] ] {
      PB_CMD_restore_active_oper_tool_data
   }

  set wfl_global [info globals "Twfl_*"]
  foreach gv $wfl_global {
     set mv [string trimleft $gv "Twfl_"]
     global $gv $mv
     if {[info exists $gv]} {
       set $mv [set $gv]
       unset $gv
    }
  }
}


#=============================================================
proc PB_CMD_cycle_tap { } {
#=============================================================
#this procedure is used to set tap cycle parameters for sinumerik 840D
#
#-------------------------------------------------------
#inputs for tapping
#-------------------------------------------------------
  global mom_spindle_speed
  global mom_spindle_direction
  global mom_motion_event
  global feed

  global mom_siemens_cycle_sdr
  global mom_siemens_cycle_enc
  global mom_siemens_cycle_sdac
  global mom_siemens_cycle_mpit
  global mom_siemens_cycle_pit
  global mom_siemens_cycle_poss
  global mom_siemens_cycle_sst
  global mom_siemens_cycle_sst1
  global mom_siemens_cycle_sdac
  global mom_siemens_cycle_sdr
  global mom_siemens_cycle_enc
  global mom_siemens_cycle_o_ptab
  global mom_siemens_cycle_o_var1
  global mom_cycle_option

  if { ![string match "tap_move" $mom_motion_event] } { return }

  if { ![info exists mom_siemens_cycle_sdac] } {
     set mom_siemens_cycle_sdac 3
  } else {
     switch $mom_siemens_cycle_sdac {
        CLW   { set mom_siemens_cycle_sdac 3 }
        CCLW  { set mom_siemens_cycle_sdac 4 }
        Off   { set mom_siemens_cycle_sdac 5 }
        default {}
     }
  }

  global mom_siemens_cycle_mpit_defined
  if { [info exists mom_siemens_cycle_mpit] } {
     if { [string match "CCLW" $mom_spindle_direction] } {
        set mom_siemens_cycle_mpit [expr -1*$mom_siemens_cycle_mpit]
     }
      catch {unset mom_siemens_cycle_pit} ;# if users set mpit, pit will be ignored
      catch {unset mom_siemens_cycle_o_ptab}
  } else {
     if { [info exists mom_siemens_cycle_o_ptab] } {
        switch $mom_siemens_cycle_o_ptab {
          "Post Defined"        { set mom_siemens_cycle_o_ptab 0 }
          "Millimeter"          { set mom_siemens_cycle_o_ptab 1 }
          "Groove per Inch"     { set mom_siemens_cycle_o_ptab 2 }
          "Inch per Revolution" { set mom_siemens_cycle_o_ptab 3 }
          default               {}
        }
     } else {
        set mom_siemens_cycle_o_ptab 0
     }
     if { [info exists mom_siemens_cycle_pit] } {
        if { $mom_siemens_cycle_pit == 0 || $mom_siemens_cycle_o_ptab == 0 } {
           if { [info exists mom_spindle_speed] && $mom_spindle_speed != 0 } {
              set mom_siemens_cycle_pit [expr $feed/$mom_spindle_speed]
           }
        }
        if { [string match "CCLW" $mom_spindle_direction] } {
           set mom_siemens_cycle_pit [expr -1*$mom_siemens_cycle_pit]
        }
     } else {
        if { [info exists mom_spindle_speed] && $mom_spindle_speed != 0 } {
            set mom_siemens_cycle_pit [expr $feed/$mom_spindle_speed]
        }
        if { [string match "CCLW" $mom_spindle_direction] } {
            set mom_siemens_cycle_pit [expr -1*$mom_siemens_cycle_pit]
        }
     }
  }

  if [info exists mom_spindle_speed] {
     set mom_siemens_cycle_sst $mom_spindle_speed
  }
  if { ![info exists mom_siemens_cycle_sst1] } {
     set mom_siemens_cycle_sst1 0
  }

  if { [info exists mom_siemens_cycle_o_var1] } {
     switch $mom_siemens_cycle_o_var1 {
        "Single Pass" { set mom_siemens_cycle_o_var1 0}
        "Break Chip"  { set mom_siemens_cycle_o_var1 1}
        "Remove Chip" { set mom_siemens_cycle_o_var1 2}
        default       {}
     }
  }

  if { [info exists mom_siemens_cycle_enc] } {
     switch $mom_siemens_cycle_enc {
        "Use Encoder-Dwell Off" {set mom_siemens_cycle_enc 0}
        "Use Encoder-Dwell On" {set mom_siemens_cycle_enc 20}
        "No Encoder-Feed Rate before Cycle" {set mom_siemens_cycle_enc 1}
        "No Encoder-Feed Rate in Cycle" {set mom_siemens_cycle_enc 11}
        default  {unset mom_siemens_cycle_enc}
     }
  }

  if { [info exists mom_siemens_cycle_sdr] } {
     switch $mom_siemens_cycle_sdr {
        "Reversal" { set mom_siemens_cycle_sdr 0}
        "CLW"      { set mom_siemens_cycle_sdr 3}
        "CCLW"     { set mom_siemens_cycle_sdr 4}
        default    {}
     }
  }
}


#=============================================================
proc PB_CMD_define_feed_block { } {
#=============================================================
     global mom_siemens_feed_output_block
     global mom_seqnum
     set mom_siemens_feed_output_block [expr int($mom_seqnum)]
     MOM_output_literal ";"
}


#=============================================================
proc PB_CMD_define_feed_variable_value { } {
#=============================================================
#This command is used to get feed value and define feed rate in variables.
#and PB_CMD_define_feedrate_format which is called from PB_CMD_before_motion.
  global mom_siemens_feed_value
  global mom_siemens_feed_definition
  global mom_seqnum
  global mom_siemens_feed_block
  global mom_siemens_feed_output_block
  global mom_siemens_feed_output_seqnum
  global feed_definition

  if { [info exists mom_siemens_feed_definition] && $mom_siemens_feed_definition == "ON" } {
     PB_CMD_get_feed_value
     MOM_output_literal ";"
     MOM_output_literal "_F_CUTTING=$mom_siemens_feed_value(cut) _F_ENGAGE=$mom_siemens_feed_value(engage) _F_RETRACT=$mom_siemens_feed_value(retract)"
     MOM_output_literal ";"
  }
}


#=============================================================
proc PB_CMD_define_feedrate_format { } {
#=============================================================
# This command is used to redefine feedrate output format as string and record feedrate
# value.
# Using mom_sinumerik_feed instead of feed for output in NX7.0. feed cannot be set to a
# string value.
  global mom_siemens_feed_definition
  global mom_siemens_feed_var_num
  global mom_siemens_feed_value
  global feed
  global mom_motion_type
  global feed_definition
  global mom_sinumerik_feed

  # Feedrate definition in variable
  if {[info exists mom_siemens_feed_definition] && $mom_siemens_feed_definition == "ON"} {
     MOM_set_address_format F String
     set motion_type [string tolower $mom_motion_type]
        switch $motion_type {
           "cut" -
           "firstcut" -
           "stepover" { set mom_sinumerik_feed "=_F_CUTTING"}
           "engage" { set mom_sinumerik_feed "=_F_ENGAGE"}
           "retract" { set mom_sinumerik_feed "=_F_RETRACT"}
           default {
              # set mom_sinumerik_feed 0
              MOM_set_address_format F Feed
           }
        }
   }
}


#=============================================================
proc PB_CMD_detect_5axis_mode { } {
#=============================================================
#This command is used to detect 5axis mode at initial move and first move.
  global mom_kin_machine_type
  global mom_siemens_5axis_mode
  global mom_siemens_5axis_output_mode
  global mom_siemens_coord_rotation
  global mom_tool_axis_type
  global mom_operation_type
  global mom_siemens_5axis_output

# For protection, reset TRAORI for 3 axis machine.
  if { $mom_kin_machine_type == "3_axis_mill" } {
     set mom_siemens_5axis_mode "TRAFOOF"
     set mom_siemens_5axis_output_mode 0
     set mom_siemens_coord_rotation 0
  }


  if { ![info exists mom_siemens_5axis_mode] } {
     set mom_siemens_5axis_mode "TRAFOOF"
  }


# Disable G18/G19 output in TRAORI/CYCLE800 mode
  MOM_do_template g17
  MOM_disable_address G_plane
  switch $mom_siemens_5axis_mode {
     TRAORI    { set mom_siemens_5axis_output "TRAORI"   ; set mom_siemens_5axis_output_mode 1}
     TRAORI2   { set mom_siemens_5axis_output "TRAORI(2)"; set mom_siemens_5axis_output_mode 1}
     SWIVELING { set mom_siemens_5axis_output "TRAFOOF"  ; set mom_siemens_5axis_output_mode 0}
     default {
        set mom_siemens_5axis_output "TRAFOOF"
        set mom_siemens_5axis_output_mode 0
        MOM_enable_address G_plane
     }
  }
}


#=============================================================
proc PB_CMD_detect_5axis_tool_path { } {
#=============================================================
# This proc is used to detect if the operation is 5 axis simultaneous milling operation.
#
# This command is referenced by DPP_GE_DETECT_5AXIS_TOOL_PATH.
#
# In this command, tool path type is detected by mom_operation_type, mom_tool_path_type and mom_tool_axis_type.
#
# The result may not always match 5-axis simultaneous milling.
# It is more tolerance.
#
# Return:
#   1 - tool path is 5 axis simultaneous
#   0 - tool path is not 5 axis simultaneous
#
# 16-Jan-2017 shuai - Initial version.
#

  global mom_tool_axis_type
  global mom_tool_path_type
  global mom_operation_type

  if {![info exists mom_tool_axis_type] } {
     set mom_tool_axis_type 0
  }

  if {![info exists mom_tool_path_type] } {
     set mom_tool_path_type "undefined"
  }

  if {[PB_CMD_detect_hole_cutting_operation]} {

     return 0

  } elseif {($mom_tool_axis_type >= 2 && [string match "Variable-axis *" $mom_operation_type]) || \
            ![string compare "Sequential Mill Main Operation" $mom_operation_type] || \
            (![string compare "variable_axis" $mom_tool_path_type] && ![string match "Variable-axis *" $mom_operation_type] && [string compare "Generic Motion" $mom_operation_type])} {

     return 1

  } else {

     return 0
  }

}


#=============================================================
proc PB_CMD_detect_hole_cutting_operation { } {
#=============================================================
# This proc is used to detect if the operation is a hole cutting operation.
#
# This command is referenced by DPP_GE_DETECT_HOLE_CUTTING_OPERATION.
#
# Hole cutting operation includs:
#   Point to Point,
#   Hole Making,
#   Drilling
#   Cylinder Milling,
#   Thread Milling,
#   Chamfer Milling,
#   Radial Groove Milling.
#
# Return:
#   1 - operation is hole cutting operation
#   0 - operation is not hole cutting operation
#
# 16-Jan-2017 shuai - Initial version.
#

  global mom_operation_type

  if {![string compare "Point to Point" $mom_operation_type] || \
      ![string compare "Hole Making" $mom_operation_type] || \
      ![string compare "Drilling" $mom_operation_type] || \
      ![string compare "Cylinder Milling" $mom_operation_type] || \
      ![string compare "Thread Milling" $mom_operation_type] || \
      ![string compare "Chamfer Milling" $mom_operation_type] || \
      ![string compare "Radial Groove Milling" $mom_operation_type] } {

     return 1

  } else {

     return 0
  }

}


#=============================================================
proc PB_CMD_detect_operation_mode { } {
#=============================================================
  global mom_tool_axis_type
  global mom_operation_type
  global mom_current_motion
  global mom_siemens_5axis_mode
  global mom_siemens_5axis_output_mode
  global mom_tool_axis
  global mom_siemens_milling_setting
  global mom_operation_name
  global mom_tool_path_type

  if {![info exists mom_tool_axis_type]} {set mom_tool_axis_type 0}

  if {[string compare "first_move" $mom_current_motion] && \
      [string compare "initial_move" $mom_current_motion]} {
return
  }

  if {![info exists mom_tool_path_type]} {
     set mom_tool_path_type "undefined"
  }

  # Check if operation is a 5 axis operation.
  #<szl 2016-06-20> Enhancement for new drilling cycle operation type
  if { ($mom_tool_axis_type >=2 && [string match "Variable-axis *" $mom_operation_type]) || \
       [string match "Sequential Mill Main Operation" $mom_operation_type] || \
       ([string match "variable_axis" $mom_tool_path_type] && ![string match "Variable-axis *" $mom_operation_type] && \
        [string compare "Hole Making" $mom_operation_type] && [string compare "Point to Point" $mom_operation_type] && \
        [string compare "Cylinder Milling" $mom_operation_type] && [string compare "Thread Milling" $mom_operation_type] && \
        [string compare "Drilling" $mom_operation_type] && [string compare "Chamfer Milling" $mom_operation_type] && \
        [string compare "Radial Groove Milling" $mom_operation_type])} {

     # If a operation type is variable-axis operation but users set it
     # work with TRAFOOF, a warning message will pop up.
     if {[info exists mom_siemens_milling_setting] && [string compare "Default" $mom_siemens_milling_setting]} {
        if {[info exists mom_siemens_5axis_mode] && [string compare "TRAORI" $mom_siemens_5axis_mode] && [string compare $mom_siemens_5axis_mode "TRAORI2"]} {
           MOM_output_to_listing_device "Warning in $mom_operation_name: Variable-axis operation should work with TRAORI, please check the UDE setting."
        }
     } else {
        if {[info exists mom_siemens_5axis_mode] && [string match $mom_siemens_5axis_mode "TRAORI2"]} {
           set mom_siemens_5axis_mode "TRAORI2"
        } else {
           set mom_siemens_5axis_mode "TRAORI"
        }
        set mom_siemens_5axis_output_mode 1
     }
  }

# Automatcially detect axial drilling opertion, set them to XZC mode.
  global mom_coordinate_output_mode
  global mom_lock_axis_value mom_lock_axis_plane
  global mom_lock_axis mom_lock_axis_value_defined
  if {[string match "Point to Point" $mom_operation_type] || [string match "Hole Making" $mom_operation_type] || \
      [string match "Drilling" $mom_operation_type]} {
     if {[EQ_is_equal [expr abs($mom_tool_axis(2))] 1.0] } {
        PB_CMD_set_XZC_mode
     }
  }

}


#=============================================================
proc PB_CMD_drill_text_move { } {
#=============================================================
  global mom_cycle_delay
  global mom_cycle_delay_revs

  if { [info exists mom_cycle_delay] || [info exists mom_cycle_delay_revs] } {
     MOM_drill_dwell_move
  } else {
     MOM_drill_move
  }
}


#=============================================================
proc PB_CMD_end_of_alignment_character { } {
#=============================================================
 #  Return sequnece number back to orignal
 #  This command may be used with the command "PM_CMD_start_of_alignment_character"

  global mom_sys_leader saved_seq_num
  if { [info exists saved_seq_num] } {
    set mom_sys_leader(N) $saved_seq_num
  }
}


#=============================================================
proc PB_CMD_end_of_extcall_operation { } {
#=============================================================
# This command is used to close sub program for each operation.
# This command must be put in end of path
  global mom_siemens_program_control
  global ptp_file_name
  global mom_sys_ptp_output
  global mom_output_file_directory
  global mom_operation_name
  global mom_machine_mode

  if {[string compare $mom_machine_mode "MILL"]} {
return
  }

  if { ![string match "ON" $mom_sys_ptp_output] || ![info exists ptp_file_name] } {
return
  }

  if { [info exists mom_siemens_program_control] && [string match "TRUE" $mom_siemens_program_control] } {
     set output_extn ".spf"
     set subroutine_name "${mom_output_file_directory}${mom_operation_name}${output_extn}"
     if { [file exists $subroutine_name] } {
        MOM_output_literal "M17"
        global feedrate_file_name
        set feedrate_file_name $subroutine_name
        if {[llength [info commands PB_CMD_output_feedrate_variables]]} {
        PB_CMD_output_feedrate_variables
        }
        MOM_close_output_file $subroutine_name
     }
  }
}


#=============================================================
proc PB_CMD_end_of_extcall_program { } {
#=============================================================
#This command must be put in end of program after all output templates.
#This command is used to output M30 to extcall main program.
  global mom_siemens_program_control
  global ptp_file_name
  global mom_sys_ptp_output
  global mom_sequence_number mom_sequence_increment mom_sequence_frequency
  global mom_sys_in_operation

  if { [info exists mom_sys_in_operation] && $mom_sys_in_operation == 1 } {
return
  }

  if { ![string match "ON" $mom_sys_ptp_output] && ![info exists ptp_file_name] } {
return
  }

  if { [info exists mom_siemens_program_control] && [string match "TRUE" $mom_siemens_program_control] } {
     MOM_open_output_file $ptp_file_name
     MOM_output_text "M30"
     unset mom_siemens_program_control
  }
}


#=============================================================
proc PB_CMD_end_of_path { } {
#=============================================================
 global sinumerik_version
 global mom_operation_type
 global mom_next_oper_has_tool_change
 global mom_current_oper_is_last_oper_in_program
 global mom_operation_type

 PB_CMD_reset_all_motion_variables_to_zero

 if { [info exists sinumerik_version] && [string match "V5" $sinumerik_version] } {
    MOM_output_literal ";"
    MOM_output_literal "FFWOF"
    MOM_output_literal "UPATH"
    MOM_output_literal "SOFT"
    MOM_output_literal "COMPOF"
    MOM_output_literal "G64"
 } else {
    if { ![string match "Point to Point" $mom_operation_type] && ![string match "Hole Making" $mom_operation_type] && \
         ![string match "Drilling" $mom_operation_type]} {
       MOM_output_literal "CYCLE832()"
    }
 }
}


#=============================================================
proc PB_CMD_end_of_program { } {
#=============================================================
# Reset start_output_flag, it is set in PB_CMD_output_start_program
  global start_output_flag
  set start_output_flag 0


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
proc PB_CMD_fix_thread_cycle { } {
#=============================================================
  global thread_cycle_flag

  if {[info exists thread_cycle_flag] && $thread_cycle_flag == -1} {
     MOM_force Once G_motion X Y Z
     MOM_linear_move
     MOM_abort_event
  }
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
  global mom_siemens_feed_var_num
  global mom_siemens_feed_value
  global mom_siemens_feed_definition
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

  set mom_siemens_feed_value(cut) [expr $unit_conversion*$mom_feed_cut_value]
  set mom_siemens_feed_value(engage) [expr $unit_conversion*$mom_feed_engage_value]
  set mom_siemens_feed_value(retract) [expr $unit_conversion*$mom_feed_retract_value]

  set mom_siemens_feed_value(cut) [format "%.2f" $mom_siemens_feed_value(cut)]
  set mom_siemens_feed_value(engage) [format "%.2f" $mom_siemens_feed_value(engage)]
  set mom_siemens_feed_value(retract) [format "%.2f" $mom_siemens_feed_value(retract)]
}


#=============================================================
proc PB_CMD_handle_generic_cycle_start_motion { } {
#=============================================================
# This command should be only attached on initial move and first move.
# This command is used to handle initial_move or first_move event generated after
# generic_cycle for lathe rough cycle output.
# 2015-10-28 szl - Initial version

   global mom_sys_cycle95_start_motion
   global mom_sys_output_cycle95
   global mom_machine_control_motion_output

   if {[info exists mom_sys_cycle95_start_motion] && ![string compare $mom_sys_cycle95_start_motion "After Cycle"] } {
      #skip to next generic_cycle which should be cycle end
      MOM_skip_handler_to_event generic_cycle

      # Don't output first point, it is included in cycle95
      # Don't output first point, it is included in cycle95
      MOM_suppress once X Z
      unset mom_sys_cycle95_start_motion

   } elseif { ([info exists mom_machine_control_motion_output] && $mom_machine_control_motion_output == 2) && \
              ([info exists mom_sys_output_cycle95] && $mom_sys_output_cycle95) } {

      set mom_sys_cycle95_start_motion "Before Cycle"
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
  global mom_sync_number


  set mom_sync_start     0
  set mom_sync_incr       1
  set mom_sync_max    100


  if {![info exists mom_sync_code] } {
    set mom_sync_code $mom_sync_start
  }
  set mom_sync_code [expr $mom_sync_code + $mom_sync_incr]

  MOM_output_literal "WAITM($mom_sync_number,1,2)"
}


#=============================================================
proc PB_CMD_init_cycle95_output { } {
#=============================================================
# ==> This command should be called in the event whose position can be output
#     as the "ready position" (outside of stock) for the CYCLE95 call.
#
#-----------------------------------------------------------------------------
# This command gathers information to determine if NX/Post should
# process contour data and produce subprogram & cycle95 instructions.
#
# The state of variable "mom_machine_control_motion_output" will indicate
# when turning processor will produce contour data whereas the variable
# "mom_sys_output_cycle95" indicates that post is equipped with the ability
# to output CYCLE95. This ability can be activated in the event below:
#
#   "Program & Tool Path"
#      -> "Program"
#          -> "Canned Cycles" -> "Turn Roughing"
#
#*****************************************************************************
# This command will only function when
#  - Turning processor has produced contour data
#  - The post is equipped with the ability to output cycle95
#
# What can be done here?
#  1. Select subprogram output style in either in-line or external SPF file
#  2. Specify labels and/or subprogram name
#  3. Validate subprogram name
#*****************************************************************************
#

   global mom_sys_output_contour_motion
   global mom_machine_control_motion_output
   global mom_sys_output_cycle95
   global mom_machine_cycle_subroutine_name
   global mom_operation_name
   global mom_template_subtype

   set mom_sys_output_contour_motion 0

  # Skip contour output for non-turning operations
   if { [info exists ::mom_operation_type] && ![string match "*Turn*" $::mom_operation_type] } {
      return
   }

  #======================================================
  # When turning processor has produced contour data and
  # post is equipped with the ability to output cycle95:
  #======================================================
   if { ([info exists mom_machine_control_motion_output] && $mom_machine_control_motion_output == 2) && \
        ([info exists mom_sys_output_cycle95] && $mom_sys_output_cycle95) } {

     # <2016-12-06 szl> Check if the operations are supported by CYCLE95, if not, will switch the output mode from Machine-Cycle to
     #                  None_Machine_Cycle and list the warning message.
      if {[string match "*ROUGH*" $mom_template_subtype] || [string match "*FINISH*" $mom_template_subtype] || \
          [string match "FACING" $mom_template_subtype]} {

        # <2016-11-28 szl> Check if Profile stock are same as Rough stock while "Additional Profile" option is on,
        #                  if no, we will switch output mode from Machine-Cycle to Non-Machine-Cycle.
         if {[info exists ::mom_profiling] && ($::mom_profiling == 1)} {
            if { !([EQ_is_equal $::mom_finish_equidistant_stock $::mom_stock_part] && \
                   [EQ_is_equal $::mom_finish_face_stock $::mom_face_stock] && \
                   [EQ_is_equal $::mom_finish_radial_stock $::mom_radial_stock]) } {

               MOM_output_to_listing_device "$mom_operation_name: Additional Profiling can only be used when profile stock is the same with rough stock.\
                                       \nSo it will not be output in current operation. Switch output mode from Machine-Cycle to Non-Machine-Cycle."
               return
            }
         }

        #----------------------------------------
        # Notify NX/Post to process contour data
        #----------------------------------------
         set mom_sys_output_contour_motion 1

      } else {
         MOM_output_to_listing_device "$mom_operation_name: The Machine Cycle motion output has not been supported for current operation type so far.\
                                       \nSwitch output mode from Machine-Cycle to Non-Machine-Cycle."
      }


     #####################################################
     # Set CYCLE95 contour output mode
     #
     #   LBL: Output subprogram in-line with main program
     #        (Enclosed in start & end labels)
     #   LBL_END: Output subprogram at end of main program
     #        (Enclosed in start & end labels)
     #   SUB: Output subprogram in a separate SPF file
     #####################################################
      global mom_siemens_cycle95_output_mode

    #  set mom_siemens_cycle95_output_mode  "LBL"
      set mom_siemens_cycle95_output_mode "LBL_END"
    #  set mom_siemens_cycle95_output_mode  "SUB"


     #++++++++++++++++++++++++++++++++++++++++++++++++
     # Defined start & end labels and subprogram name
     # ==> User may customize these labels as needed.
     #++++++++++++++++++++++++++++++++++++++++++++++++
      global mom_sys_cycle95_subprogram_name
      global mom_sys_cycle95_subprogram_start
      global mom_sys_cycle95_subprogram_end

     # Define subprogram name when it is not specified in NX.
      if { ![info exists mom_machine_cycle_subroutine_name] } {
         set  mom_machine_cycle_subroutine_name SUB_$mom_operation_name
         set mom_sys_cycle95_subprogram_end    "[string toupper $mom_operation_name]_END"
      } elseif { ![string compare "" $mom_machine_cycle_subroutine_name] } {
         set  mom_machine_cycle_subroutine_name SUB_$mom_operation_name
         set mom_sys_cycle95_subprogram_end    "[string toupper $mom_operation_name]_END"
      } else {
         set mom_sys_cycle95_subprogram_end    "[string toupper $mom_machine_cycle_subroutine_name]_END"
      }
      set mom_sys_cycle95_subprogram_name   "[string toupper $mom_machine_cycle_subroutine_name]"
      set mom_sys_cycle95_subprogram_start  "[string toupper $mom_machine_cycle_subroutine_name]"


     # Validate subprogram name and labels
      PB_CMD_check_subroutine_name


     #---------------------------------------------------------------
     # Save current position of this event.
     # - It will be used as the return position after the cycle call.
     #---------------------------------------------------------------
     # <10-30-15> szl - Don't need it as return position any more, so remove it.
     # global mom_pos mom_pos_saved_for_cycle95
     # VMOV 3 mom_pos mom_pos_saved_for_cycle95


     #------------------------------
     # Skip to the end of operation
     #------------------------------
     # <10-30-15> szl - Due to we have generic cycle now, we don't need to skip
     #                  to the end of operation here.
     # MOM_abort_operation
   } else {
      MOM_output_to_listing_device "$mom_operation_name: Lathe Rough Cycle has not been supported in Post Processor currently.\
                                    \nSwitch output mode from Machine-Cycle to Non-Machine-Cycle."
   }

}


#=============================================================
proc PB_CMD_init_cycle_parameters { } {
#=============================================================
#this procedure is used to set cycle parameters for sinumerik 840D

   global mom_cycle_spindle_axis
   if {![info exists mom_cycle_spindle_axis]} {
      set mom_cycle_spindle_axis 2
   }

   #-------------------------------------------------------
   #optinal data
   #-------------------------------------------------------
   global mom_cycle_delay_mode
   global mom_cycle_delay
   global mom_cycle_delay_revs
   global mom_siemens_cycle_dtb
   global mom_siemens_cycle_dts_mode
   global mom_siemens_cycle_dts
   global mom_siemens_cycle_o_dtd_mode
   global mom_siemens_cycle_o_dtd

  if {[info exists mom_cycle_delay_mode]} {
      set mom_cycle_delay_mode [string toupper $mom_cycle_delay_mode]
      if {[info exists mom_cycle_delay] && [string match "SECONDS" $mom_cycle_delay_mode]} {
          set mom_siemens_cycle_dtb [expr abs($mom_cycle_delay)]
      } elseif {[info exists mom_cycle_delay_revs] && [string match "REVOLUTIONS" $mom_cycle_delay_mode]} {
          set mom_siemens_cycle_dtb [expr -1*abs($mom_cycle_delay_revs)]
          set mom_cycle_delay_revs [expr -1*$mom_cycle_delay_revs]
      } elseif { [string match "OFF" $mom_cycle_delay_mode]} {
      } else {
          set mom_cycle_delay 1
          set mom_siemens_cycle_dtb 1
      }
   }

   if {[info exists mom_siemens_cycle_dts_mode]} {
      set mom_siemens_cycle_dts_mode [string toupper $mom_siemens_cycle_dts_mode]
      if {[info exists mom_siemens_cycle_dts] && [string match "SECONDS" $mom_siemens_cycle_dts_mode]} {
          set mom_siemens_cycle_dts [expr abs($mom_siemens_cycle_dts)]
      } elseif {[info exists mom_siemens_cycle_dts] && [string match "REVOLUTIONS" $mom_siemens_cycle_dts_mode]} {
          set mom_siemens_cycle_dts [expr -1*abs($mom_siemens_cycle_dts)]
      } elseif {[string match "OFF" $mom_siemens_cycle_dts_mode]} {
          catch {unset mom_siemens_cycle_dts}
      }
   }

   if {[info exists mom_siemens_cycle_o_dtd_mode]} {
      set mom_siemens_cycle_o_dtd_mode [string toupper $mom_siemens_cycle_o_dtd_mode]
      if {[info exists mom_siemens_cycle_o_dtd] && [string match "SECONDS" $mom_siemens_cycle_o_dtd_mode]} {
          set mom_siemens_cycle_o_dtd [expr abs($mom_siemens_cycle_o_dtd)]
      } elseif {[info exists mom_siemens_cycle_o_dtd] && [string match "REVOLUTIONS" $mom_siemens_cycle_o_dtd_mode]} {
          set mom_siemens_cycle_o_dtd [expr -1*abs($mom_siemens_cycle_o_dtd)]
      } elseif {[string match "ON" $mom_siemens_cycle_o_dtd_mode]} {
          set mom_siemens_cycle_o_dtd 0
      } elseif {[string match "OFF" $mom_siemens_cycle_o_dtd_mode]} {
          catch {unset mom_siemens_cycle_o_dtd}
      }
   }

   global mom_cycle_step1
   global mom_cycle_step2
   global mom_cycle_step3
   global feed
   global mom_sys_spindle_direction_code
   global mom_spindle_direction
   global mom_feed_retract_value

   global mom_siemens_cycle_fdpr
   global mom_siemens_cycle_dam
   global mom_siemens_cycle_frf
   global mom_siemens_cycle_ffr
   global mom_siemens_cycle_rff
   global mom_siemens_cycle_sdir
   global mom_siemens_cycle_o_mdep

   if [info exists mom_cycle_step1] {
       set mom_siemens_cycle_fdpr $mom_cycle_step1
   }
   if {[info exists mom_cycle_step2]} {
       set mom_siemens_cycle_dam $mom_cycle_step2
   }
   if {[info exists mom_cycle_step3]} {
       set mom_siemens_cycle_o_mdep $mom_cycle_step3
   }
   set mom_siemens_cycle_ffr $feed

   if {![info exists mom_siemens_cycle_rff] || [EQ_is_zero $mom_siemens_cycle_rff]} {
      if {[info exists mom_feed_retract_value] && ![EQ_is_zero $mom_feed_retract_value]} {
         set mom_siemens_cycle_rff $mom_feed_retract_value
      } else {
         set mom_siemens_cycle_rff $feed
      }
   }

   if {![info exists mom_siemens_cycle_frf]} {
      set mom_siemens_cycle_frf 1
   }

   set mom_siemens_cycle_sdir 3
   if {[info exists mom_spindle_direction]} {
       switch $mom_spindle_direction {
          "CLW"  { set mom_siemens_cycle_sdir 3}
          "CCLW" { set mom_siemens_cycle_sdir 4}
       }
   }
}


#=============================================================
proc PB_CMD_init_dnc_header { } {
#=============================================================
#
#  This custom will produce a DNC header at the start of your NC output.
#
#  To enable the DNC Header you must attach a DNC Header UDE to your
#  program group.
#
#      Note:  The system will automatically use the machine name,
#      program name and user name if you leave those fields blank.
#
  set level [info level]
  set upper_proc [info level [expr $level-1]]
  if {![string match $upper_proc "PB_start_of_program"]} {
     global mom_warning_info
     set mom_warning_info "PB_CMD_init_dnc_header should not be called by $upper_proc . It should be only attached to Start of Program event marker."
     catch {MOM_catch_warning}
return
  }

  if {![llength [info commands MOM_dnc_header ]]} {
    uplevel #0 {
    #=============================================================
    proc MOM_dnc_header {} {
    #=============================================================
      global mom_dnc_machine_name
      global mom_dnc_program_name
      global mom_dnc_data_type
      global mom_dnc_version_number
      global mom_dnc_release_number
      global mom_dnc_user_name
      global mom_command_status
      PB_CMD_MOM_dnc_header
    }
    };#uplevel
  }
}


#=============================================================
proc PB_CMD_init_extcall { } {
#=============================================================
# This command will generate separated sub program file for each operation and
# main program file using EXTCALL to call sub programs.
#
# This command is used with PB_CMD_start_of_extcall_operation,
# PB_CMD_end_of_extcall_operation and PB_CMD_end_of_extcall_program
#
# You must attach a Sinumerik Program Control UDE to your program group.
#
  set level [info level]
  set upper_proc [info level [expr $level-1]]
  if { ![string match $upper_proc "PB_start_of_program"] } {
     global mom_warning_info
     set mom_warning_info "PB_CMD_init_extcall should not be called by $upper_proc . It should be only attached to Start of Program event marker."
     catch { MOM_catch_warning }
return
  }

  if { ![llength [info commands MOM_program_control ]] } {
     uplevel #0 {
     #=============================================================
     proc MOM_program_control { } {
     #=============================================================
        global mom_siemens_program_control
        PB_CMD_MOM_program_control
     }
     };#uplevel
  }
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

set mom_sys_helix_pitch_type    "none"

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

   if { [string compare "none" $mom_sys_helix_pitch_type] } {
      MOM_force once I J K

#<08-01-06 gsl>
      switch $mom_sys_cir_vector {
         "Vector - Arc Center to Start" {
            set mom_prev_pos($cir_index) $pitch
            set mom_pos_arc_center($cir_index) 0.0
         }
         "Vector - Arc Start to Center" -
         "Unsigned Vector - Arc Start to Center" {
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
   global mom_pos
   global mom_prev_pos
   global mom_helix_turn_number
   set pitch [expr abs($mom_helix_pitch)]
   set feed_distance [expr abs($mom_pos($cir_index) - $mom_prev_pos($cir_index))]
   if {[EQ_is_zero $pitch]} {
      set mom_helix_turn_number 0
   } else {
      set mom_helix_turn_number [expr floor($feed_distance/$pitch)]
   }
   MOM_force Once helix_turn
   switch $mom_pos_arc_plane {
      XY { MOM_suppress once K ; MOM_force Once I J }
      YZ { MOM_suppress once I ; MOM_force Once J K }
      ZX { MOM_suppress once J ; MOM_force Once I K }
   }

   MOM_do_template circular_move
   unset mom_helix_turn_number


} ;# MOM_helix_move


} ;# uplevel
}


#=============================================================
proc PB_CMD_init_high_speed_setting { } {
#=============================================================
# This command is used to uplevel the MOM_high_speed_setting.
#
# It is applied for the UDE "Sinumerik 840D".
#
# Please don't remove this command.
#
# 23-Dec-2016 shuai - CYCLE832 enhancement.
#

  if {![CALLED_BY "PB_start_of_program" 1] } {

     return
  }


  if { ![llength [info commands MOM_high_speed_setting ]] } {

     uplevel #0 {

     #=============================================================
     proc MOM_high_speed_setting { } {
     #=============================================================

       PB_CMD_MOM_sinumerik_840D

     } ; # proc MOM_high_speed_setting

     } ; # uplevel

  }

}


#=============================================================
proc PB_CMD_init_ini_files { } {
#=============================================================
# This procedure is used with simulation_ini.tcl file which should be sourced
# in postprocessor as a user tcl file for generating ini files.
# This procedure will be excuted when simulation_ini.tcl is sourcing.
# Once you source the simulation_ini.tcl file in a postprocessor, remove this
# procedure from Start of Program will NOT affect the result.
#
# Following mom variables are used to set the options for ini files.
# mom_sinumerik_ini_create
#    "Yes"          ini files will be created
#    "No "          ini files will not be created
#
# mom_sinumerik_ini_location
#    "Part"         ini files will be output to a subfolder \cse_files\subprog
#                   of cam part file location. If \cse_files\subprog is not exists
#                   post will create this folder.
#    "CSE"          ini files will be output to sub folder \subprog of \cse_driver
#                   folder which located in same directory of \postprocessor as installed
#                   machine examples.
#    "ENV"          ini files will be output to a sub folder \subprog of enviornment
#                   variable defined directory.
#                   If it is not exists, ini files will be output to "Part".
#
# mom_sinumerik_ini_existing
#    "Rename"       Rename existing ini files to .bck in place where the one is created.
#    "Keep"         Keep ini files in place where the one is created.
#    "Delete"       Delete ini files in place where the one is created.
#
# mom_sinumerik_ini_end_status
#    "Rename"       Rename created ini file to .bck file after post run.
#    "Keep"         Keep created ini files after post run.
#    "Delete"       Delete created ini files after post run.


  global mom_sinumerik_ini_create
  global mom_sinumerik_ini_location
  global mom_sinumerik_ini_keep_existing
  global mom_sinumerik_ini_end_status

  set mom_sinumerik_ini_create     "Yes"
  set mom_sinumerik_ini_location   "Part"
  set mom_sinumerik_ini_existing   "Rename"
  set mom_sinumerik_ini_end_status "Keep"

}


#=============================================================
proc PB_CMD_init_nurbs { } {
#=============================================================
#
#  You will need to activate nurbs motion in NX CAM under machine control
#  to generate nurbs events.
#
#  This procedure is used to initialize nurbs output type.  It must be
#  placed in the Start of Program marker.
#
#  If set mom_kin_nurbs_output_type as "BSPLINE", please call PB_CMD_nurbs_spline
#  at NURBS Motion event. If set mom_kin_nurbs_output_type as "SIEMENS_POLY",
#  please call PB_CMD_nurbs_poly at NURBS Motion event.

  global mom_kin_nurbs_output_type
  global mom_kin_read_ahead_next_motion

  set mom_kin_nurbs_output_type              "BSPLINE"

  # For nurbs(Bspline) event to get next motion's type
  set mom_kin_read_ahead_next_motion 1
  MOM_reload_kinematics
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
if !$spindle_axis_defined {
  set mom_sys_spindle_axis(0)                    0.0
  set mom_sys_spindle_axis(1)                    0.0
  set mom_sys_spindle_axis(2)                    1.0
}

set mom_sys_lock_status                        "OFF"
}


#=============================================================
proc PB_CMD_init_thread { } {
#=============================================================
# This ommand will be executed automatically at the start of program.
# Please do not remove it!!!

uplevel #0 {
 #=============================================================
 proc PB_LATHE_THREAD_SET { } {
 #=============================================================
  global mom_lathe_thread_type mom_lathe_thread_advance_type
  global mom_lathe_thread_lead_i mom_lathe_thread_lead_k
  global mom_motion_distance
  global mom_lathe_thread_increment mom_lathe_thread_value
  global thread_type thread_increment feed_rate_mode

    switch $mom_lathe_thread_advance_type {
      1 { set thread_type CONSTANT ; MOM_suppress once E }
      2 { set thread_type INCREASING ; MOM_force once E }
      default { set thread_type DECREASING ; MOM_force once E }
    }

    if { ![string compare $thread_type "INCREASING"] || ![string compare $thread_type "DECREASING"] } {
      if { $mom_lathe_thread_type != 1 } {
        set LENGTH $mom_motion_distance
        set LEAD $mom_lathe_thread_value
        set INCR $mom_lathe_thread_increment
        set E [expr abs(pow(($LEAD + ($INCR * $LENGTH)) , 2) - pow($LEAD , 2)) / 2 * $LENGTH]
        set thread_increment $E
      }
    }

    if { $mom_lathe_thread_lead_i == 0 } {
      MOM_suppress once I ; MOM_force once K
    } elseif { $mom_lathe_thread_lead_k == 0 } {
      MOM_suppress once K ; MOM_force once I
    } else {
      MOM_force once I ; MOM_force once K
    }
 }
}; #uplevel 0
}


#=============================================================
proc PB_CMD_init_thread_cycle { } {
#=============================================================
# This command is used to calculate thread cycle parameters
 global thread_cycle_flag
 global cycle_name
 global mom_thread_cycle_taper
 global thread_start_pos  thread_end_pos
 global mom_pos mom_prev_pos
 global mom_turn_thread_crest_line
 global mom_turn_thread_root_line
 global mom_turn_thread_end_line
 global mom_crest_line_offset
 global mom_root_line_offset
 global mom_sys_lathe_x_factor mom_sys_lathe_x_double
 global mom_total_depth mom_total_depth_type
 global mom_total_depth_increment_type
 global mom_total_depth_constant_increment
 global mom_total_depth_variable_increment
 global thread_rough_number_of_passes thread_cycle_o_vrt
 global mom_siemens_cycle_vari
 global mom_tool_orientation
 global mom_lathe_spindle_axis
 global PI RAD2DEG DEG2RAD
 global mom_siemens_thread_counter
 global mom_tool_holder_angle_for_cutting
 global mom_tool_holder_orient_angle
 global mom_tool_axis
 global mom_area_start_point_offset
 global mom_area_end_point_offset


 # If cycle_name is THREAD, it is start of thread cycle.
 if {$cycle_name == "THREAD"} {
    set thread_cycle_flag 1
    set mom_siemens_thread_counter 0

    if {[string match $mom_lathe_spindle_axis "MCSX"]} {
       set xs 0 ; set ys 1
       set xe 3 ; set ye 4
    } elseif {[string match $mom_lathe_spindle_axis "MCSZ"]} {
       set xs 2 ; set ys 0
       set xe 5 ; set ye 3
    }

    #------------------------------------------------------
    # SPL FPL DM1 DM2 - start and end point
    #------------------------------------------------------
    set thread_start_pos(0) $mom_turn_thread_crest_line($ys)
    set thread_start_pos(2) $mom_turn_thread_crest_line($xs)

    if {[info exists mom_turn_thread_end_line]} {
       set xcs $mom_turn_thread_crest_line($xs)
       set ycs $mom_turn_thread_crest_line($ys)
       set xce $mom_turn_thread_crest_line($xe)
       set yce $mom_turn_thread_crest_line($ye)
       set xes $mom_turn_thread_end_line($xs)
       set yes $mom_turn_thread_end_line($ys)
       set xee $mom_turn_thread_end_line($xe)
       set yee $mom_turn_thread_end_line($ye)
       set thread_end_pos(0) [expr (($yce - $ycs) * ($xee * $yes - $xes * $yee) + ($yee - $yes) * ($xcs * $yce - $xce * $ycs)) / (($yce - $ycs) * ($xee - $xes) - ($xce - $xcs) * ($yee - $yes))]

       if {[EQ_is_equal $yee $yes]} {
          set thread_end_pos(2) $mom_turn_thread_end_line($ye)
       } else {
         set thread_end_pos(2) [expr ($xee - $xes) * ($thread_end_pos(0) - $yes) / ($yee - $yes) + $xes]
       }
    } else {
       set thread_end_pos(0)   $mom_turn_thread_crest_line($ye)
       set thread_end_pos(2)   $mom_turn_thread_crest_line($xe)
    }

    if {[info exists mom_crest_line_offset] && ![EQ_is_zero $mom_crest_line_offset]} {
       set length [expr sqrt(($thread_start_pos(0)-$thread_end_pos(0))*($thread_start_pos(0)-$thread_end_pos(0)) + ($thread_start_pos(2)-$thread_end_pos(2))*($thread_start_pos(2)-$thread_end_pos(2)))]
       set offset [expr abs($mom_crest_line_offset)]
       set distance_pos(0) [expr abs($thread_start_pos(2) - $thread_end_pos(2)) * $offset / $length]
       if {$mom_tool_orientation > $PI} {
          set $distance_pos(0) [expr -1*$distance_pos(0)]
       }
       set thread_start_point(0) [expr $thread_start_pos(0) + $distance_pos(0)]
       if {[EQ_is_equal $thread_end_pos(2) $thread_start_pos(2)]} {
          set thread_start_point(2) [expr $thread_start_pos(2) + $mom_crest_line_offset]
       } else {
          set thread_start_point(2) [expr ($thread_end_pos(0)- $thread_start_pos(0))*($thread_start_point(0)-$thread_start_pos(0))/($thread_start_pos(2)-$thread_end_pos(2))+$thread_start_pos(2)]
       }
       set thread_end_point(0)   [expr $thread_end_pos(0) + $distance_pos(0)]
       set thread_end_point(2)   [expr $thread_end_pos(2) + $thread_start_point(2) - $thread_start_pos(2)]
       set thread_start_pos(0)   $thread_start_point(0)
       set thread_start_pos(2)   $thread_start_point(2)
       set thread_end_pos(0)     $thread_end_point(0)
       set thread_end_pos(2)     $thread_end_point(2)
    }
    set thread_start_pos(0) [expr $thread_start_pos(0) * $mom_sys_lathe_x_factor * $mom_sys_lathe_x_double]
    set thread_end_pos(0)   [expr $thread_end_pos(0) * $mom_sys_lathe_x_factor * $mom_sys_lathe_x_double]

    #-----------------------------------------------------
    # TDEP - total cutting depth
    #-----------------------------------------------------
    if {$mom_total_depth_type == 0} {
       if { [info exists mom_turn_thread_crest_line] && [info exists mom_turn_thread_root_line]} {
          set xcs $mom_turn_thread_crest_line($xs)
          set ycs $mom_turn_thread_crest_line($ys)
          set xce $mom_turn_thread_crest_line($xe)
          set yce $mom_turn_thread_crest_line($ye)
          set xrs $mom_turn_thread_root_line($xs)
          set yrs $mom_turn_thread_root_line($ys)
          set xre $mom_turn_thread_root_line($xe)
          set yre $mom_turn_thread_root_line($ye)
          if {[EQ_is_equal $xre $xrs]} {
             set inter_point(0) $mom_turn_thread_crest_line($ys)
             set inter_point(2) [expr ($xre-$xrs)*($ycs-$yrs)/($yre-$yrs)+$xrs]
             set inter_distance [expr abs($xcs - $inter_point(2)))]
          } else {
             set inter_point(2) $mom_turn_thread_crest_line($xs)
             set inter_point(0) [expr ($xcs-$xrs)*($yre-$yrs)/($xre-$xrs)+$yrs]
             set inter_distance [expr sqrt(($xcs-$inter_point(2))*($xcs-$inter_point(2)) + ($ycs-$inter_point(0))*($ycs-$inter_point(0)))]
          }
          set length [expr sqrt(($xcs-$xce)*($xcs-$xce) + ($ycs-$yce)*($ycs-$yce))]
          set mom_total_depth [expr $inter_distance * abs($xcs-$xce) / $length]
       }
    }

    #-----------------------------------------------------
    #FAI - finish allowance
    #-----------------------------------------------------
    global mom_siemens_cycle_fal
    global mom_total_depth_finish_passes_increment
    global mom_total_depth_finish_passes_number_of_passes
    global siemens_thread_cycle_number_of_finish
    set mom_siemens_cycle_fal 0
    set siemens_thread_cycle_number_of_finish 0
    for {set i 0} {$i<6} {incr i} {
       set mom_siemens_cycle_fal [expr $mom_siemens_cycle_fal + $mom_total_depth_finish_passes_increment($i)*$mom_total_depth_finish_passes_number_of_passes($i)]
       set siemens_thread_cycle_number_of_finish [expr $siemens_thread_cycle_number_of_finish + $mom_total_depth_finish_passes_number_of_passes($i)]
    }

    #-----------------------------------------------------
    #IANG - infeed angle
    #-----------------------------------------------------
    global mom_siemens_cycle_iang
    global mom_thread_infeed_vector mom_thread_infeed_angle
    if {[info exists mom_thread_infeed_vector]} {
       set mom_siemens_cycle_iang [expr $RAD2DEG*atan2($mom_thread_infeed_vector(1),$mom_thread_infeed_vector(0))]
    } elseif {[info exists mom_thread_infeed_angle]} {
       set mom_siemens_cycle_iang $mom_thread_infeed_angle
    }

    #-----------------------------------------------------
    #VARI - thread type
    #-----------------------------------------------------
    set mom_siemens_cycle_vari 3
    if {$mom_tool_orientation < $PI} {
       if { $mom_total_depth_increment_type == 1 } {
          set mom_siemens_cycle_vari 3
       } else {
         set mom_siemens_cycle_vari 1
       }
    } else {
       if { $mom_total_depth_increment_type == 1 } {
          set mom_siemens_cycle_vari 4
       } else {
         set mom_siemens_cycle_vari 2
       }
    }

   # If cycle_name is LATHE_THREAD, it is thread cutting.
 } elseif {$cycle_name == "LATHE_THREAD"} {
     incr mom_siemens_thread_counter
     set cycle_name "THREAD_MOVE"
 }



 #-----------------------------------------------------
 #NRC - number of rough passes
 #-----------------------------------------------------
  global mom_number_of_starts
  global mom_number_of_chases
  global mom_siemens_cycle_nrc
  global siemens_thread_cycle_number_of_finish
  set mom_siemens_cycle_nrc  [expr $mom_siemens_thread_counter/$mom_number_of_starts - $mom_number_of_chases -$siemens_thread_cycle_number_of_finish]
}


#=============================================================
proc PB_CMD_init_tool_list { } {
#=============================================================
#  This command will be executed automatically at the "Start of Program" to
#  prepare for the tool list generation.
#
#  This command will add the shop doc event handlers to the post.
#  You may edit the proc MOM_TOOL_BODY to customize your tool list output.
#
#  Only the tools used in the program being post-processed will be listed.
#
#  In order to create the tool list, you MUST add the command
#  PB_CMD_create_tool_list to either the "Start of Program"
#  or the "End of Program" event marker depending on where
#  the tool list is to be output in your NC code.
#
#  The Shop Doc template file "pb_post_tool_list.tpl" residing in the
#  "postbuild/pblib/misc" directory is required for this service to work.
#  You may need to copy it to the "mach/resource/postprocessor"
#  or "mach/resource/shop_docs" directory, in case your UG runtime
#  environment does not have access to the Post Builder installation.
#

   global mom_sys_tool_list_initialized


uplevel #0 {

proc MOM_TOOL_BODY { } {
   global mom_tool_name
   global mom_tool_number
   global mom_tool_diameter
   global mom_tool_length
   global mom_tool_type
   global mom_template_subtype
   global mom_tool_point_angle
   global mom_tool_flute_length
   global mom_tool_length_adjust_register
   global mom_tool_nose_radius
   global mom_tool_corner1_radius
   global mom_tool_flute_length
   global mom_tool_orientation
   global mom_sys_control_out mom_sys_control_in
   global cycle_program_name current_program_name
   global mom_sys_tool_stack

   global tool_data_buffer


  # Handle single operation case.
  # current_program_name will be blank when no group has been selected.

   if { $current_program_name != "" } {
      set n1 [string toupper $cycle_program_name]
      set n2 [string toupper $current_program_name]
      if { $n1 != $n2 && $n1 != "" } {
return
      }
   } else {

     # mom_sys_change_mach_operation_name is set in MOM_machine_mode
     # Use this variable to generate tool info for a single operation.

      global mom_sys_change_mach_operation_name mom_operation_name

      if [info exists mom_sys_change_mach_operation_name] {
         if { ![string match "$mom_operation_name" $mom_sys_change_mach_operation_name] } {
return
         }
      } else {
return
      }
   }


  #****************************
  # Collect various tool lists
  #****************************
   lappend mom_sys_tool_stack(IN_USE) $mom_tool_name

   set tool_type [MAP_TOOL_TYPE]

   if { [lsearch $mom_sys_tool_stack(ALL) $mom_tool_name] < 0 } {

      lappend mom_sys_tool_stack(ALL)         $mom_tool_name
      lappend mom_sys_tool_stack($tool_type)  $mom_tool_name
   }


  #*************************************************
  # Define data to be output for each tool per type
  #*************************************************
   set output ""

   set ci $mom_sys_control_in
   set co $mom_sys_control_out

   if { $mom_template_subtype == "" } { set mom_template_subtype $mom_tool_type }

   set tool_name [string range $mom_tool_name 0 19]
   set template_subtype [string range $mom_template_subtype 0 19]

   switch $tool_type {

      "MILL" {


         set output [format "%-20s %-20s %-10.4f %-10.4f %-10.4f %-10d"  $tool_name $template_subtype  $mom_tool_diameter $mom_tool_corner1_radius  $mom_tool_flute_length $mom_tool_length_adjust_register]
      }

      "DRILL" {

         set mom_tool_point_angle [expr (180.0 / 3.14159) * $mom_tool_point_angle]
         set output [format "%-20s %-20s %-10.4f %-10.4f %-10.4f %-10d"  $tool_name $template_subtype  $mom_tool_diameter $mom_tool_point_angle  $mom_tool_flute_length $mom_tool_length_adjust_register]
      }

      "LATHE" {

         set pi [expr 2 * asin(1.0)]
         set tool_orient [expr (180. / 3.14159) * $mom_tool_orientation]
         set output [format "%-20s %-20s %-10.4f %-15.4f %-10d"  $tool_name $template_subtype  $mom_tool_nose_radius $tool_orient  $mom_tool_length_adjust_register]
      }
   }


  #*******************************************************************************
  # Fetch tool time data from the post.
  # This info is only available when tool list is created at the end of a program.
  #*******************************************************************************
   global mom_sys_tool_list_output_type
   global mom_sys_tool_time
   global mom_operation_name

   set tool_time ""

   if [info exists mom_sys_tool_time] {

      switch $mom_sys_tool_list_output_type {
         "ORDER_IN_USE" {
           # Tool time per operations.
            set tool_time $mom_sys_tool_time($mom_tool_name,$mom_operation_name)
         }

         default {
           # Accumulate tool time from all operations using this tool.
            set tool_time 0
            if [info exists mom_sys_tool_time($mom_tool_name,oper_list)] {
               foreach oper $mom_sys_tool_time($mom_tool_name,oper_list) {
                  set tool_time [expr $tool_time + $mom_sys_tool_time($mom_tool_name,$oper)]
               }
            }
         }
      }
   }

   if { $tool_time != ""  &&  $tool_time != "0" } {
      set tool_time [format "%-10.2f" $tool_time]
   }


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Store data to be output or used in PB_CMD_create_tool_list.
  #
  # <Ex.>
  #  global mom_tool_number
  #   set tool_data_buffer($mom_tool_name,tool_number) $mom_tool_number
  #
  # If a BLOCK_TEMPLATE is used to output the data, the global varaibles
  # used in the expression of an Address need to be set accordingly
  # before "MOM_do_template" is called.
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   set tool_data_buffer($mom_tool_name,output) "$co$output$tool_time$ci"
   set tool_data_buffer($mom_tool_name,type)   "$tool_type"
}


proc MOM_SETUP_HDR {} {
   global mom_sys_control_out mom_sys_control_in


  # Initialize various tool lists
   global mom_sys_tool_stack

   set mom_sys_tool_stack(IN_USE) [list]
   set mom_sys_tool_stack(ALL)    [list]
   set mom_sys_tool_stack(MILL)   [list]
   set mom_sys_tool_stack(DRILL)  [list]
   set mom_sys_tool_stack(LATHE)  [list]


   set ci $mom_sys_control_in
   set co $mom_sys_control_out


  #++++++++++++++++++++++++++++++++++++++++++
  # Define header to be output per tool type
  #++++++++++++++++++++++++++++++++++++++++++
   global tool_data_buffer

   set tool_desc   "DESCRIPTION"
   set tool_dia    "DIAMETER"
   set corner_rad  "COR RAD"
   set tip_ang     "TIP ANG"
   set flute_len   "FLUTE LEN"
   set adjust      "ADJ REG"
   set nose_dia    "NOSE RAD"
   set tool_orient "TOOL ORIENT"

  # Label title for tool time only when it exists.
   global mom_sys_tool_time
   if [info exists mom_sys_tool_time] {
      set mach_time   "MACH TIME"
   } else {
      set mach_time   ""
   }

     set tool_name   "DRILL"
     set output [format "%-20s %-20s %-10s %-10s %-10s %-9s %-10s"  $tool_name $tool_desc  $tool_dia $tip_ang $flute_len $adjust $mach_time]

     set header [list]
     lappend header "$co                                                                                               $ci"
     lappend header ";$co-----------------------------------------------------------------------------------------------$ci"
     lappend header ";$co$output$ci"
     lappend header ";$co-----------------------------------------------------------------------------------------------$ci"

   set tool_data_buffer(DRILL,header) [join $header \n]


     set tool_name   "MILL"
     set output [format "%-20s %-20s %-10s %-10s %-10s %-9s %-10s"  $tool_name $tool_desc  $tool_dia $corner_rad $flute_len $adjust $mach_time]

     set header [list]
     lappend header "$co                                                                                               $ci"
     lappend header ";$co-----------------------------------------------------------------------------------------------$ci"
     lappend header ";$co$output$ci"
     lappend header ";$co-----------------------------------------------------------------------------------------------$ci"

   set tool_data_buffer(MILL,header) [join $header \n]


     set tool_name   "LATHE"
     set output [format "%-20s %-20s %-10s %-15s %-9s %-10s"  $tool_name $tool_desc $nose_dia $tool_orient $adjust $mach_time]

     set header [list]
     lappend header "$co                                                                                               $ci"
     lappend header ";$co-----------------------------------------------------------------------------------------------$ci"
     lappend header ";$co$output$ci"
     lappend header ";$co-----------------------------------------------------------------------------------------------$ci"

   set tool_data_buffer(LATHE,header) [join $header \n]
}


proc MOM_PROGRAMVIEW_HDR {} {}
proc MOM_SETUP_FTR {} {}


proc MOM_MEMBERS_HDR {} {
   global mom_sys_program_stack cycle_program_name
   global current_program_name

   lappend mom_sys_program_stack $cycle_program_name

   if { [lsearch $mom_sys_program_stack "$current_program_name"] >= 0 } {
      set cycle_program_name $current_program_name
   }
}


proc MOM_MEMBERS_FTR {} {
   global mom_sys_program_stack cycle_program_name
   global current_program_name

   set mom_sys_program_stack [lreplace $mom_sys_program_stack end end]
   set cycle_program_name [lindex $mom_sys_program_stack end]

   if { [lsearch $mom_sys_program_stack "$current_program_name"] >= 0 } {
      set cycle_program_name $current_program_name
   }
}


proc MOM_PROGRAM_BODY {} {
   global mom_object_name cycle_program_name

   set cycle_program_name $mom_object_name
}


proc MOM_SETUP_BODY {} {}
proc MOM_OPER_BODY  {} {}
proc MOM_TOOL_HDR   {} {}
proc MOM_TOOL_FTR   {} {}
proc MOM_PROGRAMVIEW_FTR {} {}


proc MAP_TOOL_TYPE { } {
   global mom_tool_type

   if {[string match "Milling*" $mom_tool_type]} {
      return "MILL"
   } elseif { [string match "Turning*" $mom_tool_type]} {
      return "LATHE"
   } elseif { [string match "Grooving*" $mom_tool_type]} {
      return "LATHE"
   } elseif { [string match "Threading*" $mom_tool_type]} {
      return "LATHE"
   } elseif { [string match "Drilling*" $mom_tool_type]} {
      return "DRILL"
   } else {
      return ""
   }
}


proc shop_doc_output_literal { line } {
   global tool_list_commentary list_file

   set line_list [split $line \n]

   foreach line $line_list {

      if [info exists tool_list_commentary] {
         puts $list_file $line
      } else {
         MOM_output_literal $line
      }

   }
}


} ;# uplevel


   set mom_sys_tool_list_initialized 1
}


#=============================================================
proc PB_CMD_init_transmit { } {
#=============================================================
# Please don't remove this command
  set level [info level]
  set upper_proc [info level [expr $level-1]]
  if {![string match $upper_proc "PB_start_of_program"]} {
     global mom_warning_info
     set mom_warning_info "PB_CMD_init_transmit should not be called by $upper_proc . It should be only attached to Start of Program event marker."
     catch {MOM_catch_warning}
return
  }

if {![llength [info commands MOM_set_transmit ]]} {
   uplevel #0 {
  #=============================================================
   proc MOM_set_transmit { } {
  #=============================================================
      global mom_siemens_transmit_mode
      PB_CMD_MOM_set_transmit
   }
   };#uplevel
}

}


#=============================================================
proc PB_CMD_init_variables { } {
#=============================================================
#Initial 5axis mode.
  global mom_siemens_5axis_output_mode
  set mom_siemens_5axis_output_mode 0

#Coordinate rotation
  global mom_siemens_coord_rotation
  set mom_siemens_coord_rotation 0

#Cutcom type
  global mom_siemens_3Dcutcom_mode
  set mom_siemens_3Dcutcom_mode "OFF"

#Motion message
  global mom_siemens_pre_motion
  set mom_siemens_pre_motion "start"

#Drilling cycle count
  global mom_siemens_cycle_count
  set mom_siemens_cycle_count 0

  if {[llength [info commands MOM_ask_mcs_info ]]} {
     MOM_ask_mcs_info
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
### This is the backup of original MOM_lock_axis handler.
###
### - New command PB_CMD_MOM_lock_axis is created with the
###   same content of the original command and executed
###   by the new MOM_lock_axis handler.
###
proc DUMMY_MOM_lock_axis { } {
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
   if [llength [info commands PB_CMD_set_csys] ] {
      PB_CMD_set_csys
   }

   # Overload IKS params from machine model.
   PB_CMD_reload_iks_parameters

   # In case Axis Rotation has been set to "reverse"
   if { [llength [info commands PB_CMD_reverse_rotation_vector] ] } {
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
proc PB_CMD_lathe_thread_set { } {
#=============================================================
  global mom_lathe_thread_lead_i mom_lathe_thread_lead_k
  global mom_total_depth_angle
  global RAD2DEG

  if {![EQ_is_zero $mom_lathe_thread_lead_i] && ![EQ_is_zero $mom_lathe_thread_lead_k]} {
     set lead_angle [expr abs($RAD2DEG*$mom_total_depth_angle)]
     if {$lead_angle>180.0} {
        set lead_angle [expr fmod($lead_angle,180.0)]
     }
     if {[EQ_is_gt $lead_angle 45.0] && [EQ_is_lt $lead_angle 135.0]} {
        MOM_force Once I ; MOM_suppress Once K
     } else {
        MOM_force Once K ; MOM_suppress Once I
     }
  }

   if {[EQ_is_zero $mom_lathe_thread_lead_i]} {
      MOM_suppress Once I
   }

   if {[EQ_is_zero $mom_lathe_thread_lead_k]} {
      MOM_suppress Once K
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
  # Add PB_CMD_choose_output_mode for Sinumerik 840D template post
  # <12-01_09 lili>
  if { [llength [info commands PB_CMD_choose_output_mode]] } {
     PB_CMD_choose_output_mode
  }

  MOM_do_template linear_move
}


#=============================================================
proc PB_CMD_map_cycle95_param { } {
#=============================================================
   global mom_siemens_cycle_mid
   global mom_siemens_cycle_vari
   global mom_siemens_cycle_dam
   global mom_machine_cycle_subroutine_name
   global mom_siemens_cycle_subroutine_name
   global mom_siemens_cycle_mid
   global mom_cut_depth
   global mom_maximum
   global mom_stepover
   global mom_siemens_cycle_vari
   global mom_cleanup
   global mom_profiling
   global mom_local_return_dwell_flag
   global mom_local_return_dwell
   global mom_local_return_dwell_unit
   global mom_local_return_status
   global mom_local_return_mode
   global mom_local_return_distance
   global mom_siemens_cycle_dam
   global mom_feed_cut_unit
   global mom_feed_cut_value
   global mom_feed_stepover_unit
   global mom_feed_stepover_value
   global mom_feedrate_profile_cut_unit
   global mom_feedrate_profile_cut
   global mom_spindle_mode
   global mom_spindle_rpm mom_pos
   global mom_siemens_cycle95_output_mode


   global mom_sys_cycle95_subprogram_name
   global mom_sys_cycle95_subprogram_start
   global mom_sys_cycle95_subprogram_end

  # Subroutine name string to be referenced in CYCLE95 call
   if { [info exists mom_siemens_cycle95_output_mode] && [string match "SUB" $mom_siemens_cycle95_output_mode] } {
      set mom_siemens_cycle_subroutine_name $mom_sys_cycle95_subprogram_name
   } else {
      set mom_siemens_cycle_subroutine_name ${mom_sys_cycle95_subprogram_start}:${mom_sys_cycle95_subprogram_end}
   }

  # MID infeed depth
   global mom_turn_cycle_cut_depth
   global mom_sys_lathe_x_double
   if { [info exists mom_turn_cycle_cut_depth] } {
      set mom_siemens_cycle_mid $mom_turn_cycle_cut_depth
   } else {
      if { [info exists mom_stepover] } {
         if { $mom_stepover == 0 } {
            set mom_siemens_cycle_mid $mom_cut_depth
         } elseif { $mom_stepover == 1 || $mom_stepover == 2 }  {
            set mom_siemens_cycle_mid $mom_maximum
         }
      }
   }
   if {$mom_sys_lathe_x_double == 2} {
      set mom_siemens_cycle_mid [expr 2*$mom_siemens_cycle_mid]
   }

  # Feedrate
   global mom_operation_name
   global feed_mode

   if { [string match "SFM" $mom_spindle_mode] || [string match "SMM" $mom_spindle_mode] } {
      if { [string match "ipm" $mom_feed_cut_unit] || [string match "mmpm" $mom_feed_cut_unit] } {
         MOM_output_to_listing_device "WARNING: Cut feed rate unit $mom_feed_cut_unit doesn't match\
                                       spindle speed mode $mom_spindle_mode in $mom_operation_name!"
      }
   } else {
      set feed_mode [string toupper $mom_feed_cut_unit]
   }


   if { [string compare $mom_feed_cut_unit $mom_feed_stepover_unit] } {
      MOM_output_to_listing_device "WARNING: Stepover and Cut feed rate unit are different in $mom_operation_name!"
      MOM_output_to_listing_device "         In CYCLE95, FF2 will be as same as FF1!"

      set mom_feed_stepover_value $mom_feed_cut_value
   }

   if { [EQ_is_zero $mom_feed_stepover_value] } {
      set mom_feed_stepover_value $mom_feed_cut_value
   }

   if { [info exists mom_feedrate_profile_cut] } {
      if { $mom_feedrate_profile_cut_unit == 4 } {
         set mom_feedrate_profile_cut [expr $mom_feed_cut_value*$mom_feedrate_profile_cut/100]
      } elseif { ($mom_feedrate_profile_cut_unit == 1 && ![string match "*pm" $mom_feed_cut_unit]) ||\
                 ($mom_feedrate_profile_cut_unit == 2 && ![string match "*pr" $mom_feed_cut_unit]) } {
         MOM_output_to_listing_device "WARNING: Profile cut and Cut feed rate unit are different in $mom_operation_name!"
         MOM_output_to_listing_device "         In CYCLE95, FF3 will be as same as FF1!"

         set mom_feedrate_profile_cut $mom_feed_cut_value
      } else {
         if { [EQ_is_zero $mom_feedrate_profile_cut] } {
            set mom_feedrate_profile_cut $mom_feed_cut_value
         }
      }
   }

   # Convert feed rate unit
   global mom_kin_output_unit mom_part_unit

   if { ![string compare $mom_kin_output_unit $mom_part_unit] } {
      set mom_sys_unit_conversion "1.0"
   } elseif { ![string compare "IN" $mom_kin_output_unit] } {
      set mom_sys_unit_conversion [expr 1.0/25.4]
   } else {
      set mom_sys_unit_conversion 25.4
   }
   set mom_feed_cut_value [expr $mom_sys_unit_conversion*$mom_feed_cut_value]
   set mom_feed_stepover_value [expr $mom_sys_unit_conversion*$mom_feed_stepover_value]
   if { [info exists mom_feedrate_profile_cut] } {
      set mom_feedrate_profile_cut  [expr $mom_sys_unit_conversion*$mom_feedrate_profile_cut]
   }

  # DT-dwell time
   if { $mom_local_return_dwell_flag == 0 } {
      set mom_local_return_dwell 0
   } else {
      if { $mom_local_return_dwell_unit == 1 } {
         MOM_output_to_listing_device "WARNING: Local return dwell unit should be SECONDS in $mom_operation_name."
         MOM_output_to_listing_device "         DT value in CYCLE95 is the revolution value."
      }
   }

  # DAM
   if { [info exists mom_local_return_status] && $mom_local_return_status > 0 } {
      set mom_siemens_cycle_dam $mom_local_return_distance
   } else {
      set mom_siemens_cycle_dam 0
   }

}


#=============================================================
proc PB_CMD_map_cycle97_param { } {
#=============================================================
# This command is used to map cycle97 parameters.
# Under machine control cycle output condition, MOM_load_lathe_thread_cycle_params will return 1
# if it is executed properly. It will load cycle97 thread related MOM variables
# mom_lathe_thread_crest_line_start mom_lathe_thread_root_line_start
# mom_lathe_thread_crest_line_end mom_lathe_thread_clearance_start
# mom_lathe_thread_root_line_end  mom_lathe_thread_clearance_end
# MOM_skip_handler_to_event cycle_off is used to skip events between current event
# to MOM_cycle_off.
  global mom_turn_cycle97_machining_type
  global mom_turn_cycle_total_depth
  global mom_lathe_thread_crest_line_start mom_lathe_thread_crest_line_end
  global mom_lathe_thread_root_line_start  mom_lathe_thread_root_line_end
  global mom_lathe_thread_clearance_start mom_lathe_thread_clearance_end
  global mom_lathe_spindle_axis
  global mom_siemens_cycle_pit
  global mom_turn_thread_pitch_lead
  global mom_number_of_starts
  global mom_siemens_cycle_spl
  global mom_siemens_cycle_fpl
  global mom_siemens_cycle_dm1
  global mom_siemens_cycle_dm2
  global mom_siemens_cycle_fal
  global mom_total_depth_finish_passes_increment
  global mom_total_depth_finish_passes_number_of_passes
  global mom_siemens_cycle_nrc
  global mom_total_depth_constant_increment
  global mom_total_depth_constant_increment_source
  global mom_total_depth_increment_type
  global mom_tool_insert_length
  global mom_siemens_cycle_iang
  global mom_thread_infeed_vector mom_thread_infeed_angle
  global RAD2DEG

  if { [CMD_EXIST MOM_load_lathe_thread_cycle_params] && [MOM_load_lathe_thread_cycle_params] } {
     #++++++++++++++++++++++++++++++++++++++++++++++++++++
     # mom_siemens_cycle_pit -PIT pitch value
     #++++++++++++++++++++++++++++++++++++++++++++++++++++
     set mom_siemens_cycle_pit [expr $mom_turn_thread_pitch_lead/$mom_number_of_starts]

     #++++++++++++++++++++++++++++++++++++++++++++++++++++
     # mom_siemens_cycle_spl -SPL thread start point longitudinal
     # mom_siemens_cycle_fpl -FPL thread end point longitudinal
     # mom_siemens_cycle_dm1 -DM1 thread start point diameter
     # mom_siemens_cycle_dm2 -DM2 thread end point diameter
     #++++++++++++++++++++++++++++++++++++++++++++++++++++
     if {[string match $mom_lathe_spindle_axis "MCSX"]} {
        set mom_siemens_cycle_spl $mom_lathe_thread_crest_line_start(0)
        set mom_siemens_cycle_fpl $mom_lathe_thread_crest_line_end(0)
        set mom_siemens_cycle_dm1 [expr 2*$mom_lathe_thread_crest_line_start(1)]
        set mom_siemens_cycle_dm2 [expr 2*$mom_lathe_thread_crest_line_end(1)]
     } elseif {[string match $mom_lathe_spindle_axis "MCSZ"]} {
        set mom_siemens_cycle_spl $mom_lathe_thread_crest_line_start(2)
        set mom_siemens_cycle_fpl $mom_lathe_thread_crest_line_end(2)
        set mom_siemens_cycle_dm1 [expr 2*$mom_lathe_thread_crest_line_start(0)]
        set mom_siemens_cycle_dm2 [expr 2*$mom_lathe_thread_crest_line_end(0)]
     }

     #++++++++++++++++++++++++++++++++++++++++++++++++++++
     # mom_siemens_cycle_fal -FAL finish allowance
     #++++++++++++++++++++++++++++++++++++++++++++++++++++
     set mom_siemens_cycle_fal 0
     for {set i 0} {$i<100} {incr i} {
       set mom_siemens_cycle_fal [expr $mom_siemens_cycle_fal + $mom_total_depth_finish_passes_increment($i)*$mom_total_depth_finish_passes_number_of_passes($i)]
     }

     #++++++++++++++++++++++++++++++++++++++++++++++++++++
     # mom_siemens_cycle_nrc -NRC roughing cuts number
     #++++++++++++++++++++++++++++++++++++++++++++++++++++
     if {$mom_total_depth_increment_type == 0} {
        if {[info exists mom_total_depth_constant_increment_source]} {
           set constant_depth [expr $mom_tool_insert_length*$mom_total_depth_constant_increment/100]
           global mom_output_unit mom_part_unit
           if {[string compare $mom_output_unit $mom_part_unit]} {
              if {[string compare $mom_part_unit "MM"]} {
                 set constant_depth [expr $constant_depth/25.4]
              } else {
                 set constant_depth [expr $constant_depth*25.4]
              }
           }
        } else {
           set constant_depth $mom_total_depth_constant_increment
        }
        set mom_siemens_cycle_nrc  [expr ceil(($mom_turn_cycle_total_depth- $mom_siemens_cycle_fal)/$constant_depth)]
     } else {
        PAUSE "Thread CYCLE97 should be constant cut depth!"
     }

     # Skip to MOM_cycle_off
     if {[CMD_EXIST MOM_skip_handler_to_event]} {
        MOM_skip_handler_to_event cycle_off
        global thread_cycle_flag
        set thread_cycle_flag 1
     }
  }


}


#=============================================================
proc PB_CMD_move_force_addresses { } {
#=============================================================
  MOM_force once G_motion X Y Z D M_spindle
}


#=============================================================
proc PB_CMD_nurbs_poly { } {
#=============================================================
  global mom_kin_nurbs_output_type
  if { ![string match "SIEMENS_POLY" $mom_kin_nurbs_output_type] } { return }

  global mom_nurbs_point_count
  global mom_nurbs_points
  global mom_nurbs_coefficients
  global mom_nurbs_point_x
  global mom_nurbs_co_efficient_0
  global mom_nurbs_co_efficient_1
  global mom_nurbs_point_y
  global mom_nurbs_co_efficient_3
  global mom_nurbs_co_efficient_4
  global mom_nurbs_point_z
  global mom_nurbs_co_efficient_6
  global mom_nurbs_co_efficient_7

  for { set ii 0 } { $ii < $mom_nurbs_point_count } { incr ii } {
    set poly_output_mode ""
    set xe [expr ($mom_nurbs_points($ii,0) + $mom_nurbs_coefficients($ii,0) + $mom_nurbs_coefficients($ii,1) + $mom_nurbs_coefficients($ii,2))]
    set ye [expr ($mom_nurbs_points($ii,1) + $mom_nurbs_coefficients($ii,3) + $mom_nurbs_coefficients($ii,4) + $mom_nurbs_coefficients($ii,5))]
    set ze [expr ($mom_nurbs_points($ii,2) + $mom_nurbs_coefficients($ii,6) + $mom_nurbs_coefficients($ii,7) + $mom_nurbs_coefficients($ii,8))]
    set mom_nurbs_point_x        $xe
    set mom_nurbs_co_efficient_0 $mom_nurbs_coefficients($ii,1)
    set mom_nurbs_co_efficient_1 $mom_nurbs_coefficients($ii,0)
    set mom_nurbs_point_y        $ye
    set mom_nurbs_co_efficient_3 $mom_nurbs_coefficients($ii,4)
    set mom_nurbs_co_efficient_4 $mom_nurbs_coefficients($ii,3)
    set mom_nurbs_point_z        $ze
    set mom_nurbs_co_efficient_6 $mom_nurbs_coefficients($ii,7)
    set mom_nurbs_co_efficient_7 $mom_nurbs_coefficients($ii,6)
    MOM_do_template nurbs_poly
  }
}


#=============================================================
proc PB_CMD_nurbs_spline { } {
#=============================================================
  global mom_kin_nurbs_output_type
  global mom_nurbs_knot_count
  global mom_nurbs_point_count
  global mom_nurbs_order

  global nurbs_knot_count
  global nurbs_cntrl_count
  global nurbs_precision
  global nurbs_move_flag
  global prev_nurbs_move_flag
  global saved_nurbs_order

  global mom_nurbs_points
  global mom_nurbs_knots
  global point_length
  global last_motion_type

  global mom_prev_pos
  global mom_pos
  global mom_nxt_motion_event mom_current_motion

  global mom_kin_nurbs_output_type
  if { ![string match "BSPLINE" $mom_kin_nurbs_output_type] } { return }

  if {![string match "first_move" $mom_current_motion] && ![string match "MOM_first_move" [MOM_ask_event_type]] } {
     set nurbs_move_flag 1
     if {[info exists prev_nurbs_move_flag] && $prev_nurbs_move_flag == 1} {
        if {[info exists saved_nurbs_order] && $saved_nurbs_order == $mom_nurbs_order} {
           set nurbs_move_flag 2
        }
     }
  } else {
     set nurbs_move_flag 0
     set saved_nurbs_order 0
  }

  if {[info exists mom_nxt_motion_event] && [string match "*nurbs*" $mom_nxt_motion_event]} {
     set prev_nurbs_move_flag 1
  } else {
     set prev_nurbs_move_flag 0
  }

if {1} {
# change nurbs move with degree 1 to linear move
 if {$mom_nurbs_order == 2} {
     if {$nurbs_move_flag == 0} {
         set start_count 0
     } else {
         set start_count 1
     }
     for {set i $start_count} {$i< $mom_nurbs_point_count} {incr i} {
         set mom_pos(0) $mom_nurbs_points($i,0)
         set mom_pos(1) $mom_nurbs_points($i,1)
         set mom_pos(2) $mom_nurbs_points($i,2)
         MOM_linear_move
     }
     set prev_nurbs_move_flag 0
     set saved_nurbs_order 2
     MOM_abort_event
 }
}
  set nurbs_knot_count 2
  MOM_force ALWAYS PL
  MOM_force once G_motion

  for { set nurbs_cntrl_count 0 } { $nurbs_cntrl_count < $mom_nurbs_point_count } { incr nurbs_cntrl_count } {
    # caculate knots vector difference
    set nurbs_knot_count_saved [expr $nurbs_knot_count - 1 ]
    set point_length [expr $mom_nurbs_knots($nurbs_knot_count)-$mom_nurbs_knots($nurbs_knot_count_saved)]

        if { $nurbs_move_flag == 0 && $nurbs_cntrl_count == 0 } {
             MOM_do_template nurbs_bspline_start
             #MOM_add_to_block_buffer nurbs_bspline start [MOM_do_template nurbs_start CREATE]
             MOM_suppress Once SD
        } elseif { $nurbs_move_flag != 0 && $nurbs_cntrl_count == 0 } {
         # suppress first contrl point
           MOM_suppress once X Y Z PL SD F
           MOM_do_template nurbs_bspline
    } else {
        # output BSPLINE and SD keywords with second control point
           if { $nurbs_move_flag != 2 && $nurbs_cntrl_count == 1} {
               MOM_force once SD
           }
    #   MOM_force once X Y Z
           MOM_do_template nurbs_bspline
    }

        set nurbs_knot_count [expr $nurbs_knot_count + 1]
  }

  set saved_nurbs_order $mom_nurbs_order

  set nurbs_count [expr $mom_nurbs_point_count -1]
  for { set i 0 } { $i < 3 } { incr i } {
      set mom_prev_pos($i) $mom_nurbs_points($nurbs_count,$i)
      set mom_pos($i) $mom_nurbs_points($nurbs_count,$i)
  }
  MOM_reload_variable -a mom_prev_pos
  MOM_reload_variable -a mom_pos
}


#=============================================================
proc PB_CMD_output_5axis { } {
#=============================================================
#This command is used to output tool tip position independent with machinme kinematics(TRAORI)
#This command must be placed in PB_CMD_before_motion.
   global mom_siemens_coord_rotation mom_siemens_5axis_output_mode
   global mom_mcs_goto mom_pos mom_tool_axis
   global mom_prev_mcs_goto mom_prev_pos
   global mom_arc_center mom_pos_arc_center
   global mcs_contact_point mcs_contact_normal
   global mom_kin_machine_type
   global mom_cutcom_mode mom_cutcom_status mom_cutcom_plane
   global mom_contact_point mom_contact_center mom_contact_normal
   global mom_contact_status
   global cycle_init_flag
   global mom_current_motion mom_motion_type
   global mom_cycle_rapid_to mom_cycle_retract_to mom_cycle_feed_to
   global mom_siemens_ori_coord mom_init_pos mom_out_angle_pos
   global mom_cycle_rapid_to_pos mom_cycle_retract_to_pos mom_cycle_feed_to_pos
   global mom_cycle_spindle_axis
   global mom_coordinate_output_mode

   if {![info exists mom_siemens_coord_rotation]} {
      set mom_siemens_coord_rotation 0
   }
   if {![info exists mom_siemens_5axis_output_mode]} {
      set mom_siemens_5axis_output_mode 0
   }
   if {$mom_siemens_coord_rotation == 2} {
return
   }
   if {$mom_siemens_5axis_output_mode != 0 || ([info exists mom_coordinate_output_mode] && $mom_coordinate_output_mode == "TRANSMIT")} {
      VMOV 3 mom_mcs_goto mom_pos
      VMOV 3 mom_prev_mcs_goto mom_prev_pos
      VMOV 3 mom_arc_center mom_pos_arc_center

      if {[info exists cycle_init_flag] && $cycle_init_flag == "TRUE"} {
         if { [string match "initial_move" $mom_current_motion]} {
            set mom_pos(0) [expr $mom_pos(0) + $mom_cycle_rapid_to*$mom_tool_axis(0)]
            set mom_pos(1) [expr $mom_pos(1) + $mom_cycle_rapid_to*$mom_tool_axis(1)]
            set mom_pos(2) [expr $mom_pos(2) + $mom_cycle_rapid_to*$mom_tool_axis(2)]
         }
      }

      if {[string match "CYCLE" $mom_motion_type] && [string compare "cycle_plane_change" $mom_current_motion]} {
         if {$mom_siemens_coord_rotation == 1} {set mom_cycle_spindle_axis 2}
         if {![string match "first_move" $mom_current_motion] && ![string match "initial_move" $mom_current_motion]} {
            set mom_cycle_rapid_to_pos($mom_cycle_spindle_axis) [expr $mom_pos($mom_cycle_spindle_axis)+$mom_cycle_rapid_to]
            set mom_cycle_retract_to_pos($mom_cycle_spindle_axis) [expr $mom_pos($mom_cycle_spindle_axis)+$mom_cycle_retract_to]
            set mom_cycle_feed_to_pos($mom_cycle_spindle_axis) [expr $mom_pos($mom_cycle_spindle_axis)+$mom_cycle_feed_to]
         }
      }

      if {[info exists mom_contact_status] && $mom_contact_status == "ON"} {
         if {[info exists mcs_contact_normal] && [info exists mom_contact_normal]} {
                VMOV 3 mcs_contact_normal mom_contact_normal
         }
         if {[info exists mom_contact_point]} {
            MCS_VECTOR mom_contact_point mcs_contact_point
            VMOV 3 mcs_contact_point mom_pos
         }
      }
   }
}


#=============================================================
proc PB_CMD_output_Sinumerik_setting { } {
#=============================================================
# This command is used to output Sinumerik 840D high speed machining and 5 axis codes.
  global mom_siemens_5axis_output_mode
  global mom_siemens_coord_rotation
  global mom_5axis_control_mode
  global mom_oper_method
  global mom_kin_machine_type
  global sinumerik_version
  global mom_operation_type
  global mom_siemens_method
  global mom_siemens_tol_status
  global mom_siemens_tol
  global mom_siemens_smoothing
  global mom_siemens_compressor
  global mom_siemens_feedforward
  global mom_siemens_5axis_mode
  global mom_siemens_ori_coord
  global mom_siemens_ori_inter
  global mom_siemens_ori_def
  global mom_siemens_milling_setting
  global mom_kin_4th_axis_leader
  global mom_kin_5th_axis_leader
  global mom_tool_axis_type
  global mom_warning_info mom_operation_name
  global mom_siemens_5axis_output
  global mom_machine_mode

  if {[string compare $mom_machine_mode "MILL"]} {
return
  }

  global mom_kin_arc_output_mode save_mom_kin_arc_output_mode
  global mom_kin_helical_arc_output_mode save_mom_kin_helical_arc_output_mode
  if {[info exists mom_siemens_compressor] && $mom_siemens_compressor != "COMPOF"} {
     if {![info exists save_mom_kin_arc_output_mode]} {
        set save_mom_kin_arc_output_mode $mom_kin_arc_output_mode
        set save_mom_kin_helical_arc_output_mode $mom_kin_helical_arc_output_mode
     }
     set mom_kin_arc_output_mode "LINEAR"
     set mom_kin_helical_arc_output_mode "LINEAR"
     MOM_reload_kinematics
  }


  global mom_cutmthd_libref
  global mom_siemens_cycle832_method
  if {[info exists mom_cutmthd_libref]} {
     switch $mom_cutmthd_libref {
        OPD0_00021 { set mom_siemens_method "ROUGHING"}
        OPD0_00022 { set mom_siemens_method "ROUGH-FINISHING"}
        OPD0_00023 { set mom_siemens_method "FINISHING"}
        default    { set mom_siemens_method "DESELECTION"}
     }
  } else {
     set mom_siemens_method "DESELECTION"
  }

    global mom_coordinate_output_mode
    global mom_siemens_transmit_mode

  if {[info exist mom_siemens_transmit_mode] && $mom_siemens_transmit_mode == "ON"} {
  } else {

# If tolerance is redefined in UDE, output again as User Defined
  if {![info exists mom_siemens_tol_status]} {
     set mom_siemens_tol_status "System"
  }
  if {![string match "System" $mom_siemens_tol_status] && [info exists mom_siemens_tol] } {
     set tol [format "%.6f" $mom_siemens_tol]
     MOM_output_literal "_camtolerance=$tol  ;  User Defined"

     # For Sinumerik version 5, output compressor tolerence
     if {[info exists sinumerik_version] && [string match "V5" $sinumerik_version]} {
        PB_CMD_output_V5_compressor_tol
     }
  }

 # Output High Speed Machining codes
  if {[info exists sinumerik_version] && [string match "V5" $sinumerik_version]} {
     MOM_output_literal "$mom_siemens_5axis_output"
     MOM_force once G_offset
     MOM_do_template fixture_offset

     MOM_output_literal "$mom_siemens_feedforward"
     MOM_output_literal "UPATH"
     MOM_output_literal "SOFT"

     if {![string match "Point to Point" $mom_operation_type] && ![string match "Hole Making" $mom_operation_type] && \
         ![string match "Drilling" $mom_operation_type]} {
        MOM_output_literal "$mom_siemens_compressor"
        MOM_output_literal "$mom_siemens_smoothing"
     }  else {
        MOM_output_literal "G60"
     }

  } elseif {[info exists sinumerik_version] && [string match "V6" $sinumerik_version]} {
     set list5 {COMPOF COMPCAD COMPCURV BSPLINE}
     set list4 {FFWOF FFWON BRISK}
     set list3 {G64 G641 G642}
     set list2 {TRAFOOF TRAORI TRAORI2}
     set list0 {DESELECTION FINISHING ROUGH-FINISHING ROUGHING}
     set tolm 0
     set i 0

     foreach b5 $list5 b4 $list4 b3 $list3 b2 $list2 b0 $list0 {
        if {[string match $b5 $mom_siemens_compressor]} {
           set tolm [expr $tolm+$i*100000]
        }
        if {[string match $b4 $mom_siemens_feedforward]} {
           set tolm [expr $tolm+$i*10000]
        }
        if {[string match $b3 $mom_siemens_smoothing]} {
           set tolm [expr $tolm+$i*1000]
        }
        if {[string match $b2 $mom_siemens_5axis_output]} {
           set tolm [expr $tolm+$i*100]
        }
        if {[string match $b0 $mom_siemens_method]} {
           set tolm [expr $tolm+$i]
        }
        incr i
     }

     global cycle832_tolm
     set cycle832_tolm $tolm
     if {![string match "Point to Point" $mom_operation_type] && ![string match "Hole Making" $mom_operation_type] && \
         ![string match "Drilling" $mom_operation_type]} {
        PB_call_macro CYCLE832
     }  else {
        MOM_output_literal "G60"
     }

     MOM_output_literal "$mom_siemens_5axis_output"
     MOM_force once G_offset
     MOM_do_template fixture_offset

  } elseif {[info exists sinumerik_version] && [string match "V7" $sinumerik_version]} {
     if {![string match "Point to Point" $mom_operation_type] && ![string match "Hole Making" $mom_operation_type] && \
         ![string match "Drilling" $mom_operation_type]} {
        global cycle832_tolm
        switch $mom_siemens_method {
           "ROUGHING"        { set cycle832_tolm 3}
           "ROUGH-FINISHING" { set cycle832_tolm 2}
           "FINISHING"       { set cycle832_tolm 1}
           default           { set cycle832_tolm 0}
        }
   #     PB_call_macro CYCLE832_v7
        if {[info exists mom_siemens_smoothing] && [string match "G60" $mom_siemens_smoothing]} {
         #  MOM_output_to_listing_device "Warning in $mom_operation_name: User defined smoothing off is conflict with controller default setting in CYCLE832."
         #  MOM_output_to_listing_device "$mom_siemens_smoothing will be output with CYCLE832."
           MOM_output_literal "$mom_siemens_smoothing"
        }
        if {[info exists mom_siemens_feedforward] && [string compare "FFWON" $mom_siemens_feedforward]} {
          # MOM_output_to_listing_device "Warning in $mom_operation_name: User defined feed forward off is conflict with controller default setting in CYCLE832."
          # MOM_output_to_listing_device "$mom_siemens_feedforward will be output with CYCLE832."
           MOM_output_literal "$mom_siemens_feedforward"
        }
        if {[info exists mom_siemens_compressor] && [string compare "COMPCAD" $mom_siemens_compressor]} {
         #  MOM_output_to_listing_device "Warning in $mom_operation_name: User defined compressor off is conflict with controller default setting in CYCLE832."
         #  MOM_output_to_listing_device "$mom_siemens_compressor will be output with CYCLE832."
           MOM_output_literal "$mom_siemens_compressor"
        }
     } else {
        MOM_output_literal "G60"
     }

     MOM_output_literal "$mom_siemens_5axis_output"
     MOM_force once G_offset
     MOM_do_template fixture_offset
     if {  [info exists mom_siemens_ori_def] && ![string match "*ROTARY*" $mom_siemens_ori_def] } {
        PB_call_macro ORIRESET
     }
 }

 # Output 5 axis orientation coordinate and interpolation mode
  if {![string match "3_axis_mill*" $mom_kin_machine_type] && [string match "TRAORI*" $mom_siemens_5axis_mode]} {
     MOM_output_literal ";"
     if {[info exists mom_siemens_ori_coord]} {
        MOM_output_literal "$mom_siemens_ori_coord"
     }
     if {[info exists mom_siemens_ori_inter]} {
        MOM_output_literal "$mom_siemens_ori_inter"
     }
  }
}
}


#=============================================================
proc PB_CMD_output_V5_Sinumerik_setting { } {
#=============================================================
# This command is used to output Sinumerik 840D high speed machining when sinumerik_version is V5.
#
# It is called in MOM_initial_move and MOM_first_move.
#
# 23-Dec-2016 shuai - CYCLE832 enhancement.
#

  global sinumerik_version

  if {![info exists sinumerik_version] || [string compare "V5" $sinumerik_version] } {

     return
  }


  global mom_siemens_tol
  global mom_siemens_tol_status

  # If tolerance is redefined in UDE, output again as User Defined.
  if {![info exists mom_siemens_tol_status] } {
     set mom_siemens_tol_status "System"
  }

  if {![string match "System" $mom_siemens_tol_status] && [info exists mom_siemens_tol] } {

     set tol [format "%.6f" $mom_siemens_tol]
     MOM_output_literal "_camtolerance=$tol  ;  User Defined"

     # For Sinumerik version 5, output compressor tolerence.
     PB_CMD_output_V5_compressor_tol
  }

  # Output High Speed Machining codes.
  global mom_operation_type
  global mom_siemens_feedforward
  global mom_siemens_compressor
  global mom_siemens_smoothing

  MOM_output_literal "$mom_siemens_feedforward"
  MOM_output_literal "UPATH"
  MOM_output_literal "SOFT"

  if {[string compare "Point to Point" $mom_operation_type] && \
      [string compare "Hole Making" $mom_operation_type] && \
      [string compare "Drilling" $mom_operation_type]} {

     MOM_output_literal "$mom_siemens_compressor"
     MOM_output_literal "$mom_siemens_smoothing"

  } else {

     MOM_output_literal "G60"
  }

}


#=============================================================
proc PB_CMD_output_V5_compressor_tol { } {
#=============================================================
# This command is used to output compressor tolerance setting for Sinumerik 840D SW Version 5.
#
# 23-Dec-2016 shuai - CYCLE832 enhancement.
#

  global sinumerik_version

  if {![info exists sinumerik_version] || [string compare "V5" $sinumerik_version] } {

     return
  }


  global mom_kin_machine_type
  global mom_kin_4th_axis_leader
  global mom_kin_5th_axis_leader

  MOM_output_literal "\$MA_COMPRESS_POS_TOL\[X\] = _camtolerance*1.2"
  MOM_output_literal "\$MA_COMPRESS_POS_TOL\[Y\] = _camtolerance*1.2"
  MOM_output_literal "\$MA_COMPRESS_POS_TOL\[Z\] = _camtolerance*1.2"

  if {![string match "3_axis_mill" $mom_kin_machine_type] } {
     MOM_output_literal "\$MA_COMPRESS_POS_TOL\[$mom_kin_4th_axis_leader\] = _camtolerance*12"
  }

  if {[string match "*5*" $mom_kin_machine_type]} {
     MOM_output_literal "\$MA_COMPRESS_POS_TOL\[$mom_kin_5th_axis_leader\] = _camtolerance*12"
  }

  MOM_output_literal "NEWCONF"

}


#=============================================================
proc PB_CMD_output_V5_sinumerik_reset { } {
#=============================================================
# This command is used to output codes at end of path for sinumerik 840D when sinumerik version is V5.
#
# 23-Dec-2016 shuai - CYCLE832 enhancement.
#

  global sinumerik_version

  if {![info exists sinumerik_version] || [string compare "V5" $sinumerik_version] } {

     return
  }


  MOM_output_literal ";"
  MOM_output_literal "FFWOF"
  MOM_output_literal "UPATH"
  MOM_output_literal "SOFT"
  MOM_output_literal "COMPOF"
  MOM_output_literal "G64"

}


#=============================================================
proc PB_CMD_output_coord_rotation { } {
#=============================================================
# This custom command is used to output coordinate rotation codes.
# This command is used with PB_CMD_set_csys to output cycle800.
#
  global sinumerik_version
  global mom_operation_type
  global mom_kin_coordinate_system_type
  global mom_out_angle_pos
  global mom_siemens_coord_rotation mom_siemens_5axis_output_mode
  global coord_ref_x coord_ref_y coord_ref_z
  global coord_ang_A coord_ang_B coord_ang_C
  global coord_ang_1 coord_ang_2 coord_ang_3
  global coord_offset
  global cycle800_inc_retract
  global cycle800_tc cycle800_dir
  global cycle800_st cycle800_mode
  global mom_siemens_5axis_mode
  global mom_kin_machine_type
  global mom_siemens_ori_def
  global mom_siemens_ori_inter
  global rot_angle_pos mom_init_pos
  global mom_rotary_direction_4th mom_rotary_direction_5th
  global mom_pos mom_alt_pos mom_out_angle_pos
  global mom_siemens_ori_coord
  global mom_kin_machine_type
  global mom_kin_4th_axis_type
  global mom_kin_5th_axis_type
  global mom_tool_axis_type
  global mom_operation_name
  global mom_tool_axis

  if { [string match "3_axis_mill" $mom_kin_machine_type] } {
return
  }

#-----------------------------------------------------------
#Please set your swivel data record
#-----------------------------------------------------------
  set cycle800_tc "\"R_DATA\"" ;# For example,please put your data here

#-----------------------------------------------------------
#Please set your incremental retraction
#-----------------------------------------------------------
  set cycle800_inc_retract "1"

#-----------------------------------------------------------

  if { ![info exists mom_siemens_coord_rotation] } {
     set mom_siemens_coord_rotation 0
  }

  if { $mom_siemens_coord_rotation == 0 } {
     if { [array exists coord_offset] } {
        if { ![EQ_is_zero $coord_offset(0)] || ![EQ_is_zero $coord_offset(1)] || ![EQ_is_zero $coord_offset(2)] } {
           MOM_force once X Y Z
           MOM_do_template frame_trans
           global coord_offset_flag
           set coord_offset_flag 1
        }
     }
  } else {
  # Local csys rotation is setting
     if { $mom_siemens_coord_rotation == 1 } {
        if { ![EQ_is_equal $mom_tool_axis(2) 1.0] } {
            MOM_output_to_listing_device \
              "Warning in $mom_operation_name: Wrong Local MCS, Z axis is not parallel to tool axis vector."
        }
     }

    # Output TRANS and AROT
     if { ![string match "SWIVELING" $mom_siemens_5axis_mode] } {
        if { [array exists coord_offset] } {
           if { ![EQ_is_zero $coord_offset(0)] || ![EQ_is_zero $coord_offset(1)] || ![EQ_is_zero $coord_offset(2)] } {
              MOM_force once X Y Z
              MOM_do_template frame_trans
           }
        }
        if { ![EQ_is_zero $coord_ang_A] } {
           MOM_do_template frame_arot_x
        }
        if { ![EQ_is_zero $coord_ang_B] } {
           MOM_do_template frame_arot_y
        }
        if { ![EQ_is_zero $coord_ang_C] } {
           MOM_do_template frame_arot_z
        }

        # Switch rotary angles reference coordinate
        if { ![info exists mom_tool_axis_type] } {
           set mom_tool_axis_type 0
        }

        if { [string match "*ROTARY*" $mom_siemens_ori_def] &&\
             (($mom_tool_axis_type >=2 && [string match "Variable-axis *" $mom_operation_type ]) ||\
             [string match "Sequential Mill Main Operation" $mom_operation_type]) } {

           if { [string match "ORIMKS" $mom_siemens_ori_coord] } {
              if { [string match "*dual_head*" $mom_kin_machine_type] || [string match "*dual_table*" $mom_kin_machine_type] } {
                 if { $mom_siemens_5axis_output_mode == 1 } {
                    global save_mom_kin_machine_type
                    set save_mom_kin_machine_type  $mom_kin_machine_type
                    set mom_pos(3) $mom_init_pos(3)
                    set mom_pos(4) $mom_init_pos(4)
                    MOM_reload_variable -a mom_pos
                    set mom_kin_machine_type "5_axis_head_table"
                 } else {
                    global mom_warning_info
                    set mom_warning_info "$mom_operation_name: Wrong rotary axes with respect to Machine Coordinate.Switch to ORIWKS."
                    MOM_catch_warning
                    MOM_output_literal "ORIWKS"
                 }
              }
           } else {
              if { [string match "*head_table*" $mom_kin_machine_type] } {
                 if { $mom_siemens_5axis_output_mode == 1 } {
                    global save_mom_kin_machine_type
                    set save_mom_kin_machine_type  $mom_kin_machine_type
                    set mom_pos(3) $mom_init_pos(3)
                    set mom_pos(4) $mom_init_pos(4)
                    MOM_reload_variable -a mom_pos
                    set mom_kin_machine_type "5_axis_dual_table"
                 } else {
                    global mom_warning_info
                    set mom_warning_info "$mom_operation_name:Wrong rotary axes with respect to Workpiece Coordinate.Switch to ORIMKS."
                    MOM_catch_warning
                    MOM_output_literal "ORIMKS"
                 }
              }
           }
        }
     } else {
     # Output CYCLE800
        set cycle800_dir $mom_rotary_direction_4th
        set cycle800_st 0
        set cycle800_mode 57
        set coord_ang_1 $coord_ang_A
        set coord_ang_2 $coord_ang_B
        set coord_ang_3 $coord_ang_C
        PB_call_macro CYCLE800
     }
  }
}


#=============================================================
proc PB_CMD_output_cutcom_mode { } {
#=============================================================
#This command is used to detect cutcome mode.
  global mom_operation_type
  global mom_tool_axis
  global mom_contact_status
  global mom_cutter_data_output_indicator
  global mom_tool_tracking_type
  global mom_contact_normal
  global mom_drive_method
  global mom_automatic_wall_selection
  global mom_kin_machine_type
  global mom_siemens_3Dcutcom_mode
  global mom_siemens_coord_rotation
  global mom_siemens_5axis_output_mode
  global mom_tool_taper_angle


  if { [info exists mom_siemens_3Dcutcom_mode] && [string match "OFF" $mom_siemens_3Dcutcom_mode] } {
     if { [info exists mom_cutter_data_output_indicator] && $mom_cutter_data_output_indicator == 2 } {
      # 3axis machine
      if { [string match "3_axis_mill" $mom_kin_machine_type] } {
         MOM_output_literal "CUT3DFF"
         set mom_siemens_3Dcutcom_mode "3DFF"
      # 5axis machine
      } else {
           if { ![info exists mom_tool_taper_angle] } {
              set mom_tool_taper_angle 0.0
           }
           # check tool taper angle, CUT3DC cannot work with taper tool
           if { [EQ_is_zero $mom_tool_taper_angle] && [info exists mom_drive_method] && $mom_drive_method == 120 &&  [info exists mom_automatic_wall_selection] && [string match "No" $mom_automatic_wall_selection] } {
            MOM_output_literal "CUT3DC"
            set mom_siemens_3Dcutcom_mode "3DC"
         } elseif { $mom_siemens_coord_rotation != 0 } { ;#CYCLE800
            MOM_output_literal "CUT3DFF"
            set mom_siemens_3Dcutcom_mode "3DFF"
         } else {
            MOM_output_literal "CUT3DF"
            set mom_siemens_3Dcutcom_mode "3DF"
         }
      }
      # Move below command to PB_CMD_before_motion
      # PB_CMD_cutcom_mode
     } elseif { [info exists mom_cutter_data_output_indicator] && $mom_cutter_data_output_indicator == 1 } {

      if { $mom_siemens_5axis_output_mode == 1 } {
         MOM_output_literal "CUT3DC"
         set mom_siemens_3Dcutcom_mode "3DC_3axis"
      #Cutcom 2&1/2
      } else {
         MOM_output_literal "CUT2DF"
         set mom_siemens_3Dcutcom_mode "2DF"
      }
   }
}
}


#=============================================================
proc PB_CMD_output_cycle95_contour_file { } {
#=============================================================
   global cycle95_contour_file

   if { [info exist cycle95_contour_file] } {

      MOM_output_text " "

      foreach line $cycle95_contour_file {
         MOM_output_literal $line
      }

      MOM_output_literal "M30"
   }
}


#=============================================================
proc PB_CMD_output_diameter_mode { } {
#=============================================================
  global mom_channel_id
  global mom_machine_mode
  global mom_sys_lathe_x_double

  if {$mom_sys_lathe_x_double == 1} {
       MOM_output_literal "DIAMOF"
  } elseif {$mom_sys_lathe_x_double == 2} {
       MOM_output_literal "DIAMON"
  }



}


#=============================================================
proc PB_CMD_output_feedrate_def { } {
#=============================================================
#This command is used to generate feedrate variables in NC code.
#This command must be placed in the End of Program.
  global ptp_file_name
  global group_output_file
  global mom_group_name
  global mom_sys_ptp_output
  global mom_output_file_directory
  global mom_output_file_basename
  global output_extn
  global mom_sequence_number
  global mom_sequence_increment
  global mom_sequence_frequency
  global mom_siemens_feed_var_num
  global mom_siemens_feed_value
  global mom_siemens_feed_definition
  global feed_definition
  global mom_siemens_program_control
  global mom_sys_in_operation
  global feedrate_file_name

  #In case group output is generated
  if { [info exists mom_group_name] } {
     if { [info exists group_output_file($mom_group_name)] } {
        set feedrate_file_name $group_output_file($mom_group_name)
        PB_CMD_output_feedrate_variables
return
     }
  }

  #Output feedrate variable definitions to NC code file
  if { [info exists ptp_file_name] } {
     set feedrate_file_name $ptp_file_name
     PB_CMD_output_feedrate_variables
  }

  set mom_siemens_feed_definition "OFF"
}


#=============================================================
proc PB_CMD_output_feedrate_variables { } {
#=============================================================
# This command is used to define feedrate variables in NC files.
# This command is called by PB_CMD_feedrate_def and PB_CMD_end_of_extcall_operation.
  global feedrate_file_name
  global mom_sys_ptp_output
  global mom_sequence_number
  global mom_sequence_increment
  global mom_sequence_frequency
  global mom_siemens_feed_var_num
  global mom_siemens_feed_value
  global mom_siemens_feed_definition
  global feed_definition
  global mom_siemens_program_control
  global mom_sys_in_operation
  global mom_sys_leader
  global mom_sys_control_out
  global mom_siemens_feed_block_num
  global mom_siemens_feed_block
  global mom_siemens_feed_output_seqnum

  #feed_definition is set in PB_CMD_define_feedrate_format.
  if {![info exists feed_definition]} {
return
  } else {
     unset feed_definition
  }

  if {$mom_sys_ptp_output != "ON" && ![file exists $feedrate_file_name]} {
return
  }

  MOM_close_output_file $feedrate_file_name
  set ncfile [open $feedrate_file_name r]
  set i 0
  foreach line [split [read $ncfile] \n] {
     set fileline($i) $line
     incr i
  }
  set line_num $i
  close $ncfile
  MOM_remove_file $feedrate_file_name
  MOM_open_output_file  $feedrate_file_name

  set j 1
  for {set i 0} {$i<$line_num} {incr i} {
     if {[string match "$mom_sys_leader(N)$mom_siemens_feed_output_seqnum($j) ;" $fileline($i)]} {
        MOM_output_text "$mom_sys_leader(N)$mom_siemens_feed_output_seqnum($j) $mom_siemens_feed_block($j)"
     } elseif {[string match "*$mom_siemens_feed_block($j)" $fileline($i)]} {
        regsub $mom_siemens_feed_block($j) $fileline($i) ";" outline
        MOM_output_text "$outline"
        if {$j < $mom_siemens_feed_block_num} {
           incr j
        }
     } else {
        MOM_output_text $fileline($i)
     }
  }
}


#=============================================================
proc PB_CMD_output_mill_subprogram { } {
#=============================================================
 global mom_channel_id

 if {[info exists mom_channel_id] && $mom_channel_id==1} {
    MOM_output_literal "MILL_UPPER"
 } elseif {[info exists mom_channel_id] && $mom_channel_id==2} {
    MOM_output_literal "MILL_LOWER"
 }
}


#=============================================================
proc PB_CMD_output_motion_message { } {
#=============================================================
# This command is used to output motion type before movements.
 global mom_motion_type
 global mom_siemens_pre_motion
  global mom_machine_mode

  if {[string compare $mom_machine_mode "MILL"]} {
return
  }

 if { ![info exists mom_siemens_pre_motion] || ![info exists mom_motion_type] } {
return
 }
 if { ![string match $mom_motion_type $mom_siemens_pre_motion] } {
    switch $mom_motion_type {
      "FIRSTCUT" -
      "STEPOVER" -
      "CUT" {
         if { ![string match "FIRSTCUT" $mom_siemens_pre_motion] && ![string match "CUT" $mom_siemens_pre_motion] && ![string match "STEPOVER" $mom_siemens_pre_motion] } {
            MOM_output_literal ";Cutting"
         }
         set mom_siemens_pre_motion $mom_motion_type
      }
      default {
         set motion_type_first [string toupper [string index $mom_motion_type 0]]
         set motion_type_end [string tolower [string range $mom_motion_type 1 end]]
         set motion_type $motion_type_first$motion_type_end
         MOM_output_literal ";$motion_type Move"
         set mom_siemens_pre_motion $mom_motion_type
      }
    }
 }
}


#=============================================================
proc PB_CMD_output_start_path { } {
#=============================================================
# This command is used to output tool, method, tolerance and stock info from CAM operations.
#

  global mom_oper_method
  global mom_tool_name
  global mom_tool_type
  global mom_tool_diameter
  global mom_tool_length
  global mom_tool_corner1_radius
  global mom_inside_outside_tolerances
  global mom_stock_part
  global mom_seqnum
  global sinumerik_version
  global mom_group_name
  global mom_prev_group_name
  global mom_operation_name
  global mom_siemens_milling_setting
  global mom_siemens_feed_definition
  global mom_siemens_feed_output_block
  global mom_kin_machine_type
  global mom_kin_4th_axis_leader
  global mom_kin_5th_axis_leader

  if {![info exists mom_siemens_milling_setting] } {
     set mom_siemens_milling_setting "Default"
  }

  if {[info exists mom_prev_group_name] && [string match "*$mom_prev_group_name" $mom_siemens_milling_setting]} {

     if {[info exists mom_group_name] && ![string match $mom_group_name $mom_prev_group_name]} {

        set mom_siemens_feed_definition "OFF"
        set mom_siemens_milling_setting "Default"

        if {[CMD_EXIST "PB_CMD_set_Sinumerik_default_setting"]} {
           PB_CMD_set_Sinumerik_default_setting
        }
     }
  }

  MOM_output_literal ";"

  if {[info exists mom_oper_method]} {
     MOM_output_literal ";TECHNOLOGY: $mom_oper_method"
  }

  if {[info exists mom_tool_name]} {
     MOM_output_literal ";TOOL NAME : $mom_tool_name"
  }

  if {[info exists mom_tool_type]} {
     MOM_output_literal ";TOOL TYPE : $mom_tool_type"
  }

  if {[info exists mom_tool_diameter]} {
     MOM_output_literal ";TOOL DIAMETER     : [format "%.6f" $mom_tool_diameter]"
  }

  if {[info exists mom_tool_length]} {
     MOM_output_literal ";TOOL LENGTH       : [format "%.6f" $mom_tool_length]"
  }

  if {[info exists mom_tool_corner1_radius]} {
     MOM_output_literal ";TOOL CORNER RADIUS: [format "%.6f" $mom_tool_corner1_radius]"
  }

  if {[info exists mom_inside_outside_tolerances] && [info exists mom_stock_part]} {

     set tol [expr $mom_inside_outside_tolerances(0)+$mom_inside_outside_tolerances(1)]
     set tol [format "%.6f" $tol]

     set intol [format "%.6f" $mom_inside_outside_tolerances(0)]
     set outtol [format "%.6f" $mom_inside_outside_tolerances(1)]
     set stock [format "%.6f" $mom_stock_part]

     MOM_output_literal ";"
     MOM_output_literal ";Intol     : $intol"
     MOM_output_literal ";Outtol    : $outtol"
     MOM_output_literal ";Stock     : $stock"

     MOM_output_literal "_camtolerance=$tol"
     MOM_do_template home_position
     MOM_do_template home_position_rotary

     set mom_siemens_feed_output_block [expr int($mom_seqnum)]
     MOM_output_literal ";"

     # For Sinumerik version 5, output compressor tolerance in main program.
     if {[info exists sinumerik_version] && [string match "V5" $sinumerik_version]} {
        PB_CMD_output_V5_compressor_tol
     }
  }

  # Output reference radius of rotary axis.
  if {[info exists sinumerik_version] && ([string match "V5" $sinumerik_version] || [string match "V6" $sinumerik_version])} {

     if {[string match "*4*" $mom_kin_machine_type] || [string match "3_axis_mill_turn" $mom_kin_machine_type]} {
        MOM_output_literal "FGREF\[$mom_kin_4th_axis_leader\]=10"
     }

     if {[string match "*5*" $mom_kin_machine_type]} {
        MOM_output_literal "FGREF\[$mom_kin_4th_axis_leader\]=10 FGREF\[$mom_kin_5th_axis_leader\]=10"
     }
  }

  MOM_output_literal ";"
  MOM_output_literal ";Operation : $mom_operation_name"
  MOM_output_literal ";"

}


#=============================================================
proc PB_CMD_output_start_program { } {
#=============================================================
# This command is used to output start of program NC codes for sinumerik 840D!
#
  global mom_date
  global mom_part_name
  global mom_definition_file_name
  global start_output_flag
  global mom_sys_leader
  global mom_kin_machine_type

  if { ![info exists start_output_flag] || $start_output_flag == 0 } {
     set start_output_flag 1
     MOM_output_literal "DEF REAL _camtolerance"
     MOM_output_literal "DEF REAL _F_CUTTING, _F_ENGAGE, _F_RETRACT"
     MOM_output_literal ";"
     MOM_force Once G_cutcom G_plane G F_control G_stopping G_feed G_unit G_mode
     MOM_do_template start_of_program
  }
}


#=============================================================
proc PB_CMD_output_thread_cycle { } {
#=============================================================
# This command is used to output Sinumerik 840D thread cycle.
   global thread_cycle_flag
   global mom_crest_line_offset

   if { [info exists thread_cycle_flag] && $thread_cycle_flag == 1 } {
      set thread_cycle_flag -1
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
proc PB_CMD_preset_angle { } {
#=============================================================
  global mom_operation_type
  global mom_kin_coordinate_system_type
  global mom_out_angle_pos
  global mom_siemens_5axis_mode
  global mom_kin_machine_type
  global sinumerik_version
  global mom_siemens_ori_def
  global mom_siemens_coord_rotation
  global mom_init_pos
  global mom_sys_leader
  global mom_machine_mode

  if {[string compare $mom_machine_mode "MILL"]} {
return
  }

  if { [string match "3_axis_mill" $mom_kin_machine_type] } {
return
  }

  if { ![info exists mom_siemens_coord_rotation] } {
     set mom_siemens_coord_rotation 0
  }
  if { ![info exists mom_siemens_5axis_mode] } {
     set mom_siemens_5axis_mode TRAFOOF
  }
  if { $mom_siemens_coord_rotation != 0 && [string match "SWIVELING" $mom_siemens_5axis_mode] } {
return
  }

  if { [info exists sinumerik_version] && [string match "V7" $sinumerik_version] && [info exists mom_siemens_ori_def] && ![string match "*ROTARY*" $mom_siemens_ori_def] } {
     if { $mom_siemens_coord_rotation == 1 } {
        if { [info exists mom_init_pos(3)] } {
           set mom_out_angle_pos(0) $mom_init_pos(3)
        }
        if { [info exists mom_init_pos(4)] } {
           set mom_out_angle_pos(1) $mom_init_pos(4)
        }
     }
     PB_call_macro ORIRESET
  } else {
     #for simulation, in case rotary axis limits are reloaded from machine
     global mom_prev_out_angle_pos mom_sys_leader
     global mom_kin_4th_axis_max_limit mom_kin_4th_axis_direction mom_kin_4th_axis_min_limit mom_kin_4th_axis_leader
     global mom_kin_5th_axis_max_limit mom_kin_5th_axis_direction mom_kin_5th_axis_min_limit mom_kin_5th_axis_leader
     MOM_force once fourth_axis fifth_axis
     if { $mom_siemens_coord_rotation == 1 } {
        if { [info exists mom_init_pos(3)] } {
           set mom_out_angle_pos(0) [ROTSET $mom_init_pos(3) $mom_prev_out_angle_pos(0)  $mom_kin_4th_axis_direction  $mom_kin_4th_axis_leader  mom_sys_leader(fourth_axis)  $mom_kin_4th_axis_min_limit  $mom_kin_4th_axis_max_limit]
        }
        if { [info exists mom_init_pos(4)] } {
          set mom_out_angle_pos(1) [ROTSET $mom_init_pos(4) $mom_prev_out_angle_pos(1)  $mom_kin_5th_axis_direction   $mom_kin_5th_axis_leader   mom_sys_leader(fifth_axis)  $mom_kin_5th_axis_min_limit  $mom_kin_5th_axis_max_limit]
        }
     }
     MOM_force Once G_motion fourth_axis fifth_axis
     MOM_do_template rotation_axes
  }
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
return
   if { [info exists mom_kin_iks_usage] && $mom_kin_iks_usage == 1 } {
      if { [info exists mom_csys_matrix] } {
         if { [llength [info commands MOM_validate_machine_model] ] } {
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
proc PB_CMD_reset_Sinumerik_setting { } {
#=============================================================
# This command is used to reset the setting for Sinumerik.
#
# It is called in MOM_end_of_path.
#
# 23-Dec-2016 shuai - CYCLE832 enhancement.
#

  global mom_machine_mode

  if {[string compare $mom_machine_mode "MILL"]} {

     return
  }


  global mom_group_name
  global mom_prev_group_name

  if {[info exists mom_group_name] && $mom_group_name != ""} {
     set mom_prev_group_name $mom_group_name
  }

  global mom_current_oper_is_last_oper_in_program
  global mom_siemens_tol_group
  global mom_siemens_tol_status_group
  global mom_siemens_rotary_tol_group
  global mom_siemens_rotary_tol_status_group
  global mom_siemens_feed_definition
  global mom_siemens_milling_setting

  if {[info exists mom_current_oper_is_last_oper_in_program] && [string match "YES" $mom_current_oper_is_last_oper_in_program]} {

     if {[info exists mom_siemens_tol_group]} {
        unset mom_siemens_tol_group
     }
     if {[info exists mom_siemens_tol_status_group]} {
        unset mom_siemens_tol_status_group
     }

     if {[info exists mom_siemens_rotary_tol_group]} {
        unset mom_siemens_rotary_tol_group
     }
     if {[info exists mom_siemens_rotary_tol_status_group]} {
        unset mom_siemens_rotary_tol_status_group
     }

     set mom_siemens_feed_definition "OFF"
     set mom_siemens_milling_setting "Default"

     if {[llength [info commands PB_CMD_set_Sinumerik_default_setting]]} {
        PB_CMD_set_Sinumerik_default_setting
     }

     return
  }

  global mom_siemens_tol
  global mom_siemens_tol_status
  global mom_siemens_rotary_tol
  global mom_siemens_rotary_tol_status
  global mom_siemens_compressor mom_siemens_compressor_group
  global mom_siemens_smoothing mom_siemens_smoothing_group
  global mom_siemens_feedforward mom_siemens_feedforward_group
  global mom_siemens_top_surface_smooth mom_siemens_top_surface_smooth_group
  global mom_siemens_5axis_mode mom_siemens_5axis_mode_group
  global mom_siemens_ori_coord mom_siemens_ori_coord_group
  global mom_siemens_ori_inter mom_siemens_ori_inter_group
  global mom_siemens_ori_def mom_siemens_ori_def_group
  global mom_siemens_feed_definition_group

  if {[string match "Group*" $mom_siemens_milling_setting]} {

     if {[info exists mom_siemens_tol_group]} {
        set mom_siemens_tol $mom_siemens_tol_group
     }
     if {[info exists mom_siemens_tol_status_group]} {
        set mom_siemens_tol_status $mom_siemens_tol_status_group
     }

     set mom_siemens_compressor $mom_siemens_compressor_group
     set mom_siemens_smoothing $mom_siemens_smoothing_group
     set mom_siemens_feedforward $mom_siemens_feedforward_group
     set mom_siemens_top_surface_smooth $mom_siemens_top_surface_smooth_group
     set mom_siemens_5axis_mode $mom_siemens_5axis_mode_group
     set mom_siemens_ori_coord $mom_siemens_ori_coord_group
     set mom_siemens_ori_inter $mom_siemens_ori_inter_group
     set mom_siemens_ori_def $mom_siemens_ori_def_group
     set mom_siemens_feed_definition $mom_siemens_feed_definition_group

     if {[info exists mom_siemens_rotary_tol_status_group]} {
        set mom_siemens_rotary_tol_status $mom_siemens_rotary_tol_status_group
     }
     if {[info exists mom_siemens_rotary_tol_group]} {
        set mom_siemens_rotary_tol $mom_siemens_rotary_tol_group
     }

     # <lili 2013-06-20> Enhancement for group UDE switch.
     if {[info exists mom_group_name]} {
        set mom_siemens_milling_setting "Group$mom_group_name"
     } else {
        set mom_siemens_milling_setting "Group"
     }

  } else {

     set mom_siemens_feed_definition "OFF"
     set mom_siemens_milling_setting "Default"

     if {[llength [info commands PB_CMD_set_Sinumerik_default_setting]]} {
        PB_CMD_set_Sinumerik_default_setting
     }
  }

}


#=============================================================
proc PB_CMD_reset_all_motion_variables_to_zero { } {
#=============================================================
 # Stage for MOM_reload_kinematics
   global mom_prev_pos
   global mom_pos
   global mom_prev_out_angle_pos
   global mom_out_angle_pos
   global mom_prev_rot_ang_4th
   global mom_prev_rot_ang_5th
   global mom_rotation_angle

   set mom_prev_pos(0) 0.0
   set mom_prev_pos(1) 0.0
   set mom_prev_pos(2) 0.0
   set mom_prev_pos(3) 0.0
   set mom_prev_pos(4) 0.0

   set mom_pos(0) 0.0
   set mom_pos(1) 0.0
   set mom_pos(2) 0.0
   set mom_pos(3) 0.0
   set mom_pos(4) 0.0

    set mom_prev_out_angle_pos(0) 0.0
    set mom_prev_out_angle_pos(1) 0.0

    set mom_out_angle_pos(0) 0.0
    set mom_out_angle_pos(1) 0.0

    set mom_prev_rot_ang_4th 0.0
    set mom_prev_rot_ang_5th 0.0

    set mom_rotation_angle 0.0

    MOM_reload_variable -a mom_prev_pos
    MOM_reload_variable -a mom_pos
    MOM_reload_variable -a mom_prev_out_angle_pos
    MOM_reload_variable -a mom_out_angle_pos
    MOM_reload_variable mom_prev_rot_ang_4th
    MOM_reload_variable mom_prev_rot_ang_5th
    MOM_reload_variable mom_rotation_angle

    MOM_reload_kinematics
}


#=============================================================
proc PB_CMD_reset_control_mode { } {
#=============================================================
#Reset coordinate rotation
  global mom_siemens_coord_rotation
  global mom_kin_machine_type
  global mom_siemens_5axis_mode
  global mom_siemens_5axis_output_mode

  if { $mom_siemens_coord_rotation != 0 } {
     if { ![string match "SWIVELING" $mom_siemens_5axis_mode] } {
        MOM_output_literal "TRANS X0 Y0 Z0"
     } else {
        MOM_output_literal "CYCLE800()"
     }
     if { $mom_siemens_coord_rotation == 2 } {
        set mom_siemens_coord_rotation 0
     }
  }


  global coord_offset_flag
  if { [info exists coord_offset_flag] && $coord_offset_flag == 1 } {
     MOM_output_literal "TRANS X0 Y0 Z0"
  }

  if { $mom_siemens_5axis_output_mode == 1 } {
     set mom_siemens_5axis_output_mode 0
     MOM_do_template trafoof
  }

  # Unset 3Dcutcom mode
  global mom_siemens_3Dcutcom_mode mom_cutter_data_output_indicator
  global mom_cutcom_status
  set mom_cutter_data_output_indicator 0
  set mom_siemens_3Dcutcom_mode "OFF"


  # Motion message flag
  global mom_siemens_pre_motion
  set mom_siemens_pre_motion "end"

  PB_CMD_restore_kinematics
}


#=============================================================
proc PB_CMD_reset_fourth_axis { } {
#=============================================================
global mom_angle_out_pos mom_prev_out_angle_pos mom_pos

set mom_prev_out_angle_pos(0) 0.0
set mom_prev_pos(3) 0.0


MOM_reload_variable -a mom_prev_out_angle_pos
MOM_reload_variable -a mom_prev_pos
}


#=============================================================
proc PB_CMD_reset_mode { } {
#=============================================================
}


#=============================================================
proc PB_CMD_reset_output_digits { } {
#=============================================================
 # Reset address format according to difference setting.
 # Before use this command,please make sure following formats have been created.
 # AbsCoord_mm AbsCoord_less_mm AbsCoord_nurbs_mm
 # AbsCoord_in AbsCoord_less_in AbsCoord_nurbs_in
 # Rotary Rotary_less

  global mom_motion_output_type
  global mom_siemens_5axis_output_mode
  global mom_output_unit
  global mom_kin_machine_resolution
  global mom_kin_4th_axis_min_incr
  global mom_kin_5th_axis_min_incr

  set address_list [list X Y Z I J K]
  if {[string match $mom_output_unit "MM"]} {
     if {![info exists mom_motion_output_type] || $mom_motion_output_type < 2} {
        global mom_operation_type
        if {![string match "Point to Point" $mom_operation_type] && ![string match "Hole Making" $mom_operation_type] && \
            ![string match "Drilling" $mom_operation_type] && $mom_siemens_5axis_output_mode == 1} {
           foreach address $address_list {
              catch {MOM_set_address_format $address AbsCoord_mm}
           }
           catch {MOM_set_address_format fourth_axis Rotary}
           catch {MOM_set_address_format fifth_axis Rotary}
        } else {
           foreach address $address_list {
              catch {MOM_set_address_format $address AbsCoord_less_mm}
           }
           catch {MOM_set_address_format fourth_axis Rotary_less}
           catch {MOM_set_address_format fifth_axis Rotary_less}
        }
     } else {
        #For nurbs output
            foreach address $address_list {
              catch {MOM_set_address_format $address AbsCoord_nurbs_mm}
           }
           catch {MOM_set_address_format fourth_axis Rotary}
           catch {MOM_set_address_format fifth_axis Rotary}
     }
  } else {
     if {![info exists mom_motion_output_type] || $mom_motion_output_type < 2} {
        global mom_operation_type
        if {![string match "Point to Point" $mom_operation_type] && ![string match "Hole Making" $mom_operation_type] && \
            ![string match "Drilling" $mom_operation_type] && $mom_siemens_5axis_output_mode == 1} {
           foreach address $address_list {
              catch {MOM_set_address_format $address AbsCoord_in}
           }
           catch {MOM_set_address_format fourth_axis Rotary}
           catch {MOM_set_address_format fifth_axis Rotary}
        } else {
           foreach address $address_list {
              catch {MOM_set_address_format $address AbsCoord_less_in}
           }
           catch {MOM_set_address_format fourth_axis Rotary_less}
           catch {MOM_set_address_format fifth_axis Rotary_less}
        }
     } else {
        #For nurbs output
         foreach address $address_list {
           catch {MOM_set_address_format $address AbsCoord_nurbs_in}
        }
        catch {MOM_set_address_format fourth_axis Rotary}
        catch {MOM_set_address_format fifth_axis Rotary}
     }
  }

}


#=============================================================
proc PB_CMD_reset_part_transfer_flag { } {
#=============================================================
  global mom_part_transfer_flag
  set mom_part_transfer_flag 0
}


#=============================================================
proc PB_CMD_reset_sinumerik_setting_in_group { } {
#=============================================================
# This command is used to reset sinumerik settings for different program group.
#
# Please DO NOT remove this command from Start of Path, unless you know what you are doing.
#
# 23-Dec-2016 shuai - CYCLE832 enhancement.
#

  global mom_machine_mode

  if {[string compare $mom_machine_mode "MILL"]} {

     return
  }

  global mom_siemens_milling_setting

  if {![info exists mom_siemens_milling_setting] } {
     set mom_siemens_milling_setting "Default"
  }

  global mom_group_name
  global mom_prev_group_name
  global mom_siemens_feed_definition

  if {[info exists mom_prev_group_name] && [string match "Group$mom_prev_group_name" $mom_siemens_milling_setting]} {

     if {[info exists mom_group_name] && ![string match $mom_group_name $mom_prev_group_name] } {

        set mom_siemens_feed_definition "OFF"
        set mom_siemens_milling_setting "Default"

        if {[llength [info commands PB_CMD_set_Sinumerik_default_setting]]} {
           PB_CMD_set_Sinumerik_default_setting
        }
     }
  }

}


#=============================================================
proc PB_CMD_restore_active_oper_tool_data { } {
#=============================================================
#  This command restores the attributes of the tool used in the current operation
#  to be post-processed before the generation of the tool list.
#  The attributes have been saved in proc PB_CMD_save_active_oper_tool_data.
#  This command wil be executed automatically in PB_CMD_create_tool_list.
   global mom_sys_oper_tool_attr_list
   global mom_sys_oper_tool_attr_saved_arr
   foreach mom_var $mom_sys_oper_tool_attr_list {
      global $mom_var
      if [info exists mom_sys_oper_tool_attr_saved_arr($mom_var)] {
         set $mom_var $mom_sys_oper_tool_attr_saved_arr($mom_var)
      }
    }
}


#=============================================================
proc PB_CMD_restore_kinematics { } {
#=============================================================
#This proc is used to save original kinematics variables
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
proc PB_CMD_return_home { } {
#=============================================================

     MOM_force Once X Y Z D G_motion
     MOM_output_literal "DIAMOF"
     MOM_do_template return_home_x
     MOM_do_template return_home_spindle_yz
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

         if { [info exists mom_kin_${axis}_rotation] && [string match "reverse" [set mom_kin_${axis}_rotation]] } {

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


  set var_list { ang_offset center_offset(0) center_offset(1) center_offset(2) direction incr_switch leader limit_action max_limit min_incr min_limit plane rotation zero }

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
proc PB_CMD_rotate_cycle_coordinate { } {
#=============================================================
# This command is used to handle variable-axis drilling cycles.
# If coordinate isn't set as csys rotation and tool axis is not along Zaxis. Frame rotation codes
# TRANS/AROT or cycle800 will be output acoording to tool axis direction.
# For dual table machine without tool tip control, this command will be ignored.


  global cycle_init_flag
  global mom_siemens_cycle_count
  global cycle_plane_change_flag
  global mom_kin_machine_type
  global mom_tool_axis mom_tool_axis_type
  global mom_siemens_5axis_mode
  global mom_pos mom_mcs_goto
  global mom_prev_out_angle_pos mom_out_angle_pos
  global mom_siemens_coord_rotation
  global save_mom_kin_machine_type
  global mom_prev_tool_axis
  global coord_ang_A coord_ang_B coord_ang_C
  global mom_cycle_rapid_to_pos mom_cycle_retract_to_pos mom_cycle_feed_to_pos
  global mom_cycle_rapid_to mom_cycle_retract_to mom_cycle_feed_to
  global coord_offset mom_current_motion
  global mom_cycle_spindle_axis
  global mom_out_angle_pos mom_prev_out_angle_pos
  global mom_current_motion
  global mom_kin_machine_type

  if { ![string match "*5_axis*" $mom_kin_machine_type] } {
return
  }

  if {[info exists mom_siemens_coord_rotation] && $mom_siemens_coord_rotation ==1} {
return
  }

  if {![info exists mom_prev_out_angle_pos]} {
     set mom_prev_out_angle_pos(0) 0.0
     set mom_prev_out_angle_pos(1) 0.0
  }

  # <lili 04-20-2011>The command PB_CMD_auto_3D_rotation should be call again
  # at first hole to calculate mom_pos if there is no start point or clearance
  # plane because mom_pos cannot be reloaded at inital move or first move.
  # cycle_rotate_flag is used to detect if there is coordinate rotation after
  # first hole.
  if {![EQ_is_equal $mom_out_angle_pos(0) $mom_prev_out_angle_pos(0)] || ![EQ_is_equal $mom_out_angle_pos(1) $mom_prev_out_angle_pos(1)]} {
     set cycle_rotate_flag 1
  } else {
     set cycle_rotate_flag 0
  }

  if {[EQ_is_equal $mom_tool_axis(2) 1.0]} {
     set coord_ang_A 0
     set coord_ang_B 0
     set coord_ang_C 0
     # If in cycle plane change event, the tool axis changed back to Z axis,
     # reload mom_prev_out_angle_pos to prevent the coordinate rotation code output twice.
     if {[info exists mom_siemens_coord_rotation] && $mom_siemens_coord_rotation == 2} {
        set mom_prev_out_angle_pos(0) $mom_out_angle_pos(0)
        set mom_prev_out_angle_pos(1) $mom_out_angle_pos(1)
        MOM_reload_variable -a mom_prev_out_angle_pos
     }
  } else {
     PB_CMD_auto_3D_rotation
  }

  if {$mom_siemens_coord_rotation ==2} {
     set mom_cycle_spindle_axis 2
     if {$cycle_rotate_flag == 1} {
       # Output coordinate rotation code
        PB_CMD_output_trans_arot
        if { [PB_CMD__check_block_CYCLE800] } {
           PB_call_macro CYCLE800_sl
        }
        MOM_force Once X Y Z
     }
     VMOV 3 mom_pos mom_cycle_rapid_to_pos
     VMOV 3 mom_pos mom_cycle_feed_to_pos
     VMOV 3 mom_pos mom_cycle_retract_to_pos
     set mom_cycle_rapid_to_pos(2) [expr $mom_pos(2)+$mom_cycle_rapid_to]
     set mom_cycle_retract_to_pos(2) [expr $mom_pos(2)+$mom_cycle_retract_to]
     set mom_cycle_feed_to_pos(2) [expr $mom_pos(2)+$mom_cycle_feed_to]
  }
}


#=============================================================
proc PB_CMD_rotate_rapid_coordinate { } {
#=============================================================
# This command is used to detect rotary axis change inside operation for 3+2 milling.
# This command will output coordinate rotation code if the rotary axis change the
# position.

  global mom_kin_machine_type
  global mom_tool_axis mom_tool_axis_type
  global mom_siemens_5axis_mode
  global mom_pos mom_mcs_goto
  global mom_prev_out_angle_pos mom_out_angle_pos
  global mom_siemens_coord_rotation
  global save_mom_kin_machine_type
  global mom_prev_tool_axis
  global coord_ang_A coord_ang_B coord_ang_C
  global coord_offset mom_current_motion
  global mom_out_angle_pos mom_prev_out_angle_pos
  global mom_kin_machine_type

  if { ![string match "*5_axis*" $mom_kin_machine_type] } {
return
  }

  if { [info exists mom_siemens_coord_rotation] && $mom_siemens_coord_rotation == 1 } {
return
  }

  if { ![info exists mom_prev_out_angle_pos] } {
     set mom_prev_out_angle_pos(0) 0.0
     set mom_prev_out_angle_pos(1) 0.0
  }

  if { [EQ_is_equal $mom_out_angle_pos(0) $mom_prev_out_angle_pos(0)] &&\
       [EQ_is_equal $mom_out_angle_pos(1) $mom_prev_out_angle_pos(1)] } {
return
  }

  if { [info exists mom_tool_axis] && [info exists mom_prev_tool_axis] } {
      if { [VEC3_is_equal mom_tool_axis mom_prev_tool_axis] } {
return
      }
  }

  if { [EQ_is_equal $mom_tool_axis(2) 1.0] } {
     set coord_ang_A 0
     set coord_ang_B 0
     set coord_ang_C 0
     if { [info exists mom_siemens_coord_rotation] && $mom_siemens_coord_rotation == 2 } {
        set mom_prev_out_angle_pos(0) $mom_out_angle_pos(0)
        set mom_prev_out_angle_pos(1) $mom_out_angle_pos(1)
        MOM_reload_variable -a mom_prev_out_angle_pos
     }
  } else {
     PB_CMD_auto_3D_rotation
  }

  if { $mom_siemens_coord_rotation == 2 } {
     # Output coordinate rotation code
     PB_CMD_output_trans_arot
     if { [PB_CMD__check_block_CYCLE800] } {
          PB_call_macro CYCLE800_sl
     }
     MOM_force Once X Y Z
  }
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
proc PB_CMD_save_active_oper_tool_data { } {
#=============================================================
#  This command saves the attributes of the tool used in the current operation
#  to be post-processed before the generation of the tool list.
#
#  This command will be executed automatically in PB_CMD_create_tool_list.
#
#  You may add any desired MOM variable to the list below to be restored
#  later in your post.
#

   global mom_sys_oper_tool_attr_list
   global mom_sys_oper_tool_attr_saved_arr


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # You may add any MOM variable that needs to be retained for
  # the operation to the list below (using lappend command).
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   set mom_sys_oper_tool_attr_list [list]

   lappend mom_sys_oper_tool_attr_list  mom_tool_number
   lappend mom_sys_oper_tool_attr_list  mom_tool_length_adjust_register
   lappend mom_sys_oper_tool_attr_list  mom_tool_name
   lappend mom_sys_oper_tool_attr_list  mom_operation_name


   foreach mom_var $mom_sys_oper_tool_attr_list {
      global $mom_var
      if [info exists $mom_var] {
         set mom_sys_oper_tool_attr_saved_arr($mom_var) [eval format %s $$mom_var]
      }
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
}


#=============================================================
proc PB_CMD_set_Sinumerik_default_setting { } {
#=============================================================
# This command is the default Sinumerik milling settings for Mold&Die and Aerospace production for mill-turn machine.
#
# 22-Dec-2016 shuai - CYCLE832 enhancement.
#                     Update the description for this command.
#

  global sinumerik_version

  if {![info exists sinumerik_version] } {

     return
  }


  # Set the default settings for compressor and smoothing.
  global mom_siemens_compressor
  global mom_siemens_smoothing

  switch $sinumerik_version {

     "V5" {

        set mom_siemens_compressor "COMPCURV" ; # COMPCURV / COMPOF
        set mom_siemens_smoothing  "G642" ;     # G642 / G60
     }

     "V6" {
        set mom_siemens_compressor "COMPCAD" ; # COMPCAD / COMPOF
        set mom_siemens_smoothing  "G642" ;    # G642 / G64
     }

     "V7" -

     "from V26 to V44" -

     "V45" -

     "V47" {
        set mom_siemens_compressor "COMPCAD" ; # COMPCAD / COMPOF
        set mom_siemens_smoothing  "G645" ;    # G645 / G60
     }
  }

  # Set the default settings for some variables.
  global mom_siemens_tol_status
  global mom_siemens_feedforward
  global mom_siemens_top_surface_smooth
  global mom_siemens_5axis_mode
  global mom_siemens_ori_coord
  global mom_siemens_ori_inter
  global mom_siemens_ori_def
  global mom_siemens_rotary_tol
  global mom_siemens_rotary_tol_status

  set mom_siemens_tol_status         "System" ;      # System / User
  set mom_siemens_feedforward        "FFWON" ;       # FFWON / FFWOF
  set mom_siemens_top_surface_smooth "" ;            # _TOP_SURFACE_SMOOTH_ON / _TOP_SURFACE_SMOOTH_OFF
  set mom_siemens_5axis_mode         "TRAFOOF" ;     # TRAORI / SWIVELING / TRAFOOF
  set mom_siemens_ori_coord          "ORIWKS" ;      # ORIWKS / ORIMKS
  set mom_siemens_ori_inter          "ORIAXES" ;     # ORIAXES / ORIVECT
  set mom_siemens_ori_def            "ROTARY AXES" ; # ROTARY AXES / VECTOR

  # Set the rotary tolerance.
  set mom_siemens_rotary_tol        0.8
  set mom_siemens_rotary_tol_status "System" ; # System / User

  # Set the method type and settings status for milling.
  global mom_siemens_method
  global mom_siemens_milling_setting

  set mom_siemens_method          "DESELECTION"
  set mom_siemens_milling_setting "Default"

  # Disable tool axis vector in 3axis machine.
  global mom_kin_machine_type

  if {[string match "3_axis_mill" $mom_kin_machine_type]} {

     set mom_siemens_5axis_mode "TRAFOOF"

     MOM_disable_address A3 B3 C3
     MOM_disable_address fourth_axis fifth_axis

  } elseif {[string match "4*" $mom_kin_machine_type] || [string match "3_axis_mill_turn" $mom_kin_machine_type]} {

     MOM_disable_address fifth_axis
  }

}


#=============================================================
proc PB_CMD_set_Sinumerik_version { } {
#=============================================================
# This command is used to set the sinumerik_control_version and sinumerik_version.
#
# --------------------------------------------------
# "Sinumerik control version" is used to set the output format for drilling CYCLEs (such as CYCLE81).
# "Sinumerik version" is used to set the output format for CYCLE832.
# --------------------------------------------------
#    Sinumerik control version "Powerline"
# --------------------------------------------------
#       Sinumerik version 5.x - "V5"
#       Sinumerik version 6.x - "V6"
#       Sinumerik version 7.x - "V7"
# --------------------------------------------------
#
# --------------------------------------------------
#    Sinumerik control version "Solutionline"
# --------------------------------------------------
#       Sinumerik version 4.4 - "from V26 to V44"
#       Sinumerik version 4.5 - "V45"
#       Sinumerik version 4.7 - "V47"
# --------------------------------------------------
#
# 22-Dec-2016 shuai - CYCLE832 enhancement.
#                     Update the description for this command.
#

  global sinumerik_control_version
  global sinumerik_version

# set sinumerik_version "V5"
# set sinumerik_version "V6"
  set sinumerik_version "V7"
# set sinumerik_version "from V26 to V44"
# set sinumerik_version "V45"
# set sinumerik_version "V47"

  if {![string compare "V5" $sinumerik_version] || \
      ![string compare "V6" $sinumerik_version] || \
      ![string compare "V7" $sinumerik_version] } {

     set sinumerik_control_version "Powerline"

  } elseif {![string compare "from V26 to V44" $sinumerik_version] || \
            ![string compare "V45" $sinumerik_version] || \
            ![string compare "V47" $sinumerik_version] } {

     set sinumerik_control_version "Solutionline"
  }

}


#=============================================================
proc PB_CMD_set_XZC_mode { } {
#=============================================================
  global mom_tool_axis_type
  global mom_operation_type
  global mom_current_motion
  global mom_siemens_5axis_mode
  global mom_siemens_5axis_output_mode
  global mom_tool_axis
  global mom_coordinate_output_mode
  global mom_lock_axis
  global mom_lock_axis_plane
  global mom_lock_axis_value_defined
  global mom_lock_axis_value

  set mom_coordinate_output_mode "CX-Z OUTPUT"
  set mom_lock_axis "YAXIS"
  set mom_lock_axis_plane "XYPLAN"
  set mom_lock_axis_value_defined 1
  set mom_lock_axis_value 0.0
  MOM_lock_axis

  # Lock on and not circular move
  global mom_sys_lock_status mom_current_motion
  if { [info exists mom_sys_lock_status] && ![string compare "ON" $mom_sys_lock_status] } {
      if { [info exists mom_current_motion] && [string compare "circular_move" $mom_current_motion] } {
          LOCK_AXIS_MOTION
      }
  }

}


#=============================================================
proc PB_CMD_set_a_axis { } {
#=============================================================
global tool_holder_spindle_axis

if {![info exists tool_holder_spindle_axis]} {
   set tool_holder_spindle_axis 0
}
}


#=============================================================
proc PB_CMD_set_csys { } {
#=============================================================
#
#  This custom command will be executed automatically in
#  MOM_set_csys event handler. Starting in NX2 a
#  MOM_set_csys event with a coordinate system type and matrix will be
#  output at the start of every tool path where the MCS changes.  If the
#  coordinate system type is CSYS, the coordinate system will be converted
#  into the rotations and translations needed.
#
#  This custom command is used primarily for head/table or head/head
#  five-axis machines.
#

 global mom_kin_coordinate_system_type
 global mom_coordinate_system_purpose
 global mom_special_output
 global mom_kin_machine_type
 global mom_path_name
 global mom_siemens_coord_rotation
 global mom_csys_matrix mom_csys_origin
 global coord_offset mom_output_unit mom_part_unit
 global coord_offset_flag
 global mom_parent_csys_matrix
 global RAD2DEG

 set coord_offset(0) 0.0
 set coord_offset(1) 0.0
 set coord_offset(2) 0.0
 set coord_offset_flag 0
 set mom_siemens_coord_rotation 0

 if {![info exists mom_kin_coordinate_system_type] || ![info exists mom_special_output]} {
return
 }

   if { ![string match "CSYS" $mom_kin_coordinate_system_type] } {
return
  }

  if {[array exists mom_parent_csys_matrix]} {
     VMOV 12 mom_parent_csys_matrix csys_matrix
     set mom_csys_origin(0) $mom_parent_csys_matrix(9)
     set mom_csys_origin(1) $mom_parent_csys_matrix(10)
     set mom_csys_origin(2) $mom_parent_csys_matrix(11)
  } else {
     VMOV 12 mom_csys_matrix csys_matrix
  }

  set coord_offset(0) $mom_csys_origin(0)
  set coord_offset(1) $mom_csys_origin(1)
  set coord_offset(2) $mom_csys_origin(2)


  set m0 $csys_matrix(0)
  set m1 $csys_matrix(1)
  set m2 $csys_matrix(2)
  set m3 $csys_matrix(3)
  set m4 $csys_matrix(4)
  set m5 $csys_matrix(5)
  set m6 $csys_matrix(6)
  set m7 $csys_matrix(7)
  set m8 $csys_matrix(8)

  set cos_b_sq [expr $m0*$m0 + $m3*$m3]

  if {[EQ_is_equal $cos_b_sq 0.0]} {

    set cos_b 0.0
    set cos_c 1.0
    set cos_a $m4
    set sin_c 0.0
    set sin_a [expr -1*$m5]

    if {$m6 < 0.0} {
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

  set X $mom_csys_origin(0)
  set Y $mom_csys_origin(1)
  set Z $mom_csys_origin(2)


  global mom_kin_machine_type
  global mom_kin_4th_axis_plane
  global mom_kin_5th_axis_plane
  global mom_kin_4th_axis_direction
  global mom_kin_5th_axis_direction
  global mom_kin_4th_axis_leader
  global mom_kin_5th_axis_leader
  global mom_kin_4th_axis_min_limit
  global mom_kin_4th_axis_max_limit
  global mom_kin_5th_axis_min_limit
  global mom_kin_5th_axis_max_limit
  global mom_out_angle_pos
  global mom_prev_out_angle_pos
  global mom_sys_leader
  global mom_pos
  global mom_warning_info
  global RAD2DEG
  global mom_init_pos

  if {![info exists mom_prev_out_angle_pos(0)]} {
    set mom_prev_out_angle_pos(0) [MOM_ask_address_value fourth_axis]

    if { $mom_prev_out_angle_pos(0) == "" } {
      set mom_prev_out_angle_pos(0) 0.0
    }
  }
  if {![info exists mom_prev_out_angle_pos(1)]} {
    set mom_prev_out_angle_pos(1) [MOM_ask_address_value fifth_axis]

    if { $mom_prev_out_angle_pos(1) == "" } {
      set mom_prev_out_angle_pos(1) 0.0
    }
  }

  set mom_pos(3) $mom_init_pos(3)
  set mom_pos(4) $mom_init_pos(4)

  set rot_angle_pos(0) [ROTSET $mom_pos(3)  $mom_prev_out_angle_pos(0)  $mom_kin_4th_axis_direction \
                               $mom_kin_4th_axis_leader  mom_sys_leader(fourth_axis) \
                               $mom_kin_4th_axis_min_limit  $mom_kin_4th_axis_max_limit]
  set rot_angle_pos(1) [ROTSET $mom_pos(4)  $mom_prev_out_angle_pos(1)  $mom_kin_5th_axis_direction \
                               $mom_kin_5th_axis_leader  mom_sys_leader(fifth_axis) \
                               $mom_kin_5th_axis_min_limit  $mom_kin_5th_axis_max_limit]
  set mom_init_pos(3) $rot_angle_pos(0)
  set mom_init_pos(4) $rot_angle_pos(1)


############### CONTROLLER OUTPUT SYSTEMS FOR CUSTOMIZING SIEMENS  ########################

   global coord_ref_x coord_ref_y coord_ref_z
   global coord_ang_A coord_ang_B coord_ang_C
   global mom_siemens_coord_rotation coord_offset

   set coord_ang_A $A
   set coord_ang_B $B
   set coord_ang_C $C

   set coord_ref_x $X
   set coord_ref_y $Y
   set coord_ref_z $Z

   if {![EQ_is_zero $A] || ![EQ_is_zero $B] || ![EQ_is_zero $C]} {
      set mom_siemens_coord_rotation 1
   }
}


#=============================================================
proc PB_CMD_set_cycle_plane { } {
#=============================================================
#
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
  set suppress_principal_axis 1


 #++++++++++++++++++++++++++++++++++++++++++++++++++++++
 # This option can be set to 1, if the plane code needs
 # to be forced out @ the start of every set of cycles.
 #++++++++++++++++++++++++++++++++++++++++++++++++++++++
  set force_plane_code 0


  global mom_cycle_spindle_axis


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
proc PB_CMD_set_cycle_plane_change { } {
#=============================================================
  global mom_cycle_spindle_axis
  global mom_current_motion
  global mom_siemens_coord_rotation
  global mom_siemens_cycle_count
  global mom_programmed_feed_rate
  global cycle_init_flag
  global mom_cycle_clearance_plane_change
  global mom_cycle_tool_axis_change

  set cycle_init_flag TRUE

  if {![info exists mom_cycle_spindle_axis]} {
     set mom_cycle_spindle_axis 2
  }

  #<lili 04-28-2011> mom_cycle_tool_axis_change and mom_cycle_clearance_plane_change is added
  # to detect the tool axis change and clearance plane change in cycles. They are only available
  # in NX754 and later version.
  # mom_cycle_tool_axis_change = 1 means tool axis is changed.
  # mom_cycle_tool_axis_change = 0 menas no tool axis change.
  # mom_cycle_clearance_plane_change = 0 means no clearance plane change.
  # mom_cycle_clearance_plane_change = 1 means clearance plane change from lower to higher.
  # mom_cycle_clearance_plane_change = -1 means clearance plane change from higher to lower.
  if {![info exists mom_cycle_tool_axis_change] || $mom_cycle_tool_axis_change == 0} {
     global mom_pos mom_prev_pos mom_cycle_rapid_to_pos
     if {[info exists mom_cycle_clearance_plane_change] && $mom_cycle_clearance_plane_change>0 } {
        switch $mom_cycle_spindle_axis {
           0 {
              MOM_force Once X
              MOM_suppress Once Y Z
           }
           1 {
              MOM_force Once Y
              MOM_suppress Once X Z
           }
           2 {
              MOM_force Once Z
              MOM_suppress Once Y X
           }
           default {
              MOM_force Once Z
              MOM_suppress Once Y X
           }
        }
        MOM_do_template cycle_retract
     }
  } else {
     PB_CMD_choose_output_mode
     MOM_do_template cycle_rapid
     MOM_force Once X Y
  }

  if {[llength [info command MOM_abort_event]]} {
     MOM_abort_event
  }


}


#=============================================================
proc PB_CMD_set_fixture_offset { } {
#=============================================================
# This command is used to set fixture offset output value.
# It could be G500/G54-G57/G505-G599

  global mom_fixture_offset_value
  global mom_siemens_fixture_offset_value

  if { [info exists mom_fixture_offset_value] } {
      if {$mom_fixture_offset_value <= 0 } {
         set mom_siemens_fixture_offset_value 500
      } elseif {$mom_fixture_offset_value<=4} {
         set mom_siemens_fixture_offset_value [expr $mom_fixture_offset_value + 53]
      } elseif {$mom_fixture_offset_value>4} {
         set mom_siemens_fixture_offset_value [expr $mom_fixture_offset_value + 500]
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


  #<03-10-10 gsl> pb751 - Respect tool axis for 3-axis & XZC
   global mom_kin_machine_type mom_tool_axis
   if [string match "3_axis*" $mom_kin_machine_type] {
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

   # Always output G17 in TRAORI/CYCLE800 mode
   global mom_siemens_5axis_mode
   global mom_siemens_5axis_output_mode
   global mom_siemens_coord_rotation
   if {([info exists mom_siemens_5axis_mode] && ![string compare $mom_siemens_5axis_mode "SWIVELING"]) \
       || ([info exists mom_siemens_5axis_output_mode] && $mom_siemens_5axis_output_mode == 1) \
       || ([info exists mom_siemens_coord_rotation] && $mom_siemens_coord_rotation == 1)} {
      set mom_cycle_spindle_axis 2
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
proc PB_CMD_set_resolution { } {
#=============================================================
# This command is used to redefine the resolution of linear and rotary axes.
# This command should be used with PB_CMD_reset_output_digits, which located
# in Initial Move and First Move.
#
   global mom_output_unit
   global mom_motion_output_type
   global mom_kin_machine_resolution
   global mom_kin_4th_axis_min_incr
   global mom_kin_5th_axis_min_incr
   global mom_operation_type

   if {[string match $mom_output_unit "MM"]} {
      if {![info exists mom_motion_output_type] || $mom_motion_output_type < 2} {
         if {[string match "Point to Point" $mom_operation_type] || [string match "Hole Making" $mom_operation_type] || \
             [string match "Drilling" $mom_operation_type]} {
            set mom_kin_machine_resolution 0.001
            set mom_kin_4th_axis_min_incr  0.00001
            set mom_kin_5th_axis_min_incr  0.00001
            MOM_reload_kinematics
         } else {
            set mom_kin_machine_resolution 0.00001
            set mom_kin_4th_axis_min_incr  0.00001
            set mom_kin_5th_axis_min_incr  0.00001
            MOM_reload_kinematics
         }
      } else {
         set mom_kin_machine_resolution 0.000001
         set mom_kin_4th_axis_min_incr  0.00001
         set mom_kin_5th_axis_min_incr  0.00001
         MOM_reload_kinematics
      }
   } else {
      if {![info exists mom_motion_output_type] || $mom_motion_output_type < 2} {
         if {[string match "Point to Point" $mom_operation_type] || [string match "Hole Making" $mom_operation_type] || \
             [string match "Drilling" $mom_operation_type]} {
            set mom_kin_machine_resolution 0.0001
            set mom_kin_4th_axis_min_incr  0.00001
            set mom_kin_5th_axis_min_incr  0.00001
            MOM_reload_kinematics
         } else {
            set mom_kin_machine_resolution 0.000001
            set mom_kin_4th_axis_min_incr  0.00001
            set mom_kin_5th_axis_min_incr  0.00001
            MOM_reload_kinematics
         }
      } else {
         set mom_kin_machine_resolution 0.0000001
         set mom_kin_4th_axis_min_incr  0.00001
         set mom_kin_5th_axis_min_incr  0.00001
         MOM_reload_kinematics
      }
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
proc PB_CMD_start_of_extcall_operation { } {
#=============================================================
#  This command is used to output EXTCALL in main program and create sub program files.
#  Please put it in top of Start of Path.

   global mom_siemens_program_control
   global ptp_file_name mom_sys_ptp_output
   global mom_output_file_directory
   global mom_operation_name
   global mom_sequence_number mom_sequence_increment mom_sequence_frequency
   global mom_group_name

   if { ![string match "ON" $mom_sys_ptp_output] || ![info exists ptp_file_name] } {
return
   }

   if { [info exists mom_siemens_program_control] && [string match "TRUE" $mom_siemens_program_control] } {
      MOM_open_output_file $ptp_file_name
      MOM_set_seq_off
      MOM_output_literal "EXTCALL (\"$mom_operation_name\")"
      MOM_set_seq_on
      MOM_close_output_file $ptp_file_name

      set output_extn ".spf"
      set subroutine_name "${mom_output_file_directory}${mom_operation_name}${output_extn}"
      if { [file exists $subroutine_name] } {
         MOM_remove_file $subroutine_name
      }
      MOM_open_output_file $subroutine_name
      SEQNO_RESET
      MOM_reset_sequence $mom_sequence_number $mom_sequence_increment $mom_sequence_frequency
      MOM_set_seq_on

      #start_output_flag is used to output start of program NC codes.
      #If it is 0, NC codes for start of program will be output.
      global start_output_flag
      set start_output_flag 0
   }
}


#=============================================================
proc PB_CMD_start_of_operation_force_addresses { } {
#=============================================================
  MOM_force once X Y Z F S
}


#=============================================================
proc PB_CMD_swap_4th_5th_kinematics { } {
#=============================================================
#This proc is used to swap 4th and 5th axis kinematics variables
  set kin_list { ang_offset direction  leader incr_switch  limit_action  max_limit  min_incr min_limit  plane rotation zero}
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
 global mom_sys_leader
 if {[info exists save_mom_sys_4th_axis_has_limits] && [info exists save_mom_sys_5th_axis_has_limits]} {
    set mom_sys_4th_axis_has_limits $save_mom_sys_5th_axis_has_limits
    set mom_sys_5th_axis_has_limits $save_mom_sys_4th_axis_has_limits
 }
 if {[info exists save_mom_kin_4th_axis_leader] && [info exists save_mom_kin_5th_axis_leader]} {
    set mom_sys_leader(fourth_axis) $save_mom_kin_5th_axis_leader
    set mom_sys_leader(fifth_axis) $save_mom_kin_4th_axis_leader
 }
 MOM_reload_kinematics
}


#=============================================================
proc PB_CMD_tool_change { } {
#=============================================================
  global mom_channel_id
  global mom_current_motion

  if {$mom_channel_id==1} {
    # MOM_do_template tool_change
     PB_call_macro Tool_change
  } elseif {[string match "initial_move" $mom_current_motion]} {
     MOM_force Once M
     MOM_do_template tool_change_turret
  }
}


#=============================================================
proc PB_CMD_turret_change_uplevel { } {
#=============================================================
# This proc is used to switch postprocessor by machine mode and carrier name.
# Don't remove this proc from MOM_turret_change

uplevel #0 {


}; #uplevel

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
proc PB_CMD_unselect_tool { } {
#=============================================================
  global mom_channel_id

  if {[info exists mom_channel_id] && $mom_channel_id==1}  {
     MOM_output_literal "TC(0,0,0)"
  } elseif {[info exists mom_channel_id] && $mom_channel_id==2}  {
     MOM_output_literal "T0"
  }


}


#=============================================================
proc PB_CMD_uplevel_MOM_generic_cycle { } {
#=============================================================
# This command is used to handle cycle95 with generic cycle enhancement.
# 2013-06-27 lili - Initial version
# 2015-10-27 szl  - If start motion is generated after MOM_generic_cycle
#                   skip event handler in start motion to make sure MOM_initial_move
#                   and MOM_first_move handler are executed.


uplevel #0 {
#=============================================================
proc MOM_generic_cycle {  } {
#=============================================================
# This event is generated for lathe rough cycle operation. It contains all motions event will be
# replaced by CYCLE95, including non-cutting motions.
#
# Following mom variable will be set in this event
#   mom_generic_cycle_status
#      1      start of cycle
#      0      end of cycle


  global mom_generic_cycle_status
  global mom_sys_output_contour_motion
  global mom_siemens_cycle95_output_mode
  global mom_sys_cycle95_start_motion


  if {$mom_generic_cycle_status == 1} {
     #init cycle95 output at generic cycle start
     PB_CMD_init_cycle95_output

     if {[info exist mom_sys_output_contour_motion] && $mom_sys_output_contour_motion == 1} {
        if {[info exists mom_sys_cycle95_start_motion] && ![string compare $mom_sys_cycle95_start_motion "Before Cycle"]} {
           #skip to next generic cycle which should be cycle end
            MOM_skip_handler_to_event generic_cycle
            unset mom_sys_cycle95_start_motion
        } else {
            set mom_sys_cycle95_start_motion "After Cycle"
        }
     }
  } elseif {$mom_generic_cycle_status == 0} {
     if {[info exist mom_sys_output_contour_motion] && $mom_sys_output_contour_motion == 1} {
        #output cycle95 statement
        MOM_lathe_roughing
        MOM_force Once G_motion
     }
  }
}
};#uplevel 0
}


#=============================================================
proc PB_CMD_uplevel_lock_axis { } {
#=============================================================

uplevel #0 {
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
#return
        }

        if { [string match "TRUE" $mom_sys_cycle_after_initial] } {
   #        set mom_pos(0) [expr $mom_pos(0) - $mom_cycle_rapid_to * $mom_tool_axis(0)]
   #        set mom_pos(1) [expr $mom_pos(1) - $mom_cycle_rapid_to * $mom_tool_axis(1)]
   #        set mom_pos(2) [expr $mom_pos(2) - $mom_cycle_rapid_to * $mom_tool_axis(2)]
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

      global mom_kin_linearization_flag

      if { ![string compare "TRUE" $mom_kin_linearization_flag] &&\
            [string compare "RAPID" $mom_motion_type] &&\
            [string compare "RETRACT" $mom_motion_type] } {

         LINEARIZE_LOCK_MOTION

      } else {

         if { ![info exists mom_prev_rot_ang_4th] } { set mom_prev_rot_ang_4th 0.0 }
         if { ![info exists mom_prev_rot_ang_5th] } { set mom_prev_rot_ang_5th 0.0 }

         LINEARIZE_LOCK_OUTPUT -1

         #<09-15-09 wbh> We must call ROTSET only one time for the 4th and/or 5th axis.
         # Since the proc ROTSET was called in LINEARIZE_LOCK_OUTPUT,
         # we should reload mom_prev_rot_ang_5th if it exists.
         if { [info exists mom_kin_5th_axis_direction] } {
            set mom_prev_rot_ang_5th $mom_out_angle_pos(1)
            MOM_reload_variable mom_prev_rot_ang_5th
         }
      }

      set mom_prev_rot_ang_4th $mom_out_angle_pos(0)
      MOM_reload_variable mom_prev_rot_ang_4th
      MOM_reload_variable -a mom_pos
   }
}
}
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
proc ASK_DELTA_4TH_OR_5TH { axis_no } {
#=============================================================
# Returns the delta rotation in degrees of the axis_no(4 or 5)
#
#
# - REVISIONS
#<12-15-08 gsl> Overload this command defined in ugpost_base.tcl
#<01-07-09 gsl> Ensured this command returns absolute value
#

   global   mom_pos mom_prev_pos
   global   mom_rotary_delta_4th mom_rotary_delta_5th

  # Recompute 4th delta for polar output of XZC mill post
  # ==> mom_kin_machine_type has been set to "mill_turn"
  #     in LINEARIZE_OUTPUT before FEEDRATE_SET is called.
  #
   global mom_out_angle_pos
   global mom_kin_machine_type mom_sys_coordinate_output_mode

   if { [string match "*mill_turn*" $mom_kin_machine_type] } {
      if { [string match "POLAR" $mom_sys_coordinate_output_mode] } {
         set mom_rotary_delta_4th [expr $mom_out_angle_pos(0) - $mom_prev_pos(3)]
      }
   }


   if { $axis_no == 4 && [info exists mom_rotary_delta_4th] } {
return [expr abs($mom_rotary_delta_4th)]
   }

   if { $axis_no == 5 && [info exists mom_rotary_delta_5th] } {
return [expr abs($mom_rotary_delta_5th)]
   }

   incr axis_no -1
   set abs_rotdel [expr abs(abs($mom_pos($axis_no)) - abs($mom_prev_pos($axis_no)))]

   if { [EQ_is_gt $abs_rotdel 180.0] } {
      set rotdel [expr 360.0 - $abs_rotdel]
   } else {
      set rotdel $abs_rotdel
   }

return $rotdel
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
proc CYCLE_SET { } {
#=============================================================
   WORKPLANE_SET
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
   # VMOV 5 mom_prev_pos locked_prev_pos
   LOCK_AXIS mom_prev_pos locked_prev_pos ::mom_prev_out_angle_pos

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


   # <09-Sep-2015 ljt> Remove offsets of  4/5th axis rotary center
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
# Mar-29-2016    - Of NX/PB v11.0
#

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

      set temp($mom_sys_rotary_axis_index)  [expr ($angle-$ang1)*$RAD2DEG]
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


#=============================================================
proc MCS_VECTOR { input_vector output_vector } {
#=============================================================
# This proc is used to transform vector from machine coordinate to work coordinate
#
   upvar $input_vector u ; upvar $output_vector v
   global mom_machine_mode
   global mom_kin_machine_type

   if {$mom_machine_mode != "MILL"} {
return
   }
   if {[string match "*3_axis*" $mom_kin_machine_type] || ![string match "*table*" $mom_kin_machine_type]} {
      VMOV 3 u v
   } else {
      global mom_kin_4th_axis_type mom_kin_5th_axis_type
      global mom_kin_4th_axis_vector mom_kin_5th_axis_vector
      global mom_out_angle_pos mom_pos DEG2RAD
      if {[info exists mom_kin_4th_axis_type] && [string match "Table" $mom_kin_4th_axis_type]} {
         set angle $mom_pos(3)*$DEG2RAD
         VECTOR_ROTATE mom_kin_4th_axis_vector $angle u v
         VMOV 3 v w
      } else {
         VMOV 3 u w
      }
      if {[info exists mom_kin_5th_axis_type] && [string match "Table" $mom_kin_5th_axis_type]} {
         set angle $mom_pos(4)*$DEG2RAD
         VECTOR_ROTATE mom_kin_5th_axis_vector $angle w v
      }
   }
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
      if { [string length $s] > 0 } {
         if { !$seq_no } {
            MOM_suppress once N
         }
         MOM_output_literal $s1
      }
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
proc ROTARY_AXIS_RETRACT { } {
#=============================================================
# called by PB_CMD_kin_before_motion
#
#  This command is used by four and five axis posts to retract
#  from the part when the rotary axis become discontinuous.  This
#  command is activated by setting the axis limit violation
#  action to "retract / re-engage".
#
#-------------------------------------------------------------
# Nov-30-2016 gsl - (pb1102) Corrected logic
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
          #<04-17-09 wbh> add the case for user defined
            PB_user_def_axis_limit_action

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
proc VECTOR_ROTATE { axis angle input_vector output_vector } {
#=============================================================
# This proc is used to rotating a vector about arbitrary axis
#
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
proc PB_DEFINE_MACROS { } {
#=============================================================
   global mom_pb_macro_arr

   set mom_pb_macro_arr(CYCLE81) \
       [list {CYCLE81 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4}}]

   set mom_pb_macro_arr(CYCLE82) \
       [list {CYCLE82 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {{$mom_siemens_cycle_dtb} 1 4 2 1 1 6 4}}]

   set mom_pb_macro_arr(CYCLE83_Deep) \
       [list {CYCLE83 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {} \
         {{$mom_cycle_step1} 1 4 5 1 1 9 4} \
         {{$mom_cycle_step2} 1 4 5 1 1 9 4} \
         {{$mom_siemens_cycle_dtb} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dts} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_frf} 1 3 5 1 1 8 3} \
         {1 0} \
         {{$mom_siemens_cycle_o_axn} 1 0 1 0 0 1} \
         {{$mom_cycle_step3} 1 4 5 1 1 9 4} \
         {} \
         {{$mom_siemens_cycle_o_dtd} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_o_dis1} 1 4 5 1 1 9 4}}]

   set mom_pb_macro_arr(CYCLE83_Break_Chip) \
       [list {CYCLE83 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {} \
         {{$mom_siemens_cycle_fdpr} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dam} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dtb} 1 3 5 1 1 8 3} \
         {} \
         {{$mom_siemens_cycle_frf} 1 3 5 1 1 8 3} \
         {0 0} \
         {{$mom_siemens_cycle_o_axn} 1 0 1 0 0 1} \
         {{$mom_cycle_step3} 1 4 5 1 1 9 4} \
         {{$mom_siemens_cycle_o_vrt} 1 4 2 1 1 6 4} \
         {{$mom_siemens_cycle_o_dtd} 1 3 5 1 1 8 3}}]

   set mom_pb_macro_arr(CYCLE84) \
       [list {CYCLE84 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {{$mom_cycle_delay} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_sdac} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_mpit} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_pit} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_poss} 1 3 5 1 1 8 3} \
         {{$mom_spindle_speed} 1 2 7 1 1 9 2} \
         {{$mom_siemens_cycle_sst1} 1 2 7 1 1 9 2} \
         {{$mom_siemens_cycle_o_axn} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_o_ptab} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_o_techno} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_o_var1} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_o_dam} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_o_vrt} 1 3 5 1 1 8 3}}]

   set mom_pb_macro_arr(CYCLE840) \
       [list {CYCLE840 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {{$mom_cycle_delay} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_sdr} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_sdac} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_enc} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_mpit} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_pit} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_o_axn} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_o_ptab} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_o_techno} 1 0 2 0 0 2}}]

   set mom_pb_macro_arr(CYCLE85_Bore) \
       [list {CYCLE85 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {} \
         {{$feed} 1 2 7 1 1 9 2} \
         {{$mom_siemens_cycle_rff} 1 2 7 1 1 9 2}}]

   set mom_pb_macro_arr(CYCLE85_Bore_Dwell) \
       [list {CYCLE85 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {{$mom_cycle_delay} 1 3 5 1 1 8 3} \
         {{$feed} 1 2 7 1 1 9 2} \
         {{$mom_siemens_cycle_rff} 1 2 7 1 1 9 2}}]

   set mom_pb_macro_arr(CYCLE86) \
       [list {CYCLE86 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {{$mom_cycle_delay} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_sdir} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_rpa} 1 4 5 1 1 9 4} \
         {{$mom_siemens_cycle_rpo} 1 4 5 1 1 9 4} \
         {{$mom_siemens_cycle_rpap} 1 4 5 1 1 9 4} \
         {{$mom_cycle_orient} 1 3 5 1 1 8 3}}]

   set mom_pb_macro_arr(CYCLE87) \
       [list {CYCLE87 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {{$mom_siemens_cycle_sdir} 1 0 1 0 0 1}}]

   set mom_pb_macro_arr(CYCLE88) \
       [list {CYCLE88 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {{$mom_cycle_delay} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_sdir} 1 0 1 0 0 1}}]

   set mom_pb_macro_arr(CYCLE89) \
       [list {CYCLE89 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {{$mom_cycle_delay} 1 3 5 1 1 8 3}}]

   set mom_pb_macro_arr(CYCLE800) \
       [list {CYCLE800 ( , ) 0 {}} \
        {{1 0} \
         {{$cycle800_tc} 0} \
         {{$cycle800_st} 1 0 5 0 0 5} \
         {{$cycle800_mode} 1 0 2 0 0 2} \
         {{$coord_ref_x} 1 6 5 1 1 11 6} \
         {{$coord_ref_y} 1 6 5 1 1 11 6} \
         {{$coord_ref_z} 1 6 5 1 1 11 6} \
         {{$coord_ang_1} 1 5 5 1 1 10 5} \
         {{$coord_ang_2} 1 5 5 1 1 10 5} \
         {{$coord_ang_3} 1 5 5 1 1 10 5} \
         {0 1 3 5 1 1 8 3} \
         {0 1 3 5 1 1 8 3} \
         {0 1 3 5 1 1 8 3} \
         {{$cycle800_dir} 1 0 2 0 0 2} \
         {{$cycle800_inc_retract} 1 5 5 1 1 10 5}}]

   set mom_pb_macro_arr(CYCLE832) \
       [list {CYCLE832 ( , ) 0 {}} \
        {{_camtolerance 0} \
         {{$cycle832_tolm} 1 0 6 0 0 6}}]

   set mom_pb_macro_arr(CYCLE832_v7) \
       [list {CYCLE832 ( , ) 0 {}} \
        {{_camtolerance 0} \
         {{$cycle832_tolm} 1 0 6 0 0 6} \
         {{$cycle832_v832} 0}}]

   set mom_pb_macro_arr(MCALL) \
       [list {MCALL {} {} {} 0 {}} \
        {}]

   set mom_pb_macro_arr(ORIRESET) \
       [list {ORIRESET ( , ) 0 {}} \
        {{{$mom_out_angle_pos(0)} 1 5 5 1 1 10 5} \
         {{$mom_out_angle_pos(1)} 1 5 5 1 1 10 5}}]

   set mom_pb_macro_arr(CYCLE86_sl) \
       [list {CYCLE86 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {{$mom_siemens_cycle_dtb} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_sdir} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_rpa} 1 4 5 1 1 9 4} \
         {{$mom_siemens_cycle_rpo} 1 4 5 1 1 9 4} \
         {{$mom_siemens_cycle_rpap} 1 4 5 1 1 9 4} \
         {{$mom_cycle_orient} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_gmode} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_dmode} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_amode} 1 0 2 0 0 2}}]

   set mom_pb_macro_arr(CYCLE81_sl) \
       [list {CYCLE81 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {{$mom_siemens_cycle_dtb} 1 4 2 1 1 6 4} \
         {{$mom_siemens_cycle_gmode} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_dmode} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_amode} 1 0 2 0 0 2}}]

   set mom_pb_macro_arr(CYCLE82_sl) \
       [list {CYCLE82 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {{$mom_siemens_cycle_dtb} 1 4 2 1 1 6 4} \
         {{$mom_siemens_cycle_gmode} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_dmode} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_amode} 1 0 2 0 0 2}}]

   set mom_pb_macro_arr(CYCLE83_Deep_sl) \
       [list {CYCLE83 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {} \
         {{$mom_cycle_step1} 1 4 5 1 1 9 4} \
         {{$mom_cycle_step2} 1 4 5 1 1 9 4} \
         {{$mom_siemens_cycle_dtb} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dts} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_frf} 1 3 5 1 1 8 3} \
         {1 0} \
         {{$mom_siemens_cycle_o_axn} 1 0 1 0 0 1} \
         {{$mom_cycle_step3} 1 4 5 1 1 9 4} \
         {} \
         {{$mom_siemens_cycle_o_dtd} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_o_dis1} 1 4 5 1 1 9 4} \
         {{$mom_siemens_cycle_gmode} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_dmode} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_amode} 1 0 8 0 0 8}}]

   set mom_pb_macro_arr(CYCLE83_Break_Chip_sl) \
       [list {CYCLE83 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {} \
         {{$mom_siemens_cycle_fdpr} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dam} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dtb} 1 3 5 1 1 8 3} \
         {} \
         {{$mom_siemens_cycle_frf} 1 3 5 1 1 8 3} \
         {0 0} \
         {{$mom_siemens_cycle_o_axn} 1 0 1 0 0 1} \
         {{$mom_cycle_step3} 1 4 5 1 1 9 4} \
         {{$mom_siemens_cycle_o_vrt} 1 4 2 1 1 6 4} \
         {{$mom_siemens_cycle_o_dtd} 1 3 5 1 1 8 3} \
         {} \
         {{$mom_siemens_cycle_gmode} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_dmode} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_amode} 1 0 8 0 0 8}}]

   set mom_pb_macro_arr(CYCLE84_sl) \
       [list {CYCLE84 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {{$mom_cycle_delay} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_sdac} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_mpit} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_pit} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_poss} 1 3 5 1 1 8 3} \
         {{$mom_spindle_speed} 1 2 7 1 1 9 2} \
         {{$mom_siemens_cycle_sst1} 1 2 7 1 1 9 2} \
         {{$mom_siemens_cycle_o_axn} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_o_ptab} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_o_techno} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_o_var1} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_o_dam} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_o_vrt} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_o_pitm} 0} \
         {{$mom_siemens_cycle_o_ptab_sl} 0} \
         {{$mom_siemens_cycle_o_ptaba} 0} \
         {{$mom_siemens_cycle_gmode} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_dmode} 1 0 4 0 0 4} \
         {{$mom_siemens_cycle_amode} 1 0 7 0 0 7}}]

   set mom_pb_macro_arr(CYCLE840_sl) \
       [list {CYCLE840 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {{$mom_cycle_delay} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_sdr} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_sdac} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_enc} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_mpit} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_pit} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_o_axn} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_o_ptab} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_o_techno} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_o_pitm} 0} \
         {{$mom_siemens_cycle_o_ptab_sl} 0} \
         {{$mom_siemens_cycle_o_ptaba} 1 4 2 1 1 6 4} \
         {} \
         {{$mom_siemens_cycle_dmode} 1 0 4 0 0 4} \
         {{$mom_siemens_cycle_amode} 1 0 1 0 0 1}}]

   set mom_pb_macro_arr(CYCLE85_Bore_sl) \
       [list {CYCLE85 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {} \
         {{$feed} 1 2 7 1 1 9 2} \
         {{$mom_siemens_cycle_rff} 1 2 7 1 1 9 2} \
         {} \
         {{$mom_siemens_cycle_dmode} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_amode} 1 0 2 0 0 2}}]

   set mom_pb_macro_arr(CYCLE85_Bore_Dwell_sl) \
       [list {CYCLE85 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {{$mom_cycle_clearance_plane} 1 4 5 1 1 9 4} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 4 5 1 1 9 4} \
         {} \
         {{$mom_siemens_cycle_dtb} 1 3 5 1 1 8 3} \
         {{$feed} 1 2 7 1 1 9 2} \
         {{$mom_siemens_cycle_rff} 1 2 7 1 1 9 2} \
         {} \
         {{$mom_siemens_cycle_dmode} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_amode} 1 0 2 0 0 2}}]

   set mom_pb_macro_arr(CYCLE800_sl) \
       [list {CYCLE800 ( , ) 0 {}} \
        {{1 0} \
         {{$cycle800_tc} 0} \
         {{$cycle800_st} 1 0 5 0 0 5} \
         {{$cycle800_mode} 1 0 2 0 0 2} \
         {{$coord_ref_x} 1 6 5 1 1 11 6} \
         {{$coord_ref_y} 1 6 5 1 1 11 6} \
         {{$coord_ref_z} 1 6 5 1 1 11 6} \
         {{$coord_ang_1} 1 5 5 1 1 10 5} \
         {{$coord_ang_2} 1 5 5 1 1 10 5} \
         {{$coord_ang_3} 1 5 5 1 1 10 5} \
         {0 1 3 5 1 1 8 3} \
         {0 1 3 5 1 1 8 3} \
         {0 1 3 5 1 1 8 3} \
         {{$cycle800_dir} 1 0 2 0 0 2} \
         {{$cycle800_inc_retract} 1 5 5 1 1 10 5} \
         {{$mom_siemens_cycle_dmode} 1 0 1 0 0 1}}]

   set mom_pb_macro_arr(CYCLE97_Thread) \
       [list {CYCLE97 ( , ) 0 {}} \
        {{{$mom_siemens_cycle_pit} 1 3 5 1 1 8 3} \
         {} \
         {{$mom_siemens_cycle_spl} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_fpl} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dm1} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dm2} 1 3 5 1 1 8 3} \
         {0 1 3 5 1 1 8 3} \
         {0 1 3 5 1 1 8 3} \
         {{$mom_turn_cycle_total_depth} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_fal} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_iang} 1 3 5 1 1 8 3} \
         {0 0} \
         {{$mom_siemens_cycle_nrc} 1 0 2 0 0 2} \
         {{$mom_number_of_chases} 1 0 2 0 0 2} \
         {{$mom_turn_cycle97_machining_type} 0} \
         {{$mom_number_of_starts} 1 0 2 0 0 2} \
         {{$mom_minimum_clearance} 1 3 5 1 1 8 3}}]

   set mom_pb_macro_arr(CYCLE95) \
       [list {CYCLE95 ( , ) 0 {}} \
        {{{\"$mom_siemens_cycle_subroutine_name\"} 0} \
         {{$mom_siemens_cycle_mid} 1 3 5 1 1 8 3} \
         {{$mom_face_stock} 1 3 5 1 1 8 3} \
         {{$mom_radial_stock} 1 3 5 1 1 8 3} \
         {{$mom_stock_part} 1 3 5 1 1 8 3} \
         {{$mom_feed_cut_value} 1 3 5 1 1 8 3} \
         {{$mom_feed_stepover_value} 1 3 5 1 1 8 3} \
         {{$mom_feedrate_profile_cut} 1 3 5 1 1 8 3} \
         {{$mom_turn_cycle95_machining_type} 1 0 3 0 0 3} \
         {{$mom_local_return_dwell} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dam} 1 3 5 1 1 8 3} \
         {{$mom_retract_level_part_distance} 1 4 5 1 1 9 4}}]

   set mom_pb_macro_arr(CYCLE95_sl) \
       [list {CYCLE95 ( , ) 0 {}} \
        {{{\"$mom_siemens_cycle_subroutine_name\"} 0} \
         {{$mom_siemens_cycle_mid} 1 3 5 1 1 8 3} \
         {{$mom_face_stock} 1 3 5 1 1 8 3} \
         {{$mom_radial_stock} 1 3 5 1 1 8 3} \
         {{$mom_stock_part} 1 3 5 1 1 8 3} \
         {{$mom_feed_cut_value} 1 3 5 1 1 8 3} \
         {{$mom_feed_stepover_value} 1 3 5 1 1 8 3} \
         {{$mom_feedrate_profile_cut} 1 3 5 1 1 8 3} \
         {{$mom_turn_cycle95_machining_type} 1 0 3 0 0 3} \
         {{$mom_local_return_dwell} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dam} 1 3 5 1 1 8 3} \
         {{$mom_retract_level_part_distance} 1 4 5 1 1 9 4} \
         {0 1 0 1 0 0 1} \
         {0 1 0 1 0 0 1}}]

   set mom_pb_macro_arr(CYCLE832_v47) \
       [list {CYCLE832 ( , ) 0 {}} \
        {{{$cycle832_tol} 0} \
         {{$cycle832_tolm} 0} \
         {{$cycle832_otol} 1 2 1 1 1 3 2}}]
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
            set temp_cmd "set data_string \"$exp\""
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


set cam_post_user_tcl "simulation_ini.tcl"




#***************************
# Source in user's tcl file.
#***************************
set cam_post_dir [MOM_ask_env_var UGII_CAM_POST_DIR]
set ugii_version [string trimleft [MOM_ask_env_var UGII_VERSION] v]

if { [catch {
   if { $ugii_version >= 5 } {
      if { [file exists "[file dirname [info script]]/$cam_post_user_tcl"] } {
        # From directory relative to that of current post
         source "[file dirname [info script]]/$cam_post_user_tcl"
      } elseif { [file exists "${cam_post_dir}$cam_post_user_tcl"] } {
        # From directory relative to UGII_CAM_POST_DIR
         source "${cam_post_dir}$cam_post_user_tcl"
      } elseif { [file exists "$cam_post_user_tcl"] } {
        # From the specified directory
         source "$cam_post_user_tcl"
      } else {
         MOM_output_to_listing_device "User's Tcl: $cam_post_user_tcl not found!"
      }
   } else {
      if { [file exists "${cam_post_dir}$cam_post_user_tcl"] } {
         source "${cam_post_dir}$cam_post_user_tcl"
      } else {
         MOM_output_to_listing_device "User's Tcl: ${cam_post_dir}$cam_post_user_tcl not found!"
      }
   }
} err] } {
   MOM_output_to_listing_device "User's Tcl: An error occured while sourcing $cam_post_user_tcl!\n$err"
   MOM_abort "User's Tcl: An error occured while sourcing $cam_post_user_tcl!\n$err"
}


