##
## - mom_pause_win64.tcl
##
##==================================================================================================
## This script will enable you to pause the UG/Post processing.
##
## Assuming you will place this script into UGII_CAM_AUXILIARY_DIR,
## the usage is as follow:
##
##
##   set cam_aux_dir [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]
##   regsub -all {\\} $cam_aux_dir {/}  cam_aux_dir
##   regsub -all { }  $cam_aux_dir {\ } cam_aux_dir
##
##   open "|${cam_aux_dir}ugwish ${cam_aux_dir}mom_pause_win64.tcl <pause_file_name>"
## or
##   open "|${cam_aux_dir}ugwish ${cam_aux_dir}mom_pause_win64.tcl <pause_file_name> <message>"
## or
##   open "|${cam_aux_dir}ugwish ${cam_aux_dir}mom_pause_win64.tcl <pause_file_name> <title> <message>"
##==================================================================================================

wm withdraw .
update

set title ""
set msg ""
set pause_file_name ""


if { [llength $argv] == 1 } {
  set pause_file_name [lindex $argv 0]
}

if { [llength $argv] == 2 } {
  set pause_file_name [lindex $argv 0]
  set msg [lindex $argv 1]
}

if { [llength $argv] > 2 } {
  set pause_file_name [lindex $argv 0]
  set title [lindex $argv 1]
  set msg   [lindex $argv 2]
}

if { [string length [string trim $title]] == 0 } {
  set title "MOM Pause Win64"
}


# Allow users to continue or stop after the message popup.
#
set msg "[string trim $msg]\n\n\
         Press \"Yes\" to continue,\n\
         \"No\" to stop debugging or\n\
         \"Cancel\" to abort the job"


   #####
   #   Open the inter process communication file to record the responses
   #   from the dialog and then close the file
   #####

   set fid [open "$pause_file_name" w]

   switch [tk_messageBox -title "$title" -message "$msg" -type yesnocancel -icon info] {
      no {
         puts $fid no
      }
      cancel {
         puts $fid cancel
      }
      default {
         puts $fid yes
      }
   }

   close $fid
   file attributes "$pause_file_name" -readonly 1


wm withdraw .; destroy .




