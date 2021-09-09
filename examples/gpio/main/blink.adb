--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Real_Time;
with ESP32.GPIO;

procedure Blink
  with No_Return
is
   use type Ada.Real_Time.Time;

   Button : constant := 0;   --  Button pad
   LED    : constant := 25;  --  LED pad
begin
   ESP32.GPIO.Configure_All
     (((Pad       => Led,
        IO_MUX    => ESP32.GPIO.GPIO_Matrix,
        Direction => ESP32.GPIO.Output,
        Output    => ESP32.GPIO.GPIO_Out),  --  for Set_Level
       (Pad       => Button,
        IO_MUX    => ESP32.GPIO.GPIO_Matrix,
        Direction => ESP32.GPIO.Input,
        Input     => ESP32.GPIO.None)));    --  for Get_Level

   loop
      for J in 1 .. 10 loop
         --  Turl LED if button is not pressed
         ESP32.GPIO.Set_Level
           (LED, (J mod 2 = 1) and ESP32.GPIO.Get_Level (Button));

         delay until Ada.Real_Time.Clock + Ada.Real_Time.Seconds (1);
      end loop;
   end loop;

   --  Make sure that main subprogram doen't return in a real project!
end Blink;
