@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1
if %errorlevel% equ 0 (
    echo This script is intended for per-user installation. Please run without administrator privileges.
    timeout /t 5 /nobreak
    exit /b 1
)

where winget >nul 2>&1
if %errorlevel% neq 0 (
    echo winget is not available on this system. Please install App Installer from Microsoft Store.
    timeout /t 5 /nobreak
    exit /b 2
)

where git >nul 2>&1
if %errorlevel% equ 0 (
    echo Git is already installed and in PATH.
    timeout /t 5 /nobreak
    exit /b 3
)

echo Installing Git using winget...
winget install --id Git.Git --source winget --scope user --silent --accept-package-agreements --accept-source-agreements
if %errorlevel% neq 0 (
    echo Failed to install Git via winget.
    timeout /t 5 /nobreak
    exit /b 4
)

echo Git installation completed. Configuring Git settings...

call :refresh_env

where git >nul 2>&1
if %errorlevel% neq 0 (
    echo Git was installed but is not yet available in PATH. You may need to restart your command prompt.
    echo Manual configuration will be required.
    timeout /t 5 /nobreak
    exit /b 5
)

echo Configuring Git settings...

:: Core settings
git config --global init.defaultBranch main
if %errorlevel% neq 0 (
    echo Failed to set init.defaultBranch.  Error code: %errorlevel%
)

git config --global core.eol crlf
if %errorlevel% neq 0 (
    echo Failed to set core.eol.  Error code: %errorlevel%
)

git config --global core.autocrlf true
if %errorlevel% neq 0 (
    echo Failed to set core.autocrlf.  Error code: %errorlevel%
)

git config --global core.editor "vim"
if %errorlevel% neq 0 (
    echo Failed to set core.editor.  Error code: %errorlevel%
)

:: Credential manager
git config --global credential.helper manager
if %errorlevel% neq 0 (
    echo Failed to set credential.helper.  Error code: %errorlevel%
)

:: Performance tweaks
git config --global core.preloadindex true
if %errorlevel% neq 0 (
    echo Failed to set core.preloadindex.  Error code: %errorlevel%
)

git config --global core.fscache true
if %errorlevel% neq 0 (
    echo Failed to set core.fscache.  Error code: %errorlevel%
)

:: Push behavior
git config --global pull.rebase false
if %errorlevel% neq 0 (
    echo Failed to set pull.rebase.  Error code: %errorlevel%
)

:: Enable long paths on Windows
git config --global core.longpaths true
if %errorlevel% neq 0 (
    echo Failed to set core.longpaths.  Error code: %errorlevel%
)

echo Git installation and configuration completed successfully.

timeout /t 5 /nobreak
exit /b 0

:refresh_env
:: Refresh environment variables without requiring a restart
for /f "usebackq tokens=2,*" %%A in (`reg query HKCU\Environment /v PATH 2^>nul`) do set "UserPath=%%B"
for /f "usebackq tokens=2,*" %%A in (`reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH 2^>nul`) do set "SystemPath=%%B"
set "PATH=%UserPath%;%SystemPath%"
exit /b
