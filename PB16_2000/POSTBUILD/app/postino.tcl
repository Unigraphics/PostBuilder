#====================================================================================
#
#
#
#====================================================================================
package require Tix
package require stooop

#=====================================================================================
proc UI_PB__main_menu {top} {
#=====================================================================================
    global PB_license

    global tixOption;
    global paOption;
    global gPB;
      set ww [frame $top.f -bd 2 -relief raised];
      set gPB(main_menu) $ww;
      set w  [frame $ww.mb -bg $paOption(menu_bar_bg)];
      set gPB(main_menu_bar) $w;
      menubutton $w.file -menu $w.file.m -text $gPB(main,file,Label) -underline 0 \
                 -takefocus 0 -bg $paOption(menu_bar_bg);
      menubutton $w.help -menu $w.help.m -text $gPB(main,help,Label) -underline 0 \
                 -takefocus 0 -bg $paOption(menu_bar_bg);
      menu $w.file.m;
      set gPB(file_menu) $w.file.m;
      $w.file.m add command -label $gPB(main,file,new,Label)   -underline 0 \
                -accelerator "Ctrl+N" -command UI_PB_NewPost;
      $w.file.m add command -label $gPB(main,file,open,Label)  -underline 0 \
                -accelerator "Ctrl+O" -command UI_PB_OpenPost;

  #LICENSE_CK1

      if {$PB_license == 534 } {
        $w.file.m add command -label $gPB(main,file,mdfa,Label) \
            -underline 0 -accelerator "Ctrl+I" -command PB_mdfa_ImportMdfa;

  #LICENSE_CK2
   # set gPB_help_tips($w.file.m,3) {$gPB(main,file,mdfa,Balloon)};

      } else {
        $w.file.m add sep;
      }
      if {$PB_license} {
        $w.file.m add command -label $gPB(main,file,save,Label) \
            -underline 0 -accelerator "Ctrl+S" -command UI_PB_SavePost;
        $w.file.m add command -label $gPB(main,file,save_as,Label) \
            -underline 1 -accelerator "Ctrl+A" -command UI_PB_SavePostAs;
      } else {
        $w.file.m add command -label $gPB(main,file,save,Label) -underline 0 \
                      -accelerator "Ctrl+S" \
                      -command "tk_messageBox -type ok -icon error" \
                      -message $gPB(nav_button,no_license,Message) ;
        $w.file.m add command -label $gPB(main,file,save_as,Label) -underline 1 \
                      -accelerator "Ctrl+A" \
                      -command "tk_messageBox -type ok -icon error" \
                      -message $gPB(nav_button,no_license,Message) ;\
       }


      $w.file.m add command -label $gPB(main,file,close,Label) -underline 0 \
                -accelerator "Ctrl+C" -command UI_PB_ClosePost;
      $w.file.m add sep;
      $w.file.m add command -label $gPB(main,file,exit,Label)  -underline 1 \
                -accelerator "Ctrl+X" -command UI_PB_ExitPost;
      global gPB_help_tips;
     # Set balloon state;
      set gPB(use_bal) 1;
      PB_init_balloons -state $gPB(use_bal);
     # Get screen width;
      set gPB(screen_width) [winfo vrootwidth $top];
      PB_init_balloons -screen $gPB(screen_width);
     # HELP pull-down menu;
     #;
      menu $w.help.m;
      set gPB(help_menu) $w.help.m;
      $w.help.m add checkbutton -under 0  -label $gPB(main,help,bal,Label) \
          -variable gPB(use_bal) -onvalue 1 -offvalue 0 \
          -command SetBalloonHelp;
      set gPB(use_info) 0;
      $w.help.m add checkbutton -under 0  -label $gPB(main,help,chelp,Label) \
          -variable gPB(use_info) -onvalue 1 -offvalue 0 \
          -command UI_PB_chelp_SetContextHelp;
      $w.help.m add sep;
      $w.help.m add command -label $gPB(main,help,dialog,Label) -underline 0 -command HelpCmd_dia;
      $w.help.m add command -label $gPB(main,help,manual,Label) -underline 0 -command HelpCmd_man;
      $w.help.m add sep;
      $w.help.m add command -label $gPB(main,help,about,Label)  -underline 0 -command HelpCmd_abo;
      $w.help.m add command -label $gPB(main,help,acknow,Label) -underline 1 -command HelpCmd_ack;
      pack $w.file   -side left;
      pack $w.help   -side right;
      pack $w -fill x;
     # FILE tool palette;
     #;
      set t [tixSelect $ww.tool -radio true -allowzero true \
                               -padx 2 -pady 2 \
                               -selectedbg magenta];
      set gPB(file_tool) $t;
        $t add new  -image [tix getimage pb_new]  -command UI_PB_NewPost;
        $t add open -image [tix getimage pb_open] -command UI_PB_OpenPost;

  #LICENSE_CK3

         if {$PB_license} {
            $t add save -image [tix getimage pb_file] -command UI_PB_SavePost;
          } else {
            $t add save -image [tix getimage pb_file] \
                        -command "tk_messageBox -type ok -icon error \
                        -message $gPB(nav_button,no_license,Message)";
          }

        [$t subwidget new]  config -anchor nw;
        [$t subwidget open] config -anchor nw;
        [$t subwidget save] config -anchor nw;
      pack $t -side left -anchor w -padx 5 -pady 2;
      PB_enable_balloon [$t subwidget new];
      PB_enable_balloon [$t subwidget open];
      PB_enable_balloon [$t subwidget save];
      set gPB_help_tips([$t subwidget new])     {$gPB(tool,new,Label)};
      set gPB_help_tips([$t subwidget open])    {$gPB(tool,open,Label)};
      set gPB_help_tips([$t subwidget save])    {$gPB(tool,save,Label)};
     # HELP tool palette;
     #;
      set h [tixSelect $ww.help -radio false -allowzero true \
                                -padx 2 -pady 2 -selectedbg magenta \
                                -variable gPB(help_sel_var) \
                                -command CB_HelpCmd];
      set gPB(help_tool) $h;
        $h add bal -image [tix getimage pb_balloon];
        $h add inf -image [tix getimage pb_info];
        $h add dia -image [tix getimage pb_help_dia];
        $h add man -image [tix getimage pb_help_man];
        [$h subwidget bal]  config -anchor nw;
        [$h subwidget inf]  config -anchor nw;
        [$h subwidget dia]  config -anchor nw;
        [$h subwidget man]  config -anchor nw;
      pack $h -side right -anchor w -padx 5;
      PB_enable_balloon [$h subwidget bal];
        set gPB_help_tips([$h subwidget bal]) {$gPB(tool,bal,Label)};
      PB_enable_balloon [$h subwidget inf];
        set gPB_help_tips([$h subwidget inf]) {$gPB(tool,chelp,Label)};
      PB_enable_balloon [$h subwidget dia];
        set gPB_help_tips([$h subwidget dia]) {$gPB(tool,dialog,Label)};
      PB_enable_balloon [$h subwidget man];
        set gPB_help_tips([$h subwidget man]) {$gPB(tool,manual,Label)};
     # Turn on Balloon Tip by default;
     # (This value can only be set after the button is added.);
      set gPB(help_sel_var) {bal};
      return $ww;
  };

#=====================================================================================
proc UIPB__createGauge {} {
#=====================================================================================
   global gPB;
   # Get screen width;
    set gPB(screen_width) [winfo vrootwidth .];
    set len 300;
    set w [expr $gPB(screen_width)/2 - $len/2];
   # Create window;
    set pw .prog;
    wm withdraw .;
    toplevel $pw;
    wm title $pw "Loading UG PostBuilder ...";
    wm geometry $pw +$w+400;
    wm deiconify $pw;
    set gPB(prog_window) $pw;
    set f [frame $pw.f -class Gauge];
    pack $f -expand yes -fill both -padx 10 -pady 10;
    set hi  [option get $f height Height];
    set d [canvas $f.display -borderwidth 0 -bg white -width $len -height $hi];
    pack $d -expand yes;
    set color [option get $f color Color];
    $d create rectangle 0 0 0 $hi -outline "" -fill $color -tags bar;
    $d create text [expr 0.5*$len] 10 -anchor c -text "0%" -tags value;
    grab $gPB(prog_window);
    $gPB(prog_window) config -cursor watch;
};

  option add *Gauge.borderWidth   2           widgetDefault;
  option add *Gauge.relief        sunken      widgetDefault;
  option add *Gauge.height        25          widgetDefault;
  option add *Gauge.color         lightBlue   widgetDefault;
#=====================================================================================
proc UIPB__updateGauge {val1 val2} {
#=====================================================================================
   global gPB;
    if {$val1 < 0  ||  $val1 > 100} {
      error "Bad starting value to Progress Gauge.";
    };
    if {$val2 < 0  ||  $val2 > 100} {
      error "Bad ending value to Progress Gauge.";
    };
    set display $gPB(prog_window).f.display;
    set ww [winfo width $display];
    set h [winfo height $display];
    set v [expr $val1 + 1];
    while {$v <= $val2} {
      set w [expr 0.01*$v*$ww];
      $display coords bar 0 0 $w $h;
      set percent [format "%3.0f%%" $v];
      $display itemconfig value -text $percent;
      update;
      after 100;
      set v [expr $v + 1];
    };
};

#=====================================================================================
proc UIPB__destroyGauge {} {
#=====================================================================================
   global gPB;
   if {[info exists gPB(prog_window)] && [winfo exists $gPB(prog_window)]} {
      global prog_pct prog_pct1 prog_inc;
      unset prog_pct prog_pct1 prog_inc;
      grab release $gPB(prog_window);
      destroy $gPB(prog_window);
      unset gPB(prog_window);
      update;
    };
};

#=====================================================================================
proc UI_PB_execute {} {
#=====================================================================================

}

#===============================================================
#
#!$%^(@*#&)  UG_POST_MILL
#===============================================================
;#global tcl_platform  tcl_version
;#global gPB

global PB_license
# Set License
# set PB_license   0 ; # NO
# set PB_license 495 ; # UG_POST_EXE
# set PB_license 533 ; # UG_POST_MILL
 set PB_license 534 ; # UG_POST_ADV_BLD

 set script [info script]
 if {$script != {}} {
     set gPB_dir [file dirname $script]
 } else {
     set gPB_dir [pwd]
 }

 global env
 set env(PB_DIR) $env(PB_HOME)/app
 set env(PWD) [pwd]
 puts "\n** Starting UG Post Builder in $env(PWD) **\n"
 #source $tcl_pkgPath/stooop/stooop.tcl
 namespace import stooop::*

 if { [file exists $env(PB_DIR)/ui/ui_pb_resource.tcl ] } {
  source $env(PB_DIR)/ui/ui_pb_resource.tcl
 }

 if { [file exists $env(HOME)/ui_pb_user_resource.tcl ] } {
  source $env(HOME)/ui_pb_user_resource.tcl
 }

 if { [file exists $env(HOME)/ui_pb_user_fonts.tcl ] } {
  source $env(HOME)/ui_pb_user_fonts.tcl
 }

set lstfile [ list          \
 /ui/ui_pb_main_tcl.tcl         \
 /ui/ui_pb_common_tcl.tcl       \
 /ui/ui_pb_file_tcl.tcl         \
 /ui/ui_pb_balloon_tcl.tcl      \
 /ui/ui_pb_context_help_tcl.tcl \
 /ui/ui_pb_class_tcl.tcl        \
 /ui/ui_pb_method_tcl.tcl       \
 /dbase/pb_file_tcl.tcl         \
 /dbase/pb_class_tcl.tcl        \
 /dbase/pb_method_tcl.tcl       \
 /dbase/pb_common_tcl.tcl       \
 /dbase/pb_pui_parser_tcl.tcl   \
 /dbase/pb_proc_parser_tcl.tcl  \
 /dbase/pb_machine_tcl.tcl      \
 /dbase/pb_format_tcl.tcl       \
 /dbase/pb_address_tcl.tcl      \
 /dbase/pb_block_tcl.tcl        \
 /dbase/pb_list_tcl.tcl         \
 /dbase/pb_event_tcl.tcl        \
 /dbase/pb_sequence_tcl.tcl     \
 /dbase/pb_ude_tcl.tcl          \
 /dbase/pb_output_tcl.tcl       \
 /ui/ui_pb_machine_tcl.tcl      \
 /ui/ui_pb_definition_tcl.tcl   \
 /ui/ui_pb_format_tcl.tcl       \
 /ui/ui_pb_address_tcl.tcl      \
 /ui/ui_pb_block_tcl.tcl        \
 /ui/ui_pb_others_tcl.tcl       \
 /ui/ui_pb_program_tcl.tcl      \
 /ui/ui_pb_progtpth_tcl.tcl     \
 /ui/ui_pb_gcode_tcl.tcl        \
 /ui/ui_pb_mcode_tcl.tcl        \
 /ui/ui_pb_addrsum_tcl.tcl      \
 /ui/ui_pb_cmdmsg_tcl.tcl       \
 /ui/ui_pb_addrseq_tcl.tcl      \
 /ui/ui_pb_sequence_tcl.tcl     \
 /ui/ui_pb_toolpath_tcl.tcl     \
 /ui/ui_pb_list_tcl.tcl         \
 /ui/ui_pb_preview_tcl.tcl      \
 /ui/ui_pb_advisor_tcl.tcl
 ] ;
set ll [ llength  $lstfile ]

 UIPB__createGauge
 global prog_pct prog_pct1 prog_inc
 set prog_pct 0
 set prog_inc [expr 100/$ll] ; # 100/40

for {set ii 0} {$ii<$ll} {incr ii} {
 set prog_pct1 [expr $prog_pct + $prog_inc]
 UIPB__updateGauge $prog_pct $prog_pct1
 set prog_pct $prog_pct1
 set fn $env(PB_DIR)[ lindex $lstfile $ii ]
 source  $fn
 puts ${ii})${fn}
}

    if { $PB_license == 533 } {
      set gPB(PB_LICENSE) UG_POST_MILL
      puts "\nUG PostBuilder General License Usage\n";
    }
    if { $PB_license == 534 } {
      set gPB(PB_LICENSE) UG_POST_ADV_BLD
      puts "\nUG PostBuilder Advanced License Usage\n";
       if { [file exists $env(PB_DIR)/mdfa/pb_mdfa.tcl ] } {
  source $env(PB_DIR)/mdfa/pb_mdfa.tcl
  }
 } else {
      set gPB(PB_LICENSE) UG_POST_NO_LICENSE
      puts "\nUG PostBuilder No License Usage\n";
    }

 UIPB__updateGauge $prog_pct 100
 after 500
 UIPB__destroyGauge

wm withdraw .
UI_PB_main .widget
bind .widget <Destroy> UI_PB_ExitPost
# $gPB(top_window) config -cursor watch 

#wm withdraw .widget; wm deiconify .widget
#$gPB(top_window) config -cursor ""

