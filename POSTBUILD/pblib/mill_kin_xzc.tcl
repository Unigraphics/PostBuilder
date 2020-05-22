##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002, Unigraphics Solutions Inc.              #
#                                                                            #
##############################################################################

set mom_sys_output_mode                 "UNDEFINED"

#=============================================================
proc PB_CMD_kin_init_mill_xzc {} {
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

   if [info exists mom_kin_machine_type] {
      if { ![string match "*3_axis_mill_turn*" $mom_kin_machine_type] } {
return
      }
   }


#***********
uplevel #0 {

if [string match "POLAR" $mom_sys_xzc_arc_output_mode] {
   set mom_sys_polar_arc_output_mode  $mom_kin_arc_output_mode
   set mom_sys_cartesian_arc_output_mode "LINEAR"
} else {
   set mom_sys_polar_arc_output_mode  "LINEAR"
   set mom_sys_cartesian_arc_output_mode $mom_kin_arc_output_mode
}

if [string match "POLAR" $mom_sys_coordinate_output_mode] {
   set mom_kin_arc_output_mode  $mom_sys_polar_arc_output_mode
} else {
   set mom_kin_arc_output_mode  $mom_sys_cartesian_arc_output_mode
}

MOM_reload_kinematics

if [EQ_is_equal $mom_sys_spindle_axis(2) 1.0] {
   set mom_cycle_spindle_axis   2
} elseif [EQ_is_zero $mom_sys_spindle_axis(2)] {
   if [EQ_is_equal $mom_sys_spindle_axis(0) 1.0] {
      set mom_cycle_spindle_axis    0
      set mom_kin_caxis_rotary_pos  0.0
   } elseif [EQ_is_zero $mom_sys_spindle_axis(0)] {
      set mom_cycle_spindle_axis    1
      set mom_kin_caxis_rotary_pos  90.0
   } elseif [EQ_is_equal $mom_sys_spindle_axis(0) -1.0] {
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

   for {set i 0} {$i < $n} {incr i} {
      set v2($i) $v1($i)
   }
}

#=============================================================
proc MODES_SET { } {
#=============================================================
  global mom_output_mode
  global mom_kin_4th_axis_incr_switch              "OFF"

  switch $mom_output_mode {
    ABSOLUTE { set isincr OFF }
    default  { set isincr ON }
  }
  MOM_incremental $isincr X Y Z 
  if {$mom_kin_4th_axis_incr_switch == "ON"} {
    MOM_incremental $isincr fourth_axis
  }

}

#=============================================================
proc MOM_lintol {} {
#=============================================================
  global mom_kin_linearization_flag
  global mom_kin_linearization_tol
  global mom_lintol_status
  global mom_lintol

  if {$mom_lintol_status == "ON"} {
     set mom_kin_linearization_flag "TRUE"
     if [info exists mom_lintol] {set mom_kin_linearization_tol $mom_lintol}
  } elseif {$mom_lintol_status == "OFF"} {
     set mom_kin_linearization_flag "FALSE"
  }
}



} ;# uplevel
#***********

} ;# PB_CMD_kin_init_mill_xzc


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

   if [info exists mom_kin_machine_type] {
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
proc LINEARIZE_MOTION { } {
#=============================================================
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

   VMOV 5 mom_pos save_pos
   VMOV 5 mom_pos save_prev_pos
   VMOV 3 mom_mcs_goto save_mcs_goto
   VMOV 3 mom_tool_axis save_ta

   if { $mom_kin_linearization_tol < $mom_kin_machine_resolution } {
      set tol $mom_kin_machine_resolution
   } else {
      set tol $mom_kin_linearization_tol
   }

   CONVERT_POINT mom_prev_mcs_goto mom_prev_tool_axis save_prev_pos \
                 mom_sys_radius_output_mode mom_prev_pos
   CONVERT_BACK mom_prev_pos mom_prev_tool_axis mom_prev_mcs_goto

   set loop 0
   set count 0

   while { $loop == 0 } {

      for {set i 3} {$i < 5} {incr i} {
         set del [expr $mom_pos($i) - $mom_prev_pos($i)]
         if {$del > 180.0} {
            set mom_prev_pos($i) [expr $mom_prev_pos($i)+360.0]
         } elseif {$del < -180.0} {
            set mom_prev_pos($i) [expr $mom_prev_pos($i)-360.0]
         }
      }

      set loop 1

      for {set i 0} {$i < 3} {incr i} {
         set mid_mcs_goto($i) [expr ($mom_mcs_goto($i)+$mom_prev_mcs_goto($i))/2.0]
      }
      for {set i 0} {$i < 5} {incr i} {
         set mid_pos($i) [expr ($mom_pos($i)+$mom_prev_pos($i))/2.0]
      }

      CONVERT_BACK mid_pos mid_ta temp

      VEC3_sub temp mid_mcs_goto work

      set error [VEC3_mag work]

      if {$count > 20} {

         VMOV 5 save_pos mom_pos
         VMOV 3 save_mcs_goto mom_mcs_goto
         VMOV 3 save_ta mom_tool_axis

         LINEARIZE_OUTPUT
           
      } elseif { $error < $tol} {

         LINEARIZE_OUTPUT

         VMOV 3 mom_mcs_goto mom_prev_mcs_goto
         VMOV 3 mom_tool_axis mom_prev_tool_axis
         VMOV 5 mom_pos mom_prev_pos
 
         if {$count != 0} {
            VMOV 5 save_pos mom_pos
            VMOV 3 save_mcs_goto mom_mcs_goto
            VMOV 3 save_ta mom_tool_axis
            set loop 0
            set count 0
         }

      } else {
         if {$error < $mom_kin_machine_resolution} {
            set error $mom_kin_machine_resolution
         }
         set error [expr sqrt($mom_kin_linearization_tol*.98/$error)]
         if {$error < .5} {set error .5}
         for {set i 0} {$i < 3} {incr i} {
            set mom_mcs_goto($i) \
                [expr $mom_prev_mcs_goto($i)+($mom_mcs_goto($i)-$mom_prev_mcs_goto($i))*$error]
            set mom_tool_axis($i) \
                [expr $mom_prev_tool_axis($i)+($mom_tool_axis($i)-$mom_prev_tool_axis($i))*$error]
         }
         for {set i 0} {$i < 5} {incr i} {
            set mom_pos($i) [expr $mom_prev_pos($i)+($mom_pos($i)-$mom_prev_pos($i))*$error]
         }
         CONVERT_POINT mom_mcs_goto mom_tool_axis mom_prev_pos mom_sys_radius_output_mode mom_pos
         set loop 0
         incr count 
      }
   }

   VMOV 5 mom_pos mom_prev_pos
   VMOV 3 mom_mcs_goto mom_prev_mcs_goto
   VMOV 3 mom_tool_axis mom_prev_tool_axis
}


#=============================================================
proc LINEARIZE_OUTPUT {} {
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

   if {![info exists mom_out_angle_pos]} {
      set mom_out_angle_pos(0) 0.0
      set mom_out_angle_pos(1) 0.0
   }
   if {![info exists mom_prev_rot_ang_4th]} {
      set mom_prev_rot_ang_4th $mom_out_angle_pos(0)
   }
   if {![info exists mom_prev_rot_ang_5th]} {
      set mom_prev_rot_ang_5th $mom_out_angle_pos(1)
   }

   set mom_out_angle_pos(0) \
       [ROTSET $mom_pos(3) $mom_prev_rot_ang_4th $mom_kin_4th_axis_direction \
               $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis) $mom_kin_4th_axis_min_limit $mom_kin_4th_axis_max_limit]
#
#  Re-calcualte the distance and feed rate number 
#

   VEC3_sub mom_mcs_goto mom_prev_mcs_goto delta
   set mom_motion_distance [VEC3_mag delta]
   if {[EQ_is_lt $mom_motion_distance $mom_kin_machine_resolution]} {
       set mom_feed_rate_number $mom_kin_max_frn
   } else {
       set mom_feed_rate_number [expr $mom_feed_rate / $mom_motion_distance ]
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
proc MILL_TURN {  } {
#=============================================================
   global mom_tool_axis mom_sys_spindle_axis mom_cycle_retract_to
   global mom_cycle_rapid_to_pos mom_cycle_feed_to_pos
   global mom_cycle_retract_to_pos mom_cycle_rapid_to mom_cycle_feed_to
   global mom_kin_4th_axis_direction mom_kin_4th_axis_leader mom_sys_leader
   global mom_prev_rot_ang_4th mom_mcs_goto mom_motion_type
   global mom_out_angle_pos mom_pos mom_prev_pos
   global mom_sys_radius_output_mode mom_warning_info
   global mom_kin_4th_axis_min_limit mom_kin_4th_axis_max_limit               

   set status  [CONVERT_POINT mom_mcs_goto mom_tool_axis mom_prev_pos mom_sys_radius_output_mode mom_pos]
   if {$status == "INVALID"} {
      set mom_warning_info "Invalid Tool Axis For Mill/Turn"
      MOM_catch_warning
   }

   if {![info exists mom_prev_rot_ang_4th]} {set mom_prev_rot_ang_4th 0.0}
   set mom_out_angle_pos(0) [ROTSET $mom_pos(3) $mom_prev_rot_ang_4th  $mom_kin_4th_axis_direction $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis) $mom_kin_4th_axis_min_limit $mom_kin_4th_axis_max_limit]
   

   set mom_prev_pos(3) $mom_out_angle_pos(0)
   set mom_pos(3) $mom_out_angle_pos(0)
   MOM_reload_variable -a mom_out_angle_pos
   MOM_reload_variable -a mom_pos
   MOM_reload_variable -a mom_prev_pos
   if {$mom_pos(3) < $mom_kin_4th_axis_min_limit} {
      set mom_warning_info "C axis rotary position exceeds minimum limit, did not alter output"
      MOM_catch_warning
   } elseif {$mom_pos(3) > $mom_kin_4th_axis_max_limit} {
      set mom_warning_info "C axis rotary position exceeded maximum limit, did not alter output"
      MOM_catch_warning
   }

   if {$mom_motion_type == "CYCLE"} {
      for {set i 0} {$i < 3} {incr i} {
         set mom_cycle_rapid_to_pos($i)  [expr $mom_pos($i) + $mom_cycle_rapid_to*$mom_sys_spindle_axis($i)]
         set mom_cycle_feed_to_pos($i)  [expr $mom_pos($i) + $mom_cycle_feed_to*$mom_sys_spindle_axis($i)]
         set mom_cycle_retract_to_pos($i)  [expr $mom_pos($i) + $mom_cycle_retract_to*$mom_sys_spindle_axis($i)]
      } 
      global mom_motion_event
      if {$mom_motion_event == "initial_move"} {
          for {set i 0} {$i < 3} {incr i} {
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

   if {( [EQ_is_equal $mom_sys_spindle_axis(2) 1.0] && [EQ_is_equal $ta(2) 1.0] ) || ( [EQ_is_equal $mom_sys_spindle_axis(2) -1.0] && [EQ_is_equal $ta(2) -1.0] )} {

      set v2(0) [expr sqrt(pow($temp(0),2) + pow($temp(1),2))]
      set v2(1) 0.0
      set v2(2) $temp(2)
      set v2(3) [expr ([ARCTAN $temp(1) $temp(0)])*$RAD2DEG*$mom_sys_spindle_axis(2)]
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
      set ap(3) [expr $v2(3)+180.0]
      if {$ap(3) >= 360.0} {set ap(3) [expr $ap(3) - 360.0]}
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
            set mom_warning_info "Fourth axis rotary angle not valid"
            MOM_catch_warning
         }
      } elseif {$meth == "ALWAYS_NEGATIVE"} {
         if {$ang2bad} {
            set mom_warning_info "Fourth axis rotary angle not valid"
            MOM_catch_warning
         }
         VMOV 4 ap v2
      } elseif {$ang2bad && $ang1bad} {
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

   } elseif [EQ_is_zero $mom_sys_spindle_axis(2)] {

      set cpos [expr ([ARCTAN $ta(1) $ta(0)])]
      set cout [expr $cpos - $mom_kin_caxis_rotary_pos*$RAD2DEG]
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

        if {[info exists mom_tool_corner1_radius]} {
            set trad [expr $mom_tool_corner1_radius*2.0 - $mom_tool_diameter]
            if ![EQ_is_zero $trad] {
              set mom_warning_info "Tool position may gouge"
              MOM_catch_warning
            }
        }
        set rad [expr sqrt(pow($v2(0),2) + pow($v2(1),2))]
        set v2(3) [expr ([ARCTAN $v2(1) $v2(0)])*$RAD2DEG]
        set v2(0) $rad
        set v2(1) 0.0
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

   if [EQ_is_equal $mom_sys_spindle_axis(2) 1.0] {

      set v2(0) [expr cos($v1(3)*$DEG2RAD)*$v1(0)]
      set v2(1) [expr sin($v1(3)*$DEG2RAD)*$v1(0)]
      set v2(2) $v1(2)
      set ta(0) 0.0
      set ta(1) 0.0
      set ta(2) 1.0

   } elseif [EQ_is_zero $mom_sys_spindle_axis(2)] {


      set cpos [expr $v1(3) - $mom_kin_caxis_rotary_pos]
      set crot [expr $cpos*$DEG2RAD]
      set ta(0) [expr cos($cpos*$DEG2RAD)]
      set ta(1) [expr sin($cpos*$DEG2RAD)]
      set ta(2) 0.0
      set v2(0) [expr cos($crot)*$v1(0) - sin($crot)*$v1(1)]
      set v2(1) [expr sin($crot)*$v1(0) + cos($crot)*$v1(1)]
      set v2(2) $v1(2)
   }

   if [info exists mom_tool_z_offset] {
       set toff(0) [expr $mom_tool_z_offset*$mom_sys_spindle_axis(0)]
       set toff(1) [expr $mom_tool_z_offset*$mom_sys_spindle_axis(1)]
       set toff(2) [expr $mom_tool_z_offset*$mom_sys_spindle_axis(2)]
   } else {
       set toff(0) 0.0
       set toff(1) 0.0
       set toff(2) 0.0
   }

   VEC3_sub v2 toff v2

   if [info exists mom_origin]    { VEC3_add v2 mom_origin v2 }
   if [info exists mom_translate] { VEC3_sub v2 mom_translate v2 }
}



#=============================================================
proc ARCTAN { y x } {
#=============================================================
   global PI

   if [EQ_is_zero $y] {
      if {$x < 0.0} {return $PI}
      return 0.0
   }

   if [EQ_is_zero $x] {
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
#  angle	      angle to be output.
#  prev_angle	previous angle output.  It should be mom_out_angle_pos
#  dir		can be either MAGNITUDE_DETERMINES_DIRECTION or 
#		      SIGN_DETERMINES_DIRECTION
#  kin_leader	leader (usually A, B or C) defined by postbuilder
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
          while {[expr abs([expr $angle - $prev_angle])] > 180.0} {
              if {[expr $angle - $prev_angle] < -180.0} {
                  set angle [expr $angle + 360.0]
              } elseif {[expr $angle - $prev_angle] > 180.0} {
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

   if [info exists mom_kin_machine_type] {

      if [string match "*3_axis_mill_turn*" $mom_kin_machine_type] {

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



