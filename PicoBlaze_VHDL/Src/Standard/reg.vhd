-- =============================================================================================================
-- *
-- * Copyright (c) M.Freeman
-- *
-- * File Name: reg.vhd
-- *
-- * Version: V1.0
-- *
-- * Release Date: 
-- *
-- * Author(s): M.Freeman
-- *
-- * Description: Generic Register
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

ENTITY reg IS
GENERIC (
  width : INTEGER := 32 );
PORT ( 
  clk : IN STD_LOGIC;
  clr : IN STD_LOGIC;
  en : IN STD_LOGIC;
  rst : IN STD_LOGIC;
  din : IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
  dout : OUT STD_LOGIC_VECTOR(width-1 DOWNTO 0));
END reg;

ARCHITECTURE reg_arch OF reg IS

BEGIN

  PROCESS(clk, clr, en)
  BEGIN
    IF clr='1'
    THEN
      dout <= (OTHERS=>'0');
    ELSIF clk='1' and clk'event
    THEN
      IF en='1'
      THEN
        IF rst='1'
        THEN
          dout <= (OTHERS=>'0');
        ELSE
          dout <= din;
        END IF;
      END IF;
    END IF;
  END PROCESS;

END reg_arch;
