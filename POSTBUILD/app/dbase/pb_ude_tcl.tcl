#0

#=======================================================================
proc PB_ude_UdeInitParse { this POST_OBJ } {
  upvar $POST_OBJ post_obj
  set event_start_flag  0
  set param_start_flag  0
  set event_create_flag 0
  set param_create_flag 0
  set param_attr        ""
  set event_attr        ""
  set param_obj_list    ""
  set event_obj_list    ""
  set ude_obj_list      ""
  set cyc_evt_obj_list  "" ;#<02-20-06 peter> add a list to store the cycle_event objs
  if [info exists Post::($post_obj,ude_obj)] {
   set ude_obj_list      [lindex $Post::($post_obj,ude_obj) 0]
  }
  if { $ude_obj_list != "" } {
   set event_obj_list    $ude::($ude_obj_list,event_obj_list)
   set cyc_evt_obj_list  $ude::($ude_obj_list,cyc_evt_obj_list)
  }
  while { [gets $File::($this,FilePointer) line] >= 0 }\
  {
   set line [string trimleft $line " "]
   set comnt_check [string index $line 0]
   if { [string compare $comnt_check #] == 0  ||  [string compare $comnt_check ""] == 0 }\
   {
    continue
   } else\
   {
    set line_length [string length $line]
    set last_char_test [string index $line [expr $line_length - 1]]
    if { [string compare $last_char_test \\] == 0 }\
    {
     set line_wo_sl [string range $line 0 [expr $line_length - 2]]
     append temp_line $line_wo_sl
     continue
     } elseif { [info exists temp_line] }\
    {
     append temp_line $line
     set line $temp_line
     unset temp_line
    }
    PB_ude_UdeSecParse line event_start_flag param_start_flag \
    event_create_flag param_create_flag \
    event_attr param_attr param_obj_list \
    event_obj_list cyc_evt_obj_list ;#<02-20-06 peter>
   }
  }
  PB_ude_CreateLastParamEvtObj param_attr param_obj_list event_attr \
  event_obj_list ude_obj_list cyc_evt_obj_list ;#<02-20-06 peter>
  set Post::($post_obj,ude_obj) $ude_obj_list
  Post::SetObjListasAttr $post_obj event_obj_list
  Post::SetObjListasAttr $post_obj cyc_evt_obj_list
 }

#=======================================================================
proc PB_ude_UdeSecParse { LINE EVENT_START_FLAG PARAM_START_FLAG \
  EVENT_CREATE_FLAG PARAM_CREATE_FLAG \
  EVENT_ATTR PARAM_ATTR PARAM_OBJ_LIST \
  EVENT_OBJ_LIST CYC_EVT_OBJ_LIST } {
  upvar $LINE line
  upvar $EVENT_START_FLAG event_start_flag
  upvar $PARAM_START_FLAG param_start_flag
  upvar $EVENT_CREATE_FLAG event_create_flag
  upvar $PARAM_CREATE_FLAG param_create_flag
  upvar $EVENT_ATTR event_attr
  upvar $PARAM_ATTR param_attr
  upvar $PARAM_OBJ_LIST param_obj_list
  upvar $EVENT_OBJ_LIST event_obj_list
  upvar $CYC_EVT_OBJ_LIST cyc_evt_obj_list ;#<02-20-06 peter>
  switch -glob $line\
  {
   CYCLE*      -
   SYS_CYCLE*  -
   EVENT*      {
    set event_start_flag 1
    if { $event_create_flag }\
    {
     if { $param_create_flag }\
     {
      PB_ude_CreateParamObjAttr param_attr param_obj_list
      unset param_attr
      set param_create_flag 0
     }
     PB_ude_CreateEventObjAttr event_attr param_obj_list event_obj_list \
     cyc_evt_obj_list ;#<02-20-06 peter>
     unset event_attr
     set param_start_flag 0
     set event_create_flag 0
    }
   }
  }
  if { $event_start_flag }\
  {
   set event_create_flag 1
   if { !$param_start_flag }\
   {
    switch -glob $line\
    {
     CYCLE*         {
      lappend event_attr $line
     }
     SYS_CYCLE*     {
      lappend event_attr $line
     }
     EVENT*         {
      lappend event_attr $line
     }
     POST_EVENT*    {
      lappend event_attr $line
     }
     UI_LABEL*      {
      lappend event_attr $line
     }
     CATEGORY*      {
      lappend event_attr $line
     }
     UI_HELP*       {
      lappend event_attr $line
     }
    }
   }
   switch -glob $line\
   {
    PARAM*    {
     set param_start_flag 1
     if { $param_create_flag }\
     {
      PB_ude_CreateParamObjAttr param_attr param_obj_list
      unset param_attr
      set param_create_flag 0
     }
     lappend param_attr $line
    }
   }
   if { $param_start_flag }\
   {
    switch -glob $line\
    {
     TYPE*         {
      lappend param_attr $line
     }
     DEFVAL*       {
      lappend param_attr $line
     }
     OPTIONS*      {
      lappend param_attr $line
     }
     UI_LABEL*     {
      lappend param_attr $line
     }
     TOGGLE*       {
      lappend param_attr $line
     }
    }
    set param_create_flag 1
   }
  }
 }

#=======================================================================
proc PB_ude_CreateEventObjAttr { ATTR_LIST PARAM_OBJ_LIST EVENT_OBJ_LIST \
  CYC_EVT_OBJ_LIST } {
  upvar $ATTR_LIST attr_list
  upvar $PARAM_OBJ_LIST param_obj_list
  upvar $EVENT_OBJ_LIST event_obj_list
  upvar $CYC_EVT_OBJ_LIST cyc_evt_obj_list
  set pevt_srch [lsearch $attr_list POST_EVENT*]
  set lbl_srch [lsearch $attr_list UI_LABEL*]
  set cat_srch [lsearch $attr_list CATEGORY*]
  if { $pevt_srch == -1 }\
  {
   lappend attr_list {POST_EVENT ""}
  }
  if { $lbl_srch == -1 }\
  {
   lappend attr_list {UI_LABEL ""}
  }
  if { $cat_srch == -1 }\
  {
   lappend attr_list {CATEGORY ""}
  }
  set hlp_srch [lsearch $attr_list UI_HELP*]
  if { $hlp_srch == -1 }\
  {
   lappend attr_list {UI_HELP "" ""}
  }
  foreach attr $attr_list\
  {
   switch -glob $attr\
   {
    CYCLE*      -
    SYS_CYCLE*  -
    EVENT*      {
     set event_type_flag   [lindex $attr 0]
     set event_obj_attr(0) [lindex $attr 1]
    }
    POST_EVENT* {
     set event_obj_attr(1) [lindex $attr 1]
    }
    UI_LABEL*   {
     set event_obj_attr(2) [lindex $attr 1]
    }
    CATEGORY*   {
     set event_obj_attr(3) [lrange $attr 1 end]
    }
    UI_HELP*    {
     set event_obj_attr(5) [lindex $attr 1]
     set event_obj_attr(6) [lindex $attr 2]
    }
   }
  }
  set event_obj_attr(4) $param_obj_list
  unset param_obj_list
  if { ![info exists event_obj_attr(7)] } {
   set event_obj_attr(7)  0  ;# is_dummy
  }
  UI_PB_debug_ForceMsg_no_trace "@@@@@ UDE objects: [array get event_obj_attr]"
  if { $event_type_flag == "EVENT" } {
   PB_mthd_SetObjExtAttr event_obj_attr "ude_event"
   PB_ude_CreateEventObj event_obj_attr event_obj_list
   PB_mthd_CatalogPostExtObj event_obj_attr "ude_event"
   } else {
   PB_mthd_SetObjExtAttr event_obj_attr "cycle_event"
   PB_ude_CreateCycleEventObj event_obj_attr cyc_evt_obj_list event_type_flag
   PB_mthd_CatalogPostExtObj event_obj_attr "cycle_event"
  }
 }

#=======================================================================
proc PB_ude_CreateParamObjAttr { ATTR_LIST PARAM_OBJ_LIST } {
  upvar $ATTR_LIST attr_list
  upvar $PARAM_OBJ_LIST param_obj_list
  PB_ude_InitParamAttr attr_list
  foreach attr $attr_list\
  {
   switch -glob $attr\
   {
    PARAM*    {
     set param_obj_attr(0) [lindex $attr 1]
    }
    TYPE*     {
     set param_obj_attr(1) [lindex $attr 1]
    }
    DEFVAL*   {
     if ![string compare $param_obj_attr(1) s] {
      set param_obj_attr(4) [lindex $attr 1]
      } else {
      set param_obj_attr(2) [lindex $attr 1]
     }
    }
    OPTIONS*  {
     set temp_string [string trimleft $attr "OPTIONS "]
     set param_obj_attr(3) [string trimright $temp_string]
    }
    TOGGLE*   {
     if {![string compare $param_obj_attr(1) s]} {
      set param_obj_attr(2) [lindex $attr 1]
      } elseif {![string compare $param_obj_attr(1) o]} {
      set param_obj_attr(5) [lindex $attr 1]
      } else {
      set param_obj_attr(3) [lindex $attr 1]
     }
    }
    UI_LABEL* {
     if {[string compare $param_obj_attr(1) s] == 0 || \
      [string compare $param_obj_attr(1) b] == 0 || \
     [string compare $param_obj_attr(1) g] == 0}\
     {
      set param_obj_attr(3) [lindex $attr 1]
      } elseif {[string compare $param_obj_attr(1) p] == 0 || \
     [string compare $param_obj_attr(1) v] == 0}\
     {
      set param_obj_attr(2) [lindex $attr 1]
     } else\
     {
      set param_obj_attr(4) [lindex $attr 1]
     }
    }
   }
  }
  PB_ude_CreateParamObj param_obj_attr param_obj_list
 }

#=======================================================================
proc PB_ude_InitParamAttr {ATTR_LIST} {
  upvar $ATTR_LIST attr_list
  set test [lsearch $attr_list TYPE*]
  set type_elem [lindex $attr_list $test]
  set dtype [lindex $type_elem 1]
  switch $dtype\
  {
   i - d - \
   o - b     {
    set dval_srch [lsearch $attr_list DEFVAL*]
    if {$dval_srch == -1}\
    {
     lappend attr_list {DEFVAL ""}
    }
    switch $dtype\
    {
     i - d  {
      set tog_srch [lsearch $attr_list TOGGLE*]
      if {$tog_srch == -1}\
      {
       lappend attr_list {TOGGLE ""}
      }
     }
     o      {
      set tog_srch [lsearch $attr_list TOGGLE*]
      if {$tog_srch == -1} {
       lappend attr_list {TOGGLE ""}
      }
     }
    }
   }
   s         {
    set tog_srch [lsearch $attr_list TOGGLE*]
    if {$tog_srch == -1}\
    {
     lappend attr_list {TOGGLE ""}
    }
    set def_srch [lsearch $attr_list DEFVAL*]
    if {$def_srch == -1} {
     lappend attr_list {DEFVAL ""}
    }
   }
   p         {
    set tog_srch [lsearch $attr_list TOGGLE*]
    if {$tog_srch == -1} {
     lappend attr_list {TOGGLE ""}
    }
   }
   l         {
    set def_srch [lsearch $attr_list DEFVAL*]
    if {$def_srch == -1} {
     lappend attr_list {DEFVAL ""}
    }
   }
   g         {
    set dval_srch [lsearch $attr_list DEFVAL*]
    if {$dval_srch == -1}\
    {
     lappend attr_list {DEFVAL ""}
    }
    set label_srch [lsearch $attr_list UI_LABEL*]
    if {$label_srch == -1}\
    {
     lappend attr_list {UI_LABEL "Group End"}
    }
   }
   v         {
    set tog_srch [lsearch $attr_list TOGGLE*]
    if {$tog_srch == -1} {
     lappend attr_list {TOGGLE ""}
    }
   }
  }
  set lbl_srch [lsearch $attr_list UI_LABEL*]
  if {$lbl_srch == -1}\
  {
   lappend attr_list {UI_LABEL ""}
  }
 }

#=======================================================================
proc PB_ude_CreateLastParamEvtObj { PARAM_ATTR PARAM_OBJ_LIST EVENT_ATTR \
  EVENT_OBJ_LIST UDE_OBJ_LIST \
  CYC_EVT_OBJ_LIST } {
  upvar $PARAM_ATTR param_attr
  upvar $PARAM_OBJ_LIST param_obj_list
  upvar $EVENT_ATTR event_attr
  upvar $EVENT_OBJ_LIST event_obj_list
  upvar $UDE_OBJ_LIST ude_obj_list
  upvar $CYC_EVT_OBJ_LIST cyc_evt_obj_list
  PB_ude_CreateParamObjAttr param_attr param_obj_list
  PB_ude_CreateEventObjAttr event_attr param_obj_list event_obj_list \
  cyc_evt_obj_list ;#<02-20-06 peter>
  set ude_obj_attr(0) DEFALUT
  set ude_obj_attr(1) $event_obj_list
  set ude_obj_attr(2) $cyc_evt_obj_list
  PB_ude_CreateUdeObject ude_obj_attr ude_obj_list
 }

#=======================================================================
proc PB_ude_CreateParamObj { OBJ_ATTR OBJ_LIST } {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list
  set object [param::CreateObject obj_attr(1)]
  lappend obj_list $object
  param::ObjectSetValue $object obj_attr
  param::ObjectSetDefaultValue $object obj_attr
 }

#=======================================================================
proc PB_ude_CreateEventObj { OBJ_ATTR OBJ_LIST } {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list
  PB_com_RetObjFrmName obj_attr(0) obj_list object
  UI_PB_debug_ForceMsg_no_trace "@@@@@ UDE objects: $object => [array get obj_attr]"
  if { $object == 0 } {
   set object [new ude_event]
   lappend obj_list $object
  }
  ude_event::setvalue $object obj_attr
  ude_event::setdefvalue $object obj_attr
 }

#=======================================================================
proc PB_ude_CreateCycleEventObj { OBJ_ATTR OBJ_LIST EVENT_TYPE_FLAG} {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list
  upvar $EVENT_TYPE_FLAG event_type_flag
  PB_com_RetObjFrmName obj_attr(0) obj_list object
  if { $object == 0 } {
   set object [new cycle_event]
   lappend obj_list $object
  }
  if { $event_type_flag == "SYS_CYCLE" } {
   set obj_attr(1) 1
   if { [string compare $obj_attr(2) ""] == 0 } {
    if { [string match $obj_attr(0) "Peck_Drill"] || \
     [string match $obj_attr(0) "Break_Chip"] } {
     set obj_attr(2) [split $obj_attr(0) _]
     } else {
     set obj_attr(2) [join [split $obj_attr(0) _] ","]
    }
   }
   } else {
   set obj_attr(1) 0
  }
  cycle_event::setvalue $object obj_attr
  cycle_event::setdefvalue $object obj_attr
 }

#=======================================================================
proc PB_ude_CreateUdeObject { OBJ_ATTR OBJ_LIST } {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list
  if { [llength $obj_list] == 0 } {
   set object [new ude]
   lappend obj_list $object
   } else {
   set object [lindex $obj_list 0]
  }
  ude::setvalue $object obj_attr
 }

#=======================================================================
proc UI_PB_ude_SortEventObj_ByName {event_obj_list} {
  set name_objs_list [list]
  set sorted_list [list]
  foreach one $event_obj_list {
   set class_type [classof $one]
   if {$class_type == "::ude_event"} {
    lappend name_objs_list "$::ude_event::($one,name)_$one"
    } else {
    lappend name_objs_list "$::cycle_event::($one,name)_$one"
   }
  }
  set name_objs_list [lsort $name_objs_list]
  foreach one $name_objs_list {
   lappend sorted_list [lindex [split $one "_"] end]
  }
  return $sorted_list
 }

#=======================================================================
proc PB_ude_OutputCdlFile { NAME } {
  upvar $NAME name
  global env gPB post_object machType
  set fid [open $name w]
  puts $fid "#################### USER DEFINED EVENTS #####################################"
  puts $fid "#                                                                            #"
  puts $fid "#    PURPOSE:                                                                #"
  puts $fid "#       This file is used in the conversion of post commands contained       #"
  puts $fid "#       in pre UG V15.0 part files into User Defined Events.                 #"
  puts $fid "#                                                                            #"
  puts $fid "##############################################################################"
  set time_string [clock format [clock seconds] -format "%c %Z"]
  puts $fid "\n"
  puts $fid "#============================================================================#"
  puts $fid "#  Created by $env(USERNAME) @ $time_string"
  puts $fid "#  with Post Builder version $gPB(Postbuilder_Release_Version)."
  puts $fid "#============================================================================#"
  puts $fid "\n"
  puts $fid "MACHINE FANUC"
  puts $fid "\n"
  set udeobj $Post::($post_object,ude_obj)
  set seqobj $ude::($udeobj,seq_obj)
  if 0 {
   if [string match $machType "Mill"] {
    set event_obj_list [concat $sequence::($seqobj,mc_ude_obj_list) \
    $sequence::($seqobj,non_mc_ude_obj_list)]
    set event_obj_list [UI_PB_ude_SortEventObj_ByName $event_obj_list]
    set udc_obj_list   [UI_PB_ude_SortEventObj_ByName $ude::($udeobj,cyc_evt_obj_list)]
    set event_obj_list [concat $event_obj_list $udc_obj_list]
    } else {
    set event_obj_list [concat $sequence::($seqobj,mc_ude_obj_list) \
    $sequence::($seqobj,non_mc_ude_obj_list)]
    set event_obj_list [UI_PB_ude_SortEventObj_ByName $event_obj_list]
   }
   } else {
   set event_obj_list [concat $sequence::($seqobj,mc_ude_obj_list) \
   $sequence::($seqobj,non_mc_ude_obj_list)]
   if [string match $machType "Mill"] {
    set udc_obj_list   [UI_PB_ude_SortEventObj_ByName $ude::($udeobj,cyc_evt_obj_list)]
    } else {
    set udc_obj_list   [list]
   }
   set event_obj_list [UI_PB_ude_SortEventObj_ByName $event_obj_list]
   PB_file_ExcludeExtPostObjects event_obj_list "ude_event"
   PB_file_ExcludeExtPostObjects udc_obj_list   "cycle_event"
   set event_obj_list [concat $event_obj_list $udc_obj_list]
  }
  foreach eventobj $event_obj_list {
   set class_type [classof $eventobj]
   if { $class_type == "::ude_event" } {
    set name             $ude_event::($eventobj,name)
    set post_event       $ude_event::($eventobj,post_event)
    set ui_label         $ude_event::($eventobj,ui_label)
    set category         $ude_event::($eventobj,category)
    set param_obj_list   $ude_event::($eventobj,param_obj_list)
    set ui_help_descript $ude_event::($eventobj,help_descript)
    set ui_help_url      $ude_event::($eventobj,help_url)
    puts $fid "EVENT $name"
    puts $fid "\{"
     if { ![string match $post_event ""] } {
      puts $fid "   POST_EVENT \"$post_event\""
     }
     if { [string length $ui_label] != 0 } {
      puts $fid "   UI_LABEL \"$ui_label\""
     }
     if { ![string match $ui_help_descript ""] || ![string match $ui_help_url ""] }       {
      puts $fid "   UI_HELP \"$ui_help_descript\" \"$ui_help_url\""
     }
     if { ![string match $category "\{\}"] } {
      if ![string match $category ""] {
       puts $fid "   CATEGORY $category"
      }
     }
     } else {
     set name            $cycle_event::($eventobj,name)
     set ui_label        $cycle_event::($eventobj,ui_label)
     set param_obj_list  $cycle_event::($eventobj,param_obj_list)
     set param_obj_list_for_output [list]
     foreach obj $param_obj_list {
      if {[lsearch $gPB(sys_def_param_obj_list) $obj] < 0} {
       lappend param_obj_list_for_output $obj
      }
     }
     set param_obj_list  $param_obj_list_for_output
     if { [llength $param_obj_list] == 0 } {
      continue
     }
     if { $cycle_event::($eventobj,is_sys_cycle) == 1 } {
      puts $fid "SYS_CYCLE $name"
      puts $fid "\{"
       if {[string length $ui_label] != 0} {
        puts $fid "   UI_LABEL \"$ui_label\""
       }
       } else {
       puts $fid "CYCLE $name"
       puts $fid "\{"
        if { [string length $ui_label] != 0 } {
         puts $fid "   UI_LABEL \"$ui_label\""
        }
        if { $gPB(enable_helpdesc_for_udc) } {
         set ui_help_descript $cycle_event::($eventobj,help_descript)
         set ui_help_url      $cycle_event::($eventobj,help_url)
         if { ![string match $ui_help_descript ""] || ![string match $ui_help_url ""] } {
          puts $fid "   UI_HELP \"$ui_help_descript\" \"$ui_help_url\""
         }
        }
       }
      }
      foreach paramobj $param_obj_list {
       set param_type [string trim [classof $paramobj] ::]
       switch -exact $param_type {
        param::integer {
         set name   $param::integer::($paramobj,name)
         set type   "i"
         set def_v  $param::integer::($paramobj,default)
         set toggle $param::integer::($paramobj,toggle)
         set ui_lbl $param::integer::($paramobj,ui_label)
         puts $fid "   PARAM $name"
         puts $fid "   \{"
          puts $fid "      TYPE $type"
          puts $fid "      DEFVAL \"$def_v\""
          if ![string match $toggle ""] {
           puts $fid "      TOGGLE $toggle"
          }
          if ![string match $ui_lbl ""] {
           puts $fid "      UI_LABEL \"$ui_lbl\""
          }
         puts $fid "   \}"
        }
        param::double  {
         set name   $param::double::($paramobj,name)
         set type   "d"
         set def_v  $param::double::($paramobj,default)
         set toggle $param::double::($paramobj,toggle)
         set ui_lbl $param::double::($paramobj,ui_label)
         puts $fid "   PARAM $name"
         puts $fid "   \{"
          puts $fid "      TYPE $type"
          puts $fid "      DEFVAL \"$def_v\""
          if ![string match $toggle ""] {
           puts $fid "      TOGGLE $toggle"
          }
          if ![string match $ui_lbl ""] {
           puts $fid "      UI_LABEL \"$ui_lbl\""
          }
         puts $fid "   \}"
        }
        param::option  {
         set name   $param::option::($paramobj,name)
         set type   "o"
         set def_v  $param::option::($paramobj,default)
         set toggle $param::option::($paramobj,toggle)
         set ui_lbl $param::option::($paramobj,ui_label)
         set param_list [list]
         set temp_list [split $param::option::($paramobj,options) ,]
         foreach opt $temp_list {
          lappend param_list \"[string trim $opt \"]\"
         }
         set optlst [join $param_list ","]
         puts $fid "   PARAM $name"
         puts $fid "   \{"
          puts $fid "      TYPE $type"
          puts $fid "      DEFVAL \"$def_v\""
          puts $fid "      OPTIONS $optlst"
          if ![string match $ui_lbl ""] {
           puts $fid "      UI_LABEL \"$ui_lbl\""
          }
         puts $fid "   \}"
        }
        param::boolean {
         set name   $param::boolean::($paramobj,name)
         set type   "b"
         set def_v  $param::boolean::($paramobj,default)
         set ui_lbl $param::boolean::($paramobj,ui_label)
         puts $fid "   PARAM $name"
         puts $fid "   \{"
          puts $fid "      TYPE $type"
          puts $fid "      DEFVAL \"$def_v\""
          if ![string match $ui_lbl ""] {
           puts $fid "      UI_LABEL \"$ui_lbl\""
          }
         puts $fid "   \}"
        }
        param::string  {
         set name   $param::string::($paramobj,name)
         set type   "s"
         set def_v  $param::string::($paramobj,default)
         set toggle $param::string::($paramobj,toggle)
         set ui_lbl $param::string::($paramobj,ui_label)
         puts $fid "   PARAM $name"
         puts $fid "   \{"
          puts $fid "      TYPE $type"
          if ![string match $def_v ""] {
           puts $fid "      DEFVAL \"$def_v\""
          }
          if ![string match $toggle ""] {
           puts $fid "      TOGGLE $toggle"
          }
          if ![string match $ui_lbl ""] {
           puts $fid "      UI_LABEL \"$ui_lbl\""
          }
         puts $fid "   \}"
        }
        param::point   {
         set name   $param::point::($paramobj,name)
         set type   "p"
         set toggle $param::point::($paramobj,toggle)
         set ui_lbl $param::point::($paramobj,ui_label)
         puts $fid "   PARAM $name"
         puts $fid "   \{"
          puts $fid "      TYPE $type"
          if ![string match $toggle ""] {
           puts $fid "      TOGGLE $toggle"
          }
          if ![string match $ui_lbl ""] {
           puts $fid "      UI_LABEL \"$ui_lbl\""
          }
         puts $fid "   \}"
        }
        param::bitmap  {
         set name   $param::bitmap::($paramobj,name)
         set type   "l"
         set def_v  $param::bitmap::($paramobj,default)
         puts $fid "   PARAM $name"
         puts $fid "   \{"
          puts $fid "      TYPE $type"
          puts $fid "      DEFVAL \"$def_v\""
         puts $fid "   \}"
        }
        param::group  {
         set name   $param::group::($paramobj,name)
         set type   "g"
         set def_v  $param::group::($paramobj,default)
         set ui_lbl $param::group::($paramobj,ui_label)
         puts $fid "   PARAM $name"
         puts $fid "   \{"
          puts $fid "      TYPE $type"
          puts $fid "      DEFVAL \"$def_v\""
          if { [string compare $def_v "end"] != 0 } {
           puts $fid "      UI_LABEL \"$ui_lbl\""
          }
         puts $fid "   \}"
        }
        param::vector {
         set name   $param::vector::($paramobj,name)
         set type   "v"
         set toggle $param::vector::($paramobj,toggle)
         set ui_lbl $param::vector::($paramobj,ui_label)
         puts $fid "   PARAM $name"
         puts $fid "   \{"
          puts $fid "      TYPE $type"
          if ![string match $toggle ""] {
           puts $fid "      TOGGLE $toggle"
          }
          if ![string match $ui_lbl ""] {
           puts $fid "      UI_LABEL \"$ui_lbl\""
          }
         puts $fid "   \}"
        }
       }
      }
     puts $fid "\}"
     puts $fid "\n"
     puts $fid "#-----------------------------------------------------------------"
     puts $fid "\n"
    }
    close $fid
   }

#=======================================================================
proc PB_ude_ConvertObjs {} {
  PB_ude_SetGlobalVars
  global gPB
  global post_object
  global machData
  set mach_type [string toupper $machData(0)]
  if ![string compare $mach_type "WIRE EDM"] {
   set mach_type "WEDM"
  }
  set reObjList [list]
  set udeobj $Post::($post_object,ude_obj)
  set seqobj [new sequence]
  set ude::($udeobj,seq_obj) $seqobj
  set non_MC_ude_list [list]
  set MC_ude_list [list]
  set wedm_flag 0
  set other_type_sys_ude_list ""
  if { [string match "MILL" $mach_type] } {
   set other_type_sys_ude_list [concat $gPB(MC_ude,LATHE) $gPB(MC_ude,WEDM)]
   } elseif { [string match "LATHE" $mach_type] } {
   set other_type_sys_ude_list [concat $gPB(MC_ude,MILL) $gPB(MC_ude,WEDM)]
   } elseif { [string match "WEDM" $mach_type] } {
   set other_type_sys_ude_list [concat $gPB(MC_ude,MILL) $gPB(MC_ude,LATHE)]
   set wedm_flag 1
  }
  foreach udeevent $ude::($udeobj,event_obj_list) {
   if { [lsearch $gPB(MC_ude,$mach_type) $ude_event::($udeevent,name)] == "-1" } {
    if { [lsearch $other_type_sys_ude_list $ude_event::($udeevent,name)] != "-1" } {
     continue
    }
    if { ![string compare $ude_event::($udeevent,category) "\{\}"] } {
     lappend non_MC_ude_list $udeevent
     } else {
     set category [string toupper $ude_event::($udeevent,category)]
     set category [split $category]
     if { $wedm_flag } {
      if { [lsearch $category $mach_type] != "-1" } {
       lappend non_MC_ude_list $udeevent
      }
      } else {
      if { [lsearch $category "MILL"] != "-1" || \
       [lsearch $category "DRILL"] != "-1" || \
       [lsearch $category "LATHE"] != "-1" } {
       lappend non_MC_ude_list $udeevent
      }
     }
    }
    } else {
    lappend MC_ude_list $udeevent
   }
  }
  set NMC_output_event_obj_list [list]
  set seq_obj_list $Post::($post_object,seq_obj_list)
  set seq_obj ""
  set cyc_seq_obj ""
  foreach seq $seq_obj_list {
   if { $sequence::($seq,seq_name) == "Machine Control" } {
    set seq_obj $seq
   }
   if { $sequence::($seq,seq_name) == "Cycles" } {
    set cyc_seq_obj $seq
   }
  }
  set pre_list $sequence::($seq_obj,evt_obj_list)
  set temp_evt_obj_list [list]
  set evt_obj_for_ude   [list]
  foreach a $pre_list {
   if {$event::($a,event_ude_name) == "UDE"} {
    lappend evt_obj_for_ude $a
    } else {
    lappend temp_evt_obj_list $a
   }
  }
  foreach one $MC_ude_list {
   foreach candidate $pre_list {
    if {$event::($candidate,event_ude_name) == $ude_event::($one,name)} {
     set event::($candidate,ude_event_obj) $one
    }
   }
  }
  set sequence::($seq_obj,evt_obj_list) $temp_evt_obj_list
  set eventobj_list [list]
  set to_be_delete_event [list]
  foreach non_MC_ude $non_MC_ude_list {
   set obj [new event]
   set event::($obj,event_name) $ude_event::($non_MC_ude,name)
   set event::($obj,event_ude_name) $ude_event::($non_MC_ude,name)
   set name $ude_event::($non_MC_ude,name)
   set output_obj "-1"
   foreach b $evt_obj_for_ude {
    if {$name == $event::($b,event_name)} {
     set output_obj $b
    }
   }
   if {$output_obj != "-1"} {
    set event::($obj,block_nof_rows) $event::($output_obj,block_nof_rows)
    set event::($obj,evt_elem_list)  $event::($output_obj,evt_elem_list)
    foreach one $event::($output_obj,evt_elem_list) {
     set ::event_element::($one,event_obj) $obj
    }
    lappend to_be_delete_event $output_obj
    } else {
    set event::($obj,block_nof_rows) "0"
    set event::($obj,evt_elem_list)  ""
   }
   set event::($obj,evt_itm_obj_list) ""
   if ![string compare $ude_event::($non_MC_ude,ui_label) ""] {
    set event::($obj,event_label) $ude_event::($non_MC_ude,name)
    } else {
    set event::($obj,event_label) $ude_event::($non_MC_ude,ui_label)
   }
   set event::($obj,ude_event_obj) $non_MC_ude
   lappend eventobj_list $obj
   event::DefaultValue $obj
   event::RestoreValue $obj
   if { ![string compare $ude_event::($non_MC_ude,post_event) ""] } {
    set handler_name MOM_$ude_event::($non_MC_ude,post_event)
    } else {
    set handler_name MOM_$ude_event::($non_MC_ude,name)
   }
   if { [lsearch $gPB(MOM_func,SYS) $handler_name] == "-1" } {
    lappend gPB(MOM_func,SYS) $handler_name
   }
  }
  set sequence::($seqobj,seq_name) "Non Machine Control"
  set sequence::($seqobj,evt_obj_list) $eventobj_list
  set sequence::($seqobj,comb_elem_list) ""
  set sequence::($seqobj,non_mc_ude_obj_list) $non_MC_ude_list
  set sequence::($seqobj,mc_ude_obj_list) $MC_ude_list
  lappend reObjList $seqobj
  foreach one $to_be_delete_event {
   set event::($one,evt_elem_list) [list]
   event::DefaultValue $one
   delete $one
  }
  if { $mach_type == "MILL" } {
   set sc_cycle_event_obj_list [list]
   set nsc_cycle_event_obj_list [list]
   set exist_sc_cycle_event_names [list]
   foreach ceo $ude::($udeobj,cyc_evt_obj_list) {
    if { $cycle_event::($ceo,is_sys_cycle) == 1 } {
     lappend sc_cycle_event_obj_list $ceo
     lappend exist_sc_cycle_event_names $cycle_event::($ceo,name)
     } else {
     lappend nsc_cycle_event_obj_list $ceo
    }
   }
   set sys_cycle_names $gPB(SYS_CYCLE)
   set sys_cycle_names_with_addition_param [list]
   foreach name $exist_sc_cycle_event_names {
    set idx [lsearch $sys_cycle_names $name]
    set sys_cycle_names [lreplace $sys_cycle_names $idx $idx]
    lappend sys_cycle_names_with_addition_param $name
   }
   foreach ceo $sc_cycle_event_obj_list {
    set temp_param_list $cycle_event::($ceo,param_obj_list)
    set sys_defined_param_list [PB_ude_CreateSysDefinedParams $cycle_event::($ceo,name)]
    set temp_param_list [concat $sys_defined_param_list $temp_param_list]
    set cycle_event::($ceo,param_obj_list) $temp_param_list
    set cycle_event::($ceo,def_param_obj_list) $temp_param_list
   }
   foreach name $sys_cycle_names {
    set obj [new cycle_event]
    set obj_attr(0) $name
    set obj_attr(1) 1
    if {[string match $obj_attr(0) "Peck_Drill"] || \
     [string match $obj_attr(0) "Break_Chip"] } {
     set obj_attr(2) [split $obj_attr(0) _]
     } else {
     set obj_attr(2) [join [split $obj_attr(0) _] ","]
    }
    set obj_attr(4) [PB_ude_CreateSysDefinedParams $name]
    if $gPB(enable_helpdesc_for_udc) {
     set obj_attr(5) ""
     set obj_attr(6) ""
    }
    cycle_event::setvalue $obj obj_attr
    cycle_event::setdefvalue $obj obj_attr
    lappend sc_cycle_event_obj_list $obj
   }
   set ude::($udeobj,cyc_evt_obj_list) [concat $sc_cycle_event_obj_list $nsc_cycle_event_obj_list]
   set seqobj_cycle [new sequence]
   set ude::($udeobj,seq_obj_cycle) $seqobj_cycle
   set sequence::($seqobj_cycle,sc_cycle_event_objs) $sc_cycle_event_obj_list
   set sequence::($seqobj_cycle,nsc_cycle_event_objs) $nsc_cycle_event_obj_list
   set pre_list $sequence::($cyc_seq_obj,evt_obj_list)
   set pre_list_event_name [list]
   set temp_obj_list [list]
   foreach obj $pre_list {
    set evt_name $event::($obj,event_name)
    lappend pre_list_event_name $evt_name
    if {[lsearch $gPB(EXIST_CYCLE_EVENT) "$evt_name"] != "-1"} {
     lappend temp_obj_list $obj
    }
   }
   set sequence::($cyc_seq_obj,evt_obj_list) $temp_obj_list
   foreach obj $sc_cycle_event_obj_list {
    set event_name [PB_ude_GetEventName $obj]
    set idx [lsearch $pre_list_event_name $event_name]
    set candidate_obj [lindex $pre_list $idx]
    set event::($candidate_obj,event_ude_name) "CYCLE_EVENT"
    set event::($candidate_obj,cyc_evt_obj) $obj
   }
   set new_event_list [list]
   foreach obj $nsc_cycle_event_obj_list {
    set cycle_event_name $cycle_event::($obj,name)
    set idx [lsearch $pre_list_event_name $cycle_event_name]
    if { $idx >= 0 } {
     set event_obj [lindex $pre_list $idx]
     set event::($event_obj,event_ude_name) "CYCLE_EVENT"
     set event::($event_obj,cyc_evt_obj) $obj
     lappend new_event_list $event_obj
     } else {
     set event_obj [new event]
     set event::($event_obj,event_name) $cycle_event::($obj,name)
     set event::($event_obj,event_ude_name) "CYCLE_EVENT"
     set event::($event_obj,block_nof_rows) "0"
     set event::($event_obj,evt_elem_list) [list]
     set event::($event_obj,evt_itm_obj_list) [list]
     if ![string compare $cycle_event::($obj,ui_label) ""] {
      set event::($event_obj,event_label) $cycle_event::($obj,name)
      } else {
      set event::($event_obj,event_label) $cycle_event::($obj,ui_label)
     }
     set event::($event_obj,cyc_evt_obj) $obj
     UI_PB_cycle_MakeCopyFromCommonParam $event_obj
     lappend new_event_list $event_obj
     event::DefaultValue $event_obj
     event::RestoreValue $event_obj
    }
   }
   set sequence::($seqobj_cycle,seq_name) "UDC"
   set sequence::($seqobj_cycle,evt_obj_list) $new_event_list
   set sequence::($seqobj_cycle,comb_elem_list) ""
   lappend reObjList $seqobj_cycle
  }
  return $reObjList
 }

#=======================================================================
proc PB_ude_GetEventName { cyc_evt_obj } {
  set cyc_evt_name $cycle_event::($cyc_evt_obj,name)
  set retName ""
  switch -exact $cyc_evt_name   {
   "Drill"                 {
    set retName "Drill"
   }
   "Drill_Text"            {
    set retName "Drill Text"
   }
   "Drill_Csink"           {
    set retName "Drill Csink"
   }
   "Drill_Deep"            {
    set retName "Drill Deep"
   }
   "Drill_Deep_Breakchip"  {
    set retName "Drill Break Chip"
   }
   "Drill_Tap"             {
    set retName "Tap"
   }
   "Drill_Bore"            {
    set retName "Bore"
   }
   "Drill_Bore_Drag"       {
    set retName "Bore Drag"
   }
   "Drill_Bore_Nodrag"     {
    set retName "Bore No Drag"
   }
   "Drill_Bore_Back"       {
    set retName "Bore Back"
   }
   "Drill_Bore_Manual"     {
    set retName "Bore Manual"
   }
   "Peck_Drill"            {
    set retName "Peck Drill"
   }
   "Break_Chip"            {
    set retName "Break Chip"
   }
   "Drill_Tap_Float"       {
    set retName "Tap Float"
   }
   "Drill_Tap_Deep"        {
    set retName "Tap Deep"
   }
   "Drill_Tap_Breakchip"   {
    set retName "Tap Break Chip"
   }
   "Thread"                {
    set retName "Thread"
   }
   "Lathe_Roughing"        {
    set retName "Lathe Roughing"
   }
   default                 {
    set retName "NONE"
   }
  }
  return $retName
 }

#=======================================================================
proc PB_ude_RetUdeUdcObjList {MC NON_MC SYS_CYC NON_SYS_CYC} {
  upvar $MC mc
  upvar $NON_MC non_mc
  upvar $SYS_CYC sys_cyc
  upvar $NON_SYS_CYC non_sys_cyc
  global post_object
  global machData
  global gPB
  set mach_type [string toupper $machData(0)]
  if ![string compare $mach_type "WIRE EDM"] {
   set mach_type "WEDM"
  }
  set udeobj $Post::($post_object,ude_obj)
  set seqobj $ude::($udeobj,seq_obj)
  set temp_udc_obj_list [list]
  foreach one $ude::($udeobj,cyc_evt_obj_list) {
   set param_obj_list_for_output [list]
   foreach paramobj $cycle_event::($one,param_obj_list) {
    if {[lsearch $gPB(sys_def_param_obj_list) $paramobj] < 0} {
     lappend param_obj_list_for_output $paramobj
    }
   }
   if {[llength $param_obj_list_for_output] > 0} {
    lappend temp_udc_obj_list $one
   }
  }
  set event_obj_list [concat $sequence::($seqobj,mc_ude_obj_list) \
  $sequence::($seqobj,non_mc_ude_obj_list) \
  $temp_udc_obj_list]
  foreach eventobj $event_obj_list {
   set class_type [classof $eventobj]
   if {$class_type == "::ude_event"} {
    if {[lsearch $gPB(MC_ude,$mach_type) $ude_event::($eventobj,name)] == "-1"} {
     lappend non_mc $eventobj
     } else {
     lappend mc $eventobj
    }
    } else {
    if {$cycle_event::($eventobj,is_sys_cycle) == 1} {
     lappend sys_cyc $eventobj
     } else {
     lappend non_sys_cyc $eventobj
    }
   }
  }
 }

#=======================================================================
proc PB_ude_SetGlobalVars { } {
  global gPB McParam
  set gPB(MOM_func,SYS) [list "MOM_HEAD" "MOM_Head" "MOM_SIM_initialize_mtd" \
  "MOM_auxfun" "MOM_before_motion" "MOM_bore" \
  "MOM_bore_back" "MOM_bore_back_move" "MOM_bore_drag" \
  "MOM_bore_drag_move" "MOM_bore_dwell" "MOM_bore_dwell_move" \
  "MOM_bore_manual" "MOM_bore_manual_dwell" \
  "MOM_bore_manual_dwell_move" "MOM_bore_manual_move" \
  "MOM_bore_move" "MOM_bore_no_drag" "MOM_bore_no_drag_move" \
  "MOM_circular_move" "MOM_coolant_off" \
  "MOM_coolant_on" "MOM_cut_wire" "MOM_cutcom_off" \
  "MOM_cutcom_on" "MOM_cycle_off" "MOM_cycle_parameters" \
  "MOM_cycle_plane_change" "MOM_delay" "MOM_drill" \
  "MOM_drill_break_chip" "MOM_drill_break_chip_move" \
  "MOM_drill_deep" "MOM_drill_deep_move" "MOM_drill_dwell" \
  "MOM_drill_dwell_move" "MOM_drill_move" "MOM_drill_text" \
  "MOM_drill_text_move" "MOM_end_of_pass" "MOM_end_of_path" \
  "MOM_end_of_program" "MOM_first_move" "MOM_first_tool" \
  "MOM_from_move" "MOM_gohome_move" \
  "MOM_head" "MOM_initial_move" "MOM_lathe_thread" \
  "MOM_lathe_thread_move" "MOM_length_compensation" \
  "MOM_linear_move" "MOM_load_tool" "MOM_lock_axis" \
  "MOM_machine_mode" "MOM_msys" "MOM_opstop" \
  "MOM_prefun" "MOM_rapid_move" "MOM_rotate" "MOM_select_head" \
  "MOM_set_csys" "MOM_set_mode" "MOM_set_modes" \
  "MOM_spindle_css" "MOM_spindle_off" \
  "MOM_spindle_rpm" "MOM_start_of_group" "MOM_start_of_pass" \
  "MOM_start_of_path" "MOM_start_of_program" "MOM_stop" \
  "MOM_sync" "MOM_tap" "MOM_tap_move" "MOM_thread_wire" \
  "MOM_tool_change" "MOM_tool_preselect" \
  "MOM_wire_cutcom" "MOM_wire_feed_rate" "MOM_wire_guides" "MOM_zero" \
  "MOM_nurbs_move" "MOM_tap_float" "MOM_tap_float_move" \
  "MOM_thread" "MOM_thread_move" \
  "MOM_tap_deep" "MOM_tap_deep_move" \
  "MOM_tap_break_chip" "MOM_tap_break_chip_move" ]
  set gPB(MC_ude,MILL)  [list "mill_tool_change" "spindle" "spindle_off" "coolant" \
  "coolant_off" "length_compensation" "tool_preselect" \
  "cutcom" "auxfun" "prefun" "opstop" "stop" "set_modes" \
  "dwell"]
  set gPB(MC_ude,LATHE) [list "lathe_tool_change" "length_compensation" "set_modes" \
  "spindle" "spindle_off" "coolant" "coolant_off" "cutcom" \
  "dwell" "opstop" "auxfun" "prefun" "stop" "tool_preselect"]
  set gPB(MC_ude,WEDM)  [list "thread_wire" "cut_wire" "wire_guides" "wire_cutcom" \
  "dwell" "auxfun" "prefun" "stop" "opstop" "wire_feed_rate"]
  set McParam [list mill_tool_change    { command_status load_tool_number tool_z_offset \
   tool_adjust_register manual_tool_change \
  tool_holder tool_text } \
  spindle             { command_status spindle_mode spindle_speed spindle_maximum_rpm \
  spindle_direction spindle_range spindle_text } \
  spindle_off         { command_status spindle_text } \
  coolant             { command_status coolant_mode coolant_text } \
  coolant_off         { command_status coolant_text } \
  length_compensation { command_status Overide_operation_param \
  length_comp_register length_comp_register_text } \
  tool_preselect      { command_status tool_preselect_number tool_preselect_text } \
  cutcom              { command_status cutcom_mode on_option off_option \
   Overide_operation_param \
   cutcom_adjust_register cutcom_plane \
  full_cutcom_output cutcom_text } \
  auxfun              { command_status auxfun auxfun_text } \
  prefun              { command_status prefun prefun_text } \
  opstop              { command_status opstop_text } \
  stop                { command_status stop_text } \
  set_modes           { command_status machine_mode feed_set_mode output_mode arc_mode \
  parallel_to_axis modes_text } \
  dwell               { command_status delay_mode delay_value delay_text } \
  lathe_tool_change   { command_status load_tool_number \
   tool_x_offset tool_y_offset \
   tool_angle tool_radius tool_head tool_adjust_register \
  tool_change_type tool_text } \
  thread_wire         { command_status thread_wire_text } \
  cut_wire            { command_status cut_wire_text } \
  wire_guides         { command_status wire_guides_text } \
  wire_cutcom         { command_status wire_cutcom_adjust_register cutcom_output \
  wire_cutcom_text } \
  wire_feed_rate      { command_status Feedrate_register Appended_Text }]
  set gPB(EXIST_CYCLE_EVENT) [list {Cycle Parameters} {Cycle Off} {Cycle Plane Change} {Drill} \
  {Drill Dwell} {Drill Text} {Drill Csink} {Drill Deep} {Drill Break Chip} \
  {Tap} {Bore} {Bore Dwell} {Bore Drag} {Bore No Drag} {Bore Back} \
  {Bore Manual} {Bore Manual Dwell} {Peck Drill} {Break Chip} \
  {Tap Float} {Thread} {Lathe Roughing} \
  {Tap Deep} {Tap Break Chip}]
  set gPB(SYS_CYCLE) [list {Drill} {Drill_Text} {Drill_Csink} {Drill_Deep} {Drill_Deep_Breakchip} \
  {Drill_Tap} {Drill_Bore} {Drill_Bore_Drag} {Drill_Bore_Nodrag} \
  {Drill_Bore_Back} {Drill_Bore_Manual} {Peck_Drill} {Break_Chip} \
  {Drill_Tap_Float} {Thread} {Lathe_Roughing} \
  {Drill_Tap_Deep} {Drill_Tap_Breakchip}]
  set gPB(sys_def_param_obj_list) [list]
 }

#=======================================================================
proc PB_ude_CreateSysDefinedParams { sys_cyc_name } {
  global gPB
  set param_obj_list [list]
  set att_dwell(0) cycle_delay_mode
  set att_dwell(1) o
  set att_dwell(2) Off
  set att_dwell(3) {"On","Off","Seconds","Revolutions"}
  set att_dwell(4) "Dwell"
  set att_dwell(5) None
  set att_dwell_value(0) cycle_delay
  set att_dwell_value(1) i
  set att_dwell_value(2) 0
  set att_dwell_value(3) None
  set att_dwell_value(4) "Dwell Value"
  set att_option(0) cycle_option
  set att_option(1) b
  set att_option(2) FALSE
  set att_option(3) Option
  set att_cam(0) cycle_cam
  set att_cam(1) i
  set att_cam(2) 0
  set att_cam(3) Off
  set att_cam(4) "Cam Status"
  set att_text(0) cycle_text
  set att_text(1) s
  set att_text(2) None
  set att_text(3) "Text"
  set att_text(4) ""
  set att_csink_diameter(0) cycle_counter_sink_dia
  set att_csink_diameter(1) d
  set att_csink_diameter(2) 0.0000
  set att_csink_diameter(3) None
  set att_csink_diameter(4) "Csink Diameter"
  set att_csink_ed(0) cycle_hole_dia
  set att_csink_ed(1) d
  set att_csink_ed(2) 0.0000
  set att_csink_ed(3) None
  set att_csink_ed(4) "Entrance Diameter"
  set att_step1(0) cycle_step1
  set att_step1(1) d
  set att_step1(2) 0.0000
  set att_step1(3) None
  set att_step1(4) "Step #1"
  set att_step2(0) cycle_step2
  set att_step2(1) d
  set att_step2(2) 0.0000
  set att_step2(3) None
  set att_step2(4) "Step #2"
  set att_step3(0) cycle_step3
  set att_step3(1) d
  set att_step3(2) 0.0000
  set att_step3(3) None
  set att_step3(4) "Step #3"
  set att_orientation(0) cycle_orient
  set att_orientation(1) d
  set att_orientation(2) 0.0000
  set att_orientation(3) None
  set att_orientation(4) "Orientation"
  set att_dis(0) cycle_distance
  set att_dis(1) d
  set att_dis(2) 0.0000
  set att_dis(3) None
  set att_dis(4) "Distance"
  set att_inc_type(0) cycle_inc_type
  set att_inc_type(1) o
  set att_inc_type(2) None
  set att_inc_type(3) {"None","Constant","Variable"}
  set att_inc_type(4) "Increment Type"
  set att_inc_type(5) None
  set att_inc(0) cycle_incr
  set att_inc(1) d
  set att_inc(2) 0.0000
  set att_inc(3) None
  set att_inc(4) "Increment"
  set att_repeat(0) cycle_repeat
  set att_repeat(1) i
  set att_repeat(2) 0
  set att_repeat(3) None
  set att_repeat(4) "Repeat"
  switch -exact $sys_cyc_name   {
   "Drill"                 {
    set param_att_list [list att_dwell att_dwell_value \
    att_option att_cam]
   }
   "Drill_Text"            {
    set param_att_list [list att_text att_dwell \
    att_dwell_value att_option att_cam]
   }
   "Drill_Csink"           {
    set param_att_list [list att_csink_diameter att_csink_ed \
    att_dwell att_dwell_value att_option]
   }
   "Drill_Deep"            {
    set param_att_list [list att_dwell att_dwell_value att_option \
    att_cam att_step1 att_step2 att_step3]
   }
   "Drill_Deep_Breakchip"  {
    set param_att_list [list att_dwell att_dwell_value att_option \
    att_cam att_step1 att_step2 att_step3]
   }
   "Drill_Tap_Breakchip"   -
   "Drill_Tap_Deep"        -
   "Drill_Tap_Float"       -
   "Drill_Tap"             {
    set param_att_list [list att_dwell att_dwell_value \
    att_option att_cam]
   }
   "Drill_Bore"            {
    set param_att_list [list att_dwell att_dwell_value \
    att_option att_cam]
   }
   "Drill_Bore_Drag"       {
    set param_att_list [list att_dwell att_dwell_value \
    att_option att_cam]
   }
   "Drill_Bore_Nodrag"     {
    set param_att_list [list att_orientation att_dwell \
    att_dwell_value att_option att_cam]
   }
   "Drill_Bore_Back"       {
    set param_att_list [list att_orientation att_dwell \
    att_dwell_value att_option att_cam]
   }
   "Drill_Bore_Manual"     {
    set param_att_list [list att_dwell att_dwell_value \
    att_option att_cam]
   }
   "Peck_Drill"            {
    set param_att_list [list att_dis att_dwell att_dwell_value \
    att_inc_type]
   }
   "Break_Chip"            {
    set param_att_list [list att_dis att_dwell att_dwell_value \
    att_inc_type]
   }
   default                 {
    set param_att_list [list]
   }
  }
  set param_obj_list [list]
  if {$sys_cyc_name != "Peck_Drill" && \
   $sys_cyc_name != "Break_Chip"} {
   foreach param $param_att_list {
    PB_ude_CreateParamObj $param param_obj_list
   }
   } else {
   foreach param $param_att_list {
    PB_ude_CreateParamObj $param param_obj_list
   }
   for {set i 1} {$i < 8} {incr i} {
    set att_inc(4) "Increment $i"
    PB_ude_CreateParamObj att_inc param_obj_list
    PB_ude_CreateParamObj att_repeat param_obj_list
   }
   set param_obj_list [lreplace $param_obj_list end end]
  }
  set gPB(sys_def_param_obj_list) [concat $gPB(sys_def_param_obj_list) $param_obj_list]
  return $param_obj_list
 }
