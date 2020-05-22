##############################################################################
#                       U I _ P B _ R E S O U R C E . T C L
##############################################################################
# Description                                                                #
#    This file defines User Interface resources for the UG/Post Builder.     #
#                                                                            #
##############################################################################

##############################################################################
#               Environment setup for running Post Builder.
##############################################################################


#===========================================
# Internet browser for Unix
# - This doesn't affect the Windows systems.
#===========================================
set gPB(unix_netscape)		"netscape"


#==============================================================
# Location for Post Builder on-line help manual
# - This allows the help manual to be stored in the location
#   other than the default Post Builder installation directory
#   or using other document as the on-line help manual.
#==============================================================

if {$tcl_platform(platform) == "unix"} \
{
   set gPB(user_manual_file)       "$env(UGII_BASE_DIR)/ugdoc/html_files/postbuilder/index.htm"
   if { ![file exists $gPB(user_manual_file)] } {
      set gPB(user_manual_file)    "$env(PB_HOME)/doc/index.htm"
   }
   if { ![file exists $gPB(user_manual_file)] } {
      set gPB(user_manual_file)    "$env(PB_HOME)/doc/pb_help.html"
   }

} else {
   set gPB(user_manual_file)       "$env(UGII_BASE_DIR)/ugdoc/html_files/postbuilder/index.htm"
   if { ![file exists $gPB(user_manual_file)] } {
      set gPB(user_manual_file)    "$env(PB_HOME)/doc/index.htm"
   }
   if { ![file exists $gPB(user_manual_file)] } {
      set gPB(user_manual_file)    "$env(PB_HOME)/doc/postbuilder.chm"
   }
   if { ![file exists $gPB(user_manual_file)] } {
      set gPB(user_manual_file)    "$env(PB_HOME)/doc/pb_help.html"
   }
}

set gPB(dialog_help_file)          "$env(PB_HOME)/doc/pb.html"
set gPB(release_notes)             "$env(PB_HOME)/doc/pb_release_notes.htm"
set gPB(tcl_tk_manuals)            "$env(PB_HOME)/tcl/doc/contents.htm"


# Uncomment next line to enable the template_post.dat editor.
set gPB(edit_template_posts_data)  "$env(PB_HOME)/app/mom_tpd_editor.tcl"


set gPB(mom_vars_browser)          "$env(PB_HOME)/app/mom_vars_browser.tcl"
set gPB(mom_vars_values)           "$env(PB_HOME)/app/mom_vars_csv.txt"



#===============================================================
# Temporary directory and user's home directory may be used to
# store temporary files created during the Post Builder session.
#===============================================================
if {$tcl_platform(platform) == "unix"} \
{
   set env(TEMP)		"/tmp"
   set env(USERNAME)		"$env(LOGNAME)"

} else \
{
   set env(LOGNAME)		"$env(USERNAME)"
}


#=================================================================================
# Backup method
# - This parameter allows the users to create backup copies of
#   the Post files being edited before saving the changes:
#
#       BACKUP_ONE : Only one backup will be created on the original version of
#                    the Post in progress.
#                    The backup files are named *_org.pui, *_org.def & *_org.tcl.
#       BACKUP_ALL : A new backup will be created for every save.
#                    The sequence of backups will be named *_bck, *_bck1, etc.
#                    followed by the .pui, .def & .tcl extensions.
#       NO_BACKUP  : No backup will be created.
#=================================================================================
set gPB(backup_method)          "BACKUP_ONE"


#========================
# Font set specification
#========================
if {$tcl_platform(platform) == "windows"} \
{
   font create winFontNormal -family {MS Sans Serif} -size 8
   font create winFontBold   -family {MS Sans Serif} -size 8 -weight bold
   font create winFontItalic -family {MS Sans Serif} -size 8 -weight bold -slant italic

   set gPB(font)		{ansi 9}
   set gPB(font_sm)		{ansi 7}
   set gPB(bold_font)		{ansi 9 bold}
   set gPB(bold_font_lg)	{ansi 11 bold}
   set gPB(italic_font)         {ansi 9 italic bold}
   set gPB(italic_font_normal)	{ansi 9 italic}
   set gPB(fixed_font)		{courier 9}
   set gPB(fixed_font_sm)	{courier 7}

} else \
{
   set gPB(font)               	$tixOption(font)
   set gPB(font_sm)		{helvetica 9}
   set gPB(bold_font)		$tixOption(bold_font)
   set gPB(bold_font_lg)	{helvetica 11 bold}
   set gPB(italic_font)         $tixOption(italic_font)
   set gPB(italic_font_normal)  {helvetica 9 italic}
   set gPB(fixed_font)		{courier 12}
   set gPB(fixed_font_sm)	{courier 9}
}


#=============================================================================
# Posts history pulldown menu length
#
# -  n : Number of previously visited Posts to be displayed in pull-down menu.
#   -1 : Eliminates "Visited Posts" menu item entirely.
#=============================================================================
set gPB(post_history_menu_len)  15


#=============================================================================
# Block element icon animation
#
#  gPB(animation)        1 : Animated Block elements deletion
#                        0 : No
#
#  gPB(animation_delay)  N : Delay in N miliseconds between elements deleted.
#=============================================================================
set gPB(animation)        1
set gPB(animation_delay) 30


#=============================================================================
# Number of iterrations for Custom Commands evaluation.
#=============================================================================
set gPB(custom_command_eval_iter) 20


#=============================================================================
# Custom command syntax checker toggle switch
#
#  1 : Hide switch (Always perform syntax checking)
#  0 : Show switch
#=============================================================================
set gPB(FORCE_SYNTAX_CHECK) 0


#=============================================================================
# List PB_CMD_kin commands in the Custom Command page
#
#  1 : List
#  0 : Hide
#=============================================================================
set gPB(LIST_PB_CMD_KIN) 1


#=============================================================================
# Retain old PB_CMD commands after post conversion
#
#  1 : Keep
#  0 : Not
#=============================================================================
set gPB(KEEP_OLD_PB_CMD) 1


#=============================================================================
# Hide "Post Files Preview" page
#
#  1 : Hide
#  0 : Display
#=============================================================================
set gPB(HIDE_POST_PREVIEW_PAGE) 0


#=============================================================================
# Confirm permission to save Post to directory or files.
#
#  1 : Yes
#  0 : No
#=============================================================================
set gPB(CONFIRM_WRITE_PERMISSION) 1


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Strings, labels and messages definition
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
source $env(PB_HOME)/app/ui/ui_pb_language.tcl


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Source custom resource per installation, if it exists.
# *** Post Builder should never deliver or override this file! ***
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if [file exists $env(PB_HOME)/app/ui/ui_pb_custom_resource.tcl] {
   source $env(PB_HOME)/app/ui/ui_pb_custom_resource.tcl
}




