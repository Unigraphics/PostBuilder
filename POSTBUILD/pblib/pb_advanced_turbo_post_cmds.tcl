## HEADER BLOCK START ##
##############################################################################
#                                                                            #
# Copyright(c) 1999/2000/2001/2002/2003/2004/2005/2006, UGS PLM Solutions.   #
# Copyright(c) 2007 ~ 2016,                             SIEMENS PLM Software #
#                                                                            #
##############################################################################
#        P B _ A D V A N C E D _ T U R B O _ P O S T _ C M D S . T C L
##############################################################################
#
# Custom commands in this file are used to facilitate the customization
# of advanced turbo posts.
#
#=============================================================================
#
# In NX11.01, Post Builder allows the users to interactively avtivate any mill
# post of 3 to 5 axes to run in the Advanced Turbo mode. Custom commands in
# this package would enable the users to further customize & configure the
# post in question to fit the specific requirements.
#
#   PB_CMD__AdvTurboPost__Customize_Post       - 
#   PB_CMD__AdvTurboPost__config_before_motion - 
#   PB_CMD__AdvTurboPost__config_end_of_path   - 
#   PB_CMD__AdvTurboPost__config_output        - 
#
# Post Builder will add the commands in this package to a post when the
# Advanced Turbo output mode is enabled.
#
#=============================================================================
## HEADER BLOCK END ##




#=============================================================
proc PB_CMD__AdvTurboPost__Customize_Post { } {
#=============================================================
# - For NX11.01 & up -
#
#  This custom command can be used to customize the behavior of
#  a post with the advanced turbo mode enabled by Post Builder.
#
#  Post qualified to be processed in advanced turbo mode, when saved
#  in Post Builder v11.01 & newer, will execute this command automatically.
#  => Do not attach this command to any event marker.
#

   if { ![info exists ::mom_sys_advanced_turbo_output] || !$::mom_sys_advanced_turbo_output } {
return
   }

#
#  By default, the RAPID motions without work plane change will be processed
#  in turbo mode.  "MOM_set_turbo_rapid FALSE" can be issued in this command
#  to force all rapid motions to be processed in standard mode instead.
#  It would allow the users to carry out more customization with the rapid motions.
#
#  For any reason, user can also disable the turbo mode within this command.
#


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Uncomment "return" statement below to skip the customization
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# return


#++++++++++++++++++++++++++++++++++++++++++++++++
# Uncomment next statement to disable turbo mode
#++++++++++++++++++++++++++++++++++++++++++++++++
#   set ::mom_sys_advanced_turbo_output FALSE


   if { !$::mom_sys_advanced_turbo_output } {
      INFO "Turn off adv turbo mode"
      MOM_set_turbo_mode FALSE ADVANCED
 return
   }



  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # By default, options below have been disabled to optimize the turbo post performance;
  # => User may activate any of the options to fine tune the output of a turbo post.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   set ::mom_sys_advanced_turbo_option(ABORT_EVENT_CHECK)  0
   set ::mom_sys_advanced_turbo_option(HANDLE_1ST_LINEAR)  0
   set ::mom_sys_advanced_turbo_option(OUTPUT_OPER_MSG)    0
   set ::mom_sys_advanced_turbo_option(CALL_CIRCLE_SET)    0
   set ::mom_sys_advanced_turbo_option(DO_FORCE_SUPPRESS)  0



  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Advanced turbo mode is only available in NX11.01 & newer:
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   set ugii_full_version [string trimleft [MOM_ask_env_var UGII_FULL_VERSION] v]

   if { [COMPARE_NX_VERSION $ugii_full_version "11.0.1"] < 0 } {
      set msg "Advanced Turbo Mode is not available in NX v$ugii_full_version!"

      if [CMD_EXIST PAUSE] {
         PAUSE "Turbo Mode Activation Error" $msg
      }

      CATCH_WARNING $msg

      MOM_set_turbo_mode FALSE ADVANCED
      set ::mom_sys_advanced_turbo_output FALSE
return
   }



  #+++++++++++++++++++++++++++++++++++++++++++++++++++
  # Turbo mode is only usable for 3-5 axes mill posts
  #+++++++++++++++++++++++++++++++++++++++++++++++++++
   if { [string match "*wedm*"      $::mom_kin_machine_type] ||\
        [string match "*lathe*"     $::mom_kin_machine_type] ||\
        [string match "*mill_turn*" $::mom_kin_machine_type] } {

      set msg "Turbo mode can only be activated for 3, 4 & 5-axis mill posts!"

      if [CMD_EXIST PAUSE] {
         PAUSE "Turbo Mode Activation Error" $msg
      }

      CATCH_WARNING $msg
      MOM_set_turbo_mode FALSE ADVANCED
return
   }



  #+++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Handle RAPID motions in standard mode, when desired.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++
  # MOM_set_turbo_rapid FALSE



  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Enable MOM_before_motion to be handled when motion type changes.
  # => Can achieve better flexibility, but may hamper performance
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # MOM_set_turbo_before_motion TRUE



  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Cancel the effect of MOM_force & MOM_suppress once for each event.
  # => To eliminate the residual effect of MOM force & suppress once.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   MOM_cancel_suppress_force_once_per_event



  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Additional variables to be updated during turbo posting mode -
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   set ::mom_sys_turbo_global_add_vars_list "mom_feedrate"

}


#=============================================================
proc PB_CMD__AdvTurboPost__config_before_motion { } {
#=============================================================
# - For NX11.01 & up -
#
#  This custom command, when present in an advanced turbo post, will be executed
#  automatically in MOM_before_motion to adjust variables, e.g. feedrates',
#  for the output of non-turbo events.
#
#  => Modify this command to accommodate the needs of your post
#

   if { ![info exists ::mom_sys_advanced_turbo_output] || !$::mom_sys_advanced_turbo_output } {
return
   }


   if { ![string compare $::mom_kin_output_unit "IN"] } {
     # For iTNC -
     # set ::mom_sys_feed_rate_factor 10.0
   }

   if { [info exists ::feed] } {
      set ::mom_feedrate $::feed
   } else {
      set ::mom_feedrate $::mom_feed_rate
   }

   if { [info exists ::feed_mode] } {
      set ::mom_feedrate_mode $::feed_mode
   } else {
      set ::mom_feedrate_mode $::mom_feed_rate_mode
   }

}


#=============================================================
proc PB_CMD__AdvTurboPost__config_end_of_path { } {
#=============================================================
# - For NX11.01 & up -
#
#  This custom command, when present in an advanced turbo post,
#  will be executed automatically at the End-of-Path event handler.
#

   if { ![info exists ::mom_sys_advanced_turbo_output] || !$::mom_sys_advanced_turbo_output } {
return
   }


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Restore certain address expressions that have been altered
  # by PB_CMD__AdvTurboPost__config_output.
  #

   set address F
   foreach block_list { ::mom_sys_linear_turbo_blocks ::mom_sys_circular_turbo_blocks ::mom_sys_rapid_turbo_blocks } {

      if [info exists ${block_list}] {
         foreach block [set ${block_list}] {

            if { [info exists ::save_address_expression($block,$address)] } {

               if { [MOM_has_definition_element BLOCK $block] && [MOM_has_definition_element ADDRESS $address] } {
                  MOM_set_address_expression $block $address $::save_address_expression($block,$address)
                  unset ::save_address_expression($block,$address)
               }
            }
         }
      }
   }

   foreach block_list { ::mom_sys_linear_turbo_blocks ::mom_sys_rapid_turbo_blocks } {

      if [info exists ${block_list}] {
         foreach block [set ${block_list}] {

            foreach address { X Y Z } {
               if { [info exists ::save_address_expression($block,$address)] } {

                  if { [MOM_has_definition_element BLOCK $block] && [MOM_has_definition_element ADDRESS $address] } {
                     MOM_set_address_expression $block $address $::save_address_expression($block,$address)
                     unset ::save_address_expression($block,$address)
                  }
               }
            }
         }
      }
   }

}


#=============================================================
proc PB_CMD__AdvTurboPost__config_output { } {
#=============================================================
# - For NX11.01 & up -
#
#  This custom command, when present in an advanced turbo post,
#  will be executed automatically. It can be used to further
#  configure the output of the post in question.
#

   if { ![info exists ::mom_sys_advanced_turbo_output] || !$::mom_sys_advanced_turbo_output } {
return
   }


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Configure address expressions used during turbo mode
  #
  # - Address expressions will be restored at the End-of-Path event handler
  #   automatically via procedures in PB_CMD__AdvTurboPost__config_end_of_path.
  #
  # Similar action is performed in PB_CMD_before_motion for standard posting mode -
  #   if { $dpp_ge(sys_output_coord_mode) == "TCP_FIX_TABLE" && $dpp_ge(toolpath_axis_num) == 5 } {
  #      VMOV 3 mom_mcs_goto mom_pos
  #      VMOV 3 mom_prev_mcs_goto mom_prev_pos
  #      VMOV 3 mom_arc_center mom_pos_arc_center
  #   }
  #

  #-------------------------------------
  # Set address expression for F output
  #
   set address F
   foreach block_list { ::mom_sys_linear_turbo_blocks ::mom_sys_circular_turbo_blocks ::mom_sys_rapid_turbo_blocks } {

      if [info exists ${block_list}] {
         foreach block [set ${block_list}] {

            if { [MOM_has_definition_element BLOCK $block] && [MOM_has_definition_element ADDRESS $address] } {
               set ::save_address_expression($block,$address) \
                        [MOM_set_address_expression $block $address "\$mom_feedrate"]
            }
         }
      }
   }


  #============
  # iTNC case -
   set output_mode "MOM_POS"

  # 3axis only need to handle contact output
   if { [string match $::mom_kin_machine_type "3_axis_mill"] } {

      if { [info exists mom_nxt_contact_status] &&\
           $::mom_nxt_contact_status == "ON"} {

         MOM_disable_address G_motion
         set output_mode "MOM_CONTACT_POINT"

      } else {

         MOM_enable_address G_motion
      }

   } else {

      if { [string match "5_*" $::mom_kin_machine_type] } {
         MOM_enable_address fifth_axis
      }

      if { [info exists ::m128_mode] && $::m128_mode == "ON" } {
         set output_mode "MOM_MCS_GOTO"
      }

      if { [info exists ::mom_output_mode_define] && $::mom_output_mode_define != "ROTARY AXES" } {

        # Output tool axis vectors
         MOM_disable_address fourth_axis G_motion

         if { [string match "5_*" $::mom_kin_machine_type] } {
            MOM_disable_address fifth_axis
         }

        # 3-D ToolComp
         if { [info exists mom_nxt_contact_status] && $mom_nxt_contact_status == "ON" } {
            set output_mode "MOM_CONTACT_POINT"
         }
      }
   }


  #=============
  # Fanuc case -
   if { [info exists ::dpp_ge(sys_output_coord_mode)] && [info exists ::dpp_ge(toolpath_axis_num)] &&\
        $::dpp_ge(sys_output_coord_mode) == "TCP_FIX_TABLE" && $::dpp_ge(toolpath_axis_num) == 5 } {

      set output_mode "MOM_MCS_GOTO"
   }


  #===================================================
  # For all, set address expressions per output mode -
  #
   if { ![string match "MOM_POS" $output_mode] } {

      foreach block_list { ::mom_sys_linear_turbo_blocks ::mom_sys_rapid_turbo_blocks } {

         if [info exists ${block_list}] {
            foreach block [set ${block_list}] {

               if { [MOM_has_definition_element BLOCK $block] } {
                  foreach address { X Y Z } idx { 0 1 2 } {

                     if { [MOM_has_definition_element ADDRESS $address] } {

                        switch $output_mode {
                           MOM_MCS_GOTO {
                              set ::save_address_expression($block,$address) \
                                  [MOM_set_address_expression $block $address "\$mom_mcs_goto($idx)"]
                           }
                           MOM_CONTACT_POINT {
                              set ::save_address_expression($block,$address) \
                                  [MOM_set_address_expression $block $address "\$mom_contact_point($idx)"]
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

}




