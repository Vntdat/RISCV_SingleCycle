module singlecycle (
    // Inputs
    input logic i_clk,
    input logic i_reset,
    input logic [31:0] i_io_sw,

    // Outputs
    output logic [31:0] o_io_lcd,
    output logic [31:0] o_io_ledg,
    output logic [31:0] o_io_ledr,
    output logic [6:0] o_io_hex0,
    output logic [6:0] o_io_hex1,
    output logic [6:0] o_io_hex2,
    output logic [6:0] o_io_hex3,
    output logic [6:0] o_io_hex4,
    output logic [6:0] o_io_hex5,
    output logic [6:0] o_io_hex6,
    output logic [6:0] o_io_hex7,
    // Debugging signal
    output logic [31:0] o_pc_debug
);

    // Wire declarations
    logic pc_sel;
    logic rd_wren;
    logic br_un;
    logic br_less;
    logic br_equal;
    logic opa_sel;
    logic opb_sel;
    logic [3:0] alu_op;
    logic mem_wren;
    logic [1:0] wb_sel;
    logic [31:0] instr;
    logic [31:0] pc_four;
    logic [31:0] pc_next;
    logic [31:0] pc;
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [31:0] immediate;
    logic [31:0] operand_a;
    logic [31:0] operand_b;
    logic [31:0] alu_data;
    logic [31:0] ld_data;
    logic [31:0] wb_data;
    logic [3:0] lsu_op;

    // Debugging output
    assign o_pc_debug = pc;


    // Registers
    regfile regfile (
        .i_clk          (i_clk),
        .i_reset        (i_reset),
        .i_rs1_addr     (instr[19:15]),
        .i_rs2_addr     (instr[24:20]),
        .i_rd_addr      (instr[11:7]),
        .i_rd_data      (wb_data),
        .i_rd_wren      (rd_wren),
        .o_rs1_data     (rs1_data),
        .o_rs2_data     (rs2_data)
    );

    // Immediate generation
    immgen immgen (
        .i_inst (instr),
        .o_imm (immediate)
    );

    // Branch comparison logic
    brc brc (
        .i_rs1_data      (rs1_data),
        .i_rs2_data      (rs2_data),
        .i_br_un         (br_un),
        .o_br_less       (br_less),
        .o_br_equal      (br_equal)
    );

    // ALU operation
    alu alu (
        .i_op_a      (operand_a),
        .i_op_b      (operand_b),
        .i_alu_op    (alu_op),
        .o_alu_data  (alu_data)
    );

    // Operand selection
    mux2_1_32bit opa (
        .a (rs1_data),
        .b (pc),
        .s (opa_sel),
        .y (operand_a)
    );

    mux2_1_32bit opb (
        .a (rs2_data),
        .b (immediate),
        .s (opb_sel),
        .y (operand_b)
    );

    // LSU (Load/Store Unit)
    lsu lsu (
		.i_clk 	(i_clk),
		.i_reset (i_reset),
		.i_addr 	(alu_data),
		.i_wdata (rs2_data),
		.i_bmask (lsu_op),
		.i_wren	(mem_wren),
		.o_rdata (ld_data),
        .o_io_ledr     (o_io_ledr),
        .o_io_ledg     (o_io_ledg),
        .o_io_hex0     (o_io_hex0),
        .o_io_hex1     (o_io_hex1),
        .o_io_hex2     (o_io_hex2),
        .o_io_hex3     (o_io_hex3),
        .o_io_hex4     (o_io_hex4),
        .o_io_hex5     (o_io_hex5),
        .o_io_hex6     (o_io_hex6),
        .o_io_hex7     (o_io_hex7),
        .o_io_lcd      (o_io_lcd),
        .i_io_sw       (i_io_sw)
    );

/*
	dmem data_mem(
		.i_clk         (i_clk),
		.i_reset       (i_reset),
		.i_lsu_addr    (alu_data),
		.i_st_data     (rs2_data),
		.i_lsu_wren    (mem_wren),
		.o_ld_data     (ld_data)
	);
*/

    // Control unit
    controlunit controlunit (
        .i_instr    (instr),
        .br_less    (br_less),
        .br_equal   (br_equal),
        .pc_sel     (pc_sel),
        .rd_wren    (rd_wren),
        .br_un      (br_un),
        .opa_sel    (opa_sel),
        .opb_sel    (opb_sel),
        .mem_wren   (mem_wren),
        .alu_op     (alu_op),
        .wb_sel     (wb_sel),
	.lsu_op      (lsu_op)
    );

    // Memory unit (for fetching instructions)
	imem instr_mem (
	.i_addr (pc),
	.o_inst (instr)
	);

   assign pc_four = pc + 32'd4;
    //mux-PC source
    always_comb begin
        if (pc_sel) begin //PC4-0 and ALU_DATA-1
            pc_next = alu_data;
        end
        else begin
            pc_next = pc_four;
        end
    end
    //PC counter
    always_ff @(posedge i_clk) begin
        if (i_reset) pc <= 32'h0;
        else pc <= pc_next;
    end

    // Write-back multiplexer
    mux4_1_32bit wb (
	    .a (alu_data),
	    .b (ld_data),
	    .c (pc_four),
        .d (immediate),
        .s (wb_sel),
        .y (wb_data)
    );

endmodule
