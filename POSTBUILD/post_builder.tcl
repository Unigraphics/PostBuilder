#==========================================================================
 global env

 set script [info script]
 if {$script != {}} {
   set gPB_dir [file dirname $script]
 } else {
   set gPB_dir [pwd]
 }

 set env(USERNAME) Admin
 set env(UGII_BASE_DIR) "C:/UGNX85"

 set env(PB_ENABLE_INTERNAL_LICENSE_CONTROL) 0

#==========================================================================
# PB_HOME is the only env var referenced in the Post Builder source codes.
# It should be set based on the Post Builder installation.
#==========================================================================
 set env(PB_HOME) $gPB_dir

#==========================================================================
# <01-26-2011 gsl>
# Set variable to activate subpost functionalities.
#==========================================================================
set env(SUB_POST) 1

#==========================================================================
# Some vars for Tcl etc.
#==========================================================================
set env(PB_TCL) $tcl_library

set env(TCL_LIBRARY) $tcl_library
set env(TK_LIBRARY)  $tk_library
#set env(TIX_LIBRARY) $env(PB_HOME)/share/tix8.4

#==========================================================================
# Force off debug mode in PB
#==========================================================================
set env(UGII_CHECKING_LEVEL) 1

#==========================================================================
# Start Post Builder
#==========================================================================
# %PB_HOME%\app\Postino.exe "2006061812 UG_POST_ADV_BLD "1002010 - *L*N*D*" "{CAM_KIT_POST_100 754} {CAM_KIT_POST_101 756} {CAM_KIT_VNC_100 755} {CAM_KIT_VNC_101 757}" %PB_HOME%"
source $env(PB_HOME)/app/postino.tcl
