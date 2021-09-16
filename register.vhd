library ieee;
use ieee.std_logic_1164.all;
-- asynchronous reset N-bit FF
entity reg is
    generic (N:integer);
    port (
        D:in std_logic_vector(N-1 downto 0);
        clk,reset,en:in std_logic;
        Q:out std_logic_vector(N-1 downto 0)
    );
end reg;

architecture behave of reg is

begin
    process(clk,reset,en)
    begin
        if reset='1' then
            Q <= (others=>'0');
        elsif (clk='1') and clk'event then
            if (en='1') then
                Q <= D;
            end if;
        end if;
    end process;
end behave;