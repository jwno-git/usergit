#!/bin/bash

set -e

echo "=== Adding Repo's==="
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

echo "=== Updating APT package list ==="
sudo apt update

echo "=== Installing APT packages ==="
sudo apt install -y \
  android-sdk-platform-tools \
  bluez \
  blueman \
  brightnessctl \
  btop \
  cava \
  chafa \
  cliphist \
  curl \
  dunst \
  fonts-font-awesome \
  fonts-terminus \
  foot \
  grim \
  hyprland \
  imagemagick \
  lf \
  lxpolkit \
  network-manager-applet \
  openssh-client \
  pavucontrol \
  pulseaudio \ 
  pulseaudio-module-bluetooth \
  psmisc \
  python3-pip \
  slurp \
  snapper \
  spotify-client \
  swappy \
  tar \
  terminator \
  unzip \
  waybar \
  wget \
  wlogout \
  wofi \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal-wlr \
  zip

echo "=== Installing APT dev packages (no recommends) ==="
sudo apt install -y --no-install-recommends \
  build-essential \
  cmake \
  g++ \
  libpam0g-dev \
  libcairo2-dev \
  libdrm-dev \
  libgbm-dev \
  libgl1-mesa-dev \
  libinput-dev \
  libjpeg-dev \
  libmagic-dev \
  libpango1.0-dev \
  libpugixml-dev \
  libspng-dev \
  libsdbus-c++-dev \
  libwayland-dev \
  libwebp-dev \
  libxkbcommon-dev \
  make \
  ninja-build \
  pkg-config \
  wayland-protocols

echo "=== Ensuring Flatpak and Flathub are set up ==="
sudo apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "=== Installing Flatpak applications ==="
flatpak install -y flathub \
  com.obsproject.Studio \
  org.kde.kdenlive \
  net.cozic.joplin_desktop \
  org.libreoffice.LibreOffice \
  org.gnome.eog \
  com.bitwarden.desktop \
  org.mozilla.firefox \
  org.gimp.GIMP \
  io.mpv.Mpv \
  org.gnome.Calculator \
  org.standardnotes.standardnotes \

echo "=== Creating Flatpak menu entries ==="
sudo ln -s /var/lib/flatpak/exports/share/applications/com.obsproject.Studio.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/net.cozic.joplin_desktop.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/org.kde.kdenlive.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/org.gnome.eog.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/com.bitwarden.desktop.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/org.mozilla.firefox.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/org.gimp.GIMP.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/io.mpv.Mpv.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/org.gnome.Calculator.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/org.standardnotes.standardnotes.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/org.libreoffice.LibreOffice.calc.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/org.libreoffice.LibreOffice.writer.desktop /usr/share/applications/

echo "=== Setting global Flatpak overrides ==="
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=$HOME/.icons
sudo flatpak override --env=GTK_THEME=Nordic-darker
sudo flatpak override --env=XCURSOR_THEME=RosePine
sudo flatpak override --env=XCURSOR_SIZE=32

echo "=== Setting app-specific override for OBS Studio ==="
flatpak override com.obsproject.Studio --user \
  --filesystem=home \
  --socket=wayland \
  --socket=pulseaudio \
  --filesystem=xdg-run/pipewire-0 \
  --talk-name=org.freedesktop.portal.Desktop \
  --env=QT_QPA_PLATFORM=wayland

echo "All packages and overrides applied successfully."

echo "=== Setting up Systemd-Boot ==="
echo "Getting UUID for /dev/nvme0n1p2..."
UUID=$(blkid -s UUID -o value /dev/nvme0n1p2)
echo "Found UUID: $UUID"

### 2. Install systemd-boot and unattended-upgrades
echo "Installing systemd-boot and unattended-upgrades..."
sudo apt install -y systemd-boot systemd-boot-efi unattended-upgrades

echo "Installing systemd-boot to EFI..."
sudo bootctl --path=/boot/efi install

echo "=== Removing Grub ==="
echo "Ready to remove GRUB. Press enter to continue, or Ctrl+C to cancel."
read

sudo apt purge --allow-remove-essential -y \
  grub-common \
  grub-efi-amd64 \
  grub-efi-amd64-bin \
  grub-efi-amd64-signed \
  grub-efi-amd64-unsigned \
  grub2-common \
  shim-signed

sudo apt autoremove --purge -y

echo "Current EFI Boot Entries:"
sudo efibootmgr
echo "Enter Boot ID of GRUB to delete (e.g. 0000):"
read -r BOOT_ID
sudo efibootmgr -b "$BOOT_ID" -B

echo "Limiting retained kernels to 2..."
sudo tee /etc/apt/apt.conf.d/01autoremove-kernels > /dev/null <<EOF
APT::AutoRemove::Keep-Kernels "2";
EOF

echo "Conversion to systemd-boot complete."

echo "=== Unpacking ==="
tar -xf ~/.icons/BreezeX-RosePine-Linux.tar.xz
tar -xf ~/.icons/Nordic-Folders.tar.xz
tar -xf ~/.icons/rose-pine-hyprcursor.tar
tar -xf ~/.themes/Nordic-darker.tar.xz

echo "=== Cleaning Up ==="
mv ~/.icons/BreezeX-RosePine-Linux ~/.icons/RosePine
sudo cp -r ~/.icons/RosePine /usr/share/icons/
sudo cp -r ~/.icons/rose-pine-hyprcursor /usr/share/icons/
sudo cp -r ~/.icons/Nordic-Darker /usr/share/icons/
sudo rm -rf ~/.icons/Nordic
sudo cp -r ~/.themes/Nordic-darker /usr/share/themes/
sudo rm -rf ~/.themes/Nordic-darker-v40
sudo cp ~/Documents/wofissh.desktop /usr/share/applications/
sudo cp ~/Documents/spotify.desktop /usr/share/applications/
sudo cp -r ~/root/* /root/

echo "=== Setting up BTRFS ==="
echo "=== Unmounting /.snapshots if mounted ==="
sudo umount /.snapshots 2>/dev/null || echo "Already unmounted or not mounted."

echo "=== Deleting old /.snapshots directory ==="
sudo rm -rf /.snapshots

echo "=== Creating Snapper config for root ==="
sudo snapper -c root create-config /

echo "=== Deleting existing Btrfs subvolume at /.snapshots ==="
sudo btrfs subvolume delete /.snapshots 2>/dev/null || echo "No subvolume to delete."

echo "=== Recreating /.snapshots directory ==="
sudo mkdir /.snapshots

echo "=== Remounting all entries in /etc/fstab ==="
sudo mount -a

echo "=== Setting permissions and snapshot properties ==="
sudo chmod 750 /.snapshots
sudo btrfs property set -ts /.snapshots ro false

echo "=== Press Enter to edit Snapper Config ==="
read

echo "=== Opening Snapper config in Vim ==="
sudo nvim /etc/snapper/configs/root

