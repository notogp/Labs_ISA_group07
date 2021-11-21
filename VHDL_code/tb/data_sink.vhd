library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use work.constants.all;

library std;
use std.textio.all;

entity data_sink is
  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
    VIN   : in std_logic;
    VOUT  : in std_logic;
    DIN   : in signed(NBIT-1 downto 0));
end data_sink;

architecture beh of data_sink is

begin  -- beh

  process (CLK, RST_n)
    file res_fp : text open WRITE_MODE is "/home/isa07_2021_2022/Desktop/Lab1_group07/Lab1/VHDL_code/2.1/resultsVHDL.txt";
    variable line_out : line;    
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      null;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      if (VIN = '1') and (VOUT='1') then
        write(line_out, to_integer(DIN));
        writeline(res_fp, line_out);
      end if;
    end if;
  end process;

end beh;

--i have to do do the write in AND with the VOUT
