set -e

cd /tmp
git clone https://github.com/Connor-McCartney/deploy-arch-dwm


mv /tmp/deploy-arch-dwm/dotfiles/.config/kitty /home/connor/.config
mv /tmp/deploy-arch-dwm/dotfiles/.config/konsolerc /home/connor/.config
mv /tmp/deploy-arch-dwm/dotfiles/.local/share/konsole /home/connor/.local/share
mv /tmp/deploy-arch-dwm/dotfiles/.config/nvim /home/connor/.config
mv /tmp/deploy-arch-dwm/dotfiles/.config/picom /home/connor/.config
mv /tmp/deploy-arch-dwm/dotfiles/.bashrc /home/connor
mv /tmp/deploy-arch-dwm/dotfiles/pyproject.toml /home/connor
mv /tmp/deploy-arch-dwm/dotfiles/.wallpapers /home/connor
mv /tmp/deploy-arch-dwm/dotfiles/.switcher.sh /home/connor
mv /tmp/deploy-arch-dwm/dotfiles/.xsage.sh /home/connor
chmod +x /home/connor/.switcher.sh

rm -rf /tmp/deploy-arch-dwm
