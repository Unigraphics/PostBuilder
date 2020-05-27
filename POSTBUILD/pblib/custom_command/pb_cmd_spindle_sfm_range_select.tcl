#=============================================================
proc PB_CMD_spindle_sfm_range_select { } {
#=============================================================
#
#  This procedure will output RPM or SFM.  Use this lathe posts. 
#
#  This procedure will select the appropriate spindle range based 
#  on the spindle table provided in post builder.  This procedure 
#  will generate the mom variable mom_spindle_range which is
#  used in the WORD M_range.  The user must define the code for the 
#  mom_variable mom_sys_spindle_range_code($mom_range_code).  By 
#  default this is an m code.  You can change it to any code desired 
#  by making the M_range leader blank, the format string and the 
#  code any text needed.
#
#  You must place the word M_range in the appropriate block template.
#  You must place this custom command in a block before you output
#  the spindle range code.
#


global mom_sys_spindle_range_code mom_sys_spindle_param
global mom_spindle_mode mom_spindle_rpm mom_spindle_sfm mom_spindle_speed 
global mom_spindle_range mom_number_of_ranges

if {![info exist mom_sys_spindle_param]} {
  set mom_spindle_range 1
  return
}

if {$mom_spindle_mode == "RPM"} {
  if {[info exist mom_spindle_rpm]} {
    set speed $mom_spindle_rpm
  } else {
    set speed $mom_spindle_speed
  }  
} elseif {$mom_spindle_mode == "SFM" || $mom_spindle_mode == "SMM"} {
  if {[info exist mom_spindle_sfm]} {
    set speed $mom_spindle_sfm
  } else {
    set speed $mom_spindle_speed
  }  
}


if {![info exist mom_number_of_ranges]} {
  set mom_number_of_ranges 9
}

for {set i 1} {$i <= $mom_number_of_ranges} {incr i} {
  if {$speed > $mom_sys_spindle_param($i,min) && $speed <= $mom_sys_spindle_param($i,max) } {
    set mom_spindle_range $i
    return
  }
}
set mom_spindle_range 1
}



