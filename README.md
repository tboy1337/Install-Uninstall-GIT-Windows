# Install-Uninstall-GIT-Windows

## Features

- **Automated Git Installation**
  - Downloads Git directly from the official Git for Windows repository
  - Configures Git with sensible defaults using an INI configuration file
  - Performs silent installation with no user interaction required
  - Easy version updating via environmental variable

- **Thorough Git Uninstallation**
  - Detects Git installations in multiple standard locations
  - Closes running Git processes before uninstallation
  - Performs complete cleanup of remaining files
  - Handles multiple Git installations

## Requirements

- 64-bit Windows operating system (64-bit for installation only)
- Administrative privileges
- Internet connection (for installation only)

## Usage

### Installing Git

1. Right-click on `install_git.cmd`
2. Select "Run as administrator"
3. Wait for the installation to complete

The script will:
- Create a temporary directory
- Download the Git installer
- Create a configuration file
- Install Git silently
- Clean up temporary files

### Uninstalling Git

1. Right-click on `uninstall_git.cmd`
2. Select "Run as administrator"
3. Wait for the uninstallation to complete

The script will:
- Check for Git installations in common locations
- Close any running Git processes
- Uninstall Git from all found locations
- Remove remaining files and directories

## Default Installation Settings

The installation script configures Git with the following default settings:
- Main as the default branch
- Command line Git integration
- OpenSSH for SSH operations
- OpenSSL for HTTPS transport
- Windows-style line endings (CRLF)
- Enabled credential manager
- Enabled filesystem cache
- Disabled symlinks
- Disabled filesystem monitor

You can manually download `Git-2.47.0-64-bit.exe` and record the parameters to a file using `/SAVEINF="filename"` if you want to change the default options set in the installer but are unsure of the parameters you want.

Example for saving selected options to a file during an interactive run started from the command-line:

```
Git-2.47.0-64-bit.exe /SAVEINF=git_options.ini
```

## Troubleshooting

### Installation Issues
- Ensure you have administrative privileges
- Check your internet connection
- Verify that the temporary directory is accessible
- Make sure no antivirus is blocking the download

### Uninstallation Issues
- Ensure you have administrative privileges
- Close any applications using Git
- If manual cleanup is required, delete Git directories manually
- Check the Windows Event Viewer for detailed error messages

## License

This project is open source and available under the MIT License.

## Contributing

Feel free to open issues or submit pull requests with improvements.
