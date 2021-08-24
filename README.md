# esp32-gnat-rts

> A GNAT Ada Runtime library for ESP32 microcontrollers

This package includes GNAT Ada Run Time Systems (RTSs) based on
[FreeRTOS](http://www.freertos.org) and targeted at boards with
[ESP32](https://en.wikipedia.org/wiki/ESP32) MCUs (tested on
[Wireless Stick (Gecko Board) by Heltec](https://heltec.org/project/wireless-stick/)).
For discussions, visit [Telegram Ada Group](https://t.me/ada_lang)
or the dedicated
[Google Group](https://groups.google.com/forum/#!forum/cortex-gnat-rts)
for the parent `cortex-gnat-rts` project.

The RTSs are all Ravenscar-based, with additional restrictions
`No_Exception_Propagation` and `No_Finalization`.
`No_Exception_Propagation` means that exceptions can't be caught except
in their immediate scope; instead, a `Last_Chance_Handler` is called.

In each case, the board support for the RTS (configuration for size and
location of Flash, RAM; clock initialization; interrupt naming) is in
`$RTS/adainclude`.

The Ada source is either original or based on FSF GCC (mainly 4.9.1, some
later releases too).

The boards supported are

* Wireless Stick (Gecko Board) by Heltec
  * See `esp32/COPYING*` for licensing terms.
  * Example in `examples/`.


The package is based on
[Cortex-GNAT-RTS](https://github.com/simonjwright/cortex-gnat-rts)
by [Simon Wright](https://github.com/simonjwright/).

## Install
[Espressif](https://www.espressif.com/en/products/socs/esp32) provides a
[Espressif IoT Development Framework (ESP-IDF)](https://github.com/espressif/esp-idf/blob/master/README.md).
This package uses the SDK to build an Ada project with FreeRTOS. So you need
* ESP-IDF
* Custom ESP32 toolchain with Ada enabled
* `gprbuild` project manager
* This package for GNAT Runtime Library and examples

### Install ESP-IDF

Follow
[Get Started](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/get-started/index.html)
to install ESP-IDF.

### Install Custom ESP32 toolchain with Ada enabled

Download a toolchain from
[Releases](https://github.com/reznikmm/esp32-gnat-rts/releases)
and unpack and replace toolchain (look into
`$HOME/.espressif/tools/xtensa-esp32-elf/esp-2020r3-8.4.0`)

Alternatively, build it from sources as described
[here](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/get-started/toolchain-setup-scratch.html)
and
[here](https://github.com/RREE/esp8266-ada/wiki/Steps-for-building-on-Linux).

### Install `gprbuild` project manager

Use GNAT Community Edition or install a native package:

    apt install gprbuild

### Install esp32-gnat-rts

Clone the repository:

    git clone https://github.com/reznikmm/esp32-gnat-rts.git

# Usage

ESP-IDF provides an
[advanced build system](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-guides/build-system.html)
(developed on top of `CMake`) to build a project.
An ESP-IDF project can be seen as an amalgamation of a number of components.

The `esp32-gnat-rts` is a component for ESP-IDF. It should be used to link
Ada code into ESP-IDF application.

## Build `hello_world`

1. Setup ESP-IDF environment:

       . <esp_path>/esp-idf/export.sh

2. Build ESP-IDF application

       cd esp32-gnat-rts/examples/hello_world
       idf.py app

3. Flash it

       cd esp32-gnat-rts/examples/hello_world
       idf.py -p /dev/ttyUSB0 app-flash

4. See "Hello Ada!" output

       idf.py monitor
       I (0) cpu_start: Starting scheduler on APP CPU.
       Hello from Ada!

The `hello_world` application is an ESP-IDF project.
It requires `esp32-gnat-rts` component as dependency.
The `hello_world.c` main subprogram just calls `main` function (created by
`gnatbind`).
In turn `main` calls `Hello_Ada` procedure.
The `Hello_Ada` outputs "Hello Ada!" with `puts` provided by FreeRTOS.

## Maintainer

[Max Reznik](https://github.com/reznikmm).

## Contribute

Feel free to dive in!
[Open an issue](https://github.com/reznikmm/esp32-gnat-rts/issues/new)
or submit PRs.

## License

The runtime license is [GPL3](LICENSE) with
[GCC RunTime Exception](esp32/COPYING.RUNTIME).

