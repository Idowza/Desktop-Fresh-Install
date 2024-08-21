#!/bin/bash

# Show line numbers as green text
export PS4=$'\e[1;32m+ ${LINENO}: \e[0m'

# Enable tracing mode (show the code being executed))
set -x

# Function to handle errors
handle_error() {
  echo -e "\033[0;31mAn error occurred in line $1. Continuing with the rest of the script.\033[0m"
}

# Set up error handling
trap 'handle_error $LINENO' ERR

# Create a function for updating the system
update_system() {
  sudo apt update -y
  sudo apt upgrade -y
  sudo flatpak update -y
  sudo apt autoremove -y
  sudo apt autoclean -y
  sudo apt autopurge -y
  sudo apt install -f -y
}

# Set User Variables
# kernvar is the variable for the OEM kernel
read -p $'\e[1;33mPlease enter which OEM kernel to install (e.g. linux-oem-22.04d):\e[0m ' kernvar

#update
update_system

# Git, wget, curl
sudo apt install -y \
# git is a free and open source distributed version control system
 git \
# wget is a free utility for non-interactive download of files from the web
 wget \
# curl is a command line tool and library for transferring data with URLs
 curl

# Download and install the latest version of Steam
wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
sudo dpkg -i steam.deb
sudo apt install -f -y
rm steam.deb

# Update
update_system

# Purge Nvidia drivers
sudo apt purge nvidia* -y

# Install repositories
# Flatpak
sudo add-apt-repository -y ppa:flatpak/stable
# Retroarch
sudo add-apt-repository -y ppa:libretro/stable
# Nvidia
sudo add-apt-repository -y ppa:graphics-drivers
# Papirus Icons
sudo add-apt-repository -y ppa:papirus/papirus

# Update
update_system

# Install Packages
sudo apt install -y \
#kernvar is the variable for the OEM kernel
 $kernvar \
# retroarch is a frontend for emulators, game engines, and media players
 retroarch \
# papirus-icon-theme is a free and open source icon theme for Linux
 papirus-icon-theme \
# nemo-image-converter is a nemo extension to mass resize or rotate images
 nemo-image-converter \
# nemo-media-columns is a nemo extension to display media information
 nemo-media-columns \
# pavucontrol is a simple GTK based volume control tool
 pavucontrol \
# openssh-server is a free implementation of the SSH protocol
 openssh-server \
# virt-manager is a desktop user interface for managing virtual machines
 virt-manager \
# resolvconf is a set of scripts to manage DNS information
 resolvconf \
# wireguard is a fast, modern, and secure VPN tunnel
 wireguard \
# wireguard-tools is a set of tools for configuring and using WireGuard
 wireguard-tools \
# inkscape is a professional vector graphics editor
 inkscape \
# btop is a resource monitor that shows usage and stats for processor, memory, disks, network and processes
 btop

# Update
update_system

# Install Flatpaks
sudo flatpak install -y \
# Flatseal is a graphical utility to manage Flatpak permissions
 com.github.tchx84.Flatseal \
# pupgui2 is a GUI for managing Steam Proton compatibility installations
 net.davidotek.pupgui2 \
# PlexDesktop is a desktop client for the Plex media server
 tv.plex.PlexDesktop \
# GIMP is a free and open-source raster graphics editor
 org.gimp.GIMP

# Update
update_system

exit 0
