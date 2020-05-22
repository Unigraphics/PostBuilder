##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################
#                       P B _ P O S T _ B A S E . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains common functions for building to all posts.
#
##############################################################################

#=============================================================================
proc PB_CMD_kin_do_template { args } {
#=============================================================================
#  This command is executed automatically when any of the axis multipliers,
#  such as diameter programming, mirrorring X, Y or Z, is turned on.
#  It modifies the values that will be used in the address X, Y, Z, I etc.
#  before calling MOM_do_template.  Then, the values are restored afterward.
#
   global mom_sys_lathe_x_double
   global mom_sys_lathe_i_double
   global mom_sys_lathe_x_factor
   global mom_sys_lathe_y_factor
   global mom_sys_lathe_z_factor

   global mom_sys_home_pos
   global mom_prev_pos mom_pos mom_pos_arc_center mom_from_pos mom_from_ref_pos
   global mom_cycle_rapid_to_pos mom_cycle_feed_to_pos mom_cycle_retract_to_pos
   global mom_cycle_clearance_to_pos
   global mom_cycle_feed_to mom_cycle_rapid_to
   global mom_tool_x_offset mom_tool_y_offset mom_tool_z_offset


  # List of variables to be modified
   set var_list_1 { mom_sys_home_pos(\$i) \
                    mom_pos(\$i) \
                    mom_from_pos(\$i) \
                    mom_from_ref_pos(\$i) \
                    mom_cycle_rapid_to_pos(\$i) \
                    mom_cycle_feed_to_pos(\$i) \
                    mom_cycle_retract_to_pos(\$i) \
                    mom_cycle_clearance_to_pos(\$i) }

   set var_list_2 { mom_prev_pos(\$i) \
                    mom_pos_arc_center(\$i) }

   set var_list_3 { mom_cycle_feed_to \
                    mom_cycle_rapid_to }

  # Retain current values
   set var_list [concat $var_list_1 $var_list_2]
   foreach var $var_list {
      for { set i 0 } { $i < 3 } { incr i } {
         if [eval info exists [set var]] {
            set val [eval format $[set var]]
            eval set __[set var] $val
         }
      }
   }

   foreach var $var_list_3 {
      if [eval info exists [set var]] {
          set val [eval format $[set var]]
          eval set __[set var] $val
      }
   }

  # Adjust values
   set _factor(0) [expr $mom_sys_lathe_x_double * $mom_sys_lathe_x_factor]
   set _factor(1) $mom_sys_lathe_y_factor
   set _factor(2) $mom_sys_lathe_z_factor

   foreach var $var_list_1 {
      for { set i 0 } { $i < 3 } { incr i } {
         if [eval info exists [set var]] {
            set val [eval format $[set var]]
            eval set [set var] [expr $val * $_factor($i)]
         }
      }
   }

   foreach var $var_list_2 {
      for { set i 1 } { $i < 3 } { incr i } {
         if [eval info exists [set var]] {
            set val [eval format $[set var]]
            eval set [set var] [expr $val * $_factor($i)]
         }
      }
   }

  # Adjust values for I
   if { $mom_sys_lathe_i_double != 1 } {
      set _factor(0) [expr $mom_sys_lathe_x_factor * $mom_sys_lathe_i_double]
      if [info exists mom_prev_pos(0)] {
         set mom_prev_pos(0)       [expr $mom_prev_pos(0)       * $_factor(0)]
      }
      if [info exists mom_pos_arc_center(0)] {
         set mom_pos_arc_center(0) [expr $mom_pos_arc_center(0) * $_factor(0)]
      }
   }

   foreach var $var_list_3 {
      if [eval info exists [set var]] {
         set val [eval format $[set var]]
         eval set [set var] [expr $val * $_factor(2)]
      }
   }

  # Neutralize all factors to avoid double multiplication in the legacy posts.
   set _lathe_x_double $mom_sys_lathe_x_double
   set _lathe_i_double $mom_sys_lathe_i_double
   set _lathe_x_factor $mom_sys_lathe_x_factor
   set _lathe_y_factor $mom_sys_lathe_y_factor
   set _lathe_z_factor $mom_sys_lathe_z_factor

   set mom_sys_lathe_x_double 1
   set mom_sys_lathe_i_double 1
   set mom_sys_lathe_x_factor 1
   set mom_sys_lathe_y_factor 1
   set mom_sys_lathe_z_factor 1


  #-----------------------
  # Output block template
  #-----------------------
   MOM_SYS_do_template $args


  # Restore values
   foreach var $var_list {
      for { set i 0 } { $i < 3 } { incr i } {
         if [eval info exists [set var]] {
            set v __[set var]
            set val [eval format $$v]
            eval set [set var] $val
         }
      }
   }
   foreach var $var_list_3 {
      if [eval info exists [set var]] {
         set v __[set var]
         set val [eval format $$v]
         eval set [set var] $val
      }
   }

  # Restore factors
   set mom_sys_lathe_x_double $_lathe_x_double
   set mom_sys_lathe_i_double $_lathe_i_double
   set mom_sys_lathe_x_factor $_lathe_x_factor
   set mom_sys_lathe_y_factor $_lathe_y_factor
   set mom_sys_lathe_z_factor $_lathe_z_factor
}


#=============================================================
proc PB_CMD_before_motion { } {
#=============================================================
}


#=============================================================
proc PB_CMD_end_of_alignment_character { } {
#=============================================================
 #  Return sequnece number back to orignal
 #  This command may be used with the command "PM_CMD_start_of_alignment_character"

  global mom_sys_leader saved_seq_num
  set mom_sys_leader(N) $saved_seq_num
}


#=============================================================
proc PB_CMD_kin_end_of_path { } {
#=============================================================
  # Record tool time for this operation.
   if [llength [info commands PB_CMD_set_oper_tool_time] ] {
      PB_CMD_set_oper_tool_time
   }
}


#=============================================================
proc PB_CMD_kin_feedrate_set { } {
#=============================================================
# This procedure supercedes the functionalites provided by the
# FEEDRATE_SET in ugpost_base.tcl.  Post Builder automatically
# generates proper call sequences to this procedure in the
# Event handlers.
#
# This procedure must be used in conjunction with ugpost_base.tcl.
#
  global   feed com_feed_rate
  global   mom_feed_rate_output_mode super_feed_mode feed_mode
  global   mom_cycle_feed_rate_mode mom_cycle_feed_rate
  global   mom_cycle_feed_rate_per_rev
  global   mom_motion_type
  global   mom_warning_info
  global   Feed_IPM Feed_IPR Feed_MMPM Feed_MMPR Feed_INV
  global   mom_sys_feed_param
  global   mom_sys_cycle_feed_mode


  set super_feed_mode $mom_feed_rate_output_mode

  set f_pm [ASK_FEEDRATE_FPM] ; set f_pr [ASK_FEEDRATE_FPR]

  switch $mom_motion_type {

    CYCLE {
      if [info exists mom_sys_cycle_feed_mode] {
         if { $mom_sys_cycle_feed_mode != "Auto" } {
            set mom_cycle_feed_rate_mode $mom_sys_cycle_feed_mode
         }
      }
      if {[hiset mom_cycle_feed_rate_mode]} { set super_feed_mode $mom_cycle_feed_rate_mode }
      if {[hiset mom_cycle_feed_rate]} { set f_pm $mom_cycle_feed_rate }
      if {[hiset mom_cycle_feed_rate_per_rev]} { set f_pr $mom_cycle_feed_rate_per_rev }
    }

    FROM -
    RETRACT -
    RETURN -
    LIFT -
    TRAVERSAL -
    GOHOME -
    GOHOME_DEFAULT -
    RAPID {
      SUPER_FEED_MODE_SET RAPID
    }

    default {
      if {[EQ_is_zero $f_pm] && [EQ_is_zero $f_pr]} {
        SUPER_FEED_MODE_SET RAPID
      } else {
        SUPER_FEED_MODE_SET CONTOUR
      }
    }
  }


  set feed_mode $super_feed_mode


 # Adjust feedrate format per Post output unit again.
  global mom_kin_output_unit
  if { $mom_kin_output_unit == "IN" } {
     switch $feed_mode {
       MMPM {
         set feed_mode "IPM"
         CATCH_WARNING "Feedrate mode MMPM changed to IPM"
       }
       MMPR {
         set feed_mode "IPR"
         CATCH_WARNING "Feedrate mode MMPR changed to IPR"
       }
     }
  } else {
     switch $feed_mode {
       IPM {
         set feed_mode "MMPM"
         CATCH_WARNING "Feedrate mode IPM changed to MMPM"
       }
       IPR {
         set feed_mode "MMPR"
         CATCH_WARNING "Feedrate mode IPR changed to MMPR"
       }
     }
  }


  switch $feed_mode {
    IPM     -
    MMPM    { set feed $f_pm }
    IPR     -
    MMPR    { set feed $f_pr }
    DPM     { set feed [PB_CMD_FEEDRATE_DPM] }
    FRN     -
    INVERSE { set feed [PB_CMD_FEEDRATE_NUMBER] }
    default { set mom_warning_info "INVALID FEED RATE MODE" ; MOM_catch_warning ; return }
  }


 # Post Builder provided format for the current mode:
  if [info exists mom_sys_feed_param(${feed_mode},format)] {
    MOM_set_address_format F $mom_sys_feed_param(${feed_mode},format)
  } else {
    switch $feed_mode {
      IPM     -
      MMPM    -
      IPR     -
      MMPR    -
      DPM     -
      FRN     { MOM_set_address_format F Feed_${feed_mode} }
      INVERSE { MOM_set_address_format F Feed_INV }
    }
  }

 # Commentary output
  set com_feed_rate $f_pm


 # Execute user's commnad, if any.
  if [llength [info commands "PB_CMD_FEEDRATE_SET"]] {
     PB_CMD_FEEDRATE_SET
  }
}


#=============================================================
proc PB_CMD_kin_set_csys { } {
#=============================================================
   if [llength [info commands PB_CMD_set_csys] ] {
      PB_CMD_set_csys
   }
}


#=============================================================
proc PB_CMD_set_csys { } {
#=============================================================
#  This custom command is provided as the default to nullify
#  the same command in a linked post that may have been
#  imported from pb_cmd_coordinate_system_rotation.tcl.
}


#=============================================================
proc PB_CMD_kin_start_of_path { } {
#=============================================================
#
#  This procedure is executed at the start of every operation.
#  It will check to see if a new head (post) was loaded and 
#  will then initialize any functionality specific to that post.
#
#  It will also restore the initial Start of Program or End
#  of program event procedures.
#
#  DO NOT CHANGE THIS FILE UNLESS YOU KNOW WHAT YOU ARE DOING.
#  DO NOT CALL THIS PROCEDURE FROM ANY OTHER CUSTOM COMMAND.
#
  global mom_sys_head_change_init_program

   if [info exists mom_sys_head_change_init_program] {

      PB_CMD_kin_start_of_program
      unset mom_sys_head_change_init_program


     #<06-17-03 gsl> Moved from MOM_head to
     # execute start of head callback in new post's context.
      global CURRENT_HEAD
      if { [info exists CURRENT_HEAD] &&  [llength [info commands PB_start_of_HEAD__$CURRENT_HEAD]] } {
         PB_start_of_HEAD__$CURRENT_HEAD
      }

      # Restore master start & end of program handlers
      if [llength [info commands "MOM_start_of_program_save"]] {
         if [llength [info commands "MOM_start_of_program"]] {
            rename MOM_start_of_program ""
         }
         rename MOM_start_of_program_save MOM_start_of_program 
      }
      if [llength [info commands "MOM_end_of_program_save"]] {
         if [llength [info commands "MOM_end_of_program"]] {
            rename MOM_end_of_program ""
         }
         rename MOM_end_of_program_save MOM_end_of_program 
      }

     # Restore master head change event handler
      if [llength [info commands "MOM_head_save"]] {
         if [llength [info commands "MOM_head"]] {
            rename MOM_head ""
         }
         rename MOM_head_save MOM_head
      }
   }

  # Initialize tool time accumulator for this operation.
   if [llength [info commands PB_CMD_init_oper_tool_time] ] {
      PB_CMD_init_oper_tool_time
   }

  # Force out motion G code at the start of path.
   MOM_force once G_motion
}


#=============================================================
proc PB_CMD_pause { } {
#=============================================================
# This command enables you to pause the UG/Post processing.
#
  PAUSE
}


#=============================================================
proc PAUSE { args } {
#=============================================================
  global env

  if { [info exists env(PB_SUPPRESS_UGPOST_DEBUG)] && \
       $env(PB_SUPPRESS_UGPOST_DEBUG) == 1 } {
return
  }


  set cam_aux_dir  [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]

  global tcl_platform

  if [string match "*windows*" $tcl_platform(platform)] {
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
 
     exec ${cam_aux_dir}$ug_wish ${cam_aux_dir}mom_pause.tcl $title $msg
  }
}


#=============================================================
proc PB_CMD_start_of_alignment_character { } {
#=============================================================
 # This command can be used to output a special sequence number character.  
 # Replace the ":" with any character that you require.
 # You must use the command "PB_CMD_end_of_alignment_character" to reset
 # the sequence number back to the original setting.

  global mom_sys_leader saved_seq_num
  set saved_seq_num $mom_sys_leader(N)
  set mom_sys_leader(N) ":"
}


#=============================================================
proc EQ_is_zero { s } {
#=============================================================
   global mom_system_tolerance

   if [info exists mom_system_tolerance] {
      if { [expr abs($s)] <= $mom_system_tolerance } { return 1 } else { return 0 }
   } else {
      return 0
   }
}


#=============================================================
proc CATCH_WARNING { msg } {
#=============================================================
  global mom_warning_info
  global mom_motion_event
  global mom_event_number

   set level [info level]
   set call_stack ""
   for {set i 1} {$i < $level} {incr i} {
      set call_stack "$call_stack\[ [lindex [info level $i] 0] \]"
   }
   set mom_warning_info "$msg ($mom_motion_event $mom_event_number) $call_stack"
   MOM_catch_warning
}


#=============================================================
proc EQ_is_equal { s t } {
#=============================================================
   global mom_system_tolerance

   if [info exists mom_system_tolerance] {
      if { [expr abs($s - $t)] <= $mom_system_tolerance } { return 1 } else { return 0 }
   } else {
      return 0
   }
}



