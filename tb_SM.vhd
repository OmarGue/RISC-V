library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SM_tb is
end entity;

architecture test of SM_tb is
    signal addr     : natural range 0 to 255;
    signal data_in  : std_logic_vector(31 downto 0);
    signal mem_type : std_logic_vector(1 downto 0);
    signal mem_out  : std_logic_vector(31 downto 0);

    -- Composant SM instancié
    component SM
        port (
            addr     : in natural range 0 to 255;
            data_in  : in std_logic_vector(31 downto 0);
            mem_type : in std_logic_vector(1 downto 0);
            mem_out  : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    -- Instantiation du module SM
    uut: SM port map (
        addr => addr,
        data_in => data_in,
        mem_type => mem_type,
        mem_out => mem_out
    );

    -- Test du bloc SM
    process
    begin
        -- Test SW
        addr <= 0;
        data_in <= "00000000000000000000000000000001"; -- Valeur à stocker (32 bits)
        mem_type <= "00"; -- Store Word
        wait for 10 ns;

        -- Test SH
        addr <= 1;
        data_in <= "00000000000000001111000011110000"; -- Demi-mot à stocker
        mem_type <= "01"; -- Store Half-word
        wait for 10 ns;

        -- Test SB
        addr <= 2;
        data_in <= "00000000000000000000000011110000"; -- Octet à stocker
        mem_type <= "10"; -- Store Byte
        wait for 10 ns;

        -- Terminer la simulation
        wait;
    end process;
end architecture;
