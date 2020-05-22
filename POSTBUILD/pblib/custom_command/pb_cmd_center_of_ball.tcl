##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc PB_CMD_center_of_ball_output { } {
#=============================================================
#
#  This command will output center of ball in every linear,
#  circular and rapid move block.
#
#  This function is only valid for the Fixed and Variable Axis
#  Surfacing Contouring modules in NX2 or newer.
#
#  You will also need to toggle on the Output Contact Data
#  option on the Machine Control dialog.  
#
#
#  Import this command to the post and call it in the
#  PB_CMD_before_motion command.
#
#
   global mom_contact_status


   if [info exist mom_contact_status] {

      if { $mom_contact_status == "ON" } {

         global mom_pos
         global mom_ball_center
         global mom_current_motion


         if {$mom_current_motion == "circular_move"} {

            set d(0) [expr $mom_pos(0) - $mom_ball_center(0)]
            set d(1) [expr $mom_pos(1) - $mom_ball_center(1)]
            set d(2) [expr $mom_pos(2) - $mom_ball_center(2)]
    
            global mom_arc_center
            global mom_prev_pos

            set mom_arc_center(0) [expr $mom_arc_center(0) - $d(0)]
            set mom_arc_center(1) [expr $mom_arc_center(1) - $d(1)]
            set mom_arc_center(2) [expr $mom_arc_center(2) - $d(2)]

            set mom_prev_pos(0) [expr $mom_prev_pos(0) - $d(0)]
            set mom_prev_pos(1) [expr $mom_prev_pos(1) - $d(1)]
            set mom_prev_pos(2) [expr $mom_prev_pos(2) - $d(2)]

         }

         set mom_pos(0) $mom_ball_center(0)
         set mom_pos(1) $mom_ball_center(1)
         set mom_pos(2) $mom_ball_center(2)

      }
   }
}


