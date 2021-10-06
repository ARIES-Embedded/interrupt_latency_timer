library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ilt_pkg.all;

entity ilt_frt is
  port (
    clk   : in  std_logic;
    nrst  : in  std_logic;
    cnt_h : out std_logic_vector(PDATA_WIDTH-1 downto 0);
    cnt_l : out std_logic_vector(PDATA_WIDTH-1 downto 0));
end entity ilt_frt;

architecture rtl of ilt_frt is

  signal h, l : std_logic_vector(PDATA_WIDTH-1 downto 0) := (others => '0');

begin

  cnt_h <= h;
  cnt_l <= l;

  process (clk, nrst) is
  begin
    if nrst = '0' then
      h <= (others => '0');
      l <= (others => '0');
    elsif rising_edge(clk) then
      if l = x"ffffffff" then
        h <= std_logic_vector(unsigned(h) + 1);
      end if;
      l <= std_logic_vector(unsigned(l) + 1);
    end if;
  end process;

end architecture rtl;
