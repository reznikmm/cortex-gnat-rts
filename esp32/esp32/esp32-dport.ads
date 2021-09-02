--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package ESP32.DPort is
   pragma Preelaborate;
   pragma Discard_Names;

   --  The DPort registers control clock management (clock gating), power
   --  management, and the configuration of peripherals and core-system
   --  modules.

   type Peripheral is
     (Timers, SPI, UART, WDG, I2S0, UART1, SPI2,
      I2C0, UHCI0, Remote_Controller, PULSE_CNT, LED_PWM,
      UHCI1, Timer_Group0, eFuse, Timer_Group1, SPI3,
      PWM0, I2C1, CAN, PWM1, I2S1, SPI_DMA, UART2,
      UART_MEM, PWM2, PWM3);

   procedure Set_Active
     (Module : Peripheral;
      Value  : Boolean);
   --  If Value = True then set CLK on and RST off else vice versa.

end ESP32.DPort;
