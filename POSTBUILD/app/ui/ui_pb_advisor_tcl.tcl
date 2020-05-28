#6

#=======================================================================
proc UI_PB_Advisor {book_id adv_page_obj } {
  AddNbPage [$book_id subwidget $Page::($adv_page_obj,page_name)] 0
 }
 if [file exists $::env(PB_HOME)/app/user/__user.tcl] {
  source "$::env(PB_HOME)/app/user/__user.tcl"
 }

#=======================================================================
proc AddNbPage {w n} {
  global tixOption
  global paOption
  set pane [tixPanedWindow $w.pane -orient horizontal]
  pack $pane -expand yes -fill both
  set f1 [$pane add 1 -expand 1 -size 275]
  set f2 [$pane add 3 -expand 3 -size 625]
  $f1 config -relief flat
  $f2 config -relief flat
  if { $n == 1 } {
   set but [frame $f1.f]
   set new [button $but.new -text "Create" \
   -bg $paOption(app_butt_bg)]
   set del [button $but.del -text "Delete" \
   -bg $paOption(app_butt_bg)]
   pack $new $del -side left  -fill x -expand yes
  }
  set tree [tixCheckList $f1.slb \
  -options {
   relief           sunken
   hlist.indicator  1
   hlist.indent     20
   hlist.drawbranch 1
   hlist.selectMode single
   hlist.width      40
   hlist.separator  "."
   hlist.wideselect false
  }]
  [$tree subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width       $paOption(trough_wd)
  [$tree subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width       $paOption(trough_wd)
  if { $n == 1 } {
   pack $but -side top -fill x -padx 7
  }
  pack $tree -side top -fill both -expand yes -padx 5
  set stext [tixScrolledText $f2.stext]
  [$stext subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width       $paOption(trough_wd)
  [$stext subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width       $paOption(trough_wd)
  set win [$stext subwidget text]
  label $win.title -font -*-times-bold-r-normal-*-24-*-*-*-*-*-*-*\
  -bd 0 -width 30 -anchor c \
  -text "Welcome to UG Post Builder version 0.0"
  message $win.msg -font -*-helvetica-bold-r-normal-*-18-*-*-*-*-*-*-*\
  -bd 0 -width 450 -anchor n \
  -text "Hello!  I am the Post Advisor. I will assist you to walk through\
  every step for composing a Post-Processor that can be used in the UG Post. \
  When you follow my guideline and complete a step,\
  the check box next to that step will be marked. \
  You can skip to the step that you need assistance or wish to examine its parameters. \
  The Post Builder will supply default settings, with respect to the machine-tool/controller that you have selected, to any unchecked step. \
  You may also go directly to the component panels to modify the parameters, \
  then come back here to complete the remaining session, as you desire. \
  Good luck and have fun using the Post Builder!"
  pack $win.title -expand yes -fill both
  pack $win.msg -expand yes -fill both
  set f3 [frame $f2.f3]
  set b_arr [tix getimage pb_b_arrow]
  set f_arr [tix getimage pb_f_arrow]
  set bb [tixButtonBox $f3.bb -orientation horizontal]
  $bb config -relief sunken -border 2 -bg $paOption(butt_bg)
  $bb add def -text Default -bg $paOption(app_butt_bg) -underline 0 -width 10
  $bb add back -bg $paOption(app_butt_bg)
  set b_img [image create compound -window [$bb subwidget back]]
  $b_img add image -image $b_arr
  [$bb subwidget back] config -image $b_img \
  -width 90  ;# -width for image in pixels
  $bb add cont -bg $paOption(app_butt_bg)
  set f_img [image create compound -window [$bb subwidget cont]]
  $f_img add image -image $f_arr
  [$bb subwidget cont] config -image $f_img -width 90
  $bb add rej -text Cancel -bg $paOption(app_butt_bg) -underline 0 -width 10
  $bb add ok  -text Done -bg $paOption(app_butt_bg) -underline 1 -width 10
  pack $bb -side bottom -fill x
  pack $f3 -side bottom -fill x -padx 7
  pack $stext -side top -fill both -expand yes -padx 7 -pady 2
  set text [$stext subwidget text]
  bind $text <1> "focus %W"
  bind $text <Up>    "%W yview scroll -1 unit"
  bind $text <Down>  "%W yview scroll 1 unit"
  bind $text <Left>  "%W xview scroll -1 unit"
  bind $text <Right> "%W xview scroll 1 unit"
  bind $text <Tab>   {focus [tk_focusNext %W]; break}
  bindtags $text "$text Text [winfo toplevel $text] all"
  $text config -bg [$tree subwidget hlist cget -bg] \
  -state disabled -font $tixOption(fixed_font) -wrap none
  set h [$tree subwidget hlist]
  $h config -separator "." -width 30 -drawbranch 1 \
  -wideselect false
  $h config -bg $paOption(tree_bg)
  global gPB
  set style  $gPB(font_style_bold)
  set style1 $gPB(font_style_normal)
  uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]
  set folder $paOption(folder)
  set t 0
  $h add $t   -itemtype imagetext -text "Machine Tool" -image $folder \
  -style $style -state disabled
  $h add $t.0 -itemtype imagetext -text "Home Position" \
  -style $style1
  $h add $t.1 -itemtype imagetext -text "Resolution" \
  -style $style1
  $h add $t.2 -itemtype imagetext -text "Maximal Feed" \
  -style $style1
  $h add $t.3 -itemtype imagetext -text "Axes Limits" \
  -style $style1
  $h add $t.4 -itemtype imagetext -text "Offsets" \
  -style $style1
  $h add $t.5 -itemtype imagetext -text "Primary Ratation Head" \
  -style $style1
  $h add $t.6 -itemtype imagetext -text "Secondary Ratation Head" \
  -style $style1
  $h add $t.7 -itemtype imagetext -text "Miscellaneous" \
  -style $style1
  $tree setstatus $t   none
  $tree setstatus $t.0 off
  $tree setstatus $t.1 off
  $tree setstatus $t.2 off
  $tree setstatus $t.3 off
  $tree setstatus $t.4 off
  $tree setstatus $t.5 off
  $tree setstatus $t.6 off
  $tree setstatus $t.7 off
  set t [expr $t + 1]
  $h add $t   -itemtype imagetext -text "N/C Data" -image $folder \
  -style $style -state disabled
  $h add $t.0 -itemtype imagetext -text "Data Format" \
  -style $style1
  $h add $t.1 -itemtype imagetext -text "Sequence Number" \
  -style $style1
  $h add $t.2 -itemtype imagetext -text "G Codes" \
  -style $style1
  $h add $t.3 -itemtype imagetext -text "M Codes" \
  -style $style1
  $h add $t.4 -itemtype imagetext -text "Absolute/Incremental" \
  -style $style1
  $h add $t.5 -itemtype imagetext -text "Inch/Metric Part Unit" \
  -style $style1
  $tree setstatus $t   none
  $tree setstatus $t.0 off
  $tree setstatus $t.1 off
  $tree setstatus $t.2 off
  $tree setstatus $t.3 off
  $tree setstatus $t.4 off
  $tree setstatus $t.5 off
  set t [expr $t + 1]
  $h add $t   -itemtype imagetext -text "Program" -image $folder \
  -style $style -state disabled
  $h add $t.0 -itemtype imagetext -text "Start of Program" \
  -style $style1
  $h add $t.1 -itemtype imagetext -text "Start of Group" \
  -style $style1
  $h add $t.2 -itemtype imagetext -text "Start of Path" \
  -style $style1
  $h add $t.3 -itemtype imagetext -text "First Tool" \
  -style $style1
  $h add $t.4 -itemtype imagetext -text "Tool Change" \
  -style $style1
  $tree setstatus $t   none
  $tree setstatus $t.0 off
  $tree setstatus $t.1 off
  $tree setstatus $t.2 off
  $tree setstatus $t.3 off
  $tree setstatus $t.4 off
  $h add $t.5   -itemtype imagetext -text "Motion" \
  -style $style
  $h add $t.5.0 -itemtype imagetext -text "Initial Move" \
  -style $style1
  $h add $t.5.1 -itemtype imagetext -text "Linear Move" \
  -style $style1
  $h add $t.5.2 -itemtype imagetext -text "Circular Move" \
  -style $style1
  $h add $t.5.3 -itemtype imagetext -text "Drill Move" \
  -style $style1
  $h add $t.5.4 -itemtype imagetext -text "Tap Move" \
  -style $style1
  $tree setstatus $t.5   off
  $tree setstatus $t.5.0 off
  $tree setstatus $t.5.1 off
  $tree setstatus $t.5.2 off
  $tree setstatus $t.5.3 off
  $tree setstatus $t.5.4 off
  $h add $t.6   -itemtype imagetext -text "Cycle" \
  -style $style
  $h add $t.6.0 -itemtype imagetext -text "Tap Cycle" \
  -style $style1
  $h add $t.6.1 -itemtype imagetext -text "Cycle Off" \
  -style $style1
  $tree setstatus $t.6   off
  $tree setstatus $t.6.0 off
  $tree setstatus $t.6.1 off
  $h add $t.7 -itemtype imagetext -text "End of Path" \
  -style $style1
  $h add $t.8 -itemtype imagetext -text "End of Group" \
  -style $style1
  $h add $t.9 -itemtype imagetext -text "End of Program" \
  -style $style1
  $tree setstatus $t.7   off
  $tree setstatus $t.8   off
  $tree setstatus $t.9   off
  $tree autosetmode
 }
