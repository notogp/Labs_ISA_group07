library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
--use ieee.std_logic_unsigned.all;
use work.constants.all;

library std;
use std.textio.all;

entity data_gen is
  port (
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
end data_gen;

architecture behavioural of data_gen is

  constant tco : time := 1 ns;
  constant ts : time := 10 ns;
  signal sEndSim   : std_logic;
  signal END_SIM_i : std_logic_vector(0 to NBIT-1);

begin -- beh
-- -13, -28, 104, 544, 830, 544, 104, -28, -13
  B0 <= to_signed(-13, NBIT);
  B1 <= to_signed(-28, NBIT);
  B2 <= to_signed(104, NBIT);
  B3 <= to_signed(544, NBIT);
  B4 <= to_signed(830, NBIT);
  B5 <= to_signed(544, NBIT);
  B6 <= to_signed(104, NBIT);
  B7 <= to_signed(-28, NBIT);
  B8 <= to_signed(-13, NBIT);

  process (CLK, RST_n)
    file fp_in       : text open READ_MODE is "/home/isa07_2021_2022/Desktop/Lab1_group07/Lab1/Matlab_code/samples.txt";
    variable line_in : line;
    variable x       : integer;
  begin               -- process
    if RST_n = '0' then -- asynchronous reset (active low)
      DOUT    <= (others => '0') after tco;
      VOUT    <= '0' after tco;
      sEndSim <= '0' after tco;
    elsif CLK'event and CLK = '1' then -- rising clock edge
      if not endfile(fp_in) then
        readline(fp_in, line_in);
        read(line_in, x);
        DOUT    <= to_signed(x, NBIT) after tco;
        VOUT    <= '1' after tco;
        sEndSim <= '0' after tco;
      else
        VOUT    <= '0' after 2*ts + tco;
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

  END_SIM <= END_SIM_i(NBIT-1);


end behavioural;

