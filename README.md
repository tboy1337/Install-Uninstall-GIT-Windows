
# Git Manager for Windows 🚀

![Git Logo](https://git-scm.com/images/logos/downloads/Git-Icon-1788C.png) <!-- Assuming a public Git logo URL; replace if needed -->

**Supercharge your Git experience on Windows with these handy scripts!** Whether you're setting up Git for the first time, keeping it fresh, or saying goodbye, we've got you covered. No more fumbling with installers – just run a script and boom! 💥

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Windows](https://img.shields.io/badge/Platform-Windows-blue.svg)]()

## 🌟 Features

- **Easy Installation**: Two ways to install Git – via Winget or direct download from GitHub.
- **Seamless Updates**: Keep Git up-to-date with a single command.
- **Clean Uninstall**: Remove Git completely from common installation paths (admin required).
- **User-Friendly**: Scripts handle checks, configurations, and cleanups automatically.
- **Custom Configurations**: Sets optimal Git settings for Windows, like CRLF handling and performance tweaks.

## 📋 Requirements

- Windows 10 or later
- PowerShell (for some download methods)
- Administrator privileges for uninstallation

## 🔧 Usage

Download the scripts and run them from Command Prompt or PowerShell. Make sure to run as a regular user unless specified.

### 1. Install Git via Winget
```cmd
install_git_winget.cmd
```
- Checks if Winget is available.
- Installs Git silently for the current user.
- Configures global Git settings (e.g., default branch to main, CRLF handling).

### 2. Install Git via Direct Download
```cmd
install_git.cmd
```
- Downloads the latest Git installer (v2.50.1 – update the script for newer versions).
- Installs to `%LOCALAPPDATA%\Programs\Git` with predefined options (Vim as editor, OpenSSH, etc.).
- Handles downloads via curl, PowerShell, or bitsadmin.

### 3. Update Git
```cmd
update_git.cmd
```
- Uses Git's built-in updater to fetch and install the latest version.
- Run as a regular user.

### 4. Uninstall Git
```cmd
uninstall_git.cmd
```
- **Requires Administrator privileges** (right-click and run as admin).
- Searches common paths like `%ProgramFiles%\Git`, `%LOCALAPPDATA%\Programs\Git`.
- Runs the uninstaller silently and cleans up remaining files.

## ⚙️ Configuration Details

During installation, the scripts set these global Git configs for a smooth Windows experience:
- Default branch: `main`
- Line endings: CRLF
- Editor: Vim
- Credential helper: manager
- Performance: FSCache and preloadindex enabled
- And more! Check the scripts for full details.

## 🤝 Contributing

Feel free to fork, improve, and submit pull requests! If you find bugs or have ideas, open an issue.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details.
