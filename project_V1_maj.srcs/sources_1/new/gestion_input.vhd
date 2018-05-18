----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.11.2017 10:34:56
-- Design Name: 
-- Module Name: gestion_input - Behavioral
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
--          filtres anti-rebond pour les boutons
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gestion_input is
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
     
    
end gestion_input;

architecture Behavioral of gestion_input is

signal si_droite : std_logic;
signal si_gauche : std_logic;
signal si_centre : std_logic;
signal appuis : std_logic;
signal block_centre : std_logic := '0';
signal cpt : integer range 0 to 20000001 := 0;
begin

process(clk)
   begin

haut <= '0';
bas <= '0';
if rising_edge(clk) then
    haut <= '0';
    bas <= '0';
    if raz = '1' then
        gauche <= '0';
        droite <= '0';
        centre <= '0';
    elsif clk_bouton = '1' then
        if appuis = '0' then
            if bouton_c = '1' then
                si_centre <= '1';
                block_centre <= '1';
                appuis <= '1';
            elsif bouton_g = '1' then
                si_gauche <= '1';
                appuis <= '1';
            elsif bouton_d = '1' then
                si_droite <= '1';
                appuis <= '1';
            else
                if block_centre = '1' then
                    block_centre <= '0';
                    appuis <= '1';
                end if;
                si_droite <= '0';
                si_gauche <= '0';
            end if;
        end if;
    elsif appuis = '1' and cpt = 0 then
        if block_centre = '0' and si_centre = '1' then
            centre <= '1';
            si_centre <= '0';
        else
            centre <= '0';
        end if;
        droite <= si_droite;
        gauche <= si_gauche;
        cpt <= cpt + 1;
    elsif appuis = '1' and cpt /= 0 then
            if cpt < 15000000 then
                cpt <= cpt + 1;
            else
                appuis <= '0';
                cpt <= 0;
            end if;
            centre <= '0';
            droite <= '0';
            gauche <= '0';
    end if;
end if;
end process;
        

end Behavioral;













