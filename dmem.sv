module dmem (
	input  logic        i_clk,         // Xung clock
	input  logic        i_reset,       // Tín hiệu reset (active low)
	input  logic [31:0] i_lsu_addr,    // Địa chỉ bộ nhớ
	input  logic [31:0] i_st_data,     // Dữ liệu cần ghi
	input  logic        i_lsu_wren,    // Tín hiệu cho phép ghi
	output logic [31:0] o_ld_data
);
	
	logic [31:0] data_memory [0:511]; 
	integer i;
	
	initial begin
	$readmemh("D:/HCMUT/HK242/CTMT/10-4/isa.mem", data_memory);
	end
	
	always_ff@(posedge i_clk) begin
		if (i_reset) begin
			for (i = 0; i < 63; i = i + 1) begin
				 data_memory[i] <= 32'b0;
			end

		end else begin
			if (i_lsu_wren) begin
				data_memory[i_lsu_addr[9:2]] = i_st_data;
			end else begin
				o_ld_data = data_memory[i_lsu_addr[9:2]];
			end
		end
	end
	
endmodule
