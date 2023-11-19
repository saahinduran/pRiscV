


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
signal instMem :INST_ARRAY := (x"00000000",x"00500093", x"00102023", x"00002103",x"40110133",x"00110133",
x"00111133",x"00114133",x"00115133",x"40115133",x"00208113",x"0020F133",x"40208133",x"0010E133",
x"00411113",x"00415113",x"40415113",x"00209463",x"00500093",x"00208463",x"0020C463",
x"0020D463",x"00000000",
--x"00400167",
x"FA9FF16F",



others => "00000000000000000000000000000000");
-- addi x1,x0,5
-- sw   x1,(0)x0
-- add  x2,x1,x2 (might be x0, not sure?) 
-- sub  x1,x2,x1
-- lw   x1,(0)x0
-- sll  x2,x2,x1
-- xor  x2,x2,x1 
-- srl  x2,x2,x1
-- sra  x2,x2,x1
-- addi x2,x1,2
-- and  x2,x1,x2
-- sub  x2,x1,x2
-- or   x2,x1,x1
-- slli x2,x2,4
-- srli x2,x2,4
-- srai x2,x2,4
-- bne  x1,x2,8
-- sw   x1,(0)x0
-- beq  x1,x2,8
-- blt  x1,x2,8
-- bgt  x1,x2,8
-- jalr x2,x0,4 (commented)
-- jal  x0,-0x60



begin

process(AddrIn,instMem) is begin
	if(to_integer(unsigned(AddrIn)) mod 4 = 0) then
		InstOut <= instMem(to_integer(unsigned(AddrIn)) / 4);
	else
		InstOut <= x"FFFFFFFF";
	end if;


end process;


end inst_mem;