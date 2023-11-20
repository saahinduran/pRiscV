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

x"20800193" ,
x"20900213" ,
x"20a00293" ,
x"03100093" ,
x"00100113" ,
x"00200f93" ,
x"0021a023" ,
x"00122023" ,
x"0001a023" ,
x"0002a303" ,
x"fe231ee3" ,
x"00230263" ,
x"00108093",
x"00122023",
x"0021a023",
x"0001a023",
x"fe5ff06f",
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