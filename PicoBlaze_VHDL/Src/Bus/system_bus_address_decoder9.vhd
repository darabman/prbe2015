-- =============================================================================================================
-- *
-- * Copyright (c) M.Freeman
-- *
-- * File Name: system_bus_address_decoder9.vhd
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

ENTITY system_bus_address_decoder9 IS
PORT(
  clk_i : IN STD_LOGIC;
  rst_i : IN STD_LOGIC;
  adr_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
  ce_o : OUT STD_LOGIC_VECTOR(8 DOWNTO 0) );
END system_bus_address_decoder9;

ARCHITECTURE system_bus_address_decoder9_arch OF system_bus_address_decoder9 IS

BEGIN

  --
  -- decoder
  --
  
  ce_decoder : PROCESS(rst_i, clk_i)
  BEGIN
    IF rst_i = '1'
    THEN
      ce_o <= (OTHERS=>'0');
    ELSIF clk_i='1' and clk_i'event
    THEN
		IF adr_i(7) = '0'
		THEN 
			ce_o <= "000000001";	
		ELSE
			CASE adr_i(6 DOWNTO 4) IS
				WHEN  "000" => ce_o <= "000000010";
				WHEN  "001" => ce_o <= "000000100";
				WHEN  "010" => ce_o <= "000001000";
				WHEN  "011" => ce_o <= "000010000";
				WHEN  "100" => ce_o <= "000100000";
				WHEN  "101" => ce_o <= "001000000";
				WHEN  "110" => ce_o <= "010000000";
				WHEN  "111" => ce_o <= "100000000";				
				WHEN OTHERS => ce_o <= (OTHERS=>'0');
			END CASE;  
		END IF;
    END IF;  
  END PROCESS;

END system_bus_address_decoder9_arch;



