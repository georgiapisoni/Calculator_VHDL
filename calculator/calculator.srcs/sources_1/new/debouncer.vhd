library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debouncer is
    Generic (
        -- Impostiamo il limite a 2.000.000 per avere 20ms a 100MHz
        CLK_LIMIT : integer := 2_000_000 
    );
    Port ( 
        clk    : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        bouncy : in  STD_LOGIC;  -- Il segnale sporco dal bottone
        pulse  : out STD_LOGIC   -- Il segnale pulito (un solo ciclo)
    );
end debouncer;

architecture Behavioral of debouncer is
    signal count : integer range 0 to CLK_LIMIT := 0;
    signal stable_value : std_logic := '0';
    signal candidate_value : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                count <= 0;
                stable_value <= '0';
                pulse <= '0';
            else
                pulse <= '0'; -- Default: nessun impulso
                
                -- Se il segnale in ingresso cambia rispetto a quello che stiamo tracciando
                if bouncy /= candidate_value then
                    candidate_value <= bouncy; -- Aggiorniamo il candidato
                    count <= 0;                -- Resettiamo il timer
                
                -- Se il segnale è stabile (uguale al candidato)
                else
                    if count < CLK_LIMIT then
                        count <= count + 1; -- Continuiamo a contare
                    else
                        -- Abbiamo raggiunto 20ms di stabilità!
                        if candidate_value /= stable_value then
                            stable_value <= candidate_value;
                            
                            -- Generiamo l'impulso SOLO se il tasto è stato premuto (fronte di salita)
                            if candidate_value = '1' then
                                pulse <= '1';
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;