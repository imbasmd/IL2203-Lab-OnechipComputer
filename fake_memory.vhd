library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fake_memory is
    port (
        Address,Din:in std_logic_vector(15 downto 0);
        Rden,Wren:in std_logic;
        clk:in std_logic;
        Dout:out std_logic_vector(15 downto 0)
    );
end entity fake_memory;

architecture rtl of fake_memory is
    
    -- type in instruction
    subtype instruction is std_logic_vector(15 downto 0);
    subtype inst is std_logic_vector(3 downto 0);
    subtype reg_code is std_logic_vector(2 downto 0);
    subtype immediate is std_logic_vector(8 downto 0);
    subtype offset is std_logic_vector(11 downto 0);
    --inst list
    constant ADD:inst:="0000";
    constant SUB:inst:="0001";
    constant iAND:inst:="0010";
    constant iOR:inst:="0011";
    constant iXOR:inst:="0100";
    constant iNOT:inst:="0101";
    constant MOV:inst:="0110";
    constant NOP:inst:="0111";
    constant LD:inst:="1000";
    constant ST:inst:="1001";
    constant LDI:inst:="1010";
    constant NOT_USED:inst:="1011";
    constant BRZ:inst:="1100";
    constant BRN:inst:="1101";
    constant BRO:inst:="1110";
    constant BRA:inst:="1111";
    --reg list
    constant R0:reg_code:="000";
    constant R1:reg_code:="001";
    constant R2:reg_code:="010";
    constant R3:reg_code:="011";
    constant R4:reg_code:="100";
    constant R5:reg_code:="101";
    constant R6:reg_code:="110";
    constant R7:reg_code:="111";
    constant NU:reg_code:="000";

    -- RAM type
    type program is array (integer range<>) of std_logic_vector(15 downto 0);
    signal RAM:program(0 to 255):=(
        (LDI & R5 & B"1_0000_0000"),
        (ADD & R5 & R5 & R5 & NU),
        (ADD & R5 & R5 & R5 & NU),
        (ADD & R5 & R5 & R5 & NU),
        (ADD & R5 & R5 & R5 & NU),
        (LDI & R6 & B"0_0010_0000"),
        (LDI & R3 & B"0_0000_0011"),
        (ST & NU & R6 & R3 & NU),
        (LDI & R1 & B"0_0000_0001"),
        (LDI & R0 & B"0_0000_1110"),
        (MOV & R2 & R0 & NU & NU),
        (ADD & R2 & R2 & R1 & NU),
        (SUB & R0 & R0 & R1 & NU),
        (BRZ & B"0000_0000_0011"),
        (NOP & NU & NU & NU & NU),
        (BRA & B"1111_1111_1100"),
        (ST & NU & R6 & R2 & NU),
        (ST & NU & R5 & R2 & NU),
        (BRA & B"0000_0000_0000"),
        others=>(NOP & NU & NU & NU & NU)
    );

    signal rden_reg,wren_reg:std_logic;
    signal rden_in,wren_in:std_logic;
    signal address_s,Din_s:std_logic_vector(15 downto 0);
    signal address_8bit_s:std_logic_vector(7 downto 0);

begin
    process(clk)
    begin
        if clk='1' and clk'event then
            rden_reg<= rden;
            wren_reg<= wren;
            address_s<=address;
            Din_s<=Din;
        end if;
    end process;
    address_8bit_s<=address_s(7 downto 0);
    rden_in <= rden_reg when (unsigned(address_s)<256) else '0'; -- if address>255, Dout=0
    wren_in <= wren_reg when (unsigned(address_s)<256) else '0';
    Dout <= RAM(to_integer(unsigned(address_8bit_s))) when (rden_in='1') else RAM(0);
    RAM(to_integer(unsigned(address_8bit_s))) <= Din when (wren_in='1') else RAM(to_integer(unsigned(address_8bit_s)));

end architecture rtl;