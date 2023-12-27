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
			ByteEn 		: in std_logic_vector(1 downto 0);
			 --OUTPUTS:
			ReadData	: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000"
			
			
	);
end data_memory;

architecture data_mem of data_memory is



type RAM_ARRAY is array (0 to 128 ) of std_logic_vector (7 downto 0);   ---TODO:Reduce here !!!!
signal ramArray :RAM_ARRAY := (others => "00000000");
signal readDataInterim : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal readDataResult : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal writeData : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal ramAligned : integer range 0 to 63 := 0;


begin

ramAligned <= to_integer(unsigned(Address(5 downto 0) ) ) ;

writeData <= readDataInterim(31 downto 8) & DataIn(7 downto 0) ;



RAM_PROCESS : process(Clk) is 

begin
if(rising_edge(Clk)) then

    if(WriteEn = '1') then 
		if(ByteEn = "00") then
			ramArray(ramAligned) <= DataIn(7 downto 0);
		elsif (ByteEn = "01") then
			ramArray(ramAligned) <= DataIn(7 downto 0);
			ramArray(ramAligned +1) <= DataIn(15 downto 8);
		elsif (ByteEn = "10") then
			ramArray(ramAligned) <= DataIn(7 downto 0);
            ramArray(ramAligned +1) <= DataIn(15 downto 8);
			ramArray(ramAligned +2) <= DataIn(23 downto 16);
			ramArray(ramAligned +3) <= DataIn(31 downto 24);
		else
			ramArray(ramAligned) <= x"ff";
		end if;
		
    end if;
	
end if;
end process;

READ_PROCESS : process(Address, ByteEn, ramArray) is

begin
	if(ByteEn = "00") then
		ReadData <= (31 downto 8 => '0') & ramArray(to_integer(unsigned(Address(5 downto 0) ) ));
	elsif (ByteEn = "01") then
		ReadData <= (31 downto 16 => '0') & ramArray(to_integer(unsigned(Address(5 downto 0) ) ) +1) & ramArray(to_integer(unsigned(Address(5 downto 0) ) ));
	elsif (ByteEn = "10") then
		ReadData <= ramArray(to_integer(unsigned(Address(5 downto 0) ) ) +3) & ramArray(to_integer(unsigned(Address(5 downto 0) ) ) +2) & ramArray(to_integer(unsigned(Address(5 downto 0) ) ) +1) & ramArray(to_integer(unsigned(Address(5 downto 0) ) ) +0);
	else
		ReadData <= x"DEADC0DE";
	end if;


end process;



end data_mem;

