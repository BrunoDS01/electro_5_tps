module opcode_decode(
	input wire [6:0] opcode,
	input wire [2:0] funct3,
	
	output reg [2:0] instr_type,
	output reg save_to_reg,
	output reg rs1_used,
	output reg rs2_used,
	output reg immediate_used,
	output reg is_branch,
	output reg rd_memory,
	output reg wr_memory,
	output reg shamt_used,
	output reg inc_pc
);

/*
instr_type:
*/

parameter R_TYPE = 3'd0;
parameter I_TYPE = 3'd1;
parameter S_TYPE = 3'd2;
parameter B_TYPE = 3'd3;
parameter U_TYPE = 3'd4;
parameter J_TYPE = 3'd5;
parameter N_TYPE = 3'd7;

/*
OPDCODES
*/
localparam LOAD = 		7'b0000011;
localparam LOAD_FP = 	7'b0000111;
localparam CUSTM_0 = 	7'b0001011;
localparam MISC_MEM = 	7'b0001111;
localparam OP_IMM = 	7'b0010011;
localparam AUIPC = 		7'b0010111;
localparam OP_IMM_32 = 	7'b0011011;
localparam STORE = 		7'b0100011;
localparam STORE_FP = 	7'b0100111;
localparam CUSTM_1 = 	7'b0101011;
localparam AMO = 		7'b0101111;
localparam OP = 		7'b0110011;
localparam LUI = 		7'b0110111;
localparam OP_32 = 		7'b0111011;
localparam MADD = 		7'b1000011;
localparam MSUB = 		7'b1000111;
localparam NMSUB = 		7'b1001011;
localparam NMADD = 		7'b1001111;
localparam OP_FP = 		7'b1010011;
localparam RESERV_1 = 	7'b1010111;
localparam CUSTM_2 = 	7'b1011011;
localparam BRANCH = 	7'b1100011;
localparam JALR = 		7'b1100111;
localparam RESERV_2 = 	7'b1101011;
localparam JAL = 		7'b1101111;
localparam SYSTEM = 	7'b1110011;
localparam RESERV_3 = 	7'b1110111;
localparam CUSTM_3 = 	7'b1111011;


always @(opcode, funct3) begin
	case (opcode)
		LOAD: begin
			instr_type = I_TYPE;
			save_to_reg = 1'b0;
			rs1_used = 1'b1;
			rs2_used = 1'b0;
			immediate_used = 1'b1;
			is_branch = 1'b0;
			rd_memory = 1'b1;
			wr_memory = 1'b0;	
			shamt_used = 1'b0;
			inc_pc = 1'b0;
		end

		MISC_MEM: begin
			instr_type = I_TYPE;
			save_to_reg = 1'b0;
			rs1_used = 1'b0;
			rs2_used = 1'b0;
			immediate_used = 1'b0;
			is_branch = 1'b0;
			rd_memory = 1'b0;
			wr_memory = 1'b0;	
			shamt_used = 1'b0;
			inc_pc = 1'b0;
		end

		OP_IMM: begin
			if ((funct3 == 3'b001) || (funct3 == 3'b101) ) 
			begin
				instr_type = R_TYPE;
				immediate_used = 1'b0;
				shamt_used = 1'b1;
			end
			else
			begin
				instr_type = I_TYPE;
				immediate_used = 1'b1;
				shamt_used = 1'b0;

			end
			save_to_reg = 1'b1;
			rs1_used = 1'b1;
			rs2_used = 1'b0;
			is_branch = 1'b0;
			rd_memory = 1'b0;
			wr_memory = 1'b0;
			inc_pc = 1'b0;

		end

		AUIPC: begin
			instr_type = U_TYPE;
			save_to_reg = 1'b1;
			rs1_used = 1'b0;
			rs2_used = 1'b0;
			immediate_used = 1'b1;
			is_branch = 1'b0;
			rd_memory = 1'b0;
			wr_memory = 1'b0;	
			shamt_used = 1'b0;
			inc_pc = 1'b0;
		end

		STORE: begin
			instr_type = S_TYPE;
			save_to_reg = 1'b0;
			rs1_used = 1'b1;
			rs2_used = 1'b1;
			immediate_used = 1'b1;
			is_branch = 1'b0;
			rd_memory = 1'b0;
			wr_memory = 1'b1;	
			shamt_used = 1'b0;
			inc_pc = 1'b0;
		end

		OP: begin
			instr_type = R_TYPE;
			save_to_reg = 1'b1;
			rs1_used = 1'b1;
			rs2_used = 1'b1;
			immediate_used = 1'b0;
			is_branch = 1'b0;
			rd_memory = 1'b0;
			wr_memory = 1'b0;	
			shamt_used = 1'b0;
			inc_pc = 1'b0;
		
		end

		LUI: begin
			instr_type = U_TYPE;
			save_to_reg = 1'b1;
			rs1_used = 1'b0;
			rs2_used = 1'b0;
			immediate_used = 1'b1;
			is_branch = 1'b0;
			rd_memory = 1'b0;
			wr_memory = 1'b0;	
			shamt_used = 1'b0;
			inc_pc = 1'b0;
		end

		BRANCH: begin
			instr_type = B_TYPE;
			save_to_reg = 1'b0;
			rs1_used = 1'b1;
			rs2_used = 1'b1;
			immediate_used = 1'b1;
			is_branch = 1'b1;
			rd_memory = 1'b0;
			wr_memory = 1'b0;
			shamt_used = 1'b0;
			inc_pc = 1'b0;
		end

		JALR: begin
			instr_type = I_TYPE;
			save_to_reg = 1'b1;
			rs1_used = 1'b1;
			rs2_used = 1'b0;
			immediate_used = 1'b1;
			is_branch = 1'b1;
			rd_memory = 1'b0;
			wr_memory = 1'b0;
			shamt_used = 1'b0;
			inc_pc = 1'b1;

		end

		JAL: begin
			instr_type = J_TYPE;
			save_to_reg = 1'b1;
			rs1_used = 1'b0;
			rs2_used = 1'b0;
			immediate_used = 1'b1;
			is_branch = 1'b1;
			rd_memory = 1'b0;
			wr_memory = 1'b0;	
			shamt_used = 1'b0;
			inc_pc = 1'b1;

		end

		default: begin
			instr_type = N_TYPE;
			save_to_reg = 1'b0;
			rs1_used = 1'b0;
			rs2_used = 1'b0;
			immediate_used = 1'b0;
			is_branch = 1'b0;
			rd_memory = 1'b0;
			wr_memory = 1'b0;
			shamt_used = 1'b0;
			inc_pc = 1'b0;

		end
	endcase
end

endmodule