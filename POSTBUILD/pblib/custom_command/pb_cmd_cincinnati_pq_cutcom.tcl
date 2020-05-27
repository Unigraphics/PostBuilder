
#=============================================================
proc PB_CMD_cutcom_on { } {
#=============================================================
global mom_sys_cutcom_status
  set mom_sys_cutcom_status "START"
}


#=============================================================
proc PB_CMD_pq_cutcom_initialize { } {
#=============================================================
#  This procedure is used to establish PQ cutter compensation for Cincinnati
#  controllers.  This procedure must be placed in the start of path event marker
#  in order to get the PQ codes.
# 
#  mom_sys_cutcom_status 
#	OFF	Cutcom is off, no action is needed 
#	ON	Cutcom is on, output pq codes
#	START	Cutcom has been turned on, output startup codes
#	END	Cutcom has been turned off, output off codes
#
#  mom_sys_cutcom_type
#
#	G_CODES	Output G40, G41, G42
#	PQ	Output PQ codes
#
#  mom_sys_cutcom_on_type
#
#	NORMAL	Cutcom offset vector is perpendicular to direction of motion
#	TANGENT Cutcom offset vector is parallel to the direction of motion
#
#  mom_sys_cutcom_off_type
#
#	NORMAL	Cutcom vector for last point is perpendicular 
#               to the direction of last motion
#	TANGENT Cutcom vector for last point is parallel to the 
#               direction of last motion
#
global mom_sys_cutcom_status
global mom_sys_cutcom_type
global mom_sys_cutcom_on_type
global mom_sys_cutcom_off_type
global mom_kin_read_ahead_next_motion

  set mom_sys_cutcom_status "OFF"
  set mom_sys_cutcom_type "PQ"
  set mom_sys_cutcom_on_type "NORMAL"
  set mom_sys_cutcom_off_type "NORMAL"
  set mom_kin_read_ahead_next_motion "TRUE"

  MOM_reload_kinematics
}


#=============================================================
proc PB_CMD_pq_motion { } {
#=============================================================
#
#  Process PQ cutcom.  Calculate PQ vectors and force out as needed.  
#  This custom command must be placed in the linear_move, circular 
#  move and rapid move event markers.

   pq_cutcom
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
proc pq_cutcom {  } {
#=============================================================

  global mom_mcs_goto mom_prev_mcs_goto mom_nxt_mcs_goto 
  global mom_sys_cutcom_status mom_sys_cutcom_type mom_sys_cutcom_on_type
  global mom_sys_cutcom_off_type pval qval cur_vec nxt_vec
  global mom_nxt_event mom_nxt_event_count mom_nxt_motion_event mom_nxt_arc_center
  global mom_motion_event mom_nxt_arc_axis mom_arc_axis mom_arc_center
  global mom_pos mom_prev_pos mom_kin_machine_resolution
  global mom_cutcom_status PI

if {[info exists mom_sys_cutcom_type] && $mom_sys_cutcom_type == "PQ"} {
 
  if {$mom_sys_cutcom_type == "PQ" && $mom_sys_cutcom_status != "OFF"} {
    if {$mom_nxt_event_count != 0} {
      for {set i 0} {$i < $mom_nxt_event_count} {incr i 1} {
	if {$mom_nxt_event($i) == "cutcom_off"} {set mom_sys_cutcom_status "END"}
      }
    }
    if {$mom_motion_event == "linear_move" || $mom_nxt_motion_event == "rapid_move"} {
      VEC3_sub mom_prev_mcs_goto mom_mcs_goto tmp_vec
      VEC3_unitize tmp_vec cur_vec
    } elseif {$mom_motion_event == "circular_move"} {
      VEC3_sub mom_mcs_goto mom_arc_center cur_vec
      VEC3_unitize cur_vec tmp_vec
      VEC3_cross mom_arc_axis tmp_vec cur_vec
    }
    if {$mom_nxt_motion_event == "linear_move" || $mom_nxt_motion_event == "rapid_move"} {
      VEC3_sub mom_nxt_mcs_goto mom_mcs_goto tmp_vec
      VEC3_unitize tmp_vec nxt_vec
    } elseif {$mom_nxt_motion_event == "circular_move"} {
      VEC3_sub mom_nxt_arc_center mom_mcs_goto nxt_vec
      VEC3_unitize nxt_vec tmp_vec
      VEC3_cross mom_nxt_arc_axis tmp_vec nxt_vec
    }

    if {$mom_sys_cutcom_status != "END" && $mom_sys_cutcom_status != "START"} {
      set xdel [expr abs($mom_pos(0)-$mom_prev_pos(0))]
      if {$xdel > $mom_kin_machine_resolution} {MOM_force once P_cutcom}
      set ydel [expr abs($mom_pos(1)-$mom_prev_pos(1))]
      if {$ydel > $mom_kin_machine_resolution} {MOM_force once Q_cutcom}
    }

    if {$mom_sys_cutcom_status == "START"} {
      if {$mom_sys_cutcom_on_type == "NORMAL"} {
        set cur_vec(0) [expr -$nxt_vec(0)]
        set cur_vec(1) [expr -$nxt_vec(1)]
      } elseif {$mom_sys_cutcom_on_type == "TANGENT"} {
        set cur_vec(0) $nxt_vec(1)
        set cur_vec(1) [expr -$nxt_vec(0)]
        set nxt_vec(0) [expr -$cur_vec(0)]
        set nxt_vec(1) [expr -$cur_vec(1)]
      }
      set mom_sys_cutcom_status "ON"
      MOM_force once X Y P_cutcom Q_cutcom
    } elseif {$mom_sys_cutcom_status == "END"} {
      if {$mom_sys_cutcom_off_type == "NORMAL"} {
        set nxt_vec(0) [expr -$cur_vec(0)]
        set nxt_vec(1) [expr -$cur_vec(1)]
      } elseif {$mom_sys_cutcom_off_type == "TANGENT"} {
        set nxt_vec(0) [expr -$cur_vec(1)]
        set nxt_vec(1) $cur_vec(0)
        set cur_vec(0) [expr -$nxt_vec(0)]
        set cur_vec(1) [expr -$nxt_vec(1)]
      }
      set mom_sys_cutcom_status "OFF"
      MOM_force once X Y P_cutcom Q_cutcom
    }

    set a1 [ARCTAN $cur_vec(1) $cur_vec(0)]
    set a2 [ARCTAN $nxt_vec(1) $nxt_vec(0)]
    set a3 [expr $a1-$a2]
    if {$a3 < 0.0} {set a3 [expr $a3+$PI*2.0]}
    set a4 [expr $a2+($a3/2.0)]
    set cosa [expr cos($a4)]
    set sina [expr sin($a4)]
    set div [expr abs(sin($a3/2.0))]
    if {[EQ_is_zero $div]} {
      if {![EQ_is_zero $cosa]} {
	if {$cosa < 0.0} {
	  set pval -3.2767
        } else {
	  set pval 3.2767
        }
      } else {
	set pval 0.0
      }
      if {![EQ_is_zero $sina]} {
	if {$sina < 0.0} {
	  set qval -3.2767
        } else {
	  set qval 3.2767
        }
      } else {
	set qval 0.0
      }
    } else {
      set pval [expr $cosa/$div]
      if {$pval < -3.2767} {
        set pval -3.2767
      } elseif {$pval > 3.2767} {
        set pval 3.2767
      }
      set qval [expr $sina/$div]
      if {$qval < -3.2767} {
        set qval -3.2767
      } elseif {$qval > 3.2767} {
        set qval 3.2767
      }
    }
    if {$mom_cutcom_status == "RIGHT" } {
      set pval [expr -$pval]
      set qval [expr -$qval]
    }
  }
}
}
