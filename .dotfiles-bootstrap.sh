# Silence git clone warnings until $HOME/.gitconfig exists
sudo git config --system init.defaultBranch master

# Clone ssh dotfiles first to enable ssh multiplexing
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-ssh.git

# Clone dotfiles
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-alacritty.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-alsa.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-autorandr.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-bottom.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-btop.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-cava.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-chromium.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-code.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-dnsmasq.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-dunst.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-feh.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-gimp.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-git.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-gtk.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-htop.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-i3.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-jobber.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-ksnip.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-mime.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-nano.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-nativefier.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-pcmanfm.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-picom.git &
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-pulseaudio.git &
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

# Install tmux plugin manager
mkdir -p $HOME/.tmux/plugins/tpm >/dev/null 2>&1
git clone --depth 1 https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm &

# Install zsh plugin manager
git clone https://github.com/jandamm/zgenom.git $HOME/.zgenom &

# Wait for plugin managers to install
wait

# Cache tmux plugins
zsh -c $HOME/.tmux/plugins/tpm/bin/install_plugins &

# Cache zsh plugins
zsh -c "source $HOME/.zshrc" &

# Wait for zsh and tmux caching to finish
wait

# Install tmux plugin dependencies
sudo apt-get install -qq python3-libtmux

# Ignore pcmanfm changes
vcsh dotfiles-pcmanfm ls-files $HOME | \
  xargs -n 1 vcsh dotfiles-pcmanfm update-index --assume-unchanged

# Ignore wal-generated gtk files
vcsh dotfiles-gtk ls-files $HOME | \
  xargs -n 1 vcsh dotfiles-gtk update-index --assume-unchanged

# Start an x server for applications that require one to function (e.g. wal)
export DISPLAY=:2
vncserver $DISPLAY \
  -autokill \
  -SecurityTypes none \
  -xstartup /usr/local/bin/i3

# Generate wal cache for all wallpapers
find $HOME/.local/share/wallpapers |
  grep -v bak | \
  xargs -n 1 -P0 $HOME/.config/scripts/wal.sh 2>/dev/null

# Install vs code wal extension
yarn --cwd /opt/vscode-wal install-extension

# Terminate x server
vncserver -kill $DISPLAY
