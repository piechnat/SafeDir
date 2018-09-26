@echo off & goto :INITIALIZATION & rem # encoding = IBM852

:MAIN_PROC
call :READ_DATA || (
  net session 1>nul 2>&1
  if not !errorlevel! EQU 0 (
    set tmp_file="%temp%\AutoElevate%random%%random%%random%.vbs"
    echo CreateObject("Shell.Application"^).ShellExecute Wscript.Arguments(0^),"","","runas" > !tmp_file!
    start /wait "" !tmp_file! "%selfPath%"
    del /f !tmp_file!
    exit
  ) else (
    call :BUILD_SAFEDIR
    call :READ_DATA || :EXIT_MSG "odmowa dost©pu"
  )
)
set usrPass=
cls
if !isOpened! EQU 0 (
  set haslo=hasˆo
  if "!passwd!"=="1234" set haslo="!passwd!"
  echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿
  echo ³ Bezpieczna lokalizacja ³ ZAMKNI¨TA ³
  echo ³                        ÀÄÄÄÄÄÄÄÄÄÄÄÙ
  set /p usrPass=À Wpisz !haslo!, aby otworzy†: 
  echo:
  if "!usrPass!"=="!passwd!" (
    mklink /j "!linkDir!" "!sfDr[3]!" 1>nul 2>&1
    explorer.exe "!linkDir!"
    (echo 1!passwd!)>"%sfDr[5]%"
  ) else (
    echo - Hasˆo niepoprawne^^!
    timeout 3 1>nul
  )
) else (
  echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿
  echo ³ Bezpieczna lokalizacja ³  OTWARTA  ³
  echo ³                        ÀÄÄÄÄÄÄÄÄÄÄÄÙ
  echo ³ Wci˜nij [ENTER], aby zamkn¥†, lub 
  set /p usrPass=À wprowad« nowe hasˆo: 
  echo:
  set true=0
  if "!usrPass!"=="!passwd!" set true=1
  if "!usrPass!"=="" set true=1
  if !true! EQU 1 (
    rd "!linkDir!" 1>nul 2>&1
    (echo 0!passwd!)>"%sfDr[5]%"
    exit
  ) else (
    set /p cnfPass=- Wpisz ponownie, aby zmieni† hasˆo: 
    echo:
    if "!usrPass!"=="!cnfPass!" (
      (echo 1!usrPass!)>"%sfDr[5]%"
      echo - Hasˆo zostaˆo zmienione.
    ) else (
      echo - Wprowadzone frazy nie s¥ identyczne^^!
    )
    timeout 3 1>nul
  )
)
goto :MAIN_PROC

rem ---------------------------------- ¿ Ù Ú À ³ Ä Â Á ´ Ã Å -----------------------------------

:INITIALIZATION
color 0A & chcp 852 1>nul
title SafeDir (c) 2018 Mateusz Piechnat
call :PRINT "Trwa uruchamianie..."
call :PRINT .
set charTable= !"#$%%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
setlocal EnableDelayedExpansion EnableExtensions || call :EXIT_MSG "wˆ¥czenie rozszerzeä byˆo niemo¾liwe"
call :IS_NTFS || call :EXIT_MSG "skrypt wymaga systemu plik¢w NTFS"
call :PRINT .
set /a selfTck=4992
set selfPath=%~dpf0
set firstArg=%~dpf1
set linkDir=%~dpn0
call :GET_USER_ID
call :PRINT .
set userSID=%RESULT%
set systemSID=S-1-5-18
set everyoneSID=S-1-1-0
call :GET_NAME "16,16,16,18,17,20,16,17,13,16,16,16,16,13,16,16,16,16,13,35,16,16,16,13,16,16,16,16,16,16,16,16,16,16,20,22"
call :PRINT .
set CLSID={%RESULT%}
set sfDr[0]=%~d0\.
call :GET_NAME "51,89,83,84,69,77,0,54,79,76,85,77,69,0,41,78,70,79,82,77,65,84,73,79,78"
call :PRINT .
set sfDr[1]=%~d0\%RESULT%
set sfDr[2]=%sfDr[1]%\{%userSID%}.%CLSID%
call :GET_NAME "77,78,84"
call :PRINT .
if not %selfTck% EQU %~z0 goto :EOF
set sfDr[3]=%sfDr[2]%\%RESULT%
call :GET_NAME "68,69,83,75,84,79,80,14,73,78,73"
call :PRINT .
set sfDr[4]=%sfDr[1]%\%RESULT%
call :GET_NAME "68,65,84"
call :PRINT .
set sfDr[5]=%sfDr[3]%:%RESULT%
echo:
goto :MAIN_PROC

:READ_DATA
set passwd=
(set /p passwd=<"%sfDr[5]%") 1>nul 2>&1
if "!passwd!"=="" exit /b -1
set /a isOpened=!passwd:~0,1!
set passwd=!passwd:~1!
exit /b 0

:BUILD_SAFEDIR
call :PRINT "Przygotowywanie bezpiecznej lokalizacji..."
for /l %%g in (0,1,3) do (
  call :PRINT .
  if %%g GTR 0 md "!sfDr[%%g]!"
  takeown /f "!sfDr[%%g]!"
  if %%g GTR 0 icacls "!sfDr[%%g]!" /reset /q
  icacls "!sfDr[%%g]!" /grant *%userSID%:(OI^)(CI^)F /grant *%systemSID%:(OI^)(CI^)F /q
  icacls "!sfDr[%%g]!" /inheritance:r /q
) 1>nul 2>&1
if exist "%sfDr[3]%\" call :READ_DATA || (echo 01234)>"%sfDr[5]%"
echo: >"%sfDr[4]%"
( call :PRINT .
  takeown /f "!sfDr[4]!"
  icacls "!sfDr[4]!" /reset /q
  icacls "!sfDr[4]!" /grant *%everyoneSID%:F /q
  icacls "!sfDr[4]!" /inheritance:r /q
  attrib -r -s -h "!sfDr[4]!"
) 1>nul 2>&1
echo [.ShellClassInfo]>"%sfDr[4]%"
echo CLSID=%CLSID%>>"%sfDr[4]%"
for %%g in (1,2,4) do attrib +s +h "!sfDr[%%g]!" 1>nul 2>&1
for %%g in (2,1) do (
  call :PRINT .
  icacls "!sfDr[%%g]!" /setowner *%systemSID% /q
  icacls "!sfDr[%%g]!" /remove *%userSID% /q
) 1>nul 2>&1
exit /b 0

:PRINT
set /p tmp_var="%~1"<NUL
exit /b 0

:GET_NAME
set RESULT=
for %%g in (%~1) do set RESULT=!RESULT!!charTable:~%%g,1!
exit /b 0

:GET_USER_ID
set RESULT=%userdomain%.%username%
set /a len=0
for /f %%a in ('"wmic path win32_useraccount where name='%username%' get sid 2>&1"') do (
  set arr[!len!]=%%a
  set /a len=len+1
)
if %len% GEQ 2 if "%arr[0]%"=="SID" set RESULT=%arr[1]%
exit /b 0

:IS_NTFS
set /a len=0
for /f %%a in ('"wmic logicaldisk where caption='%~d0' get FileSystem 2>&1"') do (
  set arr[!len!]=%%a
  set /a len=len+1
)
if %len% GEQ 2 if "%arr[1]%"=="NTFS" exit /b 0
exit /b -1

:EXIT_MSG
echo: & echo Wyst¥piˆ bˆ¥d: & echo - %~1. & pause 1>nul
exit
