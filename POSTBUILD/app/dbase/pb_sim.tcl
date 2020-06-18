##############################################################################
#                       P B _ S I M . T C L
##############################################################################
# Description
#     This file contains dummy SIM & VNC commands for sourcing VNC file.
#
##############################################################################


if { [info exists gPB(sim_high_level_cmds_sourced)]  &&  $gPB(sim_high_level_cmds_sourced) } {
return
}

set gPB(sim_high_level_cmds_sourced) 1


proc SIM_mount_kim_comp                       { args } { }
proc SIM_unmount_kim_comp                     { args } { }
proc SIM_mount_tool                           { args } { }
proc SIM_unmount_tool                         { args } { }
proc SIM_load_workpiece                       { args } { }
proc SIM_unload_workpiece                     { args } { }
proc SIM_move_linear_axis                     { args } { }
proc SIM_move_rotary_axis                     { args } { }
proc SIM_set_parameter                        { args } { }
proc SIM_play_sound                           { args } { }
proc SIM_step                                 { args } { }
proc SIM_set_channel                          { args } { }
proc SIM_reset_buffer                         { args } { }
proc SIM_start_of_simulation                  { args } { }
proc SIM_end_of_simulation                    { args } { }
proc SIM_mtd_init                             { args } { }
proc SIM_ask_cording_tol                      { args } { }
proc SIM_transform_offset_acs_to_mtcs         { args } { }
proc SIM_transform_matrix_acs_to_mtcs         { args } { }
proc SIM_msg_user_feedback                    { args } { }
proc SIM_activate_tool                        { args } { }
proc SIM_ask_kim_comp_name_by_id              { args } { }
proc SIM_ask_tool_offsets                     { args } { }
proc SIM_ask_junction_xform                   { args } { }
proc SIM_create_junction                      { args } { }
proc SIM_delete_junction                      { args } { }
proc SIM_ask_mtd_units                        { args } { }
proc SIM_ask_axis_position                    { args } { }
proc SIM_dialog_set_item                      { args } { }
proc SIM_ask_mtcs_junction                    { args } { }
proc SIM_ask_axis_dof_junction                { args } { }
proc SIM_ask_axis_limits                      { args } { }
proc SIM_delay                                { args } { }
proc SIM_ask_is_junction_dependent            { args } { }
proc SIM_dbg_start                            { args } { }
proc SIM_dbg_end                              { args } { }
proc SIM_dbg_write_message                    { args } { }
proc SIM_dbg_set_output                       { args } { }
proc SIM_msg_nc_command                       { args } { }
proc SIM_ask_status_send_nc_command_msg       { args } { }
proc SIM_set_status_send_nc_command_msg       { args } { }
proc SIM_set_axis_rotary_dir_mode             { args } { }
proc SIM_ask_axis_rotary_dir_mode             { args } { }
proc SIM_set_axis_allow_reversal              { args } { }
proc SIM_ask_axis_is_reversal_allowed         { args } { }
proc SIM_ask_comp_from_dof                    { args } { }
proc SIM_msg_program_mark                     { args } { }
proc SIM_set_immediate_update                 { args } { }
proc SIM_ask_immediate_update                 { args } { }
proc SIM_convert_nurbs_to_position_data       { args } { }
proc SIM_set_coolant_any                      { args } { }
proc SIM_set_rotary_axes_config               { args } { }
proc SIM_ask_linear_axes_config               { args } { }
proc SIM_ask_rotary_axes_config               { args } { }
proc SIM_ask_current_zcs_junction             { args } { }
proc SIM_set_current_zcs_junction             { args } { }
proc MOM_SIM_ask_last_position                { args } { }
proc MOM_SIM_move_linear_zcs_or_mtcs          { args } { }
proc MOM_SIM_move_circular_zcs_or_mtcs        { args } { }
proc SIM_mach_max_axis_rapid_velocity         { args } { }
proc SIM_assign_channel_to_spindle            { args } { }
proc SIM_mach_assign_channel_to_spindle       { args } { }
proc SIM_mach_assign_axis_to_channel          { args } { }
proc SIM_mach_default_primary_channel         { args } { }
proc SIM_set_spindle_speed                    { args } { }
proc SIM_set_max_spindle_speed                { args } { }
proc SIM_mach_max_spindle_speed               { args } { }
proc SIM_mach_default_spindle_speed           { args } { }
proc SIM_synchronize                          { args } { }
proc SIM_primary_channel                      { args } { }
proc SIM_set_xtp_event                        { args } { }
proc SIM_ask_xtp_duration                     { args } { }
proc SIM_set_linearization                    { args } { }
proc SIM_set_interpolation                    { args } { }
proc SIM_ask_zcs_comp_name                    { args } { }
proc SIM_ask_nc_axis_name                     { args } { }
proc SIM_ask_tool_mount_jct_name              { args } { }
proc SIM_ask_tool_mount_comp_name             { args } { }
proc SIM_ask_head_pivot_jct_full_name         { args } { }
proc SIM_ask_machine_base_component           { args } { }
proc SIM_ask_number_of_child_components       { args } { }
proc SIM_ask_nth_child_component              { args } { }
proc SIM_ask_axis_of_component                { args } { }
proc SIM_ask_id_of_component                  { args } { }
proc SIM_ask_holding_systems_of_pocket        { args } { }
proc SIM_is_component_of_system_class         { args } { }
proc SIM_is_component_of_user_class           { args } { }
proc SIM_ask_number_of_junctions              { args } { }
proc SIM_ask_nth_junction                     { args } { }
proc SIM_is_junction_of_system_class          { args } { }
proc SIM_ask_number_of_channels               { args } { }
proc SIM_ask_nth_channel                      { args } { }
proc SIM_ask_number_of_channels_at_component  { args } { }
proc SIM_ask_nth_channel_at_component         { args } { }
proc SIM_ask_base_device_holder_of_comp       { args } { }
proc SIM_ask_base_device_of_comp              { args } { }
proc SIM_ask_axis_initial_value               { args } { }
proc SIM_set_implicit_update                  { args } { }
proc SIM_set_axis_rapid_velocity              { args } { }
proc SIM_normalize_rotary_axis                { args } { }


proc PB_SIM_call  { command args } { return 1 }

proc SIM_ask_init_junction_xform      { args } { }
proc SIM_ask_is_junction_exist        { args } { return 1 }
proc SIM_ask_junction_origin_mtcs     { JNC_name state } { return 1 }
proc SIM_ask_last_position_mtcs       { } { return 1 }
proc SIM_ask_last_position_zcs        { } { }
proc SIM_ask_linear_axes_map          { } { }
proc SIM_ask_nc_axes_of_mtool         { args } { }
proc SIM_ask_offsets_mtcs             { from_jct to_jct state } { return 1 }
proc SIM_ask_rotary_axes_map          { } { }
proc SIM_ask_tool_position_mtcs       { tip_jct } { return 1 }
proc SIM_ask_tool_position_zcs        { tip_jct } { return 1 }

proc SIM_compute_transform            { src_jct target_jct {src_state INITIAL} {target_state INITIAL} } { } 
proc SIM_convert_mtd_to_sim_units     { value } { return 1 }
proc SIM_convert_sim_to_mtd_units     { value } { return 1 }
proc SIM_create_zcs_junction          { zcs_name dest_cmp origin  mtx } { return 1 }

proc SIM_dialog_add_item              { entry } { }
proc SIM_dialog_ask_user_item_value   { item_id } { }
proc SIM_dialog_end                   { } { }
proc SIM_dialog_start                 { att } { } 

proc SIM_feedback_message             { args } { }
proc SIM_find_comp_by_name            { args } { }

proc SIM_invoke                       { sv_command args } { } 

proc SIM_macro_append_sv_cmd          { sv_cmd } { }
proc SIM_macro_call                   { macro_name } { }
proc SIM_macro_def                    { macro_name } { }
proc SIM_macro_delete                 { macro_name } { }
proc SIM_macro_delete_all             { } { }
proc SIM_macro_end                    { macro_name } { }
proc SIM_map_logical_to_phisical_axis { logical_axis } { return 1 }
proc SIM_move_circular_mtcs           { Ux Uy Uz args } { return 1 }
proc SIM_move_circular_zcs            { Ux Uy Uz args } { return 1 }
proc SIM_move_helical_mtcs            { Ux Uy Uz args } { return 1 }
proc SIM_move_helical_zcs             { Ux Uy Uz args } { return 1 }
proc SIM_move_inc_circular_mtcs       { Ux Uy Uz args } { return 1 }
proc SIM_move_inc_circular_zcs        { Ux Uy Uz args } { return 1 }
proc SIM_move_inc_helical_mtcs        { Ux Uy Uz args } { return 1 }
proc SIM_move_inc_helical_zcs         { Ux Uy Uz args } { return 1 }
proc SIM_move_inc_linear_mtcs         { args } { return 1 }
proc SIM_move_inc_linear_zcs          { args } { return 1 }
proc SIM_move_inc_nurbs_mtcs          { p_count order k_count knots points } { return 1 }
proc SIM_move_inc_nurbs_zcs           { p_count order k_count knots points } { return 1 }
proc SIM_move_linear_mtcs             { args } { return 1 }
proc SIM_move_linear_zcs              { args } { return 1 }
proc SIM_move_nurbs_mtcs              { p_count order k_count knots points } { return 1 }
proc SIM_move_nurbs_zcs               { p_count order k_count knots points } { return 1 }
proc SIM_mtd_reset                    { args } { }

proc SIM_set_coolant                  { args } { }
proc SIM_set_current_ref_junction     { args } { }
proc SIM_ask_current_ref_junction     { args } { }
proc SIM_set_cutting_mode             { args } { }
proc SIM_set_duration_callback_fct    { cb } { }
proc SIM_set_feed                     { args } { }
proc SIM_set_linear_axes_config       { axes } { }
proc SIM_set_linear_axes_map          { axes } { }
proc SIM_set_machining_mode           { args } { }
proc SIM_set_mtd_units                { args } { }
proc SIM_set_rotary_axes_map          { axes } { }
proc SIM_set_speed                    { args } { }
proc SIM_set_surface_speed            { args } { }

proc SIM_transform_mtcs_to_zcs        { X Y Z } { return 1 }
proc SIM_transform_point              { point src_jct target_jct {src_state INITIAL} {target_state INITIAL} } { return 1 }
proc SIM_transform_vector             { vector src_jct target_jct {src_state INITIAL} {target_state INITIAL} } { return 1 }
proc SIM_transform_zcs_to_mtcs        { X Y Z } { return 1 }

proc SIM_update                       { args } { }
proc SIM_update_current_zcs           { zcs_jct } { }

proc PB_VNC_sync                      { } { }
proc PB_VNC_output_debug_msg          { args } { }
proc PB_VNC_init_sim_vars             { } { }
proc PB_VNC_pass_csys_data            { } { }
proc PB_VNC_pass_head_data            { } { }
proc PB_VNC_pass_msys_data            { } { }
proc PB_VNC_pass_tool_data            { } { }
proc PB_VNC_pass_spindle_data         { } { }
proc PB_VNC_start_of_program          { } { }
proc PB_VNC_start_of_path             { } { }
proc PB_VNC_end_of_path               { } { }
proc PB_VNC_end_of_program            { } { }
proc PB_VNC_set_kinematics            { } { }
proc PB_VNC_send_message              { message } { }
proc VNC_output_debug_msg             { args } { }
proc VNC_reset_controller             { } { }
proc VNC_set_param_per_msg            { key word } { }
proc VNC_create_tmp_jct               { } { }
proc VNC_parse_motion_word            { o_buff } { return 0 }
proc VNC_parse_nc_code                { o_buff addr_leader args } { return 0 }
proc VNC_parse_nc_block               { O_BUFF word args } { return 0 }
proc VNC_set_kinematics               { } { }
proc VNC_restore_pos_no_sim           { } { }
proc VNC_send_message                 { message } { }
proc VNC_CalculateDurationTime        { linear_or_angular delta } { return 1 }
proc VNC_ask_feedrate_mode            { } { return INCH_PER_MIN }
proc VNC_ask_speed_mode               { } { return REV_PER_MIN }
proc VNC_set_feedrate_mode            { cutting_mode } { }
proc VNC_unmount_tool                 { tool_ug_name } { }
proc VNC_tool_change                  { } { }
proc VNC_rewind_stop_program          { } { }
proc VNC_rapid_move                   { } { }
proc VNC_linear_move                  { } { }
proc VNC_nurbs_move                   { } { }
proc VNC_circular_move                { direction args } { }
proc VNC_cycle_move                   { } { }
proc VNC_set_ref_jct                  { sim_tool_name } { }
proc VNC_coolant_on                   { } { }
proc VNC_coolant_off                  { } { }
proc VNC_concat_coord_list            { args } { return "" }
proc VNC_move_linear_zcs              { mode args } { }
proc VNC_set_post_kinematics          { zcs_jct X_axis Y_axis Z_axis \
                                        {4th_axis ""} {5th_axis ""} \
                                        {pivot_jct ""} {gauge_jct ""} } { }
proc VNC_machine_tool_model_exists    { } { return 1 }
proc VNC_pause                        { args } { }
proc VNC_trace                        { args } { return "" }
proc VNC_reload_kinematics            { } { }
proc VNC_sim_nc_block                 { args } {}   

proc VNC_sort_array_vals { ARR }     { return {} }
proc EQ_is_equal         { s t }     { return 0 }
proc EQ_is_ge            { s t }     { return 0 }
proc EQ_is_gt            { s t }     { return 0 }
proc EQ_is_le            { s t }     { return 0 }
proc EQ_is_lt            { s t }     { return 0 }
proc EQ_is_zero          { s }       { return 0 }
proc VEC3_add            { u v w }   { }
proc VEC3_cross          { u v w }   { }
proc VEC3_dot            { u v }     { return 0.0 }
proc VEC3_init           { x y z w } { }
proc VEC3_is_equal       { u v }     { return 0 }
proc VEC3_is_zero        { u }       { return 0 }
proc VEC3_mag            { u }       { return 1.0 }
proc VEC3_negate         { u w }     { }
proc VEC3_scale          { s u w }   { }
proc VEC3_sub            { u v w }   { }
proc VEC3_unitize        { u w }     { return 1.0 }
proc MTX3_init_x_y_z     { u v w r } { return 1 }
proc MTX3_is_equal       { m n }     { return 1 }
proc MTX3_multiply       { m n r }   { }
proc MTX3_transpose      { m r }     { }
proc MTX3_scale          { s r }     { }
proc MTX3_sub            { m n r }   { }
proc MTX3_add            { m n r }   { }
proc MTX3_vec_multiply   { u m w }   { }
proc MTX3_x              { m w }     { }
proc MTX3_y              { m w }     { }
proc MTX3_z              { m w }     { }
proc MTX3_xform_csys     { a b c x y z CSYS } { }


