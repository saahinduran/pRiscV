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
			ReadData	: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000"
	);
end data_memory;

architecture data_mem of data_memory is


type RAM_ARRAY is array (0 to 4096 ) of std_logic_vector (31 downto 0);   ---TODO:Reduce here !!!!
signal ramArray :RAM_ARRAY := (others => "00000000000000000000000000000000");


begin

RAM_PROCESS : process(Clk) is 

begin
if(rising_edge(Clk)) then
	
	
	
    if(WriteEn = '1') then 
		ramArray(to_integer(unsigned(Address))) <= DataIn;
        ReadData <= DataIn;
    else
		ReadData <= ramArray(to_integer(unsigned(Address)));

    end if;
	
end if;

end process;
--ReadData <= ramArray(to_integer(unsigned(Address)));
end data_mem;

