-- =============================================================================================================
-- *
-- * Copyright (c) University of York
-- *
-- * File Name: ram_single_port_32K.vhd
-- *
-- * Version: V1.0
-- *
-- * Release Date:
-- *
-- * Author(s): M.Freeman
-- *
-- * Description: Random Access Memory single port
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
 
ENTITY ram_single_port_32K IS
PORT (
  clk_i : IN STD_LOGIC;
  we_i : IN STD_LOGIC;  
  adr_i : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
  dat_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  
  dat_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) );
END ram_single_port_32K;
 
ARCHITECTURE ram_single_port_32K_arch OF ram_single_port_32K IS

  COMPONENT blockram_module 
  PORT (
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;  
    addr : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  
    data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) );
  END COMPONENT;  

  TYPE data_out_type IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR (7 DOWNTO 0);
  TYPE we_type IS ARRAY (0 TO 15) OF STD_LOGIC;  
  
  SIGNAL data_out : data_out_type;
  SIGNAL write_enable : we_type;

BEGIN


  --
  -- Memory Array
  --
  --                    address
  --  14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
  --  |         | |                             |
  --       4                     11
  --
  
  ram_arry : FOR i IN 0 TO 15
  GENERATE 
    blockram : blockram_module PORT MAP( 
      clk => clk_i, 
      we => write_enable(i),
      addr => adr_i(10 DOWNTO 0), 
      data_in => dat_i, 
      data_out => data_out(i) );
  END GENERATE;
  
  addr_decoder : PROCESS(adr_i, data_out, we_i)
  BEGIN
    write_enable <= (OTHERS=>'0');
    
    CASE adr_i(14 DOWNTO 11) IS
      WHEN "0000" => 
        dat_o <= data_out(0);
        write_enable(0) <= we_i;
      WHEN "0001" => 
        dat_o <= data_out(1);
        write_enable(1) <= we_i;        
      WHEN "0010" => 
        dat_o <= data_out(2);
        write_enable(2) <= we_i;
      WHEN "0011" => 
        dat_o <= data_out(3);
        write_enable(3) <= we_i;             
      WHEN "0100" => 
        dat_o <= data_out(4);
        write_enable(4) <= we_i;
      WHEN "0101" => 
        dat_o <= data_out(5);
        write_enable(5) <= we_i;        
      WHEN "0110" => 
        dat_o <= data_out(6);
        write_enable(6) <= we_i;
      WHEN "0111" => 
        dat_o <= data_out(7);
        write_enable(7) <= we_i;     
      WHEN "1000" => 
        dat_o <= data_out(8);
        write_enable(8) <= we_i;
      WHEN "1001" => 
        dat_o <= data_out(9);
        write_enable(9) <= we_i;        
      WHEN "1010" => 
        dat_o <= data_out(10);
        write_enable(10) <= we_i;
      WHEN "1011" => 
        dat_o <= data_out(11);
        write_enable(11) <= we_i;             
      WHEN "1100" => 
        dat_o <= data_out(12);
        write_enable(12) <= we_i;
      WHEN "1101" => 
        dat_o <= data_out(13);
        write_enable(13) <= we_i;        
      WHEN "1110" => 
        dat_o <= data_out(14);
        write_enable(14) <= we_i;
      WHEN "1111" => 
        dat_o <= data_out(15);
        write_enable(15) <= we_i;
      WHEN OTHERS =>
        dat_o <= (OTHERS=>'0');
        write_enable <= (OTHERS=>'0');
    END CASE;
  END PROCESS;
  
END ram_single_port_32K_arch;
 
