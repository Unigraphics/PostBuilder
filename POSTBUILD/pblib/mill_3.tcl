##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/3004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################



#*******************************************************************************
# Dummy out following commands when present -

if { [llength [info commands PB_CMD_kin_init_mill_xzc]] > 0 } {
#=============================================================
proc PB_CMD_kin_init_mill_xzc { } {
#=============================================================
# Null command from mill 3
}
#-------------------------------------------------------------
}


if { [llength [info commands PB_CMD_kin_init_mill_turn]] > 0 } {
#=============================================================
proc PB_CMD_kin_init_mill_turn { } {
#=============================================================
# Null command from mill 3
}
#-------------------------------------------------------------
}


if { [llength [info commands PB_CMD_kin_init_rotary]] > 0 } {
#=============================================================
proc PB_CMD_kin_init_rotary { } {
#=============================================================
# Null command from mill 3
}
#-------------------------------------------------------------
}


if { [llength [info commands PB_CMD_kin_before_motion]] > 0 } {
#=============================================================
proc PB_CMD_kin_before_motion { } {
#=============================================================
# Null command from mill 3
}
#-------------------------------------------------------------
}


if { [llength [info commands PB_CMD_kin_linearize_motion]] > 0 } {
#=============================================================
proc PB_CMD_kin_linearize_motion { } {
#=============================================================
# Null command from mill 3
}
#-------------------------------------------------------------
}


if { [llength [info commands PB_CMD_linearize_motion]] > 0 } {
#=============================================================
proc PB_CMD_linearize_motion { } {
#=============================================================
# Null command from mill 3
}
#-------------------------------------------------------------
}


if { [llength [info commands PB_CMD_reverse_rotation_vector]] > 0 } {
#=============================================================
proc PB_CMD_reverse_rotation_vector { } {
#=============================================================
# Null command from mill 3
}
#-------------------------------------------------------------
}


# Do we need to dummy out other commands only used in XZC or multi-axis posts?
#*******************************************************************************





