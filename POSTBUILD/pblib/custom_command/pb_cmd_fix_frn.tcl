## HEADER BLOCK START ##
##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006, UGS PLM Solutions.  #
# Copyright (c) 2007/2008/2009/2010/2011, SIEMENS PLM Softwares.             #
#                                                                            #
##############################################################################
#                    P B _ C M D _ F I X _ F R N . T C L
##############################################################################
#
# Commands in this file can be used to fix the problem with FRN feedrate output.
# They override the same commands defined in "ugpost_base.tcl".
#
# ==> You need to import all commands here to fix the FRN problem.
#
#=============================================================================
#
# PB_CMD_FEEDRATE_NUMBER   - Main command that calculates FRN feed rates. It also relies on
#                            the correctness of the other 2 commands in this file.
#                            -> You may choose to use mom_mcs_goto (default)
#                               or mom_pos for the calculation.
# PB_CMD_FEEDRATE_DPM      - This command also fixed the DPM output problem with XZC posts.
# ASK_DELTA_4TH_OR_5TH     - Modified
#
#=============================================================================
#@<DEL>@     TEXT ENCLOSED WITHIN DELETE MARKERS WILL BE REMOVED UPON RELEASE.
#
# - REVISIONS
#======
# v700
#======
#<10-09-08 gsl> Correct computation for 5-axis FRN
#<06-05-09 gsl> Prepared for pb7.0 release
#======
# v750
#======
#<06-17-09 gsl> Use mcs_goto to calculate distance for multi-axis case
#<10-13-09 gsl> "3_axis_mill" was "*3_axis_mill*".
#======
# v751
#======
#<06-03-10 gsl> Add option in PB_CMD_FEEDRATE_NUMBER to use mom_pos in calculation
#======
# v752
#======
# 07-19-10 gsl - Add use of __dist_cal_method in PB_CMD_FEEDRATE_NUMBER to switch
#                between "mom_pos" & "mcs_goto" for distance calculation
#======
# v800
#======
# 09-21-10 gsl - Add comments
# 01-27-11 gsl - Add header block
##############################################################################
# TEXT ENCLOSED WITHIN DELETE MARKERS WILL BE REMOVED UPON RELEASE.    @<DEL>@

## HEADER BLOCK END ##


#=============================================================
proc PB_CMD_FEEDRATE_NUMBER { } {
#=============================================================
# Import this custom command into your post.  It does not need
# to be placed with any event marker. It replaces the default 
# calculation for FRN.  This custom command can be used for 
# four or five axis posts.
#
#
# - REVISIONS
#<10-09-08 gsl> Correct computation for 5-axis FRN
#<06-05-09 gsl> Prepared for pb7.0 release
#<06-17-09 gsl> Use mcs_goto to calculate distance for multi-axis case
#<06-03-10 gsl> Add option to use mom_pos for calculation
#

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # "__dist_cal_method" specifies method for distance calculation
  #
  #   "MCS_GOTO"  - use "mcs_goto" : tool-path points
  #   "MOM_POS"   - use "mom_pos"  : N/C coordinates
  #

   set __dist_cal_method "MCS_GOTO"

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


   global mom_feed_rate_number
   global mom_feed_rate
   global mom_kin_max_frn
   global mom_kin_min_frn
   global mom_kin_max_dpm
   global mom_warning_info
   global mom_kin_machine_type


  # Original FRN - based on mom_motion_distance
  #
   global mom_feed_rate_number
   global mom_sys_frn_factor
   global mom_kin_max_frn


  #-----------------------------------------------------------
  # FRN factor can be set to 60 to output numbers in 1/second
  #
   if { ![info exists mom_sys_frn_factor] } {
      set mom_sys_frn_factor 1.0
   }

   set frn 0.0

   if { [info exists mom_feed_rate_number] } {

      set frn [expr $mom_feed_rate_number * $mom_sys_frn_factor]
      if { [EQ_is_gt $frn $mom_kin_max_frn] } {
         set frn $mom_kin_max_frn
      }
   }

   set frn_org $frn



  #===============
  # Recompute FRN
  #
   global mom_motion_distance

   if { ![info exists mom_motion_distance] } {
       set mom_motion_distance 0.0
   }

   set dist $mom_motion_distance


   if { [string match "3_axis_mill" $mom_kin_machine_type] } {

      if { $dist < .0001 } { set dist .0001 }
      set frn [expr $mom_feed_rate / $dist]

   } else {

     # - Compute arc length - Account for curvature contributed by each rotary axis
     #
      global mom_rotary_delta_4th mom_rotary_delta_5th DEG2RAD

     # Re-compute linear & rotary delta for XZC mill post
      global mom_sys_coordinate_output_mode
      if { [string match "*mill_turn*" $mom_kin_machine_type] } {
         if { ![string compare "POLAR" $mom_sys_coordinate_output_mode] } {
            ASK_DELTA_4TH_OR_5TH 4
         }
      }

      set a4 [expr abs($mom_rotary_delta_4th) * $DEG2RAD]
      set a5 [expr abs($mom_rotary_delta_5th) * $DEG2RAD]

      set AL4 0.0
      set AL5 0.0

      set BG4 0.0
      set BG5 0.0

     #--------------------------------------
     # Switch method for computing distance
     #
     if { [string match "MOM_POS" $__dist_cal_method] } {
        global mom_pos mom_prev_pos

        set delta(0) [expr $mom_pos(0) - $mom_prev_pos(0)]
        set delta(1) [expr $mom_pos(1) - $mom_prev_pos(1)]
        set delta(2) [expr $mom_pos(2) - $mom_prev_pos(2)]
     } else {
        global mom_mcs_goto mom_prev_mcs_goto

        set delta(0) [expr $mom_mcs_goto(0) - $mom_prev_mcs_goto(0)]
        set delta(1) [expr $mom_mcs_goto(1) - $mom_prev_mcs_goto(1)]
        set delta(2) [expr $mom_mcs_goto(2) - $mom_prev_mcs_goto(2)]
     }

      set dist [VEC3_mag delta]

      global mom_kin_4th_axis_vector mom_kin_5th_axis_vector

      if { ![EQ_is_zero $a4] } {
        # - Projected length
         set s [VEC3_dot delta mom_kin_4th_axis_vector]
         set p [expr sqrt(abs($dist*$dist - $s*$s))]

        # - Radius of curvature
         set R4 [expr ($p/2.0) / sin($a4/2.0)]

        # - Arc length
         set AL4 [expr $R4 * $a4]

        # - Bulge
         set BG4 [expr $AL4 - $p]
      }

      if { ![EQ_is_zero $a5] } {
        # - Projected length
         set s [VEC3_dot delta mom_kin_5th_axis_vector]
         set p [expr sqrt(abs($dist*$dist - $s*$s))]

        # - Radius of curvature
         set R5 [expr ($p/2.0) / sin($a5/2.0)]

        # - Arc length
         set AL5 [expr $R5 * $a5]

        # - Bulge
         set BG5 [expr $AL5 - $p]
      }

      set dist_BG [expr sqrt($dist*$dist + $BG4*$BG4 + $BG5*$BG5)]


      set dist_max [lindex [lsort -real [list $dist $AL4 $AL5 $dist_BG]] end]

      if { $dist_max < .0001 } { set dist_max .0001 }

      set frn [expr $mom_feed_rate / $dist_max]



     # Determine the maximum rotary displacement of either 4th or 5th axis.
     # For a 4-axis, x is always zero.
     #
      set rot_del [ASK_DELTA_4TH_OR_5TH 4]
      set x [ASK_DELTA_4TH_OR_5TH 5]
      if { $x > $rot_del } {
         set rot_del $x
      }

     # Calculate DPM.  DPM = delta degrees * FRN
     #
      set dpm [expr $rot_del * $frn]

     # Check for DPM being over max.  If so, calculate the time it
     # will take to move the rotary angles at maximum DPM the 
     # required number of degrees.
     #
      if { $dpm > $mom_kin_max_dpm } {
         set frn [expr $mom_kin_max_dpm/$rot_del]
         set mom_warning_info "Maximum degrees per minute exceeded, used maximum"
         MOM_catch_warning
      }

   } ;# multi-axis


   set frn [expr $frn * $mom_sys_frn_factor]


  # Check for FRN being greater than format allows.
  #
   if { $frn > $mom_kin_max_frn } {
      set frn $mom_kin_max_frn
      set mom_warning_info "Over maximum FRN, use maximum"
      MOM_catch_warning
   }

  # Check for FRN being smaller than format allows.
  #
   if { $frn < $mom_kin_min_frn } {
      set frn $mom_kin_min_frn
      set mom_warning_info "Under minimum FRN, use minimum"
      MOM_catch_warning
   }


  # Ensure FRN code comes out.  It is usually not modal.
  #
   MOM_force once F

return $frn
}


#=============================================================
proc PB_CMD_FEEDRATE_DPM { } {
#=============================================================
# Returns feed rate in degrees per min
#
#
# - REVISIONS
#<12-15-08 gsl> Handle XZC mill-turn case
#

   global   mom_feed_rate_dpm

  # mom_feed_rate_dpm is always zero in XZC-mill post
  # - Use FRN to compute DPM
   global mom_kin_machine_type mom_sys_coordinate_output_mode

   if { [string match "*mill_turn*" $mom_kin_machine_type] } {

      if { [string match "POLAR" $mom_sys_coordinate_output_mode] } {

         set f_rn [PB_CMD_FEEDRATE_NUMBER]
         set minrot [ASK_SMALLER_OF_4TH_5TH]
         set d_pm [expr $minrot * $f_rn]

return $d_pm
      }
   }

   if { [info exists mom_feed_rate_dpm] } {

return $mom_feed_rate_dpm

   } else {

      set f_rn [PB_CMD_FEEDRATE_NUMBER]
      set minrot [ASK_SMALLER_OF_4TH_5TH]
      set d_pm [expr $minrot * $f_rn]

return $d_pm
   }
}


#=============================================================
proc ASK_DELTA_4TH_OR_5TH { axis_no } {
#=============================================================
# Returns the delta rotation in degrees of the axis_no(4 or 5)
#
#
# - REVISIONS
#<12-15-08 gsl> Overload this command defined in ugpost_base.tcl
#<01-07-09 gsl> Ensured this command returns absolute value
#

   global   mom_pos mom_prev_pos
   global   mom_rotary_delta_4th mom_rotary_delta_5th

  # Recompute 4th delta for polar output of XZC mill post
  # ==> mom_kin_machine_type has been set to "mill_turn"
  #     in LINEARIZE_OUTPUT before FEEDRATE_SET is called.
  #
   global mom_out_angle_pos
   global mom_kin_machine_type mom_sys_coordinate_output_mode

   if { [string match "*mill_turn*" $mom_kin_machine_type] } {
      if { [string match "POLAR" $mom_sys_coordinate_output_mode] } {
         set mom_rotary_delta_4th [expr $mom_out_angle_pos(0) - $mom_prev_pos(3)]
      }
   }


   if { $axis_no == 4 && [info exists mom_rotary_delta_4th] } {
return [expr abs($mom_rotary_delta_4th)]
   }

   if { $axis_no == 5 && [info exists mom_rotary_delta_5th] } {
return [expr abs($mom_rotary_delta_5th)]
   }

   incr axis_no -1
   set abs_rotdel [expr abs(abs($mom_pos($axis_no)) - abs($mom_prev_pos($axis_no)))]

   if { [EQ_is_gt $abs_rotdel 180.0] } {
      set rotdel [expr 360.0 - $abs_rotdel]
   } else {
      set rotdel $abs_rotdel
   }

return $rotdel
}


