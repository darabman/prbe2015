-- =============================================================================================================
-- *
-- * Copyright (c) University of York
-- *
-- * File Name: ram_async_dual_port_module.vhd
-- *
-- * Version: V1.0
-- *
-- * Release Date:
-- *
-- * Author(s): M.Freeman
-- *
-- * Description: Random Access Memory dual port module
-- *
-- * Change History:  $Author: $
-- *                  $Date: $
-- *                  $Revision: $
-- *
-- * Conditions of Use: THIS CODE IS COPYRIGHT AND IS SUPPLIED "AS IS" WITHOUT WARRANTY OF ANY KIND, INCLUDING,
-- *                    BUT NOT LIMITED TO, ANY IMPLIED WARRANTY OF MERCHANTABILITY AND FITNESS FOR A
-- *                    PARTICULAR PURPOSE.
-- *
-- =============================================================================================================
 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
 
LIBRARY UNISIM;
USE UNISIM.vcomponents.ALL;
 
ENTITY ram_async_dual_port_module IS
PORT (
  clk : IN STD_LOGIC;
  port_a_we : IN STD_LOGIC;  
  port_a_addr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
  port_a_data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  
  port_a_data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
  port_b_addr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
  port_b_data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) );
END ram_async_dual_port_module;
 
ARCHITECTURE ram_async_dual_port_module_arch OF ram_async_dual_port_module IS

  --
  -- components
  -- 

  COMPONENT RAM16X1D
  GENERIC(
    INIT : BIT_VECTOR := X"0000");
  PORT(
    DPO : OUT STD_LOGIC;    -- Read-only 1-bit data output for DPRA
    SPO : OUT STD_LOGIC;    -- R/W 1-bit data output for A0-A3
    A0 : IN STD_LOGIC;      -- R/W address[0] input bit
    A1 : IN STD_LOGIC;      -- R/W address[1] input bit
    A2 : IN STD_LOGIC;      -- R/W address[2] input bit
    A3 : IN STD_LOGIC;      -- R/W ddress[3] input bit
    D : IN STD_LOGIC;       -- Write 1-bit data input
    DPRA0 : IN STD_LOGIC;   -- Read-only address[0] input bit
    DPRA1 : IN STD_LOGIC;   -- Read-only address[1] input bit
    DPRA2 : IN STD_LOGIC;   -- Read-only address[2] input bit
    DPRA3 : IN STD_LOGIC;   -- Read-only address[3] input bit
    WCLK : IN STD_LOGIC;    -- Write clock input
    WE : IN STD_LOGIC );    -- Write enable inputRAM16X1S
  END COMPONENT;
  
  ATTRIBUTE BOX_TYPE OF RAM16X1D : COMPONENT IS "PRIMITIVE";
   
BEGIN

  ram_module : FOR i IN 0 TO 7 GENERATE
    ram : RAM16X1D PORT MAP(
      WCLK => clk, 
      WE => port_a_we,
      SPO => port_a_data_out(i),
      A0 => port_a_addr(0),
      A1 => port_a_addr(1),
      A2 => port_a_addr(2),
      A3 => port_a_addr(3),
      D => port_a_data_in(i),
      DPO => port_b_data_out(i),
      DPRA0 => port_b_addr(0),
      DPRA1 => port_b_addr(1),
      DPRA2 => port_b_addr(2),
      DPRA3 => port_b_addr(3) );
  END GENERATE;    
  
END ram_async_dual_port_module_arch;
 
