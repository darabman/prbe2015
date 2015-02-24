-- =============================================================================================================
-- *
-- * Copyright (c) University of York
-- *
-- * File Name: internal_ram_32K.vhd
-- *
-- * Version: V1.0
-- *
-- * Release Date: 
-- *
-- * Author(s): M.Freeman
-- *
-- * Description:
-- *
-- * Change History:  $Author: $
-- *                  $Date: $
-- *                  $Revision: $
-- *
-- * Conditions of Use: THIS CODE IS COPYRIGHT AND IS SUPPLIED "AS IS" WITHOUT WARRANTY OF ANY KIND, INCLUDING,
-- *                    BUT NOT LIMITED TO, ANY IMPLIED WARRANTY OF MERCHANTABILITY AND FITNESS FOR A
-- *                    PARTICULAR PURPOSE.
-- *
-- * Notes:
-- *
-- =============================================================================================================

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY internal_ram_32K IS
PORT(
  clk_i : IN STD_LOGIC;
  rst_i : IN STD_LOGIC;
  dat_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0); 
  dat_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); 
    
  adr_i : IN STD_LOGIC_VECTOR(14 DOWNTO 0); 
  we_i : IN STD_LOGIC;
  stb_i : IN STD_LOGIC;
  cyc_i : IN STD_LOGIC;    
  ack_o : OUT STD_LOGIC ); 
END internal_ram_32K;

ARCHITECTURE internal_ram_32K_arch OF internal_ram_32K IS

  COMPONENT ram_single_port_32K 
  PORT (
    clk_i : IN STD_LOGIC;
    we_i : IN STD_LOGIC;  
    adr_i : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
    dat_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  
    dat_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) );
  END COMPONENT;

  COMPONENT pulse
  PORT (
    clk: IN STD_LOGIC;
    clr: IN STD_LOGIC;
    pulse_i: IN STD_LOGIC;
    pulse_o: OUT STD_LOGIC;
    pulse_d: OUT STD_LOGIC );
  END COMPONENT;

  SIGNAL ack_int : STD_LOGIC;
  SIGNAL we_int : STD_LOGIC;  
    
BEGIN

  --
  -- signal buffers
  --

  ack_int <= cyc_i and stb_i;
  we_int  <= we_i and cyc_i and stb_i;

  --
  -- pulse 
  --
  ram_pulse : pulse PORT MAP(
    clk => clk_i,
    clr => rst_i,
    pulse_i => ack_int,
    pulse_o => ack_o,
    pulse_d => OPEN );
  
  --
  -- RAM
  --
  ram_inst : ram_single_port_32K PORT MAP(
    clk_i => clk_i,
    we_i => we_int,
    adr_i => adr_i,
    dat_i => dat_i,
    dat_o => dat_o );
    
END internal_ram_32K_arch;


