######################## Virtual NC Controller #########################
#
#  heidenhain_conversational_vnc.tcl -
#
#  Created by x_fu  @  Friday, July 25, 2014 4:27:06 PM China Standard Time
#  with Post Builder version  9.0.3.
#
########################################################################


set mom_sim_vnc_handler_loaded "[join [split [info script] \\] /]"
set mom_sim_master_vnc_loaded [file tail $mom_sim_vnc_handler_loaded]


set mom_sim_post_builder_version 9.0.3


if { ![info exists sim_mtd_initialized] } {
   set sim_mtd_initialized 0
}


#++++++++++++++++++++++++++++++++++++
# Define the base elements only once!
#++++++++++++++++++++++++++++++++++++
if { $sim_mtd_initialized == 0 } {



set cam_aux_dir   [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]
set cam_post_dir  [MOM_ask_env_var UGII_CAM_POST_DIR]


set vnc_base_sourced 0


if { !$vnc_base_sourced } {


#=============================================================
proc VNC_ask_shared_library_suffix { } {
#=============================================================
   global tcl_platform

   set suffix ""
   set suffix [string trimleft [info sharedlibextension] .]

   if { [string match "" $suffix] } {

      if { [string match "*windows*" $tcl_platform(platform)] } {

         set suffix dll

      } else {

         if { [string match "*HP-UX*" $tcl_platform(os)] } {
            set suffix sl
         } elseif { [string match "*AIX*" $tcl_platform(os)] } {
            set suffix a
         } else {
            set suffix so
         }
      }
   }

return $suffix
}


set suff  [VNC_ask_shared_library_suffix]


if { ![file exists ${cam_aux_dir}mom_source.$suff] } {
   set suff so
}

if { ![file exists ${cam_aux_dir}mom_source.$suff] } {

   set __msg "ERROR in [info script] :\n\
             \nShared library \"mom_source\" is not found in ${cam_aux_dir}."

   catch { SIM_mtd_reset }
   MOM_abort $__msg
}

if { ![file exists ${cam_post_dir}vnc_base_v750_tcl.txt] } {

   set __msg "ERROR in [info script] :\n\
             \n\"vnc_base_v750_tcl.txt\" is not found in ${cam_post_dir}."

   catch { SIM_mtd_reset }
   MOM_abort $__msg
}


catch {
   MOM_run_user_function ${cam_aux_dir}mom_source.$suff ufusr
   MOM_decrypt_source ${cam_post_dir}vnc_base_v750_tcl.txt
}


#----------------------------------------------
# Validate correct version of vnc_base sourced.
#----------------------------------------------
if { ![info exists mom_sim_vnc_base_version] || \
      [string compare "7.5.0" $mom_sim_vnc_base_version] > 0 } {

   set __msg "ERROR :\n\
             \nWrong version of \"vnc_base_v750_tcl.txt\" has been detected.\
             \nCorrect version can be found in POSTBUILD directory.\
             \nPlease copy it to your ${cam_post_dir} directory."

   catch { SIM_mtd_reset }
   MOM_abort $__msg
}


} ;# vnc_base sourced



#**************************************
# Activate PB built revPost as default
#**************************************
if { ![info exists mom_sim_post_builder_rev_post] } {
   set mom_sim_post_builder_rev_post 1
}

if { $mom_sim_post_builder_rev_post } {

   proc MOM__util_print { line } {}

   #=============================================================
   proc MOM_SIM_execute_nc_command { } {
   #=============================================================
      PB_SIM_call PB_CMD_vnc__execute_nc_command
   }
}


set sim_mtd_initialized 1

} ;# if { $sim_mtd_initialized == 0 }


# Clean up sub-VNC handlers
#
if { [llength [info commands "PB_CMD_vnc__set_nc_definitions"]] } {
   rename PB_CMD_vnc__set_nc_definitions ""
}
if { [llength [info commands "PB_CMD_vnc__sim_other_devices"]] } {
   rename PB_CMD_vnc__sim_other_devices ""
}
if { [llength [info commands "PB_CMD_vnc__process_nc_block"]] } {
   rename PB_CMD_vnc__process_nc_block ""
}


# Clean up main-VNC handlers
#
if { [llength [info commands "PB_CMD_vnc____config_machine_tool_axes"]] } {
   rename PB_CMD_vnc____config_machine_tool_axes ""
}
if { [llength [info commands "PB_CMD_vnc____config_nc_definitions"]] } {
   rename PB_CMD_vnc____config_nc_definitions ""
}



#=============================================================
proc VNC_load_post_definitions { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_word_separator mom_sim_word_separator_len
  global mom_sim_end_of_block mom_sim_end_of_block_len
  global mom_sim_opskip_block_leader
  global mom_sim_home_pos
  global mom_sim_address
  global mom_sim_format
  global mom_sim_wcs_offsets
  global mom_sim_nc_register
  global mom_sim_nc_func
  global mom_sim_circular_vector
  global mom_sim_arc_output_mode
  global mom_sim_machine_type
  global mom_sim_num_machine_axes
  global mom_sim_advanced_kinematic_jct
  global mom_sim_4th_axis_plane mom_sim_5th_axis_plane
  global mom_sim_reverse_4th_table mom_sim_reverse_5th_table
  global mom_sim_cycle_mode
  global mom_sim_x_double mom_sim_i_double
  global mom_sim_y_double mom_sim_j_double
  global mom_sim_x_factor mom_sim_y_factor mom_sim_z_factor
  global mom_sim_i_factor mom_sim_j_factor mom_sim_k_factor
  global mom_sim_output_unit
  global mom_sim_cycle_feed_to_addr
  global mom_sim_pivot_distance
  global mom_sim_4th_axis_angle_offset mom_sim_5th_axis_angle_offset
  global mom_sim_4th_axis_direction mom_sim_5th_axis_direction
  global mom_sim_4th_axis_max_limit mom_sim_5th_axis_max_limit
  global mom_sim_4th_axis_min_limit mom_sim_5th_axis_min_limit
  global mom_sim_output_reference_method
  global mom_sim_rapid_feed_rate
  global mom_sim_4th_axis_has_limits mom_sim_5th_axis_has_limits
  global mom_sim_max_dpm mom_sim_min_dpm
  global mom_sim_max_fpm mom_sim_min_fpm
  global mom_sim_max_fpr mom_sim_min_fpr
  global mom_sim_max_frn mom_sim_min_frn
  global mom_sim_cycle_feed_mode
  global mom_sim_contour_feed_mode
  global mom_sim_rapid_feed_mode
  global mom_sim_feed_param
  global mom_sim_tool_change_time

  global mom_sim_PI mom_sim_csys_set
  global mom_sim_vnc_msg_prefix


   set mom_sim_vnc_msg_prefix                         "VNC_MSG::"

   set mom_sim_PI                                     [expr acos(-1.0)]

   if { ![info exists mom_sim_csys_set] } {
      set mom_sim_csys_set                            0
   }


   set mom_sim_control_out                            "; "
   set mom_sim_control_in                             ""

   set mom_sim_word_separator                         " "
   set mom_sim_word_separator_len                     "1"

   set mom_sim_end_of_block                           ""
   set mom_sim_end_of_block_len                       "0"

   set mom_sim_opskip_block_leader                    "/"

   set mom_sim_home_pos(0)                            "0.0"
   set mom_sim_home_pos(1)                            "0.0"
   set mom_sim_home_pos(2)                            "0.0"

   set mom_sim_circular_vector                        "Vector - Absolute Arc Center"
   set mom_sim_arc_output_mode                        "FULL_CIRCLE"
   set mom_sim_output_unit                            "IN"
   set mom_sim_rapid_feed_rate                        "400.0"
   set mom_sim_machine_type                           "5_axis_head_table"
   set mom_sim_num_machine_axes                       "5"

   if { [info exists mom_sim_advanced_kinematic_jct] } {
      unset mom_sim_advanced_kinematic_jct
   }

   set mom_sim_reverse_4th_table                      "0"
   set mom_sim_reverse_5th_table                      "0"
   set mom_sim_4th_axis_plane                         "ZX"
   set mom_sim_5th_axis_plane                         "XY"
   set mom_sim_pivot_distance                         "0.0"
   set mom_sim_4th_axis_angle_offset                  "0.0"
   set mom_sim_5th_axis_angle_offset                  "0.0"
   set mom_sim_4th_axis_direction                     "MAGNITUDE_DETERMINES_DIRECTION"
   set mom_sim_5th_axis_direction                     "MAGNITUDE_DETERMINES_DIRECTION"
   set mom_sim_4th_axis_min_limit                     "0.0"
   set mom_sim_4th_axis_max_limit                     "360.0"
   set mom_sim_5th_axis_min_limit                     "0.0"
   set mom_sim_5th_axis_max_limit                     "360.0"
   set mom_sim_4th_axis_has_limits                    "1"
   set mom_sim_5th_axis_has_limits                    "1"

   set mom_sim_max_dpm                                "10.0"
   set mom_sim_max_fpm                                "600.0"
   set mom_sim_max_fpr                                "100.0"
   set mom_sim_max_frn                                "1000.0"
   set mom_sim_min_dpm                                "0.0"
   set mom_sim_min_fpm                                "0.1"
   set mom_sim_min_fpr                                "0.01"
   set mom_sim_min_frn                                "0.01"
   set mom_sim_tool_change_time                       "10.0"
   set mom_sim_cycle_feed_mode                        "IPM"
   set mom_sim_contour_feed_mode(LINEAR)              "IPM"
   set mom_sim_contour_feed_mode(ROTARY)              "IPM"
   set mom_sim_contour_feed_mode(LINEAR_ROTARY)       "IPM"
   set mom_sim_rapid_feed_mode(LINEAR)                "IPM"
   set mom_sim_rapid_feed_mode(ROTARY)                "IPM"
   set mom_sim_rapid_feed_mode(LINEAR_ROTARY)         "IPM"
   set mom_sim_feed_param(IPM,format)                 "Feed_IPM"
   set mom_sim_feed_param(IPR,format)                 "Feed_IPR"
   set mom_sim_feed_param(FRN,format)                 "Feed_INV"
   set mom_sim_feed_param(DPM,format)                 "Feed_DPM"
   set mom_sim_feed_param(MMPM,format)                "Feed_MMPM"
   set mom_sim_feed_param(MMPR,format)                "Feed_MMPR"

   set mom_sim_cycle_feed_to_addr                     "Z"
   set mom_sim_cycle_mode(feed_to)                    "Position"
   set mom_sim_cycle_mode(rapid_to)                   "None"
   set mom_sim_cycle_mode(retract_to)                 "None"
   set mom_sim_cycle_mode(start_block)                "1"

   set mom_sim_x_double                               "1"
   set mom_sim_i_double                               "1"
   set mom_sim_y_double                               "1"
   set mom_sim_j_double                               "1"
   set mom_sim_x_factor                               "1"
   set mom_sim_y_factor                               "1"
   set mom_sim_z_factor                               "1"
   set mom_sim_i_factor                               "1"
   set mom_sim_j_factor                               "1"
   set mom_sim_k_factor                               "1"

   set mom_sim_output_reference_method                "TOOL_TIP"

   set mom_sim_address(I,leader)                      "X"
   set mom_sim_address(I,leader_len)                  "1"
   set mom_sim_address(I,trailer)                     ""
   set mom_sim_address(I,trailer_len)                 "0"
   set mom_sim_address(I,modal)                       "1"
   set mom_sim_address(I,format)                      "Coordinate"

   set mom_sim_address(G_plane,leader)                "G"
   set mom_sim_address(G_plane,leader_len)            "1"
   set mom_sim_address(G_plane,trailer)               ""
   set mom_sim_address(G_plane,trailer_len)           "0"
   set mom_sim_address(G_plane,modal)                 "1"
   set mom_sim_address(G_plane,format)                "Digit_2"

   set mom_sim_nc_func(PLANE_XY)                      "G17"
   set mom_sim_nc_func(PLANE_ZX)                      "G18"
   set mom_sim_nc_func(PLANE_YZ)                      "G19"

   set mom_sim_address(G_adjust,leader)               "G"
   set mom_sim_address(G_adjust,leader_len)           "1"
   set mom_sim_address(G_adjust,trailer)              ""
   set mom_sim_address(G_adjust,trailer_len)          "0"
   set mom_sim_address(G_adjust,modal)                "1"
   set mom_sim_address(G_adjust,format)               "Digit_2"

   set mom_sim_nc_func(TL_ADJUST_PLUS)                "G43"
   set mom_sim_nc_func(TL_ADJUST_MINUS)               "G44"
   set mom_sim_nc_func(TL_ADJUST_CANCEL)              "G49"

   set mom_sim_address(G_feed,leader)                 "G"
   set mom_sim_address(G_feed,leader_len)             "1"
   set mom_sim_address(G_feed,trailer)                ""
   set mom_sim_address(G_feed,trailer_len)            "0"
   set mom_sim_address(G_feed,modal)                  "1"
   set mom_sim_address(G_feed,format)                 "Digit_2"

   set mom_sim_nc_func(FEED_IPM)                      "G94"
   set mom_sim_nc_func(FEED_IPR)                      "G95"
   set mom_sim_nc_func(FEED_MMPM)                     "G94"
   set mom_sim_nc_func(FEED_MMPR)                     "G95"
   set mom_sim_nc_func(FEED_FRN)                      "G93"

   set mom_sim_address(G_spin,leader)                 "G"
   set mom_sim_address(G_spin,leader_len)             "1"
   set mom_sim_address(G_spin,trailer)                ""
   set mom_sim_address(G_spin,trailer_len)            "0"
   set mom_sim_address(G_spin,modal)                  "1"
   set mom_sim_address(G_spin,format)                 "Digit_2"

   set mom_sim_nc_func(SPEED_SFM)                     "G96"
   set mom_sim_nc_func(SPEED_SMM)                     "G96"
   set mom_sim_nc_func(SPEED_RPM)                     "G97"

   set mom_sim_address(G_return,leader)               "G"
   set mom_sim_address(G_return,leader_len)           "1"
   set mom_sim_address(G_return,trailer)              ""
   set mom_sim_address(G_return,trailer_len)          "0"
   set mom_sim_address(G_return,modal)                "1"
   set mom_sim_address(G_return,format)               "Digit_2"

   set mom_sim_nc_func(CYCLE_RETURN_AUTO)             "G98"
   set mom_sim_nc_func(CYCLE_RETURN_MANUAL)           "G99"

   set mom_sim_address(G_motion,leader)               ""
   set mom_sim_address(G_motion,leader_len)           "0"
   set mom_sim_address(G_motion,trailer)              ""
   set mom_sim_address(G_motion,trailer_len)          "0"
   set mom_sim_address(G_motion,modal)                "1"
   set mom_sim_address(G_motion,format)               "Digit_2"

   set mom_sim_nc_func(MOTION_RAPID)                  "L"
   set mom_sim_nc_func(MOTION_LINEAR)                 "L"
   set mom_sim_nc_func(MOTION_CIRCULAR_CLW)           "DR-"
   set mom_sim_nc_func(MOTION_CIRCULAR_CCLW)          "DR+"

   set mom_sim_address(G_mode,leader)                 "G"
   set mom_sim_address(G_mode,leader_len)             "1"
   set mom_sim_address(G_mode,trailer)                ""
   set mom_sim_address(G_mode,trailer_len)            "0"
   set mom_sim_address(G_mode,modal)                  "1"
   set mom_sim_address(G_mode,format)                 "Digit_2"

   set mom_sim_nc_func(INPUT_ABS)                     "G90"
   set mom_sim_nc_func(INPUT_INC)                     "G91"

   set mom_sim_address(G,leader)                      "G"
   set mom_sim_address(G,leader_len)                  "1"
   set mom_sim_address(G,trailer)                     ""
   set mom_sim_address(G,trailer_len)                 "0"
   set mom_sim_address(G,modal)                       "1"
   set mom_sim_address(G,format)                      "Digit_2"

   set mom_sim_nc_func(DELAY_SEC)                     "G4"
   set mom_sim_nc_func(DELAY_REV)                     "G4"
   set mom_sim_nc_func(WORK_CS_RESET)                 "G92"
   set mom_sim_nc_func(RETURN_HOME)                   "G28"
   set mom_sim_nc_func(UNIT_IN)                       "G70"
   set mom_sim_nc_func(UNIT_MM)                       "G71"

   set mom_sim_address(X,leader)                      "X"
   set mom_sim_address(X,leader_len)                  "1"
   set mom_sim_address(X,trailer)                     ""
   set mom_sim_address(X,trailer_len)                 "0"
   set mom_sim_address(X,modal)                       "1"
   set mom_sim_address(X,format)                      "Coordinate"

   set mom_sim_address(Y,leader)                      "Y"
   set mom_sim_address(Y,leader_len)                  "1"
   set mom_sim_address(Y,trailer)                     ""
   set mom_sim_address(Y,trailer_len)                 "0"
   set mom_sim_address(Y,modal)                       "1"
   set mom_sim_address(Y,format)                      "Coordinate"

   set mom_sim_address(Z,leader)                      "Z"
   set mom_sim_address(Z,leader_len)                  "1"
   set mom_sim_address(Z,trailer)                     ""
   set mom_sim_address(Z,trailer_len)                 "0"
   set mom_sim_address(Z,modal)                       "1"
   set mom_sim_address(Z,format)                      "Coordinate"

   set mom_sim_address(fourth_axis,leader)            "B"
   set mom_sim_address(fourth_axis,leader_len)        "1"
   set mom_sim_address(fourth_axis,trailer)           ""
   set mom_sim_address(fourth_axis,trailer_len)       "0"
   set mom_sim_address(fourth_axis,modal)             "1"
   set mom_sim_address(fourth_axis,format)            "Coordinate"

   set mom_sim_address(fifth_axis,leader)             "C"
   set mom_sim_address(fifth_axis,leader_len)         "1"
   set mom_sim_address(fifth_axis,trailer)            ""
   set mom_sim_address(fifth_axis,trailer_len)        "0"
   set mom_sim_address(fifth_axis,modal)              "1"
   set mom_sim_address(fifth_axis,format)             "Coordinate"

   set mom_sim_address(J,leader)                      "Y"
   set mom_sim_address(J,leader_len)                  "1"
   set mom_sim_address(J,trailer)                     ""
   set mom_sim_address(J,trailer_len)                 "0"
   set mom_sim_address(J,modal)                       "1"
   set mom_sim_address(J,format)                      "Coordinate"

   set mom_sim_address(K,leader)                      "Z"
   set mom_sim_address(K,leader_len)                  "1"
   set mom_sim_address(K,trailer)                     ""
   set mom_sim_address(K,trailer_len)                 "0"
   set mom_sim_address(K,modal)                       "1"
   set mom_sim_address(K,format)                      "Coordinate"

   set mom_sim_address(R,leader)                      "R"
   set mom_sim_address(R,leader_len)                  "1"
   set mom_sim_address(R,trailer)                     ""
   set mom_sim_address(R,trailer_len)                 "0"
   set mom_sim_address(R,modal)                       "1"
   set mom_sim_address(R,format)                      "Coordinate"

   set mom_sim_address(M128,leader)                   "M"
   set mom_sim_address(M128,leader_len)               "1"
   set mom_sim_address(M128,trailer)                  ""
   set mom_sim_address(M128,trailer_len)              "0"
   set mom_sim_address(M128,modal)                    "1"
   set mom_sim_address(M128,format)                   "AbsCoord"

   set mom_sim_address(F,leader)                      "F"
   set mom_sim_address(F,leader_len)                  "1"
   set mom_sim_address(F,trailer)                     ""
   set mom_sim_address(F,trailer_len)                 "0"
   set mom_sim_address(F,modal)                       "1"
   set mom_sim_address(F,format)                      "Feed"

   set mom_sim_address(FMAX,leader)                   "F"
   set mom_sim_address(FMAX,leader_len)               "1"
   set mom_sim_address(FMAX,trailer)                  ""
   set mom_sim_address(FMAX,trailer_len)              "0"
   set mom_sim_address(FMAX,modal)                    "1"
   set mom_sim_address(FMAX,format)                   "String"

   set mom_sim_address(T,leader)                      " "
   set mom_sim_address(T,leader_len)                  "1"
   set mom_sim_address(T,trailer)                     ""
   set mom_sim_address(T,trailer_len)                 "0"
   set mom_sim_address(T,modal)                       "1"
   set mom_sim_address(T,format)                      "Tcode"

   set mom_sim_address(S,leader)                      "S"
   set mom_sim_address(S,leader_len)                  "1"
   set mom_sim_address(S,trailer)                     ""
   set mom_sim_address(S,trailer_len)                 "0"
   set mom_sim_address(S,modal)                       "1"
   set mom_sim_address(S,format)                      "Digit_5"

   set mom_sim_address(D,leader)                      "D"
   set mom_sim_address(D,leader_len)                  "1"
   set mom_sim_address(D,trailer)                     ""
   set mom_sim_address(D,trailer_len)                 "0"
   set mom_sim_address(D,modal)                       "1"
   set mom_sim_address(D,format)                      "Digit_2"

   set mom_sim_address(H,leader)                      "H"
   set mom_sim_address(H,leader_len)                  "1"
   set mom_sim_address(H,trailer)                     ""
   set mom_sim_address(H,trailer_len)                 "0"
   set mom_sim_address(H,modal)                       "1"
   set mom_sim_address(H,format)                      "Hcode"

   set mom_sim_address(dwell,leader)                  "P"
   set mom_sim_address(dwell,leader_len)              "1"
   set mom_sim_address(dwell,trailer)                 ""
   set mom_sim_address(dwell,trailer_len)             "0"
   set mom_sim_address(dwell,modal)                   "1"
   set mom_sim_address(dwell,format)                  "Dwell_sec"

   set mom_sim_address(cycle_dwell,leader)            "Q211="
   set mom_sim_address(cycle_dwell,leader_len)        "5"
   set mom_sim_address(cycle_dwell,trailer)           ""
   set mom_sim_address(cycle_dwell,trailer_len)       "0"
   set mom_sim_address(cycle_dwell,modal)             "1"
   set mom_sim_address(cycle_dwell,format)            "Dwell_sec"

   set mom_sim_address(P_cutcom,leader)               "P"
   set mom_sim_address(P_cutcom,leader_len)           "1"
   set mom_sim_address(P_cutcom,trailer)              ""
   set mom_sim_address(P_cutcom,trailer_len)          "0"
   set mom_sim_address(P_cutcom,modal)                "1"
   set mom_sim_address(P_cutcom,format)               "Dwell_sec"

   set mom_sim_address(K_cycle,leader)                "K"
   set mom_sim_address(K_cycle,leader_len)            "1"
   set mom_sim_address(K_cycle,trailer)               ""
   set mom_sim_address(K_cycle,trailer_len)           "0"
   set mom_sim_address(K_cycle,modal)                 "1"
   set mom_sim_address(K_cycle,format)                "Coordinate"

   set mom_sim_address(cycle_step1,leader)            "I"
   set mom_sim_address(cycle_step1,leader_len)        "1"
   set mom_sim_address(cycle_step1,trailer)           ""
   set mom_sim_address(cycle_step1,trailer_len)       "0"
   set mom_sim_address(cycle_step1,modal)             "1"
   set mom_sim_address(cycle_step1,format)            "Coordinate"

   set mom_sim_address(cycle_step,leader)             "Q"
   set mom_sim_address(cycle_step,leader_len)         "1"
   set mom_sim_address(cycle_step,trailer)            ""
   set mom_sim_address(cycle_step,trailer_len)        "0"
   set mom_sim_address(cycle_step,modal)              "1"
   set mom_sim_address(cycle_step,format)             "Coordinate"

   set mom_sim_address(Q_cutcom,leader)               "Q"
   set mom_sim_address(Q_cutcom,leader_len)           "1"
   set mom_sim_address(Q_cutcom,trailer)              ""
   set mom_sim_address(Q_cutcom,trailer_len)          "0"
   set mom_sim_address(Q_cutcom,modal)                "1"
   set mom_sim_address(Q_cutcom,format)               "Coordinate"

   set mom_sim_address(E,leader)                      "E"
   set mom_sim_address(E,leader_len)                  "1"
   set mom_sim_address(E,trailer)                     ""
   set mom_sim_address(E,trailer_len)                 "0"
   set mom_sim_address(E,modal)                       "1"
   set mom_sim_address(E,format)                      "Coordinate"

   set mom_sim_address(M_spindle,leader)              "M"
   set mom_sim_address(M_spindle,leader_len)          "1"
   set mom_sim_address(M_spindle,trailer)             ""
   set mom_sim_address(M_spindle,trailer_len)         "0"
   set mom_sim_address(M_spindle,modal)               "1"
   set mom_sim_address(M_spindle,format)              "Digit_2"

   set mom_sim_nc_func(SPINDLE_CLW)                   "M3"
   set mom_sim_nc_func(SPINDLE_CCLW)                  "M4"
   set mom_sim_nc_func(SPINDLE_OFF)                   "M5"

   set mom_sim_address(M_range,leader)                "M"
   set mom_sim_address(M_range,leader_len)            "1"
   set mom_sim_address(M_range,trailer)               ""
   set mom_sim_address(M_range,trailer_len)           "0"
   set mom_sim_address(M_range,modal)                 "1"
   set mom_sim_address(M_range,format)                "Digit_2"

   set mom_sim_address(M_coolant,leader)              "M"
   set mom_sim_address(M_coolant,leader_len)          "1"
   set mom_sim_address(M_coolant,trailer)             ""
   set mom_sim_address(M_coolant,trailer_len)         "0"
   set mom_sim_address(M_coolant,modal)               "1"
   set mom_sim_address(M_coolant,format)              "Digit_2"

   set mom_sim_nc_func(COOLANT_ON)                    "M8"
   set mom_sim_nc_func(COOLANT_FLOOD)                 "M8"
   set mom_sim_nc_func(COOLANT_MIST)                  "M7"
   set mom_sim_nc_func(COOLANT_THRU)                  "M26"
   set mom_sim_nc_func(COOLANT_TAP)                   "M8"
   set mom_sim_nc_func(COOLANT_OFF)                   "M9"

   set mom_sim_address(M,leader)                      "M"
   set mom_sim_address(M,leader_len)                  "1"
   set mom_sim_address(M,trailer)                     ""
   set mom_sim_address(M,trailer_len)                 "0"
   set mom_sim_address(M,modal)                       "1"
   set mom_sim_address(M,format)                      "Digit_2"

   set mom_sim_nc_func(PROG_STOP)                     "M0"
   set mom_sim_nc_func(PROG_OPSTOP)                   "M1"
   set mom_sim_nc_func(PROG_END)                      "M2"
   set mom_sim_nc_func(TOOL_CHANGE)                   "M6"
   set mom_sim_nc_func(PROG_STOP_REWIND)              "M30"

   set mom_sim_address(circle_direction,leader)       ""
   set mom_sim_address(circle_direction,leader_len)   "0"
   set mom_sim_address(circle_direction,trailer)      ""
   set mom_sim_address(circle_direction,trailer_len)  "0"
   set mom_sim_address(circle_direction,modal)        "1"
   set mom_sim_address(circle_direction,format)       "String"

   set mom_sim_address(cutter_comp,leader)            ""
   set mom_sim_address(cutter_comp,leader_len)        "0"
   set mom_sim_address(cutter_comp,trailer)           ""
   set mom_sim_address(cutter_comp,trailer_len)       "0"
   set mom_sim_address(cutter_comp,modal)             "1"
   set mom_sim_address(cutter_comp,format)            "String"

   set mom_sim_address(G_cutcom,leader)               ""
   set mom_sim_address(G_cutcom,leader_len)           "0"
   set mom_sim_address(G_cutcom,trailer)              ""
   set mom_sim_address(G_cutcom,trailer_len)          "0"
   set mom_sim_address(G_cutcom,modal)                "1"
   set mom_sim_address(G_cutcom,format)               "Digit_2"

   set mom_sim_nc_func(CUTCOM_LEFT)                   "RL"
   set mom_sim_nc_func(CUTCOM_RIGHT)                  "RR"
   set mom_sim_nc_func(CUTCOM_OFF)                    "R0"

   set mom_sim_address(TL,leader)                     "L"
   set mom_sim_address(TL,leader_len)                 "1"
   set mom_sim_address(TL,trailer)                    ""
   set mom_sim_address(TL,trailer_len)                "0"
   set mom_sim_address(TL,modal)                      "1"
   set mom_sim_address(TL,format)                     "Coordinate"

   set mom_sim_address(TR,leader)                     "R"
   set mom_sim_address(TR,leader_len)                 "1"
   set mom_sim_address(TR,trailer)                    ""
   set mom_sim_address(TR,trailer_len)                "0"
   set mom_sim_address(TR,modal)                      "1"
   set mom_sim_address(TR,format)                     "Coordinate"

   set mom_sim_address(N,leader)                      ""
   set mom_sim_address(N,leader_len)                  "0"
   set mom_sim_address(N,trailer)                     ""
   set mom_sim_address(N,trailer_len)                 "0"
   set mom_sim_address(N,modal)                       "1"
   set mom_sim_address(N,format)                      "Digit_4"

   set mom_sim_address(Text,leader)                   ""
   set mom_sim_address(Text,leader_len)               "0"
   set mom_sim_address(Text,trailer)                  ""
   set mom_sim_address(Text,trailer_len)              "0"
   set mom_sim_address(Text,modal)                    "1"
   set mom_sim_address(Text,format)                   "String"

   set mom_sim_format(AbsCoord,type)                  "Numeral"
   set mom_sim_format(AbsCoord,plus)                  "0"
   set mom_sim_format(AbsCoord,lead_zero)             "0"
   set mom_sim_format(AbsCoord,integer)               "5"
   set mom_sim_format(AbsCoord,decimal)               "1"
   set mom_sim_format(AbsCoord,fraction)              "4"
   set mom_sim_format(AbsCoord,trail_zero)            "0"

   set mom_sim_format(Coordinate,type)                "Numeral"
   set mom_sim_format(Coordinate,plus)                "0"
   set mom_sim_format(Coordinate,lead_zero)           "0"
   set mom_sim_format(Coordinate,integer)             "4"
   set mom_sim_format(Coordinate,decimal)             "1"
   set mom_sim_format(Coordinate,fraction)            "4"
   set mom_sim_format(Coordinate,trail_zero)          "0"

   set mom_sim_format(Digit_2,type)                   "Text String"
   set mom_sim_format(Digit_2,plus)                   "0"
   set mom_sim_format(Digit_2,lead_zero)              "0"
   set mom_sim_format(Digit_2,integer)                ""
   set mom_sim_format(Digit_2,decimal)                "0"
   set mom_sim_format(Digit_2,fraction)               ""
   set mom_sim_format(Digit_2,trail_zero)             "0"

   set mom_sim_format(Digit_3,type)                   "Numeral"
   set mom_sim_format(Digit_3,plus)                   "0"
   set mom_sim_format(Digit_3,lead_zero)              "0"
   set mom_sim_format(Digit_3,integer)                "3"
   set mom_sim_format(Digit_3,decimal)                "0"
   set mom_sim_format(Digit_3,fraction)               "0"
   set mom_sim_format(Digit_3,trail_zero)             "1"

   set mom_sim_format(Digit_4,type)                   "Numeral"
   set mom_sim_format(Digit_4,plus)                   "0"
   set mom_sim_format(Digit_4,lead_zero)              "1"
   set mom_sim_format(Digit_4,integer)                "4"
   set mom_sim_format(Digit_4,decimal)                "0"
   set mom_sim_format(Digit_4,fraction)               "0"
   set mom_sim_format(Digit_4,trail_zero)             "1"

   set mom_sim_format(Digit_5,type)                   "Numeral"
   set mom_sim_format(Digit_5,plus)                   "0"
   set mom_sim_format(Digit_5,lead_zero)              "0"
   set mom_sim_format(Digit_5,integer)                "5"
   set mom_sim_format(Digit_5,decimal)                "0"
   set mom_sim_format(Digit_5,fraction)               "0"
   set mom_sim_format(Digit_5,trail_zero)             "1"

   set mom_sim_format(Dwell_SECONDS,type)             "Numeral"
   set mom_sim_format(Dwell_SECONDS,plus)             "0"
   set mom_sim_format(Dwell_SECONDS,lead_zero)        "0"
   set mom_sim_format(Dwell_SECONDS,integer)          "5"
   set mom_sim_format(Dwell_SECONDS,decimal)          "1"
   set mom_sim_format(Dwell_SECONDS,fraction)         "3"
   set mom_sim_format(Dwell_SECONDS,trail_zero)       "0"

   set mom_sim_format(Dwell_sec,type)                 "Numeral"
   set mom_sim_format(Dwell_sec,plus)                 "0"
   set mom_sim_format(Dwell_sec,lead_zero)            "0"
   set mom_sim_format(Dwell_sec,integer)              "5"
   set mom_sim_format(Dwell_sec,decimal)              "1"
   set mom_sim_format(Dwell_sec,fraction)             "3"
   set mom_sim_format(Dwell_sec,trail_zero)           "0"

   set mom_sim_format(EventNum,type)                  "Numeral"
   set mom_sim_format(EventNum,plus)                  "1"
   set mom_sim_format(EventNum,lead_zero)             "1"
   set mom_sim_format(EventNum,integer)               "3"
   set mom_sim_format(EventNum,decimal)               "0"
   set mom_sim_format(EventNum,fraction)              "0"
   set mom_sim_format(EventNum,trail_zero)            "1"

   set mom_sim_format(Feed,type)                      "Numeral"
   set mom_sim_format(Feed,plus)                      "0"
   set mom_sim_format(Feed,lead_zero)                 "0"
   set mom_sim_format(Feed,integer)                   "7"
   set mom_sim_format(Feed,decimal)                   "1"
   set mom_sim_format(Feed,fraction)                  "2"
   set mom_sim_format(Feed,trail_zero)                "0"

   set mom_sim_format(Feed_DPM,type)                  "Numeral"
   set mom_sim_format(Feed_DPM,plus)                  "0"
   set mom_sim_format(Feed_DPM,lead_zero)             "0"
   set mom_sim_format(Feed_DPM,integer)               "5"
   set mom_sim_format(Feed_DPM,decimal)               "1"
   set mom_sim_format(Feed_DPM,fraction)              "2"
   set mom_sim_format(Feed_DPM,trail_zero)            "0"

   set mom_sim_format(Feed_FRN,type)                  "Numeral"
   set mom_sim_format(Feed_FRN,plus)                  "0"
   set mom_sim_format(Feed_FRN,lead_zero)             "0"
   set mom_sim_format(Feed_FRN,integer)               "5"
   set mom_sim_format(Feed_FRN,decimal)               "1"
   set mom_sim_format(Feed_FRN,fraction)              "3"
   set mom_sim_format(Feed_FRN,trail_zero)            "0"

   set mom_sim_format(Feed_INV,type)                  "Numeral"
   set mom_sim_format(Feed_INV,plus)                  "0"
   set mom_sim_format(Feed_INV,lead_zero)             "0"
   set mom_sim_format(Feed_INV,integer)               "5"
   set mom_sim_format(Feed_INV,decimal)               "1"
   set mom_sim_format(Feed_INV,fraction)              "3"
   set mom_sim_format(Feed_INV,trail_zero)            "0"

   set mom_sim_format(Feed_IPM,type)                  "Numeral"
   set mom_sim_format(Feed_IPM,plus)                  "0"
   set mom_sim_format(Feed_IPM,lead_zero)             "0"
   set mom_sim_format(Feed_IPM,integer)               "4"
   set mom_sim_format(Feed_IPM,decimal)               "1"
   set mom_sim_format(Feed_IPM,fraction)              "1"
   set mom_sim_format(Feed_IPM,trail_zero)            "0"

   set mom_sim_format(Feed_IPR,type)                  "Numeral"
   set mom_sim_format(Feed_IPR,plus)                  "0"
   set mom_sim_format(Feed_IPR,lead_zero)             "0"
   set mom_sim_format(Feed_IPR,integer)               "1"
   set mom_sim_format(Feed_IPR,decimal)               "1"
   set mom_sim_format(Feed_IPR,fraction)              "4"
   set mom_sim_format(Feed_IPR,trail_zero)            "0"

   set mom_sim_format(Feed_MMPM,type)                 "Numeral"
   set mom_sim_format(Feed_MMPM,plus)                 "0"
   set mom_sim_format(Feed_MMPM,lead_zero)            "0"
   set mom_sim_format(Feed_MMPM,integer)              "5"
   set mom_sim_format(Feed_MMPM,decimal)              "1"
   set mom_sim_format(Feed_MMPM,fraction)             "0"
   set mom_sim_format(Feed_MMPM,trail_zero)           "0"

   set mom_sim_format(Feed_MMPR,type)                 "Numeral"
   set mom_sim_format(Feed_MMPR,plus)                 "0"
   set mom_sim_format(Feed_MMPR,lead_zero)            "0"
   set mom_sim_format(Feed_MMPR,integer)              "2"
   set mom_sim_format(Feed_MMPR,decimal)              "1"
   set mom_sim_format(Feed_MMPR,fraction)             "3"
   set mom_sim_format(Feed_MMPR,trail_zero)           "0"

   set mom_sim_format(Hcode,type)                     "Numeral"
   set mom_sim_format(Hcode,plus)                     "0"
   set mom_sim_format(Hcode,lead_zero)                "1"
   set mom_sim_format(Hcode,integer)                  "2"
   set mom_sim_format(Hcode,decimal)                  "0"
   set mom_sim_format(Hcode,fraction)                 "0"
   set mom_sim_format(Hcode,trail_zero)               "1"

   set mom_sim_format(Rev,type)                       "Numeral"
   set mom_sim_format(Rev,plus)                       "0"
   set mom_sim_format(Rev,lead_zero)                  "0"
   set mom_sim_format(Rev,integer)                    "4"
   set mom_sim_format(Rev,decimal)                    "0"
   set mom_sim_format(Rev,fraction)                   "0"
   set mom_sim_format(Rev,trail_zero)                 "1"

   set mom_sim_format(Rotary,type)                    "Numeral"
   set mom_sim_format(Rotary,plus)                    "0"
   set mom_sim_format(Rotary,lead_zero)               "0"
   set mom_sim_format(Rotary,integer)                 "5"
   set mom_sim_format(Rotary,decimal)                 "1"
   set mom_sim_format(Rotary,fraction)                "3"
   set mom_sim_format(Rotary,trail_zero)              "0"

   set mom_sim_format(String,type)                    "Text String"
   set mom_sim_format(String,plus)                    "0"
   set mom_sim_format(String,lead_zero)               "0"
   set mom_sim_format(String,integer)                 ""
   set mom_sim_format(String,decimal)                 "0"
   set mom_sim_format(String,fraction)                ""
   set mom_sim_format(String,trail_zero)              "0"

   set mom_sim_format(Tcode,type)                     "Numeral"
   set mom_sim_format(Tcode,plus)                     "0"
   set mom_sim_format(Tcode,lead_zero)                "0"
   set mom_sim_format(Tcode,integer)                  "2"
   set mom_sim_format(Tcode,decimal)                  "0"
   set mom_sim_format(Tcode,fraction)                 "0"
   set mom_sim_format(Tcode,trail_zero)               "1"

   set mom_sim_format(Zero_int,type)                  "Numeral"
   set mom_sim_format(Zero_int,plus)                  "0"
   set mom_sim_format(Zero_int,lead_zero)             "1"
   set mom_sim_format(Zero_int,integer)               "1"
   set mom_sim_format(Zero_int,decimal)               "0"
   set mom_sim_format(Zero_int,fraction)              "0"
   set mom_sim_format(Zero_int,trail_zero)            "0"

   set mom_sim_format(Zero_real,type)                 "Numeral"
   set mom_sim_format(Zero_real,plus)                 "0"
   set mom_sim_format(Zero_real,lead_zero)            "1"
   set mom_sim_format(Zero_real,integer)              "1"
   set mom_sim_format(Zero_real,decimal)              "1"
   set mom_sim_format(Zero_real,fraction)             "1"
   set mom_sim_format(Zero_real,trail_zero)           "1"

}


#=============================================================
proc PB_CMD_vnc__G_adjust_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list {mom_sim_nc_func(TL_ADJUST_PLUS) mom_sim_nc_func(TL_ADJUST_MINUS) mom_sim_nc_func(TL_ADJUST_CANCEL)}

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }


   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(TL_ADJUST_PLUS) code] } {

           # When there's been a tool change, reset ref junction.
           # We may need to retrieve the actual tool length, if any, from H register.

            set mom_sim_nc_register(TL_ADJUST) PLUS

         } elseif { [VNC_string_match mom_sim_nc_func(TL_ADJUST_MINUS) code] } {

            set mom_sim_nc_register(TL_ADJUST) MINUS

         } elseif { [VNC_string_match mom_sim_nc_func(TL_ADJUST_CANCEL) code] } {

            set mom_sim_nc_register(TL_ADJUST) OFF

           # pb601(d) - Turn off linearization
            PB_SIM_call SIM_set_linearization OFF
         }


        # Comp tool length when needed.
         if { [string compare $mom_sim_nc_register(TL_ADJUST) "OFF"] } {

            if { [info exists mom_sim_nc_register(TOOL_CHANGED)] } {

              # Restore ref jct to tool
               global mom_sim_current_junction
               global mom_sim_tool_junction mom_sim_current_tool_junction
               if { [info exists mom_sim_current_tool_junction] && [string length $mom_sim_current_tool_junction] > 0 } {
                  set mom_sim_tool_junction "$mom_sim_current_tool_junction"
                  set mom_sim_current_junction "$mom_sim_tool_junction"
               }

               if { [info exists mom_sim_current_junction] && [string length $mom_sim_current_junction] > 0 } {
                  PB_SIM_call VNC_set_current_ref_junction $mom_sim_current_junction
               }

               VNC_unset_vars mom_sim_nc_register(TOOL_CHANGED)
            }
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__G_cutcom_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list {mom_sim_nc_func(CUTCOM_LEFT) mom_sim_nc_func(CUTCOM_RIGHT) mom_sim_nc_func(CUTCOM_OFF)}

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(CUTCOM_LEFT) code] } {

            set mom_sim_nc_register(CUTCOM) LEFT

         } elseif { [VNC_string_match mom_sim_nc_func(CUTCOM_RIGHT) code] } {

            set mom_sim_nc_register(CUTCOM) RIGHT

         } elseif { [VNC_string_match mom_sim_nc_func(CUTCOM_OFF) code] } {

            set mom_sim_nc_register(CUTCOM) OFF
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__G_feed_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   if { [string match "IN" $mom_sim_nc_register(UNIT)] } {

      set codes_list [list]

      set var_list {mom_sim_nc_func(FEED_IPM) mom_sim_nc_func(FEED_IPR) mom_sim_nc_func(FEED_FRN)}

      foreach var $var_list {
        if { [info exists $var] } {
          lappend codes_list [set $var]
        }
      }

      global mom_sim_o_buffer
      foreach code $codes_list {

         if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

            if { [VNC_string_match mom_sim_nc_func(FEED_IPM) code] } {

               set mom_sim_nc_register(FEED_MODE) INCH_PER_MIN

            } elseif { [VNC_string_match mom_sim_nc_func(FEED_IPR) code] } {

               set mom_sim_nc_register(FEED_MODE) INCH_PER_REV

            } elseif { [VNC_string_match mom_sim_nc_func(FEED_FRN) code] } {

               set mom_sim_nc_register(FEED_MODE) MM_PER_100REV
            }

         break
        }
      }

   } elseif { [string match "MM" $mom_sim_nc_register(UNIT)] } {

      set codes_list [list]

      set var_list {mom_sim_nc_func(FEED_MMPM) mom_sim_nc_func(FEED_MMPR) mom_sim_nc_func(FEED_FRN)}

      foreach var $var_list {
        if { [info exists $var] } {
          lappend codes_list [set $var]
        }
      }

      global mom_sim_o_buffer
      foreach code $codes_list {

         if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

            if { [VNC_string_match mom_sim_nc_func(FEED_MMPM) code] } {

               set mom_sim_nc_register(FEED_MODE) MM_PER_MIN

            } elseif { [VNC_string_match mom_sim_nc_func(FEED_MMPR) code] } {

               set mom_sim_nc_register(FEED_MODE) MM_PER_REV

            } elseif { [VNC_string_match mom_sim_nc_func(FEED_FRN) code] } {

               set mom_sim_nc_register(FEED_MODE) MM_PER_100REV
            }

           break
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__G_misc_code { } {
#=============================================================

  global mom_sim_pos
  global mom_sim_nc_register
  global mom_sim_nc_func
  global mom_sim_wcs_offsets
  global mom_sim_csys_data

   set codes_list [list]

   set var_list [list]
    lappend var_list mom_sim_nc_func(DELAY_SEC)
    lappend var_list mom_sim_nc_func(DELAY_REV)
    lappend var_list mom_sim_nc_func(UNIT_IN)
    lappend var_list mom_sim_nc_func(UNIT_MM)
    lappend var_list mom_sim_nc_func(RETURN_HOME)
    lappend var_list mom_sim_nc_func(RETURN_HOME_P)
    lappend var_list mom_sim_nc_func(FROM_HOME)
    lappend var_list mom_sim_nc_func(MACH_CS_MOVE)
    lappend var_list mom_sim_nc_func(LOCAL_CS_SET)
    lappend var_list mom_sim_nc_func(WORK_CS_RESET)

   foreach var $var_list {
      if { [info exists $var] } {
         lappend codes_list [set $var]
      }
   }

   set wcs_codes_list [list]
   set wcs_list [array names mom_sim_wcs_offsets]
   set ind [lsearch $wcs_list 0]
   if { $ind >= 0 } {
      set wcs_list [lreplace $wcs_list $ind $ind]
   }

   set wcsvar_list [list]

   foreach wcs $wcs_list {
      lappend wcsvar_list mom_sim_nc_func(WORK_CS_$wcs)
   }

   foreach wcsvar $wcsvar_list {
      if { [info exists $wcsvar] } {
         lappend wcs_codes_list [set $wcsvar]
         lappend codes_list [set $wcsvar]
      }
   }

   global mom_sim_o_buffer

   # Select Work Coordinate System.
   # Each set of offsets (from Machine Zero) is entered and stored in the machine.
   # G54 is selected when powered on (?).
   # Work zero point offset value can be set in a program by G10 command (??).

   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [lsearch $wcs_codes_list $code] < 0 } {

            if { [VNC_string_match mom_sim_nc_func(DELAY_SEC) code] } {

            } elseif { [VNC_string_match mom_sim_nc_func(DELAY_REV) code] } {

            } elseif { [VNC_string_match mom_sim_nc_func(UNIT_IN) code] } {

               set mom_sim_nc_register(UNIT) IN
               PB_SIM_call SIM_set_mtd_units "INCH"

            } elseif { [VNC_string_match mom_sim_nc_func(UNIT_MM) code] } {

               set mom_sim_nc_register(UNIT) MM
               PB_SIM_call SIM_set_mtd_units "MM"

            } elseif { [VNC_string_match mom_sim_nc_func(RETURN_HOME) code] } {

              # Coord specified with this command is stored as the "intermediate point" that
              # the tool will position in rapid mode before going to the reference point.
              # Intermediate point (each axis) stays modal for future G28/G29.
              #
              # This command cancels cutcom and tool offsets.
              #
              # Axes of the "intermediate point" only exist when specified. Default it to
              # the ref. pt. will not be sufficient.
              # The int. pt. floats with respect to the active WCS (G54-59).
              # Reference point is fixed on a machine.

               set mom_sim_nc_register(RETURN_HOME) 1

              # Fetch the main home position, if any.
               global mom_sim_main_home_pos mom_sim_home_pos
               if { [info exists mom_sim_main_home_pos] } {
                  set mom_sim_home_pos(0) $mom_sim_main_home_pos(0)
                  set mom_sim_home_pos(1) $mom_sim_main_home_pos(1)
                  set mom_sim_home_pos(2) $mom_sim_main_home_pos(2)
               }

            } elseif { [VNC_string_match mom_sim_nc_func(RETURN_HOME_P) code] } {

              # G30 P2 XYZ -- Return to the 2nd ref pt. P2 can be omitted.
              # G30 P3 XYZ -- Return to the 3rd ref pt.
              # G30 P4 XYZ -- Return to the 4th ref pt.
              #
              # G30 & G28 share the same intermediate point. I think?.

               set mom_sim_nc_register(RETURN_HOME_P) 1

              # Save away the main home position.
              # pb502(1) - Bug! Declare mom_sim_home_pos
               global mom_sim_main_home_pos mom_sim_home_pos
               if { ![info exists mom_sim_main_home_pos] } {
                  set mom_sim_main_home_pos(0) $mom_sim_home_pos(0)
                  set mom_sim_main_home_pos(1) $mom_sim_home_pos(1)
                  set mom_sim_main_home_pos(2) $mom_sim_home_pos(2)
               }

              # Set an auxiliary home position as the target.

            } elseif { [VNC_string_match mom_sim_nc_func(FROM_HOME) code] } {

              # This command is normally issued immediately after a G28.
              #
              # Coord specified with this function is the target that the tool will position.
              # The tool will first position from the ref. pt. to the "intermediate point"
              # that have been defined in the previous G28 command, if any, in rapid mode
              # before going to its final destination.

               set mom_sim_nc_register(FROM_HOME) 1

            } elseif { [VNC_string_match mom_sim_nc_func(MACH_CS_MOVE) code] } {

              # Moves to a position in the Machine Coordinate System (MCS).
              # The origin of MCS (Machine Zero, Machine Datum) never changes.
              # One shot instruction block. Ignored in incremental mode (G91).
              # MCS is never affected by G92 or G52 (LCS) until machine is powered off.
              # (I think, guess), G53 is used in the M06 macro for the tool change.
              #
              # ** It's ignored in (G91) incremental mode!
              # ** It's a one-shot instruction!

               if { ![string compare "ABS" $mom_sim_nc_register(INPUT)] } {

                  set mom_sim_nc_register(MCS_MOVE) 1

                 # Preserve and fake the offsets. Restore them after the move.
                  global mom_sim_prev_main_offsets mom_sim_prev_local_offsets

                  set mom_sim_prev_main_offsets  $mom_sim_nc_register(MAIN_OFFSET)
                  set mom_sim_prev_local_offsets $mom_sim_nc_register(LOCAL_OFFSET)

                  set mom_sim_nc_register(MAIN_OFFSET)  [list 0.0 0.0 0.0 0.0 0.0]
                  set mom_sim_nc_register(LOCAL_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]
                  set mom_sim_nc_register(WORK_OFFSET)  [list 0.0 0.0 0.0 0.0 0.0]


                 # Set ref. csys to Machine Zero CSYS on main ZCS component
                  global mom_sim_machine_zero_csys_matrix
                  global mom_sim_prev_csys_matrix
                  global mom_sim_csys_matrix
                  global mom_sim_prev_zcs_base mom_sim_zcs_base mom_sim_zcs_base_MCS

                  array set mom_sim_prev_csys_matrix [array get mom_sim_csys_matrix]
                  array set mom_sim_csys_matrix      [array get mom_sim_machine_zero_csys_matrix]

                  set mom_sim_prev_zcs_base $mom_sim_zcs_base
                  if { [info exists mom_sim_zcs_base_MCS] } {
                     set mom_sim_zcs_base $mom_sim_zcs_base_MCS
                  }

                  PB_SIM_call PB_CMD_vnc__set_kinematics

                  global mom_sim_csys_set
                  set mom_sim_csys_set 1

                  PB_SIM_call VNC_update_sim_pos
               }

            } elseif { [VNC_string_match mom_sim_nc_func(LOCAL_CS_SET) code] } {

              # Shift all WCS. Offsets are specified.
              #
              # Specify a local coordiante system within the active work coordinate system.
              # Change of WCS or return cancels the offsets
              # G52 IP0 (i.e. 0 0 0) or G92 command also cancels this command.

               set mom_sim_nc_register(SET_LOCAL) 1

              # Defer offsets calculation until entire block is parsed.
               set mom_sim_nc_register(LOCAL_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]

            } elseif { [VNC_string_match mom_sim_nc_func(WORK_CS_RESET) code] } {

              # Disable work coord reset if S is in the block.
              # G92 is used to set max spindle speed to S register.

               global mom_sim_address
               if { [VNC_parse_nc_block mom_sim_o_buffer $mom_sim_address(S,leader)] } {
                  return
               }

              # G92 redefines the 0th WCS (main CSYS). This can also be done with "G10 L2 P0 X Y Z",
              # MDI'ed or set by machine builder.  Both G92 & G10 observe G90/G91 mode.
              # The coordinates in the block will be used to calculate the offsets in
              # PB_CMD_vnc__reset_coordinate. No motion will be produced.
              #
              # Offsets will be added to the subsequent moves regardless of which WCS is in use.
              #
              # Subsequent reference to any of the WCS will have the offsets in effect, until
              # a Manual Reference Point Return (G28?) cancels G92 and all WCSs return to normal (??).

               set mom_sim_nc_register(RESET_WCS) 1

              # Defer offsets calculation until entire block is parsed.
               set mom_sim_nc_register(MAIN_OFFSET)  [list 0.0 0.0 0.0 0.0 0.0]

               global mom_sim_message
               set mom_sim_message "-- RESET WCS"
               PB_CMD_vnc__send_message
            }

         } else {

            foreach wcs $wcs_list {
               if { [VNC_string_match mom_sim_nc_func(WORK_CS_$wcs) code] } {
                 # Set the value of nc register according to different WCS
                  set mom_sim_nc_register(WCS) $wcs

                  set mom_sim_nc_register(WORK_OFFSET) [PB_SIM_call VNC_map_to_machine_offsets $mom_sim_wcs_offsets($mom_sim_nc_register(WCS))]

                break
               }
            }
         }


         if { [info exists mom_sim_csys_data] } {

            if { [VNC_string_match mom_sim_nc_func(MACH_CS_MOVE) code] } {

            } else {

               foreach wcs $wcs_list {

                  if { [VNC_string_match mom_sim_nc_func(WORK_CS_$wcs) code] } {

                    # Zero local offsets when change WCS
                     set mom_sim_nc_register(LOCAL_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]

                    # Zero WCS offsets, since the actual CSYS will be referenced.
                     set mom_sim_nc_register(WORK_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]

                    # Fetch actual WCS matrix per WCS selection by G54 - G59 code.
                     global mom_sim_csys_matrix

                     for { set i 0 } { $i < 12 } { incr i } {
                        set mom_sim_csys_matrix($i) $mom_sim_csys_data($mom_sim_nc_register(WCS),$i)
                     }

                     PB_SIM_call PB_CMD_vnc__set_kinematics

                     global mom_sim_csys_set
                     set mom_sim_csys_set 1

                    # Update mom_sim_pos w.r.t new ref jct
                     PB_SIM_call VNC_update_sim_pos

                    # Flag to reset (adjust) the start position in next motion. (See PB_CMD_vnc__sim_motion)
                     set mom_sim_nc_register(FIXTURE_OFFSET) 1

                   break
                  }
               }
            }
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__G_mode_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list {mom_sim_nc_func(INPUT_ABS) mom_sim_nc_func(INPUT_INC)}

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(INPUT_ABS) code] } {

            set mom_sim_nc_register(INPUT) ABS

         } elseif { [VNC_string_match mom_sim_nc_func(INPUT_INC) code] } {

            set mom_sim_nc_register(INPUT) INC
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__G_motion_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list [list]
    lappend var_list mom_sim_nc_func(MOTION_RAPID)
    lappend var_list mom_sim_nc_func(MOTION_LINEAR)
    lappend var_list mom_sim_nc_func(MOTION_CIRCULAR_CLW)
    lappend var_list mom_sim_nc_func(MOTION_CIRCULAR_CCLW)
    lappend var_list mom_sim_nc_func(CYCLE_DRILL)
    lappend var_list mom_sim_nc_func(CYCLE_DRILL_DWELL)
    lappend var_list mom_sim_nc_func(CYCLE_DRILL_DEEP)
    lappend var_list mom_sim_nc_func(CYCLE_DRILL_BREAK_CHIP)
    lappend var_list mom_sim_nc_func(CYCLE_TAP)
    lappend var_list mom_sim_nc_func(CYCLE_BORE)
    lappend var_list mom_sim_nc_func(CYCLE_BORE_DRAG)
    lappend var_list mom_sim_nc_func(CYCLE_BORE_NO_DRAG)
    lappend var_list mom_sim_nc_func(CYCLE_BORE_BACK)
    lappend var_list mom_sim_nc_func(CYCLE_BORE_MANUAL)
    lappend var_list mom_sim_nc_func(CYCLE_BORE_MANUAL_DWELL)
    lappend var_list mom_sim_nc_func(CYCLE_START)
    lappend var_list mom_sim_nc_func(CYCLE_OFF)

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(MOTION_LINEAR)                 code] } {

            set mom_sim_nc_register(MOTION) "LINEAR"

         } elseif { [VNC_string_match mom_sim_nc_func(MOTION_RAPID)            code] } {

            set mom_sim_nc_register(MOTION) "RAPID"

         } elseif { [VNC_string_match mom_sim_nc_func(MOTION_CIRCULAR_CLW)     code] } {

            set mom_sim_nc_register(MOTION) "CIRCULAR_CLW"

         } elseif { [VNC_string_match mom_sim_nc_func(MOTION_CIRCULAR_CCLW)    code] } {

            set mom_sim_nc_register(MOTION) "CIRCULAR_CCLW"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_DRILL)             code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_DRILL"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_DRILL_DWELL)       code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_DRILL_DWELL"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_DRILL_DEEP)        code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_DRILL_DEEP"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_DRILL_BREAK_CHIP)  code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_DRILL_BREAK_CHIP"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_TAP)               code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_TAP"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE)              code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE_DRAG)         code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_DRAG"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE_NO_DRAG)      code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_NO_DRAG"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE_BACK)         code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_BACK"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE_MANUAL)       code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_MANUAL"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE_MANUAL_DWELL) code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_MANUAL_DWELL"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_START)             code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_START"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_OFF)               code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_OFF"

           # Cycle Off - force tool to move to the initial pt (entry pos) of next set of holes.
            global mom_sim_pos mom_sim_cycle_retract_to_pos
            if { [info exists mom_sim_cycle_retract_to_pos] } {
               set mom_sim_pos(0) $mom_sim_cycle_retract_to_pos(0)
               set mom_sim_pos(1) $mom_sim_cycle_retract_to_pos(1)
               set mom_sim_pos(2) $mom_sim_cycle_retract_to_pos(2)
            }
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__G_plane_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func
  global mom_sim_cycle_spindle_axis


   set codes_list [list]

   set var_list {mom_sim_nc_func(PLANE_XY) mom_sim_nc_func(PLANE_YZ) mom_sim_nc_func(PLANE_ZX)}

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(PLANE_XY)        code] } {

            set mom_sim_nc_register(PLANE) XY
            set mom_sim_cycle_spindle_axis 2

         } elseif { [VNC_string_match mom_sim_nc_func(PLANE_YZ)  code] } {

            set mom_sim_nc_register(PLANE) YZ
            set mom_sim_cycle_spindle_axis 0

         } elseif { [VNC_string_match mom_sim_nc_func(PLANE_ZX)  code] } {

            set mom_sim_nc_register(PLANE) ZX
            set mom_sim_cycle_spindle_axis 1
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__G_spin_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   if [string match "IN" $mom_sim_nc_register(UNIT)] {

      set codes_list [list]

      set var_list {mom_sim_nc_func(SPEED_SFM) mom_sim_nc_func(SPEED_RPM)}

      foreach var $var_list {
        if [info exists $var] {
          lappend codes_list [set $var]
        }
      }

      global mom_sim_o_buffer
      foreach code $codes_list {

         if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

            if [string match "$mom_sim_nc_func(SPEED_SFM)" $code] {

               set mom_sim_nc_register(SPINDLE_MODE) SFM

            } elseif [string match "$mom_sim_nc_func(SPEED_RPM)"  $code] {

               set mom_sim_nc_register(SPINDLE_MODE) REV_PER_MIN
            }

            break
         }
      }

   } else {

      set codes_list [list]

      set var_list {mom_sim_nc_func(SPEED_SMM) mom_sim_nc_func(SPEED_RPM)}

      foreach var $var_list {
        if [info exists $var] {
          lappend codes_list [set $var]
        }
      }

      global mom_sim_o_buffer
      foreach code $codes_list {

         if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

            if [string match "$mom_sim_nc_func(SPEED_SMM)"  $code] {

               set mom_sim_nc_register(SPINDLE_MODE) SMM

            } elseif [string match "$mom_sim_nc_func(SPEED_RPM)"  $code] {

               set mom_sim_nc_register(SPINDLE_MODE) REV_PER_MIN
            }

            break
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__G_spindle_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   if { [string match "IN" $mom_sim_nc_register(UNIT)] } {

      set codes_list [list]

      set var_list {mom_sim_nc_func(SPEED_SFM) mom_sim_nc_func(SPEED_RPM)}

      foreach var $var_list {
        if { [info exists $var] } {
          lappend codes_list [set $var]
        }
      }

      global mom_sim_o_buffer
      foreach code $codes_list {

         if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

            if { [VNC_string_match mom_sim_nc_func(SPEED_SFM)        code] } {

               set mom_sim_nc_register(SPINDLE_MODE) SFM

            } elseif { [VNC_string_match mom_sim_nc_func(SPEED_RPM)  code] } {

               set mom_sim_nc_register(SPINDLE_MODE) REV_PER_MIN
            }

            break
         }
      }

   } else {

      set codes_list [list]

      set var_list {mom_sim_nc_func(SPEED_SMM) mom_sim_nc_func(SPEED_RPM)}

      foreach var $var_list {
        if { [info exists $var] } {
          lappend codes_list [set $var]
        }
      }

      global mom_sim_o_buffer
      foreach code $codes_list {

         if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

            if { [VNC_string_match mom_sim_nc_func(SPEED_SMM)        code] } {

               set mom_sim_nc_register(SPINDLE_MODE) SMM

            } elseif { [VNC_string_match mom_sim_nc_func(SPEED_RPM)  code] } {

               set mom_sim_nc_register(SPINDLE_MODE) REV_PER_MIN
            }

            break
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__M_coolant_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list {mom_sim_nc_func(COOLANT_ON) mom_sim_nc_func(COOLANT_FLOOD) mom_sim_nc_func(COOLANT_MIST) mom_sim_nc_func(COOLANT_TAP) mom_sim_nc_func(COOLANT_OFF) mom_sim_nc_func(COOLANT_THRU)}

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(COOLANT_OFF) code] } {
            PB_SIM_call SIM_set_coolant OFF
         } else {
            PB_SIM_call SIM_set_coolant ON
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__M_misc_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list {mom_sim_nc_func(PROG_STOP) mom_sim_nc_func(PROG_OPSTOP) mom_sim_nc_func(PROG_END) mom_sim_nc_func(TOOL_CHANGE) mom_sim_nc_func(PROG_STOP_REWIND)}

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer

   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(PROG_STOP)         code] } {

         } elseif { [VNC_string_match mom_sim_nc_func(PROG_OPSTOP) code] } {

         } elseif { [VNC_string_match mom_sim_nc_func(PROG_END)    code] } {

           # Reset following functions on NC controller to the initial state.
           # (Fanuc System 9 Series)
           #
           #  G22 - Store stroke limit function ON
           #  G40 - Cutcom OFF
           #  G49 - Tool length adjust OFF
           #  G50 - Scaling OFF
           #  G54 - Work coordinate system 1
           #  G64 - Cutting mode
           #  G67 - Macro modal call cancel
           #  G69 - Coordinate system rotation OFF
           #  G80 - Canned cycle cancel
           #  G98 - Return to initial level (cycle)

            PB_SIM_call VNC_reset_controller

         } elseif { [VNC_string_match mom_sim_nc_func(TOOL_CHANGE)      code] } {

            PB_SIM_call VNC_tool_change

         } elseif { [VNC_string_match mom_sim_nc_func(PROG_STOP_REWIND) code] } {

            PB_SIM_call VNC_rewind_stop_program

         } else {
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__M_spindle_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list {mom_sim_nc_func(SPINDLE_CLW) mom_sim_nc_func(SPINDLE_CCLW) mom_sim_nc_func(SPINDLE_OFF)}

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(SPINDLE_CLW)        code] } {

            set mom_sim_nc_register(SPINDLE_DIRECTION) CLW

         } elseif { [VNC_string_match mom_sim_nc_func(SPINDLE_CCLW) code] } {

            set mom_sim_nc_register(SPINDLE_DIRECTION) CCLW

         } elseif { [VNC_string_match mom_sim_nc_func(SPINDLE_OFF)  code] } {

            set mom_sim_nc_register(SPINDLE_DIRECTION) OFF
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__R_code { } {
#=============================================================
  global mom_sim_nc_register

   set mom_sim_nc_register(R_IN_USE) 1
}


#=============================================================
proc PB_CMD_vnc____config_machine_tool_axes { } {
#=============================================================
   global mom_sim_num_machine_axes
   global mom_sim_spindle_comp mom_sim_spindle_jct
   global mom_sim_zcs_base mom_sim_mt_axis
   global mom_sim_result mom_sim_result1
   global mom_sim_reverse_4th_table mom_sim_4th_axis_has_limits
   global mom_sim_reverse_5th_table mom_sim_5th_axis_has_limits



  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  #   Specify tool mounting Junction & its parent component.
  #
  #   Mill : Tool mounting Junction & Spindle component
  #   Turn : Tool mounting Junction & Turret component
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

   set mom_sim_spindle_comp                           "SPINDLE"
   set mom_sim_spindle_jct                            "TOOL_MOUNT_JCT"
   set mom_sim_zcs_base                               "MACHINE_BASE"

   set mom_sim_mt_axis(X)                             "X"
   set mom_sim_mt_axis(Y)                             "Y"
   set mom_sim_mt_axis(Z)                             "Z"

   switch $mom_sim_num_machine_axes {
      "4" {
         set mom_sim_mt_axis(4)                       "B"
         set mom_sim_reverse_4th_table                "0"
         set mom_sim_4th_axis_has_limits              "1"
      }
      "5" {
         set mom_sim_mt_axis(4)                       "B"
         set mom_sim_reverse_4th_table                "0"
         set mom_sim_4th_axis_has_limits              "1"
         set mom_sim_mt_axis(5)                       "C"
         set mom_sim_reverse_5th_table                "0"
         set mom_sim_5th_axis_has_limits              "1"
      }
   }


  # For this machine that all physical axes participate in executing a motion.
  # Include all logical names for axes.
  #
   set axes_config_list [list]
   set rotary_axes_list [list]

   PB_SIM_call SIM_ask_nc_axes_of_mtool

   if { [info exists mom_sim_mt_axis(X)] } {
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(X)"] >= 0 } {
         lappend axes_config_list $mom_sim_mt_axis(X)
      }
   }
   if { [info exists mom_sim_mt_axis(Y)] } {
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Y)"] >= 0 } {
         lappend axes_config_list $mom_sim_mt_axis(Y)
      }
   }
   if { [info exists mom_sim_mt_axis(Z)] } {
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Z)"] >= 0 } {
         lappend axes_config_list $mom_sim_mt_axis(Z)
      }
   }
   if { [info exists mom_sim_mt_axis(4)] } {
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(4)"] >= 0 } {
         lappend rotary_axes_list $mom_sim_mt_axis(4)
      }
   }
   if { [info exists mom_sim_mt_axis(5)] } {
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(5)"] >= 0 } {
         lappend rotary_axes_list $mom_sim_mt_axis(5)
      }
   }

   PB_SIM_call SIM_set_linear_axes_config [concat $axes_config_list]

   if { [llength $rotary_axes_list] > 0 } {
      PB_SIM_call SIM_set_rotary_axes_config [concat $rotary_axes_list]
   }
}


#=============================================================
proc PB_CMD_vnc____config_nc_definitions { } {
#=============================================================
   global mom_sim_prog_rewind_stop_code
   global mom_sim_control_var_leader
   global mom_sim_control_equal_sign
   global mom_sim_incr_linear_addrs
   global mom_sim_rapid_dogleg
   global mom_sim_output_vnc_msg
   global mom_sim_pre_com_list
   global mom_sim_machine_zero_offsets
   global mom_sim_wcs_offsets
   global mom_sim_tool_data


   set mom_sim_prog_rewind_stop_code                  "%"
   set mom_sim_control_var_leader                     "#"
   set mom_sim_control_equal_sign                     "="
   set mom_sim_rapid_dogleg                           "0"
   set mom_sim_output_vnc_msg                         "0"
   set mom_sim_machine_zero_offsets                   [list 0.0 0.0 0.0]

   set mom_sim_wcs_offsets(0)                         [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set mom_sim_wcs_offsets(1)                         [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set mom_sim_wcs_offsets(2)                         [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set mom_sim_wcs_offsets(3)                         [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set mom_sim_wcs_offsets(4)                         [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set mom_sim_wcs_offsets(5)                         [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set mom_sim_wcs_offsets(6)                         [list 0.0 0.0 0.0 0.0 0.0 0.0]


   global mom_sim_nc_register

   set mom_sim_nc_register(SPINDLE_MODE)              "SFM"
   set mom_sim_nc_register(FEED_MODE)                 "INCH_PER_MIN"
   set mom_sim_nc_register(MOTION)                    "RAPID"
   set mom_sim_nc_register(INPUT)                     "ABS"
   set mom_sim_nc_register(DEF_INPUT)                 "ABS"
   set mom_sim_nc_register(SPINDLE_DIRECTION)         "CLW"

   global mom_sim_nc_func

   set mom_sim_nc_func(RETURN_HOME_P)                 "G30"
   set mom_sim_nc_func(FROM_HOME)                     "G29"
   set mom_sim_nc_func(LOCAL_CS_SET)                  "G52"
   set mom_sim_nc_func(MACH_CS_MOVE)                  "G53"
   set mom_sim_nc_func(WORK_CS_1)                     "G54"
   set mom_sim_nc_func(WORK_CS_2)                     "G55"
   set mom_sim_nc_func(WORK_CS_3)                     "G56"
   set mom_sim_nc_func(WORK_CS_4)                     "G57"
   set mom_sim_nc_func(WORK_CS_5)                     "G58"
   set mom_sim_nc_func(WORK_CS_6)                     "G59"
}


#=============================================================
proc PB_CMD_vnc____map_machine_tool_axes { } {
#=============================================================
   global mom_sim_num_machine_axes
   global mom_sim_spindle_comp mom_sim_spindle_jct
   global mom_sim_zcs_base mom_sim_mt_axis
   global mom_sim_result mom_sim_result1
   global mom_sim_reverse_4th_table mom_sim_4th_axis_has_limits
   global mom_sim_reverse_5th_table mom_sim_5th_axis_has_limits



  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  #   Specify tool mounting Junction & its parent component.
  #
  #   Mill : Tool mounting Junction & Spindle component
  #   Turn : Tool mounting Junction & Turret component
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

   set mom_sim_spindle_comp                           "SPINDLE"
   set mom_sim_spindle_jct                            "TOOL_MOUNT_JCT"
   set mom_sim_zcs_base                               "MACHINE_BASE"

   set mom_sim_mt_axis(X)                             "X"
   set mom_sim_mt_axis(Y)                             "Y"
   set mom_sim_mt_axis(Z)                             "Z"

   switch $mom_sim_num_machine_axes {
      "4" {
         set mom_sim_mt_axis(4)                       "B"
         set mom_sim_reverse_4th_table                "0"
         set mom_sim_4th_axis_has_limits              "1"
      }
      "5" {
         set mom_sim_mt_axis(4)                       "B"
         set mom_sim_reverse_4th_table                "0"
         set mom_sim_4th_axis_has_limits              "1"
         set mom_sim_mt_axis(5)                       "C"
         set mom_sim_reverse_5th_table                "0"
         set mom_sim_5th_axis_has_limits              "1"
      }
   }


  # For this machine that all physical axes participate in executing a motion.
  # Include all logical names for axes.
  #
   set axes_config_list [list]
   set rotary_axes_list [list]

   PB_SIM_call SIM_ask_nc_axes_of_mtool

   if { [info exists mom_sim_mt_axis(X)] } { 
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(X)"] >= 0 } {
         lappend axes_config_list $mom_sim_mt_axis(X)
      }
   }
   if { [info exists mom_sim_mt_axis(Y)] } { 
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Y)"] >= 0 } {
         lappend axes_config_list $mom_sim_mt_axis(Y)
      }
   }
   if { [info exists mom_sim_mt_axis(Z)] } { 
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Z)"] >= 0 } {
         lappend axes_config_list $mom_sim_mt_axis(Z)
      }
   }
   if { [info exists mom_sim_mt_axis(4)] } { 
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(4)"] >= 0 } {
         lappend rotary_axes_list $mom_sim_mt_axis(4)
      }
   }
   if { [info exists mom_sim_mt_axis(5)] } { 
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(5)"] >= 0 } {
         lappend rotary_axes_list $mom_sim_mt_axis(5)
      }
   }

   PB_SIM_call SIM_set_linear_axes_config [concat $axes_config_list]

   if { [llength $rotary_axes_list] > 0 } {
      PB_SIM_call SIM_set_rotary_axes_config [concat $rotary_axes_list]
   }


  # Process custom configuration
  #
   PB_SIM_call PB_CMD_vnc____config_machine_tool_axes
}


#=============================================================
proc PB_CMD_vnc____process_nc_block { } {
#=============================================================
  global mom_sim_o_buffer

  # Process legacy handlers
  #
   if { [llength [info commands PB_CMD_vnc__preprocess_nc_block]] } {
      set mom_sim_o_buffer [PB_SIM_call PB_CMD_vnc__preprocess_nc_block]
   }

   set o_buff $mom_sim_o_buffer


return $o_buff
}


#=============================================================
proc PB_CMD_vnc____set_nc_definitions { } {
#=============================================================
   global mom_sim_prog_rewind_stop_code
   global mom_sim_control_var_leader
   global mom_sim_control_equal_sign
   global mom_sim_incr_linear_addrs
   global mom_sim_rapid_dogleg
   global mom_sim_output_vnc_msg
   global mom_sim_pre_com_list
   global mom_sim_machine_zero_offsets
   global mom_sim_wcs_offsets
   global mom_sim_tool_data


   set mom_sim_prog_rewind_stop_code                  "%"
   set mom_sim_control_var_leader                     "#"
   set mom_sim_control_equal_sign                     "="
   set mom_sim_rapid_dogleg                           "0"
   set mom_sim_output_vnc_msg                         "0"
   set mom_sim_machine_zero_offsets                   [list 0.0 0.0 0.0]

   set mom_sim_wcs_offsets(0)                         [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set mom_sim_wcs_offsets(1)                         [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set mom_sim_wcs_offsets(2)                         [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set mom_sim_wcs_offsets(3)                         [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set mom_sim_wcs_offsets(4)                         [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set mom_sim_wcs_offsets(5)                         [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set mom_sim_wcs_offsets(6)                         [list 0.0 0.0 0.0 0.0 0.0 0.0]


   global mom_sim_nc_register

   set mom_sim_nc_register(SPINDLE_MODE)              "REV_PER_MIN"
   set mom_sim_nc_register(FEED_MODE)                 "INCH_PER_MIN"
   set mom_sim_nc_register(MOTION)                    "RAPID"
   set mom_sim_nc_register(INPUT)                     "ABS"
   set mom_sim_nc_register(DEF_INPUT)                 "ABS"
   set mom_sim_nc_register(SPINDLE_DIRECTION)         "CLW"

   global mom_sim_nc_func

   set mom_sim_nc_func(RETURN_HOME_P)                 "G30"
   set mom_sim_nc_func(FROM_HOME)                     "G29"
   set mom_sim_nc_func(LOCAL_CS_SET)                  "G52"
   set mom_sim_nc_func(MACH_CS_MOVE)                  "G53"
   set mom_sim_nc_func(WORK_CS_1)                     "G54"
   set mom_sim_nc_func(WORK_CS_2)                     "G55"
   set mom_sim_nc_func(WORK_CS_3)                     "G56"
   set mom_sim_nc_func(WORK_CS_4)                     "G57"
   set mom_sim_nc_func(WORK_CS_5)                     "G58"
   set mom_sim_nc_func(WORK_CS_6)                     "G59"


  # Process custom configuration
  #
   PB_SIM_call PB_CMD_vnc____config_nc_definitions
}


#=============================================================
proc PB_CMD_vnc____sim_other_devices { } {
#=============================================================
  global mom_sim_o_buffer
  global mom_sim_result mom_sim_result1
  global mom_sim_tool_loaded
  global mom_sim_spindle_comp mom_sim_spindle_jct
  global mom_sim_nc_register
  global mom_sim_address mom_sim_format

  global mom_sim_other_nc_codes
  global mom_sim_nc_address
  global mom_sim_nc_code
  global mom_sim_pos mom_sim_prev_pos
  global mom_sim_simulate_block


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Specify action for each code encountered.
  #
  # Codes to be simulated are defined by mom_sim_other_nc_codes in
  # PB_CMD_vnc____set_nc_definitions.
  #
  # Example here has been defined for Mazak Integrex 200.
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

   switch $mom_sim_nc_address {

     "M91" {
       # Machine datum move (one shot instruction as G53)
        set mom_sim_nc_register(MCS_MOVE) 1

       # Zero WCS offset for a MCS move. Current WCS offset will be restored after the move.
        set wcs_offsets $mom_sim_nc_register(WORK_OFFSET)
        set mom_sim_nc_register(WORK_OFFSET) [list]
        lappend mom_sim_nc_register(WORK_OFFSET) 0.0 0.0 0.0 0.0 0.0

       # Set ZCS base to main reference
        global mom_sim_zcs_base
##     ###global mom_sim_zcs_base_MCS
##        global mom_sim_zcs_base_LCS

        set zcs_base $mom_sim_zcs_base

##     ###set mom_sim_zcs_base $mom_sim_zcs_base_MCS
##        set mom_sim_zcs_base $mom_sim_zcs_base_LCS
##        PB_CMD_vnc__set_kinematics


#+++++++++++++++++++++++++++++++++++++++++++++++++
#<12-12-05 gsl> Perform move w.r.t. main ZCS base
        global mom_sim_zcs_base_MCS
        set mom_sim_zcs_base $mom_sim_zcs_base_MCS

       #<12-12-05 gsl> Restore main CSYS
        global mom_sim_csys_matrix
        global mom_sim_main_csys_matrix

#**************
#<12-20-05 gsl> Customize a Machine Zero CSYS for datum move
        global mom_sim_machine_zero_csys_matrix

        if ![info exists mom_sim_machine_zero_csys_matrix] {
         if 0 {

          # Add offsets to main CSYS to define machine zero CSYS

           if [info exists mom_sim_main_csys_matrix] {
              array set mom_sim_machine_zero_csys_matrix [array get mom_sim_main_csys_matrix]
           } else {
              array set mom_sim_machine_zero_csys_matrix [array get mom_sim_csys_matrix]
           }

           set mom_sim_machine_zero_csys_matrix(9)  [expr $mom_sim_machine_zero_csys_matrix(9)  + 848.5917]
           set mom_sim_machine_zero_csys_matrix(10) [expr $mom_sim_machine_zero_csys_matrix(10) + 423.1430]
           set mom_sim_machine_zero_csys_matrix(11) [expr $mom_sim_machine_zero_csys_matrix(11) + 675.1404]

         } else {
#<12-21-05 gsl>
          # Use MTCS to define machine zero CSYS
           global mom_sim_result mom_sim_result1
           PB_SIM_call SIM_ask_mtcs_junction
           PB_SIM_call SIM_ask_init_junction_xform $mom_sim_result

           set i 0
           foreach v $mom_sim_result {
              set mom_sim_machine_zero_csys_matrix($i)  $v
              incr i
           }
           foreach v $mom_sim_result1 {
              set mom_sim_machine_zero_csys_matrix($i)  $v
              incr i
           }
         }
        }

       # Save current CSYS to be restored after the move
        array set current_csys_matrix [array get mom_sim_csys_matrix]

       # Remap reference CSYS to machine zero
        array set mom_sim_csys_matrix [array get mom_sim_machine_zero_csys_matrix]

        PB_CMD_vnc__set_kinematics
#+++++++++++++++++++++++++++++++++++++++++++++++++

#VNC_pause "WORK_OFFSET  $mom_sim_nc_register(WORK_OFFSET)"

        PB_SIM_call PB_CMD_vnc__sim_motion

        set mom_sim_nc_register(MCS_MOVE) 0


       # Restore current CSYS
        array set mom_sim_csys_matrix [array get current_csys_matrix]


       # Restore WCS
        set mom_sim_nc_register(WORK_OFFSET) $wcs_offsets

        set mom_sim_zcs_base $zcs_base
        PB_CMD_vnc__set_kinematics

        # Disable further simulation
         set mom_sim_simulate_block 0
      }

      M200 -
      M201 { ;# Milling mode

         set mom_sim_nc_register(MACHINE_MODE) MILL
      }

      M202 { ;# Turning mode

         set mom_sim_nc_register(MACHINE_MODE) TURN

        # Zero Y.
         global mom_sim_pos
         set mom_sim_pos(1) 0
      }
    }
}


#=============================================================
proc PB_CMD_vnc__ask_device_class_in_model { } {
#=============================================================
# This function cycles through the kinematic model to determine
# if the model is a multi-channel machine.
#
# This function returns the number of components classified as _DEVICE.


   set cmd_name "PB_SIM_cycle_comp_of_class"

   if { [llength [info commands $cmd_name]] == 0 } {

      #=====================================================
      proc $cmd_name { COMP_CLASS base_comp class class_type} {
      #=====================================================
      # This command recurrsively identifies all NC axes
      # from a machine model.

         upvar $COMP_CLASS comp_class

         global mom_sim_result mom_sim_result1

         SIM_ask_number_of_child_components $base_comp
         set n_comp $mom_sim_result

         for { set i 0 } { $i < $n_comp } { incr i } {

            SIM_ask_nth_child_component $base_comp $i
            set comp $mom_sim_result

            if { ![string compare "SYSTEM" $class_type] } {
               SIM_is_component_of_system_class $comp $class
            } else {
               SIM_is_component_of_user_class $comp $class
            }

            if { $mom_sim_result == 1 } {

               lappend comp_class($class,comp) $comp
            }

            eval { [lindex [info level 0] 0] comp_class $comp $class $class_type }
         }
      }
   }


   global mom_sim_result

   set mom_sim_result ""

   set machine_base MACHINE_BASE
   SIM_ask_machine_base_component
   if { ![string match "" $mom_sim_result] } {
      set machine_base $mom_sim_result
   }

   if [info exists COMP_class] { unset COMP_class }

   set class _DEVICE
   set mode  SYSTEM

   if ![catch { PB_SIM_cycle_comp_of_class COMP_class $machine_base $class $mode }] {
return [llength $COMP_class($class,comp)]
   } else {
return 1
   }
}


#=============================================================
proc PB_CMD_vnc__ask_feedrate_mode { } {
#=============================================================
  global mom_feed_rate_mode

   if [info exists mom_feed_rate_mode] {
      switch $mom_feed_rate_mode {
         IPM     { set feed_units "INCH_PER_MIN" }
         MMPM    { set feed_units "MM_PER_MIN"}
         IPR     { set feed_units "INCH_PER_REV" }
         MMPR    { set feed_units "MM_PER_REV" }
         FRN     { set feed_units "MM_PER_100REV" }
         default { set feed_units "UNKNOWN FEEDRATE UNITS" }
      }
   } else {
      set feed_units "UNKNOWN FEEDRATE UNITS"
   }

return $feed_units
}


#=============================================================
proc PB_CMD_vnc__ask_head_spindle_axis { } {
#=============================================================
# This command retuns the head spindle axis, if any.
# - Existence of the axis can be interrogated from the kin model per
#   componemt classified as _DEVICE_HOLDER_ON_HEAD

# pb602(c) -

   global mom_sim_head_spindle_axis
   global mom_sim_head_spindle_axis_defined

   if { [info exists mom_sim_head_spindle_axis] || [info exists mom_sim_head_spindle_axis_defined] } {
return
   }


   global mom_sim_result

   set sim_result_saved $mom_sim_result

   set mom_sim_result ""

   set machine_base MACHINE_BASE
   PB_SIM_call SIM_ask_machine_base_component

   if { ![string match "" $mom_sim_result] } {
      set machine_base $mom_sim_result
   }


   VNC_unset_vars  COMP_class

   set class _DEVICE_HOLDER_ON_HEAD
   set mode  SYSTEM

   set cmd_name "PB_SIM_cycle_comp_of_class"

   if { ![catch { $cmd_name COMP_class $machine_base $class $mode }] } {
      if { [info exists COMP_class($class,comp)] } {
         PB_SIM_call SIM_ask_axis_of_component $COMP_class($class,comp)
      }
   }

   if { [string length $mom_sim_result] && [string compare "0" $mom_sim_result] && [string compare _NONE $mom_sim_result] } {

      set mom_sim_head_spindle_axis $mom_sim_result
   }

   set mom_sim_head_spindle_axis_defined 1


   set mom_sim_result $sim_result_saved
}


#=============================================================
proc PB_CMD_vnc__ask_number_of_active_channels { } {
#=============================================================
# This function cycles through the kinematic model to determine
# if the model is a multi-channel machine.
#
# This function returns the number of K-components classified as _DEVICE.


   set cmd_name "PB_SIM_cycle_comp_of_class"

   if { [llength [info commands $cmd_name]] == 0 } {

      # pb601(i) -
      #=====================================================
      proc $cmd_name { COMP_CLASS base_comp class class_type args } {
      #=====================================================
      # This command recurrsively identifies all NC axes
      # from a machine model.

         upvar $COMP_CLASS comp_class

        # Added args for passing channel number to collect tools per each carrier
         if { [llength $args] > 0 } {
            set chan [lindex $args 0]
         } else {
            set chan ""
         }

         global mom_sim_result mom_sim_result1

         PB_SIM_call SIM_ask_number_of_child_components $base_comp
         set n_comp $mom_sim_result

         for { set i 0 } { $i < $n_comp } { incr i } {

            PB_SIM_call SIM_ask_nth_child_component $base_comp $i
            set comp $mom_sim_result

            if { ![string compare $class_type "SYSTEM"] } {
               PB_SIM_call SIM_is_component_of_system_class $comp $class
            } else {
               PB_SIM_call SIM_is_component_of_user_class $comp $class
            }

            if { $mom_sim_result == 1 } {

               switch $class {

                  _DEVICE {
                     PB_SIM_call SIM_ask_number_of_channels_at_component $comp
                     set n_ch $mom_sim_result

                     for { set idx 0 } { $idx < $n_ch } { incr idx } {

                        PB_SIM_call SIM_ask_nth_channel_at_component $comp $idx
                        set ch $mom_sim_result

                        if { [info exists comp_class(active_chan)] } {
                           if { [lsearch $comp_class(active_chan) $ch] < 0 } {
                              lappend comp_class(active_chan) $ch
                           }
                        } else {
                           lappend comp_class(active_chan) $ch
                        }

                       #<07-15-08 gsl> Find tools on this device
                        eval { [lindex [info level 0] 0] comp_class $comp _TOOL $class_type $ch }
                     }
                  }

                  _DEVICE_HOLDER {
                  }

                  _TOOL {
                    # pb601(i) -
                    #*************************************************************************************
                    # Potential problem - K-comp can be renamed to become different from actual tool name.
                    # ==> Dependant K-comp should be read only!
                    #
                     set comp_class(_CARRIER,$comp) $chan

                     global mom_sim_comp_class
                     set mom_sim_comp_class(_CARRIER,$comp) $chan
                  }

                  default {
                     lappend comp_class($class,comp) $comp
                  }
               }
            }

            eval { [lindex [info level 0] 0] comp_class $comp $class $class_type $chan }
         }
      }
   }



   global mom_sim_result

  # pb602(d) - Preserve status
   set sim_result_saved $mom_sim_result


   VNC_unset_vars n_channels

   if { ![catch { SIM_ask_number_of_channels }] } {
      if { $mom_sim_result == 1 } {
         set n_channels 1
      }
   } else {
      set n_channels 1
   }

   global mom_sim_active_channels

   if { [info exists mom_sim_active_channels] } {
      set n_channels [llength $mom_sim_active_channels]
   }

   if { [info exists n_channels] } {
      set mom_sim_result $sim_result_saved
return $n_channels
   }


   set cmd_name "PB_SIM_cycle_comp_of_class"


   set mom_sim_result ""

   set machine_base MACHINE_BASE
   PB_SIM_call SIM_ask_machine_base_component

   if { ![string match "" $mom_sim_result] } {
      set machine_base $mom_sim_result
   }


   VNC_unset_vars  COMP_class

   set class _DEVICE
   set mode  SYSTEM

   set n_channels 1
   if { ![catch { PB_SIM_cycle_comp_of_class COMP_class $machine_base $class $mode }] } {
      if { [info exists COMP_class(active_chan)] } {
         set mom_sim_active_channels $COMP_class(active_chan)
         set n_channels [llength $COMP_class(active_chan)]
      }
   }

   set mom_sim_result $sim_result_saved

return $n_channels
}


#=============================================================
proc PB_CMD_vnc__ask_number_of_lathe_spindles { } {
#=============================================================
# This function cycles through the kinematic model to determine
# the number of K-components classified as _LATHE_SPINDLE.
#
# pb601(j) - Removed definition of PB_SIM_cycle_comp_of_class from this command

   global mom_sim_result

   global mom_sim_lathe_spindles

   if { [info exists mom_sim_lathe_spindles] } {
return [llength $mom_sim_lathe_spindles]
   }


  # pb602(d) - Preserve status
   set sim_result_saved $mom_sim_result

   set mom_sim_result ""

   set machine_base MACHINE_BASE
   PB_SIM_call SIM_ask_machine_base_component

   if { ![string match "" $mom_sim_result] } {
      set machine_base $mom_sim_result
   }


   VNC_unset_vars  COMP_class

   set class _LATHE_SPINDLE
   set mode  SYSTEM

   set n_spindles 0

   if { ![catch { PB_SIM_cycle_comp_of_class COMP_class $machine_base $class $mode }] } {
      if { [info exists COMP_class($class,comp)] } {
         set mom_sim_lathe_spindles $COMP_class($class,comp)
         set n_spindles [llength $COMP_class($class,comp)]
      }
   }

   set mom_sim_result $sim_result_saved

return $n_spindles
}


#=============================================================
proc PB_CMD_vnc__ask_speed_mode { } {
#=============================================================
  global mom_spindle_mode

   if [info exists mom_spindle_mode] {
      switch $mom_spindle_mode {
         RPM     { set speed_units "REV_PER_MIN" }
         default { set speed_units "UNKNOWN SPEED UNITS" }
      }
   } else {
      set speed_units "UNKNOWN SPEED UNITS"
   }

return $speed_units
}


#=============================================================
proc PB_CMD_vnc__calculate_duration_time { } {
#=============================================================
  global mom_sim_motion_linear_or_angular
  global mom_sim_travel_delta mom_sim_duration_time
  global mom_sim_feedrate_mode
  global mom_sim_nc_register
  global mom_sim_rapid_feed_rate
  global mom_sim_max_dpm


   if [llength [info commands "PB_CMD_vnc__user_calculate_duration_time"]] {
      PB_SIM_call PB_CMD_vnc__user_calculate_duration_time
return
   }


  # Prescreen condition
   if ![EQ_is_gt [expr abs($mom_sim_travel_delta)] 0.0] {
      set mom_sim_duration_time 0.0
return
   }


   set linear_or_angular $mom_sim_motion_linear_or_angular
   set delta [expr abs($mom_sim_travel_delta)]

  # Determine feed rate & mode
   if { [string match "RAPID" $mom_sim_nc_register(MOTION)] || [expr $mom_sim_nc_register(F) <= 0] } {

      set feed $mom_sim_rapid_feed_rate

      if { ![string compare "MM" $mom_sim_nc_register(UNIT)] } {
         set mode MM_PER_MIN
      } else {
         set mode INCH_PER_MIN
      }
   } else {
      set feed $mom_sim_nc_register(F)
      set mode $mom_sim_nc_register(FEED_MODE)
   }


   set feed [expr abs($feed)]


  # Initialize time
   set mom_sim_duration_time 0.000001

   if { ![string compare "ANGULAR" $linear_or_angular] } {

     # Find correct feed rate mode for a pure ratary move
      global mom_sim_feed_param
      global mom_sim_rapid_feed_mode
      global mom_sim_contour_feed_mode

      if { ![string compare "RAPID" $mom_sim_nc_register(MOTION)] } {
         if { [info exists mom_sim_max_dpm] && [EQ_is_gt $mom_sim_max_dpm 0.0] } {
            set mom_sim_duration_time [expr ($delta / $mom_sim_max_dpm) * 60.0]
         }
      } else {
         if { [info exists mom_sim_contour_feed_mode] && ![string compare "DPM" $mom_sim_contour_feed_mode(ROTARY)] } {
            global mom_sim_feedrate_dpm
            if { [info exists mom_sim_feedrate_dpm] && [EQ_is_gt $mom_sim_feedrate_dpm 0.0] } {
               set mom_sim_duration_time [expr ($delta / $mom_sim_feedrate_dpm) * 60.0]
            }
         }
      }

   } else {

      if ![EQ_is_zero $feed] {

         switch $mode {
            INCH_PER_MIN -
            MM_PER_MIN   {

               set mom_sim_duration_time [expr ($delta / $feed) * 60.0]
            }

            INCH_PER_REV -
            MM_PER_REV   {

               global mom_sim_spindle_mode mom_sim_spindle_speed
               global mom_sim_PI mom_sim_prev_pos mom_sim_pos

               switch $mom_sim_spindle_mode {
                  "REV_PER_MIN" {
                     set feed [expr $feed * $mom_sim_spindle_speed]
                  }
                  "FEET_PER_MIN" {
                     set feed [expr $feed * $mom_sim_spindle_speed * 12 / (2 * $mom_sim_PI * ($mom_sim_prev_pos(0) + $mom_sim_pos(0))/2)]
                  }
                  "M_PER_MIN" {
                     set feed [expr $feed * $mom_sim_spindle_speed * 1000 / (2 * $mom_sim_PI * ($mom_sim_prev_pos(0) + $mom_sim_pos(0))/2)]
                  }
               }

               if ![EQ_is_zero $feed] {
                  set mom_sim_duration_time [expr ($delta / $feed) * 60.0]
               }
            }

            MM_PER_100REV {
              # FRN mode
               set mom_sim_duration_time [expr 60/$feed]
            }
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__circular_move { } {
#=============================================================
  global mom_sim_address mom_sim_pos mom_sim_prev_pos
  global mom_sim_lg_axis
  global mom_sim_nc_register
  global mom_sim_circular_dir
  global mom_sim_circular_vector

  global mom_sim_o_buffer
  global mom_sim_nc_block


  # Clear R in use condition
   if { [info exists mom_sim_nc_register(R_IN_USE)] } {

     # Unset it only if not modal!
      if { !$mom_sim_address(R,modal) } {
         VNC_unset_vars  mom_sim_nc_register(R_IN_USE)
      }
   }

  # pb601(a) - Search for R word if the leader of Address R is R.
  # pb800(f) - Look at original block buffer
   if { [info exists mom_sim_nc_block] } {
      set tmp_o_buff $mom_sim_nc_block
   } else {
      set tmp_o_buff $mom_sim_o_buffer
   }

   VNC_parse_nc_word tmp_o_buff $mom_sim_address(R,leader) 2 PB_CMD_vnc__R_code


  # pb602(a) - Search for IJK to override R mode
  #         ==> R-in-use flag can be still in effect resulted from previous (turn) post

   if { [info exists mom_sim_nc_register(R_IN_USE)] } {

      if { [VNC_parse_nc_word tmp_o_buff $mom_sim_address(I,leader) 2] ||\
           [VNC_parse_nc_word tmp_o_buff $mom_sim_address(J,leader) 2] ||\
           [VNC_parse_nc_word tmp_o_buff $mom_sim_address(K,leader) 2] } {

         VNC_unset_vars mom_sim_nc_register(R_IN_USE)
      }
   }


   PB_SIM_call VNC_set_feedrate_mode CUT


   set dir $mom_sim_circular_dir
   set plane $mom_sim_nc_register(PLANE)


  # When "Unsigned Vector - Arc Start to Center" is used to define
  # the arc center vector, fake it into R case for arc center calculation.

   if { [string match "Unsigned Vector - Arc Start to Center" $mom_sim_circular_vector] } {

      set mom_sim_nc_register(R_IN_USE) 1

      if { [info exists mom_sim_nc_register(R)] } {
         set R_saved $mom_sim_nc_register(R)
      } else {
         set R_saved none
      }

      switch $plane {
         "YZ" {
            set dx $mom_sim_pos(6)
            set dy $mom_sim_pos(7)
         }
         "ZX" {
            set dx $mom_sim_pos(7)
            set dy $mom_sim_pos(5)
         }
         default {
            set dx $mom_sim_pos(5)
            set dy $mom_sim_pos(6)
         }
      }

     # Arc radius
      set mom_sim_nc_register(R) [expr sqrt($dx*$dx + $dy*$dy)]
   }


  # Find arc center vector
   if { [info exists mom_sim_nc_register(R_IN_USE)] } {

      switch $plane {
         "YZ" {
            set dx [expr $mom_sim_pos(1) - $mom_sim_prev_pos(1)]
            set dy [expr $mom_sim_pos(2) - $mom_sim_prev_pos(2)]
         }
         "ZX" {
            set dx [expr $mom_sim_pos(2) - $mom_sim_prev_pos(2)]
            set dy [expr $mom_sim_pos(0) - $mom_sim_prev_pos(0)]
         }
         default {
            set dx [expr $mom_sim_pos(0) - $mom_sim_prev_pos(0)]
            set dy [expr $mom_sim_pos(1) - $mom_sim_prev_pos(1)]
         }
      }

     # pb800(g) -
      set r $mom_sim_nc_register(R)
      set a [expr atan2($dy,$dx)]
       set t [expr sqrt($dx*$dx + $dy*$dy) / (2.0*$r)]
       if [EQ_is_gt $t  1.0] { set t  1.0 }
       if [EQ_is_lt $t -1.0] { set t -1.0 }
      set b [expr acos($t)]

     # Complement of an arc
      if { [expr $r < 0] } {
         set dir [expr -1 * $dir]
      }

      set c [expr $a + $dir*$b]

      switch $plane {
         "YZ" {
            set j [expr $r * cos($c) + $mom_sim_prev_pos(1)]
            set k [expr $r * sin($c) + $mom_sim_prev_pos(2)]
         }
         "ZX" {
            set k [expr $r * cos($c) + $mom_sim_prev_pos(2)]
            set i [expr $r * sin($c) + $mom_sim_prev_pos(0)]
         }
         default {
            set i [expr $r * cos($c) + $mom_sim_prev_pos(0)]
            set j [expr $r * sin($c) + $mom_sim_prev_pos(1)]
         }
      }

     # Restore R register
      if { [string match "Unsigned Vector - Arc Start to Center" $mom_sim_circular_vector] } {
         if { [string match "none" $R_saved] } {
            VNC_unset_vars  mom_sim_nc_register(R)
         } else {
            set mom_sim_nc_register(R) $R_saved
         }
      }

   } else {

      switch $mom_sim_circular_vector {
         "Vector - Arc Start to Center" {
            set i [expr $mom_sim_prev_pos(0) + $mom_sim_pos(5)]
            set j [expr $mom_sim_prev_pos(1) + $mom_sim_pos(6)]
            set k [expr $mom_sim_prev_pos(2) + $mom_sim_pos(7)]
         }

         "Vector - Arc Center to Start" {
            set i [expr $mom_sim_prev_pos(0) - $mom_sim_pos(5)]
            set j [expr $mom_sim_prev_pos(1) - $mom_sim_pos(6)]
            set k [expr $mom_sim_prev_pos(2) - $mom_sim_pos(7)]
         }

         "Vector - Absolute Arc Center" {
            set i $mom_sim_pos(5)
            set j $mom_sim_pos(6)
            set k $mom_sim_pos(7)
         }
      }
   }

  # pb800(g) -
   if ![info exists i] { set i 0.0 }
   if ![info exists j] { set j 0.0 }
   if ![info exists k] { set k 0.0 }


  #=====================
  # Validate arc record
  #=====================
  # pb750(j) -

  # To be implemented as "Other Options" of VNC's configuration
   global mom_sim_validate_arc mom_sim_validate_arc_tol

  # Allow overriding by setting env vars
   global env
   if { [info exists env(UGII_CAM_SIM_VALIDATE_ARC)] } {
      set mom_sim_validate_arc $env(UGII_CAM_SIM_VALIDATE_ARC)
   }
   if { ![info exists mom_sim_validate_arc] } {
     # Default to ON, if not set
      set mom_sim_validate_arc 1
   }

   if { $mom_sim_validate_arc } {

     # Determine tolerance for validation
      global mom_sim_output_unit

      if { [info exists env(UGII_CAM_SIM_VALIDATE_ARC_TOL)] } {
         set mom_sim_validate_arc_tol $env(UGII_CAM_SIM_VALIDATE_ARC_TOL)
      }
      if { ![info exists mom_sim_validate_arc_tol] } {
         if { [string match "MM" $mom_sim_output_unit] } {
            set mom_sim_validate_arc_tol 0.0011
         } else {
            set mom_sim_validate_arc_tol 0.00011
         }
      }

     # Arc center
      set Xs [expr $mom_sim_prev_pos(0) - $i]
      set Ys [expr $mom_sim_prev_pos(1) - $j]
      set Zs [expr $mom_sim_prev_pos(2) - $k]
      set Xe [expr $mom_sim_pos(0) - $i]
      set Ye [expr $mom_sim_pos(1) - $j]
      set Ze [expr $mom_sim_pos(2) - $k]

     # Start & end radius
      switch $plane {
         "XY" {
            set Rs [expr sqrt( $Xs*$Xs + $Ys*$Ys )]
            set Re [expr sqrt( $Xe*$Xe + $Ye*$Ye )]
         }
         "YZ" {
            set Rs [expr sqrt( $Ys*$Ys + $Zs*$Zs )]
            set Re [expr sqrt( $Ye*$Ye + $Ze*$Ze )]
         }
         "ZX" {
            set Rs [expr sqrt( $Zs*$Zs + $Xs*$Xs )]
            set Re [expr sqrt( $Ze*$Ze + $Xe*$Xe )]
         }
         default {
            set Rs [expr sqrt( $Xs*$Xs + $Ys*$Ys + $Zs*$Zs )]
            set Re [expr sqrt( $Xe*$Xe + $Ye*$Ye + $Ze*$Ze )]
         }
      }

     # Output VNC message when error
      if { [expr abs($Re - $Rs) > $mom_sim_validate_arc_tol] } {
         VNC_send_message "*** BAD ARC ***"
         VNC_send_message "$mom_sim_nc_block"
         VNC_send_message "  Start R: $Rs  End R: $Re   Diff = [expr abs($Re - $Rs)] > $mom_sim_validate_arc_tol"
         VNC_send_message "  ($mom_sim_prev_pos(0), $mom_sim_prev_pos(1), $mom_sim_prev_pos(2)) ->\
                             ($mom_sim_pos(0), $mom_sim_pos(1), $mom_sim_pos(2))\n"
      }
   }



   global mom_sim_arc_output_mode
   global mom_sim_PI

  # pb601(b) -
   global mom_sim_helix_pitch
   set helix_pitch ""

   switch $plane {
      "YZ" {

        # Detect helical condition
         if { [info exists mom_sim_helix_pitch] && ![EQ_is_zero $mom_sim_helix_pitch] } {
            set dz [expr $mom_sim_pos(0) - $mom_sim_prev_pos(0)]
            if { ![EQ_is_zero $dz] } {
               set helix_pitch [expr abs(2*$mom_sim_PI*$dz/$mom_sim_helix_pitch)]
            }
         }

         if { [string length $helix_pitch] == 0 } {

           # Handle full circle using half circle pt
            if { [string match "FULL_CIRCLE" $mom_sim_arc_output_mode] } {
               if { [EQ_is_equal $mom_sim_pos(1) $mom_sim_prev_pos(1)] && [EQ_is_equal $mom_sim_pos(2) $mom_sim_prev_pos(2)] } {

                  set dx [expr $mom_sim_pos(1) - $j]
                  set dy [expr $mom_sim_pos(2) - $k]
                  set a [expr atan2($dy,$dx)]
                  set b [expr $a + $mom_sim_PI]
                  set r [expr sqrt($dx*$dx + $dy*$dy)]
                  set px [expr $j + $r*cos($b)]
                  set py [expr $k + $r*sin($b)]

                  PB_SIM_call SIM_move_circular_zcs $dir 0 0 $mom_sim_lg_axis(Y) $px $mom_sim_lg_axis(Z) $py\
                                                             $mom_sim_lg_axis(J) $j $mom_sim_lg_axis(K) $k
               }
            }

            eval PB_SIM_call SIM_move_circular_zcs $dir 0 0 $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                                            $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                                            $mom_sim_lg_axis(J) $j $mom_sim_lg_axis(K) $k
         } else {

          # pb602(r) - Activate logic below
           if 1 {
            if { [EQ_is_lt $helix_pitch [expr 2*$mom_sim_PI]] } {
               set helix_pitch "$mom_sim_lg_axis(X) $mom_sim_pos(0)"
            } else {
               set helix_pitch "$mom_sim_lg_axis(X) $mom_sim_pos(0) P $helix_pitch"
            }
           } else {
            set helix_pitch "P $helix_pitch"
           }

            eval PB_SIM_call SIM_move_helical_zcs $dir 0 0 $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                                           $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                                           $mom_sim_lg_axis(J) $j $mom_sim_lg_axis(K) $k $helix_pitch
         }
      }

      "ZX" {

        # Detect helical condition
         if { [info exists mom_sim_helix_pitch] && ![EQ_is_zero $mom_sim_helix_pitch] } {
            set dz [expr $mom_sim_pos(1) - $mom_sim_prev_pos(1)]
            if { ![EQ_is_zero $dz] } {
               set helix_pitch [expr abs(2*$mom_sim_PI*$dz/$mom_sim_helix_pitch)]
            }
         }

         if { [string length $helix_pitch] == 0 } {

           # Handle full circle using half circle pt
            if { [string match "FULL_CIRCLE" $mom_sim_arc_output_mode] } {
               if { [EQ_is_equal $mom_sim_pos(2) $mom_sim_prev_pos(2)] && [EQ_is_equal $mom_sim_pos(0) $mom_sim_prev_pos(0)] } {

                  set dx [expr $mom_sim_pos(2) - $k]
                  set dy [expr $mom_sim_pos(0) - $i]
                  set a [expr atan2($dy,$dx)]
                  set b [expr $a + $mom_sim_PI]
                  set r [expr sqrt($dx*$dx + $dy*$dy)]
                  set px [expr $k + $r*cos($b)]
                  set py [expr $i + $r*sin($b)]

                  PB_SIM_call SIM_move_circular_zcs 0 $dir 0 $mom_sim_lg_axis(Z) $px $mom_sim_lg_axis(X) $py\
                                                             $mom_sim_lg_axis(K) $k $mom_sim_lg_axis(I) $i
               }
            }

            eval PB_SIM_call SIM_move_circular_zcs 0 $dir 0 $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                                            $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                                            $mom_sim_lg_axis(K) $k $mom_sim_lg_axis(I) $i
         } else {

          # pb602(r) - Activate logic below
           if 1 {
            if { [EQ_is_lt $helix_pitch [expr 2*$mom_sim_PI]] } {
               set helix_pitch "$mom_sim_lg_axis(Y) $mom_sim_pos(1)"
            } else {
               set helix_pitch "$mom_sim_lg_axis(Y) $mom_sim_pos(1) P $helix_pitch"
            }
           } else {
            set helix_pitch "P $helix_pitch"
           }

            eval PB_SIM_call SIM_move_helical_zcs 0 $dir 0 $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                                           $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                                           $mom_sim_lg_axis(K) $k $mom_sim_lg_axis(I) $i $helix_pitch
         }
      }

      default {

        # Detect helical condition
         if { [info exists mom_sim_helix_pitch] && ![EQ_is_zero $mom_sim_helix_pitch] } {
            set dz [expr $mom_sim_pos(2) - $mom_sim_prev_pos(2)]
            if { ![EQ_is_zero $dz] } {
               set helix_pitch [expr abs(2*$mom_sim_PI*$dz/$mom_sim_helix_pitch)]
            }
         }

         if { [string length $helix_pitch] == 0 } {

           # Handle full circle using half circle pt
            if { [string match "FULL_CIRCLE" $mom_sim_arc_output_mode] } {
               if { [EQ_is_equal $mom_sim_pos(0) $mom_sim_prev_pos(0)] && \
                    [EQ_is_equal $mom_sim_pos(1) $mom_sim_prev_pos(1)] } {

                  set dx [expr $mom_sim_pos(0) - $i]
                  set dy [expr $mom_sim_pos(1) - $j]
                  set a [expr atan2($dy,$dx)]
                  set b [expr $a + $mom_sim_PI]
                  set r [expr sqrt($dx*$dx + $dy*$dy)]
                  set px [expr $i + $r*cos($b)]
                  set py [expr $j + $r*sin($b)]

                  PB_SIM_call SIM_move_circular_zcs 0 0 $dir $mom_sim_lg_axis(X) $px $mom_sim_lg_axis(Y) $py\
                                                             $mom_sim_lg_axis(I) $i $mom_sim_lg_axis(J) $j
               }
            }

            eval PB_SIM_call SIM_move_circular_zcs 0 0 $dir $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                                            $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                                            $mom_sim_lg_axis(I) $i $mom_sim_lg_axis(J) $j
         } else {

          # pb602(r) - Activate logic below
           if 1 {
            if { [EQ_is_lt $helix_pitch [expr 2*$mom_sim_PI]] } {
               set helix_pitch "$mom_sim_lg_axis(Z) $mom_sim_pos(2)"
            } else {
               set helix_pitch "$mom_sim_lg_axis(Z) $mom_sim_pos(2) P $helix_pitch"
            }
           } else {
            set helix_pitch "P $helix_pitch"
           }

            eval PB_SIM_call SIM_move_helical_zcs 0 0 $dir $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                                           $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                                           $mom_sim_lg_axis(I) $i $mom_sim_lg_axis(J) $j $helix_pitch
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__config_isv_qc { } {
#=============================================================
  global mom_sim_isv_qc mom_sim_isv_qc_file mom_sim_isv_qc_mode

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Parameters for ISV autoQC can be set by the following
# system's environment variables :
#
#       UGII_ISV_QC, UGII_ISV_QC_FILE & UGII_ISV_QC_MODE.
#
# Users can, however, override the settings by uncommenting
# and revising any of the options below:
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   set mom_sim_isv_qc       0     ;# 1=ON, 0=OFF
   set mom_sim_isv_qc_file  ""    ;# "" or "listing_device"
   set mom_sim_isv_qc_mode  11110 ;# 10000 = SIM, 01000 = VNC, 00100 = PB_CMD, 00010 = Others, 00001 = mom_sim_pos
}


#=============================================================
proc PB_CMD_vnc__configure_isv_qc { } {
#=============================================================
  global mom_sim_isv_qc mom_sim_isv_qc_file mom_sim_isv_qc_mode

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Parameters for ISV autoQC can be set by the following
# system's environment variables :
#
#       UGII_ISV_QC, UGII_ISV_QC_FILE & UGII_ISV_QC_MODE.
#
# Users can, however, override the settings by uncommenting
# and revising any of the options below:
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   set mom_sim_isv_qc       0     ;# 1=ON, 0=OFF
   set mom_sim_isv_qc_file  ""    ;# "" or "listing_device"
   set mom_sim_isv_qc_mode  11110 ;# 10000 = SIM, 01000 = VNC, 00100 = PB_CMD, 00010 = Others, 00001 = mom_sim_pos
}


#=============================================================
proc PB_CMD_vnc__create_tmp_jct { } {
#=============================================================
  global mom_sim_tool_junction mom_sim_current_junction
  global mom_sim_curr_jct_matrix mom_sim_curr_jct_origin
  global mom_sim_tool_loaded


  #<911-2008> pb602(e) - Do not assume curr_jct (only defined in tool_change)
   if { ![info exists mom_sim_curr_jct_matrix] } {
      lappend mom_sim_curr_jct_matrix 1.0 0.0 0.0  0.0 1.0 0.0  0.0 0.0 1.0
      lappend mom_sim_curr_jct_origin 0.0 0.0 0.0
   }


  # pb502(2) -
  # Add protection
   if { [info exists mom_sim_tool_loaded] && [string length $mom_sim_tool_loaded] } {

      if { [string compare "$mom_sim_tool_junction" "$mom_sim_current_junction"] } {

         global mom_sim_result


         set __tmp_tool_jct  "__SIM_TMP_TOOL_JCT"


         PB_SIM_call SIM_ask_is_junction_exist $__tmp_tool_jct

         if { $mom_sim_result == 1 } {
            PB_SIM_call SIM_delete_junction $__tmp_tool_jct
         }

         eval PB_SIM_call SIM_create_junction $__tmp_tool_jct $mom_sim_tool_loaded $mom_sim_curr_jct_origin $mom_sim_curr_jct_matrix

         PB_SIM_call SIM_set_current_ref_junction $__tmp_tool_jct

         set mom_sim_tool_junction $__tmp_tool_jct
         set mom_sim_current_junction $mom_sim_tool_junction


        # Update mom_sim_pos w.r.t new ref jct
        # pb502(3) -
        # Caused problem in NT4200 -
        if 0 {
         if { ![catch {set pos [PB_SIM_call SIM_ask_last_position_zcs]} ] } {
            global mom_sim_pos
            set mom_sim_pos(0) [lindex $pos 0]
            set mom_sim_pos(1) [lindex $pos 1]
            set mom_sim_pos(2) [lindex $pos 2]
         }
        }

      }
   }
}


#=============================================================
proc PB_CMD_vnc__customize_dialog { } {
#=============================================================
#
# Comment out next statement (return) to customize the ISV User items.
#
# Make sure you set mom_sim_display_user_item to 1 in sim_high_level_sv_commands.tcl
# if you want to show your user items
#

return


  #-----------------------------------------------------------
  # This is the instruction how to customize the User items
  #
  # Dialog Syntax:
  # PB_SIM_call SIM_dialog_start "TITLE"
  # PB_SIM_call SIM_dialog_add_item "TYPE   ID   ATTRIBUTE"
  # PB_SIM_call SIM_dialog_end
  #
  # Note: The ID must be unique
  #
  # Description:
  #
  # Dialog Syntax will no longer supported System items in NX5
  #
  #----------------------------------------------------------#
  #                         Supported TYPE                   #
  #----------------------------------------------------------#
  #              NX4               |           NX5           #
  #----------------------------------------------------------#
  #     | SYS_ACTIVE_TOOL_ITEM     |        \       /        #
  #     | SYS_SPEED_ITEM           |         \     /         #
  # S   | SYS_FEED_ITEM            |          \   /          #
  # Y I | SYS_MACHINE_TIME_ITEM    |           \ /           #
  # S T | SYS_COOLANT_ITEM         |            X            #
  # T E | SYS_POSITION_ITEM        |           / \           #
  # E M | SYS_PROGRAM_WINDOW_ITEM  |          /   \          #
  # M S | SYS_MESSAGE_WINDOW_ITEM  |         /     \         #
  #     | SYS_STEP_CONTROL_ITEM    |        /       \        #
  #----------------------------------------------------------#
  #   I | USR_LABEL_ITEM           | USR_LABEL_ITEM          #
  # U T | USR_STRING_ITEM          | USR_STRING_ITEM         #
  # S E | USR_TOGGLE_ITEM          | USR_TOGGLE_ITEM         #
  # E M | USR_RADIO_ITEM           | USR_RADIO_ITEM          #
  # R S | USR_SEPARATOR_ITEM       | USR_RADIO_ITEM          #
  #----------------------------------------------------------#


  #------------------------------------------------------------------------------------------------------#
  #      TYPE           |           ATTRIBUTE                   |               DEFAULT                  #
  #------------------------------------------------------------------------------------------------------#
  # USR_LABEL_ITEM      | SENSITIVE, LABEL                      | SENSITIVE=<TRUE>, LABEL=<Label>        #
  # USR_STRING_ITEM     | SENSITIVE, LABEL, VALUE, WIDTH        | VALUE=<>, WIDTH=<10>                   #
  # USR_TOGGLE_ITEM     | SENSITIVE, LABEL, VALUE               | VALUE=<0>                              #
  # USR_RADIO_ITEM      | SENSITIVE, LABEL, VALUE, ORIENTATION, | VALUE=<0>, ORIENTATION=<VERTICAL>      #
  #                     | SPAN, LIST, FORMAT                    | SPAN=<3>, LIST=<item>, FORMAT=<BULLET> #
  # USR_SEPARATOR_ITEM  | -                                     | -                                      #
  #------------------------------------------------------------------------------------------------------#
  #
  #----------------------------------------------------------------------------------------#
  #  ATTRIBUTE  |                VALUE                        |          Example           #
  #----------------------------------------------------------------------------------------#
  # SENSITIVE   | TRUE, FALSE                                 | SENSITIVE=<FALSE>          #
  # LABEL       | String                                      | LABEL=<My Label>           #
  # VALUE       | String for USR_STRING_ITEM and              | VALUE=<My String Value>    #
  #             | Integer for USR_TOGGLE_ITEM, USR_RADIO_ITEM | VALUE=<1>                  #
  # WIDTH       | Integer                                     | WIDTH=<15>                 #
  # ORIENTATION | VERTICAL, HORIZONTAL                        | ORIENTATION=<VERTICAL>     #
  # SPAN        | Integer                                     | SPAN=<2>                   #
  # LIST        | String                                      | LIST=<item1, item2, item3> #
  # FORMAT      | BULLET, CHECK_BOX                           | FORMAT=<BULLET>            #
  #----------------------------------------------------------------------------------------#


   scan [string trim [MOM_ask_env_var UGII_VERSION]] "v%d" ugii_version


  #------------
  # Before NX5
  #------------
   if { $ugii_version < 5 } {

      PB_SIM_call SIM_dialog_start "Customized Simulation Control Panel"

     #--------------
     # System Items
     #--------------
      PB_SIM_call SIM_dialog_add_item "SYS_ACTIVE_TOOL_ITEM           S1"
      PB_SIM_call SIM_dialog_add_item "SYS_SPEED_ITEM                 S2"
      PB_SIM_call SIM_dialog_add_item "SYS_FEED_ITEM                  S3 ATTACHMENT=<LEFT 0 82>"
      PB_SIM_call SIM_dialog_add_item "SYS_MACHINE_TIME_ITEM          S4"
      PB_SIM_call SIM_dialog_add_item "SYS_COOLANT_ITEM               S5 ATTACHMENT=<LEFT 0 30>"
      PB_SIM_call SIM_dialog_add_item "SYS_POSITION_ITEM              S6"
      PB_SIM_call SIM_dialog_add_item "SYS_PROGRAM_WINDOW_ITEM        S7"
      PB_SIM_call SIM_dialog_add_item "SYS_MESSAGE_WINDOW_ITEM        S8"
      PB_SIM_call SIM_dialog_add_item "SYS_STEP_CONTROL_ITEM          S9"

      PB_SIM_call SIM_dialog_end

  #----------
  # NX5 & up
  #----------
   } else {

      PB_SIM_call SIM_dialog_start "User Items"

     #----------------
     # Add User Items
     #----------------
      PB_SIM_call SIM_dialog_add_item "USR_LABEL_ITEM     U1 LABEL=<Label>"
      PB_SIM_call SIM_dialog_add_item "USR_STRING_ITEM    U2 LABEL=<String> VALUE=<string value> WIDTH=<10>"
      PB_SIM_call SIM_dialog_add_item "USR_SEPARATOR_ITEM U3"
      PB_SIM_call SIM_dialog_add_item "USR_TOGGLE_ITEM    U4 LABEL=<Toggle> VALUE=<1>"
      PB_SIM_call SIM_dialog_add_item "USR_RADIO_ITEM     U5 LABEL=<Radio> VALUE=<1> ORIENTATION=<HORIZONTAL> SPAN=<3> LIST=<radio1,radio2,radio3> FORMAT=<CHECK_BOX>"
      PB_SIM_call SIM_dialog_end
   }
}


#=============================================================
proc PB_CMD_vnc__cycle_move { } {
#=============================================================
  global mom_sim_lg_axis
  global mom_sim_pos mom_sim_prev_pos
  global mom_sim_cycle_rapid_to_pos
  global mom_sim_cycle_feed_to_pos
  global mom_sim_cycle_retract_to_pos
  global mom_sim_cycle_mode
  global mom_sim_nc_register


   set mom_sim_pos(0) $mom_sim_prev_pos(0)
   set mom_sim_pos(1) $mom_sim_prev_pos(1)
   set mom_sim_pos(2) $mom_sim_prev_pos(2)


   if $mom_sim_cycle_mode(start_block) {

     global mom_sim_cycle_spindle_axis
     global mom_sim_cycle_rapid_to_dist
     global mom_sim_cycle_feed_to_dist
     global mom_sim_cycle_retract_to_dist
     global mom_sim_cycle_entry_pos

      set rapid_to_pos(0) $mom_sim_nc_register(X)
      set rapid_to_pos(1) $mom_sim_nc_register(Y)
      set rapid_to_pos(2) $mom_sim_nc_register(Z)

      if [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) > $rapid_to_pos($mom_sim_cycle_spindle_axis)] {
         set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) $rapid_to_pos($mom_sim_cycle_spindle_axis)
      }

      set rapid_to_pos($mom_sim_cycle_spindle_axis)  $mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis)

      if [string match "*R -*" $mom_sim_cycle_mode(rapid_to)] {
         if [string match "*Distance*" $mom_sim_cycle_mode(rapid_to)] {
            set rapid_to_pos($mom_sim_cycle_spindle_axis) [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_rapid_to_dist]
         }
      }
      set mom_sim_cycle_rapid_to_pos(0) $rapid_to_pos(0)
      set mom_sim_cycle_rapid_to_pos(1) $rapid_to_pos(1)
      set mom_sim_cycle_rapid_to_pos(2) $rapid_to_pos(2)

      set feed_to_pos(0) $mom_sim_nc_register(X)
      set feed_to_pos(1) $mom_sim_nc_register(Y)
      set feed_to_pos(2) $mom_sim_nc_register(Z)
      set feed_to_pos($mom_sim_cycle_spindle_axis)  $mom_sim_cycle_feed_to_pos($mom_sim_cycle_spindle_axis)

      switch $mom_sim_cycle_mode(feed_to) {
         "Distance" {
            set feed_to_pos($mom_sim_cycle_spindle_axis) [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) - $mom_sim_cycle_feed_to_dist]
         }
      }
      set mom_sim_cycle_feed_to_pos(0) $feed_to_pos(0)
      set mom_sim_cycle_feed_to_pos(1) $feed_to_pos(1)
      set mom_sim_cycle_feed_to_pos(2) $feed_to_pos(2)

      set retract_to_pos(0) $mom_sim_nc_register(X)
      set retract_to_pos(1) $mom_sim_nc_register(Y)
      set retract_to_pos(2) $mom_sim_nc_register(Z)
      set retract_to_pos($mom_sim_cycle_spindle_axis)  $mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis)

      if [string match "K -*" $mom_sim_cycle_mode(retract_to)] {
         if [string match "*Distance*" $mom_sim_cycle_mode(retract_to)] {
            set retract_to_pos($mom_sim_cycle_spindle_axis) [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_retract_to_dist]
         }
      }
      set mom_sim_cycle_retract_to_pos(0) $retract_to_pos(0)
      set mom_sim_cycle_retract_to_pos(1) $retract_to_pos(1)
      set mom_sim_cycle_retract_to_pos(2) $retract_to_pos(2)
   }

  # Preserve current position & motion type
   for { set i 0 } { $i < 3 } { incr i } {
      set sim_pos_save($i) $mom_sim_pos($i)
   }
   set sim_motion_type_save $mom_sim_nc_register(MOTION)

   set mom_sim_nc_register(MOTION) LINEAR


  # Clear off rotary move, if any, @ current pos
  #
   PB_SIM_call VNC_linear_move

    set mom_sim_pos(0) $mom_sim_cycle_rapid_to_pos(0)
    set mom_sim_pos(1) $mom_sim_cycle_rapid_to_pos(1)
    set mom_sim_pos(2) $mom_sim_cycle_rapid_to_pos(2)

   PB_SIM_call VNC_linear_move

    set mom_sim_pos(0) $mom_sim_cycle_feed_to_pos(0)
    set mom_sim_pos(1) $mom_sim_cycle_feed_to_pos(1)
    set mom_sim_pos(2) $mom_sim_cycle_feed_to_pos(2)

   PB_SIM_call VNC_linear_move

    set mom_sim_pos(0) $mom_sim_cycle_retract_to_pos(0)
    set mom_sim_pos(1) $mom_sim_cycle_retract_to_pos(1)
    set mom_sim_pos(2) $mom_sim_cycle_retract_to_pos(2)

   PB_SIM_call VNC_linear_move

  # Restore data
   for { set i 0 } { $i < 3 } { incr i } {
      set mom_sim_pos($i) $sim_pos_save($i)
   }
   set mom_sim_nc_register(MOTION) $sim_motion_type_save
}


#=============================================================
proc PB_CMD_vnc__cycle_move_hhc { } {
#=============================================================
#<09-23-05 gsl> Added to handle HHC drilling cycles


  global mom_sim_lg_axis
  global mom_sim_pos mom_sim_prev_pos
  global mom_sim_cycle_rapid_to_pos
  global mom_sim_cycle_feed_to_pos
  global mom_sim_cycle_retract_to_pos
  global mom_sim_cycle_mode
  global mom_sim_nc_register


#   set mom_sim_pos(0) $mom_sim_prev_pos(0)
#   set mom_sim_pos(1) $mom_sim_prev_pos(1)
#   set mom_sim_pos(2) $mom_sim_prev_pos(2)

   for { set i 0 } { $i < 3 } { incr i } {
      set sim_pos_save($i) $mom_sim_pos($i)
      set mom_sim_cycle_rapid_to_pos($i)   $mom_sim_pos($i)
      set mom_sim_cycle_feed_to_pos($i)    $mom_sim_pos($i)
      set mom_sim_cycle_retract_to_pos($i) $mom_sim_pos($i)
   }
   set sim_motion_type_save $mom_sim_nc_register(MOTION)

   global mom_sim_cycle_spindle_axis

   if ![info exists mom_sim_nc_register(Q203)] {
      set mom_sim_nc_register(Q203) $mom_sim_pos($mom_sim_cycle_spindle_axis)
   }
   if ![info exists mom_sim_nc_register(Q200)] {
      set mom_sim_nc_register(Q200) 0.0
   }
   if ![info exists mom_sim_nc_register(Q201)] {
      set mom_sim_nc_register(Q201) 0.0
   }
   if ![info exists mom_sim_nc_register(Q204)] {
      set mom_sim_nc_register(Q204) $mom_sim_nc_register(Q200)
   }


   set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis)  [expr $mom_sim_nc_register(Q203) + $mom_sim_nc_register(Q200)]
   set mom_sim_cycle_feed_to_pos($mom_sim_cycle_spindle_axis)  [expr $mom_sim_nc_register(Q203) + $mom_sim_nc_register(Q201)]
   set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis)  [expr $mom_sim_nc_register(Q203) + $mom_sim_nc_register(Q204)]

   set mom_sim_nc_register(MOTION) LINEAR
   set mom_sim_pos(0) $mom_sim_cycle_rapid_to_pos(0)
   set mom_sim_pos(1) $mom_sim_cycle_rapid_to_pos(1)
   set mom_sim_pos(2) $mom_sim_cycle_rapid_to_pos(2)

   PB_CMD_vnc__sim_motion

   set mom_sim_pos(0) $mom_sim_cycle_feed_to_pos(0)
   set mom_sim_pos(1) $mom_sim_cycle_feed_to_pos(1)
   set mom_sim_pos(2) $mom_sim_cycle_feed_to_pos(2)

   PB_CMD_vnc__sim_motion

   set mom_sim_pos(0) $mom_sim_cycle_retract_to_pos(0)
   set mom_sim_pos(1) $mom_sim_cycle_retract_to_pos(1)
   set mom_sim_pos(2) $mom_sim_cycle_retract_to_pos(2)

   PB_CMD_vnc__sim_motion

  # Restore data
   for { set i 0 } { $i < 3 } { incr i } {
      set mom_sim_pos($i) $sim_pos_save($i)
   }
   set mom_sim_nc_register(MOTION) $sim_motion_type_save
}


#=============================================================
proc PB_CMD_vnc__cycle_set { } {
#=============================================================
  global mom_sim_o_buffer
  global mom_sim_address mom_sim_pos mom_sim_prev_pos
  global mom_sim_nc_register
  global mom_sim_cycle_mode
  global mom_sim_cycle_rapid_to_pos
  global mom_sim_cycle_feed_to_pos
  global mom_sim_cycle_retract_to_pos
  global mom_sim_cycle_entry_pos
  global mom_sim_cycle_rapid_to_dist
  global mom_sim_cycle_feed_to_dist
  global mom_sim_cycle_retract_to_dist
  global mom_sim_cycle_spindle_axis

  global mom_sim_machine_type
  global mom_sim_4th_axis_plane mom_sim_5th_axis_plane


  # Interrogate tool axis to determine whether principal axis should be reversed.
  # This direction is needed when any of the cycle's parmeters is incremental.

  # Apply mirror factors to axis direction for all cases.
   global mom_sim_x_factor mom_sim_y_factor mom_sim_z_factor

   set axis_direction 1

   if [string match "*head*" $mom_sim_machine_type] {
      switch $mom_sim_4th_axis_plane {
         "ZX" {
          # Change axis direction only when it coincides with principal plane direction.
           if { $mom_sim_cycle_spindle_axis == 1 } {
            if [EQ_is_equal $mom_sim_nc_register(fourth_axis) -90.0] {
               set axis_direction -1
            }
            set axis_direction [expr $mom_sim_y_factor * $axis_direction]
           }
         }
         "YZ" {
           if { $mom_sim_cycle_spindle_axis == 0 } {
            if [EQ_is_equal $mom_sim_nc_register(fourth_axis) 90.0] {
               set axis_direction -1
            }
            set axis_direction [expr $mom_sim_x_factor * $axis_direction]
           }
         }
         "XY" {
           if { $mom_sim_cycle_spindle_axis == 2 } {
            set axis_direction [expr $mom_sim_z_factor * $axis_direction]
           }
         }
      }
   }

   if [string match "5_axis_dual_head" $mom_sim_machine_type] {
      switch $mom_sim_5th_axis_plane {
         "ZX" {
           if { $mom_sim_cycle_spindle_axis == 1 } {
            if [EQ_is_equal $mom_sim_nc_register(fifth_axis) -90.0] {
               set axis_direction -1
            }
            set axis_direction [expr $mom_sim_y_factor * $axis_direction]
           }
         }
         "YZ" {
           if { $mom_sim_cycle_spindle_axis == 0 } {
            if [EQ_is_equal $mom_sim_nc_register(fifth_axis) 90.0] {
               set axis_direction -1
            }
            set axis_direction [expr $mom_sim_x_factor * $axis_direction]
           }
         }
         "XY" {
           if { $mom_sim_cycle_spindle_axis == 2 } {
            set axis_direction [expr $mom_sim_z_factor * $axis_direction]
           }
         }
      }
   }

  # Determine axis direction for XZC mill-turn
   if { [string match "3_axis_mill_turn" $mom_sim_machine_type] } {
      if { $mom_sim_cycle_spindle_axis == 0 } {
         set axis_direction [expr $mom_sim_x_factor * $axis_direction]
      }
   }


  # Grab prev pos as entry pos
   foreach i { 0 1 2 } {
      set mom_sim_cycle_entry_pos($i) $mom_sim_prev_pos($i)
   }


  # nc_register(K_cycle) may never be set, since it's in conflict with nc_register(K).
   if { [info exists mom_sim_nc_register(K)] } {
      set mom_sim_nc_register(K_cycle) $mom_sim_nc_register(K)
   }

   if { ![info exists mom_sim_nc_register(K_cycle)] } {
      set mom_sim_nc_register(K_cycle) 0
   }

   if { ![info exists mom_sim_nc_register(R)] } {
      set mom_sim_nc_register(R) 0
   }

  # Initialize registers in case...
   if { ![info exists mom_sim_nc_register(X)] } {
      set mom_sim_nc_register(X) 0.0
   }
   if { ![info exists mom_sim_nc_register(Y)] } {
      set mom_sim_nc_register(Y) 0.0
   }
   if { ![info exists mom_sim_nc_register(Z)] } {
      set mom_sim_nc_register(Z) 0.0
   }

   set mom_sim_cycle_feed_to_pos(0) $mom_sim_nc_register(X)
   set mom_sim_cycle_feed_to_pos(1) $mom_sim_nc_register(Y)
   set mom_sim_cycle_feed_to_pos(2) $mom_sim_nc_register(Z)

   switch $mom_sim_cycle_mode(feed_to) {
      "Distance" {
         set mom_sim_cycle_feed_to_dist [expr abs($mom_sim_nc_register(Z)) * $axis_direction]

         if { $mom_sim_cycle_spindle_axis == 2 } { ;# Z axis
            set mom_sim_cycle_feed_to_pos(2) [expr $mom_sim_pos(2) - $mom_sim_cycle_feed_to_dist]
         } else {
            set mom_sim_cycle_feed_to_pos(2) $mom_sim_pos(2)
         }

        #<08-09-06 gsl> Recalculate top of hole per bottom. May not be needed???
         set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis)  [expr $mom_sim_cycle_feed_to_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_feed_to_dist]
      }
   }


  # Initialize rapid-to pos to feed-to pos
   set mom_sim_cycle_rapid_to_pos(0) $mom_sim_cycle_feed_to_pos(0)
   set mom_sim_cycle_rapid_to_pos(1) $mom_sim_cycle_feed_to_pos(1)
   set mom_sim_cycle_rapid_to_pos(2) $mom_sim_cycle_feed_to_pos(2)

   if { [string match "*R -*" $mom_sim_cycle_mode(rapid_to)] } {
      if { [string match "*Distance*" $mom_sim_cycle_mode(rapid_to)] } {
#>>>
        # The 1st hole may have been @ rapid-to pos already.
         set mom_sim_cycle_rapid_to_dist [expr $mom_sim_nc_register(R) * $axis_direction]

         if { [EQ_is_equal $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) $mom_sim_pos($mom_sim_cycle_spindle_axis)] } {

           #<08-08-06 gsl> May not be needed or a bug
           if 0 {
            set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis)  [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) - $mom_sim_cycle_rapid_to_dist]
           }
         }

         set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis)  [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_rapid_to_dist]

      } else {
         set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(R)
      }
   }


  # pb600 -
  # - Compensate for no retract-to condition
  #
   if { $axis_direction > 0 } {
      if { $mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) <= $mom_sim_cycle_feed_to_pos($mom_sim_cycle_spindle_axis) } {
         set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis)
      }
   } elseif { $axis_direction < 0 } {
      if { $mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) >= $mom_sim_cycle_feed_to_pos($mom_sim_cycle_spindle_axis) } {
         set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis)
      }
   }


  # Initialize retract-to pos
   set mom_sim_cycle_retract_to_pos(0) $mom_sim_cycle_rapid_to_pos(0)
   set mom_sim_cycle_retract_to_pos(1) $mom_sim_cycle_rapid_to_pos(1)
   set mom_sim_cycle_retract_to_pos(2) $mom_sim_cycle_rapid_to_pos(2)

   if { [string match "K*" $mom_sim_cycle_mode(retract_to)] } {
      if { [string match "*Distance*" $mom_sim_cycle_mode(retract_to)] } {
#>>>
        # The 1st hole may have been @ rapid-to pos already.
         set mom_sim_cycle_retract_to_dist [expr abs($mom_sim_nc_register(K_cycle)) * $axis_direction]

         if { [EQ_is_equal $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) $mom_sim_pos($mom_sim_cycle_spindle_axis)] } {

           #<08-09-06 gsl> Same reason for R word
           if 0 {
            set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis)  [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) - $mom_sim_cycle_retract_to_dist]
           }
         }

         set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis)  [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_retract_to_dist]

      } else {
         set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(K_cycle)
      }

   } elseif { [string match "G98/G99*" $mom_sim_cycle_mode(retract_to)] } {

      global mom_sim_nc_func

     # G98 - Retract to last Z before cycle
      if { [VNC_parse_nc_word mom_sim_o_buffer $mom_sim_nc_func(CYCLE_RETURN_AUTO) 1] } {

         switch $mom_sim_cycle_spindle_axis {
            0 {
               set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(LAST_X)
            }
            1 {
               set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(LAST_Y)
            }
            default {
               set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(LAST_Z)
            }
         }
      }
   }


   if { !$mom_sim_cycle_mode(start_block) } {
      PB_SIM_call PB_CMD_vnc__cycle_move
   }
}


#=============================================================
proc PB_CMD_vnc__define_misc_procs { } {
#=============================================================
 uplevel #0 {

  #-----------------------------------------------------------
  proc VNC_output_vnc_msg { message } {
  #-----------------------------------------------------------
     global mom_sim_message

     set mom_sim_message $message
     PB_CMD_vnc__output_vnc_msg
  }

  #-----------------------------------------------------------
  proc VNC_rotate_head_spindle_axis { degrees } {
  #-----------------------------------------------------------
  # This command rotates the head spindle axis.
  # - Existence of the axis can be interrogated from the kin model per
  #   componemt classified as _DEVICE_HOLDER_ON_HEAD

     global mom_sim_head_spindle_axis

     PB_SIM_call PB_CMD_vnc__ask_head_spindle_axis

     if { [info exists mom_sim_head_spindle_axis] } {
        PB_SIM_call SIM_move_rotary_axis 1 $mom_sim_head_spindle_axis $degrees
        PB_SIM_call SIM_update
     }
  }

  #-----------------------------------------------------------
  proc VNC_string_match { STR TKN } {
  #-----------------------------------------------------------
  # Match 2 string if they both exist
  #
     upvar $STR str
     upvar $TKN tkn

     if { [info exists str] && [info exists tkn] && [string match "$str" "$tkn"] } {
  return 1
     } else {
  return 0
     }
  }

  #-----------------------------------------------------------
  proc VNC_pause_win64 { args } {
  #-----------------------------------------------------------
   global env
   if { [info exists env(PB_SUPPRESS_UGPOST_DEBUG)]  &&  $env(PB_SUPPRESS_UGPOST_DEBUG) == 1 } {
  return
   }

   global gPB
   if { [info exists gPB(PB_disable_VNC_pause)]  &&  $gPB(PB_disable_VNC_pause) == 1 } {
  return
   }


   set cam_aux_dir  [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]
   set ug_wish "ugwish.exe"


   if { [file exists ${cam_aux_dir}$ug_wish] && [file exists ${cam_aux_dir}mom_pause_win64.tcl] } {

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
    # - A separated process will be created to construct the Tk dialog.
    #   This process will communicate with the main process via the state of a scratch file.
    #   This scratch file will collect the messages that need to be conveyed from the
    #   child process to the main process.
    ######
     global mom_logname

     set pause_file_name "[MOM_ask_env_var UGII_TMP_DIR]/${mom_logname}_mom_pause_[clock clicks].txt"

     if [file exists $pause_file_name] {
        file delete -force $pause_file_name
     }

     regsub -all {\\} $cam_aux_dir {/}  cam_aux_dir
     regsub -all { }  $cam_aux_dir {\ } cam_aux_dir

     regsub -all {\\} $pause_file_name {/}  pause_file_name
     regsub -all { }  $pause_file_name {\ } pause_file_name



    ######
    # The assumption at this point is we will always have the scratch file as the 1st
    # argument and optionally the title and message as the 2nd and 3rd arguments
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
          set gPB(PB_disable_VNC_pause) 1
       }
       cancel {
          close $fid
          file delete -force $pause_file_name

          set gPB(PB_disable_VNC_pause) 1
          PB_SIM_call SIM_mtd_reset

          uplevel #0 {
             MOM_abort "*** User Abort *** "
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

  #-----------------------------------------------------------
  proc VNC_pause { args } {
  #-----------------------------------------------------------
   global env
   if { [info exists env(PB_SUPPRESS_UGPOST_DEBUG)]  &&  $env(PB_SUPPRESS_UGPOST_DEBUG) == 1 } {
  return
   }

   global gPB
   if { [info exists gPB(PB_disable_VNC_pause)]  &&  $gPB(PB_disable_VNC_pause) == 1 } {
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

       VNC_pause_win64 $args
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
          set gPB(PB_disable_VNC_pause) 1
       }
       cancel {
          set gPB(PB_disable_VNC_pause) 1
          PB_SIM_call SIM_mtd_reset

          uplevel #0 {
             MOM_abort "*** User Abort *** "
          }
       }
       default { return }
     }
   }
  }

  #-----------------------------------------------------------
  proc VNC_escape_special_chars { s1 } {
  #-----------------------------------------------------------
  # This command is used to preprocess block buffer.
  #
   set s2 ""

   set len [string length $s1]
   for { set i 0 } { $i < $len } { incr i } {

      set c [string index $s1 $i]
      scan "$c" "%c" cv

     # Octal ASCII codes
      #  " = 042
      #  $ = 044
      #  & = 046
      #  ; = 073
      #  [ = 133
      #  \ = 134
      #  ] = 135
      #  { = 173
      #  | = 174
      #  } = 175

     # Do not escape the surrounding quotes, if any.
      if { $i == 0 || $i == [expr $len - 1] } {
         if { $cv == 042 } {
            set s2 "$s2$c"
            continue
         }
      }

      if { $cv == 042  ||  $cv == 044  ||  $cv == 046  ||  $cv == 073  ||  $cv == 0133 ||  $cv == 0134 ||  $cv == 0135 ||  $cv == 0173 ||  $cv == 0174 ||  $cv == 0175 } {

        # Add an escape char
         set s2 "$s2\\"
      }

      set s2 "$s2$c"
   }

  return $s2
  }

  #-----------------------------------------------------------
  proc VNC_update_sim_pos { } {
  #-----------------------------------------------------------
   global mom_sim_pos

   if { ![catch {set pos [PB_SIM_call SIM_ask_last_position_zcs]} ] } {
      set mom_sim_pos(0) [lindex $pos 0]
      set mom_sim_pos(1) [lindex $pos 1]
      set mom_sim_pos(2) [lindex $pos 2]
   }
  }

  #-----------------------------------------------------------
  proc VNC_set_current_ref_junction { ref_jct } {
  #-----------------------------------------------------------

   PB_SIM_call SIM_set_current_ref_junction $ref_jct

   global mom_sim_current_junction

   if { [info exists mom_sim_current_junction] } {
      if { ![catch {set pos [PB_SIM_call SIM_ask_last_position_zcs]} ] } {
         global mom_sim_pos
         set mom_sim_pos(0) [lindex $pos 0]
         set mom_sim_pos(1) [lindex $pos 1]
         set mom_sim_pos(2) [lindex $pos 2]
      }
   }
  }

  #-----------------------------------------------------------
  proc VNC_unset_procs { args } {
  #-----------------------------------------------------------

     if { [llength $args] == 0 } {
  return
     }

     foreach p $args {
        if { [llength [info commands [string trim $p] ] ] } {
           rename $p ""
        }
     }
  }

  #-----------------------------------------------------------
  proc VNC_unset_vars { args } {
  #-----------------------------------------------------------

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

  #-----------------------------------------------------------
  proc VNC_info { args } {
  #-----------------------------------------------------------
     if { [llength $args] > 0 } {
        set msg [lindex $args 0]
     } else {
        set msg ""
     }
     MOM_output_to_listing_device $msg
  }

  #-----------------------------------------------------------
  proc VNC_parse_nc_word { O_BUFF word flag args } {
  #-----------------------------------------------------------
  # - Reduce buffer & execute callback only
  #   when the requested type of match is found.
  #
  #   Arguments -
  #
  #     BUFFER  : Reference (pointer) to the block buffer
  #               (Normally you pass in "mom_sim_o_buffer" without "$" sign.)
  #               ** At this point, the block sequence number
  #                  has been removed from "mom_sim_o_buffer".
  #
  #     word    : token (string pattern) to be identified
  #
  #     flag    : 0 = Any match, do not remove token
  #               1 = Exact match
  #               2 = Extended match
  #               3 = Any match
  #
  #     args    : Optional callback command string to be executed
  #               when a match has been found.
  #
  #   Return -
  #               0 = No match
  #               1 = Match found
  #              -1 = Match found but callback not found
  #
    upvar $O_BUFF o_buff

     set tmp_buff $o_buff

     set status [VNC_parse_nc_block tmp_buff $word]

     if { $status > 0 } {
        if { $flag == 0  ||  $flag == 3  ||  $status == $flag } {
          # Trim buffer
           if { $flag != 0 } {
              set o_buff $tmp_buff
           }

          # Execute callback
           if { [llength $args] > 0 } {
              set exec_cb [string trim [lindex $args 0]]
           } else {
              set exec_cb ""
           }

           if { ![string match "" $exec_cb] } {
              if { [llength [info commands "$exec_cb"]] } {
                 eval "$exec_cb"
              } else {
  return -1
              }
           }
  return 1
        }
     }

  return 0
  }

  #-----------------------------------------------------------
  proc  MTX3_xform_csys { a b c x y z CSYS } {
  #-----------------------------------------------------------
     upvar $CSYS csys

  # <Note> a, b, c, x, y & z are measured w.r.t current csys space.
  #
  #                     Rotation about
  #         X                  Y                  Z
  # ----------------   ----------------   ----------------
  #   1     0     0     cosB   0   sinB    cosC -sinC    0
  #   0   cosA -sinA     0     1     0     sinC  cosC    0
  #   0   sinA  cosA   -sinB   0   cosB      0     0     1


    # Validate input data
     if { [EQ_is_zero $a] && [EQ_is_zero $b] && [EQ_is_zero $c] && [EQ_is_zero $x] && [EQ_is_zero $y] && [EQ_is_zero $z] } {
  return
     }


    #----------
    # Ratation
    #----------
     set xa [expr +1*$a]
     set yb [expr +1*$b]
     set zc [expr +1*$c]

     array set mm [array get csys]

     if { ![EQ_is_zero $a] || ![EQ_is_zero $b] || ![EQ_is_zero $c] } {

       # Rotate about X
       #
        set mx(0) 1;            set mx(1) 0;            set mx(2) 0
        set mx(3) 0;            set mx(4) [cosD $xa];   set mx(5) [-sinD $xa]
        set mx(6) 0;            set mx(7) [sinD $xa];   set mx(8) [cosD $xa]

       # Rotate about Y
       #
        set my(0) [cosD $yb];   set my(1) 0;            set my(2) [sinD $yb]
        set my(3) 0;            set my(4) 1;            set my(5) 0
        set my(6) [-sinD $yb];  set my(7) 0;            set my(8) [cosD $yb]

       # Rotate about Z
       #
        set mz(0) [cosD $zc];   set mz(1) [-sinD $zc];  set mz(2) 0
        set mz(3) [sinD $zc];   set mz(4) [cosD $zc];   set mz(5) 0
        set mz(6) 0;            set mz(7) 0;            set mz(8) 1

        MTX3_multiply  my mx mt
        MTX3_multiply  mz mt ma
        MTX3_transpose ma mt
        MTX3_multiply  mm mt csys
     }

    #-------------
    # Translation
    #-------------
     set u(0) $x;  set u(1) $y;  set u(2) $z
     MTX3_transpose mm ma
     MTX3_vec_multiply u ma v

     set csys(9)  [expr $csys(9)  + $v(0)]
     set csys(10) [expr $csys(10) + $v(1)]
     set csys(11) [expr $csys(11) + $v(2)]

     for { set i 0 } { $i < 12 } { incr i } {
        if { [EQ_is_zero $csys($i)] } {
           set csys($i) 0.0
        }
     }
  }

  #-----------------------------------------------------------
  proc VNC_map_from_machine_offsets { offsets } {
  #-----------------------------------------------------------
  # This function converts a 5-element offsets to a 6-element offsets.
  #

   if { [llength $offsets] == 6 } {
      return $offsets
   }

   global mom_sim_machine_type
   global mom_sim_4th_axis_plane
   global mom_sim_5th_axis_plane

   set xyzabc [list [lindex $offsets 0] [lindex $offsets 1] [lindex $offsets 2] 0.0 0.0 0.0]

   set 4th_index 0
   set 5th_index 0
   set ang4 [lindex $offsets 3]
   set ang5 [lindex $offsets 4]

   if { [string match "4*" $mom_sim_machine_type] } {
      switch $mom_sim_4th_axis_plane {
         "YZ" {
            set 4th_index 3
         }
         "ZX" {
            set 4th_index 4
         }
         "XY" {
            set 4th_index 5
         }
      }
      if { $4th_index > 0 } {
         set xyzabc [lreplace $xyzabc $4th_index $4th_index $ang4]
      }
   }

   if { [string match "5*" $mom_sim_machine_type] } {
      switch $mom_sim_4th_axis_plane {
         "XY" {
            set 4th_index 5
            switch $mom_sim_5th_axis_plane {
               "YZ" {
                  set 5th_index 3
               }
               "ZX" {
                  set 5th_index 4
               }
            }
         }
         "YZ" {
            set 4th_index 3
            switch $mom_sim_5th_axis_plane {
               "XY" {
                  set 5th_index 5
               }
               "ZX" {
                  set 5th_index 4
               }
            }
         }
         "ZX" {
            set 4th_index 4
            switch $mom_sim_5th_axis_plane {
               "XY" {
                  set 5th_index 5
               }
               "YZ" {
                  set 5th_index 3
               }
            }
         }
      }
      if { $4th_index > 0 } {
         set xyzabc [lreplace $xyzabc $4th_index $4th_index $ang4]
      }
      if { $5th_index > 0 } {
         set xyzabc [lreplace $xyzabc $5th_index $5th_index $ang5]
      }
   }

  return $xyzabc
  }

  #-----------------------------------------------------------
  proc VNC_map_to_machine_offsets { offsets } {
  #-----------------------------------------------------------
  # This function converts a 6-element offsets to a 5-element
  # offsets for an orthogonal machine.
  #

   if { [llength $offsets] == 5 } {
      return $offsets
   }

   global mom_sim_machine_type
   global mom_sim_4th_axis_plane
   global mom_sim_5th_axis_plane

   set xyzab [list [lindex $offsets 0] [lindex $offsets 1] [lindex $offsets 2] 0.0 0.0]

   set 4th_index 0
   set 5th_index 0

   if { [string match "4*" $mom_sim_machine_type] } {
      switch $mom_sim_4th_axis_plane {
         "YZ" {
            set 4th_index 3
         }
         "ZX" {
            set 4th_index 4
         }
         "XY" {
            set 4th_index 5
         }
      }
      if { $4th_index > 0 } {
         set ang4 [lindex $offsets $4th_index]
         set xyzab [lreplace $xyzab 3 3 $ang4]
      }
   }

   if { [string match "5*" $mom_sim_machine_type] } {
      switch $mom_sim_4th_axis_plane {
         "XY" {
            set 4th_index 5
            switch $mom_sim_5th_axis_plane {
               "YZ" {
                  set 5th_index 3
               }
               "ZX" {
                  set 5th_index 4
               }
            }
         }
         "YZ" {
            set 4th_index 3
            switch $mom_sim_5th_axis_plane {
               "XY" {
                  set 5th_index 5
               }
               "ZX" {
                  set 5th_index 4
               }
            }
         }
         "ZX" {
            set 4th_index 4
            switch $mom_sim_5th_axis_plane {
               "XY" {
                  set 5th_index 5
               }
               "YZ" {
                  set 5th_index 3
               }
            }
         }
      }
      if { $4th_index > 0 } {
         set ang4 [lindex $offsets $4th_index]
         set xyzab [lreplace $xyzab 3 3 $ang4]
      }
      if { $5th_index > 0 } {
         set ang5 [lindex $offsets $5th_index]
         set xyzab [lreplace $xyzab 4 4 $ang5]
      }
   }

  return $xyzab
  }

 } ;# uplevel
}


#=============================================================
proc PB_CMD_vnc__define_user_misc_procs { } {
#=============================================================
 uplevel #0 {
 }
}


#=============================================================
proc PB_CMD_vnc__define_wcs { } {
#=============================================================
  global mom_sim_result mom_sim_result1
  global mom_sim_csys_matrix
  global mom_sim_machine_zero_offsets
  global mom_sim_csys_data
  global mom_sim_wcs_offsets
  global mom_sim_csys_set
  global mom_sim_nc_register
  global mom_sim_machine_zero_csys_matrix
  global mom_sim_main_csys_matrix
  global mom_sim_local_csys_matrix


  # Define Machine Zero coordinate system offset from MTCS Junction
  #
   PB_SIM_call SIM_ask_mtcs_junction
   PB_SIM_call SIM_ask_init_junction_xform $mom_sim_result

   set i 0
   foreach v $mom_sim_result {
      set mom_sim_csys_matrix($i) $v
      incr i
   }
   foreach v $mom_sim_result1 {
      set mom_sim_csys_matrix($i) $v
      incr i
   }

    set x [lindex $mom_sim_machine_zero_offsets 0]
    set y [lindex $mom_sim_machine_zero_offsets 1]
    set z [lindex $mom_sim_machine_zero_offsets 2]

   MTX3_xform_csys 0.0 0.0 0.0 $x $y $z mom_sim_csys_matrix

   array set mom_sim_machine_zero_csys_matrix  [array get mom_sim_csys_matrix]


  # Initialize the main CSYS (0th WCS) matrix w.r.t. mom_sim_machine_zero_csys_matrix.
  # - This CSYS will get overwritten by a Main CSYS object during an in-process ISV.
  # - For standalone NC file ISV, this is where all work CSYS are defined.
  #
   array set csys_matrix [array get mom_sim_machine_zero_csys_matrix]

    set x [lindex $mom_sim_wcs_offsets(0) 0]
    set y [lindex $mom_sim_wcs_offsets(0) 1]
    set z [lindex $mom_sim_wcs_offsets(0) 2]
    set a [lindex $mom_sim_wcs_offsets(0) 3]
    set b [lindex $mom_sim_wcs_offsets(0) 4]
    set c [lindex $mom_sim_wcs_offsets(0) 5]

   MTX3_xform_csys $a $b $c $x $y $z csys_matrix
   for { set i 0 } { $i < 12 } { incr i } {
      set mom_sim_csys_data(0,$i) $csys_matrix($i)
   }


  # Zero work offsets
   set mom_sim_nc_register(WORK_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]


  # Initialize reference to 0th WCS
   array set mom_sim_csys_matrix  [array get csys_matrix]
   PB_SIM_call PB_CMD_vnc__set_kinematics
   set mom_sim_csys_set 1

   array set mom_sim_main_csys_matrix   [array get mom_sim_csys_matrix]
   array set mom_sim_local_csys_matrix  [array get mom_sim_csys_matrix]


  # Initialize other WCS matrices w.r.t. the 0th WCS.
  # - These will get overwritten by local CSYS object during an in-process ISV.
  #
   array set main_csys_matrix [array get csys_matrix]

   set n_wcs [array size mom_sim_wcs_offsets]

   for { set i 1 } { $i < $n_wcs } { incr i } {
      array set csys_matrix [array get main_csys_matrix]

       set x [lindex $mom_sim_wcs_offsets($i) 0]
       set y [lindex $mom_sim_wcs_offsets($i) 1]
       set z [lindex $mom_sim_wcs_offsets($i) 2]
       set a [lindex $mom_sim_wcs_offsets($i) 3]
       set b [lindex $mom_sim_wcs_offsets($i) 4]
       set c [lindex $mom_sim_wcs_offsets($i) 5]

      MTX3_xform_csys $a $b $c $x $y $z csys_matrix

      for { set j 0 } { $j < 12 } { incr j } {
         set mom_sim_csys_data($i,$j) $csys_matrix($j)
      }
   }
}


#=============================================================
proc PB_CMD_vnc__display_version { } {
#=============================================================
  global mom_sim_vnc_handler mom_sim_post_builder_version

   VNC_send_message "> Virtual NC Controller ($mom_sim_vnc_handler) created with Post Builder v$mom_sim_post_builder_version."
}


#=============================================================
proc PB_CMD_vnc__end_of_path { } {
#=============================================================
}


#=============================================================
proc PB_CMD_vnc__end_of_program { } {
#=============================================================
  global mom_sim_csys_set

   set mom_sim_csys_set 0
}


#=============================================================
proc PB_CMD_vnc__end_polar_mode { } {
#=============================================================
# This function ends polar mode and restores rotary axis configuration.
#
   global mom_sim_polar_mode

   if { [info exists mom_sim_polar_mode] && $mom_sim_polar_mode == 1 } {

      global mom_sim_pos
      global mom_sim_mt_axis

      global mom_sim_num_machine_axes
      global mom_sim_4th_axis_has_limits
      global mom_sim_5th_axis_has_limits
      global mom_sim_result

      switch $mom_sim_num_machine_axes {
         "4" {
            SIM_set_rotary_axes_config  [concat $mom_sim_mt_axis(4)]
         }
         "5" {
            SIM_set_rotary_axes_config  [concat $mom_sim_mt_axis(4) $mom_sim_mt_axis(5)]
         }
      }

      SIM_set_machining_mode MILL


     # Do not unwind rotary table, if it's limitless.
      set nx $mom_sim_num_machine_axes

      if ![eval set mom_sim_${nx}th_axis_has_limits] {

         PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis($nx) NORM_180

        # Fetch current angle from machine
         SIM_ask_axis_position $mom_sim_mt_axis($nx)
         if [EQ_is_zero $mom_sim_result] {
            set mom_sim_result 0.0
            PB_SIM_call SIM_move_rotary_axis 5 $mom_sim_mt_axis($nx) 0.0
         }
         set mom_sim_pos([expr $nx - 1]) $mom_sim_result
      }
   }
}


#=============================================================
proc PB_CMD_vnc__end_polar_motion { } {
#=============================================================
# This function restores motion's sim positions after a
# polarized motion is simulated.
#
   global mom_sim_polar_mode

   if { [info exists mom_sim_polar_mode] && $mom_sim_polar_mode > 0 } {

      if { $mom_sim_polar_mode == 2 } {

         global mom_sim_pos
         global mom_sim_current_x mom_sim_current_c

        # Restore to values in the block
        # set mom_sim_pos(0) $mom_sim_current_x
        # set mom_sim_pos(4) $mom_sim_current_c

        return
      }

      PB_CMD_vnc__end_polar_mode
   }
}


#=============================================================
proc PB_CMD_vnc__execute_nc_command { } {
#=============================================================
  global mom_sim_nc_block_started

  # Process setup data file, when 1st block comes thru.
  #
   if ![info exists mom_sim_nc_block_started] {
      global mom_sim_nc_program_file_name

      set mom_sim_nc_block_started  0

      if { [info exists mom_sim_nc_program_file_name] && [file exists $mom_sim_nc_program_file_name] } {

         set setup_tcl_file [join [split [file rootname $mom_sim_nc_program_file_name] \\] /]_setup.tcl
         set setup_dat_file [file rootname $setup_tcl_file].dat

         if [file exists $setup_tcl_file] {

            source $setup_tcl_file

            set mom_sim_nc_block_started  1

         } elseif [file exists $setup_dat_file] {

            set setup_dat_file_id [open $setup_dat_file RDONLY]

            while { [eof $setup_dat_file_id] == 0 } {
               set line [gets $setup_dat_file_id]

               if { [string compare "" [string trim $line]] } {
                  PB_SIM_call VNC_sim_nc_block $line
               }
            }

            close $setup_dat_file_id

            set mom_sim_nc_block_started  1
         }
      }

     # The driver needs to be notified somehow that the NC file does not
     # provide its own setup data and will use driver's setup.

      if !$mom_sim_nc_block_started {
         VNC_pause "Setup data not found for NC code file : $mom_sim_nc_program_file_name"
        # MOM_abort "*** Abort ISV due to missing Setup data file!"
      }
   }

  # Simulate block by block
  #
   global mom_sim_nc_command

   if { [string compare "" [string trim $mom_sim_nc_command]] } {
      PB_SIM_call VNC_sim_nc_block $mom_sim_nc_command
   }
}


#=============================================================
proc PB_CMD_vnc__from_home { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_pos
  global mom_sim_lg_axis


  # Move to the intermediate pt
   set coord_list [list]
   if [info exists mom_sim_nc_register(REF_INT_PT_X_PREV)] {
      lappend coord_list $mom_sim_lg_axis(X)  $mom_sim_nc_register(REF_INT_PT_X_PREV)
   }
   if [info exists mom_sim_nc_register(REF_INT_PT_Y_PREV)] {
      lappend coord_list $mom_sim_lg_axis(Y)  $mom_sim_nc_register(REF_INT_PT_Y_PREV)
   }
   if [info exists mom_sim_nc_register(REF_INT_PT_Z_PREV)] {
      lappend coord_list $mom_sim_lg_axis(Z)  $mom_sim_nc_register(REF_INT_PT_Z_PREV)
   }

   global mom_sim_num_machine_axes
   if { $mom_sim_num_machine_axes > 3 } {
      if [info exists mom_sim_nc_register(REF_INT_PT_4_PREV)] {
         lappend coord_list $mom_sim_lg_axis(4)  $mom_sim_nc_register(REF_INT_PT_4_PREV)
      }
   }

   if { $mom_sim_num_machine_axes > 4 } {
      if [info exists mom_sim_nc_register(REF_INT_PT_5_PREV)] {
         lappend coord_list $mom_sim_lg_axis(5)  $mom_sim_nc_register(REF_INT_PT_5_PREV)
      }
   }

  # Create a temp jct for subsequent moves incase the tool is not set properly.
   PB_SIM_call VNC_create_tmp_jct


  # Move to the intermediate point.
   if { [llength $coord_list] > 0 } {
      eval PB_SIM_call VNC_move_linear_zcs RAPID $coord_list
   }

  # Ensure Y is zero in lathe mode
   if [string match "TURN" $mom_sim_nc_register(MACHINE_MODE)] {
      set mom_sim_pos(1) 0
   }

  # Move to target
   switch $mom_sim_num_machine_axes {
      4 {
         PB_SIM_call VNC_move_linear_zcs RAPID  $mom_sim_lg_axis(X) $mom_sim_pos(0) $mom_sim_lg_axis(Y) $mom_sim_pos(1) $mom_sim_lg_axis(Z) $mom_sim_pos(2) $mom_sim_lg_axis(4) $mom_sim_pos(3)
      }
      5 {
         PB_SIM_call VNC_move_linear_zcs RAPID  $mom_sim_lg_axis(X) $mom_sim_pos(0) $mom_sim_lg_axis(Y) $mom_sim_pos(1) $mom_sim_lg_axis(Z) $mom_sim_pos(2) $mom_sim_lg_axis(4) $mom_sim_pos(3) $mom_sim_lg_axis(5) $mom_sim_pos(4)
      }
      default {
         PB_SIM_call VNC_move_linear_zcs RAPID  $mom_sim_lg_axis(X) $mom_sim_pos(0) $mom_sim_lg_axis(Y) $mom_sim_pos(1) $mom_sim_lg_axis(Z) $mom_sim_pos(2)
      }
   }
}


#=============================================================
proc PB_CMD_vnc__init_isv_qc { } {
#=============================================================
#
# *** DO NOT rename or remove this command!
#

  global mom_sim_isv_qc mom_sim_isv_qc_file mom_sim_isv_qc_mode


   if { [llength [info commands "PB_CMD_vnc__config_isv_qc"]] } {
      PB_CMD_vnc__config_isv_qc
   }


  # Disable qc output during extended NC output, unless it's in debug mode.
   global mom_sim_post_builder_debug
   if { ![info exists mom_sim_post_builder_debug] || !$mom_sim_post_builder_debug } {
      global mom_sim_output_extended_nc
      if { [info exists mom_sim_output_extended_nc] && $mom_sim_output_extended_nc == 1 } {
         set mom_sim_isv_qc  0
      }
   }


  # Preprocess QC mode
   set mom_sim_isv_qc_mode [string trimleft $mom_sim_isv_qc_mode 0]
   if { [string length $mom_sim_isv_qc_mode] == 0 } {
      set mom_sim_isv_qc 0
   }


  # Open message file
   if { [info exists mom_sim_isv_qc] && $mom_sim_isv_qc > 0 } {

      global mom_sim_vnc_handler_loaded

      if { ![info exists mom_sim_isv_qc_file] || ![string match "listing_device" $mom_sim_isv_qc_file] } {
         set  mom_sim_isv_qc_file ""
      }

      if { [string match "" [string trim $mom_sim_isv_qc_file]] } {

        # Default message file name is derived from the VNC.
        # User can define her own file name for the purpose.

         global mom_part_name
         set part_name "[join [split [file rootname [file tail $mom_part_name]] \\] /]"
         set file_name "[file rootname $mom_sim_vnc_handler_loaded]_${part_name}_qc.out"

         if { [catch {set mom_sim_isv_qc_file [open "$file_name" w]} ] } {
            catch { VNC_send_message "> Failed to open QC output file $file_name. Output to listing device." }
            set mom_sim_isv_qc_file "listing_device"
         } else {
            catch { VNC_send_message "> QC output file : $file_name" }
         }
      } else {
         catch { VNC_send_message "> QC output file : listing device" }
      }
   }


uplevel #0 {

#*************************************************************************
# General wrapper for all SIM, VNC & PB_CMD calls.
#
# - It can not wrap commands that pass references (pointers) as arguments,
#   ex. VNC_parse_nc_block & all math functions (EQ, VEC & MTX3).
#
#
proc PB_SIM_call { command args } {
#*************************************************************************
  global mom_sim_isv_qc
  global mom_sim_isv_qc_mode


  # Preprocess arguments list & construct command string to evaluate
   if { [llength $args] } {
      set args_list ""
      for { set i 0 } { $i < [llength $args] } { incr i } {

         set arg [lindex $args $i]

        # pb602(s) - This is needed.
         if { $i == 0 } {
            if { ![string compare $command "VNC_sim_nc_block"] || ![string compare $command "VNC_parse_motion_word"] } {
               set arg [VNC_escape_special_chars $arg]
            }
         }

        # Convert any multi-elements argument to a list.
         if { [llength $arg] > 1 } {
            set arg [list $arg]
         }

         lappend args_list $arg
      }
      set cmd_string "$command [join $args_list]"
   } else {
      set cmd_string "$command"
   }


  # Initialize the QC flag, if not defined.
   if { ![info exists mom_sim_isv_qc] } {
      set mom_sim_isv_qc 0
   }


  # Output regular QC messages per mode specified
   if { $mom_sim_isv_qc == 1 } {

     # Add a blank line before VNC_sim_nc_block
      if { [string match "VNC_sim_nc_block" $command] } {
         PB_SIM_output_qc_cmd_string ""
      }

      set output_bit $mom_sim_isv_qc_mode

      set base 10000

      if { $output_bit >= $base } {
         if { [string match "SIM_*" $command] } {
            if { [string match "SIM_ask_*" $command] || [string match "SIM_find_*" $command] || [string match "SIM_convert_*" $command] } {

               PB_SIM_output_qc_cmd_string "# $cmd_string"

            } else {

               PB_SIM_output_qc_cmd_string $cmd_string
            }
         }
         set output_bit [expr $output_bit - $base]
      }
      set base [expr $base / 10]
      if { $output_bit >= $base } {
         if { [string match "VNC_*" $command] } {
            PB_SIM_output_qc_cmd_string $cmd_string
         }
         set output_bit [expr $output_bit - $base]
      }
      set base [expr $base / 10]
      if { $output_bit >= $base } {
         if { [string match "PB_CMD_*" $command] } {
            PB_SIM_output_qc_cmd_string $cmd_string
         }
         set output_bit [expr $output_bit - $base]
      }
      set base [expr $base / 10]
      if { $output_bit >= $base } {
         if { ![string match "SIM_*" $command] && ![string match "VNC_*" $command] && ![string match "PB_CMD_*" $command] } {
            PB_SIM_output_qc_cmd_string $cmd_string
         }
      }
   }

   global mom_sim_message
   set val ""

  # Verify existence of the command
   if { ![llength [info commands "$command"]] } {
      set msg "# *** ERROR *** \"$command\" does not exist!"
      if { $mom_sim_isv_qc == 1 } {
         PB_SIM_output_qc_cmd_string "$msg"
      } else {
         set mom_sim_message "$msg"
         PB_CMD_vnc__send_message
      }

     # Define a dummy proc to eliminate the same error messages from subsequent calls.
      proc $command { args } { return }
   }

  # Evaluate command string. Abort, if error.
   if { [catch { set val [eval $cmd_string] } sta] } {
      set msg "# *** ABORT *** $cmd_string"
      if { $mom_sim_isv_qc == 1 }  {
         PB_SIM_output_qc_cmd_string "$msg"
      } else {
         set mom_sim_message "$msg"
         PB_CMD_vnc__send_message
      }

      MOM_abort "$cmd_string : $sta"
   }

  # Execution OK, pass on returned value to caller
return $val
}


#*************************************************************
# QC messages handler to be called by PB_SIM_call wrapper.
#
proc PB_SIM_output_qc_cmd_string { args } {
#*************************************************************
  global mom_sim_isv_qc mom_sim_isv_qc_file

  # This command should not be called if the QC mode is never initialized.
   if { ![info exists mom_sim_isv_qc] || $mom_sim_isv_qc <= 0 } {
return
   }

  # Pad blanks per call stack level
   set n_level [expr [info level] - 1]
   if { $n_level < 0 } { set n_level 0 }
   set lead [format %${n_level}c 32]

  # pb502(4) -
  # Skip padding for the 1st string containing proc definitions
   if { [string match "* VNC_CalculateDurationTime *" [lindex $args 0]] } {
      set lead ""
   }

  # The QC file handler should have been defined by the driver already,
  # by the time this command is called.
   if { ![info exists mom_sim_isv_qc_file] || [string match "" $mom_sim_isv_qc_file] } {
      MOM_output_to_listing_device "$lead[join $args]"
return
   }

  # Construct the message
   if 1 {
      set msg "$lead[join $args]"
   } else {
     # Add calls stack to the message
      set stack [VNC_trace]
      set idx [lsearch -glob $stack "PB_SIM_*"]
      while { $idx >= 0 } {
         set stack [lreplace $stack $idx $idx]
         set idx [lsearch -glob $stack "PB_SIM_*"]
      }
      set msg "[join $stack \n]\n\n   $lead[join $args]\n\n"
   }


  # Add mom_sim_pos to the msg per mode
   global mom_sim_isv_qc_mode
   if { [expr fmod($mom_sim_isv_qc_mode,10) == 1] } {
      global mom_sim_pos
      set msg "$msg   ;# -> [join [split [VNC_sort_array_vals mom_sim_pos]]]"
   }


  # Direct output to either the listing device or a file.
   if { [string match "listing_device" $mom_sim_isv_qc_file] } {
      MOM_output_to_listing_device "$msg"
   } else {
      puts $mom_sim_isv_qc_file "$msg"

     # >>> Flushing buffer slows down the performance
     # flush $mom_sim_isv_qc_file
   }
}

} ;# uplevel


  # Write out time calc callbacks
   if { [info exists mom_sim_isv_qc] && $mom_sim_isv_qc > 0 } {
      set cb_string { "#=============================================================" "proc VNC_CalculateDurationTime { linear_or_angular delta } {" "#=============================================================" "   global mom_sim_motion_linear_or_angular mom_sim_travel_delta" "   global mom_sim_duration_time" " " "   set mom_sim_motion_linear_or_angular \$linear_or_angular" "   set mom_sim_travel_delta \$delta" " " " PB_SIM_call PB_CMD_vnc__calculate_duration_time" " " "return \$mom_sim_duration_time" "}" " " }

      set proc_list { PB_CMD_vnc__calculate_duration_time MOM_SIM_initialize_mtd MOM_SIM_exit_mtd }

      foreach proc_name $proc_list {

         if { [llength [info procs $proc_name]] > 0 } {

            lappend cb_string "#============================================================="
            lappend cb_string "proc $proc_name { } \{"

            if { [string match "MOM_SIM_exit_mtd" $proc_name] } {
               lappend cb_string "#============================================================="
            }

           # Remove 1st & last blank lines from proc body
            set pbody [split [info body $proc_name] \n]
            set pbody [lreplace $pbody 0 0]
            set pbody [lreplace $pbody end end]

           # Append body to output list
            foreach line $pbody {
               lappend cb_string $line
            }

           # Add closing brace
            lappend cb_string  "\}"
            lappend cb_string  " "
         }
      }

      PB_SIM_output_qc_cmd_string "[join $cb_string \n]"
   }
}


#=============================================================
proc PB_CMD_vnc__init_sim_vars { } {
#=============================================================
  global mom_sim_word_separator mom_sim_word_separator_len
  global mom_sim_pos
  global mom_sim_tool_loaded
  global mom_sim_tool_junction
  global mom_sim_curr_jct_matrix mom_sim_curr_jct_origin
  global mom_sim_nc_register
  global mom_sim_wcs_offsets
  global mom_sim_ug_tool_name
  global mom_sim_result mom_sim_result1


  # Define some misc commands.
  # -> This call must be done 1st!!!
   PB_SIM_call PB_CMD_vnc__define_misc_procs


  # pb502(14) - Add user's own commands
   PB_SIM_call PB_CMD_vnc__define_user_misc_procs


  # pb600 -
  # - Retain current state of the participating NC axes, if any, before switching to new set
  #
   global mom_sim_mt_axis

   if { [info exists mom_sim_mt_axis(X)] && [info exists mom_sim_pos(0)] } {
      set mom_sim_nc_register($mom_sim_mt_axis(X)) $mom_sim_pos(0)
   }
   if { [info exists mom_sim_mt_axis(Y)] && [info exists mom_sim_pos(1)] } {
      set mom_sim_nc_register($mom_sim_mt_axis(Y)) $mom_sim_pos(1)
   }
   if { [info exists mom_sim_mt_axis(Z)] && [info exists mom_sim_pos(2)] } {
      set mom_sim_nc_register($mom_sim_mt_axis(Z)) $mom_sim_pos(2)
   }
   if { [info exists mom_sim_mt_axis(4)] && [info exists mom_sim_pos(3)] } {
      set mom_sim_nc_register($mom_sim_mt_axis(4)) $mom_sim_pos(3)
   }
   if { [info exists mom_sim_mt_axis(5)] && [info exists mom_sim_pos(4)] } {
      set mom_sim_nc_register($mom_sim_mt_axis(5)) $mom_sim_pos(4)
   }


  # Initialize var that defers tool length comp @ tool change until G43/44
   global mom_sim_tool_length_comp_auto
   VNC_unset_vars mom_sim_tool_length_comp_auto


  # Transfer static data from the Post.
  #
   PB_SIM_call VNC_load_post_definitions


  # Inspect NC functions
  #
   PB_SIM_call PB_CMD_vnc__inspect_nc_func


  # When a VNC is used to output VNC messages only w/o simulation.
  #
   global mom_sim_vnc_msg_only
   if { [info exists mom_sim_vnc_msg_only] && $mom_sim_vnc_msg_only } {
return
   }


  # Abolish end-of-block symbol for CAM program (non-standalone NC program) simulation
   global mom_sim_post_builder_rev_post
   global mom_sim_end_of_block mom_sim_end_of_block_len
   if { !$mom_sim_post_builder_rev_post } {
      set mom_sim_end_of_block ""
      set mom_sim_end_of_block_len 0
   }


  # Display this VNC name in ISV.
  #
   PB_SIM_call PB_CMD_vnc__display_version


  # Initialize controller's input unit to post's output unit
  #
   global mom_sim_output_unit
   if { ![info exists mom_sim_nc_register(UNIT)] } {
      set mom_sim_nc_register(UNIT) $mom_sim_output_unit
   }


  # Undefine machine tool kinematics assignment
  # to clear up residual variables.
  #
   global mom_sim_zcs_base mom_sim_zcs_base_MCS mom_sim_zcs_base_LCS
   global mom_sim_spindle_comp mom_sim_spindle_jct mom_sim_pivot_jct
   global mom_sim_advanced_kinematic_jct
   global mom_sim_mt_axis

   VNC_unset_vars  mom_sim_zcs_base_MCS\
                   mom_sim_zcs_base_LCS\
                   mom_sim_zcs_base\
                   mom_sim_spindle_comp\
                   mom_sim_spindle_jct\
                   mom_sim_pivot_jct\
                   mom_sim_advanced_kinematic_jct\
                   mom_sim_mt_axis


  # pb502(5) -
  # Save machine base component as global var
  #
   global mom_sim_machine_base_comp
   set mom_sim_result ""
   set mom_sim_machine_base_comp MACHINE_BASE
   PB_SIM_call SIM_ask_machine_base_component
   if { ![string match "" $mom_sim_result] } {
      set mom_sim_machine_base_comp $mom_sim_result
   }


  # Interrogate actual number of NC axes from model
  # This enables use of a higher dof driver on a lower dof machine.
   global mom_sim_num_machine_axes

   PB_SIM_call SIM_ask_nc_axes_of_mtool
   if { $mom_sim_result < $mom_sim_num_machine_axes } {
      set mom_sim_num_machine_axes $mom_sim_result
   }


  # Additional angle to index tool turret on Z-X plane for sub-spindle
  # When necessary, this angle can be specified in the ____map function or
  # other command that surely gets executed.
   global mom_sim_add_turret_angle
   set mom_sim_add_turret_angle 0.0

  # Force some parms to be defined
   set map_machine_ok 1
   if { [catch { PB_SIM_call PB_CMD_vnc____map_machine_tool_axes }] } {
      set map_machine_ok 0
   }


  #------------------------------
  # Map machine tool assignments
  #------------------------------
  # Account for multi-spindle case.
   if { [PB_SIM_call PB_CMD_vnc__ask_number_of_active_channels] > 1 ||\
        [PB_SIM_call PB_CMD_vnc__ask_number_of_lathe_spindles] > 1 } {

      if { !$map_machine_ok } {
        # Fetch machine kinematics from model
         if { [string match "TRUE" [PB_SIM_call MOM_validate_machine_model]] } {
            PB_SIM_call PB_CMD_vnc__reload_machine_tool_axes
         }
      }

   } else {

      if { [string match "TRUE" [PB_SIM_call MOM_validate_machine_model]] } {
        # Fetch machine kinematics from model
         if { [catch { PB_SIM_call PB_CMD_vnc__reload_machine_tool_axes }] } {
            PB_SIM_call PB_CMD_vnc____map_machine_tool_axes
         }
      }
   }


  # Initialize a null list for other NC codes to be simulated.
  # Actual code list will be defined in PB_CMD_vnc____set_nc_definitions.
  #
   global mom_sim_other_nc_codes
   global mom_sim_other_nc_codes_ex

   set mom_sim_other_nc_codes [list]
   set mom_sim_other_nc_codes_ex [list]


  # Add user's NC data definition.
  #
   if { [llength [info commands "PB_CMD_vnc__set_nc_definitions"]] } {
      PB_SIM_call PB_CMD_vnc__set_nc_definitions
   } else {
      PB_SIM_call PB_CMD_vnc____set_nc_definitions
   }


  # pb800(b) -
  # Load alternate unit setting for VNC
  #
   PB_SIM_call VNC_load_alternate_unit_settings


  # Add more user's NC data definition required for conversion.
  # (Legacy only)
   PB_SIM_call PB_CMD_vnc__fix_nc_definitions


  # Unset Y axis for a lathe, if necessary.
  #
   PB_SIM_call PB_CMD_vnc__unset_Y_axis


  # Validity check for machine tool parameters.
  #
   PB_SIM_call PB_CMD_vnc__validate_machine_tool


  # Nullify ref pos of MTCS
   global mom_sim_pos_mtcs
   VNC_unset_vars  mom_sim_pos_mtcs


  # Logical axes assignments (not from the post?)
  # It works to equate logical names to the physical names.
  #
   global mom_sim_lg_axis mom_sim_nc_axes mom_sim_address

  # Linear axes are commanded by logical names, whereas
  # rotary axes are commanded by physical names.
  #
   set mom_sim_lg_axis(X) X
   set mom_sim_lg_axis(Y) Y
   set mom_sim_lg_axis(Z) Z
   set mom_sim_lg_axis(I) I
   set mom_sim_lg_axis(J) J
   set mom_sim_lg_axis(K) K

  # Unset rotary axes first
   if { [info exists mom_sim_lg_axis(4)] } {
      unset mom_sim_lg_axis(4)
   }
   if { [info exists mom_sim_lg_axis(5)] } {
      unset mom_sim_lg_axis(5)
   }

   set mom_sim_nc_axes [concat $mom_sim_lg_axis(X) $mom_sim_lg_axis(Y) $mom_sim_lg_axis(Z)]

   switch $mom_sim_num_machine_axes {
      4 {
         set mom_sim_lg_axis(4) $mom_sim_mt_axis(4)
         lappend mom_sim_nc_axes $mom_sim_lg_axis(4)
      }
      5 {
         set mom_sim_lg_axis(4) $mom_sim_mt_axis(4)
         set mom_sim_lg_axis(5) $mom_sim_mt_axis(5)
         lappend mom_sim_nc_axes $mom_sim_lg_axis(4) $mom_sim_lg_axis(5)
      }
   }


  # Initialize data for simulation.
  #
   if { ![info exists mom_sim_ug_tool_name] } {
      set mom_sim_ug_tool_name ""
   }

   if { ![info exists mom_sim_tool_loaded] } {
      set mom_sim_tool_loaded ""
   }

   if { ![info exists mom_sim_tool_junction] } {
      set mom_sim_tool_junction "$mom_sim_spindle_jct"
   }

  #<911-2008> pb602(e) - Do not assume curr_jct (only defined in PB_CMD_vnc__offset_tool_jct)
  #                      Also see changes in PB_CMD_vnc__create_tmp_jct
  if 0 {
   if { ![info exists mom_sim_curr_jct_matrix] } {
      lappend mom_sim_curr_jct_matrix 1.0 0.0 0.0  0.0 1.0 0.0  0.0 0.0 1.0
   }

   if { ![info exists mom_sim_curr_jct_origin] } {
      lappend mom_sim_curr_jct_origin 0.0 0.0 0.0
   }
  }

   for { set i 0 } { $i < 8 } { incr i } {
      if { ![info exists mom_sim_pos($i)] } {
         set mom_sim_pos($i) 0
      }
   }


  # pb600 -
  # - Restore machine to the previously visited state, if any.
  #
   if { [info exists mom_sim_nc_register($mom_sim_mt_axis(X))] } {
      set mom_sim_pos(0) $mom_sim_nc_register($mom_sim_mt_axis(X))
   }
   if { [info exists mom_sim_nc_register($mom_sim_mt_axis(Z))] } {
      set mom_sim_pos(2) $mom_sim_nc_register($mom_sim_mt_axis(Z))
   }
   if { [info exists mom_sim_mt_axis(Y)] } {
      if { [info exists mom_sim_nc_register($mom_sim_mt_axis(Y))] } {
         set mom_sim_pos(1) $mom_sim_nc_register($mom_sim_mt_axis(Y))
      }
   }
   if { $mom_sim_num_machine_axes > 3 } {
      if { [info exists mom_sim_nc_register($mom_sim_mt_axis(4))] } {
         set mom_sim_pos(3) $mom_sim_nc_register($mom_sim_mt_axis(4))
      }
   }
   if { $mom_sim_num_machine_axes > 4 } {
      if { [info exists mom_sim_nc_register($mom_sim_mt_axis(5))] } {
         set mom_sim_pos(4) $mom_sim_nc_register($mom_sim_mt_axis(5))
      }
   }


  # Initialize controller's states, in case, not set in a VNC by
  # PB_CMD_vnc____set_nc_definitions
  #
   global mom_sim_vnc_msg_prefix
   if { ![info exists mom_sim_vnc_msg_prefix] } {
      set mom_sim_vnc_msg_prefix  "VNC_MSG::"
   }

   global mom_sim_spindle_max_rpm mom_sim_spindle_speed
   if { ![info exists mom_sim_spindle_max_rpm] } {
      set mom_sim_spindle_max_rpm 0
   }
   if { ![info exists mom_sim_spindle_speed] } {
      set mom_sim_spindle_speed 0
   }

   global mom_sim_cycle_spindle_axis
   if { ![info exists mom_sim_cycle_spindle_axis] } {
      set mom_sim_cycle_spindle_axis 2
   }

   if { ![info exists mom_sim_nc_register(POWER_ON_WCS)] } {
      set mom_sim_nc_register(POWER_ON_WCS) 0
   }

   if { ![info exists mom_sim_nc_register(WCS)] } {
      set mom_sim_nc_register(WCS) $mom_sim_nc_register(POWER_ON_WCS)
   }

   if { ![info exists mom_sim_nc_register(MOTION)] } {
      set mom_sim_nc_register(MOTION) RAPID
   }
   if { ![info exists mom_sim_nc_register(INPUT)] } {
      set mom_sim_nc_register(INPUT) ABS
   }
   if { ![info exists mom_sim_nc_register(STROKE_LIMIT)] } {
      set mom_sim_nc_register(STROKE_LIMIT) ON
   }
   if { ![info exists mom_sim_nc_register(CUTCOM)] } {
      set mom_sim_nc_register(CUTCOM) OFF
   }
   if { ![info exists mom_sim_nc_register(TL_ADJUST)] } {
      set mom_sim_nc_register(TL_ADJUST) OFF
   }
   if { ![info exists mom_sim_nc_register(SCALE)] } {
      set mom_sim_nc_register(SCALE) OFF
   }
   if { ![info exists mom_sim_nc_register(MACRO_MODAL)] } {
      set mom_sim_nc_register(MACRO_MODAL) OFF
   }
   if { ![info exists mom_sim_nc_register(WCS_ROTATE)] } {
      set mom_sim_nc_register(WCS_ROTATE) OFF
   }
   if { ![info exists mom_sim_nc_register(CYCLE)] } {
      set mom_sim_nc_register(CYCLE) OFF
   }
   if { ![info exists mom_sim_nc_register(CYCLE_RETURN)] } {
      set mom_sim_nc_register(CYCLE_RETURN) INIT_LEVEL
   }
   if { ![info exists mom_sim_nc_register(RETURN_HOME)] } {
      set mom_sim_nc_register(RETURN_HOME) 0
   }
   if { ![info exists mom_sim_nc_register(FROM_HOME)] } {
      set mom_sim_nc_register(FROM_HOME) 0
   }
   if { ![info exists mom_sim_nc_register(MAIN_OFFSET)] } {
      set mom_sim_nc_register(MAIN_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]
   }
   if { ![info exists mom_sim_nc_register(LOCAL_OFFSET)] } {
      set mom_sim_nc_register(LOCAL_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]
   }
   if { ![info exists mom_sim_nc_register(WORK_OFFSET)] } {
      set mom_sim_nc_register(WORK_OFFSET) [PB_SIM_call VNC_map_to_machine_offsets\
                                                        $mom_sim_wcs_offsets($mom_sim_nc_register(WCS))]
   }

   if { ![info exists mom_sim_nc_register(SPINDLE_DIRECTION)] } {
      set mom_sim_nc_register(SPINDLE_DIRECTION) OFF
   }
   if { ![info exists mom_sim_nc_register(SPINDLE_MODE)] } {
      set mom_sim_nc_register(SPINDLE_MODE) REV_PER_MIN
   }
   if { ![info exists mom_sim_nc_register(S)] } {
      set mom_sim_nc_register(S) 0
   }
   if { ![info exists mom_sim_nc_register(FEED_MODE)] } {
      switch $mom_sim_nc_register(UNIT) {
         MM {
            set mom_sim_nc_register(FEED_MODE) MM_PER_MIN
         }
         default {
            set mom_sim_nc_register(FEED_MODE) INCH_PER_MIN
         }
      }
   }
   if { ![info exists mom_sim_nc_register(F)] } {
      set mom_sim_nc_register(F) 0
   }

   global mom_sim_rapid_dogleg
   if { ![info exists mom_sim_rapid_dogleg] } {
      set mom_sim_rapid_dogleg  0
   }


#>>>>>
  # Initialize subspindle activation state
  #
   if { ![info exists mom_sim_nc_register(CROSS_MACHINING)] } {
      set mom_sim_nc_register(CROSS_MACHINING) 0
   }

  # Initialize machine mode
  #
   global mom_sim_machine_type
   if { [string match "*wedm*" $mom_sim_machine_type] } {
      set mom_sim_nc_register(MACHINE_MODE) WEDM
   } elseif { [string match "*lathe*" $mom_sim_machine_type] } {
      set mom_sim_nc_register(MACHINE_MODE) TURN
   } else {
      set mom_sim_nc_register(MACHINE_MODE) MILL
   }

  # Initialize plane code
  #
   if { [string match "TURN" $mom_sim_nc_register(MACHINE_MODE)] } {
      set mom_sim_nc_register(PLANE) ZX
   } else {
      set mom_sim_nc_register(PLANE) XY
   }

  # Initialize CSYS state
  #
   global mom_sim_csys_set
   if { ![info exists mom_sim_csys_set] } {
      set mom_sim_csys_set  0
   }

  # Initialize tool offsets
  #
   global mom_sim_tool_offset_used mom_sim_tool_offset
   if { ![info exists mom_sim_tool_offset_used] } {
      set mom_sim_tool_offset_used 0
   }

   if { ![info exists mom_sim_tool_offset] } {
      set mom_sim_tool_offset(0) 0.0
      set mom_sim_tool_offset(1) 0.0
      set mom_sim_tool_offset(2) 0.0
   }

   global mom_sim_pivot_distance
   if { ![info exists mom_sim_pivot_distance] } {
      set mom_sim_pivot_distance 0.0
   }

  # Set default N/C output unit.  This value will be used
  # when no output unit function is specified in the N/C code.
  # It's also used as the intial mode when controller is reset.
  #
   set mom_sim_nc_register(DEF_UNIT)       $mom_sim_nc_register(UNIT)

  #-----------------------------------
  # Set the machine tool driver units.
  #-----------------------------------
   if { [string match "MM" $mom_sim_nc_register(UNIT)] } {
      PB_SIM_call SIM_set_mtd_units "MM"
   } else {
      PB_SIM_call SIM_set_mtd_units "INCH"
   }

  #--------------------------------
  # Set rotary axis direction mode.
  #--------------------------------
   global mom_sim_4th_axis_direction mom_sim_5th_axis_direction
   global mom_sim_4th_axis_max_limit mom_sim_5th_axis_max_limit
   global mom_sim_4th_axis_min_limit mom_sim_5th_axis_min_limit
   global mom_sim_4th_axis_has_limits mom_sim_5th_axis_has_limits

   if { [info exists mom_sim_lg_axis(4)] } {
      if { ![string match " " $mom_sim_4th_axis_direction] } {
         if { [string match "MAGNITUDE_DETERMINES_DIRECTION" $mom_sim_4th_axis_direction] } {

           # pb751(a) - Added "mom_sim_5th_axis_has_limits" condition
            if { [EQ_is_zero $mom_sim_4th_axis_min_limit] &&\
                 [EQ_is_equal $mom_sim_4th_axis_max_limit 360.0] &&\
                !$mom_sim_4th_axis_has_limits } {

               set mom_sim_4th_axis_direction "ALWAYS_SHORTEST"
            }
         }
         PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(4) $mom_sim_4th_axis_direction
      }
   }

   if { [info exists mom_sim_lg_axis(5)] } {
      if { ![string match " " $mom_sim_5th_axis_direction] } {
         if { [string match "MAGNITUDE_DETERMINES_DIRECTION" $mom_sim_5th_axis_direction] } {

           # pb751(a) - Added "mom_sim_5th_axis_has_limits" condition
            if { [EQ_is_zero $mom_sim_5th_axis_min_limit] &&\
                 [EQ_is_equal $mom_sim_5th_axis_max_limit 360.0] &&\
                !$mom_sim_5th_axis_has_limits } {

               set mom_sim_5th_axis_direction "ALWAYS_SHORTEST"
            }
         }
         PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(5) $mom_sim_5th_axis_direction
      }
   }


  #--------------------------------------------------------
  # Define max feed rate for each axis, if not yet defined.
  #--------------------------------------------------------
   global mom_sim_rapid_feed_rate
   global mom_sim_rapid_feed mom_sim_rapid_unit
   global mom_sim_spindle_max_rpm


   if { ![info exists mom_sim_rapid_feed(X)] } {
      set mom_sim_rapid_feed(X) $mom_sim_rapid_feed_rate
   }
   if { ![info exists mom_sim_rapid_feed(Y)] } {
      set mom_sim_rapid_feed(Y) $mom_sim_rapid_feed_rate
   }
   if { ![info exists mom_sim_rapid_feed(Z)] } {
      set mom_sim_rapid_feed(Z) $mom_sim_rapid_feed_rate
   }
   if { ![info exists mom_sim_rapid_feed(4)] } {
      set mom_sim_rapid_feed(4) $mom_sim_rapid_feed_rate
   }
   if { ![info exists mom_sim_rapid_feed(5)] } {
      set mom_sim_rapid_feed(5) $mom_sim_rapid_feed_rate
   }

   if { ![info exists mom_sim_rapid_unit(X)] } {
      set mom_sim_rapid_unit(X) $mom_sim_nc_register(FEED_MODE)
   }
   if { ![info exists mom_sim_rapid_unit(Y)] } {
      set mom_sim_rapid_unit(Y) $mom_sim_nc_register(FEED_MODE)
   }
   if { ![info exists mom_sim_rapid_unit(Z)] } {
      set mom_sim_rapid_unit(Z) $mom_sim_nc_register(FEED_MODE)
   }
   if { ![info exists mom_sim_rapid_unit(4)] } {
      set mom_sim_rapid_unit(4) REV_PER_MIN
   }
   if { ![info exists mom_sim_rapid_unit(5)] } {
      set mom_sim_rapid_unit(5) REV_PER_MIN
   }


  # Default max rpm
   global mom_sim_default_spindle_max_rpm
   if { ![info exists mom_sim_default_spindle_max_rpm] } {
      set mom_sim_default_spindle_max_rpm 10000
   }

   if { ![info exists mom_sim_spindle_max_rpm] || ![EQ_is_gt $mom_sim_spindle_max_rpm 0.0] } {
      set mom_sim_spindle_max_rpm $mom_sim_default_spindle_max_rpm
   }


  #------------------------------------------------
  # Initialize parameters required by Sync Manager
  # for the components involved in this driver.
  #
   global mom_multi_channel_mode

   if { [info exists mom_multi_channel_mode] } {


      global mom_sim_delay_one_block
      set mom_sim_delay_one_block 0


     # In case sync manager is not yet initialized...
      global mom_sim_sync_manager_initialized
      if { ![info exists mom_sim_sync_manager_initialized] } {
         PB_SIM_call PB_CMD_vnc__start_of_program
      }


      global mom_sim_result mom_sim_result1
      PB_SIM_call SIM_ask_nc_axes_of_mtool

      set axes_list {X Y Z 4 5}
      foreach axis $axes_list {
         if { [info exists mom_sim_mt_axis($axis)] } {
            if { [lsearch $mom_sim_result1 $mom_sim_mt_axis($axis)] >= 0 } {
               PB_SIM_call SIM_mach_max_axis_rapid_velocity $mom_sim_mt_axis($axis) $mom_sim_rapid_feed($axis) $mom_sim_rapid_unit($axis)
            }
         }
      }
   }


  #-------------------------------------------------------------------------------
  # Initialize reference CSYS w.r.t the MTCS junction with the machine model.
  # - This also establishes the machine datum csys.
  # - This matrix is also used to define the 1st version of the main & local csys.
  #
   if { $mom_sim_csys_set == 0 } {

     # Fix legacy offsets (5 elements -> 6 elements)
     # set n_wcs [array size mom_sim_wcs_offsets]
      set n_wcs [array names mom_sim_wcs_offsets]

      foreach i $n_wcs {
         if { [llength $mom_sim_wcs_offsets($i)] == 5 } {
            set mom_sim_wcs_offsets($i) [PB_SIM_call VNC_map_from_machine_offsets $mom_sim_wcs_offsets($i)]
         }
      }


     # Offsets between MTCS and the main WCS
      global mom_sim_machine_zero_offsets
      if { ![info exists mom_sim_machine_zero_offsets] } {
         set mom_sim_machine_zero_offsets  [list 0.0 0.0 0.0]
      }


     # Define all Work Coordinate Systems
     #
      PB_SIM_call PB_CMD_vnc__define_wcs
   }


  # Initialize cut data type
   global mom_sim_cut_data_type
   if { ![info exists mom_sim_cut_data_type] } {
      set mom_sim_cut_data_type "CENTERLINE"
   }


  # Reset this var for each vnc
   VNC_unset_vars mom_sim_nc_register(TOOL_CHANGED)


  # Translate pivot jct to the plane of spindle axis
  # - We only need to do this for machines with rotary head.
  #
   global mom_sim_machine_type mom_sim_mt_axis
   global mom_sim_spindle_jct mom_sim_pivot_jct

   if { ![info exists mom_sim_pivot_jct] || [string match "" $mom_sim_pivot_jct] } {
return
   }


  # Turning tools can also be mounted into B-head.
  # pb603(a) -
   if { ![string match "*wedm*" $mom_sim_machine_type] } {

      if { [info exists mom_sim_mt_axis(4)] } {

         SIM_ask_axis_dof_junction $mom_sim_mt_axis(4)

         set axis_dof [expr abs($mom_sim_result1)]

         SIM_ask_init_junction_xform $mom_sim_pivot_jct

         set i 0
         foreach v $mom_sim_result {
            set pivot_jct_matrix($i) $v
            incr i
         }
         foreach v $mom_sim_result1 {
            set pivot_jct_matrix($i) $v
            incr i
         }

         set spindle_org [SIM_transform_point {0.0 0.0 0.0} $mom_sim_spindle_jct $mom_sim_pivot_jct]

         set x 0.0
         set y 0.0
         set z 0.0
         switch $axis_dof {
            1 {
               set x [lindex $spindle_org 0]
            }
            2 {
               set y [lindex $spindle_org 1]
            }
            default {
               set z [lindex $spindle_org 2]
            }
         }

         MTX3_xform_csys 0 0 0 $x $y $z pivot_jct_matrix

         set idx [string first "@" $mom_sim_pivot_jct]
         if { $idx >= 0 } {
            set pivot_comp [string range $mom_sim_pivot_jct 0 [expr $idx - 1]]
         } else {
            set pivot_comp $mom_sim_spindle_comp
         }

         set jct_origin [list]
         for { set i 9 } { $i < 12 } { incr i } {
            lappend jct_origin $pivot_jct_matrix($i)
         }

         set jct_matrix [list]
         for { set i 0 } { $i < 9 } { incr i } {
            lappend jct_matrix $pivot_jct_matrix($i)
         }

        # Redefine a pivot jct just for tracking NC codes
         set mom_sim_pivot_jct __SIM_PIVOT_JCT

         PB_SIM_call SIM_ask_is_junction_exist __SIM_PIVOT_JCT

         if { $mom_sim_result == 1 } {
            PB_SIM_call SIM_delete_junction $mom_sim_pivot_jct
         }

         eval PB_SIM_call SIM_create_junction $mom_sim_pivot_jct $pivot_comp $jct_origin $jct_matrix
      }
   } ;# Translate pivot
}


#=============================================================
proc PB_CMD_vnc__inspect_nc_func { } {
#=============================================================
  global mom_sim_nc_func

  # Validate if NC functions defined with a null or leading numeral.
   if [info exists var_arr] { unset var_arr }
   foreach {func val} [array get mom_sim_nc_func] {
      if { [string length [string trim $val]] == 0  ||  [scan $val %d dvar] == 1 } {
         set var_arr($func) "\"$val\""
      }
   }
   if [info exists var_arr] {
      set msg ""
      foreach var [array names var_arr] {
         set msg $msg\n$var\t\t\t$var_arr($var)
      }
      VNC_pause "Follwing NC function(s) may need to be corrected\nto avoid problem in simulation:\n$msg"
   }
}


#=============================================================
proc PB_CMD_vnc__linear_move { } {
#=============================================================
  global mom_sim_lg_axis mom_sim_pos
  global mom_sim_nc_register
  global mom_sim_num_machine_axes


   switch $mom_sim_num_machine_axes {
      4 {
         PB_SIM_call VNC_move_linear_zcs CUT  $mom_sim_lg_axis(X) $mom_sim_pos(0)  $mom_sim_lg_axis(Y) $mom_sim_pos(1)  $mom_sim_lg_axis(Z) $mom_sim_pos(2)  $mom_sim_lg_axis(4) $mom_sim_pos(3)
      }

      5 {
         PB_SIM_call VNC_move_linear_zcs CUT  $mom_sim_lg_axis(X) $mom_sim_pos(0)  $mom_sim_lg_axis(Y) $mom_sim_pos(1)  $mom_sim_lg_axis(Z) $mom_sim_pos(2)  $mom_sim_lg_axis(4) $mom_sim_pos(3)  $mom_sim_lg_axis(5) $mom_sim_pos(4)
      }
      default {
         PB_SIM_call VNC_move_linear_zcs CUT  $mom_sim_lg_axis(X) $mom_sim_pos(0)  $mom_sim_lg_axis(Y) $mom_sim_pos(1)  $mom_sim_lg_axis(Z) $mom_sim_pos(2)
      }
   }

   set mom_sim_nc_register(LAST_X) $mom_sim_pos(0)
   set mom_sim_nc_register(LAST_Y) $mom_sim_pos(1)
   set mom_sim_nc_register(LAST_Z) $mom_sim_pos(2)
}


#=============================================================
proc PB_CMD_vnc__linearize_polar_motion { } {
#=============================================================
# This function alters motion's sim positions for polar simulation.
# Polar mode should have been initiated when certain N/C code
# has been encounterred.
#
   global mom_sim_polar_mode

   if { [info exists mom_sim_polar_mode] && $mom_sim_polar_mode == 2 } {

     # pb602(f) - Added use of "mx"
      global mom_sim_num_machine_axes
      set mx [expr $mom_sim_num_machine_axes - 1]

      global mom_sim_pos
      global mom_sim_current_x mom_sim_current_c
      global mom_sim_PI

     # Preserve current X & C values
      set mom_sim_current_x $mom_sim_pos(0)
      set mom_sim_current_c $mom_sim_pos($mx)

     # Compute target X pos (rise)
      set mom_sim_pos(0) [expr sqrt($mom_sim_pos(0)*$mom_sim_pos(0) + $mom_sim_pos($mx)*$mom_sim_pos($mx))]

     # Compute target angle
      global RAD2DEG
     ## set theta [expr atan2($mom_sim_pos(4),$mom_sim_current_x)]
      set theta [expr atan2($mom_sim_current_c,$mom_sim_current_x)]
      set mom_sim_pos($mx) [expr $theta * $RAD2DEG]


     # Use vector products to determine rotation sense
     if 1 {
      global mom_sim_prev_polar_c

      if { [info exists mom_sim_prev_polar_c] } {

         set Tu $mom_sim_prev_polar_c
         set Tv $mom_sim_pos($mx)

         set Ui [cosD $Tu]
         set Uj [sinD $Tu]
         set Vi [cosD $Tv]
         set Vj [sinD $Tv]

        # Validate value
         if { [expr [expr $Ui*$Vi + $Uj*$Vj] > 1.0] } {
            set ang 0.0
         } elseif { [expr [expr $Ui*$Vi + $Uj*$Vj] < -1.0] } {
            set ang 180.0
         } else {
            set ang [expr $RAD2DEG * acos($Ui*$Vi + $Uj*$Vj)]
         }

         set sen [expr $Ui*$Vj - $Uj*$Vi]
         if { [expr $sen < 0] } {
            set sen -1
         } else {
            set sen 1
         }

         set mom_sim_pos($mx) [expr $Tu + $sen * $ang]
      }

      set mom_sim_prev_polar_c $mom_sim_pos($mx)

     } else {

     # Adjust target angle per previous condition
      global mom_sim_prev_polar_c
      if { [info exists mom_sim_prev_polar_c] } {
         if { [expr $mom_sim_prev_polar_c > 0.0] } {
            if { ![expr $mom_sim_prev_polar_c < 180.0] && ![expr $mom_sim_pos($mx) > 0.0] } {
               set mom_sim_pos($mx) [expr $mom_sim_pos($mx) + 360]
            }
         } else {
           # Handle reversed condition
            if { [expr $mom_sim_pos(4) > 0.0] } {
               set mom_sim_pos($mx) [expr $mom_sim_pos($mx) - 360]
            }
         }
      }

      set mom_sim_prev_polar_c $mom_sim_pos($mx)
     }
   }
}


#=============================================================
proc PB_CMD_vnc__nurbs_move { } {
#=============================================================
   global mom_sim_nurbs_order
   global mom_sim_nurbs_knot_count
   global mom_sim_nurbs_knots
   global mom_sim_nurbs_point_count
   global mom_sim_nurbs_points

   PB_SIM_call SIM_move_nurbs_zcs $mom_sim_nurbs_point_count $mom_sim_nurbs_order  $mom_sim_nurbs_knot_count $mom_sim_nurbs_knots $mom_sim_nurbs_points
}


#=============================================================
proc PB_CMD_vnc__offset_tool_jct { } {
#=============================================================
# Offsets supplied in Tool Junction coordinate
#
  global mom_sim_tool_x_offset mom_sim_tool_y_offset mom_sim_tool_z_offset

  global mom_sim_current_junction
  global mom_sim_tool_junction
  global mom_sim_curr_jct_matrix mom_sim_curr_jct_origin
  global mom_sim_result mom_sim_result1


  # - Create ACS junction
   PB_SIM_call SIM_ask_is_junction_exist __SIM_ACS_JCT

   if { $mom_sim_result == 0 } {
      set machine_base MACHINE_BASE
      PB_SIM_call SIM_ask_machine_base_component
      if { ![string match "" $mom_sim_result] } {
         set machine_base $mom_sim_result
      }
      eval SIM_create_junction __SIM_ACS_JCT $machine_base [list 0 0 0] [list 1 0 0 0 1 0 0 0 1]
   }


   if { ![EQ_is_zero [expr (abs($mom_sim_tool_x_offset) + abs($mom_sim_tool_y_offset) + abs($mom_sim_tool_z_offset))] ] } {


global mom_sim_message
set mom_sim_message "**TOOL JCT OFFSET: before $mom_sim_tool_x_offset $mom_sim_tool_y_offset $mom_sim_tool_z_offset"
PB_CMD_vnc__send_message

     # pb602(g) - Comment out following due to changes in tool_change
     if 0 {
      PB_SIM_call SIM_ask_init_junction_xform $mom_sim_tool_junction
      set mom_sim_curr_jct_matrix "$mom_sim_result"
      set mom_sim_curr_jct_origin "$mom_sim_result1"
     }

     # - Xform offset
      set xval $mom_sim_tool_x_offset
      set yval $mom_sim_tool_y_offset
      set zval $mom_sim_tool_z_offset
      set vec [list $xval $yval $zval]
      set toff [SIM_transform_vector $vec $mom_sim_tool_junction __SIM_ACS_JCT]
      set xval [lindex $toff 0]
      set yval [lindex $toff 1]
      set zval [lindex $toff 2]

global mom_sim_message
set mom_sim_message "**TOOL JCT OFFSET: after  $xval $yval $zval"
PB_CMD_vnc__send_message


      set xval [expr [lindex $mom_sim_curr_jct_origin 0] - $xval]
      set yval [expr [lindex $mom_sim_curr_jct_origin 1] - $yval]
      set zval [expr [lindex $mom_sim_curr_jct_origin 2] - $zval]

      set mom_sim_curr_jct_origin [list $xval $yval $zval]

      set mom_sim_tool_junction ""

      PB_SIM_call VNC_create_tmp_jct

      set mom_sim_tool_junction "$mom_sim_current_junction"
   }
}


#=============================================================
proc PB_CMD_vnc__output_debug_msg { } {
#=============================================================
  global mom_sim_message

   VNC_output_debug_msg $mom_sim_message
}


#=============================================================
proc PB_CMD_vnc__output_param_msg { } {
#=============================================================
  global mom_sim_message
  global mom_sim_output_vnc_msg

   if { ![info exists mom_sim_output_vnc_msg] } {
      set mom_sim_output_vnc_msg 0
   }

  # Direct VNC msg to the NC setup data file
   global mom_sim_output_extended_nc
   global ptp_file_name
   if { [info exists mom_sim_output_extended_nc] && $mom_sim_output_extended_nc } {
      set setup_data_file [file rootname [file tail $ptp_file_name]]_setup.dat

      MOM_close_output_file  $ptp_file_name
      MOM_open_output_file   $setup_data_file

      set saved_output_vnc_msg $mom_sim_output_vnc_msg
      set mom_sim_output_vnc_msg 0
   }


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Use MOM_output_literal to display operator messages in NC window
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   if $mom_sim_output_vnc_msg {
      MOM_output_literal $mom_sim_message
   } else {
      MOM_output_text $mom_sim_message
   }


   if { [info exists mom_sim_output_extended_nc] && $mom_sim_output_extended_nc } {
      MOM_close_output_file $setup_data_file
      MOM_open_output_file  $ptp_file_name

      set mom_sim_output_vnc_msg $saved_output_vnc_msg
   }
}


#=============================================================
proc PB_CMD_vnc__output_vnc_msg { } {
#=============================================================
  global mom_sim_message
  global mom_sim_control_out mom_sim_vnc_msg_prefix mom_sim_control_in

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix $mom_sim_message $mom_sim_control_in"

   PB_SIM_call PB_CMD_vnc__output_param_msg
}


#=============================================================
proc PB_CMD_vnc__pass_contact_contour_data { } {
#=============================================================
  global mom_sim_message
  global mom_cut_data_type mom_tracking_point_type
  global mom_tracking_point_diameter mom_tracking_point_distance


   if { [info exists mom_cut_data_type] && [string match "contact contour" $mom_cut_data_type] } {
      set mom_sim_message "CUT_DATA_TYPE==CONTACT_CONTOUR"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg

      if { $mom_tracking_point_type == 1 } {
         set mom_sim_message "CONTACT_TRACKING_TYPE==POINT"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg

         set mom_sim_message "CONTACT_TRACKING_DIAMETER==$mom_tracking_point_diameter"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg

         set mom_sim_message "CONTACT_TRACKING_DISTANCE==$mom_tracking_point_distance"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg

      } else {
         set mom_sim_message "CONTACT_TRACKING_TYPE==BOTTOM"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg
      }
   } else {
      set mom_sim_message "CUT_DATA_TYPE==CENTERLINE"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }
}


#=============================================================
proc PB_CMD_vnc__pass_csys_data { } {
#=============================================================
# This function is only executed in an in-process ISV
# to pass csys definitions.
#
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_csys_matrix

  global mom_coordinate_system_purpose
  global mom_special_output
  global mom_kin_coordinate_system_type
  global mom_machine_csys_matrix
  global mom_sim_message


   if { [info exists mom_machine_csys_matrix] } {

      global mom_main_mcs
      global mom_coordinate_system_purpose

      global mom_sim_main_mcs
      global mom_sim_machine_type


     # Grab main MCS
      MTX3_transpose mom_machine_csys_matrix mainMCS

       set mainMCS(9)  $mom_machine_csys_matrix(9)
       set mainMCS(10) $mom_machine_csys_matrix(10)
       set mainMCS(11) $mom_machine_csys_matrix(11)


#VNC_info "Main MCS : $mom_main_mcs"
#VNC_info "mainMCS 1 : [VNC_sort_array_vals mainMCS]"

     #==========================================================
     # CSYS Purpose  (mom_coordinate_system_purpose)
     # ------------
     #                      1 : Main
     #                      0 : Local
     #
     # Special Output  (mom_special_output)
     # --------------
     #                      0 : None
     #                      1 : Use Main MCS
     #                      2 : Fixture Offset
     #                      3 : CSYS Rotation
     #
     # Coordinate System Type  (mom_kin_coordinate_system_type)
     # ----------------------
     #          When CSYS Purpose = 1 (Main)
     #                      LOCAL
     #
     #          When CSYS Purpose = 0 (Local)
     #                      MAIN  : Special Output = 1
     #                      LOCAL : Special Output = 0, 2
     #                      CSYS  : Special Output = 3
     #==========================================================

      set coordinate_system_mode  $mom_kin_coordinate_system_type


#VNC_info "mainMCS 2      : [VNC_sort_array_vals mainMCS]"
#VNC_info "  machine csys : [VNC_sort_array_vals mom_machine_csys_matrix]"
#VNC_info "  csys matrix  : [VNC_sort_array_vals mom_csys_matrix]"
#VNC_info "CSYS Purpose : $mom_coordinate_system_purpose \nSpecial Output : $mom_special_output \nCoordinate System Type : $mom_kin_coordinate_system_type"
#VNC_info "Coordinate system mode : $coordinate_system_mode"


     # Extract offsets between a local and the mainMCS
     #
      if { [string compare $coordinate_system_mode "MAIN"] } {

         global mom_fixture_offset_value
         global mom_sim_nc_register mom_sim_wcs_offsets

        # Fetch fixture offset # specified with the CSYS object
         if { $mom_fixture_offset_value > 0 } {

            set mom_sim_nc_register(WCS) $mom_fixture_offset_value


           # Set linear offsets
            set mom_sim_wcs_offsets($mom_fixture_offset_value) [list $mom_csys_matrix(9) $mom_csys_matrix(10) $mom_csys_matrix(11) 0.0 0.0 0.0]

           # Find angular offsets per axis of rotation
            global mom_sim_machine_type
            global mom_sim_4th_axis_plane mom_sim_5th_axis_plane

            if { ![string match "*wedm"  $mom_sim_machine_type] && ![string match "*lathe" $mom_sim_machine_type] && ![string match "*punch" $mom_sim_machine_type] } {

               for { set i 0 } { $i < 9 } { incr i } {
                 set csys($i) $mom_csys_matrix($i)
               }

               set fourth_ang 0.0
               set fifth_ang  0.0

               set 4th_index 0
               set 5th_index 0

               if { [string match "4*" $mom_sim_machine_type] } {
                  switch $mom_sim_4th_axis_plane {
                     "XY" {
                        set fourth_ang [rad2deg [expr atan2($csys(1),$csys(0))]]
                        set 4th_index 5
                     }
                     "YZ" {
                        set fourth_ang [rad2deg [expr atan2(-1*$csys(7),$csys(8))]]
                        set 4th_index 3
                     }
                     "ZX" {
                        set fourth_ang [rad2deg [expr atan2($csys(6),$csys(8))]]
                        set 4th_index 4
                     }
                  }
                  if { [string match "*head*" $mom_sim_machine_type] } {
                     set fourth_ang [expr -1 * $fourth_ang]
                  }
               }

               if { [string match "5*" $mom_sim_machine_type] } {
                  switch $mom_sim_4th_axis_plane {
                     "XY" {
                        set 4th_index 5
                        switch $mom_sim_5th_axis_plane {
                           "YZ" {
                             # C/A
                              # Rotate Y' to XY plane for A
                               set fifth_ang  [rad2deg [expr atan2($csys(5),$csys(4))]]
                               set d [expr sqrt( $csys(5)*$csys(5) + $csys(4)*$csys(4) )]

                              # Rotate Y' to Y on XY plane for C
                               set fourth_ang  [rad2deg [expr -1*atan2($csys(3),$d)]]

                               set 5th_index 3
                           }
                           "ZX" {
                             # C/B
                              # Rotate X' to XY plane for B
                               set fifth_ang  [rad2deg [expr -1*atan2($csys(2),$csys(0))]]
                               set d [expr sqrt( $csys(2)*$csys(2) + $csys(0)*$csys(0) )]

                              # Rotate X' to X on ZX plane for C
                               set fourth_ang  [rad2deg [expr atan2($csys(1),$d)]]

                               set 5th_index 4
                           }
                        }
                     }
                     "YZ" {
                        set 4th_index 3
                        switch $mom_sim_5th_axis_plane {
                           "XY" {
                             # A/C
                              # Rotate Z' to YZ plane for C (measured on XY plane)
                               set fifth_ang [rad2deg [expr -1*atan2($csys(6),$csys(7))]]
                               set d [expr sqrt( $csys(7)*$csys(7) + $csys(6)*$csys(6) )]

                              # Rotate Z' to Z on ZX plane for A
                               set fourth_ang [rad2deg [expr -1*atan2($d,$csys(8))]]

                               set 5th_index 5
                           }
                           "ZX" {
                             # A/B
                              # Rotate Z' to YZ plane for B (measured on XZ plane)
                               set fifth_ang  [rad2deg [expr atan2($csys(6),$csys(8))]]
                               set d [expr sqrt( $csys(6)*$csys(6) + $csys(8)*$csys(8) )]

                              # Rotate Z' to Z on ZX plane for B
                               set fourth_ang [rad2deg [expr -1*atan2($csys(7),$d)]]

                               set 5th_index 4
                           }
                        }
                     }
                     "ZX" {
                        set 4th_index 4
                        switch $mom_sim_5th_axis_plane {
                           "XY" {
                             # B/C
                              # Rotate Z' to ZX plane for C (measured on XY plane)
                               set fifth_ang [rad2deg [expr atan2($csys(7),$csys(6))]]

                              # Rotate Z' to Z on YZ plane for B
                               set d [expr sqrt( $csys(7)*$csys(7) + $csys(6)*$csys(6) )]
                               set fourth_ang [rad2deg [expr atan2($d,$csys(8))]]

                               set 5th_index 5
                           }
                           "YZ" {
                             # B/A
                              # Rotate Z' to ZX plane for A (measured on YZ plane)
                               set fifth_ang  [rad2deg [expr -1*atan2($csys(7),$csys(8))]]
                               set d [expr sqrt( $csys(7)*$csys(7) + $csys(8)*$csys(8) )]

                              # Rotate Z' to Z on YZ plane for B
                               set fourth_ang [rad2deg [expr atan2($csys(6),$d)]]

                               set 5th_index 3
                           }
                        }
                     }
                  }

                 # Negate angles for heads
                  if { [string match "*dual_head*" $mom_sim_machine_type] } {
                     set fourth_ang [expr -1 * $fourth_ang]
                     set fifth_ang  [expr -1 * $fifth_ang]
                  }
                  if { [string match "*head_table*" $mom_sim_machine_type] } {
                     set fourth_ang [expr -1 * $fourth_ang]
                  }
               }

              # Update fixture offset with angular offsets
               if { $4th_index > 0 } {
                  set mom_sim_wcs_offsets($mom_fixture_offset_value) [lreplace $mom_sim_wcs_offsets($mom_fixture_offset_value) $4th_index $4th_index $fourth_ang]
               }
               if { $5th_index > 0 } {
                  set mom_sim_wcs_offsets($mom_fixture_offset_value) [lreplace $mom_sim_wcs_offsets($mom_fixture_offset_value) $5th_index $5th_index $fifth_ang]
               }
            }


           # Rotate WCS offsets for MCSX lathe work plane
            if { [string match "*lathe" $mom_sim_machine_type] } {

               global mom_lathe_spindle_axis

               if { [info exists mom_lathe_spindle_axis] && [string match "MCSX" $mom_lathe_spindle_axis] } {

                  set x_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 1]
                  set y_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 2]
                  set z_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 0]
                  set a_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 3]
                  set b_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 4]
                  set c_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 5]

                  set mom_sim_wcs_offsets($mom_fixture_offset_value) [list $x_off $y_off $z_off $a_off $b_off $c_off]
               }
            }

         } ;# fixture_offset > 0

      } ;# LOCAL


      if { [string match "MAIN" $coordinate_system_mode] } {

        # Origin UDE specifies the offsets from a main MCS to the desired reference CSYS for output.
        # This UDE will not be known or involved in standalone NC files.
         global mom_origin

         for { set i 9 } { $i < 12 } { incr i } {
            if { [info exists mom_origin] } {
               set mainMCS($i) [expr $mainMCS($i) + $mom_origin([expr $i - 9])]
            }
         }

      } else {

         MTX3_multiply mainMCS mom_csys_matrix matrix

         set u(0) $mom_csys_matrix(9)
         set u(1) $mom_csys_matrix(10)
         set u(2) $mom_csys_matrix(11)

         MTX3_vec_multiply u mom_machine_csys_matrix w

         set matrix(9)  [expr $mainMCS(9)  + $w(0)]
         set matrix(10) [expr $mainMCS(10) + $w(1)]
         set matrix(11) [expr $mainMCS(11) + $w(2)]


        # To be passed as VNC param msgs
         array set local_mainMCS [array get mainMCS]
         array set mainMCS [array get matrix]
      }


     # Rotate main CSYS matrix for lathe MCSX work plane
      if { [string match "*lathe" $mom_sim_machine_type] } {

         global mom_lathe_spindle_axis

         if { [info exists mom_lathe_spindle_axis] && [string match "MCSX" $mom_lathe_spindle_axis] } {
            MTX3_x mainMCS x
            MTX3_y mainMCS y
            MTX3_z mainMCS z

            set mainMCS(0) $y(0)
            set mainMCS(1) $y(1)
            set mainMCS(2) $y(2)

            set mainMCS(3) $z(0)
            set mainMCS(4) $z(1)
            set mainMCS(5) $z(2)

            set mainMCS(6) $x(0)
            set mainMCS(7) $x(1)
            set mainMCS(8) $x(2)
         }
      }


     # Output WCS number
     #
      global mom_fixture_offset_value
      if { ![info exists mom_fixture_offset_value] } {
         set fixture_offset 0
      } else {
         set fixture_offset $mom_fixture_offset_value
      }
      set mom_sim_message "CSYS_FIXTURE_OFFSET==$fixture_offset"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg


#VNC_info "mainMCS passed : [VNC_sort_array_vals mainMCS]"
     #---------------------
     # Pass MCS definition
     #---------------------
      for { set i 0 } { $i < 12 } { incr i } {
         set mom_sim_message "CSYS_MTX_$i==$mainMCS($i)"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg
      }


     # Retain a copy of main, local & the currently active csys matrix
      global mom_sim_main_csys_matrix
      global mom_sim_local_csys_matrix
      global mom_sim_csys_matrix

      if { [string match "MAIN" $coordinate_system_mode] } {
         array set mom_sim_main_csys_matrix  [array get mainMCS]
      } else {
         array set mom_sim_main_csys_matrix  [array get local_mainMCS]
         array set mom_sim_local_csys_matrix [array get matrix]
      }

#VNC_info "Final coordinate system mode : $coordinate_system_mode"
#VNC_info "       csys : [VNC_sort_array_vals mom_sim_csys_matrix]"
#VNC_info " local csys : [VNC_sort_array_vals mom_sim_local_csys_matrix]"
#VNC_info " main  csys : [VNC_sort_array_vals mom_sim_main_csys_matrix]"
   }
}


#=============================================================
proc PB_CMD_vnc__pass_csys_data_old { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_csys_matrix

  global mom_coordinate_system_purpose
  global mom_special_output
  global mom_kin_coordinate_system_type
  global mom_machine_csys_matrix
  global mom_sim_message


   if [info exists mom_machine_csys_matrix] {

      global mom_main_mcs
      global mom_coordinate_system_purpose

     # CSYS purpose 1 : Main
     #              0 : Local
     #
      if { $mom_coordinate_system_purpose == 1 } {
         set coordinate_system_type  MAIN

        # Transpose main MCS
         MTX3_transpose mom_machine_csys_matrix mainMCS
         set mainMCS(9)  $mom_machine_csys_matrix(9)
         set mainMCS(10) $mom_machine_csys_matrix(10)
         set mainMCS(11) $mom_machine_csys_matrix(11)

      } else {
         set coordinate_system_type  $mom_kin_coordinate_system_type
         for { set i 0 } { $i < 12 } { incr i } {
            set mainMCS($i)  $mom_machine_csys_matrix($i)
         }
      }

     # A local MCS without main becomes a main MCS itself.
     # mom_machine_csys_matrix containing ACS matrix is redefined with the local MCS itself.
     #
      if {[string match "GEOMETRY" $mom_main_mcs] || [string match "NONE" $mom_main_mcs]} {
         for { set i 0 } { $i < 12 } { incr i } {

           # Grab local CSYS as main MCS
            set mainMCS($i)  $mom_csys_matrix($i)
         }
         set coordinate_system_type MAIN
      }

     # Extract offsets between a local and a main MCS
     #
      if ![string match "MAIN" $coordinate_system_type] {

         global mom_fixture_offset_value
         global mom_sim_nc_register mom_sim_wcs_offsets

        # Fetch fixture offset # specified with CSYS object
         set mom_sim_nc_register(WCS) $mom_fixture_offset_value

        # Set linear offsets
         set mom_sim_wcs_offsets($mom_fixture_offset_value)  [list $mom_csys_matrix(9) $mom_csys_matrix(10) $mom_csys_matrix(11) 0.0 0.0]

        # Find angular offsets per axis of rotation
         global mom_sim_machine_type
         global mom_sim_4th_axis_plane mom_sim_5th_axis_plane

         if { ![string match "*wedm" $mom_sim_machine_type] && ![string match "*lathe" $mom_sim_machine_type] && ![string match "*punch" $mom_sim_machine_type] } {

            for { set i 0 } { $i < 12 } { incr i } {
              set csys($i) $mom_csys_matrix($i)
            }

            set fourth_ang 0.0
            set fifth_ang  0.0

            if { [string match "4*" $mom_sim_machine_type] } {
               switch $mom_sim_4th_axis_plane {
                  "XY" {
                     set fourth_ang [rad2deg [expr atan2($csys(1),$csys(0))]]
                  }
                  "YZ" {
                     set fourth_ang [rad2deg [expr atan2(-1*$csys(7),$csys(8))]]
                  }
                  "ZX" {
                     set fourth_ang [rad2deg [expr atan2($csys(6),$csys(8))]]
                  }
               }
               if [string match "*head*" $mom_sim_machine_type] {
                  set fourth_ang [expr -1 * $fourth_ang]
               }
            }

            if { [string match "5*" $mom_sim_machine_type] } {
               switch $mom_sim_4th_axis_plane {
                  "XY" {
                     switch $mom_sim_5th_axis_plane {
                        "YZ" {
                          # C/A
                           # Rotate Y' to XY plane for A
                            set fifth_ang  [rad2deg [expr atan2($csys(5),$csys(4))]]
                            set d [expr sqrt( $csys(5)*$csys(5) + $csys(4)*$csys(4) )]

                           # Rotate Y' to Y on XY plane for C
                            set fourth_ang  [rad2deg [expr -1*atan2($csys(3),$d)]]
                        }
                        "ZX" {
                          # C/B
                           # Rotate X' to XY plane for B
                            set fifth_ang  [rad2deg [expr -1*atan2($csys(2),$csys(0))]]
                            set d [expr sqrt( $csys(2)*$csys(2) + $csys(0)*$csys(0) )]

                           # Rotate X' to X on ZX plane for C
                            set fourth_ang  [rad2deg [expr atan2($csys(1),$d)]]
                        }
                     }
                  }
                  "YZ" {
                     switch $mom_sim_5th_axis_plane {
                        "XY" {
                          # A/C
                           # Rotate Z' to YZ plane for C (measured on XY plane)
                            set fifth_ang [rad2deg [expr -1*atan2($csys(6),$csys(7))]]
                            set d [expr sqrt( $csys(7)*$csys(7) + $csys(6)*$csys(6) )]

                           # Rotate Z' to Z on ZX plane for A
                            set fourth_ang [rad2deg [expr -1*atan2($d,$csys(8))]]
                        }
                        "ZX" {
                          # A/B
                           # Rotate Z' to YZ plane for B (measured on XZ plane)
                            set fifth_ang  [rad2deg [expr atan2($csys(6),$csys(8))]]
                            set d [expr sqrt( $csys(6)*$csys(6) + $csys(8)*$csys(8) )]

                           # Rotate Z' to Z on ZX plane for B
                            set fourth_ang [rad2deg [expr -1*atan2($csys(7),$d)]]
                        }
                     }
                  }
                  "ZX" {
                     switch $mom_sim_5th_axis_plane {
                        "XY" {
                          # B/C
                           # Rotate Z' to ZX plane for C (measured on XY plane)
                            set fifth_ang [rad2deg [expr atan2($csys(7),$csys(6))]]

                           # Rotate Z' to Z on YZ plane for B
                            set d [expr sqrt( $csys(7)*$csys(7) + $csys(6)*$csys(6) )]
                            set fourth_ang [rad2deg [expr atan2($d,$csys(8))]]
                        }
                        "YZ" {
                          # B/A
                           # Rotate Z' to ZX plane for A (measured on YZ plane)
                            set fifth_ang  [rad2deg [expr -1*atan2($csys(7),$csys(8))]]
                            set d [expr sqrt( $csys(7)*$csys(7) + $csys(8)*$csys(8) )]

                           # Rotate Z' to Z on YZ plane for B
                            set fourth_ang [rad2deg [expr atan2($csys(6),$d)]]
                        }
                     }
                  }
               }

              # Negate angles for heads
               if [string match "*dual_head*" $mom_sim_machine_type] {
                  set fourth_ang [expr -1 * $fourth_ang]
                  set fifth_ang  [expr -1 * $fifth_ang]
               }
               if [string match "*head_table*" $mom_sim_machine_type] {
                  set fourth_ang [expr -1 * $fourth_ang]
               }
            }

           # Update fixture offset with angular offsets
            set mom_sim_wcs_offsets($mom_fixture_offset_value)  [lreplace $mom_sim_wcs_offsets($mom_fixture_offset_value) 3 4 $fourth_ang $fifth_ang]

         }

      } ;# LOCAL


      if [string match "MAIN" $coordinate_system_type] {

        # Origin UDE specifies the offsets from a main MCS to the desired CSYS for output.
        # This UDE will not be involved in standalone NC files.
         global mom_origin

         for { set i 9 } { $i < 12 } { incr i } {
            if [info exists mom_origin] {
               set mainMCS($i) [expr $mainMCS($i) + $mom_origin([expr $i - 9])]
            }
         }

      } else {

if ![info exists mainMCS] {
  VNC_pause "Ohla!"
}
         MTX3_multiply mainMCS mom_csys_matrix matrix

         set u(0) $mom_csys_matrix(9)
         set u(1) $mom_csys_matrix(10)
         set u(2) $mom_csys_matrix(11)
         MTX3_vec_multiply u mainMCS w

         set matrix(9)  [expr $mainMCS(9)  + $w(0)]
         set matrix(10) [expr $mainMCS(10) + $w(1)]
         set matrix(11) [expr $mainMCS(11) + $w(2)]
      }


     #---------------------------------------------------------------------------
     # Always simulate N/C codes w.r.t. the main MCS.
     # A local MCS will not be referenced until a G68 or G54 etc. is encountered.
     #---------------------------------------------------------------------------
      for { set i 0 } { $i < 12 } { incr i } {
         set mom_sim_message "CSYS_MTX_$i==$mainMCS($i)"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg
      }


     # Store away the local matrix to be used later.
      if ![string match "MAIN" $coordinate_system_type] {
         global mom_sim_csys_matrix
         for { set i 0 } { $i < 12 } { incr i } {
            set mom_sim_csys_matrix($i) $matrix($i)
         }
      }

     # Retain main & local CSYS
      global mom_sim_main_csys_matrix
      global mom_sim_local_csys_matrix
      for { set i 0 } { $i < 12 } { incr i } {
         set mom_sim_main_csys_matrix($i)  $mainMCS($i)
         set mom_sim_local_csys_matrix($i) $mom_sim_csys_matrix($i)
      }

   }
}


#=============================================================
proc PB_CMD_vnc__pass_head_data { } {
#=============================================================
  global mom_sys_postname
  global CURRENT_HEAD
  global mom_sim_message
  global mom_sys_sim_post_name


   set mom_sim_message "HEAD_NAME==$CURRENT_HEAD"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   global tcl_platform
   if [string match "*windows*" $tcl_platform(platform)] {
      regsub -all {\\} $mom_sys_sim_post_name {/} post_file
   } else {
      set post_file $mom_sys_sim_post_name
   }
   set mom_sim_message "POST_NAME==$post_file"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg
}


#=============================================================
proc PB_CMD_vnc__pass_helix_data { } {
#=============================================================
  global mom_sim_message
  global mom_sys_helix_pitch_type
  global mom_kin_helical_arc_output_mode

   if [info exists mom_sys_helix_pitch_type] {
      set type [string toupper $mom_sys_helix_pitch_type]
      set mom_sim_message "HELIX_PITCH_TYPE==$type"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }

   if [info exists mom_kin_helical_arc_output_mode] {
      set mode $mom_kin_helical_arc_output_mode
      set mom_sim_message "HELIX_OUTPUT_MODE==$mode"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }
}


#=============================================================
proc PB_CMD_vnc__pass_helix_pitch { } {
#=============================================================
  global mom_sim_message
  global mom_helix_pitch

   if [info exists mom_helix_pitch] {
      set mom_sim_message "HELIX_PITCH==$mom_helix_pitch"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }
}


#=============================================================
proc PB_CMD_vnc__pass_msys_data { } {
#=============================================================
  global mom_msys_matrix mom_msys_origin
  global mom_sim_message


   for { set i 0 } { $i < 9 } { incr i } {
      set mom_sim_message "CSYS_MTX_$i==$mom_msys_matrix($i)"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }

   for { set j 0 } { $j < 3 } { incr j } {
      set mom_sim_message "CSYS_MTX_$i==$mom_msys_origin($j)"
      incr i
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }
}


#=============================================================
proc PB_CMD_vnc__pass_nurbs_data { } {
#=============================================================
  global mom_kin_nurbs_output_type

   if [string match "BSPLINE" $mom_kin_nurbs_output_type] {

      global mom_sim_message

      global mom_nurbs_knot_count
      global mom_nurbs_knots
      global mom_nurbs_point_count
      global mom_nurbs_points
      global mom_nurbs_order

      set mom_sim_message "NURBS_ORDER==$mom_nurbs_order"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg

      set mom_sim_message "NURBS_KNOT_COUNT==$mom_nurbs_knot_count"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg

      for {set i 0} {$i < $mom_nurbs_knot_count} {incr i} {
         set mom_sim_message "NURBS_KNOTS($i)==$mom_nurbs_knots($i)"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg
      }

      set mom_sim_message "NURBS_POINT_COUNT==$mom_nurbs_point_count"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg

      for {set i 0} {$i < $mom_nurbs_point_count} {incr i} {
         set mom_sim_message "NURBS_POINTS($i,X)==$mom_nurbs_points($i,0)"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg
         set mom_sim_message "NURBS_POINTS($i,Y)==$mom_nurbs_points($i,1)"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg
         set mom_sim_message "NURBS_POINTS($i,Z)==$mom_nurbs_points($i,2)"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg
      }
   }
}


#=============================================================
proc PB_CMD_vnc__pass_nurbs_start { } {
#=============================================================
  global mom_kin_nurbs_output_type

   if [string match "BSPLINE" $mom_kin_nurbs_output_type] {

      global mom_sim_message

      set mom_sim_message "NURBS_START==1"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }
}


#=============================================================
proc PB_CMD_vnc__pass_spindle_data { } {
#=============================================================
  global mom_spindle_direction mom_spindle_mode
  global mom_spindle_speed mom_spindle_maximum_rpm
  global mom_sim_message


   set mom_sim_message "SPINDLE_DIRECTION==$mom_spindle_direction"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "SPINDLE_MODE==$mom_spindle_mode"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "SPINDLE_MAX_RPM==$mom_spindle_maximum_rpm"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "SPINDLE_SPEED==$mom_spindle_speed"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg
}


#=============================================================
proc PB_CMD_vnc__pass_tool_carrier_data { } {
#=============================================================
  global mom_sim_message
  global mom_carrier_name
  global mom_spindle_group

   if { [info exists mom_carrier_name] } {
      set mom_sim_message "TOOL_CARRIER_ID==$mom_carrier_name"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }

   if { [info exists mom_spindle_group] } {
      set mom_sim_message "SPINDLE_GROUP==$mom_spindle_group"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }
}


#=============================================================
proc PB_CMD_vnc__pass_tool_data { } {
#=============================================================
  global mom_tool_name
  global mom_tool_type
  global mom_tool_offset_defined mom_tool_offset
  global mom_sim_message


   if { ![info exists mom_tool_offset_defined] } {
      set mom_tool_offset_defined 0
   }
   if { ![info exists mom_tool_offset(0)] } { set mom_tool_offset(0) 0 }
   if { ![info exists mom_tool_offset(1)] } { set mom_tool_offset(1) 0 }
   if { ![info exists mom_tool_offset(2)] } { set mom_tool_offset(2) 0 }

   global mom_tool_number
   if { ![info exists mom_tool_number] } {
return
   }
   set mom_sim_message "TOOL_NUMBER==$mom_tool_number"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "TOOL_NAME==$mom_tool_name"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "TOOL_TYPE==$mom_tool_type"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "TOOL_OFFSET==$mom_tool_offset_defined"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "TOOL_X_OFF==$mom_tool_offset(0)"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "TOOL_Y_OFF==$mom_tool_offset(1)"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "TOOL_Z_OFF==$mom_tool_offset(2)"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg


   global mom_tool_diameter mom_tool_adjust_register mom_tool_cutcom_register

   if { [info exists mom_tool_diameter] } {
      set mom_sim_message "TOOL_DIAMETER==$mom_tool_diameter"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }
   if { [info exists mom_tool_cutcom_register] } {
      set mom_sim_message "TOOL_CUTCOM_REG==$mom_tool_cutcom_register"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }
   if { [info exists mom_tool_adjust_register] } {
      set mom_sim_message "TOOL_ADJUST_REG==$mom_tool_adjust_register"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }

   global mom_pocket_id
   if { [info exists mom_pocket_id] } {
      set mom_sim_message "TOOL_POCKET_ID==$mom_pocket_id"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }


  # pb601(g) -
  if 0 {
  # pb502(7) -
  # Fetch info from devices (tool blocks on turret)
   global mom_sim_result mom_sim_result1

   if { ![catch { SIM_ask_base_device_holder_of_comp $mom_tool_name }] } {
      set mom_sim_message "TOOL_POCKET_ID==$mom_sim_result1"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }

   if { ![catch { SIM_ask_base_device_of_comp $mom_tool_name }] } {
     # Only allow numeric carrier ID
      if [catch {expr $mom_sim_result1 - 1} ] {
return
      }

      set mom_sim_message "TOOL_CARRIER_ID==$mom_sim_result1"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg

      global mom_sim_spindle_group
      if [info exists mom_sim_spindle_group] {
         PB_SIM_call SIM_assign_channel_to_spindle $mom_sim_result1 $mom_sim_spindle_group
      }

      PB_SIM_call PB_CMD_vnc__set_speed
   }
  }
}


#=============================================================
proc PB_CMD_vnc__pause { } {
#=============================================================
# This command enables you to pause the UG/ISV processing.
#
  VNC_pause
}


#=============================================================
proc PB_CMD_vnc__preprocess_nc_block { } {
#=============================================================
#
# Command "VNC_parse_nc_block BUFFER word" can be used to
# identify if a token is contained in a block buffer.
#
#    Arguments -
#           BUFFER  : Reference (pointer) to the block buffer
#           word    : token (string) to be identified
#
#    Return -
#           0 : no match is found
#           1 : an exact match is found (no numerals traling the token)
#           2 : an extended match is found ( with trailing numerals)
#
# An extended match will be found if the given token is "X" while
# the block buffer contains "X1.234". The command returns 2.
#
# Any matched sub-string will be removed from the buffer.
#
#
# o_buff -
#    Normally, the variable "o_buff" is set to the resultant block buffer
#    and returned back to the calling command for subsequent process.
#    If no further process is needed for the block after a token is found,
#    "o_buff" is set to a NULL string then returned.
#
#

  global mom_sim_o_buffer

  global mom_sim_nc_register
  global mom_sim_pos mom_sim_prev_pos
  global mom_sim_nc_code
  global mom_sim_address



   set o_buff $mom_sim_o_buffer


  # Extract Q word
   if [string match "*Q*=*" $mom_sim_o_buffer] {
      set word_list [split $mom_sim_o_buffer "="]
      set Q_val [lindex $word_list 1]

     # Q_val will not be a pure numeral when it contains math formula,
     # which requires a more rigorous evaluation of the formula.
      if ![catch { expr $Q_val }] {
         if [VNC_parse_nc_block mom_sim_o_buffer "Q"] {
            set Q_var "Q$mom_sim_nc_code"
            set mom_sim_nc_register($Q_var) $Q_val
         }
      }
      set o_buff ""
   }


  # Restore ZCS
   if { [VNC_parse_nc_block mom_sim_o_buffer "M129"] == 1 } {
      global mom_sim_zcs_base
      global mom_sim_zcs_base_MCS

      set mom_sim_zcs_base $mom_sim_zcs_base_MCS
      PB_CMD_vnc__set_kinematics

      set o_buff $mom_sim_o_buffer
   }


  # CUTCOM code
   if { [VNC_parse_nc_block mom_sim_o_buffer "RL"] == 1 } {
      set mom_sim_nc_register(CUTCOM) LEFT
      set o_buff $mom_sim_o_buffer
   }
   if { [VNC_parse_nc_block mom_sim_o_buffer "RR"] == 1 } {
      set mom_sim_nc_register(CUTCOM) RIGHT
      set o_buff $mom_sim_o_buffer
   }
   if { [VNC_parse_nc_block mom_sim_o_buffer "R0"] == 1 } {
      set mom_sim_nc_register(CUTCOM) OFF
      set o_buff $mom_sim_o_buffer
   }


  # Datum shift (WCS)
  # -> X
   if { [VNC_parse_nc_block mom_sim_o_buffer "CYCL DEF* 7.1"] == 1 } {
      if { [VNC_parse_nc_block mom_sim_o_buffer $mom_sim_address(X,leader)] == 2 } {
         set val [string trim $mom_sim_nc_code +]
         set mom_sim_nc_register(WORK_OFFSET) [lreplace $mom_sim_nc_register(WORK_OFFSET) 0 0 $val]
      }
      set o_buff ""
   }

  # -> Y
   if { [VNC_parse_nc_block mom_sim_o_buffer "CYCL DEF* 7.2"] == 1 } {
      if { [VNC_parse_nc_block mom_sim_o_buffer $mom_sim_address(Y,leader)] == 2 } {
         set val [string trim $mom_sim_nc_code +]
         set mom_sim_nc_register(WORK_OFFSET) [lreplace $mom_sim_nc_register(WORK_OFFSET) 1 1 $val]
      }
      set o_buff ""
   }

  # -> Z
   if { [VNC_parse_nc_block mom_sim_o_buffer "CYCL DEF* 7.3"] == 1 } {
      if { [VNC_parse_nc_block mom_sim_o_buffer $mom_sim_address(Z,leader)] == 2 } {
         set val [string trim $mom_sim_nc_code +]
         set mom_sim_nc_register(WORK_OFFSET) [lreplace $mom_sim_nc_register(WORK_OFFSET) 2 2 $val]
      }
      set o_buff ""
   }


  # Retrieve a datum by number
   if [string match "*Q339*" $mom_sim_o_buffer] {
      global mom_sim_wcs_offsets

      set mom_sim_nc_register(WCS) $mom_sim_nc_register(Q339)
      set mom_sim_nc_register(WORK_OFFSET) [list]
      foreach coord $mom_sim_wcs_offsets($mom_sim_nc_register(WCS)) {
         lappend mom_sim_nc_register(WORK_OFFSET) $coord
      }
      set o_buff ""
   }


  # Tilted WCS
   if { [VNC_parse_nc_block mom_sim_o_buffer "CYCL DEF* 19.1"] == 1 } {

      set o_buff $mom_sim_o_buffer

      set 4th_val 0.0
      set 5th_val 0.0

      if { [VNC_parse_nc_block mom_sim_o_buffer $mom_sim_address(fourth_axis,leader)] == 2 } {
         set 4th_val [string trim $mom_sim_nc_code +]
      }
      if { [VNC_parse_nc_block mom_sim_o_buffer $mom_sim_address(fifth_axis,leader)] == 2 } {
         set 5th_val [string trim $mom_sim_nc_code +]
      }


      set mom_sim_nc_register(WORK_OFFSET) [list]
      lappend mom_sim_nc_register(WORK_OFFSET) 0.0 0.0 0.0 0.0 0.0


      global mom_sim_zcs_base
      global mom_sim_zcs_base_LCS
      global mom_sim_zcs_base_MCS

      if { [expr $4th_val != 0.0] && [expr $4th_val != 0.0] } {
         if { [info exists mom_sim_zcs_base_LCS] && ![string match "" [string trim $mom_sim_zcs_base_LCS]] }  {

           #<12-12-05 gsl> Restore local CSYS
            global mom_sim_csys_matrix
            global mom_sim_local_csys_matrix
            if [info exists mom_sim_local_csys_matrix] {
               for { set i 0 } { $i < 12 } { incr i } {
                  set mom_sim_csys_matrix($i)  $mom_sim_local_csys_matrix($i)
               }
            }

            set mom_sim_zcs_base $mom_sim_zcs_base_LCS
            PB_CMD_vnc__set_kinematics

            set o_buff ""
         }

      } else {

        # Restore main CSYS
         global mom_sim_csys_matrix
         global mom_sim_main_csys_matrix
         if [info exists mom_sim_main_csys_matrix] {
            for { set i 0 } { $i < 12 } { incr i } {
               set mom_sim_csys_matrix($i)  $mom_sim_main_csys_matrix($i)
            }
         }

         set mom_sim_zcs_base $mom_sim_zcs_base_MCS
         PB_CMD_vnc__set_kinematics
      }
   }


  # Drilling Cycle parameters
   if [string match "CYCL DEF* 2*" $mom_sim_o_buffer] {
      set mom_sim_nc_register(MOTION) "CYCLE_DEF"

     # Initialize some parameters
      if [info exists mom_sim_nc_register(Q200)] {
         unset mom_sim_nc_register(Q200)
      }
      if [info exists mom_sim_nc_register(Q201)] {
         unset mom_sim_nc_register(Q201)
      }
      if [info exists mom_sim_nc_register(Q203)] {
         unset mom_sim_nc_register(Q203)
      }
      if [info exists mom_sim_nc_register(Q204)] {
         unset mom_sim_nc_register(Q204)
      }
      set o_buff ""
   }

   if [string match "CYCLE_DEF" $mom_sim_nc_register(MOTION)] {

     # RapidTo clearance above hole
      if [VNC_parse_nc_block mom_sim_o_buffer "Q200="] {
         set mom_sim_nc_register(Q200) $mom_sim_nc_code
         set o_buff ""
      }
     # FeedTo bottom from top of hole
      if [VNC_parse_nc_block mom_sim_o_buffer "Q201="] {
         set mom_sim_nc_register(Q201) $mom_sim_nc_code
         set o_buff ""
      }
     # Top of hole
      if [VNC_parse_nc_block mom_sim_o_buffer "Q203="] {
         set mom_sim_nc_register(Q203) $mom_sim_nc_code
         set o_buff ""
      }
     # RetractTo clearance above hole
      if [VNC_parse_nc_block mom_sim_o_buffer "Q204="] {
         set mom_sim_nc_register(Q204) $mom_sim_nc_code
         set o_buff ""
      }
   }

   if [string match "CYCL CALL*" $mom_sim_o_buffer] {
      PB_CMD_vnc__cycle_move_hhc
      set o_buff ""
   }


  # Trim off anything after an ";" sign (comments)
   if [string match "*;*" $mom_sim_o_buffer] {
      set i_at [string first ";" $mom_sim_o_buffer]
      if { $i_at > -1 } {
         set o_buff [string trimright [string range $mom_sim_o_buffer 0 [expr $i_at - 1]]]
      }
   }


  # Misc blocks
   if [string match "BEGIN PGM*" $mom_sim_o_buffer] {
     # Extract output unit, then remove the block.
      set unit [lindex [split $mom_sim_o_buffer] end]

      global mom_sim_output_unit

      set mom_sim_output_unit $unit
      set mom_sim_nc_register(UNIT) $unit

      switch $mom_sim_nc_register(UNIT) {
         MM {
            SIM_set_mtd_units "MM"
         }
         default {
            SIM_set_mtd_units "INCH"
         }
      }
      set o_buff ""

   } elseif [string match "END PGM*" $mom_sim_o_buffer] {
      set o_buff ""

   } elseif [string match "BLK FORM*" $mom_sim_o_buffer] {
      set o_buff ""

   } elseif [string match "TOOL DEF*" $mom_sim_o_buffer] {
      set o_buff ""

   } elseif [string match "TOOL CALL*" $mom_sim_o_buffer] {
     # Tool Change
      global mom_sim_tool_change

      if { ![info exists mom_sim_tool_change] } {
         set mom_sim_tool_change 1
      }

      if $mom_sim_tool_change {
         VNC_tool_change
      }

     # Extract work plane
      set plane [lindex [split $mom_sim_o_buffer] 3]

      global mom_sim_cycle_spindle_axis

      if [string match "Z" $plane] {

         set mom_sim_nc_register(PLANE) XY
         set mom_sim_cycle_spindle_axis 2

      } elseif [string match "X" $plane] {

         set mom_sim_nc_register(PLANE) YZ
         set mom_sim_cycle_spindle_axis 0

      } elseif [string match "Y" $plane] {

         set mom_sim_nc_register(PLANE) ZX
         set mom_sim_cycle_spindle_axis 1
      }
      set o_buff ""
   }


  # Identify Rapid Move
   if { [VNC_parse_nc_block mom_sim_o_buffer "F MAX"] == 1 } {
      set mom_sim_nc_register(MOTION) "RAPID"
      set mom_sim_nc_register(F) 0.0
      set o_buff $mom_sim_o_buffer
   }
   if { [VNC_parse_nc_block mom_sim_o_buffer "FMAX"] == 1 } {
      set mom_sim_nc_register(MOTION) "RAPID"
      set mom_sim_nc_register(F) 0.0
      set o_buff $mom_sim_o_buffer
   }


  # Circle Center
   if { [VNC_parse_nc_block mom_sim_o_buffer "CC"] == 1 } {

      global mom_sim_circular_vector
      set mom_sim_circular_vector "Vector - Absolute Arc Center"

      set val [VNC_extract_address_val mom_sim_o_buffer X]
      if { [string compare "" $val] } {
         set mom_sim_pos(5) $val
      }
      set val [VNC_extract_address_val mom_sim_o_buffer Y]
      if { [string compare "" $val] } {
         set mom_sim_pos(6) $val
      }
      set val [VNC_extract_address_val mom_sim_o_buffer Z]
      if { [string compare "" $val] } {
         set mom_sim_pos(7) $val
      }

      set o_buff ""
   }

  # Circular move block
   if [string match "C*" $mom_sim_o_buffer] {

     # Remove Circular code
      VNC_parse_nc_block mom_sim_o_buffer "C"

     # Identify direction
      if { [VNC_parse_nc_block mom_sim_o_buffer "DR+"] == 1 } {
        # CCLW
         set mom_sim_nc_register(MOTION) "CIRCULAR_CCLW"

      } elseif { [VNC_parse_nc_block mom_sim_o_buffer "DR-"] == 1 } {
        # CLW
         set mom_sim_nc_register(MOTION) "CIRCULAR_CLW"
      }

     # Force out full circle move
      set mom_sim_o_buffer [string trim $mom_sim_o_buffer]
      set o_buff $mom_sim_o_buffer

      if { ![string compare "" $o_buff] } {
         global mom_sim_arc_output_mode
         if { [info exists mom_sim_arc_output_mode] && [string match "FULL_CIRCLE" $mom_sim_arc_output_mode] } {
            PB_CMD_vnc__sim_motion
         }
      }
   }


return $o_buff
}


#=============================================================
proc PB_CMD_vnc__rapid_move { } {
#=============================================================
  global mom_sim_rapid_feed_rate
  global mom_tool_axis
  global mom_sim_rapid_dogleg
  global mom_sim_pos mom_sim_prev_pos
  global mom_sim_max_dpm
  global mom_sim_lg_axis

   if { $mom_sim_rapid_dogleg } {

      if { [info exists mom_sim_lg_axis(5)] } {
         set num 5
      } elseif { [info exists mom_sim_lg_axis(4)] } {
         set num 4
      } else {
         set num 3
      }

      set rotary_end_first 1
      set rapid_feed_rate 0

      while { $rotary_end_first } {

         set t_list [list]

         for { set i 0 } { $i < $num } { incr i } {

            set mom_sim_save_pos($i) $mom_sim_pos($i)
            set tol [expr $mom_sim_pos($i) - $mom_sim_prev_pos($i)]

            if { [EQ_is_gt $tol 0.0] } {
               set fac($i) 1
            } elseif { [EQ_is_equal $tol 0.0] } {
               set fac($i) 0
            } else {
               set fac($i) -1
            }

           # Get rapid_speed for each axis
            if { $i< 3} {
              # Linear Axes
               if { $rapid_feed_rate != 0 } {
                  set rapid_speed $rapid_feed_rate
                  set rotary_end_first 0
               } else {
                  set rapid_speed $mom_sim_rapid_feed_rate
               }
            } else {
              # Rotary Axes
               if { [info exists mom_sim_max_dpm] } {
                  set rapid_speed $mom_sim_max_dpm
               } else {
                  set rapid_speed 0.0
               }
            }

           # Calculate time
            if {![EQ_is_equal $rapid_speed 0.0] } {
               set t($i) [expr abs($mom_sim_pos($i) - $mom_sim_prev_pos($i)) / $rapid_speed]
            } else {
               set t($i) 0.0
            }

            lappend t_list $t($i)
         }

        # Sort time required for each linear axis
         set t_list [lsort -real $t_list]
         set t_order [list]

        # Generate t_order
         for { set i 0 } { $i < [llength $t_list] } { incr i } {
            for { set j 0 } { $j < $num } { incr j } {
               if { $t($j) == [lindex $t_list $i] } {
                  if { [lsearch $t_order $j] >= 0 } {
                     continue
                  } else {
                     lappend t_order $j
                     break
                  }
               }
            }
         }

        # Make sure rotary axes reach the destination before X, Y, Z axes, or at the same time
         if { $rotary_end_first == 1 } {
            set m_num [lindex $t_order 2]
            if { [lindex $t_order [expr $num-1]] == 3 } {
               set rapid_feed_rate [expr abs($mom_sim_pos($m_num) - $mom_sim_prev_pos($m_num)) / $t(3)]
            } elseif { [lindex $t_order [expr $num-1]] == 4 } {
               set rapid_feed_rate [expr abs($mom_sim_pos($m_num) - $mom_sim_prev_pos($m_num)) / $t(4)]
            } else {
               set rotary_end_first 0
            }
         }
      }

      set act_list $t_order


     ######################
     # Rapid Move Segments
     ######################
      for { set j 0 } { $j < $num } { incr j } {
         set long_ind [lindex $t_order $j]
         set long_t $t($long_ind)

         if { $j == 0 } {
            set short_t 0.0
         } else {
            set short_ind [lindex $t_order [expr $j - 1]]
            set short_t $t($short_ind)
         }
         set t_gap($j) [expr $long_t - $short_t]

         for { set i 0 } { $i < $num } { incr i } {

            if { $i< 3 } {
              # Linear Axes
               if { $rapid_feed_rate != 0 } {
                  set rapid_speed $rapid_feed_rate
               } else {
                  set rapid_speed $mom_sim_rapid_feed_rate
               }
            } else {
              # Rotary Axes
               if { [info exists mom_sim_max_dpm] } {
                  set rapid_speed $mom_sim_max_dpm
               } else {
                  set rapid_speed 0.0
               }
            }

            if { [lsearch $act_list $i] >= 0 } {
               set mom_sim_pos($i) [expr $mom_sim_prev_pos($i) + $fac($i) * $rapid_speed * $t_gap($j)]
            } else {
               set mom_sim_pos($i) $mom_sim_prev_pos($i)
            }
         }

         set int      [lsearch $act_list $long_ind]
         set act_list [lreplace $act_list $int $int]

         PB_CMD_vnc__rapid_segment

         if { $j != [expr $num - 1] } {
            for { set q 0 } { $q < $num } { incr q } {
               set mom_sim_prev_pos($q) $mom_sim_pos($q)
            }
         }
      }

   } else {

      PB_CMD_vnc__rapid_segment
   }
}


#=============================================================
proc PB_CMD_vnc__rapid_segment { } {
#=============================================================
# This function is the old PB_CMD_vnc__rapid_move
#
  global mom_sim_lg_axis
  global mom_sim_nc_register
  global mom_sim_num_machine_axes

  global mom_sim_pos mom_sim_prev_pos


   set coord_list [list]
   set pattern 0

   if { [expr $mom_sim_pos(0) != $mom_sim_prev_pos(0)] } {
      lappend coord_list $mom_sim_lg_axis(X)  $mom_sim_pos(0)
      set pattern [expr $pattern + 10000]
   }
   if { [expr $mom_sim_pos(1) != $mom_sim_prev_pos(1)] } {
      lappend coord_list $mom_sim_lg_axis(Y)  $mom_sim_pos(1)
      set pattern [expr $pattern + 1000]
   }
   if { [expr $mom_sim_pos(2) != $mom_sim_prev_pos(2)] } {
      lappend coord_list $mom_sim_lg_axis(Z)  $mom_sim_pos(2)
      set pattern [expr $pattern + 100]
   }
   if { [info exists mom_sim_lg_axis(4)] } {
      if { [expr $mom_sim_pos(3) != $mom_sim_prev_pos(3)] } {
         lappend coord_list $mom_sim_lg_axis(4)  $mom_sim_pos(3)
      set pattern [expr $pattern + 10]
      }
   }
   if { [info exists mom_sim_lg_axis(5)] } {
      if { [expr $mom_sim_pos(4) != $mom_sim_prev_pos(4)] } {
         lappend coord_list $mom_sim_lg_axis(5)  $mom_sim_pos(4)
      set pattern [expr $pattern + 1]
      }
   }


   global mom_sim_mt_axis
   global mom_sim_max_dpm

   if { ![info exists mom_sim_max_dpm] || ![EQ_is_gt $mom_sim_max_dpm 0.0] } {
      set mom_sim_max_dpm 10000
   }

   switch $pattern {
      1 { ;# Pure 5th axis rotation -

         PB_SIM_call SIM_move_rotary_axis [expr $mom_sim_pos(4)/$mom_sim_max_dpm] $mom_sim_mt_axis(5) $mom_sim_pos(4)
         PB_SIM_call SIM_update
         PB_SIM_call VNC_update_sim_pos

         set pattern 0
      }

      10 { ;# Pure 4th axis rotation -

         PB_SIM_call SIM_move_rotary_axis [expr $mom_sim_pos(3)/$mom_sim_max_dpm] $mom_sim_mt_axis(4) $mom_sim_pos(3)
         PB_SIM_call SIM_update
         PB_SIM_call VNC_update_sim_pos

         set pattern 0
      }

      11 { ;# Pure compound rotation -

         PB_SIM_call SIM_move_rotary_axis [expr $mom_sim_pos(3)/$mom_sim_max_dpm] $mom_sim_mt_axis(4) $mom_sim_pos(3)
         PB_SIM_call SIM_move_rotary_axis [expr $mom_sim_pos(4)/$mom_sim_max_dpm] $mom_sim_mt_axis(5) $mom_sim_pos(4)
         PB_SIM_call SIM_update
         PB_SIM_call VNC_update_sim_pos

         set pattern 0
      }
   }


   if { [expr $pattern > 0] } {

     # Force rotary direction
      global mom_sim_5th_axis_has_limits
      if { [info exists mom_sim_lg_axis(5)] } {
         if { !$mom_sim_5th_axis_has_limits } {
            PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(5) "ALWAYS_SHORTEST"
         }
      }


      eval PB_SIM_call VNC_move_linear_zcs RAPID $coord_list


     # In case tool is not yet activated...
      global mom_sim_tool_loaded
      if { ![string match "" [string trim $mom_sim_tool_loaded]] } {
         PB_SIM_call SIM_activate_tool $mom_sim_tool_loaded
      }
      PB_SIM_call SIM_update


     # Force rotary direction
      if { [info exists mom_sim_lg_axis(5)] } {
         if { !$mom_sim_5th_axis_has_limits } {
            global mom_sim_5th_axis_direction
            if { ![string match "" [string trim $mom_sim_5th_axis_direction] ] } {
               PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(5) $mom_sim_5th_axis_direction

               global mom_sim_mt_axis
               global mom_sim_result
               PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(5) NORM_180
               PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(5)
               if { [EQ_is_zero $mom_sim_result] } {
                  set mom_sim_result 0.0
               }
               set mom_sim_pos(4) $mom_sim_result
               PB_SIM_call SIM_move_rotary_axis 5 $mom_sim_mt_axis(5) $mom_sim_pos(4)
            }
         }
      }
   }

   set mom_sim_nc_register(LAST_X) $mom_sim_pos(0)
   set mom_sim_nc_register(LAST_Y) $mom_sim_pos(1)
   set mom_sim_nc_register(LAST_Z) $mom_sim_pos(2)
}


#=============================================================
proc PB_CMD_vnc__reload_kinematics { } {
#=============================================================
  global mom_sim_mt_axis
  global sim_prev_zcs
  global mom_sim_num_machine_axes mom_sim_advanced_kinematic_jct


   set current_zcs "$mom_sim_advanced_kinematic_jct"


  # Set kinematics based on the machine tool kinematics model
  # current_zcs represents the MCS used with this machine

   if { [PB_SIM_call VNC_machine_tool_model_exists]  &&  [string compare $sim_prev_zcs $current_zcs] } {

      if { $mom_sim_num_machine_axes == 4 } {

         PB_SIM_call VNC_set_post_kinematics $current_zcs $mom_sim_mt_axis(X) $mom_sim_mt_axis(Y) $mom_sim_mt_axis(Z) $mom_sim_mt_axis(4)
      } elseif { $mom_sim_num_machine_axes == 5 } {

         PB_SIM_call VNC_set_post_kinematics $current_zcs $mom_sim_mt_axis(X) $mom_sim_mt_axis(Y) $mom_sim_mt_axis(Z) $mom_sim_mt_axis(4) $mom_sim_mt_axis(5)
      }

      set sim_prev_zcs $current_zcs
   }


#>>>>> Advanced kinematics
#   set uf_library "ugpadvkins.dll"
#   MOM_run_user_function [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]$uf_library ufusr


   MOM_reload_kinematics
}


#=============================================================
proc PB_CMD_vnc__reload_machine_tool_axes { } {
#=============================================================
  global mom_sim_num_machine_axes
  global mom_sim_mt_axis
  global mom_sim_result mom_sim_result1
  global mom_sim_zcs_base mom_sim_zcs_base_MCS
  global mom_sim_spindle_comp mom_sim_spindle_jct
  global mom_sim_pivot_jct


  #-------------------------------------
  # Fetch machine kinematics from model
  #-------------------------------------
   set mom_sim_mt_axis(X)     [PB_SIM_call SIM_ask_nc_axis_name X]
   set mom_sim_mt_axis(Y)     [PB_SIM_call SIM_ask_nc_axis_name Y]
   set mom_sim_mt_axis(Z)     [PB_SIM_call SIM_ask_nc_axis_name Z]

   switch $mom_sim_num_machine_axes {
      "4" {
         set mom_sim_mt_axis(4) [PB_SIM_call SIM_ask_nc_axis_name 4th]
      }
      "5" {
         set mom_sim_mt_axis(4) [PB_SIM_call SIM_ask_nc_axis_name 4th]
         set mom_sim_mt_axis(5) [PB_SIM_call SIM_ask_nc_axis_name 5th]
      }
   }

   set mom_sim_zcs_base_MCS   [PB_SIM_call SIM_ask_zcs_comp_name]
   set mom_sim_zcs_base       $mom_sim_zcs_base_MCS


   set spindle_jct            [PB_SIM_call SIM_ask_tool_mount_jnct_name]
   if [string match "" $spindle_jct] {
      set spindle_jct         [PB_SIM_call SIM_ask_tool_mount_jct_name]
   }
   if ![string match "" $spindle_jct] {
      set mom_sim_spindle_jct $spindle_jct
   }

   set mom_sim_spindle_comp   [PB_SIM_call SIM_ask_tool_mount_comp_name]

   set pivot_jct              [PB_SIM_call SIM_ask_head_pivot_jct_full_name]
   if ![string match "" $pivot_jct] {
      set mom_sim_pivot_jct   $pivot_jct
   } else {
      set mom_sim_pivot_jct   $mom_sim_spindle_jct
   }


  # For this machine that all physical axes participate in executing a motion.
   PB_SIM_call SIM_ask_nc_axes_of_mtool

   set axes_config_list [list]

   if [info exists mom_sim_mt_axis(X)] {
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(X)"] >= 0 } {
         lappend axes_config_list $mom_sim_mt_axis(X)
      }
   }

   if [info exists mom_sim_mt_axis(Y)] {
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Y)"] >= 0 } {
         lappend axes_config_list $mom_sim_mt_axis(Y)
      }
   }

   if [info exists mom_sim_mt_axis(Z)] {
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Z)"] >= 0 } {
         lappend axes_config_list $mom_sim_mt_axis(Z)
      }
   }

   if { [llength $axes_config_list] > 0 } {
      PB_SIM_call SIM_set_linear_axes_config [concat $axes_config_list]
   }


   set axes_config_list [list]

   switch $mom_sim_num_machine_axes {
      "4" {
         if [info exists mom_sim_mt_axis(4)] {
            if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(4)"] >= 0 } {
               lappend axes_config_list $mom_sim_mt_axis(4)
            }
         }
      }
      "5" {
         if [info exists mom_sim_mt_axis(4)] {
            if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(4)"] >= 0 } {
               lappend axes_config_list $mom_sim_mt_axis(4)
            }
         }
         if [info exists mom_sim_mt_axis(5)] {
            if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(5)"] >= 0 } {
               lappend axes_config_list $mom_sim_mt_axis(5)
            }
         }
      }
   }

   if { [llength $axes_config_list] > 0 } {
      PB_SIM_call SIM_set_rotary_axes_config [concat $axes_config_list]
   }
}


#=============================================================
proc PB_CMD_vnc__reset_controller { } {
#=============================================================
  global mom_sim_nc_register

  # Initialize controller state
   set mom_sim_nc_register(MOTION)         RAPID
   set mom_sim_nc_register(STROKE_LIMIT)   ON
   set mom_sim_nc_register(CUTCOM)         OFF
   set mom_sim_nc_register(TL_ADJUST)      OFF
   set mom_sim_nc_register(SCALE)          OFF
   set mom_sim_nc_register(MACRO_MODAL)    OFF
   set mom_sim_nc_register(WCS_ROTATE)     OFF
   set mom_sim_nc_register(CYCLE)          OFF
   set mom_sim_nc_register(CYCLE_RETURN)   INIT_LEVEL
   set mom_sim_nc_register(RETURN_HOME)    0
   set mom_sim_nc_register(FROM_HOME)      0
}


#=============================================================
proc PB_CMD_vnc__reset_coordinate { } {
#=============================================================
# Called when a G92 is encountered.
#
  global mom_sim_nc_register
  global mom_sim_motion_begun
  global mom_sim_prev_pos

 # Absolute coordinates specified with the block.
  global mom_sim_offset_pt


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Comment out "return" to process work coordinate reset for lathe post
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   if [string match "TURN" $mom_sim_nc_register(MACHINE_MODE)] {
return
   }


   for {set i 0} {$i < 5} {incr i} {

     # Only change the components that exist in the block.
     #
      if [info exists mom_sim_offset_pt($i)] {
        #---------------------------------------------------
        # Do not change offset when the motion hasn't begun,
        # since mom_sim_prev_pos may not be reliable.
        #---------------------------------------------------
         if $mom_sim_motion_begun {
            set offset [expr $mom_sim_offset_pt($i) - $mom_sim_prev_pos($i)]
            set mom_sim_nc_register(MAIN_OFFSET)  [lreplace $mom_sim_nc_register(MAIN_OFFSET) $i $i $offset]
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__reset_nc_registers { } {
#=============================================================
# This command is called by VNC processor for every block to
# reset the => Non-Modal <= registers and control states.
#

  global mom_sim_address
  global mom_sim_nc_register

  # Address registers -
  #
   set addr_list {X Y Z fourth_axis fifth_axis I J K R K_cycle S F}
   foreach addr $addr_list {
      if { [info exists mom_sim_address($addr,modal)] && !$mom_sim_address($addr,modal) } {
         VNC_unset_vars mom_sim_nc_register($addr)
      }
   }

  # Control states -
  #
   set addr_list {G_motion G_plane}
   foreach addr $addr_list {
      if { [info exists mom_sim_address($addr,modal)] && !$mom_sim_address($addr,modal) } {
         switch $addr {
            G_motion {
               set mom_sim_nc_register(MOTION) RAPID
            }
            G_plane {
               set mom_sim_nc_register(PLANE) XY
            }
            default {
            }
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__return_home { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_lg_axis
  global mom_sim_num_machine_axes
  global mom_sim_prev_pos


  # We'll simulate the subspindle movements with different codes.
   if $mom_sim_nc_register(CROSS_MACHINING) {
return
   }


  # Fetch specified components of the intermediate pt.
   set coord_list [list]
   if [info exists mom_sim_nc_register(REF_INT_PT_X)] {
      if [expr $mom_sim_nc_register(REF_INT_PT_X) != $mom_sim_prev_pos(0)] {
         lappend coord_list $mom_sim_lg_axis(X)  $mom_sim_nc_register(REF_INT_PT_X)
      }
   }
   if [info exists mom_sim_nc_register(REF_INT_PT_Y)] {
      if [expr $mom_sim_nc_register(REF_INT_PT_Y) != $mom_sim_prev_pos(1)] {
         lappend coord_list $mom_sim_lg_axis(Y)  $mom_sim_nc_register(REF_INT_PT_Y)
      }
   }
   if [info exists mom_sim_nc_register(REF_INT_PT_Z)] {
      if [expr $mom_sim_nc_register(REF_INT_PT_Z) != $mom_sim_prev_pos(2)] {
         lappend coord_list $mom_sim_lg_axis(Z)  $mom_sim_nc_register(REF_INT_PT_Z)
      }
   }

   if { $mom_sim_num_machine_axes > 3 } {
      if [info exists mom_sim_nc_register(REF_INT_PT_4)] {
         if [expr $mom_sim_nc_register(REF_INT_PT_4) != $mom_sim_prev_pos(3)] {
            lappend coord_list $mom_sim_lg_axis(4)  $mom_sim_nc_register(REF_INT_PT_4)
         }
      }
   }

   if { $mom_sim_num_machine_axes > 4 } {
      if [info exists mom_sim_nc_register(REF_INT_PT_5)] {
         if [expr $mom_sim_nc_register(REF_INT_PT_5) != $mom_sim_prev_pos(4)] {
            lappend coord_list $mom_sim_lg_axis(5)  $mom_sim_nc_register(REF_INT_PT_5)
         }
      }
   }


global mom_sim_message
set mom_sim_message "INT PT >$coord_list<"
PB_CMD_vnc__send_message


  # Position tool to intermediate pt, if specified.
   if { [llength $coord_list] > 0 } {
      eval PB_SIM_call VNC_move_linear_zcs RAPID $coord_list
   }

  # Position spindle (not tool) to reference pt
   PB_SIM_call PB_CMD_vnc__send_dogs_home


       # Intermediate pt is saved for subsequent FROM_HOME move
       # then discarded after use.
        #--------------------------------------------------
        # Initialize previous Intermediate Reference Point.
        #--------------------------------------------------
         if [info exists mom_sim_nc_register(REF_INT_PT_X_PREV)] {
            unset mom_sim_nc_register(REF_INT_PT_X_PREV)
         }
         if [info exists mom_sim_nc_register(REF_INT_PT_Y_PREV)] {
            unset mom_sim_nc_register(REF_INT_PT_Y_PREV)
         }
         if [info exists mom_sim_nc_register(REF_INT_PT_Z_PREV)] {
            unset mom_sim_nc_register(REF_INT_PT_Z_PREV)
         }
         if [info exists mom_sim_nc_register(REF_INT_PT_4_PREV)] {
            unset mom_sim_nc_register(REF_INT_PT_4_PREV)
         }
         if [info exists mom_sim_nc_register(REF_INT_PT_5_PREV)] {
            unset mom_sim_nc_register(REF_INT_PT_5_PREV)
         }

        #-----------------------------------------
        # Initialize Intermediate Reference Point.
        #-----------------------------------------
         if [info exists mom_sim_nc_register(REF_INT_PT_X)] {
            set mom_sim_nc_register(REF_INT_PT_X_PREV) $mom_sim_nc_register(REF_INT_PT_X)
            unset mom_sim_nc_register(REF_INT_PT_X)
         }
         if [info exists mom_sim_nc_register(REF_INT_PT_Y)] {
            set mom_sim_nc_register(REF_INT_PT_Y_PREV) $mom_sim_nc_register(REF_INT_PT_Y)
            unset mom_sim_nc_register(REF_INT_PT_Y)
         }
         if [info exists mom_sim_nc_register(REF_INT_PT_Z)] {
            set mom_sim_nc_register(REF_INT_PT_Z_PREV) $mom_sim_nc_register(REF_INT_PT_Z)
            unset mom_sim_nc_register(REF_INT_PT_Z)
         }
         if [info exists mom_sim_nc_register(REF_INT_PT_4)] {
            set mom_sim_nc_register(REF_INT_PT_4_PREV) $mom_sim_nc_register(REF_INT_PT_4)
            unset mom_sim_nc_register(REF_INT_PT_4)
         }
         if [info exists mom_sim_nc_register(REF_INT_PT_5)] {
            set mom_sim_nc_register(REF_INT_PT_5_PREV) $mom_sim_nc_register(REF_INT_PT_5)
            unset mom_sim_nc_register(REF_INT_PT_5)
         }

  # Reset controller
   PB_SIM_call VNC_reset_controller
}


#=============================================================
proc PB_CMD_vnc__rewind_stop_program { } {
#=============================================================
  global mom_sim_nc_register

  # Fake a temporary intermediate reference point to send all dogs home
   set mom_sim_nc_register(REF_INT_PT_X) 0
   set mom_sim_nc_register(REF_INT_PT_Y) 0
   set mom_sim_nc_register(REF_INT_PT_Z) 0
   set mom_sim_nc_register(REF_INT_PT_4) 0
   set mom_sim_nc_register(REF_INT_PT_5) 0

  # Position spindle to reference point.
   PB_SIM_call PB_CMD_vnc__send_dogs_home

  # Unset temporary intermediate reference point
   unset mom_sim_nc_register(REF_INT_PT_X)
   unset mom_sim_nc_register(REF_INT_PT_Y)
   unset mom_sim_nc_register(REF_INT_PT_Z)
   unset mom_sim_nc_register(REF_INT_PT_4)
   unset mom_sim_nc_register(REF_INT_PT_5)

   PB_SIM_call VNC_reset_controller
}


#=============================================================
proc PB_CMD_vnc__send_dogs_home { } {
#=============================================================
  global mom_sim_mt_axis
  global mom_sim_num_machine_axes
  global mom_sim_nc_register
  global mom_sim_result mom_sim_result1


  # Make sure the polar mode is OFF.
   PB_SIM_call SIM_set_linearization OFF


  # Determine the axes that need to move per intermediate pt specified.
   set move_X 0
   set move_Y 0
   set move_Z 0
   set move_4 0
   set move_5 0

   PB_SIM_call SIM_ask_nc_axes_of_mtool


   if { [info exists mom_sim_nc_register(REF_INT_PT_X)] } {
      if { [info exists mom_sim_mt_axis(X)] } {
         if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(X)"] >= 0 } {
            set move_X 1
         }
      }
   }
   if { [info exists mom_sim_nc_register(REF_INT_PT_Y)] } {
      if { [info exists mom_sim_mt_axis(Y)] } {
         if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Y)"] >= 0 } {
            set move_Y 1
         }
      }
   }
   if { [info exists mom_sim_nc_register(REF_INT_PT_Z)] } {
      if { [info exists mom_sim_mt_axis(Z)] } {
         if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Z)"] >= 0 } {
            set move_Z 1
         }
      }
   }

   if { $mom_sim_num_machine_axes > 3 } {
      if { [info exists mom_sim_nc_register(REF_INT_PT_4)] } {
         set move_4 1
      }
   }

   if { $mom_sim_num_machine_axes > 4 } {
      if { [info exists mom_sim_nc_register(REF_INT_PT_5)] } {
         set move_5 1
      }
   }


  # Establish machine home position in MTCS for the 1st time.
   global mom_sim_pos_mtcs
   global mom_sim_lg_axis
   global mom_sim_spindle_jct mom_sim_current_junction
   global mom_sim_pivot_jct

  # Make use of pivot junction
   if { [info exists mom_sim_pivot_jct] } {
      PB_SIM_call SIM_set_current_ref_junction $mom_sim_pivot_jct
   } else {
      PB_SIM_call SIM_set_current_ref_junction $mom_sim_spindle_jct
   }

  # To prevent ref jct being reset to tool tip in sim_motion
   global mom_sim_tool_junction mom_sim_current_tool_junction
   global mom_sim_current_junction

  # pb602 - Do not override current tool jct
   if { ![info exists mom_sim_current_tool_junction] } {
      set mom_sim_current_tool_junction "$mom_sim_tool_junction"
   }

   set mom_sim_tool_junction "$mom_sim_current_junction"


  # Keep track of current position
   PB_SIM_call VNC_update_sim_pos


  # Set RAPID mode
   PB_SIM_call VNC_set_feedrate_mode RAPID

   set time 1

  # Establish ref pt
   if { ![info exists mom_sim_pos_mtcs(0)] } {
      if { $move_X } {
         PB_SIM_call SIM_move_linear_axis 1 $mom_sim_mt_axis(X) [lindex $mom_sim_nc_register(REF_PT) 0]
         set ref_pt [PB_SIM_call SIM_ask_last_position_mtcs]
         set mom_sim_pos_mtcs(0) [lindex $ref_pt 0]
      }
   }
   if { ![info exists mom_sim_pos_mtcs(1)] } {
      if { $move_Y } {
         if { [info exists mom_sim_mt_axis(Y)] } {
            PB_SIM_call SIM_move_linear_axis 1 $mom_sim_mt_axis(Y) [lindex $mom_sim_nc_register(REF_PT) 1]
            set ref_pt [PB_SIM_call SIM_ask_last_position_mtcs]
            set mom_sim_pos_mtcs(1) [lindex $ref_pt 1]
         }
      }
   }
   if { ![info exists mom_sim_pos_mtcs(2)] } {
      if { $move_Z } {
         PB_SIM_call SIM_move_linear_axis 1 $mom_sim_mt_axis(Z) [lindex $mom_sim_nc_register(REF_PT) 2]
         set ref_pt [PB_SIM_call SIM_ask_last_position_mtcs]
         set mom_sim_pos_mtcs(2) [lindex $ref_pt 2]
      }
   }

  # Always zero rotary axes ???
   if { $mom_sim_num_machine_axes > 3 } {
     # set move_4 1
   }

   if { $mom_sim_num_machine_axes > 4 } {
     # set move_5 1
   }


   set coord_list [list]
   if { $move_X } {
      lappend coord_list $mom_sim_lg_axis(X) $mom_sim_pos_mtcs(0)
   }
   if { $move_Y } {
      lappend coord_list $mom_sim_lg_axis(Y) $mom_sim_pos_mtcs(1)
   }
   if { $move_Z } {
      lappend coord_list $mom_sim_lg_axis(Z) $mom_sim_pos_mtcs(2)
   }


   if { [llength $coord_list] > 0 } {
      eval PB_SIM_call SIM_move_linear_mtcs $coord_list
   }


global mom_sim_message
set mom_sim_message "REF PT >$mom_sim_nc_register(REF_PT)<"
PB_CMD_vnc__send_message


  # If a rotary axis is limitless, only unwind it to the modulu of 360!
  #
   global mom_sim_num_machine_axes mom_sim_mt_axis
   global mom_sim_4th_axis_has_limits mom_sim_5th_axis_has_limits
   global mom_sim_4th_axis_direction mom_sim_5th_axis_direction

   global mom_sim_pos

   global mom_sim_4th_axis_max_limit mom_sim_4th_axis_min_limit
   global mom_sim_5th_axis_max_limit mom_sim_5th_axis_min_limit

   if { [expr $mom_sim_num_machine_axes > 4] } {

      if { $move_5 } {

         if { $mom_sim_5th_axis_has_limits } {

            set mom_sim_pos(4) 0

         } else {

            PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(5)

            if { ![EQ_is_equal $mom_sim_result $mom_sim_pos(4)] } {

               PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(5) NORM_180
               set mom_sim_pos(4) 0.0

            } else {

               if { [expr $mom_sim_pos(4) < 0.0] } {
                  set sign -1
               } else {
                  set sign 1
               }

               set rem [expr fmod($mom_sim_pos(4),360)]
               if { [expr abs($rem) > 180] } {
                  set mom_sim_pos(4) [expr $mom_sim_pos(4) + $sign*360 - $rem]
               } else {
                  set mom_sim_pos(4) [expr $mom_sim_pos(4) - $rem]
               }

               if { [EQ_is_zero $mom_sim_pos(4)] } {
                  set mom_sim_pos(4) 0.0
               }
            }
         }

         PB_SIM_call SIM_set_interpolation OFF

         if { [EQ_is_lt $mom_sim_pos(4) $mom_sim_5th_axis_min_limit] || [EQ_is_gt $mom_sim_pos(4) $mom_sim_5th_axis_max_limit] } {

            PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(5) NORM_180
            PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(5)
            set mom_sim_pos(4) $mom_sim_result
         }

         PB_SIM_call SIM_move_rotary_axis 5 $mom_sim_mt_axis(5) $mom_sim_pos(4)
         PB_SIM_call SIM_set_interpolation ON
      }
   }

   if { [expr $mom_sim_num_machine_axes > 3] } {

      if { $move_4 } {

         if { $mom_sim_4th_axis_has_limits } {

            set mom_sim_pos(3) 0

         } else {

            PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(4)

            if { ![EQ_is_equal $mom_sim_result $mom_sim_pos(3)] } {

               PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(4) NORM_180
               set mom_sim_pos(3) 0.0

            } else {

               if { [expr $mom_sim_pos(3) < 0.0] } {
                  set sign -1
               } else {
                  set sign 1
               }
               set rem [expr fmod($mom_sim_pos(3),360)]
               if { [expr abs($rem) > 180] } {
                  set mom_sim_pos(3) [expr $mom_sim_pos(3) + $sign*360 - $rem]
               } else {
                  set mom_sim_pos(3) [expr $mom_sim_pos(3) - $rem]
               }

               if { [EQ_is_zero $mom_sim_pos(3)] } {
                  set mom_sim_pos(3) 0.0
               }
            }
         }

         PB_SIM_call SIM_set_interpolation OFF

         if { [EQ_is_lt $mom_sim_pos(3) $mom_sim_4th_axis_min_limit] ||
              [EQ_is_gt $mom_sim_pos(3) $mom_sim_4th_axis_max_limit] } {

            PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(4) NORM_180
            PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(4)
            set mom_sim_pos(3) $mom_sim_result
         }

         PB_SIM_call SIM_move_rotary_axis 5 $mom_sim_mt_axis(4) $mom_sim_pos(3)
         PB_SIM_call SIM_set_interpolation ON
      }
   }


   PB_SIM_call SIM_update


 # pb601(e) - It seems to be needed for MS NT4200 kit, otherwise lower turret doesn't move properly.
 #            This was deemed to cause prematured change of tracking jct and disabled in pb600.
 if 1 {
  # pb501 -
  # PB_SIM_call SIM_set_current_ref_junction $mom_sim_current_junction

  # Restore current tool ref jct
   global mom_sim_tool_junction mom_sim_current_tool_junction
   global mom_sim_current_junction

  # pb602 - Enhanced condition
   if { [info exists mom_sim_current_tool_junction] && [string length $mom_sim_current_tool_junction] > 0 } {
      set mom_sim_tool_junction "$mom_sim_current_tool_junction"
      set mom_sim_current_junction "$mom_sim_tool_junction"
   }

  # Restore tracking point back to tool tip
  # pb602 - Enhanced condition (ISV of lower turret would fail w/o this checking.)
   if { [string length $mom_sim_current_junction] > 0 } {
      PB_SIM_call SIM_set_current_ref_junction $mom_sim_current_junction
   }
 }


  # Keep track of current position
   PB_SIM_call VNC_update_sim_pos


  # Zero Y for lathe mode
   if { [string match "TURN" $mom_sim_nc_register(MACHINE_MODE)] } {
      set mom_sim_pos(1) 0
   }


  # Zero all other axes
   set mom_sim_pos(5) 0
   set mom_sim_pos(6) 0
   set mom_sim_pos(7) 0
}


#=============================================================
proc PB_CMD_vnc__send_message { } {
#=============================================================
# Comment the "return" statement below to output debug messages to ISV dialog.
return

   global mom_sim_message

   VNC_send_message "$mom_sim_message"
}


#=============================================================
proc PB_CMD_vnc__set_feed { } {
#=============================================================
  global mom_sim_nc_register

   if { [string match "RAPID" $mom_sim_nc_register(MOTION)] || [expr $mom_sim_nc_register(F) <= 0] } {
      global mom_sim_rapid_feed_rate
      if { ![string compare "MM" $mom_sim_nc_register(UNIT)] } {
          set feed $mom_sim_rapid_feed_rate
          set feed_mode MM_PER_MIN
      } else {
          set feed $mom_sim_rapid_feed_rate
          set feed_mode INCH_PER_MIN
      }

      set mom_sim_nc_register(MOTION) "RAPID"

   } else {

      set feed $mom_sim_nc_register(F)
      set feed_mode $mom_sim_nc_register(FEED_MODE)
   }

   PB_SIM_call SIM_set_feed $feed $feed_mode
}


#=============================================================
proc PB_CMD_vnc__set_feedrate_mode { } {
#=============================================================
  global mom_sim_cutting_mode
  global mom_sim_feedrate_mode
  global sim_feedrate_mode

   if ![info exists mom_sim_cutting_mode] {
      set mom_sim_cutting_mode "RAPID"
   }

   PB_SIM_call SIM_set_cutting_mode  $mom_sim_cutting_mode

   set sim_feedrate_mode $mom_sim_cutting_mode
   set mom_sim_feedrate_mode $mom_sim_cutting_mode


   PB_SIM_call PB_CMD_vnc__set_feed
}


#=============================================================
proc PB_CMD_vnc__set_kinematics { } {
#=============================================================
   PB_SIM_call VNC_set_kinematics
}


#=============================================================
proc PB_CMD_vnc__set_local_offsets { } {
#=============================================================
# This function is executed when G52 is commanded.
# It calculates the offsets for defining a local CSYS within
# the active WCS.
#
  global mom_sim_nc_register

 # Absolute coordinates specified with the block.
  global mom_sim_offset_pt


   for {set i 0} {$i < 5} {incr i} {
      if [info exists mom_sim_offset_pt($i)] {
         set mom_sim_nc_register(LOCAL_OFFSET)  [lreplace $mom_sim_nc_register(LOCAL_OFFSET) $i $i $mom_sim_offset_pt($i)]
      }
   }
}


#=============================================================
proc PB_CMD_vnc__set_param_per_msg { } {
#=============================================================
# This function is executed for special message blocks
# that have been passed via PB_CMD_vnc__output_vnc_msg or
# VNC_output_vnc_msg.
#
# - This function may not be executed in a standalone NC file
#   simulation. Parameters defined here will need to be set
#   some place else.
#
  global mom_sim_msg_key mom_sim_msg_word


VNC_output_debug_msg "VNC_MSG - key:$mom_sim_msg_key  word:$mom_sim_msg_word"


  #--------------------------------------------------------------
  # Execute user's function
  # ==> A user can pass additional tokens via VNC_output_vnc_msg
  #     and then provide handlers in this command.
  #--------------------------------------------------------------
   PB_SIM_call PB_CMD_vnc____set_param_per_msg


   global mom_sim_tool_number mom_sim_tool_data

   switch $mom_sim_msg_key {

      "CUT_DATA_TYPE" {
         global mom_sim_cut_data_type
         set mom_sim_cut_data_type $mom_sim_msg_word
      }

      "CONTACT_TRACKING_TYPE" {
         global mom_sim_contact_tracking_type
         set mom_sim_contact_tracking_type $mom_sim_msg_word
      }

      "CONTACT_TRACKING_DIAMETER" {
         global mom_sim_tool_cutcom_offset
         set mom_sim_tool_cutcom_offset [expr $mom_sim_msg_word / 2]
      }

      "CONTACT_TRACKING_DISTANCE" {
         global mom_sim_tool_adjust_offset
         set mom_sim_tool_adjust_offset $mom_sim_msg_word
      }

      "HELIX_PITCH" {
        # pb601(c) -
         global mom_sim_PI
         global mom_sim_helix_pitch
         set mom_sim_helix_pitch "$mom_sim_msg_word"
      }

      "HELIX_PITCH_TYPE" {
         global mom_sim_helix_pitch_type
         set mom_sim_helix_pitch_type "$mom_sim_msg_word"
      }

      "HELIX_OUTPUT_MODE" {
         global mom_sim_helix_output_mode
         set mom_sim_helix_output_mode "$mom_sim_msg_word"
      }

      "SPINDLE_DIRECTION" {
         global mom_sim_spindle_direction
         set mom_sim_spindle_direction "$mom_sim_msg_word"
      }

      "SPINDLE_MODE" {
         global mom_sim_spindle_mode
         global mom_sim_nc_register

         switch $mom_sim_msg_word {
            RPM { set mom_sim_msg_word REV_PER_MIN }
         }
         set mom_sim_spindle_mode $mom_sim_msg_word
         set mom_sim_nc_register(SPINDLE_MODE) $mom_sim_spindle_mode
      }

      "SPINDLE_MAX_RPM" {
         global mom_sim_spindle_max_rpm

        # Set maximum spindle speed to controller's default.
         global mom_sim_default_spindle_max_rpm
         if { [EQ_is_gt $mom_sim_msg_word 0.0] } {
            set mom_sim_spindle_max_rpm "$mom_sim_msg_word"
         } else {
            set mom_sim_spindle_max_rpm $mom_sim_default_spindle_max_rpm
         }
      }

      "SPINDLE_SPEED" {
         global mom_sim_spindle_speed mom_sim_spindle_mode
         set mom_sim_spindle_speed "$mom_sim_msg_word"

         PB_SIM_call PB_CMD_vnc__set_speed
      }

      "TOOL_NUMBER" {
         set mom_sim_tool_number "$mom_sim_msg_word"

         global mom_sim_tool_change
         set mom_sim_tool_change 1

         global mom_sim_tool_carrier_id
         if { [info exists mom_sim_tool_carrier_id] } {
            set mom_sim_tool_data($mom_sim_tool_number,carrier_id) "\"$mom_sim_tool_carrier_id\""
         }
      }

      "TOOL_NAME" {
         global mom_sim_ug_tool_name
         set mom_sim_ug_tool_name "$mom_sim_msg_word"

        # Capture tool data in an array.
         set mom_sim_tool_data($mom_sim_tool_number,name) $mom_sim_ug_tool_name
      }

      "TOOL_TYPE" {
         global mom_sim_tool_type
         set mom_sim_tool_type "$mom_sim_msg_word"

        # Capture tool type
         if { [string match "MILL*" [string toupper $mom_sim_tool_type]] } {
            set type MILL
         } elseif { [string match "DRILL*" [string toupper $mom_sim_tool_type]] } {
            set type DRILL
         } else {
            set type TURN
         }
         set mom_sim_tool_data($mom_sim_tool_number,type) $type
      }

      "TOOL_OFFSET" {
         global mom_sim_tool_offset_used
         set mom_sim_tool_offset_used "$mom_sim_msg_word"

         set mom_sim_tool_data($mom_sim_tool_number,offset_used) $mom_sim_tool_offset_used
      }

      "TOOL_X_OFF" {
         global mom_sim_tool_offset
         set mom_sim_tool_offset(0) "$mom_sim_msg_word"

         set mom_sim_tool_data($mom_sim_tool_number,x_off) $mom_sim_tool_offset(0)
      }

      "TOOL_Y_OFF" {
         global mom_sim_tool_offset
         set mom_sim_tool_offset(1) "$mom_sim_msg_word"

         set mom_sim_tool_data($mom_sim_tool_number,y_off) $mom_sim_tool_offset(1)
      }

      "TOOL_Z_OFF" {
         global mom_sim_tool_offset
         set mom_sim_tool_offset(2) "$mom_sim_msg_word"

         set mom_sim_tool_data($mom_sim_tool_number,z_off) $mom_sim_tool_offset(2)
      }

      "TOOL_CARRIER_ID" {
         global mom_sim_tool_carrier_id
         set mom_sim_tool_carrier_id "$mom_sim_msg_word"

         if { [info exists mom_sim_tool_number] } {
            set mom_sim_tool_data($mom_sim_tool_number,carrier_id) "\"$mom_sim_tool_carrier_id\""
         }
      }

      "SPINDLE_GROUP" {
         global mom_sim_spindle_group
         set mom_sim_spindle_group "$mom_sim_msg_word"
      }

      "TOOL_POCKET_ID" {
         global mom_sim_tool_pocket_id
         set mom_sim_tool_pocket_id "$mom_sim_msg_word"

         set mom_sim_tool_data($mom_sim_tool_number,pocket_id) "\"$mom_sim_tool_pocket_id\""
      }

      "TOOL_DIAMETER" {
         global mom_sim_tool_diameter
         set mom_sim_tool_diameter "$mom_sim_msg_word"

         global mom_sim_cut_data_type
         if { [info exists mom_sim_cut_data_type] && [string match "CONTACT_CONTOUR" $mom_sim_cut_data_type] } {
            global mom_sim_contact_tracking_type
            if { [string match "BOTTOM" $mom_sim_contact_tracking_type] } {
               global mom_sim_tool_cutcom_offset
               set mom_sim_tool_cutcom_offset [expr $mom_sim_tool_diameter / 2]
            }
         }

         set mom_sim_tool_data($mom_sim_tool_number,diameter) $mom_sim_tool_diameter
      }

      "TOOL_CUTCOM_REG" {
         global mom_sim_tool_cutcom_register
         set mom_sim_tool_cutcom_register "$mom_sim_msg_word"

        # Register cutcom offset
         global mom_sim_tool_cutcom_offset

         if { ![info exists mom_sim_tool_cutcom_offset] } {
            set mom_sim_tool_cutcom_offset 0.0
         }

         global mom_sim_tool_cutcom_data

         set mom_sim_tool_cutcom_data($mom_sim_tool_cutcom_register) $mom_sim_tool_cutcom_offset

         set mom_sim_tool_data($mom_sim_tool_number,cutcom_register) $mom_sim_tool_cutcom_register
      }

      "TOOL_ADJUST_REG" {
         global mom_sim_tool_adjust_register
         set mom_sim_tool_adjust_register "$mom_sim_msg_word"

        # Register length offset
         global mom_sim_tool_adjust_offset

         if { ![info exists mom_sim_tool_adjust_offset] } {
            set mom_sim_tool_adjust_offset 0.0
         }

         global mom_sim_tool_adjust_data

         set mom_sim_tool_adjust_data($mom_sim_tool_adjust_register) $mom_sim_tool_adjust_offset

         set mom_sim_tool_data($mom_sim_tool_number,adjust_register) $mom_sim_tool_adjust_register
      }

      "HEAD_NAME" {
         global mom_sim_machine_head
         set mom_sim_machine_head "$mom_sim_msg_word"
      }

      "POST_NAME" {
         global mom_sim_post_name
         global mom_sim_vnc_handler_loaded

         set mom_sim_post_name "$mom_sim_msg_word"

         set new_vnc_file [string trim ${mom_sim_post_name}_vnc.tcl]
         set new_vnc_file [join [split $new_vnc_file \\] /]

        # pb602(h) - If not in revPost (ex NC code) mode, VNC will be loaded with the post. No need to load it here!
         global mom_sim_post_builder_rev_post
         if { $mom_sim_post_builder_rev_post } {

            if { [string compare [string trim $mom_sim_vnc_handler_loaded] $new_vnc_file] } {
               uplevel #0 {
                  source ${mom_sim_post_name}_vnc.tcl
               }
               PB_SIM_call PB_CMD_vnc__init_sim_vars
            }
         }
      }

      "CYCLE_SPINDLE_AXIS" {
         global mom_sim_cycle_spindle_axis
         set mom_sim_cycle_spindle_axis "$mom_sim_msg_word"
      }

      "CSYS_FIXTURE_OFFSET" {
         global mom_sim_fixture_offset
         set mom_sim_fixture_offset "$mom_sim_msg_word"
      }

      default {
      }
   }


  # Grab CSYS_MTX_'s
  #
   global mom_sim_csys_matrix mom_sim_csys_set
   global mom_sim_csys_data

   global mom_sim_fixture_offset
   if { ![info exists mom_sim_fixture_offset] } {
      set mom_sim_fixture_offset 0
   }


   if { [string match "CSYS_MTX_*" $mom_sim_msg_key] } {
      set tokens [split $mom_sim_msg_key _]
      set idx [lindex $tokens 2]

      set mom_sim_csys_matrix($idx) "$mom_sim_msg_word"

     # Store CSYS matrix
      set mom_sim_csys_data($mom_sim_fixture_offset,$idx) "$mom_sim_msg_word"


     # When csys is completely defined, map and set ZCS junction for simulation.
      if { $idx == 11 } {

        #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        # -- We don't want to override G68.1 CSYS configuration
        #    that has been defined per NC code instead of MCS object.
        #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         if { ![info exists mom_sim_nc_register(CSYS_ROTATION)] } {

            PB_SIM_call PB_CMD_vnc__set_kinematics
            set mom_sim_csys_set 1

           # Signal a new CSYS is set (See M304 for sub-spindle)
            global mom_sim_csys_origin_initial
            set mom_sim_csys_origin_initial 1
         }
      }
   }


  # Grab NURBS data
  #
   global mom_sim_nurbs_start
   global mom_sim_nurbs_order
   global mom_sim_nurbs_knot_count
   global mom_sim_nurbs_knots
   global mom_sim_nurbs_point_count
   global mom_sim_nurbs_points
   global mom_sim_nurbs_point_end_index

   if { [string match "NURBS_START" $mom_sim_msg_key] } {
      set mom_sim_nurbs_start 0
   }

   if { [string match "NURBS_ORDER" $mom_sim_msg_key] } {
      set mom_sim_nurbs_order $mom_sim_msg_word
   }

   if { [string match "NURBS_KNOT_COUNT" $mom_sim_msg_key] } {
      set mom_sim_nurbs_knot_count $mom_sim_msg_word
      set mom_sim_nurbs_knots [list]
   }

   if { [string match "NURBS_POINT_COUNT" $mom_sim_msg_key] } {
      set mom_sim_nurbs_point_count $mom_sim_msg_word
      set mom_sim_nurbs_points [list]
      set mom_sim_nurbs_point_end_index [expr $mom_sim_nurbs_point_count - 1]
   }

   if { [string match "NURBS_KNOTS*" $mom_sim_msg_key] } {
      lappend mom_sim_nurbs_knots $mom_sim_msg_word
   }

  # Info of control points is the last set of parameters passed from a NURBS event.
  # (See PB_CMD_vnc__pass_nurbs_data)
  #
   if { [string match "NURBS_POINTS*" $mom_sim_msg_key] } {
      lappend mom_sim_nurbs_points $mom_sim_msg_word

     # When the control points list is completed, set off simulation.
      if { [string match "*($mom_sim_nurbs_point_end_index,Z)*" $mom_sim_msg_key] } {
         global mom_sim_nc_register
         set mom_sim_nc_register(MOTION) NURBS

         set mom_sim_nurbs_start 1
         PB_SIM_call PB_CMD_vnc__sim_motion

         VNC_unset_vars  mom_sim_nurbs_start
      }
   }


  # Nullify msg key
   set mom_sim_msg_key ""
   set mom_sim_msg_word ""
}


#=============================================================
proc PB_CMD_vnc__set_speed { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_spindle_speed mom_sim_spindle_mode
  global mom_sim_spindle_max_rpm
  global mom_sim_primary_channel
  global mom_sim_tool_carrier_id

  global mom_carrier_name


   set spindle_speed $mom_sim_nc_register(S)
   set spindle_mode  $mom_sim_nc_register(SPINDLE_MODE)

   if [expr $mom_sim_nc_register(S) <= 0.0] {
      if [expr $mom_sim_spindle_speed > 0.0] {
         set spindle_speed $mom_sim_spindle_speed
      } else {
         set spindle_speed $mom_sim_spindle_max_rpm
         set spindle_mode  "REV_PER_MIN"
      }
   }


  # Set primary channel
   set primary_channel_set 0

   if [info exists mom_sim_primary_channel] {
      if { [string compare "REV_PER_MIN" $spindle_mode]  ||  ![string compare "TURN" $mom_sim_nc_register(MACHINE_MODE)] } {

         if [info exists mom_sim_tool_carrier_id] {

            if [expr $mom_sim_tool_carrier_id != $mom_carrier_name] {
               set mom_sim_tool_carrier_id $mom_carrier_name
            }

            if { ![string compare $mom_sim_primary_channel $mom_sim_tool_carrier_id] } {
               PB_SIM_call SIM_primary_channel $mom_sim_primary_channel
               set primary_channel_set 1
            }
         }
      }
   }


  # Set max spindle rpm
   if $primary_channel_set {

      if { ![string compare "TURN" $mom_sim_nc_register(MACHINE_MODE)] } {

        # Reduce spindle speed to the max
         if { ![string compare "REV_PER_MIN" $spindle_mode] } {
            if [EQ_is_gt $spindle_speed $mom_sim_spindle_max_rpm] {
               set spindle_speed $mom_sim_spindle_max_rpm
            }
         }

        # Set max spindle speed
         PB_SIM_call SIM_set_max_spindle_speed $mom_sim_spindle_max_rpm "REV_PER_MIN"
      }
   }


  # Pass on spindle data
   set mom_sim_spindle_mode  $spindle_mode
   set mom_sim_spindle_speed $spindle_speed

   if [string match "REV_PER_MIN" $spindle_mode] {

      switch "$mom_sim_nc_register(MACHINE_MODE)" {
         "MILL" {
            PB_SIM_call SIM_set_speed $spindle_speed $spindle_mode
         }
         "TURN" {
            if $primary_channel_set {
               PB_SIM_call SIM_set_spindle_speed $spindle_speed $spindle_mode
            }
         }
      }

   } else {

      if $primary_channel_set {
         if [string match "SFM" $spindle_mode] {
            PB_SIM_call SIM_set_surface_speed $spindle_speed "FEET_PER_MIN"
            set mom_sim_spindle_mode "FEET_PER_MIN"
         } else {
            PB_SIM_call SIM_set_surface_speed $spindle_speed "M_PER_MIN"
            set mom_sim_spindle_mode "M_PER_MIN"
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__sim_motion { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nurbs_start


  # Initialize ref csys just incase.
   global mom_sim_csys_set
   if !$mom_sim_csys_set {
      PB_SIM_call PB_CMD_vnc__set_kinematics
      set mom_sim_csys_set 1
   }


  # Disable simulation when a NURBS definition starts.
   if { [info exists mom_sim_nurbs_start] && !$mom_sim_nurbs_start } {
return
   }

  # Set feed & speed
   PB_SIM_call PB_CMD_vnc__set_feed
   PB_SIM_call PB_CMD_vnc__set_speed


  # We'll simulate the sub-spindle movements with different codes.
   if $mom_sim_nc_register(CROSS_MACHINING) {
return
   }


global mom_sim_o_buffer
global mom_sim_message
set mom_sim_message "** $mom_sim_nc_register(MOTION) -- $mom_sim_o_buffer **"
PB_CMD_vnc__send_message


  # Reset start position for next motion after a fixture offset transformation is applied.
  # - See PB_CMD_vnc__G_misc_code.
  #
   if [info exists mom_sim_nc_register(FIXTURE_OFFSET)] {

      if { ![catch {set ref_pt [PB_SIM_call SIM_ask_last_position_zcs]} ] } {
         global mom_sim_prev_pos
         set mom_sim_prev_pos(0) [lindex $ref_pt 0]
         set mom_sim_prev_pos(1) [lindex $ref_pt 1]
         set mom_sim_prev_pos(2) [lindex $ref_pt 2]
      }
   }


  # Ready parameters for polar mode simulation
   PB_SIM_call PB_CMD_vnc__start_polar_motion


  # Create a temp jct for subsequent moves incase the tool is not set properly.
   PB_SIM_call VNC_create_tmp_jct

   switch $mom_sim_nc_register(MOTION) {
      "RAPID" {
         PB_SIM_call VNC_rapid_move
      }

      "LINEAR" {
         PB_SIM_call VNC_linear_move
      }

      "CIRCULAR_CLW" {
         PB_SIM_call VNC_circular_move CLW
      }

      "CIRCULAR_CCLW" {
         PB_SIM_call VNC_circular_move CCLW
      }

      "NURBS" {
         if $mom_sim_nurbs_start {
            PB_SIM_call VNC_nurbs_move
         }
      }
   }


   if [string match "CYCLE_*" $mom_sim_nc_register(MOTION)] {
      PB_SIM_call VNC_cycle_move
   }


  # Restore ZCS base to main after the 1st move
   if [info exists mom_sim_nc_register(FIXTURE_OFFSET)] {

      global mom_sim_zcs_base mom_sim_zcs_base_MCS

      if { [info exists mom_sim_zcs_base_MCS] && ![string match "" [string trim $mom_sim_zcs_base_MCS]] }  {
         set mom_sim_zcs_base $mom_sim_zcs_base_MCS
         PB_CMD_vnc__set_kinematics
      }

      unset mom_sim_nc_register(FIXTURE_OFFSET)
   }


   PB_SIM_call PB_CMD_vnc__end_polar_motion
}


#=============================================================
proc PB_CMD_vnc__start_of_path { } {
#=============================================================

  # Pass contact contour information.
   PB_SIM_call PB_CMD_vnc__pass_contact_contour_data

  # Redefine MOM_helix_move & pass info to VNC.
   if { [llength [info commands "MOM_SYS_helix_move"]] == 0 } {
      if [llength [info commands "MOM_helix_move"]] {
         rename MOM_helix_move MOM_SYS_helix_move

         uplevel #0 {

            proc MOM_helix_move {} {
               PB_SIM_call PB_CMD_vnc__pass_helix_pitch
               MOM_SYS_helix_move
            }
         }

        # Fetch global pitch info
         PB_SIM_call PB_CMD_vnc__pass_helix_data
      }
   }


  # Redefine MOM_nurbs_move & pass info to VNC.
   if { [llength [info commands "MOM_SYS_nurbs_move"]] == 0 } {
      if [llength [info commands "MOM_nurbs_move"]] {

         rename MOM_nurbs_move MOM_SYS_nurbs_move

         uplevel #0 {

            proc MOM_nurbs_move {} {

               PB_SIM_call PB_CMD_vnc__pass_nurbs_start

               MOM_SYS_nurbs_move

               PB_SIM_call PB_CMD_vnc__pass_nurbs_data
            }
         }
      }
   }


  # Set machining mode
   global mom_sim_vnc_msg_only
   global mom_sim_nc_register
   if { ![info exists mom_sim_vnc_msg_only] || !$mom_sim_vnc_msg_only } {
      PB_SIM_call SIM_set_machining_mode $mom_sim_nc_register(MACHINE_MODE)
   }


  # Pass tool carrier data
   PB_SIM_call PB_CMD_vnc__pass_tool_carrier_data


  # For multi-channel simulation from Sync Manager, assign channel to a lathe spindle currently under control.
   global mom_multi_channel_mode mom_sim_tool_carrier_id
   if { [info exists mom_multi_channel_mode] && [info exists mom_sim_tool_carrier_id] } {

      global mom_sim_spindle_group
      if [info exists mom_sim_spindle_group] {
         PB_SIM_call SIM_assign_channel_to_spindle $mom_sim_tool_carrier_id $mom_sim_spindle_group
      }
   }
}


#=============================================================
proc PB_CMD_vnc__start_of_program { } {
#=============================================================
   global mom_multi_channel_mode


  # This command is only executed during simulation
  # Extended NC output should be disabled.
   global mom_sim_output_extended_nc
   if [info exists mom_sim_output_extended_nc] {
      unset mom_sim_output_extended_nc
   }


   if [info exists mom_multi_channel_mode] {

     # Fetch total number of channels
      global mom_sim_number_of_channels
      global mom_sim_result

      set mom_sim_number_of_channels 0
      set mom_sim_result 0

      PB_SIM_call SIM_ask_number_of_channels

      if { $mom_sim_result > 0 } {
         set mom_sim_number_of_channels $mom_sim_result
      } else {
         global mom_sim_turret_carriers
         if [info exists mom_sim_turret_carriers] {
           # This will work only if carriers have been named with integers!
            set mom_sim_number_of_channels [lindex [lsort -integer $mom_sim_turret_carriers] end]
         } else {
            set msg "Variable \"mom_sim_turret_carriers\" is not defined to construct channels dialog!"
            VNC_pause $msg
            catch { SIM_mtd_reset }
return EXIT
         }
      }


     # Set up sync manager dialog
      PB_SIM_call PB_CMD_vnc__config_sync_dialog


     # Initialize parameters for Sync Manager
      if [llength [info commands "PB_CMD_vnc__init_sync_manager"]] {
         PB_SIM_call PB_CMD_vnc__init_sync_manager
      } else {
         PB_SIM_call PB_CMD_vnc____init_sync_manager
      }

     # Flag sync manager initialized.
      global mom_sim_sync_manager_initialized
      set mom_sim_sync_manager_initialized 1

   } else {

     # Customize regular ISV dialog
      PB_SIM_call PB_CMD_vnc__customize_dialog
   }


  # Mount part on sub-spindle
   PB_SIM_call PB_CMD_vnc__mount_part


  # Add workpiece transfer handlers
   PB_SIM_call PB_CMD_vnc__add_workpiece_transfer_handlers
}


#=============================================================
proc PB_CMD_vnc__start_polar_motion { } {
#=============================================================
# This function alters motion's sim positions for polar simulation.
# Polar mode should have been initiated when certain N/C code
# has been encounterred.
#

   global mom_sim_polar_mode

   if { [info exists mom_sim_polar_mode] && $mom_sim_polar_mode > 0 } {

     # Always turn it on here, incase it's off
      PB_SIM_call SIM_set_linearization ON

      if { $mom_sim_polar_mode == 2 } {

         PB_SIM_call PB_CMD_vnc__linearize_polar_motion

       return
      }


      global mom_sim_pos
      global mom_sim_prev_pos

      global mom_sim_lg_axis
      global mom_sim_nc_register

     # If needed, make Z move first
      if { ![EQ_is_equal $mom_sim_pos(2) $mom_sim_prev_pos(2)] } {
        # PB_SIM_call VNC_move_linear_zcs CUT  $mom_sim_lg_axis(Z) $mom_sim_pos(2)
        # set mom_sim_nc_register(LAST_Z) $mom_sim_pos(2)
      }

     # pb601(f) - Do this first to correct polar mode on sub-spindle
      global mom_sim_x_factor
      if { $mom_sim_x_factor == -1 } {
         set mom_sim_pos(0) [expr $mom_sim_pos(0)*$mom_sim_x_factor]
         set mom_sim_pos(1) [expr $mom_sim_pos(1)*$mom_sim_x_factor]
         set mom_sim_pos(5) [expr $mom_sim_pos(5)*$mom_sim_x_factor]
         set mom_sim_pos(6) [expr $mom_sim_pos(6)*$mom_sim_x_factor]
      }

     # Re-compute X/Y & I/J to compensate initial angle
      global RAD2DEG
      global mom_sim_init_polar_c_angle mom_sim_num_machine_axes

      if { [info exists mom_sim_init_polar_c_angle] && ![EQ_is_zero $mom_sim_init_polar_c_angle] } {

         set c_axis [expr $mom_sim_num_machine_axes - 1]

        # Adjust X/Y
         set R     [expr sqrt( pow($mom_sim_pos($c_axis),2) + pow($mom_sim_pos(0),2) )]
         set THETA [expr atan2( $mom_sim_pos($c_axis), $mom_sim_pos(0) ) + $mom_sim_init_polar_c_angle/$RAD2DEG]
         set mom_sim_pos(0)       [expr $R * cos($THETA)]
         set mom_sim_pos($c_axis) [expr $R * sin($THETA)]

        # Adjust I/J (arc center vector)
         set R     [expr sqrt( pow($mom_sim_pos(6),2) + pow($mom_sim_pos(5),2) )]
         set THETA [expr atan2( $mom_sim_pos(6), $mom_sim_pos(5) ) + $mom_sim_init_polar_c_angle/$RAD2DEG]
         set mom_sim_pos(5) [expr $R * cos($THETA)]
         set mom_sim_pos(6) [expr $R * sin($THETA)]
      }


      global mom_sim_mt_axis
      global mom_sim_polar_output_format


      if { [info exists mom_sim_mt_axis(5)] } {

         PB_SIM_call SIM_set_rotary_axes_config  [concat $mom_sim_mt_axis(5)]

        # C is Y
         if { ![info exists mom_sim_polar_output_format] || [string match "XCZ" $mom_sim_polar_output_format] } {

            set mom_sim_pos(1) $mom_sim_pos(4)

           # Fall back to previous angle
            set mom_sim_pos(4) $mom_sim_prev_pos(4)
         }

      } elseif { [info exists mom_sim_mt_axis(4)] } {

         PB_SIM_call SIM_set_rotary_axes_config  [concat $mom_sim_mt_axis(4)]

        # C is Y
         if { ![info exists mom_sim_polar_output_format] || [string match "XCZ" $mom_sim_polar_output_format] } {

            set mom_sim_pos(1) $mom_sim_pos(3)

           # Fall back to previous angle
            set mom_sim_pos(3) $mom_sim_prev_pos(3)
         }
      }

      PB_SIM_call SIM_set_machining_mode MILL_CX
   }
}


#=============================================================
proc PB_CMD_vnc__tool_change { } {
#=============================================================
  global sim_prev_tool_name
  global mom_sim_result mom_sim_result1
  global mom_sim_ug_tool_name
  global mom_sim_tool_loaded
  global mom_sim_spindle_comp mom_sim_spindle_jct
  global mom_sim_lg_axis
  global mom_sim_nc_register
  global mom_sim_machine_type
  global mom_sim_tool_offset_used mom_sim_tool_offset mom_sim_tool_mount
  global mom_sim_output_reference_method
  global mom_sim_tool_junction mom_sim_current_junction
  global mom_sim_pivot_distance
  global mom_sim_tool_change

  global mom_sim_prev_tool_carrier_id

  global mom_sim_pos mom_sim_prev_pos


  # Fetch UG tool name per tool number
   global mom_sim_address
   global mom_sim_tool_data
   global mom_sim_tool_number

   set tool_number ""
   if { [info exists mom_sim_tool_number] } {
      set tool_number $mom_sim_tool_number
   } elseif { [info exists mom_sim_nc_register($mom_sim_address(T,leader))] } {
      set tool_number $mom_sim_nc_register($mom_sim_address(T,leader))
   }

   if { [string length $tool_number] > 0  &&  [info exists mom_sim_tool_data($tool_number,name)] } {
      set mom_sim_ug_tool_name $mom_sim_tool_data($tool_number,name)
   } else {
      set mom_sim_tool_change 0
return
   }


   if { [string match "$sim_prev_tool_name" $mom_sim_ug_tool_name] } {
      set mom_sim_tool_change 0
return
   }


  # Allow users to use specified tool change position.
   if { [llength [info commands "PB_CMD_vnc____go_to_tool_change_position"]] } {

      PB_SIM_call PB_CMD_vnc____go_to_tool_change_position

   } elseif { [llength [info commands "PB_CMD_vnc__go_to_tool_change_position"]] } {
     # Legacy
      PB_SIM_call PB_CMD_vnc__go_to_tool_change_position

   } else {

     # By default, turret does not return to ref pt for tool change
      global mom_sim_tool_carrier_id
      global mom_sim_turret_carriers
      global mom_sim_tool_pocket_id

      set done_position 0


      if { [info exists mom_sim_tool_carrier_id] && [info exists mom_sim_turret_carriers] } {

        # pb601(h)
         global mom_sim_comp_class
         if { [info exists mom_sim_comp_class(_CARRIER,$mom_sim_ug_tool_name)] } {

            set mom_sim_tool_carrier_id $mom_sim_comp_class(_CARRIER,$mom_sim_ug_tool_name)

            set mom_sim_tool_data($tool_number,carrier_id) "\"$mom_sim_tool_carrier_id\""

            global mom_sim_spindle_group
            if { [info exists mom_sim_spindle_group] } {
               PB_SIM_call SIM_assign_channel_to_spindle $mom_sim_tool_carrier_id $mom_sim_spindle_group
            }

            PB_SIM_call PB_CMD_vnc__set_speed
         }


        # Not sure this is always true for all machines!!!
         if { [lsearch $mom_sim_turret_carriers $mom_sim_tool_carrier_id] >= 0 } {

           # pb601(h)
            if { ![catch { SIM_ask_base_device_holder_of_comp $mom_sim_ug_tool_name }] } {
               set mom_sim_tool_pocket_id "$mom_sim_result1"
               set mom_sim_tool_data($tool_number,pocket_id) "\"$mom_sim_tool_pocket_id\""
            }

            set mom_sim_nc_register(REF_INT_PT_X) -939
            set mom_sim_nc_register(REF_INT_PT_Y) -939

            VNC_unset_vars  mom_sim_nc_register(REF_INT_PT_Z)

           # Position spindle to reference point.
            PB_SIM_call PB_CMD_vnc__send_dogs_home

           # Unset temporary intermediate reference point
            VNC_unset_vars  mom_sim_nc_register(REF_INT_PT_X) mom_sim_nc_register(REF_INT_PT_Y)

            set done_position 1
         }
      }

      if { $done_position == 0 } {
        # Fake a temporary intermediate reference point to send all dogs home
         set mom_sim_nc_register(REF_INT_PT_X) -939
         set mom_sim_nc_register(REF_INT_PT_Y) -939
         set mom_sim_nc_register(REF_INT_PT_Z) -939

        # Position spindle to reference point.
         PB_SIM_call PB_CMD_vnc__send_dogs_home

        # Unset temporary intermediate reference point
         VNC_unset_vars  mom_sim_nc_register(REF_INT_PT_X) mom_sim_nc_register(REF_INT_PT_Y) mom_sim_nc_register(REF_INT_PT_Z)
      }
   }


   set sim_tool_name ""


#>>>>>
#  This is where you add detailed movements such as rotating tool changer,
#  unmounting old tool and mounting new tool and/or getting next tool in ready position.
#<<<<<

  # User provided tool change sequence
   if { [llength [info commands "PB_CMD_vnc__user_tool_change"]] } {

      set sim_tool_name [PB_SIM_call PB_CMD_vnc__user_tool_change]

   } elseif { [llength [info commands "PB_CMD_vnc____tool_change"]] } {

      set sim_tool_name [PB_SIM_call PB_CMD_vnc____tool_change]

   } else {

      global mom_sim_tool_carrier_id
      global mom_sim_turret_carriers
      global mom_sim_turret_axis
      global mom_sim_tool_pocket_id


      set done_tool_change 0

      set tool_change_time 5


      set mom_sim_result ""

     # Rotate turret to index lathe tool
      if { [info exists mom_sim_tool_carrier_id] && [info exists mom_sim_tool_pocket_id] && [info exists mom_sim_turret_carriers] } {

         if { [lsearch $mom_sim_turret_carriers $mom_sim_tool_carrier_id] >= 0 } {

           # Handle mixed use of tools on a turret and stationary tools.
            if { ![catch { PB_SIM_call SIM_ask_kim_comp_name_by_id "TOOL" $mom_sim_ug_tool_name }] } {
               set done_tool_change 1
            }

            if { $done_tool_change } {

               global mom_sim_pocket_angle

              # Handle holder angle with operation
               set cutter_holder_angle_delta 0.0
               set cutter_holder_angle_delta [PB_SIM_call PB_CMD_vnc__compute_tool_holder_angle_delta]

              # Actual turret rotation angle = rot angle based on pocket ID + tool holder delta
               global mom_sim_turret_data
               global mom_sim_add_turret_angle

               set pocket_id $mom_sim_tool_pocket_id

               if { [info exists mom_sim_turret_data($mom_sim_tool_carrier_id,pockets_num)] } {
                  set pockets_num $mom_sim_turret_data($mom_sim_tool_carrier_id,pockets_num)
                  set pocket_id [expr int(fmod($pocket_id,$pockets_num))]

                 #<03-30-07 gsl> pb501 - Correct error
                  if { !$pocket_id } {
                     set pocket_id $pockets_num
                  }
               }
               set turret_rotation_angle [expr $cutter_holder_angle_delta + $mom_sim_add_turret_angle + $mom_sim_pocket_angle($mom_sim_tool_carrier_id,$pocket_id)]

              # - Reduce turret rotation
               set turret_rotation_angle [expr fmod($turret_rotation_angle,360)]
               if { [expr $turret_rotation_angle > 180] } { ;# May need to compare with previous angle
                  set turret_rotation_angle [expr $turret_rotation_angle - 360]
               }

               set __sim_result $mom_sim_result

               SIM_ask_axis_position $mom_sim_turret_axis($mom_sim_tool_carrier_id)
               set __prev_angle $mom_sim_result
               if { [expr ($turret_rotation_angle - $__prev_angle) > 180] } {
                  set turret_rotation_angle [expr $turret_rotation_angle - 360]
               } elseif { [expr ($turret_rotation_angle - $__prev_angle) < -180] } {
                  set turret_rotation_angle [expr $turret_rotation_angle + 360]
               }

               set mom_sim_result $__sim_result

               PB_SIM_call SIM_move_rotary_axis $tool_change_time $mom_sim_turret_axis($mom_sim_tool_carrier_id) $turret_rotation_angle
            }
         }
      }


     # Change tool for mills
      if { $done_tool_change == 0 } {

        # pb502(13) -
        # Always unmount fly tool


        # pb602(q) - Rotate B-head to tool change angle (set in PB_CMD_vnc____map_machine_tool_axes)
         global mom_sim_mt_axis
         if { [info exists mom_sim_mt_axis(4)] } {

            global mom_sim_tool_change_angle

            if { ![info exists mom_sim_tool_change_angle] } {
               set mom_sim_tool_change_angle 0
            }

            set mom_sim_pos(3) $mom_sim_tool_change_angle

            PB_SIM_call SIM_move_rotary_axis 5 $mom_sim_mt_axis(4) $mom_sim_pos(3)
            PB_SIM_call SIM_update
         }


        # pb602(c) - Add condition to accommodate flash tool handling
        # Restore spindle axis to ready orientation
         global mom_sim_flash_tool
         if { ![info exists mom_sim_flash_tool] } {
            set mom_sim_flash_tool 0
         }

         PB_SIM_call VNC_rotate_head_spindle_axis 0

        # pb602(p) - To avoid unmounting previous tool from turret
         if { [string length $sim_prev_tool_name] > 0 } {
            if {![info exists mom_sim_prev_tool_carrier_id] || ![info exists mom_sim_turret_carriers] || [lsearch $mom_sim_turret_carriers $mom_sim_prev_tool_carrier_id] < 0 } {

               PB_SIM_call VNC_unmount_tool $sim_prev_tool_name
            }
         }


         PB_SIM_call VNC_set_ref_jct {""}
         PB_SIM_call SIM_mount_tool $tool_change_time "UG_NAME" "$mom_sim_ug_tool_name" "$mom_sim_spindle_comp" "$mom_sim_spindle_jct"

        # pb602(c) - Accommodate flash tool handling
        # Flash spindle axis if required
         if { $mom_sim_flash_tool } {
            PB_SIM_call VNC_rotate_head_spindle_axis 180
         }


        # By default, this variable is NOT set to indicate that tool length
        # compensation is done immediately @ tool change, otherwise it's set
        # in ____map command to cause compensation to be done @ length comp
        # (G43) function.

         global mom_sim_tool_length_comp_auto

         if { [info exists mom_sim_tool_length_comp_auto] && $mom_sim_tool_length_comp_auto == 0 } {
            set mom_sim_nc_register(TOOL_CHANGED) 1
         }
      }

     # Fetch tool comp ID
      set sim_tool_name $mom_sim_result
   }


   PB_SIM_call SIM_update

  # pb602(p) - Save mom_sim_tool_carrier_id
   if { [info exists mom_sim_tool_carrier_id] } {
      set mom_sim_prev_tool_carrier_id $mom_sim_tool_carrier_id
   }

   if { [string length $sim_tool_name] > 0 } {
      PB_SIM_call SIM_activate_tool $sim_tool_name
   } else {
return
   }


   PB_SIM_call SIM_update


   set sim_prev_tool_name $mom_sim_ug_tool_name
   set mom_sim_tool_loaded $sim_tool_name


  # Flag that a tool change is done.
   set mom_sim_tool_change 0


   PB_SIM_call VNC_set_ref_jct $sim_tool_name

   set mom_sim_tool_junction "$mom_sim_current_junction"


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Create a junction per tool offsets to track N/C data.
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++
   set use_tool_tip_jct 1

   if { $mom_sim_tool_data($tool_number,offset_used) || [expr $mom_sim_pivot_distance != 0.0] } {

      if { ![string match "*_wedm" $mom_sim_machine_type] } {
         if { [string match "*axis*" $mom_sim_machine_type] } {
            set use_tool_tip_jct 0
            set x_offset [expr -1.0 * ($mom_sim_tool_data($tool_number,z_off) + $mom_sim_pivot_distance)]
            set y_offset 0.0
            set z_offset 0.0

         } elseif { [string match "*lathe*" $mom_sim_machine_type] } {
            if { [string match "TURRET_REF" $mom_sim_output_reference_method] } {
               set use_tool_tip_jct 0
               set x_offset $mom_sim_tool_data($tool_number,x_off)
               set y_offset $mom_sim_tool_data($tool_number,y_off)
               set z_offset 0.0
            }
         }
      }
   }


  #<911-2008 gsl> pb602 - This looks like a MUST fix !!!!!
   global mom_sim_curr_jct_matrix mom_sim_curr_jct_origin
   global mom_sim_result mom_sim_result1

   PB_SIM_call SIM_ask_init_junction_xform $mom_sim_tool_junction
   set mom_sim_curr_jct_matrix "$mom_sim_result"
   set mom_sim_curr_jct_origin "$mom_sim_result1"


   if { !$use_tool_tip_jct } {
      global mom_sim_tool_x_offset mom_sim_tool_y_offset mom_sim_tool_z_offset

      set mom_sim_tool_x_offset $x_offset
      set mom_sim_tool_y_offset $y_offset
      set mom_sim_tool_z_offset $z_offset

      PB_SIM_call PB_CMD_vnc__offset_tool_jct
   }


   if { [string match "TURN" $mom_sim_nc_register(MACHINE_MODE)] } {
      set mom_sim_pos(1) 0
   }

  # Reset mom_sim_prev_pos to disable unnecessary move
   for { set i 0 } { $i < 5 } { incr i } {
      set mom_sim_prev_pos($i) $mom_sim_pos($i)
   }


  # pb602 - Current tool jct should always be preserved!
   global mom_sim_current_tool_junction
   set mom_sim_current_tool_junction "$mom_sim_tool_junction"


  # Track @ pivot pt for the initial move
  # - Require a good pivot jct!
  #
   if { [info exists mom_sim_nc_register(TOOL_CHANGED)] } {
      global mom_sim_spindle_jct mom_sim_pivot_jct

      if { [info exists mom_sim_pivot_jct] } {
         PB_SIM_call VNC_set_current_ref_junction $mom_sim_pivot_jct
      } else {
         PB_SIM_call VNC_set_current_ref_junction $mom_sim_spindle_jct
      }

     # To prevent ref jct being reset to tool tip in sim_motion
      set mom_sim_tool_junction "$mom_sim_current_junction"
   }
}


#=============================================================
proc PB_CMD_vnc__unset_Y_axis { } {
#=============================================================
#  This command is called in PB_CMD_vnc__init_sim_vars
#  to unset the variable mom_sim_mt_axis(Y) for a lathe
#  that does not have a physical Y-axis defined in the model.
#
  global mom_sim_mt_axis
  global mom_sim_result1


   set re_config 0

   PB_SIM_call SIM_ask_nc_axes_of_mtool

   if [info exists mom_sim_mt_axis(Y)] {
      if { [lsearch $mom_sim_result1 $mom_sim_mt_axis(Y)] < 0 } {
         unset mom_sim_mt_axis(Y)
         set re_config 1
      }
   }


   if $re_config {

      set axes_config_list [list]

      if [info exists mom_sim_mt_axis(X)] {
         if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(X)"] >= 0 } {
            lappend axes_config_list $mom_sim_mt_axis(X)
         }
      }

      if [info exists mom_sim_mt_axis(Z)] {
         if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Z)"] >= 0 } {
            lappend axes_config_list $mom_sim_mt_axis(Z)
         }
      }

      PB_SIM_call SIM_set_linear_axes_config [concat $axes_config_list]
   }
}


#=============================================================
proc PB_CMD_vnc__validate_machine_tool { } {
#=============================================================
# This command is called in PB_CMD_vnc__init_sim_vars
# to validate the machine tool kinematics assignments.
#
  global mom_sim_result mom_sim_result1
  global mom_sim_mt_axis
  global mom_sim_zcs_base_MCS
  global mom_sim_zcs_base_LCS
  global mom_sim_spindle_comp
  global mom_sim_spindle_jct
  global mom_sim_pivot_jct
  global mom_sim_advanced_kinematic_jct


   set __msg ""

  # Validate machine axes
  #
   PB_SIM_call SIM_ask_nc_axes_of_mtool

   set axes_list { mom_sim_mt_axis(X) mom_sim_mt_axis(Y) mom_sim_mt_axis(Z) mom_sim_mt_axis(4) mom_sim_mt_axis(5) }

   foreach axis $axes_list {
      if [info exists $axis] {
         set val [eval format $[set axis]]
         if { [lsearch $mom_sim_result1 $val] < 0 } {
            set __msg "$__msg\n Machine axis \"$val\" for $axis is not defined in the model."
         }
      }
   }


  # Fetch machine base component
  #
   set mom_sim_result ""

   set machine_base MACHINE_BASE
   PB_SIM_call SIM_ask_machine_base_component
   if { ![string match "" $mom_sim_result] } {
      set machine_base $mom_sim_result
   }


  # Validate KIM components
  #
   set comps_list { mom_sim_zcs_base_MCS mom_sim_zcs_base_LCS mom_sim_spindle_comp }

   foreach comp $comps_list {
      if [info exists $comp] {
         set val [eval format $[set comp]]
         if { ![string match "$machine_base" $val] && ![string match "" $val] } {
            set mom_sim_result 0
            PB_SIM_call SIM_find_comp_by_name $machine_base $val
            if { $mom_sim_result == 0 } {
               set __msg "$__msg\n Component \"$val\" for $comp is not found in the model."
            }
         }
      }
   }


  # Validate junctions
  #
   set jcts_list { mom_sim_spindle_jct mom_sim_pivot_jct mom_sim_advanced_kinematic_jct }

   foreach jct $jcts_list {
      if [info exists $jct] {
         set val [eval format $[set jct]]

         if { ![string match "" [string trim $val]] } {
            if { ![string match "*@*" $val] } {
               set val_jct "$mom_sim_spindle_comp@$val"
            } else {
               set val_jct "$val"
            }
            set mom_sim_result 0
            PB_SIM_call SIM_ask_is_junction_exist $val_jct
            if { $mom_sim_result == 0 } {
               set __msg "$__msg\n Junction \"$val_jct\" for $jct does not exist in the model."
            }
         }
      }
   }


  #--------------------------------
  # Invalid set up found! Bail out!
  #--------------------------------
   if { ![string match "" $__msg] } {
      global mom_sim_vnc_handler_loaded

      VNC_pause "[VNC_trace]\nVNC : $mom_sim_vnc_handler_loaded ...\n\n$__msg"

      PB_SIM_call SIM_mtd_reset
      MOM_abort "***  Abort ISV due to error in machine tool kinematics.  ***"
   }
}




global mom_sim_program_has_started

if { ![info exists mom_sim_program_has_started] } {
   if { [info exists mom_sim_post_builder_rev_post] && $mom_sim_post_builder_rev_post } {

      set mom_sim_program_has_started 1

      if { ![info exists mom_part_unit] } {
         set mom_part_unit IN
      }

      # In case initialization fails...
      if { [PB_VNC_start_of_program] == "EXIT" } {
           global mom_sim_delay_one_block
           set mom_sim_delay_one_block 0

           PB_VNC_end_of_program

           set sim_mtd_initialized 0

           MOM_abort "ISV aborted!"
      }
   }
}




