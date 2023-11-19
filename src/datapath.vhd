library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity datapath is

port(
    clock_in : in std_logic;
    AluResult : out std_logic_vector(31 downto 0);
    Memout : out std_logic_vector(31 downto 0);
    CntrlRegWrite : out std_logic
);

end datapath;


architecture riscV of datapath is 

signal PC			: std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
signal PCNext		: std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
signal PCTarget		: std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
signal Instruction 	: std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
signal Clk 			: std_logic;
signal WriteEn  	: std_logic := '0';
signal Rs1Out		: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
signal Rs2Out		: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
signal Result       : std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
signal ImmOut 		: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
signal ImmSrc       : std_logic_vector(2 downto 0) := "000";
signal AluIn		: std_logic_vector (31 downto 0):= "00000000000000000000000000000000"; 
signal AluControl   : std_logic_vector (2 downto 0) := "000";  
signal AluOut       : std_logic_vector (31 downto 0):= "00000000000000000000000000000000";
signal N,Z,C,V		: std_logic;
signal PcSrc		: std_logic;
signal ResultSrc    : std_logic;
signal MemWrite     : std_logic; 
signal AluSrc       : std_logic; 
signal RegWrite     : std_logic := '0';

signal ReadData     : std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
signal Nreset		: std_logic := '0';





component instruction_memory is
	port(
			 --INPUTS: --program counter must be wired to this port !
			AddrIn		: in std_logic_vector(11 downto 0);

			 --OUTPUTS:
			InstOut		: out std_logic_vector(31 downto 0)

	);
end component;

component register_file is
	port(
			 --INPUTS:
			Clk			: in std_logic;
			Rs1Sel		: in std_logic_vector(4 downto 0);	
			Rs2Sel		: in std_logic_vector(4 downto 0);	
			RdSel		: in std_logic_vector(4 downto 0);	
			DataIn		: in std_logic_vector(31 downto 0);
			WriteEn		: in std_logic;
			 --OUTPUTS:
			Rs1Out		: out std_logic_vector(31 downto 0);
			Rs2Out		: out std_logic_vector(31 downto 0)
	);
end component;

component sign_extender is
	port(
			 --INPUTS:
			ImmSrc       :in std_logic_vector(2 downto 0);
			ImmIn	     :in std_logic_vector(31 downto 7);

			 --OUTPUTS:
			ImmOut   	 :out std_logic_vector(31 downto 0)

	);
end component;

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

component ALU is

    port (
    Rs1, Rs2   : in  std_logic_vector (31 downto 0);  
    AluControl : in  std_logic_vector (2 downto 0);  
    AluOut     : out std_logic_vector (31 downto 0); 
    N,Z,C,V    : out std_logic       
    );
end component; 


component data_memory is
	port(
			 --INPUTS:
			Clk			: in std_logic;
			Address		: in std_logic_vector(11 downto 0);	
			DataIn		: in std_logic_vector(31 downto 0);
			WriteEn		: in std_logic;
			 --OUTPUTS:
			ReadData	: out std_logic_vector(31 downto 0)
	);
end component;




begin

InstMem : instruction_memory 
port map(

AddrIn		=> PC(11 downto 0),
InstOut		=> Instruction
);


RegisterFile : register_file 
port map(

Clk			=>  Clk, 
Rs1Sel		=>  Instruction(19 downto 15),  
Rs2Sel		=>  Instruction(24 downto 20),
RdSel		=>  Instruction(11 downto 7),
DataIn		=>  Result,
WriteEn		=>  RegWrite,
         
Rs1Out		=> Rs1Out,
Rs2Out		=> Rs2Out
);


SignExtender : sign_extender 
port map(

ImmSrc       => ImmSrc,
ImmIn	     =>Instruction(31 downto 7),

ImmOut   	 => ImmOut
);

myALU: ALU 
port map(
Rs1		 	=> Rs1Out,
Rs2        	=> AluIn,
AluControl 	=> AluControl, 
AluOut     	=> AluOut,     
N	        => N,
Z           => Z,
C           => C,
V           => V
);

ControlUnit: control_unit 
port map(
OpCode		 => Instruction(6 downto 0),  
Funct3		 => Instruction(14 downto 12),  
Funct7		 => Instruction(31 downto 25),  
N            => N,
Z            => Z,
C            => C,
V		     => V,
 --OUTPUTS:
PcSrc		 => PcSrc		,
ResultSrc    => ResultSrc   ,
MemWrite     => MemWrite    ,
AluControl   => AluControl  ,
AluSrc       => AluSrc      ,
ImmSrc       => ImmSrc      ,
RegWrite     => RegWrite    
);


DataMemory : data_memory 
port map(
Clk			=> Clk,
Address		=> AluOut(11 downto 0),
DataIn		=> Rs2Out,
WriteEn		=> MemWrite,
--OUTPUTS:
ReadData	=> ReadData
);


PC_Process: process(clk) is begin
if(rising_edge(clk)) then

if(PcSrc = '0') then
	PC <= PCNext;
else
	PC <= PCTarget;
end if;

end if;
end process;

PCTarget <= PC + ImmOut;

AluIn <= Rs2Out when AluSrc = '0' else
		 ImmOut;
		 
Result <= ReadData when ResultSrc = '1' else
		  AluOut;
PCNext <= PC + 4;		  
clk <= clock_in;
AluResult <= AluOut;
Memout    <= ReadData;
CntrlRegWrite  <= MemWrite;
end riscV;