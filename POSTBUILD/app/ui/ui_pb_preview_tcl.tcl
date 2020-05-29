set gPB(check_box_status) none

#=======================================================================
proc UI_PB_Preview { book_id pre_page_obj } {
  global paOption
  global gPB
  set f [$book_id subwidget $Page::($pre_page_obj,page_name)]
  set w [tixNoteBook $f.nb -ipadx 5 -ipady 5]
  [$f.nb subwidget nbframe] config -tabpady 0
  set prev_book [new Book w]
  set Page::($pre_page_obj,book_obj) $prev_book
  if { ![PB_file_is_JE_POST_DEV] } {
   Book::CreatePage $prev_book eve "$gPB(event_handler,tab,Label)" "" \
   UI_PB_prv_EventHandler UI_PB_prv_EventTab
   } else {
   Book::CreatePage $prev_book eve "" "" "" ""
   $Book::($prev_book,book_id) pageconfigure eve -state disabled
  }
  Book::CreatePage $prev_book def "$gPB(definition,tab,Label)" "" \
  UI_PB_prv_Definition UI_PB_prv_DefTab
  if {$::env(PB_UDE_ENABLED) == 1} {
   Book::CreatePage $prev_book ude "$gPB(ude,prev,tab,Label)" "" \
   UI_PB_prv_Ude  UI_PB_prv_UdeTab
  }
  pack $f.nb -expand yes -fill both
  set Book::($prev_book,x_def_tab_img) 0
  set Book::($prev_book,current_tab) -1
  if { [PB_file_is_JE_POST_DEV] } {
   $Book::($prev_book,book_id) raise def
  }
 }

#=======================================================================
proc UI_PB_prv_EventHandler { book_id eve_page_obj } {
  global tixOption
  global paOption
  set Page::($eve_page_obj,page_id) [$book_id subwidget \
  $Page::($eve_page_obj,page_name)]
  Page::CreatePane $eve_page_obj
  Page::CreateCheckList $eve_page_obj
  __prv_CreateEvtHList eve_page_obj
  UI_PB_prv_CreateSecPaneElems eve_page_obj
  PB_int_GetEventProcsData event_proc_data
  set Page::($eve_page_obj,evt_proc_list) [array get event_proc_data]
 }

#=======================================================================
proc UI_PB_prv_CreateSecPaneElems { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global paOption
  global tixOption
  global gPB
  set sec_pane $Page::($page_obj,canvas_frame)
  set pane [tixPanedWindow $sec_pane.pane -orient vertical]
  pack $pane -fill both -expand yes
  set f1 [$pane add p1 -expand 1 -size 250]
  set f2 [$pane add p2 -expand 1 -size 250]
  $f1 config -relief flat
  $f2 config -relief flat
  set p1s [$pane subwidget p1]
  set p1_frame [frame $p1s.frm -relief sunken -bd 1]
  pack $p1_frame -padx 3 -pady 6 -fill both -expand yes
  set lla [label $p1_frame.la -text "$gPB(preview,new_code,Label)" -font $tixOption(bold_font) \
  -bg $paOption(title_bg) -fg $paOption(title_fg) -bd 2 -relief raised -anchor c]
  pack $lla -side top -fill x
  set lsw [tixScrolledText $p1_frame.lsw]
  [$lsw subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  [$lsw subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  pack $lsw -side bottom -expand yes -fill both
  set ltext [$lsw subwidget text]
  $ltext config -bg yellow \
  -font $tixOption(fixed_font) \
  -height 200 -wrap none -bd 5 -relief flat
  set p2s [$pane subwidget p2]
  set p2_frame [frame $p2s.frm -relief sunken -bd 1]
  pack $p2_frame -padx 3 -pady 6 -expand yes -fill both
  set rla [label $p2_frame.la -text "$gPB(preview,old_code,Label)" -font $tixOption(bold_font) \
  -bg $paOption(title_bg) -fg $paOption(title_fg) -bd 2 -relief raised -anchor c]
  pack $rla -side top -fill x
  set rsw [tixScrolledText $p2_frame.rsw]
  [$rsw subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  [$rsw subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  pack $rsw -side bottom -expand yes -fill both
  set rtext [$rsw subwidget text]
  $rtext config -bg lightGoldenRod1 -fg blue \
  -font $tixOption(fixed_font) \
  -height 200 -wrap none -bd 5 -relief flat
  set Page::($page_obj,ltext) $ltext
  set Page::($page_obj,rtext) $rtext
 }

#=======================================================================
proc __prv_CreateEvtHList { EVE_PAGE_OBJ } {
  upvar $EVE_PAGE_OBJ eve_page_obj
  global paOption
  global tixOption
  global gPB
  set tree $Page::($eve_page_obj,tree)
  set h [$tree subwidget hlist]
  $h delete all
  $h config -bg $paOption(tree_bg)
  set style  $gPB(font_style_bold)
  set style1 $gPB(font_style_normal)
  uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]
  set folder $paOption(folder)
  set seq  [tix getimage pb_sequence]
  set t 0
  $h add 0 -itemtype imagetext -text "" -image $folder -state disabled
  PB_int_RetSequenceObjs seq_obj_list
  foreach seq_obj $seq_obj_list \
  {
   sequence::readvalue $seq_obj seq_attr
   if { [PB_is_v3] >= 0 } {
    global machType
    if { [string match "Wire EDM" $machType] && \
     [string match "Cycles" $seq_attr(0)] } {
     continue
    }
   }
   if { [string match "Virtual NC Controller" $seq_attr(0)] } {
    continue
   }
   if { [string match "Virtual NC Controller" $seq_attr(0)] && \
    ![PB_is_v $gPB(VNC_release)] } {
    continue
   }
   switch $seq_attr(0) {
    "Program Start Sequence"   {
     set trans_name $gPB(prog,tree,prog_strt,Label)
    }
    "Operation Start Sequence" {
     set trans_name $gPB(prog,tree,oper_strt,Label)
    }
    "Machine Control"          {
     set trans_name $gPB(prog,tree,tool_path,mach_cnt,Label)
    }
    "Motions"                  {
     set trans_name $gPB(prog,tree,tool_path,motion,Label)
    }
    "Cycles"                   {
     set trans_name $gPB(prog,tree,tool_path,cycle,Label)
    }
    "Miscellaneous"            {
     set trans_name $gPB(prog,tree,misc,Label)
    }
    "Operation End Sequence"   {
     set trans_name $gPB(prog,tree,oper_end,Label)
    }
    "Program End Sequence"     {
     set trans_name $gPB(prog,tree,prog_end,Label)
    }
    "Linked Posts Sequence"    {
     set trans_name $gPB(prog,tree,linked_posts,Label)
    }
   }
   $h add 0.$t -itemtype imagetext -text $trans_name \
   -image $seq -style $style -state normal ;#<01-04-02 gsl>disabled
   if [string match "Virtual NC Controller" $seq_attr(0)] {
    __prv_AddVNCEvtHList $tree $t
    } else {
    set evt_obj_list $seq_attr(1)
    __prv_AddEvtHList $tree $t $evt_obj_list
    if 0 {
     set evt_indx 0
     foreach evt_obj $evt_obj_list \
     {
      set event_name $event::($evt_obj,event_name)
      if { [string compare $event_name "Inch Metric Mode"] == 0 || \
       [string compare $event_name "Feedrates"] == 0 || \
       [string compare $event_name "Opskip"] == 0 || \
      [string compare $event_name "Cycle Parameters"] == 0} \
      {
       incr evt_indx
       continue
      }
      $h add 0.$t.$evt_indx -itemtype imagetext -text $event_name \
      -style $style1
      $tree setstatus 0.$t.$evt_indx $gPB(check_box_status)
      incr evt_indx
     }
    }
   }
   incr t
  }
  $tree configure -browsecmd "UI_PB_prv_TclTreeSelection $eve_page_obj"
  $h selection set 0.0
  $h anchor set 0.0
  $tree autosetmode
  $tree setmode 0 none
 }

#=======================================================================
proc __prv_AddVNCEvtHList { tree t } {
  global gPB
  global post_object
  global mom_sys_arr
  set h [$tree subwidget hlist]
  set evt_obj_list $Post::($post_object,vnc_evt_obj_list)
  set style1 $gPB(font_style_normal)
  PB_int_RetAddressObjList add_obj_list
  $h delete offsprings 0.$t
  set evt_indx 0
  UI_PB_debug_ForceMsg "****************************************"
  foreach evt_obj $evt_obj_list \
  {
   if [llength $event::($evt_obj,evt_elem_list)] {
    UI_PB_debug_ForceMsg "event name >$event::($evt_obj,event_name)<"
    foreach elem $event::($evt_obj,evt_elem_list) {
     UI_PB_debug_ForceMsg ">$event_element::($elem,evt_elem_name)<\
     >$event_element::($elem,block_obj)<"
     set blk_obj $event_element::($elem,block_obj)
     block::readvalue $blk_obj blk_attr
     UI_PB_debug_ForceMsg "   >$blk_attr(0)< >$blk_attr(1)< >$blk_attr(2)< >$blk_attr(3)<"
     foreach add_elem $blk_attr(2) {
      block_element::readvalue $add_elem elem_attr
      UI_PB_debug_ForceMsg "     >$elem_attr(0)< >$elem_attr(1)< >$elem_attr(2)<\
      >$elem_attr(3)<  >$elem_attr(4)<"
     }
     if 0 {
      set obj_attr(0) $block_element::($this,elem_add_obj)
      set obj_attr(1) $block_element::($this,elem_mom_variable)
      set obj_attr(2) $block_element::($this,elem_opt_nows_var)
      set obj_attr(3) $block_element::($this,elem_desc)
      set obj_attr(4) $block_element::($this,force)
     }
    }
   }
   set event_name $event::($evt_obj,event_name)
   set add_name [lindex $event_name 0]
   set add_var  [lindex $event_name 1]
   if [string match "*mom_sys*" $add_var] {
    set code [eval format %s $mom_sys_arr($add_var)]
    } else {
    set code $add_var
   }
   if { ![string match "__USER_" $add_name] } {
    PB_com_RetObjFrmName add_name add_obj_list add_obj
    PB_int_ApplyFormatAppText add_obj code
    set code "$address::($add_obj,add_leader)$code$address::($add_obj,add_trailer)"
   }
   $h add 0.$t.$evt_indx -itemtype imagetext -text $code -style $style1
   $tree setstatus 0.$t.$evt_indx $gPB(check_box_status)
   incr evt_indx
  }
 }

#=======================================================================
proc __prv_AddEvtHList { tree t evt_obj_list } {
  global gPB
  set h [$tree subwidget hlist]
  set style1 $gPB(font_style_normal)
  $h delete offsprings 0.$t
  set evt_indx 0
  foreach evt_obj $evt_obj_list \
  {
   if [string match {$*} $event::($evt_obj,event_label)] {
    set event_name $event::($evt_obj,event_name)
    } else {
    set event_name $event::($evt_obj,event_label)
   }
   if { [string compare $event_name "Inch Metric Mode"] == 0 || \
    [string compare $event_name "Feedrates"] == 0 || \
    [string compare $event_name "Opskip"] == 0 || \
   [string compare $event_name "Cycle Parameters"] == 0} \
   {
    incr evt_indx
    continue
   }
   set event_label $event::($evt_obj,event_label)
   set event_name [UI_PB_prv_TransEventName $event_name $event_label]
   $h add 0.$t.$evt_indx -itemtype imagetext -text $event_name \
   -style $style1
   $tree setstatus 0.$t.$evt_indx $gPB(check_box_status)
   incr evt_indx
  }
 }

#=======================================================================
proc UI_PB_prv_TransEventName { event_name event_label {type 0} } {
  global gPB
  if { $type == 0 } {
   switch -exact $event_name {
    "Start of Program" {
     set trans_name "$gPB(event,start_prog,name)"
    }
    "Start of Path" {
     set trans_name "$gPB(event,opr_start,start_path,name)"
    }
    "From Move" {
     set trans_name "$gPB(event,opr_start,from_move,name)"
    }
    "First Tool" {
     set trans_name "$gPB(event,opr_start,fst_tool,name)"
    }
    "Auto Tool Change" {
     set trans_name "$gPB(event,opr_start,auto_tc,name)"
    }
    "Manual Tool Change" {
     set trans_name "$gPB(event,opr_start,manual_tc,name)"
    }
    "Initial Move" {
     set trans_name "$gPB(event,opr_start,init_move,name)"
    }
    "First Move" {
     set trans_name "$gPB(event,opr_start,fst_move,name)"
    }
    "Approach Move" {
     set trans_name "$gPB(event,opr_start,appro_move,name)"
    }
    "Engage Move" {
     set trans_name "$gPB(event,opr_start,engage_move,name)"
    }
    "First Cut" {
     set trans_name "$gPB(event,opr_start,fst_cut,name)"
    }
    "First Linear Move" {
     set trans_name "$gPB(event,opr_start,fst_lin_move,name)"
    }
    "Tool Change" {
     set trans_name "$gPB(event,tool_change,name)"
    }
    "Length Compensation" {
     set trans_name "$gPB(event,length_compn,name)"
    }
    "Set Modes" {
     set trans_name "$gPB(event,set_modes,name)"
    }
    "Spindle RPM" {
     set trans_name "$gPB(event,spindle_rpm,name)"
    }
    "Spindle Off" {
     set trans_name "$gPB(event,spindle_off,name)"
    }
    "Coolant Off" {
     set trans_name "$gPB(event,coolant_off,name)"
    }
    "Coolant On" {
     set trans_name "$gPB(event,coolant_on,name)"
    }
    "Cutcom On" {
     set trans_name "$gPB(event,cutcom_on,name)"
    }
    "Cutcom Off" {
     set trans_name "$gPB(event,cutcom_off,name)"
    }
    "Delay" {
     set trans_name "$gPB(event,delay,name)"
    }
    "Opstop" {
     set trans_name "$gPB(event,opstop,name)"
    }
    "Auxfun" {
     set trans_name "$gPB(event,auxfun,name)"
    }
    "Prefun" {
     set trans_name "$gPB(event,prefun,name)"
    }
    "Load Tool" {
     set trans_name "$gPB(event,loadtool,name)"
    }
    "Stop" {
     set trans_name "$gPB(event,stop,name)"
    }
    "Tool Preselect" {
     set trans_name "$gPB(event,toolpreselect,name)"
    }
    "Linear Move" {
     set trans_name "$gPB(event,linear,name)"
    }
    "Circular Move" {
     set trans_name "$gPB(event,circular,name)"
    }
    "Rapid Move" {
     set trans_name "$gPB(event,rapid,name)"
    }
    "NURBS Move" {
     set trans_name "$gPB(event,nurbs,name)"
    }
    "Cycle Off" {
     set trans_name "$gPB(event,cycle,cycle_off,name)"
    }
    "Cycle Plane Change" {
     set trans_name "$gPB(event,cycle,plane_chng,name)"
    }
    "Drill" {
     set trans_name "$gPB(event,cycle,drill,name)"
    }
    "Drill Dwell" {
     set trans_name "$gPB(event,cycle,drill_dwell,name)"
    }
    "Drill Text" {
     set trans_name "$gPB(event,cycle,drill_text,name)"
    }
    "Drill Csink" {
     set trans_name "$gPB(event,cycle,drill_csink,name)"
    }
    "Drill Deep" {
     set trans_name "$gPB(event,cycle,drill_deep,name)"
    }
    "Drill Break Chip" {
     set trans_name "$gPB(event,cycle,drill_brk_chip,name)"
    }
    "Tap" {
     set trans_name "$gPB(event,cycle,tap,name)"
    }
    "Tap Float" {
     set trans_name "$gPB(event,cycle,tap_float,name)"
    }
    "Tap Deep" {
     set trans_name "$gPB(event,cycle,tap_deep,name)"
    }
    "Tap Break Chip" {
     set trans_name "$gPB(event,cycle,tap_break_chip,name)"
    }
    "Bore" {
     set trans_name "$gPB(event,cycle,bore,name)"
    }
    "Bore Dwell" {
     set trans_name "$gPB(event,cycle,bore_dwell,name)"
    }
    "Bore Drag" {
     set trans_name "$gPB(event,cycle,bore_drag,name)"
    }
    "Bore No Drag" {
     set trans_name "$gPB(event,cycle,bore_no_drag,name)"
    }
    "Bore Back" {
     set trans_name "$gPB(event,cycle,bore_back,name)"
    }
    "Bore Manual" {
     set trans_name "$gPB(event,cycle,bore_manual,name)"
    }
    "Bore Manual Dwell" {
     set trans_name "$gPB(event,cycle,bore_manual_dwell,name)"
    }
    "Peck Drill" {
     set trans_name "$gPB(event,cycle,peck_drill,name)"
    }
    "Break Chip" {
     set trans_name "$gPB(event,cycle,break_chip,name)"
    }
    "Retract Move" {
     set trans_name "$gPB(event,opr_end,ret_move,name)"
    }
    "Return Move" {
     set trans_name "$gPB(event,opr_end,rtn_move,name)"
    }
    "Gohome Move" {
     set trans_name "$gPB(event,opr_end,goh_move,name)"
    }
    "End of Path" {
     set trans_name "$gPB(event,opr_end,end_path,name)"
    }
    "End of Program" -
    "End Of Program" {
     set trans_name "$gPB(event,end_prog,name)"
    }
    "Lathe Thread" {
     set trans_name "$gPB(event,lathe,name)"
    }
    "Spindle CSS" {
     set trans_name "$gPB(event,spindle_css,name)"
    }
    "Start of Pass" {
     set trans_name "$gPB(event,opr_start,start_pass,name)"
    }
    "Cutcom Move" {
     set trans_name "$gPB(event,opr_start,cutcom_move,name)"
    }
    "Lead In Move" {
     set trans_name "$gPB(event,opr_start,lead_move,name)"
    }
    "Thread Wire" {
     set trans_name "$gPB(event,threadwire,name)"
    }
    "Cut Wire" {
     set trans_name "$gPB(event,cutwire,name)"
    }
    "Set Mode" {
     set trans_name "$gPB(event,set_modes,name)"
    }
    "Lead Out Move" {
     set trans_name "$gPB(event,opr_end,lead_move,name)"
    }
    "End of Pass" {
     set trans_name "$gPB(event,opr_end,end_pass,name)"
    }
    "Common Parameters" {
     set trans_name "$gPB(event,cycle,com_param,name)"
    }
    "Feedrates" {
     set trans_name "$gPB(event,feedrates,name)"
    }
    "Inch Metric Mode" {
     set trans_name "$gPB(event,inch_metric_mode,name)"
    }
    "Wire Guides" {
     set trans_name "$gPB(event,wireguides,name)"
    }
    "Feedrate Mode DPM" {
     set trans_name "$gPB(g_code,feedmode,dpm)"
    }
    "Feedrate Mode MMPM" {
     set trans_name "$gPB(g_code,feedmode_mm,pm)"
    }
    "Feedrate Mode MMPR" {
     set trans_name "$gPB(g_code,feedmode_mm,pr)"
    }
    "Delay (Rev)" {
     set trans_name "$gPB(g_code,delay_rev,name)"
    }
    default  {
     if { [string match "\$*" $event_label] } {
      set tmp_event_label [string trimleft $event_label "\$"]
      if [catch { set trans_name [set $tmp_event_label] }] {
       set trans_name $event_name
      }
      } else {
      set trans_name $event_label
     }
    }
   }
   } else {
   switch -exact $event_name {
    "Start of Program" {
     set trans_name {$gPB(event,start_prog,name)}
    }
    "Start of Path" {
     set trans_name {$gPB(event,opr_start,start_path,name)}
    }
    "From Move" {
     set trans_name {$gPB(event,opr_start,from_move,name)}
    }
    "First Tool" {
     set trans_name {$gPB(event,opr_start,fst_tool,name)}
    }
    "Auto Tool Change" {
     set trans_name {$gPB(event,opr_start,auto_tc,name)}
    }
    "Manual Tool Change" {
     set trans_name {$gPB(event,opr_start,manual_tc,name)}
    }
    "Initial Move" {
     set trans_name {$gPB(event,opr_start,init_move,name)}
    }
    "First Move" {
     set trans_name {$gPB(event,opr_start,fst_move,name)}
    }
    "Approach Move" {
     set trans_name {$gPB(event,opr_start,appro_move,name)}
    }
    "Engage Move" {
     set trans_name {$gPB(event,opr_start,engage_move,name)}
    }
    "First Cut" {
     set trans_name {$gPB(event,opr_start,fst_cut,name)}
    }
    "First Linear Move" {
     set trans_name {$gPB(event,opr_start,fst_lin_move,name)}
    }
    "Tool Change" {
     set trans_name {$gPB(event,tool_change,name)}
    }
    "Length Compensation" {
     set trans_name {$gPB(event,length_compn,name)}
    }
    "Set Modes" {
     set trans_name {$gPB(event,set_modes,name)}
    }
    "Spindle RPM" {
     set trans_name {$gPB(event,spindle_rpm,name)}
    }
    "Spindle Off" {
     set trans_name {$gPB(event,spindle_off,name)}
    }
    "Coolant Off" {
     set trans_name {$gPB(event,coolant_off,name)}
    }
    "Coolant On" {
     set trans_name {$gPB(event,coolant_on,name)}
    }
    "Cutcom On" {
     set trans_name {$gPB(event,cutcom_on,name)}
    }
    "Cutcom Off" {
     set trans_name {$gPB(event,cutcom_off,name)}
    }
    "Delay" {
     set trans_name {$gPB(event,delay,name)}
    }
    "Opstop" {
     set trans_name {$gPB(event,opstop,name)}
    }
    "Auxfun" {
     set trans_name {$gPB(event,auxfun,name)}
    }
    "Prefun" {
     set trans_name {$gPB(event,prefun,name)}
    }
    "Load Tool" {
     set trans_name {$gPB(event,loadtool,name)}
    }
    "Stop" {
     set trans_name {$gPB(event,stop,name)}
    }
    "Tool Preselect" {
     set trans_name {$gPB(event,toolpreselect,name)}
    }
    "Linear Move" {
     set trans_name {$gPB(event,linear,name)}
    }
    "Circular Move" {
     set trans_name {$gPB(event,circular,name)}
    }
    "Rapid Move" {
     set trans_name {$gPB(event,rapid,name)}
    }
    "NURBS Move" {
     set trans_name {$gPB(event,nurbs,name)}
    }
    "Cycle Off" {
     set trans_name {$gPB(event,cycle,cycle_off,name)}
    }
    "Cycle Plane Change" {
     set trans_name {$gPB(event,cycle,plane_chng,name)}
    }
    "Drill" {
     set trans_name {$gPB(event,cycle,drill,name)}
    }
    "Drill Dwell" {
     set trans_name {$gPB(event,cycle,drill_dwell,name)}
    }
    "Drill Text" {
     set trans_name {$gPB(event,cycle,drill_text,name)}
    }
    "Drill Csink" {
     set trans_name {$gPB(event,cycle,drill_csink,name)}
    }
    "Drill Deep" {
     set trans_name {$gPB(event,cycle,drill_deep,name)}
    }
    "Drill Break Chip" {
     set trans_name {$gPB(event,cycle,drill_brk_chip,name)}
    }
    "Tap" {
     set trans_name {$gPB(event,cycle,tap,name)}
    }
    "Bore" {
     set trans_name {$gPB(event,cycle,bore,name)}
    }
    "Bore Dwell" {
     set trans_name {$gPB(event,cycle,bore_dwell,name)}
    }
    "Bore Drag" {
     set trans_name {$gPB(event,cycle,bore_drag,name)}
    }
    "Bore No Drag" {
     set trans_name {$gPB(event,cycle,bore_no_drag,name)}
    }
    "Bore Back" {
     set trans_name {$gPB(event,cycle,bore_back,name)}
    }
    "Bore Manual" {
     set trans_name {$gPB(event,cycle,bore_manual,name)}
    }
    "Bore Manual Dwell" {
     set trans_name {$gPB(event,cycle,bore_manual_dwell,name)}
    }
    "Peck Drill" {
     set trans_name {$gPB(event,cycle,peck_drill,name)}
    }
    "Break Chip" {
     set trans_name {$gPB(event,cycle,break_chip,name)}
    }
    "Retract Move" {
     set trans_name {$gPB(event,opr_end,ret_move,name)}
    }
    "Return Move" {
     set trans_name {$gPB(event,opr_end,rtn_move,name)}
    }
    "Gohome Move" {
     set trans_name {$gPB(event,opr_end,goh_move,name)}
    }
    "End of Path" {
     set trans_name {$gPB(event,opr_end,end_path,name)}
    }
    "End of Program" -
    "End Of Program" {
     set trans_name {$gPB(event,end_prog,name)}
    }
    "Lathe Thread" {
     set trans_name {$gPB(event,lathe,name)}
    }
    "Spindle CSS" {
     set trans_name {$gPB(event,spindle_css,name)}
    }
    "Start of Pass" {
     set trans_name {$gPB(event,opr_start,start_pass,name)}
    }
    "Cutcom Move" {
     set trans_name {$gPB(event,opr_start,cutcom_move,name)}
    }
    "Lead In Move" {
     set trans_name {$gPB(event,opr_start,lead_move,name)}
    }
    "Thread Wire" {
     set trans_name {$gPB(event,threadwire,name)}
    }
    "Cut Wire" {
     set trans_name {$gPB(event,cutwire,name)}
    }
    "Set Mode" {
     set trans_name {$gPB(event,set_modes,name)}
    }
    "Lead Out Move" {
     set trans_name {$gPB(event,opr_end,lead_move,name)}
    }
    "End of Pass" {
     set trans_name {$gPB(event,opr_end,end_pass,name)}
    }
    "Common Parameters" {
     set trans_name {$gPB(event,cycle,com_param,name)}
    }
    "Feedrates" {
     set trans_name {$gPB(event,feedrates,name)}
    }
    "Inch Metric Mode" {
     set trans_name {$gPB(event,inch_metric_mode,name)}
    }
    "Wire Guides" {
     set trans_name {$gPB(event,wireguides,name)}
    }
    "Feedrate Mode DPM" {
     set trans_name {$gPB(g_code,feedmode,dpm)}
    }
    "Feedrate Mode MMPM" {
     set trans_name {$gPB(g_code,feedmode_mm,pm)}
    }
    "Feedrate Mode MMPR" {
     set trans_name {$gPB(g_code,feedmode_mm,pr)}
    }
    "Delay (Rev)" {
     set trans_name {$gPB(g_code,delay_rev,name)}
    }
    default  {
     set trans_name $event_name
    }
   }
  }
  return $trans_name
 }

#=======================================================================
proc __prv_UpdateEvtHList { EVE_PAGE_OBJ } {
  upvar $EVE_PAGE_OBJ eve_page_obj
  global paOption
  global tixOption
  global gPB
  set tree $Page::($eve_page_obj,tree)
  set h [$tree subwidget hlist]
  set style1 $gPB(font_style_normal)
  uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]
  PB_int_RetSequenceObjs seq_obj_list
  set t 0
  foreach seq_obj $seq_obj_list {
   if { [PB_is_v3] >= 0 } {
    global machType
    if { [string match "Wire EDM" $machType] && \
     [string match "Cycles" $sequence::($seq_obj,seq_name)] } {
     continue
    }
   }
   if {$::env(PB_UDE_ENABLED) == 1} {
    if [string match "Machine Control" $sequence::($seq_obj,seq_name)] {
     __prv_AddEvtHList $tree $t $sequence::($seq_obj,evt_obj_list)
    }
   }
   if [string match "Cycles" $sequence::($seq_obj,seq_name)] {
    if {$::env(PB_UDE_ENABLED) == 1} {
     global machData
     if {$machData(0) == "Mill"} {
      set event_list [list]
      global post_object
      set udeobj $Post::($post_object,ude_obj)
      set seqobj_cycle $ude::($udeobj,seq_obj_cycle)
      set cycle_event_list $sequence::($seqobj_cycle,evt_obj_list)
      foreach evt_obj $sequence::($seq_obj,evt_obj_list) {
       set evt_name $event::($evt_obj,event_name)
       if {$evt_name == "Peck Drill" || \
        $evt_name == "Break Chip" || \
        $evt_name == "Drill Csink"} {
        continue
       }
       if {[lsearch $cycle_event_list $evt_obj] >= "0"} {
        if {[lsearch $gPB(SYS_CYCLE) $event::($evt_obj,event_name)] < 0} {
         lappend event_list $evt_obj
        }
        } else {
        lappend event_list $evt_obj
       }
      }
      __prv_AddEvtHList $tree $t $event_list
     }
     } else {
     set event_list [list]
     foreach evt_obj $sequence::($seq_obj,evt_obj_list) {
      set evt_name  $event::($evt_obj,event_name)
      if {$evt_name == "Peck Drill" || \
       $evt_name == "Break Chip" || \
       $evt_name == "Drill Csink"} {
       continue
       } else {
       lappend event_list $evt_obj
      }
     }
     __prv_AddEvtHList $tree $t $event_list
    }
   }
   if [string match "Linked Posts Sequence" $sequence::($seq_obj,seq_name)] {
    __prv_AddEvtHList $tree $t $sequence::($seq_obj,evt_obj_list)
    if 0 {
     $h delete offsprings 0.$t
     foreach evt_obj $sequence::($seq_obj,evt_obj_list)\
     {
      set event_name $event::($evt_obj,event_name)
      if { [string compare $event_name "Inch Metric Mode"] == 0 || \
       [string compare $event_name "Feedrates"] == 0 || \
       [string compare $event_name "Opskip"] == 0 || \
      [string compare $event_name "Cycle Parameters"] == 0} \
      {
       incr evt_indx
       continue
      }
      $h add 0.$t.$evt_indx -itemtype imagetext -text $event_name \
      -style $style1
      $tree setstatus 0.$t.$evt_indx $gPB(check_box_status)
      incr evt_indx
     }
    }
   }
   if [string match "Virtual NC Controller" $sequence::($seq_obj,seq_name)] {
    if { ![PB_is_v $gPB(VNC_release)] } {
     continue
    }
    continue
    __prv_AddVNCEvtHList $tree $t
   }
   incr t
  }
 }

#=======================================================================
proc UI_PB_prv_TclTreeSelection { page_obj args } {
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set index [string range $ent 2 [string length $ent]]
  if {[string compare $index ""] == 0} \
  {
   $HLIST selection clear
   $HLIST anchor clear
   $HLIST selection set 0.0
   $HLIST anchor set 0.0
   set index 0
  }
  set display_code 1
  set dot_indx [string first . $index]
  if {$dot_indx != -1} \
  {
   set first_indx [string range $index 0 [expr $dot_indx -1]]
   set sec_indx [string range $index [expr $dot_indx + 1] end]
  } else \
  {
   $HLIST selection clear
   $HLIST anchor clear
   set child [lindex [$HLIST info children "0.$index"] 0]
   if [string match "" [string trim $child]] {
    set display_code 0
    } else {
    $HLIST selection set $child
    $HLIST anchor set $child
    set first_indx $index
    set dot_indx [string last . $child]
    set sec_indx [string range $child [expr $dot_indx + 1] end]
   }
  }
  if { !$display_code } {
   $HLIST selection set $ent
   $HLIST anchor set $ent
   } else {
   global machType
   if { [string match "Wire EDM" $machType] } {
    if { $first_indx > 3 } { incr first_indx }
   }
   UI_PB_prv_DisplayTclCode first_indx sec_indx page_obj
  }
 }

#=======================================================================
proc UI_PB_prv_DisplayTclCode { FIRST_INDX SEC_INDX PAGE_OBJ } {
  upvar $FIRST_INDX first_indx
  upvar $SEC_INDX sec_indx
  upvar $PAGE_OBJ page_obj
  PB_int_RetSequenceObjs seq_obj_list
  set evt_blks ""
  switch $first_indx \
  {
   0  -
   1  -
   2  -
   3  -
   4  -
   5  -
   6  -
   7  -
   8  {
    set seq_obj [lindex $seq_obj_list $first_indx]
    if {[string match "Cycles" $sequence::($seq_obj,seq_name)] && \
     $::env(PB_UDE_ENABLED) == 1} {
     global machData
     if {$machData(0) == "Mill"} {
      set temp_event_list [list]
      global post_object gPB
      set udeobj $Post::($post_object,ude_obj)
      set seqobj_cycle $ude::($udeobj,seq_obj_cycle)
      set cycle_event_list $sequence::($seqobj_cycle,evt_obj_list)
      foreach evt_obj $sequence::($seq_obj,evt_obj_list) {
       set evt_name $event::($evt_obj,event_name)
       if {$evt_name == "Peck Drill" || \
        $evt_name == "Break Chip" || \
        $evt_name == "Drill Csink"} {
        continue
       }
       if {[lsearch $cycle_event_list $evt_obj] >= "0"} {
        if {[lsearch $gPB(SYS_CYCLE) $event::($evt_obj,event_name)] < "0"} {
         lappend temp_event_list $evt_obj
        }
        } else {
        lappend temp_event_list $evt_obj
       }
      }
      set event_obj [lindex $temp_event_list $sec_indx]
      } else {
      set event_obj [lindex $sequence::($seq_obj,evt_obj_list) \
      $sec_indx]
     }
     } elseif {[string match "Cycles" $sequence::($seq_obj,seq_name)] && \
     $::env(PB_UDE_ENABLED) == 0} {
     global machData
     if {$machData(0) == "Mill"} {
      set temp_event_list [list]
      global post_object gPB
      foreach evt_obj $sequence::($seq_obj,evt_obj_list) {
       set evt_name $event::($evt_obj,event_name)
       if {$evt_name == "Peck Drill" || \
        $evt_name == "Break Chip" || \
        $evt_name == "Drill Csink"} {
        continue
       }
       lappend temp_event_list $evt_obj
      }
      set event_obj [lindex $temp_event_list $sec_indx]
      } else {
      set event_obj [lindex $sequence::($seq_obj,evt_obj_list) \
      $sec_indx]
     }
     } else  {
     set event_obj [lindex $sequence::($seq_obj,evt_obj_list) \
     $sec_indx]
    }
    set temp_evt_blks ""
    __prv_GetBlkNamesOfEvent event_obj evt_blks
   }
  }
  set temp_event_name $event::($event_obj,event_name)
  PB_com_GetPrefixOfEvent temp_event_name prefix
  if { $first_indx != 8 } {
   set temp_event_name [string tolower $temp_event_name]
  }
  set temp_evt_name [join [split $temp_event_name " "] _ ]
  append event_name $prefix _ $temp_evt_name
  unset temp_evt_name
  if {$::env(PB_UDE_ENABLED) == 1} {
   if [info exists event::($event_obj,ude_event_obj)] {
    set ueo $event::($event_obj,ude_event_obj)
    set post_name $ude_event::($ueo,post_event)
    if {$post_name == ""} {
     set post_name $ude_event::($ueo,name)
    }
    set post_name MOM_${post_name}
    if {$post_name != $event_name} {
     set event_name $post_name
    }
   }
  }
  PB_output_RetBlksModality blk_mod_arr
  if { $event_name == "MOM_tool_change" } {
   set evt_blks [list ""]
  }
  if {$::env(PB_UDE_ENABLED) == 1} {
   global post_object gPB machType
   set udeobj $Post::($post_object,ude_obj)
   set seqobj_cycle $ude::($udeobj,seq_obj_cycle)
   if [string match "Mill" $machType] {
    set udc_event_list $sequence::($seqobj_cycle,evt_obj_list)
    } else {
    set udc_event_list [list]
   }
   set udc_name_list [list]
   if {[lsearch $udc_event_list $event_obj] >= 0} {
    if {[lsearch $gPB(SYS_CYCLE) $event::($event_obj,event_name)] < 0} {
     lappend udc_name_list $event_name
     if {[lindex $evt_blks 0] == ""} {
      set evt_blks ""
     }
    }
   }
   PB_output_GetEventProcData event_obj event_name evt_blks blk_mod_arr event_output $udc_name_list
   } else {
   PB_output_GetEventProcData event_obj event_name evt_blks blk_mod_arr event_output
  }
  if {$first_indx == 4} \
  {
   array set event_proc_data $Page::($page_obj,evt_proc_list)
   set name_list [array names event_proc_data]
   append temp_name $event_name _move
   if { [lsearch $name_list $temp_name] != -1} \
   {
    lappend temp_evt_list $event_name $temp_name
    set event_name $temp_evt_list
    unset temp_evt_list temp_name
   }
  }
  UI_PB_prv_DisplayEventProc page_obj event_output event_name
 }

#=======================================================================
proc __prv_GetBlkNamesOfEvent { EVENT_OBJ EVT_BLKS } {
  upvar $EVENT_OBJ event_obj
  upvar $EVT_BLKS evt_blks
  set current_event $event::($event_obj,event_name)
  PB_int_RetCycleComAndSharedEvts cycle_com_evt cycle_shared_evts
  if { [lsearch $cycle_shared_evts $current_event] != -1 } \
  {
   PB_output_RetCycleEvtBlkList event_obj evt_blks MCALL
  } else \
  {
   PB_output_RetEvtBlkList event_obj temp_evt_blk_list
   set evt_blks [list $temp_evt_blk_list]
  }
 }

#=======================================================================
proc UI_PB_prv_DisplayEventProc { PAGE_OBJ EVENT_OUTPUT EVT_NAME_LIST } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OUTPUT event_output
  upvar $EVT_NAME_LIST evt_name_list
  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)
  $ltext config -state normal
  $rtext config -state normal
  $ltext delete 1.0 end
  set event_output [lreplace $event_output 0 0]
  foreach line $event_output \
  {
   $ltext insert end "  $line\n"
  }
  array set event_proc_data $Page::($page_obj,evt_proc_list)
  $rtext delete 1.0 end
  set idx 0
  foreach event_name $evt_name_list \
  {
   if { $::env(PB_UDE_ENABLED) == 1 } {
    if { [string match $event_name "MOM_cutcom"] || \
     [string match $event_name "MOM_wire_cutcom"] } {
     set event_name MOM_cutcom_on
     } elseif [string match $event_name "MOM_spindle"] {
     set event_name MOM_spindle_rpm
    }
   }
   set old_event_output ""
   if { [info exists event_proc_data($event_name)] } \
   {
    set old_event_output $event_proc_data($event_name)
   }
   foreach line $old_event_output \
   {
    $rtext insert end "  $line\n"
   }
   if { [string compare $event_name "MOM_lathe_thread"] == 0 } {
    set evt_move ${event_name}_move
    if { [info exists event_proc_data($evt_move)] } {
     $rtext insert end "\n\n"
     foreach line $event_proc_data($evt_move)  {
      $rtext insert end "  $line\n"
     }
    }
   }
   if { [llength $evt_name_list] > 1  &&  $idx == 0 } {
    $rtext insert end "\n\n"
    incr idx
   }
  }
  if ![string compare $::tix_version 8.4] {
   UI_PB_com_HighlightTclKeywords $ltext
   UI_PB_com_HighlightTclKeywords $rtext
  }
  $ltext config -state disabled
  $rtext config -state disabled
 }

#=======================================================================
proc UI_PB_prv_Definition { book_id def_page_obj } {
  global tixOption
  global paOption
  set Page::($def_page_obj,page_id) [$book_id subwidget \
  $Page::($def_page_obj,page_name)]
  Page::CreatePane $def_page_obj
  Page::CreateCheckList $def_page_obj
  UI_PB_prv_CreateSecPaneElems def_page_obj
 }

#=======================================================================
proc UI_PB_prv_CreateDefListElements { DEF_PAGE_OBJ INDEX } {
  upvar $DEF_PAGE_OBJ def_page_obj
  upvar $INDEX index
  global paOption
  global tixOption
  global gPB
  set tree $Page::($def_page_obj,tree)
  set h [$tree subwidget hlist]
  $h config -bg $paOption(tree_bg)
  set style  $gPB(font_style_bold)
  set style1 $gPB(font_style_normal)
  uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]
  set file   $paOption(file)
  set folder $paOption(folder)
  $h delete all
  $h add 0   -itemtype imagetext -text "" -image $folder -state disabled
  $tree setstatus 0 none
  $h add 0.0 -itemtype imagetext -text "$gPB(definition,word_txt,Label)" \
  -style $style1
  $h add 0.1 -itemtype imagetext -text "$gPB(definition,end_txt,Label)" \
  -style $style1
  $h add 0.2 -itemtype imagetext -text "$gPB(definition,seq_txt,Label)" \
  -style $style1
  $h add 0.3 -itemtype imagetext -text "$gPB(definition,include,Label)" \
  -style $style1
  $tree setstatus 0.0 $gPB(check_box_status)
  $tree setstatus 0.1 $gPB(check_box_status)
  $tree setstatus 0.2 $gPB(check_box_status)
  $tree setstatus 0.3 $gPB(check_box_status)
  PB_int_RetFormatObjList fmt_obj_list
  set fmt_img [tix getimage pb_format]
  $h add 0.4 -itemtype imagetext -text "$gPB(definition,format_txt,Label)" \
  -image $fmt_img -style $style -state normal ;#<01-04-02 gsl>disabled
  set t 0
  foreach fmt_obj $fmt_obj_list \
  {
   $h add 0.4.$t -itemtype imagetext -style $style1 \
   -text $format::($fmt_obj,for_name)
   $tree setstatus 0.4.$t $gPB(check_box_status)
   incr t
  }
  PB_int_RetAddressObjList add_obj_list
  set add_img [tix getimage pb_address]
  $h add 0.5 -itemtype imagetext -text "$gPB(definition,addr_txt,Label)" \
  -image $add_img -style $style -state normal ;#<01-04-02 gsl>disabled
  set t 0
  foreach add_obj $add_obj_list \
  {
   $h add 0.5.$t -itemtype imagetext \
   -text $address::($add_obj,add_name) -style $style1
   $tree setstatus 0.5.$t $gPB(check_box_status)
   incr t
  }
  PB_int_RetBlkObjList blk_obj_list
  set blk_img [tix getimage pb_block_s]
  $h add 0.6 -itemtype imagetext -text "$gPB(definition,block_txt,Label)" \
  -image $blk_img -style $style -state normal ;#<01-04-02 gsl>disabled
  set t 0
  foreach blk_obj $blk_obj_list \
  {
   $h add 0.6.$t -itemtype imagetext \
   -text $block::($blk_obj,block_name) -style $style1
   $tree setstatus 0.6.$t $gPB(check_box_status)
   incr t
  }
  set Page::($def_page_obj,blk_obj_list) $blk_obj_list
  set comp_blk_list ""
  PB_output_GetCompositeBlks comp_blk_list
  if 0 {
   foreach blk_obj $comp_blk_list \
   {
    $h add 0.5.$t -itemtype imagetext \
    -text $block::($blk_obj,block_name) -style $style1
    $tree setstatus 0.5.$t $gPB(check_box_status)
    incr t
   }
   } else {
   if { [llength $comp_blk_list] > 0 } {
    $h add 0.7 -itemtype imagetext -text "$gPB(definition,comp_txt,Label)" \
    -image $blk_img -style $style -state normal ;#<01-04-02 gsl>disabled
    set t 0
    foreach blk_obj $comp_blk_list \
    {
     $h add 0.7.$t -itemtype imagetext \
     -text $block::($blk_obj,block_name) -style $style1
     $tree setstatus 0.7.$t $gPB(check_box_status)
     incr t
    }
   }
  }
  set Page::($def_page_obj,comp_blk_list) $comp_blk_list
  PB_int_RetPostBlocks post_blk_list
  if [info exists post_blk_list] {
   if { $post_blk_list !=  "" } \
   {
    $h add 0.8 -itemtype imagetext -text "$gPB(definition,post_txt,Label)" \
    -image $blk_img -style $style -state normal ;#<01-04-02 gsl>disabled
    set t 0
    foreach pb_blk_obj $post_blk_list \
    {
     $h add 0.8.$t -itemtype imagetext \
     -text $block::($pb_blk_obj,block_name) -style $style1
     $tree setstatus 0.8.$t $gPB(check_box_status)
     incr t
    }
   }
   set Page::($def_page_obj,post_blk_list) $post_blk_list
  }
  PB_int_RetCommentBlks comment_blk_list
  if { $comment_blk_list !=  "" } \
  {
   $h add 0.9 -itemtype imagetext -text "$gPB(definition,oper_txt,Label)" \
   -image $blk_img -style $style -state normal ;#<01-04-02 gsl>disabled
   set t 0
   foreach oper_blk $comment_blk_list \
   {
    $h add 0.9.$t -itemtype imagetext \
    -text $block::($oper_blk,block_name) -style $style1
    $tree setstatus 0.9.$t $gPB(check_box_status)
    incr t
   }
  }
  set Page::($def_page_obj,comment_blk_list) $comment_blk_list
  $tree configure -browsecmd "UI_PB_DefinitionTreeSelect $def_page_obj"
  while { [$h info exists 0.$index] == 0 } \
  {
   set ind_list [split $index .]
   if { [lindex $ind_list 1] != 0 } \
   {
    set ind_list [lreplace $ind_list 1 1 [expr [lindex $ind_list 1] - 1]]
   } else \
   {
    set ind_list [lreplace $ind_list 0 0 [expr [lindex $ind_list 0] - 1]]
    set ind_list [lreplace $ind_list 1 1 0]
   }
   set index [join $ind_list .]
  }
  $h selection set 0.$index
  $h anchor set 0.$index
  $tree autosetmode
  $tree setmode 0 none
 }

#=======================================================================
proc UI_PB_DefinitionTreeSelect { page_obj args } {
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set index [string range $ent 2 [string length $ent]]
  if {[string compare $index ""] == 0} \
  {
   $HLIST selection clear
   $HLIST anchor clear
   $HLIST selection set 0.0
   $HLIST anchor set 0.0
   set index 0
  }
  set dot_indx [string first . $index]
  if {$dot_indx != -1} \
  {
   set first_indx [string range $index 0 [expr $dot_indx -1]]
   set sec_indx [string range $index [expr $dot_indx + 1] end]
   } elseif {$index == 0 || $index == 1 || $index == 2 || $index == 3 } \
  {
   set first_indx $index
   set sec_indx 0
  } else \
  {
   $HLIST selection clear
   $HLIST anchor clear
   $HLIST selection set 0.$index.0
   $HLIST anchor set 0.$index.0
   set first_indx $index
   set sec_indx 0
  }
  UI_PB_prv_DisplayDefCode first_indx sec_indx page_obj
 }

#=======================================================================
proc UI_PB_prv_DisplayDefCode { FIRST_INDX SEC_INDX PAGE_OBJ } {
  upvar $FIRST_INDX first_indx
  upvar $SEC_INDX sec_indx
  upvar $PAGE_OBJ page_obj
  switch $first_indx \
  {
   0 { UI_PB_prv_WordSep page_obj }
   1 { UI_PB_prv_EndOfBlock page_obj }
   2 { UI_PB_prv_SeqNumber page_obj }
   3 { UI_PB_prv_Include page_obj }
   4 { UI_PB_prv_Format page_obj sec_indx }
   5 { UI_PB_prv_Address page_obj sec_indx }
   6 { UI_PB_prv_BlockTemplate page_obj sec_indx }
   7 { UI_PB_prv_CompBlockTemplate page_obj sec_indx }
   8 { UI_PB_prv_PostBlkTemplate page_obj sec_indx }
   9 { UI_PB_prv_CommentBlkTemplate page_obj sec_indx }
  }
  if ![string compare $::tix_version 8.4] {
   set ltext $Page::($page_obj,ltext)
   set rtext $Page::($page_obj,rtext)
   UI_PB_com_HighlightDefKeywords $ltext
   UI_PB_com_HighlightDefKeywords $rtext
  }
 }

#=======================================================================
proc UI_PB_prv_WordSep { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr
  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)
  PB_output_GetWordSeperator $mom_sys_arr(Word_Seperator) new_word_sep
  UI_PB_prv_OutputWordSep ltext new_word_sep
  set mom_var_arr(0) "Word_Seperator"
  PB_int_RetDefMOMVarValues mom_var_arr mom_var_value
  PB_output_GetWordSeperator $mom_var_value(Word_Seperator) word_sep
  UI_PB_prv_OutputWordSep rtext word_sep
 }

#=======================================================================
proc UI_PB_prv_OutputWordSep { TEXT_WIDGET WORD_SEP } {
  upvar $TEXT_WIDGET text_widget
  upvar $WORD_SEP word_sep
  $text_widget config -state normal
  $text_widget delete 1.0 end
  $text_widget insert end "\n"
  $text_widget insert end "         $word_sep"
  $text_widget config -state disabled
 }

#=======================================================================
proc UI_PB_prv_EndOfBlock { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr
  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)
  PB_output_GetEndOfLine $mom_sys_arr(End_of_Block) new_endof_line
  UI_PB_prv_OutputEndBlk ltext new_endof_line
  set mom_var_arr(0) "End_of_Block"
  PB_int_RetDefMOMVarValues mom_var_arr mom_var_value
  PB_output_GetEndOfLine $mom_var_value(End_of_Block) endof_line
  UI_PB_prv_OutputEndBlk rtext endof_line
 }

#=======================================================================
proc UI_PB_prv_OutputEndBlk { TEXT_WIDGET END_OF_LINE } {
  upvar $TEXT_WIDGET text_widget
  upvar $END_OF_LINE end_of_line
  $text_widget config -state normal
  $text_widget delete 1.0 end
  $text_widget insert end "\n"
  $text_widget insert end "         $end_of_line"
  $text_widget config -state disabled
 }

#=======================================================================
proc UI_PB_prv_Include { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr
  global post_object
  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)
  set include_str [list]
  global ads_cdl_arr
  if { [info exists mom_sys_arr(Include_UDE)] && $mom_sys_arr(Include_UDE) == 1 } {
   foreach oth_cdl $ads_cdl_arr($ads_cdl_arr(type_other),cdl_list) {
    lappend include_str $oth_cdl
   }
  }
  if { [info exists mom_sys_arr(Inherit_UDE)] && $mom_sys_arr(Inherit_UDE) == 1 } {
   foreach inh_cdl $ads_cdl_arr($ads_cdl_arr(type_inherit),cdl_list) {
    __ads_cdl_GetNativeCDLFileFrmListElem $inh_cdl $ads_cdl_arr(type_inherit) temp_cdl_file
    set folder $temp_cdl_file(0)
    set cdl_fn $temp_cdl_file(1).cdl
    set def_fn $temp_cdl_file(1).def
    if { [string match $folder ""] } {
     lappend include_str $cdl_fn $def_fn
     } else {
     if { ![string match "*/" $folder] } {
      append folder "/"
     }
     if { [regexp {UGII[A-Za-z0-9_]+} $folder ugii_var] } {
      regsub {UGII[A-Za-z0-9_]+} $folder [string toupper $ugii_var] folder
     }
     lappend include_str $folder$cdl_fn $folder$def_fn
    }
   }
  }
  if { [info exists mom_sys_arr(Own_UDE)] && $mom_sys_arr(Own_UDE) == 1 } {
   set pui_file $Post::($post_object,out_pui_file)
   set cdl_fn [lindex [split [file tail $pui_file] .] 0].cdl
   if { [string match $mom_sys_arr(OWN_CDL_File_Folder) ""] } {
    lappend include_str $cdl_fn
    } else {
    set folder $mom_sys_arr(OWN_CDL_File_Folder)
    if { ![string match "*/" $folder] } {
     set folder "${folder}/"
    }
    if { [regexp {UGII[A-Za-z0-9_]+} $folder ugii_var] } {
     regsub {UGII[A-Za-z0-9_]+} $folder [string toupper $ugii_var] folder
    }
    lappend include_str $folder$cdl_fn
   }
  }
  if 0 {
   if { ![string match "" $include_str] } {
    set include_str [join $include_str]
    set new_code "INCLUDE \{ ${include_str} \}"
    $ltext config -state normal
    $ltext delete 1.0 end
    $ltext insert end "\n"
    $ltext insert end "         $new_code"
    $ltext config -state disabled
    } else {
    $ltext config -state normal
    $ltext delete 1.0 end
    $ltext config -state disabled
   }
   $rtext config -state normal
   $rtext delete 1.0 end
   if { [info exists Post::($post_object,UDE_File_Name)] && \
    $Post::($post_object,UDE_File_Name) != "" } {
    set old_code "INCLUDE \{ $Post::($post_object,UDE_File_Name) \}"
    $rtext insert end "\n"
    $rtext insert end "         $old_code"
   }
   $rtext config -state disabled
  }
  if { ![string match "" $include_str] } {
   set include_str [join $include_str]
   $ltext config -state normal
   $ltext delete 1.0 end
   $ltext insert end "\n"
   $ltext insert end "         INCLUDE {\n"
    foreach ln $include_str {
     $ltext insert end "                  $ln\n"
    }
   $ltext insert end "                 }"
   $ltext config -state disabled
   } else {
   $ltext config -state normal
   $ltext delete 1.0 end
   $ltext config -state disabled
  }
  $rtext config -state normal
  $rtext delete 1.0 end
  if { [info exists Post::($post_object,UDE_File_Name)] } {
   if { ![info exists Post::($post_object,UDE_File_Name_save)] } {
    set Post::($post_object,UDE_File_Name_save) $Post::($post_object,UDE_File_Name)
   }
   if { $Post::($post_object,UDE_File_Name_save) != "" } {
    $rtext insert end "\n"
    $rtext insert end "         INCLUDE {\n"
     foreach ln $Post::($post_object,UDE_File_Name_save) {
      $rtext insert end "                  $ln\n"
     }
    $rtext insert end "                 }"
   }
  }
  $rtext config -state disabled
 }

#=======================================================================
proc UI_PB_prv_SeqNumber { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr
  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)
  set seq_param(0) $mom_sys_arr(seqnum_block)
  set seq_param(1) $mom_sys_arr(seqnum_start)
  set seq_param(2) $mom_sys_arr(seqnum_incr)
  set seq_param(3) $mom_sys_arr(seqnum_freq)
  if 1 {
   if { $mom_sys_arr(seqnum_max) != "" } {
    set seq_param(4) $mom_sys_arr(seqnum_max)
    } else {
    set seq_param(4) [PB_output_GetSeqNumMax]
   }
   } else {
   set seq_param(4) [PB_output_GetSeqNumMax]
  }
  PB_output_GetSequenceNumber seq_param new_seq_num
  UI_PB_prv_OutputSeqNo ltext new_seq_num
  set mom_var_arr(0) "seqnum_block"
  set mom_var_arr(1) "seqnum_start"
  set mom_var_arr(2) "seqnum_incr"
  set mom_var_arr(3) "seqnum_freq"
  set mom_var_arr(4) "seqnum_max"
  PB_int_RetDefMOMVarValues mom_var_arr mom_var_value
  set seq_param(0) $mom_var_value(seqnum_block)
  set seq_param(1) $mom_var_value(seqnum_start)
  set seq_param(2) $mom_var_value(seqnum_incr)
  set seq_param(3) $mom_var_value(seqnum_freq)
  set seq_param(4) $mom_var_value(seqnum_max)
  PB_output_GetSequenceNumber seq_param seq_num
  UI_PB_prv_OutputSeqNo rtext seq_num
 }

#=======================================================================
proc UI_PB_prv_OutputSeqNo { TEXT_WIDGET SEQUENCE_NUM } {
  upvar $TEXT_WIDGET text_widget
  upvar $SEQUENCE_NUM sequence_num
  $text_widget config -state normal
  $text_widget delete 1.0 end
  $text_widget insert end "\n"
  $text_widget insert end "         $sequence_num"
  $text_widget config -state disabled
 }

#=======================================================================
proc UI_PB_prv_Format { PAGE_OBJ INDEX } {
  upvar $PAGE_OBJ page_obj
  upvar $INDEX index
  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)
  PB_int_RetFormatObjList fmt_obj_list
  set fmt_obj [lindex $fmt_obj_list $index]
  format::readvalue $fmt_obj fmt_obj_attr
  PB_fmt_RetFmtFrmAttr fmt_obj_attr for_value
  UI_PB_prv_OutputFormat ltext fmt_obj_attr(0) for_value
  array set def_fmt_obj_attr $format::($fmt_obj,def_value)
  PB_fmt_RetFmtFrmAttr def_fmt_obj_attr def_for_value
  UI_PB_prv_OutputFormat rtext def_fmt_obj_attr(0) def_for_value
 }

#=======================================================================
proc UI_PB_prv_OutputFormat { TEXT_WIDGET FMT_NAME FMT_VALUE } {
  upvar $TEXT_WIDGET text_widget
  upvar $FMT_NAME fmt_name
  upvar $FMT_VALUE fmt_value
  $text_widget config -state normal
  $text_widget delete 1.0 end
  $text_widget insert end "\n"
  $text_widget insert end "         FORMAT $fmt_name  $fmt_value"
  $text_widget config -state disabled
 }

#=======================================================================
proc UI_PB_prv_Address { PAGE_OBJ INDEX } {
  upvar $PAGE_OBJ page_obj
  upvar $INDEX index
  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)
  PB_int_RetAddressObjList add_obj_list
  set add_obj [lindex $add_obj_list $index]
  address::readvalue $add_obj add_obj_attr
  if { $address::($add_obj,leader_var) != "" } \
  {
   set add_obj_attr(8) $address::($add_obj,leader_var)
  }
  PB_adr_SetZeroFmt add_obj_attr
  PB_adr_RetAddFrmAddAttr add_obj_attr add_val_list
  UI_PB_prv_OutputAddress ltext add_obj_attr(0) add_val_list
  array set def_add_obj_attr $address::($add_obj,def_value)
  if { $address::($add_obj,leader_var) != "" } \
  {
   set def_add_obj_attr(8) $address::($add_obj,leader_var)
  }
  set def_add_obj_attr(12) -1
  PB_adr_RetAddFrmAddAttr def_add_obj_attr def_add_val_list
  UI_PB_prv_OutputAddress rtext def_add_obj_attr(0) def_add_val_list
 }

#=======================================================================
proc UI_PB_prv_OutputAddress { TEXT_WIDGET ADD_NAME ADD_VALUE } {
  upvar $TEXT_WIDGET text_widget
  upvar $ADD_NAME add_name
  upvar $ADD_VALUE add_value
  $text_widget config -state normal
  $text_widget delete 1.0 end
  $text_widget insert end "\n"
  $text_widget insert end "        ADDRESS $add_name\n"
  $text_widget insert end "        \{\n"
   set ii [llength $add_value]
   for {set jj 0} {$jj < $ii} {incr jj} \
   {
    $text_widget insert end "              [lindex $add_value $jj]\n"
   }
  $text_widget insert end "        \}\n"
  $text_widget config -state disabled
 }

#=======================================================================
proc UI_PB_prv_BlockTemplate { PAGE_OBJ INDEX} {
  upvar $PAGE_OBJ page_obj
  upvar $INDEX index
  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)
  set blk_obj_list $Page::($page_obj,blk_obj_list)
  set comp_blk_list $Page::($page_obj,comp_blk_list)
  set no_of_actblks [llength $blk_obj_list]
  if {$index < $no_of_actblks} \
  {
   set block_obj [lindex $blk_obj_list $index]
  } else \
  {
   set block_obj [lindex $comp_blk_list [expr $index - $no_of_actblks]]
  }
  block::readvalue $block_obj blk_obj_attr
  PB_blk_RetBlkFrmBlkAttr blk_obj_attr blk_value
  UI_PB_prv_OutputBlockTemplate ltext blk_obj_attr(0) blk_value
  array set def_blk_obj_attr $block::($block_obj,def_value)
  PB_blk_RetBlkFrmBlkAttr def_blk_obj_attr def_blk_value def
  UI_PB_prv_OutputBlockTemplate rtext def_blk_obj_attr(0) def_blk_value
 }

#=======================================================================
proc UI_PB_prv_CompBlockTemplate { PAGE_OBJ INDEX} {
  upvar $PAGE_OBJ page_obj
  upvar $INDEX index
  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)
  set comp_blk_list $Page::($page_obj,comp_blk_list)
  set block_obj [lindex $comp_blk_list $index]
  block::readvalue $block_obj blk_obj_attr
  PB_blk_RetBlkFrmBlkAttr blk_obj_attr blk_value
  UI_PB_prv_OutputBlockTemplate ltext blk_obj_attr(0) blk_value
  array set def_blk_obj_attr $block::($block_obj,def_value)
  PB_blk_RetBlkFrmBlkAttr def_blk_obj_attr def_blk_value def
  UI_PB_prv_OutputBlockTemplate rtext def_blk_obj_attr(0) def_blk_value
 }

#=======================================================================
proc UI_PB_prv_PostBlkTemplate { PAGE_OBJ INDEX } {
  upvar $PAGE_OBJ page_obj
  upvar $INDEX index
  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)
  set post_blk_list $Page::($page_obj,post_blk_list)
  set block_obj [lindex $post_blk_list $index]
  block::readvalue $block_obj blk_obj_attr
  PB_blk_RetBlkFrmBlkAttr blk_obj_attr blk_value
  UI_PB_prv_OutputBlockTemplate ltext blk_obj_attr(0) blk_value
  array set def_blk_obj_attr $block::($block_obj,def_value)
  PB_blk_RetBlkFrmBlkAttr def_blk_obj_attr def_blk_value def
  UI_PB_prv_OutputBlockTemplate rtext def_blk_obj_attr(0) def_blk_value
 }

#=======================================================================
proc UI_PB_prv_CommentBlkTemplate { PAGE_OBJ INDEX } {
  upvar $PAGE_OBJ page_obj
  upvar $INDEX index
  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)
  set comment_blk_list $Page::($page_obj,comment_blk_list)
  set block_obj [lindex $comment_blk_list $index]
  block::readvalue $block_obj blk_obj_attr
  PB_blk_RetBlkFrmBlkAttr blk_obj_attr blk_value
  UI_PB_prv_OutputBlockTemplate ltext blk_obj_attr(0) blk_value
  array set def_blk_obj_attr $block::($block_obj,def_value)
  PB_blk_RetBlkFrmBlkAttr def_blk_obj_attr def_blk_value def
  UI_PB_prv_OutputBlockTemplate rtext def_blk_obj_attr(0) def_blk_value
 }

#=======================================================================
proc UI_PB_prv_OutputBlockTemplate { TEXT_WIDGET BLOCK_NAME BLK_VALUE } {
  upvar $TEXT_WIDGET text_widget
  upvar $BLOCK_NAME block_name
  upvar $BLK_VALUE blk_value
  $text_widget config -state normal
  $text_widget delete 1.0 end
  $text_widget insert end  "\n"
  $text_widget insert end  "         BLOCK_TEMPLATE $block_name\n"
  $text_widget insert end  "         \{\n"
   if [string match "comment_blk*" $block_name] {
    global post_object
    array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
    set comment_start $mom_sys_var_arr(Comment_Start)
    set comment_end   $mom_sys_var_arr(Comment_End)
    set blk_string [lindex $blk_value 0]
    set blk_string [string range $blk_string 1 [expr [string length $blk_string] - 2]]
    set len [string length $comment_start]
    set blk_string [string range $blk_string $len end]
    set len [string length $comment_end]
    set end_idx [expr [string length $blk_string] - $len - 1]
    set blk_string [string range $blk_string 0 $end_idx]
    $text_widget insert end "              \"$blk_string\"\n"
    } else {
    set ii [llength $blk_value]
    for {set jj 0} {$jj < $ii} {incr jj} \
    {
     $text_widget insert end "              [lindex $blk_value $jj]\n"
    }
   }
  $text_widget insert end "         \}\n"
  $text_widget config -state disabled
 }

#=======================================================================
proc UI_PB_prv_CreateTabAttr { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  global gPB
  switch -exact -- $Book::($book_obj,current_tab) \
  {
   0 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
    __prv_UpdateEvtHList page_obj
    UI_PB_prv_TclTreeSelection $page_obj
    set first_indx 0; set sec_indx 0
    UI_PB_prv_DisplayTclCode first_indx sec_indx page_obj
    UI_PB_com_SetStatusbar "$gPB(event_handler,Status)"
   }
   1 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
    set tree $Page::($page_obj,tree)
    set HLIST [$tree subwidget hlist]
    set ent [$HLIST info selection]
    set index [string range $ent 2 [string length $ent]]
    if {[string compare $index ""] == 0} \
    {
     set index 0
    }
    UI_PB_prv_CreateDefListElements page_obj index
    UI_PB_DefinitionTreeSelect $page_obj
    UI_PB_com_SetStatusbar "$gPB(definition,Status)"
   }
   2 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
    set tree $Page::($page_obj,tree)
    set HLIST [$tree subwidget hlist]
    set ent [$HLIST info selection]
    set index [string range $ent 2 [string length $ent]]
    if {[string compare $index ""] == 0} {
     set index 0
    }
    UI_PB_prv_CreateUdeListElements page_obj index
    UI_PB_prv_UdeTreeSelect $page_obj
    UI_PB_com_SetStatusbar "$gPB(ude,prev,Status)"
   }
  }
 }

#=======================================================================
proc UI_PB_prv_EventTab { book_id page_img book_obj } {
  CB_nb_def $book_id $page_img $book_obj
  set Book::($book_obj,current_tab) 0
  UI_PB_prv_CreateTabAttr book_obj
 }

#=======================================================================
proc UI_PB_prv_DefTab { book_id page_img book_obj } {
  CB_nb_def $book_id $page_img $book_obj
  set Book::($book_obj,current_tab) 1
  UI_PB_prv_CreateTabAttr book_obj
 }

#=======================================================================
proc UI_PB_prv_Ude { book_id ude_page_obj } {
  global tixOption
  global paOption
  set Page::($ude_page_obj,page_id) [$book_id subwidget \
  $Page::($ude_page_obj,page_name)]
  Page::CreatePane $ude_page_obj
  Page::CreateCheckList $ude_page_obj
  UI_PB_prv_CreateSecPaneElems ude_page_obj
 }

#=======================================================================
proc UI_PB_prv_UdeTab { book_id page_img book_obj } {
  CB_nb_def $book_id $page_img $book_obj
  set Book::($book_obj,current_tab) 2
  UI_PB_prv_CreateTabAttr book_obj
 }

#=======================================================================
proc UI_PB_prv_CreateUdeListElements {UDE_PAGE_OBJ INDEX} {
  upvar $UDE_PAGE_OBJ ude_page_obj
  upvar $INDEX index
  global paOption
  global tixOption
  global gPB
  global machType
  set tree $Page::($ude_page_obj,tree)
  set h [$tree subwidget hlist]
  $h config -bg $paOption(tree_bg)
  set style  $gPB(font_style_bold)
  set style1 $gPB(font_style_normal)
  uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]
  set file   $paOption(file)
  set folder $paOption(folder)
  set fmt_img [tix getimage pb_ude]
  $h delete all
  $h add 0 -itemtype imagetext -text "" -image $folder -state disabled
  $tree setstatus 0 none
  $h add 0.0 -itemtype imagetext -text "$gPB(ude,prev,ude,Label)" \
  -image $fmt_img -style $style -state normal
  if [string match "Mill" $machType] {
   $h add 0.1 -itemtype imagetext -text "$gPB(ude,prev,udc,Label)" \
   -image $fmt_img -style $style -state normal
  }
  set mc [list]
  set non_mc [list]
  set sys_cyc [list]
  set non_sys_cyc [list]
  PB_ude_RetUdeUdcObjList mc non_mc sys_cyc non_sys_cyc
  $h add 0.0.0 -itemtype imagetext -text "$gPB(ude,prev,mc,Label)" \
  -image $file -style $style -state normal
  $h add 0.0.1 -itemtype imagetext -text "$gPB(ude,prev,nmc,Label)" \
  -image $file -style $style -state normal
  if [string match "Mill" $machType] {
   $h add 0.1.0 -itemtype imagetext -text "$gPB(udc,prev,sys,Label)" \
   -image $file -style $style -state normal
   $h add 0.1.1 -itemtype imagetext -text "$gPB(udc,prev,nsys,Label)" \
   -image $file -style $style -state normal
  }
  set t 0
  set obj ""
  foreach obj $mc {
   $h add 0.0.0.$t -itemtype imagetext -style $style1 \
   -text $ude_event::($obj,name)
   $tree setstatus 0.0.0.$t $gPB(check_box_status)
   incr t
  }
  set Page::($ude_page_obj,mc_list)  $mc
  set t 0
  set obj ""
  foreach obj $non_mc {
   $h add 0.0.1.$t -itemtype imagetext -style $style1 \
   -text $ude_event::($obj,name)
   $tree setstatus 0.0.1.$t $gPB(check_box_status)
   incr t
  }
  set Page::($ude_page_obj,non_mc_list) $non_mc
  if [string match "Mill" $machType] {
   set t 0
   set obj ""
   foreach obj $sys_cyc {
    $h add 0.1.0.$t -itemtype imagetext -style $style1 \
    -text $cycle_event::($obj,name)
    $tree setstatus 0.1.0.$t $gPB(check_box_status)
    incr t
   }
   set Page::($ude_page_obj,sys_cyc_list) $sys_cyc
   set t 0
   set obj ""
   foreach obj $non_sys_cyc {
    $h add 0.1.1.$t -itemtype imagetext -style $style1 \
    -text $cycle_event::($obj,name)
    $tree setstatus 0.1.1.$t $gPB(check_box_status)
    incr t
   }
   set Page::($ude_page_obj,non_sys_cyc_list) $non_sys_cyc
  }
  $tree config -browsecmd "UI_PB_prv_UdeTreeSelect $ude_page_obj"
  if {[$h info exists 0.$index] == 0} {
   $h selection set 0.0.0.0
   $h anchor set 0.0.0.0
   } else {
   if {$index == 0} {
    $h selection set 0.0.0.0
    $h anchor set 0.0.0.0
    } else {
    $h selection set 0.$index
    $h anchor set 0.$index
   }
  }
  $tree autosetmode
  $tree setmode 0 none
 }

#=======================================================================
proc UI_PB_prv_UdeTreeSelect {ude_page_obj args} {
  set tree $Page::($ude_page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set index [string range $ent 2 [string length $ent]]
  if {[string compare $index ""] == 0} {
   $HLIST selection clear
   $HLIST anchor clear
   $HLIST selection set 0.0
   $HLIST anchor set 0.0
   set index 0
  }
  set dot_indx [string first . $index]
  if {$dot_indx != -1} {
   set temp_indx [string range $index 2 [string length $index]]
   set temp_dot_indx [string first . $temp_indx]
   if {$temp_dot_indx != -1} {
    set idx [string last . $index]
    set first_indx [string range $index 0 [expr $dot_indx - 1]]
    set sec_indx [string range $index [expr $dot_indx + 1] [expr $idx - 1]]
    set third_indx [string range $index [expr $idx + 1] end]
    } else {
    $HLIST selection clear
    $HLIST anchor clear
    if [$HLIST info exists 0.$index.0] {
     $HLIST selection set 0.$index.0
     $HLIST anchor set 0.$index.0
     set first_indx [string range $index 0 [expr $dot_indx - 1]]
     set sec_indx [string range $index [expr $dot_indx + 1] end]
     set third_indx 0
     } else {
     $HLIST selection set 0.$index
     $HLIST anchor set 0.$index
     return
    }
   }
   } else {
   $HLIST selection clear
   $HLIST anchor clear
   if [$HLIST info exists 0.$index.0.0] {
    $HLIST selection set 0.$index.0.0
    $HLIST anchor set 0.$index.0.0
    set first_indx $index
    set sec_indx 0
    set third_indx 0
    } else {
    $HLIST selection set 0.$index.0
    $HLIST anchor set 0.$index.0
    return
   }
  }
  UI_PB_prv_DisplayUdeCode first_indx sec_indx third_indx ude_page_obj
 }

#=======================================================================
proc UI_PB_prv_DisplayUdeCode {F_INDX S_INDX T_INDX UDE_PAGE_OBJ} {
  upvar $F_INDX f_indx
  upvar $S_INDX s_indx
  upvar $T_INDX t_indx
  upvar $UDE_PAGE_OBJ ude_page_obj
  switch $f_indx {
   0 {
    UI_PB_prv_UserDefinedEvents $s_indx $t_indx $ude_page_obj
   }
   1 {
    UI_PB_prv_UserDefinedCycles $s_indx $t_indx $ude_page_obj
   }
  }
 }

#=======================================================================
proc UI_PB_prv_UserDefinedEvents {s_indx t_indx ude_page_obj} {
  if {$s_indx == 0} {
   set event_list $Page::($ude_page_obj,mc_list)
   } else {
   set event_list $Page::($ude_page_obj,non_mc_list)
  }
  set ltext $Page::($ude_page_obj,ltext)
  set rtext $Page::($ude_page_obj,rtext)
  set evt_obj [lindex $event_list $t_indx]
  UI_PB_prv_GetUdeOutput $evt_obj new_code old_code
  UI_PB_prv_OutputUde $ltext $new_code
  UI_PB_prv_OutputUde $rtext $old_code
 }

#=======================================================================
proc UI_PB_prv_UserDefinedCycles {s_indx t_indx ude_page_obj} {
  set type ""
  if {$s_indx == 0} {
   set event_list $Page::($ude_page_obj,sys_cyc_list)
   } else {
   set event_list $Page::($ude_page_obj,non_sys_cyc_list)
  }
  set ltext $Page::($ude_page_obj,ltext)
  set rtext $Page::($ude_page_obj,rtext)
  set evt_obj [lindex $event_list $t_indx]
  UI_PB_prv_GetUdeOutput $evt_obj new_code old_code
  UI_PB_prv_OutputUde $ltext $new_code
  UI_PB_prv_OutputUde $rtext $old_code
 }

#=======================================================================
proc UI_PB_prv_GetUdeOutput {evt_obj NEW_CODE OLD_CODE} {
  global gPB
  upvar $NEW_CODE new_code
  upvar $OLD_CODE old_code
  set class_type [classof $evt_obj]
  if {$class_type == "::ude_event"} {
   set name $ude_event::($evt_obj,name)
   set post_event $ude_event::($evt_obj,post_event)
   set ui_label $ude_event::($evt_obj,ui_label)
   set category $ude_event::($evt_obj,category)
   set param_obj_list $ude_event::($evt_obj,param_obj_list)
   set ui_help_descript $ude_event::($evt_obj,help_descript)
   set ui_help_url $ude_event::($evt_obj,help_url)
   lappend new_code "      EVENT $name"
   lappend new_code "      \{"
    if ![string match $post_event ""] {
     lappend new_code "        POST_EVENT \"$post_event\""
    }
    if ![string match $ui_label ""] {
     lappend new_code "        UI_LABEL \"$ui_label\""
    }
    if ![string match $category "\{\}"] {
     if ![string match $category ""] {
      lappend new_code "        CATEGORY $category"
     }
    }
    if { ![string match $ui_help_descript ""] || ![string match $ui_help_url ""] } {
     lappend new_code "        UI_HELP \"$ui_help_descript\" \"$ui_help_url\""
    }
    set def_name $ude_event::($evt_obj,def_name)
    set def_post_event $ude_event::($evt_obj,def_post_event)
    set def_ui_label $ude_event::($evt_obj,def_ui_label)
    set def_category $ude_event::($evt_obj,def_category)
    set def_param_obj_list $ude_event::($evt_obj,def_param_obj_list)
    set def_ui_help_descript $ude_event::($evt_obj,def_help_descript)
    set def_ui_help_url $ude_event::($evt_obj,def_help_url)
    lappend old_code "      EVENT $def_name"
    lappend old_code "      \{"
     if ![string match $def_post_event ""] {
      lappend old_code "        POST_EVENT \"$def_post_event\""
     }
     if ![string match $def_ui_label ""] {
      lappend old_code "        UI_LABEL \"$def_ui_label\""
     }
     if ![string match $def_category "\{\}"] {
      if ![string match $def_category ""] {
       lappend old_code "        CATEGORY $def_category"
      }
     }
     if { ![string match $def_ui_help_descript ""] || ![string match $def_ui_help_url ""] } {
      lappend old_code "        UI_HELP \"$def_ui_help_descript\" \"$def_ui_help_url\""
     }
     } else {
     set name $cycle_event::($evt_obj,name)
     set ui_label $cycle_event::($evt_obj,ui_label)
     set param_obj_list $cycle_event::($evt_obj,param_obj_list)
     if { !$cycle_event::($evt_obj,is_sys_cycle) && $gPB(enable_helpdesc_for_udc) } {
      set ui_help_descript $cycle_event::($evt_obj,help_descript)
      set ui_help_url $cycle_event::($evt_obj,help_url)
     }
     set param_obj_list_for_output [list]
     foreach obj $param_obj_list {
      if {[lsearch $gPB(sys_def_param_obj_list) $obj] < 0} {
       lappend param_obj_list_for_output $obj
      }
     }
     set param_obj_list $param_obj_list_for_output
     if {$cycle_event::($evt_obj,is_sys_cycle) == 1} {
      lappend new_code "      SYS_CYCLE $name"
      lappend new_code "      \{"
       if ![string match $ui_label ""] {
        lappend new_code "        UI_LABEL \"$ui_label\""
       }
       } else {
       lappend new_code "      CYCLE $name"
       lappend new_code "      \{"
        if ![string match $ui_label ""] {
         lappend new_code "        UI_LABEL \"$ui_label\""
        }
        if $gPB(enable_helpdesc_for_udc) {
         if { ![string match $ui_help_descript ""] || ![string match $ui_help_url ""] } {
          lappend new_code "        UI_HELP \"$ui_help_descript\" \"$ui_help_url\""
         }
        }
       }
       set def_name $cycle_event::($evt_obj,def_name)
       set def_ui_label $cycle_event::($evt_obj,def_ui_label)
       set def_param_obj_list $cycle_event::($evt_obj,def_param_obj_list)
       if { !$cycle_event::($evt_obj,def_is_sys_cycle) && $gPB(enable_helpdesc_for_udc) } {
        set def_ui_help_descript $cycle_event::($evt_obj,def_help_descript)
        set def_ui_help_url $cycle_event::($evt_obj,def_help_url)
       }
       set param_obj_list_for_output [list]
       foreach obj $def_param_obj_list {
        if {[lsearch $gPB(sys_def_param_obj_list) $obj] < 0} {
         lappend param_obj_list_for_output $obj
        }
       }
       set def_param_obj_list $param_obj_list_for_output
       if {$cycle_event::($evt_obj,def_is_sys_cycle) == 1} {
        lappend old_code "      SYS_CYCLE $def_name"
        lappend old_code "      \{"
         if ![string match $def_ui_label ""] {
          lappend old_code "        UI_LABEL \"$def_ui_label\""
         }
         } else {
         lappend old_code "      CYCLE $def_name"
         lappend old_code "      \{"
          if ![string match $def_ui_label ""] {
           lappend old_code "        UI_LABEL \"$def_ui_label\""
          }
          if $gPB(enable_helpdesc_for_udc) {
           if { ![string match $def_ui_help_descript ""] || ![string match $def_ui_help_url ""] } {
            lappend old_code "        UI_HELP \"$def_ui_help_descript\" \"$def_ui_help_url\""
           }
          }
         }
        }
        foreach paramobj $param_obj_list {
         set type [string trim [classof $paramobj] ::]
         switch -exact $type {
          param::integer {
           set param_name $param::integer::($paramobj,name)
           set param_type "i"
           set param_defv $param::integer::($paramobj,default)
           set param_toggle $param::integer::($paramobj,toggle)
           set param_label $param::integer::($paramobj,ui_label)
           lappend new_code "        PARAM $param_name"
           lappend new_code "        \{"
            lappend new_code "           TYPE $param_type"
            lappend new_code "           DEFVAL \"$param_defv\""
            if ![string match $param_toggle ""] {
             lappend new_code "           TOGGLE $param_toggle"
            }
            if ![string match $param_label ""] {
             lappend new_code "           UI_LABEL \"$param_label\""
            }
           lappend new_code "        \}"
          }
          param::double  {
           set param_name $param::double::($paramobj,name)
           set param_type "d"
           set param_defv $param::double::($paramobj,default)
           set param_toggle $param::double::($paramobj,toggle)
           set param_label $param::double::($paramobj,ui_label)
           lappend new_code "        PARAM $param_name"
           lappend new_code "        \{"
            lappend new_code "           TYPE $param_type"
            lappend new_code "           DEFVAL \"$param_defv\""
            if ![string match $param_toggle ""] {
             lappend new_code "           TOGGLE $param_toggle"
            }
            if ![string match $param_label ""] {
             lappend new_code "           UI_LABEL \"$param_label\""
            }
           lappend new_code "        \}"
          }
          param::option  {
           set param_name $param::option::($paramobj,name)
           set param_type "o"
           set param_defv $param::option::($paramobj,default)
           set param_toggle $param::option::($paramobj,toggle)
           set param_label  $param::option::($paramobj,ui_label)
           set opt_list [list]
           set temp_list [split $param::option::($paramobj,options) ,]
           foreach opt $temp_list {
            lappend opt_list \"[string trim $opt \"]\"
           }
           set param_optlist [join $opt_list ","]
           lappend new_code "        PARAM $param_name"
           lappend new_code "        \{"
            lappend new_code "           TYPE $param_type"
            lappend new_code "           DEFVAL \"$param_defv\""
            lappend new_code "           OPTIONS $param_optlist"
            if ![string match $param_label ""] {
             lappend new_code "           UI_LABEL \"$param_label\""
            }
           lappend new_code "        \}"
          }
          param::boolean {
           set param_name $param::boolean::($paramobj,name)
           set param_type "b"
           set param_defv $param::boolean::($paramobj,default)
           set param_label $param::boolean::($paramobj,ui_label)
           lappend new_code "        PARAM $param_name"
           lappend new_code "        \{"
            lappend new_code "           TYPE $param_type"
            lappend new_code "           DEFVAL \"$param_defv\""
            if ![string match $param_label ""] {
             lappend new_code "           UI_LABEL \"$param_label\""
            }
           lappend new_code "        \}"
          }
          param::string  {
           set param_name $param::string::($paramobj,name)
           set param_type "s"
           set param_defv $param::string::($paramobj,default)
           set param_toggle $param::string::($paramobj,toggle)
           set param_label $param::string::($paramobj,ui_label)
           lappend new_code "        PARAM $param_name"
           lappend new_code "        \{"
            lappend new_code "           TYPE $param_type"
            if ![string match $param_defv ""] {
             lappend new_code "           DEFVAL \"$param_defv\""
            }
            if ![string match $param_toggle ""] {
             lappend new_code "           TOGGLE $param_toggle"
            }
            if ![string match $param_label ""] {
             lappend new_code "           UI_LABEL \"$param_label\""
            }
           lappend new_code "        \}"
          }
          param::point   {
           set param_name $param::point::($paramobj,name)
           set param_type "p"
           set param_toggle $param::point::($paramobj,toggle)
           set param_label $param::point::($paramobj,ui_label)
           lappend new_code "        PARAM $param_name"
           lappend new_code "        \{"
            lappend new_code "           TYPE $param_type"
            if ![string match $param_toggle ""] {
             lappend new_code "           TOGGLE $param_toggle"
            }
            if ![string match $param_label ""] {
             lappend new_code "           UI_LABEL \"$param_label\""
            }
           lappend new_code "        \}"
          }
          param::bitmap  {
           set param_name $param::bitmap::($paramobj,name)
           set param_type "l"
           set param_defv $param::bitmap::($paramobj,default)
           lappend new_code "        PARAM $param_name"
           lappend new_code "        \{"
            lappend new_code "           TYPE $param_type"
            if ![string match $param_defv ""] {
             lappend new_code "           DEFVAL \"$param_defv\""
            }
           lappend new_code "        \}"
          }
          param::group   {
           set param_name $param::group::($paramobj,name)
           set param_type "g"
           set param_defv $param::group::($paramobj,default)
           set param_label $param::group::($paramobj,ui_label)
           lappend new_code "        PARAM $param_name"
           lappend new_code "        \{"
            lappend new_code "           TYPE $param_type"
            if ![string match $param_defv ""] {
             lappend new_code "           DEFVAL \"$param_defv\""
            }
            if ![string match $param_defv "end"] {
             lappend new_code "           UI_LABEL \"$param_label\""
            }
           lappend new_code "        \}"
          }
          param::vector  {
           set param_name $param::vector::($paramobj,name)
           set param_type "v"
           set param_toggle $param::vector::($paramobj,toggle)
           set param_label $param::vector::($paramobj,ui_label)
           lappend new_code "        PARAM $param_name"
           lappend new_code "        \{"
            lappend new_code "           TYPE $param_type"
            if ![string match $param_toggle ""] {
             lappend new_code "           TOGGLE $param_toggle"
            }
            if ![string match $param_label ""] {
             lappend new_code "           UI_LABEL \"$param_label\""
            }
           lappend new_code "        \}"
          }
         }
        }
        foreach def_paramobj $def_param_obj_list {
         set type [string trim [classof $def_paramobj] ::]
         switch -exact $type {
          param::integer {
           set param_name $param::integer::($def_paramobj,def_name)
           set param_type "i"
           set param_defv $param::integer::($def_paramobj,def_default)
           set param_toggle $param::integer::($def_paramobj,def_toggle)
           set param_label $param::integer::($def_paramobj,def_ui_label)
           lappend old_code "        PARAM $param_name"
           lappend old_code "        \{"
            lappend old_code "           TYPE $param_type"
            lappend old_code "           DEFVAL \"$param_defv\""
            if ![string match $param_toggle ""] {
             lappend old_code "           TOGGLE $param_toggle"
            }
            if ![string match $param_label ""] {
             lappend old_code "           UI_LABEL \"$param_label\""
            }
           lappend old_code "        \}"
          }
          param::double  {
           set param_name $param::double::($def_paramobj,def_name)
           set param_type "d"
           set param_defv $param::double::($def_paramobj,def_default)
           set param_toggle $param::double::($def_paramobj,def_toggle)
           set param_label $param::double::($def_paramobj,def_ui_label)
           lappend old_code "        PARAM $param_name"
           lappend old_code "        \{"
            lappend old_code "           TYPE $param_type"
            lappend old_code "           DEFVAL \"$param_defv\""
            if ![string match $param_toggle ""] {
             lappend old_code "           TOGGLE $param_toggle"
            }
            if ![string match $param_label ""] {
             lappend old_code "           UI_LABEL \"$param_label\""
            }
           lappend old_code "        \}"
          }
          param::option  {
           set param_name $param::option::($def_paramobj,def_name)
           set param_type "o"
           set param_defv $param::option::($def_paramobj,def_default)
           set param_toggle $param::option::($def_paramobj,def_toggle)
           set param_label  $param::option::($def_paramobj,def_ui_label)
           set opt_list [list]
           set temp_list [split $param::option::($def_paramobj,def_options) ,]
           foreach opt $temp_list {
            lappend opt_list \"[string trim $opt \"]\"
           }
           set param_optlist [join $opt_list ","]
           lappend old_code "        PARAM $param_name"
           lappend old_code "        \{"
            lappend old_code "           TYPE $param_type"
            lappend old_code "           DEFVAL \"$param_defv\""
            lappend old_code "           OPTIONS $param_optlist"
            if ![string match $param_label ""] {
             lappend old_code "           UI_LABEL \"$param_label\""
            }
           lappend old_code "        \}"
          }
          param::boolean {
           set param_name $param::boolean::($def_paramobj,def_name)
           set param_type "b"
           set param_defv $param::boolean::($def_paramobj,def_default)
           set param_label $param::boolean::($def_paramobj,def_ui_label)
           lappend old_code "        PARAM $param_name"
           lappend old_code "        \{"
            lappend old_code "           TYPE $param_type"
            lappend old_code "           DEFVAL \"$param_defv\""
            if ![string match $param_label ""] {
             lappend old_code "           UI_LABEL \"$param_label\""
            }
           lappend old_code "        \}"
          }
          param::string  {
           set param_name $param::string::($def_paramobj,def_name)
           set param_type "s"
           set param_defv $param::string::($def_paramobj,def_default)
           set param_toggle $param::string::($def_paramobj,def_toggle)
           set param_label $param::string::($def_paramobj,def_ui_label)
           lappend old_code "        PARAM $param_name"
           lappend old_code "        \{"
            lappend old_code "           TYPE $param_type"
            if ![string match $param_defv ""] {
             lappend old_code "           DEFVAL \"$param_defv\""
            }
            if ![string match $param_toggle ""] {
             lappend old_code "           TOGGLE $param_toggle"
            }
            if ![string match $param_label ""] {
             lappend old_code "           UI_LABEL \"$param_label\""
            }
           lappend old_code "        \}"
          }
          param::point   {
           set param_name $param::point::($def_paramobj,def_name)
           set param_type "p"
           set param_toggle $param::point::($def_paramobj,def_toggle)
           set param_label $param::point::($def_paramobj,def_ui_label)
           lappend old_code "        PARAM $param_name"
           lappend old_code "        \{"
            lappend old_code "           TYPE $param_type"
            if ![string match $param_toggle ""] {
             lappend old_code "           TOGGLE $param_toggle"
            }
            if ![string match $param_label ""] {
             lappend old_code "           UI_LABEL \"$param_label\""
            }
           lappend old_code "        \}"
          }
          param::bitmap   {
           set param_name $param::bitmap::($def_paramobj,def_name)
           set param_type "l"
           set param_defv $param::bitmap::($def_paramobj,def_default)
           lappend old_code "        PARAM $param_name"
           lappend old_code "        \{"
            lappend old_code "           TYPE $param_type"
            if ![string match $param_defv ""] {
             lappend old_code "           DEFVAL \"$param_defv\""
            }
           lappend old_code "        \}"
          }
          param::group   {
           set param_name $param::group::($def_paramobj,def_name)
           set param_type "g"
           set param_defv $param::group::($def_paramobj,def_default)
           set param_label $param::group::($def_paramobj,def_ui_label)
           lappend old_code "        PARAM $param_name"
           lappend old_code "        \{"
            lappend old_code "           TYPE $param_type"
            if ![string match $param_defv ""] {
             lappend old_code "           DEFVAL \"$param_defv\""
            }
            if ![string match $param_defv "end"] {
             lappend old_code "           UI_LABEL \"$param_label\""
            }
           lappend old_code "        \}"
          }
          param::vector  {
           set param_name $param::vector::($def_paramobj,def_name)
           set param_type "v"
           set param_toggle $param::vector::($def_paramobj,def_toggle)
           set param_label $param::vector::($def_paramobj,def_ui_label)
           lappend old_code "        PARAM $param_name"
           lappend old_code "        \{"
            lappend old_code "           TYPE $param_type"
            if ![string match $param_toggle ""] {
             lappend old_code "           TOGGLE $param_toggle"
            }
            if ![string match $param_label ""] {
             lappend old_code "           UI_LABEL \"$param_label\""
            }
           lappend old_code "        \}"
          }
         }
        }
       lappend new_code "      \}"
      lappend old_code "      \}"
     }

#=======================================================================
proc UI_PB_prv_OutputUde {text_widget code} {
  $text_widget config -state normal
  $text_widget delete 1.0 end
  $text_widget insert end "\n"
  set i [llength $code]
  for {set j 0} {$j < $i} {incr j} {
   $text_widget insert end "[lindex $code $j]\n"
  }
  if ![string compare $::tix_version 8.4] {
   UI_PB_com_HighlightUdeKeywords $text_widget
  }
  $text_widget config -state disabled
 }
