library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ALU entity definition: inputs must take the sign into account!
entity alu is
  Port (
  ck : in std_logic;
  rst : in std_logic;
  a, b : in signed(15 downto 0);                        --switches
  add, subtract, multiply, divide : in std_logic;
  r : out signed(15 downto 0)                          --output
  );
end alu;

-- Definizione architettura ALU
architecture Behavioral of alu is
  signal moltiplica : signed( 31 downto 0 ); 
begin

  -- Processo viene eseguito ad ogni variazione su operandi e operazione selezionata
  process ( a, b, add, subtract, multiply, divide, moltiplica ) begin
    variable d :  integer := 0;                  -- auxilary variable for division
    r <= a;                             -- assegnazione di default

    if add = '1' then
      r <= a + b;
    elsif subtract = '1' then
      r <= a - b;
    elsif multiply = '1' then
      r <= a * b; 
    elsif divide = '1' then
    d := a;
    r <= '0';
       while a > 0 loop
         d := d - b;
         r <= r+1;
       end loop;
    end if;
  end process;

end Behavioral;