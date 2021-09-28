library ieee;
use ieee.std_logic_1164.all;

use work.ilt_pkg.all;

entity ilt_register is
  port (
    clk  : in std_logic;
    nrst : in std_logic;
    wr   : in std_logic;
    d    : in  std_logic_vector(PDATA_WIDTH-1 downto 0);
    q    : out std_logic_vector(PDATA_WIDTH-1 downto 0)
    );
end entity ilt_register;

architecture rtl of ilt_register is

  signal reg : std_logic_vector(PDATA_WIDTH-1 downto 0) := (others => '0');

begin

  q <= reg;

  process (clk, nrst) is
  begin
    if nrst = '0' then
      reg <= (others => '0');
    elsif rising_edge(clk) then
      if wr = '1' then
        reg <= d;
      end if;
    end if;
  end process;

end architecture rtl;
