#!/bin/bash

set -e

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

echo "=== Opening Snapper config in Vim ==="
sudo nvim /etc/snapper/configs/root
