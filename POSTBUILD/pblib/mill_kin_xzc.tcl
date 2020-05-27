proc PB_CMD_kin_mill_xzc_init {} {
uplevel #0 {
   
#
# The mill/turn requires that the following procedues be placed in
# the respective events.
#
# The procedure PB_CMD_mill_xzc_init must be placed in the Start 
# of Program Event Marker 
# The procedure PB_CMD_mill_turn_before_motion must be placed in
# the PB_CMD_before_motion
# The procedure PB_CMD_linearize_motion must be placed in
# the start of the Linear Move Event Marker.
#
# This procedure initializes the current post to output
# in XZC mode for a mill/turn.  The chuck will lock and
# be used as a rotary C axis.  All XY moves will be converted
# to X and C with X being a radius value and C the angle.
# The spindle can be specified as either parallel to the Z axis
# or perpendicular the Z axis.  The tool axis of the operation
# must be consistent with the defined spindle axis.  An error
# will generated if the post cannot position to the specified
# spindle axis.
# 
#  The following choices are available as possible spindle axes.  
#
# (0,0,1) defines a live milling spindle along the zaxis.

  set mom_sys_spindle_axis(0)		"0.0"
  set mom_sys_spindle_axis(1)		"0.0"
  set mom_sys_spindle_axis(2)		"1.0"

# (1,0,0) defines a live milling spindle along the positive xaxis.

#  set mom_sys_spindle_axis(0)		"1.0"
#  set mom_sys_spindle_axis(1)		"0.0"
#  set mom_sys_spindle_axis(2)		"0.0"

# (-1,0,0) defines a live milling spindle along the negative xaxis.

#  set mom_sys_spindle_axis(0)		"-1.0"
#  set mom_sys_spindle_axis(1)		"0.0"
#  set mom_sys_spindle_axis(2)		"0.0"

# (0,1,0) defines a live milling spindle along the positive yaxis.

#  set mom_sys_spindle_axis(0)		"0.0"
#  set mom_sys_spindle_axis(1)		"1.0"
#  set mom_sys_spindle_axis(2)		"0.0"
#
#  If your machine can also position the Y axis during contouring, the
#  post will output a Y move. The variable mom_sys_millturn_yaxis defines 
#  whether the machine has a programmable yaxis for positioning the spindle.  
#  This Y axis can only be used when the k component of the tool axis is "0".  
#  The yaxis will not be used if the tool axis is 0,0,1.  
#
  set mom_sys_millturn_yaxis		"TRUE"

#
# If your controller can output either in XYZ or XZC then the UDE SET/POLAR,ON
# will define the output to be in polar mode (XZC) or in cartesian mode (XYZ).
# This can be set to either "POLAR" or "CARTESIAN"  The variable
# mom_sys_coordinate_output_mode defines the initial setting.  "POLAR" will
# ouput in xzc mode and "CARTESIAN" will output in xyz mode.
#
  set mom_sys_coordinate_output_mode    "POLAR"
  set mom_sys_output_mode               "UNDEFINED"
#
# The following variables can be used to output a G12.1 or G13.1.  This
# very common in the Fanuc controllers.  If you require different G codes
# or additional output when changing modes, see the 
# procedure PB_CMD_mill_turn_before_motion.
#
  set mom_sys_polar_mode(POLAR)	    "12.1"
  set mom_sys_polar_mode(CARTESIAN)     "13.1"

  set mom_kin_4th_axis_direction        "MAGNITUDE_DETERMINES_DIRECTION"
  set mom_kin_4th_axis_leader           "C"  
  set mom_sys_leader(fourth_axis)       "C"  
  set mom_kin_linearization_tol         "0.0001"

  if {[info exists mom_kin_arc_output_mode]} {
    set mom_sys_cartesian_arc_output_mode  $mom_kin_arc_output_mode
  } else {
    set mom_sys_cartesian_arc_output_mode "LINEAR"
  }

  if {$mom_sys_coordinate_output_mode == "POLAR"} {
    set mom_kin_arc_output_mode           "LINEAR"
  } else {
    set mom_kin_arc_output_mode          $mom_sys_cartesian_arc_output_mode
  }

  MOM_reload_kinematics

  if {$mom_sys_spindle_axis(2) == "1.0"} {
    set mom_cycle_spindle_axis 2
  } else {
    set mom_cycle_spindle_axis 0
  }
  set RADEG           57.2957795131
  set mom_kin_caxis_rotary_pos		[expr cos($mom_sys_spindle_axis(0))*$RADEG]

#=============================================================
proc MOM_set_polar { } {
#=============================================================

  global mom_sys_coordinate_output_mode mom_coordinate_output_mode
  global mom_kin_arc_output_mode prev_mom_kin_arc_output_mode

  if {$mom_coordinate_output_mode == "ON"} {
    set mom_sys_coordinate_output_mode "POLAR"
    set prev_mom_kin_arc_output_mode $mom_kin_arc_output_mode
    set mom_kin_arc_output_mode "LINEAR"
  } elseif {$mom_coordinate_output_mode == "OFF"} {
    if {[info exists prev_mom_kin_arc_output_mode]} {
      set mom_kin_arc_output_mode $prev_mom_kin_arc_output_mode
    }
    set mom_sys_coordinate_output_mode "CARTESIAN"
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

}
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

 global mom_out_angle_pos mom_sys_coordinate_output_mode mom_sys_output_mode mom_pos
 global mom_mcs_goto mom_tool_axis mom_prev_pos mom_sys_millturn_yaxis
 global prev_mom_kin_arc_output_mode mom_kin_arc_output_mode
 
  if {$mom_sys_coordinate_output_mode == "POLAR" } {
    if {$mom_sys_millturn_yaxis != "TRUE"} {MOM_suppress always Y}
    if {$mom_sys_output_mode != "POLAR" }  {
#
#  This section outputs the code needed to change the control to polar
#  output mode.  This area needs to be changed as needed.
#
      MOM_output_literal "G12.1"
      set mom_sys_output_mode "POLAR"
    }

    MILL_TURN
    MOM_reload_variable -a mom_out_angle_pos
    set mom_prev_pos(3) $mom_out_angle_pos(0)
    set mom_pos(3) $mom_out_angle_pos(0)
    MOM_reload_variable -a mom_pos
    MOM_reload_variable -a mom_prev_pos

  } elseif {$mom_sys_coordinate_output_mode == "CARTESIAN" } {
    if {$mom_sys_millturn_yaxis != "TRUE"} {MOM_suppress off Y}
    if {$mom_sys_output_mode != "CARTESIAN"} {
#
#  This section outputs the code needed to change the control to cartesian
#  output mode.  This area needs to be changed as needed.
#
      MOM_output_literal "G13.1"
      set mom_sys_output_mode "CARTESIAN"
    }  
  }
}


#=============================================================
proc PB_CMD_linearize_motion { } {
#=============================================================

  LINEARIZE_MOTION
}

#=============================================================
proc LINEARIZE_MOTION { } {
#=============================================================

  global mom_pos mom_prev_pos mom_mcs_goto mom_prev_mcs_goto 
  global mom_kin_linearization_tol mom_sys_coordinate_output_mode 
  global mom_kin_machine_resolution mom_out_angle_pos mom_sys_output_mode
  global mom_tool_axis mom_prev_tool_axis

  if {$mom_sys_coordinate_output_mode == "CARTESIAN"} {
    PB_CMD_linear_move
    return
  }

  VMOV 5 mom_pos save_pos
  VMOV 3 mom_mcs_goto save_mcs_goto
  VMOV 3 mom_tool_axis save_ta

  if {$mom_kin_linearization_tol < $mom_kin_machine_resolution} {
    set tol $mom_kin_machine_resolution
  } else {
    set tol $mom_kin_linearization_tol
  }

  CONVERT_POINT mom_prev_mcs_goto mom_prev_tool_axis mom_prev_pos
  CONVERT_BACK mom_prev_pos mom_prev_tool_axis mom_prev_mcs_goto

  set loop 0
  set count 0
  while {$loop == 0} {

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
        set mom_mcs_goto($i) [expr $mom_prev_mcs_goto($i)+($mom_mcs_goto($i)-$mom_prev_mcs_goto($i))*$error]
        set mom_tool_axis($i) [expr $mom_prev_tool_axis($i)+($mom_tool_axis($i)-$mom_prev_tool_axis($i))*$error]
      }
      for {set i 0} {$i < 5} {incr i} {
        set mom_pos($i) [expr $mom_prev_pos($i)+($mom_pos($i)-$mom_prev_pos($i))*$error]
      }
      CONVERT_POINT mom_mcs_goto mom_tool_axis mom_pos
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
  global mom_out_angle_pos mom_pos mom_prev_rot_ang_4th mom_prev_rot_ang_5th
  global mom_kin_4th_axis_direction mom_kin_5th_axis_direction
  global mom_kin_4th_axis_leader mom_kin_5th_axis_leader 
  global mom_sys_leader mom_prev_pos

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

  set mom_out_angle_pos(0) [ROTSET $mom_pos(3) $mom_prev_rot_ang_4th $mom_kin_4th_axis_direction $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)]

  set mom_prev_pos(3) $mom_out_angle_pos(0)
  set mom_pos(3) $mom_out_angle_pos(0)

  PB_CMD_linear_move

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

  set status [CONVERT_POINT mom_mcs_goto mom_tool_axis mom_pos]
  if {$status == "BAD"} {
    set mom_warning_info "Invalid Tool Axis For Mill/Turn"
    MOM_catch_warning
  }

  if {![info exists mom_prev_rot_ang_4th]} {set mom_prev_rot_ang_4th 0.0}
  set mom_out_angle_pos(0) [ROTSET $mom_pos(3) $mom_prev_rot_ang_4th \
  $mom_kin_4th_axis_direction $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)]
  set mom_prev_pos(3) $mom_out_angle_pos(0)
  set mom_pos(3) $mom_out_angle_pos(0)
  MOM_reload_variable -a mom_out_angle_pos
  MOM_reload_variable -a mom_pos
  MOM_reload_variable -a mom_prev_pos

  if {$mom_motion_type == "CYCLE"} {
    for {set i 0} {$i < 3} {incr i} {
      set mom_cycle_rapid_to_pos($i) [expr $mom_pos($i) + $mom_cycle_rapid_to*$mom_sys_spindle_axis($i)]
      set mom_cycle_feed_to_pos($i) [expr $mom_pos($i) + $mom_cycle_feed_to*$mom_sys_spindle_axis($i)]
      set mom_cycle_retract_to_pos($i) [expr $mom_pos($i) + $mom_cycle_retract_to*$mom_sys_spindle_axis($i)]
    } 
  }
}

#=============================================================
proc CONVERT_POINT { input_point tool_axis converted_point } {
#=============================================================
 
  upvar $input_point v1; upvar $tool_axis ta ; upvar $converted_point v2

  global RADEG TWOPI mom_sys_spindle_axis mom_kin_caxis_rotary_pos
  global mom_sys_millturn_yaxis mom_kin_machine_resolution
  global mom_tool_offset mom_origin mom_translate

  VMOV 3 v1 temp

  if {[info exists mom_tool_offset]} {VEC3_add temp mom_tool_offset temp}
  if {[info exists mom_origin]} {VEC3_sub temp mom_origin temp}
  if {[info exists mom_translate]} {VEC3_add temp mom_translate temp}

  if {[EQ_is_equal $mom_sys_spindle_axis(2) 1.0] && [EQ_is_equal $ta(2) 1.0]} {

    set v2(0) [expr sqrt(pow($temp(0),2) + pow($temp(1),2))]
    set v2(1) 0.0
    set v2(2) $temp(2)
    set v2(3) [expr ([ARCTAN $temp(1) $temp(0)])*$RADEG]

  } elseif {[EQ_is_equal $mom_sys_spindle_axis(2) 0.0]} {

    set cpos [expr ([ARCTAN $ta(1) $ta(0)])]
    set cout [expr $cpos - $mom_kin_caxis_rotary_pos*$RADEG]
    set crot [expr $TWOPI - $cout]

    set v2(0) [expr cos($crot)*$temp(0) - sin($crot)*$temp(1)]
    set v2(1) [expr sin($crot)*$temp(0) + cos($crot)*$temp(1)]
    set v2(2) $temp(2)
    set v2(3) [expr $cout*$RADEG]

    if {$mom_sys_millturn_yaxis == "FALSE" && [expr abs($v2(1))] > $mom_kin_machine_resolution} {
      return "BAD"
    }  
  } else {
    return "BAD"
  }
  return "OK"
}


#=============================================================
proc CONVERT_BACK { input_point tool_axis converted_point} {
#=============================================================

  upvar $input_point v1 ; upvar $tool_axis ta ; upvar $converted_point v2
  global DEGRAD mom_kin_caxis_rotary_pos mom_sys_spindle_axis
  global mom_tool_offset mom_origin mom_translate

  if {[EQ_is_equal $mom_sys_spindle_axis(2) 1.0]} {
    set v2(0) [expr cos($v1(3)*$DEGRAD)*$v1(0)]
    set v2(1) [expr sin($v1(3)*$DEGRAD)*$v1(0)]
    set v2(2) $v1(2)
    set ta(0) 0.0
    set ta(1) 0.0
    set ta(2) 1.0

  } elseif {[EQ_is_equal $mom_sys_spindle_axis(2) 0.0]} {
    set cpos [expr $v1(3) - $mom_kin_caxis_rotary_pos]
    set crot [expr $v1(3)*$DEGRAD]
    set ta(0) [expr cos($cpos*$DEGRAD)]
    set ta(1) [expr sin($cpos*$DEGRAD)]
    set ta(2) 0.0
    set v2(0) [expr cos($crot)*$v1(0) + sin($crot)*$v1(1)]
    set v2(1) [expr - sin($crot)*$v1(0) + cos($crot)*$v1(1)]
    set v2(2) $v1(2)
  }
  if {[info exists mom_tool_offset]} {VEC3_sub v2 mom_tool_offset v2}
  if {[info exists mom_origin]} {VEC3_add v2 mom_origin v2}
  if {[info exists mom_translate]} {VEC3_sub v2 mom_translate v2}
}

#=============================================================
proc ARCTAN { y x } {
#=============================================================

  global PI

  if {[EQ_is_zero $y]} {
    if {$x < 0.0} {return $PI}
    return 0.0
  }
  if {[EQ_is_zero $x]} {
    if {$y < 0.0} {return [expr $PI*1.5]}
    return [expr $PI*.5]
  }
  set ang [expr atan ($y/$x)]
  if {$x > 0.0 && $y < 0.0} {return [expr $ang+$PI*2.0]}
  if {$x < 0.0 && $y < 0.0} {return [expr $ang+$PI]}
  if {$x < 0.0 && $y > 0.0} {return [expr $ang+$PI]}
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
proc ROTSET { angle prev_angle dir kin_leader sys_leader} {
#=============================================================

#  This procedure will take an input angle and format for a specific machine.
#
#  angle	angle to be output.
#  prev_angle	previous angle out.  It should be mom_out_angle_pos
#  dir		can be either MAGNITUDE_DETERMINES_DIRECTION or 
#		SIGN_DETERMINES_DIRECTION
#  kin_leader	leader (usually A, B or C) defined by postbuilder
#  sys_leader   leader that is created by rotset.  It could be C-.
#
  upvar $sys_leader lead

  while {$angle < 0.0} {set angle [expr $angle+360.0]}
  while {$angle >= 360.0} {set angle [expr $angle-360.0]}
  if {$dir == "MAGNITUDE_DETERMINES_DIRECTION"} {
    while {[expr abs($angle-$prev_angle)] > 180.0} {
      if {[expr $angle-$prev_angle] < -180.0} {
        set angle [expr $angle+360.0]
      } elseif {[expr $angle-$prev_angle] > 180.0} {
        set angle [expr $angle-360.0]
      }
    }
  } elseif {$dir == "SIGN_DETERMINES_DIRECTION"} {
    set del [expr $angle-$prev_angle]
    if {($del < 0.0 && $del > -180.0) || $del > 180.0} {
      set lead "$kin_leader-"
    } else {
      set lead $kin_leader
    } 
  }
  return $angle
}


#=============================================================
proc PB_CMD_linear_move { } {
#=============================================================
#
#  This procedure is used my many automatic postbuilder functions 
#  to output a linear move.  Do NOT add this block to events or
#  markers.  It is a static block and it is not intended to be added
#  to events.  Do NOT change the name of this procedure.  
#
#  If you need a custom command to be output with a linear move block, 
#  you must place a call to the custom command either before or after 
#  the MOM_do_template command.
#
#  This proc is used for:
#     simulated cycles feed moves
#     mill/turn mill linearization
#     four and five axis retract and re-engage
#     

  MOM_do_template linear_move

}

#=============================================================
proc PB_CMD_kin_mill_turn_initialize { } {
#=============================================================
#
#  This procedure initializes your post for a mill/turn.
#  A mill/turn consists of a mill post and a lathe post.
#  The system will switch between the two posts based on the 
#  operation type MILL or TURN.  
#  This procedure must be placed with the Start of Program event
#  marker.  
#  The custom command PB_CMD_machine_mode must exist in
#  your post, but not placed with any event marker.
#

global mom_sys_mill_postname
global mom_sys_lathe_postname
global mom_sys_current_head 
global mom_event_handler_file_name

#
#  The following line allows you specify the name of the lathe post
#  that will be used for turning operations.  The extension
#  .def and .tcl will be appended to define the turn post.
#  The lathe post must be saved in version V2.0 or later for it to switch
#  back and forth between mill and lathe.
#  The mill post will be the current mill post where this proc is used
#

#=============================================================
set mom_sys_lathe_postname   "lathe_tool_tip"
#=============================================================

#  This post will allow you to define the output needed for switching
#  between mill and turn operations.  The following custom commands
#  will be automatically executed when switching between operation
#  types.  This is where you can assign the M or G codes needed to
#  change modes on the controller.
#
#  PB_CMD_start_of_mill -- This procedure is executed before the start
#    of a milling operation that was preceded by a turning operation.
#
#  PB_CMD_start_of_turn -- This procedure is executed before the start
#    of a turning operation that was preceded by a milling operation.
#
#  PB_CMD_end_of_mill -- This procedure is executed at the end
#    of a milling operation that is followed by a turning operation.
#
#  PB_CMD_end_of_turn -- This procedure is executed at the end
#    of a turning operation that is followed by a milling operation.
#

set mom_sys_current_head     ""

#  
#  This section will assign the name of the mill post.  Do NOT change any
#  of the following lines.
#

if {![info exists mom_sys_mill_postname]} {
  set tempfile [file tail $mom_event_handler_file_name]
  set mom_sys_mill_postname [file rootname $tempfile]
}

}


#=============================================================
proc PB_CMD_machine_mode { } {
#=============================================================
#
#  This procedure is used by a simple mill/turn post.  
#  DO NOT change any code in this procedure unless you know
#  what you are doing
#
  global mom_machine_mode 
  global mom_sys_mill_postname
  global mom_sys_lathe_postname
  global mom_load_event_handler 
  global mom_warning_info
  global mom_sys_current_head

  if {$mom_machine_mode == "MILL"} {

      if {$mom_sys_current_head == "TURN"} {catch {PB_CMD_end_of_turn}}
 
      set mom_sys_current_head "MILL"

      set mom_load_event_handler  [MOM_ask_env_var UGII_CAM_POST_DIR]$mom_sys_mill_postname.tcl
      MOM_load_definition_file  [MOM_ask_env_var UGII_CAM_POST_DIR]$mom_sys_mill_postname.def

      catch {PB_CMD_start_of_mill}
 
  } elseif {$mom_machine_mode == "TURN"} {

      if {$mom_sys_current_head == "MILL"} {catch {PB_CMD_end_of_mill}}
 
      set mom_sys_current_head "TURN"

      set mom_load_event_handler  [MOM_ask_env_var UGII_CAM_POST_DIR]$mom_sys_lathe_postname.tcl
      MOM_load_definition_file  [MOM_ask_env_var UGII_CAM_POST_DIR]$mom_sys_lathe_postname.def

      catch {PB_CMD_start_of_turn}
 
  }
}




#=============================================================
proc PB_CMD_start_of_mill { } {
#=============================================================
#
#  PB_CMD_start_of_mill -- This procedure is executed before the start
#    of a milling operation that was preceded by a turning operation.
#
#  Typical output for this command
#  MOM_output_literal "G13"
}



#=============================================================
proc PB_CMD_start_of_turn { } {
#=============================================================
#
#  PB_CMD_start_of_turn -- This procedure is executed before the start
#    of a turning operation that was preceded by a milling operation.
#
#  Typical output for this command
#  MOM_output_literal "G13"
}


#=============================================================
proc PB_CMD_end_of_mill { } {
#=============================================================
#
#  PB_CMD_end_of_mill -- This procedure is executed at the end
#    of a milling operation that is followed by a turning operation.
#
#  Typical output for this command
#  MOM_output_literal "G13"
}


#=============================================================
proc PB_CMD_end_of_turn { } {
#=============================================================
#
#  PB_CMD_end_of_turn -- This procedure is executed at the end
#    of a turning operation that is followed by a milling operation.
#
#  Typical output for this command
#  MOM_output_literal "G13"
}


#=============================================================
proc PB_CMD_kin_start_of_program {} {
#=============================================================
   PB_CMD_kin_mill_xzc_init
   PB_CMD_kin_mill_turn_initialize
}

