#!/bin/bash 

# Show line numbers as green text 
export PS4=$'\e[1;32m+ ${LINENO}: \e[0m'

# Enable tracing mode (show the code being executed)) 
set -x

# Function to handle errors in the script 
handle_error() {
  echo -e "\033[0;31mAn error occurred in line $1. Continuing with the rest of the script.\033[0m"
}

# Set up error handling with the trap command
trap 'handle_error $LINENO' ERR

# Create a function for updating the system and removing unnecessary packages
update_system() {
  sudo apt update -y
  sudo apt upgrade -y
  sudo flatpak update -y
  sudo apt autoremove -y
  sudo apt autoclean -y
  sudo apt autopurge -y
  sudo apt install -f -y
}
#update the system
update_system

# --- OEM Kernel Selection ---
# Present a menu of available OEM kernels for the user to choose from.
echo "Searching for available OEM kernels..."
mapfile -t oem_kernels < <(apt-cache search linux-oem-2 | grep -o 'linux-oem-2[0-9.]\+[a-z]\?' | sort -u)

if [ ${#oem_kernels[@]} -eq 0 ]; then
    echo "No OEM kernels found. Please ensure your repositories are configured correctly."
    # Set kernvar to a dummy value so the script doesn't fail on the package list
    kernvar="linux-generic" 
else
    echo "Please select which OEM kernel to install:"
    select kern_choice in "${oem_kernels[@]}" "Skip"; do
        if [[ -n "$kern_choice" ]]; then
            if [[ "$kern_choice" == "Skip" ]]; then
                echo "Skipping OEM kernel installation."
                kernvar="" # Set to empty if skipping
                break
            fi
            kernvar="$kern_choice"
            echo "Selected kernel: $kernvar"
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done
fi


# --- Nvidia Driver Management ---
# Purge any existing Nvidia drivers to ensure a clean installation.
echo "Purging existing Nvidia drivers..."
sudo apt purge nvidia* -y

# Install repositories
# Flatpak is a software utility for software deployment, package management, and application virtualization
sudo add-apt-repository -y ppa:flatpak/stable
# Nvidia Graphics Drivers
sudo add-apt-repository -y ppa:graphics-drivers
# Papirus Icon Theme
sudo add-apt-repository -y ppa:papirus/papirus

#update the system
update_system

# --- Nvidia Driver Selection ---
# Find and list available proprietary Nvidia drivers for user selection.
echo "Searching for available Nvidia drivers..."
mapfile -t nvidia_drivers < <(ubuntu-drivers devices | grep 'driver\s*:\s*nvidia-driver' | grep -v 'open' | awk '{print $3}' | sort -u)

if [ ${#nvidia_drivers[@]} -eq 0 ]; then
    echo "No proprietary Nvidia drivers found. You might want to check your hardware or repository configuration."
    echo "Skipping Nvidia driver installation."
else
    echo "Please select which Nvidia driver to install:"
    select driver_choice in "${nvidia_drivers[@]}" "Skip"; do
        if [[ -n "$driver_choice" ]]; then
            if [[ "$driver_choice" == "Skip" ]]; then
                echo "Skipping Nvidia driver installation."
                break
            fi
            echo "Selected driver: $driver_choice"
            install_package "$driver_choice"
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done
fi

# Function to install a package and check its status
install_package() {
  local package=$1
  sudo apt install -y "$package"
  if [ $? -ne 0 ]; then
    echo "An error occurred during the installation of $package."
    exit 1
  fi
}

# Function to install a Flatpak and check its status
install_flatpak() {
  local flatpak=$1
  sudo flatpak install -y "$flatpak"
  if [ $? -ne 0 ]; then
    echo "An error occurred during the installation of $flatpak."
    exit 1
  fi
}

# List of packages to install
packages=(
  "$kernvar"
  "nemo-image-converter"
  "nemo-media-columns"
  "openssh-server"
  "virt-manager"
  "resolvconf"
  "wireguard"
  "wireguard-tools"
  "btop"
  "git"
  "wget"
  "curl"
  "papirus-icon-theme"
  "gnome-console"
)

# Install Packages
for package in "${packages[@]}"; do
  install_package "$package"
done

echo "Packages installed successfully."

# Update the system
update_system

# List of Flatpaks to install
flatpaks=(
  "com.github.tchx84.Flatseal"
  "net.davidotek.pupgui2"
  "tv.plex.PlexDesktop"
  "org.gimp.GIMP"
  "org.remmina.Remmina"
)

# Install Flatpaks
for flatpak in "${flatpaks[@]}"; do
  install_flatpak "$flatpak"
done

echo "Flatpaks installed successfully."

# Download and install the latest version of Steam from the official website
wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
sudo dpkg -i steam.deb
sudo apt install -f -y
rm steam.deb

# Update the system
update_system

exit 0