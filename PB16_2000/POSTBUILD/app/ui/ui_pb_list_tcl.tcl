#13

#=======================================================================
proc UI_PB_List { book_id list_page_obj } {
  global tixOption
  set Page::($list_page_obj,page_id) [$book_id subwidget \
  $Page::($list_page_obj,page_name)]
  UI_PB_list_AddListPage list_page_obj
 }

#=======================================================================
proc UI_PB_list_AddListPage { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gPB
  global tixOption
  global paOption
  global ListObjectAttr
  set w $Page::($page_obj,page_id)
  set ff [frame $w.ff -relief sunken -bd 1]
  pack $ff -side top -expand yes -fill both -padx 5
  set f [frame $ff.f]
  pack $f -side top -pady 30
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_list_DefListObjAttr $page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_list_RestoreListObjAttr $page_obj"
  UI_PB_com_CreateButtonBox $w label_list cb_arr
  set list [frame $f.1 -relief solid -bd 1]
  set g1   [tixLabelFrame $f.2 -label "$gPB(listing,Label)"]
  set g2   [frame $f.3 ]
  set g3   [frame $f.4 ]
  set g4   [frame $f.5 ]
  checkbutton $list.lisflg -text "$gPB(listing,gen,Label)" -fg white \
  -bg royalBlue\
  -variable ListObjectAttr(listfile) \
  -relief flat -font $tixOption(bold_font) \
  -anchor w -padx 12 -pady 10
  set g1_frm [$g1 subwidget frame]
  set g1_left  [frame $g1_frm.left]
  set g1_right [frame $g1_frm.right]
  grid $g1_left -row 0 -column 0 -padx 5 -pady 5 -sticky nw
  grid $g1_right -row 0 -column 1 -padx 5 -pady 5 -sticky nw
  tixLabelFrame $g1_left.param -label "$gPB(listing,parms,Label)"
  tixLabelFrame $g1_right.fmt  -label "$gPB(listing,format,Label)"
  tixLabelFrame $g2.out  -label "$gPB(listing,output,Label)"
  tixLabelFrame $g3.head  -label "$gPB(listing,header,Label)"
  tixLabelFrame $g3.foot  -label "$gPB(listing,footer,Label)"
  tixLabelFrame $g4.body  -label "$gPB(listing,oper_info,Label)"
  tixLabelEntry $g1_right.lptext -label "$gPB(listing,extension,Label)" \
  -options {
   label.width 25
   label.anchor w
   entry.width 10
   entry.anchor e
   entry.textVariable ListObjectAttr(lpt_ext)
  }
  [$g1_right.lptext subwidget label] config -font $tixOption(font)
  pack $list.lisflg
  pack $g1_left.param
  pack $g1_right.lptext -side top -fill x -padx 10 -pady 15 -anchor w
  pack $g1_right.fmt -side bottom -pady 5
  pack $g2.out
  pack $g3.head -side top
  pack $g3.foot -side bottom
  pack $g4.body -fill both
  pack $list -padx 14 -pady 5 -anchor w
  pack $g1   -padx 10 -pady 5 -anchor nw
  pack $g2   -padx 10 -pady 20 -anchor w
  set f1 [$g1_left.param subwidget frame]
  set f2 [$g1_right.fmt   subwidget frame]
  set f3 [$g2.out  subwidget frame]
  set f4 [$g3.head  subwidget frame]
  set f5 [$g4.body  subwidget frame]
  set f6 [$g3.foot  subwidget frame]
  grid columnconfig $f 1 -minsize 180
  checkbutton $f1.x -text "$gPB(listing,parms,x,Label)" \
  -variable ListObjectAttr(x) \
  -relief flat -bd 2 -anchor w -padx 6 -width 30
  checkbutton $f1.y -text "$gPB(listing,parms,y,Label)" \
  -variable ListObjectAttr(y) \
  -relief flat -bd 2 -anchor w -padx 6 -width 30
  checkbutton $f1.z -text "$gPB(listing,parms,z,Label)" \
  -variable ListObjectAttr(z) \
  -relief flat -bd 2 -anchor w -padx 6 -width 30
  checkbutton $f1.4a -text "$gPB(listing,parms,4,Label)" \
  -variable ListObjectAttr(4axis) \
  -relief flat  -bd 2 -anchor w -padx 6 -width 30
  checkbutton $f1.5a -text "$gPB(listing,parms,5,Label)" \
  -variable ListObjectAttr(5axis) \
  -relief flat  -bd 2 -anchor w -padx 6 -width 30
  checkbutton $f1.fed -text "$gPB(listing,parms,feed,Label)" \
  -variable ListObjectAttr(feed) \
  -relief flat  -bd 2 -anchor w -padx 6 -width 30
  checkbutton $f1.spd -text "$gPB(listing,parms,speed,Label)" \
  -variable ListObjectAttr(speed) \
  -relief flat  -bd 2 -anchor w -padx 6 -width 30
  pack $f1.x $f1.y $f1.z $f1.4a $f1.5a $f1.fed $f1.spd -side top \
  -anchor w
  checkbutton $f2.hed -text "$gPB(listing,format,print_header,Label)" \
  -variable ListObjectAttr(head) \
  -relief flat  -bd 2 -anchor w -padx 6 -width 30
  tixLabelEntry $f2.row -label "$gPB(listing,format,length,Label)" \
  -options {
   label.width 25
   label.anchor w
   entry.width 10
   entry.anchor e
   entry.textVariable ListObjectAttr(lines)
  }
  [$f2.row subwidget label] config -font $tixOption(font)
  tixLabelEntry $f2.col -label "$gPB(listing,format,width,Label)" \
  -options {
   label.width 25
   label.anchor w
   entry.width 10
   entry.anchor e
   entry.textVariable ListObjectAttr(column)
  }
  [$f2.col subwidget label] config -font $tixOption(font)
  pack $f2.hed -side top
  pack $f2.row -side top -fill x -padx 10 -pady 5
  pack $f2.col -side top -fill x -padx 10 -pady 3
  checkbutton $f3.warn -text "$gPB(listing,output,warning,Label)" \
  -variable ListObjectAttr(warn) \
  -relief flat  -bd 2 -anchor w -padx 6 -width 30
  checkbutton $f3.rev -text "$gPB(listing,output,review,Label)" \
  -variable ListObjectAttr(review) \
  -relief flat  -bd 2 -anchor w -padx 6 -width 30
  checkbutton $f3.grp -text "$gPB(listing,output,group,Label)" \
  -variable ListObjectAttr(group) \
  -relief flat  -bd 2 -anchor w -padx 6 -width 30
  tixLabelEntry $f3.ptpext -label "$gPB(listing,nc_file,Label)" \
  -options {
   label.width 25
   label.anchor w
   entry.width 10
   entry.anchor e
   entry.textVariable ListObjectAttr(ncfile_ext)
  }
  [$f3.ptpext subwidget label] config -font $tixOption(font)
  pack $f3.grp -fill x -anchor w
  pack $f3.warn -fill x -anchor w
  pack $f3.rev -fill x -anchor w
  pack $f3.ptpext -fill x -anchor w -padx 10 -pady 5
  checkbutton $f4.oper -text "$gPB(listing,header,oper_list,Label)" \
  -variable ListObjectAttr(oper) \
  -relief flat  -bd 2 -anchor w -padx 6 -width 30
  checkbutton $f4.tool -text "$gPB(listing,header,tool_list,Label)" \
  -variable ListObjectAttr(tool) \
  -relief flat  -bd 2 -anchor w -padx 6 -width 30
  pack $f4.oper $f4.tool -side top -anchor w
  checkbutton $f5.strt -text "$gPB(listing,oper_info,parms,Label)" \
  -variable ListObjectAttr(start_path) \
  -relief flat  -bd 2 -anchor w -padx 6 -pady 6 -width 30
  checkbutton $f5.chng -text "$gPB(listing,oper_info,tool,Label)" \
  -variable ListObjectAttr(tool_chng) \
  -relief flat  -bd 2 -anchor w -padx 6 -pady 6 -width 30
  checkbutton $f5.time -text "$gPB(listing,oper_info,cut_time,,Label)" \
  -variable ListObjectAttr(oper_time) \
  -relief flat  -bd 2 -anchor w -padx 6 -pady 6 -width 30
  pack $f5.strt $f5.chng $f5.time -side top -anchor w
  checkbutton $f6.time -text "$gPB(listing,footer,cut_time,Label)" \
  -variable ListObjectAttr(setup_time) \
  -relief flat  -bd 2 -anchor w -padx 6 -width 30
  pack $f6.time -side top -anchor w
  set gPB(c_help,$list.lisflg) "listing,gen"
  set gPB(c_help,$f1.x)    "listing,parms,x"
  set gPB(c_help,$f1.y)    "listing,parms,y"
  set gPB(c_help,$f1.z)    "listing,parms,z"
  set gPB(c_help,$f1.4a)   "listing,parms,4"
  set gPB(c_help,$f1.5a)   "listing,parms,5"
  set gPB(c_help,$f1.fed)  "listing,parms,feed"
  set gPB(c_help,$f1.spd)  "listing,parms,speed"
  set gPB(c_help,[$g1_right.lptext subwidget entry]) "listing,extension"
  set gPB(c_help,$f2.hed)  "listing,format,print_header"
  set gPB(c_help,[$f2.row subwidget entry])  "listing,format,length"
  set gPB(c_help,[$f2.col subwidget entry])  "listing,format,width"
  set gPB(c_help,$f3.grp)    "listing,output,group"
  set gPB(c_help,$f3.warn)   "listing,output,warning"
  set gPB(c_help,$f3.rev)    "listing,output,review"
  set gPB(c_help,[$f3.ptpext subwidget entry]) "listing,nc_file"
 }

#=======================================================================
proc UI_PB_list_DefListObjAttr { page_obj } {
  global ListObjectAttr
  PB_int_DefListObjAttr ListObjectAttr
 }

#=======================================================================
proc UI_PB_list_RestoreListObjAttr { page_obj } {
  global ListObjectAttr
  PB_int_RestoreListObjAttr ListObjectAttr
 }

#=======================================================================
proc UI_PB_list_ApplyListObjAttr { page_obj } {
  global ListObjectAttr
  PB_int_ApplyListObjAttr ListObjectAttr
 }

#=======================================================================
proc UI_PB_lst__SetCheckButtonState {widget STATE} {
  upvar $STATE state
  switch $state\
  {
   0      {$widget config -state disabled}
   1      {$widget config -state normal}
  }
 }
