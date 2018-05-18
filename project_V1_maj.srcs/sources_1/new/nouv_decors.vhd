----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.11.2017 10:34:56
-- Design Name: 
-- Module Name: descente - Behavioral
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
---------------------------------------------------------------------------------------------------------------------
--             Ce module génère le contenu de l'écran : descente du décor et position de la voiture
--                  l'écran est divisé en cases de 8pix/8pix qui contiennent un objet : vide, voiture ou obstacle
--              ce module calcule aussi le score en l'incrementant a chaque descente du decor
---------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
--use ieee.math_real.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity nouv_decors is
  Port ( clock : in std_logic;
         raz : in std_logic;
         clk_rafraichissement : in std_logic;
         clk_affichage : in std_logic;  -- fréquence d'affichage 
         clk_aff_voiture : in std_logic;
         coor_voiture : in std_logic_vector(2 downto 0);
         type_decor : out std_logic_vector(1 downto 0);
         coor_col: out std_logic_vector(3 downto 0);
         coor_row: out std_logic_vector(2 downto 0);
         etat : in std_logic_vector (1 downto 0);
         fin_jeu : out std_logic;
         centaine : out STD_LOGIC_VECTOR (3 downto 0);
         dizaine : out STD_LOGIC_VECTOR (3 downto 0);
         unite : out STD_LOGIC_VECTOR (3 downto 0)
         );
end nouv_decors;


 


architecture Behavioral of nouv_decors is
 
type tableau is array (integer range 0 to 95) of std_logic_vector(1 downto 0);
signal tab_decor : tableau;
signal coorX : integer range 0 to 15 :=0;
signal coorY : integer range 0 to 15 :=0;
signal x : integer range 0 to 100 := 0;
signal obstacle : integer range 0 to 10 := 0;
signal nouv_decor : std_logic := '0';
signal fin_game: std_logic := '0';
signal int_unite : integer range 0 to 10 := 0;
signal int_dizaine : integer range 0 to 10 := 0;
signal int_centaine : integer range 0 to 10 := 0;

signal erase : std_logic := '1';

begin


process(clock)

begin

if rising_edge(clock) and etat = "01" then
    if raz = '1' then
        x <= 0;
        fin_game <= '0';
        int_unite <= 0;
        int_dizaine <= 0;
        int_centaine <= 0;
        erase <= '1';
    end if;
    
    if erase = '1' then
        fin_game <= '0';
        x <= 0;
        coorX <= 0;
        coorY <= 0;
        tab_decor(x) <= "00";
        x <= x+1;
        if x >= 97 then
            erase <= '0';
            int_unite <= 0;
            int_dizaine <= 0;
            int_centaine <= 0;
        end if;
    

      -------------------------------------------------OK----------------------------------------
    elsif clk_rafraichissement = '1' and fin_game = '0'  then  --initialisation de la generation du nouveau decor
        nouv_decor <= '1';
        x<=0;
        coorX <= 0;
        coorY <= 0;
        if int_unite = 9 then
            if int_dizaine = 9 then
                if int_centaine = 9 then
                    int_centaine <= 9;
                else
                    int_centaine <= int_centaine + 1;
                    int_dizaine <= 0;
                    int_unite <= 0;
                end if;
             else
                int_dizaine <= int_dizaine + 1;
                int_unite <= 0;
             end if;
        else
            int_unite <= int_unite + 1;
        end if;
    
    elsif nouv_decor = '1' then
                --recopie la ligne du dessus
        if x <= 87 then
            if x = to_integer(unsigned(coor_voiture)) then --case correspondant a la voiture
                if tab_decor(x+8) = "11" then  --verifie si il y a un obstacle qui tombe sur la voiture
                    fin_game <= '1';  -- termine le jeu si la voiture est au meme endroit qu'un obstacle
                    erase <= '1';
                end if;
                tab_decor(x) <= "10";
            else
                tab_decor(x) <= tab_decor(x+8); --recopie la ligne du dessus si il n'y a pas la voiture
            end if;
            x <= x+1;
            
            --cree la nouvelle ligne avec un obstacle a un endroit        
        elsif x <= 95 and x > 87 then   
            if x-88 = obstacle then
                tab_decor(x) <= "11";
                x <= x+1;
            else
                tab_decor(x) <= "00";
                x <= x+1;
            end if;
        
        else
            x <= 0;
            nouv_decor <= '0';
        end if;
        
    
        
    else            -- actualise la position de la voiture
        if clk_aff_voiture='1' then
            if x < 7 then
                if tab_decor(x) = "10" then
                    tab_decor(x) <= "00";
                    tab_decor(to_integer(unsigned(coor_voiture))) <= "10";
                end if;
                x <= x+1;
            else
                x <= 0;
            end if;
            
                        -- "genere" un nb aleatoire entre 1 et 8 qui change quand on rafraichit pas l'ecran
        elsif clk_affichage /= '1' then
            if obstacle < 7 then  
                obstacle <= obstacle+1;
            else
                obstacle <=0;
            end if;
        end if;
    end if;

  
    -- selectionne les cases une par une pour envoyer les donnees au module descente
    if clk_affichage='1' and fin_game = '0' then

        if coorX = 7 then                 
            if coorY = 11 then
                coorX <= 0;
                coorY <= 0;
            else
                coorX <= 0;
                coorY <= coorY + 1;
            end if;
        else
            coorX <= coorX + 1;
        end if;   
    end if;
  
 


    
end if;
end process;

fin_jeu <= fin_game;
coor_col <= std_logic_vector(to_unsigned(coorY,4));
coor_row <= std_logic_vector(to_unsigned(coorX,3));
type_decor <= tab_decor(coorX+(8*coorY)-1);
unite <= std_logic_vector(to_unsigned(int_unite,4));
dizaine <= std_logic_vector(to_unsigned(int_dizaine,4));
centaine <= std_logic_vector(to_unsigned(int_centaine,4));


end Behavioral;
