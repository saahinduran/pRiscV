library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity sign_extender is
	port(
			 --INPUTS:
			ImmSrc       :in std_logic_vector(2 downto 0);
			ImmIn	     :in std_logic_vector(31 downto 7);

			 --OUTPUTS:
			ImmOut   	 :out std_logic_vector(31 downto 0) := "00000000000000000000000000000000"

	);
end sign_extender;


architecture signextend of sign_extender is 


begin




process (ImmSrc,ImmIn) 	is begin

case ImmSrc is

	when "000" => --"000" LUI_TYPE, AUIPC_TYPE
		ImmOut <= ImmIn(31 downto 12) & "000000000000";
	
	when "001" => --"001" JAL_TYPE 
		ImmOut(31 downto 20) <= (others => ImmIn(31) );
		ImmOut(19 downto 12) <= ImmIn(19 downto 12);
		ImmOut(11) <= ImmIn(20);	
		ImmOut(10 downto 1) <= 	ImmIn(30 downto 21);
		ImmOut(0) <= '0';	
		
	when "010" => -- "010" JALR_TYPE, LOAD_TYPE, I_TYPE
		ImmOut(31 downto 11) <= (others => ImmIn(31) );
		ImmOut(10 downto 0) <= ImmIn(30 downto 20);
	
	when "011" => -- "011" B_TYPE 
		ImmOut(31 downto 12) <= (others => ImmIn(31) );
		ImmOut(11) <= ImmIn(7);
		ImmOut(10 downto 5) <= ImmIn(30 downto 25);
		ImmOut(4 downto 1) <= ImmIn(11 downto 8);	
		ImmOut(0) <= '0';	
		
	when "100" => -- "100" STORE_TYPE
		ImmOut(31 downto 11) <= (others => ImmIn(31) );
		ImmOut(10 downto 5) <= ImmIn(30 downto 25);
		ImmOut(4 downto 0) <= ImmIn(11 downto 7);

	when "101" => -- "100" I_TYPE SLLI,SRLI,SRAI
		ImmOut(31 downto 5) <= (others => '0');	
		ImmOut(4 downto 0) <= ImmIn(24 downto 20);
				
		
	when others =>
		ImmOut <= "00000000000000000000000000000000";

end case;
end process;

end signextend; 