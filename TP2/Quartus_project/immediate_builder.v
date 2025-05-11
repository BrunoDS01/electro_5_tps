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

always @(instr_type) begin
	case (instr_type)
		R_TYPE: begin
			imm = 32'd0;		
		end
		default: begin
			imm = 32'd0;
		end
	endcase
end


endmodule