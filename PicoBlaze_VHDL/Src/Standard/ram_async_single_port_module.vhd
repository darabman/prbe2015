-- =============================================================================================================
-- *
-- * Copyright (c) University of York
-- *
-- * File Name: ram_async_single_port_module.vhd
-- *
-- * Version: V1.0
-- *
-- * Release Date:
-- *
-- * Author(s): M.Freeman
-- *
-- * Description: Random Access Memory single port module
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
 
ENTITY ram_async_single_port_module IS
PORT (
  clk : IN STD_LOGIC;
  we : IN STD_LOGIC;  
  addr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
  data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  
  data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) );
END ram_async_single_port_module;
 
ARCHITECTURE ram_async_single_port_module_arch OF ram_async_single_port_module IS

  --
  -- components
  -- 

  COMPONENT RAM16X1S
  GENERIC(
    INIT : BIT_VECTOR := X"0000");
  PORT(
    O : OUT STD_LOGIC;
    A0 : IN STD_LOGIC;
    A1 : IN STD_LOGIC;
    A2 : IN STD_LOGIC;
    A3 : IN STD_LOGIC;
    D : IN STD_LOGIC;
    WCLK : IN STD_LOGIC;
    WE : IN STD_LOGIC );
  END COMPONENT; 

  ATTRIBUTE BOX_TYPE OF RAM16X1S : COMPONENT IS "PRIMITIVE";
   
BEGIN

  ram_module : FOR i IN 0 TO 7 GENERATE
    ram : RAM16X1S PORT MAP(
      O => data_out(i),
      A0 => addr(0),
      A1 => addr(1),
      A2 => addr(2),
      A3 => addr(3),
      D => data_in(i),
      WCLK => clk, 
      WE => we );
  END GENERATE;    
  
END ram_async_single_port_module_arch;
 
