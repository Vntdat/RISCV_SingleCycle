module lsu (
    input  logic        i_clk,
    input  logic        i_reset,
    input  logic [31:0] i_lsu_addr,
    input  logic [31:0] i_st_data,
    input  logic        i_lsu_wren,

    output logic [31:0] o_ld_data,
    output logic [31:0] o_io_ledr,
    output logic [31:0] o_io_ledg,
    output logic [6:0]  o_io_hex0,
    output logic [6:0]  o_io_hex1,
    output logic [6:0]  o_io_hex2,
    output logic [6:0]  o_io_hex3,
    output logic [6:0]  o_io_hex4,
    output logic [6:0]  o_io_hex5,
    output logic [6:0]  o_io_hex6,
    output logic [6:0]  o_io_hex7,
    output logic [31:0] o_io_lcd,

    input  logic [31:0] i_io_sw
);

    logic [31:0] mem [0:8191];

    logic mem_sel, sw_sel, ledr_sel, ledg_sel, hex_lo_sel, hex_hi_sel, lcd_sel;

    always_comb begin
        mem_sel     = (i_lsu_addr >= 32'h0000_0000) && (i_lsu_addr <= 32'h0000_07FF);
        ledr_sel    = (i_lsu_addr >= 32'h1000_0000) && (i_lsu_addr <= 32'h1000_0FFF);
        ledg_sel    = (i_lsu_addr >= 32'h1000_1000) && (i_lsu_addr <= 32'h1000_1FFF);
        hex_lo_sel  = (i_lsu_addr >= 32'h1000_2000) && (i_lsu_addr <= 32'h1000_2FFF);
        hex_hi_sel  = (i_lsu_addr >= 32'h1000_3000) && (i_lsu_addr <= 32'h1000_3FFF);
        lcd_sel     = (i_lsu_addr >= 32'h1000_4000) && (i_lsu_addr <= 32'h1000_4FFF);
        sw_sel      = (i_lsu_addr >= 32'h1001_0000) && (i_lsu_addr <= 32'h1001_0FFF);
    end
// STORE
    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            o_io_ledr <= 32'd0;
            o_io_ledg <= 32'd0;
            o_io_lcd  <= 32'd0;
            o_io_hex0 <= 7'd0;
            o_io_hex1 <= 7'd0;
            o_io_hex2 <= 7'd0;
            o_io_hex3 <= 7'd0;
            o_io_hex4 <= 7'd0;
            o_io_hex5 <= 7'd0;
            o_io_hex6 <= 7'd0;
            o_io_hex7 <= 7'd0;
        end else if (i_lsu_wren) begin
            if (mem_sel)
                mem[i_lsu_addr[14:2]] <= i_st_data;
            else if (ledr_sel)
                o_io_ledr <= i_st_data;
            else if (ledg_sel)
                o_io_ledg <= i_st_data;
            else if (hex_lo_sel) begin
                o_io_hex0 <= i_st_data[6:0];
                o_io_hex1 <= i_st_data[14:8];
                o_io_hex2 <= i_st_data[22:16];
                o_io_hex3 <= i_st_data[30:24];
            end else if (hex_hi_sel) begin
                o_io_hex4 <= i_st_data[6:0];
                o_io_hex5 <= i_st_data[14:8];
                o_io_hex6 <= i_st_data[22:16];
                o_io_hex7 <= i_st_data[30:24];
            end else if (lcd_sel)
                o_io_lcd <= i_st_data;
        end
    end
 // LOAD
    always_comb begin
        if (mem_sel)
            o_ld_data = mem[i_lsu_addr[14:2]];
        else if (sw_sel)
            o_ld_data = i_io_sw;
        else
            o_ld_data = 32'd0;
    end

endmodule