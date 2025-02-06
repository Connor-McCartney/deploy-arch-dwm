set -e

cd /home/connor
mkdir Documents t

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

# wallpaper
paru -S --noconfirm feh

#printf "exec dwm" > /home/connor/.xinitrc # technically not needed, it's just to be able to run 'startx'
printf "feh --bg-scale /home/connor/.wallpapers/kuromi.png\nxcompmgr &\nexec dwm" > /home/connor/.xsession # needed to boot with lightdm
chmod +x /home/connor/.xsession

paru -S --noconfirm  noto-fonts noto-fonts-cjk noto-fonts-emoji
paru -S --noconfirm google-chrome discord obsidian flameshot alacritty sagemath

# python setup
paru -S --noconfirm python-pip
python -m venv /home/connor/.p
/home/connor/.p/bin/python -m pip install --upgrade pip
/home/connor/.p/bin/pip install pycryptodome gmpy2 pwntools

# LSPs
paru -S --noconfirm clang pyright lua-language-server

# Packer
# https://github.com/wbthomason/packer.nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

rm /home/connor/user.sh
