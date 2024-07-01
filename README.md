![pplgpwn_logo](https://github.com/llbranco/PPLGPwn/assets/5321071/17491e46-3b61-4d2b-ba56-5e5bbc7894f3)
# PPLGPwn

A method of running PPPwn on rooted LG TV's.
This method uses the C++ version of PPPwn, made by xfangfang, the link to the repo it's this one:
https://github.com/xfangfang/PPPwn_cpp

>[!IMPORTANT]
>`LIMITED SUPPORT` to [Fox Electronics](https://foxelectronics.rs/) with WebOS
> (thx to **Aljelja** for the feedback)

It provides a new way to jailbreak your PS4, using a rooted LG TV.
For more information on which firmwares are supported, check out the link above.

## If you liked my project and want to help me, consider buying me a coffee
<a href='https://ko-fi.com/J3J4Y2DQ4' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi2.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a> [![Support me on Patreon](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fshieldsio-patreon.vercel.app%2Fapi%3Fusername%3Dllbranco%26type%3Dpatrons&style=flat-square)](https://patreon.com/llbranco)

## Changes compared to [zauceee/PPLGPwn](https://github.com/zauceee/PPLGPwn) and [FabulosoDev/PPLGPwn](https://github.com/FabulosoDev/PPLGPwn)
- use curl instead of wget to download files
- automatic download of stage1.bin & stage2.bin based on chosen PS4 firmware version (thx to FabulosoDev for that)
- Sistro's stage2

Special thanks to [@TheOfficialFloW](https://github.com/TheOfficialFloW) [@SiSTR0](https://github.com/SiSTR0) [@xfangfang](https://github.com/xfangfang) [@zauceee](https://github.com/zauceee) [@FabulosoDev](https://github.com/FabulosoDev) [@PSGO](https://github.com/PSGO) and all contributors.

## Requirements
- [Rooted LG TV](https://www.webosbrew.org/rooting/)
- Ethernet cable
- Device to connect to the TV through SSH (PC: [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) or [WebOS Dev Manager](https://github.com/webosbrew/dev-manager-desktop) / Android: [ConnectBot](https://play.google.com/store/apps/details?id=org.connectbot)])
- default ssh password: `alpine`
- [follow this if you can't log in](https://gist.github.com/throwaway96/e811b0f7cc2a705a5a476a8dfa45e09f)

## Video Guides (outdated but still work) thx to [Michael Crump](https://www.youtube.com/@mbcrump) and [Modded Warfare](https://www.youtube.com/@MODDEDWARFARE) to sharing our project
[![guide](https://img.youtube.com/vi/BIeljeDINqk/0.jpg)](https://www.youtube.com/watch?v=BIeljeDINqk)[![guide](https://img.youtube.com/vi/zYoesrUsIj8/0.jpg)](https://www.youtube.com/watch?v=zYoesrUsIj8)


## Jailbreaking your LG TV
To run PPLGPwn you'll need to root your LG TV, the root itself it supported by a couple of models, check both exploits to see if your TV is capable of doing so, more steps on how to root it and enable SSH aswell are available there:
#### [Dejavuln](https://github.com/throwaway96/dejavuln-autoroot)
#### [Root my TV](https://rootmy.tv/) All firmware released since mid-2022 is patched to this method.

## Install & run PPLGPwn

After jailbreaking your own TV (ironically, we are using a jailbroken TV to jailbreak another device 😁), you need to connect to your TV via SSH and download and run `install.sh` using this command:

```
curl -fsSLO https://github.com/llbranco/PPLGPwn/raw/main/install.sh && chmod +x ./install.sh && ./install.sh
```

### On your PS4:
1. Connect your PS4 to your TV using the Ethernet port

2. Go to `Settings` and then `Network`

3. Select `Set Up Internet connection` and choose `Use a LAN Cable`

4. Choose `Custom` setup and choose `PPPoE` for `IP Address Settings`

5. Enter anything for `PPPoE User ID` and `PPPoE Password`

6. Choose `Automatic` for `DNS Settings` and `MTU Settings`

7. Choose `Do Not Use` for `Proxy Server`

8. Press the `X` button on your controller on `Test Internet Connection`

ALWAYS wait for your console to display the message `Cannot connect to network: (NW-31274-7)` before attempting this PPPOE injection again.

If the exploit fails or the PS4 crashes, you can skip the internet setup and just click on `Test Internet Connection`.

If the exploit works, you should see an output via SSH similar to the following. In addition you should see `Cannot connect to network` followed by `PPPwned` displayed as notification on your PS4, or vice versa.

```sh
[+] PPPwn - PlayStation 4 PPPoE RCE by theflow
[+] args: interface=enp0s3 fw=1100 stage1=stage1/stage1.bin stage2=stage2/stage2.bin

[+] STAGE 0: Initialization
[*] Waiting for PADI...
[+] pppoe_softc: 0xffffabd634beba00
[+] Target MAC: xx:xx:xx:xx:xx:xx
[+] Source MAC: 07:ba:be:34:d6:ab
[+] AC cookie length: 0x4e0
[*] Sending PADO...
[*] Waiting for PADR...
[*] Sending PADS...
[*] Waiting for LCP configure request...
[*] Sending LCP configure ACK...
[*] Sending LCP configure request...
[*] Waiting for LCP configure ACK...
[*] Waiting for IPCP configure request...
[*] Sending IPCP configure NAK...
[*] Waiting for IPCP configure request...
[*] Sending IPCP configure ACK...
[*] Sending IPCP configure request...
[*] Waiting for IPCP configure ACK...
[*] Waiting for interface to be ready...
[+] Target IPv6: fe80::2d9:d1ff:febc:83e4
[+] Heap grooming...done

[+] STAGE 1: Memory corruption
[+] Pinning to CPU 0...done
[*] Sending malicious LCP configure request...
[*] Waiting for LCP configure request...
[*] Sending LCP configure ACK...
[*] Sending LCP configure request...
[*] Waiting for LCP configure ACK...
[*] Waiting for IPCP configure request...
[*] Sending IPCP configure NAK...
[*] Waiting for IPCP configure request...
[*] Sending IPCP configure ACK...
[*] Sending IPCP configure request...
[*] Waiting for IPCP configure ACK...
[+] Scanning for corrupted object...found fe80::0fdf:4141:4141:4141

[+] STAGE 2: KASLR defeat
[*] Defeating KASLR...
[+] pppoe_softc_list: 0xffffffff884de578
[+] kaslr_offset: 0x3ffc000

[+] STAGE 3: Remote code execution
[*] Sending LCP terminate request...
[*] Waiting for PADI...
[+] pppoe_softc: 0xffffabd634beba00
[+] Target MAC: xx:xx:xx:xx:xx:xx
[+] Source MAC: 97:df:ea:86:ff:ff
[+] AC cookie length: 0x511
[*] Sending PADO...
[*] Waiting for PADR...
[*] Sending PADS...
[*] Triggering code execution...
[*] Waiting for stage1 to resume...
[*] Sending PADT...
[*] Waiting for PADI...
[+] pppoe_softc: 0xffffabd634be9200
[+] Target MAC: xx:xx:xx:xx:xx:xx
[+] AC cookie length: 0x0
[*] Sending PADO...
[*] Waiting for PADR...
[*] Sending PADS...
[*] Waiting for LCP configure request...
[*] Sending LCP configure ACK...
[*] Sending LCP configure request...
[*] Waiting for LCP configure ACK...
[*] Waiting for IPCP configure request...
[*] Sending IPCP configure NAK...
[*] Waiting for IPCP configure request...
[*] Sending IPCP configure ACK...
[*] Sending IPCP configure request...
[*] Waiting for IPCP configure ACK...

[+] STAGE 4: Arbitrary payload execution
[*] Sending stage2 payload...
[+] Done!
```

## Run PPLGPwn when the TV boot
1. edit this file to make the script runs on boot using `vi`
```
/var/lib/webosbrew/startup.sh
```
2.
insert this lines in the last line save and reboot the tv
```
cd /media/internal/downloads/PPLGPwn
./run.sh
```
If you updated from my previous version, I noticed that you **must update** the start path


## Run PPLGPwn with a single press on your TV remote
1. Head to the [Homebrew Store](https://www.webosbrew.org/) app and download [LG Input Hook](https://repo.webosbrew.org/apps/org.webosbrew.inputhook/)

2. Open the LG Input Hook and go to the link the app gives you in a device that has a web browser (you can also do this on your TV, but it will take longer)

3. Set this custom `Execute` action on any button you'd like:

```
cd /media/internal/downloads/PPLGPwn && chmod +x ./run.sh && ./run.sh
```   

4. Save your changes

**And done!** The button you set up with the custom action will now execute the exploit every time you press it!

## Start using your PS4 browser
1. edit the run.sh and insert `--web`
2. in your ps4 browser go to `http://YOUR_TV_IP:7796` and press START

## How to run GoldHEN on PS4 9.00 / 11.00 using PPLGPwn
1. Download `goldhen.bin` from [goldhen directory](https://github.com/llbranco/PPLGPwn/tree/main/goldhen_USB) 

2. Copy it to the root of an USB stick (formatted as FAT32 or exFAT)  
(Do NOT rename it! The name should be exactly `goldhen.bin`)

3. Plug the USB stick into your PS4
    
4. Run the PPPwn exploit  
    At this point this should automatically:
    1. run PPPwn stage1.bin

    2. trigger stage2.bin from SiSTR0 which will look for `goldhen.bin` on the inserted USB stick

    3. stage2.bin will (automaticaly) copy `goldhen.bin` from the USB stick to `/data/GoldHEN/payloads/goldhen.bin` to your console's hard drive. (again: it's auto, u don't need to do it manually)

         **Note:** From this point on, you shouldn't need the USB stick the next time you want to run the exploit, as you now have a local copy of goldhen on your hard drive.  
        (If you use the USB stick in the future, it will overwrite the local copy again. Probably useful for updates of goldhen etc.)
        
    4. GoldHEN should start at this point

## Articles
[Wololo](https://wololo.net/2024/05/14/pplgpwn-hack-your-ps4-with-your-tv/),
[Tom's Hardware](https://www.tomshardware.com/video-games/playstation/new-playstation-4-jailbreak-accomplished-using-select-lg-smart-tvs-running-webos),
[Hackaday](https://hackaday.com/2024/05/16/you-can-now-jailbreak-a-ps4-with-an-lg-tv/),
[Adrenaline](https://www.adrenaline.com.br/games/tvs-da-lg-com-jailbreak-podem-desbloquear-o-ps4/),
[Tudo Celular](https://www.tudocelular.com/tech/noticias/n221413/lg-tv-jailbreak-desbloqueio-ps4.html),
[Guru3d](https://www.guru3d.com/story/exploiting-lg-smart-tvs-to-jailbreak-playstation-4-a-new-methodology/),
[Hackster](https://www.hackster.io/news/this-hack-is-a-game-changer-9e6cf59f82ed),
[Kotaku](https://kotaku.com/ps4-playstation-4-jailbreak-hack-lg-smart-tv-method-1851485229)

# Plans
- better sh installer, web installer or usb installer (need a lot of research)
- an option on the installer to choose between: "Start on boot", "web server", "mapped key on your remote" or "manual start"
- Notifications on your tv on/off (config on install)
- Route TV WiFi to PS4
- option to choose between: GoldHen, VTX-Hen and/or GoldHen Lite

# NOTES
**!! This exploit is made for LG TV's or Fox TV's with the armv7/aarch64 architecture, I'm not sure if it works on other architectures or brands !!**

To find out your TV chip architecture connect to your TV via SSH and run `uname -m`

Thanks to the OpenLGTV and RootMyTV communities for giving us this LG TV jailbreak.  
Thanks also to everyone in the PS4 jailbreaking community who gave us the exploits!
And also thanks to all the contributors!

# Personal Note
I'm having some difficulties (in my personal life) that are preventing me from providing more frequent updates to the project... I'm struggling to deliver a functional autoupdate.

Once the autoupdate is functional I intend to bring improvements to the code and other initialization options (NATIVE, I hope... even if not at first) of the script.

TL;DR:

My personal life is a complete mess, and the little free time I have to study shell script (that's right, I barely know shell script) is constantly interrupted by shouts, horns, and motorcycles with modified exhaust pipes making noise every 5 minutes or less, thanks to the most "demonic" and uncivilized neighbors you can imagine.

I haven't been able to get a good night's sleep in... gosh, I don't even know how long... 3 or 4 years maybe.

The only device I have to test is my TV, which I also use as a monitor for my PC, being my ONLY SCREEN! Bricking is not an option.

I need more storage; my PC's hard drive is failing with a SMART error, and I'm broke. I don't have the money to invest in a new hard drive or more RAM.

To maintain the little sanity I have left, I use the little free time I have to play games.

I thank everyone for their understanding... and please make my neighbors shut up!
