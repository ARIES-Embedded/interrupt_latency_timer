library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ilt_pkg.all;

entity ilt_counter is
  port (
    clk  : in  std_logic;
    nrst : in  std_logic;
    clr  : in  std_logic;
    en   : in  std_logic;
    q    : out std_logic_vector(PDATA_WIDTH-1 downto 0));
end entity ilt_counter;

architecture rtl of ilt_counter is

  signal cnt : std_logic_vector(PDATA_WIDTH-1 downto 0) := (others => '0');

begin

  process (clk, nrst) is
  begin
    if nrst = '0' then
      cnt <= (others => '0');
    elsif rising_edge(clk) then
      if clr = '1' then
        cnt <= (others => '0');
      elsif en = '1' then
        cnt <= std_logic_vector(unsigned(cnt) + 1);
      end if;
    end if;
  end process;

  q <= cnt;

end architecture rtl;
