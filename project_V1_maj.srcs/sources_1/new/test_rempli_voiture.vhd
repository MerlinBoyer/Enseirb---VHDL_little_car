----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2017 17:11:19
-- Design Name: 
-- Module Name: test_rempli_voiture - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_rempli_voiture is
    Port ( clock : in STD_LOGIC;
           raz : in STD_LOGIC;
           type_decor : in std_logic_vector(1 downto 0);
           pix_row : out STD_LOGIC;
           pix_col : out STD_LOGIC;
           pix_color : out STD_LOGIC);
end test_rempli_voiture;

architecture Behavioral of test_rempli_voiture is


--ce module renvoie les couleurs de chaque pixel en fonction du type de décor
begin

process(clock)
begin
    if rising_edge(clock) then
        if type_decor = "10" then --voiture
            if  x <= (x0 + 4) and x >= (x0 + 2) and y < (y0 + 7) then 
                pix_data_in <= "1111110000000000";
            elsif (((x = x0+1) OR (x = x0 + 6)) AND ((y = y0+1) OR (y = y0 + 4))) then
                pix_data_in <= "1111110000000000";
            elsif (x = x0+3 OR x = x0+4) AND y = y0 + 6 then
                pix_data_in <= "1111110000000000";
            else 
               pix_data_in <= "0000000000011111";
            end if;
        elsif type_decor = "11" then
            if (((x = x0 + 3) OR (x = x0 + 4)) and (y <= y0 + 2)) then  
                pix_data_in <= "1000001000000000";
            elsif  (x >= x0 + 1) and (x <= x0 + 6) and (y <= y0 + 6) and (y >= y0 + 4) then
                pix_data_in <= "0000010000000000";
            elsif (x >= x0 + 2) and (x <= x0 + 5) and ((y = y0+3) or (y = y0+7)) then
                pix_data_in <= "0000010000000000";           
            elsif ((x = x0) OR (x = x0+7)) and y = y0 + 5 then
                pix_data_in <= "0000010000000000";
            else
                pix_data_in <= "0000000000011111";
            end if;
         end if;
     end if;
end process;       
                
                
                
end Behavioral;
