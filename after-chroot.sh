set -e

#DISK="/dev/sda"
DISK="/dev/vda"


ln -sf /usr/share/zoneinfo/Australia/Brisbane /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "arch" > /etc/hostname

pacman -S --noconfirm xorg xorg-xinit xclip
pacman -S --noconfirm networkmanager neovim sudo python-pip base-devel os-prober grub vlc htop git wget

systemctl enable NetworkManager

printf "GRUB_TIMEOUT=1\nGRUB_DISTRIBUTOR=\"Arch\"\nGRUB_CMDLINE_LINUX=\"loglevel=9 nowatchdog nvme_load=YES fsck.mode=skip modprobe.blacklist=iTCO_wdt\"\n" > /etc/default/grub
grub-install $DISK # BIOS
# grub-install --target=x86_64-efi --efi-directory=/boot # UEFI
grub-mkconfig -o /boot/grub/grub.cfg

# For my hard drive
printf "[defaults]\nntfs_defaults=uid=\$UID,gid=\$GID\n" > /etc/udisks2/mount_options.conf

# lightdm auto-login
pacman -S --noconfirm lightdm
groupadd -r autologin
cd /usr/share
mkdir xsessions
printf "[Desktop Entry]\nExec=/usr/bin/startx\n" > dwm.desktop
sed -i 's/'#autologin-user='/'autologin-user=connor'/g' /etc/lightdm/lightdm.conf


useradd -m -G users,wheel,audio,video,autologin -s /bin/bash connor
printf " \n \n" | passwd
printf " \n \n" | passwd connor
echo -e "root ALL=(ALL:ALL) ALL\n%wheel ALL=(ALL:ALL) NOPASSWD: ALL\n@includedir /etc/sudoers.d" > /etc/sudoers

# suckless
mkdir /home/connor/suckless
cd /home/connor/suckless
git clone https://git.suckless.org/dwm
git clone https://git.suckless.org/st
git clone https://git.suckless.org/dmenu
cd /home/connor/suckless/dwm && sudo make clean install
cd /home/connor/suckless/st && sudo make clean install
cd /home/connor/suckless/dmenu && sudo make clean install
printf "exec dwm" > /home/connor/.xinitrc

cd /home/connor
wget https://raw.githubusercontent.com/Connor-McCartney/deploy-arch-dwm/refs/heads/main/user.sh
chmod +x user.sh
sudo -u connor bash user.sh
