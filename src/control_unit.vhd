library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity control_unit is
	port(
			 --INPUTS:
			OpCode		 : in std_logic_vector(6 downto 0);
			Funct3		 : in std_logic_vector(2 downto 0);
			Funct7		 : in std_logic_vector(6 downto 0);
			N,Z,C,V		 : in std_logic;

		
			 --OUTPUTS:
			
			PcSrc		 :out std_logic := '0';
			ResultSrc    :out std_logic := '0';
			MemWrite     :out std_logic := '0'; -- 0  means do not write to mem, 1 means write
			AluControl   :out std_logic_vector(2 downto 0) := "000";
			AluSrc       :out std_logic := '0';  -- 0  means take register, 1 means immediate
			ImmSrc       :out std_logic_vector(2 downto 0) := "000";
			RegWrite     :out std_logic := '0'
			
			
	);
end control_unit;

architecture control of control_unit is


constant R_TYPE     : std_logic_vector(6 downto 0) := "0110011";  -- 0x33 : R_TYPE
constant I_TYPE     : std_logic_vector(6 downto 0) := "0010011";  -- 0x13 : I_TYPE
constant B_TYPE     : std_logic_vector(6 downto 0) := "1100011";  -- 0x63 : B_TYPE
constant LOAD_TYPE  : std_logic_vector(6 downto 0) := "0000011";  -- 0x03 : LOAD_TYPE
constant STORE_TYPE : std_logic_vector(6 downto 0) := "0100011";  -- 0x23 : STORE_TYPE
constant LUI_TYPE   : std_logic_vector(6 downto 0) := "0110111";  -- 0x37 : LUI_TYPE
constant AUIPC_TYPE : std_logic_vector(6 downto 0) := "0010111";  -- 0x17 : AUIPC_TYPE
constant JAL_TYPE   : std_logic_vector(6 downto 0) := "1101111";  -- 0x6F : JAL_TYPE
constant JALR_TYPE  : std_logic_vector(6 downto 0) := "1100111";  -- 0x67 : JALR_TYPE




begin

AluSrc     <= '0' when OpCode = R_TYPE else       -- Second operand of ALU comes from register only when instruction type is R.
		      '1';

ResultSrc  <= '1' when OpCode = LOAD_TYPE else	 -- Result of instruction comes from memory only when instruction type is LOAD_TYPE.
			  '0';							     -- result source is ALU result otherwise.


			 -- PC source selection; Pc including instructions cause 
			 -- Pc to have a value different than PC + 4;
PcSrc      <= '1' when OpCode = B_TYPE and Funct3= "000" and Z = '1'  			  else -- BEQ
			  '1' when OpCode = B_TYPE and Funct3= "001" and Z = '0'  			  else -- BNE
			  '1' when OpCode = B_TYPE and Funct3= "100" and N = '1' 			  else -- BLT
			  '1' when OpCode = B_TYPE and Funct3= "101" and N = '0'			  else -- BGE
			  '1' when OpCode = B_TYPE and Funct3= "110" and C = '1' 			  else -- BLTU
			  '1' when OpCode = B_TYPE and Funct3= "111" and N = '0' and C = '0'  else -- BGEU
			  '1' when OpCode = JAL_TYPE   			    else   
			  '1' when OpCode = JALR_TYPE  			    else		
			  '0';
			 
			 	
MemWrite   <= '1' when OpCode = STORE_TYPE else	 -- Memwrite signal is 1 only when executing STORE instruction
			  '0';
			 
RegWrite   <= '1' when OpCode = R_TYPE     else		 -- When will register write be performed? : R,I,LUI,LOAD,JAL,JALR,AUIPC type. 	 
			  '1' when OpCode = I_TYPE     else		 -- only branch and store does not perform any writeback.
			  '1' when OpCode = LUI_TYPE   else 
			  '1' when OpCode = LOAD_TYPE  else  
			  '1' when OpCode = JAL_TYPE   else
			  '1' when OpCode = JALR_TYPE  else
			  '1' when OpCode = AUIPC_TYPE else
			  '0';
              
			  --Each ImmSrc means different immediate extending.
ImmSrc	   <= "000" when OpCode = LUI_TYPE or OpCode = AUIPC_TYPE  else -- 0: LUI_TYPE or  AUIPC_TYPE
			  "001" when OpCode = JAL_TYPE 						   else -- 1: JAL_TYPE
			  "010" when OpCode = JALR_TYPE or OpCode = LOAD_TYPE
								  or OpCode = I_TYPE  			   else -- 2: JALR_TYPE or LOAD_TYPE or I_TYPE
			  "011" when OpCode = B_TYPE 						   else -- 3: B_TYPE
			  "100" when OpCode = STORE_TYPE 				       else -- 4: STORE_TYPE
			  "101" when OpCode = I_TYPE and (Funct3 = "001" or Funct3 = "101") else -- 5: I_TYPE SLLI,SRLI,SRAI
              "111" ; --Default value
			 
AluControl <= "000" when OpCode = LUI_TYPE or OpCode = AUIPC_TYPE or 
					OpCode = JAL_TYPE or OpCode = JALR_TYPE or OpCode = STORE_TYPE or OpCode = LOAD_TYPE
					or (OpCode = R_TYPE and Funct7 ="0000000" and Funct3 ="000")					else -- default ADD , R-TYPE ADD
			  "000" when OpCode = I_TYPE and Funct3 ="000"  else -- ADDI
			  "001" when (OpCode = I_TYPE and Funct3 ="010") or (OpCode = R_TYPE and Funct7 ="0100000")  else -- SLTI
			  "001" when OpCode = I_TYPE and Funct3 ="011"  else -- SLTIU
			  "001" when OpCode = B_TYPE  					else -- BEQ,BNE,BLT,BGE,BLTU,BGEU 

			  "010" when (OpCode = I_TYPE or OpCode = R_TYPE) and Funct3 ="100"   else -- XORI
			  "011" when (OpCode = I_TYPE or OpCode = R_TYPE) and Funct3 ="110"  else -- ORI
			  "100" when (OpCode = I_TYPE or OpCode = R_TYPE) and Funct3 ="111"  else -- ANDI 
			  "101" when ( (OpCode = I_TYPE or OpCode = R_TYPE) and Funct3 ="001") or (OpCode = R_TYPE and Funct3 ="001")  else -- SLLI
			  "110" when ( (OpCode = I_TYPE or OpCode = R_TYPE) and (Funct3 ="101" and Funct7 ="0000000") )  else -- SRLI
			  "111" when ( (OpCode = I_TYPE or OpCode = R_TYPE) and (Funct3 ="101" and Funct7 ="0100000") )  else -- SRAI
			  "000"; -- default AluControl is add.
			  
			  

							
end control;