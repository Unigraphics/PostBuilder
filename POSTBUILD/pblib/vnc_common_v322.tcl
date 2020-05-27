##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################
#                       V N C _ C O M M O N _V 3 2 2 . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains handlers for incremental conversion from v321 to v322.
#
##############################################################################
#@<DEL>@ TEXT ENCLOSED WITHIN DELETE MARKERS WILL BE REMOVED UPON RELEASE.
##############################################################################
# Description
#   This file contains base event handlers for IS&V Virtual NC Controller.
#
#
# Revisions
# ---------
# Date     Who     Reason
# 21Jun04  genLin  Inception
##############################################################################
# TEXT ENCLOSED WITHIN DELETE MARKERS WILL BE REMOVED UPON RELEASE. @<DEL>@


#=============================================================
# This function is called @ start of ISV to relocate a part
# component to the secondary mounting junction (Ex. chuck face
# of a sub-spindle).
#
proc PB_CMD_vnc__mount_part { } {
#=============================================================
  # Snap part to the sub spindle here.
}


#=============================================================
proc PB_CMD_vnc__end_of_program { } {
#=============================================================
  global mom_sim_csys_set

   set mom_sim_csys_set 0
}


#=============================================================
proc PB_CMD_vnc__unset_Y_axis { } {
#=============================================================
  global mom_sim_mt_axis


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # For a lathe that doesn't have Y-axis defined in the model,
  # uncomment the line below and call this command in the end
  # of command PB_CMD_vnc____map_machine_tool_axes.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # unset mom_sim_mt_axis(Y)


  # Map logical names (addresses) to physical axes (machine tool model). 
   global mom_sim_result1
   SIM_ask_nc_axes_of_mtool

   set axes_map_list [list]
   set axes_config_list [list]

   if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(X)"] >= 0 } {
      lappend axes_map_list $mom_sim_address(X,leader) $mom_sim_mt_axis(X)
      lappend axes_config_list $mom_sim_mt_axis(X)
   }

   if { [info exists mom_sim_mt_axis(Y)] } {
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Y)"] >= 0 } {
         lappend axes_map_list $mom_sim_address(Y,leader) $mom_sim_mt_axis(Y)
         lappend axes_config_list $mom_sim_mt_axis(Y)
      }
   }

   if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Z)"] >= 0 } {
      lappend axes_map_list $mom_sim_address(Z,leader) $mom_sim_mt_axis(Z)
      lappend axes_config_list $mom_sim_mt_axis(Z)
   }

   SIM_set_linear_axes_map    [concat $axes_map_list]
   SIM_set_linear_axes_config [concat $axes_config_list]
}


#=============================================================
proc PB_CMD_vnc__output_param_msg { } {
#=============================================================
  global mom_sim_message

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Use MOM_output_literal below to display the VNC's operator
  # messages in the NC code window (for debug purpose).
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   MOM_output_text $mom_sim_message
  # MOM_output_literal $mom_sim_message
}


#=============================================================
proc PB_CMD_vnc__pass_csys_data { } {
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

      if [string match "MAIN" $mom_kin_coordinate_system_type] {
         for { set i 0 } { $i < 12 } { incr i } {
            set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                                CSYS_MTX_$i==$mom_machine_csys_matrix($i)\
                                $mom_sim_control_in"
            PB_CMD_vnc__output_param_msg
         }
      } else {

         MTX3_multiply mom_machine_csys_matrix mom_csys_matrix matrix

         set matrix(9)  [expr $mom_machine_csys_matrix(9)  + $mom_csys_matrix(9)]
         set matrix(10) [expr $mom_machine_csys_matrix(10) + $mom_csys_matrix(10)]
         set matrix(11) [expr $mom_machine_csys_matrix(11) + $mom_csys_matrix(11)]

         for { set i 0 } { $i < 12 } { incr i } {
            set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                                CSYS_MTX_$i==$matrix($i) $mom_sim_control_in"
            PB_CMD_vnc__output_param_msg
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__pass_msys_data { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_msys_matrix mom_msys_origin
  global mom_sim_message


   for { set i 0 } { $i < 9 } { incr i } {
      set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                          CSYS_MTX_$i==$mom_msys_matrix($i) $mom_sim_control_in"
      PB_CMD_vnc__output_param_msg
   }

   for { set j 0 } { $j < 3 } { incr j } {
      set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                          CSYS_MTX_$i==$mom_msys_origin($j) $mom_sim_control_in"
      incr i
      PB_CMD_vnc__output_param_msg
   }
}


#=============================================================
proc PB_CMD_vnc__pass_head_data { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_sys_postname
  global CURRENT_HEAD
  global mom_sim_message


   set post_name $mom_sys_postname($CURRENT_HEAD)

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       HEAD_NAME==$CURRENT_HEAD $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg
   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       POST_NAME==$post_name $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg
}


#=============================================================
proc PB_CMD_vnc__pass_spindle_data { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_spindle_direction mom_spindle_mode
  global mom_spindle_speed mom_spindle_maximum_rpm
  global mom_sim_message


   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       SPINDLE_DIRECTION==$mom_spindle_direction $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       SPINDLE_MODE==$mom_spindle_mode $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       SPINDLE_SPEED==$mom_spindle_speed $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       SPINDLE_MAX_RPM==$mom_spindle_maximum_rpm $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg
}


#=============================================================
proc PB_CMD_vnc__pass_tool_data { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_tool_name
  global mom_tool_offset_defined mom_tool_offset
  global mom_sim_message


   if { ![info exists mom_tool_offset(0)] } { set mom_tool_offset(0) 0 }
   if { ![info exists mom_tool_offset(1)] } { set mom_tool_offset(1) 0 }
   if { ![info exists mom_tool_offset(2)] } { set mom_tool_offset(2) 0 }

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_NAME==$mom_tool_name $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_OFFSET==$mom_tool_offset_defined $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_X_OFF==$mom_tool_offset(0) $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_Y_OFF==$mom_tool_offset(1) $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_Z_OFF==$mom_tool_offset(2) $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg
}


#=============================================================
proc PB_CMD_vnc__send_dogs_home { } {
#=============================================================
  global mom_sim_mt_axis
  global mom_sim_num_machine_axes
  global mom_sim_nc_register
  global mom_sim_result1


  # Move axes directly.
   SIM_ask_nc_axes_of_mtool

   if { [info exists mom_sim_mt_axis(X)] } {
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(X)"] >= 0 } {
         SIM_move_linear_axis 5 $mom_sim_mt_axis(X) [lindex $mom_sim_nc_register(REF_PT) 0]
      }
   }

   if { [info exists mom_sim_mt_axis(Y)] } {
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Y)"] >= 0 } {
         SIM_move_linear_axis 5 $mom_sim_mt_axis(Y) [lindex $mom_sim_nc_register(REF_PT) 1]
      }
   }

   if { [info exists mom_sim_mt_axis(Z)] } {
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Z)"] >= 0 } {
         SIM_move_linear_axis 5 $mom_sim_mt_axis(Z) [lindex $mom_sim_nc_register(REF_PT) 2]
      }
   }


global mom_sim_message
set mom_sim_message "REF PT >$mom_sim_nc_register(REF_PT)<"
PB_CMD_vnc__send_message


   if [expr $mom_sim_num_machine_axes > 3] {
      SIM_move_rotary_axis 5 $mom_sim_mt_axis(4) 0
   }

   if [expr $mom_sim_num_machine_axes > 4] {
      SIM_move_rotary_axis 5 $mom_sim_mt_axis(5) 0
   }
 
   SIM_update


  # Keep track of current position
   global mom_sim_pos

   if { ![catch {set ref_pt [SIM_ask_last_position_zcs]} ] } {
      set mom_sim_pos(0) [lindex $ref_pt 0]
      set mom_sim_pos(1) [lindex $ref_pt 1]
      set mom_sim_pos(2) [lindex $ref_pt 2]
   }

  # Zero Y for lathe mode
   if [string match "TURN" $mom_sim_nc_register(MACHINE_MODE)] {
      set mom_sim_pos(1) 0
   }

  # Zero all other axes
   set mom_sim_pos(3) 0
   set mom_sim_pos(4) 0
   set mom_sim_pos(5) 0
   set mom_sim_pos(6) 0
   set mom_sim_pos(7) 0
}


#=============================================================
proc PB_CMD_vnc__send_message { } {
#=============================================================
# Comment the "return" statement below to output debug messages in ISV dialog.
return

   global mom_sim_message

   PB_VNC_send_message "$mom_sim_message"
}


#=============================================================
proc PB_CMD_vnc__set_param_per_msg { } {
#=============================================================
  global mom_sim_msg_key mom_sim_msg_word


PB_VNC_output_debug_msg "VNC_MSG - key:$mom_sim_msg_key  word:$mom_sim_msg_word"


   switch $mom_sim_msg_key {

      "SPINDLE_DIRECTION" {
         global mom_sim_spindle_direction
         set mom_sim_spindle_direction "$mom_sim_msg_word"
       }

      "SPINDLE_MODE" {
         global mom_sim_spindle_mode
         switch $mom_sim_msg_word {
            RPM { set mom_sim_msg_word REV_PER_MIN }
         }
         set mom_sim_spindle_mode $mom_sim_msg_word
       }

      "SPINDLE_SPEED" {
         global mom_sim_spindle_speed mom_sim_spindle_mode
         set mom_sim_spindle_speed "$mom_sim_msg_word"

         SIM_set_speed $mom_sim_spindle_speed $mom_sim_spindle_mode
       }

      "SPINDLE_MAX_RPM" {
         global mom_sim_spindle_max_rpm
         set mom_sim_spindle_max_rpm "$mom_sim_msg_word"
       }

      "TOOL_NAME" {
         global mom_sim_ug_tool_name mom_sim_tool_change
         set mom_sim_ug_tool_name "$mom_sim_msg_word"
         set mom_sim_tool_change 1
       }

      "TOOL_OFFSET" {
         global mom_sim_tool_offset_used
         set mom_sim_tool_offset_used "$mom_sim_msg_word"
      }

      "TOOL_X_OFF" {
         global mom_sim_tool_offset
         set mom_sim_tool_offset(0) "$mom_sim_msg_word"
      }

      "TOOL_Y_OFF" {
         global mom_sim_tool_offset
         set mom_sim_tool_offset(1) "$mom_sim_msg_word"
      }

      "TOOL_Z_OFF" {
         global mom_sim_tool_offset
         set mom_sim_tool_offset(2) "$mom_sim_msg_word"
      }

      "HEAD_NAME" {
         global mom_sim_machine_head
         set mom_sim_machine_head "$mom_sim_msg_word"
      }

      "POST_NAME" {
         global mom_sim_post_name
         set mom_sim_post_name "$mom_sim_msg_word"
      }

      "CYCLE_SPINDLE_AXIS" {
         global mom_sim_cycle_spindle_axis
         set mom_sim_cycle_spindle_axis "$mom_sim_msg_word"
      }

      "FIXTURE_OFFSET" {
      }

      default {
      }
   }


  # Added case to grab CSYS_MTX_'s.
   global mom_sim_csys_matrix mom_sim_csys_set

   if $mom_sim_csys_set {
return
   }

   if [string match "CSYS_MTX_*" $mom_sim_msg_key] {
      set tokens [split $mom_sim_msg_key _]
      set idx [lindex $tokens 2]

      set mom_sim_csys_matrix($idx) "$mom_sim_msg_word"

     # When csys is completely defined, map and set ZCS junction for simulation.
      if { $idx == 11 } {
         PB_CMD_vnc__set_kinematics
         set mom_sim_csys_set 1
      }
   }
}



