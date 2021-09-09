--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Streams;
with Ada.Unchecked_Conversion;

with Interfaces;
with System;
package body LoRa is
   pragma Discard_Names;

   procedure puts
     (data : String)
     with Import, Convention => C, External_Name => "puts";

   package Address is
      type Register is mod 2 **7;
      RegFifo   : constant Register := 16#00#;
      RegOpMode : constant Register := 16#01#;
      RegFrfMsb : constant Register := 16#06#;
      RegFrfMid : constant Register := 16#07#;
      RegFrfLsb : constant Register := 16#08#;
      RegPaConfig : constant Register := 16#09#;
      RegLna    : constant Register := 16#0C#;
      RegFifoAddrPtr    : constant Register := 16#0D#;
      RegFifoTxBaseAddr : constant Register := 16#0E#;
      RegFifoRxBaseAddr : constant Register := 16#0F#;
      RegFifoRxCurrentAddr : constant Register := 16#10#;
      RegIrqFlagsMask : constant Register := 16#11#;
      RegIrqFlags : constant Register := 16#12#;
      RegModemConfig1 : constant Register := 16#1D#;
      RegModemConfig2 : constant Register := 16#1E#;
      RegSymbTimeoutLsb : constant Register := 16#1F#;
      RegPreambleMsb : constant Register := 16#20#;
      RegPreambleLsb : constant Register := 16#21#;
      RegModemConfig3 : constant Register := 16#26#;
      RegDetectOptimize : constant Register := 16#31#;
      RegDetectionThreshold : constant Register := 16#37#;
      RegSyncWord : constant Register := 16#39#;
      Version   : constant Register := 16#42#;
      RegPaDac : constant Register := 16#4D#;
   end Address;

   procedure Read (Addr : Address.Register; Value : out Interfaces.Unsigned_8);
   procedure Write (Addr : Address.Register; Value : Interfaces.Unsigned_8);

   type Modulation_Scheme is (FSK, OOK);

   type FSK_OOK_Mode is
     (Sleep,
      Standby,
      FS_TX,
      Transmitter,
      FS_RX,
      Receiver);
   for FSK_OOK_Mode use (0, 1, 2, 3, 4, 5);

   type LoRa_Mode is
     (Sleep,
      Standby,
      FS_TX,
      Transmit,
      FS_RX,
      Receive_Continuous,
      Receive_Single,
      Channel_Activity_Detection);
   for LoRa_Mode use (0, 1, 2, 3, 4, 5, 6, 7);

   type RegOpMode (LongRangeMode : Boolean := False) is record
      --  This bit can be modified only in Sleep mode. A write operation on
      --  other device modes is ignored.

      LowFrequencyModeOn : Boolean;
      --  Access Low Frequency Mode registers

      case LongRangeMode is
         when False =>
            ModulationType     : Modulation_Scheme;
            FSK_OOK_Mode       : LoRa.FSK_OOK_Mode;
         when True =>
            AccessSharedReg    : Boolean;
            --  Access FSK registers page in LoRa Mode (0x0D .. 0x3F)
            LoRa_Mode          : LoRa.LoRa_Mode;
      end case;
   end record
     with Size => 8;

   for RegOpMode use record
      LongRangeMode      at 0 range 7 .. 7;
      ModulationType     at 0 range 5 .. 6;
      LowFrequencyModeOn at 0 range 3 .. 3;
      FSK_OOK_Mode       at 0 range 0 .. 2;
      AccessSharedReg    at 0 range 6 .. 6;
      LoRa_Mode          at 0 range 0 .. 2;
   end record;

   function To_Byte is new Ada.Unchecked_Conversion
     (RegOpMode, Interfaces.Unsigned_8);

   type RegPaConfig is record
      PaSelect    : Boolean;
      MaxPower    : Natural range 0 .. 7;
      --  Select max output power: Pmax=10.8+0.6*MaxPower [dBm]
      OutputPower : Natural range 0 .. 15;
      --  Pout=Pmax-(15-OutputPower) if PaSelect = 0 (RFO pins)
      --  Pout=17-(15-OutputPower) if PaSelect = 1 (PA_BOOST pin)
   end record
     with Size => 8;

   for RegPaConfig use record
      PaSelect      at 0 range 7 .. 7;
      MaxPower     at 0 range 4 .. 6;
      OutputPower at 0 range 0 .. 3;
   end record;

   function To_Byte is new Ada.Unchecked_Conversion
     (RegPaConfig, Interfaces.Unsigned_8);

   type RegLNA is record
      LnaGain      : Natural range 1 .. 6;  --  LNA gain setting
      --  1 = maximum gain, 6 = minimum gain
      LnaBoostLf   : Natural range 0 .. 3 := 0;
      --  Low Frequency (RFI_LF) LNA current adjustment
      LnaBoostHf   : Natural range 0 .. 3 := 0;
      --  High Frequency (RFI_HF) LNA current adjustment
   end record
     with Size => 8;

   for RegLNA use record
      LnaGain      at 0 range 5 .. 7;
      LnaBoostLf   at 0 range 3 .. 4;
      LnaBoostHf   at 0 range 0 .. 1;
   end record;

   function To_Byte is new Ada.Unchecked_Conversion
     (RegLNA, Interfaces.Unsigned_8);

   type RegRxConfig is record
      RestartRxOnCollision    : Boolean;
      RestartRxWithoutPllLock : Boolean;
      RestartRxWithPllLock    : Boolean;
      AfcAutoOn               : Boolean;
      AgcAutoOn               : Boolean;
      RxTrigger               : Natural range 0 .. 7;
   end record
     with Size => 8;

   for RegRxConfig use record
      RestartRxOnCollision    at 0 range 7 .. 7;
      RestartRxWithoutPllLock at 0 range 6 .. 6;
      RestartRxWithPllLock    at 0 range 5 .. 5;
      AfcAutoOn               at 0 range 4 .. 4;
      AgcAutoOn               at 0 range 3 .. 3;
      RxTrigger               at 0 range 0 .. 2;
   end record;

   function To_Byte is new Ada.Unchecked_Conversion
     (RegRxConfig, Interfaces.Unsigned_8);

   type RegModemConfig1 is record
      Bw                   : Natural range 0 .. 15;
      CodingRate           : Natural range 0 .. 7;
      ImplicitHeaderModeOn : Boolean;
   end record
     with Size => 8;

   for RegModemConfig1 use record
      Bw                   at 0 range 4 .. 7;
      CodingRate           at 0 range 1 .. 3;
      ImplicitHeaderModeOn at 0 range 0 .. 0;
   end record;

   function To_Byte is new Ada.Unchecked_Conversion
     (RegModemConfig1, Interfaces.Unsigned_8);

   type RegModemConfig2 is record
      SpreadingFactor  : Natural range 0 .. 15;
      --  SF rate (expressed as a base-2 logarithm)
      TxContinuousMode : Boolean;
      RxPayloadCrcOn   : Boolean;
      SymbTimeout      : Natural range 0 .. 3;
   end record
     with Size => 8;

   for RegModemConfig2 use record
      SpreadingFactor  at 0 range 4 .. 7;
      TxContinuousMode at 0 range 3 .. 3;
      RxPayloadCrcOn   at 0 range 2 .. 2;
      SymbTimeout      at 0 range 0 .. 1;
   end record;

   function To_Byte is new Ada.Unchecked_Conversion
     (RegModemConfig2, Interfaces.Unsigned_8);

   type RegModemConfig3 is record
      LowDataRateOptimize : Boolean;  --  the symbol length exceeds 16ms
      AgcAutoOn           : Boolean;  --  LNA gain set by the internal AGC loop
   end record
     with Size => 8;

   for RegModemConfig3 use record
      LowDataRateOptimize at 0 range 3 .. 3;
      AgcAutoOn           at 0 range 2 .. 2;
   end record;

   function To_Byte is new Ada.Unchecked_Conversion
     (RegModemConfig3, Interfaces.Unsigned_8);

   type RegPaDac is record
      PaDac : Natural range 0 .. 7;
   end record
     with Size => 8;

   for RegPaDac use record
      PaDac at 0 range 0 .. 2;
      --  Enables the +20dBm option on PA_BOOST pin:
      --  0x04 ->  Default value
      --  0x07 ->  +20dBm on PA_BOOST when OutputPower=1111
   end record;

   function To_Byte is new Ada.Unchecked_Conversion
     (RegPaDac, Interfaces.Unsigned_8);

   ----------
   -- Idle --
   ----------

   procedure Idle is
      Mode : constant RegOpMode :=
        (LongRangeMode      => True,
         AccessSharedReg    => False,
         LowFrequencyModeOn => False,
         LoRa_Mode          => Standby);
   begin
      Write (Address.RegOpMode, To_Byte (Mode));
   end Idle;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Frequency : Positive) is
      use type Interfaces.Unsigned_8;
      use type Interfaces.Unsigned_64;

      FXOSC : constant := 32_000_000;
      --  Crystal oscillator frequency
      FSTEP_Divider : constant := 2 ** 19;
      --  Frequency synthesizer step = FSOSC/FSTEP_Divider
      Frf : constant Interfaces.Unsigned_64 :=
        Interfaces.Unsigned_64 (Frequency) * FSTEP_Divider / FXOSC;
      --
      Value : Interfaces.Unsigned_8;

   begin
      Read (Address.Version, Value);

      if Value /= 16#12# then
         raise Program_Error;
      end if;

      Sleep;
      --  Set frequency
      Write (Address.RegFrfMsb, Interfaces.Unsigned_8'Mod (Frf / 16#1_0000#));
      Write (Address.RegFrfMid, Interfaces.Unsigned_8'Mod (Frf / 16#1_00#));
      Write (Address.RegFrfLsb, Interfaces.Unsigned_8'Mod (Frf));
      --  set base addresses
      Write (Address.RegFifoTxBaseAddr, 0);
      Write (Address.RegFifoRxBaseAddr, 0);

      Read (Address.RegFrfMsb, Value);
      puts ("msb=" & Value'Image & Character'Val (0));
      Read (Address.RegFrfMid, Value);
      puts ("mid=" & Value'Image & Character'Val (0));
      Read (Address.RegFrfLsb, Value);
      puts ("lsb=" & Value'Image & Character'Val (0));


      --  set LNA boost
      declare
         LNA : constant RegLNA :=
           (LnaGain => 1,
            LnaBoostLf => 0,
            LnaBoostHf => 3);  --  Boost on, 150% LNA current
      begin
         Write (Address.RegLna, To_Byte (LNA));
      end;

      --  set auto AGC
      declare
         ModemConfig3 : constant RegModemConfig3 :=
           (LowDataRateOptimize => False,
            AgcAutoOn           => True);
      begin
         Write (Address.RegModemConfig3, To_Byte (ModemConfig3));
      end;

      --  set output power to 14 dBm
      declare
         PaConfig : constant RegPaConfig :=
           (PaSelect  => True,
            MaxPower  => 7,
            OutputPower => 14 - 2);
         --  Pout=17-(15-OutputPower) if PaSelect = 1 (PA_BOOST pin)
         PaDac : constant RegPaDac := (PaDac => 4);
      begin
         Write (Address.RegPaConfig, To_Byte (PaConfig));
         Write (Address.RegPaDac, To_Byte (PaDac));
      end;

      --
      declare
         ModemConfig2 : constant RegModemConfig2 :=
           (SpreadingFactor  => 8,
            TxContinuousMode => False,
            RxPayloadCrcOn   => True,  --  enable crc
            SymbTimeout      => 0);
      begin
         Write (Address.RegDetectOptimize, 16#C3#);
         Write (Address.RegDetectionThreshold, 16#0A#);
         Write (Address.RegModemConfig2, To_Byte (ModemConfig2));
      end;

      --  setSignalBandwidth 125_000 => 7
      declare
         ModemConfig1 : constant RegModemConfig1 :=
           (Bw => 7,
            CodingRate => 1,
            ImplicitHeaderModeOn => False);
      begin
         Write (Address.RegModemConfig1, To_Byte (ModemConfig1));
      end;

      Write (Address.RegSyncWord, 16#12#);
      --  Value 0x34 is reserved for LoRaWAN networks

      --  setPreambleLength 8
      Write (Address.RegPreambleMsb, 0);
      Write (Address.RegPreambleLsb, 8);

      Write (Address.RegSymbTimeoutLsb, 255);

      Write (16#40#, 2#11_11_11_11#);

      Idle;
   end Initialize;

   procedure Read
     (Addr  : Address.Register;
      Value : out Interfaces.Unsigned_8) is
   begin
      Raw_Read (Interfaces.Unsigned_8 (Addr), Value);
   end Read;

   -------------
   -- Receive --
   -------------

   procedure Receive is
      use type Interfaces.Unsigned_8;

      Mode : constant RegOpMode :=
        (LongRangeMode      => True,
         AccessSharedReg    => False,
         LowFrequencyModeOn => False,
         LoRa_Mode          => Receive_Single);  --  Receive_Continuous);

      Hex   : constant array (Interfaces.Unsigned_8 range 0 .. 15) of Character
        := "0123456789ABCDEF";
      Text  : String (1 .. 3) := (1 .. 3 => Character'Val (0));
      Value : Interfaces.Unsigned_8;
      Next  : Interfaces.Unsigned_8;
   begin
      Read (Address.RegIrqFlags, Value);
      Write (Address.RegFifoAddrPtr, 0);
      Write (Address.RegOpMode, To_Byte (Mode));

      loop
         Text (1) := Hex (Value / 16);
         Text (2) := Hex (Value mod 16);
         puts (Text);

         loop
            Read (Address.RegIrqFlags, Next);
            exit when Next /= Value;
            Postpone_Execution (1);
         end loop;

         Value := Next;
      end loop;
   end Receive;

   -----------
   -- Sleep --
   -----------

   procedure Sleep is
      Mode : constant RegOpMode :=
        (LongRangeMode      => True,
         AccessSharedReg    => False,
         LowFrequencyModeOn => False,
         LoRa_Mode          => Sleep);
   begin
      Write (Address.RegOpMode, To_Byte (Mode));
   end Sleep;

   -----------
   -- Write --
   -----------

   procedure Write (Addr : Address.Register; Value : Interfaces.Unsigned_8) is
      use type Interfaces.Unsigned_8;
   begin
      Raw_Write (16#80# or Interfaces.Unsigned_8 (Addr), Value);
   end Write;

end LoRa;
