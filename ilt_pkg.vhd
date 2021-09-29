library ieee;
use ieee.std_logic_1164.all;

package ilt_pkg is

  constant PADDR_WIDTH : integer := 32;
  constant PDATA_WIDTH : integer := 32;

  type reg_block_t is array (natural range <>) of std_logic_vector(PDATA_WIDTH-1 downto 0);

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

      core_id : in  std_logic_vector(PDATA_WIDTH-1 downto 0);

      mctrl_w    : out std_logic;
      mctrl_data : in std_logic_vector(PDATA_WIDTH-1 downto 0);

      d_w    : out std_logic_vector(3 downto 0);
      d_data : in  reg_block_t(0 to 3);

      frt_latch_l : in  std_logic_vector(PDATA_WIDTH-1 downto 0);
      frt_latch_h : in  std_logic_vector(PDATA_WIDTH-1 downto 0);
      frt_latch_l_r : out std_logic;
      frt_latch_h_r : out std_logic;

      ack_w        : out std_logic;
      latch_status : in  std_logic_vector(PDATA_WIDTH-1 downto 0);
      irq_count    : in  std_logic_vector(PDATA_WIDTH-1 downto 0);
      ack0_miss    : in  std_logic_vector(PDATA_WIDTH-1 downto 0);
      ack3_miss    : in  std_logic_vector(PDATA_WIDTH-1 downto 0);

      latchx   : in  reg_block_t(0 to 3);
      latchx_r : out std_logic_vector(3 downto 0)
      );
  end component ilt_apb;

  component ilt_register is
    port (
      clk  : in std_logic;
      nrst : in std_logic;
      wr   : in std_logic;
      d    : in  std_logic_vector(PDATA_WIDTH-1 downto 0);
      q    : out std_logic_vector(PDATA_WIDTH-1 downto 0)
      );
  end component ilt_register;

  component ilt_frt is
    port (
      clk   : in  std_logic;
      nrst  : in  std_logic;
      cnt_h : out std_logic_vector(PDATA_WIDTH-1 downto 0);
      cnt_l : out std_logic_vector(PDATA_WIDTH-1 downto 0));
  end component ilt_frt;

  component ilt_latch is
    port (
      clk   : in  std_logic;
      nrst  : in  std_logic;
      latch : in  std_logic;
      clr   : in  std_logic;
      d     : in  std_logic_vector(PDATA_WIDTH-1 downto 0);
      q     : out std_logic_vector(PDATA_WIDTH-1 downto 0);
      valid : out std_logic;
      ovwr  : out std_logic);
  end component ilt_latch;

  component ilt_delay_cnt is
    port (
      clk  : in  std_logic;
      nrst : in  std_logic;
      mode : in  std_logic_vector(1 downto 0);
      d    : in  std_logic_vector(PDATA_WIDTH-1 downto 0);
      start: in  std_logic;
      ack0 : in  std_logic;
      ack3 : in  std_logic;
      run  : out std_logic;
      done : out std_logic);
  end component ilt_delay_cnt;

  component ilt_latency_cnt is
    port (
      clk  : in  std_logic;
      nrst : in  std_logic;
      start: in  std_logic;
      stop : in  std_logic;
      run  : out std_logic;
      q    : out std_logic_vector(PDATA_WIDTH-1 downto 0));
  end component ilt_latency_cnt;

  component ilt_counter is
    port (
      clk  : in  std_logic;
      nrst : in  std_logic;
      clr  : in  std_logic;
      en   : in  std_logic;
      q    : out std_logic_vector(PDATA_WIDTH-1 downto 0));
  end component ilt_counter;

end package ilt_pkg;
