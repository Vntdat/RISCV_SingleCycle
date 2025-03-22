module comparator_32bit (
    input  logic [31:0] A,       // Số thứ nhất (32-bit)
    input  logic [31:0] B,       // Số thứ hai (32-bit)
    output logic A_gt_B,         // A > B
    output logic A_eq_B,         // A = B
    output logic A_lt_B          // A < B
);
    logic [15:0] a_larger;       // Kết quả a_larger từ các khối 2-bit
    logic [15:0] equal;          // Kết quả equal từ các khối 2-bit
    logic [15:0] b_larger;       // Kết quả b_larger từ các khối 2-bit

    // So sánh từng khối 2-bit (kết nối thủ công)
    comparator_2bit comp0 (.a(A[1:0]),   .b(B[1:0]),   .a_larger(a_larger[0]),  .equal(equal[0]),  .b_larger(b_larger[0]));
    comparator_2bit comp1 (.a(A[3:2]),   .b(B[3:2]),   .a_larger(a_larger[1]),  .equal(equal[1]),  .b_larger(b_larger[1]));
    comparator_2bit comp2 (.a(A[5:4]),   .b(B[5:4]),   .a_larger(a_larger[2]),  .equal(equal[2]),  .b_larger(b_larger[2]));
    comparator_2bit comp3 (.a(A[7:6]),   .b(B[7:6]),   .a_larger(a_larger[3]),  .equal(equal[3]),  .b_larger(b_larger[3]));
    comparator_2bit comp4 (.a(A[9:8]),   .b(B[9:8]),   .a_larger(a_larger[4]),  .equal(equal[4]),  .b_larger(b_larger[4]));
    comparator_2bit comp5 (.a(A[11:10]), .b(B[11:10]), .a_larger(a_larger[5]),  .equal(equal[5]),  .b_larger(b_larger[5]));
    comparator_2bit comp6 (.a(A[13:12]), .b(B[13:12]), .a_larger(a_larger[6]),  .equal(equal[6]),  .b_larger(b_larger[6]));
    comparator_2bit comp7 (.a(A[15:14]), .b(B[15:14]), .a_larger(a_larger[7]),  .equal(equal[7]),  .b_larger(b_larger[7]));
    comparator_2bit comp8 (.a(A[17:16]), .b(B[17:16]), .a_larger(a_larger[8]),  .equal(equal[8]),  .b_larger(b_larger[8]));
    comparator_2bit comp9 (.a(A[19:18]), .b(B[19:18]), .a_larger(a_larger[9]),  .equal(equal[9]),  .b_larger(b_larger[9]));
    comparator_2bit comp10(.a(A[21:20]), .b(B[21:20]), .a_larger(a_larger[10]), .equal(equal[10]), .b_larger(b_larger[10]));
    comparator_2bit comp11(.a(A[23:22]), .b(B[23:22]), .a_larger(a_larger[11]), .equal(equal[11]), .b_larger(b_larger[11]));
    comparator_2bit comp12(.a(A[25:24]), .b(B[25:24]), .a_larger(a_larger[12]), .equal(equal[12]), .b_larger(b_larger[12]));
    comparator_2bit comp13(.a(A[27:26]), .b(B[27:26]), .a_larger(a_larger[13]), .equal(equal[13]), .b_larger(b_larger[13]));
    comparator_2bit comp14(.a(A[29:28]), .b(B[29:28]), .a_larger(a_larger[14]), .equal(equal[14]), .b_larger(b_larger[14]));
    comparator_2bit comp15(.a(A[31:30]), .b(B[31:30]), .a_larger(a_larger[15]), .equal(equal[15]), .b_larger(b_larger[15]));

    // Kết hợp kết quả từ các khối
    assign A_gt_B = |a_larger;
    assign A_eq_B = &equal;
    assign A_lt_B = |b_larger;
endmodule