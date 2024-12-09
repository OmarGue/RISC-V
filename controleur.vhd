library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controleur is
    generic 
    (
        DATA_WIDTH : natural := 32;
        ADDR_WIDTH : natural := 8
    );
    port 
    (
        clk    : in std_logic;
        instr  : in std_logic_vector((DATA_WIDTH-1) downto 0);
        we     : out std_logic ;
        aluOp  : out std_logic_vector(3 downto 0);
		  load   : out std_logic;
		  RI_sel : out std_logic;
		  wrMem  : out std_logic;
		  loadAcc: out std_logic
    );
end controleur;

architecture comportement of controleur is

    alias rs1    : std_logic_vector(4 downto 0) is instr(19 downto 15);
    alias rs2    : std_logic_vector(4 downto 0) is instr(24 downto 20);
    alias rd     : std_logic_vector(4 downto 0) is instr(11 downto 7);
    alias opCode : std_logic_vector(6 downto 0) is instr(6 downto 0);
    alias func3  : std_logic_vector(2 downto 0) is instr(14 downto 12);
    alias func7  : std_logic_vector(6 downto 0) is instr(31 downto 25);

begin
	load <= '0';
process(OpCode, func7(5), func3)
begin
    case opCode is  
        when "0110011" => -- Type R
            aluOp <= func7(5) & func3; -- Concatene le bit numero 5 de funct7 avec funct3
				RI_sel <= '0';
				loadAcc <= '0';
				we <= '1';
				wrMem <= '0';
				
		  when "0010011" => -- Type I
				aluOp <= func7(5) & func3;
				RI_sel <= '1';
				loadAcc <= '0';
				we <= '1';
				wrMem <= '0';
		
		  when "0000011" =>  -- Type L
			   aluOp <= "0000"; --car c une addition (rs1+offset)
				RI_sel <= '1';
				loadAcc <= '1';
				we <= '1';
				wrMem <= '0';
				
		when "0100011" => -- Type S
				RI_sel <= '1';
				loadAcc <= '1';
				we <= '0';
				wrMem <= '1';
				aluOp <= "0000";
				
        when others => 
            aluOp <= "1111";  -- Operation inconnue
    end case;
end process;

end comportement;
