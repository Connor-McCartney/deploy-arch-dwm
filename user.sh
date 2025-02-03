set -e

# Paru
cd /tmp
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si --noconfirm

# suckless
cd /tmp
git clone https://github.com/Connor-McCartney/deploy-arch-dwm
mv /tmp/deploy-arch-dwm/suckless /home/connor
cd /home/connor/suckless/dwm && sudo make clean install
cd /home/connor/suckless/dmenu && sudo make clean install
rm -rf /tmp/deploy-arch-dwm

# dotfiles
cd /tmp
wget https://raw.githubusercontent.com/Connor-McCartney/deploy-arch-dwm/refs/heads/main/dotfiles/install.sh
chmod +x install.sh
./install.sh

#printf "exec dwm" > /home/connor/.xinitrc # technically not needed, it's just to be able to run 'startx'
printf "exec dwm" > /home/connor/.xsession # needed to boot with lightdm
chmod +x /home/connor/.xsession

paru -S --noconfirm  noto-fonts noto-fonts-cjk noto-fonts-emoji
paru -S --noconfirm google-chrome onlyoffice-bin discord obsidian flameshot alacritty tmux sagemath

# wallpaper
paru -S --noconfirm feh
feh --bg-scale /home/connor/.wallpapers/1920x1080-dark.jpg

cd /home/connor
mkdir Documents t

rm /home/connor/user.sh
