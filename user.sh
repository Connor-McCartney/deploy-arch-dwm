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
rm -rf /tmp/deploy-arch-dwm

cd /home/connor/suckless/dwm && sudo make clean install
cd /home/connor/suckless/dmenu && sudo make clean install
#cd /home/connor/suckless/st && sudo make clean install

#printf "exec dwm" > /home/connor/.xinitrc # technically not needed, it's just to be able to run 'startx'
printf "exec dwm" > /home/connor/.xsession # needed to boot with lightdm
chmod +x /home/connor/.xsession

# Packer
# https://github.com/wbthomason/packer.nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

paru -S --noconfirm  noto-fonts noto-fonts-cjk noto-fonts-emoji
paru -S --noconfirm google-chrome onlyoffice-bin discord obsidian flameshot alacritty tmux

rm /home/connor/user.sh
