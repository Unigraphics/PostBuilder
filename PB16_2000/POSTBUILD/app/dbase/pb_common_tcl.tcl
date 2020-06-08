#25

#=======================================================================
proc PB_com_SetDefaultName {NAME_LIST OBJ_ATTR} {
  upvar $NAME_LIST name_list
  upvar $OBJ_ATTR obj_attr
  set count [llength $name_list]
  set dindex 1
  set dflag 0
  set match_flag 0
  set obj_name $obj_attr(0)
  if { $count == 0}\
  {
   if { $obj_attr(0) == "" } \
   {
    set obj_attr(0) DEFAULT
   }
  } else\
  {
   set dindex 0
   PB_com_ValidateName name_list obj_attr(0) dindex
   if {$dindex} \
   {
    append name $obj_attr(0) _ $dindex
    set obj_attr(0) $name
    unset name
   }
  }
 }

#=======================================================================
proc PB_com_ValidateName {NAME_LIST DEF_NAME DINDEX} {
  upvar $NAME_LIST name_list
  upvar $DEF_NAME def_name
  upvar $DINDEX inx
  set count [llength $name_list]
  if {$inx} \
  {
   append act_name $def_name _ $inx
  } else \
  {
   set act_name $def_name
  }
  for {set i 0} {$i < $count} {incr i}\
  {
   set fmt_name [lindex $name_list $i]
   if { [string compare $act_name $fmt_name] == 0}\
   {
    incr inx
    PB_com_ValidateName name_list def_name inx
   } else\
   {
    continue
   }
  }
 }

#=======================================================================
proc PB_com_RemoveBlanks {line} {
  upvar $line line_wob
  set line_wob [split $line_wob]
  set blank_index [lsearch $line_wob \0]
  while { $blank_index >= 0}\
  {
   set line_wob [lreplace $line_wob $blank_index $blank_index]
   set blank_index [lsearch $line_wob \0]
  }
 }

#=======================================================================
proc PB_com_GetModEvtBlkName {INP_NAME} {
  upvar $INP_NAME inp_name
  set temp_name [split $inp_name ""]
  set first_chr [string toupper [lindex $temp_name 0]]
  set temp_name [lreplace $temp_name 0 0 $first_chr]
  set und_sc_ind [lsearch $temp_name "_"]
  while { $und_sc_ind >= 0}\
  {
   set temp_name [lreplace $temp_name $und_sc_ind $und_sc_ind " "]
   set next_chr [string toupper [lindex $temp_name [expr $und_sc_ind + 1]]]
   set temp_name [lreplace $temp_name [expr $und_sc_ind + 1] \
   [expr $und_sc_ind + 1] $next_chr]
   set und_sc_ind [lsearch $temp_name "_"]
  }
  set inp_name [join $temp_name ""]
 }

#=======================================================================
proc PB_com_RetObjFrmName {OBJ_NAME OBJ_LIST RET_CODE} {
  upvar $OBJ_NAME obj_name
  upvar $OBJ_LIST obj_list
  upvar $RET_CODE ret_code
  if {[info exists obj_list] != 0}\
  {
   foreach object $obj_list\
   {
    set ClassName [string trim [classof $object] ::]
    switch $ClassName\
    {
     format    {set CheckName $format::($object,for_name)}
     address   {set CheckName $address::($object,add_name)}
     block     {set CheckName $block::($object,block_name)}
     event     {set CheckName $event::($object,event_name)}
     sequence  {set CheckName $sequence::($object,seq_name)}
     command   {set CheckName $command::($object,name)}
    }
    if { [string compare $CheckName $obj_name] == 0 }\
    {
     set ret_code $object
     break
    } else\
    {
     set ret_code 0
    }
   }
  }
 }

#=======================================================================
proc PB_com_WordSubNamesDesc {POST_OBJECT WORD_SUBNAMES_DESC_ARRAY \
  WORD_MOM_VAR MOM_SYS_ARR} {
  upvar $POST_OBJECT post_object
  upvar $WORD_SUBNAMES_DESC_ARRAY word_subnames_desc_array
  upvar $WORD_MOM_VAR word_mom_var
  upvar $MOM_SYS_ARR mom_sys_arr
  array set add_name_arr $Post::($post_object,add_name_list)
  array set add_mom_var_arr $Post::($post_object,add_mom_var_list)
  set no_adds [array size add_name_arr]
  for {set count 0} {$count < $no_adds} {incr count} \
  {
   set add_name $add_name_arr($count)
   set word_var_list ""
   set word_subnames_list ""
   foreach line $add_mom_var_arr($count) \
   {
    if { [lindex $line 0] != "" } \
    {
     set mom_sys_arr([lindex $line 0]) [lindex $line 1]
     lappend word_var_list [lindex $line 0]
     lappend word_subnames_list [lindex $line 2]
    }
   }
   set word_mom_var($add_name) $word_var_list
   set word_subnames_desc_array($add_name) $word_subnames_list
  }
 }

#=======================================================================
proc PB_com_GetAppTxtForMultiCharLdrs {APP_TEXT ADD_NAME ACT_APP_TEXT} {
  upvar $APP_TEXT app_text
  upvar $ADD_NAME add_name
  upvar $ACT_APP_TEXT act_app_text
  global post_object
  set act_app_text $app_text
  set add_obj_list $Post::($post_object,add_obj_list)
  PB_com_RetObjFrmName add_name add_obj_list ret_code
  if {$ret_code != 0}\
  {
   set add_leader $address::($ret_code,add_leader)
   set add_srch [string first $add_leader $app_text]
   if {$add_srch != -1}\
   {
    set str_len [string length $add_leader]
    set act_app_text [string range $app_text $str_len end]
   }
  }
 }

#=======================================================================
proc PB_com_ValidateImgName {WORD_IMG_NAME WORD_APP_TEXT} {
  upvar $WORD_IMG_NAME word_img_name
  upvar $WORD_APP_TEXT word_app_text
  switch $word_img_name\
  {
   A - B - C - D - E -
   F - G - H - I - J -
   K - L - M - N - O -
   P - Q - R - S - T -
   U - V - W - X - Y -
   Z       {}
   default {
    append temp_app_text $word_img_name $word_app_text
    set word_app_text $temp_app_text
    set word_img_name blank
    unset temp_app_text
   }
  }
 }

#=======================================================================
proc PB_com_ReadPuiFile {PuiFileName PuiFileID POST_OBJ} {
  upvar $PuiFileName FileName
  upvar $PuiFileID FileId
  upvar $POST_OBJ post_obj
  set post_obj [new Post $FileName]
  set pui_file_obj [new ParseFile $FileId]
  File::OpenFileRead $pui_file_obj $FileName
  ParseFile::ParsePuiFile $pui_file_obj post_obj
  File::CloseFile $pui_file_obj
  delete $pui_file_obj
 }

#=======================================================================
proc PB_com_ReadUdeFile {CDL_FILE_NAME CDL_FILE_ID POST_OBJ} {
  upvar $CDL_FILE_NAME cdl_file_name
  upvar $CDL_FILE_ID cdl_file_id
  upvar $POST_OBJ post_obj
  set ude_file_obj [new ParseFile $cdl_file_id]
  File::OpenFileRead $ude_file_obj $cdl_file_name
  ParseFile::ParseUdeFile $ude_file_obj post_obj
  File::CloseFile $ude_file_obj
  delete $ude_file_obj
 }

#=======================================================================
proc PB_com_ReadDfltDefFile {DefFileName FILEID POST_OBJ} {
  upvar $DefFileName FileName
  upvar $FILEID FileId
  upvar $POST_OBJ post_obj
  global ListObjectList
  global ListObjectAttr
  set FObjIndex 0
  set AObjIndex 0
  set BObjIndex 0
  set pobj [new ParseFile $FileId]
  set Post::($post_obj,def_parse_obj) $pobj
  ParseFile::ParseDefFile $pobj $FileName
  ParseFile::ParseWordSep $pobj
  ParseFile::ParseEndOfLine $pobj
  ParseFile::ParseSequence $pobj
  ParseFile::ParseFormat $pobj FormatObjList
  ParseFile::ParseAddress $pobj post_obj AddObjList LfileAddObjList \
  FormatObjList RapAddList ZeroFmt
  PB_adr_SortAddresses AddObjList
  Post::SetRapAdd $post_obj RapAddList
  Post::SetZeroFormat $post_obj ZeroFmt
  PB_com_SortObjectsByNames FormatObjList
  Post::SetObjListasAttr $post_obj FormatObjList
  Post::SetObjListasAttr $post_obj AddObjList
  ListingFile::SetLfileAddObjList $post_obj LfileAddObjList
  Post::WordAddNamesSubNamesDesc $post_obj
  Post::SetDefMasterSequence $post_obj AddObjList
  ParseFile::ParseBlockTemp $pobj BlockObjList AddObjList post_obj
  PB_com_SortObjectsByNames BlockObjList
  Post::SetObjListasAttr $post_obj BlockObjList
  PB_blk_RetDisVars BlockObjList BlockNameList WordDescArray post_obj
  set ListObjectList $Post::($post_obj,list_obj_list)
  PB_lfl_RetDisVars ListObjectList ListObjectAttr
 }

#=======================================================================
proc PB_com_SortObjectsByNames { OBJ_LIST } {
  upvar $OBJ_LIST obj_list
  set no_elements [llength $obj_list]
  set object [lindex $obj_list 0]
  for {set ii 0} {$ii < [expr $no_elements - 1]} {incr ii} \
  {
   for {set jj [expr $ii + 1]} {$jj < $no_elements} {incr jj} \
   {
    set ii_obj [lindex $obj_list $ii]
    set ClassName [string trim [classof $ii_obj] ::]
    switch $ClassName\
    {
     format    {set ii_name $format::($ii_obj,for_name)}
     address   {set ii_name $address::($ii_obj,add_name)}
     block     {set ii_name $block::($ii_obj,block_name)}
     event     {set ii_name $event::($ii_obj,event_name)}
     sequence  {set ii_name $sequence::($ii_obj,seq_name)}
    }
    set jj_obj [lindex $obj_list $jj]
    set ClassName [string trim [classof $jj_obj] ::]
    switch $ClassName\
    {
     format    {set jj_name $format::($jj_obj,for_name)}
     address   {set jj_name $address::($jj_obj,add_name)}
     block     {set jj_name $block::($jj_obj,block_name)}
     event     {set jj_name $event::($jj_obj,event_name)}
     sequence  {set jj_name $sequence::($jj_obj,seq_name)}
    }
    if { [string compare $ii_name $jj_name] > 0} \
    {
     set obj_list [lreplace $obj_list $ii $ii $jj_obj]
     set obj_list [lreplace $obj_list $jj $jj $ii_obj]
    }
   }
  }
 }

#=======================================================================
proc PB_com_MapMOMVariable { MOM_SYS_VAR_ARR ADD_OBJ BLK_ELEM_MOM_VAR \
  MOM_VAR_VALUE } {
  upvar $MOM_SYS_VAR_ARR mom_sys_var_arr
  upvar $ADD_OBJ add_obj
  upvar $BLK_ELEM_MOM_VAR blk_elem_mom_var
  upvar $MOM_VAR_VALUE mom_var_value
  set add_name $address::($add_obj,add_name)
  if {[string compare $add_name "Text"] == 0} \
  {
   set mom_var_value $blk_elem_mom_var
  } else \
  {
   global post_object
   set mom_var_names [array names mom_sys_var_arr]
   set var_index [lsearch $mom_var_names $blk_elem_mom_var]
   if { $var_index != -1 } \
   {
    set mom_var_value $mom_sys_var_arr($blk_elem_mom_var)
    if { [string match \$mom* $mom_var_value] } \
    {
     set mom_var_value $mom_sys_var_arr($mom_var_value)
     } elseif { [string match "*+*" $mom_var_value] || \
    [string match "*-*" $mom_var_value] } \
    {
     set mom_var_value ""
    }
   } else \
   {
    if { [string match \$* $blk_elem_mom_var] } \
    {
     set mom_var_value ""
    } else \
    {
     set mom_var_value $blk_elem_mom_var
    }
   }
  }
 }

#=======================================================================
proc PB_com_GetMachAxisType { KINEMATIC_VARIABLES MACH_TYPE AXISOPTION } {
  upvar $KINEMATIC_VARIABLES kinematic_variables
  upvar $MACH_TYPE mach_type
  upvar $AXISOPTION axisoption
  switch $kinematic_variables(mom_kin_machine_type) \
  {
   "3_axis_mill"       {
    set mach_type "Mill"
    set axisoption "3"
   }
   "4_axis_head"       {
    set mach_type "Mill"
    set axisoption "4H"
   }
   "4_axis_table"      {
    set mach_type "Mill"
    set axisoption "4T"
   }
   "5_axis_dual_table" {
    set mach_type "Mill"
    set axisoption "5TT"
   }
   "5_axis_dual_head"  {
    set mach_type "Mill"
    set axisoption "5HH"
   }
   "5_axis_head_table" {
    set mach_type "Mill"
    set axisoption "5HT"
   }
   "lathe"             {
    set mach_type "Lathe"
    set axisoption "2"
   }
   "2_axis_wedm"       {
    set mach_type "Wire EDM"
    set axisoption "2"
   }
   "4_axis_wedm"       {
    set mach_type "Wire EDM"
    set axisoption "4"
   }
   "mill_turn"         {
    set mach_type "Mill/Turn"
    set axisoption "3axis"
   }
  }
 }

#=======================================================================
proc PB_com_GetPrefixOfEvent { EVENT_NAME PREFIX } {
  upvar $EVENT_NAME event_name
  upvar $PREFIX prefix
  switch $event_name \
  {
   "Start of Program"   -
   "Auto Tool Change"   -
   "Manual Tool Change" -
   "Start Move"         -
   "Approach Move"      -
   "Engage Move"        -
   "First Cut"          -
   "Inch Metric Mode"   -
   "Cycle Parameters"   -
   "Return Move"        -
   "First Linear Move"  -
   "Feedrates"          {
    set prefix "PB"
   }
   default              {
    set prefix "MOM"
   }
  }
 }
