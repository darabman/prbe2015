-- =============================================================================================================
-- *
-- * Copyright (c) M.Freeman
-- *
-- * File Name: system_bus_mux9.vhd
-- *
-- * Version: V2.0
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

ENTITY system_bus_mux9 IS
GENERIC(
  width : INTEGER := 8 );
PORT(
  din_a : IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
  din_b : IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
  din_c : IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
  din_d : IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
  din_e : IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
  din_f : IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
  din_g : IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
  din_h : IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
  din_i : IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
  din_default : IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
  dout : OUT STD_LOGIC_VECTOR(width-1 DOWNTO 0);
  sel : IN STD_LOGIC_VECTOR(8 DOWNTO 0) );
END system_bus_mux9;

ARCHITECTURE system_bus_mux9_arch OF system_bus_mux9 IS
BEGIN

  --
  -- mux
  --

  mux : PROCESS(din_a, din_b, din_c, din_d, din_e, 
                din_f, din_g, din_h, din_i, din_default, 
					 sel )
  BEGIN
    CASE sel IS
      WHEN "000000001" => dout <= din_a;
      WHEN "000000010" => dout <= din_b;
      WHEN "000000100" => dout <= din_c;
      WHEN "000001000" => dout <= din_d;
      WHEN "000010000" => dout <= din_e;
      WHEN "000100000" => dout <= din_f;
      WHEN "001000000" => dout <= din_g;
      WHEN "010000000" => dout <= din_h;
      WHEN "100000000" => dout <= din_i;		
      WHEN OTHERS => dout <= din_default;
    END CASE;
  END PROCESS;

END system_bus_mux9_arch;


