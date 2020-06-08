##############################################################################
#				UI_PB_RESOURCE.TCL
##############################################################################
# Description                                                                #
#    This file defines resources for the widgets used in Post Builder.       #
#                                                                            #
# Revisions                                                                  #
# ---------                                                                  #
#   Date        Who       Reason                                             #
# 05-Oct-1999   gsl       Initial                                            #
# 17-Nov-1999   gsl       Submitted for phase-22.                            #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

global gPB env

#===============
# Main Menu Bar
#===============
## File
set gPB(main,file,Label)			"File"

set gPB(main,file,Balloon)			"\ New, Open, Save,\n\
						 Save\ As, Close and Exit"

set gPB(main,file,Balloon1)			"\ New, Open, Save,\n\
						 Import MDFA,\n\
						 Save\ As, Close and Exit"

set gPB(main,file,Context)			"File Utilities"

set gPB(main,file,new,Label)			"New ..."
set gPB(main,file,new,Balloon)			"Create a new Post"

set gPB(main,file,open,Label)			"Open ..."
set gPB(main,file,open,Balloon)			"Edit an existing Post"

set gPB(main,file,mdfa,Label)			"Import MDFA ..."
set gPB(main,file,mdfa,Balloon)			"Create a new Post from MDFA"

set gPB(main,file,save,Label)			"Save"
set gPB(main,file,save,Balloon)			"Save the Post in progress"

set gPB(main,file,save_as,Label)		"Save As ..."
set gPB(main,file,save_as,Balloon)		"Save the Post to a new name"

set gPB(main,file,close,Label)			"Close"
set gPB(main,file,close,Balloon)		"Close the Post in progress"

set gPB(main,file,exit,Label)			"Exit"
set gPB(main,file,exit,Balloon)			"Terminate Post Builder"

## Options
set gPB(main,options,Label)			"Options"
set gPB(main,options,Balloon)			"\ Properties, Post\ Advisor"
set gPB(main,options,Context)			"Options"

set gPB(main,options,properties,Label)		"Properties"
set gPB(main,options,properties,Balloon)	"Properties"

set gPB(main,options,advisor,Label)		"Post Advisor"
set gPB(main,options,advisor,Balloon)		"Post Advisor"

## Help
set gPB(main,help,Label)			"Help"
set gPB(main,help,Balloon)			"\ Balloon\ Tip,\n\
						 Context\ Info,\n\
						 What\ To\ Do,\n\
						 Help\ on\ Dialog,\n\
						 User's\ Manual,\n\
						 About\ Post\ Builder,\n\
						 Acknowledgements"

set gPB(main,help,Context)			"Help"

set gPB(main,help,bal,Label)		"Balloon Tip"
set gPB(main,help,bal,Balloon)		"Balloon Tip on Icons"

set gPB(main,help,chelp,Label)			"Context Help"
set gPB(main,help,chelp,Balloon)		"Context Sensitive Help on Dialog Items"

set gPB(main,help,what,Label)			"What To Do ?"
set gPB(main,help,what,Balloon)			"What You Can Do Here?"

set gPB(main,help,dialog,Label)			"Help On Dialog"
set gPB(main,help,dialog,Balloon)		"Help On This Dialog"

set gPB(main,help,manual,Label)			"User's Manual"
set gPB(main,help,manual,Balloon)		"User's Help Manual"

set gPB(main,help,about,Label)			"About Post Builder"
set gPB(main,help,about,Balloon)		"About Post Builder"

set gPB(main,help,acknow,Label)			"Acknoledgements"
set gPB(main,help,acknow,Balloon)		"Acknoledgements & Credits"

#==========
# Tool Bar
#==========
set gPB(tool,new,Label)				"New"
set gPB(tool,new,Context)			"New"

set gPB(tool,open,Label)			"Open"
set gPB(tool,open,Context)			"Open"

set gPB(tool,save,Label)			"Save"
set gPB(tool,save,Context)			"Save"

set gPB(tool,bal,Label)				"Balloon Tip"
set gPB(tool,bal,Context)			"Balloon Tip"

set gPB(tool,chelp,Label)			"Context Info"
set gPB(tool,chelp,Context)			"Context Info"

set gPB(tool,what,Label)			"What To Do?"
set gPB(tool,what,Context)			"What To Do?"

set gPB(tool,dialog,Label)			"Help On Dialog"
set gPB(tool,dialog,Context)			"Help On Dialog"

set gPB(tool,manual,Label)			"User's Manual"
set gPB(tool,manual,Context)			"User's Manual"

#=============
# Main Window
#=============
## Navigation Buttons
set gPB(nav_button,cancel,Label)		"Cancel"
set gPB(nav_button,cancel,Context)		"Cancel"
set gPB(nav_button,default,Label)		"Default"
set gPB(nav_button,default,Context)		"Default"
set gPB(nav_button,restore,Label)		"Restore"
set gPB(nav_button,restore,Context)		"Restore"
set gPB(nav_button,apply,Label)			"Apply"
set gPB(nav_button,apply,Context)			"Apply"
set gPB(nav_button,ok,Label)			"OK"
set gPB(nav_button,ok,Context)			"OK"
set gPB(nav_button,filter,Label)		"Filter"
set gPB(nav_button,filter,Context)		"Filter"
set gPB(nav_button,yes,Label)			"Yes"
set gPB(nav_button,yes,Context)			"Yes"
set gPB(nav_button,no,Label)			"No"
set gPB(nav_button,no,Context)			"No"

set gPB(nav_button,no_license,Message)		"No License To Perform This Function!"

## Machine Tool
set gPB(machine,tab,Label)			"Machine Tool"

### Display
set gPB(machine,display,Label)			"Display Machine Tool"
set gPB(machine,display,Context)		"Display Machine Tool"

### General parms
set gPB(machine,gen,Label)			"General & Linear Parameters"
set gPB(machine,gen,out_unit,Label)		"Post Output Unit :"
set gPB(machine,gen,kin_unit,Label)		"Kinematic Data Unit"
set gPB(machine,gen,travel_limit,Label)		"Linear Axis Travel Limits"
set gPB(machine,gen,travel_limit,x,Label)	"X"
set gPB(machine,gen,travel_limit,y,Label)	"Y"
set gPB(machine,gen,travel_limit,z,Label)	"Z"
set gPB(machine,gen,home_pos,Label)		"Home Postion"
set gPB(machine,gen,home_pos,x,Label)		"X"
set gPB(machine,gen,home_pos,y,Label)		"Y"
set gPB(machine,gen,home_pos,z,Label)		"Z"
set gPB(machine,gen,step_size,Label)		"Linear Motion Step Size"
set gPB(machine,gen,step_size,min,Label)	"Minimum"
set gPB(machine,gen,traverse_feed,Label)	"Traversal Feed Rate"
set gPB(machine,gen,traverse_feed,max,Label)	"Maximum"

### 4-th Axis parms
set gPB(machine,fourth,Label)			"Fourth Axis Parameters"

### 5-th Axis parms
set gPB(machine,fifth,Label)			"Fifth Axis Parameters"



## Program & Tool Path
set gPB(program,tab,Label)			"Program & Tool Path"


## N/C Data Definitions
set gPB(nc_data,tab,Label)			"N/C Data Definitions"


## Listing File
set gPB(listing,tab,Label)			"Listing File"


## Output Preview
set gPB(output,tab,Label)			"Files Preview"


## Post Advisor
set gPB(advisor,tab,Label)			"Post Advisor"


