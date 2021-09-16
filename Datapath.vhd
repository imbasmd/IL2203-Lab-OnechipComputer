library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.all;

entity Datapath is
    generic(M,N,POWERM:integer);
    port(
        input:in std_logic_vector(N-1 downto 0);
        IE,reset,clk,writ,ReadA,ReadB,OE,EN:in std_logic;
        WAddr,RA,RB:in std_logic_vector(M-1 downto 0);
        OP:in std_logic_vector(2 downto 0);
        Z_flag,N_flag,O_flag: out std_logic;
        output: out std_logic_vector(N-1 downto 0)
        
    );
end Datapath;

architecture struct of Datapath is

    component Register_File is
        generic(POWERM,M,N:integer);
        port(
            WD:in std_logic_vector(N-1 downto 0);
            WAddr,RA,RB:in std_logic_vector(M-1 downto 0);
            Writ,ReadA,ReadB,reset,clk:in std_logic;
            QA,QB:out std_logic_vector(N-1 downto 0)
        );
    end component;

    component Clocked_ALU
    generic(N:integer);
    port(
        OP:in std_logic_vector(2 downto 0);
        A,B: in std_logic_vector(N-1 downto 0);
        EN,reset,clk: in std_logic;
        Sum: out std_logic_vector(N-1 downto 0);
        Z_flag,N_flag,O_flag: out std_logic
    );
    end component;
    signal QA,QB,Sum,WData:std_logic_vector(N-1 downto 0);
begin
    U1:Clocked_ALU
    generic map(N=>N)
    port map(OP=>OP,A=>QA,B=>QB,EN=>EN,reset=>reset,clk=>clk,Sum=>Sum,
    Z_flag=>Z_flag,N_flag=>N_flag,O_flag=>O_flag);
    U2:Register_File
    generic map (N=>N,M=>M,POWERM=>POWERM)
    port map(WD=>WData,WAddr=>WAddr,RA=>RA,RB=>RB,Writ=>writ,ReadA=>ReadA,ReadB=>ReadB,
    reset=>reset,clk=>clk,QA=>QA,QB=>QB);

    WData<=input when (IE='1') else Sum; --IE='1' enables input
    output<= Sum when (OE='1') else (others=>'0'); --OE='1' enables output
    


end architecture struct;
