library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_single_port_rom is
end entity tb_single_port_rom;

architecture behav of tb_single_port_rom is

	component single_port_rom is
		generic 
		(
			DATA_WIDTH : natural := 8;
			ADDR_WIDTH : natural := 8
		);

		port 
		(
			clk		: in std_logic;
			addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
			q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
		);
	end component;

	-- Signaux pour tester la ROM
	signal addr_t : natural range 0 to 255; 
	signal q_t : std_logic_vector (7 downto 0);
	signal clk_t : std_logic := '1'; -- initialisation à 1 ( pour test )

begin 

	-- Instanciation de la ROM
	rom_1 : single_port_rom
		generic map
		(
			DATA_WIDTH => 8,
			ADDR_WIDTH => 8
		)
		port map
		(
			clk	=> clk_t,
			addr	=> addr_t,
			q	=> q_t
		);

	-- Génération de l'horloge 
	clk_t <= not clk_t after 5 ns;

	-- Simulation des valeurs d'adresse
	addr_t <= 0 after 0 ns, 1 after 20 ns, 2 after 40 ns;

end behav;