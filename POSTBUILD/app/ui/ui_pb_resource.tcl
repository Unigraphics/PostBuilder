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

# User's Manual
#
#set gPB(user_manual_file)       "$env(UGII_BASE_DIR)/UGDOC/html_files/nx_help/index.html#uid:index_postbuilder"
set gPB(user_manual_file)       "$env(UGII_BASE_DIR)/UGDOC/html_files/nx_help/index.html"

if { ![file exists $gPB(user_manual_file)] } {
    set gPB(user_manual_file)    "$env(PB_HOME)/doc/index.html"
}
if { ![file exists $gPB(user_manual_file)] } {
    set gPB(user_manual_file)    "$env(PB_HOME)/doc/index.htm"
}
if { ![file exists $gPB(user_manual_file)] } {
    set gPB(user_manual_file)    "$env(PB_HOME)/doc/pb_help.html"
}

if { [string match "window*" $tcl_platform(platform)] } {
    if { ![file exists $gPB(user_manual_file)] } {
        set gPB(user_manual_file) "$env(PB_HOME)/doc/postbuilder.chm"
    }
}


set gPB(dialog_help_file)          "$env(PB_HOME)/doc/pb.html"


# Tcl/Tk Manuals
#
set gPB(tcl_tk_manuals)            "$env(PB_HOME)/tcl/doc/contents.htm"
if { ![file exists $gPB(tcl_tk_manuals)] } {
    set gPB(tcl_tk_manuals)         "$env(PB_HOME)/tcl/TclTk8.0Manuals_read_me.txt"
}


# Release Notes
#
if { [info exists env(UGII_LANG)] } {
    set gPB(release_notes)             "$env(UGII_BASE_DIR)/rel_info/release_notes/$env(UGII_LANG)/index.html"
    if { ![file exists $gPB(release_notes)] } {
        set gPB(release_notes)          "$env(PB_HOME)/doc/pb_release_notes.htm"
    }
}


#===============================================================
# Uncomment next line to enable the template_post.dat editor.
#===============================================================
set gPB(edit_template_posts_data)  "$env(PB_HOME)/app/mom_tpd_editor.tcl"


set gPB(mom_vars_browser)          "$env(PB_HOME)/app/mom_vars_browser.tcl"
set gPB(mom_vars_values)           "$env(PB_HOME)/app/mom_vars_csv.txt"


#===============================================================
# Default controller type that will be used for a post that
# does not contain the controller type attribute.
#===============================================================
set gPB(default_controller_type) ""


#===============================================================
# Prompt users to choose a controller type or if the controller
# type specifed (above) does not exist.
#
# 1 : Prompt
# 0 : No prompt unless default type invalid
#===============================================================
if { [info exists env(PB_FORCE_CHOOSE_CNTL_TYPE)] } {
    set gPB(force_choose_cntl_type) $env(PB_FORCE_CHOOSE_CNTL_TYPE)
 } else {
 ## set gPB(force_choose_cntl_type) 0
}


#===============================================================
# The controller family in the list will be located in the head of
# controller menu if it exists.
#===============================================================
set gPB(priority_controller_family_list) [list Siemens]


#===============================================================
# Temporary directory and user's home directory may be used to
# store temporary files created during the Post Builder session.
#===============================================================
if { ![string compare $tcl_platform(platform) "unix"] } {
 
    set env(TEMP)        "/tmp"
    set env(USERNAME)    "$env(LOGNAME)"
 
 } else {
 
    set env(LOGNAME)     "$env(USERNAME)"
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
source $env(PB_HOME)/app/ui/ui_pb_fonts.tcl


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
set gPB(FORCE_SYNTAX_CHECK) 1


#=============================================================================
# List PB_CMD_kin commands in the Custom Command page
#
#  1 : List
#  0 : Hide
#=============================================================================
set gPB(LIST_PB_CMD_KIN) 0


#=============================================================================
# Retain old PB_CMD commands after post conversion
#
#  1 : Keep
#  0 : Not
#=============================================================================
set gPB(KEEP_OLD_PB_CMD) 0


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


#=============================================================================
# Highlight new features in a new release of Post Builder.
#
#  1 : Yes
#  0 : No
#=============================================================================
set gPB(HIGHLIGHT_NEW_FEATURE) 0
set gPB(NEW_FEATURE_COLOR)     cyan


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# Define the navigation buttons layout
#
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
set gPB(nav_button,order) "gPB(nav_button,refresh,Label) \
                           gPB(nav_button,cut,Label)     \
                           gPB(nav_button,paste,Label)   \
                           gPB(nav_button,ok,Label)      \
                           gPB(nav_button,yes,Label)     \
                           gPB(nav_button,default,label) \
                           gPB(nav_button,restore,Label) \
                           gPB(nav_button,apply,Label)   \
                           gPB(nav_button,filter,Label)  \
                           gPB(nav_button,cancel,Label)  \
                           gPB(nav_button,no,Label)      \
                           gPB(nav_button,help,Label)"
                           

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Using description for a custom command used as condition for a block.
#
# gPB(condition_cmd_description) : The comment placed in the begin of a conditon
#                                   custom command.
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
set gPB(condition_cmd_description)  [list "# This custom command should return" \
                                          "#   1 : Output BLOCK" \
                                          "#   0 : No output" \
                                          "" \
                                          "   global mom_logname" \
                                          "" "" "" "" \
                                          " return 1"]

set gPB(elem_condition_color) orange ;# red
set gPB(elem_suppress_color)  darkRed ;# black



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Set the state of some special custom commands which could not be attached to
#  any event, renamed, or/and deleted.
#
# Each element of this list should consist of custom command name, attach flag,
#  rename flag and delete flag. ("name attach_flag rename_flag delete_flag")
#
# For example, the element "PB_CMD_test 0 0 1" indicates the custom command
#  "PB_CMD_test" should not be attached to any event (the attach_flag is 0),
#  not be renamed (the rename_flag is 0) but should
#  be deleted (the delete_flag is 1).
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
set gPB(special_cmd_state_list) \
       [list "PB_CMD_MOM_clamp 0 0 0" \
             "PB_CMD_MOM_insert 0 0 0" \
             "PB_CMD_MOM_lock_axis 0 0 0" \
             "PB_CMD_MOM_opskip_off 0 0 0" \
             "PB_CMD_MOM_opskip_on 0 0 0" \
             "PB_CMD_MOM_pprint 0 0 0" \
             "PB_CMD_MOM_rotate 0 0 0" \
             "PB_CMD_MOM_text 0 0 0" \
             "PB_CMD_MOM_operator_message 0 0 0"]


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# Strings, labels and messages definitions
#
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
set gPB(load_pb_title) "Loading NX/Post Builder ..."
source $env(PB_HOME)/app/ui/ui_pb_language.tcl


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Source custom resource per installation, if it exists.
# *** Post Builder should never deliver or override this file! ***
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if { [file exists $env(PB_HOME)/app/ui/ui_pb_custom_resource.tcl] } {
 
    source $env(PB_HOME)/app/ui/ui_pb_custom_resource.tcl
}


