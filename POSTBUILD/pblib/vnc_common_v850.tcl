########################### Virtual NC Controller ############################
#                                                                            #
# Copyright (C) 1999/2000/2001/2002/2003/2004/2005/2006/2007/2008/2009/2010/ #
#               2011                                                         #
#                                                                            #
#                           Siemens PLM Software                             #
#                                                                            #
##############################################################################
#                       V N C _ C O M M O N _ V 8 5 0 . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains handlers for incremental VNC conversion.
#
##############################################################################


#=============================================================
proc PB_CMD_vnc__G_misc_code { } {
#=============================================================
# 09-10-2013 gsl - Undid rev. pb801(e) to resolve problem with
#                  extra angular offset (pr6933463)

  global mom_sim_pos
  global mom_sim_nc_register
  global mom_sim_nc_func
  global mom_sim_wcs_offsets
  global mom_sim_csys_data

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
    lappend var_list mom_sim_nc_func(LOCAL_CS_SET)
    lappend var_list mom_sim_nc_func(WORK_CS_RESET)

   foreach var $var_list {
      if { [info exists $var] } {
         lappend codes_list [set $var]
      }
   }

   set wcs_codes_list [list]
   set wcs_list [array names mom_sim_wcs_offsets]
   set ind [lsearch $wcs_list 0]
   if { $ind >= 0 } {
      set wcs_list [lreplace $wcs_list $ind $ind]
   }

   set wcsvar_list [list]

   foreach wcs $wcs_list {
      lappend wcsvar_list mom_sim_nc_func(WORK_CS_$wcs)
   }

  # Add fixture offset codes to list to process
   foreach wcsvar $wcsvar_list {
      if { [info exists $wcsvar] } {
         lappend wcs_codes_list [set $wcsvar]
         lappend codes_list [set $wcsvar]
      }
   }

   global mom_sim_o_buffer

   # Select Work Coordinate System.
   # Each set of offsets (from Machine Zero) is entered and stored in the machine.
   # G54 is selected when powered on (?).
   # Work zero point offset value can be set in a program by G10 command (??).

   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [lsearch $wcs_codes_list $code] < 0 } {
          # Process other misc codes (non-fixture offset) -

            if { [VNC_string_match mom_sim_nc_func(DELAY_SEC) code] } {

            } elseif { [VNC_string_match mom_sim_nc_func(DELAY_REV) code] } {

            } elseif { [VNC_string_match mom_sim_nc_func(UNIT_IN) code] } {

               set mom_sim_nc_register(UNIT) IN
               PB_SIM_call SIM_set_mtd_units "INCH"

            } elseif { [VNC_string_match mom_sim_nc_func(UNIT_MM) code] } {

               set mom_sim_nc_register(UNIT) MM
               PB_SIM_call SIM_set_mtd_units "MM"

            } elseif { [VNC_string_match mom_sim_nc_func(RETURN_HOME) code] } {

              # Coord specified with this command is stored as the "intermediate point" that
              # the tool will position in rapid mode before going to the reference point.
              # Intermediate point (each axis) stays modal for future G28/G29.
              #
              # This command cancels cutcom and tool offsets.
              #
              # Axes of the "intermediate point" only exist when specified. Default it to
              # the ref. pt. will not be sufficient.
              # The int. pt. floats with respect to the active WCS (G54-59).
              # Reference point is fixed on a machine.

               set mom_sim_nc_register(RETURN_HOME) 1

              # Fetch the main home position, if any.
               global mom_sim_main_home_pos mom_sim_home_pos
               if { [info exists mom_sim_main_home_pos] } {
                  set mom_sim_home_pos(0) $mom_sim_main_home_pos(0)
                  set mom_sim_home_pos(1) $mom_sim_main_home_pos(1)
                  set mom_sim_home_pos(2) $mom_sim_main_home_pos(2)
               }

              # pb603(d) -
              # Reference point may need to be reset when there are multiple positions
              if 0 {
               lappend mom_sim_nc_register(REF_PT) $mom_sim_home_pos(0) \
                                                   $mom_sim_home_pos(1) \
                                                   $mom_sim_home_pos(2) \
                                                   0.0 0.0
              }

            } elseif { [VNC_string_match mom_sim_nc_func(RETURN_HOME_P) code] } {

              # G30 P2 XYZ -- Return to the 2nd ref pt. P2 can be omitted.
              # G30 P3 XYZ -- Return to the 3rd ref pt.
              # G30 P4 XYZ -- Return to the 4th ref pt.
              #
              # G30 & G28 share the same intermediate point. I think?.

               set mom_sim_nc_register(RETURN_HOME_P) 1

              # Save away the main home position.
              # pb502(1) - Bug! Declare mom_sim_home_pos
               global mom_sim_main_home_pos mom_sim_home_pos
               if { ![info exists mom_sim_main_home_pos] } {
                  set mom_sim_main_home_pos(0) $mom_sim_home_pos(0)
                  set mom_sim_main_home_pos(1) $mom_sim_home_pos(1)
                  set mom_sim_main_home_pos(2) $mom_sim_home_pos(2)
               }

              # Set an auxiliary home position as the target.

              # pb603(d) -
              # If a different reference point (Home) can be used,
              # mom_sim_nc_register(REF_PT) would need to be re-defined accordingly.


            } elseif { [VNC_string_match mom_sim_nc_func(FROM_HOME) code] } {

              # This command is normally issued immediately after a G28.
              #
              # Coord specified with this function is the target that the tool will position.
              # The tool will first position from the ref. pt. to the "intermediate point"
              # that have been defined in the previous G28 command, if any, in rapid mode
              # before going to its final destination.

               set mom_sim_nc_register(FROM_HOME) 1

            } elseif { [VNC_string_match mom_sim_nc_func(MACH_CS_MOVE) code] } {

              # Moves to a position in the Machine Coordinate System (MCS).
              # The origin of MCS (Machine Zero, Machine Datum) never changes.
              # One shot instruction block. Ignored in incremental mode (G91).
              # MCS is never affected by G92 or G52 (LCS) until machine is powered off.
              # (I think, guess), G53 is used in the M06 macro for the tool change.
              #
              # ** It's ignored in (G91) incremental mode!
              # ** It's a one-shot instruction!

               if { ![string compare "ABS" $mom_sim_nc_register(INPUT)] } {

                  set mom_sim_nc_register(MCS_MOVE) 1

                 # Preserve and fake the offsets. Restore them after the move.
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
                  if { [info exists mom_sim_zcs_base_MCS] } {
                     set mom_sim_zcs_base $mom_sim_zcs_base_MCS
                  }

                  PB_SIM_call PB_CMD_vnc__set_kinematics

                  global mom_sim_csys_set
                  set mom_sim_csys_set 1

                  PB_SIM_call VNC_update_sim_pos
               }

            } elseif { [VNC_string_match mom_sim_nc_func(LOCAL_CS_SET) code] } {

              # Shift all WCS. Offsets are specified.
              #
              # Specify a local coordiante system within the active work coordinate system.
              # Change of WCS or return cancels the offsets
              # G52 IP0 (i.e. 0 0 0) or G92 command also cancels this command.

               set mom_sim_nc_register(SET_LOCAL) 1

              # Defer offsets calculation until entire block is parsed.
               set mom_sim_nc_register(LOCAL_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]

            } elseif { [VNC_string_match mom_sim_nc_func(WORK_CS_RESET) code] } {

              # Disable work coord reset if S is in the block.
              # G92 is used to set max spindle speed to S register.

               global mom_sim_address
               if { [VNC_parse_nc_block mom_sim_o_buffer $mom_sim_address(S,leader)] } {
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
            }

         } else {
          # Process fixture offset code - Fetch offset data

            foreach wcs $wcs_list {
               if { [VNC_string_match mom_sim_nc_func(WORK_CS_$wcs) code] } {
                 # Set the value of nc register according to different WCS
                  set mom_sim_nc_register(WCS) $wcs

                  set mom_sim_nc_register(WORK_OFFSET)\
                      [PB_SIM_call VNC_map_to_machine_offsets $mom_sim_wcs_offsets($mom_sim_nc_register(WCS))]

                break
               }
            }
         }


         if { [info exists mom_sim_csys_data] } {

            if { [VNC_string_match mom_sim_nc_func(MACH_CS_MOVE) code] } {

            } else {

               foreach wcs $wcs_list {

                  if { [VNC_string_match mom_sim_nc_func(WORK_CS_$wcs) code] } {

                    # Zero local offsets when change WCS
                     set mom_sim_nc_register(LOCAL_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]

                   # pb801(e) - Put back rotary offsets for machines with table
                    # Zero WCS offsets, since the actual CSYS will be referenced.
                    # set mom_sim_nc_register(WORK_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]

                     global mom_sim_machine_type

                     set a4th 0.0
                     set a5th 0.0

                     if { [string match "4_axis_table"      $mom_sim_machine_type] ||\
                          [string match "5_axis_dual_table" $mom_sim_machine_type] } {

                        set a4th [lindex $mom_sim_nc_register(WORK_OFFSET) 3]
                     }

                     if { [string match "5_axis_head_table" $mom_sim_machine_type] ||\
                          [string match "5_axis_dual_table" $mom_sim_machine_type] } {

                        set a5th [lindex $mom_sim_nc_register(WORK_OFFSET) 4]
                     }

                     set mom_sim_nc_register(WORK_OFFSET) [list 0.0 0.0 0.0 $a4th $a5th]


                    # Fetch actual WCS matrix per WCS selection by G54 - G59 code.
                     global mom_sim_csys_matrix

                     for { set i 0 } { $i < 12 } { incr i } {
                        set mom_sim_csys_matrix($i) $mom_sim_csys_data($mom_sim_nc_register(WCS),$i)
                     }

                    # When fixture offsets contain angular offset, set ZCS reference to rotary table
                     if { ![EQ_is_zero $a4th] || ![EQ_is_zero $a5th] } {
                        global mom_sim_zcs_base
                        global mom_sim_zcs_base_LCS

                        if { [info exists mom_sim_zcs_base_LCS] && ![string match "" [string trim $mom_sim_zcs_base_LCS]] } {
                           set mom_sim_zcs_base $mom_sim_zcs_base_LCS
                        }

                     } else {

                       # Flag to reset (adjust) the start position in next motion. (See PB_CMD_vnc__sim_motion)
                        set mom_sim_nc_register(FIXTURE_OFFSET) 1
                     }

                    # pb901(c) - Rev. pb801(e) above may not be robust that has caused extra rotation
                     set mom_sim_nc_register(WORK_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]

                     PB_SIM_call PB_CMD_vnc__set_kinematics

                     global mom_sim_csys_set
                     set mom_sim_csys_set 1

                    # Update mom_sim_pos w.r.t new ref jct
                     PB_SIM_call VNC_update_sim_pos

                   break
                  }
               }
            }
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__cycle_move { } {
#=============================================================
  global mom_sim_lg_axis
  global mom_sim_pos mom_sim_prev_pos
  global mom_sim_cycle_rapid_to_pos
  global mom_sim_cycle_feed_to_pos
  global mom_sim_cycle_retract_to_pos
  global mom_sim_cycle_mode
  global mom_sim_nc_register


   set mom_sim_pos(0) $mom_sim_prev_pos(0)
   set mom_sim_pos(1) $mom_sim_prev_pos(1)
   set mom_sim_pos(2) $mom_sim_prev_pos(2)


   if { $mom_sim_cycle_mode(start_block) } {

     global mom_sim_cycle_spindle_axis
     global mom_sim_cycle_rapid_to_dist
     global mom_sim_cycle_feed_to_dist
     global mom_sim_cycle_retract_to_dist
     global mom_sim_cycle_entry_pos

      set rapid_to_pos(0) $mom_sim_nc_register(X)
      set rapid_to_pos(1) $mom_sim_nc_register(Y)
      set rapid_to_pos(2) $mom_sim_nc_register(Z)

      if { [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) > $rapid_to_pos($mom_sim_cycle_spindle_axis)] } {
         set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) $rapid_to_pos($mom_sim_cycle_spindle_axis)
      }

      set rapid_to_pos($mom_sim_cycle_spindle_axis)  $mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis)

      if { [string match "*R -*" $mom_sim_cycle_mode(rapid_to)] } {
         if { [string match "*Distance*" $mom_sim_cycle_mode(rapid_to)] } {
            set rapid_to_pos($mom_sim_cycle_spindle_axis) \
                [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_rapid_to_dist]
         }
      }
      set mom_sim_cycle_rapid_to_pos(0) $rapid_to_pos(0)
      set mom_sim_cycle_rapid_to_pos(1) $rapid_to_pos(1)
      set mom_sim_cycle_rapid_to_pos(2) $rapid_to_pos(2)

      set feed_to_pos(0) $mom_sim_nc_register(X)
      set feed_to_pos(1) $mom_sim_nc_register(Y)
      set feed_to_pos(2) $mom_sim_nc_register(Z)
      set feed_to_pos($mom_sim_cycle_spindle_axis)  $mom_sim_cycle_feed_to_pos($mom_sim_cycle_spindle_axis)

      switch $mom_sim_cycle_mode(feed_to) {
         "Distance" {
            set feed_to_pos($mom_sim_cycle_spindle_axis) \
                [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) - $mom_sim_cycle_feed_to_dist]
         }
      }
      set mom_sim_cycle_feed_to_pos(0) $feed_to_pos(0)
      set mom_sim_cycle_feed_to_pos(1) $feed_to_pos(1)
      set mom_sim_cycle_feed_to_pos(2) $feed_to_pos(2)

      set retract_to_pos(0) $mom_sim_nc_register(X)
      set retract_to_pos(1) $mom_sim_nc_register(Y)
      set retract_to_pos(2) $mom_sim_nc_register(Z)
      set retract_to_pos($mom_sim_cycle_spindle_axis)  $mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis)

      if { [string match "K -*" $mom_sim_cycle_mode(retract_to)] } {
         if { [string match "*Distance*" $mom_sim_cycle_mode(retract_to)] } {
            set retract_to_pos($mom_sim_cycle_spindle_axis) \
                [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_retract_to_dist]
         }
      }
      set mom_sim_cycle_retract_to_pos(0) $retract_to_pos(0)
      set mom_sim_cycle_retract_to_pos(1) $retract_to_pos(1)
      set mom_sim_cycle_retract_to_pos(2) $retract_to_pos(2)
   }

  # Preserve current position & motion type
   for { set i 0 } { $i < 3 } { incr i } {
      set sim_pos_save($i) $mom_sim_pos($i)
   }
   set sim_motion_type_save $mom_sim_nc_register(MOTION)


  # pb750(c) - Retain current last position
   set last_x $mom_sim_nc_register(LAST_X)
   set last_y $mom_sim_nc_register(LAST_Y)
   set last_z $mom_sim_nc_register(LAST_Z)


  # Clear off rotary move, if any, @ current pos
  #
   global mom_sim_cycle_spindle_axis

  # pb750(i) -
  # pb750(d) - Handle retract-to of "G98/G99" mode properly
   if { [string match "*CYCLE_RETURN_AUTO" $mom_sim_cycle_mode(retract_to)] } {
      set mom_sim_pos($mom_sim_cycle_spindle_axis) $mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis)
   }

  # To prevent premature Z move
   foreach i {0 1 2} {
     if { $i != $mom_sim_cycle_spindle_axis } {
        set mom_sim_pos($i) $mom_sim_cycle_rapid_to_pos($i)
     }
   }


  # pb752(a) - Speed up rapid-to move in cycle
   set mom_sim_nc_register(MOTION) RAPID
   PB_SIM_call VNC_set_feedrate_mode RAPID


  # pb750(i) -
   PB_SIM_call VNC_rapid_move


  #----------
  # Rapid to
    set mom_sim_pos(0) $mom_sim_cycle_rapid_to_pos(0)
    set mom_sim_pos(1) $mom_sim_cycle_rapid_to_pos(1)
    set mom_sim_pos(2) $mom_sim_cycle_rapid_to_pos(2)

  # pb752(a) - Restore next move to linear move (@ high feedrate)
  # pb750(i) -
   PB_SIM_call VNC_linear_move


  # pb752(a) - Restore cut feed
   set mom_sim_nc_register(MOTION) LINEAR
   PB_SIM_call VNC_set_feedrate_mode CUT


  #---------
  # Feed to
    set mom_sim_pos(0) $mom_sim_cycle_feed_to_pos(0)
    set mom_sim_pos(1) $mom_sim_cycle_feed_to_pos(1)
    set mom_sim_pos(2) $mom_sim_cycle_feed_to_pos(2)

   PB_SIM_call VNC_linear_move


  #------------
  # Retract to
  # pb903(c) - Speed up retract-to in 2 moves
    set mom_sim_pos(0) $mom_sim_cycle_rapid_to_pos(0)
    set mom_sim_pos(1) $mom_sim_cycle_rapid_to_pos(1)
    set mom_sim_pos(2) $mom_sim_cycle_rapid_to_pos(2)

   PB_SIM_call VNC_linear_move

   set mom_sim_nc_register(MOTION) RAPID
   PB_SIM_call VNC_set_feedrate_mode RAPID
    set mom_sim_pos(0) $mom_sim_cycle_retract_to_pos(0)
    set mom_sim_pos(1) $mom_sim_cycle_retract_to_pos(1)
    set mom_sim_pos(2) $mom_sim_cycle_retract_to_pos(2)

   PB_SIM_call VNC_linear_move


  # pb801(h) - Undo change below
  # pb750(i) - This perhaps should only be done @ cycle-off
  # Restore registers back to entry (or reference) pos of the cycle.
   global mom_sim_cycle_spindle_axis
   set mom_sim_pos($mom_sim_cycle_spindle_axis) $sim_pos_save($mom_sim_cycle_spindle_axis)

  # Restore last position
   set mom_sim_nc_register(LAST_X) $last_x
   set mom_sim_nc_register(LAST_Y) $last_y
   set mom_sim_nc_register(LAST_Z) $last_z

  # Restore motion type
   set mom_sim_nc_register(MOTION) $sim_motion_type_save
}


#=============================================================
proc PB_CMD_vnc__define_misc_procs { } {
#=============================================================
# This command defines utilities used by other VNC handlers.
#
# ==> Commands defined here are subject to future enhancements and/or changes;
#     users' own commands should be defined in PB_CMD_vnc__define_user_misc_procs.
#

 uplevel #0 {

  # pb903(b) - New
  #-----------------------------------------------------------
  proc VEC3_find_principal_angle { VEC plane } {
  #-----------------------------------------------------------
  # Compute angle of a vector w.r.t a given principal plane.
  # It returns angle in degrees.
  #
  #  Input:
  #    VEC   = Name of vector of 3
  #    plane = XY, YZ, ZX or a plane's normal vector
  #
  #  Return:
  #    Included angle in degrees
  #
  # Jan 24, 2013 gsl -
  #
     upvar $VEC u

     VEC3_unitize u v

    # Assign principal plane axis vector
     switch $plane {
        XY {
          # set p(0) 0.0;  set p(1) 0.0;  set p(2) 1.0
           set r1 $v(2);  set r2 $v(0);  set r3 $v(1)
        }
        YZ {
          # set p(0) 1.0;  set p(1) 0.0;  set p(2) 0.0
           set r1 $v(0);  set r2 $v(1);  set r3 $v(2)
        }
        ZX {
          # set p(0) 0.0;  set p(1) 1.0;  set p(2) 0.0
           set r1 $v(1);  set r2 $v(2);  set r3 $v(0)
        }
        default {
          upvar $plane p
           if [array exists p] {
              VEC3_unitize p p1
              return [expr { 90.0 - $::RAD2DEG * acos([VEC3_dot v p1]) }]
           } else {
              return ""
           }
        }
     }

     if { $plane == "XY" || $plane == "YZ" || $plane == "ZX" } {
        return [expr { $::RAD2DEG*atan2($r1,[expr sqrt($r2*$r2 + $r3*$r3)]) }]
     }
  }

  # pb603(f) - New
  #-----------------------------------------------------------
  proc VNC_move_machine_linear_axis { axis to_coord args } {
  #-----------------------------------------------------------
  #  axis     : Name of axis in machine model
  #  to_coord : Target position in axis-coordinate
  #  args     : optional feed rate (IPM or MMPM) if specified
  #
     global mom_sim_result mom_sim_rapid_feed_rate


     if { [info exists mom_sim_result] } {
        set __sim_result $mom_sim_result
     }

     SIM_ask_axis_position $axis
     set fr_coord $mom_sim_result

     set delta [expr abs($to_coord - $fr_coord)]

     if { ![EQ_is_zero $delta] } {

        if { [llength $args] == 0 } {
           set feed $mom_sim_rapid_feed_rate
        } else {
           set feed_fpm [lindex $args 0]
           set feed [expr $feed_fpm > $mom_sim_rapid_feed_rate ? $mom_sim_rapid_feed_rate : $feed_fpm]
        }

        if { ![EQ_is_zero $feed] } {
           set time [expr 60.0 * abs($delta / $feed)]
        } else {
           set time 10
        }

        PB_SIM_call SIM_move_linear_axis $time $axis $to_coord
     }

     if { [info exists __sim_result] } {
        set mom_sim_result $__sim_result
     } else {
        unset mom_sim_result
     }
  }

  # pb603(f) - New
  #-----------------------------------------------------------
  proc VNC_move_machine_rotary_axis { axis to_coord args } {
  #-----------------------------------------------------------
  #  axis     : Name of axis in machine model
  #  to_coord : Target position in axis-coordinate
  #  args     : optional feed rate (DPM) if specified
  #
     global mom_sim_result mom_sim_max_dpm


     if { [info exists mom_sim_result] } {
        set __sim_result $mom_sim_result
     }

     SIM_ask_axis_position $axis
     set fr_coord $mom_sim_result

     set delta [expr abs($to_coord - $fr_coord)]

     if { ![EQ_is_zero $delta] } {

        if { [llength $args] == 0 } {
           set feed $mom_sim_max_dpm
        } else {
           set feed_dpm [lindex $args 0]
           set feed [expr $feed_dpm > $mom_sim_max_dpm ? $mom_sim_max_dpm : $feed_dpm]
        }

        if { ![EQ_is_zero $feed] } {
           set time [expr 60.0 * abs($delta / $feed)]
        } else {
           set time 10
        }

        PB_SIM_call SIM_move_rotary_axis $time $axis $to_coord
     }

     if { [info exists __sim_result] } {
        set mom_sim_result $__sim_result
     } else {
        unset mom_sim_result
     }
  }

  #-----------------------------------------------------------
  proc VNC_output_vnc_msg { message } {
  #-----------------------------------------------------------
     global mom_sim_message

     set mom_sim_message $message
     PB_SIM_call PB_CMD_vnc__output_vnc_msg
  }

  #-----------------------------------------------------------
  proc VNC_rotate_head_spindle_axis { degrees } {
  #-----------------------------------------------------------
  # This command rotates the head spindle axis.
  # - Existence of the axis can be interrogated from the kin model per
  #   componemt classified as _DEVICE_HOLDER_ON_HEAD

     global mom_sim_head_spindle_axis

     PB_SIM_call PB_CMD_vnc__ask_head_spindle_axis

     if { [info exists mom_sim_head_spindle_axis] } {
        PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_head_spindle_axis $degrees
        PB_SIM_call SIM_update
     }
  }

  #-----------------------------------------------------------
  proc VNC_string_match { STR TKN } {
  #-----------------------------------------------------------
  # Match 2 string if they both exist
  #
     upvar $STR str
     upvar $TKN tkn

     if { [info exists str] && [info exists tkn] && [string match "$str" "$tkn"] } {
  return 1
     } else {
  return 0
     }
  }


 if { [llength [info commands "EXEC"]] == 0 } {
  # pb752(c) - Define this command only when absent -

  #-----------------------------------------------------------
  proc EXEC { command_string {__wait 1} } {
  #-----------------------------------------------------------
  # This command can be used in place of the intrinsic Tcl "exec" command
  # of which some problems have been reported under Win64 O/S and multi-core
  # processors environment.
  #
  #
  # Input:
  #   command_string -- command string
  #   __wait         -- optional flag
  #                     1 (default)   = Caller will wait until execution is complete.
  #                     0 (specified) = Caller will not wait.
  # 
  # Return:
  #   Results of execution
  #
  #
  # Revisions:
  #-----------
  # 05-19-10 gsl - Initial implementation
  #

   global tcl_platform


   if { $__wait } {

      if { [string match "windows" $tcl_platform(platform)] } {

         global env mom_logname

        # Create a temporary file to collect output
         set result_file "$env(TEMP)/${mom_logname}__EXEC_[clock clicks].out"

        # Clean up existing file
         regsub -all {\\} $result_file {/}  result_file
        #regsub -all { }  $result_file {\ } result_file

         if { [file exists "$result_file"] } {
            file delete -force "$result_file"
         }

         set cmd [concat exec $command_string > \"$result_file\"]
         regsub -all {\\} $cmd {\\\\} cmd

         eval $cmd

        # Return results & clean up temporary file
         if { [file exists "$result_file"] } {
            set fid [open "$result_file" r]
            set result [read $fid]
            close $fid

            file delete -force "$result_file"

           return $result
         }

      } else {

         set cmd [concat exec $command_string]

        return [eval $cmd]
      }

   } else {

      if { [string match "windows" $tcl_platform(platform)] } {

         set cmd [concat exec $command_string &]
         regsub -all {\\} $cmd {\\\\} cmd

        return [eval $cmd]

      } else {

        return [exec $command_string &]
      }
   }
  }
 } ;# if


  #-----------------------------------------------------------
  proc VNC_pause { args } {
  #-----------------------------------------------------------
  # Revisions:
  #-----------
  # 07-16-10 gsl - Implemented with EXEC command
  #

   global env
   if { [info exists env(PB_SUPPRESS_UGPOST_DEBUG)]  &&  $env(PB_SUPPRESS_UGPOST_DEBUG) == 1 } {
  return
   }


   global gPB
   if { [info exists gPB(PB_disable_VNC_pause)]  &&  $gPB(PB_disable_VNC_pause) == 1 } {
  return
   }


   global tcl_platform

   set cam_aux_dir  [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]

   if { [string match "*windows*" $tcl_platform(platform)] } {
      set ug_wish "ugwish.exe"
   } else {
      set ug_wish ugwish
   }

   if { [file exists ${cam_aux_dir}$ug_wish]  &&  [file exists ${cam_aux_dir}mom_pause.tcl] } {

      set title ""
      set msg ""

      if { [llength $args] == 1 } {
         set msg [lindex $args 0]
      }

      if { [llength $args] > 1 } {
         set title [lindex $args 0]
         set msg [lindex $args 1]
      }

      set command_string [concat \"${cam_aux_dir}$ug_wish\" \"${cam_aux_dir}mom_pause.tcl\" \"$title\" \"$msg\"]

      set res [EXEC $command_string]


      switch [string trim $res] {
         no {
            set gPB(PB_disable_VNC_pause) 1
         }
         cancel {
            set gPB(PB_disable_VNC_pause) 1
            PB_SIM_call SIM_mtd_reset

            uplevel #0 {
               MOM_abort "*** User Abort Simulation ***"
            }
         }
         default {
            return 
         }
      }
   }
  }

  #-----------------------------------------------------------
  proc VNC_escape_special_chars { s1 } {
  #-----------------------------------------------------------
  # This command is used to preprocess block buffer.
  #
   set s2 ""

   set len [string length $s1]
   for { set i 0 } { $i < $len } { incr i } {

      set c [string index $s1 $i]
      scan "$c" "%c" cv

     # Octal ASCII codes
      #  " = 042
      #  $ = 044
      #  & = 046
      #  ; = 073
      #  [ = 133
      #  \ = 134
      #  ] = 135
      #  { = 173
      #  | = 174
      #  } = 175

     # Do not escape the surrounding quotes, if any.
      if { $i == 0 || $i == [expr $len - 1] } {
         if { $cv == 042 } {
            set s2 "$s2$c"
            continue
         }
      }

      if { $cv == 042  || \
           $cv == 044  || \
           $cv == 046  || \
           $cv == 073  || \
           $cv == 0133 || \
           $cv == 0134 || \
           $cv == 0135 || \
           $cv == 0173 || \
           $cv == 0174 || \
           $cv == 0175 } {

        # Add an escape char
         set s2 "$s2\\"
      }

      set s2 "$s2$c"
   }

  return $s2
  }

  #-----------------------------------------------------------
  proc VNC_update_sim_pos { } {
  #-----------------------------------------------------------
   global mom_sim_pos

   if { ![catch {set pos [PB_SIM_call SIM_ask_last_position_zcs]} ] } {
      set mom_sim_pos(0) [lindex $pos 0]
      set mom_sim_pos(1) [lindex $pos 1]
      set mom_sim_pos(2) [lindex $pos 2]
   }
  }

  #-----------------------------------------------------------
  proc VNC_set_current_ref_junction { ref_jct } {
  #-----------------------------------------------------------

   PB_SIM_call SIM_set_current_ref_junction $ref_jct

   global mom_sim_current_junction

   if { [info exists mom_sim_current_junction] } {
      VNC_update_sim_pos
   }
  }

  #-----------------------------------------------------------
  proc VNC_unset_procs { args } {
  #-----------------------------------------------------------

     if { [llength $args] == 0 } {
  return
     }

     foreach p $args {
        if { [llength [info commands [string trim $p] ] ] } {
           rename $p ""
        }
     }
  }

  #-----------------------------------------------------------
  proc VNC_unset_vars { args } {
  #-----------------------------------------------------------

     if { [llength $args] == 0 } {
  return
     }

     foreach VAR $args {
        upvar $VAR var

        global tcl_version

        if { [array exists var] } {
           if { [expr $tcl_version < 8.4] } {
              foreach a [array names var] {
                 if { [info exists var($a)] } {
                    unset var($a)
                 }
              }
              unset var
           } else {
              array unset var
           }
        }

        if { [info exists var] } {
           unset var
        }
     }
  }

  #-----------------------------------------------------------
  proc VNC_info { args } {
  #-----------------------------------------------------------
     if { [llength $args] > 0 } {
        set msg "VNC >>> [lindex $args 0]"
     } else {
        set msg ""
     }
     MOM_output_to_listing_device $msg
  }

  #-----------------------------------------------------------
  proc VNC_parse_nc_word { O_BUFF word flag args } {
  #-----------------------------------------------------------
  # - Reduce buffer & execute callback only
  #   when the requested type of match is found.
  #
  #   Arguments -
  #
  #     BUFFER  : Reference (pointer) to the block buffer
  #               (Normally you pass in "mom_sim_o_buffer" without "$" sign.)
  #               ** At this point, the block sequence number
  #                  has been removed from "mom_sim_o_buffer".
  #
  #     word    : token (string pattern) to be identified
  #
  #     flag    : 0 = Any match, do not remove token
  #               1 = Exact match
  #               2 = Extended match
  #               3 = Any match
  #
  #     args    : Optional callback command string to be executed
  #               when a match has been found.
  #
  #   Return -
  #               0 = No match
  #               1 = Match found
  #              -1 = Match found but callback not found
  #
    upvar $O_BUFF o_buff

     set tmp_buff $o_buff

     set status [VNC_parse_nc_block tmp_buff $word]

     if { $status > 0 } {
        if { $flag == 0  ||  $flag == 3  ||  $status == $flag } {
          # Trim buffer
           if { $flag != 0 } {
              set o_buff $tmp_buff
           }

          # Execute callback
           if { [llength $args] > 0 } {
              set exec_cb [string trim [lindex $args 0]]
           } else {
              set exec_cb ""
           }

           if { ![string match "" $exec_cb] } {
              if { [llength [info commands "$exec_cb"]] } {
                 eval "$exec_cb"
              } else {
  return -1
              }
           }
  return 1
        }
     }

  return 0
  }

  #-----------------------------------------------------------
  proc  MTX3_xform_csys { a b c x y z CSYS } {
  #-----------------------------------------------------------
     upvar $CSYS csys

  # <Note> a, b, c, x, y & z are measured w.r.t current csys space.
  #
  #                     Rotation about
  #         X                  Y                  Z
  # ----------------   ----------------   ----------------
  #   1     0     0     cosB   0   sinB    cosC -sinC    0
  #   0   cosA -sinA     0     1     0     sinC  cosC    0
  #   0   sinA  cosA   -sinB   0   cosB      0     0     1


    # Validate input data
     if { [EQ_is_zero $a] && [EQ_is_zero $b] && [EQ_is_zero $c] &&\
          [EQ_is_zero $x] && [EQ_is_zero $y] && [EQ_is_zero $z] } {
  return
     }


    #----------
    # Ratation
    #----------
     set xa [expr +1*$a]
     set yb [expr +1*$b]
     set zc [expr +1*$c]

     array set mm [array get csys]

     if { ![EQ_is_zero $a] || ![EQ_is_zero $b] || ![EQ_is_zero $c] } {

       # Rotate about X
       #
        set mx(0) 1;            set mx(1) 0;            set mx(2) 0
        set mx(3) 0;            set mx(4) [cosD $xa];   set mx(5) [-sinD $xa]
        set mx(6) 0;            set mx(7) [sinD $xa];   set mx(8) [cosD $xa]

       # Rotate about Y
       #
        set my(0) [cosD $yb];   set my(1) 0;            set my(2) [sinD $yb]
        set my(3) 0;            set my(4) 1;            set my(5) 0
        set my(6) [-sinD $yb];  set my(7) 0;            set my(8) [cosD $yb]

       # Rotate about Z
       #
        set mz(0) [cosD $zc];   set mz(1) [-sinD $zc];  set mz(2) 0
        set mz(3) [sinD $zc];   set mz(4) [cosD $zc];   set mz(5) 0
        set mz(6) 0;            set mz(7) 0;            set mz(8) 1

        MTX3_multiply  my mx mt
        MTX3_multiply  mz mt ma
        MTX3_transpose ma mt
        MTX3_multiply  mm mt csys
     }

    #-------------
    # Translation
    #-------------
     set u(0) $x;  set u(1) $y;  set u(2) $z
     MTX3_transpose mm ma
     MTX3_vec_multiply u ma v

     set csys(9)  [expr $csys(9)  + $v(0)]
     set csys(10) [expr $csys(10) + $v(1)]
     set csys(11) [expr $csys(11) + $v(2)]

     for { set i 0 } { $i < 12 } { incr i } {
        if { [EQ_is_zero $csys($i)] } {
           set csys($i) 0.0
        }
     }
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
         set xyzab [lreplace $xyzab 3 3 $ang4]
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
         set ang4 [lindex $offsets $4th_index]
         set xyzab [lreplace $xyzab 3 3 $ang4]
      }
      if { $5th_index > 0 } {
         set ang5 [lindex $offsets $5th_index]
         set xyzab [lreplace $xyzab 4 4 $ang5]
      }
   }

  return $xyzab
  }

 } ;# uplevel
}


#=============================================================
proc PB_CMD_vnc__init_isv_qc { } {
#=============================================================
#
# *** DO NOT rename or remove this command!
#

  global mom_sim_isv_qc mom_sim_isv_qc_file mom_sim_isv_qc_mode


   if { [llength [info commands "PB_CMD_vnc__config_isv_qc"]] } {
      PB_CMD_vnc__config_isv_qc
   }


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
   if { [string length $mom_sim_isv_qc_mode] == 0 } {
      set mom_sim_isv_qc 0
   }


  # Open message file
   if { [info exists mom_sim_isv_qc] && $mom_sim_isv_qc > 0 } {

      global mom_sim_vnc_handler_loaded

      if { ![info exists mom_sim_isv_qc_file] || ![string match "listing_device" $mom_sim_isv_qc_file] } {
         set  mom_sim_isv_qc_file ""
      }

      if { [string match "" [string trim $mom_sim_isv_qc_file]] } {

        # Default message file name is derived from the VNC.
        # User can define her own file name for the purpose.

         global mom_part_name
         set part_name "[join [split [file rootname [file tail $mom_part_name]] \\] /]"
         set file_name "[file rootname $mom_sim_vnc_handler_loaded]_${part_name}_qc.out"

         if { [catch {set mom_sim_isv_qc_file [open "$file_name" w]} ] } {
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
   if { [llength $args] } {
      set args_list ""
      for { set i 0 } { $i < [llength $args] } { incr i } {

         set arg [lindex $args $i]

        # pb602(s) - This is needed.
         if { $i == 0 } {
            if { ![string compare $command "VNC_sim_nc_block"] || ![string compare $command "VNC_parse_motion_word"] } {
               set arg [VNC_escape_special_chars $arg]
            }
         }

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
   if { ![info exists mom_sim_isv_qc] } {
      set mom_sim_isv_qc 0
   }


  # Output regular QC messages per mode specified
   if { $mom_sim_isv_qc == 1 } {

     # Add a blank line before VNC_sim_nc_block
      if { [string match "VNC_sim_nc_block" $command] } {
         PB_SIM_output_qc_cmd_string ""
      }

      set output_bit $mom_sim_isv_qc_mode

      set base 10000

      if { $output_bit >= $base } {
         if { [string match "SIM_*" $command] } {
            if { [string match "SIM_ask_*"     $command] ||\
                 [string match "SIM_find_*"    $command] ||\
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
         if { [string match "VNC_*" $command] } {
            PB_SIM_output_qc_cmd_string $cmd_string
         }
         set output_bit [expr $output_bit - $base]
      }
      set base [expr $base / 10]
      if { $output_bit >= $base } {
         if { [string match "PB_CMD_*" $command] } {
            PB_SIM_output_qc_cmd_string $cmd_string
         }
         set output_bit [expr $output_bit - $base]
      }
      set base [expr $base / 10]
      if { $output_bit >= $base } {
         if { ![string match "SIM_*"    $command] &&\
              ![string match "VNC_*"    $command] &&\
              ![string match "PB_CMD_*" $command] } {

            PB_SIM_output_qc_cmd_string $cmd_string
         }
      }
   }

   set val ""

  # pb901(a) - Undid rev. 801(b)
  # Verify existence of the command
   if { [llength [info commands "$command"]] > 0 } {

     # Evaluate command string. Abort, when error.
      if { [catch { set val [eval $cmd_string] } sta] } {

         set msg "# *** ABORT *** $cmd_string"

         if { $mom_sim_isv_qc == 1 }  {
            PB_SIM_output_qc_cmd_string "$msg"
         }

         VNC_send_message "$msg"

         MOM_abort "$cmd_string : $sta"
      }

   } else {

      set msg "# *** WARNING *** \"$command\" does not exist!"

      if { $mom_sim_isv_qc == 1 } {
         PB_SIM_output_qc_cmd_string "$msg"
      }

      VNC_send_message "$msg"

     # Define a dummy command
      proc $command { args } { return }
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

  # Pad blanks per call stack level
   set n_level [expr [info level] - 1]
   if { $n_level < 0 } { set n_level 0 }
   set lead [format %${n_level}c 32]

  # pb502(4) -
  # Skip padding for the 1st string containing proc definitions
   if { [string match "* VNC_CalculateDurationTime *" [lindex $args 0]] } {
      set lead ""
   }

  # The QC file handler should have been defined by the driver already,
  # by the time this command is called.
   if { ![info exists mom_sim_isv_qc_file] || [string match "" $mom_sim_isv_qc_file] } {
      MOM_output_to_listing_device "$lead[join $args]"
return
   }

  # Construct the message
   if 1 {
      set msg "$lead[join $args]"
   } else {
     # Add calls stack to the message
      set stack [VNC_trace]
      set idx [lsearch -glob $stack "PB_SIM_*"]
      while { $idx >= 0 } {
         set stack [lreplace $stack $idx $idx]
         set idx [lsearch -glob $stack "PB_SIM_*"]
      }
      set msg "[join $stack \n]\n\n   $lead[join $args]\n\n"
   }


  # Add mom_sim_pos to the msg per mode
   global mom_sim_isv_qc_mode
   if { [expr fmod($mom_sim_isv_qc_mode,10) == 1] } {
      global mom_sim_pos
      set msg "$msg   ;# -> [join [split [VNC_sort_array_vals mom_sim_pos]]]"
   }


  # Direct output to either the listing device or a file.
   if { [string match "listing_device" $mom_sim_isv_qc_file] } {
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
        "   set mom_sim_travel_delta \[expr double(\$delta)\]"\
        " "\
        " PB_SIM_call PB_CMD_vnc__calculate_duration_time"\
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

            if { [string match "MOM_SIM_exit_mtd" $proc_name] } {
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
proc PB_CMD_vnc__pass_csys_data { } {
#=============================================================
# This function is only executed in an in-process ISV
# to pass csys definitions.
#

# pb800(c) - Restored this command from pb700


  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_csys_matrix

  global mom_coordinate_system_purpose
  global mom_special_output
  global mom_kin_coordinate_system_type
  global mom_machine_csys_matrix
  global mom_sim_message


   if { [info exists mom_machine_csys_matrix] } {

      global mom_main_mcs
      global mom_coordinate_system_purpose

      global mom_sim_main_mcs
      global mom_sim_machine_type


     # Grab main MCS
      MTX3_transpose mom_machine_csys_matrix mainMCS

       set mainMCS(9)  $mom_machine_csys_matrix(9)
       set mainMCS(10) $mom_machine_csys_matrix(10)
       set mainMCS(11) $mom_machine_csys_matrix(11)


#VNC_info "Main MCS : $mom_main_mcs"
#VNC_info "mainMCS 1 : [VNC_sort_array_vals mainMCS]"

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
     #                      MAIN  : Special Output = 1 (Use Main MCS)
     #                      LOCAL : Special Output = 0 (None), 2 (Fixture Offset)
     #                      CSYS  : Special Output = 3 (CSYS Rotation)
     #==========================================================

      set coordinate_system_mode  $mom_kin_coordinate_system_type


if 0 {
 VNC_info "mainMCS 2      : [VNC_sort_array_vals mainMCS]"
 VNC_info "  machine csys : [VNC_sort_array_vals mom_machine_csys_matrix]"
 VNC_info "  csys matrix  : [VNC_sort_array_vals mom_csys_matrix]"
 VNC_info "CSYS Purpose : $mom_coordinate_system_purpose \nSpecial Output : $mom_special_output\
           \nCoordinate System Type : $mom_kin_coordinate_system_type"
 VNC_info "Coordinate system mode : $coordinate_system_mode"
}


     # 850(f) - Ensure var being defined
      global mom_fixture_offset_value
      if { ![info exists mom_fixture_offset_value] } {
         set mom_fixture_offset_value 0
      }


     # Extract offsets between a local and the mainMCS
     #
      if { [string compare $coordinate_system_mode "MAIN"] } {

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

            if { ![string match "*wedm"  $mom_sim_machine_type] &&\
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
                  if { [string match "*head*" $mom_sim_machine_type] } {
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
                  if { [string match "*dual_head*" $mom_sim_machine_type] } {
                     set fourth_ang [expr -1 * $fourth_ang]
                     set fifth_ang  [expr -1 * $fifth_ang]
                  }
                  if { [string match "*head_table*" $mom_sim_machine_type] } {
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
            if { [string match "*lathe" $mom_sim_machine_type] } {

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


      if { [string match "MAIN" $coordinate_system_mode] } {

        # Origin UDE specifies the offsets from a main MCS to the desired reference CSYS for output.
        # This UDE will not be known or involved in standalone NC files.
         global mom_origin

         for { set i 9 } { $i < 12 } { incr i } {
            if { [info exists mom_origin] } {
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


        # To be passed as VNC param msgs
         array set local_mainMCS [array get mainMCS]
         array set mainMCS [array get matrix]
      }


     # Rotate main CSYS matrix for lathe MCSX work plane
      if { [string match "*lathe" $mom_sim_machine_type] } {

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
         }
      }


     # Output WCS number
     #
      set fixture_offset $mom_fixture_offset_value

      set mom_sim_message "CSYS_FIXTURE_OFFSET==$fixture_offset"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg


#VNC_info "mainMCS passed : [VNC_sort_array_vals mainMCS]"
     #---------------------
     # Pass MCS definition
     #---------------------
      for { set i 0 } { $i < 12 } { incr i } {
         set mom_sim_message "CSYS_MTX_$i==$mainMCS($i)"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg
      }


     # Retain a copy of main, local & the currently active csys matrix
      global mom_sim_main_csys_matrix
      global mom_sim_local_csys_matrix
      global mom_sim_csys_matrix

      if { [string match "MAIN" $coordinate_system_mode] } {
         array set mom_sim_main_csys_matrix  [array get mainMCS]
      } else {
         array set mom_sim_main_csys_matrix  [array get local_mainMCS]
         array set mom_sim_local_csys_matrix [array get matrix]
      }

#VNC_info "Final coordinate system mode : $coordinate_system_mode"
#VNC_info "       csys : [VNC_sort_array_vals mom_sim_csys_matrix]"
#VNC_info " local csys : [VNC_sort_array_vals mom_sim_local_csys_matrix]"
#VNC_info " main  csys : [VNC_sort_array_vals mom_sim_main_csys_matrix]"
   }
}


#=============================================================
proc PB_CMD_vnc__pass_tool_data { } {
#=============================================================
  global mom_tool_name
  global mom_tool_type
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

  # 850(g) - Tool type may not exist
   if { [info exists mom_tool_type] } {
      set mom_sim_message "TOOL_TYPE==$mom_tool_type"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }

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


  # pb601(g) -
  if 0 {
  # pb502(7) -
  # Fetch info from devices (tool blocks on turret)
   global mom_sim_result mom_sim_result1

   if { ![catch { SIM_ask_base_device_holder_of_comp $mom_tool_name }] } {
      set mom_sim_message "TOOL_POCKET_ID==$mom_sim_result1"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }

   if { ![catch { SIM_ask_base_device_of_comp $mom_tool_name }] } {
     # Only allow numeric carrier ID
      if [catch {expr $mom_sim_result1 - 1} ] {
return
      }

      set mom_sim_message "TOOL_CARRIER_ID==$mom_sim_result1"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg

      global mom_sim_spindle_group
      if { [info exists mom_sim_spindle_group] } {
         PB_SIM_call SIM_assign_channel_to_spindle $mom_sim_result1 $mom_sim_spindle_group
      }

      PB_SIM_call PB_CMD_vnc__set_speed
   }
  }
}


#=============================================================
proc PB_CMD_vnc__rapid_segment { } {
#=============================================================
# This function is the old PB_CMD_vnc__rapid_move
#
  global mom_sim_lg_axis
  global mom_sim_nc_register
  global mom_sim_num_machine_axes

  global mom_sim_pos mom_sim_prev_pos

  global mom_sim_4th_axis_has_limits mom_sim_5th_axis_has_limits
  global mom_sim_result


  # pb750(g)
   PB_SIM_call SIM_set_linearization OFF

   set coord_list [list]
   set pattern 0

   if { [expr $mom_sim_pos(0) != $mom_sim_prev_pos(0)] } {
      lappend coord_list $mom_sim_lg_axis(X)  $mom_sim_pos(0)
      set pattern [expr $pattern + 10000]
   }
   if { [expr $mom_sim_pos(1) != $mom_sim_prev_pos(1)] } {
      lappend coord_list $mom_sim_lg_axis(Y)  $mom_sim_pos(1)
      set pattern [expr $pattern + 1000]
   }
   if { [expr $mom_sim_pos(2) != $mom_sim_prev_pos(2)] } {
      lappend coord_list $mom_sim_lg_axis(Z)  $mom_sim_pos(2)
      set pattern [expr $pattern + 100]
   }
   if { [info exists mom_sim_lg_axis(4)] } {
      if { [expr $mom_sim_pos(3) != $mom_sim_prev_pos(3)] } {

        # pb850(i) - Reduce rotation for limitless 4th rotary axis
         if { !$mom_sim_4th_axis_has_limits } {
            PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(4) "ALWAYS_SHORTEST"
            if { [expr ($mom_sim_pos(3) - $mom_sim_prev_pos(3)) > 180] } {
               set mom_sim_pos(3) [expr $mom_sim_pos(3) - 360]
            } elseif { [expr ($mom_sim_pos(3) - $mom_sim_prev_pos(3)) < -180] } {
               set mom_sim_pos(3) [expr $mom_sim_pos(3) + 360]
            }
         }

         lappend coord_list $mom_sim_lg_axis(4)  $mom_sim_pos(3)
         set pattern [expr $pattern + 10]
      }
   }
   if { [info exists mom_sim_lg_axis(5)] } {
      if { [expr $mom_sim_pos(4) != $mom_sim_prev_pos(4)] } {

        # pb850(i) - Reduce rotation for limitless 5th rotary axis
         if { !$mom_sim_5th_axis_has_limits } {
            PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(5) "ALWAYS_SHORTEST"
            if { [expr ($mom_sim_pos(4) - $mom_sim_prev_pos(4)) > 180] } {
               set mom_sim_pos(4) [expr $mom_sim_pos(4) - 360]
            } elseif { [expr ($mom_sim_pos(3) - $mom_sim_prev_pos(3)) < -180] } {
               set mom_sim_pos(4) [expr $mom_sim_pos(4) + 360]
            }
         }

         lappend coord_list $mom_sim_lg_axis(5)  $mom_sim_pos(4)
         set pattern [expr $pattern + 1]
      }
   }


   global mom_sim_mt_axis
   global mom_sim_max_dpm

   if { ![info exists mom_sim_max_dpm] || ![EQ_is_gt $mom_sim_max_dpm 0.0] } {
      set mom_sim_max_dpm 10000
   }


   switch $pattern {
      1 {
        # Pure 5th axis rotation -
         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(5) $mom_sim_pos(4)
      }

      10 {
        # Pure 4th axis rotation -
         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(4) $mom_sim_pos(3)
      }

      11 {
        # Pure compound rotation -
         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(4) $mom_sim_pos(3)
         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(5) $mom_sim_pos(4)
      }
   }


   if { [expr $pattern > 0] } {

      if { [expr $pattern > 11] } {
         eval PB_SIM_call VNC_move_linear_zcs RAPID $coord_list
      }

     # In case tool is not yet activated...
      global mom_sim_tool_loaded
      if { ![string match "" [string trim $mom_sim_tool_loaded]] } {
         PB_SIM_call SIM_activate_tool $mom_sim_tool_loaded
      }
      PB_SIM_call SIM_update

     # pb850(i) - Reset state for limitless 4th rotary axis
      if { [info exists mom_sim_lg_axis(4)] } {
         if { !$mom_sim_4th_axis_has_limits } {

            global mom_sim_4th_axis_direction
            if { ![string match "" [string trim $mom_sim_4th_axis_direction] ] } {
              # Reinstate rotary direction
               PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(4) $mom_sim_4th_axis_direction
            }

            PB_SIM_call SIM_set_interpolation OFF

            PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(4) NORM_180
            PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(4)
            if { [EQ_is_zero $mom_sim_result] } {
               set mom_sim_result 0.0
            }
            set mom_sim_pos(3) $mom_sim_result
            PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(4) $mom_sim_pos(3)
            unset mom_sim_result

            PB_SIM_call SIM_set_interpolation ON
         }
      }

     # pb850(i) - Reset state for limitless 5th rotary axis
      if { [info exists mom_sim_lg_axis(5)] } {
         if { !$mom_sim_5th_axis_has_limits } {

            global mom_sim_5th_axis_direction
            if { ![string match "" [string trim $mom_sim_5th_axis_direction] ] } {
              # Reinstate rotary direction
               PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(5) $mom_sim_5th_axis_direction
            }

            PB_SIM_call SIM_set_interpolation OFF

            PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(5) NORM_180
            PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(5)
            if { [EQ_is_zero $mom_sim_result] } {
               set mom_sim_result 0.0
            }
            set mom_sim_pos(4) $mom_sim_result
            PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(5) $mom_sim_pos(4)
            unset mom_sim_result

            PB_SIM_call SIM_set_interpolation ON
         }
      }
   }

   PB_SIM_call SIM_update

  # pb751(c) - No reference has changed, no need to update
  # PB_SIM_call VNC_update_sim_pos

   set mom_sim_nc_register(LAST_X) $mom_sim_pos(0)
   set mom_sim_nc_register(LAST_Y) $mom_sim_pos(1)
   set mom_sim_nc_register(LAST_Z) $mom_sim_pos(2)
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

   if { [expr $mom_sim_nc_register(S) <= 0.0] } {
      if { [expr $mom_sim_spindle_speed > 0.0] } {
         set spindle_speed $mom_sim_spindle_speed
      } else {
        # pb750(f) - Not to fake spindle speed
        # set spindle_speed $mom_sim_spindle_max_rpm
        # set spindle_mode  "REV_PER_MIN"
      }
   }


  # Set primary channel
   set primary_channel_set 0

   if { [info exists mom_sim_primary_channel] } {

      if { [string compare $spindle_mode "REV_PER_MIN"] || ![string compare $mom_sim_nc_register(MACHINE_MODE) "TURN"] } {

         if { [info exists mom_sim_tool_carrier_id] } {
           # pb502(8) -
           # Device name string with mom_carrier_name will fail the "expr" comparison.
           # - Make sure only numeral ID is assigned to mom_sim_tool_carrier_id.
            if { ![catch {expr $mom_sim_tool_carrier_id != $mom_carrier_name} ] } {
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
   if { $primary_channel_set } {

      if { ![string compare $mom_sim_nc_register(MACHINE_MODE) "TURN"] } {

        # Reduce spindle speed to the max
         if { ![string compare $spindle_mode "REV_PER_MIN"] } {
            if { [EQ_is_gt $spindle_speed $mom_sim_spindle_max_rpm] } {
               set spindle_speed $mom_sim_spindle_max_rpm
            }
         }

        # Set max spindle speed
         PB_SIM_call SIM_set_max_spindle_speed $mom_sim_spindle_max_rpm "REV_PER_MIN"
      }
   }


  # pb850(h) - Error protect against 0 spindle speed (machine control oper)
   if { [EQ_is_le $spindle_speed 0.0] } {
return
   }


  # Pass on spindle data
   set mom_sim_spindle_mode  $spindle_mode
   set mom_sim_spindle_speed $spindle_speed

   if { [string match "REV_PER_MIN" $spindle_mode] } {

      switch "$mom_sim_nc_register(MACHINE_MODE)" {
         "MILL" {
            PB_SIM_call SIM_set_speed $spindle_speed $spindle_mode
         }
         "TURN" {
            if { $primary_channel_set } {
               PB_SIM_call SIM_set_spindle_speed $spindle_speed $spindle_mode
            }
         }
      }

   } else {

      if { $primary_channel_set } {
         if { [string match "SFM" $spindle_mode] } {
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
proc PB_CMD_vnc__tool_change { } {
#=============================================================
# (pb903)
# 04-15-2014 gsl - Added code to handle right-angled head attachment
#
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
  global mom_sim_tool_junction mom_sim_current_tool_junction mom_sim_current_junction
  global mom_sim_pivot_distance
  global mom_sim_tool_change


  global mom_sim_pos mom_sim_prev_pos


  # Fetch UG tool name per tool number
   global mom_sim_address
   global mom_sim_tool_data
   global mom_sim_tool_number

   set tool_number ""

  # pb850(j) -
  # Preprocessor may set tool number to "0" per T code to force a tool-return
   if { [info exists mom_sim_tool_number] } {
      set tool_number $mom_sim_tool_number
   } elseif { [info exists mom_sim_nc_register($mom_sim_address(T,leader))] } {
      set tool_number $mom_sim_nc_register($mom_sim_address(T,leader))
   }

   if { [string length $tool_number] > 0  &&  [info exists mom_sim_tool_data($tool_number,name)] } {
      set mom_sim_ug_tool_name $mom_sim_tool_data($tool_number,name)
   } else {
     # pb800(i)
      set mom_sim_ug_tool_name ""
   }

  # pb800(i)
   if { ![info exists sim_prev_tool_name] } {
      set sim_prev_tool_name ""
   }

   if { [string match "$sim_prev_tool_name" $mom_sim_ug_tool_name] } {
      set mom_sim_tool_change 0
return
   }


  # Allow users to use specified tool change position.
   if { [llength [info commands "PB_CMD_vnc____go_to_tool_change_position"]] } {

      PB_SIM_call PB_CMD_vnc____go_to_tool_change_position

   } elseif { [llength [info commands "PB_CMD_vnc__go_to_tool_change_position"]] } {
     # Legacy
      PB_SIM_call PB_CMD_vnc__go_to_tool_change_position

   } else {

     # By default, turret does not return to ref pt for tool change,
     # it only moves off the spindle (Z) axis.
      global mom_sim_tool_carrier_id
      global mom_sim_turret_carriers
      global mom_sim_tool_pocket_id

      set done_position 0


      if { [info exists mom_sim_tool_carrier_id] && [info exists mom_sim_turret_carriers] } {

        # pb601(h)
         global mom_sim_comp_class
         if { [info exists mom_sim_comp_class(_CARRIER,$mom_sim_ug_tool_name)] } {

            set mom_sim_tool_carrier_id $mom_sim_comp_class(_CARRIER,$mom_sim_ug_tool_name)

            set mom_sim_tool_data($tool_number,carrier_id) "\"$mom_sim_tool_carrier_id\""

            global mom_sim_spindle_group
            if { [info exists mom_sim_spindle_group] } {
               PB_SIM_call SIM_assign_channel_to_spindle $mom_sim_tool_carrier_id $mom_sim_spindle_group
            }

            PB_SIM_call PB_CMD_vnc__set_speed
         }


        # Not sure if this is always true for all machines!!!
         if { [lsearch $mom_sim_turret_carriers $mom_sim_tool_carrier_id] >= 0 } {

           # pb601(h)
            if { ![catch { SIM_ask_base_device_holder_of_comp $mom_sim_ug_tool_name }] } {
               set mom_sim_tool_pocket_id "$mom_sim_result1"
               set mom_sim_tool_data($tool_number,pocket_id) "\"$mom_sim_tool_pocket_id\""
            }

           # Force return of X/Y (away from Z) to reference point
            set mom_sim_nc_register(REF_INT_PT_X) -939
            set mom_sim_nc_register(REF_INT_PT_Y) -939

            VNC_unset_vars  mom_sim_nc_register(REF_INT_PT_Z)

           # Position spindle to reference point.
            PB_SIM_call PB_CMD_vnc__send_dogs_home

           # Unset temporary intermediate reference point
            VNC_unset_vars  mom_sim_nc_register(REF_INT_PT_X) mom_sim_nc_register(REF_INT_PT_Y)

            set done_position 1
         }
      }

      if { $done_position == 0 } {
        # Fake a temporary intermediate reference point to send all dogs home
         set mom_sim_nc_register(REF_INT_PT_X) -939
         set mom_sim_nc_register(REF_INT_PT_Y) -939
         set mom_sim_nc_register(REF_INT_PT_Z) -939

        # pb901(d) - Only unwind rotary axes with head
         if { ![string match "*head*" $mom_sim_machine_type] } {
            VNC_unset_vars  mom_sim_nc_register(REF_INT_PT_4)
            VNC_unset_vars  mom_sim_nc_register(REF_INT_PT_5)
         } elseif { [string match "*head_table*" $mom_sim_machine_type] } {
            VNC_unset_vars  mom_sim_nc_register(REF_INT_PT_5)
         }

        # Position spindle to reference point.
         PB_SIM_call PB_CMD_vnc__send_dogs_home

        # Unset temporary intermediate reference point
         VNC_unset_vars  mom_sim_nc_register(REF_INT_PT_X) \
                         mom_sim_nc_register(REF_INT_PT_Y) \
                         mom_sim_nc_register(REF_INT_PT_Z)
      }
   }


   set sim_tool_name ""


#>>>>>
#  This is where you add detailed movements such as rotating tool changer,
#  unmounting old tool and mounting new tool and/or getting next tool in ready position.
#<<<<<

  #<06-20-2014 gsl> Head info exists even w/o head obj added, ACS jct info is needed.
   set __xform_spindle_jct 0


  # User provided tool change sequence
   if { [llength [info commands "PB_CMD_vnc__user_tool_change"]] } {

      set sim_tool_name [PB_SIM_call PB_CMD_vnc__user_tool_change]

   } elseif { [llength [info commands "PB_CMD_vnc____tool_change"]] } {

      set sim_tool_name [PB_SIM_call PB_CMD_vnc____tool_change]

   } else {

      global mom_sim_tool_carrier_id
      global mom_sim_turret_carriers
      global mom_sim_turret_axis
      global mom_sim_tool_pocket_id


      set done_tool_change 0


      set mom_sim_result ""

     # Rotate turret to index lathe tool
      if { [info exists mom_sim_tool_carrier_id] &&\
           [info exists mom_sim_tool_pocket_id]  &&\
           [info exists mom_sim_turret_carriers] } {

         if { [lsearch $mom_sim_turret_carriers $mom_sim_tool_carrier_id] >= 0 } {

           # Handle mixed use of tools on a turret and stationary tools.
            if { ![catch { PB_SIM_call SIM_ask_kim_comp_name_by_id "TOOL" $mom_sim_ug_tool_name }] } {
               set done_tool_change 1
            }

           # pb801(g) -
           # pb800(h) - Only handle when pocket ID is an integer
            if { ![catch { expr $mom_sim_tool_pocket_id }] } {

               if { $done_tool_change } {

                  global mom_sim_pocket_angle

                 # Handle holder angle with operation
                  set cutter_holder_angle_delta 0.0
                  set cutter_holder_angle_delta [PB_SIM_call PB_CMD_vnc__compute_tool_holder_angle_delta]

                 # Actual turret rotation angle = rot angle based on pocket ID + tool holder delta
                  global mom_sim_turret_data
                  global mom_sim_add_turret_angle

                  set pocket_id $mom_sim_tool_pocket_id

                  if { [info exists mom_sim_turret_data($mom_sim_tool_carrier_id,pockets_num)] } {
                     set pockets_num $mom_sim_turret_data($mom_sim_tool_carrier_id,pockets_num)
                     set pocket_id [expr int(fmod($pocket_id,$pockets_num))]

                     if { !$pocket_id } {
                        set pocket_id $pockets_num
                     }
                  }
                  set turret_rotation_angle [expr $cutter_holder_angle_delta +\
                                                  $mom_sim_add_turret_angle +\
                                                  $mom_sim_pocket_angle($mom_sim_tool_carrier_id,$pocket_id)]

                 # Reduce turret rotation
                  set turret_rotation_angle [expr fmod($turret_rotation_angle,360)]
                  if { [expr $turret_rotation_angle > 180] } { ;# May need to compare with previous angle
                     set turret_rotation_angle [expr $turret_rotation_angle - 360]
                  }

                  set __sim_result $mom_sim_result

                  SIM_ask_axis_position $mom_sim_turret_axis($mom_sim_tool_carrier_id)
                  set __prev_angle $mom_sim_result
                  if { [expr ($turret_rotation_angle - $__prev_angle) > 180] } {
                     set turret_rotation_angle [expr $turret_rotation_angle - 360]
                  } elseif { [expr ($turret_rotation_angle - $__prev_angle) < -180] } {
                     set turret_rotation_angle [expr $turret_rotation_angle + 360]
                  }

                  set mom_sim_result $__sim_result

                  PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_turret_axis($mom_sim_tool_carrier_id)\
                                                           $turret_rotation_angle
               }
            }
         }
      }


     # Change tool for mills
      if { $done_tool_change == 0 } {

        # pb502(13) -
        # Always unmount fly tool

        # pb853 - Fix error with missing double quote around *head* condition below
        # pb850(m) - Adjust rotary angle only for machine with "head"
        # pb602(q) - Rotate B-head to tool change angle (set in PB_CMD_vnc____map_machine_tool_axes)
        #
         if { [string match "*head*" $mom_sim_machine_type] } {

            global mom_sim_mt_axis
            if { [info exists mom_sim_mt_axis(4)] } {

               global mom_sim_tool_change_angle

               if { ![info exists mom_sim_tool_change_angle] } {
                  set mom_sim_tool_change_angle 0
               }

               set mom_sim_pos(3) $mom_sim_tool_change_angle

               PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(4) $mom_sim_pos(3)
               PB_SIM_call SIM_update
            }
         }


        # pb602(c) - Add condition to accommodate flash tool handling
        # Restore spindle axis to ready orientation
         global mom_sim_flash_tool
         if { ![info exists mom_sim_flash_tool] } {
            set mom_sim_flash_tool 0
         }

         PB_SIM_call VNC_rotate_head_spindle_axis 0

        # pb603(j) - Unmount fly tool in current carrier, if any
         global mom_sim_fly_tool_mounted
         if { [info exists mom_sim_tool_carrier_id] } {
            if { [info exists mom_sim_fly_tool_mounted($mom_sim_tool_carrier_id)] } {
               PB_SIM_call VNC_unmount_tool $mom_sim_fly_tool_mounted($mom_sim_tool_carrier_id)
            }
         } else {
            if { [info exists mom_sim_fly_tool_mounted(0)] } {
               PB_SIM_call VNC_unmount_tool $mom_sim_fly_tool_mounted(0)
            }
         }


        # pb801(g) - Also validate a null tool
        # pb800(i) - Next tool is null, bail out!
         if { [string match "0" $tool_number] || [string trim $mom_sim_ug_tool_name] == "" } {

           # Null following jct to send tool home properly
             set mom_sim_tool_junction         ""
             set mom_sim_current_tool_junction ""
             set mom_sim_current_junction      ""

             set mom_sim_tool_change 0
return
         }


        # pb903(a) - Xform spindle jct due to angled head attachment
         PB_SIM_call SIM_ask_mtcs_junction
         set mtcs_jct $mom_sim_result

        # This scheme will not work when machine contains more than one junction with same name,
        # since some SIM commands always serach from the root component to find the named junction.

         global mom_head_gauge_point mom_head_spindle_axis
         if { [info exists mom_head_gauge_point] && [info exists mom_head_spindle_axis] } {

            VEC3_unitize mom_head_spindle_axis u

           # pb903(d) - Revised/corrected condition below
            if { (![VEC3_is_zero u] && ![EQ_is_equal $u(2) 1.0]) || ![VEC3_is_zero mom_head_gauge_point] } {
               set __xform_spindle_jct 1
            }
         }

         if $__xform_spindle_jct {

           # - Create ACS junction
            PB_SIM_call SIM_ask_is_junction_exist __SIM_ACS_JCT

            if { $mom_sim_result == 0 } {
               set machine_base MACHINE_BASE
               PB_SIM_call SIM_ask_machine_base_component
               if { ![string match "" $mom_sim_result] } {
                  set machine_base $mom_sim_result
               }
               eval SIM_create_junction __SIM_ACS_JCT $machine_base [list 0 0 0] [list 1 0 0 0 1 0 0 0 1]
            }

           # pb903(d) - Use fully qualified Jct name <== It doesn't seem to help!
            SIM_ask_init_junction_xform "mom_sim_spindle_comp@$mom_sim_spindle_jct"

            set i 0
            foreach v $mom_sim_result {
               set spindle_jct_matrix($i) $v
               incr i
            }
            foreach v $mom_sim_result1 {
               set spindle_jct_matrix($i) $v
               incr i
            }

            set pnt [list $mom_head_spindle_axis(0) $mom_head_spindle_axis(1) $mom_head_spindle_axis(2)]
            set vec [SIM_transform_vector $pnt $mtcs_jct __SIM_ACS_JCT]

            set dir(0) [lindex $vec 0]
            set dir(1) [lindex $vec 1]
            set dir(2) [lindex $vec 2]

            set a [VEC3_find_principal_angle dir YZ]
            set b [VEC3_find_principal_angle dir ZX]
            set c [VEC3_find_principal_angle dir XY]

           # Find unit conversion factor
            global mom_sim_output_unit
            global mom_part_unit

            if { ![string compare $mom_sim_output_unit $mom_part_unit] } {
               set unit_conversion 1.0
            } elseif { ![string compare "IN" $mom_sim_output_unit] } {
               set unit_conversion [expr 1/25.4]
            } else {
               set unit_conversion 25.4
            }

            set pnt [list $mom_head_gauge_point(0) $mom_head_gauge_point(1) $mom_head_gauge_point(2)]
            set org [SIM_transform_vector $pnt $mtcs_jct __SIM_ACS_JCT]

            set x [lindex $org 0]
            set y [lindex $org 1]
            set z [lindex $org 2]

           # Apply conversion factor to origin coordinates
            set x [expr $x * $unit_conversion]
            set y [expr $y * $unit_conversion]
            set z [expr $z * $unit_conversion]

            MTX3_xform_csys $a $b $c  0  0  0 spindle_jct_matrix

            set spindle_jct_matrix(9)  [expr $spindle_jct_matrix(9)  + $x]
            set spindle_jct_matrix(10) [expr $spindle_jct_matrix(10) + $y]
            set spindle_jct_matrix(11) [expr $spindle_jct_matrix(11) + $z]

            set jct_origin [list]
            for { set i 9 } { $i < 12 } { incr i } {
               lappend jct_origin $spindle_jct_matrix($i)
            }

            set jct_matrix [list]
            for { set i 0 } { $i < 9 } { incr i } {
               lappend jct_matrix $spindle_jct_matrix($i)
            }

           # Redefine spindle jct
           # pb903(d) - Use fully qualified Jct name
            PB_SIM_call SIM_ask_is_junction_exist "mom_sim_spindle_comp@$mom_sim_spindle_jct"

            if { $mom_sim_result == 1 } {
              # pb903(d) - Use fully qualified Jct name
               PB_SIM_call SIM_delete_junction "mom_sim_spindle_comp@$mom_sim_spindle_jct"
            }

            eval PB_SIM_call SIM_create_junction $mom_sim_spindle_jct $mom_sim_spindle_comp $jct_origin $jct_matrix

           # Tool-tip jct may also need to be xfomed.

         } ;# Handle angled head attachment

         global mom_sim_tool_change_time
         if { ![info exists mom_sim_tool_change_time] || [EQ_is_le $mom_sim_tool_change_time 0.0] } {
            set tool_change_time 5
         } else {
            set tool_change_time $mom_sim_tool_change_time
         }

         PB_SIM_call VNC_set_ref_jct {""}
         PB_SIM_call SIM_mount_tool $tool_change_time "UG_NAME" "$mom_sim_ug_tool_name"\
                                    "$mom_sim_spindle_comp" "$mom_sim_spindle_jct"

        # pb603(j) - Remember the fly tool mounted in carrier
         if { [info exists mom_sim_tool_carrier_id] } {
            set mom_sim_fly_tool_mounted($mom_sim_tool_carrier_id) $mom_sim_ug_tool_name
         } else {
            set mom_sim_fly_tool_mounted(0) $mom_sim_ug_tool_name
         }


        # pb602(c) - Accommodate flash tool handling
        # Flash spindle axis if required
         if { $mom_sim_flash_tool } {
            PB_SIM_call VNC_rotate_head_spindle_axis 180
         }


        # By default, this variable is NOT set to indicate that tool length
        # compensation is done immediately @ tool change, otherwise it's set
        # in ____map command to cause compensation to be done @ length comp
        # (G43) function.

         global mom_sim_tool_length_comp_auto

         if { [info exists mom_sim_tool_length_comp_auto] && $mom_sim_tool_length_comp_auto == 0 } {
            set mom_sim_nc_register(TOOL_CHANGED) 1
         }
      }

     # Fetch tool comp ID
      set sim_tool_name $mom_sim_result
   }


   PB_SIM_call SIM_update


   if { [string length $sim_tool_name] > 0 } {
      PB_SIM_call SIM_activate_tool $sim_tool_name
   } else {
return
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
         if { [string match "*axis*" $mom_sim_machine_type] } {
            set use_tool_tip_jct 0
            set x_offset [expr -1.0 * ($mom_sim_tool_data($tool_number,z_off) + $mom_sim_pivot_distance)]
            set y_offset 0.0
            set z_offset 0.0

         } elseif { [string match "*lathe*" $mom_sim_machine_type] } {
            if { [string match "TURRET_REF" $mom_sim_output_reference_method] } {
               set use_tool_tip_jct 0
               set x_offset $mom_sim_tool_data($tool_number,x_off)
               set y_offset $mom_sim_tool_data($tool_number,y_off)
               set z_offset 0.0
            }
         }
      }
   }


  #<911-2008 gsl> pb602 - This looks like a MUST fix !!!!!
   global mom_sim_curr_jct_matrix mom_sim_curr_jct_origin
   global mom_sim_result mom_sim_result1

   PB_SIM_call SIM_ask_init_junction_xform $mom_sim_tool_junction
   set mom_sim_curr_jct_matrix "$mom_sim_result"
   set mom_sim_curr_jct_origin "$mom_sim_result1"



  # pb903(a) Account for angled head offsets
   if $__xform_spindle_jct {

      if { $use_tool_tip_jct } { set x_offset 0.0; set y_offset 0.0; set z_offset 0.0 }

      set x_offset [expr $x_offset + $mom_head_gauge_point(2)]
      set y_offset [expr $y_offset - $mom_head_gauge_point(1)*$mom_head_spindle_axis(1)]
      set z_offset [expr $z_offset - $mom_head_gauge_point(0)*$mom_head_spindle_axis(0)]

      set use_tool_tip_jct 0
   }


   if { !$use_tool_tip_jct } {
      global mom_sim_tool_x_offset mom_sim_tool_y_offset mom_sim_tool_z_offset

      set mom_sim_tool_x_offset $x_offset
      set mom_sim_tool_y_offset $y_offset
      set mom_sim_tool_z_offset $z_offset

      PB_SIM_call PB_CMD_vnc__offset_tool_jct
   }


   if { [string match "TURN" $mom_sim_nc_register(MACHINE_MODE)] } {
      set mom_sim_pos(1) 0
   }

  # Reset mom_sim_prev_pos to disable unnecessary move
   for { set i 0 } { $i < 5 } { incr i } {
      set mom_sim_prev_pos($i) $mom_sim_pos($i)
   }


  # pb602 - Current tool jct should always be preserved!
   set mom_sim_current_tool_junction "$mom_sim_tool_junction"


  # Track @ pivot pt for the initial move
  # - Require a good pivot jct!
  #
   if { [info exists mom_sim_nc_register(TOOL_CHANGED)] } {
      global mom_sim_spindle_jct mom_sim_pivot_jct

      if { [info exists mom_sim_pivot_jct] } {
         PB_SIM_call VNC_set_current_ref_junction $mom_sim_pivot_jct
      } else {
         PB_SIM_call VNC_set_current_ref_junction $mom_sim_spindle_jct
      }

     # To prevent ref jct being reset to tool tip in sim_motion
      set mom_sim_tool_junction "$mom_sim_current_junction"
   }
}


#=============================================================
proc PB_CMD_vnc__ask_number_of_active_channels { } {
#=============================================================
# This function cycles through the kinematic model to determine
# if the model is a multi-channel machine.
#
# This function returns the number of K-components classified as _DEVICE.
#

   set cmd_name "PB_SIM_cycle_comp_of_class"

   if { [llength [info commands $cmd_name]] == 0 } {

      # pb850(k) - Remove PB_SIM_call from this command. It caused error in ISV QC mode.
      # pb601(i) -
      #=====================================================
      proc $cmd_name { COMP_CLASS base_comp class class_type args } {
      #=====================================================
      # This command recurrsively identifies all NC axes
      # from a machine model.

         upvar $COMP_CLASS comp_class

        # Added args for passing channel number to collect tools per each carrier
         if { [llength $args] > 0 } {
            set chan [lindex $args 0]
         } else {
            set chan ""
         }

         global mom_sim_result mom_sim_result1

         set n_comp 0

         if [string match "*_SPUN" $base_comp] {
            return
         }
         if [catch { SIM_ask_number_of_child_components $base_comp }] {
            return
         } else {
            set n_comp $mom_sim_result
         }

         for { set i 0 } { $i < $n_comp } { incr i } {

            if ![catch { SIM_ask_nth_child_component $base_comp $i }] {
               set comp $mom_sim_result

               set mom_sim_result 0
               if { ![string compare "SYSTEM" $class_type] } {
                  if [catch { SIM_is_component_of_system_class $comp $class }] {
                     continue
                  }
               } else {
                  if [catch { SIM_is_component_of_user_class $comp $class }] {
                     continue
                  }
               }
            } else {
               continue
            }

            if { $mom_sim_result == 1 } {

               switch $class {

                  _DEVICE {
                     SIM_ask_number_of_channels_at_component $comp
                     set n_ch $mom_sim_result

                     for { set idx 0 } { $idx < $n_ch } { incr idx } {

                        SIM_ask_nth_channel_at_component $comp $idx
                        set ch $mom_sim_result

                        if { [info exists comp_class(active_chan)] } {
                           if { [lsearch $comp_class(active_chan) $ch] < 0 } {
                              lappend comp_class(active_chan) $ch
                           }
                        } else {
                           lappend comp_class(active_chan) $ch
                        }

                       #<07-15-08 gsl> Find tools on this device
                        eval { [lindex [info level 0] 0] comp_class $comp _TOOL $class_type $ch }
                     }
                  }

                  _DEVICE_HOLDER {
                  }

                  _TOOL {
                    # pb601(i) -
                    #*************************************************************************************
                    # Potential problem - K-comp can be renamed to become different from actual tool name.
                    # ==> Dependant K-comp should be read only!
                    # 
                     set comp_class(_CARRIER,$comp) $chan

                     global mom_sim_comp_class
                     set mom_sim_comp_class(_CARRIER,$comp) $chan
                  }

                  default {
                     lappend comp_class($class,comp) $comp
                  }
               }
            }

            eval { [lindex [info level 0] 0] comp_class $comp $class $class_type $chan }
         }
      }
   }



   global mom_sim_result

  # pb602(d) - Preserve status
   set sim_result_saved $mom_sim_result


   VNC_unset_vars n_channels

   if { ![catch { SIM_ask_number_of_channels }] } {
      if { $mom_sim_result == 1 } {
         set n_channels 1
      }
   } else {
      set n_channels 1
   }

   global mom_sim_active_channels

   if { [info exists mom_sim_active_channels] } {
      set n_channels [llength $mom_sim_active_channels]
   }

   if [info exists n_channels] {
      set mom_sim_result $sim_result_saved
return $n_channels
   }


   set cmd_name "PB_SIM_cycle_comp_of_class"


   set mom_sim_result ""

   set machine_base MACHINE_BASE
   PB_SIM_call SIM_ask_machine_base_component

   if { ![string match "" $mom_sim_result] } {
      set machine_base $mom_sim_result
   }


   VNC_unset_vars  COMP_class

   set class _DEVICE
   set mode  SYSTEM

   set n_channels 1
   if { ![catch { PB_SIM_cycle_comp_of_class COMP_class $machine_base $class $mode }] } {
      if { [info exists COMP_class(active_chan)] } {
         set mom_sim_active_channels $COMP_class(active_chan)
         set n_channels [llength $COMP_class(active_chan)]
      }
   }

   set mom_sim_result $sim_result_saved

return $n_channels
}


#=============================================================
proc PB_CMD_vnc__init_sim_vars { } {
#=============================================================
  global mom_sim_word_separator mom_sim_word_separator_len
  global mom_sim_pos
  global mom_sim_tool_loaded
  global mom_sim_tool_junction
  global mom_sim_curr_jct_matrix mom_sim_curr_jct_origin
  global mom_sim_nc_register
  global mom_sim_wcs_offsets
  global mom_sim_ug_tool_name
  global mom_sim_result mom_sim_result1


  # Define some misc commands.
  # -> This call must be done 1st!!!
   PB_SIM_call PB_CMD_vnc__define_misc_procs


  # pb502(14) - Add user's own commands
   PB_SIM_call PB_CMD_vnc__define_user_misc_procs


  # pb600 -
  # - Retain current state of the participating NC axes, if any, before switching to new set
  #
   global mom_sim_mt_axis

   if { [info exists mom_sim_mt_axis(X)] && [info exists mom_sim_pos(0)] } {
      set mom_sim_nc_register($mom_sim_mt_axis(X)) $mom_sim_pos(0)
   }
   if { [info exists mom_sim_mt_axis(Y)] && [info exists mom_sim_pos(1)] } {
      set mom_sim_nc_register($mom_sim_mt_axis(Y)) $mom_sim_pos(1)
   }
   if { [info exists mom_sim_mt_axis(Z)] && [info exists mom_sim_pos(2)] } {
      set mom_sim_nc_register($mom_sim_mt_axis(Z)) $mom_sim_pos(2)
   }
   if { [info exists mom_sim_mt_axis(4)] && [info exists mom_sim_pos(3)] } {
      set mom_sim_nc_register($mom_sim_mt_axis(4)) $mom_sim_pos(3)
   }
   if { [info exists mom_sim_mt_axis(5)] && [info exists mom_sim_pos(4)] } {
      set mom_sim_nc_register($mom_sim_mt_axis(5)) $mom_sim_pos(4)
   }


  # Initialize var that defers tool length comp @ tool change until G43/44
   global mom_sim_tool_length_comp_auto
   VNC_unset_vars mom_sim_tool_length_comp_auto


  # Transfer static data from the Post.
  #
   PB_SIM_call VNC_load_post_definitions


  # Inspect NC functions
  #
   PB_SIM_call PB_CMD_vnc__inspect_nc_func


  # When a VNC is used to output VNC messages only w/o simulation.
  #
   global mom_sim_vnc_msg_only
   if { [info exists mom_sim_vnc_msg_only] && $mom_sim_vnc_msg_only } {
return
   }


  # Abolish end-of-block symbol for CAM program (non-standalone NC program) simulation
   global mom_sim_post_builder_rev_post
   global mom_sim_end_of_block mom_sim_end_of_block_len
   if { !$mom_sim_post_builder_rev_post } {
      set mom_sim_end_of_block ""
      set mom_sim_end_of_block_len 0
   }


  # Display this VNC name in ISV.
  #
   PB_SIM_call PB_CMD_vnc__display_version


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

   VNC_unset_vars  mom_sim_zcs_base_MCS\
                   mom_sim_zcs_base_LCS\
                   mom_sim_zcs_base\
                   mom_sim_spindle_comp\
                   mom_sim_spindle_jct\
                   mom_sim_pivot_jct\
                   mom_sim_advanced_kinematic_jct\
                   mom_sim_mt_axis


  # pb502(5) -
  # Save machine base component as global var
  #
   global mom_sim_machine_base_comp
   set mom_sim_result ""
   set mom_sim_machine_base_comp MACHINE_BASE
   PB_SIM_call SIM_ask_machine_base_component
   if { ![string match "" $mom_sim_result] } {
      set mom_sim_machine_base_comp $mom_sim_result
   }


  # Interrogate actual number of NC axes from model
  # This enables use of a higher dof driver on a lower dof machine.
   global mom_sim_num_machine_axes

   PB_SIM_call SIM_ask_nc_axes_of_mtool
   if { $mom_sim_result < $mom_sim_num_machine_axes } {
      set mom_sim_num_machine_axes $mom_sim_result
   }


  # Additional angle to index tool turret on Z-X plane for sub-spindle
  # When necessary, this angle can be specified in the ____map function or
  # other command that surely gets executed.
   global mom_sim_add_turret_angle
   set mom_sim_add_turret_angle 0.0

  # Force some parms to be defined
   set map_machine_ok 1
   if { [catch { PB_SIM_call PB_CMD_vnc____map_machine_tool_axes }] } {
      set map_machine_ok 0
   }


  #------------------------------
  # Map machine tool assignments
  #------------------------------
  # Account for multi-spindle case.
   if { [PB_SIM_call PB_CMD_vnc__ask_number_of_active_channels] > 1 ||\
        [PB_SIM_call PB_CMD_vnc__ask_number_of_lathe_spindles] > 1 } {

      if { !$map_machine_ok } {
        # Fetch machine kinematics from model
         if { [string match "TRUE" [PB_SIM_call MOM_validate_machine_model]] } {
            PB_SIM_call PB_CMD_vnc__reload_machine_tool_axes
         }
      }

   } else {

      if { [string match "TRUE" [PB_SIM_call MOM_validate_machine_model]] } {
        # Fetch machine kinematics from model
         if { [catch { PB_SIM_call PB_CMD_vnc__reload_machine_tool_axes }] } {
            PB_SIM_call PB_CMD_vnc____map_machine_tool_axes
         }
      }
   }


  # Initialize a null list for other NC codes to be simulated.
  # Actual code list will be defined in PB_CMD_vnc____set_nc_definitions.
  #
   global mom_sim_other_nc_codes
   global mom_sim_other_nc_codes_ex

   set mom_sim_other_nc_codes [list]
   set mom_sim_other_nc_codes_ex [list]


  # Add user's NC data definition.
  #
   if { [llength [info commands "PB_CMD_vnc__set_nc_definitions"]] } {
      PB_SIM_call PB_CMD_vnc__set_nc_definitions
   } else {
      PB_SIM_call PB_CMD_vnc____set_nc_definitions
   }


  # pb800(b) -
  # Load alternate unit setting for VNC
  #
   PB_SIM_call VNC_load_alternate_unit_settings


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
   VNC_unset_vars  mom_sim_pos_mtcs


  # Logical axes assignments (not from the post?)
  # It works to equate logical names to the physical names.
  #
   global mom_sim_lg_axis mom_sim_nc_axes mom_sim_address

  # Linear axes are commanded by logical names, whereas
  # rotary axes are commanded by physical names.
  #
   set mom_sim_lg_axis(X) X
   set mom_sim_lg_axis(Y) Y
   set mom_sim_lg_axis(Z) Z
   set mom_sim_lg_axis(I) I
   set mom_sim_lg_axis(J) J
   set mom_sim_lg_axis(K) K

  # Unset rotary axes first
   if { [info exists mom_sim_lg_axis(4)] } {
      unset mom_sim_lg_axis(4)
   }
   if { [info exists mom_sim_lg_axis(5)] } {
      unset mom_sim_lg_axis(5)
   }

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
      default {}
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

  #<911-2008> pb602(e) - Do not assume curr_jct (only defined in PB_CMD_vnc__offset_tool_jct)
  #                      Also see changes in PB_CMD_vnc__create_tmp_jct
  if 0 {
   if { ![info exists mom_sim_curr_jct_matrix] } {
      lappend mom_sim_curr_jct_matrix 1.0 0.0 0.0  0.0 1.0 0.0  0.0 0.0 1.0
   }

   if { ![info exists mom_sim_curr_jct_origin] } {
      lappend mom_sim_curr_jct_origin 0.0 0.0 0.0
   }
  }

   for { set i 0 } { $i < 8 } { incr i } {
      if { ![info exists mom_sim_pos($i)] } {
         set mom_sim_pos($i) 0
      }
   }


  # pb600 -
  # - Restore machine to the previously visited state, if any.
  #
   if { [info exists mom_sim_nc_register($mom_sim_mt_axis(X))] } {
      set mom_sim_pos(0) $mom_sim_nc_register($mom_sim_mt_axis(X))
   }
   if { [info exists mom_sim_nc_register($mom_sim_mt_axis(Z))] } {
      set mom_sim_pos(2) $mom_sim_nc_register($mom_sim_mt_axis(Z))
   }
   if { [info exists mom_sim_mt_axis(Y)] } {
      if { [info exists mom_sim_nc_register($mom_sim_mt_axis(Y))] } {
         set mom_sim_pos(1) $mom_sim_nc_register($mom_sim_mt_axis(Y))
      }
   }
   if { $mom_sim_num_machine_axes > 3 } {
      if { [info exists mom_sim_nc_register($mom_sim_mt_axis(4))] } {
         set mom_sim_pos(3) $mom_sim_nc_register($mom_sim_mt_axis(4))
      }
   }
   if { $mom_sim_num_machine_axes > 4 } {
      if { [info exists mom_sim_nc_register($mom_sim_mt_axis(5))] } { 
         set mom_sim_pos(4) $mom_sim_nc_register($mom_sim_mt_axis(5))
      }
   }


  # Initialize controller's states, in case, not set in a VNC by
  # PB_CMD_vnc____set_nc_definitions
  #
   global mom_sim_vnc_msg_prefix
   if { ![info exists mom_sim_vnc_msg_prefix] } {
      set mom_sim_vnc_msg_prefix  "VNC_MSG::"
   }

   global mom_sim_spindle_max_rpm mom_sim_spindle_speed
   if { ![info exists mom_sim_spindle_max_rpm] } {
      set mom_sim_spindle_max_rpm 0
   }
   if { ![info exists mom_sim_spindle_speed] } {
      set mom_sim_spindle_speed 0
   }

   global mom_sim_cycle_spindle_axis
   if { ![info exists mom_sim_cycle_spindle_axis] } {
      set mom_sim_cycle_spindle_axis 2
   }

   if { ![info exists mom_sim_nc_register(POWER_ON_WCS)] } {
      set mom_sim_nc_register(POWER_ON_WCS) 0
   }

   if { ![info exists mom_sim_nc_register(WCS)] } {
      set mom_sim_nc_register(WCS) $mom_sim_nc_register(POWER_ON_WCS)
   }

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
      set mom_sim_nc_register(WORK_OFFSET) [PB_SIM_call VNC_map_to_machine_offsets\
                                                        $mom_sim_wcs_offsets($mom_sim_nc_register(WCS))]
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
   if { ![info exists mom_sim_rapid_dogleg] } {
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
   if { [string match "*wedm*" $mom_sim_machine_type] } {
      set mom_sim_nc_register(MACHINE_MODE) WEDM
   } elseif { [string match "*lathe*" $mom_sim_machine_type] } {
      set mom_sim_nc_register(MACHINE_MODE) TURN
   } else {
      set mom_sim_nc_register(MACHINE_MODE) MILL
   }

  # Initialize plane code
  #
   if { [string match "TURN" $mom_sim_nc_register(MACHINE_MODE)] } {
      set mom_sim_nc_register(PLANE) ZX
   } else {
      set mom_sim_nc_register(PLANE) XY
   }

  # Initialize CSYS state
  #
   global mom_sim_csys_set
   if { ![info exists mom_sim_csys_set] } {
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
   if { [string match "MM" $mom_sim_nc_register(UNIT)] } {
      PB_SIM_call SIM_set_mtd_units "MM"
   } else {
      PB_SIM_call SIM_set_mtd_units "INCH"
   }

  #--------------------------------
  # Set rotary axis direction mode.
  #--------------------------------
  #<11-07-11 gsl> Machine's kinematics may override the angular limits set in the post.
   global mom_sim_4th_axis_direction mom_sim_5th_axis_direction
   global mom_sim_4th_axis_max_limit mom_sim_5th_axis_max_limit
   global mom_sim_4th_axis_min_limit mom_sim_5th_axis_min_limit
   global mom_sim_4th_axis_has_limits mom_sim_5th_axis_has_limits

   if { [info exists mom_sim_lg_axis(4)] } {
      if { ![string match " " $mom_sim_4th_axis_direction] } {
         if { [string match "MAGNITUDE_DETERMINES_DIRECTION" $mom_sim_4th_axis_direction] } {

           # pb751(a) - Added "mom_sim_5th_axis_has_limits" condition
            if { [EQ_is_zero $mom_sim_4th_axis_min_limit] &&\
                 [EQ_is_equal $mom_sim_4th_axis_max_limit 360.0] &&\
                !$mom_sim_4th_axis_has_limits } {

               set mom_sim_4th_axis_direction "ALWAYS_SHORTEST"
            }
         }
         PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(4) $mom_sim_4th_axis_direction
      }
   }

   if { [info exists mom_sim_lg_axis(5)] } {
      if { ![string match " " $mom_sim_5th_axis_direction] } {
         if { [string match "MAGNITUDE_DETERMINES_DIRECTION" $mom_sim_5th_axis_direction] } {

           # pb751(a) - Added "mom_sim_5th_axis_has_limits" condition
            if { [EQ_is_zero $mom_sim_5th_axis_min_limit] &&\
                 [EQ_is_equal $mom_sim_5th_axis_max_limit 360.0] &&\
                !$mom_sim_5th_axis_has_limits } {

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


   if { ![info exists mom_sim_rapid_feed(X)] } {
      set mom_sim_rapid_feed(X) $mom_sim_rapid_feed_rate
   }
   if { ![info exists mom_sim_rapid_feed(Y)] } {
      set mom_sim_rapid_feed(Y) $mom_sim_rapid_feed_rate
   }
   if { ![info exists mom_sim_rapid_feed(Z)] } {
      set mom_sim_rapid_feed(Z) $mom_sim_rapid_feed_rate
   }
   if { ![info exists mom_sim_rapid_feed(4)] } {
      set mom_sim_rapid_feed(4) $mom_sim_rapid_feed_rate
   }
   if { ![info exists mom_sim_rapid_feed(5)] } {
      set mom_sim_rapid_feed(5) $mom_sim_rapid_feed_rate
   }

   if { ![info exists mom_sim_rapid_unit(X)] } {
      set mom_sim_rapid_unit(X) $mom_sim_nc_register(FEED_MODE)
   }
   if { ![info exists mom_sim_rapid_unit(Y)] } {
      set mom_sim_rapid_unit(Y) $mom_sim_nc_register(FEED_MODE)
   }
   if { ![info exists mom_sim_rapid_unit(Z)] } {
      set mom_sim_rapid_unit(Z) $mom_sim_nc_register(FEED_MODE)
   }
   if { ![info exists mom_sim_rapid_unit(4)] } {
      set mom_sim_rapid_unit(4) REV_PER_MIN
   }
   if { ![info exists mom_sim_rapid_unit(5)] } {
      set mom_sim_rapid_unit(5) REV_PER_MIN
   }


  # Default max rpm
   global mom_sim_default_spindle_max_rpm
   if { ![info exists mom_sim_default_spindle_max_rpm] } {
      set mom_sim_default_spindle_max_rpm 10000
   }

   if { ![info exists mom_sim_spindle_max_rpm] || ![EQ_is_gt $mom_sim_spindle_max_rpm 0.0] } {
      set mom_sim_spindle_max_rpm $mom_sim_default_spindle_max_rpm
   }


  #------------------------------------------------
  # Initialize parameters required by Sync Manager
  # for the components involved in this driver.
  #
   global mom_multi_channel_mode

   if { [info exists mom_multi_channel_mode] } {

      global mom_sim_delay_one_block
      set mom_sim_delay_one_block 0

     # In case sync manager is not yet initialized...
      global mom_sim_sync_manager_initialized
      if { ![info exists mom_sim_sync_manager_initialized] } {
         PB_SIM_call PB_CMD_vnc__start_of_program
      }
   }

  # pb902(a) - Moved code block out of mom_multi_channel_mode condition above
   global mom_sim_result mom_sim_result1
   PB_SIM_call SIM_ask_nc_axes_of_mtool

   set axes_list {X Y Z 4 5}
   foreach axis $axes_list {
      if { [info exists mom_sim_mt_axis($axis)] } {
         if { [lsearch $mom_sim_result1 $mom_sim_mt_axis($axis)] >= 0 } {
            PB_SIM_call SIM_mach_max_axis_rapid_velocity $mom_sim_mt_axis($axis) \
                                                         $mom_sim_rapid_feed($axis) \
                                                         $mom_sim_rapid_unit($axis)
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
     # set n_wcs [array size mom_sim_wcs_offsets]
      set n_wcs [array names mom_sim_wcs_offsets]

      foreach i $n_wcs {
         if { [llength $mom_sim_wcs_offsets($i)] == 5 } {
            set mom_sim_wcs_offsets($i) [PB_SIM_call VNC_map_from_machine_offsets $mom_sim_wcs_offsets($i)]
         }
      }


     # Offsets between MTCS and the main WCS
      global mom_sim_machine_zero_offsets
      if { ![info exists mom_sim_machine_zero_offsets] } {
         set mom_sim_machine_zero_offsets  [list 0.0 0.0 0.0]
      }


     # Define all Work Coordinate Systems
     #
      PB_SIM_call PB_CMD_vnc__define_wcs
   }


  # Initialize cut data type
   global mom_sim_cut_data_type
   if { ![info exists mom_sim_cut_data_type] } {
      set mom_sim_cut_data_type "CENTERLINE"
   }


  # Reset this var for each vnc
   VNC_unset_vars mom_sim_nc_register(TOOL_CHANGED)


  # Translate pivot jct to the plane of spindle axis
  # - We only need to do this for machines with rotary head.
  #
   global mom_sim_machine_type mom_sim_mt_axis
   global mom_sim_spindle_jct mom_sim_pivot_jct

   if { ![info exists mom_sim_pivot_jct] || [string match "" $mom_sim_pivot_jct] } {
return
   }


  # Turning tools can also be mounted into B-head.
  # pb603(a) -
   if { ![string match "*wedm*" $mom_sim_machine_type] } {

      if { [info exists mom_sim_mt_axis(4)] } {

         SIM_ask_axis_dof_junction $mom_sim_mt_axis(4)

         set axis_dof [expr abs($mom_sim_result1)]

         SIM_ask_init_junction_xform $mom_sim_pivot_jct

         set i 0
         foreach v $mom_sim_result {
            set pivot_jct_matrix($i) $v
            incr i
         }
         foreach v $mom_sim_result1 {
            set pivot_jct_matrix($i) $v
            incr i
         }

         set spindle_org [SIM_transform_point {0.0 0.0 0.0} $mom_sim_spindle_jct $mom_sim_pivot_jct]

         set x 0.0
         set y 0.0
         set z 0.0
         switch $axis_dof {
            1 {
               set x [lindex $spindle_org 0]
            }
            2 {
               set y [lindex $spindle_org 1]
            }
            default {
               set z [lindex $spindle_org 2]
            }
         }

         MTX3_xform_csys 0 0 0 $x $y $z pivot_jct_matrix

         set idx [string first "@" $mom_sim_pivot_jct]
         if { $idx >= 0 } {
            set pivot_comp [string range $mom_sim_pivot_jct 0 [expr $idx - 1]]
         } else {
            set pivot_comp $mom_sim_spindle_comp
         }

         set jct_origin [list]
         for { set i 9 } { $i < 12 } { incr i } {
            lappend jct_origin $pivot_jct_matrix($i)
         }

         set jct_matrix [list]
         for { set i 0 } { $i < 9 } { incr i } {
            lappend jct_matrix $pivot_jct_matrix($i)
         }

        # Redefine a pivot jct just for tracking NC codes
         set mom_sim_pivot_jct __SIM_PIVOT_JCT

         PB_SIM_call SIM_ask_is_junction_exist __SIM_PIVOT_JCT

         if { $mom_sim_result == 1 } {
            PB_SIM_call SIM_delete_junction $mom_sim_pivot_jct
         }

         eval PB_SIM_call SIM_create_junction $mom_sim_pivot_jct $pivot_comp $jct_origin $jct_matrix
      }
   } ;# Translate pivot
}




