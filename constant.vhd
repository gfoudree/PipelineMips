library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity constantValue is
  port(o_constant        : out std_logic_vector(31 downto 0)); 
 end constantValue;
 
 architecture mixed of constantValue is 

begin
	o_constant <= (others => '0');
end mixed;