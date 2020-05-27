#=============================================================
proc PB_CMD_mill_turn_initialize { } {
#=============================================================
#
#  This procedure initializes your post for a mill/turn.
#  A mill/turn consists of a mill post and a lathe post.
#  The system will switch between the two posts based on the 
#  operation type MILL or TURN.  
#  This procedure must be placed with the Start of Program event
#  marker.  
#  The custom command PB_CMD_machine_mode must exist in
#  your post, but not placed with any event marker.
#
#  This post will allow you to define the output needed for switching
#  between mill and turn operations.  The following custom commands
#  will be automatically executed when switching between operation
#  types.  This is where you can assing the M or G codes needed to
#  change modes on the controller.
#
#  PB_CMD_start_of_mill -- This procedure is executed before the start
#    of a milling operation that was preceded by a turning operation.
#
#  PB_CMD_start_of_turn -- This procedure is executed before the start
#    of a turning operation that was preceded by a milling operation.
#
#  PB_CMD_end_of_mill -- This procedure is executed at the end
#    of a milling operation that is followed by a turning operation.
#
#  PB_CMD_end_of_turn -- This procedure is executed at the end
#    of a turning operation that is followed by a milling operation.
#

global mom_sys_mill_postname
global mom_sys_lathe_postname
global mom_sys_current_head 

#  The following two lines allows you specify the names of the posts
#  that will be used for milling and turning operations.  The extension
#  .def and .tcl will be appended to define the mill or turn posts.

set mom_sys_mill_postname    "mill_turn_mill"
set mom_sys_lathe_postname   "lathe"

set mom_sys_current_head     ""
}


#=============================================================
proc PB_CMD_machine_mode { } {
#=============================================================
#
#  This procedure is used by a simple mill/turn post.  
#  DO NOT change any code in this procedure unless you know
#  what you are doing
#
  global mom_machine_mode 
  global mom_sys_mill_postname
  global mom_sys_lathe_postname
  global mom_load_event_handler 
  global mom_warning_info
  global mom_sys_current_head

  if {$mom_machine_mode == "MILL"} {

      if {$mom_sys_current_head == "TURN"} {catch {PB_CMD_end_of_turn}}
 
      set mom_sys_current_head "MILL"

      set mom_load_event_handler  [MOM_ask_env_var UGII_CAM_POST_DIR]$mom_sys_mill_postname.tcl
      MOM_load_definition_file  [MOM_ask_env_var UGII_CAM_POST_DIR]$mom_sys_mill_postname.def

      catch {PB_CMD_start_of_mill}
 
  } elseif {$mom_machine_mode == "TURN"} {

      if {$mom_sys_current_head == "MILL"} {catch {PB_CMD_end_of_mill}}
 
      set mom_sys_current_head "TURN"

      set mom_load_event_handler  [MOM_ask_env_var UGII_CAM_POST_DIR]$mom_sys_lathe_postname.tcl
      MOM_load_definition_file  [MOM_ask_env_var UGII_CAM_POST_DIR]$mom_sys_lathe_postname.def

      catch {PB_CMD_start_of_turn}
 
  }
}




#=============================================================
proc PB_CMD_start_of_mill { } {
#=============================================================
#
#  PB_CMD_start_of_mill -- This procedure is executed before the start
#    of a milling operation that was preceded by a turning operation.
#
#  Typical output for this command
#  MOM_output_literal "G13"
}



#=============================================================
proc PB_CMD_start_of_turn { } {
#=============================================================
#
#  PB_CMD_start_of_turn -- This procedure is executed before the start
#    of a turning operation that was preceded by a milling operation.
#
#  Typical output for this command
#  MOM_output_literal "G13"
}


#=============================================================
proc PB_CMD_end_of_mill { } {
#=============================================================
#
#  PB_CMD_end_of_mill -- This procedure is executed at the end
#    of a milling operation that is followed by a turning operation.
#
#  Typical output for this command
#  MOM_output_literal "G13"
}


#=============================================================
proc PB_CMD_end_of_turn { } {
#=============================================================
#
#  PB_CMD_end_of_turn -- This procedure is executed at the end
#    of a turning operation that is followed by a milling operation.
#
#  Typical output for this command
#  MOM_output_literal "G13"
}
