library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_seven_segment_driver is
-- L'entity del testbench è sempre vuota
end tb_seven_segment_driver;

architecture Behavioral of tb_seven_segment_driver is

    -- Dichiarazione del Componente (Unit Under Test - UUT)
    component seven_segment_driver
        generic (
            size : integer := 20
        );
        Port (
            clock : in std_logic;
            reset : in std_logic;
            digit0 : in std_logic_vector( 3 downto 0 );
            digit1 : in std_logic_vector( 3 downto 0 );
            digit2 : in std_logic_vector( 3 downto 0 );
            digit3 : in std_logic_vector( 3 downto 0 );
            CA, CB, CC, CD, CE, CF, CG, DP : out std_logic;
            AN : out std_logic_vector( 3 downto 0 )
        );
    end component;

    -- Segnali per collegare il testbench al componente
    signal clock_tb : std_logic := '0';
    signal reset_tb : std_logic := '0';
    
    -- Segnali per le 4 cifre in ingresso
    signal digit0_tb : std_logic_vector(3 downto 0) := (others => '0');
    signal digit1_tb : std_logic_vector(3 downto 0) := (others => '0');
    signal digit2_tb : std_logic_vector(3 downto 0) := (others => '0');
    signal digit3_tb : std_logic_vector(3 downto 0) := (others => '0');

    -- Segnali di uscita verso i segmenti e anodi
    signal CA_tb, CB_tb, CC_tb, CD_tb, CE_tb, CF_tb, CG_tb, DP_tb : std_logic;
    signal AN_tb : std_logic_vector(3 downto 0);

    -- Costante per il periodo del clock (100 MHz = 10 ns)
    constant CLOCK_PERIOD : time := 10 ns;

begin

    -- Istanziazione della UUT (Unit Under Test)
    uut: seven_segment_driver
    generic map (
        -- IMPORTANTE: Riduciamo la size a 5 per la simulazione.
        -- Se lasciassimo 20, dovremmo simulare per millisecondi prima
        -- di vedere gli anodi cambiare!
        size => 5 
    )
    port map (
        clock => clock_tb,
        reset => reset_tb,
        digit0 => digit0_tb,
        digit1 => digit1_tb,
        digit2 => digit2_tb,
        digit3 => digit3_tb,
        CA => CA_tb,
        CB => CB_tb,
        CC => CC_tb,
        CD => CD_tb,
        CE => CE_tb,
        CF => CF_tb,
        CG => CG_tb,
        DP => DP_tb,
        AN => AN_tb
    );

    -- Processo di generazione del Clock
    clk_process : process
    begin
        clock_tb <= '0';
        wait for CLOCK_PERIOD/2;
        clock_tb <= '1';
        wait for CLOCK_PERIOD/2;
    end process;

    -- Processo di Stimolo
    stim_proc: process
    begin
        -- 1. Reset iniziale (Attivo basso nel tuo codice: reset = '0')
        reset_tb <= '0'; 
        wait for 100 ns;
        
        -- Rilascio del reset
        reset_tb <= '1';
        wait for CLOCK_PERIOD;

        -- 2. Impostiamo valori statici per le 4 cifre
        -- Digit 0 = "0000" (Mostra 0)
        -- Digit 1 = "0001" (Mostra 1)
        -- Digit 2 = "0010" (Mostra 2)
        -- Digit 3 = "0011" (Mostra 3)
        digit0_tb <= "0000";
        digit1_tb <= "0001";
        digit2_tb <= "0010";
        digit3_tb <= "0011";

        -- Attendiamo abbastanza tempo per vedere il ciclo completo degli anodi.
        -- Con size=5, il contatore è piccolo, quindi basteranno pochi microsecondi.
        wait for 2000 ns;

        -- 3. Cambiamo i valori in ingresso per vedere se l'uscita si aggiorna
        -- Proviamo anche caratteri Hex
        digit0_tb <= "0100"; -- 4
        digit1_tb <= "0101"; -- 5
        digit2_tb <= "1000"; -- 8
        digit3_tb <= "1111"; -- F (Spento o pattern specifico)

        wait for 2000 ns;

        -- 4. Fine della simulazione
        assert false report "Simulazione completata con successo!" severity failure;
    end process;

end Behavioral;