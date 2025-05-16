#!/bin/bash

set -e

echo "=== Updating APT package list ==="
sudo apt update

echo "=== Installing APT packages ==="
sudo apt install -y \
  android-sdk-platform-tools \
  brightnessctl \
  btop \
  chafa \
  cliphist \
  curl \
  dunst \
  fonts-font-awesome \
  fonts-terminus \
  foot \
  grim \
  hyprland \
  lf \
  lxpolkit \
  network-manager-applet \
  openssh-client \
  pipewire \
  pipewire-alsa \
  pipewire-pulse \
  psmisc \
  python3-pip \
  slurp \
  snapper \
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
  blueman \
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
  com.saivert.pwvucontrol \
  org.mozilla.firefox \
  org.gimp.GIMP \
  net.ankiweb.Anki \
  io.mpv.Mpv \
  org.gnome.Calculator \
  org.standardnotes.standardnotes

echo "=== Creating Flatpak menu entries ==="
sudo ln -s /var/lib/flatpak/exports/share/applications/com.obsproject.Studio.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/net.cozic.joplin_desktop.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/org.kde.kdenlive.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/org.gnome.eog.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/com.bitwarden.desktop.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/com.saivert.pwvucontrol.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/org.mozilla.firefox.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/org.gimp.GIMP.desktop /usr/share/applications/
sudo ln -s /var/lib/flatpak/exports/share/applications/net.ankiweb.Anki.desktop /usr/share/applications/
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
