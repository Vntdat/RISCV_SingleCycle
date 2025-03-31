module controlunit (
		//tin hieu ngo vao
		input logic [31:0] i_instr,
		input logic br_less, br_equal,
		
		//tin hieu ngo ra
		output logic pc_sel, rd_wren, br_un, opa_sel, opb_sel, mem_wren,
		output logic [31:0] insn_vld, 
		output logic [3:0] alu_op,
		output logic [1:0] wb_sel
);
		// khai bao cac tin hieu can
		logic [4:0] opcode;
		logic [2:0] fun3;
		logic fun7;
		
		// gan cac tin hieu dua tren ma may
		always_comb begin 
				opcode = i_instr [6:2];
				fun3   = i_instr [14:12];
				fun7   = i_instr [30];
		end
		// gan cac gia tri ban dau cho cac ngo ra
		always_comb begin
				pc_sel    = 1'b0;    // PC = PC + 4
				br_un     = 1'b0;    // so sanh co dau
				rd_wren   = 1'b0;    // read
				opa_sel   = 1'b0;    // alu nhan rs1
				opb_sel   = 1'b0;    // alu nhan imm
				mem_wren  = 1'b0;    // read alu (load)
				alu_op    = 4'b0000; // add
				wb_sel    = 2'b00;   // pc +4
				insn_vld  = 1'b1;    // len hop le
				
		// dua tren opcode de phan biec cac loai lenh R, I, S, B, U, J
		
		case (opcode)
				// R_Format
				5'b01100: begin
					pc_sel  = 1'b0;
					rd_wren = 1'b1;
					opa_sel = 1'b0;
					opb_sel = 1'b1;
					wb_sel  = 2'b01;
					insn_vld  = 1'b0;
								case  (fun3)
										3'b000: begin
															case  (fun7)
																1'b0: alu_op = 4'b0000; //lenh ADD
																1'b1: alu_op = 4'b0001; //lenh SUB
															endcase
													end
										3'b001: alu_op = 4'b0111; //lenh SLL
										3'b010: alu_op = 4'b0010; //lenh SLT
										3'b011: alu_op = 4'b0011; //lenh SLTU
										3'b100: alu_op = 4'b0100; //lenh XOR
										3'b101: begin
															case (fun7)
																1'b0: alu_op = 4'b1000; //lenh SRL
																1'b1: alu_op = 4'b1001; //lenh SRA
															endcase
													end
										3'b110: alu_op = 4'b0101; //lenh OR
										3'b111: alu_op = 4'b0110; //lenh AND
								endcase													
						end
				// I_Format tinh toan
				5'b00100: begin
					pc_sel  = 1'b0;
					rd_wren = 1'b1;
					opa_sel = 1'b0;
					opb_sel = 1'b1;
					wb_sel  = 2'b01;
					insn_vld  = 1'b0;
									case (fun3)
											3'b000: alu_op = 4'b0000; // lenh ADDI
											3'b001: alu_op = 4'b0111; // lenh SLLI
											3'b010: alu_op = 4'b0010; // lenh SLTI
											3'b011: alu_op = 4'b0011; // lenh SLTIU
											3'b100: alu_op = 4'b0100; // lenh XORI
											3'b101: begin
															case (fun7)
																1'b0: alu_op = 4'b1000; // lenh SRLI
																1'b1: alu_op = 4'b1001; // lenh SRAI
															endcase
														end
											3'b110: alu_op = 4'b0101; // lenh ORI
											3'b111: alu_op = 4'b0110; // lenh ANDI
									endcase
							end
				//B-Format len re nhanh
				5'b11000: begin
								opa_sel  = 1'b1;
								opb_sel  = 1'b0;
								rd_wren  = 1'b0;
								mem_wren = 1'b0;
								insn_vld  = 1'b0;
									case (fun3)
											3'b000: begin 						//lenh BEQ: nhay neu bang khong dau
													br_un = 1'b0;  			// khong dau
													pc_sel = br_equal;
													  end
											3'b001: begin 						//lenh BNE nhay neu rs1
													br_un = 1'b0; 				// khong dau
													pc_sel = !br_equal;
													  end
											3'b100: begin 						//lenh BLT: nhay neu rs1 < rs2 khong dau
													br_un = 1'b0;  			// khong dau
													pc_sel = br_less; 
														end
											3'b101: begin 						//lenh BGE: nhay neu rs1>=rs2 khong dau
													br_un = 1'b0;  			// khong dau
													pc_sel = !br_less;
														end
											3'b110: begin						//lenh BLTU: nhay neu rs1<rs2 co dau
													br_un = 1'b1;  			// co dau
													pc_sel = br_less;
														end
											3'b111: begin						//lenh BGEU: nhay neu rs1>=rs2 co dau
													br_un = 1'b1;  			// co dau
													pc_sel = !br_less;
														end
									endcase			
							end
				// S_Format lenh Store ghi du lieu vao LSU
				5'b01000: begin
					pc_sel   = 1'b0;
					rd_wren  = 1'b0;
					opa_sel  = 1'b0;
					opb_sel  = 1'b1;
					mem_wren = 1'b1;
					wb_sel   = 2'b10;
					insn_vld  = 1'b0;
							 end
				// I_Format lenh Load doc du leu tu LSU
				5'b00000: begin
					pc_sel   = 1'b0;
					rd_wren  = 1'b1;
					opa_sel  = 1'b0;
					opb_sel  = 1'b0;
					mem_wren = 1'b0;
					wb_sel   = 2'b10;	
					insn_vld  = 1'b0;
							 end			
				//U_Format lenh nhay khong dieu kien
				5'b11011: begin   //lenh JAL
					pc_sel   = 1'b1;
					rd_wren  = 1'b1;
					opa_sel  = 1'b1;
					opb_sel  = 1'b0;
					mem_wren = 1'b0;
					wb_sel   = 2'b00;
					insn_vld  = 1'b0;
							 end
				5'b11001: begin 	//lenh JALR
					pc_sel   = 1'b1;
					rd_wren  = 1'b1;
					opa_sel  = 1'b0;
					opb_sel  = 1'b0;
					mem_wren = 1'b0;
					wb_sel   = 2'b00;
					insn_vld  = 1'b0;
							end
				//I_Format 
				//lenh LUI
				5'b01101: begin 
					pc_sel   = 1'b0;
					rd_wren  = 1'b1;
					mem_wren = 1'b0;
					wb_sel   = 2'b11;  // sửa ở trong hình anh Hải cho thêm phần nối từ immgen đến mux 4 sang 1
					insn_vld  = 1'b0;
						end
				//lenh AUIPC
				5'b00101: begin
					pc_sel   = 1'b0;
					rd_wren  = 1'b1;
					opa_sel  = 1'b1;
					opb_sel  = 1'b0;
					mem_wren = 1'b0;
					wb_sel   = 2'b00;
					insn_vld  = 1'b0;
						end
			endcase
	end
endmodule


				
