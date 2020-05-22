########################### Virtual NC Controller ############################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006/2007, UGS/PLM Sol.   #
#                                                                            #
##############################################################################
#                       V N C _ C O M M O N _ V 6 0 0 . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains handlers for incremental VNC conversion.
#
##############################################################################


#=============================================================
proc PB_CMD_vnc__G_adjust_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list {mom_sim_nc_func(TL_ADJUST_PLUS)\
                 mom_sim_nc_func(TL_ADJUST_MINUS)\
                 mom_sim_nc_func(TL_ADJUST_CANCEL)}

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(TL_ADJUST_PLUS) code] } {

           # When there's been a tool change, reset ref junction.
           # We may need to retrieve the actual tool length, if any, from H register.

            set mom_sim_nc_register(TL_ADJUST) PLUS

         } elseif { [VNC_string_match mom_sim_nc_func(TL_ADJUST_MINUS) code] } {

            set mom_sim_nc_register(TL_ADJUST) MINUS

         } elseif { [VNC_string_match mom_sim_nc_func(TL_ADJUST_CANCEL) code] } {

            set mom_sim_nc_register(TL_ADJUST) OFF
         }

         break
      }
   }


  # Comp tool length when needed.
   if { $mom_sim_nc_register(TL_ADJUST) != "OFF" } {
      if { [info exists mom_sim_nc_register(TOOL_CHANGED)] } {
         unset mom_sim_nc_register(TOOL_CHANGED)

         global mom_sim_current_junction
         if { [info exists mom_sim_current_junction] } {
            PB_SIM_call VNC_set_current_ref_junction $mom_sim_current_junction
         }

        # Restore ref jct to tool
         global mom_sim_tool_junction mom_sim_current_tool_junction mom_sim_current_junction
         set mom_sim_tool_junction "$mom_sim_current_tool_junction"
         set mom_sim_current_junction "$mom_sim_tool_junction"
      }
   }
}


#=============================================================
proc PB_CMD_vnc__G_cutcom_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list {mom_sim_nc_func(CUTCOM_LEFT)\
                 mom_sim_nc_func(CUTCOM_RIGHT)\
                 mom_sim_nc_func(CUTCOM_OFF)}

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(CUTCOM_LEFT) code] } {

            set mom_sim_nc_register(CUTCOM) LEFT

         } elseif { [VNC_string_match mom_sim_nc_func(CUTCOM_RIGHT) code] } {

            set mom_sim_nc_register(CUTCOM) RIGHT

         } elseif { [VNC_string_match mom_sim_nc_func(CUTCOM_OFF) code] } {

            set mom_sim_nc_register(CUTCOM) OFF
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__G_feed_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   if { [string match "IN" $mom_sim_nc_register(UNIT)] } {

      set codes_list [list]

      set var_list {mom_sim_nc_func(FEED_IPM)\
                    mom_sim_nc_func(FEED_IPR)\
                    mom_sim_nc_func(FEED_FRN)}

      foreach var $var_list {
        if { [info exists $var] } {
          lappend codes_list [set $var]
        }
      }

      global mom_sim_o_buffer
      foreach code $codes_list {

         if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

            if { [VNC_string_match mom_sim_nc_func(FEED_IPM) code] } {

               set mom_sim_nc_register(FEED_MODE) INCH_PER_MIN

            } elseif { [VNC_string_match mom_sim_nc_func(FEED_IPR) code] } {

               set mom_sim_nc_register(FEED_MODE) INCH_PER_REV

            } elseif { [VNC_string_match mom_sim_nc_func(FEED_FRN) code] } {

               set mom_sim_nc_register(FEED_MODE) MM_PER_100REV
            }

         break
        }
      }

   } elseif { [string match "MM" $mom_sim_nc_register(UNIT)] } {

      set codes_list [list]

      set var_list {mom_sim_nc_func(FEED_MMPM)\
                    mom_sim_nc_func(FEED_MMPR)\
                    mom_sim_nc_func(FEED_FRN)}

      foreach var $var_list {
        if { [info exists $var] } {
          lappend codes_list [set $var]
        }
      }

      global mom_sim_o_buffer
      foreach code $codes_list {

         if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

            if { [VNC_string_match mom_sim_nc_func(FEED_MMPM) code] } {

               set mom_sim_nc_register(FEED_MODE) MM_PER_MIN

            } elseif { [VNC_string_match mom_sim_nc_func(FEED_MMPR) code] } {

               set mom_sim_nc_register(FEED_MODE) MM_PER_REV

            } elseif { [VNC_string_match mom_sim_nc_func(FEED_FRN) code] } {

               set mom_sim_nc_register(FEED_MODE) MM_PER_100REV
            }

           break
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__G_misc_code { } {
#=============================================================
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
   set wcs_list [lreplace $wcs_list $ind $ind]

   set wcsvar_list [list]

   foreach wcs $wcs_list {
      lappend wcsvar_list mom_sim_nc_func(WORK_CS_$wcs)
   }

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

               if { [string match "ABS" $mom_sim_nc_register(INPUT)] } {

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
            }

         } else {

           foreach wcs $wcs_list {
              if { [string match "[set mom_sim_nc_func(WORK_CS_$wcs)]" $code] } {
                # Set the value of nc register according to different WCS
                 set mom_sim_nc_register(WCS) $wcs

                 set mom_sim_nc_register(WORK_OFFSET) [PB_SIM_call \
                 VNC_map_to_machine_offsets $mom_sim_wcs_offsets($mom_sim_nc_register(WCS))]
              }
              break
            }
         }

         if { [info exists mom_sim_csys_data] } {

            if { [VNC_string_match mom_sim_nc_func(MACH_CS_MOVE) code] } {

            } else {

               foreach wcs $wcs_list {
                  if { [string match "[set mom_sim_nc_func(WORK_CS_$wcs)]" $code] } {

                    # Zero local offsets when change WCS
                     set mom_sim_nc_register(LOCAL_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]

                    # Zero WCS offsets, since the actual CSYS will be referenced.
                     set mom_sim_nc_register(WORK_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]

                    # Fetch actual WCS matrix per WCS selection by G54 - G59 code.
                     global mom_sim_csys_matrix

                     for { set i 0 } { $i < 12 } { incr i } {
                        set mom_sim_csys_matrix($i) $mom_sim_csys_data($mom_sim_nc_register(WCS),$i)
                     }

                     PB_SIM_call PB_CMD_vnc__set_kinematics

                     global mom_sim_csys_set
                     set mom_sim_csys_set 1

                    # Update mom_sim_pos w.r.t new ref jct
                     PB_SIM_call VNC_update_sim_pos

                    # Flag to reset (adjust) the start position in next motion. (See PB_CMD_vnc__sim_motion)
                     set mom_sim_nc_register(FIXTURE_OFFSET) 1
                  }

                  break
               }
            }
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__G_mode_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list {mom_sim_nc_func(INPUT_ABS)\
                 mom_sim_nc_func(INPUT_INC)}

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(INPUT_ABS) code] } {

            set mom_sim_nc_register(INPUT) ABS

         } elseif { [VNC_string_match mom_sim_nc_func(INPUT_INC) code] } {

            set mom_sim_nc_register(INPUT) INC
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
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(MOTION_RAPID)                  code] } {

            set mom_sim_nc_register(MOTION) "RAPID"

         } elseif { [VNC_string_match mom_sim_nc_func(MOTION_LINEAR)           code] } {

            set mom_sim_nc_register(MOTION) "LINEAR"

         } elseif { [VNC_string_match mom_sim_nc_func(MOTION_CIRCULAR_CLW)     code] } {

            set mom_sim_nc_register(MOTION) "CIRCULAR_CLW"

         } elseif { [VNC_string_match mom_sim_nc_func(MOTION_CIRCULAR_CCLW)    code] } {

            set mom_sim_nc_register(MOTION) "CIRCULAR_CCLW"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_DRILL)             code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_DRILL"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_DRILL_DWELL)       code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_DRILL_DWELL"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_DRILL_DEEP)        code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_DRILL_DEEP"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_DRILL_BREAK_CHIP)  code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_DRILL_BREAK_CHIP"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_TAP)               code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_TAP"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE)              code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE_DRAG)         code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_DRAG"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE_NO_DRAG)      code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_NO_DRAG"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE_BACK)         code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_BACK"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE_MANUAL)       code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_MANUAL"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE_MANUAL_DWELL) code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_MANUAL_DWELL"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_START)             code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_START"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_OFF)               code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_OFF"

           # Cycle Off - force tool to move to the initial pt (entry pos) of next set of holes.
            global mom_sim_pos mom_sim_cycle_retract_to_pos
            if { [info exists mom_sim_cycle_retract_to_pos] } {
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
proc PB_CMD_vnc__G_plane_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func
  global mom_sim_cycle_spindle_axis


   set codes_list [list]

   set var_list {mom_sim_nc_func(PLANE_XY)\
                 mom_sim_nc_func(PLANE_YZ)\
                 mom_sim_nc_func(PLANE_ZX)}

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(PLANE_XY)        code] } {

            set mom_sim_nc_register(PLANE) XY
            set mom_sim_cycle_spindle_axis 2

         } elseif { [VNC_string_match mom_sim_nc_func(PLANE_YZ)  code] } {

            set mom_sim_nc_register(PLANE) YZ
            set mom_sim_cycle_spindle_axis 0

         } elseif { [VNC_string_match mom_sim_nc_func(PLANE_ZX)  code] } {

            set mom_sim_nc_register(PLANE) ZX
            set mom_sim_cycle_spindle_axis 1
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__G_spindle_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   if { [string match "IN" $mom_sim_nc_register(UNIT)] } {

      set codes_list [list]

      set var_list {mom_sim_nc_func(SPEED_SFM)\
                    mom_sim_nc_func(SPEED_RPM)}

      foreach var $var_list {
        if { [info exists $var] } {
          lappend codes_list [set $var]
        }
      }

      global mom_sim_o_buffer
      foreach code $codes_list {

         if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

            if { [VNC_string_match mom_sim_nc_func(SPEED_SFM)        code] } {

               set mom_sim_nc_register(SPINDLE_MODE) SFM

            } elseif { [VNC_string_match mom_sim_nc_func(SPEED_RPM)  code] } {

               set mom_sim_nc_register(SPINDLE_MODE) REV_PER_MIN
            }

            break
         }
      }

   } else {

      set codes_list [list]

      set var_list {mom_sim_nc_func(SPEED_SMM)\
                    mom_sim_nc_func(SPEED_RPM)}

      foreach var $var_list {
        if { [info exists $var] } {
          lappend codes_list [set $var]
        }
      }

      global mom_sim_o_buffer
      foreach code $codes_list {

         if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

            if { [VNC_string_match mom_sim_nc_func(SPEED_SMM)        code] } {

               set mom_sim_nc_register(SPINDLE_MODE) SMM

            } elseif { [VNC_string_match mom_sim_nc_func(SPEED_RPM)  code] } {

               set mom_sim_nc_register(SPINDLE_MODE) REV_PER_MIN
            }

            break
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__M_coolant_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list {mom_sim_nc_func(COOLANT_ON)\
                 mom_sim_nc_func(COOLANT_FLOOD)\
                 mom_sim_nc_func(COOLANT_MIST)\
                 mom_sim_nc_func(COOLANT_TAP)\
                 mom_sim_nc_func(COOLANT_OFF)\
                 mom_sim_nc_func(COOLANT_THRU)}

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(COOLANT_OFF) code] } {
            PB_SIM_call SIM_set_coolant OFF
         } else {
            PB_SIM_call SIM_set_coolant ON
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__M_misc_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list {mom_sim_nc_func(PROG_STOP)\
                 mom_sim_nc_func(PROG_OPSTOP)\
                 mom_sim_nc_func(PROG_END)\
                 mom_sim_nc_func(TOOL_CHANGE)\
                 mom_sim_nc_func(PROG_STOP_REWIND)}

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer

   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(PROG_STOP)         code] } {

         } elseif { [VNC_string_match mom_sim_nc_func(PROG_OPSTOP) code] } {

         } elseif { [VNC_string_match mom_sim_nc_func(PROG_END)    code] } {

           # Reset following functions on NC controller to the initial state.
           # (Fanuc System 9 Series)
           #
           #  G22 - Store stroke limit function ON
           #  G40 - Cutcom OFF
           #  G49 - Tool length adjust OFF
           #  G50 - Scaling OFF
           #  G54 - Work coordinate system 1
           #  G64 - Cutting mode
           #  G67 - Macro modal call cancel
           #  G69 - Coordinate system rotation OFF
           #  G80 - Canned cycle cancel
           #  G98 - Return to initial level (cycle)

            PB_SIM_call VNC_reset_controller

         } elseif { [VNC_string_match mom_sim_nc_func(TOOL_CHANGE)      code] } {

            PB_SIM_call VNC_tool_change

         } elseif { [VNC_string_match mom_sim_nc_func(PROG_STOP_REWIND) code] } {

            PB_SIM_call VNC_rewind_stop_program

         } else {
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__M_spindle_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list {mom_sim_nc_func(SPINDLE_CLW)\
                 mom_sim_nc_func(SPINDLE_CCLW)\
                 mom_sim_nc_func(SPINDLE_OFF)}

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(SPINDLE_CLW)        code] } {

            set mom_sim_nc_register(SPINDLE_DIRECTION) CLW

         } elseif { [VNC_string_match mom_sim_nc_func(SPINDLE_CCLW) code] } {

            set mom_sim_nc_register(SPINDLE_DIRECTION) CCLW

         } elseif { [VNC_string_match mom_sim_nc_func(SPINDLE_OFF)  code] } {

            set mom_sim_nc_register(SPINDLE_DIRECTION) OFF
         }

         break
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

  # Apply mirror factors to axis direction for all cases.
   global mom_sim_x_factor mom_sim_y_factor mom_sim_z_factor

   set axis_direction 1

   if [string match "*head*" $mom_sim_machine_type] {
      switch $mom_sim_4th_axis_plane {
         "ZX" {
          # Change axis direction only when it coincides with principal plane direction.
           if { $mom_sim_cycle_spindle_axis == 1 } {
            if [EQ_is_equal $mom_sim_nc_register(fourth_axis) -90.0] {
               set axis_direction -1
            }
            set axis_direction [expr $mom_sim_y_factor * $axis_direction]
           }
         }
         "YZ" {
           if { $mom_sim_cycle_spindle_axis == 0 } {
            if [EQ_is_equal $mom_sim_nc_register(fourth_axis) 90.0] {
               set axis_direction -1
            }
            set axis_direction [expr $mom_sim_x_factor * $axis_direction]
           }
         }
         "XY" {
           if { $mom_sim_cycle_spindle_axis == 2 } {
            set axis_direction [expr $mom_sim_z_factor * $axis_direction]
           }
         }
      }
   }

   if [string match "5_axis_dual_head" $mom_sim_machine_type] {
      switch $mom_sim_5th_axis_plane {
         "ZX" {
           if { $mom_sim_cycle_spindle_axis == 1 } {
            if [EQ_is_equal $mom_sim_nc_register(fifth_axis) -90.0] {
               set axis_direction -1
            }
            set axis_direction [expr $mom_sim_y_factor * $axis_direction]
           }
         }
         "YZ" {
           if { $mom_sim_cycle_spindle_axis == 0 } {
            if [EQ_is_equal $mom_sim_nc_register(fifth_axis) 90.0] {
               set axis_direction -1
            }
            set axis_direction [expr $mom_sim_x_factor * $axis_direction]
           }
         }
         "XY" {
           if { $mom_sim_cycle_spindle_axis == 2 } {
            set axis_direction [expr $mom_sim_z_factor * $axis_direction]
           }
         }
      }
   }

  # Determine axis direction for XZC mill-turn
   if { [string match "3_axis_mill_turn" $mom_sim_machine_type] } {
      if { $mom_sim_cycle_spindle_axis == 0 } {
         set axis_direction [expr $mom_sim_x_factor * $axis_direction]
      }
   }


  # Grab prev pos as entry pos
   foreach i { 0 1 2 } {
      set mom_sim_cycle_entry_pos($i) $mom_sim_prev_pos($i)
   }


  # nc_register(K_cycle) may never be set, since it's in conflict with nc_register(K).
   if { [info exists mom_sim_nc_register(K)] } {
      set mom_sim_nc_register(K_cycle) $mom_sim_nc_register(K)
   }

   if { ![info exists mom_sim_nc_register(K_cycle)] } {
      set mom_sim_nc_register(K_cycle) 0
   }

   if { ![info exists mom_sim_nc_register(R)] } {
      set mom_sim_nc_register(R) 0
   }

  # Initialize registers in case...
   if { ![info exists mom_sim_nc_register(X)] } {
      set mom_sim_nc_register(X) 0.0
   }
   if { ![info exists mom_sim_nc_register(Y)] } {
      set mom_sim_nc_register(Y) 0.0
   }
   if { ![info exists mom_sim_nc_register(Z)] } {
      set mom_sim_nc_register(Z) 0.0
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

        #<08-09-06 gsl> Recalculate top of hole per bottom. May not be needed???
         set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) \
             [expr $mom_sim_cycle_feed_to_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_feed_to_dist]
      }
   }


  # Initialize rapid-to pos to feed-to pos
   set mom_sim_cycle_rapid_to_pos(0) $mom_sim_cycle_feed_to_pos(0)
   set mom_sim_cycle_rapid_to_pos(1) $mom_sim_cycle_feed_to_pos(1)
   set mom_sim_cycle_rapid_to_pos(2) $mom_sim_cycle_feed_to_pos(2)

   if { [string match "*R -*" $mom_sim_cycle_mode(rapid_to)] } {
      if { [string match "*Distance*" $mom_sim_cycle_mode(rapid_to)] } {
#>>>
        # The 1st hole may have been @ rapid-to pos already.
         set mom_sim_cycle_rapid_to_dist [expr $mom_sim_nc_register(R) * $axis_direction]

         if { [EQ_is_equal $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) $mom_sim_pos($mom_sim_cycle_spindle_axis)] } {

           #<08-08-06 gsl> May not be needed or a bug
           if 0 {
            set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) \
                [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) - $mom_sim_cycle_rapid_to_dist]
           }
         }

         set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) \
             [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_rapid_to_dist]

      } else {
         set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(R)
      }
   }


  # pb600 -
  # - Compensate for no retract-to condition
  #
   if { $axis_direction > 0 } {
      if { $mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) <= $mom_sim_cycle_feed_to_pos($mom_sim_cycle_spindle_axis) } {
         set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis)
      }
   } elseif { $axis_direction < 0 } {
      if { $mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) >= $mom_sim_cycle_feed_to_pos($mom_sim_cycle_spindle_axis) } {
         set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis)
      }
   }


  # Initialize retract-to pos
   set mom_sim_cycle_retract_to_pos(0) $mom_sim_cycle_rapid_to_pos(0)
   set mom_sim_cycle_retract_to_pos(1) $mom_sim_cycle_rapid_to_pos(1)
   set mom_sim_cycle_retract_to_pos(2) $mom_sim_cycle_rapid_to_pos(2)

   if { [string match "K*" $mom_sim_cycle_mode(retract_to)] } {
      if { [string match "*Distance*" $mom_sim_cycle_mode(retract_to)] } {
#>>>
        # The 1st hole may have been @ rapid-to pos already.
         set mom_sim_cycle_retract_to_dist [expr abs($mom_sim_nc_register(K_cycle)) * $axis_direction]

         if { [EQ_is_equal $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) $mom_sim_pos($mom_sim_cycle_spindle_axis)] } {

           #<08-09-06 gsl> Same reason for R word
           if 0 {
            set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) \
                [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) - $mom_sim_cycle_retract_to_dist]
           }
         }

         set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) \
             [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_retract_to_dist]

      } else {
         set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(K_cycle)
      }

   } elseif { [string match "G98/G99*" $mom_sim_cycle_mode(retract_to)] } {

      global mom_sim_nc_func

     # G98 - Retract to last Z before cycle
      if { [VNC_parse_nc_word mom_sim_o_buffer $mom_sim_nc_func(CYCLE_RETURN_AUTO) 1] } {

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

  #-----------------------------------------------------------
  proc VNC_pause { args } {
  #-----------------------------------------------------------
   global env
   if { [info exists env(PB_SUPPRESS_UGPOST_DEBUG)]  &&  $env(PB_SUPPRESS_UGPOST_DEBUG) == 1 } {
  return
   }

   global gPB
   if { [info exists gPB(PB_disable_VNC_pause)]  &&  $gPB(PB_disable_VNC_pause) == 1 } {
  return
   }


   set cam_aux_dir  [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]

   global tcl_platform

   if { [string match "*windows*" $tcl_platform(platform)] } {
     set ug_wish "ugwish.exe"
   } else {
     set ug_wish ugwish
   }

   if { [file exists ${cam_aux_dir}$ug_wish] &&\
        [file exists ${cam_aux_dir}mom_pause.tcl] } {

     set title ""
     set msg ""

     if { [llength $args] == 1 } {
       set msg [lindex $args 0]
     }

     if { [llength $args] > 1 } {
       set title [lindex $args 0]
       set msg [lindex $args 1]
     }

     set res [exec ${cam_aux_dir}$ug_wish ${cam_aux_dir}mom_pause.tcl $title $msg]
     switch $res {
       no {
          set gPB(PB_disable_VNC_pause) 1
       }
       cancel {
          PB_SIM_call SIM_mtd_reset
          uplevel #0 {
             MOM_abort "*** User Abort *** "
          }
       }
       default { return }
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
      if { ![catch {set pos [PB_SIM_call SIM_ask_last_position_zcs]} ] } {
         global mom_sim_pos
         set mom_sim_pos(0) [lindex $pos 0]
         set mom_sim_pos(1) [lindex $pos 1]
         set mom_sim_pos(2) [lindex $pos 2]
      }
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
        set msg [lindex $args 0]
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


# Install this command only when absent.
#
if { [llength [info commands "PB_CMD_vnc__define_user_misc_procs"]] == 0 } {
#
#=============================================================
proc PB_CMD_vnc__define_user_misc_procs { } {
#=============================================================
 uplevel #0 {
 }
}
} ;# if


#=============================================================
proc PB_CMD_vnc__configure_isv_qc { } {
#=============================================================
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
   set mom_sim_isv_qc       0     ;# 1=ON, 0=OFF
   set mom_sim_isv_qc_file  ""    ;# "" or "listing_device"
   set mom_sim_isv_qc_mode  11110 ;# 10000 = SIM, 01000 = VNC, 00100 = PB_CMD, 00010 = Others, 00001 = mom_sim_pos
}


#=============================================================
proc PB_CMD_vnc__init_isv_qc { } {
#=============================================================
#
# *** DO NOT rename or remove this command!
#

  global mom_sim_isv_qc mom_sim_isv_qc_file mom_sim_isv_qc_mode


   if { [llength [info commands "PB_CMD_vnc__configure_isv_qc"]] } {
      PB_CMD_vnc__configure_isv_qc
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
   if { $mom_sim_isv_qc_mode == "" } {
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

        # Do this in vnc_base for every block buffer!
        if 0 {
         if { $i == 0 } {
            if { $command == "VNC_sim_nc_block" || $command == "VNC_parse_motion_word" } {
               set arg [VNC_escape_special_chars $arg]
            }
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
         if { ![string match "SIM_*" $command] && ![string match "VNC_*" $command] && ![string match "PB_CMD_*" $command] } {
            PB_SIM_output_qc_cmd_string $cmd_string
         }
      }
   }

   global mom_sim_message
   set val ""

  # Verify existence of the command
   if { ![llength [info commands "$command"]] } {
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
   if { [catch { set val [eval $cmd_string] } sta] } {
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
        "   set mom_sim_travel_delta \$delta"\
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
   global mom_sim_4th_axis_direction mom_sim_5th_axis_direction
   global mom_sim_4th_axis_max_limit mom_sim_5th_axis_max_limit
   global mom_sim_4th_axis_min_limit mom_sim_5th_axis_min_limit

   if { [info exists mom_sim_lg_axis(4)] } {
      if { ![string match " " $mom_sim_4th_axis_direction] } {
         if { [string match "MAGNITUDE_DETERMINES_DIRECTION" $mom_sim_4th_axis_direction] } {
            if { [EQ_is_zero $mom_sim_4th_axis_min_limit] && [EQ_is_equal $mom_sim_4th_axis_max_limit 360.0] } {
               set mom_sim_4th_axis_direction "ALWAYS_SHORTEST"
            }
         }
         PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(4) $mom_sim_4th_axis_direction
      }
   }
   if { [info exists mom_sim_lg_axis(5)] } {
      if { ![string match " " $mom_sim_5th_axis_direction] } {
         if { [string match "MAGNITUDE_DETERMINES_DIRECTION" $mom_sim_5th_axis_direction] } {
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


      global mom_sim_result mom_sim_result1
      PB_SIM_call SIM_ask_nc_axes_of_mtool

      set axes_list {X Y Z 4 5}
      foreach axis $axes_list {
         if { [info exists mom_sim_mt_axis($axis)] } {
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
   VNC_unset_vars  mom_sim_nc_register(TOOL_CHANGED)


  # Translate pivot jct to the plane of spindle axis
  # - We only need to do this for machines with rotary head.
  #
   global mom_sim_machine_type mom_sim_mt_axis
   global mom_sim_spindle_jct mom_sim_pivot_jct

   if { ![info exists mom_sim_pivot_jct] || [string match "" $mom_sim_pivot_jct] } {
return
   }

   if { [string match "*axis_head*" $mom_sim_machine_type] ||\
        [string match "*lathe*" $mom_sim_machine_type] } {

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


if { [llength [info commands PB_CMD_vnc____init_machine_tool_axes]] == 0 } {
#
# Define what's not configured via UI
#=============================================================
proc PB_CMD_vnc____init_machine_tool_axes { } {
#=============================================================
# - Do not change the name of this command!
#
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Specify kinematic components to be used as the ZCS
  # reference base :
  #
  #
  #   mom_sim_zcs_base_MCS - Main Coordinate System
  #   mom_sim_zcs_base_LCS - Local Coordinate System
  #
  #
  # mom_sim_zcs_base_MSC, normally, is a non-rotating
  # component that the part (work piece) is directly or
  # indirectly connected to in the kinematics tree.
  # If no local coordinate system programming (i.e. G68.1) is
  # used, only the mom_sim_zcs_base_MSC needs to be specified.
  #
  # mom_sim_zcs_base_LCS is to be specified, when needed,
  # with the component that rotates to form the local
  # coordinate system. It's default to "".
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_sim_zcs_base_MCS mom_sim_zcs_base_LCS

  # set mom_sim_zcs_base_LCS  "$mom_sim_zcs_base_MCS"
  # set mom_sim_zcs_base_LCS  ""


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Additional angle to rotate turret when tools are indexed
  # for sub-spindle.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_sim_add_turret_angle

  # set mom_sim_add_turret_angle 0.0


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Define the pivot junction for a machine with rotary heads.
  # It's default to the spindle junction.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_sim_pivot_jct

  # set mom_sim_pivot_jct "$mom_sim_spindle_jct"
  # set mom_sim_pivot_jct "X_SLIDE@B_ROT_JCT"


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Set this variable to disable the automatic tool length
  # compensation @ tool change until a G43 (or equivalent)
  # function is encountered.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_sim_tool_length_comp_auto

  # set mom_sim_tool_length_comp_auto 0


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Customize this VNC to handle more degrees of kinematics
  # than what the post is composed for.
  # - This is useful for programming a lathe on a mill-turn machine.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_sim_num_machine_axes
   global mom_sim_mt_axis
   global mom_sim_reverse_4th_table mom_sim_4th_axis_has_limits
   global mom_sim_reverse_5th_table mom_sim_5th_axis_has_limits

  if 0 {
   set mom_sim_num_machine_axes  4

   set mom_sim_mt_axis(X)                             "X"
   set mom_sim_mt_axis(Y)                             "Y"
   set mom_sim_mt_axis(Z)                             "Z"

   switch $mom_sim_num_machine_axes {
      "4" {
         set mom_sim_mt_axis(4)                       "B"
         set mom_sim_reverse_4th_table                "0"
         set mom_sim_4th_axis_has_limits              "1"
      }
      "5" {
         set mom_sim_mt_axis(4)                       "B"
         set mom_sim_reverse_4th_table                "0"
         set mom_sim_4th_axis_has_limits              "1"
         set mom_sim_mt_axis(5)                       "C"
         set mom_sim_reverse_5th_table                "0"
         set mom_sim_5th_axis_has_limits              "1"
      }
   }
  }
}
} ;# if


if { [llength [info commands PB_CMD_vnc____init_nc_definitions]] == 0 } {
#
# Define what's not configured via UI
#=============================================================
proc PB_CMD_vnc____init_nc_definitions { } {
#=============================================================
   global mom_sim_spindle_max_rpm mom_sim_spindle_speed
   global mom_sim_default_spindle_max_rpm
   global mom_sim_tool_number

   set mom_sim_spindle_max_rpm          0
   set mom_sim_default_spindle_max_rpm  10000
   set mom_sim_spindle_speed            0


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # OPSKIP is enabled by default
  # - It's possible to provide a Tk dialog to allow user's
  #   toggle @ ISV runtime
  #
   global mom_sim_opskip_mode

   set mom_sim_opskip_mode 1


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # File to collect debug messages when calling
  # PB_VNC_output_debug_msg msg. Debug messages and file will
  # not be generated, if this variable is not defined or set
  # to an empty string.
  #
   global mom_sim_isv_debug_msg_file

  # set mom_sim_isv_debug_msg_file "listing_device"
  # set mom_sim_isv_debug_msg_file "C:\\\\__ISV_debug.log"


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Initialize cycle spindle axis to Z
  #
   global mom_sim_cycle_spindle_axis
   set mom_sim_cycle_spindle_axis 2


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Switch to collect VNC parameters from CAM objects
  #
   global mom_sim_output_extended_nc
   set mom_sim_output_extended_nc       "0"


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Assumed initial settings of controller
  #
   if { ![info exists mom_sim_nc_register(STROKE_LIMIT)] } {
      set mom_sim_nc_register(STROKE_LIMIT) ON
   }
   if { ![info exists mom_sim_nc_register(CUTCOM)] } {
      set mom_sim_nc_register(CUTCOM) OFF
   }
   if { ![info exists mom_sim_nc_register(CYCLE_RETURN)] } {
      set mom_sim_nc_register(CYCLE_RETURN) INIT_LEVEL
   }
}
} ;# if


# Install this command only when absent.
#
if { [llength [info commands "PB_CMD_vnc____process_nc_block"]] == 0 } {
#
# This should have been PB generated handler.
#=============================================================
proc PB_CMD_vnc____process_nc_block { } {
#=============================================================
   global mom_sim_o_buffer
   global mom_sim_pre_com_list
   global mom_sim_o_buffer

   set o_buff $mom_sim_o_buffer

   if { [llength [info commands PB_CMD_vnc__preprocess_nc_block]] } {
      PB_SIM_call PB_CMD_vnc__preprocess_nc_block
   }

   if { [string match "*G04*" $o_buff ] } {
      PB_SIM_call PB_CMD_vnc__G04
   }
   if { [string match "*T*" $o_buff ] } {
      PB_SIM_call PB_CMD_vnc__T
   }

return $o_buff
}
}


#=============================================================
proc PB_CMD_vnc__offset_tool_jct { } {
#=============================================================
# Offsets supplied in Tool Junction coordinate
#
  global mom_sim_tool_x_offset mom_sim_tool_y_offset mom_sim_tool_z_offset

  global mom_sim_current_junction
  global mom_sim_tool_junction
  global mom_sim_curr_jct_matrix mom_sim_curr_jct_origin
  global mom_sim_result mom_sim_result1


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


   if { ![expr (abs($mom_sim_tool_x_offset) +\
                abs($mom_sim_tool_y_offset) +\
                abs($mom_sim_tool_z_offset)) == 0.0] } {


global mom_sim_message
set mom_sim_message "**TOOL JCT OFFSET: before $mom_sim_tool_x_offset $mom_sim_tool_y_offset $mom_sim_tool_z_offset"
PB_CMD_vnc__send_message

      PB_SIM_call SIM_ask_init_junction_xform $mom_sim_tool_junction
      set mom_sim_curr_jct_matrix "$mom_sim_result"
      set mom_sim_curr_jct_origin "$mom_sim_result1"


     # - Xform offset
      set xval $mom_sim_tool_x_offset
      set yval $mom_sim_tool_y_offset
      set zval $mom_sim_tool_z_offset
      set vec [list $xval $yval $zval]
      set toff [SIM_transform_vector $vec $mom_sim_tool_junction __SIM_ACS_JCT]
      set xval [lindex $toff 0]
      set yval [lindex $toff 1]
      set zval [lindex $toff 2]

global mom_sim_message
set mom_sim_message "**TOOL JCT OFFSET: after  $xval $yval $zval"
PB_CMD_vnc__send_message


      set xval [expr [lindex $mom_sim_curr_jct_origin 0] - $xval]
      set yval [expr [lindex $mom_sim_curr_jct_origin 1] - $yval]
      set zval [expr [lindex $mom_sim_curr_jct_origin 2] - $zval]

      set mom_sim_curr_jct_origin [list $xval $yval $zval]

      set mom_sim_tool_junction ""

      PB_SIM_call VNC_create_tmp_jct

      set mom_sim_tool_junction "$mom_sim_current_junction"
   }
}


#=============================================================
proc PB_CMD_vnc__output_param_msg { } {
#=============================================================
  global mom_sim_message
  global mom_sim_output_vnc_msg

   if { ![info exists mom_sim_output_vnc_msg] } {
      set mom_sim_output_vnc_msg 0
   }

  # Direct VNC msg to the NC setup data file
   global mom_sim_output_extended_nc
   global ptp_file_name
   if { [info exists mom_sim_output_extended_nc] && $mom_sim_output_extended_nc } {
      set setup_data_file [file rootname [file tail $ptp_file_name]]_setup.dat

      MOM_close_output_file  $ptp_file_name
      MOM_open_output_file   $setup_data_file

      set saved_output_vnc_msg $mom_sim_output_vnc_msg
      set mom_sim_output_vnc_msg 0
   }


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Use MOM_output_literal to display operator messages in NC window
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   if $mom_sim_output_vnc_msg {
      MOM_output_literal $mom_sim_message
   } else {
      MOM_output_text $mom_sim_message
   }


   if { [info exists mom_sim_output_extended_nc] && $mom_sim_output_extended_nc } {
      MOM_close_output_file $setup_data_file
      MOM_open_output_file  $ptp_file_name

      set mom_sim_output_vnc_msg $saved_output_vnc_msg
   }
}


#=============================================================
proc PB_CMD_vnc__rapid_move { } {
#=============================================================
  global mom_sim_rapid_feed_rate
  global mom_tool_axis
  global mom_sim_rapid_dogleg
  global mom_sim_pos mom_sim_prev_pos
  global mom_sim_max_dpm
  global mom_sim_lg_axis

   if $mom_sim_rapid_dogleg {

      if { [info exists mom_sim_lg_axis(5)] } {
         set num 5
      } elseif { [info exists mom_sim_lg_axis(4)] } {
         set num 4
      } else {
         set num 3
      }

      for { set i 0 } { $i < $num } { incr i } {

         set mom_sim_save_pos($i) $mom_sim_pos($i)

         set tol [expr $mom_sim_pos($i) - $mom_sim_prev_pos($i)]
         if { [EQ_is_gt $tol 0.0] } {
            set fac($i) 1
         } elseif { [EQ_is_equal $tol 0.0] } {
            set fac($i) 0
         } else {
            set fac($i) -1
         }
         if { $i< 3} {
           # Linear Axes
            set rapid_speed $mom_sim_rapid_feed_rate
         } else {
           # Rotary Axes
            if { [info exists mom_sim_max_dpm] } {
               set rapid_speed $mom_sim_max_dpm
            } else {
               set rapid_speed 0.0
            }
         }
         if {![EQ_is_equal $rapid_speed 0.0] } {
            set t($i) [expr abs($mom_sim_pos($i) - $mom_sim_prev_pos($i)) / $rapid_speed]
         } else {
            set t($i) 0.0
         }
      }

     # Sort time required for each linear axis
      set t_list [list]
      set t_num [array names t]
      foreach num $t_num {
         lappend t_list $t($num)
      }

      set t_list [lsort -real $t_list]

      set t_order [list]
      foreach i {0 1 2 3 4} {
         if {[info exists t($i)]} {
            set idx [lsearch $t_list $t($i)]
            while { [lsearch $t_order $idx] >= 0 } {
               incr idx
            }
            lappend t_order $idx
         }
      }

      set act_list $t_order


      ######################
      # Rapid Move Segments
      ######################
      for { set j 0 } { $j < $num } { incr j } {
         set long_ind [lindex $t_order $j]
         set long_t $t($long_ind)

         if { $j == 0 } {
            set short_t 0.0
         } else {
            set short_ind [lindex $t_order [expr $j - 1]]
            set short_t $t($short_ind)
         }
         set t_gap($j) [expr $long_t - $short_t]

         for { set i 0 } { $i < $num } { incr i } {
            if { [lsearch $act_list $i] >= 0 } {
               set mom_sim_pos($i) [expr $mom_sim_prev_pos($i) + $fac($i) * $rapid_speed * $t_gap($j)]
            } else {
               set mom_sim_pos($i) $mom_sim_prev_pos($i)
            }
         }

         set int      [lsearch $act_list $long_ind]
         set act_list [lreplace $act_list $int $int]

         PB_CMD_vnc__rapid_segment

         if { $j == [expr $num - 1] } {
            for { set p 0 } { $p < $num } { incr p } {
               if {![EQ_is_equal $mom_sim_pos($p) $mom_sim_save_pos($p)] } {
                  break
               }
            }
         } else {
            for { set q 0 } { $q < 7 } { incr q } {
               set mom_sim_prev_pos($q) $mom_sim_pos($q)
            }
         }
      }

   } else {

      PB_CMD_vnc__rapid_segment
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
         lappend coord_list $mom_sim_lg_axis(4)  $mom_sim_pos(3)
      set pattern [expr $pattern + 10]
      }
   }
   if { [info exists mom_sim_lg_axis(5)] } {
      if { [expr $mom_sim_pos(4) != $mom_sim_prev_pos(4)] } {
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
      1 { ;# Pure 5th axis rotation -

         PB_SIM_call SIM_move_rotary_axis [expr $mom_sim_pos(4)/$mom_sim_max_dpm] $mom_sim_mt_axis(5) $mom_sim_pos(4)
         PB_SIM_call SIM_update
         PB_SIM_call VNC_update_sim_pos

         set pattern 0
      }

      10 { ;# Pure 4th axis rotation -

         PB_SIM_call SIM_move_rotary_axis [expr $mom_sim_pos(3)/$mom_sim_max_dpm] $mom_sim_mt_axis(4) $mom_sim_pos(3)
         PB_SIM_call SIM_update
         PB_SIM_call VNC_update_sim_pos

         set pattern 0
      }

      11 { ;# Pure compound rotation -

         PB_SIM_call SIM_move_rotary_axis [expr $mom_sim_pos(3)/$mom_sim_max_dpm] $mom_sim_mt_axis(4) $mom_sim_pos(3)
         PB_SIM_call SIM_move_rotary_axis [expr $mom_sim_pos(4)/$mom_sim_max_dpm] $mom_sim_mt_axis(5) $mom_sim_pos(4)
         PB_SIM_call SIM_update
         PB_SIM_call VNC_update_sim_pos

         set pattern 0
      }
   }


   if { [expr $pattern > 0] } {

     # Force rotary direction
      global mom_sim_5th_axis_has_limits
      if { [info exists mom_sim_lg_axis(5)] } {
         if { !$mom_sim_5th_axis_has_limits } {
            PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(5) "ALWAYS_SHORTEST"
         }
      }


      eval PB_SIM_call VNC_move_linear_zcs RAPID $coord_list


     # In case tool is not yet activated...
      global mom_sim_tool_loaded
      if { ![string match "" [string trim $mom_sim_tool_loaded]] } {
         PB_SIM_call SIM_activate_tool $mom_sim_tool_loaded
      }
      PB_SIM_call SIM_update


     # Force rotary direction
      if { [info exists mom_sim_lg_axis(5)] } {
         if { !$mom_sim_5th_axis_has_limits } {
            global mom_sim_5th_axis_direction
            if { ![string match "" [string trim $mom_sim_5th_axis_direction] ] } {
               PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(5) $mom_sim_5th_axis_direction

               global mom_sim_mt_axis
               global mom_sim_result
               PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(5) NORM_180
               PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(5)
               if { [EQ_is_zero $mom_sim_result] } {
                  set mom_sim_result 0.0
               }
               set mom_sim_pos(4) $mom_sim_result
               PB_SIM_call SIM_move_rotary_axis 5 $mom_sim_mt_axis(5) $mom_sim_pos(4)
            }
         }
      }
   }

   set mom_sim_nc_register(LAST_X) $mom_sim_pos(0)
   set mom_sim_nc_register(LAST_Y) $mom_sim_pos(1)
   set mom_sim_nc_register(LAST_Z) $mom_sim_pos(2)
}


#=============================================================
proc PB_CMD_vnc__send_dogs_home { } {
#=============================================================
  global mom_sim_mt_axis
  global mom_sim_num_machine_axes
  global mom_sim_nc_register
  global mom_sim_result mom_sim_result1


  # Make sure the polar mode is OFF.
   PB_SIM_call SIM_set_linearization OFF


  # Determine the axes that need to move per intermediate pt specified.
   set move_X 0
   set move_Y 0
   set move_Z 0
   set move_4 0
   set move_5 0

   PB_SIM_call SIM_ask_nc_axes_of_mtool


   if { [info exists mom_sim_nc_register(REF_INT_PT_X)] } {
      if { [info exists mom_sim_mt_axis(X)] } {
         if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(X)"] >= 0 } {
            set move_X 1
         }
      }
   }
   if { [info exists mom_sim_nc_register(REF_INT_PT_Y)] } {
      if { [info exists mom_sim_mt_axis(Y)] } {
         if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Y)"] >= 0 } {
            set move_Y 1
         }
      }
   }
   if { [info exists mom_sim_nc_register(REF_INT_PT_Z)] } {
      if { [info exists mom_sim_mt_axis(Z)] } {
         if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Z)"] >= 0 } {
            set move_Z 1
         }
      }
   }

   if { $mom_sim_num_machine_axes > 3 } {
      if { [info exists mom_sim_nc_register(REF_INT_PT_4)] } {
         set move_4 1
      }
   }

   if { $mom_sim_num_machine_axes > 4 } {
      if { [info exists mom_sim_nc_register(REF_INT_PT_5)] } {
         set move_5 1
      }
   }


  # Establish machine home position in MTCS for the 1st time.
   global mom_sim_pos_mtcs
   global mom_sim_lg_axis
   global mom_sim_spindle_jct mom_sim_current_junction
   global mom_sim_pivot_jct

  # Make use of pivot junction
   if { [info exists mom_sim_pivot_jct] } {
      PB_SIM_call SIM_set_current_ref_junction $mom_sim_pivot_jct
   } else {
      PB_SIM_call SIM_set_current_ref_junction $mom_sim_spindle_jct
   }

  # To prevent ref jct being reset to tool tip in sim_motion
   global mom_sim_tool_junction mom_sim_current_tool_junction
   global mom_sim_current_junction    
   set mom_sim_current_tool_junction "$mom_sim_tool_junction"
   set mom_sim_tool_junction "$mom_sim_current_junction"


  # Keep track of current position
   PB_SIM_call VNC_update_sim_pos


  # Set RAPID mode
   PB_SIM_call VNC_set_feedrate_mode RAPID

   set time 1

  # Establish ref pt
   if { ![info exists mom_sim_pos_mtcs(0)] } {
      if $move_X {
         PB_SIM_call SIM_move_linear_axis 1 $mom_sim_mt_axis(X) [lindex $mom_sim_nc_register(REF_PT) 0]
         set ref_pt [PB_SIM_call SIM_ask_last_position_mtcs]
         set mom_sim_pos_mtcs(0) [lindex $ref_pt 0]
      }
   }
   if { ![info exists mom_sim_pos_mtcs(1)] } {
      if $move_Y {
         if { [info exists mom_sim_mt_axis(Y)] } {
            PB_SIM_call SIM_move_linear_axis 1 $mom_sim_mt_axis(Y) [lindex $mom_sim_nc_register(REF_PT) 1]
            set ref_pt [PB_SIM_call SIM_ask_last_position_mtcs]
            set mom_sim_pos_mtcs(1) [lindex $ref_pt 1]
         }
      }
   }
   if { ![info exists mom_sim_pos_mtcs(2)] } {
      if $move_Z {
         PB_SIM_call SIM_move_linear_axis 1 $mom_sim_mt_axis(Z) [lindex $mom_sim_nc_register(REF_PT) 2]
         set ref_pt [PB_SIM_call SIM_ask_last_position_mtcs]
         set mom_sim_pos_mtcs(2) [lindex $ref_pt 2]
      }
   }

  # Always zero rotary axes ???
   if { $mom_sim_num_machine_axes > 3 } {
     # set move_4 1
   }

   if { $mom_sim_num_machine_axes > 4 } {
     # set move_5 1
   }


   set coord_list [list]
   if $move_X {
      lappend coord_list $mom_sim_lg_axis(X) $mom_sim_pos_mtcs(0)
   }
   if $move_Y {
      lappend coord_list $mom_sim_lg_axis(Y) $mom_sim_pos_mtcs(1)
   }
   if $move_Z {
      lappend coord_list $mom_sim_lg_axis(Z) $mom_sim_pos_mtcs(2)
   }


   if { [llength $coord_list] > 0 } {
      eval PB_SIM_call SIM_move_linear_mtcs $coord_list
   }


global mom_sim_message
set mom_sim_message "REF PT >$mom_sim_nc_register(REF_PT)<"
PB_CMD_vnc__send_message


  # If a rotary axis is limitless, only unwind it to the modulu of 360!
  #
   global mom_sim_num_machine_axes mom_sim_mt_axis
   global mom_sim_4th_axis_has_limits mom_sim_5th_axis_has_limits
   global mom_sim_4th_axis_direction mom_sim_5th_axis_direction

   global mom_sim_pos

   global mom_sim_4th_axis_max_limit mom_sim_4th_axis_min_limit
   global mom_sim_5th_axis_max_limit mom_sim_5th_axis_min_limit

   if { [expr $mom_sim_num_machine_axes > 4] } {

      if $move_5 {

         if $mom_sim_5th_axis_has_limits {

            set mom_sim_pos(4) 0

         } else {

            PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(5)

            if { ![EQ_is_equal $mom_sim_result $mom_sim_pos(4)] } {

               PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(5) NORM_180
               set mom_sim_pos(4) 0.0

            } else {

               if { [expr $mom_sim_pos(4) < 0.0] } {
                  set sign -1
               } else {
                  set sign 1
               }

               set rem [expr fmod($mom_sim_pos(4),360)]
               if { [expr abs($rem) > 180] } {
                  set mom_sim_pos(4) [expr $mom_sim_pos(4) + $sign*360 - $rem]
               } else {
                  set mom_sim_pos(4) [expr $mom_sim_pos(4) - $rem]
               }

               if { [EQ_is_zero $mom_sim_pos(4)] } {
                  set mom_sim_pos(4) 0.0
               }
            }
         }

         PB_SIM_call SIM_set_interpolation OFF

         if { [EQ_is_lt $mom_sim_pos(4) $mom_sim_5th_axis_min_limit] ||\
              [EQ_is_gt $mom_sim_pos(4) $mom_sim_5th_axis_max_limit] } {

            PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(5) NORM_180
            PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(5)
            set mom_sim_pos(4) $mom_sim_result
         }

         PB_SIM_call SIM_move_rotary_axis 5 $mom_sim_mt_axis(5) $mom_sim_pos(4)
         PB_SIM_call SIM_set_interpolation ON
      }
   }

   if { [expr $mom_sim_num_machine_axes > 3] } {

      if $move_4 {

         if $mom_sim_4th_axis_has_limits {

            set mom_sim_pos(3) 0

         } else {

            PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(4)

            if { ![EQ_is_equal $mom_sim_result $mom_sim_pos(3)] } {

               PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(4) NORM_180
               set mom_sim_pos(3) 0.0

            } else {

               if { [expr $mom_sim_pos(3) < 0.0] } {
                  set sign -1
               } else {
                  set sign 1
               }
               set rem [expr fmod($mom_sim_pos(3),360)]
               if { [expr abs($rem) > 180] } {
                  set mom_sim_pos(3) [expr $mom_sim_pos(3) + $sign*360 - $rem]
               } else {
                  set mom_sim_pos(3) [expr $mom_sim_pos(3) - $rem]
               }

               if { [EQ_is_zero $mom_sim_pos(3)] } {
                  set mom_sim_pos(3) 0.0
               }
            }
         }

         PB_SIM_call SIM_set_interpolation OFF

         if { [EQ_is_lt $mom_sim_pos(3) $mom_sim_4th_axis_min_limit] ||
              [EQ_is_gt $mom_sim_pos(3) $mom_sim_4th_axis_max_limit] } {

            PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(4) NORM_180
            PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(4)
            set mom_sim_pos(3) $mom_sim_result
         }

         PB_SIM_call SIM_move_rotary_axis 5 $mom_sim_mt_axis(4) $mom_sim_pos(3)
         PB_SIM_call SIM_set_interpolation ON
      }
   }


   PB_SIM_call SIM_update


 # pb600 - This seems to cause prematured change of tracking jct
 if 0 {
  # pb501 -
  # PB_SIM_call SIM_set_current_ref_junction $mom_sim_current_junction

  # Restore current tool ref jct
   global mom_sim_tool_junction mom_sim_current_tool_junction
   global mom_sim_current_junction
   if { [info exists mom_sim_current_tool_junction] } {
      set mom_sim_tool_junction "$mom_sim_current_tool_junction"
      set mom_sim_current_junction "$mom_sim_tool_junction"
   }

  # Restore tracking point back to tool tip
   PB_SIM_call SIM_set_current_ref_junction $mom_sim_current_junction
 }


  # Keep track of current position
   PB_SIM_call VNC_update_sim_pos


  # Zero Y for lathe mode
   if { [string match "TURN" $mom_sim_nc_register(MACHINE_MODE)] } {
      set mom_sim_pos(1) 0
   }


  # Zero all other axes
   set mom_sim_pos(5) 0
   set mom_sim_pos(6) 0
   set mom_sim_pos(7) 0
}


#=============================================================
proc PB_CMD_vnc__start_polar_motion { } {
#=============================================================
# This function alters motion's sim positions for polar simulation.
# Polar mode should have been initiated when certain N/C code
# has been encounterred.
#
   global mom_sim_polar_mode

   if { [info exists mom_sim_polar_mode] && $mom_sim_polar_mode > 0 } {

     # Always turn it on here, incase it's off
      PB_SIM_call SIM_set_linearization ON

      if { $mom_sim_polar_mode == 2 } {

         PB_SIM_call PB_CMD_vnc__linearize_polar_motion

       return
      }

      global mom_sim_pos
      global mom_sim_prev_pos

      global mom_sim_lg_axis
      global mom_sim_nc_register


     # If needed, make Z move first
      if { ![EQ_is_equal $mom_sim_pos(2) $mom_sim_prev_pos(2)] } {
        # PB_SIM_call VNC_move_linear_zcs CUT  $mom_sim_lg_axis(Z) $mom_sim_pos(2)
        # set mom_sim_nc_register(LAST_Z) $mom_sim_pos(2)
      }


     # Re-compute X/Y & I/J to compensate initial angle
      global RAD2DEG
      global mom_sim_init_polar_c_angle mom_sim_num_machine_axes

      if { [info exists mom_sim_init_polar_c_angle] &&\
          ![EQ_is_zero $mom_sim_init_polar_c_angle] } {

         set c_axis [expr $mom_sim_num_machine_axes - 1]

        # Adjust X/Y
         set R     [expr sqrt( pow($mom_sim_pos($c_axis),2) + pow($mom_sim_pos(0),2) )]
         set THETA [expr atan2( $mom_sim_pos($c_axis), $mom_sim_pos(0) ) + $mom_sim_init_polar_c_angle/$RAD2DEG]
         set mom_sim_pos(0)       [expr $R * cos($THETA)]
         set mom_sim_pos($c_axis) [expr $R * sin($THETA)]

        # Adjust I/J (arc center vector)
         set R     [expr sqrt( pow($mom_sim_pos(6),2) + pow($mom_sim_pos(5),2) )]
         set THETA [expr atan2( $mom_sim_pos(6), $mom_sim_pos(5) ) + $mom_sim_init_polar_c_angle/$RAD2DEG]
         set mom_sim_pos(5) [expr $R * cos($THETA)]
         set mom_sim_pos(6) [expr $R * sin($THETA)]
      }


      global mom_sim_mt_axis
      global mom_sim_polar_output_format


      if { [info exists mom_sim_mt_axis(5)] } {

         PB_SIM_call SIM_set_rotary_axes_config  [concat $mom_sim_mt_axis(5)]

        # C is Y
         if { ![info exists mom_sim_polar_output_format] ||\
               [string match "XCZ" $mom_sim_polar_output_format] } {

            set mom_sim_pos(1) $mom_sim_pos(4)

           # Fall back to previous angle
            set mom_sim_pos(4) $mom_sim_prev_pos(4)
         }

      } elseif { [info exists mom_sim_mt_axis(4)] } {

         PB_SIM_call SIM_set_rotary_axes_config  [concat $mom_sim_mt_axis(4)]

        # C is Y
         if { ![info exists mom_sim_polar_output_format] ||\
               [string match "XCZ" $mom_sim_polar_output_format] } {

            set mom_sim_pos(1) $mom_sim_pos(3)

           # Fall back to previous angle
            set mom_sim_pos(3) $mom_sim_prev_pos(3)
         }
      }

      global mom_sim_x_factor
      if { $mom_sim_x_factor == -1 } {
         set mom_sim_pos(0) [expr $mom_sim_pos(0)*$mom_sim_x_factor]
         set mom_sim_pos(1) [expr $mom_sim_pos(1)*$mom_sim_x_factor]
         set mom_sim_pos(5) [expr $mom_sim_pos(5)*$mom_sim_x_factor]
         set mom_sim_pos(6) [expr $mom_sim_pos(6)*$mom_sim_x_factor]
      }

      PB_SIM_call SIM_set_machining_mode MILL_CX
   }
}





