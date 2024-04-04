---
title: Automatically turn a touch monitor ON and OFF
subtitle: Using DDC/CI, with Raspberry Pi 5

intro: Some touch monitors, on a loss of the HDMI signal, shine the screen with the ugly-blue background. This happens in X's and Wayland's standby, suspend and off DPMS modes. The DDC/CI might come to rescue.
---

## Prerquisites

## Preparation

Prepare following:

- download the firmware from [itead's github](https://github.com/itead/Sonoff_Zigbee_Dongle_Firmware/tree/master/Dongle-E/Router),
- disassembly the device:
  - access to board's buttons is needed,
- figure out `/dev/ttyXXX` under which device becomes available - see constants to modify below.

## DDC/CI screen off functionality test

Discovery of DPMS control via DCC/CI can be done by:

```shell
ddcutil vcpinfo D6 --verbose
```

And, if monitor supports it, the output should be something like this:

```
VCP code D6: Power mode
   DPM and DPMS status
   MCCS versions: 2.0, 2.1, 3.0, 2.2
   MCCS specification groups: Control, Miscellaneous
   ddcutil feature subsets: 
   Attributes: Read Write, Non-Continuous (simple)
   Simple NC values:
      0x01: DPM: On,  DPMS: Off
      0x02: DPM: Off, DPMS: Standby
      0x03: DPM: Off, DPMS: Suspend
      0x04: DPM: Off, DPMS: Off
      0x05: Write only value to turn off display
   Simple NC values:
      0x01: DPM: On,  DPMS: Off
      0x02: DPM: Off, DPMS: Standby
      0x03: DPM: Off, DPMS: Suspend
      0x04: DPM: Off, DPMS: Off
      0x05: Write only value to turn off display
```

If output of VCP info looks good, on/off can be tested by:

```shell
ddcutil setvcp D6 0x02; sleep 10s; ddcutil setvcp D6 0x01
```

**Warning:** this bypasses X server and wayland compositor, and therefore reset back to 0x01 needs to be done manually. The example command resets it back after waiting for 10s. Just, make sure you copy and paste the full command as one-liner.

## Automatic DDC/CI commands execution when system is idle, and when is active again

The solution is composed of 2 parts:

- a helper C program to get inactivity time,
- a control script to periodically check for (in)activity.

Source of the helper C program:

```c
#include <X11/extensions/scrnsaver.h>
#include <stdio.h>

int main(void) {
    Display *dpy = XOpenDisplay(NULL);

    if (!dpy) {
        return(1);
    }

    XScreenSaverInfo *info = XScreenSaverAllocInfo();
    XScreenSaverQueryInfo(dpy, DefaultRootWindow(dpy), info);
    printf("%u\n", info->idle);

      return(0);
}
```

Compile with:

```shell
gcc -o getIdle getIdle.c -lXss -lX11
```

Source of the script to monitor activity, and execute DDC/CI and i3 commands:

```shell
#!/bin/bash

idle=false
idleAfter=90000

while true; do
  idleTimeMillis=$(./getIdle)
  
  if [[ $idle = false && $idleTimeMillis -gt $idleAfter ]] ; then
    i3lock -c 000000 &
    ddcutil setvcp D6 0x02
    idle=true
  fi

  if [[ $idle = true && $idleTimeMillis -lt $idleAfter ]] ; then
    ddcutil setvcp D6 0x01
    sleep 3s
    pkill i3lock
    idle=false
  fi
  sleep 0.1s

done
```

Don't forget to make it executable:

```shell
chmod +x ./idle-monitor.sh
```

## Full smart home control panel setup

To make `idle-monitor.sh` and a fullscreen browser with a web app (kiosk) start automatically, create `~/.config/lxsession/LXDE-pi/autostart`:

```shell
@lxpanel --profile LXDE-pi
@pcmanfm --desktop --profile LXDE-pi

@/path/to/idle-monitor.sh
@chromium-browser http://url-of-the-fullscreen-app/ --kiosk --noerrdialogs --disable-infobars --no-first-run --enable-features=OverlayScrollbar --start-maximize
```

