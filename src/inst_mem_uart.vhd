library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity instruction_memory is
	port(
			 --INPUTS: --program counter must be wired to this port !
			AddrIn		: in std_logic_vector(31 downto 0);
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
type INST_ARRAY is array (0 to 127 ) of std_logic_vector (7 downto 0);
signal instMem :INST_ARRAY :=(x"13", x"00", x"00", x"00",

x"13", x"00", x"00", x"00", x"93", x"02", x"b0", x"0b", x"23", x"20",
x"50", x"00", x"93", x"01", x"00", x"10", x"13", x"01", x"10", x"00",
x"23", x"a0", x"21", x"00", x"93", x"02", x"80", x"10", x"03", x"22",
x"00", x"00", x"23", x"a0", x"42", x"00", x"63", x"00", x"00", x"00",



others => x"00");


begin


instructionIndex <=  to_integer(unsigned(AddrIn ) ) ;


byteAlignedAddr <=  to_integer(unsigned(RomReadAddr ) ); 


--byteAlignedAddr <= ( (to_integer(unsigned(RomReadAddr ) ) -512 )  );
--readROMInterim <= instMem(byteAlignedAddr +3) & instMem(byteAlignedAddr +2) & instMem(byteAlignedAddr +1) & instMem(byteAlignedAddr );

--process(instructionIndex,instMem) is begin 
--	if(instructionIndex >= 0 and instructionIndex  <= 83) then
		InstOut <= instMem( instructionIndex + 3) & instMem(instructionIndex + 2) & instMem(instructionIndex + 1) & instMem(instructionIndex);
--	else
--		InstOut <= x"FFFFFFFF";
--	end if;


--end process;


ROM_READ_PROCESS: process (RomReadAddr, instMem, ByteEn, byteAlignedAddr) is begin

	if(ByteEn = "00") then
		RomReadData <= (31 downto 8 => '0') & instMem(byteAlignedAddr);
	elsif (ByteEn = "01") then
		RomReadData <= (31 downto 16 => '0') & instMem(byteAlignedAddr +1) & instMem(byteAlignedAddr);
	elsif (ByteEn = "10") then
		RomReadData <= instMem(byteAlignedAddr +3) & instMem(byteAlignedAddr +2) & instMem(byteAlignedAddr +1) & instMem(byteAlignedAddr +0);
	else
		RomReadData <= x"DEADC0DE";
	end if;


--	case to_integer(unsigned(RomReadAddr ) ) mod 4 is
--	
--		when 0 =>
--			if(ByteEn = "00") then
--				RomReadData <= (31 downto 8 => '0') & instMem(byteAlignedAddr)(7 downto 0);
--			elsif(ByteEn = "01" ) then
--				RomReadData <= (31 downto 16 => '0') & instMem(byteAlignedAddr)(15 downto 0);
--			else
--				RomReadData <= instMem(byteAlignedAddr);
--			end if;
--		when 1 =>
--			if(ByteEn = "00") then
--				RomReadData <= (31 downto 8 => '0') & instMem(byteAlignedAddr)(15 downto 8);
--			elsif(ByteEn = "01" ) then
--				RomReadData <= (31 downto 16 => '0') & instMem(byteAlignedAddr)(23 downto 8);
--			else
--				RomReadData <= instMem(byteAlignedAddr)(31 downto 8) & instMem(byteAlignedAddr + 1)(7 downto 0);
--			end if;		
--		
--		
--		when 2 =>
--			if(ByteEn = "00") then
--				RomReadData <= (31 downto 8 => '0') & instMem(byteAlignedAddr)(23 downto 16);
--			elsif(ByteEn = "01" ) then
--				RomReadData <= (31 downto 16 => '0') & instMem(byteAlignedAddr)(31 downto 16);
--			else
--				RomReadData <= instMem(byteAlignedAddr)(31 downto 16) & instMem(byteAlignedAddr + 1)(15 downto 0);
--			end if;
--		when 3 =>
--			if(ByteEn = "00") then
--				RomReadData <= (31 downto 8 => '0') & instMem(byteAlignedAddr)(31 downto 24);
--			elsif(ByteEn = "01" ) then
--				RomReadData <= (31 downto 16 => '0') & instMem(byteAlignedAddr)(15 downto 0);
--			else
--				RomReadData <= instMem(byteAlignedAddr)(31 downto 24) & instMem(byteAlignedAddr + 1)(23 downto 0);
--			end if;
--		
--		when others =>
--			RomReadData <= x"FFFFFFFF";
--
--
--    end case;

end process;

--RomReadData <= (31 downto 8 => '0') & instMem(byteAlignedAddr)(7 downto 0) when to_integer(unsigned(RomReadAddr(5 downto 0) ) ) mod 4 = 0 else
--			   (31 downto 8 => '0') & instMem(byteAlignedAddr)(15 downto 8) when to_integer(unsigned(RomReadAddr(5 downto 0) ) ) mod 4 = 1 else
--			   (31 downto 8 => '0') & instMem(byteAlignedAddr)(23 downto 16) when to_integer(unsigned(RomReadAddr(5 downto 0) ) ) mod 4 = 2 else
--			   (31 downto 8 => '0') & instMem(byteAlignedAddr)(31 downto 24) when to_integer(unsigned(RomReadAddr(5 downto 0) ) ) mod 4 = 3 else
--				x"DEADBEEF";
end inst_mem;