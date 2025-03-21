module fulladder (
	input logic a,
	input logic b,
	input logic c_in,
	output logic sum,
	output logic c_out
	);
	assign sum = a^b^c_in;
	assign c_out = (a&b) | c_in&(a^b); 
endmodule