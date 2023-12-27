library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity latch is
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
end latch;

architecture Behavioral of latch is

signal sendDataReg   : std_logic_vector(7 downto 0) := "00000000";
signal statusReg 	 : std_logic_vector(7 downto 0) := "00000000";
signal controlReg    : std_logic_vector(7 downto 0) := "00000000";

type STATE_TYPE is (IDLE,TRANSMITTING);
signal state : STATE_TYPE := IDLE;
signal startFlag : std_logic := '0';
signal xFerCplt  : std_logic := '0'; 
signal newDataAvailable : std_logic := '0';


begin
Register_Read_Process : process (addr,controlReg,statusReg,sendDataReg) is

begin
		case addr is
		
		when x"01" => 
			outdata <= controlReg;
		
		when x"02" =>
			outdata <= statusReg;
			
		when x"13" =>
			outdata <=  sendDataReg;
		
		when others => 
            --outdata <=  "00000000";
		end case;
		
end process;

--outdata <= ramArray(to_integer(unsigned(addr(5 downto 0) ) ) );
end Behavioral;