library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity instruction_memory is
	port(
			 --INPUTS: 
			AddrIn		: in std_logic_vector(31 downto 0); --program counter must be wired to this port !
			RomReadAddr : in std_logic_vector(31 downto 0);
			ByteEn 		: in std_logic_vector(1 downto 0);

			 --OUTPUTS:
			InstOut		: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
			RomReadData : out std_logic_vector(31 downto 0) := x"FFFFFFFF"

	);
end instruction_memory;

architecture inst_mem of instruction_memory is

signal readROMInterim : std_logic_vector(31 downto 0);
signal byteAlignedAddr : integer := 0;
signal instructionIndex : integer := 0;
type INST_ARRAY is array (0 to 1024 ) of std_logic_vector (7 downto 0);
signal instMem :INST_ARRAY :=(x"13", x"00", x"00", x"00",

x"13", x"01", x"00", x"04", x"13", x"00", x"00", x"00", x"13", x"01",
x"01", x"fe", x"23", x"2e", x"81", x"00", x"13", x"04", x"01", x"02",
x"93", x"07", x"c0", x"26", x"23", x"26", x"f4", x"fe", x"93", x"07",
x"00", x"10", x"13", x"07", x"10", x"00", x"23", x"a0", x"e7", x"00",
x"83", x"27", x"c4", x"fe", x"03", x"c7", x"07", x"00", x"93", x"07",
x"80", x"10", x"23", x"a0", x"e7", x"00", x"13", x"00", x"00", x"00",
x"93", x"07", x"40", x"10", x"83", x"a7", x"07", x"00", x"93", x"f7",
x"27", x"00", x"e3", x"9a", x"07", x"fe", x"83", x"27", x"c4", x"fe",
x"93", x"87", x"17", x"00", x"23", x"26", x"f4", x"fe", x"83", x"27",
x"c4", x"fe", x"83", x"c7", x"07", x"00", x"e3", x"94", x"07", x"fc",
x"6f", x"00", x"00", x"00", x"20", x"20", x"20", x"20", x"20", x"20",
x"20", x"20", x"5f", x"5f", x"5f", x"5f", x"20", x"20", x"5f", x"20",
x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20",
x"20", x"20", x"20", x"20", x"20", x"0a", x"20", x"20", x"5f", x"20",
x"5f", x"5f", x"20", x"7c", x"20", x"20", x"5f", x"20", x"5c", x"28",
x"5f", x"29", x"5f", x"5f", x"5f", x"20", x"20", x"5f", x"5f", x"5f",
x"5f", x"5f", x"20", x"20", x"20", x"5f", x"5f", x"0a", x"20", x"7c",
x"20", x"27", x"5f", x"20", x"5c", x"7c", x"20", x"7c", x"5f", x"29",
x"20", x"7c", x"20", x"2f", x"20", x"5f", x"5f", x"7c", x"2f", x"20",
x"5f", x"5f", x"5c", x"20", x"5c", x"20", x"2f", x"20", x"2f", x"0a",
x"20", x"7c", x"20", x"7c", x"5f", x"29", x"20", x"7c", x"20", x"20",
x"5f", x"20", x"3c", x"7c", x"20", x"5c", x"5f", x"5f", x"20", x"5c",
x"20", x"28", x"5f", x"5f", x"20", x"5c", x"20", x"56", x"20", x"2f",
x"20", x"0a", x"20", x"7c", x"20", x"2e", x"5f", x"5f", x"2f", x"7c",
x"5f", x"7c", x"20", x"5c", x"5f", x"5c", x"5f", x"7c", x"5f", x"5f",
x"5f", x"2f", x"5c", x"5f", x"5f", x"5f", x"7c", x"20", x"5c", x"5f",
x"2f", x"20", x"20", x"0a", x"20", x"7c", x"5f", x"7c", x"20", x"20",
x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20",
x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20",
x"20", x"20", x"20", x"20", x"20", x"0a", x"00", x"00", x"00", x"00",










others => x"00");


begin


instructionIndex <=  to_integer(unsigned(AddrIn ) ) ;


byteAlignedAddr <=  to_integer(unsigned(RomReadAddr ) ); 


InstOut <= instMem( instructionIndex + 3) & instMem(instructionIndex + 2) & instMem(instructionIndex + 1) & instMem(instructionIndex);



ROM_READ_PROCESS: process (RomReadAddr, instMem, ByteEn, byteAlignedAddr) is begin

	if(ByteEn = "00") then
		RomReadData <= (31 downto 8 => '0') & instMem(byteAlignedAddr);
	elsif (ByteEn = "01") then
		RomReadData <= (31 downto 16 => '0') & instMem(byteAlignedAddr +1) & instMem(byteAlignedAddr);
	else
		RomReadData <= instMem(byteAlignedAddr +3) & instMem(byteAlignedAddr +2) & instMem(byteAlignedAddr +1) & instMem(byteAlignedAddr +0);
	end if;


end process;


end inst_mem;