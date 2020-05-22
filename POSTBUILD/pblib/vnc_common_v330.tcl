##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################
#                       V N C _ C O M M O N _ V 3 3 0 . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains handlers for incremental VNC conversion to v330.
#
##############################################################################



#=============================================================
proc PB_CMD_vnc__G_adjust_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]
    lappend codes_list $mom_sim_nc_func(TL_ADJUST_PLUS)
    lappend codes_list $mom_sim_nc_func(TL_ADJUST_MINUS)
    lappend codes_list $mom_sim_nc_func(TL_ADJUST_CANCEL)


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
proc PB_CMD_vnc__G_feed_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]
    lappend codes_list $mom_sim_nc_func(FEED_IPM)
    lappend codes_list $mom_sim_nc_func(FEED_IPR)
    lappend codes_list $mom_sim_nc_func(FEED_MMPM)
    lappend codes_list $mom_sim_nc_func(FEED_MMPR)
    lappend codes_list $mom_sim_nc_func(FEED_FRN)


   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

         if [string match "$mom_sim_nc_func(FEED_IPM)" $code] {

            set mom_sim_nc_register(FEED_MODE) INCH_PER_MIN

         } elseif [string match "$mom_sim_nc_func(FEED_IPR)"  $code] {

            set mom_sim_nc_register(FEED_MODE) INCH_PER_REV

         } elseif [string match "$mom_sim_nc_func(FEED_MMPM)"  $code] {

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


#=============================================================
proc PB_CMD_vnc__G_misc_code { } {
#=============================================================
  global mom_sim_pos
  global mom_sim_nc_register
  global mom_sim_nc_func
  global mom_sim_wcs_offsets


   set codes_list [list]
    lappend codes_list $mom_sim_nc_func(DELAY_SEC)
    lappend codes_list $mom_sim_nc_func(DELAY_REV)
    lappend codes_list $mom_sim_nc_func(UNIT_IN)
    lappend codes_list $mom_sim_nc_func(UNIT_MM)
    lappend codes_list $mom_sim_nc_func(RETURN_HOME)
    lappend codes_list $mom_sim_nc_func(RETURN_HOME_P)
    lappend codes_list $mom_sim_nc_func(FROM_HOME)
    lappend codes_list $mom_sim_nc_func(MACH_CS_MOVE)
    lappend codes_list $mom_sim_nc_func(WORK_CS_1)
    lappend codes_list $mom_sim_nc_func(WORK_CS_2)
    lappend codes_list $mom_sim_nc_func(WORK_CS_3)
    lappend codes_list $mom_sim_nc_func(WORK_CS_4)
    lappend codes_list $mom_sim_nc_func(WORK_CS_5)
    lappend codes_list $mom_sim_nc_func(WORK_CS_6)
    lappend codes_list $mom_sim_nc_func(LOCAL_CS_SET)
    lappend codes_list $mom_sim_nc_func(WORK_CS_RESET)


   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

         if [string match "$mom_sim_nc_func(DELAY_SEC)" $code] {

         } elseif [string match "$mom_sim_nc_func(DELAY_REV)" $code] {

         } elseif [string match "$mom_sim_nc_func(UNIT_IN)" $code] {

            set mom_sim_nc_register(UNIT) IN
            SIM_set_mtd_units "INCH" 

         } elseif [string match "$mom_sim_nc_func(UNIT_MM)" $code] {

            set mom_sim_nc_register(UNIT) MM
            SIM_set_mtd_units "MM" 

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

           # Defer offsets calculation until entire block is parsed in VNC_sim_nc_block.
            set mom_sim_nc_register(RESET_WCS) 1


global mom_sim_message
set mom_sim_message "-- RESET WCS"
PB_CMD_vnc__send_message

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
    lappend codes_list $mom_sim_nc_func(INPUT_ABS)
    lappend codes_list $mom_sim_nc_func(INPUT_INC)


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
    lappend codes_list $mom_sim_nc_func(MOTION_RAPID)
    lappend codes_list $mom_sim_nc_func(MOTION_LINEAR)
    lappend codes_list $mom_sim_nc_func(MOTION_CIRCULAR_CLW)
    lappend codes_list $mom_sim_nc_func(MOTION_CIRCULAR_CCLW)
    lappend codes_list $mom_sim_nc_func(CYCLE_DRILL)
    lappend codes_list $mom_sim_nc_func(CYCLE_DRILL_DWELL)
    lappend codes_list $mom_sim_nc_func(CYCLE_DRILL_DEEP)
    lappend codes_list $mom_sim_nc_func(CYCLE_DRILL_BREAK_CHIP)
    lappend codes_list $mom_sim_nc_func(CYCLE_TAP)
    lappend codes_list $mom_sim_nc_func(CYCLE_BORE)
    lappend codes_list $mom_sim_nc_func(CYCLE_BORE_DRAG)
    lappend codes_list $mom_sim_nc_func(CYCLE_BORE_NO_DRAG)
    lappend codes_list $mom_sim_nc_func(CYCLE_BORE_BACK)
    lappend codes_list $mom_sim_nc_func(CYCLE_BORE_MANUAL)
    lappend codes_list $mom_sim_nc_func(CYCLE_BORE_MANUAL_DWELL)
    lappend codes_list $mom_sim_nc_func(CYCLE_START)
    lappend codes_list $mom_sim_nc_func(CYCLE_OFF)


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
    lappend codes_list $mom_sim_nc_func(PLANE_XY)
    lappend codes_list $mom_sim_nc_func(PLANE_YZ)
    lappend codes_list $mom_sim_nc_func(PLANE_ZX)


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


   set codes_list [list]
    lappend codes_list $mom_sim_nc_func(SPEED_SFM)
    lappend codes_list $mom_sim_nc_func(SPEED_SMM)
    lappend codes_list $mom_sim_nc_func(SPEED_RPM)


   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

         if [string match "$mom_sim_nc_func(SPEED_SFM)" $code] {

            set mom_sim_nc_register(SPINDLE_MODE) SFM

         } elseif [string match "$mom_sim_nc_func(SPEED_SMM)"  $code] {

            set mom_sim_nc_register(SPINDLE_MODE) SMM

         } elseif [string match "$mom_sim_nc_func(SPEED_RPM)"  $code] {

            set mom_sim_nc_register(SPINDLE_MODE) REV_PER_MIN
         }

         break
      }
   }  
}


#=============================================================
proc PB_CMD_vnc__M_coolant_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]
    lappend codes_list $mom_sim_nc_func(COOLANT_ON)
    lappend codes_list $mom_sim_nc_func(COOLANT_FLOOD)
    lappend codes_list $mom_sim_nc_func(COOLANT_MIST)
    lappend codes_list $mom_sim_nc_func(COOLANT_TAP)
    lappend codes_list $mom_sim_nc_func(COOLANT_OFF)

    if [info exists mom_sim_nc_func(COOLANT_THRU)] {
       lappend codes_list $mom_sim_nc_func(COOLANT_THRU)
    }


   global mom_sim_o_buffer

   foreach code $codes_list {

      if { [VNC_parse_nc_block mom_sim_o_buffer $code] == 1 } {

         if [string match "$mom_sim_nc_func(COOLANT_OFF)" $code] {
            SIM_set_coolant OFF
         } else {
            SIM_set_coolant ON
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
    lappend codes_list $mom_sim_nc_func(PROG_STOP)
    lappend codes_list $mom_sim_nc_func(PROG_OPSTOP)
    lappend codes_list $mom_sim_nc_func(PROG_END)
    lappend codes_list $mom_sim_nc_func(TOOL_CHANGE)
    lappend codes_list $mom_sim_nc_func(PROG_STOP_REWIND)


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

            VNC_reset_controller

         } elseif [string match "$mom_sim_nc_func(TOOL_CHANGE)"      $code] {

            VNC_tool_change

         } elseif [string match "$mom_sim_nc_func(PROG_STOP_REWIND)" $code] {

            VNC_rewind_stop_program

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
    lappend codes_list $mom_sim_nc_func(SPINDLE_CLW)
    lappend codes_list $mom_sim_nc_func(SPINDLE_CCLW)
    lappend codes_list $mom_sim_nc_func(SPINDLE_OFF)


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
proc PB_CMD_vnc__circular_move { } {
#=============================================================
  global mom_sim_address mom_sim_pos mom_sim_prev_pos
  global mom_sim_lg_axis
  global mom_sim_nc_register
  global mom_sim_circular_dir
  global mom_sim_circular_vector

  global mom_sim_o_buffer


  # Search for R word
   if [info exists mom_sim_nc_register(R_IN_USE)] {

     # Unset it only if not modal!
      if { !$mom_sim_address(R,modal) } {
         unset mom_sim_nc_register(R_IN_USE)
      }
   }

   VNC_parse_nc_block mom_sim_o_buffer $mom_sim_address(R,leader) PB_CMD_vnc__R_code


   VNC_set_feedrate_mode "CUT"

   set dir $mom_sim_circular_dir
   set plane $mom_sim_nc_register(PLANE)


  # When "Unsigned Vector - Arc Start to Center" is used to define
  # the arc center vector, fake it into R case for arc center calculation.

   if [string match "Unsigned Vector - Arc Start to Center" $mom_sim_circular_vector] {

      set mom_sim_nc_register(R_IN_USE) 1

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

                  SIM_move_circular_zcs $dir 0 0 $mom_sim_lg_axis(Y) $px\
                                                 $mom_sim_lg_axis(Z) $py\
                                                 $mom_sim_lg_axis(J) $j\
                                                 $mom_sim_lg_axis(K) $k
               }
            }
         }

         eval SIM_move_circular_zcs $dir 0 0 $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                             $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                             $mom_sim_lg_axis(J) $j\
                                             $mom_sim_lg_axis(K) $k\
                                             $helix_pitch
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

                  SIM_move_circular_zcs 0 $dir 0 $mom_sim_lg_axis(Z) $px\
                                                 $mom_sim_lg_axis(X) $py\
                                                 $mom_sim_lg_axis(K) $k\
                                                 $mom_sim_lg_axis(I) $i
               }
            }
         }
         eval SIM_move_circular_zcs 0 $dir 0 $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                             $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                             $mom_sim_lg_axis(K) $k\
                                             $mom_sim_lg_axis(I) $i\
                                             $helix_pitch
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

                  SIM_move_circular_zcs 0 0 $dir $mom_sim_lg_axis(X) $px\
                                                 $mom_sim_lg_axis(Y) $py\
                                                 $mom_sim_lg_axis(I) $i\
                                                 $mom_sim_lg_axis(J) $j
               }
            }
         }

         eval  SIM_move_circular_zcs 0 0 $dir $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                              $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                              $mom_sim_lg_axis(I) $i\
                                              $mom_sim_lg_axis(J) $j\
                                              $helix_pitch
      }
   }
}


#=============================================================
proc PB_CMD_vnc__create_tmp_jct {} {
#=============================================================
  global mom_sim_tool_junction mom_sim_current_junction
  global mom_sim_curr_jct_matrix mom_sim_curr_jct_origin
  global mom_sim_tool_loaded


   if { ![string match "$mom_sim_tool_junction" "$mom_sim_current_junction"] } {

      global mom_sim_result

      SIM_ask_is_junction_exist __SIM_TMP_TOOL_JCT

      if { $mom_sim_result == 1 } {
         SIM_delete_junction __SIM_TMP_TOOL_JCT
      }

      set tmp_tool_jct "__SIM_TMP_TOOL_JCT"

      eval SIM_create_junction $tmp_tool_jct $mom_sim_tool_loaded  $mom_sim_curr_jct_origin $mom_sim_curr_jct_matrix
      SIM_set_current_ref_junction $tmp_tool_jct

      set mom_sim_tool_junction $tmp_tool_jct
      set mom_sim_current_junction $mom_sim_tool_junction

     # Update mom_sim_pos w.r.t new ref jct
      if { ![catch {set pos [SIM_ask_last_position_zcs]} ] } {
         global mom_sim_pos
         set mom_sim_pos(0) [lindex $pos 0]
         set mom_sim_pos(1) [lindex $pos 1]
         set mom_sim_pos(2) [lindex $pos 2]
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


   if $mom_sim_cycle_mode(start_block) {

     global mom_sim_cycle_spindle_axis
     global mom_sim_cycle_rapid_to_dist
     global mom_sim_cycle_feed_to_dist
     global mom_sim_cycle_retract_to_dist
     global mom_sim_cycle_entry_pos

      set rapid_to_pos(0) $mom_sim_nc_register(X)
      set rapid_to_pos(1) $mom_sim_nc_register(Y)
      set rapid_to_pos(2) $mom_sim_nc_register(Z)

      if [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) > $rapid_to_pos($mom_sim_cycle_spindle_axis)] {
         set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) $rapid_to_pos($mom_sim_cycle_spindle_axis)
      }

      set rapid_to_pos($mom_sim_cycle_spindle_axis)  $mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis)

      if [string match "*R -*" $mom_sim_cycle_mode(rapid_to)] {
         if [string match "*Distance*" $mom_sim_cycle_mode(rapid_to)] {
            set rapid_to_pos($mom_sim_cycle_spindle_axis)\
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
            set feed_to_pos($mom_sim_cycle_spindle_axis)\
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

      if [string match "K -*" $mom_sim_cycle_mode(retract_to)] {
         if [string match "*Distance*" $mom_sim_cycle_mode(retract_to)] {
            set retract_to_pos($mom_sim_cycle_spindle_axis)\
                [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_retract_to_dist]
         }
      }
      set mom_sim_cycle_retract_to_pos(0) $retract_to_pos(0)
      set mom_sim_cycle_retract_to_pos(1) $retract_to_pos(1)
      set mom_sim_cycle_retract_to_pos(2) $retract_to_pos(2)
   }


   for { set i 0 } { $i < 3 } { incr i } {
      set sim_pos_save($i) $mom_sim_pos($i)
   }
   set sim_motion_type_save $mom_sim_nc_register(MOTION)

   set mom_sim_nc_register(MOTION) LINEAR
   set mom_sim_pos(0) $mom_sim_cycle_rapid_to_pos(0)
   set mom_sim_pos(1) $mom_sim_cycle_rapid_to_pos(1)
   set mom_sim_pos(2) $mom_sim_cycle_rapid_to_pos(2)

   PB_CMD_vnc__sim_motion

   set mom_sim_pos(0) $mom_sim_cycle_feed_to_pos(0)
   set mom_sim_pos(1) $mom_sim_cycle_feed_to_pos(1)
   set mom_sim_pos(2) $mom_sim_cycle_feed_to_pos(2)

   PB_CMD_vnc__sim_motion

   set mom_sim_pos(0) $mom_sim_cycle_retract_to_pos(0)
   set mom_sim_pos(1) $mom_sim_cycle_retract_to_pos(1)
   set mom_sim_pos(2) $mom_sim_cycle_retract_to_pos(2)

   PB_CMD_vnc__sim_motion

  # Restore data
   for { set i 0 } { $i < 3 } { incr i } {
      set mom_sim_pos($i) $sim_pos_save($i)
   }
   set mom_sim_nc_register(MOTION) $sim_motion_type_save
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


global mom_sim_message mom_sim_cycle_feed_to_addr
set mom_sim_message "CYCLE : $mom_sim_nc_register($mom_sim_cycle_feed_to_addr)  $mom_sim_nc_register(R) $mom_sim_nc_register(K_cycle)"
PB_CMD_vnc__send_message


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

         set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis)\
             [expr $mom_sim_cycle_feed_to_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_feed_to_dist]
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

         if [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) ==  $mom_sim_pos($mom_sim_cycle_spindle_axis)] {
            set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis)\
                [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) - $mom_sim_cycle_rapid_to_dist]
         }

         set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis)\
             [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_rapid_to_dist]

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

         if [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) ==  $mom_sim_pos($mom_sim_cycle_spindle_axis)] {
            set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis)\
                [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) - $mom_sim_cycle_retract_to_dist]
         }

         set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis)\
            [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_retract_to_dist]
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
      PB_CMD_vnc__cycle_move
   }
}


#=============================================================
proc PB_CMD_vnc__end_of_program { } {
#=============================================================
  global mom_sim_csys_set

   set mom_sim_csys_set 0
}


#=============================================================
proc PB_CMD_vnc__from_home { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_pos
  global mom_sim_lg_axis


  # Move to the intermediate pt
   set coord_list [list]
   if [info exists mom_sim_nc_register(REF_INT_PT_X_PREV)] {
      lappend coord_list $mom_sim_lg_axis(X)  $mom_sim_nc_register(REF_INT_PT_X_PREV)
   }
   if [info exists mom_sim_nc_register(REF_INT_PT_Y_PREV)] {
      lappend coord_list $mom_sim_lg_axis(Y)  $mom_sim_nc_register(REF_INT_PT_Y_PREV)
   }
   if [info exists mom_sim_nc_register(REF_INT_PT_Z_PREV)] {
      lappend coord_list $mom_sim_lg_axis(Z)  $mom_sim_nc_register(REF_INT_PT_Z_PREV)
   }

   global mom_sim_num_machine_axes
   if { $mom_sim_num_machine_axes > 3 } {
      if [info exists mom_sim_nc_register(REF_INT_PT_4_PREV)] {
         lappend coord_list $mom_sim_lg_axis(4)  $mom_sim_nc_register(REF_INT_PT_4_PREV)
      }
   }

   if { $mom_sim_num_machine_axes > 4 } {
      if [info exists mom_sim_nc_register(REF_INT_PT_5_PREV)] {
         lappend coord_list $mom_sim_lg_axis(5)  $mom_sim_nc_register(REF_INT_PT_5_PREV)
      }
   }

  # Create a temp jct for subsequent moves incase the tool is not set properly.
   VNC_create_tmp_jct


  # Move to the intermediate point.
   if { [llength $coord_list] > 0 } {
      eval VNC_move_linear_zcs RAPID $coord_list
   }

  # Ensure Y is zero in lathe mode
   if { $mom_sim_nc_register(MACHINE_MODE) == "TURN" } {
      set mom_sim_pos(1) 0
   }

  # Move to target
   switch $mom_sim_num_machine_axes {
      4 {
         VNC_move_linear_zcs RAPID  $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                    $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                    $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                    $mom_sim_lg_axis(4) $mom_sim_pos(3)
      }
      5 {
         VNC_move_linear_zcs RAPID  $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                    $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                    $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                    $mom_sim_lg_axis(4) $mom_sim_pos(3)\
                                    $mom_sim_lg_axis(5) $mom_sim_pos(4)
      }
      default {
         VNC_move_linear_zcs RAPID  $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                    $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                    $mom_sim_lg_axis(Z) $mom_sim_pos(2)
      }
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
  global mom_sim_PI
  global mom_sim_cycle_spindle_axis
  global mom_sim_vnc_msg_prefix


   set mom_sim_PI [expr acos(-1.0)]

   set mom_sim_vnc_msg_prefix "VNC_MSG::"


  # Initialize a null list for other NC codes to be simulated.
  # Actual code list will be defined in PB_CMD_vnc____set_nc_definitions.
  #
   global mom_sim_other_nc_codes
   set mom_sim_other_nc_codes [list]


  # Initialize cycle spindle axis to Z
  #
   set mom_sim_cycle_spindle_axis 2


  # Transfer static data from the Post.
  #
   VNC_set_nc_definitions



  # When a VNC is used to output VNC messages only w/o simulation.
  #
   global mom_sim_vnc_msg_only
   if { [info exists mom_sim_vnc_msg_only] && $mom_sim_vnc_msg_only } {
return
   }



  # Display message about this VNC.
  #
   if [llength [info commands "PB_CMD_vnc__display_version"]] {
      PB_CMD_vnc__display_version
   }


  # Add user's NC data definition.
  #
   if [llength [info commands "PB_CMD_vnc__set_nc_definitions"]] {
      PB_CMD_vnc__set_nc_definitions
   } elseif [llength [info commands "PB_CMD_vnc____set_nc_definitions"]] {
      PB_CMD_vnc____set_nc_definitions
   }


  # Add more user's NC data definition required for conversion.
  #
   if [llength [info commands "PB_CMD_vnc__fix_nc_definitions"]] {
      PB_CMD_vnc__fix_nc_definitions
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
   PB_CMD_vnc____map_machine_tool_axes


  # Unset Y axis for a lathe, if necessary.
  #
   if [llength [info commands "PB_CMD_vnc__unset_Y_axis"]] {
      PB_CMD_vnc__unset_Y_axis
   }

  # Validity check for machine tool parameters.
  #
   if [llength [info commands "PB_CMD_vnc__validate_machine_tool"]] {
      PB_CMD_vnc__validate_machine_tool
   }


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
        # set mom_sim_pos($i) ""
         set mom_sim_pos($i) 0
      }
   }


  # Initialize controller state
  #
   global mom_sim_output_unit
   if { ![info exists mom_sim_nc_register(UNIT)] } {
      set mom_sim_nc_register(UNIT) $mom_sim_output_unit
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
   if { ![info exists mom_sim_nc_register(WCS)] } {
      set mom_sim_nc_register(WCS) 1
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
   if { ![info exists mom_sim_nc_register(LOCAL_OFFSET)] } {
      set mom_sim_nc_register(LOCAL_OFFSET) [list]
      lappend mom_sim_nc_register(LOCAL_OFFSET) 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
   }
   if { ![info exists mom_sim_nc_register(WORK_OFFSET)] } {
      set mom_sim_nc_register(WORK_OFFSET) [list]
      foreach coord $mom_sim_wcs_offsets($mom_sim_nc_register(WCS)) {
         lappend mom_sim_nc_register(WORK_OFFSET) $coord
      }
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

  # Initialize plane code
   if { ![info exists mom_sim_nc_register(PLANE)] } {
      set mom_sim_nc_register(PLANE) XY
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

  # Initialize CSYS state
  #
   global mom_sim_csys_set
   set mom_sim_csys_set 0

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
   if { $mom_sim_nc_register(UNIT) == "MM" } {
      SIM_set_mtd_units "MM" 
   } else {
      SIM_set_mtd_units "INCH" 
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
            if { [expr $mom_sim_4th_axis_min_limit == 0.0] && \
                 [expr $mom_sim_4th_axis_max_limit == 360.0] } {
               set mom_sim_4th_axis_direction "ALWAYS_SHORTEST"
            }
         }
         SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(4) $mom_sim_4th_axis_direction
      }
   }
   if [info exists mom_sim_lg_axis(5)] {
      if { ![string match " " $mom_sim_5th_axis_direction] } {
         if [string match "MAGNITUDE_DETERMINES_DIRECTION" $mom_sim_5th_axis_direction] {
            if { [expr $mom_sim_5th_axis_min_limit == 0.0] && \
                 [expr $mom_sim_5th_axis_max_limit == 360.0] } {
               set mom_sim_5th_axis_direction "ALWAYS_SHORTEST"
            }
         }
         SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(5) $mom_sim_5th_axis_direction
      }
   }
}


#=============================================================
proc PB_CMD_vnc__nurbs_move { } {
#=============================================================
   global mom_sim_nurbs_order
   global mom_sim_nurbs_knot_count
   global mom_sim_nurbs_knots
   global mom_sim_nurbs_point_count
   global mom_sim_nurbs_points

   SIM_move_nurbs_zcs $mom_sim_nurbs_point_count $mom_sim_nurbs_order \
                      $mom_sim_nurbs_knot_count $mom_sim_nurbs_knots\
                      $mom_sim_nurbs_points
}


#=============================================================
proc PB_CMD_vnc__output_debug_msg { } {
#=============================================================
  global mom_sim_message

   PB_VNC_output_debug_msg $mom_sim_message
}


#=============================================================
proc PB_CMD_vnc__output_param_msg { } {
#=============================================================
  global mom_sim_message

  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Use MOM_output_literal to display operator messages in NC window
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   MOM_output_text $mom_sim_message
  # MOM_output_literal $mom_sim_message
}


#=============================================================
proc PB_CMD_vnc__output_vnc_msg { } {
#=============================================================
  global mom_sim_message
  global mom_sim_control_out mom_sim_vnc_msg_prefix mom_sim_control_in

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                        $mom_sim_message $mom_sim_control_in"

   PB_CMD_vnc__output_param_msg
}


#=============================================================
proc PB_CMD_vnc__pass_csys_data { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_csys_matrix

  global mom_coordinate_system_purpose
  global mom_special_output
  global mom_kin_coordinate_system_type
  global mom_machine_csys_matrix
  global mom_sim_message


   if [info exists mom_machine_csys_matrix] {

      if [string match "MAIN" $mom_kin_coordinate_system_type] {
         for { set i 0 } { $i < 12 } { incr i } {
            set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                                 CSYS_MTX_$i==$mom_machine_csys_matrix($i) $mom_sim_control_in"
            PB_CMD_vnc__output_param_msg
         }
      } else {

        # MTX3_multiply mom_machine_csys_matrix mom_csys_matrix matrix

         MTX3_transpose mom_machine_csys_matrix mcs_matrix
         MTX3_multiply mcs_matrix mom_csys_matrix matrix

         set u(0) $mom_csys_matrix(9)
         set u(1) $mom_csys_matrix(10)
         set u(2) $mom_csys_matrix(11)
         MTX3_vec_multiply u mom_machine_csys_matrix w

         set matrix(9)  [expr $mom_machine_csys_matrix(9)  + $w(0)]
         set matrix(10) [expr $mom_machine_csys_matrix(10) + $w(1)]
         set matrix(11) [expr $mom_machine_csys_matrix(11) + $w(2)]

         for { set i 0 } { $i < 12 } { incr i } {
            set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix CSYS_MTX_$i==$matrix($i) $mom_sim_control_in"
            PB_CMD_vnc__output_param_msg
         }
      }
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


   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       HEAD_NAME==$CURRENT_HEAD $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       POST_NAME==$mom_sys_sim_post_name $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg
}


#=============================================================
proc PB_CMD_vnc__pass_helix_data { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_sim_message
  global mom_sys_helix_pitch_type
  global mom_kin_helical_arc_output_mode

   if [info exists mom_sys_helix_pitch_type] {
      set type [string toupper $mom_sys_helix_pitch_type]
      set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                          HELIX_PITCH_TYPE==$type $mom_sim_control_in"
      PB_CMD_vnc__output_param_msg
   }

   if [info exists mom_kin_helical_arc_output_mode] {
      set mode $mom_kin_helical_arc_output_mode
      set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                          HELIX_OUTPUT_MODE==$mode $mom_sim_control_in"
      PB_CMD_vnc__output_param_msg
   }
}


#=============================================================
proc PB_CMD_vnc__pass_helix_pitch { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_sim_message
  global mom_helix_pitch

   if [info exists mom_helix_pitch] {
      set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                          HELIX_PITCH==$mom_helix_pitch $mom_sim_control_in"
      PB_CMD_vnc__output_param_msg
   }
}


#=============================================================
proc PB_CMD_vnc__pass_msys_data { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_msys_matrix mom_msys_origin
  global mom_sim_message


   for { set i 0 } { $i < 9 } { incr i } {
      set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                          CSYS_MTX_$i==$mom_msys_matrix($i) $mom_sim_control_in"
      PB_CMD_vnc__output_param_msg
   }

   for { set j 0 } { $j < 3 } { incr j } {
      set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                          CSYS_MTX_$i==$mom_msys_origin($j) $mom_sim_control_in"
      incr i
      PB_CMD_vnc__output_param_msg
   }
}


#=============================================================
proc PB_CMD_vnc__pass_nurbs_data { } {
#=============================================================
  global mom_kin_nurbs_output_type

   if [string match "BSPLINE" $mom_kin_nurbs_output_type] {

      global mom_sim_control_out mom_sim_control_in
      global mom_sim_vnc_msg_prefix
      global mom_sim_message

      global mom_nurbs_knot_count
      global mom_nurbs_knots
      global mom_nurbs_point_count
      global mom_nurbs_points
      global mom_nurbs_order

      set mom_sim_message "NURBS_ORDER==$mom_nurbs_order"
      PB_CMD_vnc__output_vnc_msg

      set mom_sim_message "NURBS_KNOT_COUNT==$mom_nurbs_knot_count"
      PB_CMD_vnc__output_vnc_msg

      for {set i 0} {$i < $mom_nurbs_knot_count} {incr i} {
         set mom_sim_message "NURBS_KNOTS($i)==$mom_nurbs_knots($i)"
         PB_CMD_vnc__output_vnc_msg
      }

      set mom_sim_message "NURBS_POINT_COUNT==$mom_nurbs_point_count"
      PB_CMD_vnc__output_vnc_msg
 
      for {set i 0} {$i < $mom_nurbs_point_count} {incr i} {
         set mom_sim_message "NURBS_POINTS($i,X)==$mom_nurbs_points($i,0)"
         PB_CMD_vnc__output_vnc_msg
         set mom_sim_message "NURBS_POINTS($i,Y)==$mom_nurbs_points($i,1)"
         PB_CMD_vnc__output_vnc_msg
         set mom_sim_message "NURBS_POINTS($i,Z)==$mom_nurbs_points($i,2)"
         PB_CMD_vnc__output_vnc_msg
      }
   }
}


#=============================================================
proc PB_CMD_vnc__pass_nurbs_start { } {
#=============================================================
  global mom_kin_nurbs_output_type

   if [string match "BSPLINE" $mom_kin_nurbs_output_type] {

      global mom_sim_control_out mom_sim_control_in
      global mom_sim_vnc_msg_prefix
      global mom_sim_message

      set mom_sim_message "NURBS_START==1"
      PB_CMD_vnc__output_vnc_msg
   }
}


#=============================================================
proc PB_CMD_vnc__pass_spindle_data { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_spindle_direction mom_spindle_mode
  global mom_spindle_speed mom_spindle_maximum_rpm
  global mom_sim_message


   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       SPINDLE_DIRECTION==$mom_spindle_direction $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       SPINDLE_MODE==$mom_spindle_mode $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       SPINDLE_MAX_RPM==$mom_spindle_maximum_rpm $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       SPINDLE_SPEED==$mom_spindle_speed $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg
}


#=============================================================
proc PB_CMD_vnc__pass_tool_data { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_tool_name
  global mom_tool_offset_defined mom_tool_offset
  global mom_sim_message


   if { ![info exists mom_tool_offset(0)] } { set mom_tool_offset(0) 0 }
   if { ![info exists mom_tool_offset(1)] } { set mom_tool_offset(1) 0 }
   if { ![info exists mom_tool_offset(2)] } { set mom_tool_offset(2) 0 }

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_NAME==$mom_tool_name $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_OFFSET==$mom_tool_offset_defined $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_X_OFF==$mom_tool_offset(0) $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_Y_OFF==$mom_tool_offset(1) $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg

   set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_Z_OFF==$mom_tool_offset(2) $mom_sim_control_in"
   PB_CMD_vnc__output_param_msg

   global mom_carrier_name
   if [info exists mom_carrier_name] {
      set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                          TOOL_CARRIER_ID==$mom_carrier_name $mom_sim_control_in"
      PB_CMD_vnc__output_param_msg
   }

   global mom_pocket_id
   if [info exists mom_pocket_id] {
      set mom_sim_message "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                          TOOL_POCKET_ID==$mom_pocket_id $mom_sim_control_in"
      PB_CMD_vnc__output_param_msg
   }
}


#=============================================================
proc PB_CMD_vnc__rapid_move { } {
#=============================================================
  global mom_sim_lg_axis mom_sim_pos
  global mom_sim_nc_register
  global mom_sim_num_machine_axes

  global mom_sim_prev_pos


   set pattern 0

   set coord_list [list]

   if [expr $mom_sim_pos(0) != $mom_sim_prev_pos(0)] {
      lappend coord_list $mom_sim_lg_axis(X)  $mom_sim_pos(0)
      set pattern [expr $pattern + 10000]
   }
   if [expr $mom_sim_pos(1) != $mom_sim_prev_pos(1)] {
      lappend coord_list $mom_sim_lg_axis(Y)  $mom_sim_pos(1)
      set pattern [expr $pattern + 1000]
   }
   if [expr $mom_sim_pos(2) != $mom_sim_prev_pos(2)] {
      lappend coord_list $mom_sim_lg_axis(Z)  $mom_sim_pos(2)
      set pattern [expr $pattern + 100]
   }
   if [info exists mom_sim_lg_axis(4)] {
      if [expr $mom_sim_pos(3) != $mom_sim_prev_pos(3)] {
         lappend coord_list $mom_sim_lg_axis(4)  $mom_sim_pos(3)
         set pattern [expr $pattern + 10]
      }
   }
   if [info exists mom_sim_lg_axis(5)] {
      if [expr $mom_sim_pos(4) != $mom_sim_prev_pos(4)] {
         lappend coord_list $mom_sim_lg_axis(5)  $mom_sim_pos(4)
         set pattern [expr $pattern + 1]
      }
   }


  # Disable linear axes for the 1st 5th-axis ratary move
  # right after CSYS_ROTATION is set.
   if { [info exists mom_sim_nc_register(CSYS_ROTATION)] &&\
        [expr $mom_sim_nc_register(CSYS_ROTATION) == 1] } {

      if [expr $pattern == 1] {
         global mom_sim_mt_axis

         set time 1
         SIM_move_rotary_axis $time $mom_sim_mt_axis(5) $mom_sim_pos(4)
         SIM_update

        # Keep track of current position
         if { ![catch {set ref_pt [SIM_ask_last_position_zcs]} ] } {
            set mom_sim_pos(0) [lindex $ref_pt 0]
            set mom_sim_pos(1) [lindex $ref_pt 1]
            set mom_sim_pos(2) [lindex $ref_pt 2]
         }

         set pattern 0
      }

      incr mom_sim_nc_register(CSYS_ROTATION)
   }

   if [expr $pattern > 0] {
      eval VNC_move_linear_zcs RAPID $coord_list
   }

   set mom_sim_nc_register(LAST_X) $mom_sim_pos(0)
   set mom_sim_nc_register(LAST_Y) $mom_sim_pos(1)
   set mom_sim_nc_register(LAST_Z) $mom_sim_pos(2)
}


#=============================================================
proc PB_CMD_vnc__return_home { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_lg_axis
  global mom_sim_num_machine_axes
  global mom_sim_prev_pos


  # We'll simulate the subspindle movements with different codes.
   if $mom_sim_nc_register(CROSS_MACHINING) {
return
   }


  # Fetch specified components of the intermediate pt.
   set coord_list [list]
   if [info exists mom_sim_nc_register(REF_INT_PT_X)] {
      if [expr $mom_sim_nc_register(REF_INT_PT_X) != $mom_sim_prev_pos(0)] {
         lappend coord_list $mom_sim_lg_axis(X)  $mom_sim_nc_register(REF_INT_PT_X)
      }
   }
   if [info exists mom_sim_nc_register(REF_INT_PT_Y)] {
      if [expr $mom_sim_nc_register(REF_INT_PT_Y) != $mom_sim_prev_pos(1)] {
         lappend coord_list $mom_sim_lg_axis(Y)  $mom_sim_nc_register(REF_INT_PT_Y)
      }
   }
   if [info exists mom_sim_nc_register(REF_INT_PT_Z)] {
      if [expr $mom_sim_nc_register(REF_INT_PT_Z) != $mom_sim_prev_pos(2)] {
         lappend coord_list $mom_sim_lg_axis(Z)  $mom_sim_nc_register(REF_INT_PT_Z)
      }
   }

   if { $mom_sim_num_machine_axes > 3 } {
      if [info exists mom_sim_nc_register(REF_INT_PT_4)] {
         if [expr $mom_sim_nc_register(REF_INT_PT_4) != $mom_sim_prev_pos(3)] {
            lappend coord_list $mom_sim_lg_axis(4)  $mom_sim_nc_register(REF_INT_PT_4)
         }
      }
   }

   if { $mom_sim_num_machine_axes > 4 } {
      if [info exists mom_sim_nc_register(REF_INT_PT_5)] {
         if [expr $mom_sim_nc_register(REF_INT_PT_5) != $mom_sim_prev_pos(4)] {
            lappend coord_list $mom_sim_lg_axis(5)  $mom_sim_nc_register(REF_INT_PT_5)
         }
      }
   }


global mom_sim_message
set mom_sim_message "INT PT >$coord_list<"
PB_CMD_vnc__send_message


  # Position tool to intermediate pt, if specified.
   if { [llength $coord_list] > 0 } {
      eval VNC_move_linear_zcs RAPID $coord_list
   }

  # Position spindle (not tool) to reference pt
   PB_CMD_vnc__send_dogs_home


       # Intermediate pt is saved for subsequent FROM_HOME move
       # then discarded after use.
        #--------------------------------------------------
        # Initialize previous Intermediate Reference Point.
        #--------------------------------------------------
         if [info exists mom_sim_nc_register(REF_INT_PT_X_PREV)] {
            unset mom_sim_nc_register(REF_INT_PT_X_PREV)
         }
         if [info exists mom_sim_nc_register(REF_INT_PT_Y_PREV)] {
            unset mom_sim_nc_register(REF_INT_PT_Y_PREV)
         }
         if [info exists mom_sim_nc_register(REF_INT_PT_Z_PREV)] {
            unset mom_sim_nc_register(REF_INT_PT_Z_PREV)
         }
         if [info exists mom_sim_nc_register(REF_INT_PT_4_PREV)] {
            unset mom_sim_nc_register(REF_INT_PT_4_PREV)
         }
         if [info exists mom_sim_nc_register(REF_INT_PT_5_PREV)] {
            unset mom_sim_nc_register(REF_INT_PT_5_PREV)
         }

        #-----------------------------------------
        # Initialize Intermediate Reference Point.
        #-----------------------------------------
         if [info exists mom_sim_nc_register(REF_INT_PT_X)] {
            set mom_sim_nc_register(REF_INT_PT_X_PREV) $mom_sim_nc_register(REF_INT_PT_X)
            unset mom_sim_nc_register(REF_INT_PT_X)
         }
         if [info exists mom_sim_nc_register(REF_INT_PT_Y)] {
            set mom_sim_nc_register(REF_INT_PT_Y_PREV) $mom_sim_nc_register(REF_INT_PT_Y)
            unset mom_sim_nc_register(REF_INT_PT_Y)
         }
         if [info exists mom_sim_nc_register(REF_INT_PT_Z)] {
            set mom_sim_nc_register(REF_INT_PT_Z_PREV) $mom_sim_nc_register(REF_INT_PT_Z)
            unset mom_sim_nc_register(REF_INT_PT_Z)
         }
         if [info exists mom_sim_nc_register(REF_INT_PT_4)] {
            set mom_sim_nc_register(REF_INT_PT_4_PREV) $mom_sim_nc_register(REF_INT_PT_4)
            unset mom_sim_nc_register(REF_INT_PT_4)
         }
         if [info exists mom_sim_nc_register(REF_INT_PT_5)] {
            set mom_sim_nc_register(REF_INT_PT_5_PREV) $mom_sim_nc_register(REF_INT_PT_5)
            unset mom_sim_nc_register(REF_INT_PT_5)
         }

  # Reset controller
   VNC_reset_controller
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

   SIM_ask_nc_axes_of_mtool

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
      SIM_set_current_ref_junction $mom_sim_pivot_jct
   } else {
      SIM_set_current_ref_junction $mom_sim_spindle_jct
   }

  # Set RAPID mode
   VNC_set_feedrate_mode RAPID

   set time 1

   if { ![info exists mom_sim_pos_mtcs(0)] } {
      if $move_X {
         SIM_move_linear_axis $time $mom_sim_mt_axis(X) [lindex $mom_sim_nc_register(REF_PT) 0]
      }
      set ref_pt [SIM_ask_last_position_mtcs]
      set mom_sim_pos_mtcs(0) [lindex $ref_pt 0]
   }
   if { ![info exists mom_sim_pos_mtcs(1)] } {
      if $move_Y {
         SIM_move_linear_axis $time $mom_sim_mt_axis(Y) [lindex $mom_sim_nc_register(REF_PT) 1]
      }
      set ref_pt [SIM_ask_last_position_mtcs]
      set mom_sim_pos_mtcs(1) [lindex $ref_pt 1]
   }
   if { ![info exists mom_sim_pos_mtcs(2)] } {
      if $move_Z {
         SIM_move_linear_axis $time $mom_sim_mt_axis(Z) [lindex $mom_sim_nc_register(REF_PT) 2]
      }
      set ref_pt [SIM_ask_last_position_mtcs]
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


   eval SIM_move_linear_mtcs $coord_list


global mom_sim_message
set mom_sim_message "REF PT >$mom_sim_nc_register(REF_PT)<"
PB_CMD_vnc__send_message


   global mom_sim_pos

   if [expr $mom_sim_num_machine_axes > 3] {
      if $move_4 {
         SIM_move_rotary_axis $time $mom_sim_mt_axis(4) 0
         set mom_sim_pos(3) 0
      }
   }

   if [expr $mom_sim_num_machine_axes > 4] {
      if $move_5 {
         SIM_move_rotary_axis $time $mom_sim_mt_axis(5) 0
         set mom_sim_pos(4) 0
      }
   }
 
   SIM_update

   SIM_set_current_ref_junction $mom_sim_current_junction

  # Keep track of current position
   if { ![catch {set ref_pt [SIM_ask_last_position_zcs]} ] } {
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
proc PB_CMD_vnc__send_message { } {
#=============================================================
# Comment the "return" statement below to output debug messages to ISV dialog.
return

   global mom_sim_message

   PB_VNC_send_message "$mom_sim_message"
}


#=============================================================
proc PB_CMD_vnc__set_feed { } {
#=============================================================
  global mom_sim_nc_register

   if { [string match "RAPID" $mom_sim_nc_register(MOTION)] || \
        [expr $mom_sim_nc_register(F) <= 0] } {

      global mom_sim_rapid_feed_rate
      if { $mom_sim_nc_register(UNIT) == "MM" } {
         SIM_set_feed $mom_sim_rapid_feed_rate MM_PER_MIN
      } else {
         SIM_set_feed $mom_sim_rapid_feed_rate INCH_PER_MIN
      }
   } else {
      SIM_set_feed $mom_sim_nc_register(F) $mom_sim_nc_register(FEED_MODE)
   }
}


#=============================================================
proc PB_CMD_vnc__set_feedrate_mode { } {
#=============================================================
  global mom_sim_cutting_mode
  global mom_sim_feedrate_mode
  global sim_feedrate_mode

   if [info exists mom_sim_cutting_mode] {
      set mom_sim_cutting_modd "RAPID"
   } 

   SIM_set_cutting_mode  $mom_sim_cutting_mode

   set sim_feedrate_mode $mom_sim_cutting_mode
   set mom_sim_feedrate_mode $mom_sim_cutting_mode


   PB_CMD_vnc__set_feed
}


#=============================================================
proc PB_CMD_vnc__set_param_per_msg { } {
#=============================================================
  global mom_sim_msg_key mom_sim_msg_word


PB_VNC_output_debug_msg "VNC_MSG - key:$mom_sim_msg_key  word:$mom_sim_msg_word"


   switch $mom_sim_msg_key {

      "HELIX_PITCH" {
         global mom_sim_PI
         global mom_sim_helix_pitch
         set mom_sim_helix_pitch "[expr $mom_sim_msg_word / (2 * $mom_sim_PI)]"
         global mom_sim_PI
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

         PB_CMD_vnc__set_speed
      }

      "TOOL_NAME" {
         global mom_sim_ug_tool_name mom_sim_tool_change
         set mom_sim_ug_tool_name "$mom_sim_msg_word"
         set mom_sim_tool_change 1
       }

      "TOOL_OFFSET" {
         global mom_sim_tool_offset_used
         set mom_sim_tool_offset_used "$mom_sim_msg_word"
      }

      "TOOL_X_OFF" {
         global mom_sim_tool_offset
         set mom_sim_tool_offset(0) "$mom_sim_msg_word"
      }

      "TOOL_Y_OFF" {
         global mom_sim_tool_offset
         set mom_sim_tool_offset(1) "$mom_sim_msg_word"
      }

      "TOOL_Z_OFF" {
         global mom_sim_tool_offset
         set mom_sim_tool_offset(2) "$mom_sim_msg_word"
      }

      "TOOL_CARRIER_ID" {
         global mom_sim_tool_carrier_id
         set mom_sim_tool_carrier_id "$mom_sim_msg_word"
      }

      "TOOL_POCKET_ID" {
         global mom_sim_tool_pocket_id
         set mom_sim_tool_pocket_id "$mom_sim_msg_word"
      }

      "HEAD_NAME" {
         global mom_sim_machine_head
         set mom_sim_machine_head "$mom_sim_msg_word"
      }

      "POST_NAME" {
         global mom_sim_post_name
         set mom_sim_post_name "$mom_sim_msg_word"

         global mom_sim_vnc_handler
         global mom_sim_vnc_handler_loaded

         set new_vnc_file [string trim ${mom_sim_post_name}_vnc.tcl]
         set new_vnc_file [join [split $new_vnc_file \\] /]

         if { [string compare [string trim $mom_sim_vnc_handler_loaded] $new_vnc_file] } {
            uplevel #0 {
               source ${mom_sim_post_name}_vnc.tcl
            }

            PB_CMD_vnc__init_sim_vars
         }
      }

      "CYCLE_SPINDLE_AXIS" {
         global mom_sim_cycle_spindle_axis
         set mom_sim_cycle_spindle_axis "$mom_sim_msg_word"
      }

      "FIXTURE_OFFSET" {
      }

      default {
      }
   }


  # Grab NURBS
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
         PB_CMD_vnc__sim_motion

         unset mom_sim_nurbs_start
      }
   }


  # Grab CSYS_MTX_'s
   global mom_sim_csys_matrix mom_sim_csys_set

   if $mom_sim_csys_set {
return
   }

   if [string match "CSYS_MTX_*" $mom_sim_msg_key] {
      set tokens [split $mom_sim_msg_key _]
      set idx [lindex $tokens 2]

      set mom_sim_csys_matrix($idx) "$mom_sim_msg_word"

     # When csys is completely defined, map and set ZCS junction for simulation.
      if { $idx == 11 } {
         PB_CMD_vnc__set_kinematics
         set mom_sim_csys_set 1
      }
   }
}


#=============================================================
proc PB_CMD_vnc__set_speed { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_spindle_speed mom_sim_spindle_mode
  global mom_sim_spindle_max_rpm

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

   if { $spindle_mode == "REV_PER_MIN" } {
      SIM_set_speed $spindle_speed $spindle_mode
   } else {
      global primary_channel
      if [info exists primary_channel] {
         SIM_primary_channel $primary_channel
      }

      if { $spindle_mode == "SFM" } { 
         SIM_set_surface_speed $spindle_speed "FEET_PER_MIN"
      } else {
         SIM_set_surface_speed $spindle_speed "M_PER_MIN"
      }
   }
}


#=============================================================
proc PB_CMD_vnc__sim_motion { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nurbs_start


  # Disable simulation when a NURBS definition starts.
   if { [info exists mom_sim_nurbs_start] && !$mom_sim_nurbs_start } {
return
   }

  # Set feed & speed
   PB_CMD_vnc__set_feed
   PB_CMD_vnc__set_speed


  # We'll simulate the sub-spindle movements with different codes.
   if $mom_sim_nc_register(CROSS_MACHINING) {
return
   }


global mom_sim_o_buffer
global mom_sim_message
set mom_sim_message "** $mom_sim_nc_register(MOTION) -- $mom_sim_o_buffer **"
PB_CMD_vnc__send_message


  # Create a temp jct for subsequent moves incase the tool is not set properly.
   VNC_create_tmp_jct

   switch $mom_sim_nc_register(MOTION) {
      "RAPID" {
         VNC_rapid_move
      }

      "LINEAR" {
         VNC_linear_move
      }

      "CIRCULAR_CLW" {
         VNC_circular_move CLW
      }

      "CIRCULAR_CCLW" {
         VNC_circular_move CCLW
      }

      "NURBS" {
         if $mom_sim_nurbs_start {
            VNC_nurbs_move
         }
      }
   }

   if [string match "CYCLE_*" $mom_sim_nc_register(MOTION)] {
      VNC_cycle_move
   }
}


#=============================================================
proc PB_CMD_vnc__sim_other_devices { } {
#=============================================================
   PB_CMD_vnc____sim_other_devices

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Simulate more devices specific for a subordinate VNC.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_sim_nc_word

   switch $mom_sim_nc_word {
   }
}


#=============================================================
proc PB_CMD_vnc__start_of_path { } {
#=============================================================

  # Redefine MOM_helix_move & pass info to VNC.
   if { [llength [info commands "MOM_SYS_helix_move"]] == 0 } {
      if [llength [info commands "MOM_helix_move"]] {
         rename MOM_helix_move MOM_SYS_helix_move

         uplevel #0 {

            proc MOM_helix_move {} {
               PB_CMD_vnc__pass_helix_pitch
               MOM_SYS_helix_move
            }
         }

        # Fetch global pitch info
         PB_CMD_vnc__pass_helix_data
      }
   }


  # Redefine MOM_nurbs_move & pass info to VNC.
   if { [llength [info commands "MOM_SYS_nurbs_move"]] == 0 } {
      if [llength [info commands "MOM_nurbs_move"]] {

         rename MOM_nurbs_move MOM_SYS_nurbs_move

         uplevel #0 {

            proc MOM_nurbs_move {} {

               PB_CMD_vnc__pass_nurbs_start

               MOM_SYS_nurbs_move

               PB_CMD_vnc__pass_nurbs_data
            }
         }
      }
   }

  # Set machining mode
   global mom_sim_vnc_msg_only
   global mom_sim_nc_register
   if { ![info exists mom_sim_vnc_msg_only] || !$mom_sim_vnc_msg_only } {
      SIM_set_machining_mode $mom_sim_nc_register(MACHINE_MODE)
   }
}


#=============================================================
proc PB_CMD_vnc__start_of_program { } {
#=============================================================
  global mom_multi_channel_mode


   if [info exists mom_multi_channel_mode] {

     # Set up sync manager dialog
      if [llength [info commands "PB_CMD_vnc__config_sync_dialog"]] {
         PB_CMD_vnc__config_sync_dialog
      }

     # Initialize parameters for sync manager
      if [llength [info commands "PB_CMD_vnc__init_sync_manager"]] {
         PB_CMD_vnc__init_sync_manager
      }
   }


  # Mount part onto sub-spindle
   if { [llength [info commands "PB_CMD_vnc__mount_part"]] } {
      PB_CMD_vnc__mount_part
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
   PB_CMD_vnc__send_dogs_home

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

      global mom_sim_tool_carrier_id
      global mom_sim_turret_carriers
      global mom_sim_turret_axis
      global mom_sim_tool_pocket_id

      set done_tool_change 0

      set tool_change_time 5

      if { [info exists mom_sim_tool_carrier_id] && [info exists mom_sim_tool_pocket_id] && \
           [info exists mom_sim_turret_carriers] } {

         if { [lsearch $mom_sim_turret_carriers $mom_sim_tool_carrier_id] >= 0 } {

            global mom_sim_pocket_angle

            SIM_move_rotary_axis $tool_change_time $mom_sim_turret_axis($mom_sim_tool_carrier_id)\
                                 $mom_sim_pocket_angle($mom_sim_tool_carrier_id,$mom_sim_tool_pocket_id)
            SIM_ask_kim_comp_name_by_id "TOOL" $mom_sim_ug_tool_name

            set done_tool_change 1
         }
      }

      if { $done_tool_change == 0 } {
         VNC_unmount_tool $sim_prev_tool_name
         VNC_set_ref_jct ""
         SIM_mount_tool $tool_change_time "UG_NAME" "$mom_sim_ug_tool_name"\
                        "$mom_sim_spindle_comp" "$mom_sim_spindle_jct"
      }


      set sim_tool_name $mom_sim_result 

      if {$sim_tool_name != ""} {
         SIM_activate_tool $sim_tool_name
      }

      SIM_update 

      set sim_prev_tool_name $mom_sim_ug_tool_name

      set mom_sim_tool_loaded $sim_tool_name

     # Flag that a tool change is done.
      set mom_sim_tool_change 0

      VNC_set_ref_jct $sim_tool_name
 
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

         PB_CMD_vnc__offset_tool_jct
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


#=============================================================
proc PB_CMD_vnc__unset_Y_axis { } {
#=============================================================
#  This command is called in PB_CMD_vnc__init_sim_vars
#  to unset the variable mom_sim_mt_axis(Y) for a lathe
#  that does not have a physical Y-axis defined in the model.
#
  global mom_sim_mt_axis
  global mom_sim_result1


   set re_config 0

   SIM_ask_nc_axes_of_mtool

   if [info exists mom_sim_mt_axis(Y)] {
      if { [lsearch $mom_sim_result1 $mom_sim_mt_axis(Y)] < 0 } {
         unset mom_sim_mt_axis(Y)
         set re_config 1
      }
   }


   if $re_config {

      set axes_config_list [list]

      if [info exists mom_sim_mt_axis(X)] {
         if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(X)"] >= 0 } {
            lappend axes_config_list $mom_sim_mt_axis(X)
         }
      }

      if [info exists mom_sim_mt_axis(Z)] {
         if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Z)"] >= 0 } {
            lappend axes_config_list $mom_sim_mt_axis(Z)
         }
      }

      SIM_set_linear_axes_config [concat $axes_config_list]
   }
}


#=============================================================
proc PB_CMD_vnc__validate_machine_tool { } {
#=============================================================
# This command is called PB_CMD_vnc__init_sim_vars
# to validate the machine tool kinematics assignments.
#
  global mom_sim_result mom_sim_result1
  global mom_sim_mt_axis
  global mom_sim_zcs_base_MCS
  global mom_sim_zcs_base_LCS
  global mom_sim_spindle_comp
  global mom_sim_spindle_jct
  global mom_sim_pivot_jct
  global mom_sim_advanced_kinematic_jct


   set __msg ""

  # Validate machine axes
  #
   SIM_ask_nc_axes_of_mtool

   set axes_list { mom_sim_mt_axis(X) mom_sim_mt_axis(Y) mom_sim_mt_axis(Z) mom_sim_mt_axis(4) mom_sim_mt_axis(5) }

   foreach axis $axes_list {
      if [info exists $axis] {
         set val [eval format $[set axis]]
         if { [lsearch $mom_sim_result1 $val] < 0 } {
            set __msg "$__msg\n Machine axis \"$val\" for $axis is not defined in the model."
         }
      }
   }


  # Validate KIM components
  #
  # KIM component MACHINE_BASE is always assumed to exist for now
  # until it can be verified easily in the future!!!
  #
   set machine_base MACHINE_BASE

   set comps_list { mom_sim_zcs_base_MCS mom_sim_zcs_base_LCS mom_sim_spindle_comp }

   foreach comp $comps_list {
      if [info exists $comp] {
         set val [eval format $[set comp]]
         if { ![string match "$machine_base" $val] && ![string match "" $val] } {
            SIM_find_comp_by_name $machine_base $val
            if { $mom_sim_result == 0 } {
               set __msg "$__msg\n Component \"$val\" for $comp is not found in the model."
            }
         }
      }
   }


  # Validate junctions
  #
   set jcts_list { mom_sim_spindle_jct mom_sim_pivot_jct mom_sim_advanced_kinematic_jct }

   foreach jct $jcts_list {
      if [info exists $jct] {
         set val [eval format $[set jct]]

         if { ![string match "" [string trim $val]] } {

            if { ![string match "*@*" $val] } {
               set val_jct "$mom_sim_spindle_comp@$val"
            } else {
               set val_jct "$val"
            }
            SIM_ask_is_junction_exist $val_jct
            if { $mom_sim_result == 0 } {
               set __msg "$__msg\n Junction \"$val_jct\" for $jct does not exist in the model."
            }
         }
      }
   }


  #--------------------------------
  # Invalid set up found! Bail out!
  #--------------------------------
   if { ![string match "" $__msg] } {
      global mom_sim_vnc_handler_loaded

      VNC_pause "[VNC_trace]\nVNC : $mom_sim_vnc_handler_loaded ...\n\n$__msg"

      SIM_mtd_reset
      MOM_abort "***  Abort ISV due to error in machine tool kinematics.  ***"
   }
}




