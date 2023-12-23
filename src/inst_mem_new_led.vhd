library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity instruction_memory is
	port(
			 --INPUTS: --program counter must be wired to this port !
			AddrIn		: in std_logic_vector(11 downto 0);

			 --OUTPUTS:
			InstOut		: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000"

	);
end instruction_memory;

architecture inst_mem of instruction_memory is


type INST_ARRAY is array (0 to 1024 ) of std_logic_vector (31 downto 0);
signal instMem :INST_ARRAY :=(x"00000000",

x"20000193", --addi x3,x0,512
x"03F00113", --addi x2,x0,63
x"03F14113", --xori x2,x2,63
x"0021A023", --sw x2,(0)x3 
x"008010B7", --lui x1, 0x7A9FF000
x"FFF08093", --addi x1,x1,-1
x"FE009EE3", --bne x1,x0,-4
x"FF0086E3", --beq x1,x0,-20 
others => "00000000000000000000000000000000");


begin

process(AddrIn,instMem) is begin 
	if(to_integer(unsigned(AddrIn)) mod 4 = 0) then
		InstOut <= instMem(to_integer(unsigned(AddrIn)) / 4);
	else
		InstOut <= x"FFFFFFFF";
	end if;


end process;


end inst_mem;