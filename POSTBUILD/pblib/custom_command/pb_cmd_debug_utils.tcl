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
##############################################################################
# TEXT ENCLOSED WITHIN DELETE MARKERS WILL BE REMOVED UPON RELEASE. @<DEL>@



#=============================================================
proc INFO { args } {
#=============================================================
   MOM_output_to_listing_device [join $args]
}


#=============================================================
proc INFO_kin_vars { title args } {
#=============================================================
# This function displays current settings of the KIN variables.
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


#=============================================================
proc PAUSE { args } {
#=============================================================
  global env

  if { [info exists env(PB_SUPPRESS_UGPOST_DEBUG)] &&  $env(PB_SUPPRESS_UGPOST_DEBUG) == 1 } {
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
 


