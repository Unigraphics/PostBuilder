#25

#=======================================================================
proc PB_pps_CreateTclFileObjs { POST_OBJECT } {
  upvar $POST_OBJECT post_object
  PB_pps_ParseTclFile post_object event_procs
  set event_name_list [array get event_procs]
  set cmd_procs_list ""
  foreach event_name $event_name_list \
  {
   if { [string match "PB_CMD*" $event_name] } \
   {
    lappend cmd_procs_list $event_name
    PB_pps_GetCmdBlkProc event_procs($event_name) cmd_proc
    set cmd_proc_data($event_name) $cmd_proc
    unset event_procs($event_name)
   }
  }
  Post::SetEventProcs $post_object event_procs
  set cmd_blk_list ""
  foreach cmd_blk $cmd_procs_list \
  {

#=======================================================================
set cmd_proc $cmd_proc_data($cmd_blk)
 set cmd_obj_attr(0) $cmd_blk
 set cmd_obj_attr(1) $cmd_proc
 PB_pps_CreateCommand cmd_obj_attr cmd_obj
 lappend cmd_blk_list $cmd_obj
}
Post::SetCmdBlkObj $post_object cmd_blk_list
}

#=======================================================================
proc PB_pps_CreateCommand { CMD_OBJ_ATTR CMD_OBJ } {
  upvar $CMD_OBJ_ATTR cmd_obj_attr
  upvar $CMD_OBJ cmd_obj
  set cmd_obj [new command]
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
 }

#=======================================================================
proc  PB_pps_GetCmdBlkProc { EVENT_PROC CMD_PROC } {
  upvar $EVENT_PROC event_proc
  upvar $CMD_PROC cmd_proc
  set length [llength $event_proc]

#=======================================================================
set cmd_proc [lrange $event_proc 3 [expr $length - 2]]
}

#=======================================================================
proc PB_pps_ParseTclFile { POST_OBJECT EVENT_PROC_DATA } {
  upvar $POST_OBJECT post_object
  upvar $EVENT_PROC_DATA event_proc_data
  global env
  Post::ReadPostFiles $post_object dir def_file tcl_file
  set tcl_file_name "$dir/$tcl_file"
  set tcl_fid [open "$tcl_file_name" r]
  set proc_strt 0
  while { [gets $tcl_fid line] >= 0 }\
  {
   if { [string match "*proc*" $line] == 1} \
   {
    if { [string match "*PB_*" $line] == 1 || \
    [string match "*MOM*" $line] == 1 } \
    {
     set proc_strt 1
     set temp_line $line
     PB_com_RemoveBlanks temp_line
     set event_name [lindex $temp_line 1]
     unset temp_line
     lappend proc_data $prev_line
    }
    } elseif { $proc_strt == 1 && \
    [string compare "\}" $line] == 0} \
  {
   set proc_strt 2
   lappend proc_data $line
  }
  if { $proc_strt == 1} \
  {
   lappend proc_data $line
   } elseif { $proc_strt == 2} \
  {
   set event_proc_data($event_name) $proc_data
   unset proc_data
   set proc_strt  0
  }
  set prev_line $line
 }
}
