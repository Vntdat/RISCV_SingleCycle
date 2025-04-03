module alu (
	input logic [31:0] i_op_a,
	input logic [31:0] i_op_b,
	input logic [3:0] i_alu_op,
	output logic [31:0] o_alu_data
	);

	logic cout;
	logic [31:0] o_add;
	logic [31:0] o_sub;
	logic [31:0] o_slt;
	logic [31:0] o_sltu;
	logic [31:0] o_xor;
	logic [31:0] o_or;
	logic [31:0] o_and;
	logic [31:0] o_sll;
	logic [31:0] o_srl;
	logic [31:0] o_sra;
	logic [31:0] mux_inputs [15:0];

	assign mux_inputs[0]  = o_add;
	assign mux_inputs[1]  = o_sub;
	assign mux_inputs[2]  = o_slt;
	assign mux_inputs[3]  = o_sltu;
	assign mux_inputs[4]  = o_xor;
	assign mux_inputs[5]  = o_or;
	assign mux_inputs[6]  = o_and;
	assign mux_inputs[7]  = o_sll;
	assign mux_inputs[8]  = o_srl;
	assign mux_inputs[9]  = o_sra;
	assign mux_inputs[10] = 32'b0;  // Giá trị mặc định cho các trường hợp chưa sử dụng
	assign mux_inputs[11] = 32'b0;
	assign mux_inputs[12] = 32'b0;
	assign mux_inputs[13] = 32'b0;
	assign mux_inputs[14] = 32'b0;
	assign mux_inputs[15] = 32'b0;
	fulladder_32 ADD (.a (i_op_a),
							.b (i_op_b),
							.sum (o_add));
							
	sub_32 SUB (.a (i_op_a),
					.b (i_op_b),
					.s (o_sub),
					.cout (cout)); //note
						
	comparator_32bit SLT (.a (i_op_a),
								 .b (i_op_b),
								 .A_lt_B (o_slt));
								 
	comparator_32bit_unsigned SLTU (.a (i_op_a),
											  .b (i_op_b),
											  .a_lt_b (o_sltu));
											  
	xor_32 XOR (.a (i_op_a),
					.b (i_op_b),
					.c (o_xor));
					
	or_32 OR (.a (i_op_a),
				 .b (i_op_b),
				 .c (o_or));
	
	and_32 AND (.a (i_op_a),
					.b (i_op_b),
					.c (o_and));
					
	sll_32 SLL (.a (i_op_a),
					.b (i_op_b),
					.c (o_sll));
					
	srl_32 SRL (.a (i_op_a),
					.b (i_op_b),
					.c (o_srl));
					
	sra_32 SRA (.a (i_op_a),
					.b (i_op_b),
					.c (o_sra));

	mux16_1 MUX (.in(mux_inputs),
						.sel(i_alu_op),
						.out(o_alu_data));
						
endmodule: alu

module full_adder (
	input logic a,
	input logic b,
	input logic cin,
	output logic sum,
	output logic cout
	);
	
	assign sum = a^b^cin;
	assign cout = (a&b) | cin&(a^b); 
	
endmodule: full_adder

module fulladder_32(
	input logic [31:0] a,
	input logic [31:0] b,
	output logic [31:0] sum
	);
	
	logic [32:0] carry; 
	assign carry[0]=0;
	
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: adder_loop
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

endmodule: fulladder_32

module sub_32 (
	input logic [31:0] a,
	input logic [31:0] b,
	output logic [31:0] s,
	output logic cout
	);
	
	logic [31:0] b_inv;
	logic [32:0] carry;
	
    assign b_inv = ~b;  // Lấy bù một của b
    assign carry[0] = 1; // Cộng thêm 1 vào b_inv để lấy bù hai

	
	genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: adder_loop
            full_adder fa (
                .a(a[i]),
                .b(b_inv[i]),
                .cin(carry[i]),
                .sum(s[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[32];
endmodule: sub_32

module comparator_32bit (
    input logic [31:0] a,
    input logic [31:0] b,
    output logic A_lt_B  // a < b
);

    logic [31:0] sub_result;
    logic cout;
    logic a_sign, b_sign;

    // Lấy bit dấu của hai số
    assign a_sign = a[31];
    assign b_sign = b[31];

    // Phép trừ a - b
    sub_32 sub (
        .a(a),
        .b(b),
        .s(sub_result),
        .cout(cout)
    );

    // Kiểm tra các điều kiện
    assign A_lt_B = (a_sign & ~b_sign) |  // Nếu a âm và b dương thì a < b
                    (~(a_sign ^ b_sign) & ~cout);  // Nếu cùng dấu và c_out = 0 thì a < b

endmodule: comparator_32bit

module comparator_32bit_unsigned(
    input logic [31:0] a, b,   
    output logic a_lt_b       
);
    logic [31:0] sub_result;
    logic borrow;

    sub_32 subtractor (
        .a(a),
        .b(b),
        .s(sub_result),
        .cout(borrow) 
    );

    assign a_lt_b = ~borrow; 
endmodule: comparator_32bit_unsigned

module xor_32 (
	input logic [31:0] a,
	input logic [31:0] b,
	output logic [31:0] c
	);

	assign c = a^b;
endmodule: xor_32

module or_32 (
	input logic [31:0] a,
	input logic [31:0] b,
	output logic [31:0] c
	);
	
assign c = a|b;
endmodule: or_32

module and_32 (
	input logic [31:0] a,
	input logic [31:0] b,
	output logic [31:0] c
	);
	
	assign c = a&b;
endmodule: and_32

module sll_32 (
    input  logic [31:0] a,    // Giá trị đầu vào cần dịch
    input  logic [31:0] b,    // Số bit dịch (5-bit)
    output logic [31:0] c     // Kết quả sau khi dịch
);
    logic [31:0] stage1, stage2, stage3, stage4, stage5;
    logic [4:0] shift;
    
    assign shift = b[4:0];

    // Tầng dịch 16-bit
    assign stage1 = shift[4] ? {a[15:0], 16'b0} : a;

    // Tầng dịch 8-bit
    assign stage2 = shift[3] ? {stage1[23:0], 8'b0} : stage1;

    // Tầng dịch 4-bit
    assign stage3 = shift[2] ? {stage2[27:0], 4'b0} : stage2;

    // Tầng dịch 2-bit
    assign stage4 = shift[1] ? {stage3[29:0], 2'b0} : stage3;

    // Tầng dịch 1-bit
    assign stage5 = shift[0] ? {stage4[30:0], 1'b0} : stage4;

    // Kết quả cuối cùng
    assign c = stage5;

endmodule:sll_32

module srl_32 (
    input  logic [31:0] a,    // Giá trị đầu vào cần dịch
    input  logic [31:0] b,    // Số bit dịch (5-bit)
    output logic [31:0] c     // Kết quả sau khi dịch
);
    logic [31:0] stage1, stage2, stage3, stage4, stage5;
    logic [4:0] shift;
    
    assign shift = b[4:0];

    // Tầng dịch 16-bit
    assign stage1 = shift[4] ? {16'b0, a[31:16]} : a;

    // Tầng dịch 8-bit
    assign stage2 = shift[3] ? {8'b0, stage1[31:8]} : stage1;

    // Tầng dịch 4-bit
    assign stage3 = shift[2] ? {4'b0, stage2[31:4]} : stage2;

    // Tầng dịch 2-bit
    assign stage4 = shift[1] ? {2'b0, stage3[31:2]} : stage3;

    // Tầng dịch 1-bit
    assign stage5 = shift[0] ? {1'b0, stage4[31:1]} : stage4;

    // Kết quả cuối cùng
    assign c = stage5;

endmodule: srl_32

module sra_32 (
    input  logic [31:0] a,    // Giá trị đầu vào cần dịch
    input  logic [31:0] b,    // Số bit dịch (5-bit)
    output logic [31:0] c     // Kết quả sau khi dịch
);
    logic [31:0] stage1, stage2, stage3, stage4, stage5;
    logic [4:0] shift;
    logic sign_extend; // Bit mở rộng dựa trên bit dấu

    assign shift = b[4:0];
    assign sign_extend = a[31]; // Lấy bit dấu của a

    // Tầng dịch 16-bit
    assign stage1 = shift[4] ? {{16{sign_extend}}, a[31:16]} : a;

    // Tầng dịch 8-bit
    assign stage2 = shift[3] ? {{8{sign_extend}}, stage1[31:8]} : stage1;

    // Tầng dịch 4-bit
    assign stage3 = shift[2] ? {{4{sign_extend}}, stage2[31:4]} : stage2;

    // Tầng dịch 2-bit
    assign stage4 = shift[1] ? {{2{sign_extend}}, stage3[31:2]} : stage3;

    // Tầng dịch 1-bit
    assign stage5 = shift[0] ? {{1{sign_extend}}, stage4[31:1]} : stage4;

    // Kết quả cuối cùng
    assign c = stage5;

endmodule: sra_32