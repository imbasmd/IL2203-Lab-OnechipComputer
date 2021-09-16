library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.all;

entity complete_Datapath is
    generic(M,N,POWERM:integer);
    port(
        input:in std_logic_vector(N-1 downto 0);
        IE,reset,clk,writ,ReadA,ReadB,OE:in std_logic;
        WAddr,RA,RB:in std_logic_vector(M-1 downto 0);
        OP:in std_logic_vector(2 downto 0);
        Z_flag,N_flag,O_flag: out std_logic;
        output: out std_logic_vector(N-1 downto 0);

        Dout_en,Addr_en: in std_logic;
        Dout,Address: out std_logic_vector(N-1 downto 0);

        bypass_A,bypass_B,bypass_W: in std_logic;
        offset: in std_logic_vector(N-5 downto 0)
        
    );
end complete_Datapath;

architecture struct of complete_Datapath is

    component Register_File is
        generic(POWERM,M,N:integer);
        port(
            WD:in std_logic_vector(N-1 downto 0);
            WAddr,RA,RB:in std_logic_vector(M-1 downto 0);
            Writ,ReadA,ReadB,reset,clk:in std_logic;
            QA,QB:out std_logic_vector(N-1 downto 0)
        );
    end component;

    component ALU
    generic(N:integer);
    port(
        OP:in std_logic_vector(2 downto 0);
        A,B: in std_logic_vector(N-1 downto 0);
        Y: out std_logic_vector(N-1 downto 0);
        Z_flag,N_flag,O_flag: out std_logic
    );
    end component;

    component reg is
        generic (N:integer);
        port (
            D:in std_logic_vector(N-1 downto 0);
            clk,reset,en:in std_logic;
            Q:out std_logic_vector(N-1 downto 0)
        );
    end component;


    signal QA,QB,Sum,WData:std_logic_vector(N-1 downto 0);
    signal A_in,B_in:std_logic_vector(N-1 downto 0);
    signal ReadA_in,Writ_in:std_logic;
    signal RA_in,WAddr_in:std_logic_vector(M-1 downto 0);
    signal output_s:std_logic_vector(N-1 downto 0);
begin
    U1:ALU
    generic map(N=>N)
    port map(OP=>OP,A=>A_in,B=>B_in,Y=>Sum,
    Z_flag=>Z_flag,N_flag=>N_flag,O_flag=>O_flag);
    U2:Register_File
    generic map (N=>N,M=>M,POWERM=>POWERM)
    port map(WD=>WData,WAddr=>WAddr_in,RA=>RA_in,RB=>RB,Writ=>writ_in,ReadA=>ReadA_in,ReadB=>ReadB,
    reset=>reset,clk=>clk,QA=>QA,QB=>QB);
    U3_Dout_reg:reg
    generic map(N=>16)
    port map(D=>output_s,clk=>clk,reset=>reset,en=>Dout_en,Q=>Dout);
    U4_Addr_reg:reg
    generic map(N=>16)
    port map(D=>output_s,clk=>clk,reset=>reset,en=>Addr_en,Q=>Address);


    WData<=input when (IE='1') else Sum; --IE='1' enables input
    output_s<= Sum when (OE='1') else (others=>'0'); --OE='1' enables output
    output<=output_s;

    A_in <= QA when (bypass_A='0') else std_logic_vector(resize(signed(offset(8 downto 0)),N)); --used in LDI and branch
    B_in <= QB when (bypass_B='0') else std_logic_vector(resize(signed(offset(11 downto 0)),N)); -- sign extended

    ReadA_in <= '1' when (bypass_B='1') else ReadA;
    RA_in <= (others=>'1') when (bypass_B='1') else RA;

    WAddr_in <= (others=>'1') when (bypass_W='1') else WAddr; --bug in specification
    Writ_in <= '1' when (bypass_W='1') else writ;


end architecture struct;
