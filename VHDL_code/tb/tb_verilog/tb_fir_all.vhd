
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
    DIN              : out    signed (11 downto 0);
    VIN              : out    std_logic;
    H0               : out    signed(11 downto 0);
    H1               : out    signed(11 downto 0);
    H2               : out    signed(11 downto 0);
    H3               : out    signed(11 downto 0);
    H4               : out    signed(11 downto 0);
    H5               : out    signed(11 downto 0);
    H6               : out    signed(11 downto 0);
    H7               : out    signed(11 downto 0);
    H8               : out    signed(11 downto 0);
    VOUT             : in   std_logic;
    DOUT             : in   signed (11 downto 0)
  );
end entity tb_fir_all;

architecture behavioural of tb_fir_all is

  signal initialized                 : std_logic := '0';
  signal vout_sig, vin_sig		     : std_logic;
  signal dout_sig, din_sig           : signed (11 downto 0);
  signal clk_sig, rst_n_sig   	     : std_logic;
  signal h0_sig                          : signed (11 downto 0);
  signal h1_sig                          : signed (11 downto 0);
  signal h2_sig                          : signed (11 downto 0);
  signal h3_sig                          : signed (11 downto 0);
  signal h4_sig                          : signed (11 downto 0);
  signal h5_sig                          : signed (11 downto 0);
  signal h6_sig                          : signed (11 downto 0);
  signal h7_sig                          : signed (11 downto 0);
  signal h8_sig                          : signed (11 downto 0);
  signal sEndSim   : std_logic;
  signal END_SIM_i : std_logic_vector(0 to NBIT-1);
  constant tco : time := 1 ns;
  constant ts : time := 10 ns;

begin

  CLK_PROCESS : process
  begin

    clk_sig <= '0';
    wait for 5 ns;
    clk_sig <= '1' and not(END_SIM_i(11));
    wait for 5 ns;

  end process CLK_PROCESS;

  RST_PROCESS : process
  begin

    rst_n_sig       <= '1';
    wait for 5 ns;
    rst_n_sig       <= '0';
    wait for 10 ns;
    rst_n_sig       <= '1';
    initialized <= '1';
    wait for 1 sec;

  end process RST_PROCESS;

  --  ^^ initialization takes 3 clock cycles ^^

  h0_sig <= to_signed(-13, 12);
  h1_sig <= to_signed(-28, 12);
  h2_sig <= to_signed(104, 12);
  h3_sig <= to_signed(544, 12);
  h4_sig <= to_signed(830, 12);
  h5_sig <= to_signed(544, 12);
  h6_sig <= to_signed(104, 12);
  h7_sig <= to_signed(-28, 12);
  h8_sig <= to_signed(-13, 12);


---------------------------------------------------------------------------------------
	DATA_GEN_PROC : process (clk_sig, rst_n_sig)
    file fp_in       : text open READ_MODE is "/home/isa07_2021_2022/Desktop/Lab1_group07_NOTO/Lab1/Matlab_code/samples.txt";
    variable line_in : line;
    variable x       : integer;
  begin               -- process
    if rst_n_sig = '0' then -- asynchronous reset (active low)
      din_sig    <= (others => '0') after tco;
      vin_sig    <= '0' after tco;
      sEndSim <= '0' after tco;
    elsif clk_sig'event and clk_sig = '1' then -- rising clock edge
      if not endfile(fp_in) then
        readline(fp_in, line_in);
        read(line_in, x);
        din_sig    <= to_signed(x, NBIT) after tco;
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
    file res_fp : text open WRITE_MODE is "/home/isa07_2021_2022/Desktop/Lab1_group07_NOTO/Lab1/VHDL_code/2.1/resultsV.txt";
    variable line_out : line;    
  begin  -- process
    if rst_n_sig = '0' then                 -- asynchronous reset (active low)
      null;
    elsif clk_sig'event and clk_sig = '1' then  -- rising clock edge
      if (VOUT = '1') then
        write(line_out, to_integer(DOUT));
        writeline(res_fp, line_out);
      end if;
    end if;
  end process DATA_SINK_PROCESS;
-------------------------------------------------- 
CLK <= clk_sig;
RST_N <= rst_n_sig;
DIN <= din_sig;
VIN <= vin_sig;
H0 <= h0_sig;
H1 <= h1_sig;
H2 <= h2_sig;
H3 <= h3_sig;
H4 <= h4_sig;
H5 <= h5_sig;
H6 <= h6_sig;
H7 <= h7_sig;
H8 <= h8_sig;





end architecture behavioural;
