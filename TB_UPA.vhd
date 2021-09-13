
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
library std;
use std.textio.all; --include UPAckage textio.vhd
 
ENTITY TB_UPA IS
END TB_UPA;
 
ARCHITECTURE behavior OF TB_UPA IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UPA
    PORT(
         X1 : IN  std_logic_vector(255 downto 0);
         Y1 : IN  std_logic_vector(255 downto 0);
         Z1 : IN  std_logic_vector(255 downto 0);
         X2 : IN  std_logic_vector(255 downto 0);
         Y2 : IN  std_logic_vector(255 downto 0);
         Z2 : IN  std_logic_vector(255 downto 0);
         X3 : OUT  std_logic_vector(255 downto 0);
         Y3 : OUT  std_logic_vector(255 downto 0);
         Z3 : OUT  std_logic_vector(255 downto 0);
         clk : IN  std_logic;
         reset : IN  std_logic;
         done : OUT  std_logic;
         start : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal X1 : std_logic_vector(255 downto 0) := (others => '0');
   signal Y1 : std_logic_vector(255 downto 0) := (others => '0');
   signal Z1 : std_logic_vector(255 downto 0) := (others => '0');
   signal X2 : std_logic_vector(255 downto 0) := (others => '0');
   signal Y2 : std_logic_vector(255 downto 0) := (others => '0');
   signal Z2 : std_logic_vector(255 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal start : std_logic := '0';

 	--Outputs
   signal X3 : std_logic_vector(255 downto 0);
   signal Y3 : std_logic_vector(255 downto 0);
   signal Z3 : std_logic_vector(255 downto 0);
   signal done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UPA PORT MAP (
          X1 => X1,
          Y1 => Y1,
          Z1 => Z1,
          X2 => X2,
          Y2 => Y2,
          Z2 => Z2,
          X3 => X3,
          Y3 => Y3,
          Z3 => Z3,
          clk => clk,
          reset => reset,
        done => done,
          start => start
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
    file_open (fstatus, file1, "TB_UPA_jac.txt",write_mode);
	 
      reset <= '1';	
      wait for clk_period;
      reset <= '0';
		start <= '1';
		
		X1 <=x"216936D3CD6E53FEC0A4E231FDD6DC5C692CC7609525A7B2C9562D608F25D51A";
      Y1 <=x"6666666666666666666666666666666666666666666666666666666666666658";
      Z1 <=x"0000000000000000000000000000000000000000000000000000000000000001";
--		
	   X2 <= x"36AB384C9F5A046C3D043B7D1833E7AC080D8E4515D7A45F83C5A14E2843CE0E";
		Y2 <= x"2260CDF3092329C21DA25EE8C9A21F5697390F51643851560E5F46AE6AF8A3C9"; 
      Z2 <= x"0000000000000000000000000000000000000000000000000000000000000001";
		
--		Z2 <= x"16793A8694A883A8BF672E05C4BD9D6D142C9EFFCC6D662E9C8B56C2FD872182";
		

		
--		X2 <=x"216936D3CD6E53FEC0A4E231FDD6DC5C692CC7609525A7B2C9562D608F25D51A";
--      Y2 <=x"6666666666666666666666666666666666666666666666666666666666666658";
--      Z2 <=x"0000000000000000000000000000000000000000000000000000000000000001";
		
		wait for clk_period;	
		
--      start <= '0';
		


		
		write (buff, string '("X1="));
      write (buff, X1);
		writeline (file1, buff);
		
		write (buff, string '("Y1="));
      write (buff, Y1);
		writeline (file1, buff);
		
		write (buff, string '("Z1="));
      write (buff, Z1);
		writeline (file1, buff);
		write (buff, string '("X2="));
      write (buff, X2);
		writeline (file1, buff);
		
		write (buff, string '("Y2="));
      write (buff, Y2);
		writeline (file1, buff);
		
		write (buff, string '("Z2="));
      write (buff, Z2);
		writeline (file1, buff);
		
		
wait for 1300 ns;
		
		write (buff, string '("X3="));
      write (buff, X3);
		writeline (file1, buff);
		
		write (buff, string '("Y3="));
      write (buff, Y3);
		writeline (file1, buff);
		
		write (buff, string '("Z3="));
      write (buff, Z3);
		writeline (file1, buff);
				
      wait;
   end process;	

END;

