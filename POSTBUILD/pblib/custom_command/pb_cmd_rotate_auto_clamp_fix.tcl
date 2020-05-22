##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc AUTO_CLAMP {  } {
#=============================================================
#
#  This procedure is used to automatically output clamp and unclamp
#  codes.  This procedure will output M10 or M11 to do fourth 
#  axis clamping and unclamping or M12 or M13 to do fifth axis 
#  clamping and unclamping.  It will also unclamp before a ROTATE
#  command and clamp after a ROTATE.
#
   global clamp_rotary_fourth_status 
   global clamp_rotary_fifth_status 
   global mom_pos 
   global mom_prev_pos 
   global mom_sys_auto_clamp
   global mom_kin_machine_type

   if {![info exists mom_sys_auto_clamp]} {return}
   if {$mom_sys_auto_clamp != "ON"} {return}

   set rotary_out [EQ_is_equal $mom_pos(3) $mom_prev_pos(3)]

   AUTO_CLAMP_SUB  $rotary_out fourth

   switch $mom_kin_machine_type {
      5_axis_dual_table -
      5_AXIS_DUAL_TABLE -
      5_axis_dual_head -
      5_AXIS_DUAL_HEAD -
      5_axis_head_table -
      5_AXIS_HEAD_TABLE {}
      default           {return}
    }

   set rotary_out [EQ_is_equal $mom_pos(4) $mom_prev_pos(4)]

   AUTO_CLAMP_SUB $rotary_out fifth
 
}


#=============================================================
proc AUTO_CLAMP_SUB { output_status rotaxis  } {
#=============================================================
#
#  This procedure is used to automatically output clamp and unclamp
#  codes.  
#
   global mom_sys_auto_clamp
  
   if {![info exists mom_sys_auto_clamp]} {return}
   if {$mom_sys_auto_clamp != "ON"} {return}

   set var ""
   lappend var clamp_rotary
   lappend var $rotaxis
   lappend var status
   set global_status [join $var _]
   global $global_status 
   if {![info exists $global_status]} {set $global_status "UNDEFINED"}
   set stat [eval format %s $$global_status]
   if {$output_status == 0 && $stat != "UNCLAMPED"} {
      set var ""
      lappend var PB_CMD_unclamp 
      lappend var $rotaxis 
      lappend var axis
      set var [join $var _]
      $var
      set $global_status "UNCLAMPED"
   } elseif {$output_status == 1 && $stat != "CLAMPED"} {
      set var ""
      lappend var PB_CMD_clamp 
      lappend var $rotaxis 
      lappend var axis
      set var [join $var _]
      $var
      set $global_status "CLAMPED"
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
  global mom_out_angle_pos mom_prev_out_angle_pos
  global mom_prev_pos mom_sys_leader

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
         if { $mom_kin_machine_type == "5_axis_head_table ||  $mom_kin_machine_type == "5_AXIS_HEAD_TABLE" } {
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


   if {$axis == "3" && ![info exists mom_prev_out_angle_pos(0)]} {
      set mom_prev_out_angle_pos(0) [MOM_ask_address_value fourth_axis]
      if {$mom_prev_out_angle_pos(0) == ""} {set mom_prev_out_angle_pos(0) 0.0} 
   } 

 
   if {$axis == "4" && ![info exists mom_prev_out_angle_pos(1)]} {  
      set mom_prev_out_angle_pos(1) [MOM_ask_address_value fifth_axis]
      if {$mom_prev_out_angle_pos(1) == ""} {set mom_prev_out_angle_pos(1) 0.0}
   }

   set p [expr $axis + 1]
   set a [expr $axis - 3]
   if {$axis == "3" && $mom_kin_4th_axis_direction == "MAGNITUDE_DETERMINES_DIRECTION"} {
      set dirtype 0
   } elseif { $axis == "4" &&  $mom_kin_5th_axis_direction == "MAGNITUDE_DETERMINES_DIRECTION" } {
      set dirtype 0
   } else {
      set dirtype 1
   }

   if {$mode == 1} {
      set mom_out_angle_pos($a) $angle
   } elseif {$dirtype == 0} {

      if {$axis == 3} {
         set mom_out_angle_pos($a) [ROTSET $ang  $mom_prev_out_angle_pos(0) $mom_kin_4th_axis_direction  $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)]
      } else {
         set mom_out_angle_pos($a) [ROTSET $ang  $mom_prev_out_angle_pos(1) $mom_kin_5th_axis_direction  $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)]
      }

      if {$axis == 3} {set prot $mom_prev_out_angle_pos(0)}
      if {$axis == 4} {set prot $mom_prev_out_angle_pos(1)}
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
            set mom_out_angle_pos($a) [ROTSET $ang  $mom_prev_out_angle_pos(0) $mom_kin_4th_axis_direction  $mom_kin_4th_axis_leader mom_sys_leader(fourth_axis)]
         } else {
            set mom_out_angle_pos($a) [ROTSET $ang  $mom_prev_out_angle_pos(1) $mom_kin_5th_axis_direction  $mom_kin_5th_axis_leader mom_sys_leader(fifth_axis)]
         }
      } elseif {$dir == 1} {
         set mom_out_angle_pos($a) $ang
      }
   }

   if {$axis == 3} {
      AUTO_CLAMP_SUB 0 fourth
      PB_CMD_fourth_axis_rotate_move
      AUTO_CLAMP_SUB 1 fourth
   } else {
      AUTO_CLAMP_SUB 0 fifth
      PB_CMD_fifth_axis_rotate_move
      AUTO_CLAMP_SUB 1 fifth
   }

   MOM_reload_variable -a mom_out_angle_pos
}
