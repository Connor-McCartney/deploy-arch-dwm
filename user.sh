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
cd /home/connor/suckless/slstatus && sudo make clean install
rm -rf /tmp/deploy-arch-dwm

# dotfiles
nvim -v # just running some type of application will create the .local directory
cd /tmp
wget https://raw.githubusercontent.com/Connor-McCartney/deploy-arch-dwm/refs/heads/main/dotfiles/install.sh
chmod +x install.sh
./install.sh

# wallpaper
paru -S --noconfirm feh

# compositor (for transparency, rounded corners, other effects)
paru -S --noconfirm picom-ftlabs-git

#printf "exec dwm" > /home/connor/.xinitrc # technically not needed, it's just to be able to run 'startx'

# add these if using a monitor
# xrandr --output LVDS-1 --off
# xrandr --output VGA-1 --auto
printf "feh --bg-scale /home/connor/.wallpapers/kuromi.png\npicom -b\nslstatus &\nexec dwm" > /home/connor/.xsession # needed to boot with lightdm
chmod +x /home/connor/.xsession

paru -S --noconfirm  noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-hack-nerd ttf-comic-mono-git
paru -S --noconfirm brave-bin discord obsidian flameshot sagemath thunar kitty google-chrome

# just for audio effect ('play file.mp3')
paru -S --noconfirm sox twolame

# python setup
paru -S --noconfirm python-pip
python -m venv /home/connor/.p
/home/connor/.p/bin/python -m pip install --upgrade pip
/home/connor/.p/bin/pip install pycryptodome gmpy2 pwntools

# sage libs
/usr/bin/sage --pip install pycryptodome pwntools --break-system-packages

# LSPs
paru -S --noconfirm clang pyright lua-language-server asm-lsp  # rust gets installed as a dependancy

# Packer
# https://github.com/wbthomason/packer.nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
# nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'


rm /home/connor/user.sh
