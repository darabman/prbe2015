-- =============================================================================================================
-- *
-- * Copyright (c) University of York
-- *
-- * File Name: sr_ff.vhd
-- *
-- * Version: V1.0
-- *
-- * Release Date: 
-- *
-- * Author(s): M.Freeman
-- *
-- * Description: Generic set reset flip flop
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

ENTITY sr_ff IS
PORT ( 
  clk : IN STD_LOGIC;
  clr : IN STD_LOGIC;  
  set : IN STD_LOGIC;
  reset : IN STD_LOGIC;  
  d : OUT STD_LOGIC );
END sr_ff;

ARCHITECTURE sr_ff_arch OF sr_ff IS
 
BEGIN

  ff : PROCESS(clr, clk)
  BEGIN
    IF clr = '1'
    THEN
      d <= '0';
    ELSIF clk='1' and clk'event
    THEN
      IF set='1'
      THEN
        d <= '1';
      ELSIF reset='1'
      THEN
        d <= '0';
      END IF;  
    END IF;
  END PROCESS;  

END sr_ff_arch;
