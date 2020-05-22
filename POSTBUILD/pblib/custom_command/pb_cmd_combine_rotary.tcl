#===============================================================================
# Exported Custom Commands created by suderman
# on Tue Sep 21 15:40:03 2004 Pacific Daylight Time
#===============================================================================



#=============================================================
proc PB_CMD_combine_rotary_check { } {
#=============================================================
#
#  Combine consecutive rotary moves
#
#  These custom commands will allow you to combine consecutive
#  rotary moves into a single move when there is no change in 
#  X, Y and Z.
#
#  The combining of blocks will terminate when the rotary axis
#  being combined reverses or the total number of degrees of
#  the combined rotary move would have exceeded 180 degrees.
#
#  The current linear move will be suppressed if the current and the
#  next motion are either CUT or FIRSTCUT and both are linear
#  moves.
#
#  This function will only work with NX3 or later.
#  Add the follow line (without the #) to the custom command 
#  PB_CMD_before_motion.
#PB_CMD_combine_rotary_check
#
#  Select the custom command PB_CMD_combine_rotary_output from the 
#  pulldown in the Linear Move event and drag it in into the start 
#  of the Linear Move.  The Linear Move event is located at 
#  Program & Tool Path \ Program \ Tool Path \ Motion \.
#
#  Select the custom command PB_CMD_combine_rotary_init from the 
#  pulldown in the Start_of_Program event and drag it in into the 
#  Start of Program event marker.  The Start of program event is 
#  located at Program & Tool Path \ Program \ Program Start Sequence.
#
#  The following variables can be changed to relect the number of 
#  decimal places that will be output for linear and rotary words.
     set linear_decimals 4
     set rotary_decimals 3
#

global mom_sys_skip_move
global mom_nxt_pos
global mom_pos
global mom_prev_pos
global mom_nxt_motion_type 
global mom_motion_type 
global combine_mode
global prev_4th_output
global prev_5th_output
global last_4th_output
global last_5th_output
global last_4th_dir
global last_5th_dir

set mom_sys_skip_move "NO"

if {![info exists prev_4th_output]} {set prev_4th_output $mom_pos(3)}
if {![info exists prev_5th_output]} {set prev_5th_output $mom_pos(4)}

set P4 [format "%.${rotary_decimals}f" $prev_4th_output]
set P5 [format "%.${rotary_decimals}f" $prev_5th_output]

set prev_4th_output $mom_pos(3)
set prev_5th_output $mom_pos(4)

if {![info exists last_4th_output]} {set last_4th_output $P4}
if {![info exists last_5th_output]} {set last_5th_output $P5}

if {![info exists last_4th_dir]} {set last_4th_dir 0}
if {![info exists last_5th_dir]} {set last_5th_dir 0}

if {[info exists mom_nxt_pos] && [info exists mom_nxt_motion_type]} {

  set PX [format "%.${linear_decimals}f" $mom_prev_pos(0)]
  set PY [format "%.${linear_decimals}f" $mom_prev_pos(1)]
  set PZ [format "%.${linear_decimals}f" $mom_prev_pos(2)]

  set NX [format "%.${linear_decimals}f" $mom_nxt_pos(0)]
  set NY [format "%.${linear_decimals}f" $mom_nxt_pos(1)]
  set NZ [format "%.${linear_decimals}f" $mom_nxt_pos(2)]

  set N4 [format "%.${rotary_decimals}f" $mom_nxt_pos(3)]
  set N5 [format "%.${rotary_decimals}f" $mom_nxt_pos(4)]

  set X [format "%.${linear_decimals}f" $mom_pos(0)]
  set Y [format "%.${linear_decimals}f" $mom_pos(1)]
  set Z [format "%.${linear_decimals}f" $mom_pos(2)]

  set R4 [format "%.${rotary_decimals}f" $mom_pos(3)]
  set R5 [format "%.${rotary_decimals}f" $mom_pos(4)]

  set D4 [expr $R4-$P4] 
  if [EQ_is_equal $D4 0.0] {
    set cur_4th_dir 0 
  } elseif {($D4 > -180.0 && $D4 < 0.0) || ($D4 > 180.0)} {
    set cur_4th_dir -1 
  } else {
    set cur_4th_dir 1
  }
  set T4 [expr $N4-$last_4th_output]
  if [EQ_is_equal $T4 0.0] {
    set tot_4th_dir 0 
  } elseif {($T4 > -180.0 && $T4 < 0.0) || ($T4 > 180.0)} {
    set tot_4th_dir -1 
  } else {
    set tot_4th_dir 1
  }
  if {[expr $cur_4th_dir*$last_4th_dir] < -.5 || [expr $cur_4th_dir*$tot_4th_dir] < -.5} {
    set switch_dir_4th "YES"
  } else {
    set switch_dir_4th "NO"
  }

  set D5 [expr $R5-$P5] 
  if [EQ_is_equal $D5 0.0] {
    set cur_5th_dir 0 
  } elseif {($D5 > -180.0 && $D5 < 0.0) || ($D5 > 180.0)} {
    set cur_5th_dir -1 
  } else {
    set cur_5th_dir 1
  } 
  set T5 [expr $N5-$last_5th_output]
  if [EQ_is_equal $T5 0.0] {
    set tot_5th_dir 0 
  } elseif {($T5 > -180.0 && $T5 < 0.0) || ($T5 > 180.0)} {
    set tot_5th_dir -1 
  } else {
    set tot_5th_dir 1
  }
  if {[expr $cur_5th_dir*$last_5th_dir] < -.5 || [expr $cur_5th_dir*$tot_5th_dir] < -.5} {
    set switch_dir_5th "YES"
  } else {
    set switch_dir_5th "NO"
  }

  if {($mom_motion_type == "CUT" && $mom_nxt_motion_type == "CUT") || ($mom_motion_type == "FIRSTCUT" && $mom_nxt_motion_type == "FIRSTCUT") || ($mom_motion_type == "STEPOVER" && $mom_nxt_motion_type == "STEPOVER")} {
      if {[EQ_is_equal $PX $X] && [EQ_is_equal $PY $Y] && [EQ_is_equal $PZ $Z] && ![EQ_is_equal $P4 $R4] && [EQ_is_equal $P5 $R5] && [EQ_is_equal $NX $X] && [EQ_is_equal $NY $Y] && [EQ_is_equal $NZ $Z] && ![EQ_is_equal $N4 $R4] && [EQ_is_equal $N5 $R5] && $combine_mode != "5" && $switch_dir_4th == "NO"} {
        set mom_sys_skip_move "YES"
        MOM_force once fourth_axis
        set combine_mode "4"
        return
       } elseif { [EQ_is_equal $PX $X] && [EQ_is_equal $PY $Y] && [EQ_is_equal $PZ $Z] && [EQ_is_equal $P4 $R4] && ![EQ_is_equal $P5 $R5] && [EQ_is_equal $NX $X] && [EQ_is_equal $NY $Y] && [EQ_is_equal $NZ $Z] && [EQ_is_equal $N4 $R4] && ![EQ_is_equal $N5 $R5] && $combine_mode != "4" && $switch_dir_5th == "NO"} {
        set mom_sys_skip_move "YES"
        MOM_force once fifth_axis
        set combine_mode "5"
        return
      }
  }
  set combine_mode "0"
  set last_4th_output $R4
  set last_5th_output $R5
  set last_4th_dir $cur_4th_dir
  set last_5th_dir $cur_5th_dir
}


}



#=============================================================
proc PB_CMD_combine_rotary_init { } {
#=============================================================
global mom_kin_read_ahead_next_motion
global combine_mode

set combine_mode "0"
set mom_kin_read_ahead_next_motion 		      "TRUE"
MOM_reload_kinematics
}



#=============================================================
proc PB_CMD_combine_rotary_output { } {
#=============================================================
global mom_sys_skip_move


if {[info exists mom_sys_skip_move]} {
  if {$mom_sys_skip_move == "YES"} { 
    if {![llength [info commands MOM_abort_event]]} {
      global mom_warning_info
      set mom_warning_info "MOM_abort_event is an invalid command.  Must use NX3 or later"
      MOM_catch_warning
      return
    }
    global mom_pos mom_prev_pos
    global mom_mcs_goto mom_prev_mcs_goto
    VMOV 5 mom_prev_pos mom_pos
    VMOV 3 mom_prev_mcs_goto mom_mcs_goto
    MOM_reload_variable -a mom_pos
    MOM_reload_variable -a mom_mcs_goto
    MOM_abort_event 
  }
}
}



