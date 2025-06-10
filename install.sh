set -e

#DISK="/dev/vda"
#DISK="/dev/sda"
DISK="/dev/nvme0n1"

# BIOS
#printf "o\nn\n\n\n\n+8G\nn\n\n\n\n\nt\n1\n82\na\n2\nw\n" | fdisk $DISK  
#mkswap "$DISK""1"
#mkfs.ext4 "$DISK""2"
#mount "$DISK""2" /mnt
#swapon "$DISK""1"

# UEFI
printf "g\nn\n1\n\n+256M\nt\n1\nn\n2\n\n+16G\nt\n2\n19\nn\n3\n\n\nw\n" | fdisk $DISK  
mkfs.vfat -F 32 "$DISK""1"
mount "$DISK""1" /mnt/boot
mkfs.ext4 "$DISK""3"
mkswap "$DISK""2"
swapon "$DISK""2"
mount "$DISK""3" /mnt

pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
cd /mnt
wget https://raw.githubusercontent.com/Connor-McCartney/deploy-arch-dwm/refs/heads/main/after-chroot.sh
cat after-chroot.sh | arch-chroot /mnt
#reboot
