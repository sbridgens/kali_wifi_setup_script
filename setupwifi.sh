#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[+] SETTING TX POWER TO 30db${NC}"
iw reg set US
echo -e "${RED}[+] Killing non needed services${NC}"
airmon-ng check kill
echo -e "${GREEN}[+] STARTING WLAN0 IN MONITOR MODE${NC}"
airmon-ng start wlan0
echo -e "${RED}[+] SETTING WLAN0MON DOWN FOR MAC CHANGER....${NC}"
ifconfig wlan0mon down
echo -e "${RED}[+] CHANGING MAC ADDRESS${NC}"
macchanger -r wlan0mon
echo ""
echo -e "${GREEN}[+] BRINGING UP WLAN0${NC}"
ifconfig wlan0mon up
echo -e "${GREEN}[+] Check that the tx-power is 30 dBm before continuing, else check the setup..${NC}"
iwconfig wlan0mon

sleep 3
echo -e "${GREEN}"

while true; do
    read -p "[+] Do you want to start airodump-ng? [Y/N/Q]" ynq
    case $ynq in
        [yY]* )  
            echo -e "${GREEN}[+] Starting airodump-ng${NC}"
            airodump-ng wlan0mon --wps --manufacturer
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
