library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LUT_C2_sqrt_2_4 is
	generic(
		word_bits	:natural:=9;
		bus_bits	:natural:=14;
		add_bits	:natural:=6
	);
	port(
		addr		:in std_logic_vector(add_bits-1 downto 0);
		data		:out std_logic_vector(bus_bits-1 downto 0)
	);
end entity;

architecture behav of LUT_C2_sqrt_2_4 is
	type storage is array (0 to 2**add_bits-1) of std_logic_vector(word_bits-1 downto 0);
	signal rom:storage:=(
		"101100101",
		"101011101",
		"101010101",
		"101001110",
		"101000110",
		"100111111",
		"100111001",
		"100110010",
		"100101100",
		"100100110",
		"100100000",
		"100011010",
		"100010101",
		"100001111",
		"100001010",
		"100000101",
		"100000000",
		"011111011",
		"011110111",
		"011110010",
		"011101110",
		"011101010",
		"011100110",
		"011100010",
		"011011110",
		"011011010",
		"011010111",
		"011010011",
		"011010000",
		"011001101",
		"011001001",
		"011000110",
		"011000011",
		"011000000",
		"010111101",
		"010111010",
		"010110111",
		"010110101",
		"010110010",
		"010110000",
		"010101101",
		"010101011",
		"010101000",
		"010100110",
		"010100100",
		"010100001",
		"010011111",
		"010011101",
		"010011011",
		"010011001",
		"010010111",
		"010010101",
		"010010011",
		"010010001",
		"010001111",
		"010001101",
		"010001100",
		"010001010",
		"010001000",
		"010000111",
		"010000101",
		"010000011",
		"010000010",
		"010000000"
	);
begin
	data <= "100"&rom(to_integer(unsigned(addr)))&"00";
end architecture;