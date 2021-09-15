--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Real_Time;
with ESP32.GPIO;
with Interfaces;
with System;
with Handlers;

procedure Interrupt
  with No_Return
is
   use type Ada.Real_Time.Time;

   Environment_Task_Storage_Size : constant Natural := 4096
    with
      Export,
      Convention => Ada,
      External_Name => "_environment_task_storage_size";
   --  Increase stack size for environment task

begin
   ESP32.GPIO.Configure_All
     (((Pad       => Handlers.Led,
        IO_MUX    => ESP32.GPIO.GPIO_Matrix,
        Direction => ESP32.GPIO.Output,
        Output    => ESP32.GPIO.GPIO_Out),  --  for Set_Level
       (Pad       => Handlers.Button,
        IO_MUX    => ESP32.GPIO.GPIO_Matrix,
        Direction => ESP32.GPIO.Input,
        Interrupt => ESP32.GPIO.Any_Edge,
        Input     => ESP32.GPIO.None)));

   loop
      for J in 1 .. 10 loop
         delay until Ada.Real_Time.Clock + Ada.Real_Time.Seconds (1);
      end loop;
   end loop;

   --  Make sure that main subprogram doen't return in a real project!
end Interrupt;
