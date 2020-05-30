##=================================================================
## This script will enable you to pause the UG/Post processing.
##
## Assuming you will place this script into UGII_CAM_AUXILIARY_DIR,
## the usage is as follow:
##
##
##   set cam_aux_dir [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]
##   regsub -all {\\} $cam_post_dir {\\\\} cam_aux_dir
## 
##   exec ${cam_aux_dir}ugwish ${cam_aux_dir}mom_pause.tcl
## or
##   exec ${cam_aux_dir}ugwish ${cam_aux_dir}mom_pause.tcl <message>
## or
##   exec ${cam_aux_dir}ugwish ${cam_aux_dir}mom_pause.tcl <title> <message>
##=================================================================

wm withdraw .
update

set title ""
set msg ""

if { [llength $argv] == 1 } {
  set msg [lindex $argv 0]
}

if { [llength $argv] > 1 } {
  set title [lindex $argv 0]
  set msg [lindex $argv 1]
}

if { [string length [string trim $title]] == 0 } {
  set title "MOM Pause"
}



# Allow users to continue or stop after the message popup.
#
set msg "[string trim $msg]\n\n\
         Press \"Yes\" to continue,\n\
         \"No\" to stop debugging or\n\
         \"Cancel\" to abort the job"

   switch [tk_messageBox -title "$title" -message "$msg" -type yesnocancel -icon info] {
      no {
         puts no
      }
      cancel {
         puts cancel
      }
      default {
         puts ok
      }
   }


wm withdraw .; destroy .




