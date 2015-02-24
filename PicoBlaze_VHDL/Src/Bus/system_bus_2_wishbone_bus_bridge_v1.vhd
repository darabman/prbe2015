-- =============================================================================================================
-- *
-- * Copyright (c) University of York
-- *
-- * File Name: system_bus_2_wishbone_bus_bridge_v1.vhd
-- *
-- * Version: V1.0
-- *
-- * Release Date:
-- *
-- * Author(s): M.Freeman
-- *
-- * Description: PicoBlaze system bus to WishBone bus
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

-- Register Map
-- ------------
-- parameter_reg(00) : read base address 0
-- parameter_reg(01) : read base address 1
-- parameter_reg(02) : read base address 2
-- parameter_reg(03) : read base address 3
-- parameter_reg(04) : write base address 0
-- parameter_reg(05) : write base address 1
-- parameter_reg(06) : write base address 2
-- parameter_reg(07) : write base address 3
-- parameter_reg(08) : data out 0
-- parameter_reg(09) : data out 1
-- parameter_reg(0A) : data out 2
-- parameter_reg(0B) : data out 3
-- parameter_reg(0C) : interrupt enable
-- parameter_reg(0D) : command / status
-- parameter_reg(0E) : data in 0
-- parameter_reg(0F) : data in 1
-- parameter_reg(10) : data in 2
-- parameter_reg(11) : data in 3

-- Interrupt Enable Register
-- ------------------------------
-- Bit 7 : NU
-- Bit 6 : NU
-- Bit 5 : NU
-- Bit 4 : NU
-- Bit 3 : NU
-- Bit 2 : read complete     (1=enable, 0=disable)
-- Bit 1 : write complete    (1=enable, 0=disable)
-- Bit 0 : enable inerrupts  (1=enable, 0=disable)

-- Command Register
-- ---------------------------
-- Bit 7 : NU
-- Bit 6 : NU
-- Bit 5 : NU
-- Bit 4 : NU
-- Bit 3 : NU
-- Bit 2 : NU
-- Bit 1 : NU
-- Bit 0 : read / write request (1=read, 0=write)

-- Status Register
-- -------------------------
-- Bit 7 : NU
-- Bit 6 : NU
-- Bit 5 : NU
-- Bit 4 : NU
-- Bit 3 : NU
-- Bit 2 : NU
-- Bit 1 : error (1=true, 0=false)
-- Bit 0 : idle (1=true, 0=false)


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY system_bus_2_wishbone_bus_bridge_v1 IS
GENERIC(
  SYSTEM_BUS_ADDR_WIDTH : INTEGER := 32;
  SYSTEM_BUS_DATA_WIDTH : INTEGER := 32;
  SYSTEM_BUS_TYPE_WIDTH : INTEGER := 4;
  CPU_BUS_ADDR_WIDTH : INTEGER := 6;
  CPU_BUS_DATA_WIDTH : INTEGER := 8 );
PORT(
  clk_i : IN STD_LOGIC;
  rst_i : IN STD_LOGIC;

  portA_m_adr_o : OUT STD_LOGIC_VECTOR(SYSTEM_BUS_ADDR_WIDTH-1 DOWNTO 0); -- port A master
  portA_m_dat_i : IN STD_LOGIC_VECTOR(SYSTEM_BUS_DATA_WIDTH-1 DOWNTO 0);
  portA_m_dat_o : OUT STD_LOGIC_VECTOR(SYSTEM_BUS_DATA_WIDTH-1 DOWNTO 0);
  portA_m_we_o : OUT STD_LOGIC;
  portA_m_stb_o : OUT STD_LOGIC;
  portA_m_cyc_o : OUT STD_LOGIC;
  portA_m_cti_o : OUT STD_LOGIC_VECTOR(SYSTEM_BUS_TYPE_WIDTH-1 DOWNTO 0);
  portA_m_ack_i : IN STD_LOGIC;
  portA_m_err_i : IN STD_LOGIC;

  portB_s_adr_i : IN STD_LOGIC_VECTOR(CPU_BUS_ADDR_WIDTH-1 DOWNTO 0);   -- port B slave
  portB_s_dat_i : IN STD_LOGIC_VECTOR(CPU_BUS_DATA_WIDTH-1 DOWNTO 0);
  portB_s_dat_o : OUT STD_LOGIC_VECTOR(CPU_BUS_DATA_WIDTH-1 DOWNTO 0);
  portB_s_we_i : IN STD_LOGIC;
  portB_s_stb_i : IN STD_LOGIC;
  portB_s_ack_o : OUT STD_LOGIC;
  portB_s_cyc_i : IN STD_LOGIC;
  portB_s_int_o : OUT STD_LOGIC );
END system_bus_2_wishbone_bus_bridge_v1;

ARCHITECTURE system_bus_2_wishbone_bus_bridge_v1_arch OF system_bus_2_wishbone_bus_bridge_v1 IS

  -- ################
  -- #  components  #
  -- ################

  --
  -- SR flip-flop
  --

  COMPONENT sr_ff
  PORT (
    clk : IN STD_LOGIC;
    clr : IN STD_LOGIC;
    set : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    d : OUT STD_LOGIC );
  END COMPONENT;
  
  --
  -- Pulse generator
  --

  COMPONENT pulse_sync
  PORT (
    clk: IN STD_LOGIC;
    clr: IN STD_LOGIC;
    pulse_i: IN STD_LOGIC;
    pulse_o: OUT STD_LOGIC;
    pulse_d: OUT STD_LOGIC );
  END COMPONENT;
  
  --
  -- register
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


  -- #############
  -- #  signals  #
  -- #############

  SIGNAL GND : STD_LOGIC;
  SIGNAL VCC : STD_LOGIC;
  SIGNAL GND_BUS : STD_LOGIC_VECTOR(7 DOWNTO 0);

  TYPE smA_state_type IS (SA0, 
                          SA1, SA1a,
								          SA2, SA2a, SA2b, SA2c );
								  
  SIGNAL smA_present_state : smA_state_type;
  SIGNAL smA_next_state : smA_state_type;

  SIGNAL ce : STD_LOGIC_VECTOR(13 DOWNTO 0);
  
  SIGNAL control_register_en : STD_LOGIC;
  SIGNAL data_register_en : STD_LOGIC;
  
  TYPE parameter_register_bank IS ARRAY(0 TO 13) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL parameter_register : parameter_register_bank;

  SIGNAL control_register : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL data_register : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL interrupt_register : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL status_register : STD_LOGIC_VECTOR(7 DOWNTO 0);

  SIGNAL smA_ctrl_flag_rst : STD_LOGIC;
  SIGNAL smA_ctrl_flag : STD_LOGIC;

  SIGNAL smA_error_flag_en : STD_LOGIC;
  SIGNAL smA_error_flag_rst : STD_LOGIC;
  SIGNAL smA_error_flag : STD_LOGIC;

  SIGNAL portB_int : STD_LOGIC;

  SIGNAL idle : STD_LOGIC;

BEGIN

  -- ######################
  -- #  signals  buffers  #
  -- ######################

  GND <= '0';
  VCC <= '1';
  GND_BUS <= (OTHERS=>'0');

  portB_s_ack_o <= portB_s_stb_i;

  portA_m_dat_o <= parameter_register(11) & parameter_register(10) & parameter_register(9) & parameter_register(8);
 
  control_register_en <= ce(13);

  control_register <= parameter_register(13);
  interrupt_register <= parameter_register(12);
  status_register <= "0000000" & idle;

  -- ################
  -- #  components  #
  -- ################

  --
  -- parameter register array
  --

  parameter_register_array : FOR i IN 0 TO 13 GENERATE
    ra : reg
    GENERIC MAP(
      width => 8 )
    PORT MAP(
      clk => clk_i,
      clr => rst_i,
      en => ce(i),
      rst => GND,
      din => portB_s_dat_i,
      dout => parameter_register(i) );
   END GENERATE;
   
  --
  -- data register
  --

  data_register_array : reg
  GENERIC MAP(
    width => 32 )
  PORT MAP(
    clk => clk_i,
    clr => rst_i,
    en => data_register_en,
    rst => GND,
    din => portA_m_dat_i,
    dout => data_register );
   
  --
  -- command register access flag
  --

  smA_control_flag : sr_ff PORT MAP(
    clk => clk_i,
    clr => rst_i,
    set => control_register_en,
    reset => smA_ctrl_flag_rst,
    d => smA_ctrl_flag );

  --
  -- error flag
  --

  smA_error_flag_inst : sr_ff PORT MAP(
    clk => clk_i,
    clr => rst_i,
    set => smA_error_flag_en,
    reset => smA_error_flag_rst,
    d => smA_error_flag );
	 
  --
  -- irq pulse  
  --

  irq : pulse_sync
  PORT MAP(
    clk => clk_i,
    clr => rst_i,
    pulse_i => portB_int,
    pulse_o => portB_s_int_o,
    pulse_d => OPEN );

	 
  -- ###############
  -- #  processes  #
  -- ###############

  --
  -- portB parameter registers write enable (idle locks register during transfer)
  --

  portB_input_decoder : PROCESS( portB_s_adr_i, portB_s_stb_i, portB_s_we_i, idle )
  BEGIN
    IF portB_s_stb_i='1' and portB_s_we_i='1' and idle='1'
    THEN
      CASE portB_s_adr_i(4 DOWNTO 0) IS
        WHEN "00000" => ce <= "00000000000001"; -- parameter_register(00)  : read address 0
        WHEN "00001" => ce <= "00000000000010"; -- parameter_register(01)  : read address 1
        WHEN "00010" => ce <= "00000000000100"; -- parameter_register(02)  : read address 2
        WHEN "00011" => ce <= "00000000001000"; -- parameter_register(03)  : read address 3
        WHEN "00100" => ce <= "00000000010000"; -- parameter_register(04)  : write address 0
        WHEN "00101" => ce <= "00000000100000"; -- parameter_register(05)  : write address 1
        WHEN "00110" => ce <= "00000001000000"; -- parameter_register(06)  : write address 2
        WHEN "00111" => ce <= "00000010000000"; -- parameter_register(07)  : write address 3
        WHEN "01000" => ce <= "00000100000000"; -- parameter_register(08)  : data out 0
        WHEN "01001" => ce <= "00001000000000"; -- parameter_register(09)  : data out 1
        WHEN "01010" => ce <= "00010000000000"; -- parameter_register(0A)  : data out 2
        WHEN "01011" => ce <= "00100000000000"; -- parameter_register(0B)  : data out 3
        WHEN "01100" => ce <= "01000000000000"; -- parameter_register(0C)  : interrupt enable
        WHEN "01101" => ce <= "10000000000000"; -- parameter_register(0D)  : command (w) / status (r)
        WHEN OTHERS  => ce <= "00000000000000"; -- default
      END CASE;
    ELSE
      ce <= "00000000000000";
    END IF;
  END PROCESS;

  --
  -- portB parameter register data output selection
  --

  portB_output_decoder : PROCESS( portB_s_adr_i, parameter_register, status_register, data_register )
  BEGIN
    CASE portB_s_adr_i(4 DOWNTO 0) IS
      WHEN "00000" => portB_s_dat_o <= parameter_register(0);        -- parameter_register(00) : read address 0
      WHEN "00001" => portB_s_dat_o <= parameter_register(1);        -- parameter_register(01) : read address 1
      WHEN "00010" => portB_s_dat_o <= parameter_register(2);        -- parameter_register(02) : read address 2
      WHEN "00011" => portB_s_dat_o <= parameter_register(3);        -- parameter_register(03) : read address 3
      WHEN "00100" => portB_s_dat_o <= parameter_register(4);        -- parameter_register(04) : write address 0
      WHEN "00101" => portB_s_dat_o <= parameter_register(5);        -- parameter_register(05) : write address 1
      WHEN "00110" => portB_s_dat_o <= parameter_register(6);        -- parameter_register(06) : write address 2
      WHEN "00111" => portB_s_dat_o <= parameter_register(7);        -- parameter_register(07) : write address 3
      WHEN "01000" => portB_s_dat_o <= parameter_register(8);        -- parameter_register(08) : data out byte 0
      WHEN "01001" => portB_s_dat_o <= parameter_register(9);        -- parameter_register(09) : data out byte 1
      WHEN "01010" => portB_s_dat_o <= parameter_register(10);       -- parameter_register(0A) : data out byte 2
      WHEN "01011" => portB_s_dat_o <= parameter_register(11);       -- parameter_register(0B) : data out byte 3
      WHEN "01100" => portB_s_dat_o <= parameter_register(12);       -- parameter_register(0C) : interrupt enable
      WHEN "01101" => portB_s_dat_o <= status_register;              -- parameter_register(0D) : command (w) / status (r)
      WHEN "01110" => portB_s_dat_o <= data_register(7 DOWNTO 0);    -- data_register : data in 0
      WHEN "01111" => portB_s_dat_o <= data_register(15 DOWNTO 8);   -- data_register : data in 1
      WHEN "10000" => portB_s_dat_o <= data_register(23 DOWNTO 16);  -- data_register : data in 2
      WHEN "10001" => portB_s_dat_o <= data_register(31 DOWNTO 24);  -- data_register : data in 3
      WHEN OTHERS  => portB_s_dat_o <= (OTHERS=>'0');
    END CASE;
  END PROCESS;


  -- ###################
  -- #  state machine  #
  -- ###################

  --
  -- controlling state machine
  --

  smA_sync : PROCESS(clk_i, rst_i)
  BEGIN
    IF rst_i='1'
    THEN
      smA_present_state <= SA0;
    ELSIF clk_i'event and clk_i='1'
    THEN
      smA_present_state <= smA_next_state;
    END IF;
  END PROCESS;

  smA_comb: PROCESS( smA_present_state,
                     smA_ctrl_flag, smA_error_flag,
                     parameter_register, control_register, interrupt_register,
                     portA_m_ack_i )
  BEGIN
    idle <= '0';

    smA_ctrl_flag_rst <= '0';
    smA_error_flag_en <= '0';
    smA_error_flag_rst <= '0';

    portA_m_adr_o <= (OTHERS=>'0');
    portA_m_cti_o <= (OTHERS=>'0');
    portA_m_we_o <= '0';
    portA_m_stb_o <= '0';
    portA_m_cyc_o <= '0';

    portB_int <= '0';

    data_register_en <= '0';
    
    CASE smA_present_state IS

      WHEN SA0 =>
        idle <= '1';

        IF smA_ctrl_flag='1'                  -- wait for start signal
        THEN
          smA_error_flag_rst <= '1';          -- reset flags
          smA_ctrl_flag_rst <= '1';

          IF control_register(0)='1'
          THEN
            smA_next_state <= SA1;            -- Read operatrion
          ELSE
            smA_next_state <= SA2;            -- Write operation
          END IF;
        ELSE
          smA_next_state <= SA0;              -- wait
        END IF;

      --
      -- READ
      --

      WHEN SA1 =>
        portA_m_adr_o <= parameter_register(3) & parameter_register(2) & parameter_register(1) & parameter_register(0);
        portA_m_we_o <= '0';
        portA_m_stb_o <= '1';
        portA_m_cyc_o <= '1';
        portA_m_cti_o <= "0000";

        IF portA_m_ack_i='1'
        THEN
          data_register_en <= '1';     -- write data

          IF interrupt_register(0)='1' and interrupt_register(2)='1'  -- if irq enable
          THEN
            portB_int <='1';
          END IF;
          smA_next_state <= SA0;       -- finish
        ELSE
          smA_next_state <= SA1;       -- wait
        END IF;

      --
      -- WRITE
      --

      WHEN SA2 =>
        portA_m_adr_o <= parameter_register(7) & parameter_register(6) & parameter_register(5) & parameter_register(4);
        portA_m_we_o <= '1';
        portA_m_stb_o <= '1';
        portA_m_cyc_o <= '1';
        portA_m_cti_o <= "0000";
        
        IF portA_m_ack_i='1'                    -- data read by slave?
        THEN
          IF interrupt_register(0)='1' and interrupt_register(1)='1'  -- if irq enable
          THEN
            portB_int <='1';
          END IF;
          smA_next_state <= SA0;                -- finish
        ELSE  
          smA_next_state <= SA2;                -- wait
        END IF;  

      WHEN OTHERS =>
        smA_next_state <= SA0;                 -- default condition
    END CASE;
  END PROCESS;

END system_bus_2_wishbone_bus_bridge_v1_arch;


