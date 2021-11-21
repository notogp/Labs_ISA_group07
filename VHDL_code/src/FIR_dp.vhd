library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity FIR_dp is
	port (
		RST_N    : in std_logic;           -- Control unit
		CTRL_IN  : in std_logic;           -- Control unit
		--CTRL_OUT : in std_logic;           -- Control Unit
		CLK      : in std_logic;           -- External
		DIN      : in signed(NBIT-1 downto 0); -- External
		B0       : in signed(NBIT-1 downto 0); -- External
		B1       : in signed(NBIT-1 downto 0); -- External
		B2       : in signed(NBIT-1 downto 0); -- External
		B3       : in signed(NBIT-1 downto 0); -- External
		B4       : in signed(NBIT-1 downto 0); -- External
		B5       : in signed(NBIT-1 downto 0); -- External
		B6       : in signed(NBIT-1 downto 0); -- External
		B7       : in signed(NBIT-1 downto 0); -- External
		B8       : in signed(NBIT-1 downto 0); -- External
		DOUT     : out signed(NBIT-1 downto 0) -- External
	);
end entity;

architecture behavioural of FIR_dp is

	component REG is
		port (
			REG_IN 	: in signed(NBIT-1 downto 0);
			REG_OUT : out signed(NBIT-1 downto 0);
			CLK		: in std_logic;
			RST_N	: in std_logic;
			LOAD 	: in std_logic);
	end component;

	type registers_array is array (8 downto 0) of signed(NBIT-1 downto 0); -- Array for the delay line
	type coeff_array is array (8 downto 0) of signed(NBIT-1 downto 0);     -- Array for the coefficients
	type mult_array is array (8 downto 0) of signed(2*NBIT-1 downto 0);    -- Array for the results of multiplications
	type sum_array is array (7 downto 0) of signed(NBIT-1 downto 0);            -- Array for the results of additions

	signal coeff      : coeff_array;
	signal delay_line : registers_array;
	signal mult       : mult_array;
	signal sum        : sum_array;

	signal cnt_out  : unsigned(2 downto 0);
	signal dumb_one : std_logic;

begin

	coeff(0) <= B0(NBIT-1 downto 0);
	coeff(1) <= B1(NBIT-1 downto 0);
	coeff(2) <= B2(NBIT-1 downto 0);
	coeff(3) <= B3(NBIT-1 downto 0);
	coeff(4) <= B4(NBIT-1 downto 0);
	coeff(5) <= B5(NBIT-1 downto 0);
	coeff(6) <= B6(NBIT-1 downto 0);
	coeff(7) <= B7(NBIT-1 downto 0);
	coeff(8) <= B8(NBIT-1 downto 0);
	
	
	dumb_one <= '1';
	
	input_register : reg 
		port map(REG_IN => DIN, REG_OUT => delay_line(0), CLK => CLK, RST_N => RST_N, LOAD => CTRL_IN); --input register, always enabled


	registers : for i in 1 to 8 generate
			i_register : reg 
			port map(REG_IN => delay_line(i - 1), REG_OUT => delay_line(i), CLK => CLK, RST_N => RST_N, LOAD => CTRL_IN);
		end generate; -- registers

	multiplier : for i in 0 to 8 generate
		mult(i) <= coeff(i) * delay_line(i);
	end generate; -- multipliers with correction

	sum(0) <= mult(0)(2*NBIT-2 downto NBIT-1) + mult(1)(2*NBIT-2 downto NBIT-1);

	adder : for i in 1 to 7 generate
		sum(i) <= mult(i + 1)(2*NBIT-2 downto NBIT-1) + sum(i - 1);
	end generate; -- adders


	output_register : reg 
		port map(REG_IN => sum(7), REG_OUT => DOUT, CLK => CLK, RST_N => RST_N, LOAD => CTRL_IN);--output register,enabled when an output is ready

end architecture;
