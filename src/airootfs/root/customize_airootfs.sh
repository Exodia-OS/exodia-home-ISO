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

## disable `exodia-welcome` and enable `exodia-assistant` ##
sed -i 's/exodia-welcome/exodia-assistant/g' /etc/skel/.config/bspwm/bspwmrc

## update `~/.bashrc` config ##
cat >> " /etc/skel/.bashrc" <<- EOL

## ------------ Alias ------------ ##

# ls #
alias ls='lsd'
alias l='lsd -lh'
alias ll='lsd -lah'
alias la='lsd -A'
alias lm='lsd -m'
alias lr='lsd -R'
alias lg='lsd -l --group-directories-first'

# git #
alias gcl='git clone --depth 1'
alias gi='git init'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push origin master'
alias cb='git checkout'

# Pacman #
alias sync="sudo pacman -Syyy"
alias install="sudo pacman -S"
alias ipkg="sudo pacman -U"
alias update="sudo pacman -Syyu"
alias search="sudo pacman -Ss"
alias search-local="sudo pacman -Qs"
alias pkg-info="sudo pacman -Qi"
alias local-install="sudo pacman -U"
alias clr-cache="sudo pacman -Scc"
alias unlock="sudo rm /var/lib/pacman/db.lck"
alias remove="sudo pacman -R"
alias autoremove="sudo pacman -Rns"

# yay - AUR Helper #
alias Ysync="yay -Syyy"
alias Yinstall="yay -S"
alias Yipkg="yay -U"
alias Yupdate="yay -Syyu"
alias Ysearch="yay -Ss"
alias Ysearch-local="yay -Qs"
alias Ypkg-info="yay -Qi"
alias Ylocal-install="yay -U"
alias Yclr-cache="yay -Scc"
alias Yremove="yay -R"
alias Yautoremove="yay -Rns"

# Other #
alias M="ncmpcpp"
alias MA="cd ~/.ncmpcpp/scripts/ && ./ncmpcpp-art"
alias youtube="ytfzf -t"
alias eDEX-UI="eDEX-UI-Linux-x86_64.AppImage"


## ------------ COLORS ------------ ##

# Reset #
RESET_COLOR='\033[0m' # Text Reset

# Regular Colors #
Black='\033[0;30m'  Red='\033[0;31m'     Green='\033[0;32m'  Yellow='\033[0;33m'
Blue='\033[0;34m'   Purple='\033[0;35m'  Cyan='\033[0;36m'   White='\033[0;37m'

# Bold #
BBlack='\033[1;30m' BRed='\033[1;31m'    BGreen='\033[1;32m' BYellow='\033[1;33m'
BBlue='\033[1;34m'  BPurple='\033[1;35m' BCyan='\033[1;36m'  BWhite='\033[1;37m'

# Underline #
UBlack='\033[4;30m' URed='\033[4;31m'    UGreen='\033[4;32m' UYellow='\033[4;33m'
UBlue='\033[4;34m'  UPurple='\033[4;35m' UCyan='\033[4;36m'  UWhite='\033[4;37m'

# Background #
On_Black='\033[40m' On_Red='\033[41m'    On_Green='\033[42m' On_Yellow='\033[43m'
On_Blue='\033[44m'  On_Purple='\033[45m' On_Cyan='\033[46m'  On_White='\033[47m'

# High Intensity #
IBlack='\033[0;90m' IRed='\033[0;91m' IGreen='\033[0;92m' IYellow='\033[0;93m'      
IBlue='\033[0;94m' IPurple='\033[0;95m' ICyan='\033[0;96m' IWhite='\033[0;97m'      

# Bold High Intensity #
BIBlack='\033[1;90m' BIRed='\033[1;91m' BIGreen='\033[1;92m' BIYellow='\033[1;93m'
BIBlue='\033[1;94m' BIPurple='\033[1;95m' BICyan='\033[1;96m' BIWhite='\033[1;97m'

# High Intensity backgrounds #
On_IBlack='\033[0;100m' On_IRed='\033[0;101m' On_IGreen='\033[0;102m' On_IYellow='\033[0;103m'
On_IBlue='\033[0;104m' On_IPurple='\033[0;105m' On_ICyan='\033[0;106m' On_IWhite='\033[0;107m'

# load on startup #
echo -e ${Purple} "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━┓"
echo -e ${Purple} "┃                                                                                ┃ ${Cyan}  ${BBlue}Exodia Fetch ${Purple}┃  ${BGreen}  ${BYellow}  ${BRed}  ${Purple}┃"${RESET_COLOR}
echo -e ${Purple} "┃  ██╗ ██╗     ███████╗██╗  ██╗ ██████╗ ██████╗ ██╗ █████╗      ██████╗ ███████╗ ┣━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━┫"${RESET_COLOR}
echo -e ${Purple} "┃ ████████╗    ██╔════╝╚██╗██╔╝██╔═══██╗██╔══██╗██║██╔══██╗    ██╔═══██╗██╔════╝ ┃                             ┃"${RESET_COLOR}
echo -e ${Purple} "┃ ╚██╔═██╔╝    █████╗   ╚███╔╝ ██║   ██║██║  ██║██║███████║    ██║   ██║███████╗ ┃ ${Cyan}  ${BIGreen}@author MAHMOUD MOHAMED  ${Purple}┃"${RESET_COLOR}
echo -e ${Purple} "┃ ████████╗    ██╔══╝   ██╔██╗ ██║   ██║██║  ██║██║██╔══██║    ██║   ██║╚════██║ ┃ ${Cyan}  ${Blue}Developed by : ${BIGreen}00xWolf   ${Purple}┃"${RESET_COLOR}
echo -e ${Purple} "┃ ╚██╔═██╔╝    ███████╗██╔╝ ██╗╚██████╔╝██████╔╝██║██║  ██║    ╚██████╔╝███████║ ┃ ${Cyan}  ${Blue}GitHub : ${BIGreen}@mmsaeed509     ${Purple}┃"${RESET_COLOR}
echo -e ${Purple} "┃  ╚═╝ ╚═╝     ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═╝     ╚═════╝ ╚══════╝ ┃ ${Cyan}﫥 ${BIGreen}Cyb3rTh1eveZ Team        ${Purple}┃"${RESET_COLOR}
echo -e ${Purple} "┃                                                                                ┃                             ┃"${RESET_COLOR}
echo -e ${Purple} "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"${RESET_COLOR}

echo -e "\n Welcome back ${BIGreen}Mr.${USER} ${RESET_COLOR}\n"

# change sudo prompt #
export SUDO_PROMPT="[] Enter sudo Password, Mr.${USER}: "


EOL

## -------------------------------------------------------------- ##