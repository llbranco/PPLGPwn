#!/usr/bin/env bash

# 
# PPLGPwn is a project created by zauceee (aka Kodeine) valeu mano.
# I contributed to his project with some ideas
# so I started my own fork cos at some point our project was aiming different settings/configs I guess
# even tho we still share our ideas or even discuss some new features.
#
# FabulosoDev also have his fork of the project with some interesting features
# some codes here, in the "installer.sh" or in the "run.sh" was made by him. 
# 
# 
#
# this script is partially based on dejavuln-autoroot
# by throwaway96
# https://github.com/throwaway96/dejavuln-autoroot
# Copyright 2024. Licensed under AGPL v3 or later. No warranties.

# Thanks to:
# @TheOfficialFloW @zauceee @FabulosoDev @SiSTR0 @xfangfang @EchoStretch @LightningMods and all contributors that made pppwn and PPLGPwn possible
# - Jacob Clayden (https://jacobcx.dev/) for discovering DejaVuln


clear 
repo=llbranco
RED='\033[0;91m'
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
BLUE='\033[0;94m'
PURPLE='\033[0;95m'
CYAN='\033[0;96m'
NC='\033[0m' # No Color
																						   

echo -e "${GREEN}


8888888b.  8888888b.  888      .d8888b.  8888888b.  888       888 888b    888 
888   Y88b 888   Y88b 888     d88P  Y88b 888   Y88b 888   o   888 8888b   888 
888    888 888    888 888     888    888 888    888 888  d8b  888 88888b  888 
888   d88P 888   d88P 888     888        888   d88P 888 d888b 888 888Y88b 888 
8888888P   8888888P   888     888  88888 8888888P   888d88888b888 888 Y88b888 
888        888        888     888    888 888        88888P Y88888 888  Y88888 
888        888        888     Y88b  d88P 888        8888P   Y8888 888   Y8888 
888        888        88888888 Y8888P88  888        888P     Y888 888    Y888 
                                          ${CYAN}https://github.com/llbranco/PPLGPwn${NC}

${NC}
Designed for LG webOS TVs! Ported by ${PURPLE}Kodeine${NC} & ${PURPLE}Contributors${NC}, with ${RED}luv <3${NC}
Version: v1.4 (${BLUE}modded by LLBRANCO${NC}) 09-OCT-2024"

sleep 3

echo -e "
${YELLOW}---- v1.4 changes ----
New installation method supported: dejavuln

This script is being built with compatibility for webpage installation in mind (similar to what rootmy.tv does).

Now, all questions will be answered using the TV remote control via luna-service, so it's no longer necessary to answer through the SSH terminal (though if many users are interested, I can continue supporting SSH answers as well).
																																	   

Don't worry, the script can still be run via SSH—most of my tests are done through SSH.

This is my first all-in-one (AiO) installer that allows selecting between multiple stage2 payloads (Goldhen, VTX, and Lightningmods), supporting multiple firmwares.

It's very easy to install and/or update, almost as easy as having a built-in automatic updater.

I've begun a debug function (though it's still rudimentary).

The script can be started via SSH using a computer or smartphone, or directly on the TV through the music or photo player.

Keep in mind that a high-quality USB drive is NECESSARY—generic or poor-quality devices may not work properly.
--------${NC}

${CYAN}--------
Installing
--------${NC}
"

echo "definindo variaveis"

###################################
# variables and functions - start #
###################################
srcapp='com.webos.service.secondscreen.gateway'
var_link="https://github.com/llbranco/PPLGPwn/raw/main"
pplgpwn_folder="/media/internal/downloads/PPLGPwn"
usb_dir_sda1="/tmp/usb/sda/sda1"
usb_dir_sdb1="/tmp/usb/sdb/sdb1"
cpu_arch=$(uname -m)
log_file="$pplgpwn_folder/pplgpwn_webos_info.log"

# Path to the startup file and command
startup_file="$pplgpwn_folder/startup.txt"
no_startup_file="$pplgpwn_folder/no_startup.txt"
startup_cmd="cd $pplgpwn_folder && chmod +x ./run.sh && ./run.sh"
startup_script="/var/lib/webosbrew/startup.sh"

# The toast function allows the creation of toast notifications in the system
# To use, simply call the function as in the examples:
# toast 'simple text, does not support variables'
# toast "supports $variable or ${variable}"
# For formatting, use HTML tags such as p, br, b (only works on the first line), i, p, h1-h6
echo "Generating toast function merged with echo"
toast() {
    title='PPLGPwn dejavuln installer'
    escape1="${1//\\/\\\\}"
    escape="${escape1//\"/\\\"}"
    payload="$(printf '{"sourceId":"%s","message":"<h3>%s</h3>%s"}' "${srcapp}" "${title}" "${escape}")"
    luna-send -w 1000 -n 1 -a "${srcapp}" 'luna://com.webos.notification/createToast' "${payload}" >/dev/null
    echo "${1}"
}


# Uninstalling previous version - start
toast "Looking for previous installation..."
for oldfolder in "$pplgpwn_folder" "${pplgpwn_folder}-main"; do
    if [ -d "$oldfolder" ]; then
        toast "Uninstalling previous version..."
        rm -rf "$oldfolder"
    fi
done
sleep 2

# To call the "options" function use "message" "button name", "URLs" and "filename" in this particular order
# You can add as many buttons as you want, as long as they fit vertically on the TV screen; my TV limit is 10
# The first parameter passed will always be the message to display, and each group of 3 parameters refers to a button, its download URL, and the destination filename.
# Example:
# options "any message that you want to show" \ # You can use line breaks by ending the line with "\"
#         "button one" "https://downloadlink.com/remotefile.txt" "targetfile.txt" \ # You can use line breaks by ending the line with "\"
#         "button two" "$yoursite/remotefile.txt" "targetfile.txt"   # Remember not to use "\" on the last line
echo "Generating options function"
options() {
    local title="<b>PPLGPwn dejavuln installer</b>"
    # The first parameter passed will always be the message to display
    local custom_message="${1}"
    # Initializes the JSON payload with the custom message
    payload="{\"message\":\"${title}<br/> ${custom_message}\",\"buttons\":["
    # Counts the number of remaining buttons (total - 1, since the first one is the message)
    num_buttons=$(($# - 1))

    # Adds the buttons to the payload (starting from the second argument)
    index=2
    while [ $index -le $((num_buttons + 1)) ]; do
        button_name="${2}" # Button name
        url="${3}"         # Download URL
        filename="${4}"    # Target filename
        # Adds the button to the payload
        button_payload="{\"label\":\"$button_name\", \"onclick\":\"luna://com.webos.service.downloadmanager/download\", \"params\":{\"target\":\"$url\", \"targetDir\":\"$pplgpwn_folder\", \"targetFilename\":\"$filename\"}}"
        # Concatenates the button_payload to the payload, adding a comma if it's not the first button
        if [ $index -eq 2 ]; then
            payload="$payload$button_payload"
        else
            payload="$payload,$button_payload"
        fi
        # Moves to the next set of arguments
        shift 3
        index=$((index + 3))
    done

    # Closes the JSON payload
    payload="$payload]}"
    # Sends the notification
    luna-send -n 1 -f -a "${srcapp}" luna://com.webos.notification/createAlert "$payload" >/dev/null
}


log_webos_info() {
    # Checks if the directory $pplgpwn_folder exists; if not, creates it
    if [ ! -d "$pplgpwn_folder" ]; then
        echo "Directory $pplgpwn_folder not found. Creating..."
        mkdir -p "$pplgpwn_folder"
    fi
    # Clears the content of the previous log file
    : > "$log_file"
    # Obtaining TV system data and logging the output
    echo -e "\nObtaining TV system data..." | tee -a "$log_file"
    luna-send -n 1 -f luna://com.webos.service.systemservice/osInfo/query '{
       "parameters":[
          "webos_name",
          "core_os_release",
          "webos_release",
          "webos_build_id"
       ]
    }' >> "$log_file" 2>&1
    # Obtaining TV hardware data and logging the filtered output
    echo -e "\nObtaining TV hardware data..." | tee -a "$log_file"
    echo -e "\nCPU architecture: $cpu_arch..." | tee -a "$log_file"
    luna-send -n 1 -f luna://com.webos.service.systemservice/deviceInfo/query '{}' | grep -E "ram|product_id|storage|storage_free" >> "$log_file" 2>&1
    # Executes the connection status command and logs the output
    echo -e "\nObtaining connection status..." | tee -a "$log_file"
    luna-send -n 1 -f luna://com.webos.service.connectionmanager/getStatus '{}' >> "$log_file" 2>&1
    echo "Information recorded in the log file: $log_file"
}

# Calls the function
log_webos_info

# Checks if at least one of the USB directories exists and copies the log file
if [ -d "$usb_dir_sda1" ]; then
    echo "USB DRIVE sda1 found, copying webos_info to it as $log_file, useful for debugging."
    cp "$log_file" "$usb_dir_sda1/pplgpwn_webos_info.log"
elif [ -d "$usb_dir_sdb1" ]; then
    echo "USB DRIVE sdb1 found, copying webos_info to it as $log_file, useful for debugging."
    cp "$log_file" "$usb_dir_sdb1/pplgpwn_webos_info.log"
else
    echo "NO USB DRIVE found, the log is locally saved as $log_file"
fi

case "$cpu_arch" in
    armv7 | armv7l)
        cpu_arch='armv7'
        ;;
    aarch64)
        cpu_arch='aarch64'
        ;;
    *)
    toast "Unsupported CPU architecture = $cpu_arch"
        exit 1
        ;;
esac

toast "your Cpu architecture is: $cpu_arch"
sleep 5

toast 'Please select your prefered Stage2-Hen'
sleep 3

# Checks if custom.sh exists in USB root and executes it if found.
if [ -f "$usb_dir_sda1/custom.sh" ] || [ -f "$usb_dir_sdb1/custom.sh" ]; then
    echo "custom.sh found, skipping previous check."
    # Defines the path of custom.sh based on the directory it was found in
    if [ -f "$usb_dir_sda1/custom.sh" ]; then
        custom_path="$usb_dir_sda1/custom.sh"
    else
        custom_path="$usb_dir_sdb1/custom.sh"
    fi
    # Sets the hen_loader variable without the .sh extension
    hen_loader=$(basename "$custom_path" .sh)
    toast "hen_loader set to: $hen_loader, Loading your custom dejavuln payloader.<br/> Use only if you know what you are doing. I am not responsible for the improper use of this function."
    sleep 30
    # running custom.sh
    "$custom_path"
    exit 0
else
    # Downloading the README to use as a "trigger" for the installer
    options "Choose your Stage2 or HEN loader" \
            "Goldhen"  "$var_link/dejavuln-installer/readme.md" "goldhen.txt" \
            "VTX fw 7.00~9.00" "$var_link/dejavuln-installer/readme.md" "ps4henvtx.txt" \
            "VTX fw 9.03~11.00" "$var_link/dejavuln-installer/readme.md" "ps4henvtx2.txt" \
            "Lightning Mods stage2" "$var_link/dejavuln-installer/readme.md" "lightningmods.txt"
    # Loop to check for the existence of files in the local directory
    while true; do
        if [ -f "$pplgpwn_folder/goldhen.txt" ]; then
            toast "goldhen.txt found."
            hen_loader="goldhen"
            break
        elif [ -f "$pplgpwn_folder/ps4henvtx.txt" ]; then
            toast "ps4henvtx.txt found."
            hen_loader="ps4henvtx"
            break
        elif [ -f "$pplgpwn_folder/ps4henvtx2.txt" ]; then
            toast "ps4henvtx2.txt found."
            hen_loader="ps4henvtx2"
            break
        elif [ -f "$pplgpwn_folder/lightningmods.txt" ]; then
            toast "lightningmods.txt found."
            hen_loader="lightningmods"
            break
        else
            toast "Waiting for one of the HEN loader files to be downloaded..."
            sleep 2  # wait 2seg for next attempt
        fi
    done
    toast "hen_loader set to: $hen_loader"
fi

sleep 2
toast "downloading pppwn binaries for $cpu_arch"
curl -fsSL -o "$pplgpwn_folder/pppwn" "$var_link/pppwn_$cpu_arch"
sleep 3
curl -fsSL -o "$pplgpwn_folder/run.sh" "$var_link/run.sh"
sleep 3
#####################################
# HEN select - end                  #
#####################################



#####################################
# hen installer - start             #
#####################################
toast "Installing Hen..."
    while true; do
        if [ -f "$pplgpwn_folder/goldhen.txt" ]; then
            hen_loader="goldhen"
            toast "goldhen.txt found."
            options "Select your PlayStation 4 Firmware" \
                    "9.00" "$var_link/stage1/900/stage1.bin" "900.stage1" \
                    "9.60" "$var_link/stage1/960/stage1.bin" "960.stage1" \
                    "10.00" "$var_link/stage1/1000/stage1.bin" "1000.stage1" \
                    "10.01" "$var_link/stage1/1001/stage1.bin" "1001.stage1" \
                    "10.50" "$var_link/stage1/1050/stage1.bin" "1050.stage1" \
                    "10.70" "$var_link/stage1/1070/stage1.bin" "1070.stage1" \
                    "10.71" "$var_link/stage1/1071/stage1.bin" "1071.stage1" \
                    "11.00" "$var_link/stage1/1100/stage1.bin" "1100.stage1"
            # Check if the stage1 file has been downloaded
            while true; do
                file=$(ls "$pplgpwn_folder/" | grep ".stage1" | cut -d '.' -f 1)
                
                if [[ -n "$file" ]]; then
                fmv="$file"
                    toast "File $file stage1 detected."
                    break
                fi
                toast "Waiting for $file stage1 download..."
                sleep 1
            done

            # Verificação e renomeação de stage1 e download de stage2
            if [ -f "$pplgpwn_folder/$file.stage1" ]; then
                toast "$file stage1 has been downloaded."
                sleep 2
                mv "$pplgpwn_folder/$file.stage1" "$pplgpwn_folder/stage1.bin"
                toast "Downloading stage2 for firmware $file..."
                curl -fsSL -o "$pplgpwn_folder/stage2.bin" "$var_link/stage2/$file/stage2.bin"
                sleep 2
                toast "Stage2 for firmware $file downloaded."
                break
            else
                toast "Waiting for $file .stage1... second check"
                sleep 2
            fi

        elif [ -f "$pplgpwn_folder/ps4henvtx.txt" ]; then
            hen_loader="ps4henvtx"
            toast "ps4henvtx.txt was found."
            # Início da instalação de VTX1
            options "Select your PlayStation 4 Firmware" \
                    "7" "$var_link/stage1/700/stage1.bin" "700.stage1" \
                    "701" "$var_link/stage1/701/stage1.bin" "701.stage1" \
                    "702" "$var_link/stage1/702/stage1.bin" "702.stage1" \
                    "750" "$var_link/stage1/750/stage1.bin" "750.stage1" \
                    "751" "$var_link/stage1/751/stage1.bin" "751.stage1" \
                    "755" "$var_link/stage1/755/stage1.bin" "755.stage1" \
                    "8" "$var_link/stage1/800/stage1.bin" "800.stage1" \
                    "801" "$var_link/stage1/801/stage1.bin" "801.stage1" \
                    "803" "$var_link/stage1/803/stage1.bin" "803.stage1" \
                    "850" "$var_link/stage1/850/stage1.bin" "850.stage1" \
                    "852" "$var_link/stage1/852/stage1.bin" "852.stage1" \
                    "9" "$var_link/stage1/900/stage1.bin" "900.stage1"
                    toast "try to select in less than 15 sec."
                    sleep 10
            # Check if the stage1 file has been downloaded
            while true; do
                file=$(ls "$pplgpwn_folder/" | grep ".stage1" | cut -d '.' -f 1)
                
                if [[ -n "$file" ]]; then
                fmv="$file"
                    toast "File $file stage1 detected."
                    break
                fi
                toast "Waiting for $file stage1 download..."
                sleep 1
            done
            # Verificação e renomeação de stage1 e download de stage2
            if [ -f "$pplgpwn_folder/$file.stage1" ]; then
                toast "$file stage1 has been downloaded."
                sleep 2
                mv "$pplgpwn_folder/$file.stage1" "$pplgpwn_folder/stage1.bin"
                toast "Downloading stage2 for firmware $file..."
                curl -fsSL -o "$pplgpwn_folder/stage2.bin" "$var_link/ps4hen/$file/stage2.bin"
                sleep 2
                toast "Stage2 for firmware $file downloaded."
                break
            else
                toast "Waiting for $file .stage1..."
                sleep 2
            fi

            break
            # Fim da instalação de VTX1
            # Início da instalação de VTX2
                    elif [ -f "$pplgpwn_folder/ps4henvtx2.txt" ]; then
            hen_loader="ps4henvtx2"
            toast "ps4henvtx2.txt was found."
            options "Select your PlayStation 4 Firmware<br/>A=9.00 B=9.03 C=9.50 D=9.51 E=9.60 F=10.00 G=10.01 H=10.50 I=10.70 J=10.71 K=11.00Z" \
                    "A" "$var_link/stage1/903/stage1.bin" "903.stage1" \
                    "B" "$var_link/stage1/904/stage1.bin" "904.stage1" \
                    "C" "$var_link/stage1/950/stage1.bin" "950.stage1" \
                    "D" "$var_link/stage1/951/stage1.bin" "951.stage1" \
                    "E" "$var_link/stage1/960/stage1.bin" "960.stage1" \
                    "F" "$var_link/stage1/1000/stage1.bin" "1000.stage1" \
                    "G" "$var_link/stage1/1001/stage1.bin" "1001.stage1" \
                    "H" "$var_link/stage1/1050/stage1.bin" "1050.stage1" \
                    "I" "$var_link/stage1/1070/stage1.bin" "1070.stage1" \
                    "J" "$var_link/stage1/1071/stage1.bin" "1071.stage1" \
                    "K" "$var_link/stage1/1100/stage1.bin" "1100.stage1"
                    toast "try to select in less than 15 sec."
                    sleep 10
            # Check if the stage1 file has been downloaded
            while true; do
                file=$(ls "$pplgpwn_folder/" | grep ".stage1" | cut -d '.' -f 1)
                if [[ -n "$file" ]]; then
                fmv="$file"
                    toast "File $file stage1 detected."
                    break
                fi
                toast "Waiting for $file stage1 download..."
                sleep 1
            done
            # Verificação e renomeação de stage1 e download de stage2
            if [ -f "$pplgpwn_folder/$file.stage1" ]; then
                toast "$file stage1 has been downloaded."
                sleep 2
                mv "$pplgpwn_folder/$file.stage1" "$pplgpwn_folder/stage1.bin"
                toast "Downloading stage2 for firmware $file..."
                curl -fsSL -o "$pplgpwn_folder/stage2.bin" "$var_link/ps4hen/$file/stage2.bin"
                sleep 2
                toast "Stage2 for firmware $file downloaded."
                break
            else
                toast "Waiting for $file .stage1..."
                sleep 2
            fi
            break
            # Fim da instalação de VTX2
            
        elif [ -f "$pplgpwn_folder/lightningmods.txt" ]; then
            hen_loader="lightningmods"
            toast "lightningmods.txt was found."
            # Início da instalação de Lightning Mods
                        options "Select your PlayStation 4 Firmware" \
                    "9.00" "$var_link/stage1/900/stage1.bin" "900.stage1" \
                    "9.60" "$var_link/stage1/960/stage1.bin" "960.stage1" \
                    "10.00" "$var_link/stage1/1000/stage1.bin" "1000.stage1" \
                    "10.01" "$var_link/stage1/1001/stage1.bin" "1001.stage1" \
                    "10.50" "$var_link/stage1/1050/stage1.bin" "1050.stage1" \
                    "10.70" "$var_link/stage1/1070/stage1.bin" "1070.stage1" \
                    "10.71" "$var_link/stage1/1071/stage1.bin" "1071.stage1" \
                    "11.00" "$var_link/stage1/1100/stage1.bin" "1100.stage1"
            # Check if the stage1 file has been downloaded
            while true; do
                file=$(ls "$pplgpwn_folder/" | grep ".stage1" | cut -d '.' -f 1)
                
                if [[ -n "$file" ]]; then
                fmv="$file"
                    toast "File $file stage1 detected."
                    break
                fi
                toast "Waiting for $file stage1 download..."
                sleep 1
            done
            # Verificação e renomeação de stage1 e download de stage2
            if [ -f "$pplgpwn_folder/$file.stage1" ]; then
                toast "$file stage1 has been downloaded."
                sleep 2
                mv "$pplgpwn_folder/$file.stage1" "$pplgpwn_folder/stage1.bin"
                toast "Downloading Lightning mods stage2 payloader"
                curl -fsSL -o "https://github.com/LightningMods/PPPwn/releases/download/payloads/stage2.bin" "$var_link/stage2/$file/stage2.bin"
                sleep 2
                toast "Stage2 downloaded<br/>to use it simply put your payload.bin in the root on your USB."
                break
            else
                toast "Waiting for $file .stage1..."
                sleep 2
            fi
            # Fim da instalação de Lightning Mods
            break
        else
            toast 'Please select your preferred Hen'
            toast "Debug: No files found. Waiting... please select an option to continue."
            sleep 5
        fi
    done
#####################################
# hen installer - end               #
#####################################

    # Downloading the README to use as a "trigger" for the installer
    options "Start PPLGPwn on boot?" \
            "Yes, Please"  "$var_link/dejavuln-installer/readme.md" "startup.txt" \
            "No, Thank you" "$var_link/dejavuln-installer/readme.md" "no_startup.txt"


# Check if startup.txt exists
while true; do
    if [ -f "$startup_file" ]; then
        # If you find "startup.txt", add the command to the script to start at boot.
        if ! grep -Fxq "$startup_cmd" "$startup_script"; then
            echo "$startup_cmd" >> "$startup_script"
            echo "startup_cmd added to $startup_script."
        else
            echo "startup_cmd already exists in $startup_script."
        fi
        break
    elif [ -f "$no_startup_file" ]; then
        # If you find "no_startup.txt", just say it.
        toast "You selected that you dont want to load at startup"
        break
    else
        # loop
        toast "Please select if you want to start on boot..."
        sleep 3
    fi
done


toast "creating config files"
echo "hen_loader=$hen_loader
interface=eth0
firmver=$file
stage1=$pplgpwn_folder/stage1.bin
stage2=$pplgpwn_folder/stage2.bin
" > "$pplgpwn_folder/settings.config"
sleep 2
echo "config file Done!"

if [[ -f $pplgpwn_folder/stage1.bin && -f $pplgpwn_folder/stage2.bin ]]; then
    toast "<b>congratulations:</b> stage1.bin and stage2.bin for $hen_loader $file were successfully downloaded to firmware $fmv"
else
    toast "<b>warning:</b> Error downloading stage1.bin or stage2.bin"
fi
sleep 2

toast "<b>PPLGPwn installed.</b> running on 3"
sleep 1
toast "<b>PPLGPwn installed.</b> running on 2"
sleep 1
toast "<b>PPLGPwn installed.</b> running on 1"
sleep 1

cd "$pplgpwn_folder"
chmod +x "run.sh"
chmod +x "pppwn"
./run.sh
