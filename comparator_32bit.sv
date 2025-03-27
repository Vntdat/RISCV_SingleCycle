module comparator_32bit (
    input  logic [31:0] rs1,       // Số thứ nhất (32-bit)
    input  logic [31:0] rs2,       // Số thứ hai (32-bit)
    output logic rs2_gt_rs1          // A < B
);

    logic [15:0] rs2_larger;       // Kết quả b_larger từ các khối 2-bit

    // So sánh từng khối 2-bit (kết nối thủ công)
    comparator_2bit comp0 (.a(rs1[1:0]),   .b(rs2[1:0]),    .b_larger(rs2_larger[0]));
    comparator_2bit comp1 (.a(rs1[3:2]),   .b(rs2[3:2]),    .b_larger(rs2_larger[1]));
    comparator_2bit comp2 (.a(rs1[5:4]),   .b(rs2[5:4]),    .b_larger(rs2_larger[2]));
    comparator_2bit comp3 (.a(rs1[7:6]),   .b(rs2[7:6]),    .b_larger(rs2_larger[3]));
    comparator_2bit comp4 (.a(rs1[9:8]),   .b(rs2[9:8]),    .b_larger(rs2_larger[4]));
    comparator_2bit comp5 (.a(rs1[11:10]), .b(rs2[11:10]),  .b_larger(rs2_larger[5]));
    comparator_2bit comp6 (.a(rs1[13:12]), .b(rs2[13:12]),  .b_larger(rs2_larger[6]));
    comparator_2bit comp7 (.a(rs1[15:14]), .b(rs2[15:14]),  .b_larger(rs2_larger[7]));
    comparator_2bit comp8 (.a(rs1[17:16]), .b(rs2[17:16]),  .b_larger(rs2_larger[8]));
    comparator_2bit comp9 (.a(rs1[19:18]), .b(rs2[19:18]),  .b_larger(rs2_larger[9]));
    comparator_2bit comp10(.a(rs1[21:20]), .b(rs2[21:20]),  .b_larger(rs2_larger[10]));
    comparator_2bit comp11(.a(rs1[23:22]), .b(rs2[23:22]),  .b_larger(rs2_larger[11]));
    comparator_2bit comp12(.a(rs1[25:24]), .b(rs2[25:24]),  .b_larger(rs2_larger[12]));
    comparator_2bit comp13(.a(rs1[27:26]), .b(rs2[27:26]),  .b_larger(rs2_larger[13]));
    comparator_2bit comp14(.a(rs1[29:28]), .b(rs2[29:28]),  .b_larger(rs2_larger[14]));
    comparator_2bit comp15(.a(rs1[31:30]), .b(rs2[31:30]),  .b_larger(rs2_larger[15]));

    // Kết hợp kết quả từ các khối

    assign rs2_gt_rs1 = |rs2_larger;
endmodule