--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:29:23 04/19/2015
-- Design Name:   
-- Module Name:   E:/Github/TCP_full_stack/src/tb//UART_tb.vhd
-- Project Name:  project_full_stack
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UART
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY UART_w_FIFO_tb IS
END UART_w_FIFO_tb;
 
ARCHITECTURE behavior OF UART_w_FIFO_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	COMPONENT UART_w_FIFO
	PORT(
		nRST : IN std_logic;
		CLK : IN std_logic;
		RX_serial : IN std_logic;
		DIN : IN std_logic_vector(7 downto 0);
		WR : IN std_logic;
		RD : IN std_logic;          
		TX_serial : OUT std_logic;
		FULL : OUT std_logic;
		DOUT : OUT std_logic_vector(7 downto 0);
		DOUTV : OUT std_logic
		);
	END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal nRST : std_logic := '0';
   signal RX_serial : std_logic := '0';

   signal TX_serial : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	
	signal DIN : std_logic_vector(7 downto 0) := (others => '0');
	signal DOUT :std_logic_vector(7 downto 0);
	signal DOUTV : std_logic;
	
	signal WR : std_logic;
	signal RD : std_logic;
	
	signal DOUT_latched : std_logic_vector(7 downto 0);
	
	signal FULL : std_logic;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)

	Inst_UART_w_FIFO: UART_w_FIFO PORT MAP(
		nRST => nRST,
		CLK => CLK,
		RX_serial => RX_serial,
		TX_serial => TX_serial,
		DIN => DIN,
		WR => WR,
		FULL => FULL,
		DOUT => DOUT,
		RD => RD,
		DOUTV => DOUTV 
	);

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
	RX_serial <= TX_serial after 100 ns;
   -- Stimulus process
   rst_proc: process
		-- Note that LSB is transmitted first

		type char_array is array(integer range <>) of std_logic_vector(7 downto 0);
		
		-- Input data
		constant vector_to_rx : char_array(0 to 3) := (x"FF", x"00", x"55", x"AA");
		
		-- Period: 1s / 115200 ~ 8680.55 ns
		constant uart_period :time := 8680.55 ns;
   begin		
      nRST <= '0';
      wait for 100 ns;	
		nRST <= '1';
		
      wait;
   end process;
	
	RD <= DOUTV;
	process(nRST, CLK)
	begin
		if(nRST = '0') then
			DOUT_latched <= x"00";
		elsif (rising_edge(CLK)) then
			if(DOUTV = '1') then
				DOUT_latched <= DOUT;
			end if;
		end if;
	end process;
	
	tx_proc: process
		type char_array is array(integer range <>) of std_logic_vector(7 downto 0);
		
		-- Period: 1s / 115200 ~ 8680.55 ns
		constant uart_period :time := 8680.55 ns;
	begin
		wait until nRST = '1';
		wait for CLK_period;
		
		DIN <= std_logic_vector(to_unsigned(1, DIN'length));		
		WR <= '1';
		wait for CLK_period;
		
		DIN <= std_logic_vector(to_unsigned(2, DIN'length));		
		WR <= '1';
		wait for CLK_period;
		
		DIN <= std_logic_vector(to_unsigned(3, DIN'length));		
		WR <= '1';
		wait for CLK_period;
		
		WR <= '0';
		wait;
	end process;

END;
