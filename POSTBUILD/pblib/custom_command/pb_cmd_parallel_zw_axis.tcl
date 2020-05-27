proc PB_CMD_parallel_zw_mode {} {

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
}
proc PB_CMD_set_mode_zaxis {} {
#
#  This command is used to change from W axis mode to Z axis mode
#
global mom_sys_zw_pos mom_prev_pos mom_last_pos mom_sys_zw_mode
global mom_sys_leader

if {$mom_sys_zw_mode != "Z"} {

  set mom_sys_zw_mode "Z"
  set mom_sys_leader(z_axis) "Z"
  set mom_sys_zw_pos [expr $mom_prev_pos(2)-$mom_sys_zw_pos]
  MOM_force once Z

}
}

proc PB_CMD_set_mode_waxis {} {
#
#  This command is used to change from Z axis mode to W axis mode
#
global mom_sys_zw_pos mom_prev_pos mom_last_pos mom_sys_zw_mode
global mom_sys_leader

if {$mom_sys_zw_mode != "W"} {

  set mom_sys_zw_mode "W"
  set mom_sys_leader(z_axis) "W"
  set mom_sys_zw_pos [expr $mom_prev_pos(2)-$mom_sys_zw_pos]
  MOM_force once Z

}
}


}
