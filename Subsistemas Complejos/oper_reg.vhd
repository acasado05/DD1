--Autor: Aitor Casado de la Fuente
--Se trata de un circuito que carga datos de dos registros para comparar sus datos

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity oper_reg is
port(clk:    in std_logic;
     nRST:   in std_logic;
     ena_A:  in std_logic;
     ena_B:  in std_logic;
     sel:    in std_logic;
     A:      in std_logic_vector(3 downto 0);     
     B:      in std_logic_vector(3 downto 0);     
     D_out:  buffer std_logic_vector(3 downto 0)     
     ); 
end entity;


architecture rtl of oper_reg is 
  signal reg_A: std_logic_vector(3 downto 0);
  signal reg_B: std_logic_vector(3 downto 0);  
  signal A_gr_B: std_logic;
    
begin 
  -- [SECUENCIAL] Registro de 4 bits con habilitación activa a nivel alto
  -- paralelo - paralelo
  process(clk, nRST)
  begin
    if nRST = '0' then  
      reg_A <= "0000";
      
    elsif clk'event and clk = '1' then
      if ena_A = '1' then
       reg_A <= A;
       
      end if;
    end if;              
  end process;
  
  -- [SECUENCIAL] Registro de 4 bits con doble entrada de habilitación activas
  -- a nivel alto paralelo - paralelo
  process(clk, nRST)
  begin
    if nRST = '0' then  
      reg_B <= "0000";
      
    elsif clk'event and clk = '1' then
      if ena_B = '1' and A_gr_B = '1' then
       reg_B <= B;
       
      end if;
    end if;              
  end process;
  
  -- [COMBINACIONAL] Comparador de 4 bits que activa A_gr_B cuando el registro A es mayor que B
  process(reg_A, B)
  begin
    if reg_A > B then
      A_gr_B <= '1';
     
    else
      A_gr_B <= '0';
    
    end if;
  end process; 

  -- [COMBINACIONAL] Multiplexor con entrada de selección de 2 canales de 4 bit a 1 canal
  process(reg_A, reg_B, sel)
  begin
    if sel = '0' then
      D_out <= reg_A;
     
    else
      D_out <= reg_B;
    
    end if;
  end process; 

end rtl;


