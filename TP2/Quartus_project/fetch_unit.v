module fetch_unit (         
	input wire [31:0] instr_in,
	
	// PC para reemplazar al existente en caso de salto o error de predicción
	input wire [31:0] pc_new,	
	// Indicador de tener que reemplazar pc
	input wire take_new_pc,			
	
	input wire stage_clk,
	input wire reset,	
	input wire stage_ena,          
	input wire stage_x,   	


	output reg [31:0] instr,
	output reg [31:0] pc_next,
	output reg [31:0] pc,
	output reg [31:0] pc_dec
);



always @(posedge stage_clk or posedge reset) begin
	if (reset) begin
		pc <= -4;
		pc_dec <= 0;
		instr <= 32'd0;
	end
	else begin
		if (stage_x) begin
			pc <= 32'd0;
			pc_dec <= 32'd0;
			instr <= 32'd0;
		end else if (stage_ena) begin
			pc <= pc_next;
			pc_dec <= pc;
			instr <= instr_in;
		end
	end
end

always @(take_new_pc, pc_new, pc, stage_ena) begin
	if (!stage_ena) begin
		// Si stage está inhabilitado, PC next no debe incrementarse,
		// Para mantener la lectura de la instrucción
		pc_next = pc;
	end
	else if (take_new_pc) begin
		// Si hay que tomar el salto
		pc_next = pc_new;
	end
	else begin
		// Si no hay que tomar el salto
		pc_next = pc + 32'd4;
	end
end


endmodule