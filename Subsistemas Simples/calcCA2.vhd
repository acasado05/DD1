--Autor: Aitor Casado de la Fuente

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity calc_CA2 is
port(E:	in std_logic_vector(3 downto 0);
     S:	buffer std_logic_vector(3 downto 0)
     );
end entity;

architecture rtl of Calc_CA2 is
begin

S <= not(E) + 1 when E(3) = '1' else E;

end rtl;
