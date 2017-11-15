library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sll_2_PC is
 port(	i_to_shift	:	in std_logic_vector(31 downto 0);
			in_PC			: in std_logic_vector(3 downto 0);
			o_shifted	:	out std_logic_vector(31 downto 0));
end sll_2_PC;

architecture mixed of sll_2_PC is

begin
	o_shifted(31 downto 28) <= in_PC(3 downto 0);
	o_shifted(27 downto 2) <= i_to_shift(25 downto 0);
	o_shifted(1 downto 0) <= "00";
end mixed;