rem
@echo on
@setlocal

"%cd%\bin\wish80.exe" "%cd%\POSTBUILD\post_builder.tcl"

@endlocal

REM==========================================================================
REM Post Builder returns 0 as the result of a successful run, otherwise
REM it returns a non-zero value.
REM==========================================================================
if ERRORLEVEL 0 goto END
  pause

:END