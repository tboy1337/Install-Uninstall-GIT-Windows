@echo off
setlocal enabledelayedexpansion

:: Array of possible Git installation locations
set "locations[0]=%ProgramFiles%\Git"
set "locations[1]=%SystemDrive%\Program Files (x64)\Git"
set "locations[2]=%ProgramFiles(x86)%\Git"
set "locations[3]=%SystemDrive%\Git"
set "locations[4]=%LOCALAPPDATA%\Programs\Git"

set "found_installations=0"

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please right-click and select "Run as administrator".
    timeout /t 5 /nobreak
    exit /b 8
)

echo Checking for Git installations...

for /L %%i in (0,1,4) do (
    if exist "!locations[%%i]!\unins*.exe" (
        set "uninstaller=!locations[%%i]!\unins*.exe"
        for %%f in ("!uninstaller!") do (
            set "found_uninstaller=%%f"
            set /a found_installations+=1
        )
    )
)

if %found_installations% equ 0 (
    echo No Git installations found in standard locations.
    echo This might be because Git is installed in a non-standard location.
    echo If you think Git is still installed, try to uninstall it through Control Panel or locate the installation folder and run the uninstaller manually.
    timeout /t 5 /nobreak
    exit /b 7
)

for /L %%i in (0,1,4) do (
    if exist "!locations[%%i]!\unins*.exe" (
        echo Found Git installation in !locations[%%i]!
        echo With uninstaller !found_uninstaller!
        echo Terminating running Git processes...
        taskkill /F /IM "bash.exe" >nul 2>nul
        taskkill /F /IM "putty.exe" >nul 2>nul
        taskkill /F /IM "puttytel.exe" >nul 2>nul
        taskkill /F /IM "puttygen.exe" >nul 2>nul
        taskkill /F /IM "pageant.exe" >nul 2>nul
        
        echo Uninstalling Git from !locations[%%i]!...
        start /wait "Uninstalling Git" "!found_uninstaller!" /SP- /VERYSILENT /SUPPRESSMSGBOXES /FORCECLOSEAPPLICATIONS
        
        if !errorlevel! neq 0 (
            echo Failed to uninstall Git from !locations[%%i]!
            set "uninstall_error=1"
        ) else (
            echo Successfully uninstalled Git from !locations[%%i]!
            
            echo Cleaning up remaining files in !locations[%%i]!...
            timeout /t 2 /nobreak >nul 2>nul
            
            rd /s /q "!locations[%%i]!" >nul 2>nul
            if !errorlevel! neq 0 (
                echo Warning: Could not remove remaining files in !locations[%%i]!
                set "cleanup_error=1"
            ) else (
                echo Successfully removed remaining files in !locations[%%i]!
            )
        )
    )
)

if defined uninstall_error (
    echo One or more Git uninstallations failed.
    timeout /t 5 /nobreak
    exit /b 5
) else if defined cleanup_error (
    echo Git was uninstalled but some cleanup operations failed.
    echo Please check the listed locations and remove remaining files manually.
    timeout /t 5 /nobreak
    exit /b 6
) else (
    echo All Git installations were successfully uninstalled and cleaned up.
    timeout /t 5 /nobreak
    exit /b 0
)
