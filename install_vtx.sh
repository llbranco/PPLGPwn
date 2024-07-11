clear 
repo=llbranco
default_dir=/media/internal/downloads/PPLGPwn-vtx
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
888        888        88888888 Y8888P88  888        888P     Y888 888    Y888${NC}${RED}VTX
${NC}

Designed for LG webOS TVs! Ported by ${PURPLE}Kodeine${NC} & ${PURPLE}Contributors${NC}, with ${RED}luv <3${NC}
Version: v1.3 VTX (${BLUE}modded by llbranco${NC})

${CYAN}-------
INSTALLATION
-------${NC}
"

echo "
thanks to FabulosoDev this installer is based on his installer v1.2...

this installer shouldn't overwrite the vanilla PPLGPwn
but create a second directory instead

please report any issue 
"

reinstall=false
cpu_arch=$(uname -m)


# Function to handle removal and reinstallation
    echo "Removing $1 to reinstall..."
    pkill -f "pppwn"
    pkill -f "pppwn_$cpu_arch"
    rm -rf "$1"
    reinstall=true
    echo "Done!"

# Array of directories to check
array_dir=("$default_dir" "/media/internal/downloads/PPLGPwn-main")

# Loop through directories
for dir in "${array_dir[@]}"; do
    if [ -d "$dir" ]; then
        read -p "$(basename "$dir") already installed. Reinstall? [Y/N] " response
        case "$response" in
            [yY][eE][sS]|[yY])
                reinstall_pppwn "$dir"
                ;;
        esac
    else
        reinstall=true
    fi
done

#(re)install
if [ "$reinstall" = true ]
then
cpu_arch=`uname -m`
if [ $cpu_arch = "armv7" ] || [ $cpu_arch = "armv7l" ]
then
cpu_arch='armv7'
elif [ $cpu_arch = "aarch64" ]; then
cpu_arch='aarch64'
else 
echo "
Unsupported CPU architecture, please report onto the issues tab in the GitHub repo with your cpu arch!
Cpu architecture = $cpu_arch
"
return
fi

echo -e "

${CYAN}-------
Supported firmwares for PS4Hen-VTX
700 701 702 750 751 755 800 801
803 850 852 900 903 904 950 951
960 1000 1001 1050 1070 1071 1100

Choose firmware version...
-------${NC}
"
read -p "Firmware version (700-1100): " fmv
echo -e "

${CYAN}-------
Downloading files...
-------${NC}
"

# autodetect your lan interface
# this make our script compatible with more webos devices rather than just LG
# credits: https://serverfault.com/questions/842964/bash-script-to-retrieve-name-of-ethernet-network-interface
# with a little update to remove any empty space
lan_link=$(ip link | awk -F: '$0 !~ "lo|vir|^[^0-9]"{gsub(/^[ \t]+/, "", $2); print $2; getline}')


mkdir -p $default_dir
curl -fsSL -o $default_dir/pppwn https://github.com/$repo/PPLGPwn/raw/main/pppwn_$cpu_arch
curl -fsSL -o $default_dir/run.sh https://github.com/$repo/PPLGPwn/raw/main/run_vtx.sh
curl -fsSL -o $default_dir/stage1.bin https://github.com/$repo/PPLGPwn/raw/main/stage1/$fmv/stage1.bin
curl -fsSL -o $default_dir/stage2.bin https://github.com/$repo/PPLGPwn/raw/main/ps4hen/$fmv/stage2.bin

echo -e "Done!

${CYAN}-------
Writing settings...
-------${NC}
"

echo "
interface=$lan_link
firmver=$fmv
stage1=$default_dir/stage1.bin
stage2=$default_dir/stage2.bin
" > $default_dir/settings.config
echo "Done!
"
echo "If you wish to change the stage2.bin go into $default_dir and replace the exisiting stage2.bin!
"
echo "To run the exploit execute "run.sh" present in the mentioned directory! But to make it simplier follow the steps to execute the exploit with the click of a button! :)"
echo "Enjoy ;)"

luna-send -a webosbrew -f -n 1 luna://com.webos.notification/createToast '{"sourceId":"webosbrew","message": "<b>PPLGPwn PS4Hen-VTX installed.</b>"}'
fi
#(re)install end

echo "Running PPLGPWN-VTX in 3 seconds..."
sleep 3

cd $default_dir
chmod +x ./run.sh
./run.sh
