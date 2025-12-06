# Desktop Fresh Install Script

A comprehensive Bash script designed to automate the post-installation setup of a Linux desktop (specifically tailored for Linux Mint/Ubuntu-based systems). This script handles system updates, driver installations, and software provisioning to get your machine ready for daily use and gaming.

## Features

*   **System Maintenance**: Performs full system updates, upgrades, and cleanup (autoremove/autoclean).
*   **Kernel Management**: Scans for and allows interactive selection of available OEM kernels.
*   **Nvidia Drivers**: Automatically detects available proprietary Nvidia drivers and offers an interactive menu for installation.
*   **Flatpak Integration**: Installs Flatpak, adds the Flathub repository, and installs selected Flatpak applications.
*   **Software Installation**: Installs a curated list of essential system utilities and applications.
*   **Gaming Ready**: Automatically downloads and installs the latest version of Steam.

## Prerequisites

*   A Debian-based Linux distribution (tested on Linux Mint/Ubuntu).
*   `sudo` privileges.
*   Internet connection.

## Usage

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Idowza/Desktop-Fresh-Install.git
    cd Desktop-Fresh-Install
    ```

2.  **Make the script executable:**
    ```bash
    chmod +x fresh.sh
    ```

3.  **Run the script:**
    ```bash
    ./fresh.sh
    ```

Follow the on-screen prompts to select your preferred kernel and graphics drivers.

## Installed Software

### System Utilities & Tools
*   **btop**: Resource monitor
*   **git**, **wget**, **curl**: Essential command-line tools
*   **openssh-server**: SSH connectivity
*   **virt-manager**: Virtual machine management
*   **wireguard** & **wireguard-tools**: VPN support
*   **nemo-image-converter** & **nemo-media-columns**: File manager enhancements
*   **gnome-console**: Terminal emulator
*   **papirus-icon-theme**: Modern icon theme

### Flatpak Applications
*   **Flatseal**: Manage Flatpak permissions
*   **ProtonUp-Qt** (pupgui2): Manage Proton-GE for Steam
*   **Plex Desktop**: Media player
*   **GIMP**: Image editor
*   **Remmina**: Remote desktop client

### Other
*   **Steam**: Valve's digital distribution platform

## Customization

You can easily customize the software to be installed by editing the `packages` and `flatpaks` arrays inside the `fresh.sh` script.

## Disclaimer

This script performs system-level changes, including kernel and driver installations. Please review the code before running it on your system. Use at your own risk.