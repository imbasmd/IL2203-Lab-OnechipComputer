library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.all;

entity CPU is
    port(
        Din:in std_logic_vector(15 downto 0);
        clk,reset:in std_logic;
        output,Dout,Address:out std_logic_vector(15 downto 0);
        mem_Wren,mem_Rden:out std_logic
    );
end entity;

architecture struct of CPU is
    
    component microcode_fsm is
        port(
            Din: in std_logic_vector(15 downto 0);
            clk,reset_fsm:in std_logic;
            Z_flag,N_flag,O_flag:in std_logic;
            offset:out std_logic_vector(11 downto 0);
            IE,Bypass_A,Bypass_B,Bypass_W,writ,ReadA,ReadB,OE,Reset:out std_logic;
            OP:out std_logic_vector(2 downto 0);
            addr_en,Dout_en,mem_Rden,mem_Wren:out std_logic
        );
    end component;

    component complete_Datapath is
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
    end component;

    signal Z_flag_s,N_flag_s,O_flag_s,IE_s,Bypass_A_s,Bypass_B_s,Bypass_W_s,writ_s,ReadA_s,ReadB_s,OE_s,Reset_inst_s:std_logic;
    signal addr_en_s,Dout_en_s:std_logic;
    signal OP_s:std_logic_vector(2 downto 0);
    signal offset_s:std_logic_vector(11 downto 0);
    signal Datapath_reset:std_logic;

begin

    U1_fsm: microcode_fsm
    port map(Din=>Din,
    clk=>clk,reset_fsm=>reset,
    Z_flag=>Z_flag_s,N_flag=>N_flag_s,O_flag=>O_flag_s,
    offset=>offset_s,
    IE=>IE_s,Bypass_A=>Bypass_A_s,Bypass_B=>Bypass_B_s,Bypass_W=>Bypass_W_s,writ=>writ_s,ReadA=>ReadA_s,ReadB=>ReadB_s,OE=>OE_s,Reset=>Reset_inst_s,
    OP=>OP_s,
    addr_en=>addr_en_s,Dout_en=>Dout_en_s,mem_Rden=>mem_Rden,mem_Wren=>mem_Wren);

    U2_datapath: complete_Datapath
    generic map(M=>3,N=>16,POWERM=>8)
    port map(
        input=>Din,
        IE=>IE_s,reset=>Datapath_reset,clk=>clk,writ=>writ_s,ReadA=>ReadA_s,ReadB=>ReadB_s,OE=>OE_s,
        WAddr=>offset_s(11 downto 9),RA=>offset_s(8 downto 6),RB=>offset_s(5 downto 3),
        OP=>OP_s,
        Z_flag=>Z_flag_s,N_flag=>N_flag_s,O_flag=>O_flag_s,
        output=>output,

        Dout_en=>Dout_en_s,Addr_en=>addr_en_s,
        Dout=>Dout,Address=>Address,

        bypass_A=>Bypass_A_s,bypass_B=>Bypass_B_s,bypass_W=>Bypass_W_s,
        offset=>offset_s
        
    );

    Datapath_reset <= Reset_inst_s or reset;
    
    
    
end architecture struct;
