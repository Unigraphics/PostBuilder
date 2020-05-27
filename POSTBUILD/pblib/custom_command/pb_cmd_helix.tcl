#===============================================================================
# Exported Custom Commands created by suderman
# on Thu Dec 13 15:31:53 2001 Pacific Daylight Time
#===============================================================================



#=============================================================
proc PB_CMD_initialize_helix { } {
#=============================================================
uplevel #0 {
#
#  HELIX
#
#  This procedure can be used to enable your post to output helix.
#  This procedure must be placed in the Start of Program event
#  marker to activate the helix functionality.  You can choose from
#  the following options to format the circle block template to
#  output the helix parameters.
#
	set mom_sys_helix_pitch_type	"rise_radian"  
#
#  The default setting for mom_sys_helix_pitch_type is "rise_radian".
#  This is the most common.  Other choices are:
#
#	"rise_radian"	        Measures the rise over one radian.
#	"rise_revolution"	Measures the rise over 360 degrees.
#       "none"			Will suppress the output of pitch.
#       "other"			Allows you to calculate the pitch
#				using your own formula.
# 

#=============================================================
proc MOM_helix_move { } {
#=============================================================
  global mom_pos_arc_plane
  global mom_sys_cir_vector
  global mom_sys_helix_pitch_type
  global mom_helix_pitch
  global mom_prev_pos mom_pos_arc_center
 
  switch $mom_pos_arc_plane {
    XY { MOM_suppress once K ; set cir_index 2 }
    YZ { MOM_suppress once I ; set cir_index 0 }
    ZX { MOM_suppress once J ; set cir_index 1 }
  }

  switch $mom_sys_helix_pitch_type {
    none { }
    rise_radian { set pitch $mom_helix_pitch }
    rise_revolution { set pitch [expr $mom_helix_pitch * $PI * 2.0]}
    other {
#
#	Place your custom helix pitch code here
#
    }
    default { set mom_sys_helix_pitch_type "none" }
  }
    
  MOM_force once X Y Z
  if {$mom_sys_helix_pitch_type != "none"} {
    MOM_force once I J K
    if {$mom_sys_cir_vector == "Vector - Arc Center to Start"} {
      set mom_prev_pos($cir_index) 0.0
      set mom_pos_arc_center($cir_index) $pitch
    } elseif {$mom_sys_cir_vector == "Vector - Arc Start to Center"} {
      set mom_prev_pos($cir_index) $pitch
      set mom_pos_arc_center($cir_index) 0.0
    } elseif {$mom_sys_cir_vector == "Unsigned Vector - Arc Center to Start"} {
      set mom_prev_pos($cir_index) 0.0
      set mom_pos_arc_center($cir_index) $pitch
    } elseif {$mom_sys_cir_vector == "Absolute Arc Center"} {
      set mom_pos_arc_center($cir_index) $pitch
    }
  }

  MOM_do_template circular_move_1

}

}
}



