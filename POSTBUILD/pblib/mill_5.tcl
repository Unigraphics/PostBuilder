#=============================================================
proc PB_CMD_kin_init_rotary { } {
#=============================================================
uplevel #0 {

#
#  Fourth Axis Auto Clamping
#
#  Fourth Axis Auto Clamping is activated by programming the
#  UDE CLAMP/AUTO,ON in your tool path.  Fourth Axis Auto
#  Clamping may be turned off by programming the UDE CLAMP/AUTO,OFF.
#
#  An M10 will be output to clamp the XYZ axis for fourth axis 
#  motion. An M11 will be output to un-clamp the fourth axis 
#  when fourth axis motion occurs in the block.  You may edit 
#  the custom commands PB_CMD_clamp_fourth_axis or 
#  PB_CMD_unclamp_fourth_axis to output codes other than M10 or M11.
# 
#
#  Retract and Re-Engage Parameters
#
#  This option is activated by setting the Axis Limit Violation 
#  Handling option on the Machine Tool dialog to Retract / Re-Engage.  
#
#  The sequence of actions that take place when a rotary limit violation
#  occurs is a retract to the clearance plane at the rapid feedrate, 
#  reposition the rotary axes so they do not violate, move back to 
#  the engage point at the retract feedrate and engage into the part again.
#
#  You can set additional parameters that will control the retract 
#  and re-engage motion.
#
#  The parameter "mom_kin_retract_plane" defines the distance
#  from the center of rotation that the tool will retract when
#  an axis violation occurs.  For a four axis head machine tool the
#  retraction will be a cylinder.  For a five axis head machine tool
#  the retraction will be to a sphere. For rotary tables the
#  retraction will be to a plane along the spindle axis.
#
  set mom_kin_retract_plane                      10.0
#
#  The parameter "mom_kin_reengage_distance" defines the engage
#  point above the part.
#
  set mom_kin_reengage_distance                  .1
#
#  The following parameters are used by UG Post.  Do NOT change 
#  them unless you know what you are doing.
#
  set mom_kin_spindle_axis(0)                    0.0
  set mom_kin_spindle_axis(1)                    0.0
  set mom_kin_spindle_axis(2)                    1.0

  set PI              3.141592653589793 
  set DEGRAD          0.017453292519943 
  set RADEG           57.2957795131 
  set TWOPI	      6.283185307179586

  set mom_sys_spindle_axis(0)                    0.0
  set mom_sys_spindle_axis(1)                    0.0
  set mom_sys_spindle_axis(2)                    1.0

  set mom_sys_lock_status                        "OFF"

#=============================================================
proc MOM_clamp { } {
#=============================================================
  global mom_clamp_axis mom_clamp_status mom_sys_auto_clamp

  if {$mom_clamp_axis == "AUTO"} {
    if {$mom_clamp_status == "ON"} {
      set mom_sys_auto_clamp "ON"
    } elseif {$mom_clamp_status == "OFF"} {
      set mom_sys_auto_clamp "OFF"
    }
  }

}

#=============================================================
proc MOM_rotate { } {
#=============================================================
  global mom_rotate_axis_type mom_rotation_mode mom_rotation_direction
  global mom_rotation_angle mom_rotation_reference_mode
  global mom_kin_machine_type mom_kin_4th_axis_direction mom_kin_5th_axis_direction
  global mom_kin_4th_axis_leader mom_kin_5th_axis_leader
  global mom_kin_4th_axis_leader mom_kin_5th_axis_leader mom_pos
  global mom_out_angle_pos mom_prev_rot_ang_4th mom_prev_rot_ang_5th
  global mom_prev_pos

  if {![info exists mom_rotation_angle]} {return}

#
#  Determine which axis the user wanted, fourth or fifth.
#

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
    TABLE {
      set axis 3
    }
    HEAD {
      if {$mom_kin_machine_type == "5_axis_head_table  || $mom_kin_machine_type == "5_AXIS_HEAD_TABLE" } {
        set axis 4
      } else {
        set axis 3
      }
    }
    default {
      set axis 3
    }
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


 if {$axis == "3" && ![info exists mom_prev_rot_ang_4th]} {
    set mom_prev_rot_ang_4th [MOM_ask_address_value fourth_axis]
    if {$mom_prev_rot_ang_4th == ""} {set mom_prev_rot_ang_4th 0.0} 
  } 

 
  if {$axis == "4" && ![info exists mom_prev_rot_ang_5th]} {  
    set mom_prev_rot_ang_5th [MOM_ask_address_value fifth_axis]
    if {$mom_prev_rot_ang_5th == ""} {set mom_prev_rot_ang_5th 0.0}
  }

  set p [expr $axis + 1]
  set a [expr $axis - 3]
   if {$axis == "3" && $mom_kin_4th_axis_direction == "MAGNITUDE_DETERMINES_DIRECTION"} {
     set dirtype 0
   } elseif {$axis == "4" && $mom_kin_5th_axis_direction == "MAGNITUDE_DETERMINES_DIRECTION"} {
     set dirtype 0
   } else {
     set dirtype 1
   }

   if {$mode == 1} {
     set mom_out_angle_pos($a) $angle
   } elseif {$dirtype == 0} {
     if {$axis == 3} {
       set mom_out_angle_pos($a) [ROTSET $ang \
           $mom_prev_rot_ang_4th $mom_kin_4th_axis_direction \
           $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)]
     } else {
       set mom_out_angle_pos($a) [ROTSET $ang \
          $mom_prev_rot_ang_5th $mom_kin_5th_axis_direction \
          $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)]
     }
     if {$axis == 3} {set prot $mom_prev_rot_ang_4th}
     if {$axis == 4} {set prot $mom_prev_rot_ang_5th}
     if {$dir == 1 && $mom_out_angle_pos($a) < $prot} {
       set mom_out_angle_pos($a) [expr $mom_out_angle_pos($a) + 360.0] 
     } elseif {$dir == -1 && $mom_out_angle_pos($a) > $prot} {
       set mom_out_angle_pos($a) [expr $mom_out_angle_pos($a) - 360.0]
     }
   } elseif {$dirtype == "1"} {
     if {$dir == -1} {
       if {$axis == 3} {
         set mom_sys_leader(fourth_axis) $mom_kin_4th_axis_leader-
       } else {
         set mom_sys_leader(fifth_axis) $mom_kin_5th_axis_leader-
       }
     } elseif {$dir == 0} {
       if {$axis == 3} {
         set mom_out_angle_pos($a) [ROTSET $ang \
            $mom_prev_rot_ang_4th $mom_kin_4th_axis_direction \
            $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)]
       } else {
         set mom_out_angle_pos($a) [ROTSET $ang \
            $mom_prev_rot_ang_5th $mom_kin_5th_axis_direction \
            $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)]
       }
     } elseif {$dir == 1} {
       set mom_out_angle_pos($a) $ang
     }
  }

  if {$axis == 3} {
    PB_CMD_fourth_axis_rotate_move
  } else {
    PB_CMD_fifth_axis_rotate_move
  }

  MOM_reload_variable -a mom_prev_pos

}

#=============================================================
proc MOM_lock_axis { } {
#=============================================================
  global mom_sys_lock_value mom_sys_lock_plane
  global mom_sys_lock_axis mom_sys_lock_status

  set status [SET_LOCK axis plane value]
  if {$status == "error"} {
    MOM_catch_warning
    set mom_sys_lock_status OFF
  } else {
    set mom_sys_lock_status $status
    if {$status != "OFF"} {
      set mom_sys_lock_axis $axis
      set mom_sys_lock_plane $plane
      set mom_sys_lock_value $value
    }
  }
}

#=============================================================
proc  PB_catch_warning { } {
#=============================================================
  global mom_sys_rotary_error mom_warning_info

  if {$mom_warning_info == "ROTARY CROSSING LIMIT."} {set mom_sys_rotary_error $mom_warning_info}
  if {$mom_warning_info == "secondary rotary position being used"} {set mom_sys_rotary_error $mom_warning_info}
}



} ;# uplevel
} ;# PB_CMD_kin_init_rotary

#=============================================================
proc VMOV { n p1 p2 } {
#=============================================================

  upvar $p1 v1 ; upvar $p2 v2

  for {set i 0} {$i < $n} {incr i} {
    set v2($i) $v1($i)
  }
}

#=============================================================
proc ROTATE_VECTOR { plane angle input_vector output_vector } {
#=============================================================

  upvar $output_vector v ; upvar $input_vector v1
  if {$plane == 0} {
    set v(0) $v1(0)
    set v(1) [expr $v1(1)*cos($angle) - $v1(2)*sin($angle)]
    set v(2) [expr $v1(2)*cos($angle) + $v1(1)*sin($angle)]
  } elseif {$plane == 1} {
    set v(0) [expr $v1(0)*cos($angle) + $v1(2)*sin($angle)]
    set v(1) $v1(1)
    set v(2) [expr $v1(2)*cos($angle) - $v1(0)*sin($angle)]
  } elseif {$plane == 1} {
    set v(0) [expr $v1(0)*cos($angle) - $v1(1)*sin($angle)]
    set v(1) [expr $v1(1)*cos($angle) + $v1(0)*sin($angle)]
    set v(2) $v1(2)
  }
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
    while {[expr abs([expr $angle-$prev_angle])] > 180.0} {
      if {[expr $angle-$prev_angle] < -180.0} {
        set angle [expr $angle+360.0]
      } elseif {[expr $angle-$prev_angle] > 180.0} {
        set angle [expr $angle-360.0]
      }
    }
  } elseif {$dir == "SIGN_DETERMINES_DIRECTION"} {
    set del [expr $angle-$prev_angle]
    if {$del < 0.0 && $del > -180.0 || $del > 180.0} {
      set lead "$kin_leader-"
    } else {
      set lead $kin_leader
    } 
  }
  return $angle
}


#=============================================================
proc LOCK_AXIS_SUB { axis } {
#=============================================================

  global mom_pos mom_lock_axis_value_defined mom_lock_axis_value

  if {$mom_lock_axis_value_defined == 1} {
    return $mom_lock_axis_value 
  } else {
    return $mom_pos($axis)
  }           
}

#=============================================================
proc AXIS_SET { axis } {
#=============================================================

  global mom_sys_leader

  if {$axis == "[string index $mom_sys_leader(fourth_axis) 0]AXIS"} {
    return 3
  } elseif {$axis == "[string index $mom_sys_leader(fifth_axis) 0]AXIS"} {
    return 4
  } 
}



#=============================================================
proc SET_LOCK { axis plane value } {
#=============================================================
  
  upvar $axis a ; upvar $plane p ; upvar $value v

  global mom_kin_machine_type mom_lock_axis mom_lock_axis_plane mom_lock_axis_value
  global mom_warning_info

  switch $mom_kin_machine_type {
    4_axis_head -
    4_AXIS_HEAD -
    4_axis_table -
    4_AXIS_TABLE -
    mill_turn -
    MILL_TURN            {set mtype 4}
    5_axis_dual_table -
    5_AXIS_DUAL_TABLE -
    5_axis_dual_head -
    5_AXIS_DUAL_HEAD -
    5_axis_head_table -
    5_AXIS_HEAD_TABLE    {set mtype 5}
    default { 
      set mom_warning_info "Set lock only vaild for 4 and 5 axis machines"
      return "error"
    }
  } 
  set p -1          
  switch $mom_lock_axis {
    OFF {
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
          if {$mtype == 5} {
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
          if {$mtype == 5} {
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
          if {$mtype == 5} {
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
  return "ON"
}



#=============================================================
proc LOCK_AXIS { input_point output_point output_rotary } {
#=============================================================
 
  upvar $input_point ip ; upvar $output_point op ; upvar $output_rotary or

  global mom_kin_4th_axis_center_offset mom_kin_5th_axis_center_offset
  global mom_pos mom_kin_4th_axis_plane mom_kin_5th_axis_plane    
  global mom_sys_lock_value mom_sys_lock_plane
  global mom_sys_lock_axis mom_sys_lock_status
  global mom_out_angle_pos mom_prev_out_angle_pos mom_kin_4th_axis_direction 
  global mom_kin_5th_axis_direction mom_kin_4th_axis_leader mom_kin_5th_axis_leader
  global mom_sys_leader 
  global DEGRAD RADEG
 
  if {$mom_sys_lock_status == "OFF"} {return}
  VEC3_sub ip mom_kin_4th_axis_center_offset temp
  if {[info exists mom_kin_5th_axis_center_offset]} {
    VEC3_sub temp mom_kin_5th_axis_center_offset temp
  }
  set temp(3) $ip(3)
  set temp(4) $ip(4)

  if {$mom_sys_lock_plane == -1} {
    if {$mom_kin_4th_axis_plane == "XY"} {
      set mom_sys_lock_plane 2
    } elseif {$mom_kin_4th_axis_plane == "ZX"} {
      set mom_sys_lock_plane 1
    } elseif {$mom_kin_4th_axis_plane == "YZ"} {
      set mom_sys_lock_plane 0
    }
  } 

  if {$mom_kin_4th_axis_plane == "XY"} {
    set fourth_axis 2
  } elseif {$mom_kin_4th_axis_plane == "ZX"} {
    set fourth_axis 1
  } elseif {$mom_kin_4th_axis_plane == "YZ"} {
    set fourth_axis 0
  }

  if {[info exists mom_kin_5th_axis_plane]} {
    if {$mom_kin_5th_axis_plane == "XY"} {
      set fifth_axis 2
    } elseif {$mom_kin_5th_axis_plane == "ZX"} {
      set fifth_axis 1
    } elseif {$mom_kin_5th_axis_plane == "YZ"} {
      set fifth_axis 0
    }
  } else {
    set fifth_axis -1
  }


  if {$mom_sys_lock_axis > 2} {
    set angle [expr ($mom_sys_lock_value-$temp($mom_sys_lock_axis))*$DEGRAD]
    ROTATE_VECTOR $mom_sys_lock_plane $angle temp temp1
    VMOV 3 temp1 temp
    set temp($mom_sys_lock_axis) $mom_sys_lock_value
  } else {
    if {$mom_sys_lock_plane == 0} {
      set i1 1
      set i2 2
    } elseif {$mom_sys_lock_plane == 1} {
      set i1 2
      set i2 0
    } elseif {$mom_sys_lock_plane == 2} {
      set i1 0
      set i2 1
    }
    set unlocked_axis [expr $i1 + $i2 - $mom_sys_lock_axis]
    set rad [expr sqrt($temp($i1)*$temp($i1) + $temp($i2)*$temp($i2))]
    set angle [ARCTAN $temp($i2) $temp($i1)]
    if { $rad < [expr abs($mom_sys_lock_value)]} {
      if {$mom_sys_lock_value < 0.0} {
        set temp($mom_sys_lock_axis) [expr -$rad]
      } else {
        set temp($mom_sys_lock_axis) $rad
      }
    } else {
      set temp($mom_sys_lock_axis) $mom_sys_lock_value
    }
    set temp($unlocked_axis) [expr sqrt($rad*$rad - $temp($mom_sys_lock_axis)*$temp($mom_sys_lock_axis))]
    if {$mom_sys_lock_plane == $fourth_axis || $mom_sys_lock_plane == $fifth_axis} {
      VMOV 5 temp temp1
      set temp1($unlocked_axis) [expr -$temp($unlocked_axis)]
      set ang1 [ARCTAN $temp($i2) $temp($i1)]
      set ang2 [ARCTAN $temp1($i2) $temp1($i1)]
      if {$mom_sys_lock_plane == $fourth_axis} {
        set i1 3
      } else {
        set i1 4
      }
      set temp($i1) [expr ($angle-$ang1)*$RADEG]
      set temp1($i1) [expr ($angle-$ang2)*$RADEG]
      set ang1 [LIMIT_ANGLE [expr $ip($i1)-$temp($i1)]]
      set ang2 [LIMIT_ANGLE [expr $ip($i1)-$temp1($i1)]]
      if {$ang1 > 180.0} {set ang1 [LIMIT_ANGLE [expr -$ang1]]}  
      if {$ang2 > 180.0} {set ang2 [LIMIT_ANGLE [expr -$ang2]]}
      if {$ang1 > $ang2} {VMOV 5 temp1 temp}
    }
  }


  VEC3_add temp mom_kin_4th_axis_center_offset op
  if {[info exists mom_kin_5th_axis_center_offset]} {
    VEC3_add op mom_kin_5th_axis_center_offset op
  }

  if {![info exists or]} {
    set or(0) 0.0
    set or(1) 0.0
  }
  if {![info exists mom_prev_out_angle_pos]} {
    set mom_prev_out_angle_pos(0) $or(0)
    set mom_prev_out_angle_pos(1) $or(1)
  }

  set or(0) [ROTSET $temp(3) $mom_prev_out_angle_pos(0) $mom_kin_4th_axis_direction $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)]
  if {[info exists mom_kin_5th_axis_direction]} {
    set or(1) [ROTSET $temp(4) $mom_prev_out_angle_pos(1) $mom_kin_5th_axis_direction $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)]
  }

  set op(3) $temp(3)
  set op(4) $temp(4)
}

#=============================================================
proc ROTARY_AXIS_RETRACT { } {
#=============================================================
#
#  This procedure is used by four and five axis posts to retract
#  from the part when the rotary axis become discontinuous.  This
#  procedure must be placed in the MOM_before_motion event.  
#
  global mom_kin_retract_plane mom_kin_reengage_distance
  global mom_kin_rotary_reengage_feedrate mom_kin_rapid_feed_rate                      
  global mom_sys_rotary_error mom_pos mom_prev_pos 
  global mom_prev_rot_ang_4th mom_prev_rot_ang_5th 
  global mom_kin_4th_axis_direction mom_kin_4th_axis_leader 
  global mom_out_angle_pos mom_kin_5th_axis_direction mom_kin_5th_axis_leader 
  global mom_kin_4th_axis_center_offset mom_kin_5th_axis_center_offset
  global mom_sys_leader mom_tool_axis mom_prev_tool_axis mom_kin_4th_axis_type
  global mom_kin_spindle_axis mom_motion_event
  global mom_alt_pos mom_prev_alt_pos mom_feed_rate 
  global mom_kin_rotary_reengage_feedrate 
  global mom_feed_engage_value mom_feed_cut_value
  global mom_kin_4th_axis_limit_action mom_warning_info

  if {[info exists mom_sys_rotary_error] && [info exists mom_motion_event]} {
    if {$mom_sys_rotary_error != 0 && $mom_motion_event == "linear_move"} { 

    if {$mom_kin_4th_axis_limit_action == "Warning"} {
       set mom_warning_info "Rotary axis limit violated, discontinuos motion may result"
       MOM_catch_warning
       unset mom_sys_rotary_error
       return 
    }


  if {$mom_sys_rotary_error == "ROTARY CROSSING LIMIT." } {
    set roterr 0
  } else {
    set roterr 1
  }

  unset mom_sys_rotary_error

# Retract from part

  VMOV 5 mom_pos save_pos
  VMOV 5 mom_prev_pos save_prev_pos
  VMOV 2 mom_out_angle_pos save_out_angle_pos
  set save_feedrate $mom_feed_rate

  set cen(0) 0.0
  set cen(1) 0.0
  set cen(2) 0.0
  if {[info exists mom_kin_4th_axis_center_offset]} {
    VEC3_add cen mom_kin_4th_axis_center_offset cen
  }
  if {[info exists mom_kin_5th_axis_center_offset]} {
    VEC3_sub cen mom_kin_5th_axis_center_offset cen
  }
  if {$mom_kin_4th_axis_type == "Table"} {
    set num_sol [CALC_CYLINDRICAL_RETRACT_POINT mom_prev_pos mom_kin_spindle_axis $mom_kin_retract_plane ret_pt]
  } else {
    set num_sol [CALC_SPHERICAL_RETRACT_POINT mom_prev_pos mom_prev_tool_axis cen $mom_kin_retract_plane ret_pt]
  }

  
  set mom_feed_rate $mom_kin_rapid_feed_rate                      
  FEEDRATE_SET
  

  if {$num_sol != 0} {
    MOM_suppress once fourth_axis fifth_axis
    VEC3_add ret_pt cen mom_pos
    PB_CMD_linear_move
  }

# temporary fix for missing mom_prev_rot_ang_4th
#
  if {![info exists mom_prev_rot_ang_4th]} {  
    set mom_prev_rot_ang_4th [MOM_ask_address_value fourth_axis]
  }
  if {![info exists mom_prev_rot_ang_5th]} {  
    set mom_prev_rot_ang_5th [MOM_ask_address_value fifth_axis]
  }


  if {$roterr == 0} {
#
# unwind table
#
    if {[info exists mom_kin_4th_axis_direction]} {
      set mom_out_angle_pos(0) [ROTSET $mom_prev_pos(3) $mom_out_angle_pos(0) $mom_kin_4th_axis_direction $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)]
    }
    if {[info exists mom_kin_5th_axis_direction]} {
      set mom_out_angle_pos(1) [ROTSET $mom_prev_pos(4) $mom_out_angle_pos(1) $mom_kin_5th_axis_direction $mom_kin_5th_axis_leader mom_sys_leader(fourth_axis)]
    }
    MOM_suppress once X Y Z
    PB_CMD_linear_move
    for {set i 0} {$i < 3} {incr i} {
      set mom_pos($i) [expr $mom_prev_pos($i)+$mom_kin_reengage_distance*$mom_kin_spindle_axis($i)]
    }
    MOM_suppress once fourth_axis fifth_axis
    PB_CMD_linear_move
    VMOV 3 mom_prev_pos mom_pos
    MOM_suppress once fourth_axis fifth_axis
    if {$mom_feed_engage_value  > 0.0} {
      set mom_feed_rate $mom_feed_engage_value  
    } elseif {$mom_feed_cut_value  > 0.0} {
      set mom_feed_rate $mom_feed_cut_value  
    } else {
      set mom_feed_rate 10.0
    }
    FEEDRATE_SET
    PB_CMD_linear_move
    VMOV 5 save_pos mom_pos
    VMOV 5 save_prev_pos mom_prev_pos
    VMOV 2 save_out_angle_pos mom_out_angle_pos
  } else {
#
# move to alternate rotary position
#
    set mom_out_angle_pos(0) [ROTSET $mom_prev_alt_pos(3) $mom_prev_rot_ang_4th $mom_kin_4th_axis_direction $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)]
    set mom_out_angle_pos(1) [ROTSET $mom_prev_alt_pos(4) $mom_prev_rot_ang_5th $mom_kin_5th_axis_direction $mom_kin_5th_axis_leader mom_sys_leader(fourth_axis)]
    MOM_suppress once X Y Z
    PB_CMD_linear_move
    for {set i 0} {$i < 3} {incr i} {
      set mom_pos($i) [expr $mom_prev_alt_pos($i)+$mom_kin_reengage_distance*$mom_prev_tool_axis($i)]
    }
    MOM_suppress once fourth_axis fifth_axis
    PB_CMD_linear_move
    VMOV 3 mom_prev_alt_pos mom_pos
    MOM_suppress once fourth_axis fifth_axis
    if {$mom_feed_engage_value  > 0.0} {
      set mom_feed_rate $mom_feed_engage_value  
    } elseif {$mom_feed_cut_value  > 0.0} {
      set mom_feed_rate $mom_feed_cut_value  
    } else {
      set mom_feed_rate 10.0
    }
    FEEDRATE_SET
    PB_CMD_linear_move

    VMOV 5 save_pos mom_pos
    VMOV 5 save_prev_pos mom_prev_pos

    set mom_out_angle_pos(0) [ROTSET $mom_pos(3) $mom_out_angle_pos(0) $mom_kin_4th_axis_direction $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)]
    set mom_out_angle_pos(1) [ROTSET $mom_pos(4) $mom_out_angle_pos(1) $mom_kin_5th_axis_direction $mom_kin_5th_axis_leader mom_sys_leader(fourth_axis)]

    MOM_reload_variable -a mom_out_angle_pos
  }

  set save_feedrate $mom_feed_rate
  FEEDRATE_SET

 }
 }
}

#=============================================================
proc SOLVE_QUADRATIC { coeff rcomp icomp status degree } {
#=============================================================

  upvar $coeff c ; upvar $rcomp rc ; upvar $icomp ic; upvar $status st ; upvar $degree deg 

  set st 1
  set deg 0
  set rc(0) 0.0 ; set rc(1) 0.0
  set ic(0) 0.0 ; set ic(1) 0.0
  set mag [VEC3_mag c]
  if {[EQ_is_zero $mag]} {return 0}
  set acoeff [expr $c(2)/$mag]
  set bcoeff [expr $c(1)/$mag]
  set ccoeff [expr $c(0)/$mag]
  if {![EQ_is_zero $acoeff]} {
    set deg 2
    set denom [expr $acoeff*2.]
    set dscrm [expr $bcoeff*$bcoeff - $acoeff*$ccoeff*4.0]
    if {[EQ_is_zero $dscrm]} {
      set dsqrt1 0.0
    } else {
      set dsqrt1 [expr sqrt(abs($dscrm))]
    }
    if {[EQ_is_ge $dscrm 0.0]} {
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
  } elseif {![EQ_is_zero $bcoeff] } {
    set st 3
    set deg 1
    set rc(0) [expr -$ccoeff/$bcoeff]
    return 1
  } elseif {[EQ_is_zero $ccoeff] } {
    return 0
  } else {
    return 0
  }
}

#=============================================================
proc CALC_SPHERICAL_RETRACT_POINT { refpt axis cen_sphere rad_sphere int_pts } {
#=============================================================

  upvar $refpt rp ; upvar $axis ta ; upvar $cen_sphere cs 
  upvar $int_pts ip  

  set rad [expr $rad_sphere*$rad_sphere]
  VEC3_sub rp cs v1

  set coeff(2) 1.0
  set coeff(1) [expr ($v1(0)*$ta(0) + $v1(1)*$ta(1) + $v1(2)*$ta(2))*2.0]
  set coeff(0) [expr $v1(0)*$v1(0) + $v1(1)*$v1(1) + $v1(2)*$v1(2) - $rad]

  set num_sol [SOLVE_QUADRATIC coeff roots iroots status degree]
  if {$num_sol == 0} {return 0}

  if {[expr $roots(0)] > [expr $roots(1)] || $num_sol == 1} {
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
proc CALC_CYLINDRICAL_RETRACT_POINT {refpt axis dist ret_pt} {
#=============================================================
  upvar $refpt rfp ; upvar $axis ax ; upvar $ret_pt rtp 

#
# return 0 parallel or lies on plane
#        1 unique intersection
#


#
# create plane canonical form
#
  VMOV 3 ax plane
  set plane(3) $dist

  set num [expr $plane(3)-[VEC3_dot rfp plane]]
  set dir [VEC3_dot ax plane]
  if {[EQ_is_zero $dir]} {return 0}
  for {set i 0} {$i < 3} {incr i} {
    set rtp($i) [expr $rfp($i) + $ax($i)*$num/$dir]
  }
  return [RETRACT_POINT_CHECK rfp ax rtp]
} 

#=============================================================
proc RETRACT_POINT_CHECK {refpt axis retpt} {
#=============================================================
  upvar $refpt rfp ; upvar $axis ax ; upvar $retpt rtp 

# 
#  determine if retraction point is "below" the retraction plane
#  if the tool is already in a safe position, do not retract
#
#  return 0	no retract needed
#         1     retraction needed
#

  VEC3_sub rtp rfp vec
  if {[VEC3_is_zero vec]} {return 0}
  set x [VEC3_unitize vec vec1]
  set dir [VEC3_dot ax vec1]
  if {$dir <= 0.0} {
    return 0
  } else {
    return 1
  } 
} 

#=============================================================
proc REPOSITION_ERROR_CHECK { warn } {
#=============================================================
  global mom_kin_4th_axis_max_limit mom_kin_4th_axis_min_limit 
  global mom_kin_5th_axis_max_limit mom_kin_5th_axis_min_limit 
  global mom_pos mom_prev_pos mom_alt_pos mom_alt_prev_pos
  global mom_sys_rotary_error mom_warning_info mom_kin_machine_type

  if {$warn != "secondary rotary position being used" || [string index $mom_kin_machine_type 0] != 5} {
    set mom_sys_rotary_error $warn
    return
  }

  set mom_sys_rotary_error 0

  set a4 [expr $mom_alt_pos(3)+360.0]
  set a5 [expr $mom_alt_pos(4)+360.0]
  while {[expr $a4-$mom_kin_4th_axis_min_limit] > 360.0} {set a4 [expr $a4-360.0]}
  while {[expr $a5-$mom_kin_5th_axis_min_limit] > 360.0} {set a5 [expr $a5-360.0]}
  if {$a4 <= $mom_kin_4th_axis_max_limit && $a5 <= $mom_kin_5th_axis_max_limit} {return}

  for {set i 0} {$i < 2} {incr i} {
    set rot($i) [expr $mom_pos([expr $i+3]) - $mom_prev_pos([expr $i+3])]
    while {$rot($i) > 180.0} {set rot($i) [expr $rot($i)-360.0]}
    while {$rot($i) < 180.0} {set rot($i) [expr $rot($i)+360.0]}
    set rot($i) [expr abs($rot($i))]

    set rotalt($i) [expr $mom_alt_pos([expr $i+3]) - $mom_prev_pos([expr $i+3])]
    while {$rotalt($i) > 180.0} {set rotalt($i) [expr $rotalt($i)-360.0]}
    while {$rotalt($i) < 180.0} {set rotalt($i) [expr $rotalt($i)+360.0]}
    set rotalt($i) [expr abs($rotalt($i))]
  }

  if {[EQ_is_equal [expr $rot(0)+$rot(1)] [expr $rotalt(0)+$rotalt(1)]]} {return}
  set mom_sys_rotary_error $warn
}

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

  MOM_do_template linear_move_1

}


#=============================================================
proc AUTO_CLAMP { } {
#=============================================================
#
#  This procedure is used to automaticaaly output clamp and unclamp
#  codes.  This procedure must be placed in the the procedure
#  PB_CMD_before_motion.  By default this procedure will output
#  M10 or M11 to do the clamping and unclamping.
#
global clamp_rotary_status mom_pos mom_prev_pos mom_sys_auto_clamp

if {![info exists mom_sys_auto_clamp]} {return}
if {$mom_sys_auto_clamp != "ON"} {return}

if {![info exists clamp_rotary_status]} {set clamp_rotary_status "UNDEFINED"}

set rotary_out [EQ_is_equal $mom_pos(3) $mom_prev_pos(3)]

if {$rotary_out  == 0 && $clamp_rotary_status != "UNCLAMPED"} {
  PB_CMD_unclamp_fourth_axis
  set clamp_rotary_status "UNCLAMPED"
} elseif {$rotary_out == 1 && $clamp_rotary_status != "CLAMPED"} {
  PB_CMD_clamp_fourth_axis
  set clamp_rotary_status "CLAMPED"
}
}

#=============================================================
proc PB_kin_before_motion { } {
#=============================================================

  global mom_sys_lock_status mom_sys_rotary_error 
  global mom_kin_4th_axis_limit_action mom_kin_5th_axis_limit_action 

  if {[info exists mom_sys_lock_status] && $mom_sys_lock_status != "OFF"} {LOCK_AXIS_MOTION}
  if {[info exists mom_sys_rotary_error]} {
     if {$mom_kin_4th_axis_limit_action == "Retract / Re-Engage" || $mom_kin_4th_axis_limit_action == "Retract / Re-Engage"} {ROTARY_AXIS_RETRACT}
  }
}

#=============================================================
proc LOCK_AXIS_MOTION { } {
#=============================================================
#
#  The UDE lock_axis must be specified in the tool path
#  for the post to lock the requested axis.  The UDE lock_axis may only
#  be used for four and five axis machine tools.  A four axis post may
#  only lock an axis in the plane of the fourth axis.  If you have a
#  five axis machine you must specify a plane since there are two 
#  possible planes.
#
  global mom_pos mom_out_angle_pos mom_current_motion mom_motion_type
  global mom_cycle_feed_to_pos mom_cycle_feed_to mom_tool_axis
  global mom_motion_event mom_sys_lock_status 
  global mom_cycle_rapid_to_pos mom_cycle_retract_to_pos
  global mom_cycle_rapid_to mom_cycle_retract_to 

  if {$mom_sys_lock_status == "ON"} {  
    if {$mom_current_motion != "circular_move"} {
      LOCK_AXIS mom_pos mom_pos mom_out_angle_pos
      if {$mom_motion_type == "CYCLE"} {
        if {$mom_motion_event == "initial_move"} {
           set mom_pos(0) [expr $mom_pos(0) - $mom_cycle_rapid_to * $mom_tool_axis(0)]
           set mom_pos(1) [expr $mom_pos(1) - $mom_cycle_rapid_to * $mom_tool_axis(1)]
           set mom_pos(2) [expr $mom_pos(2) - $mom_cycle_rapid_to * $mom_tool_axis(2)]
        }
        set mom_cycle_feed_to_pos(0) [expr $mom_pos(0) + $mom_cycle_feed_to * $mom_tool_axis(0)]
        set mom_cycle_feed_to_pos(1) [expr $mom_pos(1) + $mom_cycle_feed_to * $mom_tool_axis(1)]
        set mom_cycle_feed_to_pos(2) [expr $mom_pos(2) + $mom_cycle_feed_to * $mom_tool_axis(2)]    
 
        set mom_cycle_rapid_to_pos(0) [expr $mom_pos(0) + $mom_cycle_rapid_to * $mom_tool_axis(0)]
        set mom_cycle_rapid_to_pos(1) [expr $mom_pos(1) + $mom_cycle_rapid_to * $mom_tool_axis(1)]
        set mom_cycle_rapid_to_pos(2) [expr $mom_pos(2) + $mom_cycle_rapid_to * $mom_tool_axis(2)]    
 
        set mom_cycle_retract_to_pos(0) [expr $mom_pos(0) + $mom_cycle_retract_to * $mom_tool_axis(0)]
        set mom_cycle_retract_to_pos(1) [expr $mom_pos(1) + $mom_cycle_retract_to * $mom_tool_axis(1)]
        set mom_cycle_retract_to_pos(2) [expr $mom_pos(2) + $mom_cycle_retract_to * $mom_tool_axis(2)]    
      }
    }
  }
}

#=============================================================
proc PB_CMD_kin_before_motion { } {
#=============================================================
#
#  This custom command is used by UG Post to support Set/Lock, 
#  rotary axis limit violation retracts and auto clamping.  
#  Do not change this procedure.  If you want to improve 
#  performance, you may comment out any of these procedures.
#  

  LOCK_AXIS_MOTION

  ROTARY_AXIS_RETRACT

  AUTO_CLAMP
}


#=============================================================
proc PB_CMD_kin_start_of_program {} {
#=============================================================
   PB_CMD_kin_init_rotary
}

