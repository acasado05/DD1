--Subsistema complejo que desplaza la barra de LEDs de la tarjeta MAX1000 en función del pulsador a la entrada
--Autor: Aitor Casado
--Fecha:28/10/23

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity complejo is
port(nRst, clk: in std_logic;
     P_1, P_2 : in std_logic;
     LEDs     : buffer std_logic_vector(7 downto 0);
     SEG      : buffer std_logic_vector(6 downto 0));
end entity complejo;

architecture rtl of complejo is

  -- Senales de ambos conformadores:
  signal MOD0     : std_logic;
  signal MEM_MOD0 : std_logic;
  signal SHIFT    : std_logic;
  signal MEM_SHIFT: std_logic;

  -- Se�ales del timer
  signal tic_1s    : std_logic;
  signal cnt_timer : std_logic_vector(23 downto 0);
  constant mod_cnt : natural := 12000000;
  --constant mod_cnt : natural := 4; -- Simualci�n

  -- Se�ales del registro de deesplazamiento
  signal ENA_SHIFT : std_logic;
  signal nL_R      : std_logic;

  --AUTOMATA
  type t_estado is (inicial_izq, inicial_dcha, izq, dcha);
  signal estado : t_estado;

begin

----------------------------------------
--  CONFORMADORES ACTIVOS NIVEL BAJO  --
----------------------------------------
-- NOTA: ambos conformadores son activos a nivel bajo debido a los pulsadores de la MAX1000
CONFORMADOR_MOD0: process(nRst, clk)
begin
  if nRst = '0' then
    MEM_MOD0 <= '1';
	 
  elsif clk'event and clk = '1' then
    MEM_MOD0 <= P_1;
	 
  end if;
end process CONFORMADOR_MOD0;

CONF_MOD0_OUT : MOD0 <= '1' when MEM_MOD0 = '1' and P_1 = '0' else
                        '0';

CONFORMADOR_SHIFT: process(nRst, clk)
begin
  if nRst = '0' then
    MEM_SHIFT <= '1';
	 
  elsif clk'event and clk = '1' then
    MEM_SHIFT <= P_2;
	 
  end if;
end process CONFORMADOR_SHIFT;

CONFORMADOR_SHIFT_OUT : SHIFT <= '1' when MEM_SHIFT = '1' and P_2 = '0' else
                                 '0';

-------------------------------
--        TIMER 12MHz        --
-------------------------------

TIMER_CNT : process(nRst, clk)
begin
  if nRst = '0' then
    cnt_timer <= (0 => '1', others => '0');
	 
  elsif clk'event and clk = '1' then
    if tic_1s = '1' then
      cnt_timer <= (0 => '1', others => '0');
		
    else
      cnt_timer <= cnt_timer + 1;
		
    end if;
  end if;
end process TIMER_CNT;

FDC_TIMER: tic_1s <= '1' when cnt_timer = mod_cnt else
                     '0';

-------------------------------
--         AUTOMATA          --
-------------------------------

 PROC_AUTOMATA : process(nRst, clk)
 begin
  if nRst = '0' then
    estado <= inicial_izq;
  elsif clk'event and clk = '1' then
    case estado is
      when inicial_izq =>
        if MOD0 = '1' then
          estado <= izq;
        elsif SHIFT = '1' then
          estado <= inicial_dcha;
        end if;
      when inicial_dcha =>
        if MOD0 = '1' then
          estado <= dcha;
			 
        elsif SHIFT = '1' then
          estado <= inicial_izq;
			 
        end if;
      when izq =>
        if MOD0 = '1' then
          estado <= inicial_izq;
			 
        end if;
		  
      when dcha =>
        if MOD0 = '1' then
          estado <= inicial_dcha;
			 
        end if;
    end case;
  end if;
 end process;

PROC_OUT: process(estado, SHIFT, tic_1s)
 begin
  case estado is
    when inicial_izq =>
      nL_R <= '1';
      if tic_1s = '1' then
        ENA_SHIFT <= '1';
      else
        ENA_SHIFT <= '0';
      end if;
    when inicial_dcha =>
      nL_R <= '0';
      if tic_1s = '1' then
        ENA_SHIFT <= '1';
      else
        ENA_SHIFT <= '0';
      end if;
    when izq =>
      nL_R <= '1';
      if SHIFT = '1' then
        ENA_SHIFT <= '1';
      else
        ENA_SHIFT <= '0';
      end if;
    when dcha =>
      nL_R <= '0';
      if SHIFT = '1' then
        ENA_SHIFT <= '1';
      else
        ENA_SHIFT <= '0';
      end if;
  end case;
 end process;

-----------------------------------------------------------------
-- REGISTRO DESPLAZAMIENTO 8 BITS ENA Y CONTROL DESPLAZAMIENTO --
-----------------------------------------------------------------

REG_DESP : process(nRst, clk)
begin
  if nRst = '0' then
    LEDs <= (0 => '1', others => '0');
	 
  elsif clk'event and clk = '1' then
    if ENA_SHIFT = '1' then
      if nL_R = '0' then -- Desplaza a izquierdas
        LEDs <= LEDs(6 downto 0) & LEDs(7);    

      else -- Desplaza a derechas
        LEDs <= LEDs(0) & LEDs(7 downto 1); 
		  
      end if;                         
    end if;
  end if;
end process REG_DESP;

-----------------------------------------------
-- CODIFICADOR DE LEDs a DISPLAY 7 SEGMENTOS --
-----------------------------------------------
-- *NOTA*: se modelar� mediante una sentencia concurrente

CODIFICADOR: SEG <= "1001111" when LEDs = 1   else --11000000
 					     "0010010" when LEDs = 2   else --11111001
 					     "0000110" when LEDs = 4   else --10100100
 					     "1001100" when LEDs = 8   else --10110000
 					     "0100100" when LEDs = 16  else --10011001
 					     "0100000" when LEDs = 32  else --10010010
					     "0001111" when LEDs = 64  else --10000010
					     "0000000" when LEDs = 128 else --11111000
					     "1111111";                     --11111111

end rtl;
