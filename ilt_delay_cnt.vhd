library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ilt_pkg.all;

entity ilt_delay_cnt is
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
end entity ilt_delay_cnt;

architecture rtl of ilt_delay_cnt is

  type delay_cnt_state_t is (IDLE_ST, LOAD_ST, RUN_ST);
  signal cnt_state : delay_cnt_state_t := IDLE_ST;
  signal cnt_next  : delay_cnt_state_t;

  signal cnt : std_logic_vector(PDATA_WIDTH-1 downto 0) := (others => '1');
  signal cnt_load, cnt_en, cnt_done, cnt_msb : std_logic;

begin

  process (clk, nrst) is
  begin
    if nrst = '0' then
      cnt_state <= IDLE_ST;
    elsif rising_edge(clk) then
      cnt_state <= cnt_next;
    end if;
  end process;

  process (cnt_state, cnt_msb, mode, start, ack0, ack3) is
  begin
    cnt_load <= '0';
    cnt_en <= '0';
    cnt_done <= '0';

    case cnt_state is
      when IDLE_ST =>
        case mode is
          when "00" => cnt_next <= IDLE_ST;

          when "01" =>
            if start = '1' then
              cnt_next <= LOAD_ST;
            else
              cnt_next <= IDLE_ST;
            end if;

          when "10" =>
            if start = '1' or ack0 = '1' then
              cnt_next <= LOAD_ST;
            else
              cnt_next <= IDLE_ST;
            end if;

          when "11" =>
            if start = '1' or ack3 = '1' then
              cnt_next <= LOAD_ST;
            else
              cnt_next <= IDLE_ST;
            end if;

          when others => cnt_next <= IDLE_ST;
        end case;

      when LOAD_ST =>
        cnt_next <= RUN_ST;
        cnt_load <= '1';

      when RUN_ST =>
        cnt_en <= '1';
        if cnt_msb = '0' then
          cnt_next <= RUN_ST;
        else
          cnt_done <= '1';
          if mode = "01" then
            cnt_next <= LOAD_ST;
          else
            cnt_next <= IDLE_ST;
          end if;
        end if;

      when others =>
        cnt_next <= IDLE_ST;
    end case;
  end process;

  run <= cnt_en;
  done <= cnt_done;

  cnt_msb <= cnt(cnt'left);

  process (clk, nrst) is
  begin
    if nrst = '0' then
      cnt <= (others => '1');
    elsif rising_edge(clk) then
      if cnt_load = '1' then
        cnt <= d;
      elsif cnt_en = '1' and cnt_msb = '0' then
        cnt <= std_logic_vector(unsigned(cnt) - 1);
      end if;
    end if;
  end process;

end architecture rtl;
