library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_registre is
end entity tb_registre;

architecture behav of tb_registre is

	component registre is
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
	end component;

	-- Signaux pour tester le registre
	signal data_in_t : std_logic_vector(31 downto 0); -- 32 bits
	signal data_out_t : std_logic_vector(31 downto 0); -- 32 bits
	signal clk_t : std_logic := '0'; -- initialisation à 0
	signal we_t : std_logic := '1';

begin 

	-- Instanciation du registre
	reg_1 : registre
		generic map
		(
			DATA_WIDTH => 32,
			ADDR_WIDTH => 8
		)
		port map
		(
			clk	=> clk_t,
			data_in	=> data_in_t,
			data_out	=> data_out_t,
			we => we_t
		);

	-- Génération de l'horloge 
	clk_t <= not clk_t after 50 ns;
	
	process
	begin
		-- Écriture d'une valeur arbitraire
		we_t <= '1';  -- Activation de l'écriture
		data_in_t <= x"01234567";  -- 32 bits
		wait for 100 ns;

		-- Désactivation de l'écriture
		we_t <= '0';
		wait for 100 ns;

		-- Écriture d'une autre valeur arbitraire
		data_in_t <= x"87654321";  -- 32 bits
		we_t <= '1';  -- Réactivation de l'écriture
		wait for 100 ns;

		-- Fin de la simulation
		wait;
	end process;

end behav;
