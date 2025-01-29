set -e

# Paru
cd /tmp
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si --noconfirm

# suckless
mkdir /home/connor/suckless
cd /home/connor/suckless
git clone https://git.suckless.org/dwm
git clone https://git.suckless.org/st
git clone https://git.suckless.org/dmenu
cd /home/connor/suckless/dwm && sudo make clean install
cd /home/connor/suckless/st && sudo make clean install
cd /home/connor/suckless/dmenu && sudo make clean install
#printf "exec dwm" > /home/connor/.xinitrc # technically not needed, it's just to be able to run 'startx'
printf "exec dwm" > /home/connor/.xsession # needed to boot with lightdm
chmod +x /home/connor/.xsession

rm /home/connor/user.sh
