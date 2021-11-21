
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_textio.all;
  use std.textio.all;
  use work.constants.all;

entity tb_fir_all is
  port (
      CLK              : out    std_logic;
      RST_N            : out    std_logic;
      DIN0             : out    signed (11 downto 0);
      DIN1             : out    signed (11 downto 0);
      DIN2             : out    signed (11 downto 0);
      VIN              : out    std_logic;
      B0               : out    signed(11 downto 0);
      B1               : out    signed(11 downto 0);
      B2               : out    signed(11 downto 0);
      B3               : out    signed(11 downto 0);
      B4               : out    signed(11 downto 0);
      B5               : out    signed(11 downto 0);
      B6               : out    signed(11 downto 0);
      B7               : out    signed(11 downto 0);
      B8               : out    signed(11 downto 0);
      VOUT             : in   std_logic;
      DOUT0             : in   signed (11 downto 0);
      DOUT1             : in   signed (11 downto 0);
      DOUT2             : in   signed (11 downto 0)
  );
end entity tb_fir_all;

architecture behavioural of tb_fir_all is


  signal initialized                 : std_logic := '0';
  --signal vout,             vin       : std_logic;
  --signal dout0, dout1, dout2, din0, din1, din2 : signed (11 downto 0);
  --signal clk,              rst_n     : std_logic;
  signal vout_sig, vin_sig		     : std_logic;
  signal  dout0_sig, dout1_sig, dout2_sig, din0_sig, din1_sig, din2_sig           : signed (11 downto 0);
  signal clk_sig, rst_n_sig   	     : std_logic;

  signal h0                          : signed (11 downto 0);
  signal h1                          : signed (11 downto 0);
  signal h2                          : signed (11 downto 0);
  signal h3                          : signed (11 downto 0);
  signal h4                          : signed (11 downto 0);
  signal h5                          : signed (11 downto 0);
  signal h6                          : signed (11 downto 0);
  signal h7                          : signed (11 downto 0);
  signal h8                          : signed (11 downto 0);
  signal cnt_ins,          cnt_outs  : unsigned (7 downto 0);
  signal sEndSim   : std_logic;
  signal END_SIM_i : std_logic_vector(0 to NBIT-1);
  constant tco : time := 1 ns;
  constant ts : time := 10 ns;

begin

  CLK_PROCESS : process
  begin

    clk_sig <= '0';
    wait for 20 ns;
    clk_sig <= '1';
    wait for 20 ns;

  end process CLK_PROCESS;

  RST_PROCESS : process
  begin

    rst_n_sig       <= '1';
    wait for 5 ns;
    rst_n_sig       <= '0';
    wait for 10 ns;
    rst_n_sig      <= '1';
    initialized <= '1';
    wait for 1 sec;

  end process RST_PROCESS;

  --  ^^ initialization takes 3 clock cycles ^^

  h0 <= to_signed(-13, 12);
  h1 <= to_signed(-28, 12);
  h2 <= to_signed(104, 12);
  h3 <= to_signed(544, 12);
  h4 <= to_signed(830, 12);
  h5 <= to_signed(544, 12);
  h6 <= to_signed(104, 12);
  h7 <= to_signed(-28, 12);
  h8 <= to_signed(-13, 12);




---------------------------------------------------------------------------------------
	DATA_GEN_PROC : process (clk_sig, rst_n_sig)
    file fp_in       : text open READ_MODE is "/home/isa07_2021_2022/Desktop/Lab1_group07_NOTO/Lab1/Matlab_code/samples.txt";
    variable line_in : line;
    variable x0       : integer;
    variable x1       : integer;
    variable x2      : integer;
  begin               -- process
    if rst_n_sig = '0' then -- asynchronous reset (active low)
      din0_sig    <= (others => '0') after tco;
      din1_sig    <= (others => '0') after tco;
      din2_sig    <= (others => '0') after tco;
      vin_sig    <= '0' after tco;
      sEndSim <= '0' after tco;
    elsif clk_sig'event and clk_sig = '1' then -- rising clock edge
      if not endfile(fp_in) then
        readline(fp_in, line_in);
        read(line_in, x0);
        din0_sig    <= to_signed(x0, NBIT) after tco;
        readline(fp_in, line_in);
        read(line_in, x1);
        din1_sig    <= to_signed(x1, NBIT) after tco;
        readline(fp_in, line_in);
        read(line_in, x2);
        din2_sig    <= to_signed(x2, NBIT) after tco;
        vin_sig    <= '1' after tco;
        sEndSim <= '0' after tco;
      else
        vin_sig    <= '0' after tco; --2*ts + tco;
        sEndSim <= '1' after tco;
      end if;
    end if;
  end process DATA_GEN_PROC;

  END_SIM_PROC : process (clk_sig, rst_n_sig)
  begin               -- process
    if rst_n_sig = '0' then -- asynchronous reset (active low)
      END_SIM_i <= (others => '0') after tco;
    elsif clk_sig'event and clk_sig = '1' then -- rising clock edge
      END_SIM_i(0)       <= sEndSim after tco;
      END_SIM_i(1 to NBIT-1) <= END_SIM_i(0 to NBIT-2) after tco;
    end if;
  end process END_SIM_PROC;

--------------------------------------------------
  DATA_SINK_PROCESS : process (clk_sig, rst_n_sig)
    file res_fp : text open WRITE_MODE is "/home/isa07_2021_2022/Desktop/Lab1_group07_NOTO/Lab1/VHDL_code/2.4/unfolded/resultsV.txt";
    variable line_out : line;    
  begin  -- process
    if rst_n_sig = '0' then                 -- asynchronous reset (active low)
      null;
    elsif clk_sig'event and clk_sig = '1' then  -- rising clock edge
      if (vout_sig = '1') then
        write(line_out, to_integer(dout0_sig));
        writeline(res_fp, line_out);
        write(line_out, to_integer(dout1_sig));
        writeline(res_fp, line_out);
        write(line_out, to_integer(dout2_sig));
        writeline(res_fp, line_out);
      end if;
    end if;
  end process DATA_SINK_PROCESS;
-------------------------------------------------- 
 -- DUT : FIR_Filter_unfolded
  --  port map (
CLK <= clk_sig;
RST_N <= rst_n_sig;
 DIN0 <= din0_sig;
 DIN1 <= din1_sig;
 DIN2 <= din2_sig; 
VIN <= vin_sig; 
B0 <= h0;
 B1 <= h1;
 B2 <= h2;
 B3 <= h3;
 B4 <= h4;
 B5 <= h5;
 B6 <= h6; 
B7 <= h7;
 B8 <= h8;



end architecture behavioural;
