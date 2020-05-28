##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc PB_CMD_three_dimensional_tool_offset { } {
#=============================================================
#
#  This custom command will output 3d cutter compensation blocks
#  for Fanuc type controls.  The initial block will look like:
#
#  G41 G01 X Y Z I J K D
#
#  I,J,K represent the contact normal output.
#
#  You will need to do the following to your post in Postbuilder
#
#  Add I,J and K words to the linear move block using the following
#  user defined expressions for each:
#      I -- $mom_contact_normal(0)
#      J -- $mom_contact_normal(1)
#      K -- $mom_contact_normal(2)
#       
#  Add the following line (without the #) to the custom command
#  PB_CMD_before_motion
#PB_CMD_three_dimensional_tool_offset
#
#  Add the custom command PB_CMD_cutcom_on to the event marker 
#  Cutcom On under Program/Tool Path/Machine Control.
#
#  This option is only valid for the Fixed and Variable Axis Surfacing
#  Contouring modules in NX2 or later.
#
#  You will need to turn on the Output Contact Data button on the 
#  Machine Control dialog.  You will also need to turn off circular 
#  interpolation output.
#
#  You will need to output a CUTCOM/LEFT to activate the G41 block.
#

global mom_contact_status

if {[info exist mom_contact_status]} {
  if {$mom_contact_status == "ON"} {

    global mom_sys_initial_cutcom

    if {[info exist mom_sys_initial_cutcom]} {
      if {$mom_sys_initial_cutcom == "ON"} {

        MOM_force once X Y Z I J K G_cutcom D
        unset mom_sys_initial_cutcom
      }
    }
  }
}
}


#=============================================================
proc PB_CMD_cutcom_on { } {
#=============================================================

global mom_sys_initial_cutcom

set mom_sys_initial_cutcom "ON"
}


