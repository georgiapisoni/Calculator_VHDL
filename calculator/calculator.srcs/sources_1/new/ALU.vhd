library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
  Port (
      clk                             : in std_logic;
      rst                             : in std_logic;
      a, b                            : in signed(15 downto 0);   --input operands
      add, subtract, multiply, divide : in std_logic;
      r                               : out signed(15 downto 0)   --output
  );
end alu;

-- ARITHMETIC LOGIC UNIT definition
architecture Behavioral of alu is
 begin

  -- calculator operations
  process ( a, b, add, subtract, multiply, divide) 
      
    -- temporary variables
    variable v_result : signed(15 downto 0);
    variable v_mult   : signed(31 downto 0);            -- stores 32-bit multplication result

    -- Division variables
    variable v_num_abs : unsigned(15 downto 0);    -- absolute value of dividend (a)
    variable v_den_abs : unsigned(15 downto 0);    -- absolute value of divisor (b)
    variable v_quo_abs : unsigned(15 downto 0);    -- absolute value of quotient
    variable v_rem     : unsigned(15 downto 0);    -- partial remainder
    variable v_sign    : std_logic;                -- final sign of the result

  begin
    v_result := (others => '0');                   
    r <= a;                                   

    if add = '1' then
      v_result := a + b;

    elsif subtract = '1' then
      v_result := a - b;

    elsif multiply = '1' then
      v_mult := a * b;
        -- ALU keeps only the lower 16 bits 

      v_result := v_mult(15 downto 0); 
    
    -- ---DIVISION LOGIC---
    elsif divide = '1' then
    -- check division by zero
        if b = 0 then
          v_result := (others => '0'); 
        else
          -- --sign of result--
          -- most significant bits =/=, result => negative
            if (a(15) = b(15)) then
                v_sign := '0'; -- (+)
            else
                v_sign := '1'; -- (-)
            end if;
                --convertion to absolute values for calculation
                v_num_abs := unsigned(abs(a));
                v_den_abs := unsigned(abs(b));
                v_quo_abs := (others => '0');
                v_rem     := (others => '0');

                -- DIVISION LOGIC LOOP
            for i in 15 downto 0 loop
                -- shift remainder left by 1 and bring in the i-th bit of numerator
                v_rem := v_rem(14 downto 0) & v_num_abs(i); 
                -- if remainder is large enough, subtract divisor
                if v_rem >= v_den_abs then
                    v_rem := v_rem - v_den_abs; 
                    v_quo_abs(i) := '1';       
                end if;
            end loop;

                -- SIGN RESTORATION
            if v_sign = '1' then
                    v_result := signed(0 - v_quo_abs); -- 2's complement negation
            else
                    v_result := signed(v_quo_abs);     -- keep positive
            end if;
        end if;
     end if;
     r <= v_result;
  end process;
 
end Behavioral;
