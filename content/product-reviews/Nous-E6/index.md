---
title: Nous E6
subtitle: Smart ZigBee LCD Temperature and Humidity Sensor

date: 2024-01-14T15:37:20+01:00

description: Review of Nous E6 Smart ZigBee LCD Temperature and Humidity Sensor.

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

coverImage: frontPoweredOn

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
  dischargeCurve01:
    alt: Nous E6 battery discharge curve with 550 mAh eneloop lite batteries
    image: images/battery-discharge-curve-with-550mah-eneloop-lite-batteries.jpg
    caption: 550mAh eneloop batteries
  dischargeCurve02:
    alt: Nous E6 battery discharge curve with 550 mAh eneloop lite batteries (run 02)
    image: images/battery-discharge-curve-with-550mah-eneloop-lite-batteries-run-02.jpg
    caption: 550mAh eneloop batteries (run 02)

imageGallery:
  batteryLife:
    - dischargeCurve01
    - dischargeCurve02
---

{{< content-image "frontPoweredOn" >}}

## Precision

I did test accuracy only briefly. Together with other sensor on a shelf, multiple units of E6 were usually +/- of 0.2°C from average of all sensors tested together.

Nous E6 seems to be good on measuring the air temperature, and it doesn't cling too much towards the temperature of furniture/wall temperature it is placed on.

Notes:

- the accuracy of room temperature reading is much more affected by correct or incorrect placement within the room, than by inaccuracy of the sensor itself.
- some sensors with official +/- of 0.2°C precision on the paper were actually measuring much more the temperature of furniture instead of the air temperature:
  - test - when window was opened when cold outside, some models of sensors went down immediately by 1°C and others just by 0.2°C.


## Power

Device is powered by two AAA batteries.

{{< content-image "openedBack" >}}

Rechargeable 1.2V NiMH batteries work fine. I love this fact, because I am not producing waste by early replacement of batteries, when I want to be sure, that sensor used in automations won't go dead in a bad moment.

Unfortunately, device doesn't detect battery type is automatically - Alkaline vs NiMH. This results in skewed percentage report for rechargeable battiers - percentage calculation is using non-rechargeable battery discharge curve. This is also not configurable.

## Battery life

Test runs:

- **41 days** (over a month) on **550mAh** eneloop lite AAA batteries from fully charged to 1%,
- **81 days** (over 2 months) on **550mAh** eneloop lite AAA batteries from fully charged to 1%.

{{< image-gallery "batteryLife" >}}
More results to be added.

## Package

Box front and back:

{{< content-image "packageFrontAndBack" >}}

Box contents:

{{< content-image "boxContents" >}}

## Alternative names and variants

This looks like an ODM product, and I've found similar products:

- GIRIER Tuya Smart ZigBee Temperature and Humidity:
    - looks the same, even same batteries included, but without Nous logos,
    - I didn't test them side by side (yet), whether temperature sensor is the same, neither I have disassembled them to compare internal
- Niceboy ION ORBIS Meteo+:
    - product photos look same, but with different logo,
    - I didn't purchase it, just noting down.


## Price

Good to great (if discounted).

One local seller offers them at 15.99€ at sporadic deals. This is close to local prices of display-less button-battery-powered sensors.

The AliExpress one is much cheaper at non-discounted prices, though. But, with longer delivery time, and without benefits of local laws for strong customer protection.

## Summary

So far, my the most favourite sensor for Zigbee and Z-Wave networks I've found and owned. 
