library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CONTROL_UNIT is
 port(
    CLK : IN  STD_LOGIC;                    
    ADD_DIGIT : IN  STD_LOGIC; 
    --LOCKED : IN STD_LOGIC;                    
    --EQUAL_PIN: IN STD_LOGIC;
    --IS_MASTER_KEY: IN STD_LOGIC;
    VALIDATE_PIN: INOUT STD_LOGIC;
    ADDIT_CHYPHER: IN STD_LOGIC;
    RESET: IN STD_LOGIC;
    FREE_OCUPE_LED: INOUT STD_LOGIC;
    ENTER_CHARACTERS_LED: INOUT STD_LOGIC; 
    FREE_CONTRACTED_LED: INOUT STD_LOGIC
 );
end CONTROL_UNIT;

architecture Behavioral of CONTROL_UNIT is

component DEBOUNCER1 is
    Port ( CLK100MHZ : in STD_LOGIC;
           BUTTON : in STD_LOGIC;
           BUTTON_DS : out STD_LOGIC);
end component;

component C_U IS
  PORT (
    CLK : IN  STD_LOGIC;                    
      ADD_DIGIT : IN  STD_LOGIC; 
     -- LOCKED : IN STD_LOGIC;                    
     -- EQUAL_PIN: IN STD_LOGIC;
      --IS_MASTER_KEY: IN STD_LOGIC;
      VALIDATE_PIN: IN STD_LOGIC;
      ADDIT_CHYPHER: IN STD_LOGIC;
      RESET: IN STD_LOGIC;
      FREE_OCUPE_LED: INOUT STD_LOGIC;
      ENTER_CHARACTERS_LED: INOUT STD_LOGIC; 
      FREE_CONTRACTED_LED: INOUT STD_LOGIC
    );
end component;

signal s1: std_logic;
signal s2: std_logic;

begin
DEBOUNCER: DEBOUNCER1 PORT MAP(CLK100MHZ => CLK, BUTTON => ADD_DIGIT,BUTTON_DS => s1);
DEBOUNCER_1: DEBOUNCER1 PORT MAP(CLK100MHZ => CLK, BUTTON => ADDIT_CHYPHER,BUTTON_DS => s2);
CONTROL_UNIT_COMPONENT: C_U PORT MAP(CLK => CLK, 
                                              ADD_DIGIT => s1, 
                                              VALIDATE_PIN => VALIDATE_PIN,
                                              ADDIT_CHYPHER => s2,
                                              RESET => RESET,
                                              FREE_OCUPE_LED => FREE_OCUPE_LED,
                                              ENTER_CHARACTERS_LED => ENTER_CHARACTERS_LED,
                                              FREE_CONTRACTED_LED => FREE_CONTRACTED_LED);

end Behavioral;
