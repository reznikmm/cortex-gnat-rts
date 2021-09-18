with Ada.Interrupts.Names;

package Ints is

   protected Signal is
      entry Wait
        (RX_Done    : out Boolean;
         RX_Timeout : out Boolean);
   private
      Done    : Boolean := False;
      Timeout : Boolean := False;
      Got     : Boolean := False;  --  Done or Timeout

      procedure Handler
         with Attach_Handler => Ada.Interrupts.Names.GPIO_INTERRUPT;
   end Signal;

end Ints;
