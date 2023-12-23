library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity UART_TOP is
generic (
c_clkfreq		: integer := 27_000_000;
c_baudrate		: integer := 115_200
);
port (
clk				: in std_logic;
addr 			: in std_logic_vector(7 downto 0); 
din 			: in std_logic_vector(7 downto 0);  
w_en			: in std_logic;
outdata			: out std_logic_vector(7 downto 0);
tx_o 			: out std_logic

);
end UART_TOP;

architecture Behavioral of UART_TOP is

-- INTERNAL REGISTERS --
signal sendDataReg   : std_logic_vector(7 downto 0) := "00000000";
signal statusReg 	 : std_logic_vector(7 downto 0) := "00000000";
signal controlReg    : std_logic_vector(7 downto 0) := "00000000";

type STATE_TYPE is (IDLE,TRANSMITTING);
signal state : STATE_TYPE := IDLE;

component uart_tx is
generic (
c_clkfreq		: integer := 100_000_000;
c_baudrate		: integer := 115_200;
c_stopbit		: integer := 2
);
port (
clk				: in std_logic;
din_i			: in std_logic_vector (7 downto 0);
tx_start_i		: in std_logic;
tx_o			: out std_logic;
tx_done_tick_o	: out std_logic
);
end component;


signal startFlag : std_logic := '0';
signal xFerCplt  : std_logic := '0'; 
signal newDataAvailable : std_logic := '0';
begin




my_uart_tx : uart_tx
generic map(
c_clkfreq		=> 27_000_000,
c_baudrate		=> 115_200,
c_stopbit		=> 1
)
port map(
clk				=> clk,
din_i			=> sendDataReg,
tx_start_i		=> startFlag,
tx_o			=> tx_o,
tx_done_tick_o	=> xFerCplt
);
    
process (clk) begin
if(rising_edge(clk)) then
case state is 

	when IDLE =>
		if (controlReg(0) = '1' and newDataAvailable = '1') then
			startFlag <= '1';
			statusReg(1) <= '1';
			state <= TRANSMITTING;
		end if;


	when TRANSMITTING =>
		if(xFerCplt = '1') then
			statusReg(0) <= '1';
			startFlag <= '0';
			statusReg(1) <= '0';
			state <= IDLE;
		end if;
		startFlag <= '0';
	when others =>
end case;	

end if;
end process;



Register_Process : process (clk, addr, din, w_en) is

begin
if(rising_edge(clk)) then
newDataAvailable <= '0';
	if(w_en = '1') then 
 
		case addr is
		
		when x"00" => 
			controlReg <= din;
		
		
		when x"08" =>
			if(statusReg(1) /= '1') then
				sendDataReg <= din;
				newDataAvailable <= '1';
			end if;
		
		when others => 
			
		end case;
    end if;
		
end if;
end process;
Register_Read_Process : process (addr) is

begin
		case addr is
		
		when x"00" => 
			outdata <= controlReg;
		
		when x"04" =>
			outdata <= statusReg;
			
		when x"08" =>
			outdata <=  sendDataReg;
		
		when others => 
		end case;
		
end process;




end Behavioral;