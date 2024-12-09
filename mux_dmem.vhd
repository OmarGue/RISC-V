library ieee;
use ieee.std_logic_1164.all;

entity mux_dmem is
    port (
        alu_output  : in std_logic_vector(31 downto 0);
        data  : in std_logic_vector(31 downto 0);
        loadAcc     : in std_logic;
        output  : out std_logic_vector(31 downto 0)
    );
end entity;

architecture behaviour of mux_dmem is
begin
    process(alu_output, data, loadAcc)
    begin
        if loadAcc = '0' then
            output <= alu_output;  -- ALU output
        else
            output <= data;  -- Memory output
        end if;
    end process;
end architecture;
