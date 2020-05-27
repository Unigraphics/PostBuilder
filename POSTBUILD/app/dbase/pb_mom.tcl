##############################################################################
#                       P B _ M O M . T C L
##############################################################################
# Description                                                                #
#     This file contains dummy MOM commands for sourcing Even Handler file.  #
#     This file is sourced by PB_PUI_PARSER.TCL.                             #
#                                                                            #
# @<DEL>@ TEXT ENCLOSED within delete markers will be REMOVED                #
#============================================================================#
# Revisions                                                                  #
#                                                                            #
#   Date        Who       Reason                                             #
# 09-Jul-2001   genLin    Specified proper arguments list for each command.  #
# 06-Nov-2001   genLin    Add procs to disguise Tcl commands for parsing     #
#                         custom commands.                                   #
# 30-Nov-2001   genLin    Modified MOM_force & MOM_suppress.                 #
#============================================================================#
# TEXT ENCLOSED within delete markers will be REMOVED @<DEL>@                #
##############################################################################

#=======================================================================
proc MOM_ask_env_var { environment_variable } {
    global env
  
     set dir "$env(PB_HOME)/pblib/"
  
  return $dir
 }
 

#=======================================================================
proc MOM_set_debug_mode            { state } {}

#=======================================================================
proc MOM_reset_sequence            { start increment frequency } {}

#=======================================================================
proc MOM_set_seq_on                { args } {}

#=======================================================================
proc MOM_set_seq_off               { args } {}
 
 

#=======================================================================
proc MOM_do_template               { block_name } {
    __add_CmdBlock $block_name
 }
 

#=======================================================================
proc MOM_force                     { state args } {
    foreach add $args {
        __add_CmdAddress $add
    }
 }
 

#=======================================================================
proc MOM_suppress                  { state args } {
    foreach add $args {
        __add_CmdAddress $add
    }
 }
 

#=======================================================================
proc MOM_set_address_format        { address_name format_name } {
    __add_CmdAddress $address_name
    __add_CmdFormat  $format_name
 }
 

#=======================================================================
proc MOM_output_literal            { args } {}

#=======================================================================
proc MOM_output_to_listing_device  { args } {}

#=======================================================================
proc MOM_abort                     { args } {}
 

#=======================================================================
proc MOM_close_output_file         { args } {}

#=======================================================================
proc MOM_open_output_file          { args } {}

#=======================================================================
proc MOM_load_kinematics           { args } {}

#=======================================================================
proc MOM_reload_kinematics         { args } {}
 

#=======================================================================
proc MOM_reload_variable           { args } {}

#=======================================================================
proc MOM_run_user_function         { args } {}
 
 
 #=================
 # Local functions
 #=================

#=======================================================================
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
 

#=======================================================================
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
 

#=======================================================================
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
 
 
 #<11-05-01 gsl>
 #-------------------------------------------------------------------------------

#=======================================================================
proc PB_mom_DisguiseTclCmds_1 { args } {
  #-------------------------------------------------------------------------------
  
     if { [lsearch [info commands "TCL_source"] "TCL_source" ] < 0 } {
         rename source     TCL_source

#=======================================================================
      proc source     { args } {}
   }

   if { [lsearch [info commands "TCL_open"] "TCL_open" ] < 0 } {
       rename open       TCL_open

#=======================================================================
      proc open       { args } { return file9999 }
   }

   if { [lsearch [info commands "TCL_close"] "TCL_close" ] < 0 } {
       rename close      TCL_close

#=======================================================================
      proc close      { args } {}
   }

   if { [lsearch [info commands "TCL_exec"] "TCL_exec" ] < 0 } {
       rename exec       TCL_exec

#=======================================================================
      proc exec       { args } { return 1 }
   }

   if { [lsearch [info commands "TCL_fblocked"] "TCL_fblocked" ] < 0 } {
       rename fblocked   TCL_fblocked

#=======================================================================
      proc fblocked   { args } { return 1 }
   }

   if { [lsearch [info commands "TCL_fconfigure"] "TCL_fconfigure" ] < 0 } {
       rename fconfigure TCL_fconfigure

#=======================================================================
      proc fconfigure { args } {}
   }

   if { [lsearch [info commands "TCL_fcopy"] "TCL_fcopy" ] < 0 } {
       rename fcopy      TCL_fcopy

#=======================================================================
      proc fcopy      { args } {}
   }

   if { [lsearch [info commands "TCL_fileevent"] "TCL_fileevent" ] < 0 } {
       rename fileevent  TCL_fileevent

#=======================================================================
      proc fileevent  { args } {}
   }

   if { [lsearch [info commands "TCL_flush"] "TCL_flush" ] < 0 } {
       rename flush      TCL_flush

#=======================================================================
      proc flush      { args } {}
   }

   if { [lsearch [info commands "TCL_pid"] "TCL_pid" ] < 0 } {
       rename pid        TCL_pid

#=======================================================================
      proc pid        { args } {}
   }

   if { [lsearch [info commands "TCL_seek"] "TCL_seek" ] < 0 } {
       rename seek       TCL_seek

#=======================================================================
      proc seek       { args } {}
   }

   if { [lsearch [info commands "TCL_tell"] "TCL_tell" ] < 0 } {
       rename tell       TCL_tell

#=======================================================================
      proc tell       { args } { return 0 }
   }
}

#-------------------------------------------------------------------------------

#=======================================================================
proc PB_mom_RestoreTclCmds_1 { args } {
  #-------------------------------------------------------------------------------
  
     rename open       ""
     rename close      ""
     rename exec       ""
     rename fblocked   ""
     rename fconfigure ""
     rename fcopy      ""
     rename fileevent  ""
     rename flush      ""
     rename pid        ""
     rename seek       ""
     rename source     ""
     rename tell       ""
  
     rename TCL_open       open
     rename TCL_close      close
     rename TCL_exec       exec
     rename TCL_fblocked   fblocked
     rename TCL_fconfigure fconfigure
     rename TCL_fcopy      fcopy
     rename TCL_fileevent  fileevent
     rename TCL_flush      flush
     rename TCL_pid        pid
     rename TCL_seek       seek
     rename TCL_source     source
     rename TCL_tell       tell
 }
 
 #-------------------------------------------------------------------------------

#=======================================================================
proc PB_mom_DisguiseTclCmds_2 { args } {
  #-------------------------------------------------------------------------------
  
     rename expr  TCL_expr
     rename gets  TCL_gets
     rename read  TCL_read
     rename while TCL_while
  

#=======================================================================
   proc expr  { args } { return 1 }

#=======================================================================
   proc gets  { args } { return -1 }

#=======================================================================
   proc read  { args } { return -1 }

#=======================================================================
   proc while { args } { return 0 }
}

#-------------------------------------------------------------------------------

#=======================================================================
proc PB_mom_RestoreTclCmds_2 { args } {
  #-------------------------------------------------------------------------------
  
     if { [lsearch [info commands "TCL_expr"] "TCL_expr" ] >= 0 } {
         rename expr ""
         rename TCL_expr expr
     }
  
     if { [lsearch [info commands "TCL_gets"] "TCL_gets" ] >= 0 } {
         rename gets ""
         rename TCL_gets gets
     }
  
     if { [lsearch [info commands "TCL_read"] "TCL_read" ] >= 0 } {
         rename read ""
         rename TCL_read read
     }
  
     if { [lsearch [info commands "TCL_while"] "TCL_while" ] >= 0 } {
         rename while ""
         rename TCL_while while
     }
 }
 
