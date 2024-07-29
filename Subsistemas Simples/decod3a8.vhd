library ieee;
use ieee.std_logic_1164.all;

entity decod3a8 is
port(n_E: in     std_logic_vector(2 downto 0);
     n_S: buffer std_logic_vector(7 downto 0));
end entity;

architecture rtl of decod3a8 is
begin
  process(n_E)
  begin
    case n_E is
      when "111"  => n_S <= "11111110";
      when "110"  => n_S <= "11111101";
      when "101"  => n_S <= "11111011";
      when "100"  => n_S <= "11110111";
      when "011"  => n_S <= "11101111";
      when "010"  => n_S <= "11011111";
      when "001"  => n_S <= "10111111";
      when "000"  => n_S <= "01111101";
      when others => n_S <= "XXXXXXXX";
    end case;
  end process;
end rtl;
