
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity UPA is
	 generic ( K : integer := 256);
    Port ( X1 : in STD_LOGIC_vector(k-1 downto 0);
           Y1 : in  STD_LOGIC_vector(k-1 downto 0);
			  Z1 : in  STD_LOGIC_vector(k-1 downto 0);
			  X2 : in STD_LOGIC_vector(k-1 downto 0);
           Y2 : in  STD_LOGIC_vector(k-1 downto 0);
			  Z2 : in  STD_LOGIC_vector(k-1 downto 0);
           X3 : out  STD_LOGIC_vector(k-1 downto 0);
           Y3 : out  STD_LOGIC_vector(k-1 downto 0);
			  Z3 : out  STD_LOGIC_vector(k-1 downto 0);
			  clk  : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  done : out STD_LOGIC;
			  start : in STD_LOGIC);
end UPA;

architecture Behavioral of UPA is
constant d: std_logic_vector(k-1 downto 0) := x"52036CEE2B6FFE738CC740797779E89800700A4D4141D8AB75EB4DCA135978A3";  --for B-Curbe d=-121665/121666


signal  A1,A2,A3,S1,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,SQ1: STD_LOGIC_vector(k-1 downto 0);
signal d1, d2, d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16,d17: STD_LOGIC;
signal l1, l2, l3,l4: STD_LOGIC;
component add
  port (A: in STD_LOGIC_vector(k-1 downto 0);
		  B: in STD_LOGIC_vector(k-1 downto 0);
		  C: out STD_LOGIC_vector(k-1 downto 0);
		  clk  : in  STD_LOGIC;
        reset : in  STD_LOGIC;
		  start: in  STD_LOGIC;
		  done: out  STD_LOGIC);
end component;

component sub
  port (A: in STD_LOGIC_vector(k-1 downto 0);
		  B: in STD_LOGIC_vector(k-1 downto 0);
		  C: out STD_LOGIC_vector(k-1 downto 0);
		  clk  : in  STD_LOGIC;
        reset: in  STD_LOGIC;
		  start: in  STD_LOGIC;
		  done: out  STD_LOGIC);
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

component sq
  port (A: in STD_LOGIC_vector(k-1 downto 0);
		  C: out STD_LOGIC_vector(k-1 downto 0);
		  clk  : in  STD_LOGIC;
        reset: in  STD_LOGIC;
		  start: in  STD_LOGIC;
		  done: out  STD_LOGIC);
end component;

begin

MM1_UPA : mult   port map (A=>X1, B=>X2, C=>M1, clk=>clk, reset=>reset,  start=>start,done=>d1);
MM2_UPA : mult   port map (A=>Y1, B=>Y2,  C=>M2, clk=>clk, reset=>reset, start=>start, done=>d2);
MM3_UPA : mult   port map (A=>Z1, B=>Z2, C=>M3, clk=>clk, reset=>reset,  start=>start,done=>d3);
MM4_UPA : mult   port map (A=>X1, B=>Y2, C=>M4, clk=>clk, reset=>reset,  start=>start,done=>d4);
MM5_UPA : mult   port map (A=>Y1, B=>X2, C=>M5, clk=>clk, reset=>reset,  start=>start,done=>d5);

l1<=d1 and d2 and d3 and d4 and d5;


----Level 2
MM6_UPA : mult   port map (A=>M1, B=>M2, C=>M6, clk=>clk, reset=>reset, start=>l1, done=>d6);
MA1_UPA : add   port map (A=>M1, B=>M2, C=>A1, clk=>clk, reset=>reset,  start=>l1,done=>d7);
MSQ1_UPA : sq   port map (A=>M3,  C=>SQ1, clk=>clk, reset=>reset,  start=>l1,done=>d8);
MA2_UPA : add   port map (A=>M4, B=>M5, C=>A2, clk=>clk, reset=>reset,  start=>l1,done=>d9);

l2<=d6 and d7 and d8 and d9;
----Level 3
MM7_UPA : mult   port map (A=>d, B=>M6, C=>M7, clk=>clk, reset=>reset,  start=>l2,done=>d10);
MM8_UPA : mult   port map (A=>A1, B=>M3, C=>M8, clk=>clk, reset=>reset,  start=>l2,done=>d11);
MM9_UPA : mult   port map (A=>A2, B=>M3, C=>M9, clk=>clk, reset=>reset,  start=>l2,done=>d12);

l3<=d10 and d11 and d12;

----Level 4
MA3_UPA : add   port map (A=>SQ1, B=>M7, C=>A3, clk=>clk, reset=>reset,  start=>l3,done=>d13);
MS1_UPA : sub   port map (A=>SQ1, B=>M7, C=>S1, clk=>clk, reset=>reset,  start=>l3,done=>d14);

l4<=d13 and d14;
----Level 5

MM10_UPA : mult   port map (A=>S1, B=>A3, C=>M10, clk=>clk, reset=>reset, start=>l4, done=>d15);
MM11_UPA : mult   port map (A=>A3, B=>M8, C=>M11, clk=>clk, reset=>reset, start=>l4, done=>d16);
MM12_UPA : mult   port map (A=>S1, B=>M9, C=>M12, clk=>clk, reset=>reset, start=>l4,done=>d17);
-- ----Level 1

-- MM1_UPA : mult  port map (A=>X1, B=>X2, C=>M1, clk=>clk, reset=>reset,  start=>start,done=>d1);
-- MM2_UPA : mult  port map (A=>Y1, B=>Y2,  C=>M2, clk=>clk, reset=>reset, start=>start, done=>d2);
-- MA1_UPA : add  port map (A=>X1, B=>Y1, C=>A1, clk=>clk, reset=>reset,  start=>start,done=>d3);
-- MA2_UPA : add  port map (A=>X2, B=>Y2, C=>A2, clk=>clk, reset=>reset,  start=>start,done=>d4);
-- MM3_UPA : mult  port map (A=>Z1, B=>Z2, C=>M3, clk=>clk, reset=>reset, start=>start, done=>d5);


-- ----Level 2
-- MM4_UPA : mult  port map (A=>a, B=>M1, C=>M4, clk=>clk, reset=>reset, start=>d1, done=>d6);
-- MM5_UPA : mult  port map (A=>M1, B=>M2, C=>M5, clk=>clk, reset=>reset, start=>d2,done=>d7);
-- MM6_UPA : mult  port map (A=>A1, B=>A2, C=>M6, clk=>clk, reset=>reset, start=>d1,done=>d8);
-- MSQ1_UPA : sq  port map (A=>M3,  C=>SQ1, clk=>clk, reset=>reset,  start=>d5,done=>d9);


-- ----Level 3
-- MM7_UPA : mult  port map (A=>d, B=>M5, C=>M7, clk=>clk, reset=>reset,  start=>d7,done=>d10);
-- MS1_UPA : sub  port map (A=>M2, B=>M4, C=>S1, clk=>clk, reset=>reset,  start=>d6,done=>d11);
-- MS2_UPA : sub  port map (A=>M6, B=>M1, C=>S2, clk=>clk, reset=>reset,  start=>d8,done=>d12);


-- ----Level 4
-- MA3_UPA : add  port map (A=>SQ1, B=>M7, C=>A3, clk=>clk, reset=>reset,  start=>d10,done=>d13);
-- MS3_UPA : sub  port map (A=>SQ1, B=>M7, C=>S3, clk=>clk, reset=>reset,  start=>d10,done=>d14);
-- MS4_UPA : sub  port map (A=>S2, B=>M2, C=>S4, clk=>clk, reset=>reset,  start=>d10,done=>d15);


-- ----Level 5

-- MM8_UPA : mult  port map (A=>A3, B=>M3, C=>M8, clk=>clk, reset=>reset, start=>d13, done=>d16);
-- MM9_UPA : mult  port map (A=>S3, B=>M3, C=>M9, clk=>clk, reset=>reset, start=>d14, done=>d17);

-- ----Level 6

-- MM10_UPA : mult  port map (A=>A3, B=>S3, C=>M10, clk=>clk, reset=>reset, start=>d16, done=>d18);
-- MM11_UPA : mult  port map (A=>M8, B=>S1, C=>M11, clk=>clk, reset=>reset, start=>d16, done=>d19);
-- MM12_UPA : mult  port map (A=>M9, B=>S4, C=>M12, clk=>clk, reset=>reset, start=>d17,done=>d20);

control_UPA_JAC:process(X1, X2, Y1, Y2, Z1, Z2, M10, M11,M12, reset, d15, d16, d17)
begin

		

			X3 <=M12;
			Y3 <=M11;
			Z3 <=M10;
		  done <= d15 and d16 and d17;

end process;
end Behavioral;

