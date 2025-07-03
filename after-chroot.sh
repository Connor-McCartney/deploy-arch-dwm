set -e

DISK="/dev/vda"
#DISK="/dev/sda"


ln -sf /usr/share/zoneinfo/Australia/Brisbane /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "arch" > /etc/hostname

pacman -S --noconfirm xorg xorg-xinit xclip xautomation xorgproto
pacman -S --noconfirm networkmanager neovim sudo base-devel os-prober grub vlc htop git wget ripgrep fzf bat fd
#pacman -S --noconfirm alsa-utils # adjust with alsamixer, arrowkeys and m toggles mute
pacman -S --noconfirm pulseaudio pavucontrol
systemctl enable NetworkManager

# disable screen saving
# https://wiki.archlinux.org/title/Display_Power_Management_Signaling
printf 'Section "Extensions"\n\tOption "DPMS" "false"\nEndSection\n' > /etc/X11/xorg.conf.d/10-extensions.conf
printf 'Section "ServerFlags"\n\tOption "BlankTime" "0"\nEndSection\n' > /etc/X11/xorg.conf.d/10-serverflags.conf

# non-LUKS
#printf "GRUB_TIMEOUT=1\nGRUB_DISTRIBUTOR=\"Arch\"\nGRUB_CMDLINE_LINUX=\"loglevel=1 nowatchdog nvme_load=YES fsck.mode=skip modprobe.blacklist=iTCO_wdt\"\n" > /etc/default/grub
##grub-install $DISK # BIOS
#pacman -S efibootmgr --noconfirm; grub-install --target=x86_64-efi --efi-directory=/boot # UEFI
#grub-mkconfig -o /boot/grub/grub.cfg

# LUKS UEFI
printf "MODULES=()\nBINARIES=()\nFILES=()\nHOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)\n" > /etc/mkinitcpio.conf
pacman -S --noconfirm thin-provisioning-tools lvm2
mkinitcpio -p linux
pacman -S efibootmgr --noconfirm; grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
uuid=$(blkid -s UUID -o value /dev/nvme0n1p2)
printf "GRUB_TIMEOUT=1\nGRUB_DISTRIBUTOR=\"Arch\"\nGRUB_CMDLINE_LINUX=\"loglevel=1 nowatchdog cryptdevice=UUID="$uuid":cryptlvm root = /dev/vg1/root nvme_load=YES fsck.mode=skip modprobe.blacklist=iTCO_wdt\"\n" > /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg


# lightdm auto-login
pacman -S --noconfirm lightdm
systemctl enable lightdm
groupadd -r autologin
cd /usr/share
mkdir xsessions
cd xsessions
printf "[Desktop Entry]\nExec=/usr/bin/startx\n" > dwm.desktop
sed -i 's/'#autologin-user='/'autologin-user=connor'/g' /etc/lightdm/lightdm.conf
sed -i 's/'#autologin-session='/'autologin-session=dwm'/g' /etc/lightdm/lightdm.conf


useradd -m -G users,wheel,audio,video,autologin -s /bin/bash connor
printf " \n \n" | passwd
printf " \n \n" | passwd connor
echo -e "root ALL=(ALL:ALL) ALL\n%wheel ALL=(ALL:ALL) NOPASSWD: ALL\n@includedir /etc/sudoers.d" > /etc/sudoers

cd /home/connor
wget https://raw.githubusercontent.com/Connor-McCartney/deploy-arch-dwm/refs/heads/main/user.sh
chmod +x user.sh
sudo -u connor bash user.sh

rm /after-chroot.sh
