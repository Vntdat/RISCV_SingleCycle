module brc_comparator_signed(
	input logic [31:0] a,
	input logic [31:0] b,
	output logic A_eq_B,
	output logic A_lt_B 
);

	logic [31:0] sub_result;
	logic c_out;
	logic a_sign, b_sign;

	// Lấy bit dấu của hai số
	assign a_sign = a[31];
	assign b_sign = b[31];

	// Phép trừ a - b
	sub_32 sub (
		.a(a),
		.b(b),
		.s(sub_result),
		.c_out(c_out)
	);
	
	// Kiểm tra các điều kiện
	assign A_eq_B = (sub_result == 0);
	assign A_lt_B = (a_sign & ~b_sign) |  // Nếu a âm và b dương thì a < b
                    (~(a_sign ^ b_sign) & ~c_out);  // Nếu cùng dấu và c_out = 0 thì a < b

endmodule