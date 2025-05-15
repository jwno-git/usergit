#!/bin/bash

# Script to install essential applications via apt

set -e

echo "Updating package list..."
sudo apt update

echo "Installing user applications..."
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

echo "Installing development packages with --no-install-recommends..."
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

echo "All packages installed successfully."
