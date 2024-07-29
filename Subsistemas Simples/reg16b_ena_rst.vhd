-- Modelado de un registro de un registro de 16 bits con entrada de
-- habiltación activa a nivel alto y entrada de reset síncronoactiva a nivel alto

library ieee;
use ieee.std_logic_1164.all;

entity reg16b_ena_rst is
port(clk:  in std_logic;
     nRST: in std_logic;
     sRst: in std_logic;
     ena:  in std_logic;
     Din:  in std_logic_vector(15 downto 0);
     Dout: buffer std_logic_vector(15 downto 0));
end entity;


architecture rtl of reg16b_ena_rst is
begin

  process(clk,nRST)
  begin
    if nRST = '0' then
      Dout <= (others => '0');
    
    elsif clk'event and clk = '1' then
      if sRSt = '1' then
        Dout <= (others => '0');

      elsif ena = '1' then
        Dout <= Din;

      end if;
    end if;
  end process;
end rtl;
