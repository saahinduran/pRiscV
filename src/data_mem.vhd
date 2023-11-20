library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_memory is
	port(
			 --INPUTS:
			Clk			: in std_logic;
			Address		: in std_logic_vector(11 downto 0);	
			DataIn		: in std_logic_vector(31 downto 0);
			WriteEn		: in std_logic;
			 --OUTPUTS:
			ReadData	: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
			UartTx		: out std_logic := '1';
			LedOut 		: out std_logic_vector(5 downto 0)
			
	);
end data_memory;

architecture data_mem of data_memory is

component UART_TOP is
generic (
c_clkfreq		: integer := 27_000_000;
c_baudrate		: integer := 115_200
);
port (
clk				: in std_logic;
send_data 		: in std_logic_vector(7 downto 0); -- this is DIN register
send_en 		: in std_logic;  --this is the 0.th bit of ctrl register
tx_o			: out std_logic; -- this is tx pin
busy_bit        : out std_logic; -- this the second bit of ctrl register
tx_done	        : out std_logic  -- this is the 1st bit of ctrl register
);
end component;




type RAM_ARRAY is array (0 to 511 ) of std_logic_vector (31 downto 0);   ---TODO:Reduce here !!!!
signal ramArray :RAM_ARRAY := (others => "00000000000000000000000000000000");

type PERIPHERAL_ARRAY is array (0 to 7 ) of std_logic_vector (31 downto 0);
signal GPIOArray :PERIPHERAL_ARRAY := (others => (31 downto 0 => '1') );
signal UartDIN    : std_logic_vector(31 downto 0) := x"00000000";
signal UartCTRL   : std_logic_vector(31 downto 0) := x"00000000";
signal UartStatus : std_logic_vector(31 downto 0) := x"00000000";

begin

myUart : UART_TOP
port map(
clk			=> Clk,
send_data 	=> UartDIN(7 downto 0),
send_en 	=> UartCTRL(0),
tx_o		=> UartTx,
busy_bit    => UartStatus(1),
tx_done	    => UartStatus(0)
);

RAM_PROCESS : process(Clk) is 

begin
if(rising_edge(Clk)) then
	
	
	
    if(WriteEn = '1') then 
		if (Address < x"200")  then
			ramArray(to_integer(unsigned(Address))) <= DataIn;
		
		elsif (Address >= x"200" and Address < x"208") then
			GPIOArray(to_integer(unsigned(Address - x"200"))) <= DataIn;
		elsif (Address = x"208") then
            UartCTRL <= DataIn;
        elsif (Address = x"209") then
            UartDIN <= DataIn;
            
		end if;
    end if;
	
end if;

end process;

READ_PROCESS : process(Address,ramArray,GPIOArray,UartStatus) is begin


if (Address < x"200") then 
	ReadData <= ramArray(to_integer(unsigned(Address)));
	
elsif (Address >= x"200" and Address < x"208") then 
	ReadData <=	GPIOArray(to_integer(unsigned(Address - x"200"))) ;
elsif (Address = x"20a" ) then 
	ReadData <=	UartStatus;
else
    ReadData <= (31 downto 0 => '1');

end if;
end process;
LedOut <= GPIOArray(0)(5 downto 0);
end data_mem;

