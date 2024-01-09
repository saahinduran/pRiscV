library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_memory is
	port(
			 --INPUTS:
			Clk			: in std_logic;
			Address		: in std_logic_vector(31 downto 0);
			DataIn		: in std_logic_vector(31 downto 0);
			WriteEn		: in std_logic;
            ByteEn 		: in std_logic_vector(1 downto 0);
			 --OUTPUTS:
			ReadData	: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000"
			
			
	);
end data_memory;

architecture data_mem of data_memory is



type RAM_ARRAY is array (0 to 31 ) of std_logic_vector (7 downto 0);   
signal ramArray0 :RAM_ARRAY := (others => x"00");
signal ramArray1 :RAM_ARRAY := (others => x"00");
signal ramArray2 :RAM_ARRAY := (others => x"00");
signal ramArray3 :RAM_ARRAY := (others => x"00");

signal readDataResult : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal writeData : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal ramAligned : integer  := 0;
signal debugread : std_logic_vector(31 downto 0);
signal WriteEnInterim : std_logic;
signal ramAlignedAddr : integer range 0 to 32;
signal ramAlignedMod : std_logic_vector(1 downto 0);

begin
WriteEnInterim <= WriteEn;
ramAligned <= to_integer(unsigned(Address ) );
ramAlignedAddr  <= to_integer( unsigned( Address(6 downto 2) ) );  -- ramAlignedAddr = address / 4 
ramAlignedMod <= Address(1 downto 0);   -- ramAlignedMod = address % 4 


RAM_PROCESS : process(Clk) is 

begin
if(rising_edge(Clk)) then

  if(WriteEnInterim = '1') then 

	case ByteEn is
	
	when "00" =>
		case(ramAlignedMod) is
		when "00" =>
		
			ramArray0(ramAlignedAddr) 	<= DataIn(7 downto 0);
		when "01" =>	
			ramArray1(ramAlignedAddr) 	<= DataIn(7 downto 0);
		when "10" =>	
			ramArray2(ramAlignedAddr) 	<= DataIn(7 downto 0);
		when "11" =>	
			ramArray3(ramAlignedAddr) 	<= DataIn(7 downto 0);
		when others =>
			
		end case;
	when "01" =>
		case(ramAlignedMod) is
		when "00" =>
			ramArray0(ramAlignedAddr) 	<= DataIn(7 downto 0);
			ramArray1(ramAlignedAddr) 	<= DataIn(15 downto 8);
		when "01" =>	
			ramArray1(ramAlignedAddr) 	<= DataIn(7 downto 0);
			ramArray2(ramAlignedAddr) 	<= DataIn(15 downto 8);
		when "10" =>	
			ramArray2(ramAlignedAddr) 	<= DataIn(7 downto 0);
			ramArray3(ramAlignedAddr) 	<= DataIn(15 downto 8);
		when "11" => 	
			ramArray3(ramAlignedAddr) 	<= DataIn(7 downto 0);
			ramArray0(ramAlignedAddr+1) <= DataIn(15 downto 8);
		when others =>
		end case;
	when others =>
		case(ramAlignedMod) is
		when "00" =>
			ramArray0(ramAlignedAddr) 	<= DataIn(7 downto 0);
			ramArray1(ramAlignedAddr) 	<= DataIn(15 downto 8);
			ramArray2(ramAlignedAddr) 	<= DataIn(23 downto 16);
			ramArray3(ramAlignedAddr) 	<= DataIn(31 downto 24);
		when "01" =>
		    ramArray1(ramAlignedAddr) 	<= DataIn(7 downto 0);
		    ramArray2(ramAlignedAddr) 	<= DataIn(15 downto 8);
		    ramArray3(ramAlignedAddr) 	<= DataIn(23 downto 16);
			ramArray0(ramAlignedAddr +1)<= DataIn(31 downto 24);
			
		when "10" =>
			ramArray2(ramAlignedAddr) 	<= DataIn(7 downto 0);
		    ramArray3(ramAlignedAddr) 	<= DataIn(15 downto 8);
		    ramArray0(ramAlignedAddr +1)<= DataIn(23 downto 16);
		    ramArray1(ramAlignedAddr +1)<= DataIn(31 downto 24);
		
			
		when "11" => 
			ramArray3(ramAlignedAddr) 	<= DataIn(7 downto 0);
			ramArray0(ramAlignedAddr +1)<= DataIn(15 downto 8);
			ramArray1(ramAlignedAddr +1)<= DataIn(23 downto 16);
			ramArray2(ramAlignedAddr +1)<= DataIn(31 downto 24);
		when others =>
		end case;
		
	end case;	

  end if;
	
end if;
end process;

READ_PROCESS : process(ramAligned, ramAlignedAddr,ByteEn, ramAlignedMod, ramArray0, ramArray1, ramArray2, ramArray3) is 

begin

case ByteEn is
	
	when "00" =>
		case(ramAlignedMod) is
		when "00" =>
		
			readDataResult <= (31 downto 8 => '0') & ramArray0(ramAlignedAddr); 	
		when "01" =>	
			readDataResult <= (31 downto 8 => '0') & ramArray1(ramAlignedAddr); 	
		when "10" =>	
			readDataResult <= (31 downto 8 => '0') & ramArray2(ramAlignedAddr); 	
		when "11" =>	
			readDataResult <= (31 downto 8 => '0') & ramArray3(ramAlignedAddr); 	
		when others =>
			
		end case;
	when "01" =>
		case(ramAlignedMod) is
		when "00" =>
			readDataResult <= (31 downto 16 => '0') & ramArray1(ramAlignedAddr) & ramArray2(ramAlignedAddr); 
		when "01" =>	
			readDataResult <= (31 downto 16 => '0') & ramArray2(ramAlignedAddr) & ramArray1(ramAlignedAddr); 
		when "10" =>	
			readDataResult <= (31 downto 16 => '0') & ramArray3(ramAlignedAddr) & ramArray2(ramAlignedAddr); 
		when "11" => 	
			readDataResult <= (31 downto 16 => '0') & ramArray0(ramAlignedAddr +1) & ramArray3(ramAlignedAddr); 
		when others =>
		end case;
	when others =>
		case(ramAlignedMod) is
		when "00" =>
			readDataResult <= ramArray3(ramAlignedAddr) &ramArray2(ramAlignedAddr)  & ramArray1(ramAlignedAddr) & ramArray0(ramAlignedAddr); 
		when "01" =>
			readDataResult <= ramArray0(ramAlignedAddr+1) &ramArray3(ramAlignedAddr)  & ramArray2(ramAlignedAddr) & ramArray1(ramAlignedAddr);
			
		when "10" =>
			readDataResult <= ramArray1(ramAlignedAddr+1) &ramArray0(ramAlignedAddr+1)  & ramArray2(ramAlignedAddr) & ramArray1(ramAlignedAddr);
		
			
		when "11" => 
			readDataResult <= ramArray2(ramAlignedAddr+1) &ramArray1(ramAlignedAddr+1)  & ramArray0(ramAlignedAddr+1) & ramArray3(ramAlignedAddr);

		when others =>
		end case;
	
end case;
end process;
ReadData <= readDataResult;

end data_mem;

