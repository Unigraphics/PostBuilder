##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006/2007/2008/2009/      #
#               2010/2011,                                                   #
#                             SIEMENS PLM Software                           #
#                                                                            #
##############################################################################
#                                                                            #
#  This file should be sourced in along with mill_5.tcl or mill_kin_xzc.tcl  #
#  to define common functions needed for multi-axis posts.                   #
#                                                                            #
##############################################################################
#
# This script defines the commands shared among XZC & multi-axis posts.
#
#    PB_CMD_kin__MOM_lintol
#    PB_CMD_kin__MOM_rotate
#
#    AUTO_CLAMP
#    AUTO_CLAMP_1
#    AUTO_CLAMP_2
#    AXIS_SET
#    ROTSET
#
#    PB_CMD__choose_preferred_solution
#    PB_CMD__convert_point
#    PB_CMD__catch_warning
#    PB_CMD_reverse_rotation_vector
#    PB_CMD_fourth_axis_rotate_move
#    PB_CMD_fifth_axis_rotate_move
#    PB_CMD_unclamp_fourth_axis
#    PB_CMD_unclamp_fifth_axis
#    PB_CMD_clamp_fourth_axis
#    PB_CMD_clamp_fifth_axis
#    PB_CMD_linear_move
#
##############################################################################


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
#<11-28-2018 gsl> pb1872 - Must reload mom_prev_rot_ang_4th & mom_prev_rot_ang_5th to fix 8553652
#
# => Uncomment next statement to disable this command -
# return


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

            if [EQ_is_gt $del5 $del5a] {
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

        #<11-28-2018 gsl> pb1872 - Must reload to fix random rotation issue (8553652)
         set ::mom_prev_rot_ang_4th $::mom_out_angle_pos(0)
         set ::mom_prev_rot_ang_5th $::mom_out_angle_pos(1)

         MOM_reload_variable mom_prev_rot_ang_4th mom_prev_rot_ang_5th

         MOM_reload_variable -a mom_out_angle_pos
         MOM_reload_variable -a mom_pos

        # Not needed
        # VMOV 2 ::mom_out_angle_pos ::mom_prev_out_angle_pos
        # MOM_reload_variable -a mom_prev_out_angle_pos

         set msg "Use alternate solution : $::mom_preferred_zone_flag \
                      ($a4 / $a5) -> ($::mom_out_angle_pos(0) / $::mom_out_angle_pos(1))"

        # OPERATOR_MSG "$msg"
         CATCH_WARNING "$co $msg $ci"
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
proc PB_CMD__convert_point { } {
#=============================================================
# This command converts global MCS goto to mom_pos & select the preferred solution
#
# Nov-27-2018 gsl - New
# Dec-13-2018 gsl - Reload mom_pos & mom_alt_pos
#
   if { [MOM_convert_point ::mom_mcs_goto ::mom_tool_axis] } {
      set idx -1
      foreach pos $::mom_result {
         set ::mom_pos([incr idx]) $pos
      }
      set idx -1
      foreach pos $::mom_result1 {
         set ::mom_alt_pos([incr idx]) $pos
      }

      MOM_reload_variable -a mom_pos
      MOM_reload_variable -a mom_alt_pos

     # Choose preferred solution per previous 4th or 5th angle
     # set ::mom_preferred_zone_flag FIFTH
      set ::mom_preferred_zone_flag FOURTH

      PB_CMD__choose_preferred_solution

      unset ::mom_preferred_zone_flag
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


if { [llength [info commands AUTO_CLAMP]] == 0 } {
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
} ;# if


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

if 0 {
# pb12.01 backup -
#=============================================================
proc ROTSET-pb1201 { angle prev_angle dir kin_leader sys_leader min max {tol_flag 0} } {
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
} ;# if 0


#=============================================================
proc ROTSET { angle prev_angle dir kin_leader sys_leader min max { tol_flag 0 } } {
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
# 04-25-2018 gsl - (pb12.02) Enhanced checking for rotation direction when "SIGN_DETERMINES_DIRECTION" is used.
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

     #<Apr-25-2018 gsl> Replaced with a command call
     #<03-13-12 gsl> Fit angle within limits
      set angle [MAXMIN_ANGLE $angle $max $min $tol_flag]

   } elseif { ![string compare "SIGN_DETERMINES_DIRECTION" $dir] } {

   #
   #  Sign determined direction determines whether the shortest distance is
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

     #<Apr-25-2018 gsl> Should be abs(prev_angle)
      set prev_angle [expr abs($prev_angle)]

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

     #<Apr-25-2018 gsl> Additional check if the move would cross the boundary, then reverse the direction.
      if { !$minus_flag && [EQ_is_lt $del 0.0] } {
         set n [expr int($prev_angle/360) + 1]
         if { [EQ_is_gt [expr $angle + $n*360.0] $max] } {
            set minus_flag 1
         }
      }


     #<04-27-11 wbh> 1819104 Check the rotary axis is 4th axis or 5th axis
      global mom_kin_4th_axis_leader mom_kin_5th_axis_leader
      global mom_rotary_direction_4th mom_rotary_direction_5th
      global mom_prev_rotary_dir_4th mom_prev_rotary_dir_5th

     #<Apr-25-2018 gsl> This logic may not determine is_4th properly,
     #                  since mom_kin_5th_axis_leader would always exist in a multi-axis post.
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
      } else {
        #<Apr-25-2018 gsl> Post (Tcl) needs to handle the opposite condition. The setting conveyed from the core processor is not reliable,
        #                  since the output angles are computed and produced by the post, core processor does not know about or keep track of.
         if { $is_4th } {
            set mom_rotary_direction_4th 1
         } else {
            set mom_rotary_direction_5th 1
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

   } ;# "SIGN_DETERMINES_DIRECTION"


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



###########################################################################
# When creating a new post from another multi-axis post,
# DO NOT override following custom commands that may have existed already!

global gPB


# Assuming this script will be sourced first -
set gPB(PB_CMD_FROM_PBLIB) [list]


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Redefine following commands only when not present in the post -

if { [llength [info commands PB_CMD_reverse_rotation_vector]] == 0 } {
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
#-------------------------------------------------------------
} else {
   lappend gPB(PB_CMD_FROM_PBLIB) "PB_CMD_reverse_rotation_vector"
}


if { [llength [info commands PB_CMD_fourth_axis_rotate_move]] == 0 } {
#=============================================================
proc PB_CMD_fourth_axis_rotate_move { } {
#=============================================================
#  This command is used by the Rotate UDE handler to output a
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
#-------------------------------------------------------------
} else {
   lappend gPB(PB_CMD_FROM_PBLIB) "PB_CMD_fourth_axis_rotate_move"
}


if { [llength [info commands PB_CMD_fifth_axis_rotate_move]] == 0 } {
#=============================================================
proc PB_CMD_fifth_axis_rotate_move { } {
#=============================================================
#  This command is used by the Rotate UDE handler to output a
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
#-------------------------------------------------------------
} else {
   lappend gPB(PB_CMD_FROM_PBLIB) "PB_CMD_fifth_axis_rotate_move"
}


if { [llength [info commands PB_CMD_unclamp_fourth_axis]] == 0 } {
#=============================================================
proc PB_CMD_unclamp_fourth_axis { } {
#=============================================================
#  This command is used by auto clamping handler to output code
#  needed to unclamp the fourth axis.
#
#  --> Do NOT attach this command to any event marker!
#  --> Do NOT change the name of this command!
#

   MOM_output_literal "M11"
}
#-------------------------------------------------------------
} else {
   lappend gPB(PB_CMD_FROM_PBLIB) "PB_CMD_unclamp_fourth_axis"
}


if { [llength [info commands PB_CMD_unclamp_fifth_axis]] == 0 } {
#=============================================================
proc PB_CMD_unclamp_fifth_axis { } {
#=============================================================
#  This command is used by auto clamping handler to output code
#  needed to unclamp the fifth axis.
#
#  --> Do NOT attach this command to any event marker!
#  --> Do NOT change the name of this command!
#

   MOM_output_literal "M13"
}
#-------------------------------------------------------------
} else {
   lappend gPB(PB_CMD_FROM_PBLIB) "PB_CMD_unclamp_fifth_axis"
}


if { [llength [info commands PB_CMD_clamp_fourth_axis]] == 0 } {
#=============================================================
proc PB_CMD_clamp_fourth_axis { } {
#=============================================================
#  This command is used by auto clamping handler to output code
#  needed to clamp the fourth axis.
#
#  --> Do NOT attach this command to any event marker!
#  --> Do NOT change the name of this command!
#

   MOM_output_literal "M10"
}
#-------------------------------------------------------------
} else {
   lappend gPB(PB_CMD_FROM_PBLIB) "PB_CMD_clamp_fourth_axis"
}


if { [llength [info commands PB_CMD_clamp_fifth_axis]] == 0 } {
#=============================================================
proc PB_CMD_clamp_fifth_axis { } {
#=============================================================
#  This command is used by auto clamping handler to output code
#  needed to clamp the fifth axis.
#
#  --> Do NOT attach this command to any event marker!
#  --> Do NOT change the name of this command!
#

   MOM_output_literal "M12"
}
#-------------------------------------------------------------
} else {
   lappend gPB(PB_CMD_FROM_PBLIB) "PB_CMD_clamp_fifth_axis"
}


if { [llength [info commands PB_CMD_linear_move]] == 0 } {
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
#     multi-axis retract & re-engage (ROTARY_AXIS_RETRACT) and lock-axis (LINEARIZE_LOCK_OUTPUT)
#     mill/turn mill linearization (LINEARIZE_MOTION, LINEARIZE_OUTPUT)
#     simulated cycles feed moves
#
#  ==> The user must ensure the BLOCK template "linear_move" exists.
#
   DO_BLOCK linear_move
}
#-------------------------------------------------------------
} else {
   lappend gPB(PB_CMD_FROM_PBLIB) "PB_CMD_linear_move"
}




