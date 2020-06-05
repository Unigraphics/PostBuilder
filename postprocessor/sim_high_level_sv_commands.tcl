################################################################################
#
# (C) dCADE Gesellschaft fuer Produktionsinformatik mbH, 1996
# Gustav-Meyer-Allee 25
# D-13355 Berlin
#
# File name:			high_level_sv_commands.tcl
#
# File description:	This file contains the TCL high level motion commands
#							for IS&V
#
#===============================================================================
#	Revision	Date			Name				Reason
#	00			11-Nov-2000		Frank Armbrust		Initial
#	01			12-Dez-2000		Thomas Schulz		Add the procedures to set the
#												    mom_sim_update_intermediate_flag
#	02			14-Nov-2000		Frank Armbrust		change comments only
#													bug fixing
#	03			08-Jan-2001		Frank Armbrust		change SIM_move_linear_mtcs
#													only requested axis movement
#													SIM_update is called after events 
#													for all axis have been created
#   04			07-Feb-2001		Thomas Schulz	    Change the call of the ask_offset
#													and the ask_matrix functions in
#													respect to work without direct 
#													return values
#   05			09-Feb-2001		Frank Armbrust		modify the SIM_move_circular_zcs
#  													and SIM_move_circular_mtcs procedures
#  													to allow incremental centerpoint
#  													This is controlled by an new variable
#  													mom_sim_incr_circle_mode which is normaly 
#  													set to 0 (means absolute)
#	06			13-Feb-2001		Yakove Dayan		added SIM_invoke
#													only requested axis movement
#													SIM_update is called after events 
#													for all axis have been created
#	07			22-Feb-2001		Frank Armbrust		Implement the axis mapping feature
#													by using the two variables:
#												    mom_sim_rot_mapping
#													mom_sim_trans_mapping
#	08			01-Apr-2001		Yakove Dayan		Merged return values by mom_sim_result variable 
#                                                   replaced mechanism to setup the transformation zcs to mtcs
#                                                   to be based on tracking a dedicated junction transformation 
#	09			17-Apr-2001		Yakove Dayan		Added MOM_SIM_set_offsets to compute tool/head
#                                                   offsets based on junctions 
#	10			05-Mai-2001		Frank Armbrust		Change the name of the global variable 
#													mom_sim_circular_last_pos(0) to mom_sim_circular_last_pos(X) 
#													and so on
#													Call the SIM_move_linear_zcs and SIM_move_linear_mtcs 
#													directly in the circulate interpolation routines to
#													avoid possible long string errors
#													Add new arguments to MOM_SIM_CircularIP3D and
#													MOM_SIM_CircularIP2D
#	11			30-Jun-2001	    Yakove Dayan        Added SIM_update_current_zcs
#                                                   SIM_update_current_gage_offsets
#                                                   did cleanup and changed S&V commands to be
#                                                   prefix by SIM and not MOM_SIM
#                                                   renames abs_to_mtc acs_to_mtcs
#	12			15-Jul-2001	    Yakove Dayan        Added default system dialog table
#	13			09-Sep-2001	    Yakove Dayan        Added new coordinate system handling and other misc. changes
#                                                   added macro commands
#   14          20-Oct-2001     Yakove Dayan        added SIM_create_zcs_junction, ..
#   15          25-Dec-2001     Yakove Dayan        added SIM_dbg* commands
#                                                   allow linear axis with names different than X, Y and Z.
#                                                   added helical support to circular interpolation.
#
#   16          05-Feb-2002     Yakove Dayan        do misc. cleanup before release
#   17          25-Feb-2002     Yakove Dayan        customized dialog additions,
#                                                   added SIM_ask_tool_position_zcs/mtcs
#   18          10-Mar-2002     Yakove Dayan        added check for close to zero radius on circular move
#   19          29-Apr-2002     Wilson Kurniawan    added ipw_show item & changed the mom_sim_dialog_table order
#   20          28-Jul-2002     Yakove Dayan        added SIM_ask/set_axis_rotary_dir_mode documentation
#                                                   incremental motion commands
#                                                   SIM_set/ask_axis_allow_reversal
#                                                   SIM_move_helical_zcs/mtcs
#                                                   SIM_move_inc_helical_zcs/mtcs
#                                                   set central tolerancing variable
#   21          26-Nov-2002     Thomas Schulz       Correct the name of the function
#                                                   SIM_move_inc_linear_mtcs
#   22          27-Nov-2002     Thomas Schulz       Add functions for NURBS
#                                                   support
#   23          28-Nov-2002     Wilson Kurniawan    Changed default system dialog table Syntax
#   24          28-Feb-2003     Jeremy Wight        move_linear_zcs_or_mtcs and move_circular_zcs_or_mtcs port
#   25          07-Apr-2003     Jeremy Wight        fix nurbs
#   26          08-Sep-2003     Jeremy Wight        PR4830634, PR4787351. Fix arc tolerance problem and Tcl typos.
#   27          16-Mar-2004     Wilson Kurniawan    PR4932674. Add user item inquiry function "SIM_dialog_ask_user_item_value"
#                                                   support merging lathe channel window
#
#   28          30-Apr-2004     Jason Detzel        Remove the sourcing of "sim_interpolation.tcl" which was replaced by C
#						                            functionality early in NX2
#   29          25-May-2004     Jason Detzel        Remove the sourcing of "sim_transformation.tcl" which was replaced by C
#						                            functionality early in NX2
#   30          05-Jul-2004     JM                  Remove SIM_set(ask)_rotary_axes_config, this is now a C function.
#                                                   It is evaluated in the high level motion commands if machining mode
#                                                   is MILL_CX. In this case the rotary axes config defines the current
#                                                   C axis of the Mill/Turn machine.
#	31			27-Jul-2004	    Wilson Kurniawan    Added default Channel Window dialog table.
#	32			15-Mar-2005	    Wilson Kurniawan    Remove SYS_SHOW_IPW_ITEM,SYS_ANIMATION_SPEED_ITEM items.
#	33			15-May-2006	    Wilson Kurniawan    Added mom_sim_display_user_item.
#	34			16-May-2006	    Wilson Kurniawan    Disable User Items by default
#
#$HISTORY$
#
################################################################################

#####################################################################
# 
#
# N O T E : The following are the high level S&V public commands that are defined 
#           in this file. All the rest of the commands found in this file are 
#           internal functions and are not intended to be called outside the 
#           scope of this file.
#
#           Also the list of the basic S&V commands is included
#
#  ========== High Level S&V Commands (TCL Commands) ============
#
# SIM_move_linear_zcs          - move axes in linear mode where coodinates are in ZCS
# SIM_move_linear_mtcs         - move axes in linear mode where coodinates are in MTCS
# SIM_move_circular_zcs        - move axes in circular mode where coodinates are in ZCS
# SIM_move_circular_mtcs       - move axes in circular mode where coodinates are in MTCS
# SIM_move_helical_zcs         - move axes in helical mode where coodinates are in ZCS
# SIM_move_helical_mtcs        - move axes in helical mode where coodinates are in MTCS
# SIM_move_inc_linear_zcs      - move axes incrementaly in linear mode where coodinates are in ZCS
# SIM_move_inc_linear_mtcs     - move axes incrementaly in linear mode where coodinates are in MTCS
# SIM_move_inc_circular_zcs    - move axes incrementaly in circular mode where coodinates are in ZCS
# SIM_move_inc_circular_mtcs   - move axes incrementaly in circular mode where coodinates are in MTCS
# SIM_move_inc_helical_zcs     - move axes incrementaly in helical mode where coodinates are in ZCS
# SIM_move_inc_helical_mtcs    - move axes incrementaly in helical mode where coodinates are in MTCS
# SIM_transform_mtcs_to_zcs    - transform point from MTCS to ZCS coordinate system
# SIM_transform_zcs_to_mtcs    - transform point from ZCS to MTCS coordinate system
# SIM_transform_point          - transform point specified in source junction to target junction
# SIM_transform_vector         - transform vector specified in source junction to target junction
# SIM_compute_transform        - compute transformation from source junction to target junction
# SIM_update_current_zcs       - set current ZCS junction and update ZCS <-> MTCS transformations
# SIM_convert_sim_to_mtd_units - converts a specified value from current part/simulation units to MTD units
# SIM_convert_mtd_to_sim_units - convert machine tool driver units to simulation(part) units
# SIM_invoke                   - a shell for invoking S&V commands. This avoids command invokation if S&V not active.
# SIM_ask_junction_origin_mtcs - returns the current or initial junction origin in MTCS coordinate system
# SIM_ask_offsets_mtcs         - return offsets between two junctions in mtcs coordinates
# SIM_ask_last_position_zcs    - Returns the last reference junction position in ZCS 
# SIM_ask_last_position_mtcs   - Returns the last reference junction position in MTCS
# SIM_ask_rotary_axes_map      - Returns the rotary axes mapping (logical to phisical axis mapping) 
# SIM_ask_linear_axes_map      - Returns the linear axes mapping (logical to phisical axis mapping) 
# SIM_ask_rotary_axes_config   - Returns the current rotary axes configuration ) 
# SIM_ask_tool_position_zcs    - Returns specified tool tip position and orientation i.r.t ZCS
# SIM_ask_tool_position_mtcs   - Returns specified tool tip position and orientation i.r.t MTCS
# SIM_set_rotary_axes_map      - Set the rotary axes mapping (logical to phisical axis mapping) 
# SIM_set_linear_axes_map      - Set the linear axes mapping (logical to phisical axis mapping) 
# SIM_set_rotary_axes_config   - Set the current rotary axes configuration  
# SIM_set_duration_callback_fct- set callback TCL function to compute duration of a delta motion
# SIM_macro_def                - start a definition of new macro
# SIM_macro_end                - end definition of a macro
# SIM_macro_call               - call a predefined macro
# SIM_macro_append_sv_cmd      - add a s&v command to macro
# SIM_macro_delete             - delete an existing macro 
# SIM_macro_delete_all         - delete all_macros
# SIM_map_logical_to_phisical_axis - map logical to phisical axis
# SIM_dialog_start             - start customized dialog definition
# SIM_dialog_end               - end customized dialog definition
# SIM_dialog_add_item          - add item to customized dialog
# SIM_dialog_set_item          - set attribute of an item in a customized dialog
# SIM_dialog_ask_user_item_value - Return the user item value
#
# ============ Basic S&V Commands (TCL Extenstions ) ==================
#
# SIM_mount_kim_comp           - mount specified component
# SIM_mount_tool               - mount specified tool
# SIM_unmount_kim_comp         - unmount specified component
# SIM_unmount_tool             - unmount tool
# SIM_move_linear_axis         - move one linear axis in axis coordinate system.
# SIM_move_rotary_axis         - move one rotary axes in axis coordinate system.
# SIM_set_parameter            - set engine parameters.
# SIM_update                   - create an step to update the state of the machine with all prior events
# SIM_step                     - create a sub-step event to perform intermidiate update of the machine state.
# SIM_mtd_init                 - initialize machine tool driver
# SIM_mtd_reset                - exit machine tool driver
# SIM_transform_offset_acs_to_mtcs - transform specified offset in absolute to mtcs coordinate system
# SIM_transform_matrix_acs_to_mtcs - transform specified matrix in absolute to mtcs coordinate system
# SIM_create_junction          - create a new junction
# SIM_create_zcs_junction      - utility function to create ZCS junction if not exists or return the one that exists
# SIM_delay                    - 'freeze' simulation for specified duration (in seconds)
# SIM_delete_junction          - delete an existing junction
# SIM_feedback_message         - send message to the message window 
# SIM_msg_user_feedback        - add feedback event that calls a user TCL procedure when event is processed.
# SIM_msg_nc_command           - send NC command to NC Program window
# SIM_msg_program_mark         - send program mark message to message window. Next/Previous operation steps to this mark
# SIM_start_of_simulation      - create and send start of simulation event
# SIM_end_of_simulation        - create and send end of simulation event
# SIM_activate_tool            - set specified tool as the active tool.
# SIM_ask_axis_position        - return the axis current position in axis coordinate system
# SIM_ask_axis_limits          - return limits of specified axis
# SIM_ask_current_ref_junction - Returns the current reference junction
# SIM_ask_current_zcs_junction - returns the name of current ZCS junction
# SIM_ask_is_junction_exist    - check if a junction exists
# SIM_ask_is_junction_dependent- return whether a specified junction is dependent on specified axis
# SIM_ask_junction_xform       - get the junction transformation in current machine state i.r.t absolute coordinate system
# SIM_ask_init_junction_xform  - get the initial junction transformation i.r.t absolute coordinate system
# SIM_ask_kim_comp_name_by_id  - get component name by its class and id
# SIM_ask_linear_axes_config   - Return the current linear axes configuration
# SIM_ask_mtcs_junction        - returns name of the MTCS junction
# SIM_ask_axis_dof_junction    - returns name of the NC axis junction and the degree of freedom axis
# SIM_ask_tool_offsets         - get the specified tool offsets
# SIM_ask_cording_tol          - get the cording tolernace for analytical curves (i.e, arc, spline)
# SIM_ask_mtd_units            - return the current MTD units
# SIM_ask_axis_rotary_dir_mode - returns the mode which controls the direction or rotation for rotary axis
# SIM_ask_axis_allow_reversal  - returns whether axis reversal is allowed
# SIM_set_current_ref_junction - Returns the current reference junction
# SIM_set_current_zcs_junction - set the current ZCS junction
# SIM_set_linear_axes_config   - Set the current rotary axes configuration
# SIM_set_mtd_units            - sets the input units of the S&V commands
# SIM_set_feed                 - set the current feedrate
# SIM_set_speed                - set the current speed
# SIM_set_coolant              - turn on/off the coolant
# SIM_set_cutting_mode         - set the current cutting mode
# SIM_set_channel              - set the current channel
# SIM_set_axis_rotary_dir_mode - set the mode which controls the direction or rotation for rotary axis
# SIM_set_axis_allow_reversal  - set whether axis reversal is allowed

# SIM_dbg_start                - Initialize S&V commands debugging tools
# SIM_dbg_end                  - Ends S&V commands debugging
# SIM_dbg_write_message        - Write message to the output listing device
# SIM_dbg_set_output           - Controls what data is output to the listing device

######################################################################

# source the other necessary files
set mom_sim_high_level_cmd_dir [MOM_ask_env_var UGII_CAM_POST_DIR]

source [file join $mom_sim_high_level_cmd_dir sim_math.tcl]
source [file join $mom_sim_high_level_cmd_dir sim_mtd_kinematics.tcl]

# puts -nonewline [format "%-70s" "Source [info script]..."]

#
################  Global MTD parameters ################
#
#
# Set the variable to Display the User Items in Simulation Control Panel
#
global mom_sim_display_user_item 
set mom_sim_display_user_item 0

set dialog_num_items 0

set mom_sim_dialog_table(0)  "SYS_LAST_ITEM"

#
# Define default Channel Window dialog table
#

set mom_sim_channel_window_dialog_attributes  "TITLE=<Channel Window>"
set mom_sim_channel_window_dialog_table(0)  "SYS_LAST_ITEM"

#-------------------------------------------------------------------------------
# this variable is used for the testing enviroment and writes some 
# debug informations on the tcl-console with the puts command
# set mom_sim_DEBUG_MODE 0 switch off the debug mode

set mom_sim_DEBUG_MODE 1

# offsets used in the S&V motion commands. those are the offsets 
# from current active coordinate system (MTCS as well as ZCS)
  set mom_sim_x_offset    0.0
  set mom_sim_y_offset    0.0
  set mom_sim_z_offset    0.0

#internal flag which indicates whether MTD has been initialized
set mom_sim_mtd_initialized 0

# define circle definition defined in absolute mode
set mom_sim_incr_circle_mode 0

#
# mapping of virtual axes to phisical axes
set mom_sim_linear_axes_map   [list ""]
set mom_sim_rotary_axes_map   [list ""]

#
# the recomputation of tool offsets is done when 
# this flag is set. 
set mom_sim_update_gage_offset_switch 0

#
# the from (normally tool tip) and to (reference junction
# on the machine) junctions that are used for offsets
# computation. 
set mom_sim_from_gage_offset_jct ""
set mom_sim_to_gage_offset_jct   ""

#
# macros initialization
set sim_macro_next_free 0
set sim_macro_number    0

#
# the callback function to compute duration
set mom_sim_duration_callback_fct ""

# set number of ZCS junctions defined
set mom_sim_zcs_junctions_count 0

#
# the offset of each axis in current axis configuration
# for now there is no need for that
# set mom_sim_axis_offsets(none) 0.0

#
# set linear and rotary axis resolution
set mom_sim_linear_axis_res    0.0001
set mom_sim_rotary_axis_res    0.0001

#
# arcs with smaller swept angle than this (in radians)
# are simulated as full circles
#
# 08-Sep-2003 jw - Kludgefix PR4787351 by dividing value by 100.
set mom_sim_angular_fullcircle 0.000001

#
# arcs with smaller radius than this
# are simulated as straight lines
set mom_sim_min_radius 0.01

#
# same point or zero tolerance
set mom_sim_zero_tol           0.0001 

################  END of MTD Globals ##########################


#-------------------------------------------------------------------------------
# 
proc MOM_SIM_ERROR_MSG { errstr } \
{
	# way for debugging: open file and write messages in the file
	#set file_id [open "debug.tcl" a]
	#puts $file_id $errstr
	#flush $file_id
	#close $file_id

    SIM_feedback_message "MTD Error" $errstr

	MOM_abort $errstr
}

proc MOM_SIM_DEBUG_MSG { errstr } \
{
	# way for debugging: open file and write messages in the file
	set file_id [open "sim_debug.err" a]
	puts $file_id $errstr
	flush $file_id
	close $file_id

#    SIM_feedback_message "MTD Debug" $errstr
}

proc MOM_SIM_INFO_MSG { infostr } \
{
	# puts $infostr
    SIM_feedback_message "MTD Info" $infostr

	MOM_log_message $infostr

}
proc MOM_SIM_WARNING_MSG { warnstr } \
{
	# puts $warnstr
    SIM_feedback_message "MTD Warning" $warnstr

	MOM_log_message $warnstr
}

#-------------------------------------------------------------------------------
#
# return the junction offsets from MTCS
#   JNC_name: the name of junction
#   state   : "CURRENT" or "INITIAL" 
#             returns junction offset in initial state of the machine
#             or in current state.
#=============================================================
proc SIM_ask_junction_origin_mtcs { JNC_name state } {
#=============================================================

 global mom_sim_result mom_sim_result1

 if { $state == "CURRENT" } {
    SIM_ask_junction_xform $JNC_name
 } else {
    SIM_ask_init_junction_xform $JNC_name
 }

 MOM_SIM_listToVector offset  $mom_sim_result1 3

 SIM_transform_offset_acs_to_mtcs $offset(1) $offset(2) $offset(3)   
 set mtcs_offset $mom_sim_result

 if {[llength $mtcs_offset] == 1} {set mtcs_offset [lindex $mtcs_offset  0] }

 return $mtcs_offset
}

#-------------------------------------------------------------------------------
#
# update the gage lengths offsets of the tool and the holder 
# if exists. 
#   from_jct: from junction name. normaly its the tool tip junction
#   to_jct:   to juncation name. normaly its the spindle junction
#   force_update: if specified, the update is done right away. otherwise
#                 the update will be done before the first motion command.       
#
#=============================================================
proc MOM_SIM_update_current_gage_offsets_old { from_jct to_jct args } {
#=============================================================
      global mom_sim_from_gage_offset_jct
      global mom_sim_to_gage_offset_jct
      global mom_sim_update_gage_offset_switch   
 
      set mom_sim_from_gage_offset_jct $from_jct
      set mom_sim_to_gage_offset_jct   $to_jct

      if {[llength $args] > 0  && $args } {
          MOM_SIM_set_offsets $from_jct $to_jct
         set mom_sim_update_gage_offset_switch 0
      } else {
         set mom_sim_update_gage_offset_switch 1
      }
}

#=============================================================
proc MOM_SIM_reset_current_gage_offsets_old { } {
#=============================================================
  global mom_sim_x_offset mom_sim_y_offset mom_sim_z_offset          

  set mom_sim_x_offset    0.0
  set mom_sim_y_offset    0.0
  set mom_sim_z_offset    0.0
}

#=============================================================
proc SIM_convert_sim_to_mtd_units { value } {
#=============================================================
  global mom_output_unit mom_part_unit mom_sim_result

#  upvar 0 $vector VEC
#  set length [array size VEC]

  # get the MTD units
  SIM_ask_mtd_units
  set mtd_unit $mom_sim_result 

  if { $mtd_unit == "MM" } {
     set is_mtd_metric 1
  } else {
     set is_mtd_metric 0
  }

  if { $mom_part_unit == "MM" } {
     set is_sim_metric 1
  } else {
     set is_sim_metric 0
  }

  set factor 1.0
  if { $is_sim_metric != $is_mtd_metric } {
      if { $is_sim_metric } {
        set factor [expr 1.0/25.4]
      } else {
        set factor 25.4
      }  
  }

#  for {set i 0} {$i<$length} {incr i} {
#	set RESULT($i) [expr $VEC($i)*$factor]
#  }

  return [expr {$value*$factor}]
}

#=============================================================
proc SIM_convert_mtd_to_sim_units { value } {
#=============================================================
  global mom_output_unit mom_part_unit mom_sim_result

#  upvar 0 $vector VEC
#  set length [array size VEC]

  # get the MTD units
  SIM_ask_mtd_units
  set mtd_unit $mom_sim_result 

  if { $mtd_unit == "MM" } {
     set is_mtd_metric 1
  } else {
     set is_mtd_metric 0
  }

  if { $mom_part_unit == "MM" } {
     set is_sim_metric 1
  } else {
     set is_sim_metric 0
  }

  set factor 1.0
  if { $is_sim_metric != $is_mtd_metric } {
      if { $is_mtd_metric } {
        set factor [expr 1.0/25.4]
      } else {
        set factor 25.4
      }  
  }

  return [expr {$value*$factor}]
}

#
# set the current ZCS junction and compute the ZCS to MTCS
# transformation
#   zcs_jct: the current ZCS junction
#
#
#=============================================================
proc SIM_update_current_zcs { zcs_jct } {
#=============================================================

 SIM_set_current_zcs_junction $zcs_jct
 MOM_SIM_set_zcs_to_mtcs_xfm $zcs_jct
}


#
# this function computes the delta X, delta Y and delta Z
# between the two junctions in MTCS coordinate system and
# sets the global offsets.
#
#=============================================================
proc MOM_SIM_set_offsets { from_jct to_jct } {
#=============================================================

 global mom_sim_result mom_sim_result1
 global mom_sim_x_offset mom_sim_y_offset mom_sim_z_offset  

 set vector [ SIM_ask_offsets_mtcs $from_jct $to_jct CURRENT ]

 set mom_sim_x_offset [lindex $vector  0]
 set mom_sim_y_offset [lindex $vector  1]
 set mom_sim_z_offset [lindex $vector  2]
}

#
# this function computes the delta X, delta Y and delta Z
# between the two junctions in MTCS coordinate system.
#
#   state   : "CURRENT" or "INITIAL" 
#             returns  offsets in initial state of the machine
#             or in current state.
#
#=============================================================
proc SIM_ask_offsets_mtcs { from_jct to_jct state } {
#=============================================================

 set from_offset [SIM_ask_junction_origin_mtcs $from_jct $state]

 set to_offset [SIM_ask_junction_origin_mtcs $to_jct $state]

 #
 # compute the offset vector
 set vector [ MOM_SIM_VDiffL $to_offset  $from_offset ]

 return $vector
}

# The JNC_name parameter is the junction that represents the
# current ZCS and it computes the zcs to mtcs transformation 
# and set it accordingly. 
#

#=============================================================
proc MOM_SIM_set_zcs_to_mtcs_xfm { JNC_name } {
#=============================================================

 global mom_sim_result mom_sim_result1
 global mom_sim_matrix_zcs_to_mtcs mom_sim_offset_zcs_to_mtcs

 # get current junction transformation
 SIM_ask_junction_xform $JNC_name 

 MOM_SIM_listToVector abs_matrix  $mom_sim_result  9
 MOM_SIM_listToVector abs_offset  $mom_sim_result1 3

 SIM_transform_offset_acs_to_mtcs $abs_offset(1) $abs_offset(2)  $abs_offset(3)   
 set mom_sim_offset_zcs_to_mtcs $mom_sim_result

 SIM_transform_matrix_acs_to_mtcs $abs_matrix(1) $abs_matrix(2) $abs_matrix(3) $abs_matrix(4) $abs_matrix(5) $abs_matrix(6) $abs_matrix(7) $abs_matrix(8) $abs_matrix(9)
 set mom_sim_matrix_zcs_to_mtcs $mom_sim_result

 if {[llength $mom_sim_matrix_zcs_to_mtcs] == 1} {set mom_sim_matrix_zcs_to_mtcs [lindex $mom_sim_matrix_zcs_to_mtcs  0] }
 if {[llength $mom_sim_offset_zcs_to_mtcs] == 1} {set mom_sim_offset_zcs_to_mtcs [lindex $mom_sim_offset_zcs_to_mtcs  0] }

}


#-------------------------------------------------------------------------------
#SIM_invoke
#
#	Modul:    IS&V
#
#	Task:		    Invoke S&V command. S&V commands should 
#                           be invoked indirectly using this function. 
#                           This is must when the controller mode is
#                           NC_CONTROLLER_MTD_EVENT_HANDLER, otherwise
#                           the S&V commands will be known in nc-program
#                           generation
#
#	Arguments:				
#
#	Results: depends on exception handling code
#
# 	Last modification:	06.02.2001
#	
# 	Owner:					
#-------------------------------------------------------------------------------

proc SIM_invoke { sv_command args } \
{
# remove outer braces 
	set args [join $args]
#	if [catch {

      global mom_sim_mtd_initialized

      set sim_return  TCL_OK

      if { $sv_command == "SIM_mtd_init" } {
     
        #-- set MTD internal flag that the MTD has been initialized
        #   properly
        set mom_sim_mtd_initialized 1
      }

      if { $mom_sim_mtd_initialized } {

            set sim_return [ eval $sv_command $args ]
      } else {
#          MOM_SIM_DEBUG_MSG "Failed processing command $sv_command $args"
#          MOM_SIM_DEBUG_MSG "Machine Tool Driver has not been initialized properly"
          MOM_SIM_ERROR_MSG "Machine Tool Driver has not been initialized properly"
      }
      
      if { $sv_command == "SIM_mtd_reset" } {

        set mom_sim_mtd_initialized 0
      } 

      return $sim_return

#	} result] {MOM_SIM_ERROR_MSG $result}
}

#-------------------------------------------------------------------------------
#SIM_move_inc_linear_zcs
#
#	Modul: 					IS&V
#
#	Task:				    high level function for axis motion related to
#						    the current ZCS. coordinates are INCREMENTAL.
#
#	Arguments:				'axis name' 'incremental axis position' 
#								(e.g. X 12 Z -23.9 Y 24.9 A 45)
#
#-------------------------------------------------------------------------------

proc SIM_move_inc_linear_zcs { args } \
{
  return [ MOM_SIM_move_linear_zcs_or_mtcs $args [SIM_ask_current_zcs_junction] INCREMENTAL]
}

#-------------------------------------------------------------------------------
#SIM_move_linear_zcs
#
#	Modul: 					IS&V
#
#	Task:				    high level function for axis motion related to
#						    the current ZCS.
#
#	Arguments:				'axis name' 'axis position' 
#								(e.g. X 12 Z -23.9 Y 24.9 A 45)
#
#-------------------------------------------------------------------------------

proc SIM_move_linear_zcs { args } \
{
  return [ MOM_SIM_move_linear_zcs_or_mtcs $args [SIM_ask_current_zcs_junction] ABSOLUTE ]
}

#-------------------------------------------------------------------------------
#SIM_move_inc_linear_mtcs
#
#	Modul: 					IS&V
#
#	Task:						high level function for axis motion related to
#								the MTCS. Coordinates are INCREMENTAL
#
#	Arguments:				'axis name' 'incremental axisvalues'
#								(e.g. X 12 Z -23.9 Y 24.9 A 45)
#
#	Results:					depends on exception handling code
#
# 	Last modification:	07.05.2001
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc SIM_move_inc_linear_mtcs { args } \
{
  global mom_sim_result
  SIM_ask_mtcs_junction
  return [ MOM_SIM_move_linear_zcs_or_mtcs $args $mom_sim_result INCREMENTAL ]
}


#-------------------------------------------------------------------------------
#SIM_move_linear_mtcs
#
#	Modul: 					IS&V
#
#	Task:						high level function for axis motion related to
#								the MTCS
#
#	Arguments:				axistypes axisvalues
#								(e.g. X 12 Z -23.9 Y 24.9 A 45)
#
#	Results:					depends on exception handling code
#
# 	Last modification:	07.05.2001
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc SIM_move_linear_mtcs { args } \
{
  global mom_sim_result
  SIM_ask_mtcs_junction
  return [ MOM_SIM_move_linear_zcs_or_mtcs $args $mom_sim_result ABSOLUTE ]
}


#-------------------------------------------------------------------------------
#SIM_move_circular_zcs
#
#	Modul: 					IS&V
#
#	Task:						high level function for circular motion related
#								to the ZCS
#
#	Arguments:				axistypes axisvalues
#								(e.g. 0 0 1 X 12 Z -23.9 Y 24.9 I 243 J 89 K 72
#								or 0 0 1 X 13 Y 534 Z 625 R 524)
#
#	Results:					depends on exception handling code
#
# 	Last modification:	07.05.2001
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------
proc SIM_move_circular_zcs { Ux Uy Uz args } \
{
  return [ MOM_SIM_move_circular_zcs_or_mtcs $Ux $Uy $Uz $args \
           [SIM_ask_current_zcs_junction] ABSOLUTE]
}

#-------------------------------------------------------------------------------
#SIM_move_inc_circular_zcs
#
#	Modul: 					IS&V
#
#	Task:						high level function for circular motion related
#								to the ZCS. End position are INCREMENTAL step in respect
#                               to last position
#
#	Arguments:				'plane normal' 'axis name' 'incremental axis position'
#								(e.g. 0 0 1 X 12 Z -23.9 Y 24.9 I 243 J 89 K 72
#								or 0 0 1 X 13 Y 534 Z 625 R 524)
#
#	Results:					depends on exception handling code
#
# 	Last modification:	07.05.2001
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------
proc SIM_move_inc_circular_zcs { Ux Uy Uz args } \
{
  return [ MOM_SIM_move_circular_zcs_or_mtcs $Ux $Uy $Uz $args \
           [SIM_ask_current_zcs_junction] INCREMENTAL]
}

#-------------------------------------------------------------------------------
#SIM_move_helical_zcs
#
#	Modul: 					IS&V
#
#	Task:				    high level function for helical motion related
#							to the ZCS. Syntax same as SIM_move_circular_zcs
#                           with the following extension:
#                           P 'pitch in radians' - P and value is specififed
#                           where each revolution is 2*PI. The end point should
#                           match the pitch value and should have the correct depth
#                           position.
#                           If pitch is less than 2*PI, then only the correct end position
#                           could be specified.
#
#	Arguments:				see SIM_move_circular_zcs
#
#	Results:					depends on exception handling code
#
# 	Last modification:	02.07.2002
#	
# 	Owner:					Yakove Dayan
#-------------------------------------------------------------------------------
proc SIM_move_helical_zcs { Ux Uy Uz args } \
{
  # add pitch if not specified (in case of helical move that is
  # less than 2*PI)

  if {[lsearch -exact $args "P"] == -1} {
    set args "$args P 0"
  }

  return [ MOM_SIM_move_circular_zcs_or_mtcs $Ux $Uy $Uz $args \
           [SIM_ask_current_zcs_junction] ABSOLUTE]
}

#-------------------------------------------------------------------------------
#SIM_move_inc_helical_zcs
#
#	Modul: 					IS&V
#
#	Task:				    high level function for INCREMENTAL helical motion related
#							to the ZCS. Syntax same as SIM_move_inc_circular_zcs
#                           with the following extension:
#                           P 'pitch in radians' - P and value is specififed
#                           where each revolution is 2*PI. The end point should
#                           match the pitch value and should have the correct depth
#                           position.
#                           If pitch is less than 2*PI, then only the correct end position
#                           could be specified.
#
#	Arguments:				see SIM_move_inc_circular_zcs
#
#	Results:					depends on exception handling code
#
# 	Last modification:	02.07.2002
#	
# 	Owner:					Yakove Dayan
#-------------------------------------------------------------------------------
proc SIM_move_inc_helical_zcs { Ux Uy Uz args } \
{
  # add pitch if not specified (in case of helical move that is
  # less than 2*PI)

  if {[lsearch -exact $args "P"] == -1} {
    set args "$args P 0"
  }

  return [ MOM_SIM_move_circular_zcs_or_mtcs $Ux $Uy $Uz $args \
           [SIM_ask_current_zcs_junction] INCREMENTAL]
}

#-------------------------------------------------------------------------------
#SIM_move_circular_mtcs
#
#	Modul: 					IS&V
#
#	Task:						high level function for circular motion related
#								to the MTCS
#
#	Arguments:				rotation vector, axistypes axisvalues
#								(e.g. 0 0 1 X 12 Z -23.9 Y 24.9 I 243 J 89 K 72
#								or 0 0 1 X 13 Y 534 Z 625 R 524)
#
#	Results:					depends on exception handling code
#
# 	Last modification:	07.05.2001
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------
proc SIM_move_circular_mtcs { Ux Uy Uz args } \
{
  global mom_sim_result
  SIM_ask_mtcs_junction
  return [ MOM_SIM_move_circular_zcs_or_mtcs $Ux $Uy $Uz $args \
           $mom_sim_result ABSOLUTE]
}

#-------------------------------------------------------------------------------
#SIM_move_inc_circular_mtcs
#
#	Modul: 					IS&V
#
#	Task:						high level function for circular motion related
#								to the MTCS. End position are INCREMENTAL step in respect
#                               to last position
#
#	Arguments:				'axis name' 'incremental axis position'
#								(e.g. 0 0 1 X 12 Z -23.9 Y 24.9 I 243 J 89 K 72
#								or 0 0 1 X 13 Y 534 Z 625 R 524)
#
#	Results:					depends on exception handling code
#
# 	Last modification:	07.05.2001
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------
proc SIM_move_inc_circular_mtcs { Ux Uy Uz args } \
{
  global mom_sim_result
  SIM_ask_mtcs_junction
  return [ MOM_SIM_move_circular_zcs_or_mtcs $Ux $Uy $Uz $args \
           $mom_sim_result INCREMENTAL]
}

#-------------------------------------------------------------------------------
#SIM_move_helical_mtcs
#
#	Modul: 					IS&V
#
#	Task:				    high level function for helical motion related
#							to the ZCS. Syntax same as SIM_move_circular_mtcs
#                           with the following extension:
#                           P 'pitch in radians' - P and value is specififed
#                           where each revolution is 2*PI. The end point should
#                           match the pitch value and should have the correct depth
#                           position.
#                           If pitch is less than 2*PI, then only the correct end position
#                           could be specified.
#
#	Arguments:				see SIM_move_circular_mtcs
#
#	Results:					depends on exception handling code
#
# 	Last modification:	02.07.2002
#	
# 	Owner:					Yakove Dayan
#-------------------------------------------------------------------------------
proc SIM_move_helical_mtcs { Ux Uy Uz args } \
{
  global mom_sim_result

  # add pitch if not specified (in case of helical move that is
  # less than 2*PI)

  if {[lsearch -exact $args "P"] == -1} {
    set args "$args P 0"
  }

  SIM_ask_mtcs_junction
  return [ MOM_SIM_move_circular_zcs_or_mtcs $Ux $Uy $Uz $args \
           $mom_sim_result ABSOLUTE]
}

#-------------------------------------------------------------------------------
#SIM_move_inc_helical_mtcs
#
#	Modul: 					IS&V
#
#	Task:				    high level function for INCREMENTAL helical motion related
#							to the MTCS. Syntax same as SIM_move_inc_circular_mtcs
#                           with the following extension:
#                           P 'pitch in radians' - P and value is specififed
#                           where each revolution is 2*PI. The end point should
#                           match the pitch value and should have the correct depth
#                           position.
#                           If pitch is less than 2*PI, then only the correct end position
#                           could be specified.
#
#	Arguments:				see SIM_move_inc_circular_mtcs
#
#	Results:					depends on exception handling code
#
# 	Last modification:	02.07.2002
#	
# 	Owner:					Yakove Dayan
#-------------------------------------------------------------------------------
proc SIM_move_inc_helical_mtcs { Ux Uy Uz args } \
{
  global mom_sim_result

  # add pitch if not specified (in case of helical move that is
  # less than 2*PI)

  if {[lsearch -exact $args "P"] == -1} {
    set args "$args P 0"
  }

  SIM_ask_mtcs_junction
  return [ MOM_SIM_move_circular_zcs_or_mtcs $Ux $Uy $Uz $args \
           $mom_sim_result INCREMENTAL]
}

################################################################################

#-------------------------------------------------------------------------------
#MOM_SIM_matchPattern
#
#	Modul: 					syntax
#
#	Task:						used by syntax module NCTK_matchPattern
#								(match pattern of the ncline)
#								useful for nc-syntax : X-10 Y89.98 A24
#
#	Arguments:				ncline, scope level (should be 1, if this procedure
#								is called from a subroutine)
#
#	Results:					pattern
#
# 	Last modification:	02.03.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_matchPattern { ncline {level #0}} {
	upvar $level $ncline var
	set address { X Y Z A B C I J K R }
	set var [string trim $var]
	set code ""
	foreach pat [join $address] { 
		if {[set index [string first $pat $var]]==0} {
			lappend code $pat
		}
	}
	if {$code == ""} \
	{
		#	no match
	} \
	else \
	{
		set code [lindex [lsort -command MOM_SIM_maxLength $code] end]
		set var [string range $var [string length $code] [string length $var]]
	}
	uplevel $level [list set $ncline $var]
	return $code
}
# End of procedure

#-------------------------------------------------------------------------------
#MOM_SIM_matchValue
#
#	Modul: 					syntax	
#
#	Task:						used by syntax module NCTK_matchValue
#								(match value of the ncline)
#								useful for nc-syntax : X-10 Y89.98 A24
#
#	Arguments:				ncline, scope level (should be 1, if this procedure
#								is called from a subroutine)	
#
#	Results:					value
#
# 	Last modification:	02.03.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_matchValue { ncline {level #0}} {
	set value ""
	upvar $level $ncline var
	if {$var!=""} { 
		set var [string trim $var]
		if {[regexp -- {^(([+-]?[0-9])+\.?([0-9]+)?)(.*)} $var all value p q post]} {
			set var $post
		} 
	}
	uplevel $level [list set $ncline $var]
	return $value
}
# End of procedure

#-------------------------------------------------------------------------------
#MOM_SIM_maxLength
#
#	Modul: 					syntax
#
#	Task:						used by syntax module NCTK_matchPattern
#
#	Arguments:	
#
#	Results:			
#
# 	Last modification:	02.03.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_maxLength {a b} {
	if {[string length $a]<[string length $b]}  { return -1 }
	if {[string length $a]==[string length $b]} { return 0  }
	if {[string length $a]>[string length $b]}  { return 1  }
}
# End of procedure

#-------------------------------------------------------------------------------
#MOM_SIM_CalculateSegments
#
#	Modul: 					IS&V
#
#	Task:						calculates the length of one segment by a given 
#								tolerance
#
#	Arguments:				tolerance, radius
#
#	Results:					segment length
#
# 	Last modification:	27.10.2000
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc MOM_SIM_CalculateSegments { tol r } \
{
    global mom_sim_linear_axis_res

    if { $r < $mom_sim_linear_axis_res || $tol > $r} { return 1 }

	set alpha [expr {2 * acos(1 - $tol/$r)}]

	return [expr {sqrt(2*$r*$r*(1-cos($alpha)))}]
}
# End of procedure

#-------------------------------------------------------------------------------
# SIM_transform_mtcs_to_zcs
#
#	Modul: 					IS&V
#
#	Task:						transform a given position X Y Z from the MTCS to
#								the ZCS coordinate system
#
#	Arguments:				position in MTCS coordinates 
#
#	Results:					position in ZCS coordinates	
#
# 	Last modification:	09.02.2001
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc SIM_transform_mtcs_to_zcs { X Y Z } \
{
	global mom_sim_matrix_zcs_to_mtcs
	global mom_sim_offset_zcs_to_mtcs
	
	set vector [list $X $Y $Z]

	##	perform transformation instruction (mom_sim_offset_zcs_to_mtcs)
	if {[info exists mom_sim_offset_zcs_to_mtcs]} \
	{
		#	displace actual position
		set vector [MOM_SIM_VDiffL $vector $mom_sim_offset_zcs_to_mtcs]
	}	
	
	##	perform rotation instruction (mom_sim_matrix_zcs_to_mtcs)
	if {[info exists mom_sim_matrix_zcs_to_mtcs]} \
	{
		#	rotate actual position
		set vector [MOM_SIM_MatMultVectorL [MOM_SIM_MatInvertL $mom_sim_matrix_zcs_to_mtcs] $vector]
	}

	return [list [lindex $vector 0] [lindex $vector 1] [lindex $vector 2]]
}

#-------------------------------------------------------------------------------
# SIM_transform_zcs_to_mtcs
#
#	Modul: 					IS&V
#
#	Task:						transform a given position X Y Z from the ZCS to
#								the MTCS coordinate system
#
#	Arguments:				position in ZCS coordinates
#
#	Results:					position in MTCS coordinates	
#
# 	Last modification:	09.02.2001
#	
# 	Owner:					Frank Armbrust
#-------------------------------------------------------------------------------

proc SIM_transform_zcs_to_mtcs { X Y Z } \
{
	global mom_sim_matrix_zcs_to_mtcs
	global mom_sim_offset_zcs_to_mtcs
	
	set vector [list $X $Y $Z]

	#	perform rotation instruction (mom_sim_matrix_zcs_to_mtcs)
	if {[info exists mom_sim_matrix_zcs_to_mtcs]} \
	{
		#	rotate actual position
		set vector [MOM_SIM_MatMultVectorL $mom_sim_matrix_zcs_to_mtcs $vector]
	}
	#	perform transformation instruction (mom_sim_offset_zcs_to_mtcs)
	if {[info exists mom_sim_offset_zcs_to_mtcs]} \
	{
		#	displace actual position
		set vector [MOM_SIM_VAddL $vector $mom_sim_offset_zcs_to_mtcs]
	}

	return [list [lindex $vector 0] [lindex $vector 1] [lindex $vector 2]]
}

proc SIM_dialog_start { att } \
{
  global mom_sim_channel_window_dialog_attributes mom_sim_channel_window_dialog_table channel_window_dialog_num_items channel_window_dialog
  global mom_sim_dialog_attributes mom_sim_dialog_table dialog_num_items
  
  set attributes	[lrange $att 1 end]
  set entry			[lindex $att 0]

  if { $entry == "SYS_CHANNEL_WINDOW" } \
  {
     set channel_window_dialog 1
     set channel_window_dialog_num_items 0

     set mom_sim_channel_window_dialog_attributes $attributes
     unset mom_sim_channel_window_dialog_table
     set mom_sim_channel_window_dialog_table(0) "SYS_LAST_ITEM"
  } \
  else \
  {
     set channel_window_dialog 0
     set dialog_num_items 0
     
     if { $entry == "SYS_MAIN_CONTROL_PANEL" } \
     {
        set mom_sim_dialog_attributes $attributes
     } \
     else \
     {
        set mom_sim_dialog_attributes "TITLE=<$att>"
     }

     unset mom_sim_dialog_table
     set mom_sim_dialog_table(0)   "SYS_LAST_ITEM" 
  }
}

proc SIM_dialog_add_item { entry } \
{
  global mom_sim_channel_window_dialog_table channel_window_dialog_num_items channel_window_dialog
  global mom_sim_dialog_table dialog_num_items

  if {$channel_window_dialog} \
  {
     set mom_sim_channel_window_dialog_table($channel_window_dialog_num_items) $entry
     set channel_window_dialog_num_items [expr {$channel_window_dialog_num_items + 1}]
  } \
  else \
  {
    set mom_sim_dialog_table($dialog_num_items) $entry
    set dialog_num_items [expr {$dialog_num_items + 1}]
  }
}

proc SIM_dialog_end { } \
{
  global mom_sim_channel_window_dialog_table channel_window_dialog_num_items channel_window_dialog
  global mom_sim_dialog_table dialog_num_items

  if {$channel_window_dialog} \
  {
     set mom_sim_channel_window_dialog_table($channel_window_dialog_num_items) "SYS_LAST_ITEM"
     set channel_window_dialog_num_items [expr {$channel_window_dialog_num_items + 1}]
  } \
  else \
  {
    set mom_sim_dialog_table($dialog_num_items) "SYS_LAST_ITEM"
    set dialog_num_items [expr {$dialog_num_items + 1}]
  }
}

#==================================================================
# proc SIM_dialog_ask_user_item_value
#
# Description
#     Inquiry User Item Value (USR_STRING_ITEM and USR_RADIO_ITEM)
#
# Usage
#     set my_user_item_value [SIM_dialog_ask_user_item_value "U3"]
#
# Returns:
#     User Item Value  
#==================================================================
proc SIM_dialog_ask_user_item_value { item_id } \
{
  global mom_user_item_values
  
  if {[info exists mom_user_item_values($item_id)]} \
  {
      return $mom_user_item_values($item_id)
  }
}

#
# mapping of virtual axes to phisical axes
# Note: axes is a list
proc SIM_set_linear_axes_map { axes } \
{ 
  global mom_sim_linear_axes_map
  set mom_sim_linear_axes_map   $axes
}

proc SIM_ask_linear_axes_map { } \
{ 
  global mom_sim_linear_axes_map
  return $mom_sim_linear_axes_map 
}

proc SIM_set_rotary_axes_map { axes } \
{ 
  global mom_sim_rotary_axes_map
  set mom_sim_rotary_axes_map   $axes
}

proc SIM_ask_rotary_axes_map { } \
{ 
  global mom_sim_rotary_axes_map
  return $mom_sim_rotary_axes_map 
}

#=============================================================
proc SIM_ask_last_position_zcs { } {
#=============================================================
 set vector [ MOM_SIM_ask_last_position [SIM_ask_current_zcs_junction] ]
 return $vector
}

#=============================================================
proc SIM_ask_last_position_mtcs { } {
#=============================================================
 global mom_sim_result
 SIM_ask_mtcs_junction
 set vector [ MOM_SIM_ask_last_position $mom_sim_result ]
 return $vector
}


#=============================================================
proc SIM_set_duration_callback_fct  { cb } {
#=============================================================

global mom_sim_duration_callback_fct

set mom_sim_duration_callback_fct $cb

}

#=============================================================
proc MOM_SIM_calculate_duration { linear_or_angular delta } {
#=============================================================

  global mom_sim_duration_callback_fct

  if { $mom_sim_duration_callback_fct == "" } {
    return 0
  } else {
    return [ $mom_sim_duration_callback_fct $linear_or_angular $delta ]
  }
}

#=============================================================
proc SIM_macro_def { macro_name } {
#=============================================================
  global sim_macro_current      # name of current cycle
  global sim_macro_num_motions  # number of motions in current cycle
  global sim_macro_number       # how many cyles are defined currenly only one is allowed
  global sim_macro_sv_cmds      # array of sv_commands structure:
                                #   (0) name of macro
                                #   (1) number of sv cms in cycle
                                #   (2..n) list of commands
  global sim_macro_list         # list of macros
  global sim_macro_next_free    # next free location in sim_macro_sv_cmds
  global sim_macro_index        # index to sim_macro_sv_cmds where macro starts

  #
  # check if macro already exists. if yes delete it.
  set macroId -1;
  for {set i 0} {$i<$sim_macro_number} {incr i} {
 	 if { $sim_macro_list($i) == $macro_name } {
       set macroId $i
       set i       $sim_macro_number
     }
  }

  if { $macroId != -1 } {
    SIM_macro_delete $macro_name
  }

  set sim_current_cycle                         $macro_name
  set sim_macro_sv_cmds($sim_macro_next_free)   $macro_name

  set n                                         [expr {$sim_macro_next_free+1}]
  set sim_macro_sv_cmds($n)                     0
  set sim_macro_num_motions                     0
  set sim_macro_index($sim_macro_number)        $sim_macro_next_free
  set sim_macro_next_free                       [expr {$sim_macro_next_free+2}]

  
  #append command to update current position
  SIM_macro_append_sv_cmd sim__mtd_update_last_pos
}

#=============================================================
proc SIM_macro_end { macro_name } {
#=============================================================
  global sim_macro_current      # name of current cycle
  global sim_macro_num_motions  # number of motions in current cycle
  global sim_macro_number       # how many cyles are defined currenly only one is allowed
  global sim_macro_sv_cmds      # array of sv_commands structure:
                                #   (0) name of cycle
                                #   (1) number of sv cms in cycle
                                #   (2..n) list of commands  
  global sim_macro_list         # list of macros
  global sim_macro_next_free    # next free location in sim_macro_sv_cmds
  global sim_macro_index        # index to sim_macro_sv_cmds where macro starts


  set n [expr {$sim_macro_index($sim_macro_number) + 1} ]
  set sim_macro_sv_cmds($n)   $sim_macro_num_motions
  set sim_current_cycle       ""

  set sim_macro_list($sim_macro_number)   $macro_name
  set sim_macro_number                    [ expr {$sim_macro_number + 1}]
}

#=============================================================
proc SIM_macro_append_sv_cmd { sv_cmd } {
#=============================================================
  global sim_macro_current      # name of current cycle
  global sim_macro_num_motions  # number of motions in current cycle
  global sim_macro_number       # how many cyles are defined currenly only one is allowed
  global sim_macro_sv_cmds      # array of sv_commands structure:
                                #   (0) name of cycle
                                #   (1) number of sv cms in cycle
                                #   (2..n) list of commands
  global sim_macro_list         # list of macros
  global sim_macro_next_free    # next free location in sim_macro_sv_cmds
  global sim_macro_index        # index to sim_macro_sv_cmds where macro starts
 
  set sim_macro_sv_cmds($sim_macro_next_free) $sv_cmd
  set sim_macro_num_motions [expr { $sim_macro_num_motions + 1 } ]
  set sim_macro_next_free [expr {$sim_macro_next_free + 1}]
}

#=============================================================
proc sim__mtd_update_last_pos {  } {
#=============================================================

  global sim_last_X sim_last_Y sim_last_Z
  global sim_last_tool_axis_X sim_last_tool_axis_Y sim_last_tool_axis_Z

  # update last position and tool axis needed by s&v commands
  set pos_and_axis [SIM_ask_tool_position_zcs [SIM_ask_current_ref_junction] ]

  set sim_last_X [lindex $pos_and_axis 0] 
  set sim_last_Y [lindex $pos_and_axis 1]   
  set sim_last_Z [lindex $pos_and_axis 2] 

  set sim_last_tool_axis_X [lindex $pos_and_axis 3] 
  set sim_last_tool_axis_Y [lindex $pos_and_axis 4]   
  set sim_last_tool_axis_Z [lindex $pos_and_axis 5] 
}

#=============================================================
proc SIM_macro_call { macro_name } {
#=============================================================
  global sim_last_X sim_last_Y sim_last_Z
  global sim_macro_current      # name of current cycle
  global sim_macro_num_motions  # number of motions in current cycle
  global sim_macro_number       # how many cyles are defined currenly only one is allowed
  global sim_macro_sv_cmds      # array of sv_commands structure:
                                #   (0) name of cycle
                                #   (1) number of sv cms in cycle
                                #   (2..n) list of commands
  global sim_macro_list         # list of macros
  global sim_macro_next_free    # next free location in sim_macro_sv_cmds
  global sim_macro_index        # index to sim_macro_sv_cmds where macro starts

#MOM_SIM_DEBUG_MSG ">> SIM_macro_call"

  set macroId -1;
  for {set i 0} {$i<$sim_macro_number} {incr i} {
 	 if { $sim_macro_list($i) == $macro_name } {
       set macroId $i
       set i       $sim_macro_number
     }
  }

  if { $macroId == -1 } {
    MOM_SIM_ERROR_MSG "Macro $macro_name NOT found"
    return
  }

  set l1  [expr {$sim_macro_index($macroId) + 2}]
  set n   [expr {$sim_macro_index($macroId) + 1}]
  set l2  [expr {$l1 + $sim_macro_sv_cmds($n)} ]

  for {set i $l1} {$i>=$l1 && $i<$l2} {incr i} {
#     MOM_SIM_DEBUG_MSG "CMD=$sim_macro_sv_cmds($i)"
 	 eval $sim_macro_sv_cmds($i)
  }
}

#=============================================================
proc SIM_macro_delete { macro_name } {
#=============================================================
  global sim_last_X sim_last_Y sim_last_Z
  global sim_macro_current      # name of current cycle
  global sim_macro_num_motions  # number of motions in current cycle
  global sim_macro_number       # how many cyles are defined currenly only one is allowed
  global sim_macro_sv_cmds      # array of sv_commands structure:
                                #   (0) name of cycle
                                #   (1) number of sv cms in cycle
                                #   (2..n) list of commands
  global sim_macro_list         # list of macros
  global sim_macro_next_free    # next free location in sim_macro_sv_cmds
  global sim_macro_index        # index to sim_macro_sv_cmds where macro starts

  set macroId -1;
  for {set i 0} {$i<$sim_macro_number} {incr i} {
 	 if { $sim_macro_list($i) == $macro_name } {
       set macroId $i
       set i       $sim_macro_number
     }
  }

  if { $macroId == -1 } {
    return
  }

  if { $macroId == 0 && $sim_macro_number == 1} {
    SIM_macro_delete_all
  }

  set sim_macro_list($macroId)    "_DELETED"
}

#=============================================================
proc SIM_macro_delete_all { } {
#=============================================================
  global sim_last_X sim_last_Y sim_last_Z
  global sim_macro_current      # name of current cycle
  global sim_macro_num_motions  # number of motions in current cycle
  global sim_macro_number       # how many cyles are defined currenly only one is allowed
  global sim_macro_sv_cmds      # array of sv_commands structure:
                                #   (0) name of cycle
                                #   (1) number of sv cms in cycle
                                #   (2..n) list of commands
  global sim_macro_list         # list of macros
  global sim_macro_next_free    # next free location in sim_macro_sv_cmds
  global sim_macro_index        # index to sim_macro_sv_cmds where macro starts

  unset sim_macro_sv_cmds
  unset sim_macro_list
  unset sim_macro_index

  set   sim_macro_current  ""
  set   sim_macro_next_free 0
  set   sim_macro_number    0

}

#
# create a ZCS junction. First the system checks whether a corresponding
# ZCS exists. if yes, and all its data matches, then its name is returned
# otherwise, a new one is created.
#=============================================================
proc SIM_create_zcs_junction { zcs_name dest_cmp origin  mtx } {
#=============================================================
 global mom_sim_zcs_junctions_count 
 global mom_sim_zcs_junction_names
 global mom_sim_zcs_junction_origin
 global mom_sim_zcs_junction_mtx
 global mom_sim_zcs_junction_dest_comp
 global mom_sim_result

#MOM_SIM_DEBUG_MSG " "
#MOM_SIM_DEBUG_MSG ">>>> zcs_name=$zcs_name dest_cmp=$dest_cmp origin=$origin mtx=$mtx"

 #
 # convert lists to vectors
 #
 MOM_SIM_listToVector originV $origin 3
 MOM_SIM_listToVector mtxV $mtx 9

 #
 # check if junction already specified. 
 #
  set  found 0
  for { set i 0} { $i < $mom_sim_zcs_junctions_count } {incr i}  {
   if { $mom_sim_zcs_junction_dest_comp($i) == $dest_cmp } {
       set idx  [ string first $zcs_name  $mom_sim_zcs_junction_names($i)]
       if { $idx != -1 } {
          # now compare transformation values 
          set same 1
          for {set j 0} { $j<9 } {incr j}  {
             set val [lindex $mom_sim_zcs_junction_mtx($i) $j] 
             
             set n [expr {$j+1}]
             set d [expr {$val - $mtxV($n)} ]

#MOM_SIM_DEBUG_MSG "MTX i=$i j=$j val=$val mtxV=$mtxV($n) d=$d"

             if {[expr {abs($d)}] > 0.000001 } {
                set same 0
                break
             }

             # compare origin
             if { $j < 3 } {
                set val [lindex $mom_sim_zcs_junction_origin($i) $j] 
             
                set d [expr {$val - $originV($n)} ]  

#MOM_SIM_DEBUG_MSG "ORG i=$i j=$j val=$val org=$originV($n) d=$d"


                if {[expr {abs($d)}] > 0.000001 } {
                   set same 0
                   break
                }
             }
          }

          if { $same == 1 } {
                set out_zcs_name $mom_sim_zcs_junction_names($i)
                set found 1
                break
          }
       }
   }
  }

#MOM_SIM_DEBUG_MSG "********* Did we find ZCS junction = $found"

 # if not found create new
 if { $found == 0 } {

    set out_zcs_name $zcs_name
    SIM_ask_is_junction_exist $out_zcs_name 
 
    # if already exists, append number
    set zcs_index $mom_sim_zcs_junctions_count
    while { $mom_sim_result == 1 } {
       set out_zcs_name "$zcs_name$zcs_index"
       SIM_ask_is_junction_exist $out_zcs_name 

       incr zcs_index
    }

    set i $mom_sim_zcs_junctions_count 
    set mom_sim_zcs_junction_names($i)     $out_zcs_name
    set mom_sim_zcs_junction_origin($i)    $origin
    set mom_sim_zcs_junction_mtx($i)       $mtx
    set mom_sim_zcs_junction_dest_comp($i) $dest_cmp

    incr mom_sim_zcs_junctions_count

    SIM_create_junction $out_zcs_name $dest_cmp $originV(1) $originV(2) $originV(3) $mtxV(1) $mtxV(2) $mtxV(3) $mtxV(4) $mtxV(5) $mtxV(6) $mtxV(7) $mtxV(8) $mtxV(9)
 }


 return $out_zcs_name
}

#=============================================================
proc SIM_map_logical_to_phisical_axis { logical_axis } {
#=============================================================

  global mom_sim_result 
  global mom_sim_linear_axes_map
  global mom_sim_rotary_axes_map


  if {[set i [lsearch -exact $mom_sim_linear_axes_map $logical_axis]]!=-1} {
      set phisical_axis [lindex $mom_sim_linear_axes_map [expr {$i+1}]]
  } elseif {[set i [lsearch -exact $mom_sim_rotary_axes_map $logical_axis]]!=-1} {
      set phisical_axis [lindex $mom_sim_rotary_axes_map [expr {$i+1}]]
  } else {
      MOM_SIM_ERROR_MSG "No phisical axis can be mapped to logical axis $logical_axis"
      set phisical_axis ""      
  }

  set mom_sim_result $phisical_axis

  return $mom_sim_result
}


#=============================================================
proc SIM_transform_vector { vector src_jct target_jct {src_state INITIAL} {target_state INITIAL} } {
#=============================================================

  global mom_sim_result 

  SIM_compute_transform $src_jct $target_jct $src_state $target_state

#  MOM_SIM_DEBUG_MSG "vector=$vector mom_sim_result=$mom_sim_result"

  set xfm_vector [ MOM_SIM_MatMultVectorL $mom_sim_result $vector]

  set mom_sim_result $xfm_vector

  return $mom_sim_result
}

#=============================================================
proc SIM_transform_point { point src_jct target_jct {src_state INITIAL} {target_state INITIAL} } {
#=============================================================

  global mom_sim_result mom_sim_result1

  SIM_compute_transform $src_jct $target_jct $src_state $target_state

  set xfm_point [ MOM_SIM_MatMultVectorL $mom_sim_result $point]

  set mom_sim_result [ MOM_SIM_VAddL $xfm_point $mom_sim_result1 ]

  return $mom_sim_result
}

#=============================================================
proc SIM_compute_transform { src_jct target_jct {src_state INITIAL} {target_state INITIAL} } {
#=============================================================

  global mom_sim_result mom_sim_result1

  if { $src_jct == $target_jct } {
   if { $src_state == $target_state } {
     set mom_sim_result  [list 1.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 1.0 ]
     set mom_sim_result1 [list 0.0 0.0 0.0 ]
     return
   }
  }

  #
  # we want to compute the transformation from src_jct to target_jct(M3).
  # M3 = M1 * M2
  # where M1 is the transformation from src_jct to acs 
  #       M2 is the transformation from acs to target_jct
  #

#MOM_SIM_DEBUG_MSG "src_jct=$src_jct target_jct=$target_jct"
#MOM_SIM_DEBUG_MSG "src_state=$src_state target_state=$target_state"

  #
  # compute M1 - from src coordinate system to acs coordinate system
  if { $src_state == "INITIAL" } {
     SIM_ask_init_junction_xform $src_jct 
  } else {
     SIM_ask_junction_xform $src_jct 
  }
 
  set M1_xfm     [MOM_SIM_MatInvertL $mom_sim_result] 
  set M1_offset  $mom_sim_result1

#MOM_SIM_DEBUG_MSG "M1_xfm=$M1_xfm"
#MOM_SIM_DEBUG_MSG "M1_offset=$M1_offset"

  #
  # compute M2 - from acs to target coordinate system
  if { $target_state == "INITIAL" } {
     SIM_ask_init_junction_xform $target_jct 
  } else {
     SIM_ask_junction_xform $target_jct 
  }
 
  set M2_xfm          $mom_sim_result
  set vec             [MOM_SIM_VDiffL [list 0.0 0.0 0.0]  $mom_sim_result1] 
  set M2_offset       [MOM_SIM_MatMultVectorL $M2_xfm $vec]
 
#MOM_SIM_DEBUG_MSG "M2_xfm=$M2_xfm"
#MOM_SIM_DEBUG_MSG "M2_offset=$M2_offset"

  #
  # compute M3- from src to target coordinate system

  #
  # M3_xfm = M2_xfm * M1_xfm
  set M3_xfm [ MOM_SIM_MatMultMatL $M2_xfm $M1_xfm ]

  #
  # M3_offset = M2_xfm*M1_offset + M2_offset 
  set vec        [MOM_SIM_MatMultVectorL $M2_xfm $M1_offset]
  set M3_offset  [MOM_SIM_VAddL $vec  $M2_offset] 

#MOM_SIM_DEBUG_MSG "M3_xfm=$M3_xfm"
#MOM_SIM_DEBUG_MSG "M3_offset=$M3_offset"

  set mom_sim_result  $M3_xfm
  set mom_sim_result1 $M3_offset
}

#=============================================================
proc MOM_SIM_ask_axis_zero_offset { axis } {
#=============================================================
  global mom_sim_x_offset mom_sim_y_offset mom_sim_z_offset          
          
  if {$axis == "X"} {
     set offset $mom_sim_x_offset
  } elseif {$axis == "Y"}  {
   set offset $mom_sim_y_offset
  }  elseif {$axis == "Z"}  {
   set offset $mom_sim_z_offset
  } else {
    MOM_SIM_ERROR_MSG "No zero offset found for axis $axis"
    set offset 0.0
  }

  return $offset
}

#
# Return current tool tip position and tool axis i.r.t ZCS.
# it is assumed that the Z axis is defined along the X axis of 
# the tool tip junction.
#=============================================================
proc MOM_SIM_ask_tool_tip_position  { tip_jct target_jct } {
#=============================================================

  global mom_sim_result mom_sim_result1

  #
  # get target transformation
  if { $target_jct == "ZCS" } {
      set target_jct [SIM_ask_current_zcs_junction]
  } else {
    SIM_ask_mtcs_junction
    set target_jct $mom_sim_result
  }

  SIM_compute_transform $tip_jct $target_jct CURRENT CURRENT

  set tool_tip  $mom_sim_result1 

  # tool axis is defined along the X axis of tip junction
  set tool_axis [ MOM_SIM_MatMultVectorL $mom_sim_result [list 1.0 0.0 0.0 ]]

  set tip_axis "$tool_tip $tool_axis"
  return $tip_axis 
}

# return tool position and orientation i.r.t current ZCS
#=============================================================
proc SIM_ask_tool_position_zcs  { tip_jct } {
#=============================================================

  return [MOM_SIM_ask_tool_tip_position $tip_jct ZCS]
}

# return tool position and orientation i.r.t MTCS
#=============================================================
proc SIM_ask_tool_position_mtcs  { tip_jct } {
#=============================================================

  return [MOM_SIM_ask_tool_tip_position $tip_jct MTCS]
}


#-------------------------------------------------------------------------------
#SIM_move_nurbs_zcs
#
#	Modul: 					IS&V
#
#	Task:						high level function for NURBS motion related to the ZCS.
#
#	Arguments:				p_count:	number of points of nurbs
#								order:	order of the nurbs
#								k_count:	number of the knots
#								knots:	TCL list of knots
#								points:	TCL list of points
#
#	Results:					depends on exception handling code
#
# 	Last modification:	27 Nov 2002
#	
# 	Owner:					Thomas Schulz
#-------------------------------------------------------------------------------
proc SIM_move_nurbs_zcs { p_count order k_count knots points } \
{
	return [ MOM_SIM_move_nurbs $p_count $order $k_count $knots $points \
                 [SIM_ask_current_zcs_junction] ABSOLUTE ]
}


#-------------------------------------------------------------------------------
#SIM_move_nurbs_mtcs
#
#	Modul: 					IS&V
#
#	Task:						high level function for NURBS motion related to the MTCS
#
#	Arguments:				p_count:	number of points of nurbs
#								order:	order of the nurbs
#								k_count:	number of the knots
#								knots:	TCL list of knots
#								points:	TCL list of points
#
#	Results:					depends on exception handling code
#
# 	Last modification:	27 Nov 2002
#	
# 	Owner:					Thomas Schulz
#-------------------------------------------------------------------------------
proc SIM_move_nurbs_mtcs { p_count order k_count knots points } \
{
  global mom_sim_result
  SIM_ask_mtcs_junction
  return [ MOM_SIM_move_nurbs $p_count $order $k_count $knots $points \
           $mom_sim_result ABSOLUTE ]
}


#-------------------------------------------------------------------------------
#SIM_move_inc_nurbs_zcs
#
#	Modul: 					IS&V
#
#	Task:						high level function for incremental NURBS motion
#								related to the ZCS.
#
#	Arguments:				p_count:	number of points of nurbs
#								order:	order of the nurbs
#								k_count:	number of the knots
#								knots:	TCL list of knots
#								points:	TCL list of points
#
#	Results:					depends on exception handling code
#
# 	Last modification:	27 Nov 2002
#	
# 	Owner:					Thomas Schulz
#-------------------------------------------------------------------------------
proc SIM_move_inc_nurbs_zcs { p_count order k_count knots points } \
{
  return [ MOM_SIM_move_nurbs $p_count $order $k_count $knots $points \
           [SIM_ask_current_zcs_junction] INCREMENTAL ]
}


#-------------------------------------------------------------------------------
#SIM_move_inc_nurbs_mtcs
#
#	Modul: 					IS&V
#
#	Task:						high level function for incremental NURBS motion
#								related to the MTCS.
#
#	Arguments:				p_count:	number of points of nurbs
#								order:	order of the nurbs
#								k_count:	number of the knots
#								knots:	TCL list of knots
#								points:	TCL list of points
#
#	Results:					depends on exception handling code
#
# 	Last modification:	27 Nov 2002
#	
# 	Owner:					Thomas Schulz
#-------------------------------------------------------------------------------
proc SIM_move_inc_nurbs_mtcs { p_count order k_count knots points } \
{
  global mom_sim_result
  SIM_ask_mtcs_junction
  return [ MOM_SIM_move_nurbs $p_count $order $k_count $knots $points \
           $mom_sim_result INCREMENTAL ]
}


#-------------------------------------------------------------------------------
#MOM_SIM_move_nurbs
#
#	Modul: 					IS&V
#
#	Task:						high level function for NURBS motion
#
#	Arguments:				p_count:	number of points of nurbs
#								order:	order of the nurbs
#								k_count:	number of the knots
#								knots:	TCL list of knots
#								points:	TCL list of points
#
#	Results:					depends on exception handling code
#
# 	Last modification:	27 Nov 2002
#	
# 	Owner:					Thomas Schulz
#-------------------------------------------------------------------------------
proc MOM_SIM_move_nurbs { p_count order k_count knots points wrk_jct motion_mode} \
{
	global mom_sim_result
	global mom_sim_result_array

	# MOM_output_to_listing_device "Convert Nurbs with order $order --- data is:"
	# MOM_output_to_listing_device "$p_count Points $k_count knots"
	# MOM_output_to_listing_device "Knots are: $knots"
	# MOM_output_to_listing_device "Points are: $points"

	SIM_convert_nurbs_to_position_data	$p_count $order $k_count $knots $points

	set nurbs_pos_count $mom_sim_result

	# MOM_output_to_listing_device "Raus kommen $nurbs_pos_count Punkte:"
	# for {set i 0} {$i < $nurbs_pos_count} {incr i} \
	# {
	# MOM_output_to_listing_device "Position $i: $mom_sim_result_array($i,0), $mom_sim_result_array($i,1), $mom_sim_result_array($i,2)"
	# if {$i > 10} {break}
	# }

	if {$nurbs_pos_count < 1 } \
	{
		MOM_SIM_WARNING_MSG "No positions based on given Nurbs are calcutation"
		return TCL_ERROR
	}

	# Based on the extracted position data call the responsible motion commands

	for {set i 0} {$i < $nurbs_pos_count} {incr i} \
	{
	   MOM_SIM_move_linear_zcs_or_mtcs "X $mom_sim_result_array($i,0) Y $mom_sim_result_array($i,1) Z $mom_sim_result_array($i,2)" $wrk_jct $motion_mode
	}
}
