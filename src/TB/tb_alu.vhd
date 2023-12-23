library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Alutestbench is


end Alutestbench;

architecture alu of Alutestbench is


component ALU is

    port (
    Rs1, Rs2   : in  std_logic_vector (31 downto 0);  
    AluControl : in  std_logic_vector (2 downto 0);  
    AluOut     : out std_logic_vector (31 downto 0); 
    N,Z,C,V    : out std_logic       
    );
end component; 

signal Rs1, Rs2   :  std_logic_vector (31 downto 0);
signal AluControl :  std_logic_vector (2 downto 0); 
signal AluOut     :  std_logic_vector (31 downto 0);
signal N,Z,C,V    :  std_logic ;  


begin

myAlu : ALU
port map
(
 Rs1, Rs2, AluControl, AluOut, N, Z, C, V   
);


ALU_DRIVER: process is begin


--- ADDITION TEST ---
wait for 10 ns;
Rs1 <= std_logic_vector(to_unsigned(5, Rs1'length));
Rs2 <= std_logic_vector(to_unsigned(10, Rs2'length));
AluControl <= std_logic_vector(to_unsigned(0, AluControl'length));
wait for 10 ns;

Rs1 <= std_logic_vector(to_unsigned(0, Rs1'length));
Rs2 <= std_logic_vector(to_unsigned(0, Rs2'length));
AluControl <= std_logic_vector(to_unsigned(0, AluControl'length));
wait for 10 ns;

Rs1 <= "11111111111111111111111111111111";
Rs2 <= std_logic_vector(to_unsigned(10, Rs2'length));
AluControl <= std_logic_vector(to_unsigned(0, AluControl'length));
wait for 10 ns;

--- SUBTRACTION TEST ---
Rs1 <= std_logic_vector(to_unsigned(10, Rs1'length));
Rs2 <= std_logic_vector(to_unsigned(5, Rs2'length));
AluControl <= std_logic_vector(to_unsigned(1, AluControl'length));
wait for 10 ns;

Rs1 <= std_logic_vector(to_unsigned(5, Rs1'length));
Rs2 <= std_logic_vector(to_unsigned(10, Rs2'length));
AluControl <= std_logic_vector(to_unsigned(1, AluControl'length));
wait for 10 ns;

Rs1 <= std_logic_vector(to_signed(5, Rs1'length));
Rs2 <= std_logic_vector(to_signed(-10, Rs2'length));
AluControl <= std_logic_vector(to_unsigned(1, AluControl'length));
wait for 10 ns;

Rs1 <= "01111111111111111111111111111111";
Rs2 <= std_logic_vector(to_signed(-10, Rs2'length));
AluControl <= std_logic_vector(to_unsigned(1, AluControl'length));
wait for 10 ns;

Rs1 <= "10000000000000000000000000000000";
Rs2 <= std_logic_vector(to_signed(10, Rs2'length));
AluControl <= std_logic_vector(to_unsigned(1, AluControl'length));
wait for 10 ns;

--- SHIFT LEFT LOGICAL TEST ---
Rs1 <= "00000000000000000000000000001010";
Rs2 <= std_logic_vector(to_unsigned(2, Rs2'length));
AluControl <= std_logic_vector(to_unsigned(5, AluControl'length));
wait for 10 ns;

Rs1 <= "00000000000000000000000000001010";
Rs2 <= std_logic_vector(to_unsigned(240420, Rs2'length));
AluControl <= std_logic_vector(to_unsigned(5, AluControl'length));  --"101" -- SLL
wait for 10 ns;

--- SHIFT RIGHT LOGICAL TEST ---
Rs1 <= "10100000000000000000000000001010";
Rs2 <= std_logic_vector(to_unsigned(8, Rs2'length));
AluControl <= std_logic_vector(to_unsigned(6, AluControl'length));   --"110"-- SRL
wait for 10 ns; 

--- SHIFT RIGHT ARITHMETIC TEST ---
Rs1 <= "10100000000000000000000000001010";
Rs2 <= std_logic_vector(to_unsigned(8, Rs2'length));
AluControl <= std_logic_vector(to_unsigned(7, AluControl'length));   --"111"-- SRA
wait for 10 ns; 

--- SHIFT RIGHT ARITHMETIC TEST ---
Rs1 <= "00100000000000000000000000001010";
Rs2 <= std_logic_vector(to_unsigned(8, Rs2'length));
AluControl <= std_logic_vector(to_unsigned(7, AluControl'length));   --"111"-- SRA
wait for 10 ns; 

--- AND  TEST ---
Rs1 <= "00100000000000000000000000001010";
Rs2 <= std_logic_vector(to_unsigned(10, Rs2'length));
AluControl <= std_logic_vector(to_unsigned(4, AluControl'length));   --"100"-- AND
wait for 10 ns; 
	
--- OR TEST ---
Rs1 <= "00100000000000000000000000001010";
Rs2 <= std_logic_vector(to_unsigned(5, Rs2'length));
AluControl <= std_logic_vector(to_unsigned(3, AluControl'length));   --"011" -- OR
wait for 10 ns; 

--- XOR TEST ---
Rs1 <= "00100000000000000000000000001010";
Rs2 <= std_logic_vector(to_unsigned(10, Rs2'length));
AluControl <= std_logic_vector(to_unsigned(2, AluControl'length));   --"010" -- XOR
wait for 10 ns; 


	
	




wait;

end process;


end architecture;