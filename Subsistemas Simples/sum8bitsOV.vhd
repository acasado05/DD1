-- Autor: Aitor Casado de la Fuente

library ieee;                    
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 

entity sum8bits is    
port(C_in:  in     std_logic;
     A:     in     std_logic_vector(7 downto 0);
     B:     in     std_logic_vector(7 downto 0);
     S:     buffer std_logic_vector(7 downto 0);
     C_out: buffer std_logic;
     OV:    buffer std_logic
    );
end entity; 

architecture rtl of sum8bits is
signal S_aux: std_logic_vector(8 downto 0);

begin
    S_aux <= ('0' & A) + ('0' & B) + C_in;
    C_out <= S_aux(8); --Asignamos el bit + significativo
    S <= S_aux(7 downto 0); --Sin el bit + significativo

    OV <= '1' when (A(7) = B(7)) and (A(7) /= S(7))
          else '0';

    
end rtl;
