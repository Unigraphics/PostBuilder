##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006, UGS PLM Solutions.  #
# Copyright (c) 2007/2008/2009/2010/2011/2012, SIEMENS PLM Softwares.        #
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
#  option on the Machine Control or Non-Cutting Moves (More...) dialog.  
#
#
#  ==> Import this command to the post and call it in the
#      PB_CMD_before_motion command.
#
#
# 04-19-2012 gsl - (6691512) Compute ball center when mom_contact_status is OFF.
#                - Does it need to verify if mom_tool_type is "Milling Tool-Ball Mill"?
# 04-25-2012 gsl - Add special handling for ENGAGE. For some reason, ENGAGE yields
#                  bad mom_ball_center data (0, 0, 0) in some cases.
#

   #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   # Set next variale to "1" to also output ball center for non-cutting moves
   #
   set output_ball_center_for_non_cut  0


   global mom_contact_status


   if [info exist mom_contact_status] {

      uplevel #0 {
       # Define function to compute ball center from tool-tip.
       if { [llength [info commands COMPUTE_BALL_CENTER]] == 0 } {

         proc COMPUTE_BALL_CENTER { } {
            global mom_kin_machine_type mom_tool_axis mom_spindle_axis
            global mom_ball_center mom_pos mom_tool_corner1_radius

            if [string match "3_axis*" $mom_kin_machine_type] {
               VMOV 3 mom_tool_axis spindle_axis
            } else {
               VMOV 3 mom_spindle_axis spindle_axis
            }

            foreach i { 0 1 2 } {
               set mom_ball_center($i) [expr $mom_pos($i) + $mom_tool_corner1_radius*$spindle_axis($i)]
            }
         }

       }
      }


      global mom_pos
      global mom_ball_center
      global mom_current_motion

      # When desired, compute ball center points for non-cutting moves
      if { $output_ball_center_for_non_cut && ![string match "ON" $mom_contact_status] } {

         COMPUTE_BALL_CENTER

         # Fake contact status to trigger calculation below
         set mom_contact_status ON
      }

      if { [string match "ON" $mom_contact_status] } {

         global mom_motion_type

         # Special handling for ENGAGE
         if { [string match "ENGAGE" $mom_motion_type] } {
            COMPUTE_BALL_CENTER
         }

         if { [string match "circular_move" $mom_current_motion] } {

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
