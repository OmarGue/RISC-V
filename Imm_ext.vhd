library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Imm_ext is
    generic (
        INSTR_WIDTH : natural := 32
    );

    port (
        instr    : in std_logic_vector((INSTR_WIDTH - 1) downto 0);  -- Instruction d'entrée
        immExt   : out std_logic_vector((INSTR_WIDTH - 1) downto 0);  -- Extension de l'immédiat
        instType : in std_logic_vector(6 downto 0)  -- Type de l'instruction
    );
end entity;

architecture arch of Imm_ext is
begin

    process(instr, instType)
        variable extension : std_logic_vector(INSTR_WIDTH - 1 downto 0) := (others => '0');  -- Extension de l'immédiat
    begin
        case instType is
            -- Type I : Récupération des bits [31:20] et extension
            when "0010011"  =>  
                extension := (others => instr(31));  -- Extension de signe
                immExt <= extension & instr(31 downto 20);  -- Extension de signe et concaténation des bits de l'immédiat

            -- Type S : Extraction des bits [31:25] et [11:7] pour l'immédiat
            when "0100011" =>  
                -- Extraction des bits [31:25] et [11:7]
                extension := (others => instr(31));  -- Extension de signe de l'immédiat
                immExt <= extension & instr(31 downto 25) & instr(11 downto 7);  -- Concaténation des bits de l'immédiat avec extension

            when others =>
                immExt <= (others => '0');  -- Par défaut, on met l'immédiat à 0

        end case;
    end process;
end architecture;
