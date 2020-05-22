##############################################################################
#                       P B _ M O M . T C L
##############################################################################
# Description                                                                #
#     This file contains dummy MOM commands for sourcing Event Handler file. #
#                                                                            #
##############################################################################



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
               proc expr { args } {
                  if [catch { set val [TCL_expr $args] }] {
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

proc MOM_ask_env_var { environment_variable } {
  global env

   set dir "$env(PB_HOME)/pblib/"

return $dir
}

proc VNC_ask_shared_library_suffix { args } {}
proc MOM_before_each_add_var       { args } {}
proc MOM_before_each_event         { args } {}
proc MOM_abort                     { args } {}
proc MOM_incremental               { args } {}
proc MOM_remove_file               { file_name args} {}
proc MOM_set_debug_mode            { state args } {}
proc MOM_reset_sequence            { start increment frequency args } {}
proc MOM_set_seq_on                { args } {}
proc MOM_set_seq_off               { args } {}

proc MOM_do_template               { block_name args } {
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

proc MOM_do_template_file          { args } { return 1 }
proc MOM_cycle_objects             { args } {}
proc MOM_ask_library_attributes    { args } {}


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




