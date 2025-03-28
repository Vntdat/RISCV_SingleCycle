module comparator_32bit_unsigned(
    input logic [31:0] a, b,    // Hai sá»‘ cáº§n so sÃ¡nh
    output logic a_lt_b         // a < b
);
    logic [31:0] sub_result;
    logic borrow;

    sub_32 subtractor (
        .a(a),
        .b(b),
        .s(sub_result),
        .c_out(borrow) // borrow = 0 náº¿u a < b
    );

    assign a_lt_b = ~borrow;  // Náº¿u cÃ³ mÆ°á»£n (borrow = 0) thÃ¬ a < b

endmodule