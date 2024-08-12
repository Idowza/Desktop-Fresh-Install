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

#Set User Variables
read -p $'\e[1;33mPlease enter which OEM kernel to install (e.g. linux-oem-22.04d):\e[0m ' kernvar

#update
update_system

# Git, wget, curl
sudo apt install -y \
 git \
 wget \
 curl

# Download and install the latest version of Google Chrome
sudo apt install libu2f-udev
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt install -f -y
rm google-chrome-stable_current_amd64.deb

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
# Inkscape
sudo add-apt-repository -y ppa:inkscape.dev/stable

# Update
update_system

# Install Packages
sudo apt install -y \
 $kernvar \
 retroarch \
 papirus-icon-theme \
 nemo-image-converter \
 nemo-media-columns \
 pavucontrol \
 openssh-server \
 virt-manager \
 resolvconf \
 wireguard \
 wireguard-tools \
 inkscape

# Update
update_system

# Install Flatpaks
sudo flatpak install -y \
 com.github.tchx84.Flatseal \
 net.davidotek.pupgui2 \
 tv.plex.PlexDesktop \
 org.gimp.GIMP

# Update
update_system

exit 0
