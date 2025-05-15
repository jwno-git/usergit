### remove GRUB (dangerous if mistaken!)
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

### Remove GRUB boot entry from EFI
echo "Current EFI Boot Entries:"
sudo efibootmgr
echo "Enter Boot ID of GRUB to delete (e.g. 0000):"
read -r BOOT_ID
sudo efibootmgr -b "$BOOT_ID" -B


### Auto-copy future kernels
echo "Creating postinst hook to auto-copy future kernels to EFI..."

sudo tee /etc/kernel/postinst.d/zz-systemd-boot-copy > /dev/null <<'EOF'
#!/bin/sh
set -e
cp /boot/vmlinuz-* /boot/efi/
cp /boot/initrd.img-* /boot/efi/
EOF

sudo chmod +x /etc/kernel/postinst.d/zz-systemd-boot-copy

### 11. Limit old kernel retention
echo "Limiting retained kernels to 2..."
sudo tee /etc/apt/apt.conf.d/01autoremove-kernels > /dev/null <<EOF
APT::AutoRemove::Keep-Kernels "2";
EOF

echo "Conversion to systemd-boot complete."
