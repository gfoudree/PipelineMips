-- Copyright (C) 2016  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Intel and sold by Intel or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 16.1.0 Build 196 10/24/2016 SJ Standard Edition"
-- CREATED		"Wed Nov 01 17:18:14 2017"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY projectB IS 
	PORT
	(
		CLK :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC
	);
END projectB;

ARCHITECTURE bdf_type OF projectB IS 

COMPONENT pc_reg
	PORT(CLK : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 i_next_PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 o_PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT adder_32
	PORT(i_A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 i_B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 o_F : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT sll_2
	PORT(i_to_shift : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 o_shifted : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux21_32bit
	PORT(i_sel : IN STD_LOGIC;
		 i_0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 i_1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 o_mux : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux21_5bit
	PORT(i_sel : IN STD_LOGIC;
		 i_0 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 i_1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 o_mux : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END COMPONENT;

COMPONENT and_2
	PORT(i_A : IN STD_LOGIC;
		 i_B : IN STD_LOGIC;
		 o_F : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT constantvalue
	PORT(		 o_constant : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT constant4
	PORT(		 o_constant4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT sll_2_pc
	PORT(i_to_shift : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 in_PC : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 o_shifted : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT register_file
	PORT(CLK : IN STD_LOGIC;
		 w_en : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 rs_sel : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 rt_sel : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 w_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 w_sel : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 rs_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 rt_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT alu
	PORT(ALU_OP : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 i_A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 i_B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 shamt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 zero : OUT STD_LOGIC;
		 ALU_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT imem
GENERIC (depth_exp_of_2 : INTEGER;
			mif_filename : STRING
			);
	PORT(clock : IN STD_LOGIC;
		 wren : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 byteena : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT dmem
GENERIC (depth_exp_of_2 : INTEGER;
			mif_filename : STRING
			);
	PORT(clock : IN STD_LOGIC;
		 wren : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 byteena : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT main_control
	PORT(i_instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 o_reg_dest : OUT STD_LOGIC;
		 o_jump : OUT STD_LOGIC;
		 o_branch : OUT STD_LOGIC;
		 o_mem_to_reg : OUT STD_LOGIC;
		 o_mem_write : OUT STD_LOGIC;
		 o_ALU_src : OUT STD_LOGIC;
		 o_reg_write : OUT STD_LOGIC;
		 o_ALU_op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT sign_extender_16_32
	PORT(i_to_extend : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 o_extended : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	adder_to_mux :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	ALU_out :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	and_o_F :  STD_LOGIC;
SIGNAL	constant_to_imem :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	dmem_q :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	mux_to_ALU :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	mux_to_PC_reg :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	mux_to_reg_file_w_data :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	mux_to_reg_file_w_sel :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	o_ALU_op :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	o_ALU_src :  STD_LOGIC;
SIGNAL	o_branch :  STD_LOGIC;
SIGNAL	o_constant4 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	o_extended :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	o_F :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	o_mem_to_reg :  STD_LOGIC;
SIGNAL	o_mem_write :  STD_LOGIC;
SIGNAL	o_PC :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	o_reg_dest :  STD_LOGIC;
SIGNAL	o_reg_write :  STD_LOGIC;
SIGNAL	PC_shifted_to_mux :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	q :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	reg_file_rs_data :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	reg_file_rt_data :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	shifted_to_adder :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	zero :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(0 TO 3);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(0 TO 3);


BEGIN 
SYNTHESIZED_WIRE_2 <= '0';
SYNTHESIZED_WIRE_3 <= "1111";
SYNTHESIZED_WIRE_4 <= "1111";



b2v_inst : pc_reg
PORT MAP(CLK => CLK,
		 reset => reset,
		 i_next_PC => mux_to_PC_reg,
		 o_PC => o_PC);


b2v_inst1 : adder_32
PORT MAP(i_A => o_PC,
		 i_B => o_constant4,
		 o_F => o_F);


b2v_inst10 : sll_2
PORT MAP(i_to_shift => o_extended,
		 o_shifted => shifted_to_adder);


b2v_inst11 : mux21_32bit
PORT MAP(i_sel => o_ALU_src,
		 i_0 => reg_file_rt_data,
		 i_1 => o_extended,
		 o_mux => mux_to_ALU);


b2v_inst12 : mux21_32bit
PORT MAP(i_sel => o_mem_to_reg,
		 i_0 => ALU_out,
		 i_1 => dmem_q,
		 o_mux => mux_to_reg_file_w_data);


b2v_inst13 : mux21_32bit
PORT MAP(i_sel => and_o_F,
		 i_0 => o_F,
		 i_1 => adder_to_mux,
		 o_mux => SYNTHESIZED_WIRE_1);



b2v_inst15 : mux21_5bit
PORT MAP(i_sel => o_reg_dest,
		 i_0 => q(20 DOWNTO 16),
		 i_1 => q(15 DOWNTO 11),
		 o_mux => mux_to_reg_file_w_sel);



b2v_inst17 : and_2
PORT MAP(i_A => o_branch,
		 i_B => zero,
		 o_F => and_o_F);


b2v_inst19 : constantvalue
PORT MAP(		 o_constant => constant_to_imem);



b2v_inst20 : constant4
PORT MAP(		 o_constant4 => o_constant4);


b2v_inst21 : mux21_32bit
PORT MAP(i_sel => SYNTHESIZED_WIRE_0,
		 i_0 => SYNTHESIZED_WIRE_1,
		 i_1 => PC_shifted_to_mux,
		 o_mux => mux_to_PC_reg);


b2v_inst22 : sll_2_pc
PORT MAP(i_to_shift => q,
		 in_PC => o_F(31 DOWNTO 28),
		 o_shifted => PC_shifted_to_mux);


b2v_inst3 : register_file
PORT MAP(CLK => CLK,
		 w_en => o_reg_write,
		 reset => reset,
		 rs_sel => q(25 DOWNTO 21),
		 rt_sel => q(20 DOWNTO 16),
		 w_data => mux_to_reg_file_w_data,
		 w_sel => mux_to_reg_file_w_sel,
		 rs_data => reg_file_rs_data,
		 rt_data => reg_file_rt_data);


b2v_inst4 : alu
PORT MAP(ALU_OP => o_ALU_op,
		 i_A => reg_file_rs_data,
		 i_B => mux_to_ALU,
		 shamt => q(10 DOWNTO 6),
		 zero => zero,
		 ALU_out => ALU_out);


b2v_inst5 : imem
GENERIC MAP(depth_exp_of_2 => 10,
			mif_filename => "imem.mif"
			)
PORT MAP(clock => CLK,
		 wren => SYNTHESIZED_WIRE_2,
		 address => o_PC(11 DOWNTO 2),
		 byteena => SYNTHESIZED_WIRE_3,
		 data => constant_to_imem,
		 q => q);


b2v_inst6 : dmem
GENERIC MAP(depth_exp_of_2 => 10,
			mif_filename => "dmem.mif"
			)
PORT MAP(clock => CLK,
		 wren => o_mem_write,
		 address => ALU_out(11 DOWNTO 2),
		 byteena => SYNTHESIZED_WIRE_4,
		 data => reg_file_rt_data,
		 q => dmem_q);


b2v_inst7 : main_control
PORT MAP(i_instruction => q,
		 o_reg_dest => o_reg_dest,
		 o_jump => SYNTHESIZED_WIRE_0,
		 o_branch => o_branch,
		 o_mem_to_reg => o_mem_to_reg,
		 o_mem_write => o_mem_write,
		 o_ALU_src => o_ALU_src,
		 o_reg_write => o_reg_write,
		 o_ALU_op => o_ALU_op);


b2v_inst8 : sign_extender_16_32
PORT MAP(i_to_extend => q(15 DOWNTO 0),
		 o_extended => o_extended);


b2v_inst9 : adder_32
PORT MAP(i_A => o_F,
		 i_B => shifted_to_adder,
		 o_F => adder_to_mux);


END bdf_type;