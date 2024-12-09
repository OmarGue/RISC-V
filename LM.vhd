library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LM is
    port (
        data_in   : in std_logic_vector(31 downto 0); -- Donnees lues depuis la mémoire
        func3 : in std_logic_vector(2 downto 0);  -- Type d instruction Load(lb : 000 / lh : 001 etc)
        res      : in std_logic_vector(1 downto 0);  -- Bits de poids faible de l adresse(determine loffset a utiliser)
        data_out  : out std_logic_vector(31 downto 0) 
    );
end entity;

architecture behaviour of LM is
begin
    process(data_in, func3, res)
    begin
        case func3 is
            when "000" => -- LB
                case res is
                    when "00" => data_out <= std_logic_vector(resize(signed(data_in(7 downto 0)), 32));
						  --11111111 11111111 11111111 11110110 (en binaire)==> 0xFFFFFFF2 (en hex).
                    when "01" => data_out <= std_logic_vector(resize(signed(data_in(15 downto 8)), 32));
                    when "10" => data_out <= std_logic_vector(resize(signed(data_in(23 downto 16)), 32));
                    when "11" => data_out <= std_logic_vector(resize(signed(data_in(31 downto 24)), 32));
                    when others => data_out <= (others => '0');
                end case;
            when "001" => -- LH
                if res = "00" then
                    data_out <= std_logic_vector(resize(signed(data_in(15 downto 0)), 32));
                elsif res = "10" then
                    data_out <= std_logic_vector(resize(signed(data_in(31 downto 16)), 32));
                else
                    data_out <= (others => '0');
                end if;
            when "010" => -- LW
                data_out <= data_in;
            when "011" => -- LBU
                case res is
                    when "00" => data_out <= "000000000000000000000000" & data_in(7 downto 0);
                    when "01" => data_out <= "000000000000000000000000" & data_in(15 downto 8);
                    when "10" => data_out <= "000000000000000000000000" & data_in(23 downto 16);
                    when "11" => data_out <= "000000000000000000000000" & data_in(31 downto 24);
                    when others => data_out <= (others => '0');
                end case;
            when "100" => -- LHU
                if res = "00" then
                    data_out <= "0000000000000000" & data_in(15 downto 0);
                elsif res = "10" then
                    data_out <= "0000000000000000" & data_in(31 downto 16);
                else
                    data_out <= (others => '0');
                end if;
            when others =>
                data_out <= (others => '0');
        end case;
    end process;
end architecture;
