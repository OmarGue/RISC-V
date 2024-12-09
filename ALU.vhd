library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    Port (
        opA   : in  std_logic_vector(31 downto 0);  
        opB   : in  std_logic_vector(31 downto 0);  
        aluOp : in  std_logic_vector(3 downto 0);   
        res    : out std_logic_vector(31 downto 0)  
    );
end ALU;

architecture Behavioral of ALU is
begin
    process(opA, opB, aluOp)
    begin
        case aluOp is
            when "0000" => 
                res <= std_logic_vector(signed(opA) + signed(opB));  -- ADD
            when "0001" => 
                res <= std_logic_vector(signed(opA) - signed(opB));  -- SUB
            when "0010" => 
                res <= std_logic_vector(shift_left(unsigned(opA), to_integer(unsigned(opB(4 downto 0)))));  -- SLL 
            when "0101" => 
                res <= opA xor opB;  -- XOR
            when "1000" => 
                res <= opA or opB;   -- OR
            when "1001" => 
                res <= opA and opB;  -- AND
            when others => 
                res <= (others => '0');  -- Opération inco sortie zéro
        end case;
    end process;
end Behavioral;
