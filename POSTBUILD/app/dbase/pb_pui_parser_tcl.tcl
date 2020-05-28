#23
UI_PB_AddPatchMsg "2007.0.0" "<28 JUL 2011>\t Added \"Wire Guides\" event for Wire EDM posts"
set gPB(no_output_events_list) {"Tool Change" "Inch Metric Mode" Feedrates Opskip}

#=======================================================================
proc PB_pui_ReadPuiCreateObjs { OBJECT POST_OBJ } {
  upvar $OBJECT object
  upvar $POST_OBJ post_obj
  global gPB vnc_desc_arr
  global output_unit mach_axis
  if [info exists Post::($post_obj,post_name)] {
   UI_PB_debug_ForceMsg "post_name : $Post::($post_obj,post_name) of $post_obj"
   UI_PB_debug_ForceMsg "post_name : $Post::($::post_object,post_name) of $::post_object"
   UI_PB_debug_ForceMsg "FileName : $File::($object,FileName)"
  }
  if [info exists gPB(edit_post_name)] {
   UI_PB_debug_ForceMsg "edit_post_name : $gPB(edit_post_name)"
  }
  set event_handler 0
  set post_info_start     0
  set description_start  0
  set controller_start   0
  set machine_axis_start 0
  set history_start      0
  set main_post_data_start 0
  set list_file_start 0
  set kinematic_var_start 0
  set master_sequence_start 0
  set gcode_start 0
  set mcode_start 0
  set glob_sequence_start 0
  set evt_ui_start 0
  set mom_sys_var_start 0
  set mom_sim_var_start 0
  set mom_sim_cmd_start 0
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
  set tpth_misc_seq 0
  set oper_end_seq 0
  set prog_end_seq 0
  set linked_posts_seq 0
  set type_family_start 0
  set function_info_start 0
  set evt_elem_exec_start 0
  set parse_old_block_modality_flag 0
  set current_event_list [list]
  set vnc_seq 0
  if { ![info exists Post::($post_obj,virtual_nc_evt_list)] } {
   set Post::($post_obj,virtual_nc_evt_list)       [list]
  }
  if { ![info exists Post::($post_obj,virtual_nc_evt_blk_list)] } {
   set Post::($post_obj,virtual_nc_evt_blk_list)   [list]
  }
  if { ![info exists Post::($post_obj,virtual_nc_label_list)] } {
   set Post::($post_obj,virtual_nc_label_list)     [list]
  }
  set index 0
  set merge_marker 0
  if { [info exists gPB(pui_marker_merge)]  &&  $gPB(pui_marker_merge) } {
   set merge_marker 1
  }
  set pui_dir ""
  set post_files(def_file) ""
  set post_files(tcl_file) ""
  Post::SetPostFiles $post_obj pui_dir post_files
  while { [gets $File::($object,FilePointer) line] >= 0 } \
  {
   UI_PB_debug_DisplayMsg $line
   set line_length [string length $line]
   set dummy_line [string trim $line]
   if { $description_start == 0 } {
    if { [string length $dummy_line] == 0 } { continue }
   }
   set last_char_test [string index $line [expr $line_length - 1]]
   if {[string compare $last_char_test \\] == 0} \
   {
    set line_with_space [string range $line 0 [expr $line_length - 2]]
    append temp_line [string trimleft $line_with_space " "]
    continue
    } elseif { [info exists temp_line] } \
   {
    append temp_line [string trimleft $line " "]
    set line $temp_line
    unset temp_line
   }
   switch -glob -- "$line"\
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
    "## POST INFORMATION START"      {
     set post_info_start 1
     continue
    }
    "## POST INFORMATION END"        {
     set post_info_start 0
     continue
    }
    "## MAIN POST DATA START"        {
     if { ![file exists $gPB(main_post)] } {
      set main_post_data_start 1
      set main_sys_var [list]
      set main_kin_var [list]
      set Indep_fmt_list [list]
      set Indep_add_list [list]
      set main_post_Output_VNC 0
     }
     continue
    }
    "## MAIN POST DATA END"          {
     set main_post_data_start 0
     if { ![file exists $gPB(main_post)] } {
      set Post::($post_obj,main_kin_var) $main_kin_var
      set Post::($post_obj,main_sys_var) $main_sys_var
      set tmp_name [file tail $gPB(main_post)]
      set Post::($post_obj,Indep_add_list) [lindex $Indep_add_list 0]
      set tmp_no [llength $Post::($post_obj,Indep_add_list)]
      array set tmp_add_arr [list]
      for { set kk 1 } { $kk <= $tmp_no } { incr kk } {
       set indx [expr $kk - 1]
       set tmp_add_arr($tmp_name,$indx,data) [lindex $Indep_add_list $kk]
       set tmp_add_arr($tmp_name,$indx,text) ""
      }
      set Post::($post_obj,Indep_add_arr) [array get tmp_add_arr]
      set Post::($post_obj,Indep_fmt_list) [lindex $Indep_fmt_list 0]
      set tmp_no [llength $Post::($post_obj,Indep_fmt_list)]
      array set tmp_fmt_arr [list]
      for { set kk 1 } { $kk <= $tmp_no } { incr kk } {
       set indx [expr $kk - 1]
       set tmp_fmt_arr($tmp_name,$indx,data) [lindex $Indep_fmt_list $kk]
       set tmp_fmt_arr($tmp_name,$indx,text) ""
      }
      set Post::($post_obj,Indep_fmt_arr) [array get tmp_fmt_arr]
      set Post::($post_obj,main_post_Output_VNC) $main_post_Output_VNC
      unset main_sys_var main_kin_var Indep_fmt_list Indep_add_list
      unset tmp_add_arr tmp_fmt_arr main_post_Output_VNC
     }
     continue
    }
    "## LISTING FILE START"          {
     set list_file_start 1
     continue
    }
    "## LISTING FILE END"            {
     set list_file_start 0
     if [info exists obj_attr] \
     {
      PB_lfl_CreateLfileObj obj_attr obj_list
      Post::ListFileObject $post_obj obj_list
      unset obj_attr
     }
     continue
    }
    "## KINEMATIC VARIABLES START"   {
     set kinematic_var_start 1
     if [info exists Post::($post_obj,mom_kin_var_list)] \
     {
      array set mom_kin_var $Post::($post_obj,mom_kin_var_list)
     }
     continue
    }
    "## KINEMATIC VARIABLES END"     {
     set kinematic_var_start 0
     if [info exists mom_kin_var] \
     {
      set Post::($post_obj,mom_kin_var_list) \
      [array get mom_kin_var]
      set Post::($post_obj,def_mom_kin_var_list) \
      [array get mom_kin_var]
      unset mom_kin_var
     }
     continue
    }
    "## MOM SIM VARIABLES START" {
     set mom_sim_var_start 1
     if [info exists Post::($post_obj,mom_sim_var_list)] \
     {
      array set mom_sim_arr $Post::($post_obj,mom_sim_var_list)
     }
     continue
    }
    "## MOM SIM VARIABLES END" {
     set mom_sim_var_start 0
     if [info exists mom_sim_arr] \
     {
      set Post::($post_obj,mom_sim_var_list) \
      [array get mom_sim_arr]
      set Post::($post_obj,def_mom_sim_var_list) \
      [array get mom_sim_arr]
      unset mom_sim_arr
     }
     continue
    }
    "## VNC COMMANDS START" {
     set mom_sim_cmd_start 1
     if ![info exists Post::($post_obj,mom_vnc_desc_list)] {
      set Post::($post_obj,mom_vnc_desc_list) [list]
     }
     array set vnc_desc_arr $Post::($post_obj,mom_vnc_desc_list)
     continue
    }
    "## VNC COMMANDS END" {
     set mom_sim_cmd_start 0
     if [info exists vnc_desc_arr] {
      set Post::($post_obj,mom_vnc_desc_list) [array get vnc_desc_arr]
     }
     continue
    }
    "## GCODES START"                {
     set gcode_start 1
     set gcd_ind 0
     if [info exists Post::($post_obj,g_codes)] \
     {
      array set g_codes       $Post::($post_obj,g_codes)
      array set g_codes_desc  $Post::($post_obj,g_codes_desc)
      set gcd_ind [array size g_codes]
      set len [llength $Post::($post_obj,g_codes)]
      for {set i 1} {$i < $len} {incr i 2} {
       set code [lindex $Post::($post_obj,g_codes) $i]
       set desc [lindex $Post::($post_obj,g_codes_desc) $i]
       set g_codes_arr($code) $desc
      }
     }
     continue
    }
    "## GCODES END"                  {
     set gcode_start 0
     if [info exists g_codes] \
     {
      Post::InitG-Codes $post_obj g_codes g_codes_desc
      unset g_codes
      unset g_codes_desc
      unset g_codes_arr
     }
     continue
    }
    "## MCODES START"                {
     set mcode_start 1
     set mcd_ind 0
     if [info exists Post::($post_obj,m_codes)] \
     {
      array set m_codes       $Post::($post_obj,m_codes)
      array set m_codes_desc  $Post::($post_obj,m_codes_desc)
      set mcd_ind [array size m_codes]
      set len [llength $Post::($post_obj,m_codes)]
      if $len {
       for {set i 1} {$i < $len} {incr i 2} {
        set code [lindex $Post::($post_obj,m_codes) $i]
        set desc [lindex $Post::($post_obj,m_codes_desc) $i]
        set m_codes_arr($code) $desc
       }
      }
     }
     continue
    }
    "## MCODES END"                  {
     set mcode_start 0
     if [info exists m_codes] {
      Post::InitM-Codes $post_obj m_codes m_codes_desc
      unset m_codes
      unset m_codes_desc
      unset m_codes_arr
     }
     continue
    }
    "## MASTER SEQUENCE START"       {
     set master_sequence_start 1
     set index -1
     set pre_index -1
     if [info exists Post::($post_obj,msq_word_param)] \
     {
      array set msq_word_param  $Post::($post_obj,msq_word_param)
      set msq_add_name          $Post::($post_obj,msq_add_name)
     }
     continue
    }
    "## MASTER SEQUENCE END"         {
     set master_sequence_start 0
     set index 0
     if [info exists new_msq_add_name] {
      if [info exists msq_add_name] {
       foreach msq $msq_add_name {
        lappend new_msq_add_name $msq
        set new_msq_word_param($msq) $msq_word_param($msq)
       }
       unset msq_add_name
       unset msq_word_param
      }
      Post::InitMasterSequence $post_obj new_msq_add_name \
      new_msq_word_param
      update idletasks
      unset new_msq_add_name
      unset new_msq_word_param
      if [info exists msq_add_name_buff] {
       unset msq_add_name_buff
      }
     }
     if [info exists msq_add_name_buff] \
     {
      set msq_add_name [concat $msq_add_name $msq_add_name_buff]
      unset msq_add_name_buff
     }
     if [info exists msq_add_name] \
     {
      Post::InitMasterSequence $post_obj msq_add_name \
      msq_word_param
      update idletasks
      unset msq_add_name
      unset msq_word_param
     }
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
     if { [info exists gPB(old_version_pui_idx)] } {
      set parse_old_block_modality_flag $gPB(parse_old_version_flag)
     }
     if { !$parse_old_block_modality_flag } {
      if { [info exists Post::($post_obj,blk_mod_list)] && \
      $Post::($post_obj,blk_mod_list) != "" } \
      {
       array set blk_mod_arr $Post::($post_obj,blk_mod_list)
      }
     }
     continue
    }
    "## BLOCK MODALITY END"          {
     set blk_mod_start 0
     if [info exists blk_mod_arr] \
     {
      if { $parse_old_block_modality_flag } {
       set Post::($post_obj,old_pui_blk_mod_list) [array get blk_mod_arr]
       } else {
       set Post::($post_obj,blk_mod_list) [array get blk_mod_arr]
      }
      unset blk_mod_arr
     } else \
     {
      if { $parse_old_block_modality_flag } {
       set Post::($post_obj,old_pui_blk_mod_list) ""
       } else {
       set Post::($post_obj,blk_mod_list) ""
      }
     }
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
     PB_pui_UpdateUsedElementExecAttr $post_obj current_event_list
     continue
    }
    "## EVENTS ELEMENT EXECUTION START" {
     set evt_elem_exec_start 1
     if { [info exists Post::($post_obj,evt_elem_exec_name_list)] && \
     $Post::($post_obj,evt_elem_exec_name_list) != "" } \
     {
      set exec_name_list $Post::($post_obj,evt_elem_exec_name_list)
      array set evt_elem_exec_arr $Post::($post_obj,evt_elem_exec_list)
     }
     continue
    }
    "## EVENTS ELEMENT EXECUTION END"  {
     set evt_elem_exec_start 0
     if [info exists exec_name_list] \
     {
      UI_PB_debug_ForceMsg "   +++++++   exec_name_list: $exec_name_list"
      UI_PB_debug_ForceMsg "   +++++++   evt_elem_exec_arr: [array get evt_elem_exec_arr]"
      set Post::($post_obj,evt_elem_exec_name_list) $exec_name_list
      set Post::($post_obj,evt_elem_exec_list) [array get evt_elem_exec_arr]
      unset exec_name_list
      unset evt_elem_exec_arr
     } else \
     {
      set Post::($post_obj,evt_elem_exec_name_list) ""
      set Post::($post_obj,evt_elem_exec_list) ""
     }
     continue
    }
    "## EVENTS USER INTERFACE START" {
     set evt_ui_start 1
     set inx 0
     set index -1
     if [info exists Post::($post_obj,ui_evt_name_lis)] \
     {
      array set ui_evt_name_arr \
      $Post::($post_obj,ui_evt_name_lis)
      array set ui_evt_itm_grp_mem_arr \
      $Post::($post_obj,ui_evt_itm_grp_mem_lis)
      set inx [array size ui_evt_name_arr]
     }
     continue
    }
    "## EVENTS USER INTERFACE END"   {
     set evt_ui_start 0
     set index 0
     if [info exists ui_evt_name_arr] \
     {
      set Post::($post_obj,ui_evt_name_lis) \
      [array get ui_evt_name_arr]
      set Post::($post_obj,ui_evt_itm_grp_mem_lis) \
      [array get ui_evt_itm_grp_mem_arr]
      unset ui_evt_name_arr
      unset ui_evt_itm_grp_mem_arr
     }
     continue
    }
    "## MOM SYS VARIABLES START" {
     set mom_sys_var_start 1
     set add_mom_indx 0
     set index -1
     set mom_var_found 0
     if [info exists Post::($post_obj,add_mom_var_list)] \
     {
      array set add_mom_var_list $Post::($post_obj,add_mom_var_list)
      set mom_var_found 1
     }
     if [info exists Post::($post_obj,add_name_list)] \
     {
      array set add_name_list $Post::($post_obj,add_name_list)
      set add_mom_indx [array size add_name_list]
      set len [llength $Post::($post_obj,add_name_list)]
      for {set i 1} {$i < $len} {incr i 2} {
       set add [lindex $Post::($post_obj,add_name_list) $i]
       if $mom_var_found {
        set var [lindex $Post::($post_obj,add_mom_var_list) $i]
        } else {
        set var [list]
       }
       set add_mom_var_arr($add,idx) [lindex $Post::($post_obj,add_name_list) [expr $i - 1]]
       set add_mom_var_arr($add,var) $var
      }
     }
     continue
    }
    "## MOM SYS VARIABLES END" {
     set mom_sys_var_start 0
     set index 0
     if [info exists add_name_list] \
     {
      array set mom_kin_var $Post::($post_obj,mom_kin_var_list)
      array set mom_sys_var_arr $Post::($post_obj,mom_sys_var_list)
      for {set i 0} {$i <= $add_mom_indx} {incr i} {
       if [info exists add_name_list($i)] {
        switch $add_name_list($i) {
         "G_feed" -
         "PB_Tcl_Var" -
         "PB_Rapid" -
         "PB_ZeroFmt" {
          foreach e $add_mom_var_list($i) {
           set var [lindex $e 0]
           set val [lindex $e 1]
           if { $var != "" && $val != "" } {
            if { ![ catch {eval format %s "$val"} res ] } {
             set mom_sys_var_arr($var) "$val"
            }
           }
          }
         }
        }
       }
      }
      for {set i 0} {$i <= $add_mom_indx} {incr i} {
       if [info exists add_name_list($i)] {
        switch $add_name_list($i) {
         "I" -
         "J" -
         "K" {
          if [info exists mom_sys_var_arr(\$mom_sys_cir_vector)] {
           set machine [string tolower $mom_kin_var(\$mom_kin_machine_type)]
           set mode $mom_sys_var_arr(\$mom_sys_cir_vector)
           if [UI_PB_tpth_SetIJKExpr $machine $mode expr_i expr_j expr_k] {
            UI_PB_tpth_SetIJKDesc $mode desc
            if 0 {
             switch $add_name_list($i) {
              "I" {
               set expr "$expr_i X-Axis"
              }
              "J" {
               if { ![string match "lathe" $machine] } {
                set expr "$expr_j Y-Axis"
                } else {
                set expr "Lathe Null Y-Axis"
               }
              }
              "K" {
               set expr "$expr_k Z-Axis"
              }
             }
            }
            switch $add_name_list($i) {
             "I" {
              set expr "$expr_i"
             }
             "J" {
              if { ![string match "lathe" $machine] } {
               set expr "$expr_j"
               } else {
               set expr "Lathe Null Y-Axis"
              }
             }
             "K" {
              set expr "$expr_k"
             }
            }
            set add_mom_var_list($i) [list]
            lappend add_mom_var_list($i) "\"$expr\""
            lappend add_mom_var_list($i) "\"\""
            lappend add_mom_var_list($i) "\"$desc\""
            set add_mom_var_list($i) [list [join $add_mom_var_list($i)]]
            if [string match "lathe" $machine] {
             switch $add_name_list($i) {
              "I" {
               lappend add_mom_var_list($i) \
               [list "\$mom_lathe_thread_lead_i" "" "$gPB(tool,ijk_desc,long_thread_lead,Label)"]
              }
              "K" {
               lappend add_mom_var_list($i) \
               [list "\$mom_lathe_thread_lead_k" "" "$gPB(tool,ijk_desc,tran_thread_lead,Label)"]
              }
             }
            }
           }
          }
         }
        }
        if 0 {
         switch $add_name_list($i) {
          "G_feed" -
          "PB_Tcl_Var" -
          "PB_Rapid" -
          "PB_ZeroFmt" {
           foreach e $add_mom_var_list($i) {
            set var [lindex $e 0]
            set val [lindex $e 1]
            if { $var != "" && $val != "" } {
             if { ![ catch {set val [eval format %s $val] } res ] } {
              set mom_sys_var_arr($var) $val
             }
            }
           }
          }
         }
        }
       }
      }
      set Post::($post_obj,mom_sys_var_list)     [array get mom_sys_var_arr]
      set Post::($post_obj,def_mom_sys_var_list) [array get mom_sys_var_arr]
      if 0 {{
       for {set i 0} {$i < 4} {incr i} {
        switch $i {
         0 { set add "G_feed" }
         1 { set add "PB_Tcl_Var" }
         2 { set add "PB_Rapid" }
         3 { set add "PB_ZeroFmt" }
        }
        PB_int_RetMOMVarAsscAddress add word_mom_var_list
        PB_int_RetMOMVarDescAddress add word_desc_list
        if [ info exists add_mom_var_arr($add,idx) ] \
        {
         foreach v $add_mom_var_arr($add,var) \
         {
          lappend word_mom_var_list [lindex $v 0]
          lappend word_desc_list [lindex $v 2]
         }
         set word_mom_var_list [ltidy $word_mom_var_list]
         set word_desc_list    [ltidy $word_desc_list]
        }
       }
       PB_int_UpdateMOMVarOfAddress   add word_mom_var_list
       PB_int_UpdateMOMVarDescAddress add word_desc_list
       unset word_mom_var_list
       unset word_desc_list
      }}
      set Post::($post_obj,add_name_list)    [array get add_name_list]
      set Post::($post_obj,add_mom_var_list) [array get add_mom_var_list]
      unset mom_kin_var
      unset add_name_list
      unset add_mom_var_list
      unset add_mom_var_arr
     }
     set add_mom_indx 0
     continue
    }
    "## FUNCTION INFO START" {
     set function_info_start 1
     continue
    }
    "## FUNCTION INFO END" {
     set function_info_start 0
     continue
    }
   }
   if { $event_handler } \
   {
    PB_com_RemoveBlanks line
    set file_type [lindex $line 0]
    set file_name [join [lrange $line 1 end] " "]
    switch $file_type \
    {
     def_file  { set post_files(def_file) $file_name }
     tcl_file  { set post_files(tcl_file) $file_name }
    }
   }
   if $post_info_start {
    switch -glob -- $line \
    {
     "#  DESCRIPTION START"  {
      set description_start 1
      set post_info ""
      continue
     }
     "#  DESCRIPTION END"    {
      set description_start 0
      set gPB(post_description) $post_info
      set gPB(post_description_default) $post_info
      unset post_info
      continue
     }
     "#  CONTROLLER START"   {
      set controller_start 1
      set post_info ""
      continue
     }
     "#  CONTROLLER END"     {
      set controller_start 0
      set gPB(post_controller) [join $post_info]
      unset post_info
      continue
     }
     "#  CONTROLLER TYPE START"   {
      set type_family_start 1
      set post_info ""
      continue
     }
     "#  CONTROLLER TYPE END"     {
      set type_family_start 0
      set gPB(post_controller_type) [join $post_info]
      unset post_info
      continue
     }
     "#  MACHINE AXIS START" {
      if { ![info exists gPB(machine_axis_type)] } {
       set machine_axis_start 1
      }
      set post_info ""
      continue
     }
     "#  MACHINE AXIS END"   {
      set machine_axis_start 0
      if { [string trim $post_info] != "" } {
       set gPB(machine_axis_type) [join $post_info]
      }
      unset post_info
      continue
     }
     "#  HISTORY START"      {
      if { ![info exists gPB(pui_ui_overwrite)] ||\
       $gPB(pui_ui_overwrite) == 0 } {
       set history_start 1
      }
      set post_info ""
      continue
     }
     "#  HISTORY END"        {
      set history_start 0
      set gPB(post_history) $post_info
      if 0 { ;# Well, we'll just put PUI version back to PB version to resolve the dilemma.
       set last_save [lindex $post_info end]
       if { [string match "Saved with *" $last_save] ||\
        [string match "Created with *" $last_save] } {
        UI_PB_debug_ForceMsg "   %%%%%%%%%%%%%%%%%  $last_save ==> [llength $last_save] elements"
        set vi [expr [lsearch $last_save "on"] - 1]
       }
      }
      unset post_info
      continue
     }
    }
    if { $description_start || $controller_start || $history_start || $type_family_start || $machine_axis_start } {
     lappend post_info $line
    }
   }
   if { $main_post_data_start } \
   {
    set [lindex $line 0] [lindex $line 1]
   }
   if { $list_file_start } \
   {
    PB_com_RemoveBlanks line
    set Name [lindex $line 0]
    set Value [lindex $line 1]
    switch $Name \
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
     Listfileflag_usertcl_check {set obj_attr(usertcl_check) $Value}
     Listfileflag_usertcl_name  {set obj_attr(usertcl_name) $Value}
     Listfileflag_verbose       {set obj_attr(verbose) $Value}
     Listfileflag_use_default_unit_fragment {set obj_attr(use_default_unit_fragment) $Value}
     Listfileflag_alt_unit_post_name {set obj_attr(alt_unit_post_name) $Value}
    }
   }
   if { $kinematic_var_start } \
   {
    set var [lindex $line 0]
    if { [string index $var 0] != "\$" } {
     set var [format %s%s "\$" $var]
    }
    set mom_kin_var($var) [lindex $line 1]
   }
   if { $mom_sim_var_start } \
   {
    set var [lindex $line 0]
    if { [string index $var 0] != "\$" } {
     set var [format %s%s "\$" $var]
    }
    set mom_sim_arr($var) [lindex $line 1]
   }
   if { $mom_sim_cmd_start } {
    foreach item $line {
     set cmd_name [lindex $item 0]
     set cmd_desc [lindex $item 2]
     set vnc_desc_arr($cmd_name,desc) $cmd_desc
    }
    set Post::($post_obj,mom_vnc_desc_list) [array get vnc_desc_arr]
   }
   if { $gcode_start } \
   {
    set var [lindex $line 0]
    if { [info exists gPB(action)] && ![string compare "new" $gPB(action)] } {
     if { [string match "Inches" $output_unit] } {
      if { [string match "*(MMPM)*" $var] || [string match "*(MMPR)*" $var] } {
       UI_PB_debug_ForceMsg "   %%%%%%%%%%%%%%%%%  MMPM & MMPR feedrate mode excluded from Inch posts"
       continue
      }
      } else {
      if { [string match "*(IPM)*" $var] || [string match "*(IPR)*" $var] } {
       UI_PB_debug_ForceMsg "   %%%%%%%%%%%%%%%%%  IPM & IPR feedrate mode excluded from Metric posts"
       continue
      }
     }
     if 0 {
      if { ![string compare "3" $mach_axis] } {
       if { [string match "*(DPM)*" $var] || [string match "*(FRN)*" $var] || [string match "*(INV)*" $var] } {
        UI_PB_debug_ForceMsg "   %%%%%%%%%%%%%%%%%  DPM & FRN feedrate mode excluded from 3-axis posts"
        continue
       }
      }
      } else {
      if { ![string compare "3" $mach_axis] } {
       if { [string match "*(DPM)*" $var] } {
        UI_PB_debug_ForceMsg "   %%%%%%%%%%%%%%%%%  DPM feedrate mode excluded from 3-axis posts"
        continue
       }
      }
     }
    }
    set addr_name ""
    UI_PB_mthd_GetAddName $var G addr_name
    if { [string compare $addr_name ""] } {
     if { ![info exists gPB(addr_expr,$addr_name)] ||\
      [lsearch -exact $gPB(addr_expr,$addr_name) $var] == -1 } {
      lappend gPB(addr_expr,$addr_name) $var
     }
    }
    if { ![string match "*cycle_breakchip*" $var] } {
     if { ![info exists g_codes_arr($var)] } {
      set g_codes($gcd_ind)  [lindex $line 0]
      if ![string match {$*} [lindex $line 1]] {
       set text [UI_PB_prv_TransEventName [lindex $line 0] [lindex $line 1] 1]
       } else {
       set text [lindex $line 1]
      }
      set g_codes_desc($gcd_ind) $text
      incr gcd_ind
      set g_codes_arr($var) $text
     }
    }
   }
   if { $mcode_start } \
   {
    set var [lindex $line 0]
    set addr_name ""
    UI_PB_mthd_GetAddName $var M addr_name
    if { [string compare $addr_name ""] } {
     if { ![info exists gPB(addr_expr,$addr_name)] ||\
      [lsearch -exact $gPB(addr_expr,$addr_name) $var] == -1 } {
      lappend gPB(addr_expr,$addr_name) $var
     }
    }
    if { ![info exists m_codes_arr($var)] } {
     set m_codes($mcd_ind)  [lindex $line 0]
     set m_codes_desc($mcd_ind) [lindex $line 1]
     incr mcd_ind
     set m_codes_arr($var) [lindex $line 1]
    }
   }
   if { $master_sequence_start } \
   {
    set mseq [lindex $line 0]
    if [info exists msq_add_name] \
    {
     set index [lsearch $msq_add_name "$mseq"]
    }
    if { [info exists gPB(pui_ui_overwrite)]  &&  !$gPB(pui_ui_overwrite) } {
     lappend new_msq_add_name $mseq
     if [info exists msq_word_param($mseq)] {
      set msq_param $msq_word_param($mseq)
      unset msq_word_param($mseq)
      set msq_add_name [lreplace $msq_add_name $index $index]
      } else {
      if { [llength $line] == 5 } {
       lappend msq_param [lindex $line 1] [lindex $line 2] [lindex $line 3] [lindex $line 4]
       } else {
       lappend msq_param [lindex $line 1] [lindex $line 2] [lindex $line 3]
       lappend msq_param 0
      }
     }
     set msq_param [lreplace $msq_param 1 1 [lindex $line 2]]
     set new_msq_word_param($mseq) $msq_param
     } else {
     if { $index < 0 } \
     {
      if { [llength $line] == 5 } \
      {
       lappend msq_add_name_buff $mseq
       lappend msq_param [lindex $line 1] [lindex $line 2] \
       [lindex $line 3] [lindex $line 4]
      }
      if { [llength $line] == 4 } \
      {
       lappend msq_add_name_buff $mseq
       lappend msq_param [lindex $line 1] [lindex $line 2] [lindex $line 3]
       lappend msq_param 0
      }
     } else \
     {
      if { $index < $pre_index } \
      {
       set msq_add_name [lreplace $msq_add_name $index $index]
       set msq_add_name [linsert $msq_add_name $pre_index $mseq]
       set index [lsearch $msq_add_name $mseq]
      }
      if [info exists msq_add_name_buff] \
      {
       set ml [llength $msq_add_name_buff]
       for {set mi [expr $ml - 1]} {$mi > -1} {incr mi -1} \
       {
        set me [lindex $msq_add_name_buff $mi]
        set msq_add_name [linsert $msq_add_name $index $me]
       }
       unset msq_add_name_buff
       set index [lsearch $msq_add_name $mseq]
      }
      if { [llength $line] == 5 } \
      {
       lappend msq_param [lindex $line 1] [lindex $line 2] \
       [lindex $line 3] [lindex $line 4]
      }
     }
     if [info exists msq_param] \
     {
      set msq_word_param($mseq) $msq_param
     }
     set pre_index $index
    }
    if [info exists msq_param] \
    {
     unset msq_param
    }
   }
   if { $blk_mod_start } \
   {
    set blk_mod_arr([lindex $line 0]) [lindex $line 1]
   }
   if { $comp_blk_start } \
   {
    if [info exists Post::($post_obj,comp_blk_list)] \
    {
     set Post::($post_obj,comp_blk_list) \
     [PB_com_MergeLists $Post::($post_obj,comp_blk_list) $line]
    } else \
    {
     set Post::($post_obj,comp_blk_list) $line
    }
   }
   if { $cycle_evt_start } \
   {
    switch -glob -- "$line" \
    {
     "#Cycle Common Block Start"              {
      set cycle_com_evt_start 1
      continue
     }
     "#Cycle Common Block End"                {
      set cycle_com_evt_start 0
      if [info exists cycle_common_evt] \
      {
       set Post::($post_obj,cyl_com_evt) \
       $cycle_common_evt
      }
      continue
     }
     "#Cycle Block Share Common Block Start"  {
      set cycle_share_evt_start 1
      continue
     }
     "#Cycle Block Share Common Block End"    {
      set cycle_share_evt_start 0
      if [info exists cycle_shared_evts] \
      {
       set Post::($post_obj,cyl_evt_sh_com_evt) \
       $cycle_shared_evts
      }
      continue
     }
    }
    if { $cycle_com_evt_start } \
    {
     set cycle_common_evt $line
    }
    if { $cycle_share_evt_start } \
    {
     if { [info exists Post::($post_obj,cyl_evt_sh_com_evt)] && \
     [llength $Post::($post_obj,cyl_evt_sh_com_evt)] > 0 } \
     {
      set cycle_shared_evts $Post::($post_obj,cyl_evt_sh_com_evt)
      } else {
      set cycle_shared_evts $line
     }
    }
   }
   if { $glob_sequence_start } \
   {
    switch -glob -- "$line" \
    {
     "#Program Start Sequence Start"     {
      set prog_start_seq 1
      set index 0
      if $merge_marker {
       if [info exists Post::($post_obj,prog_start_evt_list)] {
        array set evt_name_arr  $Post::($post_obj,prog_start_evt_list)
        array set evt_blk_arr   $Post::($post_obj,prog_start_evt_blk_list)
        array set evt_label_arr $Post::($post_obj,prog_start_label_list)
        set index [expr [llength $Post::($post_obj,prog_start_evt_list)] / 2]
        for { set i 0 } { $i < $index } { incr i } {
         set evt [join [split $evt_name_arr($i)] _]
         set Marker($evt,blk_list) $evt_blk_arr($i)
         set Marker($evt,index)    $i
        }
       }
      }
      continue
     }
     "#Program Start Sequence End"       {
      set prog_start_seq 0
      set Post::($post_obj,prog_start_evt_list) \
      [array get evt_name_arr]
      set Post::($post_obj,prog_start_label_list) \
      [array get evt_label_arr]
      set Post::($post_obj,prog_start_evt_blk_list) \
      [array get evt_blk_arr]
      if [info exists evt_name_arr] \
      {
       unset evt_name_arr
       unset evt_label_arr
       unset evt_blk_arr
      }
      continue
     }
     "#Operation Start Sequence Start"   {
      set oper_start_seq 1
      set index 0
      if $merge_marker {
       if [info exists Post::($post_obj,oper_start_evt_list)] {
        array set evt_name_arr  $Post::($post_obj,oper_start_evt_list)
        array set evt_blk_arr   $Post::($post_obj,oper_start_evt_blk_list)
        array set evt_label_arr $Post::($post_obj,oper_start_label_list)
        set index [expr [llength $Post::($post_obj,oper_start_evt_list)] / 2]
        for { set i 0 } { $i < $index } { incr i } {
         set evt [join [split $evt_name_arr($i)] _]
         set Marker($evt,blk_list) $evt_blk_arr($i)
         set Marker($evt,index)    $i
        }
       }
      }
      continue
     }
     "#Operation Start Sequence End"     {
      set oper_start_seq 0
      if [info exists evt_name_arr] \
      {
       set Post::($post_obj,oper_start_evt_list) \
       [array get evt_name_arr]
       set Post::($post_obj,oper_start_label_list) \
       [array get evt_label_arr]
       set Post::($post_obj,oper_start_evt_blk_list) \
       [array get evt_blk_arr]
       unset evt_name_arr
       unset evt_label_arr
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
      if $merge_marker {
       if [info exists Post::($post_obj,oper_end_evt_list)] {
        array set evt_name_arr  $Post::($post_obj,oper_end_evt_list)
        array set evt_blk_arr   $Post::($post_obj,oper_end_evt_blk_list)
        array set evt_label_arr $Post::($post_obj,oper_end_label_list)
        set index [expr [llength $Post::($post_obj,oper_end_evt_list)] / 2]
        for { set i 0 } { $i < $index } { incr i } {
         set evt [join [split $evt_name_arr($i)] _]
         set Marker($evt,blk_list) $evt_blk_arr($i)
         set Marker($evt,index)    $i
        }
       }
      }
      continue
     }
     "#Operation End Sequence End"       {
      set oper_end_seq 0
      if [info exists evt_name_arr] \
      {
       set Post::($post_obj,oper_end_evt_list) \
       [array get evt_name_arr]
       set Post::($post_obj,oper_end_label_list) \
       [array get evt_label_arr]
       set Post::($post_obj,oper_end_evt_blk_list) \
       [array get evt_blk_arr]
       unset evt_name_arr
       unset evt_label_arr
       unset evt_blk_arr
      }
      continue
     }
     "#Program End Sequence Start"       {
      set prog_end_seq 1
      set index 0
      if $merge_marker {
       if [info exists Post::($post_obj,prog_end_evt_list)] {
        array set evt_name_arr  $Post::($post_obj,prog_end_evt_list)
        array set evt_blk_arr   $Post::($post_obj,prog_end_evt_blk_list)
        array set evt_label_arr $Post::($post_obj,prog_end_label_list)
        set index [expr [llength $Post::($post_obj,prog_end_evt_list)] / 2]
        for { set i 0 } { $i < $index } { incr i } {
         set evt [join [split $evt_name_arr($i)] _]
         set Marker($evt,blk_list) $evt_blk_arr($i)
         set Marker($evt,index)    $i
        }
       }
      }
      continue
     }
     "#Program End Sequence End"         {
      set prog_end_seq 0
      if [info exists evt_name_arr] \
      {
       set Post::($post_obj,prog_end_evt_list) \
       [array get evt_name_arr]
       set Post::($post_obj,prog_end_label_list) \
       [array get evt_label_arr]
       set Post::($post_obj,prog_end_evt_blk_list) \
       [array get evt_blk_arr]
       unset evt_name_arr
       unset evt_label_arr
       unset evt_blk_arr
      }
      continue
     }
     "#Linked Posts Sequence Start"     {
      set linked_posts_seq 1
      set index 0
      set Post::($post_obj,linked_posts_evt_list)     [list]
      set Post::($post_obj,linked_posts_evt_blk_list) [list]
      set Post::($post_obj,linked_posts_label_list)   [list]
      if $merge_marker {
       if [info exists Post::($post_obj,linked_posts_evt_list)] {
        array set evt_name_arr  $Post::($post_obj,linked_posts_evt_list)
        array set evt_blk_arr   $Post::($post_obj,linked_posts_evt_blk_list)
        array set evt_label_arr $Post::($post_obj,linked_posts_label_list)
        set index [expr [llength $Post::($post_obj,linked_posts_evt_list)] / 2]
        for { set i 0 } { $i < $index } { incr i } {
         set evt [join [split $evt_name_arr($i)] _]
         set Marker($evt,blk_list) $evt_blk_arr($i)
         set Marker($evt,index)    $i
        }
       }
      }
      continue
     }
     "#Linked Posts Sequence End"       {
      set linked_posts_seq 0
      if [info exists evt_name_arr] \
      {
       set Post::($post_obj,linked_posts_evt_list) \
       [array get evt_name_arr]
       set Post::($post_obj,linked_posts_label_list) \
       [array get evt_label_arr]
       set Post::($post_obj,linked_posts_evt_blk_list) \
       [array get evt_blk_arr]
       unset evt_name_arr
       unset evt_label_arr
       unset evt_blk_arr
      }
      continue
     }
     "#Virtual NC Sequence Start" { ;#<03-12-03 gsl> IS&V VNC
      set vnc_seq 1
      set index 0
      continue
     }
     "#Virtual NC Sequence End" {
      set vnc_seq 0
      if [info exists evt_name_arr] \
      {
      }
      continue
     }
    }
    if { $prog_start_seq || $oper_start_seq || $oper_end_seq || $prog_end_seq }\
    {
     set evt_name [lindex $line 0]
     if { ![string compare "Start Of Pass"  $evt_name] } { set evt_name "Start of Pass"  }
     if { ![string compare "End Of Program" $evt_name] } { set evt_name "End of Program" }
     if { [llength $line] == 3 } {
      set evt_label [lindex $line 2]
      if { ![string compare "Start Of Pass"  $evt_label] } { set evt_label "Start of Pass"  }
      if { ![string compare "End Of Program" $evt_label] } { set evt_label "End of Program" }
     }
     lappend current_event_list $evt_name
     set evt [join [split $evt_name] _]
     if { $merge_marker && \
      [info exists Marker($evt,blk_list)] } {
      set idx $Marker($evt,index)
      set blk_list $Marker($evt,blk_list)
      foreach blk [lindex $line 1] {
       lappend blk_list $blk
      }
      set evt_blk_arr($idx) $blk_list
      } else {
      set evt_name_arr($index) $evt_name
      set evt_blk_arr($index)  [lindex $line 1]
      set evt_label_arr($index) $evt_name
      if { [llength $line] == 3  &&  [string length [lindex $line 2]] } {
       if ![string match {$gPB*} [lindex $line 2]] {
        set evt_label_arr($index) [UI_PB_prv_TransEventName $evt_name $evt_label 1]
        } else {
        set evt_label_arr($index) $evt_label
       }
      }
      incr index
     }
     } elseif { $tool_path_seq } \
    {
     switch -glob -- "$line" \
     {
      "#Control Functions Start"          {
       set tpth_ctrl_seq 1
       set index 0
       set merger_ude_items 0
       if [info exists Post::($post_obj,tpth_ctrl_evt_ude_list)] {
        set merger_ude_items 1
        set prev_list $Post::($post_obj,tpth_ctrl_evt_ude_list)
       }
       array set mom_kin_var $Post::($post_obj,mom_kin_var_list)
       if [string match "*_wedm" [string tolower $mom_kin_var(\$mom_kin_machine_type)]] {
        if { [info exists Post::($post_obj,tpth_ctrl_evt_list)] } {
         array set evt_name_arr  $Post::($post_obj,tpth_ctrl_evt_list)
         array set evt_label_arr $Post::($post_obj,tpth_ctrl_label_list)
         array set evt_blk_arr   $Post::($post_obj,tpth_ctrl_evt_blk_list)
         array set evt_ude_arr   $Post::($post_obj,tpth_ctrl_evt_ude_list)
         set index [array size evt_name_arr]
        }
       }
       PB_com_unset_var mom_kin_var
       continue
      }
      "#Control Functions End"            {
       set tpth_ctrl_seq 0
       if [info exists evt_name_arr] \
       {
        set Post::($post_obj,tpth_ctrl_evt_list) \
        [array get evt_name_arr]
        set Post::($post_obj,tpth_ctrl_label_list) \
        [array get evt_label_arr]
        set Post::($post_obj,tpth_ctrl_evt_blk_list) \
        [array get evt_blk_arr]
        global mach_cntl_type
        if [info exists ::mach_cntl_type] {
         if { $mach_cntl_type == "User" } {
          set merger_ude_items 0
         }
        }
        if $merger_ude_items {
         array set prev_arr $prev_list
         if { [array size evt_ude_arr] > [array size prev_arr] } {
          set Post::($post_obj,tpth_ctrl_evt_ude_list) \
          [array get evt_ude_arr]
          } else {
          set Post::($post_obj,tpth_ctrl_evt_ude_list) \
          $prev_list
         }
         } else {
         set Post::($post_obj,tpth_ctrl_evt_ude_list) \
         [array get evt_ude_arr]
        }
        PB_com_unset_var evt_name_arr
        PB_com_unset_var evt_label_arr
        PB_com_unset_var evt_blk_arr
        PB_com_unset_var evt_ude_arr
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
       if [info exists evt_name_arr] \
       {
        set Post::($post_obj,tpth_mot_evt_list) \
        [array get evt_name_arr]
        set Post::($post_obj,tpth_mot_label_list) \
        [array get evt_label_arr]
        set Post::($post_obj,tpth_mot_evt_blk_list) \
        [array get evt_blk_arr]
        unset evt_name_arr
        unset evt_label_arr
        unset evt_blk_arr
       }
       continue
      }
      "#Cycles Start"                     {
       set tpth_cycle_seq 1
       set index 0
       if {[info exists Post::($post_obj,tpth_cycle_evt_list)]} {
        array set evt_name_arr $Post::($post_obj,tpth_cycle_evt_list)
        array set evt_label_arr $Post::($post_obj,tpth_cycle_label_list)
        array set evt_blk_arr $Post::($post_obj,tpth_cycle_evt_blk_list)
        set index [array size evt_name_arr]
       }
       continue
      }
      "#Cycles End"                       {
       set tpth_cycle_seq 0
       if [info exists evt_name_arr] \
       {
        set Post::($post_obj,tpth_cycle_evt_list) \
        [array get evt_name_arr]
        set Post::($post_obj,tpth_cycle_label_list) \
        [array get evt_label_arr]
        set Post::($post_obj,tpth_cycle_evt_blk_list) \
        [array get evt_blk_arr]
        unset evt_name_arr
        unset evt_blk_arr
        unset evt_label_arr
       }
       continue
      }
      "#Misc Start"                       {
       set tpth_misc_seq 1
       set index 0
       if { ![info exists Post::($post_obj,tpth_misc_evt_list)] } {
        set Post::($post_obj,tpth_misc_evt_list)     [list]
        set Post::($post_obj,tpth_misc_label_list)   [list]
        set Post::($post_obj,tpth_misc_evt_blk_list) [list]
       }
       continue
      }
      "#Misc End"                         {
       set tpth_misc_seq 0
       if [info exists evt_name_arr] \
       {
        set Post::($post_obj,tpth_misc_evt_list) \
        [array get evt_name_arr]
        set Post::($post_obj,tpth_misc_label_list) \
        [array get evt_label_arr]
        set Post::($post_obj,tpth_misc_evt_blk_list) \
        [array get evt_blk_arr]
        unset evt_name_arr
        unset evt_blk_arr
        unset evt_label_arr
       }
       continue
      }
     }
     if { $tpth_ctrl_seq || $tpth_mot_seq || $tpth_cycle_seq || $tpth_misc_seq } \
     {
      set evt_name [lindex $line 0]
      if { ![string compare "Set Mode" $evt_name] } { set evt_name "Set Modes" }
      if { [lsearch $current_event_list "$evt_name"] < 0 } {
       lappend current_event_list "$evt_name"
      }
      if { [info exists evt_name_arr] } {
       foreach item [array names evt_name_arr] {
        if { ![string compare $evt_name_arr($item) "$evt_name"] } {
         set index $item
         break
        }
       }
      }
      set evt_name_arr($index) $evt_name
      if { [lsearch $gPB(no_output_events_list) "$evt_name"] < 0 } {
       set evt_blk_arr($index) [lindex $line 1]
       } else {
       set evt_blk_arr($index) {}
      }
      set evt_label_arr($index) [lindex $line 0]
      if { [llength $line] >= 3  &&  [string length [lindex $line 2]] } \
      {
       if ![string match {$gPB*} [lindex $line 2]] {
        set evt_label_arr($index) [UI_PB_prv_TransEventName $evt_name [lindex $line 2] 1]
        } else {
        set evt_label_arr($index) [lindex $line 2]
       }
      }
      if $tpth_ctrl_seq {
       set evt_ude_arr($index) [lindex $line 3]
      }
      if { $::env(PB_UDE_ENABLED) == 0 } {
       if $tpth_cycle_seq {
        set exist_cycle_event [list {Cycle Parameters} {Cycle Off} \
        {Cycle Plane Change} {Drill} \
        {Drill Dwell} {Drill Text} {Drill Csink} {Drill Deep} {Drill Break Chip} \
        {Tap} {Bore} {Bore Dwell} {Bore Drag} {Bore No Drag} {Bore Back} \
        {Bore Manual} {Bore Manual Dwell} {Peck Drill} {Break Chip} \
        {Tap Float} {Thread} {Lathe Roughing} {Tap Deep} {Tap Break Chip}]
        if { [lsearch $exist_cycle_event $evt_name] < 0 } {
         unset evt_blk_arr($index)
         unset evt_label_arr($index)
         unset evt_name_arr($index)
         } else {
         incr index
        }
       }
       if $tpth_ctrl_seq {
        set exist_mce_event [list {Tool Change} {Length Compensation} {Spindle RPM} \
        {Spindle Off} {Coolant On} {Coolant Off} {Inch Metric Mode} \
        {Feedrates} {Cutcom On} {Cutcom Off} {Delay} {Opstop} {Auxfun} \
        {Prefun} {Load Tool} {Stop} {Tool Preselect} {Set Modes} \
        {Spindle CSS} {Thread Wire} {Cut Wire} {Set Mode} {Wire Guides}]
        if { [lsearch $exist_mce_event $evt_name] < 0 } {
         unset evt_blk_arr($index)
         unset evt_label_arr($index)
         unset evt_name_arr($index)
         unset evt_ude_arr($index)
         } else {
         incr index
        }
       }
       if $tpth_mot_seq {
        incr index
       }
       if $tpth_misc_seq {
        incr index
       }
       } else {
       incr index
      }
     }
     } elseif { $linked_posts_seq } \
    {
     set evt_name [lindex $line 0]
     set evt_name_arr($index) $evt_name
     lappend current_event_list "$evt_name"
     if { [lsearch $gPB(no_output_events_list) "$evt_name"] < 0 } {
      set evt_blk_arr($index) [lindex $line 1]
      } else {
      set evt_blk_arr($index) {}
     }
     set evt_label_arr($index) [lindex $line 0]
     if { [llength $line] == 3  &&  [string length [lindex $line 2]] } {
      set evt_label_arr($index) [lindex $line 2]
     }
     incr index
    }
   }
   if { $evt_elem_exec_start } \
   {
    set evar [lindex $line 0]
    if { ![string compare "Start Of Pass"  $evar] } { set evar "Start of Pass"  }
    if { ![string compare "End Of Program" $evar] } { set evar "End of Program" }
    set index -1
    if { ! [info exists exec_name_list] } \
    {
     lappend exec_name_list "$evar"
     set evt_elem_exec_arr(0) [lrange $line 1 end]
    } else \
    {
     set index [lsearch $exec_name_list "$evar"]
     if { $index != -1 } \
     {
      set evt_elem_exec_arr($index) [lrange $line 1 end]
     } else \
     {
      set index [llength $exec_name_list]
      lappend exec_name_list "$evar"
      set evt_elem_exec_arr($index) [lrange $line 1 end]
     }
    }
   }
   if { $evt_ui_start } \
   {
    set evar [lindex $line 0]
    set index -1
    if [info exists ui_evt_name_arr] \
    {
     foreach e [array names ui_evt_name_arr] \
     {
      if { $evar == $ui_evt_name_arr($e) } \
      {
       set index $e
       break
      }
     }
    }
    if { $evar != "" } \
    {
     if { $index == -1 } \
     {
      set ui_evt_name_arr($inx) $evar
      if [string length [lindex $line 1]] \
      {
       set ui_evt_itm_grp_mem_arr($inx) [lrange $line 1 end]
      }
      incr inx
     } else \
     {
      if { [info exists gPB(pui_ui_overwrite)]  &&  $gPB(pui_ui_overwrite) } {
       set ui_evt_itm_grp_mem_arr($index) [lrange $line 1 end]
      }
     }
    }
   }
   if { $mom_sys_var_start } \
   {
    set mvar [lindex $line 0]
    set index -1
    set line_val [lrange $line 1 end]
    if { [info exists gPB(action)] && ![string compare "new" $gPB(action)] } {
     if [string match "G_feed" $mvar] {
      set tmp_line [list]
      lappend tmp_line [lindex $line_val 0]
      for { set idx 1 } { $idx < [llength $line_val] } { incr idx } {
       set elmt [lindex $line_val $idx]
       if { [string match "Inches" $output_unit] } {
        if { [string match "*(MMPM)*" $elmt] || [string match "*(MMPR)*" $elmt] } {
         UI_PB_debug_ForceMsg "   ================>  Remove MMPM & MMPR elements of G_feed from Inch posts"
         set elmt ""
        }
        } else {
        if { [string match "*(IPM)*" $elmt] || [string match "*(IPR)*" $elmt] } {
         UI_PB_debug_ForceMsg "   ================>  Remove IPM & IPR elements of G_feed from Metric posts"
         set elmt ""
        }
       }
       if 0 {
        if { ![string compare "3" $mach_axis] } {
         if { [string match "*(DPM)*" $elmt] || [string match "*(FRN)*" $elmt] || [string match "*(INV)*" $elmt] } {
          UI_PB_debug_ForceMsg "   ================>  Remove DPM & FRN elements of G_feed from 3-axis posts"
          set elmt ""
         }
        }
        } else {
        if { ![string compare "3" $mach_axis] } {
         if { [string match "*(DPM)*" $elmt] } {
          UI_PB_debug_ForceMsg "   ================>  Remove DPM elements of G_feed from 3-axis posts"
          set elmt ""
         }
        }
       }
       if { [string length $elmt] > 0 } {
        lappend tmp_line $elmt
       }
       unset elmt
      }
      set line_val $tmp_line
      unset tmp_line
     }
    }
    if { ![info exists add_mom_var_arr($mvar,var)] } \
    {
     set add_name_list($add_mom_indx) $mvar
     set add_mom_var_list($add_mom_indx) $line_val
     set add_mom_var_arr($mvar,var) $add_mom_var_list($add_mom_indx)
     set add_mom_var_arr($mvar,idx) $add_mom_indx
     incr add_mom_indx
     } elseif { [llength $add_mom_var_arr($mvar,var)] == 0 } \
    {
     set index add_mom_var_arr($mvar,idx)
     set add_mom_var_list($index) $line_val
     set add_mom_var_arr($mvar,var) $add_mom_var_list($index)
    } else \
    {
     set index $add_mom_var_arr($mvar,idx)
     set res_list [PB_com_MergeListsOfMultiples 3 $add_mom_var_list($index) $line_val]
     set add_mom_var_list($index) $res_list
     set add_mom_var_arr($mvar,var) $add_mom_var_list($index)
    }
   } ;# mom_sys_var_start
   if { $function_info_start } \
   {
    set func_id [lindex $line 0]
    set func_attr_list [lindex $line 1]
    set param_attr_list [lindex $line 2]
    PB_pui_CreateFunctionObj post_obj func_id func_attr_list param_attr_list
   }
  } ;# while reading each line
 }

#=======================================================================
proc PB_pui_WritePuiFile { OUTPUT_PUI_FILE } {
  upvar $OUTPUT_PUI_FILE pui_file
  global post_object
  global gPB
  set alter_unit_sub_post 0
  if { [info exist ::env(SUB_POST_MODE)] && $::env(SUB_POST_MODE) == 1 } \
  {
   if { [info exists ::env(UNIT_SUB_POST_MODE)] && $::env(UNIT_SUB_POST_MODE) == 1 } {
    set alter_unit_sub_post 1
   }
  }
  set puifid [PB_file_configure_output_file "$pui_file"]
  puts $puifid "## POSTBUILDER_VERSION=$gPB(Postbuilder_PUI_Version)"
  puts $puifid "##############################################################################"
  puts $puifid "#                                                                            #"
  puts $puifid "#  This file is used by Post Builder to edit the parameters associated       #"
  puts $puifid "#  with a specific post processor.                                           #"
  puts $puifid "#                                                                            #"
  puts $puifid "#                                                                            #"
  puts $puifid "#  <WARNING> The contents of this file should not be modified!               #"
  puts $puifid "#                                                                            #"
  puts $puifid "##############################################################################"
  global env
  set time_string [clock format [clock seconds] -format "%c %Z"]
  puts $puifid "#  Created by $env(USERNAME) @ $time_string"
  puts $puifid "#  with Post Builder version $gPB(Postbuilder_Release_Version)."
  puts $puifid "#============================================================================#"
  puts $puifid "\n"
  Post::ReadPostOutputFiles $post_object dir out_pui_file def_file tcl_file
  puts $puifid "## POST EVENT HANDLER START"
  if { !$alter_unit_sub_post } {
   puts $puifid "def_file  $def_file"
  }
  puts $puifid "tcl_file  $tcl_file"
  puts $puifid "## POST EVENT HANDLER END"
  puts $puifid "\n"
  puts $puifid "## POST INFORMATION START"
  puts $puifid "#  DESCRIPTION START"
  if [info exists gPB(post_description)] {
   foreach s $gPB(post_description) {
    puts $puifid "$s"
   }
  }
  puts $puifid "#  DESCRIPTION END"
  puts $puifid "#  CONTROLLER START"
  puts $puifid "[join $gPB(post_controller)]"
  puts $puifid "#  CONTROLLER END"
  puts $puifid "#  CONTROLLER TYPE START"
  if { [info exists gPB(post_controller_type)] && \
   $gPB(post_controller_type) != "" } {
   puts $puifid "[join $gPB(post_controller_type)]"
  }
  puts $puifid "#  CONTROLLER TYPE END"
  if { [info exists gPB(machine_axis_type)] } {
   puts $puifid "#  MACHINE AXIS START"
   puts $puifid "[join $gPB(machine_axis_type)]"
   puts $puifid "#  MACHINE AXIS END"
   unset gPB(machine_axis_type)
  }
  puts $puifid "#  HISTORY START"
  foreach s $gPB(post_history) {
   puts $puifid "$s"
  }
  puts $puifid "#  HISTORY END"
  if { $alter_unit_sub_post } {
   puts $puifid "#  MAIN POST START"
   puts $puifid "[file tail $gPB(main_post)]"
   puts $puifid "#  MAIN POST END"
   puts $puifid "#  POST TYPE START"
   puts $puifid "Alternate Unit Subordinate"
   puts $puifid "#  POST TYPE END"
  }
  puts $puifid "## POST INFORMATION END"
  puts $puifid "\n"
  if [PB_file_is_JE_POST_DEV] {
   puts $puifid "## JE_POST_DEV TRUE ##"
   puts $puifid "\n"
  }
  if { $alter_unit_sub_post } {
   puts $puifid "## ALTER UNIT SUB POST DEF INFO START"
   puts $puifid "FORMATTING"
   puts $puifid "\{"
    puts $puifid "################ FORMAT DECLARATIONS #################"
    PB_int_RetFormatObjList fmt_obj_list
    foreach fmt_obj $fmt_obj_list\
    {
     set fmt_name $format::($fmt_obj,for_name)
     format::readvalue $fmt_obj fmt_obj_attr
     PB_fmt_RetFmtFrmAttr fmt_obj_attr for_value
     puts $puifid "  FORMAT $fmt_name $for_value"
    }
    puts $puifid "\n"
    puts $puifid "################ ADDRESS DECLARATIONS ################"
    PB_int_RetAddressObjList add_obj_list
    PB_output_GetAdrObjAttr add_obj_list adr_name_arr adr_val_arr
    set no_adds [array size adr_name_arr]
    for { set count 0 } { $count < $no_adds } { incr count } \
    {
     puts $puifid "  ADDRESS $adr_name_arr($count) "
     puts $puifid "  \{"
      set no_lines [llength $adr_val_arr($count)]
      for {set jj 0} {$jj < $no_lines} {incr jj} \
      {
       puts $puifid "      [lindex $adr_val_arr($count) $jj]"
      }
     puts $puifid "  \}\n"
    }
   puts $puifid "\}"
   puts $puifid "## ALTER UNIT SUB POST DEF INFO END"
   puts $puifid ""
   puts $puifid "## MAIN POST DATA START"
   if { [info exist Post::($post_object,main_post_Output_VNC)] } {
    puts $puifid "\{main_post_Output_VNC\} \{$Post::($post_object,main_post_Output_VNC)\}"
   }
   puts $puifid "\{main_sys_var\}      \{$Post::($post_object,main_sys_var)\}"
   puts $puifid "\{main_kin_var\}      \{$Post::($post_object,main_kin_var)\}"
   puts $puifid "\{Indep_fmt_list\}    \{\{$Post::($post_object,Indep_fmt_list)\} \\"
    set tmp_no [llength $Post::($post_object,Indep_fmt_list)]
    array set tmp_arr $Post::($post_object,Indep_fmt_arr)
    set tmp_name [file tail $gPB(main_post)]
    for { set jj 0 } { $jj < $tmp_no } { incr jj } {
     if { $jj != [expr $tmp_no - 1] } {
      puts $puifid "                     \{$tmp_arr($tmp_name,$jj,data)\} \\"
      } else {
      puts $puifid "                     \{$tmp_arr($tmp_name,$jj,data)\}\}"
    }
   }
   puts $puifid "\{Indep_add_list\}    \{\{$Post::($post_object,Indep_add_list)\} \\"
    set tmp_no [llength $Post::($post_object,Indep_add_list)]
    array set tmp_arr $Post::($post_object,Indep_add_arr)
    for { set jj 0 } { $jj < $tmp_no } { incr jj } {
     if { $jj != [expr $tmp_no - 1] } {
      puts $puifid "                     \{$tmp_arr($tmp_name,$jj,data)\} \\"
      } else {
      puts $puifid "                     \{$tmp_arr($tmp_name,$jj,data)\}\}"
    }
   }
   unset tmp_arr tmp_no tmp_name
   puts $puifid "## MAIN POST DATA END"
   puts $puifid ""
   array set kin_var_arr $Post::($post_object,mom_kin_var_list)
   puts $puifid "## KINEMATIC VARIABLES START"
   set kin_var_list $gPB(mach_mom_kin_var_list)
   lappend kin_var_list "\$mom_kin_machine_type" "\$mom_kin_output_unit"
   foreach kin_var $kin_var_list {
    if { [info exists kin_var_arr($kin_var)] } {
     set value $kin_var_arr($kin_var)
     puts $puifid "[format "%-40s  %s" \"$kin_var\" \"$value\"]"
    }
   }
   unset kin_var_list
   puts $puifid "## KINEMATIC VARIABLES END"
   puts $puifid ""
   puts $puifid "## MOM SYS VARIABLES START"
   puts $puifid "\{PB_Tcl_Var\} \\"
   set jj 1
   array set sys_var_arr $Post::($post_object,main_sys_var)
   set sys_var_list [lsort -dictionary [array names sys_var_arr]]
   foreach var $sys_var_list {
    set value "$sys_var_arr($var)"
    set pos [expr [string length $value] - 1]
    switch $value \
    {
     "IPM" -
     "IPR" -
     "MMPM" -
     "MMPR" \
     {
      if { ![string compare "Inches" $gPB(main_post_unit)] } {
       set value "MMP[string range $value $pos $pos]"
       } else {
       set value "IP[string range $value $pos $pos]"
      }
      if { $jj < [llength $sys_var_list] } {
       puts $puifid "      \{\"$var\" \"$value\" \"\"\} \\"
       } else {
       puts $puifid "      \{\"$var\" \"$value\" \"\"\}"
      }
     }
     default \
     {
      if { [string match "\$mom_sys_feed_param(*,format)" $var] } {
       if { ![string compare "MM" $kin_var_arr(\$mom_kin_output_unit) ] } {
        if { [regsub "IPM" $var "MMPM" var] } {
         set value "Feed_MMPM"
         } elseif { [regsub "IPR" $var "MMPR" var] } {
         set value "Feed_MMPR"
        }
        } else {
        if { [regsub "MMPM" $var "IPM" var] } {
         set value "Feed_IPM"
         } elseif { [regsub "MMPR" $var "IPR" var] } {
         set value "Feed_IPR"
        }
       }
       if { $jj < [llength $sys_var_list] } {
        puts $puifid "      \{\"$var\" \"$value\" \"\"\} \\"
        } else {
        puts $puifid "      \{\"$var\" \"$value\" \"\"\}"
       }
      }
     }
    }
    incr jj
   }
   unset sys_var_arr sys_var_list kin_var_arr
   puts $puifid "## MOM SYS VARIABLES END"
   close $puifid
   return
  }
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
  PB_pui_WriteEvtElemExecutionData puifid seq_obj_list
  PB_pui_WriteEventUIData puifid seq_obj_list
  if [info exists Post::($post_object,axis_limit_evt_obj)] \
  {
   __mach_SaveAxisLimitAct $Post::($post_object,axis_limit_evt_obj)
  }
  array set add_name_list $Post::($post_object,add_name_list)
  array set word_desc_arr $Post::($post_object,word_desc_array)
  array set word_mom_var $Post::($post_object,word_mom_var)
  array set mom_var_arr $Post::($post_object,mom_sys_var_list)
  PB_pui_WriteMOMVariables puifid add_name_list add_obj_list \
  word_desc_arr word_mom_var mom_var_arr
  if { ![string match "*_wedm" [string tolower $mom_kin_var(\$mom_kin_machine_type)]] } {
   array set mom_sim_arr $Post::($post_object,mom_sim_var_list)
   PB_pui_WriteSIMVariables puifid mom_sim_arr
  }
  set func_obj_list $Post::($post_object,function_blk_list)
  PB_pui_WriteFunctionInfo puifid func_obj_list
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
    "usertcl_check" {puts $puifid "[format "%-30s %s" \
    Listfileflag_usertcl_check $obj_attr(usertcl_check)]"}
    "usertcl_name"  {puts $puifid "[format "%-30s %s" \
    Listfileflag_usertcl_name $obj_attr(usertcl_name)]"}
    "verbose"  {puts $puifid "[format "%-30s %s" \
    Listfileflag_verbose $obj_attr(verbose)]"}
    "use_default_unit_fragment"  {puts $puifid "[format "%-30s %s" \
    Listfileflag_use_default_unit_fragment $obj_attr(use_default_unit_fragment)]"}
    "alt_unit_post_name"  {puts $puifid "[format "%-30s %s" \
    Listfileflag_alt_unit_post_name $obj_attr(alt_unit_post_name)]"}
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
   set mom_kin_var($kin_var) [PB_output_EscapeSpecialControlChar $mom_kin_var($kin_var)]
   puts $puifid "[format "%-40s  %s" \"$kin_var\" \"$mom_kin_var($kin_var)\"]"
  }
  puts $puifid "## KINEMATIC VARIABLES END\n"
 }

#=======================================================================
proc PB_pui_WriteSIMVariables { PUIFID MOM_SIM_ARR } {
  upvar $PUIFID puifid
  upvar $MOM_SIM_ARR mom_sim_arr
  global mom_sys_arr post_object
  if { [info exists mom_sim_arr(\$mom_sim_mode_leader)] } {
   if [string match "XYZ" $mom_sim_arr(\$mom_sim_mode_leader)] {
    set mom_sim_arr(\$mom_sim_incr_linear_addrs) ""
   }
  }
  set arr_names [array names mom_sim_arr]
  puts $puifid "## MOM SIM VARIABLES START"
  set arr_names [lsort -dictionary $arr_names]
  set sub_var_list [list "\$mom_sim_spindle_jct" "\$mom_sim_spindle_direction" \
  "\$mom_sim_spindle_comp" "\$mom_sim_num_machine_axes" \
  "\$mom_sim_spindle_mode" "\$mom_sim_zcs_base" \
  "\$mom_sim_pre_com_list" "\$mom_sim_user_com_list"]
  foreach sim_var $arr_names \
  {
   set mom_sim_arr($sim_var) [PB_output_EscapeSpecialControlChar $mom_sim_arr($sim_var)]
   set len [llength $mom_sim_arr($sim_var)]
   set val $mom_sim_arr($sim_var)
   if {[string match "Standalone" $mom_sys_arr(VNC_Mode)]} {
    if {[string match "\$mom_sim_sub_*" $sim_var]} {
     continue
    }
    } else {
    if {([lsearch $sub_var_list $sim_var] < 0) &&  \
     ![string match "\$mom_sim_mt_axis*" $sim_var] &&  \
     ![string match "\$mom_sim_sub_*" $sim_var] && \
     ![string match "\$mom_sim_?th_axis_has_limits" $sim_var] && \
     ![string match "\$mom_sim_reverse_?th_table" $sim_var]} {
     continue
    }
   }
   if { $len > 10 } {
    set first_item [lindex $val 0]
    set last_item  [lindex $val end]
    if {[string match "\{*\}" $first_item]} {
     puts $puifid "    [format "%-40s  %s"  \"$sim_var\" \"$first_item\ \\]"
     } else {
     puts $puifid "    [format "%-40s  %s"  \"$sim_var\" \"\{$first_item\}\ \\]"
    }
    for { set i 1 } { $i < [expr $len - 1] } { incr i } {
     set inter_item [lindex $val $i]
     if {[string match "\{*\}" $inter_item]} {
      puts $puifid "     $inter_item \\"
      } else {
      puts $puifid "     \{$inter_item\} \\"
     }
    }
    if {[string match "\{*\}" $last_item]} {
     puts $puifid "     $last_item\""
     } else {
     puts $puifid "     \{$last_item\}\""
    }
    } else {
    puts $puifid "    [format "%-40s  %s" \"$sim_var\" \"$val\"]"
   }
  }
  puts $puifid "## MOM SIM VARIABLES END\n"
  puts $puifid "## VNC COMMANDS START"
  Post::GetObjList $post_object command cmd_obj_list
  set cmd_name_list [list]
  if [string match "Standalone" $mom_sys_arr(VNC_Mode)] {
   if {[info exists mom_sim_arr(\$mom_sim_vnc_com_list)]} {
    set cmd_name_list $mom_sim_arr(\$mom_sim_vnc_com_list)
   }
   } else {
   if {[info exists mom_sim_arr(\$mom_sim_sub_vnc_list)]} {
    set cmd_name_list $mom_sim_arr(\$mom_sim_sub_vnc_list)
   }
  }
  set length [llength $cmd_name_list]
  set var_desc "Custom Comands"
  global vnc_desc_arr
  for {set count 0 } { $count < $length } {incr count} {
   set name [lindex $cmd_name_list $count]
   PB_com_RetObjFrmName name cmd_obj_list cmd_obj
   if { $cmd_obj > 0} {
    command::readvalue $cmd_obj cmd_attr
    } else {
    continue
   }
   if [info exists command::($cmd_obj,description)] {
    set var_value $command::($cmd_obj,description)
    } else {
    set var_value ""
   }
   set var_value [string trimright $var_value "\n"]
   set vnc_desc_arr($name,desc) $var_value
   if {$count < [expr $length -1]} \
   {
    puts $puifid "\{\"$name\" \"$var_desc\" \"$var_value\"\} \\"
   } else \
   {
    puts $puifid "\{\"$name\" \"$var_desc\" \"$var_value\"\}"
   }
  }
  puts $puifid "## VNC COMMANDS END\n"
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
  PB_adr_SortAddresses add_obj_list
  puts $puifid "## MASTER SEQUENCE START"
  foreach add_obj $add_obj_list \
  {
   set add_name $address::($add_obj,add_name)
   address::readMseqAttr $add_obj mseq_attr
   puts $puifid "[format "%-15s   %s  %d  %s  %d" $add_name \
   \"$mseq_attr(0)\" $mseq_attr(1) \"$mseq_attr(2)\" $mseq_attr(4)]"
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
  if 0 {
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
   global post_object
   set post_blk_list $Post::($post_object,post_blk_list)
   foreach post_blk_obj $post_blk_list \
   {
    block::readvalue $post_blk_obj blk_obj_attr
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
  }
  puts $puifid "## BLOCK MODALITY END\n"
 }

#=======================================================================
proc PB_pui_WriteCompositeBlks { PUIFID } {
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
    puts $puifid "#Misc Start"
   }
   6 {
    puts $puifid "#Operation End Sequence Start"
   }
   7 {
    puts $puifid "#Program End Sequence Start"
   }
   8 {
    puts $puifid "#Linked Posts Sequence Start"
   }
   9 {
    puts $puifid "#Virtual NC Sequence Start"
   }
  }
 }

#=======================================================================
proc PB_pui_WriteEventAndBlks { PUIFID SEQ_OBJ } {
  upvar $PUIFID puifid
  upvar $SEQ_OBJ seq_obj
  global post_object machType
  if [string match "Virtual NC Controller" $sequence::($seq_obj,seq_name)] {
   set seq_events_list $Post::($post_object,vnc_evt_obj_list)
   } else {
   set seq_events_list $sequence::($seq_obj,evt_obj_list)
  }
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
     if { $blk_obj > 0 } {
      if { $share_event_flag }\
      {
       if {![string compare $block::($blk_obj,blk_owner) $event_name]} \
       {
        PB_output_GetBlkName blk_obj block_name
        lappend row_blk_list $block_name
        if { [string match "macro" $block::($blk_obj,blk_type)] } \
        {
         set blk_elem_obj [lindex $block::($blk_obj,elem_addr_list) 0]
         if { [info exists block_element::($blk_elem_obj,func_prefix)] } \
         {
          lappend row_blk_list $block_element::($blk_elem_obj,func_prefix)
         } else \
         {
          lappend row_blk_list ""
         }
         if { [info exists block_element::($blk_elem_obj,func_suppress_flag)] } \
         {
          lappend row_blk_list $block_element::($blk_elem_obj,func_suppress_flag)
         } else \
         {
          lappend row_blk_list 0
         }
        }
       }
      } else \
      {
       PB_output_GetBlkName blk_obj block_name
       lappend row_blk_list $block_name
       if { [string match "macro" $block::($blk_obj,blk_type)] } \
       {
        set blk_elem_obj [lindex $block::($blk_obj,elem_addr_list) 0]
        if { [info exists block_element::($blk_elem_obj,func_prefix)] } \
        {
         lappend row_blk_list $block_element::($blk_elem_obj,func_prefix)
        } else \
        {
         lappend row_blk_list ""
        }
        if { [info exists block_element::($blk_elem_obj,func_suppress_flag)] } \
        {
         lappend row_blk_list $block_element::($blk_elem_obj,func_suppress_flag)
        } else \
        {
         lappend row_blk_list 0
        }
       }
      }
     }
    }
    if [info exists row_blk_list] \
    {
     lappend evt_blk_list $row_blk_list
     unset row_blk_list
    }
   }
   set event_label $event::($evt_obj,event_label)
   if {$::env(PB_UDE_ENABLED) == 1} {
    global post_object
    set udeobj $Post::($post_object,ude_obj)
    set seqobj $ude::($udeobj,seq_obj)
    set evt_list $sequence::($seqobj,evt_obj_list)
    set seqobj_cycle $ude::($udeobj,seq_obj_cycle)
    if [string match $machType "Mill"] {
     set cyc_evt_list $sequence::($seqobj_cycle,evt_obj_list)
     } else {
     set cyc_evt_list [list]
    }
    set is_non_system_cycle_flag 0
    if {[lsearch $cyc_evt_list $evt_obj] >= "0"} {
     set cyc_evt_obj $event::($evt_obj,cyc_evt_obj)
     if {$cycle_event::($cyc_evt_obj,is_sys_cycle) == 1} {
      continue
      } else {
      set is_non_system_cycle_flag 1
     }
    }
    if {[lsearch $evt_list $evt_obj] < "0"} {
     if [string match "Virtual NC Controller" $sequence::($seq_obj,seq_name)] {
      puts $puifid "[format "%-55s  %s  %s" \{$event_name\} \{$evt_blk_list\} \{$event_label\}]"
      } else {
      if $is_non_system_cycle_flag {
       puts $puifid "[format "%-25s  %s  %s" \{$event_name\} \{$evt_blk_list\} \{$event_label\}]"
       } else {
       if [info exists event::($evt_obj,event_ude_name)] {
        set event_ude_name $event::($evt_obj,event_ude_name)
        puts $puifid "[format "%-25s  %s  %s %s" \{$event_name\} \{$evt_blk_list\} \{$event_label\} \{$event_ude_name\}]"
        } else {
        puts $puifid "[format "%-25s  %s  %s" \{$event_name\} \{$evt_blk_list\} \{$event_label\}]"
       }
      }
     }
     } else {
     if {[llength $event::($evt_obj,evt_elem_list)] > "0"} {
      set event_ude_name "UDE"
      puts $puifid "[format "%-25s  %s  %s %s" \{$event_name\} \{$evt_blk_list\} \{$event_label\} \{$event_ude_name\}]"
     }
    }
    } else {
    if [string match "Virtual NC Controller" $sequence::($seq_obj,seq_name)] {
     puts $puifid "[format "%-55s  %s  %s" \{$event_name\} \{$evt_blk_list\} \{$event_label\}]"
     } else {
     if [info exists event::($evt_obj,event_ude_name)] {
      set event_ude_name $event::($evt_obj,event_ude_name)
      puts $puifid "[format "%-25s  %s  %s %s" \{$event_name\} \{$evt_blk_list\} \{$event_label\} \{$event_ude_name\}]"
      } else {
      puts $puifid "[format "%-25s  %s  %s" \{$event_name\} \{$evt_blk_list\} \{$event_label\}]"
     }
    }
   }
  }
 }

#=======================================================================
proc PB_pui_WriteSeqFooter { PUIFID INDEX } {
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
    puts $puifid "#Cycles End\n"
   }
   5 {
    puts $puifid "#Misc End"
    puts $puifid "##Tool Path End\n"
   }
   6 {
    puts $puifid "#Operation End Sequence End\n"
   }
   7 {
    puts $puifid "#Program End Sequence End\n"
   }
   8 {
    puts $puifid "#Linked Posts Sequence End\n"
   }
   9 {
    puts $puifid "#Virtual NC Sequence End"
   }
  }
 }

#=======================================================================
proc PB_pui_WriteEvtElemExecutionData { PUIFID SEQ_OBJ_LIST } {
  upvar $PUIFID puifid
  upvar $SEQ_OBJ_LIST seq_obj_list
  global post_object
  set cyl_sh_com_evt [lindex $Post::($post_object,cyl_evt_sh_com_evt) 0]
  puts $puifid "## EVENTS ELEMENT EXECUTION START"
  foreach seq_obj $seq_obj_list \
  {
   set seq_events_list $sequence::($seq_obj,evt_obj_list)
   foreach evt_obj $seq_events_list \
   {
    set event_name $event::($evt_obj,event_name)
    if { [lsearch $cyl_sh_com_evt $event_name] != -1} \
    {
     set share_event_flag 1
    } else \
    {
     set share_event_flag 0
    }
    set len 0
    set index 0
    set exec_list ""
    foreach evt_elem_obj $event::($evt_obj,evt_elem_list) \
    {
     if { $share_event_flag } \
     {
      if { ! [UI_PB_tpth_IsCycleCustom "$event_name"] } \
      {
       set continue_flag 0
       set blk_obj $event_element::($evt_elem_obj,block_obj)
       foreach blk_elem $block::($blk_obj,elem_addr_list) \
       {
        if { ! [string match "$event_name" "$block_element::($blk_elem,owner)"] } \
        {
         set continue_flag 1
         break
        }
       }
       if { $continue_flag } \
       {
        continue
       }
      }
     }
     set sub_elem_list [split $evt_elem_obj]
     foreach sub_elem_obj $sub_elem_list \
     {
      set elem_str ""
      if { $event_element::($sub_elem_obj,exec_condition_obj) > 0 } \
      {
       set cmd_obj $event_element::($sub_elem_obj,exec_condition_obj)
       append elem_str "$index $command::($cmd_obj,name)"
       append elem_str " $event_element::($sub_elem_obj,suppress_flag)"
       } elseif { $event_element::($sub_elem_obj,suppress_flag) == 1 } \
      {
       append elem_str "$index NULL 1"
      }
      set addr_name_list ""
      foreach addr_obj $event_element::($sub_elem_obj,force_addr_list) \
      {
       lappend addr_name_list $address::($addr_obj,add_name)
      }
      if { $addr_name_list != "" } \
      {
       if { $elem_str == "" } \
       {
        set elem_str "$index NULL 0"
       }
       append elem_str " \{$addr_name_list\}"
      }
      if { $elem_str != "" } \
      {
       lappend exec_list "$elem_str"
       incr len
      }
      incr index
     }
    }
    if { $exec_list != "" } \
    {
     set index 1
     puts $puifid "\{$event::($evt_obj,event_name)\} \\"
     foreach elem_str $exec_list \
     {
      if { $index == $len } \
      {
       puts $puifid "        \{$elem_str\}"
      } else \
      {
       puts $puifid "        \{$elem_str\} \\"
      }
      incr index
     }
    }
   }
  }
  puts $puifid "## EVENTS ELEMENT EXECUTION END\n"
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
         if { [info exists mem_obj_attr(6)]  &&  $mem_obj_attr(6) != "" } {
          append tmp_3mem_out " \"$mem_obj_attr(6)\""
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
  if [PB_is_v 4.0] {
   set default_name [list "New_Address" "PB_Dummy" "PB_Tcl_Var" "Command" \
   "Operator Message" "PB_Spindle" \
   "PB_ZeroFmt" "VNC_Instruction"]
   } else {
   set default_name [list "New_Address" "PB_Dummy" "PB_Tcl_Var" "Command" \
   "Operator Message" "PB_Spindle" \
   "PB_ZeroFmt"]
  }
  foreach name $default_name \
  {
   lappend add_obj_name_list $name
  }
  puts $puifid "## MOM SYS VARIABLES START"
  global post_object
  Post::GetObjList $post_object comment cmt_blk_obj_list
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
   if [info exists word_mom_var($add_name)] \
   {
    set word_mom_var($add_name)  [ltidy $word_mom_var($add_name)]
    if { $add_name == "Operator Message" } {
     set j 0
     foreach mom_var $word_mom_var($add_name) {
      PB_com_RetObjFrmName mom_var cmt_blk_obj_list cmt_blk_obj
      if { $cmt_blk_obj > 0 } {
       if { ![info exists block::($cmt_blk_obj,evt_elem_list)]  || \
        [llength $block::($cmt_blk_obj,evt_elem_list)] == 0 } {
        set word_mom_var($add_name) [lreplace $word_mom_var($add_name) $j $j]
        } else {
        incr j
       }
       } else {
       set word_mom_var($add_name) [lreplace $word_mom_var($add_name) $j $j]
      }
     }
    }
    if [string match "PB_Dummy" $add_name] {
     set j [lsearch -exact $word_mom_var($add_name) "\$cir_vector"]
     if { $j >= 0 } {
      set word_mom_var($add_name) [lreplace $word_mom_var($add_name) $j $j]
     }
     global mom_sys_arr
     if { [info exists mom_sys_arr(\$linearization_method)] && \
      [lsearch -exact $word_mom_var($add_name) "\$linearization_method"] == -1 } {
      lappend word_mom_var($add_name) "\$linearization_method"
      set mom_var_arr(\$linearization_method) $mom_sys_arr(\$linearization_method)
     }
    }
    if [string match "Command" $add_name] {
     foreach var $word_mom_var($add_name) {
      if [string match "PB_CMD_vnc*" $var] {
       set ind [lsearch $word_mom_var($add_name) $var]
       set word_mom_var($add_name) [lreplace $word_mom_var($add_name) $ind $ind]
      }
     }
    }
    set no_mom_var [llength $word_mom_var($add_name)]
    for {set count 0} {$count < $no_mom_var} {incr count} \
    {
     set mom_var [lindex $word_mom_var($add_name) $count]
     if { $add_name == "Command" || $add_name == "Operator Message" } \
     {
      if { $add_name == "Command" } {
       set var_value ""
       } else {
       if 0 {
        if [info exists mom_var_arr($mom_var)] {
         set var_value $mom_var_arr($mom_var)
        }
        if { $var_value == "" } {
         PB_com_RetObjFrmName mom_var cmt_blk_obj_list cmt_blk_obj
         if { $cmt_blk_obj > 0 } {
          block::readvalue $cmt_blk_obj cmt_blk_obj_attr
          set blk_elem [lindex $cmt_blk_obj_attr(2) 0]
          set elem_var $block_element::($blk_elem,elem_mom_variable)
         }
         set var_value $elem_var
        }
        } else {
        PB_com_RetObjFrmName mom_var cmt_blk_obj_list cmt_blk_obj
        if { $cmt_blk_obj > 0 } {
         block::readvalue $cmt_blk_obj cmt_blk_obj_attr
         set blk_elem [lindex $cmt_blk_obj_attr(2) 0]
         set elem_var $block_element::($blk_elem,elem_mom_variable)
        }
        set var_value $elem_var
       }
       set var_value [join [split $var_value \\] \\\\\\]
      }
      set var_desc [lindex $word_desc_arr($add_name) $count]
     } else \
     {
      if {[string match "\$mom_sys_feed_param*format*" $mom_var] || \
      [string match "\$mom_sys_delay_param*format*" $mom_var] } \
      {
       set temp_list [split $mom_var ,]
       set new_var [join $temp_list ",1_"]
       if [info exists mom_var_arr($mom_var)] \
       {
        set fmt_name $mom_var_arr($mom_var)
        PB_int_RetFmtObjFromName fmt_name fmt_obj
        set mom_var_arr($new_var) $fmt_obj
       } else \
       {
        set fmt_obj 0
       }
       if {$fmt_obj} {
        set var_value $format::($fmt_obj,for_name)
       }
      } else \
      {
       if [info exists mom_var_arr($mom_var)] {
        set var_value $mom_var_arr($mom_var)
        } else {
        set var_value ""
       }
      }
      if 0 {
       if { [string match $mom_var "Comment_Start"] || \
        [string match $mom_var "Comment_End"] } {
        set var_value [PB_output_EscapeSpecialControlChar $var_value]
       }
      }
      set var_value [PB_output_EscapeSpecialControlChar $var_value]
      if { [string first $var_value \\] != -1} \
      {
       set var_split [split $var_value \\]
       set var_value [join $var_split "\\\\"]
      }
      set var_desc [lindex $word_desc_arr($add_name) $count]
     }
     if {$count < [expr $no_mom_var -1]} \
     {
      if ![string match "PB_CMD_vnc*" $mom_var] {
       puts $puifid "      \{\"$mom_var\" \"$var_value\" \"$var_desc\"\} \\"
      }
     } else \
     {
      if ![string match "PB_CMD_vnc*" $mom_var] {
       puts $puifid "      \{\"$mom_var\" \"$var_value\" \"$var_desc\"\}"
      }
     }
     set var_value ""
     set var_desc  ""
    }
   }
   if { $no_mom_var == 0 } \
   {
    puts $puifid "      \{\"\" \"\" \"\"\}"
   }
  }
  puts $puifid "\{PB_Rapid\} \\"
  set rap_1_obj $mom_var_arr(\$pb_rapid_1)
  set rap_2_obj $mom_var_arr(\$pb_rapid_2)
  set rap_blk_1 ""
  set rap_blk_2 ""
  if { $rap_1_obj != "" } \
  {
   set rap_blk_1 $block::($rap_1_obj,block_name)
  }
  if { $rap_2_obj != "" } \
  {
   if [info exists block::($rap_2_obj,block_name)] {
    set rap_blk_2 $block::($rap_2_obj,block_name)
   }
  }
  puts $puifid "      \{\"\$pb_rapid_1\" \"$rap_blk_1\" \"\"\} \\"
  puts $puifid "      \{\"\$pb_rapid_2\" \"$rap_blk_2\" \"\"\}"
  if 0 {
   puts $puifid "\{PB_ZeroFmt\} \\"
   set zero_int_fmt $mom_var_arr(\$zero_int_fmt)
   set zero_real_fmt $mom_var_arr(\$zero_real_fmt)
   puts $puifid "      \{\"\$zero_int_fmt\" \"$zero_int_fmt\" \"\"\} \\"
   puts $puifid "      \{\"\$zero_real_fmt\" \"$zero_real_fmt\" \"\"\}"
  }
  puts $puifid "## MOM SYS VARIABLES END\n"
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
  ListingFile::setvalue $cur_list_obj cur_list_obj_attr
  array set old_kin_var $Post::($old_post_obj,mom_kin_var_list)
  array set cur_kin_var $Post::($cur_post_obj,mom_kin_var_list)
  set name_list [array names old_kin_var]
  foreach old_var $name_list \
  {
   if { [string match "\$*" $old_var] == 0 } \
   {
    set cur_var "\$$old_var"
   } else \
   {
    set cur_var $old_var
   }
   if [info exists cur_kin_var($cur_var)] \
   {
    switch $old_var \
    {
     "mom_kin_4th_axis_plane"   -
     "\$mom_kin_4th_axis_plane" -
     "\$mom_kin_5th_axis_plane" -
     "mom_kin_5th_axis_plane" \
     {
      set old_kin_var($old_var) [string toupper $old_kin_var($old_var)]
     }
    }
    set cur_kin_var($cur_var) $old_kin_var($old_var)
   }
  }
  set Post::($cur_post_obj,mom_kin_var_list) [array get cur_kin_var]
  set Post::($cur_post_obj,def_mom_kin_var_list) [array get cur_kin_var]
  array set old_msq_word_param $Post::($old_post_obj,msq_word_param)
  set msq_add_name $Post::($old_post_obj,msq_add_name)
  foreach add_name $msq_add_name \
  {
   if { [lindex $old_msq_word_param($add_name) 3] == "" } \
   {
    set mseq_param $old_msq_word_param($add_name)
    if { [string match "*user*" $add_name] } \
    {
     set mseq_param [lreplace $mseq_param 3 3 1]
    } else \
    {
     set mseq_param [lreplace $mseq_param 3 3 0]
    }
    set old_msq_word_param($add_name) $mseq_param
   }
  }
  Post::InitMasterSequence $cur_post_obj msq_add_name old_msq_word_param
  array set blk_mod_arr $Post::($old_post_obj,blk_mod_list)
  set Post::($cur_post_obj,blk_mod_list) [array get blk_mod_arr]
  if [info exists Post::($old_post_obj,comp_blk_list)] {
   set Post::($cur_post_obj,comp_blk_list) \
   $Post::($old_post_obj,comp_blk_list)
   } else {
   set Post::($cur_post_obj,comp_blk_list) [list]
  }
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

#=======================================================================
proc PB_pui_CreateFunctionObj { POST_OBJ FUNC_ID ATTR_LIST PARAM_ATTR_LIST } {
  upvar $POST_OBJ post_obj
  upvar $FUNC_ID func_id
  upvar $ATTR_LIST attr_list
  upvar $PARAM_ATTR_LIST param_attr_list
  set param_obj_list [list]
  foreach param_attr $param_attr_list \
  {
   set param_obj [new function::param_elem]
   set obj_attr(0) [lindex $param_attr 0]
   set obj_attr(1) [lindex $param_attr 1]
   set obj_attr(2) [lindex $param_attr 2]
   set obj_attr(3) [lindex $param_attr 3]
   set obj_attr(4) [lindex $param_attr 4]
   set obj_attr(5) [lindex $param_attr 5]
   if { [string match "" [lindex $param_attr 0]] } \
   {
    set obj_attr(2) "Text String"
   }
   function::param_elem::setvalue $param_obj obj_attr
   function::param_elem::DefaultValue $param_obj obj_attr
   function::param_elem::RestoreValue $param_obj
   lappend param_obj_list $param_obj
  }
  set func_obj [new function]
  set function::($func_obj,id)   $func_id
  set function::($func_obj,disp_name)   [lindex $attr_list 0]
  set function::($func_obj,func_start)  [lindex $attr_list 1]
  set function::($func_obj,separator)   [lindex $attr_list 2]
  set function::($func_obj,func_end)    [lindex $attr_list 3]
  set function::($func_obj,output_param_name_flag) [lindex $attr_list 4]
  set function::($func_obj,output_link_chars) [lindex $attr_list 5]
  set function::($func_obj,description) [lindex $attr_list 6]
  set function::($func_obj,param_list)  $param_obj_list
  function::readvalue $func_obj obj_attr
  function::DefaultValue $func_obj obj_attr
  function::RestoreValue $func_obj
  set len [llength $Post::($post_obj,function_blk_list)]
  set append_flag 1
  for { set i 0 } { $i < $len } { incr i } \
  {
   set temp_obj [lindex $Post::($post_obj,function_blk_list) $i]
   if { [string compare $function::($temp_obj,id) $func_id] == 0 } \
   {
    set old_obj [lindex $Post::($post_obj,function_blk_list) $i]
    set Post::($post_obj,function_blk_list) \
    [lreplace $Post::($post_obj,function_blk_list) $i $i $func_obj]
    set append_flag 0
    delete $old_obj
    break
   }
  }
  if { $append_flag } \
  {
   lappend Post::($post_obj,function_blk_list) $func_obj
  }
 }

#=======================================================================
proc PB_pui_WriteFunctionInfo { PUIFID FUNC_OBJ_LIST } {
  upvar $PUIFID puifid
  upvar $FUNC_OBJ_LIST func_obj_list
  puts $puifid "## FUNCTION INFO START"
  foreach func_obj $func_obj_list \
  {
   function::readvalue $func_obj func_attr
   puts $puifid "\{$func_attr(0)\} \\"
   puts $puifid "      \{\"$func_attr(1)\" \"$func_attr(2)\" \"$func_attr(3)\" \
    \"$func_attr(4)\" \"$func_attr(7)\" \"$func_attr(8)\" \
    \{$func_attr(5)\}\} \\"
   set no_param [llength $func_attr(6)]
   if { $no_param == 0 } \
   {
    puts $puifid "      \{\}"
   } else \
   {
    set count 1
    foreach param_obj $func_attr(6) \
    {
     function::param_elem::readvalue $param_obj obj_attr
     if [string match "Text String" $obj_attr(2)] \
     {
      set obj_attr(1) [PB_output_EscapeSpecialControlChar_no_dollar $obj_attr(1)]
     }
     if { $count == 1 } \
     {
      if { $count == $no_param } \
      {
       puts $puifid "      \{\{\"$obj_attr(0)\" \"$obj_attr(1)\" \
         \"$obj_attr(2)\" \"$obj_attr(3)\" \
         \"$obj_attr(4)\" \"$obj_attr(5)\"\}\}"
       break
      }
      puts $puifid "      \{\{\"$obj_attr(0)\" \"$obj_attr(1)\" \
        \"$obj_attr(2)\" \"$obj_attr(3)\" \
       \"$obj_attr(4)\" \"$obj_attr(5)\"\} \\"
       incr count
       continue
      } ; #end $count == 1
      if { $count == $no_param } \
      {
       puts $puifid "       \{\"$obj_attr(0)\" \"$obj_attr(1)\" \
        \"$obj_attr(2)\" \"$obj_attr(3)\" \
        \"$obj_attr(4)\" \"$obj_attr(5)\"\}\}"
      break
     }
     puts $puifid "       \{\"$obj_attr(0)\" \"$obj_attr(1)\" \
      \"$obj_attr(2)\" \"$obj_attr(3)\" \
     \"$obj_attr(4)\" \"$obj_attr(5)\"\} \\"
     incr count
    } ; #end foreach param_obj $obj_attr(1)
   }
  }; #end foreach func_obj $func_obj_list
  puts $puifid "## FUNCTION INFO END\n"
 }

#=======================================================================
proc PB_pui_UpdateUsedElementExecAttr { post_obj CURRENT_EVT_LIST } {
  upvar $CURRENT_EVT_LIST cur_evt_list
  global gPB
  if { ![info exists cur_evt_list] || [string match "" $cur_evt_list] } {
   return
  }
  if { ![info exists Post::($post_obj,evt_elem_exec_name_list)] || \
   $Post::($post_obj,evt_elem_exec_name_list) == "" } {
   return
  }
  set exec_name_list $Post::($post_obj,evt_elem_exec_name_list)
  array set evt_elem_exec_arr $Post::($post_obj,evt_elem_exec_list)
  set inherit_list [list]
  set index_list [list]
  set i 0
  foreach evt_name $exec_name_list {
   if { [lsearch $cur_evt_list $evt_name] == -1 } {
    lappend inherit_list $evt_name
    lappend index_list $i
   }
   incr i
  }
  if { $inherit_list == "" } {
   set Post::($post_obj,evt_elem_exec_name_list) ""
   set Post::($post_obj,evt_elem_exec_list) ""
   } else {
   set i 0
   foreach evt_name $inherit_list index $index_list {
    set tmp_exec_arr($i) $evt_elem_exec_arr($index)
    incr i
   }
   set Post::($post_obj,evt_elem_exec_name_list) $inherit_list
   set Post::($post_obj,evt_elem_exec_list) [array get tmp_exec_arr]
  }
 }
