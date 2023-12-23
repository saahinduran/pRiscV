library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity register_file is
	port(
			 --INPUTS:
			Clk			: in std_logic;
			Rs1Sel		: in std_logic_vector(4 downto 0);	
			Rs2Sel		: in std_logic_vector(4 downto 0);	
			RdSel		: in std_logic_vector(4 downto 0);	
			DataIn		: in std_logic_vector(31 downto 0);
			WriteEn		: in std_logic;
			 --OUTPUTS:
			Rs1Out		: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
			Rs2Out		: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000"
	);
end register_file;

architecture reg of register_file is


type REG_ARRAY is array (0 to 31 ) of std_logic_vector (31 downto 0);
signal registerFile :REG_ARRAY := (x"00000000",x"12345678",others => "00000000000000000000000000000000");


begin

REGISTER_PROCESS : process(Clk) is 

begin
if(rising_edge(Clk)) then

	
    if(WriteEn = '1') then 
	
		if(RdSel /= "00000") then
		registerFile( to_integer(unsigned(RdSel))  ) <= DataIn ;
		end if;
		

		
		
    end if;
	
end if;

end process;

Rs1Out <= registerFile(to_integer(unsigned(Rs1Sel)));
Rs2Out <= registerFile(to_integer(unsigned(Rs2Sel)));


end reg;


--		if(RdSel = Rs1Sel and RdSel /= "00000") then 
--			Rs1Out <= DataIn;
--		end if;
		
--		if(RdSel = Rs2Sel and RdSel /= "00000") then 
--			Rs2Out <= DataIn;
--		end if;