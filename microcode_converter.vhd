library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

package microcode_converter is
    Function microcode_conv(instruction:std_logic_vector(3 downto 0);ZNO:std_logic;uPC:std_logic_vector(1 downto 0)) 
    return std_logic_vector;
end microcode_converter;

package body microcode_converter is
    
    Function microcode_conv(instruction:std_logic_vector(3 downto 0);ZNO:std_logic;uPC:std_logic_vector(1 downto 0)) 
    return std_logic_vector is
        --input I15-I12 & mux_ZNO & uPC 
        --return IE & bypassA & bypassB & bypassW & write & ReadA & ReadB & OE & reset & OP & IR & addr_en & Dout_en & mem_Rden & mem_Wren & ZNO_read_en

        -- control signal inside fsm
        -- ZNO_read_en,IR

        -- control signals for Datapath
        -- IE,Bypass_A,Bypass_B,Bypass_W,writ,ReadA,ReadB,OE,Reset,OP

        -- control signals for output registers and external memory
        -- addr_en,Dout_en,mem_Rden,mem_Wren
    begin
        case(instruction) is
            --inst 1 clk cycle
            -- add
            when "0000" =>
            if uPC=0 then
                return "000000000000100000"; --load inst
            elsif uPC=1 then
                return "000011100000000001"; --perform function
            elsif uPC=2 then
                return "001100010111010000"; --PC+1
            elsif uPC=3 then
                return "000000000000000100"; --not used
            else 
                return "000000000000000000";
            end if;
            return "000000000000000000";

            -- sub
            when "0001" =>
            if uPC=0 then
                return "000000000000100000"; --load inst
            end if;
            if uPC=1 then
                return "000011100001000001"; --perform function
            end if;
            if uPC=2 then
                return "001100010111010000"; --PC+1
            end if;
            if uPC=3 then
                return "000000000000000100"; --not used
            end if;
            return "000000000000000000";

            -- and
            when "0010" =>
            if uPC=0 then
                return "000000000000100000"; --load inst
            end if;
            if uPC=1 then
                return "000011100010000001"; --perform function
            end if;
            if uPC=2 then
                return "001100010111010000"; --PC+1
            end if;
            if uPC=3 then
                return "000000000000000100"; --not used
            end if;
            return "000000000000000000";

            -- or
            when "0011" =>
            if uPC=0 then
                return "000000000000100000"; --load inst
            end if;
            if uPC=1 then
                return "000011100011000001"; --perform function
            end if;
            if uPC=2 then
                return "001100010111010000"; --PC+1
            end if;
            if uPC=3 then
                return "000000000000000100"; --not used
            end if;
            return "000000000000000000";
            
            -- xor
            when "0100" =>
            if uPC=0 then
                return "000000000000100000"; --load inst
            end if;
            if uPC=1 then
                return "000011100100000001"; --perform function
            end if;
            if uPC=2 then
                return "001100010111010000"; --PC+1
            end if;
            if uPC=3 then
                return "000000000000000100"; --not used
            end if;
            return "000000000000000000";

            -- not
            when "0101" =>
            if uPC=0 then
                return "000000000000100000"; --load inst
            end if;
            if uPC=1 then
                return "000011100101000001"; --perform function
            end if;
            if uPC=2 then
                return "001100010111010000"; --PC+1
            end if;
            if uPC=3 then
                return "000000000000000100"; --not used
            end if;
            return "000000000000000000";

            -- mov
            when "0110" =>
            if uPC=0 then
                return "000000000000100000"; --load inst
            end if;
            if uPC=1 then
                return "000011100110000001"; --perform function
            end if;
            if uPC=2 then
                return "001100010111010000"; --PC+1
            end if;
            if uPC=3 then
                return "000000000000000100"; --not used
            end if;
            return "000000000000000000";

            -- nop
            when "0111" =>
            if uPC=0 then
                return "000000000000100000"; --load inst
            end if;
            if uPC=1 then
                return "000000000000000000"; --perform function
            end if;
            if uPC=2 then
                return "001100010111010000"; --PC+1
            end if;
            if uPC=3 then
                return "000000000000000100"; --not used
            end if;
            return "000000000000000000";

            -- LD
            -- use 2 clock cycles
            when "1000" =>
            if uPC=0 then
                return "000000000000100000"; --load inst
            end if;
            if uPC=1 then
                return "000001010110010100"; --perform function
            end if;
            if uPC=2 then
                return "001100010111010000"; --PC+1
            end if;
            if uPC=3 then
                return "100010000000000100"; --save mem<r2> to r1
            end if;
            return "000000000000000000";

            -- ST
            -- use 2 clock cycles
            when "1001" =>
            if uPC=0 then
                return "000000000000100000"; --load inst
            end if;
            if uPC=1 then
                return "000000110000001000"; --Dout R2
            end if;
            if uPC=2 then
                return "001100010111010000"; --PC+1
            end if;
            if uPC=3 then
                return "000001010110010110"; --Address R1 and mem_Wren
            end if;
            return "000000000000000000";

            -- LDI
            -- use 1 clock cycle
            when "1010" =>
            if uPC=0 then
                return "000000000000100000"; --load inst
            end if;
            if uPC=1 then
                return "010010000110000000"; --perform function
            end if;
            if uPC=2 then
                return "001100010111010000"; --PC+1
            end if;
            if uPC=3 then
                return "000000000000000100"; --not used
            end if;
            return "000000000000000000";

            --Not used
            when "1011" =>
            if uPC=0 then
                return "000000000000100000"; --load inst
            end if;
            if uPC=1 then
                return "000000000000000000"; --perform function
            end if;
            if uPC=2 then
                return "001100010111010000"; --PC+1
            end if;
            if uPC=3 then
                return "000000000000000100"; --not used
            end if;
            return "000000000000000000";
            -- BRZ
            -- use 0 clock cycles
            when "1100" =>
            if (ZNO='1') then
                if uPC=0 then
                    return "000000000000100000"; --load inst
                end if;
                if uPC=1 then
                    return "000000000000000000"; --perform function
                end if;
                if uPC=2 then
                    return "001100010000010000"; --PC+ S.E. offset
                end if;
                if uPC=3 then
                    return "000000000000000100"; --not used
                end if;
            end if;
            if (ZNO='0') then
                if uPC=0 then
                    return "000000000000100000"; --load inst
                end if;
                if uPC=1 then
                    return "000000000000000000"; --perform function
                end if;
                if uPC=2 then
                    return "001100010111010000"; --PC+1
                end if;
                if uPC=3 then
                    return "000000000000000100"; --not used
                end if;
            end if;
            return "000000000000000000";
            -- BRN
            -- use 0 clock cycles
            when "1101" =>
            if (ZNO='1') then
                if uPC=0 then
                    return "000000000000100000"; --load inst
                end if;
                if uPC=1 then
                    return "000000000000000000"; --perform function
                end if;
                if uPC=2 then
                    return "001100010000010000"; --PC+ S.E. offset
                end if;
                if uPC=3 then
                    return "000000000000000100"; --not used
                end if;
            end if;
            if (ZNO='0') then
                if uPC=0 then
                    return "000000000000100000"; --load inst
                end if;
                if uPC=1 then
                    return "000000000000000000"; --perform function
                end if;
                if uPC=2 then
                    return "001100010111010000"; --PC+1
                end if;
                if uPC=3 then
                    return "000000000000000100"; --not used
                end if;
            end if;
            return "000000000000000000";

            -- BRO
            -- use 0 clock cycles
            when "1110" =>
            if (ZNO='1') then
                if uPC=0 then
                    return "000000000000100000"; --load inst
                end if;
                if uPC=1 then
                    return "000000000000000000"; --perform function
                end if;
                if uPC=2 then
                    return "001100010000010000"; --PC+ S.E. offset
                end if;
                if uPC=3 then
                    return "000000000000000100"; --not used
                end if;
            end if;
            if (ZNO='0') then
                if uPC=0 then
                    return "000000000000100000"; --load inst
                end if;
                if uPC=1 then
                    return "000000000000000000"; --perform function
                end if;
                if uPC=2 then
                    return "001100010111010000"; --PC+1
                end if;
                if uPC=3 then
                    return "000000000000000100"; --not used
                end if;
            end if;
            return "000000000000000000";

            -- BRA
            -- use 0 clock cycles
            when "1111" =>
            if uPC=0 then
                return "000000000000100000"; --load inst
            end if;
            if uPC=1 then
                return "000000000000000000"; --perform function
            end if;
            if uPC=2 then
                return "001100010000010000"; --PC+ S.E. offset
            end if;
            if uPC=3 then
                return "000000000000000100"; --not used
            end if;
            return "000000000000000000";
                
            when others =>
            return "000000000000000000";

        end case;        
    end function;  
    
end package body microcode_converter;