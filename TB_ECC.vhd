
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
library std;
use std.textio.all; --include package textio.vhd
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_ECC IS
END TB_ECC;
 
ARCHITECTURE behavior OF TB_ECC IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ECC
    PORT(
         key : in  std_logic_vector(255 downto 0);
         x : OUT  std_logic_vector(255 downto 0);
         y : OUT  std_logic_vector(255 downto 0);
         done : OUT  std_logic;
         CLK : IN  std_logic;
         start : IN  std_logic;
         reset : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal key : std_logic_vector(255 downto 0) := (others => '0');
   signal start : std_logic := '0';

   signal CLK : std_logic := '0';
   signal reset : std_logic := '0';
   signal done : std_logic := '0';

 	--Outputs
   signal x : std_logic_vector(255 downto 0);
   signal y : std_logic_vector(255 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ECC PORT MAP (
          key => key,
          x => x,
          y => y,
          done => done,
          start => start,

          CLK => CLK,
          reset => reset
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

 -- Stimulus process
   stim_proc: process
	file file1: text;
	variable fstatus : File_open_status;
	variable buff : line;
	
   begin		
    file_open (fstatus, file1, "TB_ECC",write_mode);
	 
      reset <= '1';	
      wait for clk_period;
      reset <= '0';
      start <= '1';	

--		key <= x"82D25DA79ADCA7FD8149C563FBADB8B8D25C8EC12A4B4F6592AC5AC11E4BBA34";

				key <= x"82D36DA79ADCE7FE8149C463FBADB8F8D2598EC12A4B4F6592AC5AA11E4ACB36";

		--Px <= x"404A8AE52B0AF3A1863C518AB665FDC5B4D4300E659D8829ECCCC2F78CC5134E";
		--Py <= x"51C032606A5E9E980770E083AA49C44A436E386C205FA3F4B648F91F6427C8C3";
--key = 2p
--	key <= x"1000000000000000000000000000000000000000000000000000000000000000";

--key=n P
		
		--key<=x"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A1"; --key=n+1/2
		
		--key<=x"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A2"; --key=(n+1)/2+1
		
--key=n+1 P
--		key <= x"0000FFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364142";		
		
		--key= n-1 P
		--key <= x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364140";
		
		--key=n-2 P
		--key <= x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD036413F";
		
--key equal all 1
	  -- key <= x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
	  
--	  --key=x"3F FFFF" P


		wait for clk_period;
		
		write (buff, string '("key="));
      write (buff, key);
		writeline (file1, buff);
		
		
wait for 580090 ns;
		
		write (buff, string '("x="));
      write (buff, x);
		writeline (file1, buff);
		
		write (buff, string '("y="));
      write (buff, y);
		writeline (file1, buff);


						
			
		
      wait;
   end process;	

END;


