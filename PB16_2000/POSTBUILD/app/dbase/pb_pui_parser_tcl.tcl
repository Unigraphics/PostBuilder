#16

#=======================================================================
proc PB_pui_ReadPuiCreateObjs {OBJECT POST_OBJ} {
  upvar $OBJECT object
  upvar $POST_OBJ post_obj
  set event_handler 0
  set list_file_start 0
  set kinematic_var_start 0
  set master_sequence_start 0
  set gcode_start 0
  set mcode_start 0
  set glob_sequence_start 0
  set evt_ui_start 0
  set mom_sys_var_start 0
  set comp_blk_start 0
  set blk_mod_start 0
  set cycle_evt_start 0
  set cycle_com_evt_start 0
  set cycle_share_evt_start 0
  set sequence_start 0
  set sequence_word_status_start 0
  set prog_start_seq 0
  set oper_start_seq 0
  set tool_path_seq 0
  set tpth_ctrl_seq 0
  set tpth_mot_seq 0
  set tpth_cycle_seq 0
  set oper_end_seq 0
  set prog_end_seq 0
  set index 0
  while { [gets $File::($object,FilePointer) line] >= 0 }\
  {
   set line_length [string length $line]
   set last_char_test [string index $line [expr $line_length - 1]]
   if {[string compare $last_char_test \\] == 0}\
   {
    set line_with_space [string range $line 0 [expr $line_length - 2]]
    append temp_line [string trimleft $line_with_space " "]
    continue
    } elseif {[info exists temp_line]}\
   {
    append temp_line [string trimleft $line " "]
    set line $temp_line
    unset temp_line
   }
   switch $line\
   {
    "## POST EVENT HANDLER START"    {
     set event_handler 1
     continue
    }
    "## POST EVENT HANDLER END"      {
     set event_handler 0
     set pui_file_name $File::($object,FileName)
     set pui_dir [file dirname $pui_file_name]
     Post::SetPostFiles $post_obj pui_dir post_files
     unset post_files
     continue
    }
    "## LISTING FILE START"          {
     set list_file_start 1
     continue
    }
    "## LISTING FILE END"            {
     set list_file_start 0
     PB_lfl_CreateLfileObj obj_attr obj_list
     Post::ListFileObject $post_obj obj_list
     unset obj_attr
     continue
    }
    "## KINEMATIC VARIABLES START"   {
     set kinematic_var_start 1
     continue
    }
    "## KINEMATIC VARIABLES END"     {
     set kinematic_var_start 0
     set Post::($post_obj,mom_kin_var_list) \
     [array get mom_kin_var]
     set Post::($post_obj,def_mom_kin_var_list) \
     [array get mom_kin_var]
     continue
    }
    "## GCODES START"                {
     set gcode_start 1
     set gcd_ind 0
     continue
    }
    "## GCODES END"                  {
     set gcode_start 0
     Post::InitG-Codes $post_obj g_codes g_codes_desc
     continue
    }
    "## MCODES START"                {
     set mcode_start 1
     set mcd_ind 0
     continue
    }
    "## MCODES END"                  {
     set mcode_start 0
     Post::InitM-Codes $post_obj m_codes m_codes_desc
     continue
    }
    "## MASTER SEQUENCE START"       {
     set master_sequence_start 1
     set msq_indx 0
     continue
    }
    "## MASTER SEQUENCE END"         {
     set master_sequence_start 0
     Post::InitMasterSequence $post_obj msq_add_name \
     msq_word_param
     continue
    }
    "## CYCLE EVENT START"           {
     set cycle_evt_start 1
     continue
    }
    "## CYCLE EVENT END"             {
     set cycle_evt_start 0
     continue
    }
    "## BLOCK MODALITY START"        {
     set blk_mod_start 1
     continue
    }
    "## BLOCK MODALITY END"          {
     if {[info exists blk_mod_arr]} \
     {
      set Post::($post_obj,blk_mod_list) \
      [array get blk_mod_arr]
     } else \
     {
      set Post::($post_obj,blk_mod_list) ""
     }
     set blk_mod_start 0
     continue
    }
    "## COMPOSITE BLOCKS START"      {
     set comp_blk_start 1
     continue
    }
    "## COMPOSITE BLOCKS END"        {
     set comp_blk_start 0
     continue
    }
    "## SEQUENCE START"              {
     set glob_sequence_start 1
     continue
    }
    "## SEQUENCE END"                {
     set glob_sequence_start 0
     continue
    }
    "## EVENTS USER INTERFACE START" {
     set evt_ui_start 1
     set inx 0
     continue
    }
    "## EVENTS USER INTERFACE END"   {
     set evt_ui_start 0
     set Post::($post_obj,ui_evt_name_lis) \
     [array get ui_evt_name_arr]
     set Post::($post_obj,ui_evt_itm_grp_mem_lis) \
     [array get ui_evt_itm_grp_mem_arr]
     continue
    }
    "## MOM SYS VARIABLES START"     {
     set mom_sys_var_start 1
     set add_mom_indx 0
     continue
    }
    "## MOM SYS VARIABLES END"       {
     set mom_sys_var_start 0
     set Post::($post_obj,add_name_list) \
     [array get add_name_list]
     set Post::($post_obj,add_mom_var_list) \
     [array get add_mom_var_list]
     set add_mom_indx 0
     continue
    }
   }
   if { $event_handler} \
   {
    PB_com_RemoveBlanks line
    set file_type [lindex $line 0]
    set file_name [join [lrange $line 1 end] " "]
    switch $file_type \
    {
     def_file        { set post_files(def_file) $file_name }
     tcl_file        { set post_files(tcl_file) $file_name }
    }
   }
   if {$list_file_start}\
   {
    PB_com_RemoveBlanks line
    set Name [lindex $line 0]
    set Value [lindex $line 1]
    switch $Name\
    {
     Listfileflag               {set obj_attr(listfile)   $Value}
     Listfilename               {set obj_attr(fname)      $Value}
     Listfileflag_head          {set obj_attr(head)       $Value}
     Listfilelines              {set obj_attr(lines)      $Value}
     Listfilecolumn             {set obj_attr(column)     $Value}
     Listfileflag_oper          {set obj_attr(oper)       $Value}
     Listfileflag_tool          {set obj_attr(tool)       $Value}
     Listfileflag_start_path    {set obj_attr(start_path) $Value}
     Listfileflag_tool_chng     {set obj_attr(tool_chng)  $Value}
     Listfileflag_end_path      {set obj_attr(end_path)   $Value}
     Listfileflag_oper_time     {set obj_attr(oper_time)  $Value}
     Listfileflag_setup_time    {set obj_attr(setup_time) $Value}
     Listfileflag_warn          {set obj_attr(warn)       $Value}
     Listfileflag_lpt_ext       {set obj_attr(lpt_ext)    $Value}
     Listfileflag_review        {set obj_attr(review)     $Value}
     Listfileflag_group         {set obj_attr(group)      $Value}
     Listfileflag_ncfile_ext    {set obj_attr(ncfile_ext) $Value}
    }
   }
   if {$kinematic_var_start}\
   {
    set mom_kin_var([lindex $line 0]) [lindex $line 1]
   }
   if {$gcode_start}\
   {
    set g_codes($gcd_ind)  [lindex $line 0]
    set g_codes_desc($gcd_ind) [lindex $line 1]
    incr gcd_ind
   }
   if {$mcode_start}\
   {
    set m_codes($mcd_ind)  [lindex $line 0]
    set m_codes_desc($mcd_ind) [lindex $line 1]
    incr mcd_ind
   }
   if {$master_sequence_start}\
   {
    lappend msq_add_name [lindex $line 0]
    lappend msq_param [lindex $line 1] [lindex $line 2] [lindex $line 3]
    set msq_word_param([lindex $line 0]) $msq_param
    unset msq_param
    incr msq_indx
   }
   if {$blk_mod_start}\
   {
    set blk_mod_arr([lindex $line 0]) [lindex $line 1]
   }
   if {$comp_blk_start} \
   {
    set Post::($post_obj,comp_blk_list) $line
   }
   if {$cycle_evt_start} \
   {
    switch $line \
    {
     "#Cycle Common Block Start"              {
      set cycle_com_evt_start 1
      continue
     }
     "#Cycle Common Block End"                {
      set cycle_com_evt_start 0
      set Post::($post_obj,cyl_com_evt) \
      $cycle_common_evt
      continue
     }
     "#Cycle Block Share Common Block Start"  {
      set cycle_share_evt_start 1
      continue
     }
     "#Cycle Block Share Common Block End"    {
      set cycle_share_evt_start 0
      set Post::($post_obj,cyl_evt_sh_com_evt) \
      $cycle_shared_evts
      continue
     }
    }
    if {$cycle_com_evt_start} \
    {
     set cycle_common_evt $line
    }
    if {$cycle_share_evt_start} \
    {
     set cycle_shared_evts $line
    }
   }
   if {$glob_sequence_start}\
   {
    switch $line\
    {
     "#Program Start Sequence Start"     {
      set prog_start_seq 1
      continue
     }
     "#Program Start Sequence End"       {
      set prog_start_seq 0
      set Post::($post_obj,prog_start_evt_list) \
      [array get evt_name_arr]
      set Post::($post_obj,prog_start_evt_blk_list) \
      [array get evt_blk_arr]
      if { [info exists evt_name_arr] } \
      {
       unset evt_name_arr
       unset evt_blk_arr
      }
      continue
     }
     "#Operation Start Sequence Start"   {
      set oper_start_seq 1
      set index 0
      continue
     }
     "#Operation Start Sequence End"     {
      set oper_start_seq 0
      set Post::($post_obj,oper_start_evt_list) \
      [array get evt_name_arr]
      set Post::($post_obj,oper_start_evt_blk_list) \
      [array get evt_blk_arr]
      if { [info exists evt_name_arr] } \
      {
       unset evt_name_arr
       unset evt_blk_arr
      }
      continue
     }
     "##Tool Path Start"                 {
      set tool_path_seq 1
      continue
     }
     "##Tool Path End"                   {
      set tool_path_seq 0
      continue
     }
     "#Operation End Sequence Start"     {
      set oper_end_seq 1
      set index 0
      continue
     }
     "#Operation End Sequence End"       {
      set oper_end_seq 0
      set Post::($post_obj,oper_end_evt_list) \
      [array get evt_name_arr]
      set Post::($post_obj,oper_end_evt_blk_list) \
      [array get evt_blk_arr]
      if { [info exists evt_name_arr] } \
      {
       unset evt_name_arr
       unset evt_blk_arr
      }
      continue
     }
     "#Program End Sequence Start"       {
      set prog_end_seq 1
      set index 0
      continue
     }
     "#Program End Sequence End"         {
      set prog_end_seq 0
      set Post::($post_obj,prog_end_evt_list) \
      [array get evt_name_arr]
      set Post::($post_obj,prog_end_evt_blk_list) \
      [array get evt_blk_arr]
      if { [info exists evt_name_arr] } \
      {
       unset evt_name_arr
       unset evt_blk_arr
      }
      continue
     }
    }
    if {$prog_start_seq}\
    {
     set evt_name_arr($index) [lindex $line 0]
     set evt_blk_arr($index) [lindex $line 1]
     incr index
     } elseif {$oper_start_seq}\
    {
     set evt_name_arr($index) [lindex $line 0]
     set evt_blk_arr($index) [lindex $line 1]
     incr index
     } elseif {$tool_path_seq}\
    {
     switch $line\
     {
      "#Control Functions Start"          {
       set tpth_ctrl_seq 1
       set index 0
       continue
      }
      "#Control Functions End"            {
       set tpth_ctrl_seq 0
       set Post::($post_obj,tpth_ctrl_evt_list) \
       [array get evt_name_arr]
       set Post::($post_obj,tpth_ctrl_evt_blk_list) \
       [array get evt_blk_arr]
       if { [info exists evt_name_arr] } \
       {
        unset evt_name_arr
        unset evt_blk_arr
       }
       continue
      }
      "#Motions Start"                    {
       set tpth_mot_seq 1
       set index 0
       continue
      }
      "#Motions End"                      {
       set tpth_mot_seq 0
       set Post::($post_obj,tpth_mot_evt_list) \
       [array get evt_name_arr]
       set Post::($post_obj,tpth_mot_evt_blk_list) \
       [array get evt_blk_arr]
       if { [info exists evt_name_arr] } \
       {
        unset evt_name_arr
        unset evt_blk_arr
       }
       continue
      }
      "#Cycles Start"                      {
       set tpth_cycle_seq 1
       set index 0
       continue
      }
      "#Cycles End"                        {
       set tpth_cycle_seq 0
       set Post::($post_obj,tpth_cycle_evt_list) \
       [array get evt_name_arr]
       set Post::($post_obj,tpth_cycle_evt_blk_list) \
       [array get evt_blk_arr]
       if { [info exists evt_name_arr] } \
       {
        unset evt_name_arr
        unset evt_blk_arr
       }
       continue
      }
     }
     if {$tpth_ctrl_seq}\
     {
      set evt_name_arr($index) [lindex $line 0]
      set evt_blk_arr($index) [lindex $line 1]
      incr index
      } elseif {$tpth_mot_seq}\
     {
      set evt_name_arr($index) [lindex $line 0]
      set evt_blk_arr($index) [lindex $line 1]
      incr index
      } elseif {$tpth_cycle_seq}\
     {
      set evt_name_arr($index) [lindex $line 0]
      set evt_blk_arr($index) [lindex $line 1]
      incr index
     }
     } elseif {$oper_end_seq}\
    {
     set evt_name_arr($index) [lindex $line 0]
     set evt_blk_arr($index) [lindex $line 1]
     incr index
     } elseif {$prog_end_seq}\
    {
     set evt_name_arr($index) [lindex $line 0]
     set evt_blk_arr($index) [lindex $line 1]
     incr index
    }
   }
   if {$evt_ui_start}\
   {
    set ui_evt_name_arr($inx) [lindex $line 0]
    set ui_evt_itm_grp_mem_arr($inx) [lrange $line 1 end]
    incr inx
   }
   if {$mom_sys_var_start}\
   {
    set add_name_list($add_mom_indx) [lindex $line 0]
    set add_mom_var_list($add_mom_indx) [lrange $line 1 end]
    incr add_mom_indx
   }
  }
 }

#=======================================================================
proc PB_pui_WritePuiFile { OUTPUT_PUI_FILE } {
  upvar $OUTPUT_PUI_FILE pui_file
  global post_object
  global gPB
  set puifid [open "$pui_file" w]
  puts $puifid "## POSTBUILDER_VERSION=$gPB(Postbuilder_Version)"
  puts $puifid "#########################################################################"
  puts $puifid "#                                                                       #"
  puts $puifid "#  This is the POST UI FILE used to read and write the parameters       #"
  puts $puifid "#  associated with a spedific post processor.                           #"
  puts $puifid "#                                                                       #"
  puts $puifid "#  WARNING: The Syntax of the file should not be changed!!!             #"
  puts $puifid "#                                                                       #"
  puts $puifid "#########################################################################"
  puts $puifid "\n"
  Post::ReadPostOutputFiles $post_object dir out_pui_file def_file tcl_file
  puts $puifid "## POST EVENT HANDLER START"
  puts $puifid "def_file  $def_file"
  puts $puifid "tcl_file  $tcl_file"
  puts $puifid "## POST EVENT HANDLER END"
  puts $puifid "\n"
  set listfile_obj $Post::($post_object,list_obj_list)
  PB_pui_WriteListingFileData puifid listfile_obj
  array set mom_kin_var $Post::($post_object,mom_kin_var_list)
  PB_pui_WriteKinematicVariables puifid mom_kin_var
  array set g_codes $Post::($post_object,g_codes)
  array set g_codes_desc $Post::($post_object,g_codes_desc)
  puts $puifid "## GCODES START"
  PB_pui_WriteGMCodes puifid g_codes g_codes_desc
  puts $puifid "## GCODES END\n"
  array set m_codes $Post::($post_object,m_codes)
  array set m_codes_desc $Post::($post_object,m_codes_desc)
  puts $puifid "## MCODES START"
  PB_pui_WriteGMCodes puifid m_codes m_codes_desc
  puts $puifid "## MCODES END\n"
  set add_obj_list $Post::($post_object,add_obj_list)
  PB_pui_WriteMasterSeqData puifid add_obj_list
  set cyl_com_evt $Post::($post_object,cyl_com_evt)
  set cyl_sh_com_evt $Post::($post_object,cyl_evt_sh_com_evt)
  PB_pui_WriteCycleComSharedEvts puifid cyl_com_evt cyl_sh_com_evt
  set blk_obj_list $Post::($post_object,blk_obj_list)
  PB_pui_WriteBlockModality puifid  blk_obj_list
  PB_pui_WriteCompositeBlks puifid
  set seq_obj_list $Post::($post_object,seq_obj_list)
  PB_pui_WriteSeqEvents puifid seq_obj_list
  PB_pui_WriteEventUIData puifid seq_obj_list
  array set add_name_list $Post::($post_object,add_name_list)
  array set word_desc_arr $Post::($post_object,word_desc_array)
  array set word_mom_var $Post::($post_object,word_mom_var)
  array set mom_var_arr $Post::($post_object,mom_sys_var_list)
  PB_pui_WriteMOMVariables puifid add_name_list add_obj_list \
  word_desc_arr word_mom_var mom_var_arr
  close $puifid
 }

#=======================================================================
proc PB_pui_WriteListingFileData { PUIFID LISTFILE_OBJ } {
  upvar $PUIFID puifid
  upvar $LISTFILE_OBJ listfile_obj
  ListingFile::readvalue $listfile_obj obj_attr
  set arr_names [array names obj_attr]
  puts $puifid "## LISTING FILE START"
  foreach var_name $arr_names \
  {
   switch $var_name\
   {
    "listfile"   {puts $puifid "[format "%-30s %s" Listfileflag \
    $obj_attr(listfile)]"}
    "fname"      {puts $puifid "[format "%-30s %s" Listfilename \
    $obj_attr(fname)]"}
    "head"       {puts $puifid "[format "%-30s %s" Listfileflag_head \
    $obj_attr(head)]"}
    "lines"      {puts $puifid "[format "%-30s %s" Listfilelines \
    $obj_attr(lines)]"}
    "column"     {puts $puifid "[format "%-30s %s" Listfilecolumn \
    $obj_attr(column)]"}
    "oper"       {puts $puifid "[format "%-30s %s" Listfileflag_oper \
    $obj_attr(oper)]"}
    "tool"       {puts $puifid "[format "%-30s %s" Listfileflag_tool \
    $obj_attr(tool)]"}
    "start_path" {puts $puifid "[format "%-30s %s" Listfileflag_start_path \
    $obj_attr(start_path)]"}
    "tool_chng"  {puts $puifid "[format "%-30s %s" Listfileflag_tool_chng \
    $obj_attr(tool_chng)]"}
    "end_path"   {puts $puifid "[format "%-30s %s" Listfileflag_end_path \
    $obj_attr(end_path)]"}
    "oper_time"  {puts $puifid "[format "%-30s %s" Listfileflag_oper_time \
    $obj_attr(oper_time)]"}
    "setup_time" {puts $puifid "[format "%-30s %s" Listfileflag_setup_time \
    $obj_attr(setup_time)]"}
    "warn"       {puts $puifid "[format "%-30s %s" Listfileflag_warn \
    $obj_attr(warn)]"}
    "lpt_ext"    {puts $puifid "[format "%-30s %s" Listfileflag_lpt_ext \
    $obj_attr(lpt_ext)]"}
    "review"     {puts $puifid "[format "%-30s %s" Listfileflag_review \
    $obj_attr(review)]"}
    "group"      {puts $puifid "[format "%-30s %s" Listfileflag_group \
    $obj_attr(group)]"}
    "ncfile_ext" {puts $puifid "[format "%-30s %s" Listfileflag_ncfile_ext \
    $obj_attr(ncfile_ext)]"}
   }
  }
  puts $puifid "## LISTING FILE END\n"
 }

#=======================================================================
proc PB_pui_WriteKinematicVariables { PUIFID MOM_KIN_VAR } {
  upvar $PUIFID puifid
  upvar $MOM_KIN_VAR mom_kin_var
  set arr_names [array names mom_kin_var]
  puts $puifid "## KINEMATIC VARIABLES START"
  set arr_names [lsort -dictionary $arr_names]
  foreach kin_var $arr_names \
  {
   puts $puifid "[format "%-40s  %s" $kin_var $mom_kin_var($kin_var)]"
  }
  puts $puifid "## KINEMATIC VARIABLES END\n"
 }

#=======================================================================
proc PB_pui_WriteGMCodes { PUIFID CODE_VAR CODE_DESC } {
  upvar $PUIFID puifid
  upvar $CODE_VAR code_var
  upvar $CODE_DESC code_desc
  set no_of_codes [array size code_var]
  for {set count 0} {$count < $no_of_codes} {incr count} \
  {
   puts $puifid "[format "%-40s  %s" \"$code_var($count)\" \
   \"$code_desc($count)\"]"
  }
 }

#=======================================================================
proc PB_pui_WriteMasterSeqData { PUIFID ADD_OBJ_LIST } {
  upvar $PUIFID puifid
  upvar $ADD_OBJ_LIST add_obj_list
  puts $puifid "## MASTER SEQUENCE START"
  foreach add_obj $add_obj_list \
  {
   set add_name $address::($add_obj,add_name)
   address::readMseqAttr $add_obj mseq_attr
   puts $puifid "[format "%-15s   %s  %d  %s" $add_name \
   \"$mseq_attr(0)\" $mseq_attr(1) \"$mseq_attr(2)\"]"
   unset mseq_attr
  }
  puts $puifid "## MASTER SEQUENCE END\n"
 }

#=======================================================================
proc PB_pui_WriteCycleComSharedEvts { PUIFID CYL_COM_EVT CYL_SH_COM_EVT } {
  upvar $PUIFID puifid
  upvar $CYL_COM_EVT cyl_com_evt
  upvar $CYL_SH_COM_EVT cyl_sh_com_evt
  puts $puifid "## CYCLE EVENT START"
  puts $puifid "#Cycle Common Block Start"
  foreach evt_name $cyl_com_evt \
  {
   puts $puifid "\{$evt_name\}"
  }
  puts $puifid "#Cycle Common Block End\n"
  puts $puifid "#Cycle Block Share Common Block Start"
  puts $puifid "\{ \\"
   foreach evt_name [lindex $cyl_sh_com_evt 0] \
   {
    puts $puifid "  \{$evt_name\} \\"
   }
  puts $puifid "\}"
  puts $puifid "#Cycle Block Share Common Block End"
  puts $puifid "## CYCLE EVENT END\n"
 }

#=======================================================================
proc PB_pui_WriteBlockModality { PUIFID BLK_OBJ_LIST } {
  upvar $PUIFID puifid
  upvar $BLK_OBJ_LIST blk_obj_list
  puts $puifid "## BLOCK MODALITY START"
  foreach blk_obj $blk_obj_list \
  {
   block::readvalue $blk_obj blk_obj_attr
   set blk_mod_add_list ""
   foreach blk_elem_obj $blk_obj_attr(2) \
   {
    block_element::readvalue $blk_elem_obj blk_elem_obj_attr
    if { $blk_elem_obj_attr(4) } \
    {
     lappend blk_mod_add_list $address::($blk_elem_obj_attr(0),add_name)
    }
    unset blk_elem_obj_attr
   }
   if { $blk_mod_add_list != "" } \
   {
    puts $puifid "[format "%-30s" \{$blk_obj_attr(0)\}]  \{$blk_mod_add_list\}"
   }
   unset blk_obj_attr blk_mod_add_list
  }
  puts $puifid "## BLOCK MODALITY END\n"
 }

#=======================================================================
proc  PB_pui_WriteCompositeBlks { PUIFID } {
  upvar $PUIFID puifid
  PB_output_GetCompositeBlks comp_blk_list
  puts $puifid "## COMPOSITE BLOCKS START"
  if { $comp_blk_list != "" } \
  {
   foreach blk_obj $comp_blk_list \
   {
    lappend comp_blk_name_list $block::($blk_obj,block_name)
   }
   puts $puifid "\{$comp_blk_name_list\}"
  } else \
  {
   puts $puifid "\{\}"
  }
  puts $puifid "## COMPOSITE BLOCKS END\n"
 }

#=======================================================================
proc PB_pui_WriteSeqEvents { PUIFID SEQ_OBJ_LIST } {
  upvar $PUIFID puifid
  upvar $SEQ_OBJ_LIST seq_obj_list
  set no_seqs [llength $seq_obj_list]
  puts $puifid "## SEQUENCE START"
  for {set count 0} {$count <  $no_seqs} {incr count} \
  {
   PB_pui_WriteSeqHeader puifid count
   set seq_obj [lindex $seq_obj_list $count]
   PB_pui_WriteEventAndBlks puifid seq_obj
   PB_pui_WriteSeqFooter puifid count
  }
  puts $puifid "## SEQUENCE END\n"
 }

#=======================================================================
proc PB_pui_WriteSeqHeader { PUIFID INDEX } {
  upvar $PUIFID puifid
  upvar $INDEX index
  switch $index \
  {
   0 {
    puts $puifid "#Program Start Sequence Start"
   }
   1 {
    puts $puifid "#Operation Start Sequence Start"
   }
   2 {
    puts $puifid "##Tool Path Start"
    puts $puifid "#Control Functions Start"
   }
   3 {
    puts $puifid "#Motions Start"
   }
   4 {
    puts $puifid "#Cycles Start"
   }
   5 {
    puts $puifid "#Operation End Sequence Start"
   }
   6 {
    puts $puifid "#Program End Sequence Start"
   }
  }
 }

#=======================================================================
proc PB_pui_WriteEventAndBlks { PUIFID SEQ_OBJ } {
  upvar $PUIFID puifid
  upvar $SEQ_OBJ seq_obj
  global post_object
  set seq_events_list $sequence::($seq_obj,evt_obj_list)
  set cyl_sh_com_evt [lindex $Post::($post_object,cyl_evt_sh_com_evt) 0]
  foreach evt_obj $seq_events_list \
  {
   set evt_blk_list ""
   set event_name $event::($evt_obj,event_name)
   set evt_elem_list $event::($evt_obj,evt_elem_list)
   if { [lsearch $cyl_sh_com_evt $event_name] != -1} \
   {
    set share_event_flag 1
   } else \
   {
    set share_event_flag 0
   }
   foreach row_elem_list $evt_elem_list \
   {
    foreach elem_obj $row_elem_list \
    {
     set blk_obj $event_element::($elem_obj,block_obj)
     if { $share_event_flag }\
     {
      if {![string compare $block::($blk_obj,blk_owner) $event_name]} \
      {
       lappend row_blk_list $block::($blk_obj,block_name)
      }
     } else \
     {
      lappend row_blk_list $block::($blk_obj,block_name)
     }
    }
    if {[info exists row_blk_list]} \
    {
     lappend evt_blk_list $row_blk_list
     unset row_blk_list
    }
   }
   puts $puifid "[format "%-25s  %s" \{$event_name\} \{$evt_blk_list\}]"
  }
 }

#=======================================================================
proc  PB_pui_WriteSeqFooter { PUIFID INDEX } {
  upvar $PUIFID puifid
  upvar $INDEX index
  switch $index \
  {
   0 {
    puts $puifid "#Program Start Sequence End\n"
   }
   1 {
    puts $puifid "#Operation Start Sequence End\n"
   }
   2 {
    puts $puifid "#Control Functions End\n"
   }
   3 {
    puts $puifid "#Motions End\n"
   }
   4 {
    puts $puifid "#Cycles End"
    puts $puifid "##Tool Path End\n"
   }
   5 {
    puts $puifid "#Operation End Sequence End\n"
   }
   6 {
    puts $puifid "#Program End Sequence End"
   }
  }
 }

#=======================================================================
proc PB_pui_WriteEventUIData { PUIFID SEQ_OBJ_LIST } {
  upvar $PUIFID puifid
  upvar $SEQ_OBJ_LIST seq_obj_list
  puts $puifid "## EVENTS USER INTERFACE START"
  foreach seq_obj $seq_obj_list \
  {
   set seq_events_list $sequence::($seq_obj,evt_obj_list)
   foreach evt_obj $seq_events_list \
   {
    set evt_item_obj_list $event::($evt_obj,evt_itm_obj_list)
    if {[string compare $evt_item_obj_list ""] == 0} \
    {
     continue
    }
    puts $puifid "\{$event::($evt_obj,event_name)\} \\"
    set no_items [llength $evt_item_obj_list]
    set item_no 1
    foreach item_obj $evt_item_obj_list \
    {
     item::readvalue $item_obj item_obj_attr
     puts $puifid "     \{\{\"$item_obj_attr(0)\" $item_obj_attr(1) \
      $item_obj_attr(2)\} \\"
      set grp_no 1
      foreach grp_obj $item_obj_attr(3) \
      {
       item_group::readvalue $grp_obj grp_obj_attr
       puts $puifid "        \{\{\"$grp_obj_attr(0)\" $grp_obj_attr(1) \
        $grp_obj_attr(2)\} \\"
        set mem_no 1
        foreach mem_obj $grp_obj_attr(3) \
        {
         group_member::readvalue $mem_obj mem_obj_attr
         if {[llength $mem_obj_attr(5)] > 1} \
         {
          append tmp_3mem_out "\{$mem_obj_attr(5)\}"
         } else \
         {
          append tmp_3mem_out "$mem_obj_attr(5)"
         }
         set mem_output "          \{\"$mem_obj_attr(0)\" $mem_obj_attr(1) \
         $mem_obj_attr(2) $mem_obj_attr(3) $mem_obj_attr(4) $tmp_3mem_out\}"
         unset tmp_3mem_out
         if {$mem_no == $grp_obj_attr(1)} \
         {
         append temp_mem_output $mem_output "\}"
         set mem_output $temp_mem_output
         unset temp_mem_output
        }
        if {$mem_no == $grp_obj_attr(1) && \
        $grp_no == $item_obj_attr(1)} \
        {
        append temp_mem_output $mem_output "\}"
        set mem_output $temp_mem_output
        unset temp_mem_output
       }
       if {$mem_no == $grp_obj_attr(1) && $item_no == $no_items \
       && $grp_no == $item_obj_attr(1)} \
       {
        puts $puifid "      $mem_output"
       } else \
       {
        puts $puifid "      $mem_output \\"
       }
       incr mem_no
       unset mem_obj_attr
      }
      incr grp_no
      unset grp_obj_attr
     }
     incr item_no
     unset item_obj_attr
    }
   }
  }
  puts $puifid "## EVENTS USER INTERFACE END\n"
 }

#=======================================================================
proc PB_pui_WriteMOMVariables { PUIFID ADD_NAME_LIST ADD_OBJ_LIST \
  WORD_DESC_ARR WORD_MOM_VAR MOM_VAR_ARR } {
  upvar $PUIFID puifid
  upvar $ADD_NAME_LIST add_name_list
  upvar $ADD_OBJ_LIST add_obj_list
  upvar $WORD_DESC_ARR word_desc_arr
  upvar $WORD_MOM_VAR word_mom_var
  upvar $MOM_VAR_ARR mom_var_arr
  PB_adr_GetAddressNameList add_obj_list add_obj_name_list
  set no_of_adds [array size add_name_list]
  set default_name [list "New_Address" "PB_Dummy" "PB_Tcl_Var" "Command" \
  "Operator Message" "PB_Spindle"]
  foreach name $default_name \
  {
   lappend add_obj_name_list $name
  }
  puts $puifid "## MOM SYS VARIABLES START"
  foreach add_name $add_obj_name_list \
  {
   puts $puifid "\{$add_name\} \\"
   set word_flag 0
   for {set add_no 0} {$add_no < $no_of_adds} {incr add_no} \
   {
    if { $add_name_list($add_no) == "$add_name" } \
    {
     set no_mom_var [llength $word_mom_var($add_name_list($add_no))]
     set word_mom_list $word_mom_var($add_name_list($add_no))
     set word_flag 1
     break
    }
   }
   set no_mom_var 0
   if { [info exists word_mom_var($add_name)] } \
   {
    set no_mom_var [llength $word_mom_var($add_name)]
    for {set count 0} {$count < $no_mom_var} {incr count} \
    {
     set mom_var [lindex $word_mom_var($add_name) $count]
     if { $add_name == "Command" || $add_name == "Operator Message" } \
     {
      set var_value ""
      set var_desc [lindex $word_desc_arr($add_name) $count]
     } else \
     {
      set var_value $mom_var_arr($mom_var)
      if { [string first $var_value \\] != -1} \
      {
       set var_split [split $var_value \\]
       set var_value [join $var_split "\\\\"]
      }
      set var_desc [lindex $word_desc_arr($add_name) $count]
     }
     if {$count < [expr $no_mom_var -1]} \
     {
      puts $puifid "      \{\"$mom_var\" \"$var_value\" \"$var_desc\"\} \\"
     } else \
     {
      puts $puifid "      \{\"$mom_var\" \"$var_value\" \"$var_desc\"\}"
     }
    }
   }
   if { $no_mom_var == 0 } \
   {
    puts $puifid "      \{\"\" \"\" \"\"\}"
   }
  }
  puts $puifid "## MOM SYS VARIABLES END"
 }

#=======================================================================
proc PB_pui_PartConversion { CUR_POST_OBJ OLD_POST_OBJ } {
  upvar $CUR_POST_OBJ cur_post_obj
  upvar $OLD_POST_OBJ old_post_obj
  Post::ReadPostFiles $old_post_obj old_pui_dir old_def old_tcl
  set post_files(def_file) $old_def
  set post_files(tcl_file) $old_tcl
  Post::SetPostFiles $cur_post_obj old_pui_dir post_files
  set old_list_obj $Post::($old_post_obj,list_obj_list)
  ListingFile::readvalue $old_list_obj old_list_obj_attr
  set old_list_names $ListingFile::($old_list_obj,arr_names)
  set cur_list_obj $Post::($cur_post_obj,list_obj_list)
  ListingFile::readvalue $cur_list_obj cur_list_obj_attr
  set cur_list_names $ListingFile::($cur_list_obj,arr_names)
  foreach elem $old_list_names \
  {
   if { [lsearch $cur_list_names $elem] != -1 } \
   {
    set cur_list_obj_attr($elem) $old_list_obj_attr($elem)
   }
  }
  ListingFile::setvalue_from_pui $cur_list_obj cur_list_obj_attr
  array set old_kin_var $Post::($old_post_obj,mom_kin_var_list)
  array set cur_kin_var $Post::($cur_post_obj,mom_kin_var_list)
  set name_list [array names old_kin_var]
  foreach kin_var $name_list \
  {
   if { [info exists cur_kin_var($kin_var)] } \
   {
    switch $kin_var \
    {
     "mom_kin_4th_axis_plane" -
     "mom_kin_5th_axis_plane" \
     {
      set old_kin_var($kin_var) [string toupper $old_kin_var($kin_var)]
     }
    }
    set cur_kin_var($kin_var) $old_kin_var($kin_var)
   }
  }
  set Post::($cur_post_obj,mom_kin_var_list) [array get cur_kin_var]
  set Post::($cur_post_obj,def_mom_kin_var_list) [array get cur_kin_var]
  array set old_msq_word_param $Post::($old_post_obj,msq_word_param)
  set msq_add_name $Post::($old_post_obj,msq_add_name)
  Post::InitMasterSequence $cur_post_obj msq_add_name old_msq_word_param
  array set blk_mod_arr $Post::($old_post_obj,blk_mod_list)
  set Post::($cur_post_obj,,blk_mod_list) [array get blk_mod_arr]
  set Post::($cur_post_obj,comp_blk_list) \
  $Post::($old_post_obj,comp_blk_list)
  set seq_name_list {"prog_start" "oper_start" "oper_end" "prog_end" \
  "tpth_ctrl" "tpth_mot" "tpth_cycle"}
  foreach seq_n $seq_name_list \
  {
   set evt_list ${seq_n}_evt_list
   set blk_list ${seq_n}_evt_blk_list
   array set old_event_name_arr $Post::($old_post_obj,$evt_list)
   array set old_event_blk_arr $Post::($old_post_obj,$blk_list)
   array set cur_event_name_arr $Post::($cur_post_obj,$evt_list)
   array set cur_event_blk_arr $Post::($cur_post_obj,$blk_list)
   set no_events [array size cur_event_name_arr]
   for { set count 0 } { $count < $no_events } { incr count } \
   {
    set event_name $cur_event_name_arr($count)
    set evt_indx [lsearch $Post::($old_post_obj,$evt_list) $event_name]
    if { $evt_indx != -1 } \
    {
     set act_indx [lindex $Post::($old_post_obj,$evt_list) \
     [expr $evt_indx -1]]
     set cur_event_blk_arr($count) $old_event_blk_arr($act_indx)
    } else \
    {
     set cur_event_blk_arr($count) ""
    }
   }
   set Post::($cur_post_obj,$evt_list) [array get cur_event_name_arr]
   set Post::($cur_post_obj,$blk_list) [array get cur_event_blk_arr]
   unset cur_event_name_arr cur_event_blk_arr
   unset old_event_name_arr old_event_blk_arr
  }
  array set cur_add_name_arr $Post::($cur_post_obj,add_name_list)
  array set cur_add_mom_var_arr $Post::($cur_post_obj,add_mom_var_list)
  array set old_add_name_arr $Post::($old_post_obj,add_name_list)
  array set old_add_mom_var_arr $Post::($old_post_obj,add_mom_var_list)
  set no_old_adds [array size old_add_name_arr]
  set no_cur_adds [array size cur_add_name_arr]
  for { set count 0 } { $count < $no_old_adds } { incr count } \
  {
   set add_name $old_add_name_arr($count)
   set old_add_var_list $old_add_mom_var_arr($count)
   set cur_add_var_list ""
   for { set add_indx 0 } { $add_indx < $no_cur_adds } { incr add_indx } \
   {
    if { $cur_add_name_arr($add_indx) == "$add_name" } \
    {
     set cur_add_var_list $cur_add_mom_var_arr($add_indx)
     break
    }
   }
   if { $add_name == "Command" || $add_name == "Operator Message" || \
   $add_name == "PB_Spindle" } \
   {
    set cur_add_var_list ""
   }
   foreach var_line $old_add_var_list \
   {
    set var [lindex $var_line 0]
    set value [lindex $var_line 1]
    set cur_line_index 0
    set old_var_flag 0
    foreach cur_var_line $cur_add_var_list \
    {
     if { [string compare $var [lindex $cur_var_line 0]] == 0 } \
     {
      set cur_var_line [lreplace $cur_var_line 1 1 $value]
      set cur_add_var_list [lreplace $cur_add_var_list \
      $cur_line_index $cur_line_index $cur_var_line]
      set old_var_flag 1
      break
     }
     incr cur_line_index
    }
    if { $old_var_flag == 0 } \
    {
     lappend cur_add_var_list $var_line
    }
   }
   if { $cur_add_var_list != "" } \
   {
    set cur_add_mom_var_arr($add_indx) $cur_add_var_list
   }
  }
  set add_size [array size cur_add_name_arr]
  foreach mseq_add $msq_add_name \
  {
   set cur_add_arr_list [array get cur_add_name_arr]
   if { [lsearch $cur_add_arr_list $mseq_add] == -1 } \
   {
    set cur_add_name_arr($add_size) $mseq_add
    set cur_add_mom_var_arr($add_size) [list "" "" ""]
    incr add_size
   }
  }
  set Post::($cur_post_obj,add_name_list) [array get cur_add_name_arr]
  set Post::($cur_post_obj,add_mom_var_list) [array get cur_add_mom_var_arr]
  unset cur_add_name_arr cur_add_mom_var_arr
  unset old_add_name_arr old_add_mom_var_arr
 }