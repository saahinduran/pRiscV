library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity instMemTestBench is

generic(
 CLK_PERIOD : TIME :=  10 ns            

); 

end instMemTestBench;

architecture instTestBench of instMemTestBench is


component instruction_memory is
	port(
			 --INPUTS:
			AddrIn		: in std_logic_vector(11 downto 0);

			 --OUTPUTS:
			InstOut		: out std_logic_vector(31 downto 0)

	);
end component;

signal AddrIn		: std_logic_vector(11 downto 0);
signal InstOut		: std_logic_vector(31 downto 0);

begin

My_instruction_memory : instruction_memory
port map
(
AddrIn	=> AddrIn,		
InstOut	=> InstOut		
);


TEST_PROCESS : process is 
begin


for i in 0 to 31 loop
			AddrIn <= std_logic_vector(to_unsigned(i*4, AddrIn'length)); 

			wait for CLK_PERIOD;
        end loop;
        wait;
end process;


end architecture;