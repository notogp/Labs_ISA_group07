library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use work.constants.all;

library std;
use std.textio.all;

entity tb_all is 
end entity;

architecture behavioural of tb_all is

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
signal CLK_i : std_logic;
constant ts : time := 10 ns;
constant tco : time := 1 ns;
signal sEndSim   : std_logic;
signal END_SIM_i : std_logic_vector(0 to NBIT-1);

begin



  process
  begin -- process
    if (CLK_i = 'U') then
      CLK_i <= '0';
    else
      CLK_i <= not(CLK_i);
    end if;
    wait for ts/2;
  end process;

  clock_signal <= CLK_i and not(end_sim_signal);

  process
  begin -- process
    reset_signal <= '0';
    wait for 2.5 * ts/2;
    reset_signal <= '1';
    wait;
  end process;

  process (clock_signal, reset_signal)
    file fp_in       : text open READ_MODE is "/home/isa07_2021_2022/Desktop/Lab1_group07/Lab1/Matlab_code/samples.txt";
    variable line_in : line;
    variable x       : integer;
  begin               -- process
    if reset_signal = '0' then -- asynchronous reset (active low)
      DOUT    <= (others => '0') after tco;
      VIN    <= '0' after tco;
      sEndSim <= '0' after tco;
    elsif CLK'event and clock_signal = '1' then -- rising clock edge
      if not endfile(fp_in) then
        readline(fp_in, line_in);
        read(line_in, x);
        DOUT    <= to_signed(x, NBIT) after tco;
        VIN    <= '1' after tco;
        sEndSim <= '0' after tco;
      else
        VIN    <= '0' after 2*ts + tco;
        sEndSim <= '1' after tco;
      end if;
    end if;
  end process;

  process (CLK, RST_n)
  begin               -- process
    if RST_n = '0' then -- asynchronous reset (active low)
      END_SIM_i <= (others => '0') after tco;
    elsif CLK'event and CLK = '1' then -- rising clock edge
      END_SIM_i(0)       <= sEndSim after tco;
      END_SIM_i(1 to NBIT-1) <= END_SIM_i(0 to NBIT-2) after tco;
    end if;
  end process;

  end_sim_signal <= END_SIM_i(NBIT-1);
  

	process (clock_signal, reset_signal)
		file res_fp : text open WRITE_MODE is "/home/isa07_2021_2022/Desktop/Lab1_group07/Lab1/VHDL_code/2.1/resultsVHDL.txt";
		variable line_out : line;    
	  begin  -- process
		if reset_signal = '0' then                 -- asynchronous reset (active low)
		  null;
		elsif CLK'event and clock_signal = '1' then  -- rising clock edge
		  if (VIN = '1') and (VOUT='1') then
		    write(line_out, to_integer(DIN));
		    writeline(res_fp, line_out);
		  end if;
		end if;
	  end process;


filfir : FIR_filter
port map (CLK => clock_signal, RST_n => reset_signal, VIN => vin_signal, DIN => din_signal, B0 => B0_signal, B1 => B1_signal, B2 => B2_signal,
		  B3 => B3_signal, B4 => B4_signal, B5 => B5_signal, B6 => B6_signal, B7 => B7_signal, B8 => B8_signal, VOUT => vout_signal, DOUT => dout_signal);  

END_SIM_i <= end_sim_signal;

end architecture;
