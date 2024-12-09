library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SM is
    port (
        addr     : in natural range 0 to 255;  -- Adresse de la mémoire
        data_in  : in std_logic_vector(31 downto 0); -- Données à stocker
        mem_type : in std_logic_vector(1 downto 0); -- 00=SW, 01=SH, 10=SB
        mem_out  : out std_logic_vector(31 downto 0)  -- Valeur stockée à l'adresse
    );
end entity;

architecture rtl of SM is
    type memory_t is array(0 to 255) of std_logic_vector(31 downto 0);
    signal ram : memory_t := (others => (others => '0'));  -- Mémoire initialisée à zéro
begin

    process(addr, data_in, mem_type)
    begin
        case mem_type is
            when "00" =>  -- SW: Store Word (32 bits)
                ram(addr) <= data_in;

            when "01" =>  -- SH: Store Half-word (16 bits)
                -- Récupérer le mot actuel
                ram(addr)(15 downto 0) <= data_in(15 downto 0);  -- Stocker les 16 bits
                -- Les 16 bits supérieurs restent inchangés

            when "10" =>  -- SB: Store Byte (8 bits)
                -- Stocker l'octet dans le mot
                ram(addr)(7 downto 0) <= data_in(7 downto 0);  -- Stocker les 8 bits
                -- Les autres octets restent inchangés

            when others =>  -- Cas par défaut (non utilisé ici)
                null;
        end case;
    end process;

    -- Sortie de la mémoire à l'adresse donnée
    mem_out <= ram(addr);
end architecture;
