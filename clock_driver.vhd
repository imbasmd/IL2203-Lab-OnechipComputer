library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_driver is
    port (
        clk:in std_logic;
        divided_clk_100M: out std_logic
    );
end entity clock_driver;

architecture rtl of clock_driver is
    signal count:integer:=0;
    signal Clock:std_logic:='0';
begin
    process(clk)
    begin
        if clk='1' and clk'event then
            count<=count+1;
            if (count = 50000000-1) then
                Clock <= not(Clock);
                count <= 0;
            end if;
        end if;
    end process;

    divided_clk_100M <= clock;
    
end architecture rtl;