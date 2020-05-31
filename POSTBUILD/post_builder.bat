@echo off
@setlocal

REM #########################################################################
REM Revisions
REM =========
REM v800
REM ----
REM Jan-26-2011 gsl - Set SUB_POST to activate subpost functionalities
REM May-11-2015 Shreyash Shinde   ARCH11323: change to nxbin structure
REM Aug-15-2016 gsl - Retain UGII_BASE_DIR
REM #########################################################################


REM==========================================================================
REM PB_HOME is the only env var referenced in the Post Builder source codes.
REM It should be set based on the Post Builder installation.
REM==========================================================================
set base=%1
set base_dir=%base:"=%
set PB_HOME=%base_dir%\postbuild

set UGII_BASE_DIR=%base_dir%
echo UGII_BASE_DIR: %UGII_BASE_DIR%

REM==========================================================================
REM <01-26-2011 gsl>
REM Set variable to activate subpost functionalities.
REM==========================================================================
set SUB_POST=1

REM==========================================================================
REM UG DLL's search path.
REM==========================================================================
set PATH=%base_dir%\NXBIN;%PATH%

REM==========================================================================
REM Some vars for Tcl etc.
REM==========================================================================
set PB_TCL=%PB_HOME%\tcl

set TCL_LIBRARY=%PB_TCL%\share\tcl8.4
set TK_LIBRARY=%PB_TCL%\share\tk8.4
set TIX_LIBRARY=%PB_TCL%\share\tix8.4

REM==========================================================================
REM Force off debug mode in PB
REM==========================================================================
set UGII_CHECKING_LEVEL=0

REM==========================================================================
REM Tcl DLL search path
REM==========================================================================
set PATH=%PB_TCL%\exe;%PATH%


REM==========================================================================
REM Start Post Builder
REM==========================================================================
"%PB_HOME%\app\post_builder.exe" "%*"


@endlocal

REM==========================================================================
REM Post Builder returns 0 as the result of a successful run, otherwise
REM it returns a non-zero value.
REM==========================================================================
if ERRORLEVEL 0 goto END
  pause

:END

