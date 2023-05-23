#!/usr/bin/env bash

## Script to perform several important tasks before `makeExodiaISO` create filesystem image. ##

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

rconfig=(

	'alacritty' 'bspwm' 'geany' 'gtk-3.0' 
	'Kvantum' 'neofetch' 'qt5ct' 'ranger' 
	'Thunar' 'xfce4' 'nvim' 'caja' 'cava' 
	'rofi' 'gtk-2.0' 'dunst' 'sxhkd' 
	'networkmanager-dmenu' 'mimeapps.list'
)

for cfg in "${rconfig[@]}"; do
	if [[ -e "$sdir/.config/$cfg" ]]; then
		cp -rf "$sdir"/.config/"$cfg" "$rdir"
	fi
done

rcfg=(

	'.oh-my-zsh' '.gtkrc-2.0' '.vim_runtime' 
	'.vimrc' '.zshrc' '.p10k.zsh' 'Templates' 
	'.local/share/nvim' '.ncmpcpp' '.mplayer' 
	'.mpd' 'Music' '.face' '.Xresources.d'
	'.dmrc' '.fehbg' '.Xresources' '.xsettingsd'

)

for cfile in "${rcfg[@]}"; do
	if [[ -e "$sdir/$cfile" ]]; then
		cp -rf "$sdir"/"$cfile" /root
	fi
done

## make eDEX-UI executable ## 
# chmod +x /usr/local/bin/eDEX-UI-Linux-x86_64.AppImage

## Update xdg-user-dirs for bookmarks in thunar and pcmanfm ##
runuser -l liveuser -c 'xdg-user-dirs-update'
runuser -l liveuser -c 'xdg-user-dirs-gtk-update'
xdg-user-dirs-update
xdg-user-dirs-gtk-update

## fix exodia-grub-theme ##
# cp -r /usr/share/grub/themes/exodia /boot/grub/themes/
# sudo grub-mkconfig -o /boot/grub/grub.cfg

## -------------------------------------------------------------- ##