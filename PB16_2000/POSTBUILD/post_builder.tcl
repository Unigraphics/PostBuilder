#==========================================================================
 global env

 set script [info script]
 if {$script != {}} {
   set gPB_dir [file dirname $script]
 } else {
   set gPB_dir [pwd]
 }

 set env(USERNAME) Admin
 set env(UGII_BASE_DIR) "C:/UG160"

#==========================================================================
# PB_HOME is the only env var referenced in the Post Builder source codes.
# It should be set based on the Post Builder installation.
#==========================================================================
 set env(PB_HOME) $gPB_dir

#==========================================================================
# Some vars for Tcl etc.
#==========================================================================
set env(PB_TCL) $tcl_library

set env(TCL_LIBRARY) $tcl_library
set env(TK_LIBRARY)  $tk_library
#set env(TIX_LIBRARY) $env(PB_HOME)/share/tix4.1

#==========================================================================
# Start Post Builder
#==========================================================================
# Параметры   "!$%^(@*#&)" UG_POST_MILL  UG_POST_ADV_BLD
#
# %PB_HOME%\app\Postino.exe  "!$%^(@*#&)" UG_POST_MILL
#

source $env(PB_HOME)/app/postino.tcl