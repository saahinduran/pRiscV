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
signal instMem :INST_ARRAY :=(x"00000000",x"7A9FF0B7", x"7A9FF117",x"2BC0E093",
x"0010_2023",x"0000_0103",x"00001183",x"00004203",x"00005283",
x"0010_00A3",
x"0010_1123",
x"0010_21A3",
x"FFFFF0B7",
x"FFF0E093",
x"0010_2223",



--x"00411113",x"00415113",x"40415113",x"00209463",x"00500093",x"00208463",x"0020C463",
x"0020D463",
--x"00000000",
x"003220B3", -- slt x1,x4,x3
x"0041A0B3", -- slt x1,x3,x4
x"0BD22093", -- slti x1,x4,189
x"0BC22093", -- slti x1,x4,188

x"003230B3", -- sltu x1,x4,x3
x"0041B0B3", -- sltu x1,x3,x4
x"0BD23093", -- sltiu x1,x4,189
x"0BC23093", -- sltiu x1,x4,188

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