# Clone large dotfiles and those that require post install
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-tmux.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-x11.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-zsh.git

# Cache zsh plugins
zsh -c "source $HOME/.zshrc" &

# Cache tmux plugins
zsh -c $HOME/.tmux/plugins/tpm/bin/install_plugins &

# Wait for zsh and tmux caching to finish
wait

# Clone static dotfiles
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-alacritty.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-alsa.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-autorandr.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-code.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-compton.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-crt.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-dnsmasq.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-dunst.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-git.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-gtk.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-i3.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-jobber.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-mime.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-mpd.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-musikcube.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-ncmpcpp.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-pcmanfm.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-pulseaudio.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-ranger.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-scripts.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-ssh.git
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-xdg.git

# Ignore wal-generated gtk files
vcsh dotfiles-gtk ls-files $HOME | \
  xargs -n 1 vcsh dotfiles-gtk update-index --assume-unchanged

# Start an x server for applications that require one to function (wal, code)
export DISPLAY=:2
vncserver $DISPLAY \
  -autokill \
  -SecurityTypes none \
  -xstartup /usr/bin/i3

# Generate wal cache
zsh -c $HOME/.config/scripts/wal.sh

# Install code settings sync extension, clear extension download history, start code so extensions install, forcibly terminate code after extensions install (race condition).
code --install-extension Shan.code-settings-sync && \
  sed -i '/lastDownload/d' $HOME/.config/Code/User/syncLocalSettings.json && \
  code && sleep 90 && pkill -f code && \
  code && sleep 5 && pkill -f code && \
  vcsh dotfiles-code reset HEAD ~ && \
  vcsh dotfiles-code co ~

# Terminate x server
pkill -f vncserver
