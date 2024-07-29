--Autor: Aitor Casado

-- Decodificador de BCD a 7 segmentos

library ieee;
use ieee.std_logic_1164.all;

entity decodBCD7seg is
port(digBCD:   in std_logic_vector(3 downto 0);
     segDisp: buffer std_logic_vector(6 downto 0)
);
end entity;

architecture rtl of decodBCD7seg is
begin
  process(digBCD)
  begin
    case digBCD is
     when "0000" =>
       segDisp <= "1111110";
     when "0001" =>
       segDisp <= "0110000";
     when "0010" =>
       segDisp <= "1101101";
     when "0011" =>
       segDisp <= "1111001";
     when "0100" =>
       segDisp <= "0110011";
     when "0101" =>
       segDisp <= "1011011";
     when "0110" =>
       segDisp <= "1011111";
     when "0111" =>
       segDisp <= "1110000";
     when "1000" =>
       segDisp <= "1111111";
     when "1001" =>
       segDisp <= "1110011";
     when others =>
       segDisp <= "XXXXXXX";
    end case;
   end process;
end rtl;
