#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color


if [ -z "$1" ]
  then
    echo -e "${RED}Please specify an interface ie: ./thisscript.sh wlan0${NC}"
    exit 1
fi

echo -e "${GREEN}[+] SETTING TX POWER TO 30db${NC}"
iw reg set US
echo -e "${RED}[+] Killing non needed services${NC}"
airmon-ng check kill
echo -e "${GREEN}[+] STARTING ${1} IN MONITOR MODE${NC}"
airmon-ng start ${1}
echo -e "${RED}[+] SETTING ${1}MON DOWN FOR MAC CHANGER....${NC}"
ifconfig ${1}mon down
echo -e "${RED}[+] CHANGING MAC ADDRESS${NC}"
macchanger -r ${1}mon
echo ""
echo -e "${GREEN}[+] BRINGING UP ${1}${NC}"
ifconfig ${1}mon up
echo -e "${GREEN}[+] Check that the tx-power is 30 dBm before continuing, else check the setup..${NC}"
iwconfig ${1}mon

sleep 3
echo -e "${GREEN}"

while true; do
    read -p "[+] Do you want to start airodump-ng? [Y/N/Q]" ynq
    case $ynq in
        [yY]* )  
            echo -e "${GREEN}[+] Starting airodump-ng${NC}"
            airodump-ng ${1}mon --wps --manufacturer
            break
            ;;
        [nN]* )
            echo -e "${RED}[-] airodump-ng not required, exiting...${NC}"
            break
            ;;
        [qQ]*)
            echo -e "${RED}[-] Exiting the program...${NC}"
            break
            ;;
        * ) echo -e "${RED}[-] Please answer yes or no.${NC}";;
    esac
done
