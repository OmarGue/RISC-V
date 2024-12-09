library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_branchement is
end tb_branchement;

architecture behav of tb_branchement is

    -- Constantes
    constant DATA_WIDTH : natural := 32;
    constant ADDR_WIDTH : natural := 8;
    constant MEM_DEPTH  : natural := 100;
    constant INIT_FILE  : string := "O:\S9\S9_Conception\add_02.hex";

    -- Signaux pour connecter au DUT (Design Under Test)
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';

    -- Instance du DUT
    component branchement
        generic
        (
            DATA_WIDTH : natural := 32;
            ADDR_WIDTH : natural := 8;
            MEM_DEPTH  : natural := 100;
            INIT_FILE  : string := "add_02.hex"
        );
        port
        (
            clk      : in std_logic;
            reset    : in std_logic
        );
    end component;

begin

    -- Instantiation du DUT
    uut: branchement
        generic map
        (
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH,
            MEM_DEPTH  => MEM_DEPTH,
            INIT_FILE  => INIT_FILE
        )
        port map
        (
            clk   => clk,
            reset => reset
        );

    -- Génération de l'horloge (période de 10 ns)
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Stimuli de test
    stim_process : process
    begin
        -- Initialisation
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Attente pour laisser le design démarrer
        wait for 100 ns;
    end process;

end behav;
