library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity GPIO is
    generic(N:integer);
    port(
        IE,OE,clk,reset:in std_logic;
        Din:in std_logic_vector(N-1 downto 0);
        Dout: out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture rtl of GPIO is

    signal input,output,Q: std_logic_vector(N-1 downto 0);
begin
    input <= Din when (IE='1') else output;
    output <= Q when (OE='1') else (others=>'0');
    Dout <= output;

    process(clk,reset)
    begin
        if(reset='1') then
            Q <= (others=>'0');
        elsif clk='1' and clk'event then
            Q <= input;
        end if;
    end process;
    
    
end architecture rtl;