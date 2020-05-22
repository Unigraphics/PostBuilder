#20
global gPB
set gPB(tol) 0.000001

#=======================================================================
proc  PB_val_is_zero { s } {
  global gPB
  if { [expr abs($s) <= $gPB(tol)] } { return 1 } else { return 0 }
 }

#=======================================================================
proc  PB_val_is_equal { s t } {
  global gPB
  return [PB_val_is_zero [expr $s - $t]]
 }

#=======================================================================
proc  PB_val_is_ge { s t } {
  global gPB
  if { [expr $s > ($t - $gPB(tol))] } { return 1 } else { return 0 }
 }

#=======================================================================
proc  PB_val_is_gt { s t } {
  global gPB
  if { [expr $s > ($t + $gPB(tol))] } { return 1 } else { return 0 }
 }

#=======================================================================
proc  PB_val_is_le { s t } {
  global gPB
  if { [expr $s < ($t + $gPB(tol))] } { return 1 } else { return 0 }
 }

#=======================================================================
proc  PB_val_is_lt { s t } {
  global gPB
  if { [expr $s < ($t - $gPB(tol))] } { return 1 } else { return 0 }
 }

#=======================================================================
proc  PB_val_comp { s t } {
  if [PB_val_is_equal $s $t] { return 0 }
  if [PB_val_is_lt $s $t] { return -1 }
  if [PB_val_is_gt $s $t] { return 1 }
 }

#=======================================================================
proc PB_com_unset_var { ARR } {
  upvar $ARR arr
  global tcl_version
  if [array exists arr] {
   if [expr $tcl_version < 8.4] {
    foreach a [array names arr] {
     if [info exists arr($a)] {
      unset arr($a)
     }
    }
    unset arr
    } else {
    array unset arr
   }
  }
  if [info exists arr] {
   unset arr
  }
 }

#=======================================================================
proc PB_com_DeleteObject { obj_id args } {
  if [PB_com_HasObjectExisted $obj_id] {
   if [catch {eval delete $obj_id} res] {
    UI_PB_log_msg $res
   }
  }
 }

#=======================================================================
proc PB_com_TidyIndexedCoupletsList { vlist } {
  set old_var ""
  set j 0
  set var_list [list]
  for {set i 0} {$i < [llength $vlist]} {incr i 2} {
   set idx [lindex $vlist $i]
   set var [lindex $vlist [expr $i + 1]]
   if { ![string match $old_var $var] } {
    lappend var_list $j $var
    set old_var $var
    incr j
   }
  }
  return $var_list
 }

#=======================================================================
proc PB_com_GetFmtMaxVal { fmt } {
  format::readvalue $fmt obj_attr
  set max_string ""
  for { set i 0 } { $i < $obj_attr(5) } { incr i } {
   set max_string "${max_string}9"
  }
  for { set i 0 } { $i < $obj_attr(6) } { incr i } {
   set max_string "${max_string}."
  }
  for { set i 0 } { $i < $obj_attr(7) } { incr i } {
   set max_string "${max_string}9"
  }
  return $max_string
 }

#=======================================================================
proc PB_com_AddEscapeCharToString { S } {
  upvar $S s
  set string_modified 0
  set idx [string first "\\" $s]
  set s_new ""
  set s3 $s
  while { $idx >= 0 } {
   set exp [string index $s3 [expr $idx + 1]]
   set add_escape 1
   if { $exp  ==  "\!"   || \
    $exp  ==  "\#"   || \
    $exp  ==  "\&"   || \
    $exp  ==  "\'"   || \
    $exp  ==  "\."   || \
    $exp  ==  "\;"   || \
    $exp  ==  "\<"   || \
    $exp  ==  "\="   || \
    $exp  ==  "\>"   || \
    $exp  ==  "\?"   || \
    $exp  ==  "\@"   || \
    $exp  ==  "\["   || \
    $exp  ==  "\\"   || \
    $exp  ==  "\]"   || \
    $exp  ==  "\^"   || \
    $exp  ==  "\`"   || \
    $exp  ==  "\|"   || \
    $exp  ==  "\~"   || \
    $exp  ==  " "   || \
    $exp  ==  "b"   || \
    $exp  ==  "n"   || \
    $exp  ==  "t"    } {
    set add_escape 0
   }
   set s1 [string range $s3 0 $idx]
   set s2 [string index $s3 [expr $idx + 1]]
   set s3 [string range $s3 [expr $idx + 2] end]
   if $add_escape {
    set s1 $s1\\
    set string_modified 1
   }
   set s_new $s_new$s1$s2
   set idx [string first "\\" $s3]
  }
  set s_new "$s_new$s3"
  set s $s_new
  return $string_modified
 }

#=======================================================================
proc PB_com_GetNextObjName { obj_name class } {
  global post_object
  if { ![string match "format" $class]   && \
   ![string match "address" $class]  && \
   ![string match "block" $class]    && \
   ![string match "event" $class]    && \
   ![string match "sequence" $class] && \
   ![string match "command" $class] } {
   UI_PB_debug_ForceMsg "Class $class does not exist."
   return ""
   } else {
   Post::GetObjList $post_object $class obj_list
  }
  set name_found $obj_name
  set name_list [list]
  if [info exists obj_list] \
  {
   foreach object $obj_list \
   {
    switch $class \
    {
     format    { set CheckName $format::($object,for_name) }
     address   { set CheckName $address::($object,add_name) }
     block     { set CheckName $block::($object,block_name) }
     event     { set CheckName $event::($object,event_name) }
     sequence  { set CheckName $sequence::($object,seq_name) }
     command   { set CheckName $command::($object,name) }
    }
    if [string match "$obj_name*" $CheckName] \
    {
     lappend name_list $CheckName
    }
   }
  }
  set start_index [expr [string length $obj_name] + 1]
  set new_name_list [list]
  if [llength $name_list] {
   set name_list [lsort -ascii $name_list]
   foreach name $name_list {
    set tail [string range $name $start_index end]
    if { $tail == "" } {
     lappend new_name_list $name
     } elseif { ![catch { expr $tail }] } {
     lappend new_name_list $name
    }
   }
  }
  if [llength $new_name_list] {
   set name_list [lsort -ascii $new_name_list]
   set last_name [lindex $name_list end]
   if { [string length $last_name] > [string length $obj_name] } {
    set tail [string range $last_name $start_index end]
    set tail [expr $tail + 1]
    set name_found ${obj_name}_$tail
    } else {
    set name_found ${obj_name}_1
   }
  }
  return $name_found
 }

#=======================================================================
proc PB_com_HasObjectExisted { obj_id args } {
  if [info exists ::stooop::fullClass($obj_id)] {
   return 1
   } else {
   return 0
  }
 }

#=======================================================================
proc PB_com_MergeListsOfMultiples { n_elmt args } {
  set j 0
  for {set i 0} {$i < [llength $args]} {incr i} \
  {
   foreach e [lindex $args $i] \
   {
    set name [lindex $e 0]
    if { ![info exists arr($name,index)] } \
    {
     set arr($name,index) $j
     set arr($j,name) $name
     for {set k 1} {$k < $n_elmt} {incr k} {
      set arr($j,$k) [lindex $e $k]
     }
     incr j
     } else {
     set jj $arr($name,index)
     for {set k 1} {$k < $n_elmt} {incr k} {
      set arr($jj,$k) [lindex $e $k]
     }
    }
   }
  }
  set res_list [list]
  for {set i 0} {$i < $j} {incr i} \
  {
   set lm [list \"$arr($i,name)\"]
   for {set k 1} {$k < $n_elmt} {incr k} \
   {
    lappend lm \"[PB_output_EscapeSpecialControlChar $arr($i,$k)]\"
   }
   lappend res_list [join $lm " "]
  }
  return $res_list
 }

#=======================================================================
proc ladd { list index elmt_list args } {
  if [info exists list] \
  {
   set new_list $list
   if { [llength $args] && [lindex $args 0] == "no_dup" } \
   {
    set new_list [ltidy $list]
    foreach e $elmt_list \
    {
     set i [lsearch $new_list $e]
     if { $i >= 0 } \
     {
      set new_list [lreplace $new_list $i $i]
     }
    }
   }
  } else \
  {
   set index end
  }
  if { $index == "end" } \
  {
   lappend new_list $elmt_list
  } else \
  {
   set new_list [linsert $new_list $index $elmt_list]
  }
  return $new_list
 }

#=======================================================================
proc ltidy { list } {
  set new_list ""
  set i 0 ;# Index from the list
  foreach e $list \
  {
   if { ![info exists elmt("$e")] } \
   {
    set elmt("$e") "$i"
    lappend new_list $e
   }
   incr i
  }
  return $new_list
 }

#=======================================================================
proc lmerge { args } {
  for {set i 0} {$i < [llength $args]} {incr i} \
  {
   foreach e [lindex $args $i] \
   {
    set dummy_arr($e) 0
   }
  }
  return [array names dummy_arr]
 }

#=======================================================================
proc PB_com_MergeLists { args } {
  return [join [lmerge $args]]
 }

#=======================================================================
proc PB_com_CheckOpenBracesInLine { LINE OPEN_FLAG } {
  upvar $LINE line
  upvar $OPEN_FLAG open_flag
  set open_flag 0
  if 0 {
   if {[string match "*\{*" $line] == 1} \
    {
     set open_flag 1
    }
   }
   if {[string match "\{*" [string trimleft $line]] == 1} \
    {
     set open_flag 1
    }
   }

#=======================================================================
proc PB_com_CheckCloseBracesInLine { LINE CLOSE_FLAG } {
  upvar $LINE line
  upvar $CLOSE_FLAG close_flag
  set close_flag 0
  if 0 {
   if {[string match "*\}*" $line] == 1} \
  {
   set close_flag 1
  }
 }
 if {[string match "*\}" [string trimright $line]] == 1} \
{
 set close_flag 1
}
}

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
  switch $::tix_version {
   8.4 {
    set blank_index [lsearch $line_wob ""]
   }
   4.1 {
    set blank_index [lsearch $line_wob \0]
   }
  }
  while { $blank_index >= 0}\
  {
   set line_wob [lreplace $line_wob $blank_index $blank_index]
   switch $::tix_version {
    8.4 {
     set blank_index [lsearch $line_wob ""]
    }
    4.1 {
     set blank_index [lsearch $line_wob \0]
    }
   }
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
proc PB_com_FindObjFrmName { obj_name class } {
  global post_object
  if { ![string match "format" $class]   && \
   ![string match "address" $class]  && \
   ![string match "block" $class]    && \
   ![string match "event" $class]    && \
   ![string match "sequence" $class] && \
   ![string match "command" $class] } {
   return -1
   } else {
   Post::GetObjList $post_object $class obj_list
  }
  if [info exists obj_list] \
  {
   foreach object $obj_list \
   {
    switch $class \
    {
     format    { set CheckName $format::($object,for_name) }
     address   { set CheckName $address::($object,add_name) }
     block     { set CheckName $block::($object,block_name) }
     event     { set CheckName $event::($object,event_name) }
     sequence  { set CheckName $sequence::($object,seq_name) }
     command   { set CheckName $command::($object,name) }
    }
    if { [string compare $CheckName $obj_name] == 0 }\
    {
     return $object
     break
    }
   }
  }
  return -1
 }

#=======================================================================
proc PB_com_RetObjFrmName {OBJ_NAME OBJ_LIST RET_CODE} {
  upvar $OBJ_NAME obj_name
  upvar $OBJ_LIST obj_list
  upvar $RET_CODE ret_code
  set ret_code 0
  if {[info exists obj_list] != 0} \
  {
   if [llength $obj_list] {
    set ClassName [string trim [classof [lindex $obj_list 0]] ::]
    foreach object $obj_list\
    {
     switch $ClassName\
     {
      format    { set CheckName $format::($object,for_name) }
      address   { set CheckName $address::($object,add_name) }
      block     { set CheckName $block::($object,block_name) }
      event     { set CheckName $event::($object,event_name) }
      sequence  { set CheckName $sequence::($object,seq_name) }
      command   { set CheckName $command::($object,name) }
     }
     if { [string compare $CheckName $obj_name] == 0 }\
     {
      set ret_code $object
      break
     }
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
  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  set no_adds [array size add_name_arr]
  for {set count 0} {$count < $no_adds} {incr count} \
  {
   set add_name $add_name_arr($count)
   set word_var_list ""
   set word_subnames_list ""
   foreach line $add_mom_var_arr($count) \
   {
    set first_elem [lindex $line 0]
    set second_elem [lindex $line 1]
    if { $first_elem != "" } \
    {
     if {[string match "\$mom_sys_feed_param*format*" $first_elem] || \
     [string match "\$mom_sys_delay_param*format*" $first_elem] } \
     {
      set temp_list [split $first_elem ,]
      set new_var [join $temp_list ",1_"]
      PB_com_RetObjFrmName second_elem fmt_obj_list ret_code
      set mom_sys_arr($new_var) $ret_code
     }
     set mom_sys_arr($first_elem) $second_elem
     lappend word_var_list $first_elem
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
   Z {}
   default \
   {
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
  set pui_file_obj [new ParseFile $FileId]
  File::OpenFileRead $pui_file_obj $FileName
  ParseFile::ParsePuiFile $pui_file_obj post_obj
  File::CloseFile $pui_file_obj
  PB_com_DeleteObject $pui_file_obj
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
  PB_com_DeleteObject $ude_file_obj
 }

#=======================================================================
proc PB_com_ReadDfltDefFile {DefFileName FILEID POST_OBJ} {
  upvar $DefFileName FileName
  upvar $FILEID FileId
  upvar $POST_OBJ post_obj
  if [info exists Post::($post_obj,def_parse_obj)] {
   PB_com_DeleteObject $Post::($post_obj,def_parse_obj)
   unset Post::($post_obj,def_parse_obj)
  }
  set FObjIndex 0
  set AObjIndex 0
  set BObjIndex 0
  set pobj [new ParseFile $FileId]
  set Post::($post_obj,def_parse_obj) $pobj
  ParseFile::ParseDefFile $pobj $FileName
  if [ info exists ParseFile::($pobj,word_sep_list) ] \
  {
   ParseFile::ParseWordSep $pobj
  }
  if [ info exists ParseFile::($pobj,end_line_list) ] \
  {
   ParseFile::ParseEndOfLine $pobj
  }
  if [ info exists ParseFile::($pobj,sequence_list) ] \
  {
   ParseFile::ParseSequence $pobj
  }
  if [ info exists ParseFile::($pobj,format_list) ] \
  {
   ParseFile::ParseFormat $pobj FormatObjList
  }
  if [ info exists ParseFile::($pobj,address_list) ] \
  {
   ParseFile::ParseAddress $pobj post_obj AddObjList LfileAddObjList \
   FormatObjList RapAddList
   PB_adr_SortAddresses AddObjList
   Post::SetRapAdd $post_obj RapAddList
   Post::SetObjListasAttr $post_obj AddObjList
   if [info exists LfileAddObjList] {
    ListingFile::SetLfileAddObjList $post_obj LfileAddObjList
   }
   PB_com_SortObjectsByNames FormatObjList
   Post::SetObjListasAttr $post_obj FormatObjList
   } else {
   Post::GetObjList $post_obj address AddObjList
  }
  PB_fmt_GetPostZeroFormats post_obj FormatObjList
  PB_com_SortObjectsByNames FormatObjList
  Post::SetObjListasAttr $post_obj FormatObjList
  Post::WordAddNamesSubNamesDesc $post_obj
  Post::SetDefMasterSequence $post_obj AddObjList
  if [ info exists ParseFile::($pobj,block_temp_list) ] \
  {
   ParseFile::ParseBlockTemp $pobj BlockObjList AddObjList post_obj
   PB_com_SortObjectsByNames BlockObjList
   Post::SetObjListasAttr $post_obj BlockObjList
   PB_blk_RetDisVars BlockObjList BlockNameList WordDescArray post_obj
  } else \
  { ;#<07-24-01 gsl> Fixed Rapid blocks problem
   Post::GetObjList $post_obj block blk_obj_list
   PB_blk_SetRapidBlockObjs post_obj blk_obj_list
  }
 }

#=======================================================================
proc PB_com_SortObjectsByNames { OBJ_LIST } {
  upvar $OBJ_LIST obj_list
  set no_elements [llength $obj_list]
  if { $no_elements > 0 } \
  {
   set object [lindex $obj_list 0]
   set ClassName [string trim [classof $object] ::]
   for {set ii 0} {$ii < [expr $no_elements - 1]} {incr ii} \
   {
    for {set jj [expr $ii + 1]} {$jj < $no_elements} {incr jj} \
    {
     set ii_obj [lindex $obj_list $ii]
     switch $ClassName\
     {
      format    { set ii_name $format::($ii_obj,for_name) }
      address   { set ii_name $address::($ii_obj,add_name) }
      block     { set ii_name $block::($ii_obj,block_name) }
      event     { set ii_name $event::($ii_obj,event_name) }
      sequence  { set ii_name $sequence::($ii_obj,seq_name) }
      command   { set ii_name $command::($ii_obj,name) }
     }
     set jj_obj [lindex $obj_list $jj]
     switch $ClassName\
     {
      format    { set jj_name $format::($jj_obj,for_name) }
      address   { set jj_name $address::($jj_obj,add_name) }
      block     { set jj_name $block::($jj_obj,block_name) }
      event     { set jj_name $event::($jj_obj,event_name) }
      sequence  { set jj_name $sequence::($jj_obj,seq_name) }
      command   { set jj_name $command::($jj_obj,name) }
     }
     if { [string compare $ii_name $jj_name] > 0} \
     {
      set obj_list [lreplace $obj_list $ii $ii $jj_obj]
      set obj_list [lreplace $obj_list $jj $jj $ii_obj]
     }
    }
   }
  }
 }

#=======================================================================
proc __PB_com_MapMOMVariable { MOM_SYS_VAR_ARR ADD_OBJ BLK_ELEM_MOM_VAR \
  MOM_VAR_VALUE } {
  upvar $MOM_SYS_VAR_ARR mom_sys_var_arr
  upvar $ADD_OBJ add_obj
  upvar $BLK_ELEM_MOM_VAR blk_elem_mom_var
  upvar $MOM_VAR_VALUE mom_var_value
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
   set fmt_obj $address::($add_obj,add_format)
   set fmt_type $format::($fmt_obj,for_dtype)
   if {[string compare $fmt_type "Text String"] == 0} {
    set mom_var_value $blk_elem_mom_var
    } else {
    set mom_var_value ""
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
  global post_object
  array set mom_kin_var $Post::($post_object,mom_kin_var_list)
  set mom_var_names [array names mom_sys_var_arr]
  global gPB_blk_elem_var
  if [info exists gPB_blk_elem_var] {
   set var $gPB_blk_elem_var
   set exp $gPB_blk_elem_var
   } else {
   set var $blk_elem_mom_var
   set exp $blk_elem_mom_var
  }
  set len [string length $exp]
  set i [string first "\$" $exp]
  while { $i != -1 } {
   set head ""
   set tail ""
   if { $i > 0 } {
    set head [string range $exp 0 [expr $i - 1]]
   }
   set j [string wordend $exp [expr $i + 1]]
   set p_count 0
   set c ""
   if { [string index $exp $j] == "(" } {
    incr p_count
    set j [string wordend $exp [expr $j + 1]]
    set c [string index $exp $j]
    if { $c == ")" } { incr p_count -1 }
    if { $c == "(" } { incr p_count }
   }
   while { $p_count != 0 } {
    set j [string wordend $exp [expr $j + 1]]
    set c [string index $exp $j]
    if { $c == ")" } { incr p_count -1 }
    if { $c == "(" } { incr p_count }
    if { $j >= [expr $len - 1] } { set p_count 0 } ;# Safety
   }
   if { $c == ")" } { incr j } ;# Push index past ")", if any.
   set var [string range $exp $i [expr $j - 1]]
   UI_PB_debug_DisplayMsg " "
   UI_PB_debug_DisplayMsg "var == $var"
   set vi [lsearch $mom_var_names $var]
   if { $vi == -1 } { ;# unrecognized varaible found, stop resolving expression.
    break
    } else {
    if [string match "\$mom_sys_unit_code*output_unit)" $var] {
     if [string match "IN" $mom_kin_var(\$mom_kin_output_unit)] {
      set var "\$mom_sys_unit_code(IN)"
      } else {
      set var "\$mom_sys_unit_code(MM)"
     }
    }
    set var $mom_sys_var_arr($var)
    UI_PB_debug_DisplayMsg "    == $var"
    if { [string first "\$" $var] != -1 } {
     set var $mom_sys_var_arr($var)
     UI_PB_debug_DisplayMsg "    == $var"
    }
   }
   if { $j < [expr $len - 1] } {
    set tail [string range $exp $j end]
   }
   set exp $head$var$tail
   set len [string length $exp]
   set i [string first "\$" $exp]
  }
  UI_PB_debug_DisplayMsg "expression == $exp"
  set fmt_obj $address::($add_obj,add_format)
  set fmt_type $format::($fmt_obj,for_dtype)
  set mom_var_value ""
  if {[string compare $fmt_type "Text String"] == 0} {
   catch {set mom_var_value [format %s "$exp"]}
   } elseif { [string length $exp] > 0 } {
   catch {set mom_var_value [expr $exp]}
  }
  UI_PB_debug_DisplayMsg "mom_var_value == $mom_var_value"
 }

#=======================================================================
proc PB_com_GetMachAxisType { kin_machine_type MACH_TYPE AXISOPTION } {
  upvar $MACH_TYPE mach_type
  upvar $AXISOPTION axisoption
  switch $kin_machine_type \
  {
   "3_axis_mill" \
   {
    set mach_type "Mill"
    set axisoption "3"
   }
   "3_axis_mill_turn" \
   {
    set mach_type "Mill"
    set axisoption "3MT"
   }
   "4_axis_head" \
   {
    set mach_type "Mill"
    set axisoption "4H"
   }
   "4_axis_table" \
   {
    set mach_type "Mill"
    set axisoption "4T"
   }
   "5_axis_dual_table" \
   {
    set mach_type "Mill"
    set axisoption "5TT"
   }
   "5_axis_dual_head" \
   {
    set mach_type "Mill"
    set axisoption "5HH"
   }
   "5_axis_head_table" \
   {
    set mach_type "Mill"
    set axisoption "5HT"
   }
   "lathe" \
   {
    set mach_type "Lathe"
    set axisoption "2"
   }
   "2_axis_wedm" \
   {
    set mach_type "Wire EDM"
    set axisoption "2"
   }
   "4_axis_wedm" \
   {
    set mach_type "Wire EDM"
    set axisoption "4"
   }
   "mill_turn" \
   {
    set mach_type "Mill/Turn"
    set axisoption "3axis"
   }
  }
 }

#=======================================================================
proc PB_com_GetPrefixOfEvent { EVENT_NAME PREFIX } {
  upvar $EVENT_NAME event_name
  upvar $PREFIX prefix
  set cur_machine [PB2TCL_read_fly_var mom_fly_machine_type]
  if [string match "*_wedm" $cur_machine] {
   switch $event_name \
   {
    "Start of Program"   -
    "Start Move"         -
    "Approach Move"      -
    "Cutcom Move"        -
    "Lead In Move"       -
    "Lead Out Move"      \
    {
     set prefix "PB"
    }
    default \
    {
     set prefix "MOM"
    }
   }
   } else {
   switch -glob $event_name \
   {
    "start_of_*"   -
    "end_of_*"   -
    "Start of Program"   -
    "Auto Tool Change"   -
    "Manual Tool Change" -
    "Start Move"         -
    "Approach Move"      -
    "Engage Move"        -
    "First Cut"          -
    "First Linear Move"  -
    "Inch Metric Mode"   -
    "Cycle Parameters"   -
    "Retract Move"       -
    "Return Move"        -
    "Feedrates" \
    {
     set prefix "PB"
    }
    default \
    {
     set prefix "MOM"
    }
   }
  }
 }
