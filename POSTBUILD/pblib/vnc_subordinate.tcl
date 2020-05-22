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
proc VNC_set_nc_definitions {} {
#=============================================================
}


#=============================================================
proc PB_CMD_vnc____map_machine_tool_axes { } {
#=============================================================
  global mom_sim_address
  global mom_sim_num_machine_axes
  global mom_sim_mt_axis
  global mom_sim_result mom_sim_result1
  global mom_sim_zcs_base
  global mom_sim_spindle_comp mom_sim_spindle_jct
  global mom_sim_reverse_4th_table mom_sim_reverse_5th_table
  global mom_sim_machine_head


  ############################################################
  #
  # Configure parameters set between ##>>>>> & ##<<<<<.
  #
  ############################################################

##>>>>>
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # When desired, override the default number of machine axes
  # to change the number of controllable axes. The additional
  # axes will need to be modeled accordingly in the Machine
  # Tool model. By default, this parameter is set per post.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # set mom_sim_num_machine_axes 5

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Fetch the names of axes from the Machine Tool model. 
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   set mom_sim_mt_axis(X) X
   set mom_sim_mt_axis(Y) Y
   set mom_sim_mt_axis(Z) Z

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Uncomment next line to unset the variable, when
  # Y axis is not defined in a machine tool model (lathe).
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # unset mom_sim_mt_axis(Y)

   switch $mom_sim_num_machine_axes {
      "4" {
         set mom_sim_mt_axis(4) A
      }
      "5" {
         set mom_sim_mt_axis(4) B
         set mom_sim_mt_axis(5) C
      }
   }

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Specify a component as the ZCS reference base. Normally,
  # it should be a non-rotating component that the part is
  # directly or indirectly connected to in kinematics tree.
  #
  #   mom_sim_zcs_base_MCS : Main Coordinate System
  #   mom_sim_zcs_base_LCS : Local Coordinate System
  #
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_sim_zcs_base_MCS mom_sim_zcs_base_LCS

   set mom_sim_zcs_base_MCS  "X_SLIDE"
   set mom_sim_zcs_base_LCS  ""

   set mom_sim_zcs_base $mom_sim_zcs_base_MCS


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Specify the reference point tracking junction &
  #         the owner component of this junction :
  #
  #   Mill - Tool mounting junction & spindle component
  #   Turn - Turret rotating junction & its owner component
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   set mom_sim_spindle_jct  "TOOL_MOUNT_JCT"
   set mom_sim_spindle_comp "SPINDLE"


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Define the pivot junction for a machine with rotary heads.
  # It's default to the spindle junction.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_sim_pivot_jct

   set mom_sim_pivot_jct "$mom_sim_spindle_jct"
  # set mom_sim_pivot_jct "X_SLIDE@B_ROT_JCT"


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Reverse axis of rotation for 4th and/or 5th rotary table,
  # if they are not set accordingly in the machine tool model.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   if { $mom_sim_num_machine_axes > 3 } {
      set mom_sim_reverse_4th_table  0
      set mom_sim_reverse_5th_table  0
   }

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # If necessary, define a junction for advanced kinematics
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  global mom_sim_advanced_kinematic_jct
  # set mom_sim_advanced_kinematic_jct "ROT_JCT"

##<<<<<



  #------------------------------------------------
  # Validity check for all the parameters set here.
  #------------------------------------------------
   if [llength [info commands "PB_CMD_vnc__validate_machine_tool"]] {
      PB_CMD_vnc__validate_machine_tool
   }


  # For this machine that all physical axes participate in executing a motion. 
  # Include all logical names for axes.

   SIM_ask_nc_axes_of_mtool

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


   SIM_set_linear_axes_config [concat $axes_config_list]


   switch $mom_sim_num_machine_axes {
      "4" {
         SIM_set_rotary_axes_config  [concat $mom_sim_mt_axis(4)]
      }
      "5" {
         SIM_set_rotary_axes_config  [concat $mom_sim_mt_axis(4) $mom_sim_mt_axis(5)]
      }
   }
}


#=============================================================
proc PB_CMD_vnc__set_nc_definitions { } {
#=============================================================
   PB_CMD_vnc____set_nc_definitions

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Append more codes to be processed for a subordinate VNC.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_sim_other_nc_codes

   # lappend mom_sim_other_nc_codes G68.1 G69
}


#=============================================================
proc PB_CMD_vnc__sim_other_devices { } {
#=============================================================
   PB_CMD_vnc____sim_other_devices

  #++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Simulate more devices specific for a subordinate VNC.
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_sim_nc_address

   switch $mom_sim_nc_address {
      G68.1 {
      }

      G69 {
      }
   }
}




