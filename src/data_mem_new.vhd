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
			ByteEnable  : in std_logic_vector(1 downto 0);
			 --OUTPUTS:
			ReadData	: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000"
			
			
	);
end data_memory;

architecture data_mem of data_memory is



type RAM_ARRAY is array (0 to 255 ) of std_logic_vector (7 downto 0);   ---TODO:Reduce here !!!!
signal ramArray :RAM_ARRAY := (others => "00000000");


begin

RAM_PROCESS : process(Clk) is 

begin
if(rising_edge(Clk)) then

    if(WriteEn = '1') then 
        if(ByteEnable = "00") then
		ramArray(to_integer(unsigned(Address(7 downto 0) ) ) ) <= DataIn(7 downto 0);
     
        elsif (ByteEnable = "01") then
        ramArray(to_integer(unsigned(Address(7 downto 0) ) ) ) <= DataIn(15 downto 0);
        else
        ramArray(to_integer(unsigned(Address(7 downto 0) ) ) ) <= DataIn;
        end if;
    end if;
	
end if;
end process;



ReadData <= (31 downto 8 => '0') & ramArray(to_integer(unsigned(Address(7 downto 0) ) ) ) when ByteEnable = "00" else
			(31 downto 16 => '0') & ramArray(to_integer(unsigned(Address(7 downto 0) + 1) ) ) when ByteEnable = "01" else
			ramArray(to_integer(unsigned(Address(7 downto 0) ) ) ) & ramArray(to_integer(unsigned(Address(7 downto 0) + 1) ) )
			& ramArray(to_integer(unsigned(Address(7 downto 0) + 2) ) ) & ramArray(to_integer(unsigned(Address(7 downto 0) + 3) ) ) when ByteEnable = "10"  else
			x"DEADBEEF";

end data_mem;

