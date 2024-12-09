library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_branchement_RI is
end tb_branchement_RI;

architecture behaviour of tb_branchement_RI is

    -- Constantes
    constant DATA_WIDTH : natural := 32;
    constant ADDR_WIDTH : natural := 8;
    constant MEM_DEPTH  : natural := 100;
    constant INIT_FILE  : string := "O:\S9\S9_Conception\add_02.hex";

    -- Signaux pour connecter au DUT (Design Under Test)
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';

    -- Signaux internes pour observer les résultats
    signal pc_out      : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal instr       : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal alu_result  : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal imm_ext_s   : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal opB_mux     : std_logic_vector(DATA_WIDTH-1 downto 0);

    -- Instance du DUT
    component branchement_RI
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
    uut: branchement_RI
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
        -- Étape 1 : Réinitialisation du processeur
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Étape 2 : Simulation des instructions de type I
        -- L'IMEM contient déjà les instructions chargées via INIT_FILE.
        -- Nous observons les résultats au fur et à mesure de l'exécution.
        wait for 100 ns;  -- Laisser le temps à l'IMEM de fournir une instruction.

        -- Étape 3 : Attendre les résultats de l'ALU
        wait for 500 ns;

        -- Étape 4 : Comparaison avec les valeurs attendues
        -- Vous pouvez insérer des assertions ici pour vérifier les résultats
        -- Exemple pour ADDI : 
        -- assert (alu_result = expected_result)
        --     report "Erreur dans le calcul de ADDI" severity failure;

        -- Fin de la simulation après avoir testé plusieurs instructions
        wait for 1000 ns;
        assert false report "Fin de la simulation" severity failure;
    end process;

end behaviour;
