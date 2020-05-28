########################### Virtual NC Controller ############################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006/2007/2008,           #
#                                                                            #
#                           Siemens PLM Software                             #
#                                                                            #
##############################################################################
#                       V N C _ C O M M O N _ V 6 0 3 . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains handlers for incremental VNC conversion.
#
##############################################################################


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

        # pb603(i) - Force motion mode to linear, if not.
         if { ![string match "RAPID"  $mom_sim_nc_register(MOTION)] &&\
              ![string match "LINEAR" $mom_sim_nc_register(MOTION)] } {

            set mom_sim_nc_register(MOTION) "LINEAR"
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
proc PB_CMD_vnc__define_misc_procs { } {
#=============================================================
 uplevel #0 {

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
        PB_SIM_call SIM_move_rotary_axis 1 $mom_sim_head_spindle_axis $degrees
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

  #-----------------------------------------------------------
  proc VNC_pause_win64 { args } {
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
   set ug_wish "ugwish.exe"


   if { [file exists ${cam_aux_dir}$ug_wish] &&\
        [file exists ${cam_aux_dir}mom_pause_win64.tcl] } {

     set title ""
     set msg ""

     if { [llength $args] == 1 } {
       set msg [lindex $args 0]
     }

     if { [llength $args] > 1 } {
       set title [lindex $args 0]
       set msg [lindex $args 1]
     }


    ######
    # Define a scratch file and pass it to mom_pause_win64.tcl script -
    #
    # - A separated process will be created to construct the Tk dialog.
    #   This process will communicate with the main process via the state of a scratch file.
    #   This scratch file will collect the messages that need to be conveyed from the
    #   child process to the main process.
    ######
     global mom_logname

     set pause_file_name "[MOM_ask_env_var UGII_TMP_DIR]/${mom_logname}_mom_pause_[clock clicks].txt"

     if { [file exists $pause_file_name] } {
        file delete -force $pause_file_name
     }

     regsub -all {\\} $cam_aux_dir {/}  cam_aux_dir
     regsub -all { }  $cam_aux_dir {\ } cam_aux_dir

     regsub -all {\\} $pause_file_name {/}  pause_file_name
     regsub -all { }  $pause_file_name {\ } pause_file_name



    ######
    # The assumption at this point is we will always have the scratch file as the 1st
    # argument and optionally the title and message as the 2nd and 3rd arguments
    ######
     open "|${cam_aux_dir}$ug_wish ${cam_aux_dir}mom_pause_win64.tcl ${pause_file_name} {$title} {$msg}"


    ######
    # Waiting for the mom_pause to complete its process...
    # - This is indicated when the scratch file materialized and became read-only.
    ######
     while { ![file exists $pause_file_name] || [file writable $pause_file_name] } { }



    ######
    # Delay a 100 milli-seconds to ensure that sufficient time is given for the other process to complete.
    ######
     after 100


    ######
    # Open the scratch file to read and process the information.  Close it afterward.
    ######
     set fid [open "$pause_file_name" r]

     set res [string trim [gets $fid]]
     switch $res {
       no {
          set gPB(PB_disable_VNC_pause) 1
       }
       cancel {
          close $fid
          file delete -force $pause_file_name

          set gPB(PB_disable_VNC_pause) 1
          PB_SIM_call SIM_mtd_reset

          uplevel #0 {
             MOM_abort "*** User Abort *** "
          }
       }
       default {}
     }


    ######
    # Delete the scratch file
    ######
     close $fid
     file delete -force $pause_file_name
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



   #==========
   # Win64 OS
   #
   global tcl_platform

   if { [string match "*windows*" $tcl_platform(platform)] } {
     global mom_sys_processor_archit

     if { ![info exists mom_sys_processor_archit] } {
       set pVal ""
       set env_vars [array get env]
       set idx [lsearch $env_vars "PROCESSOR_ARCHITE*"]
       if { $idx >= 0 } {
         set pVar [lindex $env_vars $idx]
         set pVal [lindex $env_vars [expr $idx + 1]]
       }
       set mom_sys_processor_archit $pVal
     }

     if { [string match "*64*" $mom_sys_processor_archit] } {

       VNC_pause_win64 $args
  return
     }
   }



   set cam_aux_dir  [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]


   if { [string match "*windows*" $tcl_platform(platform)] } {
     set ug_wish "ugwish.exe"
   } else {
     set ug_wish ugwish
   }
 
   if { [file exists ${cam_aux_dir}$ug_wish] && [file exists ${cam_aux_dir}mom_pause.tcl] } {

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
          set gPB(PB_disable_VNC_pause) 1
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


#=============================================================
proc PB_CMD_vnc__end_polar_mode { } {
#=============================================================
# This function ends polar mode and restores rotary axis configuration.
#
   global mom_sim_polar_mode

   if { [info exists mom_sim_polar_mode] && $mom_sim_polar_mode == 1 } {

      global mom_sim_pos
      global mom_sim_mt_axis

      global mom_sim_num_machine_axes
      global mom_sim_4th_axis_has_limits
      global mom_sim_5th_axis_has_limits
      global mom_sim_result

      switch $mom_sim_num_machine_axes {
         "4" {
            PB_SIM_call SIM_set_rotary_axes_config  [concat $mom_sim_mt_axis(4)]
         }
         "5" {
            PB_SIM_call SIM_set_rotary_axes_config  [concat $mom_sim_mt_axis(4) $mom_sim_mt_axis(5)]
         }
      }

      PB_SIM_call SIM_set_machining_mode MILL


     # Do not unwind rotary table, if it's limitless.
      set nx $mom_sim_num_machine_axes

      if { ![eval set mom_sim_${nx}th_axis_has_limits] } {

         PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis($nx) NORM_180

        # Fetch current angle from machine
         PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis($nx)
         if { [EQ_is_zero $mom_sim_result] } {
            set mom_sim_result 0.0
            PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis($nx) 0.0
         }
         set mom_sim_pos([expr $nx - 1]) $mom_sim_result
         unset mom_sim_result
      }
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


#=============================================================
proc PB_CMD_vnc__rapid_move { } {
#=============================================================

  global mom_sim_rapid_feed_rate
  global mom_tool_axis
  global mom_sim_rapid_dogleg
  global mom_sim_pos mom_sim_prev_pos
  global mom_sim_max_dpm
  global mom_sim_lg_axis

   if { $mom_sim_rapid_dogleg } {

      if { [info exists mom_sim_lg_axis(5)] } {
         set num 5
      } elseif { [info exists mom_sim_lg_axis(4)] } {
         set num 4
      } else {
         set num 3
      }

      set rotary_end_first 1
      set rapid_feed_rate  0

      set idx 0

      while { $rotary_end_first } {

        # In case it gets stuck -
         incr idx
         if { $idx == 10 } {
return
         }

         set t_list [list]
         
         for { set i 0 } { $i < $num } { incr i } {

            set mom_sim_save_pos($i) $mom_sim_pos($i)
            set dist [expr $mom_sim_pos($i) - $mom_sim_prev_pos($i)]

            if { [EQ_is_gt $dist 0.0] } {
               set fac($i) 1
            } elseif { [EQ_is_zero $dist] } {
               set fac($i) 0
            } else {
               set fac($i) -1
            }

           # Get rapid_speed for each axis
            if { $i < 3 } {
              # Linear Axes
               if { ![EQ_is_zero $rapid_feed_rate] } {
                  set rapid_speed $rapid_feed_rate
                  set rotary_end_first 0
               } else {
                  set rapid_speed $mom_sim_rapid_feed_rate
               }
            } else {
              # Rotary Axes
               if { [info exists mom_sim_max_dpm] } {
                  set rapid_speed $mom_sim_max_dpm
               } else {
                  set rapid_speed 0.0
               }
            }
            
           # Calculate time
            if { ![EQ_is_zero $rapid_speed] } {
               set t($i) [expr abs($dist) / $rapid_speed]
            } else {
               set t($i) 0.0
            }

            lappend t_list $t($i)
         }


        # pb603(g) - Error protect
         set t_total 0
         foreach ti $t_list {
            set t_total [expr $t_total + $ti]
         }
         if { [EQ_is_zero $t_total] } {
return
         }


        # Sort time required for each linear axis
         set t_list [lsort -real $t_list]
         set t_order [list]

        # Generate t_order
         for { set i 0 } { $i < [llength $t_list] } { incr i } {
            for { set j 0 } { $j < $num } { incr j } {
               if { $t($j) == [lindex $t_list $i] } {
                  if { [lsearch $t_order $j] >= 0 } {
                     continue
                  } else {
                     lappend t_order $j
                     break
                  }
               }
            }
         }

        # Make sure rotary axes reach the destination before X, Y, Z axes, or at the same time
         if { $rotary_end_first == 1 } {
            set m_num [lindex $t_order 2]
            if { [lindex $t_order [expr $num - 1]] == 3 } {
               if { ![EQ_is_zero $t(3)] } {
                  set rapid_feed_rate [expr abs($mom_sim_pos($m_num) - $mom_sim_prev_pos($m_num)) / $t(3)]
               }
            } elseif { [lindex $t_order [expr $num - 1]] == 4 } {
               if { ![EQ_is_zero $t(4)] } {
                  set rapid_feed_rate [expr abs($mom_sim_pos($m_num) - $mom_sim_prev_pos($m_num)) / $t(4)]
               }
            } else {
               set rotary_end_first 0
            }
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

            if { $i< 3 } {
              # Linear Axes
               if { ![EQ_is_zero $rapid_feed_rate] } {
                  set rapid_speed $rapid_feed_rate 
               } else {
                  set rapid_speed $mom_sim_rapid_feed_rate
               }
            } else {
              # Rotary Axes
               if { [info exists mom_sim_max_dpm] } {
                  set rapid_speed $mom_sim_max_dpm
               } else {
                  set rapid_speed 0.0
               }
            }

            if { [lsearch $act_list $i] >= 0 } {
               set mom_sim_pos($i) [expr $mom_sim_prev_pos($i) + $fac($i) * $rapid_speed * $t_gap($j)]
            } else {
               set mom_sim_pos($i) $mom_sim_prev_pos($i)
            }
         }

         set int      [lsearch $act_list $long_ind]
         set act_list [lreplace $act_list $int $int]

         PB_CMD_vnc__rapid_segment

         if { $j != [expr $num - 1] } {
            for { set q 0 } { $q < $num } { incr q } {
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

         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(5) $mom_sim_pos(4)
         set pattern 0
      }

      10 { ;# Pure 4th axis rotation -

         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(4) $mom_sim_pos(3)
         set pattern 0
      }

      11 { ;# Pure compound rotation -

         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(4) $mom_sim_pos(3)
         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(5) $mom_sim_pos(4)
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

               global mom_sim_result
               PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(5) NORM_180
               PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(5)
               if { [EQ_is_zero $mom_sim_result] } {
                  set mom_sim_result 0.0
               }
               set mom_sim_pos(4) $mom_sim_result
               PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(5) $mom_sim_pos(4)
               unset mom_sim_result
            }
         }
      }
   }

   PB_SIM_call SIM_update
   PB_SIM_call VNC_update_sim_pos

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

  # pb602 - Do not override current tool jct
   if { ![info exists mom_sim_current_tool_junction] } {
      set mom_sim_current_tool_junction "$mom_sim_tool_junction"
   }

   set mom_sim_tool_junction "$mom_sim_current_junction"


  # Keep track of current position
   PB_SIM_call VNC_update_sim_pos


  # Set RAPID mode
   PB_SIM_call VNC_set_feedrate_mode RAPID

   set time 1


  # Always zero rotary axes ???
   if { $mom_sim_num_machine_axes > 3 } {
     # set move_4 1
   }

   if { $mom_sim_num_machine_axes > 4 } {
     # set move_5 1
   }


  # pb603(e) - Move axes directly
   global mom_sim_rapid_feed_rate

   if { $move_X } {
      PB_SIM_call VNC_move_machine_linear_axis $mom_sim_mt_axis(X) [lindex $mom_sim_nc_register(REF_PT) 0]
   }
   if { $move_Y } {
      PB_SIM_call VNC_move_machine_linear_axis $mom_sim_mt_axis(Y) [lindex $mom_sim_nc_register(REF_PT) 1]
   }
   if { $move_Z } {
      PB_SIM_call VNC_move_machine_linear_axis $mom_sim_mt_axis(Z) [lindex $mom_sim_nc_register(REF_PT) 2]
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

   global mom_sim_max_dpm

   if { [expr $mom_sim_num_machine_axes > 4] } {

      if { $move_5 } {

         if { $mom_sim_5th_axis_has_limits } {

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

         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(5) $mom_sim_pos(4)
         PB_SIM_call SIM_set_interpolation ON
      }
   }

   if { [expr $mom_sim_num_machine_axes > 3] } {

      if { $move_4 } {

         if { $mom_sim_4th_axis_has_limits } {

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

         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(4) $mom_sim_pos(3)
         PB_SIM_call SIM_set_interpolation ON
      }
   }


   PB_SIM_call SIM_update


 # pb601(e) - It seems to be needed for MS NT4200 kit, otherwise lower turret doesn't move properly.
 #            This was deemed to cause prematured change of tracking jct and disabled in pb600.
  if 1 {
  # pb501 -
  # PB_SIM_call SIM_set_current_ref_junction $mom_sim_current_junction

  # Restore current tool ref jct
   global mom_sim_tool_junction mom_sim_current_tool_junction
   global mom_sim_current_junction

  # pb602 - Enhanced condition
   if { [info exists mom_sim_current_tool_junction] && [string length $mom_sim_current_tool_junction] > 0 } {
      set mom_sim_tool_junction "$mom_sim_current_tool_junction"
      set mom_sim_current_junction "$mom_sim_tool_junction"
   }

  # Restore tracking point back to tool tip
  # pb602 - Enhanced condition (ISV of lower turret would fail w/o this checking.)
   if { [string length $mom_sim_current_junction] > 0 } {
      PB_SIM_call SIM_set_current_ref_junction $mom_sim_current_junction
   }
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
proc PB_CMD_vnc__sim_motion { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nurbs_start


  # Disable simulation when a NURBS definition starts.
   if { [info exists mom_sim_nurbs_start] && !$mom_sim_nurbs_start } {
return
   }

  # Set feed & speed
   PB_SIM_call PB_CMD_vnc__set_feed
   PB_SIM_call PB_CMD_vnc__set_speed


global mom_sim_o_buffer
global mom_sim_message
set mom_sim_message "** $mom_sim_nc_register(MOTION) -- $mom_sim_o_buffer **"
PB_CMD_vnc__send_message


  # Reset start position for next motion after a fixture offset transformation is applied.
  # - See PB_CMD_vnc__G_misc_code.
  #
   if { [info exists mom_sim_nc_register(FIXTURE_OFFSET)] } {

      if { ![catch {set ref_pt [PB_SIM_call SIM_ask_last_position_zcs]} ] } {
         global mom_sim_prev_pos
         set mom_sim_prev_pos(0) [lindex $ref_pt 0]
         set mom_sim_prev_pos(1) [lindex $ref_pt 1]
         set mom_sim_prev_pos(2) [lindex $ref_pt 2]
      }
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
         if { $mom_sim_nurbs_start } {
            PB_SIM_call VNC_nurbs_move
         }
      }
   }


   if { [string match "CYCLE_*" $mom_sim_nc_register(MOTION)] } {
      PB_SIM_call VNC_cycle_move
   }


  # Restore ZCS base to main after the 1st move
   if { [info exists mom_sim_nc_register(FIXTURE_OFFSET)] } {

      global mom_sim_zcs_base mom_sim_zcs_base_MCS

      if { [info exists mom_sim_zcs_base_MCS] && ![string match "" [string trim $mom_sim_zcs_base_MCS]] }  {
         set mom_sim_zcs_base $mom_sim_zcs_base_MCS
         PB_SIM_call PB_CMD_vnc__set_kinematics
      }

      VNC_unset_vars  mom_sim_nc_register(FIXTURE_OFFSET)
   }

   if { [info exists mom_sim_nc_register(MCS_MOVE_AT_PIVOT)] } {

      unset mom_sim_nc_register(MCS_MOVE_AT_PIVOT)

     # pb603(b) - Restore machine zero csys
      global mom_sim_machine_zero_csys_matrix mom_sim_machine_zero_csys_matrix_save
      if { [info exists mom_sim_machine_zero_csys_matrix_save] } {
         array set mom_sim_machine_zero_csys_matrix [array get mom_sim_machine_zero_csys_matrix_save]
      }

     # Restore current tool ref jct
      global mom_sim_current_junction


     # pb502(9) - Always force creation of tmp jct.
     # When no tool change occured, jct is not recreated after G53!
      set mom_sim_current_junction ""
      PB_SIM_call VNC_create_tmp_jct

     # Update mom_sim_pos w.r.t new ref jct
      global mom_sim_pos
      if { ![catch {set pos [PB_SIM_call SIM_ask_last_position_zcs]} ] } {
         set mom_sim_pos(0) [lindex $pos 0]
         set mom_sim_pos(1) [lindex $pos 1]
         set mom_sim_pos(2) [lindex $pos 2]
      }
   }

   PB_SIM_call PB_CMD_vnc__end_polar_motion


  # pb502(10) - Cross machining is a one shot deal
   if { $mom_sim_nc_register(CROSS_MACHINING) } {
      PB_SIM_call VNC_cross_machining_end
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


  # Fetch UG tool name per tool number
   global mom_sim_address
   global mom_sim_tool_data
   global mom_sim_tool_number

   set tool_number ""
   if { [info exists mom_sim_tool_number] } {
      set tool_number $mom_sim_tool_number
   } elseif { [info exists mom_sim_nc_register($mom_sim_address(T,leader))] } {
      set tool_number $mom_sim_nc_register($mom_sim_address(T,leader))
   }

   if { [string length $tool_number] > 0  &&  [info exists mom_sim_tool_data($tool_number,name)] } {
      set mom_sim_ug_tool_name $mom_sim_tool_data($tool_number,name)
   } else {
      set mom_sim_tool_change 0
return
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

     # By default, turret does not return to ref pt for tool change
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


        # Not sure this is always true for all machines!!!
         if { [lsearch $mom_sim_turret_carriers $mom_sim_tool_carrier_id] >= 0 } {

           # pb601(h)
            if { ![catch { SIM_ask_base_device_holder_of_comp $mom_sim_ug_tool_name }] } {
               set mom_sim_tool_pocket_id "$mom_sim_result1"
               set mom_sim_tool_data($tool_number,pocket_id) "\"$mom_sim_tool_pocket_id\""
            }

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

        # Position spindle to reference point.
         PB_SIM_call PB_CMD_vnc__send_dogs_home

        # Unset temporary intermediate reference point
         VNC_unset_vars  mom_sim_nc_register(REF_INT_PT_X) mom_sim_nc_register(REF_INT_PT_Y) mom_sim_nc_register(REF_INT_PT_Z)
      }
   }


   set sim_tool_name ""


#>>>>>
#  This is where you add detailed movements such as rotating tool changer,
#  unmounting old tool and mounting new tool and/or getting next tool in ready position.
#<<<<<

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
           [info exists mom_sim_tool_pocket_id] &&\
           [info exists mom_sim_turret_carriers] } {

         if { [lsearch $mom_sim_turret_carriers $mom_sim_tool_carrier_id] >= 0 } {

           # Handle mixed use of tools on a turret and stationary tools.
            if { ![catch { PB_SIM_call SIM_ask_kim_comp_name_by_id "TOOL" $mom_sim_ug_tool_name }] } {
               set done_tool_change 1
            }

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
 
              # - Reduce turret rotation
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


     # Change tool for mills
      if { $done_tool_change == 0 } {

        # pb502(13) -
        # Always unmount fly tool

        # pb602(q) - Rotate B-head to tool change angle (set in PB_CMD_vnc____map_machine_tool_axes)
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


         global mom_sim_tool_change_time
         if { ![info exists mom_sim_tool_change_time] || [EQ_is_le $mom_sim_tool_change_time 0.0] } {
            set tool_change_time 5
         } else {
            set tool_change_time $mom_sim_tool_change_time
         }

         PB_SIM_call VNC_set_ref_jct {""}
         PB_SIM_call SIM_mount_tool $tool_change_time "UG_NAME" "$mom_sim_ug_tool_name" "$mom_sim_spindle_comp" "$mom_sim_spindle_jct"

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
   global mom_sim_current_tool_junction
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




