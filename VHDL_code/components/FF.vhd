library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FF is
	port(
		FF_IN  : in std_logic;
		FF_OUT : out std_logic;
		CLK    : in std_logic;
		RST    : in std_logic;
		LOAD   : in std_logic);
end entity;

architecture behavioural of FF is

begin
	REGPROC : process (CLK, RST)
	begin
		if (RST = '0') then
			FF_OUT <= '0';
		elsif (CLK'EVENT and CLK = '1') then
			if (LOAD = '1') then
				FF_OUT <= FF_IN;
			end if;
		end if;

	end process;

end architecture;