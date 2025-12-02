library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity accumulator is
  Port (
      clk                           : in std_logic;
      reset                           : in std_logic;
      acc_init                        : in std_logic;   --1 resets outputs
      acc_enable                      : in std_logic;   --1 enables accumulator out
      acc_in                          : in signed(15 downto 0);
      acc_out                         : out signed(15 downto 0)                     
  );
end accumulator;

architecture Behavioral of accumulator is begin
-- question: use a separate register signal or just let it map to out?  
-- we can leave it like this (professor said its okay) 
-- signal acc_register : signes(15 downto 0); 

  process ( clk, reset ) begin
    if reset = '1' then
      acc_out <= (others =>'0');

    elsif rising_edge( clk ) then

      if acc_init = '1' then               --output reset on 
        acc_out <= (others => '0');        --output zeroed
      elsif acc_enable = '1' then   
        acc_out <= acc_in;                 --assigns input values to output
      end if;
    end if;
  end process;

end Behavioral;
