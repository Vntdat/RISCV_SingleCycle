module imem (
	input logic [31:0] imem_addr,
	output logic [31:0] imem_data
	);
	
	logic [31:0] imem [0:63];
	initial begin
		$readmemh ("D:/HCMUT/HK242/CTMT/test/isa.mem", imem);
	end
		
	always_comb begin	
		imem_data = imem[imem_addr[7:2]];
	end
endmodule
