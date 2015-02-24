-- =============================================================================================================
-- *
-- * Copyright (c) University of York
-- *
-- * File Name: ram_64b.vhd
-- *
-- * Version: V1.0
-- *
-- * Release Date:
-- *
-- * Author(s): M.Freeman
-- *
-- * Description: data memory 128 byte
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

LIBRARY UNISIM;
USE UNISIM.vcomponents.ALL;

ENTITY RAM_128B IS 
PORT (
  clk_i : IN STD_LOGIC;
  rst_i : IN STD_LOGIC;
  adr_i : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
  dat_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  
  dat_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
  we_i : IN STD_LOGIC;
  stb_i : IN STD_LOGIC; 
  ack_o : OUT STD_LOGIC );  
END RAM_128B;

ARCHITECTURE RAM_128B_arch OF RAM_128B IS 

  --
  -- components
  --
  
  COMPONENT ram_async_single_port_module
  PORT (
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;  
    addr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  
    data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) );
  END COMPONENT;  
    
  --
  -- signals 
  --
  
  TYPE data_out_type IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR (7 DOWNTO 0);
  TYPE we_type IS ARRAY (0 TO 7) OF STD_LOGIC;  
  
  SIGNAL data_out : data_out_type;
  SIGNAL write_enable : we_type;
  SIGNAL wr : STD_LOGIC;  
  
BEGIN

  --
  -- signal buffers
  --
  
  ack_o <= stb_i;
  wr <= we_i and stb_i;

  --
  -- Memory Array
  --
  --        Address
  --
  --  06 05 04 03 02 01 00
  --  |      | |         |
  --     CS        ADR
  --

  ram_arry : FOR i IN 0 TO 7
  GENERATE 
    ram_module : ram_async_single_port_module PORT MAP(
      clk => clk_i,  
      we => write_enable(i),
      addr => adr_i(3 DOWNTO 0),
      data_in => dat_i,
      data_out => data_out(i) );
  END GENERATE;   
  
  --
  -- Memory address decoder
  --
  addr_decoder : PROCESS(adr_i, data_out, wr)
  BEGIN
    write_enable <= (OTHERS=>'0');
    
    CASE adr_i(6 DOWNTO 4) IS
      WHEN "000" => 
        dat_o <= data_out(0);
        write_enable(0) <= wr;
      WHEN "001" => 
        dat_o <= data_out(1);
        write_enable(1) <= wr;        
      WHEN "010" => 
        dat_o <= data_out(2);
        write_enable(2) <= wr;
      WHEN "011" => 
        dat_o <= data_out(3);
        write_enable(3) <= wr; 
      WHEN "100" => 
        dat_o <= data_out(4);
        write_enable(4) <= wr;
      WHEN "101" => 
        dat_o <= data_out(5);
        write_enable(5) <= wr;        
      WHEN "110" => 
        dat_o <= data_out(6);
        write_enable(7) <= wr;
      WHEN "111" => 
        dat_o <= data_out(7);
        write_enable(7) <= wr;  
      WHEN OTHERS =>
        dat_o <= (OTHERS=>'0');
        write_enable <= (OTHERS=>'0');
    END CASE;
  END PROCESS;

END RAM_128B_arch;

