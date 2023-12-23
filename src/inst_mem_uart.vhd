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


type INST_ARRAY is array (0 to 8192 ) of std_logic_vector (31 downto 0);
signal instMem :INST_ARRAY :=(x"00000000",

x"10000193",
x"10400213",
x"10800293",
x"00100113",
x"0021a023",
x"04800f93",
x"0a00086f",
x"0880086f",
x"06500f93",
x"0940086f",
x"07c0086f",
x"06c00f93",
x"0880086f",
x"0700086f",
x"06c00f93",
x"07c0086f",
x"0640086f",
x"06f00f93",
x"0700086f",
x"0580086f",
x"02000f93",
x"0640086f",
x"04c0086f",
x"07700f93",
x"0580086f",
x"0400086f",
x"06f00f93",
x"04c0086f",
x"0340086f",
x"07200f93",
x"0400086f",
x"0280086f",
x"06c00f93",
x"0340086f",
x"01c0086f",
x"06400f93",
x"0280086f",
x"0100086f",
x"02100f93",
x"01c0086f",
x"0040086f",
x"00022083",
x"0020f093",
x"fe009ce3",
x"00080067",
x"00000063",
x"01f2a023",
x"00080067",





-- these instructions alias to uart_tx_test.s




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