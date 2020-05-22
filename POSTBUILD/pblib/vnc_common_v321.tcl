##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################
#                       V N C _ C O M M O N _V 3 2 1 . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains handlers for pre-v321 VNC conversion.
#
##############################################################################


#===============================================================================
proc PB_CMD_vnc__ask_feedrate_mode { } {
#===============================================================================
  global mom_feed_rate_mode

   if [info exists mom_feed_rate_mode] {
      switch $mom_feed_rate_mode {
         IPM     { set feed_units "INCH_PER_MIN" }
         MMPM    { set feed_units "MM_PER_MIN"}
         IPR     { set feed_units "INCH_PER_REV" }
         MMPR    { set feed_units "MM_PER_REV" }
         FRN     { set feed_units "MM_PER_100REV" }
         default { set feed_units "UNKNOWN FEEDRATE UNITS" }
      }
   } else {
      set feed_units "UNKNOWN FEEDRATE UNITS" 
   }

return $feed_units 
}


#===============================================================================
proc PB_CMD_vnc__set_feedrate_mode { } {
#===============================================================================
  global mom_sim_cutting_mode

   if [info exists mom_sim_cutting_mode] {
      set cutting_mode $mom_sim_cutting_mode
   } else {
      set cutting_mode "RAPID"
   }


  global mom_feed_rate
  global sim_feedrate_mode

   SIM_set_cutting_mode $cutting_mode

   set sim_feedrate_mode $cutting_mode

   if { $cutting_mode == "RAPID" } {
     # we need here the actual rapid speed. meanwhile we use what we have
      SIM_set_feed $mom_feed_rate [VNC_ask_feedrate_mode]
   } else {
      SIM_set_feed $mom_feed_rate [VNC_ask_feedrate_mode]
   }
}


#===============================================================================
proc PB_CMD_vnc__ask_speed_mode { } {
#===============================================================================
  global mom_spindle_mode

   if [info exists mom_spindle_mode] {
      switch $mom_spindle_mode {
         RPM     { set speed_units "REV_PER_MIN" }
#        SFM     {}
#        SMM     {}
         default { set speed_units "UNKNOWN SPEED UNITS" }
      }
   } else {
      set speed_units "UNKNOWN SPEED UNITS" 
   }

return $speed_units
}


#=============================================================
proc PB_CMD_vnc__create_tmp_jct {} {
#=============================================================
  global mom_sim_tool_junction mom_sim_current_junction
  global mom_sim_curr_jct_matrix mom_sim_curr_jct_origin
  global mom_sim_tool_loaded


   if { ![string match "$mom_sim_tool_junction" "$mom_sim_current_junction"] } {

     # Somehow junctions can not be deleted!?
      global mom_sim_result
      global mom_sim_tmp_tool_jct_index

      if { ![info exists mom_sim_tmp_tool_jct_index] } {
         set mom_sim_tmp_tool_jct_index 0
      }

      SIM_ask_is_junction_exist __SIM_TMP_TOOL_JCT__$mom_sim_tmp_tool_jct_index

      if { $mom_sim_result == 1 } {
         incr mom_sim_tmp_tool_jct_index
      }
      set tmp_tool_jct "__SIM_TMP_TOOL_JCT__$mom_sim_tmp_tool_jct_index"

      eval SIM_create_junction $tmp_tool_jct $mom_sim_tool_loaded \
                               $mom_sim_curr_jct_origin $mom_sim_curr_jct_matrix

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
proc PB_CMD_vnc__reload_kinematics { } {
#=============================================================
  global mom_sim_mt_axis
  global sim_prev_zcs
  global mom_sim_num_machine_axes mom_sim_advanced_kinematic_jct


   set current_zcs "$mom_sim_advanced_kinematic_jct"


  # Set kinematics based on the machine tool kinematics model
  # current_zcs represents the MCS used with this machine

   if { [VNC_machine_tool_model_exists]  &&  $sim_prev_zcs != $current_zcs } {

      if { $mom_sim_num_machine_axes == 4 } {

         VNC_set_post_kinematics $current_zcs $mom_sim_mt_axis(X) \
                                              $mom_sim_mt_axis(Y) \
                                              $mom_sim_mt_axis(Z) \
                                              $mom_sim_mt_axis(4)
      } elseif { $mom_sim_num_machine_axes == 5 } {

         VNC_set_post_kinematics $current_zcs $mom_sim_mt_axis(X) \
                                              $mom_sim_mt_axis(Y) \
                                              $mom_sim_mt_axis(Z) \
                                              $mom_sim_mt_axis(4) \
                                              $mom_sim_mt_axis(5)
      }

      set sim_prev_zcs $current_zcs
   }


#>>>>> Advanced kinematics
#   set uf_library "ugpadvkins.dll"
#   MOM_run_user_function [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]$uf_library ufusr


   MOM_reload_kinematics
}


#=============================================================
proc PB_CMD_vnc__calculate_duration_time { } {
#=============================================================
  global mom_sim_motion_linear_or_angular mom_sim_travel_delta mom_sim_duration_time

  global mom_feed_rate
  global sim_feedrate_mode
  global mom_sim_nc_register
  global mom_sim_rapid_feed_rate


   set linear_or_angular $mom_sim_motion_linear_or_angular
   set delta $mom_sim_travel_delta

  # For now, we don't compute durations for angular motions
   if { $linear_or_angular == "ANGULAR" } {
      set mom_sim_duration_time 0
return
   }

   if { $sim_feedrate_mode == "RAPID" } {
      set feed $mom_sim_rapid_feed_rate
   } else {
      set feed $mom_feed_rate
   }

   set length [expr abs($delta)]

   if {[expr abs($feed)] < 0.00001 || $length < 0.00001 } {
      set time 0
   } else {
      set time [expr ($length / $feed) * 60.0]
   }

   set mom_sim_duration_time $time
}


#=============================================================
proc PB_CMD_vnc__start_of_program { } {
#=============================================================
}


#=============================================================
proc PB_CMD_vnc__start_of_path { } {
#=============================================================
}


#=============================================================
proc PB_CMD_vnc__end_of_path { } {
#=============================================================
}


#=============================================================
proc PB_CMD_vnc__end_of_program { } {
#=============================================================
}


#=============================================================
proc PB_CMD_vnc__G_adjust_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_code
  global mom_sim_nc_func


   set codes_list [list]
    lappend codes_list $mom_sim_nc_func(TL_ADJUST_PLUS)
    lappend codes_list $mom_sim_nc_func(TL_ADJUST_MINUS)
    lappend codes_list $mom_sim_nc_func(TL_ADJUST_CANCEL)


   global mom_sim_o_buffer
   foreach code $codes_list {

      if [VNC_parse_nc_block mom_sim_o_buffer $code] {

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
proc PB_CMD_vnc__G_misc_code { } {
#=============================================================
  global mom_sim_pos
  global mom_sim_nc_register
  global mom_sim_nc_code
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

      if [VNC_parse_nc_block mom_sim_o_buffer $code] {

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
  global mom_sim_nc_code
  global mom_sim_nc_func


   set codes_list [list]
    lappend codes_list $mom_sim_nc_func(INPUT_ABS)
    lappend codes_list $mom_sim_nc_func(INPUT_INC)


   global mom_sim_o_buffer
   foreach code $codes_list {

      if [VNC_parse_nc_block mom_sim_o_buffer $code] {

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
  global mom_sim_nc_code
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

      if [VNC_parse_nc_block mom_sim_o_buffer $code] {

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
  global mom_sim_nc_code
  global mom_sim_nc_func
  global mom_sim_cycle_spindle_axis


   set codes_list [list]
    lappend codes_list $mom_sim_nc_func(PLANE_XY)
    lappend codes_list $mom_sim_nc_func(PLANE_YZ)
    lappend codes_list $mom_sim_nc_func(PLANE_ZX)


   global mom_sim_o_buffer
   foreach code $codes_list {

      if [VNC_parse_nc_block mom_sim_o_buffer $code] {

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

   global mom_sim_circular_plane
   set mom_sim_circular_plane $mom_sim_nc_register(PLANE)
}


#=============================================================
proc PB_CMD_vnc__M_misc_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_code
  global mom_sim_nc_func


   set codes_list [list]
    lappend codes_list $mom_sim_nc_func(PROG_STOP)
    lappend codes_list $mom_sim_nc_func(PROG_OPSTOP)
    lappend codes_list $mom_sim_nc_func(PROG_END)
    lappend codes_list $mom_sim_nc_func(TOOL_CHANGE)
    lappend codes_list $mom_sim_nc_func(PROG_STOP_REWIND)


   global mom_sim_o_buffer
   foreach code $codes_list {

      if [VNC_parse_nc_block mom_sim_o_buffer $code] {

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
proc PB_CMD_vnc__pass_csys_data { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_csys_matrix

  global mom_coordinate_system_purpose
  global mom_special_output
  global mom_kin_coordinate_system_type
  global mom_machine_csys_matrix

   if [info exists mom_machine_csys_matrix] {

      if [string match "MAIN" $mom_kin_coordinate_system_type] {
         for { set i 0 } { $i < 12 } { incr i } {
            MOM_output_text "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                                CSYS_MTX_$i==$mom_machine_csys_matrix($i)\
                                $mom_sim_control_in"
         }
      } else {

         MTX3_multiply mom_machine_csys_matrix mom_csys_matrix matrix

         set matrix(9)  [expr $mom_machine_csys_matrix(9)  + $mom_csys_matrix(9)]
         set matrix(10) [expr $mom_machine_csys_matrix(10) + $mom_csys_matrix(10)]
         set matrix(11) [expr $mom_machine_csys_matrix(11) + $mom_csys_matrix(11)]

         for { set i 0 } { $i < 12 } { incr i } {
            MOM_output_text "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                                CSYS_MTX_$i==$matrix($i) $mom_sim_control_in"
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__pass_msys_data { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_msys_matrix mom_msys_origin

   for { set i 0 } { $i < 9 } { incr i } {
      MOM_output_text "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                          CSYS_MTX_$i==$mom_msys_matrix($i) $mom_sim_control_in"
   }

   for { set j 0 } { $j < 3 } { incr j } {
      MOM_output_text "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                          CSYS_MTX_$i==$mom_msys_origin($j) $mom_sim_control_in"
      incr i
   }
}


#=============================================================
proc PB_CMD_vnc__pass_head_data { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_sys_postname
  global CURRENT_HEAD


   set post_name $mom_sys_postname($CURRENT_HEAD)

   MOM_output_text "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       HEAD_NAME==$CURRENT_HEAD $mom_sim_control_in"
   MOM_output_text "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       POST_NAME==$post_name $mom_sim_control_in"
}


#=============================================================
proc PB_CMD_vnc__pass_tool_data { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_tool_name
  global mom_tool_offset_defined mom_tool_offset
  global mom_sim_tool_change


  # Readied for a tool change
   set mom_sim_tool_change 1

   if { ![info exists mom_tool_offset(0)] } { set mom_tool_offset(0) 0 }
   if { ![info exists mom_tool_offset(1)] } { set mom_tool_offset(1) 0 }
   if { ![info exists mom_tool_offset(2)] } { set mom_tool_offset(2) 0 }

   MOM_output_text "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_NAME==$mom_tool_name $mom_sim_control_in"

   MOM_output_text "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_OFFSET==$mom_tool_offset_defined $mom_sim_control_in"

   MOM_output_text "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_X_OFF==$mom_tool_offset(0) $mom_sim_control_in"

   MOM_output_text "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_Y_OFF==$mom_tool_offset(1) $mom_sim_control_in"

   MOM_output_text "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_Z_OFF==$mom_tool_offset(2) $mom_sim_control_in"
}


#=============================================================
proc PB_CMD_vnc__reset_coordinate { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_offset_pt
  global mom_sim_motion_begun
  global mom_sim_prev_pos


   if [string match "MILL" $mom_sim_nc_register(MACHINE_MODE)] {


global mom_sim_message
set mom_sim_message " Local Offset before : $mom_sim_nc_register(LOCAL_OFFSET)"
PB_CMD_vnc__send_message


if [info exists mom_sim_offset_pt] {
   set mom_sim_message "   offset pt : [array get mom_sim_offset_pt]"
   PB_CMD_vnc__send_message
}


      for {set i 0} {$i < 5} {incr i} {

        # Only change the components that exist.
         if [info exists mom_sim_offset_pt($i)] {
           #---------------------------------------------------
           # Do not change offset when the motion hasn't begun,
           # since mom_sim_prev_pos may not be reliable.
           #---------------------------------------------------
            if $mom_sim_motion_begun {
               set offset [expr $mom_sim_offset_pt($i) - $mom_sim_prev_pos($i)]
               set mom_sim_nc_register(LOCAL_OFFSET) \
                   [lreplace $mom_sim_nc_register(LOCAL_OFFSET) $i $i $offset]
            }
         }
      }

set mom_sim_message " Local Offset after : $mom_sim_nc_register(LOCAL_OFFSET)"
PB_CMD_vnc__send_message

   }

}


#=============================================================
proc PB_CMD_vnc__fix_nc_definitions { } {
#=============================================================
  global mom_sim_nc_func

  # Added these G codes here to force v321 file conversion
  # for the changes in default PB_CMD_vnc____set_nc_definitions
  #
   set mom_sim_nc_func(RETURN_HOME_P)       "G30"
   set mom_sim_nc_func(FROM_HOME)           "G29"
   set mom_sim_nc_func(MACH_CS_MOVE)        "G53"
   set mom_sim_nc_func(WORK_CS_1)           "G54"
   set mom_sim_nc_func(WORK_CS_2)           "G55"
   set mom_sim_nc_func(WORK_CS_3)           "G56"
   set mom_sim_nc_func(WORK_CS_4)           "G57"
   set mom_sim_nc_func(WORK_CS_5)           "G58"
   set mom_sim_nc_func(WORK_CS_6)           "G59"
   set mom_sim_nc_func(LOCAL_CS_SET)        "G52"

  # Set circular plane code for legacy VNC
   global mom_sim_circular_plane
   set mom_sim_circular_plane XY
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

  #<03-05-04 gsl>
   if { ![info exists mom_sim_nc_register(K_cycle)] } {
      set mom_sim_nc_register(K_cycle) ""
   }


global mom_sim_message mom_sim_cycle_feed_to_addr
set mom_sim_message "CYCLE : $mom_sim_nc_register($mom_sim_cycle_feed_to_addr) \
                             $mom_sim_nc_register(R) $mom_sim_nc_register(K_cycle)"
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

         set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) \
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

         if [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) == \
                  $mom_sim_pos($mom_sim_cycle_spindle_axis)] {
            set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) \
                [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) - $mom_sim_cycle_rapid_to_dist]
         }

         set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) \
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

         if [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) == \
                  $mom_sim_pos($mom_sim_cycle_spindle_axis)] {
            set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) \
               [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) - $mom_sim_cycle_retract_to_dist]
         }

         set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) \
             [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_retract_to_dist]
      } else {
         set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(K_cycle)
      }

   } elseif [string match "G98/G99*" $mom_sim_cycle_mode(retract_to)] {

      global mom_sim_nc_func

      if [VNC_parse_nc_block mom_sim_o_buffer $mom_sim_nc_func(CYCLE_RETURN_MANUAL)] {

         switch $mom_sim_cycle_spindle_axis {
            0 {
               set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis)  $mom_sim_nc_register(LAST_X)
            }
            1 {
               set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis)  $mom_sim_nc_register(LAST_Y)
            }
            default {
               set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis)  $mom_sim_nc_register(LAST_Z)
            }
         }
      }
   }


   if { !$mom_sim_cycle_mode(start_block) } {
      PB_CMD_vnc__cycle_move
   }
}


#=============================================================
proc PB_CMD_vnc__display_version { } {
#=============================================================
  global mom_sim_vnc_handler mom_sim_post_builder_version

   PB_VNC_send_message "> Virtual NC Controller ($mom_sim_vnc_handler) created with Post Builder v$mom_sim_post_builder_version."
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
  global mom_sim_spindle_comp mom_sim_spindle_jct
  global mom_sim_mt_axis
  global mom_sim_PI
  global mom_sim_cycle_spindle_axis
  global mom_sim_vnc_msg_prefix

  global mom_sim_isv_debug_msg_file


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # File to collect debug messages when calling PB_VNC_output_debug_msg msg.
  # Debug messages and file will not be generated, if this variable is
  # not defined or set to an empty string.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # set mom_sim_isv_debug_msg_file "C:\\\\__ISV_debug.log"


   set mom_sim_PI [expr acos(-1.0)]

   set mom_sim_vnc_msg_prefix "VNC_MSG::"


  # Initialize a null list for other NC codes to simulate.
  # Actual code list will be defined in PB_CMD_vnc____set_nc_definitions.
   global mom_sim_other_nc_codes
   set mom_sim_other_nc_codes [list]


  # Initialize physical machine tool axes assignment
  # So there won't be null variable referenced in subsequent code.
  # Actual assignments are carried out in ____map function.
   set mom_sim_mt_axis(X) X
   set mom_sim_mt_axis(Y) Y
   set mom_sim_mt_axis(Z) Z
   set mom_sim_mt_axis(4) A
   set mom_sim_mt_axis(5) B


  # Initialize cycle spindle axis to Z
   set mom_sim_cycle_spindle_axis 2


  # Initialize plane code register
   set mom_sim_nc_register(PLANE) XY


  # Transfer static data from the Post.
   VNC_set_nc_definitions



  # When a VNC is used to output VNC messages only w/o simulation.
   global mom_sim_vnc_msg_only
   if { [info exists mom_sim_vnc_msg_only] && $mom_sim_vnc_msg_only } {
return
   }



  # Display message about this VNC.
   if [llength [info commands "PB_CMD_vnc__display_version"]] {
      PB_CMD_vnc__display_version
   }


  # Add user's NC data definition.
   if [llength [info commands "PB_CMD_vnc__set_nc_definitions"]] {
      PB_CMD_vnc__set_nc_definitions
   } elseif [llength [info commands "PB_CMD_vnc____set_nc_definitions"]] {
      PB_CMD_vnc____set_nc_definitions
   }


  # Add more user's NC data definition required for conversion.
   if [llength [info commands "PB_CMD_vnc__fix_nc_definitions"]] {
      PB_CMD_vnc__fix_nc_definitions
   }


  # Map machine tool axes assignments
   PB_CMD_vnc____map_machine_tool_axes


  # Logical axes assignments (not from the post?)
  # It works to equate logical names to the physical names.
   global mom_sim_lg_axis mom_sim_nc_axes mom_sim_address
   global mom_sim_num_machine_axes

  # Linear axes are commanded by logical names, whereas
  # rotary axes are commanded by physical names.
   set mom_sim_lg_axis(X) $mom_sim_address(X,leader)
   set mom_sim_lg_axis(Y) $mom_sim_address(Y,leader)
   set mom_sim_lg_axis(Z) $mom_sim_address(Z,leader)

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


  # Initialize some data to be used in simulation.

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
   if { ![info exists mom_sim_nc_register(MOTION)] } {
      set mom_sim_nc_register(MOTION) RAPID
   }
   if { ![info exists mom_sim_nc_register(UNIT)] } {
      set mom_sim_nc_register(UNIT) IN
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

#>>>>>
  # Initialize subspindle activation state
   if { ![info exists mom_sim_nc_register(CROSS_MACHINING)] } {
      set mom_sim_nc_register(CROSS_MACHINING) 0
   }

  # Initialize machine mode
   global mom_sim_machine_type
   if [string match "*wedm*" $mom_sim_machine_type] {
      set mom_sim_nc_register(MACHINE_MODE) WEDM
   } elseif [string match "*lathe*" $mom_sim_machine_type] {
      set mom_sim_nc_register(MACHINE_MODE) TURN
   } else {
      set mom_sim_nc_register(MACHINE_MODE) MILL
   }

  # Initialize csys state
   global mom_sim_csys_set
   set mom_sim_csys_set 0

  # Initialize tool offsets
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
}


#=============================================================
proc PB_CMD_vnc__output_debug_msg { } {
#=============================================================
  global mom_sim_message

   PB_VNC_output_debug_msg $mom_sim_message
}


#=============================================================
proc PB_CMD_vnc__pass_tool_data { } {
#=============================================================
  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_tool_name
  global mom_tool_offset_defined mom_tool_offset
  global mom_sim_tool_change


  # Readied for a tool change
   set mom_sim_tool_change 1

   if { ![info exists mom_tool_offset(0)] } { set mom_tool_offset(0) 0 }
   if { ![info exists mom_tool_offset(1)] } { set mom_tool_offset(1) 0 }
   if { ![info exists mom_tool_offset(2)] } { set mom_tool_offset(2) 0 }

   MOM_output_text "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_NAME==$mom_tool_name $mom_sim_control_in"

   MOM_output_text "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_OFFSET==$mom_tool_offset_defined $mom_sim_control_in"

   MOM_output_text "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_X_OFF==$mom_tool_offset(0) $mom_sim_control_in"

   MOM_output_text "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_Y_OFF==$mom_tool_offset(1) $mom_sim_control_in"

   MOM_output_text "$mom_sim_control_out$mom_sim_vnc_msg_prefix\
                       TOOL_Z_OFF==$mom_tool_offset(2) $mom_sim_control_in"
}


#=============================================================
proc PB_CMD_vnc__send_message { } {
#=============================================================
# Uncomment the "return" statement below to output debug messages to ISV dialog.
return

   global mom_sim_message

   PB_VNC_send_message "$mom_sim_message"
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


  # Current tool has been loaded. Do not change tool.
   if { [info exists mom_sim_tool_change] && !$mom_sim_tool_change } {
return
   }


  # Position spindle to reference point.
   PB_CMD_vnc__send_dogs_home

   set sim_tool_name ""

   if { ![string match "$sim_prev_tool_name" $mom_sim_ug_tool_name] && \
        ![string match "" $mom_sim_ug_tool_name] } {

#>>>>>
#  This is where you add detailed movements such as rotating tool changer,
#  unmounting old tool and mounting new tool and/or getting next tool in ready position.
#<<<<<

      VNC_unmount_tool $sim_prev_tool_name
      SIM_mount_tool "15" "UG_NAME" "$mom_sim_ug_tool_name" \
                                    "$mom_sim_spindle_comp" "$mom_sim_spindle_jct"

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
         global mom_sim_pos
         set mom_sim_pos(1) 0
      }
   }
}




