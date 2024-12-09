library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ALU is
end tb_ALU;

architecture Behavioral of tb_ALU is
    component ALU
        Port (
            opA   : in  std_logic_vector(31 downto 0);
            opB   : in  std_logic_vector(31 downto 0);
            aluOp : in  std_logic_vector(3 downto 0);
            res  : out std_logic_vector(31 downto 0)
        );
    end component;
	 
	 
	 signal opA_t   : std_logic_vector(31 downto 0);
    signal opB_t   : std_logic_vector(31 downto 0);
    signal aluOp_t : std_logic_vector(3 downto 0);
    signal res_t    : std_logic_vector(31 downto 0);

begin
    UUT: ALU
        Port Map (
            opA => opA_t ,
            opB => opB_t ,
            aluOp => aluOp_t ,
            res => res_t
        );

    process
    begin
        -- ADD tests
        opA_t <= x"00000001";  -- 1
        opB_t <= x"00000002";  -- 2
        aluOp_t <= "0000";     -- ADD
        wait for 10 ns;
       -- assert res_t = x"00000003" report "Error in ADD test 1" severity error;

--        opA_t <= x"0000000A";  -- 10
--        opB_t <= x"00000014";  -- 20
--        aluOp_t <= "0000";     -- ADD
--        wait for 10 ns;
--        assert res_t = x"0000001E" report "Error in ADD test 2" severity error;
--
--        -- SUB tests
--        opA_t <= x"00000005";  -- 5
--        opB_t <= x"00000003";  -- 3
--        aluOp_t <= "0001";     -- SUB
--        wait for 10 ns;
--        assert res_t = x"00000002" report "Error in SUB test 1" severity error;
--
--        opA_t <= x"00000010";  -- 16
--        opB_t <= x"00000004";  -- 4
--        aluOp_t <= "0001";     -- SUB
--        wait for 10 ns;
--        assert res_t = x"0000000C" report "Error in SUB test 2" severity error;
--
--      
--        opA_t <= x"0000000F";  -- 15
--        opB_t <= x"00000003";  -- 3
--        aluOp_t <= "1001";     -- AND
--        wait for 10 ns;
--        assert res_t = x"00000003" report "Error in AND test 1" severity error;
--
--        opA_t <= x"FFFFFFFF";  -- -1
--        opB_t <= x"00000001";  -- 1
--        aluOp_t <= "1001";     -- AND
--        wait for 10 ns;
--        assert res_t = x"00000001" report "Error in AND test 2" severity error;
--
--        -- OR tests
--        opA_t <= x"0000000F";  -- 15
--        opB_t <= x"00000003";  -- 3
--        aluOp_t <= "1000";     -- OR
--        wait for 10 ns;
--        assert res_t = x"0000000F" report "Error in OR test 1" severity error;
--
--        opA_t <= x"FFFFFFFF";  -- -1
--        opB_t <= x"00000000";  -- 0
--        aluOp_t <= "1000";     -- OR
--        wait for 10 ns;
--        assert res_t = x"FFFFFFFF" report "Error in OR test 2" severity error;
--
--        -- XOR tests
--        opA_t <= x"0000000F";  -- 15
--        opB_t <= x"00000003";  -- 3
--        aluOp_t <= "0101";     -- XOR
--        wait for 10 ns;
--        assert res_t = x"0000000C" report "Error in XOR test 1" severity error;
--
--        opA_t <= x"FFFFFFFF";  -- -1
--        opB_t <= x"00000001";  -- 1
--        aluOp_t <= "0101";     -- XOR
--        wait for 10 ns;
--        assert res_t = x"FFFFFFFF" report "Error in XOR test 2" severity error;

        wait;
    end process;
end Behavioral;
