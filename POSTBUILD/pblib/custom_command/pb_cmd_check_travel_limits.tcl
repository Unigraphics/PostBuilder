##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc PB_CMD_check_travel_limits { } {
#=============================================================
#
# This custom command may be used to check for the maximum
# travel for each axis.  A warning will be output for each
# GOTO that exceeds the limits.  It does not check for
# parallel axis such as Z and W.  It does not account for
# any modifications done by the user to mom_pos before the
# coordinates are output.
#
#
# Import and call this command in PB_CMD_before_motion.
#
#
   global mom_sys_max_travel 
   global mom_sys_min_travel
   global mom_kin_x_axis_limit
   global mom_kin_y_axis_limit
   global mom_kin_z_axis_limit
   global mom_pos 
   global mom_cycle_rapid_to_pos 
   global mom_cycle_feed_to_pos 
   global mom_cycle_retract_to_pos 
   global mom_motion_type
   global mom_warning_info

   if {![info exists mom_sys_max_travel]} {

      for {set i 0} {$i < 3} {incr i} {

         set mom_sys_max_travel($i) $mom_pos($i)
         set mom_sys_min_travel($i) $mom_pos($i)
      }

   } elseif { ![string compare "CYCLE" $mom_motion_type] } {

      for {set i 0} {$i < 3} {incr i} {

         if {$mom_cycle_rapid_to_pos($i) < $mom_sys_min_travel($i)} {
            set mom_sys_min_travel($i) $mom_cycle_rapid_to_pos($i)
         }
         if {$mom_cycle_rapid_to_pos($i) > $mom_sys_max_travel($i)} {
            set mom_sys_max_travel($i) $mom_cycle_rapid_to_pos($i)
         }
         if {$mom_cycle_feed_to_pos($i) < $mom_sys_min_travel($i)} {
            set mom_sys_min_travel($i) $mom_cycle_feed_to_pos($i)
         }
         if {$mom_cycle_feed_to_pos($i) > $mom_sys_max_travel($i)} {
            set mom_sys_max_travel($i) $mom_cycle_feed_to_pos($i)
         }
         if {$mom_cycle_retract_to_pos($i) < $mom_sys_min_travel($i)} {
            set mom_sys_min_travel($i) $mom_cycle_retract_to_pos($i)
         }
         if {$mom_cycle_retract_to_pos($i) > $mom_sys_max_travel($i)} {
            set mom_sys_max_travel($i) $mom_cycle_retract_to_pos($i)
         }
      }

   } else {
    
      for {set i 0} {$i < 3} {incr i} {
         if {$mom_pos($i) < $mom_sys_min_travel($i)} {
            set mom_sys_min_travel($i) $mom_pos($i)
         }
         if {$mom_pos($i) > $mom_sys_max_travel($i)} {
            set mom_sys_max_travel($i) $mom_pos($i)
         }
      }
   }

   if {[expr $mom_sys_max_travel(0) - $mom_sys_min_travel(0)] > $mom_kin_x_axis_limit} {
      set mom_warning_info "Maximum X axis travel exceeded, did not alter output"
      MOM_catch_warning
   }

   if {[expr $mom_sys_max_travel(1) - $mom_sys_min_travel(1)] > $mom_kin_y_axis_limit} {
      set mom_warning_info "Maximum Y axis travel exceeded, did not alter output"
      MOM_catch_warning
   }

   if {[expr $mom_sys_max_travel(2) - $mom_sys_min_travel(2)] > $mom_kin_z_axis_limit} {
      set mom_warning_info "Maximum Z axis travel exceeded, did not alter output"
      MOM_catch_warning
   }
}


