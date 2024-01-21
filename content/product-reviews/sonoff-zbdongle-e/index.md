---
title: Sonoff ZBDongle-E
subtitle: Zigbee 3.0 USB Dongle Plus

intro: Quite powerful Zigbee USB stick with an external antenna. By default a coordinator. Can be flashed as a router.

notes:
  positive:
    - great wireless performance and link quality
    - quite solid build
    - quite nice for its size
    - flashable as Zigbee router
  negative:
    - quite long USB stick
    - even longer with the external antenna
    - standing out if placed in plain sight 
---

![Sonoff ZBDongle-E USB Stick with detached antenna](images/stick-with-detached-antenna.jpg)

## Functionality

Great wireless performance - wall penetration, signal coverage and link quality.

It can be used as a coordinator, or as a router by flashing a different firmware.

The external antenna can be rotated to make it radiate in desired direction. For this antenna type, the best radiation and reception is perpendicularly to the stick - donut-like radiation pattern. 

### As a coordinator

I've got only short experience yet - just recently repaired all devices to it. So far everything works as fine as with Aeotec Zi-Stick ZGA008.

![Zigbee2MQTT map with Sonoff ZBDongle-E as a coordinator, and two Sonoff ZBDongle-E as routers](images/zigbee2mqtt-map-with-sonoff-zbdongle-e-as-coordinator-and-two-sonoff-zbdongle-e-as-router.png)

The link quality between coordinator and routers placed at same position as before is better with Sonoff ZBDongle-E stick than with Aeotec. Zi-Stick

### As a router

Great so far - used it for a couple of weeks already. It is handling many end devices without issues.

![Zigbee2MQTT map with Aeotec Zi-Stick as a coordinator and one Sonoff ZBDongle-E as a router](images/zigbee2mqtt-map-with-zi-stick-as-coordinator-and-sonoff-zbdongle-e-as-router.png)

Disassembly is required for flashing and network repairing. Whether that's a pro or a con depends on use-case.

If you happen to run NixOS, I've prepared a document containing steps [how to flash it under NixOS](/how-to/flash-sonoff-zbdongle-e-as-router-under-nixos).

## Aesthetics

Quite big and bulky, which makes it to stand out if placed in plain sight. That's an expected cost to pay for a powerful Zigbee stick with an external antenna.

![Sonoff ZBDongle-E USB Stick with antenna](images/stick-with-antenna.jpg)

However, Sonoff made it look quite nice even if it's big and bulky.

## Internals

Disassembled device looks like this:

::image-gallery
![Sonoff ZBDongle-E Disassembled](images/stick-disassembled.jpg){caption="Disassembled"}
![Sonoff ZBDongle-E Board top side](images/stick-disassembled-board-top.jpg){caption="Board top side"}
![Sonoff ZBDongle-E Board bottom side](images/stick-disassembled-board-bottom.jpg){caption="Board bottom side"}
::

## Box and packaging

Solid nice paper box with a manual, stick and antenna inside:

::image-gallery
![Sonoff ZBDongle-E Box Front](images/box-front.jpg){caption="Box Front"}
![Sonoff ZBDongle-E Box Back](images/box-back.jpg){caption="Box Back"}
![Sonoff ZBDongle-E Box Contents](images/box-contents.jpg){caption="Box Contents"}
::

## Summary

I am happy to trade compactness for great performance and reliability.

Great as a router, if there is a space available, where it won't stand out.

Seems great as a coordinator, too.
