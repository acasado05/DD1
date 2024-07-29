--Circuito que multiplica dos números de 8 bits
--Autor: Aitor Casado

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mult_8x8_seq is
port(clk:   in std_logic;
     nRst:  in std_logic;
     START: in std_logic;
     A:     in std_logic_vector(7 downto 0);
     B:     in std_logic_vector(7 downto 0);
     FIN:   buffer std_logic;
     MULT:  buffer std_logic_vector(15 downto 0)
     );
end entity mult_8x8_seq;

architecture rtl of mult_8x8_seq is

--Señales selectores
  signal SEL_MDOR, SEL_MNDO : std_logic;
  signal MNDO, MDOR         : std_logic_vector(3 downto 0);

--Señales multiplicador
  signal RES, RES1, RES2, RES3, RES4: std_logic_vector(7 downto 0);

--Señales registros
  signal REG0, REG1, REG2, REG3 : std_logic_vector(7 downto 0);
  signal WE: std_logic;
--  signal AUX_REG: std_logic_vector(1 downto 0);

--Señales para el autómata 
  type t_estado is(INI, PLL, PLH, PHL, PHH, FIN_RESULTADO);
  signal estado: t_estado;
--  signal AUX_OUT: std_logic_vector(3 downto 0);

begin

------------------------
--     SELECTORES     --
------------------------
MNDO <= B(3 downto 0) when SEL_MNDO = '0' else --Multiplicando
        B(7 downto 4);

MDOR <= A(3 downto 0) when SEL_MDOR = '0' else --Mutiplicador
        A(7 downto 4);

------------------------
--      MULT_4x4      --
------------------------
--El producto del valor del peso de cada bit del multiplicador (1, 2, 4 y 8) por el multiplicando, 
--si bit del multiplicador vale 1, o 0, si el bit del multiplicador vale 0

-- BARREL SHIFTER
RES1 <= "0000" & MDOR      when MNDO(0) = '1' else (others => '0');
RES2 <= "000" & MDOR & '0' when MNDO(1) = '1' else (others => '0');
RES3 <= "00" & MDOR & "00" when MNDO(2) = '1' else (others => '0');
RES4 <= '0' & MDOR & "000" when MNDO(3) = '1' else (others => '0');

RES <= RES1 + RES2 + RES3 + RES4;

------------------------
--     REGISTROS      --
------------------------
--AUX_REG <= SEL_MNDO & SEL_MDOR; --Cuando 00 -> REG0, 01 -> REG1...
--SEL_MNDO <= AUX_REG(1);
--SEL_MDOR <= AUX_REG(0);

PROC_REG : process(clk, nRst)
begin
  if nRst = '0' then
    REG0 <= (others => '0');
    REG1 <= (others => '0');
    REG2 <= (others => '0');
    REG3 <= (others => '0');

  elsif clk'event and clk = '1' then
    if WE = '1' then
      if SEL_MNDO = '0' and SEL_MDOR = '0' then
        REG0 <= RES;

      elsif SEL_MNDO = '0' and SEL_MDOR = '1' then
        REG1 <= RES;

      elsif SEL_MNDO = '1' and SEL_MDOR = '0' then
        REG2 <= RES;

      elsif SEL_MNDO = '1' and SEL_MDOR = '1' then
        REG3 <= RES;

      end if;
    end if;
  end if;
end process PROC_REG;

-----------------------------
-- CALCULO MULTIPLICACION  --
-----------------------------
MULT <= ("00000000" & REG0) + ("0000" & REG1 & "0000") + ("0000" & REG2 & "0000") + (REG3 & "00000000");

-----------------------------
--      CONTROLADOR        --
-----------------------------

PROC_CONTROLADOR : process(nRst, clk)
begin
  if nRst = '0' then
    estado <= INI;

  elsif clk'event and clk = '1' then 
    case estado is
      when INI =>
        if START = '1' then
         estado <= PLL;
        end if;

      when PLL =>
    --    if START = '1' then
          estado <= PLH;
    --    end if;

      when PLH =>
     --   if START = '1' then
          estado <= PHL;
     --   end if;

      when PHL =>
     --   if START = '1' then
          estado <= PHH;
    --    end if;

      when PHH =>
    --    if START = '1' then
          estado <= FIN_RESULTADO;
    --    end if;

      when FIN_RESULTADO =>
    --   if START = '0' then
          estado <= INI;
    --    end if;

    end case;
  end if;
end process PROC_CONTROLADOR;

-----------------------------
-- SALIDAS DEL CONTROLADOR --
-----------------------------
--AUX_OUT <= WE & SEL_MDOR & SEL_MNDO & FIN;
--WE <= AUX_OUT(3);
--SEL_MDOR <= AUX_OUT(2);
--SEL_MNDO <= AUX_OUT(1);
--FIN <= AUX_OUT(0); 

--AUX_OUT <= "0000" when estado = INI and START = '1' else
--           "1000" when estado = PLL and START = '1' else
--           "1010" when estado = PLH and START = '1' else
--           "1100" when estado = PHL and START = '1' else
--           "1110" when estado = PHH and START = '1' else
--           "0001" when estado = FIN_RESULTADO and START = '0' else
--           "XXXX";

proc_salidas: process(estado)
begin
    if estado = INI then
      WE<='0'; SEL_MDOR<='0'; SEL_MNDO<='0'; FIN<='0';

    elsif estado = PLL then
      WE<='1'; SEL_MDOR<='0'; SEL_MNDO<='0'; FIN<='0';

    elsif estado = PLH then
      WE<='1'; SEL_MDOR<='0'; SEL_MNDO<='1'; FIN<='0';

    elsif estado = PHL then
      WE<='1'; SEL_MDOR<='1'; SEL_MNDO<='0'; FIN<='0';

    elsif estado = PHH then
        WE<='1'; SEL_MDOR<='1'; SEL_MNDO<='1'; FIN<='0';

    elsif estado = FIN_RESULTADO then
        WE<='0'; SEL_MDOR<='0'; SEL_MNDO<='0'; FIN<='1';

    end if;
end process proc_salidas;
            
end rtl;
