-- =============================================================================================================
-- *
-- * Copyright (c) M.Freeman
-- *
-- * File Name: pulse_sync.vhd
-- *
-- * Version: V1.0
-- *
-- * Release Date:
-- *
-- * Author(s): M.Freeman
-- *
-- * Description: pulse syncronisation
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

ENTITY pulse_sync IS
PORT (
  clk: IN STD_LOGIC;
  clr: IN STD_LOGIC;
  pulse_i: IN STD_LOGIC;
  pulse_o: OUT STD_LOGIC;
  pulse_d: OUT STD_LOGIC );
END pulse_sync;

ARCHITECTURE pulse_sync_arch OF pulse_sync IS

  TYPE state_type IS (S0, S1, S2);
  SIGNAL present_state, next_state: state_type;
  SIGNAL pulse_int: STD_LOGIC;

BEGIN

  --
  -- signal buffers
  --

  pulse_o <= pulse_int;

  --
  -- processes
  --

  sync: PROCESS(clk, clr)
  BEGIN
    IF clr='1'
    THEN
      present_state <= S0;
    ELSIF clk'event and clk='1'
    THEN
      present_state <= next_state;
    END IF;
  END PROCESS;

  comb: PROCESS(pulse_i, present_state)
  BEGIN
    CASE present_state IS

    -- wait for start
    --
    WHEN S0 =>
      pulse_int <= '0';

      IF pulse_i='1'
      THEN
        next_state <= S1;
      ELSE
        next_state <= S0;
      END IF;

    -- generate pulse
    --
    WHEN S1 =>
      pulse_int <= '1';
      next_state <= S2;

    -- wait for stop
    --
    WHEN S2 =>
      pulse_int <= '0';

      IF pulse_i='1'
      THEN
        next_state <= S2;
      ELSE
        next_state <= S0;
      END IF;

    --default condition
    --
    WHEN OTHERS =>
      pulse_int <= '0';
      next_state <= S0;

    END CASE;
  END PROCESS;

  delay: PROCESS(clk, clr)
  BEGIN
    IF clr='1'
    THEN
      pulse_d <= '0';
    ELSIF clk'event and clk='1'
    THEN
      pulse_d <= pulse_int;
    END IF;
  END PROCESS;

END pulse_sync_arch;
