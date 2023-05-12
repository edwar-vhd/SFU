-----------------------------------------------------------------------------
-- Proyecto				: RRO IEEE754
-- Nombre de archivo	: RRO.vhd
-- Titulo				: 
-----------------------------------------------------------------------------
-- Descripcion			:
-----------------------------------------------------------------------------
-- Universidad Pedagogica y Tecnologica de Colombia.
-- Facultad de Ingeniería
-- Escuela de Ingenieria Electronica - Extension Tunja.
-- 
-- Autor: 
-- June 2020
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rro is
	port(
		selec_phase 	:in std_logic;
		input       	:in std_logic_vector(31 downto 0);
		Result         :out std_logic_vector(31 downto 0)
	);
end entity rro;

architecture rtl of rro is 
	signal rro_trig_out,ieee_out_sin_cos :std_logic_vector(31 downto 0);
	signal rro_trig_qua	:std_logic_vector(1 downto 0);
	signal rro_trig_Fixed_point :std_logic_vector(23 downto 0);
	signal rro_trig_shift		:std_logic_vector(7 downto 0);
	signal rro_trig_Result		:std_logic_vector(31 downto 0);

	signal s_too_big_exponent 	:std_logic :='0';
	signal s_exp2_shift 		:std_logic_vector(7 downto 0) :=(others=>'0');
	signal s_exp2_fixed_point 	:std_logic_vector(31 downto 0) :=(others=>'0');
	signal s_exp2_sign_ext		:std_logic_vector(31 downto 0) :=(others=>'0');
	signal s_exp2_cmp			:std_logic_vector(31 downto 0) :=(others=>'0');
	signal s_exp2_final_result  :std_logic_vector(31 downto 0):=(others=>'0');
	signal s_exp2_adjs			:std_logic_vector(31 downto 0):=(others=>'0');
begin 
	--Range reduction operation for trigonometric operations
	U0: entity work.RRO_trig
		port map(input_data  => input, 
					output_data => rro_trig_out,
				 quadrant => rro_trig_qua);

	rro_trig_shift <= std_logic_vector(to_unsigned(127,8)-unsigned(rro_trig_out(30 downto 23)));

	rro_trig_Fixed_point <= std_logic_vector(unsigned('1'&rro_trig_out(22 downto 0)) srl to_integer(unsigned(rro_trig_shift)));


	rro_trig_Result <= input(31)&rro_trig_qua&"00000"&rro_trig_Fixed_point;


	IEEE_special_cases: process(input,rro_trig_Result)
	begin 
		if(input(30 downto 23)=X"FF") then --or input(30 downto 23)=X"00") then
			ieee_out_sin_cos <= input;
		else
			ieee_out_sin_cos <= rro_trig_Result;
		end if;
	end process;

	--Range Reduction operation for exponential function
	s_too_big_exponent 	<= '1' when unsigned(input(30 downto 23))>133 else '0';
	s_exp2_shift 			<= std_logic_vector(to_unsigned(133,8) - unsigned(input(30 downto 23)));
	s_exp2_fixed_point 	<= std_logic_vector(unsigned("001"&input(22 downto 0)&"000000") srl to_integer(unsigned(s_exp2_shift)));
	s_exp2_sign_ext		<= (others=>input(31));
	s_exp2_cmp				<= s_exp2_fixed_point xor s_exp2_sign_ext;
	s_exp2_adjs				<= std_logic_vector(unsigned(s_exp2_cmp) + 1) when input(31)='1' else s_exp2_cmp;
	s_exp2_final_result <=  '1'&"00001111"&"00000000000000000000000" when (input=X"7f800000") else  --+inf
		'1'&"11110000"&"00000000000000000000000" when (input=X"ff800000") else  -- -inf
		'1'&"11111111"&input(22 downto 0) when (input(30 downto 23)=X"FF" and input(22 downto 0)/="00000000000000000000000") else --NAN
		'1'&"00001111"&"00000000000000000000000" when (s_too_big_exponent='1' and input(31)='0') else
		'1'&"11110000"&"00000000000000000000000" when (s_too_big_exponent='1' and input(31)='1') else
		'1'&"00000000"&"00000000000000000000000" when (input=X"00000000" or input(30 downto 23)=X"00")  else  -- Zero/subnorm
		'0'&s_exp2_adjs(30 downto 0);
	Result 					<= s_exp2_final_result when selec_phase='1' else ieee_out_sin_cos;
end architecture;