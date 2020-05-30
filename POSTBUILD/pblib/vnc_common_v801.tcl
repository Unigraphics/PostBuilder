########################### Virtual NC Controller ############################
#                                                                            #
# Copyright (C) 1999/2000/2001/2002/2003/2004/2005/2006/2007/2008/2009/2010/ #
#               2011                                                         #
#                                                                            #
#                           Siemens PLM Software                             #
#                                                                            #
##############################################################################
#                       V N C _ C O M M O N _ V 8 0 1 . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains handlers for incremental VNC conversion.
#
##############################################################################


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


  # Rapid to
    set mom_sim_pos(0) $mom_sim_cycle_rapid_to_pos(0)
    set mom_sim_pos(1) $mom_sim_cycle_rapid_to_pos(1)
    set mom_sim_pos(2) $mom_sim_cycle_rapid_to_pos(2)

  # pb752(a) - Restore next move to linear move
  # pb750(i) -
   PB_SIM_call VNC_linear_move


  # pb752(a) - Restore cut feed
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

  # pb901(a) - Catalog undefined commands to only display message once.
   global mom_sim_unknown_command_list
   if ![info exists mom_sim_unknown_command_list] {
      set mom_sim_unknown_command_list [list]
   }

  # Verify existence of the command
  # ==> Do not define dummy command
   if { ![llength [info commands "$command"]] } {

      if { [lsearch $mom_sim_unknown_command_list "$command"] < 0 } {

         lappend mom_sim_unknown_command_list "$command"

         set msg "# *** WARNING *** \"$command\" does not exist!"
         if { $mom_sim_isv_qc == 1 } {
            PB_SIM_output_qc_cmd_string "$msg"
         } else {
            VNC_send_message "$msg"
         }
      }

   } else {

     # Evaluate command string. Abort, when error.
      if { [catch { set val [eval $cmd_string] } sta] } {

         set msg "# *** ABORT *** $cmd_string"

         if { $mom_sim_isv_qc == 1 }  {
            PB_SIM_output_qc_cmd_string "$msg"
         } else {
            VNC_send_message "$msg"
         }

         MOM_abort "$cmd_string : $sta"
      }
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
proc PB_CMD_vnc__circular_move { } {
#=============================================================
  global mom_sim_address mom_sim_pos mom_sim_prev_pos
  global mom_sim_lg_axis
  global mom_sim_nc_register
  global mom_sim_circular_dir
  global mom_sim_circular_vector

  global mom_sim_o_buffer
  global mom_sim_nc_block


  # Clear R in-use condition
   if { [info exists mom_sim_nc_register(R_IN_USE)] } {

     # Unset it only if not modal!
      if { !$mom_sim_address(R,modal) } {
         VNC_unset_vars  mom_sim_nc_register(R_IN_USE)
      }
   }

  # pb601(a) - Search for R word if the leader of Address R is R.
  # pb800(f) - Look at original block buffer
   if { [info exists mom_sim_nc_block] } {
      set tmp_o_buff $mom_sim_nc_block
   } else {
      set tmp_o_buff $mom_sim_o_buffer
   }

   VNC_parse_nc_word tmp_o_buff $mom_sim_address(R,leader) 2 PB_CMD_vnc__R_code


  # pb602(a) - Search for IJK to override R mode
  #            ==> R in-use flag can be still in effect resulted from previous (turn) post

   if { [info exists mom_sim_nc_register(R_IN_USE)] } {

      if { [VNC_parse_nc_word tmp_o_buff $mom_sim_address(I,leader) 2] ||\
           [VNC_parse_nc_word tmp_o_buff $mom_sim_address(J,leader) 2] ||\
           [VNC_parse_nc_word tmp_o_buff $mom_sim_address(K,leader) 2] } {

         VNC_unset_vars mom_sim_nc_register(R_IN_USE)
      }
   }


   PB_SIM_call VNC_set_feedrate_mode CUT


   set dir $mom_sim_circular_dir
   set plane $mom_sim_nc_register(PLANE)


  # When "Unsigned Vector - Arc Start to Center" is used to define
  # the arc center vector, fake it into R case for arc center calculation.

  # pb801(c) - Only do this when R is not in use yet.
   if { ![info exists mom_sim_nc_register(R_IN_USE)] &&\
         [string match "Unsigned Vector - Arc Start to Center" $mom_sim_circular_vector] } {

      set mom_sim_nc_register(R_IN_USE) 1

      if { [info exists mom_sim_nc_register(R)] } {
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
   if { [info exists mom_sim_nc_register(R_IN_USE)] } {

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

     # pb800(g) -
      set r $mom_sim_nc_register(R)
      set a [expr atan2($dy,$dx)]
       set t [expr sqrt($dx*$dx + $dy*$dy) / (2.0*$r)]
       if [EQ_is_gt $t  1.0] { set t  1.0 }
       if [EQ_is_lt $t -1.0] { set t -1.0 }
      set b [expr acos($t)]

     # Complement of an arc
     # pb801(d) - Should have just changed the center but not the direction.
      #if { [expr $r < 0] } {
      #   set dir [expr -1 * $dir]
      #}

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
      if { [string match "Unsigned Vector - Arc Start to Center" $mom_sim_circular_vector] } {
         if { [string match "none" $R_saved] } {
            VNC_unset_vars  mom_sim_nc_register(R)
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

  # pb800(g) -
   if ![info exists i] { set i 0.0 }
   if ![info exists j] { set j 0.0 }
   if ![info exists k] { set k 0.0 }


  #=====================
  # Validate arc record
  #=====================
  # pb750(j) -

  # To be implemented as "Other Options" of VNC's configuration
   global mom_sim_validate_arc mom_sim_validate_arc_tol

  # Allow overriding by setting env vars
   global env
   if { [info exists env(UGII_CAM_SIM_VALIDATE_ARC)] } {
      set mom_sim_validate_arc $env(UGII_CAM_SIM_VALIDATE_ARC)
   }
   if { ![info exists mom_sim_validate_arc] } {
     # Default to ON, if not set
      set mom_sim_validate_arc 1
   }

   if { $mom_sim_validate_arc } {

     # Determine tolerance for validation
      global mom_sim_output_unit

      if { [info exists env(UGII_CAM_SIM_VALIDATE_ARC_TOL)] } {
         set mom_sim_validate_arc_tol $env(UGII_CAM_SIM_VALIDATE_ARC_TOL)
      }
      if { ![info exists mom_sim_validate_arc_tol] } {
         if { [string match "MM" $mom_sim_output_unit] } {
            set mom_sim_validate_arc_tol 0.0011
         } else {
            set mom_sim_validate_arc_tol 0.00011
         }
      }

     # Arc center
      set Xs [expr $mom_sim_prev_pos(0) - $i]
      set Ys [expr $mom_sim_prev_pos(1) - $j]
      set Zs [expr $mom_sim_prev_pos(2) - $k]
      set Xe [expr $mom_sim_pos(0) - $i]
      set Ye [expr $mom_sim_pos(1) - $j]
      set Ze [expr $mom_sim_pos(2) - $k]

     # Start & end radius
      switch $plane {
         "XY" {
            set Rs [expr sqrt( $Xs*$Xs + $Ys*$Ys )]
            set Re [expr sqrt( $Xe*$Xe + $Ye*$Ye )]
         }
         "YZ" {
            set Rs [expr sqrt( $Ys*$Ys + $Zs*$Zs )]
            set Re [expr sqrt( $Ye*$Ye + $Ze*$Ze )]
         }
         "ZX" {
            set Rs [expr sqrt( $Zs*$Zs + $Xs*$Xs )]
            set Re [expr sqrt( $Ze*$Ze + $Xe*$Xe )]
         }
         default {
            set Rs [expr sqrt( $Xs*$Xs + $Ys*$Ys + $Zs*$Zs )]
            set Re [expr sqrt( $Xe*$Xe + $Ye*$Ye + $Ze*$Ze )]
         }
      }

     # Output VNC message when error
      if { [expr abs($Re - $Rs) > $mom_sim_validate_arc_tol] } {
         VNC_send_message "*** BAD ARC ***"
         VNC_send_message "$mom_sim_nc_block"
         VNC_send_message "  Start R: $Rs  End R: $Re   Diff = [expr abs($Re - $Rs)] > $mom_sim_validate_arc_tol"
         VNC_send_message "  ($mom_sim_prev_pos(0), $mom_sim_prev_pos(1), $mom_sim_prev_pos(2)) ->\
                             ($mom_sim_pos(0), $mom_sim_pos(1), $mom_sim_pos(2))\n"
      }
   }



   global mom_sim_arc_output_mode
   global mom_sim_PI

  # pb601(b) -
   global mom_sim_helix_pitch
   set helix_pitch ""

   switch $plane {
      "YZ" {

        # Detect helical condition
         if { [info exists mom_sim_helix_pitch] && ![EQ_is_zero $mom_sim_helix_pitch] } {
            set dz [expr $mom_sim_pos(0) - $mom_sim_prev_pos(0)]
            if { ![EQ_is_zero $dz] } {
               set helix_pitch [expr abs(2*$mom_sim_PI*$dz/$mom_sim_helix_pitch)]
            }
         }

         if { [string length $helix_pitch] == 0 } {

           # Handle full circle using half circle pt
            if { [string match "FULL_CIRCLE" $mom_sim_arc_output_mode] } {
               if { [EQ_is_equal $mom_sim_pos(1) $mom_sim_prev_pos(1)] && [EQ_is_equal $mom_sim_pos(2) $mom_sim_prev_pos(2)] } {

                  set dx [expr $mom_sim_pos(1) - $j]
                  set dy [expr $mom_sim_pos(2) - $k]
                  set a [expr atan2($dy,$dx)]
                  set b [expr $a + $mom_sim_PI]
                  set r [expr sqrt($dx*$dx + $dy*$dy)]
                  set px [expr $j + $r*cos($b)]
                  set py [expr $k + $r*sin($b)]

                  PB_SIM_call SIM_move_circular_zcs $dir 0 0 $mom_sim_lg_axis(Y) $px $mom_sim_lg_axis(Z) $py\
                                                             $mom_sim_lg_axis(J) $j $mom_sim_lg_axis(K) $k
               }
            }

            eval PB_SIM_call SIM_move_circular_zcs $dir 0 0 $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                                            $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                                            $mom_sim_lg_axis(J) $j $mom_sim_lg_axis(K) $k
         } else {

          # pb602(r) - Activate logic below
           if 1 {
            if { [EQ_is_lt $helix_pitch [expr 2*$mom_sim_PI]] } {
               set helix_pitch "$mom_sim_lg_axis(X) $mom_sim_pos(0)"
            } else {
               set helix_pitch "$mom_sim_lg_axis(X) $mom_sim_pos(0) P $helix_pitch"
            }
           } else {
            set helix_pitch "P $helix_pitch"
           }

            eval PB_SIM_call SIM_move_helical_zcs $dir 0 0 $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                                           $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                                           $mom_sim_lg_axis(J) $j $mom_sim_lg_axis(K) $k $helix_pitch
         }
      }

      "ZX" {

        # Detect helical condition
         if { [info exists mom_sim_helix_pitch] && ![EQ_is_zero $mom_sim_helix_pitch] } {
            set dz [expr $mom_sim_pos(1) - $mom_sim_prev_pos(1)]
            if { ![EQ_is_zero $dz] } {
               set helix_pitch [expr abs(2*$mom_sim_PI*$dz/$mom_sim_helix_pitch)]
            }
         }

         if { [string length $helix_pitch] == 0 } {

           # Handle full circle using half circle pt
            if { [string match "FULL_CIRCLE" $mom_sim_arc_output_mode] } {
               if { [EQ_is_equal $mom_sim_pos(2) $mom_sim_prev_pos(2)] && [EQ_is_equal $mom_sim_pos(0) $mom_sim_prev_pos(0)] } {

                  set dx [expr $mom_sim_pos(2) - $k]
                  set dy [expr $mom_sim_pos(0) - $i]
                  set a [expr atan2($dy,$dx)]
                  set b [expr $a + $mom_sim_PI]
                  set r [expr sqrt($dx*$dx + $dy*$dy)]
                  set px [expr $k + $r*cos($b)]
                  set py [expr $i + $r*sin($b)]

                  PB_SIM_call SIM_move_circular_zcs 0 $dir 0 $mom_sim_lg_axis(Z) $px $mom_sim_lg_axis(X) $py\
                                                             $mom_sim_lg_axis(K) $k $mom_sim_lg_axis(I) $i
               }
            }

            eval PB_SIM_call SIM_move_circular_zcs 0 $dir 0 $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                                            $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                                            $mom_sim_lg_axis(K) $k $mom_sim_lg_axis(I) $i
         } else {

          # pb602(r) - Activate logic below
           if 1 {
            if { [EQ_is_lt $helix_pitch [expr 2*$mom_sim_PI]] } {
               set helix_pitch "$mom_sim_lg_axis(Y) $mom_sim_pos(1)"
            } else {
               set helix_pitch "$mom_sim_lg_axis(Y) $mom_sim_pos(1) P $helix_pitch"
            }
           } else {
            set helix_pitch "P $helix_pitch"
           }

            eval PB_SIM_call SIM_move_helical_zcs 0 $dir 0 $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                                           $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                                           $mom_sim_lg_axis(K) $k $mom_sim_lg_axis(I) $i $helix_pitch
         }
      }

      default {

        # Detect helical condition
         if { [info exists mom_sim_helix_pitch] && ![EQ_is_zero $mom_sim_helix_pitch] } {
            set dz [expr $mom_sim_pos(2) - $mom_sim_prev_pos(2)]
            if { ![EQ_is_zero $dz] } {
               set helix_pitch [expr abs(2*$mom_sim_PI*$dz/$mom_sim_helix_pitch)]
            }
         }

         if { [string length $helix_pitch] == 0 } {

           # Handle full circle using half circle pt
            if { [string match "FULL_CIRCLE" $mom_sim_arc_output_mode] } {
               if { [EQ_is_equal $mom_sim_pos(0) $mom_sim_prev_pos(0)] && \
                    [EQ_is_equal $mom_sim_pos(1) $mom_sim_prev_pos(1)] } {

                  set dx [expr $mom_sim_pos(0) - $i]
                  set dy [expr $mom_sim_pos(1) - $j]
                  set a [expr atan2($dy,$dx)]
                  set b [expr $a + $mom_sim_PI]
                  set r [expr sqrt($dx*$dx + $dy*$dy)]
                  set px [expr $i + $r*cos($b)]
                  set py [expr $j + $r*sin($b)]

                  PB_SIM_call SIM_move_circular_zcs 0 0 $dir $mom_sim_lg_axis(X) $px $mom_sim_lg_axis(Y) $py\
                                                             $mom_sim_lg_axis(I) $i $mom_sim_lg_axis(J) $j
               }
            }

            eval PB_SIM_call SIM_move_circular_zcs 0 0 $dir $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                                            $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                                            $mom_sim_lg_axis(I) $i $mom_sim_lg_axis(J) $j
         } else {

          # pb602(r) - Activate logic below
           if 1 {
            if { [EQ_is_lt $helix_pitch [expr 2*$mom_sim_PI]] } {
               set helix_pitch "$mom_sim_lg_axis(Z) $mom_sim_pos(2)"
            } else {
               set helix_pitch "$mom_sim_lg_axis(Z) $mom_sim_pos(2) P $helix_pitch"
            }
           } else {
            set helix_pitch "P $helix_pitch"
           }

            eval PB_SIM_call SIM_move_helical_zcs 0 0 $dir $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                                           $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                                           $mom_sim_lg_axis(I) $i $mom_sim_lg_axis(J) $j $helix_pitch
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
          # Not fixture offset -

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
          # Fixture offset - Fetch offset data

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
proc PB_CMD_vnc__ask_head_spindle_axis { } {
#=============================================================
# This command retuns the head spindle axis, if any.
# - Existence of the axis can be interrogated from the kin model per
#   componemt classified as _DEVICE_HOLDER_ON_HEAD

# pb602(c) -

   global mom_sim_head_spindle_axis
   global mom_sim_head_spindle_axis_defined

   if { [info exists mom_sim_head_spindle_axis_defined] } {
return
   }


   global mom_sim_result

   set sim_result_saved $mom_sim_result

   set mom_sim_result ""

   set machine_base MACHINE_BASE
   PB_SIM_call SIM_ask_machine_base_component

   if { ![string match "" $mom_sim_result] } {
      set machine_base $mom_sim_result
   }


   set mom_sim_head_spindle_axis_defined 0


   VNC_unset_vars  COMP_class

   set class _DEVICE_HOLDER_ON_HEAD
   set mode  SYSTEM

   set cmd_name "PB_SIM_cycle_comp_of_class"

   if { ![catch { $cmd_name COMP_class $machine_base $class $mode }] } {
      if { [info exists COMP_class($class,comp)] } {
        # pb801(f) - Added use of lindex below...
         if [catch { PB_SIM_call SIM_ask_axis_of_component [lindex $COMP_class($class,comp) 0] } res] {

            set mom_sim_result $sim_result_saved
return
         }
      }
   }

   if { [string length $mom_sim_result] &&\
        [string compare "0" $mom_sim_result] &&\
        [string compare _NONE $mom_sim_result] } {

      set mom_sim_head_spindle_axis $mom_sim_result
      set mom_sim_head_spindle_axis_defined 1
   }


   set mom_sim_result $sim_result_saved
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
  global mom_sim_tool_junction mom_sim_current_tool_junction mom_sim_current_junction
  global mom_sim_pivot_distance
  global mom_sim_tool_change


  global mom_sim_pos mom_sim_prev_pos


  # Fetch UG tool name per tool number
   global mom_sim_address
   global mom_sim_tool_data
   global mom_sim_tool_number

   set tool_number ""

  # pb800(m) - T register has priority for tool change
   if { [info exists mom_sim_nc_register($mom_sim_address(T,leader))] } {
      set tool_number $mom_sim_nc_register($mom_sim_address(T,leader))
   } elseif { [info exists mom_sim_tool_number] } {
      set tool_number $mom_sim_tool_number
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




