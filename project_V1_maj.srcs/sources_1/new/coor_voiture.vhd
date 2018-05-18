----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.11.2017 10:34:56
-- Design Name: 
-- Module Name: coor_voiture - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity coor_voiture is
    port(clk_aff_voiture : in std_logic;
         clk_mouvement : in std_logic;
         clock : in std_logic;
         raz : in std_logic;
         go_droite : in std_logic;
         go_gauche : in std_logic;
         etat : in std_logic_vector(1 downto 0);
         position : in std_logic_vector (9 downto 0);
         coor_voiture : out std_logic_vector(2 downto 0));
end coor_voiture;



architecture Behavioral of coor_voiture is

signal coor : integer range 0 to 10 :=4; --represente la position de la voiture sur la ligne ( 1 = voiture)
signal bouge : integer range 0 to 2 := 0;
begin
    
process(clock)
begin
    if rising_edge(clock) and etat = "01" then
        if raz = '1' then
            coor <= 4;  
        elsif clk_mouvement = '1' then 
            if bouge = 1 and coor < 7 then
                coor <= coor + 1;  --decalage de la voiture d'un cran a droite
                bouge <= 0;
            elsif bouge = 2 and coor > 0 then
                coor <= coor - 1;  --decalage d'un cran a gauche de la voiture
                bouge <= 0;
            else 
                coor <= coor;
                bouge <= 0;
            end if;
        elsif (go_droite = '1' or position > "1001011000") and bouge = 0 then       --go_droite et go_gauche : appuis sur un bouton
            bouge <= 1;                                                             -- position : coordonnee du joystick en x : de 0 (tout a gauche) a 1024 (tout a droite)
        elsif (go_gauche = '1' or position < "0110010000") and bouge = 0 then
            bouge <= 2; 
        end if;
    end if;
end process;

coor_voiture <= std_logic_vector(to_unsigned(coor,3));

end Behavioral;
