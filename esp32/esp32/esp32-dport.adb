--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with System;

package body ESP32.DPort is

   type Word is array (Natural range 0 .. 31) of Boolean
     with Pack;

   DPORT_PERIP_CLK_EN_REG : Word
     with Address => System'To_Address (16#3FF000C0#), Import, Volatile;
   --  enables the peripheral clock

   DPORT_PERIP_RST_EN_REG : Word
     with Address => System'To_Address (16#3FF000C4#), Import, Volatile;
   --  resets peripherals

   ----------------
   -- Set_Active --
   ----------------

   procedure Set_Active
     (Module : Peripheral;
      Value  : Boolean) is
   begin
      DPORT_PERIP_CLK_EN_REG (Peripheral'Pos (Module)) := Value;
      DPORT_PERIP_RST_EN_REG (Peripheral'Pos (Module)) := not Value;
   end Set_Active;

end ESP32.DPort;
