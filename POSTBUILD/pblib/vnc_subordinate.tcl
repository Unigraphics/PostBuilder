##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################
#                       V N C _ S U B O R D I N A T E . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains common handlers for Subordinate VNCs'.
#
##############################################################################



catch [source "[MOM_ask_env_var UGII_CAM_POST_DIR]vnc_common.tcl"]



#=============================================================
proc VNC_load_post_definitions {} {
#=============================================================
}


if { [llength [info commands PB_CMD_vnc____map_machine_tool_axes]] == 0 } {
#
# Dummy for initialization of a new subordinate VNC
#=============================================================
proc PB_CMD_vnc____map_machine_tool_axes { } {
#=============================================================
}
}


if { [llength [info commands PB_CMD_vnc____config_machine_tool_axes]] == 0 } {
#
# Define what's not configured via UI for machine tool
#=============================================================
proc PB_CMD_vnc____config_machine_tool_axes { } {
#=============================================================
# - Do not change the name of this command!
#
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Specify kinematic components to be used as the ZCS
  # reference base :
  #
  #
  #   mom_sim_zcs_base_MCS - Main Coordinate System
  #   mom_sim_zcs_base_LCS - Local Coordinate System
  #
  #
  # mom_sim_zcs_base_MSC, normally, is a non-rotating
  # component that the part (work piece) is directly or
  # indirectly connected to in the kinematics tree.
  # If no local coordinate system programming (i.e. G68.1) is
  # used, only the mom_sim_zcs_base_MSC needs to be specified.
  #
  # mom_sim_zcs_base_LCS is to be specified, when needed,
  # with the component that rotates to form the local
  # coordinate system. It's default to "".
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_sim_zcs_base_MCS mom_sim_zcs_base_LCS

  # set mom_sim_zcs_base_LCS  "$mom_sim_zcs_base_MCS"
  # set mom_sim_zcs_base_LCS  ""


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Additional angle to rotate turret when tools are indexed
  # for sub-spindle.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_sim_add_turret_angle

  # set mom_sim_add_turret_angle 0.0


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Define the pivot junction for a machine with rotary heads.
  # It's default to the spindle junction.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_sim_pivot_jct

  # set mom_sim_pivot_jct "$mom_sim_spindle_jct"
  # set mom_sim_pivot_jct "X_SLIDE@B_ROT_JCT"


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Set this variable to disable the automatic tool length
  # compensation @ tool change until a G43 (or equivalent)
  # function is encountered.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_sim_tool_length_comp_auto

  # set mom_sim_tool_length_comp_auto 0


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Customize this VNC to handle more degrees of kinematics
  # than what the post is composed for.
  # - This is useful for programming a lathe on a mill-turn machine.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_sim_num_machine_axes
   global mom_sim_mt_axis
   global mom_sim_reverse_4th_table mom_sim_4th_axis_has_limits
   global mom_sim_reverse_5th_table mom_sim_5th_axis_has_limits

  if 0 {
   set mom_sim_num_machine_axes  4

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
  }
}
} ;# if


if { [llength [info commands PB_CMD_vnc__config_nc_definitions]] == 0 } {
#
#=============================================================
proc PB_CMD_vnc__config_nc_definitions { } {
#=============================================================
   PB_SIM_call PB_CMD_vnc____set_nc_definitions

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Define more codes to be processed for a subordinate VNC.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_sim_other_nc_codes
   global mom_sim_other_nc_codes_ex

  # lappend mom_sim_other_nc_codes     T M245
  # lappend mom_sim_other_nc_codes_ex  T
}
} ;# if


if { [llength [info commands PB_CMD_vnc__set_nc_definitions]] == 0 } {
#
# This handler is PB generated; it requires a dummy here to initialize a new subordinate VNC.
#
#=============================================================
proc PB_CMD_vnc__set_nc_definitions { } {
#=============================================================

   if { [llength [info commands PB_CMD_vnc__config_nc_definitions]] } {
     # Process legacy definitions
      PB_SIM_call PB_CMD_vnc__config_nc_definitions
   } else {
     # Inherit definitions from main VNC
      PB_SIM_call PB_CMD_vnc____set_nc_definitions
   }
}
}


# Install this command only when absent.
#
if { [llength [info commands "PB_CMD_vnc__process_nc_block"]] == 0 } {
#
# This handler is PB generated; it requires a dummy here to initialize a new subordinate VNC.
#=============================================================
proc PB_CMD_vnc__process_nc_block { } {
#=============================================================
}
}


if { [llength [info commands PB_CMD_vnc__sim_other_devices]] == 0 } {
#
#=============================================================
proc PB_CMD_vnc__sim_other_devices { } {
#=============================================================
   global mom_sim_o_buffer
   global mom_sim_simulate_block


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Simulate devices specific for a subordinate VNC first.
  # Codes are specified in PB_CMD_vnc__set_nc_definitions.
  # -- This overrides Master VNC's handlers.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++


  # Simulate other devices defined with the Master VNC
  #
   PB_SIM_call PB_CMD_vnc____sim_other_devices
}
}





