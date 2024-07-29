-- Autor: Aitor Casado de la Fuente
-- Conformador de pulsos

library ieee;
use ieee.std_logic_1164.all;

entity conformador is
  port ( clk, an_rst : in     std_logic;
         e           : in     std_logic;
         s           : buffer std_logic
         );
end entity conformador;

architecture rtl of conformador is
   signal Q_i: std_logic;

begin

-- Memoria de estado
proc_estado: process (an_rst, clk)
begin
  if an_rst = '0' then
    Q_i <= '0';

  elsif clk'event and clk = '1' then
    Q_i <= e;

  end if;
end process proc_estado;

-- Calculo de la salida
proc_salida: process (Q_i, e)
begin
   if e = '1' and Q_i = '0' then
     s <= '1';

   else
     s <= '0';

   end if; 
end process proc_salida;

end architecture rtl;
