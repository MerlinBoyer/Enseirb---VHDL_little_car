library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity gestion_clock_tb is
end;

architecture bench of gestion_clock_tb is

  component gestion_clock
    Port (clock : in std_logic;
          raz : in std_logic;
          clk_rafraichissement : out std_logic;
          clk_affichage : out std_logic;
          clk_aff_voiture: out std_logic;
          clk_bouton : out std_logic);
  end component;

  signal clock: std_logic;
  signal raz: std_logic;
  signal clk_rafraichissement: std_logic;
  signal clk_affichage: std_logic;
  signal clk_aff_voiture: std_logic;
  signal clk_bouton: std_logic;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: gestion_clock port map ( clock                => clock,
                                raz                  => raz,
                                clk_rafraichissement => clk_rafraichissement,
                                clk_affichage        => clk_affichage,
                                clk_aff_voiture      => clk_aff_voiture,
                                clk_bouton           => clk_bouton );

  stimulus: process
  begin
  
    -- Put initialisation code here

    raz <= '1';
    wait for 5 ns;
    raz <= '0';
    wait for 200 ns;

    -- Put test bench stimulus code here


    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clock <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;