library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2_1 is
	generic
	(
		INSTR_WIDTH : natural := 32
	);
	
	port
	(
		input1	 : in std_logic_vector((INSTR_WIDTH - 1) downto 0);
		input2    : in std_logic_vector((INSTR_WIDTH - 1) downto 0);
		RI_sel    : in std_logic ;
		output    : out std_logic_vector((INSTR_WIDTH - 1) downto 0)
	);
end entity;

architecture arch of mux_2_1 is

	begin	
	
		process(RI_sel, input1, input2)
		begin
			if RI_sel = '0' then
				output <= input1 ;
			elsif RI_sel = '1' then
				output <= input2 ;
			end if;

		end process;
end architecture;