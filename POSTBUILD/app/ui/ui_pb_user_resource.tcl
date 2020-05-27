##############################################################################
#			UI_PB_USER_RESOURCE.TCL				     #
##############################################################################
# Description                                                                #
# -----------                                                                #
#    This file defines personalized resources for the Post Builder session.  #
#                                                                            #
#    *** All statements in this file comply with Tcl syntax.                 #
#        Double back-slashes will be required for M/S Windows environment to #
#        specify the directory names.                                        #
#                                                                            #
# Revisions                                                                  #
# ---------                                                                  #
#   Date        Who       Reason                                             #
# 31-Jul-2000   gsl       Initial                                            #
##############################################################################

#-----------------------------------------------------------------------------
# Internet browser for Unix environment
#-----------------------------------------------------------------------------
# - This parameter defines the command or alias that brings up the internet
#   browser when running Post Builder in Unix environment to display the
#   on-line help documents.
#
set gPB(unix_netscape)          "netscape4.72"


#-----------------------------------------------------------------------------
# Font sets specifications
#-----------------------------------------------------------------------------
# - These parameters define various font types and sizes to be used in the
#   Post Builder.
#
# - The syntax/example for Unix environment can be found in the resource file
#   ui_pb_resource.tcl in the POSTBUILD/app/ui directory.
#
if {$tcl_platform(platform) == "windows"} \
{
   set gPB(font)                 {ansi 9}                ;# regular font
   set gPB(font_sm)              {ansi 8}                ;# regular font - small
   set gPB(bold_font)            {ansi 9 bold}           ;# bold font
   set gPB(bold_font_lg)         {ansi 11 bold}          ;# bold font - large
   set gPB(italic_font)          {ansi 9 italic bold}    ;# italic font
   set gPB(fixed_font)           {fixedsys 9}            ;# fixed font
   set gPB(fixed_font_sm)        {courier 8}             ;# fixed font - small
}

