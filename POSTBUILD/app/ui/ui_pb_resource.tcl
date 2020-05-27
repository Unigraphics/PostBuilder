##############################################################################
#                       U I _ P B _ R E S O U R C E . T C L
##############################################################################
# Description                                                                #
#    This file defines User Interface resources for the UG/Post Builder.     #
#                                                                            #
# @<DEL>@ TEXT ENCLOSED within delete markers will be REMOVED                #
#============================================================================#
#                                                                            #
# Revisions                                                                  #
# ---------                                                                  #
#   Date        Who       Reason                                             #
# 05-Oct-1999   gsl       Initial                                            #
# 17-Nov-1999   gsl       Submitted for phase-22.                            #
#----------------------------------------------------------------------------#
# 22-Nov-1999   gsl       Added more stuff.                                  #
# 03-Mar-2K     gsl       Enhanced CSH stuff.                                #
# 26-Apr-2000 mnb/gsl V17008 submission                                      #
# 05-Jun-2000 mnb/gsl V17011 submission                                      #
# 20-Jun-2000   mnb   V17012 submission                                      #
# 18-Jul-2000   gsl       Added some resources for customizing PB.           #
# 27-Jul-2000   gsl       Set some env vars to unify Unix and Windows.       #
# 31-Jul-2000   gsl       Added font set specification.                      #
# 02-Aug-2000   gsl       gPB(unix_netscape) was gPB(browser).               #
# 03-Aug-2000   gsl       Words were Addresses.                              #
# 08-Aug-2000 mnb/gsl     Added CSH stuff for Listing File.                  #
# 09-Sep-2000   gsl       Added gPB(seq,rename_popup,Context)                #
# 11-Oct-2000   gsl       Enhanced labels for spindle range types.           #
# 14-Mar-2001   gsl       v18p10 submission.                                 #
# 29-Mar-2001   gsl       Added gPB(address,rapidx,desc).                    #
# 26-Apr-2001   gsl       Added gPB(backup_method).                          #
# 03-May-2001   gsl       "Tool Path" was "Tool Path Events".                #
# 07-May-2001   gsl       Added gPB(cust_cmd,name_has_proc)                  #
# 08-May-2001   gsl   v18 p14                                                #
# 09-May-2001   gsl       Remove gPB(cust_cmd,name_has_proc)                 #
# 23-May-2001   gsl       "File Not Found or Invalid." for                   #
#                         gPB(msg,invalid_file) was "Invalid File Name".     #
#                         Added gPB(msg,invalid_post), gPB(msg,bad_tcl_file) #
#                         and gPB(msg,bad_def_file).                         #
#                         Revised description for gPB(post_history_menu_len) #
# 30-May-2001   gsl       gPB(fixed_font) {courier 12} was default to        #
#                         $tixOption(fixed_font) for unix.                   #
# 08-Jun-2001   gsl       Added gPB(address,exp,space_only).                 #
# 20-Jun-2001   gsl       Enhanced labels for Feedrates.                     #
# 02-Oct-2001   gsl       Added gPB(cust_cmd,import,tree,Label) & Context.   #
#                                                                            #
# $HISTORY$                                                                  #
#============================================================================#
# TEXT ENCLOSED within delete markers will be REMOVED @<DEL>@                #
##############################################################################


##############################################################################
#               Environment setup for running Post Builder.
##############################################################################
#=======================================================================
# Environment variable that will be used to determine the locale for
# the native language translation. It's default to C (ANSI), if not set.
#=======================================================================
if { ![info exists env(LANG)] } \
{
    set env(LANG) C
}

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
set gPB(user_manual_file)	"$env(PB_HOME)/doc/pb_help.html"
set gPB(dialog_help_file)	"$env(PB_HOME)/doc/pb.html"

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
 
    set gPB(font)		{ansi 8}
    set gPB(font_sm)		{ansi 6}
    set gPB(bold_font)		{ansi 8 bold}
    set gPB(bold_font_lg)	{ansi 10 bold}
    set gPB(italic_font)		{ansi 8 italic bold}
    set gPB(fixed_font)		{courier 8}
    set gPB(fixed_font_sm)	{courier 7}
 
} else \
{
    set gPB(font)               	$tixOption(font)
    set gPB(font_sm)		{helvetica 9}
    set gPB(bold_font)		$tixOption(bold_font)
    set gPB(bold_font_lg)	{helvetica 11 bold}
    set gPB(italic_font)		$tixOption(italic_font)
    set gPB(fixed_font)		{courier 12}
    set gPB(fixed_font_sm)	{courier 9}
}

#=============================================================================
# Posts history pulldown menu length
#
# -  n : Number of previously visited Posts to be displayed in pull-down menu.
#   -1 : Eliminates the "Visited Posts" menu item entirely.
#=============================================================================
set gPB(post_history_menu_len)  15

#=============================================================================
# Icon animation delay (in miliseconds)
#=============================================================================
set gPB(animation)       1
set gPB(animation_delay) 50



##############################################################################
#               Strings, labels and messages definition
##############################################################################
##------
## Title
##
set gPB(main,title,Unigraphics)                 "Unigraphics"
set gPB(main,title,UG)                          "UG"
set gPB(main,title,Post_Builder)                "Post Builder"
set gPB(main,title,Version)                     "Version"
set gPB(main,default,Status)                    "Select New or Open option on File menu."
set gPB(main,save,Status)                       "Save the Post."

set gPB(load_pb_title)                          "Loading $gPB(main,title,UG)/$gPB(main,title,Post_Builder) ..."

##------
## File
##
set gPB(main,file,Label)			"File"

set gPB(main,file,Balloon)			"\ New, Open, Save,\n\
						 Save\ As, Close and Exit"

set gPB(main,file,Balloon1)			"\ New, Open, Save,\n\
						 Import MDFA,\n\
						 Save\ As, Close and Exit"

set gPB(main,file,Context)			" "
set gPB(main,file,menu,Context)			" "

set gPB(main,file,new,Label)			"New ..."
set gPB(main,file,new,Balloon)			"Create a new Post."
set gPB(main,file,new,Context)			"Create a new Post."

set gPB(main,file,open,Label)			"Open ..."
set gPB(main,file,open,Balloon)			"Edit an existing Post."
set gPB(main,file,open,Context)			"Edit an existing Post."

set gPB(main,file,mdfa,Label)			"Import MDFA ..."
set gPB(main,file,mdfa,Balloon)			"Create a new Post from MDFA."
set gPB(main,file,mdfa,Context)			"Create a new Post from MDFA."

set gPB(main,file,save,Label)			"Save"
set gPB(main,file,save,Balloon)			"Save the Post in progress."
set gPB(main,file,save,Context)			"Save the Post in progress."

set gPB(main,file,save_as,Label)		"Save As ..."
set gPB(main,file,save_as,Balloon)		"Save the Post to a new name."
set gPB(main,file,save_as,Context)		"Save the Post to a new name."

set gPB(main,file,close,Label)			"Close"
set gPB(main,file,close,Balloon)		"Close the Post in progress."
set gPB(main,file,close,Context)		"Close the Post in progress."

set gPB(main,file,exit,Label)                   "Exit"
set gPB(main,file,exit,Balloon)                 "Terminate Post Builder."
set gPB(main,file,exit,Context)                 "Terminate Post Builder."

set gPB(main,file,history,Label)		"Recently Opened Posts"
set gPB(main,file,history,Balloon)              "Edit a previously visited Post."
set gPB(main,file,history,Context)		"Edit a Post visited in the previous\
                                                 Post Builder sessions."

##---------
## Options
##
set gPB(main,options,Label)			"Options"
set gPB(main,options,Balloon)			"\ Properties, Post\ Advisor"
set gPB(main,options,Context)			" "
set gPB(main,options,menu,Context)		" "

set gPB(main,options,properties,Label)		"Properties"
set gPB(main,options,properties,Balloon)	"Properties"
set gPB(main,options,properties,Context)	"Properties"

set gPB(main,options,advisor,Label)             "Post Advisor"
set gPB(main,options,advisor,Balloon)           "Post Advisor"
set gPB(main,options,advisor,Context)           "Enable/ disable Post Advisor."

set gPB(main,options,cmd_check,Label)           "Validate Custom Commands"
set gPB(main,options,cmd_check,Balloon)         "Validate Custom Commands"
set gPB(main,options,cmd_check,Context)         "Switches for Custom Commands Validation"

set gPB(main,options,cmd_check,syntax,Label)    "Syntax Errors"
set gPB(main,options,cmd_check,command,Label)   "Unknown Commands"
set gPB(main,options,cmd_check,block,Label)     "Unknown Blocks"
set gPB(main,options,cmd_check,address,Label)   "Unknown Addresses"
set gPB(main,options,cmd_check,format,Label)    "Unknown Formats"

set gPB(main,options,backup,Label)		"Backup Post"
set gPB(main,options,backup,Balloon)		"Backup Post Method"
set gPB(main,options,backup,Context)		"Create backup copies when saving the Post\
                                                 in progress."

set gPB(main,options,backup,one,Label)          "Backup Original"
set gPB(main,options,backup,all,Label)          "Backup Every Save"
set gPB(main,options,backup,none,Label)         "No Backup"

##------
## Help
##
set gPB(main,help,Label)			"Help"
set gPB(main,help,Balloon)			"Help Options"

set gPB(main,help,Context)			" "
set gPB(main,help,menu,Context)			" "

set gPB(main,help,bal,Label)			"Balloon Tip"
set gPB(main,help,bal,Balloon)			"Balloon Tip on Icons"
set gPB(main,help,bal,Context)			"Enable/ disable display of\
                                                 balloon tool tips for icons."

set gPB(main,help,chelp,Label)			"Context Help"
set gPB(main,help,chelp,Balloon)		"Context Sensitive Help on Dialog Items"
set gPB(main,help,chelp,Context)		"Context Sensitive Help is on."

set gPB(main,help,what,Label)			"What To Do ?"
set gPB(main,help,what,Balloon)			"What You Can Do Here?"
set gPB(main,help,what,Context)			"What You Can Do Here?"

set gPB(main,help,dialog,Label)			"Help On Dialog"
set gPB(main,help,dialog,Balloon)		"Help On This Dialog"
set gPB(main,help,dialog,Context)		"Help On This Dialog"

set gPB(main,help,manual,Label)			"User's Manual"
set gPB(main,help,manual,Balloon)		"User's Help Manual"
set gPB(main,help,manual,Context)		"User's Help Manual"

set gPB(main,help,about,Label)			"About Post Builder"
set gPB(main,help,about,Balloon)		"About Post Builder"
set gPB(main,help,about,Context)		"About Post Builder"

set gPB(main,help,acknow,Label)			"Acknowledgements"
set gPB(main,help,acknow,Balloon)		"Acknowledgements & Credits"
set gPB(main,help,acknow,Context)		"Acknowledgements & Credits"

##----------
## Tool Bar
##
set gPB(tool,new,Label)				"New"
set gPB(tool,new,Context)			$gPB(main,file,new,Context)

set gPB(tool,open,Label)			"Open"
set gPB(tool,open,Context)			$gPB(main,file,open,Context)

set gPB(tool,save,Label)			"Save"
set gPB(tool,save,Context)			$gPB(main,file,save,Context)

set gPB(tool,bal,Label)				"Balloon Tip"
set gPB(tool,bal,Context)			$gPB(main,help,bal,Context)

set gPB(tool,chelp,Label)			"Context Info"
set gPB(tool,chelp,Context)			" "

set gPB(tool,what,Label)			"What To Do?"
set gPB(tool,what,Context)			$gPB(main,help,what,Context)

set gPB(tool,dialog,Label)			"Help On Dialog"
set gPB(tool,dialog,Context)			$gPB(main,help,dialog,Context)

set gPB(tool,manual,Label)			"User's Manual"
set gPB(tool,manual,Context)			$gPB(main,help,manual,Context)


#=============
# Main Window
#=============

##-----------------
## Common Messages
##
set gPB(msg,dialog,title)                       "Post Builder Message"
set gPB(msg,warning)                            "Warning"
set gPB(msg,invalid_data)                       "Invalid data has been keyed in for the parameter"
set gPB(msg,invalid_browser_cmd)		"Invalid browser command :"
set gPB(msg,no_license)				"You do not have proper license to perform this function!"
set gPB(msg,no_license_title)			"Non-Licensed UG/Post Builder Use"
set gPB(msg,no_license_dialog)			"You are permitted to use the UG/Post Builder\n\
                                                 without proper license.  However, you will not\n\
                                                 be able to save your work afterward."
set gPB(msg,pending)				"Service of this option will be implemented\
						 in the future release."
set gPB(msg,save)                               "Do you want to save your changes\n\
                                                 before closing the Post in progress?"
set gPB(msg,version_check)                      "Post created with newer version of Post Builder\
              					 can not be opened in this version."

set gPB(msg,file_corruption)                    "Incorrect contents in Post Builder Session file."
set gPB(msg,bad_tcl_file)                       "Incorrect contents in the Tcl file of your Post."
set gPB(msg,bad_def_file)                       "Incorrect contents in the Definition file of your Post."
set gPB(msg,invalid_post)                       "You must specify at least one set of\
                                                 Tcl & Definition files for your Post."
set gPB(msg,invalid_dir)                        "Directory doesn't exist."
set gPB(msg,invalid_file)                       "File Not Found or Invalid."
set gPB(msg,invalid_def_file)                   "Cannot open Definition File"
set gPB(msg,invalid_tcl_file)                   "Cannot open Event Handler File"
set gPB(msg,dir_perm)                           "You do not have the write permission to the directory:"
set gPB(msg,file_perm)                          "You do not have the write permission to the\
                                                 following file(s):"
set gPB(msg,file_exist)                         "already exist!\n\
                                                 Do you want to replace them?"
set gPB(msg,file_missing)                       "Some or all files for this Post are missing.\n\
                                                 You can not open this Post."
set gPB(msg,sub_dialog_open)                    "You have to complete the editing of all parameter\
                                                 sub dialogs before saving the Post!"
set gPB(msg,generic)                            "Post Builder currently has only been implemented\
                                                 for Generic Milling Machines."
set gPB(msg,min_word)                           "A Block should contain at least one Word."
set gPB(msg,name_exists)                        "already exists!\n\
                                                 Specify a different name."
set gPB(msg,in_use)                             "This component is in use.\n\
                                                 It cannot be deleted."
set gPB(msg,do_you_want_to_proceed)             "Do you want to assume them as existing data elements and proceed?"


##--------------------
## Common Function
##
set gPB(msg,parent_win)                         "A transient window requires its parent window defined."
set gPB(msg,close_subwin)                       "You have to close all sub-windows to enable this tab."
set gPB(msg,block_exist)                        "An element of the selected\
                                                 Word exists in the Block Template."
set gPB(msg,num_gcode_1)                        "Number of M - Codes are restricted to"
set gPB(msg,num_gcode_2)                        "per block"
set gPB(msg,num_mcode_1)                        "Number of M - Codes are restricted to"
set gPB(msg,num_mcode_2)                        "per block"
set gPB(msg,empty_entry)                        "The Entry should not be empty."



set gPB(com,text_entry_trans,title,Label)       "Entry"

##---------------------------
## Common Navigation Buttons
##
set gPB(nav_button,no_license,Message)		$gPB(msg,no_license)

set gPB(nav_button,ok,Label)			"OK"
set gPB(nav_button,ok,Context)			"This button is only available on a sub-dialog.\
                                                 It allows you to save the changes and\
                                                 dismiss the dialog."
set gPB(nav_button,cancel,Label)		"Cancel"
set gPB(nav_button,cancel,Context)		"This button is available on a sub-dialog.\
                                                 It allows you to dismiss the dialog."
set gPB(nav_button,default,Label)		"Default"
set gPB(nav_button,default,Context)		"This button allows you to restore the parameters\
                                                 on the present dialog for a component to the condition\
                                                 when the Post in session was first created or opened.\
                                                 \n\
                                                 \nHowever, the name of the component in question,\
                                                 if present, will ONLY be restored to its initial state\
                                                 of the current visit to this component."
set gPB(nav_button,restore,Label)		"Restore"
set gPB(nav_button,restore,Context)		"This button allows you to restore the parameters on\
                                                 the present dialog to the initial settings of your\
                                                 current visit to this component."
set gPB(nav_button,apply,Label)			"Apply"
set gPB(nav_button,apply,Context)		"This button allows you to save the changes without\
                                                 dismissing the present dialog.  This will also\
                                                 re-establish the initial condition of the\
                                                 present dialog.\
                                                 \n\
                                                 \n(See Restore for the need for the initial condition)"
set gPB(nav_button,filter,Label)		"Filter"
set gPB(nav_button,filter,Context)		"This button will apply the directory filter and list\
                                                 the files that satisfy the condition."
set gPB(nav_button,yes,Label)			"Yes"
set gPB(nav_button,yes,Context)			"Yes"
set gPB(nav_button,no,Label)			"No"
set gPB(nav_button,no,Context)			"No"
set gPB(nav_button,help,Label)			"help"
set gPB(nav_button,help,Context)		"help"

set gPB(nav_button,open,Label)                  "Open"
set gPB(nav_button,open,Context)                "This button allows you to open the selected Post\
                                                 for editing."

set gPB(nav_button,save,Label)                  "Save"
set gPB(nav_button,save,Context)                "This button is available on the Save As dialog\
                                                 that allows you to save the Post in progress."

set gPB(nav_button,manage,Label)                "Manage"
set gPB(nav_button,manage,Context)              "This button allows you to manage the history of\
                                                 the recently visited Posts."

set gPB(nav_button,refresh,Label)               "Refresh"
set gPB(nav_button,refresh,Context)             "This button will refresh the list\
                                                 according to the existence of the objects."

set gPB(nav_button,cut,Label)                   "Cut"
set gPB(nav_button,cut,Context)                 "This button will cut the selected object\
                                                 from the list."

set gPB(nav_button,copy,Label)                  "Copy"
set gPB(nav_button,copy,Context)                "This button will copy the selected object."

set gPB(nav_button,paste,Label)                 "Paste"
set gPB(nav_button,paste,Context)               "This button will paste the object in the buffer\
                                                 back to the list."

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
                           
##------------
## New dialog
##
set gPB(new,title,Label)                        "Create New Post Processor"
set gPB(new,Status)                             "Enter the Name & Choose the Parameter for the New Post."

set gPB(new,name,Label)				"Post Name"
set gPB(new,name,Context)			"Name of the Post Processor to be created"

set gPB(new,desc,Label)				"Description"
set gPB(new,desc,Context)			"Description for the Post Processor to be created"

#Description for each selection
set gPB(new,mill,desc,Label)                    "This is a Milling Machine."
set gPB(new,lathe,desc,Label)                   "This is a Lathe Machine."
set gPB(new,wedm,desc,Label)                    "This is a Wire EDM Machine."

set gPB(new,wedm_2,desc,Label)                  "This is a 2-Axis Wire EDM Machine."
set gPB(new,wedm_4,desc,Label)                  "This is a 4-Axis Wire EDM Machine."
set gPB(new,lathe_2,desc,Label)                 "This is a 2-Axis Horizontal Lathe Machine."
set gPB(new,lathe_4,desc,Label)                 "This is a 4-Axis Dependent Lathe Machine."
set gPB(new,mill_3,desc,Label)                  "This is a 3-Axis Milling Machine."
set gPB(new,mill_4H,desc,Label)                 "This is a 4-Axis Milling Machine With\n\
                                                 Rotary Head."
set gPB(new,mill_4T,desc,Label)                 "This is a 4-Axis Milling Machine With\n\
                                                 Rotary Table."
set gPB(new,mill_5TT,desc,Label)                "This is a 5-Axis Milling Machine With\n\
                                                 Dual Rotary Tables."
set gPB(new,mill_5HH,desc,Label)                "This is a 5-Axis Milling Machine With\n\
                                                 Dual Rotary Heads."
set gPB(new,mill_5HT,desc,Label)                "This is a 5-Axis Milling Machine With\n\
                                                 Rotary Head and Table."
set gPB(new,punch,desc,Label)                   "This is a Punch Machine."

set gPB(new,post_unit,Label)			"Post Output Unit"

set gPB(new,inch,Label)                         "Inches"
set gPB(new,inch,Context)			"Post Processor Output Unit Inches"
set gPB(new,millimeter,Label)                   "Millimeters"
set gPB(new,millimeter,Context)			"Post Processor Output Unit Millimeters"

set gPB(new,machine,Label)			"Machine Tool"
set gPB(new,machine,Context)			"Machine tool type that the Post Processor to be\
						 created for."

set gPB(new,mill,Label)                         "Mill"
set gPB(new,mill,Context)                       "Milling Machine"
set gPB(new,lathe,Label)                        "Lathe"
set gPB(new,lathe,Context)                      "Lathe Machine"
set gPB(new,wire,Label)                         "Wire EDM"
set gPB(new,wire,Context)                       "Wire EDM Machine"
set gPB(new,punch,Label)                        "Punch"

set gPB(new,axis,Label)				"Machine Axes Selection"
set gPB(new,axis,Context)			"Number and type of machine axes"

#Axis Type
set gPB(new,mach_axis,Label)			"Machine Tool Axis"
set gPB(new,mach_axis,Context)			"Select the Machine Tool Axis"
set gPB(new,lathe_2,Label)                      "2-Axis"
set gPB(new,mill_3,Label)                       "3-Axis"
set gPB(new,mill_4T,Label)                      "4-Axis with Rotary Table"
set gPB(new,mill_4H,Label)                      "4-Axis with Rotary Head"
set gPB(new,lathe_4,Label)                      "4-Axis"
set gPB(new,mill_5HH,Label)                     "5-Axis with Dual Rotary Heads"
set gPB(new,mill_5TT,Label)                     "5-Axis with Dual Rotary Tables"
set gPB(new,mill_5HT,Label)                     "5-Axis with Rotary Head and Table"
set gPB(new,wedm_2,Label)                       "2-Axis"
set gPB(new,wedm_4,Label)                       "4-Axis"
set gPB(new,punch,Label)                        "Punch"

set gPB(new,control,Label)			"Controller"
set gPB(new,control,Context)			"Select the Post Controller."

#Controller Type
set gPB(new,generic,Label)                      "Generic"
set gPB(new,library,Label)                      "Library"
set gPB(new,user,Label)                         "User's"

set gPB(new,allen,Label)                        "Allen Bradley"
set gPB(new,bridge,Label)                       "Bridgeport"
set gPB(new,brown,Label)                        "Brown & Sharp"
set gPB(new,cincin,Label)                       "Cincinnatti Milacron"
set gPB(new,kearny,Label)                       "Kearny & Tracker"
set gPB(new,fanuc,Label)                        "Fanuc"
set gPB(new,ge,Label)                           "General Electric"
set gPB(new,gn,Label)                           "General Numerics"
set gPB(new,gidding,Label)                      "Gidding & Lewis"
set gPB(new,heiden,Label)                       "Heidenhain"
set gPB(new,mazak,Label)                        "Mazak"
set gPB(new,seimens,Label)                      "Seimens"

##-------------
## Open dialog
##
set gPB(open,title,Label)                       "Edit Post"
set gPB(open,Status)                            "Choose a pui file to open."
set gPB(open,file_type)                         "Post Builder Session Files"
set gPB(open,file_type_tcl)                     "Tcl Script Files"

##----------------
## Save As dialog
##
set gPB(save_as,title,Label)                    "Save As"
set gPB(save_as,name,Label)			"Post Name"
set gPB(save_as,name,Context)			"The name that the Post Processor to be saved as."
set gPB(save_as,Status)                         "Enter the new Post file name."
set gPB(save_as,file_type)                      $gPB(open,file_type)

##----------------
## Common Widgets
##
set gPB(common,entry,Label)			"Entry"
set gPB(common,entry,Context)			"You will specify new value in the entry field."

##-----------
## Note Book
##
set gPB(nbook,tab,Label)			"Notebook Tab"
set gPB(nbook,tab,Context)			"You may select a tab to go to the\
                                                 desired parameter page.\
                                                 \n\
                                                 \nThe parameters under a tab may be\
                                                 divided into groups. Each group\
                                                 of parameters can be accessed via\
                                                 another tab."

##------
## Tree
##
set gPB(tree,select,Label)			"Component Tree"
set gPB(tree,select,Context)			"You may select a component to edit\
                                                 its parameters."
set gPB(tree,create,Label)			"Create"
set gPB(tree,create,Context)			"Create a new component by copying the item selected."
set gPB(tree,cut,Label)				"Cut"
set gPB(tree,cut,Context)			"Cut a component."
set gPB(tree,paste,Label)			"Paste"
set gPB(tree,paste,Context)			"Paste a component."
set gPB(tree,rename,Label)			"Rename"


#++++++++++++++
# Machine Tool
#++++++++++++++
set gPB(machine,tab,Label)            	        "Machine Tool"
set gPB(machine,Status)                		"Specify Machine Kinematic Parameters."

set gPB(msg,no_display)                         "No Display For This Machine Tool Configuration."
set gPB(msg,no_4th_ctable)                      "4th axis C table not allowed."
set gPB(msg,no_4th_max_min)                     "4th axis maximum axis limit can not be equal to\
                                                minimum axis limit!"
set gPB(msg,no_4th_both_neg)                    "4th axis limits can not both be negative!"
set gPB(msg,no_4th_5th_plane)                   "Plane of the 4th axis can not be\
                                                the same as that of the 5th axis."
set gPB(msg,no_4thT_5thH)                       "4th axis table and 5th axis head not allowed."
set gPB(msg,no_5th_max_min)                     "5th axis maximum axis limit can not be equal to\
                                                minimum axis limit!"
set gPB(msg,no_5th_both_neg)                    "5th axis limits can not both be negative."


##---------
## Display
##
set gPB(machine,display,Label)                  "Display Machine Tool"
set gPB(machine,display,Context)                "This option Displays Machine Tool"
set gPB(machine,display_trans,title,Label)      "Machine Tool"


##---------------
## General parms
##
set gPB(machine,gen,Label)			"General Parameters"

set gPB(machine,gen,out_unit,Label)		"Post Output Unit :"
set gPB(machine,gen,out_unit,Context)		"Post Processing Output Unit"

set gPB(machine,gen,travel_limit,Label)		"Linear Axis Travel Limits"
set gPB(machine,gen,travel_limit,Context)	"Linear Axis Travel Limits"
set gPB(machine,gen,travel_limit,x,Label)	"X"
set gPB(machine,gen,travel_limit,x,Context)	"Specify Machine Travel limit along X - axis."
set gPB(machine,gen,travel_limit,y,Label)	"Y"
set gPB(machine,gen,travel_limit,y,Context)	"Specify Machine Travel limit along Y - axis."
set gPB(machine,gen,travel_limit,z,Label)	"Z"
set gPB(machine,gen,travel_limit,z,Context)	"Specify Machine Travel limit along Z - axis."

set gPB(machine,gen,home_pos,Label)		"Home Postion"
set gPB(machine,gen,home_pos,Context)		"Home Postion"
set gPB(machine,gen,home_pos,x,Label)		"X"
set gPB(machine,gen,home_pos,x,Context)		"Specify Machine Home X Position."
set gPB(machine,gen,home_pos,y,Label)		"Y"
set gPB(machine,gen,home_pos,y,Context)		"Specify Machine Home Y Position."
set gPB(machine,gen,home_pos,z,Label)		"Z"
set gPB(machine,gen,home_pos,z,Context)		"Specify Machine Home Z Position."

set gPB(machine,gen,step_size,Label)		"Linear Motion Resolution"
set gPB(machine,gen,step_size,min,Label)	"Minimum"
set gPB(machine,gen,step_size,min,Context)	"Minimum Resolution"

set gPB(machine,gen,traverse_feed,Label)	"Traversal Feed Rate"
set gPB(machine,gen,traverse_feed,max,Label)	"Maximum"
set gPB(machine,gen,traverse_feed,max,Context)	"Maximum Feed Rate"

set gPB(machine,gen,circle_record,Label)	"Output Circular Record"
set gPB(machine,gen,circle_record,yes,Label)	"Yes"
set gPB(machine,gen,circle_record,yes,Context)	"Output Circular Record."
set gPB(machine,gen,circle_record,no,Label)	"No"
set gPB(machine,gen,circle_record,no,Context)	"Output Linear Record."

# Lathe parameters
set gPB(machine,gen,turret,Label)		"Turret"
set gPB(machine,gen,turret,Context)		"Turret"
set gPB(machine,gen,turret,conf,Label)		"Configure"
set gPB(machine,gen,turret,conf,Context)	"This option is active, when Two Turrets is selected\
						 and it allows you to define the Turret parameters."
set gPB(machine,gen,turret,one,Label)		"One Turret"
set gPB(machine,gen,turret,one,Context)		"One Turret Lathe Machine"
set gPB(machine,gen,turret,two,Label)		"Two Turrets"
set gPB(machine,gen,turret,two,Context)		"Two Turrets Lathe Machine"

set gPB(machine,gen,turret,conf_trans,Label)    "Turret Configuration"
set gPB(machine,gen,turret,prim,Label)          "Primary Turret"
set gPB(machine,gen,turret,prim,Context)        "Select the Designation of Primary Turret."
set gPB(machine,gen,turret,sec,Label)           "Secondary Turret"
set gPB(machine,gen,turret,sec,Context)         "Select the Designation of Secondary Turret."
set gPB(machine,gen,turret,designation,Label)   "Designation"
set gPB(machine,gen,turret,xoff,Label)          "X Offset"
set gPB(machine,gen,turret,xoff,Context)        "Specify the X Offset."
set gPB(machine,gen,turret,zoff,Label)          "Z Offset"
set gPB(machine,gen,turret,zoff,Context)        "Specify the Z Offset."

set gPB(machine,gen,turret,front,Label)         "FRONT"
set gPB(machine,gen,turret,rear,Label)          "REAR"
set gPB(machine,gen,turret,right,Label)         "RIGHT"
set gPB(machine,gen,turret,left,Label)          "LEFT"
set gPB(machine,gen,turret,side,Label)          "SIDE"
set gPB(machine,gen,turret,saddle,Label)        "SADDLE"

set gPB(machine,gen,axis_multi,Label)		"Axis Multiplier"
set gPB(machine,gen,axis_multi,dia,Label)	"Diameter Programming"
set gPB(machine,gen,axis_multi,dia,Context)	"This switch allows you to enable/ disable\
						 Diameter Programming."
set gPB(machine,gen,axis_multi,x,Label)		"Mirror X Axis"
set gPB(machine,gen,axis_multi,x,Context)	"This switch allows you to enable/ disable\
						 Mirroring of X Axis."
set gPB(machine,gen,axis_multi,z,Label)		"Mirror Z Axis"
set gPB(machine,gen,axis_multi,z,Context)	"This switch allows you to enable/ disable\
						 Mirroring of  Z Axis."

set gPB(machine,gen,output,Label)		"Output Method"
set gPB(machine,gen,output,Context)		"Output Method"
set gPB(machine,gen,output,tool_tip,Label)	"Tool Tip"
set gPB(machine,gen,output,tool_tip,Context)	"Output with respect to Tool Tip"
set gPB(machine,gen,output,turret_ref,Label)	"Turret Reference"
set gPB(machine,gen,output,turret_ref,Context)	"Output with respect to Turret Reference"

set gPB(machine,gen,lathe_turret,msg) 		"Designation of the Primary Turrent can not be\
          					 the same as that of the Secondary Turret."
set gPB(machine,gen,turret_chg,msg)		"Change of this option may require addition or\
						 deletion of a G92 block in the Tool Change events."

##-----------------
## 4-th Axis parms
##
set gPB(machine,axis,fourth,Label)			"Fourth Axis"

##-----------------
## 5-th Axis parms
##
set gPB(machine,axis,fifth,Label)			"Fifth Axis"

set gPB(machine,axis,rotary,Label)			"Rotary Axis"

set gPB(machine,axis,offset,Label)                      "Machine Zero To Rotary Axis Center"
set gPB(machine,axis,offset,4,Label)                    "Machine Zero To Rotary Axis Center"
set gPB(machine,axis,offset,5,Label)                    "4th Axis Center To 5th Axis Center"
set gPB(machine,axis,offset,x,Label)			"X Offset"
set gPB(machine,axis,offset,x,Context)			"Specify Rotary Axis X Offset."
set gPB(machine,axis,offset,y,Label)			"Y Offset"
set gPB(machine,axis,offset,y,Context)			"Specify Rotary Axis Y Offset."
set gPB(machine,axis,offset,z,Label)			"Z Offset"
set gPB(machine,axis,offset,z,Context)			"Specify Rotary Axis Z Offset."

set gPB(machine,axis,rotation,Label)			"Axis Rotation"
set gPB(machine,axis,rotation,norm,Label)		"Normal"
set gPB(machine,axis,rotation,norm,Context)		"Set Axis Rotation Direction to Normal."
set gPB(machine,axis,rotation,rev,Label)		"Reversed"
set gPB(machine,axis,rotation,rev,Context)		"Set Axis Rotation Direction to Reversed."

set gPB(machine,axis,direction,Label)			"Axis Direction"
set gPB(machine,axis,direction,Context)			"Select the Axis Direction."

set gPB(machine,axis,con_motion,Label)			"Consecutive Rotary Motions"
set gPB(machine,axis,con_motion,combine,Label)		"Combined"
set gPB(machine,axis,con_motion,combine,Context)	"This switch allows you to enable/ disable\
							 the linearation. It will enable/ disable the\
							 Tolerance option."
set gPB(machine,axis,con_motion,tol,Label)		"Tolerance"
set gPB(machine,axis,con_motion,tol,Context)		"This option is active only when the\
							 Combined switch is active. Specify the\
							 Tolerance."

set gPB(machine,axis,violation,Label)			"Axis Limit Violation Handling"
set gPB(machine,axis,violation,warn,Label)		"Warning"
set gPB(machine,axis,violation,warn,Context)		"Output Warnings on Axis limit Violation."
set gPB(machine,axis,violation,ret,Label)		"Retract / Re-Engage"
set gPB(machine,axis,violation,ret,Context)		"Retract / Re-Engage on Axis limit Violation."

set gPB(machine,axis,limits,Label)			"Axis Limits (Deg)"
set gPB(machine,axis,limits,min,Label)			"Minimum"
set gPB(machine,axis,limits,min,Context)		"Specify Minimum Rotary Axis limit (Deg)."
set gPB(machine,axis,limits,max,Label)			"Maximum"
set gPB(machine,axis,limits,max,Context)		"Specify Maximum Rotary Axis limit (Deg)."

set gPB(machine,axis,rotary_res,Label)			"Rotary Motion Resolution (Deg)"
set gPB(machine,axis,rotary_res,Context)		"Specify Rotary Motion Resolution (Deg)."

set gPB(machine,axis,ang_offset,Label)			"Angular Offset  (Deg)"
set gPB(machine,axis,ang_offset,Context)		"Specify the Axis Angular Offset (Deg)."

set gPB(machine,axis,pivot,Label)			"Pivot Distance"
set gPB(machine,axis,pivot,Context)			"Specify Pivot Distance."

set gPB(machine,axis,max_feed,Label)			"Max. Feed Rate (Deg/Min)"
set gPB(machine,axis,max_feed,Context)			"Specify Maximum Feed Rate (Deg/Min)."

set gPB(machine,axis,plane,Label)			"Plane of Rotation"
set gPB(machine,axis,plane,Context)			"Select the Axis Plane of Rotation."

set gPB(machine,axis,leader,Label)			"Word Leader"
set gPB(machine,axis,leader,Context)			"Specify the Word Leader."

set gPB(machine,axis,config,Label)			"Configure"
set gPB(machine,axis,config,Context)			"This option allows you to define the\
							 4th & 5th Axis parameters."

set gPB(machine,axis,r_axis_conf_trans,Label)           "Rotary Axis Configuration"
set gPB(machine,axis,4th_axis,Label)                    "4th Axis"
set gPB(machine,axis,5th_axis,Label)                    "5th Axis"

set gPB(machine,axis,rotary_lintol,Label)               "Default Linearization Tolerance"

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
set gPB(progtpth,tab,Label)			"Program & Tool Path"

##---------
## Program
##
set gPB(prog,tab,Label)				"Program"
set gPB(prog,Status)				"Define the output of Events"

set gPB(prog,tree,Label)			"Program -- Sequence Tree"
set gPB(prog,tree,Context)			"A N/C program is divided into five segments.\
                                                 They are four(4) Sequences and the body of the tool path:\
                                                 \n\
                                                 \n * Program Start Sequence\
                                                 \n * Operation Start Sequence\
                                                 \n * Tool Path\
                                                 \n * Operation End Sequence\
                                                 \n * Program End Sequence\
                                                 \n\
                                                 \nEach Sequence consists of a series of Markers.\
                                                 A Marker indicates an event that can be programmed\
                                                 and may occur at a particular stage of a N/C\
                                                 program. You may attach each Marker with a\
                                                 particular arrangement of N/C codes to be output\
                                                 when the program is Post processed.\
                                                 \n\
                                                 \nTool path is made up of numerous Events. They are\
                                                 divided into three(3) groups:\
                                                 \n\
                                                 \n * Machine Control\
                                                 \n * Motions\
                                                 \n * Cycles\
                                                 \n"
set gPB(prog,tree,prog_strt,Label)		"Program Start Sequence"
set gPB(prog,tree,prog_end,Label)		"Program End Sequence"
set gPB(prog,tree,oper_strt,Label)		"Operation Start Sequence"
set gPB(prog,tree,oper_end,Label)		"Operation End Sequence"
set gPB(prog,tree,tool_path,Label)		"Tool Path"
set gPB(prog,tree,tool_path,mach_cnt,Label)	"Machine Control"
set gPB(prog,tree,tool_path,motion,Label)	"Motion"
set gPB(prog,tree,tool_path,cycle,Label)	"Canned Cycles"

set gPB(prog,add,Label)				"Sequence -- Add Block"
set gPB(prog,add,Context)			"You may add a new Block to a Sequence\
                                                 by pressing this button and dragging\
                                                 it to the desired Marker.\
                                                 Blocks can also be attached next to, above or below\
                                                 an existing Block."

set gPB(prog,trash,Label)			"Sequence -- Trash Can"
set gPB(prog,trash,Context)			"You may dispose any unwanted Blocks\
                                                 from the Sequence by dragging them to this\
                                                 trash can."

set gPB(prog,block,Label)			"Sequence -- Block"
set gPB(prog,block,Context)			"You may delete any unwanted Block\
                                                 in the Sequence by dragging it to the\
                                                 trash can.\
                                                 \n\
                                                 \nYou may also activate a pop-up\
                                                 menu by pressing the right mouse\
                                                 button.  Several services will be\
                                                 available on the menu :\
                                                 \n\
                                                 \n * Edit\
                                                 \n * Force Output\
                                                 \n * Cut\
                                                 \n * Copy As\
                                                 \n * Paste\
                                                 \n * Delete\
                                                 \n"

set gPB(prog,select,Label)			"Sequence -- Block Selection"
set gPB(prog,select,Context)			"You may select type of Block component that\
                                                 you want to add to the Sequence from this list.\
                                                 \n\Available component types are :\
                                                 \n\
                                                 \n * New Block\
                                                 \n * Existing N/C Block\
                                                 \n * Operator Message\
                                                 \n * Custom Command\
                                                 \n"

set gPB(prog,oper_temp,Label)			"Select A Sequence Template"
set gPB(prog,add_block,Label)			"Add Block"
set gPB(prog,seq_comb_nc,Label)			"Display Combined N/C Code Blocks"
set gPB(prog,seq_comb_nc,Context)		"This button allows you to display the contents of\
                                                 a Sequence in terms of Blocks or N/C codes.\
                                                 \n\
                                                 \nN/C codes will display the Words in proper order."

set gPB(prog,plus,Label)			"Program -- Collapse / Expnad switch"
set gPB(prog,plus,Context)			"This button allows you collapse or expand the\
                                                 branches of this component."

set gPB(prog,marker,Label)			"Sequence -- Marker"
set gPB(prog,marker,Context)			"The Markers of a Sequence indicate the possible\
                                                 events that can be programmed and may occur in\
                                                 sequence at a particular stage of a N/C program.\
                                                 \n\
                                                 \nYou may attach/ arrange Blocks to be output at\
                                                 each Marker."

set gPB(prog,event,Label)			"Program -- Event"
set gPB(prog,event,Context)			"You can edit each Event with a single left-mouse\
                                                 click."

set gPB(prog,nc_code,Label)			"Program -- N/C Code"
set gPB(prog,nc_code,Context)			"Text in this box display the representative N/C code\
                                                 to be output at this Marker or from this Event."
set gPB(prog,undo_popup,Label)                  "Undo"

## Sequence
##
set gPB(seq,combo,new,Label)                    "New Block"
set gPB(seq,combo,comment,Label)                "Operator Message"
set gPB(seq,combo,custom,Label)                 "Custom Command"

set gPB(seq,new_trans,title,Label)              "Block"
set gPB(seq,cus_trans,title,Label)              "Custom Command"
set gPB(seq,oper_trans,title,Label)             "Operator Message"

set gPB(seq,edit_popup,Label)                   "Edit"
set gPB(seq,force_popup,Label)                  "Force Output"
set gPB(seq,rename_popup,Label)                 "Rename"
set gPB(seq,rename_popup,Context)               "You can specify the name for this component."
set gPB(seq,cut_popup,Label)                    "Cut"
set gPB(seq,copy_popup,Label)                   "Copy As"
set gPB(seq,copy_popup,ref,Label)               "Referenced Block"
set gPB(seq,copy_popup,new,Label)               "New Block"
set gPB(seq,paste_popup,Label)                  "Paste"
set gPB(seq,paste_popup,before,Label)           "Before"
set gPB(seq,paste_popup,inline,Label)           "Inline"
set gPB(seq,paste_popup,after,Label)            "After"
set gPB(seq,del_popup,Label)                    "Delete"

set gPB(seq,force_trans,title,Label)            "Force Output Once"

##--------------
## Toolpath
##
set gPB(tool,event_trans,title,Label)           "Event"

set gPB(tool,event_seq,button,Label)            "Select An Event Template"
set gPB(tool,add_word,button,Label)             "Add Word"

set gPB(tool,format_trans,title,Label)          "FORMAT"

set gPB(tool,circ_trans,title,Label)            "Circular Move -- Plane Codes"
set gPB(tool,circ_trans,frame,Label)            " Plane G Codes "
set gPB(tool,circ_trans,xy,Label)               "XY Plane"
set gPB(tool,circ_trans,yz,Label)               "YZ Plane"
set gPB(tool,circ_trans,zx,Label)               "ZX Plane"

set gPB(tool,ijk_desc,arc_start,Label)          "Arc Start To Center"
set gPB(tool,ijk_desc,arc_center,Label)         "Arc Center To Start"
set gPB(tool,ijk_desc,u_arc_start,Label)        "Unsigned Arc Center To Start"
set gPB(tool,ijk_desc,absolute,Label)           "Absolute Arc Center"

set gPB(tool,spindle,range,type,Label)            "Spindle Range Type"
set gPB(tool,spindle,range,range_M,Label)         "Separate Range M Code (M41)"
set gPB(tool,spindle,range,with_spindle_M,Label)  "Range Number with Spindle M Code (M13)"
set gPB(tool,spindle,range,hi_lo_with_S,Label)    "High/Low Range with S Code (S+100)"
set gPB(tool,spindle,range,nonzero_range,msg)     "The number of Spindle Ranges must be\
                                                   greater than zero."

set gPB(tool,spindle_trans,title,Label)         "Spindle Range Code Table"
set gPB(tool,spindle_trans,range,Label)         "Range"
set gPB(tool,spindle_trans,code,Label)          "Code"
set gPB(tool,spindle_trans,min,Label)           "Minimum (RPM)"
set gPB(tool,spindle_trans,max,Label)           "Maximum (RPM)"

set gPB(tool,spindle_desc,sep,Label)            " Separate Range M Code (M41, M42 ...) "
set gPB(tool,spindle_desc,range,Label)          " Range Number with Spindle M Code (M13, M23 ...)"
set gPB(tool,spindle_desc,high,Label)           " High/Low Range with S Code (S+100/S-100)"
set gPB(tool,spindle_desc,odd,Label)            " Odd/Even Range with S Code"


set gPB(tool,tool_trans,title,Label)            "Tool Code Configuration"
set gPB(tool,tool_trans,frame,Label)            "Output"
set gPB(tool,tool_trans,lathe_radio1,Label)     "Tool Number Only"
set gPB(tool,tool_trans,lathe_radio2,Label)     "Tool Number And Length Offset Number"
set gPB(tool,tool_trans,lathe_radio3,Label)     "Turret Index and Tool Number"
set gPB(tool,tool_trans,lathe_radio4,Label)     "Turret Index Tool Number And Length Offset Number"

set gPB(tool,tool_trans,default_radio1,Label)   "Tool Number Only"
set gPB(tool,tool_trans,default_radio2,Label)   "Tool Number And Length Offset Number"
set gPB(tool,tool_trans,default_radio3,Label)   "Length Offset Number And Tool Number"

set gPB(tool,conf_desc,num,Label)               "Tool Number Only"
set gPB(tool,conf_desc,next_num,Label)          "Next Tool Number Only"
set gPB(tool,conf_desc,index_num,Label)         "Turret Index And Tool Number"
set gPB(tool,conf_desc,index_next_num,Label)    "Turret Index And Next Tool Number"
set gPB(tool,conf_desc,num_len,Label)           "Tool Number And Length Offset Number"
set gPB(tool,conf_desc,next_num_len,Label)      "Next Tool Number And Length Offset Number"
set gPB(tool,conf_desc,len_num,Label)           "Length Offset Number And Tool Number"
set gPB(tool,conf_desc,len_next_num,Label)      "Length Offset Number And Next Tool Number"
set gPB(tool,conf_desc,index_num_len,Label)     "Turret Index, Tool Number And Length Offset Number"
set gPB(tool,conf_desc,index_next_num_len,Label) "Turret Index, Next Tool Number And\
                                                  Length Offset Number"

set gPB(tool,oper_trans,title,Label)            "Operator Message"
set gPB(tool,cus_trans,title,Label)             "Custom Command"

##--------------------------
## Labels for Event dialogs
##
set gPB(event,feed,IPM_mode)			"IPM (Inch/Min) Mode"

##---------
## G Codes
##
set gPB(gcode,tab,Label) 			"G Codes"
set gPB(gcode,Status)				"Specify G-Codes"

##---------
## M Codes
##
set gPB(mcode,tab,Label) 			"M Codes"
set gPB(mcode,Status)				"Specify M-Codes"

##-----------------
## Words Summary
##
set gPB(addrsum,tab,Label)			"Word Summary"
set gPB(addrsum,Status)				"Specify parameters"

set gPB(addrsum,col_addr,Label)                 "Word"
set gPB(addrsum,col_addr,Context)               "You may edit a Word address by\
                                                 left-mouse clicking its name."
set gPB(addrsum,col_lead,Label)                 "Leader/Code"
set gPB(addrsum,col_data,Label)                 "Data Type"
set gPB(addrsum,col_plus,Label)                 "Plus (+)"
set gPB(addrsum,col_lzero,Label)                "Lead Zero"
set gPB(addrsum,col_int,Label)                  "Integer"
set gPB(addrsum,col_dec,Label)                  "Decimal (.)"
set gPB(addrsum,col_frac,Label)                 "Fraction"
set gPB(addrsum,col_tzero,Label)                "Trail Zero"
set gPB(addrsum,col_modal,Label)                "Modal ?"
set gPB(addrsum,col_min,Label)                  "Minimum"
set gPB(addrsum,col_max,Label)                  "Maximum"
set gPB(addrsum,col_trail,Label)                "Trailer"

set gPB(addrsum,radio_text,Label)               "Text"
set gPB(addrsum,radio_num,Label)                "Numeric"

set gPB(addrsum,addr_trans,title,Label)         "WORD"
set gPB(addrsum,other_trans,title,Label)        "Other Data Elements"

##-----------------
## Word Sequencing
##
set gPB(wseq,tab,Label)				"Word Sequencing"
set gPB(wseq,Status)				"Sequence the Words"

set gPB(wseq,word,Label)			"Master Word Sequence"
set gPB(wseq,word,Context)			"You may sequence the order of the Words\
                                                 to appear in the N/C output by dragging any Word\
                                                 to the desired position.\
                                                 \n\
                                                 \nWhen the Word being dragged is in focus\
                                                 (color of rectangle changes) with the other Word,\
                                                 the postions of these 2 Words will be swapped.\
                                                 If a Word is dragged within the\
                                                 focus of a separator between 2 Words, the Word will\
                                                 be inserted between these 2 Words.\
                                                 \n\
                                                 \nYou may suppress any Word from being output to\
                                                 the N/C file by toggling it off with a single\
                                                 left mouse click.\
                                                 \n\
                                                 \nYou can also manipulate these Words using\
                                                 the options from a pop-up menu :\
                                                 \n\
                                                 \n * New\
                                                 \n * Edit\
                                                 \n * Delete\
                                                 \n * Activate All\
                                                 \n"

set gPB(wseq,active_out,Label)                  " Output - Active     "
set gPB(wseq,suppressed_out,Label)              " Output - Suppressed "

set gPB(wseq,popup_new,Label)                   "New"
set gPB(wseq,popup_undo,Label)                  "Undo"
set gPB(wseq,popup_edit,Label)                  "Edit"
set gPB(wseq,popup_delete,Label)                "Delete"
set gPB(wseq,popup_all,Label)                   "Activate All"
set gPB(wseq,transient_win,Label)               "WORD"

##----------------
## Custom Command
##
set gPB(cust_cmd,tab,Label)			"Custom Command"
set gPB(cust_cmd,Status)			"Define Custom Commands"

set gPB(cust_cmd,name,Label)			"Command Name"
set gPB(cust_cmd,name,Context)			"The name that you enter here will be prefixed with\
                                                 PB_CMD_ to become the actual command name."
set gPB(cust_cmd,proc,Label)			"Procedure"
set gPB(cust_cmd,proc,Context)			"You will enter a Tcl script to define the\
                                                 functionality of this command.\
                                                 \n\
                                                 \n * Noted that the contents of the script\
                                                 will not be parsed by the Post Builder, but will\
                                                 be saved in the Tcl file. Therefore, you will be\
                                                 responsible for the syntatical correctness of the\
                                                 script."
set gPB(cust_cmd,name_msg)                      "Invalid Custom Command name.\n\
                                                 Specify a different name"
set gPB(cust_cmd,name_msg_1)                    "is reserved for special Custom Commands.\n\
                                                 Specify a different name"
set gPB(cust_cmd,import,Label)                  "Import"
set gPB(cust_cmd,import,Context)                "Import Custom Commands from a selected Tcl file\
                                                 to the Post in progress."
set gPB(cust_cmd,export,Label)                  "Export"
set gPB(cust_cmd,export,Context)                "Export Custom Commands from the Post in progress\
                                                 to a Tcl file."
set gPB(cust_cmd,import,tree,Label)             "Import Custom Commands"
set gPB(cust_cmd,import,tree,Context)           "This list contains the custom command procedures and\
                                                 other Tcl procedures found in the file that you\
                                                 have specified to import.  You can preview the\
                                                 contents of each procedure by selecting the item\
                                                 on the list with a single left-mouse click.\
                                                 Any procedure that already exists in the Post\
                                                 in progress is identified with an <exists>\
                                                 indicator.  A double left-mouse\
                                                 click on an item will toggle the check-box\
                                                 next to the item.  This allows you to select or\
                                                 deselect a procedure to import. By default,\
                                                 all the procedures are selected\
                                                 to be imported.  You may deselect any item to avoid\
                                                 overwritting an existing procedure."

set gPB(cust_cmd,export,tree,Label)             "Export Custom Commands"
set gPB(cust_cmd,export,tree,Context)           "This list contains the custom command procedures and\
                                                 other Tcl procedures that exist in the Post in\
                                                 progress.  You can preview the\
                                                 contents of each procedure by selecting the item\
                                                 on the list with a single left-mouse click.\
                                                 A double left-mouse click on an item will toggle\
                                                 the check-box next to the item.  This allows you\
                                                 to select only desired procedures to export."

set gPB(cust_cmd,error,title)                   "Custom Command Error"
set gPB(cust_cmd,error,msg)                     "Validation of a Custom Command can be disabled by\
                                                 toggling off the switches on the pull-down\
                                                 of the main menu item \"Options ->\
                                                 Validate Custom Commands\"."
set gPB(cust_cmd,select_all,Label)              "Select All"
set gPB(cust_cmd,select_all,Context)            "Click this button to select all the commands displayed\
                                                 to import or export."
set gPB(cust_cmd,deselect_all,Label)            "Deselect All"
set gPB(cust_cmd,deselect_all,Context)          "Click this button to deselect all the commands."

set gPB(cust_cmd,import,warning,title)          "Custom Command Import / Export Warning"
set gPB(cust_cmd,import,warning,msg)            "No item has been selected to import or export."


if 0 {
 set gPB(cust_cmd,cmd_not_found,msg)             "The following commands do not exist\
                                                  in the current scope of the Post in progress:"
 set gPB(cust_cmd,blk_not_found,msg)             "The following Blocks do not exist\
                                                  in the current scope of the Post in progress:"
 set gPB(cust_cmd,add_not_found,msg)             "The following Addresses do not exist\
                                                  in the current scope of the Post in progress:"
 set gPB(cust_cmd,fmt_not_found,msg)             "The following Formats do not exist\
                                                  in the current scope of the Post in progress:"
}

set gPB(cust_cmd,cmd,msg)                       "Commands (procs) : "
set gPB(cust_cmd,blk,msg)                       "Blocks : "
set gPB(cust_cmd,add,msg)                       "Addresses : "
set gPB(cust_cmd,fmt,msg)                       "Formats : "
set gPB(cust_cmd,referenced,msg)                "referenced in Custom Command"
set gPB(cust_cmd,not_defined,msg)               "have not been defined in the current scope of the Post in progress."
set gPB(cust_cmd,cannot_delete,msg)             "cannot be deleted."


##------------------
## Operator Message
##
set gPB(opr_msg,text,Label)			"Operator Message"
set gPB(opr_msg,text,Context)			"Text to be displayed as an operator message.\
                                                 The required special characters for the message\
                                                 start and the end will be automatically attached\
                                                 by the Post Builder for you. These characters are\
                                                 specified in the \"Other Data Elements\" parameter\
                                                 page under \"N/C Data Definitions\" tab."

set gPB(opr_msg,name,Label)			"Message Name"
set gPB(opr_msg,empty_operator)                 "An Operator Message should not be empty."


#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
set gPB(nc_data,tab,Label)			"N/C Data Definitions"

##-------
## BLOCK
##
set gPB(block,tab,Label)                        "BLOCK"
set gPB(block,Status)                           "Define the Block Templates"

set gPB(block,name,Label)                       "Block Name"
set gPB(block,name,Context)                     "Enter the Block Name"

set gPB(block,add,Label)			"Add Word"
set gPB(block,add,Context)			"You may add a new Word to a Block\
                                                 by pressing this button and dragging\
                                                 it to the Block displayed in the\
                                                 window below.  The type of Word that\
                                                 will be created is selected from the\
                                                 list box at the right side of this\
                                                 button."

set gPB(block,select,Label)			"BLOCK -- Word Selection"
set gPB(block,select,Context)			"You may select the type of Word that\
                                                 you desire to add to the Block from\
                                                 this list."

set gPB(block,trash,Label)			"BLOCK -- Trash Can"
set gPB(block,trash,Context)			"You may dispose any unwanted Words\
                                                 from a Block by dragging them to this\
                                                 trash can."

set gPB(block,word,Label)			"BLOCK -- Word"
set gPB(block,word,Context)			"You may delete any unwanted Word\
                                                 in this Block by dragging it to the\
                                                 trash can.\
                                                 \n\
                                                 \nYou may also activate a pop-up\
                                                 menu by pressing the right mouse\
                                                 button.  Several services will be\
                                                 available on the menu :\
                                                 \n\
                                                 \n * Edit\
                                                 \n * Change Element ->\
                                                 \n * Optional\
                                                 \n * No Word Seperator\
                                                 \n * Force Output\
                                                 \n * Delete\
                                                 \n"

set gPB(block,verify,Label)			"BLOCK -- Word Verification"
set gPB(block,verify,Context)			"This window displays the reprensentative\
                                                 N/C code to be output for a Word\
                                                 selected (depressed) in the Block\
                                                 shown in the window above."

set gPB(block,new_combo,Label)                  "New Address"
set gPB(block,text_combo,Label)                 "Text"
set gPB(block,oper_combo,Label)                 "Operator Message"
set gPB(block,comm_combo,Label)                 "Command"

set gPB(block,edit_popup,Label)                 "Edit"
set gPB(block,change_popup,Label)               "Change Element"
set gPB(block,user_popup,Label)                 "User Defined Expression"
set gPB(block,opt_popup,Label)                  "Optional"
set gPB(block,no_sep_popup,Label)               "No Word Separator"
set gPB(block,force_popup,Label)                "Force Output"
set gPB(block,delete_popup,Label)               "Delete"
set gPB(block,undo_popup,Label)                 "Undo"
set gPB(block,delete_all,Label)                 "Delete All Active Elements"

set gPB(block,cmd_title,Label)                  "Custom Commnad"
set gPB(block,oper_title,Label)                 "Operator Message"
set gPB(block,addr_title,Label)                 "WORD"

set gPB(block,new_trans,title,Label)            "WORD"

set gPB(block,new,word_desc,Label)              "New Address"
set gPB(block,oper,word_desc,Label)             "Operator Message"
set gPB(block,cmd,word_desc,Label)              "Custom Command"
set gPB(block,user,word_desc,Label)             "User Defined Expression"

set gPB(block,user,expr,Label)         		"Expression"

set gPB(block,msg,min_word)                     "A Block should contain at least one Word."

set gPB(block,name_msg)			        "Invalid Block name.\n\
                                                 Specify a different name."

##---------
## ADDRESS
##
set gPB(address,tab,Label)			"WORD"
set gPB(address,Status)  			"Define Words"

set gPB(address,name,Label)			"Word Name"
set gPB(address,name,Context)			"You may edit the name of a Word."

set gPB(address,verify,Label)			"WORD -- Verification"
set gPB(address,verify,Context)			"This window displays the reprensentative\
                                                 N/C code to be output for a Word."

set gPB(address,leader,Label)			"Leader"
set gPB(address,leader,Context)			"You may enter any number of characters as the Leader\
                                                 for a Word or select a character from a\
                                                 pop-up menu using the right mouse button."

set gPB(address,format,Label)			"Format"
set gPB(address,format,edit,Label)		"Edit"
set gPB(address,format,edit,Context)		"This button allows you to edit the Format used by\
                                                 a Word."
set gPB(address,format,new,Label)		"New"
set gPB(address,format,new,Context)		"This button allows you to create a new Format." 

set gPB(address,format,select,Label)		"WORD -- Select Format"
set gPB(address,format,select,Context)		"This button allows you to select different Format\
                                                 for a Word."

set gPB(address,trailer,Label)			"Trailer"
set gPB(address,trailer,Context)		"You may enter any number of characters as the\
                                                 Trailer for a Word or select a character from\
                                                 a pop-up menu using the right mouse button."

set gPB(address,modality,Label)			"Modal ?"
set gPB(address,modality,Context)		"This option allows you to set the modality for a Word."

set gPB(address,modal_drop,off,Label)           "Off"
set gPB(address,modal_drop,once,Label)          "Once"
set gPB(address,modal_drop,always,Label)        "Always"

set gPB(address,max,value,Label)		"Maximum"
set gPB(address,max,value,Context)		"You will specify a maximum value for a Word."

set gPB(address,value,text,Label)               "Value"
  
set gPB(address,trunc_drop,Label)               "Truncate Value"
set gPB(address,warn_drop,Label)                "Warn User"
set gPB(address,abort_drop,Label)               "Abort Process"

set gPB(address,max,error_handle,Label)		"Violation Handling"
set gPB(address,max,error_handle,Context)	"This button allows you to specify the method for\
                                                 handling the violation to the maximum value:\
                                                 \n\
                                                 \n * Truncate Value\
                                                 \n * Warn User\
                                                 \n * Abort Process\
                                                 \n"

set gPB(address,min,value,Label)		"Minimum"
set gPB(address,min,value,Context)		"You will specify a minimum value for a Word."

set gPB(address,min,error_handle,Label)		"Violation Handling"
set gPB(address,min,error_handle,Context)	"This button allows you to specify the method for\
                                                 handling the violation to the minimum value:\
                                                 \n\
                                                 \n * Truncate Value\
                                                 \n * Warn User\
                                                 \n * Abort Process\
                                                 \n"

set gPB(address,format_trans,title,Label)       "FORMAT "
set gPB(address,none_popup,Label)               "None"

set gPB(address,exp,Label)			"Expression"
set gPB(address,exp,Context)			"You may specify an expression or a constant to\
                                                 a Block."
set gPB(address,exp,msg)			"Expression for a Block element should not be blank."
set gPB(address,exp,space_only)			"Expression for a Block element using numeric Format\
                                                 can not contain only spaces."

set gPB(address,exp,spec_char)			"\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@\
                                                 \[  \\  \]  \^  \`  \{  \|  \}  \~"

set gPB(address,exp,spec_char_msg)		" Special character(s)\
                                                 \n\
                                                 $gPB(address,exp,spec_char)\
                                                 \n\
                                                 can not be used in an expression for numeric data."

set gPB(address,name_msg)			"Invalid Word Name.\n\
                                                 Specify a different name."
set gPB(address,rapid1,desc)                    "Rapid Position along Longitudinal Axis"
set gPB(address,rapid2,desc)                    "Rapid Position along Transversal Axis"
set gPB(address,rapid3,desc)                    "Rapid Position along Spindle Axis"

##--------
## FORMAT
##
set gPB(format,tab,Label)			"FORMAT"
set gPB(format,Status)   			"Define the Formats"

set gPB(format,verify,Label)			"FORMAT -- Verification"
set gPB(format,verify,Context)			"This window displays the Reprensentative\
                                                 N/C code to be output using the Format specified."

set gPB(format,name,Label)			"Format Name"
set gPB(format,name,Context)			"You may edit the name of a Format."

set gPB(format,data,type,Label)			"Data Type"
set gPB(format,data,type,Context)		"You will specify the Data Type for a Format."
set gPB(format,data,num,Label)			"Numeric"
set gPB(format,data,num,Context)		"This option defines the data type of a Format as\
                                                 a Numeric."
set gPB(format,data,num,integer,Label)		"FORMAT -- Digits of Integer"
set gPB(format,data,num,integer,Context)	"This option specifies the number of digits of an\
						 integer or the integer part of a real number."
set gPB(format,data,num,fraction,Label)		"FORMAT -- Digits of Fraction"
set gPB(format,data,num,fraction,Context)	"This option specifies the number of digits for the\
                                                 fraction part of a real number."
set gPB(format,data,num,decimal,Label)		"Output Decimal Point (.)"
set gPB(format,data,num,decimal,Context)	"This option allows you to output decimal points\
                                                 in N/C code."
set gPB(format,data,num,lead,Label)		"Output Leading Zeros"
set gPB(format,data,num,lead,Context)		"This option enables leading zero padding to the\
                                                 numbers in N/C code."
set gPB(format,data,num,trail,Label)		"Output Trailng Zeros"
set gPB(format,data,num,trail,Context)		"This option enables trailing zero padding to the\
                                                 real numbers in N/C code."
set gPB(format,data,text,Label)			"Text"
set gPB(format,data,text,Context)		"This option defines the data type of a Format as\
                                                 a text string."
set gPB(format,data,plus,Label)			"Output Leading Plus Sign (+)"
set gPB(format,data,plus,Context)		"This option allows you to output plus sings in\
                                                 N/C code."
set gPB(format,zero_msg)			"Cannot make a copy of Zero format"
set gPB(format,zero_cut_msg)			"Cannot delete a Zero format"

set gPB(format,data,dec_zero,msg)               "At least one of the Decimal Point, Leading Zeros or\
                                                 Trailing Zeros options should be checked."

set gPB(format,data,no_digit,msg)               "Number of digits for integer and fraction\
                                                 should not be both zero."

set gPB(format,name_msg)			"Invalid Format Name.\n\
                                                 Specify a different name."
set gPB(format,error,title)                     "Format Error"
set gPB(format,error,msg)                       "This Format has been used in Addresses"

##---------------------
## Other Data Elements
##
set gPB(other,tab,Label)			"Other Data Elements"
set gPB(other,Status)   			"Specify the Parameters"

set gPB(other,seq_num,Label)			"Sequence Number"
set gPB(other,seq_num,Context)			"This switch allows you to enable/disable the\
                                                 output of sequence numbers in the N/C code."
set gPB(other,seq_num,start,Label)		"Sequence Number Start"
set gPB(other,seq_num,start,Context)		"Specify the start of the sequence numbers."
set gPB(other,seq_num,inc,Label)		"Sequence Number Increment"
set gPB(other,seq_num,inc,Context)		"Specify the increment of the sequence numbers."
set gPB(other,seq_num,freq,Label)		"Sequence Number Frequence"
set gPB(other,seq_num,freq,Context)		"Specify the frequence of the sequence numbers appear\
                                                 in the N/C code."

set gPB(other,chars,Label)			"Special Characters"
set gPB(other,chars,word_sep,Label)		"Word Separator"
set gPB(other,chars,word_sep,Context)		"Specify a character to be used as the word separator."
set gPB(other,chars,decimal_pt,Label)		"Decimal Point"
set gPB(other,chars,decimal_pt,Context)		"Specify a character to be used as the decimal point."
set gPB(other,chars,end_of_block,Label)		"End of Block"
set gPB(other,chars,end_of_block,Context)	"Specify a character to be used as the end-of-block."
set gPB(other,chars,comment_start,Label)	"Message Start"
set gPB(other,chars,comment_start,Context)	"Specify characters to be used as the start of an\
                                                 operator message line."
set gPB(other,chars,comment_end,Label)		"Message End"
set gPB(other,chars,comment_end,Context)	"Specify characters to be used as the end of an\
                                                 operator message line."

set gPB(other,opskip,Label)                     "OPSKIP"
set gPB(other,opskip,leader,Label)              "Line Leader"
set gPB(other,opskip,leader,Context)            "OPSKIP Line Leader"

set gPB(other,gm_codes,Label)			"G & M Codes Output Per Block"
set gPB(other,g_codes,Label)			"Number of G Codes per Block"
set gPB(other,g_codes,Context)			"This switch allows you to enable/disable the\
                                                 control of number of G codes per N/C output block."
set gPB(other,g_codes,num,Label)		"Number of G Codes"
set gPB(other,g_codes,num,Context)		"Specify the number of G codes per N/C output block."
set gPB(other,m_codes,Label)			"Number of M Codes"
set gPB(other,m_codes,Context)			"This switch allows you to enable/disable the\
                                                 control of number of M codes per N/C output block."
set gPB(other,m_codes,num,Label)		"Number of M Codes per Block"
set gPB(other,m_codes,num,Context)		"Specify the number of M codes per N/C output block."

set gPB(other,opt_none,Label)                   "None"
set gPB(other,opt_space,Label)                  "Space"
set gPB(other,opt_dec,Label)                    "Decimal (.)"
set gPB(other,opt_comma,Label)                  "Comma (,)"
set gPB(other,opt_semi,Label)                   "Semicolon (;)"
set gPB(other,opt_colon,Label)                  "Colon (:)"
set gPB(other,opt_text,Label)                   "Text"
set gPB(other,opt_left,Label)                   "Left Parenthesis"
set gPB(other,opt_right,Label)                  "Right Parenthesis"
set gPB(other,opt_pound,Label)                  "Pound Sign (\#)"
set gPB(other,opt_aster,Label)                  "Asterisk (*)"
set gPB(other,opt_slash,Label)                  "Slash (/)"
set gPB(other,opt_new,Label)                    "New Line (\\012)"

#++++++++++++++
# Listing File
#++++++++++++++
set gPB(listing,tab,Label)	                "Listing File & Output Control"
set gPB(listing,Status)                         "Specify Listing File Parameters"

set gPB(listing,gen,Label)			"Generate Listing File"
set gPB(listing,gen,Context)			"This switch allows you to enable/disable the\
						 output of Listing File."

set gPB(listing,Label)				"Listing File Elements"
set gPB(listing,parms,Label)			"Components"

set gPB(listing,parms,x,Label)			"X-Coordinate"
set gPB(listing,parms,x,Context)		"This switch allows you to enable/disable the\
						 output of x-coordinate to Listing File."

set gPB(listing,parms,y,Label)			"Y-Coordinate"
set gPB(listing,parms,y,Context)		"This switch allows you to enable/disable the\
						 output of y-coordinate to Listing File."

set gPB(listing,parms,z,Label)			"Z-Coordinate"
set gPB(listing,parms,z,Context)		"This switch allows you to enable/disable the\
						 output of z-coordinate to Listing File."

set gPB(listing,parms,4,Label)			"4th Axis Angle"
set gPB(listing,parms,4,Context)		"This switch allows you to enable/disable the\
						 output of 4th axis angle to Listing File."

set gPB(listing,parms,5,Label)			"5th Axis Angle"
set gPB(listing,parms,5,Context)		"This switch allows you to enable/disable the\
						 output of 5th axis angle to Listing File."

set gPB(listing,parms,feed,Label)		"Feed"
set gPB(listing,parms,feed,Context)		"This switch allows you to enable/disable the\
						 output of feedrate to Listing File."

set gPB(listing,parms,speed,Label)		"Speed"
set gPB(listing,parms,speed,Context)		"This switch allows you to enable/disable the\
						 output of spindle speed to Listing File."

set gPB(listing,extension,Label)		"Listing File Extension"
set gPB(listing,extension,Context)		"Specify the Listing File extension"

set gPB(listing,nc_file,Label)			"N/C Output File Extension"
set gPB(listing,nc_file,Context)		"Specify N/C output file extension"

set gPB(listing,header,Label)			"Program Header"
set gPB(listing,header,oper_list,Label)		"Operation List"
set gPB(listing,header,tool_list,Label)		"Tool List"

set gPB(listing,footer,Label)			"Program Footer"
set gPB(listing,footer,cut_time,Label)		"Total Machining Time"

set gPB(listing,format,Label)			"Page Format"
set gPB(listing,format,print_header,Label)	"Print Page Header"
set gPB(listing,format,print_header,Context)	"This switch allows you to enable/disable the\
						 output of page header to Listing File."

set gPB(listing,format,length,Label)		"Page Length (Rows)"
set gPB(listing,format,length,Context)		"Specify number of rows per page for the Listing File."
set gPB(listing,format,width,Label)		"Page Width (Columns)"
set gPB(listing,format,width,Context)		"Specify number of columns per page for the Listing File."

set gPB(listing,output,Label)			"Other Output Control Elements"

set gPB(listing,output,warning,Label)		"Output Warning Messages"
set gPB(listing,output,warning,Context)		"This switch allows you to enable/disable the\
						 output of warning messages during post processing."

set gPB(listing,output,review,Label)		"Activate Review Tool"
set gPB(listing,output,review,Context)		"This switch allows you to activate the\
						 Review Tool during post processing."

set gPB(listing,output,group,Label)             "Generate Group Output"
set gPB(listing,output,group,Context)           "This switch allows you to enable/disable the control\
                                                 of Group Output during post processing."

set gPB(listing,output,verbose,Label)           "Display Verbose Error Messages"
set gPB(listing,output,verbose,Context)         "This switch allows you to display the extended\
                                                 descriptions for the error conditions. It will\
                                                 somewhat slow down the Post Processing speed."

set gPB(listing,oper_info,Label)		"Operation Information"
set gPB(listing,oper_info,parms,Label)		"Operation Parameters"
set gPB(listing,oper_info,tool,Label)		"Tool Parameters"
set gPB(listing,oper_info,cut_time,,Label)	"Machining Time"


#<09-19-00 gsl>
set gPB(listing,user_tcl,frame,Label)           "User Tcl Source"
set gPB(listing,user_tcl,check,Label)           "Source User's Tcl File"
set gPB(listing,user_tcl,check,Context)         "This switch allows you to source your own Tcl file"
set gPB(listing,user_tcl,name,Label)            "Name"
set gPB(listing,user_tcl,name,Context)          "Specify the name of a Tcl file that you want\
                                                 to source for this Post"

#++++++++++++++++
# Output Preview
#++++++++++++++++
set gPB(output,tab,Label)			"Files Preview"
set gPB(output,new_code,Label)                  "New Code"
set gPB(output,old_code,Label)                  "Old Code"

##---------------------
## Event Handler
##
set gPB(event_handler,tab,Label) 		"Event Handler"
set gPB(event_handler,Status) 			"Choose the Event to view the procedure"

##---------------------
## Definition
##
set gPB(definition,tab,Label)			"Definitions"
set gPB(definition,Status) 			"Choose the item to view the contents"

#++++++++++++++
# Post Advisor
#++++++++++++++
set gPB(advisor,tab,Label)			"Post Advisor"
set gPB(advisor,Status)                         "Post Advisor"

set gPB(definition,word_txt,Label)              "WORD_SEPARATOR"
set gPB(definition,end_txt,Label)               "END_OF_BLOCK"
set gPB(definition,seq_txt,Label)               "SEQUENCE_NUM"
set gPB(definition,format_txt,Label)            "FORMAT"
set gPB(definition,addr_txt,Label)              "WORD"
set gPB(definition,block_txt,Label)             "BLOCK"
set gPB(definition,post_txt,Label)              "Post BLOCK"
set gPB(definition,oper_txt,Label)              "Operator Message"

#+++++++++++++
# Balloon
#+++++++++++++
set gPB(msg,odd)                                "Odd count of opt. arguments"
set gPB(msg,wrong_list_1)                       "Unknown option(s)"
set gPB(msg,wrong_list_2)                       ". Must be one of:"

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Tool Change
set gPB(event,tool_change,name)			"Tool Change"
set gPB(event,tool_change,m_code)		"M Code"
set gPB(event,tool_change,m_code,tl_chng)	"Tool Change"
set gPB(event,tool_change,t_code)		"T Code"
set gPB(event,tool_change,t_code,conf)		"Configure"
set gPB(event,tool_change,tool_num)		"Tool Number"
set gPB(event,tool_change,tool_num,min)		"Minimum"
set gPB(event,tool_change,tool_num,max)		"Maximum"
set gPB(event,tool_change,time)			"Time (Sec)"
set gPB(event,tool_change,time,tl_chng)		"Tool Change"
set gPB(event,tool_change,retract)		"Retract"
set gPB(event,tool_change,retract_z)		"Retract To Z of"

### Length Compensation
set gPB(event,length_compn,g_code)		"G Code"
set gPB(event,length_compn,g_code,len_adj)	"Tool Length Adjust"
set gPB(event,length_compn,t_code)		"T Code"
set gPB(event,length_compn,t_code,conf)		"Configure"
set gPB(event,length_compn,len_off)		"Length Offset Register"
set gPB(event,length_compn,len_off,min)		"Minimum"
set gPB(event,length_compn,len_off,max)		"Maximum"

### Set Modes
set gPB(event,set_modes,out_mode)		"Output Mode"
set gPB(event,set_modes,g_code)			"G Code"
set gPB(event,set_modes,g_code,absolute)	"Absolute"
set gPB(event,set_modes,g_code,incremental)	"Incremental"
set gPB(event,set_modes,rotary_axis)		"Rotary Axis Can Be Incremental"

### Spindle RPM
set gPB(event,spindle_rpm,dir_m_code)                   "Spindle Direction M Codes"
set gPB(event,spindle_rpm,dir_m_code,cw)                "Clockwise (CW)"
set gPB(event,spindle_rpm,dir_m_code,ccw)               "Counter Clockwise (CCW)"
set gPB(event,spindle_rpm,range_control)                "Spindle Range Control"
set gPB(event,spindle_rpm,range_control,dwell_time)     "Range Change Dwell Time (Sec)"
set gPB(event,spindle_rpm,range_control,range_code)     "Specify Range Code"

### Spindle Off
set gPB(event,spindle_off,dir_m_code)			"Spindle Direction M Code"
set gPB(event,spindle_off,dir_m_code,off)		"Off"

### Coolant On
set gPB(event,coolant_on,m_code)			"M Code"
set gPB(event,coolant_on,m_code,on)			"ON"
set gPB(event,coolant_on,m_code,flood)	        	"Flood"
set gPB(event,coolant_on,m_code,mist)			"Mist"
set gPB(event,coolant_on,m_code,tap)			"Tap"

### Coolant Off
set gPB(event,coolant_off,m_code)			"M Code"
set gPB(event,coolant_off,m_code,off)			"Off"

### Inch Metric Mode
set gPB(event,inch_metric_mode,g_code)	        	"G Code"
set gPB(event,inch_metric_mode,g_code,english)  	"English (Inch)"
set gPB(event,inch_metric_mode,g_code,metric)		"Metric (Millimeter)"

### Feedrates
set gPB(event,feedrates,ipm_mode)                       "IPM Mode"
set gPB(event,feedrates,ipr_mode)                       "IPR Mode"
set gPB(event,feedrates,dpm_mode)                       "DPM Mode"
set gPB(event,feedrates,mmpm_mode)                      "MMPM Mode"
set gPB(event,feedrates,mmpr_mode)                      "MMPR Mode"
set gPB(event,feedrates,frn_mode)                       "FRN Mode"
set gPB(event,feedrates,g_code)                         "G Code"
set gPB(event,feedrates,format)                         "Format"
set gPB(event,feedrates,max)                            "Maximum"
set gPB(event,feedrates,min)                            "Minimum"
set gPB(event,feedrates,mode,label)                     "Feedrate Modes"
set gPB(event,feedrates,mode,lin)                       "Linear Only"
set gPB(event,feedrates,mode,rot)                       "Rotary Only"
set gPB(event,feedrates,mode,lin_rot)                   "Linear and Rotary"
set gPB(event,feedrates,mode,rap_lin)                   "Rapid Linear Only"
set gPB(event,feedrates,mode,rap_rot)                   "Rapid Rotary Only"
set gPB(event,feedrates,mode,rap_lin_rot)               "Rapid Linear and Rotary"

### Cycle
set gPB(event,cycle,customize,Label)                    "Customize"
set gPB(event,cycle,customize,Context)                  "This switch allows you to\
                                                         customize a cycle.\
                                                         \n\nBy default, the basic construct of\
                                                         each cycle is defined by the settings\
                                                         of the Common Parameters. Those common\
                                                         elements in each cycle are restricted to\
                                                         being further manipulated.\
                                                         \n\nToggling on this switch allows you to\
                                                         gain complete control over the configuration\
                                                         of a cycle.  Changes made to the Common\
                                                         Parameters will no longer affect any\
                                                         customized cycle."
set gPB(event,cycle,start,Label)                        "Cycle Start"
set gPB(event,cycle,start,Context)                      "This option can be switched on for the\
                                                         machine-tools that execute cycles\
                                                         using a cycle start block (G79...)\
                                                         after the cycle has been defined (G81...)."

