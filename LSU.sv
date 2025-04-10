module lsu (
    input  logic        i_clk,
    input  logic        i_reset,
    input  logic [31:0] i_addr,
    input  logic [31:0] i_wdata,
    input  logic [3:0]  i_bmask,
    input  logic        i_wren,
    output logic [31:0] o_rdata,

    // I/O Ports
    output logic [31:0] o_io_ledr,    // Red LEDs
    output logic [31:0] o_io_ledg,    // Green LEDs
    output logic [6:0]  o_io_hex0,    // 7-seg 0
    output logic [6:0]  o_io_hex1,    // 7-seg 1
    output logic [6:0]  o_io_hex2,    // 7-seg 2
    output logic [6:0]  o_io_hex3,    // 7-seg 3
    output logic [6:0]  o_io_hex4,    // 7-seg 4
    output logic [6:0]  o_io_hex5,    // 7-seg 5
    output logic [6:0]  o_io_hex6,    // 7-seg 6
    output logic [6:0]  o_io_hex7,    // 7-seg 7
    output logic [31:0] o_io_lcd,     // LCD Control
    input  logic [31:0] i_io_sw       // Switches
);

    // Memory and I/O Registers
    logic [31:0] data_memory [0:511];  // 2KB RAM (512 words)
    logic [31:0] lcd_reg;              // LCD Control Register
    logic [31:0] ledr_reg;             // Red LEDs
    logic [31:0] ledg_reg;             // Green LEDs
    logic [31:0]  hex_reg [0:1];        // 7-segment displays

    // Address Decoding
    logic is_ram_access;    // cờ địa chỉ data
    logic is_ledr_access;   // cờ địa chỉ led đỏ
    logic is_ledg_access;   // cờ địa chỉ led xanh
    logic is_hex0_3_access; // cờ địa chỉ 4 cái led 7 đoạn 0 đến 3 
    logic is_hex4_7_access; // cờ địa chỉ 4 cái led 7 đoạn 4 đến 7 
    logic is_lcd_access;    // cờ địa chỉ lcd
    logic is_sw_access;     // cờ địa chỉ sw

    // Initialize memory (for simulation)
    initial begin
        $readmemh("C:/Users/dell/Desktop/mem.dump", data_memory);
        lcd_reg <= 0;
        ledr_reg <= 0;
        ledg_reg <= 0;
        hex_reg[0] <= 0;
		  hex_reg[1] <= 1;
    end

    // Address Decoding Logic
    always_comb begin
        is_ram_access    = (i_addr[31:11] == 21'b0000_0000_0000_0000_0000_0);     // 0x0000_0000-0x0000_07FF
        is_ledr_access   = (i_addr[31:12] == 20'h10000);     // 0x1000_0000-0x1000_0FFF
        is_ledg_access   = (i_addr[31:12] == 20'h10001);     // 0x1000_1000-0x1000_1FFF
        is_hex0_3_access = (i_addr[31:12] == 20'h10002);     // 0x1000_2000-0x1000_2FFF
        is_hex4_7_access = (i_addr[31:12] == 20'h10003);     // 0x1000_3000-0x1000_3FFF
        is_lcd_access    = (i_addr[31:12] == 20'h10004);     // 0x1000_4000-0x1000_4FFF
        is_sw_access     = (i_addr[31:12] == 20'h10010);     // 0x1001_0000-0x1001_0FFF
    end

    // Read Logic
    always_comb begin
        o_rdata = 32'h0;
        if (!i_wren) begin
            case (1'b1)
                is_ram_access: begin
                    case (i_bmask)
                        4'b0000: o_rdata = {{24{data_memory[i_addr[10:2]][7]}}, data_memory[i_addr[10:2]][7:0]};  // LB
                        4'b0001: o_rdata = {24'h0, data_memory[i_addr[10:2]][7:0]};                              // LBU
                        4'b0010: o_rdata = {{16{data_memory[i_addr[10:2]][15]}}, data_memory[i_addr[10:2]][15:0]}; // LH
                        4'b0011: o_rdata = {16'h0, data_memory[i_addr[10:2]][15:0]};                              // LHU
                        4'b0100: o_rdata = data_memory[i_addr[10:2]];                                             // LW
                        default: o_rdata = 32'h0;
                    endcase
                end
                is_ledr_access:   o_rdata = ledr_reg;
                is_ledg_access:   o_rdata = ledg_reg;
                is_hex0_3_access: o_rdata = hex_reg[0];
                is_hex4_7_access: o_rdata = hex_reg[1];
                is_lcd_access:    o_rdata = lcd_reg;
                is_sw_access:     o_rdata = i_io_sw;
                default:          o_rdata = 32'h0;
            endcase
        end
    end

    // Write Logic (Synchronous)
    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            data_memory <= '{default: 0};
            lcd_reg <= 0;
            ledr_reg <= 0;
            ledg_reg <= 0;
            hex_reg[0] <= 0;
	    hex_reg[1] <= 1;
        end
        else if (i_wren) begin
            case (1'b1)
                is_ram_access: begin
                    case (i_bmask)
                        4'b1000: data_memory[i_addr[10:2]][7:0] <= i_wdata[7:0];    // SB
                        4'b1001: data_memory[i_addr[10:2]][15:0] <= i_wdata[15:0];  // SH
                        4'b1010: data_memory[i_addr[10:2]] <= i_wdata;              // SW
                        default: ; // Ignore
                    endcase
                end
                is_ledr_access:   ledr_reg <= i_wdata;
                is_ledg_access:   ledg_reg <= i_wdata;
                is_hex0_3_access: hex_reg[0] <= i_wdata;
                is_hex4_7_access: hex_reg[1] <= i_wdata;
                is_lcd_access:    lcd_reg <= i_wdata;
                default: ; // Ignore other writes
            endcase
        end
    end

    // Connect I/O Outputs
    assign o_io_ledr = ledr_reg;
    assign o_io_ledg = ledg_reg;
    assign o_io_lcd  = lcd_reg;
    assign o_io_hex0 = hex_reg[0][6:0];
	 assign o_io_hex1 = hex_reg[0][14:8];
	 assign o_io_hex2 = hex_reg[0][22:16];
	 assign o_io_hex3 = hex_reg[0][30:24];
	 assign o_io_hex4 = hex_reg[1][6:0];
	 assign o_io_hex5 = hex_reg[1][14:8];
	 assign o_io_hex6 = hex_reg[1][22:16];
	 assign o_io_hex7 = hex_reg[1][30:24];
	 
endmodule
