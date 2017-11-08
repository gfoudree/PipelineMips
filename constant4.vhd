library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity constant4 is
  port(o_constant4        : out std_logic_vector(31 downto 0)); 
 end constant4;
 
 architecture mixed of constant4 is 

begin
	o_constant4 <= "00000000000000000000000000000100";
end mixed;