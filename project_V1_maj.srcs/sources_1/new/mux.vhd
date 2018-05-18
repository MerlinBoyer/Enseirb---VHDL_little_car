----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2017 08:21:05
-- Design Name: 
-- Module Name: mux - Behavioral
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
--      recoit les donnees de couleur de pixel depuis les differents modules et retourne celles 
--      correspondant au module indique par la machine d'etat
-------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux is
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           etat : in std_logic_vector(1 downto 0);
           pix_col_jeu : in STD_LOGIC_VECTOR (6 downto 0);
           pix_row_jeu : in STD_LOGIC_VECTOR (5 downto 0);
           pix_data_in_jeu : in STD_LOGIC_VECTOR (15 downto 0);
           pix_col_gameover : in STD_LOGIC_VECTOR (6 downto 0);
           pix_row_gameover : in STD_LOGIC_VECTOR (5 downto 0);
           pix_data_in_gameover : in STD_LOGIC_VECTOR (15 downto 0);
           pix_col_menu : in STD_LOGIC_VECTOR (6 downto 0);
           pix_row_menu : in STD_LOGIC_VECTOR (5 downto 0);
           pix_data_in_menu : in STD_LOGIC_VECTOR (15 downto 0);
           pix_data_in : out STD_LOGIC_VECTOR (15 downto 0);
           pix_col : out STD_LOGIC_VECTOR (6 downto 0);
           pix_row : out STD_LOGIC_VECTOR (5 downto 0);
           pix_write : out std_logic);
end mux;

architecture Behavioral of mux is

signal si_pix_col :  STD_LOGIC_VECTOR (6 downto 0);
signal si_pix_row :  STD_LOGIC_VECTOR (5 downto 0);
signal si_pix_data_in : STD_LOGIC_VECTOR (15 downto 0);

begin

process(clk)

begin
if rising_edge(clk) then
    if raz = '1' then
        si_pix_col <= "0000000";
        si_pix_row <= "000000";
        si_pix_data_in <= "0000000000000000";
        
    elsif etat = "00" then --envoie au module pmod les pixels de "menu"
        si_pix_col <= pix_col_menu;
        si_pix_row <= pix_row_menu;
        si_pix_data_in <= pix_data_in_menu;
        
    elsif  etat = "01" then  --envoie au module pmod les pixels de "jeu"
        si_pix_col <= pix_col_jeu;
        si_pix_row <= pix_row_jeu;
        si_pix_data_in <= pix_data_in_jeu;
        
    elsif  etat = "10" then  --envoie au module pmod les pixels de "gameover"
        si_pix_col <= pix_col_gameover;
        si_pix_row <= pix_row_gameover;
        si_pix_data_in <= pix_data_in_gameover;
    end if;
end if;

pix_write <= '1';
pix_col <= si_pix_col;
pix_row <= si_pix_row;
pix_data_in <= si_pix_data_in;
end process;


end Behavioral;
