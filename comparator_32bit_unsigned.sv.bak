module comparator_32bit_unsigned(
    input logic [31:0] a, b,    // Hai số cần so sánh
    output logic a_lt_b         // a < b
);
    logic [31:0] sub_result;
    logic borrow;

    // Sử dụng bộ trừ 32-bit
    sub_32 subtractor (
        .a(a),
        .b(b),
        .s(sub_result),
        .c_out(borrow) // borrow = 0 nếu a < b
    );

    assign a_lt_b = ~borrow;  // Nếu có mượn (borrow = 0) thì a < b

endmodule