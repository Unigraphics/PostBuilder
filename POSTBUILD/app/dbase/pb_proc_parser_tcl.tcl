source $env(PB_HOME)/app/dbase/pb_mom.tcl

#=======================================================================
proc PB_pps_CollectTclFileObjs { POST_OBJECT tcl_file_name sync args } {
  upvar $POST_OBJECT post_object
  if { [catch { set sta [PB_pps_ParseTclFile $tcl_file_name event_proc_data $sync] } ] } {
   global errorInfo
   return [ error "$errorInfo" ]
  }
  if { $sta == "TCL_ERROR" } {
   return [ error "" ]
  }
  set event_name_list [array get event_proc_data]
  set cmd_proc_list ""
  set oth_proc_list ""
  set llen [llength $event_name_list]
  for {set i 0} {$i < $llen} {incr i 2} \
  {
   set event_item [lindex $event_name_list $i]
   if { ![string match "MOM*" $event_item] && [string match "*\,name" $event_item] } \
   {
    if { [string match "PB_CMD*" $event_item] } \
    {
     set event_name [lindex [split $event_item ,] 0]
     set cmd_proc_list [ladd $cmd_proc_list end $event_name "no_dup"]
     set cmd_proc_data($event_name,proc) $event_proc_data($event_name,proc)
     set cmd_proc_data($event_name,blk_list) $event_proc_data($event_name,blk_list)
     set cmd_proc_data($event_name,add_list) $event_proc_data($event_name,add_list)
     set cmd_proc_data($event_name,fmt_list) $event_proc_data($event_name,fmt_list)
     UI_PB_debug_DisplayMsg "Custom Command : $event_name" no_debug
     } elseif { ![string match "PB*" $event_item] } \
    {
     set event_name [lindex [split $event_item ,] 0]
     set oth_proc_list [ladd $oth_proc_list end $event_name "no_dup"]
     set oth_proc_data($event_name,comment) $event_proc_data($event_name,comment)
     set oth_proc_data($event_name,args)    $event_proc_data($event_name,args)
     set oth_proc_data($event_name,proc)    $event_proc_data($event_name,proc)
     UI_PB_debug_DisplayMsg "Other Command : $event_name" no_debug
    }
   }
  }
 }

#=======================================================================
proc PB_pps_CreateTclFileObjs { POST_OBJECT tcl_file_name sync args } {
  upvar $POST_OBJECT post_object
  global gPB
  if { [catch { set sta [PB_pps_ParseTclFile $tcl_file_name event_proc_data $sync] } ] } {
   global errorInfo
   return [ error "$errorInfo" ]
  }
  if { $sta == "TCL_ERROR" } {
   return [ error "" ]
  }
  set event_name_list [array get event_proc_data]
  set cmd_proc_list ""
  set oth_proc_list ""
  Post::GetOthProcList $post_object oth_proc_list
  Post::GetOthProcData $post_object oth_proc_data
  set llen [llength $event_name_list]
  for {set i 0} {$i < $llen} {incr i 2} \
  {
   set event_item [lindex $event_name_list $i]
   if { ![string match "MOM*" $event_item] && [string match "*\,name" $event_item] } \
   {
    if { [string match "PB_CMD*" $event_item] } \
    {
     set event_name [lindex [split $event_item ,] 0]
     lappend cmd_proc_list $event_name
     set cmd_proc_data($event_name,proc) $event_proc_data($event_name,proc)
     set cmd_proc_data($event_name,blk_list) $event_proc_data($event_name,blk_list)
     set cmd_proc_data($event_name,add_list) $event_proc_data($event_name,add_list)
     set cmd_proc_data($event_name,fmt_list) $event_proc_data($event_name,fmt_list)
     } elseif { ![string match "PB*" $event_item] } \
    {
     set event_name [lindex [split $event_item ,] 0]
     if { [info exists gPB(pui_ui_overwrite)]  &&  $gPB(pui_ui_overwrite) } {
      set oth_proc_list [ladd $oth_proc_list end $event_name "no_dup"]
      set oth_proc_data($event_name,comment) $event_proc_data($event_name,comment)
      set oth_proc_data($event_name,args)    $event_proc_data($event_name,args)
      set oth_proc_data($event_name,proc)    $event_proc_data($event_name,proc)
      } else {
      if { [lsearch $oth_proc_list $event_name] < 0 } {
       lappend oth_proc_list $event_name
       set oth_proc_data($event_name,comment) $event_proc_data($event_name,comment)
       set oth_proc_data($event_name,args)    $event_proc_data($event_name,args)
       set oth_proc_data($event_name,proc)    $event_proc_data($event_name,proc)
      }
     }
    }
   }
   Post::GetEventProcs $post_object event_procs
   if { [string match "*\,name" $event_item] } \
   {
    set event_name [lindex [split $event_item ,] 0]
    set proc_data $event_proc_data($event_name,proc)
    set proc_data [linsert $proc_data 0 \
    "\#=============================================================" \
    "proc\ $event_name\ \{\ \}\ \{" \
     "\#============================================================="]
    set proc_data [linsert $proc_data end "\}"]
    set event_procs($event_name) $proc_data
   }
  }
  if [info exists event_procs] \
  {
   Post::SetEventProcs $post_object event_procs
  }
  foreach cmd_blk $cmd_proc_list \
  {
   set cmd_obj_attr(0) $cmd_blk
   set cmd_obj_attr(1) $cmd_proc_data($cmd_blk,proc)
   set cmd_obj_attr(2) $cmd_proc_data($cmd_blk,blk_list)
   set cmd_obj_attr(3) $cmd_proc_data($cmd_blk,add_list)
   set cmd_obj_attr(4) $cmd_proc_data($cmd_blk,fmt_list)
   PB_pps_CreateCommand cmd_obj_attr cmd_obj
  }
  Post::GetObjList $post_object command cmd_blk_list
  PB_com_SortObjectsByNames cmd_blk_list
  Post::SetObjListasAttr $post_object cmd_blk_list
  if { [info exists oth_proc_list] && [info exists oth_proc_data] } {
   Post::SetOthProcList $post_object oth_proc_list
   Post::SetOthProcData $post_object oth_proc_data
   unset oth_proc_list
   unset oth_proc_data
  }
 }

#=======================================================================
proc PB_pps_UpdatePostAttr {} {
  global post_object
  uplevel 1 {
   global post_object
   set list_obj_list $Post::($post_object,list_obj_list)
   set list_obj [lindex $list_obj_list 0]
   ListingFile::readvalue $list_obj obj_attr
   set mom_var_list [info vars "mom_sys_list_output"]
   if [llength $mom_var_list] {
    set obj_attr(listfile) $mom_sys_list_output
   }
   set mom_var_list [info vars "mom_sys_header_output"]
   if [llength $mom_var_list] {
    set obj_attr(head) $mom_sys_header_output
   }
   set mom_var_list [info vars "mom_sys_list_file_rows"]
   if [llength $mom_var_list] {
    set obj_attr(lines) $mom_sys_list_file_rows
   }
   set mom_var_list [info vars "mom_sys_list_file_columns"]
   if [llength $mom_var_list] {
    set obj_attr(column) $mom_sys_list_file_columns
   }
   set mom_var_list [info vars "mom_sys_warning_output"]
   if [llength $mom_var_list] {
    set obj_attr(warn) $mom_sys_warning_output
   }
   set mom_var_list [info vars "mom_sys_group_output"]
   if [llength $mom_var_list] {
    set obj_attr(group) $mom_sys_group_output
   }
   set mom_var_list [info vars "mom_sys_list_file_suffix"]
   if [llength $mom_var_list] {
    set obj_attr(lpt_ext) $mom_sys_list_file_suffix
   }
   set mom_var_list [info vars "mom_sys_output_file_suffix"]
   if [llength $mom_var_list] {
    set obj_attr(ncfile_ext) $mom_sys_output_file_suffix
   }
   ListingFile::setvalue $list_obj obj_attr
   set mom_kin_list [info vars "mom_kin*"]
   array set mom_kin_arr $Post::($post_object,mom_kin_var_list)
   foreach v $mom_kin_list {
    set var [format %s%s "\$" $v]
    if [info exists mom_kin_arr($var)] {
     set val [eval format %s $var]
     set mom_kin_arr($var) $val
    }
   }
   set Post::($post_object,mom_kin_var_list)     [array get mom_kin_arr]
   set Post::($post_object,def_mom_kin_var_list) [array get mom_kin_arr]
   set mom_sys_list [info vars "mom_sys*"]
   array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
   foreach v $mom_sys_list {
    if [array exists $v] {
     set lv [array get $v]
     set ll [llength $lv]
     for {set i 0} {$i < $ll} {incr i 2} {
      set var [format %s%s%s "\$" $v "([lindex $lv $i])"]
      set val [eval format %s $var]
      set mom_sys_arr($var) $val
     }
     } else {
     set var [format %s%s "\$" $v]
     set val [eval format %s $var]
     set mom_sys_arr($var) $val
    }
   }
   set Post::($post_object,mom_sys_var_list)     [array get mom_sys_arr]
   set Post::($post_object,def_mom_sys_var_list) [array get mom_sys_arr]
  } 
 }

#=======================================================================
proc PB_pps_CreateCommand { CMD_OBJ_ATTR CMD_OBJ } {
  upvar $CMD_OBJ_ATTR cmd_obj_attr
  upvar $CMD_OBJ cmd_obj
  global post_object
  Post::GetObjList $post_object command cmd_blk_list
  if [info exists cmd_obj] { unset cmd_obj }
  foreach cc $cmd_blk_list {
   command::readvalue $cc attr
   if { $attr(0) == "$cmd_obj_attr(0)" } {
    set cmd_obj $cc
    break
   }
  }
  if { ![info exists cmd_obj] } {
   set cmd_obj [new command]
   lappend cmd_blk_list $cmd_obj
   Post::SetObjListasAttr $post_object cmd_blk_list
  }
  command::setvalue $cmd_obj cmd_obj_attr
  command::DefaultValue $cmd_obj cmd_obj_attr
 }

#=======================================================================
proc PB_pps_CreateCmdFromCmdObj { CMD_OBJ_LIST CMD_OBJ OBJ_INDEX } {
  upvar $CMD_OBJ_LIST cmd_obj_list
  upvar $CMD_OBJ cmd_obj
  upvar $OBJ_INDEX obj_index
  command::readvalue $cmd_obj cmd_obj_attr
  PB_blk_GetCmdNamelist cmd_obj_list cmd_name_list
  PB_com_SetDefaultName cmd_name_list cmd_obj_attr
  PB_pps_CreateCommand cmd_obj_attr new_cmd_obj
  set cmd_obj_list [linsert $cmd_obj_list $obj_index $new_cmd_obj]
  global post_object
  Post::SetObjListasAttr $post_object cmd_obj_list
 }

#=======================================================================
proc PB_pps_GetCmdBlkProc { EVENT_PROC CMD_PROC } {
  upvar $EVENT_PROC event_proc
  upvar $CMD_PROC cmd_proc
  set length [llength $event_proc]

#=======================================================================
set cmd_proc [lrange $event_proc 3 [expr $length - 2]]
}

#=======================================================================
proc PB_pps_ParseTclFile { tcl_file_name EVENT_PROC_DATA sync } {
  upvar $EVENT_PROC_DATA event_proc_data
  global errorInfo
  set parse_tcl 1
  while { $parse_tcl } {
   if [ catch {source $tcl_file_name} res ] {
    UI_PB_debug_ForceMsg "$res"
    if { $errorInfo != "" } {
     return [error "" $errorInfo]
    }
    } else {
    set parse_tcl 0
   }
  }
  if $sync {
   PB_pps_UpdatePostAttr
  }
  set tcl_fid [open "$tcl_file_name" r]
  set proc_start 0
  set prev_proc_body ""
  while { [gets $tcl_fid line] >= 0 }\
  {
   set temp_line [string trim $line]
   if [string match "#*" $temp_line] \
   {
    lappend comment_lines $line
   }
   set temp_line $line
   PB_com_RemoveBlanks temp_line

#=======================================================================
if { [string match "proc *" $temp_line] == 1} \
 {
  set event_name [lindex $temp_line 1]
  set proc_is_dummy 0
  foreach p $prev_proc_body {
   if [string match "proc*$event_name*" $p] {
    set proc_is_dummy 1
    break
   }
  }
  if { $proc_is_dummy } {

#=======================================================================
proc $event_name {args} {}
 } else {
 set proc_start 1
 if { ![string match "PB_*"  $event_name]  && \
 ![string match "MOM_*" $event_name] } \
 {
  if [info exists comment_lines] \
  {
   set event_proc_data($event_name,comment) $comment_lines
  } else \
  {
   set event_proc_data($event_name,comment) ""
  }
 }
 if [info exists comment_lines] \
 {
  unset comment_lines
 }
 set event_proc_data($event_name,name) $event_name
 set event_proc_data($event_name,args) [info args $event_name]
 set proc_data ""
 set proc_body ""
 set proc_body [concat [info body $event_name]]
 set proc_body [split $proc_body "\n"]
 if { [string match "PB_*"  $event_name]  || \
 [string match "MOM_*" $event_name] } \
 {
  if [string match "\#===*" [lindex $proc_body 0]] \
  {
   set proc_body [lreplace $proc_body 0 0]
  }
 }
 foreach e $proc_body \
 {
  lappend proc_data $e
 }
 set event_proc_data($event_name,proc) $proc_data
 set prev_proc_body ""
 foreach p $proc_body {
  lappend prev_proc_body [string trim $p]
 }
} 
} else \
{
set proc_start 0
}
if { $proc_start  &&  ![string match "PB_*"  $event_name]  && \
![string match "MOM_*" $event_name] } \
{
rename $event_name ""

#=======================================================================
proc $event_name {args} {}
}
if { $proc_start  &&  [string match "PB_CMD*" $event_name] } \
{
 global gPB
 UI_PB_debug_DisplayMsg "command name = $event_name" no_debug
 set proc_state [PB_proc_ValidateCustCmd $proc_body res]
 set event_proc_data($event_name,blk_list) $gPB(CMD_BLK_LIST)
 set event_proc_data($event_name,add_list) $gPB(CMD_ADD_LIST)
 set event_proc_data($event_name,fmt_list) $gPB(CMD_FMT_LIST)
}
if { [string match "\}*" $line] == 1} \
{
if [info exists comment_lines] \
{
 unset comment_lines
}
}
}
close $tcl_fid
}

#=======================================================================
proc PB_proc_ValidateCustCmd { proc_body RES } {
  upvar $RES res
  global gPB
  global post_object
  if { ![info exists Post::($post_object,ass_cmd_list)] } {
   set Post::($post_object,ass_cmd_list) ""
   } else {
   Post::GetObjList  $post_object command cmd_obj_list
   foreach cmd_obj $cmd_obj_list {
    set cmd $command::($cmd_obj,name)
    set ass_idx [lsearch $Post::($post_object,ass_cmd_list) $cmd]
    if { $ass_idx >= 0 } {
     set Post::($post_object,ass_cmd_list) \
     [lreplace $Post::($post_object,ass_cmd_list) $ass_idx $ass_idx]
    }
   }
  }
  set tmp_proc_data ""
  foreach e $proc_body {
   set ee [string trim $e]
   if [string length $ee] {
    if { ![string match "rename*" $ee] &&  ![string match "#*" $ee] } {
     if [string match "*uplevel*" $ee] {
      set head ""
      set idx [string first "uplevel" $ee]
      if { $idx >= 0 } {
       set head [string range $ee 0 [expr $idx - 1]]
      }
     }
     if [string match "*uplevel*\{*" $ee] {
       set tail ""
       set idx [string first "\{" $ee]
        if { $idx >= 0 } {
         set tail [string range $ee [expr $idx + 1] end]
        }
        set ee [string trim [join [list $head "uplevel\ 1\ \{" $tail]]]
         } elseif [string match "*uplevel*\\" $ee] {
         set ee [string trim [join [list $head "uplevel\ 1\ \\"]]]
        }
        lappend tmp_proc_data $ee
       }
      }
     }
     set gPB(CMD_BLK_LIST) [list]
     set gPB(CMD_ADD_LIST) [list]
     set gPB(CMD_FMT_LIST) [list]
     set proc_ok 0
     set loop_idx 0 
     if 0 {
      if [catch { eval [join $tmp_proc_data \n] } res] {
       if { ![string match "*no such variable*" $res]} {
        set proc_ok -1
       }
      }
     }
     set n_iter 20 
     set res_prev ""
     PB_mom_DisguiseTclCmds_1
     set Post::($post_object,unk_cmd_list) [list]
     while { $proc_ok == 0 } {
      PB_mom_DisguiseTclCmds_2
      if [catch { eval [join $tmp_proc_data \n] } res] {
       UI_PB_debug_ForceMsg "$res"
       PB_mom_RestoreTclCmds_2
       if { $res == "$res_prev" } {
        set proc_ok 1
        continue
       }
       if [string match "*variable*exists*" $res] {
        set idx [lsearch $res "variable"]
        if { $idx >= 0 } {
         set var [lindex $res [expr $idx + 1]]
         set var [string trim $var "\""]
         unset $var
        }
        } elseif { [string match "*no such variable*" $res] || \
        [string match "*no such element*" $res] } {
        set idx [string first ":" $res]
        if { $idx >= 0 } {
         set res1 [string range $res 0 [expr $idx - 1]]
         set var  [lindex $res1 end]
         set var  [string trim $var "\""]
         if { [string index $var [expr [string length $var] - 1]] == ")" } {
          set idx [string first "(" $var]
          set this_var [string range $var 0 [expr $idx - 1]]
          } else {
          set this_var $var
         }
         if { ![string match "*\$$this_var*" $tmp_proc_data]} {
          global $this_var
          set $var 0
          } else { 
          set var_is_global 0
          foreach e $tmp_proc_data {
           if [string match "*global*$this_var*" $e] {
            set var_is_global 1
            break
           }
          }
          if $var_is_global {
           set $var 0
           } else {
           if $gPB(check_cc_syntax_error) {
            set proc_ok -1
            continue
            } else {
            set $var 0
           }
          }
         }
        }
        } elseif [string match "*invalid command name*" $res] {
        set var [lindex $res end]
        set var [string trim $var "\""]
        if $gPB(check_cc_unknown_command) {
         if { [lsearch $Post::($post_object,unk_cmd_list) $var] < 0  && \
          [lsearch $Post::($post_object,ass_cmd_list) $var] < 0 } {
          lappend Post::($post_object,unk_cmd_list) $var
         }
        }

#=======================================================================
proc $var {args} {}
 lappend tmp_proc_list $var
 } else {
 if $gPB(check_cc_syntax_error) {
  set proc_ok -1
 }
}
} else {
set proc_ok 1
}
incr loop_idx
if { $loop_idx > $n_iter } { set proc_ok 1 }
set res_prev $res
PB_mom_RestoreTclCmds_2
}
PB_mom_RestoreTclCmds_1
if [info exists tmp_proc_list] {
foreach p $tmp_proc_list {
rename $p ""
}
unset tmp_proc_list
}
if { $proc_ok != 1 } {
global errorInfo
set idx [string last "invoked from within" $errorInfo]
if { $idx > 0 } {
set res [string range $errorInfo 0 [expr $idx - 1]]
} else {
set res $errorInfo
}
set res "$res\n\n$gPB(cust_cmd,error,msg)"
set proc_ok 0
}
return $proc_ok
}
