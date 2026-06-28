#!/usr/bin/env bash
set -euo pipefail

find content -type f \( \
  -iname "*.jpg" -o \
  -iname "*.jpeg" -o \
  -iname "*.raf" \
\) | while IFS= read -r img; do

  json="${img}.json"

  echo "Processing: $img"


  exiftool -j -n \
    -Make \
    -Model \
    -FilmMode \
    -ColorChromeEffect \
    -ColorChromeFXBlue \
    -ColorTemperature \
    -WhiteBalance \
    -WhiteBalanceFineTune \
    -Color \
    -Saturation \
    -DynamicRange \
    -HighlightTone \
    -ShadowTone \
    -ISO \
    -ExposureTime \
    -FNumber \
    -ExposureCompensation \
    "$img" |
  jq '.[0]
  # -------------------------
  # Film simulation
  # -------------------------
  | .FilmSimulationName =
      ((.FilmMode|tostring) as $f
      | {
          "0":"Provia","1":"Velvia","2":"Astia","3":"Classic Chrome",
          "4":"Pro Neg. Hi","5":"Pro Neg. Std","6":"Classic Neg.",
          "7":"Eterna","8":"Acros","9":"Monochrome","10":"Sepia",
          "288":"Astia","512":"Velvia","2816":"Reala Ace"
        }[$f] // null
      | tostring)

  # -------------------------
  # Color Chrome (string-safe)
  # -------------------------
  | .ColorChromeEffect =
      ((.ColorChromeEffect|tostring) as $v
      | ({
          "0":"Off",
          "1":"Weak",
          "2":"Strong",
          "32":"Weak"
        }[$v] // $v))

  | .ColorChromeFXBlue =
      ((.ColorChromeFXBlue|tostring) as $v
      | ({
          "0":"Off",
          "1":"Weak",
          "2":"Strong",
          "32": "Weak",
        }[$v] // $v))

  # -------------------------
  # White balance
  # -------------------------
  | .WhiteBalance =
      (
        if (.ColorTemperature? != null and .ColorTemperature != "") then
          ((.ColorTemperature | tostring) + "K")
        else
          (.WhiteBalance | tostring)
        end
      )

  | .WhiteBalanceFineTune =
      (.WhiteBalanceFineTune | tostring)

  # -------------------------
  # Saturation
  # -------------------------
  | .Color =
      ((.Saturation | tostring) as $s
      | {
          "0": "0",
          "128": "+1",
          "192": "+3",
          "224": "+4",
          "256": "+2",
          "384": "-1",
          "512": "Low",
          "768": "None (B&W)",
          "769": "B&W Red Filter",
          "770": "B&W Yellow Filter",
          "771": "B&W Green Filter",
          "784": "B&W Sepia",
          "1024": "-2",
          "1216": "-3",
          "1248": "-4",
          "1280": "Acros",
          "1281": "Acros Red Filter",
          "1282": "Acros Yellow Filter",
          "1283": "Acros Green Filter",
          "32768": "Film Simulation"
        }[$s] // $s)


  # -------------------------
  # Dynamic range
  # -------------------------
  | .DynamicRange =
      ((.DynamicRange|tostring) as $v
      | ({
          "0":"DR Auto",
          "1":"DR 100",
          "2":"DR 200",
          "3":"DR 400"
        }[$v] // ("DR" + $v)))

  # -------------------------
  # Exposure time (force string)
  # -------------------------
  | .ExposureTime =
      (if (.ExposureTime|type == "number")
       then (("1/" + ((1 / .ExposureTime) | tostring)))
       else (.ExposureTime|tostring)
       end)

  # -------------------------
  # ISO / aperture / bias normalization
  # -------------------------
  | .ISO = (.ISO|tostring)
  | .FNumber = (.FNumber|tostring)
  | .ExposureCompensation = (.ExposureCompensation|tostring)

  # -------------------------
  # Tone values
  # -------------------------
  | .HighlightTone = (
      (.HighlightTone | tonumber? // null)
      | if . == null then null else (. / 16) end
      | tostring
    )

  | .ShadowTone = (
      (.ShadowTone | tonumber? // null)
      | if . == null then null else (. / 16) end
      | tostring
    )
  ' > "$json"

done
