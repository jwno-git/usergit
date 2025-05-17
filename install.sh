#!/bin/bash

set -e

echo "=== Adding Repo's==="
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

echo "=== Updating APT package list ==="
sudo apt update

echo "=== Installing APT packages s Enter to begin ==="
read

sudo apt install -y \
  android-sdk-platform-tools \
  bluez \
  blueman \
  brightnessctl \
  btop \
  cava \
  chafa \
  cliphist \
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
  slurp \
  snapper \
  spotify-client \
  swappy \
  tar \
  terminator \
  waybar \
  wget \
  wlogout \
  wofi \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal-wlr \

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

flatpak override org.mozilla.firefox --user --filesystem=home

echo "=== Building Hypr Packages ==="

mkdir -p /$HOME/.src
git clone https://github.com/zsh-users/zsh-completions ~/.zsh/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
git clone https://github.com/hyprwm/hyprutils ~/.src/hyprutils
git clone https://github.com/hyprwm/hyprlang ~/.src/hyprlang
git clone https://github.com/hyprwm/hyprwayland-scanner ~/.src/hyprwayland-scanner
git clone https://github.com/hyprwm/hyprgraphics ~/.src/hyprgraphics
git clone https://github.com/hyprwm/hyprlock ~/.src/hyprlock
git clone https://github.com/hyprwm/hyprpaper ~/.src/hyprpaper
git clone https://github.com/hyprwm/hyprpicker ~/.src/hyprpicker

cd ~/.src/hyprutils/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

echo "=== Built Hyprutils, on to Hyprlang ==="

cd ~/.src/hyprlang/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprlang -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build

echo "=== Built Hyprlang, on to Hyprwayland-scanner ==="

cd ~/.src/hyprwayland-scanner/
cmake -DCMAKE_INSTALL_PREFIX=/usr -B build
cmake --build build -j `nproc`
sudo cmake --install build

echo "=== Built Hyprwayland-scanner, on to Hyprgraphics ==="

cd ~/.src/hyprgraphics/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

echo "=== Built Hyprgraphics, on to Hyprlock ==="

cd ~/.src/hyprlock/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
cmake --build ./build --config Release --target hyprlock -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install build

echo "=== Built Hyprlocks, on to Hyprpaper ==="

cd ~/.src/hyprpaper/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprpaper -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build

echo "=== Built Hyprpaper, on to Hyprpicker ==="

cd ~/.src/hyprpicker/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprpicker -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build

cd

echo "All packages and overrides applied successfully. Press Enter to continue."
read

echo "=== Setting up Systemd-Boot ==="

## Install systemd-boot and unattended-upgrades
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
  shim-signed \
  ifupdown \
  nano \
  os-prober \
  zutty

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
cd /$HOME/.icons/
tar -xf /$HOME/.icons/BreezeX-RosePine-Linux.tar.xz
tar -xf /$HOME/.icons/Nordic-Folders.tar.xz
tar -xf /$HOME/.icons/rose-pine-hyprcursor.tar
cd /$HOME/.themes
tar -xf /$HOME/.themes/Nordic-darker.tar.xz
cd

echo "=== Cleaning Up ==="
mv /$HOME/.icons/BreezeX-RosePine-Linux ~/.icons/RosePine
sudo cp -r /$HOME/.icons/RosePine /usr/share/icons/
sudo cp -r /$HOME/.icons/rose-pine-hyprcursor /usr/share/icons/
sudo cp -r /$HOME/.icons/Nordic-Darker /usr/share/icons/
sudo rm -rf /$HOME/.icons/Nordic
sudo cp -r /$HOME/.themes/Nordic-darker /usr/share/themes/
sudo rm -rf /$HOME/.themes/Nordic-darker-v40
sudo cp /$HOME/Documents/wofissh.desktop /usr/share/applications/
sudo cp /$HOME/Documents/spotify.desktop /usr/share/applications/
sudo cp -r /$HOME/root/.config /root/
sudo cp -r /$HOME/root/.zshrc /root/
sudo cp -r /$HOME/root/debianlogo.png /root/

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

