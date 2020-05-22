#20
proc UI_PB_ProgTpth_Mcode {book_id page_obj} {
global paOption
set Page::($page_obj,page_id) [$book_id subwidget \
$Page::($page_obj,page_name)]
set page_id $Page::($page_obj,page_id)
PB_int_MCodePageAttributes m_codes_desc m_codes_mom_var
set Page::($page_obj,m_codes_mom_var) [array get m_codes_mom_var]
set no_mcodes [array size m_codes_mom_var]
set top_frm [tixScrolledWindow $page_id.top -scrollbar auto]
set act_frm [frame $page_id.actfm]
pack $act_frm -side bottom -fill x
pack $top_frm -side top -expand yes -pady 10 -padx 3
[$top_frm subwidget hsb] config -troughcolor $paOption(trough_bg) \
-width $paOption(trough_wd)
[$top_frm subwidget vsb] config -troughcolor $paOption(trough_bg) \
-width $paOption(trough_wd)
set mcode_frm [$top_frm subwidget window]
UI_PB_mcd_CreateActionButtons $act_frm page_obj
set first_col [frame $mcode_frm.1 -relief sunken -bd 3]
grid $first_col -padx 5 -pady 5
set Page::($page_obj,mcode_frm) $first_col
set data_type "a"
for {set count 0} {$count < $no_mcodes} {incr count} \
{
UI_PB_com_CreateRowAttr $first_col $count $m_codes_desc($count) \
$m_codes_mom_var($count) $data_type
}
}
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
proc UI_PB_mcd_DefaultCallBack { page_obj } {
global mom_sys_arr
array set mcode_vars $Page::($page_obj,m_codes_mom_var)
PB_int_RetDefMOMVarValues mcode_vars def_mcode_value
set no_mcodes [array size mcode_vars]
for {set count 0} { $count < $no_mcodes } { incr count} \
{
set mom_var $mcode_vars($count)
set data_type [UI_PB_com_RetSysVarDataType mom_var]
set mom_sys_arr($mom_var) [UI_PB_com_RetValByDataType \
$def_mcode_value($mom_var) $data_type]
}
}
proc UI_PB_mcd_RestoreCallBack { page_obj } {
global mom_sys_arr
array set rest_mcode_var_value $Page::($page_obj,rest_mcode_var_value)
array set mcode_vars $Page::($page_obj,m_codes_mom_var)
set no_mcodes [array size mcode_vars]
for {set count 0} { $count < $no_mcodes } { incr count} \
{
set mom_var $mcode_vars($count)
set data_type [UI_PB_com_RetSysVarDataType mom_var]
set mom_sys_arr($mom_var) [UI_PB_com_RetValByDataType \
$rest_mcode_var_value($mom_var) $data_type]
}
}
proc UI_PB_mcd_ApplyMcodeData { book_obj page_obj } {
global mom_sys_arr
PB_int_UpdateMOMVar mom_sys_arr
}
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
set mom_sys_arr($mcode_var) [UI_PB_com_RetValByDataType \
$mom_sys_arr($mcode_var) $data_type]
bind $mcode_frm.$count.1_int <KeyPress> "UI_PB_com_ValidateDataOfEntry \
%W %K $data_type"
}
if {[info exists rest_mcode_var_value]} \
{
set Page::($page_obj,rest_mcode_var_value) \
[array get rest_mcode_var_value]
}
}


