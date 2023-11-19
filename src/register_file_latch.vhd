





library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity register_file is
	port(
			 --INPUTS:
			clk			: in std_logic;
			Rs1Sel		: in std_logic_vector(4 downto 0);	
			Rs2Sel		: in std_logic_vector(4 downto 0);	
			RdSel		: in std_logic_vector(4 downto 0);	
			DataIn		: in std_logic_vector(31 downto 0);
			writeEn		: in std_logic;
			 --OUTPUTS:
			Rs1Out		: out std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
			Rs2Out		: out std_logic_vector(31 downto 0):= "00000000000000000000000000000000"
	);
end register_file;

architecture reg of register_file is


type REG_ARRAY is array (0 to 31 ) of std_logic_vector (31 downto 0);
signal RegisterFile :REG_ARRAY := (others => "00000000000000000000000000000000");


begin


RegisterFile(0) <= "00000000000000000000000000000000";
RegisterFile(1) <= DataIn  when RdSel  = "00001" and writeEn = '1';
RegisterFile(2) <= DataIn  when RdSel  = "00010" and writeEn = '1';
RegisterFile(3) <= DataIn  when RdSel   = "00011" and writeEn = '1';
RegisterFile(4) <= DataIn  when RdSel   = "00100" and writeEn = '1';
RegisterFile(5) <= DataIn  when RdSel   = "00101" and writeEn = '1';
RegisterFile(6) <= DataIn  when RdSel   = "00110" and writeEn = '1';
RegisterFile(7) <= DataIn  when RdSel   = "00111" and writeEn = '1';
RegisterFile(8) <= DataIn  when RdSel   = "01000" and writeEn = '1';
RegisterFile(9) <= DataIn  when RdSel   = "01001" and writeEn = '1';
RegisterFile(10) <= DataIn when RdSel  = "01010" and writeEn = '1';
RegisterFile(11) <= DataIn when RdSel  = "01011" and writeEn = '1';
RegisterFile(12) <= DataIn when RdSel  = "01100" and writeEn = '1';
RegisterFile(13) <= DataIn when RdSel  = "01101" and writeEn = '1';
RegisterFile(14) <= DataIn when RdSel  = "01110" and writeEn = '1';
RegisterFile(15) <= DataIn when RdSel  = "01111" and writeEn = '1';
RegisterFile(16) <= DataIn when RdSel  = "10000" and writeEn = '1';
RegisterFile(17) <= DataIn when RdSel  = "10001" and writeEn = '1';
RegisterFile(18) <= DataIn when RdSel  = "10010" and writeEn = '1';
RegisterFile(19) <= DataIn when RdSel  = "10011" and writeEn = '1';
RegisterFile(20) <= DataIn when RdSel  = "10100" and writeEn = '1';
RegisterFile(21) <= DataIn when RdSel  = "10101" and writeEn = '1';
RegisterFile(22) <= DataIn when RdSel  = "10110" and writeEn = '1';
RegisterFile(23) <= DataIn when RdSel  = "10111" and writeEn = '1';
RegisterFile(24) <= DataIn when RdSel  = "11000" and writeEn = '1';
RegisterFile(25) <= DataIn when RdSel  = "11001" and writeEn = '1';
RegisterFile(26) <= DataIn when RdSel  = "11010" and writeEn = '1';
RegisterFile(27) <= DataIn when RdSel  = "11011" and writeEn = '1';
RegisterFile(28) <= DataIn when RdSel  = "11100" and writeEn = '1';
RegisterFile(29) <= DataIn when RdSel  = "11101" and writeEn = '1';
RegisterFile(30) <= DataIn when RdSel  = "11110" and writeEn = '1';
RegisterFile(31) <= DataIn when RdSel  = "11111" and writeEn = '1';




Rs1Out <= RegisterFile(0) when Rs1Sel  = "00000" else
		  RegisterFile(1) when Rs1Sel  = "00001" else
		  RegisterFile(2) when Rs1Sel  = "00010" else
		  RegisterFile(3) when Rs1Sel  = "00011" else
		  RegisterFile(4) when Rs1Sel  = "00100" else
		  RegisterFile(5) when Rs1Sel  = "00101" else
		  RegisterFile(6) when Rs1Sel  = "00110" else
		  RegisterFile(7) when Rs1Sel  = "00111" else
		  RegisterFile(8) when Rs1Sel  = "01000" else
		  RegisterFile(9) when Rs1Sel  = "01001" else
		  RegisterFile(10) when Rs1Sel = "01010" else
		  RegisterFile(11) when Rs1Sel = "01011" else
		  RegisterFile(12) when Rs1Sel = "01100" else
		  RegisterFile(13) when Rs1Sel = "01101" else
		  RegisterFile(14) when Rs1Sel = "01110" else
		  RegisterFile(15) when Rs1Sel = "01111" else
		  RegisterFile(16) when Rs1Sel = "10000" else
		  RegisterFile(17) when Rs1Sel = "10001" else
		  RegisterFile(18) when Rs1Sel = "10010" else
		  RegisterFile(19) when Rs1Sel = "10011" else
		  RegisterFile(20) when Rs1Sel = "10100" else
		  RegisterFile(21) when Rs1Sel = "10101" else
		  RegisterFile(22) when Rs1Sel = "10110" else
		  RegisterFile(23) when Rs1Sel = "10111" else
		  RegisterFile(24) when Rs1Sel = "11000" else
		  RegisterFile(25) when Rs1Sel = "11001" else
		  RegisterFile(26) when Rs1Sel = "11010" else
		  RegisterFile(27) when Rs1Sel = "11011" else
		  RegisterFile(28) when Rs1Sel = "11100" else
		  RegisterFile(29) when Rs1Sel = "11101" else
		  RegisterFile(30) when Rs1Sel = "11110" else
		  RegisterFile(31) when Rs1Sel = "11111" ;


Rs2Out <= RegisterFile(0) when Rs2Sel  = "00000" else
		  RegisterFile(1) when Rs2Sel  = "00001" else
		  RegisterFile(2) when Rs2Sel  = "00010" else
		  RegisterFile(3) when Rs2Sel  = "00011" else
		  RegisterFile(4) when Rs2Sel  = "00100" else
		  RegisterFile(5) when Rs2Sel  = "00101" else
		  RegisterFile(6) when Rs2Sel  = "00110" else
		  RegisterFile(7) when Rs2Sel  = "00111" else
		  RegisterFile(8) when Rs2Sel  = "01000" else
		  RegisterFile(9) when Rs2Sel  = "01001" else
		  RegisterFile(10) when Rs2Sel = "01010" else
		  RegisterFile(11) when Rs2Sel = "01011" else
		  RegisterFile(12) when Rs2Sel = "01100" else
		  RegisterFile(13) when Rs2Sel = "01101" else
		  RegisterFile(14) when Rs2Sel = "01110" else
		  RegisterFile(15) when Rs2Sel = "01111" else
		  RegisterFile(16) when Rs2Sel = "10000" else
		  RegisterFile(17) when Rs2Sel = "10001" else
		  RegisterFile(18) when Rs2Sel = "10010" else
		  RegisterFile(19) when Rs2Sel = "10011" else
		  RegisterFile(20) when Rs2Sel = "10100" else
		  RegisterFile(21) when Rs2Sel = "10101" else
		  RegisterFile(22) when Rs2Sel = "10110" else
		  RegisterFile(23) when Rs2Sel = "10111" else
		  RegisterFile(24) when Rs2Sel = "11000" else
		  RegisterFile(25) when Rs2Sel = "11001" else
		  RegisterFile(26) when Rs2Sel = "11010" else
		  RegisterFile(27) when Rs2Sel = "11011" else
		  RegisterFile(28) when Rs2Sel = "11100" else
		  RegisterFile(29) when Rs2Sel = "11101" else
		  RegisterFile(30) when Rs2Sel = "11110" else
		  RegisterFile(31) when Rs2Sel = "11111" ;
		  


end reg;