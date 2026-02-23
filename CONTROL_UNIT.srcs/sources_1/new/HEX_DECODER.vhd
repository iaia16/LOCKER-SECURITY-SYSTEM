LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY HEX_DECODER IS
  PORT (
	NUM: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
	NUM_SSD: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
    );
END HEX_DECODER;

ARCHITECTURE TypeArchitecture OF HEX_DECODER IS

BEGIN
PROCESS(NUM)
BEGIN
	CASE NUM IS
	    WHEN "0000" => NUM_SSD <= "1000000"; -- 0
        WHEN "0001" => NUM_SSD <= "1111001"; -- 1
        WHEN "0010" => NUM_SSD <= "0100100"; -- 2
        WHEN "0011" => NUM_SSD <= "0110000"; -- 3
        WHEN "0100" => NUM_SSD <= "0011001"; -- 4
        WHEN "0101" => NUM_SSD <= "0010010"; -- 5
        WHEN "0110" => NUM_SSD <= "0000010"; -- 6
        WHEN "0111" => NUM_SSD <= "1111000"; -- 7
        WHEN "1000" => NUM_SSD <= "0000000"; -- 8
        WHEN "1001" => NUM_SSD <= "0010000"; -- 9
        WHEN "1010" => NUM_SSD <= "0001000"; -- A
        WHEN "1011" => NUM_SSD <= "0000011"; -- b
        WHEN "1100" => NUM_SSD <= "1000110"; -- C
        WHEN "1101" => NUM_SSD <= "0100001"; -- d
        WHEN "1110" => NUM_SSD <= "0000110"; -- E
        WHEN "1111" => NUM_SSD <= "0001110"; -- F
        WHEN OTHERS => NUM_SSD <= "1111111"; -- all segments OFF
	END CASE;
END PROCESS;

END TypeArchitecture;
