library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity gestion_input_tb is
end;

architecture bench of gestion_input_tb is

  component gestion_input
  port(bouton_g : in std_logic;
       bouton_d : in std_logic;
       bouton_h : in std_logic;
       bouton_c : in std_logic;
       bouton_b : in std_logic;
       clk : in std_logic;
       clk_bouton : in std_logic;
       clk_aff_voiture : in std_logic;
       raz : in std_logic;
       gauche : out std_logic;
       centre : out std_logic;
       haut : out std_logic;
       bas : out std_logic;
       droite : out std_logic);
  end component;

  signal bouton_g: std_logic;
  signal bouton_d: std_logic;
  signal bouton_h: std_logic;
  signal bouton_c: std_logic;
  signal bouton_b: std_logic;
  signal clk: std_logic;
  signal clk_bouton: std_logic;
  signal clk_aff_voiture: std_logic;
  signal raz: std_logic;
  signal gauche: std_logic;
  signal centre: std_logic;
  signal haut: std_logic;
  signal bas: std_logic;
  signal droite: std_logic;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: gestion_input port map ( bouton_g        => bouton_g,
                                bouton_d        => bouton_d,
                                bouton_h        => bouton_h,
                                bouton_c        => bouton_c,
                                bouton_b        => bouton_b,
                                clk             => clk,
                                clk_bouton      => clk_bouton,
                                clk_aff_voiture => clk_aff_voiture,
                                raz             => raz,
                                gauche          => gauche,
                                centre          => centre,
                                haut            => haut,
                                bas             => bas,
                                droite          => droite );

  stimulus: process
  begin
  
    -- Put initialisation code here
   raz <= '1';
       wait for 3*clock_period; 
     raz <= '0';    
       wait for 3*clock_period;
     clk_bouton <= '1';
         wait for clock_period;
     clk_bouton <= '0';
         wait for clock_period;
 
     -- Put test bench stimulus code here
   bouton_g <= '1';
   clk_bouton <= '1';
    wait for 3*clock_period;
    clk_aff_voiture <= '0';
         clk_bouton <= '0';
        wait for clock_period;
        clk_bouton <= '1';
       wait for clock_period;
   clk_bouton <= '0';
       wait for clock_period;
           wait for 3*clock_period;
       clk_bouton <= '0';
           wait for clock_period;
   wait for 3*clock_period; 
     clk_bouton <= '1';
               wait for 3*clock_period;
           clk_bouton <= '0';
               wait for clock_period;
               bouton_g <= '0';
               clk_aff_voiture <= '1';
              wait for 3*clock_period;
                 clk_aff_voiture <= '0';
               wait for clock_period;
               
     wait;

    -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
  