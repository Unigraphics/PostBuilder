##############################################################################
#                                                                            #
# Copyright (c) 1999/2000,                        Unigraphics Solutions Inc. #
# Copyright (c) 2001/2002/2003/2004/2005/2006,    UGS/PLM Solutions.         #
# Copyright (c) 2007 ~ 2017,                      SIEMENS/PLM Software       #
#                                                                            #
##############################################################################
#               P B _ C M D _ D E B U G _ U T I L S . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains utility functions for Post debugging.
#
##############################################################################



#=============================================================
proc PB_CMD_init_program_elapsed_time { } {
#=============================================================
# This command can be added to the Start of Program event
# to initiate the elapsed time tracking
#
# => With PB v11.0.2, program startup clock will be set automatically.
#    This command is not needed.
#
   set ::mom_sys_start_program_clock_seconds [clock seconds]
}


#=============================================================
proc PB_CMD_output_program_elapsed_time { } {
#=============================================================
# When the elapsed time tracking has been initiated by calling
# "PB_CMD_init_program_elapsed_time" at Start of Program event,
# this command can be added to the End of Program event to output
# the total execution time (in seconds) for a posting job.
#

   if { ![info exists ::mom_sys_start_program_clock_seconds] } {
return
   }


   set program_elapsed_seconds [expr [clock seconds] - $::mom_sys_start_program_clock_seconds]

   if { [info exists ::mom_kin_is_turbo_output] && [string match "TRUE" $::mom_kin_is_turbo_output] } {
      set msg "Elapsed time - Turbo mode          : $program_elapsed_seconds (seconds)"
   } elseif { [info exists ::mom_sys_advanced_turbo_output] && $::mom_sys_advanced_turbo_output } {
      set msg "Elapsed time - Advanced Turbo mode : $program_elapsed_seconds (seconds)"
   } else {
      set msg "Elapsed time - Standard mode       : $program_elapsed_seconds (seconds)"
   }

   INFO $msg
   OPERATOR_MSG $msg
}


#=============================================================
proc PB_CMD__show_block_template { } {
#=============================================================
# Add this command to Start of Program event marker to show
# the name of BLOCK templates in NC output.
#-------------------------------------------------------------
# Oct-28-2016 gsl  - Initial version (v11.02)
#

   if { ![CMD_EXIST MOM_POST__do_template] } {
      rename MOM_do_template MOM_POST__do_template

      if { ![info exists ::mom_sys_this_post_name] } {
         set ::mom_sys_this_post_name ""
      }

     uplevel #0 {
      #====================================
      proc MOM_do_template { block args } {
      #====================================
         if [info exists ::mom_sys_master_post] {
            OPERATOR_MSG "+ \[$::mom_sys_this_post_name\] Block Template: $block"
         } else {
            OPERATOR_MSG "+ Block Template: $block"
         }
      return [MOM_POST__do_template $block $args]
      }
     }
   }
}


#=============================================================
proc PB_CMD__define_debug_msg { } {
#=============================================================
# "PB_CMD__define_debug_msg", when present in post, will be executed
# automatically by the Start of Program event to facilitate the debugging
# capability for the posts created in Post Builder v903 & newer versions
# with calls to "PB_POST__debug_msg" command embedded.
#
# => DO NOT change the name of this custom command!
# => In PB v10.01, this command is executed automatically, therefore
#    do not call it in any event marker.
#
# ==> Variable "PB_POST__DEBUG" below should be set to "1" (default) to activate debugging.
# ==> Signature of "PB_POST__debug_msg { args }" command must not be changed.
#
#     Calls to "PB_POST__debug_msg" can be embedded in your custom commands.
#
#     *** Do Not call it in any before-output commands!!!
#     *** Do Not call it in any utility commands e.g. CALLED_BY.
#
#
# +++ Contents of debug messages (below) can be configured per user's need. +++
#
#-------------------------------------------------------------
# 01-17-2014 gsl  - Initial version (v903)
# 05-27-2015 gsl  - Added time & stack tracking (v1003)
# Feb-24-2016 gsl - Use ARR_sort_array_to_list to list info of array variables
# Jul-05-2016 gsl - Overload MOM_do_template to trace block template processed
#

#  |||||||||||||||||||||
#  VVVVVVVVVVVVVVVVVVVVV
   set PB_POST__DEBUG  1

   if $PB_POST__DEBUG {

     # To display Block template being output
      if [CMD_EXIST PB_CMD__show_block_template] {
         PB_CMD__show_block_template
      }

     uplevel #0 {
      #==================================
      proc PB_POST__debug_msg { args } {
      #==================================
        #+++++++++++++++++++++++++++++++++++++++++++++++++++++
        # UnComment next line to suppress detailed debug info
        # return

         set tab 2
         set n_level [expr $tab*([info level] - 1)]
         if { $n_level < 0 } { set n_level 0 }
         set indent [format %${n_level}c 32]

         OPERATOR_MSG ">>> $indent [info level -1] - [join $args]"

        ############################################################
        # Enable next condition to output additional info
        #
         if 1 {
           #++++++++++++++++++++++++++++++++++++++++++++++++++++++++
           # Configure the details for the variables to be observed
           #
            set gvars [list]

           # lappend gvars mom_sys_delay_param
           # lappend gvars mom_delay_value
           # lappend gvars mom_delay_revs
           # lappend gvars mom_delay_mode
           # lappend gvars delay_time

           # lappend gvars mom_manual_tool_change
           # lappend gvars mom_tool_change_type

            lappend gvars mom_motion_type mom_pos mom_mcs_goto

            foreach v $gvars {
               if [info exists ::$v] {
                  if [array exists ::$v] {
                     OPERATOR_MSG ">>>>> \t\t $v: [ARR_sort_array_to_list ::$v]"
                  } else {
                     OPERATOR_MSG ">>>>> \t\t $v: [set ::$v]"
                  }
               } else {
                  OPERATOR_MSG ">>>>> \t\t $v: Undefined"
               }
            }
           #++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         }


        ############################################################
        # Enable next condition to collect times used for execution
        #
        # - "PB_CMD__list_debug_info" can be added to End of Program
        #   to list the results to the output.
        #
         if 0 {
           #++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            set command [lindex [info level -1] 0]

            if [string match "START" [lindex $args 0]] {

               set __stack "[join [TRACE -3] " -> "]"
               if { [string trim $__stack] == "" } { set __stack "MOM/POST" }
               if ![info exists ::PB_POST_cmd_stack($command)] {
                  set ::PB_POST_cmd_stack($command)  ""
               }
               if { [lsearch $::PB_POST_cmd_stack($command) $__stack] < 0 } {
                  lappend ::PB_POST_cmd_stack($command) $__stack
               }

               if ![info exists ::PB_POST_cmd_visit($command)] {
                  set ::PB_POST_cmd_visit($command) 1
               } else {
                  incr ::PB_POST_cmd_visit($command)
               }

               set ::PB_POST_time_start($command) [clock clicks]
            }

           # Accumulate time consumed per command
           #
            set _time_used 0

            if { [string match "END" [lindex $args 0]] || [string match "RETURN" [lindex $args 0]] } {

               if [info exists ::PB_POST_time_start($command)] {
                  set _time_used [expr [clock clicks] - $::PB_POST_time_start($command)]
                  unset ::PB_POST_time_start($command)
               }

               if ![info exists ::PB_POST_time_used($command)] {
                  set ::PB_POST_time_used($command) $_time_used
               } else {
                  set ::PB_POST_time_used($command) [expr $::PB_POST_time_used($command) + $_time_used]
               }

              # Increment start time by the time consumed for remaining active commands.
               foreach cmd [array names ::PB_POST_time_start] {
                  set ::PB_POST_time_start($cmd) [expr $::PB_POST_time_start($cmd) + $_time_used]
               }
            }
           #++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         }
      }
      #==================================
     } ;# uplevel

   } else {

     uplevel #0 {
      #==================================
      proc PB_POST__debug_msg { args } {}
      #==================================
     }
   }

}


#=============================================================
proc PB_CMD__list_debug_info { } {
#=============================================================
# "PB_CMD__list_debug_info" can be added to End of Program event
# to list the result of debug messages to the posted output.

  # Grab final clock
   if { ![info exists ::PB_POST_program_end_clock] } {
      set ::PB_POST_program_end_clock [clock clicks]
   }

   OPERATOR_MSG "+++++++++++++++++++++++++++++++++++++++++++++++++++"
   OPERATOR_MSG "Program end clock: [clock format [clock seconds]]"
   OPERATOR_MSG "+++++++++++++++++++++++++++++++++++++++++++++++++++"

   if [array exists ::PB_POST_time_used] {

     # Complete remaining commands
     # ==> Commands not timed, to only show visits
      foreach cmd [array names ::PB_POST_time_start] {
         if ![info exists ::PB_POST_time_used($cmd)] {
            set ::PB_POST_time_used($cmd) 0
         }
      }

     # Accumulate Tcl time
      set time_accu 0
      set time_list [ARR_sort_array_to_list ::PB_POST_time_used 1 1]

      foreach { elem } $time_list {
         set cmd  [lindex $elem 0]
         set time [lindex $elem 1]

         if ![info exists ::PB_POST_cmd_visit($cmd)] { set ::PB_POST_cmd_visit($cmd) 1 }
         if ![info exists ::PB_POST_cmd_stack($cmd)] { set ::PB_POST_cmd_stack($cmd) "MOM/POST" }

          # Call stack & time spent by each command
           OPERATOR_MSG "\n[join $::PB_POST_cmd_stack($cmd) \n]"
           OPERATOR_MSG "   ==> [format "%-40s" $cmd] \t $time \t\t - visited $::PB_POST_cmd_visit($cmd)"

         set time_accu [expr $time_accu + abs($time)]
      }

      OPERATOR_MSG "++++++++++++++++++++++++++++++"
      OPERATOR_MSG "Total Tcl time used:  $time_accu"
      OPERATOR_MSG "++++++++++++++++++++++++++++++"
   }

  # Start clock will be set @ Start of Program when debug mode is on.
   if { [info exists ::PB_POST_program_start_clock] && [info exists ::PB_POST_program_end_clock] } {
      OPERATOR_MSG "Total program time:   [expr $::PB_POST_program_end_clock - $::PB_POST_program_start_clock]"
      OPERATOR_MSG "++++++++++++++++++++++++++++++"
   }
}


#=============================================================
proc ARR_sort_array_to_list { ARR {by_value 0} {by_decr 0} } {
#=============================================================
# This command will sort and build a list of elements of an array.
#
#   ARR      : Array Name
#   by_value : 0 Sort elements by names (default)
#              1 Sort elements by values
#   by_decr  : 0 Sort into increasing order (default)
#              1 Sort into decreasing order
#
#   Return a list of {name value} couplets
#
#-------------------------------------------------------------
# Feb-24-2016 gsl - Added by_decr flag
#
   upvar $ARR arr

   set list [list]
   foreach { e v } [array get arr] {
      lappend list "$e $v"
   }

   set val [lindex [lindex $list 0] $by_value]

   if { $by_decr } {
      set trend "decreasing"
   } else {
      set trend "increasing"
   }

   if [expr $::tcl_version > 8.1] {
      if [string is integer "$val"] {
         set list [lsort -integer    -$trend -index $by_value $list]
      } elseif [string is double "$val"] {
         set list [lsort -real       -$trend -index $by_value $list]
      } else {
         set list [lsort -dictionary -$trend -index $by_value $list]
      }
   } else {
      set list    [lsort -dictionary -$trend -index $by_value $list]
   }

return $list
}


#=============================================================
proc OPERATOR_MSG { msg {seq_no 0} } {
#=============================================================
# This command will output a single or a set of operator message(s).
#
#   msg    : Message(s separated by new-line character)
#   seq_no : 0 Output message without sequence number (Default)
#            1 Output message with sequence number
#

   foreach s [split $msg \n] {
      set s1 "$::mom_sys_control_out $s $::mom_sys_control_in"
      if { [string length $s] > 0 } {
         if { !$seq_no } {
            MOM_suppress once N
         }
         MOM_output_literal $s1
      }
   }

   set ::mom_o_buffer ""
}


#=============================================================
proc INFO_global_vars { {title MOM_Kin_Variables} {pattern mom_kin_} {pause 0} } {
#=============================================================
# This function displays current settings of a set of global variables.
#
# Syntax:
#   INFO_global_vars
#   INFO_global_vars "Info of MOM Kin Variables"
#   INFO_global_vars "MOM Sys Variables" "mom_sys_"
#   INFO_global_vars "List of MOM ISV Variables" "mom_isv_" p
#
# Arguments:
#   title   - String to be displayed as the title for the information interrogated.
#   pattern - Optional pattern of variables (default to mom_kin_) to be listed
#   pause   - Optional flag that will cause information to be displayed
#             in a Tk message dialog and thus pauses the process.
#             By default (without this flag), the information will be listed in
#             the listing device.
#

   set var_list [lsort -dictionary [info global "*${pattern}*"]]

   set msg ""
   foreach var $var_list {
      if [array exists ::$var] {
         foreach { idx elm } [array get ::$var] {
            if [info exists ::${var}($idx)] {
               set s [format "%-35s = %s" ${var}($idx) $elm]
               set msg "$msg\n$s"
            }
         }
      } else {
         if [info exists ::$var] {
            set s [format "%-35s = %s" $var [set ::$var]]
            set msg "$msg\n$s"
         }
      }
  }

  if { $pause != "0" } {
     PAUSE $title $msg
  } else {
     INFO $title\n$msg\n\n
  }
}


#=============================================================
proc INFO_kin_vars { {title MOM_Kin_Variables} {pause 0} } {
#=============================================================
# This function displays current settings of the KIN variables.
#
# Syntax:
#   INFO_kin_vars
#   INFO_kin_vars "Info of MOM Kin Variables"
#   INFO_kin_vars "List of MOM Kin Variables" p
#
# Arguments:
#   title - String to be displayed as the title for the information interrogated.
#   pause - Optional flag that will cause information to be displayed in
#           a Tk message dialog and thus pauses the process.
#           By default (without this flag), the information will be listed in
#           the listing device.
#
   INFO_global_vars $title "mom_kin_" $pause
}




