set -e

cd /tmp
git clone https://github.com/Connor-McCartney/deploy-arch-dwm


mv /tmp/deploy-arch-dwm/dotfiles/.config/alacritty /home/connor/.config
mv /tmp/deploy-arch-dwm/dotfiles/.tmux.conf /home/connor


rm -rf /tmp/deploy-arch-dwm
