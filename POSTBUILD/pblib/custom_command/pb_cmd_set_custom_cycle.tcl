##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc PB_CMD_set_custom_cycle { } {
#=============================================================
#  
#  Custom cycles 
#
#    After you have created your custom cycles in NX, you will be able to 
#    select them from the available list of canned cycles in the Hole Making 
#    module.  This list will not be available in the Point to Point module.
#    You will also be able to assign additional parameters to your cycle block.
#
#  Prerequiste : NX 2.0.1
#
#  Steps
#    1) Create a CYCLE in your ude.cdl file. Copy the following and paste it 
#       into your ude.cdl file in the user defined events folder, but be sure 
#       to remove the comments (#).  Replace every instance of "special" with
#       the name of your cycle.  Add as many parameters as you like.  For
#       instance, the line "PARAM special_cycle_param_1" will generate a mom
#       variable mom_special_cycle_param_1 when the cycle is generated.  You
#       can then use the mom variable as an expression when you add a word
#       to your cycle block.  The syntax for a CYCLE is the same as any other
#       UDE except for CYCLE instead of EVENT. 
#
     
#CYCLE special 
#{ 
#   UI_LABEL "special" 
#   PARAM special_cycle_param_1 
#   { 
#      TYPE d 
#      DEFVAL "0.0000"
#      UI_LABEL "special cycle value 1"
#   }
#   PARAM special_cycle_param_2 
#   { 
#      TYPE d 
#      DEFVAL "0.0000"
#      UI_LABEL "special cycle value 2"
#   } 
#}

#
#
#    2) Add a cycle block in N/C Data Definitions for each new cycle.  Go to
#       the N/C Data Definitions tab.  Select block.  Select one of the cycle
#       blocks, cycle_drill is good.  Select create.  Rename the block by right
#       clicking.  Give it the name of your cycle preceded by cycle_.  Right 
#       click on the G address in the block and select Change Element and then
#       User Defined Expression.  Enter the number for your G code.
#    3) To add addition parameters to the block, select New Address from the 
#       pull down.  Select add block and add the word to your block.  Change
#       leader, format and modalilty as needed.  For format, use coordinate for 
#       numeric data and digit_2 or digit_4 for integer data.  Enter your mom 
#       variable from the ude.cdl the expression.  Go to word sequencing if 
#       your new word is not in the order you need.
#    4) Add this custom command to the Start of Program event marker.  If you
#       have a linked post, this custom command must be in the main post
#       Start of Program.
#    5) Make sure the name of your cycle in the ude.cdl is the same 
#       as the name of the event handlers.
#    6) Make sure the names of your cycle parameters in the ude.cdl PARAM 
#       section are the same as in the cycle block in N/C Data Definitions except
#       preceded with mom_.
#    7) There are two basic kinds of canned cycles listed here.  Use the cycle 
#       start cycle for Maho, Heidenhain, etc..  Use the standard one for 
#       Fanuc, Siemens, Fadal, Mazatrol, etc..
#  




uplevel #0 {

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Change 1 to 0 in next line, if your cycle requires start up block.
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if 1 {

# Standard Cycle Example
#=============================================================
proc MOM_special { } {
#=============================================================

  global cycle_name
  global cycle_init_flag

  set cycle_init_flag TRUE
  set cycle_name ""
  CYCLE_SET

}

#=============================================================
proc MOM_special_move { } {
#=============================================================

  global cycle_init_flag

  MOM_do_template cycle_special
  set cycle_init_flag FALSE

}


} else {

# Cycle Start Example
#=============================================================
proc MOM_special { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name ""
   CYCLE_SET
}


#=============================================================
proc MOM_special_move { } {
#=============================================================
  global cycle_init_flag

   if { ![string compare "TRUE" $cycle_init_flag] } {
      MOM_do_template cycle_special
   }

   MOM_force Once G_motion
   MOM_do_template post_startblk
   set cycle_init_flag FALSE
}

}


}


}



