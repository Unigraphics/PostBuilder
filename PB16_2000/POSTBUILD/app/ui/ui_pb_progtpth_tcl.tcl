#22

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
  set raise_page 0
  switch -exact -- $Book::($book_obj,current_tab) \
  {
   5 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 5]
    if { [info exists Page::($page_obj,active_cmd_obj)] } \
    {
     global pb_cmd_procname
     set cmd_obj $Page::($page_obj,active_cmd_obj)
     set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
     if { [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name] } \
     {
      set raise_page 1
     }
    }
   }
  }
  if { $raise_page } \
  {
   set book_id $Book::($book_obj,book_id)
   set cur_page_name [$book_id raised]
   set cur_page_img [$book_id pagecget $cur_page_name -image]
   set prev_page_name $Page::($page_obj,page_name)

#=======================================================================
set cmd_proc [$book_id pagecget $prev_page_name -raisecmd]
 set prev_page_img [$book_id pagecget $prev_page_name -image]
 set Book::($book_obj,x_def_tab_img) $cur_page_img
 $book_id pageconfigure $prev_page_name \
 -raisecmd "CB_nb_def $book_id $prev_page_img $book_obj"
 $book_id raise $prev_page_name
 switch -exact -- $Book::($book_obj,current_tab) \
 {
  5 {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
   -icon error -message "Command \"$cur_cmd_name\" \
   exists, Use another name."
  }
 }
 $book_id raise $prev_page_name
 $book_id pageconfigure $prev_page_name -raisecmd "$cmd_proc"
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
