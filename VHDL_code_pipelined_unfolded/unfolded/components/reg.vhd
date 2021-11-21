library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;


entity REG is
	port(
		 REG_IN  : in signed(NBIT-1 DOWNTO 0);
		 REG_OUT : out signed(NBIT-1 DOWNTO 0);
		 CLK	 : in std_logic;
		 RST_N	 : in std_logic;
		 LOAD 	 : in std_logic);
end entity;

architecture behavioural of REG is

begin

REGPROC: process(CLK, RST_N)
	begin
		if(RST_N = '0') then
			REG_OUT <= (others => '0');
			elsif(CLK'EVENT AND CLK = '1') then
				if(LOAD = '1') then
				REG_OUT <= REG_IN;
			end if;
		end if;

end process;

end architecture;
