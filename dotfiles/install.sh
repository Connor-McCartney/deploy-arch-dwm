set -e

cd /tmp
git clone https://github.com/Connor-McCartney/deploy-arch-dwm


mv /tmp/deploy-arch-dwm/dotfiles/.config/kitty/kitty.conf /home/connor/.config/kitty
mv /tmp/deploy-arch-dwm/dotfiles/.config/konsolerc /home/connor/.config
mv /tmp/deploy-arch-dwm/dotfiles/.local/share/konsole /home/connor/.local/share
mv /tmp/deploy-arch-dwm/dotfiles/.config/nvim /home/connor/.config
mv /tmp/deploy-arch-dwm/dotfiles/.config/picom /home/connor/.config
mv /tmp/deploy-arch-dwm/dotfiles/.bashrc /home/connor
mv /tmp/deploy-arch-dwm/dotfiles/.fdignore /home/connor
mv /tmp/deploy-arch-dwm/dotfiles/pyproject.toml /home/connor
mv /tmp/deploy-arch-dwm/dotfiles/.wallpapers /home/connor

mv /tmp/deploy-arch-dwm/dotfiles/.switcher.sh /home/connor
mv /tmp/deploy-arch-dwm/dotfiles/.xsage.sh /home/connor
mv /tmp/deploy-arch-dwm/dotfiles/.vim_quit.sh /home/connor
mv /tmp/deploy-arch-dwm/dotfiles/.vim_saver.sh /home/connor
mv /tmp/deploy-arch-dwm/dotfiles/.upvol.sh /home/connor
mv /tmp/deploy-arch-dwm/dotfiles/.downvol.sh /home/connor


mv /tmp/deploy-arch-dwm/dotfiles/.volume_change.mp3 /home/connor

chmod +x /home/connor/.switcher.sh /home/connor/.vim_quit.sh /home/connor/.vim_saver.sh /home/connor/.xsage.sh /home/connor/.upvol.sh /home/connor/.downvol.sh

rm -rf /tmp/deploy-arch-dwm
