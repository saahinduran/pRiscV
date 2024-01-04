library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity instruction_memory is
	port(
			 --INPUTS: --program counter must be wired to this port !
			AddrIn		: in std_logic_vector(11 downto 0);
			RomReadAddr : in std_logic_vector(11 downto 0);
			ByteEn 		: in std_logic_vector(1 downto 0);

			 --OUTPUTS:
			InstOut		: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
			RomReadData : out std_logic_vector(31 downto 0) := x"DEADBEEF"

	);
end instruction_memory;

architecture inst_mem of instruction_memory is

signal byteAlignedAddr : integer range 0 to 1024 := 0;
type INST_ARRAY is array (0 to 1024 ) of std_logic_vector (31 downto 0);
signal instMem :INST_ARRAY :=(x"00000000",

x"04000113",
x"00000013",
x"fe010113",
x"00812e23",
x"02010413",
x"27800793",
x"fef42623",
x"10000793",
x"00100713",
x"00e7a023",
x"0400006f",
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
x"fe842783",
x"fe0790e3",
x"fec42783",
x"0007c783",
x"fa079ee3",
x"0000006f",
x"6c6c6548",
x"6f77206f",
x"0a646c72",
x"00000000",



others => "00000000000000000000000000000000");


begin
instMem(7) <= x"DEADBEEF"; 
byteAlignedAddr <= to_integer(unsigned(RomReadAddr(5 downto 0) ) ) / 4;

process(AddrIn,instMem) is begin 
	if(to_integer(unsigned(AddrIn)) mod 4 = 0) then
		InstOut <= instMem(to_integer(unsigned(AddrIn)) / 4);
	else
		InstOut <= x"FFFFFFFF";
	end if;


end process;

ROM_READ_PROCESS: process (RomReadAddr) is begin

	case to_integer(unsigned(RomReadAddr(5 downto 0) ) ) mod 4 is
	
		when 0 =>
			if(ByteEn = "00") then
				RomReadData <= (31 downto 8 => '0') & instMem(byteAlignedAddr)(7 downto 0);
			elsif(ByteEn = "01" ) then
				RomReadData <= (31 downto 16 => '0') & instMem(byteAlignedAddr)(15 downto 0);
			else
				RomReadData <= instMem(byteAlignedAddr);
			end if;
		when 1 =>
			if(ByteEn = "00") then
				RomReadData <= (31 downto 8 => '0') & instMem(byteAlignedAddr)(15 downto 8);
			elsif(ByteEn = "01" ) then
				RomReadData <= (31 downto 16 => '0') & instMem(byteAlignedAddr)(23 downto 8);
			else
				RomReadData <= instMem(byteAlignedAddr)(31 downto 8) & instMem(byteAlignedAddr + 1)(7 downto 0);
			end if;		
		
		
		when 2 =>
			if(ByteEn = "00") then
				RomReadData <= (31 downto 8 => '0') & instMem(byteAlignedAddr)(23 downto 16);
			elsif(ByteEn = "01" ) then
				RomReadData <= (31 downto 16 => '0') & instMem(byteAlignedAddr)(31 downto 16);
			else
				RomReadData <= instMem(byteAlignedAddr)(31 downto 16) & instMem(byteAlignedAddr + 1)(15 downto 0);
			end if;
		when 3 =>
			if(ByteEn = "00") then
				RomReadData <= (31 downto 8 => '0') & instMem(byteAlignedAddr)(31 downto 24);
			elsif(ByteEn = "01" ) then
				RomReadData <= (31 downto 16 => '0') & instMem(byteAlignedAddr)(15 downto 0);
			else
				RomReadData <= instMem(byteAlignedAddr)(31 downto 24) & instMem(byteAlignedAddr + 1)(23 downto 0);
			end if;
		
		when others =>
			RomReadData <= x"DEADBEEF";


    end case;
	
end process;

--RomReadData <= (31 downto 8 => '0') & instMem(byteAlignedAddr)(7 downto 0) when to_integer(unsigned(RomReadAddr(5 downto 0) ) ) mod 4 = 0 else
--			   (31 downto 8 => '0') & instMem(byteAlignedAddr)(15 downto 8) when to_integer(unsigned(RomReadAddr(5 downto 0) ) ) mod 4 = 1 else
--			   (31 downto 8 => '0') & instMem(byteAlignedAddr)(23 downto 16) when to_integer(unsigned(RomReadAddr(5 downto 0) ) ) mod 4 = 2 else
--			   (31 downto 8 => '0') & instMem(byteAlignedAddr)(31 downto 24) when to_integer(unsigned(RomReadAddr(5 downto 0) ) ) mod 4 = 3 else
--				x"DEADBEEF";
end inst_mem;