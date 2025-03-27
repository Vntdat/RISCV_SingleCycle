module comparator_2bit (
	input logic [1:0] a,
	input logic [1:0] b,
	output logic b_larger
	);
	

	assign b_larger = ~a[1]&b[1] | ~a[0]&b[1]&b[0] | ~a[1]&~a[0]&b[0];
endmodule