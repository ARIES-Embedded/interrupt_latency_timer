library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ilt_pkg.all;

entity ilt_latency_cnt is
  port (
    clk  : in  std_logic;
    nrst : in  std_logic;
    start: in  std_logic;
    stop : in  std_logic;
    run  : out std_logic;
    q    : out std_logic_vector(PDATA_WIDTH-1 downto 0));
end entity ilt_latency_cnt;

architecture rtl of ilt_latency_cnt is

  signal cnt : std_logic_vector(PDATA_WIDTH-1 downto 0) := (others => '0');
  signal en : std_logic := '0';

begin

  process (clk, nrst) is
  begin
    if nrst = '0' then
      en <= '0';
    elsif rising_edge(clk) then
      if start = '1' then
        en <= '1';
      elsif stop = '1' then
        en <= '0';
      end if;
    end if;
  end process;

  process (clk, nrst) is
  begin
    if nrst = '0' then
      cnt <= (others => '0');
    elsif rising_edge(clk) then
      if en = '0' then
        cnt <= (others => '0');
      else
        if not (cnt(PDATA_WIDTH-1 downto PDATA_WIDTH-4) = "1111") then
          cnt <= std_logic_vector(unsigned(cnt) + 1);
        end if;
      end if;
    end if;
  end process;

  run <= en;
  q <= cnt;

end architecture rtl;
