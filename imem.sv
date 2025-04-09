module imem (
	input logic [31:0] imem_addr,
	output logic [31:0] imem_data
	);
	
	logic [31:0] imem [0:8191];
	initial begin
		$readmemh ("/home/cpa/ca111/sc-test/02_test/isa.mem", imem);
	end
		
	always_comb begin	
		imem_data = imem[imem_addr[14:2]];
	end
endmodule
