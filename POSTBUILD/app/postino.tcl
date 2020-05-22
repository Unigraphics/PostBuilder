#
#
#
package require Tix
package require stooop


proc UI_PB__main_menu { top } {
	global tixOption;
	global paOption;
	global gPB;
	set ww [frame $top.f -bd 2 -relief raised];
	set gPB(main_menu) $ww;
	set w  [frame $ww.mb -bg $paOption(menu_bar_bg)];
	set gPB(main_menu_bar) $w;
	menubutton $w.file -menu $w.file.m -text $gPB(main,file,Label) -underline 0 \
	-takefocus 1 -bg $paOption(menu_bar_bg);
	set gPB(file_menu) $w.file.m;
	menubutton $w.help -menu $w.help.m -text $gPB(main,help,Label) -underline 0 \
	    -takefocus 1 -bg $paOption(menu_bar_bg);
	menu $w.file.m -tearoff 0;
	$w.file.m add command -label $gPB(main,file,new,Label) -underline 0 \
	-accelerator "Ctrl+N" -command UI_PB_NewPost;
	$w.file.m add command -label $gPB(main,file,open,Label) -underline 0 \
	-accelerator "Ctrl+O" -command UI_PB_OpenPost;
	#LICENSE_CK1

$w.file.m add command -label $gPB(main,file,mdfa,Label) \
-underline 0 -accelerator "Ctrl+I" -command PB_mdfa_ImportMdfa;
###$w.file.m add sep;
$w.file.m add command -label $gPB(main,file,save,Label) \
-underline 0 -accelerator "Ctrl+S" -command UI_PB_SavePost;
$w.file.m add command -label $gPB(main,file,save_as,Label) \
-underline 1 -accelerator "Ctrl+A" -command UI_PB_SavePostAs;
###$w.file.m add command -label $gPB(main,file,save,Label) -underline 0 \
###-accelerator "Ctrl+S" \
###-command "tk_messageBox -type ok -icon error \
###-message \$gPB(nav_button,no_license,Message)";
###$w.file.m add command -label $gPB(main,file,save_as,Label) -underline 1 \
###-accelerator "Ctrl+A" \
###-command "tk_messageBox -type ok -icon error \
###-message \$gPB(nav_button,no_license,Message)";

	$w.file.m add command -label $gPB(main,file,close,Label) -underline 0 \
	-accelerator "Ctrl+C" -command UI_PB_ClosePost;

	$w.file.m add sep;
	$w.file.m add command -label $gPB(main,file,exit,Label)  -underline 1 \
	-accelerator "Ctrl+X" -command UI_PB_ExitPost;
	set gPB(menu_index,file,new)     0;
	set gPB(menu_index,file,open)    1;
	set gPB(menu_index,file,mdfa)    2;
	set gPB(menu_index,file,save)    3;
	set gPB(menu_index,file,save_as) 4;
	set gPB(menu_index,file,close)   5;
	set gPB(menu_index,file,exit)    7;
	set gPB(menu_index,file,sep)     8;
	set gPB(menu_index,file,history) 9;
	global gPB_help_tips;
	# Set balloon state;
	set gPB(use_bal) 1;
	PB_init_balloons -state $gPB(use_bal);
	# Get screen width;
	set gPB(screen_width) [winfo vrootwidth $top];
	PB_init_balloons -screen $gPB(screen_width);

	# HELP pull-down menu;
	#;
	menu $w.help.m -tearoff 0;
	set gPB(help_menu) $w.help.m;
	$w.help.m add checkbutton -under 0  -label $gPB(main,help,bal,Label) \
	-variable gPB(use_bal) -onvalue 1 -offvalue 0 \
	-command SetBalloonHelp;
	set gPB(use_info) 0;
	$w.help.m add checkbutton -under 0  -label $gPB(main,help,chelp,Label) \
	-variable gPB(use_info) -onvalue 1 -offvalue 0 \
	-command UI_PB_chelp_SetContextHelp;
	$w.help.m add sep;
	$w.help.m add command -label $gPB(main,help,manual,Label) -underline 0 -command HelpCmd_man;
	$w.help.m add sep;
	$w.help.m add command -label $gPB(main,help,about,Label)  -underline 0 -command HelpCmd_abo;
	set gPB(menu_index,help,bal)    0;
	set gPB(menu_index,help,chelp)  1;
	set gPB(menu_index,help,manual) 3;
	set gPB(menu_index,help,about)  5;
	set gPB(menu_index,help,acknow) 6;
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
	;#LICENSE_CK3

$t add save -image [tix getimage pb_file] -command UI_PB_SavePost;
##$t add save -image [tix getimage pb_file] \
##-command "tk_messageBox -type ok -icon error \
##-message \$gPB(nav_button,no_license,Message)";

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
	PB_enable_balloon [$h subwidget man];
	set gPB_help_tips([$h subwidget man]) {$gPB(tool,manual,Label)};

;#LICENSE_CK2
set gPB_help_tips($w.file.m,$gPB(menu_index,file,mdfa)) {$gPB(main,file,mdfa,Balloon)};

	# Turn on Balloon Tip by default;
	# (This value can only be set after the button is added.);
	set gPB(help_sel_var) {bal};

	return $ww;
 };


## UI_PB_encrypt_post $env(LIC_HOME)/pb_license_tcl.txt $tmp_list TRUE
proc UI_PB_encrypt_post { filename source_list isLicenseList } {
 ;
}

## UI_PB_decrypt_post {$tcl_encrypted} TRUE NO NO
proc UI_PB_decrypt_post { filename isReturn isLicenseList isCheck } {
 ;
}

proc UIPB__createGauge {} {
	global gPB;
	# Get screen width;
	set gPB(screen_width) [winfo vrootwidth .];
	set len 300;    set w [expr $gPB(screen_width)/2 - $len/2];
	# Create window;
	set pw .prog;
	wm withdraw .;
	toplevel $pw;
	wm title $pw "$gPB(load_pb_title)";
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

proc UIPB__updateGauge {val1 val2} {
	global gPB;
	if { $val1 < 0  ||  $val1 > 100 } {
		error "Bad starting value to Progress Gauge.";
	};
	if { $val2 < 0  ||  $val2 > 100 } {
		error "Bad ending value to Progress Gauge.";
        };
        set display $gPB(prog_window).f.display;
        set ww [winfo width $display];
        set h [winfo height $display];
        set v [expr $val1 + 1];
        while { $v <= $val2 } {
        	set w [expr 0.01*$v*$ww];
        	$display coords bar 0 0 $w $h;
        	set percent [format "%3.0f%%" $v];
        	$display itemconfig value -text $percent;
        	update;
        	after 50;
        	if { $v == $val2 }  {	break }
        	set v [expr $v + 5];
        	if { $v > $val2 }  { set v $val2 }
         };
};

proc UIPB__destroyGauge { } {
 global gPB;
 if { [info exists gPB(prog_window)] && [winfo exists $gPB(prog_window)] } {
    global prog_pct prog_pct1 prog_inc;
    unset prog_pct prog_pct1 prog_inc;
    grab release $gPB(prog_window);
    destroy $gPB(prog_window);
    unset gPB(prog_window);
    update;
  };
};


#===============================================================
;#global tcl_platform  tcl_version
;#global gPB

# Set License
# set gPB(PB_LICENSE) "UG_POST_NO_LICENSE" ; # 0  \nNX/Post Builder No License Usage\n
# set gPB(PB_LICENSE) "UG_POST_EXE" ; # 495   \nNX/Post Builder General License Usage\n
# set gPB(PB_LICENSE) "UG_POST_MILL" ; # 533  \nNX/Post Builder General License Usage\n
 set gPB(PB_LICENSE) "UG_POST_ADV_BLD" ; # 534 \nNX/Post Builder Advanced License Usage\n
# set gPB(PB_LICENSE) "UG_POST_AUTHOR" ; # 535 \nNX/Post Builder Author License Usage\n

# set gPB(SITE_ID_IS_OK_FOR_LL) 1
# set gPB(SITE_ID_IS_OK_FOR_LL) 0
# set LicInfo(SITE_ID_IS_OK_FOR_PT) 1
# set LicInfo(SITE_ID_IS_OK_FOR_PT) 0

# set post_site_id LicInfo
# set post_license LicInfo
# set post_license_vnc LicInfo

 set ::disable_license 1
 
 #set gPB(PB_SITE_ID) 0
 #set gPB(auto_qc) 0

 set gPB(lic_list) [ list ]

 global env
 set env(PB_DIR) $env(PB_HOME)/app
 set env(PWD) [pwd]
 puts "\n** Starting UG Post Builder in $env(PWD) **\n"
 #source $tcl_pkgPath/stooop/stooop.tcl
 #namespace import stooop::*
 source $env(PB_DIR)/ui/ui_pb_resource.tcl

 if { [file exists $env(HOME)/ui_pb_user_resource.tcl ] } {
  source $env(HOME)/ui_pb_user_resource.tcl
 }

 if { [file exists $env(HOME)/ui_pb_user_fonts.tcl ] } {
  source $env(HOME)/ui_pb_user_fonts.tcl
 }

 if { [file exists $env(PB_DIR)/mdfa/pb_mdfa.tcl ] } {
  source $env(PB_DIR)/mdfa/pb_mdfa.tcl
 }

 global procfid ; # char [110]
 set procfid "ID: Che" ;

 UIPB__createGauge

 global	prog_pct prog_pct1 prog_inc
 set prog_pct 0
 set prog_inc [expr 100/40]

 set pb_kernel1 {
/ui/ui_pb_main_tcl.tcl         \
/ui/ui_pb_common_tcl.tcl       \
/ui/ui_pb_file_tcl.tcl         \
/ui/ui_pb_balloon_tcl.tcl      \
/ui/ui_pb_context_help_tcl.tcl \
/dbase/pb_common_tcl.tcl
 }

  for { set i 0 } { $i<[llength $pb_kernel1] } { incr i } {
    set s1 [lindex $pb_kernel1 $i]
    source $env(PB_DIR)$s1
    set prog_pct1 [expr $prog_pct + $prog_inc ]
    UIPB__updateGauge $prog_pct $prog_pct1
    set prog_pct $prog_pct1
  }

  wm withdraw .
  UI_PB_main .widget
  bind .widget <Destroy> UI_PB_ExitPost
  $gPB(top_window) config -cursor watch

  set pb_kernel2 {
/ui/ui_pb_class_tcl.tcl        \
/ui/ui_pb_method_tcl.tcl       \
/dbase/pb_file_tcl.tcl         \
/dbase/pb_class_tcl.tcl        \
/dbase/pb_method_tcl.tcl       \
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
/ui/ui_pb_advisor_tcl.tcl      \
/ui/ui_pb_ude_tcl.tcl
}

  for { set i 0 } { $i<[llength $pb_kernel2] } { incr i } {
    set s1 [lindex $pb_kernel2 $i]
    source $env(PB_DIR)$s1
    set prog_pct1 [expr $prog_pct + $prog_inc ]
    UIPB__updateGauge $prog_pct $prog_pct1
    set prog_pct $prog_pct1
  }
  
  UIPB__updateGauge $prog_pct 100
  after 500
  UIPB__destroyGauge
  
  if { [info exists gPB(CMD_LINE_PUI)] } {
    set gPB(CMD_LINE_PUI) ""
    update
    UI_PB_OpenCmdLinePost
  }
  
  wm withdraw .widget; wm deiconify .widget
  $gPB(top_window) config -cursor ""

#============================================
proc UI_PB_execute { fn1 } {
#============================================
# ShellExecuteA(0, "open", filename, 0, 0, 1);
    if {0==[ file exists $fn1 ]} { return 1 ; }
    
    ## htm html chm hlp txt
    set ext [ file extension $fn1 ] ;
    
    if {[ string compare $ext ".txt"]==0} {
     catch { exec -- "notepad" $fn1  } ;
     return 0 ;
    }
    if {[ string compare $ext ".htm"]==0 || [ string compare $ext ".html"]==0} {
     catch { exec -- "C:\\Program Files\\Internet Explorer\\iexplore" $fn1  } ;
     ##catch { exec -- "iexplore.exe" $fn1  } err;
     return 0 ;
    }
    if {[ string compare $ext ".chm"]==0} {
     catch { exec -- "hh.exe" $fn1  } ;
     return 0 ;
    }
    
    return 1 ;
}


#UI_PB_interactive
#================
