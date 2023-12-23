library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ControlUnittestbench is


end ControlUnittestbench;

architecture control of ControlUnittestbench is

component control_unit is
	port(
			 --INPUTS:
			OpCode		 : in std_logic_vector(6 downto 0);
			Funct3		 : in std_logic_vector(2 downto 0);
			Funct7		 : in std_logic_vector(6 downto 0);
			N,Z,C,V		 : in std_logic;

		
			 --OUTPUTS:
			
			PcSrc		 :out std_logic;
			ResultSrc    :out std_logic;
			MemWrite     :out std_logic; -- 0  means do not write to mem, 1 means write
			AluControl   :out std_logic_vector(2 downto 0);
			AluSrc       :out std_logic;  -- 0  means take register, 1 means immediate
			ImmSrc       :out std_logic_vector(2 downto 0);
			RegWrite     :out std_logic
			
			
	);
end component;

signal inst : std_logic_vector(31 downto 0);


signal N,Z,C,V		: std_logic;
signal PcSrc		: std_logic;
signal ResultSrc    : std_logic;
signal MemWrite     : std_logic; -- 0  means do not write to mem, 1 means write
signal AluControl   : std_logic_vector(2 downto 0);
signal AluSrc       : std_logic;  -- 0  means take register, 1 means immediate
signal ImmSrc       : std_logic_vector(2 downto 0);
signal RegWrite     : std_logic;


begin

myControlUnit : control_unit
port map
(
OpCode => inst(6 downto 0),
Funct3 => inst(14 downto 12),
Funct7 => inst(31 downto 25), 
N => N, 
Z => Z, 
C => C, 
V => V, 
PcSrc		=> PcSrc	   ,
ResultSrc   => ResultSrc   ,
MemWrite    => MemWrite    ,
AluControl  => AluControl  ,
AluSrc      => AluSrc      ,
ImmSrc      => ImmSrc      ,
RegWrite    => RegWrite    
);

CONTROL_BLOCK: process is begin

wait for 5 ns;
inst<= x"30008C63";
wait for 5 ns;

end process;

end control;
