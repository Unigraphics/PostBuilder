##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

proc PB_CMD_init_incremental_cycles {} {
# 
# Cycles in Incremental Mode
# 
# The default settings for canned cycles in incremental mode are that X, Y and Z 
# are incremental from the previous X, Y and Z.  Z is the bottom of the hole and R 
# is always absolute.
# 
# This custom command will allow you to make the Z in cycles incremental 
# from R.  The first Z outside of cycles will be incremental from R.  All other Z 
# values will be incremental from the previous Z.  If you need any other 
# functionality in incremental mode you can use some of the following methods to 
# accomplish it.
#
# You will need to output a SET/MODE,INCR in the toolpath.  You can do this is in
# MODES SET UDE in machine control.  To cancel incremtnal mode, insert a SET/MODE,ABSOL
# in the tool path.  You must also make sure a G80 is always output for a cycle
# off event.
# 
# Make a new address in the canned cycles common parameters pull down and add to 
# the cycle block.  Set the name to Z_cycle.  Set the format to coordinate.  
# Set the modality to yes.  The expression is $mom_cycle_feed_to - $mom_cycle_rapid_to.
# Set the leader to Z.  In the Word Sequencing tab, move the Z at the end of the 
# block sequence to between the Y and Z (Z_cycle) words.
# 
# Remove the R word from the Common Parameters block in Canned by choosing none in
# Rapid_to parameter pulldown.
# 
# Change the expression in the Z word to Rapid Z Position in Cycle by right clicking 
# on the Z word (not Z_cycle) in canned cycle block in the common parameters dialog. 
#
# Add the Custom Command PB_CMD_init_incremental cycles to the Start of Program event
# marker.
#
# Add the Custom Command PB_CMD_cycle_on to the block before the Common Parameters 
# cycle block in Canned Cycles. 
#
# Add the Custom Command PB_CMD_cycle_off to the Cycle Off marker in Canned Cycles. 
 
uplevel #0 {
 
#=============================================================
proc MODES_SET { } {
#=============================================================
  global mom_output_mode
  switch $mom_output_mode {
    ABSOLUTE { set isincr OFF }
    default  { set isincr ON }
  }
  MOM_incremental $isincr X Y Z Z_cycle
}
 
}
} 
 
 
#=============================================================
proc PB_CMD_cycle_on {} {
#=============================================================
 
global mom_sys_leader 
set mom_sys_leader(Z) "R"
}
 
 
#=============================================================
proc PB_CMD_cycle_off {} {
#=============================================================
 
global mom_sys_leader
set mom_sys_leader(Z) "Z" 
}
 
 
 
 
 
