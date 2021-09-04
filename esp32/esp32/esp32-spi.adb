--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package body ESP32.SPI is

   type SPI_CTRL_REG is record
      Reserved_1       : Natural range 0 .. 0 := 0;
      SPI_WR_BIT_ORDER : Boolean;  --  1: sends LSB first; 0: sends MSB first
      SPI_RD_BIT_ORDER : Boolean;
      SPI_FREAD_QIO    : Boolean;  --  four-line address R/W in QSPI mode
      SPI_FREAD_DIO    : Boolean;  --  two-line address R/W in QSPI mode
      Reserved_2       : Natural range 0 .. 0 := 0;
      SPI_WP           : Boolean;  --  write-protection signal in QSPI mode
      SPI_FREAD_QUAD   : Boolean;  --  four-line data reads in QSPI mode
      Reserved_3       : Natural range 0 .. 0 := 0;
      SPI_FREAD_DUAL   : Boolean;  --  two-line data reads in QSPI mode
      SPI_FASTRD_MODE  : Boolean;  --  Reserved.
      Reserved_4       : Natural range 0 .. 0 := 0;
   end record
     with Size => 32, Volatile_Full_Access;

   for SPI_CTRL_REG use record
      Reserved_1       at 0 range 27 .. 31;
      SPI_WR_BIT_ORDER at 0 range 26 .. 26;
      SPI_RD_BIT_ORDER at 0 range 25 .. 25;
      SPI_FREAD_QIO    at 0 range 24 .. 24;
      SPI_FREAD_DIO    at 0 range 23 .. 23;
      Reserved_2       at 0 range 22 .. 22;
      SPI_WP           at 0 range 21 .. 21;
      SPI_FREAD_QUAD   at 0 range 20 .. 20;
      Reserved_3       at 0 range 15 .. 19;
      SPI_FREAD_DUAL   at 0 range 14 .. 14;
      SPI_FASTRD_MODE  at 0 range 13 .. 13;
      Reserved_4       at 0 range 0 .. 12;
   end record;

   type SPI_CTRL2_REG is record
      SPI_CS_DELAY_NUM     : Natural range 0 .. 15;
      SPI_CS_DELAY_MODE    : Boolean;
      SPI_MOSI_DELAY_NUM   : Natural range 0 .. 7;
      SPI_MOSI_DELAY_MODE  : Boolean;
      SPI_MISO_DELAY_NUM   : Natural range 0 .. 7;
      SPI_MISO_DELAY_MODE  : Natural range 0 .. 3;
      SPI_CK_OUT_HIGH_MODE : Natural range 0 .. 15;
      Reserved             : Natural range 0 .. 0 := 0;
      SPI_HOLD_TIME        : Natural range 0 .. 15;
      SPI_SETUP_TIME       : Natural range 0 .. 15;
   end record
     with Size => 32, Volatile_Full_Access;

   for SPI_CTRL2_REG use record
      SPI_CS_DELAY_NUM     at 0 range 28 .. 31;
      SPI_CS_DELAY_MODE    at 0 range 26 .. 27;
      SPI_MOSI_DELAY_NUM   at 0 range 23 .. 25;
      SPI_MOSI_DELAY_MODE  at 0 range 21 .. 22;
      SPI_MISO_DELAY_NUM   at 0 range 18 .. 20;
      SPI_MISO_DELAY_MODE  at 0 range 16 .. 17;
      SPI_CK_OUT_HIGH_MODE at 0 range 12 .. 15;
      Reserved             at 0 range 8 .. 11;
      SPI_HOLD_TIME        at 0 range 4 .. 7;
      SPI_SETUP_TIME       at 0 range 0 .. 3;
   end record;

   type SPI_CLOCK_REG is record
      SPI_CLK_EQU_SYSCLK : Boolean;
      SPI_CLKDIV_PRE     : Natural range 0 .. 2 ** 13 - 1;
      SPI_CLKCNT_N       : Natural range 0 .. 2 ** 6 - 1;
      SPI_CLKCNT_H       : Natural range 0 .. 2 ** 6 - 1;
      SPI_CLKCNT_L       : Natural range 0 .. 2 ** 6 - 1;
   end record
     with Size => 32, Volatile_Full_Access;

   for SPI_CLOCK_REG use record
      SPI_CLK_EQU_SYSCLK at 0 range 31 .. 31;
      SPI_CLKDIV_PRE     at 0 range 18 .. 30;
      SPI_CLKCNT_N       at 0 range 12 .. 17;
      SPI_CLKCNT_H       at 0 range 6 .. 11;
      SPI_CLKCNT_L       at 0 range 0 .. 5;
   end record;

   type SPI_USER_REG is record
      SPI_USR_COMMAND       : Boolean;
      SPI_USR_ADDR          : Boolean;
      SPI_USR_DUMMY         : Boolean;
      SPI_USR_MISO          : Boolean;
      SPI_USR_MOSI          : Boolean;
      SPI_USR_DUMMY_IDLE    : Boolean;
      SPI_USR_MOSI_HIGHPART : Boolean;
      SPI_USR_MISO_HIGHPART : Boolean;
      Reserved_1            : Natural range 0 .. 0 := 0;
      SPI_SIO               : Boolean;
      SPI_FWRITE_QIO        : Boolean;
      SPI_FWRITE_DIO        : Boolean;
      SPI_FWRITE_QUAD       : Boolean;
      SPI_FWRITE_DUAL       : Boolean;
      SPI_WR_BYTE_ORDER     : Boolean;
      SPI_RD_BYTE_ORDER     : Boolean;
      Reserved_2            : Natural range 0 .. 0 := 0;
      SPI_CK_OUT_EDGE       : Boolean;
      SPI_CK_I_EDGE         : Boolean;
      SPI_CS_SETUP          : Boolean;
      SPI_CS_HOLD           : Boolean;
      Reserved_3            : Natural range 0 .. 0 := 0;
      SPI_DOUTDIN           : Boolean;
   end record
     with Size => 32;

   for SPI_USER_REG use record
      SPI_USR_COMMAND       at 0 range 31 .. 31;
      SPI_USR_ADDR          at 0 range 30 .. 30;
      SPI_USR_DUMMY         at 0 range 29 .. 29;
      SPI_USR_MISO          at 0 range 28 .. 28;
      SPI_USR_MOSI          at 0 range 27 .. 27;
      SPI_USR_DUMMY_IDLE    at 0 range 26 .. 26;
      SPI_USR_MOSI_HIGHPART at 0 range 25 .. 25;
      SPI_USR_MISO_HIGHPART at 0 range 24 .. 24;
      Reserved_1            at 0 range 17 .. 23;
      SPI_SIO               at 0 range 16 .. 16;
      SPI_FWRITE_QIO        at 0 range 15 .. 15;
      SPI_FWRITE_DIO        at 0 range 14 .. 14;
      SPI_FWRITE_QUAD       at 0 range 13 .. 13;
      SPI_FWRITE_DUAL       at 0 range 12 .. 12;
      SPI_WR_BYTE_ORDER     at 0 range 11 .. 11;
      SPI_RD_BYTE_ORDER     at 0 range 10 .. 10;
      Reserved_2            at 0 range 8 .. 9;
      SPI_CK_OUT_EDGE       at 0 range 7 .. 7;
      SPI_CK_I_EDGE         at 0 range 6 .. 6;
      SPI_CS_SETUP          at 0 range 5 .. 5;
      SPI_CS_HOLD           at 0 range 4 .. 4;
      Reserved_3            at 0 range 1 .. 3;
      SPI_DOUTDIN           at 0 range 0 .. 0;
   end record;

   type SPI_USER1_REG is record
      SPI_USR_ADDR_BITLEN    : Natural range 0 .. 2 ** 6 - 1;
      Reserved               : Natural range 0 .. 0 := 0;
      SPI_USR_DUMMY_CYCLELEN : Natural range 0 .. 2 ** 8 - 1;
   end record
     with Size => 32, Volatile_Full_Access;

   for SPI_USER1_REG use record
      SPI_USR_ADDR_BITLEN    at 0 range 26 .. 31;
      Reserved               at 0 range 8 .. 25;
      SPI_USR_DUMMY_CYCLELEN at 0 range 0 .. 7;
   end record;

   type SPI_PIN_REG is record
      Reserved_1         : Natural range 0 .. 0 := 0;
      SPI_CS_KEEP_ACTIVE : Boolean;
      SPI_CK_IDLE_EDGE   : Boolean;
      Reserved_2         : Natural range 0 .. 0 := 0;
      SPI_MASTER_CK_SEL  : Natural range 0 .. 7;
      Reserved_3         : Natural range 0 .. 0 := 0;
      SPI_MASTER_CS_POL  : Natural range 0 .. 7;
      SPI_CK_DIS         : Boolean;
      Reserved_4         : Natural range 0 .. 0 := 0;
      SPI_CS2_DIS        : Boolean;
      SPI_CS1_DIS        : Boolean;
      SPI_CS0_DIS        : Boolean;
   end record
     with Size => 32, Volatile_Full_Access;

   for SPI_PIN_REG use record
      Reserved_1         at 0 range 31 .. 31;
      SPI_CS_KEEP_ACTIVE at 0 range 30 .. 30;
      SPI_CK_IDLE_EDGE   at 0 range 29 .. 29;
      Reserved_2         at 0 range 14 .. 28;
      SPI_MASTER_CK_SEL  at 0 range 11 .. 13;
      Reserved_3         at 0 range 9 .. 10;
      SPI_MASTER_CS_POL  at 0 range 6 .. 8;
      SPI_CK_DIS         at 0 range 5 .. 5;
      Reserved_4         at 0 range 3 .. 4;
      SPI_CS2_DIS        at 0 range 2 .. 2;
      SPI_CS1_DIS        at 0 range 1 .. 1;
      SPI_CS0_DIS        at 0 range 0 .. 0;
   end record;

   type SPI_State is
     (Idle, Preparation, Send_Command, Send_Data,
      Read_Data, Write_Data, Wait, Done);

   type SPI_EXT2_REG is record
      Reserved : Natural range 0 .. 0 := 0;
      SPI_ST   : SPI_State;
   end record
     with Size => 32, Volatile_Full_Access;

   for SPI_EXT2_REG use record
      Reserved at 0 range 3 .. 31;
      SPI_ST   at 0 range 0 .. 2;
   end record;

   type SPI_CMD_REG is record
      Reserved_1 : Natural range 0 .. 0 := 0;
      SPI_USR    : Boolean;
      Reserved_2 : Natural range 0 .. 0 := 0;
   end record
     with Volatile_Full_Access, Object_Size => 32;

   for SPI_CMD_REG use record
      Reserved_1     at 0 range 19 .. 31;
      SPI_USR        at 0 range 18 .. 18;
      Reserved_2     at 0 range 0 .. 17;
   end record;

   type Buffer is array (0 .. 15) of Interfaces.Unsigned_32;

   type SPI_Peripheral is record
      SPI_CMD                  : SPI_CMD_REG;
      SPI_ADDR                 : Interfaces.Unsigned_32;
      SPI_CTRL                 : SPI_CTRL_REG;
      --  SPI_CTRL1                : SPI_CTRL1_REG;
      --  SPI_RD_STATUS            : SPI_RD_STATUS_REG;
      SPI_CTRL2                : SPI_CTRL2_REG;
      SPI_CLOCK                : SPI_CLOCK_REG;
      SPI_USER                 : SPI_USER_REG with Volatile_Full_Access;
      SPI_USER1                : SPI_USER1_REG;
      --  SPI_USER2                : SPI_USER2_REG;
      SPI_MOSI_DLEN            : Natural range 0 .. 2 ** 24 - 1;
      SPI_MISO_DLEN            : Natural range 0 .. 2 ** 24 - 1;
      --  SPI_SLV_WR_STATUS        : ESP32.UInt32;
      SPI_PIN                  : SPI_PIN_REG;
      --  SPI_SLAVE                : SPI_SLAVE_REG;
      --  SPI_SLAVE1               : SPI_SLAVE1_REG;
      --  SPI_SLAVE2               : SPI_SLAVE2_REG;
      --  SPI_SLAVE3               : SPI_SLAVE3_REG;
      --  SPI_SLV_WRBUF_DLEN       : SPI_SLV_WRBUF_DLEN_REG;
      --  SPI_SLV_RDBUF_DLEN       : SPI_SLV_RDBUF_DLEN_REG;
      --  SPI_CACHE_FCTRL          : SPI_CACHE_FCTRL_REG;
      --  SPI_CACHE_SCTRL          : SPI_CACHE_SCTRL_REG;
      --  SPI_SRAM_CMD             : SPI_SRAM_CMD_REG;
      --  SPI_SRAM_DRD_CMD         : SPI_SRAM_DRD_CMD_REG;
      --  SPI_SRAM_DWR_CMD         : SPI_SRAM_DWR_CMD_REG;
      --  SPI_SLV_RD_BIT           : SPI_SLV_RD_BIT_REG;
      SPI_W                    : Buffer;
      --  SPI_W15                  : ESP32.UInt32;
      --  SPI_TX_CRC               : ESP32.UInt32;
      --  SPI_EXT0                 : SPI_EXT0_REG;
      --  SPI_EXT1                 : SPI_EXT1_REG;
      SPI_EXT2                 : SPI_EXT2_REG;
      --  SPI_EXT3                 : SPI_EXT3_REG;
      --  SPI_DMA_CONF             : SPI_DMA_CONF_REG;
      --  SPI_DMA_OUT_LINK         : SPI_DMA_OUT_LINK_REG;
      --  SPI_DMA_IN_LINK          : SPI_DMA_IN_LINK_REG;
      --  SPI_DMA_STATUS           : SPI_DMA_STATUS_REG;
      --  SPI_DMA_INT_ENA          : SPI_DMA_INT_ENA_REG;
      --  SPI_DMA_INT_RAW          : SPI_DMA_INT_RAW_REG;
      --  SPI_DMA_INT_ST           : SPI_DMA_INT_ST_REG;
      --  SPI_DMA_INT_CLR          : SPI_DMA_INT_CLR_REG;
      --  SPI_IN_ERR_EOF_DES_ADDR  : ESP32.UInt32;
      --  SPI_IN_SUC_EOF_DES_ADDR  : ESP32.UInt32;
      --  SPI_INLINK_DSCR          : ESP32.UInt32;
      --  SPI_INLINK_DSCR_BF0      : ESP32.UInt32;
      --  SPI_INLINK_DSCR_BF1      : ESP32.UInt32;
      --  SPI_OUT_EOF_BFR_DES_ADDR : ESP32.UInt32;
      --  SPI_OUT_EOF_DES_ADDR     : ESP32.UInt32;
      --  SPI_OUTLINK_DSCR         : ESP32.UInt32;
      --  SPI_OUTLINK_DSCR_BF0     : ESP32.UInt32;
      --  SPI_OUTLINK_DSCR_BF1     : ESP32.UInt32;
      --  SPI_DMA_RSTATUS          : ESP32.UInt32;
      --  SPI_DMA_TSTATUS          : ESP32.UInt32;
      --  SPI_DATE                 : SPI_DATE_REG;
   end record;

   for SPI_Peripheral use record
      SPI_CMD                  at 16#0# range 0 .. 31;
      SPI_ADDR                 at 16#4# range 0 .. 31;
      SPI_CTRL                 at 16#8# range 0 .. 31;
      --  SPI_CTRL1                at 16#C# range 0 .. 31;
      --  SPI_RD_STATUS            at 16#10# range 0 .. 31;
      SPI_CTRL2                at 16#14# range 0 .. 31;
      SPI_CLOCK                at 16#18# range 0 .. 31;
      SPI_USER                 at 16#1C# range 0 .. 31;
      SPI_USER1                at 16#20# range 0 .. 31;
      --  SPI_USER2                at 16#24# range 0 .. 31;
      SPI_MOSI_DLEN            at 16#28# range 0 .. 31;
      SPI_MISO_DLEN            at 16#2C# range 0 .. 31;
      --  SPI_SLV_WR_STATUS        at 16#30# range 0 .. 31;
      SPI_PIN                  at 16#34# range 0 .. 31;
      --  SPI_SLAVE                at 16#38# range 0 .. 31;
      --  SPI_SLAVE1               at 16#3C# range 0 .. 31;
      --  SPI_SLAVE2               at 16#40# range 0 .. 31;
      --  SPI_SLAVE3               at 16#44# range 0 .. 31;
      --  SPI_SLV_WRBUF_DLEN       at 16#48# range 0 .. 31;
      --  SPI_SLV_RDBUF_DLEN       at 16#4C# range 0 .. 31;
      --  SPI_CACHE_FCTRL          at 16#50# range 0 .. 31;
      --  SPI_CACHE_SCTRL          at 16#54# range 0 .. 31;
      --  SPI_SRAM_CMD             at 16#58# range 0 .. 31;
      --  SPI_SRAM_DRD_CMD         at 16#5C# range 0 .. 31;
      --  SPI_SRAM_DWR_CMD         at 16#60# range 0 .. 31;
      --  SPI_SLV_RD_BIT           at 16#64# range 0 .. 31;
      SPI_W                   at 16#80# range 0 .. 32 * 16 - 1;
      --  SPI_W1                   at 16#84# range 0 .. 31;
      --  SPI_W2                   at 16#88# range 0 .. 31;
      --  SPI_W3                   at 16#8C# range 0 .. 31;
      --  SPI_W4                   at 16#90# range 0 .. 31;
      --  SPI_W5                   at 16#94# range 0 .. 31;
      --  SPI_W6                   at 16#98# range 0 .. 31;
      --  SPI_W7                   at 16#9C# range 0 .. 31;
      --  SPI_W8                   at 16#A0# range 0 .. 31;
      --  SPI_W9                   at 16#A4# range 0 .. 31;
      --  SPI_W10                  at 16#A8# range 0 .. 31;
      --  SPI_W11                  at 16#AC# range 0 .. 31;
      --  SPI_W12                  at 16#B0# range 0 .. 31;
      --  SPI_W13                  at 16#B4# range 0 .. 31;
      --  SPI_W14                  at 16#B8# range 0 .. 31;
      --  SPI_W15                  at 16#BC# range 0 .. 31;
      --  SPI_TX_CRC               at 16#C0# range 0 .. 31;
      --  SPI_EXT0                 at 16#F0# range 0 .. 31;
      --  SPI_EXT1                 at 16#F4# range 0 .. 31;
      SPI_EXT2                 at 16#F8# range 0 .. 31;
      --  SPI_EXT3                 at 16#FC# range 0 .. 31;
      --  SPI_DMA_CONF             at 16#100# range 0 .. 31;
      --  SPI_DMA_OUT_LINK         at 16#104# range 0 .. 31;
      --  SPI_DMA_IN_LINK          at 16#108# range 0 .. 31;
      --  SPI_DMA_STATUS           at 16#10C# range 0 .. 31;
      --  SPI_DMA_INT_ENA          at 16#110# range 0 .. 31;
      --  SPI_DMA_INT_RAW          at 16#114# range 0 .. 31;
      --  SPI_DMA_INT_ST           at 16#118# range 0 .. 31;
      --  SPI_DMA_INT_CLR          at 16#11C# range 0 .. 31;
      --  SPI_IN_ERR_EOF_DES_ADDR  at 16#120# range 0 .. 31;
      --  SPI_IN_SUC_EOF_DES_ADDR  at 16#124# range 0 .. 31;
      --  SPI_INLINK_DSCR          at 16#128# range 0 .. 31;
      --  SPI_INLINK_DSCR_BF0      at 16#12C# range 0 .. 31;
      --  SPI_INLINK_DSCR_BF1      at 16#130# range 0 .. 31;
      --  SPI_OUT_EOF_BFR_DES_ADDR at 16#134# range 0 .. 31;
      --  SPI_OUT_EOF_DES_ADDR     at 16#138# range 0 .. 31;
      --  SPI_OUTLINK_DSCR         at 16#13C# range 0 .. 31;
      --  SPI_OUTLINK_DSCR_BF0     at 16#140# range 0 .. 31;
      --  SPI_OUTLINK_DSCR_BF1     at 16#144# range 0 .. 31;
      --  SPI_DMA_RSTATUS          at 16#148# range 0 .. 31;
      --  SPI_DMA_TSTATUS          at 16#14C# range 0 .. 31;
      --  SPI_DATE                 at 16#3FC# range 0 .. 31;
   end record;

   SPI_2_Registers : aliased SPI_Peripheral
     with Import, Address => System'To_Address (16#3FF64000#);

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (Host       : Controller_Name;
      Bit_Order  : System.Bit_Order := System.High_Order_First;
      Byte_Order : System.Bit_Order := System.Low_Order_First;
      Frequency  : Natural;
      CP_Mode    : Clock_Polarity_And_Phase := Mode0)
   is
      use type System.Bit_Order;
      F_apb : constant := 80_000_000;
      N : Natural;
   begin
      if Host /= SPI_2 then
         raise Program_Error with "Unimplemented Host";
      end if;

      SPI_2_Registers.SPI_CTRL :=
        (SPI_WR_BIT_ORDER => Bit_Order = System.Low_Order_First,
         SPI_RD_BIT_ORDER => Bit_Order = System.Low_Order_First,
         SPI_FREAD_QIO    => False,
         SPI_FREAD_DIO    => False,
         SPI_WP           => False,
         SPI_FREAD_QUAD   => False,
         SPI_FREAD_DUAL   => False,
         SPI_FASTRD_MODE  => False,
         others           => 0);

      SPI_2_Registers.SPI_CTRL2 :=
        (SPI_CS_DELAY_NUM     => 0,
         SPI_CS_DELAY_MODE    => False,
         SPI_MOSI_DELAY_NUM   => 0,
         SPI_MOSI_DELAY_MODE  => False,
         SPI_MISO_DELAY_NUM   => 0,
         SPI_MISO_DELAY_MODE  => 1 + Boolean'Pos (CP_Mode in Mode0 | Mode3),
         SPI_CK_OUT_HIGH_MODE => 0,
         Reserved             => 0,
         SPI_HOLD_TIME        => 0,
         SPI_SETUP_TIME       => 0);

      SPI_2_Registers.SPI_PIN :=
        (SPI_CS_KEEP_ACTIVE => False,
         SPI_CK_IDLE_EDGE   => CP_Mode in Mode2 | Mode3,
         SPI_MASTER_CK_SEL  => 0,
         SPI_MASTER_CS_POL  => 0,
         SPI_CK_DIS         => False,
         SPI_CS2_DIS        => True,
         SPI_CS1_DIS        => True,
         SPI_CS0_DIS        => False,
         others             => 0);

      SPI_2_Registers.SPI_USER :=
        (SPI_USR_COMMAND       => False,
         SPI_USR_ADDR          => False,
         SPI_USR_DUMMY         => False,
         SPI_USR_MISO          => False,
         SPI_USR_MOSI          => False,
         SPI_USR_DUMMY_IDLE    => False,
         SPI_USR_MOSI_HIGHPART => True,
         SPI_USR_MISO_HIGHPART => False,
         SPI_SIO               => False,
         SPI_FWRITE_QIO        => False,
         SPI_FWRITE_DIO        => False,
         SPI_FWRITE_QUAD       => False,
         SPI_FWRITE_DUAL       => False,
         SPI_WR_BYTE_ORDER     => False,
         SPI_RD_BYTE_ORDER     => False,
         SPI_CK_OUT_EDGE       => CP_Mode in Mode1 | Mode2,
         SPI_CK_I_EDGE         => False,
         SPI_CS_SETUP          => False,
         SPI_CS_HOLD           => False,
         SPI_DOUTDIN           => False,  --  Full duplex
         others                => 0);

      --  A silly clock calculation
      N := F_apb / Frequency;

      SPI_2_Registers.SPI_CLOCK :=
        (SPI_CLK_EQU_SYSCLK => False,
         SPI_CLKDIV_PRE     => 0,
         SPI_CLKCNT_N       => N - 1,
         SPI_CLKCNT_H       => N / 2 - 1,
         SPI_CLKCNT_L       => N - 1);
   end Configure;

   --------------------------
   -- Half_Duplex_Transfer --
   --------------------------

   procedure Half_Duplex_Transfer
     (Host     : Controller_Name;
      Command  : Half_Duplex_Command := (Size => 0);
      Address  : Half_Duplex_Address := (Size => 0);
      Dummy    : Dummy_Size := 0;
      MOSI     : Data_Array := (1 .. 0 => 0);
      MISO     : out Data_Array)
   is
      function Minus_One (X : Natural) return Natural;
      --  If X > 0 return X-1, otherwise return 0

      ---------------
      -- Minus_One --
      ---------------

      function Minus_One (X : Natural) return Natural is
      begin
         if X = 0 then
            return 0;
         else
            return X - 1;
         end if;
      end Minus_One;

      SPI_USER : constant SPI_USER_REG := SPI_2_Registers.SPI_USER;
      Output   : Buffer with Import, Address => MOSI'Address;
   begin
      if Host /= SPI_2 or Command.Size > 0 then
         raise Program_Error with "Unimplemented Host";
      end if;

      --  FIXME: Where should I put command.data/command.size?

      SPI_2_Registers.SPI_MOSI_DLEN := MOSI'Length * 8;
      SPI_2_Registers.SPI_MISO_DLEN := MISO'Length * 8;

      --  Copy MOSI to SPI_W (8 .. 15)
      for J in 0 .. (MOSI'Length + 3) / 4 loop
         SPI_2_Registers.SPI_W (8 + J) := Output (J);
      end loop;

      SPI_2_Registers.SPI_USER1 :=
        (SPI_USR_ADDR_BITLEN    => Minus_One (Address.Size),
         SPI_USR_DUMMY_CYCLELEN => Minus_One (Dummy),
         Reserved               => 0);

      if Address.Size > 0 then
         SPI_2_Registers.SPI_ADDR := Interfaces.Shift_Left
           (Interfaces.Unsigned_32 (Address.Data),
            32 - Address.Size);
      end if;

      --  Patch SPI_USER with correct USR_* flags.
      --  Use delta aggregate from Ada 202X???
      SPI_2_Registers.SPI_USER :=
        (SPI_USR_COMMAND       => Command.Size > 0,
         SPI_USR_ADDR          => Address.Size > 0,
         SPI_USR_DUMMY         => Dummy > 0,
         SPI_USR_MISO          => MISO'Length > 0,
         SPI_USR_MOSI          => MOSI'Length > 0,
         SPI_USR_DUMMY_IDLE    => SPI_USER.SPI_USR_DUMMY_IDLE,
         SPI_USR_MOSI_HIGHPART => SPI_USER.SPI_USR_MOSI_HIGHPART,
         SPI_USR_MISO_HIGHPART => SPI_USER.SPI_USR_MISO_HIGHPART,
         SPI_SIO               => SPI_USER.SPI_SIO,
         SPI_FWRITE_QIO        => SPI_USER.SPI_FWRITE_QIO,
         SPI_FWRITE_DIO        => SPI_USER.SPI_FWRITE_DIO,
         SPI_FWRITE_QUAD       => SPI_USER.SPI_FWRITE_QUAD,
         SPI_FWRITE_DUAL       => SPI_USER.SPI_FWRITE_DUAL,
         SPI_WR_BYTE_ORDER     => SPI_USER.SPI_WR_BYTE_ORDER,
         SPI_RD_BYTE_ORDER     => SPI_USER.SPI_RD_BYTE_ORDER,
         SPI_CK_OUT_EDGE       => SPI_USER.SPI_CK_OUT_EDGE,
         SPI_CK_I_EDGE         => SPI_USER.SPI_CK_I_EDGE,
         SPI_CS_SETUP          => SPI_USER.SPI_CS_SETUP,
         SPI_CS_HOLD           => SPI_USER.SPI_CS_HOLD,
         SPI_DOUTDIN           => SPI_USER.SPI_DOUTDIN,  --  Full duplex
         others                => 0);

      --  Start transfer
      SPI_2_Registers.SPI_CMD.SPI_USR := True;

      --  Wait for the transfer to complete
      while SPI_2_Registers.SPI_CMD.SPI_USR loop
         null;
      end loop;

      --  Copy SPI_W (0 .. 7) to MISO
      declare
         Offset : Natural := 0;
         Word   : Interfaces.Unsigned_32 := 0;
      begin
         for J in MISO'Range loop
            if Offset mod 4 = 0 then
               Word := SPI_2_Registers.SPI_W (Offset / 4);
            end if;

            MISO (J) := Ada.Streams.Stream_Element'Mod (Word);
            Word := Interfaces.Shift_Right (Word, 8);
            Offset := Offset + 1;
         end loop;
      end;
   end Half_Duplex_Transfer;

   --------------------------
   -- Half_Duplex_Transfer --
   --------------------------

   procedure Half_Duplex_Transfer
     (Host     : Controller_Name;
      Command  : Half_Duplex_Command := (Size => 0);
      Address  : Half_Duplex_Address := (Size => 0);
      Dummy    : Dummy_Size := 0;
      MOSI     : Data_Array := (1 .. 0 => 0))
   is
      MISO : Data_Array (1 .. 0);
   begin
      Half_Duplex_Transfer (Host, Command, Address, Dummy, MOSI, MISO);
   end Half_Duplex_Transfer;

end ESP32.SPI;
