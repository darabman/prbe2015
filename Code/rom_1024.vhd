
-------------------------------------------------------------------------------
-- FILE : rom_1024.vhd   CREATED : {timestamp}. 
-------------------------------------------------------------------------------
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--
library unisim;
use unisim.vcomponents.all;
--
--
ENTITY rom_1024 IS
PORT (   
  clk_i : IN STD_LOGIC;
  rst_i : IN STD_LOGIC;
  port_a_adr_i : IN STD_LOGIC_VECTOR ( 9 DOWNTO 0 );
  port_a_dat_o : OUT STD_LOGIC_VECTOR ( 17 DOWNTO 0 );
  port_a_stb_i : IN STD_LOGIC;
  port_a_ack_o : OUT STD_LOGIC  );
END rom_1024;
--
ARCHITECTURE rom_data_arch OF rom_1024 IS
--
attribute INIT_00 : string; 
attribute INIT_01 : string; 
attribute INIT_02 : string; 
attribute INIT_03 : string; 
attribute INIT_04 : string; 
attribute INIT_05 : string; 
attribute INIT_06 : string; 
attribute INIT_07 : string; 
attribute INIT_08 : string; 
attribute INIT_09 : string; 
attribute INIT_0A : string; 
attribute INIT_0B : string; 
attribute INIT_0C : string; 
attribute INIT_0D : string; 
attribute INIT_0E : string; 
attribute INIT_0F : string; 
attribute INIT_10 : string; 
attribute INIT_11 : string; 
attribute INIT_12 : string; 
attribute INIT_13 : string; 
attribute INIT_14 : string; 
attribute INIT_15 : string; 
attribute INIT_16 : string; 
attribute INIT_17 : string; 
attribute INIT_18 : string; 
attribute INIT_19 : string; 
attribute INIT_1A : string; 
attribute INIT_1B : string; 
attribute INIT_1C : string; 
attribute INIT_1D : string; 
attribute INIT_1E : string; 
attribute INIT_1F : string; 
attribute INIT_20 : string; 
attribute INIT_21 : string; 
attribute INIT_22 : string; 
attribute INIT_23 : string; 
attribute INIT_24 : string; 
attribute INIT_25 : string; 
attribute INIT_26 : string; 
attribute INIT_27 : string; 
attribute INIT_28 : string; 
attribute INIT_29 : string; 
attribute INIT_2A : string; 
attribute INIT_2B : string; 
attribute INIT_2C : string; 
attribute INIT_2D : string; 
attribute INIT_2E : string; 
attribute INIT_2F : string; 
attribute INIT_30 : string; 
attribute INIT_31 : string; 
attribute INIT_32 : string; 
attribute INIT_33 : string; 
attribute INIT_34 : string; 
attribute INIT_35 : string; 
attribute INIT_36 : string; 
attribute INIT_37 : string; 
attribute INIT_38 : string; 
attribute INIT_39 : string; 
attribute INIT_3A : string; 
attribute INIT_3B : string; 
attribute INIT_3C : string; 
attribute INIT_3D : string; 
attribute INIT_3E : string; 
attribute INIT_3F : string; 
attribute INITP_00 : string;
attribute INITP_01 : string;
attribute INITP_02 : string;
attribute INITP_03 : string;
attribute INITP_04 : string;
attribute INITP_05 : string;
attribute INITP_06 : string;
attribute INITP_07 : string;
--
attribute INIT_00 of ram_1024_x_18  : label is "0000000000000000000000000000000000004006540241508101D01001000000";
attribute INIT_01 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_02 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_03 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_04 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_05 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_06 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_07 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_08 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_09 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_0A of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_0B of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_0C of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_0D of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_0E of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_0F of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_10 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_11 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_12 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_13 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_14 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_15 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_16 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_17 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_18 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_19 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_1A of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_1B of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_1C of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_1D of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_1E of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_1F of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_20 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_21 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_22 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_23 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_24 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_25 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_26 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_27 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_28 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_29 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_2A of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_2B of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_2C of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_2D of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_2E of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_2F of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_30 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_31 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_32 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_33 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_34 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_35 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_36 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_37 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_38 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_39 of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_3A of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_3B of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_3C of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_3D of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_3E of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_3F of ram_1024_x_18  : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INITP_00 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000003D60";
attribute INITP_01 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INITP_02 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INITP_03 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INITP_04 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INITP_05 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INITP_06 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";
attribute INITP_07 of ram_1024_x_18 : label is "0000000000000000000000000000000000000000000000000000000000000000";
--
BEGIN
  --
  port_a_ack_o <= port_a_stb_i;
  --
  ram_1024_x_18: RAMB16_S18
  --synthesis translate_off
  GENERIC MAP ( INIT_00 => X"0000000000000000000000000000000000004006540241508101D01001000000",
                INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_10 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_11 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_12 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_13 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
                INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",    
               INITP_00 => X"0000000000000000000000000000000000000000000000000000000000003D60",
               INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
               INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
               INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
               INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
               INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
               INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
               INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000")
  --synthesis translate_on
  PORT MAP(    
    di => "0000000000000000",
    dip => "00",
    en => '1',
    we => '0',
    ssr => '0',
    clk => clk_i,
    addr => port_a_adr_i,
    do => port_a_dat_o(15 DOWNTO 0),
    dop => port_a_dat_o(17 DOWNTO 16) );
--
END rom_data_arch;
--
------------------------------------------------------------------------------------
-- END OF FILE rom_1024.vhd
------------------------------------------------------------------------------------
