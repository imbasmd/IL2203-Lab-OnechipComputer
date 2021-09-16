use work.microcode_converter.all;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity microcode_controller is
    port (
        inst:in std_logic_vector(3 downto 0);
        ZNO:in std_logic;
        uPC:in std_logic_vector(1 downto 0);
        -- control signal inside fsm
        ZNO_read_en,IR:out std_logic; 
        -- control signals for Datapath
        IE,Bypass_A,Bypass_B,Bypass_W,writ,ReadA,ReadB,OE,Reset:out std_logic;
        OP:out std_logic_vector(2 downto 0);
        --control signals for output registers and external memory
        addr_en,Dout_en,mem_Rden,mem_Wren:out std_logic  --mem_Wren needs to be regsitered for ST instuction
    );
end entity;
--return IE & bypassA & bypassB & bypassW & writ & ReadA & ReadB & OE & reset & OP & IR & addr_en & Dout_en & mem_Rden & mem_Wren & ZNO_read_en
architecture rtl of microcode_controller is
    signal output:std_logic_vector(17 downto 0):=(others=>'0');
begin
    output <= microcode_conv(inst,ZNO,uPC);
    IE <= output(17);
    Bypass_A <= output(16);
    Bypass_B <= output(15);
    Bypass_W <= output(14);
    writ <= output(13);
    ReadA <= output(12);
    ReadB <= output(11);
    OE <= output(10);
    Reset <= output(9);
    OP <= output(8 downto 6);
    IR <= output(5);
    addr_en <= output(4);
    Dout_en <= output(3);
    mem_Rden <= output(2);
    mem_Wren <= output(1);
    ZNO_read_en <= output(0);
    
    
end architecture rtl;