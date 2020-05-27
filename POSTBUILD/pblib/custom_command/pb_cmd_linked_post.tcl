#=============================================================
proc PB_CMD_multiple_post_initialize { } {
#=============================================================
uplevel #0 {

#  This procudure will allow you to define more than one post
#  for a single NC program.  This is useful for mill/turns with more
#  than one live milling turret.  It can be used for any combination
#  of maching modes (turning, three axis, four axis, five axis).
#  
#  This procedure must be placed with the Start of Program procedure.
#
#  The following table defines the name of the head and the post that
#  will be used when that head is specified in the toolpath with a
#  UDE (User Defined Event).  The HEAD UDE must be attached to a group
#  (Program or Method).  The MOM_head event will be generated whenever
#  there is a change of group.
#
#  The following example defines four heads.  The UDE command HEAD/zhead
#  will execute the post mill_zaxis.  The files mill_zaxis.tcl and 
#  mill_zaxis.def will be used to postprocess until another HEAD command
#  is encountered.
#
#  set mom_sys_postname(zhead)    "mill_zaxis"
#  set mom_sys_postname(xhead)    "mill_xaxis"
#  set mom_sys_postname(turn)     "lathe"
#  set mom_sys_postname(fiveaxis)     "mill_5axis"
#

set mom_sys_postname(zhead)    "mill_zaxis"
set mom_sys_postname(xhead)    "mill_xaxis"
set mom_sys_postname(turn)     "lathe"
set mom_sys_postname(fiveaxis)     "mill_5axis"

#  This procedure will also allow you to output code when switching from
#  machining mode to another.  The procedure PB_CMD_start_of_zhead will be 
#  executed if it exists whenever the zhead is used.  Likewise and procedure
#  is called each time a new head is used to turn off the previous mode and
#  initiate the new mode.

set current_head ""

proc MOM_head {} {

  global mom_head_name mom_sys_postname
  global mom_load_event_handler 
  global current_head
  global mom_warning_info

  if {[info exists mom_sys_postname($mom_head_name)] && $current_head != "$mom_head_name" } {

      catch {PB_CMD_end_of_$current_head}
 
      set current_head $mom_head_name

      set mom_load_event_handler  [MOM_ask_env_var UGII_CAM_POST_DIR]$mom_sys_postname($mom_head_name).tcl
      MOM_load_definition_file  [MOM_ask_env_var UGII_CAM_POST_DIR]$mom_sys_postname($mom_head_name).def

      catch {PB_CMD_start_of_$current_head}
 
  } else {

      set mom_warning_info "bad head name"
      MOM_catch_warning
  }

}
}
}


#=============================================================
proc PB_CMD_start_of_fiveaxis { } {
#=============================================================
MOM_output_literal "Code to turn on the fiveaxis head"
}


#=============================================================
proc PB_CMD_start_of_turn { } {
#=============================================================
MOM_output_literal "Code to turn on the turn head"
}


#=============================================================
proc PB_CMD_start_of_zhead { } {
#=============================================================
MOM_output_literal "Code to turn on the zhead"
}


#=============================================================
proc PB_CMD_end_of_fiveaxis { } {
#=============================================================
MOM_output_literal "Code to turn off the fiveaxis head"
}


#=============================================================
proc PB_CMD_end_of_turn { } {
#=============================================================
MOM_output_literal "Code to turn off the turn head"
}


#=============================================================
proc PB_CMD_end_of_zhead { } {
#=============================================================
MOM_output_literal "Code to turn off the zhead"
}
