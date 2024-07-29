--Autor: Aitor Casado

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cont_bcd_7seg_habcp is
port(clk, nRst  : in std_logic;
    pulso_hab   : in std_logic;
    disp_7seg   : buffer std_logic_vector(6 downto 0)
    );
end entity cont_bcd_7seg_habcp;

architecture rtl of cont_bcd_7seg_habcp is
signal Q      : std_logic; 
signal digBCD : std_logic_vector(3 downto 0);
signal s_Cin  : std_logic;
signal s_Cout : std_logic;

begin

-----------------------------------------------
--               CONFORMADOR
-----------------------------------------------
proc_estado : process(nRst,clk)
begin
  if nRst = '0' then
    Q <= '1';
  elsif clk'event and clk = '1' then
    Q <= pulso_hab;
  end if;
end process proc_estado;

proc_salida : process(Q, pulso_hab)
begin
   if pulso_hab = '0' and Q = '1' then
     s_Cin <= '1';
   else
     s_Cin <= '0';
   end if; 
end process proc_salida;

-----------------------------------------------
--               CONTADOR BCD
-----------------------------------------------
proc_cnt : process(nRst, clk)
begin
  if nRst = '0' then
    digBCD <= X"0";
  elsif clk'event and clk = '1' then
    if s_Cin = '1' then
      if s_Cout = '1' then
        digBCD <= "0000";
      else
        digBCD <= digBCD + 1;
      end if;
    end if;
  end if;
end process proc_cnt;

s_Cout <= '1' when digBCD = "1001" else '0';
-----------------------------------------------
--               BCD A 7 SEG
-----------------------------------------------
proc_bcd7seg : process(digBCD)
begin
    case digBCD is
     when "0000" => disp_7seg <= "0000001";
     when "0001" => disp_7seg <= "1001111";
     when "0010" => disp_7seg <= "0010010"; 
     when "0011" => disp_7seg <= "0000110"; 
     when "0100" => disp_7seg <= "1001100"; 
     when "0101" => disp_7seg <= "0100100"; 
     when "0110" => disp_7seg <= "0100000"; 
     when "0111" => disp_7seg <= "0001111"; 
     when "1000" => disp_7seg <= "0000000"; 
     when "1001" => disp_7seg <= "0001100"; 
     when others => disp_7seg <= "XXXXXXX";
    end case;
	
end process proc_bcd7seg;
end rtl;
