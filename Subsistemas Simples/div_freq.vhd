--Autor: Aitor Casado de la Fuente

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity div_freq_4 is
port(clk:         in std_logic;
     nRst:        in std_logic;
     freq_div_4:  buffer std_logic
     );
end entity;

architecture rtl of div_freq_4 is
   signal Q_i: std_logic_vector(1 downto 0);

begin
  process(clk, nRst)
  begin
    if nRst = '0' then
      Q_i <= "00";

    elsif clk'event and clk = '1' then
      Q_i <= Q_i + 1;
    
    end if;
  end process;

  process(Q_i)
  begin
    if Q_i = "11" then
      freq_div_4 <= '1';

    else
      freq_div_4 <= '0';

    end if;
  end process;

end rtl;
