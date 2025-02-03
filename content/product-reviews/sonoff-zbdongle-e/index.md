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

coverImage: stickWithAntenna

images:
  stickWithoutAntenna:
    alt: Sonoff ZBDongle-E USB Stick with detached antenna
    image: images/stick-with-detached-antenna.jpg
  stickWithAntenna:
    alt: Sonoff ZBDongle-E USB Stick with antenna
    image: images/stick-with-antenna.jpg
  sonoffAsCoordinator:
    alt: Zigbee2MQTT map with Sonoff ZBDongle-E as a coordinator, and one Sonoff ZBDongle-E as routers
    image: images/zigbee2mqtt-map-with-sonoff-zbdongle-e-as-coordinator-and-one-sonoff-zbdongle-e-as-router.png

imageGallery:
  comparison:
    - name: Zigbee2MQTT map with Aeotec Zi-Stick as a coordinator with many routers,
      image: images/zigbee2mqtt-map-with-zi-stick-as-coordinator-and-sonoff-zbdongle-e-as-router.described.png
      caption: Aeotec Zi-Stick coordinator with many routers
    - name: Zigbee2MQTT map with Sonoff ZBDongle-E as a coordinator with many routers
      image: images/zigbee2mqtt-map-with-sonoff-zbdongle-e-as-coordinator-and-two-sonoff-zbdongle-e-as-router.described.png
      caption: Sonoff ZBDongle-E coordinator with many routers
    - name: Zigbee2MQTT map with Sonoff ZBDongle-E as a coordinator with little routers,
      image: images/zigbee2mqtt-map-with-sonoff-zbdongle-e-as-coordinator-and-one-sonoff-zbdongle-e-as-router.described.png
      caption: Sonoff ZBDongle-E with little routers
  internals:
    - name: Sonoff ZBDongle-E Disassembled
      image: images/stick-disassembled.jpg
      caption: Disassembled
    - name: Sonoff ZBDongle-E Board top side
      image: images/stick-disassembled-board-top.jpg
      caption: Board top side
    - name: Sonoff ZBDongle-E Board bottom side
      image: images/stick-disassembled-board-bottom.jpg
      caption: Board bottom side
  boxAndPackaging:
    - name: Sonoff ZBDongle-E Box Front
      image: images/box-front.jpg
      caption: Box Front
    - name: Sonoff ZBDongle-E Box Back
      image: images/box-back.jpg
      caption: Box Back
    - name: Sonoff ZBDongle-E Box Contents
      image: images/box-contents.jpg
      caption: Box Contents
---

::content-image{:alt="images.stickWithoutAntenna.alt" :image="images.stickWithoutAntenna.image"}
::

## Functionality

Great wireless performance - wall penetration, signal coverage and link quality.

The external antenna can be rotated to make it radiate in desired direction. For this antenna type, the best radiation and reception is perpendicularly to the stick - donut-like radiation pattern. 

It can be used as a coordinator, or as a router by flashing a different firmware.

::content-image{:alt="images.sonoffAsCoordinator.alt" :image="images.sonoffAsCoordinator.image"}
::

It performs well in both roles - as a router, and as a coordinator.

### As a coordinator

It performs well as a coordinator. Maintains stable network even with low amount of routers, and devices aren't loosing a link.

The link quality between coordinator and routers placed at same position as before is better with Sonoff ZBDongle-E stick than with Aeotec Zi-Stick ZGA008.

### As a router

Great so far - used it for a couple of weeks already. It is handling many end devices without issues.

Disassembly is required for flashing and network repairing. Whether that's a pro or a con depends on use-case.

If you happen to run NixOS, I've prepared a document containing steps [how to flash it under NixOS](/how-to/flash-sonoff-zbdongle-e-as-router-under-nixos).

### Comparison Aeotec Zi-Stick ZGA008

It performs much better than Aeotec Zi-Stick ZGA008 as a coordinator.

The Zi-Stick wasn't properly maintaining links to devices, if there wasn't "enough" routers. Even if battery powered devices were in reach of Sonoff ZBDongle-E used as a router, they sometimes lose their link if an extra router isn't added, even if that router doesn't have any links to end devices itself, and all routers can reach coordinator directly.

The issue encountered with Zi-Stick didn't appear for Sonoff ZBDongle-E. On contrary, I even removed Moes USB Repeater, and devices linked to it automatically roamed to the ZBDongle-E router or to the ZBDongle-E coordinator.

::image-gallery{:items="imageGallery.comparison"}
::

## Aesthetics

Quite big and bulky, which makes it to stand out if placed in plain sight. That's an expected cost to pay for a powerful Zigbee stick with an external antenna.

::content-image{:alt="images.stickWithAntenna.alt" :image="images.stickWithAntenna.image"}
::

However, Sonoff made it look quite nice even if it's big and bulky.

## Internals

Disassembled device looks like this:

::image-gallery{:items="imageGallery.internals"}
::

## Box and packaging

Solid nice paper box with a manual, stick and antenna inside:

::image-gallery{:items="imageGallery.boxAndPackaging"}
::

## Tips

Can be hidden behind a TV in [combination with APC SurgeArrest PM1WU2-FR](/product-combos/sonoff-zbdongle-e-on-apc-pm1wu2-fr).

## Summary

I am happy to trade compactness for great performance and reliability.

Great as a router, if there is a space available, where it won't stand out.

Seems great as a coordinator, too.
