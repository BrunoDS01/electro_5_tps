module operand_build(
	input wire [31:0] rs1_data,
	input wire [31:0] rs2_data,
	
	input wire [31:0] pc,
	input wire [31:0] imm,
	
	input wire [3:0] instr_type,
	
	output reg [31:0] a,
	output reg [31:0] b

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

always @(
	instr_type,
	rs1_data,
	rs2_data,
	pc,
	imm
)
begin
	case (instr_type)
		R_TYPE: begin
			a = rs1_data;
			b = rs2_data;
		end
		default: begin
			a = 32'd0;
			b = 32'd0;
		end
	endcase
end


endmodule