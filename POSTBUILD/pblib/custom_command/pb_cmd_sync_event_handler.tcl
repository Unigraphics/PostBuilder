## HEADER BLOCK START ##
##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006/2007/2008/2009/      #
#               2010/2011,                                                   #
#                                                                            #
#                             SIEMENS PLM Softwares.                         #
#                                                                            #
##############################################################################
#        P B _ C M D _ S Y N C _ E V E N T _ H A N D L E R . T C L
##############################################################################
#
# Commands in this file can be imported (all) to a post to fix the problem with
# sync codes output.
#
#   PB_CMD__sync_buffer_event
#   PB_CMD__sync_handle_bufferred_events
#   PB_CMD__sync_handle_event
#   PB_CMD_kin_end_of_program
#   PB_CMD_kin_handle_sync_event
#   PB_CMD_kin_start_of_program_2
#   PB_CMD__sync_reset_sync_code
#
#=============================================================================
#
# PB_CMD__sync_buffer_event
# - This command will buffer the sync event if buffer flag is set.
#   ==> It should be called by PB_CMD__sync_handle_event.
#
#   --> DO NOT REMOVE ANY LINES FROM THIS PROCEDURE UNLESS YOU KNOW
#       WHAT YOU ARE DOING.
#   --> DO NOT CALL THIS PROCEDURE FROM ANY OTHER CUSTOM COMMAND.
#
#
# PB_CMD__sync_handle_bufferred_events
# - This command will be executed automatically at the start of program.
#   It will handle the bufferred sync events triggered before start of program.
#   ==> It should be called by PB_CMD_kin_start_of_program_2.
#
#   --> DO NOT REMOVE ANY LINES FROM THIS PROCEDURE UNLESS YOU KNOW
#       WHAT YOU ARE DOING.
#
#
# PB_CMD__sync_handle_event
# - This command will be executed automatically by PB_CMD_kin_handle_sync_event
#   which gets executed by the MOM_sync event handler.
#   ==> It should be called by PB_CMD_kin_handle_sync_event.
#
#   --> DO NOT ADD THIS COMMAND TO ANY EVENT MARKER OR
#       CALL IT IN ANY OTHER COMMAND.
#   --> DO NOT REMOVE ANY LINES FROM THIS COMMAND UNLESS YOU KNOW
#       WHAT YOU ARE DOING.
#
#
# PB_CMD_kin_end_of_program
# - This command, if present, will be executed automatically;
#   it is the broker command to trigger PB_CMD__sync_reset_sync_code.
#
#   --> DO NOT REMOVE ANY LINES FROM THIS PROCEDURE UNLESS YOU KNOW
#       WHAT YOU ARE DOING.
#   --> DO NOT CALL THIS PROCEDURE FROM ANY
#       OTHER CUSTOM COMMAND.
#
#
# PB_CMD_kin_handle_sync_event
# - This command, if present, will be executed automatically;
#   it is the broker command to trigger PB_CMD__sync_handle_event.
#
#
# PB_CMD_kin_start_of_program_2
# - This command is called automatically in the end of PB_start_of_program.
#   It is also the broker command to trigger PB_CMD__sync_handle_bufferred_events.
#
#   --> DO NOT REMOVE ANY LINES FROM THIS PROCEDURE UNLESS YOU KNOW
#       WHAT YOU ARE DOING.
#   --> DO NOT CALL THIS PROCEDURE FROM ANY
#       OTHER CUSTOM COMMAND.
#
#
# PB_CMD__sync_reset_sync_code
# - This command will be called automatically by PB_CMD_kin_end_of_program
#   at the End of Program event to reset variables related to the sync event.
#
#   --> DO NOT ADD THIS COMMAND TO ANY EVENT MARKER OR
#       CALL IT IN ANY OTHER COMMAND.
#
#=============================================================================
## HEADER BLOCK END ##


#=============================================================
proc PB_CMD__sync_buffer_event { } {
#=============================================================
# This command will buffer the sync event if buffer flag is set.
#
#  --> DO NOT REMOVE ANY LINES FROM THIS PROCEDURE UNLESS YOU KNOW
#      WHAT YOU ARE DOING.
#
#  --> DO NOT CALL THIS PROCEDURE FROM ANY OTHER CUSTOM COMMAND.
#

  # This command should be called by PB_CMD__sync_handle_event.
   if { ![CALLED_BY PB_CMD__sync_handle_event] } {
return
   }


   global mom_sys_buffer_sync_flag
   global mom_sys_buffer_sync_count

   if { ![info exists mom_sys_buffer_sync_flag] } {
      set mom_sys_buffer_sync_flag 1
      set mom_sys_buffer_sync_count 0
   }
   if { $mom_sys_buffer_sync_flag } {
      incr mom_sys_buffer_sync_count
   }
}


#=============================================================
proc PB_CMD__sync_handle_bufferred_events { } {
#=============================================================
# This command will be executed automatically at the start of program.
# It will handle the bufferred sync events triggered before start of program.
#
#  --> DO NOT REMOVE ANY LINES FROM THIS PROCEDURE UNLESS YOU KNOW
#      WHAT YOU ARE DOING.
#

  # This command should be called by PB_CMD_kin_start_of_program_2.
   if { ![CALLED_BY PB_CMD_kin_start_of_program_2] } {
return
   }


   global mom_sys_buffer_sync_flag
   global mom_sys_buffer_sync_count

  # Output any sync marks that have been bufferred
   if { [info exists mom_sys_buffer_sync_flag] && $mom_sys_buffer_sync_flag } {

      if { [info exists mom_sys_buffer_sync_count] &&\
           [CMD_EXIST MOM_sync] } {

         set mom_sys_buffer_sync_flag 0
         for { set i 0 } { $i < $mom_sys_buffer_sync_count } { incr i } {
            MOM_sync
         }
      }
   }

   set mom_sys_buffer_sync_flag  0
   set mom_sys_buffer_sync_count 0
}


#=============================================================
proc PB_CMD__sync_handle_event { } {
#=============================================================
# This command will be executed automatically by PB_CMD_kin_handle_sync_event
# which will be executed by the MOM_sync event handler.
#
#  --> DO NOT ADD THIS COMMAND TO ANY EVENT MARKER OR
#      CALL IT IN ANY OTHER COMMAND.
#
#  --> DO NOT REMOVE ANY LINES FROM THIS COMMAND UNLESS YOU KNOW
#      WHAT YOU ARE DOING.
#

  # This command should be called by PB_CMD_kin_handle_sync_event.
   if { ![CALLED_BY PB_CMD_kin_handle_sync_event] } {
return
   }


   if { [string match "WEDM" [PB_CMD_ask_machine_type]] } {
return
   }


   if [CMD_EXIST PB_CMD__sync_buffer_event] {
      global mom_sys_buffer_sync_flag

      PB_CMD__sync_buffer_event

      if { [info exists mom_sys_buffer_sync_flag] && $mom_sys_buffer_sync_flag } {
return
      }
   }


   global mom_sync_code
   global mom_sync_index
   global mom_sync_start
   global mom_sync_incr
   global mom_sync_max


   set mom_sync_start    99
   set mom_sync_incr     1
   set mom_sync_max      199

   if { ![info exists mom_sync_code] } {
      set mom_sync_code $mom_sync_start
   }

   set mom_sync_code [expr $mom_sync_code + $mom_sync_incr]

  # Configure sync mark to be output
   MOM_output_literal "M$mom_sync_code"
}


#=============================================================
proc PB_CMD_kin_end_of_program { } {
#=============================================================
#  --> DO NOT REMOVE ANY LINES FROM THIS PROCEDURE UNLESS YOU KNOW
#      WHAT YOU ARE DOING.
#  --> DO NOT CALL THIS PROCEDURE FROM ANY
#      OTHER CUSTOM COMMAND.
#

   if [CMD_EXIST PB_CMD__sync_reset_sync_code] {
      PB_CMD__sync_reset_sync_code
   }
}



#=============================================================
proc PB_CMD_kin_handle_sync_event { } {
#=============================================================
# This command, if present, will be executed automatically;
# it is the broker to trigger PB_CMD__sync_handle_event.
#
   if [CMD_EXIST PB_CMD__sync_handle_event] {
      PB_CMD__sync_handle_event
   }
}



#=============================================================
proc PB_CMD_kin_start_of_program_2 { } {
#=============================================================
#  This command is called in the end of PB_start_of_program.
#
#  --> DO NOT REMOVE ANY LINES FROM THIS PROCEDURE UNLESS YOU KNOW
#      WHAT YOU ARE DOING.
#  --> DO NOT CALL THIS PROCEDURE FROM ANY
#      OTHER CUSTOM COMMAND.
#

   if [CMD_EXIST PB_CMD__sync_handle_bufferred_events] {
      PB_CMD__sync_handle_bufferred_events
   }
}



#=============================================================
proc PB_CMD__sync_reset_sync_code { } {
#=============================================================
# This command will be called automatically by PB_CMD_kin_end_of_program
# at the End of Program event to reset variables related to the sync event.
#
#  --> DO NOT ADD THIS COMMAND TO ANY EVENT MARKER OR
#      CALL IT IN ANY OTHER COMMAND.
#

  # This command should be called by PB_CMD_kin_end_of_program.
   if { ![CALLED_BY PB_CMD_kin_end_of_program] } {
return
   }


   global mom_sync_code
   global mom_sync_start
   global mom_sys_buffer_sync_flag
   global mom_sys_buffer_sync_count

   UNSET_VARS mom_sys_buffer_sync_flag

   set mom_sys_buffer_sync_count 0

   if { [info exists mom_sync_start] } {
      set mom_sync_code $mom_sync_start
   } else {
      set mom_sync_code 99
   }
}




