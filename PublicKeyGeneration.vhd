
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity ECC is
	 generic ( k : integer := 256);
    Port ( 
           key : in  std_logic_vector(k-1 downto 0);
           x : out  std_logic_vector(k-1 downto 0);
			  y : out  std_logic_vector(k-1 downto 0);
			  CLK : in std_logic;
			  start : in std_logic;

			  reset : in  std_logic;
			  done :  out std_logic);
end ECC;


architecture Behavioral of ECC is



component ECPM
    Port ( 
           key : in  std_logic_vector(k-1 downto 0);
           QX : out  std_logic_vector(k-1 downto 0);
           QY : out  std_logic_vector(k-1 downto 0);
			  QZ : out  std_logic_vector(k-1 downto 0);
			  done : out  std_logic;
			  CLK : in  std_logic;
		      start: in  STD_LOGIC;

			  reset : in  std_logic);
end component;

component mult
  port (A: in STD_LOGIC_vector(k-1 downto 0);
		  B: in STD_LOGIC_vector(k-1 downto 0);
		  C: out STD_LOGIC_vector(k-1 downto 0);
		  clk  : in  STD_LOGIC;
        reset: in  STD_LOGIC;
		  start: in  STD_LOGIC;
		  done: out  STD_LOGIC);
end component;
component inv



  port (B: in STD_LOGIC_vector(k-1 downto 0);
		  C: out STD_LOGIC_vector(k-1 downto 0);
		  clk  : in  STD_LOGIC;
        reset: in  STD_LOGIC;
		  start: in  STD_LOGIC;
		  done: out  STD_LOGIC);
end component;

	 signal  M1,M2,M3,M4,M5,IZ: std_logic_vector(255 downto 0);



           signal d1,d2,d3,d4 :   std_logic;



begin
ECPM_Jac : ECPM port map (key=>key, QX=>M1, QY=>M2, QZ => M3, start=>start, done=>d1, CLK=> CLK, reset=>reset);
Minv_z: inv   port map (B=>M3, C=>IZ, clk=>clk, reset=>reset,  start=>d1,done=>d2);
MM_x: mult   port map (A=>M1, B=>IZ, C=>M4, clk=>clk, reset=>reset,  start=>d2,done=>d3);
MM_y: mult   port map (A=>M2, B=>IZ, C=>M5, clk=>clk, reset=>reset,  start=>d2,done=>d4);


control_unit:process(CLK,d3,d4,M4,M5)
begin	
if (reset = '1') then
			x <=x"0000000000000000000000000000000000000000000000000000000000000000";
		    y <=x"0000000000000000000000000000000000000000000000000000000000000000";
    done<= '0';

elsif (CLK'event and CLK = '1' and start='1') then
			x <=M4;
		    y <=M5;
		    done <= d3 and d4;
end if;

end process control_unit;
end Behavioral;




