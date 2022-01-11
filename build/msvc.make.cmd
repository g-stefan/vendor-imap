@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

set ACTION=%1
if "%1" == "" set ACTION=make

echo - %BUILD_PROJECT% ^> %ACTION%

goto cmdXDefined
:cmdX
%*
if errorlevel 1 goto cmdXError
goto :eof
:cmdXError
echo "Error: %ACTION%"
exit 1
:cmdXDefined

if not "%ACTION%" == "make" goto :eof

call :cmdX xyo-cc --mode=%ACTION% --source-has-archive imap

if not exist output\ mkdir output
if not exist temp\ mkdir temp

set INCLUDE=%XYO_PATH_REPOSITORY%\include;%INCLUDE%
set LIB=%XYO_PATH_REPOSITORY%\lib;%LIB%
set WORKSPACE_PATH=%CD%
set WORKSPACE_PATH_OUTPUT=%WORKSPACE_PATH%\output
set WORKSPACE_PATH_BUILD=%WORKSPACE_PATH%\temp

if exist %WORKSPACE_PATH_BUILD%\build.done.flag goto :eof

copy /Y /B build\source\src.osdep.nt.env_nt.c source\src\osdep\nt\env_nt.c
copy /Y /B build\source\src.osdep.nt.yunchan.c source\src\osdep\nt\yunchan.c

pushd source

nmake /f makefile.w2k
if errorlevel 1 goto makeError

if not exist ..\output\lib\ mkdir ..\output\lib
copy /Y /B c-client\cclient.lib ..\output\lib\cclient.lib
copy /Y /B c-client\cclient.lib ..\output\lib\cclient.static.lib

if not exist ..\output\bin\ mkdir ..\output\bin
copy /Y /B imapd\imapd.exe ..\output\bin\imapd.exe
copy /Y /B ipopd\ipop2d.exe ..\output\bin\ipop2d.exe
copy /Y /B ipopd\ipop3d.exe ..\output\bin\ipop3d.exe
copy /Y /B mailutil\mailutil.exe ..\output\bin\mailutil.exe

if not exist ..\output\include\ mkdir ..\output\include
if not exist ..\output\include\c-client mkdir ..\output\include\c-client
xcopy /Y /S /E "c-client\*.h" ..\output\include\c-client

nmake /f makefile.w2k clean
if errorlevel 1 goto makeError

goto buildDone

:makeError
popd
echo "Error: make"
exit 1

:buildDone
popd
echo done > %WORKSPACE_PATH_BUILD%\build.done.flag

