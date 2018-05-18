----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.01.2018 18:43:58
-- Design Name: 
-- Module Name: trans_score - Behavioral
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

entity trans_score is
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           etat : in std_logic_vector (1 downto 0);
           score : in STD_LOGIC_VECTOR (10 downto 0);
           centaine : out STD_LOGIC_VECTOR (3 downto 0);
           dizaine : out STD_LOGIC_VECTOR (3 downto 0);
           unite : out STD_LOGIC_VECTOR (3 downto 0));
end trans_score;

architecture Behavioral of trans_score is

signal si_score : integer;
signal si_centaine : integer range 0 to 9;
signal si_dizaine : integer range 0 to 9;
signal si_unite : integer range 0 to 9;


begin

si_score <= to_integer(unsigned(score),11);


if rising_edge(clk) then
    if etat = "10" then
        if si_score < 100 then
            
    
centaine <= "0010";
dizaine <= "0110";
unite <= "1001";

end Behavioral;
