module singlecycle (
	input logic i_clk,
	input logic i_reset,
	input logic [31:0] i_io_sw,
	output logic o_insn_vld,
	output logic [6:0] o_io_hex07,
	output logic [31:0] o_pc_debug,
	output logic [31:0] o_io_ledr,
	output logic [31:0] o_io_ledg,
	output logic [31:0] o_io_lcd
	);
endmodule