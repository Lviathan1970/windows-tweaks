@echo off

echo Running %~n0...

cd /d "%~dp0"

if "%1"=="ok" goto SKIP_ELEVATE
echo call :Elevate "%0" ok
call :Elevate "%0" ok
exit
:SKIP_ELEVATE

goto ElevateEnd

:Elevate
	set COMMAND=%*
	ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs" 
	ECHO UAC.ShellExecute "cmd", "/c %COMMAND%", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs" 
	"%temp%\OEgetPrivileges.vbs"
goto :eof

:ElevateEnd

REM ================================================================

REM misc tmp dirs
rmdir /s /q "%SystemDrive%\Config.Msi" 2>nul >nul
rmdir /s /q "%SystemDrive%\NVIDIA" 2>nul >nul
rmdir /s /q "%SystemDrive%\Intel" 2>nul >nul
rmdir /s /q "%SystemDrive%\_acestream_cache_" 2>nul >nul
REM rmdir /s /q "%ProgramFiles%\NVIDIA Corporation\Installer2"

REM fix: chrome didn't shutdown correctly
del "%LocalAppData%\Google\*.tmp" /s 2>nul >nul

REM common location for Chome's downloaded files
del "%UserProfile%\Downloads\*.torrent" 2>nul
del "%UserProfile%\Documents\*.torrent" 2>nul

REM hidden files
del /a:- "%UserProfile%\Desktop\desktop.ini" 2>nul
del /a:- "%UserProfile%\Documents\desktop.ini" 2>nul
del /a:- "%UserProfile%\Downloads\desktop.ini" 2>nul
del /a:- "%ProgramFiles%\desktop.ini" 2>nul
del /a:- "%ProgramFiles(x86)%\desktop.ini" 2>nul

REM PowerISO WinPE image (~1.5GB)
rmdir /s /q "%AppData%\PowerISO\PE Files" 2>nul >nul

REM IntelliJ crash dump (~1GB)
del "%UserProfile%\java_error_in_idea.hprof" 2>nul

REM Android SDK cleanup
REM rmdir /s /q "%UserProfile%\.gradle\caches" 2>nul >nul
REM rmdir /s /q "%UserProfile%\.gradle\daemon" 2>nul >nul
REM remove all (inc. old ones) gradle wrapper dists:
REM rmdir /s /q "%UserProfile%\.gradle\wrapper" 2>nul >nul

REM Genymotion logs
del "%UserProfile%\genymotion-logs-*.zip" 2>nul

rmdir /s /q "%AppData%\PyCmd\tmp" 2>nul >nul

REM Malware cleanup
REM Task data: "cmd.exe" /c REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /f /v Yuriy /t REG_SZ /d "explorer.exe http://exinariuminix.info"
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v %UserName% /f 2>nul >nul
reg delete HKEY_CURRENT_USER\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run /v %UserName% /f 2>nul >nul
