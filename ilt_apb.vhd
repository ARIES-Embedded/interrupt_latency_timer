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

    core_id : in  std_logic_vector(PDATA_WIDTH-1 downto 0);

    mctrl_w    : out std_logic;
    mctrl_data : in std_logic_vector(PDATA_WIDTH-1 downto 0);

    d_w    : out std_logic_vector(3 downto 0);
    d_data : in  reg_block_t(3 downto 0);

    frt_latch_l : in  std_logic_vector(PDATA_WIDTH-1 downto 0);
    frt_latch_h : in  std_logic_vector(PDATA_WIDTH-1 downto 0)
    );

end entity ilt_apb;

architecture rtl of ilt_apb is

  type apb_state_t is (APB_IDLE_ST, APB_SETUP_ST, APB_ACCESS_ST);
  signal apb_state : apb_state_t := APB_IDLE_ST;
  signal apb_next  : apb_state_t;

  signal apb_start : std_logic;
  signal apb_addr  : std_logic_vector(3 downto 0);  -- only bits used for decoding
  signal apb_rdata : std_logic_vector(PDATA_WIDTH-1 downto 0);

begin

  pslverr <= '0';

  -- APB state register
  process (pclk, presetn) is
  begin
    if presetn = '0' then
      apb_state <= APB_IDLE_ST;
    elsif rising_edge(pclk) then
      apb_state <= apb_next;
    end if;
  end process;

  -- APB state machine and output logic
  process (apb_state, pselx, penable) is
  begin
    apb_next <= APB_IDLE_ST;
    pready <= '0';
    apb_start <= '0';

    case apb_state is

      when APB_IDLE_ST =>
        if pselx = '1' then
          apb_next <= APB_SETUP_ST;
          apb_start <= '1';
        end if;

      when APB_SETUP_ST =>
        apb_next <= APB_ACCESS_ST;

      when APB_ACCESS_ST =>
        apb_next <= APB_IDLE_ST;
        pready <= '1';

      when others => null;
    end case;
  end process;

  -- APB address register
  process (pclk, presetn) is
  begin
    if presetn = '0' then
      apb_addr <= (others => '0');
    elsif rising_edge(pclk) then
      if apb_start = '1' then
        apb_addr <= paddr(5 downto 2);
      end if;
    end if;
  end process;

  -- Read data mux
  process (pclk, presetn) is
  begin
    if presetn = '0' then
      apb_rdata <= (others => '0');
    elsif rising_edge(pclk) then
      if pwrite = '0' and apb_state = APB_SETUP_ST then
        case apb_addr is
          when "0000" => apb_rdata <= core_id;
          when "0001" => apb_rdata <= mctrl_data;
          when "0010" => apb_rdata <= frt_latch_l;
          when "0011" => apb_rdata <= frt_latch_h;
          when "0100" => apb_rdata <= d_data(0);
          when "0101" => apb_rdata <= d_data(1);
          when "0110" => apb_rdata <= d_data(2);
          when "0111" => apb_rdata <= d_data(3);
          when others => apb_rdata <= (others => '0');
        end case;
      end if;
    end if;
  end process;

  prdata <= apb_rdata;

  -- Write strobes
  process (apb_addr, apb_state, pwrite) is
  begin
    mctrl_w <= '0';
    d_w <= (others => '0');

    if pwrite = '1' and apb_state = APB_ACCESS_ST then
      case apb_addr is
        when "0001" => mctrl_w <= '1';
        when "0100" => d_w(0) <= '1';
        when "0101" => d_w(1) <= '1';
        when "0110" => d_w(2) <= '1';
        when "0111" => d_w(3) <= '1';
        when others => null;
      end case;
    end if;
  end process;

end architecture rtl;
