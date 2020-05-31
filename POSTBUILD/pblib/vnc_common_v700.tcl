########################### Virtual NC Controller ############################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006/2007/2008,           #
#                                                                            #
#                           Siemens PLM Software                             #
#                                                                            #
##############################################################################
#                       V N C _ C O M M O N _ V 7 0 0 . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains handlers for incremental VNC conversion.
#
##############################################################################


#=============================================================
proc PB_CMD_vnc__G_motion_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list [list]
    lappend var_list mom_sim_nc_func(MOTION_RAPID)
    lappend var_list mom_sim_nc_func(MOTION_LINEAR)
    lappend var_list mom_sim_nc_func(MOTION_CIRCULAR_CLW)
    lappend var_list mom_sim_nc_func(MOTION_CIRCULAR_CCLW)
    lappend var_list mom_sim_nc_func(CYCLE_DRILL)
    lappend var_list mom_sim_nc_func(CYCLE_DRILL_DWELL)
    lappend var_list mom_sim_nc_func(CYCLE_DRILL_DEEP)
    lappend var_list mom_sim_nc_func(CYCLE_DRILL_BREAK_CHIP)
    lappend var_list mom_sim_nc_func(CYCLE_TAP)
    lappend var_list mom_sim_nc_func(CYCLE_BORE)
    lappend var_list mom_sim_nc_func(CYCLE_BORE_DRAG)
    lappend var_list mom_sim_nc_func(CYCLE_BORE_NO_DRAG)
    lappend var_list mom_sim_nc_func(CYCLE_BORE_BACK)
    lappend var_list mom_sim_nc_func(CYCLE_BORE_MANUAL)
    lappend var_list mom_sim_nc_func(CYCLE_BORE_MANUAL_DWELL)
    lappend var_list mom_sim_nc_func(CYCLE_START)
    lappend var_list mom_sim_nc_func(CYCLE_OFF)

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(MOTION_LINEAR)                 code] } {

            set mom_sim_nc_register(MOTION) "LINEAR"

         } elseif { [VNC_string_match mom_sim_nc_func(MOTION_RAPID)            code] } {

            set mom_sim_nc_register(MOTION) "RAPID"

         } elseif { [VNC_string_match mom_sim_nc_func(MOTION_CIRCULAR_CLW)     code] } {

            set mom_sim_nc_register(MOTION) "CIRCULAR_CLW"

         } elseif { [VNC_string_match mom_sim_nc_func(MOTION_CIRCULAR_CCLW)    code] } {

            set mom_sim_nc_register(MOTION) "CIRCULAR_CCLW"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_DRILL)             code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_DRILL"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_DRILL_DWELL)       code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_DRILL_DWELL"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_DRILL_DEEP)        code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_DRILL_DEEP"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_DRILL_BREAK_CHIP)  code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_DRILL_BREAK_CHIP"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_TAP)               code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_TAP"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE)              code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE_DRAG)         code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_DRAG"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE_NO_DRAG)      code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_NO_DRAG"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE_BACK)         code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_BACK"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE_MANUAL)       code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_MANUAL"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_BORE_MANUAL_DWELL) code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_BORE_MANUAL_DWELL"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_START)             code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_START"

         } elseif { [VNC_string_match mom_sim_nc_func(CYCLE_OFF)               code] } {

            set mom_sim_nc_register(MOTION) "CYCLE_OFF"

           # Cycle Off - force tool to move to the initial pt (entry pos) of next set of holes.
            global mom_sim_pos mom_sim_cycle_retract_to_pos
            if { [info exists mom_sim_cycle_retract_to_pos] } {
               set mom_sim_pos(0) $mom_sim_cycle_retract_to_pos(0)
               set mom_sim_pos(1) $mom_sim_cycle_retract_to_pos(1)
               set mom_sim_pos(2) $mom_sim_cycle_retract_to_pos(2)
            }
         }

         break
      }
   }
}


#=============================================================
proc PB_CMD_vnc__set_feed { } {
#=============================================================
  global mom_sim_nc_register

   if { [string match "RAPID" $mom_sim_nc_register(MOTION)] || [expr $mom_sim_nc_register(F) <= 0] } {
      global mom_sim_rapid_feed_rate
      if { ![string compare "MM" $mom_sim_nc_register(UNIT)] } {
          set feed $mom_sim_rapid_feed_rate
          set feed_mode MM_PER_MIN
      } else {
          set feed $mom_sim_rapid_feed_rate
          set feed_mode INCH_PER_MIN
      }

      set mom_sim_nc_register(MOTION) "RAPID"

   } else {

      set feed $mom_sim_nc_register(F)
      set feed_mode $mom_sim_nc_register(FEED_MODE)
   }

   PB_SIM_call SIM_set_feed $feed $feed_mode
}




