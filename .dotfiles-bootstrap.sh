# Silence git clone warnings until $HOME/.gitconfig exists
sudo git config --system init.defaultBranch master

# Clone ssh dotfiles first to enable ssh multiplexing, and vcsh dotfiles for subsequent vcsh repo configuration
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-ssh.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-vcsh.git &

# Wait for bootstrap dotfiles to clone
wait

# Clone dotfiles
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-alacritty.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-alsa.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-ardour.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-autorandr.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-btm.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-btop.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-cava.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-chromium.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-code.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-cursor.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-dnsmasq.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-dunst.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-feh.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-gimp.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-git.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-gnuplot.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-gtk.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-htop.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-i3.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-jobber.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-ksnip.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-ly.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-mime.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-nano.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-nativefier.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-pcmanfm.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-picom.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-pulseaudio.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-qjackctl.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-qt5ct.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-ranger.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-scripts.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-tmux.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-x11.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-xava.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-xdg.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-zathura.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-zsh.git &

# Wait for dotfiles cloning to finish
wait

# Cache zsh plugins
zsh -c "source $HOME/.zshrc"

# Ignore pcmanfm changes
vcsh dotfiles-pcmanfm ls-files $HOME | \
  xargs -n 1 vcsh dotfiles-pcmanfm update-index --assume-unchanged

# Ignore wal-generated gtk files
vcsh dotfiles-gtk ls-files $HOME | \
  xargs -n 1 vcsh dotfiles-gtk update-index --assume-unchanged

# Start an x server for applications that require one to function (e.g. wal)
export DISPLAY=:2
sudo vncserver $DISPLAY \
  -autokill \
  -SecurityTypes none

# Generate wal cache for all wallpapers
find $HOME/.local/share/wallpapers |
  grep -v bak | \
  xargs -n 1 -P0 $HOME/.config/scripts/wal.sh 2>/dev/null

# Install vs code wal extension
yarn --cwd /opt/vscode-wal install-extension

# Terminate x server
sudo vncserver -kill $DISPLAY || true
