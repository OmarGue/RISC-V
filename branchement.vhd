library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Déclaration de l'entité pour le composant de branchement
entity branchement is
    generic
    (
        DATA_WIDTH : natural := 32;
        ADDR_WIDTH : natural := 8;
        MEM_DEPTH  : natural := 100;
        INIT_FILE  : string  := "O:\S9\S9_Conception\add_02.hex" -- Nom du fichier de mémoire
    );
    port
    (
        clk      : in std_logic;
        reset    : in std_logic
    );
end entity branchement;

architecture Behavioral of branchement is

    -- Signaux internes
    signal pc_out     : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal instr      : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal alu_result : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal bus_a      : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal bus_b      : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal alu_op     : std_logic_vector(3 downto 0);
    signal load_pc    : std_logic;
    signal reg_we     : std_logic := '1';
    signal bus_w      : std_logic_vector(DATA_WIDTH-1 downto 0);

    -- Signaux intermédiaires pour les adresses RA, RB, RW
    signal ra_sig : natural range 0 to (2**ADDR_WIDTH - 1);
    signal rb_sig : natural range 0 to (2**ADDR_WIDTH - 1);
    signal rw_sig : natural range 0 to (2**ADDR_WIDTH - 1);
    
    -- Immédiat étendu
    signal imm_ext_s : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal opB_mux   : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ri_sel    : std_logic; -- Sélecteur pour le MUX

    -- Déclarations de composants
    component PC
        generic 
        (
            DATA_WIDTH : natural := 32;
            ADDR_WIDTH : natural := 8
        );
        port 
        (
            reset : in std_logic;
            load  : in std_logic;
            din   : in std_logic_vector((DATA_WIDTH-1) downto 0);
            dout  : out std_logic_vector((DATA_WIDTH-1) downto 0)
        );
    end component;

    component imem
        generic
        (
            DATA_WIDTH  : natural := 32;
            ADDR_WIDTH  : natural := 8;
            MEM_DEPTH   : natural := 100;
            INIT_FILE   : string
        );
        port
        (
            address   : in std_logic_vector(ADDR_WIDTH-1 downto 0);
            Data_Out  : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    component controleur
        port 
        (
            clk    : in std_logic;
            instr  : in std_logic_vector(DATA_WIDTH-1 downto 0);
            we     : in std_logic;
            aluOp  : out std_logic_vector(3 downto 0);
            LOAD   : out std_logic;
            RI_sel : out std_logic -- Nouvel ajout pour piloter le MUX
        );
    end component;

    component banc_registre
        generic
        (
            DATA_WIDTH : natural := 32;    
            ADDR_WIDTH : natural := 5
        );
        port
        (
            BusA   : out std_logic_vector(DATA_WIDTH-1 downto 0);
            BusB   : out std_logic_vector(DATA_WIDTH-1 downto 0);
            BusW   : in std_logic_vector(DATA_WIDTH-1 downto 0);
            clk    : in std_logic;
            RA     : in natural range 0 to (2**ADDR_WIDTH - 1);
            RB     : in natural range 0 to (2**ADDR_WIDTH - 1);
            RW     : in natural range 0 to (2**ADDR_WIDTH - 1);
            we     : in std_logic
        );
    end component;

    component ALU
        port
        (
            opA   : in  std_logic_vector(DATA_WIDTH-1 downto 0);  
            opB   : in  std_logic_vector(DATA_WIDTH-1 downto 0);  
            aluOp : in  std_logic_vector(3 downto 0);   
            res   : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    component Imm_ext 
        generic
        (
            INSTR_WIDTH : natural := 32
        );
        port
        (
            instr    : in  std_logic_vector(INSTR_WIDTH-1 downto 0);
            immExt   : out std_logic_vector(INSTR_WIDTH-1 downto 0);
            instType : in  std_logic_vector(6 downto 0)
        );
    end component;

    component mux_2_1
        generic
        (
            INSTR_WIDTH : natural := 32
        );
        port
        (
            input1 : in  std_logic_vector(INSTR_WIDTH-1 downto 0);
            input2 : in  std_logic_vector(INSTR_WIDTH-1 downto 0);
            RI_sel : in  std_logic;
            output : out std_logic_vector(INSTR_WIDTH-1 downto 0)
        );
    end component;

begin

    -- Assignation des signaux intermédiaires pour RA, RB, RW
    ra_sig <= to_integer(unsigned(instr(19 downto 15))); -- Source registre 1
    rb_sig <= to_integer(unsigned(instr(24 downto 20))); -- Source registre 2
    rw_sig <= to_integer(unsigned(instr(11 downto 7)));  -- Registre de destination

    -- Program Counter (PC)
    pc_inst: PC
        generic map
        (
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map
        (
            reset => reset,
            load  => load_pc,
            din   => alu_result, -- Mise à jour PC par ALU
            dout  => pc_out
        );

    -- Instruction Memory (IMEM)
    imem_inst: imem
        generic map
        (
            DATA_WIDTH  => DATA_WIDTH,
            ADDR_WIDTH  => ADDR_WIDTH,
            MEM_DEPTH   => MEM_DEPTH,
            INIT_FILE   => INIT_FILE
        )
        port map
        (
            address  => pc_out(ADDR_WIDTH-1 downto 0), -- PC utilisé comme adresse
            Data_Out => instr
        );

    -- Controleur
    controleur_inst: controleur
        port map
        (
            clk    => clk,
            instr  => instr,
            we     => reg_we,
            aluOp  => alu_op,
            LOAD   => load_pc,
            RI_sel => ri_sel
        );

    -- Banc de Registres
    banc_reg_inst: banc_registre
        generic map
        (
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => 5 -- Taille des adresses
        )
        port map
        (
            BusA => bus_a,
            BusB => bus_b,
            BusW => bus_w,
            clk  => clk,
            RA   => ra_sig,
            RB   => rb_sig,
            RW   => rw_sig,
            we   => reg_we
        );

    -- Imm_ext
    imm_ext_inst: Imm_ext
        generic map
        (
            INSTR_WIDTH => DATA_WIDTH
        )
        port map
        (
            instr    => instr,
            immExt   => imm_ext_s,
            instType => instr(6 downto 0)
        );

    -- MUX_2_1
    mux_inst: mux_2_1
        generic map
        (
            INSTR_WIDTH => DATA_WIDTH
        )
        port map
        (
            input1 => bus_b,
            input2 => imm_ext_s,
            RI_sel => ri_sel,
            output => opB_mux
        );

    -- ALU
    alu_inst: ALU
        port map
        (
            opA   => bus_a,
            opB   => opB_mux,
            aluOp => alu_op,
            res   => alu_result
        );

    -- Écriture des résultats dans les registres
    bus_w <= alu_result;

end architecture Behavioral;
