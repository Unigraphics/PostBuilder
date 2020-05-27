#=============================================================
proc PB_CMD_before_motion { } {
#=============================================================
global mom_pos mom_prev_pos
global mom_sys_quill_pos mom_sys_table_pos
global mom_cycle_feed_to_pos mom_cycle_rapid_to_pos
global mom_sys_zw_mode mom_sys_z_pos mom_sys_cycle_z_pos
global mom_sys_table_leader mom_sys_quill_leader
global mom_cycle_feed_to mom_cycle_rapid_to
global mom_motion_type mom_motion_event no_update

if {[info exists no_update]} {
  unset no_update
} elseif {$mom_motion_type == "CYCLE" && $mom_motion_event == "initial_move"} {
  set mom_sys_cycle_z_pos [expr $mom_pos(2) - $mom_cycle_rapid_to]
  set mom_sys_z_pos $mom_pos(2)
  set no_update 0
} else {
  set mom_sys_cycle_z_pos $mom_pos(2)
  set mom_sys_z_pos $mom_pos(2)
}

if {$mom_sys_zw_mode == $mom_sys_table_leader} {
  set mom_pos(2) [expr $mom_sys_z_pos - $mom_sys_quill_pos]
  if {[info exists mom_cycle_feed_to_pos]} {
    set mom_cycle_feed_to_pos(2) [expr $mom_sys_cycle_z_pos + $mom_cycle_feed_to - $mom_sys_quill_pos]
  }
  if {[info exists mom_cycle_rapid_to_pos]} {
    set mom_cycle_rapid_to_pos(2) [expr $mom_sys_cycle_z_pos + $mom_cycle_rapid_to - $mom_sys_quill_pos]
  }
}

if {$mom_sys_zw_mode == $mom_sys_quill_leader} {
  set mom_pos(2) [expr $mom_sys_z_pos - $mom_sys_table_pos]
  if {[info exists mom_cycle_feed_to_pos]} {
    set mom_cycle_feed_to_pos(2) [expr $mom_sys_z_pos + $mom_cycle_feed_to - $mom_sys_table_pos]
  }
  if {[info exists mom_cycle_rapid_to_pos]} {
    set mom_cycle_rapid_to_pos(2) [expr $mom_sys_z_pos + $mom_cycle_rapid_to - $mom_sys_table_pos]
  }
}

}



#=============================================================
proc PB_CMD_initialize_parallel_zw_mode { } {
#=============================================================
uplevel #0 {


#  This procedure must be placed in the start or program.
#
#  This procedure can be used to initialize a machine tool that has 
#  parallel Z and W axes.  The leader for the Z axis is changed from
#  Z to W and W to Z as needed.  The Z or W mode may be changed by 
#  adding a PB_CMD_set_mode_zaxis or PB_CMD_set_mode_waxis to any
#  event marker.  The UDE's SET/MODE,ZAXIS or SET/MODE,WAXIS may also
#  be added to the toolpath to change mode.
#
#  The Z and W axis may not be output in the same block.
#
#  ZW Parameters
#
  set mom_sys_quill_leader	"Z"
  set mom_sys_table_leader	"W"
  set mom_sys_zaxis_home	0.0
  set mom_sys_waxis_home	0.0
  set mom_sys_zaxis_max_limit	9999.9999
  set mom_sys_zaxis_min_limit	0.0
  set mom_sys_waxis_max_limit	9999.9999
  set mom_sys_waxis_min_limit	-9999.9999
#
#  System variables DO NOT CHANGE
#
  set mom_sys_zw_mode		$mom_sys_quill_leader
  set mom_sys_leader(z_axis)  $mom_sys_quill_leader
  set mom_sys_quill_pos		0.0
  set mom_sys_table_pos		0.0
  set mom_sys_z_pos		0.0

set def_file_name "${mom_output_file_directory}temp_def_file.def"
set temp_file [open "$def_file_name" w]

puts $temp_file "MACHINE zw"
puts $temp_file " "
puts $temp_file "FORMATTING"
puts $temp_file "\{"
puts $temp_file "ADDRESS Z "
puts $temp_file "  \{"
puts $temp_file "      FORMAT      Coordinate"
puts $temp_file "      FORCE       off"
puts $temp_file "      MAX         9999.9999 Truncate"
puts $temp_file "      MIN         -9999.9999 Truncate"
puts $temp_file "      LEADER      \[\$mom_sys_leader\(z_axis\)\]"
puts $temp_file "      ZERO_FORMAT Zero_real"
puts $temp_file "  \}"
puts $temp_file " BLOCK_TEMPLATE zaxis_move" 
puts $temp_file "  \{"
puts $temp_file "       G_motion\[\$mom_sys_rapid_code\]"
puts $temp_file "       Z\[\$mom_sys_zaxis_pos\]"
puts $temp_file "  \}"
puts $temp_file "\}"
close $temp_file
MOM_load_definition_file $def_file_name
MOM_remove_file $def_file_name

proc  MOM_before_output {} {
#_______________________________________________________________________________
# This procedure is executed just before a line is about to be output
# to the file. It loads the line into a variable MOM_o_buffer and then calls
# this procedure. When it returns from this procedure, the variable MOM_o_buffer
# is read and written to the file.
#_______________________________________________________________________________

global mom_sys_leader mom_sys_quill_leader mom_sys_table_leader
global mom_sys_quill_pos mom_sys_table_pos
global mom_o_buffer
global mom_sys_control_out mom_sys_control_in

set st [string first $mom_sys_control_out $mom_o_buffer]
set en [string last $mom_sys_control_in $mom_o_buffer]
if {$st == -1 || $en == -1} {
  set buff $mom_o_buffer
} else {
  set l [string length $mom_o_buffer]
  set st1 ""
  set st2 ""
  if {$st > 0} {set st1 [string range $mom_o_buffer 0 [expr $st-1]]}
  if {$en < $l} {set st2 [string range $mom_o_buffer [expr $en+1] $l]}
  set buff [concat $st1 $st2]
} 
set zwout [string first $mom_sys_leader(z_axis) $buff]
if {$zwout > -1} {
  set val [MOM_ask_address_value Z]
  if {$val != ""} {
if {[info exists list_file]} {puts $list_file "mbm val $val"}
    if {$mom_sys_leader(z_axis) == $mom_sys_quill_leader} {
      set mom_sys_quill_pos $val
    } elseif {$mom_sys_leader(z_axis) == $mom_sys_table_leader} {
      set mom_sys_table_pos $val
    }
  }
}


#########The following procedure invokes the listing file with warnings.

         LIST_FILE
}


#=============================================================
proc MODES_SET { } {
#=============================================================
  global mom_output_mode mom_parallel_to_axis 

  switch $mom_output_mode {
    ABSOLUTE { set isincr OFF }
    default  { set isincr ON }
  }
  MOM_incremental $isincr X Y Z

  switch $mom_parallel_to_axis {
    WAXIS { 
            PB_CMD_set_mode_waxis
    }
    default { 
            PB_CMD_set_mode_zaxis
    }
  }
}

#=============================================================
proc MOM_set_axis { } {
#=============================================================
global mom_axis_position mom_axis_position_value 
global mom_sys_zw_pos mom_prev_pos mom_last_pos mom_sys_zw_mode
global mom_sys_leader mom_sys_zaxis_pos mom_sys_waxis_home mom_pos
global mom_sys_quill_leader mom_sys_zaxis_home mom_sys_table_leader
global mom_prev_pos mom_sys_table_pos
global mom_prev_pos mom_sys_z_pos mom_sys_cycle_z_pos
global mom_sys_quill_pos 


  switch $mom_axis_position {
    ZAXIS { 
      if {$mom_sys_zw_mode == $mom_sys_table_leader} {
        set need_w_reset 0
        set mom_sys_leader(z_axis) $mom_sys_quill_leader
      }

      set mom_sys_zaxis_pos $mom_axis_position_value
      MOM_force once Z
      MOM_do_template zaxis_move

      if {[info exists need_w_reset]} {
        set mom_sys_leader(z_axis) $mom_sys_table_leader
        unset need_w_reset
      }
    }
    WAXIS  { 
      if {$mom_sys_zw_mode == $mom_sys_quill_leader} {
        set need_w_reset 0
        set mom_sys_leader(z_axis) $mom_sys_table_leader
      }

      set mom_sys_zaxis_pos $mom_axis_position_value
      MOM_force once Z
      MOM_do_template zaxis_move

      if {[info exists need_w_reset]} {
        set mom_sys_leader(z_axis) $mom_sys_quill_leader
        unset need_w_reset
      }
    }
  }
}

}
}



#=============================================================
proc PB_CMD_set_mode_waxis { } {
#=============================================================
#
#  This command is used to change from Z axis mode to W axis mode
#
global mom_sys_zw_mode mom_sys_z_pos mom_sys_cycle_z_pos
global mom_sys_leader mom_sys_table_leader mom_pos
global mom_sys_quill_pos mom_sys_table_pos
global mom_cycle_feed_to_pos mom_cycle_rapid_to_pos
global mom_cycle_feed_to mom_cycle_rapid_to

if {$mom_sys_zw_mode != $mom_sys_table_leader} {
  set mom_sys_zw_mode $mom_sys_table_leader
  set mom_sys_leader(z_axis) $mom_sys_table_leader

  set mom_pos(2) [expr $mom_sys_z_pos - $mom_sys_quill_pos]
  if {[info exists mom_cycle_feed_to_pos]} {
    set mom_cycle_feed_to_pos(2) [expr $mom_sys_cycle_z_pos + $mom_cycle_feed_to - $mom_sys_quill_pos]
  }
  if {[info exists mom_cycle_rapid_to_pos]} {
    set mom_cycle_rapid_to_pos(2) [expr $mom_sys_cycle_z_pos + $mom_cycle_rapid_to - $mom_sys_quill_pos]
  }
  MOM_force once Z
}
}



#=============================================================
proc PB_CMD_set_mode_zaxis { } {
#=============================================================
#
#  This command is used to change from W axis mode to Z axis mode
#
global mom_sys_zw_mode mom_sys_z_pos mom_sys_cycle_z_pos
global mom_sys_leader mom_sys_quill_leader mom_pos
global mom_sys_quill_pos mom_sys_table_pos
global mom_cycle_feed_to_pos mom_cycle_rapid_to_pos
global mom_cycle_feed_to mom_cycle_rapid_to

if {$mom_sys_zw_mode != $mom_sys_quill_leader} {
  set mom_sys_zw_mode $mom_sys_quill_leader
  set mom_sys_leader(z_axis) $mom_sys_quill_leader
  set mom_pos(2) [expr $mom_sys_z_pos - $mom_sys_table_pos]
  if {[info exists mom_cycle_feed_to_pos]} {
    set mom_cycle_feed_to_pos(2) [expr $mom_sys_cycle_z_pos + $mom_cycle_feed_to - $mom_sys_table_pos]
  }
  if {[info exists mom_cycle_rapid_to_pos]} {
    set mom_cycle_rapid_to_pos(2) [expr $mom_sys_cycle_z_pos + $mom_cycle_rapid_to - $mom_sys_table_pos]
  }
  MOM_force once Z
}
}



#=============================================================
proc PB_CMD_set_quill_home { } {
#=============================================================
#
#  This command is used to move the quill to home position
#
global mom_sys_zw_pos mom_prev_pos mom_last_pos mom_sys_zw_mode
global mom_sys_leader mom_sys_zaxis_pos mom_sys_zaxis_home mom_pos
global mom_sys_table_leader mom_sys_waxis_home mom_sys_quill_leader
global mom_prev_pos mom_sys_z_pos mom_sys_cycle_z_pos
global mom_sys_quill_pos 

if {$mom_sys_zw_mode == $mom_sys_table_leader} {
   set need_w_reset 0
   set mom_sys_leader(z_axis) $mom_sys_quill_leader
}

set mom_sys_zaxis_pos $mom_sys_zaxis_home
MOM_force once Z
MOM_do_template zaxis_move

if {[info exists need_w_reset]} {
  set mom_sys_leader(z_axis) $mom_sys_table_leader
  unset need_w_reset
  set mom_pos(2) [expr $mom_sys_z_pos - $mom_sys_quill_pos]
  if {[info exists mom_cycle_feed_to_pos]} {
    set mom_cycle_feed_to_pos(2) [expr $mom_sys_cycle_z_pos + $mom_cycle_feed_to - $mom_sys_quill_pos]
  }
  if {[info exists mom_cycle_rapid_to_pos]} {
    set mom_cycle_rapid_to_pos(2) [expr $mom_sys_cycle_z_pos + $mom_cycle_rapid_to - $mom_sys_quill_pos]
  }
}
}



#=============================================================
proc PB_CMD_set_table_home { } {
#=============================================================
#
#  This command is used to move the table to home position
#
global mom_sys_zw_pos mom_prev_pos mom_last_pos mom_sys_zw_mode
global mom_sys_leader mom_sys_zaxis_pos mom_sys_waxis_home mom_pos
global mom_sys_quill_leader mom_sys_zaxis_home mom_sys_table_leader
global mom_prev_pos mom_sys_table_pos
global mom_prev_pos mom_sys_z_pos mom_sys_cycle_z_pos
global mom_sys_quill_pos 

if {$mom_sys_zw_mode == $mom_sys_quill_leader} {
   set need_z_reset 0
   set mom_sys_leader(z_axis) $mom_sys_table_leader
}

set mom_sys_zaxis_pos $mom_sys_waxis_home
MOM_force once Z
MOM_do_template zaxis_move

if {[info exists need_z_reset]} {
   set mom_sys_leader(z_axis) $mom_sys_quill_leader
   unset need_z_reset
   set mom_pos(2) [expr $mom_sys_z_pos - $mom_sys_table_pos]
   if {[info exists mom_cycle_feed_to_pos]} {
     set mom_cycle_feed_to_pos(2) [expr $mom_sys_cycle_z_pos + $mom_cycle_feed_to - $mom_sys_table_pos]
   }
   if {[info exists mom_cycle_rapid_to_pos]} {
     set mom_cycle_rapid_to_pos(2) [expr $mom_sys_cycle_z_pos + $mom_cycle_rapid_to - $mom_sys_table_pos]
   }
}
}


