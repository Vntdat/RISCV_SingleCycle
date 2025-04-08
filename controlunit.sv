module controlunit (
    input logic [31:0] i_instr,
    input logic br_less, br_equal,
    output logic pc_sel, rd_wren, br_un, opa_sel, opb_sel, mem_wren,
    output logic [3:0] alu_op,
    output logic [1:0] wb_sel
);

    logic [4:0] opcode;
    logic [2:0] fun3;
    logic fun7;

    always_comb begin 
        opcode = i_instr[6:2];
        fun3   = i_instr[14:12];
        fun7   = i_instr[30];
    end

    always_comb begin
        // Giá trị mặc định
        pc_sel    = 1'b0;    // PC = PC + 4
        br_un     = 1'b0;    // so sánh có dấu
        rd_wren   = 1'b0;    // đọc
        opa_sel   = 1'b0;    // ALU lấy rs1
        opb_sel   = 1'b1;    // ALU lấy imm
        mem_wren  = 1'b0;    // đọc từ ALU (load)
        alu_op    = 4'b1111; 
        wb_sel    = 2'b00;   // ALU data

        case (opcode)
            // R_Format
            5'b01100: begin
                pc_sel  = 1'b0;
                rd_wren = 1'b1;
                opa_sel = 1'b0;
                opb_sel = 1'b0; // rs2
                wb_sel  = 2'b00; // ALU data
                
                case (fun3)
                    3'b000: begin
                        case (fun7)
                            1'b0: alu_op = 4'b0000; // ADD
                            1'b1: alu_op = 4'b0001; // SUB
                        endcase
                    end
                    3'b001: alu_op = 4'b0111; // SLL
                    3'b010: alu_op = 4'b0010; // SLT
                    3'b011: alu_op = 4'b0011; // SLTU
                    3'b100: alu_op = 4'b0100; // XOR
                    3'b101: begin
                        case (fun7)
                            1'b0: alu_op = 4'b1000; // SRL
                            1'b1: alu_op = 4'b1001; // SRA
                        endcase
                    end
                    3'b110: alu_op = 4'b0101; // OR
                    3'b111: alu_op = 4'b0110; // AND
                endcase
            end
            // B-Format (so sánh nhanh)
            5'b11000: begin
                opa_sel  = 1'b1;
                opb_sel  = 1'b1; // imm
                rd_wren  = 1'b0;
                mem_wren = 1'b0;

                case (fun3)
                    3'b000, 3'b001, 3'b100, 3'b101: br_un = 1'b0;  // BEQ/BNE/BLT/BGE: so sánh có dấu
                    3'b110, 3'b111: br_un = 1'b1;                  // BLTU/BGEU: so sánh không dấu
                    default: br_un = 1'b0;
                endcase

                case (fun3)
                    3'b000: pc_sel = br_equal;      // BEQ
                    3'b001: pc_sel = !br_equal;     // BNE
                    3'b100: pc_sel = br_less;       // BLT
                    3'b101: pc_sel = !br_less;      // BGE
                    3'b110: pc_sel = br_less;       // BLTU
                    3'b111: pc_sel = !br_less;      // BGEU
                    default: pc_sel = 1'b0;         // Mặc định không nhảy
                endcase
            end
            5'b00000: begin  // I_Format Load
                pc_sel   = 1'b0;
                rd_wren  = 1'b1;
                opa_sel  = 1'b0;
                opb_sel  = 1'b1; // imm
                mem_wren = 1'b0;
                wb_sel   = 2'b01; // LSU
            end
            5'b01000: begin  // S_Format Store
                pc_sel   = 1'b0;
                rd_wren  = 1'b0;
                opa_sel  = 1'b0;
                opb_sel  = 1'b1; // imm
                mem_wren = 1'b1;
                wb_sel   = 2'b01; // LSU
            end
            5'b01101: begin  // I_Format LUI
                pc_sel   = 1'b0;
                rd_wren  = 1'b1;
                mem_wren = 1'b0;
                wb_sel   = 2'b11;  // nối immgen đến mux
            end
            5'b11011: begin  // U_Format JAL
                pc_sel   = 1'b1;
                rd_wren  = 1'b1;
                opa_sel  = 1'b1;
                opb_sel  = 1'b1; // imm
                mem_wren = 1'b0;
                wb_sel   = 2'b10; // PC + 4
            end
            5'b11001: begin  // U_Format JALR
                pc_sel   = 1'b1;
                rd_wren  = 1'b1;
                opa_sel  = 1'b0;
                opb_sel  = 1'b1; // imm
                mem_wren = 1'b0;
                wb_sel   = 2'b10; // PC + 4
            end
            default: begin
                pc_sel    = 1'b0;
                br_un     = 1'b0;
                rd_wren   = 1'b0;
                opa_sel   = 1'b0;
                opb_sel   = 1'b1;
                mem_wren  = 1'b0;
                alu_op    = 4'b0000;
                wb_sel    = 2'b00;
            end
        endcase
    end
endmodule
