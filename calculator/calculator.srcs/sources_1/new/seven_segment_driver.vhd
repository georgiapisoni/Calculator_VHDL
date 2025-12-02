library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_segment_driver is
    generic (
        size : integer := 20
    );
    Port (
        clk  : in std_logic;
        reset  : in std_logic; -- Nota: Logica Active Low (resetta se '0')
        digit0 : in std_logic_vector( 3 downto 0 );
        digit1 : in std_logic_vector( 3 downto 0 );
        digit2 : in std_logic_vector( 3 downto 0 );
        digit3 : in std_logic_vector( 3 downto 0 );
        CA, CB, CC, CD, CE, CF, CG, DP : out std_logic;
        AN     : out std_logic_vector( 3 downto 0 )
    );
end seven_segment_driver;

architecture Behavioral of seven_segment_driver is

    -- Il contatore per derivare la frequenza di aggiornamento.
    -- Clock 100 MHz. Usando i 2 bit più significativi di un contatore a 20 bit,
    -- otteniamo un cambio cifra ogni 2^18 cicli di clock (~381 Hz refresh rate totale).
    signal flick_counter : unsigned( size - 1 downto 0 );
    
    -- Segnali interni
    signal sel_bits      : std_logic_vector( 1 downto 0 ); -- 2 bit per selezionare 4 cifre
    signal digit         : std_logic_vector( 3 downto 0 );
    signal cathodes      : std_logic_vector( 7 downto 0 );

begin

    -- Processo divisore di clock
    process ( clk, reset ) begin
        if reset = '0' then
            flick_counter <= ( others => '0' );
        elsif rising_edge( clk ) then
            flick_counter <= flick_counter + 1;
        end if;
    end process;

    -- [CORREZIONE] Prendiamo solo i 2 bit più significativi
    -- Se size=20, prendiamo i bit 19 e 18.
    sel_bits <= std_logic_vector(flick_counter( size - 1 downto size - 2 ));

    -- 1. Seleziona l'ANODO attivo (Logica Active Low per display Common Anode)
    with sel_bits select
        AN <= 
            "1110" when "00", -- Cifra 0 (Destra)
            "1101" when "01", -- Cifra 1
            "1011" when "10", -- Cifra 2
            "0111" when others; -- Cifra 3 (Sinistra)

    -- 2. Seleziona il DATO da mostrare (Multiplexer)
    with sel_bits select
        digit <= 
            digit0 when "00",
            digit1 when "01",
            digit2 when "10",
            digit3 when others;

    -- 3. Decodifica Hex-to-7-Segment (Catodi Active Low)
    with digit select
        cathodes <= 
            -- DP, G, F, E, D, C, B, A
            "11000000" when "0000", -- 0
            "11111001" when "0001", -- 1
            "10100100" when "0010", -- 2
            "10110000" when "0011", -- 3
            "10011001" when "0100", -- 4
            "10010010" when "0101", -- 5
            "10000010" when "0110", -- 6
            "11111000" when "0111", -- 7
            "10000000" when "1000", -- 8
            "10010000" when "1001", -- 9
            "10001000" when "1010", -- A
            "10000011" when "1011", -- b
            "11000110" when "1100", -- C
            "10100001" when "1101", -- d
            "10000110" when "1110", -- E
            "10001110" when others; -- F

    -- Mappatura uscite fisiche
    DP <= cathodes(7);
    CG <= cathodes(6);
    CF <= cathodes(5);
    CE <= cathodes(4);
    CD <= cathodes(3);
    CC <= cathodes(2);
    CB <= cathodes(1);
    CA <= cathodes(0);

end Behavioral;