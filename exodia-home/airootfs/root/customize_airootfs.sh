#!/usr/bin/env bash

## Script to perform several important tasks before `makeExodiaISO` create filesystem image.

set -e -u

## -------------------------------------------------------------- ##

## Enable Chaotic AUR ##
pacman-key --init
pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036

## Set zsh as default shell for new user ##
sed -i -e 's#SHELL=.*#SHELL=/bin/zsh#g' /etc/default/useradd

## Copy Few Configs Into Root Dir ##
rdir="/root/.config"
sdir="/etc/skel"
if [[ ! -d "$rdir" ]]; then
	mkdir "$rdir"
fi

rconfig=('alacritty' 'bspwm' 'geany' 'gtk-3.0' 'Kvantum' 'neofetch' 'qt5ct' 'ranger' 'Thunar' 'xfce4' 'nvim' 'caja' 'cava' 'conky' 'gtk-2.0')
for cfg in "${rconfig[@]}"; do
	if [[ -e "$sdir/.config/$cfg" ]]; then
		cp -rf "$sdir"/.config/"$cfg" "$rdir"
	fi
done

rcfg=('.oh-my-zsh' '.gtkrc-2.0' '.vim_runtime' '.vimrc' '.zshrc' '.p10k.zsh' 'Templates' '.local/share/nvim' '.ncmpcpp' '.mplayer' '.mpd')
for cfile in "${rcfg[@]}"; do
	if [[ -e "$sdir/$cfile" ]]; then
		cp -rf "$sdir"/"$cfile" /root
	fi
done


## Don't launch welcome app on installed system, launch Help instead ##

sed -i -e '/## Welcome-App-Run-Once/Q' /etc/skel/.config/bspwm/bspwmrc
cat >> "/etc/skel/.config/bspwm/bspwmrc" <<- EOL
	# Help-App-Run-Once #
	exodia-help &
	sed -i -e '/# Help-App-Run-Once #/Q' "\$HOME"/.config/bspwm/bspwmrc
EOL

## Delete gnome backgrounds ##

gndir='/usr/share/backgrounds/gnome'
if [[ -d "$gndir" ]]; then
	rm -rf "$gndir"
fi

## -------------------------------------------------------------- ##