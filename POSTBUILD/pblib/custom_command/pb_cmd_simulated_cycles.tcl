##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc VMOV { n p1 p2 } {
#=============================================================
  upvar $p1 v1 ; upvar $p2 v2

  for {set i 0} {$i < $n} {incr i} {
    set v2($i) $v1($i)
  }
}



#=============================================================
proc CYCLE_TOOL_AXIS {  } {
#=============================================================
  global mom_cycle_rapid_to_pos 
  global mom_cycle_feed_to_pos 
  global mom_cycle_retract_to_pos
  global mom_cycle_rapid_to 
  global mom_cycle_feed_to 
  global mom_cycle_rapid_to 
  global mom_cycle_feed_to 
  global mom_cycle_retract_to
  global mom_kin_4th_axis_type 
  global mom_kin_5th_axis_type 
  global mom_kin_4th_axis_plane
  global mom_kin_5th_axis_plane
  global top_of_hole 
  global mom_tool_axis 
  global mom_sys_spindle_axis 
  global mom_motion_type 
  global mom_kin_spindle_axis
  global mom_pos
  global DEG2RAD
  global mom_spindle_axis

  PB_CMD_init_spindle_axis

  set mom_motion_type "SIMULATED_CYCLES"

  if [info exists mom_spindle_axis] {
    VMOV 3 mom_spindle_axis mom_sys_spindle_axis 
  } elseif { ![string compare "Table" $mom_kin_4th_axis_type] } {
    VMOV 3 mom_kin_spindle_axis mom_sys_spindle_axis 
  } elseif { ![string compare "Table" $mom_kin_5th_axis_type] } {
    VMOV 3 mom_tool_axis vec1
    set ang [expr -$mom_pos(4)*$DEG2RAD]
    if { ![string compare "XY" $mom_kin_5th_axis_plane] } {
    ROTATE_VECTOR 2 $ang vec1 vec 
    } elseif { ![string compare "ZX" $mom_kin_5th_axis_plane] } {
      ROTATE_VECTOR 1 $ang vec1 vec 
    } elseif { ![string compare "YZ" $mom_kin_5th_axis_plane] } {
      ROTATE_VECTOR 0 $ang vec1 vec 
    }
    if { ![string compare "XY" $mom_kin_4th_axis_plane] } {
      set vec(2) 0.0
    } elseif { ![string compare "ZX" $mom_kin_4th_axis_plane] } {
      set vec(1) 0.0
    } elseif { ![string compare "YZ" $mom_kin_4th_axis_plane] } {
      set vec(0) 0.0
    }
    set l [VEC3_unitize vec mom_sys_spindle_axis]
    if [EQ_is_zero $l] {
      set mom_sys_spindle_axis(2) 1.0
    } else {
      VMOV 3 mom_tool_axis mom_sys_spindle_axis
    }
  }

  for {set i 0} {$i < 3} {incr i} {
    set top_of_hole($i) [expr $mom_cycle_rapid_to_pos($i) - $mom_cycle_rapid_to*$mom_sys_spindle_axis($i)] 
  }

  for {set i 0} {$i < 3} {incr i} {
    set mom_cycle_rapid_to_pos($i) [expr $top_of_hole($i) + $mom_cycle_rapid_to*$mom_sys_spindle_axis($i)]
    set mom_cycle_feed_to_pos($i) [expr $top_of_hole($i) + $mom_cycle_feed_to*$mom_sys_spindle_axis($i)]
    set mom_cycle_retract_to_pos($i) [expr $top_of_hole($i) + $mom_cycle_retract_to*$mom_sys_spindle_axis($i)]
  }
}


#=============================================================
proc SIM_RAPID_APPROACH { pos } {
#=============================================================
  upvar $pos p  

  global mom_pos mom_sys_spindle_axis mom_prev_pos

  VEC3_sub p mom_prev_pos v1
  if {[VEC3_is_zero v1]} {return}
  set dist [VEC3_unitize v1 v2]
  set dot [VEC3_dot v2 mom_sys_spindle_axis]
  set dist [expr $dist*$dot]
  VEC3_scale dist mom_sys_spindle_axis sp_move
  VEC3_sub v1 sp_move trav_move

  if {$dist < 0.0} {
    if {![VEC3_is_zero trav_move]} {
      VEC3_add mom_prev_pos trav_move v1
      SIM_RAPID v1
    }
    if {![VEC3_is_zero sp_move]} {
      SIM_RAPID p
    }
  } else {
    if {![VEC3_is_zero sp_move]} {
      VEC3_add mom_prev_pos sp_move v1
      SIM_RAPID v1
    }
    if {![VEC3_is_zero trav_move]} {
      SIM_RAPID p
    }
  }
}


#=============================================================
proc SIM_RAPID { pos } {
#=============================================================
  upvar $pos p  

  global mom_pos mom_kin_rapid_feed_rate feed

#  set mom_feed_rate $mom_kin_rapid_feed_rate

#  FEEDRATE_SET

  set feed $mom_kin_rapid_feed_rate

  VMOV 3 p mom_pos
  PB_CMD_linear_move
  MOM_reload_variable -a mom_pos
}


#=============================================================
proc SIM_FEED { pos } {
#=============================================================
  upvar $pos p

  global mom_pos mom_cycle_feed_rate mom_feed_rate feed

#  set mom_feed_rate $mom_cycle_feed_rate

#  FEEDRATE_SET
  set feed $mom_cycle_feed_rate

  VMOV 3 p mom_pos
  PB_CMD_linear_move
  MOM_reload_variable -a mom_pos
}


#=============================================================
proc SIM_RTRCTO { } {
#=============================================================
  global mom_cycle_retract_to_pos mom_cycle_rapid_to_pos mom_sys_spindle_axis

  VEC3_sub mom_cycle_retract_to_pos mom_cycle_rapid_to_pos v1
  if {[EQ_is_gt [VEC3_dot v1 mom_sys_spindle_axis] 0.0]} {SIM_RAPID mom_cycle_retract_to_pos}
}


#=============================================================
proc CYCLE_SET { } {
#=============================================================
}




#=============================================================
proc PB_CMD_sim_cycle_drill_move { } {
#=============================================================
  global mom_cycle_rapid_to_pos mom_cycle_feed_to_pos mom_cycle_retract_to_pos

  CYCLE_TOOL_AXIS 

  SIM_RAPID_APPROACH mom_cycle_rapid_to_pos
  SIM_FEED mom_cycle_feed_to_pos
  SIM_RAPID mom_cycle_retract_to_pos
}


#=============================================================
proc PB_CMD_sim_cycle_drill_dwell_move { } {
#=============================================================
  global mom_cycle_rapid_to_pos mom_cycle_feed_to_pos mom_cycle_rapid_to_pos
  global mom_delay_value mom_cycle_delay mom_cycle_retract_to_pos

  CYCLE_TOOL_AXIS 
  SIM_RAPID_APPROACH mom_cycle_rapid_to_pos
  SIM_FEED mom_cycle_feed_to_pos

  if {![info exists mom_cycle_delay]} {
    set mom_delay_value 2.0
  } else { 
    set mom_delay_value $mom_cycle_delay
  }

  MOM_force once dwell G
  MOM_do_template delay
  SIM_RAPID mom_cycle_retract_to_pos
}


#=============================================================
proc PB_CMD_sim_cycle_drill_deep_move { } {
#=============================================================
  global mom_cycle_step1 top_of_hole mom_cycle_rapid_to mom_cycle_rapid_to_pos
  global mom_cycle_feed_to mom_sys_spindle_axis mom_cycle_retract_to_pos
  global mom_kin_machine_resolution mom_warning_info

#<sws 5100196>
  if {$mom_cycle_step1 < $mom_kin_machine_resolution} {
    set mom_warning_info "Cycle step increment not specified, Drilling cycle will be output."
    MOM_catch_warning
    PB_CMD_sim_cycle_drill_move
    return
  }
#<sws 5100196>

  CYCLE_TOOL_AXIS 

  SIM_RAPID_APPROACH mom_cycle_rapid_to_pos

  set deep_depth [expr -$mom_cycle_step1]
  set rapid_pos $mom_cycle_rapid_to

  while { $mom_cycle_feed_to < $deep_depth } {
    set deep_rapto [expr $deep_depth + $mom_cycle_rapid_to + $mom_cycle_step1 ]
    if { $rapid_pos > $deep_rapto } {
      for {set i 0} {$i < 3} {incr i} {
        set pos($i) [expr $top_of_hole($i) + $deep_rapto*$mom_sys_spindle_axis($i)]
      }
      SIM_RAPID pos 
    }
    for {set i 0} {$i < 3} {incr i} {
      set pos($i) [expr $top_of_hole($i) + $deep_depth*$mom_sys_spindle_axis($i)]
    }
    SIM_FEED pos 
    SIM_RAPID mom_cycle_rapid_to_pos 
    set deep_depth [expr $deep_depth - $mom_cycle_step1]
  }

  set deep_rapto [expr $deep_depth + $mom_cycle_rapid_to + $mom_cycle_step1 ]

  if { $rapid_pos > $deep_rapto } {
    for {set i 0} {$i < 3} {incr i} {
      set pos($i) [expr $top_of_hole($i) + $deep_rapto*$mom_sys_spindle_axis($i)]
    }
    SIM_RAPID pos 
  }

  for {set i 0} {$i < 3} {incr i} {
#<sws 5100196>
    set pos($i) [expr $top_of_hole($i) + $mom_cycle_feed_to*$mom_sys_spindle_axis($i)]
  }

  SIM_FEED pos 
  SIM_RAPID mom_cycle_retract_to_pos 
}


#=============================================================
proc PB_CMD_sim_cycle_drill_break_chip_move { } {
#=============================================================
  global mom_cycle_step1 top_of_hole mom_cycle_rapid_to mom_cycle_rapid_to_pos
  global mom_cycle_feed_to mom_sys_spindle_axis mom_cycle_retract_to_pos
  global mom_kin_machine_resolution mom_warning_info
#<sws 5100196>
  if {$mom_cycle_step1 < $mom_kin_machine_resolution} {
    set mom_warning_info "Cycle step increment not specified, Drilling cycle will be output."
    MOM_catch_warning
    PB_CMD_sim_cycle_drill_move
    return
  }
#<sws>

  CYCLE_TOOL_AXIS 

  SIM_RAPID_APPROACH mom_cycle_rapid_to_pos

  set deep_depth [expr -$mom_cycle_step1]
  set rapid_pos $mom_cycle_rapid_to

  while { $mom_cycle_feed_to < $deep_depth } {
    set deep_rapto [expr $deep_depth + $mom_cycle_rapid_to + $mom_cycle_step1 ]
    if { $rapid_pos > $deep_rapto } {
      for {set i 0} {$i < 3} {incr i} {
        set pos($i) [expr $top_of_hole($i) + $deep_rapto*$mom_sys_spindle_axis($i)]
      }
      SIM_RAPID pos 
    }
    for {set i 0} {$i < 3} {incr i} {
      set pos($i) [expr $top_of_hole($i) + $deep_depth*$mom_sys_spindle_axis($i)]
    }
    SIM_FEED pos 
    set deep_depth [expr $deep_depth - $mom_cycle_step1]
  }

  set deep_rapto [expr $deep_depth + $mom_cycle_rapid_to + $mom_cycle_step1 ]

  if { $rapid_pos > $deep_rapto } {
    for {set i 0} {$i < 3} {incr i} {
      set pos($i) [expr $top_of_hole($i) + $deep_rapto*$mom_sys_spindle_axis($i)]
    }
    SIM_RAPID pos 
  }

  for {set i 0} {$i < 3} {incr i} {
#<sws 5100196>
    set pos($i) [expr $top_of_hole($i) + $mom_cycle_feed_to*$mom_sys_spindle_axis($i)]
  }

  SIM_FEED pos 
  SIM_RAPID mom_cycle_retract_to_pos 
}


#=============================================================
proc PB_CMD_sim_cycle_tap_move { } {
#=============================================================
  global mom_cycle_retract_to_pos mom_cycle_rapid_to_pos mom_cycle_feed_to_pos
  global mom_spindle_direction

  CYCLE_TOOL_AXIS 

  SIM_RAPID_APPROACH mom_cycle_rapid_to_pos
  SIM_FEED mom_cycle_feed_to_pos
  MOM_do_template spindle_off
  set save_dir $mom_spindle_direction

  if { ![string compare "CLW" $mom_spindle_direction] } {
    set mom_spindle_direction "CCLW"
  } elseif { ![string compare "CCLW" $mom_spindle_direction] } {
    set mom_spindle_direction "CLW"
  }

  MOM_do_template spindle_rpm  
  SIM_FEED mom_cycle_rapid_to_pos
  set mom_spindle_direction $save_dir 
  SIM_RTRCTO
}


#=============================================================
proc PB_CMD_sim_cycle_bore_move { } {
#=============================================================
  global mom_cycle_retract_to_pos mom_cycle_rapid_to_pos mom_cycle_feed_to_pos

  CYCLE_TOOL_AXIS 

  SIM_RAPID_APPROACH mom_cycle_rapid_to_pos
  SIM_FEED mom_cycle_feed_to_pos
  SIM_FEED mom_cycle_rapid_to_pos
  SIM_RTRCTO
}


#=============================================================
proc PB_CMD_sim_cycle_bore_drag_move { } {
#=============================================================
  global mom_cycle_retract_to_pos mom_cycle_rapid_to_pos mom_cycle_feed_to_pos

  CYCLE_TOOL_AXIS 

  SIM_RAPID_APPROACH mom_cycle_rapid_to_pos
  SIM_FEED mom_cycle_feed_to_pos
  MOM_do_template spindle_off
  SIM_RAPID mom_cycle_retract_to_pos 
  MOM_force once M_spindle
  MOM_do_template spindle_rpm   
}


#=============================================================
proc PB_CMD_sim_cycle_bore_no_drag_move { } {
#=============================================================
  global mom_cycle_retract_to_pos mom_cycle_rapid_to_pos mom_sys_spindle_axis
  global nodrag_offset_move mom_cycle_feed_to_pos mom_cycle_orient
  global mom_cycle_retract_to mom_cycle_feed_to

  CYCLE_TOOL_AXIS 

  SIM_RAPID_APPROACH mom_cycle_rapid_to_pos
  SIM_FEED mom_cycle_feed_to_pos

  if {![info exists mom_spindle_orient_code]} {
    set mom_spindle_orient_code 19
  }

  MOM_output_literal "M$mom_spindle_orient_code"
  if {![info exists mom_cycle_orient]} {set mom_cycle_orient .1}
  set ndv(0) 1.0
  set ndv(1) 0.0
  set ndv(2) 0.0
  set dot [VEC3_dot ndv mom_sys_spindle_axis]

  if {[EQ_is_equal [expr abs($dot)] 1.0]} {
    set ndv(0) 0.0
    set ndv(1) 1.0
  }

  VEC3_cross mom_sys_spindle_axis ndv offset

  for {set i 0} {$i < 3} {incr i} {
    set pos($i) [expr $mom_cycle_feed_to_pos($i) + $offset($i)*$mom_cycle_orient]
    set pos1($i) [expr $pos($i) + $mom_sys_spindle_axis($i)*($mom_cycle_retract_to+$mom_cycle_feed_to)]
  }

  SIM_RAPID pos
  SIM_RAPID pos1
  MOM_force once M_spindle
  MOM_do_template spindle_rpm   
}


#=============================================================
proc PB_CMD_sim_cycle_bore_manual_move { } {
#=============================================================
  global mom_cycle_rapid_to_pos mom_cycle_feed_to_pos

  CYCLE_TOOL_AXIS 

  SIM_RAPID_APPROACH mom_cycle_rapid_to_pos
  SIM_FEED mom_cycle_feed_to_pos
  MOM_do_template stop
}


#=============================================================
proc PB_CMD_sim_cycle_bore_dwell_move { } {
#=============================================================
  global mom_cycle_retract_to_pos mom_cycle_rapid_to_pos mom_cycle_feed_to_pos
  global sim_delay_value mom_cycle_delay

  CYCLE_TOOL_AXIS 

  SIM_RAPID_APPROACH mom_cycle_rapid_to_pos
  SIM_FEED mom_cycle_feed_to_pos

  if {![info exists mom_cycle_delay]} {
    set mom_delay_value 2.0
  } else { 
    set mom_delay_value $mom_cycle_delay
  }

  MOM_force once dwell G
  MOM_do_template delay
  SIM_FEED mom_cycle_rapid_to_pos  
  SIM_RTRCTO
  MOM_force once M_spindle
  MOM_do_template spindle_rpm   
}


#=============================================================
proc PB_CMD_sim_cycle_bore_back_move { } {
#=============================================================
  global mom_cycle_retract_to_pos mom_cycle_rapid_to_pos mom_cycle_feed_to_pos

  CYCLE_TOOL_AXIS 

  SIM_RAPID_APPROACH mom_cycle_rapid_to_pos
  SIM_FEED mom_cycle_feed_to_pos
  SIM_RAPID mom_cycle_retract_to_pos
}


#=============================================================
proc PB_CMD_sim_cycle_bore_manual_dwell_move { } {
#=============================================================
  global mom_cycle_feed_to_pos mom_cycle_rapid_to_pos
  global sim_delay_value mom_cycle_delay

  CYCLE_TOOL_AXIS 

  SIM_RAPID_APPROACH mom_cycle_rapid_to_pos
  SIM_FEED mom_cycle_feed_to_pos

  if {![info exists mom_cycle_delay]} {
    set mom_delay_value 2.0
  } else { 
    set mom_delay_value $mom_cycle_delay
  }

  MOM_force once dwell G
  MOM_do_template delay
  MOM_do_template stop
}




#=============================================================
proc PB_CMD_init_spindle_axis {} {
#=============================================================
#
# This procedure will be executed automatically at the start of program and
# anytime it is loaded as a slave post of a linked post.
#

  global mom_kin_spindle_axis mom_sys_spindle_axis

# This procedure can be used to set the spindle axis to
# an axis other than the Z axis of the MCS.  If you have 
# a right angle head, then this vector needs to be 
# changed.
#
  if {![info exists mom_kin_spindle_axis]} { 
    set mom_kin_spindle_axis(0)                    0.0
    set mom_kin_spindle_axis(1)                    0.0
    set mom_kin_spindle_axis(2)                    1.0
  }

  if {![info exists mom_sys_spindle_axis]} { 
    set mom_sys_spindle_axis(0)                    0.0
    set mom_sys_spindle_axis(1)                    0.0
    set mom_sys_spindle_axis(2)                    1.0
  }

}

#=============================================================
proc PB_CMD_linear_move { } {
#=============================================================
#
# This procedure is used my many automatic postbuilder functions 
# to output a linear move.  Do NOT add this block to events or
# markers.  It is a static block and it is not intended to be added
# to events.  Do NOT change the name of this procedure.  
#
# If you need a custom command to be output with a linear move block, 
# you must place a call to the custom command either before or after 
# the MOM_do_template command.  You may need to edit the output
# line if you have changed the name of the linear move block.
#
# This proc is used for:
#     simulated cycles feed moves
#     mill/turn mill linearization
#     four and five axis retract and re-engage
#     

  MOM_do_template linear_move
}

