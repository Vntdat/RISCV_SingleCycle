module comparator_2bit (
	input logic [1:0] a,
	input logic [1:0] b,
	output logic a_larger,
	output logic equal,
	output logic b_larger
	);
	
	assign a_larger = a[1]&~b[1] | a[0]&~b[1]&~b[0] | a[1]&a[0]&~b[0];
	assign equal = ~(a[0]^b[0]) & ~(a[1]^b[1]);
	assign b_larger = ~a[1]&b[1] | ~a[0]&b[1]&b[0] | ~a[1]&~a[0]&b[0];
endmodule