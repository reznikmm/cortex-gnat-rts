--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Real_Time;
with Ada.Streams;
with Interfaces;
with System;

with ESP32.GPIO;
with ESP32.DPort;
with ESP32.SPI;

procedure LoRa is
   use type Ada.Real_Time.Time;

   procedure puts
     (data : String)
      with Import, Convention => C, External_Name => "puts";

   Button : constant := 0;   --  Button pad
   LED    : constant := 25;  --  LED pad
   LoRa_Reset : constant := 14;
   Value      : ESP32.SPI.Data_Array (1 .. 1);
begin
   ESP32.DPort.Set_Active (ESP32.DPort.SPI2, True);

   ESP32.GPIO.Configure_All
     (((Pad       => LED,
        IO_MUX    => ESP32.GPIO.GPIO_Matrix,
        Direction => ESP32.GPIO.Output,
        Output    => ESP32.GPIO.GPIO_OUT),
       (Pad       => 5,  --  SPI CLK
        IO_MUX    => ESP32.GPIO.GPIO_Matrix,
        Direction => ESP32.GPIO.Output,
        Output    => ESP32.GPIO.HSPICLK),
       (Pad       => 18,  --  SPI CS0 -> LoRa NSS
        IO_MUX    => ESP32.GPIO.GPIO_Matrix,
        Direction => ESP32.GPIO.Output,
        Output    => ESP32.GPIO.HSPICS0),
       (Pad       => 27,  --  SPI MOSI
        IO_MUX    => ESP32.GPIO.GPIO_Matrix,
        Direction => ESP32.GPIO.Output,
        Output    => ESP32.GPIO.HSPID),
       (Pad       => 19,  --  SPI MISO
        IO_MUX    => ESP32.GPIO.GPIO_Matrix,
        Direction => ESP32.GPIO.Input,
        Interrupt => ESP32.GPIO.Disabled,
        Input     => ESP32.GPIO.HSPIQ),
       (Pad       => 26,  --  <-- LoRa DIO0
        IO_MUX    => ESP32.GPIO.GPIO_Matrix,
        Direction => ESP32.GPIO.Input,
        Interrupt => ESP32.GPIO.Disabled,
        Input     => ESP32.GPIO.None),
       (Pad       => 35,  --  <-- LoRa DIO1
        IO_MUX    => ESP32.GPIO.GPIO_Matrix,
        Direction => ESP32.GPIO.Input,
        Interrupt => ESP32.GPIO.Disabled,
        Input     => ESP32.GPIO.None),
       (Pad       => 34,  --  <-- LoRa DIO2
        IO_MUX    => ESP32.GPIO.GPIO_Matrix,
        Direction => ESP32.GPIO.Input,
        Interrupt => ESP32.GPIO.Disabled,
        Input     => ESP32.GPIO.None),
       (Pad       => LoRa_Reset,  --  --> LoRa_Reset
        IO_MUX    => ESP32.GPIO.GPIO_Matrix,
        Direction => ESP32.GPIO.Output,
        Output    => ESP32.GPIO.GPIO_OUT),
       (Pad       => Button,
        IO_MUX    => ESP32.GPIO.GPIO_Matrix,
        Direction => ESP32.GPIO.Input,
        Interrupt => ESP32.GPIO.Disabled,
        Input     => ESP32.GPIO.None)));

   ESP32.GPIO.Set_Level (LoRa_Reset, False);
   delay until Ada.Real_Time.Clock + Ada.Real_Time.Milliseconds (20);
   ESP32.GPIO.Set_Level (LoRa_Reset, True);
   delay until Ada.Real_Time.Clock + Ada.Real_Time.Milliseconds (50);
   ESP32.GPIO.Set_Level (18, True);  --  SS

   ESP32.SPI.Configure
     (Host       => ESP32.SPI.SPI_2,
      Bit_Order  => System.High_Order_First,
      Byte_Order => System.Low_Order_First,
      Frequency  => 8_000_000,
      CP_Mode    => ESP32.SPI.Mode0);

   ESP32.GPIO.Set_Level (LED, True);

   ESP32.SPI.Half_Duplex_Transfer
     (Host    => ESP32.SPI.SPI_2,
      Address => (8, 16#42#),
      MISO    => Value);

   puts (Value (1)'Image & Character'Val (0));

   for J in 1 .. 10 loop
      --  Turl LED if button is not pressed
      ESP32.GPIO.Set_Level
        (LED, (J mod 2 = 1) and ESP32.GPIO.Get_Level (Button));

      delay until Ada.Real_Time.Clock + Ada.Real_Time.Seconds (1);
   end loop;

  --  NOTE:
  --  Make sure that main subprogram doen't return in a real project!
end LoRa;
