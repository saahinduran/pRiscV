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

x"03F00113",
x"03F14113",
x"00202223", -- sw
x"008010B7", --lui 
x"FFF08093", -- addi
x"FE009EE3", -- bne
x"FF0086E3",
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