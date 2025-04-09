module lsu (
    input  logic        i_clk,         // Xung clock
    input  logic        i_reset,       // Tín hiệu reset (active low)
    input  logic [31:0] i_lsu_addr,    // Địa chỉ bộ nhớ
    input  logic [31:0] i_st_data,     // Dữ liệu cần ghi
    input  logic        i_lsu_wren,    // Tín hiệu cho phép ghi
    output logic [31:0] o_ld_data,     // Dữ liệu đọc từ bộ nhớ
    output logic [31:0] o_io_ledr,     // LED đỏ
    output logic [31:0] o_io_ledg,     // LED xanh lá
    output logic [6:0]  o_io_hex0,     // HEX0
    output logic [6:0]  o_io_hex1,     // HEX1
    output logic [6:0]  o_io_hex2,     // HEX2
    output logic [6:0]  o_io_hex3,     // HEX3
    output logic [6:0]  o_io_hex4,     // HEX4
    output logic [6:0]  o_io_hex5,     // HEX5
    output logic [6:0]  o_io_hex6,     // HEX6
    output logic [6:0]  o_io_hex7,     // HEX7
    output logic [31:0] o_io_lcd,      // LCD
    input  logic [31:0] i_io_sw        // Dữ liệu từ công tắc
);

    logic data;
    logic io;
    logic sw;    

    // Bộ nhớ dữ liệu (8 Ki words = 32 KiB)
    logic [31:0] data_memory [0:8191]; 
    logic [31:0] io_memory [0:15];
    logic [31:0] sw_memory [0:3];

    // Khởi tạo bộ nhớ trong khối reset
    initial begin
        io_memory = '{default: 32'h0};
        sw_memory = '{default: 32'h0};
    end

    assign data = (i_lsu_addr < 32'h0000_8000);  // Địa chỉ từ 0x0000_0000 đến 0x0000_7FFF
    assign io   = (i_lsu_addr >= 32'h1000_0000 && i_lsu_addr <= 32'h1000_4FFF);
    assign sw   = (i_lsu_addr >= 32'h1001_0000 && i_lsu_addr <= 32'h1001_0FFF);

    logic [2:0] lsu_op;
    assign lsu_op = i_lsu_addr[18:16]; 

    always_comb begin
        logic [31:0] mem_data;
        mem_data = 32'h0;
        o_ld_data = 32'h0;

        if (!i_lsu_wren) begin
            if (data) begin
                mem_data = data_memory[i_lsu_addr[14:2]];
            end 
            else if (io) begin
                mem_data = io_memory[i_lsu_addr[5:2]];
            end 
            else if (sw) begin
                mem_data = sw_memory[i_lsu_addr[3:2]];
            end 
            else begin
                mem_data = 32'h0;
            end

            o_ld_data = mem_data;
        end 
    end

    always_ff @(posedge i_clk or negedge i_reset) begin
        if (!i_reset) begin
            io_memory <= '{default:32'h0};
            sw_memory <= '{default:32'h0};
        end
        else if (i_lsu_wren) begin
            case (lsu_op)
                3'b000: begin // SB
                    if (data) begin
                        data_memory[i_lsu_addr[14:2]][7:0] <= i_st_data[7:0];
                    end
                    else if (io) begin
                        io_memory[i_lsu_addr[5:2]][7:0] <= i_st_data[7:0];
                    end
                    else if (sw) begin
                        sw_memory[i_lsu_addr[3:2]][7:0] <= i_io_sw[7:0];
                    end
                end
                3'b001: begin // SH
                    if (data) begin
                        data_memory[i_lsu_addr[14:2]][15:0] <= i_st_data[15:0];
                    end
                    else if (io) begin
                        io_memory[i_lsu_addr[5:2]][15:0] <= i_st_data[15:0];
                    end
                    else if (sw) begin
                        sw_memory[i_lsu_addr[3:2]][15:0] <= i_io_sw[15:0];
                    end
                end
                3'b010: begin // SW
                    if (data) begin
                        data_memory[i_lsu_addr[14:2]] <= i_st_data;
                    end
                    else if (io) begin
                        io_memory[i_lsu_addr[5:2]] <= i_st_data;
                    end
                    else if (sw) begin
                        sw_memory[i_lsu_addr[3:2]] <= i_io_sw;
                    end
                end
                default: begin end
            endcase
        end
    end

    // Kết nối bộ nhớ ngoại vi với các thiết bị
    assign o_io_ledr = io_memory[0];
    assign o_io_ledg = io_memory[1];
    assign o_io_hex0 = io_memory[2][6:0];
    assign o_io_hex1 = io_memory[3][6:0];
    assign o_io_hex2 = io_memory[4][6:0];
    assign o_io_hex3 = io_memory[5][6:0];
    assign o_io_hex4 = io_memory[6][6:0];
    assign o_io_hex5 = io_memory[7][6:0];
    assign o_io_hex6 = io_memory[8][6:0];
    assign o_io_hex7 = io_memory[9][6:0];
    assign o_io_lcd  = io_memory[10];

endmodule
