set -e

# 1. BIOS
#DISK="/dev/vda"
#DISK="/dev/sda"
#printf "o\nn\n\n\n\n+8G\nn\n\n\n\n\nt\n1\n82\na\n2\nw\n" | fdisk $DISK  
#mkswap "$DISK""1"
#mkfs.ext4 "$DISK""2"
#mount "$DISK""2" /mnt
#swapon "$DISK""1"

# 2. UEFI
#DISK="/dev/nvme0n1"
#printf "g\nn\n1\n\n+256M\nt\n1\nn\n2\n\n+16G\nt\n2\n19\nn\n3\n\n\nw\n" | fdisk $DISK  
#mkfs.vfat -F 32 "$DISK""p1"
#mount "$DISK""p1" /mnt/boot
#mkfs.ext4 "$DISK""p3"
#mkswap "$DISK""p2"
#swapon "$DISK""p2"
#mount "$DISK""p3" /mnt

# 3. UEFI + LUKS
DISK="/dev/nvme0n1"
printf "g\nn\n1\n\n+256M\nt\n1\nn\n2\n\n\nw\n" | fdisk $DISK  
cryptsetup luksFormat "$DISK""p2"
cryptsetup open "$DISK""p2" cryptlvm
pvcreate /dev/mapper/cryptlvm
vgcreate vg1 /dev/mapper/cryptlvm
lvcreate -L 8G vg1 -n swap
lvcreate -l 100%FREE vg1 -n root
mkfs.vfat -F 32 "$DISK""p1"
mkdir /mnt/boot
mount "$DISK""p1" /mnt/boot
mkfs.ext4 /dev/vg1/root
mkswap /dev/vg1/swap
swapon /dev/vg1/swap
mount /dev/vg1/root /mnt

pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
cd /mnt
wget https://raw.githubusercontent.com/Connor-McCartney/deploy-arch-dwm/refs/heads/main/after-chroot.sh
cat after-chroot.sh | arch-chroot /mnt
#reboot
