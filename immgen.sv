module immgen (
    input  logic [31:0] i_inst,  // Lệnh đầu vào (32-bit)
    output logic [31:0] o_imm    // Giá trị Immediate đã mở rộng
);
    logic [6:0] opcode;          // Trích xuất opcode từ lệnh
    assign opcode = i_inst[6:0];

    always_comb begin
        case (opcode)
            // I-Type: Các lệnh số học sử dụng Immediate (ADDI, ANDI, ORI, XORI, SLTI, SLTIU, SLLI, SRLI, SRAI)
            7'b0010011: begin
                o_imm = {{21{i_inst[31]}}, i_inst[30:20]};
            end

            // Load-Type: Các lệnh tải dữ liệu (LW, LH, LB, LBU, LHU)
            7'b0000011: begin
                o_imm = {{21{i_inst[31]}}, i_inst[30:20]};
            end

            // Store-Type: Các lệnh lưu dữ liệu (SW, SH, SB)
            7'b0100011: begin
                o_imm = {{20{i_inst[31]}}, i_inst[31:25], i_inst[11:7]};
            end

            // Branch-Type: Các lệnh rẽ nhánh (BEQ, BNE, BLT, BGE, BLTU, BGEU)
            7'b1100011: begin
                o_imm = {{20{i_inst[31]}}, i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0}; // Shift left 1
            end

            // Jump-Type: Lệnh nhảy không điều kiện (JAL)
            7'b1101111: begin
                o_imm = {{12{i_inst[31]}}, i_inst[19:12], i_inst[20], i_inst[30:21], 1'b0}; // Shift left 1
            end

            // Upper Immediate-Type: Lệnh nạp giá trị tức thời vào thanh ghi (LUI)
            7'b0110111: begin
                o_imm = {i_inst[31:12], 12'b0}; // Không cần mở rộng dấu
            end

            // Upper Immediate-Type: Lệnh tính toán địa chỉ (AUIPC)
            7'b0010111: begin
                o_imm = {i_inst[31:12], 12'b0}; // Không cần mở rộng dấu
            end

            // JALR-Type: Lệnh nhảy có điều kiện qua thanh ghi (JALR)
            7'b1100111: begin
                o_imm = {{21{i_inst[31]}}, i_inst[30:20]};
            end

            // Mặc định: Không xác định opcode → Immediate = 0
            default: begin
                o_imm = 32'b0;
            end
        endcase
    end
endmodule
