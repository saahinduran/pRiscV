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
--x"0010_2223",



x"00411113",x"00415113",x"40415113",x"00209463",x"00500093",x"00208463",x"0020C463",
x"0020D463",x"00000000",



others => "00000000000000000000000000000000");
-- lui x1, 0x7A9FF000
-- auipc x2,  0x7A9FF000
-- orri  x1,x1, 700
-- sw    x1,(0)x0
-- lb x2,x0(0)
-- lh x3,x0(0)
-- lbu x4,x0(0)
-- lhu x5,x0(0)
-- sb x1, x0(1)
-- sh x1, x0(2)
-- sw x1, x0(3)
-- lui x1, 0xFFFFF
-- ori x1,x1,4095
-- sw x1, x0(4)

begin

process(AddrIn,instMem) is begin
	if(to_integer(unsigned(AddrIn)) mod 4 = 0) then
		InstOut <= instMem(to_integer(unsigned(AddrIn)) / 4);
	else
		InstOut <= x"FFFFFFFF";
	end if;


end process;


end inst_mem;