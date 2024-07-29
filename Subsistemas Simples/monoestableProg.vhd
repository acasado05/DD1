--Autor: Aitor Casado
--Un monoestable es un circuito que mantiene su salida activa durante un determinado periodo de
--tiempo a partir del instante en que es disparado mediante la aplicaci?n de un pulso activo en su
--entrada de disparo (trigger). El tiempo que la se?al de salida permanece activa es un n?mero entero
--de ciclos de reloj. En el siguiente cronograma se ilustra el funcionamiento de un monoestable que
--genera un pulso que dura 4 ciclos de reloj.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity monoestable is
   port(nRST, clk, pulsador: in std_logic;
        pulse         : buffer std_logic
       );
end entity;

architecture rtl of monoestable is
  signal senal_confor: std_logic;
  signal trigger     : std_logic;
  signal contador    : std_logic_vector(25 downto 0);

  begin
------------------------------------
--          CONFORMADOR           --
------------------------------------
  proc_estado : process (nRST, clk)
  begin
    if nRST = '0' then
      senal_confor <= '0';

    elsif clk'event and clk = '1' then
      senal_confor <= pulsador;

    end if;
  end process proc_estado;

  trigger <= '1' when senal_confor = '0' and pulsador = '1' else
             '0';

------------------------------------
--          MONOESTABLE           --
------------------------------------
  proc_monoestable : process(nRST, clk)
  begin 
     if nRST = '0' then
       contador <= (others => '0');
     elsif clk'event and clk = '1' then
       -- if trg = '0' then //redisparable
       if trigger = '1' then -- no redisparable
         contador <= (0 => '1', others => '0');
       elsif pulse = '1' then
         if contador /= 47999999 then
           contador <= contador + 1;

         else 
           contador <= (others => '0');

         end if;
       end if;
     end if;
  end process proc_monoestable;

  pulse <= '1' when contador /= 0 else '0';

end rtl; 
