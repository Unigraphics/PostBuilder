########################### Virtual NC Controller ############################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006, UGS PLM Solutions.  #
#                                                                            #
##############################################################################
#                       V N C _ C O M M O N _ V 3 5 0 . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains handlers for incremental VNC conversion to v350.
#
##############################################################################


#=============================================================
proc PB_CMD_vnc__G_misc_code { } {
#=============================================================
  global mom_sim_pos
  global mom_sim_nc_register
  global mom_sim_nc_func
  global mom_sim_wcs_offsets


   set codes_list [list]

   set var_list [list]
    lappend var_list mom_sim_nc_func(DELAY_SEC)
    lappend var_list mom_sim_nc_func(DELAY_REV)
    lappend var_list mom_sim_nc_func(UNIT_IN)
    lappend var_list mom_sim_nc_func(UNIT_MM)
    lappend var_list mom_sim_nc_func(RETURN_HOME)
    lappend var_list mom_sim_nc_func(RETURN_HOME_P)
    lappend var_list mom_sim_nc_func(FROM_HOME)
    lappend var_list mom_sim_nc_func(MACH_CS_MOVE)
    lappend var_list mom_sim_nc_func(WORK_CS_1)
    lappend var_list mom_sim_nc_func(WORK_CS_2)
    lappend var_list mom_sim_nc_func(WORK_CS_3)
    lappend var_list mom_sim_nc_func(WORK_CS_4)
    lappend var_list mom_sim_nc_func(WORK_CS_5)
    lappend var_list mom_sim_nc_func(WORK_CS_6)
    lappend var_list mom_sim_nc_func(LOCAL_CS_SET)
    lappend var_list mom_sim_nc_func(WORK_CS_RESET)

   foreach var $var_list {
     if [info exists $var] {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

         if [string match "$mom_sim_nc_func(DELAY_SEC)" $code] {

         } elseif [string match "$mom_sim_nc_func(DELAY_REV)" $code] {

         } elseif [string match "$mom_sim_nc_func(UNIT_IN)" $code] {

            set mom_sim_nc_register(UNIT) IN
            PB_SIM_call SIM_set_mtd_units "INCH" 


         } elseif [string match "$mom_sim_nc_func(UNIT_MM)" $code] {

            set mom_sim_nc_register(UNIT) MM
            PB_SIM_call SIM_set_mtd_units "MM" 


         } elseif [string match "$mom_sim_nc_func(RETURN_HOME)" $code] {

           # Coord specified with this command is stored as the "intermediate point" that
           # the tool will position in rapid mode before going to the reference point.
           # Intermediate point (each axis) stays modal for future G28/G29.
           #
           # This command cancels cutcom and tool offsets.
           #
           # Axes of the "intermediate point" only exist when specified. Default it to
           # the ref. pt. will not be sufficient.
           # The int. pt. floats with respect to the active WCS (G54 - G59).
           # Reference point is fixed on a machine.
   
            set mom_sim_nc_register(RETURN_HOME) 1

           # Fetch the main home position, if any.
            global mom_sim_main_home_pos mom_sim_home_pos
            if [info exists mom_sim_main_home_pos] {
               set mom_sim_home_pos(0) $mom_sim_main_home_pos(0)
               set mom_sim_home_pos(1) $mom_sim_main_home_pos(1)
               set mom_sim_home_pos(2) $mom_sim_main_home_pos(2)
            }


         } elseif [string match "$mom_sim_nc_func(RETURN_HOME_P)" $code] {

           # G30 P2 XYZ -- Return to the 2nd ref pt. P2 can be omitted.
           # G30 P3 XYZ -- Return to the 3rd ref pt.
           # G30 P4 XYZ -- Return to the 4th ref pt.
           #
           # G30 & G28 share the same intermediate point. I think?.

            set mom_sim_nc_register(RETURN_HOME_P) 1

           # Save away the main home position.
            global mom_sim_main_home_pos
            if ![info exists mom_sim_main_home_pos] {
               set mom_sim_main_home_pos(0) $mom_sim_home_pos(0)
               set mom_sim_main_home_pos(1) $mom_sim_home_pos(1)
               set mom_sim_main_home_pos(2) $mom_sim_home_pos(2)
            }

           # Set an auxiliary home position as the target.


         } elseif [string match "$mom_sim_nc_func(FROM_HOME)" $code] {

           # This command is normally issued immediately after a G28.
           #
           # Coord specified with this function is the target that the tool will position.
           # The tool will first position from the ref. pt. to the "intermediate point"
           # that have been defined in the previous G28 command, if any, in rapid mode
           # before going to its final destination.

            set mom_sim_nc_register(FROM_HOME) 1

         } elseif [string match "$mom_sim_nc_func(WORK_CS_RESET)" $code] {

           # Disable work coord reset if S is in the block.
           # G92 is used to set max spindle speed to S register.
            global mom_sim_address
            if [VNC_parse_nc_block mom_sim_o_buffer $mom_sim_address(S,leader)] {
return
            }


           # G92 redefines the 0th WCS (main CSYS). This can also be done with "G10 L2 P0 X Y Z",
           # MDI'ed or set by machine builder.  Both G92 & G10 observe G90/G91 mode.
           # The coordinates in the block will be used to calculate the offsets in
           # PB_CMD_vnc__reset_coordinate. No motion will be produced.
           #
           # Offsets will be added to the subsequent moves regardless of which WCS is in use.
           #
           # Subsequent reference to any of the WCS will have the offsets in effect, until
           # a Manual Reference Point Return (G28?) cancels G92 and all WCSs return to normal (??).


            set mom_sim_nc_register(RESET_WCS) 1

           # Defer offsets calculation until entire block is parsed.
            set mom_sim_nc_register(MAIN_OFFSET)  [list 0.0 0.0 0.0 0.0 0.0]

global mom_sim_message
set mom_sim_message "-- RESET WCS"
PB_CMD_vnc__send_message


         } elseif [string match "$mom_sim_nc_func(LOCAL_CS_SET)" $code] {

           # Specify a local coordiante system within the active WCS.
           # Offsets will ONLY be applied to the WCS in effect.
           # Change of WCS or return cancels the offsets.
           # G52 IP0(i.e. 0 0 0) or G92 command also cancels this mode.


            set mom_sim_nc_register(SET_LOCAL) 1

           # Defer offsets calculation until entire block is parsed.
            set mom_sim_nc_register(LOCAL_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]


         } elseif [string match "$mom_sim_nc_func(MACH_CS_MOVE)" $code] {

           # Moves to a position in the Machine Coordinate System (MCS).
           # The origin of MCS (Machine Zero, Machine Datum) never changes.
           # One shot instruction block. Ignored in incremental mode (G91).
           # MCS is never affected by G92 or G52 (LCS) until machine is powered off.
           # (I think, guess), G53 is used in the M06 macro for the tool change.
           #
           # ** It's ignored in (G91) incremental mode!
           # ** It's a one-shot instruction!

            if [string match "ABS" $mom_sim_nc_register(INPUT)] {

               set mom_sim_nc_register(MCS_MOVE) 1

              # Fake offsets. Restore it after the move.
               global mom_sim_prev_main_offsets mom_sim_prev_local_offsets

               set mom_sim_prev_main_offsets  $mom_sim_nc_register(MAIN_OFFSET)
               set mom_sim_prev_local_offsets $mom_sim_nc_register(LOCAL_OFFSET)

               set mom_sim_nc_register(MAIN_OFFSET)  [list 0.0 0.0 0.0 0.0 0.0]
               set mom_sim_nc_register(LOCAL_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]
               set mom_sim_nc_register(WORK_OFFSET)  [list 0.0 0.0 0.0 0.0 0.0]

 
              # Set ref. csys to Machine Zero CSYS on main ZCS component
               global mom_sim_machine_zero_csys_matrix
               global mom_sim_prev_csys_matrix
               global mom_sim_csys_matrix
               global mom_sim_prev_zcs_base mom_sim_zcs_base mom_sim_zcs_base_MCS

               array set mom_sim_prev_csys_matrix [array get mom_sim_csys_matrix]
               array set mom_sim_csys_matrix      [array get mom_sim_machine_zero_csys_matrix]

               set mom_sim_prev_zcs_base $mom_sim_zcs_base
               if [info exists mom_sim_zcs_base_MCS] {
                  set mom_sim_zcs_base $mom_sim_zcs_base_MCS
               }
               PB_SIM_call PB_CMD_vnc__set_kinematics
            }


         } elseif [string match "$mom_sim_nc_func(WORK_CS_1)" $code] {

           # Select Work Coordinate System.
           # G54 is selected when powered on (?).

            set mom_sim_nc_register(WCS) 1
            set mom_sim_nc_register(WORK_OFFSET) [PB_SIM_call VNC_map_to_machine_offsets $mom_sim_wcs_offsets(1)]

         } elseif [string match "$mom_sim_nc_func(WORK_CS_2)" $code] {

            set mom_sim_nc_register(WCS) 2
            set mom_sim_nc_register(WORK_OFFSET) [PB_SIM_call VNC_map_to_machine_offsets $mom_sim_wcs_offsets(2)]

         } elseif [string match "$mom_sim_nc_func(WORK_CS_3)" $code] {

            set mom_sim_nc_register(WCS) 3
            set mom_sim_nc_register(WORK_OFFSET) [PB_SIM_call VNC_map_to_machine_offsets $mom_sim_wcs_offsets(3)]

         } elseif [string match "$mom_sim_nc_func(WORK_CS_4)" $code] {

            set mom_sim_nc_register(WCS) 4
            set mom_sim_nc_register(WORK_OFFSET) [PB_SIM_call VNC_map_to_machine_offsets $mom_sim_wcs_offsets(4)]

         } elseif [string match "$mom_sim_nc_func(WORK_CS_5)" $code] {

            set mom_sim_nc_register(WCS) 5
            set mom_sim_nc_register(WORK_OFFSET) [PB_SIM_call VNC_map_to_machine_offsets $mom_sim_wcs_offsets(5)]

         } elseif [string match "$mom_sim_nc_func(WORK_CS_6)" $code] {

            set mom_sim_nc_register(WCS) 6
            set mom_sim_nc_register(WORK_OFFSET) [PB_SIM_call VNC_map_to_machine_offsets $mom_sim_wcs_offsets(6)]
         }


        # Perform CSYS transformation per choice of WCS.
         global mom_sim_csys_data

         if [info exists mom_sim_csys_data] {

            if [string match "$mom_sim_nc_func(MACH_CS_MOVE)" $code] {


            } elseif { [string match "$mom_sim_nc_func(WORK_CS_1)" $code] ||\
                       [string match "$mom_sim_nc_func(WORK_CS_2)" $code] ||\
                       [string match "$mom_sim_nc_func(WORK_CS_3)" $code] ||\
                       [string match "$mom_sim_nc_func(WORK_CS_4)" $code] ||\
                       [string match "$mom_sim_nc_func(WORK_CS_5)" $code] ||\
                       [string match "$mom_sim_nc_func(WORK_CS_6)" $code] } {


              # Zero local offsets when change WCS
               set mom_sim_nc_register(LOCAL_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]

              # Zero WCS offsets, since the actual CSYS will be referenced.
               set mom_sim_nc_register(WORK_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]


              # Apply local CSYS transformation and reassign ZCS base to allow rotation
               global mom_sim_zcs_base mom_sim_zcs_base_LCS

              # Validate existence of LCS
               if { [info exists mom_sim_zcs_base_LCS] && [string length $mom_sim_zcs_base_LCS] > 0 } {
                  set mom_sim_zcs_base $mom_sim_zcs_base_LCS
               }

              # Fetch actual WCS matrix per WCS selection by G54 - G59 code.
               global mom_sim_csys_matrix

               for { set i 0 } { $i < 12 } { incr i } {
                  set mom_sim_csys_matrix($i) $mom_sim_csys_data($mom_sim_nc_register(WCS),$i)
               }

               PB_SIM_call PB_CMD_vnc__set_kinematics


              # Flag to reset (adjust) the start position in next motion. (See PB_CMD_vnc__sim_motion)
               set mom_sim_nc_register(FIXTURE_OFFSET) 1
            }
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__G_motion_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list [list]
    lappend var_list mom_sim_nc_func(MOTION_RAPID)
    lappend var_list mom_sim_nc_func(MOTION_LINEAR)
    lappend var_list mom_sim_nc_func(MOTION_CIRCULAR_CLW)
    lappend var_list mom_sim_nc_func(MOTION_CIRCULAR_CCLW)
    lappend var_list mom_sim_nc_func(CYCLE_DRILL)
    lappend var_list mom_sim_nc_func(CYCLE_DRILL_DWELL)
    lappend var_list mom_sim_nc_func(CYCLE_DRILL_DEEP)
    lappend var_list mom_sim_nc_func(CYCLE_DRILL_BREAK_CHIP)
    lappend var_list mom_sim_nc_func(CYCLE_TAP)
    lappend var_list mom_sim_nc_func(CYCLE_BORE)
    lappend var_list mom_sim_nc_func(CYCLE_BORE_DRAG)
    lappend var_list mom_sim_nc_func(CYCLE_BORE_NO_DRAG)
    lappend var_list mom_sim_nc_func(CYCLE_BORE_BACK)
    lappend var_list mom_sim_nc_func(CYCLE_BORE_MANUAL)
    lappend var_list mom_sim_nc_func(CYCLE_BORE_MANUAL_DWELL)
    lappend var_list mom_sim_nc_func(CYCLE_START)
    lappend var_list mom_sim_nc_func(CYCLE_OFF)

   foreach var $var_list {
     if [info exists $var] {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

         if [string match "$mom_sim_nc_func(MOTION_RAPID)"               $code] {

            set mom_sim_nc_register(MOTION) "RAPID"

         } elseif [string match "$mom_sim_nc_func(MOTION_LINEAR)"        $code] {

            set mom_sim_nc_register(MOTION) "LINEAR"

         } elseif [string match "$mom_sim_nc_func(MOTION_CIRCULAR_CLW)"  $code] {

            set mom_sim_nc_register(MOTION) "CIRCULAR_CLW"

         } elseif [string match "$mom_sim_nc_func(MOTION_CIRCULAR_CCLW)" $code] {

            set mom_sim_nc_register(MOTION) "CIRCULAR_CCLW"

         } elseif [string match "$mom_sim_nc_func(CYCLE_DRILL)"          $code] {

            set mom_sim_nc_register(MOTION) "CYCLE_DRILL"

         } elseif [string match "$mom_sim_nc_func(CYCLE_DRILL_DWELL)"    $code] {

            set mom_sim_nc_register(MOTION) "CYCLE_DRILL_DWELL"

         } elseif [string match "$mom_sim_nc_func(CYCLE_DRILL_DEEP)"     $code] {

            set mom_sim_nc_register(MOTION) "CYCLE_DRILL_DEEP"

         } elseif [string match "$mom_sim_nc_func(CYCLE_DRILL_BREAK_CHIP)"  $code] {

            set mom_sim_nc_register(MOTION) "CYCLE_DRILL_BREAK_CHIP"

         } elseif [string match "$mom_sim_nc_func(CYCLE_TAP)"               $code] {

            set mom_sim_nc_register(MOTION) "CYCLE_TAP"

         } elseif [string match "$mom_sim_nc_func(CYCLE_BORE)"              $code] {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE"

         } elseif [string match "$mom_sim_nc_func(CYCLE_BORE_DRAG)"         $code] {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_DRAG"

         } elseif [string match "$mom_sim_nc_func(CYCLE_BORE_NO_DRAG)"      $code] {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_NO_DRAG"

         } elseif [string match "$mom_sim_nc_func(CYCLE_BORE_BACK)"         $code] {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_BACK"

         } elseif [string match "$mom_sim_nc_func(CYCLE_BORE_MANUAL)"       $code] {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_MANUAL"

         } elseif [string match "$mom_sim_nc_func(CYCLE_BORE_MANUAL_DWELL)" $code] {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_MANUAL_DWELL"

         } elseif [string match "$mom_sim_nc_func(CYCLE_START)"             $code] {

            set mom_sim_nc_register(MOTION) "CYCLE_START"

         } elseif [string match "$mom_sim_nc_func(CYCLE_OFF)"               $code] {

            set mom_sim_nc_register(MOTION) "CYCLE_OFF"

           # Cycle Off - force tool to move to the initial pt (entry pos) of next set of holes.
            global mom_sim_pos mom_sim_cycle_retract_to_pos
            if [info exists mom_sim_cycle_retract_to_pos] {
               set mom_sim_pos(0) $mom_sim_cycle_retract_to_pos(0)
               set mom_sim_pos(1) $mom_sim_cycle_retract_to_pos(1)
               set mom_sim_pos(2) $mom_sim_cycle_retract_to_pos(2)
            }
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__calculate_duration_time { } {
#=============================================================
  global mom_sim_motion_linear_or_angular
  global mom_sim_travel_delta mom_sim_duration_time
  global mom_sim_feedrate_mode
  global mom_sim_nc_register
  global mom_sim_rapid_feed_rate
  global mom_sim_max_dpm


   if [llength [info commands "PB_CMD_vnc__user_calculate_duration_time"]] {
      PB_SIM_call PB_CMD_vnc__user_calculate_duration_time
return
   }


  # Prescreen condition
   if ![EQ_is_gt [expr abs($mom_sim_travel_delta)] 0.0] {
      set mom_sim_duration_time 0.0
return
   }


   set linear_or_angular $mom_sim_motion_linear_or_angular
   set delta [expr abs($mom_sim_travel_delta)]

  # Determine feed rate & mode
   if { [string match "RAPID" $mom_sim_nc_register(MOTION)] || [expr $mom_sim_nc_register(F) <= 0] } {

      set feed $mom_sim_rapid_feed_rate

      if { $mom_sim_nc_register(UNIT) == "MM" } {
         set mode MM_PER_MIN
      } else {
         set mode INCH_PER_MIN
      }
   } else {
      set feed $mom_sim_nc_register(F)
      set mode $mom_sim_nc_register(FEED_MODE)
   }


   set feed [expr abs($feed)]


  # Initialize time
   set mom_sim_duration_time 0.000001

   if { $linear_or_angular == "ANGULAR" } {

     # Find correct feed rate mode for a pure ratary move
      global mom_sim_feed_param
      global mom_sim_rapid_feed_mode
      global mom_sim_contour_feed_mode

      if { $mom_sim_nc_register(MOTION) == "RAPID" } {
         if { [info exists mom_sim_max_dpm] && [EQ_is_gt $mom_sim_max_dpm 0.0] } {
            set mom_sim_duration_time [expr ($delta / $mom_sim_max_dpm) * 60.0]
         }
      } else {
         if { [info exists mom_sim_contour_feed_mode] && $mom_sim_contour_feed_mode(ROTARY) == "DPM" } {
            global mom_sim_feedrate_dpm
            if { [info exists mom_sim_feedrate_dpm] && [EQ_is_gt $mom_sim_feedrate_dpm 0.0] } {
               set mom_sim_duration_time [expr ($delta / $mom_sim_feedrate_dpm) * 60.0]
            }
         }
      }

   } else {

      if ![EQ_is_zero $feed] {

         switch $mode {
            INCH_PER_MIN -
            MM_PER_MIN   {

               set mom_sim_duration_time [expr ($delta / $feed) * 60.0]
            }

            INCH_PER_REV -
            MM_PER_REV   {

               global mom_sim_spindle_mode mom_sim_spindle_speed
               global mom_sim_PI mom_sim_prev_pos mom_sim_pos

               switch $mom_sim_spindle_mode {
                  "REV_PER_MIN" {
                     set feed [expr $feed * $mom_sim_spindle_speed]
                  }
                  "FEET_PER_MIN" {
                     set feed [expr $feed * $mom_sim_spindle_speed * 12 /\
                                    (2 * $mom_sim_PI * ($mom_sim_prev_pos(0) + $mom_sim_pos(0))/2)]
                  }
                  "M_PER_MIN" {
                     set feed [expr $feed * $mom_sim_spindle_speed * 1000 /\
                                    (2 * $mom_sim_PI * ($mom_sim_prev_pos(0) + $mom_sim_pos(0))/2)]
                  }
               }

               if ![EQ_is_zero $feed] {
                  set mom_sim_duration_time [expr ($delta / $feed) * 60.0]
               }
            }

            MM_PER_100REV {
              # FRN mode
               set mom_sim_duration_time [expr 60/$feed]
            }
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__cycle_set { } {
#=============================================================
  global mom_sim_o_buffer
  global mom_sim_address mom_sim_pos mom_sim_prev_pos
  global mom_sim_nc_register
  global mom_sim_cycle_mode
  global mom_sim_cycle_rapid_to_pos
  global mom_sim_cycle_feed_to_pos
  global mom_sim_cycle_retract_to_pos
  global mom_sim_cycle_entry_pos
  global mom_sim_cycle_rapid_to_dist
  global mom_sim_cycle_feed_to_dist
  global mom_sim_cycle_retract_to_dist
  global mom_sim_cycle_spindle_axis

  global mom_sim_machine_type
  global mom_sim_4th_axis_plane mom_sim_5th_axis_plane


  # Interrogate tool axis to determine whether principal axis should be reversed.
  # This direction is needed when any of the cycle's parmeters is incremental.

   set axis_direction 1

   if [string match "*head*" $mom_sim_machine_type] {
      switch $mom_sim_4th_axis_plane {
         "ZX" {
            if [EQ_is_equal $mom_sim_nc_register(fourth_axis) -90.0] {
               set axis_direction -1
            }
         }
         "YZ" {
            if [EQ_is_equal $mom_sim_nc_register(fourth_axis) 90.0] {
               set axis_direction -1
            }
         }
      }
   }

   if [string match "5_axis_dual_head" $mom_sim_machine_type] {
      switch $mom_sim_5th_axis_plane {
         "ZX" {
            if [EQ_is_equal $mom_sim_nc_register(fifth_axis) -90.0] {
               set axis_direction -1
            }
         }
         "YZ" {
            if [EQ_is_equal $mom_sim_nc_register(fifth_axis) 90.0] {
               set axis_direction -1
            }
         }
      }
   }


   set mom_sim_pos(0) $mom_sim_prev_pos(0)
   set mom_sim_pos(1) $mom_sim_prev_pos(1)
   set mom_sim_pos(2) $mom_sim_prev_pos(2)

   set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_pos($mom_sim_cycle_spindle_axis)

   set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) $mom_sim_pos($mom_sim_cycle_spindle_axis)


  # nc_register(K_cycle) may never be set, since it's in conflict with nc_register(K).
   if [info exists mom_sim_nc_register(K)] {
      set mom_sim_nc_register(K_cycle) $mom_sim_nc_register(K)
   }

   if { ![info exists mom_sim_nc_register(K_cycle)] } {
      set mom_sim_nc_register(K_cycle) 0
   }

   if { ![info exists mom_sim_nc_register(R)] } {
      set mom_sim_nc_register(R) 0
   }


   set mom_sim_cycle_feed_to_pos(0) $mom_sim_nc_register(X)
   set mom_sim_cycle_feed_to_pos(1) $mom_sim_nc_register(Y)
   set mom_sim_cycle_feed_to_pos(2) $mom_sim_nc_register(Z)

   switch $mom_sim_cycle_mode(feed_to) {
      "Distance" {
         set mom_sim_cycle_feed_to_dist [expr abs($mom_sim_nc_register(Z)) * $axis_direction]

         if { $mom_sim_cycle_spindle_axis == 2 } { ;# Z axis
            set mom_sim_cycle_feed_to_pos(2) [expr $mom_sim_pos(2) - $mom_sim_cycle_feed_to_dist]
         } else {
            set mom_sim_cycle_feed_to_pos(2) $mom_sim_pos(2)
         }

         set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) [expr $mom_sim_cycle_feed_to_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_feed_to_dist]
      }
   }


   set mom_sim_cycle_rapid_to_pos(0) $mom_sim_cycle_feed_to_pos(0)
   set mom_sim_cycle_rapid_to_pos(1) $mom_sim_cycle_feed_to_pos(1)
   set mom_sim_cycle_rapid_to_pos(2) $mom_sim_cycle_feed_to_pos(2)

   if [string match "*R -*" $mom_sim_cycle_mode(rapid_to)] {
      if [string match "*Distance*" $mom_sim_cycle_mode(rapid_to)] {
#>>>
        # The 1st hole may have been @ rapid-to pos already.
         set mom_sim_cycle_rapid_to_dist [expr abs($mom_sim_nc_register(R)) * $axis_direction]

         if [EQ_is_equal $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) $mom_sim_pos($mom_sim_cycle_spindle_axis)] {
            set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) - $mom_sim_cycle_rapid_to_dist]
         }

        # Entry pos is @ top of the hole
         set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis)

      } else {
         set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(R)
      }
   }


   set mom_sim_cycle_retract_to_pos(0) $mom_sim_cycle_rapid_to_pos(0)
   set mom_sim_cycle_retract_to_pos(1) $mom_sim_cycle_rapid_to_pos(1)
   set mom_sim_cycle_retract_to_pos(2) $mom_sim_cycle_rapid_to_pos(2)

   if [string match "K*" $mom_sim_cycle_mode(retract_to)] {
      if [string match "*Distance*" $mom_sim_cycle_mode(retract_to)] {
#>>>
        # The 1st hole may have been @ rapid-to pos already.
         set mom_sim_cycle_retract_to_dist [expr abs($mom_sim_nc_register(K_cycle)) * $axis_direction]

         if [EQ_is_equal $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) $mom_sim_pos($mom_sim_cycle_spindle_axis)] {
            set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) - $mom_sim_cycle_retract_to_dist]
         }

         set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_retract_to_dist]
      } else {
         set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(K_cycle)
      }

   } elseif [string match "G98/G99*" $mom_sim_cycle_mode(retract_to)] {

      global mom_sim_nc_func

      if { [VNC_parse_nc_block mom_sim_o_buffer $mom_sim_nc_func(CYCLE_RETURN_MANUAL)] == 1 } {
         switch $mom_sim_cycle_spindle_axis {
            0 {
               set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(LAST_X)
            }
            1 {
               set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(LAST_Y)
            }
            default {
               set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(LAST_Z)
            }
         }
      }
   }


   if { !$mom_sim_cycle_mode(start_block) } {
      PB_SIM_call PB_CMD_vnc__cycle_move
   }
}


#=============================================================
proc PB_CMD_vnc__define_misc_procs { } {
#=============================================================
 uplevel #0 {

  #-----------------------------------------------------------
  proc VNC_extract_address_val { O_BUFF addr args } {
  #-----------------------------------------------------------
   upvar $O_BUFF o_buff

   global mom_sim_nc_code
   global mom_sim_address mom_sim_format


   if [info exists mom_sim_address($addr,leader)] {
      set token $mom_sim_address($addr,leader)
   } else {
      set token $addr
   }

   set code ""

   if { [string length [string trim $token]] > 0 } {

      if { [VNC_parse_nc_block o_buff $token] == 2 } {

         set code $mom_sim_nc_code

         set fmt ""
         if [info exists mom_sim_address($addr,format)] {
            set fmt $mom_sim_address($addr,format)
         }

         if { [string length $fmt] > 0 } {
            if ![catch { set val [PB_SIM_call VNC_format_val $fmt $code] } ] {
               set code $val
            }
         }
      }
   }

  return $code
  }

  #-----------------------------------------------------------
  proc VNC_map_from_machine_offsets { offsets } {
  #-----------------------------------------------------------
  # This function converts a 5-element offsets to a 6-element offsets.
  #

   if { [llength $offsets] == 6 } {
      return $offsets
   }

   global mom_sim_machine_type
   global mom_sim_4th_axis_plane
   global mom_sim_5th_axis_plane

   set xyzabc [list [lindex $offsets 0] [lindex $offsets 1] [lindex $offsets 2] 0.0 0.0 0.0]

   set 4th_index 0
   set 5th_index 0
   set ang4 [lindex $offsets 3]
   set ang5 [lindex $offsets 4]

   if { [string match "4*" $mom_sim_machine_type] } {
      switch $mom_sim_4th_axis_plane {
         "YZ" {
            set 4th_index 3
         }
         "ZX" {
            set 4th_index 4
         }
         "XY" {
            set 4th_index 5
         }
      }
      if { $4th_index > 0 } {
         set xyzabc [lreplace $xyzabc $4th_index $4th_index $ang4]
      }
   }

   if { [string match "5*" $mom_sim_machine_type] } {
      switch $mom_sim_4th_axis_plane {
         "XY" {
            set 4th_index 5
            switch $mom_sim_5th_axis_plane {
               "YZ" {
                  set 5th_index 3
               }
               "ZX" {
                  set 5th_index 4
               }
            }
         }
         "YZ" {
            set 4th_index 3
            switch $mom_sim_5th_axis_plane {
               "XY" {
                  set 5th_index 5
               }
               "ZX" {
                  set 5th_index 4
               }
            }
         }
         "ZX" {
            set 4th_index 4
            switch $mom_sim_5th_axis_plane {
               "XY" {
                  set 5th_index 5
               }
               "YZ" {
                  set 5th_index 3
               }
            }
         }
      }
      if { $4th_index > 0 } {
         set xyzabc [lreplace $xyzabc $4th_index $4th_index $ang4]
      }
      if { $5th_index > 0 } {
         set xyzabc [lreplace $xyzabc $5th_index $5th_index $ang5]
      }
   }

  return $xyzabc
  }

  #-----------------------------------------------------------
  proc VNC_map_to_machine_offsets { offsets } {
  #-----------------------------------------------------------
  # This function converts a 6-element offsets to a 5-element
  # offsets for an orthogonal machine.
  #

   if { [llength $offsets] == 5 } {
      return $offsets
   }

   global mom_sim_machine_type
   global mom_sim_4th_axis_plane
   global mom_sim_5th_axis_plane

   set xyzab [list [lindex $offsets 0] [lindex $offsets 1] [lindex $offsets 2] 0.0 0.0]

   set 4th_index 0
   set 5th_index 0

   if { [string match "4*" $mom_sim_machine_type] } {
      switch $mom_sim_4th_axis_plane {
         "YZ" {
            set 4th_index 3
         }
         "ZX" {
            set 4th_index 4
         }
         "XY" {
            set 4th_index 5
         }
      }
      if { $4th_index > 0 } {
         set ang4 [lindex $offsets $4th_index]
      }
      set xyzab [lreplace $xyzab 3 3 $ang4]
   }

   if { [string match "5*" $mom_sim_machine_type] } {
      switch $mom_sim_4th_axis_plane {
         "XY" {
            set 4th_index 5
            switch $mom_sim_5th_axis_plane {
               "YZ" {
                  set 5th_index 3
               }
               "ZX" {
                  set 5th_index 4
               }
            }
         }
         "YZ" {
            set 4th_index 3
            switch $mom_sim_5th_axis_plane {
               "XY" {
                  set 5th_index 5
               }
               "ZX" {
                  set 5th_index 4
               }
            }
         }
         "ZX" {
            set 4th_index 4
            switch $mom_sim_5th_axis_plane {
               "XY" {
                  set 5th_index 5
               }
               "YZ" {
                  set 5th_index 3
               }
            }
         }
      }
      if { $4th_index > 0 } {
         set ang4 [lindex $offsets $4th_index]
      }
      if { $5th_index > 0 } {
         set ang5 [lindex $offsets $5th_index]
      }
      set xyzab [lreplace $xyzab 3 4 $ang4 $ang5]
   }

  return $xyzab
  }

 } ;# uplevel
}


#=============================================================
proc PB_CMD_vnc__define_wcs { } {
#=============================================================
  global mom_sim_result mom_sim_result1
  global mom_sim_csys_matrix
  global mom_sim_machine_zero_offsets
  global mom_sim_csys_data
  global mom_sim_wcs_offsets
  global mom_sim_csys_set
  global mom_sim_nc_register
  global mom_sim_machine_zero_csys_matrix
  global mom_sim_main_csys_matrix
  global mom_sim_local_csys_matrix


  # Define Machine Zero coordinate system offset from MTCS Junction
  #
   PB_SIM_call SIM_ask_mtcs_junction
   PB_SIM_call SIM_ask_init_junction_xform $mom_sim_result

   set i 0
   foreach v $mom_sim_result {
      set mom_sim_csys_matrix($i) $v
      incr i
   }
   foreach v $mom_sim_result1 {
      set mom_sim_csys_matrix($i) $v
      incr i
   }

    set x [lindex $mom_sim_machine_zero_offsets 0]
    set y [lindex $mom_sim_machine_zero_offsets 1]
    set z [lindex $mom_sim_machine_zero_offsets 2]

   MTX3_xform_csys 0.0 0.0 0.0 $x $y $z mom_sim_csys_matrix

   array set mom_sim_machine_zero_csys_matrix  [array get mom_sim_csys_matrix]


  # Initialize the main CSYS (0th WCS) matrix w.r.t. mom_sim_machine_zero_csys_matrix.
  # - This CSYS will get overwritten by a Main CSYS object during an in-process ISV.
  # - For standalone NC file ISV, this is where all work CSYS are defined.
  #
   array set csys_matrix [array get mom_sim_machine_zero_csys_matrix]

    set x [lindex $mom_sim_wcs_offsets(0) 0]
    set y [lindex $mom_sim_wcs_offsets(0) 1]
    set z [lindex $mom_sim_wcs_offsets(0) 2]
    set a [lindex $mom_sim_wcs_offsets(0) 3]
    set b [lindex $mom_sim_wcs_offsets(0) 4]
    set c [lindex $mom_sim_wcs_offsets(0) 5]

   MTX3_xform_csys $a $b $c $x $y $z csys_matrix
   for { set i 0 } { $i < 12 } { incr i } {
      set mom_sim_csys_data(0,$i) $csys_matrix($i)
   }


  # Zero work offsets
   set mom_sim_nc_register(WORK_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]


  # Initialize reference to 0th WCS
   array set mom_sim_csys_matrix  [array get csys_matrix]
   PB_SIM_call PB_CMD_vnc__set_kinematics
   set mom_sim_csys_set 1

   array set mom_sim_main_csys_matrix   [array get mom_sim_csys_matrix]
   array set mom_sim_local_csys_matrix  [array get mom_sim_csys_matrix]


  # Initialize other WCS matrices w.r.t. the 0th WCS.
  # - These will get overwritten by local CSYS object during an in-process ISV.
  #
   array set main_csys_matrix [array get csys_matrix]

   set n_wcs [array size mom_sim_wcs_offsets]

   for { set i 1 } { $i < $n_wcs } { incr i } {
      array set csys_matrix [array get main_csys_matrix]

       set x [lindex $mom_sim_wcs_offsets($i) 0]
       set y [lindex $mom_sim_wcs_offsets($i) 1]
       set z [lindex $mom_sim_wcs_offsets($i) 2]
       set a [lindex $mom_sim_wcs_offsets($i) 3]
       set b [lindex $mom_sim_wcs_offsets($i) 4]
       set c [lindex $mom_sim_wcs_offsets($i) 5]

      MTX3_xform_csys $a $b $c $x $y $z csys_matrix

      for { set j 0 } { $j < 12 } { incr j } {
         set mom_sim_csys_data($i,$j) $csys_matrix($j)
      }
   }
}


#=============================================================
proc PB_CMD_vnc__execute_nc_command { } {
#=============================================================
  global mom_sim_nc_block_started

  # Process setup data file, when 1st block comes thru.
  #
   if ![info exists mom_sim_nc_block_started] {
      global mom_sim_nc_program_file_name

      set mom_sim_nc_block_started  0

      if { [info exists mom_sim_nc_program_file_name] && [file exists $mom_sim_nc_program_file_name] } {

         set setup_tcl_file [join [split [file rootname $mom_sim_nc_program_file_name] \\] /]_setup.tcl
         set setup_dat_file [file rootname $setup_tcl_file].dat

         if [file exists $setup_tcl_file] {

            source $setup_tcl_file

            set mom_sim_nc_block_started  1

         } elseif [file exists $setup_dat_file] {

            set setup_dat_file_id [open $setup_dat_file RDONLY]

            while { [eof $setup_dat_file_id] == 0 } {
               set line [gets $setup_dat_file_id]

               if { [string trim $line] != "" } {
                  PB_SIM_call VNC_sim_nc_block $line
               }
            }

            close $setup_dat_file_id

            set mom_sim_nc_block_started  1
         }
      }

     # The driver needs to be notified somehow that the NC file does not
     # provide its own setup data and will use driver's setup. 

      if !$mom_sim_nc_block_started {
         VNC_pause "Setup data not found for NC code file : $mom_sim_nc_program_file_name"
        # MOM_abort "*** Abort ISV due to missing Setup data file!"
      }
   }

  # Simulate block by block
  #
   global mom_sim_nc_command

   if { [string trim $mom_sim_nc_command] != "" } {
      PB_SIM_call VNC_sim_nc_block $mom_sim_nc_command
   }
}


#=============================================================
proc PB_CMD_vnc__init_isv_qc { } {
#=============================================================
#
# *** DO NOT rename or remove this command!
#

  global mom_sim_isv_qc mom_sim_isv_qc_file mom_sim_isv_qc_mode

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Parameters for ISV autoQC can be set by the following
# system's environment variables :
#
#       UGII_ISV_QC, UGII_ISV_QC_FILE & UGII_ISV_QC_MODE.
#
# Users can, however, override the settings by uncommenting 
# and revising any of the options below:
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   set mom_sim_isv_qc       1     ;# 1=ON, 0=OFF
   set mom_sim_isv_qc_file  ""    ;# "" or "listing_device"
   set mom_sim_isv_qc_mode  00000 ;# 10000 = SIM, 01000 = VNC, 00100 = PB_CMD, 00010 = Others, 00001 = mom_sim_pos


  # Disable qc output during extended NC output, unless it's in debug mode.
   global mom_sim_post_builder_debug
   if { ![info exists mom_sim_post_builder_debug] || !$mom_sim_post_builder_debug } {
      global mom_sim_output_extended_nc
      if { [info exists mom_sim_output_extended_nc] && $mom_sim_output_extended_nc == 1 } {
         set mom_sim_isv_qc  0
      }
   }


  # Preprocess QC mode
   set mom_sim_isv_qc_mode [string trimleft $mom_sim_isv_qc_mode 0]
   if { $mom_sim_isv_qc_mode == "" } {
      set mom_sim_isv_qc 0
   }


  # Open message file
   if { [info exists mom_sim_isv_qc] && $mom_sim_isv_qc > 0 } {

      global mom_sim_vnc_handler_loaded

      if { ![info exists mom_sim_isv_qc_file] || ![string match "listing_device" $mom_sim_isv_qc_file] } {
         set  mom_sim_isv_qc_file ""
      }

      if [string match "" [string trim $mom_sim_isv_qc_file]] {

        # Default message file name is derived from the VNC.
        # User can define her own file name for the purpose.

         global mom_part_name
         set part_name "[join [split [file rootname [file tail $mom_part_name]] \\] /]"
         set file_name "[file rootname $mom_sim_vnc_handler_loaded]_${part_name}_qc.out"

         if [catch {set mom_sim_isv_qc_file [open "$file_name" w]} ] {
            catch { VNC_send_message "> Failed to open QC output file $file_name. Output to listing device." }
            set mom_sim_isv_qc_file "listing_device"
         } else {
            catch { VNC_send_message "> QC output file : $file_name" }
         }
      } else {
         catch { VNC_send_message "> QC output file : listing device" }
      }
   }


uplevel #0 {

#*************************************************************************
# General wrapper for all SIM, VNC & PB_CMD calls.
#
# - It can not wrap commands that pass references (pointers) as arguments,
#   ex. VNC_parse_nc_block & all math functions (EQ, VEC & MTX3).
#
#
proc PB_SIM_call { command args } {
#*************************************************************************
  global mom_sim_isv_qc
  global mom_sim_isv_qc_mode


  # Preprocess arguments list & construct command string to evaluate
   if [llength $args] {
      set args_list ""
      for { set i 0 } { $i < [llength $args] } { incr i } {
         set arg [lindex $args $i]

        # Convert any multi-elements argument to a list.
         if { [llength $arg] > 1 } {
            set arg [list $arg]
         }

         lappend args_list $arg
      }
      set cmd_string "$command [join $args_list]"
   } else {
      set cmd_string "$command"
   }


  # Initialize the QC flag, if not defined.
   if ![info exists mom_sim_isv_qc] {
      set mom_sim_isv_qc 0
   }


  # Output regular QC messages per mode specified
   if { $mom_sim_isv_qc == 1 } {

     # Add a blank line before VNC_sim_nc_block
      if [string match "VNC_sim_nc_block" $command] {
         PB_SIM_output_qc_cmd_string ""
      }

      set output_bit $mom_sim_isv_qc_mode

      set base 10000

      if { $output_bit >= $base } {
         if [string match "SIM_*" $command] {
            if { [string match "SIM_ask_*" $command] ||\
                 [string match "SIM_find_*" $command] ||\
                 [string match "SIM_convert_*" $command] } {

               PB_SIM_output_qc_cmd_string "# $cmd_string"

            } else {

               PB_SIM_output_qc_cmd_string $cmd_string
            }
         }
         set output_bit [expr $output_bit - $base]
      }
      set base [expr $base / 10]
      if { $output_bit >= $base } {
         if [string match "VNC_*" $command] {
            PB_SIM_output_qc_cmd_string $cmd_string
         }
         set output_bit [expr $output_bit - $base]
      }
      set base [expr $base / 10]
      if { $output_bit >= $base } {
         if [string match "PB_CMD_*" $command] {
            PB_SIM_output_qc_cmd_string $cmd_string
         }
         set output_bit [expr $output_bit - $base]
      }
      set base [expr $base / 10]
      if { $output_bit >= $base } {
         if { ![string match "SIM_*" $command] && ![string match "VNC_*" $command] && ![string match "PB_CMD_*" $command] } {
            PB_SIM_output_qc_cmd_string $cmd_string
         }
      }
   }

   global mom_sim_message
   set val ""

  # Verify existence of the command
   if ![llength [info commands "$command"]] {
      set msg "# *** ERROR *** \"$command\" does not exist!"
      if { $mom_sim_isv_qc == 1 } {
         PB_SIM_output_qc_cmd_string "$msg"
      } else {
         set mom_sim_message "$msg"
         PB_CMD_vnc__send_message
      }

     # Define a dummy proc to eliminate the same error messages from subsequent calls.
      proc $command { args } { return }
   }

  # Evaluate command string. Abort, if error.
   if [catch { set val [eval $cmd_string] } sta] {
      set msg "# *** ABORT *** $cmd_string"
      if { $mom_sim_isv_qc == 1 }  {
         PB_SIM_output_qc_cmd_string "$msg"
      } else {
         set mom_sim_message "$msg"
         PB_CMD_vnc__send_message
      }

      MOM_abort "$cmd_string : $sta"
   }

  # Execution OK, pass on returned value to caller
return $val
}


#*************************************************************
# QC messages handler to be called by PB_SIM_call wrapper.
#
proc PB_SIM_output_qc_cmd_string { args } {
#*************************************************************
  global mom_sim_isv_qc mom_sim_isv_qc_file

  # This command should not be called if the QC mode is never initialized.
   if { ![info exists mom_sim_isv_qc] || $mom_sim_isv_qc <= 0 } {
return
   }

  # The QC file handler should have been defined by the driver already,
  # by the time this command is called.
   if { ![info exists mom_sim_isv_qc_file] || [string match "" $mom_sim_isv_qc_file] } {
      MOM_output_to_listing_device "[join $args]"
return
   }

  # Construct the message
   if 1 {
      set msg "[join $args]"
   } else {
     # Add calls stack to the message
      set stack [VNC_trace]
      set idx [lsearch -glob $stack "PB_SIM_*"]
      while { $idx >= 0 } {
         set stack [lreplace $stack $idx $idx]
         set idx [lsearch -glob $stack "PB_SIM_*"]
      }
      set msg "[join $stack \n]\n\n   [join $args]\n\n"
   }


  # Add mom_sim_pos to the msg per mode
   global mom_sim_isv_qc_mode
   if { [expr fmod($mom_sim_isv_qc_mode,10) == 1] } {
      global mom_sim_pos
      set msg "$msg   ;# -> [join [split [VNC_sort_array_vals mom_sim_pos]]]"
   }


  # Direct output to either the listing device or a file.
   if [string match "listing_device" $mom_sim_isv_qc_file] {
      MOM_output_to_listing_device "$msg"
   } else {
      puts $mom_sim_isv_qc_file "$msg"

     # >>> Flushing buffer slows down the performance
     # flush $mom_sim_isv_qc_file
   }
}

} ;# uplevel


  # Write out time calc callbacks
   if { [info exists mom_sim_isv_qc] && $mom_sim_isv_qc > 0 } {
      set cb_string {\
        "#============================================================="\
        "proc VNC_CalculateDurationTime { linear_or_angular delta } {"\
        "#============================================================="\
        "   global mom_sim_motion_linear_or_angular mom_sim_travel_delta"\
        "   global mom_sim_duration_time"\
        " "\
        "   set mom_sim_motion_linear_or_angular \$linear_or_angular"\
        "   set mom_sim_travel_delta \$delta"\
        " "\
        "   PB_CMD_vnc__calculate_duration_time"\
        " "\
        "return \$mom_sim_duration_time"\
        "}"\
        " "\
      }

      set proc_list { PB_CMD_vnc__calculate_duration_time MOM_SIM_initialize_mtd MOM_SIM_exit_mtd }

      foreach proc_name $proc_list {

         if { [llength [info procs $proc_name]] > 0 } {

            lappend cb_string "#============================================================="
            lappend cb_string "proc $proc_name { } \{"

            if [string match "MOM_SIM_exit_mtd" $proc_name] {
               lappend cb_string "#============================================================="
            }

           # Remove 1st & last blank lines from proc body
            set pbody [split [info body $proc_name] \n]
            set pbody [lreplace $pbody 0 0]
            set pbody [lreplace $pbody end end]

           # Append body to output list
            foreach line $pbody {
               lappend cb_string $line
            }

           # Add closing brace
            lappend cb_string  "\}"
            lappend cb_string  " "
         }
      }

      PB_SIM_output_qc_cmd_string "[join $cb_string \n]"
   }
}


#=============================================================
proc PB_CMD_vnc__init_sim_vars { } {
#=============================================================
  global mom_sim_word_separator mom_sim_word_separator_len
  global mom_sim_end_of_block mom_sim_end_of_block_len
  global mom_sim_pos
  global mom_sim_tool_loaded
  global mom_sim_tool_junction
  global mom_sim_curr_jct_matrix mom_sim_curr_jct_origin
  global mom_sim_nc_register
  global mom_sim_wcs_offsets
  global mom_sim_ug_tool_name


  # Transfer static data from the Post.
  #
   PB_SIM_call VNC_load_post_definitions


  # When a VNC is used to output VNC messages only w/o simulation.
  #
   global mom_sim_vnc_msg_only
   if { [info exists mom_sim_vnc_msg_only] && $mom_sim_vnc_msg_only } {
return
   }


  # Display this VNC name in ISV.
  #
   PB_SIM_call PB_CMD_vnc__display_version


  # Define some misc commands.
   PB_SIM_call PB_CMD_vnc__define_misc_procs


  # Initialize controller's input unit to post's output unit
  #
   global mom_sim_output_unit
   if { ![info exists mom_sim_nc_register(UNIT)] } {
      set mom_sim_nc_register(UNIT) $mom_sim_output_unit
   }


  # Undefine machine tool kinematics assignment
  # to clear up residual variables.
  #
   global mom_sim_zcs_base mom_sim_zcs_base_MCS mom_sim_zcs_base_LCS
   global mom_sim_spindle_comp mom_sim_spindle_jct mom_sim_pivot_jct
   global mom_sim_advanced_kinematic_jct
   global mom_sim_mt_axis

   if [info exists mom_sim_zcs_base_MCS] {
      unset mom_sim_zcs_base_MCS
   }
   if [info exists mom_sim_zcs_base_LCS] {
      unset mom_sim_zcs_base_LCS
   }
   if [info exists mom_sim_zcs_base] {
      unset mom_sim_zcs_base
   }
   if [info exists mom_sim_spindle_comp] {
      unset mom_sim_spindle_comp
   }
   if [info exists mom_sim_spindle_jct] {
      unset mom_sim_spindle_jct
   }
   if [info exists mom_sim_pivot_jct] {
      unset mom_sim_pivot_jct
   }
   if [info exists mom_sim_advanced_kinematic_jct] {
      unset mom_sim_advanced_kinematic_jct
   }
   if [info exists mom_sim_mt_axis] {
      unset mom_sim_mt_axis
   }

  #-----------------------------------
  # Map machine tool axes assignments
  #-----------------------------------
  # Hard code axes assignmaents
   PB_SIM_call PB_CMD_vnc____map_machine_tool_axes

  # Fetch machine kinematics from model
   if [string match "TRUE" [PB_SIM_call MOM_validate_machine_model]] {
      PB_SIM_call PB_CMD_vnc__reload_machine_tool_axes
   }


  # Initialize a null list for other NC codes to be simulated.
  # Actual code list will be defined in PB_CMD_vnc____set_nc_definitions.
  #
   global mom_sim_other_nc_codes
   set mom_sim_other_nc_codes [list]


  # Add user's NC data definition.
  #
   if [llength [info commands "PB_CMD_vnc__set_nc_definitions"]] {
      PB_SIM_call PB_CMD_vnc__set_nc_definitions
   } else {
      PB_SIM_call PB_CMD_vnc____set_nc_definitions
   }


  # Add more user's NC data definition required for conversion.
  # (Legacy only)
   PB_SIM_call PB_CMD_vnc__fix_nc_definitions


  # Unset Y axis for a lathe, if necessary.
  #
   PB_SIM_call PB_CMD_vnc__unset_Y_axis


  # Validity check for machine tool parameters.
  #
   PB_SIM_call PB_CMD_vnc__validate_machine_tool


  # Nullify ref pos of MTCS
   global mom_sim_pos_mtcs
   if [info exists mom_sim_pos_mtcs(0)] {
      unset mom_sim_pos_mtcs(0)
   }
   if [info exists mom_sim_pos_mtcs(1)] {
      unset mom_sim_pos_mtcs(1)
   }
   if [info exists mom_sim_pos_mtcs(2)] {
      unset mom_sim_pos_mtcs(2)
   }


  # Logical axes assignments (not from the post?)
  # It works to equate logical names to the physical names.
  #
   global mom_sim_lg_axis mom_sim_nc_axes mom_sim_address
   global mom_sim_num_machine_axes

  # Linear axes are commanded by logical names, whereas
  # rotary axes are commanded by physical names.
  #
   set mom_sim_lg_axis(X) X
   set mom_sim_lg_axis(Y) Y
   set mom_sim_lg_axis(Z) Z
   set mom_sim_lg_axis(I) I
   set mom_sim_lg_axis(J) J
   set mom_sim_lg_axis(K) K

   set mom_sim_nc_axes [concat $mom_sim_lg_axis(X) $mom_sim_lg_axis(Y) $mom_sim_lg_axis(Z)]

   switch $mom_sim_num_machine_axes {
      4 {
         set mom_sim_lg_axis(4) $mom_sim_mt_axis(4)
         lappend mom_sim_nc_axes $mom_sim_lg_axis(4)
      }
      5 {
         set mom_sim_lg_axis(4) $mom_sim_mt_axis(4)
         set mom_sim_lg_axis(5) $mom_sim_mt_axis(5)
         lappend mom_sim_nc_axes $mom_sim_lg_axis(4) $mom_sim_lg_axis(5)
      }
   }


  # Initialize data for simulation.
  #
   if { ![info exists mom_sim_ug_tool_name] } {
      set mom_sim_ug_tool_name ""
   }

   if { ![info exists mom_sim_tool_loaded] } {
      set mom_sim_tool_loaded ""
   }

   if { ![info exists mom_sim_tool_junction] } {
      set mom_sim_tool_junction "$mom_sim_spindle_jct"
   }

   if { ![info exists mom_sim_curr_jct_matrix] } {
      lappend mom_sim_curr_jct_matrix 1.0 0.0 0.0  0.0 1.0 0.0  0.0 0.0 1.0
   }

   if { ![info exists mom_sim_curr_jct_origin] } {
      lappend mom_sim_curr_jct_origin 0.0 0.0 0.0
   }

   for {set i 0} {$i < 8} {incr i} {
      if { ![info exists mom_sim_pos($i)] } {
         set mom_sim_pos($i) 0
      }
   }


  # Initialize controller's states, in case, not set in a VNC by
  # PB_CMD_vnc____set_nc_definitions
  #
   global mom_sim_vnc_msg_prefix
   if ![info exists mom_sim_vnc_msg_prefix] {
      set mom_sim_vnc_msg_prefix  "VNC_MSG::"
   }

   global mom_sim_spindle_max_rpm mom_sim_spindle_speed
   if ![info exists mom_sim_spindle_max_rpm] {
      set mom_sim_spindle_max_rpm 0
   }
   if ![info exists mom_sim_spindle_speed] {
      set mom_sim_spindle_speed 0
   }

   global mom_sim_cycle_spindle_axis
   if ![info exists mom_sim_cycle_spindle_axis] {
      set mom_sim_cycle_spindle_axis 2
   }

   if ![info exists mom_sim_nc_register(POWER_ON_WCS)] {
      set mom_sim_nc_register(POWER_ON_WCS) 0
   }
   set mom_sim_nc_register(WCS) $mom_sim_nc_register(POWER_ON_WCS)

   if { ![info exists mom_sim_nc_register(MOTION)] } {
      set mom_sim_nc_register(MOTION) RAPID
   }
   if { ![info exists mom_sim_nc_register(INPUT)] } {
      set mom_sim_nc_register(INPUT) ABS
   }
   if { ![info exists mom_sim_nc_register(STROKE_LIMIT)] } {
      set mom_sim_nc_register(STROKE_LIMIT) ON
   }
   if { ![info exists mom_sim_nc_register(CUTCOM)] } {
      set mom_sim_nc_register(CUTCOM) OFF
   }
   if { ![info exists mom_sim_nc_register(TL_ADJUST)] } {
      set mom_sim_nc_register(TL_ADJUST) OFF
   }
   if { ![info exists mom_sim_nc_register(SCALE)] } {
      set mom_sim_nc_register(SCALE) OFF
   }
   if { ![info exists mom_sim_nc_register(MACRO_MODAL)] } {
      set mom_sim_nc_register(MACRO_MODAL) OFF
   }
   if { ![info exists mom_sim_nc_register(WCS_ROTATE)] } {
      set mom_sim_nc_register(WCS_ROTATE) OFF
   }
   if { ![info exists mom_sim_nc_register(CYCLE)] } {
      set mom_sim_nc_register(CYCLE) OFF
   }
   if { ![info exists mom_sim_nc_register(CYCLE_RETURN)] } {
      set mom_sim_nc_register(CYCLE_RETURN) INIT_LEVEL
   }
   if { ![info exists mom_sim_nc_register(RETURN_HOME)] } {
      set mom_sim_nc_register(RETURN_HOME) 0
   }
   if { ![info exists mom_sim_nc_register(FROM_HOME)] } {
      set mom_sim_nc_register(FROM_HOME) 0
   }
   if { ![info exists mom_sim_nc_register(MAIN_OFFSET)] } {
      set mom_sim_nc_register(MAIN_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]
   }
   if { ![info exists mom_sim_nc_register(LOCAL_OFFSET)] } {
      set mom_sim_nc_register(LOCAL_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]
   }
   if { ![info exists mom_sim_nc_register(WORK_OFFSET)] } {
      set mom_sim_nc_register(WORK_OFFSET) [PB_SIM_call VNC_map_to_machine_offsets $mom_sim_wcs_offsets($mom_sim_nc_register(WCS))]
   }

   if { ![info exists mom_sim_nc_register(SPINDLE_DIRECTION)] } {
      set mom_sim_nc_register(SPINDLE_DIRECTION) OFF
   }
   if { ![info exists mom_sim_nc_register(SPINDLE_MODE)] } {
      set mom_sim_nc_register(SPINDLE_MODE) REV_PER_MIN
   }
   if { ![info exists mom_sim_nc_register(S)] } {
      set mom_sim_nc_register(S) 0
   }
   if { ![info exists mom_sim_nc_register(FEED_MODE)] } {
      switch $mom_sim_nc_register(UNIT) {
         MM {
            set mom_sim_nc_register(FEED_MODE) MM_PER_MIN
         }
         default {
            set mom_sim_nc_register(FEED_MODE) INCH_PER_MIN
         }
      }
   }
   if { ![info exists mom_sim_nc_register(F)] } {
      set mom_sim_nc_register(F) 0
   }

   global mom_sim_rapid_dogleg
   if ![info exists mom_sim_rapid_dogleg] {
      set mom_sim_rapid_dogleg  0
   }


#>>>>>
  # Initialize subspindle activation state
  #
   if { ![info exists mom_sim_nc_register(CROSS_MACHINING)] } {
      set mom_sim_nc_register(CROSS_MACHINING) 0
   }

  # Initialize machine mode
  #
   global mom_sim_machine_type
   if [string match "*wedm*" $mom_sim_machine_type] {
      set mom_sim_nc_register(MACHINE_MODE) WEDM
   } elseif [string match "*lathe*" $mom_sim_machine_type] {
      set mom_sim_nc_register(MACHINE_MODE) TURN
   } else {
      set mom_sim_nc_register(MACHINE_MODE) MILL
   }

  # Initialize plane code
  #
   if { ![info exists mom_sim_nc_register(PLANE)] } {
      if [string match "TURN" $mom_sim_nc_register(MACHINE_MODE)] {
         set mom_sim_nc_register(PLANE) ZX
      } else {
         set mom_sim_nc_register(PLANE) XY
      }
   }

  # Initialize CSYS state
  #
   global mom_sim_csys_set
   if ![info exists mom_sim_csys_set] {
      set mom_sim_csys_set  0
   }

  # Initialize tool offsets
  #
   global mom_sim_tool_offset_used mom_sim_tool_offset
   if { ![info exists mom_sim_tool_offset_used] } {
      set mom_sim_tool_offset_used 0
   }

   if { ![info exists mom_sim_tool_offset] } {
      set mom_sim_tool_offset(0) 0.0
      set mom_sim_tool_offset(1) 0.0
      set mom_sim_tool_offset(2) 0.0
   }

   global mom_sim_pivot_distance
   if { ![info exists mom_sim_pivot_distance] } {
      set mom_sim_pivot_distance 0.0
   }

  # Set default N/C output unit.  This value will be used
  # when no output unit function is specified in the N/C code.
  # It's also used as the intial mode when controller is reset.
  #
   set mom_sim_nc_register(DEF_UNIT)       $mom_sim_nc_register(UNIT)

  #-----------------------------------
  # Set the machine tool driver units.
  #-----------------------------------
   if [string match "MM" $mom_sim_nc_register(UNIT)] {
      PB_SIM_call SIM_set_mtd_units "MM" 
   } else {
      PB_SIM_call SIM_set_mtd_units "INCH" 
   }

  #--------------------------------
  # Set rotary axis direction mode.
  #--------------------------------
   global mom_sim_4th_axis_direction mom_sim_5th_axis_direction
   global mom_sim_4th_axis_max_limit mom_sim_5th_axis_max_limit
   global mom_sim_4th_axis_min_limit mom_sim_5th_axis_min_limit

   if [info exists mom_sim_lg_axis(4)] {
      if { ![string match " " $mom_sim_4th_axis_direction] } {
         if [string match "MAGNITUDE_DETERMINES_DIRECTION" $mom_sim_4th_axis_direction] {
            if { [EQ_is_zero $mom_sim_4th_axis_min_limit] && [EQ_is_equal $mom_sim_4th_axis_max_limit 360.0] } {
               set mom_sim_4th_axis_direction "ALWAYS_SHORTEST"
            }
         }
         PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(4) $mom_sim_4th_axis_direction
      }
   }
   if [info exists mom_sim_lg_axis(5)] {
      if { ![string match " " $mom_sim_5th_axis_direction] } {
         if [string match "MAGNITUDE_DETERMINES_DIRECTION" $mom_sim_5th_axis_direction] {
            if { [EQ_is_zero $mom_sim_5th_axis_min_limit] && [EQ_is_equal $mom_sim_5th_axis_max_limit 360.0] } {
               set mom_sim_5th_axis_direction "ALWAYS_SHORTEST"
            }
         }
         PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(5) $mom_sim_5th_axis_direction
      }
   }


  #--------------------------------------------------------
  # Define max feed rate for each axis, if not yet defined.
  #--------------------------------------------------------
   global mom_sim_rapid_feed_rate
   global mom_sim_rapid_feed mom_sim_rapid_unit
   global mom_sim_spindle_max_rpm


   if ![info exists mom_sim_rapid_feed(X)] {
      set mom_sim_rapid_feed(X) $mom_sim_rapid_feed_rate
   }
   if ![info exists mom_sim_rapid_feed(Y)] {
      set mom_sim_rapid_feed(Y) $mom_sim_rapid_feed_rate
   }
   if ![info exists mom_sim_rapid_feed(Z)] {
      set mom_sim_rapid_feed(Z) $mom_sim_rapid_feed_rate
   }
   if ![info exists mom_sim_rapid_feed(4)] {
      set mom_sim_rapid_feed(4) $mom_sim_rapid_feed_rate
   }
   if ![info exists mom_sim_rapid_feed(5)] {
      set mom_sim_rapid_feed(5) $mom_sim_rapid_feed_rate
   }

   if ![info exists mom_sim_rapid_unit(X)] {
      set mom_sim_rapid_unit(X) $mom_sim_nc_register(FEED_MODE)
   }
   if ![info exists mom_sim_rapid_unit(Y)] {
      set mom_sim_rapid_unit(Y) $mom_sim_nc_register(FEED_MODE)
   }
   if ![info exists mom_sim_rapid_unit(Z)] {
      set mom_sim_rapid_unit(Z) $mom_sim_nc_register(FEED_MODE)
   }
   if ![info exists mom_sim_rapid_unit(4)] {
      set mom_sim_rapid_unit(4) REV_PER_MIN
   }
   if ![info exists mom_sim_rapid_unit(5)] {
      set mom_sim_rapid_unit(5) REV_PER_MIN
   }

  # Default max rpm
   set default_spindle_max_rpm 10000

   if ![info exists mom_sim_spindle_max_rpm] {
      set mom_sim_spindle_max_rpm $default_spindle_max_rpm
   }
   if ![EQ_is_gt $mom_sim_spindle_max_rpm 0.0] {
      set mom_sim_spindle_max_rpm $default_spindle_max_rpm
   }


  #------------------------------------------------
  # Initialize parameters required by Sync Manager
  # for the components involved in this driver.
  #
   global mom_multi_channel_mode

   if [info exists mom_multi_channel_mode] {


      global mom_sim_delay_one_block
      set mom_sim_delay_one_block 0


     # In case sync manager is not yet initialized...
      global mom_sim_sync_manager_initialized
      if ![info exists mom_sim_sync_manager_initialized] {
         PB_SIM_call PB_CMD_vnc__start_of_program
      }


      global mom_sim_result mom_sim_result1
      PB_SIM_call SIM_ask_nc_axes_of_mtool

      set axes_list {X Y Z 4 5}
      foreach axis $axes_list {
         if [info exists mom_sim_mt_axis($axis)] {
            if { [lsearch $mom_sim_result1 $mom_sim_mt_axis($axis)] >= 0 } {
               PB_SIM_call SIM_mach_max_axis_rapid_velocity $mom_sim_mt_axis($axis) $mom_sim_rapid_feed($axis) $mom_sim_rapid_unit($axis)
            }
         }
      }
   }


  #-------------------------------------------------------------------------------
  # Initialize reference CSYS w.r.t the MTCS junction with the machine model.
  # - This also establishes the machine datum csys.
  # - This matrix is also used to define the 1st version of the main & local csys.
  #
   if { $mom_sim_csys_set == 0 } {

     # Fix legacy offsets (5 elements -> 6 elements)
      set n_wcs [array size mom_sim_wcs_offsets]

      for { set i 0 } { $i < $n_wcs } { incr i } {
         if { [llength $mom_sim_wcs_offsets($i)] == 5 } {
            set mom_sim_wcs_offsets($i) [PB_SIM_call VNC_map_from_machine_offsets $mom_sim_wcs_offsets($i)]
         }
      }


     # Offsets between MTCS and the main WCS
      global mom_sim_machine_zero_offsets
      if ![info exists mom_sim_machine_zero_offsets] {
         set mom_sim_machine_zero_offsets  [list 0.0 0.0 0.0]
      }


     # Define all Work Coordinate Systems
     #
      PB_SIM_call PB_CMD_vnc__define_wcs
   }


  # Initialize cut data type
   global mom_sim_cut_data_type
   if ![info exists mom_sim_cut_data_type] {
      set mom_sim_cut_data_type "CENTERLINE"
   }
}


#=============================================================
proc PB_CMD_vnc__output_param_msg { } {
#=============================================================
  global mom_sim_message


  # Direct VNC msg to the NC setup data file
   global mom_sim_output_extended_nc
   global ptp_file_name
   if { [info exists mom_sim_output_extended_nc] && $mom_sim_output_extended_nc } {
      set setup_data_file [file rootname [file tail $ptp_file_name]]_setup.dat

      MOM_close_output_file  $ptp_file_name
      MOM_open_output_file   $setup_data_file
   }


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Use MOM_output_literal to display operator messages in NC window
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   MOM_output_text $mom_sim_message
  # MOM_output_literal $mom_sim_message


   if { [info exists mom_sim_output_extended_nc] && $mom_sim_output_extended_nc } {
      MOM_close_output_file $setup_data_file
      MOM_open_output_file  $ptp_file_name
   }
}


#=============================================================
proc PB_CMD_vnc__output_vnc_msg { } {
#=============================================================
  global mom_sim_message
  global mom_sim_control_out mom_sim_vnc_msg_prefix mom_sim_control_in

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                        $mom_sim_message $mom_sim_control_in"

   PB_SIM_call PB_CMD_vnc__output_param_msg
}


#=============================================================
proc PB_CMD_vnc__pass_contact_contour_data { } {
#=============================================================
  global mom_sim_message
  global mom_cut_data_type mom_tracking_point_type
  global mom_tracking_point_diameter mom_tracking_point_distance


   if { [info exists mom_cut_data_type] && [string match "contact contour" $mom_cut_data_type] } {
      set mom_sim_message "CUT_DATA_TYPE==CONTACT_CONTOUR"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg

      if { $mom_tracking_point_type == 1 } {
         set mom_sim_message "CONTACT_TRACKING_TYPE==POINT"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg

         set mom_sim_message "CONTACT_TRACKING_DIAMETER==$mom_tracking_point_diameter"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg

         set mom_sim_message "CONTACT_TRACKING_DISTANCE==$mom_tracking_point_distance"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg

      } else {
         set mom_sim_message "CONTACT_TRACKING_TYPE==BOTTOM"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg
      }
   } else {
      set mom_sim_message "CUT_DATA_TYPE==CENTERLINE"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }
}


#=============================================================
proc PB_CMD_vnc__pass_csys_data { } {
#=============================================================
# This function is only executed in an in-process ISV
# to pass csys definitions.
#
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_csys_matrix

  global mom_coordinate_system_purpose
  global mom_special_output
  global mom_kin_coordinate_system_type
  global mom_machine_csys_matrix
  global mom_sim_message


   if [info exists mom_machine_csys_matrix] {

      global mom_main_mcs
      global mom_coordinate_system_purpose

      global mom_sim_main_mcs
      global mom_sim_machine_type


     # Grab main MCS
      MTX3_transpose mom_machine_csys_matrix mainMCS

       set mainMCS(9)  $mom_machine_csys_matrix(9)
       set mainMCS(10) $mom_machine_csys_matrix(10)
       set mainMCS(11) $mom_machine_csys_matrix(11)


#VNC_pause "machine csys matrix : [VNC_sort_array_vals mom_machine_csys_matrix]"
#VNC_pause "local csys matrix : [VNC_sort_array_vals mom_csys_matrix]"
#VNC_pause " CSYS Purpose : $mom_coordinate_system_purpose\nSpecial Output : $mom_special_output\nCoordinate System Type : $mom_kin_coordinate_system_type"


     #==========================================================
     # CSYS Purpose  (mom_coordinate_system_purpose)
     # ------------
     #                      1 : Main
     #                      0 : Local
     #
     # Special Output  (mom_special_output)
     # --------------
     #                      0 : None
     #                      1 : Use Main MCS
     #                      2 : Fixture Offset
     #                      3 : CSYS Rotation
     #
     # Coordinate System Type  (mom_kin_coordinate_system_type)
     # ----------------------
     #          When CSYS Purpose = 1 (Main)
     #                      LOCAL
     #
     #          When CSYS Purpose = 0 (Local)
     #                      MAIN  : Special Output = 1
     #                      LOCAL : Special Output = 0, 2
     #                      CSYS  : Special Output = 3
     #==========================================================

      set main_mcs_found 0

      if { $mom_coordinate_system_purpose == 1 } {

         set coordinate_system_mode  MAIN

        # Set a flag to preserve real mainMCS later
         set main_mcs_found 1

      } else {

         set coordinate_system_mode  $mom_kin_coordinate_system_type
      }


     # A local MCS without main becomes a main MCS itself.
     # mom_machine_csys_matrix containing ACS matrix is redefined with the local MCS itself.
     #
      if { $coordinate_system_mode  != "MAIN" } {

         if { [string match "GEOMETRY" $mom_main_mcs] || [string match "NONE" $mom_main_mcs] } {

            set coordinate_system_mode MAIN
         }
      }


     # Define mainMCS for any MAIN mode
     #
      if { $coordinate_system_mode  == "MAIN" } {

         MTX3_transpose mom_machine_csys_matrix mcs_matrix
         MTX3_multiply mcs_matrix mom_csys_matrix mainMCS

         set u(0) $mom_csys_matrix(9)
         set u(1) $mom_csys_matrix(10)
         set u(2) $mom_csys_matrix(11)

         MTX3_vec_multiply u mom_machine_csys_matrix w

         set mainMCS(9)  [expr $mom_machine_csys_matrix(9)  + $w(0)]
         set mainMCS(10) [expr $mom_machine_csys_matrix(10) + $w(1)]
         set mainMCS(11) [expr $mom_machine_csys_matrix(11) + $w(2)]

        # Preserve a real main MCS
         if $main_mcs_found {
            for { set i 0 } { $i < 12 } { incr i } {
               set mom_sim_main_mcs($i)  $mainMCS($i)
            }
         }
      }


     # Extract offsets between a local and the mainMCS
     #
      if { $coordinate_system_mode != "MAIN" } {

         global mom_fixture_offset_value
         global mom_sim_nc_register mom_sim_wcs_offsets

        # Fetch fixture offset # specified with the CSYS object
         if { $mom_fixture_offset_value > 0 } {

            set mom_sim_nc_register(WCS) $mom_fixture_offset_value


           # Set linear offsets
            set mom_sim_wcs_offsets($mom_fixture_offset_value)\
                [list $mom_csys_matrix(9) $mom_csys_matrix(10) $mom_csys_matrix(11) 0.0 0.0 0.0]

           # Find angular offsets per axis of rotation
            global mom_sim_machine_type
            global mom_sim_4th_axis_plane mom_sim_5th_axis_plane

            if { ![string match "*wedm" $mom_sim_machine_type] &&\
                 ![string match "*lathe" $mom_sim_machine_type] &&\
                 ![string match "*punch" $mom_sim_machine_type] } {

               for { set i 0 } { $i < 9 } { incr i } {
                 set csys($i) $mom_csys_matrix($i)
               }

               set fourth_ang 0.0
               set fifth_ang  0.0

               set 4th_index 0
               set 5th_index 0

               if { [string match "4*" $mom_sim_machine_type] } {
                  switch $mom_sim_4th_axis_plane {
                     "XY" {
                        set fourth_ang [rad2deg [expr atan2($csys(1),$csys(0))]]
                        set 4th_index 5
                     }
                     "YZ" {
                        set fourth_ang [rad2deg [expr atan2(-1*$csys(7),$csys(8))]]
                        set 4th_index 3
                     }
                     "ZX" {
                        set fourth_ang [rad2deg [expr atan2($csys(6),$csys(8))]]
                        set 4th_index 4
                     }
                  }
                  if [string match "*head*" $mom_sim_machine_type] {
                     set fourth_ang [expr -1 * $fourth_ang]
                  }
               }

               if { [string match "5*" $mom_sim_machine_type] } {
                  switch $mom_sim_4th_axis_plane {
                     "XY" {
                        set 4th_index 5
                        switch $mom_sim_5th_axis_plane {
                           "YZ" {
                             # C/A
                              # Rotate Y' to XY plane for A
                               set fifth_ang  [rad2deg [expr atan2($csys(5),$csys(4))]]
                               set d [expr sqrt( $csys(5)*$csys(5) + $csys(4)*$csys(4) )]

                              # Rotate Y' to Y on XY plane for C
                               set fourth_ang  [rad2deg [expr -1*atan2($csys(3),$d)]]

                               set 5th_index 3
                           }
                           "ZX" {
                             # C/B
                              # Rotate X' to XY plane for B
                               set fifth_ang  [rad2deg [expr -1*atan2($csys(2),$csys(0))]]
                               set d [expr sqrt( $csys(2)*$csys(2) + $csys(0)*$csys(0) )]

                              # Rotate X' to X on ZX plane for C
                               set fourth_ang  [rad2deg [expr atan2($csys(1),$d)]]

                               set 5th_index 4
                           }
                        }
                     }
                     "YZ" {
                        set 4th_index 3
                        switch $mom_sim_5th_axis_plane {
                           "XY" {
                             # A/C
                              # Rotate Z' to YZ plane for C (measured on XY plane)
                               set fifth_ang [rad2deg [expr -1*atan2($csys(6),$csys(7))]]
                               set d [expr sqrt( $csys(7)*$csys(7) + $csys(6)*$csys(6) )]

                              # Rotate Z' to Z on ZX plane for A
                               set fourth_ang [rad2deg [expr -1*atan2($d,$csys(8))]]

                               set 5th_index 5
                           }
                           "ZX" {
                             # A/B
                              # Rotate Z' to YZ plane for B (measured on XZ plane)
                               set fifth_ang  [rad2deg [expr atan2($csys(6),$csys(8))]]
                               set d [expr sqrt( $csys(6)*$csys(6) + $csys(8)*$csys(8) )]

                              # Rotate Z' to Z on ZX plane for B
                               set fourth_ang [rad2deg [expr -1*atan2($csys(7),$d)]]

                               set 5th_index 4
                           }
                        }
                     }
                     "ZX" {
                        set 4th_index 4
                        switch $mom_sim_5th_axis_plane {
                           "XY" {
                             # B/C
                              # Rotate Z' to ZX plane for C (measured on XY plane)
                               set fifth_ang [rad2deg [expr atan2($csys(7),$csys(6))]]

                              # Rotate Z' to Z on YZ plane for B
                               set d [expr sqrt( $csys(7)*$csys(7) + $csys(6)*$csys(6) )]
                               set fourth_ang [rad2deg [expr atan2($d,$csys(8))]]

                               set 5th_index 5
                           }
                           "YZ" {
                             # B/A
                              # Rotate Z' to ZX plane for A (measured on YZ plane)
                               set fifth_ang  [rad2deg [expr -1*atan2($csys(7),$csys(8))]]
                               set d [expr sqrt( $csys(7)*$csys(7) + $csys(8)*$csys(8) )]

                              # Rotate Z' to Z on YZ plane for B
                               set fourth_ang [rad2deg [expr atan2($csys(6),$d)]]

                               set 5th_index 3
                           }
                        }
                     }
                  }

                 # Negate angles for heads
                  if [string match "*dual_head*" $mom_sim_machine_type] {
                     set fourth_ang [expr -1 * $fourth_ang]
                     set fifth_ang  [expr -1 * $fifth_ang]
                  }
                  if [string match "*head_table*" $mom_sim_machine_type] {
                     set fourth_ang [expr -1 * $fourth_ang]
                  }
               }

              # Update fixture offset with angular offsets
               if { $4th_index > 0 } {
                  set mom_sim_wcs_offsets($mom_fixture_offset_value)\
                      [lreplace $mom_sim_wcs_offsets($mom_fixture_offset_value) $4th_index $4th_index $fourth_ang]
               }
               if { $5th_index > 0 } {
                  set mom_sim_wcs_offsets($mom_fixture_offset_value)\
                      [lreplace $mom_sim_wcs_offsets($mom_fixture_offset_value) $5th_index $5th_index $fifth_ang]
               }
            }


           # Rotate WCS offsets for MCSX lathe work plane
            if [string match "*lathe" $mom_sim_machine_type] {

               global mom_lathe_spindle_axis

               if { [info exists mom_lathe_spindle_axis] && [string match "MCSX" $mom_lathe_spindle_axis] } {

                  set x_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 1]
                  set y_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 2]
                  set z_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 0]
                  set a_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 3]
                  set b_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 4]
                  set c_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 5]

                  set mom_sim_wcs_offsets($mom_fixture_offset_value) [list $x_off $y_off $z_off $a_off $b_off $c_off]
               }
            }

         } ;# fixture_offset > 0

      } ;# LOCAL


     # Fetch the real main MCS, if any.
      if [info exists mom_sim_main_mcs] {
         for { set i 0 } { $i < 12 } { incr i } {
           set mainMCS($i) $mom_sim_main_mcs($i)
         }
      }


      if [string match "MAIN" $coordinate_system_mode] {

        # Origin UDE specifies the offsets from a main MCS to the desired reference CSYS for output.
        # This UDE will not be known or involved in standalone NC files.
         global mom_origin

         for { set i 9 } { $i < 12 } { incr i } {
            if [info exists mom_origin] {
               set mainMCS($i) [expr $mainMCS($i) + $mom_origin([expr $i - 9])]
            }
         }

      } else {

         MTX3_multiply mainMCS mom_csys_matrix matrix

         set u(0) $mom_csys_matrix(9)
         set u(1) $mom_csys_matrix(10)
         set u(2) $mom_csys_matrix(11)

         MTX3_vec_multiply u mom_machine_csys_matrix w

         set matrix(9)  [expr $mainMCS(9)  + $w(0)]
         set matrix(10) [expr $mainMCS(10) + $w(1)]
         set matrix(11) [expr $mainMCS(11) + $w(2)]
      }


     # Rotate main CSYS matrix for lathe MCSX work plane
      if [string match "*lathe" $mom_sim_machine_type] {

         global mom_lathe_spindle_axis

         if { [info exists mom_lathe_spindle_axis] && [string match "MCSX" $mom_lathe_spindle_axis] } {
            MTX3_x mainMCS x
            MTX3_y mainMCS y
            MTX3_z mainMCS z

            set mainMCS(0) $y(0)
            set mainMCS(1) $y(1)
            set mainMCS(2) $y(2)

            set mainMCS(3) $z(0)
            set mainMCS(4) $z(1)
            set mainMCS(5) $z(2)

            set mainMCS(6) $x(0)
            set mainMCS(7) $x(1)
            set mainMCS(8) $x(2)

#VNC_pause "Lathe work plane MCSX"
         }
      }


     # Output WCS number
     #
      global mom_fixture_offset_value
      if ![info exists mom_fixture_offset_value] {
         set fixture_offset 0
      } else {
         set fixture_offset $mom_fixture_offset_value
      }
      set mom_sim_message "CSYS_FIXTURE_OFFSET==$fixture_offset"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg


     #---------------------------------------------------------------------------
     # Always simulate N/C codes w.r.t. the qualified main MCS.
     # A local MCS will not be referenced until a G68 or G54 etc. is encountered.
     #---------------------------------------------------------------------------
      for { set i 0 } { $i < 12 } { incr i } {
         set mom_sim_message "CSYS_MTX_$i==$mainMCS($i)"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg
      }

#VNC_pause "$coordinate_system_mode mainMCS --> [VNC_sort_array_vals mainMCS]"


     # Retain a copy of main, local & the currently active csys matrix
      global mom_sim_main_csys_matrix
      global mom_sim_local_csys_matrix
      global mom_sim_csys_matrix

      if ![string match "MAIN" $coordinate_system_mode] {
         for { set i 0 } { $i < 12 } { incr i } {
            set mom_sim_csys_matrix($i)       $matrix($i)
            set mom_sim_local_csys_matrix($i) $matrix($i)
         }
      } else {
         for { set i 0 } { $i < 12 } { incr i } {
            set mom_sim_main_csys_matrix($i)  $mainMCS($i)
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__pass_tool_carrier_data { } {
#=============================================================
  global mom_sim_message
  global mom_carrier_name
  global mom_spindle_group

   if [info exists mom_carrier_name] {
      set mom_sim_message "TOOL_CARRIER_ID==$mom_carrier_name"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }

   if { [info exists mom_spindle_group] } {
      set mom_sim_message "SPINDLE_GROUP==$mom_spindle_group"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }
}


#=============================================================
proc PB_CMD_vnc__pass_tool_data { } {
#=============================================================
  global mom_tool_name
  global mom_tool_offset_defined mom_tool_offset
  global mom_sim_message


   if { ![info exists mom_tool_offset_defined] } {
      set mom_tool_offset_defined 0
   }
   if { ![info exists mom_tool_offset(0)] } { set mom_tool_offset(0) 0 }
   if { ![info exists mom_tool_offset(1)] } { set mom_tool_offset(1) 0 }
   if { ![info exists mom_tool_offset(2)] } { set mom_tool_offset(2) 0 }

   global mom_tool_number
   if { ![info exists mom_tool_number] } {
return
   }
   set mom_sim_message "TOOL_NUMBER==$mom_tool_number"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "TOOL_NAME==$mom_tool_name"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "TOOL_OFFSET==$mom_tool_offset_defined"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "TOOL_X_OFF==$mom_tool_offset(0)"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "TOOL_Y_OFF==$mom_tool_offset(1)"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "TOOL_Z_OFF==$mom_tool_offset(2)"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg


   global mom_tool_diameter mom_tool_adjust_register mom_tool_cutcom_register

   if { [info exists mom_tool_diameter] } {
      set mom_sim_message "TOOL_DIAMETER==$mom_tool_diameter"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }
   if { [info exists mom_tool_cutcom_register] } {
      set mom_sim_message "TOOL_CUTCOM_REG==$mom_tool_cutcom_register"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }
   if { [info exists mom_tool_adjust_register] } {
      set mom_sim_message "TOOL_ADJUST_REG==$mom_tool_adjust_register"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }

   global mom_pocket_id
   if { [info exists mom_pocket_id] } {
      set mom_sim_message "TOOL_POCKET_ID==$mom_pocket_id"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }
}


# Do not disturb existing function during conversion!
if { [llength [info commands PB_CMD_vnc__preprocess_nc_block]] == 0 } {
#=============================================================
proc PB_CMD_vnc__preprocess_nc_block { } {
#=============================================================
# This command (executed automatically) enables you to
# process the NC block, before it's subject to the simulation.
#
#
#  Actions can be performed per sub-string pattern found in the
#  block buffer.
#
#  Simple search can be done using "string match ..." command,
#  whereas more rigorous search can be done using
#
#  "VNC_parse_nc_block BUFFER word cb_cmd"
#
#    Arguments -
#           BUFFER  : Reference (pointer) to the block buffer
#                     (Normally you pass in "mom_sim_o_buffer" without "$" sign.)
#                     ** At this point, the block sequence number
#                        has been removed from "mom_sim_o_buffer".
#           word    : token (string pattern) to be identified
#           cb_cmd  : Optional callback command string to be executed
#                     when a match has been found.
#
#    Return -
#           0 : no match is found
#           1 : an exact match is found (no numerals traling the token)
#           2 : an extended match is found (with trailing numerals)
#
#  When a block buffer containing "X1.234" is searched for the token "X",
#  an extended match (2) will be found.
#
#  mom_sim_nc_code
#  ***************
#    "1.234" will be stored in global varaible "mom_sim_nc_code".
#
#    Entire matched sub-string (X1.234) will be removed from the buffer
#    passed into "VNC_parse_nc_block".
#
#  o_buff
#  ******
#    Normally, the local variable "o_buff" is set to the block buffer before
#    "mom_sim_o_buffer" is subject to the process to preserve its original
#    state. When a desired match is found the "o_buff" can be set to the
#    resultant "$mom_sim_o_buffer" and then returned to the calling command
#    for subsequent process.
#
#    If no further process is needed for the block after a token is found,
#    "o_buff" is set to a NULL string ("") then returned.
#
#

  global mom_sim_o_buffer
  global mom_sim_nc_code
  global mom_sim_nc_address
  global mom_sim_nc_register
  global mom_sim_address


   set o_buff $mom_sim_o_buffer


  # Trim off anything after an @ sign (comment)
  #
   if [string match "*@*" $mom_sim_o_buffer] {
      set i_at [string first "@" $mom_sim_o_buffer]
      if { $i_at > -1 } {
         set o_buff [string trimright [string range $mom_sim_o_buffer 0 [expr $i_at - 1]]]
      }
   }


   set mom_sim_o_buffer $o_buff


  # Extract T code
  #
  # Depending on controller, a tool change may be performed when
  # a T code is encountered, or triggered by a M06 later on.
  # -- T code is NOT removed from the buffer at this point.
  #
   set token $mom_sim_address(T,leader)
   if { [VNC_parse_nc_block mom_sim_o_buffer $token] == 2 } {

     # Here we assume the T address only contains tool number with leading zero.
     # -- More rigorous code will be needed when T code also contains
     #    tool length adjust register or other data.
     #
      set code [string trimleft $mom_sim_nc_code 0]
      if { [string length $code] == 0 } {
         set code 0
      }

     # Save tool number to register
      set mom_sim_nc_register($token) $code

     # Perform tool change, if necessary, or restore block buffer
     #
      change_tool 0

      if $change_tool {
         PB_SIM_call VNC_tool_change
      } else {
         set mom_sim_o_buffer $o_buff
      }
   }


  # Extract D code
  #
   set token $mom_sim_address(D,leader)
   if { [VNC_parse_nc_block mom_sim_o_buffer $token] == 2 } {
      set code [string trimleft $mom_sim_nc_code 0]
      if { [string length $code] == 0 } {
         set code 0
      }
      set mom_sim_nc_register($token) $code
      set o_buff $mom_sim_o_buffer
   }


  # Extract H code
  #
   set token $mom_sim_address(H,leader)
   if { [VNC_parse_nc_block mom_sim_o_buffer $token] == 2 } {
      set code [string trimleft $mom_sim_nc_code 0]
      if { [string length $code] == 0 } {
         set code 0
      }
      set mom_sim_nc_register($token) $code
      set o_buff $mom_sim_o_buffer
   }


  # Return an empty buffer to prevent further simulation of this block.
  # set o_buff ""


return $o_buff
}
} ;# if


#=============================================================
proc PB_CMD_vnc__reload_machine_tool_axes { } {
#=============================================================
  global mom_sim_num_machine_axes
  global mom_sim_mt_axis
  global mom_sim_result mom_sim_result1
  global mom_sim_zcs_base mom_sim_zcs_base_MCS
  global mom_sim_spindle_comp mom_sim_spindle_jct
  global mom_sim_pivot_jct


  #-------------------------------------
  # Fetch machine kinematics from model
  #-------------------------------------
   set mom_sim_mt_axis(X)     [PB_SIM_call SIM_ask_nc_axis_name X]
   set mom_sim_mt_axis(Y)     [PB_SIM_call SIM_ask_nc_axis_name Y]
   set mom_sim_mt_axis(Z)     [PB_SIM_call SIM_ask_nc_axis_name Z]

   switch $mom_sim_num_machine_axes {
      "4" {
         set mom_sim_mt_axis(4) [PB_SIM_call SIM_ask_nc_axis_name 4th]
      }
      "5" {
         set mom_sim_mt_axis(4) [PB_SIM_call SIM_ask_nc_axis_name 4th]
         set mom_sim_mt_axis(5) [PB_SIM_call SIM_ask_nc_axis_name 5th]
      }
   }

   set mom_sim_zcs_base_MCS   [PB_SIM_call SIM_ask_zcs_comp_name]
   set mom_sim_zcs_base       $mom_sim_zcs_base_MCS


   set spindle_jct            [PB_SIM_call SIM_ask_tool_mount_jnct_name]
   if [string match "" $spindle_jct] {
      set spindle_jct         [PB_SIM_call SIM_ask_tool_mount_jct_name]
   }
   if ![string match "" $spindle_jct] {
      set mom_sim_spindle_jct $spindle_jct
   }

   set mom_sim_spindle_comp   [PB_SIM_call SIM_ask_tool_mount_comp_name]

   set pivot_jct              [PB_SIM_call SIM_ask_head_pivot_jct_full_name]
   if ![string match "" $pivot_jct] {
      set mom_sim_pivot_jct   $pivot_jct
   } else {
      set mom_sim_pivot_jct   $mom_sim_spindle_jct
   }


  # For this machine that all physical axes participate in executing a motion. 
   PB_SIM_call SIM_ask_nc_axes_of_mtool

   set axes_config_list [list]

   if [info exists mom_sim_mt_axis(X)] {
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(X)"] >= 0 } {
         lappend axes_config_list $mom_sim_mt_axis(X)
      }
   }

   if [info exists mom_sim_mt_axis(Y)] {
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Y)"] >= 0 } {
         lappend axes_config_list $mom_sim_mt_axis(Y)
      }
   }

   if [info exists mom_sim_mt_axis(Z)] {
      if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Z)"] >= 0 } {
         lappend axes_config_list $mom_sim_mt_axis(Z)
      }
   }


   PB_SIM_call SIM_set_linear_axes_config [concat $axes_config_list]


   switch $mom_sim_num_machine_axes {
      "4" {
         PB_SIM_call SIM_set_rotary_axes_config [concat $mom_sim_mt_axis(4)]
      }
      "5" {
         PB_SIM_call SIM_set_rotary_axes_config [concat $mom_sim_mt_axis(4) $mom_sim_mt_axis(5)]
      }
   }
}


#=============================================================
proc PB_CMD_vnc__reset_controller { } {
#=============================================================
  global mom_sim_nc_register

  # Initialize controller state
   set mom_sim_nc_register(MOTION)         RAPID
   set mom_sim_nc_register(STROKE_LIMIT)   ON
   set mom_sim_nc_register(CUTCOM)         OFF
   set mom_sim_nc_register(TL_ADJUST)      OFF
   set mom_sim_nc_register(SCALE)          OFF
   set mom_sim_nc_register(MACRO_MODAL)    OFF
   set mom_sim_nc_register(WCS_ROTATE)     OFF
   set mom_sim_nc_register(CYCLE)          OFF
   set mom_sim_nc_register(CYCLE_RETURN)   INIT_LEVEL
   set mom_sim_nc_register(RETURN_HOME)    0
   set mom_sim_nc_register(FROM_HOME)      0
}


#=============================================================
proc PB_CMD_vnc__reset_coordinate { } {
#=============================================================
# Called when a G92 is encountered.
#
  global mom_sim_nc_register
  global mom_sim_motion_begun
  global mom_sim_prev_pos

 # Absolute coordinates specified with the block.
  global mom_sim_offset_pt


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Comment out "return" to process work coordinate reset for lathe post
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   if [string match "TURN" $mom_sim_nc_register(MACHINE_MODE)] {
return
   }


   for {set i 0} {$i < 5} {incr i} {

     # Only change the components that exist in the block.
     #
      if [info exists mom_sim_offset_pt($i)] {
        #---------------------------------------------------
        # Do not change offset when the motion hasn't begun,
        # since mom_sim_prev_pos may not be reliable.
        #---------------------------------------------------
         if $mom_sim_motion_begun {
            set offset [expr $mom_sim_offset_pt($i) - $mom_sim_prev_pos($i)]
            set mom_sim_nc_register(MAIN_OFFSET)  [lreplace $mom_sim_nc_register(MAIN_OFFSET) $i $i $offset]
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__send_dogs_home { } {
#=============================================================
  global mom_sim_mt_axis
  global mom_sim_num_machine_axes
  global mom_sim_nc_register
  global mom_sim_result1


  # Determine the axes that need to move per intermediate pt specified.
   set move_X 0
   set move_Y 0
   set move_Z 0
   set move_4 0
   set move_5 0

   PB_SIM_call SIM_ask_nc_axes_of_mtool

   if [info exists mom_sim_nc_register(REF_INT_PT_X)] {
      if { [info exists mom_sim_mt_axis(X)] } {
         if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(X)"] >= 0 } {
            set move_X 1
         }
      }
   }
   if [info exists mom_sim_nc_register(REF_INT_PT_Y)] {
      if { [info exists mom_sim_mt_axis(Y)] } {
         if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Y)"] >= 0 } {
            set move_Y 1
         }
      }
   }
   if [info exists mom_sim_nc_register(REF_INT_PT_Z)] {
      if { [info exists mom_sim_mt_axis(Z)] } {
         if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Z)"] >= 0 } {
            set move_Z 1
         }
      }
   }

   if { $mom_sim_num_machine_axes > 3 } {
      if [info exists mom_sim_nc_register(REF_INT_PT_4)] {
         set move_4 1
      }
   }

   if { $mom_sim_num_machine_axes > 4 } {
      if [info exists mom_sim_nc_register(REF_INT_PT_5)] {
         set move_5 1
      }
   }


  # Establish machine home position in MTCS for the 1st time.
   global mom_sim_pos_mtcs
   global mom_sim_lg_axis
   global mom_sim_spindle_jct mom_sim_current_junction


  # Make use of pivot junction
   global mom_sim_pivot_jct
   if [info exists mom_sim_pivot_jct] {
      PB_SIM_call SIM_set_current_ref_junction $mom_sim_pivot_jct
   } else {
      PB_SIM_call SIM_set_current_ref_junction $mom_sim_spindle_jct
   }

  # Set RAPID mode
   PB_SIM_call VNC_set_feedrate_mode RAPID

   set time 1

   if { ![info exists mom_sim_pos_mtcs(0)] } {
      if $move_X {
         PB_SIM_call SIM_move_linear_axis $time $mom_sim_mt_axis(X) [lindex $mom_sim_nc_register(REF_PT) 0]
      }
      set ref_pt [PB_SIM_call SIM_ask_last_position_mtcs]
      set mom_sim_pos_mtcs(0) [lindex $ref_pt 0]
   }
   if { ![info exists mom_sim_pos_mtcs(1)] } {
      if $move_Y {
         PB_SIM_call SIM_move_linear_axis $time $mom_sim_mt_axis(Y) [lindex $mom_sim_nc_register(REF_PT) 1]
      }
      set ref_pt [PB_SIM_call SIM_ask_last_position_mtcs]
      set mom_sim_pos_mtcs(1) [lindex $ref_pt 1]
   }
   if { ![info exists mom_sim_pos_mtcs(2)] } {
      if $move_Z {
         PB_SIM_call SIM_move_linear_axis $time $mom_sim_mt_axis(Z) [lindex $mom_sim_nc_register(REF_PT) 2]
      }
      set ref_pt [PB_SIM_call SIM_ask_last_position_mtcs]
      set mom_sim_pos_mtcs(2) [lindex $ref_pt 2]
   }

   set coord_list [list]
   if $move_X {
      lappend coord_list $mom_sim_lg_axis(X)  $mom_sim_pos_mtcs(0)
   }
   if $move_Y {
      lappend coord_list $mom_sim_lg_axis(Y)  $mom_sim_pos_mtcs(1)
   }
   if $move_Z {
      lappend coord_list $mom_sim_lg_axis(Z)  $mom_sim_pos_mtcs(2)
   }


   if { [llength $coord_list] > 0 } {
      eval PB_SIM_call SIM_move_linear_mtcs $coord_list
   }

global mom_sim_message
set mom_sim_message "REF PT >$mom_sim_nc_register(REF_PT)<"
PB_CMD_vnc__send_message


   global mom_sim_pos

   if [expr $mom_sim_num_machine_axes > 3] {
      if $move_4 {
         PB_SIM_call SIM_move_rotary_axis $time $mom_sim_mt_axis(4) 0
         set mom_sim_pos(3) 0
      }
   }

   if [expr $mom_sim_num_machine_axes > 4] {
      if $move_5 {
         PB_SIM_call SIM_move_rotary_axis $time $mom_sim_mt_axis(5) 0
         set mom_sim_pos(4) 0
      }
   }
 
   PB_SIM_call SIM_update

   PB_SIM_call SIM_set_current_ref_junction $mom_sim_current_junction

  # Keep track of current position
   if { ![catch {set ref_pt [PB_SIM_call SIM_ask_last_position_zcs]} ] } {
      set mom_sim_pos(0) [lindex $ref_pt 0]
      set mom_sim_pos(1) [lindex $ref_pt 1]
      set mom_sim_pos(2) [lindex $ref_pt 2]
   }

  # Zero Y for lathe mode
   if [string match "TURN" $mom_sim_nc_register(MACHINE_MODE)] {
      set mom_sim_pos(1) 0
   }

  # Zero all other axes
   set mom_sim_pos(5) 0
   set mom_sim_pos(6) 0
   set mom_sim_pos(7) 0
}


#=============================================================
proc PB_CMD_vnc__set_local_offsets { } {
#=============================================================
# This function is executed when G52 is commanded.
# It calculates the offsets for defining a local CSYS within
# the active WCS.
#
   global mom_sim_nc_register
   global mom_sim_offset_pt

   for {set i 0} {$i < 5} {incr i} {
      if [info exists mom_sim_offset_pt($i)] {
         set mom_sim_nc_register(LOCAL_OFFSET) \
             [lreplace $mom_sim_nc_register(LOCAL_OFFSET) $i $i $mom_sim_offset_pt($i)]
      }
   }
}


#=============================================================
proc PB_CMD_vnc__set_param_per_msg { } {
#=============================================================
# This function may not be executed in a standalone NC file
# simulation. Parameters defined here will need to be set
# some place else.
#
  global mom_sim_msg_key mom_sim_msg_word


VNC_output_debug_msg "VNC_MSG - key:$mom_sim_msg_key  word:$mom_sim_msg_word"

   global mom_sim_tool_number mom_sim_tool_data

   switch $mom_sim_msg_key {

      "CUT_DATA_TYPE" {
         global mom_sim_cut_data_type
         set mom_sim_cut_data_type $mom_sim_msg_word
      }

      "CONTACT_TRACKING_TYPE" {
         global mom_sim_contact_tracking_type
         set mom_sim_contact_tracking_type $mom_sim_msg_word
      }

      "CONTACT_TRACKING_DIAMETER" {
         global mom_sim_tool_cutcom_offset
         set mom_sim_tool_cutcom_offset [expr $mom_sim_msg_word / 2]
      }

      "CONTACT_TRACKING_DISTANCE" {
         global mom_sim_tool_adjust_offset
         set mom_sim_tool_adjust_offset $mom_sim_msg_word
      }

      "HELIX_PITCH" {
         global mom_sim_PI
         global mom_sim_helix_pitch
         set mom_sim_helix_pitch "[expr $mom_sim_msg_word / (2 * $mom_sim_PI)]"
      }

      "HELIX_PITCH_TYPE" {
         global mom_sim_helix_pitch_type
         set mom_sim_helix_pitch_type "$mom_sim_msg_word"
      }

      "HELIX_OUTPUT_MODE" {
         global mom_sim_helix_output_mode
         set mom_sim_helix_output_mode "$mom_sim_msg_word"
      }

      "SPINDLE_DIRECTION" {
         global mom_sim_spindle_direction
         set mom_sim_spindle_direction "$mom_sim_msg_word"
      }

      "SPINDLE_MODE" {
         global mom_sim_spindle_mode
         global mom_sim_nc_register

         switch $mom_sim_msg_word {
            RPM { set mom_sim_msg_word REV_PER_MIN }
         }
         set mom_sim_spindle_mode $mom_sim_msg_word
         set mom_sim_nc_register(SPINDLE_MODE) $mom_sim_spindle_mode
      }

      "SPINDLE_MAX_RPM" {
         global mom_sim_spindle_max_rpm
         set mom_sim_spindle_max_rpm "$mom_sim_msg_word"
      }

      "SPINDLE_SPEED" {
         global mom_sim_spindle_speed mom_sim_spindle_mode
         set mom_sim_spindle_speed "$mom_sim_msg_word"

         PB_SIM_call PB_CMD_vnc__set_speed
      }

      "TOOL_NUMBER" {
         set mom_sim_tool_number "$mom_sim_msg_word"

         global mom_sim_tool_change
         set mom_sim_tool_change 1

         global mom_sim_tool_carrier_id
         if [info exists mom_sim_tool_carrier_id] {
            set mom_sim_tool_data($mom_sim_tool_number,carrier_id) "\"$mom_sim_tool_carrier_id\""
         }
      }

      "TOOL_NAME" {
         global mom_sim_ug_tool_name
         set mom_sim_ug_tool_name "$mom_sim_msg_word"

        # Capture tool data in an array.
         set mom_sim_tool_data($mom_sim_tool_number,name) $mom_sim_ug_tool_name
      }

      "TOOL_OFFSET" {
         global mom_sim_tool_offset_used
         set mom_sim_tool_offset_used "$mom_sim_msg_word"

         set mom_sim_tool_data($mom_sim_tool_number,offset_used) $mom_sim_tool_offset_used
      }

      "TOOL_X_OFF" {
         global mom_sim_tool_offset
         set mom_sim_tool_offset(0) "$mom_sim_msg_word"

         set mom_sim_tool_data($mom_sim_tool_number,x_off) $mom_sim_tool_offset(0)
      }

      "TOOL_Y_OFF" {
         global mom_sim_tool_offset
         set mom_sim_tool_offset(1) "$mom_sim_msg_word"

         set mom_sim_tool_data($mom_sim_tool_number,y_off) $mom_sim_tool_offset(1)
      }

      "TOOL_Z_OFF" {
         global mom_sim_tool_offset
         set mom_sim_tool_offset(2) "$mom_sim_msg_word"

         set mom_sim_tool_data($mom_sim_tool_number,z_off) $mom_sim_tool_offset(2)
      }

      "TOOL_CARRIER_ID" {
         global mom_sim_tool_carrier_id
         set mom_sim_tool_carrier_id "$mom_sim_msg_word"

         if [info exists mom_sim_tool_number] {
            set mom_sim_tool_data($mom_sim_tool_number,carrier_id) "\"$mom_sim_tool_carrier_id\""
         }
      }

      "SPINDLE_GROUP" {
         global mom_sim_spindle_group
         set mom_sim_spindle_group "$mom_sim_msg_word"
      }

      "TOOL_POCKET_ID" {
         global mom_sim_tool_pocket_id
         set mom_sim_tool_pocket_id "$mom_sim_msg_word"

         set mom_sim_tool_data($mom_sim_tool_number,pocket_id) "\"$mom_sim_tool_pocket_id\""
      }

      "TOOL_DIAMETER" {
         global mom_sim_tool_diameter
         set mom_sim_tool_diameter "$mom_sim_msg_word"

         global mom_sim_cut_data_type
         if { [info exists mom_sim_cut_data_type] && [string match "CONTACT_CONTOUR" $mom_sim_cut_data_type] } {
            global mom_sim_contact_tracking_type
            if [string match "BOTTOM" $mom_sim_contact_tracking_type] {
               global mom_sim_tool_cutcom_offset
               set mom_sim_tool_cutcom_offset [expr $mom_sim_tool_diameter / 2]
            }
         }

         set mom_sim_tool_data($mom_sim_tool_number,diameter) $mom_sim_tool_diameter
      }

      "TOOL_CUTCOM_REG" {
         global mom_sim_tool_cutcom_register
         set mom_sim_tool_cutcom_register "$mom_sim_msg_word"

        # Register cutcom offset
         global mom_sim_tool_cutcom_offset
         global mom_sim_cutcom_register

         if ![info exists mom_sim_tool_cutcom_offset] {
            set mom_sim_tool_cutcom_offset 0.0
         }

         set mom_sim_cutcom_register($mom_sim_tool_cutcom_register) $mom_sim_tool_cutcom_offset

         set mom_sim_tool_data($mom_sim_tool_number,cutcom_register) $mom_sim_tool_cutcom_register
      }

      "TOOL_ADJUST_REG" {
         global mom_sim_tool_adjust_register
         set mom_sim_tool_adjust_register "$mom_sim_msg_word"

        # Register length offset
         global mom_sim_tool_adjust_offset
         global mom_sim_adjust_register

         if ![info exists mom_sim_tool_adjust_offset] {
            set mom_sim_tool_adjust_offset 0.0
         }

         set mom_sim_adjust_register($mom_sim_tool_adjust_register) $mom_sim_tool_adjust_offset

         set mom_sim_tool_data($mom_sim_tool_number,adjust_register) $mom_sim_tool_adjust_register
      }

      "HEAD_NAME" {
         global mom_sim_machine_head
         set mom_sim_machine_head "$mom_sim_msg_word"
      }

      "POST_NAME" {
         global mom_sim_post_name
         global mom_sim_vnc_handler_loaded

         set mom_sim_post_name "$mom_sim_msg_word"

         set new_vnc_file [string trim ${mom_sim_post_name}_vnc.tcl]
         set new_vnc_file [join [split $new_vnc_file \\] /]

         if { [string compare [string trim $mom_sim_vnc_handler_loaded] $new_vnc_file] } {
            uplevel #0 {
               source ${mom_sim_post_name}_vnc.tcl
            }

            PB_SIM_call PB_CMD_vnc__init_sim_vars
         }
      }

      "CYCLE_SPINDLE_AXIS" {
         global mom_sim_cycle_spindle_axis
         set mom_sim_cycle_spindle_axis "$mom_sim_msg_word"
      }

      "CSYS_FIXTURE_OFFSET" {
         global mom_sim_fixture_offset
         set mom_sim_fixture_offset "$mom_sim_msg_word"
      }

      default {
      }
   }


  # Grab CSYS_MTX_'s
   global mom_sim_csys_matrix mom_sim_csys_set
   global mom_sim_csys_data

   global mom_sim_fixture_offset
   if ![info exists mom_sim_fixture_offset] {
      set mom_sim_fixture_offset 0
   }


   if [string match "CSYS_MTX_*" $mom_sim_msg_key] {
      set tokens [split $mom_sim_msg_key _]
      set idx [lindex $tokens 2]

      set mom_sim_csys_matrix($idx) "$mom_sim_msg_word"

     # Store CSYS matrix
      set mom_sim_csys_data($mom_sim_fixture_offset,$idx) "$mom_sim_msg_word"

     # When csys is completely defined, map and set ZCS junction for simulation.
      if { $idx == 11 } {
         PB_SIM_call PB_CMD_vnc__set_kinematics
         set mom_sim_csys_set 1

        # Signal a new CSYS is set
         global mom_sim_csys_origin_initial
         set mom_sim_csys_origin_initial 1
      }
   }


  # Grab NURBS data
   global mom_sim_nurbs_start
   global mom_sim_nurbs_order
   global mom_sim_nurbs_knot_count
   global mom_sim_nurbs_knots
   global mom_sim_nurbs_point_count
   global mom_sim_nurbs_points
   global mom_sim_nurbs_point_end_index

   if [string match "NURBS_START" $mom_sim_msg_key] {
      set mom_sim_nurbs_start 0
   }

   if [string match "NURBS_ORDER" $mom_sim_msg_key] {
      set mom_sim_nurbs_order $mom_sim_msg_word
   }

   if [string match "NURBS_KNOT_COUNT" $mom_sim_msg_key] {
      set mom_sim_nurbs_knot_count $mom_sim_msg_word
      set mom_sim_nurbs_knots [list]
   }

   if [string match "NURBS_POINT_COUNT" $mom_sim_msg_key] {
      set mom_sim_nurbs_point_count $mom_sim_msg_word
      set mom_sim_nurbs_points [list]
      set mom_sim_nurbs_point_end_index [expr $mom_sim_nurbs_point_count - 1]
   }

   if [string match "NURBS_KNOTS*" $mom_sim_msg_key] {
      lappend mom_sim_nurbs_knots $mom_sim_msg_word
   }

  # Info of control points is the last set of parameters passed from a NURBS event.
  # (See PB_CMD_vnc__pass_nurbs_data)
  #
   if [string match "NURBS_POINTS*" $mom_sim_msg_key] {
      lappend mom_sim_nurbs_points $mom_sim_msg_word

     # When the control points list is completed, set off simulation.
      if [string match "*($mom_sim_nurbs_point_end_index,Z)*" $mom_sim_msg_key] {
         global mom_sim_nc_register
         set mom_sim_nc_register(MOTION) NURBS

         set mom_sim_nurbs_start 1
         PB_SIM_call PB_CMD_vnc__sim_motion

         unset mom_sim_nurbs_start
      }
   }

  # Nullify msg key
   set mom_sim_msg_key ""
   set mom_sim_msg_word ""
}


#=============================================================
proc PB_CMD_vnc__set_speed { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_spindle_speed mom_sim_spindle_mode
  global mom_sim_spindle_max_rpm
  global mom_sim_primary_channel
  global mom_sim_tool_carrier_id

  global mom_carrier_name


   set spindle_speed $mom_sim_nc_register(S)
   set spindle_mode  $mom_sim_nc_register(SPINDLE_MODE)

   if [expr $mom_sim_nc_register(S) <= 0.0] {
      if [expr $mom_sim_spindle_speed > 0.0] {
         set spindle_speed $mom_sim_spindle_speed
      } else {
         set spindle_speed $mom_sim_spindle_max_rpm
         set spindle_mode  "REV_PER_MIN"
      }
   }


  # Set primary channel
   set primary_channel_set 0

   if [info exists mom_sim_primary_channel] {
      if { $spindle_mode != "REV_PER_MIN"  ||  $mom_sim_nc_register(MACHINE_MODE) == "TURN" } {

         if [info exists mom_sim_tool_carrier_id] {

            if [expr $mom_sim_tool_carrier_id != $mom_carrier_name] {
               set mom_sim_tool_carrier_id $mom_carrier_name
            }

            if { $mom_sim_primary_channel == $mom_sim_tool_carrier_id } {
               PB_SIM_call SIM_primary_channel $mom_sim_primary_channel
               set primary_channel_set 1
            }
         }
      }
   }


  # Set max spindle rpm
   if $primary_channel_set {
      if [EQ_is_gt $mom_sim_spindle_max_rpm 0] {

         if { $mom_sim_nc_register(MACHINE_MODE) == "TURN" } {
            if { $spindle_mode == "REV_PER_MIN" } {
               if [EQ_is_gt $spindle_speed $mom_sim_spindle_max_rpm] {
                  set spindle_speed $mom_sim_spindle_max_rpm
               }
            }
            PB_SIM_call SIM_set_max_spindle_speed $mom_sim_spindle_max_rpm "REV_PER_MIN"
         }
      }
   }


  # Pass on spindle data
   set mom_sim_spindle_mode  $spindle_mode
   set mom_sim_spindle_speed $spindle_speed

   if [string match "REV_PER_MIN" $spindle_mode] {

      switch "$mom_sim_nc_register(MACHINE_MODE)" {
         "MILL" {
            PB_SIM_call SIM_set_speed $spindle_speed $spindle_mode
         }
         "TURN" {
            if $primary_channel_set {
               PB_SIM_call SIM_set_spindle_speed $spindle_speed $spindle_mode
            }
         }
      }

   } else {

      if $primary_channel_set {
         if [string match "SFM" $spindle_mode] { 
            PB_SIM_call SIM_set_surface_speed $spindle_speed "FEET_PER_MIN"
            set mom_sim_spindle_mode "FEET_PER_MIN"
         } else {
            PB_SIM_call SIM_set_surface_speed $spindle_speed "M_PER_MIN"
            set mom_sim_spindle_mode "M_PER_MIN"
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__sim_motion { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nurbs_start


  # Initialize ref csys just incase.
   global mom_sim_csys_set
   if !$mom_sim_csys_set {
      PB_SIM_call PB_CMD_vnc__set_kinematics
      set mom_sim_csys_set 1
   }


  # Disable simulation when a NURBS definition starts.
   if { [info exists mom_sim_nurbs_start] && !$mom_sim_nurbs_start } {
return
   }

  # Set feed & speed
   PB_SIM_call PB_CMD_vnc__set_feed
   PB_SIM_call PB_CMD_vnc__set_speed


  # We'll simulate the sub-spindle movements with different codes.
   if $mom_sim_nc_register(CROSS_MACHINING) {
return
   }


global mom_sim_o_buffer
global mom_sim_message
set mom_sim_message "** $mom_sim_nc_register(MOTION) -- $mom_sim_o_buffer **"
PB_CMD_vnc__send_message


  # Reset start position for next motion after a fixture offset transformation is applied.
   if [info exists mom_sim_nc_register(FIXTURE_OFFSET)] {

      if { ![catch {set ref_pt [PB_SIM_call SIM_ask_last_position_zcs]} ] } {
         global mom_sim_prev_pos
         set mom_sim_prev_pos(0) [lindex $ref_pt 0]
         set mom_sim_prev_pos(1) [lindex $ref_pt 1]
         set mom_sim_prev_pos(2) [lindex $ref_pt 2]
      }

      unset mom_sim_nc_register(FIXTURE_OFFSET)
   }


  # Ready parameters for polar mode simulation
   PB_SIM_call PB_CMD_vnc__start_polar_motion


  # Create a temp jct for subsequent moves incase the tool is not set properly.
   PB_SIM_call VNC_create_tmp_jct

   switch $mom_sim_nc_register(MOTION) {
      "RAPID" {
         PB_SIM_call VNC_rapid_move
      }

      "LINEAR" {
         PB_SIM_call VNC_linear_move
      }

      "CIRCULAR_CLW" {
         PB_SIM_call VNC_circular_move CLW
      }

      "CIRCULAR_CCLW" {
         PB_SIM_call VNC_circular_move CCLW
      }

      "NURBS" {
         if $mom_sim_nurbs_start {
            PB_SIM_call VNC_nurbs_move
         }
      }
   }

   if [string match "CYCLE_*" $mom_sim_nc_register(MOTION)] {
      PB_SIM_call VNC_cycle_move
   }


  # Restore parameters after polar mode simulation
   PB_SIM_call PB_CMD_vnc__end_polar_motion
}


#=============================================================
proc PB_CMD_vnc__start_of_path { } {
#=============================================================

  # Pass contact contour information.
   PB_SIM_call PB_CMD_vnc__pass_contact_contour_data

  # Redefine MOM_helix_move & pass info to VNC.
   if { [llength [info commands "MOM_SYS_helix_move"]] == 0 } {
      if [llength [info commands "MOM_helix_move"]] {
         rename MOM_helix_move MOM_SYS_helix_move

         uplevel #0 {

            proc MOM_helix_move {} {
               PB_SIM_call PB_CMD_vnc__pass_helix_pitch
               MOM_SYS_helix_move
            }
         }

        # Fetch global pitch info
         PB_SIM_call PB_CMD_vnc__pass_helix_data
      }
   }


  # Redefine MOM_nurbs_move & pass info to VNC.
   if { [llength [info commands "MOM_SYS_nurbs_move"]] == 0 } {
      if [llength [info commands "MOM_nurbs_move"]] {

         rename MOM_nurbs_move MOM_SYS_nurbs_move

         uplevel #0 {

            proc MOM_nurbs_move {} {

               PB_SIM_call PB_CMD_vnc__pass_nurbs_start

               MOM_SYS_nurbs_move

               PB_SIM_call PB_CMD_vnc__pass_nurbs_data
            }
         }
      }
   }

  # Set machining mode
   global mom_sim_vnc_msg_only
   global mom_sim_nc_register
   if { ![info exists mom_sim_vnc_msg_only] || !$mom_sim_vnc_msg_only } {
      PB_SIM_call SIM_set_machining_mode $mom_sim_nc_register(MACHINE_MODE)
   }


  # Pass tool carrier data
   PB_SIM_call PB_CMD_vnc__pass_tool_carrier_data


  # For multi-channel simulation, assign channel to a lathe spindle currently under control.
   global mom_multi_channel_mode mom_sim_tool_carrier_id
   if { [info exists mom_multi_channel_mode] && [info exists mom_sim_tool_carrier_id] } {

      global mom_sim_result mom_sim_result1

      PB_SIM_call SIM_ask_nc_axes_of_mtool

      foreach axis $mom_sim_result1 {

         PB_SIM_call SIM_ask_comp_from_dof $axis
         set kcomp $mom_sim_result

         set mom_sim_result 0
         PB_SIM_call SIM_is_component_of_system_class $kcomp _LATHE_SPINDLE

         if { $mom_sim_result == 1 } {
            PB_SIM_call SIM_assign_channel_to_spindle $mom_sim_tool_carrier_id $kcomp
          break
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__start_of_program { } {
#=============================================================
   global mom_multi_channel_mode


  # This command is only executed during simulation
  # Extended NC output should be disabled.
   global mom_sim_output_extended_nc
   if [info exists mom_sim_output_extended_nc] {
      unset mom_sim_output_extended_nc
   }


   if [info exists mom_multi_channel_mode] {

     # Fetch total number of channels
      global mom_sim_number_of_channels
      global mom_sim_result

      set mom_sim_number_of_channels 0
      set mom_sim_result 0

      PB_SIM_call SIM_ask_number_of_channels

      if { $mom_sim_result > 0 } {
         set mom_sim_number_of_channels $mom_sim_result
      } else {
         global mom_sim_turret_carriers
         if [info exists mom_sim_turret_carriers] {
           # This will work only if carriers have been named with integers!
            set mom_sim_number_of_channels [lindex [lsort -integer $mom_sim_turret_carriers] end]
         } else {
            set msg "Variable \"mom_sim_turret_carriers\" is not defined to construct channels dialog!"
            VNC_pause $msg
            catch { SIM_mtd_reset }
return EXIT
         }
      }


     # Set up sync manager dialog
      PB_SIM_call PB_CMD_vnc__config_sync_dialog


     # Initialize parameters for Sync Manager
      if [llength [info commands "PB_CMD_vnc__init_sync_manager"]] {
         PB_SIM_call PB_CMD_vnc__init_sync_manager
      } else {
         PB_SIM_call PB_CMD_vnc____init_sync_manager
      }

     # Flag sync manager initialized.
      global mom_sim_sync_manager_initialized
      set mom_sim_sync_manager_initialized 1

   } else {

     # Customize regular ISV dialog
      PB_SIM_call PB_CMD_vnc__customize_dialog
   }


  # Mount part on sub-spindle
   PB_SIM_call PB_CMD_vnc__mount_part


  # Add workpiece transfer handlers
   PB_SIM_call PB_CMD_vnc__add_workpiece_transfer_handlers
}


#=============================================================
proc PB_CMD_vnc__start_polar_motion { } {
#=============================================================
# This function alters motion's sim positions for polar simulation.
# Polar mode should have been initiated when certain N/C code
# has been encounterred.
#
   global mom_sim_polar_mode

   if { [info exists mom_sim_polar_mode] && $mom_sim_polar_mode == 1 } {

      global mom_sim_pos
      global mom_sim_current_x mom_sim_current_c
      global mom_sim_PI

     # Preserve current X & C values
      set mom_sim_current_x $mom_sim_pos(0)
      set mom_sim_current_c $mom_sim_pos(4)

     # Compute target X pos (rise)
      set mom_sim_pos(0) [expr sqrt($mom_sim_pos(0)*$mom_sim_pos(0) + $mom_sim_pos(4)*$mom_sim_pos(4))]

     # Compute target angle
      set theta [expr atan2($mom_sim_pos(4),$mom_sim_current_x)]
      set mom_sim_pos(4) [expr $theta * 180 / $mom_sim_PI]

     # Adjust target angle per previous condition
      global mom_sim_prev_polar_c
      if { [info exists mom_sim_prev_polar_c] && [expr $mom_sim_prev_polar_c > 0.0] } {
         if { ![expr $mom_sim_prev_polar_c < 180.0] && ![expr $mom_sim_pos(4) > 0.0] } {
            set mom_sim_pos(4) [expr $mom_sim_pos(4) + 360]
         }
      }
      set mom_sim_prev_polar_c $mom_sim_pos(4)

      PB_SIM_call SIM_set_linearization ON
   }
}


#=============================================================
proc PB_CMD_vnc__end_polar_motion { } {
#=============================================================
# This function restores motion's sim positions after a
# polarized motion is simulated.
#
   global mom_sim_polar_mode

   if { [info exists mom_sim_polar_mode] && $mom_sim_polar_mode == 1 } {

     global mom_sim_pos
     global mom_sim_current_x mom_sim_current_c

     PB_SIM_call SIM_set_linearization OFF

     set mom_sim_pos(0) $mom_sim_current_x
     set mom_sim_pos(4) $mom_sim_current_c
   }
}


#=============================================================
proc PB_CMD_vnc__pass_head_data { } {
#=============================================================
  global mom_sys_postname
  global CURRENT_HEAD
  global mom_sim_message
  global mom_sys_sim_post_name


   set mom_sim_message "HEAD_NAME==$CURRENT_HEAD"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   global tcl_platform
   if [string match "*windows*" $tcl_platform(platform)] {
      regsub -all {\\} $mom_sys_sim_post_name {/} post_file
   } else {
      set post_file $mom_sys_sim_post_name
   }
   set mom_sim_message "POST_NAME==$post_file"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg
}


#=============================================================
proc PB_CMD_vnc__tool_change { } {
#=============================================================
  global sim_prev_tool_name
  global mom_sim_result mom_sim_result1
  global mom_sim_ug_tool_name
  global mom_sim_tool_loaded
  global mom_sim_spindle_comp mom_sim_spindle_jct
  global mom_sim_lg_axis
  global mom_sim_nc_register
  global mom_sim_machine_type
  global mom_sim_tool_offset_used mom_sim_tool_offset mom_sim_tool_mount
  global mom_sim_output_reference_method
  global mom_sim_tool_junction mom_sim_current_junction
  global mom_sim_pivot_distance
  global mom_sim_tool_change

  global mom_sim_pos mom_sim_prev_pos


  # Fetch UG tool name per tool number
   global mom_sim_address
   global mom_sim_tool_data
   global mom_sim_tool_number

   set tool_number ""
   if [info exists mom_sim_tool_number] {
      set tool_number $mom_sim_tool_number
   } elseif [info exists mom_sim_nc_register($mom_sim_address(T,leader))] {
      set tool_number $mom_sim_nc_register($mom_sim_address(T,leader))
   }

   if { $tool_number != ""  &&  [info exists mom_sim_tool_data($tool_number,name)] } {
      set mom_sim_ug_tool_name $mom_sim_tool_data($tool_number,name)
   } else {
      set mom_sim_tool_change 0
return
   }


   if [string match "$sim_prev_tool_name" $mom_sim_ug_tool_name] {
      set mom_sim_tool_change 0
return
   }


  # Allow users to use specified tool change position.
   if [llength [info commands "PB_CMD_vnc__go_to_tool_change_position"]] {

      PB_SIM_call PB_CMD_vnc__go_to_tool_change_position

   } else {
     # Fake a temporary intermediate reference point to send all dogs home
      set mom_sim_nc_register(REF_INT_PT_X) 0
      set mom_sim_nc_register(REF_INT_PT_Y) 0
      set mom_sim_nc_register(REF_INT_PT_Z) 0
      set mom_sim_nc_register(REF_INT_PT_4) 0
      set mom_sim_nc_register(REF_INT_PT_5) 0

     # Position spindle to reference point.
      PB_SIM_call PB_CMD_vnc__send_dogs_home

     # Unset temporary intermediate reference point
      unset mom_sim_nc_register(REF_INT_PT_X)
      unset mom_sim_nc_register(REF_INT_PT_Y)
      unset mom_sim_nc_register(REF_INT_PT_Z)
      unset mom_sim_nc_register(REF_INT_PT_4)
      unset mom_sim_nc_register(REF_INT_PT_5)
   }

   set sim_tool_name ""

#>>>>>
#  This is where you add detailed movements such as rotating tool changer,
#  unmounting old tool and mounting new tool and/or getting next tool in ready position.
#<<<<<

  # User provided tool change sequence
   if [llength [info commands "PB_CMD_vnc__user_tool_change"]] {

      set sim_tool_name [PB_SIM_call PB_CMD_vnc__user_tool_change]

   } elseif [llength [info commands "PB_CMD_vnc____tool_change"]] {

      set sim_tool_name [PB_SIM_call PB_CMD_vnc____tool_change]

   } else {

      global mom_sim_tool_carrier_id
      global mom_sim_turret_carriers
      global mom_sim_turret_axis
      global mom_sim_tool_pocket_id


      set done_tool_change 0

      set tool_change_time 5

     # Rotate tool turret for lathe
      if { [info exists mom_sim_tool_carrier_id] &&\
           [info exists mom_sim_tool_pocket_id] &&\
           [info exists mom_sim_turret_carriers] } {

         if { [lsearch $mom_sim_turret_carriers $mom_sim_tool_carrier_id] >= 0 } {

           # Handle mixed use of tools on a turret and stationary tools.
            if ![catch { PB_SIM_call SIM_ask_kim_comp_name_by_id "TOOL" $mom_sim_ug_tool_name }] {
               set done_tool_change 1
            }

            if $done_tool_change {
               global mom_sim_pocket_angle
               PB_SIM_call SIM_move_rotary_axis $tool_change_time $mom_sim_turret_axis($mom_sim_tool_carrier_id)\
                                                $mom_sim_pocket_angle($mom_sim_tool_carrier_id,$mom_sim_tool_pocket_id)
            }
         }
      }

     # Change tool for mills
      if { $done_tool_change == 0 } {
         PB_SIM_call VNC_unmount_tool $sim_prev_tool_name
         PB_SIM_call VNC_set_ref_jct {""}
         PB_SIM_call SIM_mount_tool $tool_change_time "UG_NAME" "$mom_sim_ug_tool_name"\
                                    "$mom_sim_spindle_comp" "$mom_sim_spindle_jct"
      }

     # Fetch tool comp ID
      set sim_tool_name $mom_sim_result 
   }


   PB_SIM_call SIM_update 

   if {$sim_tool_name != ""} {
      PB_SIM_call SIM_activate_tool $sim_tool_name
   }

   PB_SIM_call SIM_update 


   set sim_prev_tool_name $mom_sim_ug_tool_name
   set mom_sim_tool_loaded $sim_tool_name


  # Flag that a tool change is done.
   set mom_sim_tool_change 0


   PB_SIM_call VNC_set_ref_jct $sim_tool_name
 
   set mom_sim_tool_junction "$mom_sim_current_junction"


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Create a junction per tool offsets to track N/C data.
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++
   set use_tool_tip_jct 1

   if { $mom_sim_tool_data($tool_number,offset_used) || [expr $mom_sim_pivot_distance != 0.0] } {

      if { ![string match "*_wedm" $mom_sim_machine_type] } {
         if [string match "*axis*" $mom_sim_machine_type] {
            set use_tool_tip_jct 0
            set x_offset [expr -1.0 * ($mom_sim_tool_data($tool_number,z_off) + $mom_sim_pivot_distance)]
            set y_offset 0.0
            set z_offset 0.0

         } elseif [string match "*lathe*" $mom_sim_machine_type] {
            if [string match "TURRET_REF" $mom_sim_output_reference_method] {
               set use_tool_tip_jct 0
               set x_offset $mom_sim_tool_data($tool_number,x_off)
               set y_offset $mom_sim_tool_data($tool_number,y_off)
               set z_offset 0.0
            }
         }
      }
   }


   if { !$use_tool_tip_jct } {
      global mom_sim_tool_x_offset mom_sim_tool_y_offset mom_sim_tool_z_offset

      set mom_sim_tool_x_offset $x_offset
      set mom_sim_tool_y_offset $y_offset
      set mom_sim_tool_z_offset $z_offset

      PB_SIM_call PB_CMD_vnc__offset_tool_jct
   }


   if [string match "TURN" $mom_sim_nc_register(MACHINE_MODE)] {
      set mom_sim_pos(1) 0
   }

  # Reset mom_sim_prev_pos to disable unnecessary move
   for {set i 0} {$i < 5} {incr i} {
      set mom_sim_prev_pos($i) $mom_sim_pos($i)
   }
}




