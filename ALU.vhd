library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.numeric_std_unsigned.all;

entity ALU is
    generic(N:integer);
    port(
        OP:in std_logic_vector(2 downto 0);
        A,B: in std_logic_vector(N-1 downto 0);
        Y: out std_logic_vector(N-1 downto 0);
        Z_flag,N_flag,O_flag: out std_logic
    );
end ALU;

architecture behave of ALU is
    signal Y_res :std_logic_vector(N-1 downto 0):=(others=>'0');
    constant zero :std_logic_vector(N-1 downto 0):=(others=>'0');
    signal overflow_check:std_logic_vector(2 downto 0):=(others=>'0');
begin
    process(OP,A,B)
    begin
        case(OP) is
            when "000" =>
            --Y=A+B
            Y_res <= std_logic_vector(unsigned(A) + unsigned(B));
            when "001" =>
            --Y=A-B
            Y_res <= std_logic_vector(unsigned(A) - unsigned(B));
            when "010" =>
            --Y=A and B
            Y_res <= A and B;
            when "011" =>
            --Y=A or B
            Y_res <= A or B;
            when "100" =>
            --Y=A xor B
            Y_res <= A xor B;
            when "101" =>
            --Y=not A
            Y_res <= not(A);
            when "110" =>
            --Y=A
            Y_res <= A;
            when "111" =>
            --Y=A + 1
            Y_res <= std_logic_vector(unsigned(A) + 1);
            when others =>
            Y_res <= (others=>'0');

        end case;
    end process;
    Y <= Y_res;
    overflow_check <= A(N-1)&B(N-1)&Y_res(N-1);
    Z_flag <= '1' when (Y_res=zero) else '0';
    N_flag <= '1' when (Y_res(N-1)='1') else '0';
    O_flag <= '1' when ((((overflow_check="100")or(overflow_check="011")) and (OP="001")) or (((overflow_check="001")or(overflow_check="110")) and (OP="000"))) else '0';
end behave;
