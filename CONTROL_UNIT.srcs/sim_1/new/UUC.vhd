library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity execution_unit_tb is
end execution_unit_tb;

architecture behavior of execution_unit_tb is

    -- Signals
    signal clk100             : std_logic := '0';
    signal reset              : std_logic := '1';
    signal add_digit          : std_logic := '0';
    signal cnt_up             : std_logic := '0';
    signal cnt_dn             : std_logic := '0';
    
    signal free_occupied_led  : std_logic;
    signal enter_characters_led : std_logic;
    signal anode              : std_logic_vector(3 downto 0);
    signal catode             : std_logic_vector(6 downto 0);

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz clock

begin

    -- Clock process
    clk_process : process
    begin
        clk100 <= '0';
        wait for CLK_PERIOD / 2;
        clk100 <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- DUT
    uut: entity work.EXECUTION_UNIT
        port map (
            FREE_OCCUPIED_LED     => free_occupied_led,
            ENTER_CHARACTERS_LED  => enter_characters_led,
            ADD_DIGIT             => add_digit,
            CNT_UP                => cnt_up,
            CNT_DN                => cnt_dn,
            CLK100                => clk100,
            RESET                 => reset,
            ANODE                 => anode,
            CATODE                => catode
        );

    -- Stimulus process
    stim_proc: process
        procedure enter_digit(times: integer) is
        begin
            -- Simulate pressing CNT_UP N times to set a digit
            for i in 1 to times loop
                cnt_up <= '1';
                wait for CLK_PERIOD * 2;
                cnt_up <= '0';
                wait for CLK_PERIOD * 2;
            end loop;

            -- Simulate pressing ADD_DIGIT to confirm digit
            add_digit <= '1';
            wait for CLK_PERIOD * 5;
            add_digit <= '0';
            wait for CLK_PERIOD * 10;
        end procedure;
        
    begin
        -- Initial reset
        wait for 20 ns;
        reset <= '0';

        -- STEP 1: Enter code (store)
        enter_digit(1); -- Enter '1'
        enter_digit(2); -- Enter '2'
        enter_digit(3); -- Enter '3'

        wait for 200 ns; -- System transitions to LOCKED_STATE

        -- STEP 2: Re-enter same code to unlock
        enter_digit(1);
        enter_digit(2);
        enter_digit(3);

        wait for 500 ns;

        -- End of test
        wait;
    end process;

end behavior;
