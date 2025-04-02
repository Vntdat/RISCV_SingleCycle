`timescale 1ns / 1ps

module singlecycle_tb;
    reg i_clk;
    reg i_reset;
    reg [31:0] i_io_sw;
    wire [31:0] o_io_lcd;
    wire [31:0] o_io_ledg;
    wire [31:0] o_io_ledr;
    wire [6:0] o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3;
    wire [6:0] o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7;
    wire [31:0] o_pc_debug;
    wire o_insn_vld;
    
    // Instantiate the DUT (Device Under Test)
    singlecycle uut (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_io_sw(i_io_sw),
        .o_io_lcd(o_io_lcd),
        .o_io_ledg(o_io_ledg),
        .o_io_ledr(o_io_ledr),
        .o_io_hex0(o_io_hex0),
        .o_io_hex1(o_io_hex1),
        .o_io_hex2(o_io_hex2),
        .o_io_hex3(o_io_hex3),
        .o_io_hex4(o_io_hex4),
        .o_io_hex5(o_io_hex5),
        .o_io_hex6(o_io_hex6),
        .o_io_hex7(o_io_hex7),
        .o_pc_debug(o_pc_debug),
        .o_insn_vld(o_insn_vld)
    );

    // Clock generation
    always #5 i_clk = ~i_clk;
    
    initial begin
        // Initialize inputs
        i_clk = 0;
        i_reset = 1;
        i_io_sw = 0;
        
        // Wait for reset
        #10;
        i_reset = 0;
        
        // Load instructions into memory
        $readmemh("app1.dut", uut.memory.memory_array);
        
        // Run simulation
        #1000;
        
        // Finish simulation
        $finish;
    end
endmodule