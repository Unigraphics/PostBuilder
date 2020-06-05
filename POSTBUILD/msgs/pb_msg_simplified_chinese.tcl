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
#
#  <Ex.>
#       ::msgcat::mcset $gPB(LANG) "MC(main,title,Unigraphics)"  "Unigraphics"
#       -------------------------------------------------------  -------------
#                             - Variable -                         - String -
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
# pb10.03
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(msg,filename_with_spec_char)"              "文件名包含不受支持的特殊字符！"
::msgcat::mcset $gPB(LANG) "MC(msg,not_post_comp_file)"                   "可能没有为此包含选择立柱的自有组件！"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,warn_file)"         "警告文件"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,nc_output)"         "NC 输出"

#=============================================================================
# pb10.02
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,check,Label)"           "抑制检查当前后处理"
::msgcat::mcset $gPB(LANG) "MC(main,options,debug,Label)"                 "嵌入后处理调试消息"
::msgcat::mcset $gPB(LANG) "MC(encrypt,suppress,Label)"                   "禁用当前后处理的许可证更改"
::msgcat::mcset $gPB(LANG) "MC(main,title,license_control)"               "许可证控制"

#=============================================================================
# pb902
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(other,ude_include_def,Label)"              "包含其他 CDL 或 DEF 文件"
#-----------------------------------------------------------------------------
# Labels for new tapping cycles
#-----------------------------------------------------------------------------
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_deep,name)"                "深攻丝"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_break_chip,name)"          "断屑攻丝"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_float,name)"                    "浅攻丝"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_deep,name)"                     "深攻丝"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_break_chip,name)"               "断屑攻丝"
#-----------------------------------------------------------------------------
# Defined strings that did not make it to the local language files.
# - These strings should be included for translation in the later release.
#-----------------------------------------------------------------------------
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_change,axis,label)"      "检测到孔之间的刀轴发生更改"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rapid)"               "快进"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,cutting)"             "切削"

#=============================================================================
# pb800
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(event,misc,subop_start,name)"      "子工序刀轨开始"
::msgcat::mcset $gPB(LANG) "MC(event,misc,subop_end,name)"        "子工序刀轨结束"
::msgcat::mcset $gPB(LANG) "MC(event,misc,contour_start,name)"    "轮廓起点"
::msgcat::mcset $gPB(LANG) "MC(event,misc,contour_end,name)"      "轮廓终点"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,misc,Label)"             "杂项"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,lathe_rough,name)"     "车削粗加工"
::msgcat::mcset $gPB(LANG) "MC(main,file,properties,Label)"       "后处理属性"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_CATEGORY)"    "铣床或车床后处理 UDE 可能无法仅通过 \"Wedm\" 类别指定！"

::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_change,label)"   "检测下部的工作平面更改"
::msgcat::mcset $gPB(LANG) "MC(format,check_1,error,msg)"         "格式不适合表达式的值"

::msgcat::mcset $gPB(LANG) "MC(format,check_4,error,msg)"         "在离开或保存此后处理之前更改相关地址的格式！"
::msgcat::mcset $gPB(LANG) "MC(format,check_5,error,msg)"         "在离开此页或保存此后处理之前修改格式！"
::msgcat::mcset $gPB(LANG) "MC(format,check_6,error,msg)"         "在进入此页之前更改相关地址的格式！"

::msgcat::mcset $gPB(LANG) "MC(msg,old_block,maximum_length)"     "以下块的名称超出长度限制："
::msgcat::mcset $gPB(LANG) "MC(msg,old_address,maximum_length)"   "以下文字的名称超出长度限制："
::msgcat::mcset $gPB(LANG) "MC(msg,block_address,check,title)"    "正在检查块和字名称"
::msgcat::mcset $gPB(LANG) "MC(msg,block_address,maximum_length)" "一些块或文字名称超出长度限制。"

::msgcat::mcset $gPB(LANG) "MC(address,maximum_name_msg)"         "字符串长度超出限制。"

::msgcat::mcset $gPB(LANG) "MC(ude,import,oth_list,Label)"        "包括其他 CDL 文件"
::msgcat::mcset $gPB(LANG) "MC(ude,import,oth_list,Context)"      "右键单击鼠标，从弹出菜单中选择\\\"新建\\\"选项以在此后处理中包含其他 CDL 文件。"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_list,Label)"        "从后处理继承 UDE"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_list,Context)"      "右键单击鼠标，从弹出菜单中选择\\\"新建\\\"选项以从后处理继承 UDE 定义和相关处理程序。"
::msgcat::mcset $gPB(LANG) "MC(ude,import,up,Label)"              "向上"
::msgcat::mcset $gPB(LANG) "MC(ude,import,down,Label)"            "向下"
::msgcat::mcset $gPB(LANG) "MC(msg,exist_cdl_file)"               "指定的 CDL 文件已经包含在内！"

::msgcat::mcset $gPB(LANG) "MC(listing,link_var,check,Label)"     "将 Tcl 变量链接至 C 变量"
::msgcat::mcset $gPB(LANG) "MC(listing,link_var,check,Context)"   "可将一组经常更改的 Tcl 变量（例如\\\"mom_pos\\\"）直接链接至内部 C 变量以提高后处理性能。但是，应遵循某些限制以避免 NC 输出中可能出现的错误和差异。"

::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,title)"       "检查线性/旋转运动精度"
::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,linear)"      "格式设置可能不适合输出的\"线性运动精度\"。"
::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,rotary)"      "格式设置可能不适合输出的\"旋转运动精度\"。"

::msgcat::mcset $gPB(LANG) "MC(cmd,export,desc,label)"            "输入已导出定制命令的描述"
::msgcat::mcset $gPB(LANG) "MC(cmd,desc_dlg,title)"               "描述"
::msgcat::mcset $gPB(LANG) "MC(block,delete_row,Label)"           "删除此行中所有活动单元"
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,set,Label)"        "输出条件"
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,new,Label)"        "新建..."
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,edit,Label)"       "编辑..."
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,remove,Label)"     "移除..."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_for_cond)"       "指定其他名称。\n输出条件命令的前缀应为"

::msgcat::mcset $gPB(LANG) "MC(machine,linearization,Label)"         "线性插值"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,angle,Label)"   "旋转角度"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,angle,Context)" "将根据旋转轴起始角度和终止角度的分布来计算插值点。"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,axis,Label)"    "刀轴"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,axis,Context)"  "将根据刀轴起始矢量和终止矢量的分布来计算插值点。"
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,continue,Label)"   "继续"
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,abort,Label)"      "中止"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,def_lintol,Label)"       "默认公差"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,def_lintol,Context)"     "默认线性化公差"
::msgcat::mcset $gPB(LANG) "MC(sub_post,inch,Lable)"                 "IN"
::msgcat::mcset $gPB(LANG) "MC(sub_post,metric,Lable)"               "MM"
::msgcat::mcset $gPB(LANG) "MC(new_sub,title,Label)"                 "新建副后处理器"
::msgcat::mcset $gPB(LANG) "MC(new,sub_post,toggle,label)"           "副后处理"
::msgcat::mcset $gPB(LANG) "MC(new,sub_post,toggle,tmp_label)"       "仅副后处理单位"
::msgcat::mcset $gPB(LANG) "MC(new,unit_post,filename,msg)"          "新建的备选输出单位副后处理的命名方式应为：\n在主后处理名称后面添加 \"__MM\" 或 \"__IN\" 后缀。"
::msgcat::mcset $gPB(LANG) "MC(new,alter_unit,toggle,label)"         "备选输出单位"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,label)"                 "主后处理"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,warning_1,msg)"         "只可使用完整的主后处理来新建副后处理！"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,warning_2,msg)"         "必须在后处理构造器 8.0 或\n更新版本中创建或保存主后处理。"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,specify_err,msg)"       "创建副后处理时必须指定主后处理！"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,alter_unit,Label)"        "副后处理输出单位："
::msgcat::mcset $gPB(LANG) "MC(unit_related_param,tab,Label)"        "单位参数"
::msgcat::mcset $gPB(LANG) "MC(unit_related_param,feed_rate,Label)"  "进给率"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,frame,Label)"        "可选的备选单位副后处理"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,default,Label)"      "默认"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,default,Context)"    "备选单位副后处理的默认名称将是 <后处理名称>__MM 或 <后处理名称>__IN"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,specify,Label)"      "指定"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,specify,Context)"    "指定备选单位副后处理的名称"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,select_name,Label)"  "选择名称"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,warning_1,msg)"      "仅可选择备选单位副后处理！"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,warning_2,msg)"      "选定的副后处理不支持此后处理的备选输出单位！"

::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,post_name,Label)"    "备选单位副后处理"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,post_name,Context)"  "NX 后处理将使用单位副后处理（如果提供）来处理此后处理的备选输出单位。"


##--------------------
## New string in v7.5
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,evt_title)"  "针对轴限制违例的用户定义操作"
::msgcat::mcset $gPB(LANG) "MC(event,helix,name)"                       "螺旋移动"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_param,prefix,msg)"    "地址中使用的表达式"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_param,postfix,msg)"   "不会受此选项更改的影响！"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,default,msg)"          "此操作会将特殊 NC 代码及其处理程序\n的列表恢复到打开或创建此后处理文件时的状态。\n\n要继续吗？"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,restore,msg)"          "此操作会将特殊 NC 代码及其处理程序\n的列表恢复到上次访问此页面时的状态。\n\n要继续吗？"
::msgcat::mcset $gPB(LANG) "MC(msg,block_format_command,paste_err)"     "对象名存在...粘贴无效！"
::msgcat::mcset $gPB(LANG) "MC(main,file,open,choose_cntl_type)"        "选择控制器族"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,no_vnc_cmd,msg)"         "此文件中没有包含新的或不同的 VNC 命令！"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,no_cmd,msg)"             "此文件中没有包含新的或不同的定制命令！"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,name_same_err,Msg)"        "刀具名称不能相同！"
::msgcat::mcset $gPB(LANG) "MC(msg,limit_to_change_license)"            "您不是此后处理的作者。\n您无权对其重命名或更改其许可证。"
::msgcat::mcset $gPB(LANG) "MC(output,other_opts,validation,msg)"       "应指定用户 tcl 文件的名称。"
::msgcat::mcset $gPB(LANG) "MC(machine,empty_entry_err,msg)"            "此参数页面上有空条目。"
::msgcat::mcset $gPB(LANG) "MC(msg,control_v_limit)"                    "您尝试粘贴的字符串可能超出\n了长度限制或者包含了多行或\n无效字符。"
::msgcat::mcset $gPB(LANG) "MC(block,capital_name_msg)"                 "块名称的开头字母不能为大写！\n指定其他名称。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,Label)"      "用户定义"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,Handler)"    "处理程序"
::msgcat::mcset $gPB(LANG) "MC(new,user,file,NOT_EXIST)"                "此用户文件不存在！"
::msgcat::mcset $gPB(LANG) "MC(new,include_vnc,Label)"                  "包含虚拟 NC 控制器"
::msgcat::mcset $gPB(LANG) "MC(other,opt_equal,Label)"                  "等号 (=)"
::msgcat::mcset $gPB(LANG) "MC(event,nurbs,name)"                       "NURBS 移动"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_float,name)"             "浅攻丝"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,thread,name)"                "螺纹加工"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,MSG_NESTED_GROUP)"      "不支持嵌套分组！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bmp,Label)"                   "位图"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bmp,Context)"                 "添加新的位图参数，方法是将它拖到右侧列表中。"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,Label)"                 "分组"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,Context)"               "添加新的分组参数，方法是将它拖到右侧列表中。"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,DESC,Label)"         "描述"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,DESC,Context)"       "指定事件信息"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,URL,Label)"          "URL"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,URL,Context)"        "指定事件描述的 URL"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_IMAGE_FILE)"  "图像文件必须采用 BMP 格式！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)" "位图文件名不应包含目录路径！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_VAR_NAME)"    "变量名称必须以字母开头。"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_KEYWORD)"     "变量名称不应使用关键字： "
::msgcat::mcset $gPB(LANG) "MC(ude,editor,status_label)"                "状态"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,vector,Label)"                "矢量"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,vector,Context)"              "添加新的矢量参数，方法是将它拖到右侧列表中。"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_URL_FORMAT)"        "URL 必须采用 \"http://*\" 或 \"file://*\" 格式，且不使用反斜杠。"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_BLANK_HELP_INFO)"   "必须指定描述和 URL！"
::msgcat::mcset $gPB(LANG) "MC(new,MSG_NO_AXIS)"                        "必须为车床选定轴配置。"
::msgcat::mcset $gPB(LANG) "MC(machine,info,controller_type,Label)"     "控制器族"
::msgcat::mcset $gPB(LANG) "MC(block,func_combo,Label)"                 "宏"
::msgcat::mcset $gPB(LANG) "MC(block,prefix_popup,add,Label)"           "添加前缀文本"
::msgcat::mcset $gPB(LANG) "MC(block,prefix_popup,edit,Label)"          "编辑前缀文本"
::msgcat::mcset $gPB(LANG) "MC(block,prefix,Label)"                     "前缀"
::msgcat::mcset $gPB(LANG) "MC(block,suppress_popup,Label)"             "抑制序号"
::msgcat::mcset $gPB(LANG) "MC(block,custom_func,Label)"                "定制宏"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,macro,Label)"                  "定制宏"
::msgcat::mcset $gPB(LANG) "MC(func,tab,Label)"                         "宏"
::msgcat::mcset $gPB(LANG) "MC(func,exp,msg)"                           "宏参数的表达式不应为空。"
::msgcat::mcset $gPB(LANG) "MC(func,edit,name,Label)"                   "宏名称"
::msgcat::mcset $gPB(LANG) "MC(func,disp_name,Label)"                   "输出名称"
::msgcat::mcset $gPB(LANG) "MC(func,param_list,Label)"                  "参数列表"
::msgcat::mcset $gPB(LANG) "MC(func,separator,Label)"                   "分隔符"
::msgcat::mcset $gPB(LANG) "MC(func,start,Label)"                       "开始字符"
::msgcat::mcset $gPB(LANG) "MC(func,end,Label)"                         "结束字符"
::msgcat::mcset $gPB(LANG) "MC(func,output,name,Label)"                 "输出属性"
::msgcat::mcset $gPB(LANG) "MC(func,output,check,Label)"                "输出参数的名称"
::msgcat::mcset $gPB(LANG) "MC(func,output,link,Label)"                 "链接字符"
::msgcat::mcset $gPB(LANG) "MC(func,col_param,Label)"                   "参数"
::msgcat::mcset $gPB(LANG) "MC(func,col_exp,Label)"                     "表达式"
::msgcat::mcset $gPB(LANG) "MC(func,popup,insert,Label)"                "新建"
::msgcat::mcset $gPB(LANG) "MC(func,name,err_msg)"                      "宏名称不应包含空格！"
::msgcat::mcset $gPB(LANG) "MC(func,name,blank_err)"                    "宏名称不应为空！"
::msgcat::mcset $gPB(LANG) "MC(func,name,contain_err)"                  "宏名称应只包含字母、数字和下划线字符！"
::msgcat::mcset $gPB(LANG) "MC(func,tree_node,start_err)"               "节点名称必须以大写字母开头！"
::msgcat::mcset $gPB(LANG) "MC(func,tree_node,contain_err)"             "节点名称应只接受字母、数字或下划线字符！"
::msgcat::mcset $gPB(LANG) "MC(func,help,Label)"                        "信息"
::msgcat::mcset $gPB(LANG) "MC(func,help,Context)"                      "显示对象的信息。"
::msgcat::mcset $gPB(LANG) "MC(func,help,MSG_NO_INFO)"                  "没有为此宏提供任何信息。"


##------
## Title
##
::msgcat::mcset $gPB(LANG) "MC(main,title,Unigraphics)"             "Unigraphics"
::msgcat::mcset $gPB(LANG) "MC(main,title,UG)"                      "NX"
::msgcat::mcset $gPB(LANG) "MC(main,title,Post_Builder)"            "后处理构造器"

::msgcat::mcset $gPB(LANG) "MC(main,title,Version)"                 "版本"
::msgcat::mcset $gPB(LANG) "MC(main,default,Status)"                "选择“文件”菜单上的“新建”或“打开”选项。"
::msgcat::mcset $gPB(LANG) "MC(main,save,Status)"                   "保存后处理。"

##------
## File
##
::msgcat::mcset $gPB(LANG) "MC(main,file,Label)"                    "文件"

::msgcat::mcset $gPB(LANG) "MC(main,file,Balloon)"                  "\ 新建，打开，保存，\n另存\ 为，关闭和退出"

::msgcat::mcset $gPB(LANG) "MC(main,file,Context)"                  "\ 新建，打开，保存，\n另存\ 为，关闭和退出"
::msgcat::mcset $gPB(LANG) "MC(main,file,menu,Context)"             " "

::msgcat::mcset $gPB(LANG) "MC(main,file,new,Label)"                "新建..."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Balloon)"              "新建后处理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Context)"              "新建后处理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Busy)"                 "正在新建后处理..."

::msgcat::mcset $gPB(LANG) "MC(main,file,open,Label)"               "打开..."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Balloon)"             "编辑现有后处理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Context)"             "编辑现有后处理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Busy)"                "正在打开后处理..."

::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Label)"               "导入 MDFA..."
::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Balloon)"             "从 MDFA 新建后处理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Context)"             "从 MDFA 新建后处理。"

::msgcat::mcset $gPB(LANG) "MC(main,file,save,Label)"               "保存"
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Balloon)"             "保存进行中的后处理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Context)"             "保存进行中的后处理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Busy)"                "正在保存后处理..."

::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Label)"            "另存为..."
::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Balloon)"          "用新名称保存后处理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Context)"          "用新名称保存后处理。"

::msgcat::mcset $gPB(LANG) "MC(main,file,close,Label)"              "关闭"
::msgcat::mcset $gPB(LANG) "MC(main,file,close,Balloon)"            "关闭进行中的后处理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,close,Context)"            "关闭进行中的后处理。"

::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Label)"               "退出"
::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Balloon)"             "终止后处理构造器。"
::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Context)"             "终止后处理构造器。"

::msgcat::mcset $gPB(LANG) "MC(main,file,history,Label)"            "最近打开的后处理"
::msgcat::mcset $gPB(LANG) "MC(main,file,history,Balloon)"          "编辑先前访问过的后处理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,history,Context)"          "编辑在先前后处理构造器会话中访问过的后处理。"

##---------
## Options
##
::msgcat::mcset $gPB(LANG) "MC(main,options,Label)"                 "选项"

::msgcat::mcset $gPB(LANG) "MC(main,options,Balloon)"               " 验证\ 定制\ 命令，备份\ 后处理"
::msgcat::mcset $gPB(LANG) "MC(main,options,Context)"               " "
::msgcat::mcset $gPB(LANG) "MC(main,options,menu,Context)"          " "

::msgcat::mcset $gPB(LANG) "MC(main,windows,Label)"                 "窗口"
::msgcat::mcset $gPB(LANG) "MC(main,windows,Balloon)"               "编辑后处理列表"
::msgcat::mcset $gPB(LANG) "MC(main,windows,Context)"               " "
::msgcat::mcset $gPB(LANG) "MC(main,windows,menu,Context)"          " "

::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Label)"      "属性"
::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Balloon)"    "属性"
::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Context)"    "属性"

::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Label)"         "后处理顾问"
::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Balloon)"       "后处理顾问"
::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Context)"       "启用/禁用后处理顾问。"

::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Label)"       "验证定制命令"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Balloon)"     "验证定制命令"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Context)"     "定制命令验证开关"

::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,syntax,Label)"   "语法错误"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,command,Label)"  "未知命令"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,block,Label)"    "未知块"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,address,Label)"  "未知地址"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,format,Label)"   "未知格式"

::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Label)"          "备份后处理"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Balloon)"        "备份后处理方法"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Context)"        "在保存进行中的后处理时创建备份副本。"

::msgcat::mcset $gPB(LANG) "MC(main,options,backup,one,Label)"      "备份原始对象"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,all,Label)"      "备份每次保存的"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,none,Label)"     "无备份"

##-----------
## Utilities
##
::msgcat::mcset $gPB(LANG) "MC(main,utils,Label)"                   "实用工具"
::msgcat::mcset $gPB(LANG) "MC(main,utils,Balloon)"                 "\ 选择\ MOM\ 变量，安装\ 后处理"
::msgcat::mcset $gPB(LANG) "MC(main,utils,Context)"                 " "
::msgcat::mcset $gPB(LANG) "MC(main,utils,menu,Context)"            " "

::msgcat::mcset $gPB(LANG) "MC(main,utils,etpdf,Label)"             "编辑模板后处理数据文件"

::msgcat::mcset $gPB(LANG) "MC(main,utils,bmv,Label)"               "浏览 MOM 变量"
::msgcat::mcset $gPB(LANG) "MC(main,utils,blic,Label)"              "浏览许可证"


##------
## Help
##
::msgcat::mcset $gPB(LANG) "MC(main,help,Label)"                    "帮助"
::msgcat::mcset $gPB(LANG) "MC(main,help,Balloon)"                  "帮助选项"
::msgcat::mcset $gPB(LANG) "MC(main,help,Context)"                  "帮助选项"
::msgcat::mcset $gPB(LANG) "MC(main,help,menu,Context)"             " "

::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Label)"                "符号标注提示"
::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Balloon)"              "图标上的符号标注提示"
::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Context)"              "启用/禁用图标上的符号标注工具提示显示。"

::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Label)"              "上下文关联帮助"
::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Balloon)"            "对话框项的相关上下文关联帮助"
::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Context)"            "对话框项的相关上下文关联帮助"

::msgcat::mcset $gPB(LANG) "MC(main,help,what,Label)"               "执行什么操作？"
::msgcat::mcset $gPB(LANG) "MC(main,help,what,Balloon)"             "此处您能执行什么操作？"
::msgcat::mcset $gPB(LANG) "MC(main,help,what,Context)"             "此处您能执行什么操作？"

::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Label)"             "对话框相关帮助"
::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Balloon)"           "该对话框的相关帮助"
::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Context)"           "该对话框的相关帮助"

::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Label)"             "用户手册"
::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Balloon)"           "用户帮助手册"
::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Context)"           "用户帮助手册"

::msgcat::mcset $gPB(LANG) "MC(main,help,about,Label)"              "关于后处理构造器"
::msgcat::mcset $gPB(LANG) "MC(main,help,about,Balloon)"            "关于后处理构造器"
::msgcat::mcset $gPB(LANG) "MC(main,help,about,Context)"            "关于后处理构造器"

::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Label)"           "发行说明"
::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Balloon)"         "发行说明"
::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Context)"         "发行说明"

::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Label)"            "Tcl/Tk 参考手册"
::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Balloon)"          "Tcl/Tk 参考手册"
::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Context)"          "Tcl/Tk 参考手册"

##----------
## Tool Bar
##
::msgcat::mcset $gPB(LANG) "MC(tool,new,Label)"                     "新建"
::msgcat::mcset $gPB(LANG) "MC(tool,new,Context)"                   "新建后处理。"

::msgcat::mcset $gPB(LANG) "MC(tool,open,Label)"                    "打开"
::msgcat::mcset $gPB(LANG) "MC(tool,open,Context)"                  "编辑现有后处理。"

::msgcat::mcset $gPB(LANG) "MC(tool,save,Label)"                    "保存"
::msgcat::mcset $gPB(LANG) "MC(tool,save,Context)"                  "保存进行中的后处理。"

::msgcat::mcset $gPB(LANG) "MC(tool,bal,Label)"                     "符号标注提示"
::msgcat::mcset $gPB(LANG) "MC(tool,bal,Context)"                   "启用/禁用图标上的符号标注工具提示显示。"

::msgcat::mcset $gPB(LANG) "MC(tool,chelp,Label)"                   "上下文关联帮助"
::msgcat::mcset $gPB(LANG) "MC(tool,chelp,Context)"                 "对话框项的相关上下文关联帮助"

::msgcat::mcset $gPB(LANG) "MC(tool,what,Label)"                    "执行什么操作？"
::msgcat::mcset $gPB(LANG) "MC(tool,what,Context)"                  "此处您能执行什么操作？"

::msgcat::mcset $gPB(LANG) "MC(tool,dialog,Label)"                  "对话框相关帮助"
::msgcat::mcset $gPB(LANG) "MC(tool,dialog,Context)"                "该对话框的相关帮助"

::msgcat::mcset $gPB(LANG) "MC(tool,manual,Label)"                  "用户手册"
::msgcat::mcset $gPB(LANG) "MC(tool,manual,Context)"                "用户帮助手册"

#=============
# Main Window
#=============

##-----------------
## Common Messages
##
::msgcat::mcset $gPB(LANG) "MC(msg,error,title)"                    "后处理构造器错误"
::msgcat::mcset $gPB(LANG) "MC(msg,dialog,title)"                   "后处理构造器消息"
::msgcat::mcset $gPB(LANG) "MC(msg,warning)"                        "警告"
::msgcat::mcset $gPB(LANG) "MC(msg,error)"                          "错误"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_data)"                   "针对此参数键入的数据无效"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_browser_cmd)"            "无效的浏览器命令："
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_filename)"                 "文件名已更改！"
::msgcat::mcset $gPB(LANG) "MC(msg,user_ctrl_limit)"                "如果您不是作者，则不能使用经许可的\n后处理作为控制器来创建新的后处理！"
::msgcat::mcset $gPB(LANG) "MC(msg,import_limit)"                   "您不是此许可后处理的作者。\n不能导入定制命令！"
::msgcat::mcset $gPB(LANG) "MC(msg,limit_msg)"                      "您不是此许可后处理的作者。"
::msgcat::mcset $gPB(LANG) "MC(msg,no_file)"                        "缺少此许可后处理的加密文件！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license)"                     "您没有可执行此功能的合适许可证！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license_title)"               "NX/后处理构造器无许可证使用"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license_dialog)"              "允许您在没有合适许可证的\n情况下使用 NX/后处理构造器。\n但您不能保存后续工作。"
::msgcat::mcset $gPB(LANG) "MC(msg,pending)"                        "将在以后的发行版中实现此选项的使用。"
::msgcat::mcset $gPB(LANG) "MC(msg,save)"                           "要在关闭进行中的后处理之前\n保存更改吗？"
::msgcat::mcset $gPB(LANG) "MC(msg,version_check)"                  "在该版本中不能打开用较新版本后处理构造器创建的后处理。"

::msgcat::mcset $gPB(LANG) "MC(msg,file_corruption)"                "后处理构造器会话文件中的内容不正确。"
::msgcat::mcset $gPB(LANG) "MC(msg,bad_tcl_file)"                   "后处理 Tcl 文件中的内容不正确。"
::msgcat::mcset $gPB(LANG) "MC(msg,bad_def_file)"                   "后处理定义文件中的内容不正确。"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_post)"                   "必须为您的后处理指定至少一组 Tcl 和定义文件。"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_dir)"                    "目录不存在。"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_file)"                   "文件未找到或无效。"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_def_file)"               "不能打开定义文件"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_tcl_file)"               "不能打开事件处理程序文件"
::msgcat::mcset $gPB(LANG) "MC(msg,dir_perm)"                       "您不具备此目录的写权限："
::msgcat::mcset $gPB(LANG) "MC(msg,file_perm)"                      "您无权写入到"

::msgcat::mcset $gPB(LANG) "MC(msg,file_exist)"                     "已经存在！\n要替换它们吗？"
::msgcat::mcset $gPB(LANG) "MC(msg,file_missing)"                   "缺少此后处理的部分或全部文件。\n您不能打开此后处理。"
::msgcat::mcset $gPB(LANG) "MC(msg,sub_dialog_open)"                "保存后处理之前，必须完成对所有参数子对话框的编辑！"
::msgcat::mcset $gPB(LANG) "MC(msg,generic)"                        "目前仅对常规铣床实现了后处理构造器。"
::msgcat::mcset $gPB(LANG) "MC(msg,min_word)"                       "一个块应至少包含一个文字。"
::msgcat::mcset $gPB(LANG) "MC(msg,name_exists)"                    "已经存在！\n请指定其他名称。"
::msgcat::mcset $gPB(LANG) "MC(msg,in_use)"                         "此组件正在使用中。\n无法将其删除。"
::msgcat::mcset $gPB(LANG) "MC(msg,do_you_want_to_proceed)"         "您可以将它们认为是现有数据单元，然后继续。"
::msgcat::mcset $gPB(LANG) "MC(msg,not_installed_properly)"         "未正确安装。"
::msgcat::mcset $gPB(LANG) "MC(msg,no_app_to_open)"                 "没有要打开的应用模块"
::msgcat::mcset $gPB(LANG) "MC(msg,save_change)"                    "要保存更改吗？"

::msgcat::mcset $gPB(LANG) "MC(msg,external_editor)"                "外部编辑器"

# - Do not translate EDITOR
::msgcat::mcset $gPB(LANG) "MC(msg,set_ext_editor)"                 "您可以使用环境变量 EDITOR 以激活您所需的文本编辑器。"
::msgcat::mcset $gPB(LANG) "MC(msg,filename_with_space)"            "不支持包含空格的文件名！"
::msgcat::mcset $gPB(LANG) "MC(msg,filename_protection)"            "不能覆盖由某个编辑后处理所使用的选定文件！"


##--------------------
## Common Function
##
::msgcat::mcset $gPB(LANG) "MC(msg,parent_win)"                     "瞬态窗口要求已定义其父窗口。"
::msgcat::mcset $gPB(LANG) "MC(msg,close_subwin)"                   "您必须关闭所有子窗口才能启用该选项卡。"
::msgcat::mcset $gPB(LANG) "MC(msg,block_exist)"                    "选定的文字单元在块模板中已经存在。"
::msgcat::mcset $gPB(LANG) "MC(msg,num_gcode_1)"                    "G 代码数量限制为"
::msgcat::mcset $gPB(LANG) "MC(msg,num_gcode_2)"                    "/块"
::msgcat::mcset $gPB(LANG) "MC(msg,num_mcode_1)"                    "M 代码数量限制为"
::msgcat::mcset $gPB(LANG) "MC(msg,num_mcode_2)"                    "/块"
::msgcat::mcset $gPB(LANG) "MC(msg,empty_entry)"                    "条目不应为空。"

::msgcat::mcset $gPB(LANG) "MC(msg,edit_feed_fmt)"                  "地址 \"F\" 的格式可以在“进给率”参数页面上编辑"

::msgcat::mcset $gPB(LANG) "MC(msg,seq_num_max)"                    "序列号的最大值不能超过地址 N 的容量："

::msgcat::mcset $gPB(LANG) "MC(msg,no_cdl_name)"                    "应指定后处理名称！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_def_name)"                    "应指定文件夹！\n样式应类似于 \"\$UGII_*\"！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_own_name)"                    "应指定文件夹！\n样式应类似于 \"\$UGII_*\"！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_oth_ude_name)"                "应指定其他 cdl 文件名！\n样式应类似于 \"\$UGII_*\"！"
::msgcat::mcset $gPB(LANG) "MC(msg,not_oth_cdl_file)"               "只允许 CDL 文件！"
::msgcat::mcset $gPB(LANG) "MC(msg,not_pui_file)"                   "只允许 PUI 文件！"
::msgcat::mcset $gPB(LANG) "MC(msg,not_cdl_file)"                   "只允许 CDL 文件！"
::msgcat::mcset $gPB(LANG) "MC(msg,not_def_file)"                   "只允许 DEF 文件！"
::msgcat::mcset $gPB(LANG) "MC(msg,not_own_cdl_file)"               "只允许自身 CDL 文件！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_cdl_file)"                    "选定的后处理不具备关联的 CDL 文件。"
::msgcat::mcset $gPB(LANG) "MC(msg,cdl_info)"                       "选定后处理的 CDL 和定义文件将在该后处理的定义文件中被引用（包含）。\n选定后处理的 Tcl 文件还将在运行时被事件处理程序文件参考。"

::msgcat::mcset $gPB(LANG) "MC(msg,add_max1)"                       "地址的最大值"
::msgcat::mcset $gPB(LANG) "MC(msg,add_max2)"                       "不能超过其格式的容量："


::msgcat::mcset $gPB(LANG) "MC(com,text_entry_trans,title,Label)"   "条目"

##---------------------------
## Common Navigation Buttons
##
::msgcat::mcset $gPB(LANG) "MC(nav_button,no_license,Message)"      "您没有可执行此功能的合适许可证！"

::msgcat::mcset $gPB(LANG) "MC(nav_button,ok,Label)"                "确定"
::msgcat::mcset $gPB(LANG) "MC(nav_button,ok,Context)"              "此按钮仅在子对话框上可用。它允许您保存更改并取消此对话框。"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cancel,Label)"            "取消"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cancel,Context)"          "此按钮在子对话框上可用。它允许您取消此对话框。"
::msgcat::mcset $gPB(LANG) "MC(nav_button,default,Label)"           "默认"
::msgcat::mcset $gPB(LANG) "MC(nav_button,default,Context)"         "此按钮允许您将某组件当前对话框上的参数恢复到首次创建或打开会话中的后处理时的状态。\n \n但如果存在有问题的组件，则其名称只能恢复为此组件当前访问时的初始状态。"
::msgcat::mcset $gPB(LANG) "MC(nav_button,restore,Label)"           "恢复"
::msgcat::mcset $gPB(LANG) "MC(nav_button,restore,Context)"         "此按钮允许您将当前对话框上的参数恢复到您当前访问此组件时的初始设置。"
::msgcat::mcset $gPB(LANG) "MC(nav_button,apply,Label)"             "应用"
::msgcat::mcset $gPB(LANG) "MC(nav_button,apply,Context)"           "此按钮允许您保存更改而不取消当前对话框。此操作还会重新建立当前对话框的初始状态。\n \n（如果需要初始状态，请参考“恢复”）"
::msgcat::mcset $gPB(LANG) "MC(nav_button,filter,Label)"            "过滤"
::msgcat::mcset $gPB(LANG) "MC(nav_button,filter,Context)"          "此按钮将应用目录过滤器并列出满足条件的文件。"
::msgcat::mcset $gPB(LANG) "MC(nav_button,yes,Label)"               "是"
::msgcat::mcset $gPB(LANG) "MC(nav_button,yes,Context)"             "是"
::msgcat::mcset $gPB(LANG) "MC(nav_button,no,Label)"                "否"
::msgcat::mcset $gPB(LANG) "MC(nav_button,no,Context)"              "否"
::msgcat::mcset $gPB(LANG) "MC(nav_button,help,Label)"              "帮助"
::msgcat::mcset $gPB(LANG) "MC(nav_button,help,Context)"            "帮助"

::msgcat::mcset $gPB(LANG) "MC(nav_button,open,Label)"              "打开"
::msgcat::mcset $gPB(LANG) "MC(nav_button,open,Context)"            "此按钮允许您打开选定的后处理以编辑。"

::msgcat::mcset $gPB(LANG) "MC(nav_button,save,Label)"              "保存"
::msgcat::mcset $gPB(LANG) "MC(nav_button,save,Context)"            "此按钮在“另存为”对话框上可用，它允许您保存进行中的后处理。"

::msgcat::mcset $gPB(LANG) "MC(nav_button,manage,Label)"            "管理..."
::msgcat::mcset $gPB(LANG) "MC(nav_button,manage,Context)"          "此按钮允许您管理最近访问的后处理历史记录。"

::msgcat::mcset $gPB(LANG) "MC(nav_button,refresh,Label)"           "刷新"
::msgcat::mcset $gPB(LANG) "MC(nav_button,refresh,Context)"         "此按钮将根据对象的存在情况刷新列表。"

::msgcat::mcset $gPB(LANG) "MC(nav_button,cut,Label)"               "剪切"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cut,Context)"             "此按钮将从列表中剪切选定的对象。"

::msgcat::mcset $gPB(LANG) "MC(nav_button,copy,Label)"              "复制"
::msgcat::mcset $gPB(LANG) "MC(nav_button,copy,Context)"            "此按钮将复制选定的对象。"

::msgcat::mcset $gPB(LANG) "MC(nav_button,paste,Label)"             "粘贴"
::msgcat::mcset $gPB(LANG) "MC(nav_button,paste,Context)"           "此按钮将缓冲区的对象粘贴回列表。"

::msgcat::mcset $gPB(LANG) "MC(nav_button,edit,Label)"              "编辑"
::msgcat::mcset $gPB(LANG) "MC(nav_button,edit,Context)"            "此按钮将编辑缓冲区的对象！"

::msgcat::mcset $gPB(LANG) "MC(nav_button,ex_editor,Label)"         "使用外部编辑器"

##------------
## New dialog
##
::msgcat::mcset $gPB(LANG) "MC(new,title,Label)"                    "新建后处理器"
::msgcat::mcset $gPB(LANG) "MC(new,Status)"                         "输入名称并选择“新建后处理”的参数。"

::msgcat::mcset $gPB(LANG) "MC(new,name,Label)"                     "后处理名称"
::msgcat::mcset $gPB(LANG) "MC(new,name,Context)"                   "要创建的后处理器的名称"

::msgcat::mcset $gPB(LANG) "MC(new,desc,Label)"                     "描述"
::msgcat::mcset $gPB(LANG) "MC(new,desc,Context)"                   "要创建的后处理器的描述"

#Description for each selection
::msgcat::mcset $gPB(LANG) "MC(new,mill,desc,Label)"                "这是铣床。"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,desc,Label)"               "这是车床。"
::msgcat::mcset $gPB(LANG) "MC(new,wedm,desc,Label)"                "这是线切割机床。"

::msgcat::mcset $gPB(LANG) "MC(new,wedm_2,desc,Label)"              "这是 2 轴线切割机床。"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_4,desc,Label)"              "这是 4 轴线切割机床。"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_2,desc,Label)"             "这是 2 轴水平车床。"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_4,desc,Label)"             "这是 4 轴关联车床。"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3,desc,Label)"              "这是 3 轴铣床。"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3MT,desc,Label)"            "3 轴车铣 (XZC)"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4H,desc,Label)"             "这是带转头的 4 轴\n铣床。"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4T,desc,Label)"             "这是带转台的 4 轴\n铣床。"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5TT,desc,Label)"            "这是带双转台的 5 轴\n铣床。"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HH,desc,Label)"            "这是带双转头的 5 轴\n铣床。"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HT,desc,Label)"            "这是带转头和转台的 5 轴\n铣床。"
::msgcat::mcset $gPB(LANG) "MC(new,punch,desc,Label)"               "这是冲压机床。"

::msgcat::mcset $gPB(LANG) "MC(new,post_unit,Label)"                "后处理输出单位"

::msgcat::mcset $gPB(LANG) "MC(new,inch,Label)"                     "英寸"
::msgcat::mcset $gPB(LANG) "MC(new,inch,Context)"                   "后处理器输出单位英寸"
::msgcat::mcset $gPB(LANG) "MC(new,millimeter,Label)"               "毫米"
::msgcat::mcset $gPB(LANG) "MC(new,millimeter,Context)"             "后处理器输出单位毫米"

::msgcat::mcset $gPB(LANG) "MC(new,machine,Label)"                  "机床"
::msgcat::mcset $gPB(LANG) "MC(new,machine,Context)"                "要为其创建后处理器的机床类型。"

::msgcat::mcset $gPB(LANG) "MC(new,mill,Label)"                     "铣"
::msgcat::mcset $gPB(LANG) "MC(new,mill,Context)"                   "铣床"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,Label)"                    "车"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,Context)"                  "车床"
::msgcat::mcset $gPB(LANG) "MC(new,wire,Label)"                     "线切割"
::msgcat::mcset $gPB(LANG) "MC(new,wire,Context)"                   "线切割机床"
::msgcat::mcset $gPB(LANG) "MC(new,punch,Label)"                    "冲压"

::msgcat::mcset $gPB(LANG) "MC(new,axis,Label)"                     "机床轴选择"
::msgcat::mcset $gPB(LANG) "MC(new,axis,Context)"                   "机床轴的数量和类型"

#Axis Number
::msgcat::mcset $gPB(LANG) "MC(new,axis_2,Label)"                   "2 轴"
::msgcat::mcset $gPB(LANG) "MC(new,axis_3,Label)"                   "3 轴"
::msgcat::mcset $gPB(LANG) "MC(new,axis_4,Label)"                   "4 轴"
::msgcat::mcset $gPB(LANG) "MC(new,axis_5,Label)"                   "5 轴"
::msgcat::mcset $gPB(LANG) "MC(new,axis_XZC,Label)"                 "XZC"


#Axis Type
::msgcat::mcset $gPB(LANG) "MC(new,mach_axis,Label)"                "机床轴"
::msgcat::mcset $gPB(LANG) "MC(new,mach_axis,Context)"              "选择机床轴"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_2,Label)"                  "2 轴"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3,Label)"                   "3 轴"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3MT,Label)"                 "3 轴车铣 (XZC)"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4T,Label)"                  "4 轴带转台"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4H,Label)"                  "4 轴带转头"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_4,Label)"                  "4 轴"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HH,Label)"                 "5 轴带双转头"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5TT,Label)"                 "5 轴带双转台"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HT,Label)"                 "5 轴带转头和转台"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_2,Label)"                   "2 轴"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_4,Label)"                   "4 轴"
::msgcat::mcset $gPB(LANG) "MC(new,punch,Label)"                    "冲压"

::msgcat::mcset $gPB(LANG) "MC(new,control,Label)"                  "控制器"
::msgcat::mcset $gPB(LANG) "MC(new,control,Context)"                "选择后处理控制器。"

#Controller Type
::msgcat::mcset $gPB(LANG) "MC(new,generic,Label)"                  "一般"
::msgcat::mcset $gPB(LANG) "MC(new,library,Label)"                  "库"
::msgcat::mcset $gPB(LANG) "MC(new,user,Label)"                     "用户"
::msgcat::mcset $gPB(LANG) "MC(new,user,browse,Label)"              "浏览"

# - Machine tool/ controller brands
::msgcat::mcset $gPB(LANG) "MC(new,allen,Label)"                    "Allen Bradley"
::msgcat::mcset $gPB(LANG) "MC(new,bridge,Label)"                   "Bridgeport"
::msgcat::mcset $gPB(LANG) "MC(new,brown,Label)"                    "Brown & Sharp"
::msgcat::mcset $gPB(LANG) "MC(new,cincin,Label)"                   "Cincinnatti Milacron"
::msgcat::mcset $gPB(LANG) "MC(new,kearny,Label)"                   "Kearny & Tracker"
::msgcat::mcset $gPB(LANG) "MC(new,fanuc,Label)"                    "Fanuc"
::msgcat::mcset $gPB(LANG) "MC(new,ge,Label)"                       "General Electric"
::msgcat::mcset $gPB(LANG) "MC(new,gn,Label)"                       "General Numerics"
::msgcat::mcset $gPB(LANG) "MC(new,gidding,Label)"                  "Gidding & Lewis"
::msgcat::mcset $gPB(LANG) "MC(new,heiden,Label)"                   "Heidenhain"
::msgcat::mcset $gPB(LANG) "MC(new,mazak,Label)"                    "Mazak"
::msgcat::mcset $gPB(LANG) "MC(new,seimens,Label)"                  "Siemens"

##-------------
## Open dialog
##
::msgcat::mcset $gPB(LANG) "MC(open,title,Label)"                   "编辑后处理"
::msgcat::mcset $gPB(LANG) "MC(open,Status)"                        "选择要打开的 PUI 文件。"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_pui)"                 "后处理构造器会话文件"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_tcl)"                 "Tcl 脚本文件"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_def)"                 "定义文件"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_cdl)"                 "CDL 文件"

##-------------
## Misc dialog
##
::msgcat::mcset $gPB(LANG) "MC(open_save,dlg,title,Label)"          "选择文件"
::msgcat::mcset $gPB(LANG) "MC(exp_cc,dlg,title,Label)"             "导出定制命令"
::msgcat::mcset $gPB(LANG) "MC(show_mt,title,Label)"                "机床"

##----------------
## Utils dialog
##
::msgcat::mcset $gPB(LANG) "MC(mvb,title,Label)"                    "MOM 变量浏览器"
::msgcat::mcset $gPB(LANG) "MC(mvb,cat,Label)"                      "类别"
::msgcat::mcset $gPB(LANG) "MC(mvb,search,Label)"                   "搜索"
::msgcat::mcset $gPB(LANG) "MC(mvb,defv,Label)"                     "默认值"
::msgcat::mcset $gPB(LANG) "MC(mvb,posv,Label)"                     "可行值"
::msgcat::mcset $gPB(LANG) "MC(mvb,data,Label)"                     "数据类型"
::msgcat::mcset $gPB(LANG) "MC(mvb,desc,Label)"                     "描述"

::msgcat::mcset $gPB(LANG) "MC(inposts,title,Label)"                "编辑 template_post.dat"
::msgcat::mcset $gPB(LANG) "MC(tpdf,text,Label)"                    "模板后处理数据文件"
::msgcat::mcset $gPB(LANG) "MC(inposts,edit,title,Label)"           "编辑行"
::msgcat::mcset $gPB(LANG) "MC(inposts,edit,post,Label)"            "后处理"


##----------------
## Save As dialog
##
::msgcat::mcset $gPB(LANG) "MC(save_as,title,Label)"                "另存为"
::msgcat::mcset $gPB(LANG) "MC(save_as,name,Label)"                 "后处理名称"
::msgcat::mcset $gPB(LANG) "MC(save_as,name,Context)"               "后处理器要另存为的名称。"
::msgcat::mcset $gPB(LANG) "MC(save_as,Status)"                     "输入新的后处理文件名。"
::msgcat::mcset $gPB(LANG) "MC(save_as,file_type_pui)"              "后处理构造器会话文件"

##----------------
## Common Widgets
##
::msgcat::mcset $gPB(LANG) "MC(common,entry,Label)"                 "条目"
::msgcat::mcset $gPB(LANG) "MC(common,entry,Context)"               "您将在条目字段指定新值。"

##-----------
## Note Book
##
::msgcat::mcset $gPB(LANG) "MC(nbook,tab,Label)"                    "笔记本选项卡"
::msgcat::mcset $gPB(LANG) "MC(nbook,tab,Context)"                  "您可以选择一个选项卡以转至您需要的参数页面。\n\n一个选项卡下面的参数可能会分为几组。可以通过另一选项卡访问各组参数。"

##------
## Tree
##
::msgcat::mcset $gPB(LANG) "MC(tree,select,Label)"                  "组件树"
::msgcat::mcset $gPB(LANG) "MC(tree,select,Context)"                "您可以选择一个组件以查看或编辑其内容或参数。"
::msgcat::mcset $gPB(LANG) "MC(tree,create,Label)"                  "创建"
::msgcat::mcset $gPB(LANG) "MC(tree,create,Context)"                "通过复制选定的项来创建新组件。"
::msgcat::mcset $gPB(LANG) "MC(tree,cut,Label)"                     "剪切"
::msgcat::mcset $gPB(LANG) "MC(tree,cut,Context)"                   "剪切组件。"
::msgcat::mcset $gPB(LANG) "MC(tree,paste,Label)"                   "粘贴"
::msgcat::mcset $gPB(LANG) "MC(tree,paste,Context)"                 "粘贴组件。"
::msgcat::mcset $gPB(LANG) "MC(tree,rename,Label)"                  "重命名"

##------------------
## Encrypt dialogs
##
::msgcat::mcset $gPB(LANG) "MC(encrypt,browser,Label)"              "许可证列表"
::msgcat::mcset $gPB(LANG) "MC(encrypt,title,Label)"                "选择许可证"
::msgcat::mcset $gPB(LANG) "MC(encrypt,output,Label)"               "加密输出"
::msgcat::mcset $gPB(LANG) "MC(encrypt,license,Label)"              "许可证：  "

#++++++++++++++
# Machine Tool
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(machine,tab,Label)"                  "机床"
::msgcat::mcset $gPB(LANG) "MC(machine,Status)"                     "指定机床运动学参数。"

::msgcat::mcset $gPB(LANG) "MC(msg,no_display)"                     "此机床配置的图像不可用。"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_ctable)"                  "第 4 轴 C 加工台不受允许。"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_max_min)"                 "第 4 轴最大轴限制不能等于最小轴限制！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_both_neg)"                "第 4 轴限制不能都为负！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_5th_plane)"               "第 4 轴的平面不能与第 5 轴的相同。"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4thT_5thH)"                   "第 4 轴加工台和第 5 轴机头不受允许。"
::msgcat::mcset $gPB(LANG) "MC(msg,no_5th_max_min)"                 "第 5 轴最大轴限制不能等于最小轴限制！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_5th_both_neg)"                "第 5 轴限制不能都为负！"

##---------
# Post Info
##
::msgcat::mcset $gPB(LANG) "MC(machine,info,title,Label)"           "后处理信息"
::msgcat::mcset $gPB(LANG) "MC(machine,info,desc,Label)"            "描述"
::msgcat::mcset $gPB(LANG) "MC(machine,info,type,Label)"            "机床类型"
::msgcat::mcset $gPB(LANG) "MC(machine,info,kinematics,Label)"      "运动学"
::msgcat::mcset $gPB(LANG) "MC(machine,info,unit,Label)"            "输出单位"
::msgcat::mcset $gPB(LANG) "MC(machine,info,controller,Label)"      "控制器"
::msgcat::mcset $gPB(LANG) "MC(machine,info,history,Label)"         "历史记录"

##---------
## Display
##
::msgcat::mcset $gPB(LANG) "MC(machine,display,Label)"              "显示机床"
::msgcat::mcset $gPB(LANG) "MC(machine,display,Context)"            "此选项显示机床"
::msgcat::mcset $gPB(LANG) "MC(machine,display_trans,title,Label)"  "机床"


##---------------
## General parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,gen,Label)"                      "一般参数"
    
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,Label)"             "后处理输出单位："
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,Context)"           "后处理输出单位"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,inch,Label)"        "英制" 
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,metric,Label)"      "公制"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,Label)"         "线性轴行程限制"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,Context)"       "线性轴行程限制"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,x,Label)"       "X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,x,Context)"     "指定机床沿 X 轴的行程限制。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,y,Label)"       "Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,y,Context)"     "指定机床沿 Y 轴的行程限制。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,z,Label)"       "Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,z,Context)"     "指定机床沿 Z 轴的行程限制。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,Label)"             "回零位置"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,Context)"           "回零位置"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,x,Label)"           "X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,x,Context)"         "机床相对于 X 轴物理零位置的 X 轴回零位置。机床返回此位置以自动换刀。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,y,Label)"           "Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,y,Context)"         "机床相对于 Y 轴物理零位置的 Y 轴回零位置。机床返回此位置以自动换刀。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,z,Label)"           "Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,z,Context)"         "机床相对于 Z 轴物理零位置的 Z 轴回零位置。机床返回此位置以自动换刀。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,Label)"            "线性运动精度"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,min,Label)"        "最小值"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,min,Context)"      "最小精度"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,Label)"        "移刀进给率"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,max,Label)"    "最大值"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,max,Context)"  "最大进给率"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,Label)"        "输出循环记录"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,yes,Label)"    "是"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,yes,Context)"  "输出循环记录。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,no,Label)"     "否"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,no,Context)"   "输出线性记录。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,config_4and5_axis,oth,Label)"    "其他"

# Wire EDM parameters
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,wire_tilt)"             "线侧倾控制"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,angle)"                 "角度"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,coord)"                 "坐标"

# Lathe parameters
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,Label)"               "转塔"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,Context)"             "转塔"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf,Label)"          "配置"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf,Context)"        "选择两个转塔时，此选项允许您配置参数。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,one,Label)"           "单转塔"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,one,Context)"         "单转塔车床"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,two,Label)"           "双转塔"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,two,Context)"         "双转塔车床"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf_trans,Label)"    "转塔配置"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,prim,Label)"          "主转塔"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,prim,Context)"        "选择主转塔的名称。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,sec,Label)"           "辅助转塔"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,sec,Context)"         "选择辅助转塔的名称。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,designation,Label)"   "名称"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,xoff,Label)"          "X 偏置"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,xoff,Context)"        "指定 X 偏置。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,zoff,Label)"          "Z 偏置"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,zoff,Context)"        "指定 Z 偏置。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,front,Label)"         "前"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,rear,Label)"          "后"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,right,Label)"         "右"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,left,Label)"          "左"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,side,Label)"          "侧"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,saddle,Label)"        "鞍型"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,Label)"           "轴乘数"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,dia,Label)"       "直径编程"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,dia,Context)"     "这些选项允许您通过翻倍 N/C 输出中选定地址的值，启用直径编程。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2x,Label)"        "2X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2x,Context)"      "此开关允许您通过翻倍 N/C 输出中的 X 轴坐标，启用直径编程。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2y,Label)"        "2Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2y,Context)"      "此开关允许您通过翻倍 N/C 输出中的 Y 轴坐标，启用直径编程。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2i,Label)"        "2I"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2i,Context)"      "此开关允许您在使用直径编程时将循环记录的 I 值翻倍。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2j,Label)"        "2J"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2j,Context)"      "此开关允许您在使用直径编程时将循环记录的 J 值翻倍。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,mir,Label)"       "镜像输出"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,mir,Context)"     "这些选项允许您通过使其在 N/C 输出中的值为负，镜像选定的地址。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,x,Label)"         "-X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,x,Context)"       "此开关允许您使 N/C 输出中的 X 轴坐标为负。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,y,Label)"         "-Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,y,Context)"       "此开关允许您使 N/C 输出中的 Y 轴坐标为负。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,z,Label)"         "-Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,z,Context)"       "此开关允许您使 N/C 输出中的 Z 轴坐标为负。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,i,Label)"         "-I"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,i,Context)"       "此开关允许您使 N/C 输出中的循环记录 I 值为负。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,j,Label)"         "-J"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,j,Context)"       "此开关允许您使 N/C 输出中的循环记录 J 值为负。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,k,Label)"         "-K"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,k,Context)"       "此开关允许您使 N/C 输出中的循环记录 K 值为负。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,Label)"               "输出方法"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,Context)"             "输出方法"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,tool_tip,Label)"      "刀尖"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,tool_tip,Context)"    "相对于刀尖的输出"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,turret_ref,Label)"    "转塔参考"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,turret_ref,Context)"  "相对于转塔参考的输出"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_turret,msg)"           "主转塔的名称不能与辅助转塔的相同。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret_chg,msg)"             "更改此选项可能需要在换刀事件中添加或删除一个 G92 块。"
# Entries for XZC/Mill-Turn
::msgcat::mcset $gPB(LANG) "MC(machine,gen,spindle_axis,Label)"             "初始主轴"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,spindle_axis,Context)"           "实时铣刀的初始主轴可以指定为平行于或垂直于 Z 轴。工序的刀轴必须与指定的主轴一致。如果后处理不能定位到指定的主轴，则会出错。\n此矢量可能会被机头对象指定的主轴替代。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,position_in_yaxis,Label)"        "Y 轴中的位置"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,position_in_yaxis,Context)"      "机床具备一个可编程的 Y 轴，它可以在轮廓加工时定位。此选项仅在主轴不是沿 Z 轴时适用。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,Label)"                "机床模式"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,Context)"              "机床模式可以是 XZC 铣或简单车铣。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,xzc_mill,Label)"       "XZC 铣"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,xzc_mill,Context)"     "XZC 铣将有一个加工台或卡盘面锁定在车铣机床上，作为旋转 C 轴。所有 XY 移动都转换至 X 和 C，其中 X 为半径值，C 为角度。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,mill_turn,Label)"      "简单车铣"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,mill_turn,Context)"    "此 XZC 铣后处理将与车后处理相链接，以处理包含铣削和车削工序的程序。工序类型将决定使用哪个后处理生成 N/C 输出。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mill_turn,lathe_post,Label)"     "车后处理"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mill_turn,lathe_post,Context)"   "简单车铣后处理需要车后处理以对程序中的车削工序进行后处理。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_post,select_name,Label)"   "选择名称"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_post,select_name,Context)" "选择要用于简单车铣后处理的车后处理的名称。此后处理很可能在 NX/后处理运行时的 \\\$UGII_CAM_POST_DIR 目录中，否则将使用在铣后处理所在目录中同名的后处理。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,Label)"               "默认坐标模式"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,Context)"             "此选项将坐标输出模式的初始设置定义为极坐标 (XZC) 或笛卡尔坐标 (XYZ)。此模式可以通过由工序编程的 \\\"SET/POLAR,ON\\\" UDE 进行更改。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,polar,Label)"         "极坐标"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,polar,Context)"       "XZC 格式的坐标输出。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,cart,Label)"          "笛卡尔坐标"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,cart,Context)"        "XYZ 格式的坐标输出。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,Label)"             "循环记录模式"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,Context)"           "此选项定义将采用极坐标 (XCR) 或笛卡尔坐标 (XYIJ) 模式。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,polar,Label)"       "极坐标"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,polar,Context)"     "XCR 格式的圆形输出。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,cart,Label)"        "笛卡尔坐标"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,cart,Context)"      "XYIJ 格式的圆形输出。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,def_spindle_axis,Label)"         "初始主轴"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,def_spindle_axis,Context)"       "初始主轴可能会被机头对象指定的主轴替代。\n此矢量无需合成。"


##-----------------
## 4-th Axis parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,fourth,Label)"              "第四轴"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,radius_output,Label)"       "半径输出"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,radius_output,Context)"     "刀轴沿 Z 轴 (0,0,1) 时，后处理可以选择以下选项来输出极坐标的半径 (X)：\\\"始终为正\\\"、\\\"始终为负\\\"或\\\"最短距离\\\"。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,type_head,Label)"           "机头"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,type_table,Label)"          "转台"

##-----------------
## 5-th Axis parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,fifth,Label)"               "第五轴"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary,Label)"              "旋转轴"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,Label)"              "机床零点到旋转轴中心"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,4,Label)"            "机床零点到第 4 轴中心"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,5,Label)"            "第 4 轴中心到第 5 轴中心"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,x,Label)"            "X 偏置"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,x,Context)"          "指定旋转轴 X 偏置。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,y,Label)"            "Y 偏置"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,y,Context)"          "指定旋转轴 Y 偏置。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,z,Label)"            "Z 偏置"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,z,Context)"          "指定旋转轴 Z 偏置。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,Label)"            "轴旋转"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,norm,Label)"       "法向"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,norm,Context)"     "设置轴旋转方向为“法向”。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,rev,Label)"        "反向"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,rev,Context)"      "设置轴旋转方向为“反向”。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,direction,Label)"           "轴方向"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,direction,Context)"         "选择轴方向。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,Label)"              "连续旋转运动"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,combine,Label)"      "组合"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,combine,Context)"    "此开关允许您启用/禁用线性化。它将启用/禁用公差选项。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,tol,Label)"      "公差"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,tol,Context)"    "此选项仅在“组合”开关活动时才处于活动状态。请指定公差。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,Label)"           "轴限制违例处理"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,warn,Label)"      "警告"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,warn,Context)"    "轴限制违例时输出警告。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,ret,Label)"       "退刀/重新进刀"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,ret,Context)"     "轴限制违例时退刀/重新进刀。\n \n在定制命令 PB_CMD_init_rotaty 中，可以调节以下参数以实现所需的运动：\n \n   mom_kin_retract_type \n   mom_kin_retract_distance \n   mom_kin_reengage_distance"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,Label)"              "轴限制（度）"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,min,Label)"          "最小值"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,min,Context)"        "指定最小旋转轴限制（度）。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,max,Label)"          "最大值"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,max,Context)"        "指定最大旋转轴限制（度）。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,incr_text)"                 "旋转轴可以是递增的"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_res,Label)"          "旋转运动精度（度）"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_res,Context)"        "指定旋转运动精度（度）。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,ang_offset,Label)"          "角度偏置（度）"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,ang_offset,Context)"        "指定轴角度偏置（度）。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,pivot,Label)"               "枢轴距离"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,pivot,Context)"             "指定枢轴距离。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,max_feed,Label)"            "最大进给率（度/分）"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,max_feed,Context)"          "指定最大进给率（度/分）。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,Label)"               "旋转平面"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,Context)"             "选择 XY、YZ、ZX 或“其他”作为旋转平面。\\\"其他\\\"选项允许您指定任意矢量。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,normal,Label)"        "平面法矢"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,normal,Context)"      "指定平面法矢作为旋转轴。\n此矢量无需合成。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,4th,Label)"           "第 4 轴平面法矢"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,4th,Context)"         "指定第 4 轴旋转的平面法矢。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,5th,Label)"           "第 5 轴平面法矢"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,5th,Context)"         "指定第 5 轴旋转的平面法矢。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,leader,Label)"              "文字引导符"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,leader,Context)"            "指定文字引导符。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,config,Label)"              "配置"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,config,Context)"            "此选项允许您定义第 4 和第 5 轴参数。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,r_axis_conf_trans,Label)"   "旋转轴配置"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,4th_axis,Label)"            "第 4 轴"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,5th_axis,Label)"            "第 5 轴"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,head,Label)"                " 机头 "
::msgcat::mcset $gPB(LANG) "MC(machine,axis,table,Label)"               " 转台 "

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_lintol,Label)"       "默认线性化公差"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_lintol,Context)"     "用当前或之前的工序指定 LINTOL/ON 后处理命令时，此数值将作为默认公差以线性化旋转运动。LINTOL/ 命令还可以指定其他线性化公差。"

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(progtpth,tab,Label)"                 "程序和刀轨"

##---------
## Program
##
::msgcat::mcset $gPB(LANG) "MC(prog,tab,Label)"                     "程序"
::msgcat::mcset $gPB(LANG) "MC(prog,Status)"                        "定义事件的输出"

::msgcat::mcset $gPB(LANG) "MC(prog,tree,Label)"                    "程序 -- 序列树"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,Context)"                  "N/C 程序被分为五个部分：四 (4) 个序列和刀轨本体：\n \n * 程序起始序列\n * 工序起始序列\n * 刀轨\n * 工序结束序列\n * 程序结束序列\n \n每个序列包含一系列的标记。每个标记代表可以编程且可能在 N/C 程序某个特定阶段发生的事件。您可以向每个标记附加特定顺序的 N/C 代码，以在后处理该程序时输出。\n \n刀轨由大量事件组成，分为三 (3) 组：\n \n * 机床控制\n * 运动\n * 循环\n"

::msgcat::mcset $gPB(LANG) "MC(prog,tree,prog_strt,Label)"          "程序起始序列"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,prog_end,Label)"           "程序结束序列"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,oper_strt,Label)"          "工序起始序列"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,oper_end,Label)"           "工序结束序列"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,Label)"          "刀径"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,mach_cnt,Label)" "机床控制"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,motion,Label)"   "运动"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,cycle,Label)"    "现成循环"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,linked_posts,Label)"       "链接的后处理序列"

::msgcat::mcset $gPB(LANG) "MC(prog,add,Label)"                     "序列 -- 添加块"
::msgcat::mcset $gPB(LANG) "MC(prog,add,Context)"                   "通过按下此按钮并将其拖动到所需的标记，可以将新块添加到序列。还可以将块附加到现有块的旁边、上边或下边。"

::msgcat::mcset $gPB(LANG) "MC(prog,trash,Label)"                   "序列 -- 垃圾桶"
::msgcat::mcset $gPB(LANG) "MC(prog,trash,Context)"                 "通过将块拖动到垃圾桶，可以移除序列中不想要的块。"

::msgcat::mcset $gPB(LANG) "MC(prog,block,Label)"                   "序列 -- 块"
::msgcat::mcset $gPB(LANG) "MC(prog,block,Context)"                 "通过将块拖动到垃圾桶，可以删除序列中不想要的块。\n \n还可以按下鼠标右键来激活弹出式菜单。该菜单上有几项服务可用：\n \n * 编辑\n * 强制输出\n * 剪切\n * 复制为\n * 粘贴\n * 删除\n"

::msgcat::mcset $gPB(LANG) "MC(prog,select,Label)"                  "序列 -- 块选择"
::msgcat::mcset $gPB(LANG) "MC(prog,select,Context)"                "可以从该列表中选择要添加到序列的块组件的类型。\n\A可用组件类型包括：\n \n * 新块\n * 现有 N/C 块\n * 操作员消息\n * 定制命令\n"

::msgcat::mcset $gPB(LANG) "MC(prog,oper_temp,Label)"               "选择序列模板"
::msgcat::mcset $gPB(LANG) "MC(prog,add_block,Label)"               "添加块"
::msgcat::mcset $gPB(LANG) "MC(prog,seq_comb_nc,Label)"             "显示组合 N/C 代码块"
::msgcat::mcset $gPB(LANG) "MC(prog,seq_comb_nc,Context)"           "此按钮允许您根据块或 N/C 代码显示序列内容。\n \nN/C 代码会以适当的顺序显示文字。"

::msgcat::mcset $gPB(LANG) "MC(prog,plus,Label)"                    "程序 -- 折叠/展开开关"
::msgcat::mcset $gPB(LANG) "MC(prog,plus,Context)"                  "此按钮允许您折叠或展开该组件的分支。"

::msgcat::mcset $gPB(LANG) "MC(prog,marker,Label)"                  "序列 -- 标记"
::msgcat::mcset $gPB(LANG) "MC(prog,marker,Context)"                "序列的标记代表可以编程且可能在 N/C 程序某个特定阶段出现的可能事件。\n \n您可以附加/布置要在每个标记中输出的块。"

::msgcat::mcset $gPB(LANG) "MC(prog,event,Label)"                   "程序 -- 事件"
::msgcat::mcset $gPB(LANG) "MC(prog,event,Context)"                 "您可以通过单击鼠标左键编辑每个事件。"

::msgcat::mcset $gPB(LANG) "MC(prog,nc_code,Label)"                 "程序 -- N/C 代码"
::msgcat::mcset $gPB(LANG) "MC(prog,nc_code,Context)"               "此框中的文本显示将作为此标记或此事件输出的代表性 N/C 代码。"
::msgcat::mcset $gPB(LANG) "MC(prog,undo_popup,Label)"              "撤消"

## Sequence
##
::msgcat::mcset $gPB(LANG) "MC(seq,combo,new,Label)"                "新块"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,comment,Label)"            "操作员消息"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,custom,Label)"             "定制命令"

::msgcat::mcset $gPB(LANG) "MC(seq,new_trans,title,Label)"          "块"
::msgcat::mcset $gPB(LANG) "MC(seq,cus_trans,title,Label)"          "定制命令"
::msgcat::mcset $gPB(LANG) "MC(seq,oper_trans,title,Label)"         "操作员消息"

::msgcat::mcset $gPB(LANG) "MC(seq,edit_popup,Label)"               "编辑"
::msgcat::mcset $gPB(LANG) "MC(seq,force_popup,Label)"              "强制输出"
::msgcat::mcset $gPB(LANG) "MC(seq,rename_popup,Label)"             "重命名"
::msgcat::mcset $gPB(LANG) "MC(seq,rename_popup,Context)"           "您可以指定此组件的名称。"
::msgcat::mcset $gPB(LANG) "MC(seq,cut_popup,Label)"                "剪切"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,Label)"               "复制为"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,ref,Label)"           "引用的块"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,new,Label)"           "新块"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,Label)"              "粘贴"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,before,Label)"       "之前"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,inline,Label)"       "行内"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,after,Label)"        "之后"
::msgcat::mcset $gPB(LANG) "MC(seq,del_popup,Label)"                "删除"

::msgcat::mcset $gPB(LANG) "MC(seq,force_trans,title,Label)"        "强制输出一次"

##--------------
## Toolpath
##
::msgcat::mcset $gPB(LANG) "MC(tool,event_trans,title,Label)"       "事件"

::msgcat::mcset $gPB(LANG) "MC(tool,event_seq,button,Label)"        "选择事件模板"
::msgcat::mcset $gPB(LANG) "MC(tool,add_word,button,Label)"         "添加文字"

::msgcat::mcset $gPB(LANG) "MC(tool,format_trans,title,Label)"      "格式"

::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,title,Label)"        "圆周移动 -- 平面代码"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,frame,Label)"        " 平面 G 代码 "
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,xy,Label)"           "XY 平面"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,yz,Label)"           "YZ 平面"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,zx,Label)"           "ZX 平面"

::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,arc_start,Label)"          "圆弧起点到中心"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,arc_center,Label)"         "圆弧中心到起点"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,u_arc_start,Label)"        "无符号的圆弧起点到中心"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,absolute,Label)"           "绝对圆弧中心"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,long_thread_lead,Label)"   "纵向螺纹线"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,tran_thread_lead,Label)"   "横向螺纹线"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,type,Label)"              "主轴范围类型"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,range_M,Label)"           "独立范围 M 代码 (M41)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,with_spindle_M,Label)"    "带主轴 M 代码的范围号 (M13)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,hi_lo_with_S,Label)"      "带 S 代码的高/低范围 (S+100)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,nonzero_range,msg)"       "主轴范围号必须大于零。"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,title,Label)"         "主轴范围代码表"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,range,Label)"         "范围"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,code,Label)"          "代码"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,min,Label)"           "最小值 (RPM)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,max,Label)"           "最大值 (RPM)"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,sep,Label)"            " 独立范围 M 代码 (M41, M42 ...) "
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,range,Label)"          " 带主轴 M 代码的范围号 (M13, M23 ...)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,high,Label)"           " 带 S 代码的高/低范围 (S+100/S-100)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,odd,Label)"            " 带 S 代码的奇数/偶数范围"


::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt1,Label)"            "刀具号"
::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt2,Label)"            "刀具号和长度偏置号"
::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt3,Label)"            "长度偏置号和刀具号"

::msgcat::mcset $gPB(LANG) "MC(tool,config,title,Label)"                "刀具代码配置"
::msgcat::mcset $gPB(LANG) "MC(tool,config,output,Label)"               "输出"

::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt1,Label)"           "刀具号"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt2,Label)"           "刀具号和长度偏置号"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt3,Label)"           "转塔索引和刀具号"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt4,Label)"           "转塔索引刀具号和长度偏置号"

::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,num,Label)"               "刀具号"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,next_num,Label)"          "下一刀具号"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_num,Label)"         "转塔索引和刀具号"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_next_num,Label)"    "转塔索引和下一刀具号"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,num_len,Label)"           "刀具号和长度偏置号"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,next_num_len,Label)"      "下一刀具号和长度偏置号"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,len_num,Label)"           "长度偏置号和刀具号"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,len_next_num,Label)"      "长度偏置号和下一刀具号"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_num_len,Label)"     "转塔索引、刀具号和长度偏置号"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_next_num_len,Label)"    "转塔索引、下一刀具号和长度偏置号"

::msgcat::mcset $gPB(LANG) "MC(tool,oper_trans,title,Label)"            "操作员消息"
::msgcat::mcset $gPB(LANG) "MC(tool,cus_trans,title,Label)"             "定制命令"

##--------------------------
## Labels for Event dialogs
##
::msgcat::mcset $gPB(LANG) "MC(event,feed,IPM_mode)"                "IPM（英寸/分）模式"

##---------
## G Codes
##
::msgcat::mcset $gPB(LANG) "MC(gcode,tab,Label)"                    "G 代码"
::msgcat::mcset $gPB(LANG) "MC(gcode,Status)"                       "指定 G 代码"

##---------
## M Codes
##
::msgcat::mcset $gPB(LANG) "MC(mcode,tab,Label)"                    "M 代码"
::msgcat::mcset $gPB(LANG) "MC(mcode,Status)"                       "指定 M 代码"

##-----------------
## Words Summary
##
::msgcat::mcset $gPB(LANG) "MC(addrsum,tab,Label)"                  "文字汇总"
::msgcat::mcset $gPB(LANG) "MC(addrsum,Status)"                     "指定参数"

::msgcat::mcset $gPB(LANG) "MC(addrsum,col_addr,Label)"             "文字"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_addr,Context)"           "您可以通过用鼠标左键单击名称以编辑文字地址。"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_lead,Label)"             "引导符/代码"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_data,Label)"             "数据类型"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_plus,Label)"             "加号 (+)"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_lzero,Label)"            "前导零"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_int,Label)"              "整数"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_dec,Label)"              "小数点 (.)"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_frac,Label)"             "分数"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_tzero,Label)"            "后置零"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_modal,Label)"            "模态？"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_min,Label)"              "最小值"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_max,Label)"              "最大值"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_trail,Label)"            "结束符"

::msgcat::mcset $gPB(LANG) "MC(addrsum,radio_text,Label)"           "文本"
::msgcat::mcset $gPB(LANG) "MC(addrsum,radio_num,Label)"            "数字"

::msgcat::mcset $gPB(LANG) "MC(addrsum,addr_trans,title,Label)"     "文字"
::msgcat::mcset $gPB(LANG) "MC(addrsum,other_trans,title,Label)"    "其他数据单元"

##-----------------
## Word Sequencing
##
::msgcat::mcset $gPB(LANG) "MC(wseq,tab,Label)"                     "文字排序"
::msgcat::mcset $gPB(LANG) "MC(wseq,Status)"                        "对文字排序"

::msgcat::mcset $gPB(LANG) "MC(wseq,word,Label)"                    "主文字序列"
::msgcat::mcset $gPB(LANG) "MC(wseq,word,Context)"                  "您可以通过将文字拖到所需位置，对 N/C 输出中出现的文字进行排序。\n \n当拖动的文字与另一文字焦点对准（矩形颜色更改）时，两个文字将互换位置。如果将某个文字拖动到两个文字间的分隔符焦点内，则该文字会被插入这两个文字之间。\n \n可以通过单击鼠标左键将文字关闭，以抑制其输出到 N/C 文件。\n \n还可以使用弹出菜单中的选项对这些文字进行以下操作：\n \n * 新建\n * 编辑\n * 删除\n * 全部激活\n"

::msgcat::mcset $gPB(LANG) "MC(wseq,active_out,Label)"              " 输出 - 活动的     "
::msgcat::mcset $gPB(LANG) "MC(wseq,suppressed_out,Label)"          " 输出 - 抑制的 "

::msgcat::mcset $gPB(LANG) "MC(wseq,popup_new,Label)"               "新建"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_undo,Label)"              "撤消"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_edit,Label)"              "编辑"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_delete,Label)"            "删除"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_all,Label)"               "全部激活"
::msgcat::mcset $gPB(LANG) "MC(wseq,transient_win,Label)"           "文字"
::msgcat::mcset $gPB(LANG) "MC(wseq,cannot_suppress_msg)"           "不能被抑制。它已经作为单个单元用于"
::msgcat::mcset $gPB(LANG) "MC(wseq,empty_block_msg)"               "抑制此地址的输出将导致无效的空块。"

##----------------
## Custom Command
##
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,tab,Label)"                 "定制命令"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,Status)"                    "定义定制命令"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name,Label)"                "命令名称"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name,Context)"              "您在此处输入的名称将加上前缀 PB_CMD_ 以作为实际的命令名。"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,proc,Label)"                "步骤"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,proc,Context)"              "您必须输入 Tcl 脚本以定义此命令的功能。\n \n * 注意：脚本的内容不会被后处理构造器解析，但会被保存在 Tcl 文件中。因此，您必须对脚本的语法正确性负责。"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg)"                  "定制命令名无效。\n请指定其他名称"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_1)"                "已经预留给特殊定制命令。\n请指定其他名称"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_2)"                "仅允许类似于\n PB_CMD_vnc____* 的 VNC 定制命令名。\n请指定其他名称"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,Label)"              "导入"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,Context)"            "将选定 Tcl 文件中的定制命令导入进行中的后处理。"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,Label)"              "导出"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,Context)"            "将进行中的后处理中的定制命令导出到 Tcl 文件。"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,tree,Label)"         "导入定制命令"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,tree,Context)"       "此列表包含您指定导入的文件中存在的定制命令步骤和 Tcl 步骤。您可以通过单击鼠标左键选择列表上的项，以预览各步骤中的内容。已经存在于进行中的后处理的步骤标有 <exists> 指示符。在某一项上双击鼠标左键将切换该项旁边的复选框。此操作允许您选择或取消选择要导入的步骤。默认情况下，所有步骤都被选中导入。您可以取消选择某一项以避免覆盖现有的步骤。"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,tree,Label)"         "导出定制命令"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,tree,Context)"       "此列表包含存在于进行中的后处理的定制命令步骤和 Tcl 步骤。您可以通过单击鼠标左键选择列表上的项，以预览各步骤中的内容。在某一项上双击鼠标左键将切换该项旁边的复选框。这样可供您只选择要导出的步骤。"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,error,title)"               "定制命令错误"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,error,msg)"                 "通过设置主菜单项\"选项 -> 验证定制命令\"的下拉菜单上的开关，可以启用或禁用定制命令的验证。"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,select_all,Label)"          "全选"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,select_all,Context)"        "单击此按钮可选择所有显示用于导入或导出的命令。"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,deselect_all,Label)"        "全不选"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,deselect_all,Context)"      "单击此按钮可取消选择所有命令。"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,warning,title)"      "定制命令导入/导出警告"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,warning,msg)"        "没有选择任何项进行导入或导出。"



::msgcat::mcset $gPB(LANG) "MC(cust_cmd,cmd,msg)"                   "命令： "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,blk,msg)"                   "块： "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,add,msg)"                   "地址： "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,fmt,msg)"                   "格式： "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,referenced,msg)"            "在定制命令中引用 "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,not_defined,msg)"           "尚未在进行中的后处理当前范围中定义。"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,cannot_delete,msg)"         "不能删除。"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,save_post,msg)"             "您仍要保存该后处理吗？"


##------------------
## Operator Message
##
::msgcat::mcset $gPB(LANG) "MC(opr_msg,text,Label)"                 "操作员消息"
::msgcat::mcset $gPB(LANG) "MC(opr_msg,text,Context)"               "即将显示为运算程序消息的文本。消息开始和结束必需的特殊字符将被自动附加到后处理构造器。这些字符可以在 \"N/C 数据定义\"选项卡下面的\"其他数据单元\"参数页面中指定。"

::msgcat::mcset $gPB(LANG) "MC(opr_msg,name,Label)"                 "消息名称"
::msgcat::mcset $gPB(LANG) "MC(opr_msg,empty_operator)"             "操作员消息不应为空。"


##--------------
## Linked Posts
##
::msgcat::mcset $gPB(LANG) "MC(link_post,tab,Label)"                "链接的后处理"
::msgcat::mcset $gPB(LANG) "MC(link_post,Status)"                   "定义链接的后处理"

::msgcat::mcset $gPB(LANG) "MC(link_post,toggle,Label)"             "链接其他后处理到此后处理"
::msgcat::mcset $gPB(LANG) "MC(link_post,toggle,Context)"           "其他后处理可以链接到此后处理，以处理执行多个简单铣削和车削模式组合的复杂机床。"

::msgcat::mcset $gPB(LANG) "MC(link_post,head,Label)"               "机头"
::msgcat::mcset $gPB(LANG) "MC(link_post,head,Context)"             "复杂机床可以在多种加工模式中使用不同的运动学组来执行加工工序。每组运动学可以作为 NX/后处理的独立机头。需要用特定机头执行的加工工序将作为一组放在机床或加工方法视图中。\\\"机头\\\" UDE 随后将被指派到该组，以指定此机头的名称。"

::msgcat::mcset $gPB(LANG) "MC(link_post,post,Label)"               "后处理"
::msgcat::mcset $gPB(LANG) "MC(link_post,post,Context)"             "后处理被指派到机头中，用于生成 N/C 代码。"

::msgcat::mcset $gPB(LANG) "MC(link_post,link,Label)"               "链接的后处理"
::msgcat::mcset $gPB(LANG) "MC(link_post,link,Context)"             "[::msgcat::mc MC(link_post,head,Context)] \n\n [::msgcat::mc MC(link_post,post,Context)]"


::msgcat::mcset $gPB(LANG) "MC(link_post,new,Label)"                "新建"
::msgcat::mcset $gPB(LANG) "MC(link_post,new,Context)"              "创建新链接。"

::msgcat::mcset $gPB(LANG) "MC(link_post,edit,Label)"               "编辑"
::msgcat::mcset $gPB(LANG) "MC(link_post,edit,Context)"             "编辑链接。"

::msgcat::mcset $gPB(LANG) "MC(link_post,delete,Label)"             "删除"
::msgcat::mcset $gPB(LANG) "MC(link_post,delete,Context)"           "删除链接。"

::msgcat::mcset $gPB(LANG) "MC(link_post,select_name,Label)"        "选择名称"
::msgcat::mcset $gPB(LANG) "MC(link_post,select_name,Context)"      "选择要指派给机头的后处理名称。此后处理很可能在 NX/后处理运行时中主后处理所在的目录中，否则将使用 \\\$UGII_CAM_POST_DIR 目录中同名的后处理。"

::msgcat::mcset $gPB(LANG) "MC(link_post,start_of_head,Label)"      "机头开始"
::msgcat::mcset $gPB(LANG) "MC(link_post,start_of_head,Context)"    "指定机头开始时要执行的 N/C 代码或操作。"

::msgcat::mcset $gPB(LANG) "MC(link_post,end_of_head,Label)"        "机头结束"
::msgcat::mcset $gPB(LANG) "MC(link_post,end_of_head,Context)"      "指定机头结束时要执行的 N/C 代码或操作。"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,head,Label)"           "机头"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,post,Label)"           "后处理"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,title,Label)"          "链接的后处理"

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(nc_data,tab,Label)"                  "N/C 数据定义"

##-------
## BLOCK
##
::msgcat::mcset $gPB(LANG) "MC(block,tab,Label)"                    "块"
::msgcat::mcset $gPB(LANG) "MC(block,Status)"                       "定义块模板"

::msgcat::mcset $gPB(LANG) "MC(block,name,Label)"                   "块名称"
::msgcat::mcset $gPB(LANG) "MC(block,name,Context)"                 "输入块名称"

::msgcat::mcset $gPB(LANG) "MC(block,add,Label)"                    "添加文字"
::msgcat::mcset $gPB(LANG) "MC(block,add,Context)"                  "您可以通过按下此按钮并将其拖动到以下窗口显示的块中，添加新文字到块中。即将创建的文字类型从该按钮右侧的列表框中选择。"

::msgcat::mcset $gPB(LANG) "MC(block,select,Label)"                 "块 -- 文字选择"
::msgcat::mcset $gPB(LANG) "MC(block,select,Context)"               "可以从该列表中选择要添加到块的文字的类型。"

::msgcat::mcset $gPB(LANG) "MC(block,trash,Label)"                  "块 -- 垃圾桶"
::msgcat::mcset $gPB(LANG) "MC(block,trash,Context)"                "通过将文字拖动到垃圾桶，可以移除块中不想要的文字。"

::msgcat::mcset $gPB(LANG) "MC(block,word,Label)"                   "块 -- 文字"
::msgcat::mcset $gPB(LANG) "MC(block,word,Context)"                 "通过将文字拖动到垃圾桶，可以删除该块中不想要的文字。\n \n还可以按下鼠标右键来激活弹出式菜单。该菜单上有几项服务可用：\n \n * 编辑\n * 更改单元 ->\n * 可选\n * 无文字分隔符\n * 强制输出\n * 删除\n"

::msgcat::mcset $gPB(LANG) "MC(block,verify,Label)"                 "块 -- 文字验证"
::msgcat::mcset $gPB(LANG) "MC(block,verify,Context)"               "此窗口显示要为文字输出的代表性 N/C 代码，这些文字是在以上窗口中显示的块中选定（压下）的。"

::msgcat::mcset $gPB(LANG) "MC(block,new_combo,Label)"              "新地址"
::msgcat::mcset $gPB(LANG) "MC(block,text_combo,Label)"             "文本"
::msgcat::mcset $gPB(LANG) "MC(block,oper_combo,Label)"             "操作员消息"
::msgcat::mcset $gPB(LANG) "MC(block,comm_combo,Label)"             "命令"

::msgcat::mcset $gPB(LANG) "MC(block,edit_popup,Label)"             "编辑"
::msgcat::mcset $gPB(LANG) "MC(block,view_popup,Label)"             "查看"
::msgcat::mcset $gPB(LANG) "MC(block,change_popup,Label)"           "更改单元"
::msgcat::mcset $gPB(LANG) "MC(block,user_popup,Label)"             "用户定义表达式"
::msgcat::mcset $gPB(LANG) "MC(block,opt_popup,Label)"              "可选"
::msgcat::mcset $gPB(LANG) "MC(block,no_sep_popup,Label)"           "无文字分隔符"
::msgcat::mcset $gPB(LANG) "MC(block,force_popup,Label)"            "强制输出"
::msgcat::mcset $gPB(LANG) "MC(block,delete_popup,Label)"           "删除"
::msgcat::mcset $gPB(LANG) "MC(block,undo_popup,Label)"             "撤消"
::msgcat::mcset $gPB(LANG) "MC(block,delete_all,Label)"             "删除所有活动单元"

::msgcat::mcset $gPB(LANG) "MC(block,cmd_title,Label)"              "定制命令"
::msgcat::mcset $gPB(LANG) "MC(block,oper_title,Label)"             "操作员消息"
::msgcat::mcset $gPB(LANG) "MC(block,addr_title,Label)"             "文字"

::msgcat::mcset $gPB(LANG) "MC(block,new_trans,title,Label)"        "文字"

::msgcat::mcset $gPB(LANG) "MC(block,new,word_desc,Label)"          "新地址"
::msgcat::mcset $gPB(LANG) "MC(block,oper,word_desc,Label)"         "操作员消息"
::msgcat::mcset $gPB(LANG) "MC(block,cmd,word_desc,Label)"          "定制命令"
::msgcat::mcset $gPB(LANG) "MC(block,user,word_desc,Label)"         "用户定义表达式"
::msgcat::mcset $gPB(LANG) "MC(block,text,word_desc,Label)"         "文本字符串"

::msgcat::mcset $gPB(LANG) "MC(block,user,expr,Label)"              "表达式"

::msgcat::mcset $gPB(LANG) "MC(block,msg,min_word)"                 "一个块应至少包含一个文字。"

::msgcat::mcset $gPB(LANG) "MC(block,name_msg)"                     "块名称无效。\n请指定其他名称。"

##---------
## ADDRESS
##
::msgcat::mcset $gPB(LANG) "MC(address,tab,Label)"                  "文字"
::msgcat::mcset $gPB(LANG) "MC(address,Status)"                     "定义文字"

::msgcat::mcset $gPB(LANG) "MC(address,name,Label)"                 "文字名称"
::msgcat::mcset $gPB(LANG) "MC(address,name,Context)"               "您可以编辑文字的名称。"

::msgcat::mcset $gPB(LANG) "MC(address,verify,Label)"               "文字 -- 验证"
::msgcat::mcset $gPB(LANG) "MC(address,verify,Context)"             "此窗口显示要为文字输出的代表性 N/C 代码。"

::msgcat::mcset $gPB(LANG) "MC(address,leader,Label)"               "引导符"
::msgcat::mcset $gPB(LANG) "MC(address,leader,Context)"             "您可以输入任意数量的字符作为文字的引导符，或者使用鼠标右键显示弹出菜单并从中选择字符。"

::msgcat::mcset $gPB(LANG) "MC(address,format,Label)"               "格式"
::msgcat::mcset $gPB(LANG) "MC(address,format,edit,Label)"          "编辑"
::msgcat::mcset $gPB(LANG) "MC(address,format,edit,Context)"        "此按钮允许您编辑文字使用的格式。"
::msgcat::mcset $gPB(LANG) "MC(address,format,new,Label)"           "新建"
::msgcat::mcset $gPB(LANG) "MC(address,format,new,Context)"         "此按钮允许您创建新的格式。"

::msgcat::mcset $gPB(LANG) "MC(address,format,select,Label)"        "文字 -- 选择格式"
::msgcat::mcset $gPB(LANG) "MC(address,format,select,Context)"      "此按钮允许您为文字选择不同的格式。"

::msgcat::mcset $gPB(LANG) "MC(address,trailer,Label)"              "结束符"
::msgcat::mcset $gPB(LANG) "MC(address,trailer,Context)"            "您可以输入任意数量的字符作为文字的结束符，或者使用鼠标右键显示弹出菜单并从中选择字符。"

::msgcat::mcset $gPB(LANG) "MC(address,modality,Label)"             "模态？"
::msgcat::mcset $gPB(LANG) "MC(address,modality,Context)"           "此选项允许您设置文字的形式。"

::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,off,Label)"       "关"
::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,once,Label)"      "一次"
::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,always,Label)"    "始终"

::msgcat::mcset $gPB(LANG) "MC(address,max,value,Label)"            "最大值"
::msgcat::mcset $gPB(LANG) "MC(address,max,value,Context)"          "您将指定文字的最大值。"

::msgcat::mcset $gPB(LANG) "MC(address,value,text,Label)"           "值"

::msgcat::mcset $gPB(LANG) "MC(address,trunc_drop,Label)"           "截断值"
::msgcat::mcset $gPB(LANG) "MC(address,warn_drop,Label)"            "警告用户"
::msgcat::mcset $gPB(LANG) "MC(address,abort_drop,Label)"           "中止进程"

::msgcat::mcset $gPB(LANG) "MC(address,max,error_handle,Label)"     "违例处理"
::msgcat::mcset $gPB(LANG) "MC(address,max,error_handle,Context)"   "此按钮允许您指定违反最大值时的处理方法：\n \n * 截断值\n * 警告用户\n * 中止进程\n"

::msgcat::mcset $gPB(LANG) "MC(address,min,value,Label)"            "最小值"
::msgcat::mcset $gPB(LANG) "MC(address,min,value,Context)"          "您将指定文字的最小值。"

::msgcat::mcset $gPB(LANG) "MC(address,min,error_handle,Label)"     "违例处理"
::msgcat::mcset $gPB(LANG) "MC(address,min,error_handle,Context)"   "此按钮允许您指定违反最小值时的处理方法：\n \n * 截断值\n * 警告用户\n * 中止进程\n"

::msgcat::mcset $gPB(LANG) "MC(address,format_trans,title,Label)"   "格式 "
::msgcat::mcset $gPB(LANG) "MC(address,none_popup,Label)"           "无"

::msgcat::mcset $gPB(LANG) "MC(address,exp,Label)"                  "表达式"
::msgcat::mcset $gPB(LANG) "MC(address,exp,Context)"                "您可以指定表达式或常数到块中。"
::msgcat::mcset $gPB(LANG) "MC(address,exp,msg)"                    "块单元的表达式不能为空。"
::msgcat::mcset $gPB(LANG) "MC(address,exp,space_only)"             "使用数字格式的块单元表达式不能仅包含空格。"

## No translation is needed for this string.
::msgcat::mcset $gPB(LANG) "MC(address,exp,spec_char)"              "\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@ \[  \\  \]  \^  \`  \{  \|  \}  \~"

::msgcat::mcset $gPB(LANG) "MC(address,exp,spec_char_msg)"          "特殊字符\n [::msgcat::mc MC(address,exp,spec_char)] \n不能用于数字数据的表达式。"



::msgcat::mcset $gPB(LANG) "MC(address,name_msg)"                   "文字名称无效。\n请指定其他名称。"
# - No translation for rapid1, rapid2 & rapid3
::msgcat::mcset $gPB(LANG) "MC(address,rapid_add_name_msg)"         "rapid1、rapid2 和 rapid3 已经由后处理构造器预留供内部使用。\n请指定其他名称。"

::msgcat::mcset $gPB(LANG) "MC(address,rapid1,desc)"                "沿纵向轴快速定位"
::msgcat::mcset $gPB(LANG) "MC(address,rapid2,desc)"                "沿横向轴快速定位"
::msgcat::mcset $gPB(LANG) "MC(address,rapid3,desc)"                "沿主轴快速定位"

##--------
## FORMAT
##
::msgcat::mcset $gPB(LANG) "MC(format,tab,Label)"                   "格式"
::msgcat::mcset $gPB(LANG) "MC(format,Status)"                      "定义格式"

::msgcat::mcset $gPB(LANG) "MC(format,verify,Label)"                "格式 -- 验证"
::msgcat::mcset $gPB(LANG) "MC(format,verify,Context)"              "此窗口显示将使用指定格式进行输出的代表性 N/C 代码。"

::msgcat::mcset $gPB(LANG) "MC(format,name,Label)"                  "格式名"
::msgcat::mcset $gPB(LANG) "MC(format,name,Context)"                "您可以编辑格式的名称。"

::msgcat::mcset $gPB(LANG) "MC(format,data,type,Label)"             "数据类型"
::msgcat::mcset $gPB(LANG) "MC(format,data,type,Context)"           "您将指定格式的数据类型。"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,Label)"              "数字"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,Context)"            "此选项将格式的数据类型定义为数字。"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,integer,Label)"      "格式 -- 整数位数"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,integer,Context)"    "此选项指定整数或实数整数部分的位数。"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,fraction,Label)"     "格式 -- 分数位数"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,fraction,Context)"   "此选项指定实数分数部分的位数。"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,decimal,Label)"      "输出小数点 (.)"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,decimal,Context)"    "此选项允许您在 N/C 代码中输出小数点。"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,lead,Label)"         "输出前导零"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,lead,Context)"       "此选项启用附加到 N/C 代码数字中的前导零。"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,trail,Label)"        "输出后置零"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,trail,Context)"      "此选项启用附加到 N/C 代码实数中的后置零。"
::msgcat::mcset $gPB(LANG) "MC(format,data,text,Label)"             "文本"
::msgcat::mcset $gPB(LANG) "MC(format,data,text,Context)"           "此选项将格式的数据类型定义为文本字符串。"
::msgcat::mcset $gPB(LANG) "MC(format,data,plus,Label)"             "输出前导加号 (+)"
::msgcat::mcset $gPB(LANG) "MC(format,data,plus,Context)"           "此选项允许您在 N/C 代码中输出加号。"
::msgcat::mcset $gPB(LANG) "MC(format,zero_msg)"                    "不能创建零格式副本"
::msgcat::mcset $gPB(LANG) "MC(format,zero_cut_msg)"                "不能删除零格式"

::msgcat::mcset $gPB(LANG) "MC(format,data,dec_zero,msg)"           "应至少选中一个小数点、前导零或后置零选项。"

::msgcat::mcset $gPB(LANG) "MC(format,data,no_digit,msg)"           "整数和分数的位数不能都为零。"

::msgcat::mcset $gPB(LANG) "MC(format,name_msg)"                    "格式名称无效。\n请指定其他名称。"
::msgcat::mcset $gPB(LANG) "MC(format,error,title)"                 "格式错误"
::msgcat::mcset $gPB(LANG) "MC(format,error,msg)"                   "此格式已在地址中使用"

##---------------------
## Other Data Elements
##
::msgcat::mcset $gPB(LANG) "MC(other,tab,Label)"                    "其他数据单元"
::msgcat::mcset $gPB(LANG) "MC(other,Status)"                       "指定参数"

::msgcat::mcset $gPB(LANG) "MC(other,seq_num,Label)"                "序列号"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,Context)"              "此开关允许您启用/禁用在 N/C 代码中输出序列号。"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,start,Label)"          "序列号开始值"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,start,Context)"        "指定序列号的开始值。"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,inc,Label)"            "序列号增量值"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,inc,Context)"          "指定序列号的增量值。"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,freq,Label)"           "序列号频率"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,freq,Context)"         "指定序列号出现在 N/C 代码中的频率。"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,max,Label)"            "序列号最大值"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,max,Context)"          "指定序列号的最大值。"

::msgcat::mcset $gPB(LANG) "MC(other,chars,Label)"                  "特殊字符"
::msgcat::mcset $gPB(LANG) "MC(other,chars,word_sep,Label)"         "文字分隔符"
::msgcat::mcset $gPB(LANG) "MC(other,chars,word_sep,Context)"       "指定用作文字分隔符的字符。"
::msgcat::mcset $gPB(LANG) "MC(other,chars,decimal_pt,Label)"       "小数点"
::msgcat::mcset $gPB(LANG) "MC(other,chars,decimal_pt,Context)"     "指定用作小数点的字符。"
::msgcat::mcset $gPB(LANG) "MC(other,chars,end_of_block,Label)"     "块结束"
::msgcat::mcset $gPB(LANG) "MC(other,chars,end_of_block,Context)"   "指定用作块结束的字符。"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_start,Label)"    "消息开始"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_start,Context)"  "指定要用作操作员消息行开始的字符。"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_end,Label)"      "消息结束"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_end,Context)"    "指定要用作操作员消息行结束的字符。"

::msgcat::mcset $gPB(LANG) "MC(other,opskip,Label)"                 "OPSKIP"
::msgcat::mcset $gPB(LANG) "MC(other,opskip,leader,Label)"          "行引导符"
::msgcat::mcset $gPB(LANG) "MC(other,opskip,leader,Context)"        "OPSKIP 行引导符"

::msgcat::mcset $gPB(LANG) "MC(other,gm_codes,Label)"               "每块的 G 和 M 代码输出"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,Label)"                "每块的 G 代码数"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,Context)"              "此开关允许您启用/禁用每个 N/C 输出块的 G 代码数控制。"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,num,Label)"            "G 代码数"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,num,Context)"          "指定每个 N/C 输出块的 G 代码数。"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,Label)"                "M 代码数"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,Context)"              "此开关允许您启用/禁用每个 N/C 输出块的 M 代码数控制。"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,num,Label)"            "每块的 M 代码数"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,num,Context)"          "指定每个 N/C 输出块的 M 代码数。"

::msgcat::mcset $gPB(LANG) "MC(other,opt_none,Label)"               "无"
::msgcat::mcset $gPB(LANG) "MC(other,opt_space,Label)"              "空格"
::msgcat::mcset $gPB(LANG) "MC(other,opt_dec,Label)"                "小数点 (.)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_comma,Label)"              "逗号 (,)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_semi,Label)"               "分号 (;)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_colon,Label)"              "冒号 (:)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_text,Label)"               "文本字符串"
::msgcat::mcset $gPB(LANG) "MC(other,opt_left,Label)"               "左括号 ("
::msgcat::mcset $gPB(LANG) "MC(other,opt_right,Label)"              "右括号 )"
::msgcat::mcset $gPB(LANG) "MC(other,opt_pound,Label)"              "井号 (\#)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_aster,Label)"              "星号 (*)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_slash,Label)"              "斜线 (/)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_new_line,Label)"           "新行 (\\012)"

# UDE Inclusion
::msgcat::mcset $gPB(LANG) "MC(other,ude,Label)"                    "用户定义事件"
::msgcat::mcset $gPB(LANG) "MC(other,ude_include,Label)"            "包括其他 CDL 文件"
::msgcat::mcset $gPB(LANG) "MC(other,ude_include,Context)"          "此选项使此后处理可以在其定义文件中包括对 CDL 文件的参考。"

::msgcat::mcset $gPB(LANG) "MC(other,ude_file,Label)"               "CDL 文件名"
::msgcat::mcset $gPB(LANG) "MC(other,ude_file,Context)"             "要在此后处理的定义文件中引用（包括）的 CDL 文件的路径和文件名。路径名必须以 UG 环境变量 (\\\$UGII) 开始，或者无路径。如果未指定路径，则由 UG/NX 在运行时使用 UGII_CAM_FILE_SEARCH_PATH 定位文件。"
::msgcat::mcset $gPB(LANG) "MC(other,ude_select,Label)"             "选择名称"
::msgcat::mcset $gPB(LANG) "MC(other,ude_select,Context)"           "要在此后处理的定义文件中引用（包括）的 CDL 文件。默认情况下，选中的文件名前缀为 \\\$UGII_CAM_USER_DEF_EVENT_DIR/。您可以在选中后根据需要编辑路径名。"


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(output,tab,Label)"                   "输出设置"
::msgcat::mcset $gPB(LANG) "MC(output,Status)"                      "配置输出参数"

#++++++++++++++
# VNC Controls
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(output,vnc,Label)"                   "虚拟 N/C 控制器"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,std,Label)"          "独立"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,sub,Label)"          "从属"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,status,Label)"            "选择 VNC 文件。"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mis_match,Label)"         "选定的文件与默认的 VNC 文件名不匹配。\n要重新选择文件吗？"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,output,Label)"            "生成虚拟 N/C 控制器 (VNC)"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,output,Context)"          "此选项使您能够生成虚拟 N/C 控制器 (VNC)。因此，通过启用的 VNC 创建的后处理可用于 ISV。"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,Label)"              "主 VNC"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,Context)"            "从属 VNC 引用的主 VNC 名称。在 ISV 运行时，此后处理很可能在从属 VNC 所在的目录中，否则将使用 \\\$UGII_CAM_POST_DIR 目录中同名的后处理。"


::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,err_msg)"                 "必须为从属 VNC 指定主 VNC。"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,select_name,Label)"       "选择名称"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,select_name,Context)"     "选择从属 VNC 引用的 VNC 名称。在 ISV 运行时，此后处理很可能在从属 VNC 所在的目录中，否则将使用 \\\$UGII_CAM_POST_DIR 目录中同名的后处理。"

::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,Label)"                   "虚拟 N/C 控制器模式"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,Context)"                 "虚拟 N/C 控制器可以是独立的，也可以是主 VNC 的从属。"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,std,Context)"             "独立 VNC 是不依赖其他 VNC 的。"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,sub,Context)"             "从属 VNC 在很大程度上依赖主 VNC。它将在 ISV 运行时对主 VNC 寻源。"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,pb_ver,msg)"                   "后处理构造器创建的虚拟 N/C 控制器 "
#++++++++++++++
# Listing File
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(listing,tab,Label)"                  "列表文件"
::msgcat::mcset $gPB(LANG) "MC(listing,Status)"                     "指定列表文件参数"

::msgcat::mcset $gPB(LANG) "MC(listing,gen,Label)"                  "生成列表文件"
::msgcat::mcset $gPB(LANG) "MC(listing,gen,Context)"                "此开关允许您启用/禁用输出列表文件。"

::msgcat::mcset $gPB(LANG) "MC(listing,Label)"                      "列表文件单元"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,Label)"                "组件"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,x,Label)"              "X 坐标"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,x,Context)"            "此开关允许您启用/禁用将 X 坐标输出到列表文件。"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,y,Label)"              "Y 坐标"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,y,Context)"            "此开关允许您启用/禁用将 Y 坐标输出到列表文件。"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,z,Label)"              "Z 坐标"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,z,Context)"            "此开关允许您启用/禁用将 Z 坐标输出到列表文件。"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,4,Label)"              "第 4 轴角度"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,4,Context)"            "此开关允许您启用/禁用将第 4 轴角度输出到列表文件。"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,5,Label)"              "第 5 轴角度"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,5,Context)"            "此开关允许您启用/禁用将第 5 轴角度输出到列表文件。"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,feed,Label)"           "进给"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,feed,Context)"         "此开关允许您启用/禁用将进给率输出到列表文件。"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,speed,Label)"          "速度"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,speed,Context)"        "此开关允许您启用/禁用将主轴速度输出到列表文件。"

::msgcat::mcset $gPB(LANG) "MC(listing,extension,Label)"            "列表文件扩展名"
::msgcat::mcset $gPB(LANG) "MC(listing,extension,Context)"          "指定列表文件扩展名"

::msgcat::mcset $gPB(LANG) "MC(listing,nc_file,Label)"              "N/C 输出文件扩展名"
::msgcat::mcset $gPB(LANG) "MC(listing,nc_file,Context)"            "指定 N/C 输出文件扩展名"

::msgcat::mcset $gPB(LANG) "MC(listing,header,Label)"               "程序头"
::msgcat::mcset $gPB(LANG) "MC(listing,header,oper_list,Label)"     "工序列表"
::msgcat::mcset $gPB(LANG) "MC(listing,header,tool_list,Label)"     "刀具列表"

::msgcat::mcset $gPB(LANG) "MC(listing,footer,Label)"               "程序尾"
::msgcat::mcset $gPB(LANG) "MC(listing,footer,cut_time,Label)"      "总加工时间"

::msgcat::mcset $gPB(LANG) "MC(listing,format,Label)"                   "页面格式"
::msgcat::mcset $gPB(LANG) "MC(listing,format,print_header,Label)"      "打印页眉"
::msgcat::mcset $gPB(LANG) "MC(listing,format,print_header,Context)"    "此开关允许您启用/禁用将页眉输出到列表文件。"

::msgcat::mcset $gPB(LANG) "MC(listing,format,length,Label)"        "页面长度（行）"
::msgcat::mcset $gPB(LANG) "MC(listing,format,length,Context)"      "指定列表文件每页的行数。"
::msgcat::mcset $gPB(LANG) "MC(listing,format,width,Label)"         "页面宽度（列）"
::msgcat::mcset $gPB(LANG) "MC(listing,format,width,Context)"       "指定列表文件每页的列数。"

::msgcat::mcset $gPB(LANG) "MC(listing,other,tab,Label)"            "其他选项"
::msgcat::mcset $gPB(LANG) "MC(listing,output,Label)"               "输出控制单元"

::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,Label)"       "输出警告消息"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,Context)"     "此开关允许您在后处理过程中启用/禁用警告消息的输出。"

::msgcat::mcset $gPB(LANG) "MC(listing,output,review,Label)"        "激活检查工具"
::msgcat::mcset $gPB(LANG) "MC(listing,output,review,Context)"      "此开关允许您在后处理过程中激活审核工具。"

::msgcat::mcset $gPB(LANG) "MC(listing,output,group,Label)"         "生成组输出"
::msgcat::mcset $gPB(LANG) "MC(listing,output,group,Context)"       "此开关允许您在后处理过程中启用/禁用组输出的控制。"

::msgcat::mcset $gPB(LANG) "MC(listing,output,verbose,Label)"       "显示详细错误消息"
::msgcat::mcset $gPB(LANG) "MC(listing,output,verbose,Context)"     "此开关允许您显示错误情况的扩展描述。它会在一定程度上减慢后处理的速度。"

::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,Label)"            "工序信息"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,parms,Label)"      "工序参数"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,tool,Label)"       "刀具参数"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,cut_time,,Label)"  "加工时间"


#<09-19-00 gsl>
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,frame,Label)"       "用户 Tcl 源"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,check,Label)"       "寻源用户 Tcl 文件"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,check,Context)"     "此开关允许您引用自己的 Tcl 文件"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,name,Label)"        "文件名"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,name,Context)"      "指定您想要为该后处理引用的 Tcl 文件名"

#++++++++++++++++
# Output Preview
#++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(preview,tab,Label)"                  "后处理文件预览"
::msgcat::mcset $gPB(LANG) "MC(preview,new_code,Label)"             "新代码"
::msgcat::mcset $gPB(LANG) "MC(preview,old_code,Label)"             "旧代码"

##---------------------
## Event Handler
##
::msgcat::mcset $gPB(LANG) "MC(event_handler,tab,Label)"            "事件处理程序"
::msgcat::mcset $gPB(LANG) "MC(event_handler,Status)"               "选择事件以查看步骤"

##---------------------
## Definition
##
::msgcat::mcset $gPB(LANG) "MC(definition,tab,Label)"               "定义"
::msgcat::mcset $gPB(LANG) "MC(definition,Status)"                  "选择项以查看内容"

#++++++++++++++
# Post Advisor
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(advisor,tab,Label)"                  "后处理顾问"
::msgcat::mcset $gPB(LANG) "MC(advisor,Status)"                     "后处理顾问"

::msgcat::mcset $gPB(LANG) "MC(definition,word_txt,Label)"          "WORD_SEPARATOR"
::msgcat::mcset $gPB(LANG) "MC(definition,end_txt,Label)"           "END_OF_BLOCK"
::msgcat::mcset $gPB(LANG) "MC(definition,seq_txt,Label)"           "SEQUENCE_NUM"
::msgcat::mcset $gPB(LANG) "MC(definition,include,Label)"           "INCLUDE"
::msgcat::mcset $gPB(LANG) "MC(definition,format_txt,Label)"        "格式"
::msgcat::mcset $gPB(LANG) "MC(definition,addr_txt,Label)"          "文字"
::msgcat::mcset $gPB(LANG) "MC(definition,block_txt,Label)"         "块"
::msgcat::mcset $gPB(LANG) "MC(definition,comp_txt,Label)"          "复合块"
::msgcat::mcset $gPB(LANG) "MC(definition,post_txt,Label)"          "后处理块"
::msgcat::mcset $gPB(LANG) "MC(definition,oper_txt,Label)"          "操作员消息"

#+++++++++++++
# Balloon
#+++++++++++++
::msgcat::mcset $gPB(LANG) "MC(msg,odd)"                            "可选参数的奇数计数"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_list_1)"                   "未知选项"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_list_2)"                   "必须为其中一个："

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Program Start
::msgcat::mcset $gPB(LANG) "MC(event,start_prog,name)"              "程序开始"

### Operation Start
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,start_path,name)"    "刀轨开始"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,from_move,name)"     "出发点移动"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_tool,name)"      "第一个刀具"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,auto_tc,name)"       "自动换刀"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,manual_tc,name)"     "手工换刀"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,init_move,name)"     "初始移动"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_move,name)"      "第一次移动"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,appro_move,name)"    "逼近移动"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,engage_move,name)"   "进刀移动"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_cut,name)"       "第一刀切削"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_lin_move,name)"  "第一个线性移动"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,start_pass,name)"    "刀路开始"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,cutcom_move,name)"   "刀具补偿移动"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,lead_move,name)"     "前导移动"

### Operation End
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,ret_move,name)"        "退刀移动"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,rtn_move,name)"        "返回移动"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,goh_move,name)"        "回零移动"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,end_path,name)"        "刀轨结束"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,lead_move,name)"       "后导移动"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,end_pass,name)"        "刀路结束"

### Program End
::msgcat::mcset $gPB(LANG) "MC(event,end_prog,name)"                "程序结束"


### Tool Change
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,name)"             "换刀"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code)"           "M 代码"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,tl_chng)"   "换刀"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,pt)"        "主转塔"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,st)"        "辅助转塔"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code)"           "T 代码"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,conf)"      "配置"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,pt_idx)"    "主转塔索引"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,st_idx)"    "辅助转塔索引"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num)"         "刀具号"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num,min)"     "最小值"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num,max)"     "最大值"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,time)"             "时间（秒）"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,time,tl_chng)"     "换刀"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,retract)"          "退刀"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,retract_z)"        "退刀到以下的 Z 处："

### Length Compensation
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,name)"            "长度补偿"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,g_code)"          "G 代码"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,g_code,len_adj)"  "刀具长度调整"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,t_code)"          "T 代码"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,t_code,conf)"     "配置"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off)"         "长度补偿寄存器"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off,min)"     "最小值"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off,max)"     "最大值"

### Set Modes
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,name)"               "设置模式"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,out_mode)"           "输出模式"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code)"             "G 代码"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code,absolute)"    "绝对"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code,incremental)" "增量"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,rotary_axis)"        "旋转轴可以是递增的"

### Spindle RPM
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,name)"                     "主轴 RPM"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code)"               "主轴方向 M 代码"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code,cw)"            "顺时针 (CW)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code,ccw)"           "逆时针 (CCW)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control)"            "主轴范围控制"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control,dwell_time)" "范围更改驻留时间（秒）"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control,range_code)" "指定范围代码"

### Spindle CSS
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,name)"             "主轴 CSS"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code)"           "主轴 G 代码"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,const)"     "恒定表面代码"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,max)"       "最大 RPM 代码"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,sfm)"       "用于取消 SFM 的代码"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,max)"              "CSS 中的最大 RPM"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,sfm)"              "始终让 IPR 模式用于 SFM"

### Spindle Off
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,name)"             "主轴关"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,dir_m_code)"       "主轴方向 M 代码"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,dir_m_code,off)"   "关"

### Coolant On
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,name)"              "冷却液开"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code)"            "M 代码"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,on)"         "开"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,flood)"      "液态"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,mist)"       "雾状"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,thru)"       "通孔"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,tap)"        "攻丝"

### Coolant Off
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,name)"             "冷却液关"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,m_code)"           "M 代码"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,m_code,off)"       "关"

### Inch Metric Mode
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,name)"            "英寸公制模式"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code)"          "G 代码"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code,english)"  "英制（英寸）"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code,metric)"   "公制（毫米）"

### Feedrates
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,name)"               "进给率"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,ipm_mode)"           "IPM 模式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,ipr_mode)"           "IPR 模式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,dpm_mode)"           "DPM 模式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mmpm_mode)"          "MMPM 模式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mmpr_mode)"          "MMPR 模式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,frn_mode)"           "FRN 模式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,g_code)"             "G 代码"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,format)"             "格式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,max)"                "最大值"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,min)"                "最小值"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,label)"         "进给率模式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,lin)"           "仅线性"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rot)"           "仅旋转"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,lin_rot)"       "线性和旋转"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_lin)"       "仅快速线性"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_rot)"       "仅快速旋转"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_lin_rot)"   "快速线性和旋转"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,cycle_mode)"         "循环进给率模式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,cycle)"              "循环"

### Cutcom On
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,name)"               "刀具补偿打开"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,g_code)"             "G 代码"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,left)"               "左"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,right)"              "右"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,app_planes)"         "适用平面"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,edit_planes)"        "编辑平面代码"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,reg)"                "刀具补偿寄存器"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,min)"                "最小值"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,max)"                "最大值"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,bef)"                "换刀前关闭刀具补偿"

### Cutcom Off
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,name)"              "刀具补偿关闭"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,g_code)"            "G 代码"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,off)"               "关"

### Delay
::msgcat::mcset $gPB(LANG) "MC(event,delay,name)"                   "延迟"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds)"                "秒"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds,g_code)"         "G 代码"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds,format)"         "格式"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode)"               "输出模式"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,sec)"           "仅秒数"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,rev)"           "仅转数"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,feed)"          "依赖于进给率"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,ivs)"           "反向时间"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution)"             "转"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution,g_code)"      "G 代码"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution,format)"      "格式"

### Option Stop
::msgcat::mcset $gPB(LANG) "MC(event,opstop,name)"                  "选择性停刀"

### Auxfun
::msgcat::mcset $gPB(LANG) "MC(event,auxfun,name)"                  "辅助功能"

### Prefun
::msgcat::mcset $gPB(LANG) "MC(event,prefun,name)"                  "预览功能"

### Load Tool
::msgcat::mcset $gPB(LANG) "MC(event,loadtool,name)"                "加载刀具"

### Stop
::msgcat::mcset $gPB(LANG) "MC(event,stop,name)"                    "停止"

### Tool Preselect
::msgcat::mcset $gPB(LANG) "MC(event,toolpreselect,name)"           "刀具预选"

### Thread Wire
::msgcat::mcset $gPB(LANG) "MC(event,threadwire,name)"              "螺纹线"

### Cut Wire
::msgcat::mcset $gPB(LANG) "MC(event,cutwire,name)"                 "切割线"

### Wire Guides
::msgcat::mcset $gPB(LANG) "MC(event,wireguides,name)"              "捆丝导向器"

### Linear Move
::msgcat::mcset $gPB(LANG) "MC(event,linear,name)"                  "线性移动"
::msgcat::mcset $gPB(LANG) "MC(event,linear,g_code)"                "G 代码"
::msgcat::mcset $gPB(LANG) "MC(event,linear,motion)"                "线性运动"
::msgcat::mcset $gPB(LANG) "MC(event,linear,assume)"                "最大移刀速度时设为快速模式"

### Circular Move
::msgcat::mcset $gPB(LANG) "MC(event,circular,name)"                "圆周移动"
::msgcat::mcset $gPB(LANG) "MC(event,circular,g_code)"              "运动 G 代码"
::msgcat::mcset $gPB(LANG) "MC(event,circular,clockwise)"           "顺时针 (CLW)"
::msgcat::mcset $gPB(LANG) "MC(event,circular,counter-clock)"       "逆时针 (CCLW)"
::msgcat::mcset $gPB(LANG) "MC(event,circular,record)"              "循环记录"
::msgcat::mcset $gPB(LANG) "MC(event,circular,full_circle)"         "整圆"
::msgcat::mcset $gPB(LANG) "MC(event,circular,quadrant)"            "象限"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_def)"             "IJK 定义"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ij_def)"              "IJ 定义"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ik_def)"              "IK 定义"
::msgcat::mcset $gPB(LANG) "MC(event,circular,planes)"              "适用平面"
::msgcat::mcset $gPB(LANG) "MC(event,circular,edit_planes)"         "编辑平面代码"
::msgcat::mcset $gPB(LANG) "MC(event,circular,radius)"              "半径"
::msgcat::mcset $gPB(LANG) "MC(event,circular,min)"                 "最小值"
::msgcat::mcset $gPB(LANG) "MC(event,circular,max)"                 "最大值"
::msgcat::mcset $gPB(LANG) "MC(event,circular,arc_len)"             "最小圆弧长度"

### Rapid Move
::msgcat::mcset $gPB(LANG) "MC(event,rapid,name)"                   "快速移动"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,g_code)"                 "G 代码"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,motion)"                 "快速运动"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,plane_change)"           "工作平面更改"

### Lathe Thread
::msgcat::mcset $gPB(LANG) "MC(event,lathe,name)"                   "车螺纹"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,g_code)"                 "螺纹 G 代码"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,cons)"                   "常数"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,incr)"                   "增量"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,decr)"                   "递减"

### Cycle
::msgcat::mcset $gPB(LANG) "MC(event,cycle,g_code)"                 "G 代码和定制"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,customize,Label)"        "定制"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,customize,Context)"      "此开关允许您定制一个循环。\n\n默认情况下，每个循环的基本构造由“公共参数”的设置定义。每个循环中这些常用单元受到限制而无法修改。\n\n打开此开关允许您获得对循环配置的完全控制。对“公共参数”所作的更改将不再影响任何定制循环。"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,Label)"            "循环开始"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,Context)"          "如果有在定义了循环 (G81...) 后使用循环开始块 (G79...) 来执行循环的机床，可以针对这些机床打开此选项。"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,text)"             "使用循环开始块执行循环"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,rapid_to)"               "快速 - 至"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,retract_to)"             "退刀 - 至"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_control)"          "循环平面控制"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,com_param,name)"         "公共参数"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,cycle_off,name)"         "循环关闭"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_chng,name)"        "循环平面更改"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill,name)"             "钻"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_dwell,name)"       "钻驻留"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_text,name)"        "钻文本"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_csink,name)"       "钻埋头孔"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_deep,name)"        "深钻"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_brk_chip,name)"    "钻断屑"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap,name)"               "攻丝"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore,name)"              "镗"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_dwell,name)"        "镗驻留"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_drag,name)"         "快退镗"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_no_drag,name)"      "镗，横向偏置后快退"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_back,name)"         "退刀镗"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_manual,name)"       "手工退刀镗"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_manual_dwell,name)" "手工退刀镗延时"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,peck_drill,name)"        "啄钻"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,break_chip,name)"        "断屑"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_dwell_sf,name)"    "钻延时（孔口平面）"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_deep_peck,name)"   "深钻（啄）"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_ream,name)"         "镗（铰）"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_no-drag,name)"      "镗，横向偏置后快退"

##------------
## G Code
##
::msgcat::mcset $gPB(LANG) "MC(g_code,rapid,name)"                  "快速运动"
::msgcat::mcset $gPB(LANG) "MC(g_code,linear,name)"                 "线性运动"
::msgcat::mcset $gPB(LANG) "MC(g_code,circular_clw,name)"           "圆弧插补 CLW"
::msgcat::mcset $gPB(LANG) "MC(g_code,circular_cclw,name)"          "圆弧插补 CCLW"
::msgcat::mcset $gPB(LANG) "MC(g_code,delay_sec,name)"              "延迟（秒）"
::msgcat::mcset $gPB(LANG) "MC(g_code,delay_rev,name)"              "延迟（转）"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_xy,name)"                 "平面 XY"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_zx,name)"                 "平面 ZX"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_yz,name)"                 "平面 YZ"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_off,name)"             "刀具补偿关闭"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_left,name)"            "刀具补偿左"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_right,name)"           "刀具补偿右"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_plus,name)"            "刀具长度调整加"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_minus,name)"           "刀具长度调整减"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_off,name)"             "刀具长度调整关闭"
::msgcat::mcset $gPB(LANG) "MC(g_code,inch,name)"                   "英制模式"
::msgcat::mcset $gPB(LANG) "MC(g_code,metric,name)"                 "公制模式"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_start,name)"            "循环开始代码"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_off,name)"              "循环关闭"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill,name)"            "循环钻"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_dwell,name)"      "循环钻驻留"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_deep,name)"       "循环深钻"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_bc,name)"         "循环钻断屑"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap,name)"                    "循环攻丝"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore,name)"                   "循环镗"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_drag,name)"              "循环快退镗"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_no_drag,name)"           "循环镗，横向偏置后快退"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_dwell,name)"             "循环镗驻留"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_manual,name)"            "循环手工镗"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_back,name)"              "循环退刀镗"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_manual_dwell,name)"      "循环手工驻留镗"
::msgcat::mcset $gPB(LANG) "MC(g_code,abs,name)"                    "绝对模式"
::msgcat::mcset $gPB(LANG) "MC(g_code,inc,name)"                    "递增模式"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_retract_auto,name)"     "循环退刀（自动）"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_retract_manual,name)"   "循环退刀（手工）"
::msgcat::mcset $gPB(LANG) "MC(g_code,reset,name)"                  "重置"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_ipm,name)"                 "进给率模式 IPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_ipr,name)"                 "进给率模式 IPR"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_frn,name)"                 "进给率模式 FRN"
::msgcat::mcset $gPB(LANG) "MC(g_code,spindle_css,name)"            "主轴 CSS"
::msgcat::mcset $gPB(LANG) "MC(g_code,spindle_rpm,name)"            "主轴 RPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,ret_home,name)"               "回零"
::msgcat::mcset $gPB(LANG) "MC(g_code,cons_thread,name)"            "恒定螺纹"
::msgcat::mcset $gPB(LANG) "MC(g_code,incr_thread,name)"            "递增螺纹"
::msgcat::mcset $gPB(LANG) "MC(g_code,decr_thread,name)"            "递减螺纹"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_in,pm)"              "进给率模式 IPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_in,pr)"              "进给率模式 IPR"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_mm,pm)"              "进给率模式 MMPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_mm,pr)"              "进给率模式 MMPR"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode,dpm)"                "联邦制模式 DPM"

##------------
## M Code
##
::msgcat::mcset $gPB(LANG) "MC(m_code,stop_manual_tc,name)"         "停止/手工换刀"
::msgcat::mcset $gPB(LANG) "MC(m_code,stop,name)"                   "停止"
::msgcat::mcset $gPB(LANG) "MC(m_code,opt_stop,name)"               "选择性停刀"
::msgcat::mcset $gPB(LANG) "MC(m_code,prog_end,name)"               "程序结束"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_clw,name)"            "主轴开/CLW"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_cclw,name)"           "主轴 CCLW"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type1)"          "恒定螺纹"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type2)"          "递增螺纹"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type3)"          "递减螺纹"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_off,name)"            "主轴关"
::msgcat::mcset $gPB(LANG) "MC(m_code,tc_retract,name)"             "换刀/退刀"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_on,name)"             "冷却液开"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_fld,name)"            "液态冷却液"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_mist,name)"           "雾状冷却液"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_thru,name)"           "冷却液通孔"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_tap,name)"            "冷却液攻丝"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_off,name)"            "冷却液关"
::msgcat::mcset $gPB(LANG) "MC(m_code,rewind,name)"                 "倒回"
::msgcat::mcset $gPB(LANG) "MC(m_code,thread_wire,name)"            "螺纹线"
::msgcat::mcset $gPB(LANG) "MC(m_code,cut_wire,name)"               "切割线"
::msgcat::mcset $gPB(LANG) "MC(m_code,fls_on,name)"                 "平齐开"
::msgcat::mcset $gPB(LANG) "MC(m_code,fls_off,name)"                "平齐关"
::msgcat::mcset $gPB(LANG) "MC(m_code,power_on,name)"               "电源开"
::msgcat::mcset $gPB(LANG) "MC(m_code,power_off,name)"              "电源关"
::msgcat::mcset $gPB(LANG) "MC(m_code,wire_on,name)"                "割线开"
::msgcat::mcset $gPB(LANG) "MC(m_code,wire_off,name)"               "割线关"
::msgcat::mcset $gPB(LANG) "MC(m_code,pri_turret,name)"             "主转塔"
::msgcat::mcset $gPB(LANG) "MC(m_code,sec_turret,name)"             "辅助转塔"

##------------
## UDE
##
::msgcat::mcset $gPB(LANG) "MC(ude,editor,enable,Label)"            "启用 UDE 编辑器"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,enable,as_saved,Label)"   "按照保存的"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,TITLE)"                   "用户定义事件"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,no_ude)"                  "没有相关的 UDE！"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,int,Label)"               "整数"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,int,Context)"             "添加新的整数参数，方法是将它拖到右侧列表中。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,real,Label)"              "实数"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,real,Context)"            "添加新的实数参数，方法是将它拖到右侧列表中。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,txt,Label)"               "文本"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,txt,Context)"             "添加新的字符串参数，方法是将它拖到右侧列表中。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,bln,Label)"               "布尔"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bln,Context)"             "添加新的布尔参数，方法是将它拖动到右侧列表中。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,Label)"               "选项"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,Context)"             "添加新的选项参数，方法是将它拖到右侧列表中。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,Label)"               "点"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,Context)"             "添加新的点参数，方法是将它拖到右侧列表中。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,trash,Label)"             "编辑器 -- 垃圾桶"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,trash,Context)"           "通过将参数拖动到垃圾桶，可以移除右侧列表中不想要的参数。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,event,Label)"             "事件"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,event,Context)"           "您可以使用 MB1 在此编辑事件的参数。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,Label)"             "事件 -- 参数"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,Context)"           "您可以通过右键单击编辑各参数，或者通过拖放更改参数顺序。\n \n浅蓝色参数是系统定义参数，不能删除。\n实木色参数是非系统定义参数，可以修改或删除。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,edit,Label)"        "参数 -- 选项"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,edit,Context)"      "单击鼠标键 1 选择默认选项。\n双击鼠标键 1 编辑选项。"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,editor,Label)"      "参数类型： "

::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,sel,Label)"           "选择"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,dsp,Label)"           "显示"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,ok,Label)"            "确定"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,bck,Label)"           "后退"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,cnl,Label)"           "取消"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PL,Label)"       "参数标签"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,VN,Label)"       "变量名"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,DF,Label)"       "默认值"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PL,Context)"     "指定参数标签"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,VN,Context)"     "指定变量名"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,DF,Context)"     "指定默认值"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG)"             "切换"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG,B,Label)"     "切换"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG,B,Context)"   "选择切换的值"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ON,Label)"       "开"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OFF,Label)"      "关"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ON,Context)"     "选择默认值为“开”"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OFF,Context)"    "选择默认值为“关”"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OL)"             "选项列表"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ADD,Label)"      "添加"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,CUT,Label)"      "剪切"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PASTE,Label)"    "粘贴"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ADD,Context)"    "添加项"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,CUT,Context)"    "剪切项"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PASTE,Context)"  "粘贴项"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ENTRY,Label)"    "选项"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ENTRY,Context)"  "输入项"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EN,Label)"       "事件名称"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EN,Context)"     "指定事件名称"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,Label)"      "后处理名称"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,Context)"    "指定后处理名称"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,C,Label)"    "后处理名称"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,C,Context)"  "此开关允许您设置或不设置后处理名称"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,Label)"       "事件标签"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,Context)"     "指定事件标签"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,C,Label)"     "事件标签"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,C,Context)"   "此开关允许您设置或不设置事件标签"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC,Label)"           "类别"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC,Context)"         "此开关允许您设置或不设置类别"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_MILL,Label)"      "铣"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_DRILL,Label)"     "钻"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_LATHE,Label)"     "车"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_WEDM,Label)"      "线切割"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_MILL,Context)"    "设置铣类别"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_DRILL,Context)"   "设置钻类别"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_LATHE,Context)"   "设置车类别"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_WEDM,Context)"    "设置线切割类别"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,EDIT)"                    "编辑事件"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,CREATE)"                  "创建机床控制事件"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,HELP)"              "帮助"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,EDIT)"              "编辑用户定义参数..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,EDIT)"              "编辑..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,VIEW)"              "查看..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,DELETE)"            "删除"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,CREATE)"            "新建机床控制事件..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,IMPORT)"            "导入机床控制事件..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_BLANK)"         "事件名称不能为空！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_SAMENAME)"      "事件名称已经存在！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_SameHandler)"   "事件处理程序已经存在！\n如果已经将其选中，请修改事件名称或后处理名称！"
::msgcat::mcset $gPB(LANG) "MC(ude,validate)"                       "此事件中没有参数！"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,tab,Label)"                 "用户定义事件"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,ude,Label)"                 "机床控制事件"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,udc,Label)"                 "用户自定义循环"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,mc,Label)"                  "系统机床控制事件"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,nmc,Label)"                 "非系统机床控制事件"
::msgcat::mcset $gPB(LANG) "MC(udc,prev,sys,Label)"                 "系统循环"
::msgcat::mcset $gPB(LANG) "MC(udc,prev,nsys,Label)"                "非系统循环"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,Status)"                    "选择定义项"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_BLANK)"           "选项字符串不能为空！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_SAME)"            "选项字符串已经存在！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_PST_SAME)"        "您粘贴的选项已经存在！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_IDENTICAL)"       "有些选项相同！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,NO_OPT)"              "列表中没有选项！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_NO_VNAME)"      "变量名不能为空！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_EXIST_VNAME)"   "变量名已经存在！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,spindle_css,INFO)"        "此事件与\"主轴 RPM\" 共享 UDE。"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr,Label)"               "从后处理继承 UDE"

::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr,Context)"             "此选项使此后处理可以从某个后处理继承 UDE 定义及其处理程序。"

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,Label)"               "选择后处理"

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,Context)"             "选择所需后处理的 PUI 文件。建议将所有与正在继承的后处理相关的文件（PUI、Def、Tcl 和 CDL）放置在相同的目录（文件夹）中，供运行时使用。"

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_cdl,Label)"          "CDL 文件名"

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_cdl,Context)"        "要在此后处理的定义文件中引用（包括）的与选定后处理相关的 CDL 文件的路径和文件名。路径名必须以 UG 环境变量 (\\\$UGII) 开始，或者无路径。如果未指定路径，则由 UG/NX 在运行时使用 UGII_CAM_FILE_SEARCH_PATH 定位文件。"

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_def,Label)"          "Def 文件名"
::msgcat::mcset $gPB(LANG) "MC(ude,import,name_def,Context)"        "要在此后处理的定义文件中引用（包括）的选定后处理的定义文件路径和文件名。路径名必须以 UG 环境变量 (\\\$UGII) 开始，或者无路径。如果未指定路径，则由 UG/NX 在运行时使用 UGII_CAM_FILE_SEARCH_PATH 定位文件。"

::msgcat::mcset $gPB(LANG) "MC(ude,import,include_cdl,Label)"       "CDL"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_pst,Label)"           "后处理"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_folder,Label)"        "文件夹"
::msgcat::mcset $gPB(LANG) "MC(ude,import,own_folder,Label)"        "文件夹"
::msgcat::mcset $gPB(LANG) "MC(ude,import,own,Label)"               "包括自身 CDL 文件"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own,Context)"             "此选项使此后处理可以在其定义文件包括对其自身 CDL 文件的参考。"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own_ent,Label)"           "自身 CDL 文件"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own_ent,Context)"         "要在此后处理的定义文件中引用（包括）的与该后处理相关的 CDL 文件的路径和文件名。实际文件名将在保存此后处理时决定。路径名必须以 UG 环境变量 (\\\$UGII) 开始，或者无路径。如果未指定路径，则由 UG/NX 在运行时使用 UGII_CAM_FILE_SEARCH_PATH 定位文件。"

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,pui,status)"          "选择 PUI 文件"
::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,cdl,status)"          "选择 CDL 文件"

##---------
## UDC
##
::msgcat::mcset $gPB(LANG) "MC(udc,editor,TITLE)"                   "用户定义循环"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CREATE)"                  "创建用户定义的循环"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,TYPE)"                    "循环类型"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,type,UDC)"                "用户定义"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,type,SYSUDC)"             "系统定义"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,Label)"            "循环标签"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCNAME,Label)"           "循环名称"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,Context)"          "指定循环标签"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCNAME,Context)"         "指定循环名称"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,C,Label)"          "循环标签"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,C,Context)"        "此开关允许您设置循环标签"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,EDIT)"              "编辑用户定义参数..."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_BLANK)"         "循环名称不能为空！"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SAMENAME)"      "循环名称已经存在！"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SameHandler)"   "事件处理程序已经存在！\n请修改循环事件名称！"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_ISSYSCYC)"      "循环名称属于系统循环类型！"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SYSCYC_EXIST)"  "此类系统循环已经存在！"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,EDIT)"                    "编辑循环事件"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,CREATE)"            "新建用户定义的循环..."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,IMPORT)"            "导入用户定义的循环..."
::msgcat::mcset $gPB(LANG) "MC(udc,drill,csink,INFO)"               "此事件与钻共享处理程序！"
::msgcat::mcset $gPB(LANG) "MC(udc,drill,simulate,INFO)"            "此事件是一种仿真循环！"
::msgcat::mcset $gPB(LANG) "MC(udc,drill,dwell,INFO)"               "此事件与以下对象共享用户定义的循环： "


#######
# IS&V
#######
::msgcat::mcset $gPB(LANG) "MC(isv,tab,label)"                      "虚拟 N/C 控制器"
::msgcat::mcset $gPB(LANG) "MC(isv,Status)"                         "指定 ISV 的参数"
::msgcat::mcset $gPB(LANG) "MC(isv,review,Status)"                  "审核 VNC 命令"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,Label)"                    "配置"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_command,Label)"              "VNC 命令"
####################
# General Definition
####################
::msgcat::mcset $gPB(LANG) "MC(isv,select_Main)"                    "为附属的 VNC 选择主 VNC 文件。"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,machine,Label)"            "机床"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,component,Label)"          "刀具安装"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs_frame,Label)"      "程序零参考"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs,Label)"            "组件"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs,Context)"          "指定组件作为 ZCS 参考基础。它应是在运动学树中与部件直接或间接相连的非旋转组件。"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_com,Label)"           "组件"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_com,Context)"         "指定用于安装刀具的组件。它应是铣后处理的主轴组件或车后处理的转塔组件。"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_jct,Label)"           "联接"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_jct,Context)"         "定义用于安装刀具的联接。它是铣后处理主轴面中心处的联接，或者是车后处理的转塔旋转联接。如果转塔是固定的，则是刀具安装联接。"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_name,Label)"          "机床上指定的轴"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_name,Context)"        "指定轴名称以匹配您的机床运动学配置"




::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_frm,Label)"           "NC 轴名称"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fourth,Label)"         "反向旋转"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fourth,Context)"       "指定轴的旋转方向。方向可以是反向或者法向。这只适用于转台。"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fifth,Label)"          "反向旋转"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_limit,Label)"       "旋转限制"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_limit,Context)"     "指定此旋转轴是否具有限制"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fifth_limit,Label)"        "旋转限制"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,limiton,Label)"            "是"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,limitoff,Label)"           "否"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_table,Label)"       "第 4 轴"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fifth_table,Label)"        "第 5 轴"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,header,Label)"             " 转台 "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,intialization,Label)"      "控制器"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,general_def,Label)"        "初始设置"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,advanced_def,Label)"       "其他选项"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,InputOutput,Label)"        "特殊 NC 代码"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,program,Label)"            "默认程序定义"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,output,Label)"             "导出程序定义"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,output,Context)"           "保存程序定义到文件"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,input,Label)"              "导入程序定义"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,input,Context)"            "从文件调用程序定义"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,file_err,Msg)"             "选定文件不匹配默认程序定义文件的类型，要继续吗？"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,wcs,Label)"                "装夹偏置"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,tool,Label)"               "刀具数据"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,g_code,Label)"             "特殊 G 代码"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,special_vnc,Label)"        "特殊 NC 代码"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial,frame,Label)"      ""
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_motion,Label)"     "运动"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_motion,Context)"   "指定机床的初始运动"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle,frame,Label)"      "主轴"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle_mode,Label)"       "模式"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle_direction,Label)"  "方向"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle,frame,Context)"    "指定初始主轴速度单位和旋转方向"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,feedrate_mode,Label)"      "进给率模式"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,feedrate_mode,Context)"    "指定初始进给率单位"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,boolean,frame,Label)"      "布尔项定义"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,power_on_wcs,Label)"       "开启 WCS  "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,power_on_wcs,Context)"     "0 表示将使用默认机床零坐标\n 1 表示将使用第一个用户定义装夹偏置（工作坐标）"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,use_s_leader,Label)"       "使用 S"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,use_f_leader,Label)"       "使用 F"


::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,Label)"            "快速折线"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,Context)"          "“开”将按照折线样式遍历快速移动；“关”则按照 NC 代码（点到点）遍历快速移动。"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,yes)"              "是"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,no)"               "否"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,on_off_frame,Label)"       "开/关定义"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,stroke_limit,Label)"       "行程限制"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,cutcom,Label)"             "刀具补偿"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,tl_adjust,Label)"          "刀具长度调整"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,scale,Label)"              "比例"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,macro_modal,Label)"        "宏模态"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,wcs_rotate,Label)"         "WCS 旋转"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,cycle,Label)"              "循环"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_mode,frame,Label)"     "输入模式"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_mode,frame,Context)"   "将初始输入模式指定为绝对的或递增的"

###################
# Input/Out Related
###################
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,frame,Label)"        ""
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,rewindstop,Label)"   "倒回停止代码"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,rewindstop,Context)" "指定倒回停止代码"

::msgcat::mcset $gPB(LANG) "MC(isv,control_var,frame,Label)"        "控制变量"

::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,convarleader,Label)"     "引导符"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,convarleader,Context)"   "指定控制器变量"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,conequ,Label)"           "等号"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,conequ,Context)"         "指定等号为控制变量"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,percent,Label)"          "百分号 %"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,leaderjing,Label)"       "井号 #"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,text_string,Label)"      "文本字符串"

::msgcat::mcset $gPB(LANG) "MC(isv,inputmode,frame,Label)"          ""
::msgcat::mcset $gPB(LANG) "MC(isv,input_mode,Label)"               "初始模式"
::msgcat::mcset $gPB(LANG) "MC(isv,absolute_mode,Label)"            "绝对"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_style,frame,Label)"  "递增模式"

::msgcat::mcset $gPB(LANG) "MC(isv,incremental_mode,Label)"         "增量"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_gcode,Label)"        "G 代码"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_gcode,Context)"      "使用 G90 G91 区分绝对模式或递增模式"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_uvw,Label)"          "特殊引导符"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_uvw,Context)"        "使用特殊引导符区分绝对模式或递增模式。例如引导符 X Y Z 表示处于绝对模式，引导符 U V W 表示处于递增模式。"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_x,Label)"                   "X "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_y,Label)"                   "Y "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_z,Label)"                   "Z "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_a,Label)"                   "第四轴 "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_b,Label)"                   "第五轴 "

::msgcat::mcset $gPB(LANG) "MC(isv,incr_x,Context)"                 "指定递增模式中使用的特殊 X 轴引导符"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_y,Context)"                 "指定递增模式中使用的特殊 Y 轴引导符"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_z,Context)"                 "指定递增模式中使用的特殊 Z 轴引导符"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_a,Context)"                 "指定递增模式中使用的特殊第四轴引导符"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_b,Context)"                 "指定递增模式中使用的特殊第五轴引导符"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_mes,frame,Label)"            "输出 VNC 消息"

::msgcat::mcset $gPB(LANG) "MC(isv,vnc_message,Label)"              "列出 VNC 消息"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_message,Context)"            "如果选中此选项，则仿真过程中将在工序消息窗口中显示所有 VNC 调试消息。"

::msgcat::mcset $gPB(LANG) "MC(isv,vnc_mes,prefix,Label)"           "消息前缀"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_desc,Label)"                "描述"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,Label)"            "代码列表"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_nccode,Label)"              "NC 代码/字符串"

################
# WCS Definition
################
::msgcat::mcset $gPB(LANG) "MC(isv,machine_zero,offset,Label)"      "机床零偏置自\n机床零联接"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,frame,Label)"         "装夹偏置"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_leader,Label)"               " 代码 "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_number,Label)"               "    "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_x,Label)"      " X 偏置  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_y,Label)"      " Y 偏置  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_z,Label)"      " Z 偏置  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,a_offset,Label)"      " A 偏置  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,b_offset,Label)"      " B 偏置  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,c_offset,Label)"      " C 偏置  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_num,Label)"       "坐标系"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_num,Context)"     "指定需要添加的装夹偏置数值"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_add,Label)"       "添加"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_add,Context)"     "添加新的装夹偏置坐标系，指定其位置"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_err,Msg)"         "此坐标系号已经存在！"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,frame,Label)"          "刀具信息"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_entry,Label)"     "输入新的刀具名称"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_name,Label)"      "       名称       "

::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_num,Label)"       " 刀具 "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_tool,Label)"       "添加"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_diameter,Label)"  " 直径 "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,offset_usder,Label)"   "   刀尖偏置   "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,carrier_id,Label)"     " 刀架 ID "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,pocket_id,Label)"      " 刀槽 ID "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutcom_reg,Label)"     "     刀具补偿     "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutreg,Label)"         "寄存器 "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutval,Label)"         "偏置 "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,adjust_reg,Label)"     " 长度调整 "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_type,Label)"      "   类型   "
::msgcat::mcset $gPB(LANG) "MC(isv,prog,setup,Label)"               "默认程序定义"
::msgcat::mcset $gPB(LANG) "MC(isv,prog,setup_right,Label)"         "程序定义"
::msgcat::mcset $gPB(LANG) "MC(isv,output,setup_data,Label)"        "指定程序定义文件"
::msgcat::mcset $gPB(LANG) "MC(isv,input,setup_data,Label)"         "选择程序定义文件"

::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,toolnum,Label)"        "刀具号  "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,toolnum,Context)"      "指定需要添加的刀具号"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_tool,Context)"     "添加新刀具，指定其参数"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_err,Msg)"          "此刀具号已经存在！"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,name_err,Msg)"         "刀具名称不能为空！"

###########################
# Special G code Definition
###########################

::msgcat::mcset $gPB(LANG) "MC(isv,g_code,frame,Label)"             "特殊 G 代码"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,frame,Context)"           "指定仿真中使用的特殊 G 代码"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,from_home,Label)"         "自零点"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,return_home,Label)"       "回零点 Pn"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,mach_wcs,Label)"          "机床基准移动"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,set_local,Label)"         "设置局部坐标"

###########################
# Special NC Custom Command
###########################

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,frame,Label)"       "特殊 NC 命令"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,frame,Context)"     "为特殊设备指定的 NC 命令"


::msgcat::mcset $gPB(LANG) "MC(isv,spec_pre,frame,Label)"           "预处理命令"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_pre,frame,Context)"         "命令列表包含在解析块以获取坐标前需要处理的所有标记或符号"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add,Label)"         "添加"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,edit,Label)"        "编辑"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,delete,Label)"      "删除"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,title,Label)"       "其他设备的特殊命令"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add_sim,Label)"     "在光标处添加 SIM 命令"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,init_sim,Label)"    "请选择一个命令"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,preleader,Label)"   "引导符"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,preleader,Context)" "指定用户定义预处理命令的引导符。"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,precode,Label)"     "代码"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,precode,Context)"   "指定用户定义预处理命令的引导符。"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,leader,Label)"      "引导符"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,leader,Context)"    "指定用户定义命令的引导符。"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,code,Label)"        "代码"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,code,Context)"      "指定用户定义命令的引导符。"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add,Context)"       "添加新的用户定义命令"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add_err,Msg)"       "此标记已被处理！"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,sel_err,Msg)"       "请选择一个命令"
::msgcat::mcset $gPB(LANG) "MC(isv,export,error,title)"             "警告"

::msgcat::mcset $gPB(LANG) "MC(isv,tool_table,title,Label)"         "刀具表"
::msgcat::mcset $gPB(LANG) "MC(isv,ex_editor,warning,Msg)"          "这是系统生成的 VNC 命令。将不保存更改。"


# - Languages
#
::msgcat::mcset $gPB(LANG) "MC(language,Label)"                     "语言"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_english)"                     "英语"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_french)"                      "法语"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_german)"                      "德语"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_italian)"                     "意大利语"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_japanese)"                    "日语"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_korean)"                      "韩语"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_russian)"                     "俄语"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_simple_chinese)"              "简体中文"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_spanish)"                     "西班牙语"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_traditional_chinese)"         "繁体中文"

### Exit Options Dialog
::msgcat::mcset $gPB(LANG) "MC(exit,options,Label)"                 "退出选项"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveAll,Label)"         "退出且全部保存"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveNone,Label)"        "退出但不保存"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveSelect,Label)"      "退出且保存选定的"

### OptionMenu Items
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Other)"       "其他"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,None)"        "无"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,RT_R)"        "快速移刀和 R"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Rapid)"       "快进"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,RS)"          "快速主轴"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,C_off_RS)"    "“循环关”，然后“快速主轴”"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,IPM)"         "IPM"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,FRN)"         "FRN"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,IPR)"         "IPR"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Auto)"        "自动"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,DPM)"         "DPM"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Abs_Inc)"     "绝对/递增"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Abs_Only)"    "仅绝对"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Inc_Only)"    "仅递增"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,SD)"          "最短距离"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,AP)"          "始终为正"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,AN)"          "始终为负"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Z_Axis)"      "Z 轴"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,+X_Axis)"     "+X 轴"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,-X_Axis)"     "-X 轴"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Y_Axis)"      "Y 轴"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,MDD)"         "幅值决定方向"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,SDD)"         "符号决定方向"


