module comparator_32bit_unsigned(
    input logic [31:0] rs1, rs2,    // Hai số cần so sánh
    output logic rs1_lt_rs2      // rs1 < rs2
);
    logic [31:0] sub_result;
    logic borrow;

    // Sử dụng bộ trừ 32-bit
    sub_32 subtractor (
        .a(rs1),
        .b(rs2),
        .s(sub_result),
        .c_out(borrow) // borrow = 0 nếu A < B
    );

    assign A_lt_B = ~borrow;               // Nếu có mượn (borrow = 0) thì A < B

endmodule
