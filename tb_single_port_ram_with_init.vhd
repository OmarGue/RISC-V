library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_single_port_ram_with_init is
end tb_single_port_ram_with_init;

architecture behav of tb_single_port_ram_with_init is

component single_port_ram_with_init
generic (
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 3  -- 3 bits pour 8 adresses
	);

	port (
		clk		: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
end component;

signal clk_t : std_logic := '0';
signal addr_t : natural range 0 to 7;
signal q_t : std_logic_vector(31 downto 0);
signal data_t : std_logic_vector(31 downto 0);
signal we_t : std_logic := '1';

begin 

    -- Instantiation of the memory
    ram_1: single_port_ram_with_init
    generic map(
        DATA_WIDTH => 32,
        ADDR_WIDTH => 3  -- 8 adresses
    )
    port map(
        clk => clk_t,
        addr => addr_t,
        q => q_t,
        data => data_t,
        we => we_t
    );

    clk_t <= not clk_t after 5 ns;

    process
    begin
        for i in 0 to 7 loop
            addr_t <= i;
            we_t <= '0';  
            wait for 10 ns;
        end loop;

        -- 2. Écraser la valeur des 8 mots avec la valeur 7-Adresse
        for i in 0 to 7 loop
            addr_t <= i;
            data_t <= std_logic_vector(to_unsigned(7 - i, 32));
            we_t <= '1';  -- Mode écriture
            wait for 10 ns;
        end loop;

        for i in 0 to 7 loop
            addr_t <= i;
            we_t <= '0';  
            wait for 10 ns;
        end loop;

        wait;
    end process;

end behav;