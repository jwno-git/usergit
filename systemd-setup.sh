#!/bin/bash

set -e

### 1. Get UUID
echo "Getting UUID for /dev/nvme0n1p2..."
UUID=$(blkid -s UUID -o value /dev/nvme0n1p2)
echo "Found UUID: $UUID"

### 2. Install systemd-boot and unattended-upgrades
echo "Installing systemd-boot and unattended-upgrades..."
sudo apt install -y systemd-boot systemd-boot-efi unattended-upgrades

echo "Installing systemd-boot to EFI..."
sudo bootctl --path=/boot/efi install
