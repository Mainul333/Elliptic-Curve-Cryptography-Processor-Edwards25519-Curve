
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
library std;
use std.textio.all; --include package textio.vhd
 
ENTITY TB_inv IS
END TB_inv;
 
ARCHITECTURE behavior OF TB_inv IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT inv
    PORT(
         B : IN  std_logic_vector(255 downto 0);
         clk : IN  std_logic;
         reset : IN  std_logic;
         start : IN  std_logic;
         done : OUT  std_logic;
         C : OUT  std_logic_vector(255 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal B : std_logic_vector(255 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal start : std_logic := '0';

 	--Outputs
   signal done : std_logic;
   signal C : std_logic_vector(255 downto 0);

   -- Clock period definitions
   constant clk_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: inv PORT MAP (
          B => B,
          clk => clk,
          reset => reset,
          start => start,
          done => done,
          C => C
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
 

-- Stimulus process
   stim_proc: process
	file file1: text;
	variable fstatus : File_open_status;
	variable buff : line;
	
   begin		
    file_open (fstatus, file1, "TB_mod_mult_new.txt",write_mode);
	 
      reset <= '1';	
      wait for clk_period;
      reset <= '0';
		start <= '1';

--		
--		B <= x"A16936D3CD6E53FEC0A4E231FDD6DC5C692CC7609525A7B2C9562D608F25D51D";
--		B <= x"D16936D3BD6E53FEC0A4E231FDD6DC5C692CC7609525A7B2C9562D608A25D61E";
		B <= x"D16936D3BD6E53FEC0A4E231FDD6DC5C692CC7609525A4F2C9562D608A25D61E";

--		X1 <= x"216936D3CD6E53FEC0A4E231FDD6DC5C692CC7609525A7B2C9562D608F25D51A";
--		Y1 <= x"6666666666666666666666666666666666666666666666666666666666666658"; --1px,y,z
--		Z1 <= x"0000000000000000000000000000000000000000000000000000000000000001";
--		
--
--		
--		X2 <=x"31241DDB9A7C254AEA224B87B7B0F909886EC1DDFA71625B7ABA864C18300A57";
--      Y2 <=x"3324984C6CC933DB69B782FC3AC951F60A47AA662BBE321C924B2CD95E2D7FD7";
--      Z2 <=x"6986C5796B577C574098BEFA3B426292EBD360FDD39299D16374A93CEF78DE6B";
		
		wait for clk_period;
		
		

		
		write (buff, string '("B="));
      write (buff, B);
		writeline (file1, buff);
				
      wait for 260 ns;
		
		write (buff, string '("C="));
      write (buff, C);
		writeline (file1, buff);
		
      wait;
   end process;	

END;




 