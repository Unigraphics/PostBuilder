##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc PB_CMD_unidirectional_positioning { } {
#=============================================================
#
# This custom command will add positioning moves to a canned cycle
# so that the motion toward the hole is unidirectional.
#
#
# Import this command to the post and place it in the "Common Parameters"
# of the Canned Cycles page.
#
#

   global mom_pos feed mom_feed_rate

  #
  # You can use the following two parameters to define the X and Y motions
  # towards the holes.
  #
   set mom_sys_uni_dir(0) .2
   set mom_sys_uni_dir(1) .2

  #
  # You can use the following parameter to define the feedrate of the linear
  # move block.
  #
   set mom_sys_uni_feed 8.0


  ###########################################################################

   set sav_pos(0) $mom_pos(0)
   set sav_pos(1) $mom_pos(1)

   set mom_pos(0) [expr $mom_pos(0) + $mom_sys_uni_dir(0)]
   set mom_pos(1) [expr $mom_pos(1) + $mom_sys_uni_dir(1)]

   set sav_feed $feed
   set sav_mfr $mom_feed_rate

   MOM_suppress once Z
   MOM_rapid_move

   set feed $mom_sys_uni_feed
   set mom_feed_rate $mom_sys_uni_feed

   set mom_pos(0) $sav_pos(0)
   set mom_pos(1) $sav_pos(1)

   MOM_suppress once Z
   MOM_linear_move

   set mom_feed_rate $sav_mfr
   set feed $sav_feed

   MOM_force once X Y
}


