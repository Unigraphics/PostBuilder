##############################################################
# This file contains utility functions for VNC
##############################################################

#=============================================================
proc PB_CMD_vnc____ASSIGN_TURRET_POCKETS { } {
#=============================================================
# This is a special handler for assigning turret pockets.
#
#   *** DO NOT change the name of this command. ***
# 
# When this command exists in the Post, body of this command
# will be written out to the global scope of the Post's Tcl file.
# No need to declare any global variables in this command!
#


 # List of carrier ID's of indexable turrets
 # This list is referenced in VNC's tool change handler to trigger a turret indexing.
 #
  set mom_sim_turret_carriers  {2}


 # Each turret may be configured differently
 #
  foreach carrier_id $mom_sim_turret_carriers {
     switch $carrier_id {
        "2" {
          # Axis name
           set mom_sim_turret_axis($carrier_id) TURRET

          # Number of pockets
           set pockets_num  12

           set ang_inc [expr 360 / $pockets_num]
           set ang 0

           for { set pocket_id 1 } { $pocket_id < [expr $pockets_num + 1] } { incr pocket_id } {
              set mom_sim_pocket_angle($carrier_id,$pocket_id)  $ang
              set mom_sim_pocket_working_transformation($carrier_id@$pocket_id)  "AXIS=<TURRET> VALUE=<$ang>" 
              set ang [expr $ang + $ang_inc]
           }
        }
     }
  }

  unset carrier_id
  unset pocket_id
  unset pockets_num
  unset ang_inc
  unset ang
}


#=============================================================
proc PB_CMD_vnc__config_sync_dialog { } {
#=============================================================
# This command is to be used for configuring the Sync Manager dialog.
# It will be called by PB_CMD_vnc__start_of_program, when it exists.
#

  global mom_sim_vnc_msg_only


   if { ![info exists mom_sim_vnc_msg_only] || !$mom_sim_vnc_msg_only } {

      SIM_dialog_start	"SYS_MAIN_CONTROL_PANEL TITLE=<Merging-Lathe Control Panel>"

       SIM_dialog_add_item	"SYS_MACHINE_TIME_ITEM		S1"
       SIM_dialog_add_item	"SYS_CHANNEL_ITEM		S2 ORIENTATION=<HORIZONTAL> SPAN=<3> LIST=<1:TRUE,2:TRUE>"
       SIM_dialog_add_item	"SYS_POSITION_ITEM		S3 POSITION=<AXES> AXES_LIST=<Z1,X1,TURRET1,Z2,X2,TURRET2>"
       SIM_dialog_add_item	"SYS_MESSAGE_WINDOW_ITEM	S4"
       SIM_dialog_add_item	"SYS_STEP_CONTROL_ITEM		S5"
       SIM_dialog_add_item	"SYS_ANIMATION_SPEED_ITEM	S6"

      SIM_dialog_end

     # Start of Channel Window Dialog
      SIM_dialog_start	"SYS_CHANNEL_WINDOW TITLE=<Channel Window>"

      # 1st Channel
       SIM_dialog_add_item	"SYS_START_CHANNEL_GROUP      1"
       SIM_dialog_add_item	"SYS_ACTIVE_TOOL_ITEM         U1"
       SIM_dialog_add_item	"SYS_COOLANT_ITEM             U2 ATTACHMENT=<LEFT 0 10>"
       SIM_dialog_add_item	"SYS_SPEED_ITEM               U3"
       SIM_dialog_add_item	"SYS_FEED_ITEM                U4 ATTACHMENT=<LEFT 0 10>"
       SIM_dialog_add_item	"SYS_SPINDLE_SPEED_ITEM       U5"
       SIM_dialog_add_item	"SYS_SURFACE_SPEED_ITEM       U6 ATTACHMENT=<LEFT 0 5>"
       SIM_dialog_add_item	"SYS_MAX_SPINDLE_SPEED_ITEM   U7"
       SIM_dialog_add_item	"SYS_TOOL_POSITION_ITEM       U8"
       SIM_dialog_add_item	"SYS_PROGRAM_WINDOW_ITEM      U9 SPAN=<4> WIDTH=<33>"

       SIM_dialog_add_item	"USR_SEPARATOR_ITEM           SP1 ORIENTATION=<VERTICAL> HEIGHT=<198> ATTACHMENT=<LEFT 0 0>"

      # 2nd Channel
       SIM_dialog_add_item	"SYS_START_CHANNEL_GROUP      2"
       SIM_dialog_add_item	"SYS_ACTIVE_TOOL_ITEM         U1"
       SIM_dialog_add_item	"SYS_COOLANT_ITEM             U2 ATTACHMENT=<LEFT 0 10>"
       SIM_dialog_add_item	"SYS_SPEED_ITEM               U3"
       SIM_dialog_add_item	"SYS_FEED_ITEM                U4 ATTACHMENT=<LEFT 0 10>"
       SIM_dialog_add_item	"SYS_SPINDLE_SPEED_ITEM       U5"
       SIM_dialog_add_item	"SYS_SURFACE_SPEED_ITEM       U6 ATTACHMENT=<LEFT 0 5>"
       SIM_dialog_add_item	"SYS_MAX_SPINDLE_SPEED_ITEM   U7"
       SIM_dialog_add_item	"SYS_TOOL_POSITION_ITEM       U8"
       SIM_dialog_add_item	"SYS_PROGRAM_WINDOW_ITEM      U9 SPAN=<4> WIDTH=<33>"

     # End of Channel Window Dialog
      SIM_dialog_end
   }
}


#=============================================================
proc PB_CMD_vnc__init_sync_manager { } {
#=============================================================
# This command is to be used for initializing the Sync Manager.
# It will be called by PB_CMD_vnc__start_of_program, when it exists.
#

  global mom_sim_vnc_msg_only
  global mom_sim_primary_channel


   if { ![info exists mom_sim_vnc_msg_only] || !$mom_sim_vnc_msg_only } {

     # Axes feedrates
      SIM_mach_max_axis_rapid_velocity X1     20 M_PER_MIN
      SIM_mach_max_axis_rapid_velocity Y      20 M_PER_MIN
      SIM_mach_max_axis_rapid_velocity B      20 M_PER_MIN
      SIM_mach_max_axis_rapid_velocity Z1     20 M_PER_MIN
      SIM_mach_max_axis_rapid_velocity X2     20 M_PER_MIN
      SIM_mach_max_axis_rapid_velocity Z2     20 M_PER_MIN
      SIM_mach_max_axis_rapid_velocity TURRET 20 M_PER_MIN

      SIM_mach_max_axis_rapid_velocity C1     10 REV_PER_MIN
      SIM_mach_max_axis_rapid_velocity C2     10 REV_PER_MIN

     # Spindle components speeds
      SIM_mach_max_spindle_speed CHUCK1 8000 REV_PER_MIN
      SIM_mach_max_spindle_speed CHUCK2 4500 REV_PER_MIN

     # By default all channeles assigned to spindle-1 component
      SIM_mach_assign_channel_to_spindle 1 CHUCK1
      SIM_mach_assign_channel_to_spindle 2 CHUCK1

      SIM_mach_default_primary_channel 1
      SIM_mach_default_primary_channel 2
   }
}


#=============================================================
proc PB_CMD_vnc__mount_part { } {
#=============================================================
# This function will be called, if present, @ start of ISV to
# relocate a part component to the secondary mounting junction
# (Ex. chuck face of a sub-spindle).
#
# *** Comment out next statement to snap part to the sub spindle.
#return

   set source_comp PART_SUB
   set source_jct  PART_SUB_MOUNT_JCT
   set target_comp CHUCK2
   set target_jct  CHUCK2_JCT

   SIM_mount_kim_comp 0 $source_comp $source_jct $target_comp $target_jct
   SIM_update

  #---------------------
  # Compute the offsets
  #---------------------
   global mom_sim_sub_spindle_offset
   global mom_sim_result1

   SIM_ask_init_junction_xform $source_jct
   set origin_part_sub $mom_sim_result1
   SIM_ask_init_junction_xform $target_jct
   set origin_chuck2 $mom_sim_result1

   for { set i 0 } { $i < 3 } { incr i } {
      set mom_sim_sub_spindle_offset($i) [expr [lindex $origin_chuck2 $i] - [lindex $origin_part_sub $i]]
   }
}


#=============================================================
proc PB_CMD_vnc__sync { } {
#=============================================================
# This command is to be called by the MOM_sync handler of the Post.
#

  global mom_sync_number
  global mom_sync_primary
  global mom_sync_affected
  global mom_sim_primary_channel

   SIM_synchronize $mom_sync_number $mom_sync_affected(0) $mom_sync_affected(1)

   if { ![string match "" $mom_sync_primary] && ![string match "None" $mom_sync_primary] } {
      SIM_primary_channel $mom_sync_primary
      set mom_sim_primary_channel $mom_sync_primary
   } 
}


#=============================================================
proc PB_CMD_vnc__validate_machine_tool { } {
#=============================================================
# This command is called PB_CMD_vnc__init_sim_vars
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
   SIM_ask_nc_axes_of_mtool

   set axes_list { mom_sim_mt_axis(X) mom_sim_mt_axis(Y) mom_sim_mt_axis(Z) mom_sim_mt_axis(4) mom_sim_mt_axis(5) }

   foreach axis $axes_list {
      if [info exists $axis] {
         set val [eval format $[set axis]]
         if { [lsearch $mom_sim_result1 $val] < 0 } {
            set __msg "$__msg\n Machine axis \"$val\" for $axis is not defined in the model."
         }
      }
   }


  # Validate KIM components
  #
  # KIM component MACHINE_BASE is always assumed to exist for now
  # until it can be verified easily in the future!!!
   set machine_base MACHINE_BASE

   set comps_list { mom_sim_zcs_base_MCS mom_sim_zcs_base_LCS mom_sim_spindle_comp }

   foreach comp $comps_list {
      if [info exists $comp] {
         set val [eval format $[set comp]]
         if { ![string match "$machine_base" $val] } {
            SIM_find_comp_by_name $machine_base $val
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
            SIM_ask_is_junction_exist $val_jct
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

      SIM_mtd_reset
      MOM_abort "***  Abort ISV due to error in machine tool kinematics.  ***"
   }
}


