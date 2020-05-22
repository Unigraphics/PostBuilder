##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc PB_CMD_user_defined_text_commands { } {
#=============================================================
#
# This custom command will add the handling of OPSKIP, OPSTOP and STOP
# when programmed as uder defined text.  Place this command in the start 
# of operation event marker.
#
  uplevel #0 {
  
    proc  MOM_text {} {
    #_______________________________________________________________________________
    # This procedure is executed when the Text command is activated.
    #_______________________________________________________________________________
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
      "OPSKIP"
           {
             if {$mom_record_fields(1) == "ON"} {MOM_opskip_on}
             if {$mom_record_fields(1) == "OFF"} {MOM_opskip_off}
           }
      "OPSTOP"
           {
             MOM_opstop
           }
      "STOP"
           {
             MOM_stop
           }
      default
           {
             if {[info exists mom_user_defined_text]} {
               MOM_output_literal "${mom_sys_control_out}${mom_user_defined_text}${mom_sys_control_in}"
             }
           }
    }
  }
}
}



