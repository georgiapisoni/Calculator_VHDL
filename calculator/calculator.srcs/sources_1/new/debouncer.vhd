library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is
  generic (
    counter_size : integer := 12
  );
  port (
    clock                           : in std_logic;
    reset                           : in std_logic;
    bouncy                          : in std_logic;
    pulse                           : out std_logic
  );
end debouncer;

architecture behavioral of debouncer is

  signal counter                : unsigned((counter_size-1) downto 0) := (others => '0');
  -- keeps track of the time interval in which the signal is stable
  signal candidate_value        : std_logic := '0';       --flag for candidate stable value
  signal stable_value           : std_logic := '0';       --flag for current stable value
  signal delayed_stable_value   : std_logic := '0';       --flag for delayed stable value to generate out

begin

  process ( clock, reset ) begin
    if reset = '0' then
      counter <= (others => '0');
      stable_value <= '0';
      candidate_value <= '0'; 

    elsif rising_edge( clock ) then
      -- Check whether the signal is stable
      if bouncy = candidate_value then
        -- Stable signal. Check for how long
        if counter = ( others => '0' ) then
          -- Update stable value
          stable_value <= candidate_value;
        else
         -- Decrement the counter
          counter <= counter - 1;
        end if;
      else
        -- Signal not stable. Update the candidate value and reset the counter
        candidate_value <= '0';
      end if;
    end if;
  end process;

  -- creates a DELAYED VERSION of the stable signal 
  process ( clock, reset ) begin
    if reset = '0' then
      delayed_stable_value <= '0';
    elsif rising_edge( clock ) then
      delayed_stable_value <= stable_value;
    end if;
  end process;

  -- Generate output pulse
  pulse <= '1' when stable_value = '1' and delayed_stable_value = '1' else
           '0';

end behavioral;

