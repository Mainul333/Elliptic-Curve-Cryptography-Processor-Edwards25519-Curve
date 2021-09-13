
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity ECPM is
	 generic ( k : integer := 256);
    Port ( 
           key : in  std_logic_vector(k-1 downto 0);
           QX : out  std_logic_vector(k-1 downto 0);
           QY : out  std_logic_vector(k-1 downto 0);
			  QZ : out  std_logic_vector(k-1 downto 0);
			  done : out  std_logic;

			  CLK : in  std_logic;
			  start : in  std_logic;
		
			  reset : in  std_logic);
end ECPM;


architecture Behavioral of ECPM is


signal AX1,AX2,AX3,AY1,AY2,AY3,AZ1,AZ2,AZ3 : std_logic_vector(k-1 downto 0);


signal  count: integer range 0 to k;

signal  done1, done2: std_logic; 
signal  start1, reset1: std_logic; 
signal   first,check2,check, PA: std_logic; 

--component Reg_PDPA_new 
--    generic (k : integer := 256);
--    Port ( D : in  STD_LOGIC_VECTOR (k-1 downto 0);
--           clk, reset : in  STD_LOGIC;
--			  start: in std_logic;
--			  done : out std_logic;
--           Q : out  STD_LOGIC_VECTOR (k-1 downto 0));
--end component;

component UPA
    Port ( X1 : in STD_LOGIC_vector(k-1 downto 0);
           Y1 : in  STD_LOGIC_vector(k-1 downto 0);
			  Z1 : in  STD_LOGIC_vector(k-1 downto 0);
			  X2 : in STD_LOGIC_vector(k-1 downto 0);
           Y2 : in  STD_LOGIC_vector(k-1 downto 0);
			  Z2 : in  STD_LOGIC_vector(k-1 downto 0);
           X3 : out  STD_LOGIC_vector(k-1 downto 0);
           Y3 : out  STD_LOGIC_vector(k-1 downto 0);
			  Z3 : out  STD_LOGIC_vector(k-1 downto 0);
			  CLK  : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  done : out STD_LOGIC;
			  start : in STD_LOGIC);
end component;
constant PX : std_logic_vector(255 downto 0):= x"216936D3CD6E53FEC0A4E231FDD6DC5C692CC7609525A7B2C9562D608F25D51A";
constant PY : std_logic_vector(255 downto 0):= x"6666666666666666666666666666666666666666666666666666666666666658";
constant PZ : std_logic_vector(255 downto 0):= x"0000000000000000000000000000000000000000000000000000000000000001";

begin
UPA_Jac : UPA port map (X1=>AX1, Y1=>AY1, Z1 => AZ1, X2=>AX2, Y2=>AY2, Z2 => AZ2, X3=>AX3, Y3=>AY3, Z3 => AZ3, CLK=>CLK, reset=>reset1, done=>done1, start=>start1);

--R1Q_PD : Reg_PDPA_new generic map(k=>256)  port map (D=>Q2X, Q=>QQ2X, clk=>clk, reset=>reset, start=>done1,done=>d1);
--R2Q_PD : Reg_PDPA_new generic map(k=>256)  port map (D=>Q2Y, Q=>QQ2Y, clk=>clk, reset=>reset, start=>done1,done=>d2);
--R3Q_PD : Reg_PDPA_new generic map(k=>256)  port map (D=>Q2Z, Q=>QQ2Z, clk=>clk, reset=>reset, start=>done1,done=>d3);

--R1Q_PD : Reg_PDPA_new generic map(k=>256)  port map (D=>Q2pX, Q=>QQX, clk=>clk, reset=>reset, start=>done2,done=>d1);
--R2Q_PD : Reg_PDPA_new generic map(k=>256)  port map (D=>Q2pY, Q=>QQY, clk=>clk, reset=>reset, start=>done2,done=>d2);
--R3Q_PD : Reg_PDPA_new generic map(k=>256)  port map (D=>Q2pZ, Q=>QQZ, clk=>clk, reset=>reset, start=>done2,done=>d3);
control_unit: process (CLK, reset,reset1)
begin

if (reset = '1') then
	count <= k;


   done<= '0';
	check <= '1';
--	
--				QX <=  x"0000000000000000000000000000000000000000000000000000000000000000";
--				QY <= x"0000000000000000000000000000000000000000000000000000000000000000";
--				QZ <= x"0000000000000000000000000000000000000000000000000000000000000000";

elsif(reset1 = '1') then
	reset1 <= '0';



	done2 <= '0';
 

elsif (CLK'event and CLK = '1' and start='1') then

if(done2 = '0' ) then
 if(check = '1') then

--  if(key(count-1) = '1') then

		      AX1<=PX;
	         AY1<=PY;
	         AZ1<=PZ;
	         AX2<=PX;
	        AY2<=PY;
	        AZ2<=PZ;

 	   first <='1';
       PA<='0';
        start1 <= '1';
	    reset1 <= '1';
        check <= '0';
--	    else
--	    count <= count - 1;
--        end if;
             
 else

 done2<= done1;
 
 end if;
	                
	                

else




if(count >1) then



if(key(count-2)='1') then
if(first='1') then
		AX2 <= PX;
	    AY2 <= PY;
	    AZ2 <= PZ;

	    AX1 <= AX3;
	    AY1 <= AY3;
	    AZ1 <= AZ3;
    first<='0';
    count <= count - 1; 
		 


else

 if(PA='0') then
	
	

		 AX1 <= AX3;
	    AY1 <= AY3;
	    AZ1 <= AZ3;
	    AX2 <= AX3;
	    AY2 <= AY3;
	    AZ2 <= AZ3;
	    PA<='1';
     

 else

   	 AX1 <= PX;
	    AY1 <= PY;
	    AZ1 <= PZ;
	    AX2 <= AX3;
	    AY2 <= AY3;
	    AZ2 <= AZ3;
       PA<='0';
		 count<=count-1;

end if;	
end if; 		
else
if(first='0') then
		 AX1 <= AX3;
	    AY1 <= AY3;
	    AZ1 <= AZ3;
	    AX2 <= AX3;
	    AY2 <= AY3;
	    AZ2 <= AZ3;
	else
	first<='0';
	
end if;
	 count<=count-1;
end if;
reset1<='1';



else
				QX <= AX3;
				QY <= AY3;
				QZ <= AZ3;

			
			       done<= done1;
				


end if;

	 

 













end if;
end if;


end process control_unit;
end Behavioral;


