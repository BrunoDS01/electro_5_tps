module  address_builder(
	input wire [31:0] imm,
	input wire  [31:0] pc,
	input wire [31:0] rs1,
	input wire [2:0] instr_type,
	input wire is_branch,
	
	output reg [31:0] address_target,
	output reg [1:0] flag_branch
);

parameter R_TYPE = 3'd0;
parameter I_TYPE = 3'd1;
parameter S_TYPE = 3'd2;
parameter B_TYPE = 3'd3;
parameter U_TYPE = 3'd4;
parameter J_TYPE = 3'd5;

always @(imm, pc, instr_type, rs1, is_branch)
begin
	case (instr_type)
		J_TYPE: begin
			address_target = pc + imm;
			flag_branch = 2'b01;
		end
		I_TYPE: begin
			address_target = rs1 + imm;
			// Si es un salto que se arma con el inmediato:
			if (is_branch) begin
				flag_branch = 2'b10;
				address_target = (rs1 + imm) & ~32'd1; // esto es especificación para JALR
			end
			else begin
				// Si no es un salto
				flag_branch = 2'b00;
				address_target = rs1 + imm;
			end
		end
		B_TYPE: begin
			address_target = pc + imm;	
			flag_branch = 2'b11;
		end
		S_TYPE: begin
			address_target = rs1 + imm;	
			flag_branch = 2'b00;
		end
		default: begin
			address_target = 32'd0;
			flag_branch = 2'b00;
		end 
	endcase
end


endmodule
