
#=======================================================================
proc TPD_textLoadFile {wframe file} {
  global gTPD;
  if {[file exists $file] == 1} {
    set f [open $file];
    while {[gets $f line] >= 0} { $wframe.list insert end $line;  } ;
    close $f;
    set gTPD(snap) [$wframe.list get 0 end];
    $wframe.list selection set 0;
  } else {
    tk_messageBox -parent [winfo toplevel $wframe] -message "Invalid File Name" -icon error;
    return 0;
  } ;
  return 1;
} ;

#=======================================================================
proc TPD_addLine {wlist wline} {
  global __edit_tpd_defaultdir;
  set operation open;
  set blank "";
  set types { {"Post files"        {.pui}    } {"All files"         *} } ;
  if {[string compare $__edit_tpd_defaultdir ""] != 0} {
      set file [tk_getOpenFile -filetypes $types -initialdir $__edit_tpd_defaultdir];
   } else {
      set file [tk_getOpenFile -filetypes $types];
  } ;
  if [string match "" $file] { return;  } ;
  set new_file [file tail $file];
  set post [file root $new_file];
  if 0 {
    set fileextension [file join , \$ \{UGII_CAM_POST_DIR\} \. tcl , \$  \{UGII_CAM_POST_DIR \} \. def];
    set newpost [file join $post, \$ \{ UGII_CAM_POST_DIR \} $post \. tcl, \$  \{ UGII_CAM_POST_DIR \} $post \. def];
    if {[string compare $fileextension $newpost] == 0} {
    } else {
      set __edit_tpd_defaultdir [file dirname $file];
      $wlist insert active $newpost;
      set x [$wlist index active];
      incr x -1;
      $wlist activate $x;
      $wlist selection clear 0 end;
      $wlist selection set $x;
    }
  } ;
  set post [list $post ",\ " $ \{UGII_CAM_POST_DIR\} $post .tcl  ",\ " $ \{UGII_CAM_POST_DIR\} $post .def];
  set newpost [join $post ""];
  set __edit_tpd_defaultdir [file dirname $file];
  $wlist insert active $newpost;
  set x [$wlist index active];
  incr x -1;
  $wlist activate $x;
  $wlist selection clear 0 end;
  $wlist selection set $x;
  [winfo parent $wlist].buttons.delete config -state normal;
  [winfo parent $wlist].buttons.edit   config -state normal;
  if {[string compare __edit_tpd_fileName ""] == 0} { set __edit_tpd_defaultdir [file dirname $file]; } ;
  if {[string compare $file $blank] == 0} { }
} ;

#=======================================================================
proc TPD_deleteLine {wlist pButton} {
   global __edit_tpd_currentSelection;
   $wlist selection clear 0 end;
   $wlist selection set active;
   set __edit_tpd_currentSelection [$wlist get active];
   if 0 {
     if {[string compare $__edit_tpd_currentSelection ""] != 0} {
        $wlist delete [$wlist curselection];
     }
    } else {
      $wlist delete [$wlist curselection];
    } ;
   $wlist selection set active;
   $pButton config -state normal;
} ;

#=======================================================================
proc TPD_pasteLine {wlist pButton} {
   global __edit_tpd_currentSelection;
   if 0 {
     if {[string compare $__edit_tpd_currentSelection ""] != 0} {
       $wlist insert active $__edit_tpd_currentSelection;
     }
   } else {
      $wlist insert active $__edit_tpd_currentSelection;
   }
} ;

#=======================================================================
proc TPD_editLine {wlist} {
    set edit [$wlist get active];
    set editIndex [$wlist index active];
    TPD_editDialog $wlist $edit $editIndex;
} ;

#=======================================================================
proc TPD_positionWindow { w args } {
    update idletasks;
    set screen_width  [winfo vrootwidth .];
    set screen_height [winfo vrootheight .];
    if { [llength $args] && [lindex $args 0] == "non_deco" } {
       set WIN_X 0;
       set WIN_Y 0;
    } else {
       set WIN_X 5;
       set WIN_Y 20;
    } ;
    set win_max_width  [expr [winfo vrootwidth .]  - $WIN_X - $WIN_X];
    set win_max_height [expr [winfo vrootheight .] - $WIN_Y - $WIN_X];
    set xc [expr [winfo rootx $w] - $WIN_X];
    set yc [expr [winfo rooty $w] - $WIN_Y];
    set geom_x "+$xc";
    set geom_y "+$yc";
    set ww [winfo width  $w];
    set wh [winfo height $w];
    set geom_w "$ww";
    set geom_h "$wh";
    set ww [expr $ww + $WIN_X + $WIN_X];
    set wh [expr $wh + $WIN_Y + $WIN_X];
    set dx 0;
    set dy 0;
    if { $ww >= $screen_width } {
      set geom_x "+0";
      set geom_w $win_max_width;
      set dx 1;
    } else {
      set dx [expr $xc + $ww - $screen_width];
      if { $dx > 0 } { set geom_x "-0"; }
    } ;
    if { $wh >= $screen_height } {
      set geom_y "+0";
      set geom_h $win_max_height;
      set dy 1;
    } else {
      set dy [expr $yc + $wh - $screen_height];
      if { $dy > 0 } { set geom_y "-0"; }
    } ;
    if { $xc < 0 } { set geom_x "+0"; set dx 1; } ;
    if { $yc < 0 } { set geom_y "+0"; set dy 1; } ;
    if { $dx > 0 || $dy > 0 } {
      set geom "[join [list $geom_w x $geom_h $geom_x $geom_y] ""]";
      wm geometry $w $geom_x$geom_y;
    } ;
    focus $w;
} ;

#=======================================================================
proc TPD_editDialog {wlist edit index} {
    global gPB;
    set g $wlist.edit;
    toplevel $g;
    wm transient $g $wlist;
    wm title $g "$gPB(inposts,edit,title,Label)";
    frame $g.buttons -relief sunken -bd 2 -bg gold1;
    pack $g.buttons -side bottom -fill x;
    button $g.buttons.dismiss -text "$gPB(nav_button,cancel,Label)" -width 13 -bg #d0c690  -command "grab release $g;
    destroy $g;
    $wlist selection set active";
    button $g.buttons.add -text "$gPB(nav_button,ok,Label)" -width 13 -bg #d0c690  -command "TPD_editLine2 $wlist $index $g";
    pack $g.buttons.add $g.buttons.dismiss -side left -expand 1 -pady 10;
    frame $g.file;
    label $g.file.label -text "$gPB(inposts,edit,post,Label)" -anchor w;
    frame $g.frame -borderwidth .5c;
    entry $g.file.entry -width 100;
    pack $g.file.label -side left -padx 5;
    pack $g.file.entry -side right;
    bind $g.file.entry <Return> "TPD_editLine2 $wlist $index $g";
    $g.file.entry delete 0 end;
    $g.file.entry insert end $edit;
    pack $g.file -side top -fill x -pady 5;
    set rootx [winfo rootx $wlist];
    set rooty [winfo rooty $wlist];
    set bbox [$wlist bbox $index];
    set dx [expr [lindex $bbox 0] + $rootx - 20];
    set dy [expr [lindex $bbox 1] + $rooty + 20];
    wm geometry $g +$dx+$dy;
    TPD_positionWindow $g;
    grab $g;
    focus $g.file.entry;
} ;

#=======================================================================
proc TPD_editLine2 { wlist windex g args } {
    set gentry $g.file.entry;
    set entry_is_valid 1;
    set newline [$gentry get];
    if { ![info exists newline] } {
       set entry_is_valid 0;
    } else {
       set newLine [$gentry get];
       set newline [string trim $newline];
       if { [string length $newLine] > 0  &&  ![string match "\#*" $newLine] } {
           set eline [split $newLine ,];
           if { [lsearch [lindex $eline 2] *.def ] ||  [lsearch [lindex $eline 1] *.tcl ] ||  [llength $eline] != 3} { set entry_is_valid 0; }
       }
    } ;
    if { $entry_is_valid == 0 } {
      tk_messageBox -parent [winfo toplevel $g] -message "Invalid Entry" -icon error;
      focus $gentry;
      return;
    } ;
    set edit [$wlist get $windex];
    set edit1 [string trim $edit];
    set lastIndex [expr [$wlist size] - 1];
    if { [string compare $edit1 $newLine] != 0} {
      $wlist delete $windex;
      if {$windex == $lastIndex} { $wlist insert end $newLine; } else { $wlist insert $windex $newLine; } ;
      $wlist activate $windex;
      $wlist selection set active;
    } ;
    destroy $g;
} ;

#=======================================================================
proc TPD_move {wlist option x y} {
    global __edit_tpd_entry __edit_tpd_oldY;
    set current [$wlist get @$x,$y];
    set newIndex [$wlist nearest $y];
    set first [$wlist get 0];
    set end [$wlist get end];
    set currIndex $newIndex;
    set lastIndex [expr [$wlist size] - 1];
    set current [string trim $current];
    if { $current == "" } { set __edit_tpd_oldY $y; return } ;
    if {[string compare $option "get"] == 0} {
       set __edit_tpd_entry [$wlist get @$x,$y];
       set __edit_tpd_oldY $y;
    } elseif {[string compare $__edit_tpd_entry $current] != 0} {
             if {$__edit_tpd_oldY > $y} {
                incr newIndex;
                $wlist delete $newIndex;
                $wlist insert $currIndex $__edit_tpd_entry;
             } elseif {$__edit_tpd_oldY < $y} {
                     incr newIndex -1;
                     $wlist delete $newIndex;
                     if { $currIndex == $lastIndex } { $wlist insert end $__edit_tpd_entry; } else { $wlist insert $currIndex $__edit_tpd_entry; }
                   } ;
            set __edit_tpd_oldY $y;
        } ;
    after 10;
} ;

#=======================================================================
proc TPD_QuestionBox {wframe wline} {
    if 0 {
      set file_name [string trim [$wline get]];
      if [string match "" $file_name] {}
    } ;
    if { [$wframe.list size] == 0 } {
     set answer no;
    } else {
       global gTPD;
       set answer yes;
       if [info exists gTPD(snap)] {
         if { [string compare "$gTPD(snap)" "[$wframe.list get 0 end]"] == 0 } { set answer no; }
       } ;
       if { $answer == "yes" } { set answer [tk_messageBox -parent [winfo toplevel $wframe]  -message "Save changes?" -type yesno -icon question]; }
    } ;
    if [string match "yes" $answer] {
       TPD_fileDialog $wframe $wline saveOpen;
    } elseif [string match "no" $answer] {
             TPD_fileDialog $wframe $wline open;
          }
} ;

#=======================================================================
proc TPD_OkBox { ww wframe wline } {
    if 0 {
      set file_name [string trim [$wline get]];
      if [string match "" $file_name] {}
    } ;
    if { [$wframe.list size] == 0 } { } else { TPD_fileDialog $wframe $wline save;  } ;
    global tix_version;
    if ![string compare $tix_version 8.4] { tk_focusFollowsMouse; } ;
    destroy $ww;
} ;

#=======================================================================
proc TPD_ExitBox { ww wframe wline } {
    if 0 {
      set file_name [string trim [$wline get]];
      if [string match "" $file_name] {}
    } ;
    if { [$wframe.list size] == 0 } {
      set answer no;
    } else {
        global gTPD;
        set answer yes;
        if [info exists gTPD(snap)] {
          if { [string compare "$gTPD(snap)" "[$wframe.list get 0 end]"] == 0 } { set answer no; }
        } ;
        if { $answer == "yes" } { set answer [tk_messageBox -parent [winfo toplevel $wframe]  -message "Save changes?" -type yesno -icon question]; }
    } ;
    if [string match "yes" $answer] { TPD_fileDialog $wframe $wline save; } ;
    global tix_version;
    if ![string compare $tix_version 8.4] { tk_focusFollowsMouse;  } ;
    destroy $ww;
} ;

#=======================================================================
proc TPD_fileDialog {wframe wline operation} {
  global __edit_tpd_defaultdir;
  set types { {"DAT files"            {.dat}          } {"Text files"           {.txt .doc}     } {"Text files"           {}              TEXT} {"Tcl Scripts"          {.tcl}          TEXT} {"C Source Files"       {.c .h}         } {"All Source Files"     {.tcl .c .h}    } {"All files"            *} } ;
  if {$operation == "open"} {
    if {[string compare $__edit_tpd_defaultdir ""] != 0} {
     set file [tk_getOpenFile -filetypes $types -parent $wframe  -initialdir $__edit_tpd_defaultdir];
    } else {
     set file [tk_getOpenFile -filetypes $types -parent $wframe];
    } ;
    if {[string compare $file ""] != 0} {
      $wline config -state normal;
      $wline delete 0 end;
      $wframe.list delete 0 end;
      $wline insert end $file;
      set __edit_tpd_defaultdir [file dirname $file];
      if { ![TPD_textLoadFile $wframe $file] } { $wline delete 0 end; } ;
      $wline config -state disabled;
    }
  } elseif {$operation == "save" } {
          set newFile [tk_getSaveFile -filetypes $types -parent $wframe -defaultextension .dat  -initialdir $__edit_tpd_defaultdir -initialfile [$wline get]];
          if {[string compare $newFile ""] != 0} {
               set f [open $newFile w+];
               foreach i [$wframe.list get 0 end] { puts $f $i; } ;
               close $f;
          }
    } else {
        set newFile [tk_getSaveFile -filetypes $types -parent $wframe -defaultextension .dat  -initialdir $__edit_tpd_defaultdir -initialfile [$wline get]];
        if {[string compare $newFile ""] != 0} {
           set f [open $newFile w+];
           foreach i [$wframe.list get 0 end] { puts $f $i; } ;
           close $f;
           if {[string compare $__edit_tpd_defaultdir ""] != 0} {
               set file [tk_getOpenFile -filetypes $types -parent $wframe  -initialdir $__edit_tpd_defaultdir];
           } else {
               set file [tk_getOpenFile -filetypes $types -parent $wframe];
           } ;
          if {[string compare $file ""] != 0} {
            $wline config -state normal;
            $wline delete 0 end;
            $wframe.list delete 0 end;
            $wline insert end $file;
            set __edit_tpd_defaultdir [file dirname $file];
            if { ![TPD_textLoadFile $wframe $file] } { $wline delete 0 end; } ;
            $wline config -state disabled;
          }
        }
    }
} ;

#=======================================================================
proc TPD_edit_template_post { w } {
    global gPB;
    global __edit_tpd_currentSelection __edit_tpd_fileName __edit_tpd_defaultdir;
    set __edit_tpd_currentSelection "";
    set __edit_tpd_fileName "";
    set __edit_tpd_defaultdir "";
    if { $w == "" } {
      set ww .;
    } else {
      set ww $w;
      if { ![string match "." $w] } {
       if [winfo exists $w] {
         raise $w;
         update;
         return;
       } ;
       toplevel $w;
      }
    } ;
    wm title $ww "$gPB(inposts,title,Label)";
    global tix_version;
    if ![string compare $tix_version 8.4] { bind all <Enter> {} } ;
    wm protocol $ww WM_DELETE_WINDOW "TPD_ExitBox $ww $w.frame $w.file.entry";
    frame $w.regulars -relief sunken -bd 2 -bg gold1;
    pack $w.regulars -side bottom -fill x;
    button $w.regulars.dismiss -text $gPB(nav_button,cancel,Label) -width 13 -bg #d0c690  -command "TPD_ExitBox $ww $w.frame $w.file.entry";
    button $w.regulars.save -text "$gPB(nav_button,ok,Label)" -width 13 -bg #d0c690  -command "TPD_OkBox $ww $w.frame $w.file.entry";
    pack $w.regulars.save $w.regulars.dismiss -side left -expand 1 -pady 10;
    frame $w.file;
    label $w.file.label -text "$gPB(tpdf,text,Label)" -anchor w;
    frame $w.frame -borderwidth .5c;
    entry $w.file.entry -width 70 -textvariable __edit_tpd_fileName -bg lightBlue -state disabled;
    button $w.file.button2 -text "$gPB(new,user,browse,Label)" -width 13  -command "TPD_QuestionBox $w.frame $w.file.entry";
    pack $w.file.label $w.file.entry -side left -padx 5;
    pack $w.file.button2 -side left -pady 5 -padx 10;
    pack $w.file -side top -fill x;
    frame $w.line;
    pack $w.line -side bottom -fill x -pady 2m;
    label $w.line.label -text "Entry:" -width 13 -anchor w;
    entry $w.line.entry -width 40 -textvariable lineEntry;
    pack $w.frame -side bottom;
    scrollbar $w.frame.yscroll -command "$w.frame.list yview";
    scrollbar $w.frame.xscroll -orient horizontal  -command "$w.frame.list xview";
    listbox $w.frame.list -width 100 -height 25 -setgrid 1 -selectmode browse  -yscroll "$w.frame.yscroll set" -xscroll "$w.frame.xscroll set" -bg lightgray;
    set wlist $w.frame.list;
    bind $wlist <Double-Button-1> "TPD_editLine $wlist";
    bind $wlist <1> "$w.frame.buttons.delete config -state normal;
    $w.frame.buttons.edit   config -state normal";
    grid $w.frame.list -row 0 -column 0 -rowspan 4 -columnspan 4 -sticky news;
    grid $w.frame.yscroll -row 0 -column 4 -rowspan 4 -columnspan 1 -sticky news;
    grid $w.frame.xscroll -row 4 -column 0 -rowspan 1 -columnspan 4 -sticky news;
    text $w.text -yscrollcommand "$w.scroll set" -setgrid true;
    scrollbar $w.scroll -command "$w.text yview";
    set wfb [frame $w.frame.buttons];
    button $wfb.add    -text "$gPB(tool,new,Label)"   -width 13  -command "TPD_addLine    $w.frame.list \$lineEntry";
    button $wfb.paste  -text "$gPB(nav_button,paste,Label)" -width 13  -command "TPD_pasteLine  $w.frame.list $wfb.paste";
    button $wfb.delete -text "$gPB(nav_button,cut,Label)"   -width 13  -command "TPD_deleteLine $w.frame.list $wfb.paste"  -state disabled;
    button $wfb.edit   -text "$gPB(nav_button,edit,Label)"  -width 13  -command "TPD_editLine   $w.frame.list"  -state disabled;
    grid $wfb -row 5 -column 0 -rowspan 1 -columnspan 4 -sticky news -ipady 5;
    pack $wfb.add $wfb.delete $wfb.paste $wfb.edit -side left -expand 1;
    $wfb.paste config -state disabled;
    global env;
    if {![info exists env(UGII_CAM_POST_CONFIG_FILE)] && ![info exists env(UGII_BASE_DIR)]} {
       set __edit_tpd_defaultdir "";
    } elseif {[info exists env(UGII_CAM_POST_CONFIG_FILE)]} {
            set f [open $env(UGII_CAM_POST_CONFIG_FILE)];
            while {[gets $f line] >= 0} { $w.frame.list insert end $line; } ;
            close $f;
            set __edit_tpd_fileName $env(UGII_CAM_POST_CONFIG_FILE);
            set __edit_tpd_defaultdir [file dirname $env(UGII_CAM_POST_CONFIG_FILE)];
          } elseif {[info exists env(UGII_BASE_DIR)]} {
                set baseDir $env(UGII_BASE_DIR);
                set fileext "/mach/resource/postprocessor";
                set fileextension "/mach/resource/postprocessor/template_post.dat";
                set __edit_tpd_fileName [file nativename $baseDir$fileextension];
                set __edit_tpd_defaultdir [file nativename $baseDir$fileext];
                if { ![TPD_textLoadFile $w.frame $__edit_tpd_fileName] } {
                   $w.file.entry config -state normal;
                   $w.file.entry delete 0 end;
                   $w.file.entry config -state disabled;
                }
             } ;
    if { [$wlist size] > 0 } {
       $w.frame.buttons.delete config -state normal;
       $w.frame.buttons.edit   config -state normal;
    } ;
    $wlist selection set active;
    if {[string compare $__edit_tpd_fileName ""] != 0} { } ;
    TPD_positionWindow $ww;
    raise $ww;
} ;


if [info exists gPB_edit_tpd] { return } ;
TPD_edit_template_post "";
