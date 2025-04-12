module imem (
    input  logic [31:0] i_addr,
    output logic [31:0] o_inst
);
    logic [31:0] memory [0:8191];
    initial begin
<<<<<<< HEAD
        $readmemh("/home/cpa/ca111/submission/ca111/sc-test/02_test/isa.mem", memory);  // file imem.mem chứa mã lệnh hex
=======
        $readmemh("/home/cpa/ca111/sc-test/02_test/isa.mem", memory);  // file imem.mem chứa mã lệnh hex
>>>>>>> 6e8de79a09b2e48afe099dd47f8562613341c76c
    end
    always_comb begin
        o_inst = memory[i_addr[14:2]];
    end

endmodule

