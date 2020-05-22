#13

#=======================================================================
proc UI_PB_ProgTpth_Mcode {book_id page_obj} {
  global paOption
  set Page::($page_obj,page_id) [$book_id subwidget \
  $Page::($page_obj,page_name)]
  set page_id $Page::($page_obj,page_id)
  PB_int_MCodePageAttributes m_codes_desc m_codes_mom_var
  set Page::($page_obj,m_codes_mom_var) [array get m_codes_mom_var]
  set no_mcodes [array size m_codes_mom_var]
  switch $::tix_version {
   8.4 {
    set act_frm [frame $page_id.actfm]
    pack $act_frm -side bottom -fill x
    set mcode_frm [UI_PB_mthd_CreateSFrameWindow $page_id.top y]
    pack $page_id.top -expand yes -side top -pady 10 -padx 3
   }
   4.1 {
    set top_frm [tixScrolledWindow $page_id.top -scrollbar auto]
    set act_frm [frame $page_id.actfm]
    pack $act_frm -side bottom -fill x
    pack $top_frm -side top -expand yes -pady 10 -padx 3
    [$top_frm subwidget hsb] config -troughcolor $paOption(trough_bg) \
    -width $paOption(trough_wd)
    [$top_frm subwidget vsb] config -troughcolor $paOption(trough_bg) \
    -width $paOption(trough_wd)
    set mcode_frm [$top_frm subwidget window]
   }
  }
  UI_PB_mcd_CreateActionButtons $act_frm page_obj
  set first_col [frame $mcode_frm.1 -relief sunken -bd 3]
  grid $first_col -padx 5 -pady 5
  set Page::($page_obj,mcode_frm) $first_col
  set data_type "a"
  for {set count 0} {$count < $no_mcodes} {incr count} \
  {
   UI_PB_com_CreateCodeRowAttr $first_col $count $m_codes_desc($count) \
   $m_codes_mom_var($count) $data_type M
  }
  if {$::tix_version == 8.4} {
   update
   set wid [winfo reqwidth $mcode_frm]
   set hei [winfo reqheight $mcode_frm]
   $page_id.top.sf config -width $wid -height $hei
  }
 }

#=======================================================================
proc UI_PB_mcd_CreateActionButtons { act_frm PAGE_OBJ} {
  upvar $PAGE_OBJ page_obj
  global paOption
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_mcd_DefaultCallBack $page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_mcd_RestoreCallBack $page_obj"
  UI_PB_com_CreateButtonBox $act_frm label_list cb_arr
 }

#=======================================================================
proc UI_PB_mcd_DefaultCallBack { page_obj } {
  global mom_sys_arr post_object
  array set mcode_vars $Page::($page_obj,m_codes_mom_var)
  PB_int_RetDefMOMVarValues mcode_vars def_mcode_value
  set no_mcodes [array size mcode_vars]
  array set mcode_desc $Post::($post_object,m_codes_desc)
  for {set count 0} { $count < $no_mcodes } { incr count} \
  {
   set mom_var $mcode_vars($count)
   set data_type [UI_PB_com_RetSysVarDataType mom_var]
   set mom_sys_arr($mom_var) [UI_PB_com_RetValByDataType \
   $def_mcode_value($mom_var) $data_type]
   set gPB($mom_var) $mom_sys_arr($mom_var)
   UI_PB_formatMcodeData mcode_desc $page_obj $count add_name var
  }
 }

#=======================================================================
proc UI_PB_mcd_RestoreCallBack { page_obj } {
  global mom_sys_arr post_object gPB
  array set rest_mcode_var_value $Page::($page_obj,rest_mcode_var_value)
  array set mcode_vars $Page::($page_obj,m_codes_mom_var)
  array set mcode_desc $Post::($post_object,m_codes_desc)
  set no_mcodes [array size mcode_vars]
  for {set count 0} { $count < $no_mcodes } { incr count} \
  {
   set mom_var $mcode_vars($count)
   set data_type [UI_PB_com_RetSysVarDataType mom_var]
   set mom_sys_arr($mom_var) [UI_PB_com_RetValByDataType \
   $rest_mcode_var_value($mom_var) $data_type]
   set gPB($mom_var) $mom_sys_arr($mom_var)
   UI_PB_formatMcodeData mcode_desc $page_obj $count add_name var
  }
 }

#=======================================================================
proc UI_PB_mcd_ApplyMcodeData { book_obj page_obj } {
  global mom_sys_arr
  PB_int_UpdateMOMVar mom_sys_arr
 }

#=======================================================================
proc UI_PB_formatMcodeData { MCODE_DESC page_obj count ADD_NAME VAR } {
  upvar $MCODE_DESC mcode_desc
  upvar $ADD_NAME add_name
  upvar $VAR var
  global mom_sys_arr post_object gPB
  set no_mcodes [array size mcode_desc]
  set mcode_frm $Page::($page_obj,mcode_frm)
  set ent $mcode_frm.$count.1_int
  set mcode_var [$ent cget -textvariable]
  set s [string first "(" $mcode_var]
  set e [string last  ")" $mcode_var]
  set mcode_var [string range $mcode_var [expr $s + 1] [expr $e - 1]]
  UI_PB_mthd_GetAddName $mcode_var M add_name
  UI_PB_com_GetFomFrmAddname $add_name fmt_obj_attr
  set gPB($mcode_var) $mom_sys_arr($mcode_var)
  set var [string trimleft $mcode_var "\$"]
  UI_PB_com_FormatCode $ent $add_name mom_sys_arr $var
 }

#=======================================================================
proc UI_PB_mcd_RestoreMcodeData { page_obj } {
  global mom_sys_arr
  if { ![info exists Page::($page_obj,m_codes_mom_var)] } { return }
  array set mcode_vars $Page::($page_obj,m_codes_mom_var)
  set no_mcodes [array size mcode_vars]
  set mcode_frm $Page::($page_obj,mcode_frm)
  set data_type "a"
  for {set count 0} {$count < $no_mcodes} {incr count} \
  {
   set mcode_var $mcode_vars($count)
   set rest_mcode_var_value($mcode_var) $mom_sys_arr($mcode_var)
   set data_type [UI_PB_com_RetSysVarDataType mcode_var]
   global post_object
   array set mcode_desc $Post::($post_object,m_codes_desc)
   UI_PB_formatMcodeData mcode_desc $page_obj $count add_name var
   if {![info exists positive]} { set positive 0 }
   bind $mcode_frm.$count.1_int <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K $data_type $positive"
   bind $mcode_frm.$count.1_int <KeyRelease> "UI_PB_com_FormatCode %W $add_name mom_sys_arr $var"
   global gpb_addr_var paOption
   if { ![info exists gpb_addr_var($add_name,leader_name)] || [string match "" $gpb_addr_var($add_name,leader_name)] } {
    $mcode_frm.$count.2_int config -bg $paOption(table_bg)
    } else {
    $mcode_frm.$count.2_int config -bg $paOption(special_bg)
   }
  }
  if {[info exists rest_mcode_var_value]} \
  {
   set Page::($page_obj,rest_mcode_var_value) \
   [array get rest_mcode_var_value]
  }
 }
