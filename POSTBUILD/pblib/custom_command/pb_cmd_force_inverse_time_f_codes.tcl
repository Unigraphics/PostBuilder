
#=============================================================
proc PB_CMD_force_FRN_F_code { } {
#=============================================================
#
#  This custom command can be used to force out F codes for FRN
#  mode.  Place this command in the start of your linear move
#  event.  All F codes output with IPM or MMPM will still be 
#  output modal.
#
global feed_mode
if {$feed_mode == "FRN"} {MOM_force once F}
}



