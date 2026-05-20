set -e

#target="uefi-luks-hyperv"
target="bios-thinkpad"
#target="uefi-luks-HP"

if [[ $target = "uefi-luks-hyperv" ]]; then
    printf "MODULES=()\nBINARIES=()\nFILES=()\nHOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)\n" > /etc/mkinitcpio.conf
    pacman -S --noconfirm thin-provisioning-tools lvm2
    mkinitcpio -p linux
    pacman -S efibootmgr --noconfirm; grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    uuid=$(blkid -s UUID -o value /dev/sda2)
    printf "GRUB_TIMEOUT=1\nGRUB_DISTRIBUTOR=\"Artix\"\nGRUB_CMDLINE_LINUX=\"loglevel=1 nowatchdog cryptdevice=UUID="$uuid":cryptlvm root=/dev/vg1/root nvme_load=YES fsck.mode=skip modprobe.blacklist=iTCO_wdt\"\n" > /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
fi

if [[ $target = "uefi-luks-HP" ]]; then
    printf "MODULES=()\nBINARIES=()\nFILES=()\nHOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)\n" > /etc/mkinitcpio.conf
    pacman -S --noconfirm thin-provisioning-tools lvm2
    mkinitcpio -p linux
    pacman -S efibootmgr --noconfirm; grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    uuid=$(blkid -s UUID -o value /dev/nvme0n1p2)
    printf "GRUB_TIMEOUT=1\nGRUB_DISTRIBUTOR=\"Artix\"\nGRUB_CMDLINE_LINUX=\"loglevel=1 nowatchdog cryptdevice=UUID="$uuid":cryptlvm root=/dev/vg1/root nvme_load=YES fsck.mode=skip modprobe.blacklist=iTCO_wdt\"\n" > /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
fi


if [[ $target = "bios-thinkpad" ]]; then
    printf "GRUB_TIMEOUT=1\nGRUB_DISTRIBUTOR=\"Arch\"\nGRUB_CMDLINE_LINUX=\"loglevel=1 nowatchdog nvme_load=YES fsck.mode=skip modprobe.blacklist=iTCO_wdt\"\n" > /etc/default/grub
    grub-install /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg
fi


printf " \n \n" | passwd

echo "minimal install finished"
sudo -u connor bash user.sh

rm /after-chroot.sh
