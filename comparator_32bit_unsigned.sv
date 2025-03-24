module comparator_32bit_unsigned (
    input  logic [31:0] A,       // Số thứ nhất (32-bit)
    input  logic [31:0] B,       // Số thứ hai (32-bit)
    output logic A_gt_B,         // A > B
    output logic A_eq_B,         // A = B
    output logic A_lt_B          // A < B
	);
 endmodule