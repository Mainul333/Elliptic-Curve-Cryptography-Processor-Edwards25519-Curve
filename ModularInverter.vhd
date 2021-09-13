
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
	
entity inv is
    generic ( m : integer := 256);
    Port ( B : in  STD_LOGIC_VECTOR (m-1 downto 0);
           C : out  STD_LOGIC_VECTOR (m-1 downto 0);
			  clk : in std_logic;
			  start : in std_logic;
			  done : out std_logic;
			  reset : in std_logic);
end inv;

architecture arch_inv of inv is



signal x,x1,x2,x3,x4, y,y1,y2,y3,y4, U1,U2,V1,V2,UV,VU,xy,yx,xpy,ypx,xp,yp: std_logic_vector (m downto 0);
constant p : std_logic_vector (m-1 downto 0) := x"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFED";
constant xi : std_logic_vector (m-1 downto 0) := x"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEE";

signal first: std_logic;
signal sel1: std_logic_vector(1 downto 0);

signal sel2: std_logic_vector(1 downto 0);
signal U: std_logic_vector(m downto 0);
signal V: std_logic_vector (m downto 0);
begin

UV<=U-V;
VU<=V-U;
xy<=x-y;
yx<=y-x;
xpy<=x+p-y;
ypx<=y+p-x;

with UV(m) select
U2<=UV when '0',
    U when others;
  
  
with VU(m) select
V2<=VU when '0',
    V when others;


sel1<=UV(m)&xy(m);

with sel1 select
x2<=xy when "00",
    xpy when "01",
	 x when others;
	
sel2<=VU(m)&yx(m);
x3<=x2+p;

with sel2 select
y2<=yx when "00",
    ypx when "01",
	 y when others;
y3<=y2+p;

xp<=x2-p;
with xp(m) select
x4<=xp when '0',
    x2 when others;			
 process (clk, reset,start)

begin

		if reset = '1' then

         first<='1';

            done <= '0';
				C<=x"0000000000000000000000000000000000000000000000000000000000000000";					
		elsif (CLK'event and CLK = '1' and start= '1') then 

      if(first='1') then
		
		if B(0)='0' then
						U<="00"&B(m-1 downto 1);
						x<="00"&xi(m-1 downto 1);
						else
				      U<='0'&B;
						x<='0'&x"0000000000000000000000000000000000000000000000000000000000000001";
						end if;
		            V<='0'&p;
						y<='0'&x"0000000000000000000000000000000000000000000000000000000000000000";						
					first<='0';
	    else  

		    if (U= 1) then
             C<=x4(m-1 downto 0);
             done<='1';
          else
			  if U2(0)='0' then
			  
	            U<='0'& U2(m downto 1);
					if x2(0)='0' then
					x<='0'&x2(m downto 1);
					else
					x<='0'&x3(m downto 1);
					end if;
					
				else
				x<=x2;
				U<=U2;
				end if;
				if V2(0)='0' then
	         	V<='0'& V2(m downto 1);
					if y2(0)='0' then
					y<='0'&y2(m downto 1);
					else
					y<='0'&y3(m downto 1);
					end if;					
				else
				y<=y2;
				 V<=V2;
				end if;
				 

      end if;
			 


	  end if;
	 end if;
end process;
end arch_inv;


