module wrapper (
    input logic CLOCK_50,
    input logic [2:0] KEY,
    input logic [17:0] SW,  // Switches trên board DE2

    output logic [31:0] LCD,   // LCD 32-bit
    output logic [7:0] LEDG,   // LED xanh
    output logic [9:0] LEDR,   // LED đỏ

    output logic [6:0] HEX0,
    output logic [6:0] HEX1,
    output logic [6:0] HEX2,
    output logic [6:0] HEX3,
    output logic [6:0] HEX4,
    output logic [6:0] HEX5,
    output logic [6:0] HEX6,
    output logic [6:0] HEX7,

    output logic [31:0] o_pc_debug  // Debug: địa chỉ PC hiện tại
);


    singlecycle cpu (
        .i_clk(CLOCK_50),
        .i_reset(KEY[0]),
        .o_pc_debug(o_pc_debug),
			.i_io_sw({14'b0, SW}),  // mở rộng lên 32-bit nếu cần
        .o_io_lcd(LCD),
        .o_io_ledg({24'b0, LEDG}),  // mở rộng LEDG thành 32-bit
        .o_io_ledr({22'b0, LEDR}),  // mở rộng LEDR thành 32-bit
        .o_io_hex0 (HEX0),
		  .o_io_hex1 (HEX1),
		  .o_io_hex2 (HEX2),
		  .o_io_hex3 (HEX3),
		  .o_io_hex4 (HEX4),
		  .o_io_hex5 (HEX5),
		  .o_io_hex6 (HEX6),
		  .o_io_hex7 (HEX7)
    );

endmodule
