library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ALU entity definition: inputs must take the sign into account!
entity alu is
  Port (
      ck : in std_logic;
      rst : in std_logic;
      a, b : in signed(15 downto 0);                        --input operands
      add, subtract, multiply, divide : in std_logic;
      r : out signed(15 downto 0)                           --output
  );
end alu;

-- Definizione architettura ALU
architecture Behavioral of alu is
 begin

  -- Processo viene eseguito ad ogni variazione su operandi e operazione selezionata
  process ( a, b, add, subtract, multiply, divide) 
      
    -- temporary variables
    variable v_result : signed(15 downto 0);
    variable v_mult   : signed(31 downto 0);            -- To store 32-bit multiplication result

     -- Variables specific for the Division
    variable v_num_abs : unsigned(15 downto 0);    -- Absolute value of Dividend (A)
    variable v_den_abs : unsigned(15 downto 0);    -- Absolute value of Divisor (B)
    variable v_quo_abs : unsigned(15 downto 0);    -- Absolute value of Quotient
    variable v_rem     : unsigned(15 downto 0);    -- Partial Remainder
    variable v_sign    : std_logic;                -- Final sign of the result

  begin
    v_result := (others => '0');                   -- Default initialization 
    r <= a;                                        -- Default init output

    if add = '1' then
      v_result := a + b;
    elsif subtract = '1' then
      v_result := a - b;
    elsif multiply = '1' then
      v_mult := a * b;
        -- Resize: Keep only the lower 16 bits (standard ALU behavior)
      v_result := v_mult(15 downto 0); 
    elsif divide = '1' then
    -- Check for Division by Zero
        if b = 0 then
          v_result := (others => '0'); -- Handle error (or output zero)
        else
          -- Determine the sign of the result
          -- If MSBs (sign bits) are different, result is negative
            if (a(15) = b(15)) then
                v_sign := '0'; -- Positive
            else
                v_sign := '1'; -- Negative
            end if;
                --Convert inputs to Unsigned Absolute Values for calculation
                v_num_abs := unsigned(abs(a));
                v_den_abs := unsigned(abs(b));
                -- Initialize quotient and remainder
                v_quo_abs := (others => '0');
                v_rem     := (others => '0');
                -- Fixed Loop for Division (Synthesizable equivalent of subtraction loop)
            for i in 15 downto 0 loop
                -- Shift Remainder left by 1 and bring in the i-th bit of Numerator
                v_rem := v_rem(14 downto 0) & v_num_abs(i); 
                -- Compare: If Remainder is large enough, subtract Divisor
                if v_rem >= v_den_abs then
                    v_rem := v_rem - v_den_abs; -- Subtract
                    v_quo_abs(i) := '1';        -- Set quotient bit to 1
                end if;
            end loop;

                -- Restore the correct sign
            if v_sign = '1' then
                    v_result := signed(0 - v_quo_abs); -- 2's complement negation
            else
                    v_result := signed(v_quo_abs);     -- Keep positive
            end if;
        end if;
     end if;
  end process;
  r <= v_result;
 
end Behavioral;
