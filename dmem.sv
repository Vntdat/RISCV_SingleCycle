module dmem (
    input  logic        i_clk,
    input  logic        i_reset,
    input  logic [31:0] i_addr,
    input  logic [31:0] i_wdata,
    input  logic [3:0]  i_bmask,
    input  logic        i_wren,
    output logic [31:0] o_rdata
);

    logic [31:0] data_memory [0:511];  // 8KB memory
    logic [3:0]  lsu_op;
    logic        addr_valid;

    assign lsu_op = i_bmask;
    assign addr_valid = (i_addr[31:11] == 0);  // Kiểm tra địa chỉ 0x0000-0x7FFF

    // Khởi tạo bộ nhớ (chỉ cho simulation)
    initial begin
        $readmemh("E:/BKHCM/HK 242/CTMT/singlecycle/isa.mem", data_memory);
    end

    // Xử lý đọc
    always_comb begin 
        o_rdata = 32'h0;
        if (!i_wren && addr_valid) begin
            case (lsu_op)
                4'b0000: o_rdata = {{24{data_memory[i_addr[10:2]][7]}}, data_memory[i_addr[10:2]][7:0]};  // LB
                4'b0001: o_rdata = {24'h0, data_memory[i_addr[10:2]][7:0]};                             // LBU
                4'b0010: o_rdata = {{16{data_memory[i_addr[10:2]][15]}}, data_memory[i_addr[10:2]][15:0]}; // LH
                4'b0011: o_rdata = {16'h0, data_memory[i_addr[10:2]][15:0]};                              // LHU
                4'b0100: o_rdata = data_memory[i_addr[10:2]];                                             // LW
                default: o_rdata = 32'h0;
            endcase
        end
    end

    // Xử lý ghi và reset (đồng bộ)
    always_ff @(posedge i_clk) begin
        if (!i_reset) begin
            data_memory <= '{default: 0};
        end
        else if (i_wren && addr_valid) begin
            // Ghi dữ liệu khi có yêu cầu
            case (lsu_op)
                4'b1000: data_memory[i_addr[10:2]][7:0] <= i_wdata[7:0];   // SB
                4'b1001: data_memory[i_addr[10:2]][15:0] <= i_wdata[15:0]; // SH
                4'b1010: data_memory[i_addr[10:2]] <= i_wdata;             // SW
                default: ; // No operation
            endcase
        end
    end
endmodule