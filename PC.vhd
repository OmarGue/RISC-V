library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity PC is
	generic 
	(
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 8
	);
	port 
	(
		reset : in std_logic;
		load		: in std_logic;
		din : in std_logic_vector((DATA_WIDTH-1) downto 0);
		dout : out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end PC;

architecture comportement of PC is
	signal pcc : std_logic_vector (DATA_WIDTH - 1 downto 0) := (others => '0');
    begin
    process(reset, load, din)
    begin
        if reset = '1' then
            -- Réinitialisation asynchrone
            pcc <= (others => '0');
        elsif load = '1' then
            -- Chargement asynchrone des donnees d'entree
            pcc <= din;
        else
            -- Incrementation asynchrone par 4
            pcc <= std_logic_vector(unsigned(pcc) + 4);
        end if;
    end process;
	 dout<=pcc;
end comportement;