library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity uPgm_counter is
    port(
        clk:in std_logic;
        reset:in std_logic;
        count:out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of uPgm_counter is
    signal counter: std_logic_vector(1 downto 0):=(others=>'0');
begin
    process(clk,reset)
    begin
        if reset='1' then --asynchronous reset
            counter <= "00";
        elsif clk='1' and clk'event then
            counter <= counter + 1;
        end if;
    end process;

    count <= counter;

end architecture rtl;