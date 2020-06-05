##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################
#                           P B _ U D E _ B A S E . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains handlers for common UDE for all posts.
#
##############################################################################



#=============================================================
proc PB_CMD_MOM_text { } {
#=============================================================
# Default PB generated handler for UDE MOM_text
# - Do not attach it to any event!
#
# This procedure is executed when the Text command is activated.
#
   global mom_user_defined_text mom_record_fields
   global mom_sys_control_out mom_sys_control_in
   global mom_record_text mom_pprint set mom_Instruction mom_operator_message
   global mom_pprint_defined mom_operator_message_defined

   switch $mom_record_fields(0) {
   "PPRINT" 
         {
            set mom_pprint_defined 1
            set mom_pprint $mom_record_text
            MOM_pprint
         }
   "INSERT"
         {
            set mom_Instruction $mom_record_text
            MOM_insert
         }
   "DISPLY"
         {
            set mom_operator_message_defined 1
            set mom_operator_message $mom_record_text
            MOM_operator_message
         }
   default
         {
            if {[info exists mom_user_defined_text]} {
               MOM_output_literal "${mom_sys_control_out}${mom_user_defined_text}${mom_sys_control_in}"
            }
         }
   }
}


#=============================================================
proc PB_CMD_MOM_opskip_on { } {
#=============================================================
# Default PB generated handler for UDE MOM_opskip_on
# - Do not attach it to any event!
#
# <Note> Current MOM/Post implementation only handles opskip string appearing at the start of a block;
#        and by default, it only supports one level of opskip control.
#
# This procedure is executed when the Optional skip command is activated.
#

   MOM_set_line_leader always $::mom_sys_opskip_block_leader
   set ::mom_sys_opskip_on 1
}


#=============================================================
proc PB_CMD_MOM_opskip_off { } {
#=============================================================
# Default PB generated handler for UDE MOM_opskip_off
# - Do not attach it to any event!
#
# This procedure is executed when the Optional skip command is activated.
#

   MOM_set_line_leader off $::mom_sys_opskip_block_leader
   set ::mom_sys_opskip_on 0
}


#=============================================================
proc PB_CMD_MOM_insert { } {
#=============================================================
# Default PB generated handler for UDE MOM_insert
# - Do not attach it to any event!
#
# This procedure is executed when the Insert command is activated.
#
   global mom_Instruction
   MOM_output_literal "$mom_Instruction"
}


#=============================================================
proc PB_CMD_MOM_pprint { } {
#=============================================================
# Default PB generated handler for UDE MOM_pprint
# - Do not attach it to any event!
#
# This procedure is executed when the PPrint command is activated.
#
   global mom_pprint_defined

   if { [info exists mom_pprint_defined] } {
      if { $mom_pprint_defined == 0 } {
return
      }
   }

   PPRINT_OUTPUT
}


#=============================================================
proc PB_CMD_MOM_operator_message { } {
#=============================================================
# Default PB generated handler for UDE MOM_operator_message
# - Do not attach it to any event!
#
# This procedure is executed when the Operator Message command is activated.
#
# 28-Apr-2017 ugs - Of pb1102mp
#
   global mom_operator_message mom_operator_message_defined
   global mom_operator_message_status
   global ptp_file_name group_output_file mom_group_name
   global mom_sys_commentary_output
   global mom_sys_control_in
   global mom_sys_control_out
   global mom_sys_ptp_output
   global mom_post_in_simulation

   if { [info exists mom_operator_message_defined] && $mom_operator_message_defined == 0 } {
return
   }

   if { ![string match "ON" $mom_operator_message] && ![string match "OFF" $mom_operator_message] } {

      set brac_start [string first \( $mom_operator_message]
      set brac_end   [string last  \) $mom_operator_message]

      if { $brac_start != 0 } {
         set text_string "("
      } else {
         set text_string ""
      }

      append text_string $mom_operator_message
      if { $brac_end == -1 || \
           $brac_end != [expr [string length $mom_operator_message] -1 ] } {
         append text_string ")"
      }

      set st [MOM_set_seq_off]

     # Suspend output to PTP
      MOM_close_output_file $ptp_file_name

      if { [info exists mom_group_name] && [info exists group_output_file($mom_group_name)] } {
         MOM_close_output_file $group_output_file($mom_group_name)
      }

     # 5767232 -
     # 6686893 - seq num were output in nx6
     # if { [string match "on" $st] } { MOM_suppress once N }

     #<01Jun2011 wbh> Only output text to commentary file when postprocessing
      if { ![info exists mom_post_in_simulation] || $mom_post_in_simulation == 0 } {
         MOM_output_literal $text_string
      }

     # Resume output to PTP
      if { [string match "ON" $mom_sys_ptp_output] } {
         MOM_open_output_file $ptp_file_name
      }

      if { [info exists mom_group_name] && [info exists group_output_file($mom_group_name)] } {
         MOM_open_output_file $group_output_file($mom_group_name)
      }

      if { [string match "on" $st] } { MOM_set_seq_on }

      set need_commentary $mom_sys_commentary_output
      set mom_sys_commentary_output OFF

      regsub -all {[)]} $text_string $mom_sys_control_in  text_string
      regsub -all {[(]} $text_string $mom_sys_control_out text_string

      MOM_output_literal $text_string

      set mom_sys_commentary_output $need_commentary

   } else {

      set mom_operator_message_status $mom_operator_message
   }
}




