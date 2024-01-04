library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity datapath is

port(
    clock_in 	: in std_logic := '1';
	rst  		: in std_logic := '1';
    Memout 		: out std_logic_vector(5 downto 0) := "000000";
	uart_tx_o 	: out std_logic := '0';
	sampleClkOut: out std_logic
);

end datapath;


architecture riscV of datapath is 

signal PC			: std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
signal PCNext		: std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
signal PCTarget		: std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
signal Instruction 	: std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
signal Clk 			: std_logic := '0';
signal WriteEn  	: std_logic := '0';
signal Rs1Out		: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
signal Rs2Out		: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
signal Result       : std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
signal ImmOut 		: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
signal ImmSrc       : std_logic_vector(2 downto 0) := "000";
signal Alu1In		: std_logic_vector (31 downto 0):= "00000000000000000000000000000000"; 
signal Alu2In		: std_logic_vector (31 downto 0):= "00000000000000000000000000000000"; 
signal AluControl   : std_logic_vector (2 downto 0) := "000";  
signal AluOutDataPth       : std_logic_vector (31 downto 0):= x"ffffffff";
--attribute syn_preserve : integer;
--attribute syn_preserve of AluOutDataPth: signal is 1;

signal N,Z,C,V		: std_logic := '0';
signal PcSrc		: std_logic := '0';
signal ResultSrc    : std_logic_vector(3 downto 0) := "0000";
signal MemWrite     : std_logic := '0'; 
signal AluSrc       : std_logic := '0'; 
signal RegWrite     : std_logic := '0';

signal ReadData     : std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
signal PcSource		: std_logic := '0';
signal MemWriteData : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal WriteWidth 	: std_logic_vector(1 downto 0) := "00";
signal Reset 		: std_logic:='1';
signal ByteEn       :  std_logic_vector(1 downto 0):="00";
signal clkSample 	: std_logic;
signal clkSlow			:std_logic;




   component Gowin_rPLL
       port (
           clkout: out std_logic;
         clkin: in std_logic
      );
   end component;

component Gowin_CLKDIV
    port (
        clkout: out std_logic;
        hclkin: in std_logic;
        resetn: in std_logic
    );
end component;
	




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
			ResultSrc    :out std_logic_vector(3 downto 0) := "0000";
			MemWrite     :out std_logic; -- 0  means do not write to mem, 1 means write
			AluControl   :out std_logic_vector(2 downto 0);
			AluSrc       :out std_logic;  -- 0  means take register, 1 means immediate
			ImmSrc       :out std_logic_vector(2 downto 0);
			WriteWidth 	 :out std_logic_vector(1 downto 0) := "00";
			RegWrite     :out std_logic
			
			
	);
end component;


component ALU is

    port (
    Rs1, Rs2   : in  std_logic_vector (31 downto 0) := "00000000000000000000000000000000";  
    AluControl : in  std_logic_vector (2 downto 0) := "000";  
    AluOut     : out std_logic_vector (31 downto 0) := x"FEADBEEF" ; 
    N,Z,C,V    : out std_logic       := '0'
    );
end component; 


component peripherals is
port(
	Clk			: in std_logic;
	Address		: in std_logic_vector(31 downto 0):= x"00000000";	
	DataIn		: in std_logic_vector(31 downto 0);
	WriteEn		: in std_logic;
	AddrIn		: in std_logic_vector(31 downto 0); -- PC ADDRESS / ROM ADDRESS 
    ByteEn      : in std_logic_vector(1 downto 0);


	 --OUTPUTS:
	ReadData	: out std_logic_vector(31 downto 0) :=x"DEADBEEF";
	InstOut		: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	UART_TX		: out std_logic:= '1'
);
end component;




begin
Reset <= rst;



clkdiv: Gowin_CLKDIV
    port map (
        clkout => clkSlow,
        hclkin => clk,
        resetn => '1'
    );

 pll: Gowin_rPLL
 port map (
         clkout => clkSample,
        clkin => clk
 );
 sampleClkOut <= clkSample;	



RegisterFile : register_file 
port map(

Clk			=>  clk, 
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
Rs1		 	=> Alu1In,
Rs2        	=> Alu2In,
AluControl 	=> AluControl, 
AluOut     	=> AluOutDataPth,     
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
WriteWidth 	 => ByteEn  ,
RegWrite     => RegWrite    
);




myPeripherals : peripherals
port map(
	Clk			=> clk,
	Address		=> AluOutDataPth,
	DataIn		=> MemWriteData,
	WriteEn		=> MemWrite,
	AddrIn		=> PC, -- PC ADDRESS / ROM ADDRESS 
	ByteEn 		=> ByteEn,

	 --OUTPUTS:
	ReadData	=> ReadData,
	InstOut		=> Instruction,
	UART_TX		=> uart_tx_o

);


PC_Process: process(clk) is begin
if(rising_edge(clk)) then


if (Reset = '0' ) then
	PC <= x"00000004";
elsif(PcSrc = '0') then
	PC <= PCNext;
else
	PC <= PCTarget;
end if;

end if;
end process;

PCTarget <= Rs1Out + ImmOut when Instruction(6 downto 0) = "1100111" else -- when instruction is JALR
			PC + ImmOut;
			

Alu2In <= Rs2Out when AluSrc = '0' else
		 ImmOut;
		 
Alu1In <= PC when Instruction(6 downto 0) = "0010111" else	
		  Rs1Out;
	


RESULT_PROCESS: process(ResultSrc, ReadData, PCNext, AluOutDataPth) is

begin
case ResultSrc is
	when "0001" | "0011" | "0100" | "0101" | "0110"  => 
		Result <= ReadData;
		
	when "0010" =>
		Result <= PCNext;
		
	when "1000" =>
		Result <= x"00000001";
	when "0000" =>
		Result <= x"00000000";
	when others =>
		Result <= AluOutDataPth; 


end case;
end process;
	
--Result <= ReadData when ResultSrc = "0001" else
--		  PCNext   when ResultSrc = "0010" else
--		  ( (31 downto 8 => ReadData(7)) & ReadData(7 downto 0)) when ResultSrc = "0011" 	else --load byte
--		  ( (31 downto 16 => ReadData(7)) & ReadData(15 downto 0)) when ResultSrc = "0100" 	else -- load halfword
--		  ( (31 downto 8 => '0') & ReadData(7 downto 0)) when ResultSrc = "0101" 			else -- load byte u
--		  ( (31 downto 16 =>'0') & ReadData(15 downto 0)) when ResultSrc = "0110" 			else -- load halfword u
--		  ( (31 downto 1 => '0') & '1')  when ResultSrc = "1000" else   -- SLTI,SLT,SLTIU,SLTU satisfied
--		  (  31 downto 0 => '0'  	)  when ResultSrc = "0000" else	-- SLTI,SLT,SLTIU,SLTU not satisfied
--		  AluOutDataPth;
		   
		  
MemWriteData <= Rs2Out;







PCNext <= PC + 4;		  
clk <= clock_in;
--clkSlow <= clk;

Memout <= ReadData(5 downto 0);
end riscV;