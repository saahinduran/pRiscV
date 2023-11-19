library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity ALU is

    port (
    Rs1, Rs2   : in  std_logic_vector (31 downto 0) := "00000000000000000000000000000000";  
    AluControl : in  std_logic_vector (2 downto 0) := "000";  
    AluOut     : out std_logic_vector (31 downto 0) := "00000000000000000000000000000000"; 
    N,Z,C,V    : out std_logic       := '0'
    );
end ALU; 


architecture alu of ALU is


constant ADD  : std_logic_vector(2 downto 0) := "000";
constant SUB  : std_logic_vector(2 downto 0) := "001";
constant SLLL : std_logic_vector(2 downto 0) := "101";
constant SRLL : std_logic_vector(2 downto 0) := "110";
constant SRAA : std_logic_vector(2 downto 0) := "111";
constant ANDD : std_logic_vector(2 downto 0) := "100";
constant ORR  : std_logic_vector(2 downto 0) := "011";
constant XORR : std_logic_vector(2 downto 0) := "010";


signal aluResult : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
signal aluTemp: std_logic_vector (32 downto 0) := "000000000000000000000000000000000";
signal sumOverFlow, subOverFlow :std_logic := '0';


begin
ALU_PROCESS: process(Rs1,Rs2,AluControl) is begin

case(AluControl) is
	when "000" => -- Addition
		aluResult <= Rs1 + Rs2 ; 

	when "001" => -- Subtraction
		aluResult <= Rs1 - Rs2 ; 

	when "101" => -- SLL
		aluResult <= std_logic_vector(shift_left(unsigned(Rs1), to_integer(unsigned(Rs2))));

	when "110" => -- SRL
		aluResult <= std_logic_vector(shift_right(unsigned(Rs1), to_integer(unsigned(Rs2))));
		
	when "111" => -- SRA
		aluResult <= std_logic_vector(shift_right(signed(Rs1), to_integer(unsigned(Rs2))));
		

	when "100" => -- AND
		aluResult <= Rs1 and Rs2;

	when "011" => -- OR
		aluResult <= Rs1 or Rs2;

	when "010" => -- XOR
		aluResult <= Rs1 xor Rs2;
  
  
    when others => aluResult <= Rs1 + Rs2;
	
end case;
end process;
 
 
 AluOut <= aluResult; -- ALU out
 aluTemp <= ('0' & Rs1) + ('0' & Rs2);
 
 C <= aluTemp(32); -- Carryout flag
 
 --V:
sumOverFlow <= (not(Rs1(31)) and not(Rs2(31)) and aluResult(31)) or (Rs1(31) and Rs2(31) and not(aluResult(31)));
subOverFlow <= (not(Rs1(31)) and Rs2(31) and aluResult(31)) or (Rs1(31) and not(Rs2(31)) and not(aluResult(31)));


 V  <= sumOverFlow when (AluControl = "000") else
	   subOverFlow when (AluControl = "001") else 
	   '0';
 
 
 N  <= aluResult(31);
 
 Z	<= '1' when (aluResult = "00000000000000000000000000000000") else 
	   '0';
 
end alu;