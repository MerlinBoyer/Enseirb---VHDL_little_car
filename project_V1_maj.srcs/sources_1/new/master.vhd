----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2017 13:14:17
-- Design Name: 
-- Module Name: master - Behavioral
-- Project Name: 
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
--          Machine d'etat : les etats possibles sont :
--          MENU : declenche l'affichage de l'ecran menu
--          JEU : declenche les modules generant le jeu et l'affichage de celui-ci
--          GAME_OVER : declenche l'affichage de l'ecran game over
------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity master is
    Port ( clock : in STD_LOGIC;
           raz : in STD_LOGIC;
           fin_jeu : in STD_LOGIC;
           bouton : in STD_LOGIC;
           signal_etat : out STD_LOGIC_VECTOR (1 downto 0));
end master;

architecture Behavioral of master is


type type_etat is (menu, jeu, game_over);
signal etat : type_etat := menu;

begin

etatfutur: process(clock)

begin

if rising_edge(clock) then
    if raz = '1' then
        etat <= menu;
    elsif bouton = '1' and etat = menu then
        etat <= jeu;
    elsif fin_jeu =  '1' and etat = jeu then
        etat <= game_over;
    elsif bouton = '1' and etat = game_over then
        etat <= menu;
    end if;
end if;

end process etatfutur;


etatpresent: process(etat)

begin

case etat is
    when menu =>
        signal_etat <= "00";
    
    when jeu =>
        signal_etat <= "01";
    
    when game_over =>
        signal_etat <= "10";
    
    when others =>
        null;
    
    end case;

end process etatpresent;


end Behavioral;
