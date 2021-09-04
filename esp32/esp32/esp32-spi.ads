--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Interfaces;
with System;
with Ada.Streams;

package ESP32.SPI is
   pragma Preelaborate;
   pragma Discard_Names;

   type Controller_Name is (SPI_0, SPI_1, SPI_2, SPI_3);

   HSPI : Controller_Name renames SPI_2;
   --  SPI2 signal bus
   VSPI : Controller_Name renames SPI_3;
   --  SPI3 signal bus

   type Clock_Polarity_And_Phase is (Mode0, Mode1, Mode2, Mode3);
   --  Mode0 means CPOL=0, CPHA=0

   procedure Configure
     (Host       : Controller_Name;
      Bit_Order  : System.Bit_Order := System.High_Order_First;
      Byte_Order : System.Bit_Order := System.Low_Order_First;
      Frequency  : Natural;
      CP_Mode    : Clock_Polarity_And_Phase := Mode0);

   subtype Command_Size is Natural range 0 .. 16;  --  In bits
   subtype Address_Size is Natural range 0 .. 32;  --  In bits
   subtype Dummy_Size is Natural range 0 .. 256;   --  In bits
   subtype Data_Length is Ada.Streams.Stream_Element_Count range 0 .. 64;

   type Data_Array is array (Data_Length range <>) of
     Ada.Streams.Stream_Element
   with Alignment => 4;

   type Half_Duplex_Command (Size : Command_Size := 0) is record
      case Size is
         when 0 =>
            null;
         when others =>
            Data : Interfaces.Unsigned_16;
      end case;
   end record;

   type Half_Duplex_Address (Size : Address_Size := 0) is record
      case Size is
         when 0 =>
            null;
         when others =>
            Data : Interfaces.Unsigned_16;
      end case;
   end record;

   procedure Half_Duplex_Transfer
     (Host     : Controller_Name;
      Command  : Half_Duplex_Command := (Size => 0);
      Address  : Half_Duplex_Address := (Size => 0);
      Dummy    : Dummy_Size := 0;
      MOSI     : Data_Array := (1 .. 0 => 0);
      MISO     : out Data_Array);

   procedure Half_Duplex_Transfer
     (Host     : Controller_Name;
      Command  : Half_Duplex_Command := (Size => 0);
      Address  : Half_Duplex_Address := (Size => 0);
      Dummy    : Dummy_Size := 0;
      MOSI     : Data_Array := (1 .. 0 => 0))
     with Inline;

end ESP32.SPI;
