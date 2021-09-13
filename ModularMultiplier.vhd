
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mult is
	 generic ( k : integer := 256);
    Port ( A : in  std_logic_vector(k-1 downto 0);
           B : in  std_logic_vector(k-1 downto 0);
           C : out  std_logic_vector(k-1 downto 0);
           CLK : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  start: in  STD_LOGIC;
			  done : out  STD_LOGIC
			  );
end mult;

architecture Behavioral of mult is
constant P: std_logic_vector(k+1 downto 0):="00"&x"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFED"; --for 256 bit
constant P2: std_logic_vector(k+1 downto 0):="00"&x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDA"; --for 256 bit
constant P3: std_logic_vector(k+1 downto 0):="01"&x"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC7"; --258 bits
constant P4: std_logic_vector(k+1 downto 0):="01"&x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB4"; --258 bits
constant P5: std_logic_vector(k+1 downto 0):= "10"&x"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA1"; --259 bits
constant P6: std_logic_vector(k+1 downto 0):= "10"&x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8E"; --259 bits

signal temp1: std_logic_vector(k+1 downto 0);


signal temp21,temp22,prod,prod1, prod2, prod3,prod4: std_logic_vector(k+1 downto 0);
signal sel1: std_logic_vector(1 downto 0);
signal sel2: std_logic_vector(2 downto 0);

signal first: std_logic;
 
begin

sel1<=temp1(k+1)&temp1(k);
 with sel1 select
		prod1 <= prod + temp21 + temp22 when "11",
		         prod+temp21 when "10",
					prod+temp22 when "01",
		         prod when others;

sel2<=prod1(k+1)&prod1(k)&prod1(k-1);
				

with sel2 select
		prod4 <= prod1  when "000",
					prod1-P when "001",
					prod1-P2 when "010",
					prod1-P3 when "011",
					prod1-P4 when "100",
					prod1-P5 when "101",

					prod1-P6 when others;
 

 
process(CLK, reset, start)

begin
	if reset = '1' then
		done <= '0';
		first<='1';
		prod<=(others => '0');

		   C <= x"0000000000000000000000000000000000000000000000000000000000000000";

		 
	elsif (CLK'event and CLK = '1' and start= '1')  then
		if first = '1' then
		
							temp1 <= B&"01";

			temp21 <= '0' & A&'0';
			temp22 <= "00" & A;

		
			first <= '0';
		else
			
           if temp1( k-1 downto 0)='0'&x"4000000000000000000000000000000000000000000000000000000000000000" then
			   C <= prod4( k-1 downto 0);	
				done <= '1';
  


           else
           prod <= prod4( k-1 downto 0) & "00";
           temp1 <= temp1(k-1 downto 0) & "00";

			end if;
		end if;
	end if;
end process;
end Behavioral;


