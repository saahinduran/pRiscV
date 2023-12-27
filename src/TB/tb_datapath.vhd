library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity datapathTestBench is

end datapathTestBench;


architecture riscVTest of datapathTestBench is 

component datapath is
port(
    clock_in 	: in std_logic := '1';
	rst  		: in std_logic := '1';
    Memout 		: out std_logic_vector(5 downto 0) := "000000";
	uart_tx_o 	: out std_logic := '0'
);
end component;

signal clock_in : std_logic:='0';
signal rst  		:  std_logic := '1';
signal Memout 		:  std_logic_vector(5 downto 0) := "000000";
signal uart_tx_o 	:  std_logic := '0';

begin

cpu : datapath 
port map(
	clock_in   => clock_in     ,
	rst  	   => rst  	       ,
	Memout 	   => Memout 	   ,
	uart_tx_o  => uart_tx_o
	
	
);


Clok_Process: process is begin
clock_in <= '1';
wait for 5 ns;
clock_in <= '0';
wait for 5 ns;

end process;

end riscVTest;