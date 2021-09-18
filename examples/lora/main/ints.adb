with ESP32.GPIO;
package body Ints is

   protected body Signal is

      -------------
      -- Handler --
      -------------

      procedure Handler is
         DIO_0 : constant ESP32.GPIO.GPIO_Pad := 26;
         DIO_1 : constant ESP32.GPIO.GPIO_Pad := 35;
         Set : constant ESP32.GPIO.GPIO_40_Set :=
           ESP32.GPIO.Get_Interrupt_Status;
      begin
         --  Clear interrupt status. Should be first action in the handler
         ESP32.GPIO.Set_Interrupt_Status ((0 .. 39 => False));
         Done := Set (DIO_0);
         Timeout := Set (DIO_1);
         Got := Done or Timeout;
      end Handler;

      ----------
      -- Wait --
      ----------

      entry Wait
        (RX_Done    : out Boolean;
         RX_Timeout : out Boolean) when Got is
      begin
         RX_Done    := Done;
         RX_Timeout := Timeout;
         Got        := False;
         Done       := False;
         Timeout    := False;
      end Wait;

   end Signal;

end Ints;
