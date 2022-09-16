#!/usr/bin/env bash

## Script to perform several important tasks before `makeExodiaISO` create filesystem image.

set -e -u

## -------------------------------------------------------------- ##

## Fix Initrd Generation in Installed System ##
cat > "/etc/mkinitcpio.d/linux.preset" <<- _EOF_
	# mkinitcpio preset file for the 'linux' package

	ALL_kver="/boot/vmlinuz-linux"
	ALL_config="/etc/mkinitcpio.conf"

	PRESETS=('default' 'fallback')

	#default_config="/etc/mkinitcpio.conf"
	default_image="/boot/initramfs-linux.img"
	#default_options=""

	#fallback_config="/etc/mkinitcpio.conf"
	fallback_image="/boot/initramfs-linux-fallback.img"
	fallback_options="-S autodetect"    
_EOF_

## -------------------------------------------------------------- ##

## Enable Parallel Downloads ##
sed -i -e 's|#ParallelDownloads.*|ParallelDownloads = 6|g' /etc/pacman.conf
sed -i -e '/#\[testing\]/Q' /etc/pacman.conf

## Enable Chaotic AUR ##
pacman-key --init
pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036

## -------------------------------------------------------------- ##

## Set zsh as default shell for new user ##
sed -i -e 's#SHELL=.*#SHELL=/bin/zsh#g' /etc/default/useradd

## -------------------------------------------------------------- ##

## Copy Few Configs Into Root Dir ##
rdir="/root/.config"
sdir="/etc/skel"
if [[ ! -d "$rdir" ]]; then
	mkdir "$rdir"
fi

rconfig=(alacritty bspwm geany gtk-3.0 Kvantum neofetch qt5ct ranger Thunar xfce4 nvim caja cava conky gtk-2.0)
for cfg in "${rconfig[@]}"; do
	if [[ -e "$sdir/.config/$cfg" ]]; then
		cp -rf "$sdir"/.config/"$cfg" "$rdir"
	fi
done

rcfg=('.oh-my-zsh' '.gtkrc-2.0' '.vim_runtime' '.vimrc' '.zshrc' '.p10k.zsh' 'Templates' '.local/share/nvim')
for cfile in "${rcfg[@]}"; do
	if [[ -e "$sdir/$cfile" ]]; then
		cp -rf "$sdir"/"$cfile" /root
	fi
done

## -------------------------------------------------------------- ##

## Don't launch welcome app on installed system, launch Help instead

sed -i -e '/## Welcome-App-Run-Once/Q' /etc/skel/.config/bspwm/bspwmrc
cat >> "/etc/skel/.config/bspwm/bspwmrc" <<- EOL
	# Help-App-Run-Once #
	exodia-help &
	sed -i -e '/# Help-App-Run-Once #/Q' "\$HOME"/.config/bspwm/bspwmrc
EOL

## -------------------------------------------------------------- ##

## Set `WineTrix` as default cursor theme
sed -i -e 's|Inherits=.*|Inherits=WineTrix|g' /usr/share/icons/default/index.theme
mkdir -p /etc/skel/.icons && cp -rf /usr/share/icons/default /etc/skel/.icons/default

## Update xdg-user-dirs for bookmarks in thunar and pcmanfm
runuser -l liveuser -c 'xdg-user-dirs-update'
runuser -l liveuser -c 'xdg-user-dirs-gtk-update'
xdg-user-dirs-update
xdg-user-dirs-gtk-update

## Delete gnome backgrounds
gndir='/usr/share/backgrounds/gnome'
if [[ -d "$gndir" ]]; then
	rm -rf "$gndir"
fi

## -------------------------------------------------------------- ##

