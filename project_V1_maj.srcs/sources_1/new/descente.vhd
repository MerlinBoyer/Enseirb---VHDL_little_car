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
------------------------------------------------------------------------------------------------------------------------------
--      Ce module transcrit les données en "cases" de nouv_decor en données par pixels pour le module PMOD_OLEDtgbbitmap
--
--      nouv_decor indique le type d'objet présent sur une case de 8pix/8pix et ce module renvoit les couleurs de chaque pixel un par un.
-----------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity descente is
    port(clock : in std_logic;
         raz : in std_logic;
         clk_aff: in std_logic;
         type_decor : in std_logic_vector(1 downto 0);
         coor_col: in std_logic_vector(3 downto 0);
         coor_row: in std_logic_vector(2 downto 0);
         pix_col : out std_logic_vector(6 downto 0);
         pix_row : out std_logic_vector(5 downto 0);
         pix_data_in : out std_logic_vector(15 downto 0);
         etat : in std_logic_vector(1 downto 0));
end descente;


architecture Behavioral of descente is

signal x : integer := 0;
signal y : integer := 0;
signal x0 : integer := 0;
signal y0 : integer := 0;


begin

process(clock)

begin



if rising_edge(clock) and etat="01" then
    if raz = '1' then
        x <= 0;
        y <= 0;
    end if;
    if  clk_aff='1' then
        x0 <= 8*(to_integer(unsigned(coor_row)));
        y0 <= 8*(to_integer(unsigned(coor_col)));
        x <= 8*(to_integer(unsigned(coor_row)));  
        y <= 8*(to_integer(unsigned(coor_col)));
    else
      if type_decor = "11" then     --obstacle (arbre)
           if (((x = x0 + 3) or (x = x0 + 4)) and (y <= y0 + 2)) then  
               pix_data_in <= "1000001000000000";
           elsif  (x >= x0 + 1) and (x <= x0 + 6) and (y <= y0 + 6) and (y >= y0 + 4) then
               pix_data_in <= "0000010000000000";
           elsif (x >= x0 + 2) and (x <= x0 + 5) and ((y = y0+3) or (y = y0+7)) then
               pix_data_in <= "0000010000000000";           
           elsif ((x = x0) OR (x = x0+7)) and y = y0 + 5 then
               pix_data_in <= "0000010000000000";
           elsif y = y0 then
               pix_data_in <= "1000001000000000";
           else
             pix_data_in <= "0000000000011111";
           end if;
      elsif type_decor = "00" then      -- case vide
           pix_data_in <= "0000000000011111";
      elsif type_decor = "10" then      --voiture
           if  x <= (x0 + 5) and x >= (x0 + 2) and y < (y0 + 7) then 
               pix_data_in <= "1111110000000000";
           elsif (((x = x0+1) OR (x = x0 + 6)) AND ((y = y0+1) OR (y = y0 + 4))) then
               pix_data_in <= "1111110000000000";
           elsif (x = x0+3 OR x = x0+4) AND y = y0 + 6 then
               pix_data_in <= "1111110000000000";
           else 
              pix_data_in <= "0000000000011111";
           end if;
      end if;
      

        pix_row <= std_logic_vector(to_unsigned(x,6));
        pix_col <= std_logic_vector(to_unsigned(y,7));
         

          if x = x0+7 then       -- sélectionne les 64 pixels de la case les uns apres les autres
            if y = y0 + 7 then
                y <= y0;
                x <= x0;
            else
                y <= y + 1;
                  x <= x0;
            end if;
          else
            x <= x + 1;
          end if;  

end if;  
end if;  
end process;

end Behavioral;
