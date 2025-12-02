library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity calcolatrice is
  Port (
    CLK : in std_logic;
    SW : in std_logic_vector( 15 downto 0 );
    LED : out std_logic_vector( 15 downto 0 );
    CA, CB, CC, CD, CE, CF, CG, DP : out std_logic;
    AN : out std_logic_vector( 3 downto 0 );
    BTNC, BTNU, BTNL, BTNR, BTND : in std_logic
  );
end calcolatrice;

architecture Behavioral of calcolatrice is

  -- Internal signal to hold the edge detected versions of the buttons
  signal center_edge, up_edge, left_edge, right_edge, down_edge : std_logic;
  -- Signal to carry the accumulator input and output
  signal acc_in, acc_out : signed( 15 downto 0 );
  -- Init and Load enable for the accumulator
  signal acc_init, acc_enable : std_logic;
  -- ALU control signals
  signal do_add, do_sub, do_mult, do_div : std_logic;
  -- The output of the accumulator is translated into std_logic_vector in this signal
  signal display_value : std_logic_vector( 15 downto 0 );
  -- The input from the switches is sign extended here
  signal sw_input : std_logic_vector( 15 downto 0 );

begin

  -- Instantiate buttons:
  center_detect : entity work.debouncer(Behavioral)
  port map (
    clock   => CLK,
    reset   => SW(15),
    bouncy  => BTNC,
    pulse   => center_edge
    );

  up_detect : entity work.debouncer(Behavioral)
  port map (
    clock   => CLK,
    reset   => SW(15),
    bouncy  => BTNU,
    pulse   => up_edge
    );

  down_detect : entity work.debouncer(Behavioral)
  port map (
    clock   => CLK,
    reset   => SW(15),
    bouncy  => BTND,
    pulse   => down_edge
    );

  left_detect : entity work.debouncer(Behavioral)
  port map (
    clock   => CLK,
    reset   => SW(15),
    bouncy  => BTNL,
    pulse   => left_edge
    );

  right_detect : entity work.debouncer(Behavioral)
  port map(
    clock   => CLK,
    reset   => SW(15),
    bouncy  => BTNR,
    pulse   => right_edge
    );

  -- Instantiate the seven segment display driver
  thedriver : entity work.seven_segment_driver( Behavioral ) 
  generic map ( 
     size => 21 
  )
  port map (
    clock => CLK,
    reset => SW(15),
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

  -- Sign extended switches (32bit - extension)
  sw_input <= SW;

  -- Instantiate the ALU
  the_alu : entity work.alu( Behavioral ) 
  port map (
    a        => acc_out,
    b        => signed( sw_input ),
    add      => do_add,
    subtract => do_sub,
    multiply => do_mult,
    divide   => do_div,
    r        => acc_in
    );

  do_add  <= up_edge;
  do_sub  <= left_edge;
  do_mult <= right_edge;
  do_div  <= down_edge;

  -- Instantiate the accumulator  
  the_accumulator : entity work.accumulator( Behavioral )
  port map (
    clock      => CLK,
    reset      => SW(15),
    acc_init   => acc_init,
    acc_enable => acc_enable,
    acc_in     => acc_in,
    acc_out    => acc_out
    );

  display_value <= std_logic_vector( acc_out );
  acc_enable   <= up_edge or left_edge or right_edge or down_edge;
  acc_init <= center_edge;

end Behavioral;
