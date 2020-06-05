#0

#=======================================================================
proc UI_PB_ProgTpth_Gcode {book_id page_obj} {
  global paOption
  global gPB
  set Page::($page_obj,page_id) [$book_id subwidget \
  $Page::($page_obj,page_name)]
  set page_id $Page::($page_obj,page_id)
  PB_int_GCodePageAttributes g_codes_desc g_codes_mom_var
  set Page::($page_obj,g_codes_mom_var)  [array get g_codes_mom_var]
  set no_gcodes [array size g_codes_mom_var]
  switch $::tix_version {
   8.4 {
    set act_frm [frame $page_id.actfm]
    pack $act_frm -side bottom -fill x
    set gcode_frm [UI_PB_mthd_CreateSFrameWindow $page_id.top y]
    pack $page_id.top -expand yes -side top -pady 10 -padx 3
   }
   4.1 {
    set top_frm [tixScrolledWindow $page_id.top -scrollbar auto]
    set act_frm [frame $page_id.actfm]
    pack $act_frm -side bottom -fill x
    pack $top_frm -side top -expand yes -pady 10 -padx 3
    [$top_frm subwidget hsb] config -troughcolor $paOption(trough_bg) \
    -width       $paOption(trough_wd)
    [$top_frm subwidget vsb] config -troughcolor $paOption(trough_bg) \
    -width       $paOption(trough_wd)
    set gcode_frm [$top_frm subwidget window]
   }
  }
  UI_PB_gcd_CreateActionButtons $act_frm page_obj
  set no_row_gcodes [expr $no_gcodes / 2]
  if {[expr $no_gcodes %2] > 0} \
  {
   incr no_row_gcodes
  }
  set first_col  [frame $gcode_frm.fst -relief sunken -bd 3]
  set second_col [frame $gcode_frm.sec -relief sunken -bd 3]
  set Page::($page_obj,gcode_col1) $first_col
  set Page::($page_obj,gcode_col2) $second_col
  tixForm $first_col -padleft 5 -padtop 5 -padbottom 5
  tixForm $second_col -left $first_col -padleft 5 -padright 5 -padtop 5 -padbottom 5
  set data_type "a"
  for {set count 0} {$count < $no_row_gcodes} {incr count} \
  {
   UI_PB_com_CreateCodeRowAttr $first_col $count $g_codes_desc($count) \
   $g_codes_mom_var($count) $data_type G
  }
  for {set count $no_row_gcodes} {$count < $no_gcodes} {incr count} \
  {
   UI_PB_com_CreateCodeRowAttr $second_col $count $g_codes_desc($count) \
   $g_codes_mom_var($count) $data_type G
  }
  if {$::tix_version == 8.4} {
   update
   set wid [winfo reqwidth $gcode_frm]
   set hei [winfo reqheight $gcode_frm]
   $page_id.top.sf config -width $wid -height $hei
  }
 }

#=======================================================================
proc UI_PB_formatGcodeData { GCODE_DESC page_obj count ADD_NAME VAR args } {
  upvar $GCODE_DESC gcode_desc
  upvar $ADD_NAME add_name
  upvar $VAR var
  global mom_sys_arr post_object gPB
  set no_gcodes [array size gcode_desc]
  set no_row_gcd [expr $no_gcodes / 2]
  if { [expr $no_gcodes % 2] } { incr no_row_gcd }
  if { $count < $no_row_gcd } {
   set gcode_frm $Page::($page_obj,gcode_col1)
   } else {
   set gcode_frm $Page::($page_obj,gcode_col2)
  }
  set ent $gcode_frm.$count.1_int
  set gcode_var [$ent cget -textvariable]
  set s [string first "(" $gcode_var]
  set e [string last  ")" $gcode_var]
  set gcode_var [string range $gcode_var [expr $s + 1] [expr $e - 1]]
  UI_PB_mthd_GetAddName $gcode_var G add_name
  UI_PB_com_GetFomFrmAddname $add_name fmt_obj_attr
  set gPB($gcode_var) $mom_sys_arr($gcode_var)
  set var [string trimleft $gcode_var "\$"]
  if { [llength $args] > 0 } {
   set no_format [lindex $args 0]
  }
  if { ![info exists no_format] || !$no_format } {
   UI_PB_com_FormatCode $ent $add_name mom_sys_arr $var
  }
 }

#=======================================================================
proc UI_PB_gcd_RestoreGcodeData { page_obj args } {
  global mom_sys_arr
  array set gcode_vars $Page::($page_obj,g_codes_mom_var)
  set no_gcodes [array size gcode_vars]
  global post_object
  array set gcode_desc $Post::($post_object,g_codes_desc)
  if { [llength $args] > 0 } {
   set no_format [lindex $args 0]
  }
  set no_row_gcd [expr $no_gcodes / 2]
  if { [expr $no_gcodes % 2] } { incr no_row_gcd }
  set data_type a
  set gcode_frm $Page::($page_obj,gcode_col1)
  set row_no 0
  for { set count 0 } { $count < $no_gcodes } { incr count } \
  {
   set gcode_var $gcode_vars($count)
   set rest_gcode_var_value($gcode_var) $mom_sys_arr($gcode_var)
   if { $row_no == $no_row_gcd } \
   {
    set gcode_frm $Page::($page_obj,gcode_col2)
   }
   set data_type [UI_PB_com_RetSysVarDataType gcode_var]
   if { ![info exists no_format] || !$no_format } {
    set mom_sys_arr($gcode_var) [UI_PB_com_RetValByDataType \
    $mom_sys_arr($gcode_var) $data_type]
   }
   if { [info exists no_format] && $no_format } {
    UI_PB_formatGcodeData gcode_desc $page_obj $count add_name var $no_format
    } else {
    UI_PB_formatGcodeData gcode_desc $page_obj $count add_name var
   }
   if {![info exists positive]} { set positive 0 }
   bind $gcode_frm.$row_no.1_int <KeyPress>   "UI_PB_com_ValidateDataOfEntry %W %K $data_type $positive"
   bind $gcode_frm.$row_no.1_int <KeyRelease> "UI_PB_com_FormatCode %W $add_name mom_sys_arr $var"
   global gpb_addr_var paOption
   if { ![info exists gpb_addr_var($add_name,leader_name)] || [string match "" $gpb_addr_var($add_name,leader_name)] } {
    $gcode_frm.$row_no.2_int config -bg $paOption(table_bg)
    } else {
    $gcode_frm.$row_no.2_int config -bg $paOption(special_bg)
   }
   incr row_no
  }
  if { [info exists rest_gcode_var_value] } \
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
  global mom_sys_arr post_object
  array set gcode_vars $Page::($page_obj,g_codes_mom_var)
  PB_int_RetDefMOMVarValues gcode_vars def_gcode_value
  set no_gcodes [array size gcode_vars]
  array set gcode_desc $Post::($post_object,g_codes_desc)
  for {set count 0} { $count < $no_gcodes } { incr count} \
  {
   set mom_var $gcode_vars($count)
   set data_type [UI_PB_com_RetSysVarDataType mom_var]
   set mom_sys_arr($mom_var) [UI_PB_com_RetValByDataType \
   $def_gcode_value($mom_var) $data_type]
   set gPB($mom_var) $mom_sys_arr($mom_var)
   UI_PB_formatGcodeData gcode_desc $page_obj $count add_name var
  }
 }

#=======================================================================
proc UI_PB_gcd_RestoreCallBack { page_obj } {
  global mom_sys_arr
  global gPB post_object
  array set rest_gcode_var_value $Page::($page_obj,rest_gcode_var_value)
  array set gcode_vars $Page::($page_obj,g_codes_mom_var)
  array set gcode_desc $Post::($post_object,g_codes_desc)
  set no_gcodes [array size gcode_vars]
  for {set count 0} { $count < $no_gcodes } { incr count} \
  {
   set mom_var $gcode_vars($count)
   set data_type [UI_PB_com_RetSysVarDataType mom_var]
   set mom_sys_arr($mom_var) [UI_PB_com_RetValByDataType \
   $rest_gcode_var_value($mom_var) $data_type]
   set gPB($mom_var) $mom_sys_arr($mom_var)
   UI_PB_formatGcodeData gcode_desc $page_obj $count add_name var
  }
 }

#=======================================================================
proc UI_PB_gcd_ApplyGcodeData { book_obj page_obj } {
  global mom_sys_arr
  PB_int_UpdateMOMVar mom_sys_arr
 }
