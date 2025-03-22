module LSU (
    input  logic        i_clk,         // Xung clock
    input  logic        i_reset,       // Tín hiệu reset (active low)
    input  logic [31:0] i_lsu_addr,    // Địa chỉ bộ nhớ
    input  logic [31:0] i_st_data,     // Dữ liệu cần ghi
    input  logic        i_lsu_wren,    // Tín hiệu cho phép ghi (1: ghi, 0: đọc)
    output logic [31:0] o_ld_data,     // Dữ liệu đọc từ bộ nhớ
    output logic [31:0] o_io_ledr,     // Điều khiển đèn LED đỏ
    output logic [31:0] o_io_ledg,     // Điều khiển đèn LED xanh lá
    output logic [6:0]  o_io_hex0,     // Điều khiển màn hình 7 đoạn HEX0
    output logic [6:0]  o_io_hex1,     // Điều khiển màn hình 7 đoạn HEX1
    output logic [6:0]  o_io_hex2,     // Điều khiển màn hình 7 đoạn HEX2
    output logic [6:0]  o_io_hex3,     // Điều khiển màn hình 7 đoạn HEX3
    output logic [6:0]  o_io_hex4,     // Điều khiển màn hình 7 đoạn HEX4
    output logic [6:0]  o_io_hex5,     // Điều khiển màn hình 7 đoạn HEX5
    output logic [6:0]  o_io_hex6,     // Điều khiển màn hình 7 đoạn HEX6
    output logic [6:0]  o_io_hex7,     // Điều khiển màn hình 7 đoạn HEX7
    output logic [31:0] o_io_lcd,      // Điều khiển thanh ghi LCD
    input  logic [31:0] i_io_sw        // Dữ liệu từ công tắc
);

    // Bộ nhớ dữ liệu (2 KiB)
    logic [31:0] data_memory [0:511];  // 512 ô nhớ, mỗi ô 32-bit

    // Bộ nhớ ngoại vi (LED, LCD, v.v.)
    logic [31:0] io_memory [0:15];     // 16 ô nhớ, mỗi ô 32-bit

    // Bộ nhớ công tắc (Switches)
    logic [31:0] sw_memory [0:3];      // 4 ô nhớ, mỗi ô 32-bit

    // Khởi tạo toàn bộ bộ nhớ về 0
    initial begin
        data_memory = '{default: 32'h0};  // Khởi tạo bộ nhớ dữ liệu về 0
		 // $readmemh("02_test/dump/mem.dump", data_memory);  // Khởi tạo bộ nhớ từ file mem.dump
        io_memory = '{default: 32'h0};    // Khởi tạo bộ nhớ ngoại vi về 0
        sw_memory = '{default: 32'h0};    // Khởi tạo bộ nhớ công tắc về 0
    end

    // Kiểm tra địa chỉ hợp lệ
    logic data;  // Truy cập bộ nhớ dữ liệu
    logic io;    // Truy cập bộ nhớ ngoại vi
    logic sw;    // Truy cập bộ nhớ công tắc

    assign data = (i_lsu_addr >= 32'h0000_0000 && i_lsu_addr <= 32'h0000_1FFF); // kiểm tra xem địa chỉ có nằm trong vùng data_memory không
    assign io   = (i_lsu_addr >= 32'h1000_0000 && i_lsu_addr <= 32'h1000_4FFF); // kiểm tra xem địa chỉ có nằm trong vùng io_memory không
    assign sw   = (i_lsu_addr >= 32'h1001_0000 && i_lsu_addr <= 32'h1001_0FFF); // kiểm tra xem địa chỉ có nằm trong vùng sw_memory không

    // Xác định loại lệnh từ địa chỉ (sử dụng bit 10 11 12 của địa chỉ)
    logic [2:0] lsu_op;
    assign lsu_op = i_lsu_addr[12:10];  // bit 10 11 12 của địa chỉ, có thể sử dụng bit 0 bit 1 nhưng nếu như vậy không thể bao quát hết 5 lệnh load được

    // Xử lý đọc dữ liệu
    always_comb begin
        logic [31:0] mem_data;
        if (!i_lsu_wren) begin // đọc dữ liệu khi i_lsu_wren = 0
            if (data) begin
                mem_data = data_memory[i_lsu_addr[9:2]];  // Đọc từ data_memory theo địa chỉ i_lsu_addr từ bit thứ 2 đến bit thứ 9 do vùng data chỉ có 512 ô nhớ
            end 
            else 
				if (io) begin
                mem_data = io_memory[i_lsu_addr[5:2]];    // Đọc từ io_memory theo địa chỉ i_lsu_addr từ bit 2 đến bit 5 do io triển khai 16 ô nhớ
            end 
            else 
				if (sw) begin
                mem_data = sw_memory[i_lsu_addr[3:2]];   // Đọc từ bộ nhớ sw_memory từ địac chỉ i_lsu_addr từ bit 2 đến bit 3 do sw triển khai 4 ô nhớ thôi
            end 
            else begin
                mem_data = 32'h0;                       // Địa chỉ không hợp lệ
            end

            // Xử lý lệnh load
            case (lsu_op)
                3'b000: o_ld_data = {{24{mem_data[7]}}, mem_data[7:0]};   // LB (load byte có dấu): Ngõ ra bằng mem_data trong đó bit số 7 của mem_data được mở rộng
                3'b100: o_ld_data = {24'h0, mem_data[7:0]};               // LBU (load byte không dấu): Ngõ ra bằng mem_data trong đó từ bit thứ 8 đến bit 31 bằng 0
                3'b001: o_ld_data = {{16{mem_data[15]}}, mem_data[15:0]}; // LH (load half-word có dấu): tương tự LB
                3'b101: o_ld_data = {16'h0, mem_data[15:0]};              // LHU (load half-word không dấu): tương tự LBH
					 3'b010: o_ld_data = mem_data;										// LW ghi cả word : ngõ ra bằng mem_data (lúc này mem_data có 32 bit)
                default: o_ld_data = 32'h0;                              // Mặc định
            endcase
        end 
		  else begin
            o_ld_data = 32'h0; // Không đọc khi đang ghi
        end
    end

    // Xử lý ghi dữ liệu
    always_ff @(posedge i_clk or negedge i_reset) begin
        if (!i_reset) begin
            // Reset toàn bộ bộ nhớ về 0
            data_memory <= '{default: 32'h0};  // Reset bộ nhớ dữ liệu
				// $readmemh("02_test/dump/mem.dump", data_memory); // Khởi tạo bộ nhớ từ file mem.dump
            io_memory <= '{default: 32'h0};    // Reset bộ nhớ ngoại vi
            sw_memory <= '{default: 32'h0};    // Reset bộ nhớ công tắc
        end else if (i_lsu_wren) begin 
            case (lsu_op)
                3'b000: begin // SB (store byte)
                    if (data) begin
                        data_memory[i_lsu_addr[9:2]][7:0] <= i_st_data[7:0]; 
                    end 
						  else if (io) begin
                        io_memory[i_lsu_addr[5:2]][7:0] <= i_st_data[7:0];
                    end 
						  else if (sw) begin
                        sw_memory[i_lsu_addr[3:2]][7:0] <= i_io_sw[7:0];
                    end
                end
                3'b001: begin // SH (store half-word)
                    if (data) begin
                        data_memory[i_lsu_addr[9:2]][15:0] <= i_st_data[15:0];
                    end 
						  else if (io) begin
                        io_memory[i_lsu_addr[5:2]][15:0] <= i_st_data[15:0];
                    end 
						  else if (sw) begin
                        sw_memory[i_lsu_addr[3:2]][15:0] <= i_io_sw[15:0];
                    end
                end
                3'b010: begin // SW (store word)
                    if (data) begin
                        data_memory[i_lsu_addr[9:2]] <= i_st_data;
                    end 
						  else if (io) begin
                        io_memory[i_lsu_addr[5:2]] <= i_st_data;
                    end 
						  else if (sw) begin
                        sw_memory[i_lsu_addr[3:2]] <= i_io_sw;
                    end
                end
            endcase
        end
    end

    // Kết nối bộ nhớ ngoại vi với các thiết bị
    assign o_io_ledr = io_memory[0];  // LED đỏ
    assign o_io_ledg = io_memory[1];  // LED xanh lá
    assign o_io_hex0 = io_memory[2][6:0];  // HEX0
    assign o_io_hex1 = io_memory[3][6:0];  // HEX1
    assign o_io_hex2 = io_memory[4][6:0];  // HEX2
    assign o_io_hex3 = io_memory[5][6:0];  // HEX3
    assign o_io_hex4 = io_memory[6][6:0];  // HEX4
    assign o_io_hex5 = io_memory[7][6:0];  // HEX5
    assign o_io_hex6 = io_memory[8][6:0];  // HEX6
    assign o_io_hex7 = io_memory[9][6:0];  // HEX7
    assign o_io_lcd  = io_memory[10];      // LCD

    // Kết nối bộ nhớ công tắc với đầu vào
   // always_ff @(posedge i_clk or negedge i_reset) begin
   //     if (!i_reset) begin
   //         sw_memory[0] <= 32'h0;  // Reset về 0
   //     end else begin
    //        sw_memory[0] <= i_io_sw;  // Cập nhật giá trị từ công tắc
   //     end
  //  end

endmodule