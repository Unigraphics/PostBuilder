################################################################################
#                                                                              #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.      #
#                                                                              #
################################################################################
#                       U I _ P B _ F O N T S . T C L
################################################################################
#                                                                              #
# Description                                                                  #
#     This file contains the fonts setting for different language.             #
#                                                                              #
################################################################################

global gPB env tixOption


if ![info exists gPB(LANG)] {
   return
}


if { ![string compare $::tcl_platform(platform) "windows"] } {

   switch $gPB(LANG) {

      "pb_msg_simple_chinese" -
      "pb_msg_traditional_chinese" {

         set gPB(font)                {simsun 10}
         set gPB(font_sm)             {ansi 8}
         set gPB(bold_font)           {simsun 10 bold}
         set gPB(bold_font_lg)        {simsun 10 bold}
         set gPB(italic_font)         $gPB(bold_font)
         set gPB(italic_font_normal)  {simsun 9 italic}
         set gPB(fixed_font)          {{courier new} 10}
         set gPB(fixed_font_sm)       {courier 7}
      }

      "pb_msg_japanese" -
      "pb_msg_korean" {

         set gPB(font)                {ansi 9}
         set gPB(font_sm)             {ansi 8}
         set gPB(bold_font)           {ansi 9 bold}
         set gPB(bold_font_lg)        {ansi 11 bold}
         set gPB(italic_font)         $gPB(bold_font)
         set gPB(italic_font_normal)  {ansi 9 italic}
         set gPB(fixed_font)          {{courier new} 10}
         set gPB(fixed_font_sm)       {courier 7}
      }

      "pb_msg_english" -
      "pb_msg_french"  -
      "pb_msg_german"  -
      "pb_msg_italian" -
      "pb_msg_russian" -
      "pb_msg_spanish" -

      default {

         set gPB(font)                {ansi 9}
         set gPB(font_sm)             {ansi 8}
         set gPB(bold_font)           {ansi 9 bold}
         set gPB(bold_font_lg)        {ansi 11 bold}
         set gPB(italic_font)         {ansi 9 italic bold}
         set gPB(italic_font_normal)  {ansi 9 italic}
         set gPB(fixed_font)          {{courier new} 10}
         set gPB(fixed_font_sm)       {courier 7}
      }
   }

} else {

   if { ![info exists tixOption(font)] } {
       tixSetDefaultFontset
   }

   set gPB(font)                $tixOption(font)
   set gPB(font_sm)             {helvetica 9}
   set gPB(bold_font)           $tixOption(bold_font)
   set gPB(bold_font_lg)        {helvetica 11 bold}
   set gPB(italic_font)         $tixOption(italic_font)
   set gPB(italic_font_normal)  {helvetica 9 italic}
   set gPB(fixed_font)          {courier 12}
   set gPB(fixed_font_sm)       {courier 10}
}


#===================================================================
# The user can also customize the fonts set in ui_pb_user_fonts.tcl.
# This file should be placed in the HOME directory.
#===================================================================
if { [file exists $env(HOME)/ui_pb_user_fonts.tcl] } {
   source $env(HOME)/ui_pb_user_fonts.tcl
}



