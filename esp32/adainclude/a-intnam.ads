--  Copyright (C) 2016-2021 Free Software Foundation, Inc.

--  This file is part of the Cortex GNAT RTS package.
--
--  The Cortex GNAT RTS package is free software; you can redistribute
--  it and/or modify it under the terms of the GNU General Public
--  License as published by the Free Software Foundation; either
--  version 3 of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--  General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; see the file COPYING3.  If not, see
--  <http://www.gnu.org/licenses/>.

--  For the ESP32. See ESP32 Technical Reference Manual, 2.3.1 Peripheral
--  Interrupt Source

package Ada.Interrupts.Names is

   MAC_INTR            : constant Interrupt_ID := 0;
   MAC_NMI             : constant Interrupt_ID := 1;
   BB_INT              : constant Interrupt_ID := 2;
   BT_MAC_INT          : constant Interrupt_ID := 3;
   BT_BB_INT           : constant Interrupt_ID := 4;
   BT_BB_NMI           : constant Interrupt_ID := 5;
   RWBT_IRQ            : constant Interrupt_ID := 6;
   RWBLE_IRQ           : constant Interrupt_ID := 7;
   RWBT_NMI            : constant Interrupt_ID := 8;
   RWBLE_NMI           : constant Interrupt_ID := 9;
   SLC0_INTR           : constant Interrupt_ID := 10;
   SLC1_INTR           : constant Interrupt_ID := 11;
   UHCI0_INTR          : constant Interrupt_ID := 12;
   UHCI1_INTR          : constant Interrupt_ID := 13;
   TG_T0_LEVEL_INT     : constant Interrupt_ID := 14;
   TG_T1_LEVEL_INT     : constant Interrupt_ID := 15;
   TG_WDT_LEVEL_INT    : constant Interrupt_ID := 16;
   TG_LACT_LEVEL_INT   : constant Interrupt_ID := 17;
   TG1_T0_LEVEL_INT    : constant Interrupt_ID := 18;
   TG1_T1_LEVEL_INT    : constant Interrupt_ID := 19;
   TG1_WDT_LEVEL_INT   : constant Interrupt_ID := 20;
   TG1_LACT_LEVEL_INT  : constant Interrupt_ID := 21;
   GPIO_INTERRUPT      : constant Interrupt_ID := 22;
   GPIO_INTERRUPT_NMI  : constant Interrupt_ID := 23;
   CPU_INTR_FROM_CPU_0 : constant Interrupt_ID := 24;
   CPU_INTR_FROM_CPU_1 : constant Interrupt_ID := 25;
   CPU_INTR_FROM_CPU_2 : constant Interrupt_ID := 26;
   CPU_INTR_FROM_CPU_3 : constant Interrupt_ID := 27;
   SPI_INTR_0          : constant Interrupt_ID := 28;
   SPI_INTR_1          : constant Interrupt_ID := 29;
   SPI_INTR_2          : constant Interrupt_ID := 30;
   SPI_INTR_3          : constant Interrupt_ID := 31;

   I2S0_INT            : constant Interrupt_ID := 32;
   I2S1_INT            : constant Interrupt_ID := 33;
   UART_INTR           : constant Interrupt_ID := 34;
   UART1_INTR          : constant Interrupt_ID := 35;
   UART2_INTR          : constant Interrupt_ID := 36;
   SDIO_HOST_INTERRUPT : constant Interrupt_ID := 37;
   EMAC_INT            : constant Interrupt_ID := 38;
   PWM0_INTR           : constant Interrupt_ID := 39;
   PWM1_INTR           : constant Interrupt_ID := 40;
   PWM2_INTR           : constant Interrupt_ID := 41;
   PWM3_INTR           : constant Interrupt_ID := 42;
   LEDC_INT            : constant Interrupt_ID := 43;
   EFUSE_INT           : constant Interrupt_ID := 44;
   CAN_INT             : constant Interrupt_ID := 45;
   RTC_CORE_INTR       : constant Interrupt_ID := 46;
   RMT_INTR            : constant Interrupt_ID := 47;
   PCNT_INTR           : constant Interrupt_ID := 48;
   I2C_EXT0_INTR       : constant Interrupt_ID := 49;
   I2C_EXT1_INTR       : constant Interrupt_ID := 50;
   RSA_INTR            : constant Interrupt_ID := 51;
   SPI1_DMA_INT        : constant Interrupt_ID := 52;
   SPI2_DMA_INT        : constant Interrupt_ID := 53;
   SPI3_DMA_INT        : constant Interrupt_ID := 54;
   WDG_INT             : constant Interrupt_ID := 55;
   TIMER_INT1          : constant Interrupt_ID := 56;
   TIMER_INT2          : constant Interrupt_ID := 57;
   TG_T0_EDGE_INT      : constant Interrupt_ID := 58;
   TG_T1_EDGE_INT      : constant Interrupt_ID := 59;
   TG_WDT_EDGE_INT     : constant Interrupt_ID := 60;
   TG_LACT_EDGE_INT    : constant Interrupt_ID := 61;
   TG1_T0_EDGE_INT     : constant Interrupt_ID := 62;
   TG1_T1_EDGE_INT     : constant Interrupt_ID := 63;

   TG1_WDT_EDGE_INT    : constant Interrupt_ID := 64;
   TG1_LACT_EDGE_INT   : constant Interrupt_ID := 65;
   MMU_IA_INT          : constant Interrupt_ID := 66;
   MPU_IA_INT          : constant Interrupt_ID := 67;
   CACHE_IA_INT        : constant Interrupt_ID := 68;

end Ada.Interrupts.Names;
