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
#@<DEL>@ TEXT ENCLOSED WITHIN DELETE MARKERS WILL BE REMOVED UPON RELEASE.
##############################################################################
#
# Revisions
# ---------
# Date     Who   Reason
# ----     ---   ------
# 04-26-07 gsl - Inception
#======
# v700
#======
# 05-13-09 gsl - Removed PAUSE command
#======
# v800
#======
# 01-27-11 gsl - Removed INFO. It gets added when post is upgraded.
#              - Enhanced description for INFO_kin_vars.
##############################################################################
# TEXT ENCLOSED WITHIN DELETE MARKERS WILL BE REMOVED UPON RELEASE. @<DEL>@



#=============================================================
proc INFO_kin_vars { title args } {
#=============================================================
# This function displays current settings of the KIN variables.
#
# Syntax:
#   INFO_kin_vars "Title" P
#
#  Title - String to be displayed as the title for the information interrogated.
#  P     - An optional flag that will cause information to be displayed in
#          a Tk message dialog and thus pauses the process.
#          By default (without this flag), the information will be listed in
#          the listing device.
#

  # Determine the need to display message in a dialog.
   set pause 0
   if { [llength $args] > 0 } {
      if { [string match "P*" [string toupper [string trim [lindex $args 0]]]] } {
         set pause 1
      }
   }

   set var_list [lsort -dictionary [info global "*mom_kin_*"]]

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

  if { $pause } {
     PAUSE $title $msg
  } else {
     INFO $title\n$msg\n\n
  }
}


