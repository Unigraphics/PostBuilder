##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc PB_CMD_positive_z_down { } {
#=============================================================
#
# This custom command may be used for machine tools that need all Z output
# to have all Z values positive down.  This command will only work for 
# a Z spindle axis.  It will not support ZX or YZ circular interpolation.
#
# Copy the following line (without the #) and paste it into the 
# PB_CMD_before_motion custom command.
#
#PB_CMD_positive_z_down
 
   global mom_pos
   global mom_motion_type
   global mom_motion_event
   global mom_cycle_rapid_to_pos
   global mom_cycle_feed_to_pos
   global mom_cycle_retract_to_pos
   global mom_last_pos
   global cycle_init

   if {![info exists mom_last_pos(2)]} {set mom_last_pos(2) 100000.0}

   set delta [expr $mom_last_pos(2) - $mom_pos(2)]

   set mom_pos(2) [expr $mom_pos(2) * (-1.0)]

   set mom_last_pos(2) [expr $mom_pos(2) - $delta]

   if { ![string compare "CYCLE" $mom_motion_type] } {
      if {![info exists cycle_init]} {
         set mom_cycle_rapid_to_pos(2) [expr $mom_cycle_rapid_to_pos(2) * (-1.0)]
         set mom_cycle_feed_to_pos(2) [expr $mom_cycle_feed_to_pos(2) * (-1.0)]
         set mom_cycle_retract_to_pos(2) [expr $mom_cycle_retract_to_pos(2) * (-1.0)]
         if { ![string compare "initial_move" $mom_motion_event] } {set cycle_init 0}
      } else {
         unset cycle_init
      }
   }
}

