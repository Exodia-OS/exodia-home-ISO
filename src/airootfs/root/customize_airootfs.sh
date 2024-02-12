#!/usr/bin/env bash

#####################################
#                                   #
#  @author      : 00xWolf           #
#    GitHub    : @mmsaeed509       #
#    Developer : Mahmoud Mohamed   #
#  﫥  Copyright : Exodia OS         #
#                                   #
#####################################

## Script to perform several important tasks before `makeExodiaISO` create filesystem image. ##

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

## Enable Chaotic AUR ##
pacman-key --init
pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036

## Set zsh as default shell for new user ##
sed -i -e 's#SHELL=.*#SHELL=/bin/zsh#g' /etc/default/useradd

## Copy Few Configs Into Root Dir ##
rdir="/root/.config"
sdir="/etc/skel"

if [[ ! -d "$rdir" ]];
	
	then
		
		mkdir "$rdir"

fi

rconfig=(

	'alacritty' 'bspwm' 'geany' 'gtk-3.0' 
	'Kvantum' 'neofetch' 'qt5ct' 'ranger' 
	'Thunar' 'xfce4' 'nvim' 'caja' 'cava' 
	'rofi' 'gtk-2.0' 'dunst' 'sxhkd' 'i3'
	'networkmanager-dmenu' 'mimeapps.list'
)

for cfg in "${rconfig[@]}";
	
	do
		
		if [[ -e "$sdir/.config/$cfg" ]];
			
			then
				
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

for cfile in "${rcfg[@]}";
	
	do
	
		if [[ -e "$sdir/$cfile" ]];
			
			then
				
				cp -rf "$sdir"/"$cfile" /root

		fi
		
done

## make eDEX-UI executable ## 
chmod +x /usr/local/bin/eDEX-UI-Linux-x86_64.AppImage

## Update xdg-user-dirs for bookmarks in thunar and pcmanfm ##
runuser -l liveuser -c 'xdg-user-dirs-update'
runuser -l liveuser -c 'xdg-user-dirs-gtk-update'
xdg-user-dirs-update
xdg-user-dirs-gtk-update

## disable `exodia-welcome` and enable `exodia-assistant` ##
sed -i 's/exodia-welcome/exodia-assistant/g' /etc/skel/.config/bspwm/bspwmrc
sed -i 's/exodia-welcome/exodia-assistant/g' /etc/skel/.config/i3/bin/autostart.sh

## -------------------------------------------------------------- ##
