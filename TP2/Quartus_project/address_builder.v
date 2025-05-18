module  address_builder(
	input wire [31:0] imm,
	input wire  [31:0] pc,
	input wire [31:0] rs1,
	input wire [2:0] instr_type,
	
	
	output reg [31:0] pc_target,
	output reg [1:0] flag_branch


);



parameter R_TYPE = 3'd0;
parameter I_TYPE = 3'd1;
parameter S_TYPE = 3'd2;
parameter B_TYPE = 3'd3;
parameter U_TYPE = 3'd4;
parameter J_TYPE = 3'd5;

always @(imm, pc, instr_type, rs1)
begin
	case (instr_type)
		J_TYPE: begin
		
			pc_target = pc + imm;
			flag_branch = 2'b01;
		end
		I_TYPE:begin
		
			pc_target = rs1 + imm;
			flag_branch = 2'b10;
			
		end
		B_TYPE: begin
		
			pc_target = pc + imm;	
			flag_branch = 2'b11;
			
		end
		default: begin
		
			pc_target = 32'd0;
			flag_branch = 2'b00;
			
		end 
	endcase
end


endmodule
