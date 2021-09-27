library ieee;
use ieee.std_logic_1164.all;

package ilt_pkg is

  constant PADDR_WIDTH : integer := 32;
  constant PDATA_WIDTH : integer := 32;

  component ilt_apb is
    generic (
      PADDR_WIDTH : integer;
      PDATA_WIDTH : integer);
    port (
      pclk    : in  std_logic;
      presetn : in  std_logic;
      paddr   : in  std_logic_vector(PADDR_WIDTH-1 downto 0);
      pselx   : in  std_logic;
      penable : in  std_logic;
      pwrite  : in  std_logic;
      pwdata  : in  std_logic_vector(PDATA_WIDTH-1 downto 0);
      pready  : out std_logic;
      prdata  : out std_logic_vector(PDATA_WIDTH-1 downto 0);
      pslverr : out std_logic;

      core_id : in  std_logic_vector(PDATA_WIDTH-1 downto 0));
  end component ilt_apb;

end package ilt_pkg;
