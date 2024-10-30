@echo off
setlocal enabledelayedexpansion

:: Set variables for easy updating
set "GIT_VERSION=2.47.0"
set "DOWNLOAD_URL=https://github.com/git-for-windows/git/releases/download/v%GIT_VERSION%.windows.1/Git-%GIT_VERSION%-64-bit.exe"
set "INSTALLER_NAME=Git-%GIT_VERSION%-64-bit.exe"

set "TEMP_DIR=%TEMP%\GitInstall_%RANDOM%"
set "DOWNLOAD_TASK=DownloadTask_%RANDOM%"

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please right-click and select "Run as administrator".
    timeout /t 5 /nobreak
    exit /b 4
)

mkdir "%TEMP_DIR%"
if %errorlevel% neq 0 (
    echo Failed to create temporary Git install directory.
    timeout /t 5 /nobreak
    exit /b 3
)

cd /d "%TEMP_DIR%"
if %errorlevel% neq 0 (
    echo Failed to change to temporary Git install directory.
    timeout /t 5 /nobreak
    exit /b 2
)

where curl >nul 2>&1
if %errorlevel% equ 0 (
    echo Attempting to download %INSTALLER_NAME% with curl...
    curl -o "%INSTALLER_NAME%" -L "%DOWNLOAD_URL%" >nul 2>&1
    if %errorlevel% equ 0 goto :verify_download
    echo Curl download failed, trying PowerShell...
)

where powershell >nul 2>&1
if %errorlevel% equ 0 (
    echo Attempting to download %INSTALLER_NAME% with PowerShell...
    start /wait powershell -WindowStyle Hidden -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -OutFile '%INSTALLER_NAME%' -Uri '%DOWNLOAD_URL%'"
    if %errorlevel% equ 0 goto :verify_download
    echo PowerShell download failed, trying bitsadmin...
)

echo Attempting to download %INSTALLER_NAME% with bitsadmin...
(
echo bitsadmin /transfer %DOWNLOAD_TASK% /download /priority FOREGROUND /DYNAMIC "%DOWNLOAD_URL%" "%TEMP_DIR%\%INSTALLER_NAME%"
) > "set_task.cmd" 2>nul

if %errorlevel% neq 0 (
    echo Failed to write to temporary directory.
    goto :giterror
)

start /wait schtasks /create /tn "RunAsSystemTask" /tr "cmd /c %TEMP_DIR%\set_task.cmd" /sc once /st 23:59 /ru SYSTEM >nul
if %errorlevel% neq 0 (
    echo All download methods failed.
    goto :giterror
)

start /wait schtasks /run /tn "RunAsSystemTask" >nul
if %errorlevel% neq 0 (
    echo All download methods failed.
    start /wait schtasks /delete /tn "RunAsSystemTask" /f >nul
    if %errorlevel% neq 0 (
        echo Failed to delete scheduled task, please delete "RunAsSystemTask" manually.
    )
    goto :giterror
)

:waitloop
if not exist "%TEMP_DIR%\%INSTALLER_NAME%" (
    timeout /t 2 /nobreak >nul
    goto waitloop
)

timeout /t 2 /nobreak >nul

start /wait schtasks /delete /tn "RunAsSystemTask" /f >nul
if %errorlevel% neq 0 (
    echo Failed to delete scheduled task, please delete "RunAsSystemTask" manually.
)

:verify_download
if not exist "%TEMP_DIR%\%INSTALLER_NAME%" (
    echo Download appears to have failed - installer not found.
    goto :giterror
)

echo Creating temporary git_options.ini file...
(
echo [Setup]
echo Lang=default
echo Dir=%ProgramFiles%\Git
echo Group=Git
echo NoIcons=0
echo SetupType=default
echo Components=ext,ext\shellhere,ext\guihere,gitlfs,assoc,assoc_sh
echo Tasks=
echo EditorOption=VIM
echo CustomEditorPath=
echo DefaultBranchOption=main
echo PathOption=Cmd
echo SSHOption=OpenSSH
echo TortoiseOption=false
echo CURLOption=OpenSSL
echo CRLFOption=CRLFAlways
echo BashTerminalOption=ConHost
echo GitPullBehaviorOption=Merge
echo UseCredentialManager=Enabled
echo PerformanceTweaksFSCache=Enabled
echo EnableSymlinks=Disabled
echo EnableFSMonitor=Disabled
) > "git_options.ini" 2>nul

if %errorlevel% neq 0 (
    echo Failed to create temporary git_options.ini file.
    goto :giterror
)

echo Installing %INSTALLER_NAME%...
start /wait %INSTALLER_NAME% /VERYSILENT /NORESTART /NOCANCEL /LOADINF="git_options.ini"
if %errorlevel% neq 0 (
    echo Failed to install Git.
    goto :giterror
)

echo Git installation completed successfully.
goto :gitcleanup

:giterror
echo An error occurred during the Git installation process.
call :gitcleanup
exit /b 1

:gitcleanup
echo Cleaning up...
timeout /t 2 /nobreak >nul
cd /d "%TEMP%"
if %errorlevel% neq 0 (
    echo Failed to change to temporary directory for Git install cleanup.
)
rd /s /q "%TEMP_DIR%"
if %errorlevel% neq 0 (
    echo Failed to remove temporary Git install directory. Please delete "%TEMP_DIR%" manually.
) else (
    echo Clean up successful.
)
timeout /t 5 /nobreak

exit /b 0
