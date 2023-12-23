library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;



entity SignExtendtestbench is 


end SignExtendtestbench;


architecture tbsignextend of testbench is 

component sign_extender is
	port(
			 --INPUTS:
			ImmSrc       :in std_logic_vector(2 downto 0);
			ImmIn	     :in std_logic_vector(31 downto 7);

			 --OUTPUTS:
			ImmOut   	 :out std_logic_vector(31 downto 0)

	);
end component;

signal ImmSrc       : std_logic_vector(2 downto 0);
signal ImmIn	    : std_logic_vector(31 downto 7);
signal ImmOut   	: std_logic_vector(31 downto 0);
signal instruction  : std_logic_vector(31 downto 0);


begin

mySign_extender : sign_extender 
port map
(
ImmSrc  => ImmSrc  ,          
ImmIn	=> ImmIn   ,        
ImmOut  => ImmOut   	 	
);
		
ImmIn <= 	instruction(31 downto 7);

process	is begin

wait for 5 ns;
instruction <= x"0007a783";
ImmSrc <= "010";
wait for 5 ns;

wait for 5 ns;
instruction <= x"00112623";
ImmSrc <= "100";
wait for 5 ns;

wait for 5 ns;
instruction <= x"01010413";
ImmSrc <= "010";
wait for 5 ns;

wait for 5 ns;
instruction <= x"84078513";
ImmSrc <= "010";
wait for 5 ns;

wait for 5 ns;
instruction <= x"fefff797";
ImmSrc <= "000";
wait for 5 ns;


wait for 5 ns;
instruction <= x"9dcff0ef";
ImmSrc <= "001";
wait for 5 ns;

wait for 5 ns;
instruction <= x"00f71c63";
ImmSrc <= "011";
wait for 5 ns;

wait for 5 ns;
instruction <= x"84078513";
ImmSrc <= "010";
wait for 5 ns;

wait for 5 ns;
instruction <= x"00e7a023";
ImmSrc <= "100";
wait for 5 ns;




wait;
end process;

end tbsignextend; 