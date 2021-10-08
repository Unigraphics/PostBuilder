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
REM
REM v12.01 MP1
REM ----------
REM Mar-01-2018 gsl  - Adopted Tcl8.6
REM #########################################################################


REM==========================================================================
REM PB_HOME is the only env var referenced in the Post Builder source codes.
REM It should be set based on the Post Builder installation.
REM==========================================================================
set base=%1
set base_dir=%base:"=%
set PB_HOME=%base_dir%\postbuild


REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
REM Configure "base_dir" & "PB_HOME" to run Post Builder off this file -

REM - Set proper UGII_BASE_DIR
:: set base_dir=D:\Program Files\UGS\NX 11.0

REM - Set proper PB_HOME
:: set PB_HOME=D:\Post_Builder\v12.01\postbuild

REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

REM ==> DO NOT change anything below this line! <==

set UGII_ROOT_DIR=%base_dir%\ugii



set UGII_BASE_DIR=%base_dir%

echo UGII_BASE_DIR: %UGII_BASE_DIR%
echo PB_HOME:       %PB_HOME%


REM==========================================================================
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

set TCL_LIBRARY=%PB_TCL%\share\tcl8.6
set TK_LIBRARY=%PB_TCL%\share\tk8.6
set TIX_LIBRARY=%PB_TCL%\share\tix8.4.3

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
"%UGII_BASE_DIR%\postbuild\app\post_builder.exe" "%*"


@endlocal

REM==========================================================================
REM Post Builder returns 0 as the result of a successful run, otherwise
REM it returns a non-zero value.
REM==========================================================================
if ERRORLEVEL 0 goto END
  pause

:END

