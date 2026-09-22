# 32×16 LED Information Panel

***English** · [Español](README.es.md)*

A wall-mounted panel of **512 WS2812B LEDs** showing the time, the weather and who is
home, all in pixel art. Driven by an **ESP32-S3 running ESPHome** and integrated with
**Home Assistant**.

Everything — brightness, schedules, colours, timings, thresholds — is adjusted from
Home Assistant **without recompiling**.

> ### Before you read on
>
> **The build guide is written in Spanish.** It is thorough (750 lines, from the bill
> of materials to troubleshooting) and translates well, but it has not been ported to
> English. The code and its comments are in Spanish too.
>
> **The weather data comes from AEMET, which only covers Spain.** Swapping it for
> another provider is a contained change — see [Adapting it](#adapting-it) below — but
> it is not a drop-in.

---

## What it does

| Screen | Content |
|---|---|
| **Clock** | Four large digits across the full panel, blinking colon, seconds bar |
| **Weather** | Sky icon, large temperature, and a slot that **rotates through nine data points based on what is actually worth saying** |
| **Presence** | One icon per person showing where they are: the shape says what kind of place, the colour says which one |
| **Animations** | Pixel-art scenes triggered by hand or from an automation |

Plus: alerts when someone changes location, a night mode with a configurable schedule,
automatic page rotation and a screen-off switch.

## Specifications

| | |
|---|---|
| Resolution | 32 × 16 = 512 LEDs · 10 mm pitch |
| Size | 337 × 177 × ~30 mm |
| Brain | ESP32-S3 running ESPHome |
| Power | 5 V / 18 A, supply mounted **outside** the frame |
| Typical draw | 5-6 A (30 W) |
| Approximate cost | €90-110, excluding tools and filament |

## Getting started

👉 **[Full build guide](docs/GUIA.md)** *(Spanish)* — bill of materials with links,
parts to print, wiring, assembly, calibration and troubleshooting.

## What is in here

```
docs/GUIA.md              the build guide, start to finish (Spanish)
firmware/                 the ESPHome YAML and the drawing headers
homeassistant/            automations and control dashboard
impresion3d/              parametric OpenSCAD model and the STLs
herramientas/             sprite extractor and scene simulator
```

## What you need

- **Home Assistant** running, with the ESPHome add-on.
- **A 3D printer** with a bed of at least 240 × 240 mm. Every large part is split in
  two to fit.
- Basic soldering, and being comfortable wiring mains. The power supply is open-frame.

## Adapting it

**Outside Spain**, replace the AEMET sensor block in the YAML with your own provider
(Met.no, OpenWeatherMap, AccuWeather…). You need: current condition, temperature,
humidity, rain/snow/storm probabilities, mean and gust wind speed, apparent temperature
and today's high and low. Drop whatever you cannot get from the priority list and it
keeps working.

**A different matrix size** means changing `paneles`, `cols_panel` and `rows` at the top
of the OpenSCAD model, and reworking the page layouts — they are hand-drawn for 32×16
and assume, for instance, that the panel is exactly one 16 px sprite tall.

## About the animations

The two bundled scenes ship with **placeholder sprites**: generic drawings made for this
repository. They work and demonstrate the mechanism, but they are deliberately plain.

The original build used sprites from NES games, which are **not distributed here**
because they are still under copyright — a work from 1985 stays protected for decades,
and trademarks do not lapse while in use.

To use your own, `herramientas/` has the extractor: download a sheet from
[The Spriters Resource](https://www.spriters-resource.com/), convert it and replace the
blocks in `firmware/panel_led_sprites.h`. The process is documented in that file's
header.

> **Do not iterate by recompiling.** `herramientas/simular_escena.py` builds the scene
> and exports it as a GIF. A build-and-upload cycle takes two minutes; looking at a GIF
> is instant. Both scenes in this project needed four passes each.

## Design decisions you may find useful

- **The power supply lives outside the frame.** That removes the heat and the mains
  voltage from the piece hanging on the wall, allows printing everything in PLA, and
  brings the depth down from ~50 mm to 15-20.
- **Two independent cable pairs**, one per panel. Separate injection was needed anyway,
  so running two pairs costs nothing and halves the current in each: 3 A instead of 6.
- **Brightness is capped by construction.** The slider moves within a 45 %
  `color_correct`, so not even the boot flash can exceed the supply's budget. The limit
  does not live in any control anyone can move.
- **The weather slot rotates by relevance, not on a fixed carousel.** Most of those
  values read zero for most of the year; a fixed carousel would spend half the year
  showing zeros in turn.
- **Animations are not stored as frames** but as a sprite plus a movement rule, which
  decouples motion smoothness from the cadence of the poses.

## Licence

| Material | Licence |
|---|---|
| Code (`firmware/`, `homeassistant/`, `herramientas/`) | **MIT** |
| Documentation (`docs/`, this README) | **CC BY-SA 4.0** |
| 3D model (`impresion3d/`) | **CC BY-SA 4.0** |

Forks and improvements welcome — just credit where it came from.

The frame is **inspired by** a model by
[DBMaking](https://makerworld.com/en/models/156388), from which cell measurements were
taken. It is rewritten from scratch as parametric code, is 32×16 rather than 16×16, and
adds parts the original does not have. Full reasoning in [LICENSE](LICENSE).

## Credits

- Frame geometry inspired by
  [*Frame Led Matrix 16x16 sound reactive*](https://makerworld.com/en/models/156388)
  by **DBMaking**.
- Power supply enclosure:
  [*Meanwell LRS-100-5 Case*](https://www.printables.com/model/183280-meanwell-lrs-100-5-case)
  by **bloodpack**.
