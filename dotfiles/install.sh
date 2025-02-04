set -e

cd /tmp
git clone https://github.com/Connor-McCartney/deploy-arch-dwm


mv /tmp/deploy-arch-dwm/dotfiles/.config/alacritty /home/connor/.config
mv /tmp/deploy-arch-dwm/dotfiles/.bashrc /home/connor
mv /tmp/deploy-arch-dwm/dotfiles/.wallpapers /home/connor
mv /tmp/deploy-arch-dwm/dotfiles/.switcher.sh /home/connor
chmod +x /home/connor/.switcher.sh

rm -rf /tmp/deploy-arch-dwm
