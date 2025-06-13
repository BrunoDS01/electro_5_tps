module operand_build(
	input wire [31:0] rs1_data,
	input wire [31:0] rs2_data,
	
	input wire [31:0] pc,
	input wire [31:0] imm,
	
	input wire [3:0] instr_type,
	
	input wire [4:0] rs2,
	input wire shamt_used,
	input wire inc_pc,
	
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
	imm,
	rs2,
	shamt_used,
	inc_pc
)
begin
	case (instr_type)
		R_TYPE: begin // ADD SUB
			if (shamt_used) begin
				a = rs1_data;
				b = rs2; // rs2 se usa como shamt
			end
			else begin
				a = rs1_data;
				b = rs2_data;
			end
		end
		I_TYPE: begin //ADDI, LW, JALR
			if (inc_pc) begin
				// Si es JALR, debe sumar 4 al pc
				a = pc;
				b = 4;
			end
			else begin
				b = imm;
				a = rs1_data;
			end
		
		end
		S_TYPE: begin // //SW
			a = rs1_data;
			b = imm;
		end
		B_TYPE: begin //BEQ BNE
			a = rs1_data;
			b = rs2_data;
		end
		U_TYPE: begin //LUI AUIPC
			a = imm;
			b = 32'd0;
		end
		J_TYPE: begin //JAL
			a = pc;
			b = 4;
		end
		default: begin
			a = 32'd0;
			b = 32'd0;
		end
	endcase
end


endmodule