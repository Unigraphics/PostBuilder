##############################################################################
#                                                                            #
# Copyright(c) 1999/2000/2001/2002/2003/2004/2005/2006, UGS PLM Solutions.   #
# Copyright(c) 2007 ~ 2017,                             SIEMENS PLM Software #
#                                                                            #
##############################################################################
#
# This script defines following commands for multi-axis posts.
# Some common commands used in this script may be found in
# <mill_5_common.tcl>.
#
#    PB_CMD_kin_init_rotary
#      uplevel {
#          MOM_clamp
#         *MOM_rotate
#          MOM_lock_axis
#         *PB_catch_warning
#         *MOM_lintol
#      }
#
#    ROTATE_VECTOR
#    LOCK_AXIS_SUB
#    SET_LOCK
#    CHECK_LOCK_ROTARY_AXIS
#    RESET_ROTARY_SIGN
#    SET_FEEDRATE_NUMBER
#    ANGLE_CHECK
#    GET_SPINDLE_AXIS
#    SOLVE_QUADRATIC
#    CALC_SPHERICAL_RETRACT_POINT
#    CALC_CYLINDRICAL_RETRACT_POINT
#    RETRACT_POINT_CHECK
#
#    PB_CMD_kin_before_motion
#      VALIDATE_MOTION
#        PB_CMD__validate_motion
#      LOCK_AXIS_MOTION
#        LINEARIZE_LOCK_MOTION
#          LINEARIZE_LOCK_OUTPUT
#      ROTARY_AXIS_RETRACT
#      (AUTO_CLAMP)
#
#    LOCK_AXIS
#    UNLOCK_AXIS
#    LOCK_AXIS_INITIALIZE
#    PREFERRED_SOLUTION
#
#    PB_CMD_kin_init_mill_turn
#    PB_CMD_kin_init_mill_xzc
#    PB_CMD_kin_linearize_motion
#
#    PB_CMD__choose_preferred_solution
#    PB_CMD_init_rotary
#    PB_CMD_linearize_motion
#    PB_CMD_reposition_move
#    PB_CMD_retract_move
#    PB_CMD_revert_dual_head_kin_vars
#
##############################################################################



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
proc MOM_clamp { } {
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
proc MOM_lock_axis { } {
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

} ;# PB_CMD_kin_init_rotary


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
proc ROTARY_AXIS_RETRACT { } {
#=============================================================
# called by PB_CMD_kin_before_motion
#
#  This command is used by four and five axis posts to retract
#  from workpiece when the rotary axis become discontinuous.
#  This command is activated by setting the axis limit violation
#  action to "Retract / Re-Engage".
#
#-------------------------------------------------------------
# Nov-30-2016 gsl - (pb11.02) Corrected logic
# Sep-11-2017 gsl - (pb12.01) PB_user_defined_axis_limit_action was PB_user_def_axis_limit_action.
# Apr-13-2018 gsl - (pb12.02) Enhanced check condition for axis_limit_action.
# Aug-14-2019 gsl - (pb1899)  Patch up potentially missing ::mom_kin_5th_axis_limit_action
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
         global mom_warning_info
         global mom_kin_4th_axis_min_limit mom_kin_4th_axis_max_limit
         global mom_kin_5th_axis_min_limit mom_kin_5th_axis_max_limit

         global mom_kin_machine_type


        # (pb1899) - Patch up potentially missing 5th axis variables used in this command
         if { ![string match "5_axis_*" $mom_kin_machine_type] } {
            if { ![info exists ::mom_kin_5th_axis_limit_action] } {
               set ::mom_kin_5th_axis_limit_action $::mom_kin_4th_axis_limit_action
            }
         }


        #
        #  Check for the limit action being warning only.  If so, issue warning and leave
        #
        # (pb12.02) - Enhanced check condition
         if { ![string compare "Warning" $::mom_kin_4th_axis_limit_action] &&\
              ![string compare "Warning" $::mom_kin_5th_axis_limit_action] } {

            CATCH_WARNING "Rotary axis limit violated, discontinuous motion may result."

            return

         } elseif { ![string compare "User Defined" $::mom_kin_4th_axis_limit_action] ||\
                    ![string compare "User Defined" $::mom_kin_5th_axis_limit_action] } {

            PB_user_defined_axis_limit_action

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
proc PB_CMD__validate_motion { } {
#=============================================================
# Validate legitimate motion outputs of different post configurations -
#
# ==> This command will be called automatically by VALIDATE_MOTION
#     which in turn is called by PB_CMD_kin_before_motion.
# ==> Do not rename this command!
#
# For a 4-axis Table - The spindle axis (Vs) and tool axis (Vt) should be either co-linear or (||)
#                      BOTH on the plane of rotation (Vp).
# For a 4-axis Head  - The spindle axis (Vs) should be identical to the tool axis (Vt) and (&&)
#                      must lie ON the plane of rotation (Vp).
#
# For a 3-axis mill  - The resultant spindle axis and tool axis should be identical (Vt.Vp == 1).
#
#
# - "mom_spindle_axis" has accounted for the direction change resulted from
#   the angled-head attachment added to the spindle.
# - The max/min of the rotary axis will further constraint the reachability.
# - Vectors' DOT product will be 0 or +/-1. (Vt.Vp == 0 || +/-1)
#
# ==> This command can be enhanced to validate outputs of other post configurations.
#
#   Return: 1 = Motion OK
#           0 = Motion Bad
#-------------------------------------------------------------
# Apr-29-2015 gsl - New
# Sep-30-2016 gsl - Handle 3-axis case
#

#+++++++++++++++++++++++++++++++++++++++++++++++++++
# Uncomment next statement to disable this command -
#+++++++++++++++++++++++++++++++++++++++++++++++++++
# return 1


  # "mom_spindle_axis" would include transformation of head attachment.
   if [info exists ::mom_spindle_axis] {
      VMOV 3 ::mom_spindle_axis ::mom_sys_spindle_axis
   } else {
      VMOV 3 ::mom_kin_spindle_axis ::mom_sys_spindle_axis
   }


   if { [string match "3_axis_mill" $::mom_kin_machine_type] } {
      if { ![EQ_is_equal [VEC3_dot ::mom_sys_spindle_axis ::mom_tool_axis] 1.0] } {

         CATCH_WARNING "Illegal motion for a 3-axis mill"
         return 0
      }
   }


   if { [string match "4_axis_table" $::mom_kin_machine_type] } {

      if { !( [EQ_is_equal [expr abs([VEC3_dot ::mom_sys_spindle_axis ::mom_tool_axis])] 1.0] || \
              ( [EQ_is_equal [VEC3_dot ::mom_sys_spindle_axis ::mom_kin_4th_axis_vector] 0.0] && \
                [EQ_is_equal [VEC3_dot ::mom_tool_axis        ::mom_kin_4th_axis_vector] 0.0] ) ) } {

         CATCH_WARNING "Illegal motion for a 4-axis table machine"
         return 0
      }
   }

   if { [string match "4_axis_head" $::mom_kin_machine_type] } {

      if { !( [EQ_is_equal [VEC3_dot ::mom_sys_spindle_axis ::mom_tool_axis] 1.0] && \
              [EQ_is_equal [VEC3_dot ::mom_sys_spindle_axis ::mom_kin_4th_axis_vector] 0.0] ) } {

         CATCH_WARNING "Illegal motion for a 4-axis head machine"
         return 0
      }
   }

   return 1
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

if 0 {
#=============================================================
proc LOCK_AXIS_MOTION-pb1003 { } {
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
# Jul-16-2015     - Of pb1003
# Sep-09-2015 ljt - Comment out reload mom_pos
# Oct-15-2015 ljt - PR6789060 move reverse rotation to LINEARIZE_LOCK_OUTPUT
# Mar-25-2016 gsl - Forced "SHORTEST_DISTANCE" rotations cause axis' limits not honored.
# Mar-29-2016 gsl - Release a clean version for NX11.0
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
#<lll>
if 0 {
         if { [string match "initial_move" $mom_motion_event] } {
            set mom_sys_cycle_after_initial "TRUE"
return
         }

         if { [string match "TRUE" $mom_sys_cycle_after_initial] } {
            set mom_pos(0) [expr $mom_pos(0) - $mom_cycle_rapid_to * $mom_tool_axis(0)]
            set mom_pos(1) [expr $mom_pos(1) - $mom_cycle_rapid_to * $mom_tool_axis(1)]
            set mom_pos(2) [expr $mom_pos(2) - $mom_cycle_rapid_to * $mom_tool_axis(2)]
         }

         set mom_sys_cycle_after_initial "FALSE"
}

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

     #<lll> Removed RETARCT and add CYCLE & rapid_move
      if { ![string compare "TRUE"       $mom_kin_linearization_flag] &&\
            [string compare "RAPID"      $mom_motion_type]            &&\
            [string compare "CYCLE"      $mom_motion_type]            &&\
            [string compare "rapid_move" $mom_motion_event] } {

         LINEARIZE_LOCK_MOTION

        #<09-Sep-2015 ljt> Reload mom_pos will mess up iks. Reload mom_pos will change mom_prev_pos
        # in the next motion which makes sure mom_prev_pos is locked. Move this logic to LINEARIZE_LOCK_MOTION
        #
        # Only needed after linearization
        # MOM_reload_variable -a mom_pos

      } else {

         if { ![info exists mom_prev_rot_ang_4th] } { set mom_prev_rot_ang_4th 0.0 }
         if { ![info exists mom_prev_rot_ang_5th] } { set mom_prev_rot_ang_5th 0.0 }

        #<Mar-25-2016 gsl> Forced rotations cause axis' limits not honored.
        if 0 {
        # Add condition to march along shortest route
         set __reload_kin 0
         if [string match "5_axis_*table" $mom_kin_machine_type] {

           #<gsl> Not to reload during contouring
            if { [string compare "initial_move" $mom_motion_event] &&\
                 [string compare "first_move"   $mom_motion_event] &&\
                 [string compare "linear_move"  $mom_motion_event] &&\
                 [string compare "APPROACH"     $mom_motion_type]  &&\
                 [string compare "DEPARTURE"    $mom_motion_type] } {

               set save_kin_5th_axis_direction $mom_kin_5th_axis_direction
               set mom_kin_5th_axis_direction "SHORTEST_DISTANCE" ;# Will cause ROTSET not to do anything
               set __reload_kin 1
            }
         }

         if [string match "4_axis_table" $mom_kin_machine_type] {

            set save_kin_4th_axis_direction $mom_kin_4th_axis_direction
            set mom_kin_4th_axis_direction "SHORTEST_DISTANCE" ;# Will cause ROTSET not to do anything
            set __reload_kin 1
         }

         if { $__reload_kin } { MOM_reload_kinematics }
        }

         LINEARIZE_LOCK_OUTPUT -1

        if 0 {
         set __reload_kin 0
         if { [info exists save_kin_5th_axis_direction] } {
            set mom_kin_5th_axis_direction $save_kin_5th_axis_direction
            unset save_kin_5th_axis_direction
            set __reload_kin 1
         }

         if { [info exists save_kin_4th_axis_direction] } {
            set mom_kin_4th_axis_direction $save_kin_4th_axis_direction
            unset save_kin_4th_axis_direction
            set __reload_kin 1
         }

         if { $__reload_kin } { MOM_reload_kinematics }
        }

        #<09-15-09 wbh> We must call ROTSET only once for the 4th and/or 5th axis.
        # Since ROTSET was called in LINEARIZE_LOCK_OUTPUT,
        # we should reload mom_prev_rot_ang_5th if it exists.
        # <10-15-2015 ljt> move reverse table rotation to LINEARIZE_LOCK_OUTPUT
if 0 {
         if [string match "5_axis_*table" $mom_kin_machine_type] {

           #<04-08-2014 gsl> Add condition to reverse table rotation
            if { [string match "MAGNITUDE_DETERMINES_DIRECTION" $mom_kin_5th_axis_direction] &&\
                 [string match "Table" $mom_kin_5th_axis_type] } {

              # ==> DOT tool axis vector with table axis vector to reverse rotation
               global mom_kin_5th_axis_vector
               set sign [expr ([VEC3_dot mom_tool_axis mom_kin_5th_axis_vector] > 0) ? 1 : -1]
               set mom_out_angle_pos(1) [expr $sign*$mom_out_angle_pos(1)]
            }

            set mom_prev_rot_ang_5th $mom_out_angle_pos(1)
            MOM_reload_variable mom_prev_rot_ang_5th
         }
}
      }

     # set mom_prev_rot_ang_4th $mom_out_angle_pos(0)
     # MOM_reload_variable mom_prev_rot_ang_4th


     #VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
     # > Do not reload mom_pos here!
     # MOM_reload_variable -a mom_pos
   }
}
} ;# backup LOCK_AXIS_MOTION


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
# Mar-29-2016     - Of NX/PB v11.0
# Sep-11-2017 gsl - 7698782 Also recompute mom_prev_pos with LOCK_AXIS

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

        #<Sep-11-2017 gsl> 7698782 Also recompute mom_prev_pos
         LOCK_AXIS mom_prev_pos mom_prev_pos ::mom_prev_out_angle_pos
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
# Sep-11-2017 gsl - 7698782 Undo revision of <09-09-2015 ljt>. Ref revision in LOCK_AXIS_MOTION.

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
   #<Sep-11-2017 gsl> 7698782
    VMOV 5 mom_prev_pos locked_prev_pos
   # LOCK_AXIS mom_prev_pos locked_prev_pos ::mom_prev_out_angle_pos

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


if 0 {
#=============================================================
proc LINEARIZE_LOCK_OUTPUT-nx1202 { count } {
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
} ;# backup LINEARIZE_LOCK_OUTPUT


#=============================================================
proc LINEARIZE_LOCK_OUTPUT { count } {
#=============================================================
# called by LOCK_AXIS_MOTION & LINEARIZE_LOCK_MOTION
# "count > 0" will cause output.
#
# Jul-16-2013     - pb1003
# Oct-15-2015 ljt - PR6789060, account for reversed rotation, reload mom_prev_rot_ang_4/5th
# Oct-26-2018 gsl - 8961308 : Recompute DPM 
#
   global mom_pos mom_prev_pos
   global mom_mcs_goto mom_prev_mcs_goto
   global mom_out_angle_pos mom_prev_out_angle_pos
   global mom_prev_rot_ang_4th
   global mom_prev_rot_ang_5th
   global mom_kin_4th_axis_direction
   global mom_kin_5th_axis_direction
   global mom_kin_4th_axis_leader
   global mom_kin_5th_axis_leader
   global mom_sys_leader
   global mom_motion_distance
   global mom_feed_rate_number
   global mom_feed_rate
   global mom_kin_machine_resolution
   global mom_kin_max_frn
   global mom_kin_machine_type
   global mom_kin_4th_axis_min_limit mom_kin_4th_axis_max_limit
   global mom_kin_5th_axis_min_limit mom_kin_5th_axis_max_limit
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

  # Raw FRN w/o constraint of max DPM
   if { [EQ_is_lt $mom_motion_distance $mom_kin_machine_resolution] } {
      set mom_feed_rate_number $mom_kin_max_frn
   } else {
      set mom_feed_rate_number [expr $mom_feed_rate / $mom_motion_distance]
   }

   set mom_pos(3) $mom_out_angle_pos(0)
   set mom_pos(4) $mom_out_angle_pos(1)

   MOM_reload_variable -a mom_out_angle_pos


  #<10/26/2018 gsl> Recompute DPM during LOCK_AXIS
   global mom_feed_rate_dpm
   global mom_sys_rotary_axis_index

   set prev_ang [LIMIT_ANGLE $::mom_prev_out_angle_pos([expr $mom_sys_rotary_axis_index - 3 ])]
   set curr_ang [LIMIT_ANGLE $::mom_out_angle_pos([expr $mom_sys_rotary_axis_index - 3 ])]
   if { $prev_ang > 180.0 } { set prev_ang [LIMIT_ANGLE [expr -$prev_ang]] }
   if { $curr_ang > 180.0 } { set curr_ang [LIMIT_ANGLE [expr -$curr_ang]] }
   set minrot   [expr abs( $curr_ang - $prev_ang )]

   set mom_feed_rate_dpm [expr $minrot * $mom_feed_rate_number]
   if { [expr $mom_feed_rate_dpm > $::mom_kin_max_dpm ] } {
      set mom_feed_rate_dpm $::mom_kin_max_dpm
   }
   MOM_reload_variable mom_feed_rate_dpm


  # Normalized for feedrate mode determination
   set mom_pos($mom_sys_rotary_axis_index)      [LIMIT_ANGLE $mom_pos($mom_sys_rotary_axis_index)]
   set mom_prev_pos($mom_sys_rotary_axis_index) [LIMIT_ANGLE $mom_prev_pos($mom_sys_rotary_axis_index)]


   FEEDRATE_SET

   if { $count > 0 } { PB_CMD_linear_move }
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


   # <09-Sep-2015 ljt> Remove offsets of the 4/5th axis rotary center
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






###########################################################################
# When creating a new post from another multi-axis post,
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
# Dummy out following commands when present (resulted from a XZC post) -

if { [llength [info commands PB_CMD_kin_init_mill_xzc]] > 0 } {
#=============================================================
proc PB_CMD_kin_init_mill_xzc { } {
#=============================================================
# Null command from mill 5
}
#-------------------------------------------------------------
}


if { [llength [info commands PB_CMD_kin_init_mill_turn]] > 0 } {
#=============================================================
proc PB_CMD_kin_init_mill_turn { } {
#=============================================================
# Null command from mill 5
}
#-------------------------------------------------------------
}


if { [llength [info commands PB_CMD_kin_linearize_motion]] > 0 } {
#=============================================================
proc PB_CMD_kin_linearize_motion { } {
#=============================================================
# Null command from mill 5
}
#-------------------------------------------------------------
}


if { [llength [info commands PB_CMD_linearize_motion]] > 0 } {
#=============================================================
proc PB_CMD_linearize_motion { } {
#=============================================================
# Null command from mill 5
#
# This command is to obliterate the same command in the previous
# Post Builder release (v2.0).  In case this command has been
# attached to the Linear Move event of the existing Posts, this
# will prevent the linearization being performed twice, since
# PB_CMD_kin_linearize_motion is executed automatically already.
}
#-------------------------------------------------------------
}

#*******************************************************************************



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Redefine following commands only when absent -


if { [llength [info commands PB_CMD_revert_dual_head_kin_vars]] == 0 } {
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


   set var_list { ang_offset\
                  center_offset(0)\
                  center_offset(1)\
                  center_offset(2)\
                  direction\
                  incr_switch\
                  leader\
                  limit_action\
                  max_limit\
                  min_incr\
                  min_limit\
                  plane\
                  rotation\
                  zero }

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
#-------------------------------------------------------------
} else {
   lappend gPB(PB_CMD_FROM_PBLIB) "PB_CMD_revert_dual_head_kin_vars"
}


if { [llength [info commands PB_CMD_init_rotary]] == 0 } {
#=============================================================
proc PB_CMD_init_rotary { } {
#=============================================================
# Setting Retract and Re-Engage Parameters
#
# This action is activated by setting the Axis Limit Violation
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

   if { !$spindle_axis_defined } {
      VMOV 3 mom_kin_spindle_axis mom_sys_spindle_axis
   }

   set mom_sys_lock_status                        "OFF"

} ;# PB_CMD_init_rotary
#-------------------------------------------------------------
} else {
   lappend gPB(PB_CMD_FROM_PBLIB) "PB_CMD_init_rotary"
}


if { [llength [info commands PB_CMD_retract_move]] == 0 } {
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
#  If you need to modify the x, y or z locations you will need to do the
#  following.  (without the #)
#
#  global mom_pos
#  set mom_pos(0) 1.0
#  set mom_pos(1) 2.0
#  set mom_pos(2) 3.0

   MOM_do_template linear_move
}
#-------------------------------------------------------------
} else {
   lappend gPB(PB_CMD_FROM_PBLIB) "PB_CMD_retract_move"
}


if { [llength [info commands PB_CMD_reposition_move]] == 0 } {
#=============================================================
proc PB_CMD_reposition_move { } {
#=============================================================
#  This command is used by rotary axis retract to reposition the
#  rotary axes after the tool has been fully retracted.
#
#  You can modify this command to customize the reposition move.
#

   MOM_suppress once X Y Z
   MOM_do_template rapid_traverse
}
#-------------------------------------------------------------
} else {
   lappend gPB(PB_CMD_FROM_PBLIB) "PB_CMD_reposition_move"
}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



 unset __is_multi_axis_post




