module singlecycle (
	//inputs
	input logic i_clk,
	input logic i_reset,
	input logic [31:0] i_io_sw,
	//outputs
	output logic [31:0] o_io_lcd,
	output logic [31:0] o_io_ledg,
	output logic [31:0] o_io_ledr,
  	output logic [6:0]   o_io_hex0,
  	output logic [6:0]   o_io_hex1,
  	output logic [6:0]   o_io_hex2,
  	output logic [6:0]   o_io_hex3,
  	output logic [6:0]   o_io_hex4,
  	output logic [6:0]       o_io_hex5,
  	output logic [6:0]       o_io_hex6,
  	output logic [6:0]       o_io_hex7,
	//----signals for debugging---//
	output logic [31:0] o_pc_debug,
	output logic o_insn_vld
	);
	 
//------Wire--------//
    logic pc_sel;
    logic opa_sel;
    logic opb_sel;
    logic rd_wren;
    logic br_un;
    logic br_less;
    logic br_equal;
    logic lsu_wren;
    logic [1:0]  wb_sel;
    logic [3:0]  alu_op;
    logic [31:0] alu_data;
    logic [31:0] pc_next;
    logic [31:0] op_a;
    logic [31:0] pc;
    logic [31:0] rs1_data;
    logic [31:0] op_b;
    logic [31:0] rs2_data;
    logic [31:0] wb_data;
    logic [31:0] pc_four;
    logic [31:0] ld_data;
    logic [31:0] immediate;
    logic [31:0] instr;

assign o_pc_debug = pc;
   
endmodule