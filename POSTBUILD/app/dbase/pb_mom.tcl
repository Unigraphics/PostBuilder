##############################################################################
#                       P B _ M O M . T C L
##############################################################################
# Description                                                                #
#     This file contains dummy MOM commands for sourcing Event Handler file. #
#                                                                            #
##############################################################################


#=============================================================================
# These keywords could not be used as the UDE parameter name.
#=============================================================================

set gPB(non_ude_param_keywords) { "POS_INTEGER" "NEG_INTEGER" "DOUBLE" "IDENT"\
                                  "FP_IDENT" "EXPR" "NON_NULL_LITERAL" "LITERAL"\
                                  "NO_COOK_LITERAL" "TURBO_TOKEN" "MACHINE"\
                                  "INCLUDE" "FORMATTING" "WORD_SEPARATOR"\
                                  "END_OF_LINE" "SEQUENCE" "SWITCH_FLAG"\
                                  "ADDRESS" "FORMAT" "ZERO_FORMAT" "MAX"\
                                  "MIN" "FORCE" "PRINT_ADDR_LABEL" "LABEL_TEXT"\
                                  "BLOCK_TEMPLATE" "YOFF" "YALWAYS" "YONCE"\
                                  "ABORT" "TRUNCATE" "WARNING" "LEADER"\
                                  "TRAILER" "CTGY" "UI_LABEL" "OUT_FILE_DIR"\
                                  "OUT_FILE_SUFFIX" "INCREMENTAL" "OMIT"\
                                  "TP_IDENT" "ANGLES" "DRIVEN" "HOLDING_SYSTEM"\
                                  "POCKET" "PRELOAD_TOOL" "PRELOAD_TURRET" "QUERY"\
                                  "ROTATABLE" "TOOL_CONSTRAINTS" "TURRET"\
                                  "XFORM_ANGLES" "HOLDING_SYSTEM_ANY" "LOAD_STATUS"\
                                  "TOOL_ONLY" "TURRET_AND_TOOL" "TURRET_AND_POCKET"\
                                  "ALL" "PARAM_TYPE_SPEC" "CLASS_TYPE" "CLASS_SUBTYPE"\
                                  "YON" "NONE" "EVENT" "CLASS" "PARAM" "TOGGLE"\
                                  "POST_EVENT" "DEFVAL" "TYPE" "OPTIONS" "CYCLE"\
                                  "SYS_CYCLE" "SYS_PARAM"\
                                }


#=============================================================================
# Tcl commands to be disabled during syntax checking of Custom Commands.
#=============================================================================

set gPB(disabled_tcl_cmds_list_1) {    exit \
                                       puts \
                                       after \
                                       open \
                                       close \
                                       exec \
                                       fblocked \
                                       fconfigure \
                                       fcopy \
                                       fileevent \
                                       flush \
                                       pid \
                                       seek \
                                       source \
                                       cd \
                                       tell }

set gPB(disabled_tcl_cmds_list_2) {    file \
                                       while \
                                       expr \
                                       gets \
                                       read }



#=============================================================================
# PB commands to disguise Tcl commands during syntax checking.
#=============================================================================

#-----------------------------------------------------------------------------
proc PB_mom_DisguiseTclCmds_1 { args } {
#-----------------------------------------------------------------------------
  global gPB

   foreach cmd $gPB(disabled_tcl_cmds_list_1) {

      if { [lsearch [info commands "TCL_$cmd"] "TCL_$cmd" ] < 0 } {
         if { [lsearch [info commands "$cmd"] "$cmd" ] >= 0 } {
            rename $cmd TCL_$cmd
         }
         proc $cmd { args } {}
      }
   }
}

#-----------------------------------------------------------------------------
proc PB_mom_RestoreTclCmds_1 { args } {
#-----------------------------------------------------------------------------
  global gPB

   foreach cmd $gPB(disabled_tcl_cmds_list_1) {

      if { [lsearch [info commands "TCL_$cmd"] "TCL_$cmd" ] >= 0 } {
         rename $cmd     ""
         rename TCL_$cmd $cmd
      }
   }
}

#-----------------------------------------------------------------------------
proc PB_mom_DisguiseTclCmds_2 { args } {
#-----------------------------------------------------------------------------
  global gPB

   foreach cmd $gPB(disabled_tcl_cmds_list_2) {

      if { [lsearch [info commands "TCL_$cmd"] "TCL_$cmd" ] < 0 } {

         if { [lsearch [info commands "$cmd"] "$cmd" ] >= 0 } {
            rename $cmd TCL_$cmd
         }

         switch $cmd {
            "file"  -
            "while" {
               proc $cmd { args } { return 1 }
            }
            "expr" {
               proc $cmd { args } {
                  if [catch { set val [eval TCL_expr $args] }] {
                     return 1
                  } else {
                     return $val
                  }
               }
            }
            "gets" -
            "read" {
               proc $cmd { args } { return -1 }
            }

            default {
               proc $cmd { args } { return 0 }
            }
         }
      }
   }
}

#-----------------------------------------------------------------------------
proc PB_mom_RestoreTclCmds_2 { args } {
#-----------------------------------------------------------------------------
  global gPB

   foreach cmd $gPB(disabled_tcl_cmds_list_2) {

      if { [lsearch [info commands "TCL_$cmd"] "TCL_$cmd" ] >= 0 } {
         rename $cmd ""
         rename TCL_$cmd $cmd
      }
   }
}



#=============================================================================
# MOM commands to be disguised during syntax checking of Custom Commands.
#=============================================================================

proc MOM_set_output_style          { args } {}

proc MOM_add_to_block_buffer       { block_name args } {
  __add_CmdBlock $block_name
}

proc MOM_add_to_address_buffer     { address_name args } {
  __add_CmdAddress $address_name
}

proc MOM_set_format                { format_name args } {
  __add_CmdFormat  $format_name
}

proc MOM_ask_end_of_line_state     { args } { return "on" }
proc MOM_set_end_of_line_state     { args } {}
proc MOM_map_local_csys_to_main    { args } {}
proc MOM_validate_machine_model    { args } { return "TRUE" }
proc MOM_reload_iks_parameters     { args } {}
proc MOM_start_subroutine          { args } {}
proc MOM_end_subroutine            { args } {}
proc MOM_update_kinematics         { args } {}


proc MOM_ask_ess_exp_value         { args } { return "1" }
proc MOM_log_message               { args } {}
proc MOM_restart_upon_return       { args } {}
proc MOM_dump                      { args } {}
proc MOM_evaluate_arg              { args } {}
proc MOM_ask_part_units            { args } {}
proc MOM_add_to_line_buffer        { args } {}
proc MOM_source                    { args } {}
proc MOM_ask_unique_filename       { args } {}
proc MOM_load_and_pass_interp      { args } {}
proc MOM_load_tk                   { args } {}
proc MOM_unload_library            { args } {}
proc MOM_set_visible_undo_mark     { args } {}
proc MOM_set_invisible_undo_mark   { args } {}
proc MOM_undo_to_mark_by_name      { args } {}
proc MOM_undo_to_mark_by_mark_id   { args } {}
proc MOM_delete_to_mark_by_name    { args } {}
proc MOM_delete_to_mark_by_mark_id { args } {}
proc MOM_string_toupper            { args } { return [join $args] }
proc MOM_set_xtp_event             { args } {}
proc MOM_manage_xtp_events_in_post { args } {}
proc MOM_abort_event               { args } {}
proc MOM_ask_syslog_name           { args } {}

proc MOM_ask_env_var { environment_variable } {
  global env

   set dir "$env(PB_HOME)/pblib/"

return $dir
}

proc MOM_catch_warning             { args } {}
proc MOM_before_output             {      } {}
proc VNC_ask_shared_library_suffix { args } {}
proc MOM_ask_event_type            {      } { return " " }
proc MOM_ask_address_value         { args } {}
proc MOM_before_each_add_var       { args } {}
proc MOM_before_each_event         { args } {}
proc MOM_incremental               { args } {}
proc MOM_remove_file               { file_name args} {}
proc MOM_set_debug_mode            { state args } {}
proc MOM_reset_sequence            { start increment frequency args } {}
proc MOM_set_seq_on                { args } { return "off" }
proc MOM_set_seq_off               { args } { return "on" }

proc MOM_enable_address            { args } {
  foreach add $args {
     __add_CmdAddress $add
  }
}

proc MOM_disable_address           { args } {
  foreach add $args {
     __add_CmdAddress $add
  }
}

proc MOM_do_template               { block_name args } {
  __add_CmdBlock $block_name
}

proc MOM_force_block               { state block_name args } {
  __add_CmdBlock $block_name
}

proc MOM_force                     { state args } {
  foreach add $args {
     __add_CmdAddress $add
  }
}

proc MOM_suppress                  { state args } {
  foreach add $args {
     __add_CmdAddress $add
  }
}

proc MOM_set_address_format        { address_name format_name args } {
  __add_CmdAddress $address_name
  __add_CmdFormat  $format_name
}

proc MOM_output_text               { text args } {}
proc MOM_output_literal            { text args } {}
proc MOM_output_to_listing_device  { text args } {}
proc MOM_abort                     { args } {}

proc MOM_load_definition_file      { args } {}
proc MOM_close_output_file         { args } {}
proc MOM_open_output_file          { args } {}
proc MOM_load_kinematics           { args } {}
proc MOM_reload_kinematics         { args } {}

proc MOM_reload_variable           { args } {}
proc MOM_run_user_function         { args } {}

proc MOM_do_template_file          { args } { return "1" }
proc MOM_cycle_objects             { args } {}
proc MOM_ask_library_attributes    { args } {}
proc MOM_set_line_leader           { args } {}
proc MOM_ask_oper_csys             { args } { return "1" }
proc MOM_post_oper_path            { args } { return "1" }
proc MOM_convert_point             { args } { return "1" }
proc MOM_check_out_license         { args } { return "1" }
proc MOM_set_env_var               { args } { return "1" }
proc MOM_run_postprocess           { args } { return "1" }
proc MOM_ask_machine_zero_junction_name  { args } { return " " }
proc MOM_load_lathe_thread_cycle_params  { args } { return "1" }
proc MOM_display_message           { args } { return "1" }

proc MOM_abort_operation           { args } {}
proc MOM_ask_mcs_info              { args } {}
proc MOM_set                       { args } { return "1" }
proc MOM_unset                     { args } {}
proc MOM_link_var                  { args } {}
proc MOM_unlink_var                { args } {}

proc MOM_list_oper_path            { args } {}
proc MOM_list_user_defined_events  { args } {}
proc MOM_refresh_display           { args } {}
proc MOM_capture_image             { args } {}
proc MOM_capture_path_gif_image    { args } {}


#<Aug-29-2016 gsl>
proc MOM_set_address_buffer_nows    { args } {}
proc MOM_output_line                { args } { return "output_buffer" }
proc MOM_ask_init_junction_xform    { args } { return 1 }
proc MOM_fix_xzc_contact_output     { args } {}
proc MOM_skip_handler_to_event      { args } {}
proc MOM_find_datum_csys            { args } { return 1 }
proc MOM_ask_output_csys            { args } {}
proc MOM_revise_output_csys         { args } {}
proc MOM_restore_output_csys        { args } {}
proc MOM_revert_to_nx6_discal       { args } {}
proc MOM_enable_pre_nx8_incr_output { args } {}
proc MOM_enable_resolution_round    { args } {}
proc MOM_enable_pre_nx9_round_off   { args } {}
proc MOM_enable_post_options        { args } {}
proc MOM_set_address_with_value     { args } { return "addr_str" }
proc MOM_find_rotation_matrix       { args } { return 1 }
proc MOM_has_definition_element     { args } { return 1 }
proc MOM_ask_definition_element     { args } { return 1 }

#=======
# v11.01
#=======
proc MOM_set_turbo_mode          { args } {}
proc MOM_set_turbo_rapid         { args } { return "TRUE" }
proc MOM_set_turbo_blocks        { args } {}
proc MOM_set_address_expression  { args } { return "expression" }
proc MOM_set_turbo_before_motion { args } { return "TRUE" }
proc MOM_feedrate_set            { args } {}
proc MOM_cancel_suppress_force_once_per_event { args } { return "TRUE" }

#=======
# v12.0
#=======
proc MOM_abort_program             { args } {}


#=============================================================================
# Local functions
#=============================================================================
proc __add_CmdBlock { block_name } {
  global gPB

   if [info exists gPB(CMD_BLK_LIST)] {
      set idx [lsearch $gPB(CMD_BLK_LIST) $block_name]
      if { $idx < 0 } {
         lappend gPB(CMD_BLK_LIST) $block_name
      }
   } else {
      lappend gPB(CMD_BLK_LIST) $block_name
   }
}

proc __add_CmdAddress { address_name } {
  global gPB

   if [info exists gPB(CMD_ADD_LIST)] {
      set idx [lsearch $gPB(CMD_ADD_LIST) $address_name]
      if { $idx < 0 } {
         lappend gPB(CMD_ADD_LIST) $address_name
      }
   } else {
      lappend gPB(CMD_ADD_LIST) $address_name
   }
}

proc __add_CmdFormat { format_name } {
  global gPB

   if [info exists gPB(CMD_FMT_LIST)] {
      set idx [lsearch $gPB(CMD_FMT_LIST) $format_name]
      if { $idx < 0 } {
         lappend gPB(CMD_FMT_LIST) $format_name
      }
   } else {
      lappend gPB(CMD_FMT_LIST) $format_name
   }
}




