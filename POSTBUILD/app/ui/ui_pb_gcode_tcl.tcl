
#=======================================================================
proc UI_PB_ProgTpth_Gcode {book_id page_obj} {
  global paOption
  set Page::($page_obj,page_id) [$book_id subwidget \
  $Page::($page_obj,page_name)]
  set page_id $Page::($page_obj,page_id)
  PB_int_GCodePageAttributes g_codes_desc g_codes_mom_var
  set Page::($page_obj,g_codes_mom_var)  [array get g_codes_mom_var]
  set no_gcodes [array size g_codes_mom_var]
  set top_frm [tixScrolledWindow $page_id.top -scrollbar auto]
  set act_frm [frame $page_id.actfm]
  pack $act_frm -side bottom -fill x
  pack $top_frm -side top -expand yes -pady 10 -padx 3
  [$top_frm subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width       $paOption(trough_wd)
  [$top_frm subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width       $paOption(trough_wd)
  set gcode_frm [$top_frm subwidget window]
  UI_PB_gcd_CreateActionButtons $act_frm page_obj
  set no_row_gcodes [expr $no_gcodes / 2]
  if {[expr $no_gcodes %2] > 0} \
  {
   incr no_row_gcodes
  }
  set first_col [frame $gcode_frm.fst -relief sunken -bd 3]
  set second_col [frame $gcode_frm.sec -relief sunken -bd 3]
  set Page::($page_obj,gcode_col1) $first_col
  set Page::($page_obj,gcode_col2) $second_col
  tixForm $first_col -padleft 5 -padtop 5 -padbottom 5
  tixForm $second_col -left $first_col -padleft 5 -padright 5 -padtop 5 -padbottom 5
  set data_type "a"
  for {set count 0} {$count < $no_row_gcodes} {incr count} \
  {
   UI_PB_com_CreateRowAttr $first_col $count $g_codes_desc($count) \
   $g_codes_mom_var($count) $data_type
  }
  for {set count $no_row_gcodes} {$count < $no_gcodes} {incr count} \
  {
   UI_PB_com_CreateRowAttr $second_col $count $g_codes_desc($count) \
   $g_codes_mom_var($count) $data_type
  }
 }

#=======================================================================
proc UI_PB_gcd_RestoreGcodeData { page_obj } {
  global mom_sys_arr
  array set gcode_vars $Page::($page_obj,g_codes_mom_var)
  set no_gcodes [array size gcode_vars]
  set no_row_gcd [expr $no_gcodes / 2]
  if { [expr $no_gcodes % 2] } { incr no_row_gcd }
  set data_type a
  set gcode_frm $Page::($page_obj,gcode_col1)
  set row_no 0
  for {set count 0} {$count < $no_gcodes} {incr count} \
  {
   set gcode_var $gcode_vars($count)
   set rest_gcode_var_value($gcode_var) $mom_sys_arr($gcode_var)
   if { $row_no == $no_row_gcd } \
   {
    set gcode_frm $Page::($page_obj,gcode_col2)
   }
   set data_type [UI_PB_com_RetSysVarDataType gcode_var]
   set mom_sys_arr($gcode_var) [UI_PB_com_RetValByDataType \
   $mom_sys_arr($gcode_var) $data_type]
   bind $gcode_frm.$row_no.1_int <KeyPress> "UI_PB_com_ValidateDataOfEntry \
   %W %K $data_type"
   incr row_no
  }
  if {[info exists rest_gcode_var_value]} \
  {
   set Page::($page_obj,rest_gcode_var_value) \
   [array get rest_gcode_var_value]
  }
 }

#=======================================================================
proc UI_PB_gcd_CreateActionButtons { act_frm PAGE_OBJ} {
  upvar $PAGE_OBJ page_obj
  global paOption
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_gcd_DefaultCallBack $page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_gcd_RestoreCallBack $page_obj"
  UI_PB_com_CreateButtonBox $act_frm label_list cb_arr
 }

#=======================================================================
proc UI_PB_gcd_DefaultCallBack { page_obj } {
  global mom_sys_arr
  array set gcode_vars $Page::($page_obj,g_codes_mom_var)
  PB_int_RetDefMOMVarValues gcode_vars def_gcode_value
  set no_gcodes [array size gcode_vars]
  for {set count 0} { $count < $no_gcodes } { incr count} \
  {
   set mom_var $gcode_vars($count)
   set data_type [UI_PB_com_RetSysVarDataType mom_var]
   set mom_sys_arr($mom_var) [UI_PB_com_RetValByDataType \
   $def_gcode_value($mom_var) $data_type]
  }
 }

#=======================================================================
proc UI_PB_gcd_RestoreCallBack { page_obj } {
  global mom_sys_arr
  array set rest_gcode_var_value $Page::($page_obj,rest_gcode_var_value)
  array set gcode_vars $Page::($page_obj,g_codes_mom_var)
  set no_gcodes [array size gcode_vars]
  for {set count 0} { $count < $no_gcodes } { incr count} \
  {
   set mom_var $gcode_vars($count)
   set data_type [UI_PB_com_RetSysVarDataType mom_var]
   set mom_sys_arr($mom_var) [UI_PB_com_RetValByDataType \
   $rest_gcode_var_value($mom_var) $data_type]
  }
 }

#=======================================================================
proc UI_PB_gcd_ApplyGcodeData { book_obj page_obj } {
  global mom_sys_arr
  PB_int_UpdateMOMVar mom_sys_arr
 }
