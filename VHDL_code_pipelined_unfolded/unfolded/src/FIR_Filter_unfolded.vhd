
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

-- y[n] = b0*x[n] + b1*x[n-1] + b2*x[n-2] + b3*x[n-3] + b4*x[n-4] + b5*x[n-5] + b6*x[n-6] + b7*x[n-7] + b8*x[n-8]

entity FIR_Filter_unfolded is
	 port (	CLK   : in std_logic;
          RST_n : in std_logic;
          VIN   : in std_logic;
          DIN0   : in signed(NBIT-1 downto 0);
          DIN1   : in signed(NBIT-1 downto 0);
          DIN2   : in signed(NBIT-1 downto 0);
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
          DOUT0  : out signed(NBIT-1 downto 0);
		  DOUT1  : out signed(NBIT-1 downto 0);
		  DOUT2  : out signed(NBIT-1 downto 0));
end entity;

architecture behavioural of FIR_Filter_unfolded is


	component FF is
		port (
		  FF_IN  : in    std_logic;
		  FF_OUT : out   std_logic;
		  CLK    : in    std_logic;
		  RST    : in    std_logic;
		  LOAD   : in    std_logic);
	end component;

 	component FIR_cu is
		port (
		  CLK   	: in    std_logic;
		  RST_N 	: in    std_logic;
		  VIN   	: in    std_logic;
		  VIN_LOAD  : out   std_logic;
		  VOUT  	: out   std_logic
		);
	end component;
	
	component FIR_Filter_dp_unfolded is
		port (
		  RST_N    : in    std_logic;
		  CTRL_IN  : in    std_logic;
		  CLK      : in    std_logic;
		  DIN0     : in    signed(NBIT-1 downto 0);
    	  DIN1     : in    signed(NBIT-1 downto 0);
    	  DIN2     : in	   signed(NBIT-1 downto 0); 
		  B0       : in    signed(NBIT-1 downto 0);
		  B1       : in    signed(NBIT-1 downto 0);
		  B2       : in    signed(NBIT-1 downto 0);
		  B3       : in    signed(NBIT-1 downto 0);
		  B4       : in    signed(NBIT-1 downto 0);
		  B5       : in    signed(NBIT-1 downto 0);
		  B6       : in    signed(NBIT-1 downto 0);
		  B7       : in    signed(NBIT-1 downto 0);
		  B8       : in    signed(NBIT-1 downto 0);
		  DOUT0     : out signed(NBIT-1 downto 0);
    	  DOUT1     : out signed(NBIT-1 downto 0);
    	  DOUT2     : out signed(NBIT-1 downto 0));
	  end component;

  --type FlipFlops_array is array (2 downto 0) of std_logic;
  -- Control signals
  signal delay_FF1 : std_logic := '0';
  signal CTRL_IN_DP  : std_logic;
  signal VOUT_DELAYED : std_logic := '0';
  signal dumb_one : std_logic;
  signal VOUT_signal: std_logic;

begin

	dumb_one <= '1';

	CU : FIR_cu
	  port map ( CLK => CLK, RST_N => RST_N, VIN => VIN, VIN_LOAD => CTRL_IN_DP, VOUT => VOUT_DELAYED);

	DP : FIR_Filter_dp_unfolded
	  port map ( RST_N => RST_N, CTRL_IN => CTRL_IN_DP, CLK => CLK, DIN0 => DIN0, DIN1 => DIN1, DIN2 => DIN2,
				 B0 => B0, B1 => B1, B2 => B2, B3 => B3, B4 => B4, B5 => B5, B6 => B6, B7 => B7, B8 => B8, DOUT0 => DOUT0, DOUT1 => DOUT1, DOUT2 => DOUT2);

	delay1 : FF 
	  port map(FF_IN => VOUT_DELAYED, FF_OUT => delay_FF1, CLK => CLK, RST => RST_n, LOAD => dumb_one); --input register, always enabled

  VOUT <= delay_FF1;	

end architecture behavioural;
