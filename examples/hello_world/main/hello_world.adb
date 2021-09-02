--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with System;
with Ada.Real_Time;

procedure Hello_World is
   use type Ada.Real_Time.Time;

   procedure puts
     (data : System.Address)
      with Import, Convention => C, External_Name => "puts";

   Hello : String := "Hello from Ada!" & ASCII.NUL;
begin
  for J in 1 .. 10 loop
    puts (Hello'Address);
    delay until Ada.Real_Time.Clock + Ada.Real_Time.Seconds (1);
  end loop;

  --  NOTE:
  --  Make sure that main subprogram doen't return in a real project!
end;
