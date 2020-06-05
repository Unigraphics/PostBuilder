########################### Virtual NC Controller ############################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006/2007/2008/2009/2010/ #
#               2011                                                         #
#                                                                            #
#                           SIEMENS PLM Software                             #
#                                                                            #
##############################################################################
#                       V N C _ C O M M O N _ V 7 5 2 . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains handlers for incremental VNC conversion.
#
##############################################################################


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
   if { $mom_sim_output_vnc_msg } {
      MOM_output_literal $mom_sim_message
   } else {
     # pb752(d)
      if { [llength [info commands "ugpost_MOM_output_text"]] } {
         ugpost_MOM_output_text $mom_sim_message
      } else {
         MOM_output_text $mom_sim_message
      }
   }


   if { [info exists mom_sim_output_extended_nc] && $mom_sim_output_extended_nc } {
      MOM_close_output_file $setup_data_file
      MOM_open_output_file  $ptp_file_name

      set mom_sim_output_vnc_msg $saved_output_vnc_msg
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


  # pb800(a) - Speed up rapid-to move in cycle
   set mom_sim_nc_register(MOTION) RAPID
   PB_SIM_call VNC_set_feedrate_mode RAPID


  # pb750(i) -
   PB_SIM_call VNC_rapid_move


  # Rapid to
    set mom_sim_pos(0) $mom_sim_cycle_rapid_to_pos(0)
    set mom_sim_pos(1) $mom_sim_cycle_rapid_to_pos(1)
    set mom_sim_pos(2) $mom_sim_cycle_rapid_to_pos(2)

  # pb800(a) - Restore next move to linear move
  # pb750(i) -
   PB_SIM_call VNC_linear_move


  # pb800(a) - Restore cut feed
   set mom_sim_nc_register(MOTION) LINEAR
   PB_SIM_call VNC_set_feedrate_mode CUT


  # Feed to
    set mom_sim_pos(0) $mom_sim_cycle_feed_to_pos(0)
    set mom_sim_pos(1) $mom_sim_cycle_feed_to_pos(1)
    set mom_sim_pos(2) $mom_sim_cycle_feed_to_pos(2)

   PB_SIM_call VNC_linear_move


  # Retract to
    set mom_sim_pos(0) $mom_sim_cycle_retract_to_pos(0)
    set mom_sim_pos(1) $mom_sim_cycle_retract_to_pos(1)
    set mom_sim_pos(2) $mom_sim_cycle_retract_to_pos(2)

   PB_SIM_call VNC_linear_move


  # pb750(i) - This perhaps should only be done @ cycle-off
  if 0 {
  # Restore registers back to entry (or reference) pos of the cycle.
   global mom_sim_cycle_spindle_axis
   set mom_sim_pos($mom_sim_cycle_spindle_axis) $sim_pos_save($mom_sim_cycle_spindle_axis)
  }

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




