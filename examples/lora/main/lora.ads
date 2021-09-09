--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Interfaces;

generic
   with procedure Raw_Read
     (Address : Interfaces.Unsigned_8;
      Value   : out Interfaces.Unsigned_8);

   with procedure Raw_Write
     (Address : Interfaces.Unsigned_8;
      Value   : Interfaces.Unsigned_8);

   with procedure Postpone_Execution
     (Miliseconds : Natural);

package Lora is
   pragma Pure;

   procedure Initialize (Frequency : Positive);

   procedure Sleep;

   procedure Idle;

   procedure Receive;

end Lora;
