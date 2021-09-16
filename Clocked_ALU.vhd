library ieee;
use ieee.std_logic_1164.all;
library work;
use work.all;

entity Clocked_ALU is
    generic(N:integer);
    port(
        OP:in std_logic_vector(2 downto 0);
        A,B: in std_logic_vector(N-1 downto 0);
        EN,reset,clk: in std_logic;
        Sum: out std_logic_vector(N-1 downto 0);
        Z_flag,N_flag,O_flag: out std_logic
    );
end Clocked_ALU;

architecture structure of Clocked_ALU is

    component ALU
    generic(N:integer);
    port(
        OP:in std_logic_vector(2 downto 0);
        A,B: in std_logic_vector(N-1 downto 0);
        Y: out std_logic_vector(N-1 downto 0);
        Z_flag,N_flag,O_flag: out std_logic
    );
    end component;

    component reg
    generic (N:integer);
    port (
        D:in std_logic_vector(N-1 downto 0);
        clk,reset,en:in std_logic;
        Q:out std_logic_vector(N-1 downto 0)
    );
    end component;

    signal S_Sum :std_logic_vector(N-1 downto 0):=(others=>'0');
    signal S_Z,S_N,S_O:std_logic:='0';
begin
    U1:ALU
    generic map(N=>N)
    port map(OP,A,B,S_Sum,S_Z,S_N,S_O);
    U2: reg
    generic map(N=>N)
    port map(S_Sum,clk,reset,EN,Sum);
    U3: reg
    generic map(N=>1)
    port map(D(0)=>S_Z,clk=>clk,reset=>reset,en=>EN,Q(0)=>Z_flag);
    U4: reg
    generic map(N=>1)
    port map(D(0)=>S_N,clk=>clk,reset=>reset,en=>EN,Q(0)=>N_flag);
    U5: reg
    generic map(N=>1)
    port map(D(0)=>S_O,clk=>clk,reset=>reset,en=>EN,Q(0)=>O_flag);
end structure;