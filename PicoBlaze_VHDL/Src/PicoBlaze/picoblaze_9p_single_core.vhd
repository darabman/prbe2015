-- =============================================================================================================
-- *
-- * Copyright (c) M.Freeman
-- *
-- * File Name: picoblaze_4p_single_core.vhd
-- *
-- * Version: V1.0
-- *
-- * Release Date:
-- *
-- * Author(s): M.Freeman
-- *
-- * Description: Single core picoblaze, 4 port
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
USE UNISIM.VCOMPONENTS.ALL;

ENTITY picoblaze_9p_single_core IS
PORT (
  clk_i : IN STD_LOGIC;
  rst_i : IN STD_LOGIC;

  core_adr_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
  core_dat_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
  core_dat_i : IN STD_LOGIC_VECTOR(71 DOWNTO 0);
  core_stb_o : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
  core_cyc_o : OUT STD_LOGIC;
  core_we_o  : OUT STD_LOGIC;
  core_ack_i : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
  core_irq_i : IN STD_LOGIC;
  core_irq_o : OUT STD_LOGIC );
END picoblaze_9p_single_core;

ARCHITECTURE picoblaze_9p_single_core_arch OF picoblaze_9p_single_core IS

  --
  -- components
  --

  --
  -- processor
  --

  COMPONENT picoblaze IS
  GENERIC (
    MAIN_MIN : INTEGER  := 16#000#;
    MAIN_MAX : INTEGER  := 16#2FF#;
    ISR_MIN  : INTEGER  := 16#3FF#;
    ISR_MAX  : INTEGER  := 16#3FF#;
    SUB_MIN  : INTEGER  := 16#300#;
    SUB_MAX  : INTEGER  := 16#3FE# );
  PORT (
    clk_i : IN STD_LOGIC ;
    rst_i : IN STD_LOGIC ;

    d_adr_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);  -- processor data bus
    d_dat_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    d_dat_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    d_we_o : OUT STD_LOGIC;
    d_stb_o : OUT STD_LOGIC;
    d_ack_i : IN STD_LOGIC;

    i_adr_o : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);  -- processor instruction bus
    i_dat_i : IN  STD_LOGIC_VECTOR(17 DOWNTO 0);
    i_stb_o : OUT STD_LOGIC;
    i_ack_i : IN STD_LOGIC;

    int_i : IN STD_LOGIC;
    int_ack_o : OUT STD_LOGIC );

  END COMPONENT;

  --
  -- instruction memory
  --
  
  COMPONENT ROM_1024
  PORT (  
    clk_i : IN STD_LOGIC;
    rst_i : IN STD_LOGIC;
    port_a_adr_i : IN STD_LOGIC_VECTOR ( 9 DOWNTO 0 );
    port_a_dat_o : OUT STD_LOGIC_VECTOR ( 17 DOWNTO 0 );
    port_a_stb_i : IN STD_LOGIC;
    port_a_ack_o : OUT STD_LOGIC  );
  END COMPONENT;
  
  --
  -- instruction memory mirror
  --
  
  COMPONENT blockram_1024x16bit
  PORT (
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;  
    addr : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  
    data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) );
  END COMPONENT;
    
  --
  -- address decoder
  --

  COMPONENT system_bus_address_decoder9
  PORT(
    clk_i : IN STD_LOGIC;
    rst_i : IN STD_LOGIC;
    adr_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    ce_o : OUT STD_LOGIC_VECTOR(8 DOWNTO 0) );
  END COMPONENT;

  --
  -- data mux
  --

  COMPONENT system_bus_mux9
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
  END COMPONENT;

  --
  -- pipeline register
  --

  COMPONENT reg
  GENERIC (
    width : INTEGER := 32 );
  PORT (
    clk : IN STD_LOGIC;
    clr : IN STD_LOGIC;
    en : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
    dout : OUT STD_LOGIC_VECTOR(width-1 DOWNTO 0));
  END COMPONENT;

  --
  -- signals
  --

  SIGNAL GND     : STD_LOGIC;
  SIGNAL VCC     : STD_LOGIC;
  SIGNAL GND_BUS : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL GND_BUS_16 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  --
  -- Core
  --

  SIGNAL core_d_adr_o   : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL core_d_adr_p_o : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL core_d_dat_i   : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL core_d_dat_o   : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL core_d_dat_p_o : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL core_d_we_o    : STD_LOGIC;
  SIGNAL core_d_stb_o   : STD_LOGIC;
  SIGNAL core_d_ack_i   : STD_LOGIC;
  
  SIGNAL core_i_adr_o   : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL core_i_dat_i   : STD_LOGIC_VECTOR(17 DOWNTO 0);
  SIGNAL core_i_stb_o   : STD_LOGIC;
  SIGNAL core_i_ack_i   : STD_LOGIC;

  SIGNAL core_ce_o      : STD_LOGIC_VECTOR(8 DOWNTO 0);
  
  SIGNAL high_addr_bus : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

  --
  -- signal buffers
  --

  VCC <= '1';
  GND <= '0';
  GND_BUS <= (OTHERS=>'0');
  GND_BUS_16 <= (OTHERS=>'0');

  core_cyc_o <= '1';
  core_we_o  <= core_d_we_o;
  core_adr_o <= core_d_adr_p_o;
  core_dat_o <= core_d_dat_p_o;

  core_d_ack_i  <= core_ack_i(0) or core_ack_i(1) or core_ack_i(2) or core_ack_i(3);

  core_stb_o(0) <= core_ce_o(0) and core_d_stb_o;
  core_stb_o(1) <= core_ce_o(1) and core_d_stb_o;
  core_stb_o(2) <= core_ce_o(2) and core_d_stb_o;
  core_stb_o(3) <= core_ce_o(3) and core_d_stb_o;

  -- ################
  -- #  Components  #
  -- ################

  -- 
  -- Core instruction memory
  --

  rom : ROM_1024 PORT MAP(
    clk_i        => clk_i,
    rst_i        => rst_i,
    port_a_adr_i => core_i_adr_o,
    port_a_dat_o => core_i_dat_i,
    port_a_stb_i => core_i_stb_o,
    port_a_ack_o => core_i_ack_i );

  -- 
  -- Core instruction memory
  --
  
  rom_extended : blockram_1024x16bit PORT MAP(
    clk      => clk_i,
    we       => GND,
    addr     => core_i_adr_o,
    data_in  => GND_BUS_16,
    data_out => high_addr_bus );

  --
  -- Core processor
  --

  core_cpu : picoblaze 
  PORT MAP(
    clk_i     => clk_i,
    rst_i     => rst_i,
    d_adr_o   => core_d_adr_o,
    d_dat_i   => core_d_dat_i,
    d_dat_o   => core_d_dat_o,
    d_we_o    => core_d_we_o,
    d_stb_o   => core_d_stb_o,
    d_ack_i   => core_d_ack_i,
    i_adr_o   => core_i_adr_o,
    i_dat_i   => core_i_dat_i,
    i_stb_o   => core_i_stb_o,
    i_ack_i   => core_i_ack_i,
    int_i     => core_irq_i,
    int_ack_o => core_irq_o );

  --
  -- Core data bus addr pipeline register
  --

  core_adr_pipeline_reg : reg
  GENERIC MAP(
    width => 8 )
  PORT MAP(
    clk => clk_i,
    clr => rst_i,
    en => VCC,
    rst => GND,
    din => core_d_adr_o,
    dout => core_d_adr_p_o );

  --
  -- Core data bus data out pipeline register
  --

  core_data_out_pipeline_reg : reg
  GENERIC MAP(
    width => 8 )
  PORT MAP(
    clk => clk_i,
    clr => rst_i,
    en => VCC,
    rst => GND,
    din => core_d_dat_o,
    dout => core_d_dat_p_o );

  --
  -- Core system bus address decoder
  --
  
  --
  -- Address decoder
  -- ---------------
  -- 
  -- Addr Min          Addr Max          Range    Description
  -- 00000000 (00h)    01111111 (3Fh)    128      RAM
  -- 10000000 (80h)    10001111 (8Fh)    16       User defined
  -- 10010000 (90h)    10011111 (9Fh)    16       User defined
  -- 10100000 (A0h)    10101111 (AFh)    16       User defined
  -- 10110000 (B0h)    10111111 (BFh)    16       User defined  
  -- 11000000 (C0h)    11001111 (CFh)    16       User defined
  -- 11010000 (D0h)    11011111 (DFh)    16       User defined
  -- 11100000 (E0h)    11101111 (EFh)    16       User defined
  -- 11110000 (F0h)    11111111 (FFh)    16       User defined  
  --
  
  core_addr_dec : system_bus_address_decoder9
  PORT MAP(
    clk_i => clk_i,
    rst_i => rst_i,
    adr_i => core_d_adr_o,
    ce_o => core_ce_o );

  --
  -- Core slave data out mux
  --

  core_data_mux : system_bus_mux9
  GENERIC MAP(
    width => 8 )
  PORT MAP(
    din_a => core_dat_i(7 DOWNTO 0),
    din_b => core_dat_i(15 DOWNTO 8),
    din_c => core_dat_i(23 DOWNTO 16),
    din_d => core_dat_i(31 DOWNTO 24),
    din_e => core_dat_i(39 DOWNTO 32),
    din_f => core_dat_i(47 DOWNTO 40),
    din_g => core_dat_i(55 DOWNTO 48),
    din_h => core_dat_i(63 DOWNTO 56),	
    din_i => core_dat_i(71 DOWNTO 64),		 
    din_default => GND_BUS,
    dout  => core_d_dat_i,
    sel => core_ce_o );


END picoblaze_9p_single_core_arch;


