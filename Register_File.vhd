library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register_file is
    generic(POWERM,M,N:integer);--POWERM is 2^M
    port(
        WD:in std_logic_vector(N-1 downto 0);
        WAddr,RA,RB:in std_logic_vector(M-1 downto 0);
        Writ,ReadA,ReadB,reset,clk:in std_logic;
        QA,QB:out std_logic_vector(N-1 downto 0)
    );

end Register_file;

architecture behave of Register_File is
    type regs is array (0 to POWERM-1) of std_logic_vector(N-1 downto 0);
    signal data:regs:=(others=>(others=>'0'));
    
begin
    process(clk,reset)
    begin
        if reset='1' then --asynchronous reset
            data <= (others=>(others=>'0'));
        elsif (clk='1') and clk'event then  -- synchronous write
            if (Writ='1') then
                data(to_integer(unsigned(WAddr)))<= WD;--unsigned or integer?
            end if;
            -- if (ReadA='1') then
            --     QA<=data(to_integer(unsigned(RA)));
            -- end if;
            -- if (ReadB='1') then
            --     QB<=data(to_integer(unsigned(RB)));
            -- end if;
        end if;
    end process;
    QA<=data(to_integer(unsigned(RA))) when (ReadA='1') else (others=>'0'); --asynchronous read
    QB<=data(to_integer(unsigned(RB))) when (ReadB='1') else (others=>'0');
end architecture behave;