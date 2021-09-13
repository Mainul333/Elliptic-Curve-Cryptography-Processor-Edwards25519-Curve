
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addtiply operation

entity add is
generic (k : integer := 256);
	PORT(A, B : IN std_logic_vector(k-1 downto 0);
	        CLK : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  start: in  STD_LOGIC;
			  done : out  STD_LOGIC;
	C : OUT std_logic_vector(k-1 downto 0));
end add;


architecture arch_add of add is

constant P: std_logic_vector(255 downto 0):=x"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFED"; --for 256 bit

signal count : integer := 1;
begin

add_pf24_clk: process (CLK,reset, start)
variable temp, Xtemp : std_logic_vector(k downto 0);
begin
if reset = '1' then
		count <= 1;
--		C <= x"0000000000000000000000000000000000000000000000000000000000000000";
		done <= '0';
elsif (CLK'event and CLK = '1' and start= '1') then
      temp := ('0' & A) + ('0' & B);
if (temp(k-1)= '1') then
      Xtemp := temp-('0'&P);
else
      Xtemp := temp;
end if;
      if(count = 0) then
		    count <= 1;	
		    C <= Xtemp(k-1 downto 0);	
			 done <= '1';
      else
	       count <= count - 1;
      end if;

end if;

end process add_pf24_clk;
end arch_add;

