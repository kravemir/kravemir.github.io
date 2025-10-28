---
title: Automatically turn ON and OFF a touch monitor
subtitle: Via DDC/CI protocol, based on activity in X11 using XSS lib, on Raspberry Pi 5

date: 2024-04-07T13:08:05+02:00

description: Guide on how to setup automatic on and off of a touch screen for power saving, without a blue screen on a loss of HDMI signal.

intro: |
  Some touch monitors shine with a bright blue background after HDMI signal is lost, which is a disturbing effect in certain use-cases.

  This can happen in X's and Wayland's standby, suspend and off DPMS modes. Which makes this power saving method to not be a fully pleasant solution for smart home control panels.

  The DDC/CI, if monitor supports it, might be used to avoid the blue screen effect. And, this how to article describes the solution based on DDC/CI for Raspberry Pi 5 running X11 display server.
---

## Prerequisites

A fully working setup and installation is prepared with following components:

- Raspberry Pi 5 board,
- Raspberry Pi OS, 64-bit, based on Debian 12 (bookworm),
- Touch Monitor connected via HDMI and USB (touch support).

_**Note - board:** a different Raspberry Pi model might work, but this how to was not tested on them._

_**Note - OS:** a different distro or version can work, but would require some adjustments for auto-start. This article assumes default setup of the system based on OS above._

_**Note - display:** this setup is fully working with [this touch screen monitor from AliExpress](https://www.aliexpress.com/item/1005003626235738.html). I like it shipped from within the EU (no extra customs fees). It was cheaper on the sale though, but there are similarly looking alternatives, but might differ in internals (?). I have also ordered and tried the [16" very slim touch screen monitor from AliExpress](https://www.aliexpress.com/item/1005006397448866.html?), but this has defunct touch functionality, and embedded circuitry (guessing - voltage transformer) is making whining noise. If not for those issues, it would have been the perfect -one for the use case, because it's very slim and has recessed connectors._

## Preparation

Install dependencies:

- `ddcutil` - utility to control monitors via DDC/CI,
- `i3lock` - a simple screen saver to capture touches until screen comes back on - to not propagate touches to an app while screen is still not on.
- `libxss-dev` - header files for X11 screen saving - needed to compile utility in C.

```shell
sudo apt install ddcutil i3 libxss-dev
```

Optional:

- enable SSH via `raspi-config` for easy access to the machine in a case, that the monitor stays off.

## DDC/CI screen off functionality test

Discovery of presence of DPMS control via DCC/CI can be done by:

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

If the output of VCP info looks good, on/off can be tested by:

```shell
ddcutil setvcp D6 0x02; sleep 10s; ddcutil setvcp D6 0x01
```

**Warning:** this bypasses X server and wayland compositor, and therefore reset back to 0x01 needs to be done manually. The example command resets it back after waiting for 10s. Just, make sure you copy and paste the full command as one-liner.

## Automatic DDC/CI commands execution when system is idle, and when is active again

The custom solution is composed of 2 parts:

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

Make it executable:

```shell
chmod +x ./idle-monitor.sh
```

Test it:

```shell
./idle-monitor.sh
```

## Full smart home control panel setup

To make `idle-monitor.sh` and a fullscreen browser with a web app (kiosk / smart home control panel) start automatically, create `~/.config/lxsession/LXDE-pi/autostart`:

```shell
@lxpanel --profile LXDE-pi
@pcmanfm --desktop --profile LXDE-pi

@/path/to/idle-monitor.sh
@chromium-browser http://url-of-the-fullscreen-app/ --kiosk --noerrdialogs --disable-infobars --no-first-run --enable-features=OverlayScrollbar --start-maximize
```

## References

Thanks to knowledge shared in other sources:

1. [The answer in Unix & Linux S/E](https://unix.stackexchange.com/a/122816/13428) for how to run command when system is idle and when is active again.
