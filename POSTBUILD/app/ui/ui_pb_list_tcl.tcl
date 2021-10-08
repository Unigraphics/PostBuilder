#18
UI_PB_AddPatchMsg "2005.0.0" "<07-02-08> Output PB_CMD_vnc____old_map_machine_tool_axes for legacy sub-VNC"

#=======================================================================
proc __PB_has_VNC { } {
  return 1
  global gPB
  if { [PB_is_v $gPB(VNC_release)] && ![PB_is_v 4.0] } {
   return 1
   } else {
   return 0
  }
 }

#=======================================================================
proc UI_PB_List { book_id output_page_obj } {
  global tixOption
  global ListObjectAttr
  global gPB
  global mom_sys_arr
  global output_book
  set f [$book_id subwidget $Page::($output_page_obj,page_name)]
  set w [tixNoteBook $f.nb -ipadx 5 -ipady 5]
  [$w subwidget nbframe] config -tabpady 0
  set output_book [new Book w]
  set Page::($output_page_obj,book_obj) $output_book
  if { [PB_is_probe_post] } {
   Book::CreatePage $output_book lpt "" "" "" ""
   Book::CreatePage $output_book oth "" "" "" ""
   $Book::($output_book,book_id) pageconfigure lpt -state disabled
   $Book::($output_book,book_id) pageconfigure oth -state disabled
   } else {
   Book::CreatePage $output_book lpt "$gPB(listing,tab,Label)" "" \
   UI_PB_list_AddListPage UI_PB_list_ListingTab
   Book::CreatePage $output_book oth "$gPB(listing,other,tab,Label)" "" \
   UI_PB_list_AddOtherElemPage UI_PB_list_OtherElemTab
  }
  Book::CreatePage $output_book pre "$gPB(preview,tab,Label)" pb_output \
  UI_PB_Preview UI_PB_list_PreviewTab
  pack $f.nb -expand yes -fill both
  set Book::($output_book,x_def_tab_img) 0
  set Book::($output_book,current_tab)  -1
  if { [PB_is_probe_post] } {
   $Book::($output_book,book_id) raise pre
  }
 }

#=======================================================================
proc UI_PB_list_ListingTab { book_id page_img book_obj} {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_list_ValidatePrevPageData book_obj] } \
  {
   return
  }
  UI_PB_list_UpdatePrevTabElems book_obj
  set Book::($book_obj,current_tab) 0
  UI_PB_list_CreateTabAttr book_obj
 }

#=======================================================================
proc UI_PB_list_OtherElemTab { book_id page_img book_obj} {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_list_ValidatePrevPageData book_obj] } \
  {
   return
  }
  UI_PB_list_UpdatePrevTabElems book_obj
  set Book::($book_obj,current_tab) 1
  UI_PB_list_CreateTabAttr book_obj
  if { [info exists ::mom_sys_arr(\$mom_sys_advanced_turbo_output)] } {
   set ::rest_mom_sys_arr(\$mom_sys_advanced_turbo_output) $::mom_sys_arr(\$mom_sys_advanced_turbo_output)
  }
 }

#=======================================================================
proc UI_PB_list_PreviewTab { book_id page_img book_obj } {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_list_ValidatePrevPageData book_obj] } \
  {
   return
  }
  UI_PB_list_UpdatePrevTabElems book_obj
  set Book::($book_obj,current_tab) 2
  UI_PB_list_CreateTabAttr book_obj
 }

#=======================================================================
proc UI_PB_list_ValidatePrevPageParam { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  global gPB
  set raise_page 0
  set current_tab $Book::($book_obj,current_tab)
  set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
  switch -exact -- $current_tab \
  {
   0 { ;# Listing File
   }
   1 { ;# Other Elements
    global ListObjectAttr
    if {$ListObjectAttr(usertcl_check) == 1} {
     if {[string length [string trim $ListObjectAttr(usertcl_name)]] == 0} {
      set raise_page 1
     }
    }
   }
   2 { # <03-03-06 pheobe>Validate Post File Review Page
   }
  }
  return $raise_page
 }

#=======================================================================
proc UI_PB_list_ErrorPrevPage { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  global gPB
  set current_tab $Book::($book_obj,current_tab)
  set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
  set book_id $Book::($book_obj,book_id)
  set cur_page_name [$book_id raised]
  set cur_page_img [$book_id pagecget $cur_page_name -image]
  set prev_page_name $Page::($page_obj,page_name)
  set prev_page_img [$book_id pagecget $prev_page_name -image]
  set Book::($book_obj,x_def_tab_img) $cur_page_img
  $book_id pageconfigure $prev_page_name \
  -raisecmd "CB_nb_def $book_id $prev_page_img $book_obj"
  $book_id raise $prev_page_name
  switch -exact -- $current_tab \
  {
   0 {
   }
   1 {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
    -type ok -icon error \
    -message "$gPB(output,other_opts,validation,msg)"
   }
   2 {
   }
  }
 }

#=======================================================================
proc UI_PB_list_ValidatePrevPageData { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  global gPB
  set raise_page 0
  set raise_page [UI_PB_list_ValidatePrevPageParam book_obj]
  if $raise_page {
   UI_PB_list_ErrorPrevPage book_obj
   set current_tab $Book::($book_obj,current_tab)
   set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
   set book_id $Book::($book_obj,book_id)
   set cur_page_name [$book_id raised]
   set cur_page_img [$book_id pagecget $cur_page_name -image]
   set prev_page_name $Page::($page_obj,page_name)
   set raisecmd [$book_id pagecget $prev_page_name -raisecmd]
   $book_id raise $prev_page_name
   $book_id pageconfigure $prev_page_name -raisecmd "$raisecmd"
   switch $cur_page_name \
   {
    "lpt"   { set new_tab 0 }
    "oth"   { set new_tab 1 }
    "pre"   { set new_tab 2 }
    default { set new_tab 0 }
   }
   set Book::($book_obj,current_tab) $new_tab
   set Book::($book_obj,current_tab) $current_tab
  }
  return $raise_page
 }
 if 0 {

#=======================================================================
proc UI_PB_list_ValidatePrevPageData { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  global gPB
  set raise_page 0
  set lis_page_flag 0
  set oth_page_flag 0
  set isv_page_flag 0
  set current_tab $Book::($book_obj,current_tab)
  set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
  switch -exact -- $current_tab \
  {
   0 { ;# Listing File
   }
   1 { ;# Other Elements
    global mom_sys_arr
    if { $mom_sys_arr(Output_VNC) && [string match "Subordinate" $mom_sys_arr(VNC_Mode)] } {
     if [string match "" $mom_sys_arr(Main_VNC)] {
      set raise_page 1
     }
    }
   }
   2 { ;# IS&V RevPost
   }
  }
  if { $raise_page } \
  {
   set book_id $Book::($book_obj,book_id)
   set cur_page_name [$book_id raised]
   set cur_page_img [$book_id pagecget $cur_page_name -image]
   set prev_page_name $Page::($page_obj,page_name)
   set raisecmd [$book_id pagecget $prev_page_name -raisecmd]
   set prev_page_img [$book_id pagecget $prev_page_name -image]
   set Book::($book_obj,x_def_tab_img) $cur_page_img
   $book_id pageconfigure $prev_page_name \
   -raisecmd "CB_nb_def $book_id $prev_page_img $book_obj"
   $book_id raise $prev_page_name
   switch -exact -- $current_tab \
   {
    0 {
    }
    1 {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type ok -icon error \
     -message "$gPB(output,vnc,main,err_msg)"
    }
    2 {
    }
   }
   $book_id raise $prev_page_name
   $book_id pageconfigure $prev_page_name -raisecmd "$raisecmd"
   switch $cur_page_name \
   {
    "lpt"   { set new_tab 0 }
    "oth"   { set new_tab 1 }
    "pre"   { set new_tab 2 }
    default { set new_tab 0 }
   }
   set Book::($book_obj,current_tab) $new_tab
   UI_PB_DeleteBookAttr book_obj
   set Book::($book_obj,current_tab) $current_tab
  }
  return $raise_page
 }
} ;# if 0

#=======================================================================
proc UI_PB_list_UpdatePrevTabElems { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  set current_tab $Book::($book_obj,current_tab)
  set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
  global ListObjectAttr
  switch -exact -- $current_tab \
  {
   0 {
    PB_int_ApplyListObjAttr ListObjectAttr
   }
   1 {
    PB_int_ApplyListObjAttr ListObjectAttr
   }
   2 {
   }
  }
 }

#=======================================================================
proc UI_PB_list_CreateTabAttr { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  global gPB
  set current_tab $Book::($book_obj,current_tab)
  set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
  switch -exact -- $current_tab \
  {
   0 { ;# Listing File
    UI_PB_com_SetStatusbar "$gPB(listing,Status)"
   }
   1 { ;# Other Control Elements
    UI_PB_com_SetStatusbar "$gPB(listing,Status)"
   }
   2 { ;# <03-03-06 pheobe> change it with post file review
    if 1 {
     set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
     if [info exists Page::($page_obj,book_obj)] \
     {
      set page_book_obj $Page::($page_obj,book_obj)
      UI_PB_prv_CreateTabAttr page_book_obj
     }
    }
    UI_PB_com_SetStatusbar "$gPB(listing,Status)"
   }
  }
 }

#=======================================================================
proc UI_PB_list_AddListPage { book_id page_obj } {
  global paOption
  global tixOption
  global gPB
  global ListObjectAttr
  set Page::($page_obj,page_id) [$book_id subwidget \
  $Page::($page_obj,page_name)]
  set w $Page::($page_obj,page_id)
  set sw [tixScrolledWindow $w.s -scrollbar auto -bd 0 -relief flat]
  [$sw subwidget hsb] config -troughcolor $paOption(trough_bg)
  [$sw subwidget vsb] config -troughcolor $paOption(trough_bg)
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_list_DefListObjAttr $page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_list_RestoreListObjAttr $page_obj"
  UI_PB_com_CreateButtonBox $w label_list cb_arr
  pack $sw -side top -expand yes -fill both
  set f  [$sw subwidget window]
  set list [frame $f.1 -relief solid -bd 1]
  set g1   [tixLabelFrame $f.2 -label "$gPB(listing,Label)"]
  grid $list -sticky w -padx 5 -pady 10
  grid $g1
  if { $::tcl_version == 8.6 } {
   grid anchor $f c
  }
  PB_int_RetListingFileParams ListObjectAttr
  set attr_list [array get ListObjectAttr]
  for { set i 1 } { $i < [llength $attr_list] } { incr i 2 } {
   if { [lindex $attr_list $i] == "OFF" } {
    set attr_list [lreplace $attr_list $i $i 0]
    } elseif { [lindex $attr_list $i] == "ON" } {
    set attr_list [lreplace $attr_list $i $i 1]
   }
  }
  array set ListObjectAttr $attr_list
  checkbutton $list.lisflg -text "$gPB(listing,gen,Label)" \
  -highlightthickness 0 \
  -fg $paOption(special_fg) \
  -bg $paOption(header_bg)\
  -variable ListObjectAttr(listfile) \
  -relief flat -font $tixOption(bold_font) \
  -anchor w -padx 10 -pady 6 ;#<03-31-03 gsl> 6 was 10.
  global tix_version
  if ![string compare $tix_version 8.4] {
   $list.lisflg configure -activebackground $paOption(header_bg) \
   -activeforeground $paOption(special_fg)
  }
  set g1_frm [$g1 subwidget frame]
  set g1_left  [frame $g1_frm.left]
  grid $g1_left  -row 0 -column 0 -padx 5 -pady 5 -sticky nw
  tixLabelEntry $g1_left.lptext -label "$gPB(listing,extension,Label)" \
  -options {
   label.width 30
   label.anchor w
   entry.width 7
   entry.anchor e
   entry.textVariable ListObjectAttr(lpt_ext)
  }
  [$g1_left.lptext subwidget label] config -font $tixOption(font)
  pack $g1_left.lptext -side top -fill x -padx 10 -pady 15 -anchor w
  tixLabelFrame $g1_left.param -label "$gPB(listing,parms,Label)"
  pack $list.lisflg
  pack $g1_left.param
  set f1  [$g1_left.param subwidget frame]
  checkbutton $f1.x   -text "$gPB(listing,parms,x,Label)" \
  -variable ListObjectAttr(x) \
  -relief flat -bd 2 -anchor w -padx 5 -width 30
  checkbutton $f1.y   -text "$gPB(listing,parms,y,Label)" \
  -variable ListObjectAttr(y) \
  -relief flat -bd 2 -anchor w -padx 5 -width 30
  checkbutton $f1.z   -text "$gPB(listing,parms,z,Label)" \
  -variable ListObjectAttr(z) \
  -relief flat -bd 2 -anchor w -padx 5 -width 30
  checkbutton $f1.4a  -text "$gPB(listing,parms,4,Label)" \
  -variable ListObjectAttr(4axis) \
  -relief flat -bd 2 -anchor w -padx 5 -width 30
  checkbutton $f1.5a  -text "$gPB(listing,parms,5,Label)" \
  -variable ListObjectAttr(5axis) \
  -relief flat -bd 2 -anchor w -padx 5 -width 30
  checkbutton $f1.fed -text "$gPB(listing,parms,feed,Label)" \
  -variable ListObjectAttr(feed) \
  -relief flat -bd 2 -anchor w -padx 5 -width 30
  checkbutton $f1.spd -text "$gPB(listing,parms,speed,Label)" \
  -variable ListObjectAttr(speed) \
  -relief flat -bd 2 -anchor w -padx 5 -width 30
  pack $f1.x $f1.y $f1.z $f1.4a $f1.5a $f1.fed $f1.spd -side top \
  -anchor w
  set gPB(c_help,$list.lisflg) "listing,gen"
  set gPB(c_help,$f1.x)      "listing,parms,x"
  set gPB(c_help,$f1.y)      "listing,parms,y"
  set gPB(c_help,$f1.z)      "listing,parms,z"
  set gPB(c_help,$f1.4a)     "listing,parms,4"
  set gPB(c_help,$f1.5a)     "listing,parms,5"
  set gPB(c_help,$f1.fed)    "listing,parms,feed"
  set gPB(c_help,$f1.spd)    "listing,parms,speed"
  set gPB(c_help,[$g1_left.lptext subwidget entry]) "listing,extension"
 }

#=======================================================================
proc UI_PB_list_AddOtherElemPage { book_id page_obj } {
  global paOption
  global tixOption
  global gPB
  global ListObjectAttr
  global post_object
  set Page::($page_obj,page_id) [$book_id subwidget \
  $Page::($page_obj,page_name)]
  set w $Page::($page_obj,page_id)
  set sw [tixScrolledWindow $w.s -scrollbar auto]
  [$sw subwidget hsb] config -troughcolor $paOption(trough_bg)
  [$sw subwidget vsb] config -troughcolor $paOption(trough_bg)
  set f  [$sw subwidget window]
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_list_DefListObjAttr $page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_list_RestoreListObjAttr $page_obj"
  UI_PB_com_CreateButtonBox $w label_list cb_arr
  pack $sw -side top -expand yes -fill both
  set g2 [frame $f.2 ]
  grid $g2
  if { $::tcl_version == 8.6 } {
   grid anchor $f c
  }
  set arr_temp_item_names  {listfile x y z 4axis 5axis feed speed lpt_ext}
  set list_file_obj $Post::($post_object,list_obj_list)
  set lfile_obj [lindex $list_file_obj 0]
  foreach name $arr_temp_item_names {
   set ListingFile::($lfile_obj,$name) $ListObjectAttr($name)
  }
  PB_int_RetListingFileParams ListObjectAttr
  set attr_list [array get ListObjectAttr]
  for { set i 1 } { $i < [llength $attr_list] } { incr i 2 } {
   if { [lindex $attr_list $i] == "OFF" } {
    set attr_list [lreplace $attr_list $i $i 0]
    } elseif { [lindex $attr_list $i] == "ON" } {
    set attr_list [lreplace $attr_list $i $i 1]
   }
  }
  array set ListObjectAttr $attr_list
  tixLabelFrame $g2.out        -label "$gPB(listing,output,Label)"
  if 1 {
   tixLabelFrame $g2.atp        -labelside none
   global mom_sys_arr
   global def_mom_sys_arr
   global rest_mom_sys_arr
   if { ![info exists mom_sys_arr(\$mom_sys_advanced_turbo_output)] } {
    set mom_sys_arr(\$mom_sys_advanced_turbo_output)      0
    array set def_mom_sys_arr $Post::($post_object,def_mom_sys_var_list)
    set def_mom_sys_arr(\$mom_sys_advanced_turbo_output)  0
    set Post::($post_object,mom_sys_var_list)      [array get mom_sys_arr]
    set Post::($post_object,def_mom_sys_var_list)  [array get def_mom_sys_arr]
   }
   if { [string match "Mill" $::machType] && ![string match "3MT" $::axisoption] } {
    set sta normal
    } else {
    set sta disabled
    set mom_sys_arr(\$mom_sys_advanced_turbo_output) 0
   }
   set rest_mom_sys_arr(\$mom_sys_advanced_turbo_output) $mom_sys_arr(\$mom_sys_advanced_turbo_output)
   if { $mom_sys_arr(\$mom_sys_advanced_turbo_output) } {
    set gPB(ATP_CMDS_LOADED) 1
   }
   set f3d [$g2.atp subwidget frame]
   checkbutton $f3d.chk -text "Enable Advanced Turbo Post Output" \
   -variable mom_sys_arr(\$mom_sys_advanced_turbo_output) \
   -relief flat  -bd 2 -anchor w -padx 5 -width 30 -state $sta \
   -command "__LoadAdvTurboPostCmds"
   pack $f3d.chk -fill x -anchor w -pady 10
  }
  tixLabelFrame $g2.tcl        -label "$gPB(listing,user_tcl,frame,Label)"
  if { [info exist ::env(SUB_POST)] && $::env(SUB_POST) == 1 } \
  {
   tixLabelFrame $g2.unit    -label "$gPB(listing,alt_unit,frame,Label)"
   set f3c [$g2.unit subwidget frame]
  }
  tixLabelFrame $g2.lnk  -labelside none
  pack $g2.out    -side top    -fill both
  if [winfo exists $g2.atp] {
   pack $g2.atp -side top    -fill both
  }
  pack $g2.tcl    -side top    -fill both
  if { [info exist ::env(SUB_POST)] && $::env(SUB_POST) == 1 } \
  {
   pack $g2.unit -side top    -fill both         -pady 20 ;#<12-09-10 gsl> Added -pady
  }
  tixLabelFrame $g2.sub  -labelside none
  pack $g2.sub    -side top    -fill both
  set f3s [$g2.sub subwidget frame]
  if { ![info exists ::ListObjectAttr(subprog_out)] } {
   set ::ListObjectAttr(subprog_out) 0
  }
  checkbutton $f3s.sub -text "$gPB(listing,subprog_out,check,Label)" \
  -variable ListObjectAttr(subprog_out) \
  -relief flat  -bd 2 -anchor w -padx 5 -width 30
  pack $f3s.sub -fill x -anchor w -pady 10
  set gPB(c_help,$f3s.sub)   "listing,subprog_out,check"
  tixLabelFrame $g2.tra  -labelside none
  pack $g2.tra    -side top    -fill both
  set f3t [$g2.tra subwidget frame]
  if { ![info exists ::ListObjectAttr(tran_path)] } {
   set ::ListObjectAttr(tran_path) 0
  }
  checkbutton $f3t.tra -text "$gPB(listing,tran_path,check,Label)" \
  -variable ListObjectAttr(tran_path) \
  -relief flat  -bd 2 -anchor w -padx 5 -width 30
  pack $f3t.tra -fill x -anchor w -pady 10
  set gPB(c_help,$f3t.tra)   "listing,tran_path,check"
  pack $g2.lnk -side bottom -fill both -pady 10 ;#<11-16-10 gsl> Added -pady ;#<12-15-10 wbh> Deleted -padx
  set f3  [$g2.out  subwidget frame]
  set f3a [$g2.tcl  subwidget frame]
  set f3b [$g2.lnk subwidget frame]
  if { ![info exists ListObjectAttr(verbose)] } \
  {
   set ListObjectAttr(verbose) 0
  }
  checkbutton $f3.err  -text "$gPB(listing,output,verbose,Label)" \
  -variable ListObjectAttr(verbose) \
  -relief flat  -bd 2 -anchor w -padx 5 -width 30
  if 0 {
   checkbutton $f3.warn -text "$gPB(listing,output,warning,Label)" \
   -variable ListObjectAttr(warn) \
   -relief flat  -bd 2 -anchor w -padx 5 -width 30
   } else {
   frame $f3.warn
   checkbutton $f3.warn.act -text "$gPB(listing,output,warning,Label)" \
   -variable ListObjectAttr(warn) \
   -relief flat  -bd 2 -anchor w -padx 5 \
   -command "UI_PB_lst__SetUserTclEntryState $page_obj"
   set m_opts {FILE LIST}
   set m_opt_labels(FILE) "$gPB(listing,output,warning,warn_file)"
   set m_opt_labels(LIST) "$gPB(listing,output,warning,nc_output)"
   set max_err $ListObjectAttr(warn_opt)
   tixOptionMenu $f3.warn.opt \
   -label "" \
   -variable ListObjectAttr(warn_opt)
   foreach opt $m_opts {
    $f3.warn.opt add command $opt -label "$m_opt_labels($opt)"
   }
   $f3.warn.opt config -value $max_err
   pack $f3.warn.act $f3.warn.opt -side left -fill x -expand yes
   set Page::($page_obj,warn_opt) $f3.warn.opt
  }
  checkbutton $f3.rev  -text "$gPB(listing,output,review,Label)" \
  -variable ListObjectAttr(review) \
  -relief flat  -bd 2 -anchor w -padx 5 -width 30
  checkbutton $f3.grp  -text "$gPB(listing,output,group,Label)" \
  -variable ListObjectAttr(group) \
  -relief flat  -bd 2 -anchor w -padx 5 -width 30
  tixLabelEntry $f3.ptpext -label "$gPB(listing,nc_file,Label)" \
  -options {
   label.width 30
   label.anchor w
   entry.width 7
   entry.anchor e
   entry.textVariable ListObjectAttr(ncfile_ext)
  }
  [$f3.ptpext subwidget label] config -font $tixOption(font)
  pack $f3.ptpext -fill x -anchor w -padx 10 -pady 15
  pack $f3.grp    -fill x -anchor w
  pack $f3.warn   -fill x -anchor w
  pack $f3.err    -fill x -anchor w
  pack $f3.rev    -fill x -anchor w
  checkbutton $f3a.chk -text "$gPB(listing,user_tcl,check,Label)" \
  -variable ListObjectAttr(usertcl_check) \
  -relief flat  -bd 2 -anchor w -padx 5 -width 30 \
  -command "UI_PB_lst__SetUserTclEntryState $page_obj"
  tixLabelEntry $f3a.name -label "$gPB(listing,user_tcl,name,Label)" \
  -options {
   label.width 10
   label.anchor w
   entry.width 27
   entry.anchor e
   entry.textVariable ListObjectAttr(usertcl_name)
  }
  [$f3a.name subwidget label] config -font $tixOption(font)
  set Page::($page_obj,usertcl_entry) $f3a.name
  pack $f3a.chk  -fill x -anchor w -pady 10
  pack $f3a.name -fill x -anchor w -padx 10 -pady 10
  UI_PB_lst__SetUserTclEntryState $page_obj
  if { [info exist ::env(SUB_POST)] && $::env(SUB_POST) == 1 } \
  {
   set rb_f [frame $f3c.fb]
   set en_f [frame $f3c.en]
   tixForm $rb_f  -top %10 -bottom %45 -left %0 -right %100
   tixForm $en_f  -top %55 -bottom %90 -left %3 -right %97
   radiobutton $rb_f.def -text "$gPB(listing,alt_unit,default,Label)" -variable ListObjectAttr(use_default_unit_fragment) \
   -relief flat -value 1 -bd 2 -width 15 -anchor w
   radiobutton $rb_f.sel -text "$gPB(listing,alt_unit,specify,Label)" -variable ListObjectAttr(use_default_unit_fragment) \
   -relief flat -value 0 -bd 2 -anchor w
   grid $rb_f.def -row 0 -column 0 -sticky {}
   grid $rb_f.sel -row 0 -column 1 -sticky {}
   entry $en_f.ent   -width 30 -relief sunken -textvariable ListObjectAttr(alt_unit_post_name) -state disabled
   button $en_f.but  -text "$gPB(listing,alt_unit,select_name,Label)" -command "__file_SelectAlterUnitPostFragment"
   pack $en_f.ent -side left
   pack $en_f.but -side right -padx 2
   $rb_f.def configure -command "__Switch_AlternateUnitPostFragement"
   $rb_f.sel configure -command "__Switch_AlternateUnitPostFragement"
   set gPB(alt_unit_fragment_wid) $en_f
   __Switch_AlternateUnitPostFragement
   set gPB(c_help,$rb_f.def)    "listing,alt_unit,default"
   set gPB(c_help,$rb_f.sel)    "listing,alt_unit,specify"
   set gPB(c_help,$en_f.ent)    "listing,alt_unit,post_name"
  }
  checkbutton $f3b.chk -text "$gPB(listing,link_var,check,Label)" \
  -variable ListObjectAttr(link_var) \
  -relief flat  -bd 2 -anchor w -padx 5 -width 30
  pack $f3b.chk -fill x -anchor w -pady 10
  if 0 {
   if { [PB_is_v $gPB(VNC_release)] && ![PB_is_v 4.0] } {
   }
  }
  set gPB(c_help,$f3.err)    "listing,output,verbose"
  set gPB(c_help,$f3.grp)    "listing,output,group"
  set gPB(c_help,$f3.warn)   "listing,output,warning"
  set gPB(c_help,$f3.rev)    "listing,output,review"
  set gPB(c_help,[$f3.ptpext subwidget entry]) "listing,nc_file"
  set gPB(c_help,$f3a.chk)                     "listing,user_tcl,check"
  set gPB(c_help,[$f3a.name subwidget entry])  "listing,user_tcl,name"
  set gPB(c_help,$f3b.chk)   "listing,link_var,check"
 }

#=======================================================================
proc __LoadAdvTurboPostCmds { args } {
  if { $::mom_sys_arr(\$mom_sys_advanced_turbo_output) } {
   set font_org              $::gPB(c_help,font)
   set ::gPB(c_help,font)    $::tixOption(font)
   set width_org             $::gPB(c_help,width)
   set ::gPB(c_help,width)   500
   UI_PB_chelp__display_msg "Enable Advanced Turbo Post Output" \
   "Mill posts of 3 to 5 axes with Advanced Turbo mode enabled\
   can improve the post-process performance by about 80%.\
   \n\nPost Builder automatically converts the output constructs of\
   Linear, Circular & Rapid motion events into the handlers required\
   to run post-process in turbo mode.\
   \n\nPost Builder will also add several special commands prefixed with \"PB_CMD__AdvTurboPost\"\
   that allow the users to further customize an Advanced Turbo Post. \
   These commands will be executed automatically at designated event handlers while NX/Post is\
   running in turbo mode."
   set ::gPB(c_help,font)    $font_org
   set ::gPB(c_help,width)   $width_org
   if { ![info exists ::gPB(ATP_CMDS_LOADED)] || !$::gPB(ATP_CMDS_LOADED) } {
    set ::gPB(ATP_CMDS_LOADED) 0
    set ATP_cmds { PB_CMD__AdvTurboPost__Customize_Post \
     PB_CMD__AdvTurboPost__config_before_motion \
     PB_CMD__AdvTurboPost__config_end_of_path \
    PB_CMD__AdvTurboPost__config_output }
    foreach cmd $ATP_cmds {
     if { [PB_com_FindObjFrmName $cmd command] > 0 } {
      set ::gPB(ATP_CMDS_LOADED) 1
      break
     }
    }
    if { $::gPB(ATP_CMDS_LOADED) } {
     set res [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type yesno -icon warning \
     -message "Your post contains Advanced Turbo commands already. \
     You may import these commands maually or overload them right away. \
     \n\nDo you want to proceed loading the commands now?"]
     if { $res == "no" } {
      unset ::gPB(ATP_CMDS_LOADED)
      return
      } else {
      set ::gPB(ATP_CMDS_LOADED) 0
     }
    }
    if { $::gPB(ATP_CMDS_LOADED) == 0 } {
     set tcl_file "$::env(PB_HOME)/pblib/pb_advanced_turbo_post_cmds.tcl"
     if { [file exists "$tcl_file"] && \
      [catch { PB_pps_CreateTclFileObjs ::post_object $tcl_file 1 }] } { ;#<Sep-23-2016 gsl> Error when "0" was used.
      return [error "$::gPB(msg,bad_tcl_file) : \n\n$errorInfo"]
     }
     set ::gPB(ATP_CMDS_LOADED) 1
    }
   }
  }
 }

#=======================================================================
proc UI_PB_list_DefListObjAttr { page_obj } {
  global ListObjectAttr
  global gPB
  PB_int_DefListObjAttr ListObjectAttr
  UI_PB_lst__SetUserTclEntryState $page_obj
  global post_object
  set list_file_obj $Post::($post_object,list_obj_list)
  set lfile_obj [lindex $list_file_obj 0]
  switch -exact -- $Page::($page_obj,page_name) \
  {
   lpt {
    set arr_temp_names {warn verbose review group ncfile_ext usertcl_check usertcl_name use_default_unit_fragment alt_unit_post_name}
   }
   oth {
    set arr_temp_names {listfile x y z 4axis 5axis feed speed lpt_ext}
   }
   pre {
   }
  }
  if { [info exist arr_temp_names] } {
   array set arr_temp_attr $ListingFile::($lfile_obj,restore_value)
   foreach name $arr_temp_names {
    set ListObjectAttr($name) $arr_temp_attr($name)
   }
  }
  if { ![string compare "oth" $Page::($page_obj,page_name)] } {
   set ::mom_sys_arr(\$mom_sys_advanced_turbo_output) $::def_mom_sys_arr(\$mom_sys_advanced_turbo_output)
   __Switch_AlternateUnitPostFragement
  }
 }

#=======================================================================
proc UI_PB_list_RestoreListObjAttr { page_obj } {
  global ListObjectAttr
  global gPB
  PB_int_RestoreListObjAttr ListObjectAttr
  UI_PB_lst__SetUserTclEntryState $page_obj
  if { ![string compare "oth" $Page::($page_obj,page_name)] } {
   set ::mom_sys_arr(\$mom_sys_advanced_turbo_output) $::rest_mom_sys_arr(\$mom_sys_advanced_turbo_output)
   __Switch_AlternateUnitPostFragement
  }
 }

#=======================================================================
proc UI_PB_list_ApplyListObjAttr { LIST_BOOK } {
  global ListObjectAttr
  upvar $LIST_BOOK list_book
  global mom_sys_arr
  switch -exact -- $Book::($list_book,current_tab) \
  {
   0 {
    PB_int_ApplyListObjAttr ListObjectAttr
   }
   1 {
    PB_int_ApplyListObjAttr ListObjectAttr
   }
   2 { ;# change it to post file review
   }
  }
 }

#=======================================================================
proc UI_PB_lst__SetUserTclEntryState { page_obj } {
  global ListObjectAttr
  global paOption gPB
  if { 0 && [info exists Page::($page_obj,warn_opt)] && \
   [winfo exists $Page::($page_obj,warn_opt)] } {
   if $ListObjectAttr(warn) { set state normal } else { set state disabled }
   $Page::($page_obj,warn_opt) config -state $state
  }
  if { [info exists Page::($page_obj,usertcl_entry)] && \
   [winfo exists $Page::($page_obj,usertcl_entry)] } {
   set usertcl_entry $Page::($page_obj,usertcl_entry)
   set ent_wdg [$usertcl_entry subwidget entry]
   switch $ListObjectAttr(usertcl_check) \
   {
    0 {
     $ent_wdg config -state disabled -fg $paOption(disabled_fg) \
     -bg $paOption(entry_disabled_bg)
    }
    1 {
     $ent_wdg config -state normal -fg black -bg $gPB(entry_color)
     focus $ent_wdg
     $ent_wdg icursor end
    }
   }
  }
 }

#=======================================================================
proc __isv_SetVNCPageStatus { page_obj} {
  global mom_sys_arr
  if [info exists Page::($page_obj,page_id)] {
   set page_id $Page::($page_obj,page_id)
   set dis_pan $page_id.pane
   if { $mom_sys_arr(Output_VNC) ==  0 } {
    UI_PB_com_DisableWindow $dis_pan
    } else {
    UI_PB_com_EnableWindow $dis_pan
    __isv_ChangeSetupTreeStatus
   }
  }
 }

#=======================================================================
proc UI_PB_isv_UpdateDefPageParams {} {
  global mom_sys_arr gPB
  global mom_sim_arr rest_mom_sim_arr
  global post_object isv_def_id
  if {![info exists mom_sys_arr(Output_VNC)] || \
   ($mom_sys_arr(Output_VNC) == 0)} {
   return
  }
  PB_int_UpdateSIMVar mom_sim_arr
  array set rest_mom_sim_arr [array get mom_sim_arr]
  set Post::($post_object,rest_mom_sim_var_list) [array get mom_sim_arr]
  set page_obj $isv_def_id
  Post::GetObjList $post_object command all_cmd_list
  set gPB(rest_cmd_obj_list) $all_cmd_list
  foreach item $all_cmd_list {
   command::RestoreValue $item
  }
  if [info exists gPB(pre_list,index)] {
   set gPB(pre_list,rest_index) $gPB(pre_list,index)
  }
 }

#=======================================================================
proc UI_PB_isv_UpdateReviewPageParams {} {
  global mom_sys_arr
  global mom_sim_arr rest_mom_sim_arr
  global isv_rev_id post_object
  PB_int_UpdateMOMVar mom_sys_arr
  PB_int_UpdateSIMVar mom_sim_arr
  set rev_page_obj $isv_rev_id
  UI_PB_cmd_DeleteCmdProc $rev_page_obj
  if [info exists Page::($rev_page_obj,active_cmd_obj)] \
  {
   unset Page::($rev_page_obj,active_cmd_obj)
  }
  array set rest_mom_sim_arr [array get mom_sim_arr]
  set Post::($post_object,rest_mom_sim_var_list) [array get mom_sim_arr]
  Post::GetObjList $post_object command all_cmd_list
  set gPB(rest_cmd_obj_list) $all_cmd_list
  foreach item $all_cmd_list {
   command::RestoreValue $item
  }
 }

#=======================================================================
proc UI_PB_isv_DeleteTabAttr { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  global mom_sim_arr mom_sys_arr
  switch -exact -- $Book::($book_obj,current_tab) \
  {
   0 {
    UI_PB_isv_UpdateDefPageParams
   }
   1 {
    UI_PB_isv_UpdateReviewPageParams
   }
  }
 }

#=======================================================================
proc UI_PB_isv_CreateTabAttr { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  global gPB
  switch -exact -- $Book::($book_obj,current_tab) \
  {
   0 {
    UI_PB_com_SetStatusbar "$gPB(isv,Status)"
    set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
    UI_PB_isv_CreateDefTabAttr page_obj
   }
   1 {
    UI_PB_com_SetStatusbar "$gPB(isv,review,Status)"
    set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
    UI_PB_isv_CreateRevTabAttr page_obj
   }
  }
 }

#=======================================================================
proc UI_PB_isv_CreateDefTabAttr { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global mom_sim_arr
  global mom_sys_arr
  global post_object gPB
  global rest_mom_sim_arr
  global rest_mom_sys_arr
  Post::GetObjList $post_object command all_cmd_list
  set gPB(rest_cmd_obj_list) $all_cmd_list
  if { $mom_sys_arr(Output_VNC) && [info exists Post::($post_object,rest_mom_sim_var_list)] } {
   __isv_setup_RestoreCallBack 0
  }
  set add_name $gPB(isv_addname)
  set gPB(isv_datatype) [__isv_SetAddrValidateFmt]
  set data_type $gPB(isv_datatype)
  if {[info exists Page::($page_obj,gcodent_list_1)]} {
   set win_list $Page::($page_obj,gcodent_list_1)
   foreach win $win_list {
    __isv_ValidateFormat_Binding $add_name $data_type $win
   }
  }
  if { [info exists Page::($page_obj,gcodent_list_2)] } {
   set win_list $Page::($page_obj,gcodent_list_2)
   foreach win $win_list {
    __isv_ValidateFormat_Binding $add_name $data_type $win
   }
  }
  global paOption gpb_addr_var
  if {[info exists Page::($page_obj,gcodlbl_list_1)]} {
   set lbl_list $Page::($page_obj,gcodlbl_list_1)
   foreach lbl $lbl_list {
    set lbl_var [$lbl cget -textvariable]
    if {[string match "" [set $lbl_var]]} {
     $lbl configure -bg $::SystemButtonFace
     } else {
     $lbl configure -bg $paOption(special_bg)
    }
   }
  }
  if {[info exists Page::($page_obj,gcodlbl_list_2)]} {
   set lbl_list $Page::($page_obj,gcodlbl_list_2)
   foreach lbl $lbl_list {
    set lbl_var [$lbl cget -textvariable]
    if {[string match "" [set $lbl_var]]} {
     $lbl configure -bg $::SystemButtonFace
     } else {
     $lbl configure -bg $paOption(special_bg)
    }
   }
  }
  if { [info exists gPB(pre_list)] } {
   if [info exists gPB(pre_list,rest_index)] {
    set gPB(pre_list,index) $gPB(pre_list,rest_index)
   }
   __isv_RecreateLeftSpec
  }
 }

#=======================================================================
proc UI_PB_isv_CreateRevTabAttr { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global mom_sim_arr mom_sys_arr
  global post_object gPB
  global rest_mom_sim_arr
  global rest_mom_sys_arr
  Post::GetObjList $post_object command all_cmd_list
  set gPB(rest_cmd_obj_list) $all_cmd_list
  if { $mom_sys_arr(Output_VNC) && [info exists Post::($post_object,rest_mom_sim_var_list)] } {
   array set mom_sim_arr $Post::($post_object,rest_mom_sim_var_list)
   __isv_RestoreCallBack $page_obj
  }
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set index [string range $ent 2 end]
  if { [string compare $index ""] == 0 } \
  {
   set index 0
  }
  __isv_DisplayCodeNameList page_obj index
  __isv_CodeItemSelection $page_obj
 }

#=======================================================================
proc __lst_CheckVNCFile { page_obj } {
  global mom_sys_arr
  if { $mom_sys_arr(Output_VNC) == 0 } {
   return
   } elseif { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
   return
   } elseif {![string match "*_vnc.tcl" $mom_sys_arr(Main_VNC)] } {
   __lst__SetVNCRefSelectSens $page_obj
  }
 }

#=======================================================================
proc __isv_SetVNCSwitchSense { page_obj frame } {
  global mom_sys_arr
  global post_object
  global paOption tixOption
  global gPB
  if { [PB_is_v $gPB(VNC_release)] == 0 } {
   set mom_sys_arr(Output_VNC) 0
   set mom_sys_arr(Main_VNC) ""
   set mom_sys_arr(VNC_Mode) "Standalone"
   PB_int_UpdateMOMVar mom_sys_arr
  }
  set bg_clr $paOption(header_bg)
  set g33 [frame $frame.3 -bg $bg_clr -relief raised -bd 2]
  set gPB(vnc_param) $g33
  set g3 [frame $g33.frame -bg $bg_clr]
  pack $g3 -pady 1 -fill x ;#<01-17-08 gsl> added -fill
  if 0 {
   checkbutton $g3.vnc   -text "$gPB(output,vnc,output,Label)" \
   -command "__lst__SetVNCOutputOptionSens $page_obj" \
   -variable mom_sys_arr(Output_VNC) \
   -relief solid -bd 2 -font $tixOption(bold_font) \
   -anchor c -padx 12 -pady 9 -bg #ffff99 ;# yellow
  }
  checkbutton $g3.vnc   -text "$gPB(output,vnc,output,Label)" \
  -highlightthickness 0 \
  -command "__lst__SetVNCOutputOptionSens $page_obj" \
  -variable mom_sys_arr(Output_VNC) \
  -relief solid -bd 2 -font $tixOption(bold_font) \
  -anchor c -padx 12 -pady 7 -fg black -bg lightYellow
  ;# white ;# gray90 ;# lemonChiffon1 ;# lightCyan ;# paleGoldenRod
  frame $g3.opt -bg $bg_clr
  pack $g3.vnc -side left  -padx 10 -fill x -expand yes
  pack $g3.opt -side right -padx 0  -fill x -expand yes
  set f3v  $g3.opt
  radiobutton $f3v.std -text "$gPB(output,vnc,mode,std,Label)" \
  -highlightthickness 0 \
  -variable mom_sys_arr(VNC_Mode) -bg $bg_clr -fg $paOption(special_fg) \
  -value Standalone -command "__lst__SetVNCRefSelectSens $page_obj"
  radiobutton $f3v.sub -text "$gPB(output,vnc,mode,sub,Label)" \
  -highlightthickness 0 \
  -variable mom_sys_arr(VNC_Mode) -bg $bg_clr -fg $paOption(special_fg)\
  -value Subordinate -command "__lst__SetVNCRefSelectSens $page_obj"
  set vnc [frame $f3v.vnc -bd 1 -relief sunken]
  pack $f3v.std $f3v.sub -side left -pady 5 -fill x -expand yes
  pack $f3v.vnc          -side left -padx 10 -pady 5 -fill x -expand yes
  entry $vnc.ent -width 20 -relief sunken -textvariable mom_sys_arr(Main_VNC)
  bind $vnc.ent <FocusOut> "__lst_CheckVNCFile $page_obj"
  label  $vnc.lbl -text "$gPB(output,vnc,main,Label)" \
  -font $tixOption(bold_font) \
  -padx 5 -pady 2
  button $vnc.but -text "$gPB(output,vnc,main,select_name,Label)" \
  -command "__lst_SelectVNCFile"
  if { ![info exists gPB(current_VNC_Mode)] } {
   set gPB(current_VNC_Mode) ""
  }
  UI_PB_debug_ForceMsg "\n gPB(current_VNC_Mode) : $gPB(current_VNC_Mode)  mom_sys_arr(VNC_Mode) : $mom_sys_arr(VNC_Mode) \n"
  set gPB(current_VNC_Mode) $mom_sys_arr(VNC_Mode)
  pack $vnc.but -side right -padx 3 -pady 2 -fill x -expand yes
  pack $vnc.lbl $vnc.ent -side left -padx 0 -pady 2 -fill x -expand yes
  PB_enable_balloon $vnc.ent
  global gPB_help_tips
  set gPB_help_tips($vnc.ent)   {$mom_sys_arr(Main_VNC)}
  pack $g33 -padx 5 -pady 5 -fill x -expand yes
  set gPB(c_help,$g3.vnc)      "output,vnc,output"
  set gPB(c_help,$g3.opt)      "output,vnc,mode"
  set gPB(c_help,$g3.opt.std)  "output,vnc,mode,std"
  set gPB(c_help,$g3.opt.sub)  "output,vnc,mode,sub"
  set gPB(c_help,$vnc.ent)     "output,vnc,main"
  set gPB(c_help,$vnc.but)     "output,vnc,main,select_name"
  __lst__SetVNCOutputOptionSens $page_obj
 }

#=======================================================================
proc __isv_ChangeSetupTreeStatus { } {
  global gPB mom_sys_arr
  global isv_def_id
  if {![info exists isv_def_id]} { return }
  set page_obj $isv_def_id
  if {![info exists Page::($page_obj,tree)]} {
   return
  }
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  if { $mom_sys_arr(Output_VNC) == 0} {
   return
  }
  if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
   $h entryconfig 0.1.0 -style $gPB(font_style_normal) -state normal
   $h entryconfig 0.1.1 -style $gPB(font_style_normal) -state normal
   if [$h info exists 0.2] {
    $h entryconfig 0.2 -style $gPB(font_style_bold) -state normal
    $h entryconfig 0.2.0 -style $gPB(font_style_normal) -state normal
    $h entryconfig 0.2.1 -style $gPB(font_style_normal) -state normal
   }
   } else {
   set ent [$h info selection]
   if {![string match "0.0" $ent] &&  \
    ![string match "0.1.2" $ent]} {
    $h selection clear
    $h anchor clear
    $h selection set 0.0
    $h anchor set 0.0
    __isv_setup_ItemSelection $h 0.0
   }
   $h entryconfig 0.1.0 -style $gPB(font_style_normal_gray) -state disabled
   $h entryconfig 0.1.1 -style $gPB(font_style_normal_gray) -state disabled
   if [$h info exists 0.2] {
    $h entryconfig 0.2   -style $gPB(font_style_bold_gray)   -state disabled
    $h entryconfig 0.2.0 -style $gPB(font_style_normal_gray) -state disabled
    $h entryconfig 0.2.1 -style $gPB(font_style_normal_gray) -state disabled
   }
  }
 }

#=======================================================================
proc __isv_SetTabSense { book_name flag } {
  global paOption gPB
  return
  set pg_list [$book_name pages]
  foreach pg $pg_list {
   set image [$book_name pagecget $pg -image]
   if { [string match "gray" $flag] } {
    if 0 {
     if {[string match "def" $pg]} {
      set label $gPB(isv,setup,Label)
      } else {
      set label $gPB(isv,vnc_command,Label)
     }
    }
    $image config -foreground gray
    } else {
    $image config -foreground blue
   }
  }
 }

#=======================================================================
proc __lst__SetVNCOutputOptionSens { page_obj } {
  global paOption
  global mom_sys_arr mom_sim_arr rest_mom_sim_arr
  global gPB post_object
  if { $mom_sys_arr(Output_VNC) } {
   PB_InitialVNC_Seqlist
   __isv_initialSIMVars
  }
  set g33 $gPB(vnc_param)
  set g3 $g33.frame
  set f3v $g3.opt
  set book_name $Book::($page_obj,book_id)
  set pg_list [$book_name pages]
  set pg_path_list [list]
  foreach it $Book::($page_obj,page_obj_list) {
   if { [info exists Page::($it,page_id)] } {
    lappend pg_path_list $Page::($it,page_id)
   }
  }
  if { $mom_sys_arr(Output_VNC) } {
   $f3v.std config -state normal
   $f3v.sub config -state normal
   foreach pg $pg_list {
    $book_name pageconfigure $pg -state normal
    __isv_SetTabSense $book_name normal
   }
   foreach pg $pg_path_list {
    UI_PB_com_EnableWindow $pg.pane
   }
   __lst__SetVNCRefSelectSens $page_obj
   } else {
   $f3v.std config -state disabled
   $f3v.sub config -state disabled
   $f3v.vnc.lbl config -fg $paOption(disabled_fg)
   $f3v.vnc.ent config -fg $paOption(disabled_fg) -bg $paOption(entry_disabled_bg) \
   -state disabled
   $f3v.vnc.but config -state disabled
   foreach pg $pg_list {
    set sta [$book_name pageconfig $pg -state]
    set gPB(sens,state,$book_name._$pg) [lindex $sta end]
    $book_name pageconfigure $pg -state disabled
    __isv_SetTabSense $book_name gray
   }
   foreach pg $pg_path_list {
    UI_PB_com_DisableWindow $pg
   }
  }
  if { $mom_sys_arr(Output_VNC) } {
   UI_PB_isv_UpdateDefPageParams
  }
 }

#=======================================================================
proc __lst__SetVNCRefSelectSens { page_obj } {
  global paOption gPB post_object
  global mom_sys_arr mom_sim_arr
  set g33 $gPB(vnc_param)
  set g3 $g33.frame
  set f3v $g3.opt
  set book_id $Book::($page_obj,book_id)
  $f3v.vnc.lbl config -fg black
  if { ![string match "$gPB(current_VNC_Mode)" $mom_sys_arr(VNC_Mode)] } {
   UI_PB_debug_ForceMsg "\n gPB(current_VNC_Mode) : $gPB(current_VNC_Mode)  mom_sys_arr(VNC_Mode) : $mom_sys_arr(VNC_Mode) \n"
   UI_PB_debug_ForceMsg "\n page_obj : $page_obj <= isv_rev_id : $::isv_rev_id \n"
   if { [info exists Page::($::isv_rev_id,buff_cmd_obj)] } {
    if [string match "Standalone" $gPB(current_VNC_Mode)] {
     set ::isv_main_buff_cmd_obj $Page::($::isv_rev_id,buff_cmd_obj)
     UI_PB_debug_ForceMsg "\n ::isv_main_buff_cmd_obj : $::isv_main_buff_cmd_obj \n"
     } else {
     set ::isv_sub_buff_cmd_obj  $Page::($::isv_rev_id,buff_cmd_obj)
     UI_PB_debug_ForceMsg "\n ::isv_sub_buff_cmd_obj : $::isv_sub_buff_cmd_obj \n"
    }
    unset Page::($::isv_rev_id,buff_cmd_obj)
   }
   if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
    if [info exists ::isv_main_buff_cmd_obj] {
     UI_PB_debug_ForceMsg "\n Restore ::isv_main_buff_cmd_obj : $::isv_main_buff_cmd_obj \n"
     set Page::($::isv_rev_id,buff_cmd_obj) $::isv_main_buff_cmd_obj
    }
    } else {
    if { [info exists ::isv_sub_buff_cmd_obj] } {
     UI_PB_debug_ForceMsg "\n Restore ::isv_sub_buff_cmd_obj : $::isv_sub_buff_cmd_obj \n"
     set Page::($::isv_rev_id,buff_cmd_obj) $::isv_sub_buff_cmd_obj
    }
   }
  }
  if { [string match "Subordinate" $mom_sys_arr(VNC_Mode)] } {
   if { ![info exists mom_sys_arr(Main_VNC)] || [string match "" $mom_sys_arr(Main_VNC)] } {
    set reg [__lst_SelectVNCFile]
    if !$reg {
     set mom_sys_arr(VNC_Mode) "Standalone"
     __lst__SetVNCRefSelectSens $page_obj
    }
   }
   if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
    $f3v.vnc.but config -state disabled
    $f3v.vnc.ent config -state disabled \
    -fg $paOption(disabled_fg) -bg $paOption(entry_disabled_bg)
    } else {
    $f3v.vnc.but config -state normal
    $f3v.vnc.ent config -state normal \
    -fg black -bg $gPB(entry_color)
   }
   } else {
   $f3v.vnc.but config -state disabled
   $f3v.vnc.ent config -state disabled \
   -fg $paOption(disabled_fg) -bg $paOption(entry_disabled_bg)
  }
  set gPB(current_VNC_Mode) $mom_sys_arr(VNC_Mode)
  if { $mom_sys_arr(Output_VNC) } {
   if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
    set gPB(vnc_tag) 1
    } else {
    set gPB(vnc_tag) 0
   }
   if { ![info exists gPB(vnc_old_tag)] } {
    set same_tag 1
    } else {
    if {![string match "$gPB(vnc_tag)" $gPB(vnc_old_tag)]} {
     set same_tag 1
     } else {
     set same_tag 0
    }
   }
   set gPB(vnc_old_tag) $gPB(vnc_tag)
   __isv_ChangeSetupTreeStatus
   if { $same_tag } {
    PB_GetVncCommandFrmPostObj
    __isv_UpdateNCCommandList $page_obj $same_tag
    PB_int_UpdateSIMVar mom_sim_arr
    __isv_GetCommandDisplayList disp_com_list
    PB_int_RetCmdBlks cmd_obj_list
    set gPB(def_cmd_obj_list) $cmd_obj_list
    if {[string match "1" $Book::($page_obj,current_tab)]} {
     set rev_page_obj [lindex $Book::($page_obj,page_obj_list) 1]
     set index 0
     if {[info exists Page::($rev_page_obj,active_cmd_obj)]} {
      unset Page::($rev_page_obj,active_cmd_obj)
     }
     if {[info exists Page::($rev_page_obj,selected_index)]} {
      unset Page::($rev_page_obj,selected_index)
     }
     UI_PB_cmd_DeleteCmdProc $rev_page_obj
     __isv_DisplayCodeNameList rev_page_obj index
     __isv_CodeItemSelection $rev_page_obj
     } else {
     if { [info exists gPB(pre_list)] } {
      __isv_RecreateLeftSpec
     }
    }
   }
  }
 }

#=======================================================================
proc __lst_SelectVNCFile { } {
  global gPB
  global tcl_platform
  global mom_sys_arr
  UI_PB_com_SetStatusbar "Select a VNC file."
  if { [info exists mom_sys_arr(Main_VNC)] } {
   set gPB(master_VNC) $mom_sys_arr(Main_VNC)
  }
  if { ![info exists gPB(master_VNC)] } {
   set gPB(master_VNC) ""
  }
  set master_VNC $gPB(master_VNC)
  switch $tcl_platform(platform) {
   unix {
    UI_PB_file_SelectFile_unx TCL gPB(master_VNC) open
   }
   windows {
    UI_PB_com_GrayOutSaveOptions
    UI_PB_com_DisableMain
    UI_PB_file_SelectFile_win TCL gPB(master_VNC) open
    UI_PB_com_EnableMain
    UI_PB_com_UnGraySaveOptions
    __isv_ChangeSetupTreeStatus
   }
  }
  set gPB(master_VNC) [string trim $gPB(master_VNC) \"]
  if { [file exists $gPB(master_VNC)] } {
   if { ![string match "$master_VNC" $gPB(master_VNC)] } {
    if { ![string match "*_vnc.tcl" $gPB(master_VNC)] && [string length $gPB(master_VNC)] } {
     set res [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type yesno -icon warning \
     -message "$gPB(output,vnc,mis_match,Label)"]
     if { [string match "yes" $res] } {
      __lst_SelectVNCFile
     }
    }
   }
   set gPB(current_VNC_Mode) $mom_sys_arr(VNC_Mode)
   set gPB(master_vnc_dir) [file dirname $gPB(master_VNC)]
   set mom_sys_arr(Main_VNC) [file tail $gPB(master_VNC)]
   return 1
   } else {
   set mom_sys_arr(VNC_Mode) $gPB(current_VNC_Mode)
   return 0
  }
 }

#=======================================================================
proc UI_PB_isv_SetInitalStatus { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  global paOption gPB
  global mom_sys_arr
  if { [info exists gPB(vnc_param)] } {
   set g33 $gPB(vnc_param)
   set g3 $g33.frame
   set f3v $g3.opt
   set book_name $Book::($book_obj,book_id)
   set pg_list [$book_name pages]
   if $mom_sys_arr(Output_VNC) {
    $f3v.std config -state normal
    $f3v.sub config -state normal
    foreach pg $pg_list {
     $book_name pageconfig $pg -state normal
    }
    } else {
    $f3v.std config -state disabled
    $f3v.sub config -state disabled
    $f3v.vnc.lbl config -fg $paOption(disabled_fg)
    $f3v.vnc.ent config -fg $paOption(disabled_fg) -bg $paOption(entry_disabled_bg) \
    -state disabled
    $f3v.vnc.but config -state disabled
    foreach pg $pg_list {
     $book_name pageconfig $pg -state disabled
    }
   }
   global LicInfo
   if { [info exists LicInfo(user_right_limit)] && $LicInfo(user_right_limit) == "YES" } {
    $g3.vnc      config -state disabled
    $f3v.std     config -state disabled
    $f3v.sub     config -state disabled
    $f3v.vnc.ent config -state disabled
    $f3v.vnc.but config -state disabled
    $book_name pageconfig [lindex $pg_list 0] -state disabled
    $book_name pageconfig [lindex $pg_list 1] -state disabled
   }
   if { $gPB(PB_LICENSE) == "UG_POST_AUTHOR" &&\
    [info exists LicInfo(SITE_ID_IS_OK_FOR_PT)] && $LicInfo(SITE_ID_IS_OK_FOR_PT) == 0 &&\
    [lsearch $gPB(lic_list) $LicInfo(post_license)] >= 0 } {
    $g3.vnc      config -state disabled
    $f3v.std     config -state disabled
    $f3v.sub     config -state disabled
    $f3v.vnc.ent config -state disabled
    $f3v.vnc.but config -state disabled
   }
  }
 }

#=======================================================================
proc UI_PB_vnc_AddRevPostPage { book_id page_book_obj } {
  global tixOption
  global paOption
  global gPB pb_cmd_procname
  global post_object
  global isv_book_id isv_def_id isv_rev_id
  set f [$book_id subwidget $Page::($page_book_obj,page_name)]
  set w [tixNoteBook $f.nb -ipadx 5 -ipady 5]
  [$w subwidget nbframe] config -tabpady 0
  set isv_book [new Book w]
  set isv_book_id $isv_book
  set Page::($page_book_obj,book_obj) $isv_book
  set top_frm [frame $f.top -height 100]
  pack $top_frm -side top -fill x ;# both
  pack $f.nb -side top -expand yes -fill both
  set Book::($isv_book,x_def_tab_img) 0
  set Book::($isv_book,current_tab) -1
  Book::CreatePage $isv_book stp "$gPB(isv,setup,Label)"       ""  __isv_AddDefinitionsPage __isv_SetupDefTab
  Book::CreatePage $isv_book cod "$gPB(isv,vnc_command,Label)" ""  __isv_AddReviewCodePage  __isv_ReviewCodeTab
  set isv_def_id [Book::RetPageObj $isv_book stp] ;#<Aug-24-2017 gsl> "stp" was "def".
  set isv_rev_id [Book::RetPageObj $isv_book cod] ;#<May-22-2017 gsl> "cod" was "rev".
  __isv_SetVNCSwitchSense $isv_book $top_frm
 }

#=======================================================================
proc __isv_InputWCSToolInfo {} {
  global gPB mom_sim_arr rest_mom_sim_arr
  global mom_sim_tool_data mom_sim_wcs_offsets
  global post_object
  array set mom_sim_arr $Post::($post_object,mom_sim_var_list)
  __isv_Distroy_WCSTable
  __isv_Distroy_ToolTable
  set item_list $gPB(tool_item_list)
  set mom_sim_arr(\$mom_sim_tool_list) [lsort -increasing $mom_sim_arr(\$mom_sim_tool_list)]
  foreach tool $mom_sim_arr(\$mom_sim_tool_list) {
   foreach item $item_list {
    set rest_mom_sim_arr(\$mom_sim_tool_data\($tool,$item\))  \
    $mom_sim_arr(\$mom_sim_tool_data\($tool,$item\))
    unset mom_sim_arr(\$mom_sim_tool_data\($tool,$item\))
   }
  }
  set rest_mom_sim_arr(\$mom_sim_tool_list) $mom_sim_arr(\$mom_sim_tool_list)
  unset mom_sim_arr(\$mom_sim_tool_list)
  if [array exists mom_sim_tool_data] {
   set t_list [array names mom_sim_tool_data]
   foreach it $t_list {
    unset mom_sim_tool_data($it)
   }
  }
  set item_list [list x y z a b c]
  foreach item $mom_sim_arr(\$mom_sim_wcsnum_list) {
   set rest_mom_sim_arr(\$mom_sim_wcs_offsets\($item\)) $mom_sim_arr(\$mom_sim_wcs_offsets\($item\))
   unset mom_sim_arr(\$mom_sim_wcs_offsets\($item\))
   foreach it $item_list {
    unset gPB($item,$it)
   }
  }
  set rest_mom_sim_arr(\$mom_sim_wcsnum_list) $mom_sim_arr(\$mom_sim_wcsnum_list)
  unset mom_sim_arr(\$mom_sim_wcsnum_list)
  if [array exists mom_sim_wcs_offsets] {
   set w_list [array names mom_sim_wcs_offsets]
   foreach it $w_list {
    unset mom_sim_wcs_offsets($it)
   }
  }
  catch { source $gPB(setup_data_file) }
  set gPB(zero_off_x) [lindex $mom_sim_machine_zero_offsets 0]
  set gPB(zero_off_y) [lindex $mom_sim_machine_zero_offsets 1]
  set gPB(zero_off_z) [lindex $mom_sim_machine_zero_offsets 2]
  set mom_sim_arr(\$mom_sim_machine_zero_offsets) $mom_sim_machine_zero_offsets
  if [array exists mom_sim_wcs_offsets] {
   set mom_sim_arr(\$mom_sim_wcsnum_list) [array names mom_sim_wcs_offsets]
   foreach item $mom_sim_arr(\$mom_sim_wcsnum_list) {
    set mom_sim_arr(\$mom_sim_wcs_offsets\($item\)) $mom_sim_wcs_offsets($item)
   }
   if ![info exists mom_sim_wcs_offsets(0)] {
    set mom_sim_arr(\$mom_sim_wcs_offsets\(0\)) [list 0.0 0.0 0.0 0.0 0.0 0.0]
    lappend mom_sim_arr(\$mom_sim_wcsnum_list) 0
   }
   } else {
   set mom_sim_arr(\$mom_sim_wcsnum_list) [list]
  }
  set lenth [array size mom_sim_tool_data]
  set tool_array_list [array names mom_sim_tool_data]
  set tool_array_list [lsort -increasing $tool_array_list]
  set tool_list [list]
  foreach tool $tool_array_list {
   set single_tool_list [split $tool ","]
   set tool_number [lindex $single_tool_list 0]
   if {[lsearch $tool_list $tool_number] < 0} {
    lappend tool_list $tool_number
   }
  }
  set mom_sim_arr(\$mom_sim_tool_list) $tool_list
  foreach tool $tool_array_list {
   set mom_sim_arr(\$mom_sim_tool_data\($tool\)) $mom_sim_tool_data($tool)
  }
  set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
  set Post::($post_object,rest_mom_sim_var_list) [array get rest_mom_sim_arr]
  __isv_Redisplay_WCSTable
  __isv_Redisplay_ToolTable
 }

#=======================================================================
proc __isv_ImportSetupDataFile {} {
  global gPB post_object
  global tcl_platform
  global mom_sys_arr
  if { [UI_PB_isv_setup_ValidateToolname 1] } {
   return
  }
  UI_PB_com_SetStatusbar "Import Program Definition file."
  set post_name $Post::($post_object,post_name)
  set out_dir $Post::($post_object,output_dir)
  set init_file ""
  set acwin [UI_PB_com_AskActiveWindow]
  set win $acwin.__tk_filedialog
  set gPB(main_window).save_as $win
  UI_PB_com_ClaimActiveWindow $win
  UI_PB_com_DisableMain
  UI_PB_GrayOutAllFileOptions
  set types {
   { {Program Definition File} {.tcl} }
  }
  $gPB(c_help,tool_button) config -state disabled
  $gPB(main_menu_bar).file.m entryconfigure $gPB(menu_index,file,exit) -state disabled
  set filename [tk_getOpenFile -title "$gPB(isv,input,setup_data,Label)" \
  -defaultextension "tcl" \
  -filetypes $types \
  -initialfile $init_file \
  -initialdir $out_dir \
  -parent $acwin]
  if { ($filename != "") && ![string match "*_setup.tcl" $filename]} {
   set err_msg "$gPB(isv,setup,file_err,Msg)"
   set res [tk_messageBox -parent $acwin -type yesno -icon error \
   -title $gPB(msg,dialog,title) \
   -message "$gPB(isv,setup,file_err,Msg)"]
   if [string match "yes" $res] {
    __isv_ImportSetupDataFile
   }
   } elseif { $filename != ""} {
   set gPB(setup_data_file) $filename
   __isv_InputWCSToolInfo
   } else {
  }
  UI_PB_com_DelistActiveWindow $win
  UI_PB_com_ClaimActiveWindow $acwin
  UI_PB_com_EnableMain
  $gPB(c_help,tool_button) config -state normal
  $gPB(main_menu_bar).help.m entryconfigure $gPB(menu_index,help,chelp) -state normal
  UI_PB_ActivateOpenFileOpts
 }

#=======================================================================
proc __isv_SelectSetupDataFile {} {
  global gPB post_object
  global tcl_platform
  global mom_sys_arr
  global isv_def_id
  global gPB
  if { [UI_PB_isv_setup_ValidateToolname 1] } {
   return
  }
  set page_obj $isv_def_id
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  set def_item [$h selection get]
  switch $def_item \
  {
   0.2.0 { set def_item 2.0 }
   0.2.1 { set def_item 2.1 }
  }
  if { [UI_PB_isv_setup_ValidateEmptyEntry $def_item] } {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -message $gPB(machine,empty_entry_err,msg) \
   -icon error
   return
  }
  UI_PB_com_SetStatusbar "Select a Program Definition file."
  set post_name $Post::($post_object,post_name)
  set out_dir $Post::($post_object,output_dir)
  set init_file [file join $out_dir ${post_name}_setup.tcl]
  set acwin [UI_PB_com_AskActiveWindow]
  set win $acwin.__tk_filedialog
  set gPB(main_window).save_as $win
  UI_PB_com_ClaimActiveWindow $win
  UI_PB_com_DisableMain
  UI_PB_GrayOutAllFileOptions
  $gPB(c_help,tool_button) config -state disabled
  set gPB(save_as_now) 1
  $gPB(main_menu_bar).file.m entryconfigure $gPB(menu_index,file,exit) -state disabled
  set filename [tk_getSaveFile -title "$gPB(isv,output,setup_data,Label)" \
  -defaultextension "tcl" \
  -initialfile $init_file \
  -initialdir $out_dir \
  -parent $acwin]
  if { ($filename != "") && ![string match "*_setup.tcl" $filename]} {
   set res [tk_messageBox -parent $acwin -type yesno -icon error \
   -title $gPB(msg,dialog,title) \
   -message $gPB(isv,setup,file_err,Msg)]
   if [string match "yes" $res] {
    __isv_SelectSetupDataFile
   }
   } elseif { $filename != ""} {
   set gPB(setup_data_file) $filename
   __isv_OutputWCSToolInfo
   } else {
  }
  UI_PB_com_DelistActiveWindow $win
  UI_PB_com_ClaimActiveWindow $acwin
  UI_PB_com_EnableMain
  $gPB(c_help,tool_button) config -state normal
  $gPB(main_menu_bar).help.m entryconfigure $gPB(menu_index,help,chelp) -state normal
  UI_PB_ActivateOpenFileOpts
 }

#=======================================================================
proc __isv_SetAddrValidateFmt {} {
  global gPB
  set add_name "G"
  set gPB(isv_addname) $add_name
  PB_int_RetAddrObjFromName add_name add_obj
  if { $add_obj } \
  {
   address::readvalue $add_obj add_obj_attr
   format::readvalue $add_obj_attr(1) fmt_obj_attr
   switch $fmt_obj_attr(1) \
   {
    "Numeral"     {
     if { $fmt_obj_attr(6) } \
     {
      set data_type f
     } else \
     {
      set data_type i
     }
    }
    "Text String" {
     set data_type s
    }
   }
  } else \
  {
   set data_type s
  }
  return $data_type
 }

#=======================================================================
proc __isv_AddDefinitionsPage { book_id page_obj } {
  global paOption tixOption
  global mom_sys_arr mom_sim_arr
  global gPB post_object
  global isv_def_id
  set isv_def_id $page_obj
  array set mom_sim_arr $Post::($post_object,mom_sim_var_list)
  __isv_SetDefSimVars
  set gPB(def_pageid) [$book_id subwidget $Page::($page_obj,page_name)]
  set Page::($page_obj,page_id) $gPB(def_pageid)
  __isv_SetPageAttributes page_obj
  set Page::($page_obj,prev_seq) 0.0
  Page::CreatePane $page_obj
  Page::CreateTree $page_obj
  __isv_setup_CreateTree
  set canvas_frame $Page::($page_obj,canvas_frame)
  pack $canvas_frame -fill both -expand yes
  set top_frame [frame $canvas_frame.top -height 30]
  set bot_frame [frame $canvas_frame.bot]
  set Page::($page_obj,top_frame) $top_frame
  set Page::($page_obj,bot_frame) $bot_frame
  pack $bot_frame -fill both -expand yes
  set Page::($page_obj,top_flag) 0
  set frm_bg $paOption(name_bg) ;#$paOption(header_bg) ;#$paOption(table_bg) ;#$paOption(special_bg)
  set frm_fg #ffff99 ;#yellow $paOption(title_fg)
  set top_sub1 [frame $top_frame.sub1 -bg $frm_bg -relief sunken -bd 1]
  pack $top_sub1 -pady 7 ;# -fill x -expand yes
  set prog_lbl [label $top_sub1.lbl -text "$gPB(isv,prog,setup_right,Label)" -font $tixOption(bold_font) \
  -bg $frm_bg -fg $frm_fg]
  set top_sub  [frame $top_sub1.sub -bg $frm_bg]
  pack $prog_lbl $top_sub -side left -padx 5 -pady 2
  set top_but   [button $top_sub.but -text "$gPB(cust_cmd,import,Label)" \
  -command "__isv_ImportSetupDataFile" -bg $paOption(app_butt_bg) -width 15]
  set top_but_2 [button $top_sub.but2 -text "$gPB(cust_cmd,export,Label)" \
  -command "__isv_SelectSetupDataFile" -bg $paOption(app_butt_bg) -width 15]
  pack $top_but $top_but_2 -side left -padx 3 -pady 2
  set gPB(c_help,$top_but)   "isv,setup,input"
  set gPB(c_help,$top_but_2) "isv,setup,output"
  set label_list {"gPB(nav_button,default,Label)" "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) "__isv_setup_DefaultCallBack"
  set cb_arr(gPB(nav_button,restore,Label)) "__isv_setup_RestoreCallBack"
  UI_PB_com_CreateButtonBox $bot_frame label_list cb_arr
  pack configure $bot_frame.box -pady 3 -padx 3
  set setup_frm $bot_frame
  set Page::($page_obj,setup_frm) $setup_frm
  set item_list [list mac ini put adv wcs tol]
  set mac_frm [frame $setup_frm.mac]
  set ini_frm [frame $setup_frm.ini]
  set adv_frm [frame $setup_frm.adv]
  set put_frm [frame $setup_frm.put]
  set wcs_frm [frame $setup_frm.wcs]
  set tol_frm [frame $setup_frm.tol]
  set gPB(isv_datatype) [__isv_SetAddrValidateFmt]
  __isv_MachineToolParamPage      $page_obj $mac_frm
  __isv_InitializationPage        $ini_frm
  __isv_AdvanceInitializationPage $page_obj $adv_frm
  __isv_SymbolDefinitionPage      $page_obj $put_frm
  __isv_WCSDefinitionPage         $page_obj $wcs_frm
  __isv_ToolInfoDefPage           $page_obj $tol_frm
  set Page::($page_obj,mac_frm) $mac_frm
  set Page::($page_obj,ini_frm) $ini_frm
  set Page::($page_obj,adv_frm) $adv_frm
  set Page::($page_obj,put_frm) $put_frm
  set Page::($page_obj,wcs_frm) $wcs_frm
  set Page::($page_obj,tol_frm) $tol_frm
  pack $mac_frm -fill both -expand yes -pady 2
  __isv_SetVNCPageStatus $page_obj
 }

#=======================================================================
proc __isv_OutputWCSToolInfo {} {
  global gPB
  global mom_sim_arr
  global post_object
  set post_name $Post::($post_object,post_name)
  set out_dir $Post::($post_object,output_dir)
  set file_name $gPB(setup_data_file)
  set set_id [open $file_name w+]
  set output_list [list]
  lappend output_list "   #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  lappend output_list "   # Offsets (in X/Y/Z axes) of the Machine Zero CSYS w.r.t"
  lappend output_list "   # MACHINE_ZERO* Junction of machine model."
  lappend output_list "   # This will be used to define the Machine Zero CSYS matrix."
  lappend output_list "   #"
  lappend output_list "   # - MTCS must be oriented the same as machine axes,"
  lappend output_list "   #   hence, only translational offsets are specified."
  lappend output_list "   # - Offsets between MTCS and the main MCS can be obtained"
  lappend output_list "   #   using \"Information\" on object in NX."
  lappend output_list "   #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  lappend output_list ""
  lappend output_list "   global mom_sim_machine_zero_offsets"
  lappend output_list ""
  lappend output_list "   set mom_sim_machine_zero_offsets \[list $mom_sim_arr(\$mom_sim_machine_zero_offsets)\]"
  lappend output_list ""
  lappend output_list ""
  lappend output_list "   #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  lappend output_list "   # Offsets for defining Work Coordinate Systems (WCS)"
  lappend output_list "   #"
  lappend output_list "   # 0   : Main WCS"
  lappend output_list "   #       - Offsets from Machine Zero CSYS."
  lappend output_list "   #"
  lappend output_list "   # 1-6 : G54 ~ G59"
  lappend output_list "   #       - Offsets from the main (0th) WCS"
  lappend output_list "   #       - As needed, additional work offsets can also be"
  lappend output_list "   #         defined here."
  lappend output_list "   #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  lappend output_list ""
  lappend output_list "   global mom_sim_wcs_offsets"
  lappend output_list ""
  foreach it $mom_sim_arr(\$mom_sim_wcsnum_list) {
   lappend output_list "   set mom_sim_wcs_offsets\($it\) \[list $mom_sim_arr(\$mom_sim_wcs_offsets\($it\))\]"
  }
  lappend output_list ""
  lappend output_list "   PB_SIM_call PB_SIM_call PB_CMD_vnc__define_wcs"
  lappend output_list ""
  lappend output_list ""
  lappend output_list ""
  lappend output_list "   #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  lappend output_list "   # Specify dafault tool assignments"
  lappend output_list "   # - As many as needed"
  lappend output_list "   #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  lappend output_list ""
  lappend output_list "   global mom_sim_tool_data"
  lappend output_list ""
  foreach tool $mom_sim_arr(\$mom_sim_tool_list) {
   lappend output_list "   set mom_sim_tool_data\($tool,name\) $mom_sim_arr(\$mom_sim_tool_data\($tool,name\))"
   lappend output_list "   set mom_sim_tool_data\($tool,type\) $mom_sim_arr(\$mom_sim_tool_data\($tool,type\))"
   lappend output_list "   set mom_sim_tool_data\($tool,offset_used\) $mom_sim_arr(\$mom_sim_tool_data\($tool,offset_used\))"
   lappend output_list "   set mom_sim_tool_data\($tool,x_off\) $mom_sim_arr(\$mom_sim_tool_data\($tool,x_off\))"
   lappend output_list "   set mom_sim_tool_data\($tool,y_off\) $mom_sim_arr(\$mom_sim_tool_data\($tool,y_off\))"
   lappend output_list "   set mom_sim_tool_data\($tool,z_off\) $mom_sim_arr(\$mom_sim_tool_data\($tool,z_off\))"
   lappend output_list "   set mom_sim_tool_data\($tool,carrier_id\) $mom_sim_arr(\$mom_sim_tool_data\($tool,carrier_id\))"
   lappend output_list "   set mom_sim_tool_data\($tool,pocket_id\) $mom_sim_arr(\$mom_sim_tool_data\($tool,pocket_id\))"
   lappend output_list "   set mom_sim_tool_data\($tool,diameter\) $mom_sim_arr(\$mom_sim_tool_data\($tool,diameter\))"
   lappend output_list "   set mom_sim_tool_data\($tool,cutcom_register\) $mom_sim_arr(\$mom_sim_tool_data\($tool,cutcom_register\))"
   lappend output_list "   set mom_sim_tool_data\($tool,cutcom_value\) $mom_sim_arr(\$mom_sim_tool_data\($tool,cutcom_value\))"
   lappend output_list "   set mom_sim_tool_data\($tool,adjust_register\) $mom_sim_arr(\$mom_sim_tool_data\($tool,adjust_register\))"
   lappend output_list "   set mom_sim_tool_data\($tool,adjust_value\) $mom_sim_arr(\$mom_sim_tool_data\($tool,adjust_value\))"
   lappend output_list ""
  }
  foreach line $output_list {
   puts $set_id $line
  }
  close $set_id
 }

#=======================================================================
proc __isv_SetDefSimVars {} {
  global gPB axisoption
  global mom_sim_arr
  set isv_mac_param { "\$mom_sim_zcs_base" "\$mom_sim_spindle_comp"  \
  "\$mom_sim_spindle_jct" "\$mom_sim_mt_axis()"}
  if {[info exists axisoption]} {
   if {[string match "4*" $axisoption]} {
    lappend isv_mac_param "\$mom_sim_reverse_4th_table"
    lappend isv_mac_param "\$mom_sim_4th_axis_has_limits"
    if {[string match "5*" $axisoption]} {
     lappend isv_mac_param "\$mom_sim_reverse_5th_table"
     lappend isv_mac_param "\$mom_sim_5th_axis_has_limits"
    }
   }
  }
  set gPB(isv_mac_param)  $isv_mac_param
  set isv_ini_param { "\$mom_sim_power_on_wcs" "\$mom_sim_spindle_mode"    "\$mom_sim_spindle_direction" \
   "\$mom_sim_feed_mode"    "\$mom_sim_initial_motion"  "\$mom_sim_input_mode" \
  }
  set gPB(isv_ini_param)  $isv_ini_param
  set isv_oth_param { "\$mom_sim_rapid_dogleg" \
   "\$mom_sim_prog_rewind_stop_code" "\$mom_sim_control_var_leader" \
   "\$mom_sim_control_equal_sign" "\$mom_sim_from_home" \
   "\$mom_sim_return_home" "\$mom_sim_mach_cs" \
   "\$mom_sim_local_wcs" "\$mom_sim_incr_linear_addrs" \
   "\$mom_sim_mode_leader" "\$mom_sim_output_vnc_msg" \
  }
  set gPB(isv_oth_param) $isv_oth_param
  set isv_spe_param { "\$mom_sim_vnc_com_list" \
   "\$mom_sim_pre_com_list" \
   "\$mom_sim_precod_list" \
  }
  set isv_subspe_param { "\$mom_sim_sub_vnc_list" \
   "\$mom_sim_pre_com_list" \
   "\$mom_sim_sub_precod_list" \
  }
  set gPB(isv_spe_param) $isv_spe_param
  set gPB(isv_subspe_param) $isv_subspe_param
  set isv_wcs_param { "\$mom_sim_wcs_offsets()" "\$mom_sim_wcsnum_list" "\$mom_sim_machine_zero_offsets"}
  set gPB(isv_wcs_param) $isv_wcs_param
  set isv_tool_param { "\$mom_sim_tool_list" "\$mom_sim_tool_data()" }
  set gPB(isv_tool_param) $isv_tool_param
 }

#=======================================================================
proc __isv_setup_CreateTree { } {
  global paOption tixOption gPB
  global isv_def_id
  set page_obj $isv_def_id
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  $tree config \
  -command "__isv_setup_ItemSelection $h" \
  -browsecmd "__isv_setup_ItemSelection $h"
  $h config -bg $paOption(tree_bg)
  uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]
  set file   $paOption(file)
  set folder $paOption(folder)
  set seq    [tix getimage pb_sequence]
  set subseq [tix getimage pb_sub_seq]
  set style  $gPB(font_style_bold)
  set style1 $gPB(font_style_normal)
  $h add 0     -itemtype imagetext -text "" -image $folder -state disabled
  $h add 0.0   -itemtype imagetext -text "$gPB(isv,setup,machine,Label)" \
  -image $seq    -style $style
  $h add 0.1   -itemtype imagetext -text "$gPB(isv,setup,intialization,Label)" \
  -image $seq    -style $style
  $h add 0.1.0 -itemtype imagetext -text "$gPB(isv,setup,general_def,Label)" \
  -image $subseq    -style $style1
  $h add 0.1.1 -itemtype imagetext -text "$gPB(isv,setup,advanced_def,Label)" \
  -image $subseq    -style $style1
  $h add 0.1.2 -itemtype imagetext -text "$gPB(isv,setup,InputOutput,Label)" \
  -image $subseq    -style $style1
  global env tcl_platform
  set is_MacOS 0
  if { [string match "Darwin" $tcl_platform(os)] ||\
   ([info exists env(PLAT)] && [string match "macos" $env(PLAT)]) } then {
   set is_MacOS 1
  }
  if { !$is_MacOS } {
   $h add 0.2    -itemtype imagetext -text "$gPB(isv,setup,program,Label)" \
   -image $seq    -style $style
   $h add 0.2.0  -itemtype imagetext -text "$gPB(isv,setup,wcs,Label)" \
   -image $subseq    -style $style1
   $h add 0.2.1  -itemtype imagetext -text "$gPB(isv,setup,tool,Label)" \
   -image $subseq    -style $style1
  }
  $h selection set 0.0
  $h anchor set 0.0
 }

#=======================================================================
proc __isv_RecreateLeftSpec { args } {
  global mom_sim_arr gPB
  global tixOption paOption post_object
  global isv_def_id
  set page_obj $isv_def_id
  catch { array set mom_sim_arr $Post::($post_object,mom_sim_var_list) }
  set pre_list $gPB(pre_list)
  if { [info exists gPB(pre_list,index)] } {
   set ind $gPB(pre_list,index)
   } else {
   set ind ""
  }
  set img    [tix getimage pb_vnc_user]
  set style1 $gPB(font_style_bold)
  if { [info exists mom_sim_arr(\$mom_sim_pre_com_list)] } {
   set length [llength $mom_sim_arr(\$mom_sim_pre_com_list)]
   $pre_list delete all
   for { set i 0 } { $i < $length } { incr i } {
    set item [lindex $mom_sim_arr(\$mom_sim_pre_com_list) $i]
    $pre_list add $i -itemtype imagetext -text "$item" \
    -image $img -style $style1
   }
   Post::GetObjList $post_object command cmd_obj_list
   if { [llength $mom_sim_arr(\$mom_sim_pre_com_list)] } {
    $pre_list selection clear
    $pre_list anchor clear
    if { [string match "" $ind] } {
     $pre_list selection set 0
     $pre_list anchor set 0
     set ind 0
     } else {
     $pre_list selection set $ind
     $pre_list selection set $ind
    }
    set token [$pre_list entrycget $ind -text]
    set cmd_name "PB_CMD_vnc__$token"
    PB_com_RetObjFrmName cmd_name cmd_obj_list cmd_obj
    set Page::($page_obj,active_cmd_obj) $cmd_obj
    if { $cmd_obj > 0 } {
     set tag [lindex $args 0]
     if { ![string match "res" $tag] && ![string match "def" $tag] } {
      set command::($cmd_obj,description) [$gPB(pre_text) get 0.0 end]
      } else {
      $gPB(pre_text) delete 0.0 end
      $gPB(pre_text) insert 0.0 $command::($cmd_obj,description)
     }
    }
    } else {
    $gPB(pre_text) delete 0.0 end
    set Page::($page_obj,active_cmd_obj) 0
    set gPB(pre_list,active_cmd_obj) 0
   }
  }
  __isv_DisplayLeaderCode $gPB(pre_list) $gPB(pre_text) $args
 }

#=======================================================================
proc __isv_RecreateSpecHList { args } {
  global gPB
  global isv_def_id
  set page_obj $isv_def_id
  __isv_RecreateLeftSpec $args
  set tag [lindex $args 0]
  if { [string match "seq" $tag] } {
   __isv_SaveCommandDecs $gPB(pre_text) $gPB(pre_list)
  }
 }

#=======================================================================
proc __isv_Default_ToolData {} {
  global mom_sim_arr def_mom_sim_arr
  global post_object gPB
  array set def_mom_sim_arr $Post::($post_object,def_mom_sim_var_list)
  set item_list $gPB(tool_item_list)
  foreach it $mom_sim_arr(\$mom_sim_tool_list) {
   foreach item $item_list {
    unset mom_sim_arr(\$mom_sim_tool_data\($it,$item\))
   }
  }
  foreach it $def_mom_sim_arr(\$mom_sim_tool_list) {
   foreach item $item_list {
    if {[info exists def_mom_sim_arr(\$mom_sim_tool_data\($it,$item\))]} {
     set mom_sim_arr(\$mom_sim_tool_data\($it,$item\))  \
     $def_mom_sim_arr(\$mom_sim_tool_data\($it,$item\))
    }
   }
  }
  set mom_sim_arr(\$mom_sim_tool_list) $def_mom_sim_arr(\$mom_sim_tool_list)
 }

#=======================================================================
proc __isv_Default_WCSData {} {
  global mom_sim_arr def_mom_sim_arr
  global post_object gPB
  array set def_mom_sim_arr $Post::($post_object,def_mom_sim_var_list)
  array set mom_sim_arr $Post::($post_object,mom_sim_var_list)
  foreach it $mom_sim_arr(\$mom_sim_wcsnum_list) {
   unset mom_sim_arr(\$mom_sim_wcs_offsets\($it\))
  }
  foreach it $def_mom_sim_arr(\$mom_sim_wcsnum_list) {
   if { [info exists def_mom_sim_arr(\$mom_sim_wcs_offsets\($it\))] } {
    set mom_sim_arr(\$mom_sim_wcs_offsets\($it\))  \
    $def_mom_sim_arr(\$mom_sim_wcs_offsets\($it\))
   }
  }
  if { [info exists def_mom_sim_arr(\$mom_sim_wcsnum_list)] } {
   set mom_sim_arr(\$mom_sim_wcsnum_list) $def_mom_sim_arr(\$mom_sim_wcsnum_list)
  }
 }

#=======================================================================
proc __isv_setup_DefaultCallBack { } {
  global mom_sim_arr def_mom_sim_arr
  global mom_sys_arr def_mom_sys_arr
  global gPB machType axisoption paOption gpb_addr_var
  global post_object isv_def_id
  set page_obj $isv_def_id
  if { [info exists Page::($page_obj,prev_seq)] && $Page::($page_obj,prev_seq) == 1.2 } {
   set ret_value [tk_messageBox -message "$gPB(isv,spec_codelist,default,msg)" \
   -type okcancel \
   -parent [UI_PB_com_AskActiveWindow] \
   -icon question  -title "Default"]
   if { ![string  compare $ret_value "cancel"] } {
    return
   }
  }
  array set def_mom_sys_arr $Post::($post_object,def_mom_sys_var_list)
  array set def_mom_sim_arr $Post::($post_object,def_mom_sim_var_list)
  set ind [array exists def_mom_sim_arr]
  if {![info exists Page::($page_obj,prev_seq)]} {
   set Page::($page_obj,prev_seq) 0.0
  }
  switch $Page::($page_obj,prev_seq) {
   0.0 {
    set mom_var_list $gPB(isv_mac_param)
   }
   1 -
   1.0 {
    set mom_var_list $gPB(isv_ini_param)
   }
   1.1 {
    set  mom_var_list $gPB(isv_oth_param)
   }
   1.2 {
    if {[string match "Standalone" $mom_sys_arr(VNC_Mode)]} {
     set mom_var_list $gPB(isv_spe_param)
     } else {
     set mom_var_list $gPB(isv_subspe_param)
    }
   }
   2 -
   2.0 {
    set mom_var_list $gPB(isv_wcs_param)
   }
   2.1 {
    set mom_var_list $gPB(isv_tool_param)
   }
  }
  set temp_list [list]
  foreach sim_var $mom_var_list {
   if {[string first "(" $sim_var] < 0 } {
    if {[string match "\$mom_sim*" $sim_var]} {
     if {[string match "\$mom_sim_pre_com_list" $sim_var] } {
      set all_cmd_list $gPB(def_cmd_obj_list)
      Post::SetObjListasAttr $post_object all_cmd_list
      if { [info exists Post::($post_object,mom_vnc_desc_list)] } {
       array set vnc_desc_arr $Post::($post_object,mom_vnc_desc_list)
       } else {
       array set vnc_desc_arr [list]
      }
      foreach cmd $all_cmd_list {
       if { [info exists command::($cmd,def_value)] } {
        array set cmd_attr $command::($cmd,def_value)
        command::setvalue $cmd cmd_attr
       }
       if { [info exists cmd_attr(5)] } {
        set vnc_desc_arr($command::($cmd,name),desc) $cmd_attr(5)
       }
      }
      set Post::($post_object,mom_vnc_desc_list) [array get vnc_desc_arr]
     }
     if { ![string match "\$mom_sim_tool_list" $sim_var] &&  \
      ![string match "\$mom_sim_wcsnum_list" $sim_var] } {
      if { [info exists def_mom_sim_arr($sim_var)] } {
       set mom_sim_arr($sim_var) $def_mom_sim_arr($sim_var)
      }
     }
     } elseif {[string match "\$mom_sys*" $sim_var]} {
     set mom_sys_arr($sim_var) $def_mom_sys_arr($sim_var)
     } else {
    }
    } else {
    lappend temp_list $sim_var
   }
  }
  foreach item  $temp_list {
   switch $item {
    "\$mom_sim_mt_axis()" {
     if { [string match "3" $mom_sim_arr(\$mom_sim_num_machine_axes)] } {
      set axislist [list X Y Z]
      } elseif {[string match "4" $mom_sim_arr(\$mom_sim_num_machine_axes)]} {
      set axislist [list X Y Z 4]
      } elseif {[string match "5" $mom_sim_arr(\$mom_sim_num_machine_axes)]} {
      set axislist [list X Y Z 4 5]
      } elseif [string match "2" $mom_sim_arr(\$mom_sim_num_machine_axes)] {
      set axislist [list X Z]
      } elseif [string match "3mt" $mom_sim_arr(\$mom_sim_num_machine_axes)] {
      set axislist [list X Z C]
     }
     foreach item $axislist {
      if { [info exists def_mom_sim_arr(\$mom_sim_mt_axis\($item\))] } {
       set mom_sim_arr(\$mom_sim_mt_axis\($item\)) $def_mom_sim_arr(\$mom_sim_mt_axis\($item\))
      }
     }
    }
   }
  }
  set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
  switch $Page::($page_obj,prev_seq) {
   0.0 -
   1 -
   1.0 {
   }
   1.1 {
    if { [string match "UVW" $mom_sim_arr(\$mom_sim_mode_leader)] } {
     set gPB(output_X) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 0]
     set gPB(output_Y) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 1]
     set gPB(output_Z) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 2]
     if { [info exists gPB(output_A)] } {
      set gPB(output_A) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 3]
     }
     if { [info exists gPB(output_B)] } {
      set gPB(output_B) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 4]
     }
     } else {
     set gPB(output_X) $gpb_addr_var(X,leader_name)
     set gPB(output_Y) $gpb_addr_var(Y,leader_name)
     set gPB(output_Z) $gpb_addr_var(Z,leader_name)
     if { [info exists gPB(output_A)] } {
      set gPB(output_A) $gpb_addr_var(fourth_axis,leader_name)
     }
     if { [info exists gPB(output_B)] } {
      set gPB(output_B) $gpb_addr_var(fifth_axis,leader_name)
     }
    }
    __isv_SetSysLeader
    set add_name $gPB(isv_addname)
    set gPB(isv_datatype) [__isv_SetAddrValidateFmt]
    set data_type $gPB(isv_datatype)
    set win_list $Page::($page_obj,gcodent_list_1)
    foreach win $win_list {
     __isv_ValidateFormat_Binding $add_name $data_type $win
    }
    set lbl_list $Page::($page_obj,gcodlbl_list_1)
    foreach lbl $lbl_list {
     set lbl_var [$lbl cget -textvariable]
     if {[string match "" [set $lbl_var]]} {
      $lbl config -bg $::SystemButtonFace
      } else {
      $lbl config -bg $paOption(special_bg)
     }
    }
   }
   1.2 {
    if [info exists gPB(pre_list,def_index)] {
     set gPB(pre_list,index) $gPB(pre_list,def_index)
     } else {
     set gPB(pre_list,index) ""
    }
    __isv_RecreateSpecHList def
   }
   2 -
   2.0 {
    __isv_Distroy_WCSTable
    __isv_Default_WCSData
    __isv_Redisplay_WCSTable
   }
   2.1 {
    __isv_Distroy_ToolTable
    __isv_Default_ToolData
    __isv_Redisplay_ToolTable
   }
  }
 }

#=======================================================================
proc __isv_Restore_WCSData {} {
  global mom_sim_arr rest_mom_sim_arr
  global post_object gPB
  array set rest_mom_sim_arr $Post::($post_object,rest_mom_sim_var_list)
  array set mom_sim_arr $Post::($post_object,mom_sim_var_list)
  foreach it $mom_sim_arr(\$mom_sim_wcsnum_list) {
   unset mom_sim_arr(\$mom_sim_wcs_offsets\($it\))
  }
  foreach it $rest_mom_sim_arr(\$mom_sim_wcsnum_list) {
   set mom_sim_arr(\$mom_sim_wcs_offsets\($it\))  \
   $rest_mom_sim_arr(\$mom_sim_wcs_offsets\($it\))
  }
  set mom_sim_arr(\$mom_sim_wcsnum_list) $rest_mom_sim_arr(\$mom_sim_wcsnum_list)
 }

#=======================================================================
proc __isv_Restore_ToolData {} {
  global mom_sim_arr rest_mom_sim_arr
  global post_object gPB
  array set rest_mom_sim_arr $Post::($post_object,rest_mom_sim_var_list)
  set item_list $gPB(tool_item_list)
  foreach it $mom_sim_arr(\$mom_sim_tool_list) {
   foreach item $item_list {
    unset mom_sim_arr(\$mom_sim_tool_data\($it,$item\))
   }
  }
  foreach it $rest_mom_sim_arr(\$mom_sim_tool_list) {
   foreach item $item_list {
    set mom_sim_arr(\$mom_sim_tool_data\($it,$item\))  \
    $rest_mom_sim_arr(\$mom_sim_tool_data\($it,$item\))
   }
  }
  set mom_sim_arr(\$mom_sim_tool_list) $rest_mom_sim_arr(\$mom_sim_tool_list)
 }

#=======================================================================
proc __isv_setup_RestoreCallBack { {confirm 1} } {
  global mom_sim_arr rest_mom_sim_arr
  global mom_sys_arr rest_mom_sys_arr
  global gPB machType axisoption post_object paOption
  global isv_def_id gpb_addr_var
  set page_obj $isv_def_id
  if { $confirm } {
   if { [info exists Page::($page_obj,prev_seq)] && $Page::($page_obj,prev_seq) == 1.2 } {
    set ret_value [tk_messageBox -message "$gPB(isv,spec_codelist,restore,msg)" \
    -type okcancel \
    -parent [UI_PB_com_AskActiveWindow] \
    -icon question  -title "Restore"]
    if { ![string  compare $ret_value "cancel"] } {
     return
    }
   }
  }
  array set rest_mom_sim_arr $Post::($post_object,rest_mom_sim_var_list)
  switch $Page::($page_obj,prev_seq) {
   0.0 {
    set mom_var_list $gPB(isv_mac_param)
   }
   1 -
   1.0 {
    set mom_var_list $gPB(isv_ini_param)
   }
   1.1 {
    set  mom_var_list $gPB(isv_oth_param)
   }
   1.2 {
    if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
     set mom_var_list $gPB(isv_spe_param)
     } else {
     set mom_var_list $gPB(isv_subspe_param)
    }
   }
   2 -
   2.0 {
    set mom_var_list $gPB(isv_wcs_param)
   }
   2.1 {
    set mom_var_list $gPB(isv_tool_param)
   }
  }
  set temp_list [list]
  foreach sim_var $mom_var_list \
  {
   if {[string first "(" $sim_var] < 0 } {
    if {[string match "\$mom_sim*" $sim_var]} {
     if {[string match "\$mom_sim_pre_com_list" $sim_var]} {
      set all_cmd_list $gPB(rest_cmd_obj_list)
      Post::SetObjListasAttr $post_object all_cmd_list
      if { [info exists Post::($post_object,mom_vnc_desc_list)] } {
       array set vnc_desc_arr $Post::($post_object,mom_vnc_desc_list)
       } else {
       array set vnc_desc_arr [list]
      }
      foreach cmd $all_cmd_list {
       if [info exists command::($cmd,rest_value)] {
        array set cmd_attr $command::($cmd,rest_value)
        command::setvalue $cmd cmd_attr
        if { [info exists cmd_attr(5)] } {
         set vnc_desc_arr($command::($cmd,name),desc) $cmd_attr(5)
        }
       }
      }
      set Post::($post_object,mom_vnc_desc_list) [array get vnc_desc_arr]
     }
     if {![string match "\$mom_sim_tool_list" $sim_var] &&  \
      ![string match "\$mom_sim_wcsnum_list" $sim_var]} {
      if {[info exists rest_mom_sim_arr($sim_var)]} {
       set mom_sim_arr($sim_var) $rest_mom_sim_arr($sim_var)
      }
     }
     } elseif {[string match "\$mom_sys*" $sim_var]} {
     set mom_sys_arr($sim_var) $rest_mom_sys_arr($sim_var)
    }
    } else {
    lappend temp_list $sim_var
   }
  }
  foreach item  $temp_list {
   switch $item {
    "\$mom_sim_mt_axis()" {
     if [string match "3" $mom_sim_arr(\$mom_sim_num_machine_axes)] {
      set axislist [list X Y Z]
      } elseif {[string match "4" $mom_sim_arr(\$mom_sim_num_machine_axes)]} {
      set axislist [list X Y Z 4]
      } elseif {[string match "5" $mom_sim_arr(\$mom_sim_num_machine_axes)]} {
      set axislist [list X Y Z 4 5]
      } elseif [string match "2" $mom_sim_arr(\$mom_sim_num_machine_axes)] {
      set axislist [list X Z]
      } elseif [string match "3mt" $mom_sim_arr(\$mom_sim_num_machine_axes)] {
      set axislist [list X Z C]
     }
     if ![info exists axislist] {
      set axislist [list]
     }
     foreach item $axislist {
      if {[info exists rest_mom_sim_arr(\$mom_sim_mt_axis\($item\)]} {
       set mom_sim_arr(\$mom_sim_mt_axis\($item\))  $rest_mom_sim_arr(\$mom_sim_mt_axis\($item\))
      }
     }
    }
   }
  }
  set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
  switch $Page::($page_obj,prev_seq) {
   0 -
   0.0 -
   1 -
   1.0 {
   }
   1.1 {
    if {[llength $mom_sim_arr(\$mom_sim_incr_linear_addrs)] != 0} {
     set gPB(output_X) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 0]
     set gPB(output_Y) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 1]
     set gPB(output_Z) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 2]
     switch $machType {
      "Mill" {
       switch $axisoption {
        "4T" -
        "4H" {
         set gPB(output_A) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 3]
        }
        "5HH" -
        "5HT" -
        "5TT" {
         set gPB(output_A) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 3]
         set gPB(output_B) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 4]
        }
       }
      }
      "Lathe" {
      }
     }
     } else {
     set gPB(output_X) $gpb_addr_var(X,leader_name)
     set gPB(output_Y) $gpb_addr_var(Y,leader_name)
     set gPB(output_Z) $gpb_addr_var(Z,leader_name)
     if {[info exists gPB(output_A)]} {
      set gPB(output_A) $gpb_addr_var(fourth_axis,leader_name)
     }
     if {[info exists gPB(output_B)]} {
      set gPB(output_B) $gpb_addr_var(fifth_axis,leader_name)
     }
    }
    __isv_SetSysLeader
    set add_name $gPB(isv_addname)
    set gPB(isv_datatype) [__isv_SetAddrValidateFmt]
    set data_type $gPB(isv_datatype)
    set win_list $Page::($page_obj,gcodent_list_1)
    foreach win $win_list {
     __isv_ValidateFormat_Binding $add_name $data_type $win
    }
    set lbl_list $Page::($page_obj,gcodlbl_list_1)
    foreach lbl $lbl_list {
     set lbl_var [$lbl cget -textvariable]
     if { [string match "" [set $lbl_var]] } {
      $lbl config -bg $::SystemButtonFace
      } else {
      $lbl config -bg $paOption(special_bg)
     }
    }
   }
   1.2 {
    if { [info exists gPB(pre_list,rest_index)] } {
     set gPB(pre_list,index) $gPB(pre_list,rest_index)
     } else {
     set gPB(pre_list,index) ""
    }
    __isv_RecreateSpecHList res
   }
   2 -
   2.0 {
    __isv_Distroy_WCSTable
    __isv_Restore_WCSData
    __isv_Redisplay_WCSTable
   }
   2.1 {
    __isv_Distroy_ToolTable
    __isv_Restore_ToolData
    __isv_Redisplay_ToolTable
   }
  } ;#  switch
 }

#=======================================================================
proc __isv_setup_PackUnpackTopFrame { page_obj branch_item} {
  set top_frame $Page::($page_obj,top_frame)
  set bot_frame $Page::($page_obj,bot_frame)
  switch $branch_item \
  {
   0   {set Page::($page_obj,sld_flag) 0}
   1   {set Page::($page_obj,sld_flag) 0}
   1.0 {set Page::($page_obj,sld_flag) 0}
   1.1 {set Page::($page_obj,sld_flag) 0}
   1.2 {set Page::($page_obj,sld_flag) 0}
   2   {set Page::($page_obj,sld_flag) 1}
   2.0 {set Page::($page_obj,sld_flag) 1}
   2.1 {set Page::($page_obj,sld_flag) 1}
  }
  if { $Page::($page_obj,sld_flag) == 0 } {
   if { $Page::($page_obj,top_flag) == 1 } {
    pack forget $Page::($page_obj,top_frame)
    set Page::($page_obj,top_flag) 0
    pack configure $bot_frame -padx 0
    pack configure $bot_frame.box -padx 3
   }
   } else {
   if { $Page::($page_obj,top_flag) == 0 } {
    pack forget $Page::($page_obj,bot_frame)
    pack $Page::($page_obj,top_frame) -side top -fill x -padx 3
    pack $Page::($page_obj,bot_frame) -expand yes -fill both -padx 3
    set  Page::($page_obj,top_flag) 1
    pack configure $bot_frame.box -padx 0
   }
  }
 }

#=======================================================================
proc UI_PB_isv_setup_ValidateToolname { output_mess } {
  global mom_sim_arr
  global gPB
  set raise_item 0
  set tool_name_empty 0
  set tool_name_same 0
  if { [info exists mom_sim_arr(\$mom_sim_tool_list)] } {
   if { $mom_sim_arr(\$mom_sim_tool_list) != "" } {
    set tool_name_list $mom_sim_arr(\$mom_sim_tool_list)
    foreach tool_num $tool_name_list {
     if { [info exists mom_sim_arr(\$mom_sim_tool_data\($tool_num,name\))] } {
      set tool_name [string trim $mom_sim_arr(\$mom_sim_tool_data\($tool_num,name\))]
      if { $tool_name == "" } {
       set raise_item 1
       set tool_name_empty 1
       break
      }
     }
    }
    foreach tool_num1 $tool_name_list {
     if { [info exists mom_sim_arr(\$mom_sim_tool_data\($tool_num1,name\))] } {
      set tool_name1 [string trim $mom_sim_arr(\$mom_sim_tool_data\($tool_num1,name\))]
      set tool_name_list [lrange $tool_name_list 1 end]
      set same_name 0
      foreach tool_num2 $tool_name_list {
       if { [info exists mom_sim_arr(\$mom_sim_tool_data\($tool_num2,name\))] } {
        set tool_name2 [string trim $mom_sim_arr(\$mom_sim_tool_data\($tool_num2,name\))]
        if { $tool_name1 == $tool_name2 } {
         set same_name 1
         break
        }
       }
      }
      if { $same_name } {
       set raise_item 1
       set tool_name_same 1
       break
      }
     }
    }
   }
   if { $output_mess } {
    if { $raise_item } {
     if { $tool_name_empty } {
      set tool_name_err $gPB(isv,tool_info,name_err,Msg)
      } elseif { $tool_name_same } {
      set tool_name_err $gPB(isv,tool_info,name_same_err,Msg)
     }
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -message $tool_name_err \
     -icon error
    }
   }
  }
  return $raise_item
 }

#=======================================================================
proc __isv_setup_ValidateToolname {h} {
  global gPB
  set ret_num 0
  if { [UI_PB_isv_setup_ValidateToolname 0] } {
   $h selection clear
   $h anchor clear
   $h selection set 0.2.1
   $h selection set 0.2.1
   UI_PB_isv_setup_ValidateToolname 1
   set ret_num 1
  }
  return $ret_num
 }

#=======================================================================
proc UI_PB_isv_setup_ValidateEmptyEntry { def_item } {
  global mom_sim_arr
  global gPB
  switch $def_item \
  {
   0.0   {set def_item 0.0}
   0.1.0 {set def_item 1.0}
   0.1.1 {set def_item 1.1}
   0.1.2 {set def_item 1.2}
   0.2.0 {set def_item 2.0}
   0.2.1 {set def_item 2.1}
  }
  set ent_var_list [list]
  switch $def_item \
  {
   0.0 \
   {
    lappend ent_var_list "mom_sim_arr(\$mom_sim_spindle_comp)" \
    "mom_sim_arr(\$mom_sim_spindle_jct)" \
    "mom_sim_arr(\$mom_sim_zcs_base)"
   }
   1.0 \
   {
   }
   1.1 \
   {
   }
   1.2 \
   {
   }
   2.0 \
   {
    lappend ent_var_list "gPB(zero_off_x)" \
    "gPB(zero_off_y)" \
    "gPB(zero_off_z)"
    foreach wcsnum $mom_sim_arr(\$mom_sim_wcsnum_list) {
     foreach item {x y z a b c} {
      lappend ent_var_list "gPB($wcsnum,$item)"
     }
    }
   }
   2.1 \
   {
    foreach toolnum $mom_sim_arr(\$mom_sim_tool_list) {
     foreach item {diameter x_off y_off z_off cutcom_value adjust_value carrier_id pocket_id} {
      lappend ent_var_list "mom_sim_arr(\$mom_sim_tool_data\($toolnum,$item\))"
     }
    }
   }
  }
  if { [llength $ent_var_list] } {
   foreach var $ent_var_list {
    set var [string trim $var]
    if { [info exists $var] } {
     if { ![string compare [string trim [set $var]] ""] } {
      return 1
     }
    }
   }
  }
  return 0
 }

#=======================================================================
proc __isv_setup_ValidateEmptyEntry { h prev_seq item} {
  global gPB
  set ret_num 0
  switch $item \
  {
   0   {set item_h 0.0}
   1   {set item_h 1.0}
   1.0 {set item_h 1.0}
   1.1 {set item_h 1.1}
   1.2 {set item_h 1.2}
   2   {set item_h 2.0}
   2.0 {set item_h 2.0}
   2.1 {set item_h 2.1}
  }
  switch $prev_seq \
  {
   0.0 {set prev_seq_h 0.0}
   1.0 {set prev_seq_h 0.1.0}
   1.1 {set prev_seq_h 0.1.1}
   1.2 {set prev_seq_h 0.1.2}
   2.0 {set prev_seq_h 0.2.0}
   2.1 {set prev_seq_h 0.2.1}
  }
  if { [string compare $item_h $prev_seq] } {
   if { [UI_PB_isv_setup_ValidateEmptyEntry $prev_seq] } {
    $h selection clear
    $h anchor clear
    $h selection set $prev_seq_h
    $h selection set $prev_seq_h
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
    -message $gPB(machine,empty_entry_err,msg) \
    -icon error
    set ret_num 1
   }
  }
  return $ret_num
 }

#=======================================================================
proc __isv_setup_ItemSelection { h args} {
  global gPB
  global isv_def_id
  global mom_sys_arr
  set page_obj $isv_def_id
  set setup_frm $Page::($page_obj,setup_frm)
  set mac_frm $Page::($page_obj,mac_frm)
  set ini_frm $Page::($page_obj,ini_frm)
  set adv_frm $Page::($page_obj,adv_frm)
  set put_frm $Page::($page_obj,put_frm)
  set wcs_frm $Page::($page_obj,wcs_frm)
  set tol_frm $Page::($page_obj,tol_frm)
  set item_len [llength args]
  if { $item_len != 0 } {
   set item [string range $args 2 end]
  }
  set prev_seq $Page::($page_obj,prev_seq)
  if {[string match "Standalone" $mom_sys_arr(VNC_Mode)]} {
   set main_flag 1
   } else {
   set main_flag 0
  }
  switch $prev_seq \
  {
   0.0 { set prev_item "mac" }
   1   {
    if { $main_flag == 1 } {
     set prev_item "ini"
     } else {
     set prev_item "adv"
    }
   }
   1.0 { set prev_item "ini" }
   1.1 { set prev_item "put" }
   1.2 { set prev_item "adv" }
   2   { set prev_item "wcs" }
   2.0 { set prev_item "wcs" }
   2.1 { set prev_item "tol" }
  }
  set padx 0
  set pady 2
  switch $item \
  {
   0 { ;#<07-13-08 lxy> Validate tool name
    if {[__isv_setup_ValidateToolname $h]} {
     return
    }
    if {[__isv_setup_ValidateEmptyEntry $h $prev_seq $item]} {
     return
    }
    $h selection clear
    $h anchor clear
    $h selection set 0.0
    $h selection set 0.0
    __isv_setup_PackUnpackTopFrame $page_obj $item
    pack forget $setup_frm.$prev_item
    pack $setup_frm.mac -padx $padx -pady $pady -fill both -expand yes
    set Page::($page_obj,prev_seq) 0.0
   }
   1 { ;#<07-13-08 lxy> Validate tool name
    if {[__isv_setup_ValidateToolname $h]} {
     return
    }
    if {[__isv_setup_ValidateEmptyEntry $h $prev_seq $item]} {
     return
    }
    $h selection clear
    $h anchor clear
    if { $main_flag == 1 } {
     $h selection set 0.1.0
     $h selection set 0.1.0
     } else {
     $h selection set 0.1.2
     $h selection set 0.1.2
    }
    __isv_setup_PackUnpackTopFrame $page_obj $item
    pack forget $setup_frm.$prev_item
    if { $main_flag == 1 } {
     pack $setup_frm.ini -padx $padx -pady $pady -fill both -expand yes
     set Page::($page_obj,prev_seq) 1.0
     } else {
     pack $setup_frm.adv -padx $padx -pady $pady -fill both -expand yes
     set Page::($page_obj,prev_seq) 1.2
    }
   }
   1.0 { ;#<07-13-08 lxy> Validate tool name
    if {[__isv_setup_ValidateToolname $h]} {
     return
    }
    if {[__isv_setup_ValidateEmptyEntry $h $prev_seq $item]} {
     return
    }
    if { $prev_seq != 1.0 } {
     __isv_setup_PackUnpackTopFrame $page_obj $item
     pack forget $setup_frm.$prev_item
     pack $setup_frm.ini -padx $padx -pady $pady -fill both -expand yes
     set Page::($page_obj,prev_seq) 1.0
    }
   }
   1.1 { ;#<07-13-08 lxy> Validate tool name
    if {[__isv_setup_ValidateToolname $h]} {
     return
    }
    if {[__isv_setup_ValidateEmptyEntry $h $prev_seq $item]} {
     return
    }
    if { $prev_seq != 1.1 } {
     __isv_setup_PackUnpackTopFrame $page_obj $item
     pack forget $setup_frm.$prev_item
     pack $setup_frm.put -padx $padx -pady $pady -fill both -expand yes
     set Page::($page_obj,prev_seq) 1.1
    }
   }
   1.2 { ;#<07-13-08 lxy> Validate tool name
    if {[__isv_setup_ValidateToolname $h]} {
     return
    }
    if {[__isv_setup_ValidateEmptyEntry $h $prev_seq $item]} {
     return
    }
    if { $prev_seq != 1.2 } {
     __isv_setup_PackUnpackTopFrame $page_obj $item
     PB_int_UpdateSIMVar mom_sim_arr
     __isv_RecreateSpecHList seq
     pack forget $setup_frm.$prev_item
     pack $setup_frm.adv -padx $padx -pady $pady -fill both -expand yes
     set Page::($page_obj,prev_seq) 1.2
    }
   }
   2 { ;#<07-13-08 lxy> Validate tool name
    if {[__isv_setup_ValidateToolname $h]} {
     return
    }
    if {[__isv_setup_ValidateEmptyEntry $h $prev_seq $item]} {
     return
    }
    $h selection clear
    $h anchor clear
    $h selection set 0.2.0
    if { $prev_seq != 2 } {
     __isv_setup_PackUnpackTopFrame $page_obj $item
     pack forget $setup_frm.$prev_item
     pack $wcs_frm -side left -padx $padx -pady $pady -fill both -expand yes
     set Page::($page_obj,prev_seq) 2.0
    }
   }
   2.0 { ;#<07-13-08 lxy> Validate tool name
    if {[__isv_setup_ValidateToolname $h]} {
     return
    }
    if {[__isv_setup_ValidateEmptyEntry $h $prev_seq $item]} {
     return
    }
    if { $prev_seq != 2.0 } {
     __isv_setup_PackUnpackTopFrame $page_obj $item
     pack forget $setup_frm.$prev_item
     pack $wcs_frm -side left -padx $padx -pady $pady -fill both -expand yes
     set Page::($page_obj,prev_seq) 2.0
    }
   }
   2.1 { ;#<02-22-09 lxy> Validate empty entries
    if {[__isv_setup_ValidateEmptyEntry $h $prev_seq $item]} {
     return
    }
    if { $prev_seq != 2.1 } {
     __isv_setup_PackUnpackTopFrame $page_obj $item
     pack forget $setup_frm.$prev_item
     pack $tol_frm -side left -padx $padx -pady $pady -fill both -expand yes
     set Page::($page_obj,prev_seq) 2.1
    }
   }
  } ;# switch
  UI_PB_isv_UpdateDefPageParams
 }

#=======================================================================
proc __isv_MachineComponetDef { page_obj b str} {
  global mom_sim_arr
  set var [$b cget -textvariable]
  $b delete 0 end
  $b insert 0 $str
  set $var $str
  $b selection range 0 end
 }

#=======================================================================
proc __isv_CreateFourthTableParam { frame flag } {
  global mom_sim_arr gPB
  global tixOption paOption
  global axisoption
  if {[string match "3MT" $axisoption]} {
   set frm_lbl "$gPB(machine,axis,rotary,Label)"
   } else {
   set frm_lbl "$gPB(isv,setup,fourth_table,Label)"
  }
  Page::CreateLblFrame $frame four "$frm_lbl"
  set right_frm [$frame.four subwidget frame]
  pack $frame.four -side top
  set 4header [frame $right_frm.1]
  set 4rev [frame $right_frm.2]
  set 4rad [frame $right_frm.3]
  set mom_sim_arr(\$mom_sim_4th_axis_has_limits) 1
  set mom_sim_arr(\$mom_sim_reverse_4th_table) 0
  pack $4header $4rev $4rad -side top -fill x
  if {[string match "H" $flag]} {
   set type_lbl $gPB(machine,axis,head,Label)
   } else {
   set type_lbl $gPB(machine,axis,table,Label)
  }
  label $4header.type -text "$type_lbl" \
  -font $tixOption(bold_font) \
  -fg $paOption(special_fg) -bg $paOption(special_bg)
  pack $4header.type -side left -padx 5 -pady 2
  set 4revtable [checkbutton $4rev.four \
  -text "$gPB(isv,setup,rev_fourth,Label)" \
  -variable mom_sim_arr(\$mom_sim_reverse_4th_table) \
  -justify left]
  pack $4revtable -side left -padx 5 -pady 2
  set 4lbl [label $4rad.lbl -text "$gPB(isv,setup,fourth_limit,Label)" \
  -width 15 -justify left -anchor w] ;#<12-04-07 gsl> 15 was 10; added -anchor w.
  set 4rad1 [radiobutton $4rad.on \
  -text "$gPB(isv,setup,limiton,Label)" \
  -variable mom_sim_arr(\$mom_sim_4th_axis_has_limits) \
  -value 1]
  set 4rad2 [radiobutton $4rad.off \
  -text "$gPB(isv,setup,limitoff,Label)" \
  -variable mom_sim_arr(\$mom_sim_4th_axis_has_limits) \
  -value 0]
  pack $4lbl $4rad1 $4rad2 -side left -padx 5 -pady 2
  set gPB(c_help,$4revtable) "isv,setup,rev_fourth"
  set gPB(c_help,$4lbl) "isv,setup,fourth_limit"
 }

#=======================================================================
proc __isv_CreateFifthTableParam { frame flag} {
  global mom_sim_arr gPB
  global tixOption paOption
  Page::CreateLblFrame $frame fif "$gPB(isv,setup,fifth_table,Label)"
  set right_frm [$frame.fif subwidget frame]
  pack $frame.fif -side top
  set 5header [frame $right_frm.1]
  set 5rev [frame $right_frm.2]
  set 5rad [frame $right_frm.3]
  pack $5header $5rev $5rad -side top -fill x
  set mom_sim_arr(\$mom_sim_5th_axis_has_limits) 1
  set mom_sim_arr(\$mom_sim_reverse_5th_table) 0
  if {[string match "H" $flag]} {
   set type_lbl $gPB(machine,axis,head,Label)
   } else {
   set type_lbl $gPB(machine,axis,table,Label)
  }
  label $5header.type -text "$type_lbl" \
  -font $tixOption(bold_font) \
  -fg $paOption(special_fg) -bg $paOption(special_bg)
  pack $5header.type -side left -padx 5 -pady 2
  set 5revtable [checkbutton $5rev.fifth \
  -text "$gPB(isv,setup,rev_fifth,Label)" \
  -variable mom_sim_arr(\$mom_sim_reverse_5th_table) \
  -justify left]
  pack $5revtable -side left -padx 5 -pady 2
  set 5lbl [label $5rad.lbl -text "$gPB(isv,setup,fifth_limit,Label)" \
  -width 15 -justify left -anchor w] ;#<12-04-07 gsl> 15 was 10; added -anchor w.
  set 5rad1 [radiobutton $5rad.on \
  -text "$gPB(isv,setup,limiton,Label)" \
  -variable mom_sim_arr(\$mom_sim_5th_axis_has_limits) \
  -value 1]
  set 5rad2 [radiobutton $5rad.off \
  -text "$gPB(isv,setup,limitoff,Label)" \
  -variable mom_sim_arr(\$mom_sim_5th_axis_has_limits) \
  -value 0]
  pack $5lbl $5rad1 $5rad2 -side left -padx 5 -pady 2
  set gPB(c_help,$5revtable) "isv,setup,rev_fourth"
  set gPB(c_help,$5lbl) "isv,setup,fourth_limit"
 }

#=======================================================================
proc __isv_CreateFourAxisName { frame } {
  global mom_sim_arr gpb_addr_var
  global tixOption paOption
  global machType axisoption
  set options_list {A B C D E F G H I J K L M N O \
  P Q R S T U V W X Y Z "gPB(address,none_popup,Label)"}
  set callback "__isv_MachineComponetDef"
  set a_frm [frame $frame.a]
  pack $a_frm -side top -fill x -expand yes
  set label_var "gpb_addr_var(fourth_axis,leader_name)"
  if [string match "Lathe" $machType] {
   if [info exists gpb_addr_var(B_axis,leader_name)] {
    set label_var "gpb_addr_var(B_axis,leader_name)"
   }
  }
  if ![info exists mom_sim_arr(\$mom_sim_mt_axis\(4\))] {
   if {[string match "4H" $axisoption] || [string match "4T" $axisoption]} {
    set mom_sim_arr(\$mom_sim_mt_axis\(4\)) "A"
    } elseif [string match "5*" $axisoption] {
    set mom_sim_arr(\$mom_sim_mt_axis\(4\)) "B"
    } elseif {[string match "3MT" $axisoption]} {
    set mom_sim_arr(\$mom_sim_mt_axis\(4\)) "C"
   }
  }
  UI_PB_mthd_CreateLblPopEntry page_obj $a_frm \$mom_sim_mt_axis\(4\) \
  label_var options_list callback
  set gPB(c_help,$a_frm) "isv,setup,axis_name"
 }

#=======================================================================
proc __isv_CreateFifthAxisName { frame } {
  global gpb_addr_var
  global mom_sim_arr
  global tixOption paOption
  set options_list {A B C D E F G H I J K L M N O \
  P Q R S T U V W X Y Z "gPB(address,none_popup,Label)"}
  set callback "__isv_MachineComponetDef"
  set b_frm [frame $frame.b]
  pack $b_frm -side top -fill x -expand yes
  set label_var "gpb_addr_var(fifth_axis,leader_name)"
  if ![info exists mom_sim_arr(\$mom_sim_mt_axis\(5\))] {
   set mom_sim_arr(\$mom_sim_mt_axis\(5\)) "C"
  }
  UI_PB_mthd_CreateLblPopEntry page_obj $b_frm \$mom_sim_mt_axis\(5\) \
  label_var options_list callback
  set gPB(c_help,$b_frm) "isv,setup,axis_name"
 }

#=======================================================================
proc __isv_ValidateMachineToolParam { win key } {
  global paOption mom_sim_arr gPB
  set disable_flag 1
  if { [string match "\[a-z\]" $key] } {
   if {[string match "c" $key] || \
    [string match "v" $key] || \
    [string match "x" $key]} {
    if {[info exists gPB(prev_key)] && $gPB(prev_key) == "Control_L" || \
     [info exists gPB(prev_key)] && $gPB(prev_key) == "Control_R"} {
     } else {
     set ind [$win index insert]
     $win delete $ind $ind
     $win insert insert [string toupper $key]
     set disable_flag 0
    }
    } else {
    set ind [$win index insert]
    $win delete $ind $ind
    $win insert insert [string toupper $key]
    set disable_flag 0
   }
   } elseif {[string match "asterisk" $key]} {
   set disable_flag 1
   } else {
   UI_PB_com_DisableSpecialChars $win $key
  }
  if { !$disable_flag } {
   $win config -state disabled
  }
  set gPB(prev_key) $key
 }

#=======================================================================
proc __isv_ValidateMachineToolParamRelease { win } {
  $win config -state normal
 }

#=======================================================================
proc __isv_MachineToolParamPage { page_obj frame} {
  global gPB paOption tixOption
  global mom_sim_arr
  global machType axisoption
  UI_PB_mthd_CreateScrollWindow $frame mac setup_win y
  set sub [frame $setup_win.sub -bd 3]
  pack $sub -fill both -expand yes
  set mac_frame [frame $sub.sub]
  pack $mac_frame -pady 30
  set sub_frame [frame $mac_frame.left -bd 3]
  pack $sub_frame -side left
  Page::CreateLblFrame $sub_frame zcs $gPB(isv,setup,component,Label)
  set sub_widget [$sub_frame.zcs subwidget frame]
  set options_list {A B C D E F G H I J K L M N O \
  P Q R S T U V W X Y Z "gPB(address,none_popup,Label)"}
  set callback "__isv_MachineComponetDef"
  set spin_com [frame $sub_widget.2]
  set spin_jct [frame $sub_widget.3]
  set label $gPB(isv,setup,spin_com,Label)
  Page::CreateLblEntry s  \$mom_sim_spindle_comp $spin_com com $label
  if 0 {
   bind $spin_com.1_com <KeyPress> "__isv_ValidateMachineToolParam %W %K"
   bind $spin_com.1_com <KeyRelease> "__isv_ValidateMachineToolParamRelease %W"
  }
  set label $gPB(isv,setup,spin_jct,Label)
  Page::CreateLblEntry s  \$mom_sim_spindle_jct $spin_jct com $label
  Page::CreateLblFrame $sub_frame com "$gPB(isv,setup,mac_zcs_frame,Label)"
  set sub_zcs [$sub_frame.com subwidget frame]
  set zcs_base [frame $sub_zcs.1]
  set label $gPB(isv,setup,mac_zcs,Label)
  Page::CreateLblEntry s  \$mom_sim_zcs_base $zcs_base com $label
  set gPB(c_help,$spin_com.1_com) "isv,setup,spin_com"
  set gPB(c_help,$spin_jct.1_com) "isv,setup,spin_jct"
  set gPB(c_help,$zcs_base.1_com) "isv,setup,mac_zcs"
  $spin_com.1_com config -width 15
  $spin_jct.1_com config -width 15
  $zcs_base.1_com config -width 15
  pack $spin_com $spin_jct -side top -anchor n -fill x
  pack $zcs_base -side top -anchor n -fill x
  Page::CreateLblFrame $sub_frame axis $gPB(isv,setup,axis_frm,Label)
  set sub2 [$sub_frame.axis subwidget frame]
  set 3axis_frm [frame $sub2.3axis]
  pack $3axis_frm -side top -fill x
  set x_frm [frame $3axis_frm.x]
  set y_frm [frame $3axis_frm.y]
  set z_frm [frame $3axis_frm.z]
  pack $x_frm $y_frm $z_frm -side top -fill x -expand yes
  if 0 {
   set label_var "gpb_addr_var(X,leader_name)"
   UI_PB_mthd_CreateLblPopEntry page_obj $x_frm \$mom_sim_mt_axis\(X\) \
   label_var options_list callback
   if {[string match "Mill" $machType] && ![string match "3MT" $axisoption]} {
    set label_var "gpb_addr_var(Y,leader_name)"
    UI_PB_mthd_CreateLblPopEntry page_obj $y_frm \$mom_sim_mt_axis\(Y\) \
    label_var options_list callback
   }
   set label_var "gpb_addr_var(Z,leader_name)"
   UI_PB_mthd_CreateLblPopEntry page_obj $z_frm \$mom_sim_mt_axis\(Z\) \
   label_var options_list callback
   } else {
   global X_leader Y_leader Z_leader
   set X_leader X
   set label_var "X_leader"
   UI_PB_mthd_CreateLblPopEntry page_obj $x_frm \$mom_sim_mt_axis\(X\) \
   label_var options_list callback
   $x_frm.lbl config -fg black -bg $::SystemButtonFace
   if {[string match "Mill" $machType] && ![string match "3MT" $axisoption]} {
    set Y_leader Y
    set label_var "Y_leader"
    UI_PB_mthd_CreateLblPopEntry page_obj $y_frm \$mom_sim_mt_axis\(Y\) \
    label_var options_list callback
    $y_frm.lbl config -fg black -bg $::SystemButtonFace
   }
   set Z_leader Z
   set label_var "Z_leader"
   UI_PB_mthd_CreateLblPopEntry page_obj $z_frm \$mom_sim_mt_axis\(Z\) \
   label_var options_list callback
   $z_frm.lbl config -fg black -bg $::SystemButtonFace
   PB_com_unset_var X_leader
   PB_com_unset_var Y_leader
   PB_com_unset_var Z_leader
  }
  set gPB(c_help,$x_frm) "isv,setup,axis_name"
  set gPB(c_help,$y_frm) "isv,setup,axis_name"
  set gPB(c_help,$z_frm) "isv,setup,axis_name"
  pack $sub_frame.zcs $sub_frame.com $sub_frame.axis -side top -anchor n -fill x
  switch $machType \
  {
   "Mill" \
   {
    switch $axisoption \
    {
     "3MT" -
     "4H" -
     "4T" {
      __isv_CreateFourAxisName $3axis_frm
      set rightframe [frame $mac_frame.right]
      pack $rightframe -side top -padx 25 -pady 3
      if {[string match "4H" $axisoption]} {
       __isv_CreateFourthTableParam $rightframe "H"
       } else {
       __isv_CreateFourthTableParam $rightframe "T"
      }
     }
     "5HH" -
     "5HT" -
     "5TT" {
      __isv_CreateFourAxisName $3axis_frm
      __isv_CreateFifthAxisName $3axis_frm
      set rightframe [frame $mac_frame.right]
      pack $rightframe -side top -padx 25 -pady 3
      if {[string match "5TT" $axisoption]} {
       __isv_CreateFourthTableParam $rightframe "T"
       } else {
       __isv_CreateFourthTableParam $rightframe "H"
      }
      if {[string match "5HH" $axisoption]} {
       __isv_CreateFifthTableParam $rightframe "H"
       } else {
       __isv_CreateFifthTableParam $rightframe "T"
      }
     }
    }
   }
   "Lathe" \
   {
   }
  }
  set ent_list [list $spin_com.1_com $spin_jct.1_com $zcs_base.1_com \
  $3axis_frm.x.ent $3axis_frm.y.ent $3axis_frm.z.ent \
  $3axis_frm.a.ent $3axis_frm.b.ent]
  foreach ent $ent_list {
   if { [winfo exists $ent] } {
    bind $ent <KeyPress> "__isv_ValidateMachineToolParam %W %K"
    bind $ent <KeyRelease> "__isv_ValidateMachineToolParamRelease %W"
   }
  }
 }

#=======================================================================
proc __isv_InitializationPage { frame } {
  global gPB paOption
  global tixOption
  UI_PB_mthd_CreateScrollWindow $frame ini setup_win y
  set frame_left [frame $setup_win.left]
  pack $frame_left -pady 30
  Page::CreateLblFrame $frame_left mot "" ;#<12-18-07 gsl> "$gPB(isv,setup,initial,frame,Label)"
  pack $frame_left.mot -side top -fill x -expand yes
  set mot_frm $frame_left.mot
  __isv_MotionDefineFrame $mot_frm
  Page::CreateLblFrame $frame_left spl "$gPB(isv,setup,spindle,frame,Label)"
  pack $frame_left.spl -side top  -fill x -expand yes
  set spl_frm $frame_left.spl
  __isv_SpindleDefineFrame $spl_frm
  Page::CreateLblFrame $frame_left fee ""
  pack $frame_left.fee -side top  -fill x -expand yes
  set fee_frm $frame_left.fee
  __isv_FeedRateDefineFrame $fee_frm
  Page::CreateLblFrame $frame_left mod "$gPB(isv,setup,initial_mode,frame,Label)"
  pack $frame_left.mod -side top  -fill x -expand yes
  set mod_frm $frame_left.mod
  __isv_InitModeDefineFrame $mod_frm
 }

#=======================================================================
proc __isv_AdvanceInitializationPage { page_obj frame } {
  global gPB paOption tixOption
  set spe_frm [frame $frame.spe -bd 2 -relief sunken]
  pack $spe_frm -padx 3 -fill both -expand yes
  Page::CreateLblFrame $spe_frm pre "" ;#<01-17-08 gsl> Remove label "$gPB(isv,spec_pre,frame,Label)"
  pack $spe_frm.pre -side top -padx 20 -pady 20 -fill both
  set spec_def_frm $spe_frm.pre
  __isv_SpecialDefinePreCommand $page_obj $spec_def_frm
 }

#=======================================================================
proc __isv_SymbolDefinitionPage { page_obj frame } {
  global gPB
  UI_PB_mthd_CreateScrollWindow $frame def setup_win y
  set sub_frame [frame $setup_win.sub]
  pack $sub_frame -pady 30
  set frame_left [frame $sub_frame.left]
  set frame_right [frame $sub_frame.right]
  pack $frame_left $frame_right -side left -padx 10 -pady 0 -fill y
  Page::CreateLblFrame $frame_left col "$gPB(isv,control_var,frame,Label)"
  pack $frame_left.col -side top -padx 5 -pady 2 -fill x
  set symbol_frm $frame_left.col
  __isv_ControlVarFrame $symbol_frm
  Page::CreateLblFrame $frame_left sbl "" ;#<12-18-07 gsl> "$gPB(isv,sign_define,frame,Label)"
  pack $frame_left.sbl -side top -padx 5 -pady 2 -fill x
  set symbol_frm $frame_left.sbl
  __isv_SymbolDefineFrame $page_obj $symbol_frm
  Page::CreateLblFrame $frame_left cod "" ;#<12-18-07 gsl> "$gPB(isv,sign_define,frame,Label)"
  pack $frame_left.cod -side top -padx 5 -pady 2 -fill x
  set symbol_frm $frame_left.cod
  __isv_SpecGcodeDefineFrame $page_obj $symbol_frm
  Page::CreateLblFrame $frame_right mode "$gPB(isv,incremental_style,frame,Label)"
  pack $frame_right.mode -side top -padx 5 -pady 2 -fill x ;#<12-04-07 gsl> -pady 0 was 2.
  set input_mode_frm $frame_right.mode
  __isv_InputModeDefFrame $page_obj $input_mode_frm
  Page::CreateLblFrame $frame_right dog ""
  pack $frame_right.dog -side top -padx 5 -pady 4 -fill x ;#<12-04-07 gsl> -pady 4 was 2.
  set dog_frm $frame_right.dog
  __isv_SetRapidDogFrame $dog_frm
  Page::CreateLblFrame $frame_right oth ""
  pack $frame_right.oth -side top -padx 5 -pady 25 -fill x
  set vnc_msg_frm $frame_right.oth
  __isv_DefOutputVNCmsg $vnc_msg_frm
 }

#=======================================================================
proc __isv_Distroy_WCSTable {} {
  global gPB
  if { [winfo exists $gPB(wcs_col)] } {
   set gPB(wcs_bindage) [bind $gPB(main_window) <Destroy>]
   bind $gPB(main_window) <Destroy> ""
   destroy $gPB(wcs_col)
  }
 }

#=======================================================================
proc __isv_Redisplay_WCSTable {} {
  global mom_sim_arr gPB
  if ![string match "" $gPB(wcs_bindage)] {
   bind $gPB(main_window) <Destroy> $gPB(wcs_bindage)
  }
  frame $gPB(wcs_col)
  pack $gPB(wcs_col) -side top -fill both -expand yes
  if { [info exists mom_sim_arr(\$mom_sim_wcsnum_list)] } {
   set mom_sim_arr(\$mom_sim_wcsnum_list) [lsort -dictionary $mom_sim_arr(\$mom_sim_wcsnum_list)]
   __isv_CreateWCSInfoGrid $gPB(wcs_col)
   } else {
   set mom_sim_arr(\$mom_sim_wcsnum_list) [list]
  }
 }

#=======================================================================
proc __isv_RecreateWCSTable { } {
  __isv_Distroy_WCSTable
  __isv_Redisplay_WCSTable
 }

#=======================================================================
proc __isv_DeleteOneWCS { frame} {
  global gPB
  global mom_sim_arr
  global isv_def_id
  set page_obj $isv_def_id
  set ind [string last "_" $frame]
  set gPB(wnum) [string range $frame [expr $ind + 1 ] end]
  set ind [lsearch $mom_sim_arr(\$mom_sim_wcsnum_list) $gPB(wnum)]
  set mom_sim_arr(\$mom_sim_wcsnum_list) [lreplace $mom_sim_arr(\$mom_sim_wcsnum_list) $ind $ind]
  set del_num $gPB(wnum)
  unset mom_sim_arr(\$mom_sim_wcs_offsets\($del_num\))
  unset mom_sim_arr(\$mom_sim_wcs_$del_num)
  unset gPB($del_num,x)
  unset gPB($del_num,y)
  unset gPB($del_num,z)
  unset gPB($del_num,a)
  unset gPB($del_num,b)
  unset gPB($del_num,c)
  __isv_RecreateWCSTable
 }

#=======================================================================
proc __isv_DeleteWCSLisPopup { X Y frame} {
  global gPB
  global isv_def_id
  set page_obj $isv_def_id
  set popup $frame.pop
  $popup delete 0 end
  $popup add command -label "$gPB(isv,spec_command,delete,Label)"\
  -state normal -command "__isv_DeleteOneWCS $frame"
  tk_popup $popup $X $Y
 }

#=======================================================================
proc __isv_CreateDeleteWCSPop { frame} {
  set popup [menu $frame.pop -tearoff 0]
  bind $frame.but <3> "__isv_DeleteWCSLisPopup %X %Y $frame"
 }

#=======================================================================
proc __isv__CreateWCSFirstColAttr { page_obj grid no_row wcs_num } {
  global paOption tixOption
  global mom_sim_arr
  set wnum_frm $grid.wnum_$wcs_num
  if { ![winfo exists $wnum_frm] } {
   set wnum_frm [frame $grid.wnum_$wcs_num -bg $paOption(table_bg)]
   set addn [button $wnum_frm.but -text $wcs_num \
   -font $tixOption(bold_font) \
   -anchor c \
   -relief flat -bd 1 \
   -background $paOption(table_bg) \
   -highlightbackground $paOption(table_bg) \
   -state normal \
   -foreground blue]
   bind $addn <Enter> "%W config -bg $paOption(focus) -relief solid"
   bind $addn <Leave> "%W config -bg $paOption(table_bg) -relief flat"
   bind $addn <Enter> "+%W config -highlightbackground $paOption(special_bg)"
   bind $addn <Leave> "+%W config -highlightbackground $paOption(table_bg)"
   __isv_CreateDeleteWCSPop $wnum_frm
   pack $addn
  }
  $grid set 0 $no_row -itemtype window -window $wnum_frm
 }

#=======================================================================
proc __isv_SetWCSFunction { win wcs_num} {
  global mom_sim_arr
  global gPB
  set code [$win get]
  set mom_sim_arr(\$mom_sim_wcs_$wcs_num) "$code"
 }

#=======================================================================
proc __isv__CreateWCSRestColAttr { page_obj grid no_row wcs_num} {
  global paOption gPB tixOption
  global mom_sim_arr rest_mom_sim_arr
  global gpb_addr_var
  if {![info exists mom_sim_arr(\$mom_sim_wcs_$wcs_num)]} {
   set mom_sim_arr(\$mom_sim_wcs_$wcs_num) ""
   switch $wcs_num {
    0 { set mom_sim_arr(\$mom_sim_wcs_$wcs_num) "53"}
    1 { set mom_sim_arr(\$mom_sim_wcs_$wcs_num) "54"}
    2 { set mom_sim_arr(\$mom_sim_wcs_$wcs_num) "55"}
    3 { set mom_sim_arr(\$mom_sim_wcs_$wcs_num) "56"}
    4 { set mom_sim_arr(\$mom_sim_wcs_$wcs_num) "57"}
    5 { set mom_sim_arr(\$mom_sim_wcs_$wcs_num) "58"}
    6 { set mom_sim_arr(\$mom_sim_wcs_$wcs_num) "59"}
   }
  }
  if {![info exists mom_sim_arr(\$mom_sim_wcs_offsets\($wcs_num\))]} {
   set mom_sim_arr(\$mom_sim_wcs_offsets\($wcs_num\)) [list 0.0 0.0 0.0 0.0 0.0 0.0]
  }
  set gPB($wcs_num,x) [lindex $mom_sim_arr(\$mom_sim_wcs_offsets\($wcs_num\)) 0]
  set gPB($wcs_num,y) [lindex $mom_sim_arr(\$mom_sim_wcs_offsets\($wcs_num\)) 1]
  set gPB($wcs_num,z) [lindex $mom_sim_arr(\$mom_sim_wcs_offsets\($wcs_num\)) 2]
  set gPB($wcs_num,a) [lindex $mom_sim_arr(\$mom_sim_wcs_offsets\($wcs_num\)) 3]
  set gPB($wcs_num,b) [lindex $mom_sim_arr(\$mom_sim_wcs_offsets\($wcs_num\)) 4]
  set gPB($wcs_num,c) [lindex $mom_sim_arr(\$mom_sim_wcs_offsets\($wcs_num\)) 5]
  set add_name $gPB(isv_addname)
  set gPB(isv_datatype) [__isv_SetAddrValidateFmt]
  set data_type $gPB(isv_datatype)
  set l_frm $grid.l_$wcs_num
  if { ![winfo exists $l_frm] } \
  {
   set l_frm [frame $grid.l_$wcs_num]
   set bgc $paOption(special_bg)
   set fgc $paOption(special_fg)
   label $l_frm.lbl -textvariable gpb_addr_var($add_name,leader_name)  \
   -padx 3 -font $tixOption(bold_font) -bg $bgc -fg $fgc
   set ent1 [entry $l_frm.ent -textvariable mom_sim_arr(\$mom_sim_wcs_$wcs_num) -width 6]
   pack $l_frm.lbl -side left -anchor c -padx 5 -pady 2
   pack $l_frm.ent -side left -anchor c
   bind $l_frm.ent <Leave> "__isv_SetWCSFunction %W $wcs_num"
   __isv_ValidateFormat_Binding $add_name $data_type $l_frm.ent
   if {[string match "" $gpb_addr_var($add_name,leader_name)]} {
    $l_frm.lbl config -bg $::SystemButtonFace
    } else {
    $l_frm.lbl config -bg $paOption(special_bg)
   }
   lappend Page::($page_obj,gcodlbl_list_2) $l_frm.lbl
   lappend Page::($page_obj,gcodent_list_2) $l_frm.ent
  }
  $grid set 1 $no_row -itemtype window -window $l_frm
  set coord_list [list x y z a b c]
  set col_idx 2
  foreach coord $coord_list {
   set ${coord}_frm $grid.${coord}_$wcs_num
   if { ![winfo exists ${coord}_frm] } \
   {
    set ${coord}_frm [eval frame $grid.${coord}_$wcs_num]
    set ent$col_idx [eval entry $${coord}_frm.ent -textvariable gPB($wcs_num,$coord) -width 6]
    pack [set ent$col_idx] -padx 15 -fill x
   }
   $grid set $col_idx $no_row -itemtype window -window [set ${coord}_frm]
   incr col_idx
  }
  set wcs_ent_list [list ent2 ent3 ent4 ent5 ent6 ent7]
  set data_type "f"
  set ind 0
  foreach it $wcs_ent_list {
   bind [set $it] <FocusOut> "__isvSaveWCSWinValue %W $wcs_num $ind"
   bind [set $it] <KeyPress>   "UI_PB_com_ValidateDataOfEntry %W %K $data_type"
   bind [set $it] <KeyRelease> "%W config -state normal"
   incr ind 1
  }
 }

#=======================================================================
proc __isv_CreatWCSColAttributes { grid} {
  global gPB
  global paOption tixOption
  global mom_sim_arr
  global isv_def_id
  set page_obj $isv_def_id
  set title_col(0) "$gPB(isv,wcs_number,Label)"
  set title_col(1) "$gPB(isv,wcs_leader,Label)"
  set title_col(2) "$gPB(isv,wcs_offset,origin_x,Label)"
  set title_col(3) "$gPB(isv,wcs_offset,origin_y,Label)"
  set title_col(4) "$gPB(isv,wcs_offset,origin_z,Label)"
  set title_col(5) "$gPB(isv,wcs_offset,a_offset,Label)"
  set title_col(6) "$gPB(isv,wcs_offset,b_offset,Label)"
  set title_col(7) "$gPB(isv,wcs_offset,c_offset,Label)"
  set style [tixDisplayStyle text -refwindow $grid \
  -fg $paOption(title_fg)\
  -anchor c -font $tixOption(bold_font)]
  set no_col 8
  for {set col 0} {$col < $no_col} {incr col} {
   $grid set $col 0 -itemtype text -text $title_col($col) -style $style
  }
  set len [llength $mom_sim_arr(\$mom_sim_wcsnum_list)]
  set Page::($page_obj,gcodent_list_2) [list]
  set Page::($page_obj,gcodlbl_list_2) [list]
  set mom_sim_arr(\$mom_sim_wcsnum_list) [lsort -dictionary $mom_sim_arr(\$mom_sim_wcsnum_list)]
  foreach wcs_num $mom_sim_arr(\$mom_sim_wcsnum_list) \
  {
   set count [lsearch $mom_sim_arr(\$mom_sim_wcsnum_list) $wcs_num]
   __isv__CreateWCSFirstColAttr $page_obj $grid [expr $count + 1] $wcs_num
   __isv__CreateWCSRestColAttr  $page_obj $grid [expr $count + 1] $wcs_num
  }
 }

#=======================================================================
proc __isv_SaveMachineZero { win } {
  global mom_sim_arr gPB
  $win config -takefocus 0
  set var [$win cget -textvariable]
  set value [set $var]
  switch $var {
   "gPB(zero_off_x)" { set mom_sim_arr(\$mom_sim_machine_zero_offsets) \
   [lreplace $mom_sim_arr(\$mom_sim_machine_zero_offsets) 0 0 $value]}
   "gPB(zero_off_y)" { set mom_sim_arr(\$mom_sim_machine_zero_offsets) \
   [lreplace $mom_sim_arr(\$mom_sim_machine_zero_offsets) 1 1 $value]}
   "gPB(zero_off_z)" { set mom_sim_arr(\$mom_sim_machine_zero_offsets) \
   [lreplace $mom_sim_arr(\$mom_sim_machine_zero_offsets) 2 2 $value]}
  }
 }

#=======================================================================
proc __isv_SimpleFormat { w area x1 y1 x2 y2 } {
  global margin
  global paOption
  set bg(x-margin) $paOption(title_bg)
  set bg(main)     gray20
  case $area {
   main {
    $w format grid $x1 $y1 $x2 $y2 -anchor se
   }
   {x-margin} {
    $w format border $x1 $y1 $x2 $y2 \
    -fill 1 -relief raised -bd 2 -bg $bg($area)
   }
   {y-margin} {
    $w format border $x1 $y1 $x2 $y2 \
    -fill 1 -relief raised -bd 2
   }
   {s-margin} {
    $w format border $x1 $y1 $x2 $y2 \
    -fill 1 -relief raised -bd 2 -bg $bg(x-margin)
   }
  }
 }

#=======================================================================
proc __isv_CreateMachineZeroGrid { frame } {
  global paOption gPB tixOption mom_sim_arr
  if ![info exists mom_sim_arr(\$mom_sim_machine_zero_offsets)] {
   set mom_sim_arr(\$mom_sim_machine_zero_offsets) [list 0.0 0.0 0.0]
  }
  set gPB(zero_off_x) [lindex $mom_sim_arr(\$mom_sim_machine_zero_offsets) 0]
  set gPB(zero_off_y) [lindex $mom_sim_arr(\$mom_sim_machine_zero_offsets) 1]
  set gPB(zero_off_z) [lindex $mom_sim_arr(\$mom_sim_machine_zero_offsets) 2]
  set grid [tixGrid $frame.grid -height 2 -width 3]
  pack $grid -fill both -expand yes
  $grid config -state disabled -formatcmd "__isv_SimpleFormat $grid" -highlightthickness 0
  $grid size col default -pad0 0 -pad1 0
  $grid size col 0       -pad0 0 -pad1 1 -size auto
  $grid size col 1       -pad0 0 -pad1 1 -size auto
  $grid size row default -pad0 0 -pad1 3 -size auto
  $grid size row 1       -pad0 0 -pad1 3 -size auto
  $grid size col 2       -pad0 0 -pad1 1 -size auto
  set col(0) $gPB(isv,wcs_offset,origin_x,Label)
  set col(1) $gPB(isv,wcs_offset,origin_y,Label)
  set col(2) $gPB(isv,wcs_offset,origin_z,Label)
  set var(0) x
  set var(1) y
  set var(2) z
  set style [tixDisplayStyle text  -refwindow $grid -bg $paOption(title_bg) -fg $paOption(special_fg) \
  -font $tixOption(bold_font) -anchor c]
  set style1 [tixDisplayStyle window -refwindow $grid -anchor c]
  for { set i 0 } {$i < 3} { incr i} {
   $grid set $i 0 -itemtype text -text "$col($i)" -style $style
   set frm$i [frame $grid.frm$i -relief raised]
   set frame [set frm$i]
   set ent$i [entry $frame.ent -textvariable gPB(zero_off_$var($i)) -width 10]
   set ent [set ent$i]
   pack $ent -fill both -padx 5 -pady 5
   $grid set $i 1 -itemtype window -window $frame -style $style1
   bind $ent <FocusOut> "__isv_SaveMachineZero %W"
   set data_type "f"
   bind $ent <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K $data_type"
   bind $ent <KeyRelease> "%W config -state normal"
  }
 }

#=======================================================================
proc __isv_CreateWCSInfoGrid { bot_frm } {
  global paOption
  tixScrolledGrid $bot_frm.scr -bd 0 -scrollbar auto
  [$bot_frm.scr subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  [$bot_frm.scr subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  pack $bot_frm.scr -fill both -padx 10 -pady 5
  set grid [$bot_frm.scr subwidget grid]
  set n_col 7
  global tix_version
  switch $tix_version {
   8.4 {
    $grid config -relief sunken -bd 3 \
    -state normal \
    -formatcmd "UI_PB_ads_SimpleFormat $grid" \
    -height 10 -width $n_col -highlightthickness 0
   }
   4.1 {
    $grid config -relief sunken -bd 3 \
    -formatcmd "UI_PB_ads_SimpleFormat $grid" \
    -state disabled \
    -height 10 -width $n_col -highlightthickness 0
   }
  }
  $grid size col default -pad0 0 -pad1 1
  $grid size col 0       -pad0 0 -pad1 1 -size auto
  $grid size col 1       -pad0 0 -pad1 3 -size auto
  $grid size row default -pad0 0 -pad1 3 -size auto
  $grid size row 0       -pad0 3 -pad1 3 -size auto
  __isv_CreatWCSColAttributes $grid
 }

#=======================================================================
proc __isv_WCSCreateOnerow {} {
  global paOption tixOption
  global gPB
  global mom_sim_arr
  if { [lsearch $mom_sim_arr(\$mom_sim_wcsnum_list) $gPB(add_wcs)] < 0 } {
   lappend mom_sim_arr(\$mom_sim_wcsnum_list) $gPB(add_wcs)
   set wcs_num $gPB(add_wcs)
   set mom_sim_arr(\$mom_sim_wcs_offsets\($wcs_num\)) [list 0.0 0.0 0.0 0.0 0.0 0.0]
   } else {
   set err_msg "$gPB(isv,wcs_offset,wcs_err,Msg)"
   tk_messageBox -parent [ UI_PB_com_AskActiveWindow ] \
   -message $err_msg \
   -icon warning -type ok
   return
  }
  __isv_RecreateWCSTable
 }

#=======================================================================
proc __isv_InitialWCSData {} {
  global mom_sim_arr post_object
  if {![info exists mom_sim_arr(\$mom_sim_wcsnum_list)]} {
   set mom_sim_arr(\$mom_sim_wcsnum_list) [list 0 1 2 3 4 5 6]
  }
  if {![info exists mom_sim_arr(\$mom_sim_wcs_offsets\(0\))]} {
   set  mom_sim_arr(\$mom_sim_wcs_offsets\(0\)) [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set  mom_sim_arr(\$mom_sim_wcs_offsets\(1\)) [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set  mom_sim_arr(\$mom_sim_wcs_offsets\(2\)) [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set  mom_sim_arr(\$mom_sim_wcs_offsets\(3\)) [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set  mom_sim_arr(\$mom_sim_wcs_offsets\(4\)) [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set  mom_sim_arr(\$mom_sim_wcs_offsets\(5\)) [list 0.0 0.0 0.0 0.0 0.0 0.0]
   set  mom_sim_arr(\$mom_sim_wcs_offsets\(6\)) [list 0.0 0.0 0.0 0.0 0.0 0.0]
  }
  if {![info exists mom_sim_arr(\$mom_sim_wcs_0)]} {
   set mom_sim_arr(\$mom_sim_wcs_0) "53"
   set mom_sim_arr(\$mom_sim_wcs_1) "54"
   set mom_sim_arr(\$mom_sim_wcs_2) "55"
   set mom_sim_arr(\$mom_sim_wcs_3) "56"
   set mom_sim_arr(\$mom_sim_wcs_4) "57"
   set mom_sim_arr(\$mom_sim_wcs_5) "58"
   set mom_sim_arr(\$mom_sim_wcs_6) "59"
  }
 }

#=======================================================================
proc __isv_WCSDefinitionParam { page_obj frame} {
  global gPB
  global paOption tixOption
  set subframe $frame
  set topest_frm [frame $frame.topest -relief sunken -bd 1]
  set top_frm [frame $subframe.top]
  set bot_frm [frame $subframe.bot]
  pack $frame.topest -side top -fill x -expand yes -padx 10 -pady 5
  pack $top_frm $bot_frm -side top -fill both -expand yes
  set bg_clr gray85
  $topest_frm config -bg $bg_clr
  set top_lbl [label $topest_frm.lbl -text $gPB(isv,machine_zero,offset,Label) -width 30 -justify left \
  -font $tixOption(bold_font) -bg $bg_clr]
  set zero_frame [frame $topest_frm.right -relief raised]
  pack $top_lbl $zero_frame -side left -padx 15 -pady 5
  __isv_CreateMachineZeroGrid $zero_frame
  set gPB(wcs_col) $bot_frm
  if {![info exists gPB(add_wcs)]} {
   set gPB(add_wcs) 0
  }
  set add_opt [tixControl $top_frm.col -integer true -min 0 -max 99 \
  -command    "" \
  -selectmode immediate \
  -variable gPB(add_wcs) -label "$gPB(isv,wcs_offset,wcs_num,Label)" \
  -options {
   entry.width 6
  label.anchor e}]
  set add_but [button $top_frm.add -text "$gPB(isv,wcs_offset,wcs_add,Label)" -bg $paOption(app_butt_bg) -width 8 \
  -command "__isv_WCSCreateOnerow"]
  pack $add_opt $add_but -side left -padx 10 -pady 8
  __isv_InitialWCSData
  __isv_CreateWCSInfoGrid $bot_frm
  set gPB(c_help,$add_opt) "isv,wcs_offset,wcs_num"
  set gPB(c_help,$add_but) "isv,wcs_offset,wcs_add"
 }

#=======================================================================
proc __isv_WCSDefinitionPage { page_obj frame } {
  set wcs_define [Page::CreateFrame $frame wcs]
  $wcs_define config -bd 1 -relief sunken
  pack $wcs_define -fill both -expand yes
  __isv_WCSDefinitionParam $page_obj $wcs_define
 }

#=======================================================================
proc __isv_ToolInfoDefPage { page_obj frame } {
  global gPB
  set tool_define [Page::CreateFrame $frame tol]
  $tool_define config -bd 1 -relief sunken
  pack $tool_define -fill both -expand yes
  __isv_ToolDefineFrame $tool_define
 }

#=======================================================================
proc __isv_cmd_CreateTreePopup {} {
  global isv_rev_id
  set page_obj $isv_rev_id
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  set popup [menu $h.pop -tearoff 0]
  set Page::($page_obj,tree_popup) $popup
  bind $h <3> "__isv_cmd_CreateTreePopupElements %X %Y %x %y"
 }

#=======================================================================
proc  __isv_UpdateCommandAdd { cur_name } {
  global mom_sim_arr mom_sys_arr
  global post_object
  if {[string match "Standalone" $mom_sys_arr(VNC_Mode)]} {
   set ind [lsearch $mom_sim_arr(\$mom_sim_user_com_list) $cur_name]
   if { $ind < 0} {
    lappend mom_sim_arr(\$mom_sim_user_com_list) $cur_name
   }
   set ind [lsearch $mom_sim_arr(\$mom_sim_vnc_com_list) $cur_name]
   if { $ind < 0} {
    lappend mom_sim_arr(\$mom_sim_vnc_com_list) $cur_name
   }
   } else {
   set ind [lsearch $mom_sim_arr(\$mom_sim_sub_user_list) $cur_name]
   if { $ind < 0} {
    lappend mom_sim_arr(\$mom_sim_sub_user_list) $cur_name
   }
   set ind [lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $cur_name]
   if { $ind < 0} {
    lappend mom_sim_arr(\$mom_sim_sub_vnc_list) $cur_name
   }
  }
 }

#=======================================================================
proc __isv_RemoveCmdProcFromList { prev_name } {
  global mom_sim_arr mom_sys_arr
  global post_object
  if {[string match "Standalone" $mom_sys_arr(VNC_Mode)]} {
   set ind [lsearch $mom_sim_arr(\$mom_sim_user_com_list) $prev_name]
   if { $ind >= 0} {
    set mom_sim_arr(\$mom_sim_user_com_list) [lreplace $mom_sim_arr(\$mom_sim_user_com_list) $ind $ind]
   }
   set ind [lsearch $mom_sim_arr(\$mom_sim_vnc_com_list) $prev_name]
   if { $ind >= 0} {
    set mom_sim_arr(\$mom_sim_vnc_com_list) [lreplace $mom_sim_arr(\$mom_sim_vnc_com_list) $ind $ind]
   }
   } else {
   set ind [lsearch $mom_sim_arr(\$mom_sim_sub_user_list) $prev_name]
   if { $ind >= 0} {
    set mom_sim_arr(\$mom_sim_sub_user_list) [lreplace $mom_sim_arr(\$mom_sim_sub_user_list) $ind $ind]
   }
   set ind [lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $prev_name]
   if { $ind >= 0} {
    set mom_sim_arr(\$mom_sim_sub_vnc_list) [lreplace $mom_sim_arr(\$mom_sim_sub_vnc_list) $ind $ind]
   }
  }
 }

#=======================================================================
proc  __isv_cmd_CreateTreePopupElements { X Y x y } {
  global gPB mom_sim_arr mom_sys_arr
  global isv_rev_id
  set page_obj $isv_rev_id
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  raise $gPB(main_window)
  set cursor_entry [$h nearest $y]
  set indent [$h cget -indent]
  if { [string compare $cursor_entry "0"] != 0 } \
  {
   if {![info exists Page::($page_obj,selected_index)]} {
    set Page::($page_obj,selected_index) -1
   }
   if [string match $Page::($page_obj,selected_index) $cursor_entry] {
    set Page::($page_obj,selected_index) -1
   }
   __isv_CodeItemSelection $page_obj $cursor_entry
  }
  set popup $Page::($page_obj,tree_popup)
  set active_index [$h info selection]
  if {[string match "Standalone" $mom_sys_arr(VNC_Mode)]} {
   set user_com_list $mom_sim_arr(\$mom_sim_user_com_list)
   } else {
   set user_com_list $mom_sim_arr(\$mom_sim_sub_user_list)
  }
  set token_list $mom_sim_arr(\$mom_sim_pre_com_list)
  set token_cmd_list [list]
  foreach token $token_list {
   set item [join [split $token] "_"]
   set item "PB_CMD_vnc__$item"
   lappend token_cmd_list $item
  }
  if { $x >= [expr $indent * 2] && \
   $Page::($page_obj,double_click_flag) == 0 && \
  $active_index == $cursor_entry } \
  {
   $popup delete 0 end
   set indx_string [$h entrycget $active_index -text]
   if { ([lsearch $user_com_list $indx_string] >= 0) &&  \
    ([lsearch $token_cmd_list $indx_string] < 0) } {
    $popup add command -label "$gPB(tree,rename,Label)" -state normal \
    -command "UI_PB_cmd_EditCmdName $page_obj $active_index"
    $popup add sep
    $popup add command -label "$gPB(tree,create,Label)" -state normal \
    -command "__isv_cmd_CreateACmdBlock $page_obj $active_index"
    $popup add command -label "$gPB(tree,cut,Label)" -state normal \
    -command "__isv_cmd_CutACmdBlock $page_obj"
    } else {
    $popup add command -label "$gPB(tree,rename,Label)" -state disabled \
    -command ""
    $popup add sep
    if { [string match "*map_machine_tool_axes" $indx_string] || \
     [string match "*set_nc_definitions"    $indx_string] || \
     [string match "*sim_other_devices"     $indx_string] || \
     [string match "*process_nc_block"      $indx_string] } {
     $popup add command -label "$gPB(tree,create,Label)" -state disabled -command ""
     } else {
     $popup add command -label "$gPB(tree,create,Label)" -state normal \
     -command "__isv_cmd_CreateACmdBlock $page_obj $active_index"
    }
    $popup add command -label "$gPB(tree,cut,Label)" -state disabled -command ""
   }
   if [info exists Page::($page_obj,buff_cmd_obj)] {
    $popup add command -label "$gPB(tree,paste,Label)" -state normal \
    -command "__isv_cmd_PasteACmdBlock $page_obj"
    } else {
    $popup add command -label "$gPB(tree,paste,Label)" -state disabled -command ""
   }
   tk_popup $popup $X $Y
  }
 }

#=======================================================================
proc __isv_cmd_CreateTreeElements {} {
  global paOption
  global isv_rev_id
  set page_obj $isv_rev_id
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  $h config -bg $paOption(tree_bg)
  uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]
  $tree config \
  -command   "UI_PB_cmd_EditCmdName $page_obj" \
  -browsecmd "__isv_CodeItemSelection $page_obj [$h info selection]"
 }

#=======================================================================
proc __isv_AddReviewCodePage { book_id page_obj } {
  global paOption tixOption
  global mom_sys_arr gPB
  global isv_rev_id
  set isv_rev_id $page_obj
  set gPB(rev_pageid) [$book_id subwidget $Page::($page_obj,page_name)]
  set Page::($page_obj,page_id) $gPB(rev_pageid)
  __isv_SetPageAttributes page_obj
  if [info exists Page::($page_obj,active_cmd_obj)] \
  {
   unset Page::($page_obj,active_cmd_obj)
  }
  Page::CreatePane $page_obj
  __isv_AddComponentsLeftPane page_obj
  Page::CreateTree $page_obj
  __isv_cmd_CreateTreePopup
  __isv_cmd_CreateTreeElements
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) \
  "__isv_DefaultCallBack $page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "__isv_RestoreCallBack $page_obj"
  set canvas_frame $Page::($page_obj,canvas_frame)
  UI_PB_com_CreateButtonBox $canvas_frame label_list cb_arr
  pack configure $canvas_frame.box -padx 3
  __isv_CreateCodeParamPages $page_obj
  set Page::($page_obj,double_click_flag) 0
 }

#=======================================================================
proc __isv_ValidatePrevPageData { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  global gPB
  set raise_page 0
  set current_tab $Book::($book_obj,current_tab)
  set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
  switch -exact -- $current_tab \
  {
   0 { ;# VNC definition Page
    set raise_page_1 [UI_PB_isv_setup_ValidateToolname 0]
    global isv_def_id
    set page_obj $isv_def_id
    set tree $Page::($page_obj,tree)
    set h [$tree subwidget hlist]
    set def_item [$h selection get]
    set raise_page_2 [UI_PB_isv_setup_ValidateEmptyEntry $def_item]
    if { $raise_page_1 || $raise_page_2 } {
     set raise_page 1
    }
   }
   1 {
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
    }
    if { !$raise_page } \
    {
     set Page::($page_obj,selected_index) -1
    }
   }
  }
  if $raise_page {
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
  0 { ;#<07-13-08 lxy> validate tool name
   global isv_def_id
   set page_obj $isv_def_id
   set tree $Page::($page_obj,tree)
   set h [$tree subwidget hlist]
   set def_item [$h selection get]
   if { ![string compare $def_item 0.2.1] && [UI_PB_isv_setup_ValidateToolname 0] } {
    UI_PB_isv_setup_ValidateToolname 1
    } else {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
    -message $gPB(machine,empty_entry_err,msg) \
    -icon error
   }
  }
  1 {
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
  "def"  { set new_tab 0 }
  "cod"  { set new_tab 1 }
  default { set new_tab 0 }
 }
 set Book::($book_obj,current_tab) $new_tab
 UI_PB_isv_DeleteTabAttr book_obj
 set Book::($book_obj,current_tab) $current_tab
}
return $raise_page
}

#=======================================================================
proc __isv_SetupDefTab { book_id page_img book_obj } {
  CB_nb_def $book_id $page_img $book_obj
  if { [__isv_ValidatePrevPageData book_obj] } \
  {
   return
  }
  UI_PB_isv_DeleteTabAttr book_obj
  set Book::($book_obj,current_tab) 0
  UI_PB_isv_CreateTabAttr book_obj
 }

#=======================================================================
proc __isv_ReviewCodeTab { book_id page_img book_obj } {
  CB_nb_def $book_id $page_img $book_obj
  if { [__isv_ValidatePrevPageData book_obj] } \
  {
   return
  }
  UI_PB_isv_DeleteTabAttr book_obj
  set Book::($book_obj,current_tab) 1
  UI_PB_isv_CreateTabAttr book_obj
 }

#=======================================================================
proc __isv_InitModeDefineFrame { frame } {
  global mom_sim_arr
  global gPB
  set frame [$frame subwidget frame]
  set md_frm [frame $frame.mode]
  pack $md_frm -pady 5 -fill both
  set mode_opt_1 [radiobutton $md_frm.opt_1 -variable mom_sim_arr(\$mom_sim_input_mode) \
  -text "$gPB(isv,absolute_mode,Label)" -value "ABS" -width 14 -anchor w]
  set mode_opt_2 [radiobutton $md_frm.opt_2 -variable mom_sim_arr(\$mom_sim_input_mode) \
  -text "$gPB(isv,incremental_mode,Label)" -value "INC" -width 16 -anchor w]
  pack $mode_opt_1  -side left  -pady 2
  pack $mode_opt_2  -side right -pady 2
  set gPB(c_help,$md_frm.opt_1) "isv,setup,initial_mode,frame"
  set gPB(c_help,$md_frm.opt_2) "isv,setup,initial_mode,frame"
 }

#=======================================================================
proc __isv_SetSpiModeValue { value } {
  global mom_sim_nc_register
  set mom_sim_nc_register(SPINDLE_MODE) $value
 }

#=======================================================================
proc __isv_SetSpiDireValue { value } {
  global mom_sim_nc_register
  set mom_sim_nc_register(SPINDLE_DIRECTION) $value
 }

#=======================================================================
proc __isv_SetFeedModeVallue { value } {
  global mom_sim_nc_register
  set mom_sim_nc_register(FEED_MODE) $value
 }

#=======================================================================
proc __isv_SpindleDefineFrame { frame } {
  global mom_sim_arr mom_kin_var
  global gPB
  set frame [$frame subwidget frame]
  set frame_2 [frame $frame.dir]
  pack $frame_2 -side left -padx 5 -pady 5 -fill both
  if {[string match "IN" $mom_kin_var(\$mom_kin_output_unit)]} {
   set options_1 [list "SFM" "REV_PER_MIN"]
   } else {
   set options_1 [list "SMM" "REV_PER_MIN"]
  }
  if { ( [info exists mom_sim_arr(\$mom_sim_spindle_mode)] &&  \
   [lsearch $options_1 $mom_sim_arr(\$mom_sim_spindle_mode)] < 0 ) ||\
   ![info exists mom_sim_arr(\$mom_sim_spindle_mode)] } {
   set mom_sim_arr(\$mom_sim_spindle_mode) [lindex $options_1 0]
  }
  set gPB(spindle_mode) [tixOptionMenu $frame_2.mode \
  -label "$gPB(isv,setup,spindle_mode,Label)" \
  -variable mom_sim_arr(\$mom_sim_spindle_mode) \
  -options {
   label.width 18
   label.anchor w
   menubutton.width 12
  }]
  foreach op $options_1 {
   $frame_2.mode add command $op -label $op
  }
  set options_2 [list "CLW" "CCLW" "OFF"]
  tixOptionMenu $frame_2.dir \
  -label "$gPB(isv,setup,spindle_direction,Label)" \
  -variable mom_sim_arr(\$mom_sim_spindle_direction) \
  -options {
   label.width 18
   label.anchor w
   menubutton.width 12
  }
  foreach op $options_2 {
   $frame_2.dir add command $op -label $op
  }
  pack $frame_2.mode $frame_2.dir -side top -padx 5 -pady 2
  set gPB(c_help,$frame_2.mode) "isv,setup,spindle,frame"
  set gPB(c_help,$frame_2.dir) "isv,setup,spindle,frame"
 }

#=======================================================================
proc __isv_FeedRateDefineFrame { frame } {
  global gPB mom_sim_arr
  global mom_kin_var
  set frame [$frame subwidget frame]
  set frame_2 [frame $frame.dir]
  pack $frame_2 -side left -padx 5 -pady 5 -fill both
  set output_unit $mom_kin_var(\$mom_kin_output_unit)
  if {[string match "IN" $output_unit]} {
   set options_3 [list "INCH_PER_MIN" "IN_PER_REV"]
   set mom_sim_arr(\$mom_sim_feed_mode) "INCH_PER_MIN"
   } else {
   set options_3 [list "MM_PER_MIN" "MM_PER_REV" "MM_PER_100REV"]
   set mom_sim_arr(\$mom_sim_feed_mode) "MM_PER_MIN"
  }
  tixOptionMenu $frame_2.fmod \
  -label "$gPB(isv,setup,feedrate_mode,Label)" \
  -variable mom_sim_arr(\$mom_sim_feed_mode) \
  -options {
   label.width 18
   label.anchor w
   menubutton.width 12
  }
  foreach op $options_3 {
   $frame_2.fmod add command $op -label $op
  }
  pack  $frame_2.fmod -side top -padx 5 -pady 2
  set menu [$frame_2.fmod subwidget menubutton]
  set gPB($frame_2.fmod) "isv,setup,feedrate_mode"
 }

#=======================================================================
proc __isv_SetMotionValue { value } {
  global mom_sim_nc_register
  global mom_sim_arr
  set mom_sim_nc_register(MOTION) $value
 }

#=======================================================================
proc __isv_MotionDefineFrame {frame } {
  global mom_sim_arr
  global gPB
  set frame_sub [$frame subwidget frame]
  set frame [frame $frame_sub.sub]
  pack $frame -padx 5 -pady 5 -fill both
  set opt_list [list "RAPID" "LINEAR"]
  tixOptionMenu $frame.mot \
  -label "$gPB(isv,setup,initial_motion,Label)" \
  -variable mom_sim_arr(\$mom_sim_initial_motion) \
  -options {
   label.width 18
   label.anchor w
   menubutton.width 12
  }
  foreach op $opt_list {
   $frame.mot add command $op -label $op
  }
  pack $frame.mot  -padx 5 -pady 2
  set gPB(c_help,$frame.mot) "isv,setup,initial_motion"
 }

#=======================================================================
proc __isv_OnOffDefineFrame { frame } {
  global mom_sim_arr
  global gPB
  global paOption tixOption
  set frame_sub [$frame subwidget frame]
  set frame [frame $frame_sub.sub]
  pack $frame -pady 5 -padx 10 -fill both
 }

#=======================================================================
proc UI_PB_isv_DisplayCommandDecs { cmd_obj page_obj } {
  global gPB
  if {![info exists gPB(pre_list)]} {
   return
  }
  if { ![info exists gPB(desc_txt)] || ![winfo exists $gPB(desc_txt)] } {
   return
  }
  $gPB(desc_txt) delete 0.0 end
  $gPB(desc_txt) insert end $command::($cmd_obj,description)
  set desc_out $gPB(pre_text)
  $desc_out delete 0.0 end
  $desc_out insert end $command::($cmd_obj,description)
 }

#=======================================================================
proc __isv_DefaultCallBack { page_obj } {
  global post_object
  global mom_sim_arr
  global pb_cmd_procname
  if { ![info exists Page::($page_obj,active_cmd_obj)] } \
  {
   return
  }
  UI_PB_cmd_DeleteCmdProc $page_obj
  set cmd_obj $Page::($page_obj,active_cmd_obj)
  array set def_cmd_attr $command::($cmd_obj,def_value)
  command::setvalue $cmd_obj def_cmd_attr
  UI_PB_cmd_DisplayCmdProc cmd_obj page_obj
  UI_PB_isv_DisplayCommandDecs $cmd_obj $page_obj
 }

#=======================================================================
proc __isv_RestoreCallBack { page_obj } {
  global post_object
  global pb_cmd_procname
  global gPB
  if { ![info exists Page::($page_obj,active_cmd_obj)] } \
  {
   return
  }
  UI_PB_cmd_DeleteCmdProc $page_obj
  set cmd_obj $Page::($page_obj,active_cmd_obj)
  if {![info exists command::($cmd_obj,rest_value)]} {
   set command::($cmd_obj,rest_value) $command::($cmd_obj,def_value)
  }
  array set rest_cmd_attr $command::($cmd_obj,rest_value)
  command::setvalue $cmd_obj rest_cmd_attr
  UI_PB_cmd_DisplayCmdProc cmd_obj page_obj
  UI_PB_isv_DisplayCommandDecs $cmd_obj $page_obj
 }

#=======================================================================
proc __isv_Def_DisableDefPages { page_obj } {
  global gPB
 }

#=======================================================================
proc __isv_Add_CancelOrDestroyCB { page_obj } {
  global gPB
  set act_cmd_obj $Page::($page_obj,active_cmd_obj)
  set original_text ""
  if { $act_cmd_obj > 0 && [info exists command::($act_cmd_obj,description)] } {
   set original_text $command::($act_cmd_obj,description)
  }
  set com_list $gPB(pre_list)
  set desc_out $gPB(pre_text)
  if {[info exists gPB(pre_add)] && $gPB(pre_add)} {
   __isv_DeleteSpecialCommand $com_list
   PB_com_unset_var gPB(pre_add)
  }
  $desc_out delete 0.0 end
  $desc_out insert end $original_text
 }

#=======================================================================
proc __isv_Def_ActiveDefPages { page_obj win_index } {
  global gPB
  if { $gPB(toplevel_disable_$win_index) } \
  {
   set gPB(toplevel_disable_$win_index) 0
  }
  __isv_Add_CancelOrDestroyCB $page_obj
 }

#=======================================================================
proc __isv_Def_CancCallBack { win page_obj } {
  global gPB
  __isv_Add_CancelOrDestroyCB $page_obj
  destroy $win
  __isv_ChangeSetupTreeStatus
  __isv_RecreateSpecHList seq
 }

#=======================================================================
proc __isv_cmd_SaveDescription { cmd_obj } {
  global gPB
  global post_object
  array set vnc_desc_arr $Post::($post_object,mom_vnc_desc_list)
  set cmd_name $command::($cmd_obj,name)
  set vnc_desc_arr($cmd_name,desc) $command::($cmd_obj,description)
  set Post::($post_object,mom_vnc_desc_list) [array get vnc_desc_arr]
 }

#=======================================================================
proc __isv_Def_OkCallBack { win page_obj } {
  global post_object gPB
  global new_custom_name
  __isv_ApplyCallBack $page_obj
  PB_com_unset_var gPB(cus_add)
  PB_com_unset_var gPB(pre_add)
  destroy $win
  __isv_ChangeSetupTreeStatus
  __isv_RecreateSpecHList seq
 }

#=======================================================================
proc __isv_ValidateSpecCommandOK {} {
  return 1
 }

#=======================================================================
proc __isv_ApplyCallBack { page_obj } {
  global gPB
  set ret_code [__isv_ValidateSpecCommandOK]
  if { $ret_code == 1} {
   if { ![UI_PB_cmd_SaveCmdProc $page_obj] } {
    return
   }
   set active_cmd $Page::($page_obj,active_cmd_obj)
   command::readvalue $active_cmd cmd_obj_attr
   set text [$gPB(desc_txt) get 0.0 end]
   set command::($active_cmd,description) $text
   set cmd_obj_attr(1) $command::($active_cmd,proc)
   set cmd_obj_attr(5) $command::($active_cmd,description)
   command::setvalue $active_cmd cmd_obj_attr
   command::RestoreValue $active_cmd
   __isv_cmd_SaveDescription $active_cmd
   } else {
   set title "$gPB(cust_cmd,error,title)"
   set err_msg "$gPB(cust_cmd,error,msg)"
   tk_messageBox -parent [ UI_PB_com_AskActiveWindow ] -type ok -icon error \
   -title $title -message $err_msg
  }
 }

#=======================================================================
proc __isv_Def_ConfigDefNavButtons { page_obj win frame} {
  global gPB
  global cb_arr
  set cb_arr(gPB(nav_button,default,Label)) \
  "__isv_DefaultCallBack $page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "__isv_RestoreCallBack $page_obj"
  set cb_arr(gPB(nav_button,apply,Label)) \
  "__isv_ApplyCallBack $page_obj"
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "__isv_Def_CancCallBack $win $page_obj"
  set cb_arr(gPB(nav_button,ok,Label))  \
  "__isv_Def_OkCallBack $win $page_obj"
  set box_frm_1 [frame $frame.box_frm_1]
  set box_frm_2 [frame $frame.box_frm_2]
  tixForm $box_frm_2 -top 0 -left 0 -right %60 -padright 20
  tixForm $box_frm_1 -top 0 -left $box_frm_2 -right %100
  set label_list_1 { "gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)"}
  set label_list_2 { "gPB(nav_button,default,Label)" \
   "gPB(nav_button,restore,Label)" \
  "gPB(nav_button,apply,Label)"}
  UI_PB_com_CreateButtonBox $box_frm_1 label_list_1 cb_arr
  UI_PB_com_CreateButtonBox $box_frm_2 label_list_2 cb_arr
 }

#=======================================================================
proc __isv_CreateSpecialCommandWindow { cus_list args } {
  global gPB
  global paOption
  global isv_def_id
  global mom_sys_arr mom_sim_arr
  global post_object
  if { [llength $args] } {
   if { [string match "add" [lindex $args 0]] } {
    set gPB(pre_add) 1
    } else {
    set gPB(pre_add) 0
   }
  }
  set page_obj $isv_def_id
  set cmd_obj $Page::($page_obj,active_cmd_obj)
  if { $cmd_obj <= 0 } {
   tk_messageBox -message "VNC command does not exist.\nRemove token from the list!" -icon error
   return
  }
  if { ![string compare [$cus_list selection get] ""] } {
   set title "$gPB(cust_cmd,error,title)"
   set err_msg "$gPB(isv,command_sel,err,Msg)"
   tk_messageBox -parent [ UI_PB_com_AskActiveWindow ] \
   -title $gPB(cust_cmd,error,title) -message $gPB(isv,spec_command,sel_err,Msg) \
   -icon error
   return
  }
  if { [string match $mom_sys_arr(VNC_Mode) "Standalone"] } {
   set pre_cmd_name_list $mom_sim_arr(\$mom_sim_user_com_list)
   } else {
   set pre_cmd_name_list $mom_sim_arr(\$mom_sim_sub_user_list)
  }
  Post::GetObjList $post_object command cmd_obj_list
  set pre_cmd_obj_list [list]
  foreach cmd_name $pre_cmd_name_list {
   foreach cmd_obj $cmd_obj_list {
    if { ![string compare $command::($cmd_obj,name) $cmd_name] } {
     lappend pre_cmd_obj_list $cmd_obj
     break
    }
   }
  }
  if { [llength $pre_cmd_obj_list] } {
   foreach cmd $pre_cmd_obj_list {
    command::readvalue $cmd cmd_attr
    set command::($cmd,rest_value) [array get cmd_attr]
   }
  }
  set w [toplevel $gPB(active_window).spec]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $w \
  "$gPB(isv,spec_command,title,Label)" "800x600+200+200" \
  "" "__isv_Def_DisableDefPages $page_obj" "" \
  "__isv_Def_ActiveDefPages $page_obj $win_index"
  __isv_CreateSpecCustomPage $page_obj $w $cus_list
  UI_PB_com_CenterWindow $w
 }

#=======================================================================
proc __isv_AddSIMCommand {} {
  global gPB
  global isv_def_id
  set page_obj $isv_def_id
  set text_widget $Page::($page_obj,text_widget)
  $text_widget insert insert $Page::($page_obj,comb_var)
  __isv_UseNoteBalloon
 }

#=======================================================================
proc __isv_InsertDesciption { cus_list key_text } {
  global gPB
  if 0 {
   set desc_out $gPB(pre_text)
   tixEnableAll $desc_out
   set text [$gPB(desc_txt) get 0.0 end]
   $desc_out delete 0.0 end
   $desc_out insert 0.0 $text
   tixDisableAll $desc_out
   } else {
   global isv_def_id post_object
   global is_from_spec_cmd_win
   if { ![info exists is_from_spec_cmd_win] || $is_from_spec_cmd_win == 0 } {
    set is_from_spec_cmd_win 1
   }
   set page_obj $isv_def_id
   set cmd_obj $Page::($page_obj,active_cmd_obj)
   if { [info exists Post::($post_object,mom_vnc_desc_list)] } {
    array set vnc_desc_arr $Post::($post_object,mom_vnc_desc_list)
    } else {
    array set vnc_desc_arr [list]
   }
   set desc_txt [$gPB(desc_txt) get 0.0 end]
   set command::($cmd_obj,description) $desc_txt
   set cmd_name command::($cmd_obj,name)
   set vnc_desc_arr($cmd_name,desc) $desc_txt
   set Post::($post_object,mom_vnc_desc_list) [array get vnc_desc_arr]
  }
 }

#=======================================================================
proc __isv_CreateSpecCustomPage { page_obj win cus_list} {
  global gPB
  global paOption tixOption
  global post_object
  global mom_sys_arr mom_sim_arr
  set w $win
  set cmd_obj $Page::($page_obj,active_cmd_obj)
  set Page::($page_obj,panel_hi) 80
  set Page::($page_obj,glob_text_shift) 10
  set bg $paOption(title_bg)
  set fg $paOption(special_fg)
  set ft $gPB(bold_font)
  set top_canvas_dim(0) 80
  set top_canvas_dim(1) 200
  set bot_canvas_dim(0) 100
  set bot_canvas_dim(1) 200
  set top_canvas [canvas $w.top]
  $top_canvas config -height $top_canvas_dim(0) -width $top_canvas_dim(1)
  set bot_canvas [canvas $w.bot -highlightthickness 0]
  $bot_canvas config -height $bot_canvas_dim(0) -width $bot_canvas_dim(1)
  pack $top_canvas -side top -fill x -padx 3 ;#<07-15-09 wbh> 3 was 10
  pack $bot_canvas -side bottom -anchor s -fill both -expand yes -padx 3 -pady 3 ;#<07-15-09 wbh> 3 was 10. Add -pady
  set top_frm [frame $top_canvas.sub -bg $paOption(name_bg) -relief solid -borderwidth 1]
  set frame [frame $bot_canvas.f1]
  __isv_Def_ConfigDefNavButtons $page_obj $win $frame
  set progtop_frm [frame $bot_canvas.f3 -bg $bg]
  set content_frm [frame $bot_canvas.f2]
  set progbot_frm [frame $bot_canvas.f4 -bg $bg]
  set desc        [frame $bot_canvas.d1]
  pack $frame       -side bottom -fill x -anchor s
  pack $desc        -side bottom -fill both -expand yes -pady 5
  pack $top_frm     -side top    -expand no  -fill x
  pack $progtop_frm -side top    -expand no  -fill x
  pack $progbot_frm -side bottom -expand no  -fill x
  pack $content_frm -side top    -expand yes -fill both
  set bc [$top_canvas config -background]
  $top_canvas config -highlightcolor [lindex $bc end]
  set Page::($page_obj,top_canvas) $top_canvas
  set Page::($page_obj,bot_canvas) $bot_canvas
  set edit_com_name [string range $command::($cmd_obj,name) 12 end]
  set code_but [label $top_frm.but -text " $edit_com_name " -font $gPB(bold_font_lg) \
  -bg $paOption(active_color) -relief ridge -bd 2] ;#<01-17-08 gsl> -relief was sunken
  set Page::($page_obj,add_name) " $gPB(isv,spec_command,add_sim,Label) "
  set top_but [button $top_frm.addbut -text "$gPB(isv,spec_command,add_sim,Label)" \
  -command "__isv_AddSIMCommand" -bg $paOption(app_butt_bg)]
  set combo_frm [frame $top_frm.frm]
  pack $code_but  -side left  -padx 20 -pady 10 -fill x
  pack $top_but   -side left  -padx 20 -pady 10 -fill x -expand yes
  pack $combo_frm -side right -padx 30 -pady 10 -fill x ;# A combo box can not be stretched. -expand yes
  set Page::($page_obj,comb_var) ""
  set gPB(mom_sim_command) ""
  UI_PB_mthd_CreateMenu $page_obj $combo_frm
  __isv_CreateMenuOptions $page_obj
  if { [string first " " $edit_com_name] > 0 } {
   set edit_com_name [join [split $edit_com_name " "] _]
  }
  set cmd_name "PB_CMD_vnc__$edit_com_name"

#=======================================================================
set cur_cmd_proc $command::($cmd_obj,proc)

#=======================================================================
set prog_head_text "proc PB_CMD_vnc__$edit_com_name  \{  \}  \{ "
  set progtop_label [label $progtop_frm.lbl -text $prog_head_text -bg $bg -fg $fg -font $ft]
  pack $progtop_label -side left -padx 5 -pady 5
 set progbot_label [label $progbot_frm.lbl -text "\}" -bg $bg -fg $fg -font $ft]
 pack $progbot_label -side left -padx 5 -pady 5
 tixScrolledText $content_frm.scr
 [$content_frm.scr subwidget hsb] config -troughcolor $paOption(trough_bg) \
 -width $paOption(trough_wd)
 [$content_frm.scr subwidget vsb] config -troughcolor $paOption(trough_bg) \
 -width $paOption(trough_wd)
 pack $content_frm.scr -fill both -expand yes ;#<May-25-2017 gsl> added -expand ;# was -fill x
 set text_widget [$content_frm.scr subwidget text]
 $text_widget config -font $gPB(fixed_font) -wrap none -bd 5 -relief flat
 set Page::($page_obj,text_widget) $text_widget
 UI_PB_cmd_DisplayCmdProc cmd_obj page_obj
 if { ![info exists gPB(text_select_bg)] } {
  set gPB(text_select_bg) [lindex [$text_widget cget -selectbackground] 0]
 }
 bind $text_widget <1> "%W config -selectbackground $gPB(text_select_bg)"
 set desc_lbl    [label $desc.lbl -text "$gPB(isv,spec_desc,Label)" -font $tixOption(italic_font) -width 12]
 set desc_scrtxt [tixScrolledText $desc.scr -height 45 -scrollbar y]
 [$desc.scr subwidget hsb] config -troughcolor $paOption(trough_bg) \
 -width $paOption(trough_wd)
 set desc_txt [$desc.scr subwidget text]
 set gPB(desc_txt) $desc_txt
 $gPB(desc_txt) config -wrap word -font $gPB(font)
 bind $desc_txt <KeyRelease> "__isv_InsertDesciption $cus_list %K"
 pack $desc_lbl -side left
 pack $desc.scr -side right -fill both -expand yes ;#<May-25-2017 gsl> -fill was x.
 $desc_txt delete 0.0 end
 if { [info exists command::($cmd_obj,description)] && ![string match "" $command::($cmd_obj,description)] } {
  set description [string trimright $command::($cmd_obj,description) \n]
  if 0 {
   set description [split $description "\n"]
   foreach line $description {
    $desc_txt insert insert "$line\n"
   }
  }
  $desc_txt insert insert $description
  set desc_txt [string trimright $desc_txt \n]
 }
 global gPB
 set gPB(custom_command_paste_buffer) ""
 set t_list [list $text_widget $desc_txt]
 foreach t $t_list {
  if [winfo exists $t.pop] {
   set menu $t.pop
   } else {
   set menu [menu $t.pop -tearoff 0 -cursor ""]
  }
  bind $t <3> "UI_PB_cmd_AddPopUpMenu $page_obj $t $menu %X %Y"
  bind $t <KeyPress> "_cmd_ChangeTabKey $t %K"
 }
 focus $text_widget
 global tix_version
 if ![string compare $tix_version 8.4] {
  UI_PB_com_HighlightTclKeywords $text_widget
 }
}

#=======================================================================
proc __isv_CreateAddBlocktoTextWidget { page_obj } {
  global paOption
  global tixOption
  global gPB
  set top_canvas $Page::($page_obj,top_canvas)
  set panel_hi $Page::($page_obj,panel_hi)
  set add_comp [image create compound -window $top_canvas \
  -bd 1 \
  -background #c0c0ff \
  -borderwidth 2 \
  -relief raised \
  -showbackground 1]
  $add_comp add text -text $Page::($page_obj,add_name) \
  -font $tixOption(bold_font) -anchor w
  set dx 250
  set dy [expr [expr $panel_hi / 2] + 5]
  $top_canvas create image $dx $dy -image $add_comp \
  -tag add_movable
  $add_comp config -bg $paOption(app_butt_bg)
  set Page::($page_obj,add) $add_comp
 }

#=======================================================================
proc __isvDestroyNotballon {} {
  global gPB
  global gPB_help_tips gPB_use_balloons
  global isv_def_id
  set page_obj $isv_def_id
  set bot_canvas $Page::($page_obj,bot_canvas)
  PB_cancel_balloon
  set gPB_help_tips($bot_canvas) ""
  set gPB_use_balloons $gPB(oribal)
  unset gPB_help_tips($bot_canvas)
  PB_enable_balloon Canvas
 }

#=======================================================================
proc __isv_UseNoteBalloon {args} {
  global mom_sim_cmd_array
  global gPB
  global gPB_use_balloons
  global balloon_after_ID
  global isv_def_id
  set page_obj $isv_def_id
  set gPB(mom_sim_command) $Page::($page_obj,comb_var)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set top_canvas $Page::($page_obj,top_canvas)
  set panel_hi $Page::($page_obj,panel_hi)
  set xi 200
  set yi 200
  set rootx [winfo rootx $bot_canvas]
  set rooty [winfo rooty $bot_canvas]
  if {![info exists mom_sim_cmd_array($gPB(mom_sim_command),args)]} {
   set mom_item_args_list [list]
   } else {
   set mom_item_args_list $mom_sim_cmd_array($gPB(mom_sim_command),args)
  }
  set itlength [llength $mom_item_args_list]
  if { $itlength > 0} {
   set display_text " $mom_item_args_list"
   } else {
   set display_text "NO extra args needed!"
  }
  if {[winfo exists .balloon_help]} {
   destroy .balloon_help
  }
  PB_disable_balloon Canvas
  set gPB(oribal) $gPB_use_balloons
  set gPB_use_balloons 1
  set balloon_after_ID [create_balloon $display_text [expr int($xi) + $rootx] [expr int($yi) + $rooty]]
  wm transient .balloon_help $bot_canvas
  if { $itlength > 0 } {
   .balloon_help.lead config  -text "Variables Needed:"
  }
  bind .balloon_help <ButtonPress-1> "__isvDestroyNotballon"
 }
 if 1 {

#=======================================================================
proc __isv_CreateMenuOptions { page_obj } {
  global gPB env
  global mom_sim_cmd_array
  set gPB(sim_cmd_obj_list) [list]
  set sim_cmd_file "$env(PB_HOME)/app/dbase/pb_sim.tcl"
  PB_pps_ParseTclFile $sim_cmd_file event_proc_data 0
  set event_name_list [array get event_proc_data]
  set llen [llength $event_name_list]
  for {set i 0} {$i < $llen} {incr i 2} \
  {
   set event_item [lindex $event_name_list $i]
   set event_name [lindex [split $event_item ,] 0]
   set event_val_name [lindex [split $event_item ,] 1]
   if { [llength [info procs $event_name]] > 0 } {
    if {[string match "SIM*" $event_name]} {
     lappend gPB(sim_cmd_obj_list) $event_name
     if {[string match "args" $event_val_name]} {
      set mom_sim_cmd_array($event_name,args) $event_proc_data($event_name,args)
     }
    }
   }
  }
  set gPB(sim_cmd_obj_list) [ltidy $gPB(sim_cmd_obj_list)]
  set first_cmd [lindex $gPB(sim_cmd_obj_list) 0]
  set Page::($page_obj,comb_var) $first_cmd
  set comb_widget $Page::($page_obj,comb_widget)
  set sim_length [llength $gPB(sim_cmd_obj_list)]
  $comb_widget add cascade -label "Motion" -menu $comb_widget.move
  menu $comb_widget.move
  $comb_widget add cascade -label "Transform" -menu $comb_widget.mount
  menu $comb_widget.mount
  $comb_widget add cascade -label "Query" -menu $comb_widget.ask
  menu $comb_widget.ask
  $comb_widget add cascade -label "Setting" -menu $comb_widget.set
  menu $comb_widget.set
  $comb_widget add cascade -label "Feedback" -menu $comb_widget.dbg
  menu $comb_widget.dbg
  $comb_widget add cascade -label "Macro" -menu $comb_widget.mac
  menu $comb_widget.mac
  $comb_widget add cascade -label "Miscellaneous" -menu $comb_widget.mis
  menu $comb_widget.mis
  for {set count 0} {$count < $sim_length} {incr count} {
   set item [lindex $gPB(sim_cmd_obj_list) $count]
   if {[string match "SIM_move*" $item]} {
    $comb_widget.move add command -label $item -command "__isv_SetSIMCommand $item"
    } elseif { [string match "SIM_transform*" $item] ||    \
    [string match "SIM_convert*" $item] } {
    $comb_widget.mount add command -label $item -command "__isv_SetSIMCommand $item"
    } elseif { [string match "SIM_ask*" $item] ||    \
    [string match "SIM_is*" $item] ||   \
    [string match "SIM_find*" $item] } {
    $comb_widget.ask add command -label $item -command "__isv_SetSIMCommand $item"
    } elseif {[string match "SIM_set*" $item]} {
    $comb_widget.set add command -label $item -command "__isv_SetSIMCommand $item"
    } elseif {[string match "SIM_feedback*" $item] ||   \
    [string match "SIM_msg*" $item]} {
    $comb_widget.dbg add command -label $item -command "__isv_SetSIMCommand $item"
    } elseif {[string match "SIM_macro*" $item] } {
    $comb_widget.mac add command -label $item -command "__isv_SetSIMCommand $item"
    } else {
    $comb_widget.mis add command -label $item -command "__isv_SetSIMCommand $item"
   }
  }
 }
}

#=======================================================================
proc __isv_SetSIMCommand { item } {
  global gPB
  global isv_def_id
  set page_obj $isv_def_id
  set gPB(mom_sim_command) $item
  set Page::($page_obj,comb_var) $item
  __isv_UseNoteBalloon
 }

#=======================================================================
proc __isv_SetPowerOnWCSValue {} {
  global mom_sim_arr mom_sim_nc_register
  set mom_sim_nc_register(POWER_ON_WCS) $mom_sim_arr(\$mom_sim_power_on_wcs)
 }

#=======================================================================
proc __isv_SetPowerOnWCS { frame } {
  global paOption tixOption
  global gPB
  global mom_sim_arr mom_sim_nc_register
  set sub_frame [$frame subwidget frame]
  set pow_lbl [label $sub_frame.lbl -text "$gPB(isv,setup,power_on_wcs,Label)" -width 18 -anchor w]
  if {[info exists mom_sim_arr(\$mom_sim_power_on_wcs)]} {
   set  mom_sim_nc_register(POWER_ON_WCS) $mom_sim_arr(\$mom_sim_power_on_wcs)
   } else {
   set mom_sim_nc_register(POWER_ON_WCS) 1
  }
  set radio_1 [radiobutton $sub_frame.rad1 -variable mom_sim_arr(\$mom_sim_power_on_wcs) \
  -value 0 -text "0" -width 3 -anchor w \
  -command "__isv_SetPowerOnWCSValue"]
  set radio_2 [radiobutton $sub_frame.rad2 -variable mom_sim_arr(\$mom_sim_power_on_wcs) \
  -value 1 -text "1" -width 3 -anchor w \
  -command "__isv_SetPowerOnWCSValue"]
  pack $pow_lbl -side left -pady 2 -padx 5
  pack $radio_2 $radio_1 -side left -pady 2 -padx 5
  set gPB(c_help,$sub_frame.rad1) "isv,setup,power_on_wcs"
  set gPB(c_help,$sub_frame.rad2) "isv,setup,power_on_wcs"
 }

#=======================================================================
proc __isv_ValidateFormat_Binding { add_name data_type win } {
  global mom_sim_arr
  UI_PB_com_GetFomFrmAddname $add_name fmt_obj_attr
  bind $win <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K $data_type"
  bind $win <KeyRelease> "UI_PB_com_FormatCode %W $add_name"
  set code_var [$win cget -textvariable]
  PB_fmt_RetFmtOptVal fmt_obj_attr $code_var fmt_value
  set $code_var $fmt_value
 }

#=======================================================================
proc __isv_SpecGcodeDefineFrame { page_obj gcode_frame } {
  global mom_sim_arr
  global gPB
  global paOption tixOption
  set sub_frame [$gcode_frame subwidget frame]
  set frame1 [frame $sub_frame.1]
  set frame2 [frame $sub_frame.2]
  set frame3 [frame $sub_frame.3]
  set frame4 [frame $sub_frame.4]
  pack $frame1 $frame2 $frame3 $frame4 -side top -fill x -expand yes
  set lbl1 [label $frame1.lbl -text "$gPB(isv,g_code,from_home,Label)"]
  set lbl2 [label $frame2.lbl -text "$gPB(isv,g_code,return_home,Label)"]
  set lbl3 [label $frame3.lbl -text "$gPB(isv,g_code,mach_wcs,Label)"]
  set lbl4 [label $frame4.lbl -text "$gPB(isv,g_code,set_local,Label)"]
  set frm1 [frame $frame1.frm -width 20 ]
  set frm2 [frame $frame2.frm -width 20 ]
  set frm3 [frame $frame3.frm -width 20 ]
  set frm4 [frame $frame4.frm -width 20 ]
  pack $lbl1 $lbl2 $lbl3 $lbl4 -side left -anchor w -padx 5 -pady 6
  pack $frm1 $frm2 $frm3 $frm4 -side right -anchor e
  global gpb_addr_var
  set add_name $gPB(isv_addname)
  set gPB(isv_datatype) [__isv_SetAddrValidateFmt]
  set data_type $gPB(isv_datatype)
  set bgc $paOption(special_bg)
  set fgc $paOption(special_fg)
  set  lbl11 [label $frm1.lbl -padx 3 -textvariable gpb_addr_var($add_name,leader_name) \
  -font $tixOption(bold_font) -bg $bgc -fg $fgc]
  set  lbl12 [label $frm2.lbl -padx 3 -textvariable gpb_addr_var($add_name,leader_name) \
  -font $tixOption(bold_font) -bg $bgc -fg $fgc]
  set  lbl13 [label $frm3.lbl -padx 3 -textvariable gpb_addr_var($add_name,leader_name) \
  -font $tixOption(bold_font) -bg $bgc -fg $fgc]
  set  lbl14 [label $frm4.lbl -padx 3 -textvariable gpb_addr_var($add_name,leader_name) \
  -font $tixOption(bold_font) -bg $bgc -fg $fgc]
  set ent1 [entry $frm1.ent -width 10 -textvariable mom_sim_arr(\$mom_sim_from_home)]
  set ent2 [entry $frm2.ent -width 10 -textvariable mom_sim_arr(\$mom_sim_return_home)]
  set ent3 [entry $frm3.ent -width 10 -textvariable mom_sim_arr(\$mom_sim_mach_cs)]
  set ent4 [entry $frm4.ent -width 10 -textvariable mom_sim_arr(\$mom_sim_local_wcs)]
  pack $lbl11 $lbl12 $lbl13 $lbl14 -side left -pady 6
  pack $ent1 $ent2 $ent3 $ent4 -side right -padx 5 -pady 6
  set ent_list [list ent1 ent2 ent3 ent4]
  set Page::($page_obj,gcodent_list_1) [list]
  foreach ent $ent_list {
   lappend Page::($page_obj,gcodent_list_1) [set $ent]
  }
  set lbl_list [list lbl11 lbl12 lbl13 lbl14]
  set Page::($page_obj,gcodelbl_list_1) [list]
  foreach lbl $lbl_list {
   lappend Page::($page_obj,gcodlbl_list_1) [set $lbl]
  }
  foreach item $ent_list {
   set win [set $item]
   __isv_ValidateFormat_Binding $add_name $data_type $win
  }
  set gPB(c_help,$frm1.ent) "isv,g_code,frame"
  set gPB(c_help,$frm2.ent) "isv,g_code,frame"
  set gPB(c_help,$frm3.ent) "isv,g_code,frame"
  set gPB(c_help,$frm4.ent) "isv,g_code,frame"
 }

#=======================================================================
proc __isv_SelectSymbolLeader { b str } {
  global mom_sim_arr
  $b delete 0 end
  $b insert 0 $str
  set var [$b cget -textvariable]
  set $var $str
 }

#=======================================================================
proc __isv_ControlVarPopupMenu {frame} {
  set rw [$frame subwidget frame]
  set menu_2 [menu $rw.2.pop -tearoff 0]
  set menu_3 [menu $rw.3.pop -tearoff 0]
  bind $rw.2.ent "focus %W"
  bind $rw.3.ent "focus %W"
  bind $rw.2.ent <3> "tk_popup $menu_2 %X %Y"
  bind $rw.3.ent <3> "tk_popup $menu_3 %X %Y"
  set options_list { "%" "\#" "=" "gPB(address,none_popup,Label)"}
  set callback "__isv_SelectSymbolLeader"
  set bind_widget $rw.2.ent
  __isv_SetPopupOptions menu_2 options_list callback \
  bind_widget
  set bind_widget $rw.3.ent
  __isv_SetPopupOptions menu_3 options_list callback \
  bind_widget
 }

#=======================================================================
proc __isv_SymbolPopupMenu { page_obj frame } {
  set rw [$frame subwidget frame]
  set menu_1 [menu $rw.1.pop -tearoff 0]
  bind $rw.1.ent "focus %W"
  bind $rw.1.ent <3> "tk_popup $menu_1 %X %Y"
  set options_list { "%" "\#" "=" "gPB(address,none_popup,Label)"}
  set bind_widget $rw.1.ent
  set callback "__isv_SelectSymbolLeader"
  __isv_SetPopupOptions menu_1 options_list callback \
  bind_widget
 }

#=======================================================================
proc __isv_SymbolDefineFrame { page_obj symbol_frm } {
  global gPB
  global mom_sim_arr
  global paOption
  set rw [$symbol_frm subwidget frame]
  set rw_rew [frame $rw.1]
  pack $rw_rew -fill x -pady 2
  set rew_lbl [label $rw_rew.lbl -width 15 -text "$gPB(isv,sign_define,rewindstop,Label)" -anchor w]
  set rew_ent [entry $rw_rew.ent -width 10 -textvariable mom_sim_arr(\$mom_sim_prog_rewind_stop_code) \
  -bg $paOption(header_bg) -fg $paOption(special_fg)]
  pack $rew_lbl -side left -padx 5 -pady 2
  pack $rew_ent -side right -padx 5 -pady 2
  __isv_SymbolPopupMenu $page_obj $symbol_frm
  set gPB(c_help,$rw_rew.ent) "isv,sign_define,rewindstop"
 }

#=======================================================================
proc __isv_ControlVarFrame { symbol_frm } {
  global gPB
  global mom_sim_arr
  global paOption
  set rw [$symbol_frm subwidget frame]
  set rw_col [frame $rw.2]
  set eq_col [frame $rw.3]
  pack $rw_col $eq_col -side top -fill x -pady 2
  set col_lbl [label $rw_col.lbl -width 15 -text "$gPB(isv,sign_define,convarleader,Label)" -anchor w]
  set col_ent [entry $rw_col.ent -width 10 -textvariable mom_sim_arr(\$mom_sim_control_var_leader) \
  -bg $paOption(header_bg) -fg $paOption(special_fg)]
  set equ_lbl [label $eq_col.lbl -width 15 -text "$gPB(isv,sign_define,conequ,Label)" -anchor w]
  set equ_ent [entry $eq_col.ent -width 10 -textvariable mom_sim_arr(\$mom_sim_control_equal_sign) \
  -bg $paOption(header_bg) -fg $paOption(special_fg)]
  pack $col_lbl $equ_lbl -side left -padx 5 -pady 2
  pack $col_ent  $equ_ent -side right -padx 5 -pady 2
  __isv_ControlVarPopupMenu $symbol_frm
  set gPB(c_help,$rw_col.ent) "isv,sign_define,convarleader"
  set gPB(c_help,$eq_col.ent) "isv,sign_define,conequ"
 }

#=======================================================================
proc __isv_CreateAddrLeaderPopup { page_obj frame } {
  global gPB
  global machType axisoption
  set menu_1 [menu $frame.bot.pop1 -tearoff 0]
  set menu_2 [menu $frame.bot.pop2 -tearoff 0]
  set menu_3 [menu $frame.bot.pop3 -tearoff 0]
  bind $frame.bot.1.ent <1> "focus %W"
  bind $frame.bot.2.ent <1> "focus %W"
  bind $frame.bot.3.ent <1> "focus %W"
  set options_list {A B C D E F G H I J K L M N O \
  P Q R S T U V W X Y Z "gPB(address,none_popup,Label)"}
  set bind_widget $frame.bot.1.ent
  set callback "__isv_SelectLeader"
  __isv_SetPopupOptions menu_1 options_list callback bind_widget
  set bind_widget $frame.bot.2.ent
  __isv_SetPopupOptions menu_2 options_list callback bind_widget
  set bind_widget $frame.bot.3.ent
  __isv_SetPopupOptions menu_3 options_list callback bind_widget
  switch $machType {
   "Mill" \
   {
    switch $axisoption \
    {
     "4T" -
     "4H" {
      set menu_4 [menu $frame.right.pop1 -tearoff 0]
      bind $frame.right.1.ent <1> "focus %W"
      set bind_widget $frame.right.1.ent
      __isv_SetPopupOptions menu_4 options_list callback bind_widget
     }
     "5TT" -
     "5HT" -
     "5HH" {
      set menu_4 [menu $frame.right.pop1 -tearoff 0]
      bind $frame.right.1.ent <1> "focus %W"
      set bind_widget $frame.right.1.ent
      __isv_SetPopupOptions menu_4 options_list callback bind_widget
      set menu_5 [menu $frame.right.pop2 -tearoff 0]
      bind $frame.right.2.ent <1> "focus %W"
      set bind_widget $frame.right.2.ent
      __isv_SetPopupOptions menu_5 options_list callback bind_widget
     }
    } ;#switch axisoption
   }
   "Lathe" \
   {
   }
  }
 }

#=======================================================================
proc __isv_SaveIncrLeader { ent num } {
  global mom_sim_arr
  set str [$ent get]
  if {[string match "" $str]} {
   set str "-"
  }
  set len [llength $mom_sim_arr(\$mom_sim_incr_linear_addrs)]
  if { $num < $len } {
   set mom_sim_arr(\$mom_sim_incr_linear_addrs) \
   [lreplace $mom_sim_arr(\$mom_sim_incr_linear_addrs) $num $num $str]
  }
 }

#=======================================================================
proc __isv_SetSysLeader { } {
  global mom_sim_arr
  global mom_sys_arr
  global paOption tixOption
  global gPB gpb_addr_var
  global machType axisoption
  global isv_def_id
  set page_obj $isv_def_id
  set frame $Page::($page_obj,leader_frm)
  set ent_list [list $frame.bot.1.ent $frame.bot.2.ent $frame.bot.3.ent $frame.right.1.ent $frame.right.2.ent]
  set menu_list [list $frame.bot.pop1 $frame.bot.pop2 $frame.bot.pop3 $frame.right.pop1 $frame.right.pop2]
  set lbl_list [list $frame.bot.1.lbl $frame.bot.2.lbl $frame.bot.3.lbl $frame.right.1.lbl $frame.right.2.lbl]
  set var_list [list "gPB(output_X)" "gPB(output_Y)" "gPB(output_Z)" "gPB(output_A)" "gPB(output_B)"]
  set leader_list [list "$gpb_addr_var(X,leader_name)" \
  "$gpb_addr_var(Y,leader_name)" \
  "$gpb_addr_var(Z,leader_name)"]
  if {[string match "Lathe" $machType] ||  \
   [string match "3MT" $axisoption]} {
   set leader_list [lreplace $leader_list 1 1 "-"]
  }
  if {[string match "3MT" $axisoption] || \
   [string match "4*" $axisoption] || \
   [string match "5*" $axisoption]} {
   lappend leader_list "$gpb_addr_var(fourth_axis,leader_name)"
   if {[string match "5*" $axisoption]} {
    lappend leader_list "$gpb_addr_var(fifth_axis,leader_name)"
   }
  }
  if {[string match "UVW" $mom_sim_arr(\$mom_sim_mode_leader)]} {
   set val_list [list]
   for { set i 0 } { $i < 5 } {incr i} {
    set var [lindex $leader_list $i]
    if {![string match "" $var]} {
     set def_val $var
     } else {
     set def_val "-"
    }
    lappend val_list $def_val
   }
   set mom_sim_arr(\$mom_sim_incr_linear_addrs) $val_list
  }
  for { set i 0 } { $i < 5} { incr i } {
   set ent [lindex $ent_list $i]
   set lbl [lindex $lbl_list $i]
   set men [lindex $menu_list $i]
   set var [lindex $var_list $i]
   set ldr_var [lindex $leader_list $i]
   if { [winfo exists $ent] } {
    if { [string match "UVW" $mom_sim_arr(\$mom_sim_mode_leader)] } {
     set val [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) $i]
     set $var $val
     $ent config -state normal -bg $paOption(header_bg) -fg $paOption(special_fg)
     bind $ent <3> "tk_popup $men %X %Y"
     set str [$ent get]
     bind $ent <Leave> "__isv_SaveIncrLeader %W $i"
     $lbl config -fg $paOption(special_fg) -bg $paOption(special_bg)
     } else {
     set $var $ldr_var
     $ent config -state disabled -bg $paOption(entry_disabled_bg)
     $lbl config -fg gray -bg $::SystemButtonFace
     bind $ent <3> ""
     bind $ent <Leave> ""
    }
   }
  }
  if { [string match "XYZ" $mom_sim_arr(\$mom_sim_mode_leader)] } {
   set mom_sim_arr(\$mom_sim_incr_linear_addrs) [list]
  }
 }

#=======================================================================
proc __isv_SetInitialMotionMode {} {
  global mom_sim_arr
  global mom_sim_nc_register
  set mom_sim_nc_register(INPUT) $mom_sim_arr(\$mom_sim_input_mode)
 }

#=======================================================================
proc __isv_InputModeDefFrame { page_obj input_frm } {
  global mom_sim_nc_register
  global mom_sim_arr mom_sys_arr
  global machType axisoption
  global gPB paOption tixOption env
  if { ![info exists mom_sim_arr(\$mom_sim_incr_linear_addrs)] || \
   [llength $mom_sim_arr(\$mom_sim_incr_linear_addrs)] == 0 } {
   set  mom_sim_arr(\$mom_sim_incr_linear_addrs) [list]
   set  mom_sim_arr(\$mom_sim_mode_leader) "XYZ"
   } elseif {[llength $mom_sim_arr(\$mom_sim_incr_linear_addrs)]} {
   set  gPB(Output_X) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 0]
   set  gPB(Output_Y) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 1]
   set  gPB(Output_Z) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 2]
   set  mom_sim_arr(\$mom_sim_mode_leader) "UVW"
  }
  set md [$input_frm subwidget frame]
  set sty_frm [frame $md.style]
  set leader_frm [frame $md.leader]
  set Page::($page_obj,leader_frm) $leader_frm
  pack $sty_frm -side top -anchor w -pady 2
  pack $leader_frm -side bottom -pady 2 -padx 10 -anchor w
  set sty_sub [frame $sty_frm.left]
  pack $sty_sub -side top
  set style_opt_1 [radiobutton $sty_sub.opt_1 -text "$gPB(isv,incremental_gcode,Label)" \
  -variable mom_sim_arr(\$mom_sim_mode_leader) -value "XYZ" \
  -command "__isv_SetSysLeader" -anchor w]
  set style_opt_2 [radiobutton $sty_sub.opt_2 -text "$gPB(isv,incremental_uvw,Label)" \
  -variable mom_sim_arr(\$mom_sim_mode_leader) -value "UVW" \
  -command "__isv_SetSysLeader" -anchor w]
  set gPB(c_help,$sty_sub.opt_1) "isv,incremental_gcode"
  set gPB(c_help,$sty_sub.opt_2) "isv,incremental_uvw"
  pack $style_opt_1 $style_opt_2 -side left -padx 5 -pady 2
  set coord_frm [frame $leader_frm.bot]
  set coord_frm1 [frame $coord_frm.1]
  set coord_frm2 [frame $coord_frm.2]
  set coord_frm3 [frame $coord_frm.3]
  pack $coord_frm1 $coord_frm2 $coord_frm3 -side left -padx 5 -pady 2 -anchor w
  global gpb_addr_var
  set bgc $paOption(special_bg)
  set fgc $paOption(special_fg)
  uplevel #0 set TRANSPARENT_GIF_COLOR [$coord_frm cget -bg]
  set add_name "X"
  set co_lbl1 [label $coord_frm1.lbl -textvariable gpb_addr_var($add_name,leader_name) \
  -font $tixOption(bold_font) -bg $bgc -fg $fgc]
  set add_name "Y"
  set co_lbl2 [label $coord_frm2.lbl -textvariable gpb_addr_var($add_name,leader_name) \
  -font $tixOption(bold_font) -bg $bgc -fg $fgc]
  set add_name "Z"
  set co_lbl3 [label $coord_frm3.lbl -textvariable gpb_addr_var($add_name,leader_name) \
  -font $tixOption(bold_font) -bg $bgc -fg $fgc]
  set co_ent1 [entry $coord_frm1.ent -width 5 -textvariable gPB(output_X)]
  set co_ent2 [entry $coord_frm2.ent -width 5 -textvariable gPB(output_Y)]
  set co_ent3 [entry $coord_frm3.ent -width 5 -textvariable gPB(output_Z)]
  pack $co_lbl1 $co_lbl2 $co_lbl3 -side left  -anchor w -padx 1 -pady 2
  pack $co_ent1 $co_ent2 $co_ent3 -side right -anchor w -padx 1 -pady 2
  set gPB(c_help,$coord_frm1.ent) "isv,incr_x"
  set gPB(c_help,$coord_frm2.ent) "isv,incr_y"
  set gPB(c_help,$coord_frm3.ent) "isv,incr_z"
  switch $machType \
  {
   "Mill" \
   {
    switch $axisoption \
    {
     "3MT" -
     "4H" -
     "4T" {
      if { [info exists mom_sim_arr(\$mom_sim_incr_linear_addrs)] } {
       set gPB(Output_A) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 3]
       } else {
       if { [string match "3MT" $axisOption] } {
        set gPB(Output_A) "C"
        } else {
        set gPB(Output_A) "A"
       }
      }
      set coord_abc [frame $leader_frm.right]
      set coord_frma [frame $coord_abc.1]
      pack $coord_abc -side bottom -anchor w -pady 2
      pack $coord_frma -padx 5 -pady 2 -anchor w
      set add_name "fourth_axis"
      set co_lbl4 [label $coord_frma.lbl -textvariable gpb_addr_var($add_name,leader_name) \
      -font $tixOption(bold_font) -bg $bgc -fg $fgc]
      set co_ent4 [entry $coord_frma.ent -width 5 -textvariable gPB(output_A)]
      pack $co_lbl4 -side left  -anchor w -padx 1 -pady 2
      pack $co_ent4 -side right -anchor w -padx 1 -pady 2
      set gPB(c_help,$coord_frma.ent) "isv,incr_a"
     }
     "5HH" -
     "5HT" -
     "5TT" {
      if { [info exists mom_sim_arr(\$mom_sim_incr_linear_addrs)] } {
       set gPB(Output_A) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 3]
       set gPB(Output_B) [lindex $mom_sim_arr(\$mom_sim_incr_linear_addrs) 4]
       } else {
       set gPB(Output_A) "A"
       set gPB(Output_B) "B"
      }
      set coord_abc [frame $leader_frm.right]
      set coord_frma [frame $coord_abc.1]
      set coord_frmb [frame $coord_abc.2]
      pack $coord_abc -side bottom -anchor w -pady 2
      pack $coord_frma $coord_frmb -side left -padx 5 -pady 2 -anchor w
      set add_name "fourth_axis"
      set co_lbl4 [label $coord_frma.lbl -textvariable gpb_addr_var($add_name,leader_name) \
      -font $tixOption(bold_font) -bg $bgc -fg $fgc]
      set co_ent4 [entry $coord_frma.ent -width 5 -textvariable gPB(output_A)]
      pack $co_lbl4 -side left -anchor w -padx 1 -pady 2
      pack $co_ent4 -side right -anchor w -padx 1 -pady 2
      set add_name "fifth_axis"
      set co_lbl5 [label $coord_frmb.lbl -textvariable gpb_addr_var($add_name,leader_name) \
      -font $tixOption(bold_font) -bg $bgc -fg $fgc]
      set co_ent5 [entry $coord_frmb.ent -width 5 -textvariable gPB(output_B)]
      pack $co_lbl5 -side left -anchor w -padx 1 -pady 2
      pack $co_ent5 -side right -anchor w -padx 1 -pady 2
      set gPB(c_help,$coord_frma.ent) "isv,incr_a"
      set gPB(c_help,$coord_frmb.ent) "isv,incr_b"
     }
    }
   }
   "Lathe" \
   {
   }
  }
  pack $coord_frm -side right -anchor e -pady 2
  __isv_CreateAddrLeaderPopup $page_obj $leader_frm
  __isv_SetSysLeader
 }

#=======================================================================
proc __isv_IncrStyleStateSet { frame } {
  global mom_sim_nc_register
  global mom_sim_arr
  global mom_sys_arr
  set style_lbl $frame.lbl
  set style_opt_1 $frame.style.opt_1
  set style_opt_2 $frame.style.opt_2
 }

#=======================================================================
proc __isv_SetRapidDogValue {} {
  global mom_sim_arr mom_sim_nc_register
 }

#=======================================================================
proc __isv_SetRapidDogFrame { frame } {
  global gPB
  global paOption tixOption
  global mom_sim_arr mom_sim_nc_register
  set sub_frame [$frame subwidget frame]
  set lbl [label $sub_frame.lbl -text "$gPB(isv,setup,dog_leg,Label)" -width 15 -anchor w] ;#<12-04-07 gsl> 15 was 12.
  set dog_rad1 [radiobutton $sub_frame.rad1 -variable mom_sim_arr(\$mom_sim_rapid_dogleg) \
  -value 1 -text "$gPB(isv,setup,dog_leg,yes)" -width 3 -anchor w \
  -command "__isv_SetRapidDogValue"]
  set dog_rad2 [radiobutton $sub_frame.rad2 -variable mom_sim_arr(\$mom_sim_rapid_dogleg) \
  -value 0 -text "$gPB(isv,setup,dog_leg,no)" -width 3 -anchor w \
  -command "__isv_SetRapidDogValue"]
  pack $lbl -side left -pady 2 -padx 10
  pack $dog_rad2 $dog_rad1 -side right -padx 5 -pady 2
  set gPB(c_help,$sub_frame.rad1) "isv,setup,dog_leg"
  set gPB(c_help,$sub_frame.rad2) "isv,setup,dog_leg"
 }

#=======================================================================
proc __isv_DefOutputVNCmsg { msg_frm } {
  global gPB paOption
  global tixOption
  global mom_sim_arr
  set outmes [$msg_frm subwidget frame]
  set mes [frame $outmes.mes]
  set out [checkbutton $outmes.out -text "$gPB(isv,vnc_message,Label)" \
  -font $tixOption(font) \
  -variable mom_sim_arr(\$mom_sim_output_vnc_msg) \
  -command ""]
  pack $out $mes -padx 5 -pady 2 -side top -anchor w
  set gPB(c_help,$outmes.out) "isv,vnc_message"
 }

#=======================================================================
proc __isv_ToolCreateOnerow { frame tool_list} {
  global paOption tixOption
  global gPB
  global mom_sim_arr
  if { [lsearch $mom_sim_arr(\$mom_sim_tool_list) $gPB(add_tool)] < 0 } {
   lappend mom_sim_arr(\$mom_sim_tool_list) $gPB(add_tool)
   __isv_RecreateToolTable $gPB(add_tool)
   incr gPB(add_tool)
   } else {
   set err_msg $gPB(isv,tool_info,add_err,Msg)
   tk_messageBox -parent [ UI_PB_com_AskActiveWindow ] -message $err_msg -type ok -icon warning
  }
 }

#=======================================================================
proc __isv_CreateToolNamePopup { frame } {
  global gPB
  set menu [menu $frame.pop -tearoff 0]
  bind $frame.ent <1> "focus %W"
  bind $frame.ent <3> "focus %W;tk_popup $menu %X %Y"
  set options_list {UGTI0201_068 UGTI0201_011 UGTI0321_015 UGTI0321_013 UGTI0301_341 UGTI0301_075 \
  UGTI0351_146 UGTI0351_152 UGTI0351_144 "gPB(address,none_popup,Label)"}
  set bind_widget $frame.ent
  set callback "__isv_ToolSelectLeader"
  __isv_SetPopupOptions menu options_list callback \
  bind_widget
 }

#=======================================================================
proc __isv_ToolOffsetStatus { frame tool_num } {
  global gPB mom_sim_arr
  global paOption
  if { $mom_sim_arr(\$mom_sim_tool_data\($tool_num,offset_used\)) == 1 } {
   $frame.right.x.xoff config -state normal -bg $paOption(special_fg)
   $frame.right.y.yoff config -state normal -bg $paOption(special_fg)
   $frame.right.z.zoff config -state normal -bg $paOption(special_fg)
   } else {
   $frame.right.x.xoff config -state disabled -bg $paOption(entry_disabled_bg)
   $frame.right.y.yoff config -state disabled -bg $paOption(entry_disabled_bg)
   $frame.right.z.zoff config -state disabled -bg $paOption(entry_disabled_bg)
  }
 }

#=======================================================================
proc __isv_DeleteOneTool { frame } {
  global gPB
  global mom_sim_arr
  set var [$frame.but cget -textvariable]
  set del_num [set $var]
  __isv_Distroy_ToolTable
  set item_list $gPB(tool_item_list)
  foreach item $item_list {
   unset mom_sim_arr(\$mom_sim_tool_data\($del_num,$item\))
  }
  unset $var
  set ind [lsearch $mom_sim_arr(\$mom_sim_tool_list) $del_num]
  set mom_sim_arr(\$mom_sim_tool_list) [lreplace $mom_sim_arr(\$mom_sim_tool_list) $ind $ind]
  if { [llength $mom_sim_arr(\$mom_sim_tool_list)] == 0 } {
   set gPB(add_tool) 1
   } else {
   set gPB(add_tool) $del_num
  }
  __isv_Redisplay_ToolTable
 }

#=======================================================================
proc __isv_DeleteToolLisPopup { X Y frame } {
  global gPB
  set popup $frame.pop
  $popup delete 0 end
  $popup add command -label "$gPB(isv,spec_command,delete,Label)"\
  -state normal -command "__isv_DeleteOneTool $frame"
  tk_popup $popup $X $Y
 }

#=======================================================================
proc __isv_CreateDeleteToolPop { frame } {
  global gPB
  set popup [menu $frame.pop -tearoff 0]
  bind $frame.but <3> "__isv_DeleteToolLisPopup %X %Y $frame "
 }

#=======================================================================
proc __isv_EditToolNumber { win grid} {
  global mom_sim_arr gPB
  global paOption
  set old_num $gPB(cur_number)
  set var [$win cget -textvariable]
  set tool_num [$win get]
  set item_list $gPB(tool_item_list)
  if { $old_num == $tool_num } {
   $win config -bg $paOption(table_bg) -relief flat -state disabled
   return
  }
  if { [lsearch $mom_sim_arr(\$mom_sim_tool_list) $tool_num] >= 0 } {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -message "$gPB(isv,tool_info,add_err,Msg)" -icon error
   $win delete 0 end
   $win insert 0 $old_num
   $win config -bg $paOption(table_bg) -relief flat -state disabled
   return
   } else {
   set index [lsearch $mom_sim_arr(\$mom_sim_tool_list) $old_num]
   set mom_sim_arr(\$mom_sim_tool_list) [lreplace $mom_sim_arr(\$mom_sim_tool_list) $index $index $tool_num]
   set no_row [expr $index + 1]
   foreach item $item_list {
    set mom_sim_arr(\$mom_sim_tool_data\($tool_num,$item\)) $mom_sim_arr(\$mom_sim_tool_data\($old_num,$item\))
   }
   $grid.tname_$no_row.ent config -textvariable mom_sim_arr(\$mom_sim_tool_data\($tool_num,name\))
   $grid.toff_$no_row.ent config -variable mom_sim_arr(\$mom_sim_tool_data\($tool_num,offset_used\))
   $grid.toff_$no_row.right.x.xoff config -textvariable mom_sim_arr(\$mom_sim_tool_data\($tool_num,x_off\))
   $grid.toff_$no_row.right.y.yoff config -textvariable mom_sim_arr(\$mom_sim_tool_data\($tool_num,y_off\))
   $grid.toff_$no_row.right.z.zoff config -textvariable mom_sim_arr(\$mom_sim_tool_data\($tool_num,z_off\))
   $grid.ttype_$no_row.ent config -variable mom_sim_arr(\$mom_sim_tool_data\($tool_num,type\))
   $grid.tdia_$no_row.ent config -textvariable  mom_sim_arr(\$mom_sim_tool_data\($tool_num,diameter\))
   $grid.tcut_$no_row.1.ent config -variable  mom_sim_arr(\$mom_sim_tool_data\($tool_num,cutcom_register\))
   $grid.tcut_$no_row.2.ent config -textvariable  mom_sim_arr(\$mom_sim_tool_data\($tool_num,cutcom_value\))
   $grid.tadj_$no_row.1.ent config -variable  mom_sim_arr(\$mom_sim_tool_data\($tool_num,adjust_register\))
   $grid.tadj_$no_row.2.ent config -textvariable  mom_sim_arr(\$mom_sim_tool_data\($tool_num,adjust_value\))
   $grid.tpoc_$no_row.ent config -textvariable mom_sim_arr(\$mom_sim_tool_data\($tool_num,pocket_id\))
   $grid.tcar_$no_row.ent config -textvariable mom_sim_arr(\$mom_sim_tool_data\($tool_num,carrier_id\))
   foreach item $item_list {
    unset mom_sim_arr(\$mom_sim_tool_data\($old_num,$item\))
   }
   set $var $tool_num
   set gPB(cur_number) $tool_num
  }
  $win config -bg $paOption(table_bg) -relief flat -state disabled
 }

#=======================================================================
proc __isv_ToolEntryEnter { win } {
  global gPB paOption
  set gPB(cur_number) [$win get]
  $win config -bg $paOption(focus) -relief solid -state normal
 }

#=======================================================================
proc __isv__CreateFirstColAttr { grid no_row args} {
  global paOption tixOption
  global mom_sim_arr gPB
  set tnum_frm $grid.tnum_$no_row
  set index [expr $no_row - 1]
  set gPB($no_row) [lindex $mom_sim_arr(\$mom_sim_tool_list) $index]
  if { ![winfo exists $tnum_frm] } {
   set tnum_frm [frame $grid.tnum_$no_row -bg $paOption(table_bg)]
   global tix_version
   switch $tix_version {
    8.4 {
     set addn [entry $tnum_frm.but -textvariable gPB($no_row) \
     -font $tixOption(bold_font) -foreground blue -bg $paOption(table_bg) \
     -relief flat -bd 1 -disabledforeground blue\
     -highlightbackground $paOption(table_bg) -disabledbackground $paOption(table_bg) \
     -justify center -width 4]
    }
    4.1 {
     set addn [entry $tnum_frm.but -textvariable gPB($no_row) \
     -font $tixOption(bold_font) -foreground blue -bg $paOption(table_bg) \
     -relief flat -bd 1 \
     -highlightbackground $paOption(table_bg) \
     -justify center -width 4]
    }
   }
   pack $addn -side right -anchor e -padx 2 -pady 23
   bind $addn <Enter> "__isv_ToolEntryEnter %W"
   set data_type "i"
   bind $addn <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K $data_type"
   bind $addn <KeyRelease> "%W config -state normal"
   bind $addn <Leave> "__isv_EditToolNumber %W $grid"
   bind $addn <Return> "%W config -state disabled -relief flat -bg $paOption(table_bg)"
   __isv_CreateDeleteToolPop $tnum_frm
  }
  $grid set 0 $no_row -itemtype window -window $tnum_frm
 }

#=======================================================================
proc __isv_ValidateNoneEmpty { win } {
  global gPB
  set str [$win get]
  if {[string match "" $str]} {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -message $gPB(isv,tool_info,name_err,Msg) \
   -icon error
   focus $win
   return
  }
 }

#=======================================================================
proc __isv__CreateRestColAttr { grid no_row args} {
  global paOption
  global gPB
  global mom_sim_arr
  set tname_frm $grid.tname_$no_row
  if {[llength $args]} {
   set tool_num [lindex $args 0]
   } else {
   set tool_num [lindex $mom_sim_arr(\$mom_sim_tool_list) [expr $no_row - 1]]
  }
  if { ![winfo exists $tname_frm] } \
  {
   set tname_frm [frame $grid.tname_$no_row]
   if {![info exists mom_sim_arr(\$mom_sim_tool_data\($tool_num,name\))]} {
    if {$tool_num < 10 } {
     set tool_name "UGTI0000_00$tool_num"
     } elseif {$tool_num < 100} {
     set tool_name "UGTI0000_0$tool_num"
     } else {
     set tool_name "UGTI0000_000"
    }
    set mom_sim_arr(\$mom_sim_tool_data\($tool_num,name\)) $tool_name
   }
   set ent1 [entry $tname_frm.ent -textvariable mom_sim_arr(\$mom_sim_tool_data\($tool_num,name\)) \
   -width 12 -bg $paOption(header_bg) -fg $paOption(special_fg)]
   pack $tname_frm.ent -padx 3 -pady 20
   __isv_CreateToolNamePopup $tname_frm
  }
  $grid set 1 $no_row -itemtype window -window $tname_frm
  set toff_frm $grid.toff_$no_row
  if { ![winfo exists $toff_frm] } \
  {
   set toff_frm [frame $grid.toff_$no_row]
   pack forget $toff_frm
   pack $toff_frm -fill x -padx 3
   if {![info exists mom_sim_arr(\$mom_sim_tool_data\($tool_num,offset_used\))]} {
    set mom_sim_arr(\$mom_sim_tool_data\($tool_num,offset_used\)) 0
    set mom_sim_arr(\$mom_sim_tool_data\($tool_num,x_off\)) 0.0
    set mom_sim_arr(\$mom_sim_tool_data\($tool_num,y_off\)) 0.0
    set mom_sim_arr(\$mom_sim_tool_data\($tool_num,z_off\)) 0.0
   }
   checkbutton $toff_frm.ent -variable mom_sim_arr(\$mom_sim_tool_data\($tool_num,offset_used\)) \
   -command  "__isv_ToolOffsetStatus $toff_frm $tool_num"
   pack $toff_frm.ent -side left -anchor w
   set toff_frm_right [frame $toff_frm.right]
   pack $toff_frm_right -side left
   set off_x [frame $toff_frm_right.x]
   set off_y [frame $toff_frm_right.y]
   set off_z [frame $toff_frm_right.z]
   pack $off_x $off_y $off_z -side top -fill both
   label $off_x.lblx -text "X" -width 2
   set ent2 [entry $off_x.xoff -textvariable mom_sim_arr(\$mom_sim_tool_data\($tool_num,x_off\)) -width 5]
   pack $off_x.lblx $off_x.xoff -side left
   label $off_y.lbly -text "Y" -width 2
   set ent3 [entry $off_y.yoff -textvariable mom_sim_arr(\$mom_sim_tool_data\($tool_num,y_off\)) -width 5]
   pack $off_y.lbly $off_y.yoff -side left -pady 0
   label $off_z.lblz -text "Z" -width 2
   set ent4 [entry $off_z.zoff -textvariable mom_sim_arr(\$mom_sim_tool_data\($tool_num,z_off\)) -width 5]
   pack $off_z.lblz $off_z.zoff -side left
   __isv_ToolOffsetStatus $toff_frm $tool_num
  }
  $grid set 4 $no_row -itemtype window -window $toff_frm
  set ttype_frm $grid.ttype_$no_row
  if { ![winfo exists $ttype_frm] } \
  {
   if {![info exists mom_sim_arr(\$mom_sim_tool_data\($tool_num,type\))]} {
    set mom_sim_arr(\$mom_sim_tool_data\($tool_num,type\)) "MILL"
   }
   set tool_type $mom_sim_arr(\$mom_sim_tool_data\($tool_num,type\))
   set ttype_frm [frame $grid.ttype_$no_row]
   set ent12 [tixOptionMenu $ttype_frm.ent \
   -command    "" \
   -variable mom_sim_arr(\$mom_sim_tool_data\($tool_num,type\)) \
   -options {
    menubutton.height 1
    menubutton.width 4
   }]
   set opt_list [list "MILL" "DRILL" "LATHE"]
   foreach op $opt_list {
    $ent12 add command $op -label $op
   }
   $ent12 configure -value "$tool_type"
   pack $ttype_frm.ent -padx 3 -pady 18
  }
  $grid set 2 $no_row -itemtype window -window $ttype_frm
  set tdia_frm $grid.tdia_$no_row
  if { ![winfo exists $tdia_frm] } \
  {
   set tdia_frm [frame $grid.tdia_$no_row]
   if {![info exists mom_sim_arr(\$mom_sim_tool_data\($tool_num,diameter\))]} {
    set mom_sim_arr(\$mom_sim_tool_data\($tool_num,diameter\)) 0.0
   }
   set ent5 [entry $tdia_frm.ent -textvariable mom_sim_arr(\$mom_sim_tool_data\($tool_num,diameter\)) \
   -width 8]
   pack $tdia_frm.ent -padx 3 -pady 20
  }
  $grid set 3 $no_row -itemtype window -window $tdia_frm
  set tcut_frm $grid.tcut_$no_row
  if { ![winfo exists $tcut_frm] } \
  {
   set tcut_frm [frame $grid.tcut_$no_row]
   set tcut_1 [frame $tcut_frm.1]
   set tcut_2 [frame $tcut_frm.2]
   pack $tcut_1 $tcut_2 -side top -fill x -padx 3 -pady 3
   if ![info exists mom_sim_arr(\$mom_sim_tool_data\($tool_num,cutcom_register\))] {
    set mom_sim_arr(\$mom_sim_tool_data\($tool_num,cutcom_register\)) 1
   }
   set ent6 [tixControl $tcut_1.ent \
   -integer true -min 0 -max 100 \
   -command    "" \
   -selectmode immediate \
   -variable mom_sim_arr(\$mom_sim_tool_data\($tool_num,cutcom_register\)) \
   -label "$gPB(isv,tool_info,cutreg,Label)"\
   -options {
    entry.width 3
    label.anchor e
   }]
   label $tcut_2.lbl -text "$gPB(isv,tool_info,cutval,Label)" -width 5 -anchor w
   if {![info exists mom_sim_arr(\$mom_sim_tool_data\($tool_num,cutcom_value\))]} {
    set mom_sim_arr(\$mom_sim_tool_data\($tool_num,cutcom_value\)) 0.0
   }
   set ent7 [entry $tcut_2.ent -textvariable mom_sim_arr(\$mom_sim_tool_data\($tool_num,cutcom_value\)) \
   -width 5]
   pack $tcut_1.ent             -side left -pady 3
   pack $tcut_2.lbl  -side left -pady 3
   pack $tcut_2.ent  -side right -pady 3
  }
  $grid set 5 $no_row -itemtype window -window $tcut_frm
  set tadj_frm $grid.tadj_$no_row
  if { ![winfo exists $tadj_frm] } \
  {
   set tadj_frm [frame $grid.tadj_$no_row]
   set tadj_1 [frame $tadj_frm.1]
   set tadj_2 [frame $tadj_frm.2]
   pack $tadj_1 $tadj_2 -side top -fill x -padx 3 -pady 3
   if ![info exists mom_sim_arr(\$mom_sim_tool_data\($tool_num,adjust_register\))] {
    set mom_sim_arr(\$mom_sim_tool_data\($tool_num,adjust_register\)) 1
   }
   set ent8 [tixControl $tadj_1.ent -integer true -min 0 -max 100 \
   -command    "" \
   -selectmode immediate \
   -variable mom_sim_arr(\$mom_sim_tool_data\($tool_num,adjust_register\)) \
   -label "$gPB(isv,tool_info,cutreg,Label)"\
   -options {
    entry.width 3
    label.anchor e
   }]
   label $tadj_2.lbl -text "$gPB(isv,tool_info,cutval,Label)"  \
   -width 5 -justify left -anchor w
   if {![info exists mom_sim_arr(\$mom_sim_tool_data\($tool_num,adjust_value\))]} {
    set mom_sim_arr(\$mom_sim_tool_data\($tool_num,adjust_value\)) 0.0
   }
   set ent9 [entry $tadj_2.ent -textvariable mom_sim_arr(\$mom_sim_tool_data\($tool_num,adjust_value\)) \
   -width 5]
   pack $tadj_1.ent -side left -pady 3
   pack $tadj_2.lbl -side left -pady 3
   pack $tadj_2.ent -side right -pady 3
  }
  $grid set 6 $no_row -itemtype window -window $tadj_frm
  set tcar_frm $grid.tcar_$no_row
  if { ![winfo exists $tcar_frm] } \
  {
   set tcar_frm [frame $grid.tcar_$no_row]
   if {![info exists mom_sim_arr(\$mom_sim_tool_data\($tool_num,carrier_id\))]} {
    set mom_sim_arr(\$mom_sim_tool_data\($tool_num,carrier_id\)) 0
   }
   set ent10 [entry $tcar_frm.ent -textvariable mom_sim_arr(\$mom_sim_tool_data\($tool_num,carrier_id\)) \
   -width 8]
   pack $tcar_frm.ent -padx 3 -pady 20
  }
  $grid set 7 $no_row -itemtype window -window $tcar_frm
  set tpoc_frm $grid.tpoc_$no_row
  if { ![winfo exists $tpoc_frm] } \
  {
   set tpoc_frm [frame $grid.tpoc_$no_row]
   if {![info exists mom_sim_arr(\$mom_sim_tool_data\($tool_num,pocket_id\))]} {
    set mom_sim_arr(\$mom_sim_tool_data\($tool_num,pocket_id\)) 0
   }
   set ent11 [entry $tpoc_frm.ent -textvariable mom_sim_arr(\$mom_sim_tool_data\($tool_num,pocket_id\)) \
   -width 8]
   pack $tpoc_frm.ent -padx 3 -pady 20
  }
  $grid set 8 $no_row -itemtype window -window $tpoc_frm
  set data_type "f"
  set entlist [list ent2 ent3 ent4 ent5 ent7 ent9]
  foreach item $entlist {
   if [winfo exists $item] {
    bind [set $item] <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K $data_type"
    bind [set $item] <KeyRelease> "%W config -state normal"
   }
  }
  set data_type "i"
  set entlist [list ent10 ent11]
  foreach item $entlist {
   if [winfo exists $item] {
    bind [set $item] <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K $data_type"
    bind [set $item] <KeyRelease> "%W config -state normal"
   }
  }
 }

#=======================================================================
proc __isv__CreateToolColAttributes { grid args } {
  global gPB
  global paOption tixOption
  global mom_sim_arr
  set title_col(0) "$gPB(isv,tool_info,tool_num,Label)"
  set title_col(1) "$gPB(isv,tool_info,tool_name,Label)"
  set title_col(2) "$gPB(isv,tool_info,tool_type,Label)"
  set title_col(4) "$gPB(isv,tool_info,offset_usder,Label)"
  set title_col(3) "$gPB(isv,tool_info,tool_diameter,Label)"
  set title_col(5) "$gPB(isv,tool_info,cutcom_reg,Label)"
  set title_col(6) "$gPB(isv,tool_info,adjust_reg,Label)"
  set title_col(7) "$gPB(isv,tool_info,carrier_id,Label)"
  set title_col(8) "$gPB(isv,tool_info,pocket_id,Label)"
  set style [tixDisplayStyle text -refwindow $grid \
  -fg $paOption(title_fg)\
  -anchor c -font $tixOption(bold_font)]
  set no_col 9
  for { set col 0 } { $col < $no_col } { incr col } {
   $grid set $col 0 -itemtype text -text $title_col($col) -style $style
  }
  if { ![info exists mom_sim_arr(\$mom_sim_tool_list)] } {
   set mom_sim_arr(\$mom_sim_tool_list) [list]
  }
  set len [llength $mom_sim_arr(\$mom_sim_tool_list)]
  for { set i 0 } { $i < $len } { incr i } {
   set tool_index [lindex $mom_sim_arr(\$mom_sim_tool_list) $i]
   foreach one { diameter x_off y_off z_off adjust_value adjust_register cutcom_value cutcom_register pocket_id carrier_id } {
    if { ![info exists mom_sim_arr(\$mom_sim_tool_data\(${tool_index},${one}\))] ||\
     ![string compare [string trim $mom_sim_arr(\$mom_sim_tool_data\(${tool_index},${one}\))] ""] } {
     set mom_sim_arr(\$mom_sim_tool_data\(${tool_index},${one}\)) 0
    }
   }
   if { ![info exists mom_sim_arr(\$mom_sim_tool_data\(${tool_index},type\))] ||\
    ![string compare [string trim $mom_sim_arr(\$mom_sim_tool_data\(${tool_index},type\))] ""] } {
    set mom_sim_arr(\$mom_sim_tool_data\(${tool_index},type\)) MILL
   }
  }
  if { $len } {
   for { set i 1 } { $i <= $len } { incr i } {
    __isv__CreateFirstColAttr $grid $i
    __isv__CreateRestColAttr  $grid $i
   }
  }
 }

#=======================================================================
proc __isv_Distroy_ToolTable {} {
  global gPB
  if { [winfo exists $gPB(tool_col)] } {
   set gPB(tool_bindage) [bind $gPB(main_window) <Destroy>]
   bind $gPB(main_window) <Destroy> ""
   destroy $gPB(tool_col)
  }
 }

#=======================================================================
proc __isv_Redisplay_ToolTable { args } {
  global mom_sim_arr gPB
  if { [llength $args]} {
   set add_tool [lindex $args 0]
   } else {
   set add_tool ""
  }
  if ![string match "" $gPB(tool_bindage)] {
   bind $gPB(main_window) <Destroy> $gPB(tool_bindage)
  }
  frame $gPB(tool_col)
  pack $gPB(tool_col) -side top -fill both -expand yes
  if { [info exists mom_sim_arr(\$mom_sim_tool_list)] } {
   set mom_sim_arr(\$mom_sim_tool_list) [lsort -dictionary $mom_sim_arr(\$mom_sim_tool_list)]
   __isv_CreateToolInfoGrid $gPB(tool_col) $add_tool
   } else {
   set mom_sim_arr(\$mom_sim_tool_list) ""
  }
 }

#=======================================================================
proc __isv_RecreateToolTable { args } {
  if {[llength $args]} {
   set add_tool [lindex $args 0]
   } else {
   set add_tool ""
  }
  __isv_Distroy_ToolTable
  __isv_Redisplay_ToolTable $add_tool
 }

#=======================================================================
proc __isv_CreateFanucToolTable { tool_list args } {
  global paOption
  tixScrolledGrid $tool_list.scr -bd 0 -scrollbar auto
  [$tool_list.scr subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  [$tool_list.scr subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  pack $tool_list.scr -fill both -expand yes -padx 10 -pady 5
  set grid [$tool_list.scr subwidget grid]
  global tix_version
  switch $tix_version {
   8.4 {
    $grid config -relief sunken -bd 3 \
    -state normal \
    -formatcmd "UI_PB_ads_SimpleFormat $grid" \
    -height 12 -width 9 -highlightthickness 0
    $grid size row default -size auto  -pad0 0 -pad1 4
   }
   4.1 {
    $grid config -relief sunken -bd 3 \
    -state disabled \
    -formatcmd "UI_PB_ads_SimpleFormat $grid" \
    -height 12 -width 9 -highlightthickness 0
    $grid size row default -size auto  -pad0 0 -pad1 6
   }
  }
  $grid size col default -size auto  -pad0 0 -pad1 0
  $grid size row 0       -size auto  -pad0 3 -pad1 3
  if { [llength $args] } {
   set add_tool [lindex $args 0]
   } else {
   set add_tool ""
  }
  __isv__CreateToolColAttributes $grid $add_tool
 }

#=======================================================================
proc __isv_CreateHeidenhainToolTable { tool_list args } {
  package provide Tktable
  package require Tktable
  set t [table $tool_list.scr -cols 6 -borderwidth 3 \
  -titlerows 1]
  $t tag row blue 7
  $t tag col blue 6 8
  scrollbar $tool_list.sx -command [list $t xview]
  scrollbar $tool_list.sy -command [list $t yview]
  grid $t       -       -      -     $tool_list.sy -sticky ns
  grid $tool_list.sx      -       -      -         -sticky ew
  grid columnconfig . 1 -weight 1
  grid rowconfig . 2 -weight 1
  grid config $t -sticky news
 }

#=======================================================================
proc __isv_CreateToolInfoGrid { tool_list args } {
  global paOption
  global gPB mach_cntl_type
  if { [llength $args] } {
   set add_tool [lindex $args 0]
   } else {
   set add_tool ""
  }
  if { ![info exists mach_cntl_type] } {
   set mach_cntl_type "Generic"
  }
  __isv_CreateFanucToolTable $tool_list $add_tool
  if 0 {
   if { [string match "Generic" $mach_cntl_type] } {
    __isv_CreateFanucToolTable $tool_list $add_tool
    } elseif { [string match "System" $mach_cntl_type] &&  \
    [string match "heidenhain_conversational" $gPB(mach_sys_controller)] } {
    __isv_CreateFanucToolTable $tool_list $add_tool
   }
  }
 }

#=======================================================================
proc __isv_Def_DisableToolTable {} {
  global gPB
 }

#=======================================================================
proc __isv_Def_ActiveToolTable { win_index } {
  global gPB
  if { $gPB(toplevel_disable_$win_index) } \
  {
   set gPB(toplevel_disable_$win_index) 0
  }
 }

#=======================================================================
proc __isv_ToolMap {} {
  global env
  global mach_cntl_type gPB
  set w [toplevel $gPB(active_window).tool_table]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $w \
  "$gPB(isv,tool_table,title,Label)" "+300+200" \
  "" "__isv_Def_DisableToolTable" "" \
  "__isv_Def_ActiveToolTable $win_index"
  if { [string match "Generic" $mach_cntl_type] } {
   __isv_CreateFanucToolTable $w
   } elseif { [string match "System" $mach_cntl_type] } {
   switch $gPB(mach_sys_controller) {
    "heidenhain_conversational" {
    }
    default { }
   }
  }
  UI_PB_com_PositionWindow $w
 }

#=======================================================================
proc __isv_ToolDefineFrame { frame } {
  global mom_sim_arr
  global gPB
  global paOption tixOption
  global tool_count
  set item_list [list name type offset_used x_off y_off z_off \
  carrier_id pocket_id diameter cutcom_register \
  cutcom_value adjust_register adjust_value]
  set gPB(tool_item_list) $item_list
  set tool_count 0
  if {![info exists mom_sim_arr(\$mom_sim_ug_tool_name)]} {
   set mom_sim_ug_tool_name ""
  }
  set tool_info $frame
  set tool_add [frame $tool_info.add -width 30]
  set tool_list [frame $tool_info.list]
  pack $tool_add -side top -fill x
  pack $tool_list -side top -fill both -expand yes
  set gPB(tool_col) $tool_list
  set gPB(add_tool) 1
  set add_opt [tixControl $tool_add.col -integer true -min 0 -max 100 \
  -command    "" \
  -selectmode immediate \
  -variable gPB(add_tool) -label "$gPB(isv,tool_info,toolnum,Label)"\
  -options {
   entry.width 6
   label.anchor w
  }]
  set tool_button [button $tool_add.but -width 8 -text "$gPB(isv,tool_info,add_tool,Label)" \
  -bg $paOption(app_butt_bg) -command "__isv_ToolCreateOnerow $tool_add $tool_list"]
  pack $add_opt $tool_button -side left -padx 10 -pady 8
  pack $add_opt -side left -padx 10 -pady 10
  __isv_CreateToolInfoGrid $tool_list
  set gPB(c_help,$add_opt) "isv,tool_info,toolnum"
  set gPB(c_help,$tool_button) "isv,tool_info,add_tool"
 }

#=======================================================================
proc __isvSaveWCSWinValue { win wcs_num ind} {
  global gPB
  global mom_sim_arr
  set widget $win
  set var [$widget cget -textvariable]
  set wcs_option $wcs_num
  if { $wcs_option == "" || $wcs_option < 0 } {
   return
  }
  set mom_sim_arr(\$mom_sim_wcs_offsets\($wcs_option\)) \
  [lreplace $mom_sim_arr(\$mom_sim_wcs_offsets\($wcs_option\)) $ind $ind [set $var]]
 }

#=======================================================================
proc __isv_CreateSpecLisPopup { X Y x y spec_list text_widget} {
  global gPB
  global isv_def_id
  set page_obj $isv_def_id
  set entry_index [$spec_list nearest $y]
  $spec_list selection clear
  $spec_list anchor clear
  if { [string compare $entry_index ""] } {
   $spec_list selection set $entry_index
   $spec_list anchor set $entry_index
  }
  __isv_DisplayLeaderCode $spec_list $text_widget
  set popup $gPB(prelis_popup)
  $popup delete 0 end
  if 0 {
   $popup add command -label "$gPB(isv,spec_command,delete,Label)"\
   -state normal -command "__isv_DeleteSpecialCommand $spec_list $y"
  }
  if { ![string compare $entry_index ""] } {
   $popup add command -label "$gPB(nav_button,cut,Label)"\
   -state disabled -command "__isv_CutSpecialCommand $spec_list $y"
   } else {
   $popup add command -label "$gPB(nav_button,cut,Label)"\
   -state normal -command "__isv_CutSpecialCommand $spec_list $y"
  }
  if { [info exists Page::($page_obj,buff_cmd_obj)] } {
   $popup add command -label "$gPB(nav_button,paste,Label)"\
   -state normal -command "__isv_PasteSpecialCommand $spec_list $y"
   } else {
   $popup add command -label "$gPB(nav_button,paste,Label)"\
   -state disabled -command ""
  }
  tk_popup $popup $X $Y
 }

#=======================================================================
proc __isv_CreateSpecListPopup { spec_lis text_widget} {
  global gPB
  set popup [menu $spec_lis.pop -tearoff 0]
  set gPB(prelis_popup) $popup
  bind $spec_lis <3> "__isv_CreateSpecLisPopup %X %Y %x %y $spec_lis $text_widget"
 }

#=======================================================================
proc __isv_UpdateNCCommandList { args } {
  global mom_sys_arr mom_sim_arr mom_kin_var
  global post_object gPB
  global mom_sim_pre_com_list
  if {[llength $args]} {
   set switch_tag 1
   } else {
   set switch_tag 0
  }
  catch { array set mom_sim_arr $Post::($post_object,mom_sim_var_list) }
  if {![info exists mom_sim_arr(\$mom_sim_pre_com_list)] } {
   if 0 {
    if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
     set mom_sim_arr(\$mom_sim_precod_list) [list G04 T]
     set mom_sim_arr(\$mom_sim_pre_com_list) [list G04 T]
     } else {
     set mom_sim_arr(\$mom_sim_sub_precod_list) [list]
     set mom_sim_arr(\$mom_sim_pre_com_list) [list]
    }
   }
   set mom_sim_arr(\$mom_sim_sub_precod_list) [list]
   set mom_sim_arr(\$mom_sim_pre_com_list) [list]
   } else {
   if { $switch_tag == 1 } {
    if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
     if { ![info exists mom_sim_arr(\$mom_sim_precod_list)] ||\
      [llength $mom_sim_arr(\$mom_sim_precod_list)] == 0 } {
      set mom_sim_arr(\$mom_sim_precod_list) $mom_sim_arr(\$mom_sim_pre_com_list)
      } else {
      set mom_sim_arr(\$mom_sim_pre_com_list) $mom_sim_arr(\$mom_sim_precod_list)
     }
     } else {
     if { ![info exists mom_sim_arr(\$mom_sim_sub_precod_list)] ||\
      [llength $mom_sim_arr(\$mom_sim_sub_precod_list)] == 0 } {
      set mom_sim_arr(\$mom_sim_pre_com_list) [list]
      set mom_sim_arr(\$mom_sim_sub_precod_list) $mom_sim_arr(\$mom_sim_pre_com_list)
      } else {
      set mom_sim_arr(\$mom_sim_pre_com_list) $mom_sim_arr(\$mom_sim_sub_precod_list)
     }
    }
   }
  }
  if {[string match "Standalone" $mom_sys_arr(VNC_Mode)]} {
   if {![info exists mom_sim_arr(\$mom_sim_user_com_list)] } {
    set mom_sim_arr(\$mom_sim_user_com_list) [list]
   }
   } else {
   if {![info exists mom_sim_arr(\$mom_sim_sub_user_list)] } {
    set mom_sim_arr(\$mom_sim_sub_user_list) [list]
   }
  }
  if {![info exists mom_sim_arr(\$mom_sim_num_machine_axes)] } {
   if { [info exists mom_kin_var(\$mom_kin_machine_type)] } {
    if { [string match "5*" $mom_kin_var(\$mom_kin_machine_type)] } {
     set mom_sim_arr(\$mom_sim_num_machine_axes) "5"
     } elseif { [string match "4*" $mom_kin_var(\$mom_kin_machine_type)] } {
     set mom_sim_arr(\$mom_sim_num_machine_axes) "4"
     } elseif { [string match "3_axis_mill_turn" $mom_kin_var(\$mom_kin_machine_type)] } {
     set mom_sim_arr(\$mom_sim_num_machine_axes) "3mt"
     } elseif { [string match "lathe" $mom_kin_var(\$mom_kin_machine_type)] } {
     set mom_sim_arr(\$mom_sim_num_machine_axes) "2"
     } else {
     set mom_sim_arr(\$mom_sim_num_machine_axes) "3"
    }
   }
  }
  set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
  set Post::($post_object,def_mom_sim_var_list) [array get mom_sim_arr]
  set Post::($post_object,rest_mom_sim_var_list) [array get mom_sim_arr]
 }

#=======================================================================
proc __isv_DisplayLeaderCode { win text_widget args } {
  global mom_sim_arr gPB mom_sys_arr
  global pb_cmd_procname post_object
  global isv_def_id
  global is_from_spec_cmd_win
  set page_obj $isv_def_id
  set index [$win selection get]
  set var mom_sim_arr(\$mom_sim_pre_com_list)
  set gPB(pre_list,index) $index
  if {![info exists gPB(pre_list,def_index)] } {
   set gPB(pre_list,def_index) $index
  }
  if { [info exists gPB(pre_list,active_cmd_obj)] } {
   set cmd_obj $gPB(pre_list,active_cmd_obj)
   } else {
   set cmd_obj 0
  }
  set tag [lindex $args 0]
  if {![string match "res" $tag] && ![string match "def" $tag] } {
   if { ![info exists is_from_spec_cmd_win] || $is_from_spec_cmd_win == 0 } {
    set last_desp [$text_widget get 0.0 end]
    if { [info exists Post::($post_object,mom_vnc_desc_list)] } {
     array set vnc_desc_arr $Post::($post_object,mom_vnc_desc_list)
     } else {
     array set vnc_desc_arr [list]
    }
    if { $cmd_obj > 0 } {
     set command::($cmd_obj,description) $last_desp
     set last_cmd $command::($cmd_obj,name)
     set vnc_desc_arr($last_cmd,desc) $last_desp
    }
    set Post::($post_object,mom_vnc_desc_list) [array get vnc_desc_arr]
    } else {
    unset is_from_spec_cmd_win
   }
  }
  if {[string match "" $index]} {
   set gPB(pre_code) ""
   return
  }
  set cmd_name [$win entrycget $index -text]
  if 0 {
   if {[string first " " $cmd_name] > 0} {
    set pb_cmd_procname [join [split $cmd_name " "] _]
    } else {
    set pb_cmd_procname $cmd_name
   }
  }
  set pb_cmd_procname $cmd_name
  set command_name "PB_CMD_vnc__$pb_cmd_procname"
  Post::GetObjList $post_object command cmd_obj_list
  PB_com_RetObjFrmName command_name cmd_obj_list cmd_obj
  set gPB(pre_code) $cmd_name
  set Page::($page_obj,active_cmd_obj) $cmd_obj
  set gPB(pre_list,active_cmd_obj) $cmd_obj
  if { $cmd_obj > 0 } {
   if { [info exists Post::($post_object,mom_vnc_desc_list)] } {
    array set vnc_desc_arr $Post::($post_object,mom_vnc_desc_list)
    if { [info exists vnc_desc_arr($command_name,desc)] } {
     set command::($cmd_obj,description) $vnc_desc_arr($command_name,desc)
     } else {
     set command::($cmd_obj,description) ""
    }
   }
   if { [info exists command::($cmd_obj,description)] && \
    ![string match "" $command::($cmd_obj,description)] } {
    set description [string trimright $command::($cmd_obj,description) \n]
    $text_widget delete 0.0 end
    $text_widget insert insert $description
    } else {
    set command::($cmd_obj,description) ""
    $text_widget delete 0.0 end
   }
  }
 }

#=======================================================================
proc __isv_SaveCommandDecs { text_widget scr_list } {
  global isv_def_id gPB
  global post_object
  set page_obj $isv_def_id
  set index [$scr_list selection get]
  if [string match "" $index] {return}
  set token [$scr_list entrycget $index -text]
  set cmd_name "PB_CMD_vnc__$token"
  Post::GetObjList $post_object command cmd_obj_list
  PB_com_RetObjFrmName cmd_name cmd_obj_list cmd_obj
  set Page::($page_obj,active_cmd_obj) $cmd_obj
  if {![info exist Page::($page_obj,active_cmd_obj)]} {
   return
   } elseif { [string match "" $Page::($page_obj,active_cmd_obj)] } {
   return
   } else {
   set cmd_obj $Page::($page_obj,active_cmd_obj)
   if { $cmd_obj <= 0 } {
    return
   }
   set text [$text_widget get 0.0 end]
   if { [info exists command::($cmd_obj,description)] } {
    unset command::($cmd_obj,description)
   }
   set text [string trim $text]
   set command::($cmd_obj,description) $text
   set cmd_name $command::($cmd_obj,name)
   array set vnc_desc_arr $Post::($post_object,mom_vnc_desc_list)
   set vnc_desc_arr($cmd_name,desc) $command::($cmd_obj,description)
   set Post::($post_object,mom_vnc_desc_list) [array get vnc_desc_arr]
  }
 }

#=======================================================================
proc __isv_SpecialDefinePreCommand { page_obj spec_pre } {
  global paOption tixOption
  global gPB mom_sim_arr
  pack $spec_pre -side top -padx 20 -pady 20 -fill both -expand yes
  set spec_frm [$spec_pre subwidget frame]
  set addr_def [frame $spec_frm.preleft]
  pack $addr_def -fill both -expand yes ;#<May-25-2017 gsl> -expand yes
  set pre_top [frame $addr_def.top]
  set pre_bot [frame $addr_def.bot]
  pack $pre_top -side top -fill both -pady 5 -padx 5
  pack $pre_bot -side top -fill both -pady 5 -padx 5 -expand yes
  set bg_clr gray90
  set pre_t [frame $pre_top.top -bd 1 -relief ridge -bg $bg_clr]
  set pre_m [frame $pre_bot.m]
  set pre_l [frame $pre_bot.left]
  set pre_r [frame $pre_bot.right -relief raised -bd 1]
  pack $pre_t -side left -padx 2 -pady 2 -fill both -expand yes
  pack $pre_m -side top   -pady 2 -fill x ;#   -expand yes
  pack $pre_l -side left  -padx 0 -fill both -expand yes ;#<11-02-07 gsl> -padx was 2.
  pack $pre_r -side right -padx 2 -fill both -expand yes
  set pre_ldrcod [label $pre_t.lbl -text "$gPB(isv,spec_nccode,Label)" -bg $bg_clr]
  set pre_code [entry $pre_t.ent2 -textvariable gPB(pre_code)]
  set pre_lbl  [label $pre_m.lbl -text "$gPB(isv,spec_codelist,Label)" \
  -font $tixOption(italic_font)]
  pack $pre_lbl -side left -padx 2
  set precom_list [tixScrolledHList $pre_l.list -width 100 -scrollbar auto]
  set pre_list [$precom_list subwidget hlist]
  set gPB(pre_list) $pre_list
  $pre_list config -bg $paOption(tree_bg) -relief sunken -takefocus 0
  pack $precom_list -side left -fill both -expand yes
  set pre_rt [frame $pre_r.top]
  pack $pre_rt -side top -fill x ;# -expand yes
  set des_lbl [label $pre_rt.lbl -text "$gPB(isv,spec_desc,Label)" -font $gPB(font)]
  set precom_text [tixScrolledText $pre_r.txt -scrollbar y -width 140]
  set pre_text [$precom_text subwidget text]
  $pre_text config -bg lightGoldenRod1 -wrap word -font $gPB(font)
  set gPB(pre_text) $pre_text
  pack $des_lbl -side top -fill x -expand no ;#<11-02-07 gsl> was -side left -padx 5.
  pack $precom_text -side bottom -fill both -padx 3 -pady 3 -expand yes ;#<May-25-2017 gsl> -expand yes
  set pre_but [button $pre_t.but -text "  $gPB(isv,spec_command,add,Label)  " \
  -relief raised -bd 2 -bg $paOption(app_butt_bg) \
  -command "__isv_AddNewSpecialCommand $pre_list"]
  bind $pre_code <Return> "__isv_RenamePreCommand %W"
  bind $pre_code <KeyPress> "UI_PB_com_DisableSpecialChars %W %K 1"
  bind $pre_code <KeyRelease> { %W config -state normal }
  pack $pre_ldrcod -padx 10 -pady 2 -side left ;#<01-17-08 gsl> -padx was 5.
  pack $pre_but -side right -padx 5 -pady 2
  pack $pre_code -side right -padx 5 -pady 2 -fill x -expand yes
  set cmd [list __isv_CreateSpecialCommandWindow $gPB(pre_list)]
  $pre_list config -browsecmd "__isv_DisplayLeaderCode $pre_list $pre_text" \
  -command $cmd
  set gPB(sens,browse_cmd,$pre_list) "__isv_DisplayLeaderCode $gPB(pre_list) $gPB(pre_text)"
  set gPB(sens,execute_cmd,$pre_list) "$cmd"
  set gPB(sens,right_cmd,$pre_list) "__isv_CreateSpecLisPopup %X %Y %x %y $gPB(pre_list) $gPB(pre_text)"
  __isv_RecreateLeftSpec
  bind $pre_text <Leave> "__isv_SaveCommandDecs %W $gPB(pre_list)"
  set gPB(c_help,$pre_top.ent1) "isv,spec_command,preleader"
  set gPB(c_help,$pre_top.ent2) "isv,spec_command,precode"
  set gPB(c_help,$pre_top.but)  "isv,spec_command,add"
  set gPB(c_help,$pre_list)     "isv,spec_pre,frame"
  __isv_CreateSpecListPopup $pre_list $pre_text
 }

#=======================================================================
proc __isv_CreateLeaderPopup { page_obj frame } {
  global gPB
  set menu_spe [menu $frame.popspe -tearoff 0]
  bind $frame.ent1 <3> "tk_popup $menu_spe %X %Y"
  set options_list {A B C D E F G H I J K L M N O \
  P Q R S T U V W X Y Z "gPB(address,none_popup,Label)"}
  set bind_widget $frame.ent1
  set callback "__isv_SelectLeader"
  __isv_SetPopupOptions menu_spe options_list callback \
  bind_widget
 }

#=======================================================================
proc __isv_ToolSelectLeader { b str } {
  global gPB
  $b delete 0 end
  $b insert 0 $str
  set gPB(tname) $str
  $b selection range 0 end
 }

#=======================================================================
proc __isv_SelectLeader { b str } {
  global mom_sim_arr
  global gPB
  set ent_var [$b cget -textvariable]
  $b delete 0 end
  $b insert 0 $str
  set $ent_var $str
  $b selection range 0 end
  focus $b
  if {[string match "UVW" $mom_sim_arr(\$mom_sim_mode_leader)]} {
   set var(0) "gPB(output_X)"
   set var(1) "gPB(output_Y)"
   set var(2) "gPB(output_Z)"
   set var(3) "gPB(output_A)"
   set var(4) "gPB(output_B)"
   for { set i 0} { $i < 5 } { incr i} {
    set str [set $var($i)]
    if {[string match "" $str]} { set str "-"}
    catch { set mom_sim_arr(\$mom_sim_incr_linear_addrs) [lreplace $mom_sim_arr(\$mom_sim_incr_linear_addrs) $i $i $str]}
   }
   } else {
   set mom_sim_arr(\$mom_sim_incr_linear_addrs) [list]
  }
 }

#=======================================================================
proc __isv_SetPopupOptions { MENU OPTIONS_LIST CALLBACK BIND_WIDGET } {
  global gPB
  upvar $MENU menu1
  upvar $OPTIONS_LIST options_list
  upvar $CALLBACK callback
  upvar $BIND_WIDGET bind_widget
  set count 1
  foreach ELEMENT $options_list  {
   if { $ELEMENT == "gPB(address,none_popup,Label)" } {
    $menu1 add command -label [set $ELEMENT] -command "$callback $bind_widget \"\""
    } else {
    if { $count == 1 } {
     $menu1 add command -label $ELEMENT -columnbreak 1 -command "$callback $bind_widget $ELEMENT"
     } else {
     $menu1 add command -label $ELEMENT -command "$callback $bind_widget $ELEMENT"
    }
   }
   if { $count == 9 } {
    set count 0
   }
   incr count
  }
 }

#=======================================================================
proc __isv_UpdateCmdNameData { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global pb_cmd_procname
  set active_cmd $Page::($page_obj,active_cmd_obj)
  set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
  set prev_cmd_name $command::($active_cmd,name)
  set ind [string compare $cur_cmd_name $prev_cmd_name]
  if { [string compare $cur_cmd_name $prev_cmd_name] != 0 } {
   PB_int_RemoveCmdProcFromList active_cmd
   set command::($active_cmd,name) $cur_cmd_name
   PB_int_UpdateCommandAdd active_cmd
   command::readvalue $active_cmd cmd_obj_attr
   set cmd_obj_attr(0) PB_CMD_${pb_cmd_procname}
   command::setvalue $active_cmd cmd_obj_attr
   array set def_cmd_attr $command::($active_cmd,def_value)
   set def_cmd_attr(0) $prev_cmd_name
   command::DefaultValue $active_cmd def_cmd_attr
   if [info exists command::($active_cmd,rest_value)] {
    array set rest_cmd_attr $command::($active_cmd,rest_value)
    } else {
    array set rest_cmd_attr [array get cmd_obj_attr]
   }
   set rest_cmd_attr(0) $prev_cmd_name
   set command::($active_cmd,rest_value) [array get rest_cmd_attr]
  }
 }

#=======================================================================
proc __isv_EditSelectedCommand { ind cus_list win } {
  global gPB mom_sim_arr mom_sys_arr
  global pb_cmd_procname post_object
  global isv_def_id
  set page_obj $isv_def_id
  set num [$cus_list entrycget $ind -text]
  set entry_var [$win cget -textvariable]
  set item [set $entry_var]
  set disp_name $item
  if { [string first " " $disp_name] > 0 } {
   set disp_name [join [split $disp_name " "] _]
  }
  set display_name "PB_CMD_vnc__$disp_name"
  if { [string first " " $num] > 0 } {
   set exist_command [join [split $num " "] _]
   } else {
   set exist_command $num
  }
  set pb_cmd_procname "vnc__$exist_command"
  set exist_command "PB_CMD_vnc__$exist_command"
  if { ![string match "$num" "$item"] } {
   PB_int_RetCmdBlks cmd_blk_list
   PB_com_RetObjFrmName display_name cmd_blk_list cmd_obj
   if { $cmd_obj > 0 } {
    tk_messageBox -message "VNC command exists already!" -icon warning
    set gPB(pre_code) $num
    $win config -takefocus 1
    return
   }
   PB_com_RetObjFrmName exist_command cmd_blk_list cmd_obj
   if { $cmd_obj <= 0 } {
    tk_messageBox -message "Cannot rename nonexistent VNC handler for \"$num\".\nRemove token from the list!" -icon error
    set gPB(pre_code) $num
    $win config -takefocus 1
    return
   }
   set Page::($page_obj,active_cmd_obj) $cmd_obj
   set gPB(pre_list,active_cmd_obj) $cmd_obj
   $cus_list entryconfig $ind -text "$item"
   set pb_cmd_procname "vnc__$disp_name"
   array set vnc_desc_arr $Post::($post_object,mom_vnc_desc_list)
   set prev_cmd_name $command::($cmd_obj,name)
   set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
   set vnc_desc_arr($cur_cmd_name,desc) $vnc_desc_arr($prev_cmd_name,desc)
   unset vnc_desc_arr($prev_cmd_name,desc)
   set Post::($post_object,mom_vnc_desc_list) [array get vnc_desc_arr]
   __isv_UpdateCmdNameData page_obj
   catch {array set mom_sim_arr $Post::($post_object,mom_sim_var_list)}
   set index [lsearch $mom_sim_arr(\$mom_sim_pre_com_list) "$num"]
   set mom_sim_arr(\$mom_sim_pre_com_list) \
   [lreplace $mom_sim_arr(\$mom_sim_pre_com_list) $index $index "$item"]
   if { [string match $mom_sys_arr(VNC_Mode) "Standalone"] } {
    set index [lsearch $mom_sim_arr(\$mom_sim_precod_list) "$num"]
    set mom_sim_arr(\$mom_sim_precod_list)  \
    [lreplace $mom_sim_arr(\$mom_sim_precod_list) $index $index "$item"]
    set it [lsearch $mom_sim_arr(\$mom_sim_vnc_com_list) $exist_command]
    set mom_sim_arr(\$mom_sim_vnc_com_list)  \
    [lreplace $mom_sim_arr(\$mom_sim_vnc_com_list) $it $it $display_name]
    set uit [lsearch $mom_sim_arr(\$mom_sim_user_com_list) $exist_command]
    set mom_sim_arr(\$mom_sim_user_com_list)  \
    [lreplace $mom_sim_arr(\$mom_sim_user_com_list) $uit $uit $display_name]
    } else {
    set index [lsearch $mom_sim_arr(\$mom_sim_sub_precod_list) "$num"]
    set mom_sim_arr(\$mom_sim_sub_precod_list)  \
    [lreplace $mom_sim_arr(\$mom_sim_sub_precod_list) $index $index "$item"]
    set it [lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $exist_command]
    set mom_sim_arr(\$mom_sim_sub_vnc_list)  \
    [lreplace $mom_sim_arr(\$mom_sim_sub_vnc_list) $it $it $display_name]
    set uit [lsearch $mom_sim_arr(\$mom_sim_sub_user_list) $exist_command]
    set mom_sim_arr(\$mom_sim_sub_user_list)  \
    [lreplace $mom_sim_arr(\$mom_sim_sub_user_list) $uit $uit $display_name]
   }
   set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
  }
 }

#=======================================================================
proc __isv_RenamePreCommand { win } {
  global gPB
  set pre_list $gPB(pre_list)
  set index [$pre_list selection get]
  if { $index >= 0 } {
   __isv_EditSelectedCommand $index $pre_list $win
  }
 }

#=======================================================================
proc __isv_AddNewSpecialCommand { win_list } {
  global gPB
  global post_object
  global mom_sys_arr mom_sim_arr
  global isv_def_id
  set page_obj $isv_def_id
  set num $gPB(pre_code)
  set display_name [string trim $num]
  if { [string match "" $display_name] } {
   return
  }
  if { [string first " " $display_name] > 0 } {
   set new_com_name [join [split $display_name " "] _]
   } else {
   set new_com_name $display_name
  }
  set cmd_obj 0
  set new_com_name "PB_CMD_vnc__$new_com_name"
  Post::GetObjList $post_object command cmd_blk_list
  PB_com_RetObjFrmName new_com_name cmd_blk_list cmd_obj
  if { $cmd_obj <= 0 } {
   set obj_attr(0) $new_com_name
   set obj_attr(1) ""
   lappend obj_attr(1) "  global mom_sim_o_buffer"
   lappend obj_attr(1) ""
   lappend obj_attr(1) "  # Skip process of an empty block"
   lappend obj_attr(1) "   if { \[string length \[string trim \$mom_sim_o_buffer\]\] == 0 } {"
    lappend obj_attr(1) " return \"\""
   lappend obj_attr(1) "   }"
   lappend obj_attr(1) ""
   lappend obj_attr(1) ""
   lappend obj_attr(1) "  ## By default, this handler is disabled until you comment out next line."
   lappend obj_attr(1) "  ##"
   lappend obj_attr(1) " return \$mom_sim_o_buffer"
   lappend obj_attr(1) ""
   lappend obj_attr(1) ""
   lappend obj_attr(1) "  ## Make sure token below match exactly with the string to be processed."
   lappend obj_attr(1) "  ##"
   lappend obj_attr(1) "   set NC_token \"$num\""
   lappend obj_attr(1) ""
   lappend obj_attr(1) ""
   lappend obj_attr(1) ""
   lappend obj_attr(1) "   global mom_sim_nc_register mom_sim_pos mom_sim_prev_pos"
   lappend obj_attr(1) "   global mom_sim_result mom_sim_result1 mom_sim_address"
   lappend obj_attr(1) "   global mom_sim_nc_code"
   lappend obj_attr(1) ""
   lappend obj_attr(1) "   set o_buff \$mom_sim_o_buffer"
   lappend obj_attr(1) ""
   lappend obj_attr(1) ""
   lappend obj_attr(1) "  # - VNC_parse_nc_word command can be used to process this token."
   lappend obj_attr(1) "  #"
   lappend obj_attr(1) "  # You will set the match level and/or provide callback function with respect to"
   lappend obj_attr(1) "  # the application for this token.  By default, the token is removed from the"
   lappend obj_attr(1) "  # block buffer when a match is found, unless match level \"0\" is specified."
   lappend obj_attr(1) "  #"
   lappend obj_attr(1) "  #  Match Level -"
   lappend obj_attr(1) "  #   0 = Any match      \(token preserved\)"
   lappend obj_attr(1) "  #   1 = Exact match    \(token without trailing numerals\)"
   lappend obj_attr(1) "  #   2 = Extended match \(token with trailing numerals - Value stored in mom_sim_nc_code\)"
   lappend obj_attr(1) "  #   3 = Any match      \(token & numerals removed\)"
   lappend obj_attr(1) "  #"
   lappend obj_attr(1) "   set match_level 1"
   lappend obj_attr(1) ""
   lappend obj_attr(1) ""
   lappend obj_attr(1) "  # Optional callback function can be provided."
   lappend obj_attr(1) "  #"
   lappend obj_attr(1) "   set callback \"\""
   lappend obj_attr(1) ""
   lappend obj_attr(1) ""
   lappend obj_attr(1) "  #  Return Value -"
   lappend obj_attr(1) "  #   0 = No match"
   lappend obj_attr(1) "  #   1 = Match found"
   lappend obj_attr(1) "  #  -1 = Match found but callback (if supplied) not found"
   lappend obj_attr(1) "  #"
   lappend obj_attr(1) "   set result \[VNC_parse_nc_word o_buff \"\$NC_token\" \$match_level \$callback\]"
   lappend obj_attr(1) ""
   lappend obj_attr(1) "   if { \$result } {"
    lappend obj_attr(1) ""
    lappend obj_attr(1) "     ## Extract coordinates data from this block, if needed"
    lappend obj_attr(1) "     ## to perform a movement or for other purposes."
    lappend obj_attr(1) "     ##"
    lappend obj_attr(1) "     ## - Coordinate data per Address leader will be stored in mom_sim_pos array as following:"
    lappend obj_attr(1) "     ##   (0)X  (1)Y  (2)Z  (3)4th  (4)5th  (5)I  (6)J  (7)K  (8)R  (9)K  (10)S  (11)F"
    lappend obj_attr(1) "     ##"
    lappend obj_attr(1) "     # set simulate_block \[PB_SIM_call VNC_parse_motion_word \$o_buff\]"
    lappend obj_attr(1) ""
    lappend obj_attr(1) ""
    lappend obj_attr(1) "     ## Perform other actions with respect to this token."
    lappend obj_attr(1) "     ##"
    lappend obj_attr(1) ""
    lappend obj_attr(1) ""
    lappend obj_attr(1) ""
    lappend obj_attr(1) "     ## When necessary, clear block buffer to prevent further processing of this block,"
    lappend obj_attr(1) "     ## otherwise the remaining content will be subject to subsequent process."
    lappend obj_attr(1) "     ##"
    lappend obj_attr(1) "     # set o_buff \"\""
   lappend obj_attr(1) "   }"
   lappend obj_attr(1) ""
   lappend obj_attr(1) "   set mom_sim_o_buffer \$o_buff"
   lappend obj_attr(1) ""
   lappend obj_attr(1) ""
   lappend obj_attr(1) " return \$o_buff"
   PB_pps_CreateCommand obj_attr cmd_obj
   catch {array set mom_sim_arr $Post::($post_object,mom_sim_var_list)}
   if 1 {
    if {[info exists Page::($page_obj,active_cmd_obj)] && $Page::($page_obj,active_cmd_obj) > 0} {
     set prev_cmd_obj $Page::($page_obj,active_cmd_obj)
     set prev_cmd_fname $command::($prev_cmd_obj,name)
     set prev_cmd_sname [string range $prev_cmd_fname 12 end]
    }
    if { [string match "Subordinate" $mom_sys_arr(VNC_Mode)] } {
     if {[info exists prev_cmd_obj]} {
      set mom_sim_arr(\$mom_sim_sub_precod_list) [linsert $mom_sim_arr(\$mom_sim_sub_precod_list) [expr [lsearch $mom_sim_arr(\$mom_sim_sub_precod_list) $prev_cmd_sname]+1] "$num"]
      set mom_sim_arr(\$mom_sim_sub_vnc_list) [linsert $mom_sim_arr(\$mom_sim_sub_vnc_list) [expr [lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $prev_cmd_fname]+1] "$new_com_name"]
      set mom_sim_arr(\$mom_sim_sub_user_list) [linsert $mom_sim_arr(\$mom_sim_sub_user_list) [expr [lsearch $mom_sim_arr(\$mom_sim_sub_user_list) $prev_cmd_fname]+1] "$new_com_name"]
      } else {
      lappend mom_sim_arr(\$mom_sim_sub_precod_list) "$num"
      lappend mom_sim_arr(\$mom_sim_sub_vnc_list) "$new_com_name"
      lappend mom_sim_arr(\$mom_sim_sub_user_list) "$new_com_name"
     }
     } else {
     if {[info exists prev_cmd_obj]} {
      set mom_sim_arr(\$mom_sim_precod_list) [linsert $mom_sim_arr(\$mom_sim_precod_list) [expr [lsearch $mom_sim_arr(\$mom_sim_precod_list) $prev_cmd_sname]+1] "$num"]
      set mom_sim_arr(\$mom_sim_vnc_com_list) [linsert $mom_sim_arr(\$mom_sim_vnc_com_list) [expr [lsearch $mom_sim_arr(\$mom_sim_vnc_com_list) $prev_cmd_fname]+1] "$new_com_name"]
      set mom_sim_arr(\$mom_sim_user_com_list) [linsert $mom_sim_arr(\$mom_sim_user_com_list) [expr [lsearch $mom_sim_arr(\$mom_sim_user_com_list) $prev_cmd_fname]+1] "$new_com_name"]
      } else {
      lappend mom_sim_arr(\$mom_sim_precod_list) "$num"
      lappend mom_sim_arr(\$mom_sim_vnc_com_list) "$new_com_name"
      lappend mom_sim_arr(\$mom_sim_user_com_list) "$new_com_name"
     }
    }
    if {[info exists prev_cmd_obj]} {
     set mom_sim_arr(\$mom_sim_pre_com_list) [linsert $mom_sim_arr(\$mom_sim_pre_com_list) [expr [lsearch $mom_sim_arr(\$mom_sim_pre_com_list) $prev_cmd_sname]+1] "$display_name"]
     } else {
     lappend mom_sim_arr(\$mom_sim_pre_com_list) $display_name
    }
    } else {
    if { [string match "Subordinate" $mom_sys_arr(VNC_Mode)] } {
     lappend mom_sim_arr(\$mom_sim_sub_precod_list) "$num"
     lappend mom_sim_arr(\$mom_sim_sub_vnc_list) "$new_com_name"
     lappend mom_sim_arr(\$mom_sim_sub_user_list) "$new_com_name"
     } else {
     lappend mom_sim_arr(\$mom_sim_precod_list) "$num"
     lappend mom_sim_arr(\$mom_sim_vnc_com_list) "$new_com_name"
     lappend mom_sim_arr(\$mom_sim_user_com_list) "$new_com_name"
    }
    lappend mom_sim_arr(\$mom_sim_pre_com_list) "$display_name"
   }
   set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
   set list_length [llength $mom_sim_arr(\$mom_sim_pre_com_list)]
   set Page::($page_obj,active_cmd_obj) $cmd_obj
   global paOption tixOption
   set style1 [tixDisplayStyle imagetext -bg $paOption(tree_bg) \
   -padx 4 -pady 1 -font $tixOption(bold_font)]
   set hand [tix getimage pb_vnc_user]
   set index [$win_list selection get]
   set index [lsearch $mom_sim_arr(\$mom_sim_pre_com_list) "$display_name"]
   set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
   set gPB(pre_list,index) $index
   __isv_RecreateLeftSpec
   __isv_CreateSpecialCommandWindow $win_list add
   } else {
   set title "$gPB(msg,error)"
   set err_msg "This token has been handled already!"
   tk_messageBox -parent [ UI_PB_com_AskActiveWindow ] -type ok -icon error \
   -message "$err_msg" -title "$title"
   return
  }
 }

#=======================================================================
proc __isv_DeleteSpecialCommand { cus_list args } {
  global post_object
  global mom_sys_arr mom_sim_arr
  global gPB isv_def_id
  set page_obj $isv_def_id
  set list_len [llength $mom_sim_arr(\$mom_sim_pre_com_list)]
  if { [llength $args] } {
   set y [lindex $args 0]
   set index [$cus_list nearest $y]
   } else {
   set is_from_cancel 1
   set add_cmd_obj $Page::($page_obj,active_cmd_obj)
   set add_cmd_name [string range $command::($add_cmd_obj,name) 12 end]
   set index [lsearch $mom_sim_arr(\$mom_sim_pre_com_list) $add_cmd_name]
  }
  if { $index == "" } {
   set title "$gPB(cust_cmd,error,title)"
   set err_msg "$gPB(isv,spec_command,sel_err,Msg)"
   tk_messageBox -parent [ UI_PB_com_AskActiveWindow ] \
   -type ok -icon error \
   -message "$err_msg" -title "$title"
   return
  }
  set display_name [$cus_list entrycget $index -text]
  set in [lsearch $mom_sim_arr(\$mom_sim_pre_com_list) $display_name]
  set mom_sim_arr(\$mom_sim_pre_com_list) \
  [lreplace $mom_sim_arr(\$mom_sim_pre_com_list) $in $in]
  if { [string first " " $display_name] > 0 } {
   set display_name [join [split $display_name " "] _]
  }
  set cmd_name "PB_CMD_vnc__$display_name"
  Post::GetObjList $post_object command all_cmd_list
  set cmd_obj $Page::($page_obj,active_cmd_obj)
  set ind [lsearch $all_cmd_list $cmd_obj]
  set all_cmd_list [lreplace $all_cmd_list $ind $ind]
  Post::SetObjListasAttr $post_object all_cmd_list
  array set vnc_desc_arr $Post::($post_object,mom_vnc_desc_list)
  if { [info exists vnc_desc_arr($cmd_name,desc)] } {
   unset vnc_desc_arr($cmd_name,desc)
   set Post::($post_object,mom_vnc_desc_list) [array get vnc_desc_arr]
  }
  if { [string match "Subordinate" $mom_sys_arr(VNC_Mode)] } {
   set cmd_blk_list $mom_sim_arr(\$mom_sim_sub_vnc_list)
   set ind [lsearch $cmd_blk_list $cmd_name]
   set cmd_blk_list [lreplace $cmd_blk_list $ind $ind]
   set mom_sim_arr(\$mom_sim_sub_vnc_list) $cmd_blk_list
   set ind [lsearch $mom_sim_arr(\$mom_sim_sub_user_list) $cmd_name]
   set mom_sim_arr(\$mom_sim_sub_user_list) [lreplace $mom_sim_arr(\$mom_sim_sub_user_list) $ind $ind]
   set mom_sim_arr(\$mom_sim_sub_precod_list)  \
   [lreplace $mom_sim_arr(\$mom_sim_sub_precod_list) $in $in]
   } else {
   set cmd_blk_list $mom_sim_arr(\$mom_sim_vnc_com_list)
   set ind [lsearch $cmd_blk_list $cmd_name]
   set cmd_blk_list [lreplace $cmd_blk_list $ind $ind]
   set mom_sim_arr(\$mom_sim_vnc_com_list) $cmd_blk_list
   set ind [lsearch $mom_sim_arr(\$mom_sim_user_com_list) $cmd_name]
   set mom_sim_arr(\$mom_sim_user_com_list) [lreplace $mom_sim_arr(\$mom_sim_user_com_list) $ind $ind]
   set mom_sim_arr(\$mom_sim_precod_list)  \
   [lreplace $mom_sim_arr(\$mom_sim_precod_list) $in $in]
  }
  if { $is_from_cancel } {
   set pc [$cus_list info prev $index]
   set index_var "gPB(pre_list,index)"
   if { ![string match "" $pc] } {
    set $index_var $pc
    } else {
    set $index_var ""
   }
   unset is_from_cancel
   } else {
   set fc [$cus_list info next $index]
   set pc [$cus_list info prev $index]
   set index_var "gPB(pre_list,index)"
   if { ![string match "" $fc] } {
    set $index_var $index
    } elseif { ![string match "" $pc] } {
    set $index_var $pc
    } else {
    set $index_var ""
   }
  }
  set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
  __isv_RecreateLeftSpec
 }

#=======================================================================
proc __isvGetWCSData { win } {
  global wcs_option
  global wcs_off
  global mom_sim_arr gPB
  set label [$win cget -text]
  set lbl_list [split $label " "]
  set wcs_option [lindex $lbl_list 2]
  set num $wcs_option
  if { [info exists mom_sim_arr(\$mom_sim_wcs_offsets\($num\))] } {
   set gPB(origin_xoff) [lindex $mom_sim_arr(\$mom_sim_wcs_offsets\($num\)) 0]
   set gPB(origin_yoff) [lindex $mom_sim_arr(\$mom_sim_wcs_offsets\($num\)) 1]
   set gPB(origin_zoff) [lindex $mom_sim_arr(\$mom_sim_wcs_offsets\($num\)) 2]
   set gPB(aaxis_off) [lindex $mom_sim_arr(\$mom_sim_wcs_offsets\($num\)) 3]
   set gPB(baxis_off) [lindex $mom_sim_arr(\$mom_sim_wcs_offsets\($num\)) 4]
   set gPB(caxis_off) [lindex $mom_sim_arr(\$mom_sim_wcs_offsets\($num\)) 5]
   } else {
   set gPB(origin_xoff) ""
   set gPB(origin_yoff) ""
   set gPB(origin_zoff) ""
   set gPB(aaxis_off) ""
   set gPB(baxis_off) ""
   set gPB(caxis_off) ""
   $wcs_off.ori.x.ent delete 0 end
   $wcs_off.ori.y.ent delete 0 end
   $wcs_off.ori.z.ent delete 0 end
   $wcs_off.ang.a.ent delete 0 end
   $wcs_off.ang.b.ent delete 0 end
   $wcs_off.ang.c.ent delete 0 end
   return
  }
 }

#=======================================================================
proc __isv_ReviewCodePage { page_obj args} {
  global gPB paOption
  global pb_cmd_procname
  global tixOption
  global mom_sys_arr
  global mom_sim_arr
  set bg $paOption(title_bg)
  set fg $paOption(special_fg)
  set ft $gPB(bold_font)
  set rest_frame $Page::($page_obj,rest_frm)
  set review_frm [frame $rest_frame.review_code]
  pack $review_frm -side top -fill both -padx 3 -pady 0 -expand yes ;#<May-25-2017 gsl>
  set Page::($page_obj,review_frm) $review_frm
  set top_frm [frame $review_frm.top -height 40 -relief flat -bg $bg]
  set mid_frm [frame $review_frm.mid -bg yellow]
  set bot_frm [frame $review_frm.bot -height 40 -relief flat -bg $bg]
  pack $top_frm -side top    -fill x
  pack $bot_frm -side bottom -fill x
  pack $mid_frm -side top    -fill both -expand yes ;#<May-25-2017 gsl> Added -expand yes
  if { ![string match "" $args] } {
   set cmd_mode [lindex $args 0]
  }

#=======================================================================
label $top_frm.prc -text " proc    PB_CMD_vnc__" -fg $fg -bg $bg -font $ft -justify right
 if { $cmd_mode } {
  entry $top_frm.ent -textvariable pb_cmd_procname -width 40 -relief flat -bd 0 -bg $bg -justify left
  bind $top_frm.ent <KeyPress> "UI_PB_com_DisableKeysForProc %W %K"
  bind $top_frm.ent <KeyRelease> { %W config -state normal }
  } else {
  label $top_frm.ent -text "" -fg $fg -bg $bg -font $ft
 }
 label $top_frm.brc -text "   \{ \}   \{" -fg $fg -bg $bg -font $ft
  pack $top_frm.prc $top_frm.ent $top_frm.brc -side left -pady 10
  tixScrolledText $mid_frm.scr
  [$mid_frm.scr subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  [$mid_frm.scr subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  pack $mid_frm.scr -expand yes -fill both
  set text_widget [$mid_frm.scr subwidget text]
  $text_widget config -font $gPB(fixed_font) -wrap none -bd 5 -relief flat
  set Page::($page_obj,text_widget) $text_widget
  set Page::($page_obj,cmd_entry) $top_frm.ent
  set Page::($page_obj,entry_flag) $cmd_mode
  set tbg [lindex [$text_widget config -bg] end]
  set Page::($page_obj,text_widget_bg) $tbg
 label $bot_frm.brc -text "\}" -fg $fg -bg $bg -font $ft
 pack $bot_frm.brc -side left -pady 10 -fill x
 global gPB
 set gPB(custom_command_paste_buffer) ""
 set t  $Page::($page_obj,text_widget)
 if [winfo exists $t.pop] {
  set menu $t.pop
  } else {
  set menu [menu $t.pop -tearoff 0 -cursor ""]
 }
 if { ![info exists gPB(text_select_bg)] } {
  set gPB(text_select_bg) [lindex [$t cget -selectbackground] 0]
 }
 bind $t <1> "%W config -selectbackground $gPB(text_select_bg)"
 bind $t <Button-3> "UI_PB_cmd_AddPopUpMenu $page_obj $t $menu %X %Y"
 bind $t <KeyPress> "_cmd_ChangeTabKey $t %K"
 focus $text_widget
 set sel [[$Page::($page_obj,tree) subwidget hlist] info selection]
 set index [string range $sel 2 end]
 if [string match "" $index] {
  return
 }
}

#=======================================================================
proc __isv_CreateCodeParamPages { page_obj } {
  global pb_cmd_procname
  set canvas_frame $Page::($page_obj,canvas_frame)
  set rest_frm [frame $canvas_frame.rest_frm]
  pack $rest_frm -side top -fill both -expand yes ;#<May-25-2017 gsl> Added -expand
  set Page::($page_obj,rest_frm) $rest_frm
  set pb_cmd_procname ""
  __isv_ReviewCodePage $page_obj 0
  set Page::($page_obj,double_click_flag) 0
 }

#=======================================================================
proc __isv_CodeItemSelection { page_obj args } {
  global post_object
  UI_PB_cmd_SelectItem $page_obj $args
 }

#=======================================================================
proc __isv_DisplayCodeItemParam { page_obj args } {
  global gPB
  global mom_sys_arr
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info anchor]
  set index [string range $ent 2 [string length $ent]]
  if { [string compare $index ""] == 0} \
  {
   set index 0
   $HLIST selection clear
   $HLIST anchor clear
   $HLIST selection set 0.0
   $HLIST anchor set 0.0
  }
  set seq_obj $Page::($page_obj,seq_obj)
  set evt_obj $Page::($page_obj,evt_obj)
  set mom_sys_arr(seq_blk_nc_code) 0
  if { $Page::($page_obj,prev_seq) != $index } {
   set evt_obj_list $sequence::($seq_obj,evt_obj_list)
   set sequence::($seq_obj,evt_obj_list) $evt_obj
   event::RestoreValue $evt_obj
   UI_PB_debug_ForceMsg "$event::($evt_obj,event_name) \
   $event::($evt_obj,block_nof_rows) \
   $event::($evt_obj,evt_elem_list) \
   $event::($evt_obj,evt_itm_obj_list) \
   $event::($evt_obj,event_label)"
   set prev_seq $Page::($page_obj,prev_seq)
   if { $Page::($page_obj,prev_seq) == -1 } {
    UI_PB_evt_SetSequenceObjAttr seq_obj
    set Page::($page_obj,prev_seq) Virtual_NC
    } else {
    UI_PB_evt_DeleteApplyEvtElemsOfSeq page_obj
    set sequence::($seq_obj,evt_obj_list) $Page::($page_obj,prev_evt_obj)
    UI_PB_evt_DeleteObjectsPrevSeq page_obj
    set sequence::($seq_obj,evt_obj_list) $Page::($page_obj,evt_obj)
    set Page::($page_obj,prev_seq) Virtual_NC
    UI_PB_evt_SetSequenceObjAttr seq_obj
    $Page::($page_obj,bot_canvas) yview moveto 0
    $Page::($page_obj,bot_canvas) xview moveto 0
   }
   UI_PB_evt_RestoreSeqObjData seq_obj
   UI_PB_evt_CreateSeqAttributes page_obj
   if { $prev_seq >= 2 && $prev_seq < 3 } {
    if { $seq_index < 2 || $seq_index > 4 } {
     UI_PB_evt_CreateMenuOptions page_obj seq_obj
    }
   }
   set Page::($page_obj,prev_evt_obj) $evt_obj
  }
 }

#=======================================================================
proc __isv_SetPageAttributes { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set Page::($page_obj,popup_flag) 0
  set Page::($page_obj,fmt_flag) 0
  set Page::($page_obj,h_cell) 30       ;# cell height
  set Page::($page_obj,w_cell) 62       ;# cell width
  set Page::($page_obj,w_divi) 4        ;# divider width
  set Page::($page_obj,rect_region) 80  ;# Block rectangle region
  set Page::($page_obj,x_orig) 60       ;# upper-left corner of 1st cell
  set Page::($page_obj,y_orig) 120
  set Page::($page_obj,add_flag) 0
  set Page::($page_obj,last_xb) 0
  set Page::($page_obj,last_yb) 0
  set Page::($page_obj,last_xt) 0
  set Page::($page_obj,last_yt) 0
  set Page::($page_obj,icon_top) 0
  set Page::($page_obj,source_elem_obj) 0
  set Page::($page_obj,being_dragged) 0
 }

#=======================================================================
proc __isv_cmd_CreateACmdBlock { page_obj args } {
  global mom_sys_arr mom_sim_arr post_object
  global pb_proc_name
  if { [info exists Page::($page_obj,rename_index)] } {
   if { [UI_PB_cmd_UpdateCmdEntry $page_obj $Page::($page_obj,rename_index)] == "UI_PB_ERROR" } {
    return
   }
  }
  if { ![info exists Page::($page_obj,active_cmd_obj)] } {
   set act_cmd_obj 0
   set obj_index ""
   } else {
   if { ![UI_PB_cmd_SaveCmdProc $page_obj] } {
    return
   }
   set act_cmd_obj $Page::($page_obj,active_cmd_obj)
   unset Page::($page_obj,active_cmd_obj)
   UI_PB_cmd_DeleteCmdProc $page_obj
  }
  if { $Page::($page_obj,double_click_flag) } {
   set Page::($page_obj,double_click_flag) 0
   unset Page::($page_obj,rename_index)
  }
  if $act_cmd_obj {
   set act_cmd_name $command::($act_cmd_obj,name)
   PB_int_CreateCmdObj act_cmd_obj obj_index
   set cmd_blk_list $Post::($post_object,cmd_blk_list)
   set cmd_obj [lindex $cmd_blk_list $obj_index]
   set cmd_name $command::($cmd_obj,name)
   } else {
   set cmd_obj_attr(0) "PB_CMD_vnc__custom_command"
   set cmd_obj_attr(1) ""
   PB_pps_CreateCommand cmd_obj_attr cmd_obj
   PB_int_UpdateCommandAdd cmd_obj
   set cmd_name $cmd_obj_attr(0)
  }
  UI_PB_debug_ForceMsg "\n obj_index selected to be created : $Page::($page_obj,selected_index) \n"
  if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
   if { [lsearch $mom_sim_arr(\$mom_sim_vnc_com_list) $cmd_name] < 0 } {
    if $act_cmd_obj {
     set ind [lsearch $mom_sim_arr(\$mom_sim_vnc_com_list) $act_cmd_name]
     set ind [expr $ind + 1]
     } else {
     set ind 0
    }
    set mom_sim_arr(\$mom_sim_vnc_com_list) [linsert $mom_sim_arr(\$mom_sim_vnc_com_list) $ind $cmd_name]
    set obj_index $ind
   }
   if { [lsearch $mom_sim_arr(\$mom_sim_user_com_list) $cmd_name] < 0 } {
    lappend mom_sim_arr(\$mom_sim_user_com_list) $cmd_name
   }
   } else {
   if { [lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $cmd_name] < 0 } {
    if $act_cmd_obj {
     set ind [lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $act_cmd_name]
     set ind [expr $ind + 1]
     } else {
     set ind 0
    }
    set mom_sim_arr(\$mom_sim_sub_vnc_list) [linsert $mom_sim_arr(\$mom_sim_sub_vnc_list) $ind $cmd_name]
    set obj_index $ind
   }
   if { [lsearch $mom_sim_arr(\$mom_sim_sub_user_list) $cmd_name] < 0 } {
    lappend mom_sim_arr(\$mom_sim_sub_user_list) $cmd_name
   }
  }
  if { !$act_cmd_obj } {
   set obj_index 0
  }
  set index 0
  if [info exists Page::($page_obj,selected_index)] {
   set index [expr [string range $Page::($page_obj,selected_index) 2 end] + 1]
   unset Page::($page_obj,selected_index)
  }
  set pb_proc_name [string range $cmd_name 12 end]
  set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
  UI_PB_debug_ForceMsg "\n obj_index new selected : $obj_index \n"
  __isv_DisplayCodeNameList page_obj obj_index
  __isv_CodeItemSelection $page_obj 0.$obj_index
 }

#=======================================================================
proc __isv_CommandCutObject-Not-Needed { ACTIVE_CMD_OBJ OBJ_INDEX } {
  upvar $ACTIVE_CMD_OBJ active_cmd_obj
  upvar $OBJ_INDEX obj_index
  PB_int_CommandCutObject active_cmd_obj obj_index
 }

#=======================================================================
proc __isv_CommandCutObject { ACTIVE_CMD_OBJ } {
  upvar $ACTIVE_CMD_OBJ active_cmd_obj
  global post_object mom_sim_arr
  PB_int_RemoveCmdProcFromList active_cmd_obj
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  set cmd_name $command::($active_cmd_obj,name)
  foreach item $cmd_blk_list {
   if {[string match $cmd_name $command::($item,name)]} {
    set cmd_id $item
    break
   }
  }
  set ind [lsearch $cmd_blk_list $cmd_id]
  set cmd_blk_list [lreplace $cmd_blk_list $ind $ind]
  set Post::($post_object,cmd_blk_list) $cmd_blk_list
 }

#=======================================================================
proc __isv_cmd_CutACmdBlock { page_obj} {
  global mom_sim_arr post_object mom_sys_arr
  if { ![info exists Page::($page_obj,active_cmd_obj)] } {
   return
  }
  set active_cmd_obj $Page::($page_obj,active_cmd_obj)
  if { ![UI_PB_cmd_SaveCmdProc $page_obj not_verify] } {
   return
  }
  UI_PB_cmd_DeleteCmdProc $page_obj
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  if { $Page::($page_obj,double_click_flag) } {
   set ent $Page::($page_obj,rename_index)
   set obj_index [string range $ent 2 end]
   set Page::($page_obj,double_click_flag) 0
   unset Page::($page_obj,rename_index)
   grab release [grab current]
  } else \
  {
   set ent [$HLIST info selection]
   set obj_index [string range $ent 2 end]
  }
  set Page::($page_obj,buff_cmd_obj) $active_cmd_obj
  set cmd_name $command::($active_cmd_obj,name)
  UI_PB_debug_ForceMsg "\n obj_index ($cmd_name $active_cmd_obj) to be cut : $obj_index \n"
  __isv_CommandCutObject active_cmd_obj
  unset Page::($page_obj,active_cmd_obj)
  global mom_sys_arr mom_sim_arr
  if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
   set ind [lsearch $mom_sim_arr(\$mom_sim_vnc_com_list) $cmd_name]
   set length [llength $mom_sim_arr(\$mom_sim_vnc_com_list)]
   set mom_sim_arr(\$mom_sim_vnc_com_list) [lreplace $mom_sim_arr(\$mom_sim_vnc_com_list) $ind $ind]
   set ind [lsearch $mom_sim_arr(\$mom_sim_user_com_list) $cmd_name]
   if { $ind >= 0 } {
    set mom_sim_arr(\$mom_sim_user_com_list) [lreplace $mom_sim_arr(\$mom_sim_user_com_list) $ind $ind]
   }
   } else {
   set ind [lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $cmd_name]
   set length [llength $mom_sim_arr(\$mom_sim_sub_vnc_list)]
   set mom_sim_arr(\$mom_sim_sub_vnc_list) [lreplace $mom_sim_arr(\$mom_sim_sub_vnc_list) $ind $ind]
   set ind [lsearch $mom_sim_arr(\$mom_sim_sub_user_list) $cmd_name]
   if { $ind >= 0 } {
    set mom_sim_arr(\$mom_sim_sub_user_list) [lreplace $mom_sim_arr(\$mom_sim_sub_user_list) $ind $ind]
   }
  }
  unset Page::($page_obj,selected_index)
  incr obj_index -1
  UI_PB_debug_ForceMsg "\n obj_index to be selected : $obj_index \n"
  set ent "0.$obj_index"
  set cmd_name  [lindex [$HLIST entryconfigure $ent -text] end]
  if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
   set obj_index [lsearch $mom_sim_arr(\$mom_sim_vnc_com_list) $cmd_name]
   } else {
   set obj_index [lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $cmd_name]
  }
  if { $obj_index == $length } {
   incr obj_index -1
  }
  set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
  __isv_DisplayCodeNameList page_obj obj_index
  __isv_CodeItemSelection $page_obj 0.$obj_index
  set left_pane_id $Page::($page_obj,left_pane_id)
  $left_pane_id.f.pas config -state normal
 }

#=======================================================================
proc __isv_cmd_PasteACmdBlock { page_obj } {
  global mom_sys_arr mom_sim_arr post_object rest_mom_sim_arr
  if { ![info exists Page::($page_obj,buff_cmd_obj)] } {
   return
  }
  if { [info exists Page::($page_obj,rename_index)] } {
   if { [UI_PB_cmd_UpdateCmdEntry $page_obj $Page::($page_obj,rename_index)] == "UI_PB_ERROR" } {
    return
   }
  }
  if { $Page::($page_obj,double_click_flag) } {
   set Page::($page_obj,double_click_flag) 0
   unset Page::($page_obj,rename_index)
  }
  UI_PB_debug_ForceMsg "\n selected_index before pasting : $Page::($page_obj,selected_index) \n"
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  set buff_cmd_obj $Page::($page_obj,buff_cmd_obj)
  set obj_index [lsearch $cmd_blk_list $buff_cmd_obj]
  UI_PB_debug_ForceMsg "\n obj_index of buff_cmd_obj : $obj_index $buff_cmd_obj\n"
  UI_PB_debug_ForceMsg "\n cmd_blk_list : $cmd_blk_list \n"
  PB_int_CmdBlockPasteObject buff_cmd_obj obj_index
  UI_PB_debug_ForceMsg "\n obj_index newly created to be pasted : $obj_index  $buff_cmd_obj \n"
  set cmd_name $command::($buff_cmd_obj,name)
  if { [info exists Page::($page_obj,active_cmd_obj)] &&  \
   ![string match "" $Page::($page_obj,active_cmd_obj)] } {
   set act_cmd_obj $Page::($page_obj,active_cmd_obj)
   set act_name $command::($act_cmd_obj,name)
   if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
    set obj_index [expr [lsearch $mom_sim_arr(\$mom_sim_vnc_com_list) $act_name] + 1]
    } else {
    set obj_index [expr [lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $act_name] + 1]
   }
   } else {
   set obj_index 0
  }
  if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
   set mom_sim_arr(\$mom_sim_vnc_com_list) \
   [linsert $mom_sim_arr(\$mom_sim_vnc_com_list) $obj_index $cmd_name]
   lappend mom_sim_arr(\$mom_sim_user_com_list) $cmd_name
   PB_com_unset_var ::isv_main_buff_cmd_obj
   } else {
   set mom_sim_arr(\$mom_sim_sub_vnc_list) \
   [linsert $mom_sim_arr(\$mom_sim_sub_vnc_list) $obj_index $cmd_name]
   lappend mom_sim_arr(\$mom_sim_sub_user_list) $cmd_name
   PB_com_unset_var ::isv_sub_buff_cmd_obj
  }
  set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
  unset Page::($page_obj,buff_cmd_obj)
  unset Page::($page_obj,selected_index) ;#"0.$obj_index"
  UI_PB_debug_ForceMsg "\n obj_index pasted : $obj_index \n"
  __isv_DisplayCodeNameList page_obj obj_index
  __isv_CodeItemSelection $page_obj 0.$obj_index
 }

#=======================================================================
proc __isv_ImportCmdOk_CB { win page_obj } {
  global post_object
  global gPB
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set out_cmd_proc_list ""
  set out_oth_proc_list ""
  set item_selected 0
  foreach ent [$HLIST info children] {
   set sta [string tolower [$tree getstatus $ent]]
   if [string match "on" $sta] {
    incr item_selected
    set proc_name [lindex [$HLIST entryconfigure $ent -text] end]
    if { $proc_name == "" } {
     $tree setstatus $ent off
     } else {
     if [string match "PB_CMD_vnc__*" $proc_name] {
      lappend out_cmd_proc_list $proc_name
      } else {
      lappend out_oth_proc_list $proc_name
     }
    }
   }
  }
  if { $item_selected == 0 } {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
   -icon warning -title "$gPB(cust_cmd,import,warning,title)" \
   -message "$gPB(cust_cmd,import,warning,msg)"
   return
  }
  array set cmd_proc_data $Page::($page_obj,cmd_proc_data)
  foreach cmd $out_cmd_proc_list {
   set cmd_obj_attr(0) $cmd
   set cmd_obj_attr(1) $cmd_proc_data($cmd,proc)
   set cmd_obj_attr(2) $cmd_proc_data($cmd,blk_list)
   set cmd_obj_attr(3) $cmd_proc_data($cmd,add_list)
   set cmd_obj_attr(4) $cmd_proc_data($cmd,fmt_list)
   __cmd_CreateCommand cmd_obj_attr cmd
  }
  Post::GetObjList $post_object command cmd_obj_list
  PB_com_SortObjectsByNames cmd_obj_list
  Post::SetObjListasAttr $post_object cmd_obj_list
  foreach cmd_obj $cmd_obj_list {
   PB_int_UpdateCommandAdd cmd_obj
  }
  set vnc_page_obj [lindex $Book::($gPB(book),page_obj_list) 4]
  set book_obj $Page::($vnc_page_obj,book_obj)
  set cod_page_obj [lindex $Book::($book_obj,page_obj_list) 1]
  set cmd_obj $Page::($cod_page_obj,active_cmd_obj)
  command::readvalue $cmd_obj cmd_obj_attr
  UI_PB_cmd_DeleteCmdProc $cod_page_obj
  set Page::($cod_page_obj,selected_index) -1
  if [info exists Page::($cod_page_obj,active_cmd_obj)] {
   unset Page::($cod_page_obj,active_cmd_obj)
  }
  UI_PB_isv_DeleteTabAttr book_obj
  set Book::($book_obj,current_tab) 1
  UI_PB_isv_CreateTabAttr book_obj
  unset gPB(custom_command_import_page)
  PB_com_DeleteObject $page_obj
  destroy $win
 }

#=======================================================================
proc __isv_AddComponentsLeftPane {PAGE_OBJ} {
  upvar $PAGE_OBJ page_obj
  global gPB
  global paOption
  set lpane $Page::($page_obj,left_pane_id)
  set frm_bg $paOption(name_bg)
  set top_frm [frame $lpane.top -bg $frm_bg -relief sunken -bd 1]
  set left_pane [frame $lpane.bot]
  set Page::($page_obj,left_pane_id) $left_pane
  pack $top_frm -side top -fill x -padx 7 -pady 2
  pack $left_pane -side bottom -fill both -expand yes
  set frm [frame $top_frm.frm -bg $frm_bg]
  pack $frm -fill x -padx 1
  set imp [button $frm.imp -text "$gPB(cust_cmd,import,Label)" \
  -command "_cmd_ImportCustCmdFile $page_obj vnc" \
  -bg $paOption(app_butt_bg) -state normal]
  set exp [button $frm.exp -text "$gPB(cust_cmd,export,Label)" \
  -command "_cmd_ExportCustCmdFile $page_obj vnc" \
  -bg $paOption(app_butt_bg) -state normal]
  pack $imp $exp -side left -fill x -expand yes -padx 1 -pady 2
  set but [frame $left_pane.f]
  set new [button $but.new -text "$gPB(tree,create,Label)" \
  -bg $paOption(app_butt_bg) -state normal \
  -command "__isv_cmd_CreateACmdBlock $page_obj"]
  set del [button $but.del -text "$gPB(tree,cut,Label)" \
  -bg $paOption(app_butt_bg) -state normal \
  -command "__isv_cmd_CutACmdBlock $page_obj"]
  set pas [button $but.pas -text "$gPB(tree,paste,Label)" \
  -bg $paOption(app_butt_bg) -state disabled \
  -command "__isv_cmd_PasteACmdBlock $page_obj"]
  pack $new $del $pas -side left -fill x -expand yes
  pack $but -side top -fill x -padx 7
  set gPB(c_help,$new)   "tree,create"
  set gPB(c_help,$del)   "tree,cut"
  set gPB(c_help,$pas)   "tree,paste"
  set gPB(c_help,$imp)   "cust_cmd,import"
  set gPB(c_help,$exp)   "cust_cmd,export"
 }

#=======================================================================
proc __isv_GetCommandDisplayList { DISP_COM_LIST } {
  upvar $DISP_COM_LIST disp_com_list
  global mom_sim_arr post_object mom_sys_arr
  Post::GetObjList $post_object command cmd_blk_list
  if { [string match "Subordinate" $mom_sys_arr(VNC_Mode)] } {
   set sub_list [list "PB_CMD_vnc__set_nc_definitions" \
   "PB_CMD_vnc__sim_other_devices" \
   "PB_CMD_vnc____map_machine_tool_axes" \
   "PB_CMD_vnc__process_nc_block"]
   set old_sub_list [list "PB_CMD_vnc__config_nc_definitions" \
   "PB_CMD_vnc____config_machine_tool_axes"]
   foreach old_cmd $old_sub_list {
    if { [llength [info commands $old_cmd]] } {
     lappend sub_list $old_cmd
    }
   }
   foreach sub $sub_list {
    if { [lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $sub] < 0 } {
     lappend mom_sim_arr(\$mom_sim_sub_vnc_list) $sub
    }
   }
   lappend mom_sim_arr(\$mom_sim_sub_vnc_list) "PB_CMD_vnc____config_machine_tool_axes"
   set mom_sim_arr(\$mom_sim_sub_vnc_list) [ltidy $mom_sim_arr(\$mom_sim_sub_vnc_list)]
   set temp [list]
   foreach cmd_name $mom_sim_arr(\$mom_sim_sub_vnc_list) {
    if { ![catch {PB_com_RetObjFrmName cmd_name cmd_blk_list cmd_obj}] } {
     if { $cmd_obj > 0 } {
      lappend disp_com_list $cmd_obj
      } else {
      lappend temp $cmd_name
     }
     } else {
     continue
    }
   }
   if { [llength $temp] > 0 } {
    foreach sub_item $temp {
     set ind [lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $sub_item]
     set mom_sim_arr(\$mom_sim_sub_vnc_list) [lreplace $mom_sim_arr(\$mom_sim_sub_vnc_list) $ind $ind]
    }
   }
   } else {
   if { ![llength $mom_sim_arr(\$mom_sim_vnc_com_list)] } {
    __isv_ImportExistedVNCCommands cmd_blk_list
    } elseif { [llength $mom_sim_arr(\$mom_sim_vnc_com_list)] < 5 } {
    __isv_ImportExistedVNCCommands cmd_blk_list
    set mom_sim_arr(\$mom_sim_vnc_com_list) [ltidy $mom_sim_arr(\$mom_sim_vnc_com_list)]
    } else {
    __isv_ImportExistedVNCCommands cmd_blk_list
   }
   lappend mom_sim_arr(\$mom_sim_vnc_com_list) "PB_CMD_vnc____config_machine_tool_axes"
   set mom_sim_arr(\$mom_sim_vnc_com_list) [ltidy $mom_sim_arr(\$mom_sim_vnc_com_list)]
   foreach cmd_name $mom_sim_arr(\$mom_sim_vnc_com_list) {
    PB_com_RetObjFrmName cmd_name cmd_blk_list cmd_obj
    lappend disp_com_list $cmd_obj
   }
  }
  set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
 }

#=======================================================================
proc __isv_ImportExistedVNCCommands { CMD_BLK_LIST } {
  upvar $CMD_BLK_LIST cmd_blk_list
  global mom_sim_arr
  foreach cmd $cmd_blk_list {
   set cmd_name $command::($cmd,name)
   if { [string match "PB_CMD_vnc__*" $cmd_name] } {
    if { [lsearch $mom_sim_arr(\$mom_sim_vnc_com_list) $cmd_name] < 0 } {
     if { ![info exists mom_sim_arr(\$mom_sim_sub_vnc_list)] } {
      lappend mom_sim_arr(\$mom_sim_vnc_com_list) $cmd_name
      } elseif { [lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $cmd_name] < 0 } {
      lappend mom_sim_arr(\$mom_sim_vnc_com_list) $cmd_name
      } elseif { [string match "PB_CMD_vnc____map_machine_tool_axes" $cmd_name] } {
      lappend mom_sim_arr(\$mom_sim_vnc_com_list) $cmd_name
     }
    }
   }
  }
 }

#=======================================================================
proc __isv_DisplayCodeNameList { PAGE_OBJ OBJ_INDEX } {
  upvar $PAGE_OBJ page_obj
  upvar $OBJ_INDEX obj_index
  global paOption tixOption
  global mom_sys_arr mom_sim_arr
  global post_object
  global gPB
  if { [string match "" $obj_index ] } {
   set obj_index 0
  }
  if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
   set sel_name [lindex $mom_sim_arr(\$mom_sim_vnc_com_list) $obj_index]
   } else {
   set sel_name [lindex $mom_sim_arr(\$mom_sim_sub_vnc_list) $obj_index]
  }
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  $HLIST config -bg $paOption(tree_bg)
  uplevel #0 set TRANSPARENT_GIF_COLOR [$HLIST cget -bg]
  $HLIST delete all
  $HLIST add 0 -itemtype imagetext -text "" -image $paOption(folder) -state disabled
  set file  [tix getimage pb_vnc_sys]
  set file1 [tix getimage pb_vnc_user]
  set file2 [tix getimage pb_cmd]
  if $mom_sys_arr(Output_VNC) {
   global tix_version
   switch $tix_version {
    8.4 {
     set style [tixDisplayStyle imagetext \
     -bg $paOption(tree_bg) -padx 4 -pady 1 -font $tixOption(font) \
     -selectforeground blue -selectbackground lightblue]
    }
    4.1 {
     set gPB(font_style_normal) [tixDisplayStyle imagetext \
     -bg $paOption(tree_bg) -padx 4 -pady 1 -font $tixOption(font) \
     -selectforeground blue]
     set style $gPB(font_style_normal)
    }
   }
   } else {
   set style [tixDisplayStyle imagetext \
   -fg $paOption(tree_disabled_fg) \
   -bg $paOption(tree_bg) \
   -padx 4 -pady 1 -font $tixOption(font)]
  }
  set disp_com_list [list]
  __isv_GetCommandDisplayList disp_com_list
  set cmd_name_list [list]
  foreach cmd_obj $disp_com_list {
   if {[info exists command::($cmd_obj,name)]} {
    lappend cmd_name_list $command::($cmd_obj,name)
   }
  }
  set no_blks [llength $cmd_name_list]
  set token_list $mom_sim_arr(\$mom_sim_pre_com_list)
  set token_cmd_list [list]
  foreach token $token_list {
   set item [join [split $token] "_"]
   set item "PB_CMD_vnc__$item"
   lappend token_cmd_list $item
  }
  if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
   set user_com_list $mom_sim_arr(\$mom_sim_user_com_list)
   } else {
   set user_com_list $mom_sim_arr(\$mom_sim_sub_user_list)
  }
  set cmd_name_list [lsort -ascii $cmd_name_list]
  if { $no_blks } {
   for { set count 0 } { $count < $no_blks } { incr count } {
    set cmd_name [lindex $cmd_name_list $count]
    set list_cmd 1
    global LicInfo
    if { [info exists LicInfo(user_right_limit)] && $LicInfo(user_right_limit) == "YES" } {
     set filter(Subordinate) [list PB_CMD_vnc____map_machine_tool_axes \
     PB_CMD_vnc__set_nc_definitions \
     PB_CMD_vnc__sim_other_devices \
     PB_CMD_vnc__process_nc_block]
     set filter(Standalone)  [list PB_CMD_vnc____map_machine_tool_axes \
     PB_CMD_vnc____set_nc_definitions \
     PB_CMD_vnc____sim_other_devices \
     PB_CMD_vnc__preprocess_nc_block \
     PB_CMD_vnc____process_nc_block \
     PB_CMD_vnc____ASSIGN_TURRET_POCKETS \
     PB_CMD_vnc__user_tool_change \
     PB_CMD_vnc__config_sync_dialog \
     PB_CMD_vnc__init_sync_manager \
     PB_CMD_vnc__mount_part \
     PB_CMD_vnc__customize_dialog \
     PB_CMD_vnc__load_vnc_file]
     set is_exists [lsearch $filter($mom_sys_arr(VNC_Mode)) $cmd_name]
     if { ($is_exists < 0) && ![string match "PB_CMD_vnc____*" $cmd_name] } {
      set list_cmd 0
     }
    }
    if $list_cmd {
     if {![info exists i_count] } {
      set i_count 0
      } else {
      incr i_count
     }
     if { [lsearch $token_cmd_list $cmd_name] >= 0 } {
      $HLIST add 0.$i_count -itemtype imagetext -text $cmd_name \
      -image $file1 -style $style
      if { [string match "$sel_name" $cmd_name] } {
       set obj_index $i_count
      }
      } elseif { [lsearch $user_com_list $cmd_name] >= 0 } {
      $HLIST add 0.$i_count -itemtype imagetext -text $cmd_name \
      -image $file2 -style $style
      if { [string match "$sel_name" $cmd_name] } {
       set obj_index $i_count
      }
      } else {
      $HLIST add 0.$i_count -itemtype imagetext -text $cmd_name \
      -image $file -style $style
     }
     if { [string match "$sel_name" $cmd_name] } {
      set obj_index $i_count
     }
    }
   }
  }
  if { $no_blks } {
   if { $obj_index >= $no_blks } {
    set obj_index [expr $no_blks - 1]
   }
   if [$HLIST info exists 0.$obj_index] {
    $HLIST selection set 0.$obj_index
    } elseif [$HLIST info exists 0.0] {
    $HLIST selection set 0.0
    } else {
    $HLIST selection set 0
   }
   } else {
   $HLIST selection clear
   $HLIST anchor clear
  }
 }

#=======================================================================
proc _isv_DisplayCmdBlkAttr  { PAGE_OBJ CMD_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $CMD_OBJ cmd_obj
  command::RestoreValue $cmd_obj
  set Page::($page_obj,active_cmd_obj) $cmd_obj
  __isv_DisplayProcData cmd_obj page_obj
 }

#=======================================================================
proc __isv_DisplayProcData {} {
  UI_PB_cmd_DisplayCmdProc page_obj cmd_obj
 }

#=======================================================================
proc __isv_CutSpecialCommand { cus_list y args } {
  global gPB post_object
  global isv_def_id
  global mom_sim_arr mom_sys_arr
  set page_obj $isv_def_id
  if { ![info exists Page::($page_obj,active_cmd_obj)] } \
  {
   return
  }
  set index [$cus_list nearest $y]
  if { $index == "" } {
   set title "$gPB(cust_cmd,error,title)"
   set err_msg "$gPB(isv,spec_command,sel_err,Msg)"
   tk_messageBox -parent [ UI_PB_com_AskActiveWindow ] \
   -type ok -icon error \
   -message "$err_msg" -title "$title"
   return
  }
  set display_name [$cus_list entrycget $index -text]
  set active_cmd_obj $Page::($page_obj,active_cmd_obj)
  if { $active_cmd_obj > 0 } {
   set cmd_name $command::($active_cmd_obj,name)
   set Page::($page_obj,buff_cmd_obj) $active_cmd_obj
   Post::GetObjList $post_object command all_cmd_list
   set ind [lsearch $all_cmd_list $active_cmd_obj]
   set all_cmd_list [lreplace $all_cmd_list $ind $ind]
   Post::SetObjListasAttr $post_object all_cmd_list
   array set vnc_desc_arr $Post::($post_object,mom_vnc_desc_list)
   if { [info exists vnc_desc_arr($cmd_name,desc)] } {
    unset vnc_desc_arr($cmd_name,desc)
    set Post::($post_object,mom_vnc_desc_list) [array get vnc_desc_arr]
   }
   if { [string match "Subordinate" $mom_sys_arr(VNC_Mode)] } {
    set ind [lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $cmd_name]
    set mom_sim_arr(\$mom_sim_sub_vnc_list) [lreplace $mom_sim_arr(\$mom_sim_sub_vnc_list) $ind $ind]
    set ind [lsearch $mom_sim_arr(\$mom_sim_sub_user_list) $cmd_name]
    set mom_sim_arr(\$mom_sim_sub_user_list) [lreplace $mom_sim_arr(\$mom_sim_sub_user_list) $ind $ind]
    set ind [lsearch $mom_sim_arr(\$mom_sim_sub_precod_list) $cmd_name]
    set mom_sim_arr(\$mom_sim_sub_precod_list)  \
    [lreplace $mom_sim_arr(\$mom_sim_sub_precod_list) $ind $ind]
    } else {
    set ind [lsearch $mom_sim_arr(\$mom_sim_vnc_com_list) $cmd_name]
    set mom_sim_arr(\$mom_sim_vnc_com_list) [lreplace $mom_sim_arr(\$mom_sim_vnc_com_list) $ind $ind]
    set ind [lsearch $mom_sim_arr(\$mom_sim_user_com_list) $cmd_name]
    set mom_sim_arr(\$mom_sim_user_com_list) [lreplace $mom_sim_arr(\$mom_sim_user_com_list) $ind $ind]
    set ind [lsearch $mom_sim_arr(\$mom_sim_precod_list) $display_name]
    set mom_sim_arr(\$mom_sim_precod_list)  \
    [lreplace $mom_sim_arr(\$mom_sim_precod_list) $ind $ind]
   }
  }
  set ind [lsearch $mom_sim_arr(\$mom_sim_pre_com_list) $display_name]
  set mom_sim_arr(\$mom_sim_pre_com_list)  \
  [lreplace $mom_sim_arr(\$mom_sim_pre_com_list) $ind $ind]
  set fc [$cus_list info next $index]
  set pc [$cus_list info prev $index]
  set index_var "gPB(pre_list,index)"
  if { ![string match "" $fc] } {
   set $index_var $index
   } elseif { ![string match "" $pc] } {
   set $index_var $pc
   } else {
   set $index_var ""
  }
  set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
  __isv_RecreateLeftSpec
 }

#=======================================================================
proc __isv_PasteSpecialCommand { cus_list y args } {
  global gPB post_object
  global isv_def_id
  global mom_sim_arr mom_sys_arr
  set page_obj $isv_def_id
  if { ![info exists Page::($page_obj,buff_cmd_obj)] } \
  {
   return
  }
  set paste_cmd_obj $Page::($page_obj,buff_cmd_obj)
  set paste_cmd_name $command::($paste_cmd_obj,name)
  set paste_cmd_name_tail [string range $paste_cmd_name 12 end]
  set active_cmd_obj $Page::($page_obj,active_cmd_obj)
  if { [info exists command::($active_cmd_obj,name)] } {
   set active_cmd_name $command::($active_cmd_obj,name)
   } else {
   set active_cmd_name ""
  }
  set index [$cus_list nearest $y]
  if { $index == ""} {
   set title "$gPB(cust_cmd,error,title)"
   set err_msg "$gPB(isv,spec_command,sel_err,Msg)"
   if 0 {
    tk_messageBox -parent [ UI_PB_com_AskActiveWindow ] \
    -type ok -icon error \
    -message "$err_msg" -title "$title"
    return
   }
   set display_name ""
   } else {
   set display_name [$cus_list entrycget $index -text]
  }
  Post::GetObjList $post_object command all_cmd_list
  set count [llength $all_cmd_list]
  if { $count } \
  {
   PB_com_RetObjFrmName paste_cmd_name all_cmd_list ret_code
   if { $ret_code } \
   {
    unset Page::($page_obj,buff_cmd_obj)
    return [tk_messageBox -type ok -icon error\
    -message "$gPB(msg,block_format_command,paste_err)"]
   }
  }
  lappend all_cmd_list $paste_cmd_obj
  Post::SetObjListasAttr $post_object all_cmd_list
  array set vnc_desc_arr $Post::($post_object,mom_vnc_desc_list)
  if { [info exists command::($paste_cmd_obj,description)] } {
   set vnc_desc_arr($paste_cmd_name,desc) $command::($paste_cmd_obj,description)
   set Post::($post_object,mom_vnc_desc_list) [array get vnc_desc_arr]
  }
  if { [string match "Subordinate" $mom_sys_arr(VNC_Mode)] } {
   set ind [lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $active_cmd_name]
   set mom_sim_arr(\$mom_sim_sub_vnc_list) [linsert $mom_sim_arr(\$mom_sim_sub_vnc_list) [expr $ind + 1] $paste_cmd_name]
   set ind [lsearch $mom_sim_arr(\$mom_sim_sub_user_list) $active_cmd_name]
   set mom_sim_arr(\$mom_sim_sub_user_list) [linsert $mom_sim_arr(\$mom_sim_sub_user_list) [expr $ind + 1] $paste_cmd_name]
   set ind [lsearch $mom_sim_arr(\$mom_sim_sub_precod_list) $display_name]
   set mom_sim_arr(\$mom_sim_sub_precod_list)  \
   [linsert $mom_sim_arr(\$mom_sim_sub_precod_list) [expr $ind + 1] $paste_cmd_name_tail]
   } else {
   set ind [lsearch $mom_sim_arr(\$mom_sim_vnc_com_list) $active_cmd_name]
   set mom_sim_arr(\$mom_sim_vnc_com_list) [linsert $mom_sim_arr(\$mom_sim_vnc_com_list) [expr $ind + 1] $paste_cmd_name]
   set ind [lsearch $mom_sim_arr(\$mom_sim_user_com_list) $active_cmd_name]
   set mom_sim_arr(\$mom_sim_user_com_list) [linsert $mom_sim_arr(\$mom_sim_user_com_list) [expr $ind + 1] $paste_cmd_name]
   set ind [lsearch $mom_sim_arr(\$mom_sim_precod_list) $display_name]
   set mom_sim_arr(\$mom_sim_precod_list)  \
   [linsert $mom_sim_arr(\$mom_sim_precod_list) [expr $ind + 1] $paste_cmd_name_tail]
  }
  set ind [lsearch $mom_sim_arr(\$mom_sim_pre_com_list) $display_name]
  set mom_sim_arr(\$mom_sim_pre_com_list)  \
  [linsert $mom_sim_arr(\$mom_sim_pre_com_list) [expr $ind + 1] $paste_cmd_name_tail]
  set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
  set gPB(pre_list,index) [lsearch $mom_sim_arr(\$mom_sim_pre_com_list) $paste_cmd_name_tail]
  unset Page::($page_obj,buff_cmd_obj)
  set Page::($page_obj,active_cmd_obj) $paste_cmd_obj
  __isv_RecreateLeftSpec
 }

#=======================================================================
proc __file_SelectAlterUnitPostFragment { args } {
  global gPB
  global env
  global tcl_platform
  global ListObjectAttr
  global mom_kin_var
  if { ![info exists ::env(SUB_POST)] || $::env(SUB_POST) == 0 } {
   return
  }
  if { $gPB(use_info) } \
  {
   UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
   return
  }
  UI_PB_file_GetWorkFileDir
  set file_name [file join $gPB(work_dir) $gPB(work_file)]
  if { ![file exists $file_name] } {
   set gPB(work_file) ""
  }
  __file_DisableWidgets
  if { ![info exists ListObjectAttr(alt_unit_post_name)] } {
   set ListObjectAttr(alt_unit_post_name) ""
  }
  set gPB(alt_unit_post_name) ""
  if {$tcl_platform(platform) == "unix"} \
  {
   UI_PB_file_SelectFile_unx PUI gPB(alt_unit_post_name) open
   } elseif {$tcl_platform(platform) == "windows"} \
  {
   UI_PB_file_SelectFile_win PUI gPB(alt_unit_post_name) open
   __file_EnableWidgets
  }
  if { [string compare $ListObjectAttr(alt_unit_post_name) [file tail $gPB(alt_unit_post_name)]] == 0 } {
   PB_com_unset_var gPB(is_alt_unit_sub_post)
   return
  }
  if { $gPB(alt_unit_post_name) != "" } {
   set gPB(is_alt_unit_sub_post) 0
   set gPB(alt_unit_post_name) [string trim $gPB(alt_unit_post_name) \"]
   PB_file_GetPostAttr $gPB(alt_unit_post_name) machine_type axis_option post_unit
   if { ![string compare "IN" $mom_kin_var(\$mom_kin_output_unit)] } {
    set pat "*__MM.pui"
    } else {
    set pat "*__IN.pui"
   }
   if { $gPB(is_alt_unit_sub_post) } {
    if { ![string match $pat $gPB(alt_unit_post_name)] } {
     set gPB(is_alt_unit_sub_post) 0
     set msg $gPB(listing,alt_unit,warning_2,msg)
    }
    } else {
    set msg $gPB(listing,alt_unit,warning_1,msg)
   }
   if { $gPB(is_alt_unit_sub_post) == 0 } {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -icon warning \
    -message "$msg"
    PB_com_unset_var gPB(is_alt_unit_sub_post)
    PB_com_unset_var gPB(is_sub_post)
    unset gPB(alt_unit_post_name)
    __file_SelectAlterUnitPostFragment
    } else {
    set ListObjectAttr(alt_unit_post_name) [file tail $gPB(alt_unit_post_name)]
    unset gPB(alt_unit_post_name)
    PB_com_unset_var gPB(is_alt_unit_sub_post)
    PB_com_unset_var gPB(is_sub_post)
   }
  }
 }

#=======================================================================
proc __Switch_AlternateUnitPostFragement { } {
  global post_object
  global mom_kin_var
  global ListObjectAttr
  global gPB
  if { ![info exists ::env(SUB_POST)] || $::env(SUB_POST) == 0 } {
   return
  }
  if { ![info exists gPB(pre_use_default_unit_fragment)] } {
   if { $ListObjectAttr(use_default_unit_fragment) } {
    set gPB(pre_use_default_unit_fragment) 0
    } else {
    set gPB(pre_use_default_unit_fragment) 1
   }
  }
  set widget $gPB(alt_unit_fragment_wid)
  set tmp_alt_unit_post_name [file rootname $Post::($post_object,out_pui_file)]
  if { ![string compare "IN" $mom_kin_var(\$mom_kin_output_unit)] } {
   append tmp_alt_unit_post_name "__MM.pui"
   } else {
   append tmp_alt_unit_post_name "__IN.pui"
  }
  if { ![string compare "" $ListObjectAttr(use_default_unit_fragment)] } {
   set ListObjectAttr(use_default_unit_fragment) 1
  }
  if { $ListObjectAttr(use_default_unit_fragment) } {
   if { [info exists ListObjectAttr(alt_unit_post_name)] } {
    if [catch {info level -1} res] {
     if { $gPB(pre_use_default_unit_fragment) } {
      set gPB(selected_alt_unit_post_name) $ListObjectAttr(alt_unit_post_name)
     }
    }
   }
   set ListObjectAttr(alt_unit_post_name) $tmp_alt_unit_post_name
   $widget.but configure -state disabled
   set gPB(pre_use_default_unit_fragment) 0
   } else {
   if [catch { info level -1 } res] {
    set retain_org_name 1
    } else {
    set retain_org_name 0
   }
   if { $retain_org_name } {
    if { [info exists gPB(selected_alt_unit_post_name)] } {
     set ListObjectAttr(alt_unit_post_name) $gPB(selected_alt_unit_post_name)
     } else {
     set ListObjectAttr(alt_unit_post_name) ""
    }
   }
   if { ![info exists ListObjectAttr(alt_unit_post_name)] } {
    set ListObjectAttr(alt_unit_post_name) ""
   }
   $widget.but configure -state normal
   set gPB(selected_alt_unit_post_name) $ListObjectAttr(alt_unit_post_name)
   set gPB(pre_use_default_unit_fragment) 1
  }
 }
