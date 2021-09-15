--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with ESP32.GPIO;
with Interfaces;
with System;

package body Handlers is

   protected body Button_Handler is

      function Button_On return Boolean is
      begin
         return On;
      end Button_On;

      procedure Handler is
      begin
         --  Clear interrupt status. Should be first action in the handler
         ESP32.GPIO.Set_Interrupt_Status ((0 .. 39 => False));
         --  Blink with LED
         On := not On;
         ESP32.GPIO.Set_Level (LED, On);
      end Handler;

   end Button_Handler;

end Handlers;
