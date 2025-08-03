---
title: Control 4-color MH-ET Live Epaper using Arduino

description: Guide how to draw on 4-color Epaper Module from MH-ET LIVE using Arduino (and ESP32).

coverImage: front

images:
  front:
    alt: Front side of MH-ET Live 2.9" 4-color epaper module
    image: images/front.jpg
    caption: Front
  back:
    alt: Back side of MH-ET Live 2.9" 4-color epaper module
    image: images/back.jpg
    caption: MH-ET Live 2.9" 4-color epaper module
  all:
    alt: MH-ET Live 2.9" 4-color epaper module connected to ESP32
    image: images/all.jpg
    caption: Epaper and ESP32
---


{{< content-image "front" >}}

## Prerequisites

Main parts:

- ESP32 development board (not yet tested on Arduino),
- 2.9" MH-ET Live 4-color Epaper Module,
- other wiring ingredients of yours choice.

{{< content-image "all" >}}

# Wiring

Connecting ESP32 development board and Epaper Module:

- D4 - BUSY
- RX2 - RES
- TX2 - D/C
- D5 - CS
- D18 - SCL
- D23 - SDA
- GND - GND
- 3V3 - VCC

{{< content-image "back" >}}

## Programming the ESP32

Current version of library doesn't support the model, and custom configuration needs to be created:

1. download `GxEPD2_290c_GDEY029F51H.h` and `GxEPD2_290c_GDEY029F51H.cpp`,
2. update resolution to `128x296`,
3. replace all occurences of `GxEPD2_290c_GDEY029F51H` with `GxEPD2_290c_GDEY029F51`.

Source code for the sketch:

```arduino
#define ENABLE_GxEPD2_GFX 0

#include <GxEPD2_4C.h>
#include <GxEPD2_290c_GDEY029F51.h>
#include <Fonts/FreeMonoBold18pt7b.h>
#include <Fonts/FreeMonoBold12pt7b.h>
#include <Fonts/FreeMonoBold9pt7b.h>
#include <Fonts/FreeMono9pt7b.h>
#include <Fonts/FreeSerifItalic9pt7b.h>

GxEPD2_4C<GxEPD2_290c_GDEY029F51, GxEPD2_290c_GDEY029F51::HEIGHT> display(GxEPD2_290c_GDEY029F51(/*CS=5*/ SS, /*DC=*/ 17, /*RST=*/ 16, /*BUSY=*/ 4));

void setup()
{
  display.init(115200, true, 2, false);

  fullRefresh();
  delay(5000);
  
  showPartialUpdate();
  delay(1000);

  coverContent();
  display.hibernate();
}

const int16_t padding_x = 8;
const int16_t padding_y = 6;

void fullRefresh()
{
  display.setRotation(3);
  display.setTextColor(GxEPD_BLACK);

  int16_t tbx, tby; uint16_t x, y, tbw, tbh;

  display.setFullWindow();
  display.firstPage();
  do
  {
    display.fillScreen(GxEPD_WHITE);
    
    display.fillRect(0, 6, display.width(), 1, GxEPD_BLACK);
    display.fillRect(0, display.height() - 7, display.width(), 1, GxEPD_BLACK);

    display.fillCircle(display.width() / 2, display.height() / 2, (display.height() * 3 + display.width() * 2) / 10, GxEPD_YELLOW);

    display.setTextColor(GxEPD_RED);
    display.setFont(&FreeMonoBold18pt7b);
    display.getTextBounds("Full Refresh", 0, 0, &tbx, &tby, &tbw, &tbh);
    x = ((display.width() - tbw) / 2) - tbx;
    y = ((display.height() + tbh) / 2) - tby;
    display.setCursor(x, y - tbh);
    display.print("Full Refresh");

    display.fillRect(0, 0, display.width(), 2, GxEPD_RED);
    display.fillRect(0, 2, display.width(), 4, GxEPD_YELLOW);

    display.fillRect(0, display.height() - 2, display.width(), 2, GxEPD_RED);
    display.fillRect(0, display.height() - 6, display.width(), 4, GxEPD_YELLOW);
  }
  while (display.nextPage());
}

void showPartialUpdate()
{
  display.setRotation(3);
  display.setTextColor(GxEPD_BLACK);

  char textBuffer[50];

  int16_t tbx, tby; uint16_t x, y, tbw, tbh;

  uint16_t box_x = display.width() / 3;
  uint16_t box_y = display.height() / 2;
  uint16_t box_w = display.width() - box_x;
  uint16_t box_h = display.height() - box_y;

  display.setFullWindow();
  display.firstPage();
  do
  {
    display.fillScreen(GxEPD_WHITE);

    display.setTextColor(GxEPD_BLACK);
    display.setFont(&FreeMonoBold12pt7b);
    display.getTextBounds("Partial updates", 0, 0, &tbx, &tby, &tbw, &tbh);
    x = padding_x;
    y = padding_y;
    display.setCursor(x, y - tby);
    display.print("Partial updates");
    
      sprintf(textBuffer, "Counter: %d", 0);
      display.fillRect(box_x, box_y, box_w, box_h, GxEPD_RED);

      display.setTextColor(GxEPD_YELLOW);
      display.setFont(&FreeMonoBold12pt7b);
      display.getTextBounds(textBuffer, 0, 0, &tbx, &tby, &tbw, &tbh);
      x = box_x + (box_w - tbw) / 2;
      y = box_y + (box_h - tbh) / 2;
      display.setCursor(x - tbx, y - tby);
      display.print(textBuffer);
  }
  while (display.nextPage());

  display.setPartialWindow(box_x, box_y, box_w, box_h);
  for (uint16_t i = 1; i <= 3; i += 1)
  {
    delay(500);
    display.firstPage();
    do
    {
      sprintf(textBuffer, "Counter: %d", i);
      display.fillRect(box_x, box_y, box_w, box_h, GxEPD_RED);

      display.setTextColor(GxEPD_WHITE);
      display.setFont(&FreeMonoBold12pt7b);
      display.getTextBounds(textBuffer, 0, 0, &tbx, &tby, &tbw, &tbh);
      x = box_x + (box_w - tbw) / 2;
      y = box_y + (box_h - tbh) / 2;
      display.setCursor(x - tbx, y - tby);
      display.print(textBuffer);
    }
    while (display.nextPage());
  }
}

void coverContent()
{
  display.setRotation(3);
  display.setTextColor(GxEPD_BLACK);

  int16_t tbx, tby; uint16_t x, y, tbw, tbh, top_part_bottom, bottom_part_top;

  display.setFullWindow();
  display.firstPage();
  do
  {
    display.fillScreen(GxEPD_WHITE);

    display.setFont(&FreeMonoBold9pt7b);
    display.setTextColor(GxEPD_RED);
    display.getTextBounds("2.9\" 4-color", 0, 0, &tbx, &tby, &tbw, &tbh);
    x = (display.width() - tbw) - padding_x - tbx;
    y = padding_y;
    top_part_bottom = y + tbh + padding_y;
    display.fillRect(x - padding_x, 0, display.width() - x + padding_x, top_part_bottom , GxEPD_YELLOW);
    display.setCursor(x, y - tby);
    display.print("2.9\" 4-color");

    display.setTextColor(GxEPD_RED);
    display.setFont(&FreeMonoBold9pt7b);
    display.getTextBounds("Epaper", 0, 0, &tbx, &tby, &tbw, &tbh);
    x = padding_x - tbx;
    y = padding_y;
    display.setCursor(x, y - tby);
    display.print("Epaper");

    display.setTextColor(GxEPD_WHITE);
    display.setFont(&FreeMonoBold9pt7b);
    display.getTextBounds("Miroslav Kravec", 0, 0, &tbx, &tby, &tbw, &tbh);
    x = padding_x;
    y = display.height() - padding_y - tbh;
    bottom_part_top = y - padding_y;
    display.fillRect(0, bottom_part_top, display.width(), tbh + padding_y + padding_y , GxEPD_RED);
    display.setCursor(x - tbx, y - tby);
    display.print("Miroslav Kravec");
    x = x + tbw;

    display.setFont(&FreeSerifItalic9pt7b);
    display.getTextBounds(" - kravemir.org", 0, 0, &tbx, &tby, &tbw, &tbh);
    display.setCursor(x - tbx, y  - tby);
    display.print(" - kravemir.org");

    display.fillCircle(padding_x + 5, bottom_part_top - padding_y - 5, 5, GxEPD_BLACK);
    display.fillCircle(padding_x + 20, bottom_part_top - padding_y - 5, 5, GxEPD_RED);
    display.fillCircle(padding_x + 35, bottom_part_top - padding_y - 5, 5, GxEPD_YELLOW);

    display.fillCircle(padding_x + 50, bottom_part_top - padding_y - 5, 5, GxEPD_RED);
    display.drawCircle(padding_x + 50, bottom_part_top - padding_y - 5, 5, GxEPD_BLACK);
    display.fillCircle(padding_x + 65, bottom_part_top - padding_y - 5, 5, GxEPD_YELLOW);
    display.drawCircle(padding_x + 65, bottom_part_top - padding_y - 5, 5, GxEPD_BLACK);
    display.drawCircle(padding_x + 80, bottom_part_top - padding_y - 5, 5, GxEPD_BLACK);

    display.drawCircle(padding_x + 95, bottom_part_top - padding_y - 5, 5, GxEPD_RED);
    display.drawCircle(padding_x + 110, bottom_part_top - padding_y - 5, 5, GxEPD_RED);
    display.drawCircle(padding_x + 125, bottom_part_top - padding_y - 5, 5, GxEPD_RED);

    display.drawCircle(padding_x + 140, bottom_part_top - padding_y - 5, 5, GxEPD_YELLOW);
    display.drawCircle(padding_x + 155, bottom_part_top - padding_y - 5, 5, GxEPD_YELLOW);
    display.drawCircle(padding_x + 170, bottom_part_top - padding_y - 5, 5, GxEPD_YELLOW);

    bottom_part_top = bottom_part_top - 15;

    display.setTextColor(GxEPD_BLACK);
    display.setFont(&FreeMonoBold18pt7b);
    display.getTextBounds("Hello World!", 0, 0, &tbx, &tby, &tbw, &tbh);
    x = ((display.width() - tbw) / 2) - tbx;
    y = top_part_bottom + ((bottom_part_top - top_part_bottom + tbh) / 2) - tby;
    display.setCursor(x, y - tbh);
    display.print("Hello World!");
  }
  while (display.nextPage());
}

void loop() {};
```

## Demonstration video

Demonstration of functionality with ESP32:

<iframe class="youtube" width="560" height="315" src="https://www.youtube.com/embed/uN31V_qtQIA?si=rwSIb0u8CZAUSl8A" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
