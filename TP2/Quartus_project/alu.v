module alu(
	input wire [31:0] a,
	input wire [31:0] b,
	
	input wire [2:0] funct3_,
	input wire [6:0] funct7_,
	
	input wire [3:0] instr_type,
	
	
	output reg [31:0] c
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


// Completar las siguientes tablas con FUNCT3, y FUNCT7 (si se utiliza).

/*
	FUNCT3_table
*/

localparam ADD_SUB3 = 3'b000;
localparam ADDI3 = 3'b000;
localparam SHIFT3 = 3'b101;

/*
	FUNCT7_table
*/
localparam ADD7 = 7'b0000000;
localparam SUB7 = 7'b0100000;
localparam SRL = 7'b0000000;
localparam SRA = 7'b0100000;

always @(a, b, funct3_, funct7_, instr_type) begin
	case (instr_type)
		// R_TYPE corresponden a operaciones comunes que usan rs1 y rs2
		R_TYPE: begin
			case (funct3_)
			
				ADD_SUB3: begin
					if (funct7_ == ADD7) begin
						c = a + b;
					end
					else if (funct7_ == SUB7) begin
						c = a - b;
					end
					else begin
						c = 32'd0;
					end
				end
				
				SHIFT3: begin
					if (funct7_ == SRL) begin
						c = a >> b[4:0];
					end
					else if (funct7_ == SRA) begin
						c = a >>> b[4:0];
					end
					else begin
						c = 0;
					end
				end
				
				default: begin
					c = 0;
				end
			
			endcase
		end
		
		I_TYPE: begin
			case (funct3_)
				ADDI3: begin
					c = a + b;
				end
				
				default: begin
					c = 0;
				end
			endcase
		
		end
		
		default: begin
			c = 0;
		end
	endcase
end

endmodule