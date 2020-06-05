## HEADER BLOCK START ##
##############################################################################
#                                                                            #
# Copyright (c) 1999/2000,                        Unigraphics Solutions Inc. #
# Copyright (c) 2001/2002/2003/2004/2005/2006,    UGS/PLM Solutions.         #
# Copyright (c) 2007 ~ 2017,                      SIEMENS/PLM Software       #
#                                                                            #
##############################################################################
#         P B _ C M D _ A C T I V A T E _ T U R B O _ M O D E . T C L
##############################################################################
#
# Custom commands in this file can be used to activate turbo mode for a post.
#
#=============================================================================
#
# Custom commands in this file allow you to activate turbo mode to the posts of
# following controllers:
#
#  1. Fanuc style controllers
#  2. iTNC (Heidenhain Conversational) controllers
#  3. Sinumerik (840D) controllers
#
# You will import "PB_CMD__validate_turbo_mode" command and one of the 3 activation
# commands in this package to your post; and, when necessary, edit the definitions
# to fit the output requirements of your controller.
#
# => The turbo activation command should be attached to the Start-of-Program event.
#
#=============================================================================
## HEADER BLOCK END ##




#=============================================================
proc PB_CMD__validate_turbo_mode { } {
#=============================================================
# This command is called automatically by the activation of
# legacy turbo posts to verify if turbo mode can be performed.
#
# => Do not call this command in any event!
#
#
# Revisions:
# Jan-19-2017 gsl - (pb11.02) Added to accommodate advanced turbo mode
#

  # Define command below to run turbo mode in earlier versions of NX/Post.
  #
   if { ![CMD_EXIST MOM_set_turbo_mode] } {
      #---------------------------------------------
      proc MOM_set_turbo_mode { turbo_mode args } {
      #---------------------------------------------
         set ::mom_kin_is_turbo_output $turbo_mode
         MOM_reload_kinematics
      }
   }


  # Allow legacy turbo mode to override Advanced Turbo mode -
  #
   if { [info exists ::mom_kin_is_turbo_output] } {

      if { [info exists ::mom_sys_advanced_turbo_output] &&\
                       $::mom_sys_advanced_turbo_output } {

         INFO "Disable Advanced Turbo mode"
         set ::mom_sys_advanced_turbo_output 0
      }

      if { [string match "TRUE" $::mom_kin_is_turbo_output] } {

         MOM_set_turbo_mode TRUE

      } else {

         INFO "Disable any turbo mode"
         MOM_set_turbo_mode FALSE
return 0
      }
   }


  # When Advanced Turbo mode is active, skip configuration for legacy turbo post.
  #
   if { [info exists ::mom_sys_advanced_turbo_output] &&\
                    $::mom_sys_advanced_turbo_output } {

      INFO "Skip legacy turbo mode configuration within an Advanced Turbo post."
      MOM_set_turbo_mode FALSE
return 0
   }


  # Disable turbo mode for non-milling posts
  #
   if { [string match "*wedm*"      $::mom_kin_machine_type] ||\
        [string match "*lathe*"     $::mom_kin_machine_type] ||\
        [string match "*mill_turn*" $::mom_kin_machine_type] } {

      set msg "Turbo mode can only be activated for 3, 4 & 5-axis mill posts!"

      INFO $msg
      CATCH_WARNING $msg

      MOM_set_turbo_mode FALSE
return 0
   }


  # Skip multi-axis turbo mode for pre-NX7
  #
   set ugii_version [string trimleft [MOM_ask_env_var UGII_VERSION] v]

   if { ![string match "3_axis_mill" $::mom_kin_machine_type] } {
      if { $ugii_version < 7 } {

         set msg "Multi-axis turbo mode is not available prior to NX7."

         INFO $msg
         CATCH_WARNING $msg

         MOM_set_turbo_mode FALSE
return 0
      }
   }


  # Open scratch file for turbo blocks definition
  #
   set ugii_tmp_dir [MOM_ask_env_var UGII_TMP_DIR]
   set ::mom_user_turbo_def_file_name  [file join $ugii_tmp_dir __${::mom_logname}_turbo_blocks_[clock clicks].def]

   if { [catch { set ::mom_user_turbo_def_fid [open "$::mom_user_turbo_def_file_name" w] } res] } {

      if { ![info exists res] } {
         set res "$::mom_user_turbo_def_file_name\nFile open error!"
      }

      INFO $res
      CATCH_WARNING $res

      MOM_set_turbo_mode FALSE
return 0
   }

return 1
}


#=============================================================
proc PB_CMD__activate_Fanuc_turbo_mode { } {
#=============================================================
#  This custom command will activate the turbo process mode for
#  the posts of FANUC style controllers.  The execution time
#  will be 15 to 20 % of that required in the standard mode.
#
#  This command may only be used with Post Builder 3.2.1 or later
#  and NX2 or newer.
#
#  => Place this command with the "Start of Program" event marker.
#
#  The following turbo blocks are defined in this command:
#
#     linear_move_turbo
#     circular_move_turbo
#     rapid_move_turbo
#     sequence_number_turbo
#
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Definitions file of the post involved MUST have generic turbo blocks defined first.
#  This command will only modify & enhance the construct of the turbo blocks.
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#  => You may re-arrange the words sequence within each block template.
#     However, you MUST NOT edit the expressions within the words,
#     remove or add any other words into these turbo blocks.
#
#  In Post Builder, you may modify the parameters of the Words used
#  with the turbo blocks on the N/C Data Defitions dialogs. You may also
#  modify the parameters of Formats involved for the turbo output.
#
#  Custom commands used in the linear move, circular move & rapid move
#  event handlers will be ignored. MOM_before_motion handler will not be executed.
#
#  By default, rapid motions are also processed in turbo mode where
#  each motion is output in a single block.
#  => "MOM_set_turbo_rapid FALSE" (see below) can be issued in order to process
#     the rapid motions in standard mode instead, of which the customization
#     done for the rapid motions including MOM_before_motion will be executed.
#     This would greatly enhance the customizability of a turbo post.
#
#
# Revisions:
# Jan-19-2017 gsl - (pb11.02) Revised to accommodate advanced turbo mode
#


##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
UNSET_VARS ::mom_kin_is_turbo_output
##
## Uncomment a line below to disable Advanced Turbo mode.
## => Without setting this variable, Advanced Turbo mode will continue.
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# set ::mom_kin_is_turbo_output TRUE   ;# To post in legacy turbo mode
# set ::mom_kin_is_turbo_output FALSE  ;# To post in standard mode


 if { ![info exists ::mom_kin_is_turbo_output] } {
return
 }



##++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Process RAPID motions in standard mode, when desired.
## => This option can also be configured per operations.
##++++++++++++++++++++++++++++++++++++++++++++++++++++++
 if [CMD_EXIST MOM_set_turbo_rapid] {
   # MOM_set_turbo_rapid "FALSE"
 }


##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Set variable below to "1" to output arc radius for circular moves.
## => This option is not available in turbo mode prior to NX10.0.3.
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 set use_arc_radius_output 0



  #------------------------------------------
  # Verify if legacy turbo mode can proceed -
   if { ![PB_CMD__validate_turbo_mode] } {
return
   }


   set tmp_file $::mom_user_turbo_def_fid
   fconfigure $tmp_file -translation lf

   set ugii_version [string trimleft [MOM_ask_env_var UGII_VERSION] v]
   regexp {[0-9]} $::mom_kin_machine_type machine_axis


  #+++++++++++++++++++++
  # Define turbo blocks
  #+++++++++++++++++++++
   puts $tmp_file { MACHINE mill }
   puts $tmp_file { FORMATTING }
   puts $tmp_file " {"
   puts $tmp_file {   BLOCK_TEMPLATE circular_move_turbo }
   puts $tmp_file "   {"

   if { [EQ_is_ge $ugii_version 12] } {
      puts $tmp_file {    G_plane[^sys_cutcom_plane_code(ARC_PLANE)]\opt }
   }
   puts $tmp_file {       G_feed[^sys_feed_rate_mode_code(FEED_MODE)]\opt }
   puts $tmp_file {       G_motion[^sys_circle_code(ARC_DIRECTION)]\opt }
   puts $tmp_file {       G_mode[^sys_output_code(OUTPUT_MODE)] }
   puts $tmp_file {       X[^POSX] }
   puts $tmp_file {       Y[^POSY] }
   puts $tmp_file {       Z[^POSZ] }

   if { $use_arc_radius_output } {

      puts $tmp_file {    ARC_RADIUS[^arc_radius] }

   } else {

      puts $tmp_file {    I[^CENTERX] }
      puts $tmp_file {    J[^CENTERY] }
      puts $tmp_file {    K[^CENTERZ] }
   }

   puts $tmp_file {       F[^FEED] }
   puts $tmp_file {       S[^SPINDLE_SPEED] }
   puts $tmp_file {       M_spindle[^sys_spindle_direction_code(SPINDLE_DIRECTION)]\opt }
   puts $tmp_file "   }"

   puts $tmp_file {   BLOCK_TEMPLATE linear_move_turbo }
   puts $tmp_file "   {"
   puts $tmp_file {       G_cutcom[^sys_cutcom_code(CUTCOM_STATUS)]\opt }
   puts $tmp_file {       G_plane[^sys_cutcom_plane_code(CUTCOM_PLANE)]\opt }
   puts $tmp_file {       G_feed[^sys_feed_rate_mode_code(FEED_MODE)]\opt }
   puts $tmp_file {       G_motion[^sys_linear_code] }
   puts $tmp_file {       G_mode[^sys_output_code(OUTPUT_MODE)] }
   puts $tmp_file {       X[^POSX] }
   puts $tmp_file {       Y[^POSY] }
   puts $tmp_file {       Z[^POSZ] }

   if { $machine_axis > 3 } {

      puts $tmp_file {    fourth_axis[^POS4] }

      if { $machine_axis > 4 } {
         puts $tmp_file { fifth_axis[^POS5] }
      }

      puts $tmp_file {    tool_axis_I[^tool_axis0] }
      puts $tmp_file {    tool_axis_J[^tool_axis1] }
      puts $tmp_file {    tool_axis_K[^tool_axis2] }
   }

   puts $tmp_file {       F[^FEED] }
   puts $tmp_file {       D[^cutcom_adjust_register]\opt }
   puts $tmp_file {       S[^SPINDLE_SPEED] }
   puts $tmp_file {       M_spindle[^sys_spindle_direction_code(SPINDLE_DIRECTION)]\opt }
   puts $tmp_file {       M_coolant[^sys_coolant_code(COOLNT_STATUS)]\opt }
   puts $tmp_file "   }"

   puts $tmp_file {   BLOCK_TEMPLATE rapid_move_turbo }
   puts $tmp_file "   {"
   puts $tmp_file {       G_adjust[^sys_adjust_code] }
   puts $tmp_file {       G_motion[^sys_rapid_code] }
   puts $tmp_file {       G_mode[^sys_output_code(OUTPUT_MODE)] }
   puts $tmp_file {       X[^POSX] }
   puts $tmp_file {       Y[^POSY] }
   puts $tmp_file {       Z[^POSZ] }

   if { $machine_axis > 3 } {

      puts $tmp_file {    fourth_axis[^POS4] }

      if { $machine_axis > 4 } {
         puts $tmp_file { fifth_axis[^POS5] }
      }

      puts $tmp_file {    tool_axis_I[^tool_axis0] }
      puts $tmp_file {    tool_axis_J[^tool_axis1] }
      puts $tmp_file {    tool_axis_K[^tool_axis2] }
   }

   puts $tmp_file {       H[^tool_adjust_register]\opt }
   puts $tmp_file {       S[^SPINDLE_SPEED] }
   puts $tmp_file {       M_spindle[^sys_spindle_direction_code(SPINDLE_DIRECTION)]\opt }
   puts $tmp_file "   }"

   puts $tmp_file {   BLOCK_TEMPLATE sequence_number_turbo }
   puts $tmp_file "   {"
   puts $tmp_file {       N[^SEQNUM] }
   puts $tmp_file "   }"
   puts $tmp_file "}"

   close $tmp_file


  # Load turbo blocks
  #
   global tcl_platform
   if { [string match "*windows*" $tcl_platform(platform)] } {
      regsub -all {/} $::mom_user_turbo_def_file_name {\\} ::mom_user_turbo_def_file_name
   }

   if { [catch { MOM_load_definition_file  "$::mom_user_turbo_def_file_name" } res] } {

     # If some addresses are not defined, display message when post processing failed.
      set msg "Failed to load turbo blocks definition. Check if addresses and turbo symbols are correct.\n$res"

      INFO $msg
      CATCH_WARNING $msg

     # Disable turbo mode, if loading failed
      MOM_set_turbo_mode FALSE
   }

   MOM_remove_file  $::mom_user_turbo_def_file_name


  # Bail out, when turbo mode cannot be activated after all.
   if { ![string match "TRUE" $::mom_kin_is_turbo_output] } {
return
   }


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # When needed, define a custom command to reset turbo settings
  # @ Initial Move & First Move events.
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # return

  uplevel #0 {

   #=============================================================
   proc CONFIG_TURBO_OUTPUT { } {
   #=============================================================
   # This command is used during turbo posting mode to configure settings
   # that would affect the NC output. It will be executed automatically
   # by the Initial Move and First Move events.
   #
   # ==> Do not rename or attach it to any event.
   #

     # Bail out when not in turbo mode or multi-axis post
      if { ![info exists ::mom_kin_is_turbo_output] ||\
           ![string match "TRUE" $::mom_kin_is_turbo_output] ||\
            [string match "3_axis_mill" $::mom_kin_machine_type] } {

         return
      }


     # dpp_ge(sys_tcp_tool_axis_output_mode)
     # "AXIS"    output the rotation angle of axis (G43.4)
     # "VECTOR"  output tool axis vector(G43.5)
      if { ![info exists ::dpp_ge(sys_tcp_tool_axis_output_mode)] } {
         set ::dpp_ge(sys_tcp_tool_axis_output_mode) "AXIS"
      }

     # dpp_ge(sys_output_coord_mode)
     # "TCP_FIX_TABLE"    use a coordinate system fixed on the table as the programming coordinate system
     # "TCP_FIX_MACHINE"  use workpiece coordinate system fixed on machine as the programming coordinate system
      if { ![info exists ::dpp_ge(sys_output_coord_mode)] } {
         set ::dpp_ge(sys_output_coord_mode) "TCP_FIX_MACHINE"
      }

      if { ![info exists ::dpp_ge(tool_axis_num)] } {
         set ::dpp_ge(tool_axis_num) "3"
      }


      if { $::dpp_ge(sys_tcp_tool_axis_output_mode) == "VECTOR" } {

        # Output tool axis vectors
         MOM_disable_address fourth_axis

         if { [string match "5_*" $::mom_kin_machine_type] } {
            MOM_disable_address fifth_axis
         }

         MOM_enable_address tool_axis_I tool_axis_J tool_axis_K

      } else {

        # Output rotary angles
         MOM_enable_address fourth_axis

         if { [string match "5_*" $::mom_kin_machine_type] } {
            MOM_enable_address fifth_axis
         }

         MOM_disable_address tool_axis_I tool_axis_J tool_axis_K
      }

      if { $::dpp_ge(sys_output_coord_mode) == "TCP_FIX_TABLE" && $::dpp_ge(tool_axis_num) == "5" } {
         MOM_set_turbo_pos_output "MOM_MCS_GOTO"
      } else {
         MOM_set_turbo_pos_output "MOM_POS"
      }
   }

  } ;# uplevel
}


#=============================================================
proc PB_CMD__activate_iTNC_turbo_mode { } {
#=============================================================
#  This custom command will activate the turbo process mode for
#  the posts of iTNC family of controllers. The execution time
#  will be 15 to 20 % of that required in the standard mode.
#
#  This command may only be used with Post Builder 3.2.1 or later
#  and NX2 or newer.
#
#  => Place this command with the "Start of Program" event marker.
#
#  The following turbo blocks are defined in this command:
#
#     linear_move_turbo
#     circular_move_turbo
#     rapid_move_turbo
#     sequence_number_turbo
#
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Definitions file of the post involved MUST have generic turbo blocks defined first.
#  This command will only modify & enhance the construct of the turbo blocks.
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#  => You may re-arrange the words sequence within each block template.
#     However, you MUST NOT edit the expressions within the words,
#     remove or add any other words into these turbo blocks.
#
#  In Post Builder, you may modify the parameters of the Words used
#  with the turbo blocks on the N/C Data Defitions dialogs. You may also
#  modify the parameters of Formats involved for the turbo output.
#
#  Custom commands used in the linear move, circular move & rapid move
#  event handlers will be ignored. MOM_before_motion handler will not be executed.
#
#  By default, rapid motions are also processed in turbo mode where
#  each motion is output in a single block.
#  => "MOM_set_turbo_rapid FALSE" (see below) can be issued in order to process
#     the rapid motions in standard mode instead, of which the customization
#     done for the rapid motions including MOM_before_motion will be executed.
#     This would greatly enhance the customizability of a turbo post.
#
#
# Revisions:
# Jan-19-2017 gsl - (pb11.02) Revised to accommodate advanced turbo mode
#


##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
UNSET_VARS ::mom_kin_is_turbo_output
##
## Uncomment a line below to disable Advanced Turbo mode.
## => Without setting this variable, Advanced Turbo mode will continue.
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# set ::mom_kin_is_turbo_output TRUE   ;# To post in legacy turbo mode
# set ::mom_kin_is_turbo_output FALSE  ;# To post in standard mode


 if { ![info exists ::mom_kin_is_turbo_output] } {
return
 }



##++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Process RAPID motions in standard mode, when desired.
## => This option can also be configured per operations.
##++++++++++++++++++++++++++++++++++++++++++++++++++++++
 if [CMD_EXIST MOM_set_turbo_rapid] {
   # MOM_set_turbo_rapid "FALSE"
 }


##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Set variable below to "1" to output arc radius for circular moves.
## => This option is not available in turbo mode prior to NX10.0.3.
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 set use_arc_radius_output 0



  #------------------------------------------
  # Verify if legacy turbo mode can proceed -
   if { ![PB_CMD__validate_turbo_mode] } {
return
   }


   set tmp_file $::mom_user_turbo_def_fid
   fconfigure $tmp_file -translation lf

   set ugii_version [string trimleft [MOM_ask_env_var UGII_VERSION] v]
   regexp {[0-9]} $::mom_kin_machine_type machine_axis


  #+++++++++++++++++++++
  # Define turbo blocks
  #+++++++++++++++++++++
   puts $tmp_file {MACHINE mill }
   puts $tmp_file {FORMATTING }
   puts $tmp_file "{"
   puts $tmp_file {     FORMAT Spindle_Digit_2 "&__2_00" }

   if { !$use_arc_radius_output } {
      puts $tmp_file {  ADDRESS CX }
      puts $tmp_file " {"
      puts $tmp_file {       FORMAT      Coordinate }
      puts $tmp_file {       FORCE       always }
      puts $tmp_file {       MAX         99999.999 Truncate }
      puts $tmp_file {       MIN         -99999.999 Truncate }
      puts $tmp_file {       LEADER      [$mom_sys_leader(X)] }
      puts $tmp_file {       ZERO_FORMAT Zero_real }
      puts $tmp_file " }"

      puts $tmp_file {  ADDRESS CY }
      puts $tmp_file " {"
      puts $tmp_file {       FORMAT      Coordinate }
      puts $tmp_file {       FORCE       always }
      puts $tmp_file {       MAX         99999.999 Truncate }
      puts $tmp_file {       MIN         -99999.999 Truncate }
      puts $tmp_file {       LEADER      [$mom_sys_leader(Y)] }
      puts $tmp_file {       ZERO_FORMAT Zero_real }
      puts $tmp_file " }"

      puts $tmp_file {  ADDRESS CZ }
      puts $tmp_file " {"
      puts $tmp_file {       FORMAT      Coordinate }
      puts $tmp_file {       FORCE       always }
      puts $tmp_file {       MAX         99999.999 Truncate }
      puts $tmp_file {       MIN         -99999.999 Truncate }
      puts $tmp_file {       LEADER      [$mom_sys_leader(Z)] }
      puts $tmp_file {       ZERO_FORMAT Zero_real }
      puts $tmp_file " }"
   }


   if { $use_arc_radius_output } {
      puts $tmp_file {  BLOCK_TEMPLATE circular_move_turbo }
      puts $tmp_file "  {"

      if { [EQ_is_ge $ugii_version 12] } {
         puts $tmp_file {    G_plane[^sys_cutcom_plane_code(ARC_PLANE)]\opt }
      }
      puts $tmp_file {       G_motion[CR]\opt }
      puts $tmp_file {       X[^POSX] }
      puts $tmp_file {       Y[^POSY] }
      puts $tmp_file {       Z[^POSZ] }
      puts $tmp_file {       R[^arc_radius] }
      puts $tmp_file {       circle_direction[^sys_circle_code(ARC_DIRECTION)]\opt }
      puts $tmp_file {       F[^FEED] }
      puts $tmp_file "  }"

   } else {

      puts $tmp_file {  BLOCK_TEMPLATE circular_move_turbo }
      puts $tmp_file "  {"
      puts $tmp_file {       Text[CC] }
      puts $tmp_file {       I[^CENTERX] }
      puts $tmp_file {       J[^CENTERY] }
      puts $tmp_file {       K[^CENTERZ] }
      puts $tmp_file "  }"

      puts $tmp_file {  BLOCK_TEMPLATE circular_move_1_turbo }
      puts $tmp_file "  {"

      if { [EQ_is_ge $ugii_version 12] } {
         puts $tmp_file {    G_plane[^sys_cutcom_plane_code(ARC_PLANE)]\opt }
      }
      puts $tmp_file {       G_motion[C]\opt }
      puts $tmp_file {       CX[^POSX] }
      puts $tmp_file {       CY[^POSY] }
      puts $tmp_file {       CZ[^POSZ] }
      puts $tmp_file {       circle_direction[^sys_circle_code(ARC_DIRECTION)]\opt }
      puts $tmp_file {       F[^FEED] }
      puts $tmp_file "  }"
   }

   puts $tmp_file {  BLOCK_TEMPLATE linear_move_turbo }
   puts $tmp_file "  {"
   puts $tmp_file {          LN[LN] }
   puts $tmp_file {          G_cutcom[^sys_cutcom_code(CUTCOM_STATUS)]\opt }
   puts $tmp_file {          G_plane[^sys_cutcom_plane_code(CUTCOM_PLANE)]\opt }
   puts $tmp_file {          G_motion[^sys_linear_code] }
   puts $tmp_file {          X[^POSX] }
   puts $tmp_file {          Y[^POSY] }
   puts $tmp_file {          Z[^POSZ] }

   if { $machine_axis > 3 } {

      puts $tmp_file {       fourth_axis[^POS4] }

      if { $machine_axis > 4 } {
         puts $tmp_file {    fifth_axis[^POS5] }
      }

      if { [EQ_is_ge $ugii_version 11] } {
         puts $tmp_file {    TX[^tool_axis0]\opt }
         puts $tmp_file {    TY[^tool_axis1]\opt }
         puts $tmp_file {    TZ[^tool_axis2]\opt }
      }
   }

   if { [EQ_is_ge $ugii_version 11] } {
      puts $tmp_file {       NX[^contact_normal0]\opt }
      puts $tmp_file {       NY[^contact_normal1]\opt }
      puts $tmp_file {       NZ[^contact_normal2]\opt }
   }

   puts $tmp_file {          F[^FEED] }
   puts $tmp_file {          M_spindle[^sys_spindle_direction_code(SPINDLE_DIRECTION)]\opt }
   puts $tmp_file "  }"

   puts $tmp_file {  BLOCK_TEMPLATE rapid_move_turbo }
   puts $tmp_file "  {"
   puts $tmp_file {          LN[LN] }
   puts $tmp_file {          G_motion[^sys_rapid_code] }
   puts $tmp_file {          X[^POSX] }
   puts $tmp_file {          Y[^POSY] }
   puts $tmp_file {          Z[^POSZ] }
   puts $tmp_file {          G_cutcom[^sys_cutcom_code(CUTCOM_STATUS)]\opt }

   if { $machine_axis > 3 } {

      puts $tmp_file {       fourth_axis[^POS4] }

      if { $machine_axis > 4 } {
         puts $tmp_file {     fifth_axis[^POS5] }
      }

      if { [EQ_is_ge $ugii_version 11] } {
         puts $tmp_file {    TX[^tool_axis0]\opt }
         puts $tmp_file {    TY[^tool_axis1]\opt }
         puts $tmp_file {    TZ[^tool_axis2]\opt }
      }
   }

   if { [EQ_is_ge $ugii_version 11] } {
      puts $tmp_file {       NX[^contact_normal0]\opt }
      puts $tmp_file {       NY[^contact_normal1]\opt }
      puts $tmp_file {       NZ[^contact_normal2]\opt }
   }

   puts $tmp_file {          FMAX[MAX] }
   puts $tmp_file "  }"

   puts $tmp_file {  BLOCK_TEMPLATE sequence_number_turbo }
   puts $tmp_file "  {"
   puts $tmp_file {          N[^SEQNUM] }
   puts $tmp_file "  }"
   puts $tmp_file "}"


   close $tmp_file


  # Load turbo blocks
  #
   global tcl_platform
   if { [string match "*windows*" $tcl_platform(platform)] } {
      regsub -all {/} $::mom_user_turbo_def_file_name {\\} ::mom_user_turbo_def_file_name
   }

   if { [catch { MOM_load_definition_file  "$::mom_user_turbo_def_file_name" } res] } {

     # If some addresses are not defined, display message when post processing failed.
      set msg "Failed to load turbo blocks definition. Check if addresses and turbo symbols are correct.\n$res"

      INFO $msg
      CATCH_WARNING $msg

     # Disable turbo mode, if loading failed
      MOM_set_turbo_mode FALSE
   }

   MOM_remove_file  $::mom_user_turbo_def_file_name


  # Bail out, when turbo mode cannot be activated after all.
   if { ![string match "TRUE" $::mom_kin_is_turbo_output] } {
return
   }


  # Fix the issue that the default format is string
   MOM_set_address_format M_spindle Spindle_Digit_2

  # Always output circle center and direction, Post Core does suppress ijk
  # based on arc plane
   if { !$use_arc_radius_output } {
      MOM_force always K I J circle_direction
   }


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # When needed, define a custom command to reset turbo settings
  # @ Initial Move & First Move events.
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # return

  uplevel #0 {

   #=============================================================
   proc CONFIG_TURBO_OUTPUT { } {
   #=============================================================
   # This command is used during turbo posting mode to configure settings
   # that would affect the NC output. It will be executed automatically
   # by the Initial Move and First Move events.
   #
   # ==> Do not rename or attach it to any event.
   #

     # Bail out when not in turbo mode or multi-axis post
      if { ![info exists ::mom_kin_is_turbo_output] ||\
           ![string match "TRUE" $::mom_kin_is_turbo_output] } {

         return
      }

     # 3axis only need to handle contact output
      if { [string match $::mom_kin_machine_type "3_axis_mill"] } {

         if { [info exists mom_nxt_contact_status] &&\
              $::mom_nxt_contact_status == "ON"} {

            MOM_enable_address NX NY NZ LN
            MOM_disable_address G_motion
            MOM_set_turbo_pos_output "MOM_CONTACT_POINT"

         } else {

            MOM_disable_address LN NX NY NZ
            MOM_enable_address G_motion
            MOM_set_turbo_pos_output "MOM_POS"
         }

         return
      }

     # Enable all addresses
      MOM_enable_address NX NY NZ TX TY TZ LN G_motion fourth_axis
      if { [string match "5_*" $::mom_kin_machine_type] } {
         MOM_enable_address fifth_axis
      }


      if { [info exists ::dpp_ge(toolpath_axis_num)] && $::dpp_ge(toolpath_axis_num) == "5" } {
         MOM_set_turbo_pos_output "MOM_MCS_GOTO"
      } else {
         MOM_set_turbo_pos_output "MOM_POS"
      }


      if { [info exists ::mom_output_mode_define] && $::mom_output_mode_define != "ROTARY AXES" } {

        # Output tool axis vectors
         MOM_disable_address fourth_axis G_motion

         if { [string match "5_*" $::mom_kin_machine_type] } {
            MOM_disable_address fifth_axis
         }

        # 3-D ToolComp
         if { [info exists mom_nxt_contact_status] && $mom_nxt_contact_status == "ON" } {
            MOM_set_turbo_pos_output "MOM_CONTACT_POINT"
         } else {
            MOM_disable_address NX NY NZ
         }

      } else {

        # Output rotary angles
         MOM_disable_address NX NY NZ TX TY TZ LN
      }
   }

  } ;# uplevel
}


#=============================================================
proc PB_CMD__activate_Sinumerik_turbo_mode { } {
#=============================================================
#  This custom command will activate the turbo process mode for
#  the posts of Sinumerik controllers. The execution time
#  will be 15 to 20 % of that required in the standard mode.
#
#  This command may only be used with Post Builder 3.2.1 or later
#  and NX2 or newer.
#
#  => Place this command with the "Start of Program" event marker.
#
#  The following turbo blocks are defined in this command:
#
#     linear_move_turbo
#     circular_move_turbo
#     rapid_move_turbo
#     sequence_number_turbo
#
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Definitions file of the post involved MUST have generic turbo blocks defined first.
#  This command will only modify & enhance the construct of the turbo blocks.
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#  => You may re-arrange the words sequence within each block template.
#     However, you MUST NOT edit the expressions within the words,
#     remove or add any other words into these turbo blocks.
#
#  In Post Builder, you may modify the parameters of the Words used
#  with the turbo blocks on the N/C Data Defitions dialogs. You may also
#  modify the parameters of Formats involved for the turbo output.
#
#  Custom commands used in the linear move, circular move & rapid move
#  event handlers will be ignored. MOM_before_motion handler will not be executed.
#
#  By default, rapid motions are also processed in turbo mode where
#  each motion is output in a single block.
#  => "MOM_set_turbo_rapid FALSE" (see below) can be issued in order to process
#     the rapid motions in standard mode instead, of which the customization
#     done for the rapid motions including MOM_before_motion will be executed.
#     This would greatly enhance the customizability of a turbo post.
#
#
# Revisions:
# Jan-19-2017 gsl - (pb11.02) Revised to accommodate advanced turbo mode
#


##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
UNSET_VARS ::mom_kin_is_turbo_output
##
## Uncomment a line below to disable Advanced Turbo mode.
## => Without setting this variable, Advanced Turbo mode will continue.
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# set ::mom_kin_is_turbo_output TRUE   ;# To post in legacy turbo mode
# set ::mom_kin_is_turbo_output FALSE  ;# To post in standard mode


 if { ![info exists ::mom_kin_is_turbo_output] } {
return
 }



##++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Process RAPID motions in standard mode, when desired.
## => This option can also be configured per operations.
##++++++++++++++++++++++++++++++++++++++++++++++++++++++
 if [CMD_EXIST MOM_set_turbo_rapid] {
   # MOM_set_turbo_rapid "FALSE"
 }


##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Set variable below to "1" to output arc radius for circular moves.
## => This option is not available in turbo mode prior to NX10.0.3.
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 set use_arc_radius_output 0



  #------------------------------------------
  # Verify if legacy turbo mode can proceed -
   if { ![PB_CMD__validate_turbo_mode] } {
return
   }


   set tmp_file $::mom_user_turbo_def_fid
   fconfigure $tmp_file -translation lf

   set ugii_version [string trimleft [MOM_ask_env_var UGII_VERSION] v]
   regexp {[0-9]} $::mom_kin_machine_type machine_axis


  #+++++++++++++++++++++
  # Define turbo blocks
  #+++++++++++++++++++++
   puts $tmp_file {MACHINE mill}
   puts $tmp_file {FORMATTING}
   puts $tmp_file "{"
   puts $tmp_file {  BLOCK_TEMPLATE circular_move_turbo }
   puts $tmp_file "  {"

   if { [EQ_is_ge $ugii_version 12] } {
      puts $tmp_file {     G_plane[^sys_cutcom_plane_code(ARC_PLANE)]\opt }
   }
   puts $tmp_file {        G_feed[^sys_feed_rate_mode_code(FEED_MODE)]\opt }
   puts $tmp_file {        G_motion[^sys_circle_code(ARC_DIRECTION)] }
   puts $tmp_file {        G_mode[^sys_output_code(OUTPUT_MODE)] }
   puts $tmp_file {        X[^POSX] }
   puts $tmp_file {        Y[^POSY] }
   puts $tmp_file {        Z[^POSZ] }

   if { $use_arc_radius_output } {

      puts $tmp_file {     R[^arc_radius] }

   } else {

      puts $tmp_file {     I[^CENTERX] }
      puts $tmp_file {     J[^CENTERY] }
      puts $tmp_file {     K[^CENTERZ] }
   }
   puts $tmp_file {        S[^SPINDLE_SPEED] }
   puts $tmp_file {        F[^FEED] }
   puts $tmp_file "  }"

   puts $tmp_file {  BLOCK_TEMPLATE linear_move_turbo }
   puts $tmp_file "  {"
   puts $tmp_file {        G_cutcom[^sys_cutcom_code(CUTCOM_STATUS)]\opt }
   puts $tmp_file {        G_plane[^sys_cutcom_plane_code(CUTCOM_PLANE)]\opt }
   puts $tmp_file {        G_feed[^sys_feed_rate_mode_code(FEED_MODE)]\opt }
   puts $tmp_file {        G_motion[^sys_linear_code] }
   puts $tmp_file {        X[^POSX] }
   puts $tmp_file {        Y[^POSY] }
   puts $tmp_file {        Z[^POSZ] }

   if { $machine_axis > 3 } {

      puts $tmp_file {     fourth_axis[^POS4] }

      if { $machine_axis > 4 } {
         puts $tmp_file {  fifth_axis[^POS5] }
      }

      if { [EQ_is_ge $ugii_version 11] } {

         puts $tmp_file {  A3[^tool_axis0]\opt }
         puts $tmp_file {  B3[^tool_axis1]\opt }
         puts $tmp_file {  C3[^tool_axis2]\opt }
      }
   }
   if { [EQ_is_ge $ugii_version 11] } {
      puts $tmp_file {     A5[^contact_vector0]\opt }
      puts $tmp_file {     B5[^contact_vector1]\opt }
      puts $tmp_file {     C5[^contact_vector2]\opt }
   }
   puts $tmp_file {        S[^SPINDLE_SPEED] }
   puts $tmp_file {        D[^tool_adjust_register]\opt }
   puts $tmp_file {        M_spindle[^sys_spindle_direction_code(SPINDLE_DIRECTION)]\opt }
   puts $tmp_file {        M_coolant[^sys_coolant_code(COOLNT_STATUS)]\opt }
   puts $tmp_file {        F[^FEED] }
   puts $tmp_file "  }"

   puts $tmp_file {  BLOCK_TEMPLATE rapid_move_turbo }
   puts $tmp_file "  {"
   puts $tmp_file {        G_cutcom[^sys_cutcom_code(CUTCOM_STATUS)]\opt }
   puts $tmp_file {        G_motion[^sys_rapid_code] }
   puts $tmp_file {        X[^POSX] }
   puts $tmp_file {        Y[^POSY] }
   puts $tmp_file {        Z[^POSZ] }

   if { $machine_axis > 3 } {

      puts $tmp_file {     fourth_axis[^POS4] }

      if { $machine_axis > 4 } {
         puts $tmp_file {  fifth_axis[^POS5] }
      }

      if { [EQ_is_ge $ugii_version 11] } {
         puts $tmp_file {  A3[^tool_axis0]\opt }
         puts $tmp_file {  B3[^tool_axis1]\opt }
         puts $tmp_file {  C3[^tool_axis2]\opt }
      }
   }

   if { [EQ_is_ge $ugii_version 11] } {
      puts $tmp_file {     A5[^contact_vector0]\opt }
      puts $tmp_file {     B5[^contact_vector1]\opt }
      puts $tmp_file {     C5[^contact_vector2]\opt }
   }
   puts $tmp_file {        S[^SPINDLE_SPEED] }
   puts $tmp_file {        D[^tool_adjust_register]\opt }
   puts $tmp_file {        M_spindle[^sys_spindle_direction_code(SPINDLE_DIRECTION)]\opt }
   puts $tmp_file "   }"

   puts $tmp_file {  BLOCK_TEMPLATE sequence_number_turbo }
   puts $tmp_file "  {"
   puts $tmp_file {        N[^SEQNUM] }
   puts $tmp_file "  }"
   puts $tmp_file "}"

   close $tmp_file


  # Load turbo blocks
  #
   global tcl_platform
   if { [string match "*windows*" $tcl_platform(platform)] } {
      regsub -all {/} $::mom_user_turbo_def_file_name {\\} ::mom_user_turbo_def_file_name
   }

   if { [catch { MOM_load_definition_file  "$::mom_user_turbo_def_file_name" } res] } {

     # If some addresses are not defined, display message when post processing failed.
      set msg "Failed to load turbo blocks definition. Check if addresses and turbo symbols are correct.\n$res"

      INFO $msg
      CATCH_WARNING $msg

     # Disable turbo mode, if loading failed
      MOM_set_turbo_mode FALSE
   }

   MOM_remove_file  $::mom_user_turbo_def_file_name


   if { ![string match "TRUE" $::mom_kin_is_turbo_output] } {
return
   }


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # When needed, define a custom command to reset turbo settings
  # @ Initial Move & First Move.
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # return

  uplevel #0 {

   #=============================================================
   proc CONFIG_TURBO_OUTPUT { } {
   #=============================================================
   # This command is used during turbo posting mode to configure settings
   # that would affect the NC output. It will be executed automatically
   # by the Initial Move and First Move events.
   #
   # ==> Do not rename or attach it to any event.
   #

     # Bail out when not in turbo mode or multi-axis post
      if { ![info exists ::mom_kin_is_turbo_output] ||\
           ![string match "TRUE" $::mom_kin_is_turbo_output] } {
         return
      }


      if { [string match "3_axis_mill" $::mom_kin_machine_type] } {

         if { [info exists ::mom_nxt_contact_status] &&\
             ![string compare "ON" $::mom_nxt_contact_status] } {

             MOM_set_turbo_pos_output "MOM_CONTACT_GOTO"
             MOM_enable_address A5 B5 C5

         } else {

             MOM_set_turbo_pos_output "MOM_POS"
             MOM_disable_address A5 B5 C5
         }

         return
      }


     # Enable all addresses
      MOM_enable_address A3 B3 C3 A5 B5 C5 fourth_axis

      if { [string match "5_*" $::mom_kin_machine_type] } {
         MOM_enable_address fifth_axis
      }

     # mom_siemens_ori_def :
     # ROTARY AXIS : programming with rotary axis
     # VECTOR : programming with tool orientation
      if { ![info exists ::mom_siemens_ori_def] } {
         set ::mom_siemens_ori_def "ROTARY AXIS"
      }

     # mom_siemens_coord_rotation :
     # 0 : no coordinate rotation
     # 1 : CSYS Rotation
     # 2 : auto3D, coordinate rotation from tilt tool axis
      if { ![info exists ::mom_siemens_coord_rotation] } {
         set ::mom_siemens_coord_rotation "0"
      }


     # mom_siemens_5axis_output_mode TCP mode "1"/"0"
      if { $::mom_siemens_5axis_output_mode == 1 &&\
           $::mom_siemens_coord_rotation != 2 } {

        # TRAORI ON
         if { [string match "*VECTOR*" $::mom_siemens_ori_def] } {

            MOM_disable_address fourth_axis

            if { ![string match "5_*" $::mom_kin_machine_type] } {
               MOM_disable_address fifth_axis
            }

         } else {

            MOM_disable_address A3 B3 C3
         }

         MOM_set_turbo_pos_output "MOM_MCS_GOTO"

      } else {

        # TRAORI OFF
         MOM_disable_address A3 B3 C3
         MOM_set_turbo_pos_output "MOM_POS"
      }

     # 3D cutcom
      if { [info exists ::mom_nxt_contact_status] && ![string compare "ON" $::mom_nxt_contact_status] } {

         MOM_set_turbo_pos_output "MOM_CONTACT_GOTO"

      } else {

         MOM_disable_address A5 B5 C5
      }
   }

  } ;# uplevel
}




