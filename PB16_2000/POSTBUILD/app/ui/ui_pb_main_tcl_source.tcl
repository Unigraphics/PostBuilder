#13
global env
global tixOption
global gPB
tix addbitmapdir [tixFSJoin $env(PB_HOME) images]
set tixOption(font)???$gPB(font)
set tixOption(font_sm)??$gPB(font_sm)
set tixOption(bold_font)??$gPB(bold_font)
set tixOption(bold_font_lg)??$gPB(bold_font_lg)
set tixOption(italic_font)??$gPB(italic_font)
set tixOption(fixed_font)??$gPB(fixed_font)
set tixOption(fixed_font_sm)??$gPB(fixed_font_sm)
option add *font $tixOption(bold_font) $tixOption(prioLevel)
set paOption(title_bg)?darkSeaGreen3
set paOption(title_fg)?lightYellow
set paOption(table_bg)?lightSkyBlue
set paOption(app_bg)??#9676a2 ;#
set paOption(tree_bg)??lightYellow 
set paOption(butt_bg)??Gold1 ;#
set paOption(app_butt_bg)?#d0c690 ;# #a8d464
set paOption(can_bg)??#ace8d2
set paOption(can_trough_bg)?#7cdabc
set paOption(trough_bg)?#f0da1c
set paOption(trough_wd)?12
set paOption(file)??[tix getimage pb_textfile]
set paOption(folder)??[tix getimage pb_folder]
set paOption(format)??[tix getimage pb_format]
set paOption(address)??[tix getimage pb_address]
set paOption(popup)??#e3e3e3
set paOption(seq_bg)??yellow ;#Aquamarine1 AntiqueWhite CadetBlue1 #8ceeb6
set paOption(seq_fg)??blue3 
set paOption(event)???skyBlue3
set paOption(cell_color)??paleTurquoise
set paOption(active_color)??burlyWood1
set paOption(focus)???lightYellow
set paOption(balloon)???yellow
set paOption(select_clr)??orange 
set paOption(menu_bar_bg)??lightBlue 
set paOption(text)???lightSkyBlue
set paOption(disabled_fg)??gray
set paOption(tree_disabled_fg)?lightGray
option add *Label.font??$tixOption(font)
option add *Menu.background??gray95
option add *Menu.activeBackground?blue
option add *Menu.activeForeground?yellow
option add *Menu.selectColor??$paOption(select_clr)
option add *Menu.activeBorderWidth?0
option add *Menu.font???$tixOption(bold_font)
option add *Button.cursor???hand2
option add *Button.activeBackground??$paOption(focus)
option add *Button.activeForeground??black
option add *Button.disabledForeground??$paOption(disabled_fg)
option add *Menubutton.cursor???hand2
option add *Menubutton.activeBackground?$paOption(focus)
option add *Checkbutton.cursor??hand2
option add *Checkbutton.activeBackground?$paOption(focus)
option add *Checkbutton.disabledForeground?$paOption(disabled_fg)
option add *Checkbutton.selectColor??$paOption(select_clr)
option add *Checkbutton.font???$tixOption(font)
option add *Radiobutton.cursor??hand2
option add *Radiobutton.activeBackground?$paOption(focus)
option add *Radiobutton.disabledForeground?$paOption(disabled_fg)
option add *Radiobutton.selectColor??$paOption(select_clr)
option add *Radiobutton.font???$tixOption(font)
option add *Entry.font???$tixOption(font)
option add *TixOptionMenu.cursor??hand2
option add *TixOptionMenu.label.font??$tixOption(font)
option add *TixNoteBook.tagPadX??6
option add *TixNoteBook.tagPadY??4
option add *TixNoteBook.borderWidth??2
option add *TixLabelFrame.label.font??$tixOption(italic_font)
option add *TixLabelEntry.label.font??$tixOption(font)
option add *TixButtonBox.background??$paOption(butt_bg)
option add *Dialog.msg.wrapLength??4i

#=======================================================================
proc UI_PB_main {w} {
  global auto_path gPB_dir
  global paOption tixOption
  global gPB
  set gPB(active_window_list)   {}
  set gPB(active_window)        ""
  set gPB(top_window)           ""
  set gPB(top_window).new       ""
  set gPB(top_window).open      ""
  set gPB(main_window)          ""
  set gPB(main_window_disabled) 0
  set gPB(toplevel_list)        {}
  set gPB(help_win_id)          0
  set gPB(Postbuilder_Version)  2000.0.0
  set vi [string last "." $gPB(Postbuilder_Version)]
  set ver [string range $gPB(Postbuilder_Version) 0 [expr $vi - 1]]
  set gPB(Postbuilder_Release)  "UG/Post Builder V[expr $ver - 1999.0]"
  set gPB(Postbuilder_Date)     "August 7, 2000"
  set gPB(output_dir)           ""
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
   wm title     $w "$gPB(Postbuilder_Release)"
   wm geometry  $w 1000x107+100+20
   wm resizable $w 0 0
   wm protocol  $w WM_DELETE_WINDOW "UI_PB_ExitPost"
   $w config -bg $paOption(app_bg)
   set gPB(top_window) $w
   UI_PB_com_ClaimActiveWindow $w
   set main_menu [UI_PB__main_menu   $w]
   set status    [UI_PB__main_status $w]
   set gPB(main_menu)  $main_menu
   pack $main_menu -side top    -fill x
   pack $status    -side bottom -fill x
   set mb $gPB(main_menu_bar)
   set gPB(c_help,$mb.file)            "main,file"
   set gPB(c_help,$mb.file.m)          "main,file,menu"
   set gPB(c_help,$mb.file.m,1)        "main,file,new"
   set gPB(c_help,$mb.file.m,2)        "main,file,open"
   set gPB(c_help,$mb.file.m,3)        "main,file,mdfa"
   set gPB(c_help,$mb.file.m,4)        "main,file,save"
   set gPB(c_help,$mb.file.m,5)        "main,file,save_as"
   set gPB(c_help,$mb.file.m,6)        "main,file,close"
   set gPB(c_help,$mb.file.m,8)        "main,file,exit"
   set gPB(c_help,$mb.help)            "main,help"
   set gPB(c_help,$mb.help.m)          "main,help,menu"
   set gPB(c_help,$mb.help.m,1)        "main,help,bal"
   set gPB(c_help,$mb.help.m,2)        "main,help,chelp"
   set gPB(c_help,$mb.help.m,4)        "main,help,dialog"
   set gPB(c_help,$mb.help.m,5)        "main,help,manual"
   set gPB(c_help,$mb.help.m,7)        "main,help,about"
   set gPB(c_help,$mb.help.m,8)        "main,help,acknow"
   set gPB(c_help,[$main_menu.tool subwidget new])?"tool,new"
   set gPB(c_help,[$main_menu.tool subwidget open])?"tool,open"
   set gPB(c_help,[$main_menu.tool subwidget save])?"tool,save"
   set gPB(c_help,[$main_menu.help subwidget bal])?"tool,bal"
   set gPB(c_help,[$main_menu.help subwidget dia])?"tool,dialog"
   set gPB(c_help,[$main_menu.help subwidget man])?"tool,manual"
   set gPB(c_help,tool_button) [$main_menu.help subwidget inf]
   $mb.file.m entryconfigure 4 -state disabled
   $mb.file.m entryconfigure 5 -state disabled
   $mb.file.m entryconfigure 6 -state disabled
   [$main_menu.tool subwidget save] config -state disabled
   if ![info exists gPB(entry_color)] \
   {
    entry .xxxentry
    set gPB(entry_color) [lindex [.xxxentry config -bg] end]
    tixDestroy .xxxentry
   }
   bind all <Control-x> ""
   bind all <Control-o> ""
   bind all <Control-g><Control-l> HelpCmd_ack
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
    set html_doc_file "$gPB(user_manual_file)"
   }
  }
  if { ![file exists $html_doc_file] } {
   return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -type ok -icon error -message "Document not found!"]
  }
  if {$tcl_platform(platform) == "unix"} \
  {
   if { ![ info exists gPB(unix_netscape) ] } {
    set gPB(unix_netscape) "netscape"
   }
   catch { set result [exec whereis $gPB(unix_netscape)] }
   if [info exists result] \
   {
    if { [string first "$gPB(unix_netscape)" $result] < 0 } \
    {
     return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type ok -icon error -message "Browser command \"$gPB(unix_netscape)\" not found!"]
    }
   }
   unset result
   if { [catch { exec xwininfo -id $gPB(help_win_id) } res]  ==  0 } \
   {
    set win(ID) $gPB(help_win_id)
    set nav_win_found 2
   } else \
   {
    set gPB(help_win_id) 0
    set nav_win_found 0 
    
    
    catch { set result [exec xlswins | grep -i net] }
    if [info exists result] \
    {
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
       if { [string match $win(CONTENT) "UG/Post"] } {
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
     set html_doc_file "$gPB(unix_netscape) -id $win(ID) \
     -remote 'openFile($html_doc_file)'"
     set gPB(help_win_id) $win(ID)
    }
    0  {
     set html_doc_file "$gPB(unix_netscape) -remote 'openFile($html_doc_file)'"
    }
    -1 {
     set html_doc_file "$gPB(unix_netscape) $html_doc_file&"
    }
   }
   if [catch { UI_PB_execute $html_doc_file } res] \
   {
    UI_PB_debug_DisplayMsg $res
    return [__MenuItemCmd_nyi $gPB(help_menu)]
   }
   } elseif { $tcl_platform(platform) == "windows" } \
  {
   set html_doc_file [join [split $html_doc_file "/"] "\\\\"]
   if [catch { UI_PB_execute $html_doc_file } res] \
   {
    UI_PB_debug_DisplayMsg $res
    return [__MenuItemCmd_nyi $gPB(help_menu)]
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
   return [tk_messageBox -parent $gPB(active_window) -type ok \
   -icon info -message "$gPB(Postbuilder_Release)  ($gPB(Postbuilder_Date))"]
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
   to this product.\
   \n\
   \n\
   \n?Team Members:\
   \n\
   \n??Arun N.\
   \n??Bill B.\
   \n??Bing Z.\
   \n??Binu P.\
   \n??Byung C.\
   \n??Gen L.\
   \n??David L.\
   \n??Mahendra G.\
   \n??Naveen M.\
   \n??Satya C.\
   \n??Stan The Man"
   return [tk_messageBox -parent $gPB(active_window) -type ok -icon info -message $msg]
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
  if { $gPB(use_info) } \
  {
   return [UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)]
  }
  if { [info exists gPB(main_window)] && $gPB(main_window) != "" } \
  {
   set choice [UI_PB_ClosePost]
   if { $choice == "yes" || $choice == "no" } \
   {
    exit
   }
  } else \
  {
   exit
  }
 }

#=======================================================================
proc UI_PB_save_a_post { args } {
  global gPB
  set ret_flag 0
  set ret_flag [UI_PB_UpdateCurrentBookPageAttr gPB(book)]
  if { $ret_flag } { return }
  PB_CreateDefTclFiles
  set gPB(session) EDIT
 }

#=======================================================================
proc UI_PB_ClosePost {args} {
  global gPB
  global mom_sys_arr mom_kin_var
  set prev_mssg $gPB(menu_bar_status)
  if { $gPB(use_info) } \
  {
   return [UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)]
  }
  if { [info exists gPB(PB_LICENSE)] } {
   if { $gPB(PB_LICENSE) != "UG_POST_NO_LICENSE" } {
    UI_PB_com_SetStatusbar "$gPB(main,save,Status)"
    set choice [tk_messageBox -parent $gPB(active_window) -type yesnocancel \
    -icon question -message "$gPB(msg,save)"]
    } else {
    set choice "no"
   }
  } else \
  {
   UI_PB_com_SetStatusbar "Save the post"
   set choice [tk_messageBox -parent $gPB(active_window) -type yesnocancel \
   -icon question -message "$gPB(msg,save)"]
  }
  if { $choice == "yes" } \
  {
   UI_PB_SavePost
   UI_PB_com_SetStatusbar "$prev_mssg"
   if { $gPB(session) == "EDIT" } \
   {
    UI_PB_com_DeleteTopLevelWindows
   } else \
   {
    return
   }
   if { [info exists mom_sys_arr] } { unset mom_sys_arr }
   if { [info exists mom_kin_var] } { unset mom_kin_var }
   } elseif { $choice == "no" } \
  {
   UI_PB_com_DeleteTopLevelWindows
   UI_PB_com_SetStatusbar "$gPB(main,default,Status)"
   if { [info exists mom_sys_arr] } { unset mom_sys_arr }
   if { [info exists mom_kin_var] } { unset mom_kin_var }
  }
  return $choice
 }

#=======================================================================
proc DeletePostWidgets { } {
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
  if { $gPB(book) == 0 } { return }
  set pb_book $gPB(book)
  set book_chap $Book::($pb_book,page_obj_list)
  foreach chap $book_chap \
  {
   if { [info exists Page::($chap,book)] } \
   {
    set chap_pages $Page::($chap,book)
    foreach page_obj $chap_pages \
    {
     delete $page_obj
    }
   }
   delete $chap
  }
  delete $pb_book
  set gPB(book) 0
 }

#=======================================================================
proc UI_PB_DeleteDataBaseObjs { } {
  global post_object
  if { ! [info exists post_object] } { return }
  set seq_obj_list $Post::($post_object,seq_obj_list)
  foreach seq_obj $seq_obj_list \
  {
   delete $seq_obj
  }
  set blk_obj_list $Post::($post_object,blk_obj_list)
  foreach blk_obj $blk_obj_list \
  {
   delete $blk_obj
  }
  set add_obj_list $Post::($post_object,add_obj_list)
  foreach add_obj $add_obj_list \
  {
   delete $add_obj
  }
  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  foreach fmt_obj $fmt_obj_list \
  {
   delete $fmt_obj
  }
  delete $post_object
  unset post_object
 }

#=======================================================================
proc UI_PB_main_window {args} {
  global paOption
  global gPB
  if { [info exists gPB(main_window)] } {
   unset gPB(main_window)
  }
  set mw [toplevel $gPB(top_window).main]
  UI_PB_com_CreateTransientWindow $mw "Post Processor" "1000x725+100+160" \
  "" "UI_PB_ClosePost" "DeletePostWidgets" 0
  set gPB(main_window) $mw
  UI_PB_com_SetWindowTitle
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
  switch -exact -- $Book::($book_obj,current_tab) \
  {
   1 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
    if {[info exists Page::($page_obj,book_obj)]} \
    {
     set page_book_obj $Page::($page_obj,book_obj)
     switch $Book::($page_book_obj,current_tab) \
     {
      5 {
       set cmd_page [lindex $Book::($page_book_obj,page_obj_list) 5]
       if { [info exists Page::($cmd_page,active_cmd_obj)] } \
       {
        set cmd_obj $Page::($cmd_page,active_cmd_obj)
        global pb_cmd_procname
        set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
        if { [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name] } \
        {
         set raise_page 1
        }
       }
      }
     }
    }
   }
   2 {
    set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
    if {[info exists Page::($page_obj,book_obj)]} \
    {
     set page_book_obj $Page::($page_obj,book_obj)
     switch $Book::($page_book_obj,current_tab) \
     {
      0 {
       set blk_page [lindex $Book::($page_book_obj,page_obj_list) 0]
       if { [info exists Page::($blk_page,active_blk_obj)] } \
       {
        set block_obj $Page::($blk_page,active_blk_obj)
        if { $block::($block_obj,active_blk_elem_list) == "" } \
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
        set fmt_obj $Page::($fmt_page,act_fmt_obj)
        if { [UI_PB_fmt_CheckFormatName FORMATOBJATTR(0) fmt_obj]} \
        {
         set raise_page 1
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
   set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
   set page_book_obj $Page::($page_obj,book_obj)
   switch $Book::($page_book_obj,current_tab) \
   {
    5 {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error -message "Command \"$cur_cmd_name\" \
     exists, Use another name."
    }
   }
  }
  2 {
   set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
   set page_book_obj $Page::($page_obj,book_obj)
   switch $Book::($page_book_obj,current_tab) \
   {
    0 {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type ok -icon error \
     -message "$gPB(msg,min_word)"
    }
    2 {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type ok -icon error \
     -message "Format \"FORMATOBJATTR(0)\" exists, \
     Use another name."
    }
   }
  }
 }
 $book_id raise $prev_page_name
 $book_id pageconfigure $prev_page_name -raisecmd "$cmd_proc"
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
    UI_PB_gcd_ApplyMcodeData $prg_book $page_obj
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
    if { [UI_PB_cmd_SaveCmdProc $page_obj] } \
    {
     global pb_cmd_procname
     set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error -message "Command \"$cur_cmd_name\" \
     exists, Use another name."
     set ret_flag 1
    }
   }
  }
  return $ret_flag
 }

#=======================================================================
proc UI_PB_UpdateNCDefBoock { DEF_BOOK } {
  upvar $DEF_BOOK def_book
  global gPB
  set ret_flag 0
  switch -exact -- $Book::($def_book,current_tab) \
  {
   0  {
    set page_obj [lindex $Book::($def_book,page_obj_list) 0]
    set block_obj $Page::($page_obj,active_blk_obj)
    if { $block::($block_obj,active_blk_elem_list) == "" } \
    {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error \
     -message "$gPB(msg,min_word)"
     set ret_flag 1
    } else \
    {
     UI_PB_blk_BlkApplyCallBack $page_obj
    }
   }
   1  {
    set page_obj [lindex $Book::($def_book,page_obj_list) 1]
    UI_PB_addr_ApplyCurrentAddrData page_obj
   }
   2  {
    set page_obj [lindex $Book::($def_book,page_obj_list) 2]
    set ret_code [UI_PB_fmt_ApplyCurrentFmtData page_obj]
    if { $ret_code } \
    {
     global FORMATOBJATTR
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error \
     -message "Format \"$FORMATOBJATTR(0)\" exists, \
     Use another name."
     set ret_flag 1
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
     set ret_flag [UI_PB_UpdateNCDefBoock page_book_obj]
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
