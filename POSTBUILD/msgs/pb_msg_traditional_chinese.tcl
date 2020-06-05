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
::msgcat::mcset $gPB(LANG) "MC(msg,filename_with_spec_char)"              "檔名包含不受支援的特殊字元！"
::msgcat::mcset $gPB(LANG) "MC(msg,not_post_comp_file)"                   "可能沒有為此包含選取立柱的自有元件！"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,warn_file)"         "警告檔案"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,nc_output)"         "NC 輸出"

#=============================================================================
# pb10.02
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,check,Label)"           "抑制檢查目前後處理"
::msgcat::mcset $gPB(LANG) "MC(main,options,debug,Label)"                 "嵌入後處理偵錯訊息"
::msgcat::mcset $gPB(LANG) "MC(encrypt,suppress,Label)"                   "停用目前後處理的授權變更"
::msgcat::mcset $gPB(LANG) "MC(main,title,license_control)"               "授權控制"

#=============================================================================
# pb902
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(other,ude_include_def,Label)"              "包含其他 CDL 或 DEF 檔案"
#-----------------------------------------------------------------------------
# Labels for new tapping cycles
#-----------------------------------------------------------------------------
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_deep,name)"                "深攻絲"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_break_chip,name)"          "斷屑攻絲"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_float,name)"                    "淺攻絲"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_deep,name)"                     "深攻絲"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_break_chip,name)"               "斷屑攻絲"
#-----------------------------------------------------------------------------
# Defined strings that did not make it to the local language files.
# - These strings should be included for translation in the later release.
#-----------------------------------------------------------------------------
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_change,axis,label)"      "偵測到孔之間的刀軸發生變更"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rapid)"               "快轉"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,cutting)"             "切削"

#=============================================================================
# pb800
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(event,misc,subop_start,name)"      "子工序刀軌開始"
::msgcat::mcset $gPB(LANG) "MC(event,misc,subop_end,name)"        "子工序刀軌結束"
::msgcat::mcset $gPB(LANG) "MC(event,misc,contour_start,name)"    "輪廓起點"
::msgcat::mcset $gPB(LANG) "MC(event,misc,contour_end,name)"      "輪廓終點"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,misc,Label)"             "雜項"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,lathe_rough,name)"     "車削粗加工"
::msgcat::mcset $gPB(LANG) "MC(main,file,properties,Label)"       "後處理屬性"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_CATEGORY)"    "銑床或車床後處理 UDE 可能無法僅通過 \"Wedm\" 類別指定！"

::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_change,label)"   "偵測下部的工作平面變更"
::msgcat::mcset $gPB(LANG) "MC(format,check_1,error,msg)"         "格式不適合運算式的值"

::msgcat::mcset $gPB(LANG) "MC(format,check_4,error,msg)"         "在離開或儲存此後處理之前變更相關地址的格式！"
::msgcat::mcset $gPB(LANG) "MC(format,check_5,error,msg)"         "在離開此頁或儲存此後處理之前修改格式！"
::msgcat::mcset $gPB(LANG) "MC(format,check_6,error,msg)"         "在進入此頁之前變更相關地址的格式！"

::msgcat::mcset $gPB(LANG) "MC(msg,old_block,maximum_length)"     "以下塊的名稱超出長度限制："
::msgcat::mcset $gPB(LANG) "MC(msg,old_address,maximum_length)"   "以下文字的名稱超出長度限制："
::msgcat::mcset $gPB(LANG) "MC(msg,block_address,check,title)"    "正在檢查塊和字名稱"
::msgcat::mcset $gPB(LANG) "MC(msg,block_address,maximum_length)" "一些塊或文字名稱超出長度限制。"

::msgcat::mcset $gPB(LANG) "MC(address,maximum_name_msg)"         "字串長度超出限制。"

::msgcat::mcset $gPB(LANG) "MC(ude,import,oth_list,Label)"        "包括其他 CDL 檔案"
::msgcat::mcset $gPB(LANG) "MC(ude,import,oth_list,Context)"      "右鍵點擊滑鼠，從彈出式功能表中選取\\\"新建\\\"選項以在此後處理中包含其他 CDL 檔案。"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_list,Label)"        "從後處理繼承 UDE"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_list,Context)"      "右鍵點擊滑鼠，從彈出式功能表中選取\\\"新建\\\"選項以從後處理繼承 UDE 定義和相關處理常式。"
::msgcat::mcset $gPB(LANG) "MC(ude,import,up,Label)"              "向上"
::msgcat::mcset $gPB(LANG) "MC(ude,import,down,Label)"            "向下"
::msgcat::mcset $gPB(LANG) "MC(msg,exist_cdl_file)"               "指定的 CDL 檔案已經包含在內！"

::msgcat::mcset $gPB(LANG) "MC(listing,link_var,check,Label)"     "將 Tcl 變數連結至 C 變數"
::msgcat::mcset $gPB(LANG) "MC(listing,link_var,check,Context)"   "可將一組經常變更的 Tcl 變數（例如 \\\"mom_pos\\\"）直接連結至內部 C 變數以提高後處理效能。但是，應遵循某些限制以避免 NC 輸出中可能出現的錯誤和差異。"

::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,title)"       "檢查線性/旋轉運動精度"
::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,linear)"      "格式設定可能不適合輸出的\"線性運動精度\"。"
::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,rotary)"      "格式設定可能不適合輸出的\"旋轉運動精度\"。"

::msgcat::mcset $gPB(LANG) "MC(cmd,export,desc,label)"            "輸入已匯出自訂指令的敘述"
::msgcat::mcset $gPB(LANG) "MC(cmd,desc_dlg,title)"               "敘述"
::msgcat::mcset $gPB(LANG) "MC(block,delete_row,Label)"           "刪除此列中所有使用中單元"
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,set,Label)"        "輸出條件"
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,new,Label)"        "新建..."
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,edit,Label)"       "編輯..."
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,remove,Label)"     "移除..."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_for_cond)"       "指定其他名稱。\n輸出條件指令的字首應為"

::msgcat::mcset $gPB(LANG) "MC(machine,linearization,Label)"         "線性插值"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,angle,Label)"   "旋轉角度"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,angle,Context)" "將根據旋轉軸起始角度和終止角度的分佈來計算插值點。"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,axis,Label)"    "刀軸"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,axis,Context)"  "將根據刀軸起始向量和終止向量的分佈來計算插值點。"
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,continue,Label)"   "繼續"
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,abort,Label)"      "中止"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,def_lintol,Label)"       "預設公差"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,def_lintol,Context)"     "預設線性化公差"
::msgcat::mcset $gPB(LANG) "MC(sub_post,inch,Lable)"                 "IN"
::msgcat::mcset $gPB(LANG) "MC(sub_post,metric,Lable)"               "MM"
::msgcat::mcset $gPB(LANG) "MC(new_sub,title,Label)"                 "新建副後處理器"
::msgcat::mcset $gPB(LANG) "MC(new,sub_post,toggle,label)"           "副後處理"
::msgcat::mcset $gPB(LANG) "MC(new,sub_post,toggle,tmp_label)"       "僅副後處理單位"
::msgcat::mcset $gPB(LANG) "MC(new,unit_post,filename,msg)"          "新建的備選輸出單位副後處理的命名方式應為：\n在主後處理名稱後面新增 \"__MM\" 或 \"__IN\" 字尾。"
::msgcat::mcset $gPB(LANG) "MC(new,alter_unit,toggle,label)"         "備選輸出單位"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,label)"                 "主後處理"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,warning_1,msg)"         "只可使用完整的主後處理來新建副後處理！"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,warning_2,msg)"         "必須在後處理建構器 8.0 或\n更新版本中建立或儲存主後處理。"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,specify_err,msg)"       "建立副後處理時必須指定主後處理！"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,alter_unit,Label)"        "副後處理輸出單位："
::msgcat::mcset $gPB(LANG) "MC(unit_related_param,tab,Label)"        "單位參數"
::msgcat::mcset $gPB(LANG) "MC(unit_related_param,feed_rate,Label)"  "進給率"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,frame,Label)"        "選用的備選單位副後處理"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,default,Label)"      "預設"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,default,Context)"    "備選單位副後處理的預設名稱將是 <後處理名稱>__MM 或 <後處理名稱>__IN"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,specify,Label)"      "指定"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,specify,Context)"    "指定備選單位副後處理的名稱"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,select_name,Label)"  "選取名稱"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,warning_1,msg)"      "僅可選取備選單位副後處理！"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,warning_2,msg)"      "選定的副後處理不支援此後處理的備選輸出單位！"

::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,post_name,Label)"    "備選單位副後處理"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,post_name,Context)"  "NX 後處理將使用單位副後處理（如果提供）來處理此後處理的備選輸出單位。"


##--------------------
## New string in v7.5
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,evt_title)"  "針對軸限制違例的使用者定義動作"
::msgcat::mcset $gPB(LANG) "MC(event,helix,name)"                       "螺旋移動"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_param,prefix,msg)"    "地址中使用的運算式"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_param,postfix,msg)"   "不會受此選項變更的影響！"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,default,msg)"          "此動作會將特殊 NC 程式碼及其處理常式\n的清單還原到開啟或建立此後處理檔案時的狀態。\n\n要繼續嗎？"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,restore,msg)"          "此動作會將特殊 NC 程式碼及其處理常式\n的清單還原到上次訪問此頁面時的狀態。\n\n要繼續嗎？"
::msgcat::mcset $gPB(LANG) "MC(msg,block_format_command,paste_err)"     "物件名存在...貼上無效！"
::msgcat::mcset $gPB(LANG) "MC(main,file,open,choose_cntl_type)"        "選取控制器家族"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,no_vnc_cmd,msg)"         "此檔案中沒有包含新的或不同的 VNC 指令！"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,no_cmd,msg)"             "此檔案中沒有包含新的或不同的自訂指令！"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,name_same_err,Msg)"        "刀具名稱不能相同！"
::msgcat::mcset $gPB(LANG) "MC(msg,limit_to_change_license)"            "您不是此後處理的作者。\n您無權對其重新命名或變更其授權。"
::msgcat::mcset $gPB(LANG) "MC(output,other_opts,validation,msg)"       "應指定使用者 tcl 檔案的名稱。"
::msgcat::mcset $gPB(LANG) "MC(machine,empty_entry_err,msg)"            "此參數頁面上有空條目。"
::msgcat::mcset $gPB(LANG) "MC(msg,control_v_limit)"                    "您嘗試貼上的字串可能超出\n了長度限制或者包含了多列或\n無效字元。"
::msgcat::mcset $gPB(LANG) "MC(block,capital_name_msg)"                 "塊名稱的開頭字母不能為大寫！\n指定其他名稱。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,Label)"      "使用者定義"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,Handler)"    "處理常式"
::msgcat::mcset $gPB(LANG) "MC(new,user,file,NOT_EXIST)"                "此使用者檔案不存在！"
::msgcat::mcset $gPB(LANG) "MC(new,include_vnc,Label)"                  "包含虛擬 NC 控制器"
::msgcat::mcset $gPB(LANG) "MC(other,opt_equal,Label)"                  "等號 (=)"
::msgcat::mcset $gPB(LANG) "MC(event,nurbs,name)"                       "NURBS 移動"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_float,name)"             "淺攻絲"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,thread,name)"                "螺紋加工"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,MSG_NESTED_GROUP)"      "不支援巢狀分組！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bmp,Label)"                   "點陣圖"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bmp,Context)"                 "新增點陣圖參數，方法是將它拖到右側清單中。"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,Label)"                 "分組"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,Context)"               "新增分組參數，方法是將它拖到右側清單中。"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,DESC,Label)"         "敘述"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,DESC,Context)"       "指定事件資訊"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,URL,Label)"          "URL"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,URL,Context)"        "指定事件敘述的 URL"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_IMAGE_FILE)"  "影像檔案必須採用 BMP 格式！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)" "點陣圖檔名不應包含目錄路徑！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_VAR_NAME)"    "變數名稱必須以字母開頭。"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_KEYWORD)"     "變數名稱不應使用關鍵字： "
::msgcat::mcset $gPB(LANG) "MC(ude,editor,status_label)"                "狀態"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,vector,Label)"                "向量"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,vector,Context)"              "新增向量參數，方法是將它拖到右側清單中。"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_URL_FORMAT)"        "URL 必須採用 \"http://*\" 或 \"file://*\" 格式，且不使用反斜線。"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_BLANK_HELP_INFO)"   "必須指定敘述和 URL！"
::msgcat::mcset $gPB(LANG) "MC(new,MSG_NO_AXIS)"                        "必須為車床選定軸組態。"
::msgcat::mcset $gPB(LANG) "MC(machine,info,controller_type,Label)"     "控制器家族"
::msgcat::mcset $gPB(LANG) "MC(block,func_combo,Label)"                 "巨集"
::msgcat::mcset $gPB(LANG) "MC(block,prefix_popup,add,Label)"           "新增字首文字"
::msgcat::mcset $gPB(LANG) "MC(block,prefix_popup,edit,Label)"          "編輯字首文字"
::msgcat::mcset $gPB(LANG) "MC(block,prefix,Label)"                     "字首"
::msgcat::mcset $gPB(LANG) "MC(block,suppress_popup,Label)"             "抑制序號"
::msgcat::mcset $gPB(LANG) "MC(block,custom_func,Label)"                "自訂巨集"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,macro,Label)"                  "自訂巨集"
::msgcat::mcset $gPB(LANG) "MC(func,tab,Label)"                         "巨集"
::msgcat::mcset $gPB(LANG) "MC(func,exp,msg)"                           "巨集參數的運算式不應為空。"
::msgcat::mcset $gPB(LANG) "MC(func,edit,name,Label)"                   "巨集名稱"
::msgcat::mcset $gPB(LANG) "MC(func,disp_name,Label)"                   "輸出名稱"
::msgcat::mcset $gPB(LANG) "MC(func,param_list,Label)"                  "參數清單"
::msgcat::mcset $gPB(LANG) "MC(func,separator,Label)"                   "分隔符號"
::msgcat::mcset $gPB(LANG) "MC(func,start,Label)"                       "開始字元"
::msgcat::mcset $gPB(LANG) "MC(func,end,Label)"                         "結束字元"
::msgcat::mcset $gPB(LANG) "MC(func,output,name,Label)"                 "輸出屬性"
::msgcat::mcset $gPB(LANG) "MC(func,output,check,Label)"                "輸出參數的名稱"
::msgcat::mcset $gPB(LANG) "MC(func,output,link,Label)"                 "連結字元"
::msgcat::mcset $gPB(LANG) "MC(func,col_param,Label)"                   "參數"
::msgcat::mcset $gPB(LANG) "MC(func,col_exp,Label)"                     "運算式"
::msgcat::mcset $gPB(LANG) "MC(func,popup,insert,Label)"                "新建"
::msgcat::mcset $gPB(LANG) "MC(func,name,err_msg)"                      "巨集名稱不應包含空格！"
::msgcat::mcset $gPB(LANG) "MC(func,name,blank_err)"                    "巨集名稱不應為空！"
::msgcat::mcset $gPB(LANG) "MC(func,name,contain_err)"                  "巨集名稱應只包含字母、數字和底線字元！"
::msgcat::mcset $gPB(LANG) "MC(func,tree_node,start_err)"               "節點名稱必須以大寫字母開頭！"
::msgcat::mcset $gPB(LANG) "MC(func,tree_node,contain_err)"             "節點名稱應只接受字母、數字或底線字元！"
::msgcat::mcset $gPB(LANG) "MC(func,help,Label)"                        "資訊"
::msgcat::mcset $gPB(LANG) "MC(func,help,Context)"                      "顯示物件的資訊。"
::msgcat::mcset $gPB(LANG) "MC(func,help,MSG_NO_INFO)"                  "沒有為此巨集提供任何資訊。"


##------
## Title
##
::msgcat::mcset $gPB(LANG) "MC(main,title,Unigraphics)"             "Unigraphics"
::msgcat::mcset $gPB(LANG) "MC(main,title,UG)"                      "NX"
::msgcat::mcset $gPB(LANG) "MC(main,title,Post_Builder)"            "後處理建構器"

::msgcat::mcset $gPB(LANG) "MC(main,title,Version)"                 "版本"
::msgcat::mcset $gPB(LANG) "MC(main,default,Status)"                "選取「檔案」功能表」上的「新建」或「開啟」選項。"
::msgcat::mcset $gPB(LANG) "MC(main,save,Status)"                   "儲存後處理。"

##------
## File
##
::msgcat::mcset $gPB(LANG) "MC(main,file,Label)"                    "檔案"

::msgcat::mcset $gPB(LANG) "MC(main,file,Balloon)"                  "\ 新建，開啟，儲存，\n另存\ 新檔，關閉和離開"

::msgcat::mcset $gPB(LANG) "MC(main,file,Context)"                  "\ 新建，開啟，儲存，\n另存\ 新檔，關閉和離開"
::msgcat::mcset $gPB(LANG) "MC(main,file,menu,Context)"             " "

::msgcat::mcset $gPB(LANG) "MC(main,file,new,Label)"                "新建..."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Balloon)"              "新建後處理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Context)"              "新建後處理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Busy)"                 "正在新建後處理..."

::msgcat::mcset $gPB(LANG) "MC(main,file,open,Label)"               "開啟..."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Balloon)"             "編輯現有後處理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Context)"             "編輯現有後處理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Busy)"                "正在開啟後處理..."

::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Label)"               "匯入 MDFA..."
::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Balloon)"             "從 MDFA 新建後處理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Context)"             "從 MDFA 新建後處理。"

::msgcat::mcset $gPB(LANG) "MC(main,file,save,Label)"               "儲存"
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Balloon)"             "儲存進行中的後處理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Context)"             "儲存進行中的後處理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Busy)"                "正在儲存後處理..."

::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Label)"            "另存新檔..."
::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Balloon)"          "用新名稱儲存後處理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Context)"          "用新名稱儲存後處理。"

::msgcat::mcset $gPB(LANG) "MC(main,file,close,Label)"              "關閉"
::msgcat::mcset $gPB(LANG) "MC(main,file,close,Balloon)"            "關閉進行中的後處理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,close,Context)"            "關閉進行中的後處理。"

::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Label)"               "離開"
::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Balloon)"             "終止後處理建構器。"
::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Context)"             "終止後處理建構器。"

::msgcat::mcset $gPB(LANG) "MC(main,file,history,Label)"            "最近開啟的後處理"
::msgcat::mcset $gPB(LANG) "MC(main,file,history,Balloon)"          "編輯先前訪問過的後處理。"
::msgcat::mcset $gPB(LANG) "MC(main,file,history,Context)"          "編輯在先前後處理建構器階段作業中訪問過的後處理。"

##---------
## Options
##
::msgcat::mcset $gPB(LANG) "MC(main,options,Label)"                 "選項"

::msgcat::mcset $gPB(LANG) "MC(main,options,Balloon)"               " 驗證\ 自訂\ 指令，備份\ 後處理"
::msgcat::mcset $gPB(LANG) "MC(main,options,Context)"               " "
::msgcat::mcset $gPB(LANG) "MC(main,options,menu,Context)"          " "

::msgcat::mcset $gPB(LANG) "MC(main,windows,Label)"                 "視窗"
::msgcat::mcset $gPB(LANG) "MC(main,windows,Balloon)"               "編輯後處理清單"
::msgcat::mcset $gPB(LANG) "MC(main,windows,Context)"               " "
::msgcat::mcset $gPB(LANG) "MC(main,windows,menu,Context)"          " "

::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Label)"      "屬性"
::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Balloon)"    "屬性"
::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Context)"    "屬性"

::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Label)"         "後處理顧問"
::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Balloon)"       "後處理顧問"
::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Context)"       "啟用/停用後處理顧問。"

::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Label)"       "驗證自訂指令"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Balloon)"     "驗證自訂指令"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Context)"     "自訂指令驗證開關"

::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,syntax,Label)"   "語法錯誤"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,command,Label)"  "未知指令"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,block,Label)"    "未知塊"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,address,Label)"  "未知地址"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,format,Label)"   "未知格式"

::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Label)"          "備份後處理"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Balloon)"        "備份後處理方法"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Context)"        "在儲存進行中的後處理時建立備份副本。"

::msgcat::mcset $gPB(LANG) "MC(main,options,backup,one,Label)"      "備份原始物件"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,all,Label)"      "備份每次儲存的"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,none,Label)"     "無備份"

##-----------
## Utilities
##
::msgcat::mcset $gPB(LANG) "MC(main,utils,Label)"                   "公用程式"
::msgcat::mcset $gPB(LANG) "MC(main,utils,Balloon)"                 "\ 選取 \ MOM\  變數，安裝\ 後處理"
::msgcat::mcset $gPB(LANG) "MC(main,utils,Context)"                 " "
::msgcat::mcset $gPB(LANG) "MC(main,utils,menu,Context)"            " "

::msgcat::mcset $gPB(LANG) "MC(main,utils,etpdf,Label)"             "編輯範本後處理資料檔案"

::msgcat::mcset $gPB(LANG) "MC(main,utils,bmv,Label)"               "瀏覽 MOM 變數"
::msgcat::mcset $gPB(LANG) "MC(main,utils,blic,Label)"              "瀏覽授權"


##------
## Help
##
::msgcat::mcset $gPB(LANG) "MC(main,help,Label)"                    "說明"
::msgcat::mcset $gPB(LANG) "MC(main,help,Balloon)"                  "說明選項"
::msgcat::mcset $gPB(LANG) "MC(main,help,Context)"                  "說明選項"
::msgcat::mcset $gPB(LANG) "MC(main,help,menu,Context)"             " "

::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Label)"                "符號標註提示"
::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Balloon)"              "圖示上的符號標註提示"
::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Context)"              "啟用/停用圖示上的符號標註工具提示顯示。"

::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Label)"              "上下文關聯說明"
::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Balloon)"            "對話方塊項的相關上下文關聯說明"
::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Context)"            "對話方塊項的相關上下文關聯說明"

::msgcat::mcset $gPB(LANG) "MC(main,help,what,Label)"               "執行什麼動作？"
::msgcat::mcset $gPB(LANG) "MC(main,help,what,Balloon)"             "此處您能執行什麼動作？"
::msgcat::mcset $gPB(LANG) "MC(main,help,what,Context)"             "此處您能執行什麼動作？"

::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Label)"             "對話方塊相關說明"
::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Balloon)"           "該對話方塊的相關說明"
::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Context)"           "該對話方塊的相關說明"

::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Label)"             "使用者手冊"
::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Balloon)"           "使用者說明手冊"
::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Context)"           "使用者說明手冊"

::msgcat::mcset $gPB(LANG) "MC(main,help,about,Label)"              "關於後處理建構器"
::msgcat::mcset $gPB(LANG) "MC(main,help,about,Balloon)"            "關於後處理建構器"
::msgcat::mcset $gPB(LANG) "MC(main,help,about,Context)"            "關於後處理建構器"

::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Label)"           "發行說明"
::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Balloon)"         "發行說明"
::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Context)"         "發行說明"

::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Label)"            "Tcl/Tk 參照手冊"
::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Balloon)"          "Tcl/Tk 參照手冊"
::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Context)"          "Tcl/Tk 參照手冊"

##----------
## Tool Bar
##
::msgcat::mcset $gPB(LANG) "MC(tool,new,Label)"                     "新建"
::msgcat::mcset $gPB(LANG) "MC(tool,new,Context)"                   "新建後處理。"

::msgcat::mcset $gPB(LANG) "MC(tool,open,Label)"                    "開啟"
::msgcat::mcset $gPB(LANG) "MC(tool,open,Context)"                  "編輯現有後處理。"

::msgcat::mcset $gPB(LANG) "MC(tool,save,Label)"                    "儲存"
::msgcat::mcset $gPB(LANG) "MC(tool,save,Context)"                  "儲存進行中的後處理。"

::msgcat::mcset $gPB(LANG) "MC(tool,bal,Label)"                     "符號標註提示"
::msgcat::mcset $gPB(LANG) "MC(tool,bal,Context)"                   "啟用/停用圖示上的符號標註工具提示顯示。"

::msgcat::mcset $gPB(LANG) "MC(tool,chelp,Label)"                   "上下文關聯說明"
::msgcat::mcset $gPB(LANG) "MC(tool,chelp,Context)"                 "對話方塊項的相關上下文關聯說明"

::msgcat::mcset $gPB(LANG) "MC(tool,what,Label)"                    "執行什麼動作？"
::msgcat::mcset $gPB(LANG) "MC(tool,what,Context)"                  "此處您能執行什麼動作？"

::msgcat::mcset $gPB(LANG) "MC(tool,dialog,Label)"                  "對話方塊相關說明"
::msgcat::mcset $gPB(LANG) "MC(tool,dialog,Context)"                "該對話方塊的相關說明"

::msgcat::mcset $gPB(LANG) "MC(tool,manual,Label)"                  "使用者手冊"
::msgcat::mcset $gPB(LANG) "MC(tool,manual,Context)"                "使用者說明手冊"

#=============
# Main Window
#=============

##-----------------
## Common Messages
##
::msgcat::mcset $gPB(LANG) "MC(msg,error,title)"                    "後處理建構器錯誤"
::msgcat::mcset $gPB(LANG) "MC(msg,dialog,title)"                   "後處理建構器訊息"
::msgcat::mcset $gPB(LANG) "MC(msg,warning)"                        "警告"
::msgcat::mcset $gPB(LANG) "MC(msg,error)"                          "錯誤"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_data)"                   "針對此參數鍵入的資料無效"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_browser_cmd)"            "無效的瀏覽器指令："
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_filename)"                 "檔名已變更！"
::msgcat::mcset $gPB(LANG) "MC(msg,user_ctrl_limit)"                "如果您不是作者，則不能使用經授權的\n後處理作為控制器來建立新的後處理！"
::msgcat::mcset $gPB(LANG) "MC(msg,import_limit)"                   "您不是此授權後處理的作者。\n不能匯入自訂指令！"
::msgcat::mcset $gPB(LANG) "MC(msg,limit_msg)"                      "您不是此授權後處理的作者。"
::msgcat::mcset $gPB(LANG) "MC(msg,no_file)"                        "缺少此授權後處理的加密檔案！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license)"                     "您沒有可執行此功能的合適授權！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license_title)"               "NX/後處理建構器無授權使用"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license_dialog)"              "允許您在沒有合適授權的\n情況下使用 NX/後處理建構器。\n但您不能儲存後續工作。"
::msgcat::mcset $gPB(LANG) "MC(msg,pending)"                        "將在以後的發行版中實現此選項的使用。"
::msgcat::mcset $gPB(LANG) "MC(msg,save)"                           "要在關閉進行中的後處理之前\n儲存變更嗎？"
::msgcat::mcset $gPB(LANG) "MC(msg,version_check)"                  "在該版本中不能開啟用較新版本後處理建構器建立的後處理。"

::msgcat::mcset $gPB(LANG) "MC(msg,file_corruption)"                "後處理建構器階段作業檔案中的內容不正確。"
::msgcat::mcset $gPB(LANG) "MC(msg,bad_tcl_file)"                   "後處理 Tcl 檔案中的內容不正確。"
::msgcat::mcset $gPB(LANG) "MC(msg,bad_def_file)"                   "後處理定義檔案中的內容不正確。"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_post)"                   "必須為您的後處理指定至少一組 Tcl 和定義檔案。"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_dir)"                    "目錄不存在。"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_file)"                   "檔案未找到或無效。"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_def_file)"               "不能開啟定義檔案"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_tcl_file)"               "不能開啟事件處理常式檔案"
::msgcat::mcset $gPB(LANG) "MC(msg,dir_perm)"                       "您不具備此目錄的寫許可權："
::msgcat::mcset $gPB(LANG) "MC(msg,file_perm)"                      "您無權寫入到"

::msgcat::mcset $gPB(LANG) "MC(msg,file_exist)"                     "已經存在！\n要取代它們嗎？"
::msgcat::mcset $gPB(LANG) "MC(msg,file_missing)"                   "缺少此後處理的部分或全部檔案。\n您不能開啟此後處理。"
::msgcat::mcset $gPB(LANG) "MC(msg,sub_dialog_open)"                "儲存後處理之前，必須完成對所有參數子對話方塊的編輯！"
::msgcat::mcset $gPB(LANG) "MC(msg,generic)"                        "目前僅對常規銑床實現了後處理建構器。"
::msgcat::mcset $gPB(LANG) "MC(msg,min_word)"                       "一個塊應至少包含一個文字。"
::msgcat::mcset $gPB(LANG) "MC(msg,name_exists)"                    "已經存在！\n請指定其他名稱。"
::msgcat::mcset $gPB(LANG) "MC(msg,in_use)"                         "此元件正在使用中。\n無法將其刪除。"
::msgcat::mcset $gPB(LANG) "MC(msg,do_you_want_to_proceed)"         "您可以將它們認為是現有資料單元格，然後繼續。"
::msgcat::mcset $gPB(LANG) "MC(msg,not_installed_properly)"         "未正確安裝。"
::msgcat::mcset $gPB(LANG) "MC(msg,no_app_to_open)"                 "沒有要開啟的應用模組"
::msgcat::mcset $gPB(LANG) "MC(msg,save_change)"                    "要儲存變更嗎？"

::msgcat::mcset $gPB(LANG) "MC(msg,external_editor)"                "外部編輯器"

# - Do not translate EDITOR
::msgcat::mcset $gPB(LANG) "MC(msg,set_ext_editor)"                 "您可以使用環境變數 EDITOR 以啟動您所需的文字編輯器。"
::msgcat::mcset $gPB(LANG) "MC(msg,filename_with_space)"            "不支援包含空格的檔名！"
::msgcat::mcset $gPB(LANG) "MC(msg,filename_protection)"            "不能覆寫由某個編輯後處理所使用的選定檔案！"


##--------------------
## Common Function
##
::msgcat::mcset $gPB(LANG) "MC(msg,parent_win)"                     "瞬態視窗要求已定義其父視窗。"
::msgcat::mcset $gPB(LANG) "MC(msg,close_subwin)"                   "您必須關閉所有子視窗才能啟用該標籤。"
::msgcat::mcset $gPB(LANG) "MC(msg,block_exist)"                    "選定的文字單元在塊範本中已經存在。"
::msgcat::mcset $gPB(LANG) "MC(msg,num_gcode_1)"                    "G 程式碼數量限制為"
::msgcat::mcset $gPB(LANG) "MC(msg,num_gcode_2)"                    "/塊"
::msgcat::mcset $gPB(LANG) "MC(msg,num_mcode_1)"                    "M 程式碼數量限制為"
::msgcat::mcset $gPB(LANG) "MC(msg,num_mcode_2)"                    "/塊"
::msgcat::mcset $gPB(LANG) "MC(msg,empty_entry)"                    "條目不應為空。"

::msgcat::mcset $gPB(LANG) "MC(msg,edit_feed_fmt)"                  "地址 \"F\" 的格式可以在「進給率」參數頁面上編輯"

::msgcat::mcset $gPB(LANG) "MC(msg,seq_num_max)"                    "序號的最大值不能超過地址 N 的容量："

::msgcat::mcset $gPB(LANG) "MC(msg,no_cdl_name)"                    "應指定後處理名稱！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_def_name)"                    "應指定資料夾！\n樣式應類似於 \"\$UGII_*\"！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_own_name)"                    "應指定資料夾！\n樣式應類似於 \"\$UGII_*\"！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_oth_ude_name)"                "應指定其他 cdl 檔名！\n樣式應類似於 \"\$UGII_*\"！"
::msgcat::mcset $gPB(LANG) "MC(msg,not_oth_cdl_file)"               "只允許 CDL 檔案！"
::msgcat::mcset $gPB(LANG) "MC(msg,not_pui_file)"                   "只允許 PUI 檔案！"
::msgcat::mcset $gPB(LANG) "MC(msg,not_cdl_file)"                   "只允許 CDL 檔案！"
::msgcat::mcset $gPB(LANG) "MC(msg,not_def_file)"                   "只允許 DEF 檔案！"
::msgcat::mcset $gPB(LANG) "MC(msg,not_own_cdl_file)"               "只允許自身 CDL 檔案！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_cdl_file)"                    "選定的後處理不具備關聯的 CDL 檔案。"
::msgcat::mcset $gPB(LANG) "MC(msg,cdl_info)"                       "選定後處理的 CDL 和定義檔案將在該後處理的定義檔案中被參考（包含）。\n選定後處理的 Tcl 檔案還將在執行階段被事件處理常式檔案參照。"

::msgcat::mcset $gPB(LANG) "MC(msg,add_max1)"                       "地址的最大值"
::msgcat::mcset $gPB(LANG) "MC(msg,add_max2)"                       "不能超過其格式的容量："


::msgcat::mcset $gPB(LANG) "MC(com,text_entry_trans,title,Label)"   "條目"

##---------------------------
## Common Navigation Buttons
##
::msgcat::mcset $gPB(LANG) "MC(nav_button,no_license,Message)"      "您沒有可執行此功能的合適授權！"

::msgcat::mcset $gPB(LANG) "MC(nav_button,ok,Label)"                "確定"
::msgcat::mcset $gPB(LANG) "MC(nav_button,ok,Context)"              "此按鈕僅在子對話方塊上可用。它允許您儲存變更並取消此對話方塊。"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cancel,Label)"            "取消"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cancel,Context)"          "此按鈕在子對話方塊上可用。它允許您取消此對話方塊。"
::msgcat::mcset $gPB(LANG) "MC(nav_button,default,Label)"           "預設"
::msgcat::mcset $gPB(LANG) "MC(nav_button,default,Context)"         "此按鈕允許您將某元件目前對話方塊上的參數還原到首次建立或開啟階段作業中的後處理時的狀態。\n\n但如果存在有問題的元件，則其名稱只能還原為此元件目前訪問時的初始狀態。"
::msgcat::mcset $gPB(LANG) "MC(nav_button,restore,Label)"           "還原"
::msgcat::mcset $gPB(LANG) "MC(nav_button,restore,Context)"         "此按鈕允許您將目前對話方塊上的參數還原到您目前訪問此元件時的初始設定。"
::msgcat::mcset $gPB(LANG) "MC(nav_button,apply,Label)"             "套用"
::msgcat::mcset $gPB(LANG) "MC(nav_button,apply,Context)"           "此按鈕允許您儲存變更而不取消目前對話方塊。此動作還會重新建立目前對話方塊的初始狀態。\n\n（如果需要初始狀態，請參照「還原」）"
::msgcat::mcset $gPB(LANG) "MC(nav_button,filter,Label)"            "篩選"
::msgcat::mcset $gPB(LANG) "MC(nav_button,filter,Context)"          "此按鈕將套用目錄篩選器並列出滿足條件的檔案。"
::msgcat::mcset $gPB(LANG) "MC(nav_button,yes,Label)"               "是"
::msgcat::mcset $gPB(LANG) "MC(nav_button,yes,Context)"             "是"
::msgcat::mcset $gPB(LANG) "MC(nav_button,no,Label)"                "否"
::msgcat::mcset $gPB(LANG) "MC(nav_button,no,Context)"              "否"
::msgcat::mcset $gPB(LANG) "MC(nav_button,help,Label)"              "說明"
::msgcat::mcset $gPB(LANG) "MC(nav_button,help,Context)"            "說明"

::msgcat::mcset $gPB(LANG) "MC(nav_button,open,Label)"              "開啟"
::msgcat::mcset $gPB(LANG) "MC(nav_button,open,Context)"            "此按鈕允許您開啟選定的後處理以編輯。"

::msgcat::mcset $gPB(LANG) "MC(nav_button,save,Label)"              "儲存"
::msgcat::mcset $gPB(LANG) "MC(nav_button,save,Context)"            "此按鈕在「另存新檔」對話方塊上可用，它允許您儲存進行中的後處理。"

::msgcat::mcset $gPB(LANG) "MC(nav_button,manage,Label)"            "管理..."
::msgcat::mcset $gPB(LANG) "MC(nav_button,manage,Context)"          "此按鈕允許您管理最近訪問的後處理歷程記錄。"

::msgcat::mcset $gPB(LANG) "MC(nav_button,refresh,Label)"           "重新整理"
::msgcat::mcset $gPB(LANG) "MC(nav_button,refresh,Context)"         "此按鈕將根據物件的存在情況重新整理清單。"

::msgcat::mcset $gPB(LANG) "MC(nav_button,cut,Label)"               "剪下"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cut,Context)"             "此按鈕將從清單中剪下選定的物件。"

::msgcat::mcset $gPB(LANG) "MC(nav_button,copy,Label)"              "複製"
::msgcat::mcset $gPB(LANG) "MC(nav_button,copy,Context)"            "此按鈕將複製選定的物件。"

::msgcat::mcset $gPB(LANG) "MC(nav_button,paste,Label)"             "貼上"
::msgcat::mcset $gPB(LANG) "MC(nav_button,paste,Context)"           "此按鈕將緩衝區的物件貼上回清單。"

::msgcat::mcset $gPB(LANG) "MC(nav_button,edit,Label)"              "編輯"
::msgcat::mcset $gPB(LANG) "MC(nav_button,edit,Context)"            "此按鈕將編輯緩衝區的物件！"

::msgcat::mcset $gPB(LANG) "MC(nav_button,ex_editor,Label)"         "使用外部編輯器"

##------------
## New dialog
##
::msgcat::mcset $gPB(LANG) "MC(new,title,Label)"                    "新建後處理器"
::msgcat::mcset $gPB(LANG) "MC(new,Status)"                         "輸入名稱並選取「新建後處理」的參數。"

::msgcat::mcset $gPB(LANG) "MC(new,name,Label)"                     "後處理名稱"
::msgcat::mcset $gPB(LANG) "MC(new,name,Context)"                   "要建立的後處理器的名稱"

::msgcat::mcset $gPB(LANG) "MC(new,desc,Label)"                     "敘述"
::msgcat::mcset $gPB(LANG) "MC(new,desc,Context)"                   "要建立的後處理器的敘述"

#Description for each selection
::msgcat::mcset $gPB(LANG) "MC(new,mill,desc,Label)"                "這是銑床。"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,desc,Label)"               "這是車床。"
::msgcat::mcset $gPB(LANG) "MC(new,wedm,desc,Label)"                "這是線切割機床。"

::msgcat::mcset $gPB(LANG) "MC(new,wedm_2,desc,Label)"              "這是 2 軸線切割機床。"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_4,desc,Label)"              "這是 4 軸線切割機床。"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_2,desc,Label)"             "這是 2 軸水平車床。"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_4,desc,Label)"             "這是 4 軸關聯車床。"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3,desc,Label)"              "這是 3 軸銑床。"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3MT,desc,Label)"            "3 軸車銑 (XZC)"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4H,desc,Label)"             "這是帶轉頭的 4 軸\n銑床。"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4T,desc,Label)"             "這是帶轉檯的 4 軸\n銑床。"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5TT,desc,Label)"            "這是帶雙轉檯的 5 軸\n銑床。"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HH,desc,Label)"            "這是帶雙轉頭的 5 軸\n銑床。"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HT,desc,Label)"            "這是帶轉頭和轉檯的 5 軸\n銑床。"
::msgcat::mcset $gPB(LANG) "MC(new,punch,desc,Label)"               "這是沖壓機床。"

::msgcat::mcset $gPB(LANG) "MC(new,post_unit,Label)"                "後處理輸出單位"

::msgcat::mcset $gPB(LANG) "MC(new,inch,Label)"                     "英寸"
::msgcat::mcset $gPB(LANG) "MC(new,inch,Context)"                   "後處理器輸出單位英寸"
::msgcat::mcset $gPB(LANG) "MC(new,millimeter,Label)"               "公釐"
::msgcat::mcset $gPB(LANG) "MC(new,millimeter,Context)"             "後處理器輸出單位公釐"

::msgcat::mcset $gPB(LANG) "MC(new,machine,Label)"                  "機床"
::msgcat::mcset $gPB(LANG) "MC(new,machine,Context)"                "要為其建立後處理器的機床類型。"

::msgcat::mcset $gPB(LANG) "MC(new,mill,Label)"                     "銑"
::msgcat::mcset $gPB(LANG) "MC(new,mill,Context)"                   "銑床"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,Label)"                    "車"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,Context)"                  "車床"
::msgcat::mcset $gPB(LANG) "MC(new,wire,Label)"                     "線切割"
::msgcat::mcset $gPB(LANG) "MC(new,wire,Context)"                   "線切割機床"
::msgcat::mcset $gPB(LANG) "MC(new,punch,Label)"                    "沖壓"

::msgcat::mcset $gPB(LANG) "MC(new,axis,Label)"                     "機床軸選取"
::msgcat::mcset $gPB(LANG) "MC(new,axis,Context)"                   "機床軸的數量和類型"

#Axis Number
::msgcat::mcset $gPB(LANG) "MC(new,axis_2,Label)"                   "2 軸"
::msgcat::mcset $gPB(LANG) "MC(new,axis_3,Label)"                   "3 軸"
::msgcat::mcset $gPB(LANG) "MC(new,axis_4,Label)"                   "4 軸"
::msgcat::mcset $gPB(LANG) "MC(new,axis_5,Label)"                   "5 軸"
::msgcat::mcset $gPB(LANG) "MC(new,axis_XZC,Label)"                 "XZC"


#Axis Type
::msgcat::mcset $gPB(LANG) "MC(new,mach_axis,Label)"                "機床軸"
::msgcat::mcset $gPB(LANG) "MC(new,mach_axis,Context)"              "選取機床軸"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_2,Label)"                  "2 軸"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3,Label)"                   "3 軸"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3MT,Label)"                 "3 軸車銑 (XZC)"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4T,Label)"                  "4 軸帶轉檯"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4H,Label)"                  "4 軸帶轉頭"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_4,Label)"                  "4 軸"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HH,Label)"                 "5 軸帶雙轉頭"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5TT,Label)"                 "5 軸帶雙轉檯"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HT,Label)"                 "5 軸帶轉頭和轉檯"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_2,Label)"                   "2 軸"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_4,Label)"                   "4 軸"
::msgcat::mcset $gPB(LANG) "MC(new,punch,Label)"                    "沖壓"

::msgcat::mcset $gPB(LANG) "MC(new,control,Label)"                  "控制器"
::msgcat::mcset $gPB(LANG) "MC(new,control,Context)"                "選取後處理控制器。"

#Controller Type
::msgcat::mcset $gPB(LANG) "MC(new,generic,Label)"                  "一般"
::msgcat::mcset $gPB(LANG) "MC(new,library,Label)"                  "庫"
::msgcat::mcset $gPB(LANG) "MC(new,user,Label)"                     "使用者"
::msgcat::mcset $gPB(LANG) "MC(new,user,browse,Label)"              "瀏覽"

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
::msgcat::mcset $gPB(LANG) "MC(open,title,Label)"                   "編輯後處理"
::msgcat::mcset $gPB(LANG) "MC(open,Status)"                        "選取要開啟的 PUI 檔案。"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_pui)"                 "後處理建構器階段作業檔案"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_tcl)"                 "Tcl 指令碼檔案"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_def)"                 "定義檔案"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_cdl)"                 "CDL 檔案"

##-------------
## Misc dialog
##
::msgcat::mcset $gPB(LANG) "MC(open_save,dlg,title,Label)"          "選取檔案"
::msgcat::mcset $gPB(LANG) "MC(exp_cc,dlg,title,Label)"             "匯出自訂指令"
::msgcat::mcset $gPB(LANG) "MC(show_mt,title,Label)"                "機床"

##----------------
## Utils dialog
##
::msgcat::mcset $gPB(LANG) "MC(mvb,title,Label)"                    "MOM 變數瀏覽器"
::msgcat::mcset $gPB(LANG) "MC(mvb,cat,Label)"                      "類別"
::msgcat::mcset $gPB(LANG) "MC(mvb,search,Label)"                   "搜尋"
::msgcat::mcset $gPB(LANG) "MC(mvb,defv,Label)"                     "預設值"
::msgcat::mcset $gPB(LANG) "MC(mvb,posv,Label)"                     "可行值"
::msgcat::mcset $gPB(LANG) "MC(mvb,data,Label)"                     "資料類型"
::msgcat::mcset $gPB(LANG) "MC(mvb,desc,Label)"                     "敘述"

::msgcat::mcset $gPB(LANG) "MC(inposts,title,Label)"                "編輯 template_post.dat"
::msgcat::mcset $gPB(LANG) "MC(tpdf,text,Label)"                    "範本後處理資料檔案"
::msgcat::mcset $gPB(LANG) "MC(inposts,edit,title,Label)"           "編輯列"
::msgcat::mcset $gPB(LANG) "MC(inposts,edit,post,Label)"            "後處理"


##----------------
## Save As dialog
##
::msgcat::mcset $gPB(LANG) "MC(save_as,title,Label)"                "另存新檔"
::msgcat::mcset $gPB(LANG) "MC(save_as,name,Label)"                 "後處理名稱"
::msgcat::mcset $gPB(LANG) "MC(save_as,name,Context)"               "後處理器要另存新檔的名稱。"
::msgcat::mcset $gPB(LANG) "MC(save_as,Status)"                     "輸入新的後處理檔名。"
::msgcat::mcset $gPB(LANG) "MC(save_as,file_type_pui)"              "後處理建構器階段作業檔案"

##----------------
## Common Widgets
##
::msgcat::mcset $gPB(LANG) "MC(common,entry,Label)"                 "條目"
::msgcat::mcset $gPB(LANG) "MC(common,entry,Context)"               "您將在條目欄位指定新值。"

##-----------
## Note Book
##
::msgcat::mcset $gPB(LANG) "MC(nbook,tab,Label)"                    "筆記本標籤"
::msgcat::mcset $gPB(LANG) "MC(nbook,tab,Context)"                  "您可以選取一個標籤以轉至您需要的參數頁面。\n\n一個標籤下面的參數可能會分為幾組。可以通過另一標籤存取各組參數。"

##------
## Tree
##
::msgcat::mcset $gPB(LANG) "MC(tree,select,Label)"                  "元件樹"
::msgcat::mcset $gPB(LANG) "MC(tree,select,Context)"                "您可以選取一個元件以檢視或編輯其內容或參數。"
::msgcat::mcset $gPB(LANG) "MC(tree,create,Label)"                  "建立"
::msgcat::mcset $gPB(LANG) "MC(tree,create,Context)"                "通過複製選定的項來建立新元件。"
::msgcat::mcset $gPB(LANG) "MC(tree,cut,Label)"                     "剪下"
::msgcat::mcset $gPB(LANG) "MC(tree,cut,Context)"                   "剪下元件。"
::msgcat::mcset $gPB(LANG) "MC(tree,paste,Label)"                   "貼上"
::msgcat::mcset $gPB(LANG) "MC(tree,paste,Context)"                 "貼上元件。"
::msgcat::mcset $gPB(LANG) "MC(tree,rename,Label)"                  "重新命名"

##------------------
## Encrypt dialogs
##
::msgcat::mcset $gPB(LANG) "MC(encrypt,browser,Label)"              "授權清單"
::msgcat::mcset $gPB(LANG) "MC(encrypt,title,Label)"                "選取授權"
::msgcat::mcset $gPB(LANG) "MC(encrypt,output,Label)"               "加密輸出"
::msgcat::mcset $gPB(LANG) "MC(encrypt,license,Label)"              "授權：  "

#++++++++++++++
# Machine Tool
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(machine,tab,Label)"                  "機床"
::msgcat::mcset $gPB(LANG) "MC(machine,Status)"                     "指定機床運動學參數。"

::msgcat::mcset $gPB(LANG) "MC(msg,no_display)"                     "此機床組態的影像不可用。"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_ctable)"                  "第 4 軸 C 加工台不受允許。"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_max_min)"                 "第 4 軸最大軸限制不能等於最小軸限制！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_both_neg)"                "第 4 軸限制不能都為負！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_5th_plane)"               "第 4 軸的平面不能與第 5 軸的相同。"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4thT_5thH)"                   "第 4 軸加工台和第 5 軸機頭不受允許。"
::msgcat::mcset $gPB(LANG) "MC(msg,no_5th_max_min)"                 "第 5 軸最大軸限制不能等於最小軸限制！"
::msgcat::mcset $gPB(LANG) "MC(msg,no_5th_both_neg)"                "第 5 軸限制不能都為負！"

##---------
# Post Info
##
::msgcat::mcset $gPB(LANG) "MC(machine,info,title,Label)"           "後處理資訊"
::msgcat::mcset $gPB(LANG) "MC(machine,info,desc,Label)"            "敘述"
::msgcat::mcset $gPB(LANG) "MC(machine,info,type,Label)"            "機床類型"
::msgcat::mcset $gPB(LANG) "MC(machine,info,kinematics,Label)"      "運動學"
::msgcat::mcset $gPB(LANG) "MC(machine,info,unit,Label)"            "輸出單位"
::msgcat::mcset $gPB(LANG) "MC(machine,info,controller,Label)"      "控制器"
::msgcat::mcset $gPB(LANG) "MC(machine,info,history,Label)"         "歷程記錄"

##---------
## Display
##
::msgcat::mcset $gPB(LANG) "MC(machine,display,Label)"              "顯示機床"
::msgcat::mcset $gPB(LANG) "MC(machine,display,Context)"            "此選項顯示機床"
::msgcat::mcset $gPB(LANG) "MC(machine,display_trans,title,Label)"  "機床"


##---------------
## General parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,gen,Label)"                      "一般參數"
    
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,Label)"             "後處理輸出單位："
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,Context)"           "後處理輸出單位"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,inch,Label)"        "英制" 
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,metric,Label)"      "公制"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,Label)"         "線性軸行程限制"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,Context)"       "線性軸行程限制"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,x,Label)"       "X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,x,Context)"     "指定機床沿 X 軸的行程限制。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,y,Label)"       "Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,y,Context)"     "指定機床沿 Y 軸的行程限制。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,z,Label)"       "Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,z,Context)"     "指定機床沿 Z 軸的行程限制。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,Label)"             "回零位置"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,Context)"           "回零位置"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,x,Label)"           "X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,x,Context)"         "機床相對於 X 軸物理零位置的 X 軸回零位置。機床返回此位置以自動換刀。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,y,Label)"           "Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,y,Context)"         "機床相對於 Y 軸物理零位置的 Y 軸回零位置。機床返回此位置以自動換刀。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,z,Label)"           "Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,z,Context)"         "機床相對於 Z 軸物理零位置的 Z 軸回零位置。機床返回此位置以自動換刀。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,Label)"            "線性運動精度"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,min,Label)"        "最小值"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,min,Context)"      "最小精度"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,Label)"        "移刀進給率"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,max,Label)"    "最大值"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,max,Context)"  "最大進給率"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,Label)"        "輸出迴圈記錄"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,yes,Label)"    "是"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,yes,Context)"  "輸出迴圈記錄。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,no,Label)"     "否"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,no,Context)"   "輸出線性記錄。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,config_4and5_axis,oth,Label)"    "其他"

# Wire EDM parameters
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,wire_tilt)"             "線側傾控制"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,angle)"                 "角度"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,coord)"                 "座標"

# Lathe parameters
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,Label)"               "轉塔"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,Context)"             "轉塔"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf,Label)"          "配置"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf,Context)"        "選取兩個轉塔時，此選項允許您配置參數。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,one,Label)"           "單轉塔"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,one,Context)"         "單轉塔車床"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,two,Label)"           "雙轉塔"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,two,Context)"         "雙轉塔車床"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf_trans,Label)"    "轉塔組態"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,prim,Label)"          "主轉塔"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,prim,Context)"        "選取主轉塔的名稱。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,sec,Label)"           "輔助轉塔"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,sec,Context)"         "選取輔助轉塔的名稱。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,designation,Label)"   "名稱"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,xoff,Label)"          "X 偏置"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,xoff,Context)"        "指定 X 偏置。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,zoff,Label)"          "Z 向偏置"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,zoff,Context)"        "指定 Z 向偏置。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,front,Label)"         "前"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,rear,Label)"          "後"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,right,Label)"         "右"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,left,Label)"          "左"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,side,Label)"          "側"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,saddle,Label)"        "鞍型"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,Label)"           "軸乘數"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,dia,Label)"       "直徑程式設計"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,dia,Context)"     "這些選項允許您通過翻倍 N/C 輸出中選定地址的值，啟用直徑程式設計。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2x,Label)"        "2X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2x,Context)"      "此開關允許您通過翻倍 N/C 輸出中的 X 軸座標，啟用直徑程式設計。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2y,Label)"        "2Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2y,Context)"      "此開關允許您通過翻倍 N/C 輸出中的 Y 軸座標，啟用直徑程式設計。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2i,Label)"        "2I"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2i,Context)"      "此開關允許您在使用直徑程式設計時將迴圈記錄的 I 值翻倍。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2j,Label)"        "2J"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2j,Context)"      "此開關允許您在使用直徑程式設計時將迴圈記錄的 J 值翻倍。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,mir,Label)"       "鏡射輸出"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,mir,Context)"     "這些選項允許您通過使其在 N/C 輸出中的值為負，鏡射選定的地址。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,x,Label)"         "-X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,x,Context)"       "此開關允許您使 N/C 輸出中的 X 軸座標為負。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,y,Label)"         "-Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,y,Context)"       "此開關允許您使 N/C 輸出中的 Y 軸座標為負。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,z,Label)"         "-Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,z,Context)"       "此開關允許您使 N/C 輸出中的 Z 軸座標為負。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,i,Label)"         "-I"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,i,Context)"       "此開關允許您使 N/C 輸出中的迴圈記錄 I 值為負。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,j,Label)"         "-J"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,j,Context)"       "此開關允許您使 N/C 輸出中的迴圈記錄 J 值為負。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,k,Label)"         "-K"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,k,Context)"       "此開關允許您使 N/C 輸出中的迴圈記錄 K 值為負。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,Label)"               "輸出方法"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,Context)"             "輸出方法"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,tool_tip,Label)"      "刀尖"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,tool_tip,Context)"    "相對於刀尖的輸出"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,turret_ref,Label)"    "轉塔參照"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,turret_ref,Context)"  "相對於轉塔參照的輸出"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_turret,msg)"           "主轉塔的名稱不能與輔助轉塔的相同。"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret_chg,msg)"             "變更此選項可能需要在換刀事件中新增或刪除一個 G92 塊。"
# Entries for XZC/Mill-Turn
::msgcat::mcset $gPB(LANG) "MC(machine,gen,spindle_axis,Label)"             "初始主軸"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,spindle_axis,Context)"           "即時銑刀的初始主軸可以指定為平行於或垂直於 Z 軸。工序的刀軸必須與指定的主軸一致。如果後處理不能定位到指定的主軸，則會出錯。\n此向量可能會被機頭物件指定的主軸取代。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,position_in_yaxis,Label)"        "Y 軸中的位置"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,position_in_yaxis,Context)"      "機床具備一個可程式設計的 Y 軸，它可以在輪廓加工時定位。此選項僅在主軸不是沿 Z 軸時適用。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,Label)"                "機床模式"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,Context)"              "機床模式可以是 XZC 銑或簡單車銑。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,xzc_mill,Label)"       "XZC 銑"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,xzc_mill,Context)"     "XZC 銑將有一個加工台或卡盤面鎖定在車銑機床上，作為旋轉 C 軸。所有 XY 移動都轉換至 X 和 C，其中 X 為半徑值，C 為角度。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,mill_turn,Label)"      "簡單車銑"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,mill_turn,Context)"    "此 XZC 銑後處理將與車後處理相連結，以處理包含銑削和車削工序的程式。工序類型將決定使用哪個後處理生成 N/C 輸出。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mill_turn,lathe_post,Label)"     "車後處理"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mill_turn,lathe_post,Context)"   "簡單車銑後處理需要車後處理以對程式中的車削工序進行後處理。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_post,select_name,Label)"   "選取名稱"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_post,select_name,Context)" "選取要用於簡單車銑後處理的車後處理的名稱。此後處理很可能在 NX/後處理執行時的 \\\$UGII_CAM_POST_DIR 目錄中，否則將使用在銑後處理所在目錄中同名的後處理。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,Label)"               "預設座標模式"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,Context)"             "此選項將座標輸出模式的初始設定定義為極座標 (XZC) 或笛卡爾座標 (XYZ)。此模式可以通過由工序程式設計的 \\\"SET/POLAR，ON\\\" UDE 進行變更。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,polar,Label)"         "極座標"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,polar,Context)"       "XZC 格式的座標輸出。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,cart,Label)"          "笛卡爾座標"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,cart,Context)"        "XYZ 格式的座標輸出。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,Label)"             "迴圈記錄模式"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,Context)"           "此選項定義將採用極座標 (XCR) 或笛卡爾座標 (XYIJ) 模式。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,polar,Label)"       "極座標"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,polar,Context)"     "XCR 格式的圓形輸出。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,cart,Label)"        "笛卡爾座標"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,cart,Context)"      "XYIJ 格式的圓形輸出。"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,def_spindle_axis,Label)"         "初始主軸"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,def_spindle_axis,Context)"       "初始主軸可能會被機頭物件指定的主軸取代。\n此向量無需合成。"


##-----------------
## 4-th Axis parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,fourth,Label)"              "第四軸"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,radius_output,Label)"       "半徑輸出"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,radius_output,Context)"     "刀軸沿 Z 軸 (0,0,1) 時，後處理可以選取以下選項來輸出極座標的半徑 (X)：\\\"始終為正\\\"、\\\"始終為負\\\"或\\\"最短距離\\\"。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,type_head,Label)"           "機頭"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,type_table,Label)"          "轉檯"

##-----------------
## 5-th Axis parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,fifth,Label)"               "第五軸"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary,Label)"              "旋轉軸"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,Label)"              "機床零點到旋轉軸中心"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,4,Label)"            "機床零點到第 4 軸中心"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,5,Label)"            "第 4 軸中心到第 5 軸中心"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,x,Label)"            "X 偏置"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,x,Context)"          "指定旋轉軸 X 偏置。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,y,Label)"            "Y 向偏置"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,y,Context)"          "指定旋轉軸 Y 向偏置。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,z,Label)"            "Z 向偏置"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,z,Context)"          "指定旋轉軸 Z 向偏置。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,Label)"            "軸旋轉"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,norm,Label)"       "法向"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,norm,Context)"     "設定軸旋轉方向為「法向」。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,rev,Label)"        "反向"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,rev,Context)"      "設定軸旋轉方向為「反向」。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,direction,Label)"           "軸方向"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,direction,Context)"         "選取軸方向。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,Label)"              "連續旋轉運動"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,combine,Label)"      "組合"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,combine,Context)"    "此開關允許您啟用/停用線性化。它將啟用/停用公差選項。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,tol,Label)"      "公差"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,tol,Context)"    "此選項僅在「組合」開關使用中時才處於使用中狀態。請指定公差。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,Label)"           "軸限制違例處理"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,warn,Label)"      "警告"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,warn,Context)"    "軸限制違例時輸出警告。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,ret,Label)"       "退刀/重新進刀"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,ret,Context)"     "軸限制違例時退刀/重新進刀。\n\n在自訂指令 PB_CMD_init_rotaty 中，可以調節以下參數以實現所需的運動：\n\n   mom_kin_retract_type\n   mom_kin_retract_distance\n   mom_kin_reengage_distance"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,Label)"              "軸限制（度）"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,min,Label)"          "最小值"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,min,Context)"        "指定最小旋轉軸限制（度）。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,max,Label)"          "最大值"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,max,Context)"        "指定最大旋轉軸限制（度）。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,incr_text)"                 "旋轉軸可以是遞增的"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_res,Label)"          "旋轉運動精度（度）"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_res,Context)"        "指定旋轉運動精度（度）。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,ang_offset,Label)"          "角度偏置（度）"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,ang_offset,Context)"        "指定軸角度偏置（度）。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,pivot,Label)"               "樞軸距離"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,pivot,Context)"             "指定樞軸距離。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,max_feed,Label)"            "最大進給率（度/分）"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,max_feed,Context)"          "指定最大進給率（度/分）。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,Label)"               "旋轉平面"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,Context)"             "選取 XY、YZ、ZX 或「其他」作為旋轉平面。\\\"其他\\\"選項允許您指定任意向量。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,normal,Label)"        "平面法矢"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,normal,Context)"      "指定平面法矢作為旋轉軸。\n此向量無需合成。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,4th,Label)"           "第 4 軸平面法矢"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,4th,Context)"         "指定第 4 軸旋轉的平面法矢。"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,5th,Label)"           "第 5 軸平面法矢"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,5th,Context)"         "指定第 5 軸旋轉的平面法矢。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,leader,Label)"              "文字引導符"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,leader,Context)"            "指定文字引導符。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,config,Label)"              "配置"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,config,Context)"            "此選項允許您定義第 4 和第 5 軸參數。"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,r_axis_conf_trans,Label)"   "旋轉軸組態"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,4th_axis,Label)"            "第 4 軸"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,5th_axis,Label)"            "第 5 軸"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,head,Label)"                " 機頭 "
::msgcat::mcset $gPB(LANG) "MC(machine,axis,table,Label)"               " 轉檯 "

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_lintol,Label)"       "預設線性化公差"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_lintol,Context)"     "用目前或之前的工序指定 LINTOL/ON 後處理指令時，此數值將作為預設公差以線性化旋轉運動。LINTOL/指令還可以指定其他線性化公差。"

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(progtpth,tab,Label)"                 "程式和刀軌"

##---------
## Program
##
::msgcat::mcset $gPB(LANG) "MC(prog,tab,Label)"                     "程式"
::msgcat::mcset $gPB(LANG) "MC(prog,Status)"                        "定義事件的輸出"

::msgcat::mcset $gPB(LANG) "MC(prog,tree,Label)"                    "程式 -- 序列樹"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,Context)"                  "N/C 程式被分為五個部分：四 (4) 個序列和刀軌本體：\n\n * 程式起始序列\n * 工序起始序列\n * 刀軌\n * 工序結束序列\n * 程式結束序列\n\n每個序列包含一係列的標記。每個標記代表可以程式設計且可能在 N/C 程式某個特定階段發生的事件。您可以向每個標記附加特定順序的 N/C 程式碼，以在後處理該程式時輸出。\n\n刀軌由大量事件組成，分為三 (3) 群組：\n\n * 機床控制\n * 運動\n * 迴圈\n"

::msgcat::mcset $gPB(LANG) "MC(prog,tree,prog_strt,Label)"          "程式起始序列"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,prog_end,Label)"           "程式結束序列"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,oper_strt,Label)"          "工序起始序列"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,oper_end,Label)"           "工序結束序列"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,Label)"          "刀徑"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,mach_cnt,Label)" "機床控制"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,motion,Label)"   "運動"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,cycle,Label)"    "現成迴圈"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,linked_posts,Label)"       "連結的後處理序列"

::msgcat::mcset $gPB(LANG) "MC(prog,add,Label)"                     "序列 -- 新增塊"
::msgcat::mcset $gPB(LANG) "MC(prog,add,Context)"                   "通過按下此按鈕並將其拖曳到所需的標記，可以將新塊新增到序列。還可以將塊附加到現有塊的旁邊、上邊或下邊。"

::msgcat::mcset $gPB(LANG) "MC(prog,trash,Label)"                   "序列 -- 垃圾桶"
::msgcat::mcset $gPB(LANG) "MC(prog,trash,Context)"                 "通過將塊拖曳到垃圾桶，可以移除序列中不想要的塊。"

::msgcat::mcset $gPB(LANG) "MC(prog,block,Label)"                   "序列 -- 塊"
::msgcat::mcset $gPB(LANG) "MC(prog,block,Context)"                 "通過將塊拖曳到垃圾桶，可以刪除序列中不想要的塊。\n\n還可以按下滑鼠右鍵來啟動彈出式功能表。該功能表上有幾項服務可用：\n\n * 編輯\n * 強制輸出\n * 剪下\n * 複製為\n * 貼上\n * 刪除\n"

::msgcat::mcset $gPB(LANG) "MC(prog,select,Label)"                  "序列 -- 塊選取"
::msgcat::mcset $gPB(LANG) "MC(prog,select,Context)"                "可以從該清單中選取要新增到序列的塊元件的類型。\n\A可用元件類型包括：\n\n * 新塊\n * 現有 N/C 塊\n * 作業員訊息\n * 自訂指令\n"

::msgcat::mcset $gPB(LANG) "MC(prog,oper_temp,Label)"               "選取序列範本"
::msgcat::mcset $gPB(LANG) "MC(prog,add_block,Label)"               "新增塊"
::msgcat::mcset $gPB(LANG) "MC(prog,seq_comb_nc,Label)"             "顯示組合 N/C 程式碼塊"
::msgcat::mcset $gPB(LANG) "MC(prog,seq_comb_nc,Context)"           "此按鈕允許您根據塊或 N/C 程式碼顯示序列內容。\n\nN/C 程式碼會以適當的順序顯示文字。"

::msgcat::mcset $gPB(LANG) "MC(prog,plus,Label)"                    "程式 -- 收合/展開開關"
::msgcat::mcset $gPB(LANG) "MC(prog,plus,Context)"                  "此按鈕允許您收合或展開該元件的分支。"

::msgcat::mcset $gPB(LANG) "MC(prog,marker,Label)"                  "序列 -- 標記"
::msgcat::mcset $gPB(LANG) "MC(prog,marker,Context)"                "序列的標記代表可以程式設計且可能在 N/C 程式某個特定階段出現的可能事件。\n\n您可以附加/組裝安排要在每個標記中輸出的塊。"

::msgcat::mcset $gPB(LANG) "MC(prog,event,Label)"                   "程式 -- 事件"
::msgcat::mcset $gPB(LANG) "MC(prog,event,Context)"                 "您可以通過點擊滑鼠左鍵編輯每個事件。"

::msgcat::mcset $gPB(LANG) "MC(prog,nc_code,Label)"                 "程式 -- N/C 程式碼"
::msgcat::mcset $gPB(LANG) "MC(prog,nc_code,Context)"               "此框中的文字顯示將作為此標記或此事件輸出的代表性 N/C 程式碼。"
::msgcat::mcset $gPB(LANG) "MC(prog,undo_popup,Label)"              "復原"

## Sequence
##
::msgcat::mcset $gPB(LANG) "MC(seq,combo,new,Label)"                "新塊"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,comment,Label)"            "作業員訊息"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,custom,Label)"             "自訂指令"

::msgcat::mcset $gPB(LANG) "MC(seq,new_trans,title,Label)"          "塊"
::msgcat::mcset $gPB(LANG) "MC(seq,cus_trans,title,Label)"          "自訂指令"
::msgcat::mcset $gPB(LANG) "MC(seq,oper_trans,title,Label)"         "作業員訊息"

::msgcat::mcset $gPB(LANG) "MC(seq,edit_popup,Label)"               "編輯"
::msgcat::mcset $gPB(LANG) "MC(seq,force_popup,Label)"              "強制輸出"
::msgcat::mcset $gPB(LANG) "MC(seq,rename_popup,Label)"             "重新命名"
::msgcat::mcset $gPB(LANG) "MC(seq,rename_popup,Context)"           "您可以指定此元件的名稱。"
::msgcat::mcset $gPB(LANG) "MC(seq,cut_popup,Label)"                "剪下"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,Label)"               "複製為"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,ref,Label)"           "參考的塊"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,new,Label)"           "新塊"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,Label)"              "貼上"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,before,Label)"       "之前"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,inline,Label)"       "列內"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,after,Label)"        "之後"
::msgcat::mcset $gPB(LANG) "MC(seq,del_popup,Label)"                "刪除"

::msgcat::mcset $gPB(LANG) "MC(seq,force_trans,title,Label)"        "強制輸出一次"

##--------------
## Toolpath
##
::msgcat::mcset $gPB(LANG) "MC(tool,event_trans,title,Label)"       "事件"

::msgcat::mcset $gPB(LANG) "MC(tool,event_seq,button,Label)"        "選取事件範本"
::msgcat::mcset $gPB(LANG) "MC(tool,add_word,button,Label)"         "新增文字"

::msgcat::mcset $gPB(LANG) "MC(tool,format_trans,title,Label)"      "格式"

::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,title,Label)"        "圓周移動 -- 平面程式碼"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,frame,Label)"        " 平面 G 程式碼 "
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,xy,Label)"           "Xy 平面"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,yz,Label)"           "Yz 平面"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,zx,Label)"           "Zx 平面"

::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,arc_start,Label)"          "圓弧起點到中心"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,arc_center,Label)"         "圓弧中心到起點"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,u_arc_start,Label)"        "無符號的圓弧起點到中心"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,absolute,Label)"           "絕對圓弧中心"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,long_thread_lead,Label)"   "縱向螺紋線"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,tran_thread_lead,Label)"   "橫向螺紋線"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,type,Label)"              "主軸範圍類型"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,range_M,Label)"           "獨立範圍 M 程式碼 (M41)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,with_spindle_M,Label)"    "帶主軸 M 程式碼的範圍號 (M13)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,hi_lo_with_S,Label)"      "帶 S 程式碼的高/低範圍 (S+100)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,nonzero_range,msg)"       "主軸範圍號必須大於零。"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,title,Label)"         "主軸範圍程式碼表"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,range,Label)"         "範圍"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,code,Label)"          "程式碼"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,min,Label)"           "最小值 (RPM)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,max,Label)"           "最大值 (RPM)"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,sep,Label)"            " 獨立範圍 M 程式碼 (M41, M42...) "
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,range,Label)"          " 帶主軸 M 程式碼的範圍號 (M13, M23...)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,high,Label)"           " 帶 S 程式碼的高/低範圍 (S+100/S-100)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,odd,Label)"            " 帶 S 程式碼的奇數/偶數範圍"


::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt1,Label)"            "刀具號"
::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt2,Label)"            "刀具號和長度偏置號"
::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt3,Label)"            "長度偏置號和刀具號"

::msgcat::mcset $gPB(LANG) "MC(tool,config,title,Label)"                "刀具程式碼組態"
::msgcat::mcset $gPB(LANG) "MC(tool,config,output,Label)"               "輸出"

::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt1,Label)"           "刀具號"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt2,Label)"           "刀具號和長度偏置號"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt3,Label)"           "轉塔索引和刀具號"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt4,Label)"           "轉塔索引刀具號和長度偏置號"

::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,num,Label)"               "刀具號"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,next_num,Label)"          "下一刀具號"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_num,Label)"         "轉塔索引和刀具號"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_next_num,Label)"    "轉塔索引和下一刀具號"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,num_len,Label)"           "刀具號和長度偏置號"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,next_num_len,Label)"      "下一刀具號和長度偏置號"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,len_num,Label)"           "長度偏置號和刀具號"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,len_next_num,Label)"      "長度偏置號和下一刀具號"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_num_len,Label)"     "轉塔索引、刀具號和長度偏置號"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_next_num_len,Label)"    "轉塔索引、下一刀具號和長度偏置號"

::msgcat::mcset $gPB(LANG) "MC(tool,oper_trans,title,Label)"            "作業員訊息"
::msgcat::mcset $gPB(LANG) "MC(tool,cus_trans,title,Label)"             "自訂指令"

##--------------------------
## Labels for Event dialogs
##
::msgcat::mcset $gPB(LANG) "MC(event,feed,IPM_mode)"                "IPM（英寸/分）模式"

##---------
## G Codes
##
::msgcat::mcset $gPB(LANG) "MC(gcode,tab,Label)"                    "G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(gcode,Status)"                       "指定 G 程式碼"

##---------
## M Codes
##
::msgcat::mcset $gPB(LANG) "MC(mcode,tab,Label)"                    "M 程式碼"
::msgcat::mcset $gPB(LANG) "MC(mcode,Status)"                       "指定 M 程式碼"

##-----------------
## Words Summary
##
::msgcat::mcset $gPB(LANG) "MC(addrsum,tab,Label)"                  "文字匯總"
::msgcat::mcset $gPB(LANG) "MC(addrsum,Status)"                     "指定參數"

::msgcat::mcset $gPB(LANG) "MC(addrsum,col_addr,Label)"             "文字"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_addr,Context)"           "您可以通過用滑鼠左鍵點擊名稱以編輯文字地址。"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_lead,Label)"             "引導符/程式碼"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_data,Label)"             "資料類型"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_plus,Label)"             "加號 (+)"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_lzero,Label)"            "前置字元為零"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_int,Label)"              "整數"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_dec,Label)"              "小數點 (.)"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_frac,Label)"             "分數"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_tzero,Label)"            "後置零"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_modal,Label)"            "模態？"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_min,Label)"              "最小值"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_max,Label)"              "最大值"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_trail,Label)"            "結束符"

::msgcat::mcset $gPB(LANG) "MC(addrsum,radio_text,Label)"           "文字"
::msgcat::mcset $gPB(LANG) "MC(addrsum,radio_num,Label)"            "數字"

::msgcat::mcset $gPB(LANG) "MC(addrsum,addr_trans,title,Label)"     "文字"
::msgcat::mcset $gPB(LANG) "MC(addrsum,other_trans,title,Label)"    "其他資料單元"

##-----------------
## Word Sequencing
##
::msgcat::mcset $gPB(LANG) "MC(wseq,tab,Label)"                     "文字排序"
::msgcat::mcset $gPB(LANG) "MC(wseq,Status)"                        "對文字排序"

::msgcat::mcset $gPB(LANG) "MC(wseq,word,Label)"                    "主文字序列"
::msgcat::mcset $gPB(LANG) "MC(wseq,word,Context)"                  "您可以通過將文字拖到所需位置，對 N/C 輸出中出現的文字進行排序。\n\n當拖曳的文字與另一文字焦點對準（矩形顏色變更）時，兩個文字將互換位置。如果將某個文字拖曳到兩個文字間的分隔符號焦點內，則該文字會被插入這兩個文字之間。\n\n可以通過點擊滑鼠左鍵將文字關閉，以抑制其輸出到 N/C 檔案。\n\n還可以使用彈出式功能表中的選項對這些文字進行以下動作：\n\n * 新建\n * 編輯\n * 刪除\n * 全部啟動\n"

::msgcat::mcset $gPB(LANG) "MC(wseq,active_out,Label)"              " 輸出 - 使用中的     "
::msgcat::mcset $gPB(LANG) "MC(wseq,suppressed_out,Label)"          " 輸出 - 抑制的 "

::msgcat::mcset $gPB(LANG) "MC(wseq,popup_new,Label)"               "新建"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_undo,Label)"              "復原"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_edit,Label)"              "編輯"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_delete,Label)"            "刪除"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_all,Label)"               "全部啟動"
::msgcat::mcset $gPB(LANG) "MC(wseq,transient_win,Label)"           "文字"
::msgcat::mcset $gPB(LANG) "MC(wseq,cannot_suppress_msg)"           "不能被抑制。它已經作為單個單元用於"
::msgcat::mcset $gPB(LANG) "MC(wseq,empty_block_msg)"               "抑制此地址的輸出將導致無效的空塊。"

##----------------
## Custom Command
##
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,tab,Label)"                 "自訂指令"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,Status)"                    "定義自訂指令"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name,Label)"                "指令名稱"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name,Context)"              "您在此處輸入的名稱將加上字首 PB_CMD_ 以作為實際的指令名。"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,proc,Label)"                "步驟"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,proc,Context)"              "您必須輸入 Tcl 指令碼以定義此指令的功能。\n\n * 注意：指令碼的內容不會被後處理建構器解析，但會被儲存在 Tcl 檔案中。因此，您必須對指令碼的語法正確性負責。"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg)"                  "自訂指令名無效。\n請指定其他名稱"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_1)"                "已經預留給特殊自訂指令。\n請指定其他名稱"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_2)"                "僅允許類似於\n PB_CMD_vnc____ * 的 VNC 自訂指令名。\n請指定其他名稱"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,Label)"              "匯入"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,Context)"            "將選定 Tcl 檔案中的自訂指令匯入進行中的後處理。"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,Label)"              "匯出"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,Context)"            "將進行中的後處理中的自訂指令匯出到 Tcl 檔案。"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,tree,Label)"         "匯入自訂指令"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,tree,Context)"       "此清單包含您指定匯入的檔案中存在的自訂指令步驟和 Tcl 步驟。您可以通過點擊滑鼠左鍵選取清單上的項，以預覽各步驟中的內容。已經存在於進行中的後處理的步驟標有 <exists> 指示符。在某一項上雙擊滑鼠左鍵將切換該項旁邊的核取方塊。此動作允許您選取或取消選取要匯入的步驟。預設情況下，所有步驟都被選中匯入。您可以取消選取某一項以避免覆寫現有的步驟。"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,tree,Label)"         "匯出自訂指令"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,tree,Context)"       "此清單包含存在於進行中的後處理的自訂指令步驟和 Tcl 步驟。您可以通過點擊滑鼠左鍵選取清單上的項，以預覽各步驟中的內容。在某一項上雙擊滑鼠左鍵將切換該項旁邊的核取方塊。這樣可供您只選取要匯出的步驟。"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,error,title)"               "自訂指令錯誤"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,error,msg)"                 "通過設定主功能表項\"選項 -> 驗證自訂指令\"的下拉功能表上的開關，可以啟用或停用自訂指令的驗證。"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,select_all,Label)"          "全選"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,select_all,Context)"        "點擊此按鈕可選取所有顯示用於匯入或匯出的指令。"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,deselect_all,Label)"        "全不選"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,deselect_all,Context)"      "點擊此按鈕可取消選取所有指令。"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,warning,title)"      "自訂指令匯入/匯出警告"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,warning,msg)"        "沒有選取任何項進行匯入或匯出。"



::msgcat::mcset $gPB(LANG) "MC(cust_cmd,cmd,msg)"                   "指令： "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,blk,msg)"                   "塊： "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,add,msg)"                   "地址： "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,fmt,msg)"                   "格式： "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,referenced,msg)"            "在自訂指令中參考 "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,not_defined,msg)"           "尚未在進行中的後處理目前範圍中定義。"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,cannot_delete,msg)"         "不能刪除。"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,save_post,msg)"             "您仍要儲存該後處理嗎？"


##------------------
## Operator Message
##
::msgcat::mcset $gPB(LANG) "MC(opr_msg,text,Label)"                 "作業員訊息"
::msgcat::mcset $gPB(LANG) "MC(opr_msg,text,Context)"               "即將顯示為運算程式訊息的文字。訊息開始和結束必需的特殊字元將被自動附加到後處理建構器。這些字元可以在 \"N/C 資料定義\"標籤下面的\"其他資料單元\"參數頁面中指定。"

::msgcat::mcset $gPB(LANG) "MC(opr_msg,name,Label)"                 "訊息名稱"
::msgcat::mcset $gPB(LANG) "MC(opr_msg,empty_operator)"             "作業員訊息不應為空。"


##--------------
## Linked Posts
##
::msgcat::mcset $gPB(LANG) "MC(link_post,tab,Label)"                "連結的後處理"
::msgcat::mcset $gPB(LANG) "MC(link_post,Status)"                   "定義連結的後處理"

::msgcat::mcset $gPB(LANG) "MC(link_post,toggle,Label)"             "連結其他後處理到此後處理"
::msgcat::mcset $gPB(LANG) "MC(link_post,toggle,Context)"           "其他後處理可以連結到此後處理，以處理執行多個簡單銑削和車削模式組合的複雜機床。"

::msgcat::mcset $gPB(LANG) "MC(link_post,head,Label)"               "機頭"
::msgcat::mcset $gPB(LANG) "MC(link_post,head,Context)"             "複雜機床可以在多種加工模式中使用不同的運動學群組來執行加工工序。每組運動學可以作為 NX/後處理的獨立機頭。需要用特定機頭執行的加工工序將作為一組放在機床或加工方法視圖中。\\\"機頭 \\\"UDE 隨後將被指派到該群組，以指定此機頭的名稱。"

::msgcat::mcset $gPB(LANG) "MC(link_post,post,Label)"               "後處理"
::msgcat::mcset $gPB(LANG) "MC(link_post,post,Context)"             "後處理被指派到機頭中，用於生成 N/C 程式碼。"

::msgcat::mcset $gPB(LANG) "MC(link_post,link,Label)"               "連結的後處理"
::msgcat::mcset $gPB(LANG) "MC(link_post,link,Context)"             "[::msgcat::mc MC(link_post,head,Context)]\n\n[::msgcat::mc MC(link_post,post,Context)]"


::msgcat::mcset $gPB(LANG) "MC(link_post,new,Label)"                "新建"
::msgcat::mcset $gPB(LANG) "MC(link_post,new,Context)"              "建立新連結。"

::msgcat::mcset $gPB(LANG) "MC(link_post,edit,Label)"               "編輯"
::msgcat::mcset $gPB(LANG) "MC(link_post,edit,Context)"             "編輯連結。"

::msgcat::mcset $gPB(LANG) "MC(link_post,delete,Label)"             "刪除"
::msgcat::mcset $gPB(LANG) "MC(link_post,delete,Context)"           "刪除連結。"

::msgcat::mcset $gPB(LANG) "MC(link_post,select_name,Label)"        "選取名稱"
::msgcat::mcset $gPB(LANG) "MC(link_post,select_name,Context)"      "選取要指派給機頭的後處理名稱。此後處理很可能在 NX/後處理執行時中主後處理所在的目錄中，否則將使用 \\\$UGII_CAM_POST_DIR 目錄中同名的後處理。"

::msgcat::mcset $gPB(LANG) "MC(link_post,start_of_head,Label)"      "機頭開始"
::msgcat::mcset $gPB(LANG) "MC(link_post,start_of_head,Context)"    "指定機頭開始時要執行的 N/C 程式碼或動作。"

::msgcat::mcset $gPB(LANG) "MC(link_post,end_of_head,Label)"        "機頭結束"
::msgcat::mcset $gPB(LANG) "MC(link_post,end_of_head,Context)"      "指定機頭結束時要執行的 N/C 程式碼或動作。"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,head,Label)"           "機頭"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,post,Label)"           "後處理"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,title,Label)"          "連結的後處理"

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(nc_data,tab,Label)"                  "N/C 資料定義"

##-------
## BLOCK
##
::msgcat::mcset $gPB(LANG) "MC(block,tab,Label)"                    "塊"
::msgcat::mcset $gPB(LANG) "MC(block,Status)"                       "定義塊範本"

::msgcat::mcset $gPB(LANG) "MC(block,name,Label)"                   "塊名稱"
::msgcat::mcset $gPB(LANG) "MC(block,name,Context)"                 "輸入塊名稱"

::msgcat::mcset $gPB(LANG) "MC(block,add,Label)"                    "新增文字"
::msgcat::mcset $gPB(LANG) "MC(block,add,Context)"                  "您可以通過按下此按鈕並將其拖曳到以下視窗顯示的塊中，新增文字到塊中。即將建立的文字類型從該按鈕右側的清單方塊中選取。"

::msgcat::mcset $gPB(LANG) "MC(block,select,Label)"                 "塊 -- 文字選取"
::msgcat::mcset $gPB(LANG) "MC(block,select,Context)"               "可以從該清單中選取要新增到塊的文字的類型。"

::msgcat::mcset $gPB(LANG) "MC(block,trash,Label)"                  "塊 -- 垃圾桶"
::msgcat::mcset $gPB(LANG) "MC(block,trash,Context)"                "通過將文字拖曳到垃圾桶，可以移除塊中不想要的文字。"

::msgcat::mcset $gPB(LANG) "MC(block,word,Label)"                   "塊 -- 文字"
::msgcat::mcset $gPB(LANG) "MC(block,word,Context)"                 "通過將文字拖曳到垃圾桶，可以刪除該塊中不想要的文字。\n\n還可以按下滑鼠右鍵來啟動彈出式功能表。該功能表上有幾項服務可用：\n\n * 編輯\n * 變更單元 ->\n * 選用\n * 無文字分隔符號\n * 強制輸出\n * 刪除\n"

::msgcat::mcset $gPB(LANG) "MC(block,verify,Label)"                 "塊 -- 文字驗證"
::msgcat::mcset $gPB(LANG) "MC(block,verify,Context)"               "此視窗顯示要為文字輸出的代表性 N/C 程式碼，這些文字是在以上視窗中顯示的塊中選定（壓下）的。"

::msgcat::mcset $gPB(LANG) "MC(block,new_combo,Label)"              "新地址"
::msgcat::mcset $gPB(LANG) "MC(block,text_combo,Label)"             "文字"
::msgcat::mcset $gPB(LANG) "MC(block,oper_combo,Label)"             "作業員訊息"
::msgcat::mcset $gPB(LANG) "MC(block,comm_combo,Label)"             "指令"

::msgcat::mcset $gPB(LANG) "MC(block,edit_popup,Label)"             "編輯"
::msgcat::mcset $gPB(LANG) "MC(block,view_popup,Label)"             "檢視"
::msgcat::mcset $gPB(LANG) "MC(block,change_popup,Label)"           "變更單元"
::msgcat::mcset $gPB(LANG) "MC(block,user_popup,Label)"             "使用者定義運算式"
::msgcat::mcset $gPB(LANG) "MC(block,opt_popup,Label)"              "選用"
::msgcat::mcset $gPB(LANG) "MC(block,no_sep_popup,Label)"           "無文字分隔符號"
::msgcat::mcset $gPB(LANG) "MC(block,force_popup,Label)"            "強制輸出"
::msgcat::mcset $gPB(LANG) "MC(block,delete_popup,Label)"           "刪除"
::msgcat::mcset $gPB(LANG) "MC(block,undo_popup,Label)"             "復原"
::msgcat::mcset $gPB(LANG) "MC(block,delete_all,Label)"             "刪除所有使用中單元"

::msgcat::mcset $gPB(LANG) "MC(block,cmd_title,Label)"              "自訂指令"
::msgcat::mcset $gPB(LANG) "MC(block,oper_title,Label)"             "作業員訊息"
::msgcat::mcset $gPB(LANG) "MC(block,addr_title,Label)"             "文字"

::msgcat::mcset $gPB(LANG) "MC(block,new_trans,title,Label)"        "文字"

::msgcat::mcset $gPB(LANG) "MC(block,new,word_desc,Label)"          "新地址"
::msgcat::mcset $gPB(LANG) "MC(block,oper,word_desc,Label)"         "作業員訊息"
::msgcat::mcset $gPB(LANG) "MC(block,cmd,word_desc,Label)"          "自訂指令"
::msgcat::mcset $gPB(LANG) "MC(block,user,word_desc,Label)"         "使用者定義運算式"
::msgcat::mcset $gPB(LANG) "MC(block,text,word_desc,Label)"         "文字字串"

::msgcat::mcset $gPB(LANG) "MC(block,user,expr,Label)"              "運算式"

::msgcat::mcset $gPB(LANG) "MC(block,msg,min_word)"                 "一個塊應至少包含一個文字。"

::msgcat::mcset $gPB(LANG) "MC(block,name_msg)"                     "塊名稱無效。\n請指定其他名稱。"

##---------
## ADDRESS
##
::msgcat::mcset $gPB(LANG) "MC(address,tab,Label)"                  "文字"
::msgcat::mcset $gPB(LANG) "MC(address,Status)"                     "定義文字"

::msgcat::mcset $gPB(LANG) "MC(address,name,Label)"                 "文字名稱"
::msgcat::mcset $gPB(LANG) "MC(address,name,Context)"               "您可以編輯文字的名稱。"

::msgcat::mcset $gPB(LANG) "MC(address,verify,Label)"               "文字 -- 驗證"
::msgcat::mcset $gPB(LANG) "MC(address,verify,Context)"             "此視窗顯示要為文字輸出的代表性 N/C 程式碼。"

::msgcat::mcset $gPB(LANG) "MC(address,leader,Label)"               "引導符"
::msgcat::mcset $gPB(LANG) "MC(address,leader,Context)"             "您可以輸入任意數量的字元作為文字的引導符，或者使用滑鼠右鍵顯示彈出式功能表並從中選取字元。"

::msgcat::mcset $gPB(LANG) "MC(address,format,Label)"               "格式"
::msgcat::mcset $gPB(LANG) "MC(address,format,edit,Label)"          "編輯"
::msgcat::mcset $gPB(LANG) "MC(address,format,edit,Context)"        "此按鈕允許您編輯文字使用的格式。"
::msgcat::mcset $gPB(LANG) "MC(address,format,new,Label)"           "新建"
::msgcat::mcset $gPB(LANG) "MC(address,format,new,Context)"         "此按鈕允許您建立新的格式。"

::msgcat::mcset $gPB(LANG) "MC(address,format,select,Label)"        "文字 -- 選取格式"
::msgcat::mcset $gPB(LANG) "MC(address,format,select,Context)"      "此按鈕允許您為文字選取不同的格式。"

::msgcat::mcset $gPB(LANG) "MC(address,trailer,Label)"              "結束符"
::msgcat::mcset $gPB(LANG) "MC(address,trailer,Context)"            "您可以輸入任意數量的字元作為文字的結束符，或者使用滑鼠右鍵顯示彈出式功能表並從中選取字元。"

::msgcat::mcset $gPB(LANG) "MC(address,modality,Label)"             "模態？"
::msgcat::mcset $gPB(LANG) "MC(address,modality,Context)"           "此選項允許您設定文字的形式。"

::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,off,Label)"       "關"
::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,once,Label)"      "一次"
::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,always,Label)"    "始終"

::msgcat::mcset $gPB(LANG) "MC(address,max,value,Label)"            "最大值"
::msgcat::mcset $gPB(LANG) "MC(address,max,value,Context)"          "您將指定文字的最大值。"

::msgcat::mcset $gPB(LANG) "MC(address,value,text,Label)"           "值"

::msgcat::mcset $gPB(LANG) "MC(address,trunc_drop,Label)"           "截斷值"
::msgcat::mcset $gPB(LANG) "MC(address,warn_drop,Label)"            "警告使用者"
::msgcat::mcset $gPB(LANG) "MC(address,abort_drop,Label)"           "中止進程"

::msgcat::mcset $gPB(LANG) "MC(address,max,error_handle,Label)"     "違例處理"
::msgcat::mcset $gPB(LANG) "MC(address,max,error_handle,Context)"   "此按鈕允許您指定違反最大值時的處理方法：\n\n * 截斷值\n * 警告使用者\n * 中止進程\n"

::msgcat::mcset $gPB(LANG) "MC(address,min,value,Label)"            "最小值"
::msgcat::mcset $gPB(LANG) "MC(address,min,value,Context)"          "您將指定文字的最小值。"

::msgcat::mcset $gPB(LANG) "MC(address,min,error_handle,Label)"     "違例處理"
::msgcat::mcset $gPB(LANG) "MC(address,min,error_handle,Context)"   "此按鈕允許您指定違反最小值時的處理方法：\n\n * 截斷值\n * 警告使用者\n * 中止進程\n"

::msgcat::mcset $gPB(LANG) "MC(address,format_trans,title,Label)"   "格式 "
::msgcat::mcset $gPB(LANG) "MC(address,none_popup,Label)"           "無"

::msgcat::mcset $gPB(LANG) "MC(address,exp,Label)"                  "運算式"
::msgcat::mcset $gPB(LANG) "MC(address,exp,Context)"                "您可以指定運算式或常數到塊中。"
::msgcat::mcset $gPB(LANG) "MC(address,exp,msg)"                    "塊單元的運算式不能為空。"
::msgcat::mcset $gPB(LANG) "MC(address,exp,space_only)"             "使用數字格式的塊單元運算式不能僅包含空格。"

## No translation is needed for this string.
::msgcat::mcset $gPB(LANG) "MC(address,exp,spec_char)"              "\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@ \[  \\  \]  \^  \`  \{  \|  \}  \~"

::msgcat::mcset $gPB(LANG) "MC(address,exp,spec_char_msg)"          "特殊字元\n [::msgcat::mc MC(address,exp,spec_char)]\n不能用於數字資料的運算式。"



::msgcat::mcset $gPB(LANG) "MC(address,name_msg)"                   "文字名稱無效。\n請指定其他名稱。"
# - No translation for rapid1, rapid2 & rapid3
::msgcat::mcset $gPB(LANG) "MC(address,rapid_add_name_msg)"         "Rapid1、rapid2 和 rapid3 已經由後處理建構器預留供內部使用。\n請指定其他名稱。"

::msgcat::mcset $gPB(LANG) "MC(address,rapid1,desc)"                "沿縱向軸快速定位"
::msgcat::mcset $gPB(LANG) "MC(address,rapid2,desc)"                "沿橫向軸快速定位"
::msgcat::mcset $gPB(LANG) "MC(address,rapid3,desc)"                "沿主軸快速定位"

##--------
## FORMAT
##
::msgcat::mcset $gPB(LANG) "MC(format,tab,Label)"                   "格式"
::msgcat::mcset $gPB(LANG) "MC(format,Status)"                      "定義格式"

::msgcat::mcset $gPB(LANG) "MC(format,verify,Label)"                "格式 -- 驗證"
::msgcat::mcset $gPB(LANG) "MC(format,verify,Context)"              "此視窗顯示將使用指定格式進行輸出的代表性 N/C 程式碼。"

::msgcat::mcset $gPB(LANG) "MC(format,name,Label)"                  "格式名"
::msgcat::mcset $gPB(LANG) "MC(format,name,Context)"                "您可以編輯格式的名稱。"

::msgcat::mcset $gPB(LANG) "MC(format,data,type,Label)"             "資料類型"
::msgcat::mcset $gPB(LANG) "MC(format,data,type,Context)"           "您將指定格式的資料類型。"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,Label)"              "數字"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,Context)"            "此選項將格式的資料類型定義為數字。"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,integer,Label)"      "格式 -- 整數數字數"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,integer,Context)"    "此選項指定整數或實數整數部分的位數。"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,fraction,Label)"     "格式 -- 分數數字數"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,fraction,Context)"   "此選項指定實數分數部分的位數。"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,decimal,Label)"      "輸出小數點 (.)"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,decimal,Context)"    "此選項允許您在 N/C 程式碼中輸出小數點。"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,lead,Label)"         "輸出前置零"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,lead,Context)"       "此選項啟用附加到 N/C 程式碼數字中的前置零。"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,trail,Label)"        "輸出後置零"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,trail,Context)"      "此選項啟用附加到 N/C 程式碼實數中的後置零。"
::msgcat::mcset $gPB(LANG) "MC(format,data,text,Label)"             "文字"
::msgcat::mcset $gPB(LANG) "MC(format,data,text,Context)"           "此選項將格式的資料類型定義為文字字串。"
::msgcat::mcset $gPB(LANG) "MC(format,data,plus,Label)"             "輸出前置字元為加號 (+)"
::msgcat::mcset $gPB(LANG) "MC(format,data,plus,Context)"           "此選項允許您在 N/C 程式碼中輸出加號。"
::msgcat::mcset $gPB(LANG) "MC(format,zero_msg)"                    "不能建立零格式副本"
::msgcat::mcset $gPB(LANG) "MC(format,zero_cut_msg)"                "不能刪除零格式"

::msgcat::mcset $gPB(LANG) "MC(format,data,dec_zero,msg)"           "應至少選中一個小數點、前置零或後置零選項。"

::msgcat::mcset $gPB(LANG) "MC(format,data,no_digit,msg)"           "整數和分數的位元數不能都為零。"

::msgcat::mcset $gPB(LANG) "MC(format,name_msg)"                    "格式名稱無效。\n請指定其他名稱。"
::msgcat::mcset $gPB(LANG) "MC(format,error,title)"                 "格式錯誤"
::msgcat::mcset $gPB(LANG) "MC(format,error,msg)"                   "此格式已在地址中使用"

##---------------------
## Other Data Elements
##
::msgcat::mcset $gPB(LANG) "MC(other,tab,Label)"                    "其他資料單元"
::msgcat::mcset $gPB(LANG) "MC(other,Status)"                       "指定參數"

::msgcat::mcset $gPB(LANG) "MC(other,seq_num,Label)"                "序號"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,Context)"              "此開關允許您啟用/停用在 N/C 程式碼中輸出序列號。"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,start,Label)"          "序號開始值"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,start,Context)"        "指定序列號的開始值。"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,inc,Label)"            "序號增量值"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,inc,Context)"          "指定序列號的增量值。"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,freq,Label)"           "序號頻率"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,freq,Context)"         "指定序號出現在 N/C 程式碼中的頻率。"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,max,Label)"            "序號最大值"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,max,Context)"          "指定序號的最大值。"

::msgcat::mcset $gPB(LANG) "MC(other,chars,Label)"                  "特殊字元"
::msgcat::mcset $gPB(LANG) "MC(other,chars,word_sep,Label)"         "文字分隔符號"
::msgcat::mcset $gPB(LANG) "MC(other,chars,word_sep,Context)"       "指定用作文字分隔符號的字元。"
::msgcat::mcset $gPB(LANG) "MC(other,chars,decimal_pt,Label)"       "小數點"
::msgcat::mcset $gPB(LANG) "MC(other,chars,decimal_pt,Context)"     "指定用作小數點的字元。"
::msgcat::mcset $gPB(LANG) "MC(other,chars,end_of_block,Label)"     "塊結束"
::msgcat::mcset $gPB(LANG) "MC(other,chars,end_of_block,Context)"   "指定用作塊結束的字元。"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_start,Label)"    "訊息開始"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_start,Context)"  "指定要用作作業員訊息列開始的字元。"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_end,Label)"      "訊息結束"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_end,Context)"    "指定要用作作業員訊息列結束的字元。"

::msgcat::mcset $gPB(LANG) "MC(other,opskip,Label)"                 "OPSKIP"
::msgcat::mcset $gPB(LANG) "MC(other,opskip,leader,Label)"          "列引導符"
::msgcat::mcset $gPB(LANG) "MC(other,opskip,leader,Context)"        "OPSKIP 列引導符"

::msgcat::mcset $gPB(LANG) "MC(other,gm_codes,Label)"               "每塊的 G 和 M 程式碼輸出"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,Label)"                "每塊的 G 程式碼數"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,Context)"              "此開關允許您啟用/停用每個 N/C 輸出塊的 G 程式碼數控制。"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,num,Label)"            "G 程式碼數"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,num,Context)"          "指定每個 N/C 輸出塊的 G 程式碼數。"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,Label)"                "M 程式碼數"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,Context)"              "此開關允許您啟用/停用每個 N/C 輸出塊的 M 程式碼數控制。"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,num,Label)"            "每塊的 M 程式碼數"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,num,Context)"          "指定每個 N/C 輸出塊的 M 程式碼數。"

::msgcat::mcset $gPB(LANG) "MC(other,opt_none,Label)"               "無"
::msgcat::mcset $gPB(LANG) "MC(other,opt_space,Label)"              "空格"
::msgcat::mcset $gPB(LANG) "MC(other,opt_dec,Label)"                "小數點 (.)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_comma,Label)"              "逗號 (,)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_semi,Label)"               "分號 (;)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_colon,Label)"              "冒號 (:)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_text,Label)"               "文字字串"
::msgcat::mcset $gPB(LANG) "MC(other,opt_left,Label)"               "左括弧 ("
::msgcat::mcset $gPB(LANG) "MC(other,opt_right,Label)"              "右括弧 )"
::msgcat::mcset $gPB(LANG) "MC(other,opt_pound,Label)"              "井號 (\#)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_aster,Label)"              "星號 (*)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_slash,Label)"              "斜線 (/)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_new_line,Label)"           "新列 (\\012)"

# UDE Inclusion
::msgcat::mcset $gPB(LANG) "MC(other,ude,Label)"                    "使用者定義事件"
::msgcat::mcset $gPB(LANG) "MC(other,ude_include,Label)"            "包括其他 CDL 檔案"
::msgcat::mcset $gPB(LANG) "MC(other,ude_include,Context)"          "此選項使此後處理可以在其定義檔案中包括對 CDL 檔案的參照。"

::msgcat::mcset $gPB(LANG) "MC(other,ude_file,Label)"               "CDL 檔名"
::msgcat::mcset $gPB(LANG) "MC(other,ude_file,Context)"             "要在此後處理的定義檔案中參考（包括）的 CDL 檔案的路徑和檔名。路徑名必須以 UG 環境變數 (\\\$UGII) 開始，或者無路徑。如果未指定路徑，則由 UG/NX 在執行階段使用 UGII_CAM_FILE_SEARCH_PATH 定位檔案。"
::msgcat::mcset $gPB(LANG) "MC(other,ude_select,Label)"             "選取名稱"
::msgcat::mcset $gPB(LANG) "MC(other,ude_select,Context)"           "要在此後處理的定義檔案中參考（包括）的 CDL 檔案。預設情況下，選中的檔名字首為 \\\$UGII_CAM_USER_DEF_EVENT_DIR/。您可以在選中後根據需要編輯路徑名。"


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(output,tab,Label)"                   "輸出設定"
::msgcat::mcset $gPB(LANG) "MC(output,Status)"                      "配置輸出參數"

#++++++++++++++
# VNC Controls
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(output,vnc,Label)"                   "虛擬 N/C 控制器"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,std,Label)"          "獨立"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,sub,Label)"          "從屬"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,status,Label)"            "選取 VNC 檔案。"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mis_match,Label)"         "選定的檔案與預設的 VNC 檔名不符合。\n要重新選取檔案嗎？"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,output,Label)"            "產生虛擬 N/C 控制器 (VNC)"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,output,Context)"          "此選項使您能夠產生虛擬 N/C 控制器 (VNC)。因此，通過啟用的 VNC 建立的後處理可用於 ISV。"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,Label)"              "主 VNC"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,Context)"            "從屬 VNC 參考的主 VNC 名稱。在 ISV 執行時，此後處理很可能在從屬 VNC 所在的目錄中，否則將使用 \\\$UGII_CAM_POST_DIR 目錄中同名的後處理。"


::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,err_msg)"                 "必須為從屬 VNC 指定主 VNC。"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,select_name,Label)"       "選取名稱"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,select_name,Context)"     "選取從屬 VNC 參考的 VNC 名稱。在 ISV 執行時，此後處理很可能在從屬 VNC 所在的目錄中，否則將使用 \\\$UGII_CAM_POST_DIR 目錄中同名的後處理。"

::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,Label)"                   "虛擬 N/C 控制器模式"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,Context)"                 "虛擬 N/C 控制器可以是獨立的，也可以是主 VNC 的從屬。"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,std,Context)"             "獨立 VNC 是不依賴其他 VNC 的。"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,sub,Context)"             "從屬 VNC 在很大程度上依賴主 VNC。它將在 ISV 執行階段對主 VNC 尋來源。"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,pb_ver,msg)"                   "後處理建構器建立的虛擬 N/C 控制器 "
#++++++++++++++
# Listing File
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(listing,tab,Label)"                  "清單檔案"
::msgcat::mcset $gPB(LANG) "MC(listing,Status)"                     "指定清單檔案參數"

::msgcat::mcset $gPB(LANG) "MC(listing,gen,Label)"                  "產生清單檔案"
::msgcat::mcset $gPB(LANG) "MC(listing,gen,Context)"                "此開關允許您啟用/停用輸出清單檔案。"

::msgcat::mcset $gPB(LANG) "MC(listing,Label)"                      "清單檔案單元"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,Label)"                "元件"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,x,Label)"              "X 座標"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,x,Context)"            "此開關允許您啟用/停用將 X 座標輸出到清單檔案。"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,y,Label)"              "Y 座標"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,y,Context)"            "此開關允許您啟用/停用將 Y 座標輸出到清單檔案。"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,z,Label)"              "Z 座標"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,z,Context)"            "此開關允許您啟用/停用將 Z 座標輸出到清單檔案。"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,4,Label)"              "第 4 軸角度"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,4,Context)"            "此開關允許您啟用/停用將第 4 軸角度輸出到清單檔案。"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,5,Label)"              "第 5 軸角度"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,5,Context)"            "此開關允許您啟用/停用將第 5 軸角度輸出到清單檔案。"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,feed,Label)"           "進給"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,feed,Context)"         "此開關允許您啟用/停用將進給率輸出到清單檔案。"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,speed,Label)"          "速度"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,speed,Context)"        "此開關允許您啟用/停用將主軸速度輸出到清單檔案。"

::msgcat::mcset $gPB(LANG) "MC(listing,extension,Label)"            "清單副檔名"
::msgcat::mcset $gPB(LANG) "MC(listing,extension,Context)"          "指定清單副檔名"

::msgcat::mcset $gPB(LANG) "MC(listing,nc_file,Label)"              "N/C 輸出副檔名"
::msgcat::mcset $gPB(LANG) "MC(listing,nc_file,Context)"            "指定 N/C 輸出副檔名"

::msgcat::mcset $gPB(LANG) "MC(listing,header,Label)"               "程式頭"
::msgcat::mcset $gPB(LANG) "MC(listing,header,oper_list,Label)"     "工序清單"
::msgcat::mcset $gPB(LANG) "MC(listing,header,tool_list,Label)"     "刀具清單"

::msgcat::mcset $gPB(LANG) "MC(listing,footer,Label)"               "程式尾"
::msgcat::mcset $gPB(LANG) "MC(listing,footer,cut_time,Label)"      "總加工時間"

::msgcat::mcset $gPB(LANG) "MC(listing,format,Label)"                   "頁面格式"
::msgcat::mcset $gPB(LANG) "MC(listing,format,print_header,Label)"      "列印頁首"
::msgcat::mcset $gPB(LANG) "MC(listing,format,print_header,Context)"    "此開關允許您啟用/停用將頁首輸出到清單檔案。"

::msgcat::mcset $gPB(LANG) "MC(listing,format,length,Label)"        "頁面長度（列）"
::msgcat::mcset $gPB(LANG) "MC(listing,format,length,Context)"      "指定清單檔案每頁的列數。"
::msgcat::mcset $gPB(LANG) "MC(listing,format,width,Label)"         "頁面寬度（欄）"
::msgcat::mcset $gPB(LANG) "MC(listing,format,width,Context)"       "指定清單檔案每頁的欄數。"

::msgcat::mcset $gPB(LANG) "MC(listing,other,tab,Label)"            "其他選項"
::msgcat::mcset $gPB(LANG) "MC(listing,output,Label)"               "輸出控制單元"

::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,Label)"       "輸出警告訊息"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,Context)"     "此開關允許您在後處理過程中啟用/停用警告訊息的輸出。"

::msgcat::mcset $gPB(LANG) "MC(listing,output,review,Label)"        "啟動檢查工具"
::msgcat::mcset $gPB(LANG) "MC(listing,output,review,Context)"      "此開關允許您在後處理過程中啟動審核工具。"

::msgcat::mcset $gPB(LANG) "MC(listing,output,group,Label)"         "產生群組輸出"
::msgcat::mcset $gPB(LANG) "MC(listing,output,group,Context)"       "此開關允許您在後處理過程中啟用/停用群組輸出的控制。"

::msgcat::mcset $gPB(LANG) "MC(listing,output,verbose,Label)"       "顯示詳細錯誤訊息"
::msgcat::mcset $gPB(LANG) "MC(listing,output,verbose,Context)"     "此開關允許您顯示錯誤情況的擴展敘述。它會在一定程度上減慢後處理的速度。"

::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,Label)"            "工序資訊"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,parms,Label)"      "工序參數"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,tool,Label)"       "刀具參數"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,cut_time,,Label)"  "加工時間"


#<09-19-00 gsl>
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,frame,Label)"       "使用者 Tcl 來源"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,check,Label)"       "尋來源使用者 Tcl 檔案"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,check,Context)"     "此開關允許您參考自己的 Tcl 檔案"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,name,Label)"        "檔名"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,name,Context)"      "指定您想要為該後處理參考的 Tcl 檔名"

#++++++++++++++++
# Output Preview
#++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(preview,tab,Label)"                  "後處理檔案預覽"
::msgcat::mcset $gPB(LANG) "MC(preview,new_code,Label)"             "新程式碼"
::msgcat::mcset $gPB(LANG) "MC(preview,old_code,Label)"             "舊程式碼"

##---------------------
## Event Handler
##
::msgcat::mcset $gPB(LANG) "MC(event_handler,tab,Label)"            "事件處理常式"
::msgcat::mcset $gPB(LANG) "MC(event_handler,Status)"               "選取事件以檢視步驟"

##---------------------
## Definition
##
::msgcat::mcset $gPB(LANG) "MC(definition,tab,Label)"               "定義"
::msgcat::mcset $gPB(LANG) "MC(definition,Status)"                  "選取項以檢視內容"

#++++++++++++++
# Post Advisor
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(advisor,tab,Label)"                  "後處理顧問"
::msgcat::mcset $gPB(LANG) "MC(advisor,Status)"                     "後處理顧問"

::msgcat::mcset $gPB(LANG) "MC(definition,word_txt,Label)"          "WORD_SEPARATOR"
::msgcat::mcset $gPB(LANG) "MC(definition,end_txt,Label)"           "END_OF_BLOCK"
::msgcat::mcset $gPB(LANG) "MC(definition,seq_txt,Label)"           "SEQUENCE_NUM"
::msgcat::mcset $gPB(LANG) "MC(definition,include,Label)"           "INCLUDE"
::msgcat::mcset $gPB(LANG) "MC(definition,format_txt,Label)"        "格式"
::msgcat::mcset $gPB(LANG) "MC(definition,addr_txt,Label)"          "文字"
::msgcat::mcset $gPB(LANG) "MC(definition,block_txt,Label)"         "塊"
::msgcat::mcset $gPB(LANG) "MC(definition,comp_txt,Label)"          "複合塊"
::msgcat::mcset $gPB(LANG) "MC(definition,post_txt,Label)"          "後處理塊"
::msgcat::mcset $gPB(LANG) "MC(definition,oper_txt,Label)"          "作業員訊息"

#+++++++++++++
# Balloon
#+++++++++++++
::msgcat::mcset $gPB(LANG) "MC(msg,odd)"                            "可選引數的奇數計數"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_list_1)"                   "未知選項"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_list_2)"                   "必須為其中一個："

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Program Start
::msgcat::mcset $gPB(LANG) "MC(event,start_prog,name)"              "程式開始"

### Operation Start
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,start_path,name)"    "刀軌開始"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,from_move,name)"     "出發點移動"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_tool,name)"      "第一個刀具"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,auto_tc,name)"       "自動換刀"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,manual_tc,name)"     "手動換刀"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,init_move,name)"     "初始移動"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_move,name)"      "第一次移動"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,appro_move,name)"    "逼近移動"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,engage_move,name)"   "進刀移動"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_cut,name)"       "第一刀切削"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_lin_move,name)"  "第一個線性移動"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,start_pass,name)"    "刀路開始"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,cutcom_move,name)"   "刀具補償移動"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,lead_move,name)"     "前置字元為移動"

### Operation End
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,ret_move,name)"        "退刀移動"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,rtn_move,name)"        "返回移動"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,goh_move,name)"        "回零移動"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,end_path,name)"        "刀軌結束"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,lead_move,name)"       "後匯移動"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,end_pass,name)"        "刀路結束"

### Program End
::msgcat::mcset $gPB(LANG) "MC(event,end_prog,name)"                "程式結束"


### Tool Change
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,name)"             "換刀"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code)"           "M 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,tl_chng)"   "換刀"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,pt)"        "主轉塔"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,st)"        "輔助轉塔"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code)"           "T 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,conf)"      "配置"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,pt_idx)"    "主轉塔索引"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,st_idx)"    "輔助轉塔索引"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num)"         "刀具號"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num,min)"     "最小值"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num,max)"     "最大值"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,time)"             "時間（秒）"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,time,tl_chng)"     "換刀"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,retract)"          "退刀"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,retract_z)"        "退刀到以下的 Z 處："

### Length Compensation
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,name)"            "長度補償"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,g_code)"          "G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,g_code,len_adj)"  "刀具長度調整"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,t_code)"          "T 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,t_code,conf)"     "配置"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off)"         "長度補償寄存器"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off,min)"     "最小值"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off,max)"     "最大值"

### Set Modes
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,name)"               "設定模式"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,out_mode)"           "輸出模式"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code)"             "G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code,absolute)"    "絕對"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code,incremental)" "增量"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,rotary_axis)"        "旋轉軸可以是遞增的"

### Spindle RPM
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,name)"                     "主軸 RPM"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code)"               "主軸方向 M 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code,cw)"            "順時針 (CW)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code,ccw)"           "逆時針 (CCW)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control)"            "主軸範圍控制"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control,dwell_time)" "範圍變更駐留時間（秒）"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control,range_code)" "指定範圍程式碼"

### Spindle CSS
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,name)"             "主軸 CSS"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code)"           "主軸 G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,const)"     "恆定表面程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,max)"       "最大 RPM 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,sfm)"       "用於取消 SFM 的程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,max)"              "CSS 中的最大 RPM"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,sfm)"              "始終讓 IPR 模式用於 SFM"

### Spindle Off
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,name)"             "主軸關"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,dir_m_code)"       "主軸方向 M 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,dir_m_code,off)"   "關"

### Coolant On
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,name)"              "冷卻液開"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code)"            "M 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,on)"         "開"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,flood)"      "液態"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,mist)"       "霧狀"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,thru)"       "通孔"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,tap)"        "攻絲"

### Coolant Off
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,name)"             "冷卻液關"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,m_code)"           "M 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,m_code,off)"       "關"

### Inch Metric Mode
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,name)"            "英寸公制模式"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code)"          "G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code,english)"  "英制（英寸）"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code,metric)"   "公制（公釐）"

### Feedrates
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,name)"               "進給率"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,ipm_mode)"           "IPM 模式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,ipr_mode)"           "IPR 模式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,dpm_mode)"           "DPM 模式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mmpm_mode)"          "MMPM 模式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mmpr_mode)"          "MMPR 模式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,frn_mode)"           "FRN 模式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,g_code)"             "G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,format)"             "格式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,max)"                "最大值"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,min)"                "最小值"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,label)"         "進給率模式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,lin)"           "僅線性"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rot)"           "僅旋轉"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,lin_rot)"       "線性和旋轉"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_lin)"       "僅快速線性"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_rot)"       "僅快速旋轉"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_lin_rot)"   "快速線性和旋轉"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,cycle_mode)"         "迴圈進給率模式"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,cycle)"              "迴圈"

### Cutcom On
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,name)"               "刀具補償開啟"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,g_code)"             "G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,left)"               "左"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,right)"              "右"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,app_planes)"         "適用平面"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,edit_planes)"        "編輯平面程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,reg)"                "刀具補償寄存器"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,min)"                "最小值"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,max)"                "最大值"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,bef)"                "換刀前關閉刀具補償"

### Cutcom Off
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,name)"              "刀具補償關閉"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,g_code)"            "G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,off)"               "關"

### Delay
::msgcat::mcset $gPB(LANG) "MC(event,delay,name)"                   "延遲"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds)"                "秒"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds,g_code)"         "G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds,format)"         "格式"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode)"               "輸出模式"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,sec)"           "僅秒數"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,rev)"           "僅轉數"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,feed)"          "依賴於進給率"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,ivs)"           "反向時間"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution)"             "轉"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution,g_code)"      "G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution,format)"      "格式"

### Option Stop
::msgcat::mcset $gPB(LANG) "MC(event,opstop,name)"                  "選取性停刀"

### Auxfun
::msgcat::mcset $gPB(LANG) "MC(event,auxfun,name)"                  "協助工具"

### Prefun
::msgcat::mcset $gPB(LANG) "MC(event,prefun,name)"                  "預覽功能"

### Load Tool
::msgcat::mcset $gPB(LANG) "MC(event,loadtool,name)"                "載入刀具"

### Stop
::msgcat::mcset $gPB(LANG) "MC(event,stop,name)"                    "停止"

### Tool Preselect
::msgcat::mcset $gPB(LANG) "MC(event,toolpreselect,name)"           "刀具預選"

### Thread Wire
::msgcat::mcset $gPB(LANG) "MC(event,threadwire,name)"              "螺紋線"

### Cut Wire
::msgcat::mcset $gPB(LANG) "MC(event,cutwire,name)"                 "切割線"

### Wire Guides
::msgcat::mcset $gPB(LANG) "MC(event,wireguides,name)"              "捆絲導向器"

### Linear Move
::msgcat::mcset $gPB(LANG) "MC(event,linear,name)"                  "線性移動"
::msgcat::mcset $gPB(LANG) "MC(event,linear,g_code)"                "G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,linear,motion)"                "線性運動"
::msgcat::mcset $gPB(LANG) "MC(event,linear,assume)"                "最大移刀速度時設為快速模式"

### Circular Move
::msgcat::mcset $gPB(LANG) "MC(event,circular,name)"                "圓周移動"
::msgcat::mcset $gPB(LANG) "MC(event,circular,g_code)"              "運動 G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,circular,clockwise)"           "順時針 (CLW)"
::msgcat::mcset $gPB(LANG) "MC(event,circular,counter-clock)"       "逆時針 (CCLW)"
::msgcat::mcset $gPB(LANG) "MC(event,circular,record)"              "迴圈記錄"
::msgcat::mcset $gPB(LANG) "MC(event,circular,full_circle)"         "整圓"
::msgcat::mcset $gPB(LANG) "MC(event,circular,quadrant)"            "象限"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_def)"             "IJK 定義"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ij_def)"              "IJ 定義"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ik_def)"              "IK 定義"
::msgcat::mcset $gPB(LANG) "MC(event,circular,planes)"              "適用平面"
::msgcat::mcset $gPB(LANG) "MC(event,circular,edit_planes)"         "編輯平面程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,circular,radius)"              "半徑"
::msgcat::mcset $gPB(LANG) "MC(event,circular,min)"                 "最小值"
::msgcat::mcset $gPB(LANG) "MC(event,circular,max)"                 "最大值"
::msgcat::mcset $gPB(LANG) "MC(event,circular,arc_len)"             "最小圓弧長度"

### Rapid Move
::msgcat::mcset $gPB(LANG) "MC(event,rapid,name)"                   "快速移動"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,g_code)"                 "G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,motion)"                 "快速運動"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,plane_change)"           "工作平面變更"

### Lathe Thread
::msgcat::mcset $gPB(LANG) "MC(event,lathe,name)"                   "車螺紋"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,g_code)"                 "螺紋 G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,cons)"                   "常數"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,incr)"                   "增量"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,decr)"                   "遞減"

### Cycle
::msgcat::mcset $gPB(LANG) "MC(event,cycle,g_code)"                 "G 程式碼和自訂"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,customize,Label)"        "自訂"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,customize,Context)"      "此開關允許您自訂一個迴圈。\n\n預設情況下，每個迴圈的基本建構由「公共參數」的設定定義。每個迴圈中這些常用單元受到限制而無法修改。\n\n開啟此開關允許您獲得對迴圈組態的完全控制。對「公共參數」所作的變更將不再影響任何自訂迴圈。"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,Label)"            "迴圈開始"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,Context)"          "如果有在定義了迴圈 (G81...) 後使用迴圈開始塊 (G79...) 來執行迴圈的機床，可以針對這些機床開啟此選項。"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,text)"             "使用迴圈開始塊執行迴圈"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,rapid_to)"               "快速 - 至"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,retract_to)"             "退刀 - 至"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_control)"          "迴圈平面控制"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,com_param,name)"         "公共參數"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,cycle_off,name)"         "迴圈關閉"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_chng,name)"        "迴圈平面變更"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill,name)"             "鑽"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_dwell,name)"       "鑽駐留"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_text,name)"        "鑽文字"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_csink,name)"       "鑽埋頭孔"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_deep,name)"        "深鑽"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_brk_chip,name)"    "鑽斷屑"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap,name)"               "攻絲"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore,name)"              "鏜"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_dwell,name)"        "鏜駐留"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_drag,name)"         "快退鏜"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_no_drag,name)"      "鏜，橫向偏置後快退"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_back,name)"         "退刀鏜"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_manual,name)"       "手動退刀鏜"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_manual_dwell,name)" "手動退刀鏜延時"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,peck_drill,name)"        "啄鑽"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,break_chip,name)"        "斷屑"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_dwell_sf,name)"    "鑽延時（孔口平面）"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_deep_peck,name)"   "深鑽（啄）"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_ream,name)"         "鏜（鉸）"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_no-drag,name)"      "鏜，橫向偏置後快退"

##------------
## G Code
##
::msgcat::mcset $gPB(LANG) "MC(g_code,rapid,name)"                  "快速運動"
::msgcat::mcset $gPB(LANG) "MC(g_code,linear,name)"                 "線性運動"
::msgcat::mcset $gPB(LANG) "MC(g_code,circular_clw,name)"           "圓弧插補 CLW"
::msgcat::mcset $gPB(LANG) "MC(g_code,circular_cclw,name)"          "圓弧插補 CCLW"
::msgcat::mcset $gPB(LANG) "MC(g_code,delay_sec,name)"              "延遲（秒）"
::msgcat::mcset $gPB(LANG) "MC(g_code,delay_rev,name)"              "延遲（轉）"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_xy,name)"                 "平面 XY"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_zx,name)"                 "平面 ZX"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_yz,name)"                 "平面 YZ"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_off,name)"             "刀具補償關閉"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_left,name)"            "刀具補償左"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_right,name)"           "刀具補償右"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_plus,name)"            "刀具長度調整加"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_minus,name)"           "刀具長度調整減"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_off,name)"             "刀具長度調整關閉"
::msgcat::mcset $gPB(LANG) "MC(g_code,inch,name)"                   "英制模式"
::msgcat::mcset $gPB(LANG) "MC(g_code,metric,name)"                 "公制模式"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_start,name)"            "迴圈開始程式碼"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_off,name)"              "迴圈關閉"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill,name)"            "迴圈鑽"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_dwell,name)"      "迴圈鑽駐留"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_deep,name)"       "迴圈深鑽"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_bc,name)"         "迴圈鑽斷屑"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap,name)"                    "迴圈攻絲"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore,name)"                   "迴圈鏜"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_drag,name)"              "迴圈快退鏜"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_no_drag,name)"           "迴圈鏜，橫向偏置後快退"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_dwell,name)"             "迴圈鏜駐留"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_manual,name)"            "迴圈手動鏜"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_back,name)"              "迴圈退刀鏜"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_manual_dwell,name)"      "迴圈手動駐留鏜"
::msgcat::mcset $gPB(LANG) "MC(g_code,abs,name)"                    "絕對模式"
::msgcat::mcset $gPB(LANG) "MC(g_code,inc,name)"                    "遞增模式"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_retract_auto,name)"     "迴圈退刀（自動）"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_retract_manual,name)"   "迴圈退刀（手動）"
::msgcat::mcset $gPB(LANG) "MC(g_code,reset,name)"                  "重設"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_ipm,name)"                 "進給率模式 IPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_ipr,name)"                 "進給率模式 IPR"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_frn,name)"                 "進給率模式 FRN"
::msgcat::mcset $gPB(LANG) "MC(g_code,spindle_css,name)"            "主軸 CSS"
::msgcat::mcset $gPB(LANG) "MC(g_code,spindle_rpm,name)"            "主軸 RPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,ret_home,name)"               "回零"
::msgcat::mcset $gPB(LANG) "MC(g_code,cons_thread,name)"            "恆定螺紋"
::msgcat::mcset $gPB(LANG) "MC(g_code,incr_thread,name)"            "遞增螺紋"
::msgcat::mcset $gPB(LANG) "MC(g_code,decr_thread,name)"            "遞減螺紋"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_in,pm)"              "進給率模式 IPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_in,pr)"              "進給率模式 IPR"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_mm,pm)"              "進給率模式 MMPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_mm,pr)"              "進給率模式 MMPR"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode,dpm)"                "聯邦制模式 DPM"

##------------
## M Code
##
::msgcat::mcset $gPB(LANG) "MC(m_code,stop_manual_tc,name)"         "停止/手動換刀"
::msgcat::mcset $gPB(LANG) "MC(m_code,stop,name)"                   "停止"
::msgcat::mcset $gPB(LANG) "MC(m_code,opt_stop,name)"               "選取性停刀"
::msgcat::mcset $gPB(LANG) "MC(m_code,prog_end,name)"               "程式結束"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_clw,name)"            "主軸開/CLW"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_cclw,name)"           "主軸 CCLW"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type1)"          "恆定螺紋"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type2)"          "遞增螺紋"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type3)"          "遞減螺紋"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_off,name)"            "主軸關"
::msgcat::mcset $gPB(LANG) "MC(m_code,tc_retract,name)"             "換刀/退刀"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_on,name)"             "冷卻液開"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_fld,name)"            "液態冷卻液"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_mist,name)"           "霧狀冷卻液"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_thru,name)"           "冷卻液通孔"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_tap,name)"            "冷卻液攻絲"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_off,name)"            "冷卻液關"
::msgcat::mcset $gPB(LANG) "MC(m_code,rewind,name)"                 "倒回"
::msgcat::mcset $gPB(LANG) "MC(m_code,thread_wire,name)"            "螺紋線"
::msgcat::mcset $gPB(LANG) "MC(m_code,cut_wire,name)"               "切割線"
::msgcat::mcset $gPB(LANG) "MC(m_code,fls_on,name)"                 "平齊開"
::msgcat::mcset $gPB(LANG) "MC(m_code,fls_off,name)"                "平齊關"
::msgcat::mcset $gPB(LANG) "MC(m_code,power_on,name)"               "電源開"
::msgcat::mcset $gPB(LANG) "MC(m_code,power_off,name)"              "電源關"
::msgcat::mcset $gPB(LANG) "MC(m_code,wire_on,name)"                "割線開"
::msgcat::mcset $gPB(LANG) "MC(m_code,wire_off,name)"               "割線關"
::msgcat::mcset $gPB(LANG) "MC(m_code,pri_turret,name)"             "主轉塔"
::msgcat::mcset $gPB(LANG) "MC(m_code,sec_turret,name)"             "輔助轉塔"

##------------
## UDE
##
::msgcat::mcset $gPB(LANG) "MC(ude,editor,enable,Label)"            "啟用 UDE 編輯器"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,enable,as_saved,Label)"   "按照儲存的"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,TITLE)"                   "使用者定義事件"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,no_ude)"                  "沒有相關的 UDE！"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,int,Label)"               "整數"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,int,Context)"             "新增整數參數，方法是將它拖到右側清單中。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,real,Label)"              "實數"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,real,Context)"            "新增實數參數，方法是將它拖到右側清單中。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,txt,Label)"               "文字"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,txt,Context)"             "新增字串參數，方法是將它拖到右側清單中。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,bln,Label)"               "布林"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bln,Context)"             "新增布林參數，方法是將它拖曳到右側清單中。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,Label)"               "選項"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,Context)"             "新增選項參數，方法是將它拖到右側清單中。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,Label)"               "點"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,Context)"             "新增點參數，方法是將它拖到右側清單中。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,trash,Label)"             "編輯器 -- 垃圾桶"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,trash,Context)"           "通過將參數拖曳到垃圾桶，可以移除右側清單中不想要的參數。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,event,Label)"             "事件"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,event,Context)"           "您可以使用 MB1 在此編輯事件的參數。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,Label)"             "事件 -- 參數"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,Context)"           "您可以通過右鍵點擊編輯各參數，或者通過拖放變更參數順序。\n\n淺藍色參數是系統定義參數，不能刪除。\n實木色參數是非系統定義參數，可以修改或刪除。"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,edit,Label)"        "參數 -- 選項"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,edit,Context)"      "點擊滑鼠鍵 1 選取預設選項。\n雙擊滑鼠鍵 1 編輯選項。"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,editor,Label)"      "參數類型： "

::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,sel,Label)"           "選取"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,dsp,Label)"           "顯示"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,ok,Label)"            "確定"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,bck,Label)"           "後退"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,cnl,Label)"           "取消"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PL,Label)"       "參數標籤"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,VN,Label)"       "變數名"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,DF,Label)"       "預設值"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PL,Context)"     "指定參數標籤"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,VN,Context)"     "指定變數名"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,DF,Context)"     "指定預設值"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG)"             "切換"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG,B,Label)"     "切換"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG,B,Context)"   "選取切換的值"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ON,Label)"       "開"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OFF,Label)"      "關"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ON,Context)"     "選取預設值為「開」"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OFF,Context)"    "選取預設值為「關」"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OL)"             "選項清單"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ADD,Label)"      "新增"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,CUT,Label)"      "剪下"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PASTE,Label)"    "貼上"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ADD,Context)"    "新增項"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,CUT,Context)"    "剪下項"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PASTE,Context)"  "貼上項"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ENTRY,Label)"    "選項"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ENTRY,Context)"  "輸入項"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EN,Label)"       "事件名稱"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EN,Context)"     "指定事件名稱"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,Label)"      "後處理名稱"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,Context)"    "指定後處理名稱"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,C,Label)"    "後處理名稱"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,C,Context)"  "此開關允許您設定或不設定後處理名稱"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,Label)"       "事件標籤"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,Context)"     "指定事件標籤"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,C,Label)"     "事件標籤"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,C,Context)"   "此開關允許您設定或不設定事件標籤"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC,Label)"           "類別"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC,Context)"         "此開關允許您設定或不設定類別"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_MILL,Label)"      "銑"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_DRILL,Label)"     "鑽"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_LATHE,Label)"     "車"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_WEDM,Label)"      "線切割"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_MILL,Context)"    "設定銑類別"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_DRILL,Context)"   "設定鑽類別"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_LATHE,Context)"   "設定車類別"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_WEDM,Context)"    "設定線切割類別"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,EDIT)"                    "編輯事件"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,CREATE)"                  "建立機床控制事件"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,HELP)"              "說明"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,EDIT)"              "編輯使用者定義參數..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,EDIT)"              "編輯..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,VIEW)"              "檢視..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,DELETE)"            "刪除"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,CREATE)"            "新建機床控制事件..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,IMPORT)"            "匯入機床控制事件..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_BLANK)"         "事件名稱不能為空！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_SAMENAME)"      "事件名稱已經存在！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_SameHandler)"   "事件處理常式已經存在！\n如果已經將其選中，請修改事件名稱或後處理名稱！"
::msgcat::mcset $gPB(LANG) "MC(ude,validate)"                       "此事件中沒有參數！"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,tab,Label)"                 "使用者定義事件"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,ude,Label)"                 "機床控制事件"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,udc,Label)"                 "使用者自定義迴圈"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,mc,Label)"                  "系統機床控制事件"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,nmc,Label)"                 "非系統機床控制事件"
::msgcat::mcset $gPB(LANG) "MC(udc,prev,sys,Label)"                 "系統迴圈"
::msgcat::mcset $gPB(LANG) "MC(udc,prev,nsys,Label)"                "非系統迴圈"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,Status)"                    "選取定義項"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_BLANK)"           "選項字串不能為空！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_SAME)"            "選項字串已經存在！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_PST_SAME)"        "您貼上的選項已經存在！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_IDENTICAL)"       "有些選項相同！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,NO_OPT)"              "清單中沒有選項！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_NO_VNAME)"      "變數名不能為空！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_EXIST_VNAME)"   "變數名已經存在！"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,spindle_css,INFO)"        "此事件與\"主軸 RPM\" 共用 UDE。"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr,Label)"               "從後處理繼承 UDE"

::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr,Context)"             "此選項使此後處理可以從某個後處理繼承 UDE 定義及其處理常式。"

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,Label)"               "選取後處理"

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,Context)"             "選取所需後處理的 PUI 檔案。建議將所有與正在繼承的後處理相關的檔案（PUI、Def、Tcl 和 CDL）放置在相同的目錄（資料夾）中，供執行階段使用。"

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_cdl,Label)"          "CDL 檔名"

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_cdl,Context)"        "要在此後處理的定義檔案中參考（包括）的與選定後處理相關的 CDL 檔案的路徑和檔名。路徑名必須以 UG 環境變數 (\\\$UGII) 開始，或者無路徑。如果未指定路徑，則由 UG/NX 在執行階段使用 UGII_CAM_FILE_SEARCH_PATH 定位檔案。"

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_def,Label)"          "Def 檔名"
::msgcat::mcset $gPB(LANG) "MC(ude,import,name_def,Context)"        "要在此後處理的定義檔案中參考（包括）的選定後處理的定義檔案路徑和檔名。路徑名必須以 UG 環境變數 (\\\$UGII) 開始，或者無路徑。如果未指定路徑，則由 UG/NX 在執行階段使用 UGII_CAM_FILE_SEARCH_PATH 定位檔案。"

::msgcat::mcset $gPB(LANG) "MC(ude,import,include_cdl,Label)"       "CDL"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_pst,Label)"           "後處理"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_folder,Label)"        "資料夾"
::msgcat::mcset $gPB(LANG) "MC(ude,import,own_folder,Label)"        "資料夾"
::msgcat::mcset $gPB(LANG) "MC(ude,import,own,Label)"               "包括自身 CDL 檔案"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own,Context)"             "此選項使此後處理可以在其定義檔案包括對其自身 CDL 檔案的參照。"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own_ent,Label)"           "自身 CDL 檔案"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own_ent,Context)"         "要在此後處理的定義檔案中參考（包括）的與該後處理相關的 CDL 檔案的路徑和檔名。實際檔名將在儲存此後處理時決定。路徑名必須以 UG 環境變數 (\\\$UGII) 開始，或者無路徑。如果未指定路徑，則由 UG/NX 在執行階段使用 UGII_CAM_FILE_SEARCH_PATH 定位檔案。"

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,pui,status)"          "選取 PUI 檔案"
::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,cdl,status)"          "選取 CDL 檔案"

##---------
## UDC
##
::msgcat::mcset $gPB(LANG) "MC(udc,editor,TITLE)"                   "使用者定義迴圈"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CREATE)"                  "建立使用者定義的迴圈"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,TYPE)"                    "迴圈類型"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,type,UDC)"                "使用者定義"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,type,SYSUDC)"             "系統定義"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,Label)"            "迴圈標籤"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCNAME,Label)"           "迴圈名稱"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,Context)"          "指定迴圈標籤"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCNAME,Context)"         "指定迴圈名稱"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,C,Label)"          "迴圈標籤"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,C,Context)"        "此開關允許您設定迴圈標籤"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,EDIT)"              "編輯使用者定義參數..."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_BLANK)"         "迴圈名稱不能為空！"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SAMENAME)"      "迴圈名稱已經存在！"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SameHandler)"   "事件處理常式已經存在！\n請修改迴圈事件名稱！"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_ISSYSCYC)"      "迴圈名稱屬於系統迴圈類型！"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SYSCYC_EXIST)"  "此類系統迴圈已經存在！"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,EDIT)"                    "編輯迴圈事件"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,CREATE)"            "新建使用者定義的迴圈..."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,IMPORT)"            "匯入使用者定義的迴圈..."
::msgcat::mcset $gPB(LANG) "MC(udc,drill,csink,INFO)"               "此事件與鑽共用處理常式！"
::msgcat::mcset $gPB(LANG) "MC(udc,drill,simulate,INFO)"            "此事件是一種模擬迴圈！"
::msgcat::mcset $gPB(LANG) "MC(udc,drill,dwell,INFO)"               "此事件與以下物件共用使用者定義的迴圈： "


#######
# IS&V
#######
::msgcat::mcset $gPB(LANG) "MC(isv,tab,label)"                      "虛擬 N/C 控制器"
::msgcat::mcset $gPB(LANG) "MC(isv,Status)"                         "指定 ISV 的參數"
::msgcat::mcset $gPB(LANG) "MC(isv,review,Status)"                  "審核 VNC 指令"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,Label)"                    "組態"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_command,Label)"              "VNC 指令"
####################
# General Definition
####################
::msgcat::mcset $gPB(LANG) "MC(isv,select_Main)"                    "為附屬的 VNC 選取主 VNC 檔案。"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,machine,Label)"            "機床"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,component,Label)"          "刀具安裝"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs_frame,Label)"      "程式零參照"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs,Label)"            "元件"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs,Context)"          "指定元件作為 ZCS 參照基礎。它應是在運動學樹中與零件直接或間接相連的非旋轉元件。"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_com,Label)"           "元件"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_com,Context)"         "指定用於安裝刀具的元件。它應是銑後處理的主軸元件或車後處理的轉塔元件。"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_jct,Label)"           "聯接"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_jct,Context)"         "定義用於安裝刀具的聯接。它是銑後處理主軸面中心處的聯接，或者是車後處理的轉塔旋轉聯接。如果轉塔是固定的，則是刀具安裝聯接。"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_name,Label)"          "機床上指定的軸"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_name,Context)"        "指定軸名稱以符合您的機床運動學組態"




::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_frm,Label)"           "NC 軸名稱"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fourth,Label)"         "反向旋轉"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fourth,Context)"       "指定軸的旋轉方向。方向可以是反向或者法向。這只適用於轉檯。"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fifth,Label)"          "反向旋轉"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_limit,Label)"       "旋轉限制"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_limit,Context)"     "指定此旋轉軸是否具有限制"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fifth_limit,Label)"        "旋轉限制"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,limiton,Label)"            "是"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,limitoff,Label)"           "否"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_table,Label)"       "第 4 軸"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fifth_table,Label)"        "第 5 軸"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,header,Label)"             " 轉檯 "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,intialization,Label)"      "控制器"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,general_def,Label)"        "初始設定"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,advanced_def,Label)"       "其他選項"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,InputOutput,Label)"        "特殊 NC 程式碼"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,program,Label)"            "預設程式定義"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,output,Label)"             "匯出程式定義"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,output,Context)"           "儲存程式定義到檔案"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,input,Label)"              "匯入程式定義"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,input,Context)"            "從檔案調用程式定義"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,file_err,Msg)"             "選定檔案不符合預設程式定義檔案的類型，要繼續嗎？"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,wcs,Label)"                "裝夾偏置"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,tool,Label)"               "刀具資料"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,g_code,Label)"             "特殊 G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,special_vnc,Label)"        "特殊 NC 程式碼"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial,frame,Label)"      ""
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_motion,Label)"     "運動"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_motion,Context)"   "指定機床的初始運動"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle,frame,Label)"      "主軸"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle_mode,Label)"       "模式"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle_direction,Label)"  "方向"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle,frame,Context)"    "指定初始主軸速度單位和旋轉方向"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,feedrate_mode,Label)"      "進給率模式"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,feedrate_mode,Context)"    "指定初始進給率單位"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,boolean,frame,Label)"      "布林項定義"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,power_on_wcs,Label)"       "開啟 WCS  "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,power_on_wcs,Context)"     "0 表示將使用預設機床零座標\n1 表示將使用第一個使用者定義裝夾偏置（工作座標）"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,use_s_leader,Label)"       "使用 S"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,use_f_leader,Label)"       "使用 F"


::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,Label)"            "快速折線"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,Context)"          "「開」將按照折線樣式遍曆快速移動；「關」則按照 NC 程式碼（點到點）遍曆快速移動。"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,yes)"              "是"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,no)"               "否"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,on_off_frame,Label)"       "開/關定義"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,stroke_limit,Label)"       "行程限制"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,cutcom,Label)"             "刀具補償"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,tl_adjust,Label)"          "刀具長度調整"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,scale,Label)"              "比例"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,macro_modal,Label)"        "巨集模態"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,wcs_rotate,Label)"         "WCS 旋轉"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,cycle,Label)"              "迴圈"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_mode,frame,Label)"     "輸入模式"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_mode,frame,Context)"   "將初始輸入模式指定為絕對的或遞增的"

###################
# Input/Out Related
###################
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,frame,Label)"        ""
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,rewindstop,Label)"   "倒回停止程式碼"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,rewindstop,Context)" "指定倒回停止程式碼"

::msgcat::mcset $gPB(LANG) "MC(isv,control_var,frame,Label)"        "控制變數"

::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,convarleader,Label)"     "引導符"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,convarleader,Context)"   "指定控制器變數"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,conequ,Label)"           "等號"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,conequ,Context)"         "指定等號為控制變數"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,percent,Label)"          "百分號%"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,leaderjing,Label)"       "井號 #"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,text_string,Label)"      "文字字串"

::msgcat::mcset $gPB(LANG) "MC(isv,inputmode,frame,Label)"          ""
::msgcat::mcset $gPB(LANG) "MC(isv,input_mode,Label)"               "初始模式"
::msgcat::mcset $gPB(LANG) "MC(isv,absolute_mode,Label)"            "絕對"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_style,frame,Label)"  "遞增模式"

::msgcat::mcset $gPB(LANG) "MC(isv,incremental_mode,Label)"         "增量"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_gcode,Label)"        "G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_gcode,Context)"      "使用 G90 G91 區分絕對模式或遞增模式"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_uvw,Label)"          "特殊引導符"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_uvw,Context)"        "使用特殊引導符區分絕對模式或遞增模式。例如引導符 X Y Z 表示處於絕對模式，引導符 U V W 表示處於遞增模式。"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_x,Label)"                   "X "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_y,Label)"                   "Y "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_z,Label)"                   "Z "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_a,Label)"                   "第四軸 "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_b,Label)"                   "第五軸 "

::msgcat::mcset $gPB(LANG) "MC(isv,incr_x,Context)"                 "指定遞增模式中使用的特殊 X 軸引導符"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_y,Context)"                 "指定遞增模式中使用的特殊 Y 軸引導符"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_z,Context)"                 "指定遞增模式中使用的特殊 Z 軸引導符"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_a,Context)"                 "指定遞增模式中使用的特殊第四軸引導符"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_b,Context)"                 "指定遞增模式中使用的特殊第五軸引導符"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_mes,frame,Label)"            "輸出 VNC 訊息"

::msgcat::mcset $gPB(LANG) "MC(isv,vnc_message,Label)"              "列出 VNC 訊息"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_message,Context)"            "如果選中此選項，則模擬過程中將在工序訊息視窗中顯示所有 VNC 偵錯訊息。"

::msgcat::mcset $gPB(LANG) "MC(isv,vnc_mes,prefix,Label)"           "訊息字首"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_desc,Label)"                "敘述"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,Label)"            "程式碼清單"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_nccode,Label)"              "NC 程式碼/字串"

################
# WCS Definition
################
::msgcat::mcset $gPB(LANG) "MC(isv,machine_zero,offset,Label)"      "機床零偏置自\n機床零聯接"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,frame,Label)"         "裝夾偏置"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_leader,Label)"               " 程式碼 "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_number,Label)"               "    "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_x,Label)"      " X 偏置  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_y,Label)"      " Y 向偏置  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_z,Label)"      " Z 向偏置  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,a_offset,Label)"      " A 偏置  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,b_offset,Label)"      " B 偏置  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,c_offset,Label)"      " C 偏置  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_num,Label)"       "座標系"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_num,Context)"     "指定需要新增的裝夾偏置數值"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_add,Label)"       "新增"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_add,Context)"     "新增裝夾偏置座標系，指定其位置"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_err,Msg)"         "此座標系號已經存在！"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,frame,Label)"          "刀具資訊"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_entry,Label)"     "輸入新的刀具名稱"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_name,Label)"      "       名稱       "

::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_num,Label)"       " 刀具 "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_tool,Label)"       "新增"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_diameter,Label)"  " 直徑 "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,offset_usder,Label)"   "   刀尖偏置   "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,carrier_id,Label)"     " 刀架 ID "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,pocket_id,Label)"      " 刀槽 ID "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutcom_reg,Label)"     "     刀具補償     "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutreg,Label)"         "寄存器 "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutval,Label)"         "偏置 "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,adjust_reg,Label)"     " 長度調整 "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_type,Label)"      "   類型   "
::msgcat::mcset $gPB(LANG) "MC(isv,prog,setup,Label)"               "預設程式定義"
::msgcat::mcset $gPB(LANG) "MC(isv,prog,setup_right,Label)"         "程式定義"
::msgcat::mcset $gPB(LANG) "MC(isv,output,setup_data,Label)"        "指定程式定義檔案"
::msgcat::mcset $gPB(LANG) "MC(isv,input,setup_data,Label)"         "選取程式定義檔案"

::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,toolnum,Label)"        "刀具號  "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,toolnum,Context)"      "指定需要新增的刀具號"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_tool,Context)"     "新增刀具，指定其參數"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_err,Msg)"          "此刀具號已經存在！"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,name_err,Msg)"         "刀具名稱不能為空！"

###########################
# Special G code Definition
###########################

::msgcat::mcset $gPB(LANG) "MC(isv,g_code,frame,Label)"             "特殊 G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,frame,Context)"           "指定模擬中使用的特殊 G 程式碼"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,from_home,Label)"         "自零點"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,return_home,Label)"       "回零點 Pn"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,mach_wcs,Label)"          "機床基準移動"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,set_local,Label)"         "設定局部座標"

###########################
# Special NC Custom Command
###########################

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,frame,Label)"       "特殊 NC 指令"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,frame,Context)"     "為特殊設備指定的 NC 指令"


::msgcat::mcset $gPB(LANG) "MC(isv,spec_pre,frame,Label)"           "前處理指令"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_pre,frame,Context)"         "指令清單包含在解析塊以獲取座標前需要處理的所有標記或符號"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add,Label)"         "新增"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,edit,Label)"        "編輯"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,delete,Label)"      "刪除"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,title,Label)"       "其他設備的特殊指令"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add_sim,Label)"     "在游標處新增 SIM 指令"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,init_sim,Label)"    "請選取一個指令"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,preleader,Label)"   "引導符"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,preleader,Context)" "指定使用者定義前處理指令的引導符。"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,precode,Label)"     "程式碼"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,precode,Context)"   "指定使用者定義前處理指令的引導符。"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,leader,Label)"      "引導符"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,leader,Context)"    "指定使用者定義指令的引導符。"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,code,Label)"        "程式碼"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,code,Context)"      "指定使用者定義指令的引導符。"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add,Context)"       "新增使用者定義指令"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add_err,Msg)"       "此標記已被處理！"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,sel_err,Msg)"       "請選取一個指令"
::msgcat::mcset $gPB(LANG) "MC(isv,export,error,title)"             "警告"

::msgcat::mcset $gPB(LANG) "MC(isv,tool_table,title,Label)"         "刀具表"
::msgcat::mcset $gPB(LANG) "MC(isv,ex_editor,warning,Msg)"          "這是系統產生的 VNC 指令。將不儲存變更。"


# - Languages
#
::msgcat::mcset $gPB(LANG) "MC(language,Label)"                     "語言"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_english)"                     "英文"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_french)"                      "法文"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_german)"                      "德文"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_italian)"                     "義大利文"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_japanese)"                    "日文"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_korean)"                      "韓文"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_russian)"                     "俄文"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_simple_chinese)"              "簡體中文"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_spanish)"                     "西班牙文"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_traditional_chinese)"         "繁體中文"

### Exit Options Dialog
::msgcat::mcset $gPB(LANG) "MC(exit,options,Label)"                 "離開選項"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveAll,Label)"         "離開且全部儲存"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveNone,Label)"        "離開但不儲存"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveSelect,Label)"      "離開且儲存選定的"

### OptionMenu Items
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Other)"       "其他"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,None)"        "無"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,RT_R)"        "快速移刀和 R"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Rapid)"       "快轉"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,RS)"          "快速主軸"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,C_off_RS)"    "「迴圈關」，然後「快速主軸」"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,IPM)"         "IPM"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,FRN)"         "FRN"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,IPR)"         "IPR"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Auto)"        "自動"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,DPM)"         "DPM"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Abs_Inc)"     "絕對/遞增"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Abs_Only)"    "僅絕對"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Inc_Only)"    "僅遞增"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,SD)"          "最短距離"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,AP)"          "始終為正"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,AN)"          "始終為負"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Z_Axis)"      "Z 軸"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,+X_Axis)"     "+X 軸"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,-X_Axis)"     "-X 軸"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Y_Axis)"      "Y 軸"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,MDD)"         "幅值決定方向"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,SDD)"         "符號決定方向"


