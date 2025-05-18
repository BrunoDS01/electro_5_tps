module opcode_decode(
	input wire [6:0] opcode,
	
	output reg [2:0] instr_type,
	output reg save_to_reg,
	output reg rs1_used,
	output reg rs2_used,
	output reg immediate_used,
	output reg is_branch,
	output reg rd_memory,
	output reg wr_memory
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

/*
OPDCODES
*/
localparam JAL = 7'b1101111;
localparam OP = 7'b0110011;
localparam LOAD = 7'b0000011;
localparam STORE = 7'b0100011;

always @(opcode) begin
	case (opcode)
		OP: begin
			// R-Type
			instr_type = R_TYPE;
			save_to_reg = 1'b0;
			rs1_used = 1'b1;
			rs2_used = 1'b1;
			immediate_used = 1'b0;
			is_branch = 1'b0;
			rd_memory = 1'b0;
			wr_memory = 1'b0;		
		
		end
		JAL: begin
			instr_type = J_TYPE;
			save_to_reg = 1'b0;
			rs1_used = 1'b0;
			rs2_used = 1'b0;
			immediate_used = 1'b1;
			is_branch = 1'b1;
			rd_memory = 1'b0;
			wr_memory = 1'b0;	
		end
		default: begin
			instr_type = R_TYPE;
			save_to_reg = 1'b0;
			rs1_used = 1'b0;
			rs2_used = 1'b0;
			immediate_used = 1'b0;
			is_branch = 1'b0;
			rd_memory = 1'b0;
			wr_memory = 1'b0;
		end
	endcase
end

endmodule