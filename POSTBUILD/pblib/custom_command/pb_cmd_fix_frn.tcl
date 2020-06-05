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
# ==> PB_CMD_FEEDRATE_NUMBER, PB_CMD_FEEDRATE_DPM & ASK_DELTA_4TH_OR_5TH provide
#     fixes to the generic method of FRN & DPM calculations.  Other commands may
#     be imported to output FRN or DPM with variants.
#
#=============================================================================
#
# PB_CMD_FEEDRATE_NUMBER        - Main command that calculates FRN feed rates.
#                                 Motion distance is calculated in part space.
# PB_CMD_FEEDRATE_NUMBER__Fanuc - Mimics Fanuc's method of FRN calculation
# PB_CMD_FEEDRATE_NUMBER__NX6   - Uses NX6's method of distance calculation
#                                 (via PB_CMD__NX6_discal) to compute FRN.
# PB_CMD_FEEDRATE_NUMBER__PB10  - Preserves the method of FRN calculation
#                                 implemented prior to Post Builder v10.
# PB_CMD_FEEDRATE_DPM           - This command also fixed DPM output problem with XZC posts.
# PB_CMD_FEEDRATE_DPM__Fanuc    - Mimics Fanuc's method of DPM calculation.
#                                 (Requires PB_CMD__NX6_discal)
# ASK_DELTA_4TH_OR_5TH          - Modified
#
# PB_CMD__NX6_discal            - Clone of NX6's method of motion distance calculation
#=============================================================================

## HEADER BLOCK END ##

#=============================================================
proc PB_CMD__NX6_discal { } {
#=============================================================
# This command mimics the distance calculation of a motion event
# using the formula implemented before NX7 in NX/Post.
#
# - Revisions -
# Nov-03-2014 gsl - Implemented
#
   global mom_rotary_delta_4th mom_rotary_delta_5th DEG2RAD

  # Re-compute rotary delta for XZC mill post
   global mom_kin_machine_type
   global mom_sys_coordinate_output_mode

   if { [string match "*mill_turn*" $mom_kin_machine_type] } {
      if { ![string compare "POLAR" $mom_sys_coordinate_output_mode] } {
         ASK_DELTA_4TH_OR_5TH 4
      }
   }

   set del_a(4) [expr abs($mom_rotary_delta_4th)]
   set del_a(5) [expr abs($mom_rotary_delta_5th)]

   global mom_pos mom_prev_pos

   set delta(0) [expr $mom_pos(0) - $mom_prev_pos(0)]
   set delta(1) [expr $mom_pos(1) - $mom_prev_pos(1)]
   set delta(2) [expr $mom_pos(2) - $mom_prev_pos(2)]

  # Linear distance
   set dist [VEC3_mag delta]


   global mom_tool_tracking_height mom_kin_tool_tracking_height
   set track_ht 0.0

   if { [info exists mom_tool_tracking_height] && $mom_tool_tracking_height > 0.0 } {
      set track_ht $mom_tool_tracking_height
   }
   if { [EQ_is_zero $track_ht] && [info exists mom_kin_tool_tracking_height] && $mom_kin_tool_tracking_height > 0.0 } {
      set track_ht $mom_kin_tool_tracking_height
   }

   global mom_kin_4th_axis_min_incr mom_kin_5th_axis_min_incr
   global mom_kin_4th_axis_type mom_kin_5th_axis_type
   global mom_mcs_goto mom_prev_mcs_goto
   global mom_kin_4th_axis_plane mom_kin_5th_axis_plane
   global mom_kin_pivot_gauge_offset mom_tool_offset
   global mom_kin_4th_axis_point mom_kin_5th_axis_point
   global mom_kin_4th_axis_vector mom_kin_5th_axis_vector

   set rdist4 0.0
   set rdist5 0.0

   foreach { ix min_incr axis_type axis_plane rotary_delta } \
             [list 4 $mom_kin_4th_axis_min_incr $mom_kin_4th_axis_type $mom_kin_4th_axis_plane $mom_rotary_delta_4th \
                   5 $mom_kin_5th_axis_min_incr $mom_kin_5th_axis_type $mom_kin_5th_axis_plane $mom_rotary_delta_5th] {

      if { ![EQ_is_zero_tol $del_a($ix) $min_incr] } {

         if { ![string compare "Table" $axis_type] } {

            set work1(0) $mom_mcs_goto(0)
            set work1(1) $mom_mcs_goto(1)
            set work1(2) $mom_mcs_goto(2)
            set work2(0) $mom_prev_mcs_goto(0)
            set work2(1) $mom_prev_mcs_goto(1)
            set work2(2) $mom_prev_mcs_goto(2)

           #  REMOVE NON-INVOLVED AXES */
            switch $axis_plane {
               "YZ" {
                  set work1(0) 0.0
                  set work2(0) 0.0
               }
               "ZX" {
                  set work1(1) 0.0
                  set work2(1) 0.0
               }
               "XY" {
                  set work1(2) 0.0
                  set work2(2) 0.0
               }
               default {}
            }

            set rads [VEC3_mag work1]
            set rade [VEC3_mag work2]
            set radav2 [expr ($rads + $rade)/2.0]

            if { [EQ_is_zero $track_ht] } {
               set radav1 $radav2
            } else {
               set work1(0) [expr $mom_mcs_goto(0) + $mom_mcs_goto(3)*$track_ht]
               set work1(1) [expr $mom_mcs_goto(1) + $mom_mcs_goto(4)*$track_ht]
               set work1(2) [expr $mom_mcs_goto(2) + $mom_mcs_goto(5)*$track_ht]
               set work2(0) [expr $mom_prev_mcs_goto(0) + $mom_prev_mcs_goto(3)*$track_ht]
               set work2(1) [expr $mom_prev_mcs_goto(1) + $mom_prev_mcs_goto(4)*$track_ht]
               set work2(2) [expr $mom_prev_mcs_goto(2) + $mom_prev_mcs_goto(5)*$track_ht]

              #  REMOVE NON-INVOLVED AXES
               switch $axis_plane {
                  "YZ" {
                     set work1(0) 0.0
                     set work2(0) 0.0
                  }
                  "ZX" {
                     set work1(1) 0.0
                     set work2(1) 0.0
                  }
                  "XY" {
                     set work1(2) 0.0
                     set work2(2) 0.0
                  }
                  default {}
               }

               set rads [VEC3_mag work1]
               set rade [VEC3_mag work2]
               set radav1 [expr ($rads + $rade)/2.0]
            }

         } else { ;# Head

           #  IF ROTARY AXIS IS SWIVELING HEAD RADIUS = ZPIVOT + ZOFF
            if { [info exists mom_kin_pivot_gauge_offset] && [info exists mom_tool_offset(2)] } {
               set radav2 [expr $mom_kin_pivot_gauge_offset + $mom_tool_offset(2)]
            } else {
               set radav2 0.0
            }

            if { [EQ_is_zero $track_ht] } {
               set radav1 $radav2
            } else {
               set radav1 [expr $radav2 - $track_ht]
            }
         }

         if [expr $radav1 > $radav2] {
            set rdist${ix} [expr $radav1 * $DEG2RAD * $rotary_delta]
         } else {
            set rdist${ix} [expr $radav2 * $DEG2RAD * $rotary_delta]
         }
      }
   }


  # Total distance
   set tdist [expr sqrt( $dist*$dist + $rdist4*$rdist4 + $rdist5*$rdist5 )]

return $tdist
}


#=============================================================
proc PB_CMD_FEEDRATE_DPM__Fanuc { } {
#=============================================================
# This command returns the feed rate in degrees per minute.
# It mimics the DPM calculation for Fanuc controllers.
# It can be called in the PB_CMD_FEEDRATE_DPM to overwrite
# the default implementaion.
#
# - Revisions -
# Nov-03-2014 gsl - Implemented (according to PW)
#

   global mom_event_time mom_pos mom_prev_pos
   global mom_rotary_delta_4th mom_rotary_delta_5th
   global mom_motion_distance mom_feed_rate mom_event_time

  # Force NX6's distance calculation
   set mom_motion_distance [PB_CMD__NX6_discal]
   MOM_reload_variable mom_motion_distance

   set mom_event_time [expr $mom_motion_distance / $mom_feed_rate]
   MOM_reload_variable mom_event_time


  # Re-compute rotary delta for XZC mill post
   global mom_kin_machine_type
   global mom_sys_coordinate_output_mode

   if { [string match "*mill_turn*" $mom_kin_machine_type] } {
      if { ![string compare "POLAR" $mom_sys_coordinate_output_mode] } {
         ASK_DELTA_4TH_OR_5TH 4
      }
   }

   set total_distance [expr sqrt( ($mom_pos(0) - $mom_prev_pos(0)) * ($mom_pos(0) - $mom_prev_pos(0)) +\
                                  ($mom_pos(1) - $mom_prev_pos(1)) * ($mom_pos(1) - $mom_prev_pos(1)) +\
                                  ($mom_pos(2) - $mom_prev_pos(2)) * ($mom_pos(2) - $mom_prev_pos(2)) +\
                                  ($mom_rotary_delta_4th * $mom_rotary_delta_4th) +\
                                  ($mom_rotary_delta_5th * $mom_rotary_delta_5th) )]

   global mom_kin_max_dpm mom_feed_rate_dpm

   set d_pm [expr $total_distance / $mom_event_time]
   if { [expr $d_pm > $mom_kin_max_dpm ] } {
      set d_pm $mom_kin_max_dpm
   }
 
   set mom_feed_rate_dpm $d_pm
   MOM_reload_variable mom_feed_rate_dpm

return $d_pm
}


#=============================================================
proc PB_CMD_FEEDRATE_NUMBER__Fanuc { } {
#=============================================================
# This command mimics the FRN calculation of Fanuc controllers.
#
# This custom command can be imported and executed in the
# PB_CMD_FEEDRATE_NUMBER command.
#
#
# - REVISIONS -
# Oct-28-2014 gsl - Revised for PW/Fanuc FRN calculation
#
   global mom_feed_rate_number
   global mom_feed_rate
   global mom_kin_max_frn
   global mom_kin_min_frn
   global mom_kin_max_dpm
   global mom_warning_info
   global mom_kin_machine_type


  # Original FRN - based on mom_motion_distance
  #
   global mom_sys_frn_factor


  # Set default FRN factor, if not defined.
   if { ![info exists mom_sys_frn_factor] } {
      set mom_sys_frn_factor 1.0
   }


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Uncomment next statement to overload FRN factor, when necessary
  # to adjust the result of FRN calculation.
  # - It may also be set to 60 to output FRN in (1/second).

  # set mom_sys_frn_factor 1.0


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

     # Rotary angles
      global mom_rotary_delta_4th mom_rotary_delta_5th DEG2RAD

     # Re-compute rotary delta for XZC mill post
      global mom_sys_coordinate_output_mode

      if { [string match "*mill_turn*" $mom_kin_machine_type] } {
         if { ![string compare "POLAR" $mom_sys_coordinate_output_mode] } {
            ASK_DELTA_4TH_OR_5TH 4
         }
      }

      set a4 [expr abs($mom_rotary_delta_4th)]
      set a5 [expr abs($mom_rotary_delta_5th)]

      global mom_pos mom_prev_pos

      set delta(0) [expr $mom_pos(0) - $mom_prev_pos(0)]
      set delta(1) [expr $mom_pos(1) - $mom_prev_pos(1)]
      set delta(2) [expr $mom_pos(2) - $mom_prev_pos(2)]


     #++++++++++++++++++++
     # According to Fanuc
     #++++++++++++++++++++
      set dist_max [expr sqrt( $delta(0)*$delta(0) + $delta(1)*$delta(1)  + $delta(2)*$delta(2) + $a4*$a4 + $a5*$a5 )]


      if { $dist_max < .0001 } { set dist_max .0001 }

      set frn [expr $mom_feed_rate / $dist_max]


     # => Fanuc uses total travel to compute DPM
     #
      set rot_del $dist_max

     # Calculate DPM.  DPM = delta degrees * FRN
     #
      set dpm [expr $rot_del * $frn]

     # Check for DPM being over max.  If so, calculate the time it
     # will take to move the rotary angles at maximum DPM the
     # required number of degrees.
     #
      if { $dpm > $mom_kin_max_dpm } {
         set dpm $mom_kin_max_dpm
         set frn [expr $dpm/$rot_del]
         CATCH_WARNING "Maximum degrees per minute exceeded, used maximum"
      }

   } ;# multi-axis


  # Fudge FRN number with the given factor
   if { ![EQ_is_equal $mom_sys_frn_factor 1.0] } {
      set frn [expr $frn * $mom_sys_frn_factor]
   }


  # Check for FRN being greater than format allows.
  #
   if { $frn > $mom_kin_max_frn } {
      set frn $mom_kin_max_frn
      CATCH_WARNING "Over maximum FRN, use maximum"
   }

  # Check for FRN being smaller than format allows.
  #
   if { $frn < $mom_kin_min_frn } {
      set frn $mom_kin_min_frn
      CATCH_WARNING "Under minimum FRN, use minimum"
   }

   set mom_feed_rate_number $frn
   MOM_reload_variable mom_feed_rate_number


  # Ensure FRN code comes out.  It is usually not modal.
  #
   MOM_force once F

return $frn
}


#=============================================================
proc PB_CMD_FEEDRATE_NUMBER { } {
#=============================================================
# Import this custom command into your post.  It does not need
# to be placed with any event marker. It will replace default
# method of FRN calculation (of ugpost_base).
# This custom command can be used for four or five axis posts.
#
#
# - REVISIONS -
#<10-09-08 gsl> Correct computation for 5-axis FRN
#<06-05-09 gsl> Prepared for pb7.0 release
#<06-17-09 gsl> Use mcs_goto to calculate distance for multi-axis case
#<06-03-10 gsl> Add option to use mom_pos for calculation
#<02-11-14 gsl> Add comments for overloading frn factor
#<11-05-14 gsl> (pb10.01) Simplified length calculation
#

# Uncomment a statement below, if a different method of FRN calculation is preferred.
#
#return [PB_CMD_FEEDRATE_NUMBER__Fanuc]
#return [PB_CMD_FEEDRATE_NUMBER__NX6]
#return [PB_CMD_FEEDRATE_NUMBER__PB10]



  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # "__dist_cal_method" specifies method for distance calculation
  #
  #   "MOM_POS"   - use "mom_pos"  : N/C coordinates
  #   "MCS_GOTO"  - use "mcs_goto" : tool-path points
  #
  # ==> MCS_GOTO would produce proper length of a motion.

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
   global mom_sys_frn_factor


  # Set default FRN factor, if not defined.
   if { ![info exists mom_sys_frn_factor] } {
      set mom_sys_frn_factor 1.0
   }

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Uncomment next statement to overload FRN factor, when necessary
  # to adjust the result of FRN calculation.
  # - It may also be set to 60 to output FRN in (1/second).

  # set mom_sys_frn_factor 1.0


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

     # Re-compute linear & rotary delta for XZC mill post
      global mom_sys_coordinate_output_mode

      if { [string match "*mill_turn*" $mom_kin_machine_type] } {
         if { ![string compare "POLAR" $mom_sys_coordinate_output_mode] } {
            ASK_DELTA_4TH_OR_5TH 4
         }
      }

      global mom_pos mom_prev_pos
      global mom_mcs_goto mom_prev_mcs_goto

     #--------------------------------------
     # Switch method for computing distance
     #
      if { [string match "MOM_POS" $__dist_cal_method] } {
         set delta(0) [expr $mom_pos(0) - $mom_prev_pos(0)]
         set delta(1) [expr $mom_pos(1) - $mom_prev_pos(1)]
         set delta(2) [expr $mom_pos(2) - $mom_prev_pos(2)]
      } else {
         set delta(0) [expr $mom_mcs_goto(0) - $mom_prev_mcs_goto(0)]
         set delta(1) [expr $mom_mcs_goto(1) - $mom_prev_mcs_goto(1)]
         set delta(2) [expr $mom_mcs_goto(2) - $mom_prev_mcs_goto(2)]
      }


     # Linear distance
      set dist [VEC3_mag delta]


      if { $dist < .0001 } { set dist .0001 }

      set mom_motion_distance $dist
      MOM_reload_variable mom_motion_distance

      set frn [expr $mom_feed_rate / $dist]

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
         CATCH_WARNING "Maximum degrees per minute exceeded, used maximum"
      }

      global mom_feed_rate_dpm
      set mom_feed_rate_dpm $dpm
      MOM_reload_variable mom_feed_rate_dpm

   } ;# multi-axis


   global mom_event_time
   set mom_event_time [expr 1.0/$frn]
   MOM_reload_variable mom_event_time

   set frn [expr $frn * $mom_sys_frn_factor]

  # Check for FRN being greater than format allows.
  #
   if { $frn > $mom_kin_max_frn } {
      set frn $mom_kin_max_frn
      CATCH_WARNING "Over maximum FRN, use maximum"
   }

  # Check for FRN being smaller than format allows.
  #
   if { $frn < $mom_kin_min_frn } {
      set frn $mom_kin_min_frn
      CATCH_WARNING "Under minimum FRN, use minimum"
   }

   set mom_feed_rate_number $frn
   MOM_reload_variable mom_feed_rate_number


  # Ensure FRN code comes out.  It is usually not modal.
  #
   MOM_force once F

return $frn
}


#=============================================================
proc PB_CMD_FEEDRATE_NUMBER__NX6 { } {
#=============================================================
# This command uses NX6's method for distance calculation and
# will adjust the values of mom_motion_distance and mom_event_time.
#
# It may be called in PB_CMD_FEEDRATE_NUMBER to overwrite the
# generic FRN calculation.
#
#
# - REVISIONS -
# Nov-07-2014 gsl - Implemented
#

   global mom_feed_rate_number
   global mom_feed_rate
   global mom_kin_max_frn
   global mom_kin_min_frn
   global mom_kin_max_dpm
   global mom_warning_info


  # Original FRN - based on mom_motion_distance
  #
   global mom_sys_frn_factor


  # Set default FRN factor, if not defined.
   if { ![info exists mom_sys_frn_factor] } {
      set mom_sys_frn_factor 1.0
   }


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Uncomment next statement to overload FRN factor, when necessary
  # to adjust the result of FRN calculation.
  # - It may also be set to 60 to output FRN in (1/second).

  # set mom_sys_frn_factor 1.0


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
   global mom_motion_distance mom_event_time

   if { ![info exists mom_motion_distance] } {
       set mom_motion_distance 0.0
   }


  # Devise NX6's method of motion distance calculation
   set mom_motion_distance [PB_CMD__NX6_discal]
   MOM_reload_variable mom_motion_distance

   set dist $mom_motion_distance


   if { $dist < .0001 } { set dist .0001 }
   set frn [expr $mom_feed_rate / $dist]


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
      set dpm $mom_kin_max_dpm
      set frn [expr $dpm/$rot_del]
      CATCH_WARNING "Maximum degrees per minute exceeded, used maximum"
   }

  # Adjust time per resultant FRN
   set mom_event_time [expr 1.0/$frn]
   MOM_reload_variable mom_event_time


  # Fudge FRN number with the given factor
   if { ![EQ_is_equal $mom_sys_frn_factor 1.0] } {
      set frn [expr $frn * $mom_sys_frn_factor]
   }


  # Check for FRN being greater than format allows.
  #
   if { $frn > $mom_kin_max_frn } {
      set frn $mom_kin_max_frn
      CATCH_WARNING "Over maximum FRN, use maximum"
   }

  # Check for FRN being smaller than format allows.
  #
   if { $frn < $mom_kin_min_frn } {
      set frn $mom_kin_min_frn
      CATCH_WARNING "Under minimum FRN, use minimum"
   }

   set mom_feed_rate_number $frn
   MOM_reload_variable mom_feed_rate_number


  # Ensure FRN code comes out.  It is usually not modal.
  #
   MOM_force once F

return $frn
}


#=============================================================
proc PB_CMD_FEEDRATE_NUMBER__PB10 { } {
#=============================================================
# This commands preserves the method of FRN calculation
# between Post Builder v7.0 to v10.0.
#
# It may be called in PB_CMD_FEEDRATE_NUMBER to overwrite the
# generic FRN calculation.
#
#
# - REVISIONS -
#<10-09-08 gsl> Correct computation for 5-axis FRN
#<06-05-09 gsl> Prepared for pb7.0 release
#<06-17-09 gsl> Use mcs_goto to calculate distance for multi-axis case
#<06-03-10 gsl> Add option to use mom_pos for calculation
#<02-11-14 gsl> Add comments for overloading frn factor
#<11-07-14 gsl> Renamed from PB_CMD_FEEDRATE_NUMBER to preserve old method
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
   global mom_sys_frn_factor


  # Set default FRN factor, if not defined.
   if { ![info exists mom_sys_frn_factor] } {
      set mom_sys_frn_factor 1.0
   }

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Uncomment next statement to overload FRN factor, when necessary
  # to adjust the result of FRN calculation.
  # - It may also be set to 60 to output FRN in (1/second).

  # set mom_sys_frn_factor 1.0


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

   set mom_feed_rate_number $frn
   MOM_reload_variable mom_feed_rate_number


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
# - REVISIONS -
#<12-15-08 gsl> Handle XZC mill-turn case
#<11-07-14 gsl> Added use of PB_CMD_FEEDRATE_DPM__Fanuc (commented)
#

# Uncomment next statement to compute DPM per Fanuc's formula
#return [PB_CMD_FEEDRATE_DPM__Fanuc]


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
# - REVISIONS -
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



