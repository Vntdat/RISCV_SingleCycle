module imem (
    input  logic [31:0] i_addr,
    output logic [31:0] o_inst
);
    logic [31:0] memory [0:511];
    initial begin
        $readmemh("D:/HCMUT/HK242/CTMT/10-4/isa.mem", memory);  // file imem.mem chứa mã lệnh hex
    end
    always_comb begin
        o_inst = memory[i_addr[9:2]];
    end

endmodule

