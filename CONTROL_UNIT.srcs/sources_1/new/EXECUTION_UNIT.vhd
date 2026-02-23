library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity EXECUTION_UNIT is
  Port (
    FREE_OCCUPIED_LED     : out STD_LOGIC;
    ENTER_CHARACTERS_LED  : out STD_LOGIC;
    ADD_DIGIT             : in  STD_LOGIC;
    CNT_UP                : in  STD_LOGIC;
    CLK100                : in  STD_LOGIC;
    CNT_DN                : in  STD_LOGIC;
    RESET                 : in  STD_LOGIC;
    ANODE                 : out STD_LOGIC_VECTOR(3 DOWNTO 0);
    CATODE                : out STD_LOGIC_VECTOR(6 DOWNTO 0)
  );
end EXECUTION_UNIT;

architecture Behavioral of EXECUTION_UNIT is

COMPONENT C_U
    port(
      CLK                  : in  STD_LOGIC;
      ADD_DIGIT            : in  STD_LOGIC;
      VALIDATE_PIN         : inout STD_LOGIC;
      RESET                : in STD_LOGIC;
      FREE_OCCUPIED_LED    : inout STD_LOGIC;
      ENTER_CHARACTERS_LED : inout STD_LOGIC;
      COUNTER_RESET        : inout STD_LOGIC
    );
END COMPONENT;

COMPONENT DEBOUNCER1
    Port (
      CLK100MHZ : in STD_LOGIC;
      BUTTON    : in STD_LOGIC;
      BUTTON_DS : out STD_LOGIC
    );
END COMPONENT;

COMPONENT COUNTER
    Port (
      Q_OUT         : inout STD_LOGIC_VECTOR(3 DOWNTO 0);
      RESET         : in STD_LOGIC;
      CNT_UP        : in STD_LOGIC;
      CNT_DN        : in STD_LOGIC;
      CLK           : in STD_LOGIC;
      COUNTER_RESET : in STD_LOGIC
    );
END COMPONENT;

COMPONENT SSD_DISPLAY
    Port (
      RESET        : in  STD_LOGIC;
      CLK100       : in  STD_LOGIC;
      NUM1, NUM2, NUM3 : in STD_LOGIC_VECTOR(3 DOWNTO 0);
      CATODE       : out STD_LOGIC_VECTOR(6 DOWNTO 0);
      ANODE        : out STD_LOGIC_VECTOR(3 DOWNTO 0);
      ENABLE_NUM1, ENABLE_NUM2, ENABLE_NUM3 : in STD_LOGIC
    );
END COMPONENT;
SIGNAL COUNTER_OUT : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL DIGIT_INDEX : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
SIGNAL NUM1, NUM2, NUM3 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
SIGNAL MEM1, MEM2, MEM3 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
SIGNAL VALIDATE_PIN : STD_LOGIC := '0';
SIGNAL FREE_OCCUPIED, ENTER_CHARACTERS : STD_LOGIC;
SIGNAL ENABLE_NUM1, ENABLE_NUM2, ENABLE_NUM3 : STD_LOGIC := '0';
SIGNAL SEL : STD_LOGIC;
SIGNAL COUNTER_RESET : STD_LOGIC;

BEGIN
SSD: SSD_DISPLAY port map(
    RESET       => RESET,
    CLK100      => CLK100,
    NUM1        => NUM1,
    NUM2        => NUM2,
    NUM3        => NUM3,
    CATODE      => CATODE,
    ANODE       => ANODE,
    ENABLE_NUM1 => ENABLE_NUM1,
    ENABLE_NUM2 => ENABLE_NUM2,
    ENABLE_NUM3 => ENABLE_NUM3
  );
CONTROL: C_U port map(
    CLK                  => CLK100,
    ADD_DIGIT            => ADD_DIGIT,
    VALIDATE_PIN         => VALIDATE_PIN,
    RESET                => RESET,
    FREE_OCCUPIED_LED    => FREE_OCCUPIED,
    ENTER_CHARACTERS_LED => ENTER_CHARACTERS,
    COUNTER_RESET        => COUNTER_RESET
  );
CNT: COUNTER port map(
    Q_OUT         => COUNTER_OUT,
    RESET         => RESET,
    CNT_UP        => CNT_UP,
    CNT_DN        => CNT_DN,
    CLK           => CLK100,
    COUNTER_RESET => COUNTER_RESET
  );
SELECT_DIGIT: DEBOUNCER1 port map(
    CLK100MHZ => CLK100,
    BUTTON    => ADD_DIGIT,
    BUTTON_DS => SEL
  );
NUM_INDEX:PROCESS(CLK100, RESET)
BEGIN
    IF RESET = '1' THEN
        DIGIT_INDEX <= "00";
    ELSIF RISING_EDGE(CLK100) THEN
        IF ENTER_CHARACTERS = '1' AND SEL = '1' THEN
            CASE DIGIT_INDEX IS
                WHEN "00" | "01" =>
                    DIGIT_INDEX <= DIGIT_INDEX + 1;
                WHEN "10" =>
                    DIGIT_INDEX <= "11";
                WHEN "11" =>
                    DIGIT_INDEX <= "00";
                WHEN OTHERS =>
                    DIGIT_INDEX <= "00";
                END CASE;
        ELSIF ENTER_CHARACTERS='0' THEN
            DIGIT_INDEX<="00";
        END IF;
    END IF;
END PROCESS;
ENTER_DIGIT:PROCESS(CLK100)
BEGIN
    IF RISING_EDGE(CLK100) THEN
        IF RESET = '1' THEN
            NUM1 <= "0000"; NUM2 <= "0000"; NUM3 <= "0000";
            MEM1 <= "0000"; MEM2 <= "0000"; MEM3 <= "0000";
            VALIDATE_PIN <= '0';
        ELSIF ENTER_CHARACTERS = '1' THEN
            CASE DIGIT_INDEX IS
                WHEN "00" =>
                    NUM1 <= COUNTER_OUT;
                WHEN "01" =>
                    NUM2 <= COUNTER_OUT;
                WHEN "10" =>
                    NUM3 <= COUNTER_OUT;
                WHEN "11" =>
                    IF FREE_OCCUPIED = '0' THEN
                        MEM1 <= NUM1; MEM2 <= NUM2; MEM3 <= NUM3;
                    ELSE
                        IF (NUM1 = MEM1 AND NUM2 = MEM2 AND NUM3 = MEM3) THEN
                            VALIDATE_PIN <= '1';
                        ELSE
                            VALIDATE_PIN <= '0';
                        END IF;
                    END IF;
                    NUM1 <= "0000"; NUM2 <= "0000"; NUM3 <= "0000";
            END CASE;
        END IF;
    END IF;
END PROCESS;

ENABLE_NUM1 <= '1' WHEN ENTER_CHARACTERS = '1' AND (DIGIT_INDEX = "00" OR DIGIT_INDEX = "01" OR DIGIT_INDEX = "10") ELSE '0';
ENABLE_NUM2 <= '1' WHEN ENTER_CHARACTERS = '1' AND (DIGIT_INDEX = "01" OR DIGIT_INDEX = "10") ELSE '0';
ENABLE_NUM3 <= '1' WHEN ENTER_CHARACTERS = '1' AND DIGIT_INDEX = "10" ELSE '0';
FREE_OCCUPIED_LED <= FREE_OCCUPIED;
ENTER_CHARACTERS_LED <= ENTER_CHARACTERS;

end Behavioral;
