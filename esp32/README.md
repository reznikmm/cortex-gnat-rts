This is an Ada Runtime System (RTS) for the GCC Ada compiler (GNAT),
targeted to boards based on the [ESP32](https://en.wikipedia.org/wiki/ESP32).

The RTS supports Ravenscar tasking. Package System contains the following additional restrictions:

*  `pragma Restrictions (No_Exception_Propagation);`
*  `pragma Restrictions (No_Finalization);`

The RTS is intended to support commercial binary distributions. The Ada source code has either been derived from FSF GCC (4.9.1, in some cases later) or written for this work; see the files `COPYING3` and `COPYING.RUNTIME`.

The RTS is based on [FreeRTOS]( http://www.freertos.org). See `COPYING.FreeRTOS`.

The following non-original files don't form part of a binary deliverable, so don't affect the status of the binary:

* `build_runtime.gpr` and `runtime.xml` originated in AdaCore's GNAT GPL 2014 arm-eabi distribution (for Linux).

