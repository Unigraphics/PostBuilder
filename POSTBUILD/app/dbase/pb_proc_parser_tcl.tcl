#10
source $env(PB_HOME)/app/dbase/pb_mom.tcl
source $env(PB_HOME)/app/dbase/pb_sim.tcl
UI_PB_AddPatchMsg "2001.0.1" "<07-25-02>  Fixed problem with syntax checking of custom commands."

#=======================================================================
proc PB_pps_CleanUpTclFileObjs { args } {
  global gPB post_object
  foreach cmd [info procs PB_CMD_*] {
   if [info exists gPB(procs)] {
    if { [lsearch $gPB(procs) "$cmd"] < 0 } {
     rename $cmd ""
    }
    } else {
    rename $cmd ""
   }
  }
  set mom_proc_list { MOM_ask_env_var              \
   MOM_before_each_add_var      \
   MOM_before_each_event        \
   MOM_abort                    \
   MOM_incremental              \
   MOM_remove_file              \
   MOM_set_debug_mode           \
   MOM_reset_sequence           \
   MOM_set_seq_on               \
   MOM_set_seq_off              \
   MOM_enable_address           \
   MOM_disable_address          \
   MOM_do_template              \
   MOM_force                    \
   MOM_suppress                 \
   MOM_set_address_format       \
   MOM_output_text              \
   MOM_output_literal           \
   MOM_output_to_listing_device \
   MOM_abort                    \
   MOM_load_definition_file     \
   MOM_close_output_file        \
   MOM_open_output_file         \
   MOM_load_kinematics          \
   MOM_reload_kinematics        \
   MOM_reload_variable          \
   MOM_run_user_function        \
   MOM_do_template_file         \
   MOM_cycle_objects            \
  MOM_ask_library_attributes }
  foreach cmd [info procs MOM_*] {
   if { [lsearch $mom_proc_list "$cmd"] < 0 } {
    if [info exists gPB(procs)] {
     if { [lsearch $gPB(procs) "$cmd"] < 0 } {
      rename $cmd ""
     }
     } else {
     rename $cmd ""
    }
   }
  }
  if { [llength $args] > 0 } {
   upvar $[lindex $args 0] event_proc_data
   set event_name_list [array get event_proc_data]
   set llen [llength $event_name_list]
   for {set i 0} {$i < $llen} {incr i 2} \
   {
    set event_item [lindex $event_name_list $i]
    if { ![string match "MOM*" $event_item] && [string match "*\,name" $event_item] } \
    {
     if { ![string match "PB_CMD*" $event_item] && ![string match "VNC_*" $event_item] } \
     {
      set event_name [lindex [split $event_item ,] 0]
      if { [llength [info procs $event_name]] > 0 } {
       rename $event_name ""
      }
     }
    }
   }
   } else {
   Post::GetOthProcList $post_object oth_proc_list
   if [info exists oth_proc_list] {
    foreach cmd $oth_proc_list {
     if { [llength [info procs $cmd]] > 0 } {
      rename $cmd ""
     }
    }
   }
  }
  if 0 {
   foreach var [info globals mom_*] {
    if [info exists $var] {
     if [array exists $var] {
      PB_com_unset_var $var
     }
    }
   }
  }
 }

#=======================================================================
proc PB_pps_CollectTclFileObjs { POST_OBJECT tcl_file_name sync args } {
  upvar $POST_OBJECT post_object
  if { [catch { set sta [PB_pps_ParseTclFile $tcl_file_name event_proc_data $sync] } ] } {
   PB_pps_CleanUpTclFileObjs event_proc_data
   global errorInfo
   return [error "$errorInfo"]
  }
  if { $sta == "TCL_ERROR" } {
   PB_pps_CleanUpTclFileObjs event_proc_data
   return [error ""]
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
     } elseif { ![string match "PB*" $event_item] && \
    ![string match "VNC_*" $event_item] } \
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
  global errorInfo
  if { [catch { set sta [PB_pps_ParseTclFile $tcl_file_name event_proc_data $sync] }] } {
   PB_pps_CleanUpTclFileObjs event_proc_data
   return [error "$errorInfo"]
  }
  if { $sta == "TCL_ERROR" } {
   PB_pps_CleanUpTclFileObjs event_proc_data
   return [error ""]
  }
  set event_name_list [array get event_proc_data]
  set cmd_proc_list ""
  set post_cmd_list [list]
  Post::GetObjList $post_object command cmd_blk_list
  foreach cc $cmd_blk_list {
   command::readvalue $cc attr
   if { [lsearch $post_cmd_list $attr(0)] < 0 } {
    lappend post_cmd_list $attr(0)
   }
  }
  set oth_proc_list ""
  Post::GetOthProcList $post_object oth_proc_list
  Post::GetOthProcData $post_object oth_proc_data
  Post::GetEventProcs $post_object event_procs
  set llen [llength $event_name_list]
  for { set i 0 } { $i < $llen } { incr i 2 } \
  {
   set event_item [lindex $event_name_list $i]
   if { ![string match "MOM*" $event_item] && [string match "*\,name" $event_item] } \
   {
    if { [string match "PB_CMD*" $event_item] } \
    {
     set event_name [lindex [split $event_item ,] 0]

#=======================================================================
set add_proc 1
 if { [string match "PB_CMD_kin_*" $event_name] } \
 {
  if { [info exists gPB(pui_ui_overwrite)]  &&  $gPB(pui_ui_overwrite) } \
  {
  } else \
  {
   if { [lsearch $post_cmd_list $event_name] >= 0 } \
   {
    UI_PB_debug_ForceMsg ">>> Skipping $event_name"

#=======================================================================
set add_proc 0
}
}
}
if { [string match "PB_CMD_vnc____*" $event_name] } {
if { [lsearch $post_cmd_list $event_name] >= 0 } \
{
UI_PB_debug_ForceMsg ">>> Skipping VNC command  $event_name"

#=======================================================================
set add_proc 0
}
}

#=======================================================================
if { $add_proc } \
 {
  UI_PB_debug_ForceMsg ">>> Adding $event_name"
  set cmd_proc_list [ladd $cmd_proc_list end $event_name "no_dup"]
  set cmd_proc_data($event_name,proc) $event_proc_data($event_name,proc)
  set cmd_proc_data($event_name,blk_list) $event_proc_data($event_name,blk_list)
  set cmd_proc_data($event_name,add_list) $event_proc_data($event_name,add_list)
  set cmd_proc_data($event_name,fmt_list) $event_proc_data($event_name,fmt_list)
 }
 } elseif { ![string match "PB_*" $event_item] && \
![string match "VNC_*" $event_item] } \
{
 set event_name [lindex [split $event_item ,] 0]
 if { ![info exists gPB(pui_ui_overwrite)] } {
  set gPB(pui_ui_overwrite) 1
 }
 if { [info exists gPB(pui_ui_overwrite)]  &&  $gPB(pui_ui_overwrite) } {
  set oth_proc_list [ladd $oth_proc_list end $event_name "no_dup"]
  set oth_proc_data($event_name,comment) $event_proc_data($event_name,comment)
  set oth_proc_data($event_name,args)    $event_proc_data($event_name,args)
  set oth_proc_data($event_name,proc)    $event_proc_data($event_name,proc)
  } else {
  if { [lsearch $oth_proc_list $event_name] < 0  && \
   [string compare $event_name "AUTO_CLAMP"] && \
   [string compare $event_name "AUTO_CLAMP_1"] && \
   [string compare $event_name "AUTO_CLAMP_2"] } {
   lappend oth_proc_list $event_name
   set oth_proc_data($event_name,comment) $event_proc_data($event_name,comment)
   set oth_proc_data($event_name,args)    $event_proc_data($event_name,args)
   set oth_proc_data($event_name,proc)    $event_proc_data($event_name,proc)
  }
 }
}
}
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
if { [info exists Post::($post_object,mom_vnc_desc_list)] } {
array set vnc_desc_arr $Post::($post_object,mom_vnc_desc_list)
if { [info exists vnc_desc_arr($cmd_blk,desc)] } {
 set cmd_obj_attr(5) $vnc_desc_arr($cmd_blk,desc)
}
unset vnc_desc_arr
}
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
   set mom_var_list [info vars "mom_sys_pb_link_var_mode"]
   if [llength $mom_var_list] {
    set obj_attr(link_var) $mom_sys_pb_link_var_mode
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
   set mom_sim_list [info vars "mom_sim*"]
   array set mom_sim_arr $Post::($post_object,mom_sim_var_list)
   foreach v $mom_sim_list {
    set var [format %s%s "\$" $v]
    if [info exists mom_sim_arr($var)] {
     set val [eval format %s $var]
     set mom_sim_arr($var) $val
    }
   }
   set Post::($post_object,mom_sim_var_list)     [array get mom_sim_arr]
   set Post::($post_object,def_mom_sim_var_list) [array get mom_sim_arr]
   set mom_sys_list [info vars "mom_sys*"]
   array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
   foreach v $mom_sys_list {
    if [array exists $v] {
     set lv [array get $v]
     set ll [llength $lv]
     for {set i 0} {$i < $ll} {incr i 2} {
      set var [format %s%s%s "\$" $v "([lindex $lv $i])"]
      if [info exists mom_sys_arr($var)] {
       set val [eval format %s $var]
       set mom_sys_arr($var) $val
      }
     }
     } else {
     set var [format %s%s "\$" $v]
     if [info exists mom_sys_arr($var)] {
      set val [eval format %s $var]
      set mom_sys_arr($var) $val
     }
    }
   }
   set Post::($post_object,mom_sys_var_list)     [array get mom_sys_arr]
   set Post::($post_object,def_mom_sys_var_list) [array get mom_sys_arr]
  } ;# uplevel 1
 }

#=======================================================================
proc PB_pps_CreateCommand { CMD_OBJ_ATTR CMD_OBJ } {
  upvar $CMD_OBJ_ATTR cmd_obj_attr
  upvar $CMD_OBJ cmd_obj
  global post_object
  Post::GetObjList $post_object command cmd_blk_list
  PB_com_unset_var cmd_obj
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
proc _pps_KeepUserStyleCommand { LINE ORG_PROC_START ORG_PROC_END PROC_NAME_APPEAR\
  LEFT_BRACE_COUNT RIGHT_BRACE_COUNT ORG_PROC_BODY\
  ORG_PROC_BODY_COM COMBINE_NEXT_LINE KEEP_NXT_LINE_LEFT_BLANK\
  NEED_VALIDATE EVENT_NAME_SAVED EVENT_PROC_DATA FRM_IMPORT_FUNC } {
  global post_object
  upvar $LINE                     line
  upvar $ORG_PROC_START           org_proc_start
  upvar $ORG_PROC_END             org_proc_end
  upvar $PROC_NAME_APPEAR         proc_name_appear
  upvar $LEFT_BRACE_COUNT         left_brace_count
  upvar $RIGHT_BRACE_COUNT        right_brace_count
  upvar $ORG_PROC_BODY            org_proc_body
  upvar $ORG_PROC_BODY_COM        org_proc_body_com
  upvar $COMBINE_NEXT_LINE        combine_next_line
  upvar $KEEP_NXT_LINE_LEFT_BLANK keep_nxt_line_left_blank
  upvar $NEED_VALIDATE            need_validate
  upvar $EVENT_NAME_SAVED         event_name_saved
  upvar $EVENT_PROC_DATA          event_proc_data
  upvar $FRM_IMPORT_FUNC          frm_import_func
  if { [string match "\}*" [string trim $line]] == 1 } {
  if { $left_brace_count == $right_brace_count } {
   set org_proc_start 0
   set org_proc_end   1
   if { [string match "PB_*"  $event_name_saved] } {
    set spe_ind 0
    set remove_blank 0
    while 1 {
     if { $spe_ind >= [llength $org_proc_body_com] } {
      break
     }
     if { ![string compare "" [string trim [lindex $org_proc_body_com $spe_ind]]] } {
      incr spe_ind
      continue
     }
     if { [string match "\#========*" [string trimleft [lindex $org_proc_body_com $spe_ind]]] } {
      incr spe_ind
      set remove_blank 1
      break
     }
     break
    }
    for { set tmp_ind 0 } { $tmp_ind < $spe_ind } { incr tmp_ind } {
     set org_proc_body_com [lreplace $org_proc_body_com 0 0]
    }
    if { !$remove_blank } {
     set org_proc_body_com [lreplace $org_proc_body_com 0 0 [string trimleft [lindex $org_proc_body_com 0]]]
    }
    set spe_ind 0
    set remove_blank 0
    while 1 {
     if { $spe_ind >= [llength $org_proc_body] } {
      break
     }
     if { ![string compare "" [string trim [lindex $org_proc_body $spe_ind]]] } {
      incr spe_ind
      continue
     }
     if { [string match "\#========*" [string trimleft [lindex $org_proc_body $spe_ind]]] } {
      incr spe_ind
      set remove_blank 1
      break
     }
     break
    }
    if { $remove_blank } {
     for { set tmp_ind 0 } { $tmp_ind < $spe_ind } { incr tmp_ind } {
      set org_proc_body [lreplace $org_proc_body 0 0]
     }
    }
    } else {
    set spe_ind 0
    while 1 {
     if { $spe_ind >= [llength $org_proc_body_com] } {
      break
     }
     if { ![string compare "" [string trim [lindex $org_proc_body_com $spe_ind]]] } {
      incr spe_ind
      continue
     }
     break
    }
    for { set tmp_ind 0 } { $tmp_ind < $spe_ind } { incr tmp_ind } {
     set org_proc_body_com [lreplace $org_proc_body_com 0 0]
    }
    set org_proc_body_com [lreplace $org_proc_body_com 0 0 [string trimleft [lindex $org_proc_body_com 0]]]
   }
   if { ![string compare [join $event_proc_data($event_name_saved,proc) ""]\
    [string trimright [join $org_proc_body_com ""]]] } {
    set event_proc_data($event_name_saved,proc) $org_proc_body
    if { [string match "PB_CMD*" "$event_name_saved"] } {
     foreach cmd_item [array names command:: "*,name"] {
      if { ![string compare $command::($cmd_item) "$event_name_saved"] } {
       set cmd_object [lindex [split $cmd_item ","] 0]
       break
      }
     }
     if { [info exists cmd_object] && $cmd_object > 0 && \
     ![string compare "$org_proc_body" $command::($cmd_object,proc)]} \
     {
      if { !$frm_import_func } {
       set need_validate 0
       foreach item [array names event_proc_data "$event_name_saved*"] {
        PB_com_unset_var event_proc_data($item)
       }
       } else {
       Post::GetObjList $post_object command post_cmd_list
       if { [lsearch $post_cmd_list $cmd_object] == -1 } {
        set need_validate 1
        } else {
        set need_validate 0
        foreach item [array names event_proc_data "$event_name_saved*"] {
         PB_com_unset_var event_proc_data($item)
        }
       }
      }
     }
     } else {
     if { $frm_import_func } {
      set post_oth_proc_list [list]
      Post::GetOthProcList $post_object post_oth_proc_list
      Post::GetOthProcData $post_object post_oth_proc_data
      if { [lsearch $post_oth_proc_list $event_name_saved] > -1 &&\
       ![string compare "$org_proc_body" $post_oth_proc_data($event_name_saved,proc)] } {
       foreach item [array names event_proc_data "$event_name_saved*"] {
        PB_com_unset_var event_proc_data($item)
       }
      }
     }
    }
    } else {
    foreach item [array names event_proc_data "$event_name_saved,*"] {
     PB_com_unset_var event_proc_data($item)
    }
   }
   } else {
   set org_proc_body_line_temp [string trimright $line]
   UI_PB_com_RemoveTab "$org_proc_body_line_temp" org_proc_body_line
   lappend org_proc_body $org_proc_body_line
   set org_line [string trimright $line]
   regsub -all {\\\\} $org_line {} org_line
   set org_length [string length $org_line]
   if { ![string compare "\\" [string index $org_line [expr $org_length - 1 ]]] } {
    if { $combine_next_line == 0 } {
     if { [regexp {[.]*\\[ ]+$} $line] } {
      append this_line $line
      } else {
      set this_line [string trimright $line]
      set this_line [string range $this_line 0 [expr [string length $this_line] - 2]]
      append this_line " "
     }
     lappend org_proc_body_com $this_line
     } elseif { $combine_next_line == 1 } {
     set temp_last_line [lindex $org_proc_body_com end]
     if { $keep_nxt_line_left_blank } {
      if { [regexp {[.]*\\[ ]+$} $line] } {
       set this_line $line
       } else {
       set this_line [string trimright $line]
       set this_line [string range $this_line 0 [expr [string length $this_line] - 2]]
       append this_line " "
      }
      } else {
      if { [regexp {[.]*\\[ ]+$} $line] } {
       set this_line [string trimleft $line]
       } else {
       set this_line [string trim $line]
       set this_line [string range $this_line 0 [expr [string length $this_line] - 2]]
       append this_line " "
      }
     }
     append temp_last_line $this_line
     set org_proc_body_com [lreplace $org_proc_body_com end end $temp_last_line]
    }
    if { [regexp {[.]*\\[ ]+$} $line] } {
     set keep_nxt_line_left_blank 1
     } else {
     set keep_nxt_line_left_blank 0
    }
    set combine_next_line 1
    } else {
    if { $combine_next_line == 0 } {
     lappend org_proc_body_com $line
     } elseif { $combine_next_line == 1 } {
     set temp_last_line [lindex $org_proc_body_com end]
     if { $keep_nxt_line_left_blank } {
      set this_line $line
      } else {
      set this_line [string trimleft $line]
     }
     append temp_last_line $this_line
     set org_proc_body_com [lreplace $org_proc_body_com end end $temp_last_line]
    }
    set combine_next_line 0
   }
   set body_line [string trim $line]
   if { ![string match "\#*" $body_line] && \
   [string compare "" $body_line] } \
   {
    regsub -all {\\\\} $body_line {} body_line
    regsub -all {\\\{} $body_line {} body_line
     regsub -all {\\\}} $body_line {} body_line
     set left_brace_count  [expr $left_brace_count + [llength [split $body_line \{]] - 1]
     set right_brace_count [expr $right_brace_count + [llength [split $body_line \}]] - 1]
    }
   }
   } else {
   set org_proc_body_line_temp [string trimright $line]
   UI_PB_com_RemoveTab "$org_proc_body_line_temp" org_proc_body_line
   lappend org_proc_body $org_proc_body_line
   set org_line [string trimright $line]
   regsub -all {\\\\} $org_line {} org_line
   set org_length [string length $org_line]
   if { ![string compare "\\" [string index $org_line [expr $org_length - 1 ]]] } {
    if { $combine_next_line == 0 } {
     if { [regexp {[.]*\\[ ]+$} $line] } {
      set this_line $line
      } else {
      set this_line [string trimright $line]
      set this_line [string range $this_line 0 [expr [string length $this_line] - 2]]
      append this_line " "
     }
     lappend org_proc_body_com $this_line
     } elseif { $combine_next_line == 1 } {
     set temp_last_line [lindex $org_proc_body_com end]
     if { $keep_nxt_line_left_blank } {
      if { [regexp {[.]*\\[ ]+$} $line] } {
       set this_line $line
       } else {
       set this_line [string trimright $line]
       set this_line [string range $this_line 0 [expr [string length $this_line] - 2]]
       append this_line " "
      }
      } else {
      if { [regexp {[.]*\\[ ]+$} $line] } {
       set this_line [string trimleft $line]
       } else {
       set this_line [string trim $line]
       set this_line [string range $this_line 0 [expr [string length $this_line] - 2]]
       append this_line " "
      }
     }
     append temp_last_line $this_line
     set org_proc_body_com [lreplace $org_proc_body_com end end $temp_last_line]
    }
    if { [regexp {[.]*\\[ ]+$} $line] } {
     set keep_nxt_line_left_blank 1
     } else {
     set keep_nxt_line_left_blank 0
    }
    set combine_next_line 1
    } else {
    if { $combine_next_line == 0 } {
     lappend org_proc_body_com $line
     } elseif { $combine_next_line == 1 } {
     set temp_last_line [lindex $org_proc_body_com end]
     if { $keep_nxt_line_left_blank } {
      set this_line $line
      } else {
      set this_line [string trimleft $line]
     }
     append temp_last_line $this_line
     set org_proc_body_com [lreplace $org_proc_body_com end end $temp_last_line]
    }
    set combine_next_line 0
   }
   set body_line [string trim $line]
   if { ![string match "\#*" $body_line] && \
   [string compare "" $body_line] } \
   {
    regsub -all {\\\\} $body_line {} body_line
    regsub -all {\\\{} $body_line {} body_line
     regsub -all {\\\}} $body_line {} body_line
     set left_brace_count  [expr $left_brace_count + [llength [split $body_line \{]] - 1]
     set right_brace_count [expr $right_brace_count + [llength [split $body_line \}]] - 1]
    }
   } ;# not reach the end of proc
  }

#=======================================================================
proc PB_pps_ParseTclFile { tcl_file_name EVENT_PROC_DATA sync } {
  global gPB
  upvar $EVENT_PROC_DATA event_proc_data
  set fake_source 1
  set source_cmd source
  if $fake_source {
   set source_cmd TCL_source
   if { [llength [info commands $source_cmd]] == 0 } {
    rename source $source_cmd
   }

#=======================================================================
proc source { tcl_file } {
  global gPB
  set source_it 0  ;#<02-09-11 gsl> was 1.
  if [string match "*ugpost_base.tcl*" "$tcl_file"] {
   if { ![info exists gPB(ugpost_base_sourced)] } {
    set source_it 1
    } else {
    set source_it 0
   }
  }
  if { $source_it } {
   TCL_source "$tcl_file"
   if { [string match "*ugpost_base.tcl*" "$tcl_file"] && ![info exists gPB(ugpost_base_sourced)] } {
    set gPB(ugpost_base_sourced) 1
   }
  }
 }
}
if {[string match "*_vnc.tcl" $tcl_file_name]} {
 set file_type "vnc"
 } else {
 set file_type ""
}
global errorInfo
set parse_tcl 1
set tcl_encrypted "[file rootname $tcl_file_name]_tcl.txt"
if [file exists $tcl_encrypted] {
 if {$::disable_license == 0} {
  set is_encrypted_file 1
  } else {
  set gPB(err_msg) "Licensed Post is only supported on Windows platforms";
  return [error "" ""]
 }
 } else {
 set is_encrypted_file 0
}
while { $parse_tcl } {
 if { $is_encrypted_file == 1 } {
  if [llength [info commands UI_PB_decrypt_post] ] {
   set source_str  "set source_code_list \[UI_PB_decrypt_post {$tcl_encrypted} TRUE NO NO\]"
   } else {
   set source_str [list $source_cmd $tcl_file_name] ;#<02-09-11 gsl> TCL_source was source.
  }
  } else {
  set source_str [list $source_cmd $tcl_file_name]  ;#<02-09-11 gsl> TCL_source was source.
 }
 if [ catch $source_str res ] {
  UI_PB_debug_ForceMsg "$res"
  if { $errorInfo != "" } {
   set idx [string last "invoked from within" $errorInfo]
   if { $idx > 0 } {
    set errorInfo [string range $errorInfo 0 [expr $idx - 1]]
   }
   set gPB(err_msg) "$errorInfo\n\n\
   You must correct this error in $tcl_file_name!"
   return [error "" "$errorInfo"]
  }
  } else {
  set parse_tcl 0
 }
}
if { $is_encrypted_file == 1 } {
 global LicInfo
 if { $source_code_list == "WRONG_FILENAME" } {
  set gPB(err_msg) $gPB(msg,wrong_filename)
  PB_com_unset_var LicInfo
  return [error "" ""]
 }
}
if $fake_source {
 rename source ""
 rename $source_cmd source
}
if { [info exists mom_kin_machine_type] } {
 set gPB(mom_kin_machine_type) $mom_kin_machine_type
 } else {
 set gPB(mom_kin_machine_type) ""
}
if 0 { ;# This scheme doesn't work. See changes below -
 global post_object
 set cmd_obj_list   ""
 set cmd_name_list  ""
 Post::GetObjList  $post_object command cmd_obj_list
 PB_blk_GetCmdNamelist cmd_obj_list cmd_name_list
 set gPB(custom_command_list) $cmd_name_list
}
if $sync {
 PB_pps_UpdatePostAttr
}
set proc_start 0
set prev_proc_body ""
if 0 {
 set var_list [info vars "*spindle_axis*"]
} ;#<10-28-05 gsl>
if [info exists mom_kin_spindle_axis_backup] {
 PB_com_unset_var mom_kin_spindle_axis_backup
}
if [info exists mom_sys_spindle_axis_backup] {
 PB_com_unset_var mom_sys_spindle_axis_backup
}
if [array exists mom_kin_spindle_axis] {
 set mom_kin_spindle_axis_backup [array get mom_kin_spindle_axis]
}
if [array exists mom_sys_spindle_axis] {
 set mom_sys_spindle_axis_backup [array get mom_sys_spindle_axis]
}
if { $is_encrypted_file == 0 } {
 set source_code_list [list]
 set tcl_fid [open "$tcl_file_name" r]
 while { [gets $tcl_fid line] >= 0 } {
  lappend source_code_list $line
 }
 close $tcl_fid
}
switch $gPB(new_machine_type) \
{
 "Mill" {
  switch $gPB(mach_axis_remove_proc) \
  {
   "3" {
    set unwanted_proc_list [list "PB_CMD_kin_init_mill_turn" \
    "PB_CMD_kin_init_mill_xzc" \
    "PB_CMD_kin_mill_turn_initialize" \
    "PB_CMD_kin_mill_xzc_init" \
    "PB_CMD_kin_init_rotary" \
    "PB_CMD_kin_linearize_motion" \
    "PB_CMD_linearize_motion" \
    "PB_CMD_reverse_rotation_vector"]
   }
   "3MT" {
    set unwanted_proc_list [list "PB_CMD_kin_init_rotary" \
    "PB_CMD_linearize_motion"]
   }
   "4H" -
   "4T" -
   "5TT" -
   "5HH" -
   "5HT" {
    set unwanted_proc_list [list "PB_CMD_kin_init_mill_turn" \
    "PB_CMD_kin_init_mill_xzc" \
    "PB_CMD_kin_mill_turn_initialize" \
    "PB_CMD_kin_mill_xzc_init" \
    "PB_CMD_kin_linearize_motion" \
    "PB_CMD_linearize_motion"]
   }
  }
 }
 "Lathe" {
  set unwanted_proc_list [list "PB_CMD_kin_init_mill_turn" \
  "PB_CMD_kin_init_mill_xzc" \
  "PB_CMD_kin_mill_turn_initialize" \
  "PB_CMD_kin_mill_xzc_init" \
  "PB_CMD_kin_init_rotary" \
  "PB_CMD_kin_linearize_motion" \
  "PB_CMD_linearize_motion" \
  "PB_CMD_reverse_rotation_vector"]
 }
 "Wedm" {
  switch $gPB(mach_axis_remove_proc) \
  {
   "2" {
    set unwanted_proc_list [list "PB_CMD_kin_init_mill_turn" \
    "PB_CMD_kin_init_mill_xzc" \
    "PB_CMD_kin_mill_turn_initialize" \
    "PB_CMD_kin_mill_xzc_init" \
    "PB_CMD_kin_init_rotary" \
    "PB_CMD_kin_linearize_motion" \
    "PB_CMD_linearize_motion" \
    "PB_CMD_reverse_rotation_vector"]
   }
   "4" {
    set unwanted_proc_list [list "PB_CMD_kin_init_mill_turn" \
    "PB_CMD_kin_init_mill_xzc" \
    "PB_CMD_kin_mill_turn_initialize" \
    "PB_CMD_kin_mill_xzc_init" \
    "PB_CMD_kin_linearize_motion" \
    "PB_CMD_linearize_motion" \
    "PB_CMD_reverse_rotation_vector"]
   }
  }
 }
}
set org_proc_start            0  ; # indicate the start of proc
set org_proc_end              0  ; # indicate the end of proc

#=======================================================================
set proc_name_appear          0  ; # indicate the line "proc *" appear
 set left_brace_count          0  ; # count of left brace
 set right_brace_count         0  ; # count of right brace

#=======================================================================
set org_proc_body             "" ; # proc body that has the same style as in tcl file
 set org_proc_body_com         "" ; # remove backslashes to get the style of "info body *"
 set combine_next_line         0  ; # decide whether combine this line to previous one.
 set keep_nxt_line_left_blank  0  ; # decide whether the left blanks should be kept.
 set need_validate             1  ; # decide whether the CMD command should be validated when it appears again.
 set same_line_flag 0             ;
 if { ![string compare "_cmd_ViewTclProcs" [lindex [info level -1] 0]] } {
  set frm_import_func 1
  } else {
  set frm_import_func 0
 }
 foreach line $source_code_list \
 {
  set temp_line [string trim $line]
  if [string match "#*" $temp_line] \
  {
   lappend comment_lines $line
  }
  if { $org_proc_start } {
   _pps_KeepUserStyleCommand line org_proc_start org_proc_end proc_name_appear left_brace_count right_brace_count org_proc_body org_proc_body_com combine_next_line keep_nxt_line_left_blank need_validate event_name_saved event_proc_data frm_import_func
  } ;# org_proc_start
  set temp_line $line
  PB_com_RemoveBlanks temp_line
  if { $temp_line == "" } \
  {
   PB_com_unset_var comment_lines
  }

#=======================================================================
if { [string match "proc *" $temp_line] == 1 } \
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
   if { [llength [info commands "$event_name"]] == 0 } {

#=======================================================================
proc $event_name {args} { return 1 } ;#<02-23-05 gsl> 1 was 0.
}
} else {
if { [llength [info commands "$event_name"]] } {
 set proc_start 1
 if { ![string match "MOM_*" $event_name] && \
  ![string match "VNC_*" $event_name] && \
  (![string match "PB_*"  $event_name] || [string match "PB_CMD_*"  $event_name]) && \
 (![info exists unwanted_proc_list] || [lsearch $unwanted_proc_list $event_name] == -1) } \
 {
  set proc_name_appear 1
  set event_name_saved $event_name
  if { [string match "PB_CMD_*"  $event_name] && [llength [split $line "\{"]] == [llength [split $line "\}"]] } {
   set same_line_flag 1
   set proc_name_appear 0
   set org_proc_end 1
   set need_validate 1
  }
 }
 if { ![string match "PB_*"  $event_name]  && \
  ![string match "MOM_*" $event_name]  && \
 ![string match "VNC_*" $event_name] } \
 {
  if [info exists comment_lines] \
  {
   set event_proc_data($event_name,comment) $comment_lines
  } else \
  {
   set event_proc_data($event_name,comment) ""
  }
 }
 PB_com_unset_var comment_lines
 set event_proc_data($event_name,name) $event_name
 set real_args_list [list]
 if { ![catch { set args_list [info args $event_name] }] } {
  foreach one $args_list {
   set var [list]
   set with_default [info default $event_name $one var]
   if { $with_default == 0 } {
    lappend real_args_list $one
    } else {
    lappend real_args_list "\{$one $var\}"
   }
  }
 }
 set event_proc_data($event_name,args) $real_args_list
 set proc_data ""
 set proc_body ""
 catch { set proc_body [concat [info body $event_name]] }
 set proc_body [split $proc_body "\n"]
 if { [string match "PB_*"  $event_name]  || \
  [string match "MOM_*" $event_name]  || \
 [string match "VNC_*" $event_name]} \
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
} ;# if event_name exists
} ;# !proc_is_dummy
} else \
{
set proc_start 0
}
if { $proc_start  &&  ![string match "PB_*"  $event_name]  &&\
![string match "MOM_*" $event_name]  &&\
![string match "VNC_*" $event_name] } {
rename $event_name ""

#=======================================================================
proc $event_name {args} { return 1 }
}
global gPB
if { [string match "*_vnc.tcl" $tcl_file_name] &&\
 ![string match "*vnc_common_*" $tcl_file_name] } {
 if { ($proc_start && [string match "VNC_load_post_definitions*" $event_name]) ||\
  ($proc_start && [string match "VNC_set_nc_definitions*" $event_name]) } {
  if { [catch { PB_proc_ValidateCustCmd $event_name $proc_body res }] } {
   UI_PB_debug_ForceMsg "$event_name \n\n[join $proc_body \n] \n\n$errorInfo"
   PB_com_unset_var comment_lines
  }
 }
}
if { $proc_start } {

#=======================================================================
set is_unwanted_proc 0
 if { [info exists unwanted_proc_list] && [llength $unwanted_proc_list] } {
  foreach one $unwanted_proc_list {
   if { ![string compare $one $event_name] } {

#=======================================================================
set is_unwanted_proc 1
 break
}
}
unset one

#=======================================================================
if { $is_unwanted_proc == 1 } {
  foreach item [array names event_proc_data "$event_name,*"] {
   PB_com_unset_var event_proc_data($item)
  }
  set event_name ""
  unset is_unwanted_proc
 }
 if { [info exists gPB(PB_CMD_FROM_PBLIB)] && [lsearch $gPB(PB_CMD_FROM_PBLIB) "$event_name"] != -1 } {
  foreach item [array names event_proc_data "$event_name,*"] {
   PB_com_unset_var event_proc_data($item)
  }
  set event_name ""
  set proc_name_appear 0
  set event_name_saved ""
 }
}
}
if { $org_proc_end } {
set event_name $event_name_saved
}
if { $org_proc_end && [string match "PB_CMD*" $event_name] && $need_validate } \
{
global gPB
UI_PB_debug_DisplayMsg "command name = $event_name" no_debug
set validate_on_open 1
if {[string match "*vnc_common*" $tcl_file_name]} {
 set validate_on_open 0
}
if { $validate_on_open == 1 } {
 if [catch { PB_proc_ValidateCustCmd $event_name $proc_body res }] {
  UI_PB_debug_ForceMsg "$event_name \n\n[join $proc_body \n] \n\n$errorInfo"
  PB_com_unset_var comment_lines
 }
 } else {
 set gPB(CMD_BLK_LIST) ""
 set gPB(CMD_ADD_LIST) ""
 set gPB(CMD_FMT_LIST) ""
}
set keep_cmd 1
set Postbuilder_Version $gPB(Postbuilder_Version)
if [info exists gPB(Old_PUI_Version)] {
 set gPB(Postbuilder_Version) $gPB(Old_PUI_Version)
}
if { [PB_is_v 6.0.2] == 0 } {
 if [info exists mom_sys_arr(VNC_Mode)] {
  if {[string match "Standalone" $mom_sys_arr(VNC_Mode)]} {
   if {[string match "PB_CMD_vnc__set_nc_definitions" $event_name] || \
    [string match "PB_CMD_vnc__sim_other_devices" $event_name]} {
    set keep_cmd 0
    unset event_proc_data($event_name,name)
    unset event_proc_data($event_name,args)
    PB_com_unset_var event_proc_data($event_name,comment)
   }
  }
 }
}
if { [PB_is_v 3.4] == 0 } {
 if { [string match "PB_CMD_init_new_iks" $event_name] ||\
  [string match "PB_CMD_set_new_iks" $event_name] } {
  set proc_data "\"# Avoid execution of this command\"\n\
  return\n\
  \" \"\n\
  $proc_data"
  set event_proc_data($event_name,proc) $proc_data
 }
 if [string match "*ugpadvkins.*" $proc_data] {
  set _body [list]
  lappend _body "# Disable new IKS for dual-head mill"
  lappend _body " "
  lappend _body "global mom_kin_iks_usage"
  lappend _body "global mom_kin_machine_type"
  lappend _body "global mom_sys_ugpadvkins_used"
  lappend _body " "
  lappend _body "if \{ \$mom_sys_ugpadvkins_used == 0 \} \{"
   lappend _body "   if \[string match \"5_axis_dual_head\" \$mom_kin_machine_type\] \{"
    lappend _body "      if \{ \$mom_kin_iks_usage == 1 \} \{"
     lappend _body "         PB_CMD_revert_dual_head_kin_vars"
     lappend _body "         set mom_kin_iks_usage 0"
    lappend _body "      \}"
   lappend _body "   \}"
   lappend _body "   set mom_sys_ugpadvkins_used 1"
  lappend _body "\}"
  lappend _body " "
  lappend _body " "
  set proc_data $_body\n$proc_data
  set event_proc_data($event_name,proc) $proc_data
 }
}
if { [PB_is_v 3] == 0 } {
 switch $event_name {
  "PB_CMD_machine_mode" -
  "PB_CMD_init_mill_turn" -
  "PB_CMD_kin_mill_turn_initialize" -
  "PB_CMD_init_mill_xzc" -
  "PB_CMD_kin_mill_xzc_init" -
  "PB_CMD_init_multiple_post" -
  "PB_CMD_multiple_post_initialize" \
  {
   set keep_cmd 0
   if { [info exists gPB(KEEP_OLD_PB_CMD)]  && \
    $gPB(KEEP_OLD_PB_CMD) == 1 } {
    set keep_cmd 1
    } else {
    unset event_proc_data($event_name,name)
    unset event_proc_data($event_name,args)
    PB_com_unset_var event_proc_data($event_name,comment)
   }
  }
 }
}
set gPB(Postbuilder_Version) $Postbuilder_Version
if { ![info exists gPB(CMD_BLK_LIST)] } { set gPB(CMD_BLK_LIST) "" }
if { ![info exists gPB(CMD_ADD_LIST)] } { set gPB(CMD_ADD_LIST) "" }
if { ![info exists gPB(CMD_FMT_LIST)] } { set gPB(CMD_FMT_LIST) "" }
if $keep_cmd {
 set event_proc_data($event_name,blk_list) $gPB(CMD_BLK_LIST)
 set event_proc_data($event_name,add_list) $gPB(CMD_ADD_LIST)
 set event_proc_data($event_name,fmt_list) $gPB(CMD_FMT_LIST)
}
}
if { ($org_proc_end && [string match "\}*" [string trim $line]] == 1) || $same_line_flag } \
{
PB_com_unset_var comment_lines
set org_proc_end              0
set left_brace_count          0
set right_brace_count         0
set org_proc_body             ""
set org_proc_body_com         ""
set combine_next_line         0
set keep_nxt_line_left_blank  0
set need_validate             1
set event_name_saved          ""
set same_line_flag 0
}
if { $proc_name_appear } {
set org_proc_start    1
set proc_name_appear  0
}
}
PB_com_unset_var gPB(PB_CMD_FROM_PBLIB)
if [info exists mom_kin_spindle_axis_backup] {
if [info exists mom_kin_spindle_axis] {
PB_com_unset_var mom_kin_spindle_axis
}
array set mom_kin_spindle_axis $mom_kin_spindle_axis_backup
}
if [info exists mom_sys_spindle_axis_backup] {
if [info exists mom_sys_spindle_axis] {
PB_com_unset_var mom_sys_spindle_axis
}
array set mom_sys_spindle_axis $mom_sys_spindle_axis_backup
}
if 0 {
global post_object
array set mom_sys_var $Post::($post_object,mom_sys_var_list)
array set mom_kin_var $Post::($post_object,mom_kin_var_list)
foreach var $var_list {
if [array exists $var] {
if [string match "mom_kin*" $var] {
 foreach i { 0 1 2 } {
  set mom_kin_var(\$mom_kin_spindle_axis($i)) $mom_kin_spindle_axis($i)
 }
 } elseif [string match "mom_sys*" $var] {
 foreach i { 0 1 2 } {
  set mom_sys_var(\$mom_sys_spindle_axis($i)) $mom_sys_spindle_axis($i)
 }
}
}
}
set Post::($post_object,mom_sys_var_list)     [array get mom_sys_var]
set Post::($post_object,mom_kin_var_list)     [array get mom_kin_var]
} ;#<10-28-05 gsl>
}

#=======================================================================
proc __RENAME { args } {}

#=======================================================================
proc __RETURN { args } {}

#=======================================================================
proc __PROC { args } {}

#=======================================================================
proc __EvalProc { proc_data RES } {
  upvar $RES __PB_res
  if [catch { eval [join $proc_data \n] } __PB_res] {
   return 1
   } else {
   return 0
  }
 }

#=======================================================================
proc PB_proc_SnapShotCmdObjs { } {
  return
  global gPB
  set gPB(cmd_globals) ""
  set gPB(cmd_procs)   ""
  foreach g [info globals] {
   global $g
   lappend gPB(cmd_globals) $g
  }
  set gPB(cmd_procs) [info procs]
 }

#=======================================================================
proc PB_proc_CleanUpCmdObjs { } {
  return
  global gPB
  if [info exists gPB(cmd_globals)] {
   foreach g [info globals] {
    if { [lsearch $gPB(cmd_globals) $g] < 0 } {
     global $g
     unset $g
    }
   }
   unset gPB(cmd_globals)
  }
  if [info exists gPB(cmd_procs)] {
   foreach p [info procs] {
    if { [lsearch $gPB(cmd_procs) "$p"] < 0 } {
     rename $p ""
    }
   }
   unset gPB(cmd_procs)
  }
 }

#=======================================================================
proc __find_keyword { keyword line } {
  set pat1 "\*\[ \{\]$keyword\[ \}\]\*"
 set pat2 "$keyword\[ \}\]\*"
 set pat3 "\*\[ \{\]$keyword"
  set pat4 "$keyword"
  if { [string match $pat1 $line] || \
   [string match $pat2 $line] || \
   [string match $pat3 $line] || \
  [string match $pat4 $line]  } \
  {
   return 1
   } else {
   return 0
  }
 }

#=======================================================================
proc PB_proc_ValidateCustCmd { __PB_cmd_name __PB_proc_body __PB_RES args } {
  upvar  $__PB_RES __PB_res
  global gPB
  global post_object
  global errorInfo
  global tcl_version
  if { ![info exists gPB(cmd_obj_cleanup)] || $gPB(cmd_obj_cleanup) == 1 } {
   PB_proc_SnapShotCmdObjs
  }
  global mom_sys_arr
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
  set __PB_tmp_proc_data ""
  set uplevel_global_scope 0
  foreach e $__PB_proc_body {
   set ee [string trim $e]
   if [string length $ee] {
    if { ![string match "rename*" $ee] && ![string match "#*" $ee] } {}
    if { ![string match "#*" $ee] } {
     if [string match "*rename *" $ee] {
      if [__find_keyword "rename" $ee] {
       set idx [string first "rename" $ee]
       set head [string range $ee 0 [expr $idx - 1]]
       set idx [string wordend $ee $idx]
       set tail [string range $ee $idx end]
       set ee "${head}__RENAME${tail}"
      }
     }
     if [string match "*return*" $ee] {
      if [__find_keyword "return" $ee] {
       set idx [string first "return" $ee]
       set head [string range $ee 0 [expr $idx - 1]]
       set idx [expr $idx + 6]
       set tail [string range $ee $idx end]
       set ee "${head}__RETURN${tail}"
      }
     }

#=======================================================================
if [string match "*proc *" $ee] {
  if [__find_keyword "proc" $ee] {

#=======================================================================
set idx [string first "proc " $ee]
 set head [string range $ee 0 [expr $idx - 1]]
 set idx [string wordend $ee $idx]
 set tail [string range $ee $idx end]
 set ee "${head}__PROC${tail}"
}
}
if 0 {
if [string match "*if *" $ee] {
 set idx [string first "if " $ee]
 set head [string range $ee 0 [expr $idx - 1]]
 set idx [string last " \{" $ee]
  set tail [string range $ee [expr $idx + 1] end]
  set ee "${head}if 1 ${tail}"
 }
}
if [string match "*uplevel *\#0 *" $ee] {
 set uplevel_global_scope 1
 set uplevel_brace_count 0
 set uplevel_proc_scope 0
 set uplevel_proc_brace_count 0
}
if $uplevel_global_scope {
 set s [join [list $ee]]
 regsub -all {\\\\\{} $s {}  s
  regsub -all {\\\\\}} $s {}  s
  set left_brace_count  [llength [split $s \{]]
  set right_brace_count [llength [split $s \}]]
  if [string match "__PROC *" $s] {
   set uplevel_proc_scope 1
  }
  if { $uplevel_proc_scope == 0 } {
   if [expr $left_brace_count > $right_brace_count] {
    incr uplevel_brace_count
   }
   if [expr $left_brace_count < $right_brace_count] {
    incr uplevel_brace_count -1
    if [expr $uplevel_brace_count == 0] {
     set uplevel_global_scope 0
    }
   }
   } else {
   if [expr $left_brace_count > $right_brace_count] {
    incr uplevel_proc_brace_count
   }
   if [expr $left_brace_count < $right_brace_count] {
    incr uplevel_proc_brace_count -1
    if [expr $uplevel_proc_brace_count == 0] {
     set uplevel_proc_scope 0
    }
   }
  }
 }
 if [string match "*uplevel *" $ee] {
  set head ""
  set idx [string first "uplevel" $ee]
  if { $idx >= 0 } {
   set head [string range $ee 0 [expr $idx - 1]]
  }
 }
 if [string match "*uplevel *\{*" $ee] {
   set tail ""
   set idx [string first "\{" $ee]
    if { $idx >= 0 } {
     set tail [string range $ee [expr $idx + 1] end]
    }
    set ee [string trim [join [list $head "uplevel\ 1\ \{" $tail]]]
     } elseif [string match "*uplevel*\\" $ee] {
     set ee [string trim [join [list $head "uplevel\ 1\ \\"]]]
    }
    lappend __PB_tmp_proc_data $ee
   }
  }
 }
 set gPB(CMD_BLK_LIST) [list]
 set gPB(CMD_ADD_LIST) [list]
 set gPB(CMD_FMT_LIST) [list]
 set gPB(CMD_VAR_LIST) [list]
 if { ![string compare [string trim [join $__PB_tmp_proc_data \n]] ""] } {
  return 1
 }
 foreach v [info locals] {
  if { ![string match "__PB_cmd_name"         $v] && \
   ![string match "__PB_RES"              $v] && \
   ![string match "__PB_res"              $v] && \
   ![string match "__PB_tmp_proc_data"    $v] && \
   ![string match "args"                  $v] && \
   ![string match "gPB"                   $v] && \
   ![string match "uplevel_*"             $v] && \
   ![string match "errorInfo"             $v] } {
   foreach var $v {
    unset $var
   }
  }
 }
 unset v
 unset var
 set PB_val 1
 set __PB_proc_ok  0
 set __PB_loop_idx 0 ;# counter to prevent infinite loop
 if 0 {
  if [catch { eval [join $__PB_tmp_proc_data \n] } __PB_res] {
   if { ![string match "*no such variable*" $__PB_res]} {
    set __PB_proc_ok -1
   }
  }
 }
 if { [info exists gPB(custom_command_eval_iter)] && \
  $gPB(custom_command_eval_iter) > 0 } {
  set __PB_n_iter  $gPB(custom_command_eval_iter)
  } else {
  set __PB_n_iter 20
 }
 set __PB_res_prev ""
 set flag_rename 0
 if { [string match "*$__PB_cmd_name*" $__PB_tmp_proc_data] &&\
  [llength [info commands "TCL_$__PB_cmd_name"]] == 0 } {
  if { [llength [info commands "$__PB_cmd_name"]] > 0 } {
   rename $__PB_cmd_name TCL_$__PB_cmd_name
  }

#=======================================================================
proc $__PB_cmd_name { args } {}
 set flag_rename 1
}
PB_mom_DisguiseTclCmds_1
set Post::($post_object,unk_cmd_list) [list]
while { $__PB_proc_ok == 0 } {
 PB_mom_DisguiseTclCmds_2
 if [catch { eval [join $__PB_tmp_proc_data \n] } __PB_res] {
  set __PB_res_more $errorInfo
  UI_PB_debug_ForceMsg "Command Syntax Error : $__PB_res"
  PB_mom_RestoreTclCmds_2
  if [string match "$__PB_res_prev" $__PB_res] {
   set __PB_proc_ok 1
   continue
  }
  if [string match "*variable*exists*" $__PB_res] {
   set __PB_idx [lsearch $__PB_res "variable"]
   if { $__PB_idx >= 0 } {
    set __PB_var [lindex $__PB_res [expr $__PB_idx + 1]]
    set __PB_var [string trim $__PB_var "\""]
    PB_com_unset_var $__PB_var
   }
   } elseif { [string match "*no such variable*" $__PB_res] || \
   [string match "*no such element*" $__PB_res] } {
   if {[string match "*PB_CMD_vnc*" $__PB_cmd_name]} {
    set __PB_proc_ok 1
    continue
   }
   if { [string match "*PB_CMD_vnc__set_nc_definitions*" $__PB_cmd_name] ||\
    [string match "*PB_CMD_vnc__sim_other_devices*" $__PB_cmd_name] } {
    set __PB_proc_ok 1
    continue
   }
   set __PB_idx [string first ": " $__PB_res]
   if { $__PB_idx >= 0 } {
    set __PB_res1 [string range $__PB_res 0 [expr int($__PB_idx - 1)]]
    set __PB_var  [lindex $__PB_res1 end]
    set __PB_var  [string trim $__PB_var "\""]
    if { $tcl_version >= "8.0" } {
     if { [string match "::*" $__PB_var] } {
      set __PB_var [string trimleft $__PB_var "::"]
     }
    }
    if { [string index $__PB_var [expr [string length $__PB_var] - 1]] == ")" } {
     set __PB_idx [string first "(" $__PB_var]
     set __PB_this_var [string range $__PB_var 0 [expr int($__PB_idx - 1)]]
     } else {
     set __PB_this_var $__PB_var
    }
    if { ![string match "*\$$__PB_this_var*" $__PB_tmp_proc_data]} {
     global $__PB_this_var
     set $__PB_var $PB_val
     } else { ;# Variable used by current proc.
     set __PB_var_is_global 0
     foreach __PB_e $__PB_tmp_proc_data {
      if [string match "*global*$__PB_this_var*" $__PB_e] {
       set __PB_var_is_global 1
       break
      }
     }
     foreach __PB_e $__PB_tmp_proc_data {
      if { [string match "*gets * $__PB_this_var*" $__PB_e] ||\
       [string match "*uplevel *" $__PB_e] } {
       set __PB_var_is_global 1
       global $__PB_this_var
       break
      }
     }
     lappend gPB(CMD_VAR_LIST) $__PB_this_var
     if { [llength $args] && [lindex $args 0] == "exp" } {
      UI_PB_debug_ForceMsg "Unknown var $__PB_this_var in expression ==> Set global $__PB_this_var"
      set __PB_var_is_global 1
      global $__PB_this_var
     }
     if $__PB_var_is_global {
      if [catch { set $__PB_var $PB_val } __PB_res] {
       set __PB_proc_ok -1
       continue
      }
      } else {
      if $gPB(check_cc_syntax_error) {
       set __PB_proc_ok -1
       set __PB_idx [string last "body line" $__PB_res_more]
       if { $__PB_idx >= 0 } {
        set __PB_idx      [string wordend $__PB_res_more $__PB_idx];# body
        set __PB_idx      [expr $__PB_idx + 1];# Skip a space
        set __PB_idx      [string wordend $__PB_res_more $__PB_idx];# line
        set __PB_idx      [expr $__PB_idx + 1]
        set __PB_idx2     [string wordend $__PB_res_more $__PB_idx]
        set __PB_line_num [string range $__PB_res_more $__PB_idx [expr $__PB_idx2 - 1]]
        if { $__PB_line_num > 0 } {
         set __PB_ii 1
         foreach __PB_e $__PB_tmp_proc_data {
          if { $__PB_ii > $__PB_line_num } { break }
          set __PB_e [string trim $__PB_e]
          if { ![string match "" $__PB_e] && \
           ![string match "\#*" $__PB_e] } {
           if 0 {
            if { [string match "*set *$__PB_this_var *" $__PB_e] || \
             [string match "*gets * $__PB_this_var" $__PB_e] || \
             [string match "*gets * $__PB_this_var *" $__PB_e] } {}
           }
           if { [string match "*set *$__PB_this_var *"    $__PB_e] || \
            [string match "*set *$__PB_this_var\(* *" $__PB_e] || \
            [string match "*gets * $__PB_this_var"    $__PB_e] || \
            [string match "*gets * $__PB_this_var *"  $__PB_e] } {
            UI_PB_debug_ForceMsg "Unknown var @ line $__PB_line_num : $__PB_var \
            ==> Found @ line $__PB_ii : $__PB_e \
            ==> Set global $__PB_this_var"
            global $__PB_this_var
            set $__PB_var $PB_val
            set __PB_proc_ok 0
            break
           }
           incr __PB_ii
          }
         }
        }
       }
       continue
       } else {
       set $__PB_var $PB_val
      }
     }
    }
    } else {
    if $gPB(check_cc_syntax_error) {
     set __PB_proc_ok -1
     } else {
     set __PB_proc_ok 1
    }
    continue
   }
   } elseif [string match "*invalid command name*" $__PB_res] {
   UI_PB_debug_ForceMsg "Invalid command \n\n$__PB_res"
   if 0 {
    set __PB_var [lindex $__PB_res end]
    set __PB_var [string trim $__PB_var "\""]
   }
   set __PB_bail 0
   if [catch { set __PB_var [lindex $__PB_res end] }] {
    if $gPB(check_cc_syntax_error) {
     set __PB_proc_ok -1
    }
    set __PB_bail 1
    } else {
    set __PB_var [string trim $__PB_var "\""]
   }
   if { !$__PB_bail } {
    if { [llength $__PB_var] > 1 } {
     if $gPB(check_cc_syntax_error) {
      set __PB_proc_ok -1
     }
     set __PB_bail 1
    }
   }
   if $__PB_bail {
    if { $__PB_proc_ok == 0 } { set __PB_proc_ok 1 }
    continue
   }
   if $gPB(check_cc_unknown_command) {
    if { [lsearch $Post::($post_object,unk_cmd_list) $__PB_var] < 0  && \
     [lsearch $Post::($post_object,ass_cmd_list) $__PB_var] < 0 } {
     lappend Post::($post_object,unk_cmd_list) $__PB_var
    }
   }

#=======================================================================
proc $__PB_var { args } { return 1 }
 lappend __PB_tmp_proc_list $__PB_var
 } else {
 if $gPB(check_cc_syntax_error) {
  set __PB_proc_ok -1
 }
}
} else {
set __PB_proc_ok 1
}
incr __PB_loop_idx
if { $__PB_loop_idx > $__PB_n_iter } { set __PB_proc_ok 1 }
set __PB_res_prev $__PB_res
PB_mom_RestoreTclCmds_2
}
PB_mom_RestoreTclCmds_1
if { $flag_rename } {
rename $__PB_cmd_name ""
if { [llength [info commands "TCL_$__PB_cmd_name"]] > 0 } {
rename TCL_$__PB_cmd_name ""
}
}
if [info exists __PB_tmp_proc_list] {
foreach __PB_p $__PB_tmp_proc_list {
rename $__PB_p ""
}
unset __PB_tmp_proc_list
}
if 0 {
if [llength $uplevel_script] {
if [string match "*global *" $uplevel_script] {
 set __PB_proc_ok -1
 set __PB_res_more "Variables should not be declared as global\
 within a uplevel #0 scope!"
}
}
}
if { $__PB_proc_ok == 1 } {
if { [PB_is_v3] >= 0 } {
if { [string match "PB_CMD_init_multiple_post" $__PB_cmd_name]  || \
 [string match "PB_CMD_multiple_post_initialize" $__PB_cmd_name] } {
 uplevel 1 { ;# mom_sys_postname is defined in a uplevel scope from a PB_CMD.
  global post_object
  if [info exists mom_sys_postname] {
   array set mom_sys_var $Post::($post_object,mom_sys_var_list)
   set mom_sys_var(\$mom_sys_postname_list) [array get mom_sys_postname]
   set Post::($post_object,mom_sys_var_list) [array get mom_sys_var]
   unset mom_sys_postname
  }
 }
}
if { [string match "PB_CMD_init_mill_turn" $__PB_cmd_name]  || \
 [string match "PB_CMD_kin_mill_turn_initialize" $__PB_cmd_name] } {
 if 1 { ;# These vars were not defined in an uplevel scope.
  global post_object
  array set mom_sys_var $Post::($post_object,mom_sys_var_list)
  PB_com_unset_var post_links
  global mom_sys_mill_turn_type
  if [info exists mom_sys_mill_turn_type] {
   if [string match "SIMPLE_MILL_TURN" $mom_sys_mill_turn_type] {
    set post_links {MILL this_post TURN lathe_tool_tip}
   }
   set mom_sys_var(\$mom_sys_mill_turn_type) $mom_sys_mill_turn_type
   unset mom_sys_mill_turn_type
  }
  global mom_sys_lathe_postname
  if [info exists mom_sys_lathe_postname] {
   set lathe_post_name [file rootname [file tail $mom_sys_lathe_postname]]
   if [info exists post_links] {
    set post_links [lreplace $post_links 3 3 $lathe_post_name]
   }
   set mom_sys_var(\$mom_sys_lathe_postname) $lathe_post_name
   unset mom_sys_lathe_postname
  }
  if [info exists post_links] {
   set mom_sys_var(\$mom_sys_postname_list) $post_links
  }
  set Post::($post_object,mom_sys_var_list) [array get mom_sys_var]
 }
}
if { [string match "PB_CMD_init_mill_xzc"     $__PB_cmd_name] || \
 [string match "PB_CMD_kin_mill_xzc_init" $__PB_cmd_name] } {
 uplevel 1 {
  global post_object
  array set mom_sys_var $Post::($post_object,mom_sys_var_list)
  array set mom_kin_var $Post::($post_object,mom_kin_var_list)
  if [info exists mom_sys_spindle_axis] {
   set spindle_axis "Z_AXIS"
   if { [expr $mom_sys_spindle_axis(0) == 1.0] && \
    [expr $mom_sys_spindle_axis(1) == 0.0] && \
    [expr $mom_sys_spindle_axis(2) == 0.0] } {
    set spindle_axis "+X_AXIS"
   }
   if { [expr $mom_sys_spindle_axis(0) == -1.0] && \
    [expr $mom_sys_spindle_axis(1) == 0.0] && \
    [expr $mom_sys_spindle_axis(2) == 0.0] } {
    set spindle_axis "-X_AXIS"
   }
   if { [expr $mom_sys_spindle_axis(0) == 0.0] && \
    [expr $mom_sys_spindle_axis(1) == 1.0] && \
    [expr $mom_sys_spindle_axis(2) == 0.0] } {
    set spindle_axis "Y_AXIS"
   }
   if { [expr $mom_sys_spindle_axis(0) == 0.0] && \
    [expr $mom_sys_spindle_axis(1) == 0.0] && \
    [expr $mom_sys_spindle_axis(2) == 1.0] } {
    set spindle_axis "Z_AXIS"
   }
   if ![info exists mom_sys_var(\$mill_turn_spindle_axis)] {
    set mom_sys_var(\$mill_turn_spindle_axis) $spindle_axis
   }
   unset mom_sys_spindle_axis
  }
  if [info exists mom_sys_radius_output_mode] {
   set mom_sys_var(\$mom_sys_radius_output_mode) $mom_sys_radius_output_mode
   unset mom_sys_radius_output_mode
  }
  if [info exists mom_sys_millturn_yaxis] {
   set mom_sys_var(\$mom_sys_millturn_yaxis) $mom_sys_millturn_yaxis
   unset mom_sys_millturn_yaxis
  }
  if [info exists mom_sys_coordinate_output_mode] {
   set mom_sys_var(\$mom_sys_coordinate_output_mode) $mom_sys_coordinate_output_mode
   unset mom_sys_coordinate_output_mode
  }
  if 0 {
   if [info exists mom_sys_xzc_arc_output_mode] {
    set mom_sys_var(\$mom_sys_xzc_arc_output_mode) $mom_sys_xzc_arc_output_mode
    unset mom_sys_xzc_arc_output_mode
   }
  }
  if [info exists mom_kin_4th_axis_direction] {
   set mom_kin_var(\$mom_kin_4th_axis_direction) $mom_kin_4th_axis_direction
   unset mom_kin_4th_axis_direction
  }
  if [info exists mom_kin_4th_axis_min_limit] {
   set mom_kin_var(\$mom_kin_4th_axis_min_limit) $mom_kin_4th_axis_min_limit
   unset mom_kin_4th_axis_min_limit
  }
  if [info exists mom_kin_4th_axis_max_limit] {
   set mom_kin_var(\$mom_kin_4th_axis_max_limit) $mom_kin_4th_axis_max_limit
   unset mom_kin_4th_axis_max_limit
  }
  if [info exists mom_kin_4th_axis_leader] {
   set mom_kin_var(\$mom_kin_4th_axis_leader) $mom_kin_4th_axis_leader
   unset mom_kin_4th_axis_leader
  }
  if [info exists mom_kin_linearization_tol] {
   set mom_kin_var(\$mom_kin_linearization_tol) $mom_kin_linearization_tol
   unset mom_kin_linearization_tol
  }
  if [info exists mom_sys_leader(fourth_axis)] {
   set mom_sys_var(\$mom_sys_leader(fourth_axis)) $mom_sys_leader(fourth_axis)
   unset mom_sys_leader(fourth_axis)
  }
  set Post::($post_object,mom_sys_var_list) [array get mom_sys_var]
  set Post::($post_object,mom_kin_var_list) [array get mom_kin_var]
 } ;# uplevel
}
} ;# PB_is_v3
if ![info exists gPB(PUI_Version)] {
if [info exists gPB(Old_PUI_Version)] {
 set gPB(PUI_Version) $gPB(Old_PUI_Version)
 } else {
 set gPB(PUI_Version) $gPB(Postbuilder_PUI_Version)
}
}
set Postbuilder_Version $gPB(Postbuilder_Version)
set gPB(Postbuilder_Version) $gPB(PUI_Version)
if { [PB_is_v 3.4] == 0 } {
if { [string match "PB_CMD_init_new_iks" $__PB_cmd_name] ||\
 [string match "PB_CMD_set_new_iks"  $__PB_cmd_name] ||\
 [string match "*ugpadvkins.*"       [join $__PB_tmp_proc_data]] } {
 if [string match "*ugpadvkins.*" [join $__PB_tmp_proc_data]] {
  uplevel 1 {
   set mom_kin_iks_usage 1
  }
 }
 uplevel 1 {
  global post_object
  array set mom_kin_var $Post::($post_object,mom_kin_var_list)
  set iks_var_list { mom_iks_usage \
   mom_kin_iks_usage \
   mom_kin_rotary_axis_method \
   mom_kin_machine_zero_offset \
   mom_kin_spindle_axis \
   mom_kin_4th_axis_point \
   mom_kin_5th_axis_point \
   mom_kin_4th_axis_vector \
  mom_kin_5th_axis_vector }
  set fetch_iks 0
  foreach var $iks_var_list {
   catch {global $var}
   if [info exists $var] {
    if { [string match "mom_iks_usage"     $var] ||\
     [string match "mom_kin_iks_usage" $var] } {
     set val [set $var]
     if { $val } {
      set fetch_iks 1
      set gPB(new_IKS_in_use) 1
     }
     continue
    }
    if $fetch_iks {
     if [string match "mom_kin_rotary_axis_method" $var] {
      set mom_kin_var(\$[set var]) [set $var]]
      } else {
      foreach i { 0 1 2 } {
       if [info exists [set var]($i)] {
        set mom_kin_var(\$[set var]($i)) [eval format $[set var]($i)]
       }
      }
     }
    }
   }
  }
  if $fetch_iks {
   set PI [expr acos(-1.0)]
   if { ![info exists mom_kin_var(\$mom_kin_4th_axis_vector(0\)] || \
    ![info exists mom_kin_var(\$mom_kin_4th_axis_vector(1\)] || \
    ![info exists mom_kin_var(\$mom_kin_4th_axis_vector(2\)] } {
    set mom_kin_var(\$mom_kin_4th_axis_vector(0\))      0.0
    set mom_kin_var(\$mom_kin_4th_axis_vector(1\))      1.0
    set mom_kin_var(\$mom_kin_4th_axis_vector(2\))      0.0
   }
   set x $mom_kin_var(\$mom_kin_4th_axis_vector(0\))
   set y $mom_kin_var(\$mom_kin_4th_axis_vector(1\))
   set z $mom_kin_var(\$mom_kin_4th_axis_vector(2\))
   if       [ PB_val_is_equal [expr atan2($z,sqrt($x*$x + $y*$y))] [expr $PI/2] ] {
    set mom_kin_var(\$mom_kin_4th_axis_plane) "XY"
    } elseif [ PB_val_is_equal [expr atan2($x,sqrt($y*$y + $z*$z))] [expr $PI/2] ] {
    set mom_kin_var(\$mom_kin_4th_axis_plane) "YZ"
    } elseif [ PB_val_is_equal [expr atan2($y,sqrt($z*$z + $x*$x))] [expr $PI/2] ] {
    set mom_kin_var(\$mom_kin_4th_axis_plane) "ZX"
    } else {
    set mom_kin_var(\$mom_kin_4th_axis_plane) "Other"
   }
   if { ![info exists mom_kin_var(\$mom_kin_5th_axis_vector(0\)] || \
    ![info exists mom_kin_var(\$mom_kin_5th_axis_vector(1\)] || \
    ![info exists mom_kin_var(\$mom_kin_5th_axis_vector(2\)] } {
    set mom_kin_var(\$mom_kin_5th_axis_vector(0\))      0.0
    set mom_kin_var(\$mom_kin_5th_axis_vector(1\))      0.0
    set mom_kin_var(\$mom_kin_5th_axis_vector(2\))      1.0
   }
   set x $mom_kin_var(\$mom_kin_5th_axis_vector(0\))
   set y $mom_kin_var(\$mom_kin_5th_axis_vector(1\))
   set z $mom_kin_var(\$mom_kin_5th_axis_vector(2\))
   if       [ PB_val_is_equal [expr atan2($z,sqrt($x*$x+$y*$y))] [expr $PI/2] ] {
    set mom_kin_var(\$mom_kin_5th_axis_plane) "XY"
    } elseif [ PB_val_is_equal [expr atan2($x,sqrt($y*$y+$z*$z))] [expr $PI/2] ] {
    set mom_kin_var(\$mom_kin_5th_axis_plane) "YZ"
    } elseif [ PB_val_is_equal [expr atan2($y,sqrt($z*$z+$x*$x))] [expr $PI/2] ] {
    set mom_kin_var(\$mom_kin_5th_axis_plane) "ZX"
    } else {
    set mom_kin_var(\$mom_kin_5th_axis_plane) "Other"
   }
   set Post::($post_object,mom_kin_var_list)     [array get mom_kin_var]
   set Post::($post_object,def_mom_kin_var_list) [array get mom_kin_var]
  }
 } ;# uplevel
}
} else {
set gPB(new_IKS_in_use) 1
} ;# PB_is_v 3.4
if { [PB_is_v 6.0.2] == 0 } {
if { ![info exists gPB(non_overite_mom_sim)] } {
 set gPB(non_overite_mom_sim) 0
}
if { $gPB(non_overite_mom_sim) == 0 } {
 if { [string match "VNC_load_post_definitions" $__PB_cmd_name] ||\
  [string match "VNC_set_nc_definitions" $__PB_cmd_name] } {
  global mom_sim_output_unit mom_sim_arr mom_kin_var
  global output_unit
  uplevel #0 {
   global mom_sim_output_unit mom_sim_arr mom_kin_var
   global output_unit
   if { [info exists output_unit] } {
    set current_unit $output_unit
    } elseif { [info exists mom_kin_var(\$mom_kin_output_unit)] } {
    set current_unit $mom_kin_var(\$mom_kin_output_unit)
    } elseif { [info exists mom_sim_output_unit] } {
    set current_unit $mom_sim_output_unit
   }
   switch $current_unit {
    "IN" {
     set mom_sim_arr(\$mom_sim_feed_mode) "INCH_PER_MIN"
     set mom_sim_arr(\$mom_sim_spindle_mode) "SFM"
    }
    "MM" {
     set mom_sim_arr(\$mom_sim_feed_mode) "MM_PER_MIN"
     set mom_sim_arr(\$mom_sim_spindle_mode) "SMM"
    }
   }
   set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
   set Post::($post_object,def_mom_sim_var_list) [array get mom_sim_arr]
  } ;# uplevel
 }
 if { [string match "PB_CMD_vnc____set_nc_definitions" $__PB_cmd_name] } {
  global mom_sys_arr mom_sim_arr gPB
  if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
   if { ![info exists gPB($__PB_cmd_name,validate_once)] } {
    set gPB($__PB_cmd_name,validate_once) 0
   }
   if { $gPB($__PB_cmd_name,validate_once) == 0 } {
    uplevel #0 {
     global mom_sim_arr
     array set mom_sim_arr $Post::($post_object,mom_sim_var_list)
     global mom_sim_nc_register
     set reg_var_name [list "MOTION" "SPINDLE_MODE" "SPINDLE_DIRECTION"\
     "FEED_MODE" "INPUT" "DEF_INPUT"]
     foreach reg_var $reg_var_name {
      if {[info exists mom_sim_nc_register($reg_var)]} {
       set value $mom_sim_nc_register($reg_var)
       } else {
       continue
      }
      switch $reg_var {
       "MOTION" {
        set mom_sim_arr(\$mom_sim_initial_motion) $value
       }
       "SPINDLE_MODE" {
        set mom_sim_arr(\$mom_sim_spindle_mode) $value
       }
       "SPINDLE_DIRECTION" {
        set mom_sim_arr(\$mom_sim_spindle_direction) $value
       }
       "FEED_MODE" {
        set mom_sim_arr(\$mom_sim_feed_mode) $value
       }
       "INPUT" {
        set mom_sim_arr(\$mom_sim_input_mode) $value
       }
       "DEF_INPUT" {
        set mom_sim_arr(\$mom_sim_input_mode) $value
       }
      }
     }
     global mom_sim_nc_func gpb_addr_var
     set func_var_name [list "RETURN_HOME_P" "FROM_HOME" "LOCAL_CS_SET" "MACH_CS_MOVE"]
     for { set i 0 } { $i < 12} { incr i} {
      lappend func_var_name "WORK_CS_$i"
     }
     foreach func_var $func_var_name {
      if {[info exists mom_sim_nc_func($func_var)]} {
       if {[info exists gpb_addr_var(G,leader_name)]} {
        set leader $gpb_addr_var(G,leader_name)
        } else {
        set leader "G"
       }
       set value [string trimleft $mom_sim_nc_func($func_var) $leader]
       } else {
       continue
      }
      switch $func_var {
       "RETURN_HOME_P" {
        set mom_sim_arr(\$mom_sim_return_home) $value
       }
       "FROM_HOME" {
        set mom_sim_arr(\$mom_sim_from_home) $value
       }
       "LOCAL_CS_SET" {
        set mom_sim_arr(\$mom_sim_local_wcs) $value
       }
       "MACH_CS_MOVE" {
        set mom_sim_arr(\$mom_sim_mach_cs) $value
       }
      }
      if {[string match "WORK_CS_*" $func_var]} {
       set num_ind [string last "_" $func_var]
       set num [string range $func_var [expr $num_ind + 1] end]
       set mom_sim_arr(\$mom_sim_wcs_$num) $value
      }
     }
     set sim_var_list {mom_sim_initial_motion\
      mom_sim_spindle_direction\
      mom_sim_feedrate_mode\
      mom_sim_input_mode\
      mom_sim_control_var_leader\
      mom_sim_prog_rewind_stop_code\
      mom_sim_control_var_leader\
      mom_sim_control_equal_sign\
      mom_sim_from_home\
      mom_sim_return_home\
      mom_sim_local_wcs\
      mom_sim_mach_cs\
      mom_sim_rapid_dogleg\
      mom_sim_incr_linear_addrs\
      mom_sim_output_vnc_msg\
      mom_sim_wcs_offsets\
      mom_sim_tool_data\
     mom_sim_machine_zero_offsets}
     foreach sim_var $sim_var_list {
      global $sim_var
      if {[info exists $sim_var]} {
       if {[array exists $sim_var]} {
        set arrvar_names [array names $sim_var]
        foreach item $arrvar_names {
         set mom_sim_arr(\$[set sim_var]\($item\)) [set ${sim_var}($item)]
         if {[string match "mom_sim_wcs_offsets" $sim_var]} {
          set mom_sim_arr(\$mom_sim_wcsnum_list) $arrvar_names
          if {[llength [set ${sim_var}($item)]] == 5} {
           lappend ${sim_var}($item) 0.0
           lappend mom_sim_arr(\$[set sim_var]\($item\)) 0.0
          }
         }
         if {[string match "mom_sim_tool_data" $sim_var]} {
          set mom_sim_arr(\$mom_sim_tool_list) [list]
          foreach fir_nam $arrvar_names {
           set ind [string first "," $fir_nam]
           set tool_num [string range $fir_nam 0 [expr $ind - 1]]
           if {[lsearch $mom_sim_arr(\$mom_sim_tool_list) $tool_num] < 0} {
            lappend mom_sim_arr(\$mom_sim_tool_list) $tool_num
           }
          }
         }
        }
        } else {
        set mom_sim_arr(\$[set sim_var]) [set $sim_var]
       }
       } elseif { ![info exists mom_sim_arr(\$$sim_var)] ||\
       [string match "" $mom_sim_arr(\$$sim_var)] } {
       switch $sim_var {
        mom_sim_control_var_leader \
        { set mom_sim_arr(\$mom_sim_control_var_leader)               "\#" }
        mom_sim_initial_motion \
        { set mom_sim_arr(\$mom_sim_initial_motion)                 "RAPID"}
        mom_sim_input_mode \
        { set mom_sim_arr(\$mom_sim_input_mode)                       "ABS"}
        mom_sim_prog_rewind_stop_code \
        { set mom_sim_arr(\$mom_sim_prog_rewind_stop_code)              "%"}
        mom_sim_control_var_leader \
        { set mom_sim_arr(\$mom_sim_control_var_leader)                 "#"}
        mom_sim_control_equal_sign \
        { set mom_sim_arr(\$mom_sim_control_equal_sign)                 "="}
        mom_sim_rapid_dogleg \
        { set mom_sim_arr(\$mom_sim_rapid_dogleg)                       "0"}
        mom_sim_incr_linear_addrs \
        { set mom_sim_arr(\$mom_sim_incr_linear_addrs)     [list X Y Z A B]}
        mom_sim_output_vnc_msg \
        { set mom_sim_arr(\$mom_sim_output_vnc_msg)                     "0"}
        mom_sim_spindle_direction \
        { set mom_sim_arr(\$mom_sim_spindle_direction)                "CLW"}
        mom_sim_from_home \
        { set mom_sim_arr(\$mom_sim_from_home)                         "29"}
        mom_sim_return_home \
        { set mom_sim_arr(\$mom_sim_return_home)                       "30"}
        mom_sim_local_wcs \
        { set mom_sim_arr(\$mom_sim_local_wcs)                         "52"}
        mom_sim_mach_cs \
        { set mom_sim_arr(\$mom_sim_mach_cs)                           "53"}
        mom_sim_wcs_offsets \
        {
         if {![info exists mom_sim_arr(\$mom_sim_wcs_offsets\(0\))]} {
          for { set i 0 } { $i <= 6 } { incr i } {
           set mom_sim_arr(\$mom_sim_wcs_offsets\($i\)) [list 0.0 0.0 0.0 0.0 0.0 0.0]
          }
         }
        }
        mom_sim_tool_data \
        {
         if {![info exists mom_sim_arr(\$mom_sim_tool_list)]} {
          set mom_sim_arr(\$mom_sim_tool_list) [list]
         }
        }
        mom_sim_machine_zero_offsets \
        {
         set mom_sim_arr(\$mom_sim_machine_zero_offsets) [list 0.0 0.0 0.0]
        }
       } ;#switch
      } ;# else
     } ;# foreach
     set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
     set Post::($post_object,def_mom_sim_var_list) [array get mom_sim_arr]
    } ;# uplevel
   }
   set $gPB($__PB_cmd_name,validate_once) 0
  } ;# Standalone
 } ;# string match set_nc_definitions
 if { [string match "PB_CMD_vnc____map_machine_tool_axes"  $__PB_cmd_name] } {
  PB_InitialVNC_Seqlist
  uplevel #0 {
   array set mom_sim_arr $Post::($post_object,mom_sim_var_list)
   set sim_var_list {mom_sim_zcs_base \
    mom_sim_spindle_comp \
    mom_sim_spindle_jct \
    mom_sim_mt_axis \
   mom_sim_num_machine_axes}
   if ![info exists machType] {
    set machType "Mill"
    set axisoption "3"
   }
   if {[info exists mom_sim_machine_type]} {
    PB_com_GetMachAxisType $mom_sim_machine_type machType axisoption
   }
   if {[string match "4*" $axisoption]} {
    lappend sim_var_list mom_sim_reverse_4th_table
    lappend sim_var_list mom_sim_4th_axis_has_limits
   }
   if {[string match "5*" $axisoption]} {
    lappend sim_var_list mom_sim_reverse_4th_table
    lappend sim_var_list mom_sim_4th_axis_has_limits
    lappend sim_var_list mom_sim_reverse_5th_table
    lappend sim_var_list mom_sim_5th_axis_has_limits
   }
   foreach sim_var $sim_var_list {
    global $sim_var
    if { [info exists $sim_var] || [array exists $sim_var] } {
     if { [string match "mom_sim_mt_axis" $sim_var] } {
      set arrvar_names [array names $sim_var]
      foreach item $arrvar_names {
       set mom_sim_arr(\$[set sim_var]\($item\)) [set ${sim_var}($item)]
      }
      if { [string match "Lathe" $machType] || [string match "3MT" $axisoption] } {
       PB_com_unset_var mom_sim_arr(\$mom_sim_mt_axis\(Y\))
      }
      } else {
      set mom_sim_arr(\$[set sim_var]) [set $sim_var]
      set value [set $sim_var]
     }
     PB_com_unset_var $sim_var
     } elseif { ![info exists mom_sim_arr(\$$sim_var)] } {
     switch $sim_var {
      mom_sim_zcs_base \
      {
       set mom_sim_arr(\$mom_sim_zcs_base) "X_SLIDE"
      }
      mom_sim_spindle_comp \
      {
       set mom_sim_arr(\$mom_sim_spindle_comp) "SPINDLE"
      }
      mom_sim_spindle_jct \
      {
       set mom_sim_arr(\$mom_sim_spindle_jct) "TOOL_MOUNT_JCT"
      }
      mom_sim_reverse_4th_table \
      {
       set mom_sim_arr(\$mom_sim_reverse_4th_table) "0"
      }
      mom_sim_reverse_5th_table \
      {
       set mom_sim_arr(\$mom_sim_reverse_5th_table) "0"
      }
      mom_sim_4th_axis_has_limits \
      {
       set mom_sim_arr(\$mom_sim_4th_axis_has_limits) "1"
      }
      mom_sim_5th_axis_has_limits \
      {
       set mom_sim_arr(\$mom_sim_5th_axis_has_limits) "1"
      }
      mom_sim_num_machine_axes \
      {
       if {[string match "2*" $axisoption]} {
        set mom_sim_arr(\$mom_sim_num_machine_axes) "2"
       }
       if {[string match "3*" $axisoption] && ![string match "3MT" $axisoption]} {
        set mom_sim_arr(\$mom_sim_num_machine_axes) "3"
       }
       if {[string match "4*" $axisoption] || [string match "3MT" $axisoption]} {
        set mom_sim_arr(\$mom_sim_num_machine_axes) "4"
       }
       if [string match "5*" $axisoption] {
        set mom_sim_arr(\$mom_sim_num_machine_axes) "5"
       }
      }
      mom_sim_mt_axis \
      {
       if {![info exists mom_sim_arr(\$mom_sim_mt_axis\(X\))]} {
        set mom_sim_arr(\$mom_sim_mt_axis\(X\)) "X"
        set mom_sim_arr(\$mom_sim_mt_axis\(Y\)) "Y"
        set mom_sim_arr(\$mom_sim_mt_axis\(Z\)) "Z"
       }
       switch $machType {
        "Mill" {
         switch $axisoption {
          "3MT" {
           if ![info exists mom_sim_arr($mom_sim_mt_axis\(4\))] {
            set mom_sim_arr(\$mom_sim_mt_axis\(4\)) "C"
            PB_com_unset_var mom_sim_arr(\$mom_sim_mt_axis\(Y\))
           }
          }
          "4H" -
          "4T" {
           if {![info exists mom_sim_arr(\$mom_sim_mt_axis\(4\))]} {
            set mom_sim_arr(\$mom_sim_mt_axis\(4\)) "A"
           }
          }
          "5HH" -
          "5HT" -
          "5TT" {
           if {![info exists mom_sim_arr(\$mom_sim_mt_axis\(4\))]} {
            set mom_sim_arr(\$mom_sim_mt_axis\(4\)) "B"
            set mom_sim_arr(\$mom_sim_mt_axis\(5\)) "C"
           }
          }
         }
        }
        "Lathe" {
         PB_com_unset_var mom_sim_arr(\$mom_sim_mt_axis\(Y\))
        }
       }
      }
     }
    }
   }
  } ;# uplevel
  set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
  set Post::($post_object,def_mom_sim_var_list) [array get mom_sim_arr]
 } ;# string match map machine tool axes
} ; # when save none overwrite mom_sim_arr
} ;# PB_is_v 6.0
set  gPB(Postbuilder_Version) $Postbuilder_Version
} ;# __PB_proc_ok
if { $__PB_proc_ok != 1 } {
set errorInfo $__PB_res_more
set __PB_idx [string last "invoked from within" $errorInfo]
if { $__PB_idx > 0 } {
set __PB_res [string range $errorInfo 0 [expr int($__PB_idx - 1)]]
} else {
set __PB_res $errorInfo
}
set __PB_res "Error found in \"$__PB_cmd_name\" : \n\n\
$__PB_res"
set __PB_proc_ok 0 ;# Error
}
if { ![info exists gPB(cmd_obj_cleanup)] || $gPB(cmd_obj_cleanup) == 1 } {
PB_proc_CleanUpCmdObjs
}
return $__PB_proc_ok
}

#=======================================================================
proc PB_pps_ValidateAllCustCmd { args } {
  global post_object
  Post::GetObjList $post_object command cmd_blk_list
  foreach cc $cmd_blk_list {
   command::readvalue $cc attr
   set proc_state [PB_proc_ValidateCustCmd $attr(0) $attr(1) res]
   if { $proc_state <= 0 } {
    return $proc_state
   }
  }
 }

#=======================================================================
proc PB_pps_ConvertOldUdeDefinitionStyle { } {
  global post_object gPB env
  set names [array names command:: *name]
  set obj_list [list]
  foreach one $names {
   if {[string match "PB_CMD_kin_init_rotary" $command::($one)] || \
    [string match "PB_CMD_kin_init_mill_xzc" $command::($one)]} {
    if {[string trim $command::([lindex [split $one ,] 0],proc)] != ""} {
     lappend obj_list [lindex [split $one ,] 0]
    }
   }
  }
  if {[llength $obj_list] > 0} {
   foreach obj $obj_list {
    set proc_body $command::($obj,proc)

#=======================================================================
set start_idx [lsearch $proc_body "proc *"]
 set end_idx [lsearch $proc_body "*;# uplevel*"]
 set temp_proc_body [lrange $proc_body $start_idx [expr $end_idx - 1]]
 set cmd_str [join $temp_proc_body "\n"]
 set tmp_file_name $::env(TEMP)\\[clock clicks].tcl
 global tcl_platform
 if { ![string match "windows" $tcl_platform(platform)] } {
  regsub -all {\\} $tmp_file_name {/}  tmp_file_name
 }
 set fid [open $tmp_file_name w]
 puts $fid $cmd_str
 close $fid
 PB_com_unset_var event_proc_data
 PB_pps_ParseTclFile $tmp_file_name event_proc_data 0
 file delete -force $tmp_file_name
 if {[info exists env(PB_UDE_ENABLED)] && $env(PB_UDE_ENABLED) == 1} {
  set names [array names event_proc_data MOM*name]
  if {[llength $names] == 0} {
   continue
  }
  set exist_handler_list [list]
  foreach one $names {
   lappend exist_handler_list [lindex [split $one ,] 0]
  }
  set to_be_delete [list]
  set ude_event_obj_list [list]
  set names [array names ::ude_event:: "*,name"]
  foreach one $names {
   set post_event $::ude_event::([lindex [split $one ,] 0],post_event)
   if {[string trim $post_event] == ""} {
    set handler_name MOM_$::ude_event::($one)
    } else {
    set handler_name MOM_$post_event
   }
   if {[lsearch $exist_handler_list $handler_name] >= 0} {
    lappend to_be_delete $handler_name
    lappend ude_event_obj_list [lindex [split $one ,] 0]
   }
  }
  set event_objs [list]
  set names [array names ::event:: *ude_event_obj]
  foreach one $names {
   if {[lsearch $ude_event_obj_list $::event::($one)] >= 0} {
    lappend event_objs [lindex [split $one ,] 0]
   }
  }
  if { [llength $to_be_delete] == 0 } {
   continue
   } else {
   set len [llength $proc_body]
   set start_idx [list]
   set proc_name_list [list]
   for { set i 0 } { $i < $len } { incr i } {
    set temp_line [string trim [lindex $proc_body $i]]

#=======================================================================
if { [string match "proc MOM*" $temp_line] } {
  set proc_name [lindex [split $temp_line] 1]
  if { [lsearch $to_be_delete $proc_name] >= 0 } {
   set start [string first $proc_name [lindex $proc_body $i]]
   set end [expr $start + [string length $proc_name] - 1]
   set fs [string range [lindex $proc_body $i]  0 [expr $start - 1]]
   set es [string range [lindex $proc_body $i] [expr $end + 1] end]
   set new_line "${fs}DUMMY_${proc_name}${es}"
   set proc_body [lreplace $proc_body $i $i $new_line]
   set start_idx [linsert $start_idx 0 $i]
   set proc_name_list [linsert $proc_name_list 0 $proc_name]
   set cmd_obj_attr(0) PB_CMD_$proc_name
   set cmd_obj_attr(1) "{# Default handler for UDE $proc_name} {# - Do not attach it to any event!} {#} {}\
   $event_proc_data($proc_name,proc)"
   set cmd_obj_attr(2) ""
   set cmd_obj_attr(3) ""
   set cmd_obj_attr(4) ""
   set idx [lsearch $to_be_delete $proc_name]
   set ude_event_obj [lindex $ude_event_obj_list $idx]
   set the_one ""
   foreach one $event_objs {
    if {$::event::($one,ude_event_obj) == $ude_event_obj} {
     set the_one $one
     break
    }
   }
   set exist_names [array names command:: *name]
   set is_to_create 1
   set cmd_obj NULL
   foreach one $exist_names {
    if [string match "$cmd_obj_attr(0)" $command::($one)] {
     set is_to_create 0
     set cmd_obj [lindex [split $one ,] 0]
     break
    }
   }
   if $is_to_create {
    set result ""
    PB_proc_ValidateCustCmd $cmd_obj_attr(0) $cmd_obj_attr(1) result
    PB_pps_CreateCommand cmd_obj_attr cmd_obj
    PB_int_UpdateCommandAdd cmd_obj
   }
   if { [string length $the_one] > 0 } {
    set exists_elem_list $event::($the_one,evt_elem_list)
    set is_to_added 1
    foreach one $exists_elem_list {
     if [string match $::event_element::($one,evt_elem_name) $cmd_obj_attr(0)] {
      set is_to_added 0
      break
     }
    }
    if $is_to_added {
     PB_int_CreateCmdBlkElem cmd_obj_attr(0) new_elem_obj
     set block_element::($new_elem_obj,owner) $event::($the_one,event_name)
     PB_int_CreateCmdBlock cmd_obj_attr(0) new_elem_obj new_block_obj
     set block::($new_block_obj,blk_owner) $event::($the_one,event_name)
     PB_int_CreateNewEventElement new_block_obj new_evt_elem $the_one
     lappend block::($new_block_obj,active_blk_elem_list) $new_elem_obj
     lappend event::($the_one,evt_elem_list) $new_evt_elem
     event::DefaultValue $the_one
    }
   }
  }
 }
}
set len [llength $start_idx]
for {set i 0} {$i < $len} {incr i} {
 set idx [lindex $start_idx $i]
 set proc_name [lindex $proc_name_list $i]
 if 0 {

#=======================================================================
set comment1 "### The original name of the belowing proc is $proc_name"
 set comment2 "### A new command PB_CMD_$proc_name is created."
 set comment3 "### And it is included in $proc_name"
 set proc_body [linsert $proc_body $idx $comment3]
 set proc_body [linsert $proc_body $idx $comment2]
 set proc_body [linsert $proc_body $idx $comment1]
 } else {
 set comment1 "### This is the backup of original $proc_name handler."
 set comment2 "###"
 set comment3 "### - New command PB_CMD_$proc_name is created with the"
 set comment4 "###   same content of the original command and executed"
 set comment5 "###   by the new $proc_name handler."
 set comment6 "###"
 set proc_body [linsert $proc_body $idx $comment6]
 set proc_body [linsert $proc_body $idx $comment5]
 set proc_body [linsert $proc_body $idx $comment4]
 set proc_body [linsert $proc_body $idx $comment3]
 set proc_body [linsert $proc_body $idx $comment2]
 set proc_body [linsert $proc_body $idx $comment1]
}
}
set command::($obj,proc) $proc_body
}
Post::GetObjList $post_object command cmd_blk_list
PB_com_SortObjectsByNames cmd_blk_list
Post::SetObjListasAttr $post_object cmd_blk_list
} else {
set names [array names event_proc_data DUMMY*name]
if {[llength $names] == 0} {
continue
}
set len [llength $proc_body]
set start_idx [list]
for {set i 0} {$i < $len} {incr i} {
set temp_line [string trim [lindex $proc_body $i]]

#=======================================================================
if [string match "proc DUMMY_MOM*" $temp_line] {
  set proc_name [lindex [split $temp_line] 1]
  set start [string first $proc_name [lindex $proc_body $i]]
  set end [expr $start + [string length $proc_name] -1]
  set fs [string range [lindex $proc_body $i]  0 [expr $start - 1]]
  set es [string range [lindex $proc_body $i] [expr $end + 1] end]
  set new_line "${fs}[string range $proc_name 6 end]${es}"
  set proc_body [lreplace $proc_body $i $i $new_line]
  set start_idx [linsert $start_idx 0 $i]
 }
}
set n_cmt 6
foreach one $start_idx {
 set idx [expr $one - $n_cmt]
 for { set i 1 } { $i <= $n_cmt } { incr i } {
  if [string match "###*" [lindex $proc_body $idx]] {
   set proc_body [lreplace $proc_body $idx $idx]
  }
 }
}
set command::($obj,proc) $proc_body
set to_be_delete [list]
foreach one $names {
 set dummy_proc_name [lindex [split $one ,] 0]
 lappend to_be_delete PB_CMD_[string range $dummy_proc_name 6 end]
}
set obj_list [list]
set names [array names command:: *name]
foreach one $names {
 if {[lsearch $to_be_delete $command::($one)] >= 0} {
  lappend obj_list [lindex [split $one ,] 0]
 }
}
global post_object
foreach one $obj_list {
 Post::GetObjList $post_object command cmd_blk_list
 set idx [lsearch $cmd_blk_list $one]
 set cmd_blk_list [lreplace $cmd_blk_list $idx $idx]
 Post::SetObjListasAttr $post_object cmd_blk_list
 PB_int_RemoveCmdProcFromList one
 delete $one
}
}
}
}
set old_handler_name [list MOM_opskip_on \
MOM_opskip_off \
MOM_insert \
MOM_pprint \
MOM_operator_message \
MOM_text]
if { [info exists env(PB_UDE_ENABLED)] && $env(PB_UDE_ENABLED) == 1 } {
set ude_event_obj_list [list]
set handler_name_list [list]
set names [array names ::ude_event:: "*,name"]
foreach one $names {
set post_event $::ude_event::([lindex [split $one ,] 0],post_event)
if {[string trim $post_event] == ""} {
set handler_name MOM_$::ude_event::($one)
} else {
set handler_name MOM_$post_event
}
if {[lsearch $old_handler_name $handler_name] >= 0} {
lappend ude_event_obj_list [lindex [split $one ,] 0]
lappend handler_name_list $handler_name
}
}
set event_objs_with_index [list]
set names [array names ::event:: *ude_event_obj]
foreach one $names {
set idx [lsearch $ude_event_obj_list $::event::($one)]
if { $idx >= 0 } {
lappend event_objs_with_index "$idx [lindex [split $one ,] 0]"
}
}
foreach one $event_objs_with_index {
set idx [lindex $one 0]
set event_obj [lindex $one 1]
set command_name PB_CMD_[lindex $handler_name_list $idx]
set exists_elem_list $event::($event_obj,evt_elem_list)
set is_to_added 1
foreach one $exists_elem_list {
if [string match $::event_element::($one,evt_elem_name) $command_name] {
 set is_to_added 0
 break
}
}
if $is_to_added {
if { [PB_com_FindObjFrmName $command_name command] >= 0 } {
 PB_int_CreateCmdBlkElem command_name new_elem_obj
 set block_element::($new_elem_obj,owner) $event::($event_obj,event_name)
 PB_int_CreateCmdBlock command_name new_elem_obj new_block_obj
 set block::($new_block_obj,blk_owner) $event::($event_obj,event_name)
 PB_int_CreateNewEventElement new_block_obj new_evt_elem $event_obj
 lappend block::($new_block_obj,active_blk_elem_list) $new_elem_obj
 lappend event::($event_obj,evt_elem_list) $new_evt_elem
 event::DefaultValue $event_obj
}
}
}
} elseif { 0 } {
set cmd_name_list [list]
foreach one $old_handler_name {
lappend cmd_name_list "PB_CMD_$one"
}
set obj_list [list]
set names [array names command:: *name]
foreach one $names {
if {[lsearch $cmd_name_list $command::($one)] >= 0} {
lappend obj_list [lindex [split $one ,] 0]
}
}
global post_object
foreach one $obj_list {
Post::GetObjList $post_object command cmd_blk_list
set idx [lsearch $cmd_blk_list $one]
set cmd_blk_list [lreplace $cmd_blk_list $idx $idx]
Post::SetObjListasAttr $post_object cmd_blk_list
PB_int_RemoveCmdProcFromList one
delete $one
}
}
}
