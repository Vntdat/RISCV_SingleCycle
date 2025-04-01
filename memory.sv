module memory (
    input  logic        i_clk,
    input  logic        i_reset,
    input  logic [31:0] i_addr,    // Địa chỉ đọc/ghi
    input  logic [31:0] i_wdata,   // Dữ liệu ghi
    input  logic [3:0]  i_bmask,   // Byte Mask
    input  logic        i_wren,    // Enable ghi
    output logic [31:0] o_rdata    // Dữ liệu đọc
);
		parameter MEM_SIZE = 1024;
	logic [31:0] mem [MEM_SIZE-1:0];

    // Đọc file dữ liệu/mã lệnh
    initial begin
		$readmemh("D:/HCMUT/HK242/CTMT/RISCV_SingleCycle/memory_init.mem.txt", mem);
    end

    // Đọc không đồng bộ
    assign o_rdata = mem[i_addr[11:2]];  // Căn chỉnh theo từ (word-aligned)

    // Ghi đồng bộ với byte mask
    always_ff @(posedge i_clk or posedge i_reset) begin
        if (i_reset) begin
            for (int i = 0; i < 1024; i = i + 1)
                mem[i] <= 32'b0;
        end else if (i_wren) begin
            if (i_bmask[0]) mem[i_addr[11:2]][7:0]   <= i_wdata[7:0];
            if (i_bmask[1]) mem[i_addr[11:2]][15:8]  <= i_wdata[15:8];
            if (i_bmask[2]) mem[i_addr[11:2]][23:16] <= i_wdata[23:16];
            if (i_bmask[3]) mem[i_addr[11:2]][31:24] <= i_wdata[31:24];
        end
    end

endmodule
