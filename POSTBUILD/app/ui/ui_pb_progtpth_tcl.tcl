
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
  if { ![PB_file_is_JE_POST_DEV] } {
   if { [PB_is_v3] >= 0 } {
    Book::CreatePage $evnt_book link "$gPB(link_post,tab,Label)" "" \
    UI_PB_ProgTpth_LinkPost UI_PB_progtpth_LinkPostTab
   }
   } else {
   Book::CreatePage $evnt_book link "" "" "" ""
   $Book::($evnt_book,book_id) pageconfigure link -state disabled
  }
  Book::CreatePage $evnt_book func "$gPB(func,tab,Label)" "" \
  UI_PB_ProgTpth_FunctionCall UI_PB_progtpth_FunctionCallTab
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
  if ![string compare $::tix_version 8.4] {
   bind .widget.main <MouseWheel> {
    .widget.main.nb.nbframe.pro.nb.nbframe.gcod.top.sf yview scroll [expr {- (%D / 120) * 1}] units
   }
  }
  if { [UI_PB_progtpth_ValidatePrevPageData book_obj 1] } \
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
  if ![string compare $::tix_version 8.4] {
   bind .widget.main <MouseWheel> {
    .widget.main.nb.nbframe.pro.nb.nbframe.mcod.top.sf yview scroll [expr {- (%D / 120) * 1}] units
   }
  }
  if { [UI_PB_progtpth_ValidatePrevPageData book_obj 2] } \
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
  if ![catch { UI_PB_progtpth_CreateTabAttr book_obj }] {
   if 0 {
    global mom_sys_arr
    if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) > 0 } {
     global gPB
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -title "$gPB(msg,dialog,title)"\
     -icon warning -message "Do not rename or remove any PB_CMD_vnc command,\n\
     unless you are certain what the consequences are!"
    }
   }
  }
 }

#=======================================================================
proc UI_PB_progtpth_FunctionCallTab {book_id page_img book_obj} {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_progtpth_ValidatePrevPageData book_obj] } \
  {
   return
  }
  UI_PB_progtpth_DeleteTabAtt book_obj
  set Book::($book_obj,current_tab) 7
  UI_PB_progtpth_CreateTabAttr book_obj
 }

#=======================================================================
proc UI_PB_ProgTpth_LinkPost { book_id page_obj } {
  global tixOption
  global paOption
  global gPB
  global mom_sys_arr
  PB_int_RetSequenceObjs seq_obj_list
  set seq_obj [lindex $seq_obj_list 8]
  set Page::($page_obj,seq_obj) $seq_obj
  set sequence::($seq_obj,ude_flag) 1
  if { ![info exists mom_sys_arr(\$is_linked_post)] } {
   set mom_sys_arr(\$is_linked_post) 0
  }
  set Page::($page_obj,page_id) [$book_id subwidget $Page::($page_obj,page_name)]
  set page_id $Page::($page_obj,page_id)
  set linked_posts [UI_PB_lnk_SetLinkedPostsForHList]
  checkbutton $page_id.master -text "$gPB(link_post,toggle,Label)" \
  -fg $paOption(special_fg) \
  -bg $paOption(header_bg) \
  -variable mom_sys_arr(\$is_linked_post) \
  -relief solid -bd 1 \
  -font $tixOption(bold_font) \
  -anchor w -padx 10 -pady 7 ;#<03-31-03 gsl> 7 was 10.
  if ![string compare $::tix_version 8.4] {
   $page_id.master configure -activebackground $paOption(header_bg) \
   -activeforeground $paOption(special_fg)
  }
  pack $page_id.master -side top -anchor c -pady 10
  set gPB(c_help,$page_id.master)  "link_post,toggle"
  set top_frm [frame $page_id.top -relief sunken -bd 1]
  set list_frm [tixScrolledHList $top_frm.list -scrollbar both -options {
   hlist.columns 2
   hlist.header  true
  }]
  if ![string compare $::tix_version 8.4] {
   $list_frm config -highlightthickness 0
  }
  set hlist [$list_frm subwidget hlist]
  set Page::($page_obj,hlist) $hlist
  set butt_frm [frame $top_frm.butt -relief flat]
  set Page::($page_obj,butt_win) $butt_frm
  $hlist config -command "__EditALinkedPost edit"
  pack $butt_frm -side right -fill y -padx 5 -pady 5
  pack $list_frm -side left  -fill both -expand yes -padx 5 -pady 5
  set new [button $butt_frm.new -text $gPB(link_post,new,Label) \
  -bg $paOption(app_butt_bg) \
  -command "__EditALinkedPost new"]
  set edt [button $butt_frm.edt -text $gPB(link_post,edit,Label) \
  -bg $paOption(app_butt_bg) \
  -command "__EditALinkedPost edit"]
  set del [button $butt_frm.del -text $gPB(link_post,delete,Label) \
  -bg $paOption(app_butt_bg) \
  -command "__EditALinkedPost del"]
  pack $new $edt $del -fill x -pady 3
  set gPB(c_help,$new)  "link_post,new"
  set gPB(c_help,$edt)  "link_post,edit"
  set gPB(c_help,$del)  "link_post,delete"
  $hlist config -browsecmd "__lnk_BrowseALinkedPost $page_obj"
  set style(header) [tixDisplayStyle text -refwindow $hlist \
  -fg $paOption(title_fg) -padx 10 \
  -font [tix option get bold_font]]
  $hlist header create 0 -itemtype text -text "$gPB(link_post,head,Label)" \
  -style $style(header) \
  -headerbackground $paOption(title_bg)
  $hlist header create 1 -itemtype text -text "$gPB(link_post,post,Label)" \
  -style $style(header) \
  -headerbackground $paOption(title_bg)
  set gPB(c_help,$hlist)  "link_post,link"
  $hlist config -separator "." -drawbranch 0 -indent 0
  $hlist column width 0 -char 25
  switch $::tix_version {
   8.4 {
    frame $hlist.sep -bd 0 -height 1 -width 10 -relief flat -bg gray76
    $hlist add . -itemtype window -window $hlist.sep -state disabled
   }
   4.1 {
    $hlist add . -itemtype text -state disabled
   }
  }
  [$list_frm subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  [$list_frm subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  set Page::($page_obj,is_linked_post)    $mom_sys_arr(\$is_linked_post)
  set Page::($page_obj,linked_posts_list) [__lnk_FetchLinkedPostsList $hlist]
  set Page::($page_obj,list_win) $top_frm
  set act_frm [frame $page_id.actfm]
  __lnk_CreateActionButtons $act_frm $page_obj
  pack $act_frm -side bottom -fill x
  pack $top_frm -side top -fill both -expand yes -pady 20 -padx 50
  $page_id.master config -command "__lnk_ToggleLinkedPostList $page_obj"
 }

#=======================================================================
proc __lnk_AttachLinkedPostCB { page_obj args } {
  global post_object
  set hlist $Page::($page_obj,hlist)
  $hlist config -command   "__EditALinkedPost edit"
  $hlist config -browsecmd "__lnk_BrowseALinkedPost $page_obj"
  set win $Page::($page_obj,list_win)
  $win.butt.new config -command "__EditALinkedPost new"
  $win.butt.edt config -command "__EditALinkedPost edit"
  $win.butt.del config -command "__EditALinkedPost del"
 }

#=======================================================================
proc __lnk_SetRestoreData { args } {
  global post_object
  global mom_sys_arr
  set page_obj [UI_PB_com_GetCurrentTabPageObj]
  set page_id $Page::($page_obj,page_id)
  if [winfo exists $page_id.master] {
   $page_id.master config -state normal
   array set def_mom_sys_arr $Post::($post_object,def_mom_sys_var_list)
   if { [info exists mom_sys_arr(\$mom_sys_mill_turn_type)] && \
    [string match "SIMPLE_MILL_TURN" $mom_sys_arr(\$mom_sys_mill_turn_type)] } {
    if { ![info exists Page::($page_obj,XZC_is_linked_post)] } {
     set Page::($page_obj,XZC_is_linked_post)    $mom_sys_arr(\$is_linked_post)
     set Page::($page_obj,XZC_linked_posts_list) $mom_sys_arr(\$linked_posts_list)
    }
    set mom_sys_arr(\$is_linked_post) 1
    set post [list]
    lappend post 0  "MILL"  "this_post"
    lappend linked_posts $post
    set post [list]
    lappend post 1  "TURN"  "$mom_sys_arr(\$mom_sys_lathe_postname)"
    lappend linked_posts $post
    set mom_sys_arr(\$linked_posts_list) [list]
    lappend mom_sys_arr(\$linked_posts_list)  "\{MILL\} \{this_post\}"
    lappend mom_sys_arr(\$linked_posts_list)  "\{TURN\} \{$mom_sys_arr(\$mom_sys_lathe_postname)\}"
    PB_int_UpdateMOMVar mom_sys_arr ;# This is sort of part-conversion!
    if { ![info exists Page::($page_obj,XZC_def_is_linked_post)] } {
     set Page::($page_obj,XZC_def_is_linked_post)    $def_mom_sys_arr(\$is_linked_post)
     set Page::($page_obj,XZC_def_linked_posts_list) $def_mom_sys_arr(\$linked_posts_list)
     set Page::($page_obj,XZC_def_lathe_postname)    $def_mom_sys_arr(\$mom_sys_lathe_postname)
    }
    if { ![info exists Page::($page_obj,SMT_def_is_linked_post)] } {
     set Page::($page_obj,SMT_def_is_linked_post)    $mom_sys_arr(\$is_linked_post)
     set Page::($page_obj,SMT_def_linked_posts_list) $mom_sys_arr(\$linked_posts_list)
     set Page::($page_obj,SMT_def_lathe_postname)    $def_mom_sys_arr(\$mom_sys_lathe_postname)
    }
    set def_mom_sys_arr(\$is_linked_post)         $Page::($page_obj,SMT_def_is_linked_post)
    set def_mom_sys_arr(\$linked_posts_list)      $Page::($page_obj,SMT_def_linked_posts_list)
    set def_mom_sys_arr(\$mom_sys_lathe_postname) $Page::($page_obj,SMT_def_lathe_postname)
    $page_id.master config -state disabled
    } elseif [info exists Page::($page_obj,XZC_is_linked_post)] {
    set mom_sys_arr(\$is_linked_post)    $Page::($page_obj,XZC_is_linked_post)
    set mom_sys_arr(\$linked_posts_list) $Page::($page_obj,XZC_linked_posts_list)
    unset Page::($page_obj,XZC_is_linked_post)
    unset Page::($page_obj,XZC_linked_posts_list)
    set def_mom_sys_arr(\$is_linked_post)    $Page::($page_obj,XZC_def_is_linked_post)
    set def_mom_sys_arr(\$linked_posts_list) $Page::($page_obj,XZC_def_linked_posts_list)
   }
   set Post::($post_object,def_mom_sys_var_list) [array get def_mom_sys_arr]
  }
  __lnk_FillLinkedPostsHList $page_obj
  __lnk_ToggleLinkedPostList $page_obj
  set Page::($page_obj,is_linked_post)    $mom_sys_arr(\$is_linked_post)
  set Page::($page_obj,linked_posts_list) [__lnk_FetchLinkedPostsList $Page::($page_obj,hlist)]
  if [info exists mom_sys_arr(\$mom_sys_lathe_postname)] {
   set Page::($page_obj,lathe_postname)    $mom_sys_arr(\$mom_sys_lathe_postname)
  }
  PB_int_RetSequenceObjs seq_obj_list
  set seq_obj [lindex $seq_obj_list 8]
  sequence::RestoreValue $seq_obj
  array set rest_seq_obj_attr $sequence::($seq_obj,rest_value)
  set rest_evt_obj_list $rest_seq_obj_attr(1)
  foreach evt_obj $rest_evt_obj_list {
   event::RestoreValue $evt_obj
   array set rest_evt_obj_attr $event::($evt_obj,rest_value)
   set rest_evt_elem_obj_list $rest_evt_obj_attr(2)
   foreach evt_elem_obj $rest_evt_elem_obj_list {
    event_element::RestoreValue $evt_elem_obj
    array set rest_evt_elem_obj_attr $event_element::($evt_elem_obj,rest_value)
   }
  }
 }

#=======================================================================
proc __lnk_DefaultData { args } {
  PB_int_RetSequenceObjs seq_obj_list
  set seq_obj [lindex $seq_obj_list 8]
  array set def_seq_obj_attr $sequence::($seq_obj,def_value)
  set def_evt_obj_list $def_seq_obj_attr(1)
  foreach evt_obj $def_evt_obj_list {
   array set def_evt_obj_attr $event::($evt_obj,def_value)
   set def_evt_elem_obj_list $def_evt_obj_attr(2)
   foreach evt_elem_obj $def_evt_elem_obj_list {
    if [info exists event_element::($evt_elem_obj,def_value)] {
     array set evt_elem_obj_attr $event_element::($evt_elem_obj,def_value)
     event_element::setvalue $evt_elem_obj evt_elem_obj_attr
     } else {
     event_element::readvalue    $evt_elem_obj evt_elem_obj_attr
     event_element::DefaultValue $evt_elem_obj evt_elem_obj_attr
    }
   }
   event::setvalue $evt_obj def_evt_obj_attr
  }
  sequence::setvalue $seq_obj def_seq_obj_attr
 }

#=======================================================================
proc __lnk_RestoreData { args } {
  PB_int_RetSequenceObjs seq_obj_list
  set seq_obj [lindex $seq_obj_list 8]
  global mom_sys_arr
  set delete_all_evt_elem 0
  if { $mom_sys_arr(\$is_linked_post) == 0 } {
   if [string match "" [lindex [lindex $mom_sys_arr(\$linked_posts_list) 0] 0]] {
    set delete_all_evt_elem 1
   }
  }
  sequence::readvalue $seq_obj seq_attr
  set evt_obj_list $seq_attr(1)
  foreach evt_obj $evt_obj_list {
   __lnk_CleanUpEventData evt_obj evt_obj_list seq_obj $delete_all_evt_elem
  }
  array set rest_seq_obj_attr $sequence::($seq_obj,rest_value)
  set rest_evt_obj_list $rest_seq_obj_attr(1)
  foreach evt_obj $rest_evt_obj_list {
   array set rest_evt_obj_attr $event::($evt_obj,rest_value)
   set rest_evt_elem_obj_list $rest_evt_obj_attr(2)
   foreach evt_elem_obj $rest_evt_elem_obj_list {
    array set evt_elem_obj_attr $event_element::($evt_elem_obj,rest_value)
    event_element::setvalue $evt_elem_obj evt_elem_obj_attr
   }
   event::setvalue $evt_obj rest_evt_obj_attr
  }
  sequence::setvalue $seq_obj rest_seq_obj_attr
 }

#=======================================================================
proc __lnk_CleanUpEventData { EVT_OBJ EVT_OBJ_LIST SEQ_OBJ delete_all_evt_elem args } {
  upvar $EVT_OBJ      evt_obj
  upvar $EVT_OBJ_LIST evt_obj_list
  upvar $SEQ_OBJ      seq_obj
  array set def_seq_attr $sequence::($seq_obj,def_value)
  set def_evt_obj_list $def_seq_attr(1)
  array set res_seq_attr $sequence::($seq_obj,rest_value)
  set res_evt_obj_list $res_seq_attr(1)
  sequence::readvalue $seq_obj seq_attr
  if { [llength $event::($evt_obj,rest_value)] > 0 } {
   array set res_evt_attr $event::($evt_obj,rest_value)
   set res_evt_elem_list $res_evt_attr(2)
   } else {
   set res_evt_elem_list [list]
  }
  array set def_evt_attr $event::($evt_obj,def_value)
  set def_evt_elem_list $def_evt_attr(2)
  event::readvalue $evt_obj evt_attr
  set evt_elem_list $evt_attr(2)
  if { [lsearch $res_evt_obj_list $evt_obj] < 0  && \
   [lsearch $def_evt_obj_list $evt_obj] < 0 } {
   foreach evt_elem $res_evt_elem_list {
    __lnk_DeleteEventElem $evt_elem
    set index [lsearch $def_evt_elem_list $evt_elem]
    set def_evt_elem_list [lreplace $def_evt_elem_list $index $index]
    set index [lsearch $evt_elem_list $evt_elem]
    set evt_elem_list [lreplace $evt_elem_list $index $index]
   }
   foreach evt_elem $def_evt_elem_list {
    __lnk_DeleteEventElem $evt_elem
    set index [lsearch $evt_elem_list $evt_elem]
    set evt_elem_list [lreplace $evt_elem_list $index $index]
   }
   foreach evt_elem $evt_elem_list {
    __lnk_DeleteEventElem $evt_elem
   }
   set evt_attr(2) [list]
   event::setvalue $evt_obj evt_attr
   PB_com_DeleteObject $evt_obj
   set index [lsearch $evt_obj_list $evt_obj]
   set evt_obj_list [lreplace $evt_obj_list $index $index]
   set seq_attr(1) $evt_obj_list
   sequence::setvalue $seq_obj seq_attr
   } else {
   foreach evt_elem $evt_elem_list {
    if $delete_all_evt_elem {
     __lnk_DeleteEventElem $evt_elem
     } else {
     if { [lsearch $res_evt_elem_list $evt_elem] < 0  && \
      [lsearch $def_evt_elem_list $evt_elem] < 0 } {
      __lnk_DeleteEventElem $evt_elem
     }
    }
   }
  }
 }

#=======================================================================
proc UI_PB_lnk_SetLinkedPostsForHList { args } {
  global mom_sys_arr
  set linked_posts [list]
  if [info exists mom_sys_arr(\$linked_posts_list)] {
   set posts_list $mom_sys_arr(\$linked_posts_list)
   set ip 0
   foreach p $posts_list {
    set post [list]
    lappend post $ip
    foreach e $p {
     lappend post $e
    }
    lappend linked_posts $post
    incr ip
   }
   } else {
   set linked_posts {
    {0  ""  "this_post"}
   }
   set mom_sys_arr(\$linked_posts_list) [list]
   lappend mom_sys_arr(\$linked_posts_list)  "\{\} \{this_post\}"
   PB_int_UpdateMOMVar mom_sys_arr ;# This is sort of part-conversion!
  }
  return $linked_posts
 }

#=======================================================================
proc __lnk_FillLinkedPostsHList { page_obj args } {
  set hlist $Page::($page_obj,hlist)
  set style(this_post)  [tixDisplayStyle text -refwindow $hlist \
  -fg yellow -bg brown \
  -padx 10 -font [tix option get italic_font]]
  set style(post)       [tixDisplayStyle text -refwindow $hlist \
  -padx 10 -font [tix option get bold_font]]
  set sel  [$hlist info selection]
  set ents [$hlist info children .]
  foreach e $ents {
   $hlist delete entry $e
  }
  set linked_posts [UI_PB_lnk_SetLinkedPostsForHList]
  set idx 0
  foreach post $linked_posts {
   set head_name [lindex $post 1]
   set post_name [lindex $post 2]
   set row [$hlist add .[lindex $post 0] -itemtype text \
   -text $head_name -style $style(post) -data $post]
   if { $idx == 0 } {
    $hlist item create $row 1 -itemtype text \
    -text $post_name -style $style(this_post)
    } else {
    $hlist item create $row 1 -itemtype text \
    -text $post_name -style $style(post)
   }
   incr idx
  }
  set ents [$hlist info children .]
  if { [lsearch $ents $sel] < 0 } {
   set sel .0
  }
  $hlist selection set $sel
  $hlist anchor set $sel
 }

#=======================================================================
proc __lnk_FetchLinkedPostsList { hlist args } {
  set ents [$hlist info children .]
  set linked_posts_list [list]
  foreach item $ents {
   set sel [$hlist info data $item]
   set head [lindex $sel 1]
   set post [lindex $sel 2]
   lappend linked_posts_list "\{$head\} \{$post\}"
  }
  return $linked_posts_list
 }

#=======================================================================
proc __lnk_ToggleLinkedPostList { page_obj args } {
  global mom_sys_arr
  set win $Page::($page_obj,list_win)
  UI_PB_com_EnableWindow $win
  if { $mom_sys_arr(\$is_linked_post) == 1 } {
   set hlist $Page::($page_obj,hlist)
   set sel [$hlist info selection]
   set sel [$hlist info data $sel]
   set head_text [lindex $sel 1]
   if { $head_text == "" } {
    __EditALinkedPost edit
    tkwait window [UI_PB_com_AskActiveWindow]
    set sel [$hlist info selection]
    set sel [$hlist info data $sel]
    set head_text [lindex $sel 1]
    if { $head_text == "" } {
     set mom_sys_arr(\$is_linked_post) 0
     UI_PB_com_DisableWindow $win
     return
    }
   }
   if { [info exists mom_sys_arr(\$mom_sys_mill_turn_type)] && \
    [string match "SIMPLE_MILL_TURN" $mom_sys_arr(\$mom_sys_mill_turn_type)] } {
    $Page::($page_obj,butt_win).new config -state disabled
    $Page::($page_obj,butt_win).del config -state disabled
    } else {
    $Page::($page_obj,butt_win).new config -state normal
    $Page::($page_obj,butt_win).del config -state normal
   }
   } else {
   UI_PB_com_DisableWindow $win
   return
  }
  __lnk_AttachLinkedPostCB $page_obj
  __lnk_BrowseALinkedPost $page_obj
 }

#=======================================================================
proc __lnk_BrowseALinkedPost { page_obj args } {
  global mom_sys_arr
  if { $mom_sys_arr(\$is_linked_post) == 1 } {
   if ![string compare $::tix_version 8.4] {
    global gPB
    set parent_page_id [lindex $Book::($gPB(book),page_obj_list) \
    $Book::($gPB(book),current_tab)]
    set parent_book_id $Page::($parent_page_id,book_obj)
    set num_page [llength $Book::($parent_book_id,page_obj_list)]
    set page_obj [lindex $Book::($parent_book_id,page_obj_list) [expr $num_page - 2]]
   }
   set hlist $Page::($page_obj,hlist)
   set sel [$hlist info selection]
   $Page::($page_obj,butt_win).new config -state normal
   $Page::($page_obj,butt_win).edt config -state normal
   if { ![string compare ".0" $sel] } {
    $Page::($page_obj,butt_win).del config -state disabled
    } else {
    $Page::($page_obj,butt_win).del config -state normal
   }
   } else {
   $Page::($page_obj,butt_win).new config -state disabled
   $Page::($page_obj,butt_win).edt config -state disabled
   $Page::($page_obj,butt_win).del config -state disabled
  }
  global gPB LicInfo
  if { [info exists LicInfo(SITE_ID_IS_OK_FOR_PT)] } {
   if { ![string compare $gPB(PB_LICENSE) "UG_POST_AUTHOR"] && $LicInfo(SITE_ID_IS_OK_FOR_PT) == 0 } {
    if {[lsearch $gPB(lic_list) $LicInfo(post_license)] >= 0} {
     $Page::($page_obj,page_id).master config -state disabled
     $Page::($page_obj,butt_win).new   config -state disabled
     $Page::($page_obj,butt_win).del   config -state disabled
    }
   }
  }
 }

#=======================================================================
proc __EditALinkedPost { flag args } {
  global tixOption
  global paOption
  global gPB
  set page_obj [UI_PB_com_GetCurrentTabPageObj]
  set hlist $Page::($page_obj,hlist)
  set sel [$hlist info selection]
  set sel_data [$hlist info data $sel]
  set cur_index [lindex $sel_data 0]
  set head_text [lindex $sel_data 1]
  set post_text [lindex $sel_data 2]
  set seq_obj $Page::($page_obj,seq_obj)
  sequence::readvalue $seq_obj seq_obj_attr
  set evt_obj_list $seq_obj_attr(1)
  if [string match "del" $flag] {
   if [string match ".0" $sel] {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
    -icon error -message "You may not delete this link!"
    } else {
    set evt_name "start_of_HEAD__$head_text"
    set evt_obj -1
    PB_com_RetObjFrmName evt_name evt_obj_list evt_obj
    if { $evt_obj > 0 } {
     __lnk_CleanUpEventData evt_obj evt_obj_list seq_obj 1
    }
    set evt_name "end_of_HEAD__$head_text"
    set evt_obj -1
    PB_com_RetObjFrmName evt_name evt_obj_list evt_obj
    if { $evt_obj > 0 } {
     __lnk_CleanUpEventData evt_obj evt_obj_list seq_obj 1
    }
    set prev [$hlist info prev $sel]
    $hlist delete entry $sel
    $hlist selection set $prev
    $hlist anchor set $prev
    __lnk_BrowseALinkedPost $page_obj
   }
   return
  }
  set head_state normal
  set post_state normal
  set head_bg $paOption(special_fg)
  set post_bg $paOption(special_fg)
  if [string match "edit" $flag] {
   if [string match ".0" $sel] {
    set post_state disabled
    set post_bg $paOption(entry_disabled_bg)
   }
   } else {
   set cur_index -1
   set head_text ""
   set post_text ""
  }
  global mom_sys_arr
  if { [info exists mom_sys_arr(\$mom_sys_mill_turn_type)] && \
   [string match "SIMPLE_MILL_TURN" $mom_sys_arr(\$mom_sys_mill_turn_type)] } {
   if [string match ".0" $sel] {
    set head_state disabled
    set post_state disabled
    set head_bg $paOption(entry_disabled_bg)
    set post_bg $paOption(entry_disabled_bg)
    } else {
    set head_state disabled
    set head_bg $paOption(entry_disabled_bg)
   }
  }
  set win [toplevel [UI_PB_com_AskActiveWindow].link_post]
  set title "$gPB(link_post,dlg,title,Label)"
  UI_PB_com_CreateTransientWindow $win "$title" "" "" "" \
  "" ""
  set frm [frame $win.frm -relief flat]
  pack $frm -side top -fill x -expand yes -padx 3 -pady 3
  label  $frm.head_lbl -text "$gPB(link_post,dlg,head,Label) " -justify left -font $tixOption(bold_font)
  entry  $frm.head_ent -width 25 -relief sunken -textvar head_text
  $frm.head_ent delete 0 end
  $frm.head_ent insert 0 $head_text
  $frm.head_ent config -state $head_state -bg $head_bg
  grid   $frm.head_lbl $frm.head_ent - - - -sticky ew -padx 3 -pady 3
  label  $frm.post_lbl -text "$gPB(link_post,dlg,post,Label) " -justify left -font $tixOption(bold_font)
  entry  $frm.post_ent -width 25 -relief sunken -textvar post_text
  $frm.post_ent delete 0 end
  $frm.post_ent insert 0 $post_text
  $frm.post_ent config -state $post_state -bg $post_bg
  button $frm.post_but -text "$gPB(link_post,select_name,Label)" \
  -command "__lnk_SelectPost $frm.post_ent" -state $post_state
  grid   $frm.post_lbl $frm.post_ent - - $frm.post_but -sticky ew -padx 3 -pady 3
  set gPB(c_help,$frm.head_ent) "link_post,head"
  set gPB(c_help,$frm.post_ent) "link_post,post"
  set gPB(c_help,$frm.post_but) "link_post,select_name"
  if { [info exists mom_sys_arr(\$mom_sys_mill_turn_type)] && \
   [string match "SIMPLE_MILL_TURN" $mom_sys_arr(\$mom_sys_mill_turn_type)] } {
   if [string match ".1" $sel] {
    $frm.post_ent config -textvar mom_sys_arr(\$mom_sys_lathe_postname)
   }
  }
  bind $frm.head_ent <KeyPress>   "UI_PB_com_DisableSpecialChars %W %K"
  bind $frm.head_ent <KeyPress> "+UI_PB_com_RestrictStringLength %W %K head"
  bind $frm.head_ent <Control-Key-v> "UI_PB_com_Validate_Control_V %W %K %A head"
  bind $frm.head_ent <KeyRelease> "UI_PB_com_Validate_Control_V_Release %W"
  bind $frm.post_ent <KeyPress>   "UI_PB_com_DisableSpecialChars %W %K"
  bind $frm.post_ent <KeyRelease> {%W config -state normal}
  focus $frm.head_ent
  set evt_name "start_of_HEAD__$head_text"
  set start_evt_obj -1
  PB_com_RetObjFrmName evt_name evt_obj_list start_evt_obj
  set start_evt_is_new 0
  if { $start_evt_obj <= 0 } {
   set evt_obj_attr(0) "$evt_name"
   set evt_obj_attr(1) 0
   set evt_obj_attr(2) {}
   set evt_obj_attr(3) {}
   set evt_obj_attr(4) $evt_obj_attr(0)
   PB_evt_CreateEvtObj evt_obj_attr evt_obj_list
   set start_evt_is_new 1
  }
  PB_com_RetObjFrmName evt_name evt_obj_list start_evt_obj
  set b [frame $frm.bbox]
  button $b.start -text "Start" \
  -command "__lnk_EditEvent $frm.head_ent start $seq_obj $start_evt_obj" \
  -takefocus 1 -background $paOption(event)
  set img_id [image create compound -window $b.start -padx 10 \
  -foreground $paOption(special_fg) -background $paOption(event)]
  $img_id add image -image [tix getimage pb_event_marker]
  $img_id add text -text "$gPB(link_post,start_of_head,Label)"
  $b.start config -image $img_id
  unset img_id
  set evt_name "end_of_HEAD__$head_text"
  set end_evt_obj -1
  PB_com_RetObjFrmName evt_name evt_obj_list end_evt_obj
  set end_evt_is_new 0
  if { $end_evt_obj <= 0 } {
   set evt_obj_attr(0) "$evt_name"
   set evt_obj_attr(1) 0
   set evt_obj_attr(2) {}
   set evt_obj_attr(3) {}
   set evt_obj_attr(4) $evt_obj_attr(0)
   PB_evt_CreateEvtObj evt_obj_attr evt_obj_list
   set end_evt_is_new 1
  }
  PB_com_RetObjFrmName evt_name evt_obj_list end_evt_obj
  button $b.end -text "End" \
  -command "__lnk_EditEvent $frm.head_ent end $seq_obj $end_evt_obj" \
  -takefocus 1 -background $paOption(event)
  set img_id [image create compound -window $b.end -padx 10 \
  -foreground $paOption(special_fg) -background $paOption(event)]
  $img_id add image -image [tix getimage pb_event_marker]
  $img_id add text -text "$gPB(link_post,end_of_head,Label)"
  $b.end config -image $img_id
  unset img_id
  pack $b.start -side left  -padx 5 -pady 5 -fill x -expand yes
  pack $b.end   -side right -padx 5 -pady 5 -fill x -expand yes
  set gPB(c_help,$b.start) "link_post,start_of_head"
  set gPB(c_help,$b.end)   "link_post,end_of_head"
  grid $b - - - - -sticky ew
  set butt [frame $win.b]
  pack $butt -side bottom -fill x
  set label_list {"gPB(nav_button,ok,Label)" \
  "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label))      "__lnk_OkCB $flag $page_obj $win \
  $start_evt_obj $end_evt_obj {$evt_obj_list} $seq_obj"
  set cb_arr(gPB(nav_button,cancel,Label))  "__lnk_CancelCB $win \
  $start_evt_obj $start_evt_is_new \
  $end_evt_obj $end_evt_is_new \
  {$evt_obj_list} $seq_obj"
  UI_PB_com_CreateButtonBox $butt label_list cb_arr
  UI_PB_com_CenterWindow $win
 }

#=======================================================================
proc __lnk_EditEvent { w flag seq_obj evt_obj args } {
  event::readvalue $evt_obj evt_obj_attr
  if [string match "start" $flag] {
   set evt_obj_attr(0) "start_of_HEAD__[$w get]"
  }
  if [string match "end" $flag] {
   set evt_obj_attr(0) "end_of_HEAD__[$w get]"
  }
  set evt_obj_attr(4) $evt_obj_attr(0)
  event::setvalue $evt_obj evt_obj_attr
  set event::($evt_obj,event_open) 1
  event::RestoreValue $evt_obj
  set seq_page_obj 0
  set Page::($seq_page_obj,active_seq) 0
  set Page::($seq_page_obj,buff_blk_obj) 0
  UI_PB_tpth_LinkedPostEvent seq_page_obj seq_obj evt_obj
 }

#=======================================================================
proc __lnk_SelectPost { w args } {
  global gPB
  global env
  global tcl_platform
  UI_PB_com_SetStatusbar "Select a Post Builder session file."
  UI_PB_file_GetWorkFileDir
  set file_name [file join $gPB(work_dir) $gPB(work_file)]
  if { ![file exists $file_name] } {
   set gPB(work_file) ""
  }
  if { ![info exists gPB(link_post)] } {
   set gPB(link_post) ""
  }
  if {$tcl_platform(platform) == "unix"} \
  {
   UI_PB_file_SelectFile_unx PUI gPB(link_post) open
   } elseif {$tcl_platform(platform) == "windows"} \
  {
   UI_PB_file_SelectFile_win PUI gPB(link_post) open
  }
  set gPB(link_post) [string trim $gPB(link_post) \"]
  if { $gPB(link_post) != "" } {
   set post [file rootname [file tail $gPB(link_post)]]
   $w delete 0 end
   $w insert 0 $post
  }
 }

#=======================================================================
proc __lnk_OkCB { flag page_obj win start_evt_obj end_evt_obj evt_obj_list seq_obj } {
  global post_object
  set hlist $Page::($page_obj,hlist)
  set head [$win.frm.head_ent get]
  set post [$win.frm.post_ent get]
  if { [string trim $head] == "" || [string trim $post] == "" } {
   if { ![string match ".0" [$hlist info selection]] } {
    set res [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
    -message "Neither Head nor Post name can be blank!"]
    return
   }
   } else {
   if { [llength $event::($start_evt_obj,evt_elem_list)] == 0 } {
    PB_com_DeleteObject $start_evt_obj
    set index [lsearch $evt_obj_list $start_evt_obj]
    set evt_obj_list [lreplace $evt_obj_list $index $index]
    } else {
    set event::($start_evt_obj,event_name)  "start_of_HEAD__$head"
    set event::($start_evt_obj,event_label) "start_of_HEAD__$head"
    UI_PB_lnk_SyncBlockNameWithEvent $start_evt_obj
   }
   if { [llength $event::($end_evt_obj,evt_elem_list)] == 0 } {
    PB_com_DeleteObject $end_evt_obj
    set index [lsearch $evt_obj_list $end_evt_obj]
    set evt_obj_list [lreplace $evt_obj_list $index $index]
    } else {
    set event::($end_evt_obj,event_name)    "end_of_HEAD__$head"
    set event::($end_evt_obj,event_label)   "end_of_HEAD__$head"
    UI_PB_lnk_SyncBlockNameWithEvent $end_evt_obj
   }
   set Post::($post_object,evt_obj_list)   $evt_obj_list
   set sequence::($seq_obj,evt_obj_list)   $evt_obj_list
   array set res_seq_attr $sequence::($seq_obj,rest_value)
   set res_seq_attr(1) $evt_obj_list
   set sequence::($seq_obj,rest_value) [array get res_seq_attr]
   array set def_seq_attr $sequence::($seq_obj,def_value)
   set def_seq_attr(1) $evt_obj_list
   set sequence::($seq_obj,def_value) [array get def_seq_attr]
  }
  set item [$hlist info selection]
  set sel [$hlist info data $item]
  if [string match "edit" $flag] {
   set id [lindex $sel 0]
   set sel_edit [list]
   lappend sel_edit $id $head $post
   $hlist entryconfig $item -data $sel_edit -text $head
   $hlist item config $item 1 -text $post
   } else { ;# new
   set ents [$hlist info children .]
   set new_id [llength $ents]
   while { [$hlist info exists .$new_id] } {
    incr new_id
   }
   set sel_new [list]
   lappend sel_new $new_id $head $post
   set style(post) [tixDisplayStyle text -refwindow $hlist \
   -padx 10 -font [tix option get bold_font]]
   set row [$hlist add .$new_id -after $item -itemtype text -text $head -data $sel_new \
   -style $style(post)]
   $hlist item create $row 1 -itemtype text -text $post -style $style(post)
   $hlist selection clear
   $hlist selection set .$new_id
   $hlist anchor clear
   $hlist anchor set .$new_id
  }
  destroy $win
  update
  if { [string trim $head] == "" } {
   global mom_sys_arr
   set mom_sys_arr(\$is_linked_post) 0
   UI_PB_com_DisableWindow $Page::($page_obj,list_win)
   return
  }
  __lnk_BrowseALinkedPost $page_obj
 }

#=======================================================================
proc __lnk_CancelCB { win \
  start_evt_obj start_evt_is_new \
  end_evt_obj end_evt_is_new \
  evt_obj_list seq_obj } {
  global post_object
  if $start_evt_is_new {
   __lnk_CleanUpEventData start_evt_obj evt_obj_list seq_obj 1
  }
  if $end_evt_is_new {
   __lnk_CleanUpEventData end_evt_obj evt_obj_list seq_obj 1
  }
  destroy $win
 }

#=======================================================================
proc UI_PB_lnk_SyncBlockNameWithEvent { event_obj } {
  global paOption gPB
  event::readvalue $event_obj evt_attr
  set event_name "$evt_attr(0)"
  set blk_type start
  set last_idx end
  if [string match "start_of_HEAD__*" $event_name] {
   set post_name [string range $event_name 15 $last_idx]
   } else {
   set post_name [string range $event_name 13 $last_idx]
   set blk_type end
  }
  set sub_index 0
  foreach evt_elem_obj $evt_attr(2) {
   switch $blk_type {
    "start" {
     set blk_name "start_of_HEAD__$post_name"
    }
    "end" -
    default {
     set blk_name "end_of_HEAD__$post_name"
    }
   }
   if { $sub_index > 0 } {
    set blk_name "${blk_name}_$sub_index"
   }
   event_element::readvalue $evt_elem_obj evt_elem_attr
   set evt_elem_attr(0) "$blk_name"
   event_element::setvalue     $evt_elem_obj evt_elem_attr
   event_element::DefaultValue $evt_elem_obj evt_elem_attr
   event_element::RestoreValue $evt_elem_obj
   set blk_obj $evt_elem_attr(1)
   block:::readvalue $blk_obj blk_attr
   set blk_attr(0) "$blk_name"
   block::setvalue     $blk_obj blk_attr
   block::DefaultValue $blk_obj blk_attr
   block::RestoreValue $blk_obj
   set block::($blk_obj,blk_owner) "$event_name"
   set blk_elem_list $blk_attr(2)
   foreach blk_elem_obj $blk_elem_list {
    set block_element::($blk_elem_obj,owner)       "$event_name"
    set block_element::($blk_elem_obj,parent_name) "$blk_name"
   }
   incr sub_index
  }
 }

#=======================================================================
proc __lnk_CreateActionButtons { act_frm page_obj } {
  global paOption
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_lnk_DefaultCallBack $page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_lnk_RestoreCallBack $page_obj"
  UI_PB_com_CreateButtonBox $act_frm label_list cb_arr
 }

#=======================================================================
proc UI_PB_lnk_DefaultCallBack { page_obj } {
  global post_object
  global mom_sys_arr
  array set def_mom_sys_arr $Post::($post_object,def_mom_sys_var_list)
  set mom_sys_arr(\$is_linked_post)    $def_mom_sys_arr(\$is_linked_post)
  set mom_sys_arr(\$linked_posts_list) $def_mom_sys_arr(\$linked_posts_list)
  if { [info exists mom_sys_arr(\$mom_sys_mill_turn_type)] && \
   [string match "SIMPLE_MILL_TURN" $mom_sys_arr(\$mom_sys_mill_turn_type)] } {
   if [info exists def_mom_sys_arr(\$mom_sys_lathe_postname)] {
    set mom_sys_arr(\$mom_sys_lathe_postname) $def_mom_sys_arr(\$mom_sys_lathe_postname)
   }
  }
  __lnk_FillLinkedPostsHList $page_obj
  __lnk_ToggleLinkedPostList $page_obj
  __lnk_DefaultData
 }

#=======================================================================
proc UI_PB_lnk_RestoreCallBack { page_obj } {
  global mom_sys_arr
  set mom_sys_arr(\$is_linked_post)    $Page::($page_obj,is_linked_post)
  set mom_sys_arr(\$linked_posts_list) $Page::($page_obj,linked_posts_list)
  if { [info exists mom_sys_arr(\$mom_sys_mill_turn_type)] && \
   [string match "SIMPLE_MILL_TURN" $mom_sys_arr(\$mom_sys_mill_turn_type)] } {
   if [info exists Page::($page_obj,lathe_postname)] {
    set mom_sys_arr(\$mom_sys_lathe_postname) $Page::($page_obj,lathe_postname)
   }
  }
  __lnk_FillLinkedPostsHList $page_obj
  __lnk_ToggleLinkedPostList $page_obj
  __lnk_RestoreData
 }

#=======================================================================
proc UI_PB_lnk_ApplyData { page_obj } {
  global mom_sys_arr
  PB_int_UpdateMOMVar mom_sys_arr
 }

#=======================================================================
proc UI_PB_lnk_SaveData { page_obj } {
  global post_object
  global mom_sys_arr
  set hlist $Page::($page_obj,hlist)
  set mom_sys_arr(\$linked_posts_list) [__lnk_FetchLinkedPostsList $hlist]
  set Page::($page_obj,is_linked_post)    $mom_sys_arr(\$is_linked_post)
  set Page::($page_obj,linked_posts_list) $mom_sys_arr(\$linked_posts_list)
  set seq_obj $Page::($page_obj,seq_obj)
  array set def_seq_attr $sequence::($seq_obj,def_value)
  set def_evt_obj_list $def_seq_attr(1)
  array set res_seq_attr $sequence::($seq_obj,rest_value)
  set res_evt_obj_list $res_seq_attr(1)
  sequence::readvalue $seq_obj seq_attr
  set evt_obj_list $seq_attr(1)
  foreach evt_obj $res_evt_obj_list {
   array set res_evt_attr $event::($evt_obj,rest_value)
   set res_evt_elem_list $res_evt_attr(2)
   array set def_evt_attr $event::($evt_obj,def_value)
   set def_evt_elem_list $def_evt_attr(2)
   event::readvalue $evt_obj evt_attr
   set evt_elem_list $evt_attr(2)
   if { [lsearch $evt_obj_list $evt_obj] < 0  && \
    [lsearch $def_evt_obj_list $evt_obj] < 0 } {
    foreach evt_elem $res_evt_elem_list {
     __lnk_DeleteEventElem $evt_elem
     set index [lsearch $def_evt_elem_list $evt_elem]
     set def_evt_elem_list [lreplace $def_evt_elem_list $index $index]
     set index [lsearch $evt_elem_list $evt_elem]
     set evt_elem_list [lreplace $evt_elem_list $index $index]
    }
    foreach evt_elem $def_evt_elem_list {
     __lnk_DeleteEventElem $evt_elem
     set index [lsearch $evt_elem_list $evt_elem]
     set evt_elem_list [lreplace $evt_elem_list $index $index]
    }
    foreach evt_elem $evt_elem_list {
     __lnk_DeleteEventElem $evt_elem
    }
    set evt_attr(2) [list]
    event::setvalue $evt_obj evt_attr
    PB_com_DeleteObject $evt_obj
    set index [lsearch $evt_obj_list $evt_obj]
    set evt_obj_list [lreplace $evt_obj_list $index $index]
    set seq_attr(1) $evt_obj_list
    sequence::setvalue $seq_obj seq_attr
    } else {
    foreach evt_elem $res_evt_elem_list {
     if { [lsearch $evt_elem_list $evt_elem] < 0  && \
      [lsearch $def_evt_elem_list $evt_elem] < 0 } {
      __lnk_DeleteEventElem $evt_elem
     }
    }
   }
   if 0 {
    array set def_evt_obj_attr $event::($evt_obj,def_value)
    set evt_elem_list ""
    foreach elem_obj $event::($evt_obj,evt_elem_list) \
    {
     set block_obj $event_element::($elem_obj,block_obj)
     if { [lsearch $def_evt_obj_attr(2) $elem_obj] == -1 } \
     {
      PB_com_DeleteObject $elem_obj
      if { $block::($block_obj,blk_type) == "normal" } \
      {
       PB_int_RemoveBlkObjFrmList block_obj
       } elseif { $block::($block_obj,blk_type) == "comment" } \
      {
       PB_int_DeleteCommentBlkFromList block_obj
      }
      PB_com_DeleteObject $block_obj
     } else \
     {
      UI_PB_blk_DeleteChangeOverBlkElems block_obj
      lappend evt_elem_list $elem_obj
     }
    }
    set event::($evt_obj,evt_elem_list) $evt_elem_list
   }
  }
 }

#=======================================================================
proc __lnk_DeleteEventElem { evt_elem } {
  global post_object
  event_element::readvalue $evt_elem evt_elem_attr
  set blk_obj $evt_elem_attr(1)
  block::DeleteFromEventElemList $blk_obj evt_elem
  block::DeleteFromEventElemList $blk_obj evt_elem
  if { [llength $block::($blk_obj,evt_elem_list)] == 0 } {
   switch $block::($blk_obj,blk_type) {
    "command" {
     set blk_obj_list $Post::($post_object,cmd_blk_list)
     set index [lsearch $blk_obj_list $blk_obj]
     set blk_obj_list [lreplace $blk_obj_list $index $index]
     set Post::($post_object,cmd_blk_list) $blk_obj_list
    }
    "comment" {
     set blk_obj_list $Post::($post_object,comment_blk_list)
     set index [lsearch $blk_obj_list $blk_obj]
     set blk_obj_list [lreplace $blk_obj_list $index $index]
     set Post::($post_object,comment_blk_list) $blk_obj_list
     PB_int_DeleteCommentBlkFromList blk_obj
    }
    default {
     set blk_obj_list $Post::($post_object,blk_obj_list)
     set index [lsearch $blk_obj_list $blk_obj]
     set blk_obj_list [lreplace $blk_obj_list $index $index]
     set Post::($post_object,blk_obj_list) $blk_obj_list
     PB_int_RemoveBlkObjFrmList blk_obj
    }
   }
   if { ![string match "command" $block::($blk_obj,blk_type)] } {
    PB_com_DeleteObject $blk_obj
   }
  }
  set evt_obj $event_element::($evt_elem,event_obj)
  set evt_elem_list $event::($evt_obj,evt_elem_list)
  set idx [lsearch $evt_elem_list $evt_elem]
  if { $idx >= 0 } {
   set evt_elem_list [lreplace $evt_elem_list $idx $idx]
   set event::($evt_obj,evt_elem_list) $evt_elem_list
  }
  event::RestoreValue $evt_obj
  PB_com_DeleteObject $evt_elem
 }

#=======================================================================
proc UI_PB_progtpth_LinkPostTab { book_id page_img book_obj } {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_progtpth_ValidatePrevPageData book_obj] }\
  {
   return
  }
  UI_PB_progtpth_DeleteTabAtt book_obj
  set Book::($book_obj,current_tab) 6
  UI_PB_progtpth_CreateTabAttr book_obj
  set Book::($book_obj,tab_6_created) 1
 }

#=======================================================================
proc UI_PB_progtpth_CreateTabAttr { BOOK_OBJ args } {
  upvar $BOOK_OBJ book_obj
  global gPB
  switch -exact -- $Book::($book_obj,current_tab) \
  {
   0 { ;# Program
    set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
    UI_PB_evt_GetSequenceIndex page_obj seq_index
    set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
    UI_PB_evt_RestoreSeqObjData seq_obj
    if { $seq_index == 0 || $seq_index == 1 || \
    $seq_index == 6 || $seq_index == 7 } \
    {
     UI_PB_evt_CreateMenuOptions page_obj seq_obj
    }
    UI_PB_evt_CreateSeqAttributes page_obj
    UI_PB_com_SetStatusbar "$gPB(prog,Status)"
   }
   1 { ;# G Codes
    set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
    if { [llength $args] > 0 } {
     set page_s [lindex $args 0]
    }
    if { [info exists page_s] && ![string compare "G" $page_s] } {
     UI_PB_gcd_RestoreGcodeData $page_obj 1
     } else {
     UI_PB_gcd_RestoreGcodeData $page_obj
    }
    UI_PB_com_SetStatusbar "$gPB(gcode,Status)"
   }
   2 { ;# M Codes
    set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
    if { [llength $args] > 0 } {
     set page_s [lindex $args 0]
    }
    if { [info exists page_s] && ![string compare "M" $page_s] } {
     UI_PB_mcd_RestoreMcodeData $page_obj 1
     } else {
     UI_PB_mcd_RestoreMcodeData $page_obj
    }
    UI_PB_com_SetStatusbar "$gPB(mcode,Status)"
   }
   3 { ;# Word Summary
    set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
    UI_PB_ads_TabAddrsumCreate page_obj
    UI_PB_com_SetStatusbar "$gPB(addrsum,Status)"
   }
   4 { ;# Word Sequencing
    set page_obj [lindex $Book::($book_obj,page_obj_list) 4]
    UI_PB_mseq_CreateMastSeqElements page_obj
    UI_PB_com_SetStatusbar "$gPB(wseq,Status)"
    global post_object
    set Post::($post_object,mseq_visited) 1
   }
   5 { ;# Custom Commands
    set page_obj [lindex $Book::($book_obj,page_obj_list) 5]
    UI_PB_cmd_CmdTabCreate page_obj
    UI_PB_com_SetStatusbar "$gPB(cust_cmd,Status)"
   }
   6 { ;# Linked Posts
    set page_obj [lindex $Book::($book_obj,page_obj_list) 6]
    set current_tab $Book::($book_obj,current_tab)
    if { ![info exists Book::($book_obj,tab_${current_tab}_created)] } {
     __lnk_SetRestoreData
    }
    UI_PB_com_SetStatusbar "Specify post links."
    global LicInfo
    if { [info exists LicInfo(user_right_limit)]  &&  $LicInfo(user_right_limit) == "YES" } {
     set page_id [$Book::($book_obj,book_id) subwidget $Page::($page_obj,page_name)]
     UI_PB_com_DisableWindow $page_id
    }
   }
   7 { ;#<03-31-09 wbh> Macro
    set page_obj [lindex $Book::($book_obj,page_obj_list) 7]
    UI_PB_func_FuncTabCreate page_obj
    UI_PB_com_SetStatusbar "Edit functions."
   }
  }
 }

#=======================================================================
proc UI_PB_progtpth_ValidatePrevPageData { BOOK_OBJ args} {
  upvar $BOOK_OBJ book_obj
  global gPB
  set raise_page 0
  set current_tab $Book::($book_obj,current_tab)
  set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
  switch -exact -- $current_tab \
  {
   3 { ;#<11-27-01 gsl> Addresses Summary page
    set addrsum_err [UI_PB_ads_ValidateAllFormats]
    if $addrsum_err { set raise_page 1 }
    set max [UI_PB_ads_ValidateMaxN]
    if $max {
     set raise_page 1
    }
   }
   5 { ;# Custom Command page
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
   6 { ;#<12-04-02 gsl> Linked Posts page
    set raise_page [UI_PB_progtpth_ValidateLinkedPostPage $page_obj]
    if { $raise_page == 0 } {
     UI_PB_lnk_SaveData $page_obj
    }
   }
   7 { ;#<03-31-09 wbh> Macro page
    set raise_page [UI_PB_func_CheckFuncFormat $page_obj error_msg]
    if { !$raise_page } \
    {
     if [info exists Page::($page_obj,active_func_obj)] \
     {
      set func_obj $Page::($page_obj,active_func_obj)
      UI_PB_func_SaveFuncInfo $page_obj $func_obj
     }
    }
   }
  }
  if { $raise_page } {
   set need_valid_nxt 0
   } else {
   set need_valid_nxt 1
  }
  if { [llength $args] > 0 && $need_valid_nxt } {
   set nxt_tab [lindex $args 0]
   set nxt_page_obj [lindex $Book::($book_obj,page_obj_list) $nxt_tab]
   switch -exact -- $nxt_tab \
   {
    1 { ;#<03-15-10 lxy> G Codes page
     set gcodes_err_msg ""
     if { [UI_PB_progtpth_ValidateGMCodePage $page_obj gcodes_err_msg G] } {
      set raise_page 1
     }
    }
    2 { ;#<03-15-10 lxy> M Codes page
     set mcodes_err_msg ""
     if { [UI_PB_progtpth_ValidateGMCodePage $page_obj mcodes_err_msg M] } {
      set raise_page 1
     }
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
    UI_PB_fmt_DisplayErrorMessage $addrsum_err
    } elseif { $max } {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
    -type ok -icon error \
    -message "$gPB(msg,add_max1) N $gPB(msg,add_max2) $max."
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
  6 { ;#<01-14-03 gsl> Linked posts
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -type ok -icon error \
   -message "Duplicated Head assignment is not permitted."
  }
  7 { ;#<03-31-09 wbh> Macro
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -type ok -icon error -message $error_msg
  }
 }
 if { [info exists nxt_tab] && $need_valid_nxt } {
  switch -exact -- $nxt_tab \
  {
   1 { ;#<03-15-10 lxy> G Codes page
    UI_PB_mthd_DisplayErrMsg "$gcodes_err_msg"
   }
   2 { ;#<03-15-10 lxy> M Codes page
    UI_PB_mthd_DisplayErrMsg "$mcodes_err_msg"
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
  "link"  { set new_tab 6 }
  "func"  { set new_tab 7 }
  default { set new_tab 0 }
 }
 set Book::($book_obj,current_tab) $new_tab
 if { $new_tab == 1 } {
  UI_PB_progtpth_CreateTabAttr book_obj G
  } elseif { $new_tab == 2 } {
  UI_PB_progtpth_CreateTabAttr book_obj M
  } else {
  UI_PB_progtpth_CreateTabAttr book_obj
 }
 set Book::($book_obj,current_tab) $current_tab
}
return $raise_page
}

#=======================================================================
proc UI_PB_progtpth_ValidateGMCodePage { page_obj ERR_MSG cname } {
  global mom_sys_arr post_object gPB
  global gpb_fmt_var
  upvar $ERR_MSG err_msg
  set re_state 0
  set err_message_list [list]
  if { ![string compare "G" $cname] } {
   array set codes_var_arr $Post::($post_object,g_codes)
   } elseif { ![string compare "M" $cname] } {
   array set codes_var_arr $Post::($post_object,m_codes)
  }
  foreach code_index [array names codes_var_arr] {
   set state 0
   set code_var $codes_var_arr($code_index)
   UI_PB_mthd_GetAddName $code_var $cname add_name
   UI_PB_com_GetFomFrmAddname $add_name fmr_obj_attr
   set fmt_name $fmr_obj_attr(0)
   set for_obj_attr(0) $gpb_fmt_var($fmt_name,name)
   set for_obj_attr(1) $gpb_fmt_var($fmt_name,dtype)
   set for_obj_attr(2) $gpb_fmt_var($fmt_name,plus_status)
   set for_obj_attr(3) $gpb_fmt_var($fmt_name,lead_zero)
   set for_obj_attr(4) $gpb_fmt_var($fmt_name,trailzero)
   set for_obj_attr(5) $gpb_fmt_var($fmt_name,integer)
   set for_obj_attr(6) $gpb_fmt_var($fmt_name,decimal)
   set for_obj_attr(7) $gpb_fmt_var($fmt_name,fraction)
   if { ![string compare "Numeral" $for_obj_attr(1)] } {
    set expr_value [string trim $mom_sys_arr($code_var)]
    if { [string match -* $expr_value] } {
     set expr_value [string trim $expr_value "-"]
    }
    if { [string match +* $expr_value] } {
     set expr_value [string trim $expr_value "+"]
    }
    if ![catch { expr $expr_value + 1 }] {
     set dec_pt [string first "." $expr_value]
     if { $dec_pt != -1 } {
      set len [expr [string length $expr_value] - 1]
      set fpart [string trimleft [string range $expr_value 0 [expr $dec_pt - 1]] "0"]
      set spart [string trimright [string range $expr_value [expr $dec_pt + 1] $len] "0"]
      } else {
      set fpart [string trimleft $expr_value "0"]
      set spart ""
     }
     if { ![string compare "" $for_obj_attr(5)] } {
      set for_obj_attr(5) 0
     }
     if { ![string compare "" $for_obj_attr(7)] } {
      set for_obj_attr(7) 0
     }
     if { [string length $fpart] > $for_obj_attr(5) || [string length $spart] > $for_obj_attr(7) } {
      set state 1
     }
     } else {
     set state 1
    }
   }
   if { $state } {
    UI_PB_fmt_AppendFormatErrorMsg err_message_list $code_var $add_name for_obj_attr
   }
  }
  if { [llength $err_message_list] > 0 } {
   set re_state 1
   set err_msg ""
   for { set i 0 } { $i < [llength $err_message_list] } { incr i } {
    append err_msg "[lindex $err_message_list $i] \n"
   }
   append err_msg "\n$gPB(format,check_6,error,msg)"
  }
  return $re_state
 }

#=======================================================================
proc UI_PB_progtpth_ValidateLinkedPostPage { page_obj } {
  set raise_page 0
  set hlist $Page::($page_obj,hlist)
  set ents [$hlist info children .]
  set head_list [list]
  foreach item $ents {
   set sel [$hlist info data $item]
   set head [lindex $sel 1]
   set head [string toupper $head]
   if { [lsearch $head_list "$head"] >= 0 } {
    set raise_page 1
    break
    } else {
    lappend head_list $head
   }
  }
  return $raise_page
 }

#=======================================================================
proc UI_PB_progtpth_DeleteTabAtt { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  switch -exact -- $Book::($book_obj,current_tab) \
  {
   0 { ;# Program
    set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
    UI_PB_evt_DeleteObjectsPrevSeq page_obj
    UI_PB_evt_DeleteApplyEvtElemsOfSeq page_obj
   }
   1 { ;# G Codes
    set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
    UI_PB_gcd_ApplyGcodeData $book_obj $page_obj
   }
   2 { ;# M Codes
    set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
    UI_PB_mcd_ApplyMcodeData $book_obj $page_obj
   }
   3 { ;# Summary
    set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
    UI_PB_ads_UpdateAddressObjects
   }
   4 { ;# Sequencing
    set page_obj [lindex $Book::($book_obj,page_obj_list) 4]
    UI_PB_mseq_ApplyMastSeq page_obj
    UI_PB_mseq_DeleteMastSeqElems page_obj
   }
   5 { ;# Custom Commnads
    set page_obj [lindex $Book::($book_obj,page_obj_list) 5]
    UI_PB_cmd_CmdTabDelete page_obj
   }
   6 { ;#<01-15-03 gsl> Linked posts
    set page_obj [lindex $Book::($book_obj,page_obj_list) 6]
   }
   7 { ;#<03-31-09 wbh> Macro
    set page_obj [lindex $Book::($book_obj,page_obj_list) 7]
    UI_PB_func_FuncTabDelete page_obj
   }
  }
 }
