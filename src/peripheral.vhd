library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity peripherals is

port(
	Clk			: in std_logic;
	Address		: in std_logic_vector(11 downto 0);	
	DataIn		: in std_logic_vector(31 downto 0);
	WriteEn		: in std_logic;
	 --OUTPUTS:
	ReadData	: out std_logic_vector(31 downto 0);
	UART_TX		: out std_logic:= '1'
);

end peripherals;


architecture perip of peripherals is 


signal uartReadDataInterim : std_logic_vector(11  downto 0);
signal uartAddressInterim  : std_logic_vector(11 downto 0);
signal readDataInterim 	   : std_logic_vector(31 downto 0);

component UART_TOP is
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
end component;


component data_memory is
	port(
			 --INPUTS:
			Clk			: in std_logic;
			Address		: in std_logic_vector(11 downto 0);	
			DataIn		: in std_logic_vector(31 downto 0);
			WriteEn		: in std_logic;
			 --OUTPUTS:
			ReadData	: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000"
			
			
	);
end component;


begin

myUart : UART_TOP
port map(
clk				=> Clk,
addr 			=> uartAddressInterim(7 downto 0),
din 			=> DataIn(7 downto 0),
w_en			=> WriteEn,
outdata			=> uartReadDataInterim(7 downto 0),
tx_o 			=> UART_TX
);


myRamMemory : data_memory
port map(
Clk			=> Clk,
Address		=> Address,
DataIn		=> DataIn,
WriteEn		=> WriteEn,
ReadData	=> readDataInterim
);

ReadData <= (31 downto 12 => '0') & "0000" & uartReadDataInterim(7 downto 0) when Address >= x"100" and Address <=x"108" else
			readDataInterim;
			
			
uartAddressInterim <= Address - x"100"; 



end architecture;