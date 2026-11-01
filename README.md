# thesada-hw

Hardware for the [thesada](https://github.com/Thesada) property monitoring
platform. Designed in EasyEDA Pro.

[`base-carrier-v0.2/`](base-carrier-v0.2/) holds the project source (`.epro`),
the schematic and board PDFs, a 4-layer Gerber and drill set ready to order, the
BOM with LCSC part numbers, the pick-and-place file, the netlist and a STEP 3D
model (zipped) for enclosure work.

## base carrier v0.2

A shield that carries the sensor front end and plugs onto an off-the-shelf
ESP32 board, which supplies the MCU, WiFi and, on the LILYGO, the cellular
modem. This is the board that is built and running; the firmware is
[thesada-fw](https://github.com/Thesada/thesada-fw).

| | |
|---|---|
| CT current channels | 2, differential, one per pump |
| CT connectors | 3.5 mm jack or 3-pin JST, per channel |
| ADC | 1x ADS1115 |
| 1-Wire | 4 connectors on a single bus, plus a DS18B20 on the board itself |
| Base boards | header sets for LILYGO T-SIM7080-S3 and Freenove ESP32 |
| Protection | TVS on every analog net and on the 1-Wire line, TVS and a resettable fuse on the power input |

v0.1 came back from the fab, was assembled and tested, and dropped one part
that did not belong (D2). v0.2 is that fix and the revision to build.

Earlier carrier revisions and other board designs are kept privately until they
are built.

## Licence

[CERN-OHL-P-2.0](https://cern.ch/cern-ohl). SPDX-License-Identifier: CERN-OHL-P-2.0
