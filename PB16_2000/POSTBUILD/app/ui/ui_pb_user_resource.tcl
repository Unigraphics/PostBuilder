##############################################################################
#			UI_PB_USER_RESOURCE.TCL				     #
##############################################################################
# Description                                                                #
#    This file defines personalized resources for the PostBuilder.           #
#                                                                            #
# Revisions                                                                  #
# ---------                                                                  #
#   Date        Who       Reason                                             #
# 31-Jul-2000   gsl       Initial                                            #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

global gPB env tcl_platform tixOption


set gPB(unix_browser)				"netscape4.72"

#========================
# Font set specification
#========================
if {$tcl_platform(platform) == "windows"} \
{
  set gPB(font)			{ansi 10}
  set gPB(font_sm)		{ansi 8}
  set gPB(bold_font)		{ansi 10 bold}
  set gPB(bold_font_lg)		{ansi 12 bold}
  set gPB(italic_font)		{ansi 10 italic bold}
  set gPB(fixed_font)		{courier 10}
  set gPB(fixed_font_sm)	{courier 8}
}
