library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.all;

entity microcode_fsm is
    port(
        Din: in std_logic_vector(15 downto 0);
        clk,reset_fsm:in std_logic;
        Z_flag,N_flag,O_flag:in std_logic;
        offset:out std_logic_vector(11 downto 0);
        IE,Bypass_A,Bypass_B,Bypass_W,writ,ReadA,ReadB,OE,Reset:out std_logic;
        OP:out std_logic_vector(2 downto 0);
        addr_en,Dout_en,mem_Rden,mem_Wren:out std_logic
    );
end microcode_fsm;

architecture struct of microcode_fsm is
    
    component microcode_controller is
        port(
            inst:in std_logic_vector(3 downto 0);
            ZNO:in std_logic;
            uPC:in std_logic_vector(1 downto 0);
            -- control signal inside fsm
            ZNO_read_en,IR:out std_logic; 
            -- control signals for Datapath
            IE,Bypass_A,Bypass_B,Bypass_W,writ,ReadA,ReadB,OE,Reset:out std_logic;
            OP:out std_logic_vector(2 downto 0);
            --control signals for output registers and external memory
            addr_en,Dout_en,mem_Rden,mem_Wren:out std_logic
        );
    end component;

    component ZNO_controller is
        port (
            IR_15_12: in std_logic_vector(3 downto 0); -- tell the controller which flag to use
            Z_flag,N_flag,O_flag: in std_logic;
            enable:in std_logic; -- tell the controller when to read flags from the Datapath
            clk:in std_logic;
            ZNO_flag: out std_logic
        );
    end component;

    component uPgm_counter is
        port(
            clk:in std_logic;
            reset:in std_logic;
            count:out std_logic_vector(1 downto 0)
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

    signal IR_s,A2_s,ZNO_read_en_s,mem_Wren_s:std_logic;
    signal A1A0_s:std_logic_vector(1 downto 0);
    signal Inst_s:std_logic_vector(15 downto 0);
begin
    U1_instruction_reg:reg
    generic map(N=>16)
    port map(
        D=>Din,clk=>clk,reset=>reset_fsm,en=>IR_s,Q=>Inst_s
    );

    U2_program_counter:uPgm_counter
    port map(clk=>clk,reset=>reset_fsm,count=>A1A0_s);

    U3_ZNO_controller:ZNO_controller
    port map(IR_15_12=>Inst_s(15 downto 12),Z_flag=>Z_flag,N_flag=>N_flag,
    O_flag=>O_flag,enable=>ZNO_read_en_s,clk=>clk,ZNO_flag=>A2_s);

    U4_microcode_controller:microcode_controller

    port map(
        inst=>Inst_s(15 downto 12),
        ZNO=>A2_s,
        uPC=>A1A0_s,
        ZNO_read_en=>ZNO_read_en_s,IR=>IR_s,
        IE=>IE,Bypass_A=>Bypass_A,Bypass_B=>Bypass_B,Bypass_W=>Bypass_W,writ=>writ,ReadA=>ReadA,ReadB=>ReadB,OE=>OE,Reset=>Reset,
        OP=>OP,
        addr_en=>addr_en,Dout_en=>Dout_en,mem_Rden=>mem_Rden,mem_Wren=>mem_Wren_s
    );
    -- memory Wren signal needs to be regsitered for ST instruction
    U5_mem_Wren_reg:reg
    generic map(N=>1)
    port map(
    D(0)=>mem_Wren_s,clk=>clk,reset=>reset_fsm,en=>'1',Q(0)=>mem_Wren
    );

    offset <= Inst_s(11 downto 0);
    
    
    
end architecture struct;