##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006/2007                 #
#                                                                            #
#                            UGS/PLM Solutions                               #
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
proc PB_CMD__define_debug_msg { } {
#=============================================================
# This command can be added to the Start of Program to facilitate
# debugging capability for the posts created in Post Builder v903.
# => DO NOT change its name!
#
# ==> Variable "PB_POST__DEBUG" should be set to "1" (default) to activate debugging.
# ==> Signature of "PB_POST__debug_msg { args }" command should not be changed.
#
#     Calls to "PB_POST__debug_msg" can be embedded in your custom commands.
#     *** Do Not call it in any before-output commands!!!
#     *** Do Not use it in utility commands e.g. CALLED_BY
#     This command can be called in other custom commands for debugging purpose.
#
# +++ Contents of debug messages (below) can be configured per user's intent.
#
#-------------------------------------------------------------
# 01-17-2014 gsl - Initial version (v903)
#
#  |||||||||||||||||||||
#  VVVVVVVVVVVVVVVVVVVVV
   set PB_POST__DEBUG  1

   if $PB_POST__DEBUG {

     uplevel #0 {
      #==================================
      proc PB_POST__debug_msg { args } {
      #==================================
         set n_level [expr 2*([info level] - 1)]
         if { $n_level < 0 } { set n_level 0 }
         set indent [format %${n_level}c 32]

         OPERATOR_MSG ">>> $indent [info level -1] - [join $args]"

         #++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         # Configure the details for the variables to be observed
         #
         if [info exists ::mom_out_angle_pos(1)] {
            OPERATOR_MSG ">>>>> mom_out_angle_pos(1): $::mom_out_angle_pos(1)"
         }
         #++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      }
     }

   } else {

     uplevel #0 {
      #==================================
      proc PB_POST__debug_msg { args } {}
      #==================================
     }
   }
}


#=============================================================
proc OPERATOR_MSG { msg } {
#=============================================================
   MOM_output_text "$::mom_sys_control_out $msg $::mom_sys_control_in"
}


#=============================================================
proc INFO_global_vars { {title "MOM Kin Variables"} {pattern "mom_kin_"} {pause 0} } {
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
#   pattern - Part of pattern of variables to be listed
#   pause   - Optional flag that will cause information to be displayed in
#             a Tk message dialog and thus pauses the process.
#             By default (without this flag), the information will be listed in
#             the listing device.
#

   set var_list [lsort -dictionary [info global "*${pattern}*"]]

   set msg ""
   foreach var $var_list {
     # Global declaration
      global $var

      if [array exists $var] {
         foreach { idx elm } [array get $var] {
            if [info exists [set var]($idx)] {
               set s [format "%-35s = %s" [set var]($idx) $elm]
               set msg "$msg\n$s"
            }
         }
      } else {
         if [info exists $var] {
            set s [format "%-35s = %s" $var [set $var]]
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
proc INFO_kin_vars { {title "MOM Kin Variables"} {pause 0} } {
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



