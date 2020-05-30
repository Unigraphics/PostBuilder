##############################################################################
#                       U I _ P B _ L A N G U A G E . T C L
##############################################################################
# Description                                                                #
#    This file defines labels, strings and messages used in UG/Post Builder. #
#                                                                            #
##############################################################################

##############################################################################
# Environment variable that will be used to determine the locale for
# the native language translation. It's default to C (ANSI), if not set.
##############################################################################

if ![info exists gPB(LANG)] {
   return
}


# Load message file of current locale
msgcat::mclocale $gPB(LANG)
msgcat::mcload $env(PB_HOME)/msgs



#=============================================================================
# pb11.01

# Fall back to English when translation is not yet provided (variable name is returned).
set gPB(event,combo,tcl_line,Label)               [::msgcat::mc MC(event,combo,tcl_line,Label)]
if [string match "MC(event,combo,tcl_line,Label)" $gPB(event,combo,tcl_line,Label)] {
   set gPB(event,combo,tcl_line,Label)            "Tcl Comment"
}
set gPB(event,elem,indent,popup,Label)            "Indent This Line in Tcl"
set gPB(event,elem,indent,dialog,title)           "Indentation"
set gPB(event,elem,indent,dialog,blanks)          "Blanks"


#=============================================================================
# pb10.03
#=============================================================================
set gPB(msg,filename_with_spec_char)              [::msgcat::mc MC(msg,filename_with_spec_char)]
set gPB(msg,not_post_comp_file)                   [::msgcat::mc MC(msg,not_post_comp_file)]
set gPB(listing,output,warning,warn_file)         [::msgcat::mc MC(listing,output,warning,warn_file)]
set gPB(listing,output,warning,nc_output)         [::msgcat::mc MC(listing,output,warning,nc_output)]


#=============================================================================
# pb10.02
#=============================================================================
set gPB(machine,resolution,check,Label)           [::msgcat::mc MC(machine,resolution,check,Label)]
set gPB(main,options,debug,Label)                 [::msgcat::mc MC(main,options,debug,Label)]
set gPB(encrypt,suppress,Label)                   [::msgcat::mc MC(encrypt,suppress,Label)]
set gPB(main,title,license_control)               [::msgcat::mc MC(main,title,license_control)]


#=============================================================================
# pb902
#=============================================================================
set gPB(other,ude_include_def,Label)              [::msgcat::mc MC(other,ude_include_def,Label)]
#-----------------------------------------------------------------------------
# Labels for new tapping cycles
#-----------------------------------------------------------------------------
set gPB(event,cycle,tap_deep,name)                [::msgcat::mc MC(event,cycle,tap_deep,name)]
set gPB(event,cycle,tap_break_chip,name)          [::msgcat::mc MC(event,cycle,tap_break_chip,name)]
set gPB(g_code,tap_float,name)                    [::msgcat::mc MC(g_code,tap_float,name)]
set gPB(g_code,tap_deep,name)                     [::msgcat::mc MC(g_code,tap_deep,name)]
set gPB(g_code,tap_break_chip,name)               [::msgcat::mc MC(g_code,tap_break_chip,name)]
#-----------------------------------------------------------------------------
# Defined strings that did not make it to the local language files.
# - These strings should be included for translation in the later release.
#-----------------------------------------------------------------------------
set gPB(event,cycle,plane_change,axis,label)      [::msgcat::mc MC(event,cycle,plane_change,axis,label)]
set gPB(event,feedrates,mode,rapid)               [::msgcat::mc MC(event,feedrates,mode,rapid)]
set gPB(event,feedrates,mode,cutting)             [::msgcat::mc MC(event,feedrates,mode,cutting)]


#=============================================================================
# pb800
#=============================================================================
set gPB(event,misc,subop_start,name)              [::msgcat::mc MC(event,misc,subop_start,name)]
set gPB(event,misc,subop_end,name)                [::msgcat::mc MC(event,misc,subop_end,name)]
set gPB(event,misc,contour_start,name)            [::msgcat::mc MC(event,misc,contour_start,name)]
set gPB(event,misc,contour_end,name)              [::msgcat::mc MC(event,misc,contour_end,name)]
set gPB(prog,tree,misc,Label)                     [::msgcat::mc MC(prog,tree,misc,Label)]
set gPB(event,cycle,lathe_rough,name)             [::msgcat::mc MC(event,cycle,lathe_rough,name)]
set gPB(main,file,properties,Label)               [::msgcat::mc MC(main,file,properties,Label)]

set gPB(ude,editor,popup,MSG_CATEGORY)            [::msgcat::mc MC(ude,editor,popup,MSG_CATEGORY)]

set gPB(event,cycle,plane_change,label)           [::msgcat::mc MC(event,cycle,plane_change,label)]
set gPB(format,check_1,error,msg)                 [::msgcat::mc MC(format,check_1,error,msg)]

set gPB(format,check_4,error,msg)                 [::msgcat::mc MC(format,check_4,error,msg)]
set gPB(format,check_5,error,msg)                 [::msgcat::mc MC(format,check_5,error,msg)]
set gPB(format,check_6,error,msg)                 [::msgcat::mc MC(format,check_6,error,msg)]

set gPB(msg,old_block,maximum_length)             [::msgcat::mc MC(msg,old_block,maximum_length)]
set gPB(msg,old_address,maximum_length)           [::msgcat::mc MC(msg,old_address,maximum_length)]
set gPB(msg,block_address,check,title)            [::msgcat::mc MC(msg,block_address,check,title)]
set gPB(msg,block_address,maximum_length)         [::msgcat::mc MC(msg,block_address,maximum_length)]

set gPB(address,maximum_name_msg)                 [::msgcat::mc MC(address,maximum_name_msg)]

set gPB(ude,import,oth_list,Label)                [::msgcat::mc MC(ude,import,oth_list,Label)]
set gPB(ude,import,oth_list,Context)              [::msgcat::mc MC(ude,import,oth_list,Context)]
set gPB(ude,import,ihr_list,Label)                [::msgcat::mc MC(ude,import,ihr_list,Label)]
set gPB(ude,import,ihr_list,Context)              [::msgcat::mc MC(ude,import,ihr_list,Context)]
set gPB(ude,import,up,Label)                      [::msgcat::mc MC(ude,import,up,Label)]
set gPB(ude,import,down,Label)                    [::msgcat::mc MC(ude,import,down,Label)]
set gPB(msg,exist_cdl_file)                       [::msgcat::mc MC(msg,exist_cdl_file)]

set gPB(listing,link_var,check,Label)             [::msgcat::mc MC(listing,link_var,check,Label)]
set gPB(listing,link_var,check,Context)           [::msgcat::mc MC(listing,link_var,check,Context)]

set gPB(msg,check_resolution,title)               [::msgcat::mc MC(msg,check_resolution,title)]
set gPB(msg,check_resolution,linear)              [::msgcat::mc MC(msg,check_resolution,linear)]
set gPB(msg,check_resolution,rotary)              [::msgcat::mc MC(msg,check_resolution,rotary)]

set gPB(cmd,export,desc,label)                    [::msgcat::mc MC(cmd,export,desc,label)]
set gPB(cmd,desc_dlg,title)                       [::msgcat::mc MC(cmd,desc_dlg,title)]
set gPB(block,delete_row,Label)                   [::msgcat::mc MC(block,delete_row,Label)]
set gPB(block,exec_cond,set,Label)                [::msgcat::mc MC(block,exec_cond,set,Label)]
set gPB(block,exec_cond,new,Label)                [::msgcat::mc MC(block,exec_cond,new,Label)]
set gPB(block,exec_cond,edit,Label)               [::msgcat::mc MC(block,exec_cond,edit,Label)]
set gPB(block,exec_cond,remove,Label)             [::msgcat::mc MC(block,exec_cond,remove,Label)]

set gPB(cust_cmd,name_msg_for_cond)               [::msgcat::mc MC(cust_cmd,name_msg_for_cond)]

set gPB(machine,linearization,Label)              [::msgcat::mc MC(machine,linearization,Label)]
set gPB(machine,linearization,angle,Label)        [::msgcat::mc MC(machine,linearization,angle,Label)]
set gPB(machine,linearization,angle,Context)      [::msgcat::mc MC(machine,linearization,angle,Context)]
set gPB(machine,linearization,axis,Label)         [::msgcat::mc MC(machine,linearization,axis,Label)]
set gPB(machine,linearization,axis,Context)       [::msgcat::mc MC(machine,linearization,axis,Context)]
set gPB(machine,resolution,continue,Label)        [::msgcat::mc MC(machine,resolution,continue,Label)]
set gPB(machine,resolution,abort,Label)           [::msgcat::mc MC(machine,resolution,abort,Label)]

set gPB(machine,axis,def_lintol,Label)            [::msgcat::mc MC(machine,axis,def_lintol,Label)]
set gPB(machine,axis,def_lintol,Context)          [::msgcat::mc MC(machine,axis,def_lintol,Context)]
set gPB(sub_post,inch,Lable)                      [::msgcat::mc MC(sub_post,inch,Lable)]
set gPB(sub_post,metric,Lable)                    [::msgcat::mc MC(sub_post,metric,Lable)]
set gPB(new_sub,title,Label)                      [::msgcat::mc MC(new_sub,title,Label)]
set gPB(new,sub_post,toggle,label)                [::msgcat::mc MC(new,sub_post,toggle,label)]
set gPB(new,sub_post,toggle,tmp_label)            [::msgcat::mc MC(new,sub_post,toggle,tmp_label)]
set gPB(new,unit_post,filename,msg)               [::msgcat::mc MC(new,unit_post,filename,msg)]
set gPB(new,alter_unit,toggle,label)              [::msgcat::mc MC(new,alter_unit,toggle,label)]
set gPB(new,main_post,label)                      [::msgcat::mc MC(new,main_post,label)]
set gPB(new,main_post,warning_1,msg)              [::msgcat::mc MC(new,main_post,warning_1,msg)]
set gPB(new,main_post,warning_2,msg)              [::msgcat::mc MC(new,main_post,warning_2,msg)]
set gPB(new,main_post,specify_err,msg)            [::msgcat::mc MC(new,main_post,specify_err,msg)]
set gPB(machine,gen,alter_unit,Label)             [::msgcat::mc MC(machine,gen,alter_unit,Label)]
set gPB(unit_related_param,tab,Label)             [::msgcat::mc MC(unit_related_param,tab,Label)]
set gPB(unit_related_param,feed_rate,Label)       [::msgcat::mc MC(unit_related_param,feed_rate,Label)]
set gPB(listing,alt_unit,frame,Label)             [::msgcat::mc MC(listing,alt_unit,frame,Label)]
set gPB(listing,alt_unit,default,Label)           [::msgcat::mc MC(listing,alt_unit,default,Label)]
set gPB(listing,alt_unit,default,Context)         [::msgcat::mc MC(listing,alt_unit,default,Context)]
set gPB(listing,alt_unit,specify,Label)           [::msgcat::mc MC(listing,alt_unit,specify,Label)]
set gPB(listing,alt_unit,specify,Context)         [::msgcat::mc MC(listing,alt_unit,specify,Context)]
set gPB(listing,alt_unit,select_name,Label)       [::msgcat::mc MC(listing,alt_unit,select_name,Label)]
set gPB(listing,alt_unit,warning_1,msg)           [::msgcat::mc MC(listing,alt_unit,warning_1,msg)]
set gPB(listing,alt_unit,warning_2,msg)           [::msgcat::mc MC(listing,alt_unit,warning_2,msg)]

set gPB(listing,alt_unit,post_name,Label)         [::msgcat::mc MC(listing,alt_unit,post_name,Label)]
set gPB(listing,alt_unit,post_name,Context)       [::msgcat::mc MC(listing,alt_unit,post_name,Context)]


#=============================================================================
# pb750
#=============================================================================
set gPB(machine,axis,violation,user,evt_title)    [::msgcat::mc MC(machine,axis,violation,user,evt_title)]
set gPB(event,helix,name)                         [::msgcat::mc MC(event,helix,name)]
set gPB(event,circular,ijk_param,prefix,msg)      [::msgcat::mc MC(event,circular,ijk_param,prefix,msg)]
set gPB(event,circular,ijk_param,postfix,msg)     [::msgcat::mc MC(event,circular,ijk_param,postfix,msg)]
set gPB(isv,spec_codelist,default,msg)            [::msgcat::mc MC(isv,spec_codelist,default,msg)]
set gPB(isv,spec_codelist,restore,msg)            [::msgcat::mc MC(isv,spec_codelist,restore,msg)]
set gPB(msg,block_format_command,paste_err)       [::msgcat::mc MC(msg,block_format_command,paste_err)]
set gPB(main,file,open,choose_cntl_type)          [::msgcat::mc MC(main,file,open,choose_cntl_type)]
set gPB(cust_cmd,import,no_vnc_cmd,msg)           [::msgcat::mc MC(cust_cmd,import,no_vnc_cmd,msg)]
set gPB(cust_cmd,import,no_cmd,msg)               [::msgcat::mc MC(cust_cmd,import,no_cmd,msg)]
set gPB(isv,tool_info,name_same_err,Msg)          [::msgcat::mc MC(isv,tool_info,name_same_err,Msg)]
set gPB(msg,limit_to_change_license)              [::msgcat::mc MC(msg,limit_to_change_license)]
set gPB(output,other_opts,validation,msg)         [::msgcat::mc MC(output,other_opts,validation,msg)]
set gPB(machine,empty_entry_err,msg)              [::msgcat::mc MC(machine,empty_entry_err,msg)]
set gPB(msg,control_v_limit)                      [::msgcat::mc MC(msg,control_v_limit)]
set gPB(block,capital_name_msg)                   [::msgcat::mc MC(block,capital_name_msg)]
set gPB(machine,axis,violation,user,Label)        [::msgcat::mc MC(machine,axis,violation,user,Label)]
set gPB(machine,axis,violation,user,Handler)      [::msgcat::mc MC(machine,axis,violation,user,Handler)]
set gPB(new,user,file,NOT_EXIST)                  [::msgcat::mc MC(new,user,file,NOT_EXIST)]
set gPB(new,include_vnc,Label)                    [::msgcat::mc MC(new,include_vnc,Label)]
set gPB(other,opt_equal,Label)                    [::msgcat::mc MC(other,opt_equal,Label)]
set gPB(event,nurbs,name)                         [::msgcat::mc MC(event,nurbs,name)]
set gPB(event,cycle,tap_float,name)               [::msgcat::mc MC(event,cycle,tap_float,name)]
set gPB(event,cycle,thread,name)                  [::msgcat::mc MC(event,cycle,thread,name)]
set gPB(ude,editor,group,MSG_NESTED_GROUP)        [::msgcat::mc MC(ude,editor,group,MSG_NESTED_GROUP)]
set gPB(ude,editor,bmp,Label)                     [::msgcat::mc MC(ude,editor,bmp,Label)]
set gPB(ude,editor,bmp,Context)                   [::msgcat::mc MC(ude,editor,bmp,Context)]
set gPB(ude,editor,group,Label)                   [::msgcat::mc MC(ude,editor,group,Label)]
set gPB(ude,editor,group,Context)                 [::msgcat::mc MC(ude,editor,group,Context)]
set gPB(ude,editor,eventdlg,DESC,Label)           [::msgcat::mc MC(ude,editor,eventdlg,DESC,Label)]
set gPB(ude,editor,eventdlg,DESC,Context)         [::msgcat::mc MC(ude,editor,eventdlg,DESC,Context)]
set gPB(ude,editor,eventdlg,URL,Label)            [::msgcat::mc MC(ude,editor,eventdlg,URL,Label)]
set gPB(ude,editor,eventdlg,URL,Context)          [::msgcat::mc MC(ude,editor,eventdlg,URL,Context)]
set gPB(ude,editor,param,MSG_WRONG_IMAGE_FILE)    [::msgcat::mc MC(ude,editor,param,MSG_WRONG_IMAGE_FILE)]
set gPB(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)  [::msgcat::mc MC(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)]
set gPB(ude,editor,param,MSG_WRONG_VAR_NAME)      [::msgcat::mc MC(ude,editor,param,MSG_WRONG_VAR_NAME)]
set gPB(ude,editor,param,MSG_WRONG_KEYWORD)       [::msgcat::mc MC(ude,editor,param,MSG_WRONG_KEYWORD)]
set gPB(ude,editor,status_label)                  [::msgcat::mc MC(ude,editor,status_label)]
set gPB(ude,editor,vector,Label)                  [::msgcat::mc MC(ude,editor,vector,Label)]
set gPB(ude,editor,vector,Context)                [::msgcat::mc MC(ude,editor,vector,Context)]
set gPB(ude,editor,popup,MSG_URL_FORMAT)          [::msgcat::mc MC(ude,editor,popup,MSG_URL_FORMAT)]
set gPB(ude,editor,popup,MSG_BLANK_HELP_INFO)     [::msgcat::mc MC(ude,editor,popup,MSG_BLANK_HELP_INFO)]
set gPB(new,MSG_NO_AXIS)                          [::msgcat::mc MC(new,MSG_NO_AXIS)]
set gPB(machine,info,controller_type,Label)       [::msgcat::mc MC(machine,info,controller_type,Label)]
set gPB(block,func_combo,Label)                   [::msgcat::mc MC(block,func_combo,Label)]
set gPB(block,prefix_popup,add,Label)             [::msgcat::mc MC(block,prefix_popup,add,Label)]
set gPB(block,prefix_popup,edit,Label)            [::msgcat::mc MC(block,prefix_popup,edit,Label)]
set gPB(block,prefix,Label)                       [::msgcat::mc MC(block,prefix,Label)]
set gPB(block,suppress_popup,Label)               [::msgcat::mc MC(block,suppress_popup,Label)]
set gPB(block,custom_func,Label)                  [::msgcat::mc MC(block,custom_func,Label)]
set gPB(seq,combo,macro,Label)                    [::msgcat::mc MC(seq,combo,macro,Label)]
set gPB(func,tab,Label)                           [::msgcat::mc MC(func,tab,Label)]
set gPB(func,exp,msg)                             [::msgcat::mc MC(func,exp,msg)]
set gPB(func,edit,name,Label)                     [::msgcat::mc MC(func,edit,name,Label)]
set gPB(func,disp_name,Label)                     [::msgcat::mc MC(func,disp_name,Label)]
set gPB(func,param_list,Label)                    [::msgcat::mc MC(func,param_list,Label)]
set gPB(func,separator,Label)                     [::msgcat::mc MC(func,separator,Label)]
set gPB(func,start,Label)                         [::msgcat::mc MC(func,start,Label)]
set gPB(func,end,Label)                           [::msgcat::mc MC(func,end,Label)]
set gPB(func,output,name,Label)                   [::msgcat::mc MC(func,output,name,Label)]
set gPB(func,output,check,Label)                  [::msgcat::mc MC(func,output,check,Label)]
set gPB(func,output,link,Label)                   [::msgcat::mc MC(func,output,link,Label)]
set gPB(func,col_param,Label)                     [::msgcat::mc MC(func,col_param,Label)]
set gPB(func,col_exp,Label)                       [::msgcat::mc MC(func,col_exp,Label)]
set gPB(func,popup,insert,Label)                  [::msgcat::mc MC(func,popup,insert,Label)]
set gPB(func,name,err_msg)                        [::msgcat::mc MC(func,name,err_msg)]
set gPB(func,name,blank_err)                      [::msgcat::mc MC(func,name,blank_err)]
set gPB(func,name,contain_err)                    [::msgcat::mc MC(func,name,contain_err)]
set gPB(func,tree_node,start_err)                 [::msgcat::mc MC(func,tree_node,start_err)]
set gPB(func,tree_node,contain_err)               [::msgcat::mc MC(func,tree_node,contain_err)]
set gPB(func,help,Label)                          [::msgcat::mc MC(func,help,Label)]
set gPB(func,help,Context)                        [::msgcat::mc MC(func,help,Context)]
set gPB(func,help,MSG_NO_INFO)                    [::msgcat::mc MC(func,help,MSG_NO_INFO)]


##############################################################################
#               Strings, labels and messages definition
##############################################################################

set gPB(machine,gen,out_unit,inch,Label)        [::msgcat::mc MC(machine,gen,out_unit,inch,Label)]
set gPB(machine,gen,out_unit,metric,Label)      [::msgcat::mc MC(machine,gen,out_unit,metric,Label)]
set gPB(g_code,feedmode,dpm)                    [::msgcat::mc MC(g_code,feedmode,dpm)]
set gPB(ude,editor,enable,as_saved,Label)       [::msgcat::mc MC(ude,editor,enable,as_saved,Label)]

##------
## Title
##
set gPB(main,title,Unigraphics)                 [::msgcat::mc MC(main,title,Unigraphics)]
set gPB(main,title,UG)                          [::msgcat::mc MC(main,title,UG)]
set gPB(main,title,Post_Builder)                [::msgcat::mc MC(main,title,Post_Builder)]
set gPB(main,title,Version)                     [::msgcat::mc MC(main,title,Version)]
set gPB(main,default,Status)                    [::msgcat::mc MC(main,default,Status)]
set gPB(main,save,Status)                       [::msgcat::mc MC(main,save,Status)]

##------
## File
##
set gPB(main,file,Label)                        [::msgcat::mc MC(main,file,Label)]

set gPB(main,file,Balloon)                      [::msgcat::mc MC(main,file,Balloon)]

set gPB(main,file,Context)                      [::msgcat::mc MC(main,file,Context)]
set gPB(main,file,menu,Context)                 [::msgcat::mc MC(main,file,menu,Context)]

set gPB(main,file,new,Label)                    [::msgcat::mc MC(main,file,new,Label)]
set gPB(main,file,new,Balloon)                  [::msgcat::mc MC(main,file,new,Balloon)]
set gPB(main,file,new,Context)                  [::msgcat::mc MC(main,file,new,Context)]
set gPB(main,file,new,Busy)                     [::msgcat::mc MC(main,file,new,Busy)]

set gPB(main,file,open,Label)                   [::msgcat::mc MC(main,file,open,Label)]
set gPB(main,file,open,Balloon)                 [::msgcat::mc MC(main,file,open,Balloon)]
set gPB(main,file,open,Context)                 [::msgcat::mc MC(main,file,open,Context)]
set gPB(main,file,open,Busy)                    [::msgcat::mc MC(main,file,open,Busy)]

set gPB(main,file,mdfa,Label)                   [::msgcat::mc MC(main,file,mdfa,Label)]
set gPB(main,file,mdfa,Balloon)                 [::msgcat::mc MC(main,file,mdfa,Balloon)]
set gPB(main,file,mdfa,Context)                 [::msgcat::mc MC(main,file,mdfa,Context)]

set gPB(main,file,save,Label)                   [::msgcat::mc MC(main,file,save,Label)]
set gPB(main,file,save,Balloon)                 [::msgcat::mc MC(main,file,save,Balloon)]
set gPB(main,file,save,Context)                 [::msgcat::mc MC(main,file,save,Context)]
set gPB(main,file,save,Busy)                    [::msgcat::mc MC(main,file,save,Busy)]

set gPB(main,file,save_as,Label)                [::msgcat::mc MC(main,file,save_as,Label)]
set gPB(main,file,save_as,Balloon)              [::msgcat::mc MC(main,file,save_as,Balloon)]
set gPB(main,file,save_as,Context)              [::msgcat::mc MC(main,file,save_as,Context)]

set gPB(main,file,close,Label)                  [::msgcat::mc MC(main,file,close,Label)]
set gPB(main,file,close,Balloon)                [::msgcat::mc MC(main,file,close,Balloon)]
set gPB(main,file,close,Context)                [::msgcat::mc MC(main,file,close,Context)]

set gPB(main,file,exit,Label)                   [::msgcat::mc MC(main,file,exit,Label)]
set gPB(main,file,exit,Balloon)                 [::msgcat::mc MC(main,file,exit,Balloon)]
set gPB(main,file,exit,Context)                 [::msgcat::mc MC(main,file,exit,Context)]

set gPB(main,file,history,Label)                [::msgcat::mc MC(main,file,history,Label)]
set gPB(main,file,history,Balloon)              [::msgcat::mc MC(main,file,history,Balloon)]
set gPB(main,file,history,Context)              [::msgcat::mc MC(main,file,history,Context)]

##---------
## Options
##
set gPB(main,options,Label)                     [::msgcat::mc MC(main,options,Label)]
set gPB(main,options,Balloon)                   [::msgcat::mc MC(main,options,Balloon)]
set gPB(main,options,Context)                   [::msgcat::mc MC(main,options,Context)]
set gPB(main,options,menu,Context)              [::msgcat::mc MC(main,options,menu,Context)]

set gPB(main,windows,Label)                     [::msgcat::mc MC(main,windows,Label)]
set gPB(main,windows,Balloon)                   [::msgcat::mc MC(main,windows,Balloon)]
set gPB(main,windows,Context)                   [::msgcat::mc MC(main,windows,Context)]
set gPB(main,windows,menu,Context)              [::msgcat::mc MC(main,windows,menu,Context)]

set gPB(main,options,properties,Label)          [::msgcat::mc MC(main,options,properties,Label)]
set gPB(main,options,properties,Balloon)        [::msgcat::mc MC(main,options,properties,Balloon)]
set gPB(main,options,properties,Context)        [::msgcat::mc MC(main,options,properties,Context)]

set gPB(main,options,advisor,Label)             [::msgcat::mc MC(main,options,advisor,Label)]
set gPB(main,options,advisor,Balloon)           [::msgcat::mc MC(main,options,advisor,Balloon)]
set gPB(main,options,advisor,Context)           [::msgcat::mc MC(main,options,advisor,Context)]

set gPB(main,options,cmd_check,Label)           [::msgcat::mc MC(main,options,cmd_check,Label)]
set gPB(main,options,cmd_check,Balloon)         [::msgcat::mc MC(main,options,cmd_check,Balloon)]
set gPB(main,options,cmd_check,Context)         [::msgcat::mc MC(main,options,cmd_check,Context)]

set gPB(main,options,cmd_check,syntax,Label)    [::msgcat::mc MC(main,options,cmd_check,syntax,Label)]
set gPB(main,options,cmd_check,command,Label)   [::msgcat::mc MC(main,options,cmd_check,command,Label)]
set gPB(main,options,cmd_check,block,Label)     [::msgcat::mc MC(main,options,cmd_check,block,Label)]
set gPB(main,options,cmd_check,address,Label)   [::msgcat::mc MC(main,options,cmd_check,address,Label)]
set gPB(main,options,cmd_check,format,Label)    [::msgcat::mc MC(main,options,cmd_check,format,Label)]

set gPB(main,options,backup,Label)              [::msgcat::mc MC(main,options,backup,Label)]
set gPB(main,options,backup,Balloon)            [::msgcat::mc MC(main,options,backup,Balloon)]
set gPB(main,options,backup,Context)            [::msgcat::mc MC(main,options,backup,Context)]

set gPB(main,options,backup,one,Label)          [::msgcat::mc MC(main,options,backup,one,Label)]
set gPB(main,options,backup,all,Label)          [::msgcat::mc MC(main,options,backup,all,Label)]
set gPB(main,options,backup,none,Label)         [::msgcat::mc MC(main,options,backup,none,Label)]

##-----------
## Utilities
##
set gPB(main,utils,Label)                       [::msgcat::mc MC(main,utils,Label)]
set gPB(main,utils,Balloon)                     [::msgcat::mc MC(main,utils,Balloon)]
set gPB(main,utils,Context)                     [::msgcat::mc MC(main,utils,Context)]
set gPB(main,utils,menu,Context)                [::msgcat::mc MC(main,utils,menu,Context)]
set gPB(main,utils,etpdf,Label)                 [::msgcat::mc MC(main,utils,etpdf,Label)]
set gPB(main,utils,bmv,Label)                   [::msgcat::mc MC(main,utils,bmv,Label)]
set gPB(main,utils,blic,Label)                  [::msgcat::mc MC(main,utils,blic,Label)]

##------
## Help
##
set gPB(main,help,Label)                        [::msgcat::mc MC(main,help,Label)]
set gPB(main,help,Balloon)                      [::msgcat::mc MC(main,help,Balloon)]
set gPB(main,help,Context)                      [::msgcat::mc MC(main,help,Context)]
set gPB(main,help,menu,Context)                 [::msgcat::mc MC(main,help,menu,Context)]

set gPB(main,help,bal,Label)                    [::msgcat::mc MC(main,help,bal,Label)]
set gPB(main,help,bal,Balloon)                  [::msgcat::mc MC(main,help,bal,Balloon)]
set gPB(main,help,bal,Context)                  [::msgcat::mc MC(main,help,bal,Context)]

set gPB(main,help,chelp,Label)                  [::msgcat::mc MC(main,help,chelp,Label)]
set gPB(main,help,chelp,Balloon)                [::msgcat::mc MC(main,help,chelp,Balloon)]
set gPB(main,help,chelp,Context)                [::msgcat::mc MC(main,help,chelp,Context)]

set gPB(main,help,what,Label)                   [::msgcat::mc MC(main,help,what,Label)]
set gPB(main,help,what,Balloon)                 [::msgcat::mc MC(main,help,what,Balloon)]
set gPB(main,help,what,Context)                 [::msgcat::mc MC(main,help,what,Context)]

set gPB(main,help,dialog,Label)                 [::msgcat::mc MC(main,help,dialog,Label)]
set gPB(main,help,dialog,Balloon)               [::msgcat::mc MC(main,help,dialog,Balloon)]
set gPB(main,help,dialog,Context)               [::msgcat::mc MC(main,help,dialog,Context)]

set gPB(main,help,manual,Label)                 [::msgcat::mc MC(main,help,manual,Label)]
set gPB(main,help,manual,Balloon)               [::msgcat::mc MC(main,help,manual,Balloon)]
set gPB(main,help,manual,Context)               [::msgcat::mc MC(main,help,manual,Context)]

set gPB(main,help,about,Label)                  [::msgcat::mc MC(main,help,about,Label)]
set gPB(main,help,about,Balloon)                [::msgcat::mc MC(main,help,about,Balloon)]
set gPB(main,help,about,Context)                [::msgcat::mc MC(main,help,about,Context)]

set gPB(main,help,rel_note,Label)               [::msgcat::mc MC(main,help,rel_note,Label)]
set gPB(main,help,rel_note,Balloon)             [::msgcat::mc MC(main,help,rel_note,Balloon)]
set gPB(main,help,rel_note,Context)             [::msgcat::mc MC(main,help,rel_note,Context)]

set gPB(main,help,tcl_man,Label)                [::msgcat::mc MC(main,help,tcl_man,Label)]
set gPB(main,help,tcl_man,Balloon)              [::msgcat::mc MC(main,help,tcl_man,Balloon)]
set gPB(main,help,tcl_man,Context)              [::msgcat::mc MC(main,help,tcl_man,Context)]

##----------
## Tool Bar
##
set gPB(tool,new,Label)                         [::msgcat::mc MC(tool,new,Label)]
set gPB(tool,new,Context)                       [::msgcat::mc MC(tool,new,Context)]

set gPB(tool,open,Label)                        [::msgcat::mc MC(tool,open,Label)]
set gPB(tool,open,Context)                      [::msgcat::mc MC(tool,open,Context)]

set gPB(tool,save,Label)                        [::msgcat::mc MC(tool,save,Label)]
set gPB(tool,save,Context)                      [::msgcat::mc MC(tool,save,Context)]

set gPB(tool,bal,Label)                         [::msgcat::mc MC(tool,bal,Label)]
set gPB(tool,bal,Context)                       [::msgcat::mc MC(tool,bal,Context)]

set gPB(tool,chelp,Label)                       [::msgcat::mc MC(tool,chelp,Label)]
set gPB(tool,chelp,Context)                     [::msgcat::mc MC(tool,chelp,Context)]

set gPB(tool,what,Label)                        [::msgcat::mc MC(tool,what,Label)]
set gPB(tool,what,Context)                      [::msgcat::mc MC(tool,what,Context)]

set gPB(tool,dialog,Label)                      [::msgcat::mc MC(tool,dialog,Label)]
set gPB(tool,dialog,Context)                    [::msgcat::mc MC(tool,dialog,Context)]

set gPB(tool,manual,Label)                      [::msgcat::mc MC(tool,manual,Label)]
set gPB(tool,manual,Context)                    [::msgcat::mc MC(tool,manual,Context)]


#=============
# Main Window
#=============

##-----------------
## Common Messages
##
set gPB(msg,error,title)                        [::msgcat::mc MC(msg,error,title)]
set gPB(msg,dialog,title)                       [::msgcat::mc MC(msg,dialog,title)]
set gPB(msg,warning)                            [::msgcat::mc MC(msg,warning)]
set gPB(msg,error)                              [::msgcat::mc MC(msg,error)]
set gPB(msg,invalid_data)                       [::msgcat::mc MC(msg,invalid_data)]
set gPB(msg,invalid_browser_cmd)                [::msgcat::mc MC(msg,invalid_browser_cmd)]
set gPB(msg,wrong_filename)                     [::msgcat::mc MC(msg,wrong_filename)]
set gPB(msg,user_ctrl_limit)                    [::msgcat::mc MC(msg,user_ctrl_limit)]
set gPB(msg,import_limit)                       [::msgcat::mc MC(msg,import_limit)]
set gPB(msg,limit_msg)                          [::msgcat::mc MC(msg,limit_msg)]
set gPB(msg,no_file)                            [::msgcat::mc MC(msg,no_file)]
set gPB(msg,no_license)                         [::msgcat::mc MC(msg,no_license)]
set gPB(msg,no_license_title)                   [::msgcat::mc MC(msg,no_license_title)]
set gPB(msg,no_license_dialog)                  [::msgcat::mc MC(msg,no_license_dialog)]

set gPB(msg,pending)                            [::msgcat::mc MC(msg,pending)]
set gPB(msg,save)                               [::msgcat::mc MC(msg,save)]
set gPB(msg,version_check)                      [::msgcat::mc MC(msg,version_check)]

set gPB(msg,file_corruption)                    [::msgcat::mc MC(msg,file_corruption)]
set gPB(msg,bad_tcl_file)                       [::msgcat::mc MC(msg,bad_tcl_file)]
set gPB(msg,bad_def_file)                       [::msgcat::mc MC(msg,bad_def_file)]
set gPB(msg,invalid_post)                       [::msgcat::mc MC(msg,invalid_post)]
set gPB(msg,invalid_dir)                        [::msgcat::mc MC(msg,invalid_dir)]
set gPB(msg,invalid_file)                       [::msgcat::mc MC(msg,invalid_file)]
set gPB(msg,invalid_def_file)                   [::msgcat::mc MC(msg,invalid_def_file)]
set gPB(msg,invalid_tcl_file)                   [::msgcat::mc MC(msg,invalid_tcl_file)]
set gPB(msg,dir_perm)                           [::msgcat::mc MC(msg,dir_perm)]
set gPB(msg,file_perm)                          [::msgcat::mc MC(msg,file_perm)]

set gPB(msg,file_exist)                         [::msgcat::mc MC(msg,file_exist)]
set gPB(msg,file_missing)                       [::msgcat::mc MC(msg,file_missing)]
set gPB(msg,sub_dialog_open)                    [::msgcat::mc MC(msg,sub_dialog_open)]
set gPB(msg,generic)                            [::msgcat::mc MC(msg,generic)]
set gPB(msg,min_word)                           [::msgcat::mc MC(msg,min_word)]
set gPB(msg,name_exists)                        [::msgcat::mc MC(msg,name_exists)]
set gPB(msg,in_use)                             [::msgcat::mc MC(msg,in_use)]
set gPB(msg,do_you_want_to_proceed)             [::msgcat::mc MC(msg,do_you_want_to_proceed)]
set gPB(msg,not_installed_properly)             [::msgcat::mc MC(msg,not_installed_properly)]
set gPB(msg,no_app_to_open)                     [::msgcat::mc MC(msg,no_app_to_open)]
set gPB(msg,save_change)                        [::msgcat::mc MC(msg,save_change)]
set gPB(msg,external_editor)                    [::msgcat::mc MC(msg,external_editor)]
set gPB(msg,set_ext_editor)                     [::msgcat::mc MC(msg,set_ext_editor)]

set gPB(msg,filename_with_space)                [::msgcat::mc MC(msg,filename_with_space)]
set gPB(msg,filename_protection)                [::msgcat::mc MC(msg,filename_protection)]


##--------------------
## Common Function
##
set gPB(msg,parent_win)                         [::msgcat::mc MC(msg,parent_win)]
set gPB(msg,close_subwin)                       [::msgcat::mc MC(msg,close_subwin)]
set gPB(msg,block_exist)                        [::msgcat::mc MC(msg,block_exist)]
set gPB(msg,num_gcode_1)                        [::msgcat::mc MC(msg,num_gcode_1)]
set gPB(msg,num_gcode_2)                        [::msgcat::mc MC(msg,num_gcode_2)]
set gPB(msg,num_mcode_1)                        [::msgcat::mc MC(msg,num_mcode_1)]
set gPB(msg,num_mcode_2)                        [::msgcat::mc MC(msg,num_mcode_2)]
set gPB(msg,empty_entry)                        [::msgcat::mc MC(msg,empty_entry)]

set gPB(msg,edit_feed_fmt)                      [::msgcat::mc MC(msg,edit_feed_fmt)]

set gPB(msg,seq_num_max)                        [::msgcat::mc MC(msg,seq_num_max)]
set gPB(msg,no_cdl_name)                        [::msgcat::mc MC(msg,no_cdl_name)]
set gPB(msg,no_def_name)                        [::msgcat::mc MC(msg,no_def_name)]
set gPB(msg,no_own_name)                        [::msgcat::mc MC(msg,no_own_name)]
set gPB(msg,no_oth_ude_name)                    [::msgcat::mc MC(msg,no_oth_ude_name)]
set gPB(msg,not_oth_cdl_file)                   [::msgcat::mc MC(msg,not_oth_cdl_file)]
set gPB(msg,not_pui_file)                       [::msgcat::mc MC(msg,not_pui_file)]
set gPB(msg,not_cdl_file)                       [::msgcat::mc MC(msg,not_cdl_file)]
set gPB(msg,not_def_file)                       [::msgcat::mc MC(msg,not_def_file)]
set gPB(msg,not_own_cdl_file)                   [::msgcat::mc MC(msg,not_own_cdl_file)]
set gPB(msg,no_cdl_file)                        [::msgcat::mc MC(msg,no_cdl_file)]
set gPB(msg,cdl_info)                           [::msgcat::mc MC(msg,cdl_info)]


set gPB(msg,add_max1)                           [::msgcat::mc MC(msg,add_max1)]
set gPB(msg,add_max2)                           [::msgcat::mc MC(msg,add_max2)]


set gPB(com,text_entry_trans,title,Label)       [::msgcat::mc MC(com,text_entry_trans,title,Label)]

##---------------------------
## Common Navigation Buttons
##
set gPB(nav_button,no_license,Message)          [::msgcat::mc MC(nav_button,no_license,Message)]

set gPB(nav_button,ok,Label)                    [::msgcat::mc MC(nav_button,ok,Label)]
set gPB(nav_button,ok,Context)                  [::msgcat::mc MC(nav_button,ok,Context)]
set gPB(nav_button,cancel,Label)                [::msgcat::mc MC(nav_button,cancel,Label)]
set gPB(nav_button,cancel,Context)              [::msgcat::mc MC(nav_button,cancel,Context)]
set gPB(nav_button,default,Label)               [::msgcat::mc MC(nav_button,default,Label)]
set gPB(nav_button,default,Context)             [::msgcat::mc MC(nav_button,default,Context)]
set gPB(nav_button,restore,Label)               [::msgcat::mc MC(nav_button,restore,Label)]
set gPB(nav_button,restore,Context)             [::msgcat::mc MC(nav_button,restore,Context)]
set gPB(nav_button,apply,Label)                 [::msgcat::mc MC(nav_button,apply,Label)]
set gPB(nav_button,apply,Context)               [::msgcat::mc MC(nav_button,apply,Context)]
set gPB(nav_button,filter,Label)                [::msgcat::mc MC(nav_button,filter,Label)]
set gPB(nav_button,filter,Context)              [::msgcat::mc MC(nav_button,filter,Context)]
set gPB(nav_button,yes,Label)                   [::msgcat::mc MC(nav_button,yes,Label)]
set gPB(nav_button,yes,Context)                 [::msgcat::mc MC(nav_button,yes,Context)]
set gPB(nav_button,no,Label)                    [::msgcat::mc MC(nav_button,no,Label)]
set gPB(nav_button,no,Context)                  [::msgcat::mc MC(nav_button,no,Context)]
set gPB(nav_button,help,Label)                  [::msgcat::mc MC(nav_button,help,Label)]
set gPB(nav_button,help,Context)                [::msgcat::mc MC(nav_button,help,Context)]

set gPB(nav_button,open,Label)                  [::msgcat::mc MC(nav_button,open,Label)]
set gPB(nav_button,open,Context)                [::msgcat::mc MC(nav_button,open,Context)]

set gPB(nav_button,save,Label)                  [::msgcat::mc MC(nav_button,save,Label)]
set gPB(nav_button,save,Context)                [::msgcat::mc MC(nav_button,save,Context)]

set gPB(nav_button,manage,Label)                [::msgcat::mc MC(nav_button,manage,Label)]
set gPB(nav_button,manage,Context)              [::msgcat::mc MC(nav_button,manage,Context)]

set gPB(nav_button,refresh,Label)               [::msgcat::mc MC(nav_button,refresh,Label)]
set gPB(nav_button,refresh,Context)             [::msgcat::mc MC(nav_button,refresh,Context)]

set gPB(nav_button,cut,Label)                   [::msgcat::mc MC(nav_button,cut,Label)]
set gPB(nav_button,cut,Context)                 [::msgcat::mc MC(nav_button,cut,Context)]

set gPB(nav_button,copy,Label)                  [::msgcat::mc MC(nav_button,copy,Label)]
set gPB(nav_button,copy,Context)                [::msgcat::mc MC(nav_button,copy,Context)]

set gPB(nav_button,paste,Label)                 [::msgcat::mc MC(nav_button,paste,Label)]
set gPB(nav_button,paste,Context)               [::msgcat::mc MC(nav_button,paste,Context)]

set gPB(nav_button,edit,Label)                  [::msgcat::mc MC(nav_button,edit,Label)]
set gPB(nav_button,edit,Context)                [::msgcat::mc MC(nav_button,edit,Context)]

set gPB(nav_button,ex_editor,Label)             [::msgcat::mc MC(nav_button,ex_editor,Label)]


##------------
## New dialog
##
set gPB(new,title,Label)                        [::msgcat::mc MC(new,title,Label)]
set gPB(new,Status)                             [::msgcat::mc MC(new,Status)]

set gPB(new,name,Label)                         [::msgcat::mc MC(new,name,Label)]
set gPB(new,name,Context)                       [::msgcat::mc MC(new,name,Context)]

set gPB(new,desc,Label)                         [::msgcat::mc MC(new,desc,Label)]
set gPB(new,desc,Context)                       [::msgcat::mc MC(new,desc,Context)]

#Description for each selection
set gPB(new,mill,desc,Label)                    [::msgcat::mc MC(new,mill,desc,Label)]
set gPB(new,lathe,desc,Label)                   [::msgcat::mc MC(new,lathe,desc,Label)]
set gPB(new,wedm,desc,Label)                    [::msgcat::mc MC(new,wedm,desc,Label)]

set gPB(new,wedm_2,desc,Label)                  [::msgcat::mc MC(new,wedm_2,desc,Label)]
set gPB(new,wedm_4,desc,Label)                  [::msgcat::mc MC(new,wedm_4,desc,Label)]
set gPB(new,lathe_2,desc,Label)                 [::msgcat::mc MC(new,lathe_2,desc,Label)]
set gPB(new,lathe_4,desc,Label)                 [::msgcat::mc MC(new,lathe_4,desc,Label)]
set gPB(new,mill_3,desc,Label)                  [::msgcat::mc MC(new,mill_3,desc,Label)]
set gPB(new,mill_3MT,desc,Label)                [::msgcat::mc MC(new,mill_3MT,desc,Label)]
set gPB(new,mill_4H,desc,Label)                 [::msgcat::mc MC(new,mill_4H,desc,Label)]
set gPB(new,mill_4T,desc,Label)                 [::msgcat::mc MC(new,mill_4T,desc,Label)]
set gPB(new,mill_5TT,desc,Label)                [::msgcat::mc MC(new,mill_5TT,desc,Label)]
set gPB(new,mill_5HH,desc,Label)                [::msgcat::mc MC(new,mill_5HH,desc,Label)]
set gPB(new,mill_5HT,desc,Label)                [::msgcat::mc MC(new,mill_5HT,desc,Label)]
set gPB(new,punch,desc,Label)                   [::msgcat::mc MC(new,punch,desc,Label)]

set gPB(new,post_unit,Label)                    [::msgcat::mc MC(new,post_unit,Label)]

set gPB(new,inch,Label)                         [::msgcat::mc MC(new,inch,Label)]
set gPB(new,inch,Context)                       [::msgcat::mc MC(new,inch,Context)]
set gPB(new,millimeter,Label)                   [::msgcat::mc MC(new,millimeter,Label)]
set gPB(new,millimeter,Context)                 [::msgcat::mc MC(new,millimeter,Context)]

set gPB(new,machine,Label)                      [::msgcat::mc MC(new,machine,Label)]
set gPB(new,machine,Context)                    [::msgcat::mc MC(new,machine,Context)]

set gPB(new,mill,Label)                         [::msgcat::mc MC(new,mill,Label)]
set gPB(new,mill,Context)                       [::msgcat::mc MC(new,mill,Context)]
set gPB(new,lathe,Label)                        [::msgcat::mc MC(new,lathe,Label)]
set gPB(new,lathe,Context)                      [::msgcat::mc MC(new,lathe,Context)]
set gPB(new,wire,Label)                         [::msgcat::mc MC(new,wire,Label)]
set gPB(new,wire,Context)                       [::msgcat::mc MC(new,wire,Context)]
set gPB(new,punch,Label)                        [::msgcat::mc MC(new,punch,Label)]

set gPB(new,axis,Label)                         [::msgcat::mc MC(new,axis,Label)]
set gPB(new,axis,Context)                       [::msgcat::mc MC(new,axis,Context)]

#Axis Number
set gPB(new,axis_2,Label)                       [::msgcat::mc MC(new,axis_2,Label)]
set gPB(new,axis_3,Label)                       [::msgcat::mc MC(new,axis_3,Label)]
set gPB(new,axis_4,Label)                       [::msgcat::mc MC(new,axis_4,Label)]
set gPB(new,axis_5,Label)                       [::msgcat::mc MC(new,axis_5,Label)]
set gPB(new,axis_XZC,Label)                     [::msgcat::mc MC(new,axis_XZC,Label)]

#Axis Type
set gPB(new,mach_axis,Label)                    [::msgcat::mc MC(new,mach_axis,Label)]
set gPB(new,mach_axis,Context)                  [::msgcat::mc MC(new,mach_axis,Context)]
set gPB(new,lathe_2,Label)                      [::msgcat::mc MC(new,lathe_2,Label)]
set gPB(new,mill_3,Label)                       [::msgcat::mc MC(new,mill_3,Label)]
set gPB(new,mill_3MT,Label)                     [::msgcat::mc MC(new,mill_3MT,Label)]
set gPB(new,mill_4T,Label)                      [::msgcat::mc MC(new,mill_4T,Label)]
set gPB(new,mill_4H,Label)                      [::msgcat::mc MC(new,mill_4H,Label)]
set gPB(new,lathe_4,Label)                      [::msgcat::mc MC(new,lathe_4,Label)]
set gPB(new,mill_5HH,Label)                     [::msgcat::mc MC(new,mill_5HH,Label)]
set gPB(new,mill_5TT,Label)                     [::msgcat::mc MC(new,mill_5TT,Label)]
set gPB(new,mill_5HT,Label)                     [::msgcat::mc MC(new,mill_5HT,Label)]
set gPB(new,wedm_2,Label)                       [::msgcat::mc MC(new,wedm_2,Label)]
set gPB(new,wedm_4,Label)                       [::msgcat::mc MC(new,wedm_4,Label)]
set gPB(new,punch,Label)                        [::msgcat::mc MC(new,punch,Label)]

set gPB(new,control,Label)                      [::msgcat::mc MC(new,control,Label)]
set gPB(new,control,Context)                    [::msgcat::mc MC(new,control,Context)]

#Controller Type
set gPB(new,generic,Label)                      [::msgcat::mc MC(new,generic,Label)]
set gPB(new,library,Label)                      [::msgcat::mc MC(new,library,Label)]
set gPB(new,user,Label)                         [::msgcat::mc MC(new,user,Label)]
set gPB(new,user,browse,Label)                  [::msgcat::mc MC(new,user,browse,Label)]

set gPB(new,allen,Label)                        [::msgcat::mc MC(new,allen,Label)]
set gPB(new,bridge,Label)                       [::msgcat::mc MC(new,bridge,Label)]
set gPB(new,brown,Label)                        [::msgcat::mc MC(new,brown,Label)]
set gPB(new,cincin,Label)                       [::msgcat::mc MC(new,cincin,Label)]
set gPB(new,kearny,Label)                       [::msgcat::mc MC(new,kearny,Label)]
set gPB(new,fanuc,Label)                        [::msgcat::mc MC(new,fanuc,Label)]
set gPB(new,ge,Label)                           [::msgcat::mc MC(new,ge,Label)]
set gPB(new,gn,Label)                           [::msgcat::mc MC(new,gn,Label)]
set gPB(new,gidding,Label)                      [::msgcat::mc MC(new,gidding,Label)]
set gPB(new,heiden,Label)                       [::msgcat::mc MC(new,heiden,Label)]
set gPB(new,mazak,Label)                        [::msgcat::mc MC(new,mazak,Label)]
set gPB(new,seimens,Label)                      [::msgcat::mc MC(new,seimens,Label)]

##-------------
## Open dialog
##
set gPB(open,title,Label)                       [::msgcat::mc MC(open,title,Label)]
set gPB(open,Status)                            [::msgcat::mc MC(open,Status)]
set gPB(open,file_type_pui)                     [::msgcat::mc MC(open,file_type_pui)]
set gPB(open,file_type_tcl)                     [::msgcat::mc MC(open,file_type_tcl)]
set gPB(open,file_type_def)                     [::msgcat::mc MC(open,file_type_def)]
set gPB(open,file_type_cdl)                     [::msgcat::mc MC(open,file_type_cdl)]

##-------------
## Misc dialog
##
set gPB(open_save,dlg,title,Label)              [::msgcat::mc MC(open_save,dlg,title,Label)]
set gPB(exp_cc,dlg,title,Label)                 [::msgcat::mc MC(exp_cc,dlg,title,Label)]
set gPB(show_mt,title,Label)                    [::msgcat::mc MC(show_mt,title,Label)]

##----------------
## Utils dialog
##
set gPB(mvb,title,Label)                       [::msgcat::mc MC(mvb,title,Label)]
set gPB(mvb,cat,Label)                         [::msgcat::mc MC(mvb,cat,Label)]
set gPB(mvb,search,Label)                      [::msgcat::mc MC(mvb,search,Label)]
set gPB(mvb,defv,Label)                        [::msgcat::mc MC(mvb,defv,Label)]
set gPB(mvb,posv,Label)                        [::msgcat::mc MC(mvb,posv,Label)]
set gPB(mvb,data,Label)                        [::msgcat::mc MC(mvb,data,Label)]
set gPB(mvb,desc,Label)                        [::msgcat::mc MC(mvb,desc,Label)]

set gPB(inposts,title,Label)                   [::msgcat::mc MC(inposts,title,Label)]
set gPB(tpdf,text,Label)                       [::msgcat::mc MC(tpdf,text,Label)]
set gPB(inposts,edit,title,Label)              [::msgcat::mc MC(inposts,edit,title,Label)]
set gPB(inposts,edit,post,Label)               [::msgcat::mc MC(inposts,edit,post,Label)]


##----------------
## Save As dialog
##
set gPB(save_as,title,Label)                    [::msgcat::mc MC(save_as,title,Label)]
set gPB(save_as,name,Label)                     [::msgcat::mc MC(save_as,name,Label)]
set gPB(save_as,name,Context)                   [::msgcat::mc MC(save_as,name,Context)]
set gPB(save_as,Status)                         [::msgcat::mc MC(save_as,Status)]
set gPB(save_as,file_type_pui)                  [::msgcat::mc MC(save_as,file_type_pui)]

##----------------
## Common Widgets
##
set gPB(common,entry,Label)                     [::msgcat::mc MC(common,entry,Label)]
set gPB(common,entry,Context)                   [::msgcat::mc MC(common,entry,Context)]

##-----------
## Note Book
##
set gPB(nbook,tab,Label)                        [::msgcat::mc MC(nbook,tab,Label)]
set gPB(nbook,tab,Context)                      [::msgcat::mc MC(nbook,tab,Context)]

##------
## Tree
##
set gPB(tree,select,Label)                      [::msgcat::mc MC(tree,select,Label)]
set gPB(tree,select,Context)                    [::msgcat::mc MC(tree,select,Context)]
set gPB(tree,create,Label)                      [::msgcat::mc MC(tree,create,Label)]
set gPB(tree,create,Context)                    [::msgcat::mc MC(tree,create,Context)]
set gPB(tree,cut,Label)                         [::msgcat::mc MC(tree,cut,Label)]
set gPB(tree,cut,Context)                       [::msgcat::mc MC(tree,cut,Context)]
set gPB(tree,paste,Label)                       [::msgcat::mc MC(tree,paste,Label)]
set gPB(tree,paste,Context)                     [::msgcat::mc MC(tree,paste,Context)]
set gPB(tree,rename,Label)                      [::msgcat::mc MC(tree,rename,Label)]

##------------------
## Encrypt dialogs
##
set gPB(encrypt,browser,Label)                  [::msgcat::mc MC(encrypt,browser,Label)]
set gPB(encrypt,title,Label)                    [::msgcat::mc MC(encrypt,title,Label)]
set gPB(encrypt,output,Label)                   [::msgcat::mc MC(encrypt,output,Label)]
set gPB(encrypt,license,Label)                  [::msgcat::mc MC(encrypt,license,Label)]

#++++++++++++++
# Machine Tool
#++++++++++++++
set gPB(machine,tab,Label)                      [::msgcat::mc MC(machine,tab,Label)]
set gPB(machine,Status)                         [::msgcat::mc MC(machine,Status)]

set gPB(msg,no_display)                         [::msgcat::mc MC(msg,no_display)]
set gPB(msg,no_4th_ctable)                      [::msgcat::mc MC(msg,no_4th_ctable)]
set gPB(msg,no_4th_max_min)                     [::msgcat::mc MC(msg,no_4th_max_min)]
set gPB(msg,no_4th_both_neg)                    [::msgcat::mc MC(msg,no_4th_both_neg)]
set gPB(msg,no_4th_5th_plane)                   [::msgcat::mc MC(msg,no_4th_5th_plane)]
set gPB(msg,no_4thT_5thH)                       [::msgcat::mc MC(msg,no_4thT_5thH)]
set gPB(msg,no_5th_max_min)                     [::msgcat::mc MC(msg,no_5th_max_min)]
set gPB(msg,no_5th_both_neg)                    [::msgcat::mc MC(msg,no_5th_both_neg)]

##---------
# Post Info
##
set gPB(machine,info,title,Label)               [::msgcat::mc MC(machine,info,title,Label)]
set gPB(machine,info,desc,Label)                [::msgcat::mc MC(machine,info,desc,Label)]
set gPB(machine,info,type,Label)                [::msgcat::mc MC(machine,info,type,Label)]
set gPB(machine,info,kinematics,Label)          [::msgcat::mc MC(machine,info,kinematics,Label)]
set gPB(machine,info,unit,Label)                [::msgcat::mc MC(machine,info,unit,Label)]
set gPB(machine,info,controller,Label)          [::msgcat::mc MC(machine,info,controller,Label)]
set gPB(machine,info,history,Label)             [::msgcat::mc MC(machine,info,history,Label)]

##---------
## Display
##
set gPB(machine,display,Label)                  [::msgcat::mc MC(machine,display,Label)]
set gPB(machine,display,Context)                [::msgcat::mc MC(machine,display,Context)]
set gPB(machine,display_trans,title,Label)      [::msgcat::mc MC(machine,display_trans,title,Label)]


##---------------
## General parms
##
set gPB(machine,gen,Label)                      [::msgcat::mc MC(machine,gen,Label)]

set gPB(machine,gen,out_unit,Label)             [::msgcat::mc MC(machine,gen,out_unit,Label)]
set gPB(machine,gen,out_unit,Context)           [::msgcat::mc MC(machine,gen,out_unit,Context)]

set gPB(machine,gen,travel_limit,Label)         [::msgcat::mc MC(machine,gen,travel_limit,Label)]
set gPB(machine,gen,travel_limit,Context)       [::msgcat::mc MC(machine,gen,travel_limit,Context)]
set gPB(machine,gen,travel_limit,x,Label)       [::msgcat::mc MC(machine,gen,travel_limit,x,Label)]
set gPB(machine,gen,travel_limit,x,Context)     [::msgcat::mc MC(machine,gen,travel_limit,x,Context)]
set gPB(machine,gen,travel_limit,y,Label)       [::msgcat::mc MC(machine,gen,travel_limit,y,Label)]
set gPB(machine,gen,travel_limit,y,Context)     [::msgcat::mc MC(machine,gen,travel_limit,y,Context)]
set gPB(machine,gen,travel_limit,z,Label)       [::msgcat::mc MC(machine,gen,travel_limit,z,Label)]
set gPB(machine,gen,travel_limit,z,Context)     [::msgcat::mc MC(machine,gen,travel_limit,z,Context)]

set gPB(machine,gen,home_pos,Label)             [::msgcat::mc MC(machine,gen,home_pos,Label)]
set gPB(machine,gen,home_pos,Context)           [::msgcat::mc MC(machine,gen,home_pos,Context)]
set gPB(machine,gen,home_pos,x,Label)           [::msgcat::mc MC(machine,gen,home_pos,x,Label)]
set gPB(machine,gen,home_pos,x,Context)         [::msgcat::mc MC(machine,gen,home_pos,x,Context)]
set gPB(machine,gen,home_pos,y,Label)           [::msgcat::mc MC(machine,gen,home_pos,y,Label)]
set gPB(machine,gen,home_pos,y,Context)         [::msgcat::mc MC(machine,gen,home_pos,y,Context)]
set gPB(machine,gen,home_pos,z,Label)           [::msgcat::mc MC(machine,gen,home_pos,z,Label)]
set gPB(machine,gen,home_pos,z,Context)         [::msgcat::mc MC(machine,gen,home_pos,z,Context)]

set gPB(machine,gen,step_size,Label)            [::msgcat::mc MC(machine,gen,step_size,Label)]
set gPB(machine,gen,step_size,min,Label)        [::msgcat::mc MC(machine,gen,step_size,min,Label)]
set gPB(machine,gen,step_size,min,Context)      [::msgcat::mc MC(machine,gen,step_size,min,Context)]

set gPB(machine,gen,traverse_feed,Label)        [::msgcat::mc MC(machine,gen,traverse_feed,Label)]
set gPB(machine,gen,traverse_feed,max,Label)    [::msgcat::mc MC(machine,gen,traverse_feed,max,Label)]
set gPB(machine,gen,traverse_feed,max,Context)  [::msgcat::mc MC(machine,gen,traverse_feed,max,Context)]

set gPB(machine,gen,circle_record,Label)        [::msgcat::mc MC(machine,gen,circle_record,Label)]
set gPB(machine,gen,circle_record,yes,Label)    [::msgcat::mc MC(machine,gen,circle_record,yes,Label)]
set gPB(machine,gen,circle_record,yes,Context)  [::msgcat::mc MC(machine,gen,circle_record,yes,Context)]
set gPB(machine,gen,circle_record,no,Label)     [::msgcat::mc MC(machine,gen,circle_record,no,Label)]
set gPB(machine,gen,circle_record,no,Context)   [::msgcat::mc MC(machine,gen,circle_record,no,Context)]

set gPB(machine,gen,config_4and5_axis,oth,Label) [::msgcat::mc MC(machine,gen,config_4and5_axis,oth,Label)]

# Wire EDM parameters
set gPB(machine,gen,wedm,wire_tilt)             [::msgcat::mc MC(machine,gen,wedm,wire_tilt)]
set gPB(machine,gen,wedm,angle)                 [::msgcat::mc MC(machine,gen,wedm,angle)]
set gPB(machine,gen,wedm,coord)                 [::msgcat::mc MC(machine,gen,wedm,coord)]

# Lathe parameters
set gPB(machine,gen,turret,Label)               [::msgcat::mc MC(machine,gen,turret,Label)]
set gPB(machine,gen,turret,Context)             [::msgcat::mc MC(machine,gen,turret,Context)]
set gPB(machine,gen,turret,conf,Label)          [::msgcat::mc MC(machine,gen,turret,conf,Label)]
set gPB(machine,gen,turret,conf,Context)        [::msgcat::mc MC(machine,gen,turret,conf,Context)]
set gPB(machine,gen,turret,one,Label)           [::msgcat::mc MC(machine,gen,turret,one,Label)]
set gPB(machine,gen,turret,one,Context)         [::msgcat::mc MC(machine,gen,turret,one,Context)]
set gPB(machine,gen,turret,two,Label)           [::msgcat::mc MC(machine,gen,turret,two,Label)]
set gPB(machine,gen,turret,two,Context)         [::msgcat::mc MC(machine,gen,turret,two,Context)]

set gPB(machine,gen,turret,conf_trans,Label)    [::msgcat::mc MC(machine,gen,turret,conf_trans,Label)]
set gPB(machine,gen,turret,prim,Label)          [::msgcat::mc MC(machine,gen,turret,prim,Label)]
set gPB(machine,gen,turret,prim,Context)        [::msgcat::mc MC(machine,gen,turret,prim,Context)]
set gPB(machine,gen,turret,sec,Label)           [::msgcat::mc MC(machine,gen,turret,sec,Label)]
set gPB(machine,gen,turret,sec,Context)         [::msgcat::mc MC(machine,gen,turret,sec,Context)]
set gPB(machine,gen,turret,designation,Label)   [::msgcat::mc MC(machine,gen,turret,designation,Label)]
set gPB(machine,gen,turret,xoff,Label)          [::msgcat::mc MC(machine,gen,turret,xoff,Label)]
set gPB(machine,gen,turret,xoff,Context)        [::msgcat::mc MC(machine,gen,turret,xoff,Context)]
set gPB(machine,gen,turret,zoff,Label)          [::msgcat::mc MC(machine,gen,turret,zoff,Label)]
set gPB(machine,gen,turret,zoff,Context)        [::msgcat::mc MC(machine,gen,turret,zoff,Context)]

set gPB(machine,gen,turret,front,Label)         [::msgcat::mc MC(machine,gen,turret,front,Label)]
set gPB(machine,gen,turret,rear,Label)          [::msgcat::mc MC(machine,gen,turret,rear,Label)]
set gPB(machine,gen,turret,right,Label)         [::msgcat::mc MC(machine,gen,turret,right,Label)]
set gPB(machine,gen,turret,left,Label)          [::msgcat::mc MC(machine,gen,turret,left,Label)]
set gPB(machine,gen,turret,side,Label)          [::msgcat::mc MC(machine,gen,turret,side,Label)]
set gPB(machine,gen,turret,saddle,Label)        [::msgcat::mc MC(machine,gen,turret,saddle,Label)]

set gPB(machine,gen,axis_multi,Label)           [::msgcat::mc MC(machine,gen,axis_multi,Label)]
set gPB(machine,gen,axis_multi,dia,Label)       [::msgcat::mc MC(machine,gen,axis_multi,dia,Label)]
set gPB(machine,gen,axis_multi,dia,Context)     [::msgcat::mc MC(machine,gen,axis_multi,dia,Context)]
set gPB(machine,gen,axis_multi,2x,Label)        [::msgcat::mc MC(machine,gen,axis_multi,2x,Label)]
set gPB(machine,gen,axis_multi,2x,Context)      [::msgcat::mc MC(machine,gen,axis_multi,2x,Context)]

set gPB(machine,gen,axis_multi,2y,Label)        [::msgcat::mc MC(machine,gen,axis_multi,2y,Label)]
set gPB(machine,gen,axis_multi,2y,Context)      [::msgcat::mc MC(machine,gen,axis_multi,2y,Context)]
set gPB(machine,gen,axis_multi,2i,Label)        [::msgcat::mc MC(machine,gen,axis_multi,2i,Label)]
set gPB(machine,gen,axis_multi,2i,Context)      [::msgcat::mc MC(machine,gen,axis_multi,2i,Context)]
set gPB(machine,gen,axis_multi,2j,Label)        [::msgcat::mc MC(machine,gen,axis_multi,2j,Label)]
set gPB(machine,gen,axis_multi,2j,Context)      [::msgcat::mc MC(machine,gen,axis_multi,2j,Context)]

set gPB(machine,gen,axis_multi,mir,Label)       [::msgcat::mc MC(machine,gen,axis_multi,mir,Label)]
set gPB(machine,gen,axis_multi,mir,Context)     [::msgcat::mc MC(machine,gen,axis_multi,mir,Context)]
set gPB(machine,gen,axis_multi,x,Label)         [::msgcat::mc MC(machine,gen,axis_multi,x,Label)]
set gPB(machine,gen,axis_multi,x,Context)       [::msgcat::mc MC(machine,gen,axis_multi,x,Context)]
set gPB(machine,gen,axis_multi,y,Label)         [::msgcat::mc MC(machine,gen,axis_multi,y,Label)]
set gPB(machine,gen,axis_multi,y,Context)       [::msgcat::mc MC(machine,gen,axis_multi,y,Context)]
set gPB(machine,gen,axis_multi,z,Label)         [::msgcat::mc MC(machine,gen,axis_multi,z,Label)]
set gPB(machine,gen,axis_multi,z,Context)       [::msgcat::mc MC(machine,gen,axis_multi,z,Context)]
set gPB(machine,gen,axis_multi,i,Label)         [::msgcat::mc MC(machine,gen,axis_multi,i,Label)]
set gPB(machine,gen,axis_multi,i,Context)       [::msgcat::mc MC(machine,gen,axis_multi,i,Context)]
set gPB(machine,gen,axis_multi,j,Label)         [::msgcat::mc MC(machine,gen,axis_multi,j,Label)]
set gPB(machine,gen,axis_multi,j,Context)       [::msgcat::mc MC(machine,gen,axis_multi,j,Context)]
set gPB(machine,gen,axis_multi,k,Label)         [::msgcat::mc MC(machine,gen,axis_multi,k,Label)]
set gPB(machine,gen,axis_multi,k,Context)       [::msgcat::mc MC(machine,gen,axis_multi,k,Context)]

set gPB(machine,gen,output,Label)               [::msgcat::mc MC(machine,gen,output,Label)]
set gPB(machine,gen,output,Context)             [::msgcat::mc MC(machine,gen,output,Context)]
set gPB(machine,gen,output,tool_tip,Label)      [::msgcat::mc MC(machine,gen,output,tool_tip,Label)]
set gPB(machine,gen,output,tool_tip,Context)    [::msgcat::mc MC(machine,gen,output,tool_tip,Context)]
set gPB(machine,gen,output,turret_ref,Label)    [::msgcat::mc MC(machine,gen,output,turret_ref,Label)]
set gPB(machine,gen,output,turret_ref,Context)  [::msgcat::mc MC(machine,gen,output,turret_ref,Context)]

set gPB(machine,gen,lathe_turret,msg)           [::msgcat::mc MC(machine,gen,lathe_turret,msg)]
set gPB(machine,gen,turret_chg,msg)             [::msgcat::mc MC(machine,gen,turret_chg,msg)]
# Entries for XZC/Mill-Turn
set gPB(machine,gen,spindle_axis,Label)         [::msgcat::mc MC(machine,gen,spindle_axis,Label)]
set gPB(machine,gen,spindle_axis,Context)       [::msgcat::mc MC(machine,gen,spindle_axis,Context)]

set gPB(machine,gen,position_in_yaxis,Label)    [::msgcat::mc MC(machine,gen,position_in_yaxis,Label)]
set gPB(machine,gen,position_in_yaxis,Context)  [::msgcat::mc MC(machine,gen,position_in_yaxis,Context)]

set gPB(machine,gen,mach_mode,Label)            [::msgcat::mc MC(machine,gen,mach_mode,Label)]
set gPB(machine,gen,mach_mode,Context)          [::msgcat::mc MC(machine,gen,mach_mode,Context)]

set gPB(machine,gen,mach_mode,xzc_mill,Label)       [::msgcat::mc MC(machine,gen,mach_mode,xzc_mill,Label)]
set gPB(machine,gen,mach_mode,xzc_mill,Context)     [::msgcat::mc MC(machine,gen,mach_mode,xzc_mill,Context)]

set gPB(machine,gen,mach_mode,mill_turn,Label)      [::msgcat::mc MC(machine,gen,mach_mode,mill_turn,Label)]
set gPB(machine,gen,mach_mode,mill_turn,Context)    [::msgcat::mc MC(machine,gen,mach_mode,mill_turn,Context)]

set gPB(machine,gen,mill_turn,lathe_post,Label)     [::msgcat::mc MC(machine,gen,mill_turn,lathe_post,Label)]
set gPB(machine,gen,mill_turn,lathe_post,Context)   [::msgcat::mc MC(machine,gen,mill_turn,lathe_post,Context)]

set gPB(machine,gen,lathe_post,select_name,Label)   [::msgcat::mc MC(machine,gen,lathe_post,select_name,Label)]
set gPB(machine,gen,lathe_post,select_name,Context) [::msgcat::mc MC(machine,gen,lathe_post,select_name,Context)]

set gPB(machine,gen,coord_mode,Label)         [::msgcat::mc MC(machine,gen,coord_mode,Label)]
set gPB(machine,gen,coord_mode,Context)       [::msgcat::mc MC(machine,gen,coord_mode,Context)]

set gPB(machine,gen,coord_mode,polar,Label)   [::msgcat::mc MC(machine,gen,coord_mode,polar,Label)]
set gPB(machine,gen,coord_mode,polar,Context) [::msgcat::mc MC(machine,gen,coord_mode,polar,Context)]

set gPB(machine,gen,coord_mode,cart,Label)    [::msgcat::mc MC(machine,gen,coord_mode,cart,Label)]
set gPB(machine,gen,coord_mode,cart,Context)  [::msgcat::mc MC(machine,gen,coord_mode,cart,Context)]

set gPB(machine,gen,xzc_arc_mode,Label)       [::msgcat::mc MC(machine,gen,xzc_arc_mode,Label)]
set gPB(machine,gen,xzc_arc_mode,Context)     [::msgcat::mc MC(machine,gen,xzc_arc_mode,Context)]

set gPB(machine,gen,xzc_arc_mode,polar,Label)   [::msgcat::mc MC(machine,gen,xzc_arc_mode,polar,Label)]
set gPB(machine,gen,xzc_arc_mode,polar,Context) [::msgcat::mc MC(machine,gen,xzc_arc_mode,polar,Context)]

set gPB(machine,gen,xzc_arc_mode,cart,Label)    [::msgcat::mc MC(machine,gen,xzc_arc_mode,cart,Label)]
set gPB(machine,gen,xzc_arc_mode,cart,Context)  [::msgcat::mc MC(machine,gen,xzc_arc_mode,cart,Context)]

set gPB(machine,gen,def_spindle_axis,Label)     [::msgcat::mc MC(machine,gen,def_spindle_axis,Label)]
set gPB(machine,gen,def_spindle_axis,Context)   [::msgcat::mc MC(machine,gen,def_spindle_axis,Context)]


##-----------------
## 4-th Axis parms
##
set gPB(machine,axis,fourth,Label)          [::msgcat::mc MC(machine,axis,fourth,Label)]

set gPB(machine,axis,radius_output,Label)   [::msgcat::mc MC(machine,axis,radius_output,Label)]
set gPB(machine,axis,radius_output,Context) [::msgcat::mc MC(machine,axis,radius_output,Context)]

set gPB(machine,axis,type_head,Label)       [::msgcat::mc MC(machine,axis,type_head,Label)]
set gPB(machine,axis,type_table,Label)      [::msgcat::mc MC(machine,axis,type_table,Label)]

##-----------------
## 5-th Axis parms
##
set gPB(machine,axis,fifth,Label)           [::msgcat::mc MC(machine,axis,fifth,Label)]

set gPB(machine,axis,rotary,Label)          [::msgcat::mc MC(machine,axis,rotary,Label)]

set gPB(machine,axis,offset,Label)                      [::msgcat::mc MC(machine,axis,offset,Label)]
set gPB(machine,axis,offset,4,Label)                    [::msgcat::mc MC(machine,axis,offset,4,Label)]
set gPB(machine,axis,offset,5,Label)                    [::msgcat::mc MC(machine,axis,offset,5,Label)]
set gPB(machine,axis,offset,x,Label)            [::msgcat::mc MC(machine,axis,offset,x,Label)]
set gPB(machine,axis,offset,x,Context)          [::msgcat::mc MC(machine,axis,offset,x,Context)]
set gPB(machine,axis,offset,y,Label)            [::msgcat::mc MC(machine,axis,offset,y,Label)]
set gPB(machine,axis,offset,y,Context)          [::msgcat::mc MC(machine,axis,offset,y,Context)]
set gPB(machine,axis,offset,z,Label)            [::msgcat::mc MC(machine,axis,offset,z,Label)]
set gPB(machine,axis,offset,z,Context)          [::msgcat::mc MC(machine,axis,offset,z,Context)]

set gPB(machine,axis,rotation,Label)            [::msgcat::mc MC(machine,axis,rotation,Label)]
set gPB(machine,axis,rotation,norm,Label)       [::msgcat::mc MC(machine,axis,rotation,norm,Label)]
set gPB(machine,axis,rotation,norm,Context)     [::msgcat::mc MC(machine,axis,rotation,norm,Context)]
set gPB(machine,axis,rotation,rev,Label)        [::msgcat::mc MC(machine,axis,rotation,rev,Label)]
set gPB(machine,axis,rotation,rev,Context)      [::msgcat::mc MC(machine,axis,rotation,rev,Context)]

set gPB(machine,axis,direction,Label)           [::msgcat::mc MC(machine,axis,direction,Label)]
set gPB(machine,axis,direction,Context)         [::msgcat::mc MC(machine,axis,direction,Context)]

set gPB(machine,axis,con_motion,Label)          [::msgcat::mc MC(machine,axis,con_motion,Label)]
set gPB(machine,axis,con_motion,combine,Label)      [::msgcat::mc MC(machine,axis,con_motion,combine,Label)]
set gPB(machine,axis,con_motion,combine,Context)    [::msgcat::mc MC(machine,axis,con_motion,combine,Context)]
set gPB(machine,axis,con_motion,tol,Label)      [::msgcat::mc MC(machine,axis,con_motion,tol,Label)]
set gPB(machine,axis,con_motion,tol,Context)        [::msgcat::mc MC(machine,axis,con_motion,tol,Context)]

set gPB(machine,axis,violation,Label)           [::msgcat::mc MC(machine,axis,violation,Label)]
set gPB(machine,axis,violation,warn,Label)      [::msgcat::mc MC(machine,axis,violation,warn,Label)]
set gPB(machine,axis,violation,warn,Context)        [::msgcat::mc MC(machine,axis,violation,warn,Context)]
set gPB(machine,axis,violation,ret,Label)       [::msgcat::mc MC(machine,axis,violation,ret,Label)]
set gPB(machine,axis,violation,ret,Context)     [::msgcat::mc MC(machine,axis,violation,ret,Context)]

set gPB(machine,axis,limits,Label)                      [::msgcat::mc MC(machine,axis,limits,Label)]
set gPB(machine,axis,limits,min,Label)          [::msgcat::mc MC(machine,axis,limits,min,Label)]
set gPB(machine,axis,limits,min,Context)        [::msgcat::mc MC(machine,axis,limits,min,Context)]
set gPB(machine,axis,limits,max,Label)          [::msgcat::mc MC(machine,axis,limits,max,Label)]
set gPB(machine,axis,limits,max,Context)        [::msgcat::mc MC(machine,axis,limits,max,Context)]

set gPB(machine,axis,incr_text)                 [::msgcat::mc MC(machine,axis,incr_text)]

set gPB(machine,axis,rotary_res,Label)          [::msgcat::mc MC(machine,axis,rotary_res,Label)]
set gPB(machine,axis,rotary_res,Context)        [::msgcat::mc MC(machine,axis,rotary_res,Context)]

set gPB(machine,axis,ang_offset,Label)          [::msgcat::mc MC(machine,axis,ang_offset,Label)]
set gPB(machine,axis,ang_offset,Context)        [::msgcat::mc MC(machine,axis,ang_offset,Context)]

set gPB(machine,axis,pivot,Label)               [::msgcat::mc MC(machine,axis,pivot,Label)]
set gPB(machine,axis,pivot,Context)             [::msgcat::mc MC(machine,axis,pivot,Context)]

set gPB(machine,axis,max_feed,Label)        [::msgcat::mc MC(machine,axis,max_feed,Label)]
set gPB(machine,axis,max_feed,Context)      [::msgcat::mc MC(machine,axis,max_feed,Context)]

set gPB(machine,axis,plane,Label)               [::msgcat::mc MC(machine,axis,plane,Label)]
set gPB(machine,axis,plane,Context)             [::msgcat::mc MC(machine,axis,plane,Context)]

set gPB(machine,axis,plane,normal,Label)        [::msgcat::mc MC(machine,axis,plane,normal,Label)]
set gPB(machine,axis,plane,normal,Context)      [::msgcat::mc MC(machine,axis,plane,normal,Context)]
set gPB(machine,axis,plane,4th,Label)           [::msgcat::mc MC(machine,axis,plane,4th,Label)]
set gPB(machine,axis,plane,4th,Context)         [::msgcat::mc MC(machine,axis,plane,4th,Context)]
set gPB(machine,axis,plane,5th,Label)           [::msgcat::mc MC(machine,axis,plane,5th,Label)]
set gPB(machine,axis,plane,5th,Context)         [::msgcat::mc MC(machine,axis,plane,5th,Context)]

set gPB(machine,axis,leader,Label)              [::msgcat::mc MC(machine,axis,leader,Label)]
set gPB(machine,axis,leader,Context)        [::msgcat::mc MC(machine,axis,leader,Context)]

set gPB(machine,axis,config,Label)              [::msgcat::mc MC(machine,axis,config,Label)]
set gPB(machine,axis,config,Context)        [::msgcat::mc MC(machine,axis,config,Context)]

set gPB(machine,axis,r_axis_conf_trans,Label)   [::msgcat::mc MC(machine,axis,r_axis_conf_trans,Label)]
set gPB(machine,axis,4th_axis,Label)            [::msgcat::mc MC(machine,axis,4th_axis,Label)]
set gPB(machine,axis,5th_axis,Label)            [::msgcat::mc MC(machine,axis,5th_axis,Label)]
set gPB(machine,axis,head,Label)                [::msgcat::mc MC(machine,axis,head,Label)]
set gPB(machine,axis,table,Label)               [::msgcat::mc MC(machine,axis,table,Label)]

set gPB(machine,axis,rotary_lintol,Label)       [::msgcat::mc MC(machine,axis,rotary_lintol,Label)]
set gPB(machine,axis,rotary_lintol,Context)     [::msgcat::mc MC(machine,axis,rotary_lintol,Context)]

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
set gPB(progtpth,tab,Label)         [::msgcat::mc MC(progtpth,tab,Label)]

##---------
## Program
##
set gPB(prog,tab,Label)             [::msgcat::mc MC(prog,tab,Label)]
set gPB(prog,Status)                [::msgcat::mc MC(prog,Status)]

set gPB(prog,tree,Label)            [::msgcat::mc MC(prog,tree,Label)]
set gPB(prog,tree,Context)          [::msgcat::mc MC(prog,tree,Context)]
set gPB(prog,tree,prog_strt,Label)      [::msgcat::mc MC(prog,tree,prog_strt,Label)]
set gPB(prog,tree,prog_end,Label)       [::msgcat::mc MC(prog,tree,prog_end,Label)]
set gPB(prog,tree,oper_strt,Label)      [::msgcat::mc MC(prog,tree,oper_strt,Label)]
set gPB(prog,tree,oper_end,Label)       [::msgcat::mc MC(prog,tree,oper_end,Label)]
set gPB(prog,tree,tool_path,Label)      [::msgcat::mc MC(prog,tree,tool_path,Label)]
set gPB(prog,tree,tool_path,mach_cnt,Label) [::msgcat::mc MC(prog,tree,tool_path,mach_cnt,Label)]
set gPB(prog,tree,tool_path,motion,Label)   [::msgcat::mc MC(prog,tree,tool_path,motion,Label)]
set gPB(prog,tree,tool_path,cycle,Label)    [::msgcat::mc MC(prog,tree,tool_path,cycle,Label)]
set gPB(prog,tree,linked_posts,Label)       [::msgcat::mc MC(prog,tree,linked_posts,Label)]

set gPB(prog,add,Label)             [::msgcat::mc MC(prog,add,Label)]
set gPB(prog,add,Context)           [::msgcat::mc MC(prog,add,Context)]

set gPB(prog,trash,Label)           [::msgcat::mc MC(prog,trash,Label)]
set gPB(prog,trash,Context)         [::msgcat::mc MC(prog,trash,Context)]

set gPB(prog,block,Label)           [::msgcat::mc MC(prog,block,Label)]
set gPB(prog,block,Context)         [::msgcat::mc MC(prog,block,Context)]

set gPB(prog,select,Label)          [::msgcat::mc MC(prog,select,Label)]
set gPB(prog,select,Context)        [::msgcat::mc MC(prog,select,Context)]

set gPB(prog,oper_temp,Label)           [::msgcat::mc MC(prog,oper_temp,Label)]
set gPB(prog,add_block,Label)           [::msgcat::mc MC(prog,add_block,Label)]
set gPB(prog,seq_comb_nc,Label)         [::msgcat::mc MC(prog,seq_comb_nc,Label)]
set gPB(prog,seq_comb_nc,Context)       [::msgcat::mc MC(prog,seq_comb_nc,Context)]

set gPB(prog,plus,Label)            [::msgcat::mc MC(prog,plus,Label)]
set gPB(prog,plus,Context)          [::msgcat::mc MC(prog,plus,Context)]

set gPB(prog,marker,Label)          [::msgcat::mc MC(prog,marker,Label)]
set gPB(prog,marker,Context)        [::msgcat::mc MC(prog,marker,Context)]

set gPB(prog,event,Label)           [::msgcat::mc MC(prog,event,Label)]
set gPB(prog,event,Context)         [::msgcat::mc MC(prog,event,Context)]

set gPB(prog,nc_code,Label)         [::msgcat::mc MC(prog,nc_code,Label)]
set gPB(prog,nc_code,Context)       [::msgcat::mc MC(prog,nc_code,Context)]
set gPB(prog,undo_popup,Label)      [::msgcat::mc MC(prog,undo_popup,Label)]

## Sequence
##
set gPB(seq,combo,new,Label)                    [::msgcat::mc MC(seq,combo,new,Label)]
set gPB(seq,combo,comment,Label)                [::msgcat::mc MC(seq,combo,comment,Label)]
set gPB(seq,combo,custom,Label)                 [::msgcat::mc MC(seq,combo,custom,Label)]

set gPB(seq,new_trans,title,Label)              [::msgcat::mc MC(seq,new_trans,title,Label)]
set gPB(seq,cus_trans,title,Label)              [::msgcat::mc MC(seq,cus_trans,title,Label)]
set gPB(seq,oper_trans,title,Label)             [::msgcat::mc MC(seq,oper_trans,title,Label)]

set gPB(seq,edit_popup,Label)                   [::msgcat::mc MC(seq,edit_popup,Label)]
set gPB(seq,force_popup,Label)                  [::msgcat::mc MC(seq,force_popup,Label)]
set gPB(seq,rename_popup,Label)                 [::msgcat::mc MC(seq,rename_popup,Label)]
set gPB(seq,rename_popup,Context)               [::msgcat::mc MC(seq,rename_popup,Context)]
set gPB(seq,cut_popup,Label)                    [::msgcat::mc MC(seq,cut_popup,Label)]
set gPB(seq,copy_popup,Label)                   [::msgcat::mc MC(seq,copy_popup,Label)]
set gPB(seq,copy_popup,ref,Label)               [::msgcat::mc MC(seq,copy_popup,ref,Label)]
set gPB(seq,copy_popup,new,Label)               [::msgcat::mc MC(seq,copy_popup,new,Label)]
set gPB(seq,paste_popup,Label)                  [::msgcat::mc MC(seq,paste_popup,Label)]
set gPB(seq,paste_popup,before,Label)           [::msgcat::mc MC(seq,paste_popup,before,Label)]
set gPB(seq,paste_popup,inline,Label)           [::msgcat::mc MC(seq,paste_popup,inline,Label)]
set gPB(seq,paste_popup,after,Label)            [::msgcat::mc MC(seq,paste_popup,after,Label)]
set gPB(seq,del_popup,Label)                    [::msgcat::mc MC(seq,del_popup,Label)]

set gPB(seq,force_trans,title,Label)            [::msgcat::mc MC(seq,force_trans,title,Label)]

##--------------
## Toolpath
##
set gPB(tool,event_trans,title,Label)           [::msgcat::mc MC(tool,event_trans,title,Label)]

set gPB(tool,event_seq,button,Label)            [::msgcat::mc MC(tool,event_seq,button,Label)]
set gPB(tool,add_word,button,Label)             [::msgcat::mc MC(tool,add_word,button,Label)]

set gPB(tool,format_trans,title,Label)          [::msgcat::mc MC(tool,format_trans,title,Label)]

set gPB(tool,circ_trans,title,Label)            [::msgcat::mc MC(tool,circ_trans,title,Label)]
set gPB(tool,circ_trans,frame,Label)            [::msgcat::mc MC(tool,circ_trans,frame,Label)]
set gPB(tool,circ_trans,xy,Label)               [::msgcat::mc MC(tool,circ_trans,xy,Label)]
set gPB(tool,circ_trans,yz,Label)               [::msgcat::mc MC(tool,circ_trans,yz,Label)]
set gPB(tool,circ_trans,zx,Label)               [::msgcat::mc MC(tool,circ_trans,zx,Label)]

set gPB(tool,ijk_desc,arc_start,Label)          [::msgcat::mc MC(tool,ijk_desc,arc_start,Label)]
set gPB(tool,ijk_desc,arc_center,Label)         [::msgcat::mc MC(tool,ijk_desc,arc_center,Label)]
set gPB(tool,ijk_desc,u_arc_start,Label)        [::msgcat::mc MC(tool,ijk_desc,u_arc_start,Label)]
set gPB(tool,ijk_desc,absolute,Label)           [::msgcat::mc MC(tool,ijk_desc,absolute,Label)]
set gPB(tool,ijk_desc,long_thread_lead,Label)   [::msgcat::mc MC(tool,ijk_desc,long_thread_lead,Label)]
set gPB(tool,ijk_desc,tran_thread_lead,Label)   [::msgcat::mc MC(tool,ijk_desc,tran_thread_lead,Label)]

set gPB(tool,spindle,range,type,Label)            [::msgcat::mc MC(tool,spindle,range,type,Label)]
set gPB(tool,spindle,range,range_M,Label)         [::msgcat::mc MC(tool,spindle,range,range_M,Label)]
set gPB(tool,spindle,range,with_spindle_M,Label)  [::msgcat::mc MC(tool,spindle,range,with_spindle_M,Label)]
set gPB(tool,spindle,range,hi_lo_with_S,Label)    [::msgcat::mc MC(tool,spindle,range,hi_lo_with_S,Label)]
set gPB(tool,spindle,range,nonzero_range,msg)     [::msgcat::mc MC(tool,spindle,range,nonzero_range,msg)]

set gPB(tool,spindle_trans,title,Label)         [::msgcat::mc MC(tool,spindle_trans,title,Label)]
set gPB(tool,spindle_trans,range,Label)         [::msgcat::mc MC(tool,spindle_trans,range,Label)]
set gPB(tool,spindle_trans,code,Label)          [::msgcat::mc MC(tool,spindle_trans,code,Label)]
set gPB(tool,spindle_trans,min,Label)           [::msgcat::mc MC(tool,spindle_trans,min,Label)]
set gPB(tool,spindle_trans,max,Label)           [::msgcat::mc MC(tool,spindle_trans,max,Label)]

set gPB(tool,spindle_desc,sep,Label)            [::msgcat::mc MC(tool,spindle_desc,sep,Label)]
set gPB(tool,spindle_desc,range,Label)          [::msgcat::mc MC(tool,spindle_desc,range,Label)]
set gPB(tool,spindle_desc,high,Label)           [::msgcat::mc MC(tool,spindle_desc,high,Label)]
set gPB(tool,spindle_desc,odd,Label)            [::msgcat::mc MC(tool,spindle_desc,odd,Label)]


set gPB(tool,config,mill_opt1,Label)            [::msgcat::mc MC(tool,config,mill_opt1,Label)]
set gPB(tool,config,mill_opt2,Label)            [::msgcat::mc MC(tool,config,mill_opt2,Label)]
set gPB(tool,config,mill_opt3,Label)            [::msgcat::mc MC(tool,config,mill_opt3,Label)]

set gPB(tool,config,title,Label)                [::msgcat::mc MC(tool,config,title,Label)]
set gPB(tool,config,output,Label)               [::msgcat::mc MC(tool,config,output,Label)]

set gPB(tool,config,lathe_opt1,Label)           [::msgcat::mc MC(tool,config,lathe_opt1,Label)]
set gPB(tool,config,lathe_opt2,Label)           [::msgcat::mc MC(tool,config,lathe_opt2,Label)]
set gPB(tool,config,lathe_opt3,Label)           [::msgcat::mc MC(tool,config,lathe_opt3,Label)]
set gPB(tool,config,lathe_opt4,Label)           [::msgcat::mc MC(tool,config,lathe_opt4,Label)]

set gPB(tool,conf_desc,num,Label)                [::msgcat::mc MC(tool,conf_desc,num,Label)]
set gPB(tool,conf_desc,next_num,Label)           [::msgcat::mc MC(tool,conf_desc,next_num,Label)]
set gPB(tool,conf_desc,index_num,Label)          [::msgcat::mc MC(tool,conf_desc,index_num,Label)]
set gPB(tool,conf_desc,index_next_num,Label)     [::msgcat::mc MC(tool,conf_desc,index_next_num,Label)]
set gPB(tool,conf_desc,num_len,Label)            [::msgcat::mc MC(tool,conf_desc,num_len,Label)]
set gPB(tool,conf_desc,next_num_len,Label)       [::msgcat::mc MC(tool,conf_desc,next_num_len,Label)]
set gPB(tool,conf_desc,len_num,Label)            [::msgcat::mc MC(tool,conf_desc,len_num,Label)]
set gPB(tool,conf_desc,len_next_num,Label)       [::msgcat::mc MC(tool,conf_desc,len_next_num,Label)]
set gPB(tool,conf_desc,index_num_len,Label)      [::msgcat::mc MC(tool,conf_desc,index_num_len,Label)]
set gPB(tool,conf_desc,index_next_num_len,Label) [::msgcat::mc MC(tool,conf_desc,index_next_num_len,Label)]

set gPB(tool,oper_trans,title,Label)             [::msgcat::mc MC(tool,oper_trans,title,Label)]
set gPB(tool,cus_trans,title,Label)              [::msgcat::mc MC(tool,cus_trans,title,Label)]

##--------------------------
## Labels for Event dialogs
##
set gPB(event,feed,IPM_mode)                     [::msgcat::mc MC(event,feed,IPM_mode)]

##---------
## G Codes
##
set gPB(gcode,tab,Label)            [::msgcat::mc MC(gcode,tab,Label)]
set gPB(gcode,Status)               [::msgcat::mc MC(gcode,Status)]

##---------
## M Codes
##
set gPB(mcode,tab,Label)            [::msgcat::mc MC(mcode,tab,Label)]
set gPB(mcode,Status)               [::msgcat::mc MC(mcode,Status)]

##-----------------
## Words Summary
##
set gPB(addrsum,tab,Label)          [::msgcat::mc MC(addrsum,tab,Label)]
set gPB(addrsum,Status)             [::msgcat::mc MC(addrsum,Status)]

set gPB(addrsum,col_addr,Label)                 [::msgcat::mc MC(addrsum,col_addr,Label)]
set gPB(addrsum,col_addr,Context)               [::msgcat::mc MC(addrsum,col_addr,Context)]
set gPB(addrsum,col_lead,Label)                 [::msgcat::mc MC(addrsum,col_lead,Label)]
set gPB(addrsum,col_data,Label)                 [::msgcat::mc MC(addrsum,col_data,Label)]
set gPB(addrsum,col_plus,Label)                 [::msgcat::mc MC(addrsum,col_plus,Label)]
set gPB(addrsum,col_lzero,Label)                [::msgcat::mc MC(addrsum,col_lzero,Label)]
set gPB(addrsum,col_int,Label)                  [::msgcat::mc MC(addrsum,col_int,Label)]
set gPB(addrsum,col_dec,Label)                  [::msgcat::mc MC(addrsum,col_dec,Label)]
set gPB(addrsum,col_frac,Label)                 [::msgcat::mc MC(addrsum,col_frac,Label)]
set gPB(addrsum,col_tzero,Label)                [::msgcat::mc MC(addrsum,col_tzero,Label)]
set gPB(addrsum,col_modal,Label)                [::msgcat::mc MC(addrsum,col_modal,Label)]
set gPB(addrsum,col_min,Label)                  [::msgcat::mc MC(addrsum,col_min,Label)]
set gPB(addrsum,col_max,Label)                  [::msgcat::mc MC(addrsum,col_max,Label)]
set gPB(addrsum,col_trail,Label)                [::msgcat::mc MC(addrsum,col_trail,Label)]

set gPB(addrsum,radio_text,Label)               [::msgcat::mc MC(addrsum,radio_text,Label)]
set gPB(addrsum,radio_num,Label)                [::msgcat::mc MC(addrsum,radio_num,Label)]

set gPB(addrsum,addr_trans,title,Label)         [::msgcat::mc MC(addrsum,addr_trans,title,Label)]
set gPB(addrsum,other_trans,title,Label)        [::msgcat::mc MC(addrsum,other_trans,title,Label)]

##-----------------
## Word Sequencing
##
set gPB(wseq,tab,Label)             [::msgcat::mc MC(wseq,tab,Label)]
set gPB(wseq,Status)                [::msgcat::mc MC(wseq,Status)]

set gPB(wseq,word,Label)            [::msgcat::mc MC(wseq,word,Label)]
set gPB(wseq,word,Context)          [::msgcat::mc MC(wseq,word,Context)]

set gPB(wseq,active_out,Label)                  [::msgcat::mc MC(wseq,active_out,Label)]
set gPB(wseq,suppressed_out,Label)              [::msgcat::mc MC(wseq,suppressed_out,Label)]

set gPB(wseq,popup_new,Label)                   [::msgcat::mc MC(wseq,popup_new,Label)]
set gPB(wseq,popup_undo,Label)                  [::msgcat::mc MC(wseq,popup_undo,Label)]
set gPB(wseq,popup_edit,Label)                  [::msgcat::mc MC(wseq,popup_edit,Label)]
set gPB(wseq,popup_delete,Label)                [::msgcat::mc MC(wseq,popup_delete,Label)]
set gPB(wseq,popup_all,Label)                   [::msgcat::mc MC(wseq,popup_all,Label)]
set gPB(wseq,transient_win,Label)               [::msgcat::mc MC(wseq,transient_win,Label)]
set gPB(wseq,cannot_suppress_msg)               [::msgcat::mc MC(wseq,cannot_suppress_msg)]
set gPB(wseq,empty_block_msg)                   [::msgcat::mc MC(wseq,empty_block_msg)]

##----------------
## Custom Command
##
set gPB(cust_cmd,tab,Label)         [::msgcat::mc MC(cust_cmd,tab,Label)]
set gPB(cust_cmd,Status)            [::msgcat::mc MC(cust_cmd,Status)]

set gPB(cust_cmd,name,Label)            [::msgcat::mc MC(cust_cmd,name,Label)]
set gPB(cust_cmd,name,Context)          [::msgcat::mc MC(cust_cmd,name,Context)]
set gPB(cust_cmd,proc,Label)            [::msgcat::mc MC(cust_cmd,proc,Label)]
set gPB(cust_cmd,proc,Context)          [::msgcat::mc MC(cust_cmd,proc,Context)]
set gPB(cust_cmd,name_msg)                      [::msgcat::mc MC(cust_cmd,name_msg)]
set gPB(cust_cmd,name_msg_1)                    [::msgcat::mc MC(cust_cmd,name_msg_1)]
set gPB(cust_cmd,name_msg_2)                    [::msgcat::mc MC(cust_cmd,name_msg_2)]
set gPB(cust_cmd,import,Label)                  [::msgcat::mc MC(cust_cmd,import,Label)]
set gPB(cust_cmd,import,Context)                [::msgcat::mc MC(cust_cmd,import,Context)]
set gPB(cust_cmd,export,Label)                  [::msgcat::mc MC(cust_cmd,export,Label)]
set gPB(cust_cmd,export,Context)                [::msgcat::mc MC(cust_cmd,export,Context)]
set gPB(cust_cmd,import,tree,Label)             [::msgcat::mc MC(cust_cmd,import,tree,Label)]
set gPB(cust_cmd,import,tree,Context)           [::msgcat::mc MC(cust_cmd,import,tree,Context)]

set gPB(cust_cmd,export,tree,Label)             [::msgcat::mc MC(cust_cmd,export,tree,Label)]
set gPB(cust_cmd,export,tree,Context)           [::msgcat::mc MC(cust_cmd,export,tree,Context)]

set gPB(cust_cmd,error,title)                   [::msgcat::mc MC(cust_cmd,error,title)]
set gPB(cust_cmd,error,msg)                     [::msgcat::mc MC(cust_cmd,error,msg)]
set gPB(cust_cmd,select_all,Label)              [::msgcat::mc MC(cust_cmd,select_all,Label)]
set gPB(cust_cmd,select_all,Context)            [::msgcat::mc MC(cust_cmd,select_all,Context)]
set gPB(cust_cmd,deselect_all,Label)            [::msgcat::mc MC(cust_cmd,deselect_all,Label)]
set gPB(cust_cmd,deselect_all,Context)          [::msgcat::mc MC(cust_cmd,deselect_all,Context)]

set gPB(cust_cmd,import,warning,title)          [::msgcat::mc MC(cust_cmd,import,warning,title)]
set gPB(cust_cmd,import,warning,msg)            [::msgcat::mc MC(cust_cmd,import,warning,msg)]



set gPB(cust_cmd,cmd,msg)                       [::msgcat::mc MC(cust_cmd,cmd,msg)]
set gPB(cust_cmd,blk,msg)                       [::msgcat::mc MC(cust_cmd,blk,msg)]
set gPB(cust_cmd,add,msg)                       [::msgcat::mc MC(cust_cmd,add,msg)]
set gPB(cust_cmd,fmt,msg)                       [::msgcat::mc MC(cust_cmd,fmt,msg)]
set gPB(cust_cmd,referenced,msg)                [::msgcat::mc MC(cust_cmd,referenced,msg)]
set gPB(cust_cmd,not_defined,msg)               [::msgcat::mc MC(cust_cmd,not_defined,msg)]
set gPB(cust_cmd,cannot_delete,msg)             [::msgcat::mc MC(cust_cmd,cannot_delete,msg)]
set gPB(cust_cmd,save_post,msg)                 [::msgcat::mc MC(cust_cmd,save_post,msg)]


##------------------
## Operator Message
##
set gPB(opr_msg,text,Label)         [::msgcat::mc MC(opr_msg,text,Label)]
set gPB(opr_msg,text,Context)           [::msgcat::mc MC(opr_msg,text,Context)]

set gPB(opr_msg,name,Label)         [::msgcat::mc MC(opr_msg,name,Label)]
set gPB(opr_msg,empty_operator)                 [::msgcat::mc MC(opr_msg,empty_operator)]


##--------------
## Linked Posts
##
set gPB(link_post,tab,Label)                    [::msgcat::mc MC(link_post,tab,Label)]
set gPB(link_post,Status)                       [::msgcat::mc MC(link_post,Status)]

set gPB(link_post,toggle,Label)                 [::msgcat::mc MC(link_post,toggle,Label)]
set gPB(link_post,toggle,Context)               [::msgcat::mc MC(link_post,toggle,Context)]

set gPB(link_post,head,Label)                   [::msgcat::mc MC(link_post,head,Label)]
set gPB(link_post,head,Context)                 [::msgcat::mc MC(link_post,head,Context)]

set gPB(link_post,post,Label)                   [::msgcat::mc MC(link_post,post,Label)]
set gPB(link_post,post,Context)                 [::msgcat::mc MC(link_post,post,Context)]

set gPB(link_post,link,Label)                   [::msgcat::mc MC(link_post,link,Label)]
set gPB(link_post,link,Context)                 [::msgcat::mc MC(link_post,link,Context)]

set gPB(link_post,new,Label)                    [::msgcat::mc MC(link_post,new,Label)]
set gPB(link_post,new,Context)                  [::msgcat::mc MC(link_post,new,Context)]

set gPB(link_post,edit,Label)                   [::msgcat::mc MC(link_post,edit,Label)]
set gPB(link_post,edit,Context)                 [::msgcat::mc MC(link_post,edit,Context)]

set gPB(link_post,delete,Label)                 [::msgcat::mc MC(link_post,delete,Label)]
set gPB(link_post,delete,Context)               [::msgcat::mc MC(link_post,delete,Context)]

set gPB(link_post,select_name,Label)            [::msgcat::mc MC(link_post,select_name,Label)]
set gPB(link_post,select_name,Context)          [::msgcat::mc MC(link_post,select_name,Context)]

set gPB(link_post,start_of_head,Label)          [::msgcat::mc MC(link_post,start_of_head,Label)]
set gPB(link_post,start_of_head,Context)        [::msgcat::mc MC(link_post,start_of_head,Context)]

set gPB(link_post,end_of_head,Label)            [::msgcat::mc MC(link_post,end_of_head,Label)]
set gPB(link_post,end_of_head,Context)          [::msgcat::mc MC(link_post,end_of_head,Context)]

set gPB(link_post,dlg,head,Label)               [::msgcat::mc MC(link_post,dlg,head,Label)]
set gPB(link_post,dlg,post,Label)               [::msgcat::mc MC(link_post,dlg,post,Label)]

set gPB(link_post,dlg,title,Label)              [::msgcat::mc MC(link_post,dlg,title,Label)]

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
set gPB(nc_data,tab,Label)          [::msgcat::mc MC(nc_data,tab,Label)]

##-------
## BLOCK
##
set gPB(block,tab,Label)                        [::msgcat::mc MC(block,tab,Label)]
set gPB(block,Status)                           [::msgcat::mc MC(block,Status)]

set gPB(block,name,Label)                       [::msgcat::mc MC(block,name,Label)]
set gPB(block,name,Context)                     [::msgcat::mc MC(block,name,Context)]

set gPB(block,add,Label)            [::msgcat::mc MC(block,add,Label)]
set gPB(block,add,Context)          [::msgcat::mc MC(block,add,Context)]

set gPB(block,select,Label)         [::msgcat::mc MC(block,select,Label)]
set gPB(block,select,Context)           [::msgcat::mc MC(block,select,Context)]

set gPB(block,trash,Label)          [::msgcat::mc MC(block,trash,Label)]
set gPB(block,trash,Context)            [::msgcat::mc MC(block,trash,Context)]

set gPB(block,word,Label)           [::msgcat::mc MC(block,word,Label)]
set gPB(block,word,Context)         [::msgcat::mc MC(block,word,Context)]

set gPB(block,verify,Label)         [::msgcat::mc MC(block,verify,Label)]
set gPB(block,verify,Context)           [::msgcat::mc MC(block,verify,Context)]

set gPB(block,new_combo,Label)                  [::msgcat::mc MC(block,new_combo,Label)]
set gPB(block,text_combo,Label)                 [::msgcat::mc MC(block,text_combo,Label)]
set gPB(block,oper_combo,Label)                 [::msgcat::mc MC(block,oper_combo,Label)]
set gPB(block,comm_combo,Label)                 [::msgcat::mc MC(block,comm_combo,Label)]

set gPB(block,edit_popup,Label)                 [::msgcat::mc MC(block,edit_popup,Label)]
set gPB(block,view_popup,Label)                 [::msgcat::mc MC(block,view_popup,Label)]
set gPB(block,change_popup,Label)               [::msgcat::mc MC(block,change_popup,Label)]
set gPB(block,user_popup,Label)                 [::msgcat::mc MC(block,user_popup,Label)]
set gPB(block,opt_popup,Label)                  [::msgcat::mc MC(block,opt_popup,Label)]
set gPB(block,no_sep_popup,Label)               [::msgcat::mc MC(block,no_sep_popup,Label)]
set gPB(block,force_popup,Label)                [::msgcat::mc MC(block,force_popup,Label)]
set gPB(block,delete_popup,Label)               [::msgcat::mc MC(block,delete_popup,Label)]
set gPB(block,undo_popup,Label)                 [::msgcat::mc MC(block,undo_popup,Label)]
set gPB(block,delete_all,Label)                 [::msgcat::mc MC(block,delete_all,Label)]

set gPB(block,cmd_title,Label)                  [::msgcat::mc MC(block,cmd_title,Label)]
set gPB(block,oper_title,Label)                 [::msgcat::mc MC(block,oper_title,Label)]
set gPB(block,addr_title,Label)                 [::msgcat::mc MC(block,addr_title,Label)]

set gPB(block,new_trans,title,Label)            [::msgcat::mc MC(block,new_trans,title,Label)]

set gPB(block,new,word_desc,Label)              [::msgcat::mc MC(block,new,word_desc,Label)]
set gPB(block,oper,word_desc,Label)             [::msgcat::mc MC(block,oper,word_desc,Label)]
set gPB(block,cmd,word_desc,Label)              [::msgcat::mc MC(block,cmd,word_desc,Label)]
set gPB(block,user,word_desc,Label)             [::msgcat::mc MC(block,user,word_desc,Label)]
set gPB(block,text,word_desc,Label)             [::msgcat::mc MC(block,text,word_desc,Label)]

set gPB(block,user,expr,Label)              [::msgcat::mc MC(block,user,expr,Label)]

set gPB(block,msg,min_word)                     [::msgcat::mc MC(block,msg,min_word)]

set gPB(block,name_msg)                 [::msgcat::mc MC(block,name_msg)]

##---------
## ADDRESS
##
set gPB(address,tab,Label)          [::msgcat::mc MC(address,tab,Label)]
set gPB(address,Status)             [::msgcat::mc MC(address,Status)]

set gPB(address,name,Label)         [::msgcat::mc MC(address,name,Label)]
set gPB(address,name,Context)           [::msgcat::mc MC(address,name,Context)]

set gPB(address,verify,Label)           [::msgcat::mc MC(address,verify,Label)]
set gPB(address,verify,Context)         [::msgcat::mc MC(address,verify,Context)]

set gPB(address,leader,Label)           [::msgcat::mc MC(address,leader,Label)]
set gPB(address,leader,Context)         [::msgcat::mc MC(address,leader,Context)]

set gPB(address,format,Label)           [::msgcat::mc MC(address,format,Label)]
set gPB(address,format,edit,Label)      [::msgcat::mc MC(address,format,edit,Label)]
set gPB(address,format,edit,Context)        [::msgcat::mc MC(address,format,edit,Context)]
set gPB(address,format,new,Label)       [::msgcat::mc MC(address,format,new,Label)]
set gPB(address,format,new,Context)     [::msgcat::mc MC(address,format,new,Context)]

set gPB(address,format,select,Label)        [::msgcat::mc MC(address,format,select,Label)]
set gPB(address,format,select,Context)      [::msgcat::mc MC(address,format,select,Context)]

set gPB(address,trailer,Label)          [::msgcat::mc MC(address,trailer,Label)]
set gPB(address,trailer,Context)        [::msgcat::mc MC(address,trailer,Context)]

set gPB(address,modality,Label)         [::msgcat::mc MC(address,modality,Label)]
set gPB(address,modality,Context)       [::msgcat::mc MC(address,modality,Context)]

set gPB(address,modal_drop,off,Label)           [::msgcat::mc MC(address,modal_drop,off,Label)]
set gPB(address,modal_drop,once,Label)          [::msgcat::mc MC(address,modal_drop,once,Label)]
set gPB(address,modal_drop,always,Label)        [::msgcat::mc MC(address,modal_drop,always,Label)]

set gPB(address,max,value,Label)        [::msgcat::mc MC(address,max,value,Label)]
set gPB(address,max,value,Context)      [::msgcat::mc MC(address,max,value,Context)]

set gPB(address,value,text,Label)               [::msgcat::mc MC(address,value,text,Label)]

set gPB(address,trunc_drop,Label)               [::msgcat::mc MC(address,trunc_drop,Label)]
set gPB(address,warn_drop,Label)                [::msgcat::mc MC(address,warn_drop,Label)]
set gPB(address,abort_drop,Label)               [::msgcat::mc MC(address,abort_drop,Label)]

set gPB(address,max,error_handle,Label)     [::msgcat::mc MC(address,max,error_handle,Label)]
set gPB(address,max,error_handle,Context)   [::msgcat::mc MC(address,max,error_handle,Context)]

set gPB(address,min,value,Label)        [::msgcat::mc MC(address,min,value,Label)]
set gPB(address,min,value,Context)      [::msgcat::mc MC(address,min,value,Context)]

set gPB(address,min,error_handle,Label)     [::msgcat::mc MC(address,min,error_handle,Label)]
set gPB(address,min,error_handle,Context)   [::msgcat::mc MC(address,min,error_handle,Context)]

set gPB(address,format_trans,title,Label)       [::msgcat::mc MC(address,format_trans,title,Label)]
set gPB(address,none_popup,Label)               [::msgcat::mc MC(address,none_popup,Label)]

set gPB(address,exp,Label)          [::msgcat::mc MC(address,exp,Label)]
set gPB(address,exp,Context)            [::msgcat::mc MC(address,exp,Context)]
set gPB(address,exp,msg)            [::msgcat::mc MC(address,exp,msg)]
set gPB(address,exp,space_only)         [::msgcat::mc MC(address,exp,space_only)]

set gPB(address,exp,spec_char)          [::msgcat::mc MC(address,exp,spec_char)]

set gPB(address,exp,spec_char_msg)      [::msgcat::mc MC(address,exp,spec_char_msg)]

set gPB(address,name_msg)                       [::msgcat::mc MC(address,name_msg)]
set gPB(address,rapid_add_name_msg)         [::msgcat::mc MC(address,rapid_add_name_msg)]
set gPB(address,rapid1,desc)                    [::msgcat::mc MC(address,rapid1,desc)]
set gPB(address,rapid2,desc)                    [::msgcat::mc MC(address,rapid2,desc)]
set gPB(address,rapid3,desc)                    [::msgcat::mc MC(address,rapid3,desc)]

##--------
## FORMAT
##
set gPB(format,tab,Label)           [::msgcat::mc MC(format,tab,Label)]
set gPB(format,Status)              [::msgcat::mc MC(format,Status)]

set gPB(format,verify,Label)            [::msgcat::mc MC(format,verify,Label)]
set gPB(format,verify,Context)          [::msgcat::mc MC(format,verify,Context)]

set gPB(format,name,Label)          [::msgcat::mc MC(format,name,Label)]
set gPB(format,name,Context)            [::msgcat::mc MC(format,name,Context)]

set gPB(format,data,type,Label)         [::msgcat::mc MC(format,data,type,Label)]
set gPB(format,data,type,Context)       [::msgcat::mc MC(format,data,type,Context)]
set gPB(format,data,num,Label)          [::msgcat::mc MC(format,data,num,Label)]
set gPB(format,data,num,Context)        [::msgcat::mc MC(format,data,num,Context)]
set gPB(format,data,num,integer,Label)      [::msgcat::mc MC(format,data,num,integer,Label)]
set gPB(format,data,num,integer,Context)    [::msgcat::mc MC(format,data,num,integer,Context)]
set gPB(format,data,num,fraction,Label)     [::msgcat::mc MC(format,data,num,fraction,Label)]
set gPB(format,data,num,fraction,Context)   [::msgcat::mc MC(format,data,num,fraction,Context)]
set gPB(format,data,num,decimal,Label)      [::msgcat::mc MC(format,data,num,decimal,Label)]
set gPB(format,data,num,decimal,Context)    [::msgcat::mc MC(format,data,num,decimal,Context)]
set gPB(format,data,num,lead,Label)     [::msgcat::mc MC(format,data,num,lead,Label)]
set gPB(format,data,num,lead,Context)       [::msgcat::mc MC(format,data,num,lead,Context)]
set gPB(format,data,num,trail,Label)        [::msgcat::mc MC(format,data,num,trail,Label)]
set gPB(format,data,num,trail,Context)      [::msgcat::mc MC(format,data,num,trail,Context)]
set gPB(format,data,text,Label)         [::msgcat::mc MC(format,data,text,Label)]
set gPB(format,data,text,Context)       [::msgcat::mc MC(format,data,text,Context)]
set gPB(format,data,plus,Label)         [::msgcat::mc MC(format,data,plus,Label)]
set gPB(format,data,plus,Context)       [::msgcat::mc MC(format,data,plus,Context)]
set gPB(format,zero_msg)            [::msgcat::mc MC(format,zero_msg)]
set gPB(format,zero_cut_msg)            [::msgcat::mc MC(format,zero_cut_msg)]

set gPB(format,data,dec_zero,msg)               [::msgcat::mc MC(format,data,dec_zero,msg)]

set gPB(format,data,no_digit,msg)               [::msgcat::mc MC(format,data,no_digit,msg)]

set gPB(format,name_msg)            [::msgcat::mc MC(format,name_msg)]
set gPB(format,error,title)                     [::msgcat::mc MC(format,error,title)]
set gPB(format,error,msg)                       [::msgcat::mc MC(format,error,msg)]

##---------------------
## Other Data Elements
##
set gPB(other,tab,Label)            [::msgcat::mc MC(other,tab,Label)]
set gPB(other,Status)               [::msgcat::mc MC(other,Status)]

set gPB(other,seq_num,Label)            [::msgcat::mc MC(other,seq_num,Label)]
set gPB(other,seq_num,Context)          [::msgcat::mc MC(other,seq_num,Context)]
set gPB(other,seq_num,start,Label)      [::msgcat::mc MC(other,seq_num,start,Label)]
set gPB(other,seq_num,start,Context)        [::msgcat::mc MC(other,seq_num,start,Context)]
set gPB(other,seq_num,inc,Label)        [::msgcat::mc MC(other,seq_num,inc,Label)]
set gPB(other,seq_num,inc,Context)      [::msgcat::mc MC(other,seq_num,inc,Context)]
set gPB(other,seq_num,freq,Label)       [::msgcat::mc MC(other,seq_num,freq,Label)]
set gPB(other,seq_num,freq,Context)     [::msgcat::mc MC(other,seq_num,freq,Context)]
set gPB(other,seq_num,max,Label)                [::msgcat::mc MC(other,seq_num,max,Label)]
set gPB(other,seq_num,max,Context)              [::msgcat::mc MC(other,seq_num,max,Context)]

set gPB(other,chars,Label)          [::msgcat::mc MC(other,chars,Label)]
set gPB(other,chars,word_sep,Label)     [::msgcat::mc MC(other,chars,word_sep,Label)]
set gPB(other,chars,word_sep,Context)       [::msgcat::mc MC(other,chars,word_sep,Context)]
set gPB(other,chars,decimal_pt,Label)       [::msgcat::mc MC(other,chars,decimal_pt,Label)]
set gPB(other,chars,decimal_pt,Context)     [::msgcat::mc MC(other,chars,decimal_pt,Context)]
set gPB(other,chars,end_of_block,Label)     [::msgcat::mc MC(other,chars,end_of_block,Label)]
set gPB(other,chars,end_of_block,Context)   [::msgcat::mc MC(other,chars,end_of_block,Context)]
set gPB(other,chars,comment_start,Label)    [::msgcat::mc MC(other,chars,comment_start,Label)]
set gPB(other,chars,comment_start,Context)  [::msgcat::mc MC(other,chars,comment_start,Context)]
set gPB(other,chars,comment_end,Label)      [::msgcat::mc MC(other,chars,comment_end,Label)]
set gPB(other,chars,comment_end,Context)    [::msgcat::mc MC(other,chars,comment_end,Context)]

set gPB(other,opskip,Label)                     [::msgcat::mc MC(other,opskip,Label)]
set gPB(other,opskip,leader,Label)              [::msgcat::mc MC(other,opskip,leader,Label)]
set gPB(other,opskip,leader,Context)            [::msgcat::mc MC(other,opskip,leader,Context)]

set gPB(other,gm_codes,Label)           [::msgcat::mc MC(other,gm_codes,Label)]
set gPB(other,g_codes,Label)            [::msgcat::mc MC(other,g_codes,Label)]
set gPB(other,g_codes,Context)          [::msgcat::mc MC(other,g_codes,Context)]
set gPB(other,g_codes,num,Label)        [::msgcat::mc MC(other,g_codes,num,Label)]
set gPB(other,g_codes,num,Context)      [::msgcat::mc MC(other,g_codes,num,Context)]
set gPB(other,m_codes,Label)            [::msgcat::mc MC(other,m_codes,Label)]
set gPB(other,m_codes,Context)          [::msgcat::mc MC(other,m_codes,Context)]
set gPB(other,m_codes,num,Label)        [::msgcat::mc MC(other,m_codes,num,Label)]
set gPB(other,m_codes,num,Context)      [::msgcat::mc MC(other,m_codes,num,Context)]

set gPB(other,opt_none,Label)                   [::msgcat::mc MC(other,opt_none,Label)]
set gPB(other,opt_space,Label)                  [::msgcat::mc MC(other,opt_space,Label)]
set gPB(other,opt_dec,Label)                    [::msgcat::mc MC(other,opt_dec,Label)]
set gPB(other,opt_comma,Label)                  [::msgcat::mc MC(other,opt_comma,Label)]
set gPB(other,opt_semi,Label)                   [::msgcat::mc MC(other,opt_semi,Label)]
set gPB(other,opt_colon,Label)                  [::msgcat::mc MC(other,opt_colon,Label)]
set gPB(other,opt_text,Label)                   [::msgcat::mc MC(other,opt_text,Label)]
set gPB(other,opt_left,Label)                   [::msgcat::mc MC(other,opt_left,Label)]
set gPB(other,opt_right,Label)                  [::msgcat::mc MC(other,opt_right,Label)]
set gPB(other,opt_pound,Label)                  [::msgcat::mc MC(other,opt_pound,Label)]
set gPB(other,opt_aster,Label)                  [::msgcat::mc MC(other,opt_aster,Label)]
set gPB(other,opt_slash,Label)                  [::msgcat::mc MC(other,opt_slash,Label)]
set gPB(other,opt_new_line,Label)               [::msgcat::mc MC(other,opt_new_line,Label)]

# UDE Inclusion
set gPB(other,ude,Label)                        [::msgcat::mc MC(other,ude,Label)]
set gPB(other,ude_include,Label)                [::msgcat::mc MC(other,ude_include,Label)]
set gPB(other,ude_include,Context)              [::msgcat::mc MC(other,ude_include,Context)]
set gPB(other,ude_file,Label)                   [::msgcat::mc MC(other,ude_file,Label)]
set gPB(other,ude_file,Context)                 [::msgcat::mc MC(other,ude_file,Context)]
set gPB(other,ude_select,Label)                 [::msgcat::mc MC(other,ude_select,Label)]
set gPB(other,ude_select,Context)               [::msgcat::mc MC(other,ude_select,Context)]


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
set gPB(output,tab,Label)                       [::msgcat::mc MC(output,tab,Label)]
set gPB(output,Status)                          [::msgcat::mc MC(output,Status)]

#++++++++++++++
# VNC Controls
#++++++++++++++
set gPB(output,vnc,Label)                       [::msgcat::mc MC(output,vnc,Label)]
set gPB(output,vnc,mode,std,Label)              [::msgcat::mc MC(output,vnc,mode,std,Label)]
set gPB(output,vnc,mode,sub,Label)              [::msgcat::mc MC(output,vnc,mode,sub,Label)]
set gPB(output,vnc,status,Label)                [::msgcat::mc MC(output,vnc,status,Label)]
set gPB(output,vnc,mis_match,Label)             [::msgcat::mc MC(output,vnc,mis_match,Label)]
set gPB(output,vnc,output,Label)                [::msgcat::mc MC(output,vnc,output,Label)]
set gPB(output,vnc,output,Context)              [::msgcat::mc MC(output,vnc,output,Context)]
set gPB(output,vnc,main,Label)                  [::msgcat::mc MC(output,vnc,main,Label)]
set gPB(output,vnc,main,Context)                [::msgcat::mc MC(output,vnc,main,Context)]

set gPB(output,vnc,main,err_msg)                [::msgcat::mc MC(output,vnc,main,err_msg)]
set gPB(output,vnc,main,select_name,Label)      [::msgcat::mc MC(output,vnc,main,select_name,Label)]
set gPB(output,vnc,main,select_name,Context)    [::msgcat::mc MC(output,vnc,main,select_name,Context)]

set gPB(output,vnc,mode,Label)                  [::msgcat::mc MC(output,vnc,mode,Label)]
set gPB(output,vnc,mode,Context)                [::msgcat::mc MC(output,vnc,mode,Context)]
set gPB(output,vnc,mode,std,Context)            [::msgcat::mc MC(output,vnc,mode,std,Context)]
set gPB(output,vnc,mode,sub,Context)            [::msgcat::mc MC(output,vnc,mode,sub,Context)]
set gPB(output,vnc,pb_ver,msg)                  [::msgcat::mc MC(output,vnc,pb_ver,msg)]
#++++++++++++++
# Listing File
#++++++++++++++
set gPB(listing,tab,Label)              [::msgcat::mc MC(listing,tab,Label)]
set gPB(listing,Status)                 [::msgcat::mc MC(listing,Status)]

set gPB(listing,gen,Label)              [::msgcat::mc MC(listing,gen,Label)]
set gPB(listing,gen,Context)            [::msgcat::mc MC(listing,gen,Context)]

set gPB(listing,Label)                  [::msgcat::mc MC(listing,Label)]
set gPB(listing,parms,Label)            [::msgcat::mc MC(listing,parms,Label)]

set gPB(listing,parms,x,Label)          [::msgcat::mc MC(listing,parms,x,Label)]
set gPB(listing,parms,x,Context)        [::msgcat::mc MC(listing,parms,x,Context)]

set gPB(listing,parms,y,Label)          [::msgcat::mc MC(listing,parms,y,Label)]
set gPB(listing,parms,y,Context)        [::msgcat::mc MC(listing,parms,y,Context)]

set gPB(listing,parms,z,Label)          [::msgcat::mc MC(listing,parms,z,Label)]
set gPB(listing,parms,z,Context)        [::msgcat::mc MC(listing,parms,z,Context)]

set gPB(listing,parms,4,Label)          [::msgcat::mc MC(listing,parms,4,Label)]
set gPB(listing,parms,4,Context)        [::msgcat::mc MC(listing,parms,4,Context)]

set gPB(listing,parms,5,Label)          [::msgcat::mc MC(listing,parms,5,Label)]
set gPB(listing,parms,5,Context)        [::msgcat::mc MC(listing,parms,5,Context)]

set gPB(listing,parms,feed,Label)       [::msgcat::mc MC(listing,parms,feed,Label)]
set gPB(listing,parms,feed,Context)     [::msgcat::mc MC(listing,parms,feed,Context)]

set gPB(listing,parms,speed,Label)      [::msgcat::mc MC(listing,parms,speed,Label)]
set gPB(listing,parms,speed,Context)    [::msgcat::mc MC(listing,parms,speed,Context)]

set gPB(listing,extension,Label)        [::msgcat::mc MC(listing,extension,Label)]
set gPB(listing,extension,Context)      [::msgcat::mc MC(listing,extension,Context)]

set gPB(listing,nc_file,Label)          [::msgcat::mc MC(listing,nc_file,Label)]
set gPB(listing,nc_file,Context)        [::msgcat::mc MC(listing,nc_file,Context)]

set gPB(listing,header,Label)               [::msgcat::mc MC(listing,header,Label)]
set gPB(listing,header,oper_list,Label)     [::msgcat::mc MC(listing,header,oper_list,Label)]
set gPB(listing,header,tool_list,Label)     [::msgcat::mc MC(listing,header,tool_list,Label)]

set gPB(listing,footer,Label)               [::msgcat::mc MC(listing,footer,Label)]
set gPB(listing,footer,cut_time,Label)      [::msgcat::mc MC(listing,footer,cut_time,Label)]

set gPB(listing,format,Label)                   [::msgcat::mc MC(listing,format,Label)]
set gPB(listing,format,print_header,Label)      [::msgcat::mc MC(listing,format,print_header,Label)]
set gPB(listing,format,print_header,Context)    [::msgcat::mc MC(listing,format,print_header,Context)]

set gPB(listing,format,length,Label)        [::msgcat::mc MC(listing,format,length,Label)]
set gPB(listing,format,length,Context)      [::msgcat::mc MC(listing,format,length,Context)]
set gPB(listing,format,width,Label)         [::msgcat::mc MC(listing,format,width,Label)]
set gPB(listing,format,width,Context)       [::msgcat::mc MC(listing,format,width,Context)]

set gPB(listing,other,tab,Label)            [::msgcat::mc MC(listing,other,tab,Label)]
set gPB(listing,output,Label)               [::msgcat::mc MC(listing,output,Label)]

set gPB(listing,output,warning,Label)       [::msgcat::mc MC(listing,output,warning,Label)]
set gPB(listing,output,warning,Context)     [::msgcat::mc MC(listing,output,warning,Context)]

set gPB(listing,output,review,Label)        [::msgcat::mc MC(listing,output,review,Label)]
set gPB(listing,output,review,Context)      [::msgcat::mc MC(listing,output,review,Context)]

set gPB(listing,output,group,Label)             [::msgcat::mc MC(listing,output,group,Label)]
set gPB(listing,output,group,Context)           [::msgcat::mc MC(listing,output,group,Context)]

set gPB(listing,output,verbose,Label)           [::msgcat::mc MC(listing,output,verbose,Label)]
set gPB(listing,output,verbose,Context)         [::msgcat::mc MC(listing,output,verbose,Context)]

set gPB(listing,oper_info,Label)            [::msgcat::mc MC(listing,oper_info,Label)]
set gPB(listing,oper_info,parms,Label)      [::msgcat::mc MC(listing,oper_info,parms,Label)]
set gPB(listing,oper_info,tool,Label)       [::msgcat::mc MC(listing,oper_info,tool,Label)]
set gPB(listing,oper_info,cut_time,,Label)  [::msgcat::mc MC(listing,oper_info,cut_time,,Label)]


#<09-19-00 gsl>
set gPB(listing,user_tcl,frame,Label)           [::msgcat::mc MC(listing,user_tcl,frame,Label)]
set gPB(listing,user_tcl,check,Label)           [::msgcat::mc MC(listing,user_tcl,check,Label)]
set gPB(listing,user_tcl,check,Context)         [::msgcat::mc MC(listing,user_tcl,check,Context)]
set gPB(listing,user_tcl,name,Label)            [::msgcat::mc MC(listing,user_tcl,name,Label)]
set gPB(listing,user_tcl,name,Context)          [::msgcat::mc MC(listing,user_tcl,name,Context)]

#++++++++++++++++
# Output Preview
#++++++++++++++++
set gPB(preview,tab,Label)          [::msgcat::mc MC(preview,tab,Label)]
set gPB(preview,new_code,Label)                 [::msgcat::mc MC(preview,new_code,Label)]
set gPB(preview,old_code,Label)                 [::msgcat::mc MC(preview,old_code,Label)]

##---------------------
## Event Handler
##
set gPB(event_handler,tab,Label)        [::msgcat::mc MC(event_handler,tab,Label)]
set gPB(event_handler,Status)           [::msgcat::mc MC(event_handler,Status)]

##---------------------
## Definition
##
set gPB(definition,tab,Label)           [::msgcat::mc MC(definition,tab,Label)]
set gPB(definition,Status)          [::msgcat::mc MC(definition,Status)]

#++++++++++++++
# Post Advisor
#++++++++++++++
set gPB(advisor,tab,Label)          [::msgcat::mc MC(advisor,tab,Label)]
set gPB(advisor,Status)                         [::msgcat::mc MC(advisor,Status)]

set gPB(definition,word_txt,Label)              [::msgcat::mc MC(definition,word_txt,Label)]
set gPB(definition,end_txt,Label)               [::msgcat::mc MC(definition,end_txt,Label)]
set gPB(definition,seq_txt,Label)               [::msgcat::mc MC(definition,seq_txt,Label)]
set gPB(definition,include,Label)               [::msgcat::mc MC(definition,include,Label)]
set gPB(definition,format_txt,Label)            [::msgcat::mc MC(definition,format_txt,Label)]
set gPB(definition,addr_txt,Label)              [::msgcat::mc MC(definition,addr_txt,Label)]
set gPB(definition,block_txt,Label)             [::msgcat::mc MC(definition,block_txt,Label)]
set gPB(definition,comp_txt,Label)              [::msgcat::mc MC(definition,comp_txt,Label)]
set gPB(definition,post_txt,Label)              [::msgcat::mc MC(definition,post_txt,Label)]
set gPB(definition,oper_txt,Label)              [::msgcat::mc MC(definition,oper_txt,Label)]

#+++++++++++++
# Balloon
#+++++++++++++
set gPB(msg,odd)                                [::msgcat::mc MC(msg,odd)]
set gPB(msg,wrong_list_1)                       [::msgcat::mc MC(msg,wrong_list_1)]
set gPB(msg,wrong_list_2)                       [::msgcat::mc MC(msg,wrong_list_2)]

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

###
set gPB(event,start_prog,name)                  [::msgcat::mc  MC(event,start_prog,name)]

###
set gPB(event,opr_start,start_path,name)        [::msgcat::mc  MC(event,opr_start,start_path,name)]
set gPB(event,opr_start,from_move,name)         [::msgcat::mc  MC(event,opr_start,from_move,name)]
set gPB(event,opr_start,fst_tool,name)          [::msgcat::mc  MC(event,opr_start,fst_tool,name)]
set gPB(event,opr_start,auto_tc,name)           [::msgcat::mc  MC(event,opr_start,auto_tc,name)]
set gPB(event,opr_start,manual_tc,name)         [::msgcat::mc  MC(event,opr_start,manual_tc,name)]
set gPB(event,opr_start,init_move,name)         [::msgcat::mc  MC(event,opr_start,init_move,name)]
set gPB(event,opr_start,fst_move,name)          [::msgcat::mc  MC(event,opr_start,fst_move,name)]
set gPB(event,opr_start,appro_move,name)        [::msgcat::mc  MC(event,opr_start,appro_move,name)]
set gPB(event,opr_start,engage_move,name)       [::msgcat::mc  MC(event,opr_start,engage_move,name)]
set gPB(event,opr_start,fst_cut,name)           [::msgcat::mc  MC(event,opr_start,fst_cut,name)]
set gPB(event,opr_start,fst_lin_move,name)      [::msgcat::mc  MC(event,opr_start,fst_lin_move,name)]
set gPB(event,opr_start,start_pass,name)        [::msgcat::mc  MC(event,opr_start,start_pass,name)]
set gPB(event,opr_start,cutcom_move,name)       [::msgcat::mc  MC(event,opr_start,cutcom_move,name)]
set gPB(event,opr_start,lead_move,name)         [::msgcat::mc  MC(event,opr_start,lead_move,name)]

###
set gPB(event,opr_end,ret_move,name)            [::msgcat::mc  MC(event,opr_end,ret_move,name)]
set gPB(event,opr_end,rtn_move,name)            [::msgcat::mc  MC(event,opr_end,rtn_move,name)]
set gPB(event,opr_end,goh_move,name)            [::msgcat::mc  MC(event,opr_end,goh_move,name)]
set gPB(event,opr_end,end_path,name)            [::msgcat::mc  MC(event,opr_end,end_path,name)]
set gPB(event,opr_end,lead_move,name)           [::msgcat::mc  MC(event,opr_end,lead_move,name)]
set gPB(event,opr_end,end_pass,name)            [::msgcat::mc  MC(event,opr_end,end_pass,name)]

###
set gPB(event,end_prog,name)                    [::msgcat::mc  MC(event,end_prog,name)]

### Tool Change
set gPB(event,tool_change,name)         [::msgcat::mc MC(event,tool_change,name)]
set gPB(event,tool_change,m_code)       [::msgcat::mc MC(event,tool_change,m_code)]
set gPB(event,tool_change,m_code,tl_chng)   [::msgcat::mc MC(event,tool_change,m_code,tl_chng)]
set gPB(event,tool_change,m_code,pt)            [::msgcat::mc MC(event,tool_change,m_code,pt)]
set gPB(event,tool_change,m_code,st)            [::msgcat::mc MC(event,tool_change,m_code,st)]
set gPB(event,tool_change,t_code)       [::msgcat::mc MC(event,tool_change,t_code)]
set gPB(event,tool_change,t_code,conf)      [::msgcat::mc MC(event,tool_change,t_code,conf)]
set gPB(event,tool_change,t_code,pt_idx)    [::msgcat::mc MC(event,tool_change,t_code,pt_idx)]
set gPB(event,tool_change,t_code,st_idx)    [::msgcat::mc MC(event,tool_change,t_code,st_idx)]
set gPB(event,tool_change,tool_num)     [::msgcat::mc MC(event,tool_change,tool_num)]
set gPB(event,tool_change,tool_num,min)     [::msgcat::mc MC(event,tool_change,tool_num,min)]
set gPB(event,tool_change,tool_num,max)     [::msgcat::mc MC(event,tool_change,tool_num,max)]
set gPB(event,tool_change,time)         [::msgcat::mc MC(event,tool_change,time)]
set gPB(event,tool_change,time,tl_chng)     [::msgcat::mc MC(event,tool_change,time,tl_chng)]
set gPB(event,tool_change,retract)      [::msgcat::mc MC(event,tool_change,retract)]
set gPB(event,tool_change,retract_z)        [::msgcat::mc MC(event,tool_change,retract_z)]

### Length Compensation
set gPB(event,length_compn,name)            [::msgcat::mc MC(event,length_compn,name)]
set gPB(event,length_compn,g_code)          [::msgcat::mc MC(event,length_compn,g_code)]
set gPB(event,length_compn,g_code,len_adj)  [::msgcat::mc MC(event,length_compn,g_code,len_adj)]
set gPB(event,length_compn,t_code)          [::msgcat::mc MC(event,length_compn,t_code)]
set gPB(event,length_compn,t_code,conf)     [::msgcat::mc MC(event,length_compn,t_code,conf)]
set gPB(event,length_compn,len_off)         [::msgcat::mc MC(event,length_compn,len_off)]
set gPB(event,length_compn,len_off,min)     [::msgcat::mc MC(event,length_compn,len_off,min)]
set gPB(event,length_compn,len_off,max)     [::msgcat::mc MC(event,length_compn,len_off,max)]

### Set Modes
set gPB(event,set_modes,name)               [::msgcat::mc MC(event,set_modes,name)]
set gPB(event,set_modes,out_mode)           [::msgcat::mc MC(event,set_modes,out_mode)]
set gPB(event,set_modes,g_code)             [::msgcat::mc MC(event,set_modes,g_code)]
set gPB(event,set_modes,g_code,absolute)    [::msgcat::mc MC(event,set_modes,g_code,absolute)]
set gPB(event,set_modes,g_code,incremental) [::msgcat::mc MC(event,set_modes,g_code,incremental)]
set gPB(event,set_modes,rotary_axis)        [::msgcat::mc MC(event,set_modes,rotary_axis)]

### Spindle RPM
set gPB(event,spindle_rpm,name)                         [::msgcat::mc MC(event,spindle_rpm,name)]
set gPB(event,spindle_rpm,dir_m_code)                   [::msgcat::mc MC(event,spindle_rpm,dir_m_code)]
set gPB(event,spindle_rpm,dir_m_code,cw)                [::msgcat::mc MC(event,spindle_rpm,dir_m_code,cw)]
set gPB(event,spindle_rpm,dir_m_code,ccw)               [::msgcat::mc MC(event,spindle_rpm,dir_m_code,ccw)]
set gPB(event,spindle_rpm,range_control)                [::msgcat::mc MC(event,spindle_rpm,range_control)]
set gPB(event,spindle_rpm,range_control,dwell_time)     [::msgcat::mc MC(event,spindle_rpm,range_control,dwell_time)]
set gPB(event,spindle_rpm,range_control,range_code)     [::msgcat::mc MC(event,spindle_rpm,range_control,range_code)]

### Spindle CSS
set gPB(event,spindle_css,name)                         [::msgcat::mc MC(event,spindle_css,name)]
set gPB(event,spindle_css,g_code)                       [::msgcat::mc MC(event,spindle_css,g_code)]
set gPB(event,spindle_css,g_code,const)                 [::msgcat::mc MC(event,spindle_css,g_code,const)]
set gPB(event,spindle_css,g_code,max)                   [::msgcat::mc MC(event,spindle_css,g_code,max)]
set gPB(event,spindle_css,g_code,sfm)                   [::msgcat::mc MC(event,spindle_css,g_code,sfm)]
set gPB(event,spindle_css,max)                          [::msgcat::mc MC(event,spindle_css,max)]
set gPB(event,spindle_css,sfm)                          [::msgcat::mc MC(event,spindle_css,sfm)]

### Spindle Off
set gPB(event,spindle_off,name)                 [::msgcat::mc MC(event,spindle_off,name)]
set gPB(event,spindle_off,dir_m_code)           [::msgcat::mc MC(event,spindle_off,dir_m_code)]
set gPB(event,spindle_off,dir_m_code,off)       [::msgcat::mc MC(event,spindle_off,dir_m_code,off)]

### Coolant On
set gPB(event,coolant_on,name)                  [::msgcat::mc MC(event,coolant_on,name)]
set gPB(event,coolant_on,m_code)                [::msgcat::mc MC(event,coolant_on,m_code)]
set gPB(event,coolant_on,m_code,on)             [::msgcat::mc MC(event,coolant_on,m_code,on)]
set gPB(event,coolant_on,m_code,flood)          [::msgcat::mc MC(event,coolant_on,m_code,flood)]
set gPB(event,coolant_on,m_code,mist)           [::msgcat::mc MC(event,coolant_on,m_code,mist)]
set gPB(event,coolant_on,m_code,thru)           [::msgcat::mc MC(event,coolant_on,m_code,thru)]
set gPB(event,coolant_on,m_code,tap)            [::msgcat::mc MC(event,coolant_on,m_code,tap)]

### Coolant Off
set gPB(event,coolant_off,name)                 [::msgcat::mc MC(event,coolant_off,name)]
set gPB(event,coolant_off,m_code)               [::msgcat::mc MC(event,coolant_off,m_code)]
set gPB(event,coolant_off,m_code,off)           [::msgcat::mc MC(event,coolant_off,m_code,off)]

### Inch Metric Mode
set gPB(event,inch_metric_mode,name)                [::msgcat::mc MC(event,inch_metric_mode,name)]
set gPB(event,inch_metric_mode,g_code)              [::msgcat::mc MC(event,inch_metric_mode,g_code)]
set gPB(event,inch_metric_mode,g_code,english)      [::msgcat::mc MC(event,inch_metric_mode,g_code,english)]
set gPB(event,inch_metric_mode,g_code,metric)       [::msgcat::mc MC(event,inch_metric_mode,g_code,metric)]

### Feedrates
set gPB(event,feedrates,name)                           [::msgcat::mc MC(event,feedrates,name)]
set gPB(event,feedrates,ipm_mode)                       [::msgcat::mc MC(event,feedrates,ipm_mode)]
set gPB(event,feedrates,ipr_mode)                       [::msgcat::mc MC(event,feedrates,ipr_mode)]
set gPB(event,feedrates,dpm_mode)                       [::msgcat::mc MC(event,feedrates,dpm_mode)]
set gPB(event,feedrates,mmpm_mode)                      [::msgcat::mc MC(event,feedrates,mmpm_mode)]
set gPB(event,feedrates,mmpr_mode)                      [::msgcat::mc MC(event,feedrates,mmpr_mode)]
set gPB(event,feedrates,frn_mode)                       [::msgcat::mc MC(event,feedrates,frn_mode)]
set gPB(event,feedrates,g_code)                         [::msgcat::mc MC(event,feedrates,g_code)]
set gPB(event,feedrates,format)                         [::msgcat::mc MC(event,feedrates,format)]
set gPB(event,feedrates,max)                            [::msgcat::mc MC(event,feedrates,max)]
set gPB(event,feedrates,min)                            [::msgcat::mc MC(event,feedrates,min)]
set gPB(event,feedrates,mode,label)                     [::msgcat::mc MC(event,feedrates,mode,label)]
set gPB(event,feedrates,mode,lin)                       [::msgcat::mc MC(event,feedrates,mode,lin)]
set gPB(event,feedrates,mode,rot)                       [::msgcat::mc MC(event,feedrates,mode,rot)]
set gPB(event,feedrates,mode,lin_rot)                   [::msgcat::mc MC(event,feedrates,mode,lin_rot)]
set gPB(event,feedrates,mode,rap_lin)                   [::msgcat::mc MC(event,feedrates,mode,rap_lin)]
set gPB(event,feedrates,mode,rap_rot)                   [::msgcat::mc MC(event,feedrates,mode,rap_rot)]
set gPB(event,feedrates,mode,rap_lin_rot)               [::msgcat::mc MC(event,feedrates,mode,rap_lin_rot)]
set gPB(event,feedrates,cycle_mode)                     [::msgcat::mc MC(event,feedrates,cycle_mode)]
set gPB(event,feedrates,cycle)                          [::msgcat::mc MC(event,feedrates,cycle)]

### Cutcom On
set gPB(event,cutcom_on,name)                           [::msgcat::mc MC(event,cutcom_on,name)]
set gPB(event,cutcom_on,g_code)                         [::msgcat::mc MC(event,cutcom_on,g_code)]
set gPB(event,cutcom_on,left)                           [::msgcat::mc MC(event,cutcom_on,left)]
set gPB(event,cutcom_on,right)                          [::msgcat::mc MC(event,cutcom_on,right)]
set gPB(event,cutcom_on,app_planes)                     [::msgcat::mc MC(event,cutcom_on,app_planes)]
set gPB(event,cutcom_on,edit_planes)                    [::msgcat::mc MC(event,cutcom_on,edit_planes)]
set gPB(event,cutcom_on,reg)                            [::msgcat::mc MC(event,cutcom_on,reg)]
set gPB(event,cutcom_on,min)                            [::msgcat::mc MC(event,cutcom_on,min)]
set gPB(event,cutcom_on,max)                            [::msgcat::mc MC(event,cutcom_on,max)]
set gPB(event,cutcom_on,bef)                            [::msgcat::mc MC(event,cutcom_on,bef)]

### Cutcom Off
set gPB(event,cutcom_off,name)                          [::msgcat::mc MC(event,cutcom_off,name)]
set gPB(event,cutcom_off,g_code)                        [::msgcat::mc MC(event,cutcom_off,g_code)]
set gPB(event,cutcom_off,off)                           [::msgcat::mc MC(event,cutcom_off,off)]

### Delay
set gPB(event,delay,name)                               [::msgcat::mc MC(event,delay,name)]
set gPB(event,delay,seconds)                            [::msgcat::mc MC(event,delay,seconds)]
set gPB(event,delay,seconds,g_code)                     [::msgcat::mc MC(event,delay,seconds,g_code)]
set gPB(event,delay,seconds,format)                     [::msgcat::mc MC(event,delay,seconds,format)]
set gPB(event,delay,out_mode)                           [::msgcat::mc MC(event,delay,out_mode)]
set gPB(event,delay,out_mode,sec)                       [::msgcat::mc MC(event,delay,out_mode,sec)]
set gPB(event,delay,out_mode,rev)                       [::msgcat::mc MC(event,delay,out_mode,rev)]
set gPB(event,delay,out_mode,feed)                      [::msgcat::mc MC(event,delay,out_mode,feed)]
set gPB(event,delay,out_mode,ivs)                       [::msgcat::mc MC(event,delay,out_mode,ivs)]
set gPB(event,delay,revolution)                         [::msgcat::mc MC(event,delay,revolution)]
set gPB(event,delay,revolution,g_code)                  [::msgcat::mc MC(event,delay,revolution,g_code)]
set gPB(event,delay,revolution,format)                  [::msgcat::mc MC(event,delay,revolution,format)]

### Option Stop
set gPB(event,opstop,name)                              [::msgcat::mc MC(event,opstop,name)]

### Auxfun
set gPB(event,auxfun,name)                              [::msgcat::mc MC(event,auxfun,name)]

### Prefun
set gPB(event,prefun,name)                              [::msgcat::mc MC(event,prefun,name)]

### Load Tool
set gPB(event,loadtool,name)                            [::msgcat::mc MC(event,loadtool,name)]

### Stop
set gPB(event,stop,name)                                [::msgcat::mc MC(event,stop,name)]

### Tool Preselect
set gPB(event,toolpreselect,name)                       [::msgcat::mc MC(event,toolpreselect,name)]

### Thread Wire
set gPB(event,threadwire,name)                          [::msgcat::mc MC(event,threadwire,name)]

### Cut Wire
set gPB(event,cutwire,name)                             [::msgcat::mc MC(event,cutwire,name)]

### Wire Guides
set gPB(event,wireguides,name)                          [::msgcat::mc MC(event,wireguides,name)]

### Linear Move
set gPB(event,linear,name)                              [::msgcat::mc MC(event,linear,name)]
set gPB(event,linear,g_code)                            [::msgcat::mc MC(event,linear,g_code)]
set gPB(event,linear,motion)                            [::msgcat::mc MC(event,linear,motion)]
set gPB(event,linear,assume)                            [::msgcat::mc MC(event,linear,assume)]

### Circular Move
set gPB(event,circular,name)                            [::msgcat::mc MC(event,circular,name)]
set gPB(event,circular,g_code)                          [::msgcat::mc MC(event,circular,g_code)]
set gPB(event,circular,clockwise)                       [::msgcat::mc MC(event,circular,clockwise)]
set gPB(event,circular,counter-clock)                   [::msgcat::mc MC(event,circular,counter-clock)]
set gPB(event,circular,record)                          [::msgcat::mc MC(event,circular,record)]
set gPB(event,circular,full_circle)                     [::msgcat::mc MC(event,circular,full_circle)]
set gPB(event,circular,quadrant)                        [::msgcat::mc MC(event,circular,quadrant)]
set gPB(event,circular,ijk_def)                         [::msgcat::mc MC(event,circular,ijk_def)]
set gPB(event,circular,ij_def)                          [::msgcat::mc MC(event,circular,ij_def)]
set gPB(event,circular,ik_def)                          [::msgcat::mc MC(event,circular,ik_def)]
set gPB(event,circular,planes)                          [::msgcat::mc MC(event,circular,planes)]
set gPB(event,circular,edit_planes)                     [::msgcat::mc MC(event,circular,edit_planes)]
set gPB(event,circular,radius)                          [::msgcat::mc MC(event,circular,radius)]
set gPB(event,circular,min)                             [::msgcat::mc MC(event,circular,min)]
set gPB(event,circular,max)                             [::msgcat::mc MC(event,circular,max)]
set gPB(event,circular,arc_len)                         [::msgcat::mc MC(event,circular,arc_len)]



### Rapid Move
set gPB(event,rapid,name)                               [::msgcat::mc MC(event,rapid,name)]
set gPB(event,rapid,g_code)                             [::msgcat::mc MC(event,rapid,g_code)]
set gPB(event,rapid,motion)                             [::msgcat::mc MC(event,rapid,motion)]
set gPB(event,rapid,plane_change)                       [::msgcat::mc MC(event,rapid,plane_change)]

### Lathe Thread
set gPB(event,lathe,name)                               [::msgcat::mc MC(event,lathe,name)]
set gPB(event,lathe,g_code)                             [::msgcat::mc MC(event,lathe,g_code)]
set gPB(event,lathe,cons)                               [::msgcat::mc MC(event,lathe,cons)]
set gPB(event,lathe,incr)                               [::msgcat::mc MC(event,lathe,incr)]
set gPB(event,lathe,decr)                               [::msgcat::mc MC(event,lathe,decr)]

### Cycle
set gPB(event,cycle,g_code)                        [::msgcat::mc MC(event,cycle,g_code)]
set gPB(event,cycle,customize,Label)               [::msgcat::mc MC(event,cycle,customize,Label)]
set gPB(event,cycle,customize,Context)             [::msgcat::mc MC(event,cycle,customize,Context)]
set gPB(event,cycle,start,Label)                   [::msgcat::mc MC(event,cycle,start,Label)]
set gPB(event,cycle,start,Context)                 [::msgcat::mc MC(event,cycle,start,Context)]
set gPB(event,cycle,start,text)                    [::msgcat::mc MC(event,cycle,start,text)]
set gPB(event,cycle,rapid_to)                      [::msgcat::mc MC(event,cycle,rapid_to)]
set gPB(event,cycle,retract_to)                    [::msgcat::mc MC(event,cycle,retract_to)]
set gPB(event,cycle,plane_control)                 [::msgcat::mc MC(event,cycle,plane_control)]
set gPB(event,cycle,com_param,name)                [::msgcat::mc MC(event,cycle,com_param,name)]
set gPB(event,cycle,cycle_off,name)                [::msgcat::mc MC(event,cycle,cycle_off,name)]
set gPB(event,cycle,plane_chng,name)               [::msgcat::mc MC(event,cycle,plane_chng,name)]
set gPB(event,cycle,drill,name)                    [::msgcat::mc MC(event,cycle,drill,name)]
set gPB(event,cycle,drill_dwell,name)              [::msgcat::mc MC(event,cycle,drill_dwell,name)]
set gPB(event,cycle,drill_text,name)               [::msgcat::mc MC(event,cycle,drill_text,name)]
set gPB(event,cycle,drill_csink,name)              [::msgcat::mc MC(event,cycle,drill_csink,name)]
set gPB(event,cycle,drill_deep,name)               [::msgcat::mc MC(event,cycle,drill_deep,name)]
set gPB(event,cycle,drill_brk_chip,name)           [::msgcat::mc MC(event,cycle,drill_brk_chip,name)]
set gPB(event,cycle,tap,name)                      [::msgcat::mc MC(event,cycle,tap,name)]
set gPB(event,cycle,bore,name)                     [::msgcat::mc MC(event,cycle,bore,name)]
set gPB(event,cycle,bore_dwell,name)               [::msgcat::mc MC(event,cycle,bore_dwell,name)]
set gPB(event,cycle,bore_drag,name)                [::msgcat::mc MC(event,cycle,bore_drag,name)]
set gPB(event,cycle,bore_no_drag,name)             [::msgcat::mc MC(event,cycle,bore_no_drag,name)]
set gPB(event,cycle,bore_back,name)                [::msgcat::mc MC(event,cycle,bore_back,name)]
set gPB(event,cycle,bore_manual,name)              [::msgcat::mc MC(event,cycle,bore_manual,name)]
set gPB(event,cycle,bore_manual_dwell,name)        [::msgcat::mc MC(event,cycle,bore_manual_dwell,name)]
set gPB(event,cycle,peck_drill,name)               [::msgcat::mc MC(event,cycle,peck_drill,name)]
set gPB(event,cycle,break_chip,name)               [::msgcat::mc MC(event,cycle,break_chip,name)]
set gPB(event,cycle,drill_dwell_sf,name)           [::msgcat::mc MC(event,cycle,drill_dwell_sf,name)]
set gPB(event,cycle,drill_deep_peck,name)          [::msgcat::mc MC(event,cycle,drill_deep_peck,name)]
set gPB(event,cycle,bore_ream,name)                [::msgcat::mc MC(event,cycle,bore_ream,name)]
set gPB(event,cycle,bore_no-drag,name)             [::msgcat::mc MC(event,cycle,bore_no-drag,name)]

###--------
### G Code
###
set gPB(g_code,rapid,name)                     [::msgcat::mc MC(g_code,rapid,name)]
set gPB(g_code,linear,name)                    [::msgcat::mc MC(g_code,linear,name)]
set gPB(g_code,circular_clw,name)              [::msgcat::mc MC(g_code,circular_clw,name)]
set gPB(g_code,circular_cclw,name)             [::msgcat::mc MC(g_code,circular_cclw,name)]
set gPB(g_code,delay_sec,name)                 [::msgcat::mc MC(g_code,delay_sec,name)]
set gPB(g_code,delay_rev,name)                 [::msgcat::mc MC(g_code,delay_rev,name)]
set gPB(g_code,pln_xy,name)                    [::msgcat::mc MC(g_code,pln_xy,name)]
set gPB(g_code,pln_zx,name)                    [::msgcat::mc MC(g_code,pln_zx,name)]
set gPB(g_code,pln_yz,name)                    [::msgcat::mc MC(g_code,pln_yz,name)]
set gPB(g_code,cutcom_off,name)                [::msgcat::mc MC(g_code,cutcom_off,name)]
set gPB(g_code,cutcom_left,name)               [::msgcat::mc MC(g_code,cutcom_left,name)]
set gPB(g_code,cutcom_right,name)              [::msgcat::mc MC(g_code,cutcom_right,name)]
set gPB(g_code,length_plus,name)               [::msgcat::mc MC(g_code,length_plus,name)]
set gPB(g_code,length_minus,name)              [::msgcat::mc MC(g_code,length_minus,name)]
set gPB(g_code,length_off,name)                [::msgcat::mc MC(g_code,length_off,name)]
set gPB(g_code,inch,name)                      [::msgcat::mc MC(g_code,inch,name)]
set gPB(g_code,metric,name)                    [::msgcat::mc MC(g_code,metric,name)]
set gPB(g_code,cycle_start,name)               [::msgcat::mc MC(g_code,cycle_start,name)]
set gPB(g_code,cycle_off,name)                 [::msgcat::mc MC(g_code,cycle_off,name)]
set gPB(g_code,cycle_drill,name)               [::msgcat::mc MC(g_code,cycle_drill,name)]
set gPB(g_code,cycle_drill_dwell,name)         [::msgcat::mc MC(g_code,cycle_drill_dwell,name)]
set gPB(g_code,cycle_drill_deep,name)          [::msgcat::mc MC(g_code,cycle_drill_deep,name)]
set gPB(g_code,cycle_drill_bc,name)            [::msgcat::mc MC(g_code,cycle_drill_bc,name)]
set gPB(g_code,tap,name)                       [::msgcat::mc MC(g_code,tap,name)]
set gPB(g_code,bore,name)                      [::msgcat::mc MC(g_code,bore,name)]
set gPB(g_code,bore_drag,name)                 [::msgcat::mc MC(g_code,bore_drag,name)]
set gPB(g_code,bore_no_drag,name)              [::msgcat::mc MC(g_code,bore_no_drag,name)]
set gPB(g_code,bore_dwell,name)                [::msgcat::mc MC(g_code,bore_dwell,name)]
set gPB(g_code,bore_manual,name)               [::msgcat::mc MC(g_code,bore_manual,name)]
set gPB(g_code,bore_back,name)                 [::msgcat::mc MC(g_code,bore_back,name)]
set gPB(g_code,bore_manual_dwell,name)         [::msgcat::mc MC(g_code,bore_manual_dwell,name)]
set gPB(g_code,abs,name)                       [::msgcat::mc MC(g_code,abs,name)]
set gPB(g_code,inc,name)                       [::msgcat::mc MC(g_code,inc,name)]
set gPB(g_code,cycle_retract_auto,name)        [::msgcat::mc MC(g_code,cycle_retract_auto,name)]
set gPB(g_code,cycle_retract_manual,name)      [::msgcat::mc MC(g_code,cycle_retract_manual,name)]
set gPB(g_code,reset,name)                     [::msgcat::mc MC(g_code,reset,name)]
set gPB(g_code,fr_ipm,name)                    [::msgcat::mc MC(g_code,fr_ipm,name)]
set gPB(g_code,fr_ipr,name)                    [::msgcat::mc MC(g_code,fr_ipr,name)]
set gPB(g_code,fr_frn,name)                    [::msgcat::mc MC(g_code,fr_frn,name)]
set gPB(g_code,spindle_css,name)               [::msgcat::mc MC(g_code,spindle_css,name)]
set gPB(g_code,spindle_rpm,name)               [::msgcat::mc MC(g_code,spindle_rpm,name)]
set gPB(g_code,ret_home,name)                  [::msgcat::mc MC(g_code,ret_home,name)]
set gPB(g_code,cons_thread,name)               [::msgcat::mc MC(g_code,cons_thread,name)]
set gPB(g_code,incr_thread,name)               [::msgcat::mc MC(g_code,incr_thread,name)]
set gPB(g_code,decr_thread,name)               [::msgcat::mc MC(g_code,decr_thread,name)]
set gPB(g_code,feedmode_in,pm)                 [::msgcat::mc MC(g_code,feedmode_in,pm)]
set gPB(g_code,feedmode_in,pr)                 [::msgcat::mc MC(g_code,feedmode_in,pr)]
set gPB(g_code,feedmode_mm,pm)                 [::msgcat::mc MC(g_code,feedmode_mm,pm)]
set gPB(g_code,feedmode_mm,pr)                 [::msgcat::mc MC(g_code,feedmode_mm,pr)]

###--------
### M Code
###
set gPB(m_code,stop_manual_tc,name)                     [::msgcat::mc MC(m_code,stop_manual_tc,name)]
set gPB(m_code,stop,name)                               [::msgcat::mc MC(m_code,stop,name)]
set gPB(m_code,opt_stop,name)                           [::msgcat::mc MC(m_code,opt_stop,name)]
set gPB(m_code,prog_end,name)                           [::msgcat::mc MC(m_code,prog_end,name)]
set gPB(m_code,spindle_clw,name)                        [::msgcat::mc MC(m_code,spindle_clw,name)]
set gPB(m_code,spindle_cclw,name)                       [::msgcat::mc MC(m_code,spindle_cclw,name)]
set gPB(m_code,lathe_thread,type1)                      [::msgcat::mc MC(m_code,lathe_thread,type1)]
set gPB(m_code,lathe_thread,type2)                      [::msgcat::mc MC(m_code,lathe_thread,type2)]
set gPB(m_code,lathe_thread,type3)                      [::msgcat::mc MC(m_code,lathe_thread,type3)]
set gPB(m_code,spindle_off,name)                        [::msgcat::mc MC(m_code,spindle_off,name)]
set gPB(m_code,tc_retract,name)                         [::msgcat::mc MC(m_code,tc_retract,name)]
set gPB(m_code,coolant_on,name)                         [::msgcat::mc MC(m_code,coolant_on,name)]
set gPB(m_code,coolant_fld,name)                        [::msgcat::mc MC(m_code,coolant_fld,name)]
set gPB(m_code,coolant_mist,name)                       [::msgcat::mc MC(m_code,coolant_mist,name)]
set gPB(m_code,coolant_thru,name)                       [::msgcat::mc MC(m_code,coolant_thru,name)]
set gPB(m_code,coolant_tap,name)                        [::msgcat::mc MC(m_code,coolant_tap,name)]
set gPB(m_code,coolant_off,name)                        [::msgcat::mc MC(m_code,coolant_off,name)]
set gPB(m_code,rewind,name)                             [::msgcat::mc MC(m_code,rewind,name)]
set gPB(m_code,thread_wire,name)                        [::msgcat::mc MC(m_code,thread_wire,name)]
set gPB(m_code,cut_wire,name)                           [::msgcat::mc MC(m_code,cut_wire,name)]
set gPB(m_code,fls_on,name)                             [::msgcat::mc MC(m_code,fls_on,name)]
set gPB(m_code,fls_off,name)                            [::msgcat::mc MC(m_code,fls_off,name)]
set gPB(m_code,power_on,name)                           [::msgcat::mc MC(m_code,power_on,name)]
set gPB(m_code,power_off,name)                          [::msgcat::mc MC(m_code,power_off,name)]
set gPB(m_code,wire_on,name)                            [::msgcat::mc MC(m_code,wire_on,name)]
set gPB(m_code,wire_off,name)                           [::msgcat::mc MC(m_code,wire_off,name)]
set gPB(m_code,pri_turret,name)                         [::msgcat::mc MC(m_code,pri_turret,name)]
set gPB(m_code,sec_turret,name)                         [::msgcat::mc MC(m_code,sec_turret,name)]

### UDE <10-10-05 peter>
set gPB(ude,editor,enable,Label)                        [::msgcat::mc MC(ude,editor,enable,Label)]
set gPB(ude,editor,TITLE)                               [::msgcat::mc MC(ude,editor,TITLE)]

set gPB(ude,editor,no_ude)                              [::msgcat::mc MC(ude,editor,no_ude)]

set gPB(ude,editor,int,Label)                           [::msgcat::mc MC(ude,editor,int,Label)]
set gPB(ude,editor,int,Context)                         [::msgcat::mc MC(ude,editor,int,Context)]

set gPB(ude,editor,real,Label)                          [::msgcat::mc MC(ude,editor,real,Label)]
set gPB(ude,editor,real,Context)                        [::msgcat::mc MC(ude,editor,real,Context)]

set gPB(ude,editor,txt,Label)                           [::msgcat::mc MC(ude,editor,txt,Label)]
set gPB(ude,editor,txt,Context)                         [::msgcat::mc MC(ude,editor,txt,Context)]

set gPB(ude,editor,bln,Label)                           [::msgcat::mc MC(ude,editor,bln,Label)]
set gPB(ude,editor,bln,Context)                         [::msgcat::mc MC(ude,editor,bln,Context)]

set gPB(ude,editor,opt,Label)                           [::msgcat::mc MC(ude,editor,opt,Label)]
set gPB(ude,editor,opt,Context)                         [::msgcat::mc MC(ude,editor,opt,Context)]

set gPB(ude,editor,pnt,Label)                           [::msgcat::mc MC(ude,editor,pnt,Label)]
set gPB(ude,editor,pnt,Context)                         [::msgcat::mc MC(ude,editor,pnt,Context)]

set gPB(ude,editor,trash,Label)                         [::msgcat::mc MC(ude,editor,trash,Label)]
set gPB(ude,editor,trash,Context)                       [::msgcat::mc MC(ude,editor,trash,Context)]

set gPB(ude,editor,event,Label)                         [::msgcat::mc MC(ude,editor,event,Label)]
set gPB(ude,editor,event,Context)                       [::msgcat::mc MC(ude,editor,event,Context)]

set gPB(ude,editor,param,Label)                         [::msgcat::mc MC(ude,editor,param,Label)]
set gPB(ude,editor,param,Context)                       [::msgcat::mc MC(ude,editor,param,Context)]
set gPB(ude,editor,param,edit,Label)                    [::msgcat::mc MC(ude,editor,param,edit,Label)]
set gPB(ude,editor,param,edit,Context)                  [::msgcat::mc MC(ude,editor,param,edit,Context)]
set gPB(ude,editor,param,editor,Label)                  [::msgcat::mc MC(ude,editor,param,editor,Label)]

set gPB(ude,editor,pnt,sel,Label)                       [::msgcat::mc MC(ude,editor,pnt,sel,Label)]
set gPB(ude,editor,pnt,dsp,Label)                       [::msgcat::mc MC(ude,editor,pnt,dsp,Label)]

set gPB(ude,editor,dlg,ok,Label)                        [::msgcat::mc MC(ude,editor,dlg,ok,Label)]
set gPB(ude,editor,dlg,bck,Label)                       [::msgcat::mc MC(ude,editor,dlg,bck,Label)]
set gPB(ude,editor,dlg,cnl,Label)                       [::msgcat::mc MC(ude,editor,dlg,cnl,Label)]

set gPB(ude,editor,paramdlg,PL,Label)                   [::msgcat::mc MC(ude,editor,paramdlg,PL,Label)]
set gPB(ude,editor,paramdlg,VN,Label)                   [::msgcat::mc MC(ude,editor,paramdlg,VN,Label)]
set gPB(ude,editor,paramdlg,DF,Label)                   [::msgcat::mc MC(ude,editor,paramdlg,DF,Label)]
set gPB(ude,editor,paramdlg,PL,Context)                 [::msgcat::mc MC(ude,editor,paramdlg,PL,Context)]
set gPB(ude,editor,paramdlg,VN,Context)                 [::msgcat::mc MC(ude,editor,paramdlg,VN,Context)]
set gPB(ude,editor,paramdlg,DF,Context)                 [::msgcat::mc MC(ude,editor,paramdlg,DF,Context)]
set gPB(ude,editor,paramdlg,TG)                     [::msgcat::mc MC(ude,editor,paramdlg,TG)]
set gPB(ude,editor,paramdlg,TG,B,Label)             [::msgcat::mc MC(ude,editor,paramdlg,TG,B,Label)]
set gPB(ude,editor,paramdlg,TG,B,Context)           [::msgcat::mc MC(ude,editor,paramdlg,TG,B,Context)]
set gPB(ude,editor,paramdlg,ON,Label)               [::msgcat::mc MC(ude,editor,paramdlg,ON,Label)]
set gPB(ude,editor,paramdlg,OFF,Label)              [::msgcat::mc MC(ude,editor,paramdlg,OFF,Label)]
set gPB(ude,editor,paramdlg,ON,Context)             [::msgcat::mc MC(ude,editor,paramdlg,ON,Context)]
set gPB(ude,editor,paramdlg,OFF,Context)            [::msgcat::mc MC(ude,editor,paramdlg,OFF,Context)]
set gPB(ude,editor,paramdlg,OL)                     [::msgcat::mc MC(ude,editor,paramdlg,OL)]
set gPB(ude,editor,paramdlg,ADD,Label)              [::msgcat::mc MC(ude,editor,paramdlg,ADD,Label)]
set gPB(ude,editor,paramdlg,PASTE,Label)            [::msgcat::mc MC(ude,editor,paramdlg,PASTE,Label)]
set gPB(ude,editor,paramdlg,CUT,Label)              [::msgcat::mc MC(ude,editor,paramdlg,CUT,Label)]
set gPB(ude,editor,paramdlg,ADD,Context)            [::msgcat::mc MC(ude,editor,paramdlg,ADD,Context)]
set gPB(ude,editor,paramdlg,CUT,Context)            [::msgcat::mc MC(ude,editor,paramdlg,CUT,Context)]
set gPB(ude,editor,paramdlg,PASTE,Context)          [::msgcat::mc MC(ude,editor,paramdlg,PASTE,Context)]
set gPB(ude,editor,paramdlg,ENTRY,Label)            [::msgcat::mc MC(ude,editor,paramdlg,ENTRY,Label)]
set gPB(ude,editor,paramdlg,ENTRY,Context)          [::msgcat::mc MC(ude,editor,paramdlg,ENTRY,Context)]
set gPB(ude,editor,eventdlg,EN,Label)               [::msgcat::mc MC(ude,editor,eventdlg,EN,Label)]
set gPB(ude,editor,eventdlg,EN,Context)             [::msgcat::mc MC(ude,editor,eventdlg,EN,Context)]
set gPB(ude,editor,eventdlg,PEN,Label)              [::msgcat::mc MC(ude,editor,eventdlg,PEN,Label)]
set gPB(ude,editor,eventdlg,PEN,Context)            [::msgcat::mc MC(ude,editor,eventdlg,PEN,Context)]
set gPB(ude,editor,eventdlg,PEN,C,Label)            [::msgcat::mc MC(ude,editor,eventdlg,PEN,C,Label)]
set gPB(ude,editor,eventdlg,PEN,C,Context)          [::msgcat::mc MC(ude,editor,eventdlg,PEN,C,Context)]
set gPB(ude,editor,eventdlg,EL,Label)               [::msgcat::mc MC(ude,editor,eventdlg,EL,Label)]
set gPB(ude,editor,eventdlg,EL,Context)             [::msgcat::mc MC(ude,editor,eventdlg,EL,Context)]
set gPB(ude,editor,eventdlg,EL,C,Label)             [::msgcat::mc MC(ude,editor,eventdlg,EL,C,Label)]
set gPB(ude,editor,eventdlg,EL,C,Context)           [::msgcat::mc MC(ude,editor,eventdlg,EL,C,Context)]
set gPB(ude,editor,eventdlg,EC,Label)               [::msgcat::mc MC(ude,editor,eventdlg,EC,Label)]
set gPB(ude,editor,eventdlg,EC,Context)             [::msgcat::mc MC(ude,editor,eventdlg,EC,Context)]
set gPB(ude,editor,eventdlg,EC_MILL,Label)          [::msgcat::mc MC(ude,editor,eventdlg,EC_MILL,Label)]
set gPB(ude,editor,eventdlg,EC_DRILL,Label)         [::msgcat::mc MC(ude,editor,eventdlg,EC_DRILL,Label)]
set gPB(ude,editor,eventdlg,EC_LATHE,Label)         [::msgcat::mc MC(ude,editor,eventdlg,EC_LATHE,Label)]
set gPB(ude,editor,eventdlg,EC_WEDM,Label)          [::msgcat::mc MC(ude,editor,eventdlg,EC_WEDM,Label)]
set gPB(ude,editor,eventdlg,EC_MILL,Context)        [::msgcat::mc MC(ude,editor,eventdlg,EC_MILL,Context)]
set gPB(ude,editor,eventdlg,EC_DRILL,Context)       [::msgcat::mc MC(ude,editor,eventdlg,EC_DRILL,Context)]
set gPB(ude,editor,eventdlg,EC_LATHE,Context)       [::msgcat::mc MC(ude,editor,eventdlg,EC_LATHE,Context)]
set gPB(ude,editor,eventdlg,EC_WEDM,Context)        [::msgcat::mc MC(ude,editor,eventdlg,EC_WEDM,Context)]
set gPB(ude,editor,EDIT)                            [::msgcat::mc MC(ude,editor,EDIT)]
set gPB(ude,editor,CREATE)                          [::msgcat::mc MC(ude,editor,CREATE)]
set gPB(ude,editor,popup,HELP)                      [::msgcat::mc MC(ude,editor,popup,HELP)]
set gPB(ude,editor,popup,EDIT)                      [::msgcat::mc MC(ude,editor,popup,EDIT)]
set gPB(ude,editor,param,EDIT)                      [::msgcat::mc MC(ude,editor,param,EDIT)]
set gPB(ude,editor,param,VIEW)                      [::msgcat::mc MC(ude,editor,param,VIEW)]
set gPB(ude,editor,popup,DELETE)                    [::msgcat::mc MC(ude,editor,popup,DELETE)]
set gPB(ude,editor,popup,CREATE)                    [::msgcat::mc MC(ude,editor,popup,CREATE)]
set gPB(ude,editor,popup,IMPORT)                    [::msgcat::mc MC(ude,editor,popup,IMPORT)]
set gPB(ude,editor,popup,MSG_BLANK)                 [::msgcat::mc MC(ude,editor,popup,MSG_BLANK)]
set gPB(ude,editor,popup,MSG_SAMENAME)              [::msgcat::mc MC(ude,editor,popup,MSG_SAMENAME)]
set gPB(ude,editor,popup,MSG_SameHandler)           [::msgcat::mc MC(ude,editor,popup,MSG_SameHandler)]
set gPB(ude,validate)                               [::msgcat::mc MC(ude,validate)]
set gPB(ude,prev,tab,Label)                         [::msgcat::mc MC(ude,prev,tab,Label)]
set gPB(ude,prev,ude,Label)                         [::msgcat::mc MC(ude,prev,ude,Label)]
set gPB(ude,prev,udc,Label)                         [::msgcat::mc MC(ude,prev,udc,Label)]
set gPB(ude,prev,mc,Label)                          [::msgcat::mc MC(ude,prev,mc,Label)]
set gPB(ude,prev,nmc,Label)                         [::msgcat::mc MC(ude,prev,nmc,Label)]
set gPB(udc,prev,sys,Label)                         [::msgcat::mc MC(udc,prev,sys,Label)]
set gPB(udc,prev,nsys,Label)                        [::msgcat::mc MC(udc,prev,nsys,Label)]
set gPB(ude,prev,Status)                            [::msgcat::mc MC(ude,prev,Status)]
set gPB(ude,editor,opt,MSG_BLANK)                   [::msgcat::mc MC(ude,editor,opt,MSG_BLANK)]
set gPB(ude,editor,opt,MSG_SAME)                    [::msgcat::mc MC(ude,editor,opt,MSG_SAME)]
set gPB(ude,editor,opt,MSG_PST_SAME)                [::msgcat::mc MC(ude,editor,opt,MSG_PST_SAME)]
set gPB(ude,editor,opt,MSG_IDENTICAL)               [::msgcat::mc MC(ude,editor,opt,MSG_IDENTICAL)]
set gPB(ude,editor,opt,NO_OPT)                      [::msgcat::mc MC(ude,editor,opt,NO_OPT)]
set gPB(ude,editor,param,MSG_NO_VNAME)              [::msgcat::mc MC(ude,editor,param,MSG_NO_VNAME)]
set gPB(ude,editor,param,MSG_EXIST_VNAME)           [::msgcat::mc MC(ude,editor,param,MSG_EXIST_VNAME)]
set gPB(ude,editor,spindle_css,INFO)                [::msgcat::mc MC(ude,editor,spindle_css,INFO)]
set gPB(ude,import,ihr,Label)                       [::msgcat::mc MC(ude,import,ihr,Label)]
set gPB(ude,import,ihr,Context)                     [::msgcat::mc MC(ude,import,ihr,Context)]
set gPB(ude,import,sel,Label)                       [::msgcat::mc MC(ude,import,sel,Label)]
set gPB(ude,import,sel,Context)                     [::msgcat::mc MC(ude,import,sel,Context)]
set gPB(ude,import,name_cdl,Label)                  [::msgcat::mc MC(ude,import,name_cdl,Label)]
set gPB(ude,import,name_cdl,Context)                [::msgcat::mc MC(ude,import,name_cdl,Context)]
set gPB(ude,import,name_def,Label)                  [::msgcat::mc MC(ude,import,name_def,Label)]
set gPB(ude,import,name_def,Context)                [::msgcat::mc MC(ude,import,name_def,Context)]
set gPB(ude,import,include_cdl,Label)               [::msgcat::mc MC(ude,import,include_cdl,Label)]
set gPB(ude,import,ihr_pst,Label)                   [::msgcat::mc MC(ude,import,ihr_pst,Label)]
set gPB(ude,import,ihr_folder,Label)                [::msgcat::mc MC(ude,import,ihr_folder,Label)]
set gPB(ude,import,own_folder,Label)                [::msgcat::mc MC(ude,import,own_folder,Label)]
set gPB(ude,import,own,Label)                       [::msgcat::mc MC(ude,import,own,Label)]
set gPB(ude,import,own,Context)                     [::msgcat::mc MC(ude,import,own,Context)]
set gPB(ude,import,own_ent,Label)                   [::msgcat::mc MC(ude,import,own_ent,Label)]
set gPB(ude,import,own_ent,Context)                 [::msgcat::mc MC(ude,import,own_ent,Context)]
set gPB(ude,import,sel,pui,status)                  [::msgcat::mc MC(ude,import,sel,pui,status)]
set gPB(ude,import,sel,cdl,status)                  [::msgcat::mc MC(ude,import,sel,cdl,status)]
#----------------------for UDC-----------------------------------------------------
set gPB(udc,editor,TITLE)                           [::msgcat::mc MC(udc,editor,TITLE)]
set gPB(udc,editor,CREATE)                          [::msgcat::mc MC(udc,editor,CREATE)]
set gPB(udc,editor,TYPE)                            [::msgcat::mc MC(udc,editor,TYPE)]
set gPB(udc,editor,type,UDC)                        [::msgcat::mc MC(udc,editor,type,UDC)]
set gPB(udc,editor,type,SYSUDC)                     [::msgcat::mc MC(udc,editor,type,SYSUDC)]
set gPB(udc,editor,CYCLBL,Label)                    [::msgcat::mc MC(udc,editor,CYCLBL,Label)]
set gPB(udc,editor,CYCNAME,Label)                   [::msgcat::mc MC(udc,editor,CYCNAME,Label)]
set gPB(udc,editor,CYCLBL,Context)                  [::msgcat::mc MC(udc,editor,CYCLBL,Context)]
set gPB(udc,editor,CYCNAME,Context)                 [::msgcat::mc MC(udc,editor,CYCNAME,Context)]
set gPB(udc,editor,CYCLBL,C,Label)                  [::msgcat::mc MC(udc,editor,CYCLBL,C,Label)]
set gPB(udc,editor,CYCLBL,C,Context)                [::msgcat::mc MC(udc,editor,CYCLBL,C,Context)]
set gPB(udc,editor,popup,EDIT)                      [::msgcat::mc MC(udc,editor,popup,EDIT)]
set gPB(udc,editor,popup,MSG_BLANK)                 [::msgcat::mc MC(udc,editor,popup,MSG_BLANK)]
set gPB(udc,editor,popup,MSG_SAMENAME)              [::msgcat::mc MC(udc,editor,popup,MSG_SAMENAME)]
set gPB(udc,editor,popup,MSG_SameHandler)           [::msgcat::mc MC(udc,editor,popup,MSG_SameHandler)]
set gPB(udc,editor,popup,MSG_ISSYSCYC)              [::msgcat::mc MC(udc,editor,popup,MSG_ISSYSCYC)]
set gPB(udc,editor,popup,MSG_SYSCYC_EXIST)          [::msgcat::mc MC(udc,editor,popup,MSG_SYSCYC_EXIST)]
set gPB(udc,editor,EDIT)                            [::msgcat::mc MC(udc,editor,EDIT)]
set gPB(udc,editor,popup,CREATE)                    [::msgcat::mc MC(udc,editor,popup,CREATE)]
set gPB(udc,editor,popup,IMPORT)                    [::msgcat::mc MC(udc,editor,popup,IMPORT)]
set gPB(udc,drill,csink,INFO)                       [::msgcat::mc MC(udc,drill,csink,INFO)]
set gPB(udc,drill,simulate,INFO)                    [::msgcat::mc MC(udc,drill,simulate,INFO)]
set gPB(udc,drill,dwell,INFO)                       [::msgcat::mc MC(udc,drill,dwell,INFO)]
#peter--------------------------------------------------------------------------------------------------

#pheobe
#####
#IS&V
#####
set gPB(isv,tab,label)                          [::msgcat::mc MC(isv,tab,label)]
set gPB(isv,Status)                             [::msgcat::mc MC(isv,Status)]
set gPB(isv,review,Status)                      [::msgcat::mc MC(isv,review,Status)]

set gPB(isv,setup,Label)                        [::msgcat::mc MC(isv,setup,Label)]
set gPB(isv,vnc_command,Label)                  [::msgcat::mc MC(isv,vnc_command,Label)]
####################
# General Definition
####################
set gPB(isv,select_Main)                        [::msgcat::mc MC(isv,select_Main)]
set gPB(isv,setup,machine,Label)                [::msgcat::mc MC(isv,setup,machine,Label)]
set gPB(isv,setup,component,Label)              [::msgcat::mc MC(isv,setup,component,Label)]
set gPB(isv,setup,mac_zcs_frame,Label)          [::msgcat::mc MC(isv,setup,mac_zcs_frame,Label)]
set gPB(isv,setup,mac_zcs,Label)                [::msgcat::mc MC(isv,setup,mac_zcs,Label)]
set gPB(isv,setup,mac_zcs,Context)              [::msgcat::mc MC(isv,setup,mac_zcs,Context)]
set gPB(isv,setup,spin_com,Label)               [::msgcat::mc MC(isv,setup,spin_com,Label)]
set gPB(isv,setup,spin_com,Context)             [::msgcat::mc MC(isv,setup,spin_com,Context)]

set gPB(isv,setup,spin_jct,Label)               [::msgcat::mc MC(isv,setup,spin_jct,Label)]
set gPB(isv,setup,spin_jct,Context)     [::msgcat::mc MC(isv,setup,spin_jct,Context)]
set gPB(isv,setup,axis_name,Label)      [::msgcat::mc MC(isv,setup,axis_name,Label)]
set gPB(isv,setup,axis_name,Context)    [::msgcat::mc MC(isv,setup,axis_name,Context)]




set gPB(isv,setup,axis_frm,Label)       [::msgcat::mc MC(isv,setup,axis_frm,Label)]
set gPB(isv,setup,rev_fourth,Label)     [::msgcat::mc MC(isv,setup,rev_fourth,Label)]
set gPB(isv,setup,rev_fourth,Context)   [::msgcat::mc MC(isv,setup,rev_fourth,Context)]
set gPB(isv,setup,rev_fifth,Label)      [::msgcat::mc MC(isv,setup,rev_fifth,Label)]

set gPB(isv,setup,fourth_limit,Label)   [::msgcat::mc MC(isv,setup,fourth_limit,Label)]
set gPB(isv,setup,fourth_limit,Context) [::msgcat::mc MC(isv,setup,fourth_limit,Context)]
set gPB(isv,setup,fifth_limit,Label)    [::msgcat::mc MC(isv,setup,fifth_limit,Label)]
set gPB(isv,setup,limiton,Label)        [::msgcat::mc MC(isv,setup,limiton,Label)]
set gPB(isv,setup,limitoff,Label)       [::msgcat::mc MC(isv,setup,limitoff,Label)]
set gPB(isv,setup,fourth_table,Label)   [::msgcat::mc MC(isv,setup,fourth_table,Label)]
set gPB(isv,setup,fifth_table,Label)    [::msgcat::mc MC(isv,setup,fifth_table,Label)]
set gPB(isv,setup,header,Label)         [::msgcat::mc MC(isv,setup,header,Label)]
set gPB(isv,setup,intialization,Label)  [::msgcat::mc MC(isv,setup,intialization,Label)]
set gPB(isv,setup,general_def,Label)    [::msgcat::mc MC(isv,setup,general_def,Label)]
set gPB(isv,setup,advanced_def,Label)   [::msgcat::mc MC(isv,setup,advanced_def,Label)]
set gPB(isv,setup,InputOutput,Label)    [::msgcat::mc MC(isv,setup,InputOutput,Label)]

set gPB(isv,setup,program,Label)        [::msgcat::mc MC(isv,setup,program,Label)]
set gPB(isv,setup,output,Label)         [::msgcat::mc MC(isv,setup,output,Label)]
set gPB(isv,setup,output,Context)       [::msgcat::mc MC(isv,setup,output,Context)]
set gPB(isv,setup,input,Label)          [::msgcat::mc MC(isv,setup,input,Label)]
set gPB(isv,setup,input,Context)        [::msgcat::mc MC(isv,setup,input,Context)]
set gPB(isv,setup,wcs,Label)            [::msgcat::mc MC(isv,setup,wcs,Label)]
set gPB(isv,setup,tool,Label)           [::msgcat::mc MC(isv,setup,tool,Label)]
set gPB(isv,setup,g_code,Label)         [::msgcat::mc MC(isv,setup,g_code,Label)]
set gPB(isv,setup,special_vnc,Label)    [::msgcat::mc MC(isv,setup,special_vnc,Label)]

set gPB(isv,setup,initial,frame,Label)       [::msgcat::mc MC(isv,setup,initial,frame,Label)]
set gPB(isv,setup,initial_motion,Label)      [::msgcat::mc MC(isv,setup,initial_motion,Label)]
set gPB(isv,setup,initial_motion,Context)    [::msgcat::mc MC(isv,setup,initial_motion,Context)]

set gPB(isv,setup,spindle,frame,Label)       [::msgcat::mc MC(isv,setup,spindle,frame,Label)]
set gPB(isv,setup,spindle_mode,Label)        [::msgcat::mc MC(isv,setup,spindle_mode,Label)]
set gPB(isv,setup,spindle_direction,Label)   [::msgcat::mc MC(isv,setup,spindle_direction,Label)]
set gPB(isv,setup,spindle,frame,Context)     [::msgcat::mc MC(isv,setup,spindle,frame,Context)]

set gPB(isv,setup,feedrate_mode,Label)       [::msgcat::mc MC(isv,setup,feedrate_mode,Label)]
set gPB(isv,setup,feedrate_mode,Context)     [::msgcat::mc MC(isv,setup,feedrate_mode,Context)]

set gPB(isv,setup,boolean,frame,Label)       [::msgcat::mc MC(isv,setup,boolean,frame,Label)]
set gPB(isv,setup,power_on_wcs,Label)        [::msgcat::mc MC(isv,setup,power_on_wcs,Label)]
set gPB(isv,setup,power_on_wcs,Context)      [::msgcat::mc MC(isv,setup,power_on_wcs,Context)]

set gPB(isv,setup,use_s_leader,Label)        [::msgcat::mc MC(isv,setup,use_s_leader,Label)]
set gPB(isv,setup,use_f_leader,Label)        [::msgcat::mc MC(isv,setup,use_f_leader,Label)]


set gPB(isv,setup,dog_leg,Label)             [::msgcat::mc MC(isv,setup,dog_leg,Label)]
set gPB(isv,setup,dog_leg,Context)           [::msgcat::mc MC(isv,setup,dog_leg,Context)]
set gPB(isv,setup,dog_leg,yes)               [::msgcat::mc MC(isv,setup,dog_leg,yes)]
set gPB(isv,setup,dog_leg,no)                [::msgcat::mc MC(isv,setup,dog_leg,no)]

set gPB(isv,setup,on_off_frame,Label)        [::msgcat::mc MC(isv,setup,on_off_frame,Label)]
set gPB(isv,setup,stroke_limit,Label)        [::msgcat::mc MC(isv,setup,stroke_limit,Label)]
set gPB(isv,setup,cutcom,Label)                [::msgcat::mc MC(isv,setup,cutcom,Label)]
set gPB(isv,setup,tl_adjust,Label)             [::msgcat::mc MC(isv,setup,tl_adjust,Label)]
set gPB(isv,setup,scale,Label)                 [::msgcat::mc MC(isv,setup,scale,Label)]
set gPB(isv,setup,macro_modal,Label)           [::msgcat::mc MC(isv,setup,macro_modal,Label)]
set gPB(isv,setup,wcs_rotate,Label)            [::msgcat::mc MC(isv,setup,wcs_rotate,Label)]
set gPB(isv,setup,cycle,Label)                 [::msgcat::mc MC(isv,setup,cycle,Label)]


set gPB(isv,setup,initial_mode,frame,Label)     [::msgcat::mc MC(isv,setup,initial_mode,frame,Label)]
set gPB(isv,setup,initial_mode,frame,Context)   [::msgcat::mc MC(isv,setup,initial_mode,frame,Context)]
##############################
# Input/Out Related
##############################

set gPB(isv,sign_define,frame,Label)            [::msgcat::mc MC(isv,sign_define,frame,Label)]
set gPB(isv,sign_define,rewindstop,Label)       [::msgcat::mc MC(isv,sign_define,rewindstop,Label)]
set gPB(isv,sign_define,rewindstop,Context)     [::msgcat::mc MC(isv,sign_define,rewindstop,Context)]

set gPB(isv,control_var,frame,Label)            [::msgcat::mc MC(isv,control_var,frame,Label)]

set gPB(isv,sign_define,convarleader,Label)     [::msgcat::mc MC(isv,sign_define,convarleader,Label)]
set gPB(isv,sign_define,convarleader,Context)   [::msgcat::mc MC(isv,sign_define,convarleader,Context)]
set gPB(isv,sign_define,conequ,Label)           [::msgcat::mc MC(isv,sign_define,conequ,Label)]
set gPB(isv,sign_define,conequ,Context)         [::msgcat::mc MC(isv,sign_define,conequ,Context)]
set gPB(isv,sign_define,percent,Label)          [::msgcat::mc MC(isv,sign_define,percent,Label)]
set gPB(isv,sign_define,leaderjing,Label)       [::msgcat::mc MC(isv,sign_define,leaderjing,Label)]
set gPB(isv,sign_define,text_string,Label)      [::msgcat::mc MC(isv,sign_define,text_string,Label)]

set gPB(isv,inputmode,frame,Label)               [::msgcat::mc MC(isv,inputmode,frame,Label)]
set gPB(isv,input_mode,Label)                    [::msgcat::mc MC(isv,input_mode,Label)]
set gPB(isv,absolute_mode,Label)                 [::msgcat::mc MC(isv,absolute_mode,Label)]
set gPB(isv,incremental_style,frame,Label)       [::msgcat::mc MC(isv,incremental_style,frame,Label)]

set gPB(isv,incremental_mode,Label)              [::msgcat::mc MC(isv,incremental_mode,Label)]
set gPB(isv,incremental_gcode,Label)             [::msgcat::mc MC(isv,incremental_gcode,Label)]
set gPB(isv,incremental_gcode,Context)           [::msgcat::mc MC(isv,incremental_gcode,Context)]
set gPB(isv,incremental_uvw,Label)               [::msgcat::mc MC(isv,incremental_uvw,Label)]
set gPB(isv,incremental_uvw,Context)             [::msgcat::mc MC(isv,incremental_uvw,Context)]
set gPB(isv,incr_x,Label)                        [::msgcat::mc MC(isv,incr_x,Label)]
set gPB(isv,incr_y,Label)                        [::msgcat::mc MC(isv,incr_y,Label)]
set gPB(isv,incr_z,Label)                        [::msgcat::mc MC(isv,incr_z,Label)]
set gPB(isv,incr_a,Label)                        [::msgcat::mc MC(isv,incr_a,Label)]
set gPB(isv,incr_b,Label)                        [::msgcat::mc MC(isv,incr_b,Label)]

set gPB(isv,incr_x,Context)                      [::msgcat::mc MC(isv,incr_x,Context)]
set gPB(isv,incr_y,Context)                      [::msgcat::mc MC(isv,incr_y,Context)]
set gPB(isv,incr_z,Context)                      [::msgcat::mc MC(isv,incr_z,Context)]
set gPB(isv,incr_a,Context)                      [::msgcat::mc MC(isv,incr_a,Context)]
set gPB(isv,incr_b,Context)                      [::msgcat::mc MC(isv,incr_b,Context)]
set gPB(isv,vnc_mes,frame,Label)                 [::msgcat::mc MC(isv,vnc_mes,frame,Label)]
set gPB(isv,vnc_message,Label)                   [::msgcat::mc MC(isv,vnc_message,Label)]
set gPB(isv,vnc_message,Context)                 [::msgcat::mc MC(isv,vnc_message,Context)]

set gPB(isv,vnc_mes,prefix,Label)                [::msgcat::mc MC(isv,vnc_mes,prefix,Label)]
set gPB(isv,spec_desc,Label)                     [::msgcat::mc MC(isv,spec_desc,Label)]
set gPB(isv,spec_codelist,Label)                 [::msgcat::mc MC(isv,spec_codelist,Label)]
set gPB(isv,spec_nccode,Label)                   [::msgcat::mc MC(isv,spec_nccode,Label)]
###################
# WCS Definition
###################
set gPB(isv,machine_zero,offset,Label)              [::msgcat::mc MC(isv,machine_zero,offset,Label)]
set gPB(isv,wcs_offset,frame,Label)                 [::msgcat::mc MC(isv,wcs_offset,frame,Label)]
set gPB(isv,wcs_leader,Label)                       [::msgcat::mc MC(isv,wcs_leader,Label)]
set gPB(isv,wcs_number,Label)                       [::msgcat::mc MC(isv,wcs_number,Label)]
set gPB(isv,wcs_offset,origin_x,Label)              [::msgcat::mc MC(isv,wcs_offset,origin_x,Label)]
set gPB(isv,wcs_offset,origin_y,Label)              [::msgcat::mc MC(isv,wcs_offset,origin_y,Label)]
set gPB(isv,wcs_offset,origin_z,Label)              [::msgcat::mc MC(isv,wcs_offset,origin_z,Label)]
set gPB(isv,wcs_offset,a_offset,Label)              [::msgcat::mc MC(isv,wcs_offset,a_offset,Label)]
set gPB(isv,wcs_offset,b_offset,Label)              [::msgcat::mc MC(isv,wcs_offset,b_offset,Label)]
set gPB(isv,wcs_offset,c_offset,Label)              [::msgcat::mc MC(isv,wcs_offset,c_offset,Label)]
set gPB(isv,wcs_offset,wcs_num,Label)               [::msgcat::mc MC(isv,wcs_offset,wcs_num,Label)]
set gPB(isv,wcs_offset,wcs_num,Context)             [::msgcat::mc MC(isv,wcs_offset,wcs_num,Context)]
set gPB(isv,wcs_offset,wcs_add,Label)               [::msgcat::mc MC(isv,wcs_offset,wcs_add,Label)]
set gPB(isv,wcs_offset,wcs_add,Context)             [::msgcat::mc MC(isv,wcs_offset,wcs_add,Context)]
set gPB(isv,wcs_offset,wcs_err,Msg)                 [::msgcat::mc MC(isv,wcs_offset,wcs_err,Msg)]

set gPB(isv,tool_info,frame,Label)                  [::msgcat::mc MC(isv,tool_info,frame,Label)]
set gPB(isv,tool_info,tool_entry,Label)             [::msgcat::mc MC(isv,tool_info,tool_entry,Label)]
set gPB(isv,tool_info,tool_name,Label)              [::msgcat::mc MC(isv,tool_info,tool_name,Label)]

set gPB(isv,tool_info,tool_num,Label)               [::msgcat::mc MC(isv,tool_info,tool_num,Label)]
set gPB(isv,tool_info,add_tool,Label)               [::msgcat::mc MC(isv,tool_info,add_tool,Label)]
set gPB(isv,tool_info,tool_diameter,Label)          [::msgcat::mc MC(isv,tool_info,tool_diameter,Label)]
set gPB(isv,tool_info,offset_usder,Label)           [::msgcat::mc MC(isv,tool_info,offset_usder,Label)]
set gPB(isv,tool_info,carrier_id,Label)             [::msgcat::mc MC(isv,tool_info,carrier_id,Label)]
set gPB(isv,tool_info,pocket_id,Label)              [::msgcat::mc MC(isv,tool_info,pocket_id,Label)]
set gPB(isv,tool_info,cutcom_reg,Label)             [::msgcat::mc MC(isv,tool_info,cutcom_reg,Label)]
set gPB(isv,tool_info,cutreg,Label)                 [::msgcat::mc MC(isv,tool_info,cutreg,Label)]
set gPB(isv,tool_info,cutval,Label)                 [::msgcat::mc MC(isv,tool_info,cutval,Label)]
set gPB(isv,tool_info,adjust_reg,Label)             [::msgcat::mc MC(isv,tool_info,adjust_reg,Label)]
set gPB(isv,tool_info,tool_type,Label)              [::msgcat::mc MC(isv,tool_info,tool_type,Label)]
set gPB(isv,prog,setup,Label)                       [::msgcat::mc MC(isv,prog,setup,Label)]
set gPB(isv,prog,setup_right,Label)                 [::msgcat::mc MC(isv,prog,setup_right,Label)]
set gPB(isv,output,setup_data,Label)                [::msgcat::mc MC(isv,output,setup_data,Label)]
set gPB(isv,input,setup_data,Label)                 [::msgcat::mc MC(isv,input,setup_data,Label)]
set gPB(isv,setup,file_err,Msg)                     [::msgcat::mc MC(isv,setup,file_err,Msg)]

set gPB(isv,tool_info,toolnum,Label)                [::msgcat::mc MC(isv,tool_info,toolnum,Label)]
set gPB(isv,tool_info,toolnum,Context)              [::msgcat::mc MC(isv,tool_info,toolnum,Context)]
set gPB(isv,tool_info,add_tool,Context)             [::msgcat::mc MC(isv,tool_info,add_tool,Context)]
set gPB(isv,tool_info,add_err,Msg)                  [::msgcat::mc MC(isv,tool_info,add_err,Msg)]
set gPB(isv,tool_info,name_err,Msg)                 [::msgcat::mc MC(isv,tool_info,name_err,Msg)]
######################
# Special G code Definition
######################

set gPB(isv,g_code,frame,Label)                     [::msgcat::mc MC(isv,g_code,frame,Label)]
set gPB(isv,g_code,frame,Context)                   [::msgcat::mc MC(isv,g_code,frame,Context)]
set gPB(isv,g_code,from_home,Label)                 [::msgcat::mc MC(isv,g_code,from_home,Label)]
set gPB(isv,g_code,return_home,Label)               [::msgcat::mc MC(isv,g_code,return_home,Label)]
set gPB(isv,g_code,mach_wcs,Label)                  [::msgcat::mc MC(isv,g_code,mach_wcs,Label)]
set gPB(isv,g_code,set_local,Label)                 [::msgcat::mc MC(isv,g_code,set_local,Label)]
###########################
# Special NC Custom Command
#############################

set gPB(isv,spec_command,frame,Label)               [::msgcat::mc MC(isv,spec_command,frame,Label)]
set gPB(isv,spec_command,frame,Context)             [::msgcat::mc MC(isv,spec_command,frame,Context)]
set gPB(isv,spec_pre,frame,Label)                   [::msgcat::mc MC(isv,spec_pre,frame,Label)]
set gPB(isv,spec_pre,frame,Context)                 [::msgcat::mc MC(isv,spec_pre,frame,Context)]
set gPB(isv,spec_command,add,Label)                 [::msgcat::mc MC(isv,spec_command,add,Label)]
set gPB(isv,spec_command,edit,Label)                [::msgcat::mc MC(isv,spec_command,edit,Label)]
set gPB(isv,spec_command,delete,Label)              [::msgcat::mc MC(isv,spec_command,delete,Label)]
set gPB(isv,spec_command,title,Label)               [::msgcat::mc MC(isv,spec_command,title,Label)]
set gPB(isv,spec_command,add_sim,Label)             [::msgcat::mc MC(isv,spec_command,add_sim,Label)]
set gPB(isv,spec_command,init_sim,Label)            [::msgcat::mc MC(isv,spec_command,init_sim,Label)]

set gPB(isv,spec_command,preleader,Label)           [::msgcat::mc MC(isv,spec_command,preleader,Label)]
set gPB(isv,spec_command,preleader,Context)         [::msgcat::mc MC(isv,spec_command,preleader,Context)]
set gPB(isv,spec_command,precode,Label)             [::msgcat::mc MC(isv,spec_command,precode,Label)]
set gPB(isv,spec_command,precode,Context)           [::msgcat::mc MC(isv,spec_command,precode,Context)]
set gPB(isv,spec_command,leader,Label)              [::msgcat::mc MC(isv,spec_command,leader,Label)]
set gPB(isv,spec_command,leader,Context)            [::msgcat::mc MC(isv,spec_command,leader,Context)]
set gPB(isv,spec_command,code,Label)                [::msgcat::mc MC(isv,spec_command,code,Label)]
set gPB(isv,spec_command,code,Context)              [::msgcat::mc MC(isv,spec_command,code,Context)]
set gPB(isv,spec_command,add,Context)               [::msgcat::mc MC(isv,spec_command,add,Context)]
set gPB(isv,spec_command,add_err,Msg)               [::msgcat::mc MC(isv,spec_command,add_err,Msg)]
set gPB(isv,spec_command,sel_err,Msg)               [::msgcat::mc MC(isv,spec_command,sel_err,Msg)]
set gPB(isv,export,error,title)                     [::msgcat::mc MC(isv,export,error,title)]
set gPB(isv,ex_editor,warning,Msg)                  [::msgcat::mc MC(isv,ex_editor,warning,Msg)]




### Language
set gPB(language,Label)                             [::msgcat::mc MC(language,Label)]
set gPB(pb_msg_brazilian_portuguese)                [::msgcat::mc MC(pb_msg_brazilian_portuguese)]
set gPB(pb_msg_english)                             [::msgcat::mc MC(pb_msg_english)]
set gPB(pb_msg_french)                              [::msgcat::mc MC(pb_msg_french)]
set gPB(pb_msg_german)                              [::msgcat::mc MC(pb_msg_german)]
set gPB(pb_msg_italian)                             [::msgcat::mc MC(pb_msg_italian)]
set gPB(pb_msg_japanese)                            [::msgcat::mc MC(pb_msg_japanese)]
set gPB(pb_msg_korean)                              [::msgcat::mc MC(pb_msg_korean)]
set gPB(pb_msg_russian)                             [::msgcat::mc MC(pb_msg_russian)]
set gPB(pb_msg_simple_chinese)                      [::msgcat::mc MC(pb_msg_simple_chinese)]
set gPB(pb_msg_spanish)                             [::msgcat::mc MC(pb_msg_spanish)]
set gPB(pb_msg_traditional_chinese)                 [::msgcat::mc MC(pb_msg_traditional_chinese)]

### Exit Options Dialog
set gPB(exit,options,Label)                         [::msgcat::mc MC(exit,options,Label)]
set gPB(exit,options,SaveAll,Label)                 [::msgcat::mc MC(exit,options,SaveAll,Label)]
set gPB(exit,options,SaveNone,Label)                [::msgcat::mc MC(exit,options,SaveNone,Label)]
set gPB(exit,options,SaveSelect,Label)              [::msgcat::mc MC(exit,options,SaveSelect,Label)]

### OptionMenu Items
set gPB(optionMenu,item,Other)       [::msgcat::mc MC(optionMenu,item,Other)]
set gPB(optionMenu,item,None)        [::msgcat::mc MC(optionMenu,item,None)]
set gPB(optionMenu,item,RT_R)        [::msgcat::mc MC(optionMenu,item,RT_R)]
set gPB(optionMenu,item,Rapid)       [::msgcat::mc MC(optionMenu,item,Rapid)]
set gPB(optionMenu,item,RS)          [::msgcat::mc MC(optionMenu,item,RS)]
set gPB(optionMenu,item,C_off_RS)    [::msgcat::mc MC(optionMenu,item,C_off_RS)]
set gPB(optionMenu,item,IPM)         [::msgcat::mc MC(optionMenu,item,IPM)]
set gPB(optionMenu,item,FRN)         [::msgcat::mc MC(optionMenu,item,FRN)]
set gPB(optionMenu,item,IPR)         [::msgcat::mc MC(optionMenu,item,IPR)]
set gPB(optionMenu,item,Auto)        [::msgcat::mc MC(optionMenu,item,Auto)]
set gPB(optionMenu,item,DPM)         [::msgcat::mc MC(optionMenu,item,DPM)]
set gPB(optionMenu,item,Abs_Inc)     [::msgcat::mc MC(optionMenu,item,Abs_Inc)]
set gPB(optionMenu,item,Abs_Only)    [::msgcat::mc MC(optionMenu,item,Abs_Only)]
set gPB(optionMenu,item,Inc_Only)    [::msgcat::mc MC(optionMenu,item,Inc_Only)]
set gPB(optionMenu,item,SD)          [::msgcat::mc MC(optionMenu,item,SD)]
set gPB(optionMenu,item,AP)          [::msgcat::mc MC(optionMenu,item,AP)]
set gPB(optionMenu,item,AN)          [::msgcat::mc MC(optionMenu,item,AN)]
set gPB(optionMenu,item,Z_Axis)      [::msgcat::mc MC(optionMenu,item,Z_Axis)]
set gPB(optionMenu,item,+X_Axis)     [::msgcat::mc MC(optionMenu,item,+X_Axis)]
set gPB(optionMenu,item,-X_Axis)     [::msgcat::mc MC(optionMenu,item,-X_Axis)]
set gPB(optionMenu,item,Y_Axis)      [::msgcat::mc MC(optionMenu,item,Y_Axis)]
set gPB(optionMenu,item,MDD)         [::msgcat::mc MC(optionMenu,item,MDD)]
set gPB(optionMenu,item,SDD)         [::msgcat::mc MC(optionMenu,item,SDD)]




