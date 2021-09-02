--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with System;

package body ESP32.GPIO is

   pragma Warnings (Off, "literal * is not referenced");

   type Pad_Function is
     (Pad_Function_1,
      Pad_Function_2,
      Pad_Function_3, --  always GPIO Matrix route
      Pad_Function_4,
      Pad_Function_5,
      Pad_Function_6);
   for Pad_Function use
     (Pad_Function_1 => 0,
      Pad_Function_2 => 1,
      Pad_Function_3 => 2, --  always GPIO Matrix route
      Pad_Function_4 => 3,
      Pad_Function_5 => 4,
      Pad_Function_6 => 5);
   --  IO_MUX function index as used in IO_MUX_x_REG/MCU_SEL

   NA : constant IO_MUX_Signal := GPIO_Matrix;

   IO_Mux_Pad_Summary : constant array
     (GPIO_Pad, Pad_Function) of IO_MUX_Signal :=
     (00 => (NA, CLK_OUT1, GPIO_Matrix, NA,        NA, EMAC_TX_CLK),
      05 => (NA, VSPICS0,  GPIO_Matrix, HS1_DATA6, NA, EMAC_RX_CLK),
      18 => (NA, VSPICLK,  GPIO_Matrix, HS1_DATA7, NA, NA),
      19 => (NA, VSPIQ,    GPIO_Matrix, U0CTS,     NA, EMAC_TXD0),
      25 => (NA, NA,       GPIO_Matrix, NA,        NA, EMAC_RXD0),
      27 => (NA, NA,       GPIO_Matrix, NA,        NA, EMAC_RX_DV),
         others => (others => NA));
   --  See IO_MUX Pad Summary table in the ESP32 reference

   type Drive_Strength is range 0 .. 3;
   --  A higher value corresponds with a higher strength.

   type IO_MUX_REG is record
      Reserved : Natural range 0 .. 0 := 0;
      MCU_SEL  : Pad_Function;  --  the IO_MUX function for this signal
      FUN_DRV  : Drive_Strength;  --  the drive strength of the pad.
      FUN_IE   : Boolean;  --  Input enable of the pad
      FUN_WPU  : Boolean;  --  Pull-up enable of the pad
      FUN_WPD  : Boolean;  --  Pull-down enable of the pad
      MCU_DRV  : Drive_Strength;
      --  Select the drive strength of the pad during sleep mode.
      MCU_IE   : Boolean;  --  Input enable of the pad during sleep mode
      MCU_WPU  : Boolean;  --  Pull-up enable of the pad
      MCU_WPD  : Boolean;  --  Pull-down enable of the pad
      SLP_SEL  : Boolean;  --  Sleep mode selection of this pad.
      MCU_OE   : Boolean;  --  Output enable of the pad in sleep mode
   end record
     with Size => 32, Volatile_Full_Access;

   for IO_MUX_REG use record
      Reserved at 0 range 15 .. 31;
      MCU_SEL at 0 range 12 .. 14;
      FUN_DRV at 0 range 10 .. 11;
      FUN_IE  at 0 range 9 .. 9;
      FUN_WPU at 0 range 8 .. 8;
      FUN_WPD at 0 range 7 .. 7;
      MCU_DRV at 0 range 5 .. 6;
      MCU_IE  at 0 range 4 .. 4;
      MCU_WPU at 0 range 3 .. 3;
      MCU_WPD at 0 range 2 .. 2;
      SLP_SEL at 0 range 1 .. 1;
      MCU_OE  at 0 range 0 .. 0;
   end record;

   type IO_MUX_REG_Offset is range 0 .. 36;

   type IO_MUX_REG_Offset_Map is array (GPIO_Pad) of IO_MUX_REG_Offset
     with Component_Size => 8;

   IO_MUX_REG_Map : constant IO_MUX_REG_Offset_Map :=
     (00 => 16#44# / 4, 01 => 16#88# / 4, 02 => 16#40# / 4, 03 => 16#84# / 4,
      04 => 16#48# / 4, 05 => 16#6c# / 4, 06 => 16#60# / 4, 07 => 16#64# / 4,
      08 => 16#68# / 4, 09 => 16#54# / 4, 10 => 16#58# / 4, 11 => 16#5c# / 4,
      12 => 16#34# / 4, 13 => 16#38# / 4, 14 => 16#30# / 4, 15 => 16#3c# / 4,
      16 => 16#4c# / 4, 17 => 16#50# / 4, 18 => 16#70# / 4, 19 => 16#74# / 4,
      20 => 16#78# / 4, 21 => 16#7c# / 4, 22 => 16#80# / 4, 23 => 16#8c# / 4,
      24 => 16#90# / 4, 25 => 16#24# / 4, 26 => 16#28# / 4, 27 => 16#2c# / 4,
      28 .. 31 => 0,
      32 => 16#1c# / 4, 33 => 16#20# / 4, 34 => 16#14# / 4, 35 => 16#18# / 4,
      36 => 16#04# / 4, 37 => 16#08# / 4, 38 => 16#0c# / 4, 39 => 16#10# / 4);

   IO_MUX_REG_Array : array (IO_MUX_REG_Offset) of IO_MUX_REG
     with Address => System'To_Address (16#3ff49000#), Import, Volatile;

   type Interrupt_Kind is
     (Disabled,
      Rising_Edge,
      Falling_Edge,
      Any_Edge,
      Low_Level,
      High_Level);

   type GPIO_PIN_REG is record
      Reserved_1       : Natural range 0 .. 0 := 0;
      PRO_CPU_NINT_ENA : Boolean;  --  PRO CPU non-maskable interrupt enable
      PRO_CPU_INT_ENA  : Boolean;  --  PRO CPU interrupt enable
      APP_CPU_NINT_ENA : Boolean;  --  APP CPU non-maskable interrupt enable
      APP_CPU_INT_ENA  : Boolean;  --  APP CPU interrupt enable
      Reserved_2       : Natural range 0 .. 0 := 0;
      WAKEUP_ENABLE    : Boolean;  --  only wake up the CPU from Light-sleep
      INT_TYPE         : Interrupt_Kind;
      Reserved_3       : Natural range 0 .. 0 := 0;
      PAD_DRIVER       : Boolean;  --  open drain output
      Reserved_4       : Natural range 0 .. 0 := 0;
   end record
     with Size => 32;

   for GPIO_PIN_REG use record
      Reserved_1       at 0 range 17 .. 31;
      PRO_CPU_NINT_ENA at 0 range 16 .. 16;
      PRO_CPU_INT_ENA  at 0 range 15 .. 15;
      APP_CPU_NINT_ENA at 0 range 14 .. 14;
      APP_CPU_INT_ENA  at 0 range 13 .. 13;
      Reserved_2       at 0 range 11 .. 12;
      WAKEUP_ENABLE    at 0 range 10 .. 10;
      INT_TYPE         at 0 range 7 .. 9;
      Reserved_3       at 0 range 3 .. 6;
      PAD_DRIVER       at 0 range 2 .. 2;
      Reserved_4       at 0 range 0 .. 1;
   end record;

   GPIO_PIN_REG_Array : array (GPIO_Pad) of GPIO_PIN_REG
     with Address => System'To_Address (16#3ff44088#), Import;

   subtype Input_Function is GPIO_Pad'Base range 0 .. 16#38#;
   --  A value of 0-39 selects which of the 40 GPIO Matrix input pins this
   --  signal is connected to, or 0x38 for a constantly high input or 0x30 for
   --  a constantly low input.

   Always_Low  : constant Input_Function := 16#30#;
   Always_High : constant Input_Function := 16#38#;

   type GPIO_FUNC_IN_SEL_CFG_REG is record
      Reserved             : Natural range 0 .. 0 := 0;
      GPIO_SIG_IN_SEL      : Boolean;  --  route through GPIO Matrix
      GPIO_FUNC_IN_INV_SEL : Boolean;  --  Invert the input value
      GPIO_FUNC_IN_SEL     : Input_Function;
      --  Selection control for peripheral input
   end record
     with Size => 32;

   for GPIO_FUNC_IN_SEL_CFG_REG use record
      Reserved             at 0 range 8 .. 31;
      GPIO_SIG_IN_SEL      at 0 range 7 .. 7;
      GPIO_FUNC_IN_INV_SEL at 0 range 6 .. 6;
      GPIO_FUNC_IN_SEL     at 0 range 0 .. 5;
   end record;

   GPIO_FUNC_IN_SEL_CFG_REG_Array : array
     (Input_Signal) of GPIO_FUNC_IN_SEL_CFG_REG
       with Address => System'To_Address ( 16#3FF44130#), Import, Volatile;

   type GPIO_FUNC_OUT_SEL_CFG_REG is record
      Reserved    : Natural range 0 .. 0 := 0;
      OEN_INV_SEL : Boolean;  --  Invert the output enable signal
      OEN_SEL     : Boolean;
      --  Force the output enable signal to be sourced from bit n of
      --  GPIO_ENABLE_REG
      OUT_INV_SEL : Boolean;  --  Invert the output value
      OUT_SEL     : Output_Signal;
      --  Selection control for GPIO output n. A value of s (0<=s<256) connects
      --  peripheral output s to GPIO output n. A value of 256 selects bit n
      --  of GPIO_OUT_REG/GPIO_OUT1_REG and GPIO_ENABLE_REG/GPIO_ENABLE1_REG
      --  as the output value and output enable. (R/W)
   end record
     with Size => 32;

   for GPIO_FUNC_OUT_SEL_CFG_REG use record
      Reserved    at 0 range 12 .. 31;
      OEN_INV_SEL at 0 range 11 .. 11;
      OEN_SEL     at 0 range 10 .. 10;
      OUT_INV_SEL at 0 range 9 .. 9;
      OUT_SEL     at 0 range 0 .. 8;
   end record;

   GPIO_FUNC_OUT_SEL_CFG_REG_Array : array
     (Natural range 0 .. 255) of GPIO_FUNC_OUT_SEL_CFG_REG
       with Address => System'To_Address ( 16#3FF44530#), Import, Volatile;

   type GPIO_32_Set is array (GPIO_Pad range 0 .. 31) of Boolean
     with Pack;

   type GPIO_8_Set is array (GPIO_Pad range 32 .. 39) of Boolean
     with Pack;

   GPIO_OUT_REG : GPIO_32_Set
     with Address => System'To_Address (16#3FF44004#), Import, Volatile;
   --  GPIO0-31 output value

   GPIO_OUT_W1TS_REG : GPIO_32_Set
     with Address => System'To_Address (16#3FF44008#), Import, Volatile;
   --  GPIO0-31 output set register

   GPIO_OUT_W1TC_REG : GPIO_32_Set
     with Address => System'To_Address (16#3FF4400C#), Import, Volatile;
   --  GPIO0-31 output clear register

   GPIO_OUT1_REG : GPIO_8_Set
     with Address => System'To_Address (16#3FF44010#), Import, Volatile;
   --  GPI32-39 output value

   GPIO_OUT1_W1TS_REG : GPIO_8_Set
     with Address => System'To_Address (16#3FF44014#), Import, Volatile;
   --  GPI32-39 output set register

   GPIO_OUT1_W1TC_REG : GPIO_8_Set
     with Address => System'To_Address (16#3FF44018#), Import, Volatile;
   --  GPI32-39 output clear register

   GPIO_ENABLE_REG : GPIO_32_Set
     with Address => System'To_Address (16#3FF44020#), Import, Volatile;
   --  GPIO0-31 output enable

   GPIO_ENABLE_W1TS_REG : GPIO_32_Set
     with Address => System'To_Address (16#3FF44024#), Import, Volatile;
   --  GPIO0-31 output enable set register

   GPIO_ENABLE_W1TC_REG : GPIO_32_Set
     with Address => System'To_Address (16#3FF44028#), Import, Volatile;
   --  GPIO0-31 output enable clear register

   GPIO_ENABLE1_REG : GPIO_8_Set
     with Address => System'To_Address (16#3FF4402C#), Import, Volatile;
   --  GPIO32-39 output enable

   GPIO_ENABLE1_W1TS_REG : GPIO_8_Set
     with Address => System'To_Address (16#3FF44030#), Import, Volatile;
   --  GPI32-39 output enable set register

   GPIO_ENABLE1_W1TC_REG : GPIO_8_Set
     with Address => System'To_Address (16#3FF44034#), Import, Volatile;
   --  GPI32-39 output enable clear register

   GPIO_IN_REG : GPIO_32_Set
     with Address => System'To_Address (16#3FF4403C#), Import, Volatile;
   --  GPIO0-31 input value

   GPIO_IN1_REG : GPIO_8_Set
     with Address => System'To_Address (16#3FF44040#), Import, Volatile;
   --  GPI32-39 input value

   function To_Set (Pad : GPIO_Pad) return GPIO_32_Set with Inline;
   function To_Set (Pad : GPIO_Pad) return GPIO_8_Set with Inline;

   ---------------
   -- Configure --
   ---------------

   procedure Configure (Value : Configuration) is
      Pad   : constant GPIO_Pad := Value.Pad;
      Funct : Pad_Function;
   begin
      if not Valid_IO_MUX_Signal (Pad, Value.IO_MUX) or else
        (Pad in Input_Only_GPIO_Pad and Value.Direction = Output)
      then
         raise Program_Error;
      elsif Value.IO_MUX = GPIO_Matrix then
         Funct := Pad_Function_3;
      else
         --  Find io_mux pad function if not GPIO, otherwise take FUN_3
         for J in Pad_Function loop
            if IO_Mux_Pad_Summary (Pad, J) = Value.IO_MUX then
               Funct := J;
               exit;
            end if;
         end loop;
      end if;

      case Value.Direction is
         when Output =>
            if Value.IO_MUX = GPIO_Matrix then
               --  Set the GPIO_FUNCx_OUT_SEL field in GPIO_FUNCx_OUT_SEL_CFG
               --  to the numeric index (Y) of desired peripheral output signal
               --  Y.
               GPIO_FUNC_OUT_SEL_CFG_REG_Array (GPIO_Pad'Pos (Pad)) :=
                 (OEN_INV_SEL => False,
                  OEN_SEL     => True,  --  turn GPIO_ENABLE on
                  OUT_INV_SEL => False,
                  OUT_SEL     => Value.Output,
                  Reserved    => 0);

               --  Set the GPIO_ENABLE bit on
               if Pad <= 31 then
                  GPIO_ENABLE_W1TS_REG :=  To_Set (Pad);
               else
                  GPIO_ENABLE1_W1TS_REG := To_Set (Pad);
               end if;

               --  For push/pull mode (default), clear PAD_DRIVER bit
               GPIO_PIN_REG_Array (Pad) :=
                 (PRO_CPU_NINT_ENA => False,
                  PRO_CPU_INT_ENA  => False,
                  APP_CPU_NINT_ENA => False,
                  APP_CPU_INT_ENA  => False,
                  WAKEUP_ENABLE    => False,
                  INT_TYPE         => Disabled,
                  PAD_DRIVER       => False,
                  others           => 0);

            end if;
         when Input =>
            if Value.IO_MUX = GPIO_Matrix and Value.Input /= None then
               --  Configure the GPIO_FUNCy_IN_SEL_CFG register corresponding
               --  to peripheral signal Y in the GPIO Matrix
               GPIO_FUNC_IN_SEL_CFG_REG_Array (Value.Input) :=
                 (GPIO_SIG_IN_SEL      => True,  --  route through GPIO Matrix
                  GPIO_FUNC_IN_INV_SEL => False,
                  GPIO_FUNC_IN_SEL     => Pad,
                  Reserved             => 0);

               --  Set the GPIO_FUNCx_OEN_SEL bit in the GPIO_FUNCx_OUT_SEL_CFG
               --  register to force the pin's output state to be determined
               --  always by the GPIO_ENABLE_DATA[x] field
               GPIO_FUNC_OUT_SEL_CFG_REG_Array (GPIO_Pad'Pos (Pad)) :=
                 (OEN_INV_SEL => False,
                  OEN_SEL     => True,  --  turn GPIO_ENABLE on
                  OUT_INV_SEL => False,
                  OUT_SEL     => GPIO_OUT,
                  Reserved    => 0);
            end if;
         when Disable =>
            null;
      end case;

      --  Configure the IO_MUX to select the GPIO Matrix.
      IO_MUX_REG_Array (IO_MUX_REG_Map (Pad)) :=
        (MCU_SEL  => Funct,
         FUN_DRV  => 0,
         FUN_IE   => Value.Direction = Input,
         FUN_WPU  => False,
         FUN_WPD  => False,
         MCU_DRV  => 0,
         MCU_IE   => Value.Direction = Input,
         MCU_WPU  => False,
         MCU_WPD  => False,
         SLP_SEL  => False,
         MCU_OE   => False,
         Reserved => 0);

      if Value.Direction /= Output then
         --  Clear GPIO_ENABLE to disable the output driver for the GPIO pad
         if Pad <= 31 then
            GPIO_ENABLE_W1TC_REG :=  To_Set (Pad);
         else
            GPIO_ENABLE1_W1TC_REG := To_Set (Pad);
         end if;
      end if;
   end Configure;

   -------------------
   -- Configure_All --
   -------------------

   procedure Configure_All (Value : Configuration_Array) is
   begin
      for Config of Value loop
         Configure (Config);
      end loop;
   end Configure_All;

   ---------------
   -- Get_Level --
   ---------------

   function Get_Level (Pad : GPIO_Pad) return Boolean is
   begin
      if Pad <= 31 then
         return GPIO_IN_REG (Pad);
      else
         return GPIO_IN1_REG (Pad);
      end if;
   end Get_Level;

   -------------------
   -- Set_Direction --
   -------------------

   procedure Set_Direction
     (Pad   : GPIO_Pad;
      Value : Pad_Direction) is
   begin
      if Value = Output then
         GPIO_FUNC_OUT_SEL_CFG_REG_Array (GPIO_Pad'Pos (Pad)) :=
           (OEN_INV_SEL => False,
            OEN_SEL     => False,
            OUT_INV_SEL => False,
            OUT_SEL     => GPIO_OUT,
            Reserved    => 0);

         if Pad <= 31 then
            GPIO_ENABLE_W1TS_REG :=  To_Set (Pad);
            --  GPIO_OUT_REG (Pad) := False;
         else
            GPIO_ENABLE1_W1TS_REG := To_Set (Pad);
         end if;

         GPIO_PIN_REG_Array (Pad) :=
           (PRO_CPU_NINT_ENA => False,
            PRO_CPU_INT_ENA  => False,
            APP_CPU_NINT_ENA => False,
            APP_CPU_INT_ENA  => False,
            WAKEUP_ENABLE    => False,
            INT_TYPE         => Disabled,
            PAD_DRIVER       => False,
            others           => 0);
      elsif Pad <= 31 then
         --  Disable output for Pad (0 .. 31)
         GPIO_ENABLE_W1TC_REG :=  To_Set (Pad);
      else
         --  Disable output for Pad (32 .. 39)
         GPIO_ENABLE1_W1TC_REG := To_Set (Pad);
      end if;

      IO_MUX_REG_Array (IO_MUX_REG_Map (Pad)) :=
        (MCU_SEL => Pad_Function_3,
         FUN_DRV => 0,
         FUN_IE  => Value = Input,
         FUN_WPU => False,
         FUN_WPD => False,
         MCU_DRV => 0,
         MCU_IE => Value = Input,
         MCU_WPU => False,
         MCU_WPD => False,
         SLP_SEL => False,
         MCU_OE  => False,
         Reserved => 0);
   end Set_Direction;

   procedure Set_Level
     (Pad   : GPIO_Pad;
      Value : Boolean) is
   begin
      if Pad <= 31 then
         if Value then
            GPIO_OUT_W1TS_REG := To_Set (Pad);
         else
            GPIO_OUT_W1TC_REG := To_Set (Pad);
         end if;
      else
         if Value then
            GPIO_OUT1_W1TS_REG := To_Set (Pad);
         else
            GPIO_OUT1_W1TC_REG := To_Set (Pad);
         end if;
      end if;
   end Set_Level;

   ------------
   -- To_Set --
   ------------

   function To_Set (Pad : GPIO_Pad) return GPIO_32_Set is
      Result : GPIO_32_Set := (others => False);
   begin
      Result (Pad) := True;
      --  return GPIO_32_Set'(Pad => True, others => False);
      --  return (0 .. Pad - 1 => False) & True & (Pad + 1 .. 31 => False);
      return Result;
   end To_Set;

   ------------
   -- To_Set --
   ------------

   function To_Set (Pad : GPIO_Pad) return GPIO_8_Set is
      Result : GPIO_8_Set := (others => False);
   begin
      Result (Pad) := True;
      return Result;
   end To_Set;

   -------------------------
   -- Valid_IO_MUX_Signal --
   -------------------------

   function Valid_IO_MUX_Signal
     (Pad : GPIO_Pad; IO_MUX : IO_MUX_Signal) return Boolean is
   begin
      return IO_MUX = GPIO_Matrix or else
        (for some J in Pad_Function => IO_Mux_Pad_Summary (Pad, J) = IO_MUX);
   end Valid_IO_MUX_Signal;

end ESP32.GPIO;
