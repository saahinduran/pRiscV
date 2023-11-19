library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity dataTestBench is

generic(
 CLK_PERIOD : TIME :=  10 ns            

); 

end dataTestBench;

architecture dataTest of dataTestBench is

component data_memory is
	port(
			 --INPUTS:
			Clk			: in std_logic;
			Address		: in std_logic_vector(11 downto 0);	
			DataIn		: in std_logic_vector(31 downto 0);
			WriteEn		: in std_logic;
			 --OUTPUTS:
			ReadData	: out std_logic_vector(31 downto 0)
	);
end component;

signal Clk			: std_logic;
signal Address		: std_logic_vector(11 downto 0);
signal DataIn		: std_logic_vector(31 downto 0);
signal WriteEn		: std_logic;
signal ReadData		: std_logic_vector(31 downto 0);


begin

My_data_memory : data_memory
port map
(
Clk			=> Clk		,
Address		=> Address	,
DataIn		=> DataIn	,
WriteEn		=> WriteEn	,
ReadData	=> ReadData
);


TEST_PROCESS : process is 
begin

for i in 0 to 31 loop
			Address <= std_logic_vector(to_unsigned(i, Address'length)); 
			DataIn <= std_logic_vector(to_unsigned((i+1)*10, DataIn'length));
			writeEn <= '1';
			wait for CLK_PERIOD;
        end loop;
writeEn <= '0';        
for i in 0 to 31 loop
            Address <= std_logic_vector(to_unsigned(i, Address'length)); 
            wait for CLK_PERIOD;
        end loop;

wait;
end process;


CLOCK_PROCESS : process is 
begin
clk <= '0';
wait for CLK_PERIOD / 2;

clk <= '1';
wait for CLK_PERIOD / 2;

end process;


end architecture;