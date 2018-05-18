library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity coor_voiture_tb is
end;

architecture bench of coor_voiture_tb is

  component coor_voiture
      port(clk_aff_voiture : in std_logic;
           clk_mouvement : in std_logic;
           clock : in std_logic;
           raz : in std_logic;
           go_droite : in std_logic;
           go_gauche : in std_logic;
           etat : in std_logic_vector(1 downto 0);
           position : in std_logic_vector (9 downto 0);
           coor_voiture : out std_logic_vector(2 downto 0));
  end component;

  signal clk_aff_voiture: std_logic;
  signal clk_mouvement: std_logic;
  signal clock: std_logic;
  signal raz: std_logic;
  signal go_droite: std_logic;
  signal go_gauche: std_logic;
  signal etat: std_logic_vector(1 downto 0);
  signal position: std_logic_vector (9 downto 0);
  signal coor_voiture1: std_logic_vector(2 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: coor_voiture port map ( clk_aff_voiture => clk_aff_voiture,
                               clk_mouvement   => clk_mouvement,
                               clock           => clock,
                               raz             => raz,
                               go_droite       => go_droite,
                               go_gauche       => go_gauche,
                               etat            => etat,
                               position        => position,
                               coor_voiture    => coor_voiture1);

  stimulus: process
  begin
  
    -- Put initialisation code here
        raz <= '1';
        wait for 20 ns;
        raz <= '0';
        etat <= "00";
        position <= "0111110100";
        wait for 20 ns;
        go_droite <= '1';
        wait for 20ns;
        go_droite <= '0'; --impuls pr montrer  etat
        wait for 20ns;
        clk_mouvement <= '1';  --val
        wait for 20ns;
        clk_mouvement <= '0';
        wait for 100ns;
        
        etat <= "01";
        go_droite <= '1';
        wait for 20ns;
        go_droite <= '0'; --impuls pr montrer déplacement
        clk_mouvement <= '1';  --val
        wait for 20ns;
        clk_mouvement <= '0';
        wait for 100ns;
        
        go_gauche <= '1';  --impuls pr montrer non chevauchement
        wait for 20ns;
        go_gauche <= '0';
        wait for 40ns;
        go_droite <= '1';
        wait for 20ns;
        go_droite <= '0';
        wait for 40ns;
        clk_mouvement <= '1';
        wait for 20ns;
        clk_mouvement <= '0';
        
        wait for 100ns;   --montrer plusieurs incrementation quand joystick décalé
        position <= "1010111100";
        wait for 40ns;
        clk_mouvement <= '1';
        wait for 20ns;
        clk_mouvement <= '0';
        wait for 40ns;
        clk_mouvement <= '1';
        wait for 20ns;
        clk_mouvement <= '0';
        wait for 40ns;
        clk_mouvement <= '1';
        wait for 20ns;
        clk_mouvement <= '0';
        wait for 40ns;
        clk_mouvement <= '1';
        wait for 20ns;
        clk_mouvement <= '0';
        wait for 40ns;
        clk_mouvement <= '1';
        wait for 20ns;
        clk_mouvement <= '0';
        wait for 100ns;
        

    -- Put test bench stimulus code here

    stop_the_clock <= true;
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