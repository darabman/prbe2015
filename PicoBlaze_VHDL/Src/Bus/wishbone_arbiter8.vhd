-- =============================================================================================================
-- *
-- * Copyright (c) University of York
-- *
-- * File Name: wishbone_arbiter8.vhd
-- *
-- * Version: V2.0
-- *
-- * Release Date:
-- *
-- * Author(s): M.Freeman
-- *
-- * Description: Wishbone bus arbiter
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

ENTITY wishbone_arbiter8 IS
PORT(
  clk_i : IN STD_LOGIC;
  rst_i : IN STD_LOGIC;
  cyc_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
  cyc_o : OUT STD_LOGIC;
  gnt_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
  idle : OUT STD_LOGIC );
END wishbone_arbiter8;

ARCHITECTURE wishbone_arbiter8_arch OF wishbone_arbiter8 IS

  TYPE state IS ( S0, S0w, S1, S1w, S2, S2w, S3, S3w, S4, S4w, 
                  S5, S5w, S6, S6w, S7, S7w );
                  
  SIGNAL present_state : state;
  SIGNAL next_state : state;
  SIGNAL cyc : STD_LOGIC;

  SIGNAL present_active_cyc : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL next_active_cyc : STD_LOGIC_VECTOR(7 DOWNTO 0);
  
  SIGNAL cyc_en : STD_LOGIC;
  SIGNAL cyc_active : STD_LOGIC;

BEGIN

  -- ####################
  -- #  signal buffers  #
  -- ####################

  cyc <= cyc_i(0) or cyc_i(1) or cyc_i(2) or cyc_i(3) or cyc_i(4) or cyc_i(5) or cyc_i(6) or cyc_i(7);
  cyc_o <= cyc;

  -- ###############
  -- #  processes  #
  -- ###############

  --
  -- Current active cycle request
  --

  active_cycle : PROCESS( clk_i, rst_i )
  BEGIN
    IF rst_i='1'
    THEN
      present_active_cyc <= (OTHERS=>'0');
    ELSIF clk_i='1' and clk_i'event
    THEN
      IF cyc_en='1'
      THEN
        present_active_cyc <= next_active_cyc;
      END IF;  
    END IF;
  END PROCESS;

  --
  -- Current active cycle complete
  --

  cycle_active : PROCESS( rst_i, cyc_i, present_active_cyc )
  BEGIN
    IF rst_i='1'
    THEN
      cyc_active <= '0';
    ELSE
      cyc_active <= (cyc_i(0) and present_active_cyc(0)) or
                    (cyc_i(1) and present_active_cyc(1)) or
                    (cyc_i(2) and present_active_cyc(2)) or
                    (cyc_i(3) and present_active_cyc(3)) or
                    (cyc_i(4) and present_active_cyc(4)) or
                    (cyc_i(5) and present_active_cyc(5)) or
                    (cyc_i(6) and present_active_cyc(6)) or
                    (cyc_i(7) and present_active_cyc(7));
    END IF;
  END PROCESS;

  --
  -- state machine
  --

  sync : PROCESS(clk_i, rst_i)
  BEGIN
    IF rst_i='1'
    THEN
      present_state <= S0;
    ELSIF clk_i='1' and clk_i'event
    THEN
      present_state <= next_state;
    END IF;
  END PROCESS;

  comb : PROCESS(present_state,
                 cyc_i, cyc, cyc_active, present_active_cyc )
  BEGIN

    next_active_cyc <= (OTHERS=>'0');  -- default
    gnt_o <= (OTHERS=>'0');
    cyc_en <= '0';
    idle <= '0';

    CASE present_state IS

      --
      -- Priority : 01234567
      --

      WHEN S0 =>
        cyc_en <= '1';                     -- latch mask
        
        IF cyc_i(0)='1'
        THEN
          gnt_o(0) <= '1';
          next_active_cyc <= "00000001";   -- cyc0 triggered
          next_state <= S0w;               -- wait for transaction to complete
        ELSIF cyc_i(1)='1'
        THEN
          gnt_o(1) <= '1';
          next_active_cyc <= "00000010";   -- cyc1 triggered
          next_state <= S0w;               -- wait for transaction to complete
        ELSIF cyc_i(2)='1'
        THEN
          gnt_o(2) <= '1';
          next_active_cyc <= "00000100";   -- cyc2 triggered
          next_state <= S0w;               -- wait for transaction to complete
        ELSIF cyc_i(3)='1'
        THEN
          gnt_o(3) <= '1';
          next_active_cyc <= "00001000";   -- cyc3 triggered
          next_state <= S0w;               -- wait for transaction to complete
        ELSIF cyc_i(4)='1'
        THEN
          gnt_o(4) <= '1';
          next_active_cyc <= "00010000";   -- cyc4 triggered
          next_state <= S0w;               -- wait for transaction to complete
        ELSIF cyc_i(5)='1'
        THEN
          gnt_o(5) <= '1';
          next_active_cyc <= "00100000";   -- cyc5 triggered
          next_state <= S0w;               -- wait for transaction to complete
        ELSIF cyc_i(6)='1'
        THEN
          gnt_o(6) <= '1';
          next_active_cyc <= "01000000";   -- cyc6 triggered
          next_state <= S0w;               -- wait for transaction to complete
        ELSIF cyc_i(7)='1'
        THEN
          gnt_o(7) <= '1';
          next_active_cyc <= "10000000";   -- cyc7 triggered
          next_state <= S0w;               -- wait for transaction to complete
        ELSE
          idle <= '1';
          next_state <= S0;                -- no requests wait
        END IF;
        
      WHEN S0w =>
        
        IF cyc_active='1'
        THEN
          gnt_o <= present_active_cyc;       -- keep active
          next_state <= S0w;                 -- no requests wait
        ELSE
          IF cyc_i(1)='1'                    -- Priority : 12345670
          THEN
            gnt_o(1) <= '1';
            next_active_cyc <= "00000010";   -- cyc1 triggered
            next_state <= S1w;               -- wait for transaction to complete
          ELSIF cyc_i(2)='1'
          THEN
            gnt_o(2) <= '1';
            next_active_cyc <= "00000100";   -- cyc2 triggered
            next_state <= S1w;               -- wait for transaction to complete
          ELSIF cyc_i(3)='1'
          THEN
            gnt_o(3) <= '1';
            next_active_cyc <= "00001000";   -- cyc3 triggered
            next_state <= S1w;               -- wait for transaction to complete
          ELSIF cyc_i(4)='1'
          THEN
            gnt_o(4) <= '1';
            next_active_cyc <= "00010000";   -- cyc4 triggered
            next_state <= S1w;               -- wait for transaction to complete
          ELSIF cyc_i(5)='1'
          THEN
            gnt_o(5) <= '1';
            next_active_cyc <= "00100000";   -- cyc5 triggered
            next_state <= S1w;               -- wait for transaction to complete
          ELSIF cyc_i(6)='1'
          THEN
            gnt_o(6) <= '1';
            next_active_cyc <= "01000000";   -- cyc6 triggered
            next_state <= S1w;               -- wait for transaction to complete
          ELSIF cyc_i(7)='1'
          THEN
            gnt_o(7) <= '1';
            next_active_cyc <= "10000000";   -- cyc7 triggered
            next_state <= S1w;               -- wait for transaction to complete
          ELSIF cyc_i(0)='1'
          THEN
            gnt_o(0) <= '1';
            next_active_cyc <= "00000001";   -- cyc0 triggered
            next_state <= S1w;               -- wait for transaction to complete
          ELSE
            idle <= '1';
            next_state <= S1;                -- no requests wait
          END IF;
        END IF;

      --
      -- Priority : 12345670
      --

      WHEN S1 =>
        cyc_en <= '1';                     -- latch mask
        
        IF cyc_i(1)='1'
        THEN
          gnt_o(1) <= '1';
          next_active_cyc <= "00000010";   -- cyc1 triggered
          next_state <= S1w;               -- wait for transaction to complete
        ELSIF cyc_i(2)='1'
        THEN
          gnt_o(2) <= '1';
          next_active_cyc <= "00000100";   -- cyc2 triggered
          next_state <= S1w;               -- wait for transaction to complete
        ELSIF cyc_i(3)='1'
        THEN
          gnt_o(3) <= '1';
          next_active_cyc <= "00001000";   -- cyc3 triggered
          next_state <= S1w;               -- wait for transaction to complete
        ELSIF cyc_i(4)='1'
        THEN
          gnt_o(4) <= '1';
          next_active_cyc <= "00010000";   -- cyc4 triggered
          next_state <= S1w;               -- wait for transaction to complete
        ELSIF cyc_i(5)='1'
        THEN
          gnt_o(5) <= '1';
          next_active_cyc <= "00100000";   -- cyc5 triggered
          next_state <= S1w;               -- wait for transaction to complete
        ELSIF cyc_i(6)='1'
        THEN
          gnt_o(6) <= '1';
          next_active_cyc <= "01000000";   -- cyc6 triggered
          next_state <= S1w;               -- wait for transaction to complete
        ELSIF cyc_i(7)='1'
        THEN
          gnt_o(7) <= '1';
          next_active_cyc <= "10000000";   -- cyc7 triggered
          next_state <= S1w;               -- wait for transaction to complete
        ELSIF cyc_i(0)='1'
        THEN
          gnt_o(0) <= '1';
          next_active_cyc <= "00000001";   -- cyc0 triggered
          next_state <= S1w;               -- wait for transaction to complete
        ELSE
          idle <= '1';
          next_state <= S1;                -- no requests wait
        END IF;
        
      WHEN S1w =>
      
        IF cyc_active='1'
        THEN
          gnt_o <= present_active_cyc;       -- keep active
          next_state <= S1w;                 -- no requests wait
        ELSE
          IF cyc_i(2)='1'                    -- Priority : 23456701
          THEN
            gnt_o(2) <= '1';
            next_active_cyc <= "00000100";   -- cyc2 triggered
            next_state <= S2w;               -- wait for transaction to complete
          ELSIF cyc_i(3)='1'
          THEN
            gnt_o(3) <= '1';
            next_active_cyc <= "00001000";   -- cyc3 triggered
            next_state <= S2w;               -- wait for transaction to complete
          ELSIF cyc_i(4)='1'
          THEN
            gnt_o(4) <= '1';
            next_active_cyc <= "00010000";   -- cyc4 triggered
            next_state <= S2w;               -- wait for transaction to complete
          ELSIF cyc_i(5)='1'
          THEN
            gnt_o(5) <= '1';
            next_active_cyc <= "00100000";   -- cyc5 triggered
            next_state <= S2w;               -- wait for transaction to complete
          ELSIF cyc_i(6)='1'
          THEN
            gnt_o(6) <= '1';
            next_active_cyc <= "01000000";   -- cyc6 triggered
            next_state <= S2w;               -- wait for transaction to complete
          ELSIF cyc_i(7)='1'
          THEN
            gnt_o(7) <= '1';
            next_active_cyc <= "10000000";   -- cyc7 triggered
            next_state <= S2w;               -- wait for transaction to complete
          ELSIF cyc_i(0)='1'
          THEN
            gnt_o(0) <= '1';
            next_active_cyc <= "00000001";   -- cyc0 triggered
            next_state <= S2w;               -- wait for transaction to complete
          ELSIF cyc_i(1)='1'                 
          THEN
            gnt_o(1) <= '1';
            next_active_cyc <= "00000010";   -- cyc1 triggered
            next_state <= S2w;               -- wait for transaction to complete
          ELSE
            idle <= '1';
            next_state <= S2;                -- no requests wait
          END IF;
        END IF;

      --
      -- Priority : 23456701
      --

      WHEN S2 =>
        cyc_en <= '1';                     -- latch mask
        
        IF cyc_i(2)='1'
        THEN
          gnt_o(2) <= '1';
          next_active_cyc <= "00000100";   -- cyc2 triggered
          next_state <= S2w;               -- wait for transaction to complete
        ELSIF cyc_i(3)='1'
        THEN
          gnt_o(3) <= '1';
          next_active_cyc <= "00001000";   -- cyc3 triggered
          next_state <= S2w;               -- wait for transaction to complete
        ELSIF cyc_i(4)='1'
        THEN
          gnt_o(4) <= '1';
          next_active_cyc <= "00010000";   -- cyc4 triggered
          next_state <= S2w;               -- wait for transaction to complete
        ELSIF cyc_i(5)='1'
        THEN
          gnt_o(5) <= '1';
          next_active_cyc <= "00100000";   -- cyc5 triggered
          next_state <= S2w;               -- wait for transaction to complete
        ELSIF cyc_i(6)='1'
        THEN
          gnt_o(6) <= '1';
          next_active_cyc <= "01000000";   -- cyc6 triggered
          next_state <= S2w;               -- wait for transaction to complete
        ELSIF cyc_i(7)='1'
        THEN
          gnt_o(7) <= '1';
          next_active_cyc <= "10000000";   -- cyc7 triggered
          next_state <= S2w;               -- wait for transaction to complete
        ELSIF cyc_i(0)='1'
        THEN
          gnt_o(0) <= '1';
          next_active_cyc <= "00000001";   -- cyc0 triggered
          next_state <= S2w;               -- wait for transaction to complete
        ELSIF cyc_i(1)='1'
        THEN
          gnt_o(1) <= '1';
          next_active_cyc <= "00000010";   -- cyc1 triggered
          next_state <= S2w;               -- wait for transaction to complete          
        ELSE
          idle <= '1';
          next_state <= S2;                -- no requests wait
        END IF;
        
      WHEN S2w =>
      
        IF cyc_active='1'
        THEN
          gnt_o <= present_active_cyc;       -- keep active
          next_state <= S2w;                 -- no requests wait
        ELSE
          IF cyc_i(3)='1'                    -- Priority : 34567012
          THEN
            gnt_o(3) <= '1';
            next_active_cyc <= "00001000";   -- cyc3 triggered
            next_state <= S3w;               -- wait for transaction to complete
          ELSIF cyc_i(4)='1'
          THEN
            gnt_o(4) <= '1';
            next_active_cyc <= "00010000";   -- cyc4 triggered
            next_state <= S3w;               -- wait for transaction to complete
          ELSIF cyc_i(5)='1'
          THEN
            gnt_o(5) <= '1';
            next_active_cyc <= "00100000";   -- cyc5 triggered
            next_state <= S3w;               -- wait for transaction to complete
          ELSIF cyc_i(6)='1'
          THEN
            gnt_o(6) <= '1';
            next_active_cyc <= "01000000";   -- cyc6 triggered
            next_state <= S3w;               -- wait for transaction to complete
          ELSIF cyc_i(7)='1'
          THEN
            gnt_o(7) <= '1';
            next_active_cyc <= "10000000";   -- cyc7 triggered
            next_state <= S3w;               -- wait for transaction to complete
          ELSIF cyc_i(0)='1'
          THEN
            gnt_o(0) <= '1';
            next_active_cyc <= "00000001";   -- cyc0 triggered
            next_state <= S3w;               -- wait for transaction to complete
          ELSIF cyc_i(1)='1'                 
          THEN
            gnt_o(1) <= '1';
            next_active_cyc <= "00000010";   -- cyc1 triggered
            next_state <= S3w;               -- wait for transaction to complete
          ELSIF cyc_i(2)='1'                 
          THEN
            gnt_o(2) <= '1';
            next_active_cyc <= "00000100";   -- cyc2 triggered
            next_state <= S3w;               -- wait for transaction to complete
          ELSE
            idle <= '1';
            next_state <= S3;                -- no requests wait
          END IF;
        END IF;
        
      --
      -- Priority : 34567012
      --

      WHEN S3 =>
        cyc_en <= '1';                     -- latch mask
        
        IF cyc_i(3)='1'
        THEN
          gnt_o(3) <= '1';
          next_active_cyc <= "00001000";   -- cyc3 triggered
          next_state <= S3w;               -- wait for transaction to complete
        ELSIF cyc_i(4)='1'
        THEN
          gnt_o(4) <= '1';
          next_active_cyc <= "00010000";   -- cyc4 triggered
          next_state <= S3w;               -- wait for transaction to complete
        ELSIF cyc_i(5)='1'
        THEN
          gnt_o(5) <= '1';
          next_active_cyc <= "00100000";   -- cyc5 triggered
          next_state <= S3w;               -- wait for transaction to complete
        ELSIF cyc_i(6)='1'
        THEN
          gnt_o(6) <= '1';
          next_active_cyc <= "01000000";   -- cyc6 triggered
          next_state <= S3w;               -- wait for transaction to complete
        ELSIF cyc_i(7)='1'
        THEN
          gnt_o(7) <= '1';
          next_active_cyc <= "10000000";   -- cyc7 triggered
          next_state <= S3w;               -- wait for transaction to complete
        ELSIF cyc_i(0)='1'
        THEN
          gnt_o(0) <= '1';
          next_active_cyc <= "00000001";   -- cyc0 triggered
          next_state <= S3w;               -- wait for transaction to complete
        ELSIF cyc_i(1)='1'
        THEN
          gnt_o(1) <= '1';
          next_active_cyc <= "00000010";   -- cyc1 triggered
          next_state <= S3w;               -- wait for transaction to complete   
        ELSIF cyc_i(2)='1'
        THEN
          gnt_o(2) <= '1';
          next_active_cyc <= "00000100";   -- cyc2 triggered
          next_state <= S3w;               -- wait for transaction to complete
        ELSE
          idle <= '1';
          next_state <= S3;                -- no requests wait
        END IF;
        
      WHEN S3w =>
      
        IF cyc_active='1'
        THEN
          gnt_o <= present_active_cyc;       -- keep active
          next_state <= S3w;                 -- no requests wait
        ELSE
          IF cyc_i(4)='1'                    -- Priority : 45670123
          THEN
            gnt_o(4) <= '1';
            next_active_cyc <= "00010000";   -- cyc4 triggered
            next_state <= S4w;               -- wait for transaction to complete
          ELSIF cyc_i(5)='1'
          THEN
            gnt_o(5) <= '1';
            next_active_cyc <= "00100000";   -- cyc5 triggered
            next_state <= S4w;               -- wait for transaction to complete
          ELSIF cyc_i(6)='1'
          THEN
            gnt_o(6) <= '1';
            next_active_cyc <= "01000000";   -- cyc6 triggered
            next_state <= S4w;               -- wait for transaction to complete
          ELSIF cyc_i(7)='1'
          THEN
            gnt_o(7) <= '1';
            next_active_cyc <= "10000000";   -- cyc7 triggered
            next_state <= S4w;               -- wait for transaction to complete
          ELSIF cyc_i(0)='1'
          THEN
            gnt_o(0) <= '1';
            next_active_cyc <= "00000001";   -- cyc0 triggered
            next_state <= S4w;               -- wait for transaction to complete
          ELSIF cyc_i(1)='1'                 
          THEN
            gnt_o(1) <= '1';
            next_active_cyc <= "00000010";   -- cyc1 triggered
            next_state <= S4w;               -- wait for transaction to complete
          ELSIF cyc_i(2)='1'                 
          THEN
            gnt_o(2) <= '1';
            next_active_cyc <= "00000100";   -- cyc2 triggered
            next_state <= S4w;               -- wait for transaction to complete
          ELSIF cyc_i(3)='1'                
          THEN
            gnt_o(3) <= '1';
            next_active_cyc <= "00001000";   -- cyc3 triggered
            next_state <= S4w;               -- wait for transaction to complete
          ELSE
            idle <= '1';
            next_state <= S4;                -- no requests wait
          END IF;
        END IF;
        
      --
      -- Priority : 45670123
      --

      WHEN S4 =>
        cyc_en <= '1';                     -- latch mask
        
        IF cyc_i(4)='1'
        THEN
          gnt_o(4) <= '1';
          next_active_cyc <= "00010000";   -- cyc4 triggered
          next_state <= S4w;               -- wait for transaction to complete
        ELSIF cyc_i(5)='1'
        THEN
          gnt_o(5) <= '1';
          next_active_cyc <= "00100000";   -- cyc5 triggered
          next_state <= S4w;               -- wait for transaction to complete
        ELSIF cyc_i(6)='1'
        THEN
          gnt_o(6) <= '1';
          next_active_cyc <= "01000000";   -- cyc6 triggered
          next_state <= S4w;               -- wait for transaction to complete
        ELSIF cyc_i(7)='1'
        THEN
          gnt_o(7) <= '1';
          next_active_cyc <= "10000000";   -- cyc7 triggered
          next_state <= S4w;               -- wait for transaction to complete
        ELSIF cyc_i(0)='1'
        THEN
          gnt_o(0) <= '1';
          next_active_cyc <= "00000001";   -- cyc0 triggered
          next_state <= S4w;               -- wait for transaction to complete
        ELSIF cyc_i(1)='1'
        THEN
          gnt_o(1) <= '1';
          next_active_cyc <= "00000010";   -- cyc1 triggered
          next_state <= S4w;               -- wait for transaction to complete   
        ELSIF cyc_i(2)='1'
        THEN
          gnt_o(2) <= '1';
          next_active_cyc <= "00000100";   -- cyc2 triggered
          next_state <= S4w;               -- wait for transaction to complete
        ELSIF cyc_i(3)='1'
        THEN
          gnt_o(3) <= '1';
          next_active_cyc <= "00001000";   -- cyc3 triggered
          next_state <= S4w;               -- wait for transaction to complete
        ELSE
          idle <= '1';
          next_state <= S4;                -- no requests wait
        END IF;
        
      WHEN S4w =>
      
        IF cyc_active='1'
        THEN
          gnt_o <= present_active_cyc;       -- keep active
          next_state <= S4w;                 -- no requests wait
        ELSE
          IF cyc_i(5)='1'                    -- Priority : 56701234
          THEN
            gnt_o(5) <= '1';
            next_active_cyc <= "00100000";   -- cyc5 triggered
            next_state <= S5w;               -- wait for transaction to complete
          ELSIF cyc_i(6)='1'
          THEN
            gnt_o(6) <= '1';
            next_active_cyc <= "01000000";   -- cyc6 triggered
            next_state <= S5w;               -- wait for transaction to complete
          ELSIF cyc_i(7)='1'
          THEN
            gnt_o(7) <= '1';
            next_active_cyc <= "10000000";   -- cyc7 triggered
            next_state <= S5w;               -- wait for transaction to complete
          ELSIF cyc_i(0)='1'
          THEN
            gnt_o(0) <= '1';
            next_active_cyc <= "00000001";   -- cyc0 triggered
            next_state <= S5w;               -- wait for transaction to complete
          ELSIF cyc_i(1)='1'                 
          THEN
            gnt_o(1) <= '1';
            next_active_cyc <= "00000010";   -- cyc1 triggered
            next_state <= S5w;               -- wait for transaction to complete
          ELSIF cyc_i(2)='1'                 
          THEN
            gnt_o(2) <= '1';
            next_active_cyc <= "00000100";   -- cyc2 triggered
            next_state <= S5w;               -- wait for transaction to complete
          ELSIF cyc_i(3)='1'                
          THEN
            gnt_o(3) <= '1';
            next_active_cyc <= "00001000";   -- cyc3 triggered
            next_state <= S5w;               -- wait for transaction to complete
          ELSIF cyc_i(4)='1'                 
          THEN
            gnt_o(4) <= '1';
            next_active_cyc <= "00010000";   -- cyc4 triggered
            next_state <= S5w;               -- wait for transaction to complete
          ELSE
            idle <= '1';
            next_state <= S5;                -- no requests wait
          END IF;
        END IF;

      --
      -- Priority : 56701234
      --

      WHEN S5 =>
        cyc_en <= '1';                     -- latch mask
        
        IF cyc_i(5)='1'
        THEN
          gnt_o(5) <= '1';
          next_active_cyc <= "00100000";   -- cyc5 triggered
          next_state <= S5w;               -- wait for transaction to complete
        ELSIF cyc_i(6)='1'
        THEN
          gnt_o(6) <= '1';
          next_active_cyc <= "01000000";   -- cyc6 triggered
          next_state <= S5w;               -- wait for transaction to complete
        ELSIF cyc_i(7)='1'
        THEN
          gnt_o(7) <= '1';
          next_active_cyc <= "10000000";   -- cyc7 triggered
          next_state <= S5w;               -- wait for transaction to complete
        ELSIF cyc_i(0)='1'
        THEN
          gnt_o(0) <= '1';
          next_active_cyc <= "00000001";   -- cyc0 triggered
          next_state <= S5w;               -- wait for transaction to complete
        ELSIF cyc_i(1)='1'
        THEN
          gnt_o(1) <= '1';
          next_active_cyc <= "00000010";   -- cyc1 triggered
          next_state <= S5w;               -- wait for transaction to complete   
        ELSIF cyc_i(2)='1'
        THEN
          gnt_o(2) <= '1';
          next_active_cyc <= "00000100";   -- cyc2 triggered
          next_state <= S5w;               -- wait for transaction to complete
        ELSIF cyc_i(3)='1'
        THEN
          gnt_o(3) <= '1';
          next_active_cyc <= "00001000";   -- cyc3 triggered
          next_state <= S5w;               -- wait for transaction to complete
        ELSIF cyc_i(4)='1'
        THEN
          gnt_o(4) <= '1';
          next_active_cyc <= "00010000";   -- cyc4 triggered
          next_state <= S5w;               -- wait for transaction to complete
        ELSE
          idle <= '1';
          next_state <= S5;                -- no requests wait
        END IF;
        
      WHEN S5w =>
      
        IF cyc_active='1'
        THEN
          gnt_o <= present_active_cyc;       -- keep active
          next_state <= S5w;                 -- no requests wait
        ELSE
          IF cyc_i(6)='1'                    -- Priority : 67012345
          THEN
            gnt_o(6) <= '1';
            next_active_cyc <= "01000000";   -- cyc6 triggered
            next_state <= S6w;               -- wait for transaction to complete
          ELSIF cyc_i(7)='1'
          THEN
            gnt_o(7) <= '1';
            next_active_cyc <= "10000000";   -- cyc7 triggered
            next_state <= S6w;               -- wait for transaction to complete
          ELSIF cyc_i(0)='1'
          THEN
            gnt_o(0) <= '1';
            next_active_cyc <= "00000001";   -- cyc0 triggered
            next_state <= S6w;               -- wait for transaction to complete
          ELSIF cyc_i(1)='1'                 
          THEN
            gnt_o(1) <= '1';
            next_active_cyc <= "00000010";   -- cyc1 triggered
            next_state <= S6w;               -- wait for transaction to complete
          ELSIF cyc_i(2)='1'                 
          THEN
            gnt_o(2) <= '1';
            next_active_cyc <= "00000100";   -- cyc2 triggered
            next_state <= S6w;               -- wait for transaction to complete
          ELSIF cyc_i(3)='1'                
          THEN
            gnt_o(3) <= '1';
            next_active_cyc <= "00001000";   -- cyc3 triggered
            next_state <= S6w;               -- wait for transaction to complete
          ELSIF cyc_i(4)='1'                    -- Priority : 45670123
          THEN
            gnt_o(4) <= '1';
            next_active_cyc <= "00010000";   -- cyc4 triggered
            next_state <= S6w;               -- wait for transaction to complete
          ELSIF cyc_i(5)='1'                 
          THEN
            gnt_o(5) <= '1';
            next_active_cyc <= "00100000";   -- cyc5 triggered
            next_state <= S6w;               -- wait for transaction to complete            
          ELSE
            idle <= '1';
            next_state <= S6;                -- no requests wait
          END IF;
        END IF;
        
      --
      -- Priority : 67012345
      --

      WHEN S6 =>
        cyc_en <= '1';                     -- latch mask
        
        IF cyc_i(6)='1'
        THEN
          gnt_o(6) <= '1';
          next_active_cyc <= "01000000";   -- cyc6 triggered
          next_state <= S6w;               -- wait for transaction to complete
        ELSIF cyc_i(7)='1'
        THEN
          gnt_o(7) <= '1';
          next_active_cyc <= "10000000";   -- cyc7 triggered
          next_state <= S6w;               -- wait for transaction to complete
        ELSIF cyc_i(0)='1'
        THEN
          gnt_o(0) <= '1';
          next_active_cyc <= "00000001";   -- cyc0 triggered
          next_state <= S6w;               -- wait for transaction to complete
        ELSIF cyc_i(1)='1'
        THEN
          gnt_o(1) <= '1';
          next_active_cyc <= "00000010";   -- cyc1 triggered
          next_state <= S6w;               -- wait for transaction to complete   
        ELSIF cyc_i(2)='1'
        THEN
          gnt_o(2) <= '1';
          next_active_cyc <= "00000100";   -- cyc2 triggered
          next_state <= S6w;               -- wait for transaction to complete
        ELSIF cyc_i(3)='1'
        THEN
          gnt_o(3) <= '1';
          next_active_cyc <= "00001000";   -- cyc3 triggered
          next_state <= S6w;               -- wait for transaction to complete
        ELSIF cyc_i(4)='1'
        THEN
          gnt_o(4) <= '1';
          next_active_cyc <= "00010000";   -- cyc4 triggered
          next_state <= S6w;               -- wait for transaction to complete
        ELSIF cyc_i(5)='1'
        THEN
          gnt_o(5) <= '1';
          next_active_cyc <= "00100000";   -- cyc5 triggered
          next_state <= S6w;               -- wait for transaction to complete          
        ELSE
          idle <= '1';
          next_state <= S6;                -- no requests wait
        END IF;
        
      WHEN S6w =>
      
        IF cyc_active='1'
        THEN
          gnt_o <= present_active_cyc;       -- keep active
          next_state <= S6w;                 -- no requests wait
        ELSE
          IF cyc_i(7)='1'                    -- Priority : 70123456
          THEN
            gnt_o(7) <= '1';
            next_active_cyc <= "10000000";   -- cyc7 triggered
            next_state <= S7w;               -- wait for transaction to complete
          ELSIF cyc_i(0)='1'
          THEN
            gnt_o(0) <= '1';
            next_active_cyc <= "00000001";   -- cyc0 triggered
            next_state <= S7w;               -- wait for transaction to complete
          ELSIF cyc_i(1)='1'                 
          THEN
            gnt_o(1) <= '1';
            next_active_cyc <= "00000010";   -- cyc1 triggered
            next_state <= S7w;               -- wait for transaction to complete
          ELSIF cyc_i(2)='1'                 
          THEN
            gnt_o(2) <= '1';
            next_active_cyc <= "00000100";   -- cyc2 triggered
            next_state <= S7w;               -- wait for transaction to complete
          ELSIF cyc_i(3)='1'                
          THEN
            gnt_o(3) <= '1';
            next_active_cyc <= "00001000";   -- cyc3 triggered
            next_state <= S7w;               -- wait for transaction to complete
          ELSIF cyc_i(4)='1'                    -- Priority : 45670123
          THEN
            gnt_o(4) <= '1';
            next_active_cyc <= "00010000";   -- cyc4 triggered
            next_state <= S7w;               -- wait for transaction to complete
          ELSIF cyc_i(5)='1'                 
          THEN
            gnt_o(5) <= '1';
            next_active_cyc <= "00100000";   -- cyc5 triggered
            next_state <= S7w;               -- wait for transaction to complete   
          ELSIF cyc_i(6)='1'               
          THEN
            gnt_o(6) <= '1';
            next_active_cyc <= "01000000";   -- cyc6 triggered
            next_state <= S7w;               -- wait for transaction to complete
          ELSE
            idle <= '1';
            next_state <= S7;                -- no requests wait
          END IF;
        END IF;
        
      --
      -- Priority : 70123456
      --

      WHEN S7 =>
        cyc_en <= '1';                     -- latch mask
        
        IF cyc_i(7)='1'
        THEN
          gnt_o(7) <= '1';
          next_active_cyc <= "10000000";   -- cyc7 triggered
          next_state <= S7w;               -- wait for transaction to complete
        ELSIF cyc_i(0)='1'
        THEN
          gnt_o(0) <= '1';
          next_active_cyc <= "00000001";   -- cyc0 triggered
          next_state <= S7w;               -- wait for transaction to complete
        ELSIF cyc_i(1)='1'
        THEN
          gnt_o(1) <= '1';
          next_active_cyc <= "00000010";   -- cyc1 triggered
          next_state <= S7w;               -- wait for transaction to complete   
        ELSIF cyc_i(2)='1'
        THEN
          gnt_o(2) <= '1';
          next_active_cyc <= "00000100";   -- cyc2 triggered
          next_state <= S7w;               -- wait for transaction to complete
        ELSIF cyc_i(3)='1'
        THEN
          gnt_o(3) <= '1';
          next_active_cyc <= "00001000";   -- cyc3 triggered
          next_state <= S7w;               -- wait for transaction to complete
        ELSIF cyc_i(4)='1'
        THEN
          gnt_o(4) <= '1';
          next_active_cyc <= "00010000";   -- cyc4 triggered
          next_state <= S7w;               -- wait for transaction to complete
        ELSIF cyc_i(5)='1'
        THEN
          gnt_o(5) <= '1';
          next_active_cyc <= "00100000";   -- cyc5 triggered
          next_state <= S7w;               -- wait for transaction to complete    
        ELSIF cyc_i(6)='1'
        THEN
          gnt_o(6) <= '1';
          next_active_cyc <= "01000000";   -- cyc6 triggered
          next_state <= S7w;               -- wait for transaction to complete
        ELSE
          idle <= '1';
          next_state <= S7;                -- no requests wait
        END IF;
        
      WHEN S7w =>
      
        IF cyc_active='1'
        THEN
          gnt_o <= present_active_cyc;       -- keep active
          next_state <= S7w;                 -- no requests wait
        ELSE
          IF cyc_i(0)='1'                    -- Priority : 01234567
          THEN
            gnt_o(0) <= '1';
            next_active_cyc <= "00000001";   -- cyc0 triggered
            next_state <= S0w;               -- wait for transaction to complete
          ELSIF cyc_i(1)='1'                 
          THEN
            gnt_o(1) <= '1';
            next_active_cyc <= "00000010";   -- cyc1 triggered
            next_state <= S0w;               -- wait for transaction to complete
          ELSIF cyc_i(2)='1'                 
          THEN
            gnt_o(2) <= '1';
            next_active_cyc <= "00000100";   -- cyc2 triggered
            next_state <= S0w;               -- wait for transaction to complete
          ELSIF cyc_i(3)='1'                
          THEN
            gnt_o(3) <= '1';
            next_active_cyc <= "00001000";   -- cyc3 triggered
            next_state <= S0w;               -- wait for transaction to complete
          ELSIF cyc_i(4)='1'                    -- Priority : 45670123
          THEN
            gnt_o(4) <= '1';
            next_active_cyc <= "00010000";   -- cyc4 triggered
            next_state <= S0w;               -- wait for transaction to complete
          ELSIF cyc_i(5)='1'                 
          THEN
            gnt_o(5) <= '1';
            next_active_cyc <= "00100000";   -- cyc5 triggered
            next_state <= S0w;               -- wait for transaction to complete   
          ELSIF cyc_i(6)='1'               
          THEN
            gnt_o(6) <= '1';
            next_active_cyc <= "01000000";   -- cyc6 triggered
            next_state <= S0w;               -- wait for transaction to complete
          ELSIF cyc_i(7)='1'               
          THEN
            gnt_o(7) <= '1';
            next_active_cyc <= "10000000";   -- cyc7 triggered
            next_state <= S0w;               -- wait for transaction to complete            
          ELSE
            idle <= '1';
            next_state <= S0;                -- no requests wait
          END IF;
        END IF;
        
      --
      -- Default
      --
      WHEN OTHERS =>
        next_state <= S0;

    END CASE;
  END PROCESS;
END wishbone_arbiter8_arch;
