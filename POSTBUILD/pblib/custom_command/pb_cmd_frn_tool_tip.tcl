##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc PB_CMD_FEEDRATE_NUMBER { } {
#=============================================================
#
# This feed rate calculation will provide inverse time based
# on tool tip motion.  It will also check against minimum and
# maximum FRN numbers.  It also checks to see if the maximum
# DPM has been exceeded and adjusts the FRN so that the FRN
# does not force the rotary axis to exceed the maximum DPM.
# 
# Import this custom command into your post.  It does not need
# to be placed in an event marker.  it replaces the default 
# calculation for FRN.  This custom command can be used for 
# four or five axis posts.
#
   global mom_feed_rate_number
   global mom_mcs_goto
   global mom_prev_mcs_goto
   global mom_feed_rate
   global mom_kin_max_frn
   global mom_kin_min_frn
   global mom_kin_max_dpm
   global mom_warning_info

   VEC3_sub mom_mcs_goto mom_prev_mcs_goto delta
   set dist [VEC3_mag delta]

#
#  Calculate initial feed rate number.  This is feedrate in
#  IPM or MMPM divided by the distance in inches or mm. 
#  
   if {$dist < .0001} {set dist .0001}
   set f [expr $mom_feed_rate/$dist]
 
#
#  Determine the maximum rotary distance of either fourth or
#  fifth axis.  For a four axis, x is always zero.
#
   set rot_del [ASK_DELTA_4TH_OR_5TH 4]
   set x [ASK_DELTA_4TH_OR_5TH 5]
   if {$x > $rot_del} {set rot_del $x}

#
#  Calculate DPM.  DPM = delta degrees / minutes
#
   set dpm [expr $rot_del*$f]
#
#  Check for DPM being over max.  If so, calculate the time it
#  will take to move the rotary angles at maximum DPM the 
#  required number of degrees.
#
   if {$dpm > $mom_kin_max_dpm} {
      set mom_warning_info "Maximum degrees per minute exceeded, used maximum"
      set f [expr $mom_kin_max_dpm/$rot_del]
   }
#
#  Check for FRN being greater than format allows.
#
   if {$f > $mom_kin_max_frn} {
      set f $mom_kin_max_frn
      set mom_warning_info "Maximum FRN exceeded, used maximum"
      MOM_catch_warning
   }
#
#  Check for FRN being smaller than format allows.
#
   if {$f < $mom_kin_min_frn} {
      set f $mom_kin_min_frn
      set mom_warning_info "Minimum FRN exceeded, used minimum"
      MOM_catch_warning
   }
#
#  Insure FRN code comes out.  It is usually not modal.
#
   MOM_force once F
   return $f  
}



