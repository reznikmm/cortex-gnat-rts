--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Gnat.IO;
with Ada.Real_Time;

procedure Gnatio
  with No_Return
is
   use Gnat.IO;
   use type Ada.Real_Time.Time_Span;

   --  procedure puts
   --    (data : System.Address)
   --     with Import, Convention => C, External_Name => "puts";

   Hello : String := "Hello from Ada!" & ASCII.NUL;
begin
   loop
      Put ('c');
      Put ('h');
      Put ('a');
      Put ('r');
      Put ('s');
      New_Line (2);

      Put ("string");
      New_Line (3);

      for I in Integer'(0) .. 9 loop
         Put (I); Put (' ');
      end loop;
      New_Line;

      Fibb:
      declare
         Max : constant Natural := 1_000_000;
         Val : Natural := 1;
         Prev : Natural := 1;
         Next : Natural := Val + Prev;
      begin
         while Val < Max loop
            Put (Next); New_Line;
            Prev := Val;
            Val := Next;
            Next := Prev + Val;
         end loop;
      end Fibb;

      delay until Ada.Real_Time.Clock + Ada.Real_Time.Seconds (3);
   end loop;

  --  NOTE:
  --  Make sure that main subprogram doen't return in a real project!
end Gnatio;
