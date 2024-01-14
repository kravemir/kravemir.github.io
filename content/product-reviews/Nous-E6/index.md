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
---

![Nous E6 powered on](/images/product-reviews/nous-e6/front-powered.jpg)

## Precision

I did test accuracy only briefly. Together with other sensor on a shelf, multiple units of E6 were usually +/- of 0.2°C from average of all sensors tested together.

Nous E6 seems to be good on measuring the air temperature, and it doesn't cling too much towards the temperature of furniture/wall temperature it is placed on.

Notes:

- the accuracy of room temperature reading is much more affected by correct or incorrect placement within the room, than by inaccuracy of the sensor itself.
- some sensors with official +/- of 0.2°C precision on the paper were actually measuring much more the temperature of furniture instead of the air temperature:
  - test - when window was opened when cold outside, some models of sensors went down immediately by 1°C and others just by 0.2°C.


## Power

Device is powered by two AAA batteries.

![Nous E6 with opened back battery compartment](/images/product-reviews/nous-e6/back-opened.jpg)

Rechargeable 1.2V NiMH batteries work fine. I love this fact, because I am not producing waste by early replacement of batteries, when I want to be sure, that sensor used in automations won't go dead in a bad moment.

Unfortunately, device doesn't detect battery type is automatically - Alkaline vs NiMH. This results in skewed percentage report for rechargeable battiers - percentage calculation is using non-rechargeable battery discharge curve. This is also not configurable.

## Battery life

To be added:

- not tested long enough,
- so far lasted over 2 weeks on 2x NiMH AAA batteries with decent (reported) percentage of battery charge left,
- unfortunately, I had my HA history retention set to default 10 days, so I don't date of last battery change and need to re-run the test from full charge.

## Package

Box front and back:

![Nous E6 box front and back](/images/product-reviews/nous-e6/package-front-back.jpg)

Box contents:

![Nous E6 box contents](/images/product-reviews/nous-e6/package-contents.jpg)


## Price

Great.

One local seller offers them at 15.99€ at sporadic deals. This is close to local prices of display-less button-battery-powered sensors.

## Summary

So far, my the most favourite sensor for Zigbee and Z-Wave networks I've found and owned. 