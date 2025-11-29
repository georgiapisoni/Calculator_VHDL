library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity calcolatrice is
  Port (

  
-- Enter port declarations here:
    -- * One clock input
    -- * One reset input
    -- * One input for the "SW" switches
    -- * One output for the "LED" LEDs
    -- * Inputs for the "BTNC, BTNU, BTNL, BTNR, BTND" buttons
	
    CA, CB, CC, CD, CE, CF, CG, DP : out std_logic; --! modify the constraint file accordingly
    AN : out std_logic_vector( 7 downto 0 )

  );
end calcolatrice;

architecture Behavioral of calcolatrice is

-- Internal signals for debouncers
  signal center_edge, up_edge, left_edge, right_edge, down_edge : std_logic;
  -- Input/output signals for accumulator
  signal acc_in, acc_out : signed( 15 downto 0 );
  -- Init and load signals for accumulator
  signal acc_init, acc_enable : std_logic;
  -- Control signals for ALU
  signal do_add, do_sub, do_mult, do_div : std_logic;
  -- The accumulator output should be converted to std_logic_vector
  signal display_value : std_logic_vector( 15 downto 0 );
  -- Signals for input switches
  signal sw_input : std_logic_vector( 15 downto 0 );
 
begin

  -- Buttons Declaration:
  center_detect : entity work.debouncer(Behavioral)
  port map (
    clock   => clock,
    reset   => reset,
    bouncy  => BTNC,
    pulse   => center_edge
  );
  
  up_detect : entity work.debouncer(Behavioral)
  port map (
    -- link and connect the button
  );
  
  down_detect : entity work.debouncer(Behavioral)
  port map (
    -- link and connect the button
  );
  
  left_detect : entity work.debouncer(Behavioral)
  port map (
    -- link and connect the button
  );

  right_detect : entity work.debouncer(Behavioral)
  port map (
    -- link and connect the button
  );
  
  -- Instantiate the seven segment display driver
  thedriver : entity work.seven_segment_driver( Behavioral ) 
  generic map ( 
     size => 21 
  ) port map (
    clock => clock,
    reset => reset,
    digit0 => display_value( 3 downto 0 ),
    digit1 => display_value( 7 downto 4 ),
    digit2 => display_value( 11 downto 8 ),
    digit3 => display_value( 15 downto 12 ),
    CA     => CA,
    CB     => CB,
    CC     => CC,
    CD     => CD,
    CE     => CE,
    CF     => CF,
    CG     => CG,
    DP     => DP,
    AN     => AN
  );
  LED <= SW;
  
  -- transfer swithc input to signal
  sw_input <= SW;
              
  -- Instantiate the ALU
  the_alu : entity work.alu( Behavioral ) port map (
-- Connect the alu to the accumulator and switches. 
-- It also connects the internal signals to establish the operation
  );
-- Assigns the output of the corresponding debouncers to the internal signals
  do_add  <= up_edge;
  do_sub  <= ...
  do_mult <= ...
  do_div  <= ..
   
  -- Declaration accumulator
  the_accumulator : entity work.accumulator( Behavioral )
  port map(
    -- Connect accumulator
  );
 -- Assigns the output value to display value
  display_value <= std_logic_vector( ... );
   -- Assign acc_enable and acc_init as delivered
  acc_enable <= ...
  acc_init <= ...;

end Behavioral;