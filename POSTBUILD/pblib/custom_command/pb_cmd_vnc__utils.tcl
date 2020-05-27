##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006, UGS/PLM Solutions.  #
#                                                                            #
##############################################################################
#               P B _ C M D _ V N C _ _ U T I L S . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains utility functions for ISV & Sync Manager.
#
##############################################################################



#=============================================================
proc PB_CMD_vnc__load_vnc_file { } {
#=============================================================
# This function will load a new VNC file per combination of
# various NC instructions during a NC program simaultion.
#
   global mom_sim_post_builder_rev_post

  # For CAM program simuation, VNC is loaded in head change event.
  #
   if { ![info exists mom_sim_post_builder_rev_post] || !$mom_sim_post_builder_rev_post } {
return
   }


   global mom_sim_linked_post_name

   if [info exists mom_sim_linked_post_name] {

      global mom_sim_vnc_handler_loaded
      global mom_sim_machine_head
      global mom_sim_machine_data

      if { [info exists mom_sim_machine_data(type)] &&\
           [info exists mom_sim_machine_data(carrier)] &&\
           [info exists mom_sim_machine_data(spindle)] } {

         set head $mom_sim_machine_data(type)_${mom_sim_machine_data(carrier)}_${mom_sim_machine_data(spindle)}

         if [info exists mom_sim_linked_post_name($head)] {

            set post_name $mom_sim_linked_post_name($head)
            set new_vnc_file "[file dirname $mom_sim_vnc_handler_loaded]/${post_name}_vnc.tcl"

            if { [string compare $mom_sim_vnc_handler_loaded $new_vnc_file] } {
               uplevel #0 {
                  source $new_vnc_file
               }

               PB_SIM_call PB_CMD_vnc__init_sim_vars
            }
         }

      }
   }
}


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


 #----------
 # * Step-1
 #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 # List of tool carrier ID's for indexable turrets
 # This list is referenced in VNC's tool change handler
 # to trigger a turret indexing.
 #
  set mom_sim_turret_carriers  {1 2}


 #--------------------------------------------------------------------------
 # Each turret may be configured differently.
 # Sample code below assumes both turrets have same configuration
 # which defines tool pockets situated around a turret uniformly.
 # Non-uniform arrangement needs to be individually defined for each pocket.
 #--------------------------------------------------------------------------
  foreach carrier_id $mom_sim_turret_carriers {
     switch $carrier_id {
        "1" -
        "2" {


          #----------
          # * Step-2
          #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          # Turret axis name defined with machine model.
          # Make sure the name of the rotating AXIS is specified here!
          #
           set mom_sim_turret_axis($carrier_id) TURRET$carrier_id


          #----------
          # * Step-3
          #+++++++++++++++++++++++++++++++++
          # Number of pockets on the turret
          #
           set pockets_num  12

          # Retain pockets number var to be referenced during tool change
           global mom_sim_turret_data
           set mom_sim_turret_data($carrier_id,pockets_num) $pockets_num
 
           set ang_inc [expr 360 / $pockets_num]
           set ang 0

           for { set pocket_id 1 } { $pocket_id < [expr $pockets_num + 1] } { incr pocket_id } {

              set mom_sim_pocket_angle($carrier_id,$pocket_id)  $ang
              set mom_sim_pocket_working_transformation($carrier_id@$pocket_id)\
                                                        "AXIS=<$mom_sim_turret_axis($carrier_id)> VALUE=<$ang>"

              set ang [expr $ang + $ang_inc]
           }


          #----------
          # * Step-4
          #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          # Specify the axes that a turret will move while returning
          # to the home position for a tool change.
          #
           global mom_sim_turret_return_axes
           set mom_sim_turret_return_axes($carrier_id) {X Y Z}

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
# This function is executed automatically for configuring
# the Channels dialog in Sync Manager.
#

#
# Comment out the "return" statement to customize
# the Channel Window System items in NX4 and User items in NX5.
#
# Make sure you set mom_sim_display_user_item to 1 in sim_high_level_sv_commands.tcl 
# if you want to show your user items
#

return

   global mom_sim_display_user_item 
   set mom_sim_display_user_item 1

 
  #-------------------------------------------------------------
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
  #------------------------------------------------------------#
  #                         Supported TYPE                     #
  #------------------------------------------------------------#
  #              NX4                 |           NX5           #
  #------------------------------------------------------------#
  #     | SYS_START_CHANNEL_GROUP    |        \        /       #
  #     | SYS_ACTIVE_TOOL_ITEM       |         \      /        #
  #     | SYS_COOLANT_ITEM           |          \    /         #
  # S   | SYS_SPEED_ITEM             |           \  /          #
  # Y I | SYS_FEED_ITEM              |            \/           #
  # S T | SYS_SPINDLE_SPEED_ITEM     |            /\           #
  # T E | SYS_SURFACE_SPEED_ITEM     |           /  \          #
  # E M | SYS_MAX_SPINDLE_SPEED_ITEM |          /    \         #
  # M S | SYS_TOOL_POSITION_ITEM     |         /      \        #
  #     | SYS_PROGRAM_WINDOW_ITEM    |        /        \       #
  #------------------------------------------------------------#
  #   I |         \    /             | USR_LABEL_ITEM          #
  # U T |          \  /              | USR_STRING_ITEM         #
  # S E |           \/               | USR_TOGGLE_ITEM         #
  # E M |           /\               | USR_RADIO_ITEM          #
  # R S |          /  \              | USR_RADIO_ITEM          #
  #     |         /    \             |                         #
  #------------------------------------------------------------#


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


   global mom_sim_vnc_msg_only
  
   if { ![info exists mom_sim_vnc_msg_only] || !$mom_sim_vnc_msg_only } {
  

      scan [string trim [MOM_ask_env_var UGII_VERSION]] "v%d" ugii_version


     #------------
     # Before NX5
     #------------
      if { $ugii_version < 5 } {

         global mom_sim_number_of_channels

         if [info exists mom_sim_number_of_channels] {

           # Start of Channel Window Dialog
            PB_SIM_call SIM_dialog_start      "SYS_CHANNEL_WINDOW TITLE=<Channel Window>"

            for { set i 0 } { $i < $mom_sim_number_of_channels } { incr i } {

               PB_SIM_call SIM_dialog_add_item     "SYS_START_CHANNEL_GROUP     [expr $i + 1]"
               PB_SIM_call SIM_dialog_add_item     "SYS_ACTIVE_TOOL_ITEM        U1"
               PB_SIM_call SIM_dialog_add_item     "SYS_COOLANT_ITEM            U2 ATTACHMENT=<LEFT 0 10>"
               PB_SIM_call SIM_dialog_add_item     "SYS_SPEED_ITEM              U3"
               PB_SIM_call SIM_dialog_add_item     "SYS_FEED_ITEM               U4 ATTACHMENT=<LEFT 0 10>"
               PB_SIM_call SIM_dialog_add_item     "SYS_SPINDLE_SPEED_ITEM      U5"
               PB_SIM_call SIM_dialog_add_item     "SYS_SURFACE_SPEED_ITEM      U6 ATTACHMENT=<LEFT 0 5>"
               PB_SIM_call SIM_dialog_add_item     "SYS_MAX_SPINDLE_SPEED_ITEM  U7"
               PB_SIM_call SIM_dialog_add_item     "SYS_TOOL_POSITION_ITEM      U8"
               PB_SIM_call SIM_dialog_add_item     "SYS_PROGRAM_WINDOW_ITEM     U9 SPAN=<4> WIDTH=<33>"

               if { $i < [expr $mom_sim_number_of_channels - 1] } {          
                  PB_SIM_call SIM_dialog_add_item  "USR_SEPARATOR_ITEM \
                                                    SP1 ORIENTATION=<VERTICAL>\
                                                    HEIGHT=<198> ATTACHMENT=<LEFT 0 0>"
               }
            }

           # End of Channel Window Dialog
            PB_SIM_call SIM_dialog_end
         }

     #----------
     # NX5 & up
     #----------
      } else {

        # Start of Channel Window Dialog
         PB_SIM_call SIM_dialog_start  "SYS_CHANNEL_WINDOW TITLE=<Channel Window>"
  
         PB_SIM_call SIM_dialog_add_item "USR_LABEL_ITEM     U1 LABEL=<Label>"
         PB_SIM_call SIM_dialog_add_item "USR_STRING_ITEM    U2 LABEL=<String> VALUE=<string value> WIDTH=<10>"
         PB_SIM_call SIM_dialog_add_item "USR_SEPARATOR_ITEM U3"
         PB_SIM_call SIM_dialog_add_item "USR_TOGGLE_ITEM    U4 LABEL=<Toggle> VALUE=<1>"
         PB_SIM_call SIM_dialog_add_item "USR_RADIO_ITEM     U5 LABEL=<Radio> VALUE=<1>\
                                                                ORIENTATION=<HORIZONTAL> SPAN=<3>\
                                                                LIST=<radio1,radio2,radio3> FORMAT=<CHECK_BOX>"
  
        # End of Channel Window Dialog
         PB_SIM_call SIM_dialog_end
      }
   }
}


#=============================================================
proc PB_CMD_vnc__init_sync_manager { } {
#=============================================================
# This command is executed automatically, if present in the
# driver, by the PB_CMD_vnc__start_of_program to initialize
# maximaum feeds & speeds for the kinematic elements required
# for Sync Manager.
#
# ** The users need to import this command to the driver for
#    Sync Manager simulation. Parameters of the default
#    configuration provided here need to be modified to fit
#    specific needs.
#
  global mom_multi_channel_mode


   if [info exists mom_multi_channel_mode] {

      global mom_sim_vnc_msg_only

      if { ![info exists mom_sim_vnc_msg_only] || !$mom_sim_vnc_msg_only } {

         global mom_sim_number_of_channels
         global mom_sim_rapid_feed_rate
         global mom_sim_turret_axis
         global mom_sim_default_spindle_max_rpm

         global mom_sim_result mom_sim_result1

          PB_SIM_call SIM_ask_nc_axes_of_mtool


          #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          # User will define feeds & speeds for turrets & spindles
          #
           set turret_speed       20
           set spindle_speed      10000
           set spindle_feed       10

           if [info exists mom_sim_default_spindle_max_rpm] {
              set spindle_speed   $mom_sim_default_spindle_max_rpm
           }


           global mom_sim_nc_register

           if { ![string compare "MM" $mom_sim_nc_register(UNIT)] } {
              set spindle_feed_unit  M_PER_MIN
           } else {
              set spindle_feed_unit  IN_PER_MIN
           }


          # Spindle component & axis assignmewnts.
          # -> Define a "" to skip the configuration of a component.
          #
           set main_spindle_comp         MAIN_SPINDLE
           set main_spindle_linear_axis  "" ;#MAIN_SPINDLE
           set sub_spindle_comp          "" ;#COUNTER_SPINDLE
           set sub_spindle_linear_axis   "" ;#COUNTER_SPINDLE
          #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


         for { set i 1 } { $i <= $mom_sim_number_of_channels } { incr i } {

           # Turret assignments are defined in PB_CMD_vnc____ASSIGN_TURRET_POCKETS.
            if [info exists mom_sim_turret_axis($i)] {
               if { [lsearch $mom_sim_result1 $mom_sim_turret_axis($i)] >= 0 } {
                  SIM_mach_max_axis_rapid_velocity  $mom_sim_turret_axis($i)  $turret_speed  REV_PER_MIN
                  SIM_set_axis_rotary_dir_mode      $mom_sim_turret_axis($i)  ALWAYS_SHORTEST
               }
            }

           # Set max feed for tool holder joints -- 12 joints (pockets) on each turret.
           # - This was impelmented for Heyligenstaedt with 2 turrets.
           #
           # for { set j 1 } { $j < 13 } { incr j } {
           #    if { [lsearch $mom_sim_result1 "T${i}_ARM_$j"] >= 0 } {
           #       SIM_mach_max_axis_rapid_velocity T${i}_ARM_$j 1 REV_PER_MIN
           #    }
           # }


           # By default all channels are assigned to main spindle.
            SIM_mach_assign_channel_to_spindle  $i  $main_spindle_comp

           # All channels can be primary
            SIM_mach_default_primary_channel  $i
         }


        # Spindle components speeds
         if { [string length $main_spindle_comp] != 0 } {
            SIM_mach_max_spindle_speed $main_spindle_comp  $spindle_speed  REV_PER_MIN
         }

         if { [string length $sub_spindle_comp] != 0 ] } {
            SIM_mach_max_spindle_speed $sub_spindle_comp   $spindle_speed  REV_PER_MIN
         }


        # Linear axis rapid feed that moves the main spindle axis
         if { [string length $main_spindle_linear_axis] != 0 } {
            if { [lsearch $mom_sim_result1 $main_spindle_linear_axis] >= 0 } {
               SIM_mach_max_axis_rapid_velocity $main_spindle_linear_axis  $spindle_feed  $spindle_feed_unit
            }
         }


        # Linear axis rapid feed that moves the counter spindle axis
        # to pick up the workpiece from the main spindle
         if { [string length $sub_spindle_linear_axis] != 0 } {
            if { [lsearch $mom_sim_result1 $sub_spindle_linear_axis] >= 0 } {
               SIM_mach_max_axis_rapid_velocity $sub_spindle_linear_axis  $spindle_feed  $spindle_feed_unit
            }
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__mount_part { } {
#=============================================================
# This function will be called, if present, @ start of ISV to
# relocate a part component to the secondary mounting junction
# (Ex. chuck face of a sub-spindle).
#
#
# *** Comment out next statement to snap part to the sub spindle.

return


  #+++++++++++++++++++++++
  # Name objects involved
  #
   set source_comp PART_SUB
   set source_jct  PART_SUB_MOUNT_JCT
   set target_comp CHUCK2
   set target_jct  CHUCK2_JCT


  # Fetch machine base component
  #
   global mom_sim_result

   set mom_sim_result ""

   set machine_base MACHINE_BASE
   PB_SIM_call SIM_ask_machine_base_component
   if { ![string match "" $mom_sim_result] } {
      set machine_base $mom_sim_result
   }


  # Validate KIM components
  #
   set comps_list { source_comp target_comp }

   foreach comp $comps_list {
      set val [eval format $[set comp]]
      set mom_sim_result 0
      catch {SIM_find_comp_by_name $machine_base $val}
      if { $mom_sim_result == 0 } {
         return
      }
   }


  # Validate junctions
  #
   set jct1 "$source_comp@$source_jct"
   set jct2 "$target_comp@$target_jct"

   set jcts_list { jct1 jct2 }

   foreach jct $jcts_list {
      set val [eval format $[set jct]]
      set mom_sim_result 0
      catch {SIM_ask_is_junction_exist $val}
      if { $mom_sim_result == 0 } {
         return
      }
   }


  # Trnasfer the part
  #
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
  global mom_sync_number
  global mom_sync_primary
  global mom_sync_affected
  global mom_sim_primary_channel

  # pb600 - Changed logic to handle more than 2 channels!
   set ch_list [list]
   foreach ch [array names mom_sync_affected] {
      lappend ch_list $mom_sync_affected($ch)
   }
   if [llength $ch_list] {
      eval PB_SIM_call SIM_synchronize $mom_sync_number $ch_list
   }

   if { ![string match "" $mom_sync_primary] && ![string match "None" $mom_sync_primary] } {
      SIM_primary_channel $mom_sync_primary
      set mom_sim_primary_channel $mom_sync_primary
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



