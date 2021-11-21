library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.constants.all;

entity tb_FIR is 
end entity;

architecture behavioural of tb_FIR is

	component FIR_Filter is
	 	port(	
			CLK   : in std_logic;
			RST_n : in std_logic;
			VIN   : in std_logic;
			DIN   : in signed(NBIT-1 downto 0);
			B0	  : in signed(NBIT-1 downto 0);
			B1	  : in signed(NBIT-1 downto 0);
			B2	  : in signed(NBIT-1 downto 0);
			B3	  : in signed(NBIT-1 downto 0);
			B4	  : in signed(NBIT-1 downto 0);
			B5	  : in signed(NBIT-1 downto 0);
			B6	  : in signed(NBIT-1 downto 0);
			B7	  : in signed(NBIT-1 downto 0);
			B8	  : in signed(NBIT-1 downto 0);
			VOUT  : out std_logic;
			DOUT  : out signed(NBIT-1 downto 0));
	end component;
	
	component clk_gen is 
		port(
			END_SIM : in std_logic;
			CLK     : out std_logic;
			RST_n   : out std_logic);
	end component;

	component data_sink is
	   port(
    		CLK   : in std_logic;
    		RST_n : in std_logic;
    		VIN   : in std_logic;
			VOUT  : in std_logic;
    		DIN   : in signed(NBIT-1 downto 0));
	end component;
	
	component data_gen is 
	  port(
			CLK     : in std_logic;
			RST_n   : in std_logic;
			VOUT    : out std_logic;
			DOUT    : out signed(NBIT-1 downto 0);
			B0      : out signed(NBIT-1 downto 0);
			B1      : out signed(NBIT-1 downto 0);
			B2      : out signed(NBIT-1 downto 0);
			B3      : out signed(NBIT-1 downto 0);
			B4      : out signed(NBIT-1 downto 0);
			B5      : out signed(NBIT-1 downto 0);
			B6      : out signed(NBIT-1 downto 0);
			B7      : out signed(NBIT-1 downto 0);
			B8      : out signed(NBIT-1 downto 0);
			END_SIM : out std_logic);
	end component;

signal clock_signal : std_logic;
signal reset_signal : std_logic;
signal end_sim_signal: std_logic;
signal vout_signal: std_logic;
signal vin_signal: std_logic;
signal dout_signal : signed (NBIT-1 downto 0);
signal din_signal : signed (NBIT-1 downto 0);
signal B0_signal : signed (NBIT-1 downto 0);
signal B1_signal : signed (NBIT-1 downto 0);
signal B2_signal : signed (NBIT-1 downto 0);
signal B3_signal : signed (NBIT-1 downto 0);
signal B4_signal : signed (NBIT-1 downto 0);
signal B5_signal : signed (NBIT-1 downto 0);
signal B6_signal : signed (NBIT-1 downto 0);
signal B7_signal : signed (NBIT-1 downto 0);
signal B8_signal : signed (NBIT-1 downto 0);
signal END_SIM_i : std_logic;

begin

clock_generation : clk_gen 
port map (END_SIM => end_sim_signal, CLK => clock_signal, RST_n => reset_signal);

data_generation: data_gen
port map (CLK => clock_signal, RST_n => reset_signal, VOUT => vin_signal, DOUT => din_signal, B0 => B0_signal, B1 => B1_signal, B2 => B2_signal,
		  B3 => B3_signal, B4 => B4_signal, B5 => B5_signal, B6 => B6_signal, B7 => B7_signal, B8 => B8_signal, END_SIM => end_sim_signal);

data_writing : data_sink
port map (CLK => clock_signal, RST_n => reset_signal, VIN => vin_signal, VOUT => vout_signal, DIN => dout_signal);

filfir : FIR_filter
port map (CLK => clock_signal, RST_n => reset_signal, VIN => vin_signal, DIN => din_signal, B0 => B0_signal, B1 => B1_signal, B2 => B2_signal,
		  B3 => B3_signal, B4 => B4_signal, B5 => B5_signal, B6 => B6_signal, B7 => B7_signal, B8 => B8_signal, VOUT => vout_signal, DOUT => dout_signal);  

END_SIM_i <= end_sim_signal;

end architecture;
