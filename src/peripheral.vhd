library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity peripherals is

port(
	Clk			: in std_logic;
	Address		: in std_logic_vector(31 downto 0):= x"00000000";	
	DataIn		: in std_logic_vector(31 downto 0);
	WriteEn		: in std_logic;
	AddrIn		: in std_logic_vector(31 downto 0); -- PC ADDRESS / ROM ADDRESS 
    ByteEn      : in std_logic_vector(1 downto 0);


	 --OUTPUTS:
	ReadData	: out std_logic_vector(31 downto 0) :=x"DEADBEEF";
	InstOut		: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	UART_TX		: out std_logic:= '1'
);

end peripherals;


architecture perip of peripherals is 


signal uartReadDataInterim : std_logic_vector(31  downto 0);
signal uartAddressInterim  : std_logic_vector(31 downto 0);
signal readDataInterim 	   : std_logic_vector(31 downto 0);

signal RomReadData 		   : std_logic_vector(31 downto 0) := x"DEADBEEF";


signal RomReadAddrInterim 		    : std_logic_vector(31 downto 0):= x"00000000";
signal RamReadAddr		   			: std_logic_vector(31 downto 0):= x"00000000";
signal AddressInteger				: integer;
signal ReadDataX 					: std_logic_vector(31 downto 0):= x"00000000";
signal ramWriteEn 					: std_logic := '0';

component UART_TOP is
generic (
c_clkfreq		: integer := 27_000_000;
c_baudrate		: integer := 115_200
);
port (
clk				: in std_logic;
addr 			: in std_logic_vector(31 downto 0); 
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
			Address		: in std_logic_vector(31 downto 0);
			DataIn		: in std_logic_vector(31 downto 0);
			WriteEn		: in std_logic;
            ByteEn 		: in std_logic_vector(1 downto 0);
			 --OUTPUTS:
			ReadData	: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000"
			
			
	);

end component;

component instruction_memory is
	port(
			 --INPUTS: --program counter must be wired to this port !
			AddrIn		: in std_logic_vector(31 downto 0);
			RomReadAddr : in std_logic_vector(31 downto 0);
			ByteEn 		: in std_logic_vector(1 downto 0);

			 --OUTPUTS:
			InstOut		: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
			RomReadData : out std_logic_vector(31 downto 0) := x"FFFFFFFF"

	);
end component;

begin

myUart : UART_TOP
port map(
clk				=> Clk,
addr 			=> uartAddressInterim ,
din 			=> DataIn(7 downto 0),
w_en			=> WriteEn,
outdata			=> uartReadDataInterim(7 downto 0),
tx_o 			=> UART_TX
);


myRamMemory : data_memory
port map(
Clk			=> Clk,
Address		=> RamReadAddr,
DataIn		=> DataIn,
WriteEn		=> ramWriteEn,
ByteEn      => ByteEn,
ReadData	=> readDataInterim
);

myInstructionMemory : instruction_memory

port map(

AddrIn		=> AddrIn,
RomReadAddr => RomReadAddrInterim,
RomReadData => RomReadData,
ByteEn     => ByteEn,


 --OUTPUTS:
InstOut		=> InstOut
);


--READ_SELECTION_PROCESS : process (Address) is
--
--begin
--	if (Address >= x"0000_0000") and (Address <= x"0000_0040") then
--		ReadData <= readDataInterim;
--
--	elsif (Address >= x"0000_0100") and (Address <= x"0000_0108") then
--		ReadData <= (31 downto 12 => '0') & "0000" & uartReadDataInterim(7 downto 0);	
--		
--	elsif (Address >= x"0000_0200") and (Address <= x"0000_0300") then
--		ReadData <= RomReadData;
--		
--	else
--		ReadData <= x"DEADC0ab";
--	end if;
--
--end process;

ReadData <= readDataInterim when (Address <= x"0000_0040") and (Address >= x"0000_0000") else
		   (31 downto 12 => '0') & "0000" & uartReadDataInterim(7 downto 0) when (Address >= x"0000_0100") and (Address <= x"0000_0108") else
			RomReadData when (Address >= x"0000_0200") and (Address <= x"0000_0300") else
			x"DEADC0ab";



SWITCH_PROCESS : process (Address) is
begin
	if( Address < x"0000_0100" and WriteEn = '1') then 
		ramWriteEn <= '1';
	else
		ramWriteEn <= '0';
	end if;

end process;


			
BASE_ADDRESS_PROCESS : process(Address) is
begin

	if ( Address(31 downto 9) = (22 downto 1 =>'0') & '1' )   then  
		RomReadAddrInterim <= (31 downto 9 => '0') & Address(8 downto 0);
		--RomReadAddrInterim <= Address;
	else
		RomReadAddrInterim <= x"00000000";
	end if;

	if( Address(31 downto 8) = (23 downto 1 =>'0')  ) then
		RamReadAddr <= (31 downto 7 => '0') & Address(6 downto 0);
		--RamReadAddr <= Address;
	else
		RamReadAddr <= x"00000000";
	end if;
		
	if( Address(31 downto 8) = (23 downto 1 =>'0') & '1' ) then
		uartAddressInterim <= (31 downto 12 => '0') & Address(11 downto 0);
		--uartAddressInterim <=  Address;
	else
		uartAddressInterim <=  x"00000000";
	end if;	



end process;		
	

end architecture;