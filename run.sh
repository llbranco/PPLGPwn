clear

RED='\033[0;91m'
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
BLUE='\033[0;94m'
PURPLE='\033[0;95m'
CYAN='\033[0;96m'
NC='\033[0m' # No Color
. /media/internal/downloads/PPLGPwn/settings.config
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
Version: v1.3 (${BLUE}by llbranco${NC})

${CYAN}-------
RUNNING
-------${NC}
"
luna-send -a webosbrew -f -n 1 luna://com.webos.notification/createToast '{"sourceId":"webosbrew","message": "<b>PPLGPwn!</b><br/>Starting your Jailbreak.<br/>by:  llbranco, kodeine & contributors"}'

chmod +x ./pppwn
./pppwn --interface $interface --fw $firmver --stage1 $stage1 --stage2 $stage2 --auto-retry -nw
echo "./pppwn --interface $interface -fw $firmver --stage1 $stage1 --stage2 $stage2 --auto-retry -nw"

luna-send -a webosbrew -f -n 1 luna://com.webos.notification/createToast '{"sourceId":"webosbrew","message": "<h3>PPLGPwned!</h3><br/>Done, enjoy! ;)"}'
