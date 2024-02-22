---
title: Nous E6
subtitle: Smart ZigBee LCD Temperature and Humidity Sensor

intro: |
  Cool little Zigbee temperature and humidity sensor with display, working on rechargeable 2xAAA batteries.

notes:
  positive:
    - displays clock
    - embedded magnet in top half of the back
    - AAA batteries
    - rechargeable NiMH work fine
  negative:
    - missing reporting options (min/max interval)
    - battery type is not detected, nor configurable, but assumed as alkaline
    - skewed percentage report for rechargeable NiMH batteries

images:
  frontPoweredOn:
    alt: Nous E6 powered on
    image: images/front-powered.jpg
  openedBack:
    alt: Nous E6 with opened back battery compartment
    image: images/back-opened.jpg
  packageFrontAndBack:
    alt: Nous E6 box front and back
    image: images/package-front-back.jpg
  boxContents:
    alt: Nous E6 box contents
    image: images/package-contents.jpg
  batteryDischargeCurveWith550mahEneloopLiteBatteries:
    alt: Nous E6 battery discharge curve with 550 mAh eneloop lite batteries
    image: images/battery-discharge-curve-with-550mah-eneloop-lite-batteries.jpg
---

::content-image{:alt="images.frontPoweredOn.alt" :image="images.frontPoweredOn.image"}
::

## Precision

I did test accuracy only briefly. Together with other sensor on a shelf, multiple units of E6 were usually +/- of 0.2°C from average of all sensors tested together.

Nous E6 seems to be good on measuring the air temperature, and it doesn't cling too much towards the temperature of furniture/wall temperature it is placed on.

Notes:

- the accuracy of room temperature reading is much more affected by correct or incorrect placement within the room, than by inaccuracy of the sensor itself.
- some sensors with official +/- of 0.2°C precision on the paper were actually measuring much more the temperature of furniture instead of the air temperature:
  - test - when window was opened when cold outside, some models of sensors went down immediately by 1°C and others just by 0.2°C.


## Power

Device is powered by two AAA batteries.

::content-image{:alt="images.openedBack.alt" :image="images.openedBack.image"}
::

Rechargeable 1.2V NiMH batteries work fine. I love this fact, because I am not producing waste by early replacement of batteries, when I want to be sure, that sensor used in automations won't go dead in a bad moment.

Unfortunately, device doesn't detect battery type is automatically - Alkaline vs NiMH. This results in skewed percentage report for rechargeable battiers - percentage calculation is using non-rechargeable battery discharge curve. This is also not configurable.

## Battery life

First finisher at 1%, lasted **41 days on 550mAh** eneloop lite AAA batteries.

::content-image{:alt="images.batteryDischargeCurveWith550mahEneloopLiteBatteries.alt" :image="images.batteryDischargeCurveWith550mahEneloopLiteBatteries.image"}
::

More results to be added.

## Package

Box front and back:

::content-image{:alt="images.packageFrontAndBack.alt" :image="images.packageFrontAndBack.image"}
::

Box contents:

::content-image{:alt="images.boxContents.alt" :image="images.boxContents.image"}
::

## Price

Great.

One local seller offers them at 15.99€ at sporadic deals. This is close to local prices of display-less button-battery-powered sensors.

## Summary

So far, my the most favourite sensor for Zigbee and Z-Wave networks I've found and owned. 
