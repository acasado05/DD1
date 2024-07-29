-- Modelado de un restador de 4 bits

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; --Realizar operaciones aritméticas

entity rest4bits is
port(A: in      std_logic_vector(3 downto 0);
     B: in      std_logic_vector(3 downto 0);
     S: buffer  std_logic_vector(3 downto 0)
);
end entity;


architecture rtl of rest4bits is
begin
  S <= A + (not B) +1; --Sentencia concurrente que modela una resta
                       --en CA2. (not -> std_logic_1164)

end rtl;
