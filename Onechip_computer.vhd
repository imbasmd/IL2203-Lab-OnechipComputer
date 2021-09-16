library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.all;

entity Onechip_computer is
    port (
        clk,reset:in std_logic;
        OE:in std_logic;
        PIO: out std_logic_vector(15 downto 0)
    );
end entity Onechip_computer;

architecture struct of Onechip_computer is
    
    component CPU is
        port(
            Din:in std_logic_vector(15 downto 0);
            clk,reset:in std_logic;
            output,Dout,Address:out std_logic_vector(15 downto 0);
            mem_Wren,mem_Rden:out std_logic
        );
    end component;

    -- component fake_memory is
    --     port (
    --         Address,Din:in std_logic_vector(15 downto 0);
    --         Rden,Wren:in std_logic;
    --         clk:in std_logic;
    --         Dout:out std_logic_vector(15 downto 0)
    --     );
    -- end component;

    component mem
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  ;
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
    end component;

    component GPIO is
        generic(N:integer);
        port(
		  
            IE,OE,clk,reset:in std_logic;
            Din:in std_logic_vector(N-1 downto 0);
            Dout: out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    signal Address_s,Dout_CPU_s,Dout_Memory_s:std_logic_vector(15 downto 0);
    signal Rden_s,Wren_s,Wren_in:std_logic;
    signal GPIO_IE:std_logic;

begin

    Wren_in<= '0' when (unsigned(Address_s)>255) else Wren_s; --address larger than 00ff is ingored

    U1_CPU:CPU
    port map(
        Din=>Dout_Memory_s,clk=>clk,reset=>reset,Dout=>Dout_CPU_s,Address=>Address_s,
        mem_Wren=>Wren_s,mem_Rden=>Rden_s
    );
    -- U2_memory:fake_memory
    -- port map(
    --     Address=>Address_s,Din=>Dout_CPU_s,Rden=>Rden_s,Wren=>Wren_s,
    --     clk=>clk,Dout=>Dout_Memory_s
    -- );

    U2_memory:mem
    port map(
        address=>Address_s(7 downto 0),clock=>clk,Data=>Dout_CPU_s,
        wren=>wren_in,q=>Dout_Memory_s
    );

    U3_GPIO:GPIO
    generic map(N=>16)
    port map(
        IE=>GPIO_IE,OE=>OE,clk=>clk,reset=>reset,Din=>Dout_CPU_s,Dout=>PIO
    );

    GPIO_IE <= '1' when (unsigned(Address_s)=X"F000") else '0';

    
    
end architecture struct;