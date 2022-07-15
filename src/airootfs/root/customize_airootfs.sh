#!/usr/bin/env bash

set -e -u

# Enable Parallel Downloads
sed -i -e 's|#ParallelDownloads.*|ParallelDownloads = 6|g' /etc/pacman.conf
sed -i -e '/#\[testing\]/Q' /etc/pacman.conf

# Enable Chaotic AUR
pacman-key --init
pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036

#--------------------------------------------------------------

# Set zsh as default shell for new user
sed -i -e 's#SHELL=.*#SHELL=/bin/zsh#g' /etc/default/useradd

#--------------------------------------------------------------

# Copy ConfigFiles  Into Root Dir #

rdir="/root/.config"
sdir="/etc/skel"
if [[ ! -d "$rdir" ]]; then
	mkdir "$rdir"
fi

rconfig=(alacritty bspwm geany gtk-3.0 Kvantum neofetch qt5ct ranger Thunar xfce4)

for cfg in "${rconfig[@]}"; do
	if [[ -e "$sdir/.config/$cfg" ]]; then
		cp -rf "$sdir"/.config/"$cfg" "$rdir"
	fi
done

rcfg=('.oh-my-zsh' '.gtkrc-2.0' '.vim_runtime' '.vimrc' '.zshrc')
for cfile in "${rcfg[@]}"; do
	if [[ -e "$sdir/$cfile" ]]; then
		cp -rf "$sdir"/"$cfile" /root
	fi
done

#--------------------------------------------------------------
