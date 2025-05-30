module immediate_builder(
	input wire [31:0] instr,
	input wire [2:0] instr_type,

	output reg [31:0] imm
);

parameter R_TYPE = 3'd0;
parameter I_TYPE = 3'd1;
parameter S_TYPE = 3'd2;
parameter B_TYPE = 3'd3;
parameter U_TYPE = 3'd4;
parameter J_TYPE = 3'd5;
parameter N_TYPE = 3'd7;

always @(instr_type, instr) begin
	case (instr_type)
		R_TYPE: begin
			imm = 32'd0;		
		end

		I_TYPE: begin
			imm[11:0] = instr[31:20];
			imm[31:12] = {20{instr[31]}};
		end

		S_TYPE: begin
			imm[11:5] = instr[31:25];
			imm[4:0] = instr[11:7];
			imm[31:12] = {20{instr[31]}};
		end

		B_TYPE: begin
			imm[12] = instr[31];
			imm[10:5] = instr[30:25];
			imm[4:1] = instr[11:8];
			imm[11] = instr[7];
			imm[31:13] = {19{instr[31]}};
			imm[0] = 0;
		end

		U_TYPE: begin
			imm[31:12] = instr[31:12];
			imm[11:0] = 12'd0;
		end

		J_TYPE: begin
			imm[20] = instr[31];
			imm[10:1] = instr[30:21];
			imm[11] =  instr[20];
			imm[19:12] = instr[19:12];
			imm[0] = 0;
			imm[31:21] = {11{instr[31]}};
		end
		default: begin
			imm = 32'd0;
		end
	endcase
end


endmodule