library ieee;
use ieee.std_logic_1164.all;

use work.ilt_pkg.all;

entity ilt_apb is
  generic (
    PADDR_WIDTH : integer := PADDR_WIDTH;
    PDATA_WIDTH : integer := PDATA_WIDTH
    );
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

end entity ilt_apb;

architecture rtl of ilt_apb is

  type apb_state_t is (APB_IDLE_ST, APB_SETUP_ST, APB_ACCESS_ST);
  signal apb_state : apb_state_t := APB_IDLE_ST;
  signal apb_next  : apb_state_t;

begin

  prdata <= core_id;

  pslverr <= '0';

  process (pclk, presetn) is
  begin
    if presetn = '0' then
      apb_state <= APB_IDLE_ST;
    elsif rising_edge(pclk) then
      apb_state <= apb_next;
    end if;
  end process;

  process (apb_state, pselx, penable) is
  begin
    apb_next <= APB_IDLE_ST;
    pready <= '0';

    case apb_state is
      when APB_IDLE_ST =>
        if pselx = '1' then
          apb_next <= APB_SETUP_ST;
        end if;

      when APB_SETUP_ST =>
        apb_next <= APB_IDLE_ST;
        pready <= '1';

      when others => null;
    end case;
  end process;

end architecture rtl;
