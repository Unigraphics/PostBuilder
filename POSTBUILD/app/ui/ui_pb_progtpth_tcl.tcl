
#=======================================================================
proc UI_PB_ProgTpth { book_id prgtpth_page_obj } {
  global gPB
  set f [$book_id subwidget $Page::($prgtpth_page_obj,page_name)]
  set w [tixNoteBook $f.nb -ipadx 5 -ipady 5]
  [$w subwidget nbframe] config -tabpady 0
  set evnt_book [new Book w]
  set Page::($prgtpth_page_obj,book_obj) $evnt_book
  Book::CreatePage $evnt_book prog "$gPB(prog,tab,Label)" "" \
  UI_PB_ProgTpth_Program UI_PB_progtpth_ProgramTab
  Book::CreatePage $evnt_book gcod "$gPB(gcode,tab,Label)" "" \
  UI_PB_ProgTpth_Gcode UI_PB_progtpth_GcodeTab
  Book::CreatePage $evnt_book mcod "$gPB(mcode,tab,Label)" "" \
  UI_PB_ProgTpth_Mcode UI_PB_progtpth_McodeTab
  Book::CreatePage $evnt_book asum "$gPB(addrsum,tab,Label)" "" \
  UI_PB_ProgTpth_AddSum UI_PB_progtpth_AddsumTab
  Book::CreatePage $evnt_book wseq "$gPB(wseq,tab,Label)" "" \
  UI_PB_ProgTpth_WordSeq UI_PB_progtpth_WordSeqTab
  Book::CreatePage $evnt_book cust "$gPB(cust_cmd,tab,Label)" "" \
  UI_PB_ProgTpth_CustomCmd UI_PB_progtpth_CustCmdTab
  pack $f.nb -expand yes -fill both
  set Book::($evnt_book,x_def_tab_img) 0
  set Book::($evnt_book,current_tab) -1
 }

#=======================================================================
proc UI_PB_progtpth_ProgramTab {book_id page_img book_obj} {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_progtpth_ValidatePrevPageData book_obj] } \
  {
   return
  }
  UI_PB_progtpth_DeleteTabAtt book_obj
  set Book::($book_obj,current_tab) 0
  UI_PB_progtpth_CreateTabAttr book_obj
 }

#=======================================================================
proc UI_PB_progtpth_GcodeTab {book_id page_img book_obj} {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_progtpth_ValidatePrevPageData book_obj] } \
  {
   return
  }
  UI_PB_progtpth_DeleteTabAtt book_obj
  set Book::($book_obj,current_tab) 1
  UI_PB_progtpth_CreateTabAttr book_obj
 }

#=======================================================================
proc UI_PB_progtpth_McodeTab {book_id page_img book_obj} {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_progtpth_ValidatePrevPageData book_obj] } \
  {
   return
  }
  UI_PB_progtpth_DeleteTabAtt book_obj
  set Book::($book_obj,current_tab) 2
  UI_PB_progtpth_CreateTabAttr book_obj
 }

#=======================================================================
proc UI_PB_progtpth_AddsumTab {book_id page_img book_obj} {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_progtpth_ValidatePrevPageData book_obj] } \
  {
   return
  }
  UI_PB_progtpth_DeleteTabAtt book_obj
  set Book::($book_obj,current_tab) 3
  UI_PB_progtpth_CreateTabAttr book_obj
 }

#=======================================================================
proc UI_PB_progtpth_WordSeqTab {book_id page_img book_obj} {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_progtpth_ValidatePrevPageData book_obj] } \
  {
   return
  }
  UI_PB_progtpth_DeleteTabAtt book_obj
  set Book::($book_obj,current_tab) 4
  UI_PB_progtpth_CreateTabAttr book_obj
 }

#=======================================================================
proc UI_PB_progtpth_CustCmdTab {book_id page_img book_obj} {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_progtpth_ValidatePrevPageData book_obj] } \
  {
   return
  }
  UI_PB_progtpth_DeleteTabAtt book_obj
  set Book::($book_obj,current_tab) 5
  UI_PB_progtpth_CreateTabAttr book_obj
 }

#=======================================================================
proc UI_PB_progtpth_CreateTabAttr { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  global gPB
  switch -exact -- $Book::($book_obj,current_tab) \
  {
   0 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
    UI_PB_evt_GetSequenceIndex page_obj seq_index
    set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
    UI_PB_evt_RestoreSeqObjData seq_obj
    if { $seq_index == 0 || $seq_index == 1 || \
    $seq_index == 5 || $seq_index == 6 } \
    {
     UI_PB_evt_CreateMenuOptions page_obj seq_obj
    }
    UI_PB_evt_CreateSeqAttributes page_obj
    UI_PB_com_SetStatusbar "$gPB(prog,Status)"
   }
   1 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
    UI_PB_gcd_RestoreGcodeData $page_obj
    UI_PB_com_SetStatusbar "$gPB(gcode,Status)"
   }
   2 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
    UI_PB_mcd_RestoreMcodeData $page_obj
    UI_PB_com_SetStatusbar "$gPB(mcode,Status)"
   }
   3 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
    UI_PB_ads_TabAddrsumCreate page_obj
    UI_PB_com_SetStatusbar "$gPB(addrsum,Status)"
   }
   4 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 4]
    UI_PB_mseq_CreateMastSeqElements page_obj
    UI_PB_com_SetStatusbar "$gPB(wseq,Status)"
    global post_object
    set Post::($post_object,mseq_visited) 1
   }
   5 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 5]
    UI_PB_cmd_CmdTabCreate page_obj
    UI_PB_com_SetStatusbar "$gPB(cust_cmd,Status)"
   }
  }
 }

#=======================================================================
proc UI_PB_progtpth_ValidatePrevPageData { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  global gPB
  set raise_page 0
  set current_tab $Book::($book_obj,current_tab)
  set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
  switch -exact -- $current_tab \
  {
   3 { 
    set addrsum_err [UI_PB_ads_ValidateAllFormats]
    if $addrsum_err { set raise_page 1 }
   }
   5 { 
    if { [info exists Page::($page_obj,active_cmd_obj)] } \
    {
     global pb_cmd_procname
     set cmd_obj $Page::($page_obj,active_cmd_obj)
     set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
     set cust_page_flag [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name]
     if { $cust_page_flag } \
     {
      set raise_page 1
     }
     set cc_res 1
     set cc_res [ UI_PB_cmd_SaveCmdProc_ret_msg $page_obj cc_err_msg ]
     if { $cc_res != 1 } \
     {
      set raise_page 1
     }
     if 0 {
      set res [ UI_PB_cmd_SaveCmdProc_ret_msg $page_obj cc_err_msg ]
      if { $res == 0 } \
      {
       set raise_page 1
       } elseif { $res == -1 } \
      {
       set res [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
       -type yesno -icon warning \
       -message "$cc_err_msg"]
       if { $res == "no" } \
       {
        set raise_page 1
       }
       unset cc_err_msg
      }
     }
    }
    if { !$raise_page } \
    {
     set Page::($page_obj,selected_index) -1
    }
   }
  }
  if { $raise_page } \
  {
   set book_id $Book::($book_obj,book_id)
   set cur_page_name [$book_id raised]

#=======================================================================
set cur_cmd_proc [$book_id pagecget $cur_page_name -raisecmd]
 set cur_page_img [$book_id pagecget $cur_page_name -image]
 set prev_page_name $Page::($page_obj,page_name)

#=======================================================================
set prev_cmd_proc [$book_id pagecget $prev_page_name -raisecmd]
 set prev_page_img [$book_id pagecget $prev_page_name -image]
 set Book::($book_obj,x_def_tab_img) $cur_page_img
 $book_id pageconfigure $prev_page_name \
 -raisecmd "CB_nb_def $book_id $prev_page_img $book_obj"
 $book_id raise $prev_page_name
 switch -exact -- $current_tab \
 {
  3 {
   if { [info exists addrsum_err] && $addrsum_err } {
    UI_PB_ads_DisplayErrorMessage $addrsum_err
   }
  }
  5 {
   if { $cc_res == 0 } \
   {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
    -type ok -icon error \
    -title "$gPB(cust_cmd,error,title)" \
    -message "$cc_err_msg"
    } elseif { $cc_res == -1 } \
   {
    set res [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
    -type yesno -icon warning \
    -title "$gPB(cust_cmd,error,title)" \
    -message "$cc_err_msg" ]
    if { $res == "yes" } \
    {
     PB_file_AssumeUnknownCommandsInProc
     PB_file_AssumeUnknownDefElemsInProc
     if [info exists Page::($page_obj,active_cmd_obj)] \
     {
      set cmd_obj $Page::($page_obj,active_cmd_obj)
      UI_PB_cmd_GetProcFromTextWin $page_obj proc_text
      set command::($cmd_obj,proc) $proc_text
     }
     set Book::($book_obj,x_def_tab_img) $prev_page_img
     $book_id pageconfigure $cur_page_name \
     -raisecmd "CB_nb_def $book_id $cur_page_img $book_obj"
     $book_id raise $cur_page_name
     $book_id pageconfigure $cur_page_name -raisecmd "$cur_cmd_proc"
     $book_id pageconfigure $prev_page_name -raisecmd "$prev_cmd_proc"
     set Page::($page_obj,selected_index) -1
     return 0
    }
   }
  }
 }
 $book_id raise $prev_page_name
 $book_id pageconfigure $prev_page_name -raisecmd "$prev_cmd_proc"
 switch $cur_page_name \
 {
  "prog"  { set new_tab 0 }
  "gcod"  { set new_tab 1 }
  "mcod"  { set new_tab 2 }
  "asum"  { set new_tab 3 }
  "wseq"  { set new_tab 4 }
  "cust"  { set new_tab 5 }
  default { set new_tab 0 }
 }
 set Book::($book_obj,current_tab) $new_tab
 UI_PB_progtpth_CreateTabAttr book_obj
 set Book::($book_obj,current_tab) $current_tab
}
return $raise_page
}

#=======================================================================
proc UI_PB_progtpth_DeleteTabAtt { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  switch -exact -- $Book::($book_obj,current_tab) \
  {
   0 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
    UI_PB_evt_DeleteObjectsPrevSeq page_obj
    UI_PB_evt_DeleteApplyEvtElemsOfSeq page_obj
   }
   1 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
    UI_PB_gcd_ApplyGcodeData $book_obj $page_obj
   }
   2 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
    UI_PB_mcd_ApplyMcodeData $book_obj $page_obj
   }
   3 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
    UI_PB_ads_UpdateAddressObjects
   }
   4 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 4]
    UI_PB_mseq_ApplyMastSeq page_obj
    UI_PB_mseq_DeleteMastSeqElems page_obj
   }
   5 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 5]
    UI_PB_cmd_CmdTabDelete page_obj
   }
  }
 }
