##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006, UGS PLM Solutions   #
#                                                                            #
##############################################################################


set mom_sys_output_mode                 "UNDEFINED"


#=============================================================
proc PB_CMD_kin_init_mill_xzc { } {
#=============================================================
#
# This procedure initializes the current post to output
# in XZC mode for a mill/turn.  The chuck will lock and
# be used as a rotary C axis.  All XY moves will be converted
# to X and C with X being a radius value and C the angle.
# The spindle can be specified as either parallel to the Z axis
# or perpendicular the Z axis.  The tool axis of the operation
# must be consistent with the defined spindle axis.  An error
# will be generated if the post cannot position to the specified
# spindle axis.
#

   global mom_kin_machine_type

   if { [info exists mom_kin_machine_type] } {
      if { ![string match "*3_axis_mill_turn*" $mom_kin_machine_type] } {
return
      }
   }


#***********
uplevel #0 {

if { [string match "POLAR" $mom_sys_xzc_arc_output_mode] } {
   set mom_sys_polar_arc_output_mode  $mom_kin_arc_output_mode
   set mom_sys_cartesian_arc_output_mode "LINEAR"
} else {
   set mom_sys_polar_arc_output_mode  "LINEAR"
   set mom_sys_cartesian_arc_output_mode $mom_kin_arc_output_mode
}

if { [string match "POLAR" $mom_sys_coordinate_output_mode] } {
   set mom_kin_arc_output_mode  $mom_sys_polar_arc_output_mode
} else {
   set mom_kin_arc_output_mode  $mom_sys_cartesian_arc_output_mode
}


MOM_reload_kinematics


if { [EQ_is_equal $mom_sys_spindle_axis(2) 1.0] } {
   set mom_cycle_spindle_axis   2
} elseif { [EQ_is_zero $mom_sys_spindle_axis(2)] } {
   if { [EQ_is_equal $mom_sys_spindle_axis(0) 1.0] } {
      set mom_cycle_spindle_axis    0
      set mom_kin_caxis_rotary_pos  0.0
   } elseif { [EQ_is_zero $mom_sys_spindle_axis(0)] } {
      set mom_cycle_spindle_axis    1
      set mom_kin_caxis_rotary_pos  90.0
   } elseif { [EQ_is_equal $mom_sys_spindle_axis(0) -1.0] } {
      set mom_cycle_spindle_axis    0
      set mom_kin_caxis_rotary_pos  180.0
   }
}


#=============================================================
proc MOM_set_polar { } {
#=============================================================
   global mom_sys_coordinate_output_mode
   global mom_coordinate_output_mode
   global mom_kin_arc_output_mode
   global mom_sys_polar_arc_output_mode
   global mom_sys_cartesian_arc_output_mode

   if { $mom_coordinate_output_mode == "ON" } {
      set mom_sys_coordinate_output_mode "POLAR"
      set mom_kin_arc_output_mode $mom_sys_polar_arc_output_mode
   } elseif { $mom_coordinate_output_mode == "OFF" } {
      set mom_sys_coordinate_output_mode "CARTESIAN"
      set mom_kin_arc_output_mode $mom_sys_cartesian_arc_output_mode
   }

   MOM_reload_kinematics
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
proc MODES_SET { } {
#=============================================================
  global mom_output_mode
  global mom_kin_4th_axis_incr_switch

  switch $mom_output_mode {
    ABSOLUTE { set isincr OFF }
    default  { set isincr ON }
  }

  MOM_incremental $isincr X Y Z

  if { $mom_kin_4th_axis_incr_switch == "ON" } {
    MOM_incremental $isincr fourth_axis
  }

  MOM_reload_kinematics
}


#=============================================================
proc MOM_lintol { } {
#=============================================================
  global mom_kin_linearization_flag
  global mom_kin_linearization_tol
  global mom_lintol_status
  global mom_lintol

  if {$mom_lintol_status == "ON"} {
     set mom_kin_linearization_flag "TRUE"
     if { [info exists mom_lintol] } {set mom_kin_linearization_tol $mom_lintol}
  } elseif {$mom_lintol_status == "OFF"} {
     set mom_kin_linearization_flag "FALSE"
  }
}


#=============================================================
proc MOM_rotate { } {
#=============================================================
## <rws 04-11-2008>
## If in TURN mode and user ivokes "Flip tool aorund Holder" a MOM_rotate event is generated
## When this happens ABORT this event via return

  global mom_machine_mode


  if {$mom_machine_mode == "TURN"} {return}


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

  if {![info exists mom_rotation_angle]} {return}

  if {![info exists mom_kin_5th_axis_direction]} {set mom_kin_5th_axis_direction "0"}

  #
  #  Determine which axis the user wanted, fourth or fifth.
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
         AAXIS {
            set axis [AXIS_SET $mom_rotate_axis_type]
         }
         BAXIS {
            set axis [AXIS_SET $mom_rotate_axis_type]
         }
         CAXIS {
            set axis [AXIS_SET $mom_rotate_axis_type]
         }
         HEAD {
            if { $mom_kin_machine_type == "5_axis_head_table"  ||  $mom_kin_machine_type == "5_AXIS_HEAD_TABLE" } {
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

   if {$axis == "0"} {
      global mom_warning_info
      set mom_warning_info "Invalid rotary axis"
      MOM_catch_warning
      MOM_abort_event
   }

   switch $mom_rotation_mode {
      NONE {
         set angle $mom_rotation_angle
         set mode 0
      }
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


  #<05-10-06 sws> pb351 - Corrected logic
   if {$axis == "3" } {
      if {![info exists mom_prev_rot_ang_4th]} {
          set prev_angles(0) [MOM_ask_address_value fourth_axis]
      } else {
          set prev_angles(0) $mom_prev_rot_ang_4th
      }
   } elseif {$axis == "4"} {
      if {![info exists mom_prev_rot_ang_5th]} {
          set prev_angles(1) [MOM_ask_address_value fifth_axis]
      } else {
          set prev_angles(1) $mom_prev_rot_ang_5th
      }
   }

   set p [expr $axis + 1]
   set a [expr $axis - 3]
   if {$axis == "3" && $mom_kin_4th_axis_direction == "MAGNITUDE_DETERMINES_DIRECTION"} {
      set dirtype 0
      global mom_sys_4th_axis_dir_mode
      if [info exists mom_sys_4th_axis_dir_mode] {
        if {$mom_sys_4th_axis_dir_mode == "ON"} {
          set del $dir
          if {$del == 0} {
            set del [expr $ang-$mom_prev_pos(3)]
            if {$del > 180.0} {set del [expr $del-360.0]}
            if {$del < -180.0} {set del [expr $del+360.0]}
          }
          global mom_sys_4th_axis_cur_dir
          if {$del > 0.0} {
            global mom_sys_4th_axis_clw_code
            set mom_sys_4th_axis_cur_dir $mom_sys_4th_axis_clw_code
          } elseif {$del < 0.0} {
            global mom_sys_4th_axis_cclw_code
            set mom_sys_4th_axis_cur_dir $mom_sys_4th_axis_cclw_code
          }
        }
      }
   } elseif { $axis == "4"  &&  $mom_kin_5th_axis_direction == "MAGNITUDE_DETERMINES_DIRECTION" } {
      set dirtype 0
      global mom_sys_5th_axis_dir_mode
      if [info exists mom_sys_5th_axis_dir_mode] {
        if {$mom_sys_5th_axis_dir_mode == "ON"} {
          set del $dir
          if {$del == 0} {
            set del [expr $ang-$mom_prev_pos(4)]
            if {$del > 180.0} {set del [expr $del-360.0]}
            if {$del < -180.0} {set del [expr $del+360.0]}
          }
          global mom_sys_5th_axis_cur_dir
          if {$del > 0.0} {
            global mom_sys_5th_axis_clw_code
            set mom_sys_5th_axis_cur_dir $mom_sys_5th_axis_clw_code
          } elseif {$del < 0.0} {
            global mom_sys_5th_axis_cclw_code
            set mom_sys_5th_axis_cur_dir $mom_sys_5th_axis_cclw_code
          }
        }
      }
   } else {
      set dirtype 1
   }

   if {$mode == 1} {
      set mom_out_angle_pos($a) $angle
   } elseif {$dirtype == 0} {

      if {$axis == 3} {
         set mom_out_angle_pos($a) [ROTSET $ang  $prev_angles(0)  $mom_kin_4th_axis_direction  $mom_kin_4th_axis_leader  mom_sys_leader(fourth_axis)  $mom_kin_4th_axis_min_limit  $mom_kin_4th_axis_max_limit]
      } else {
         set mom_out_angle_pos($a) [ROTSET $ang  $prev_angles(1)  $mom_kin_5th_axis_direction   $mom_kin_5th_axis_leader   mom_sys_leader(fifth_axis)  $mom_kin_5th_axis_min_limit  $mom_kin_5th_axis_max_limit]
      }

 #     if {$axis == 3} {set prot $prev_angles(0)}
 #     if {$axis == 4} {set prot $prev_angles(1)}
 #     if {$dir == 1 && $mom_out_angle_pos($a) < $prot} {
 #        set mom_out_angle_pos($a) [expr $mom_out_angle_pos($a) + 360.0]
 #     } elseif {$dir == -1 && $mom_out_angle_pos($a) > $prot} {
 #        set mom_out_angle_pos($a) [expr $mom_out_angle_pos($a) - 360.0]
 #     }
   } elseif {$dirtype == "1"} {

      if {$dir == -1} {
         if {$axis == 3} {
            set mom_sys_leader(fourth_axis) $mom_kin_4th_axis_leader-
         } else {
            set mom_sys_leader(fifth_axis) $mom_kin_5th_axis_leader-
         }
      } elseif {$dir == 0} {
         if {$axis == 3} {
            set mom_out_angle_pos($a) [ROTSET $ang  $prev_angles(0)  $mom_kin_4th_axis_direction   $mom_kin_4th_axis_leader   mom_sys_leader(fourth_axis)  $mom_kin_4th_axis_min_limit  $mom_kin_4th_axis_max_limit]
         } else {
            set mom_out_angle_pos($a) [ROTSET $ang  $prev_angles(1)  $mom_kin_5th_axis_direction   $mom_kin_5th_axis_leader  mom_sys_leader(fifth_axis)  $mom_kin_5th_axis_min_limit  $mom_kin_5th_axis_max_limit]
         }
      } elseif {$dir == 1} {
         set mom_out_angle_pos($a) $ang
      }
   }

   global mom_sys_auto_clamp

   if {[info exists mom_sys_auto_clamp]} {
     if {$mom_sys_auto_clamp == "ON"} {
       set out1 "1"
       set out2 "0"
       if {$axis == 3} {
         AUTO_CLAMP_2 $out1
         AUTO_CLAMP_1 $out2
       } else {
         AUTO_CLAMP_1 $out1
         AUTO_CLAMP_2 $out2
       }
     }
   }

   if {$axis == 3} {
      ####  <rws>
      ####  Use rotref switch ON to not output the actual 4th axis move

      if { $mom_rotation_reference_mode == "OFF" } {
          PB_CMD_fourth_axis_rotate_move
      }

      if {$mom_kin_4th_axis_direction == "SIGN_DETERMINES_DIRECTION"} {
        set mom_prev_rot_ang_4th [expr abs($mom_out_angle_pos(0))]
      } else {
        set mom_prev_rot_ang_4th $mom_out_angle_pos(0)
      }
      MOM_reload_variable mom_prev_rot_ang_4th
   } else {

      if [info exists mom_kin_5th_axis_direction] {

        ####  <rws>
        ####  Use rotref switch ON to not output the actual 5th axis move

        if { $mom_rotation_reference_mode == "OFF" } {
            PB_CMD_fifth_axis_rotate_move
        }

        if {$mom_kin_5th_axis_direction == "SIGN_DETERMINES_DIRECTION"} {
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
proc AXIS_SET { axis } {
#=============================================================

  global mom_sys_leader

   if {$axis == "[string index $mom_sys_leader(fourth_axis) 0]AXIS"} {
      return 3
   } elseif {$axis == "[string index $mom_sys_leader(fifth_axis) 0]AXIS"} {
      return 4
   } else {
      return 0
   }
}




} ;# uplevel
#***********

} ;# PB_CMD_kin_init_mill_xzc


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
proc PB_CMD_init_polar_mode {} {
#=============================================================
#
# This procedure is called before every motion when the output
# is switched from CARTESIAN to POLAR mode. Any necessary actions
# or codes to output should be taken place in this command.
#
# Common Fanuc controllers use following G code to switch mode.
#
   MOM_output_literal "G12.1"
}


#=============================================================
proc PB_CMD_init_cartesian_mode {} {
#=============================================================
#
# This procedure is called before every motion when the output
# is switched from POLAR to CARTESIAN mode. Any necessary actions
# or codes to output should be taken place in this command.
#
# Common Fanuc controllers use following G code to switch mode.
#
   MOM_output_literal "G13.1"
}


#=============================================================
proc PB_CMD_kin_before_motion {} {
#=============================================================
#
# This procedure is called before every motion.  It converts the
# xyz input from UG to xzc for the mill/turn.  It also processes
# the tool axis and verifies its correctness.  Do NOT rename this
# procedure.
#

   global mom_kin_machine_type

   if { [info exists mom_kin_machine_type] } {
      if { ![string match "*3_axis_mill_turn*" $mom_kin_machine_type] } {
return
      }
   }


   global mom_out_angle_pos mom_sys_coordinate_output_mode mom_sys_output_mode mom_pos
   global mom_mcs_goto mom_tool_axis mom_prev_pos mom_sys_millturn_yaxis
   global mom_kin_arc_output_mode

   if { $mom_sys_coordinate_output_mode == "POLAR" } {

      if { $mom_sys_millturn_yaxis != "TRUE" } { MOM_suppress always Y }
      if { $mom_sys_output_mode != "POLAR" }  {
        #
        # This section outputs the code needed to change the control to polar
        # output mode.
        #
         PB_CMD_init_polar_mode
         set mom_sys_output_mode "POLAR"
      }

      MILL_TURN
      MOM_reload_variable -a mom_out_angle_pos
      set mom_prev_pos(3) $mom_out_angle_pos(0)
      set mom_pos(3) $mom_out_angle_pos(0)
      MOM_reload_variable -a mom_pos
      MOM_reload_variable -a mom_prev_pos

   } elseif { $mom_sys_coordinate_output_mode == "CARTESIAN" } {

      if { $mom_sys_millturn_yaxis != "TRUE" } { MOM_suppress off Y }
      if { $mom_sys_output_mode != "CARTESIAN" } {
        #
        # This section outputs the code needed to change the control to cartesian
        # output mode.
        #
         PB_CMD_init_cartesian_mode
         set mom_sys_output_mode "CARTESIAN"
      }
   }
}


#=============================================================
proc PB_CMD_kin_linearize_motion { } {
#=============================================================
#
# This procedure is called automatically before every linear motion to
# linearize rotary motions for a XZC mill.
#
   LINEARIZE_MOTION
}


#=============================================================
proc PB_CMD_linearize_motion { } {
#=============================================================
#
# This procedure is to obliterate the same proc in the previous
# Post Builder release (v2.0).  In case this command has been
# attached to the Linear Move event of the existing Posts, this
# will prevent the linearization being performed twice, since
# PB_CMD_kin_linearize_motion is executed automatically already.
#
}


#=============================================================
proc PB_CMD_disable_linearization { } {
#=============================================================
#<04-14-08 gsl>
# This command can be attached to Start of Path event to disable
# the linearization done by PB_CMD_kin_linearize_motion
#

   if { [llength [info commands PB_CMD_kin_linearize_motion]] } {
      rename PB_CMD_kin_linearize_motion ""
   }
}


#=============================================================
proc LINEARIZE_MOTION { } {
#=============================================================
#  MOM_linear_move -> PB_CMD_kin_linearize_motion -> LINEARIZE_MOTION
#
   global mom_pos mom_prev_pos mom_mcs_goto mom_prev_mcs_goto
   global mom_kin_linearization_tol mom_sys_coordinate_output_mode
   global mom_kin_machine_resolution mom_out_angle_pos mom_sys_output_mode
   global mom_tool_axis mom_prev_tool_axis mom_sys_radius_output_mode
   global mom_kin_4th_axis_min_limit mom_kin_4th_axis_max_limit
   global mom_kin_linearization_flag

   if { $mom_sys_coordinate_output_mode == "CARTESIAN" || $mom_kin_linearization_flag == "FALSE"} {
      PB_CMD_linear_move
return
   }


   VMOV 5 mom_pos save_prev_pos
   VMOV 3 mom_mcs_goto save_mcs_goto
   VMOV 3 mom_tool_axis save_ta

   if { $mom_kin_linearization_tol < $mom_kin_machine_resolution } {
      set tol $mom_kin_machine_resolution
   } else {
      set tol $mom_kin_linearization_tol
   }

#<sws 5095924>
   set status [CONVERT_POINT mom_prev_mcs_goto mom_prev_tool_axis save_prev_pos mom_sys_radius_output_mode mom_prev_pos]
   if { [string match "FAIL" $status] } {
return
   }
   CONVERT_BACK mom_prev_pos mom_prev_tool_axis mom_prev_mcs_goto

   set loop 0
   set count 0

#<sws 5223160>
#
#  This algorithm linearizes between mom_prev_pos and mom_pos.  The following
#  section of code checks to make sure the sign of the X (or radius) does not change.
#  If the sign does change, the iteration loop will never converge.  This can happen
#  if the SHORTEST_DISTANCE method is selected to determine the sign of the X value.
#  This code forces the sign of mom_pos(0) to be the same as mom_prev_pos(0).
#
   set reset_to_shortest_distance 0
   if { $mom_sys_radius_output_mode == "SHORTEST_DISTANCE" } {
      if { $mom_pos(0) < 0.0 && $mom_prev_pos(0) > 0.0 } {

         set mom_sys_radius_output_mode "ALWAYS_POSITIVE"
         set mom_pos(0) [expr -$mom_pos(0)]
         set mom_pos(3) [expr $mom_pos(3) + 180]
         set mom_pos(3) [LIMIT_ANGLE $mom_pos(3)]
         set reset_to_shortest_distance 1

      } elseif { $mom_pos(0) > 0.0 && $mom_prev_pos(0) < 0.0 } {

         set mom_sys_radius_output_mode "ALWAYS_NEGATIVE"
         set mom_pos(0) [expr -$mom_pos(0)]
         set mom_pos(3) [expr $mom_pos(3) + 180.0]
         set mom_pos(3) [LIMIT_ANGLE $mom_pos(3)]
         set reset_to_shortest_distance 1
      }
   }

   VMOV 5 mom_pos save_pos
#<sws 5223160>

   while { $loop == 0 } {

      for { set i 3 } { $i < 5 } { incr i } {
         set del [expr $mom_pos($i) - $mom_prev_pos($i)]
         if { $del > 180.0 } {
            set mom_prev_pos($i) [expr $mom_prev_pos($i)+360.0]
         } elseif { $del < -180.0 } {
            set mom_prev_pos($i) [expr $mom_prev_pos($i)-360.0]
         }
      }

      set loop 1

      for { set i 0 } { $i < 3 } { incr i } {
         set mid_mcs_goto($i) [expr ($mom_mcs_goto($i) + $mom_prev_mcs_goto($i))/2.0]
      }
      for { set i 0 } { $i < 5 } { incr i } {
         set mid_pos($i) [expr ($mom_pos($i) + $mom_prev_pos($i))/2.0]
      }

      CONVERT_BACK mid_pos mid_ta temp

      VEC3_sub temp mid_mcs_goto work

      set error [VEC3_mag work]
      if { $count > 20 } {

         VMOV 5 save_pos mom_pos
         VMOV 3 save_mcs_goto mom_mcs_goto
         VMOV 3 save_ta mom_tool_axis

         LINEARIZE_OUTPUT

      } elseif { $error < $tol } {

         LINEARIZE_OUTPUT

         VMOV 3 mom_mcs_goto mom_prev_mcs_goto
         VMOV 3 mom_tool_axis mom_prev_tool_axis
         VMOV 5 mom_pos mom_prev_pos

         if { $count != 0 } {
            VMOV 5 save_pos mom_pos
            VMOV 3 save_mcs_goto mom_mcs_goto
            VMOV 3 save_ta mom_tool_axis
            set loop 0
            set count 0
         }

      } else {

         if { $error < $mom_kin_machine_resolution } {
            set error $mom_kin_machine_resolution
         }

         set error [expr sqrt($mom_kin_linearization_tol*.98/$error)]

         if { $error < .5 } { set error .5 }

         for { set i 0 } { $i < 3 } { incr i } {
            set mom_mcs_goto($i)   [expr $mom_prev_mcs_goto($i)  + ($mom_mcs_goto($i)  - $mom_prev_mcs_goto($i))*$error]
            set mom_tool_axis($i)  [expr $mom_prev_tool_axis($i) + ($mom_tool_axis($i) - $mom_prev_tool_axis($i))*$error]
         }
         for { set i 0 } { $i < 5 } { incr i } {
            set mom_pos($i) [expr $mom_prev_pos($i) + ($mom_pos($i) - $mom_prev_pos($i))*$error]
         }
         CONVERT_POINT mom_mcs_goto mom_tool_axis mom_prev_pos mom_sys_radius_output_mode mom_pos
         set loop 0
         incr count
      }
   }

   VMOV 5 mom_pos mom_prev_pos
   VMOV 3 mom_mcs_goto mom_prev_mcs_goto
   VMOV 3 mom_tool_axis mom_prev_tool_axis

   if { $reset_to_shortest_distance == "1" } {
      set mom_sys_radius_output_mode "SHORTEST_DISTANCE"
   }
}


#=============================================================
proc LINEARIZE_OUTPUT { } {
#=============================================================
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

   if { ![info exists mom_out_angle_pos] } {
      set mom_out_angle_pos(0) 0.0
      set mom_out_angle_pos(1) 0.0
   }
   if { ![info exists mom_prev_rot_ang_4th] } {
      set mom_prev_rot_ang_4th $mom_out_angle_pos(0)
   }
   if { ![info exists mom_prev_rot_ang_5th] } {
      set mom_prev_rot_ang_5th $mom_out_angle_pos(1)
   }

   set mom_out_angle_pos(0)  [ROTSET $mom_pos(3) $mom_prev_rot_ang_4th $mom_kin_4th_axis_direction\
                                     $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)\
                                     $mom_kin_4th_axis_min_limit $mom_kin_4th_axis_max_limit]

   #
   #  Re-calcualte the distance and feed rate number
   #

   VEC3_sub mom_mcs_goto mom_prev_mcs_goto delta
   set mom_motion_distance [VEC3_mag delta]
   if {[EQ_is_lt $mom_motion_distance $mom_kin_machine_resolution]} {
       set mom_feed_rate_number $mom_kin_max_frn
   } else {
       set mom_feed_rate_number [expr $mom_feed_rate / $mom_motion_distance]
   }

   set mom_pos(3) $mom_out_angle_pos(0)

   if {[string match "3_axis_mill_turn" $mom_kin_machine_type]} {
       set mom_kin_machine_type "mill_turn"
   }

   FEEDRATE_SET

   if {[string match "mill_turn" $mom_kin_machine_type]} {
       set mom_kin_machine_type "3_axis_mill_turn"
   }

   PB_CMD_linear_move

   set mom_prev_pos(3) $mom_out_angle_pos(0)

   MOM_reload_variable -a mom_pos
   MOM_reload_variable -a mom_prev_pos
   MOM_reload_variable -a mom_out_angle_pos
}


#=============================================================
proc MILL_TURN { } {
#=============================================================
   global mom_tool_axis mom_sys_spindle_axis mom_cycle_retract_to
   global mom_cycle_rapid_to_pos mom_cycle_feed_to_pos
   global mom_cycle_retract_to_pos mom_cycle_rapid_to mom_cycle_feed_to
   global mom_kin_4th_axis_direction mom_kin_4th_axis_leader mom_sys_leader
   global mom_prev_rot_ang_4th mom_mcs_goto mom_motion_type
   global mom_out_angle_pos mom_pos mom_prev_pos
   global mom_sys_radius_output_mode mom_warning_info
   global mom_kin_4th_axis_min_limit mom_kin_4th_axis_max_limit
   global mom_motion_event mom_sys_spindle_axis

   set status  [CONVERT_POINT mom_mcs_goto mom_tool_axis mom_prev_pos mom_sys_radius_output_mode mom_pos]

   if {$status == "INVALID"} {
      set mom_warning_info "Invalid Tool Axis For Mill/Turn"
      set mom_sys_abort_next_event 1
      global mom_sys_abort_next_event
      MOM_catch_warning
   }

   if { $mom_motion_event == "circular_move" } {
      global mom_arc_direction
      global mom_pos_arc_plane
      global mom_pos_arc_center

      if { [EQ_is_equal [expr abs($mom_sys_spindle_axis(1))] 1.0] } {
         set mom_pos_arc_plane "ZX"
      }
      if { [EQ_is_equal $mom_pos(3) 180.0] } {
          if {$mom_arc_direction == "CLW"} {
              set mom_arc_direction "CCLW"
          } else {
              set mom_arc_direction "CLW"
          }
      }
      if { [EQ_is_equal $mom_pos(3) 90.0] } {
          set y $mom_pos_arc_center(2)
          set mom_pos_arc_center(2) [expr -$mom_pos_arc_center(1)]
          set mom_pos_arc_center(1) $y
      } elseif { [EQ_is_equal $mom_pos(3) 270.0] } {
          set z $mom_pos_arc_center(1)
          set mom_pos_arc_center(1) [expr -$mom_pos_arc_center(2)]
          set mom_pos_arc_center(2) $z
      }
   }

   if { ![info exists mom_prev_rot_ang_4th] } {
      set mom_prev_rot_ang_4th 0.0 ;#<04-15-08 gsl> Should it be mom_out_angle_pos(0) instead?
   }

   set mom_out_angle_pos(0) [ROTSET $mom_pos(3) $mom_prev_rot_ang_4th $mom_kin_4th_axis_direction\
                                    $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)\
                                    $mom_kin_4th_axis_min_limit $mom_kin_4th_axis_max_limit]

   set mom_prev_pos(3) $mom_out_angle_pos(0)
   set mom_pos(3) $mom_out_angle_pos(0)

   MOM_reload_variable -a mom_out_angle_pos
   MOM_reload_variable -a mom_pos
   MOM_reload_variable -a mom_prev_pos

   if { $mom_pos(3) < $mom_kin_4th_axis_min_limit } {
      set mom_warning_info "C axis rotary position exceeds minimum limit, did not alter output"
      MOM_catch_warning
   } elseif { $mom_pos(3) > $mom_kin_4th_axis_max_limit } {
      set mom_warning_info "C axis rotary position exceeded maximum limit, did not alter output"
      MOM_catch_warning
   }

   if { $mom_motion_type == "CYCLE" } {
      for { set i 0 } { $i < 3 } { incr i } {
         set mom_cycle_rapid_to_pos($i)    [expr $mom_pos($i) + $mom_cycle_rapid_to*$mom_sys_spindle_axis($i)]
         set mom_cycle_feed_to_pos($i)     [expr $mom_pos($i) + $mom_cycle_feed_to*$mom_sys_spindle_axis($i)]
         set mom_cycle_retract_to_pos($i)  [expr $mom_pos($i) + $mom_cycle_retract_to*$mom_sys_spindle_axis($i)]
      }

      global mom_motion_event

      if { [string match "initial_move" $mom_motion_event] } {
         for { set i 0 } { $i < 3 } { incr i } {
            set mom_pos($i)  [expr $mom_pos($i) + $mom_cycle_rapid_to*$mom_sys_spindle_axis($i)]
         }
      }
   }
}


#=============================================================
proc CONVERT_POINT { input_point tool_axis prev_pos conversion_method converted_point } {
#=============================================================
   upvar $input_point v1; upvar $tool_axis ta ; upvar $converted_point v2
   upvar $prev_pos pp; upvar $conversion_method meth

   global mom_sys_spindle_axis mom_kin_caxis_rotary_pos
   global mom_sys_millturn_yaxis mom_kin_machine_resolution
   global mom_origin mom_translate
   global mom_tool_z_offset
   global mom_kin_4th_axis_min_limit mom_kin_4th_axis_max_limit
   global mom_warning_info
   global RAD2DEG DEG2RAD PI
   global mom_kin_4th_axis_min_limit mom_kin_4th_axis_max_limit
   global mom_kin_4th_axis_point mom_kin_4th_axis_center_offset
   global mom_kin_4th_axis_ang_offset
   global mom_kin_4th_axis_rotation
   global mom_sys_abort_next_event


   VMOV 3 v1 temp

   if {[info exists mom_tool_z_offset]} {
       set toff(0) [expr $mom_tool_z_offset*$mom_sys_spindle_axis(0)]
       set toff(1) [expr $mom_tool_z_offset*$mom_sys_spindle_axis(1)]
       set toff(2) [expr $mom_tool_z_offset*$mom_sys_spindle_axis(2)]
   } else {
       set toff(0) 0.0
       set toff(1) 0.0
       set toff(2) 0.0
   }

   VEC3_add temp toff temp
   if { [info exists mom_origin] }    { VEC3_sub temp mom_origin temp }
   if { [info exists mom_translate] } { VEC3_add temp mom_translate temp }

   if {[info exists mom_kin_4th_axis_point]} {
      VEC3_add temp mom_kin_4th_axis_point temp
   } else {
      VEC3_add temp mom_kin_4th_axis_center_offset temp
   }

   if { ( [EQ_is_equal $mom_sys_spindle_axis(2) 1.0] && [EQ_is_equal $ta(2) 1.0] ) ||\
        ( [EQ_is_equal $mom_sys_spindle_axis(2) -1.0] && [EQ_is_equal $ta(2) -1.0] ) } {

      set v2(0) [expr sqrt(pow($temp(0),2) + pow($temp(1),2))]
      set v2(1) 0.0
      set v2(2) $temp(2)
      set v2(3) [expr ([ARCTAN $temp(1) $temp(0)])*$RAD2DEG*$mom_sys_spindle_axis(2)]
      if {$mom_kin_4th_axis_rotation == "reverse"} {set v2(3) [expr -$v2(3)]}
      set v2(3) [expr $v2(3) + $mom_kin_4th_axis_ang_offset]
      set ang1 [LIMIT_ANGLE $v2(3)]
      if {$ang1 >= $mom_kin_4th_axis_min_limit && $ang1 <= $mom_kin_4th_axis_max_limit} {
         set ang1bad 0
      } else {
         set ang1 [expr $ang1 - 360.0]
         if {$ang1 >= $mom_kin_4th_axis_min_limit && $ang1 <= $mom_kin_4th_axis_max_limit} {
            set ang1bad 0
         } else {
            set ang1bad 1
         }
      }

      set ap(0) [expr -$v2(0)]
      set ap(1) 0.0
      set ap(2) $v2(2)
      set ap(3) [expr $v2(3) + 180.0]
      set ang2 [LIMIT_ANGLE $ap(3)]
      if {$ang2 >= $mom_kin_4th_axis_min_limit && $ang2 <= $mom_kin_4th_axis_max_limit} {
         set ang2bad 0
      } else {
         set ang2 [expr $ang2 - 360.0]
         if {$ang2 >= $mom_kin_4th_axis_min_limit && $ang2 <= $mom_kin_4th_axis_max_limit} {
            set ang2bad 0
         } else {
            set ang2bad 1
         }
      }

      if {$meth == "ALWAYS_POSITIVE"} {
         if {$ang1bad} {
            set mom_sys_abort_next_event 1
            set mom_warning_info "Fourth axis rotary angle not valid"
            MOM_catch_warning
         }
      } elseif {$meth == "ALWAYS_NEGATIVE"} {
         if {$ang2bad} {
            set mom_sys_abort_next_event 1
            set mom_warning_info "Fourth axis rotary angle not valid"
            MOM_catch_warning
         }
         VMOV 4 ap v2
      } elseif {$ang2bad && $ang1bad} {
         set mom_sys_abort_next_event 1
         set mom_warning_info "Fourth axis rotary angle not valid"
         MOM_catch_warning
      } elseif {$ang1bad == 1} {
         VMOV 4 ap v2
      } elseif {!$ang1bad && !$ang2bad} {
         set d1 [LIMIT_ANGLE [expr $v2(3) - $pp(3)]]
         if {$d1 > 180.} {set d1 [expr 360.0 - $d1]}
         set d2 [LIMIT_ANGLE [expr $ap(3) - $pp(3)]]
         if {$d2 > 180.} {set d2 [expr 360.0 - $d2]}
         if {$d2 < $d1} {VMOV 4 ap v2}
      }

   } elseif { [EQ_is_zero $mom_sys_spindle_axis(2)] } {

      set cpos [expr ([ARCTAN $ta(1) $ta(0)])]
      set cout [expr $cpos - $mom_kin_caxis_rotary_pos*$DEG2RAD]
      set crot [expr 2*$PI - $cout]

      set v2(0) [expr cos($crot)*$temp(0) - sin($crot)*$temp(1)]
      set v2(1) [expr sin($crot)*$temp(0) + cos($crot)*$temp(1)]
      set v2(2) $temp(2)
      set v2(3) [expr $cout*$RAD2DEG]

      global mom_kin_machine_resolution
      if {$mom_kin_machine_resolution >= .001} {
          set decimals 3
      } elseif {$mom_kin_machine_resolution >= .0001} {
          set decimals 4
      } else {
          set decimals 5
      }
      set yaxis [format "%.${decimals}f" $v2(1)]
      if {$mom_sys_millturn_yaxis == "FALSE"  && ![EQ_is_zero $yaxis] } {

        global mom_tool_corner1_radius
        global mom_tool_diameter

#<sws 5095924>
        set rad [expr sqrt(pow($v2(0),2) + pow($v2(1),2))]
        set v2(3) [expr ([ARCTAN $v2(1) $v2(0)])*$RAD2DEG]
        set v2(0) $rad
        set v2(1) 0.0
        if { [info exists mom_tool_corner1_radius] } {
            set trad [expr $mom_tool_corner1_radius*2.0 - $mom_tool_diameter]
            if { ![EQ_is_zero $trad] } {
               set mom_sys_abort_next_event 1
               set mom_warning_info "Tool may gouge, tool axis does not pass through centerline"
               MOM_catch_warning
              return "FAIL"
            }
        }
      }
      return "OK"
   } else {
      return "INVALID"
   }

return "OK"
}


#=============================================================
proc CONVERT_BACK { input_point tool_axis converted_point } {
#=============================================================

   upvar $input_point v1 ; upvar $tool_axis ta ; upvar $converted_point v2
   global DEG2RAD mom_kin_caxis_rotary_pos mom_sys_spindle_axis
   global mom_tool_offset mom_origin mom_translate
   global mom_tool_z_offset
   global mom_kin_4th_axis_point mom_kin_4th_axis_center_offset
   global mom_kin_4th_axis_ang_offset
   global mom_kin_4th_axis_rotation

   set ang [expr $v1(3) - $mom_kin_4th_axis_ang_offset]

   if {$mom_kin_4th_axis_rotation == "reverse"} {set v1(3) [expr -$v1(3)]}

   if { [EQ_is_equal $mom_sys_spindle_axis(2) 1.0] } {

      set v2(0) [expr cos($ang*$DEG2RAD)*$v1(0)]
      set v2(1) [expr sin($ang*$DEG2RAD)*$v1(0)]
      set v2(2) $v1(2)
      set ta(0) 0.0
      set ta(1) 0.0
      set ta(2) 1.0

   } elseif { [EQ_is_zero $mom_sys_spindle_axis(2)] } {


      set cpos [expr $ang - $mom_kin_caxis_rotary_pos]
      set crot [expr $cpos*$DEG2RAD]
      set ta(0) [expr cos($cpos*$DEG2RAD)]
      set ta(1) [expr sin($cpos*$DEG2RAD)]
      set ta(2) 0.0
      set v2(0) [expr cos($crot)*$v1(0) - sin($crot)*$v1(1)]
      set v2(1) [expr sin($crot)*$v1(0) + cos($crot)*$v1(1)]
      set v2(2) $v1(2)
   }

   if { [info exists mom_tool_z_offset] } {
       set toff(0) [expr $mom_tool_z_offset*$mom_sys_spindle_axis(0)]
       set toff(1) [expr $mom_tool_z_offset*$mom_sys_spindle_axis(1)]
       set toff(2) [expr $mom_tool_z_offset*$mom_sys_spindle_axis(2)]
   } else {
       set toff(0) 0.0
       set toff(1) 0.0
       set toff(2) 0.0
   }

   VEC3_sub v2 toff v2

   if { [info exists mom_origin] }    { VEC3_add v2 mom_origin v2 }
   if { [info exists mom_translate] } { VEC3_sub v2 mom_translate v2 }

   if { [info exists mom_kin_4th_axis_point] } {
      VEC3_sub v2 mom_kin_4th_axis_point v2
   } else {
      VEC3_sub v2 mom_kin_4th_axis_center_offset v2
   }
}


#=============================================================
proc ARCTAN { y x } {
#=============================================================
   global PI

   if { [EQ_is_zero $y] } {
      if {$x < 0.0} {return $PI}
      return 0.0
   }

   if { [EQ_is_zero $x] } {
      if {$y < 0.0} {return [expr $PI*1.5]}
      return [expr $PI*.5]
   }

   set ang [expr atan ($y/$x)]
   if {$x > 0.0 && $y < 0.0} {return [expr $ang + $PI*2.0]}
   if {$x < 0.0 && $y < 0.0} {return [expr $ang + $PI]}
   if {$x < 0.0 && $y > 0.0} {return [expr $ang + $PI]}

return $ang
}


#=============================================================
proc LIMIT_ANGLE { a } {
#=============================================================

   while {$a < 0.0} {set a [expr $a+360.0]}
   while {$a >= 360.0} {set a [expr $a-360.0]}

return $a
}


#=============================================================
proc ROTSET { angle prev_angle dir kin_leader sys_leader min max } {
#=============================================================
#
#  This procedure will take an input angle and format for a specific machine.
#  It will also validate that the angle is within the specified limits of
#  machine.
#
#  angle          angle to be output.
#  prev_angle    previous angle output.  It should be mom_out_angle_pos
#  dir        can be either MAGNITUDE_DETERMINES_DIRECTION or
#              SIGN_DETERMINES_DIRECTION
#  kin_leader    leader (usually A, B or C) defined by postbuilder
#  sys_leader     leader that is created by rotset.  It could be C-.
#  min            minimum degrees of travel for current axis
#  max            maximum degrees of travel for current axis
#
#  This procedure is called the follow functions.
#  LOCK_AXIS, RETRACT_ROTARY_AXIS, MOM_rotate, LINEARIZE_OUTPUT and MILL_TURN
#
#
#=============================================================

   upvar $sys_leader lead

#
#  Make sure angle is 0-360 to start with.
#
   LIMIT_ANGLE $angle

   if {$dir == "MAGNITUDE_DETERMINES_DIRECTION"} {
#
#  If magnitude determines direction and total travel is less than or equal
#  to 360, we can assume there is at most one valid solution.  Find it and
#  leave.  Check for the total travel being less than 360 and give a warning
#  if a valid position cannot be found.
#
      set travel [expr $max - $min]
      if {$travel <= 360.0} {
          while {$angle < $min} {set angle [expr $angle + 360.0]}
          while {$angle > $max} {set angle [expr $angle - 360.0]}
          if {$angle < $min} {
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
          while { [expr abs([expr $angle - $prev_angle])] > 180.0 } {
              if { [expr $angle - $prev_angle] < -180.0 } {
                  set angle [expr $angle + 360.0]
              } elseif { [expr $angle - $prev_angle] > 180.0 } {
                  set angle [expr $angle - 360.0]
              }
          }
#
#  Check for the best solution being out of the travel limits.  Use the
#  next best valid solution.
#
          while {$angle < $min} {set angle [expr $angle + 360.0]}
          while {$angle > $max} {set angle [expr $angle - 360.0]}
      }
   } elseif {$dir == "SIGN_DETERMINES_DIRECTION"} {
#
#  Sign determines direction.  Determine whether the shortest distance is
#  clockwise or counterclockwise.  If counterclockwise append a "-" sign
#  to the address leader.
#
      set del [expr $angle-$prev_angle]
      if {($del < 0.0 && $del > -180.0) || $del > 180.0} {
          set lead "$kin_leader-"
      } else {
          set lead $kin_leader
      }
#
#  There are no alternate solutions if the position is out of limits.  Give
#  a warning a leave.
#
      if {$angle < $min || $angle > $max} {
          global mom_warning_info
          set mom_warning_info "$kin_leader-axis is under minimum or over maximum.  Assumed default."
          MOM_catch_warning
      }
   }

return $angle
}


#=============================================================
proc PB_CMD_linear_move { } {
#=============================================================
#
# This procedure is used by many automatic postbuilder functions
# to output a linear move.  Do NOT add this block to events or
# markers.  It is a static block and it is not intended to be added
# to events.  Do NOT change the name of this procedure.
#
# If you need a custom command to be output with a linear move block,
# you must place a call to the custom command either before or after
# the MOM_do_template command.
#
# This proc is used for:
#
#     simulated cycles feed moves
#     mill/turn mill linearization
#     four and five axis retract and re-engage
#

   MOM_do_template linear_move
}


#=============================================================
proc PB_CMD_kin_init_mill_turn { } {
#=============================================================
#
# This procedure initializes your post for a mill/turn.
#

   global mom_kin_machine_type mom_sys_mill_turn_mode

   if { [info exists mom_kin_machine_type] } {

      if { [string match "*3_axis_mill_turn*" $mom_kin_machine_type] } {

         set mom_sys_mill_turn_mode 1

      } else {

return
      }
   }


   global mom_sys_mill_postname
   global mom_sys_current_head
   global mom_event_handler_file_name


   set mom_sys_current_head     ""

  #
  # This section assigns the name of the mill post.  Do NOT change any
  # of the following lines.
  #
   if {![info exists mom_sys_mill_postname]} {
      set mom_sys_mill_postname "[file rootname $mom_event_handler_file_name]"
   }
}


#=============================================================
proc PB_CMD_start_of_operation_force_addresses { } {
#=============================================================
#
# This command is used for mill turns to make sure that
# certain parameters are not overwritten.  Do NOT remove
# the following line.
#
   MOM_force once S M_spindle X Z F fourth_axis
}


#=============================================================
proc PB_CMD_kin_init_rotary { } {
#=============================================================
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






