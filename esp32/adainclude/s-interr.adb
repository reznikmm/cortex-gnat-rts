--  Copyright (C) 2016-2021 Free Software Foundation, Inc.
--
--  This file is part of the Cortex GNAT RTS project. This file is
--  free software; you can redistribute it and/or modify it under
--  terms of the GNU General Public License as published by the Free
--  Software Foundation; either version 3, or (at your option) any
--  later version. This file is distributed in the hope that it will
--  be useful, but WITHOUT ANY WARRANTY; without even the implied
--  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--
--  As a special exception under Section 7 of GPL version 3, you are
--  granted additional permissions described in the GCC Runtime
--  Library Exception, version 3.1, as published by the Free Software
--  Foundation.
--
--  You should have received a copy of the GNU General Public License
--  and a copy of the GCC Runtime Library Exception along with this
--  program; see the files COPYING3 and COPYING.RUNTIME respectively.
--  If not, see <http://www.gnu.org/licenses/>.

with Ada.Unchecked_Conversion;
with Interfaces.C;

package body System.Interrupts is

   type Handler_Wrapper is access procedure (Obj : System.Address)
     with Convention => C;

   type Parameterless_Handler_Impl is record
      Object  : System.Address;
      Wrapper : Handler_Wrapper;
   end record
   with
     Size => 64;

   function To_Impl_View
     is new Ada.Unchecked_Conversion (Parameterless_Handler,
                                      Parameterless_Handler_Impl);

   function esp_intr_alloc
     (source         : Interfaces.C.int;
      flags          : Interfaces.C.int;
      handler        : Handler_Wrapper;
      arg            : System.Address;
      ret_handle     : System.Address) return Interfaces.C.int
   with Import, Convention => C, External_Name => "esp_intr_alloc";

   ---------------------------------
   -- Install_Restricted_Handlers --
   ---------------------------------

   procedure Install_Restricted_Handlers
     (Prio     : Any_Priority;
      Handlers : New_Handler_Array)
   is
      Priority        : constant Interrupt_Priority :=
        Any_Priority'Max (Interrupt_Priority'First, Prio);
   begin
      for H of Handlers loop
         declare
            Impl : constant Parameterless_Handler_Impl :=
              To_Impl_View (H.Handler);
            Interrupt : constant Natural := Natural (H.Interrupt);

            use type Interfaces.C.int;
            Error                : Interfaces.C.int;
            ESP_OK               : constant := 0;
            --  ESP_INTR_FLAG_SHARED : constant := 2 ** 8;
            Level                : constant Interfaces.C.int :=
              2 ** (Priority - Interrupt_Priority'First + 1);
         begin
            Error := esp_intr_alloc
              (source         => Interfaces.C.int (Interrupt),
               flags          => Level,
               handler        => Impl.Wrapper,
               arg            => Impl.Object,
               ret_handle     => System.Null_Address);

            if Error /= ESP_OK then
               raise Program_Error;
            end if;

         end;
      end loop;
   end Install_Restricted_Handlers;

   procedure Install_Restricted_Handlers_Sequential is
   begin
      raise Program_Error;  --  Unimplemented
   end Install_Restricted_Handlers_Sequential;

end System.Interrupts;
