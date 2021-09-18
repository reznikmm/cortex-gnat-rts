--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Interfaces;
with Ada.Streams;

generic
   with procedure Raw_Read
     (Address : Interfaces.Unsigned_8;
      Value   : out Interfaces.Unsigned_8);

   with procedure Raw_Write
     (Address : Interfaces.Unsigned_8;
      Value   : Interfaces.Unsigned_8);

package Lora is
   pragma Pure;

   procedure Initialize (Frequency : Positive);

   procedure Sleep;

   procedure Idle;

   procedure Receive;

   procedure On_DIO_0_Raise
     (Data : out Ada.Streams.Stream_Element_Array;
      Last : out Ada.Streams.Stream_Element_Offset);

end Lora;
