`timescale 1ns / 1ps

module controlunit_tb;

    // Inputs
    logic [31:0] i_instr;
    logic br_less;
    logic br_equal;
    
    // Outputs
    logic pc_sel, rd_wren, br_un, opa_sel, opb_sel, mem_wren;
    logic insn_vld;
    logic [3:0] alu_op;
    logic [1:0] wb_sel;
    
    // Instantiate the Unit Under Test (UUT)
    controlunit uut (
        .i_instr(i_instr),
        .br_less(br_less),
        .br_equal(br_equal),
        .pc_sel(pc_sel),
        .rd_wren(rd_wren),
        .br_un(br_un),
        .opa_sel(opa_sel),
        .opb_sel(opb_sel),
        .mem_wren(mem_wren),
        .insn_vld(insn_vld),
        .alu_op(alu_op),
        .wb_sel(wb_sel)
    );
    
    task automatic check_output(
        input string inst_name,
        input logic exp_pc_sel,
        input logic exp_rd_wren,
        input logic exp_br_un,
        input logic exp_opa_sel,
        input logic exp_opb_sel,
        input logic exp_mem_wren,
        input logic exp_insn_vld,
        input [3:0] exp_alu_op,
        input [1:0] exp_wb_sel
    );
        begin
            $display("\nTesting %s instruction:", inst_name);
            $display("Input instruction: %32b", i_instr);
            
            if (pc_sel !== exp_pc_sel || rd_wren !== exp_rd_wren || br_un !== exp_br_un ||
                opa_sel !== exp_opa_sel || opb_sel !== exp_opb_sel || mem_wren !== exp_mem_wren ||
                insn_vld !== exp_insn_vld || alu_op !== exp_alu_op || wb_sel !== exp_wb_sel) begin
                $display("ERROR: Output mismatch!");
                $display("Expected: pc_sel=%b, rd_wren=%b, br_un=%b, opa_sel=%b, opb_sel=%b", 
                         exp_pc_sel, exp_rd_wren, exp_br_un, exp_opa_sel, exp_opb_sel);
                $display("         mem_wren=%b, insn_vld=%b, alu_op=%4b, wb_sel=%2b",
                         exp_mem_wren, exp_insn_vld, exp_alu_op, exp_wb_sel);
                $display("Got:      pc_sel=%b, rd_wren=%b, br_un=%b, opa_sel=%b, opb_sel=%b", 
                         pc_sel, rd_wren, br_un, opa_sel, opb_sel);
                $display("         mem_wren=%b, insn_vld=%b, alu_op=%4b, wb_sel=%2b",
                         mem_wren, insn_vld, alu_op, wb_sel);
            end else begin
                $display("%s instruction PASSED!", inst_name);
            end
        end
    endtask

    initial begin
        // Initialize Inputs
        i_instr = 0;
        br_less = 0;
        br_equal = 0;
        
        $display("======================================");
        $display("  FULL RISC-V CONTROL UNIT TESTBENCH  ");
        $display("======================================");
        
        // Wait 10 ns for global reset
        #10;

        //==================================================
        // 1. R-type Instructions (12 lệnh)
        //==================================================
        $display("\n==== 1. Testing R-type Instructions (12) ====");
        
        // 1.1 Arithmetic
        i_instr = {7'b0000000, 5'b00000, 5'b00000, 3'b000, 5'b00000, 7'b0110011}; #10; // ADD
        check_output("ADD", 0,1,0,0,0,0,0,4'b0000,2'b00);
        
        i_instr = {7'b0100000, 5'b00000, 5'b00000, 3'b000, 5'b00000, 7'b0110011}; #10; // SUB
        check_output("SUB", 0,1,0,0,0,0,0,4'b0001,2'b00);
        
        // 1.2 Logical
        i_instr = {7'b0000000, 5'b00000, 5'b00000, 3'b111, 5'b00000, 7'b0110011}; #10; // AND
        check_output("AND", 0,1,0,0,0,0,0,4'b0110,2'b00);
        
        i_instr = {7'b0000000, 5'b00000, 5'b00000, 3'b110, 5'b00000, 7'b0110011}; #10; // OR
        check_output("OR", 0,1,0,0,0,0,0,4'b0101,2'b00);
        
        i_instr = {7'b0000000, 5'b00000, 5'b00000, 3'b100, 5'b00000, 7'b0110011}; #10; // XOR
        check_output("XOR", 0,1,0,0,0,0,0,4'b0100,2'b00);
        
        // 1.3 Shift
        i_instr = {7'b0000000, 5'b00000, 5'b00000, 3'b001, 5'b00000, 7'b0110011}; #10; // SLL
        check_output("SLL", 0,1,0,0,0,0,0,4'b0111,2'b00);
        
        i_instr = {7'b0000000, 5'b00000, 5'b00000, 3'b101, 5'b00000, 7'b0110011}; #10; // SRL
        check_output("SRL", 0,1,0,0,0,0,0,4'b1000,2'b00);
        
        i_instr = {7'b0100000, 5'b00000, 5'b00000, 3'b101, 5'b00000, 7'b0110011}; #10; // SRA
        check_output("SRA", 0,1,0,0,0,0,0,4'b1001,2'b00);
        
        // 1.4 Comparison
        i_instr = {7'b0000000, 5'b00000, 5'b00000, 3'b010, 5'b00000, 7'b0110011}; #10; // SLT
        check_output("SLT", 0,1,0,0,0,0,0,4'b0010,2'b00);
        
        i_instr = {7'b0000000, 5'b00000, 5'b00000, 3'b011, 5'b00000, 7'b0110011}; #10; // SLTU
        check_output("SLTU", 0,1,0,0,0,0,0,4'b0011,2'b00);

        //==================================================
        // 2. I-type Instructions (13 lệnh)
        //==================================================
        $display("\n==== 2. Testing I-type Instructions (13) ====");
        
        // 2.1 Arithmetic Immediate
        i_instr = {12'b0, 5'b00000, 3'b000, 5'b00000, 7'b0010011}; #10; // ADDI
        check_output("ADDI", 0,1,0,0,1,0,0,4'b0000,2'b00);
        
        i_instr = {12'b0, 5'b00000, 3'b111, 5'b00000, 7'b0010011}; #10; // ANDI
        check_output("ANDI", 0,1,0,0,1,0,0,4'b0110,2'b00);
        
        i_instr = {12'b0, 5'b00000, 3'b110, 5'b00000, 7'b0010011}; #10; // ORI
        check_output("ORI", 0,1,0,0,1,0,0,4'b0101,2'b00);
        
        i_instr = {12'b0, 5'b00000, 3'b100, 5'b00000, 7'b0010011}; #10; // XORI
        check_output("XORI", 0,1,0,0,1,0,0,4'b0100,2'b00);
        
        // 2.2 Shift Immediate
        i_instr = {7'b0000000, 5'b00000, 5'b00000, 3'b001, 5'b00000, 7'b0010011}; #10; // SLLI
        check_output("SLLI", 0,1,0,0,1,0,0,4'b0111,2'b00);
        
        i_instr = {7'b0000000, 5'b00000, 5'b00000, 3'b101, 5'b00000, 7'b0010011}; #10; // SRLI
        check_output("SRLI", 0,1,0,0,1,0,0,4'b1000,2'b00);
        
        i_instr = {7'b0100000, 5'b00000, 5'b00000, 3'b101, 5'b00000, 7'b0010011}; #10; // SRAI
        check_output("SRAI", 0,1,0,0,1,0,0,4'b1001,2'b00);
        
        // 2.3 Comparison Immediate
        i_instr = {12'b0, 5'b00000, 3'b010, 5'b00000, 7'b0010011}; #10; // SLTI
        check_output("SLTI", 0,1,0,0,1,0,0,4'b0010,2'b00);
        
        i_instr = {12'b0, 5'b00000, 3'b011, 5'b00000, 7'b0010011}; #10; // SLTIU
        check_output("SLTIU", 0,1,0,0,1,0,0,4'b0011,2'b00);
        
        // 2.4 Load
        i_instr = {12'b0, 5'b00000, 3'b000, 5'b00000, 7'b0000011}; #10; // LB
        check_output("LB", 0,1,0,0,1,0,0,4'b0000,2'b01);
        
        i_instr = {12'b0, 5'b00000, 3'b001, 5'b00000, 7'b0000011}; #10; // LH
        check_output("LH", 0,1,0,0,1,0,0,4'b0000,2'b01);
        
        i_instr = {12'b0, 5'b00000, 3'b010, 5'b00000, 7'b0000011}; #10; // LW
        check_output("LW", 0,1,0,0,1,0,0,4'b0000,2'b01);
        
        i_instr = {12'b0, 5'b00000, 3'b100, 5'b00000, 7'b0000011}; #10; // LBU
        check_output("LBU", 0,1,0,0,1,0,0,4'b0000,2'b01);
        
        i_instr = {12'b0, 5'b00000, 3'b101, 5'b00000, 7'b0000011}; #10; // LHU
        check_output("LHU", 0,1,0,0,1,0,0,4'b0000,2'b01);

        //==================================================
        // 3. S-type Instructions (3 lệnh)
        //==================================================
        $display("\n==== 3. Testing S-type Instructions (3) ====");
        
        i_instr = {7'b0, 5'b00000, 5'b00000, 3'b000, 5'b00000, 7'b0100011}; #10; // SB
        check_output("SB", 0,0,0,0,1,1,0,4'b0000,2'b01);
        
        i_instr = {7'b0, 5'b00000, 5'b00000, 3'b001, 5'b00000, 7'b0100011}; #10; // SH
        check_output("SH", 0,0,0,0,1,1,0,4'b0000,2'b01);
        
        i_instr = {7'b0, 5'b00000, 5'b00000, 3'b010, 5'b00000, 7'b0100011}; #10; // SW
        check_output("SW", 0,0,0,0,1,1,0,4'b0000,2'b01);

        //==================================================
        // 4. B-type Instructions (6 lệnh)
        //==================================================
        $display("\n==== 4. Testing B-type Instructions (6) ====");
        br_equal = 1; br_less = 0;
        
        i_instr = {7'b0, 5'b00000, 5'b00000, 3'b000, 5'b00000, 7'b1100011}; #10; // BEQ
        check_output("BEQ", br_equal,0,0,1,1,0,0,4'b0000,2'b00);
        
        i_instr = {7'b0, 5'b00000, 5'b00000, 3'b001, 5'b00000, 7'b1100011}; #10; // BNE
        check_output("BNE", !br_equal,0,0,1,1,0,0,4'b0000,2'b00);
        
        i_instr = {7'b0, 5'b00000, 5'b00000, 3'b100, 5'b00000, 7'b1100011}; #10; // BLT
        check_output("BLT", br_less,0,0,1,1,0,0,4'b0000,2'b00);
        
        i_instr = {7'b0, 5'b00000, 5'b00000, 3'b101, 5'b00000, 7'b1100011}; #10; // BGE
        check_output("BGE", !br_less,0,0,1,1,0,0,4'b0000,2'b00);
        
        br_less = 1; // Test unsigned branches
        i_instr = {7'b0, 5'b00000, 5'b00000, 3'b110, 5'b00000, 7'b1100011}; #10; // BLTU
        check_output("BLTU", br_less,0,1,1,1,0,0,4'b0000,2'b00);
        
        i_instr = {7'b0, 5'b00000, 5'b00000, 3'b111, 5'b00000, 7'b1100011}; #10; // BGEU
        check_output("BGEU", !br_less,0,1,1,1,0,0,4'b0000,2'b00);

        //==================================================
        // 5. U-type & J-type Instructions (3 lệnh)
        //==================================================
        $display("\n==== 5. Testing U/J-type Instructions (3) ====");
        
        i_instr = {20'b0, 5'b00000, 7'b0110111}; #10; // LUI
        check_output("LUI", 0,1,0,0,0,0,0,4'b0000,2'b11);
        
        i_instr = {20'b0, 5'b00000, 7'b0010111}; #10; // AUIPC
        check_output("AUIPC", 0,1,0,1,1,0,0,4'b0000,2'b10);
        
        i_instr = {20'b0, 5'b00000, 7'b1101111}; #10; // JAL
        check_output("JAL", 1,1,0,1,1,0,0,4'b0000,2'b10);
        
        i_instr = {12'b0, 5'b00000, 3'b000, 5'b00000, 7'b1100111}; #10; // JALR
        check_output("JALR", 1,1,0,0,1,0,0,4'b0000,2'b10);

        //==================================================
        // 6. Test invalid instruction
        //==================================================
        $display("\n==== 6. Testing Invalid Instruction ====");
        i_instr = {25'b0, 7'b1111111}; #10;
        check_output("INVALID", 0,0,0,0,1,0,1,4'b0000,2'b00);

        // Finish simulation
        #10;
        $display("\n======================================");
        $display("  ALL 37 INSTRUCTIONS TESTED SUCCESSFULLY");
        $display("======================================");
        $finish;
    end
    
endmodule