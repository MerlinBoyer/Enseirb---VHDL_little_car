----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.11.2017 10:34:56
-- Design Name: 
-- Module Name: gestion_clock - Behavioral
-- Project Name: A
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
--          genere les differentes clocks necessaires aux differents modules
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gestion_clock is
  Port (clock : in std_logic;
        raz : in std_logic;
        clk_rafraichissement : out std_logic;
        clk_affichage : out std_logic;
        clk_aff_voiture: out std_logic;
        clk_mouvement : out std_logic;
        signal_etat : in std_logic_vector (1 downto 0);
        clk_bouton : out std_logic);
        
        
        
end gestion_clock;

architecture Behavioral of gestion_clock is
signal compteur_raf : integer range 0 to 100000000 := 0;
signal si_clock_raf : std_logic;
signal vitesse : integer range 0 to 100000000 := 0;
signal regul_vitesse : integer range 0 to 10000 :=0;

signal compteur_bouton : integer range 0 to 100000000 := 0;
signal si_clock_bouton : std_logic;

signal compteur_aff : integer range 0 to 10000 := 0;
signal si_clock_aff : std_logic;

signal compteur_aff_voiture : integer range 0 to 50000000 := 0;
signal si_clock_aff_voiture : std_logic;

signal compteur_mouv : integer range 0 to 100000000 :=0;
signal si_clk_mouv : std_logic;

begin

process(clock)
begin

if rising_edge(clock) then
    if raz = '1' then
        compteur_raf <= 0;
        vitesse <= 0;
        regul_vitesse <= 0;
    elsif compteur_raf < 99482657-vitesse then
        si_clock_raf <= '0';
        compteur_raf <= compteur_raf +1;
    else
        si_clock_raf <= '1';
        compteur_raf <= 0;
        if regul_vitesse <= 2500000 then
           regul_vitesse <= regul_vitesse + 100000;
        end if;
        if vitesse< 90000000 and signal_etat = "01" then
            vitesse <= vitesse + 1980000;
        elsif signal_etat = "10" then
            vitesse <= 0;
        end if;
    end if;
end if;
end process;


process(clock)
begin

if rising_edge(clock) then
    if raz = '1' then
        compteur_aff <= 0;
    elsif compteur_aff < 70 then
        si_clock_aff <= '0';
        compteur_aff <= compteur_aff +1;
    else
        si_clock_aff <= '1';
        compteur_aff <= 0;
    end if;
end if;
end process;


process(clock)
begin

if rising_edge(clock) then
    if raz = '1' then
        compteur_bouton <= 0;
    elsif compteur_bouton < 100000 then
        si_clock_bouton <= '0';
        compteur_bouton <= compteur_bouton +1;
    else
        si_clock_bouton <= '1';
        compteur_bouton <= 0;
    end if;
end if;
end process;

process(clock)
begin
if rising_edge(clock) then
    if raz = '1' then
        compteur_aff_voiture <= 0;
    elsif compteur_aff_voiture < 100 then             
        si_clock_aff_voiture <= '0';
        compteur_aff_voiture <= compteur_aff_voiture +1;
    else 
        si_clock_aff_voiture <= '1';
        compteur_aff_voiture <= 0;
    end if;
end if;
end process;


process(clock)
begin
if rising_edge(clock) then
    if raz = '1' then
        compteur_mouv <= 0;
    elsif compteur_mouv < 20000000 then            
        si_clk_mouv <= '0';
        compteur_mouv <= compteur_mouv +1;
    else 
        si_clk_mouv <= '1';
        compteur_mouv <= 0;
    end if;
end if;
end process;

clk_mouvement <= si_clk_mouv;
clk_aff_voiture <= si_clock_aff_voiture;
clk_affichage <= si_clock_aff;
clk_bouton <= si_clock_bouton;
clk_rafraichissement <= si_clock_raf;

end Behavioral;
