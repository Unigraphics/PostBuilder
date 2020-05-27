##############################################################################
#               Strings, labels and messages definition
##############################################################################

#######################  GUIDELINE FOR TRANSLATION  ##########################
if 0 {
#
# Tcl syntax is used in this file. The follwing key elements should be observed:
# 
# - A line started with a '#' sign defines comment; no translation is needed.
# - A string is defined by a sequence of alpha-numeric or symbols between a pair of double quotes ("...").
#   Ex.
#       ::msgcat::mcset pb_msg_english "MC(main,title,Unigraphics)"  "Unigraphics"
#       -----------------------------------------------------------  -------------
#                              - Variable -                            - String -
#
#       ==> "pb_msg_english" must be identical to the name of a particular language file.
#
#
# - A '\' character at the end of a line indicates the definition of a string
#   is continued into subsequent line(s).
# - A '\n' (new-line) token is used to display message in separated (list of) lines.
# - Any special character reserved for Tcl language (see definition for MC(address,exp,spec_char) below)
#   to be displayed in a message should be prefixed with a '\' (escape) character.
#   Ex.
#       '\ ' to preserve blanks within a string
#       '\$' to display a dollar sign in a label or message
#       '\"' to display a double quote sign in a label or message
#
# - A pair of '[]' (square brackets) is used to execute a Tcl command.
#
# - [::msgcat::mc ...] is occassionally used to transfer one string to the other.
#
#
# The following types of tokens (case sensitive) do not need to be translated:
# - Any single character prefixed by a '\' (as mentioned above)
# - Tokens (including single character) in all UPPER case
#   such as 'M', 'G', 'F', 'UGII' and 'EDITOR', except
#   'BLOCK', "WORD", 'FORMAT' and 'Wire EDM'.
# - Any contiguous string joined by "_" (underscore) characters
# - Any contiguous string containing numerals
# - Tcl
# - Tk
# - Tix
#
# Leading and trailing blanks in the strings ("  ...  ") should be preserved after translation.
#
# Set the return value to 1 (as "retrun 1") in the code fragment below when this language file is ready to be released.
#
}
##################  DO NOT CHANGE ANYTHING ABOVE THIS LINE ###################




if { [info exists gPB(LANG_TEST)] } {
  #======================================================
  # Return 1 when this language file is ready to be used
  #======================================================
return 1
}


#=============================================================================
# pb800
#=============================================================================
::msgcat::mcset pb_msg_english "MC(event,misc,subop_start,name)"      "Start of Subop Path"
::msgcat::mcset pb_msg_english "MC(event,misc,subop_end,name)"        "End of Subop Path"
::msgcat::mcset pb_msg_english "MC(event,misc,contour_start,name)"    "Contour Start"
::msgcat::mcset pb_msg_english "MC(event,misc,contour_end,name)"      "Contour End"
::msgcat::mcset pb_msg_english "MC(prog,tree,misc,Label)"             "Miscellaneous"
::msgcat::mcset pb_msg_english "MC(event,cycle,lathe_rough,name)"     "Lathe Roughing"
::msgcat::mcset pb_msg_english "MC(main,file,properties,Label)"       "Post Properties"

::msgcat::mcset pb_msg_english "MC(ude,editor,popup,MSG_CATEGORY)"    "UDE for a mill or lathe post may not be specified with only a \"Wedm\" category!"

::msgcat::mcset pb_msg_english "MC(event,cycle,plane_change,label)"   "Detect Work Plane Change To Lower"
::msgcat::mcset pb_msg_english "MC(format,check_1,error,msg)"         "Format can not accommodate the value of expressions"

::msgcat::mcset pb_msg_english "MC(format,check_4,error,msg)"         "Change the Format of related Address before leaving this page\
                                                                       or saving this post!"
::msgcat::mcset pb_msg_english "MC(format,check_5,error,msg)"         "Modify the Format before leaving this page or saving this post!"
::msgcat::mcset pb_msg_english "MC(format,check_6,error,msg)"         "Change the Format of related Address before entering this page!"

::msgcat::mcset pb_msg_english "MC(msg,old_block,maximum_length)"     "The names of following Blocks have exceeded the length limitation:"
::msgcat::mcset pb_msg_english "MC(msg,old_address,maximum_length)"   "The names of following Words have exceeded the length limitation:"
::msgcat::mcset pb_msg_english "MC(msg,block_address,check,title)"    "Checking Block and Word name"
::msgcat::mcset pb_msg_english "MC(msg,block_address,maximum_length)" "Some names of Blocks or Words have exceeded the length limitation."

::msgcat::mcset pb_msg_english "MC(address,maximum_name_msg)"         "The string length has exceeded the limitation."

::msgcat::mcset pb_msg_english "MC(ude,import,oth_list,Label)"        "Include Other CDL File"
::msgcat::mcset pb_msg_english "MC(ude,import,oth_list,Context)"      "Select \\\"New\\\" option from popup menu (right-mouse click)\
                                                                       to include other CDL files with this post."
::msgcat::mcset pb_msg_english "MC(ude,import,ihr_list,Label)"        "Inherit UDE From A Post"
::msgcat::mcset pb_msg_english "MC(ude,import,ihr_list,Context)"      "Select \\\"New\\\" option from popup menu (right-mouse click)\
                                                                       to inherit UDE definitions and associated handlers from a post."
::msgcat::mcset pb_msg_english "MC(ude,import,up,Label)"              "Up"
::msgcat::mcset pb_msg_english "MC(ude,import,down,Label)"            "Down"
::msgcat::mcset pb_msg_english "MC(msg,exist_cdl_file)"               "Specified CDL file has been included already!"

::msgcat::mcset pb_msg_english "MC(listing,link_var,check,Label)"     "Link Tcl Variables to C Variables"
::msgcat::mcset pb_msg_english "MC(listing,link_var,check,Context)"   "A set of frequently changed Tcl variables (such as \\\"mom_pos\\\") can be linked\
                                                                       directly to the internal C variables to improve the performance of post-processing.\
                                                                       However, certain restrictions should be observed to avoid possible errors and\
                                                                       difference in the NC output."

::msgcat::mcset pb_msg_english "MC(msg,check_resolution,title)"       "Check Lineare/Rotary Motion Resolution"
::msgcat::mcset pb_msg_english "MC(msg,check_resolution,linear)"      "Format setting may not accommodate the output for \"Linear Motion Resolution\"."
::msgcat::mcset pb_msg_english "MC(msg,check_resolution,rotary)"      "Format setting may not accommodate the output for \"Rotary Motion Resolution\"."

::msgcat::mcset pb_msg_english "MC(cmd,export,desc,label)"            "Input description for the exported custom commands"
::msgcat::mcset pb_msg_english "MC(cmd,desc_dlg,title)"               "Description"
::msgcat::mcset pb_msg_english "MC(block,delete_row,Label)"           "Delete All Active Elements In This Row"
::msgcat::mcset pb_msg_english "MC(block,exec_cond,set,Label)"        "Output Condition"
::msgcat::mcset pb_msg_english "MC(block,exec_cond,new,Label)"        "New..."
::msgcat::mcset pb_msg_english "MC(block,exec_cond,edit,Label)"       "Edit..."
::msgcat::mcset pb_msg_english "MC(block,exec_cond,remove,Label)"     "Remove..."

::msgcat::mcset pb_msg_english "MC(cust_cmd,name_msg_for_cond)"       "Specify a different name. \
                                                                       \nOutput condition command shoud be prefixed with"

::msgcat::mcset pb_msg_english "MC(machine,linearization,Label)"         "Linearization Interpolation"
::msgcat::mcset pb_msg_english "MC(machine,linearization,angle,Label)"   "Rotary Angle"
::msgcat::mcset pb_msg_english "MC(machine,linearization,angle,Context)" "Interpolated points will be calculated based on the distribution of\
                                                                          the start and end angles of the rotary axes."
::msgcat::mcset pb_msg_english "MC(machine,linearization,axis,Label)"    "Tool Axis"
::msgcat::mcset pb_msg_english "MC(machine,linearization,axis,Context)"  "Interpolated points will be calculated based on the distribution of\
                                                                          the start and end vectors of the tool axis."
::msgcat::mcset pb_msg_english "MC(machine,resolution,continue,Label)"   "Continue"
::msgcat::mcset pb_msg_english "MC(machine,resolution,abort,Label)"      "Abort"

::msgcat::mcset pb_msg_english "MC(machine,axis,def_lintol,Label)"       "Default Tolerance"
::msgcat::mcset pb_msg_english "MC(machine,axis,def_lintol,Context)"     "Default Linearization Tolerance"
::msgcat::mcset pb_msg_english "MC(sub_post,inch,Lable)"                 "IN"
::msgcat::mcset pb_msg_english "MC(sub_post,metric,Lable)"               "MM"
::msgcat::mcset pb_msg_english "MC(new_sub,title,Label)"                 "Create New Subordinate Post Processor"
::msgcat::mcset pb_msg_english "MC(new,sub_post,toggle,label)"           "Subordinate Post"
::msgcat::mcset pb_msg_english "MC(new,sub_post,toggle,tmp_label)"       "Units Only Subpost"
::msgcat::mcset pb_msg_english "MC(new,unit_post,filename,msg)"          "The new subordinate post for alternate output units should be named\n\
                                                                          by adding postfix \"__MM\" or \"__IN\" to the name of main post."
::msgcat::mcset pb_msg_english "MC(new,alter_unit,toggle,label)"         "Alternate Output Unit"
::msgcat::mcset pb_msg_english "MC(new,main_post,label)"                 "Main Post"
::msgcat::mcset pb_msg_english "MC(new,main_post,warning_1,msg)"         "Only a complete main post can be used to create a new subordinate post!"
::msgcat::mcset pb_msg_english "MC(new,main_post,warning_2,msg)"         "The main post must be created or saved\n in Post Builder version 8.0 or newer."
::msgcat::mcset pb_msg_english "MC(new,main_post,specify_err,msg)"       "Main post must be specified for creating a subordinate post!"
::msgcat::mcset pb_msg_english "MC(machine,gen,alter_unit,Label)"        "Subpost Output Units :"
::msgcat::mcset pb_msg_english "MC(unit_related_param,tab,Label)"        "Units Parameters"
::msgcat::mcset pb_msg_english "MC(unit_related_param,feed_rate,Label)"  "Feed Rate"
::msgcat::mcset pb_msg_english "MC(listing,alt_unit,frame,Label)"        "Optional Alternate Units Subpost"
::msgcat::mcset pb_msg_english "MC(listing,alt_unit,default,Label)"      "Default"
::msgcat::mcset pb_msg_english "MC(listing,alt_unit,default,Context)"    "Default name of alternate units subpost will be <post name>__MM or <post name>__IN"
::msgcat::mcset pb_msg_english "MC(listing,alt_unit,specify,Label)"      "Specify"
::msgcat::mcset pb_msg_english "MC(listing,alt_unit,specify,Context)"    "Specify name of an alternate units subpost"
::msgcat::mcset pb_msg_english "MC(listing,alt_unit,select_name,Label)"  "Select Name"
::msgcat::mcset pb_msg_english "MC(listing,alt_unit,warning_1,msg)"      "Only an alternate units subpost can be selected!"
::msgcat::mcset pb_msg_english "MC(listing,alt_unit,warning_2,msg)"      "The selected subpost can not support the alternate output units for this post!"

::msgcat::mcset pb_msg_english "MC(listing,alt_unit,post_name,Label)"    "Alternate Units Subpost"
::msgcat::mcset pb_msg_english "MC(listing,alt_unit,post_name,Context)"  "NX Post will use the units subpost, if supplied, to handle the\
                                                                          alternate output units for this post."


##--------------------
## New string in v7.5
##
::msgcat::mcset pb_msg_english "MC(machine,axis,violation,user,evt_title)"  "User Defined Action for Axis Limit Violation"
::msgcat::mcset pb_msg_english "MC(event,helix,name)"                       "Helix Move"
::msgcat::mcset pb_msg_english "MC(event,circular,ijk_param,prefix,msg)"    "Expressions used in Addresses"
::msgcat::mcset pb_msg_english "MC(event,circular,ijk_param,postfix,msg)"   "will not be affected by the change of this option!"
::msgcat::mcset pb_msg_english "MC(isv,spec_codelist,default,msg)"          "This action will restore the list of special NC codes and\n\
                                                                            their handlers to the state when this post was opened or created.\n\n\
                                                                             Do you want to continue?"
::msgcat::mcset pb_msg_english "MC(isv,spec_codelist,restore,msg)"          "This action will restore the list of special NC codes and\n\
                                                                             their handlers to the state when this page was last visited.\n\n\
                                                                             Do you want to continue?"
::msgcat::mcset pb_msg_english "MC(msg,block_format_command,paste_err)"     "Object Name Exists...Paste Invalid!"
::msgcat::mcset pb_msg_english "MC(main,file,open,choose_cntl_type)"        "Choose A Controller Family"
::msgcat::mcset pb_msg_english "MC(cust_cmd,import,no_vnc_cmd,msg)"         "This file contains no new or different VNC command!"
::msgcat::mcset pb_msg_english "MC(cust_cmd,import,no_cmd,msg)"             "This file contains no new or different custom command!"
::msgcat::mcset pb_msg_english "MC(isv,tool_info,name_same_err,Msg)"        "Tool names can not be the same!"
::msgcat::mcset pb_msg_english "MC(msg,limit_to_change_license)"            "You are not the author of this post. \nYou will not\
                                                                             have permission to rename it or change its license."
::msgcat::mcset pb_msg_english "MC(output,other_opts,validation,msg)"       "The name of the user's tcl file should be specified."
::msgcat::mcset pb_msg_english "MC(machine,empty_entry_err,msg)"            "There are empty entries on this parameters page."
::msgcat::mcset pb_msg_english "MC(msg,control_v_limit)"                    "The string that you are trying to paste may have\n\
                                                                             exceeded the length limitation or\n\
                                                                             contained multiple lines or invalid characters."
::msgcat::mcset pb_msg_english "MC(block,capital_name_msg)"                 "The leading letter of block name can not be in capitals!\n\
                                                                             Specify a different name."
::msgcat::mcset pb_msg_english "MC(machine,axis,violation,user,Label)"      "User Defined"
::msgcat::mcset pb_msg_english "MC(machine,axis,violation,user,Handler)"    "Handler"
::msgcat::mcset pb_msg_english "MC(new,user,file,NOT_EXIST)"                "This user file does not exist!"
::msgcat::mcset pb_msg_english "MC(new,include_vnc,Label)"                  "Include Virtual NC Controller"
::msgcat::mcset pb_msg_english "MC(other,opt_equal,Label)"                  "Equal Sign (=)"
::msgcat::mcset pb_msg_english "MC(event,nurbs,name)"                       "NURBS Move"
::msgcat::mcset pb_msg_english "MC(event,cycle,tap_float,name)"             "Tap Float"
::msgcat::mcset pb_msg_english "MC(event,cycle,thread,name)"                "Thread"
::msgcat::mcset pb_msg_english "MC(ude,editor,group,MSG_NESTED_GROUP)"      "Nested grouping is not supported!"
::msgcat::mcset pb_msg_english "MC(ude,editor,bmp,Label)"                   "Bitmap"
::msgcat::mcset pb_msg_english "MC(ude,editor,bmp,Context)"                 "Add a new bitmap parameter by dragging it to right list."
::msgcat::mcset pb_msg_english "MC(ude,editor,group,Label)"                 "Group"
::msgcat::mcset pb_msg_english "MC(ude,editor,group,Context)"               "Add a new grouping parameter by dragging it to right list."
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,DESC,Label)"         "Description"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,DESC,Context)"       "Specify event information"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,URL,Label)"          "URL"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,URL,Context)"        "Specify URL for the event description"
::msgcat::mcset pb_msg_english "MC(ude,editor,param,MSG_WRONG_IMAGE_FILE)"  "Image file must be of BMP format!"
::msgcat::mcset pb_msg_english "MC(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)" "Bitmap file name should not contain directory path!"
::msgcat::mcset pb_msg_english "MC(ude,editor,param,MSG_WRONG_VAR_NAME)"    "Variable name must begin with a letter."
::msgcat::mcset pb_msg_english "MC(ude,editor,param,MSG_WRONG_KEYWORD)"     "Variable name should not use keyword: "
::msgcat::mcset pb_msg_english "MC(ude,editor,status_label)"                "Status"
::msgcat::mcset pb_msg_english "MC(ude,editor,vector,Label)"                "Vector"
::msgcat::mcset pb_msg_english "MC(ude,editor,vector,Context)"              "Add a new vector parameter by dragging it to right list."
::msgcat::mcset pb_msg_english "MC(ude,editor,popup,MSG_URL_FORMAT)"        "URL must be of format \"http://*\" or \"file://*\" and\
                                                                             no backslash in use."
::msgcat::mcset pb_msg_english "MC(ude,editor,popup,MSG_BLANK_HELP_INFO)"   "Description and URL must be specified!"
::msgcat::mcset pb_msg_english "MC(new,MSG_NO_AXIS)"                        "Axis configuration must be selected for a machine tool."
::msgcat::mcset pb_msg_english "MC(machine,info,controller_type,Label)"     "Controller Family"
::msgcat::mcset pb_msg_english "MC(block,func_combo,Label)"                 "Macro"
::msgcat::mcset pb_msg_english "MC(block,prefix_popup,add,Label)"           "Add Prefix Text"
::msgcat::mcset pb_msg_english "MC(block,prefix_popup,edit,Label)"          "Edit Prefix Text"
::msgcat::mcset pb_msg_english "MC(block,prefix,Label)"                     "Prefix"
::msgcat::mcset pb_msg_english "MC(block,suppress_popup,Label)"             "Suppress Sequence Number"
::msgcat::mcset pb_msg_english "MC(block,custom_func,Label)"                "Custom Macro"
::msgcat::mcset pb_msg_english "MC(seq,combo,macro,Label)"                  "Custom Macro"
::msgcat::mcset pb_msg_english "MC(func,tab,Label)"                         "Macro"
::msgcat::mcset pb_msg_english "MC(func,exp,msg)"                           "Expression for a Macro's parameter should not be blank."
::msgcat::mcset pb_msg_english "MC(func,edit,name,Label)"                   "Macro Name"
::msgcat::mcset pb_msg_english "MC(func,disp_name,Label)"                   "Output Name"
::msgcat::mcset pb_msg_english "MC(func,param_list,Label)"                  "Parameters List"
::msgcat::mcset pb_msg_english "MC(func,separator,Label)"                   "Separator"
::msgcat::mcset pb_msg_english "MC(func,start,Label)"                       "Start Character"
::msgcat::mcset pb_msg_english "MC(func,end,Label)"                         "End Character"
::msgcat::mcset pb_msg_english "MC(func,output,name,Label)"                 "Output Attribute"
::msgcat::mcset pb_msg_english "MC(func,output,check,Label)"                "Output Parameters' Name"
::msgcat::mcset pb_msg_english "MC(func,output,link,Label)"                 "Link Character"
::msgcat::mcset pb_msg_english "MC(func,col_param,Label)"                   "Parameter"
::msgcat::mcset pb_msg_english "MC(func,col_exp,Label)"                     "Expression"
::msgcat::mcset pb_msg_english "MC(func,popup,insert,Label)"                "New"
::msgcat::mcset pb_msg_english "MC(func,name,err_msg)"                      "Macro name should not contain space!"
::msgcat::mcset pb_msg_english "MC(func,name,blank_err)"                    "Macro name should not be blank!"
::msgcat::mcset pb_msg_english "MC(func,name,contain_err)"                  "Macro name should only contain alphabets, digits and underscore characters!"
::msgcat::mcset pb_msg_english "MC(func,tree_node,start_err)"               "Node name must begin with an upper-case letter!"
::msgcat::mcset pb_msg_english "MC(func,tree_node,contain_err)"             "Node name only accepts an alphabet, digit or the underscore character!"
::msgcat::mcset pb_msg_english "MC(func,help,Label)"                        "Information"
::msgcat::mcset pb_msg_english "MC(func,help,Context)"                      "Show information of the object."
::msgcat::mcset pb_msg_english "MC(func,help,MSG_NO_INFO)"                  "No information is provided for this Macro."


##------
## Title
##
::msgcat::mcset pb_msg_english "MC(main,title,Unigraphics)"             "Unigraphics"
::msgcat::mcset pb_msg_english "MC(main,title,UG)"                      "NX"
::msgcat::mcset pb_msg_english "MC(main,title,Post_Builder)"            "Post Builder"

::msgcat::mcset pb_msg_english "MC(main,title,Version)"                 "Version"
::msgcat::mcset pb_msg_english "MC(main,default,Status)"                "Select New or Open option on File menu."
::msgcat::mcset pb_msg_english "MC(main,save,Status)"                   "Save the Post."

##------
## File
##
::msgcat::mcset pb_msg_english "MC(main,file,Label)"                    "File"

::msgcat::mcset pb_msg_english "MC(main,file,Balloon)"                  "\ New, Open, Save,\n\
                                                                         Save\ As, Close and Exit"

::msgcat::mcset pb_msg_english "MC(main,file,Context)"                  "\ New, Open, Save,\n\
                                                                         Save\ As, Close and Exit"
::msgcat::mcset pb_msg_english "MC(main,file,menu,Context)"             " "

::msgcat::mcset pb_msg_english "MC(main,file,new,Label)"                "New ..."
::msgcat::mcset pb_msg_english "MC(main,file,new,Balloon)"              "Create a new Post."
::msgcat::mcset pb_msg_english "MC(main,file,new,Context)"              "Create a new Post."
::msgcat::mcset pb_msg_english "MC(main,file,new,Busy)"                 "Creating New Post ..."

::msgcat::mcset pb_msg_english "MC(main,file,open,Label)"               "Open ..."
::msgcat::mcset pb_msg_english "MC(main,file,open,Balloon)"             "Edit an existing Post."
::msgcat::mcset pb_msg_english "MC(main,file,open,Context)"             "Edit an existing Post."
::msgcat::mcset pb_msg_english "MC(main,file,open,Busy)"                "Opening Post ..."

::msgcat::mcset pb_msg_english "MC(main,file,mdfa,Label)"               "Import MDFA ..."
::msgcat::mcset pb_msg_english "MC(main,file,mdfa,Balloon)"             "Create a new Post from MDFA."
::msgcat::mcset pb_msg_english "MC(main,file,mdfa,Context)"             "Create a new Post from MDFA."

::msgcat::mcset pb_msg_english "MC(main,file,save,Label)"               "Save"
::msgcat::mcset pb_msg_english "MC(main,file,save,Balloon)"             "Save the Post in progress."
::msgcat::mcset pb_msg_english "MC(main,file,save,Context)"             "Save the Post in progress."
::msgcat::mcset pb_msg_english "MC(main,file,save,Busy)"                "Saving Post ..."

::msgcat::mcset pb_msg_english "MC(main,file,save_as,Label)"            "Save As ..."
::msgcat::mcset pb_msg_english "MC(main,file,save_as,Balloon)"          "Save the Post to a new name."
::msgcat::mcset pb_msg_english "MC(main,file,save_as,Context)"          "Save the Post to a new name."

::msgcat::mcset pb_msg_english "MC(main,file,close,Label)"              "Close"
::msgcat::mcset pb_msg_english "MC(main,file,close,Balloon)"            "Close the Post in progress."
::msgcat::mcset pb_msg_english "MC(main,file,close,Context)"            "Close the Post in progress."

::msgcat::mcset pb_msg_english "MC(main,file,exit,Label)"               "Exit"
::msgcat::mcset pb_msg_english "MC(main,file,exit,Balloon)"             "Terminate Post Builder."
::msgcat::mcset pb_msg_english "MC(main,file,exit,Context)"             "Terminate Post Builder."

::msgcat::mcset pb_msg_english "MC(main,file,history,Label)"            "Recently Opened Posts"
::msgcat::mcset pb_msg_english "MC(main,file,history,Balloon)"          "Edit a previously visited Post."
::msgcat::mcset pb_msg_english "MC(main,file,history,Context)"          "Edit a Post visited in the previous Post Builder sessions."

##---------
## Options
##
::msgcat::mcset pb_msg_english "MC(main,options,Label)"                 "Options"

::msgcat::mcset pb_msg_english "MC(main,options,Balloon)"               " Validate\ Custom\ Commands, Backup\ Post"
::msgcat::mcset pb_msg_english "MC(main,options,Context)"               " "
::msgcat::mcset pb_msg_english "MC(main,options,menu,Context)"          " "

::msgcat::mcset pb_msg_english "MC(main,windows,Label)"                 "Windows"
::msgcat::mcset pb_msg_english "MC(main,windows,Balloon)"               "The editting posts list"
::msgcat::mcset pb_msg_english "MC(main,windows,Context)"               " "
::msgcat::mcset pb_msg_english "MC(main,windows,menu,Context)"          " "

::msgcat::mcset pb_msg_english "MC(main,options,properties,Label)"      "Properties"
::msgcat::mcset pb_msg_english "MC(main,options,properties,Balloon)"    "Properties"
::msgcat::mcset pb_msg_english "MC(main,options,properties,Context)"    "Properties"

::msgcat::mcset pb_msg_english "MC(main,options,advisor,Label)"         "Post Advisor"
::msgcat::mcset pb_msg_english "MC(main,options,advisor,Balloon)"       "Post Advisor"
::msgcat::mcset pb_msg_english "MC(main,options,advisor,Context)"       "Enable/ disable Post Advisor."

::msgcat::mcset pb_msg_english "MC(main,options,cmd_check,Label)"       "Validate Custom Commands"
::msgcat::mcset pb_msg_english "MC(main,options,cmd_check,Balloon)"     "Validate Custom Commands"
::msgcat::mcset pb_msg_english "MC(main,options,cmd_check,Context)"     "Switches for Custom Commands Validation"

::msgcat::mcset pb_msg_english "MC(main,options,cmd_check,syntax,Label)"   "Syntax Errors"
::msgcat::mcset pb_msg_english "MC(main,options,cmd_check,command,Label)"  "Unknown Commands"
::msgcat::mcset pb_msg_english "MC(main,options,cmd_check,block,Label)"    "Unknown Blocks"
::msgcat::mcset pb_msg_english "MC(main,options,cmd_check,address,Label)"  "Unknown Addresses"
::msgcat::mcset pb_msg_english "MC(main,options,cmd_check,format,Label)"   "Unknown Formats"

::msgcat::mcset pb_msg_english "MC(main,options,backup,Label)"          "Backup Post"
::msgcat::mcset pb_msg_english "MC(main,options,backup,Balloon)"        "Backup Post Method"
::msgcat::mcset pb_msg_english "MC(main,options,backup,Context)"        "Create backup copies when saving the Post in progress."

::msgcat::mcset pb_msg_english "MC(main,options,backup,one,Label)"      "Backup Original"
::msgcat::mcset pb_msg_english "MC(main,options,backup,all,Label)"      "Backup Every Save"
::msgcat::mcset pb_msg_english "MC(main,options,backup,none,Label)"     "No Backup"

##-----------
## Utilities
##
::msgcat::mcset pb_msg_english "MC(main,utils,Label)"                   "Utilities"
::msgcat::mcset pb_msg_english "MC(main,utils,Balloon)"                 "\ Choose\ MOM\ Variable, Install\ Post"
::msgcat::mcset pb_msg_english "MC(main,utils,Context)"                 " "
::msgcat::mcset pb_msg_english "MC(main,utils,menu,Context)"            " "

::msgcat::mcset pb_msg_english "MC(main,utils,etpdf,Label)"             "Edit Template Posts Data File"

::msgcat::mcset pb_msg_english "MC(main,utils,bmv,Label)"               "Browse MOM Variables"
::msgcat::mcset pb_msg_english "MC(main,utils,blic,Label)"              "Browse Licenses"


##------
## Help
##
::msgcat::mcset pb_msg_english "MC(main,help,Label)"                    "Help"
::msgcat::mcset pb_msg_english "MC(main,help,Balloon)"                  "Help Options"
::msgcat::mcset pb_msg_english "MC(main,help,Context)"                  "Help Options"
::msgcat::mcset pb_msg_english "MC(main,help,menu,Context)"             " "

::msgcat::mcset pb_msg_english "MC(main,help,bal,Label)"                "Balloon Tip"
::msgcat::mcset pb_msg_english "MC(main,help,bal,Balloon)"              "Balloon Tip on Icons"
::msgcat::mcset pb_msg_english "MC(main,help,bal,Context)"              "Enable/ disable display of balloon tool tips for icons."

::msgcat::mcset pb_msg_english "MC(main,help,chelp,Label)"              "Context Sensitive Help"
::msgcat::mcset pb_msg_english "MC(main,help,chelp,Balloon)"            "Context Sensitive Help on Dialog Items"
::msgcat::mcset pb_msg_english "MC(main,help,chelp,Context)"            "Context Sensitive Help on Dialog Items"

::msgcat::mcset pb_msg_english "MC(main,help,what,Label)"               "What To Do?"
::msgcat::mcset pb_msg_english "MC(main,help,what,Balloon)"             "What You Can Do Here?"
::msgcat::mcset pb_msg_english "MC(main,help,what,Context)"             "What You Can Do Here?"

::msgcat::mcset pb_msg_english "MC(main,help,dialog,Label)"             "Help On Dialog"
::msgcat::mcset pb_msg_english "MC(main,help,dialog,Balloon)"           "Help On This Dialog"
::msgcat::mcset pb_msg_english "MC(main,help,dialog,Context)"           "Help On This Dialog"

::msgcat::mcset pb_msg_english "MC(main,help,manual,Label)"             "User's Manual"
::msgcat::mcset pb_msg_english "MC(main,help,manual,Balloon)"           "User's Help Manual"
::msgcat::mcset pb_msg_english "MC(main,help,manual,Context)"           "User's Help Manual"

::msgcat::mcset pb_msg_english "MC(main,help,about,Label)"              "About Post Builder"
::msgcat::mcset pb_msg_english "MC(main,help,about,Balloon)"            "About Post Builder"
::msgcat::mcset pb_msg_english "MC(main,help,about,Context)"            "About Post Builder"

::msgcat::mcset pb_msg_english "MC(main,help,rel_note,Label)"           "Release Notes"
::msgcat::mcset pb_msg_english "MC(main,help,rel_note,Balloon)"         "Release Notes"
::msgcat::mcset pb_msg_english "MC(main,help,rel_note,Context)"         "Release Notes"

::msgcat::mcset pb_msg_english "MC(main,help,tcl_man,Label)"            "Tcl/Tk Reference Manuals"
::msgcat::mcset pb_msg_english "MC(main,help,tcl_man,Balloon)"          "Tcl/Tk Reference Manuals"
::msgcat::mcset pb_msg_english "MC(main,help,tcl_man,Context)"          "Tcl/Tk Reference Manuals"

##----------
## Tool Bar
##
::msgcat::mcset pb_msg_english "MC(tool,new,Label)"                     "New"
::msgcat::mcset pb_msg_english "MC(tool,new,Context)"                   "Create a new Post."

::msgcat::mcset pb_msg_english "MC(tool,open,Label)"                    "Open"
::msgcat::mcset pb_msg_english "MC(tool,open,Context)"                  "Edit an existing Post."

::msgcat::mcset pb_msg_english "MC(tool,save,Label)"                    "Save"
::msgcat::mcset pb_msg_english "MC(tool,save,Context)"                  "Save the Post in progress."

::msgcat::mcset pb_msg_english "MC(tool,bal,Label)"                     "Balloon Tip"
::msgcat::mcset pb_msg_english "MC(tool,bal,Context)"                   "Enable/ disable display of balloon tool tips for icons."

::msgcat::mcset pb_msg_english "MC(tool,chelp,Label)"                   "Context Sensitive Help"
::msgcat::mcset pb_msg_english "MC(tool,chelp,Context)"                 "Context Sensitive Help on Dialog Items"

::msgcat::mcset pb_msg_english "MC(tool,what,Label)"                    "What To Do?"
::msgcat::mcset pb_msg_english "MC(tool,what,Context)"                  "What You Can Do Here?"

::msgcat::mcset pb_msg_english "MC(tool,dialog,Label)"                  "Help On Dialog"
::msgcat::mcset pb_msg_english "MC(tool,dialog,Context)"                "Help On This Dialog"

::msgcat::mcset pb_msg_english "MC(tool,manual,Label)"                  "User's Manual"
::msgcat::mcset pb_msg_english "MC(tool,manual,Context)"                "User's Help Manual"

#=============
# Main Window
#=============

##-----------------
## Common Messages
##
::msgcat::mcset pb_msg_english "MC(msg,error,title)"                    "Post Builder Error"
::msgcat::mcset pb_msg_english "MC(msg,dialog,title)"                   "Post Builder Message"
::msgcat::mcset pb_msg_english "MC(msg,warning)"                        "Warning"
::msgcat::mcset pb_msg_english "MC(msg,error)"                          "Error"
::msgcat::mcset pb_msg_english "MC(msg,invalid_data)"                   "Invalid data has been keyed in for the parameter"
::msgcat::mcset pb_msg_english "MC(msg,invalid_browser_cmd)"            "Invalid browser command :"
::msgcat::mcset pb_msg_english "MC(msg,wrong_filename)"                 "The filename has been changed!"
::msgcat::mcset pb_msg_english "MC(msg,user_ctrl_limit)"                "A licensed post can not be used as controller\n\
                                                                         for creating a new post if you are not the author!"
::msgcat::mcset pb_msg_english "MC(msg,import_limit)"                   "You are not the author of this licensed post.\n\
                                                                         Custom commands may not be imported!"
::msgcat::mcset pb_msg_english "MC(msg,limit_msg)"                      "You are not the author of this licensed post!"
::msgcat::mcset pb_msg_english "MC(msg,no_file)"                        "Encrypted file is missing for this licensed post!"
::msgcat::mcset pb_msg_english "MC(msg,no_license)"                     "You do not have proper license to perform this function!"
::msgcat::mcset pb_msg_english "MC(msg,no_license_title)"               "NX/Post Builder Non-Licensed Use"
::msgcat::mcset pb_msg_english "MC(msg,no_license_dialog)"              "You are permitted to use the NX/Post Builder\n\
                                                                         without proper license.  However, you will not\n\
                                                                         be able to save your work afterward."
::msgcat::mcset pb_msg_english "MC(msg,pending)"                        "Service of this option will be implemented in the future release."
::msgcat::mcset pb_msg_english "MC(msg,save)"                           "Do you want to save your changes\n\
                                                                         before closing the Post in progress?"
::msgcat::mcset pb_msg_english "MC(msg,version_check)"                  "Post created with newer version of Post Builder can not be opened in this version."

::msgcat::mcset pb_msg_english "MC(msg,file_corruption)"                "Incorrect contents in Post Builder Session file."
::msgcat::mcset pb_msg_english "MC(msg,bad_tcl_file)"                   "Incorrect contents in the Tcl file of your Post."
::msgcat::mcset pb_msg_english "MC(msg,bad_def_file)"                   "Incorrect contents in the Definition file of your Post."
::msgcat::mcset pb_msg_english "MC(msg,invalid_post)"                   "You must specify at least one set of Tcl & Definition files for your Post."
::msgcat::mcset pb_msg_english "MC(msg,invalid_dir)"                    "Directory doesn't exist."
::msgcat::mcset pb_msg_english "MC(msg,invalid_file)"                   "File Not Found or Invalid."
::msgcat::mcset pb_msg_english "MC(msg,invalid_def_file)"               "Cannot open Definition File"
::msgcat::mcset pb_msg_english "MC(msg,invalid_tcl_file)"               "Cannot open Event Handler File"
::msgcat::mcset pb_msg_english "MC(msg,dir_perm)"                       "You do not have the write permission to the directory:"
::msgcat::mcset pb_msg_english "MC(msg,file_perm)"                      "You do not have the permission to write to"

::msgcat::mcset pb_msg_english "MC(msg,file_exist)"                     "already exist!\
                                                                         \nDo you want to replace them anyway?"
::msgcat::mcset pb_msg_english "MC(msg,file_missing)"                   "Some or all files for this Post are missing.\n\
                                                                         You can not open this Post."
::msgcat::mcset pb_msg_english "MC(msg,sub_dialog_open)"                "You have to complete the editing of all parameter sub dialogs before saving the Post!"
::msgcat::mcset pb_msg_english "MC(msg,generic)"                        "Post Builder currently has only been implemented for Generic Milling Machines."
::msgcat::mcset pb_msg_english "MC(msg,min_word)"                       "A Block should contain at least one Word."
::msgcat::mcset pb_msg_english "MC(msg,name_exists)"                    "already exists!\n\
                                                                         Specify a different name."
::msgcat::mcset pb_msg_english "MC(msg,in_use)"                         "This component is in use.\n\
                                                                         It cannot be deleted."
::msgcat::mcset pb_msg_english "MC(msg,do_you_want_to_proceed)"         "You may assume them as existing data elements and proceed."
::msgcat::mcset pb_msg_english "MC(msg,not_installed_properly)"         "has not been installed properly."
::msgcat::mcset pb_msg_english "MC(msg,no_app_to_open)"                 "No application to open"
::msgcat::mcset pb_msg_english "MC(msg,save_change)"                    "Do you want to save the changes?"

::msgcat::mcset pb_msg_english "MC(msg,external_editor)"                "External Editor"

# - Do not translate EDITOR
::msgcat::mcset pb_msg_english "MC(msg,set_ext_editor)"                 "You can use environment variable EDITOR to activate your favorite text editor."
::msgcat::mcset pb_msg_english "MC(msg,filename_with_space)"            "File name constaining space is not supported!"
::msgcat::mcset pb_msg_english "MC(msg,filename_protection)"            "The selected file used by one of the editing posts can not be overwrited!"


##--------------------
## Common Function
##
::msgcat::mcset pb_msg_english "MC(msg,parent_win)"                     "A transient window requires its parent window defined."
::msgcat::mcset pb_msg_english "MC(msg,close_subwin)"                   "You have to close all sub-windows to enable this tab."
::msgcat::mcset pb_msg_english "MC(msg,block_exist)"                    "An element of the selected Word exists in the Block Template."
::msgcat::mcset pb_msg_english "MC(msg,num_gcode_1)"                    "Number of G - Codes are restricted to"
::msgcat::mcset pb_msg_english "MC(msg,num_gcode_2)"                    "per block"
::msgcat::mcset pb_msg_english "MC(msg,num_mcode_1)"                    "Number of M - Codes are restricted to"
::msgcat::mcset pb_msg_english "MC(msg,num_mcode_2)"                    "per block"
::msgcat::mcset pb_msg_english "MC(msg,empty_entry)"                    "The Entry should not be empty."

::msgcat::mcset pb_msg_english "MC(msg,edit_feed_fmt)"                  "Formats for Address \"F\" may be edited on Feedrates parameters page"

::msgcat::mcset pb_msg_english "MC(msg,seq_num_max)"                    "Maximum value of the Sequence Number should not execeed the Address N's capacity of"

::msgcat::mcset pb_msg_english "MC(msg,no_cdl_name)"                    "The post name should be specified!"
::msgcat::mcset pb_msg_english "MC(msg,no_def_name)"                    "The folder should be specified!\n\
                                                                         And the pattern should like \"\$UGII_*\"!"
::msgcat::mcset pb_msg_english "MC(msg,no_own_name)"                    "The folder should be specified!\n\
                                                                         And the pattern should like \"\$UGII_*\"!"
::msgcat::mcset pb_msg_english "MC(msg,no_oth_ude_name)"                "The other cdl file name should be specified!\n\
                                                                         And the pattern should like \"\$UGII_*\"!"
::msgcat::mcset pb_msg_english "MC(msg,not_oth_cdl_file)"               "Only CDL file is allowed!"
::msgcat::mcset pb_msg_english "MC(msg,not_pui_file)"                   "Only PUI file is allowed!"
::msgcat::mcset pb_msg_english "MC(msg,not_cdl_file)"                   "Only CDL file is allowed!"
::msgcat::mcset pb_msg_english "MC(msg,not_def_file)"                   "Only DEF file is allowed!"
::msgcat::mcset pb_msg_english "MC(msg,not_own_cdl_file)"               "Only own CDL file is allowed!"
::msgcat::mcset pb_msg_english "MC(msg,no_cdl_file)"                    "The selected post does not have a associated CDL file."
::msgcat::mcset pb_msg_english "MC(msg,cdl_info)"                       "The CDL and definition files of the selected post will be referenced (INCLUDE) in the definition file of this post.\n\
                                                                         And the Tcl file of the selected post will also be sourced in by the event handler file of this post at runtime."

::msgcat::mcset pb_msg_english "MC(msg,add_max1)"                       "Maximum value of Address"
::msgcat::mcset pb_msg_english "MC(msg,add_max2)"                       "should not execeed its Format's capacity of"


::msgcat::mcset pb_msg_english "MC(com,text_entry_trans,title,Label)"   "Entry"

##---------------------------
## Common Navigation Buttons
##
::msgcat::mcset pb_msg_english "MC(nav_button,no_license,Message)"      "You do not have proper license to perform this function!"

::msgcat::mcset pb_msg_english "MC(nav_button,ok,Label)"                "OK"
::msgcat::mcset pb_msg_english "MC(nav_button,ok,Context)"              "This button is only available on a sub-dialog. It allows you to save the changes and dismiss the dialog."
::msgcat::mcset pb_msg_english "MC(nav_button,cancel,Label)"            "Cancel"
::msgcat::mcset pb_msg_english "MC(nav_button,cancel,Context)"          "This button is available on a sub-dialog. It allows you to dismiss the dialog."
::msgcat::mcset pb_msg_english "MC(nav_button,default,Label)"           "Default"
::msgcat::mcset pb_msg_english "MC(nav_button,default,Context)"         "This button allows you to restore the parameters on the present dialog for a component to the condition when the Post in session was first created or opened.\
                                                                         \n\
                                                                         \nHowever, the name of the component in question, if present, will only be restored to its initial state of the current visit to this component."
::msgcat::mcset pb_msg_english "MC(nav_button,restore,Label)"           "Restore"
::msgcat::mcset pb_msg_english "MC(nav_button,restore,Context)"         "This button allows you to restore the parameters on the present dialog to the initial settings of your current visit to this component."
::msgcat::mcset pb_msg_english "MC(nav_button,apply,Label)"             "Apply"
::msgcat::mcset pb_msg_english "MC(nav_button,apply,Context)"           "This button allows you to save the changes without dismissing the present dialog.  This will also re-establish the initial condition of the present dialog.\
                                                                         \n\
                                                                         \n(See Restore for the need for the initial condition)"
::msgcat::mcset pb_msg_english "MC(nav_button,filter,Label)"            "Filter"
::msgcat::mcset pb_msg_english "MC(nav_button,filter,Context)"          "This button will apply the directory filter and list the files that satisfy the condition."
::msgcat::mcset pb_msg_english "MC(nav_button,yes,Label)"               "Yes"
::msgcat::mcset pb_msg_english "MC(nav_button,yes,Context)"             "Yes"
::msgcat::mcset pb_msg_english "MC(nav_button,no,Label)"                "No"
::msgcat::mcset pb_msg_english "MC(nav_button,no,Context)"              "No"
::msgcat::mcset pb_msg_english "MC(nav_button,help,Label)"              "Help"
::msgcat::mcset pb_msg_english "MC(nav_button,help,Context)"            "Help"

::msgcat::mcset pb_msg_english "MC(nav_button,open,Label)"              "Open"
::msgcat::mcset pb_msg_english "MC(nav_button,open,Context)"            "This button allows you to open the selected Post for editing."

::msgcat::mcset pb_msg_english "MC(nav_button,save,Label)"              "Save"
::msgcat::mcset pb_msg_english "MC(nav_button,save,Context)"            "This button is available on the Save As dialog that allows you to save the Post in progress."

::msgcat::mcset pb_msg_english "MC(nav_button,manage,Label)"            "Manage ..."
::msgcat::mcset pb_msg_english "MC(nav_button,manage,Context)"          "This button allows you to manage the history of the recently visited Posts."

::msgcat::mcset pb_msg_english "MC(nav_button,refresh,Label)"           "Refresh"
::msgcat::mcset pb_msg_english "MC(nav_button,refresh,Context)"         "This button will refresh the list according to the existence of the objects."

::msgcat::mcset pb_msg_english "MC(nav_button,cut,Label)"               "Cut"
::msgcat::mcset pb_msg_english "MC(nav_button,cut,Context)"             "This button will cut the selected object from the list."

::msgcat::mcset pb_msg_english "MC(nav_button,copy,Label)"              "Copy"
::msgcat::mcset pb_msg_english "MC(nav_button,copy,Context)"            "This button will copy the selected object."

::msgcat::mcset pb_msg_english "MC(nav_button,paste,Label)"             "Paste"
::msgcat::mcset pb_msg_english "MC(nav_button,paste,Context)"           "This button will paste the object in the buffer back to the list."

::msgcat::mcset pb_msg_english "MC(nav_button,edit,Label)"              "Edit"
::msgcat::mcset pb_msg_english "MC(nav_button,edit,Context)"            "This button will edit the object in the buffer!"

::msgcat::mcset pb_msg_english "MC(nav_button,ex_editor,Label)"         "Use External Editor"

##------------
## New dialog
##
::msgcat::mcset pb_msg_english "MC(new,title,Label)"                    "Create New Post Processor"
::msgcat::mcset pb_msg_english "MC(new,Status)"                         "Enter the Name & Choose the Parameter for the New Post."

::msgcat::mcset pb_msg_english "MC(new,name,Label)"                     "Post Name"
::msgcat::mcset pb_msg_english "MC(new,name,Context)"                   "Name of the Post Processor to be created"

::msgcat::mcset pb_msg_english "MC(new,desc,Label)"                     "Description"
::msgcat::mcset pb_msg_english "MC(new,desc,Context)"                   "Description for the Post Processor to be created"

#Description for each selection
::msgcat::mcset pb_msg_english "MC(new,mill,desc,Label)"                "This is a Milling Machine."
::msgcat::mcset pb_msg_english "MC(new,lathe,desc,Label)"               "This is a Lathe Machine."
::msgcat::mcset pb_msg_english "MC(new,wedm,desc,Label)"                "This is a Wire EDM Machine."

::msgcat::mcset pb_msg_english "MC(new,wedm_2,desc,Label)"              "This is a 2-Axis Wire EDM Machine."
::msgcat::mcset pb_msg_english "MC(new,wedm_4,desc,Label)"              "This is a 4-Axis Wire EDM Machine."
::msgcat::mcset pb_msg_english "MC(new,lathe_2,desc,Label)"             "This is a 2-Axis Horizontal Lathe Machine."
::msgcat::mcset pb_msg_english "MC(new,lathe_4,desc,Label)"             "This is a 4-Axis Dependent Lathe Machine."
::msgcat::mcset pb_msg_english "MC(new,mill_3,desc,Label)"              "This is a 3-Axis Milling Machine."
::msgcat::mcset pb_msg_english "MC(new,mill_3MT,desc,Label)"            "3-Axis Mill-Turn (XZC)"
::msgcat::mcset pb_msg_english "MC(new,mill_4H,desc,Label)"             "This is a 4-Axis Milling Machine With\n\
                                                                         Rotary Head."
::msgcat::mcset pb_msg_english "MC(new,mill_4T,desc,Label)"             "This is a 4-Axis Milling Machine With\n\
                                                                         Rotary Table."
::msgcat::mcset pb_msg_english "MC(new,mill_5TT,desc,Label)"            "This is a 5-Axis Milling Machine With\n\
                                                                         Dual Rotary Tables."
::msgcat::mcset pb_msg_english "MC(new,mill_5HH,desc,Label)"            "This is a 5-Axis Milling Machine With\n\
                                                                         Dual Rotary Heads."
::msgcat::mcset pb_msg_english "MC(new,mill_5HT,desc,Label)"            "This is a 5-Axis Milling Machine With\n\
                                                                         Rotary Head and Table."
::msgcat::mcset pb_msg_english "MC(new,punch,desc,Label)"               "This is a Punch Machine."

::msgcat::mcset pb_msg_english "MC(new,post_unit,Label)"                "Post Output Unit"

::msgcat::mcset pb_msg_english "MC(new,inch,Label)"                     "Inches"
::msgcat::mcset pb_msg_english "MC(new,inch,Context)"                   "Post Processor Output Unit Inches"
::msgcat::mcset pb_msg_english "MC(new,millimeter,Label)"               "Millimeters"
::msgcat::mcset pb_msg_english "MC(new,millimeter,Context)"             "Post Processor Output Unit Millimeters"

::msgcat::mcset pb_msg_english "MC(new,machine,Label)"                  "Machine Tool"
::msgcat::mcset pb_msg_english "MC(new,machine,Context)"                "Machine tool type that the Post Processor to be created for."

::msgcat::mcset pb_msg_english "MC(new,mill,Label)"                     "Mill"
::msgcat::mcset pb_msg_english "MC(new,mill,Context)"                   "Milling Machine"
::msgcat::mcset pb_msg_english "MC(new,lathe,Label)"                    "Lathe"
::msgcat::mcset pb_msg_english "MC(new,lathe,Context)"                  "Lathe Machine"
::msgcat::mcset pb_msg_english "MC(new,wire,Label)"                     "Wire EDM"
::msgcat::mcset pb_msg_english "MC(new,wire,Context)"                   "Wire EDM Machine"
::msgcat::mcset pb_msg_english "MC(new,punch,Label)"                    "Punch"

::msgcat::mcset pb_msg_english "MC(new,axis,Label)"                     "Machine Axes Selection"
::msgcat::mcset pb_msg_english "MC(new,axis,Context)"                   "Number and type of machine axes"

#Axis Number
::msgcat::mcset pb_msg_english "MC(new,axis_2,Label)"                   "2-Axis"
::msgcat::mcset pb_msg_english "MC(new,axis_3,Label)"                   "3-Axis"
::msgcat::mcset pb_msg_english "MC(new,axis_4,Label)"                   "4-Axis"
::msgcat::mcset pb_msg_english "MC(new,axis_5,Label)"                   "5-Axis"
::msgcat::mcset pb_msg_english "MC(new,axis_XZC,Label)"                 "XZC"


#Axis Type
::msgcat::mcset pb_msg_english "MC(new,mach_axis,Label)"                "Machine Tool Axis"
::msgcat::mcset pb_msg_english "MC(new,mach_axis,Context)"              "Select the Machine Tool Axis"
::msgcat::mcset pb_msg_english "MC(new,lathe_2,Label)"                  "2-Axis"
::msgcat::mcset pb_msg_english "MC(new,mill_3,Label)"                   "3-Axis"
::msgcat::mcset pb_msg_english "MC(new,mill_3MT,Label)"                 "3-Axis Mill-Turn (XZC)"
::msgcat::mcset pb_msg_english "MC(new,mill_4T,Label)"                  "4-Axis with Rotary Table"
::msgcat::mcset pb_msg_english "MC(new,mill_4H,Label)"                  "4-Axis with Rotary Head"
::msgcat::mcset pb_msg_english "MC(new,lathe_4,Label)"                  "4-Axis"
::msgcat::mcset pb_msg_english "MC(new,mill_5HH,Label)"                 "5-Axis with Dual Rotary Heads"
::msgcat::mcset pb_msg_english "MC(new,mill_5TT,Label)"                 "5-Axis with Dual Rotary Tables"
::msgcat::mcset pb_msg_english "MC(new,mill_5HT,Label)"                 "5-Axis with Rotary Head and Table"
::msgcat::mcset pb_msg_english "MC(new,wedm_2,Label)"                   "2-Axis"
::msgcat::mcset pb_msg_english "MC(new,wedm_4,Label)"                   "4-Axis"
::msgcat::mcset pb_msg_english "MC(new,punch,Label)"                    "Punch"

::msgcat::mcset pb_msg_english "MC(new,control,Label)"                  "Controller"
::msgcat::mcset pb_msg_english "MC(new,control,Context)"                "Select the Post Controller."

#Controller Type
::msgcat::mcset pb_msg_english "MC(new,generic,Label)"                  "Generic"
::msgcat::mcset pb_msg_english "MC(new,library,Label)"                  "Library"
::msgcat::mcset pb_msg_english "MC(new,user,Label)"                     "User's"
::msgcat::mcset pb_msg_english "MC(new,user,browse,Label)"              "Browse"

# - Machine tool/ controller brands
::msgcat::mcset pb_msg_english "MC(new,allen,Label)"                    "Allen Bradley"
::msgcat::mcset pb_msg_english "MC(new,bridge,Label)"                   "Bridgeport"
::msgcat::mcset pb_msg_english "MC(new,brown,Label)"                    "Brown & Sharp"
::msgcat::mcset pb_msg_english "MC(new,cincin,Label)"                   "Cincinnatti Milacron"
::msgcat::mcset pb_msg_english "MC(new,kearny,Label)"                   "Kearny & Tracker"
::msgcat::mcset pb_msg_english "MC(new,fanuc,Label)"                    "Fanuc"
::msgcat::mcset pb_msg_english "MC(new,ge,Label)"                       "General Electric"
::msgcat::mcset pb_msg_english "MC(new,gn,Label)"                       "General Numerics"
::msgcat::mcset pb_msg_english "MC(new,gidding,Label)"                  "Gidding & Lewis"
::msgcat::mcset pb_msg_english "MC(new,heiden,Label)"                   "Heidenhain"
::msgcat::mcset pb_msg_english "MC(new,mazak,Label)"                    "Mazak"
::msgcat::mcset pb_msg_english "MC(new,seimens,Label)"                  "Seimens"

##-------------
## Open dialog
##
::msgcat::mcset pb_msg_english "MC(open,title,Label)"                   "Edit Post"
::msgcat::mcset pb_msg_english "MC(open,Status)"                        "Choose a PUI file to open."
::msgcat::mcset pb_msg_english "MC(open,file_type_pui)"                 "Post Builder Session Files"
::msgcat::mcset pb_msg_english "MC(open,file_type_tcl)"                 "Tcl Script Files"
::msgcat::mcset pb_msg_english "MC(open,file_type_def)"                 "Definition Files"
::msgcat::mcset pb_msg_english "MC(open,file_type_cdl)"                 "CDL Files"

##-------------
## Misc dialog
##
::msgcat::mcset pb_msg_english "MC(open_save,dlg,title,Label)"          "Select a file"
::msgcat::mcset pb_msg_english "MC(exp_cc,dlg,title,Label)"             "Export Custom Commands"
::msgcat::mcset pb_msg_english "MC(show_mt,title,Label)"                "Machine Tool"

##----------------
## Utils dialog
##
::msgcat::mcset pb_msg_english "MC(mvb,title,Label)"                    "MOM Variables Browser"
::msgcat::mcset pb_msg_english "MC(mvb,cat,Label)"                      "Category"
::msgcat::mcset pb_msg_english "MC(mvb,search,Label)"                   "Search"
::msgcat::mcset pb_msg_english "MC(mvb,defv,Label)"                     "Default Value"
::msgcat::mcset pb_msg_english "MC(mvb,posv,Label)"                     "Possible Values"
::msgcat::mcset pb_msg_english "MC(mvb,data,Label)"                     "Data Type"
::msgcat::mcset pb_msg_english "MC(mvb,desc,Label)"                     "Description"

::msgcat::mcset pb_msg_english "MC(inposts,title,Label)"                "Edit template_post.dat"
::msgcat::mcset pb_msg_english "MC(tpdf,text,Label)"                    "Template Posts Data File"
::msgcat::mcset pb_msg_english "MC(inposts,edit,title,Label)"           "Edit A Line"
::msgcat::mcset pb_msg_english "MC(inposts,edit,post,Label)"            "Post"


##----------------
## Save As dialog
##
::msgcat::mcset pb_msg_english "MC(save_as,title,Label)"                "Save As"
::msgcat::mcset pb_msg_english "MC(save_as,name,Label)"                 "Post Name"
::msgcat::mcset pb_msg_english "MC(save_as,name,Context)"               "The name that the Post Processor to be saved as."
::msgcat::mcset pb_msg_english "MC(save_as,Status)"                     "Enter the new Post file name."
::msgcat::mcset pb_msg_english "MC(save_as,file_type_pui)"              "Post Builder Session Files"

##----------------
## Common Widgets
##
::msgcat::mcset pb_msg_english "MC(common,entry,Label)"                 "Entry"
::msgcat::mcset pb_msg_english "MC(common,entry,Context)"               "You will specify new value in the entry field."

##-----------
## Note Book
##
::msgcat::mcset pb_msg_english "MC(nbook,tab,Label)"                    "Notebook Tab"
::msgcat::mcset pb_msg_english "MC(nbook,tab,Context)"                  "You may select a tab to go to the desired parameter page.\
                                                                         \n\
                                                                         \nThe parameters under a tab may be divided into groups. Each group of parameters can be accessed via another tab."

##------
## Tree
##
::msgcat::mcset pb_msg_english "MC(tree,select,Label)"                  "Component Tree"
::msgcat::mcset pb_msg_english "MC(tree,select,Context)"                "You may select a component to view or edit its content or parameters."
::msgcat::mcset pb_msg_english "MC(tree,create,Label)"                  "Create"
::msgcat::mcset pb_msg_english "MC(tree,create,Context)"                "Create a new component by copying the item selected."
::msgcat::mcset pb_msg_english "MC(tree,cut,Label)"                     "Cut"
::msgcat::mcset pb_msg_english "MC(tree,cut,Context)"                   "Cut a component."
::msgcat::mcset pb_msg_english "MC(tree,paste,Label)"                   "Paste"
::msgcat::mcset pb_msg_english "MC(tree,paste,Context)"                 "Paste a component."
::msgcat::mcset pb_msg_english "MC(tree,rename,Label)"                  "Rename"

##------------------
## Encrypt dialogs
##
::msgcat::mcset pb_msg_english "MC(encrypt,browser,Label)"              "Licenses List"
::msgcat::mcset pb_msg_english "MC(encrypt,title,Label)"                "Select A License"
::msgcat::mcset pb_msg_english "MC(encrypt,output,Label)"               "Encrypt Output"
::msgcat::mcset pb_msg_english "MC(encrypt,license,Label)"              "License :  "

#++++++++++++++
# Machine Tool
#++++++++++++++
::msgcat::mcset pb_msg_english "MC(machine,tab,Label)"                  "Machine Tool"
::msgcat::mcset pb_msg_english "MC(machine,Status)"                     "Specify Machine Kinematic Parameters."

::msgcat::mcset pb_msg_english "MC(msg,no_display)"                     "Image for this machine tool configuration is unavailable."
::msgcat::mcset pb_msg_english "MC(msg,no_4th_ctable)"                  "4th axis C table not allowed."
::msgcat::mcset pb_msg_english "MC(msg,no_4th_max_min)"                 "4th axis maximum axis limit can not be equal to minimum axis limit!"
::msgcat::mcset pb_msg_english "MC(msg,no_4th_both_neg)"                "4th axis limits can not both be negative!"
::msgcat::mcset pb_msg_english "MC(msg,no_4th_5th_plane)"               "Plane of the 4th axis can not be the same as that of the 5th axis."
::msgcat::mcset pb_msg_english "MC(msg,no_4thT_5thH)"                   "4th axis table and 5th axis head not allowed."
::msgcat::mcset pb_msg_english "MC(msg,no_5th_max_min)"                 "5th axis maximum axis limit can not be equal to minimum axis limit!"
::msgcat::mcset pb_msg_english "MC(msg,no_5th_both_neg)"                "5th axis limits can not both be negative."

##---------
# Post Info
##
::msgcat::mcset pb_msg_english "MC(machine,info,title,Label)"           "Post Information"
::msgcat::mcset pb_msg_english "MC(machine,info,desc,Label)"            "Description"
::msgcat::mcset pb_msg_english "MC(machine,info,type,Label)"            "Machine Type"
::msgcat::mcset pb_msg_english "MC(machine,info,kinematics,Label)"      "Kinematics"
::msgcat::mcset pb_msg_english "MC(machine,info,unit,Label)"            "Output Unit"
::msgcat::mcset pb_msg_english "MC(machine,info,controller,Label)"      "Controller"
::msgcat::mcset pb_msg_english "MC(machine,info,history,Label)"         "History"

##---------
## Display
##
::msgcat::mcset pb_msg_english "MC(machine,display,Label)"              "Display Machine Tool"
::msgcat::mcset pb_msg_english "MC(machine,display,Context)"            "This option Displays Machine Tool"
::msgcat::mcset pb_msg_english "MC(machine,display_trans,title,Label)"  "Machine Tool"


##---------------
## General parms
##
::msgcat::mcset pb_msg_english "MC(machine,gen,Label)"                      "General Parameters"
    
::msgcat::mcset pb_msg_english "MC(machine,gen,out_unit,Label)"             "Post Output Unit :"
::msgcat::mcset pb_msg_english "MC(machine,gen,out_unit,Context)"           "Post Processing Output Unit"
::msgcat::mcset pb_msg_english "MC(machine,gen,out_unit,inch,Label)"        "Inch" 
::msgcat::mcset pb_msg_english "MC(machine,gen,out_unit,metric,Label)"      "Metric"

::msgcat::mcset pb_msg_english "MC(machine,gen,travel_limit,Label)"         "Linear Axis Travel Limits"
::msgcat::mcset pb_msg_english "MC(machine,gen,travel_limit,Context)"       "Linear Axis Travel Limits"
::msgcat::mcset pb_msg_english "MC(machine,gen,travel_limit,x,Label)"       "X"
::msgcat::mcset pb_msg_english "MC(machine,gen,travel_limit,x,Context)"     "Specify Machine Travel limit along X - axis."
::msgcat::mcset pb_msg_english "MC(machine,gen,travel_limit,y,Label)"       "Y"
::msgcat::mcset pb_msg_english "MC(machine,gen,travel_limit,y,Context)"     "Specify Machine Travel limit along Y - axis."
::msgcat::mcset pb_msg_english "MC(machine,gen,travel_limit,z,Label)"       "Z"
::msgcat::mcset pb_msg_english "MC(machine,gen,travel_limit,z,Context)"     "Specify Machine Travel limit along Z - axis."

::msgcat::mcset pb_msg_english "MC(machine,gen,home_pos,Label)"             "Home Position"
::msgcat::mcset pb_msg_english "MC(machine,gen,home_pos,Context)"           "Home Position"
::msgcat::mcset pb_msg_english "MC(machine,gen,home_pos,x,Label)"           "X"
::msgcat::mcset pb_msg_english "MC(machine,gen,home_pos,x,Context)"         "Machine home position of X-axis with respect to the physical zero position of the axis.  Machine returns to this position for auto tool change."
::msgcat::mcset pb_msg_english "MC(machine,gen,home_pos,y,Label)"           "Y"
::msgcat::mcset pb_msg_english "MC(machine,gen,home_pos,y,Context)"         "Machine home position of Y-axis with respect to the physical zero position of the axis.  Machine returns to this position for auto tool change."
::msgcat::mcset pb_msg_english "MC(machine,gen,home_pos,z,Label)"           "Z"
::msgcat::mcset pb_msg_english "MC(machine,gen,home_pos,z,Context)"         "Machine home position of Z-axis with respect to the physical zero position of the axis.  Machine returns to this position for auto tool change."

::msgcat::mcset pb_msg_english "MC(machine,gen,step_size,Label)"            "Linear Motion Resolution"
::msgcat::mcset pb_msg_english "MC(machine,gen,step_size,min,Label)"        "Minimum"
::msgcat::mcset pb_msg_english "MC(machine,gen,step_size,min,Context)"      "Minimum Resolution"

::msgcat::mcset pb_msg_english "MC(machine,gen,traverse_feed,Label)"        "Traversal Feed Rate"
::msgcat::mcset pb_msg_english "MC(machine,gen,traverse_feed,max,Label)"    "Maximum"
::msgcat::mcset pb_msg_english "MC(machine,gen,traverse_feed,max,Context)"  "Maximum Feed Rate"

::msgcat::mcset pb_msg_english "MC(machine,gen,circle_record,Label)"        "Output Circular Record"
::msgcat::mcset pb_msg_english "MC(machine,gen,circle_record,yes,Label)"    "Yes"
::msgcat::mcset pb_msg_english "MC(machine,gen,circle_record,yes,Context)"  "Output Circular Record."
::msgcat::mcset pb_msg_english "MC(machine,gen,circle_record,no,Label)"     "No"
::msgcat::mcset pb_msg_english "MC(machine,gen,circle_record,no,Context)"   "Output Linear Record."

::msgcat::mcset pb_msg_english "MC(machine,gen,config_4and5_axis,oth,Label)"    "Other"

# Wire EDM parameters
::msgcat::mcset pb_msg_english "MC(machine,gen,wedm,wire_tilt)"             "Wire Tilt Control"
::msgcat::mcset pb_msg_english "MC(machine,gen,wedm,angle)"                 "Angles"
::msgcat::mcset pb_msg_english "MC(machine,gen,wedm,coord)"                 "Coordinates"

# Lathe parameters
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,Label)"               "Turret"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,Context)"             "Turret"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,conf,Label)"          "Configure"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,conf,Context)"        "When Two Turrets is selected, this option allows you to configure the parameters."
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,one,Label)"           "One Turret"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,one,Context)"         "One Turret Lathe Machine"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,two,Label)"           "Two Turrets"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,two,Context)"         "Two Turrets Lathe Machine"

::msgcat::mcset pb_msg_english "MC(machine,gen,turret,conf_trans,Label)"    "Turret Configuration"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,prim,Label)"          "Primary Turret"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,prim,Context)"        "Select the Designation of Primary Turret."
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,sec,Label)"           "Secondary Turret"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,sec,Context)"         "Select the Designation of Secondary Turret."
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,designation,Label)"   "Designation"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,xoff,Label)"          "X Offset"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,xoff,Context)"        "Specify the X Offset."
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,zoff,Label)"          "Z Offset"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,zoff,Context)"        "Specify the Z Offset."

::msgcat::mcset pb_msg_english "MC(machine,gen,turret,front,Label)"         "FRONT"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,rear,Label)"          "REAR"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,right,Label)"         "RIGHT"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,left,Label)"          "LEFT"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,side,Label)"          "SIDE"
::msgcat::mcset pb_msg_english "MC(machine,gen,turret,saddle,Label)"        "SADDLE"

::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,Label)"           "Axis Multipliers"
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,dia,Label)"       "Diameter Programming"
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,dia,Context)"     "These options allow you to enable the Diameter Programming by doubling the values of selected addresses in the N/C output."
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,2x,Label)"        "2X"
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,2x,Context)"      "This switch allows you to enable the Diameter Programming by doubling the X-axis coordinates in the N/C output."

::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,2y,Label)"        "2Y"
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,2y,Context)"      "This switch allows you to enable the Diameter Programming by doubling the Y-axis coordinates in the N/C output."
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,2i,Label)"        "2I"
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,2i,Context)"      "This switch allows you to double the values of I of circular records when Diameter Programming is used."
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,2j,Label)"        "2J"
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,2j,Context)"      "This switch allows you to double the values of J of circular records when Diameter Programming is used."

::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,mir,Label)"       "Mirror Output"
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,mir,Context)"     "These options allow you to mirror the selected addresses by negating their values in the N/C output."
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,x,Label)"         "-X"
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,x,Context)"       "This switch allows you to negate the X-axis coordinates in the N/C output."
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,y,Label)"         "-Y"
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,y,Context)"       "This switch allows you to negate the Y-axis coordinates in the N/C output."
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,z,Label)"         "-Z"
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,z,Context)"       "This switch allows you to negate the Z-axis coordinates in the N/C output."
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,i,Label)"         "-I"
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,i,Context)"       "This switch allows you to negate the values of I of circular records in the N/C output."
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,j,Label)"         "-J"
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,j,Context)"       "This switch allows you to negate the values of J of circular records in the N/C output."
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,k,Label)"         "-K"
::msgcat::mcset pb_msg_english "MC(machine,gen,axis_multi,k,Context)"       "This switch allows you to negate the values of K of circular records in the N/C output."

::msgcat::mcset pb_msg_english "MC(machine,gen,output,Label)"               "Output Method"
::msgcat::mcset pb_msg_english "MC(machine,gen,output,Context)"             "Output Method"
::msgcat::mcset pb_msg_english "MC(machine,gen,output,tool_tip,Label)"      "Tool Tip"
::msgcat::mcset pb_msg_english "MC(machine,gen,output,tool_tip,Context)"    "Output with respect to Tool Tip"
::msgcat::mcset pb_msg_english "MC(machine,gen,output,turret_ref,Label)"    "Turret Reference"
::msgcat::mcset pb_msg_english "MC(machine,gen,output,turret_ref,Context)"  "Output with respect to Turret Reference"

::msgcat::mcset pb_msg_english "MC(machine,gen,lathe_turret,msg)"           "Designation of the Primary Turrent can not be the same as that of the Secondary Turret."
::msgcat::mcset pb_msg_english "MC(machine,gen,turret_chg,msg)"             "Change of this option may require addition or deletion of a G92 block in the Tool Change events."
# Entries for XZC/Mill-Turn
::msgcat::mcset pb_msg_english "MC(machine,gen,spindle_axis,Label)"             "Initial Spindle Axis"
::msgcat::mcset pb_msg_english "MC(machine,gen,spindle_axis,Context)"           "Initial spindle axis designated for the live milling tool can be specified as either parallel to the Z axis or perpendicular to the Z axis.  The tool axis of the operation must be consistent with the specified spindle axis.  An error will occur if the post cannot position to the specified spindle axis.\
                                                                                 \nThis vector may be overridden by the spindle axis specified with a Head object."

::msgcat::mcset pb_msg_english "MC(machine,gen,position_in_yaxis,Label)"        "Position in Y-Axis"
::msgcat::mcset pb_msg_english "MC(machine,gen,position_in_yaxis,Context)"      "Machine has a programmable Y-axis that can position during the contouring.  This option is only applicable when the Spindle Axis is not along Z-axis."

::msgcat::mcset pb_msg_english "MC(machine,gen,mach_mode,Label)"                "Machine Mode"
::msgcat::mcset pb_msg_english "MC(machine,gen,mach_mode,Context)"              "Machine Mode can be either XZC-Mill or Simple Mill-Turn."

::msgcat::mcset pb_msg_english "MC(machine,gen,mach_mode,xzc_mill,Label)"       "XZC Mill"
::msgcat::mcset pb_msg_english "MC(machine,gen,mach_mode,xzc_mill,Context)"     "An XZC mill will have a table or a chuck face locked on a mill-turn machine as the rotary C axis.  All XY moves will be converted to X and C with X being a radius value and C the angle."

::msgcat::mcset pb_msg_english "MC(machine,gen,mach_mode,mill_turn,Label)"      "Simple Mill-Turn"
::msgcat::mcset pb_msg_english "MC(machine,gen,mach_mode,mill_turn,Context)"    "This XZC mill post will be linked to a lathe post to process a program that contains both milling and turning operations.  The operation type will determine which post to use for producing the N/C outputs."

::msgcat::mcset pb_msg_english "MC(machine,gen,mill_turn,lathe_post,Label)"     "Lathe Post"
::msgcat::mcset pb_msg_english "MC(machine,gen,mill_turn,lathe_post,Context)"   "A lathe post is required for a Simple Mill-Turn post to postprocess the turning operations in a program."

::msgcat::mcset pb_msg_english "MC(machine,gen,lathe_post,select_name,Label)"   "Select Name"
::msgcat::mcset pb_msg_english "MC(machine,gen,lathe_post,select_name,Context)" "Select the name of a lathe post to be used in a Simple Mill-Turn post.  Presumably, this post will be found in the \\\$UGII_CAM_POST_DIR directory at the NX/Post run-time, otherwise a post with the same name in the directory where the mill post resides will be used."

::msgcat::mcset pb_msg_english "MC(machine,gen,coord_mode,Label)"               "Default Coordinate Mode"
::msgcat::mcset pb_msg_english "MC(machine,gen,coord_mode,Context)"             "This options defines the initial setting for the coordinate output mode to be Polar (XZC) or Cartesian (XYZ).  This mode can be altered by the \\\"SET/POLAR,ON\\\" UDE's programmed with the operations."

::msgcat::mcset pb_msg_english "MC(machine,gen,coord_mode,polar,Label)"         "Polar"
::msgcat::mcset pb_msg_english "MC(machine,gen,coord_mode,polar,Context)"       "Coordinate output in XZC."

::msgcat::mcset pb_msg_english "MC(machine,gen,coord_mode,cart,Label)"          "Cartesian"
::msgcat::mcset pb_msg_english "MC(machine,gen,coord_mode,cart,Context)"        "Coordinate output in XYZ."

::msgcat::mcset pb_msg_english "MC(machine,gen,xzc_arc_mode,Label)"             "Circular Record Mode"
::msgcat::mcset pb_msg_english "MC(machine,gen,xzc_arc_mode,Context)"           "This options defines the circular records output to be in Polar (XCR) or Cartesian (XYIJ) mode."

::msgcat::mcset pb_msg_english "MC(machine,gen,xzc_arc_mode,polar,Label)"       "Polar"
::msgcat::mcset pb_msg_english "MC(machine,gen,xzc_arc_mode,polar,Context)"     "Circular Output in XCR."

::msgcat::mcset pb_msg_english "MC(machine,gen,xzc_arc_mode,cart,Label)"        "Cartesian"
::msgcat::mcset pb_msg_english "MC(machine,gen,xzc_arc_mode,cart,Context)"      "Circular Output in XYIJ."

::msgcat::mcset pb_msg_english "MC(machine,gen,def_spindle_axis,Label)"         "Initial Spindle Axis"
::msgcat::mcset pb_msg_english "MC(machine,gen,def_spindle_axis,Context)"       "Initial spindle axis may be overridden by the spindle axis specified with a Head object.\
                                                                                 \nThe vector does not need to be unitized."


##-----------------
## 4-th Axis parms
##
::msgcat::mcset pb_msg_english "MC(machine,axis,fourth,Label)"              "Fourth Axis"

::msgcat::mcset pb_msg_english "MC(machine,axis,radius_output,Label)"       "Radius Output"
::msgcat::mcset pb_msg_english "MC(machine,axis,radius_output,Context)"     "When the tool axis is along Z-axis (0,0,1), the post has the choice of outputting the radius (X) of the polar coordinates to be \\\"Always Positive\\\", \\\"Always Negative\\\" or \\\"Shortest Distance\\\"."

::msgcat::mcset pb_msg_english "MC(machine,axis,type_head,Label)"           "Head"
::msgcat::mcset pb_msg_english "MC(machine,axis,type_table,Label)"          "Table"

##-----------------
## 5-th Axis parms
##
::msgcat::mcset pb_msg_english "MC(machine,axis,fifth,Label)"               "Fifth Axis"

::msgcat::mcset pb_msg_english "MC(machine,axis,rotary,Label)"              "Rotary Axis"

::msgcat::mcset pb_msg_english "MC(machine,axis,offset,Label)"              "Machine Zero To Rotary Axis Center"
::msgcat::mcset pb_msg_english "MC(machine,axis,offset,4,Label)"            "Machine Zero To 4th Axis Center"
::msgcat::mcset pb_msg_english "MC(machine,axis,offset,5,Label)"            "4th Axis Center To 5th Axis Center"
::msgcat::mcset pb_msg_english "MC(machine,axis,offset,x,Label)"            "X Offset"
::msgcat::mcset pb_msg_english "MC(machine,axis,offset,x,Context)"          "Specify Rotary Axis X Offset."
::msgcat::mcset pb_msg_english "MC(machine,axis,offset,y,Label)"            "Y Offset"
::msgcat::mcset pb_msg_english "MC(machine,axis,offset,y,Context)"          "Specify Rotary Axis Y Offset."
::msgcat::mcset pb_msg_english "MC(machine,axis,offset,z,Label)"            "Z Offset"
::msgcat::mcset pb_msg_english "MC(machine,axis,offset,z,Context)"          "Specify Rotary Axis Z Offset."

::msgcat::mcset pb_msg_english "MC(machine,axis,rotation,Label)"            "Axis Rotation"
::msgcat::mcset pb_msg_english "MC(machine,axis,rotation,norm,Label)"       "Normal"
::msgcat::mcset pb_msg_english "MC(machine,axis,rotation,norm,Context)"     "Set Axis Rotation Direction to Normal."
::msgcat::mcset pb_msg_english "MC(machine,axis,rotation,rev,Label)"        "Reversed"
::msgcat::mcset pb_msg_english "MC(machine,axis,rotation,rev,Context)"      "Set Axis Rotation Direction to Reversed."

::msgcat::mcset pb_msg_english "MC(machine,axis,direction,Label)"           "Axis Direction"
::msgcat::mcset pb_msg_english "MC(machine,axis,direction,Context)"         "Select the Axis Direction."

::msgcat::mcset pb_msg_english "MC(machine,axis,con_motion,Label)"              "Consecutive Rotary Motions"
::msgcat::mcset pb_msg_english "MC(machine,axis,con_motion,combine,Label)"      "Combined"
::msgcat::mcset pb_msg_english "MC(machine,axis,con_motion,combine,Context)"    "This switch allows you to enable/ disable the linearation. It will enable/ disable the Tolerance option."
::msgcat::mcset pb_msg_english "MC(machine,axis,con_motion,tol,Label)"      "Tolerance"
::msgcat::mcset pb_msg_english "MC(machine,axis,con_motion,tol,Context)"    "This option is active only when the Combined switch is active. Specify the Tolerance."

::msgcat::mcset pb_msg_english "MC(machine,axis,violation,Label)"           "Axis Limit Violation Handling"
::msgcat::mcset pb_msg_english "MC(machine,axis,violation,warn,Label)"      "Warning"
::msgcat::mcset pb_msg_english "MC(machine,axis,violation,warn,Context)"    "Output Warnings on Axis limit Violation."
::msgcat::mcset pb_msg_english "MC(machine,axis,violation,ret,Label)"       "Retract / Re-Engage"
::msgcat::mcset pb_msg_english "MC(machine,axis,violation,ret,Context)"     "Retract / Re-Engage on Axis limit Violation.\
                                                                             \n\
                                                                             \nIn custom command PB_CMD_init_rotaty, the following parameters can be adjusted to achieve the desired moves:\
                                                                             \n\
                                                                             \n   mom_kin_retract_type\
                                                                             \n   mom_kin_retract_distance\
                                                                             \n   mom_kin_reengage_distance"

::msgcat::mcset pb_msg_english "MC(machine,axis,limits,Label)"              "Axis Limits (Deg)"
::msgcat::mcset pb_msg_english "MC(machine,axis,limits,min,Label)"          "Minimum"
::msgcat::mcset pb_msg_english "MC(machine,axis,limits,min,Context)"        "Specify Minimum Rotary Axis limit (Deg)."
::msgcat::mcset pb_msg_english "MC(machine,axis,limits,max,Label)"          "Maximum"
::msgcat::mcset pb_msg_english "MC(machine,axis,limits,max,Context)"        "Specify Maximum Rotary Axis limit (Deg)."

::msgcat::mcset pb_msg_english "MC(machine,axis,incr_text)"                 "This Rotary Axis Can Be Incremental"

::msgcat::mcset pb_msg_english "MC(machine,axis,rotary_res,Label)"          "Rotary Motion Resolution (Deg)"
::msgcat::mcset pb_msg_english "MC(machine,axis,rotary_res,Context)"        "Specify Rotary Motion Resolution (Deg)."

::msgcat::mcset pb_msg_english "MC(machine,axis,ang_offset,Label)"          "Angular Offset  (Deg)"
::msgcat::mcset pb_msg_english "MC(machine,axis,ang_offset,Context)"        "Specify the Axis Angular Offset (Deg)."

::msgcat::mcset pb_msg_english "MC(machine,axis,pivot,Label)"               "Pivot Distance"
::msgcat::mcset pb_msg_english "MC(machine,axis,pivot,Context)"             "Specify Pivot Distance."

::msgcat::mcset pb_msg_english "MC(machine,axis,max_feed,Label)"            "Max. Feed Rate (Deg/Min)"
::msgcat::mcset pb_msg_english "MC(machine,axis,max_feed,Context)"          "Specify Maximum Feed Rate (Deg/Min)."

::msgcat::mcset pb_msg_english "MC(machine,axis,plane,Label)"               "Plane of Rotation"
::msgcat::mcset pb_msg_english "MC(machine,axis,plane,Context)"             "Select XY, YZ, ZX or Other as Plane of Rotation. \\\"Other\\\" option allows you to specify an arbitary vector."

::msgcat::mcset pb_msg_english "MC(machine,axis,plane,normal,Label)"        "Plane Normal Vector"
::msgcat::mcset pb_msg_english "MC(machine,axis,plane,normal,Context)"      "Specify Plane Normal Vector as axis of rotation.\
                                                                             \nThe vector does not need to be unitized."
::msgcat::mcset pb_msg_english "MC(machine,axis,plane,4th,Label)"           "4th Axis Plane Normal"
::msgcat::mcset pb_msg_english "MC(machine,axis,plane,4th,Context)"         "Specify a plnae normal vector for 4th axis rotation."
::msgcat::mcset pb_msg_english "MC(machine,axis,plane,5th,Label)"           "5th Axis Plane Normal"
::msgcat::mcset pb_msg_english "MC(machine,axis,plane,5th,Context)"         "Specify a plnae normal vector for 5th axis rotation."

::msgcat::mcset pb_msg_english "MC(machine,axis,leader,Label)"              "Word Leader"
::msgcat::mcset pb_msg_english "MC(machine,axis,leader,Context)"            "Specify the Word Leader."

::msgcat::mcset pb_msg_english "MC(machine,axis,config,Label)"              "Configure"
::msgcat::mcset pb_msg_english "MC(machine,axis,config,Context)"            "This option allows you to define the 4th & 5th axis parameters."

::msgcat::mcset pb_msg_english "MC(machine,axis,r_axis_conf_trans,Label)"   "Rotary Axis Configuration"
::msgcat::mcset pb_msg_english "MC(machine,axis,4th_axis,Label)"            "4th Axis"
::msgcat::mcset pb_msg_english "MC(machine,axis,5th_axis,Label)"            "5th Axis"
::msgcat::mcset pb_msg_english "MC(machine,axis,head,Label)"                " Head "
::msgcat::mcset pb_msg_english "MC(machine,axis,table,Label)"               " Table "

::msgcat::mcset pb_msg_english "MC(machine,axis,rotary_lintol,Label)"       "Default Linearization Tolerance"
::msgcat::mcset pb_msg_english "MC(machine,axis,rotary_lintol,Context)"     "This value will be used as the default tolerance to linearize the rotary moves when the LINTOL/ON post command is specified with current or preceding operation(s).  LINTOL/ command can also specify a different linearization tolerance."

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
::msgcat::mcset pb_msg_english "MC(progtpth,tab,Label)"                 "Program & Tool Path"

##---------
## Program
##
::msgcat::mcset pb_msg_english "MC(prog,tab,Label)"                     "Program"
::msgcat::mcset pb_msg_english "MC(prog,Status)"                        "Define the output of Events"

::msgcat::mcset pb_msg_english "MC(prog,tree,Label)"                    "Program -- Sequence Tree"
::msgcat::mcset pb_msg_english "MC(prog,tree,Context)"                  "A N/C program is divided into five segments: four(4) Sequences and the body of the tool path:\
                                                                         \n\
                                                                         \n * Program Start Sequence\
                                                                         \n * Operation Start Sequence\
                                                                         \n * Tool Path\
                                                                         \n * Operation End Sequence\
                                                                         \n * Program End Sequence\
                                                                         \n\
                                                                         \nEach Sequence consists of a series of Markers. A Marker indicates an event that can be programmed and may occur at a particular stage of a N/C program. You may attach each Marker with a particular arrangement of N/C codes to be output when the program is Post processed.\
                                                                         \n\
                                                                         \nTool path is made up of numerous Events. They are divided into three(3) groups:\
                                                                         \n\
                                                                         \n * Machine Control\
                                                                         \n * Motions\
                                                                         \n * Cycles\
                                                                         \n"

::msgcat::mcset pb_msg_english "MC(prog,tree,prog_strt,Label)"          "Program Start Sequence"
::msgcat::mcset pb_msg_english "MC(prog,tree,prog_end,Label)"           "Program End Sequence"
::msgcat::mcset pb_msg_english "MC(prog,tree,oper_strt,Label)"          "Operation Start Sequence"
::msgcat::mcset pb_msg_english "MC(prog,tree,oper_end,Label)"           "Operation End Sequence"
::msgcat::mcset pb_msg_english "MC(prog,tree,tool_path,Label)"          "Tool Path"
::msgcat::mcset pb_msg_english "MC(prog,tree,tool_path,mach_cnt,Label)" "Machine Control"
::msgcat::mcset pb_msg_english "MC(prog,tree,tool_path,motion,Label)"   "Motion"
::msgcat::mcset pb_msg_english "MC(prog,tree,tool_path,cycle,Label)"    "Canned Cycles"
::msgcat::mcset pb_msg_english "MC(prog,tree,linked_posts,Label)"       "Linked Posts Sequence"

::msgcat::mcset pb_msg_english "MC(prog,add,Label)"                     "Sequence -- Add Block"
::msgcat::mcset pb_msg_english "MC(prog,add,Context)"                   "You may add a new Block to a Sequence by pressing this button and dragging it to the desired Marker.  Blocks can also be attached next to, above or below an existing Block."

::msgcat::mcset pb_msg_english "MC(prog,trash,Label)"                   "Sequence -- Trash Can"
::msgcat::mcset pb_msg_english "MC(prog,trash,Context)"                 "You may dispose any unwanted Blocks from the Sequence by dragging them to this trash can."

::msgcat::mcset pb_msg_english "MC(prog,block,Label)"                   "Sequence -- Block"
::msgcat::mcset pb_msg_english "MC(prog,block,Context)"                 "You may delete any unwanted Block in the Sequence by dragging it to the trash can.\
                                                                         \n\
                                                                         \nYou may also activate a pop-up menu by pressing the right mouse button.  Several services will be available on the menu :\
                                                                         \n\
                                                                         \n * Edit\
                                                                         \n * Force Output\
                                                                         \n * Cut\
                                                                         \n * Copy As\
                                                                         \n * Paste\
                                                                         \n * Delete\
                                                                         \n"

::msgcat::mcset pb_msg_english "MC(prog,select,Label)"                  "Sequence -- Block Selection"
::msgcat::mcset pb_msg_english "MC(prog,select,Context)"                "You may select type of Block component that you want to add to the Sequence from this list.\
                                                                         \n\Available component types are :\
                                                                         \n\
                                                                         \n * New Block\
                                                                         \n * Existing N/C Block\
                                                                         \n * Operator Message\
                                                                         \n * Custom Command\
                                                                         \n"

::msgcat::mcset pb_msg_english "MC(prog,oper_temp,Label)"               "Select A Sequence Template"
::msgcat::mcset pb_msg_english "MC(prog,add_block,Label)"               "Add Block"
::msgcat::mcset pb_msg_english "MC(prog,seq_comb_nc,Label)"             "Display Combined N/C Code Blocks"
::msgcat::mcset pb_msg_english "MC(prog,seq_comb_nc,Context)"           "This button allows you to display the contents of a Sequence in terms of Blocks or N/C codes.\
                                                                         \n\
                                                                         \nN/C codes will display the Words in proper order."

::msgcat::mcset pb_msg_english "MC(prog,plus,Label)"                    "Program -- Collapse / Expnad switch"
::msgcat::mcset pb_msg_english "MC(prog,plus,Context)"                  "This button allows you collapse or expand the branches of this component."

::msgcat::mcset pb_msg_english "MC(prog,marker,Label)"                  "Sequence -- Marker"
::msgcat::mcset pb_msg_english "MC(prog,marker,Context)"                "The Markers of a Sequence indicate the possible events that can be programmed and may occur in sequence at a particular stage of a N/C program.\
                                                                         \n\
                                                                         \nYou may attach/ arrange Blocks to be output at each Marker."

::msgcat::mcset pb_msg_english "MC(prog,event,Label)"                   "Program -- Event"
::msgcat::mcset pb_msg_english "MC(prog,event,Context)"                 "You can edit each Event with a single left-mouse click."

::msgcat::mcset pb_msg_english "MC(prog,nc_code,Label)"                 "Program -- N/C Code"
::msgcat::mcset pb_msg_english "MC(prog,nc_code,Context)"               "Text in this box display the representative N/C code to be output at this Marker or from this Event."
::msgcat::mcset pb_msg_english "MC(prog,undo_popup,Label)"              "Undo"

## Sequence
##
::msgcat::mcset pb_msg_english "MC(seq,combo,new,Label)"                "New Block"
::msgcat::mcset pb_msg_english "MC(seq,combo,comment,Label)"            "Operator Message"
::msgcat::mcset pb_msg_english "MC(seq,combo,custom,Label)"             "Custom Command"

::msgcat::mcset pb_msg_english "MC(seq,new_trans,title,Label)"          "Block"
::msgcat::mcset pb_msg_english "MC(seq,cus_trans,title,Label)"          "Custom Command"
::msgcat::mcset pb_msg_english "MC(seq,oper_trans,title,Label)"         "Operator Message"

::msgcat::mcset pb_msg_english "MC(seq,edit_popup,Label)"               "Edit"
::msgcat::mcset pb_msg_english "MC(seq,force_popup,Label)"              "Force Output"
::msgcat::mcset pb_msg_english "MC(seq,rename_popup,Label)"             "Rename"
::msgcat::mcset pb_msg_english "MC(seq,rename_popup,Context)"           "You can specify the name for this component."
::msgcat::mcset pb_msg_english "MC(seq,cut_popup,Label)"                "Cut"
::msgcat::mcset pb_msg_english "MC(seq,copy_popup,Label)"               "Copy As"
::msgcat::mcset pb_msg_english "MC(seq,copy_popup,ref,Label)"           "Referenced Block(s)"
::msgcat::mcset pb_msg_english "MC(seq,copy_popup,new,Label)"           "New Block(s)"
::msgcat::mcset pb_msg_english "MC(seq,paste_popup,Label)"              "Paste"
::msgcat::mcset pb_msg_english "MC(seq,paste_popup,before,Label)"       "Before"
::msgcat::mcset pb_msg_english "MC(seq,paste_popup,inline,Label)"       "Inline"
::msgcat::mcset pb_msg_english "MC(seq,paste_popup,after,Label)"        "After"
::msgcat::mcset pb_msg_english "MC(seq,del_popup,Label)"                "Delete"

::msgcat::mcset pb_msg_english "MC(seq,force_trans,title,Label)"        "Force Output Once"

##--------------
## Toolpath
##
::msgcat::mcset pb_msg_english "MC(tool,event_trans,title,Label)"       "Event"

::msgcat::mcset pb_msg_english "MC(tool,event_seq,button,Label)"        "Select An Event Template"
::msgcat::mcset pb_msg_english "MC(tool,add_word,button,Label)"         "Add Word"

::msgcat::mcset pb_msg_english "MC(tool,format_trans,title,Label)"      "FORMAT"

::msgcat::mcset pb_msg_english "MC(tool,circ_trans,title,Label)"        "Circular Move -- Plane Codes"
::msgcat::mcset pb_msg_english "MC(tool,circ_trans,frame,Label)"        " Plane G Codes "
::msgcat::mcset pb_msg_english "MC(tool,circ_trans,xy,Label)"           "XY Plane"
::msgcat::mcset pb_msg_english "MC(tool,circ_trans,yz,Label)"           "YZ Plane"
::msgcat::mcset pb_msg_english "MC(tool,circ_trans,zx,Label)"           "ZX Plane"

::msgcat::mcset pb_msg_english "MC(tool,ijk_desc,arc_start,Label)"          "Arc Start To Center"
::msgcat::mcset pb_msg_english "MC(tool,ijk_desc,arc_center,Label)"         "Arc Center To Start"
::msgcat::mcset pb_msg_english "MC(tool,ijk_desc,u_arc_start,Label)"        "Unsigned Arc Start To Center"
::msgcat::mcset pb_msg_english "MC(tool,ijk_desc,absolute,Label)"           "Absolute Arc Center"
::msgcat::mcset pb_msg_english "MC(tool,ijk_desc,long_thread_lead,Label)"   "Longitudinal Thread Lead"
::msgcat::mcset pb_msg_english "MC(tool,ijk_desc,tran_thread_lead,Label)"   "Transversal Thread Lead"

::msgcat::mcset pb_msg_english "MC(tool,spindle,range,type,Label)"              "Spindle Range Type"
::msgcat::mcset pb_msg_english "MC(tool,spindle,range,range_M,Label)"           "Separate Range M Code (M41)"
::msgcat::mcset pb_msg_english "MC(tool,spindle,range,with_spindle_M,Label)"    "Range Number with Spindle M Code (M13)"
::msgcat::mcset pb_msg_english "MC(tool,spindle,range,hi_lo_with_S,Label)"      "High/Low Range with S Code (S+100)"
::msgcat::mcset pb_msg_english "MC(tool,spindle,range,nonzero_range,msg)"       "The number of Spindle Ranges must be greater than zero."

::msgcat::mcset pb_msg_english "MC(tool,spindle_trans,title,Label)"         "Spindle Range Code Table"
::msgcat::mcset pb_msg_english "MC(tool,spindle_trans,range,Label)"         "Range"
::msgcat::mcset pb_msg_english "MC(tool,spindle_trans,code,Label)"          "Code"
::msgcat::mcset pb_msg_english "MC(tool,spindle_trans,min,Label)"           "Minimum (RPM)"
::msgcat::mcset pb_msg_english "MC(tool,spindle_trans,max,Label)"           "Maximum (RPM)"

::msgcat::mcset pb_msg_english "MC(tool,spindle_desc,sep,Label)"            " Separate Range M Code (M41, M42 ...) "
::msgcat::mcset pb_msg_english "MC(tool,spindle_desc,range,Label)"          " Range Number with Spindle M Code (M13, M23 ...)"
::msgcat::mcset pb_msg_english "MC(tool,spindle_desc,high,Label)"           " High/Low Range with S Code (S+100/S-100)"
::msgcat::mcset pb_msg_english "MC(tool,spindle_desc,odd,Label)"            " Odd/Even Range with S Code"


::msgcat::mcset pb_msg_english "MC(tool,config,mill_opt1,Label)"            "Tool Number"
::msgcat::mcset pb_msg_english "MC(tool,config,mill_opt2,Label)"            "Tool Number And Length Offset Number"
::msgcat::mcset pb_msg_english "MC(tool,config,mill_opt3,Label)"            "Length Offset Number And Tool Number"

::msgcat::mcset pb_msg_english "MC(tool,config,title,Label)"                "Tool Code Configuration"
::msgcat::mcset pb_msg_english "MC(tool,config,output,Label)"               "Output"

::msgcat::mcset pb_msg_english "MC(tool,config,lathe_opt1,Label)"           "Tool Number"
::msgcat::mcset pb_msg_english "MC(tool,config,lathe_opt2,Label)"           "Tool Number And Length Offset Number"
::msgcat::mcset pb_msg_english "MC(tool,config,lathe_opt3,Label)"           "Turret Index and Tool Number"
::msgcat::mcset pb_msg_english "MC(tool,config,lathe_opt4,Label)"           "Turret Index Tool Number And Length Offset Number"

::msgcat::mcset pb_msg_english "MC(tool,conf_desc,num,Label)"               "Tool Number"
::msgcat::mcset pb_msg_english "MC(tool,conf_desc,next_num,Label)"          "Next Tool Number"
::msgcat::mcset pb_msg_english "MC(tool,conf_desc,index_num,Label)"         "Turret Index And Tool Number"
::msgcat::mcset pb_msg_english "MC(tool,conf_desc,index_next_num,Label)"    "Turret Index And Next Tool Number"
::msgcat::mcset pb_msg_english "MC(tool,conf_desc,num_len,Label)"           "Tool Number And Length Offset Number"
::msgcat::mcset pb_msg_english "MC(tool,conf_desc,next_num_len,Label)"      "Next Tool Number And Length Offset Number"
::msgcat::mcset pb_msg_english "MC(tool,conf_desc,len_num,Label)"           "Length Offset Number And Tool Number"
::msgcat::mcset pb_msg_english "MC(tool,conf_desc,len_next_num,Label)"      "Length Offset Number And Next Tool Number"
::msgcat::mcset pb_msg_english "MC(tool,conf_desc,index_num_len,Label)"     "Turret Index, Tool Number And Length Offset Number"
::msgcat::mcset pb_msg_english "MC(tool,conf_desc,index_next_num_len,Label)"    "Turret Index, Next Tool Number And Length Offset Number"

::msgcat::mcset pb_msg_english "MC(tool,oper_trans,title,Label)"            "Operator Message"
::msgcat::mcset pb_msg_english "MC(tool,cus_trans,title,Label)"             "Custom Command"

##--------------------------
## Labels for Event dialogs
##
::msgcat::mcset pb_msg_english "MC(event,feed,IPM_mode)"                "IPM (Inch/Min) Mode"

##---------
## G Codes
##
::msgcat::mcset pb_msg_english "MC(gcode,tab,Label)"                    "G Codes"
::msgcat::mcset pb_msg_english "MC(gcode,Status)"                       "Specify G-Codes"

##---------
## M Codes
##
::msgcat::mcset pb_msg_english "MC(mcode,tab,Label)"                    "M Codes"
::msgcat::mcset pb_msg_english "MC(mcode,Status)"                       "Specify M-Codes"

##-----------------
## Words Summary
##
::msgcat::mcset pb_msg_english "MC(addrsum,tab,Label)"                  "Word Summary"
::msgcat::mcset pb_msg_english "MC(addrsum,Status)"                     "Specify parameters"

::msgcat::mcset pb_msg_english "MC(addrsum,col_addr,Label)"             "Word"
::msgcat::mcset pb_msg_english "MC(addrsum,col_addr,Context)"           "You may edit a Word address by left-mouse clicking its name."
::msgcat::mcset pb_msg_english "MC(addrsum,col_lead,Label)"             "Leader/Code"
::msgcat::mcset pb_msg_english "MC(addrsum,col_data,Label)"             "Data Type"
::msgcat::mcset pb_msg_english "MC(addrsum,col_plus,Label)"             "Plus (+)"
::msgcat::mcset pb_msg_english "MC(addrsum,col_lzero,Label)"            "Lead Zero"
::msgcat::mcset pb_msg_english "MC(addrsum,col_int,Label)"              "Integer"
::msgcat::mcset pb_msg_english "MC(addrsum,col_dec,Label)"              "Decimal (.)"
::msgcat::mcset pb_msg_english "MC(addrsum,col_frac,Label)"             "Fraction"
::msgcat::mcset pb_msg_english "MC(addrsum,col_tzero,Label)"            "Trail Zero"
::msgcat::mcset pb_msg_english "MC(addrsum,col_modal,Label)"            "Modal ?"
::msgcat::mcset pb_msg_english "MC(addrsum,col_min,Label)"              "Minimum"
::msgcat::mcset pb_msg_english "MC(addrsum,col_max,Label)"              "Maximum"
::msgcat::mcset pb_msg_english "MC(addrsum,col_trail,Label)"            "Trailer"

::msgcat::mcset pb_msg_english "MC(addrsum,radio_text,Label)"           "Text"
::msgcat::mcset pb_msg_english "MC(addrsum,radio_num,Label)"            "Numeric"

::msgcat::mcset pb_msg_english "MC(addrsum,addr_trans,title,Label)"     "WORD"
::msgcat::mcset pb_msg_english "MC(addrsum,other_trans,title,Label)"    "Other Data Elements"

##-----------------
## Word Sequencing
##
::msgcat::mcset pb_msg_english "MC(wseq,tab,Label)"                     "Word Sequencing"
::msgcat::mcset pb_msg_english "MC(wseq,Status)"                        "Sequence the Words"

::msgcat::mcset pb_msg_english "MC(wseq,word,Label)"                    "Master Word Sequence"
::msgcat::mcset pb_msg_english "MC(wseq,word,Context)"                  "You may sequence the order of the Words to appear in the N/C output by dragging any Word to the desired position.\
                                                                         \n\
                                                                         \nWhen the Word being dragged is in focus (color of rectangle changes) with the other Word, the postions of these 2 Words will be swapped. If a Word is dragged within the focus of a separator between 2 Words, the Word will be inserted between these 2 Words.\
                                                                         \n\
                                                                         \nYou may suppress any Word from being output to the N/C file by toggling it off with a single left mouse click.\
                                                                         \n\
                                                                         \nYou can also manipulate these Words using the options from a pop-up menu :\
                                                                         \n\
                                                                         \n * New\
                                                                         \n * Edit\
                                                                         \n * Delete\
                                                                         \n * Activate All\
                                                                         \n"

::msgcat::mcset pb_msg_english "MC(wseq,active_out,Label)"              " Output - Active     "
::msgcat::mcset pb_msg_english "MC(wseq,suppressed_out,Label)"          " Output - Suppressed "

::msgcat::mcset pb_msg_english "MC(wseq,popup_new,Label)"               "New"
::msgcat::mcset pb_msg_english "MC(wseq,popup_undo,Label)"              "Undo"
::msgcat::mcset pb_msg_english "MC(wseq,popup_edit,Label)"              "Edit"
::msgcat::mcset pb_msg_english "MC(wseq,popup_delete,Label)"            "Delete"
::msgcat::mcset pb_msg_english "MC(wseq,popup_all,Label)"               "Activate All"
::msgcat::mcset pb_msg_english "MC(wseq,transient_win,Label)"           "WORD"
::msgcat::mcset pb_msg_english "MC(wseq,cannot_suppress_msg)"           "can not be suppressed.  It has been used as a single element in the"
::msgcat::mcset pb_msg_english "MC(wseq,empty_block_msg)"               "Suppressing output of this Address will result in invalid empty Block(s)."

##----------------
## Custom Command
##
::msgcat::mcset pb_msg_english "MC(cust_cmd,tab,Label)"                 "Custom Command"
::msgcat::mcset pb_msg_english "MC(cust_cmd,Status)"                    "Define Custom Commands"

::msgcat::mcset pb_msg_english "MC(cust_cmd,name,Label)"                "Command Name"
::msgcat::mcset pb_msg_english "MC(cust_cmd,name,Context)"              "The name that you enter here will be prefixed with PB_CMD_ to become the actual command name."
::msgcat::mcset pb_msg_english "MC(cust_cmd,proc,Label)"                "Procedure"
::msgcat::mcset pb_msg_english "MC(cust_cmd,proc,Context)"              "You will enter a Tcl script to define the functionality of this command.\
                                                                         \n\
                                                                         \n * Noted that the contents of the script will not be parsed by the Post Builder, but will be saved in the Tcl file. Therefore, you will be responsible for the syntatical correctness of the script."

::msgcat::mcset pb_msg_english "MC(cust_cmd,name_msg)"                  "Invalid Custom Command name.\n\
                                                                         Specify a different name"
::msgcat::mcset pb_msg_english "MC(cust_cmd,name_msg_1)"                "is reserved for special Custom Commands.\n\
                                                                         Specify a different name"
::msgcat::mcset pb_msg_english "MC(cust_cmd,name_msg_2)"                "Only VNC custom commands names like \n\
                                                                         PB_CMD_vnc____* are permitted.\n\
                                                                         Specify a different name"

::msgcat::mcset pb_msg_english "MC(cust_cmd,import,Label)"              "Import"
::msgcat::mcset pb_msg_english "MC(cust_cmd,import,Context)"            "Import Custom Commands from a selected Tcl file to the Post in progress."
::msgcat::mcset pb_msg_english "MC(cust_cmd,export,Label)"              "Export"
::msgcat::mcset pb_msg_english "MC(cust_cmd,export,Context)"            "Export Custom Commands from the Post in progress to a Tcl file."
::msgcat::mcset pb_msg_english "MC(cust_cmd,import,tree,Label)"         "Import Custom Commands"
::msgcat::mcset pb_msg_english "MC(cust_cmd,import,tree,Context)"       "This list contains the custom command procedures and other Tcl procedures found in the file that you have specified to import.  You can preview the contents of each procedure by selecting the item on the list with a single left-mouse click.  Any procedure that already exists in the Post in progress is identified with an <exists> indicator.  A double left-mouse click on an item will toggle the check-box next to the item.  This allows you to select or deselect a procedure to import. By default, all the procedures are selected to be imported.  You may deselect any item to avoid overwritting an existing procedure."

::msgcat::mcset pb_msg_english "MC(cust_cmd,export,tree,Label)"         "Export Custom Commands"
::msgcat::mcset pb_msg_english "MC(cust_cmd,export,tree,Context)"       "This list contains the custom command procedures and other Tcl procedures that exist in the Post in progress.  You can preview the contents of each procedure by selecting the item on the list with a single left-mouse click.  A double left-mouse click on an item will toggle the check-box next to the item.  This allows you to select only desired procedures to export."

::msgcat::mcset pb_msg_english "MC(cust_cmd,error,title)"               "Custom Command Error"
::msgcat::mcset pb_msg_english "MC(cust_cmd,error,msg)"                 "Validation of Custom Commands can be enabled or disabled by setting the switches on the pull-down of the main menu item \"Options -> Validate Custom Commands\"."

::msgcat::mcset pb_msg_english "MC(cust_cmd,select_all,Label)"          "Select All"
::msgcat::mcset pb_msg_english "MC(cust_cmd,select_all,Context)"        "Click this button to select all the commands displayed to import or export."
::msgcat::mcset pb_msg_english "MC(cust_cmd,deselect_all,Label)"        "Deselect All"
::msgcat::mcset pb_msg_english "MC(cust_cmd,deselect_all,Context)"      "Click this button to deselect all the commands."

::msgcat::mcset pb_msg_english "MC(cust_cmd,import,warning,title)"      "Custom Command Import / Export Warning"
::msgcat::mcset pb_msg_english "MC(cust_cmd,import,warning,msg)"        "No item has been selected to import or export."



::msgcat::mcset pb_msg_english "MC(cust_cmd,cmd,msg)"                   "Commands : "
::msgcat::mcset pb_msg_english "MC(cust_cmd,blk,msg)"                   "Blocks : "
::msgcat::mcset pb_msg_english "MC(cust_cmd,add,msg)"                   "Addresses : "
::msgcat::mcset pb_msg_english "MC(cust_cmd,fmt,msg)"                   "Formats : "
::msgcat::mcset pb_msg_english "MC(cust_cmd,referenced,msg)"            "referenced in Custom Command "
::msgcat::mcset pb_msg_english "MC(cust_cmd,not_defined,msg)"           "have not been defined in the current scope of the Post in progress."
::msgcat::mcset pb_msg_english "MC(cust_cmd,cannot_delete,msg)"         "cannot be deleted."
::msgcat::mcset pb_msg_english "MC(cust_cmd,save_post,msg)"             "Do you want to save this Post anyway?"


##------------------
## Operator Message
##
::msgcat::mcset pb_msg_english "MC(opr_msg,text,Label)"                 "Operator Message"
::msgcat::mcset pb_msg_english "MC(opr_msg,text,Context)"               "Text to be displayed as an operator message.  The required special characters for the message start and the end will be automatically attached by the Post Builder for you. These characters are specified in the \"Other Data Elements\" parameter page under \"N/C Data Definitions\" tab."

::msgcat::mcset pb_msg_english "MC(opr_msg,name,Label)"                 "Message Name"
::msgcat::mcset pb_msg_english "MC(opr_msg,empty_operator)"             "An Operator Message should not be empty."


##--------------
## Linked Posts
##
::msgcat::mcset pb_msg_english "MC(link_post,tab,Label)"                "Linked Posts"
::msgcat::mcset pb_msg_english "MC(link_post,Status)"                   "Define Linked Posts"

::msgcat::mcset pb_msg_english "MC(link_post,toggle,Label)"             "Link Other Posts to This Post"
::msgcat::mcset pb_msg_english "MC(link_post,toggle,Context)"           "Other posts can be linked to this post to handle complex machine-tools that perform more than one combination of simple milling and turning modes."

::msgcat::mcset pb_msg_english "MC(link_post,head,Label)"               "Head"
::msgcat::mcset pb_msg_english "MC(link_post,head,Context)"             "A complex machine-tool can perform its machining operations using different sets of kinematics in various machining modes.  Each set of kinematics is treated as an independent Head in NX/Post.  Machining operaions that need to be performed with a specific Head will be placed together as a group in the Machine Tool or Machining Method View.  A \\\"Head\\\" UDE will then be assigned to the group to designate the name for this head."

::msgcat::mcset pb_msg_english "MC(link_post,post,Label)"               "Post"
::msgcat::mcset pb_msg_english "MC(link_post,post,Context)"             "A post is assigned to a Head for producing the N/C codes."

::msgcat::mcset pb_msg_english "MC(link_post,link,Label)"               "A Linked Post"
::msgcat::mcset pb_msg_english "MC(link_post,link,Context)"             "[::msgcat::mc MC(link_post,head,Context)] \n\n [::msgcat::mc MC(link_post,post,Context)]"


::msgcat::mcset pb_msg_english "MC(link_post,new,Label)"                "New"
::msgcat::mcset pb_msg_english "MC(link_post,new,Context)"              "Create a new link."

::msgcat::mcset pb_msg_english "MC(link_post,edit,Label)"               "Edit"
::msgcat::mcset pb_msg_english "MC(link_post,edit,Context)"             "Edit a link."

::msgcat::mcset pb_msg_english "MC(link_post,delete,Label)"             "Delete"
::msgcat::mcset pb_msg_english "MC(link_post,delete,Context)"           "Delete a link."

::msgcat::mcset pb_msg_english "MC(link_post,select_name,Label)"        "Select Name"
::msgcat::mcset pb_msg_english "MC(link_post,select_name,Context)"      "Select the name of a post to be assigned to a Head.  Presumably, this post will be found in the directory where the main post is at the NX/Post run-time, otherwise a post with the same name in the \\\$UGII_CAM_POST_DIR directory will be used."

::msgcat::mcset pb_msg_english "MC(link_post,start_of_head,Label)"      "Start of Head"
::msgcat::mcset pb_msg_english "MC(link_post,start_of_head,Context)"    "Specify the N/C codes or actions to be executed at the start of this Head."

::msgcat::mcset pb_msg_english "MC(link_post,end_of_head,Label)"        "End of Head"
::msgcat::mcset pb_msg_english "MC(link_post,end_of_head,Context)"      "Specify the N/C codes or actions to be executed at the end of this Head."
::msgcat::mcset pb_msg_english "MC(link_post,dlg,head,Label)"           "Head"
::msgcat::mcset pb_msg_english "MC(link_post,dlg,post,Label)"           "Post"
::msgcat::mcset pb_msg_english "MC(link_post,dlg,title,Label)"          "Linked Post"

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
::msgcat::mcset pb_msg_english "MC(nc_data,tab,Label)"                  "N/C Data Definitions"

##-------
## BLOCK
##
::msgcat::mcset pb_msg_english "MC(block,tab,Label)"                    "BLOCK"
::msgcat::mcset pb_msg_english "MC(block,Status)"                       "Define the Block Templates"

::msgcat::mcset pb_msg_english "MC(block,name,Label)"                   "Block Name"
::msgcat::mcset pb_msg_english "MC(block,name,Context)"                 "Enter the Block Name"

::msgcat::mcset pb_msg_english "MC(block,add,Label)"                    "Add Word"
::msgcat::mcset pb_msg_english "MC(block,add,Context)"                  "You may add a new Word to a Block by pressing this button and dragging it to the Block displayed in the window below.  The type of Word that will be created is selected from the list box at the right side of this button."

::msgcat::mcset pb_msg_english "MC(block,select,Label)"                 "BLOCK -- Word Selection"
::msgcat::mcset pb_msg_english "MC(block,select,Context)"               "You may select the type of Word that you desire to add to the Block from this list."

::msgcat::mcset pb_msg_english "MC(block,trash,Label)"                  "BLOCK -- Trash Can"
::msgcat::mcset pb_msg_english "MC(block,trash,Context)"                "You may dispose any unwanted Words from a Block by dragging them to this trash can."

::msgcat::mcset pb_msg_english "MC(block,word,Label)"                   "BLOCK -- Word"
::msgcat::mcset pb_msg_english "MC(block,word,Context)"                 "You may delete any unwanted Word in this Block by dragging it to the trash can.\
                                                                         \n\
                                                                         \nYou may also activate a pop-up menu by pressing the right mouse button.  Several services will be available on the menu :\
                                                                         \n\
                                                                         \n * Edit\
                                                                         \n * Change Element ->\
                                                                         \n * Optional\
                                                                         \n * No Word Seperator\
                                                                         \n * Force Output\
                                                                         \n * Delete\
                                                                         \n"

::msgcat::mcset pb_msg_english "MC(block,verify,Label)"                 "BLOCK -- Word Verification"
::msgcat::mcset pb_msg_english "MC(block,verify,Context)"               "This window displays the reprensentative N/C code to be output for a Word selected (depressed) in the Block shown in the window above."

::msgcat::mcset pb_msg_english "MC(block,new_combo,Label)"              "New Address"
::msgcat::mcset pb_msg_english "MC(block,text_combo,Label)"             "Text"
::msgcat::mcset pb_msg_english "MC(block,oper_combo,Label)"             "Operator Message"
::msgcat::mcset pb_msg_english "MC(block,comm_combo,Label)"             "Command"

::msgcat::mcset pb_msg_english "MC(block,edit_popup,Label)"             "Edit"
::msgcat::mcset pb_msg_english "MC(block,view_popup,Label)"             "View"
::msgcat::mcset pb_msg_english "MC(block,change_popup,Label)"           "Change Element"
::msgcat::mcset pb_msg_english "MC(block,user_popup,Label)"             "User Defined Expression"
::msgcat::mcset pb_msg_english "MC(block,opt_popup,Label)"              "Optional"
::msgcat::mcset pb_msg_english "MC(block,no_sep_popup,Label)"           "No Word Separator"
::msgcat::mcset pb_msg_english "MC(block,force_popup,Label)"            "Force Output"
::msgcat::mcset pb_msg_english "MC(block,delete_popup,Label)"           "Delete"
::msgcat::mcset pb_msg_english "MC(block,undo_popup,Label)"             "Undo"
::msgcat::mcset pb_msg_english "MC(block,delete_all,Label)"             "Delete All Active Elements"

::msgcat::mcset pb_msg_english "MC(block,cmd_title,Label)"              "Custom Commnad"
::msgcat::mcset pb_msg_english "MC(block,oper_title,Label)"             "Operator Message"
::msgcat::mcset pb_msg_english "MC(block,addr_title,Label)"             "WORD"

::msgcat::mcset pb_msg_english "MC(block,new_trans,title,Label)"        "WORD"

::msgcat::mcset pb_msg_english "MC(block,new,word_desc,Label)"          "New Address"
::msgcat::mcset pb_msg_english "MC(block,oper,word_desc,Label)"         "Operator Message"
::msgcat::mcset pb_msg_english "MC(block,cmd,word_desc,Label)"          "Custom Command"
::msgcat::mcset pb_msg_english "MC(block,user,word_desc,Label)"         "User Defined Expression"
::msgcat::mcset pb_msg_english "MC(block,text,word_desc,Label)"         "Text String"

::msgcat::mcset pb_msg_english "MC(block,user,expr,Label)"              "Expression"

::msgcat::mcset pb_msg_english "MC(block,msg,min_word)"                 "A Block should contain at least one Word."

::msgcat::mcset pb_msg_english "MC(block,name_msg)"                     "Invalid Block name.\n\
                                                                         Specify a different name."

##---------
## ADDRESS
##
::msgcat::mcset pb_msg_english "MC(address,tab,Label)"                  "WORD"
::msgcat::mcset pb_msg_english "MC(address,Status)"                     "Define Words"

::msgcat::mcset pb_msg_english "MC(address,name,Label)"                 "Word Name"
::msgcat::mcset pb_msg_english "MC(address,name,Context)"               "You may edit the name of a Word."

::msgcat::mcset pb_msg_english "MC(address,verify,Label)"               "WORD -- Verification"
::msgcat::mcset pb_msg_english "MC(address,verify,Context)"             "This window displays the reprensentative N/C code to be output for a Word."

::msgcat::mcset pb_msg_english "MC(address,leader,Label)"               "Leader"
::msgcat::mcset pb_msg_english "MC(address,leader,Context)"             "You may enter any number of characters as the Leader for a Word or select a character from a pop-up menu using the right mouse button."

::msgcat::mcset pb_msg_english "MC(address,format,Label)"               "Format"
::msgcat::mcset pb_msg_english "MC(address,format,edit,Label)"          "Edit"
::msgcat::mcset pb_msg_english "MC(address,format,edit,Context)"        "This button allows you to edit the Format used by a Word."
::msgcat::mcset pb_msg_english "MC(address,format,new,Label)"           "New"
::msgcat::mcset pb_msg_english "MC(address,format,new,Context)"         "This button allows you to create a new Format."

::msgcat::mcset pb_msg_english "MC(address,format,select,Label)"        "WORD -- Select Format"
::msgcat::mcset pb_msg_english "MC(address,format,select,Context)"      "This button allows you to select different Format for a Word."

::msgcat::mcset pb_msg_english "MC(address,trailer,Label)"              "Trailer"
::msgcat::mcset pb_msg_english "MC(address,trailer,Context)"            "You may enter any number of characters as the Trailer for a Word or select a character from a pop-up menu using the right mouse button."

::msgcat::mcset pb_msg_english "MC(address,modality,Label)"             "Modal ?"
::msgcat::mcset pb_msg_english "MC(address,modality,Context)"           "This option allows you to set the modality for a Word."

::msgcat::mcset pb_msg_english "MC(address,modal_drop,off,Label)"       "Off"
::msgcat::mcset pb_msg_english "MC(address,modal_drop,once,Label)"      "Once"
::msgcat::mcset pb_msg_english "MC(address,modal_drop,always,Label)"    "Always"

::msgcat::mcset pb_msg_english "MC(address,max,value,Label)"            "Maximum"
::msgcat::mcset pb_msg_english "MC(address,max,value,Context)"          "You will specify a maximum value for a Word."

::msgcat::mcset pb_msg_english "MC(address,value,text,Label)"           "Value"

::msgcat::mcset pb_msg_english "MC(address,trunc_drop,Label)"           "Truncate Value"
::msgcat::mcset pb_msg_english "MC(address,warn_drop,Label)"            "Warn User"
::msgcat::mcset pb_msg_english "MC(address,abort_drop,Label)"           "Abort Process"

::msgcat::mcset pb_msg_english "MC(address,max,error_handle,Label)"     "Violation Handling"
::msgcat::mcset pb_msg_english "MC(address,max,error_handle,Context)"   "This button allows you to specify the method for handling the violation to the maximum value:\
                                                                         \n\
                                                                         \n * Truncate Value\
                                                                         \n * Warn User\
                                                                         \n * Abort Process\
                                                                         \n"

::msgcat::mcset pb_msg_english "MC(address,min,value,Label)"            "Minimum"
::msgcat::mcset pb_msg_english "MC(address,min,value,Context)"          "You will specify a minimum value for a Word."

::msgcat::mcset pb_msg_english "MC(address,min,error_handle,Label)"     "Violation Handling"
::msgcat::mcset pb_msg_english "MC(address,min,error_handle,Context)"   "This button allows you to specify the method for handling the violation to the minimum value:\
                                                                         \n\
                                                                         \n * Truncate Value\
                                                                         \n * Warn User\
                                                                         \n * Abort Process\
                                                                         \n"

::msgcat::mcset pb_msg_english "MC(address,format_trans,title,Label)"   "FORMAT "
::msgcat::mcset pb_msg_english "MC(address,none_popup,Label)"           "None"

::msgcat::mcset pb_msg_english "MC(address,exp,Label)"                  "Expression"
::msgcat::mcset pb_msg_english "MC(address,exp,Context)"                "You may specify an expression or a constant to a Block."
::msgcat::mcset pb_msg_english "MC(address,exp,msg)"                    "Expression for a Block element should not be blank."
::msgcat::mcset pb_msg_english "MC(address,exp,space_only)"             "Expression for a Block element using numeric Format can not contain only spaces."

## No translation is needed for this string.
::msgcat::mcset pb_msg_english "MC(address,exp,spec_char)"              "\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@ \[  \\  \]  \^  \`  \{  \|  \}  \~"

::msgcat::mcset pb_msg_english "MC(address,exp,spec_char_msg)"          "Special character(s) \n [::msgcat::mc MC(address,exp,spec_char)] \n\
                                                                         can not be used in an expression for numeric data."



::msgcat::mcset pb_msg_english "MC(address,name_msg)"                   "Invalid Word Name.\n\
                                                                         Please specify a different name."
# - No translation for rapid1, rapid2 & rapid3
::msgcat::mcset pb_msg_english "MC(address,rapid_add_name_msg)"         "rapid1, rapid2 and rapid3 are reserved for internal use by Post Builder.\n\
                                                                         Please specify a different name."

::msgcat::mcset pb_msg_english "MC(address,rapid1,desc)"                "Rapid Position along Longitudinal Axis"
::msgcat::mcset pb_msg_english "MC(address,rapid2,desc)"                "Rapid Position along Transversal Axis"
::msgcat::mcset pb_msg_english "MC(address,rapid3,desc)"                "Rapid Position along Spindle Axis"

##--------
## FORMAT
##
::msgcat::mcset pb_msg_english "MC(format,tab,Label)"                   "FORMAT"
::msgcat::mcset pb_msg_english "MC(format,Status)"                      "Define the Formats"

::msgcat::mcset pb_msg_english "MC(format,verify,Label)"                "FORMAT -- Verification"
::msgcat::mcset pb_msg_english "MC(format,verify,Context)"              "This window displays the Reprensentative N/C code to be output using the Format specified."

::msgcat::mcset pb_msg_english "MC(format,name,Label)"                  "Format Name"
::msgcat::mcset pb_msg_english "MC(format,name,Context)"                "You may edit the name of a Format."

::msgcat::mcset pb_msg_english "MC(format,data,type,Label)"             "Data Type"
::msgcat::mcset pb_msg_english "MC(format,data,type,Context)"           "You will specify the Data Type for a Format."
::msgcat::mcset pb_msg_english "MC(format,data,num,Label)"              "Numeric"
::msgcat::mcset pb_msg_english "MC(format,data,num,Context)"            "This option defines the data type of a Format as a Numeric."
::msgcat::mcset pb_msg_english "MC(format,data,num,integer,Label)"      "FORMAT -- Digits of Integer"
::msgcat::mcset pb_msg_english "MC(format,data,num,integer,Context)"    "This option specifies the number of digits of an integer or the integer part of a real number."
::msgcat::mcset pb_msg_english "MC(format,data,num,fraction,Label)"     "FORMAT -- Digits of Fraction"
::msgcat::mcset pb_msg_english "MC(format,data,num,fraction,Context)"   "This option specifies the number of digits for the fraction part of a real number."
::msgcat::mcset pb_msg_english "MC(format,data,num,decimal,Label)"      "Output Decimal Point (.)"
::msgcat::mcset pb_msg_english "MC(format,data,num,decimal,Context)"    "This option allows you to output decimal points in N/C code."
::msgcat::mcset pb_msg_english "MC(format,data,num,lead,Label)"         "Output Leading Zeros"
::msgcat::mcset pb_msg_english "MC(format,data,num,lead,Context)"       "This option enables leading zero padding to the numbers in N/C code."
::msgcat::mcset pb_msg_english "MC(format,data,num,trail,Label)"        "Output Trailng Zeros"
::msgcat::mcset pb_msg_english "MC(format,data,num,trail,Context)"      "This option enables trailing zero padding to the real numbers in N/C code."
::msgcat::mcset pb_msg_english "MC(format,data,text,Label)"             "Text"
::msgcat::mcset pb_msg_english "MC(format,data,text,Context)"           "This option defines the data type of a Format as a text string."
::msgcat::mcset pb_msg_english "MC(format,data,plus,Label)"             "Output Leading Plus Sign (+)"
::msgcat::mcset pb_msg_english "MC(format,data,plus,Context)"           "This option allows you to output plus sings in N/C code."
::msgcat::mcset pb_msg_english "MC(format,zero_msg)"                    "Cannot make a copy of Zero format"
::msgcat::mcset pb_msg_english "MC(format,zero_cut_msg)"                "Cannot delete a Zero format"

::msgcat::mcset pb_msg_english "MC(format,data,dec_zero,msg)"           "At least one of the Decimal Point, Leading Zeros or Trailing Zeros options should be checked."

::msgcat::mcset pb_msg_english "MC(format,data,no_digit,msg)"           "Number of digits for integer and fraction should not be both zero."

::msgcat::mcset pb_msg_english "MC(format,name_msg)"                    "Invalid Format Name.\n\
                                                                         Specify a different name."
::msgcat::mcset pb_msg_english "MC(format,error,title)"                 "Format Error"
::msgcat::mcset pb_msg_english "MC(format,error,msg)"                   "This Format has been used in Addresses"

##---------------------
## Other Data Elements
##
::msgcat::mcset pb_msg_english "MC(other,tab,Label)"                    "Other Data Elements"
::msgcat::mcset pb_msg_english "MC(other,Status)"                       "Specify the Parameters"

::msgcat::mcset pb_msg_english "MC(other,seq_num,Label)"                "Sequence Number"
::msgcat::mcset pb_msg_english "MC(other,seq_num,Context)"              "This switch allows you to enable/disable the output of sequence numbers in the N/C code."
::msgcat::mcset pb_msg_english "MC(other,seq_num,start,Label)"          "Sequence Number Start"
::msgcat::mcset pb_msg_english "MC(other,seq_num,start,Context)"        "Specify the start of the sequence numbers."
::msgcat::mcset pb_msg_english "MC(other,seq_num,inc,Label)"            "Sequence Number Increment"
::msgcat::mcset pb_msg_english "MC(other,seq_num,inc,Context)"          "Specify the increment of the sequence numbers."
::msgcat::mcset pb_msg_english "MC(other,seq_num,freq,Label)"           "Sequence Number Frequency"
::msgcat::mcset pb_msg_english "MC(other,seq_num,freq,Context)"         "Specify the frequence of the sequence numbers appear in the N/C code."
::msgcat::mcset pb_msg_english "MC(other,seq_num,max,Label)"            "Sequence Number Maximum"
::msgcat::mcset pb_msg_english "MC(other,seq_num,max,Context)"          "Specify the maximum value of the sequence numbers."

::msgcat::mcset pb_msg_english "MC(other,chars,Label)"                  "Special Characters"
::msgcat::mcset pb_msg_english "MC(other,chars,word_sep,Label)"         "Word Separator"
::msgcat::mcset pb_msg_english "MC(other,chars,word_sep,Context)"       "Specify a character to be used as the word separator."
::msgcat::mcset pb_msg_english "MC(other,chars,decimal_pt,Label)"       "Decimal Point"
::msgcat::mcset pb_msg_english "MC(other,chars,decimal_pt,Context)"     "Specify a character to be used as the decimal point."
::msgcat::mcset pb_msg_english "MC(other,chars,end_of_block,Label)"     "End of Block"
::msgcat::mcset pb_msg_english "MC(other,chars,end_of_block,Context)"   "Specify a character to be used as the end-of-block."
::msgcat::mcset pb_msg_english "MC(other,chars,comment_start,Label)"    "Message Start"
::msgcat::mcset pb_msg_english "MC(other,chars,comment_start,Context)"  "Specify characters to be used as the start of an operator message line."
::msgcat::mcset pb_msg_english "MC(other,chars,comment_end,Label)"      "Message End"
::msgcat::mcset pb_msg_english "MC(other,chars,comment_end,Context)"    "Specify characters to be used as the end of an operator message line."

::msgcat::mcset pb_msg_english "MC(other,opskip,Label)"                 "OPSKIP"
::msgcat::mcset pb_msg_english "MC(other,opskip,leader,Label)"          "Line Leader"
::msgcat::mcset pb_msg_english "MC(other,opskip,leader,Context)"        "OPSKIP Line Leader"

::msgcat::mcset pb_msg_english "MC(other,gm_codes,Label)"               "G & M Codes Output Per Block"
::msgcat::mcset pb_msg_english "MC(other,g_codes,Label)"                "Number of G Codes per Block"
::msgcat::mcset pb_msg_english "MC(other,g_codes,Context)"              "This switch allows you to enable/disable the control of number of G codes per N/C output block."
::msgcat::mcset pb_msg_english "MC(other,g_codes,num,Label)"            "Number of G Codes"
::msgcat::mcset pb_msg_english "MC(other,g_codes,num,Context)"          "Specify the number of G codes per N/C output block."
::msgcat::mcset pb_msg_english "MC(other,m_codes,Label)"                "Number of M Codes"
::msgcat::mcset pb_msg_english "MC(other,m_codes,Context)"              "This switch allows you to enable/disable the control of number of M codes per N/C output block."
::msgcat::mcset pb_msg_english "MC(other,m_codes,num,Label)"            "Number of M Codes per Block"
::msgcat::mcset pb_msg_english "MC(other,m_codes,num,Context)"          "Specify the number of M codes per N/C output block."

::msgcat::mcset pb_msg_english "MC(other,opt_none,Label)"               "None"
::msgcat::mcset pb_msg_english "MC(other,opt_space,Label)"              "Space"
::msgcat::mcset pb_msg_english "MC(other,opt_dec,Label)"                "Decimal (.)"
::msgcat::mcset pb_msg_english "MC(other,opt_comma,Label)"              "Comma (,)"
::msgcat::mcset pb_msg_english "MC(other,opt_semi,Label)"               "Semicolon (;)"
::msgcat::mcset pb_msg_english "MC(other,opt_colon,Label)"              "Colon (:)"
::msgcat::mcset pb_msg_english "MC(other,opt_text,Label)"               "Text String"
::msgcat::mcset pb_msg_english "MC(other,opt_left,Label)"               "Left Parenthesis ("
::msgcat::mcset pb_msg_english "MC(other,opt_right,Label)"              "Right Parenthesis )"
::msgcat::mcset pb_msg_english "MC(other,opt_pound,Label)"              "Pound Sign (\#)"
::msgcat::mcset pb_msg_english "MC(other,opt_aster,Label)"              "Asterisk (*)"
::msgcat::mcset pb_msg_english "MC(other,opt_slash,Label)"              "Slash (/)"
::msgcat::mcset pb_msg_english "MC(other,opt_new_line,Label)"           "New Line (\\012)"

# UDE Inclusion
::msgcat::mcset pb_msg_english "MC(other,ude,Label)"                    "User Defined Events"
::msgcat::mcset pb_msg_english "MC(other,ude_include,Label)"            "Include Other CDL File"
::msgcat::mcset pb_msg_english "MC(other,ude_include,Context)"          "This option enables this post to include reference to a CDL file in its definition file."

::msgcat::mcset pb_msg_english "MC(other,ude_file,Label)"               "CDL File Name"
::msgcat::mcset pb_msg_english "MC(other,ude_file,Context)"             "Path and file name of a CDL file to be referenced (INCLUDE) in the definition file of this post.  The path name must start with a UG environment variable (\\\$UGII) or none.  When no path is specified, UGII_CAM_FILE_SEARCH_PATH will be used to locate the file by UG/NX at runtime."
::msgcat::mcset pb_msg_english "MC(other,ude_select,Label)"             "Select Name"
::msgcat::mcset pb_msg_english "MC(other,ude_select,Context)"           "Select a CDL file to be referenced (INCLUDE) in the definition file of this post.  By default, the file name selected will be preppended with \\\$UGII_CAM_USER_DEF_EVENT_DIR/.  You may edit the path name as desired after the selection."


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
::msgcat::mcset pb_msg_english "MC(output,tab,Label)"                   "Output Settings"
::msgcat::mcset pb_msg_english "MC(output,Status)"                      "Configure Output Parameters"

#++++++++++++++
# VNC Controls
#++++++++++++++
::msgcat::mcset pb_msg_english "MC(output,vnc,Label)"                   "Virtual N/C Controller"
::msgcat::mcset pb_msg_english "MC(output,vnc,mode,std,Label)"          "Standalone"
::msgcat::mcset pb_msg_english "MC(output,vnc,mode,sub,Label)"          "Subordinate"
::msgcat::mcset pb_msg_english "MC(output,vnc,status,Label)"            "Select A VNC File."
::msgcat::mcset pb_msg_english "MC(output,vnc,mis_match,Label)"         "The selected file does not\
                                                                         match the default VNC file name.\n\
                                                                         Do you want to reselect the file?"
::msgcat::mcset pb_msg_english "MC(output,vnc,output,Label)"            "Generate Virtual N/C Controller (VNC)"
::msgcat::mcset pb_msg_english "MC(output,vnc,output,Context)"          "This option enables you to generate a Virtual N/C Controller (VNC).  A post created with VNC enabled can thus be used for ISV."
::msgcat::mcset pb_msg_english "MC(output,vnc,main,Label)"              "Master VNC"
::msgcat::mcset pb_msg_english "MC(output,vnc,main,Context)"            "The name of the Master VNC that will be sourced by a Subordinate VNC.  At the ISV run-time, presumably, this post will be found in the directory where the Subordinate VNC is, otherwise a post with the same name in the \\\$UGII_CAM_POST_DIR directory will be used."


::msgcat::mcset pb_msg_english "MC(output,vnc,main,err_msg)"                 "Master VNC must be specified for a Subordinate VNC."
::msgcat::mcset pb_msg_english "MC(output,vnc,main,select_name,Label)"       "Select Name"
::msgcat::mcset pb_msg_english "MC(output,vnc,main,select_name,Context)"     "Select the name of a VNC to be sourced by a Subordinate VNC.  At the ISV run-time, presumably, this post will be found in the directory where the Subordinate VNC is, otherwise a post with the same name in the \\\$UGII_CAM_POST_DIR directory will be used."

::msgcat::mcset pb_msg_english "MC(output,vnc,mode,Label)"                   "Virtual N/C Controller Mode"
::msgcat::mcset pb_msg_english "MC(output,vnc,mode,Context)"                 "A Virtual N/C Controller can be either Standalone or Subordinate to a Master VNC."
::msgcat::mcset pb_msg_english "MC(output,vnc,mode,std,Context)"             "A Standalone VNC is self-contained."
::msgcat::mcset pb_msg_english "MC(output,vnc,mode,sub,Context)"             "A Subordinate VNC is largely dependant of its Master VNC.  It will source the Master VNC at the ISV runtime."
::msgcat::mcset pb_msg_english "MC(output,vnc,pb_ver,msg)"                   "Virtual N/C Controller created with Post Builder "
#++++++++++++++
# Listing File
#++++++++++++++
::msgcat::mcset pb_msg_english "MC(listing,tab,Label)"                  "Listing File"
::msgcat::mcset pb_msg_english "MC(listing,Status)"                     "Specify Listing File Parameters"

::msgcat::mcset pb_msg_english "MC(listing,gen,Label)"                  "Generate Listing File"
::msgcat::mcset pb_msg_english "MC(listing,gen,Context)"                "This switch allows you to enable/disable the output of Listing File."

::msgcat::mcset pb_msg_english "MC(listing,Label)"                      "Listing File Elements"
::msgcat::mcset pb_msg_english "MC(listing,parms,Label)"                "Components"

::msgcat::mcset pb_msg_english "MC(listing,parms,x,Label)"              "X-Coordinate"
::msgcat::mcset pb_msg_english "MC(listing,parms,x,Context)"            "This switch allows you to enable/disable the output of x-coordinate to Listing File."

::msgcat::mcset pb_msg_english "MC(listing,parms,y,Label)"              "Y-Coordinate"
::msgcat::mcset pb_msg_english "MC(listing,parms,y,Context)"            "This switch allows you to enable/disable the output of y-coordinate to Listing File."

::msgcat::mcset pb_msg_english "MC(listing,parms,z,Label)"              "Z-Coordinate"
::msgcat::mcset pb_msg_english "MC(listing,parms,z,Context)"            "This switch allows you to enable/disable the output of z-coordinate to Listing File."

::msgcat::mcset pb_msg_english "MC(listing,parms,4,Label)"              "4th Axis Angle"
::msgcat::mcset pb_msg_english "MC(listing,parms,4,Context)"            "This switch allows you to enable/disable the output of 4th axis angle to Listing File."

::msgcat::mcset pb_msg_english "MC(listing,parms,5,Label)"              "5th Axis Angle"
::msgcat::mcset pb_msg_english "MC(listing,parms,5,Context)"            "This switch allows you to enable/disable the output of 5th axis angle to Listing File."

::msgcat::mcset pb_msg_english "MC(listing,parms,feed,Label)"           "Feed"
::msgcat::mcset pb_msg_english "MC(listing,parms,feed,Context)"         "This switch allows you to enable/disable the output of feedrate to Listing File."

::msgcat::mcset pb_msg_english "MC(listing,parms,speed,Label)"          "Speed"
::msgcat::mcset pb_msg_english "MC(listing,parms,speed,Context)"        "This switch allows you to enable/disable the output of spindle speed to Listing File."

::msgcat::mcset pb_msg_english "MC(listing,extension,Label)"            "Listing File Extension"
::msgcat::mcset pb_msg_english "MC(listing,extension,Context)"          "Specify the Listing File extension"

::msgcat::mcset pb_msg_english "MC(listing,nc_file,Label)"              "N/C Output File Extension"
::msgcat::mcset pb_msg_english "MC(listing,nc_file,Context)"            "Specify N/C output file extension"

::msgcat::mcset pb_msg_english "MC(listing,header,Label)"               "Program Header"
::msgcat::mcset pb_msg_english "MC(listing,header,oper_list,Label)"     "Operation List"
::msgcat::mcset pb_msg_english "MC(listing,header,tool_list,Label)"     "Tool List"

::msgcat::mcset pb_msg_english "MC(listing,footer,Label)"               "Program Footer"
::msgcat::mcset pb_msg_english "MC(listing,footer,cut_time,Label)"      "Total Machining Time"

::msgcat::mcset pb_msg_english "MC(listing,format,Label)"                   "Page Format"
::msgcat::mcset pb_msg_english "MC(listing,format,print_header,Label)"      "Print Page Header"
::msgcat::mcset pb_msg_english "MC(listing,format,print_header,Context)"    "This switch allows you to enable/disable the output of page header to Listing File."

::msgcat::mcset pb_msg_english "MC(listing,format,length,Label)"        "Page Length (Rows)"
::msgcat::mcset pb_msg_english "MC(listing,format,length,Context)"      "Specify number of rows per page for the Listing File."
::msgcat::mcset pb_msg_english "MC(listing,format,width,Label)"         "Page Width (Columns)"
::msgcat::mcset pb_msg_english "MC(listing,format,width,Context)"       "Specify number of columns per page for the Listing File."

::msgcat::mcset pb_msg_english "MC(listing,other,tab,Label)"            "Other Options"
::msgcat::mcset pb_msg_english "MC(listing,output,Label)"               "Output Control Elements"

::msgcat::mcset pb_msg_english "MC(listing,output,warning,Label)"       "Output Warning Messages"
::msgcat::mcset pb_msg_english "MC(listing,output,warning,Context)"     "This switch allows you to enable/disable the output of warning messages during post processing."

::msgcat::mcset pb_msg_english "MC(listing,output,review,Label)"        "Activate Review Tool"
::msgcat::mcset pb_msg_english "MC(listing,output,review,Context)"      "This switch allows you to activate the Review Tool during post processing."

::msgcat::mcset pb_msg_english "MC(listing,output,group,Label)"         "Generate Group Output"
::msgcat::mcset pb_msg_english "MC(listing,output,group,Context)"       "This switch allows you to enable/disable the control of Group Output during post processing."

::msgcat::mcset pb_msg_english "MC(listing,output,verbose,Label)"       "Display Verbose Error Messages"
::msgcat::mcset pb_msg_english "MC(listing,output,verbose,Context)"     "This switch allows you to display the extended descriptions for the error conditions. It will somewhat slow down the Post Processing speed."

::msgcat::mcset pb_msg_english "MC(listing,oper_info,Label)"            "Operation Information"
::msgcat::mcset pb_msg_english "MC(listing,oper_info,parms,Label)"      "Operation Parameters"
::msgcat::mcset pb_msg_english "MC(listing,oper_info,tool,Label)"       "Tool Parameters"
::msgcat::mcset pb_msg_english "MC(listing,oper_info,cut_time,,Label)"  "Machining Time"


#<09-19-00 gsl>
::msgcat::mcset pb_msg_english "MC(listing,user_tcl,frame,Label)"       "User Tcl Source"
::msgcat::mcset pb_msg_english "MC(listing,user_tcl,check,Label)"       "Source User's Tcl File"
::msgcat::mcset pb_msg_english "MC(listing,user_tcl,check,Context)"     "This switch allows you to source your own Tcl file"
::msgcat::mcset pb_msg_english "MC(listing,user_tcl,name,Label)"        "File Name"
::msgcat::mcset pb_msg_english "MC(listing,user_tcl,name,Context)"      "Specify the name of a Tcl file that you want to source for this Post"

#++++++++++++++++
# Output Preview
#++++++++++++++++
::msgcat::mcset pb_msg_english "MC(preview,tab,Label)"                  "Post Files Preview"
::msgcat::mcset pb_msg_english "MC(preview,new_code,Label)"             "New Code"
::msgcat::mcset pb_msg_english "MC(preview,old_code,Label)"             "Old Code"

##---------------------
## Event Handler
##
::msgcat::mcset pb_msg_english "MC(event_handler,tab,Label)"            "Event Handlers"
::msgcat::mcset pb_msg_english "MC(event_handler,Status)"               "Choose the Event to view the procedure"

##---------------------
## Definition
##
::msgcat::mcset pb_msg_english "MC(definition,tab,Label)"               "Definitions"
::msgcat::mcset pb_msg_english "MC(definition,Status)"                  "Choose the item to view the contents"

#++++++++++++++
# Post Advisor
#++++++++++++++
::msgcat::mcset pb_msg_english "MC(advisor,tab,Label)"                  "Post Advisor"
::msgcat::mcset pb_msg_english "MC(advisor,Status)"                     "Post Advisor"

::msgcat::mcset pb_msg_english "MC(definition,word_txt,Label)"          "WORD_SEPARATOR"
::msgcat::mcset pb_msg_english "MC(definition,end_txt,Label)"           "END_OF_BLOCK"
::msgcat::mcset pb_msg_english "MC(definition,seq_txt,Label)"           "SEQUENCE_NUM"
::msgcat::mcset pb_msg_english "MC(definition,include,Label)"           "INCLUDE"
::msgcat::mcset pb_msg_english "MC(definition,format_txt,Label)"        "FORMAT"
::msgcat::mcset pb_msg_english "MC(definition,addr_txt,Label)"          "WORD"
::msgcat::mcset pb_msg_english "MC(definition,block_txt,Label)"         "BLOCK"
::msgcat::mcset pb_msg_english "MC(definition,comp_txt,Label)"          "Composite BLOCK"
::msgcat::mcset pb_msg_english "MC(definition,post_txt,Label)"          "Post BLOCK"
::msgcat::mcset pb_msg_english "MC(definition,oper_txt,Label)"          "Operator Message"

#+++++++++++++
# Balloon
#+++++++++++++
::msgcat::mcset pb_msg_english "MC(msg,odd)"                            "Odd count of opt. arguments"
::msgcat::mcset pb_msg_english "MC(msg,wrong_list_1)"                   "Unknown option(s)"
::msgcat::mcset pb_msg_english "MC(msg,wrong_list_2)"                   ". Must be one of:"

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Program Start
::msgcat::mcset pb_msg_english "MC(event,start_prog,name)"              "Start of Program"

### Operation Start
::msgcat::mcset pb_msg_english "MC(event,opr_start,start_path,name)"    "Start of Path"
::msgcat::mcset pb_msg_english "MC(event,opr_start,from_move,name)"     "From Move"
::msgcat::mcset pb_msg_english "MC(event,opr_start,fst_tool,name)"      "First Tool"
::msgcat::mcset pb_msg_english "MC(event,opr_start,auto_tc,name)"       "Auto Tool Change"
::msgcat::mcset pb_msg_english "MC(event,opr_start,manual_tc,name)"     "Manual Tool Change"
::msgcat::mcset pb_msg_english "MC(event,opr_start,init_move,name)"     "Initial Move"
::msgcat::mcset pb_msg_english "MC(event,opr_start,fst_move,name)"      "First Move"
::msgcat::mcset pb_msg_english "MC(event,opr_start,appro_move,name)"    "Approach Move"
::msgcat::mcset pb_msg_english "MC(event,opr_start,engage_move,name)"   "Engage Move"
::msgcat::mcset pb_msg_english "MC(event,opr_start,fst_cut,name)"       "First Cut"
::msgcat::mcset pb_msg_english "MC(event,opr_start,fst_lin_move,name)"  "First Linear Move"
::msgcat::mcset pb_msg_english "MC(event,opr_start,start_pass,name)"    "Start of Pass"
::msgcat::mcset pb_msg_english "MC(event,opr_start,cutcom_move,name)"   "Cutcom Move"
::msgcat::mcset pb_msg_english "MC(event,opr_start,lead_move,name)"     "Lead In Move"

### Operation End
::msgcat::mcset pb_msg_english "MC(event,opr_end,ret_move,name)"        "Retract Move"
::msgcat::mcset pb_msg_english "MC(event,opr_end,rtn_move,name)"        "Return Move"
::msgcat::mcset pb_msg_english "MC(event,opr_end,goh_move,name)"        "Gohome Move"
::msgcat::mcset pb_msg_english "MC(event,opr_end,end_path,name)"        "End of Path"
::msgcat::mcset pb_msg_english "MC(event,opr_end,lead_move,name)"       "Lead Out Move"
::msgcat::mcset pb_msg_english "MC(event,opr_end,end_pass,name)"        "End of Pass"

### Program End
::msgcat::mcset pb_msg_english "MC(event,end_prog,name)"                "End of Program"


### Tool Change
::msgcat::mcset pb_msg_english "MC(event,tool_change,name)"             "Tool Change"
::msgcat::mcset pb_msg_english "MC(event,tool_change,m_code)"           "M Code"
::msgcat::mcset pb_msg_english "MC(event,tool_change,m_code,tl_chng)"   "Tool Change"
::msgcat::mcset pb_msg_english "MC(event,tool_change,m_code,pt)"        "Primary Turret"
::msgcat::mcset pb_msg_english "MC(event,tool_change,m_code,st)"        "Secondary Turret"
::msgcat::mcset pb_msg_english "MC(event,tool_change,t_code)"           "T Code"
::msgcat::mcset pb_msg_english "MC(event,tool_change,t_code,conf)"      "Configure"
::msgcat::mcset pb_msg_english "MC(event,tool_change,t_code,pt_idx)"    "Primary Turret Index"
::msgcat::mcset pb_msg_english "MC(event,tool_change,t_code,st_idx)"    "Secondary Turret Index"
::msgcat::mcset pb_msg_english "MC(event,tool_change,tool_num)"         "Tool Number"
::msgcat::mcset pb_msg_english "MC(event,tool_change,tool_num,min)"     "Minimum"
::msgcat::mcset pb_msg_english "MC(event,tool_change,tool_num,max)"     "Maximum"
::msgcat::mcset pb_msg_english "MC(event,tool_change,time)"             "Time (Sec)"
::msgcat::mcset pb_msg_english "MC(event,tool_change,time,tl_chng)"     "Tool Change"
::msgcat::mcset pb_msg_english "MC(event,tool_change,retract)"          "Retract"
::msgcat::mcset pb_msg_english "MC(event,tool_change,retract_z)"        "Retract To Z of"

### Length Compensation
::msgcat::mcset pb_msg_english "MC(event,length_compn,name)"            "Length Compensation"
::msgcat::mcset pb_msg_english "MC(event,length_compn,g_code)"          "G Code"
::msgcat::mcset pb_msg_english "MC(event,length_compn,g_code,len_adj)"  "Tool Length Adjust"
::msgcat::mcset pb_msg_english "MC(event,length_compn,t_code)"          "T Code"
::msgcat::mcset pb_msg_english "MC(event,length_compn,t_code,conf)"     "Configure"
::msgcat::mcset pb_msg_english "MC(event,length_compn,len_off)"         "Length Offset Register"
::msgcat::mcset pb_msg_english "MC(event,length_compn,len_off,min)"     "Minimum"
::msgcat::mcset pb_msg_english "MC(event,length_compn,len_off,max)"     "Maximum"

### Set Modes
::msgcat::mcset pb_msg_english "MC(event,set_modes,name)"               "Set Modes"
::msgcat::mcset pb_msg_english "MC(event,set_modes,out_mode)"           "Output Mode"
::msgcat::mcset pb_msg_english "MC(event,set_modes,g_code)"             "G Code"
::msgcat::mcset pb_msg_english "MC(event,set_modes,g_code,absolute)"    "Absolute"
::msgcat::mcset pb_msg_english "MC(event,set_modes,g_code,incremental)" "Incremental"
::msgcat::mcset pb_msg_english "MC(event,set_modes,rotary_axis)"        "Rotary Axis Can Be Incremental"

### Spindle RPM
::msgcat::mcset pb_msg_english "MC(event,spindle_rpm,name)"                     "Spindle RPM"
::msgcat::mcset pb_msg_english "MC(event,spindle_rpm,dir_m_code)"               "Spindle Direction M Codes"
::msgcat::mcset pb_msg_english "MC(event,spindle_rpm,dir_m_code,cw)"            "Clockwise (CW)"
::msgcat::mcset pb_msg_english "MC(event,spindle_rpm,dir_m_code,ccw)"           "Counter Clockwise (CCW)"
::msgcat::mcset pb_msg_english "MC(event,spindle_rpm,range_control)"            "Spindle Range Control"
::msgcat::mcset pb_msg_english "MC(event,spindle_rpm,range_control,dwell_time)" "Range Change Dwell Time (Sec)"
::msgcat::mcset pb_msg_english "MC(event,spindle_rpm,range_control,range_code)" "Specify Range Code"

### Spindle CSS
::msgcat::mcset pb_msg_english "MC(event,spindle_css,name)"             "Spindle CSS"
::msgcat::mcset pb_msg_english "MC(event,spindle_css,g_code)"           "Spindle G Code"
::msgcat::mcset pb_msg_english "MC(event,spindle_css,g_code,const)"     "Constant Surface Code"
::msgcat::mcset pb_msg_english "MC(event,spindle_css,g_code,max)"       "Maximum RPM Code"
::msgcat::mcset pb_msg_english "MC(event,spindle_css,g_code,sfm)"       "Code To Cancel SFM"
::msgcat::mcset pb_msg_english "MC(event,spindle_css,max)"              "Maximum RPM During CSS"
::msgcat::mcset pb_msg_english "MC(event,spindle_css,sfm)"              "Alway Have IPR mode for SFM"

### Spindle Off
::msgcat::mcset pb_msg_english "MC(event,spindle_off,name)"             "Spindle Off"
::msgcat::mcset pb_msg_english "MC(event,spindle_off,dir_m_code)"       "Spindle Direction M Code"
::msgcat::mcset pb_msg_english "MC(event,spindle_off,dir_m_code,off)"   "Off"

### Coolant On
::msgcat::mcset pb_msg_english "MC(event,coolant_on,name)"              "Coolant On"
::msgcat::mcset pb_msg_english "MC(event,coolant_on,m_code)"            "M Code"
::msgcat::mcset pb_msg_english "MC(event,coolant_on,m_code,on)"         "ON"
::msgcat::mcset pb_msg_english "MC(event,coolant_on,m_code,flood)"      "Flood"
::msgcat::mcset pb_msg_english "MC(event,coolant_on,m_code,mist)"       "Mist"
::msgcat::mcset pb_msg_english "MC(event,coolant_on,m_code,thru)"       "Thru"
::msgcat::mcset pb_msg_english "MC(event,coolant_on,m_code,tap)"        "Tap"

### Coolant Off
::msgcat::mcset pb_msg_english "MC(event,coolant_off,name)"             "Coolant Off"
::msgcat::mcset pb_msg_english "MC(event,coolant_off,m_code)"           "M Code"
::msgcat::mcset pb_msg_english "MC(event,coolant_off,m_code,off)"       "Off"

### Inch Metric Mode
::msgcat::mcset pb_msg_english "MC(event,inch_metric_mode,name)"            "Inch Metric Mode"
::msgcat::mcset pb_msg_english "MC(event,inch_metric_mode,g_code)"          "G Code"
::msgcat::mcset pb_msg_english "MC(event,inch_metric_mode,g_code,english)"  "English (Inch)"
::msgcat::mcset pb_msg_english "MC(event,inch_metric_mode,g_code,metric)"   "Metric (Millimeter)"

### Feedrates
::msgcat::mcset pb_msg_english "MC(event,feedrates,name)"               "Feedrates"
::msgcat::mcset pb_msg_english "MC(event,feedrates,ipm_mode)"           "IPM Mode"
::msgcat::mcset pb_msg_english "MC(event,feedrates,ipr_mode)"           "IPR Mode"
::msgcat::mcset pb_msg_english "MC(event,feedrates,dpm_mode)"           "DPM Mode"
::msgcat::mcset pb_msg_english "MC(event,feedrates,mmpm_mode)"          "MMPM Mode"
::msgcat::mcset pb_msg_english "MC(event,feedrates,mmpr_mode)"          "MMPR Mode"
::msgcat::mcset pb_msg_english "MC(event,feedrates,frn_mode)"           "FRN Mode"
::msgcat::mcset pb_msg_english "MC(event,feedrates,g_code)"             "G Code"
::msgcat::mcset pb_msg_english "MC(event,feedrates,format)"             "Format"
::msgcat::mcset pb_msg_english "MC(event,feedrates,max)"                "Maximum"
::msgcat::mcset pb_msg_english "MC(event,feedrates,min)"                "Minimum"
::msgcat::mcset pb_msg_english "MC(event,feedrates,mode,label)"         "Feedrate Modes"
::msgcat::mcset pb_msg_english "MC(event,feedrates,mode,lin)"           "Linear Only"
::msgcat::mcset pb_msg_english "MC(event,feedrates,mode,rot)"           "Rotary Only"
::msgcat::mcset pb_msg_english "MC(event,feedrates,mode,lin_rot)"       "Linear and Rotary"
::msgcat::mcset pb_msg_english "MC(event,feedrates,mode,rap_lin)"       "Rapid Linear Only"
::msgcat::mcset pb_msg_english "MC(event,feedrates,mode,rap_rot)"       "Rapid Rotary Only"
::msgcat::mcset pb_msg_english "MC(event,feedrates,mode,rap_lin_rot)"   "Rapid Linear and Rotary"
::msgcat::mcset pb_msg_english "MC(event,feedrates,cycle_mode)"         "Cycle Feed Rate Mode"
::msgcat::mcset pb_msg_english "MC(event,feedrates,cycle)"              "Cycle"

### Cutcom On
::msgcat::mcset pb_msg_english "MC(event,cutcom_on,name)"               "Cutcom On"
::msgcat::mcset pb_msg_english "MC(event,cutcom_on,g_code)"             "G Code"
::msgcat::mcset pb_msg_english "MC(event,cutcom_on,left)"               "Left"
::msgcat::mcset pb_msg_english "MC(event,cutcom_on,right)"              "Right"
::msgcat::mcset pb_msg_english "MC(event,cutcom_on,app_planes)"         "Applicable Planes"
::msgcat::mcset pb_msg_english "MC(event,cutcom_on,edit_planes)"        "Edit Plane Codes"
::msgcat::mcset pb_msg_english "MC(event,cutcom_on,reg)"                "Cutcom Register"
::msgcat::mcset pb_msg_english "MC(event,cutcom_on,min)"                "Minimum"
::msgcat::mcset pb_msg_english "MC(event,cutcom_on,max)"                "Maximum"
::msgcat::mcset pb_msg_english "MC(event,cutcom_on,bef)"                "Cutcom Off Before Change"

### Cutcom Off
::msgcat::mcset pb_msg_english "MC(event,cutcom_off,name)"              "Cutcom Off"
::msgcat::mcset pb_msg_english "MC(event,cutcom_off,g_code)"            "G Code"
::msgcat::mcset pb_msg_english "MC(event,cutcom_off,off)"               "Off"

### Delay
::msgcat::mcset pb_msg_english "MC(event,delay,name)"                   "Delay"
::msgcat::mcset pb_msg_english "MC(event,delay,seconds)"                "Seconds"
::msgcat::mcset pb_msg_english "MC(event,delay,seconds,g_code)"         "G-Code"
::msgcat::mcset pb_msg_english "MC(event,delay,seconds,format)"         "Format"
::msgcat::mcset pb_msg_english "MC(event,delay,out_mode)"               "Output Mode"
::msgcat::mcset pb_msg_english "MC(event,delay,out_mode,sec)"           "Seconds Only"
::msgcat::mcset pb_msg_english "MC(event,delay,out_mode,rev)"           "Revolutions Only"
::msgcat::mcset pb_msg_english "MC(event,delay,out_mode,feed)"          "Depends On Feedrate"
::msgcat::mcset pb_msg_english "MC(event,delay,out_mode,ivs)"           "Inverse Time"
::msgcat::mcset pb_msg_english "MC(event,delay,revolution)"             "Revolutions"
::msgcat::mcset pb_msg_english "MC(event,delay,revolution,g_code)"      "G-Code"
::msgcat::mcset pb_msg_english "MC(event,delay,revolution,format)"      "Format"

### Option Stop
::msgcat::mcset pb_msg_english "MC(event,opstop,name)"                  "Opstop"

### Auxfun
::msgcat::mcset pb_msg_english "MC(event,auxfun,name)"                  "Auxfun"

### Prefun
::msgcat::mcset pb_msg_english "MC(event,prefun,name)"                  "Prefun"

### Load Tool
::msgcat::mcset pb_msg_english "MC(event,loadtool,name)"                "Load Tool"

### Stop
::msgcat::mcset pb_msg_english "MC(event,stop,name)"                    "Stop"

### Tool Preselect
::msgcat::mcset pb_msg_english "MC(event,toolpreselect,name)"           "Tool Preselect"

### Thread Wire
::msgcat::mcset pb_msg_english "MC(event,threadwire,name)"              "Thread Wire"

### Cut Wire
::msgcat::mcset pb_msg_english "MC(event,cutwire,name)"                 "Cut Wire"

### Wire Guides
::msgcat::mcset pb_msg_english "MC(event,wireguides,name)"              "Wire Guides"

### Linear Move
::msgcat::mcset pb_msg_english "MC(event,linear,name)"                  "Linear Move"
::msgcat::mcset pb_msg_english "MC(event,linear,g_code)"                "G Code"
::msgcat::mcset pb_msg_english "MC(event,linear,motion)"                "Linear Motion"
::msgcat::mcset pb_msg_english "MC(event,linear,assume)"                "Assumed Rapid Mode at Maximum Traversal Feed"

### Circular Move
::msgcat::mcset pb_msg_english "MC(event,circular,name)"                "Circular Move"
::msgcat::mcset pb_msg_english "MC(event,circular,g_code)"              "Motion G Code"
::msgcat::mcset pb_msg_english "MC(event,circular,clockwise)"           "Clockwise(CLW)"
::msgcat::mcset pb_msg_english "MC(event,circular,counter-clock)"       "Counter-Clockwise(CCLW)"
::msgcat::mcset pb_msg_english "MC(event,circular,record)"              "Circular Record"
::msgcat::mcset pb_msg_english "MC(event,circular,full_circle)"         "Full Circle"
::msgcat::mcset pb_msg_english "MC(event,circular,quadrant)"            "Quadrant"
::msgcat::mcset pb_msg_english "MC(event,circular,ijk_def)"             "IJK Definition"
::msgcat::mcset pb_msg_english "MC(event,circular,ij_def)"              "IJ Definition"
::msgcat::mcset pb_msg_english "MC(event,circular,ik_def)"              "IK Definition"
::msgcat::mcset pb_msg_english "MC(event,circular,planes)"              "Applicable Planes"
::msgcat::mcset pb_msg_english "MC(event,circular,edit_planes)"         "Edit Plane Codes"
::msgcat::mcset pb_msg_english "MC(event,circular,radius)"              "Radius"
::msgcat::mcset pb_msg_english "MC(event,circular,min)"                 "Minimum"
::msgcat::mcset pb_msg_english "MC(event,circular,max)"                 "Maximum"
::msgcat::mcset pb_msg_english "MC(event,circular,arc_len)"             "Minimum Arc Length"

### Rapid Move
::msgcat::mcset pb_msg_english "MC(event,rapid,name)"                   "Rapid Move"
::msgcat::mcset pb_msg_english "MC(event,rapid,g_code)"                 "G Code"
::msgcat::mcset pb_msg_english "MC(event,rapid,motion)"                 "Rapid Motion"
::msgcat::mcset pb_msg_english "MC(event,rapid,plane_change)"           "Work Plane Change"

### Lathe Thread
::msgcat::mcset pb_msg_english "MC(event,lathe,name)"                   "Lathe Thread"
::msgcat::mcset pb_msg_english "MC(event,lathe,g_code)"                 "Thread G Code"
::msgcat::mcset pb_msg_english "MC(event,lathe,cons)"                   "Constant"
::msgcat::mcset pb_msg_english "MC(event,lathe,incr)"                   "Incremental"
::msgcat::mcset pb_msg_english "MC(event,lathe,decr)"                   "Decremental"

### Cycle
::msgcat::mcset pb_msg_english "MC(event,cycle,g_code)"                 "G Code & Customization"
::msgcat::mcset pb_msg_english "MC(event,cycle,customize,Label)"        "Customize"
::msgcat::mcset pb_msg_english "MC(event,cycle,customize,Context)"      "This switch allows you to customize a cycle.\
                                                                         \n\nBy default, the basic construct of each cycle is defined by the settings of the Common Parameters. These common elements in each cycle are restricted to any modification.\
                                                                         \n\nToggling on this switch allows you to gain complete control over the configuration of a cycle.  Changes made to the Common Parameters will no longer affect any customized cycle."
::msgcat::mcset pb_msg_english "MC(event,cycle,start,Label)"            "Cycle Start"
::msgcat::mcset pb_msg_english "MC(event,cycle,start,Context)"          "This option can be switched on for the machine-tools that execute cycles using a cycle start block (G79...) after the cycle has been defined (G81...)."
::msgcat::mcset pb_msg_english "MC(event,cycle,start,text)"             "Use Cycle Start Block To Execute Cycle"
::msgcat::mcset pb_msg_english "MC(event,cycle,rapid_to)"               "Rapid - To"
::msgcat::mcset pb_msg_english "MC(event,cycle,retract_to)"             "Retract - To"
::msgcat::mcset pb_msg_english "MC(event,cycle,plane_control)"          "Cycle Plane Control"
::msgcat::mcset pb_msg_english "MC(event,cycle,com_param,name)"         "Common Parameters"
::msgcat::mcset pb_msg_english "MC(event,cycle,cycle_off,name)"         "Cycle Off"
::msgcat::mcset pb_msg_english "MC(event,cycle,plane_chng,name)"        "Cycle Plane Change"
::msgcat::mcset pb_msg_english "MC(event,cycle,drill,name)"             "Drill"
::msgcat::mcset pb_msg_english "MC(event,cycle,drill_dwell,name)"       "Drill Dwell"
::msgcat::mcset pb_msg_english "MC(event,cycle,drill_text,name)"        "Drill Text"
::msgcat::mcset pb_msg_english "MC(event,cycle,drill_csink,name)"       "Drill Csink"
::msgcat::mcset pb_msg_english "MC(event,cycle,drill_deep,name)"        "Drill Deep"
::msgcat::mcset pb_msg_english "MC(event,cycle,drill_brk_chip,name)"    "Drill Break Chip"
::msgcat::mcset pb_msg_english "MC(event,cycle,tap,name)"               "Tap"
::msgcat::mcset pb_msg_english "MC(event,cycle,bore,name)"              "Bore"
::msgcat::mcset pb_msg_english "MC(event,cycle,bore_dwell,name)"        "Bore Dwell"
::msgcat::mcset pb_msg_english "MC(event,cycle,bore_drag,name)"         "Bore Drag"
::msgcat::mcset pb_msg_english "MC(event,cycle,bore_no_drag,name)"      "Bore No Drag"
::msgcat::mcset pb_msg_english "MC(event,cycle,bore_back,name)"         "Bore Back"
::msgcat::mcset pb_msg_english "MC(event,cycle,bore_manual,name)"       "Bore Manual"
::msgcat::mcset pb_msg_english "MC(event,cycle,bore_manual_dwell,name)" "Bore Manual Dwell"
::msgcat::mcset pb_msg_english "MC(event,cycle,peck_drill,name)"        "Peck Drill"
::msgcat::mcset pb_msg_english "MC(event,cycle,break_chip,name)"        "Break Chip"
::msgcat::mcset pb_msg_english "MC(event,cycle,drill_dwell_sf,name)"    "Drill Dwell (SpotFace)"
::msgcat::mcset pb_msg_english "MC(event,cycle,drill_deep_peck,name)"   "Drill Deep (Peck)"
::msgcat::mcset pb_msg_english "MC(event,cycle,bore_ream,name)"         "Bore (Ream)"
::msgcat::mcset pb_msg_english "MC(event,cycle,bore_no-drag,name)"      "Bore No-Drag"

##------------
## G Code
##
::msgcat::mcset pb_msg_english "MC(g_code,rapid,name)"                  "Motion Rapid"
::msgcat::mcset pb_msg_english "MC(g_code,linear,name)"                 "Motion Linear"
::msgcat::mcset pb_msg_english "MC(g_code,circular_clw,name)"           "Circular Interperlation CLW"
::msgcat::mcset pb_msg_english "MC(g_code,circular_cclw,name)"          "Circular Interperlation CCLW"
::msgcat::mcset pb_msg_english "MC(g_code,delay_sec,name)"              "Delay (Sec)"
::msgcat::mcset pb_msg_english "MC(g_code,delay_rev,name)"              "Delay (Rev)"
::msgcat::mcset pb_msg_english "MC(g_code,pln_xy,name)"                 "Plane XY"
::msgcat::mcset pb_msg_english "MC(g_code,pln_zx,name)"                 "Plane ZX"
::msgcat::mcset pb_msg_english "MC(g_code,pln_yz,name)"                 "Plane YZ"
::msgcat::mcset pb_msg_english "MC(g_code,cutcom_off,name)"             "Cutcom Off"
::msgcat::mcset pb_msg_english "MC(g_code,cutcom_left,name)"            "Cutcom Left"
::msgcat::mcset pb_msg_english "MC(g_code,cutcom_right,name)"           "Cutcom Right"
::msgcat::mcset pb_msg_english "MC(g_code,length_plus,name)"            "Tool Length Adjust Plus"
::msgcat::mcset pb_msg_english "MC(g_code,length_minus,name)"           "Tool Length Adjust Minus"
::msgcat::mcset pb_msg_english "MC(g_code,length_off,name)"             "Tool Length Adjust Off"
::msgcat::mcset pb_msg_english "MC(g_code,inch,name)"                   "Inch Mode"
::msgcat::mcset pb_msg_english "MC(g_code,metric,name)"                 "Metric Mode"
::msgcat::mcset pb_msg_english "MC(g_code,cycle_start,name)"            "Cycle Start Code"
::msgcat::mcset pb_msg_english "MC(g_code,cycle_off,name)"              "Cycle Off"
::msgcat::mcset pb_msg_english "MC(g_code,cycle_drill,name)"            "Cycle Drill"
::msgcat::mcset pb_msg_english "MC(g_code,cycle_drill_dwell,name)"      "Cycle Drill Dwell"
::msgcat::mcset pb_msg_english "MC(g_code,cycle_drill_deep,name)"       "Cycle Drill Deep"
::msgcat::mcset pb_msg_english "MC(g_code,cycle_drill_bc,name)"         "Cycle Drill Break Chip"
::msgcat::mcset pb_msg_english "MC(g_code,tap,name)"                    "Cycle Tap"
::msgcat::mcset pb_msg_english "MC(g_code,bore,name)"                   "Cycle Bore"
::msgcat::mcset pb_msg_english "MC(g_code,bore_drag,name)"              "Cycle Bore Drag"
::msgcat::mcset pb_msg_english "MC(g_code,bore_no_drag,name)"           "Cycle Bore No Drag"
::msgcat::mcset pb_msg_english "MC(g_code,bore_dwell,name)"             "Cycle Bore Dwell"
::msgcat::mcset pb_msg_english "MC(g_code,bore_manual,name)"            "Cycle Bore Manual"
::msgcat::mcset pb_msg_english "MC(g_code,bore_back,name)"              "Cycle Bore Back"
::msgcat::mcset pb_msg_english "MC(g_code,bore_manual_dwell,name)"      "Cycle Bore Manual Dwell"
::msgcat::mcset pb_msg_english "MC(g_code,abs,name)"                    "Absolute Mode"
::msgcat::mcset pb_msg_english "MC(g_code,inc,name)"                    "Incremental Mode"
::msgcat::mcset pb_msg_english "MC(g_code,cycle_retract_auto,name)"     "Cycle Retract (AUTO)"
::msgcat::mcset pb_msg_english "MC(g_code,cycle_retract_manual,name)"   "Cycle Retract (MANUAL)"
::msgcat::mcset pb_msg_english "MC(g_code,reset,name)"                  "Reset"
::msgcat::mcset pb_msg_english "MC(g_code,fr_ipm,name)"                 "Feedrate Mode IPM"
::msgcat::mcset pb_msg_english "MC(g_code,fr_ipr,name)"                 "Feedrate Mode IPR"
::msgcat::mcset pb_msg_english "MC(g_code,fr_frn,name)"                 "Feedrate Mode FRN"
::msgcat::mcset pb_msg_english "MC(g_code,spindle_css,name)"            "Spindle CSS"
::msgcat::mcset pb_msg_english "MC(g_code,spindle_rpm,name)"            "Spindle RPM"
::msgcat::mcset pb_msg_english "MC(g_code,ret_home,name)"               "Return Home"
::msgcat::mcset pb_msg_english "MC(g_code,cons_thread,name)"            "Constant Thread"
::msgcat::mcset pb_msg_english "MC(g_code,incr_thread,name)"            "Incremental Thread"
::msgcat::mcset pb_msg_english "MC(g_code,decr_thread,name)"            "Decremental Thread"
::msgcat::mcset pb_msg_english "MC(g_code,feedmode_in,pm)"              "Feedrate Mode IPM"
::msgcat::mcset pb_msg_english "MC(g_code,feedmode_in,pr)"              "Feedrate Mode IPR"
::msgcat::mcset pb_msg_english "MC(g_code,feedmode_mm,pm)"              "Feedrate Mode MMPM"
::msgcat::mcset pb_msg_english "MC(g_code,feedmode_mm,pr)"              "Feedrate Mode MMPR"
::msgcat::mcset pb_msg_english "MC(g_code,feedmode,dpm)"                "Feedrate Mode DPM"

##------------
## M Code
##
::msgcat::mcset pb_msg_english "MC(m_code,stop_manual_tc,name)"         "Stop/Manual Tool Change"
::msgcat::mcset pb_msg_english "MC(m_code,stop,name)"                   "Stop"
::msgcat::mcset pb_msg_english "MC(m_code,opt_stop,name)"               "Opstop"
::msgcat::mcset pb_msg_english "MC(m_code,prog_end,name)"               "Program End"
::msgcat::mcset pb_msg_english "MC(m_code,spindle_clw,name)"            "Spindle On/CLW"
::msgcat::mcset pb_msg_english "MC(m_code,spindle_cclw,name)"           "Spindle CCLW"
::msgcat::mcset pb_msg_english "MC(m_code,lathe_thread,type1)"          "Constant Thread"
::msgcat::mcset pb_msg_english "MC(m_code,lathe_thread,type2)"          "Incremental Thread"
::msgcat::mcset pb_msg_english "MC(m_code,lathe_thread,type3)"          "Decremental Thread"
::msgcat::mcset pb_msg_english "MC(m_code,spindle_off,name)"            "Spindle Off"
::msgcat::mcset pb_msg_english "MC(m_code,tc_retract,name)"             "Tool Change/Retract"
::msgcat::mcset pb_msg_english "MC(m_code,coolant_on,name)"             "Coolant On"
::msgcat::mcset pb_msg_english "MC(m_code,coolant_fld,name)"            "Coolant Flood"
::msgcat::mcset pb_msg_english "MC(m_code,coolant_mist,name)"           "Coolant Mist"
::msgcat::mcset pb_msg_english "MC(m_code,coolant_thru,name)"           "Coolant Thru"
::msgcat::mcset pb_msg_english "MC(m_code,coolant_tap,name)"            "Coolant Tap"
::msgcat::mcset pb_msg_english "MC(m_code,coolant_off,name)"            "Coolant Off"
::msgcat::mcset pb_msg_english "MC(m_code,rewind,name)"                 "Rewind"
::msgcat::mcset pb_msg_english "MC(m_code,thread_wire,name)"            "Thread Wire"
::msgcat::mcset pb_msg_english "MC(m_code,cut_wire,name)"               "Cut Wire"
::msgcat::mcset pb_msg_english "MC(m_code,fls_on,name)"                 "Flushing On"
::msgcat::mcset pb_msg_english "MC(m_code,fls_off,name)"                "Flushing Off"
::msgcat::mcset pb_msg_english "MC(m_code,power_on,name)"               "Power On"
::msgcat::mcset pb_msg_english "MC(m_code,power_off,name)"              "Power Off"
::msgcat::mcset pb_msg_english "MC(m_code,wire_on,name)"                "Wire On"
::msgcat::mcset pb_msg_english "MC(m_code,wire_off,name)"               "Wire Off"
::msgcat::mcset pb_msg_english "MC(m_code,pri_turret,name)"             "Primary Turret"
::msgcat::mcset pb_msg_english "MC(m_code,sec_turret,name)"             "Secondary Turret"

##------------
## UDE
##
::msgcat::mcset pb_msg_english "MC(ude,editor,enable,Label)"            "Enable UDE Editor"
::msgcat::mcset pb_msg_english "MC(ude,editor,enable,as_saved,Label)"   "As Saved"
::msgcat::mcset pb_msg_english "MC(ude,editor,TITLE)"                   "User Defined Event"

::msgcat::mcset pb_msg_english "MC(ude,editor,no_ude)"                  "No relevant UDE!"

::msgcat::mcset pb_msg_english "MC(ude,editor,int,Label)"               "Integer"
::msgcat::mcset pb_msg_english "MC(ude,editor,int,Context)"             "Add a new integer parameter by dragging it to right list."

::msgcat::mcset pb_msg_english "MC(ude,editor,real,Label)"              "Real"
::msgcat::mcset pb_msg_english "MC(ude,editor,real,Context)"            "Add a new real parameter by dragging it to right list."

::msgcat::mcset pb_msg_english "MC(ude,editor,txt,Label)"               "Text"
::msgcat::mcset pb_msg_english "MC(ude,editor,txt,Context)"             "Add a new string parameter by dragging it to right list."

::msgcat::mcset pb_msg_english "MC(ude,editor,bln,Label)"               "Boolean"
::msgcat::mcset pb_msg_english "MC(ude,editor,bln,Context)"             "Add a new boolean parameter by dragging it to right list."

::msgcat::mcset pb_msg_english "MC(ude,editor,opt,Label)"               "Option"
::msgcat::mcset pb_msg_english "MC(ude,editor,opt,Context)"             "Add a new option parameter by dragging it to right list."

::msgcat::mcset pb_msg_english "MC(ude,editor,pnt,Label)"               "Point"
::msgcat::mcset pb_msg_english "MC(ude,editor,pnt,Context)"             "Add a new point parameter by dragging it to right list."

::msgcat::mcset pb_msg_english "MC(ude,editor,trash,Label)"             "Editor -- Trash Can"
::msgcat::mcset pb_msg_english "MC(ude,editor,trash,Context)"           "You may dispose any unwanted parameters from the right list by drag them to this trash can."

::msgcat::mcset pb_msg_english "MC(ude,editor,event,Label)"             "Event"
::msgcat::mcset pb_msg_english "MC(ude,editor,event,Context)"           "You can edit event's parameters here by MB1."

::msgcat::mcset pb_msg_english "MC(ude,editor,param,Label)"             "Event -- Parameters"
::msgcat::mcset pb_msg_english "MC(ude,editor,param,Context)"           "You can edit each parameter by right clicking or change the parameters order by drag&drop.\n\
                                                                         \nThe parameter in lightblue is system defined that can not be deleted.\
                                                                         \nThe parameter in burlywood is non-system defined that can be modified or deleted."

::msgcat::mcset pb_msg_english "MC(ude,editor,param,edit,Label)"        "Parameters -- Option"
::msgcat::mcset pb_msg_english "MC(ude,editor,param,edit,Context)"      "Click mouse button 1 to select default option.\n\
                                                                         Double click mouse button 1 to edit option."
::msgcat::mcset pb_msg_english "MC(ude,editor,param,editor,Label)"      "Parameter Type: "

::msgcat::mcset pb_msg_english "MC(ude,editor,pnt,sel,Label)"           "Select"
::msgcat::mcset pb_msg_english "MC(ude,editor,pnt,dsp,Label)"           "Display"

::msgcat::mcset pb_msg_english "MC(ude,editor,dlg,ok,Label)"            "OK"
::msgcat::mcset pb_msg_english "MC(ude,editor,dlg,bck,Label)"           "Back"
::msgcat::mcset pb_msg_english "MC(ude,editor,dlg,cnl,Label)"           "Cancel"

::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,PL,Label)"       "Parameter Label"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,VN,Label)"       "Variable Name"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,DF,Label)"       "Default Value"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,PL,Context)"     "Specify the parameter label"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,VN,Context)"     "Specify the variable name"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,DF,Context)"     "Specify the default value"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,TG)"             "Toggle"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,TG,B,Label)"     "Toggle"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,TG,B,Context)"   "Select the toggle value"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,ON,Label)"       "On"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,OFF,Label)"      "Off"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,ON,Context)"     "Select the default value as ON"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,OFF,Context)"    "Select the default value as OFF"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,OL)"             "Option List"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,ADD,Label)"      "Add"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,CUT,Label)"      "Cut"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,PASTE,Label)"    "Paste"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,ADD,Context)"    "Add an item"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,CUT,Context)"    "Cut an item"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,PASTE,Context)"  "Paste an item"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,ENTRY,Label)"    "Option"
::msgcat::mcset pb_msg_english "MC(ude,editor,paramdlg,ENTRY,Context)"  "Enter an item"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,EN,Label)"       "Event Name"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,EN,Context)"     "Specify the event name"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,PEN,Label)"      "Post Name"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,PEN,Context)"    "Specify the post name"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,PEN,C,Label)"    "Post Name"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,PEN,C,Context)"  "This switch allows you whether to set post name"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,EL,Label)"       "Event Label"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,EL,Context)"     "Specify the event label"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,EL,C,Label)"     "Event Label"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,EL,C,Context)"   "This switch allows you whether to set event label"

::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,EC,Label)"           "Category"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,EC,Context)"         "This switch allows you whether to set category"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,EC_MILL,Label)"      "Mill"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,EC_DRILL,Label)"     "Drill"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,EC_LATHE,Label)"     "Lathe"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,EC_WEDM,Label)"      "Wedm"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,EC_MILL,Context)"    "Set mill category"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,EC_DRILL,Context)"   "Set drill category"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,EC_LATHE,Context)"   "Set lathe category"
::msgcat::mcset pb_msg_english "MC(ude,editor,eventdlg,EC_WEDM,Context)"    "Set wedm category"

::msgcat::mcset pb_msg_english "MC(ude,editor,EDIT)"                    "Edit Event"
::msgcat::mcset pb_msg_english "MC(ude,editor,CREATE)"                  "Create Machine Control Event"
::msgcat::mcset pb_msg_english "MC(ude,editor,popup,HELP)"              "Help"
::msgcat::mcset pb_msg_english "MC(ude,editor,popup,EDIT)"              "Edit User Defined Parameters..."
::msgcat::mcset pb_msg_english "MC(ude,editor,param,EDIT)"              "Edit..."
::msgcat::mcset pb_msg_english "MC(ude,editor,param,VIEW)"              "View..."
::msgcat::mcset pb_msg_english "MC(ude,editor,popup,DELETE)"            "Delete"
::msgcat::mcset pb_msg_english "MC(ude,editor,popup,CREATE)"            "Create New Machine Control Event..."
::msgcat::mcset pb_msg_english "MC(ude,editor,popup,IMPORT)"            "Import Machine Control Events..."
::msgcat::mcset pb_msg_english "MC(ude,editor,popup,MSG_BLANK)"         "The event name could not be blank!"
::msgcat::mcset pb_msg_english "MC(ude,editor,popup,MSG_SAMENAME)"      "The event name exists!"
::msgcat::mcset pb_msg_english "MC(ude,editor,popup,MSG_SameHandler)"   "Event handler exists!\
                                                                         \nPlease modify the event name or post name,if it is checked!"
::msgcat::mcset pb_msg_english "MC(ude,validate)"                       "There is no parameter in this event!"
::msgcat::mcset pb_msg_english "MC(ude,prev,tab,Label)"                 "User Defined Events"
::msgcat::mcset pb_msg_english "MC(ude,prev,ude,Label)"                 "Machine Control Events"
::msgcat::mcset pb_msg_english "MC(ude,prev,udc,Label)"                 "User Defined Cycles"
::msgcat::mcset pb_msg_english "MC(ude,prev,mc,Label)"                  "System Machine Control Events"
::msgcat::mcset pb_msg_english "MC(ude,prev,nmc,Label)"                 "Non-System Machine Control Events"
::msgcat::mcset pb_msg_english "MC(udc,prev,sys,Label)"                 "System Cycles"
::msgcat::mcset pb_msg_english "MC(udc,prev,nsys,Label)"                "Non-System Cycles"
::msgcat::mcset pb_msg_english "MC(ude,prev,Status)"                    "Choose the item to definition"
::msgcat::mcset pb_msg_english "MC(ude,editor,opt,MSG_BLANK)"           "The option string could not be blank!"
::msgcat::mcset pb_msg_english "MC(ude,editor,opt,MSG_SAME)"            "The option string exists!"
::msgcat::mcset pb_msg_english "MC(ude,editor,opt,MSG_PST_SAME)"        "The option you paste exists!"
::msgcat::mcset pb_msg_english "MC(ude,editor,opt,MSG_IDENTICAL)"       "Some options are identical!"
::msgcat::mcset pb_msg_english "MC(ude,editor,opt,NO_OPT)"              "There is no option in the list!"
::msgcat::mcset pb_msg_english "MC(ude,editor,param,MSG_NO_VNAME)"      "The variable name could not be blank!"
::msgcat::mcset pb_msg_english "MC(ude,editor,param,MSG_EXIST_VNAME)"   "The variable name exists!"
::msgcat::mcset pb_msg_english "MC(ude,editor,spindle_css,INFO)"        "This event shares the UDE with \"Spindle RPM\""
::msgcat::mcset pb_msg_english "MC(ude,import,ihr,Label)"               "Inherit UDE From A Post"

::msgcat::mcset pb_msg_english "MC(ude,import,ihr,Context)"             "This option enables this post to inherit UDE definition and their handlers from a post."

::msgcat::mcset pb_msg_english "MC(ude,import,sel,Label)"               "Select Post"

::msgcat::mcset pb_msg_english "MC(ude,import,sel,Context)"             "Select the PUI file of the desired post. It's recommanded all files (PUI, Def, Tcl & CDL) associated with the post being inherited be placed in the same directory (folder) for runtime utilization."

::msgcat::mcset pb_msg_english "MC(ude,import,name_cdl,Label)"          "CDL File Name"

::msgcat::mcset pb_msg_english "MC(ude,import,name_cdl,Context)"        "Path and file name of the CDL file associated with the selected post that will be referenced (INCLUDE) in the definition file of this post.  The path name must start with a UG environment variable (\\\$UGII) or none.  When no path is specified, UGII_CAM_FILE_SEARCH_PATH will be used to locate the file by UG/NX at runtime."

::msgcat::mcset pb_msg_english "MC(ude,import,name_def,Label)"          "Def File Name"
::msgcat::mcset pb_msg_english "MC(ude,import,name_def,Context)"        "Path and file name of the definition file of the selected post that will be referenced (INCLUDE) in the definition file of this post.  The path name must start with a UG environment variable (\\\$UGII) or none.  When no path is specified, UGII_CAM_FILE_SEARCH_PATH will be used to locate the file by UG/NX at runtime."

::msgcat::mcset pb_msg_english "MC(ude,import,include_cdl,Label)"       "CDL"
::msgcat::mcset pb_msg_english "MC(ude,import,ihr_pst,Label)"           "Post"
::msgcat::mcset pb_msg_english "MC(ude,import,ihr_folder,Label)"        "Folder"
::msgcat::mcset pb_msg_english "MC(ude,import,own_folder,Label)"        "Folder"
::msgcat::mcset pb_msg_english "MC(ude,import,own,Label)"               "Include Own CDL File"

::msgcat::mcset pb_msg_english "MC(ude,import,own,Context)"             "This option enables this post to include the reference to its own CDL file in its definition file."

::msgcat::mcset pb_msg_english "MC(ude,import,own_ent,Label)"           "Own CDL File"

::msgcat::mcset pb_msg_english "MC(ude,import,own_ent,Context)"         "Path and file name of the CDL file associated with this post to be referenced (INCLUDE) in the definition file of this post.  The actual file name will be determined when this post is saved.  The path name must start with a UG environment variable (\\\$UGII) or none.  When no path is specified, UGII_CAM_FILE_SEARCH_PATH will be used to locate the file by UG/NX at runtime."

::msgcat::mcset pb_msg_english "MC(ude,import,sel,pui,status)"          "Select a PUI file"
::msgcat::mcset pb_msg_english "MC(ude,import,sel,cdl,status)"          "Select a CDL file"

##---------
## UDC
##
::msgcat::mcset pb_msg_english "MC(udc,editor,TITLE)"                   "User Defined Cycle"
::msgcat::mcset pb_msg_english "MC(udc,editor,CREATE)"                  "Create User Defined Cycle"
::msgcat::mcset pb_msg_english "MC(udc,editor,TYPE)"                    "Cycle Type"
::msgcat::mcset pb_msg_english "MC(udc,editor,type,UDC)"                "User Defined"
::msgcat::mcset pb_msg_english "MC(udc,editor,type,SYSUDC)"             "System Defined"
::msgcat::mcset pb_msg_english "MC(udc,editor,CYCLBL,Label)"            "Cycle Label"
::msgcat::mcset pb_msg_english "MC(udc,editor,CYCNAME,Label)"           "Cycle Name"
::msgcat::mcset pb_msg_english "MC(udc,editor,CYCLBL,Context)"          "Specify the cycle label"
::msgcat::mcset pb_msg_english "MC(udc,editor,CYCNAME,Context)"         "Specify the cycle name"
::msgcat::mcset pb_msg_english "MC(udc,editor,CYCLBL,C,Label)"          "Cycle Label"
::msgcat::mcset pb_msg_english "MC(udc,editor,CYCLBL,C,Context)"        "This switch allows you to set cycle label"
::msgcat::mcset pb_msg_english "MC(udc,editor,popup,EDIT)"              "Edit User Defined Parameters..."
::msgcat::mcset pb_msg_english "MC(udc,editor,popup,MSG_BLANK)"         "The cycle name could not be blank!"
::msgcat::mcset pb_msg_english "MC(udc,editor,popup,MSG_SAMENAME)"      "The cycle name exists!"
::msgcat::mcset pb_msg_english "MC(udc,editor,popup,MSG_SameHandler)"   "Event handler exists!\n\
                                                                         Please modify the cycle event name!"
::msgcat::mcset pb_msg_english "MC(udc,editor,popup,MSG_ISSYSCYC)"      "The cycle name belongs to System Cycle type!"
::msgcat::mcset pb_msg_english "MC(udc,editor,popup,MSG_SYSCYC_EXIST)"  "This kind of  System Cycle exists!"
::msgcat::mcset pb_msg_english "MC(udc,editor,EDIT)"                    "Edit Cycle Event"
::msgcat::mcset pb_msg_english "MC(udc,editor,popup,CREATE)"            "Create New User Defined Cycle..."
::msgcat::mcset pb_msg_english "MC(udc,editor,popup,IMPORT)"            "Import User Defined Cycles..."
::msgcat::mcset pb_msg_english "MC(udc,drill,csink,INFO)"               "This event shares the handler with Drill!"
::msgcat::mcset pb_msg_english "MC(udc,drill,simulate,INFO)"            "This event is one kind of simulated cycles!"
::msgcat::mcset pb_msg_english "MC(udc,drill,dwell,INFO)"               "This event shares the User Defined Cycle with "


#######
# IS&V
#######
::msgcat::mcset pb_msg_english "MC(isv,tab,label)"                      "Virtual N/C Controller"
::msgcat::mcset pb_msg_english "MC(isv,Status)"                         "Specify parameters for ISV"
::msgcat::mcset pb_msg_english "MC(isv,review,Status)"                  "Review VNC Commands"

::msgcat::mcset pb_msg_english "MC(isv,setup,Label)"                    "Configuration"
::msgcat::mcset pb_msg_english "MC(isv,vnc_command,Label)"              "VNC Commands"
####################
# General Definition
####################
::msgcat::mcset pb_msg_english "MC(isv,select_Main)"                    "Select master VNC file for a subordinate VNC."
::msgcat::mcset pb_msg_english "MC(isv,setup,machine,Label)"            "Machine Tool"
::msgcat::mcset pb_msg_english "MC(isv,setup,component,Label)"          "Tool Mounting"
::msgcat::mcset pb_msg_english "MC(isv,setup,mac_zcs_frame,Label)"      "Program Zero Reference"
::msgcat::mcset pb_msg_english "MC(isv,setup,mac_zcs,Label)"            "Component"
::msgcat::mcset pb_msg_english "MC(isv,setup,mac_zcs,Context)"          "Specify a component as the ZCS reference base. It should be a non-rotating component that the part is connected to directly or indirectly in the Kinematics tree."
::msgcat::mcset pb_msg_english "MC(isv,setup,spin_com,Label)"           "Component"
::msgcat::mcset pb_msg_english "MC(isv,setup,spin_com,Context)"         "Specify a component that tools will be mounted on. It should be the spindle component for a mill post and the turret component for a lathe post."

::msgcat::mcset pb_msg_english "MC(isv,setup,spin_jct,Label)"           "Junction"
::msgcat::mcset pb_msg_english "MC(isv,setup,spin_jct,Context)"         "Define a Junction for mounting tools. It's the Juction at the center of spindle face for a mill post. It's the turret rotating Junction for a lathe post. It will be the tool mounting Junction, if the turrent is fixed."

::msgcat::mcset pb_msg_english "MC(isv,setup,axis_name,Label)"          "Axis Specified on Machine Tool"
::msgcat::mcset pb_msg_english "MC(isv,setup,axis_name,Context)"        "Specify the axis names to match your machine tool kinematics configuration"




::msgcat::mcset pb_msg_english "MC(isv,setup,axis_frm,Label)"           "NC Axis Names"
::msgcat::mcset pb_msg_english "MC(isv,setup,rev_fourth,Label)"         "Reverse Rotation"
::msgcat::mcset pb_msg_english "MC(isv,setup,rev_fourth,Context)"       "Specify rotary direction of the axis, It can be either reversed or normal.  This is only applicable for a rotary table."
::msgcat::mcset pb_msg_english "MC(isv,setup,rev_fifth,Label)"          "Reverse Rotation"

::msgcat::mcset pb_msg_english "MC(isv,setup,fourth_limit,Label)"       "Rotary Limit"
::msgcat::mcset pb_msg_english "MC(isv,setup,fourth_limit,Context)"     "Specify if this rotary axis has limits"
::msgcat::mcset pb_msg_english "MC(isv,setup,fifth_limit,Label)"        "Rotary Limit"
::msgcat::mcset pb_msg_english "MC(isv,setup,limiton,Label)"            "Yes"
::msgcat::mcset pb_msg_english "MC(isv,setup,limitoff,Label)"           "No"
::msgcat::mcset pb_msg_english "MC(isv,setup,fourth_table,Label)"       "4th Axis"
::msgcat::mcset pb_msg_english "MC(isv,setup,fifth_table,Label)"        "5th Axis"
::msgcat::mcset pb_msg_english "MC(isv,setup,header,Label)"             " Table "
::msgcat::mcset pb_msg_english "MC(isv,setup,intialization,Label)"      "Controller"
::msgcat::mcset pb_msg_english "MC(isv,setup,general_def,Label)"        "Initial Setting"
::msgcat::mcset pb_msg_english "MC(isv,setup,advanced_def,Label)"       "Other Options"
::msgcat::mcset pb_msg_english "MC(isv,setup,InputOutput,Label)"        "Special NC Codes"

::msgcat::mcset pb_msg_english "MC(isv,setup,program,Label)"            "Default Program Definition"
::msgcat::mcset pb_msg_english "MC(isv,setup,output,Label)"             "Export Program Definition"
::msgcat::mcset pb_msg_english "MC(isv,setup,output,Context)"           "Save Program Definition to a file"
::msgcat::mcset pb_msg_english "MC(isv,setup,input,Label)"              "Import Program Definition"
::msgcat::mcset pb_msg_english "MC(isv,setup,input,Context)"            "Retrieve Program Definition from a file"
::msgcat::mcset pb_msg_english "MC(isv,setup,file_err,Msg)"             "The selected file doesn't match default Program Definition File type, do you want to proceed?"
::msgcat::mcset pb_msg_english "MC(isv,setup,wcs,Label)"                "Fixture Offsets"
::msgcat::mcset pb_msg_english "MC(isv,setup,tool,Label)"               "Tool Data"
::msgcat::mcset pb_msg_english "MC(isv,setup,g_code,Label)"             "Special G code"
::msgcat::mcset pb_msg_english "MC(isv,setup,special_vnc,Label)"        "Special NC Code"

::msgcat::mcset pb_msg_english "MC(isv,setup,initial,frame,Label)"      ""
::msgcat::mcset pb_msg_english "MC(isv,setup,initial_motion,Label)"     "Motion"
::msgcat::mcset pb_msg_english "MC(isv,setup,initial_motion,Context)"   "Specify initial motion of Machine Tool"

::msgcat::mcset pb_msg_english "MC(isv,setup,spindle,frame,Label)"      "Spindle"
::msgcat::mcset pb_msg_english "MC(isv,setup,spindle_mode,Label)"       "Mode"
::msgcat::mcset pb_msg_english "MC(isv,setup,spindle_direction,Label)"  "Direction"
::msgcat::mcset pb_msg_english "MC(isv,setup,spindle,frame,Context)"    "Specify initial spindle speed unit and rotary direction"

::msgcat::mcset pb_msg_english "MC(isv,setup,feedrate_mode,Label)"      "Feed Rate Mode"
::msgcat::mcset pb_msg_english "MC(isv,setup,feedrate_mode,Context)"    "Specify initial feedrate unit"

::msgcat::mcset pb_msg_english "MC(isv,setup,boolean,frame,Label)"      "Boolean Item Define"
::msgcat::mcset pb_msg_english "MC(isv,setup,power_on_wcs,Label)"       "Power On WCS  "
::msgcat::mcset pb_msg_english "MC(isv,setup,power_on_wcs,Context)"     "0 indicates default machine zero coordinate will be used\n\
                                                                         1 indeicates the first user define fixture offset (work coordinate) will be used"

::msgcat::mcset pb_msg_english "MC(isv,setup,use_s_leader,Label)"       "S used"
::msgcat::mcset pb_msg_english "MC(isv,setup,use_f_leader,Label)"       "F used"


::msgcat::mcset pb_msg_english "MC(isv,setup,dog_leg,Label)"            "Dogleg Rapid"
::msgcat::mcset pb_msg_english "MC(isv,setup,dog_leg,Context)"          "ON will traverse the rapid moves in dogleg fashion; OFF will traverse the rapid moves according to the NC code (point-to point)."

::msgcat::mcset pb_msg_english "MC(isv,setup,dog_leg,yes)"              "Yes"
::msgcat::mcset pb_msg_english "MC(isv,setup,dog_leg,no)"               "No"

::msgcat::mcset pb_msg_english "MC(isv,setup,on_off_frame,Label)"       "ON/OFF Define"
::msgcat::mcset pb_msg_english "MC(isv,setup,stroke_limit,Label)"       "Stroke Limit"
::msgcat::mcset pb_msg_english "MC(isv,setup,cutcom,Label)"             "Cutcom"
::msgcat::mcset pb_msg_english "MC(isv,setup,tl_adjust,Label)"          "Tool Length Adjust"
::msgcat::mcset pb_msg_english "MC(isv,setup,scale,Label)"              "Scale"
::msgcat::mcset pb_msg_english "MC(isv,setup,macro_modal,Label)"        "Macro Modal"
::msgcat::mcset pb_msg_english "MC(isv,setup,wcs_rotate,Label)"         "WCS Rotate"
::msgcat::mcset pb_msg_english "MC(isv,setup,cycle,Label)"              "Cycle"

::msgcat::mcset pb_msg_english "MC(isv,setup,initial_mode,frame,Label)"     "Input Mode"
::msgcat::mcset pb_msg_english "MC(isv,setup,initial_mode,frame,Context)"   "Specify initial input mode as either absolut or incremental"

###################
# Input/Out Related
###################
::msgcat::mcset pb_msg_english "MC(isv,sign_define,frame,Label)"        ""
::msgcat::mcset pb_msg_english "MC(isv,sign_define,rewindstop,Label)"   "Rewind Stop Code"
::msgcat::mcset pb_msg_english "MC(isv,sign_define,rewindstop,Context)" "Specify the Rewind Stop code"

::msgcat::mcset pb_msg_english "MC(isv,control_var,frame,Label)"        "Control Variables"

::msgcat::mcset pb_msg_english "MC(isv,sign_define,convarleader,Label)"     "Leader"
::msgcat::mcset pb_msg_english "MC(isv,sign_define,convarleader,Context)"   "Specify the controller variable"
::msgcat::mcset pb_msg_english "MC(isv,sign_define,conequ,Label)"           "Equal Sign"
::msgcat::mcset pb_msg_english "MC(isv,sign_define,conequ,Context)"         "Specify the control Equal Sign"
::msgcat::mcset pb_msg_english "MC(isv,sign_define,percent,Label)"          "Percent sign %"
::msgcat::mcset pb_msg_english "MC(isv,sign_define,leaderjing,Label)"       "Sharp #"
::msgcat::mcset pb_msg_english "MC(isv,sign_define,text_string,Label)"      "Text string"

::msgcat::mcset pb_msg_english "MC(isv,inputmode,frame,Label)"          ""
::msgcat::mcset pb_msg_english "MC(isv,input_mode,Label)"               "Initial Mode"
::msgcat::mcset pb_msg_english "MC(isv,absolute_mode,Label)"            "Absolute"
::msgcat::mcset pb_msg_english "MC(isv,incremental_style,frame,Label)"  "Incremental Mode"

::msgcat::mcset pb_msg_english "MC(isv,incremental_mode,Label)"         "Incremental"
::msgcat::mcset pb_msg_english "MC(isv,incremental_gcode,Label)"        "G code"
::msgcat::mcset pb_msg_english "MC(isv,incremental_gcode,Context)"      "Using G90 G91 to differentiate absolute mode or incremental mode"
::msgcat::mcset pb_msg_english "MC(isv,incremental_uvw,Label)"          "Special Leader"
::msgcat::mcset pb_msg_english "MC(isv,incremental_uvw,Context)"        "Using special leader to diffentiate absolute mode or incremental mode. fg: Leader X Y Z indate it's in absolute mode, Leader U V W indicate it's in incremental mode."
::msgcat::mcset pb_msg_english "MC(isv,incr_x,Label)"                   "X "
::msgcat::mcset pb_msg_english "MC(isv,incr_y,Label)"                   "Y "
::msgcat::mcset pb_msg_english "MC(isv,incr_z,Label)"                   "Z "
::msgcat::mcset pb_msg_english "MC(isv,incr_a,Label)"                   "Fourth Axis "
::msgcat::mcset pb_msg_english "MC(isv,incr_b,Label)"                   "Fifthf Axis "

::msgcat::mcset pb_msg_english "MC(isv,incr_x,Context)"                 "Specify special X Axis leader used in incremental style"
::msgcat::mcset pb_msg_english "MC(isv,incr_y,Context)"                 "Specify special Y Axis leader used in incremental style"
::msgcat::mcset pb_msg_english "MC(isv,incr_z,Context)"                 "Specify special Z Axis leader used in incremental style"
::msgcat::mcset pb_msg_english "MC(isv,incr_a,Context)"                 "Specify special Fourth Axis leader used in incremental style"
::msgcat::mcset pb_msg_english "MC(isv,incr_b,Context)"                 "Specify special Fifth Axis leader used in incremental style"
::msgcat::mcset pb_msg_english "MC(isv,vnc_mes,frame,Label)"            "Output VNC Message"

::msgcat::mcset pb_msg_english "MC(isv,vnc_message,Label)"              "List VNC Message"
::msgcat::mcset pb_msg_english "MC(isv,vnc_message,Context)"            "If this option is checked, all the VNC debug mesages will be displayed in operation message window during simulation."

::msgcat::mcset pb_msg_english "MC(isv,vnc_mes,prefix,Label)"           "Message Prefix"
::msgcat::mcset pb_msg_english "MC(isv,spec_desc,Label)"                "Description"
::msgcat::mcset pb_msg_english "MC(isv,spec_codelist,Label)"            "Code List"
::msgcat::mcset pb_msg_english "MC(isv,spec_nccode,Label)"              "NC Code / String"

################
# WCS Definition
################
::msgcat::mcset pb_msg_english "MC(isv,machine_zero,offset,Label)"      "Machine Zero Offsets from\nMachine Tool Zero Junction"
::msgcat::mcset pb_msg_english "MC(isv,wcs_offset,frame,Label)"         "Fixture Offsets"
::msgcat::mcset pb_msg_english "MC(isv,wcs_leader,Label)"               " Code "
::msgcat::mcset pb_msg_english "MC(isv,wcs_number,Label)"               "    "
::msgcat::mcset pb_msg_english "MC(isv,wcs_offset,origin_x,Label)"      " X-Offset  "
::msgcat::mcset pb_msg_english "MC(isv,wcs_offset,origin_y,Label)"      " Y-Offset  "
::msgcat::mcset pb_msg_english "MC(isv,wcs_offset,origin_z,Label)"      " Z-Offset  "
::msgcat::mcset pb_msg_english "MC(isv,wcs_offset,a_offset,Label)"      " A-Offset  "
::msgcat::mcset pb_msg_english "MC(isv,wcs_offset,b_offset,Label)"      " B-Offset  "
::msgcat::mcset pb_msg_english "MC(isv,wcs_offset,c_offset,Label)"      " C-Offset  "
::msgcat::mcset pb_msg_english "MC(isv,wcs_offset,wcs_num,Label)"       "Coordinate System"
::msgcat::mcset pb_msg_english "MC(isv,wcs_offset,wcs_num,Context)"     "Specify the fixture offset number that need be added"
::msgcat::mcset pb_msg_english "MC(isv,wcs_offset,wcs_add,Label)"       "Add"
::msgcat::mcset pb_msg_english "MC(isv,wcs_offset,wcs_add,Context)"     "Add new fixture offset coordinate system,specify its postion"
::msgcat::mcset pb_msg_english "MC(isv,wcs_offset,wcs_err,Msg)"         "This coordinate system number has existed already!"
::msgcat::mcset pb_msg_english "MC(isv,tool_info,frame,Label)"          "Tool Info"
::msgcat::mcset pb_msg_english "MC(isv,tool_info,tool_entry,Label)"     "Enter a new tool name"
::msgcat::mcset pb_msg_english "MC(isv,tool_info,tool_name,Label)"      "       Name       "

::msgcat::mcset pb_msg_english "MC(isv,tool_info,tool_num,Label)"       " Tool "
::msgcat::mcset pb_msg_english "MC(isv,tool_info,add_tool,Label)"       "Add"
::msgcat::mcset pb_msg_english "MC(isv,tool_info,tool_diameter,Label)"  " Diameter "
::msgcat::mcset pb_msg_english "MC(isv,tool_info,offset_usder,Label)"   "   Tip Offsets   "
::msgcat::mcset pb_msg_english "MC(isv,tool_info,carrier_id,Label)"     " Carrier ID "
::msgcat::mcset pb_msg_english "MC(isv,tool_info,pocket_id,Label)"      " Pocket ID "
::msgcat::mcset pb_msg_english "MC(isv,tool_info,cutcom_reg,Label)"     "     CUTCOM     "
::msgcat::mcset pb_msg_english "MC(isv,tool_info,cutreg,Label)"         "Register "
::msgcat::mcset pb_msg_english "MC(isv,tool_info,cutval,Label)"         "Offset "
::msgcat::mcset pb_msg_english "MC(isv,tool_info,adjust_reg,Label)"     " Length Adjust "
::msgcat::mcset pb_msg_english "MC(isv,tool_info,tool_type,Label)"      "   Type   "
::msgcat::mcset pb_msg_english "MC(isv,prog,setup,Label)"               "Default Program Definition"
::msgcat::mcset pb_msg_english "MC(isv,prog,setup_right,Label)"         "Program Definition"
::msgcat::mcset pb_msg_english "MC(isv,output,setup_data,Label)"        "Specify Program Definition File"
::msgcat::mcset pb_msg_english "MC(isv,input,setup_data,Label)"         "Select Program Definition File"

::msgcat::mcset pb_msg_english "MC(isv,tool_info,toolnum,Label)"        "Tool Number  "
::msgcat::mcset pb_msg_english "MC(isv,tool_info,toolnum,Context)"      "Specify the tool number that need be added"
::msgcat::mcset pb_msg_english "MC(isv,tool_info,add_tool,Context)"     "Add new tool,specify its parameters"
::msgcat::mcset pb_msg_english "MC(isv,tool_info,add_err,Msg)"          "This tool number has existed already!"
::msgcat::mcset pb_msg_english "MC(isv,tool_info,name_err,Msg)"         "Tool name can not be empty!"

###########################
# Special G code Definition
###########################

::msgcat::mcset pb_msg_english "MC(isv,g_code,frame,Label)"             "Special G Code"
::msgcat::mcset pb_msg_english "MC(isv,g_code,frame,Context)"           "Specify special G codes used in simulation"
::msgcat::mcset pb_msg_english "MC(isv,g_code,from_home,Label)"         "From Home"
::msgcat::mcset pb_msg_english "MC(isv,g_code,return_home,Label)"       "Return Home Pn"
::msgcat::mcset pb_msg_english "MC(isv,g_code,mach_wcs,Label)"          "Machine Datum Move"
::msgcat::mcset pb_msg_english "MC(isv,g_code,set_local,Label)"         "Set Local Coordinate"

###########################
# Special NC Custom Command
###########################

::msgcat::mcset pb_msg_english "MC(isv,spec_command,frame,Label)"       "Special NC Commands"
::msgcat::mcset pb_msg_english "MC(isv,spec_command,frame,Context)"     "NC commands specified for special devices"


::msgcat::mcset pb_msg_english "MC(isv,spec_pre,frame,Label)"           "Preprocess Commands"
::msgcat::mcset pb_msg_english "MC(isv,spec_pre,frame,Context)"         "Command list includes all the tokens or symbols that need to be processed before a block is subject to the parsing for coordinates"

::msgcat::mcset pb_msg_english "MC(isv,spec_command,add,Label)"         "Add"
::msgcat::mcset pb_msg_english "MC(isv,spec_command,edit,Label)"        "Edit"
::msgcat::mcset pb_msg_english "MC(isv,spec_command,delete,Label)"      "Delete"
::msgcat::mcset pb_msg_english "MC(isv,spec_command,title,Label)"       "Special Command for other Devices"
::msgcat::mcset pb_msg_english "MC(isv,spec_command,add_sim,Label)"     "Add SIM Command @Cursor"
::msgcat::mcset pb_msg_english "MC(isv,spec_command,init_sim,Label)"    "Please Select one Command"

::msgcat::mcset pb_msg_english "MC(isv,spec_command,preleader,Label)"   "Leader"
::msgcat::mcset pb_msg_english "MC(isv,spec_command,preleader,Context)" "Specify Leader for usr defined preprocessed command."

::msgcat::mcset pb_msg_english "MC(isv,spec_command,precode,Label)"     "Code"
::msgcat::mcset pb_msg_english "MC(isv,spec_command,precode,Context)"   "Specify Leader for usr defined preprocessed command."

::msgcat::mcset pb_msg_english "MC(isv,spec_command,leader,Label)"      "Leader"
::msgcat::mcset pb_msg_english "MC(isv,spec_command,leader,Context)"    "Specify Leader for usr defined command."

::msgcat::mcset pb_msg_english "MC(isv,spec_command,code,Label)"        "Code"
::msgcat::mcset pb_msg_english "MC(isv,spec_command,code,Context)"      "Specify Leader for usr defined command."

::msgcat::mcset pb_msg_english "MC(isv,spec_command,add,Context)"       "Add new user define command"
::msgcat::mcset pb_msg_english "MC(isv,spec_command,add_err,Msg)"       "This token has been handled already!"
::msgcat::mcset pb_msg_english "MC(isv,spec_command,sel_err,Msg)"       "Please choose a command"
::msgcat::mcset pb_msg_english "MC(isv,export,error,title)"             "Warning"

::msgcat::mcset pb_msg_english "MC(isv,tool_table,title,Label)"         "Tool Table"
::msgcat::mcset pb_msg_english "MC(isv,ex_editor,warning,Msg)"          "This is a system generated VNC command. Changes will not be saved."


# - Languages
#
::msgcat::mcset pb_msg_english "MC(language,Label)"                     "Language"
::msgcat::mcset pb_msg_english "MC(pb_msg_english)"                     "English"
::msgcat::mcset pb_msg_english "MC(pb_msg_french)"                      "French"
::msgcat::mcset pb_msg_english "MC(pb_msg_german)"                      "German"
::msgcat::mcset pb_msg_english "MC(pb_msg_italian)"                     "Italian"
::msgcat::mcset pb_msg_english "MC(pb_msg_japanese)"                    "Japanese"
::msgcat::mcset pb_msg_english "MC(pb_msg_korean)"                      "Korean"
::msgcat::mcset pb_msg_english "MC(pb_msg_russian)"                     "Russian"
::msgcat::mcset pb_msg_english "MC(pb_msg_simple_chinese)"              "Simple Chinese"
::msgcat::mcset pb_msg_english "MC(pb_msg_spanish)"                     "Spanish"
::msgcat::mcset pb_msg_english "MC(pb_msg_traditional_chinese)"         "Traditional Chinese"

### Exit Options Dialog
::msgcat::mcset pb_msg_english "MC(exit,options,Label)"                 "Exit Options"
::msgcat::mcset pb_msg_english "MC(exit,options,SaveAll,Label)"         "Exit with Saving All"
::msgcat::mcset pb_msg_english "MC(exit,options,SaveNone,Label)"        "Exit without Saving"
::msgcat::mcset pb_msg_english "MC(exit,options,SaveSelect,Label)"      "Exit with Saving Selected"

### OptionMenu Items
::msgcat::mcset pb_msg_english "MC(optionMenu,item,Other)"       "Other"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,None)"        "None"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,RT_R)"        "Rapid Traverse & R"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,Rapid)"       "Rapid"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,RS)"          "Rapid Spindle"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,C_off_RS)"    "Cycle Off then Rapid Spindle"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,IPM)"         "IPM"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,FRN)"         "FRN"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,IPR)"         "IPR"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,Auto)"        "Auto"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,DPM)"         "DPM"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,Abs_Inc)"     "Absolute/Incremental"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,Abs_Only)"    "Absolute Only"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,Inc_Only)"    "Incremental Only"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,SD)"          "Shortest Distance"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,AP)"          "Always Positive"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,AN)"          "Always Negative"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,Z_Axis)"      "Z Axis"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,+X_Axis)"     "+X Axis"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,-X_Axis)"     "-X Axis"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,Y_Axis)"      "Y Axis"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,MDD)"         "Magnitude Determines Direction"
::msgcat::mcset pb_msg_english "MC(optionMenu,item,SDD)"         "Sign Determines Direction"

