library ieee;
use ieee.std_logic_1164.all;

entity tb_LM is
end entity;

architecture behaviour of tb_LM is
    signal data_in   : std_logic_vector(31 downto 0) := (others => '0');
    signal func3 : std_logic_vector(2 downto 0) := (others => '0');
    signal res      : std_logic_vector(1 downto 0) := (others => '0');
    signal data_out  : std_logic_vector(31 downto 0);
    
    component LM
        port (
            data_in   : in std_logic_vector(31 downto 0);
            func3 : in std_logic_vector(2 downto 0);
            res      : in std_logic_vector(1 downto 0);
            data_out  : out std_logic_vector(31 downto 0)
        );
    end component;
begin
    uut: LM
        port map (
            data_in   => data_in,
            func3 => func3,
            res      => res,
            data_out  => data_out
        );

    process
    begin
        -- Test 1: LB, res = 00
        data_in <= x"12345678"; func3 <= "000"; res <= "00";
        wait for 10 ns;
        
        -- Test 2: LH, res = 10
        data_in <= x"12345678"; func3 <= "001"; res <= "10";
        wait for 10 ns;
        
        -- Test 3: LW
        data_in <= x"12345678"; func3 <= "010"; res <= "00";
        wait for 10 ns;
        
        -- Test 4: LBU, res = 01
        data_in <= x"12345678"; func3 <= "011"; res <= "01";
        wait for 10 ns;
        
        -- Test 5: LHU, res = 10
        data_in <= x"12345678"; func3 <= "100"; res <= "10";
        wait for 10 ns;

        -- Test Additional 5 cases...
        wait;
    end process;
end architecture;
