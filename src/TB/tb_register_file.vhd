library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity testbench is

generic(
 CLK_PERIOD : TIME :=  10 ns            

); 

end testbench;

architecture reg of testbench is

component register_file is
	port(
			-- INPUTS:
			clk			: in std_logic;
			Rs1Sel		: in std_logic_vector(4 downto 0);	
			Rs2Sel		: in std_logic_vector(4 downto 0);	
			RdSel		: in std_logic_vector(4 downto 0);	
			DataIn		: in std_logic_vector(31 downto 0);
			writeEn		: in std_logic;
			-- OUTPUTS:
			Rs1Out		: out std_logic_vector(31 downto 0);
			Rs2Out		: out std_logic_vector(31 downto 0)
	);
end component;

signal clk			: std_logic;
signal Rs1Sel		: std_logic_vector(4 downto 0);	
signal Rs2Sel		: std_logic_vector(4 downto 0);	
signal RdSel		: std_logic_vector(4 downto 0);	
signal DataIn		: std_logic_vector(31 downto 0);
signal writeEn		: std_logic;
signal Rs1Out		:  std_logic_vector(31 downto 0);
signal Rs2Out		:  std_logic_vector(31 downto 0);




begin

My_register_file : register_file
port map
(
clk		 => clk		 ,
Rs1Sel	 => Rs1Sel	 ,
Rs2Sel	 => Rs2Sel	 ,
RdSel	 => RdSel	 ,
DataIn	 => DataIn	 ,
writeEn	 => writeEn	 ,
Rs1Out	 => Rs1Out	 ,
Rs2Out	 => Rs2Out	 
);


TEST_PROCESS : process is 
begin
wait for CLK_PERIOD / 2;
Rs1Sel <= std_logic_vector(to_unsigned(0, RdSel'length));
Rs2Sel <= std_logic_vector(to_unsigned(1, RdSel'length));
RdSel <= std_logic_vector(to_unsigned(0, RdSel'length)); 
DataIn <= std_logic_vector(to_unsigned(12345, DataIn'length));
writeEn <= '1';
wait for CLK_PERIOD;

Rs1Sel <= std_logic_vector(to_unsigned(1, RdSel'length));
Rs2Sel <= std_logic_vector(to_unsigned(3, RdSel'length));
writeEn <= '0';
wait for CLK_PERIOD;

RdSel <= std_logic_vector(to_unsigned(2, RdSel'length));
DataIn <= std_logic_vector(to_unsigned(43210, DataIn'length));
writeEn <= '1';
wait for CLK_PERIOD;

RdSel <= std_logic_vector(to_unsigned(0, RdSel'length));
DataIn <= std_logic_vector(to_unsigned(123, DataIn'length));
writeEn <= '1';
Rs1Sel <= std_logic_vector(to_unsigned(0, RdSel'length));
Rs2Sel <= std_logic_vector(to_unsigned(1, RdSel'length));
wait for CLK_PERIOD;

Rs1Sel <= std_logic_vector(to_unsigned(2, RdSel'length));
Rs2Sel <= std_logic_vector(to_unsigned(3, RdSel'length));
writeEn <= '0';
wait for CLK_PERIOD;


for i in 0 to 31 loop
			RdSel <= std_logic_vector(to_unsigned(i, RdSel'length)); 
			DataIn <= std_logic_vector(to_unsigned((i+1)*10, DataIn'length));
			Rs1Sel <= std_logic_vector(to_unsigned(i, RdSel'length));
            Rs2Sel <= std_logic_vector(to_unsigned(i, RdSel'length));
			writeEn <= '1';
			wait for CLK_PERIOD;
        end loop;
writeEn <= '0';        
for i in 0 to 31 loop
            Rs1Sel <= std_logic_vector(to_unsigned(i, RdSel'length));
            Rs2Sel <= std_logic_vector(to_unsigned(i, RdSel'length));
            wait for CLK_PERIOD;
        end loop;

wait;
end process;


CLOCK_PROCESS : process is 
begin
clk <= '0';
wait for CLK_PERIOD / 2;

clk <= '1';
wait for CLK_PERIOD / 2;

end process;


end architecture;