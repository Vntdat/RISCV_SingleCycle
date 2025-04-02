module singlecycle (
	//inputs
	input logic i_clk,
	input logic i_reset,
	input logic [31:0] i_io_sw,
	//outputs
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
	//----signals for debugging---//
	output logic [31:0] o_pc_debug,
	output logic o_insn_vld
	);
	 
//------Wire--------//
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
	
	logic [31:0] pc_four;
	logic [31:0] pc_next;
	logic [31:0] pc;
	logic [31:0] instr;
	logic [31:0] rs1_data;
	logic [31:0] rs2_data;
	logic [31:0] immediate;
	logic [31:0] operand_a;
	logic [31:0] operand_b;
	logic [31:0] alu_data;
	logic [31:0] ld_data;
	logic [31:0] wb_data;
	
	logic [31:0] mem_rdata;
	logic [3:0] mem_bmask = 4'b1111;  // Mặc định truy cập cả 4 byte (word)
	
	assign o_pc_debug = pc;
   
	regfile regfile (
		.i_clk 			(i_clk),
		.i_reset 		(i_reset),
		.i_rs1_addr 	(instr[19:15]),  // Địa chỉ thanh ghi nguồn 1
		.i_rs2_addr 	(instr[24:20]),  // Địa chỉ thanh ghi nguồn 2  
		.i_rd_addr 		(instr[11:7]),   // Địa chỉ thanh ghi đích
		.i_rd_data 		(wb_data),   // Dữ liệu ghi vào thanh ghi đích
		.i_rd_wren 		(rd_wren),   // Cho phép ghi
		.o_rs1_data 	(rs1_data),  // Dữ liệu từ thanh ghi nguồn 1
		.o_rs2_data 	(rs2_data)  // Dữ liệu từ thanh ghi nguồn 2
	);
	
	immgen immgen (
		.i_inst (instr),
		.o_imm (immediate)
	);
	
	brc brc (
		.i_rs1_data		(rs1_data), // Dữ liệu từ thanh ghi 1
		.i_rs2_data 	(rs2_data), // Dữ liệu từ thanh ghi 2
		.i_br_un 		(br_un),    // Chế độ so sánh (1: signed, 0: unsigned)
		.o_br_less 		(br_less),      // Kết quả rs1 < rs2
		.o_br_equal 	(br_equal)      // Kết quả rs1 == rs2
	);
	
	alu alu (
		.i_op_a 		(operand_a),
		.i_op_b 		(operand_b),
		.i_alu_op 	(alu_op),
		.o_alu_data (alu_data)
	);
	
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
		.y	(operand_b)
	);
	
	LSU lsu (
		.i_clk 			(i_clk),         // Xung clock
		.i_reset 		(i_reset),       // Tín hiệu reset (active low)
		.i_lsu_addr		(alu_data),    						// Địa chỉ bộ nhớ
		.i_st_data		(rs2_data),     						// Dữ liệu cần ghi
		.i_lsu_wren    (mem_wren),			// Tín hiệu cho phép ghi (1: ghi, 0: đọc)
		.o_ld_data		(ld_data),     // Dữ liệu đọc từ bộ nhớ
		.o_io_ledr (o_io_ledr),    // Điều khiển đèn LED đỏ
		.o_io_ledg (o_io_ledg),    // Điều khiển đèn LED xanh lá
		.o_io_hex0 (o_io_hex0),
		.o_io_hex1 (o_io_hex1),
		.o_io_hex2 (o_io_hex2),
		.o_io_hex3 (o_io_hex3),
		.o_io_hex4 (o_io_hex4),
		.o_io_hex5 (o_io_hex5),
		.o_io_hex6 (o_io_hex6),
		.o_io_hex7 (o_io_hex7),
		.o_io_lcd  (o_io_lcd),
		.i_io_sw   (i_io_sw)
	);

	controlunit controlunit (
		.i_instr 	(instr),
		.br_less 	(br_less),
		.br_equal	(br_equal),
		.pc_sel 		(pc_sel),
		.rd_wren		(rd_wren),
		.br_un 		(br_un),
		.opa_sel 	(opa_sel),
		.opb_sel 	(opb_sel),
		.mem_wren 	(mem_wren),
		.insn_vld 	(insn_vld),
		.alu_op 		(alu_op),
		.wb_sel 		(wb_sel)
	);
	
	memory memory (
		.i_clk    (i_clk),
		.i_reset  (i_reset),
		.i_addr   (pc),       // Địa chỉ đọc lệnh
		.i_wdata  (rs2_data), // Dữ liệu cần ghi
		.i_bmask  (mem_bmask),
		.i_wren   (mem_wren), // Ghi khi cần
		.o_rdata  (mem_rdata) // Lệnh đọc ra từ bộ nhớ
);
	pc_reg pc_reg (
		.i_clk (i_clk),
		.i_reset (i_reset),
		.i_pc_next (pc_next),
		.o_pc (pc)
	);
	
	mux2_1_32bit pc_mux (
		.a (pc_four),    // Giá trị PC + 4 (mặc định)
		.b (alu_data),   // Giá trị từ ALU (nhảy hoặc branch)
		.s (pc_sel),     // Tín hiệu chọn (1: chọn ALU, 0: chọn PC + 4)
		.y (pc_next)     // Kết quả đầu ra
);

	fulladder_32 pc_adder (
		.a 	(pc),
		.b 	(32'd4),
		.sum 	(pc_four)
	);

	
endmodule
