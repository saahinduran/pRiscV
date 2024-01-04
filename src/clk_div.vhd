library IEEE;
use IEEE.std_logic_1164.all;


entity clk_div is

	generic (
	refClk		    : integer := 27_000_000;
	outClk		    : integer := 13_500_500
	);
	
	port (
	clk_in	: in std_logic;
	clk_out	: out std_logic
	);
end clk_div;




architecture clk_arch of clk_div is

constant clkCountUpLim 	: integer := (refClk/outClk)/2;
signal   clkCounter     : integer := 0;
signal   clkOut			: std_logic := '0';


begin
	clk_process: process(clk_in)
	begin
	
	if(rising_edge(clk_in)) then

		if(clkCounter = clkCountUpLim - 1) then
		clkCounter <= 0;
		clkOut <= not(clkOut);
		else
		clkCounter <= clkCounter + 1;
		end if;

	end if;
	
	end process;
	clk_out <= clkOut;
end clk_arch;