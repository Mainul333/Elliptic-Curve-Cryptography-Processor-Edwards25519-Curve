
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addtiply operation

entity sub is
generic (k : integer := 256);
	PORT(A, B : IN std_logic_vector(k-1 downto 0);
	        CLK : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  start: in  STD_LOGIC;
			  done : out  STD_LOGIC;
	C : OUT std_logic_vector(k-1 downto 0));
end sub;

architecture arch_sub of sub is
constant P: std_logic_vector(k-1 downto 0):=x"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFED"; --for 256 bit

signal count : integer := 1;
begin

sub_clk: process(CLK, reset, start)
variable temp1, temp2 : std_logic_vector(k downto 0);


begin
if reset = '1' then
		count <= 1;
		C <= x"0000000000000000000000000000000000000000000000000000000000000000";
		done <= '0';
elsif (CLK'event and CLK = '1'and start= '1') then
      temp1 := ('0' & A)-('0' & B);
if temp1(k-1) = '0' then
		temp2 := temp1;
else
      temp2 := temp1 + ('0' & P);
end if;
      if(count = 0) then
		    count <= 1;	
		    C <= temp2(k-1 downto 0);	
			 done <= '1';
      else
	       count <= count - 1;
      end if;
end if;
end process sub_clk;
end arch_sub;

