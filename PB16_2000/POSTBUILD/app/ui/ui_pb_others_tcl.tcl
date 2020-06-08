#12

#=======================================================================
proc UI_PB_Def_OtherElements {book_id other_page_obj} {
  global tixOption
  global paOption
  set w [$book_id subwidget $Page::($other_page_obj,page_name)]
  AddPageGenParm $other_page_obj $w 0
 }

#=======================================================================
proc AddPageGenParm {page_obj p e} {
  global tixOption
  global paOption
  set f [frame $p.f -relief sunken -bd 1]
  pack $f -expand yes -fill both -padx 3
  UI_PB_ads_CreateSpecialChars page_obj $f
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) "UI_PB_oth_DefaultCallBack"
  set cb_arr(gPB(nav_button,restore,Label)) "UI_PB_oth_RestCallBack $page_obj"
  UI_PB_com_CreateButtonBox $p label_list cb_arr
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
  set mom_var_list {"seqnum_start" "seqnum_incr" "seqnum_freq" \
   "\$mom_sys_gcodes_per_block" "\$mom_sys_mcodes_per_block" \
   "Word_Seperator" "End_of_Block" \
  "Comment_Start" "Comment_End"}
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
  set mom_var_list {"Word_Seperator" "End_of_Block" "Comment_Start" \
  "Comment_End"}
  foreach option $mom_var_list \
  {
   set mom_sys_arr($option) $special_char($option,char)
  }
  PB_int_UpdateMOMVar mom_sys_arr
 }