##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006/2007/2008/2009,      #
#                                                                            #
#                           Siemens PLM Software                             #
#                                                                            #
##############################################################################


#=============================================================
proc PB_CMD_display_sample_Tk_dialog { } {
#=============================================================

  # Provide a Tcl/Tk script for your application with a qualified path
  # -- "\\" should be used for Windows' folder names
  #
   set tcl "C:\\Program Files\\UGS\\NX 6.0\\MACH\\custom\\my.tcl"


   if { [file exists "$tcl"] } {


      set buff [UGWISH_win64 "$tcl"]


     #++++++++++++++++++++++++++++++++++++++++++++++
     # Read & process data returned from the dialog
     #++++++++++++++++++++++++++++++++++++++++++++++
      if { [string length $buff] > 0 } {

        # - You must know exactly how the data has been written and
        #   organized by your script and process them accordingly.
        #

      }
   }


######################## S A M P L E #########################
# == My_Tcl_Script.tcl ==
#
# - The Tcl script should accept a file string as its argument and will
#   open it as the output channel to collect messages that it needs
#   to communicate with the caller of this command.
#
# - Upon exit of the Tk dialog, the Tcl script should close the scratch file
#   and MUST change its file attribute to "Read-Only". (See sample code below)
#
# - The contents of scratch file will be returned to the caller of this command.
#
# - It's up to the caller to process the resultant data from the scratch file.
#
if 0 {
 #------------------------------------
 # Fetch scratch file given by caller
 #------------------------------------
  set tmp_file [lindex $argv 0]


  wm withdraw .
  update


  # Open file channel to collect output messages
   set fid [open "$tmp_file" w]


  #+++++++++++++++++++++++++++++++++++
  # Body of work for your application
  #+++++++++++++++++++++++++++++++++++
   set title "My Tk Dialog"
   set msg   "Click Yes to continue, No to stop debugging and Cancel to abort the job"

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


  #--------------------------------------------
  # Close scratch file and set it to -readonly
  #--------------------------------------------
   close $fid
   file attributes "$tmp_file" -readonly 1


  wm withdraw .; destroy .
}
######################## S A M P L E #########################

}


#=============================================================
proc UGWISH_win64 { tcl } {
#=============================================================
#
# This command will spawn a separated process to display a Tk dialog
# programmed by the given Tcl script.
#
#
# - The Tcl script should accept a file string as its argument and will
#   open it as the output channel to collect messages that it needs
#   to communicate with the caller of this command.
#   ==> The name of the scratch file is defined in this command automatically
#       in conjunction with the user's log-in name and is created in the
#       UGII_TMP_DIR directory.
#
# - Upon exit of the Tk dialog, the Tcl script should close the scratch file
#   and MUST change its file attribute to "Read-Only". (See sample code below)
#
# - The contents of scratch file will be returned to the caller of this command.
#
# - It's up to the caller to process the resultant data from the scratch file.
#   ==> The caller must know exactly how the data has been written and organized
#       by the script and process them accordingly.
#
#
# This command has been implemented to enable the win32-bit standalone ugwish.exe to display
# a Tk dialog in the win64 environment. It should also work as well in the win32 environment.
#
#
######################## S A M P L E #########################
# == My_Tcl_Script.tcl ==

if 0 {
 #------------------------------------
 # Fetch scratch file given by caller
 #------------------------------------
  set tmp_file [lindex $argv 0]


  wm withdraw .
  update


  # Open file channel
   set fid [open "$tmp_file" w]


  #+++++++++++++++++++++++++++++++++++
  # Body of work for your application
  #+++++++++++++++++++++++++++++++++++
   set title "My Tk Dialog"
   set msg   "Click Yes to continue, No to stop debugging and Cancel to abort the job"

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


  #--------------------------------------------
  # Close scratch file and set it to -readonly
  #--------------------------------------------
   close $fid
   file attributes "$tmp_file" -readonly 1


  wm withdraw .; destroy .
}
######################## S A M P L E #########################



   set cam_aux_dir  [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]
   set ug_wish "ugwish.exe"

   if { [file exists "${cam_aux_dir}$ug_wish"] && [file exists "$tcl"] } {

    ######
    # Define a scratch file in the UGII_TMP_DIR directory
    ######
     global mom_logname

     set tmp_file "[MOM_ask_env_var UGII_TMP_DIR]/${mom_logname}_mom_tmp_[clock clicks].txt"

    # Clean up any existing file with the same name
     if [file exists "$tmp_file"] {
        file delete -force "$tmp_file"
     }

     regsub -all {\\} $cam_aux_dir {/}  cam_aux_dir
     regsub -all { }  $cam_aux_dir {\ } cam_aux_dir

     regsub -all {\\} $tcl {/}  tcl
     regsub -all { }  $tcl {\ } tcl

     regsub -all {\\} $tmp_file {/}  tmp_file
     regsub -all { }  $tmp_file {\ } tmp_file


    ######
    # Execute script
    ######
     open "|${cam_aux_dir}$ug_wish ${tcl} ${tmp_file}"


    ######
    # Waiting for the Tcl script to complete its process...
    #
    # - This is indicated when the scratch file materialized and became read-only.
    ######
     while { ![file exists "$tmp_file"] || [file writable "$tmp_file"] } { }



    # Fetch data & clean up scratch file
     set fid [open "$tmp_file" r]
     set out_buff [read $fid]

     close $fid
     file delete -force "$tmp_file"


    #-------------------------------------------
    # Return contents of scratch file to caller
    #-------------------------------------------
return "$out_buff"
   }
}




