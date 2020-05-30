##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006, UGS PLM Solutions   #
#                                                                            #
##############################################################################
#
# This script defines following commands for XZC mill posts.
# Some common commands used in this script may be found in
# <mill_5_common.tcl>.
#
#    PB_CMD_kin_init_mill_xzc
#      uplevel {
#         *MOM_rotate
#         *PB_catch_warning
#         *MOM_lintol
#          MOM_set_polar
#          MODES_SET
#      }
#
#    PB_CMD_kin_before_motion
#    PB_CMD_kin_linearize_motion
#    PB_CMD_kin_init_mill_turn
#    LINEARIZE_MOTION
#    LINEARIZE_OUTPUT
#    MILL_TURN
#    CONVERT_POINT
#    CONVERT_BACK
#
#    PB_CMD_kin_init_rotary
#
#    PB_CMD_linearize_motion
#    PB_CMD_init_polar_mode
#    PB_CMD_init_cartesian_mode
#    PB_CMD_disable_linearization
#    PB_CMD_start_of_operation_force_addresses
#
##############################################################################


set mom_sys_output_mode                 "UNDEFINED"



#=============================================================
proc PB_CMD_kin_init_mill_xzc { } {
#=============================================================
# This command initializes the current post to output
# in XZC mode for a mill/turn.  The chuck will lock and
# be used as a rotary C axis.  All XY moves will be converted
# to X and C with X being a radius value and C the angle.
#
# The spindle can be specified as either parallel to the Z axis
# or perpendicular the Z axis.  The tool axis of the operation
# must be consistent with the defined spindle axis.  An error
# will be generated if the post cannot position to the specified
# spindle axis.
#
# Following commands are defined (via uplevel) here:
#
#    MOM_rotate
#    PB_catch_warning
#    MOM_lintol
#    MOM_set_polar
#    MODES_SET
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
proc MOM_rotate { } {
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
proc PB_catch_warning { } {
#=============================================================
# Called by MOM_catch_warning (ugpost_base.tcl)
#
# - String with "mom_warning_info" (come from event generator or handlers)
#   may be output by MOM_catch_warning to the message file.
#
# - "mom_warning_info" will be transfered to "mom_sys_rotary_error" for
#   PB_CMD_kin_before_motion to handle the error condition.
#
   PB_CMD_kin_catch_warning
}


#=============================================================
proc MOM_lintol { } {
#=============================================================
   PB_CMD_kin__MOM_lintol
}


#=============================================================
proc MOM_set_polar { } {
#=============================================================
   global mom_sys_coordinate_output_mode
   global mom_coordinate_output_mode
   global mom_kin_arc_output_mode
   global mom_sys_polar_arc_output_mode
   global mom_sys_cartesian_arc_output_mode

   if { ![string compare "ON" $mom_coordinate_output_mode] } {
      set mom_sys_coordinate_output_mode "POLAR"
      set mom_kin_arc_output_mode $mom_sys_polar_arc_output_mode
   } elseif { ![string compare "OFF" $mom_coordinate_output_mode] } {
      set mom_sys_coordinate_output_mode "CARTESIAN"
      set mom_kin_arc_output_mode $mom_sys_cartesian_arc_output_mode
   }

   MOM_reload_kinematics
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

   if { ![string compare "ON" $mom_kin_4th_axis_incr_switch] } {
      MOM_incremental $isincr fourth_axis
   }

   MOM_reload_kinematics
}


} ;# uplevel
#***********

} ;# PB_CMD_kin_init_mill_xzc


#=============================================================
proc PB_CMD_kin_before_motion { } {
#=============================================================
# This command is called before every motion.  It converts the
# xyz input from UG to xzc for the mill/turn.  It also processes
# the tool axis and verifies its correctness.
#
# --> Do NOT rename this command!
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

   if { ![string compare "POLAR" $mom_sys_coordinate_output_mode] } {

      if { [string compare "TRUE" $mom_sys_millturn_yaxis] } { MOM_suppress always Y }
      if { [string compare "POLAR" $mom_sys_output_mode] }  {
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
      set mom_pos(3)      $mom_out_angle_pos(0)
      MOM_reload_variable -a mom_pos
      MOM_reload_variable -a mom_prev_pos

   } elseif { ![string compare "CARTESIAN" $mom_sys_coordinate_output_mode] } {

      if { [string compare "TRUE" $mom_sys_millturn_yaxis] } { MOM_suppress off Y }
      if { [string compare "CARTESIAN" $mom_sys_output_mode] } {
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
# This command is called automatically before every linear motion to
# linearize rotary motions for a XZC mill.
#
   LINEARIZE_MOTION
}


#=============================================================
proc PB_CMD_kin_init_mill_turn { } {
#=============================================================
# This command initializes your post for a mill/turn.
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
  # This section assigns the name of the mill post.
  # --> Do NOT change any of the following lines!
  #
   if {![info exists mom_sys_mill_postname]} {
      set mom_sys_mill_postname "[file rootname $mom_event_handler_file_name]"
   }
}


if 0 {
#=============================================================
proc LINEARIZE_MOTION-pb1003 { } {
#=============================================================
# MOM_linear_move -> PB_CMD_kin_linearize_motion -> LINEARIZE_MOTION
#
# 07-31-2013 gsl - PR 6695045 - Add a global counter (all_count) to break the looping.
#                  Perhaps, same control is needed in LINEARIZE_LOCK_MOTION.
# 08-06-2013 gsl - Check the closeness of consecutive finds to prevent endless iteration
#                - Cleaned up and removed some pitfalls
# 10-09-2015 ljt - PR7526841: Use all_count to record the total number of interpolated points
#                  instead of the total number of iterations.
# 03-19-2016 ljt - PR7454776, Add angle comparison to break the looping

   global mom_pos mom_prev_pos mom_mcs_goto mom_prev_mcs_goto
   global mom_kin_linearization_tol mom_sys_coordinate_output_mode
   global mom_kin_machine_resolution mom_out_angle_pos mom_sys_output_mode
   global mom_tool_axis mom_prev_tool_axis mom_sys_radius_output_mode
   global mom_kin_4th_axis_min_limit mom_kin_4th_axis_max_limit
   global mom_kin_linearization_flag


  # Only for POLAR mode
   if { ![string compare "CARTESIAN" $mom_sys_coordinate_output_mode] ||\
        ![string compare "FALSE" $mom_kin_linearization_flag] } {
      PB_CMD_linear_move
return
   }


   VMOV 5 mom_pos       save_prev_pos
   VMOV 3 mom_mcs_goto  save_mcs_goto
   VMOV 3 mom_tool_axis save_ta


  #<09-09-2013 gsl> This may not be correct, since lin-tol is the chordal tolerance and
  #                 output resolution is the coincident tolerance.
  if 0 {
   if { $mom_kin_linearization_tol < $mom_kin_machine_resolution } {
      set tol $mom_kin_machine_resolution
   } else {
      set tol $mom_kin_linearization_tol
   }
  } else {
   set tol $mom_kin_linearization_tol
  }

  #<sws 5095924>
   set status [CONVERT_POINT mom_prev_mcs_goto mom_prev_tool_axis save_prev_pos mom_sys_radius_output_mode mom_prev_pos]
   if { [string match "FAIL" $status] } {
return
   }

  #<09-11-09 lxy> 5950020 - It seems redundant; and it also changes prev_mcs_goto.
  # CONVERT_BACK mom_prev_pos mom_prev_tool_axis mom_prev_mcs_goto


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

   if { ![string compare "SHORTEST_DISTANCE" $mom_sys_radius_output_mode] } {

      if { $mom_pos(0) < 0.0  &&  $mom_prev_pos(0) > 0.0 } {

         set mom_sys_radius_output_mode "ALWAYS_POSITIVE"
         set mom_pos(0) [expr -$mom_pos(0)]
         set mom_pos(3) [expr $mom_pos(3) + 180]
         set mom_pos(3) [LIMIT_ANGLE $mom_pos(3)]

         set reset_to_shortest_distance 1

      } elseif { $mom_pos(0) > 0.0  &&  $mom_prev_pos(0) < 0.0 } {

         set mom_sys_radius_output_mode "ALWAYS_NEGATIVE"
         set mom_pos(0) [expr -$mom_pos(0)]
         set mom_pos(3) [expr $mom_pos(3) + 180.0]
         set mom_pos(3) [LIMIT_ANGLE $mom_pos(3)]

         set reset_to_shortest_distance 1
      }
   }

   VMOV 5 mom_pos save_pos


  # Global counter to further constrain & break the looping;
  #
   set all_count 0

  # Retain previous in-tolerance point to check for closeness (within output tol) of subsequent solution.
  # This will prevent oscillatory situation (endless loop) during the solution finding.
  #
  # set __user_in_tol_pos(0) 0.0; set __user_in_tol_pos(1) 0.0; set __user_in_tol_pos(2) 0.0;
   VMOV 5 mom_prev_pos __user_in_tol_pos

   while { $loop == 0 } {

     # Never exceed 100 interpolated points!
      if { $all_count > 100 } {
         break
      }

      for { set i 3 } { $i < 5 } { incr i } {
         set del [expr $mom_pos($i) - $mom_prev_pos($i)]
         if { $del > 180.0 } {
            set mom_prev_pos($i) [expr $mom_prev_pos($i) + 360.0]
         } elseif { $del < -180.0 } {
            set mom_prev_pos($i) [expr $mom_prev_pos($i) - 360.0]
         }
      }

      set loop 1

      for { set i 0 } { $i < 3 } { incr i } {
         set mid_mcs_goto($i) [expr ($mom_mcs_goto($i) + $mom_prev_mcs_goto($i))/2.0]
      }

      for { set i 0 } { $i < 5 } { incr i } {
         set mid_pos($i) [expr ($mom_pos($i) + $mom_prev_pos($i))/2.0]
      }

     # Check deviation with tool path (in part space)
      CONVERT_BACK mid_pos mid_ta tmp_mcs_goto

      VEC3_sub tmp_mcs_goto mid_mcs_goto delta

      set error [VEC3_mag delta]

#INFO "all_count: $all_count  count: $count  -> error: $error  => [EQ_is_lt $error $tol]"

      if { $count > 20 } {
        # Each half-segment will not iterate more than 20 times

         VMOV 5 save_pos      mom_pos
         VMOV 3 save_mcs_goto mom_mcs_goto
         VMOV 3 save_ta       mom_tool_axis

         LINEARIZE_OUTPUT

         break

      } elseif { [EQ_is_lt $error $tol] } { ;#<07-31-2013 gsl> Replaced "<" with EQ_is_lt
        # Find point in tolerance

        # Compare current find with previous in-tol point
        # ==> Stop iterating on current segment
         VEC3_sub mom_pos __user_in_tol_pos dev

        # <17-Mar-2016 Jintao> Add angle comparison
         set delta_angle [expr abs( $mom_pos(3) - $__user_in_tol_pos(3) )]
         if { $delta_angle > 180.0 } {
            set delta_angle [expr abs( $delta_angle - 360.0 )]
         }

         if { [EQ_is_lt [VEC3_mag dev] $mom_kin_machine_resolution] &&\
              [EQ_is_lt $delta_angle $mom_kin_machine_resolution] } {

           # INFO "Same pos found, break iteration"
            break
         }

         VMOV 5 mom_pos __user_in_tol_pos

         LINEARIZE_OUTPUT

        # Set new start point for new half-segment
         VMOV 3 mom_mcs_goto  mom_prev_mcs_goto
         VMOV 3 mom_tool_axis mom_prev_tool_axis
         VMOV 5 mom_pos       mom_prev_pos

         if { $count != 0 } {

           # Restore original end point
            VMOV 5 save_pos      mom_pos
            VMOV 3 save_mcs_goto mom_mcs_goto
            VMOV 3 save_ta       mom_tool_axis

            set loop 0
            set count 0

           # <10-09-2015 ljt> PR7526841, record the number of interpolated points
            incr all_count
         }

      } else {
        # Prepare for next iteration

         if { $error < $mom_kin_machine_resolution } {
            set error $mom_kin_machine_resolution
         }

        #<08-06-2013 gsl> According to C code, change this statement: set error [expr sqrt($mom_kin_linearization_tol*.98/$error)]
         set error [expr sqrt( $tol/$error )*0.98]

         if { $error < .5 } { set error .5 }

         for { set i 0 } { $i < 3 } { incr i } {
            set mom_mcs_goto($i)   [expr $mom_prev_mcs_goto($i)  + ($mom_mcs_goto($i)  - $mom_prev_mcs_goto($i))*$error]
            set mom_tool_axis($i)  [expr $mom_prev_tool_axis($i) + ($mom_tool_axis($i) - $mom_prev_tool_axis($i))*$error]
         }

        #<08-06-2013 gsl> Since mom_pos is the output of CONVERT_POINT, no need to be calculated here.
        # for { set i 0 } { $i < 5 } { incr i } {
        #    set mom_pos($i) [expr $mom_prev_pos($i) + ($mom_pos($i) - $mom_prev_pos($i))*$error]
        # }

        #<08-06-2013 gsl> Mid-MCS pt becomes new end pt of the half-segment, find corresponding mom_pos to iterate.
        #                 What if conversion failed???
         set status [CONVERT_POINT mom_mcs_goto mom_tool_axis mom_prev_pos mom_sys_radius_output_mode mom_pos]
         if { [string match "FAIL" $status] } {
           # Bail out???
            INFO "status: $status"
         }

         set loop 0
         incr count
      }

     # <10-09-2015 ljt> Increase all_count here will record the number of loops;
     # but there is a great chance that all_count will be greater than 100.
      # incr all_count
   }


   VMOV 5 mom_pos       mom_prev_pos
   VMOV 3 mom_mcs_goto  mom_prev_mcs_goto
   VMOV 3 mom_tool_axis mom_prev_tool_axis

   if { $reset_to_shortest_distance == 1 } {
      set mom_sys_radius_output_mode "SHORTEST_DISTANCE"
   }
}
} ;# backup LINEARIZE_MOTION 

#=============================================================
proc LINEARIZE_MOTION { } {
#=============================================================
# MOM_linear_move -> PB_CMD_kin_linearize_motion -> LINEARIZE_MOTION
#
# Mar-29-2016       - NX/PB v11.0
# Aug-01-2016 Shuai - PR7768537. Fix duplicated end point problem

   global mom_pos mom_prev_pos mom_mcs_goto mom_prev_mcs_goto
   global mom_kin_linearization_tol mom_sys_coordinate_output_mode
   global mom_kin_machine_resolution mom_out_angle_pos mom_sys_output_mode
   global mom_tool_axis mom_prev_tool_axis mom_sys_radius_output_mode
   global mom_kin_4th_axis_min_limit mom_kin_4th_axis_max_limit
   global mom_kin_linearization_flag


  # Only for POLAR mode
   if { ![string compare "CARTESIAN" $mom_sys_coordinate_output_mode] ||\
        ![string compare "FALSE" $mom_kin_linearization_flag] } {
      PB_CMD_linear_move
return
   }


   VMOV 5 mom_pos       save_prev_pos
   VMOV 3 mom_mcs_goto  save_mcs_goto
   VMOV 3 mom_tool_axis save_ta


   set tol $mom_kin_linearization_tol


   set status [CONVERT_POINT mom_prev_mcs_goto mom_prev_tool_axis save_prev_pos mom_sys_radius_output_mode mom_prev_pos]
   if { [string match "FAIL" $status] } {
return
   }


   set loop 0
   set count 0


#
#  This algorithm linearizes between mom_prev_pos and mom_pos.  The following
#  section of code checks to make sure the sign of the X (or radius) does not change.
#  If the sign does change, the iteration loop will never converge.  This can happen
#  if the SHORTEST_DISTANCE method is selected to determine the sign of the X value.
#  This code forces the sign of mom_pos(0) to be the same as mom_prev_pos(0).
#
   set reset_to_shortest_distance 0

   if { ![string compare "SHORTEST_DISTANCE" $mom_sys_radius_output_mode] } {

      if { $mom_pos(0) < 0.0  &&  $mom_prev_pos(0) > 0.0 } {

         set mom_sys_radius_output_mode "ALWAYS_POSITIVE"
         set mom_pos(0) [expr -$mom_pos(0)]
         set mom_pos(3) [expr $mom_pos(3) + 180]
         set mom_pos(3) [LIMIT_ANGLE $mom_pos(3)]

         set reset_to_shortest_distance 1

      } elseif { $mom_pos(0) > 0.0  &&  $mom_prev_pos(0) < 0.0 } {

         set mom_sys_radius_output_mode "ALWAYS_NEGATIVE"
         set mom_pos(0) [expr -$mom_pos(0)]
         set mom_pos(3) [expr $mom_pos(3) + 180.0]
         set mom_pos(3) [LIMIT_ANGLE $mom_pos(3)]

         set reset_to_shortest_distance 1
      }
   }

   VMOV 5 mom_pos save_pos


  # Global counter to further constrain & break the looping;
  #
   set all_count 0

  # Retain previous in-tolerance point to check for closeness (within output tol) of subsequent solution.
  # This will prevent oscillatory situation (endless loop) during the solution finding.
  #
  # set __user_in_tol_pos(0) 0.0; set __user_in_tol_pos(1) 0.0; set __user_in_tol_pos(2) 0.0;
   VMOV 5 mom_prev_pos __user_in_tol_pos

   while { $loop == 0 } {

     # Never exceed 100 interpolated points!
      if { $all_count > 100 } {
         break
      }

      for { set i 3 } { $i < 5 } { incr i } {
         set del [expr $mom_pos($i) - $mom_prev_pos($i)]
         if { $del > 180.0 } {
            set mom_prev_pos($i) [expr $mom_prev_pos($i) + 360.0]
         } elseif { $del < -180.0 } {
            set mom_prev_pos($i) [expr $mom_prev_pos($i) - 360.0]
         }
      }

      set loop 1

      for { set i 0 } { $i < 3 } { incr i } {
         set mid_mcs_goto($i) [expr ($mom_mcs_goto($i) + $mom_prev_mcs_goto($i))/2.0]
      }

      for { set i 0 } { $i < 5 } { incr i } {
         set mid_pos($i) [expr ($mom_pos($i) + $mom_prev_pos($i))/2.0]
      }

     # Check deviation with tool path (in part space)
      CONVERT_BACK mid_pos mid_ta tmp_mcs_goto

      VEC3_sub tmp_mcs_goto mid_mcs_goto delta

      set error [VEC3_mag delta]

      if { $count > 20 } {
        # Each half-segment will not iterate more than 20 times

         VMOV 5 save_pos      mom_pos
         VMOV 3 save_mcs_goto mom_mcs_goto
         VMOV 3 save_ta       mom_tool_axis

         LINEARIZE_OUTPUT

         break

      } elseif { [EQ_is_lt $error $tol] } {

        # Find point in tolerance

        # Compare current find with previous in-tol point
        # ==> Stop iterating on current segment
         VEC3_sub mom_pos __user_in_tol_pos dev

        # Angle comparison
         set delta_angle [expr abs( $mom_pos(3) - $__user_in_tol_pos(3) )]
         if { $delta_angle > 180.0 } {
            set delta_angle [expr abs( $delta_angle - 360.0 )]
         }

        # <Aug-01-2016 shuai> PR7768537. Fix duplicated end point problem.
         VEC3_sub mom_pos save_pos dev_o

         if {([EQ_is_lt [VEC3_mag dev] $mom_kin_machine_resolution] &&\
              [EQ_is_lt $delta_angle $mom_kin_machine_resolution]) ||\
              [EQ_is_lt [VEC3_mag dev_o] $mom_kin_machine_resolution] } {

           # INFO "Same pos found, break iteration"
            break
         }

         VMOV 5 mom_pos __user_in_tol_pos

         LINEARIZE_OUTPUT

        # Set new start point for new half-segment
         VMOV 3 mom_mcs_goto  mom_prev_mcs_goto
         VMOV 3 mom_tool_axis mom_prev_tool_axis
         VMOV 5 mom_pos       mom_prev_pos

         if { $count != 0 } {

           # Restore original end point
            VMOV 5 save_pos      mom_pos
            VMOV 3 save_mcs_goto mom_mcs_goto
            VMOV 3 save_ta       mom_tool_axis

            set loop 0
            set count 0

           # Record the number of interpolated points
            incr all_count
         }

      } else {

        # Prepare for next iteration

         if { $error < $mom_kin_machine_resolution } {
            set error $mom_kin_machine_resolution
         }

        # According to C code, change next statement: set error [expr sqrt($mom_kin_linearization_tol*.98/$error)]
         set error [expr sqrt( $tol/$error )*0.98]

         if { $error < .5 } { set error .5 }

         for { set i 0 } { $i < 3 } { incr i } {
            set mom_mcs_goto($i)   [expr $mom_prev_mcs_goto($i)  + ($mom_mcs_goto($i)  - $mom_prev_mcs_goto($i))*$error]
            set mom_tool_axis($i)  [expr $mom_prev_tool_axis($i) + ($mom_tool_axis($i) - $mom_prev_tool_axis($i))*$error]
         }

        # Mid-MCS pt becomes new end pt of the half-segment, find corresponding mom_pos to iterate.
        # => What if conversion failed???
         set status [CONVERT_POINT mom_mcs_goto mom_tool_axis mom_prev_pos mom_sys_radius_output_mode mom_pos]
         if { [string match "FAIL" $status] } {
           # Bail out???
            INFO "status: $status"
         }

         set loop 0
         incr count
      }

   } ;# loop


   VMOV 5 mom_pos       mom_prev_pos
   VMOV 3 mom_mcs_goto  mom_prev_mcs_goto
   VMOV 3 mom_tool_axis mom_prev_tool_axis

   if { $reset_to_shortest_distance == 1 } {
      set mom_sys_radius_output_mode "SHORTEST_DISTANCE"
   }
}


#=============================================================
proc LINEARIZE_OUTPUT { } {
#=============================================================
# MOM_linear_move -> PB_CMD_kin_linearize_motion -> LINEARIZE_MOTION -> LINEARIZE_OUTPUT
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
   if { [EQ_is_lt $mom_motion_distance $mom_kin_machine_resolution] } {
      set mom_feed_rate_number $mom_kin_max_frn
   } else {
      set mom_feed_rate_number [expr $mom_feed_rate / $mom_motion_distance]
   }

   set mom_pos(3) $mom_out_angle_pos(0)

   # To work with the code in legacy ugpost_base
   if { [string match "3_axis_mill_turn" $mom_kin_machine_type] } {
      set mom_kin_machine_type "mill_turn"
   }

   FEEDRATE_SET

   if { [string match "mill_turn" $mom_kin_machine_type] } {
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

  # Must be called by PB_CMD_kin_before_motion
   if { ![CALLED_BY "PB_CMD_kin_before_motion"] } {
return
   }


   global mom_tool_axis mom_sys_spindle_axis mom_cycle_retract_to
   global mom_cycle_rapid_to_pos mom_cycle_feed_to_pos
   global mom_cycle_retract_to_pos mom_cycle_rapid_to mom_cycle_feed_to
   global mom_kin_4th_axis_direction mom_kin_4th_axis_leader mom_sys_leader
   global mom_prev_rot_ang_4th mom_mcs_goto mom_motion_type
   global mom_out_angle_pos mom_pos mom_prev_pos
   global mom_sys_radius_output_mode mom_warning_info
   global mom_kin_4th_axis_min_limit mom_kin_4th_axis_max_limit
   global mom_motion_event mom_sys_spindle_axis

   set status [CONVERT_POINT mom_mcs_goto mom_tool_axis mom_prev_pos mom_sys_radius_output_mode mom_pos]

   if { ![string compare "INVALID" $status] } {
      CATCH_WARNING "Invalid Tool Axis For Mill/Turn"
      global mom_sys_abort_next_event
      set mom_sys_abort_next_event 0
   }

   if { ![string compare "circular_move" $mom_motion_event] } {
      global mom_arc_direction
      global mom_pos_arc_plane
      global mom_pos_arc_center

      if { [EQ_is_equal [expr abs($mom_sys_spindle_axis(1))] 1.0] } {
         set mom_pos_arc_plane "ZX"
      }
      if { [EQ_is_equal $mom_pos(3) 180.0] } {
         if { ![string compare "CLW" $mom_arc_direction] } {
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
      CATCH_WARNING "C axis rotary position exceeds minimum limit, did not alter output"
   } elseif { $mom_pos(3) > $mom_kin_4th_axis_max_limit } {
      CATCH_WARNING "C axis rotary position exceeded maximum limit, did not alter output"
   }

   if { ![string compare "CYCLE" $mom_motion_type] } {
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
# - Called by MILL_TURN & LINEARIZE_MOTION
#
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


  #<08-06-2013 gsl> Tool axis s/b unitized
   VEC3_unitize ta tb
   VMOV 3 tb ta

   VMOV 3 v1 temp

   if { [info exists mom_tool_z_offset] } {
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

   if { [info exists mom_kin_4th_axis_point] } {
      VEC3_add temp mom_kin_4th_axis_point temp
   } else {
      VEC3_add temp mom_kin_4th_axis_center_offset temp
   }

  # 6093551
   if { ( [EQ_is_equal $mom_sys_spindle_axis(2)  1.0] && [EQ_is_equal $ta(2)  1.0] ) ||\
        ( [EQ_is_equal $mom_sys_spindle_axis(2) -1.0] && [EQ_is_equal $ta(2) -1.0] ) ||\
        ( [EQ_is_equal $mom_sys_spindle_axis(2)  1.0] && [EQ_is_equal $ta(2) -1.0] ) } {

      set v2(0) [expr sqrt(pow($temp(0),2) + pow($temp(1),2))]
      set v2(1) 0.0
      set v2(2) $temp(2)
      set v2(3) [expr ([ARCTAN $temp(1) $temp(0)])*$RAD2DEG*$mom_sys_spindle_axis(2)]

      if { ![string compare "reverse" $mom_kin_4th_axis_rotation] } { set v2(3) [expr -1*$v2(3)] }

      set v2(3) [expr $v2(3) + $mom_kin_4th_axis_ang_offset]
      set ang1 [LIMIT_ANGLE $v2(3)]

      if { $ang1 >= $mom_kin_4th_axis_min_limit && $ang1 <= $mom_kin_4th_axis_max_limit } {
         set ang1bad 0
      } else {
         set ang1 [expr $ang1 - 360.0]
         if { $ang1 >= $mom_kin_4th_axis_min_limit && $ang1 <= $mom_kin_4th_axis_max_limit } {
            set ang1bad 0
         } else {
            set ang1bad 1
         }
      }

      set ap(0) [expr -1*$v2(0)]
      set ap(1) 0.0
      set ap(2) $v2(2)
      set ap(3) [expr $v2(3) + 180.0]
      set ang2 [LIMIT_ANGLE $ap(3)]

      if { $ang2 >= $mom_kin_4th_axis_min_limit && $ang2 <= $mom_kin_4th_axis_max_limit } {
         set ang2bad 0
      } else {
         set ang2 [expr $ang2 - 360.0]
         if { $ang2 >= $mom_kin_4th_axis_min_limit && $ang2 <= $mom_kin_4th_axis_max_limit } {
            set ang2bad 0
         } else {
            set ang2bad 1
         }
      }

      if { ![string compare "ALWAYS_POSITIVE" $meth] } {
         if { $ang1bad } {
            set mom_sys_abort_next_event 1
            CATCH_WARNING "Fourth axis rotary angle not valid"
         }
      } elseif { ![string compare "ALWAYS_NEGATIVE" $meth] } {
         if { $ang2bad } {
            set mom_sys_abort_next_event 1
            CATCH_WARNING "Fourth axis rotary angle not valid"
         }
         VMOV 4 ap v2
      } elseif { $ang2bad && $ang1bad } {
         set mom_sys_abort_next_event 1
         CATCH_WARNING "Fourth axis rotary angle not valid"
      } elseif { $ang1bad == 1 } {
         VMOV 4 ap v2
      } elseif { !$ang1bad && !$ang2bad } {
         set d1 [LIMIT_ANGLE [expr $v2(3) - $pp(3)]]
         if { $d1 > 180. } { set d1 [expr 360.0 - $d1] }
         set d2 [LIMIT_ANGLE [expr $ap(3) - $pp(3)]]
         if { $d2 > 180. } { set d2 [expr 360.0 - $d2] }
         if { $d2 < $d1 } { VMOV 4 ap v2 }
      }

   } elseif { [EQ_is_zero $mom_sys_spindle_axis(2)] } {

      set cpos [expr ([ARCTAN $ta(1) $ta(0)])]
      set cout [expr $cpos - $mom_kin_caxis_rotary_pos*$DEG2RAD]
      set crot [expr 2*$PI - $cout]

      set v2(0) [expr cos($crot)*$temp(0) - sin($crot)*$temp(1)]
      set v2(1) [expr sin($crot)*$temp(0) + cos($crot)*$temp(1)]
      set v2(2) $temp(2)
      set v2(3) [expr $cout*$RAD2DEG]

#<08-02-10 gsl> pb752 - May be redundant
if 0 {
      global mom_kin_machine_resolution
      if { $mom_kin_machine_resolution >= .001 } {
         set decimals 3
      } elseif { $mom_kin_machine_resolution >= .0001 } {
         set decimals 4
      } else {
         set decimals 5
      }

      set yaxis [format "%.${decimals}f" $v2(1)]
} else {
      set yaxis $v2(1)
}
      if { ![string compare "FALSE" $mom_sys_millturn_yaxis] && ![EQ_is_zero $yaxis] } {

         global mom_tool_corner1_radius
         global mom_tool_diameter

#<08-02-10 gsl> pb752 - v2(3) is incremental
        #<sws 5095924>
         set rad [expr sqrt(pow($v2(0),2) + pow($v2(1),2))]
         set v2(3) [expr $v2(3) + ([ARCTAN $v2(1) $v2(0)])*$RAD2DEG]
         set v2(0) $rad
         set v2(1) 0.0

#<08-02-10 gsl> pb752 - What is it trying to do here?
#                     - Is it considering concave condition?
#                     - If this is a must condition, event can be aborted earlier.
#                       ==> We may need to keep track of previous Y (radius) and only abort this handler
#                           when current Y becomes larger.
         if { [info exists mom_tool_corner1_radius] } {
            set trad [expr $mom_tool_corner1_radius*2.0 - $mom_tool_diameter]
            if { ![EQ_is_zero $trad] } {
               set mom_sys_abort_next_event 1
               CATCH_WARNING "Tool may gouge, tool axis does not pass through centerline"

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
# - Called by LINEARIZE_MOTION
#
   upvar $input_point v1 ; upvar $tool_axis ta ; upvar $converted_point v2
   global DEG2RAD mom_kin_caxis_rotary_pos mom_sys_spindle_axis
   global mom_tool_offset mom_origin mom_translate
   global mom_tool_z_offset
   global mom_kin_4th_axis_point mom_kin_4th_axis_center_offset
   global mom_kin_4th_axis_ang_offset
   global mom_kin_4th_axis_rotation

   set ang [expr $v1(3) - $mom_kin_4th_axis_ang_offset]

   if { ![string compare "reverse" $mom_kin_4th_axis_rotation] } {set v1(3) [expr -$v1(3)]}

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




###########################################################################
# When creating a new post from another xzc mill-turn post,
# do not override following custom commands that may have existed already!

global gPB

set __is_xzc_mill_turn_post 0
set __is_multi_axis_post    0

if { [info exists gPB(mom_kin_machine_type)] } {

   if { [string match "3_axis_mill_turn" $gPB(mom_kin_machine_type)] } {
      set __is_xzc_mill_turn_post 1
   }

   if { [string match "*mill*" $gPB(mom_kin_machine_type)] &&\
       ([string match "*4*" $gPB(mom_kin_machine_type)] || [string match "*5*" $gPB(mom_kin_machine_type)]) } {

      set __is_multi_axis_post 1
   }
}



if { ![info exists gPB(PB_CMD_FROM_PBLIB)] } {
   set gPB(PB_CMD_FROM_PBLIB) [list]
}


#*******************************************************************************
# Dummy out following commands when present (resulted from a multi-axis post) -

if { [llength [info commands PB_CMD_kin_init_rotary]] > 0 } {
#=============================================================
proc PB_CMD_kin_init_rotary { } {
#=============================================================
# Null command from mill xzc
}
#-------------------------------------------------------------
}

if { [llength [info commands PB_CMD_linearize_motion]] > 0 } {
#=============================================================
proc PB_CMD_linearize_motion { } {
#=============================================================
# Null command from mill xzc
#
# This command is to obliterate the same command in the previous
# Post Builder release (v2.0).  In case this command has been
# attached to the Linear Move event of the existing Posts, this
# will prevent the linearization being performed twice, since
# PB_CMD_kin_linearize_motion is executed automatically already.
#
}
#-------------------------------------------------------------
}

#*******************************************************************************



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Redefine following commands only when not present -


if { [llength [info commands PB_CMD_init_polar_mode]] == 0 } {
#=============================================================
proc PB_CMD_init_polar_mode { } {
#=============================================================
# This command is called before every motion when the output
# is switched from CARTESIAN to POLAR mode. Any necessary actions
# or codes to output should be taken place in this command.
#
# Common Fanuc controllers use following G code to switch mode.
#
   MOM_output_literal "G12.1"
}
#-------------------------------------------------------------
} else {
   lappend gPB(PB_CMD_FROM_PBLIB) "PB_CMD_init_polar_mode"
}


if { [llength [info commands PB_CMD_init_cartesian_mode]] == 0 } {
#=============================================================
proc PB_CMD_init_cartesian_mode { } {
#=============================================================
# This command is called before every motion when the output
# is switched from POLAR to CARTESIAN mode. Any necessary actions
# or codes to output should be taken place in this command.
#
# Common Fanuc controllers use following G code to switch mode.
#
   MOM_output_literal "G13.1"
}
#-------------------------------------------------------------
} else {
   lappend gPB(PB_CMD_FROM_PBLIB) "PB_CMD_init_cartesian_mode"
}


if { [llength [info commands PB_CMD_disable_linearization]] == 0 } {
#=============================================================
proc PB_CMD_disable_linearization { } {
#=============================================================
# This command can be attached to Start of Path event to disable
# the linearization done by PB_CMD_kin_linearize_motion
#

   if { [llength [info commands PB_CMD_kin_linearize_motion]] } {
      rename PB_CMD_kin_linearize_motion ""
   }
}
#-------------------------------------------------------------
} else {
   lappend gPB(PB_CMD_FROM_PBLIB) "PB_CMD_disable_linearization"
}


if { [llength [info commands PB_CMD_start_of_operation_force_addresses]] == 0 } {
#=============================================================
proc PB_CMD_start_of_operation_force_addresses { } {
#=============================================================
# This command is used for mill-turns to make sure that
# certain parameters are not overwritten.
#
# --> Do NOT remove the following line!
#
   MOM_force once S M_spindle X Z F fourth_axis
}
#-------------------------------------------------------------
} else {
   lappend gPB(PB_CMD_FROM_PBLIB) "PB_CMD_start_of_operation_force_addresses"
}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



unset __is_xzc_mill_turn_post






