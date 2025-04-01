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

	
	full_adder fa0  (.a(a[0]),  .b(b_inv[0]),  .cin(carry[0]),  .sum(s[0]),  .cout(carry[1]));
    full_adder fa1  (.a(a[1]),  .b(b_inv[1]),  .cin(carry[1]),  .sum(s[1]),  .cout(carry[2]));
    full_adder fa2  (.a(a[2]),  .b(b_inv[2]),  .cin(carry[2]),  .sum(s[2]),  .cout(carry[3]));
    full_adder fa3  (.a(a[3]),  .b(b_inv[3]),  .cin(carry[3]),  .sum(s[3]),  .cout(carry[4]));
    full_adder fa4  (.a(a[4]),  .b(b_inv[4]),  .cin(carry[4]),  .sum(s[4]),  .cout(carry[5]));
    full_adder fa5  (.a(a[5]),  .b(b_inv[5]),  .cin(carry[5]),  .sum(s[5]),  .cout(carry[6]));
    full_adder fa6  (.a(a[6]),  .b(b_inv[6]),  .cin(carry[6]),  .sum(s[6]),  .cout(carry[7]));
    full_adder fa7  (.a(a[7]),  .b(b_inv[7]),  .cin(carry[7]),  .sum(s[7]),  .cout(carry[8]));
    full_adder fa8  (.a(a[8]),  .b(b_inv[8]),  .cin(carry[8]),  .sum(s[8]),  .cout(carry[9]));
    full_adder fa9  (.a(a[9]),  .b(b_inv[9]),  .cin(carry[9]),  .sum(s[9]),  .cout(carry[10]));
    full_adder fa10 (.a(a[10]), .b(b_inv[10]), .cin(carry[10]), .sum(s[10]), .cout(carry[11]));
    full_adder fa11 (.a(a[11]), .b(b_inv[11]), .cin(carry[11]), .sum(s[11]), .cout(carry[12]));
    full_adder fa12 (.a(a[12]), .b(b_inv[12]), .cin(carry[12]), .sum(s[12]), .cout(carry[13]));
    full_adder fa13 (.a(a[13]), .b(b_inv[13]), .cin(carry[13]), .sum(s[13]), .cout(carry[14]));
    full_adder fa14 (.a(a[14]), .b(b_inv[14]), .cin(carry[14]), .sum(s[14]), .cout(carry[15]));
    full_adder fa15 (.a(a[15]), .b(b_inv[15]), .cin(carry[15]), .sum(s[15]), .cout(carry[16]));
    full_adder fa16 (.a(a[16]), .b(b_inv[16]), .cin(carry[16]), .sum(s[16]), .cout(carry[17]));
    full_adder fa17 (.a(a[17]), .b(b_inv[17]), .cin(carry[17]), .sum(s[17]), .cout(carry[18]));
    full_adder fa18 (.a(a[18]), .b(b_inv[18]), .cin(carry[18]), .sum(s[18]), .cout(carry[19]));
    full_adder fa19 (.a(a[19]), .b(b_inv[19]), .cin(carry[19]), .sum(s[19]), .cout(carry[20]));
    full_adder fa20 (.a(a[20]), .b(b_inv[20]), .cin(carry[20]), .sum(s[20]), .cout(carry[21]));
    full_adder fa21 (.a(a[21]), .b(b_inv[21]), .cin(carry[21]), .sum(s[21]), .cout(carry[22]));
    full_adder fa22 (.a(a[22]), .b(b_inv[22]), .cin(carry[22]), .sum(s[22]), .cout(carry[23]));
    full_adder fa23 (.a(a[23]), .b(b_inv[23]), .cin(carry[23]), .sum(s[23]), .cout(carry[24]));
    full_adder fa24 (.a(a[24]), .b(b_inv[24]), .cin(carry[24]), .sum(s[24]), .cout(carry[25]));
    full_adder fa25 (.a(a[25]), .b(b_inv[25]), .cin(carry[25]), .sum(s[25]), .cout(carry[26]));
    full_adder fa26 (.a(a[26]), .b(b_inv[26]), .cin(carry[26]), .sum(s[26]), .cout(carry[27]));
    full_adder fa27 (.a(a[27]), .b(b_inv[27]), .cin(carry[27]), .sum(s[27]), .cout(carry[28]));
    full_adder fa28 (.a(a[28]), .b(b_inv[28]), .cin(carry[28]), .sum(s[28]), .cout(carry[29]));
    full_adder fa29 (.a(a[29]), .b(b_inv[29]), .cin(carry[29]), .sum(s[29]), .cout(carry[30]));
    full_adder fa30 (.a(a[30]), .b(b_inv[30]), .cin(carry[30]), .sum(s[30]), .cout(carry[31]));
    full_adder fa31 (.a(a[31]), .b(b_inv[31]), .cin(carry[31]), .sum(s[31]), .cout(carry[32]));

    assign cout = carry[32];
endmodule
