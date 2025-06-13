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
localparam SLL3 = 3'b001;
localparam SLT3 = 3'b010;
localparam SLTU3 = 3'b011;
localparam XOR3 = 3'b100;
localparam SHIFT3 = 3'b101;
localparam OR3 = 3'b110;
localparam AND3 = 3'b111;
localparam LW3 = 3'b010; // Funct3 para LW
localparam LH3 = 3'b001; // Funct3 para LH/LHU
localparam LB3 = 3'b000; // Funct3 para LB/LBU

/*
	FUNCT7_table
*/
localparam ADD7 = 7'b0000000;
localparam SUB7 = 7'b0100000;
localparam SRL = 7'b0000000;
localparam SRA = 7'b0100000;

always @(a, b, funct3_, funct7_, instr_type) begin
	case (instr_type)
		// R_TYPE: Operaciones aritméticas y lógicas con rs1 y rs2
		R_TYPE: begin
			case (funct3_)
				ADD_SUB3: begin
					if (funct7_ == ADD7) begin
						c = a + b; // ADD
					end else if (funct7_ == SUB7) begin
						c = a - b; // SUB
					end else begin
						c = 32'd0;
					end
				end
				
				SLL3: begin
					c = a << b[4:0]; // SLL (Shift Left Logical)
				end
				
				SLT3: begin
					c = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // SLT (Signed Less Than)
				end
				
				SLTU3: begin
					c = (a < b) ? 32'd1 : 32'd0; // SLTU (Unsigned Less Than)
				end
				
				XOR3: begin
					c = a ^ b; // XOR
				end
				
				SHIFT3: begin
					if (funct7_ == SRL) begin
						c = a >> b[4:0]; // SRL (Shift Right Logical)
					end else if (funct7_ == SRA) begin
						c = $signed(a) >>> b[4:0]; // SRA (Shift Right Arithmetic)
					end else begin
						c = 0;
					end
				end
				
				OR3: begin
					c = a | b; // OR
				end
				
				AND3: begin
					c = a & b; // AND
				end
				
				default: begin
					c = 32'd0;
				end
			endcase
		end
		
		// I_TYPE: Operaciones inmediatas
		I_TYPE: begin
			case (funct3_)
				ADD_SUB3: begin
					c = a + b; // ADDI (o JALR, sumará PC con 4)
				end
				
				SLL3: begin
					c = a << b[4:0]; // SLLI
				end
				
				SLT3: begin
					c = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // SLTI
				end
				
				SLTU3: begin
					c = (a < b) ? 32'd1 : 32'd0; // SLTIU
				end
				
				XOR3: begin
					c = a ^ b; // XORI
				end
				
				SHIFT3: begin
					if (funct7_ == SRL) begin
						c = a >> b[4:0]; // SRLI
					end else if (funct7_ == SRA) begin
						c = $signed(a) >>> b[4:0]; // SRAI
					end else begin
						c = 0;
					end
				end
				
				OR3: begin
					c = a | b; // ORI
				end
				
				AND3: begin
					c = a & b; // ANDI
				end
				
				default: begin
					c = 32'd0;
				end
			endcase
		end
		
		// S_TYPE: Solo calcula la dirección efectiva
		S_TYPE: begin
			c = a + b; // Dirección de memoria
		end
		
		// B_TYPE: Comparaciones condicionales para Branch
		B_TYPE: begin
			case (funct3_)
				3'b000: c = (a == b) ? 32'd1 : 32'd0; // BEQ
				3'b001: c = (a != b) ? 32'd1 : 32'd0; // BNE
				3'b100: c = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // BLT
				3'b101: c = ($signed(a) >= $signed(b)) ? 32'd1 : 32'd0; // BGE
				3'b110: c = (a < b) ? 32'd1 : 32'd0; // BLTU
				3'b111: c = (a >= b) ? 32'd1 : 32'd0; // BGEU
				default: c = 32'd0;
			endcase
		end
		
		// U_TYPE: LUI y AUIPC
		U_TYPE: begin
			c = b; // LUI y AUIPC usan directamente el valor inmediato
		end
		
		// J_TYPE: JAL (manejo de direcciones)
		J_TYPE: begin
			c = a + b; // PC se le suma 4
		end
		
		// N_TYPE: NOP
		N_TYPE: begin
			c = 32'd0; // No hace nada
		end
		
		// Default: Operación desconocida
		default: begin
			c = 32'd0;
		end
	endcase
end


endmodule