##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc PB_CMD_fourth_axis_rotate_move { } {
#=============================================================
#
# This procedure is used by the ROTATE ude command to output a 
# fourth axis rotary move.  You can use the NC Data Definitions
# section of postbuilder to modify the fourth_axis_rotary_move
# block template. 
#
# Do NOT add this block to events or markers.  It is a static 
# block and it is not intended to be added to events.  Do NOT 
# change the name of this custom command.
#

   PB_CMD_index_rotary_table
}



#=============================================================
proc PB_CMD_index_rotary_table { } {
#=============================================================
#
# This custom command will output M codes to index the
# rotary index_table to preset stops.
#
# This custom command will only work 4 or 5 axis posts.  Only
# the fourth axis can be controlled by this custom command.
#
# If you require indexing codes to control your rotary axis,
# you must remove the A, B or C word from all of your blocks.
# You will also need to add this block to the linear move,
# rapid move and common cycle event markers if you want to
# use the tool axis in conjunction with your indexing table.
# Otherwise only the ROTATE/TABLE post command will output
# rotary indexing codes.
#
# You will need to overwrite the PB_CMD_fourth_axis_rotary_move
# custom command with the version in pb_cmd_index_rotary_table.tcl
#
# The parameter "index_code" allows you to define the code
# that will be output to position the table to the next stop.
#

   set index_code "M15"

#
# The parameter "stops" allows you to specify as many indexing
# positions as needed.  The post will output one index_code
# per stop.  The positions must be in ascending order to generate
# the correct number of stop positions.  The following example
# defines eight stops each 45 degrees apart.  
#

   set stops {0 45 90 135 180 225 270 315}

   global mom_pos
   global pre_index_pos
   global mom_warning_info

   set total_stops [llength $stops]

   if {![info exists pre_index_pos]} {set pre_index_pos 0}

   catch {unset index_pos}

   for {set i 0} {$i < $total_stops} {incr i} {
      if {[lindex $stops $i] == $mom_pos(3)} {
         set index_pos $i
         break
      }
   }

   if {![info exists index_pos]} {
      set deg [format %-7.3f $mom_pos(3)] 
      set mom_warning_info "Rotary index position $deg not found, ignored command"
      MOM_catch_warning
      return
   }

   set delta_index [expr $index_pos - $pre_index_pos]

   if {$delta_index < 0} {set delta_index [expr $delta_index + $total_stops]}
   for {set i 0} {$i < $delta_index} {incr i} {
      MOM_output_literal "$index_code"
   }

   set pre_index_pos $index_pos
}

