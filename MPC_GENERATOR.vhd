-- ============================================================
-- MPC_GENERATOR - Gerador do proximo endereco (MPC) do Mic-1
--
-- JAM(2) = JMPC : MPC[7..0] = NEXT_ADDRESS[7..0] OR MBR_IN
-- JAM(1) = JAMN : MPC[8]    = NEXT_ADDRESS[8] OR N_latched
-- JAM(0) = JAMZ : MPC[8]    = NEXT_ADDRESS[8] OR Z_latched
--
-- As flags N e Z sao registradas na borda de subida de CLOCK
-- (2 flip-flops F e High-bit do Mic-1 do Tanenbaum), enquanto
-- o registro do endereco fica na entrada da ROM (CTRLSTORE).
-- ============================================================
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY MPC_GENERATOR IS
	PORT
	(
		JAM          : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
		CLOCK        : IN  STD_LOGIC;
		N            : IN  STD_LOGIC;
		Z            : IN  STD_LOGIC;
		MBR_IN       : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
		NEXT_ADDRESS : IN  STD_LOGIC_VECTOR (8 DOWNTO 0);
		MPC          : OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
	);
END MPC_GENERATOR;

ARCHITECTURE behavior OF MPC_GENERATOR IS
	SIGNAL n_reg : STD_LOGIC := '0';
	SIGNAL z_reg : STD_LOGIC := '0';
BEGIN
	PROCESS (CLOCK)
	BEGIN
		IF rising_edge(CLOCK) THEN
			n_reg <= N;
			z_reg <= Z;
		END IF;
	END PROCESS;

	-- Bit alto: desvio condicional por N ou Z registrados
	MPC(8) <= NEXT_ADDRESS(8) OR (JAM(1) AND n_reg) OR (JAM(0) AND z_reg);

	-- Bits baixos: desvio multiplo pelo opcode (MBR_IN) quando JMPC = 1
	MPC(7 DOWNTO 0) <= NEXT_ADDRESS(7 DOWNTO 0) OR MBR_IN WHEN JAM(2) = '1'
	                   ELSE NEXT_ADDRESS(7 DOWNTO 0);
END behavior;
