library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ZNO_controller is
    port (
        IR_15_12: in std_logic_vector(3 downto 0); -- tell the controller which flag to use
        Z_flag,N_flag,O_flag: in std_logic;
        enable:in std_logic; -- tell the controller when to read flags from the Datapath
        clk:in std_logic;
        ZNO_flag: out std_logic
    );
end entity;

architecture rtl of ZNO_controller is
    signal reg_Z,reg_N,reg_O: std_logic;
begin
    process(clk)
    begin
        if clk='1' and clk'event then
            if enable = '1' then
                reg_Z <= Z_flag;
                reg_N <= N_flag;
                reg_O <= O_flag;
            end if;
        end if;
    end process;

    ZNO_flag <= reg_Z when IR_15_12 = "1100" else -- A2 for the microcode_fsm will be little later than the  A6-A3
                reg_N when IR_15_12 = "1101" else -- hopefully it will be alright, test needed
                reg_O when IR_15_12 = "1110" else
                '0';
    
end architecture rtl;
