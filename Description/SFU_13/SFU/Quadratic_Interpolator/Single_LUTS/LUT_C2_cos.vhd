library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LUT_C2_cos is
	generic(
		word_bits	:natural:=12;
		bus_bits	:natural:=14;
		add_bits	:natural:=6
	);
	port(
		addr		:in std_logic_vector(add_bits-1 downto 0);
		data		:out std_logic_vector(bus_bits-1 downto 0)
	);
end entity;

architecture behav of LUT_C2_cos is
	type storage is array (0 to 2**add_bits-1) of std_logic_vector(word_bits-1 downto 0);
	signal rom:storage:=(
		"111111111111",
		"111111111110",
		"111111111100",
		"111111111001",
		"111111110101",
		"111111110000",
		"111111101010",
		"111111100011",
		"111111011011",
		"111111010010",
		"111111001000",
		"111110111110",
		"111110110010",
		"111110100101",
		"111110010111",
		"111110001000",
		"111101111000",
		"111101100111",
		"111101010110",
		"111101000011",
		"111100101111",
		"111100011011",
		"111100000101",
		"111011101110",
		"111011010111",
		"111010111111",
		"111010100101",
		"111010001011",
		"111001110000",
		"111001010100",
		"111000110111",
		"111000011001",
		"110111111011",
		"110111011011",
		"110110111011",
		"110110011001",
		"110101110111",
		"110101010100",
		"110100110000",
		"110100001100",
		"110011100110",
		"110011000000",
		"110010011001",
		"110001110001",
		"110001001001",
		"110000011111",
		"101111110101",
		"101111001010",
		"101110011111",
		"101101110010",
		"101101000101",
		"101100010111",
		"101011101001",
		"101010111010",
		"101010001010",
		"101001011001",
		"101000101000",
		"100111110111",
		"100111000100",
		"100110010001",
		"100101011110",
		"100100101001",
		"100011110101",
		"100010111111"
	);
begin
	data <= "10"&rom(to_integer(unsigned(addr)));
end architecture;