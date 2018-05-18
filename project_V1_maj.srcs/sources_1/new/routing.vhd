----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.11.2017 10:39:57
-- Design Name: 
-- Module Name: routing - Behavioral
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
--      Module de routage liant les blocs constituant le projet entre eux
------------------------------------------------




library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity routing is
  Port (horloge : in std_logic;
        reset : in std_logic;
        bouton_gauche: in std_logic;
        bouton_droit: in std_logic;
        bouton_haut : in std_logic;
        bouton_centre : in std_logic;
        bouton_bas : in std_logic;
        --oled
        PMOD_CS : out std_logic;
        PMOD_MOSI : out std_logic;
        PMOD_SCK : out std_logic;
        PMOD_DC : out std_logic;
        PMOD_RES : out std_logic;
        PMOD_VCCEN : out std_logic;
        PMOD_EN : out std_logic;
        --jstk
        JMISO : in  STD_LOGIC;								-- Master In Slave Out, JA3
        JSW : in  STD_LOGIC_VECTOR (2 downto 0);        -- Switches 2, 1, and 0
        JSS : out  STD_LOGIC;                                -- Slave Select, Pin 1, Port JA
        JMOSI : out  STD_LOGIC;                            -- Master Out Slave In, Pin 2, Port JA
        JSCLK : out  STD_LOGIC;                            -- Serial Clock, Pin 4, Port JA
        JLED : out  STD_LOGIC_VECTOR (2 downto 0);    -- LEDs 2, 1, and 0
        JAN : out  STD_LOGIC_VECTOR (3 downto 0);    -- Anodes for Seven Segment Display
        JSEG : out  STD_LOGIC_VECTOR (6 downto 0)); -- Cathodes for Seven Segment Display
end routing;

architecture Behavioral of routing is


------------------------------------------------------- Components -----------------------------------------------------------------

component descente is
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
end component;

component gestion_input is
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
end component;
 
 
component gestion_clock is
Port (clock : in std_logic;
        raz : in std_logic;
        clk_rafraichissement : out std_logic;
        clk_affichage : out std_logic;
        clk_aff_voiture: out std_logic;
        clk_mouvement : out std_logic;
        signal_etat : in std_logic_vector (1 downto 0);
        clk_bouton : out std_logic);
end component;

component master is
    Port ( clock : in STD_LOGIC;
           raz : in STD_LOGIC;
           fin_jeu : in STD_LOGIC;
           bouton : in STD_LOGIC;
           signal_etat : out STD_LOGIC_VECTOR (1 downto 0));
end component;


component nouv_decors is
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
end component;


component coor_voiture is
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

component mux is
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
end component;

component menu is
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           pix_col_menu : out STD_LOGIC_VECTOR (6 downto 0);
           pix_row_menu : out STD_LOGIC_VECTOR (5 downto 0);
           pix_data_in_menu : out STD_LOGIC_VECTOR (15 downto 0);
           etat : in std_logic_vector(1 downto 0));
end component;

component game_over is
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           pix_col_gameover : out STD_LOGIC_VECTOR (6 downto 0);
           pix_row_gameover : out STD_LOGIC_VECTOR (5 downto 0);
           pix_data_in_gameover : out STD_LOGIC_VECTOR (15 downto 0);
           centaine : in std_logic_vector (3 downto 0);
           dizaine : in std_logic_vector (3 downto 0);
           unite : in std_logic_vector (3 downto 0);
           etat : in std_logic_vector(1 downto 0));
end component;


component pmodoledrgb_bitmap is
    Generic (CLK_FREQ_HZ : integer := 100000000;        -- by default, we run at 100MHz
         BPP         : integer range 1 to 16 := 16; -- bits per pixel
         GREYSCALE   : boolean := False;            -- color or greyscale ? (only for BPP>6)
         LEFT_SIDE   : boolean := False);           -- True if the Pmod is on the left side of the board
    Port (clk          : in  STD_LOGIC;
          reset        : in  STD_LOGIC;
          
          pix_write    : in  STD_LOGIC;
          pix_col      : in  STD_LOGIC_VECTOR(    6 downto 0);
          pix_row      : in  STD_LOGIC_VECTOR(    5 downto 0);
          pix_data_in  : in  STD_LOGIC_VECTOR(BPP-1 downto 0);
          pix_data_out : out STD_LOGIC_VECTOR(BPP-1 downto 0);
          
          PMOD_CS      : out STD_LOGIC;
          PMOD_MOSI    : out STD_LOGIC;
          PMOD_SCK     : out STD_LOGIC;
          PMOD_DC      : out STD_LOGIC;
          PMOD_RES     : out STD_LOGIC;
          PMOD_VCCEN   : out STD_LOGIC;
          PMOD_EN      : out STD_LOGIC);          
end component;


component PmodJSTK_Demo is
    Port ( CLK : in  STD_LOGIC;								-- 100Mhz onboard clock
           RST : in  STD_LOGIC;								-- Button D
           MISO : in  STD_LOGIC;								-- Master In Slave Out, JA3
           SW : in  STD_LOGIC_VECTOR (2 downto 0);		-- Switches 2, 1, and 0
           SS : out  STD_LOGIC;								-- Slave Select, Pin 1, Port JA
           MOSI : out  STD_LOGIC;							-- Master Out Slave In, Pin 2, Port JA
           SCLK : out  STD_LOGIC;							-- Serial Clock, Pin 4, Port JA
           LED : out  STD_LOGIC_VECTOR (2 downto 0);	-- LEDs 2, 1, and 0
           AN : out  STD_LOGIC_VECTOR (3 downto 0);	-- Anodes for Seven Segment Display
           position : out STD_LOGIC_VECTOR (9 downto 0);
           SEG : out  STD_LOGIC_VECTOR (6 downto 0)); -- Cathodes for Seven Segment Display
end component;


---------------------------------------------- Signaux ---------------------------------------------


signal si_raz          :  STD_LOGIC;
signal si_orologio     :  STD_LOGIC;
signal si_clk_aff      :  STD_LOGIC;
signal si_clk_aff_voiture : std_logic;
signal si_clk_mouvement : std_logic;
signal si_clk_rafraichissement : std_logic; 
signal si_clk_bouton : std_logic;
--boutons
signal si_bouton_gauche     :  STD_LOGIC; 
signal si_bouton_droit     :  STD_LOGIC;
signal si_bouton_centre     :  STD_LOGIC;
signal si_bouton_haut     :  STD_LOGIC;
signal si_bouton_bas     :  STD_LOGIC;
signal si_gauche : std_logic;
signal si_droite : std_logic;
signal si_centre : std_logic;
signal si_haut : std_logic;
signal si_bas : std_logic;


--Signaux pour l'écran OLED
signal si_PMOD_CS      :  STD_LOGIC;
signal si_PMOD_MOSI    :  STD_LOGIC;
signal si_PMOD_SCK     :  STD_LOGIC;
signal si_PMOD_DC      :  STD_LOGIC;
signal si_PMOD_RES     :  STD_LOGIC;
signal si_PMOD_VCCEN   :  STD_LOGIC;
signal si_PMOD_EN      :  STD_LOGIC;   
signal si_pix_data_out :  std_logic_vector(15 downto 0);


--signaux pour les modules de jeux
signal si_pix_col      :  std_logic_vector(6 downto 0);
signal si_pix_row      :  std_logic_vector(5 downto 0);
signal si_pix_data_in  :  std_logic_vector(15 downto 0);
signal si_pix_col_jeu      :  std_logic_vector(6 downto 0);
signal si_pix_row_jeu      :  std_logic_vector(5 downto 0);
signal si_pix_data_in_jeu  :  std_logic_vector(15 downto 0);
signal si_pix_col_menu      :  std_logic_vector(6 downto 0);
signal si_pix_row_menu      :  std_logic_vector(5 downto 0);
signal si_pix_data_in_menu  :  std_logic_vector(15 downto 0);
signal si_pix_col_gameover      :  std_logic_vector(6 downto 0);
signal si_pix_row_gameover      :  std_logic_vector(5 downto 0);
signal si_pix_data_in_gameover  :  std_logic_vector(15 downto 0);
signal si_etat           :  std_logic_vector(1 downto 0);
signal si_fin_jeu           : std_logic ;
signal si_nouv_game        : std_logic;
signal si_score         : std_logic_vector (10 downto 0);
signal si_centaine      : std_logic_vector (3 downto 0);
signal si_dizaine       : std_logic_vector (3 downto 0);
signal si_unite         : std_logic_vector (3 downto 0);

signal si_pix_write    :  std_logic;
signal si_type_decor   :  std_logic_vector(1 downto 0);
signal si_coor_row     :  std_logic_vector(2 downto 0);
signal si_coor_col     :  std_logic_vector(3 downto 0);
signal si_coor_voiture :  std_logic_vector(2 downto 0);


--signaux pour le joystick
signal si_JMISO : std_logic;
signal si_JSW : std_logic_vector (2 downto 0);
signal si_JSS : std_logic;
signal si_JMOSI : std_logic;
signal si_JSCLK : std_logic;
signal si_JLED : std_logic_vector (2 downto 0);
signal si_JAN : std_logic_vector (3 downto 0);
signal si_JSEG : std_logic_vector (6 downto 0);
signal si_jposition : std_logic_vector (9 downto 0);

------------------------------------------------- Routing ----------------------------------------

    
begin

si_orologio <= horloge;
si_raz <= reset;
si_bouton_gauche <= bouton_gauche;
si_bouton_droit <= bouton_droit;
si_bouton_haut <= bouton_haut;
si_bouton_centre <= bouton_centre;
si_bouton_bas <= bouton_bas;

--JSTK
si_JMISO <= JMISO;
si_JSW <= JSW;

inst1 : descente port map(clock => si_orologio,
                          raz => si_raz,
                          clk_aff => si_clk_aff,
                          coor_col => si_coor_col,
                          coor_row => si_coor_row,
                          type_decor => si_type_decor,
                          pix_col => si_pix_col_jeu,
                          pix_row => si_pix_row_jeu,
                          pix_data_in => si_pix_data_in_jeu,
                          etat => si_etat);
                          
                          
inst2 : pmodoledrgb_bitmap generic map(CLK_FREQ_HZ => 100000000,        
                                       BPP         => 16,              
                                       GREYSCALE   => false,            
                                       LEFT_SIDE   => false)
                                               
                            port map (clk          => si_orologio,
                                      reset        => si_raz,
                                      pix_write    => si_pix_write,
                                      pix_col      => si_pix_col,
                                      pix_row      => si_pix_row,
                                      pix_data_in  => si_pix_data_in,
                                      pix_data_out => si_pix_data_out,
                                      PMOD_CS      => si_PMOD_CS,
                                      PMOD_MOSI    => si_PMOD_MOSI,
                                      PMOD_SCK     => si_PMOD_SCK,
                                      PMOD_DC      => si_PMOD_DC,
                                      PMOD_RES     => si_PMOD_RES,
                                      PMOD_VCCEN   => si_PMOD_VCCEN,
                                      PMOD_EN      => si_PMOD_EN); 
                                      
                                      
                                      
inst3 : nouv_decors port map (clock => si_orologio,
                              raz => si_raz,
                              clk_rafraichissement => si_clk_rafraichissement,
                              clk_affichage => si_clk_aff,
                              clk_aff_voiture => si_clk_aff_voiture,
                              type_decor => si_type_decor,
                              coor_col => si_coor_col,
                              coor_row => si_coor_row,
                              coor_voiture => si_coor_voiture,
                              etat => si_etat,
                              fin_jeu => si_fin_jeu,
                              centaine => si_centaine,
                              dizaine => si_dizaine,
                              unite => si_unite
                              );
                          
                          
inst4 : gestion_clock port map(clock => si_orologio,
                               raz => si_raz,
                               clk_rafraichissement => si_clk_rafraichissement,
                               clk_affichage => si_clk_aff,
                               clk_aff_voiture => si_clk_aff_voiture,
                               clk_mouvement => si_clk_mouvement,
                               signal_etat => si_etat,
                               clk_bouton => si_clk_bouton);
                               
inst5 : gestion_input port map (bouton_g => si_bouton_gauche,
                                bouton_d => si_bouton_droit,
                                bouton_h => si_bouton_haut,
                                bouton_c => si_bouton_centre,
                                bouton_b => si_bouton_bas,
                                clk => si_orologio,
                                clk_bouton => si_clk_bouton,
                                clk_aff_voiture => si_clk_aff_voiture,
                                raz => si_raz,
                                gauche => si_gauche,
                                centre => si_centre,
                                haut => si_haut,
                                bas => si_bas,
                                droite => si_droite);
                                    
                                    
inst6 : coor_voiture port map(clk_aff_voiture => si_clk_aff_voiture,
                              clk_mouvement => si_clk_mouvement,
                              clock => si_orologio,
                              raz => si_raz,
                              go_droite => si_droite,
                              go_gauche => si_gauche,
                              etat => si_etat,
                              position => si_Jposition,
                              coor_voiture => si_coor_voiture);                                    
                    
inst7 : mux port map(clk => si_orologio,
                     raz => si_raz,
                     etat => si_etat,
                     pix_col_jeu => si_pix_col_jeu,
                     pix_row_jeu => si_pix_row_jeu,
                     pix_data_in_jeu => si_pix_data_in_jeu,
                     pix_col_gameover => si_pix_col_gameover,
                     pix_row_gameover => si_pix_row_gameover,
                     pix_data_in_gameover => si_pix_data_in_gameover,
                     pix_col_menu => si_pix_col_menu,
                     pix_row_menu => si_pix_row_menu,
                     pix_data_in_menu => si_pix_data_in_menu,
                     pix_data_in => si_pix_data_in,
                     pix_col => si_pix_col,
                     pix_row => si_pix_row,
                     pix_write => si_pix_write);

inst8 : menu port map(clk => si_orologio,
                      raz => si_raz,
                      pix_col_menu => si_pix_col_menu,
                       pix_row_menu => si_pix_row_menu,
                       pix_data_in_menu => si_pix_data_in_menu,
                       etat => si_etat);

inst9 : game_over port map(clk => si_orologio,
                           raz => si_raz,
                           pix_col_gameover => si_pix_col_gameover,
                           pix_row_gameover => si_pix_row_gameover,
                           pix_data_in_gameover => si_pix_data_in_gameover,
                           centaine => si_centaine,
                           dizaine => si_dizaine,
                           unite => si_unite,
                           etat => si_etat);
                      
inst10 : master port map(clock => si_orologio,
                          raz => si_raz,
                          fin_jeu => si_fin_jeu,
                          bouton => si_centre,
                          signal_etat => si_etat);

inst11 : PmodJSTK_Demo port map(
                        CLK => si_orologio,
                        RST => si_raz,
                        MISO => si_JMISO,
                        SW => si_JSW,
                        SS => si_JSS,
                        MOSI => si_JMOSI,
                        SCLK => si_JSCLK,
                        LED => si_JLED,
                        AN => si_JAN,
                        position => si_Jposition,
                        SEG => si_JSEG
                        );




--OLED            
PMOD_CS <= si_PMOD_CS;
PMOD_MOSI <= si_PMOD_MOSI;
PMOD_SCK <= si_PMOD_SCK;
PMOD_DC <= si_PMOD_DC;
PMOD_RES <= si_PMOD_RES;
PMOD_VCCEN <= si_PMOD_VCCEN;
PMOD_EN <= si_PMOD_EN;


--JSTK
JSS <= si_JSS;
JMOSI <= si_JMOSI;
JSCLK <= si_JSCLK;
JLED <= si_JLED;
JAN <= si_JAN;
JSEG <= si_JSEG;

end Behavioral;
