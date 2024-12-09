library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_banc_registre is
end entity tb_banc_registre;

architecture behav of tb_banc_registre is
component banc_registre

	 generic (
        DATA_WIDTH : integer := 32;    
        REG_COUNT  : integer := 32     
    );
    port (
        clk          : in std_logic;
		  we		      : in std_logic ;
        RW           : in std_logic_vector(4 downto 0);  
        RA           : in std_logic_vector(4 downto 0);  
        RB           : in std_logic_vector(4 downto 0);  
        BusW         : in std_logic_vector(DATA_WIDTH-1 downto 0); 
        BusA         : out std_logic_vector(DATA_WIDTH-1 downto 0); 
        BusB         : out std_logic_vector(DATA_WIDTH-1 downto 0)  
    );
	end component;

	-- Signaux pour tester le registre
	signal we_t		:std_logic ;
	signal RW_t : std_logic_vector(4 downto 0);
	signal RA_t : std_logic_vector(4 downto 0);
	signal RB_t : std_logic_vector(4 downto 0);
	signal BusW_t : std_logic_vector (31 downto 0);
	signal BusA_t : std_logic_vector (31 downto 0);
	signal BusB_t : std_logic_vector (31 downto 0);
	signal clk_t : std_logic := '0'; -- initialisation à 0
	
	begin 
	-- Instanciation du registre
	reg_2 : banc_registre
		generic map
		(
			DATA_WIDTH => 32,
			REG_COUNT => 32
		)
		port map
		(
			clk	=> clk_t,
			RW	=> RW_t,
			RA	=> RA_t,
			RB	=> RB_t,
			BusW	=> BusW_t,
			BusA	=> BusA_t,
			BusB	=> BusB_t,
         we => we_t
	
		);

	clk_t <= not clk_t after 50 ns;

     process
    begin
	 
	 for i in 0 to 31 loop 
        we_t <= '1';                       
        RW_t <= std_logic_vector(to_unsigned(i,5));                   
        BusW_t <= std_logic_vector(to_unsigned(31-i,32));    
		 wait for 10 ns; 
	end loop ;
	
	
	for i in 0 to 31 loop
		RA_t <= std_logic_vector(to_unsigned(i,5));
		RB_t <= std_logic_vector(to_unsigned(i,5)); 
		we_t <= '0';
		wait for 10 ns;
	end loop;
		 
		 wait;
	end process;
end behav;

 
