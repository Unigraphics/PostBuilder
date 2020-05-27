
#=======================================================================
proc UI_PB_Def_OtherElements {book_id other_page_obj} {
  global tixOption
  global paOption
  set Page::($other_page_obj,page_id) [$book_id subwidget \
  $Page::($other_page_obj,page_name)]
  set w [$book_id subwidget $Page::($other_page_obj,page_name)]
  AddPageGenParm $other_page_obj $w 0
 }

#=======================================================================
proc AddPageGenParm {page_obj p e} {
  global tixOption
  global paOption
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) "UI_PB_oth_DefaultCallBack"
  set cb_arr(gPB(nav_button,restore,Label)) "UI_PB_oth_RestCallBack $page_obj"
  set b [frame $p.b]
  pack $b -side bottom -fill x -padx 3
  UI_PB_com_CreateButtonBox $b label_list cb_arr
  UI_PB_mthd_CreateScrollWindow $p othparm win y
  set f [frame $win.f]
  pack $f -expand yes -fill both
  UI_PB_ads_CreateSpecialChars page_obj $f
 }

#=======================================================================
proc UI_PB_oth_DefaultCallBack { } {
  UI_PB_ads_SpecDefaultCallBack
 }

#=======================================================================
proc UI_PB_oth_RestCallBack { page_obj } {
  UI_PB_ads_SpecRestCallBack $page_obj
 }

#=======================================================================
proc UI_PB_oth_UpdateOtherPage { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr
  set mom_var_list {"seqnum_start" "seqnum_incr" "seqnum_freq" "seqnum_max" \
   "\$mom_sys_gcodes_per_block" "\$mom_sys_mcodes_per_block" \
   "\$mom_sys_opskip_block_leader" "Word_Seperator" \
  "End_of_Block" "Comment_Start" "Comment_End"}
  if [PB_is_v 3.1] {
   if 0 {
    lappend mom_var_list "Include_UDE" "UDE_File_Name"
    lappend mom_var_list "Inherit_UDE" "PST_File_Name" "PST_File_Folder"
   } ;#end if 0
   lappend mom_var_list "Include_UDE" "Inherit_UDE"
   if {$::env(PB_UDE_ENABLED) == 1} {
    lappend mom_var_list "Own_UDE" "OWN_CDL_File_Folder"
   }
   global ads_cdl_arr
   set cdl_type_list [list $ads_cdl_arr(type_other) $ads_cdl_arr(type_inherit)]
   foreach cdl_type $cdl_type_list {
    set ads_cdl_arr($cdl_type,rest_cdl_list) $ads_cdl_arr($cdl_type,cdl_list)
   }
  }
  foreach var $mom_var_list \
  {
   set rest_spec_momvar($var) $mom_sys_arr($var)
  }
  set Page::($page_obj,rest_spec_momvar) [array get rest_spec_momvar]
 }

#=======================================================================
proc UI_PB_oth_ApplyOtherAttr { } {
  global mom_sys_arr
  global special_char
  set mom_var_list {"Word_Seperator" "End_of_Block" \
  "Comment_Start" "Comment_End"}
  foreach option $mom_var_list \
  {
   set mom_sys_arr($option) $special_char($option,char)
  }
  PB_int_UpdateMOMVar mom_sys_arr
 }
