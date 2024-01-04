library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_memory is
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
end data_memory;

architecture data_mem of data_memory is



type RAM_ARRAY is array (0 to 32 ) of std_logic_vector (31 downto 0);   
signal ramArray :RAM_ARRAY := (others => x"00000000");

signal readDataResult : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal writeData : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal ramAligned : integer  := 0;
signal debugread : std_logic_vector(31 downto 0);
signal WriteEnInterim : std_logic;

begin
WriteEnInterim <= WriteEn;
ramAligned <= to_integer(unsigned(Address ) ) / 4;


RAM_PROCESS : process(Clk, ramAligned, DataIn,WriteEnInterim) is 

begin
if(rising_edge(Clk)) then

  if(WriteEnInterim = '1') then 

			ramArray(ramAligned) <= DataIn;
		
  end if;
	
end if;
end process;


		readDataResult <= ramArray(ramAligned );


		


ReadData <= readDataResult;

end data_mem;

