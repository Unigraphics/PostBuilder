source $env(PB_HOME)/app/ui/ui_pb_debug.tcl
set gPB(Session_Log)   [file nativename "$env(HOME)/pb_session.log"]
if [file exists $gPB(Session_Log)] {
 catch { source "$gPB(Session_Log)" }
}
set gPB(Postbuilder_Version)       "2001.0.0"
set release_date                   "12/31/2001"
set gPB(Postbuilder_Release_Date)  [clock format [clock scan $release_date] -format "%x"]
set gPB(Postbuilder_PUI_Version)   "2001.0.0"
set phase                          ".1"
set gPB(Postbuilder_PUI_Version)   "$gPB(Postbuilder_PUI_Version)$phase"
set vi  [string last "." $gPB(Postbuilder_Version)]
set ver [string range $gPB(Postbuilder_Version) 0 [expr $vi - 1]]
set ver [expr $ver - 1999.0]
set ext [string range $gPB(Postbuilder_Version) $vi end]
set gPB(Postbuilder_Release)       \
"$gPB(main,title,UG)/$gPB(main,title,Post_Builder) $gPB(main,title,Version) $ver$ext"
set gPB(Postbuilder_Release_About) \
"$gPB(main,title,UG)/$gPB(main,title,Post_Builder) $gPB(main,title,Version)\
$ver$ext$phase  ($gPB(Postbuilder_Release_Date))\n\n"
set gPB(Output_Dir)   ""
set gPB(User_Def_Blk)   "user_blk"
set gPB(User_Def_Add)   "user_add"
set gPB(User_Def_Fmt)   "user_fmt"
set gPB(MOM_obj_name_len)  32
tix addbitmapdir [tixFSJoin $env(PB_HOME) images]
set tixOption(font)   $gPB(font)
set tixOption(font_sm)  $gPB(font_sm)
set tixOption(bold_font)  $gPB(bold_font)
set tixOption(bold_font_lg)  $gPB(bold_font_lg)
set tixOption(italic_font)  $gPB(italic_font)
set tixOption(fixed_font)  $gPB(fixed_font)
set tixOption(fixed_font_sm)  $gPB(fixed_font_sm)
option add *font $tixOption(bold_font) $tixOption(prioLevel)
set paOption(title_bg)  darkSeaGreen3
set paOption(title_fg)  lightYellow
set paOption(table_bg)  lightSkyBlue
set paOption(app_bg)   #9676a2 ;#
set paOption(tree_bg)   lightYellow 
set paOption(butt_bg)   Gold1 ;#
set paOption(app_butt_bg)  #d0c690 ;# #a8d464
set paOption(can_bg)   #ace8d2
set paOption(can_trough_bg)  #7cdabc
set paOption(trough_bg)  #f0da1c
set paOption(trough_wd)  12
set paOption(file)   [tix getimage pb_textfile]
set paOption(folder)   [tix getimage pb_folder]
set paOption(format)   [tix getimage pb_format]
set paOption(address)   [tix getimage pb_address]
set paOption(popup)   #e3e3e3
set paOption(seq_bg)   yellow ;#Aquamarine1 AntiqueWhite CadetBlue1 #8ceeb6
set paOption(seq_fg)   blue3 
set paOption(event)   skyBlue3
set paOption(cell_color)  paleTurquoise
set paOption(active_color)  burlyWood1
set paOption(focus)   lightYellow
set paOption(balloon)   yellow
set paOption(select_clr)  orange 
set paOption(menu_bar_bg)  lightBlue 
set paOption(text)   lightSkyBlue
set paOption(disabled_fg)  gray
set paOption(tree_disabled_fg) lightGray
set paOption(header_bg)  royalBlue
set paOption(special_bg)  navyBlue
set paOption(special_fg)  white
set paOption(entry_disabled_bg) lightBlue
set paOption(sunken_bg)  pink
set paOption(raised_bg)  #c0c0ff
set paOption(name_bg)   slateGray4 ;# darkSeaGreen3 ;# deepSkyBlue4 
option add *Label.font  $tixOption(font)
option add *Menu.background  gray95
option add *Menu.activeBackground blue
option add *Menu.activeForeground yellow
option add *Menu.selectColor  $paOption(select_clr)
option add *Menu.activeBorderWidth 0
option add *Menu.font   $tixOption(bold_font)
option add *Menu.cursor               hand2
option add *Button.cursor   hand2
option add *Button.activeBackground  $paOption(focus)
option add *Button.activeForeground  black
option add *Button.disabledForeground  $paOption(disabled_fg)
option add *Menubutton.cursor   hand2
option add *Menubutton.activeBackground $paOption(focus)
option add *Checkbutton.cursor  hand2
option add *Checkbutton.activeBackground $paOption(focus)
option add *Checkbutton.disabledForeground $paOption(disabled_fg)
option add *Checkbutton.selectColor  $paOption(select_clr)
option add *Checkbutton.font   $tixOption(font)
option add *Radiobutton.cursor  hand2
option add *Radiobutton.activeBackground $paOption(focus)
option add *Radiobutton.disabledForeground $paOption(disabled_fg)
option add *Radiobutton.selectColor  $paOption(select_clr)
option add *Radiobutton.font   $tixOption(font)
option add *Entry.font   $tixOption(font)
option add *TixOptionMenu.cursor  hand2
option add *TixOptionMenu.label.font  $tixOption(font)
option add *TixNoteBook.tagPadX  6
option add *TixNoteBook.tagPadY  4
option add *TixNoteBook.borderWidth  2
option add *TixLabelFrame.label.font  $tixOption(italic_font)
option add *TixLabelEntry.label.font  $tixOption(font)
option add *TixButtonBox.background  $paOption(butt_bg)
option add *Dialog.msg.wrapLength  4i
set gPB(font_style_normal) [tixDisplayStyle imagetext \
-bg $paOption(tree_bg) -padx 4 -pady 1 -font $tixOption(font) \
-selectforeground blue]
set gPB(font_style_bold) [tixDisplayStyle imagetext \
-bg $paOption(tree_bg) -padx 4 -pady 2 -font $tixOption(bold_font) \
-selectforeground blue]
set gPB(font_style_normal_gray) [tixDisplayStyle imagetext \
-fg $paOption(tree_disabled_fg) \
-bg $paOption(tree_bg) \
-padx 4 -pady 1 -font $tixOption(font)]
set gPB(font_style_bold_gray) [tixDisplayStyle imagetext \
-fg $paOption(tree_disabled_fg) \
-bg $paOption(tree_bg) \
-padx 4 -pady 2 -font $tixOption(bold_font)]

#=======================================================================
proc UI_PB_AddPatchMsg { s } {
  global gPB
  set gPB(Postbuilder_Release_About) "$gPB(Postbuilder_Release_About)\n\
  $s"
 }

#=======================================================================
proc UI_PB_main {w} {
  global auto_path gPB_dir
  global paOption tixOption
  global gPB
  set gPB(active_window_list)     [list]
  set gPB(active_window)          ""
  set gPB(top_window)             ""
  set gPB(top_window).new         ""
  set gPB(top_window).open        ""
  set gPB(main_window)            ""
  set gPB(main_window_disabled)   0
  set gPB(toplevel_list)          [list]
  set gPB(help_win_id)            0
  set gPB(native_dialog_present)  0
  set gPB(screen_width)  [winfo vrootwidth .] 
  set gPB(screen_height) [winfo vrootheight .]
  if ![info exists gPB_dir] {
   set script [info script]
   if {$script != {}} {
     set gPB_dir [file dirname $script]
     } else {
     set gPB_dir [pwd]
    }
    set gPB_dir [tixFSAbsPath $gPB_dir]
   }
   lappend auto_path $gPB_dir
   tix addbitmapdir [tixFSJoin $gPB_dir bitmaps]
   toplevel     $w
   wm title     $w "$gPB(Postbuilder_Release) Beta"
   set xc 0 
   set yc 0
   set gPB(TOP_WIN_HI) 107
   wm geometry  $w 1000x$gPB(TOP_WIN_HI)+$xc+$yc
   wm protocol  $w WM_DELETE_WINDOW "UI_PB_ExitPost"
   $w config -bg $paOption(app_bg)
   set gPB(top_window) $w
   UI_PB_com_ClaimActiveWindow $w
   set main_menu [UI_PB__main_menu   $w]
   set status    [UI_PB__main_status $w]
   set gPB(main_menu)  $main_menu
   pack $main_menu -side top    -fill x
   pack $status    -side bottom -fill x
   pack forget [$gPB(help_tool) subwidget dia]
   $gPB(file_tool).frame config -bg $paOption(table_bg)
   $gPB(help_tool).frame config -bg $paOption(table_bg)
   __main_AddOptionsMenu
   UI_PB_AddVisitedPosts
   set mb $gPB(main_menu_bar)
   set gPB(c_help,$mb.file)                                  "main,file"
   set gPB(c_help,$mb.file.m)                                "main,file,menu"
   set gPB(c_help,$mb.file.m,$gPB(menu_index,file,new))      "main,file,new"
   set gPB(c_help,$mb.file.m,$gPB(menu_index,file,open))     "main,file,open"
   set gPB(c_help,$mb.file.m,$gPB(menu_index,file,mdfa))     "main,file,mdfa"
   set gPB(c_help,$mb.file.m,$gPB(menu_index,file,save))     "main,file,save"
   set gPB(c_help,$mb.file.m,$gPB(menu_index,file,save_as))  "main,file,save_as"
   set gPB(c_help,$mb.file.m,$gPB(menu_index,file,close))    "main,file,close"
   set gPB(c_help,$mb.file.m,$gPB(menu_index,file,exit))     "main,file,exit"
   set gPB(c_help,$mb.file.m,$gPB(menu_index,file,history))  "main,file,history"
   set gPB(c_help,$mb.help)                                  "main,help"
   set gPB(c_help,$mb.help.m)                                "main,help,menu"
   set gPB(c_help,$mb.help.m,$gPB(menu_index,help,bal))      "main,help,bal"
   set gPB(c_help,$mb.help.m,$gPB(menu_index,help,chelp))    "main,help,chelp"
   set gPB(c_help,$mb.help.m,$gPB(menu_index,help,manual))   "main,help,manual"
   set gPB(c_help,$mb.help.m,$gPB(menu_index,help,about))    "main,help,about"
   set gPB(c_help,$mb.help.m,$gPB(menu_index,help,acknow))   "main,help,acknow"
   set gPB(c_help,[$main_menu.tool subwidget new]) "tool,new"
   set gPB(c_help,[$main_menu.tool subwidget open]) "tool,open"
   set gPB(c_help,[$main_menu.tool subwidget save]) "tool,save"
   set gPB(c_help,[$main_menu.help subwidget bal]) "tool,bal"
   set gPB(c_help,[$main_menu.help subwidget man]) "tool,manual"
   set gPB(c_help,tool_button) [$main_menu.help subwidget inf]
   $mb.file.m entryconfigure $gPB(menu_index,file,save)    -state disabled
   $mb.file.m entryconfigure $gPB(menu_index,file,save_as) -state disabled
   $mb.file.m entryconfigure $gPB(menu_index,file,close)   -state disabled
   [$main_menu.tool subwidget save] config -state disabled
   if ![info exists gPB(entry_color)] \
   {
    entry .xxxentry
    set gPB(entry_color) [lindex [.xxxentry config -bg] end]
    tixDestroy .xxxentry
   }
   update
   set xxc [winfo rootx $gPB(top_window)]
   set yyc [winfo rooty $gPB(top_window)]
   set gPB(WIN_X) [expr $xxc - $xc] 
   set gPB(WIN_Y) [expr $yyc - $yc] 
   set gPB(win_max_width)  [expr $gPB(screen_width)  - $gPB(WIN_X) - $gPB(WIN_X)]
   set gPB(win_max_height) [expr $gPB(screen_height) - $gPB(WIN_Y) - $gPB(WIN_X)]
   UI_PB_com_PositionWindow $w
   wm resizable $w 0 0
   bind all <Control-x> ""
   bind all <Control-o> ""
   bind all <Control-g><Control-s><Control-l> HelpCmd_ack
   bind all <F1> HelpCmd_man
   if { [info exists gPB(PB_LICENSE)] } {
    if { $gPB(PB_LICENSE) == "UG_POST_NO_LICENSE" } {
     __NoLicenseMsg
    }
   }
  }

#=======================================================================
proc UI_PB_OpenCmdLinePost {} {
  global gPB
  if [info exists gPB(CMD_LINE_PUI)] {
   UI_PB_file_EditPost 0 $gPB(CMD_LINE_PUI) 1
  }
 }

#=======================================================================
proc __main_AddOptionsMenu {} {
  global gPB paOption
  set w $gPB(main_menu_bar)
  menubutton $w.option -menu $w.option.m -text $gPB(main,options,Label) -underline 0 \
  -takefocus 1 -bg $paOption(menu_bar_bg)
  pack $w.option -side left -padx 10
  menu $w.option.m -tearoff 0
  set gPB(option_menu) $w.option.m
  set m $gPB(option_menu).opts
  $gPB(option_menu) add cascade -label "$gPB(main,options,cmd_check,Label)" \
  -menu $m
  menu $m -tearoff 1
  set opt(0) $gPB(main,options,cmd_check,syntax,Label)
  set opt(1) $gPB(main,options,cmd_check,command,Label)
  set opt(2) $gPB(main,options,cmd_check,block,Label)
  set opt(3) $gPB(main,options,cmd_check,address,Label)
  set opt(4) $gPB(main,options,cmd_check,format,Label)
  if { ![info exists gPB(check_cc_syntax_error)] } {
   set gPB(check_cc_syntax_error)     1
  }
  if { ![info exists gPB(check_cc_unknown_command)] } {
   set gPB(check_cc_unknown_command)  0
  }
  if { ![info exists gPB(check_cc_unknown_block)] } {
   set gPB(check_cc_unknown_block)    0
  }
  if { ![info exists gPB(check_cc_unknown_address)] } {
   set gPB(check_cc_unknown_address)  0
  }
  if { ![info exists gPB(check_cc_unknown_format)] } {
   set gPB(check_cc_unknown_format)   0
  }
  set var(0) gPB(check_cc_syntax_error)
  set var(1) gPB(check_cc_unknown_command)
  set var(2) gPB(check_cc_unknown_block)
  set var(3) gPB(check_cc_unknown_address)
  set var(4) gPB(check_cc_unknown_format)
  for {set i 0} {$i < 5} {incr i} \
  {
   $m add checkbutton -label "$opt($i)" \
   -variable $var($i) -onvalue 1 -offvalue 0
  }
  $gPB(option_menu) add separator
  set m $gPB(option_menu).bck
  $gPB(option_menu) add cascade -label "$gPB(main,options,backup,Label)" \
  -menu $m
  menu $m -tearoff 0
  $m add radiobutton -label "$gPB(main,options,backup,one,Label)" -indicatoron 1 \
  -variable gPB(backup_method) -value "BACKUP_ONE"
  $m add radiobutton -label "$gPB(main,options,backup,all,Label)" -indicatoron 1 \
  -variable gPB(backup_method) -value "BACKUP_ALL"
  $m add radiobutton -label "$gPB(main,options,backup,none,Label)" -indicatoron 1 \
  -variable gPB(backup_method) -value "NO_BACKUP"
  PB_enable_balloon $w.option
  set gPB_help_tips($w.option)   {$gPB(main,options,Balloon)}
 }

#=======================================================================
proc UI_PB_AddVisitedPosts {} {
  global gPB
  if { [info exists gPB(file_menu_posts_list)] } \
  {
   catch { $gPB(file_menu_posts_list) delete 0 end }
   destroy $gPB(file_menu_posts_list)
   unset gPB(file_menu_posts_list)
   catch { $gPB(file_menu) delete $gPB(menu_index,file,sep) $gPB(menu_index,file,history) }
  }
  if { $gPB(post_history_menu_len) == -1 } {
   return
  }
  if { [info exists gPB(open_files_list)]  &&  [llength $gPB(open_files_list)] } \
  {
   set gPB(file_menu_posts_list) $gPB(file_menu).posts_list
   set m $gPB(file_menu_posts_list)
   $gPB(file_menu) add separator
   if { $gPB(post_history_menu_len) } \
   {
    $gPB(file_menu) add cascade -label "$gPB(main,file,history,Label)" \
    -menu $m
    menu $m -tearoff 0
    set i 0
    foreach f $gPB(open_files_list) \
    {
     $m add command -label "[file rootname [file nativename $f]]" \
     -command "UI_PB_OpenVisitedPost $f"
     incr i
     if { $i == $gPB(post_history_menu_len) } {
      break
     }
    }
    $m add separator
    $m add command -label "$gPB(nav_button,manage,Label) ..." -command "__CreateVisitedPostsList"
   } else \
   {
    $gPB(file_menu) add command -label "$gPB(main,file,history,Label) ..." \
    -command "__CreateVisitedPostsList"
   }
  }
 }

#=======================================================================
proc __RefreshVisitedPostsMenu { } {
  global gPB
  if { $gPB(use_info) } \
  {
   UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
   return
  }
  set new_list [list]
  foreach f $gPB(open_files_list) \
  {
   if [file exists $f] \
   {
    if { [lsearch $new_list "$f"] == -1 } {
     lappend new_list $f
    }
   }
  }
  set gPB(open_files_list) $new_list
  UI_PB_AddVisitedPosts
 }

#=======================================================================
proc __CreateVisitedPostsList { args } {
  global gPB
  global paOption
  if { $gPB(use_info) } \
  {
   UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
   return
  }
  set win [toplevel $gPB(top_window).history]
  set title "$gPB(main,file,history,Label)"
  UI_PB_com_CreateTransientWindow $win "$title" "500x300+300+100" "" "" \
  "destroy $win" "__CancelVisitedPost $win"
  frame $win.f -relief flat
  pack $win.f -side top -expand yes -fill both
  set tl [tixScrolledListBox $win.f.tl -options {
   listbox.selectMode single
  } \
  -command "__OpenVisitedPost $win"]
  pack $tl -side left -expand yes -fill both -padx 3 -pady 3
  set tlist [$tl subwidget listbox]
  foreach pname $gPB(open_files_list) \
  {
   set f [file rootname [file nativename $pname]]
   $tlist insert end "$f"
  }
  $tlist selection set 0
  set bf [frame $win.f.b -relief flat]
  pack $bf -side right -fill both
  set ref_b [button $bf.ref -text $gPB(nav_button,refresh,Label) \
  -bg $paOption(app_butt_bg) \
  -command "__RefreshVisitedPostsList $tlist"]
  set cut_b [button $bf.cut -text $gPB(nav_button,cut,Label) \
  -bg $paOption(app_butt_bg) \
  -command "__CutVisitedPost $bf $tlist"]
  set pas_b [button $bf.pas -text $gPB(nav_button,paste,Label) \
  -bg $paOption(app_butt_bg) \
  -command "__PasteVisitedPost $bf $tlist"]
  __SetPasteButtonState $bf
  pack $ref_b $cut_b $pas_b -side top -fill x -padx 3 -pady 3
  set gPB(c_help,$ref_b)     "nav_button,refresh"
  set gPB(c_help,$cut_b)     "nav_button,cut"
  set gPB(c_help,$pas_b)     "nav_button,paste"
  frame $win.b -relief flat
  pack $win.b -side bottom -expand no -fill x -padx 3 -pady 3
  set box1 [frame $win.b.1]
  set cb_arr(gPB(nav_button,open,Label))   "__OpenVisitedPost $win"
  set cb_arr(gPB(nav_button,cancel,Label)) "__CancelVisitedPost $win"
  tixForm $box1 -top 0 -left 0 -right %100
  set label_list1 { "gPB(nav_button,open,Label)" "gPB(nav_button,cancel,Label)" }
  UI_PB_com_CreateButtonBox $box1 label_list1 cb_arr
  UI_PB_GrayOutAllFileOptions
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc __SetPasteButtonState { frm } {
  global gPB
  set paste_button $frm.pas
  if [info exists gPB(post_history_paste_buffer)] \
  {
   $paste_button config -state normal
  } else \
  {
   $paste_button config -state disabled
  }
 }

#=======================================================================
proc __RefreshVisitedPostsList { tl } {
  global gPB
  set file_list [list]
  foreach f $gPB(open_files_list) \
  {
   set f [join [split $f "\\"] "/"]
   if [file exists $f] \
   {
    lappend file_list $f
   }
  }
  set new_list [list]
  foreach f $file_list \
  {
   if { [lsearch $new_list $f] < 0 } \
   {
    lappend new_list $f
   }
  }
  set gPB(open_files_list) $new_list
  $tl delete 0 end
  foreach pname $gPB(open_files_list) \
  {
   set f [file rootname [file nativename $pname]]
   $tl insert end "$f"
  }
  $tl selection set 0
 }

#=======================================================================
proc __CutVisitedPost { frm tl } {
  global gPB
  set i [$tl curselection]
  if { $i != "" } \
  {
   $tl delete $i
   set gPB(post_history_paste_buffer) [lindex $gPB(open_files_list) $i]
   set gPB(open_files_list) [lreplace $gPB(open_files_list) $i $i]
   __SetPasteButtonState $frm
   $tl selection set $i
   $tl activate $i
  }
 }

#=======================================================================
proc __PasteVisitedPost { frm tl } {
  global gPB
  if [info exists gPB(post_history_paste_buffer)] \
  {
   set i [$tl curselection]
   if { $i != "" } \
   {
    set f [file rootname [file nativename $gPB(post_history_paste_buffer)]]
    set j [expr $i + 1]
    $tl insert $j $f
    set gPB(open_files_list) [linsert $gPB(open_files_list) $j $gPB(post_history_paste_buffer)]
    unset gPB(post_history_paste_buffer)
    __SetPasteButtonState $frm
    $tl selection clear 0 end
    $tl selection set $j
    $tl activate $j
   }
  }
 }

#=======================================================================
proc __OpenVisitedPost { w } {
  global gPB
  set lb [$w.f.tl subwidget listbox]
  set i [$lb curselection]
  if { $i != "" } \
  {
   set pname [lindex $gPB(open_files_list) $i]
   destroy $w
   UI_PB_OpenVisitedPost $pname
  }
 }

#=======================================================================
proc __CancelVisitedPost { w } {
  UI_PB_OpenCancel_CB; destroy $w
  UI_PB_AddVisitedPosts
 }

#=======================================================================
proc __DisplayAboutPostBuilder {} {
  global gPB
  global paOption
  set gPB(About_Post_Builder_msg) [UI_PB_com_AskActiveWindow].about_pb
  set win [toplevel $gPB(About_Post_Builder_msg)]
  set title "$gPB(main,help,about,Label)"
  set text $gPB(Postbuilder_Release_About)
  set xc [expr [winfo rootx $gPB(top_window)] + 300]
  set yc [expr [winfo rooty $gPB(top_window)] + 300]
  UI_PB_com_CreateTransientWindow $win "$title" "+$xc+$yc" "" "" \
  "grab release $win; destroy $win" \
  "grab release $win; destroy $win"
  set t [frame $win.t -relief sunken -bd 2]
  pack $t -side top -expand yes -fill both
  set b [frame $win.b]
  pack $b -side bottom -expand yes -fill x
  frame $t.f -bg $gPB(entry_color)
  pack $t.f -side right -expand yes -fill both
  label $t.f.l -text $text -font $gPB(bold_font) -justify left \
  -bg $gPB(entry_color)
  pack $t.f.l -padx 10 -pady 10
  label $t.a -image [tix getimage pb_post_builder] -bg $paOption(title_bg)
  pack $t.a -side left -fill y
  frame $b.f -relief sunken -bd 1 -takefocus 1 \
  -highlightcolor black -highlightthickness 1
  pack $b.f -pady 5
  button $b.f.b -text "$gPB(nav_button,ok,Label)" -width 10 \
  -comman "destroy $win" -takefocus 0
  pack $b.f.b -side bottom -padx 1 -pady 1
  UI_PB_com_PositionWindow $win
  wm resizable $gPB(About_Post_Builder_msg) 0 0
  grab set $win
 }

#=======================================================================
proc __NoLicenseMsg {} {
  global gPB
  global paOption
  tkwait visibility $gPB(top_window)
  set gPB(NO_LICENSE_msg) $gPB(top_window).no_license
  set win [toplevel $gPB(NO_LICENSE_msg)]
  set title $gPB(msg,no_license_title)
  set text $gPB(msg,no_license_dialog)
  set xc [expr [winfo rootx $gPB(top_window)] + 300]
  set yc [expr [winfo rooty $gPB(top_window)]]
  UI_PB_com_CreateTransientWindow $win "$title" "+$xc+$yc" "" \
  "" "return" "return" 0
  UI_PB_com_DismissActiveWindow $win
  frame $win.f -relief sunken -bd 2 -bg $gPB(entry_color)
  pack $win.f -side right -expand yes -fill both
  frame $win.f.b -bg red
  pack $win.f.b -padx 7 -pady 6
  label $win.f.b.l -text $text -font $gPB(bold_font) -justify left \
  -fg yellow -bg red
  pack $win.f.b.l -padx 5 -pady 3
  label $win.a -bitmap error
  pack $win.a -side left -padx 3m -pady 3m
  UI_PB_com_PositionWindow $win
  wm resizable $gPB(NO_LICENSE_msg) 0 0
  UI_PB_com_DeleteFromTopLevelList $gPB(NO_LICENSE_msg)
 }

#=======================================================================
proc CB_HelpCmd { w opt } {
  global gPB
  set idx [lsearch $gPB(help_sel_var) $w]
  switch -exact -- $w \
  {
   man -
   dia -
   wtd {
    if {$idx >= 0} {
     set gPB(help_sel_var) [lreplace $gPB(help_sel_var) $idx $idx]
     } else {
     return
    }
   }
   inf {
    if { $gPB(use_info) && $idx >= 0 } \
    {
     return
     } elseif { !$gPB(use_info) && $idx < 0 } \
    {
     return
     } else {}
   }
   bal {
    if { $gPB(use_info) && $idx >= 0 } \
    {
     return
    }
   }
  }
  switch -exact -- $w \
  {
   man { HelpCmd_man }
   dia { HelpCmd_dia }
   wtd { HelpCmd_wtd }
   inf { HelpCmd_inf }
   bal { HelpCmd_bal }
  }
 }

#=======================================================================
proc HelpCmd_bal {} {
  global gPB
  if {[lsearch $gPB(help_sel_var) bal] >= 0} {
   set gPB(use_bal) 1
   } else {
   set gPB(use_bal) 0
  }
  SetBalloonHelp
 }

#=======================================================================
proc HelpCmd_inf {} {
  global gPB
  if {[lsearch $gPB(help_sel_var) inf] >= 0} {
   set gPB(use_info) 1
   } else {
   set gPB(use_info) 0
  }
  UI_PB_chelp_SetContextHelp
 }

#=======================================================================
proc __MenuItemCmd_nyi { m } {
  global gPB
  if { $gPB(use_info) } \
  {
   return [UI_PB_chelp_DisplayMenuItemCsh $m]
  } else \
  {
   return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -type ok -icon info -message "$gPB(msg,pending)"]
  }
 }

#=======================================================================
proc __HelpItemCmd { doc_type } {
  global gPB
  global env
  global tcl_platform
  if { $gPB(use_info) } \
  {
   return [UI_PB_chelp_DisplayMenuItemCsh $gPB(help_menu)]
  }
  if { [llength [info commands "UI_PB_execute"]] == 0 } \
  {
   return [__MenuItemCmd_nyi $gPB(help_menu)]
  }
  switch -- $doc_type \
  {
   "WHAT_TO_DO" {
    return [__MenuItemCmd_nyi $gPB(help_menu)]
   }
   "DIALOG_HELP" {
    return [__MenuItemCmd_nyi $gPB(help_menu)]
   }
   "USER_MANUAL" {
    set doc_file "$gPB(user_manual_file)"
   }
  }
  if { ![file exists $doc_file] } {
   return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -type ok -icon error -message "Document not found!"]
  }
  if {$tcl_platform(platform) == "unix"} \
  {
   if { ![ info exists gPB(unix_netscape) ] } {
    set gPB(unix_netscape) "netscape"
   }
   set browser $gPB(unix_netscape)
   if [info exists result] { unset result }
   if { $gPB(help_win_id) == 0 } \
   {
    if { [catch { exec xwininfo -name "Netscape: UG/Post Builder User's Manual" }] == 0 } \
    {
     set result [exec xwininfo -name "Netscape: UG/Post Builder User's Manual"]
     if [info exists result] \
     {
      set result [join [split $result "\""] ""]
      set ni [lsearch $result "id:"]
      if { $ni > -1 } {
       set gPB(help_win_id) [lindex $result [expr $ni + 1]]
       set win(ID) $gPB(help_win_id)
       set nav_win_found 2
      }
     }
    }
   } else \
   {
    if { [catch { exec xwininfo -id $gPB(help_win_id) }] } \
    {
     set gPB(help_win_id) 0
    } else \
    {
     set win(ID) $gPB(help_win_id)
     set nav_win_found 2
    }
   }
   if { $gPB(help_win_id) == 0 } \
   {
    set nav_win_found -1 
    
    
    
    catch { set result [exec xlswins | grep -i netscape] }
    if [info exists result] \
    {
     set nav_win_found 0
     set result [join [split $result "\""] ""]
     set ni [lsearch $result "(Netscape:"]
     while { $ni > -1 } {
      set win(ID)      [lindex $result [expr $ni - 1]]
      set win(APP)     [lindex $result $ni]
      set win(CONTENT) [lindex $result [expr $ni + 1]]
      if { [string match $win(APP)     "(Netscape:"] && \
       ![string match $win(CONTENT) "Untitled)" ] && \
       ![string match $win(CONTENT) "Find)"     ] && \
      ![string match $win(CONTENT) "Error)"    ] } \
      {
       set nav_win_found 1
       if { [string match $win(CONTENT) "UG/Post"] } \
       {
        break;
       }
      }
      set result [lreplace $result 0 [expr $ni + 1]]
      set ni [lsearch $result "(Netscape:"]
     }
     } else { 
     set nav_win_found -1
    }
   }
   switch -- $nav_win_found \
   {
    2  -
    1  {
     set html_doc_file "$browser $win(ID) -raise \
     -remote 'openFile($doc_file)'"
     set gPB(help_win_id) $win(ID)
    }
    0  {
     set html_doc_file "$browser -raise \
     -remote 'openFile($doc_file)'"
    }
    -1 {
     set html_doc_file "$browser $doc_file&"
    }
   }
   if { [UI_PB_execute $html_doc_file] == 0 } \
   {
    return 
   } else \
   {
    if { $browser != "netscape" } \
    {
     set browser "netscape"
     set gPB(unix_netscape) $browser
     set html_doc_file "$browser $doc_file&"
     if { [UI_PB_execute $html_doc_file] == 0 } \
     {
      return 
     } else \
     {
      return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
      -icon error -message "$gPB(msg,invalid_browser_cmd) $browser"]
     }
    } else \
    {
     return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error -message "$gPB(msg,invalid_browser_cmd) $browser"]
    }
   }
   } elseif { $tcl_platform(platform) == "windows" } \
  {
   set html_doc_file [join [split $doc_file "/"] "\\\\"]
   if { [UI_PB_execute $html_doc_file] != 0 } \
   {
    return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
    -icon error -message "$gPB(msg,invalid_browser_cmd) $browser"]
   }
  } else \
  {
   return [__MenuItemCmd_nyi $gPB(help_menu)]
  }
 }

#=======================================================================
proc HelpCmd_wtd {} {
  return [__HelpItemCmd WHAT_TO_DO]
 }

#=======================================================================
proc HelpCmd_dia {} {
  return [__HelpItemCmd DIALOG_HELP]
 }

#=======================================================================
proc HelpCmd_man {} {
  return [__HelpItemCmd USER_MANUAL]
 }

#=======================================================================
proc HelpCmd_abo {} {
  global gPB
  if { $gPB(use_info) } \
  {
   return [UI_PB_chelp_DisplayMenuItemCsh $gPB(help_menu)]
  } else \
  {
   return [__DisplayAboutPostBuilder]
   return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
   -icon info -message "$gPB(Postbuilder_Release_About)"]
  }
 }

#=======================================================================
proc HelpCmd_ack {} {
  global gPB
  if { $gPB(use_info) } \
  {
   return [UI_PB_chelp_DisplayMenuItemCsh $gPB(help_menu)]
  } else \
  {
   set msg "Development team of UG/Post\ Builder acknowledges\
   that Tcl/Tk, Tix and Stooop have been utilized to\
   develop this product.  Credits should be honored\
   to the authors of these tool kits (John Ousterhout,\
   Ioi Lam & Jean-Luc Fontaine and their associates),\
   who have subconsciously made invaluable contribution\
   to UG/Post\ Builder.\
   \n\
   \n\
   \n Team Members:\
   \n\
   \n  Arun N.\
   \n  Bill B.\
   \n  Bing Z.\
   \n  Binu P.\
   \n  Byung C.\
   \n  David L.\
   \n  Gen S. L.\
   \n  Mahendra G.\
   \n  Naveen M.\
   \n  Satya C.\
   \n  Stan The Man"
   return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon info -message $msg]
  }
 }

#=======================================================================
proc OptionCmd_pro {} {
  global gPB
  return [__MenuItemCmd_nyi $gPB(option_menu)]
 }

#=======================================================================
proc OptionCmd_adv {} {
  global gPB
  return [__MenuItemCmd_nyi $gPB(option_menu)]
 }

#=======================================================================
proc SetBalloonHelp {} {
  global gPB
  global gPB_use_balloons gPB_help_tips
  if { $gPB(use_info) } \
  {
   if { $gPB(use_bal) } {
    set gPB(use_bal) 0
    } else {
    set gPB(use_bal) 1
   }
   return [UI_PB_chelp_DisplayMenuItemCsh $gPB(help_menu)]
  }
  set gPB_use_balloons $gPB(use_bal)
  set gPB_help_tips(state) $gPB(use_bal)
  set idx [lsearch $gPB(help_sel_var) bal]
  if { $gPB(use_bal) && $idx >= 0 } \
  {
   return
   } elseif { !$gPB(use_bal) && $idx < 0 } \
  {
   return
  } else \
  {
   if { $gPB(use_bal) } \
   {
    set gPB(help_sel_var) [linsert $gPB(help_sel_var) 0 bal]
   } else \
   {
    set gPB(help_sel_var) [lreplace $gPB(help_sel_var) $idx $idx]
   }
  }
 }

#=======================================================================
proc UI_PB_ExitPost { args } {
  global gPB
  if [info exists gPB(save_as_now)] { return }
  if { $gPB(use_info) } \
  {
   return [UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)]
  }
  if { [info exists gPB(main_window)] && $gPB(main_window) != "" } \
  {
   set choice [UI_PB_ClosePost]
   if { $choice == "yes" || $choice == "no" } \
   {
    UI_PB_save_SessionLog
    exit
   }
  } else \
  {
   UI_PB_save_SessionLog
   exit
  }
 }

#=======================================================================
proc UI_PB_save_SessionLog { args } {
  global gPB env
  set fid 0
  set fid [open $gPB(Session_Log) w+]
  if { $fid != "" } \
  {
   set time_string [clock format [clock seconds] -format "%c %Z"]
   puts $fid "\#==============================================================================="
   puts $fid "\# Post Builder Session Log File created by $env(USERNAME)"
   puts $fid "\# on $time_string"
   puts $fid "\#==============================================================================="
   puts $fid " "
   puts $fid "\#---------------"
   puts $fid "\# Backup Method"
   puts $fid "\#---------------"
   puts $fid "set\ gPB(backup_method) \"$gPB(backup_method)\""
   puts $fid " "
   puts $fid "\#---------------------------------------------"
   puts $fid "\# Switches for Custom Commands Validity Check"
   puts $fid "\#---------------------------------------------"
   puts $fid "set\ gPB(check_cc_syntax_error)    \"$gPB(check_cc_syntax_error)\""
   puts $fid "set\ gPB(check_cc_unknown_command) \"$gPB(check_cc_unknown_command)\""
   puts $fid "set\ gPB(check_cc_unknown_block)   \"$gPB(check_cc_unknown_block)\""
   puts $fid "set\ gPB(check_cc_unknown_address) \"$gPB(check_cc_unknown_address)\""
   puts $fid "set\ gPB(check_cc_unknown_format)  \"$gPB(check_cc_unknown_format)\""
   puts $fid " "
   puts $fid "\#--------------------------------------------"
   puts $fid "\# Custom Commands Import/Export destinations"
   puts $fid "\#--------------------------------------------"
   if [info exists gPB(custom_command_file_import)] {
    set f [join [split $gPB(custom_command_file_import) "\\"] "/"]
    puts $fid "set\ gPB(custom_command_file_import) \"$f\""
   }
   if [info exists gPB(custom_command_file_export)] {
    set f [join [split $gPB(custom_command_file_export) "\\"] "/"]
    puts $fid "set\ gPB(custom_command_file_export) \"$f\""
   }
   if { [info exists gPB(open_files_list)]  &&  [llength $gPB(open_files_list)] } \
   {
    puts $fid " "
    puts $fid "\#---------------"
    puts $fid "\# Visited Posts"
    puts $fid "\#---------------"
    puts $fid "set\ gPB(open_files_list) \{$gPB(open_files_list)\}"
   }
   close $fid
  } else \
  {
   return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon warning \
   -message "$gPB(msg,file_perm) \n $gPB(Session_Log)"]
  }
 }

#=======================================================================
proc UI_PB_save_a_post { args } {
  global gPB
  if 0 {
   PB_int_ReadPostOutputFiles cur_dir gpb_pui_file gpb_def_file \
   gpb_tcl_file
   if { [file exists "$cur_dir/$gpb_pui_file"] || \
    [file exists "$cur_dir/$gpb_def_file"] || \
   [file exists "$cur_dir/$gpb_tcl_file"] }  \
   {
    set ans [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type yesno -icon warning \
    -message "$gPB(msg,file_exist)"]
    if { $ans == "no" } \
    {
     return
    }
   }
  }
  global post_object
  Post::GetObjList $post_object command cmd_obj_list
  set err_msg ""
  if [info exists cmd_obj_list] {
   foreach c $cmd_obj_list {
    set msg [PB_file_ValidateDefElemsInCommand $c]
    if { $msg != "" } {
     append err_msg $msg
    }
   }
  }
  if { $err_msg != "" } {
   UI_PB_debug_DisplayMsg $err_msg no_debug
   set choice [tk_messageBox \
   -parent [UI_PB_com_AskActiveWindow] -type okcancel -icon question \
   -message "$err_msg \nDo you want to save this Post anyway?"]
   if { $choice == "cancel" } {
    return
   }
  }
  set ret_flag 0
  set ret_flag [UI_PB_UpdateCurrentBookPageAttr gPB(book)]
  if { $ret_flag } { return }
  PB_CreateDefTclFiles
  UI_PB_com_SetWindowTitle
  set gPB(session) EDIT
 }

#=======================================================================
proc UI_PB_ClosePost {args} {
  global gPB
  if [info exists gPB(save_as_now)] { return }
  global mom_sys_arr mom_kin_var
  set prev_mssg $gPB(menu_bar_status)
  if { $gPB(use_info) } \
  {
   return [UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)]
  }
  set choice "cancel"
  if { [info exists gPB(PB_LICENSE)] } {
   if { $gPB(PB_LICENSE) != "UG_POST_NO_LICENSE" } {
    UI_PB_com_SetStatusbar "$gPB(main,save,Status)"
    set choice [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type yesnocancel \
    -icon question -message "$gPB(msg,save)"]
    } else {
    set choice "no"
   }
  } else \
  { 
   UI_PB_com_SetStatusbar "$gPB(main,save,Status)"
   set choice [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type yesnocancel \
   -icon question -message "$gPB(msg,save)"]
  }
  if { $choice == "yes" } \
  {
   if { [UI_PB_com_AskActiveWindow] != "$gPB(main_window)" } {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
    -icon error -message "$gPB(msg,sub_dialog_open)"
    set choice "cancel"
   }
  }
  if { $choice == "yes" } \
  {
   UI_PB_SavePost
   UI_PB_com_SetStatusbar "$prev_mssg"
   if { $gPB(session) != "EDIT" } \
   {
    return
   }
   } elseif { $choice == "no" } \
  {
   UI_PB_com_SetStatusbar "$gPB(main,default,Status)"
  }
  if { $choice == "yes"  ||  $choice == "no" } \
  {
   UI_PB_com_DeleteTopLevelWindows
   UI_PB_AddVisitedPosts
   if [array exists mom_sys_arr] { unset mom_sys_arr }
   if [array exists mom_kin_var] { unset mom_kin_var }
   namespace delete ::stooop
   package forget stooop
  }
  return $choice
 }

#=======================================================================
proc __DeletePostWidgets { } {
  global gPB
  if [info exists gPB(tix_grid)] \
  {
   global addr_app_text
   PB_int_AddrSummaryAttr addr_name_list addr_app_text addr_desc_arr
   set no_addr [llength $addr_name_list]
   for {set count 0} {$count < [expr $no_addr + 1]} {incr count} \
   {
    $gPB(tix_grid) delete row $count
   }
   unset gPB(tix_grid)
  }
  UI_PB_EnableFileOptions
  UI_PB_DeleteDataBaseObjs
  UI_PB_DeleteUIObjects
 }

#=======================================================================
proc UI_PB_DeleteUIObjects { } {
  global gPB
  if { $gPB(book) == 0 } {
   return
  }
  set pb_book $gPB(book)
  set book_chap $Book::($pb_book,page_obj_list)
  foreach chap $book_chap \
  {
   if { [info exists Page::($chap,book)] } \
   {
    set chap_pages $Page::($chap,book)
    foreach page_obj $chap_pages \
    {
     catch { eval delete $page_obj }
    }
   }
   catch { eval delete $chap }
  }
  eval delete $pb_book
  set gPB(book) 0
 }

#=======================================================================
proc UI_PB_DeleteDataBaseObjs { } {
  global post_object
  if { ![info exists post_object] } {
   return
  }
  if 0 {
   if [info exists Post::($post_object,def_parse_obj)] \
   {
    eval delete $Post::($post_object,def_parse_obj)
   }
   set seq_obj_list $Post::($post_object,seq_obj_list)
   foreach seq_obj $seq_obj_list \
   {
    eval delete $seq_obj
   }
   set blk_obj_list $Post::($post_object,blk_obj_list)
   foreach blk_obj $blk_obj_list \
   {
    eval delete $blk_obj
   }
   set add_obj_list $Post::($post_object,add_obj_list)
   foreach add_obj $add_obj_list \
   {
    eval delete $add_obj
   }
   set fmt_obj_list $Post::($post_object,fmt_obj_list)
   foreach fmt_obj $fmt_obj_list \
   {
    eval delete $fmt_obj
   }
  }
  if [catch { delete $post_object } res] {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -type ok -icon error \
   -message "Post objects are not cleaned up properly!\n $res"
  }
  if [info exists post_object] { unset post_object }
 }

#=======================================================================
proc UI_PB_main_window {args} {
  global gPB
  global paOption
  if { [info exists gPB(main_window)] } {
   unset gPB(main_window)
  }
  set mw [toplevel $gPB(top_window).main]
  set xc [expr [winfo rootx $gPB(top_window)] - $gPB(WIN_X)]
  set yc [expr [winfo rooty $gPB(top_window)] + $gPB(TOP_WIN_HI) + $gPB(WIN_X)]
  UI_PB_com_CreateTransientWindow $mw "Post Processor" "1000x600+$xc+$yc" \
  "" "" "UI_PB_ClosePost" "__DeletePostWidgets" 0
  set gPB(main_window) $mw
  UI_PB_com_SetWindowTitle
  if 0 {
   set sw [tixScrolledWindow $mw.sw -scrollbar auto -height 600]
   [$sw subwidget hsb] config -troughcolor skyBlue \
   -width $paOption(trough_wd)
   [$sw subwidget vsb] config -troughcolor skyBlue \
   -width $paOption(trough_wd)
   pack $sw -side top -expand yes -fill both
   set win [$sw subwidget window]
   set w [tixNoteBook $win.nb -ipadx 3 -ipady 3]
  }
  set w [tixNoteBook $mw.nb -ipadx 3 -ipady 3]
  [$w subwidget nbframe] config -backpagecolor $paOption(app_bg) \
  -tabpadx 0 -tabpady 0
  bind [$w subwidget nbframe] <Button-1> "UI_PB_NoteBookTabBinding $w %x %y"
  set gPB(book) [new Book w]
  Book::CreatePage $gPB(book) mac "$gPB(machine,tab,Label)" pb_machine \
  UI_PB_MachineTool UI_PB_MachToolTab
  Book::CreatePage $gPB(book) pro "$gPB(progtpth,tab,Label)" pb_prog \
  UI_PB_ProgTpth UI_PB_ProgTpthTab
  Book::CreatePage $gPB(book) def "$gPB(nc_data,tab,Label)" pb_mcd \
  UI_PB_Def UI_PB_DefTab
  Book::CreatePage $gPB(book) lis "$gPB(listing,tab,Label)" pb_listing \
  UI_PB_List UI_PB_ListTab
  Book::CreatePage $gPB(book) pre "$gPB(output,tab,Label)" pb_output \
  UI_PB_Preview UI_PB_PreviewTab
  set Book::($gPB(book),x_def_tab_img) 0
  set Book::($gPB(book),current_tab) -1
  pack $w -expand yes -fill both
  update idletasks
  set xxc [winfo rootx $mw]
  set yyc [winfo rooty $mw]
  set gPB(WIN_X) [expr $xxc - $xc]
  set gPB(WIN_Y) [expr $yyc - $yc]
  set gPB(win_max_width)  [expr $gPB(screen_width)  - $gPB(WIN_X) - $gPB(WIN_X)]
  set gPB(win_max_height) [expr $gPB(screen_height) - $gPB(WIN_Y) - $gPB(WIN_X)]
  UI_PB_com_PositionWindow $mw
 }

#=======================================================================
proc UI_PB_NoteBookTabBinding { book_id x y } {
  global machTree
  if { [info exists machTree] && ([UI_PB__MachToolValidation] == "bad") } {
   return
   } else {
   tixNoteBook:MouseDown $book_id $x $y
  }
 }

#=======================================================================
proc UI_PB_MachToolTab { book_id page_img book_obj } {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_ValidatePrevBookData book_obj] } \
  {
   return
  }
  UI_PB_DeleteBookAttr book_obj
  set Book::($book_obj,current_tab) 0
  UI_PB_UpdateBookAttr book_obj
 }

#=======================================================================
proc UI_PB_ProgTpthTab { book_id page_img book_obj } {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_ValidatePrevBookData book_obj] } \
  {
   return
  }
  UI_PB_DeleteBookAttr book_obj
  set Book::($book_obj,current_tab) 1
  UI_PB_UpdateBookAttr book_obj
 }

#=======================================================================
proc UI_PB_DefTab { book_id page_img book_obj } {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_ValidatePrevBookData book_obj] } \
  {
   return
  }
  UI_PB_DeleteBookAttr book_obj
  set Book::($book_obj,current_tab) 2
  UI_PB_UpdateBookAttr book_obj
 }

#=======================================================================
proc UI_PB_ListTab { book_id page_img book_obj } {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_ValidatePrevBookData book_obj] } \
  {
   return
  }
  UI_PB_DeleteBookAttr book_obj
  set Book::($book_obj,current_tab) 3
  UI_PB_UpdateBookAttr book_obj
 }

#=======================================================================
proc UI_PB_PreviewTab { book_id page_img book_obj } {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_ValidatePrevBookData book_obj] } \
  {
   return
  }
  UI_PB_DeleteBookAttr book_obj
  set Book::($book_obj,current_tab) 4
  UI_PB_UpdateBookAttr book_obj
 }

#=======================================================================
proc UI_PB_AdvisorTab { book_id page_img book_obj } {
  CB_nb_def $book_id $page_img $book_obj
  if { [UI_PB_ValidatePrevBookData book_obj] } \
  {
   return
  }
  UI_PB_DeleteBookAttr book_obj
  set Book::($book_obj,current_tab) 5
  UI_PB_UpdateBookAttr book_obj
 }

#=======================================================================
proc UI_PB__MachToolValidation {} {
  global machTree axisoption
  if { [info exists machTree] } {
   switch -- $axisoption {
    "3" {
     set axis_type 3
    }
    "4H" -
    "4T" {
     set axis_type 4
    }
    "5TT" -
    "5HH" -
    "5HT" {
     set axis_type 5
    }
   }
   return [ValidateMachObjAttr $machTree $axis_type]
  }
 }

#=======================================================================
proc UI_PB_ValidatePrevBookData { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  global gPB
  set raise_page 0
  set fmt_page_flag 0
  set blk_page_flag 0
  set current_tab $Book::($book_obj,current_tab)
  set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
  switch -exact -- $Book::($book_obj,current_tab) \
  {
   0 { 
    global  mom_kin_var
    PB_int_RetAddressObjList addr_obj_list
    set addr_name "fourth_axis"
    PB_com_RetObjFrmName addr_name addr_obj_list addr_obj
    if { $addr_obj > 0 } {
     if [info exists mom_kin_var(\$mom_kin_4th_axis_leader)] {
      address::readvalue $addr_obj addr_obj_attr
      set addr_obj_attr(8) $mom_kin_var(\$mom_kin_4th_axis_leader)
      address::setvalue $addr_obj addr_obj_attr
     }
    }
    set addr_name "fifth_axis"
    PB_com_RetObjFrmName addr_name addr_obj_list addr_obj
    if { $addr_obj > 0 } {
     if [info exists mom_kin_var(\$mom_kin_5th_axis_leader)] {
      address::readvalue $addr_obj addr_obj_attr
      set addr_obj_attr(8) $mom_kin_var(\$mom_kin_5th_axis_leader)
      address::setvalue $addr_obj addr_obj_attr
     }
    }
   }
   1 { 
    set gPB(IGNORE_CC_MAIN_TAB) 0
    if [info exists Page::($page_obj,book_obj)] \
    {
     set page_book_obj $Page::($page_obj,book_obj)
     switch $Book::($page_book_obj,current_tab) \
     {
      3 { 
       set addrsum_err [UI_PB_ads_ValidateAllFormats]
       if $addrsum_err { set raise_page 1 }
      }
      5 { 
       set cmd_page [lindex $Book::($page_book_obj,page_obj_list) 5]
       if { [info exists Page::($cmd_page,active_cmd_obj)] } \
       {
        set cmd_obj $Page::($cmd_page,active_cmd_obj)
        global pb_cmd_procname
        set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
        set cust_page_flag [PB_int_CheckForCmdBlk cmd_obj \
        cur_cmd_name]
        if { $cust_page_flag } \
        {
         set raise_page 1
        }
        set cc_res 1
        if { ![info exists gPB(IGNORE_CC_MAIN_TAB)] } \
        {
         set gPB(IGNORE_CC_MAIN_TAB) 0
        }
        if { $gPB(IGNORE_CC_MAIN_TAB) == 0 } \
        {
         set cc_res [ UI_PB_cmd_SaveCmdProc_ret_msg $cmd_page cc_err_msg ]
        } else \
        {
         set gPB(IGNORE_CC_MAIN_TAB) 0
        }
        if { $cc_res != 1 } \
        {
         set raise_page 1
        }
       }
       if { !$raise_page } \
       {
        set Page::($cmd_page,selected_index) -1
       }
      }
     }
    }
   }
   2 { 
    if {[info exists Page::($page_obj,book_obj)]} \
    {
     set page_book_obj $Page::($page_obj,book_obj)
     switch $Book::($page_book_obj,current_tab) \
     {
      0 {
       set blk_page [lindex $Book::($page_book_obj,page_obj_list) 0]
       if { [info exists Page::($blk_page,active_blk_obj)] } \
       {
        global gPB_block_name
        set block_obj $Page::($blk_page,active_blk_obj)
        set ret_code [UI_PB_blk_CheckBlockName gPB_block_name block_obj]
        if { $block::($block_obj,active_blk_elem_list) == "" } { 
         set raise_page 1
         set blk_page_flag 3
         } elseif { $ret_code } { 
         set raise_page 1
         set blk_page_flag $ret_code
        }
       }
      }
      1 {
       set addr_page [lindex $Book::($page_book_obj,page_obj_list) 1]
       if { [info exists Page::($addr_page,act_addr_obj)] } \
       {
        global gPB_address_name
        set add_obj $Page::($addr_page,act_addr_obj)
        set add_page_flag [UI_PB_addr_CheckAddressName \
        gPB_address_name add_obj]
        if { $add_page_flag } \
        {
         set raise_page 1
        }
       }
      }
      2 {
       set fmt_page [lindex $Book::($page_book_obj,page_obj_list) 2]
       if { [info exists Page::($fmt_page,act_fmt_obj)] } \
       {
        global FORMATOBJATTR
        global gPB_format_name
        set fmt_obj $Page::($fmt_page,act_fmt_obj)
        set ret_code [UI_PB_fmt_CheckFormatName gPB_format_name fmt_obj]
        if { $ret_code } \
        {
         set raise_page 1
         set fmt_page_flag $ret_code
         } elseif { $FORMATOBJATTR(1) == "Numeral" && \
         $FORMATOBJATTR(6) == 0 && \
         $FORMATOBJATTR(3) == 0 && \
        $FORMATOBJATTR(4) == 0 } \
        {
         set raise_page 1
         set fmt_page_flag 3
        }
       }
      }
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
  1 {
   set page_book_obj $Page::($page_obj,book_obj)
   switch $Book::($page_book_obj,current_tab) \
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
      set gPB(IGNORE_CC_MAIN_TAB) 0
      if { $res == "yes" } \
      {
       PB_file_AssumeUnknownCommandsInProc
       PB_file_AssumeUnknownDefElemsInProc
       set cmd_page [lindex $Book::($page_book_obj,page_obj_list) 5]
       if { [info exists Page::($cmd_page,active_cmd_obj)] } \
       {
        set cmd_obj $Page::($cmd_page,active_cmd_obj)
        UI_PB_cmd_GetProcFromTextWin $cmd_page proc_text
        set command::($cmd_obj,proc) $proc_text
       }
       $book_id pageconfigure $prev_page_name -raisecmd "$cmd_proc"
       set prev_page_name $cur_page_name

#=======================================================================
set cmd_proc [$book_id pagecget $prev_page_name -raisecmd]
 set Book::($book_obj,x_def_tab_img) $prev_page_img
 set prev_page_img $cur_page_img
 $book_id pageconfigure $prev_page_name \
 -raisecmd "CB_nb_def $book_id $prev_page_img $book_obj"
 $book_id raise $prev_page_name
 $book_id pageconfigure $prev_page_name -raisecmd "$cmd_proc"
 set gPB(IGNORE_CC_MAIN_TAB) 1
 set Page::($cmd_page,selected_index) -1
 return 0
}
}
}
}
}
2 {
set page_book_obj $Page::($page_obj,book_obj)
switch $Book::($page_book_obj,current_tab) \
{
0 {
switch $blk_page_flag \
{
1 -
2 {
 UI_PB_blk_DenyBlockRename $blk_page_flag
}
3 {
 tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
 -type ok -icon error \
 -message "$gPB(msg,min_word)"
}
}
}
1 {
UI_PB_addr_DenyAddrRename $add_page_flag
}
2 {
switch $fmt_page_flag \
{
1 -
2 {
 UI_PB_fmt_DenyFmtRename $fmt_page_flag
}
3 {
 tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
 -type ok -icon error \
 -message "$gPB(format,data,dec_zero,msg)"
}
}
}
}
}
}
$book_id raise $prev_page_name
$book_id pageconfigure $prev_page_name -raisecmd "$cmd_proc"
switch $cur_page_name \
{
"mac"   { set new_tab 0 }
"pro"   { set new_tab 1 }
"def"   { set new_tab 2 }
"lis"   { set new_tab 3 }
"pre"   { set new_tab 4 }
default { set new_tab 0 }
}
set Book::($book_obj,current_tab) $new_tab
UI_PB_DeleteBookAttr book_obj
set Book::($book_obj,current_tab) $current_tab
}
return $raise_page
}

#=======================================================================
proc UI_PB_DeleteBookAttr { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  switch -exact -- $Book::($book_obj,current_tab) \
  {
   0 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
    UI_PB_mach_UpdateMachinePageParams page_obj
   }
   1 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
    if {[info exists Page::($page_obj,book_obj)]} \
    {
     set page_book_obj $Page::($page_obj,book_obj)
     UI_PB_progtpth_DeleteTabAtt page_book_obj
    }
   }
   2 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
    if {[info exists Page::($page_obj,book_obj)]} \
    {
     set page_book_obj $Page::($page_obj,book_obj)
     UI_PB_Def_UpdatePrevTabElems page_book_obj
    }
   }
   3 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
    UI_PB_list_ApplyListObjAttr page_obj
   }
   4 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 4]
   }
   5 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 5]
   }
  }
 }

#=======================================================================
proc UI_PB_UpdateBookAttr { BOOK_OBJ } {
  upvar $BOOK_OBJ book_obj
  global gPB
  switch -exact -- $Book::($book_obj,current_tab) \
  {
   0 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
    UI_PB_mach_CreateTabAttr $page_obj
    UI_PB_com_SetStatusbar "$gPB(machine,Status)"
   }
   1 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
    if {[info exists Page::($page_obj,book_obj)]} \
    {
     set page_book_obj $Page::($page_obj,book_obj)
     UI_PB_progtpth_CreateTabAttr page_book_obj
    }
   }
   2 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
    if {[info exists Page::($page_obj,book_obj)]} \
    {
     set page_book_obj $Page::($page_obj,book_obj)
     UI_PB_Def_CreateTabAttr page_book_obj
    }
   }
   3 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
    UI_PB_com_SetStatusbar "$gPB(listing,Status)"
   }
   4 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 4]
    if {[info exists Page::($page_obj,book_obj)]} \
    {
     set page_book_obj $Page::($page_obj,book_obj)
     UI_PB_prv_CreateTabAttr page_book_obj
    }
   }
   5 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 5]
    UI_PB_com_SetStatusbar "$gPB(advisor,Status)"
   }
  }
 }

#=======================================================================
proc UI_PB_UpdateProgTpthBook { PRG_BOOK } {
  upvar $PRG_BOOK prg_book
  set ret_flag 0
  switch -exact -- $Book::($prg_book,current_tab) \
  {
   0 {
    set page_obj [lindex $Book::($prg_book,page_obj_list) 0]
    UI_PB_evt_GetSequenceIndex page_obj seq_index
    set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
   }
   1 {
    set page_obj [lindex $Book::($prg_book,page_obj_list) 1]
    UI_PB_gcd_ApplyGcodeData $prg_book $page_obj
   }
   2 {
    set page_obj [lindex $Book::($prg_book,page_obj_list) 2]
    UI_PB_mcd_ApplyMcodeData $prg_book $page_obj
   }
   3 {
    set page_obj [lindex $Book::($prg_book,page_obj_list) 3]
    UI_PB_ads_UpdateAddressObjects
   }
   4 {
    set page_obj [lindex $Book::($prg_book,page_obj_list) 4]
    UI_PB_mseq_ApplyMastSeq page_obj
   }
   5 {
    set page_obj [lindex $Book::($prg_book,page_obj_list) 5]
    if [info exists Page::($page_obj,active_cmd_obj)] {
     set active_cmd $Page::($page_obj,active_cmd_obj)
     global pb_cmd_procname
     set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
     set cust_page_flag [PB_int_CheckForCmdBlk active_cmd cur_cmd_name]
     if { $cust_page_flag } \
     {
      UI_PB_cmd_DenyCmdRename $cust_page_flag
      set ret_flag 1
     } else \
     {
      UI_PB_cmd_SaveCmdProc $page_obj
     }
    }
   }
  }
  return $ret_flag
 }

#=======================================================================
proc UI_PB_UpdateNCDefBook { DEF_BOOK } {
  upvar $DEF_BOOK def_book
  global gPB
  set ret_flag 0
  switch -exact -- $Book::($def_book,current_tab) \
  {
   0  {
    global gPB_block_name
    set page_obj [lindex $Book::($def_book,page_obj_list) 0]
    set block_obj $Page::($page_obj,active_blk_obj)
    set ret_code [UI_PB_blk_CheckBlockName gPB_block_name block_obj]
    if { $block::($block_obj,active_blk_elem_list) == "" } \
    {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error \
     -message "$gPB(msg,min_word)"
     set ret_flag 1
     } elseif { $ret_code } \
    {
     UI_PB_blk_DenyBlockRename $ret_code
     set ret_flag 1
    } else \
    {
     UI_PB_blk_BlkApplyCallBack $page_obj
    }
   }
   1  {
    set page_obj [lindex $Book::($def_book,page_obj_list) 1]
    global gPB_address_name
    set add_obj $Page::($page_obj,act_addr_obj)
    set ret_code [UI_PB_addr_CheckAddressName gPB_address_name add_obj]
    if { $ret_code } \
    {
     UI_PB_addr_DenyAddrRename $ret_code
     set ret_flag 1
    } else \
    {
     UI_PB_addr_ApplyCurrentAddrData page_obj
    }
   }
   2  {
    set page_obj [lindex $Book::($def_book,page_obj_list) 2]
    if { [info exists Page::($page_obj,act_fmt_obj)] } \
    {
     global FORMATOBJATTR
     global gPB_format_name
     set fmt_obj $Page::($page_obj,act_fmt_obj)
     set page_obj [lindex $Book::($def_book,page_obj_list) 2]
     set ret_code [UI_PB_fmt_CheckFormatName gPB_format_name fmt_obj]
     if { $ret_code } \
     {
      UI_PB_fmt_DenyFmtRename $ret_code
      set ret_flag 1
      } elseif { $FORMATOBJATTR(1) == "Numeral" && \
      $FORMATOBJATTR(6) == 0 && $FORMATOBJATTR(3) == 0 && \
     $FORMATOBJATTR(4) == 0 } \
     {
      tk_messageBox  -parent [UI_PB_com_AskActiveWindow] \
      -type ok -icon error \
      -message " $gPB(format,data,dec_zero,msg)"
      set ret_flag 1
     } else \
     {
      UI_PB_fmt_ApplyCurrentFmtData page_obj
     }
    }
   }
   3  {
    set page_obj [lindex $Book::($def_book,page_obj_list) 3]
    UI_PB_oth_ApplyOtherAttr
   }
  }
  return $ret_flag
 }

#=======================================================================
proc UI_PB_UpdateCurrentBookPageAttr { PB_BOOK } {
  upvar $PB_BOOK book
  set ret_flag 0
  switch -exact -- $Book::($book,current_tab) \
  {
   0  {
    set page_obj [lindex $Book::($book,page_obj_list) 0]
    UI_PB_mach_UpdateMachinePageParams page_obj
   }
   1  {
    set page_obj [lindex $Book::($book,page_obj_list) 1]
    if {[info exists Page::($page_obj,book_obj)]} \
    {
     set page_book_obj $Page::($page_obj,book_obj)
     set ret_flag [UI_PB_UpdateProgTpthBook page_book_obj]
    }
   }
   2  {
    set page_obj [lindex $Book::($book,page_obj_list) 2]
    if {[info exists Page::($page_obj,book_obj)]} \
    {
     set page_book_obj $Page::($page_obj,book_obj)
     set ret_flag [UI_PB_UpdateNCDefBook page_book_obj]
    }
   }
   3  {
    set page_obj [lindex $Book::($book,page_obj_list) 3]
    UI_PB_list_ApplyListObjAttr page_obj
   }
   4  {
    set page_obj [lindex $Book::($book,page_obj_list) 4]
    if {[info exists Page::($page_obj,book_obj)]} \
    {
     set page_book_obj $Page::($page_obj,book_obj)
    }
   }
   5  {
    set page_obj [lindex $Book::($book,page_obj_list) 5]
   }
  }
  return $ret_flag
 }

#=======================================================================
proc UI_PB__main_status {top} {
  global gPB
  global tixOption
  set w [frame $top.f3 -relief raised -bd 1]
  set gPB(statusbar) \
  [label $w.status -font $tixOption(bold_font) -bg black -fg gold1 \
  -anchor w -relief sunken -bd 1 -textvariable gPB(menu_bar_status)]
  set gPB(menu_bar_status) "$gPB(main,default,Status)"
  tixForm $gPB(statusbar) -padx 3 -pady 3 -left 0 -right %70
  return $w
 }
