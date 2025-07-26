---
title: Flash Sonoff ZBDongle-E as router under NixOS

intro: Sonoff ZBDongle-E is quite powerful Zigbee dongle. By default, it's loaded with coordinator firmware. This how to article contains steps cheatsheet to flash it with router firmware under NixOS.
---

## Preparation

Prepare following:

- download the firmware from [itead's github](https://github.com/itead/Sonoff_Zigbee_Dongle_Firmware/tree/master/Dongle-E/Router),
- disassembly the device:
  - access to board's buttons is needed,
- figure out `/dev/ttyXXX` under which device becomes available - see constants to modify below.

## Modify constants in commands

Flashing steps contain constants, which vary in different environments, or after some time:

- `/dev/ttyFIGURE_OUT`:
  - location of `tty` device for the Sonoff ZBDongle-E,
  - figure out via - simple way:
    1. run `ls -ld /dev/tty*`,
    2. connect the device,
    3. run `ls -ld /dev/tty*` again,
    4. find the difference - new line for the device,
- `Z3RouterUSBDonlge_EZNet6.10.3_V1.0.0.gbl`:
  - firmware file name - will change if a new version is released.

## Steps

With prerequisites prepared, flashing can be performed using following steps:

1. connect the board to computer:
   - extension cable can make it more convenient to access buttons on the board, 

2. connect to device's serial:

   ```shell
   nix-shell -p putty 
   
   sudo putty -serial -sercfg 115200,8,n,1 /dev/ttyFIGURE_OUT
   ``` 
   
3. enter bootloader mode:
 
   1. press and hold BOOT, 
   2. then press RST, 
   3. then release BOOT,

4. perform upload:

   1. open another terminal:
      ```shell
      nix-shell -p lrzsz
      
      cd directory/containing/the-firmware/in-it
      ```
   2. confirm upload start via putty:
      - press 1 to selecting "upload gbl"
   3. execute the upload in terminal - run:
      ```shell
      sudo bash -c 'sx Z3RouterUSBDonlge_EZNet6.10.3_V1.0.0.gbl < /dev/ttyFIGURE_OUT > /dev/ttyFIGURE_OUT'
      ```
   4. wait for completion: 
      ```shell
      Sending Z3RouterUSBDonlge_EZNet6.10.3_V1.0.0.gbl, 2244 blocks: Give your local XMODEM receive command now.
      Bytes Sent: 287360   BPS:9008

      Transfer complete
      ```

5. pairing:

   1. reboot board by pressing "2" in putty to select "run",
   2. enable pairing mode for your Zigbee network,
   3. wait for Sonoff ZBDongle-E to pair,
   4. turn off pairing mode for the Zigbee network.

6. unplug the board, and assembly it back.

