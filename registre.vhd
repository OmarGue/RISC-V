library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity registre is
	generic 
	(
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 8
	);
	port 
	(
		clk		: in std_logic;
		data_in : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		data_out : out std_logic_vector((DATA_WIDTH-1) downto 0)
	);

end registre;
architecture comportement of registre is
signal reg_data : std_logic_vector((DATA_WIDTH-1) downto 0);
    begin
    process(clk)
    begin
		if(rising_edge(clk)) then
			if(we = '1') then
				reg_data<= data_in;
	      end if;		
        end if;	  
    end process;
	 data_out<=reg_data;
end comportement;