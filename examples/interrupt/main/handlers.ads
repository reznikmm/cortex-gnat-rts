--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Interrupts.Names;

package Handlers is

   Button : constant := 0;   --  Button pad
   LED    : constant := 25;  --  LED pad

   protected Button_Handler is
      function Button_On return Boolean;
   private
      On : Boolean := False;

      procedure Handler
         with Attach_Handler => Ada.Interrupts.Names.GPIO_INTERRUPT;
   end Button_Handler;

end Handlers;
