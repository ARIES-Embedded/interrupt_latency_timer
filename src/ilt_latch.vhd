library ieee;
use ieee.std_logic_1164.all;

use work.ilt_pkg.all;

entity ilt_latch is
  port (
    clk   : in  std_logic;
    nrst  : in  std_logic;
    latch : in  std_logic;
    clr   : in  std_logic;
    d     : in  std_logic_vector(PDATA_WIDTH-1 downto 0);
    q     : out std_logic_vector(PDATA_WIDTH-1 downto 0);
    valid : out std_logic;
    ovwr  : out std_logic);
end entity ilt_latch;

architecture rtl of ilt_latch is

  signal vld : std_logic := '0';
  signal ovf : std_logic := '0';
  signal reg : std_logic_vector(PDATA_WIDTH-1 downto 0) := (others => '0');

begin

  ovwr <= ovf;
  valid <= vld;
  q <= reg;

  process (clk, nrst) is
  begin
    if nrst = '0' then
      vld <= '0';
      ovf <= '0';
      reg <= (others => '0');
    elsif rising_edge(clk) then
      if clr = '1' then
        vld <= '0';
        ovf <= '0';
      elsif latch = '1' then
        ovf <= vld;
        vld <= '1';
        reg <= d;
      end if;
    end if;
  end process;

end architecture rtl;
