library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity SSD_DISPLAY is
  Port (
    RESET: IN STD_LOGIC;
    CLK100: IN STD_LOGIC;
    NUM1, NUM2, NUM3: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    CATODE: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
    ANODE: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    ENABLE_NUM1, ENABLE_NUM2, ENABLE_NUM3: IN STD_LOGIC
  );
end SSD_DISPLAY;

architecture Behavioral of SSD_DISPLAY is

  COMPONENT HEX_DECODER IS
    PORT (
      NUM: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      NUM_SSD: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL SEL: STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL COUNT: STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
  SIGNAL NUM: STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL NUM_SSD: STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN
  DCD: HEX_DECODER PORT MAP(NUM => NUM, NUM_SSD => NUM_SSD);
  CNT: PROCESS(CLK100)
  BEGIN
    IF RISING_EDGE(CLK100) THEN
      COUNT <= COUNT + 1;
    END IF;
  END PROCESS;
  SEL <= COUNT(15 DOWNTO 14);
  ANOD: PROCESS(SEL)
  BEGIN
    CASE SEL IS
      WHEN "00" => ANODE <= "1110";
      WHEN "01" => ANODE <= "1101";
      WHEN "10" => ANODE <= "1011";
      WHEN "11" => ANODE <= "0111";
      WHEN OTHERS => ANODE <= "1111";
    END CASE;
  END PROCESS;
CATOD: PROCESS(CLK100)
  BEGIN
    IF RISING_EDGE(CLK100) THEN
      IF RESET = '1' THEN
        CATODE <= "1111111";
      ELSE
        CASE SEL IS
          WHEN "00" =>
            IF ENABLE_NUM1 = '1' THEN
              NUM <= NUM1;
              CATODE <= NUM_SSD;
            ELSE
              CATODE <= "1111111";
            END IF;
          WHEN "01" =>
            IF ENABLE_NUM2 = '1' THEN
              NUM <= NUM2;
              CATODE <= NUM_SSD;
            ELSE
              CATODE <= "1111111";
            END IF;
          WHEN "10" =>
            IF ENABLE_NUM3 = '1' THEN
              NUM <= NUM3;
              CATODE <= NUM_SSD;
            ELSE
              CATODE <= "1111111";
            END IF;
          WHEN OTHERS =>
            NUM <= "0000";
            CATODE <= "1111111";
        END CASE;
      END IF;
    END IF;
END PROCESS;
end Behavioral;