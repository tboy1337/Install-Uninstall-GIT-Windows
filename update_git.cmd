@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please right-click and select "Run as administrator".
    timeout /t 5 /nobreak
    exit /b 1
)

where git >nul 2>&1
if %errorlevel% neq 0 (
    echo Git is not installed or in PATH.
    timeout /t 5 /nobreak
    exit /b 2
)

echo Updating Git using built-in updater...
git update-git-for-windows
if %errorlevel% equ 0 (
    echo Git update completed successfully!
) else (
    echo Git update failed.  Error code: %errorlevel%
    timeout /t 5 /nobreak
    exit /b 3
)

timeout /t 5 /nobreak
exit /b 0
