##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc PB_CMD_init_pivot_offsets { } {
#=============================================================
#
# This procedure can be used to define a 3-dimensional
# pivot offset distance from the spindle gauge point
# for 4/5-axis machines.
#
# This custom command will be executed automatically, when imported,
# by the posts created by Post Builder.
#
# For non-PostBuilder posts, this proc needs to be copied & pasted
# to the post and called in MOM_start_of_program event handler.
#
#
# New kinematic variables will be set as follows:
#
#   mom_kin_pivot_dist_vec(0) :
#               Distance from Pivot to Gauge point along  X direction
#   mom_kin_pivot_dist_vec(1) :
#               Distance from Pivot to Gauge point along  Y direction
#   mom_kin_pivot_dist_vec(2) :
#               Distance from Pivot to Gauge point along  Z direction,
#               It's default to mom_kin_pivot_gauge_offset.
#
# This array of variables supercedes the existing scalar variable
# mom_kin_pivot_gauge_offset for defining the pivotr gauge point offsets.
#

  global mom_kin_pivot_dist_vec
  global mom_kin_pivot_gauge_offset
  global mom_kin_machine_type


   if [info exists mom_kin_pivot_dist_vec] {
      unset mom_kin_pivot_dist_vec
   }

   if { ![info exists mom_kin_pivot_gauge_offset] } {
      set mom_kin_pivot_gauge_offset 0
   }

   if [info exists mom_kin_machine_type] {
      if { ![string match "*3_axis_mill*" $mom_kin_machine_type] && \
           ![string match "*lathe*"       $mom_kin_machine_type] && \
           ![string match "*wedm*"        $mom_kin_machine_type] } {

#<< User's inputs >>

         set mom_kin_pivot_dist_vec(0)  0.0
         set mom_kin_pivot_dist_vec(1)  0.0
         set mom_kin_pivot_dist_vec(2)  $mom_kin_pivot_gauge_offset
      }
   }

  # Reload the kin variables.
   MOM_reload_kinematics
}


