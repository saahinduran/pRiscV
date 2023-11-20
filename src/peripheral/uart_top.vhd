library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity UART_TOP is
generic (
c_clkfreq		: integer := 27_000_000;
c_baudrate		: integer := 115_200
);
port (
clk				: in std_logic;
send_data 		: in std_logic_vector(7 downto 0); -- this is DIN register
send_en 		: in std_logic;  --this is the 0.th bit of ctrl register
tx_o			: out std_logic; -- this is tx pin
busy_bit        : out std_logic; -- this the second bit of ctrl register
tx_done	        : out std_logic  -- this is the 1st bit of ctrl register
);
end UART_TOP;

architecture Behavioral of UART_TOP is

-- INTERNAL REGISTERS --
signal xMitEn   : std_logic := '0';
signal xFerCplt : std_logic := '0';

type STATE_TYPE is (IDLE,TRANSMITTING);
signal state : STATE_TYPE := IDLE;

component uart_tx is
generic (
c_clkfreq		: integer := 100_000_000;
c_baudrate		: integer := 115_200;
c_stopbit		: integer := 2
);
port (
clk				: in std_logic;
din_i			: in std_logic_vector (7 downto 0);
tx_start_i		: in std_logic;
tx_o			: out std_logic;
tx_done_tick_o	: out std_logic
);
end component;



signal sclk				: std_logic;

signal ram_dout : std_logic_vector(7 downto 0):= x"31";

begin




my_uart_tx : uart_tx
generic map(
c_clkfreq		=> 27_000_000,
c_baudrate		=> 115_200,
c_stopbit		=> 1
)
port map(
clk				=> clk,
din_i			=> send_data,
tx_start_i		=> xMitEn,
tx_o			=> tx_o,
tx_done_tick_o	=> xFerCplt
);
    
process (clk) begin
if(rising_edge(clk)) then
case state is 

	when IDLE =>
		if (send_en = '1') then
			busy_bit <= '1'; --out
			xMitEn <= '1'; --internal control signal
			tx_done <= '0';
			state <= TRANSMITTING;
		end if;


	when TRANSMITTING =>
		if(xFerCplt = '1') then
			busy_bit <= '0';
			tx_done <= '1';
			xMitEn <= '0';
			state <= IDLE;
		end if;
end case;	

end if;
end process;

end Behavioral;