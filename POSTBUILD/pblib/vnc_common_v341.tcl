########################### Virtual NC Controller ############################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005, UGS PLM Solutions.       #
#                                                                            #
##############################################################################
#                       V N C _ C O M M O N _ V 3 4 1 . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains handlers for incremental VNC conversion to v341.
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
     if [info exists $var] {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

         if [string match "$mom_sim_nc_func(TL_ADJUST_PLUS)" $code] {

           # When there's been a tool change, reset ref junction.
           # We may need to retrieve the actual tool length, if any, from H register.

            set mom_sim_nc_register(TL_ADJUST) PLUS

         } elseif [string match "$mom_sim_nc_func(TL_ADJUST_MINUS)"  $code] {

            set mom_sim_nc_register(TL_ADJUST) MINUS

         } elseif [string match "$mom_sim_nc_func(TL_ADJUST_CANCEL)" $code] {

            set mom_sim_nc_register(TL_ADJUST) OFF
         }

         break
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
     if [info exists $var] {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {
      if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

         if [string match "$mom_sim_nc_func(CUTCOM_LEFT)" $code] {

            set mom_sim_nc_register(CUTCOM) LEFT

         } elseif [string match "$mom_sim_nc_func(CUTCOM_RIGHT)" $code] {

            set mom_sim_nc_register(CUTCOM) RIGHT

         } elseif [string match "$mom_sim_nc_func(CUTCOM_OFF)" $code] {

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


   if [string match "IN" $mom_sim_nc_register(UNIT)] {

      set codes_list [list]

      set var_list {mom_sim_nc_func(FEED_IPM)\
                    mom_sim_nc_func(FEED_IPR)\
                    mom_sim_nc_func(FEED_FRN)}

      foreach var $var_list {
        if [info exists $var] {
          lappend codes_list [set $var]
        }
      }

      global mom_sim_o_buffer
      foreach code $codes_list {

         if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

            if [string match "$mom_sim_nc_func(FEED_IPM)" $code] {

               set mom_sim_nc_register(FEED_MODE) INCH_PER_MIN

            } elseif [string match "$mom_sim_nc_func(FEED_IPR)"  $code] {

               set mom_sim_nc_register(FEED_MODE) INCH_PER_REV

            } elseif [string match "$mom_sim_nc_func(FEED_FRN)"  $code] {

               set mom_sim_nc_register(FEED_MODE) MM_PER_100REV
            }

         break
        }
      }

   } elseif [string match "MM" $mom_sim_nc_register(UNIT)] {

      set codes_list [list]

      set var_list {mom_sim_nc_func(FEED_MMPM)\
                    mom_sim_nc_func(FEED_MMPR)\
                    mom_sim_nc_func(FEED_FRN)}

      foreach var $var_list {
        if [info exists $var] {
          lappend codes_list [set $var]
        }
      }

      global mom_sim_o_buffer
      foreach code $codes_list {

         if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

            if [string match "$mom_sim_nc_func(FEED_MMPM)" $code] {

               set mom_sim_nc_register(FEED_MODE) MM_PER_MIN

            } elseif [string match "$mom_sim_nc_func(FEED_MMPR)"  $code] {

               set mom_sim_nc_register(FEED_MODE) MM_PER_REV

            } elseif [string match "$mom_sim_nc_func(FEED_FRN)"  $code] {

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


   set codes_list [list]

   set var_list {mom_sim_nc_func(DELAY_SEC)\
                 mom_sim_nc_func(DELAY_REV)\
                 mom_sim_nc_func(UNIT_IN)\
                 mom_sim_nc_func(UNIT_MM)\
                 mom_sim_nc_func(RETURN_HOME)\
                 mom_sim_nc_func(RETURN_HOME_P)\
                 mom_sim_nc_func(FROM_HOME)\
                 mom_sim_nc_func(MACH_CS_MOVE)\
                 mom_sim_nc_func(WORK_CS_1)\
                 mom_sim_nc_func(WORK_CS_2)\
                 mom_sim_nc_func(WORK_CS_3)\
                 mom_sim_nc_func(WORK_CS_4)\
                 mom_sim_nc_func(WORK_CS_5)\
                 mom_sim_nc_func(WORK_CS_6)\
                 mom_sim_nc_func(LOCAL_CS_SET)\
                 mom_sim_nc_func(WORK_CS_RESET)}

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
           # The int. pt. floats with respect to the active WCS (G54-59).
           # Reference point is fixed on a machine.
   
            set mom_sim_nc_register(RETURN_HOME) 1

         } elseif [string match "$mom_sim_nc_func(RETURN_HOME_P)" $code] {

           # G30 P2 XYZ -- Return to the 2nd ref pt. P2 can be omitted.
           # G30 P3 XYZ -- Return to the 3rd ref pt.
           # G30 P4 XYZ -- Return to the 4th ref pt.
           #
           # G30 & G28 share the same intermediate point. I think?.

         } elseif [string match "$mom_sim_nc_func(FROM_HOME)" $code] {

           # This command is normally issued immediately after a G28.
           #
           # Coord specified with this function is the target that the tool will position.
           # The tool will first position from the ref. pt. to the "intermediate point"
           # that have been defined in the previous G28 command, if any, in rapid mode
           # before going to its final destination.

            set mom_sim_nc_register(FROM_HOME) 1

         } elseif [string match "$mom_sim_nc_func(MACH_CS_MOVE)" $code] {

           # Moves to a position in the Machine Coordiante System (MCS).
           # The origin of MCS (Machine Zero, Machine Datum) never changes.
           # One shot deal block. Ignored in incremental mode (G91).
           # MCS is never affected by G92 or G52 (LCS) until machine is powered off.
           # (I think, guess), G53 is used in the M06 macro for the tool change.

            set mom_sim_nc_register(MCS_MOVE) 1

           # Fake WCS offset. Restore it after move.
            set mom_sim_nc_register(WORK_OFFSET) [list]
            lappend mom_sim_nc_register(WORK_OFFSET) 0.0 0.0 0.0 0.0 0.0

         } elseif [string match "$mom_sim_nc_func(WORK_CS_1)" $code] {

           # Select Work Coordinate System.
           # Each set of offsets (from Machine Zero) is entered and stored in the machine.
           # G54 is selected when powered on (?).
           # Work zero point offset value can be set in a program by G10 command (??).

            set mom_sim_nc_register(WCS) 1
            set mom_sim_nc_register(WORK_OFFSET) [list]
            foreach coord $mom_sim_wcs_offsets($mom_sim_nc_register(WCS)) {
               lappend mom_sim_nc_register(WORK_OFFSET) $coord
            }

         } elseif [string match "$mom_sim_nc_func(WORK_CS_2)" $code] {

            set mom_sim_nc_register(WCS) 2
            set mom_sim_nc_register(WORK_OFFSET) [list]
            foreach coord $mom_sim_wcs_offsets($mom_sim_nc_register(WCS)) {
               lappend mom_sim_nc_register(WORK_OFFSET) $coord
            }

         } elseif [string match "$mom_sim_nc_func(WORK_CS_3)" $code] {

            set mom_sim_nc_register(WCS) 3
            set mom_sim_nc_register(WORK_OFFSET) [list]
            foreach coord $mom_sim_wcs_offsets($mom_sim_nc_register(WCS)) {
               lappend mom_sim_nc_register(WORK_OFFSET) $coord
            }
   
         } elseif [string match "$mom_sim_nc_func(WORK_CS_4)" $code] {

            set mom_sim_nc_register(WCS) 4
            set mom_sim_nc_register(WORK_OFFSET) [list]
            foreach coord $mom_sim_wcs_offsets($mom_sim_nc_register(WCS)) {
               lappend mom_sim_nc_register(WORK_OFFSET) $coord
            }

         } elseif [string match "$mom_sim_nc_func(WORK_CS_5)" $code] {

            set mom_sim_nc_register(WCS) 5
            set mom_sim_nc_register(WORK_OFFSET) [list]
            foreach coord $mom_sim_wcs_offsets($mom_sim_nc_register(WCS)) {
               lappend mom_sim_nc_register(WORK_OFFSET) $coord
            }

         } elseif [string match "$mom_sim_nc_func(WORK_CS_6)" $code] {

            set mom_sim_nc_register(WCS) 6
            set mom_sim_nc_register(WORK_OFFSET) [list]
            foreach coord $mom_sim_wcs_offsets($mom_sim_nc_register(WCS)) {
               lappend mom_sim_nc_register(WORK_OFFSET) $coord
            }

         } elseif [string match "$mom_sim_nc_func(LOCAL_CS_SET)" $code] {

           # Shift all WCS. Offsets are specified.
           #
           # Specify a local coordiante system within the active work coordinate system.
           # Shifts will be applied to All WCS.
           # G52 IP0 or G92 command cancels this command.

            set mom_sim_nc_register(SET_LOCAL) 1

         } elseif [string match "$mom_sim_nc_func(WORK_CS_RESET)" $code] {

           # Disable work coord reset if S is in the block.
           # G92 is used to set max spindle speed.
            global mom_sim_address
            if [VNC_parse_nc_block mom_sim_o_buffer $mom_sim_address(S,leader)] {
return
            }


           # Modify Work Coordinate System (G54 - G59).
           #
           # This command immediately make current pos a new origin of the working coordiante system
           # The offsets are added to ALL work coordinate systems (G54 - G59).
           # Subsequent reference to any of the WCS will have the offsets in effect.
           #
           # XYZ specified with this command will be used to position the tool from new origin.
           # A Manual Reference Point Return cancels G92. All WCS return to normal (??).

           # Defer offsets calculation until entire block is parsed.
            set mom_sim_nc_register(RESET_WCS) 1


global mom_sim_message
set mom_sim_message "-- RESET WCS"
PB_CMD_vnc__send_message

         }


        # Perform CSYS transformation per choice of WCS.
         if [string match "$mom_sim_nc_func(MACH_CS_MOVE)" $code] {


         } elseif { [string match "$mom_sim_nc_func(WORK_CS_1)" $code] || [string match "$mom_sim_nc_func(WORK_CS_2)" $code] || [string match "$mom_sim_nc_func(WORK_CS_3)" $code] || [string match "$mom_sim_nc_func(WORK_CS_4)" $code] || [string match "$mom_sim_nc_func(WORK_CS_5)" $code] || [string match "$mom_sim_nc_func(WORK_CS_6)" $code] } {

           # Apply local MCS xformation and reassign ZCS base to rotate
            global mom_sim_zcs_base mom_sim_zcs_base_LCS
            if [info exists mom_sim_zcs_base_LCS] {
               set mom_sim_zcs_base $mom_sim_zcs_base_LCS
            }

            PB_SIM_call VNC_set_kinematics

           # Flag to reset start position in next motion.
            set mom_sim_nc_register(FIXTURE_OFFSET) 1
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
     if [info exists $var] {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

         if [string match "$mom_sim_nc_func(INPUT_ABS)" $code] {

            set mom_sim_nc_register(INPUT) ABS

         } elseif [string match "$mom_sim_nc_func(INPUT_INC)" $code] {

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

   set var_list {mom_sim_nc_func(MOTION_RAPID)\
                 mom_sim_nc_func(MOTION_LINEAR)\
                 mom_sim_nc_func(MOTION_CIRCULAR_CLW)\
                 mom_sim_nc_func(MOTION_CIRCULAR_CCLW)\
                 mom_sim_nc_func(CYCLE_DRILL)\
                 mom_sim_nc_func(CYCLE_DRILL_DWELL)\
                 mom_sim_nc_func(CYCLE_DRILL_DEEP)\
                 mom_sim_nc_func(CYCLE_DRILL_BREAK_CHIP)\
                 mom_sim_nc_func(CYCLE_TAP)\
                 mom_sim_nc_func(CYCLE_BORE)\
                 mom_sim_nc_func(CYCLE_BORE_DRAG)\
                 mom_sim_nc_func(CYCLE_BORE_NO_DRAG)\
                 mom_sim_nc_func(CYCLE_BORE_BACK)\
                 mom_sim_nc_func(CYCLE_BORE_MANUAL)\
                 mom_sim_nc_func(CYCLE_BORE_MANUAL_DWELL)\
                 mom_sim_nc_func(CYCLE_START)\
                 mom_sim_nc_func(CYCLE_OFF)}

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
     if [info exists $var] {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

         if [string match "$mom_sim_nc_func(PLANE_XY)"        $code] {

            set mom_sim_nc_register(PLANE) XY
            set mom_sim_cycle_spindle_axis 2

         } elseif [string match "$mom_sim_nc_func(PLANE_YZ)"  $code] {

            set mom_sim_nc_register(PLANE) YZ
            set mom_sim_cycle_spindle_axis 0

         } elseif [string match "$mom_sim_nc_func(PLANE_ZX)"  $code] {

            set mom_sim_nc_register(PLANE) ZX
            set mom_sim_cycle_spindle_axis 1
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__G_spin_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   if [string match "IN" $mom_sim_nc_register(UNIT)] {

      set codes_list [list]

      set var_list {mom_sim_nc_func(SPEED_SFM)\
                    mom_sim_nc_func(SPEED_RPM)}

      foreach var $var_list {
        if [info exists $var] {
          lappend codes_list [set $var]
        }
      }

      global mom_sim_o_buffer
      foreach code $codes_list {

         if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

            if [string match "$mom_sim_nc_func(SPEED_SFM)" $code] {

               set mom_sim_nc_register(SPINDLE_MODE) SFM

            } elseif [string match "$mom_sim_nc_func(SPEED_RPM)"  $code] {

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
        if [info exists $var] {
          lappend codes_list [set $var]
        }
      }

      global mom_sim_o_buffer
      foreach code $codes_list {

         if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

            if [string match "$mom_sim_nc_func(SPEED_SMM)"  $code] {

               set mom_sim_nc_register(SPINDLE_MODE) SMM

            } elseif [string match "$mom_sim_nc_func(SPEED_RPM)"  $code] {

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
     if [info exists $var] {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer

   foreach code $codes_list {

      if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

         if [string match "$mom_sim_nc_func(COOLANT_OFF)" $code] {
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
     if [info exists $var] {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer

   foreach code $codes_list {

      if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

         if [string match "$mom_sim_nc_func(PROG_STOP)"         $code] {

         } elseif [string match "$mom_sim_nc_func(PROG_OPSTOP)" $code] {

         } elseif [string match "$mom_sim_nc_func(PROG_END)"    $code] {

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

         } elseif [string match "$mom_sim_nc_func(TOOL_CHANGE)"      $code] {

            PB_SIM_call VNC_tool_change

         } elseif [string match "$mom_sim_nc_func(PROG_STOP_REWIND)" $code] {

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
     if [info exists $var] {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

         if [string match "$mom_sim_nc_func(SPINDLE_CLW)" $code] {

            set mom_sim_nc_register(SPINDLE_DIRECTION) CLW

         } elseif [string match "$mom_sim_nc_func(SPINDLE_CCLW)"  $code] {

            set mom_sim_nc_register(SPINDLE_DIRECTION) CCLW

         } elseif [string match "$mom_sim_nc_func(SPINDLE_OFF)"  $code] {

            set mom_sim_nc_register(SPINDLE_DIRECTION) OFF
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

      if { [info exists mom_sim_max_dpm] && ![EQ_is_zero $mom_sim_max_dpm] } {
         set mom_sim_duration_time [expr ($delta / $mom_sim_max_dpm) * 60.0]
      }

   } else {

      if { ![EQ_is_zero $feed] && ![EQ_is_zero $delta] } {

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
proc PB_CMD_vnc__circular_move { } {
#=============================================================
  global mom_sim_address mom_sim_pos mom_sim_prev_pos
  global mom_sim_lg_axis
  global mom_sim_nc_register
  global mom_sim_circular_dir
  global mom_sim_circular_vector

  global mom_sim_o_buffer


  # Clear R in use condition
   if [info exists mom_sim_nc_register(R_IN_USE)] {

     # Unset it only if not modal!
      if { !$mom_sim_address(R,modal) } {
         unset mom_sim_nc_register(R_IN_USE)
      }
   }

  # Search for R word if the leader of Address R is R.
  # >>> Not sure this will always work!
   if [string match "R" $mom_sim_address(R,leader)] {
      VNC_parse_nc_block mom_sim_o_buffer $mom_sim_address(R,leader) PB_CMD_vnc__R_code
   }

   PB_SIM_call VNC_set_feedrate_mode CUT


   set dir $mom_sim_circular_dir
   set plane $mom_sim_nc_register(PLANE)


  # When "Unsigned Vector - Arc Start to Center" is used to define
  # the arc center vector, fake it into R case for arc center calculation.

   if [string match "Unsigned Vector - Arc Start to Center" $mom_sim_circular_vector] {

      set mom_sim_nc_register(R_IN_USE) 1

      if [info exists mom_sim_nc_register(R)] {
         set R_saved $mom_sim_nc_register(R)
      } else {
         set R_saved none
      }

      switch $plane {
         "YZ" {
            set dx $mom_sim_pos(6)
            set dy $mom_sim_pos(7)
         }
         "ZX" {
            set dx $mom_sim_pos(7)
            set dy $mom_sim_pos(5)
         }
         default {
            set dx $mom_sim_pos(5)
            set dy $mom_sim_pos(6)
         }
      }

     # Arc radius
      set mom_sim_nc_register(R) [expr sqrt($dx*$dx + $dy*$dy)]
   }


  # Find arc center vector
   if [info exists mom_sim_nc_register(R_IN_USE)] {

      switch $plane {
         "YZ" {
            set dx [expr $mom_sim_pos(1) - $mom_sim_prev_pos(1)]
            set dy [expr $mom_sim_pos(2) - $mom_sim_prev_pos(2)]
         }
         "ZX" {
            set dx [expr $mom_sim_pos(2) - $mom_sim_prev_pos(2)]
            set dy [expr $mom_sim_pos(0) - $mom_sim_prev_pos(0)]
         }
         default {
            set dx [expr $mom_sim_pos(0) - $mom_sim_prev_pos(0)]
            set dy [expr $mom_sim_pos(1) - $mom_sim_prev_pos(1)]
         }
      }

      set r $mom_sim_nc_register(R)
      set a [expr atan2($dy,$dx)]
      set b [expr acos(sqrt($dx*$dx + $dy*$dy) / (2.0*$r))]

     # Complement of an arc
      if [expr $r < 0] {
         set dir [expr -1 * $dir]
      }

      set c [expr $a + $dir*$b]

      switch $plane {
         "YZ" {
            set j [expr $r * cos($c) + $mom_sim_prev_pos(1)]
            set k [expr $r * sin($c) + $mom_sim_prev_pos(2)]
         }
         "ZX" {
            set k [expr $r * cos($c) + $mom_sim_prev_pos(2)]
            set i [expr $r * sin($c) + $mom_sim_prev_pos(0)]
         }
         default {
            set i [expr $r * cos($c) + $mom_sim_prev_pos(0)]
            set j [expr $r * sin($c) + $mom_sim_prev_pos(1)]
         }
      }

     # Restore R register
      if [string match "Unsigned Vector - Arc Start to Center" $mom_sim_circular_vector] {
         if [string match "none" $R_saved] {
            unset mom_sim_nc_register(R)
         } else {
            set mom_sim_nc_register(R) $R_saved
         }
      }

   } else {

      switch $mom_sim_circular_vector {
         "Vector - Arc Start to Center" {
            set i [expr $mom_sim_prev_pos(0) + $mom_sim_pos(5)]
            set j [expr $mom_sim_prev_pos(1) + $mom_sim_pos(6)]
            set k [expr $mom_sim_prev_pos(2) + $mom_sim_pos(7)]
         }

         "Vector - Arc Center to Start" {
            set i [expr $mom_sim_prev_pos(0) - $mom_sim_pos(5)]
            set j [expr $mom_sim_prev_pos(1) - $mom_sim_pos(6)]
            set k [expr $mom_sim_prev_pos(2) - $mom_sim_pos(7)]
         }

         "Vector - Absolute Arc Center" {
            set i $mom_sim_pos(5)
            set j $mom_sim_pos(6)
            set k $mom_sim_pos(7)
         }
      }
   }

   global mom_sim_arc_output_mode
   global mom_sim_PI

   set helix_pitch ""

   switch $plane {
      "YZ" {

        # Handle helical condition
         if [expr $mom_sim_pos(0) != $mom_sim_prev_pos(0)] {
            if { [info exists mom_sim_helix_pitch] && [expr $mom_sim_helix_pitch != 0.0] } {
               set helix_pitch "P $mom_sim_helix_pitch"
            }
         }

        # Handle full circle case using half circle pt for non-helix (???)
         if [string match "" $helix_pitch] {

            if [string match "FULL_CIRCLE" $mom_sim_arc_output_mode] {
               if { [expr $mom_sim_pos(1) == $mom_sim_prev_pos(1)] && 
                    [expr $mom_sim_pos(2) == $mom_sim_prev_pos(2)] } {

                  set dx [expr $mom_sim_pos(1) - $j]
                  set dy [expr $mom_sim_pos(2) - $k]
                  set a [expr atan2($dy,$dx)]
                  set b [expr $a + $mom_sim_PI]
                  set r [expr sqrt($dx*$dx + $dy*$dy)]
                  set px [expr $j + $r*cos($b)]
                  set py [expr $k + $r*sin($b)]

                  PB_SIM_call SIM_move_circular_zcs $dir 0 0 $mom_sim_lg_axis(Y) $px\
                                                             $mom_sim_lg_axis(Z) $py\
                                                             $mom_sim_lg_axis(J) $j $mom_sim_lg_axis(K) $k
               }
            }
         }

         eval PB_SIM_call SIM_move_circular_zcs $dir 0 0 $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                                         $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                                         $mom_sim_lg_axis(J) $j $mom_sim_lg_axis(K) $k $helix_pitch
      }

      "ZX" {

        # Handle helical condition
         if [expr $mom_sim_pos(1) != $mom_sim_prev_pos(1)] {
            if { [info exists mom_sim_helix_pitch] && [expr $mom_sim_helix_pitch != 0.0] } {
               set helix_pitch "P $mom_sim_helix_pitch"
            }
         }

        # Handle full circle case using half circle pt for non-helix
         if [string match "" $helix_pitch] {
            if [string match "FULL_CIRCLE" $mom_sim_arc_output_mode] {
               if { [expr $mom_sim_pos(2) == $mom_sim_prev_pos(2)] && 
                    [expr $mom_sim_pos(0) == $mom_sim_prev_pos(0)] } {

                  set dx [expr $mom_sim_pos(2) - $k]
                  set dy [expr $mom_sim_pos(0) - $i]
                  set a [expr atan2($dy,$dx)]
                  set b [expr $a + $mom_sim_PI]
                  set r [expr sqrt($dx*$dx + $dy*$dy)]
                  set px [expr $k + $r*cos($b)]
                  set py [expr $i + $r*sin($b)]

                  PB_SIM_call SIM_move_circular_zcs 0 $dir 0 $mom_sim_lg_axis(Z) $px\
                                                             $mom_sim_lg_axis(X) $py\
                                                             $mom_sim_lg_axis(K) $k $mom_sim_lg_axis(I) $i
               }
            }
         }
         eval PB_SIM_call SIM_move_circular_zcs 0 $dir 0 $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                                         $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                                         $mom_sim_lg_axis(K) $k $mom_sim_lg_axis(I) $i $helix_pitch
      }

      default {

        # Handle helical condition
         if [expr $mom_sim_pos(2) != $mom_sim_prev_pos(2)] {
            if { [info exists mom_sim_helix_pitch] && [expr $mom_sim_helix_pitch != 0.0] } {
               set helix_pitch "P $mom_sim_helix_pitch"
            }
         }

        # Handle full circle case using half circle pt for non-helix
         if [string match "" $helix_pitch] {
            if [string match "FULL_CIRCLE" $mom_sim_arc_output_mode] {
               if { [expr $mom_sim_pos(0) == $mom_sim_prev_pos(0)] && 
                    [expr $mom_sim_pos(1) == $mom_sim_prev_pos(1)] } {

                  set dx [expr $mom_sim_pos(0) - $i]
                  set dy [expr $mom_sim_pos(1) - $j]
                  set a [expr atan2($dy,$dx)]
                  set b [expr $a + $mom_sim_PI]
                  set r [expr sqrt($dx*$dx + $dy*$dy)]
                  set px [expr $i + $r*cos($b)]
                  set py [expr $j + $r*sin($b)]

                  PB_SIM_call SIM_move_circular_zcs 0 0 $dir $mom_sim_lg_axis(X) $px\
                                                             $mom_sim_lg_axis(Y) $py\
                                                             $mom_sim_lg_axis(I) $i $mom_sim_lg_axis(J) $j
               }
            }
         }

         eval PB_SIM_call SIM_move_circular_zcs 0 0 $dir $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                                         $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                                         $mom_sim_lg_axis(I) $i $mom_sim_lg_axis(J) $j $helix_pitch
      }
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
#   set mom_sim_isv_qc       1    ;# 1=ON, 0=OFF
#   set mom_sim_isv_qc_file  ""   ;# "" or "listing_device"
#   set mom_sim_isv_qc_mode  1100 ;# 1000=SIM, 0100=VNC, 0010=PB_CMD, 0001=Others


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
         VNC_send_message "> QC output file : listing device"
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

      set output_bit $mom_sim_isv_qc_mode

      set base 1000

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
         if { ![string match "SIM_*" $command] &&\
              ![string match "VNC_*" $command] &&\
              ![string match "PB_CMD_*" $command] } {
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

  # Direct output to either the listing device or a file.
   if [string match "listing_device" $mom_sim_isv_qc_file] {
      MOM_output_to_listing_device "$msg"
   } else {
      puts $mom_sim_isv_qc_file "$msg"

     # >>> Flushing buffer slows down the performance
     # flush $mom_sim_isv_qc_file
   }
}

}

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
        lappend cb_string "#============================================================="
        lappend cb_string "proc $proc_name { } \{"

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

      PB_SIM_output_qc_cmd_string "[join $cb_string \n]"
   }
}


#=============================================================
proc PB_CMD_vnc__pass_head_data { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_sys_postname
  global CURRENT_HEAD
  global mom_sim_message
  global mom_sys_sim_post_name


   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix HEAD_NAME==$CURRENT_HEAD $mom_sim_control_in"
   PB_SIM_call PB_CMD_vnc__output_param_msg

   global tcl_platform
   if [string match "*windows*" $tcl_platform(platform)] {
      regsub -all {\\} $mom_sys_sim_post_name {/} post_file
   }
   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix POST_NAME==$post_file $mom_sim_control_in"
   PB_SIM_call PB_CMD_vnc__output_param_msg
}


#=============================================================
proc PB_CMD_vnc__set_speed { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_spindle_speed mom_sim_spindle_mode
  global mom_sim_spindle_max_rpm
  global mom_sim_primary_channel
  global mom_sim_tool_carrier_id


   if [info exists mom_sim_primary_channel] {
      if [info exists mom_sim_tool_carrier_id] {
         if { $mom_sim_primary_channel != $mom_sim_tool_carrier_id } {
return
         }
      }
      PB_SIM_call SIM_primary_channel $mom_sim_primary_channel
   }

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

  # Pass on spindle data
   set mom_sim_spindle_mode  $spindle_mode
   set mom_sim_spindle_speed $spindle_speed

   if { $spindle_mode == "REV_PER_MIN" } {

      PB_SIM_call SIM_set_speed $spindle_speed $spindle_mode

   } else {

      if { $spindle_mode == "SFM" } { 

         PB_SIM_call SIM_set_surface_speed $spindle_speed "FEET_PER_MIN"

        # Pass on spindle mode
         set mom_sim_spindle_mode "FEET_PER_MIN"

      } else {
         PB_SIM_call SIM_set_surface_speed $spindle_speed "M_PER_MIN"

        # Pass on spindle mode
         set mom_sim_spindle_mode "M_PER_MIN"
      }
   }
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


  # Current tool has been loaded. Do not change tool.
   if { [info exists mom_sim_tool_change] && !$mom_sim_tool_change } {
return
   }


  # Fake a temporary intermediate reference point to send all dogs home
   set mom_sim_nc_register(REF_INT_PT_X) 0
   set mom_sim_nc_register(REF_INT_PT_Y) 0
   set mom_sim_nc_register(REF_INT_PT_Z) 0
   set mom_sim_nc_register(REF_INT_PT_4) 0
   set mom_sim_nc_register(REF_INT_PT_5) 0

  # Position spindle to reference point.
   PB_SIM_call PB_CMD_vnc__send_dogs_home

  # Unset temporary intermediate reference point to send all dogs home
   unset mom_sim_nc_register(REF_INT_PT_X)
   unset mom_sim_nc_register(REF_INT_PT_Y)
   unset mom_sim_nc_register(REF_INT_PT_Z)
   unset mom_sim_nc_register(REF_INT_PT_4)
   unset mom_sim_nc_register(REF_INT_PT_5)


   set sim_tool_name ""

   if { ![string match "$sim_prev_tool_name" $mom_sim_ug_tool_name] &&  ![string match "" $mom_sim_ug_tool_name] } {

#>>>>>
#  This is where you add detailed movements such as rotating tool changer,
#  unmounting old tool and mounting new tool and/or getting next tool in ready position.
#<<<<<

     # User provided tool change sequence
      if [llength [info commands "PB_CMD_vnc____tool_change"]] {

         set sim_tool_name [PB_CMD_vnc____tool_change]

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
               global mom_sim_pocket_angle
               PB_SIM_call SIM_move_rotary_axis $tool_change_time $mom_sim_turret_axis($mom_sim_tool_carrier_id)\
                                                $mom_sim_pocket_angle($mom_sim_tool_carrier_id,$mom_sim_tool_pocket_id)

               PB_SIM_call SIM_ask_kim_comp_name_by_id "TOOL" $mom_sim_ug_tool_name

               set done_tool_change 1
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



      if {$sim_tool_name != ""} {
         PB_SIM_call SIM_activate_tool $sim_tool_name
      }

      PB_SIM_call SIM_update 


      set sim_prev_tool_name $mom_sim_ug_tool_name
      set mom_sim_tool_loaded $sim_tool_name


     # Flag tool change is done.
      set mom_sim_tool_change 0

      PB_SIM_call VNC_set_ref_jct $sim_tool_name
 
      set mom_sim_tool_junction "$mom_sim_current_junction"


     #++++++++++++++++++++++++++++++++++++++++++++++++++++++
     # Create a junction per tool offsets to track N/C data.
     #++++++++++++++++++++++++++++++++++++++++++++++++++++++
      set use_tool_tip_jct 1

      if { $mom_sim_tool_offset_used || [expr $mom_sim_pivot_distance != 0.0] } {

         if { ![string match "*_wedm" $mom_sim_machine_type] } {
            if [string match "*axis*" $mom_sim_machine_type] {
               set use_tool_tip_jct 0
               set x_offset [expr -1.0 * ($mom_sim_tool_offset(2) + $mom_sim_pivot_distance)]
               set y_offset 0.0
               set z_offset 0.0

            } elseif [string match "*lathe*" $mom_sim_machine_type] {
               if [string match "TURRET_REF" $mom_sim_output_reference_method] {
                  set use_tool_tip_jct 0
                  set x_offset $mom_sim_tool_offset(0)
                  set y_offset $mom_sim_tool_offset(1)
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
}




