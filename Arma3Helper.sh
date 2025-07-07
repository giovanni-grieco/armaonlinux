#!/usr/bin/env bash

# SPDX-License-Identifier: GPL-2.0
# 
# Original Author: Ingo Reitz <9l@9lo.re>
# Modified by: Giovanni Pio Grieco <giovannipiogrieco@gmail.com>
# 
_SCRIPTVER="2v00-1"

#####################################################################################
## Adjust below or use the external config file
#####################################################################################

## Path to Arma's compatdata (wineprefix)
# Leave empty if Arma is installed in Steams default library
COMPAT_DATA_PATH=""

# If you have proton in a different steam library, then put the path to its steamapps folder here
# Leave empty if Proton is installed in Steams default library
STEAM_LIBRARY_PATH=""

## Esync/Fsync
# IMPORTANT: Make sure that Esync and Fsync settings MATCH for both Arma and TeamSpeak(here)
# If you havent explicitly turned it off for Arma, leave it on here!
ESYNC=true
FSYNC=true

###########################################################################
##        DO NOT EDIT BELOW!
###########################################################################

# Exit if run with different shell
if  [ -n "$_" ]; then
	echo "FATAL: Do not run the script with sh or any other shell!"
	echo "Shell: $_"
	exit
fi

# Check if $XDG_CONFIG_HOME exists, then read external config if it exists
if [[ -n "$XDG_CONFIG_HOME" ]]; then
	USERCONFIG="$XDG_CONFIG_HOME/arma3helper"
else
	USERCONFIG="$HOME/.config/arma3helper"
fi
if [[ -e "$USERCONFIG/config" ]]; then
	echo "Config file $USERCONFIG/config found. Using its values."
	# shellcheck source=/dev/null
	source "$USERCONFIG/config"
fi

## FUNCTIONS
# Installed check ($1 = path; $2 = name in error msg)
_checkinstall() {
	if [[ ! $(command -v "$1") ]]; then
		echo -e "\e[31mError\e[0m: $1 is not installed!"
		exit 1
	fi
}
# Installed check by path ($1 = path; $2 = name in error msg)
_checkpath() {
	if [[ ! -e "$1" ]]; then
		echo -e "\e[31mError\e[0m: $2 is not installed!"
		exit 1
	fi
}
# Confirmation prompt
_confirmation() {
	read -p "$1 (y/n) " -n 1 -r
	echo 
	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
    	exit 1
	fi
}
# Get the command to modify the protonprefix
_get_wrappercmd() {
	no_winetricks=$(_checkinstall "winetricks")
	no_protontricks=$(_checkinstall "protontricks")
	wrappercmd=""

	if [[ $no_winetricks && $no_protontricks ]]; then
		echo -e "$no_winetricks\n$no_protontricks"
		exit 1
	fi
	if [[ $no_winetricks ]]; then
		echo "protontricks 107410"
	else
		echo "winetricks"
	fi
}

## ENVIROMENTAL VARAIBLES
if [[ -z "$COMPAT_DATA_PATH" ]]; then
	COMPAT_DATA_PATH="$HOME/.local/share/Steam/steamapps/compatdata/107410"
fi
export STEAM_COMPAT_DATA_PATH="$COMPAT_DATA_PATH"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam"
export SteamAppId="107410"
export SteamGameId="107410"
if [[ $ESYNC == false ]]; then
	export PROTON_NO_ESYNC="1"
fi
if [[ $FSYNC == false ]]; then
	export PROTON_NO_FSYNC="1"
fi

PROTONEXEC="protontricks-launch --appid 107410"
TSPATH="$COMPAT_DATA_PATH/pfx/drive_c/Program Files/TeamSpeak 3 Client/ts3client_win64.exe"
# Start
if [[ -z $* ]]; then
	# Check if TS is installed
	_checkpath "$TSPATH" "TeamSpeak"
	echo "Caution: Arma needs to be started first!"
	sh -c "$PROTONEXEC '$TSPATH'"
# TS installer
# TS installer
elif [[ $1 == "install" ]]; then 
    echo "Trying to install Teamspeak with provided file"
    echo -e "\e[31mINSTALL TEAMSPEAK FOR ALL USERS AND LEAVE THE PATH DEFAULT!!!\e[0m \n"
    sleep 2
    if [[ -z $2 ]]; then
        echo "Error - no installer exe provided"
        exit 1
    fi
    sh -c "$PROTONEXEC $2"
    
    # Create application shortcut after installation
    echo "Creating application shortcut..."
    SCRIPT_PATH="$(realpath "$0")"
    APPS_DIR="$HOME/.local/share/applications"
    mkdir -p "$APPS_DIR"
    DESKTOP_FILE="$APPS_DIR/TeamSpeak3-ArmA3.desktop"
    
    cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Type=Application
Name=TeamSpeak 3 (ArmA3)
Comment=Launch TeamSpeak 3 for ArmA3 via Proton
Exec=$SCRIPT_PATH
Icon=teamspeak3
Terminal=false
Categories=Game;Network;
EOF
    
    chmod +x "$DESKTOP_FILE"
    echo "Application shortcut created - find it in your applications menu"
# Debug information
elif [[ $1 = "debug" ]]; then
	echo "DEBUGGING INFORMATION"
	echo
	echo "Script Version: $_SCRIPTVER"
	_UPVER=$(curl -s https://raw.githubusercontent.com/giovanni-grieco/armaonlinux/master/version)
	if [[ $_SCRIPTVER != "$_UPVER" ]]; then
		echo -e "\e[31mScript Version $_UPVER is available!\e[0m"
		echo "https://github.com/giovanni-grieco/armaonlinux"
	fi
	echo
	echo "Command Line:"
	echo "sh -c \"$PROTONEXEC $TSPATH\""
	echo
	echo "Enviromental Variables"
	echo "STEAM_COMPAT_DATA_PATH: $STEAM_COMPAT_DATA_PATH"
	echo "SteamAppId/SteamGameId: $SteamAppId $SteamGameId"
	echo "ESync: $ESYNC"
	echo "FSync: $FSYNC"
elif [[ $1 = "winecfg" ]]; then
	echo "Starting winecfg via winetricks for Arma's compatdata..."
	wrappercmd=$(_get_wrappercmd)
	echo "Running $wrappercmd winecfg"
	export WINEPREFIX="$COMPAT_DATA_PATH/pfx"
	$wrappercmd winecfg
# Updater
elif [[ $1 = "update" ]]; then
	echo -e "\e[31mUpdating the script will reset your changes in the script options!\e[0m"
	echo "However, it will not reset your settings in ~/.arma3helper."
	_confirmation "Are you sure?"
	curl -o "$0" https://raw.githubusercontent.com/giovanni-grieco/armaonlinux/master/Arma3Helper.sh
	echo "The Script was updated!"
else
	echo "SCRIPT USAGE"
	echo
	echo -e "\e[31mDouble check the script settings before reporting any problems!\e[0m"
	echo
	echo "./Arma3Helper.sh                                      - Start Teamspeak"
	echo
	echo "./Arma3Helper.sh install [installer exe path]         - Install Teamspeak"
	echo
	echo "./Arma3Helper.sh winecfg                              - Run winecfg for the Arma prefix"
	echo
	echo "./Arma3Helper.sh debug                                - Print Debugging Information"
	echo 
	echo "./Arma3Helper.sh update                               - Update the script from github master"
fi
