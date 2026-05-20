swapoff /dev/*
umount /dev/*

#target="uefi-luks-hyperv"
target="bios-thinkpad"
#target="uefi-luks-HP"

set -e

if [[ $target = "uefi-luks-hyperv" ]]; then
    printf "g\nn\n1\n\n+256M\nt\n1\nn\n2\n\n\nw\n" | fdisk /dev/sda
    cryptsetup luksFormat /dev/sda2
    cryptsetup open /dev/sda2 cryptlvm
    pvcreate /dev/mapper/cryptlvm
    vgcreate vg1 /dev/mapper/cryptlvm
    lvcreate -L 8G vg1 -n swap
    lvcreate -l 100%FREE vg1 -n root
    mkfs.vfat -F 32 /dev/sda1
    mkfs.ext4 /dev/vg1/root
    mkswap /dev/vg1/swap
    mount /dev/vg1/root /mnt
    mkdir /mnt/boot
    mount /dev/sda1 /mnt/boot
    swapon /dev/vg1/swap
fi


if [[ $target = "uefi-luks-HP" ]]; then
    printf "g\nn\n1\n\n+256M\nt\n1\nn\n2\n\n\nw\n" | fdisk /dev/nvme0n1
    cryptsetup luksFormat /dev/nvme0n1p2
    cryptsetup open /dev/nvme0n1p2 cryptlvm
    pvcreate /dev/mapper/cryptlvm
    vgcreate vg1 /dev/mapper/cryptlvm
    lvcreate -L 8G vg1 -n swap
    lvcreate -l 100%FREE vg1 -n root
    mkfs.vfat -F 32 /dev/nvme0n1p1
    mkfs.ext4 /dev/vg1/root
    mkswap /dev/vg1/swap
    mount /dev/vg1/root /mnt
    mkdir /mnt/boot
    mount /dev/nvme0n1p1 /mnt/boot
    swapon /dev/vg1/swap
fi

if [[ $target = "bios-thinkpad" ]]; then
    printf "o\nn\n\n\n\n+8G\nn\n\n\n\n\nt\n1\n82\na\n2\nw\n" | fdisk /dev/sda  
    mkswap /dev/sda1
    mkfs.ext4 /dev/sda2
    mount /dev/sda2 /mnt
    swapon /dev/sda1
fi



pacstrap /mnt base linux
genfstab -U /mnt >> /mnt/etc/fstab
cd /mnt
curl https://raw.githubusercontent.com/Connor-McCartney/deploy-arch-dwm/refs/heads/main/minimal-after-chroot.sh -o minimal-after-chroot.sh
cat minimal-after-chroot.sh | arch-chroot /mnt
#reboot
