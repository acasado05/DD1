library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity monoestables is
port(clk  : in std_logic;
     nRst : in std_logic;
     trig : in std_logic;
     pulse: in std_logic);
end entity monoestables;

architecture rtl of monoestables is
    signal cuenta: std_logic_vector(3 downto 0);

begin
  process(nRst,clk)
  begin
    if nRst = '0' then
      cuenta <= "0000";

    elsif clk'event and clk = '1' then
      if trig = '1' then
        cuenta <= "0001";

      elsif pulse = '1' then
        if cuenta /= 8 then
          cuenta <= cuenta + 1;
          
        else
          cuenta <= "0000";
        end if;
      end if;
    end if;
  end process;

  pulse <= '1' when cuenta /= 0 else '0';
end rtl;