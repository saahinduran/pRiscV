library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity instruction_memory is
	port(
			 --INPUTS: --program counter must be wired to this port !
			AddrIn		: in std_logic_vector(11 downto 0);
			RomReadAddr : in std_logic_vector(11 downto 0);

			 --OUTPUTS:
			InstOut		: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
			RomReadData : out std_logic_vector(31 downto 0) := x"DEADBEEF"

	);
end instruction_memory;

architecture inst_mem of instruction_memory is


type INST_ARRAY is array (0 to 256 ) of std_logic_vector (31 downto 0);
signal instMem :INST_ARRAY :=(x"00000000",


x"04000113",
x"04000113",
x"00000013",
x"fe010113",
x"00812e23",
x"02010413",
x"29000793",
x"fef42623",
x"10000793",
x"00100713",
x"00e7a023",
x"0580006f",
x"10800793",
x"fec42703",
x"00e7a023",
x"fec42783",
x"00178793",
x"fef42623",
x"10400793",
x"0007a783",
x"fef42423",
x"fe842783",
x"0017d793",
x"0017f793",
x"fef42423",
x"00000013",
x"fe842783",
x"fc079ee3",
x"00100793",
x"fef42223",
x"fe442783",
x"00178793",
x"fef42023",
x"fec42783",
x"0007c783",
x"00000013",x"00000013",x"00000013",x"00000013",x"00000013",x"00000013",x"00000013",x"00000013",x"00000013",x"00000013",x"00000013",x"00000013",x"00000013",
x"fa0792e3",
x"0000006f",
x"6c6c6548",
x"6f77206f",
x"0a646c72",
x"00000000",





others => "00000000000000000000000000000000");


begin

process(AddrIn,instMem) is begin 
	if(to_integer(unsigned(AddrIn)) mod 4 = 0) then
		InstOut <= instMem(to_integer(unsigned(AddrIn)) / 4);
	else
		InstOut <= x"FFFFFFFF";
	end if;


end process;

RomReadData <= instMem(to_integer(unsigned(RomReadAddr(5 downto 0) ) ) / 4);
end inst_mem;