library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DEBOUNCER1 is
    Port ( CLK100MHZ : in STD_LOGIC;
           BUTTON : in STD_LOGIC;
           BUTTON_DS : out STD_LOGIC
           );
end DEBOUNCER1;
 
architecture Behavioral of DEBOUNCER1 is
SIGNAL COUNT : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
SIGNAL T : STD_LOGIC;
SIGNAL Q1, Q2, Q3 : STD_LOGIC;

BEGIN
 
PROCESS (CLK100MHZ)
BEGIN
    IF (rising_edge(CLK100MHZ)) THEN
        COUNT <= COUNT + 1;
    END IF;
END PROCESS;
 
T <= '1' WHEN COUNT = x"FFFF" ELSE '0';
 
PROCESS(CLK100MHZ)
BEGIN
    IF (rising_edge(CLK100MHZ)) THEN
        IF(T = '1') THEN
            Q1 <= BUTTON;
        END IF;
    END IF;
END PROCESS;
 
PROCESS(CLK100MHZ)
BEGIN
    IF (rising_edge(CLK100MHZ)) THEN
        Q2 <= Q1;
   	    Q3 <= Q2;
    END IF;
END PROCESS;
 
BUTTON_DS <= BUTTON AND Q2 AND (NOT Q3);

end Behavioral;