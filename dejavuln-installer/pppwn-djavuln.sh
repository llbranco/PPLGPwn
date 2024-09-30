#!/usr/bin/env bash
clear 

# you can manually edit this file if you wanto to install in another firmware
# just replace the 1100 to any firmware that you want (between 900~1100)
fmv=1100

# don't edit anything else
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

${NC}
Designed for LG webOS TVs! Ported by ${PURPLE}Kodeine${NC} & ${PURPLE}Contributors${NC}, with ${RED}luv <3${NC}
Version: v1.3.1 (${BLUE}modded by llbranco${NC})

${CYAN}-------
INSTALLATION
-------${NC}
"

echo "thanks to FabulosoDev, this installer is based on his installer v1.2..."

reinstall=true
cpu_arch=`uname -m`

echo "$cpu_arch"

if [ -d /media/internal/downloads/PPLGPwn ]
then
	    pkill -f "pppwn"
		pkill -f "pppwn_$cpu_arch"
        rm -rf /media/internal/downloads/PPLGPwn
        reinstall=true
        echo "Done!"
fi

if [ -d /media/internal/downloads/PPLGPwn-main ]
then
		pkill -f "pppwn"
		pkill -f "pppwn_$cpu_arch"
        rm -rf /media/internal/downloads/PPLGPwn-main
        echo "Done!"
fi

echo "instalando "
if [ $cpu_arch = "armv7" ] || [ $cpu_arch = "armv7l" ]
	then
	cpu_arch='armv7'
		elif [ $cpu_arch = "aarch64" ]; then
			cpu_arch='aarch64'
		else 
			echo "Cpu architecture = $cpu_arch"
			luna-send -a webosbrew -f -n 1 luna://com.webos.notification/createToast '{"sourceId":"webosbrew","message": "<b>Error:</b>Unsupported CPU architecture, please report onto the issues tab in the GitHub repo with your cpu arch!"}'
	return
fi


mkdir -p /media/internal/downloads/PPLGPwn
curl -fsSL -o /media/internal/downloads/PPLGPwn/pppwn https://github.com/$repo/PPLGPwn/raw/main/pppwn_$cpu_arch
curl -fsSL -o /media/internal/downloads/PPLGPwn/run.sh https://github.com/$repo/PPLGPwn/raw/main/run.sh
curl -fsSL -o /media/internal/downloads/PPLGPwn/stage1.bin https://github.com/$repo/PPLGPwn/raw/main/stage1/$fmv/stage1.bin
curl -fsSL -o /media/internal/downloads/PPLGPwn/stage2.bin https://github.com/$repo/PPLGPwn/raw/main/stage2/$fmv/stage2.bin

echo "
interface=eth0
firmver=$fmv
stage1=/media/internal/downloads/PPLGPwn/stage1.bin
stage2=/media/internal/downloads/PPLGPwn/stage2.bin
" > /media/internal/downloads/PPLGPwn/settings.config

luna-send -a webosbrew -f -n 1 luna://com.webos.notification/createToast '{"sourceId":"webosbrew","message": "<b>PPLGPwn installed.</b>"}'

echo "Running PPLGPWN in 3 seconds..."
sleep 3

cd /media/internal/downloads/PPLGPwn
chmod +x ./run.sh

startup_cmd="cd /media/internal/downloads/PPLGPwn && chmod +x ./run.sh && ./run.sh"
startup_script="/var/lib/webosbrew/startup.sh"

# Check if the line already exists
if ! grep -Fxq "$startup_cmd" "$startup_script"; then
    echo "$startup_cmd" >> "$startup_script"
    echo "startup_cmd added to $startup_script."
else
    echo "startup_cmd already exists in $startup_script."
fi

./run.sh
exit 1
