module next_pc_decision_module(

	// pc anterior en caso de que hayamos saltado y no tendríamos que haberlo hecho
	input wire [31:0] prev_pc,
	
	// Es el que viene de address builder, lo tomamos si flag_real_branch está en 1 
	input wire [31:0] pc_add_build_target,
	
	// Flag de que se debería tomar el salto (sin saber a priori la salida del predictor)
	input wire branch_result,				
	
	// Es el flag de predicción propagado por el pipeline
	// 1: se saltó; 0: no se saltó
	input wire prev_branch_prediction,			

	// Es el que viene del predictor, lo tomamos  si branch prediction es 1
	input wire [31:0] pc_target_prediction_actual,
	// Es el que viene directo del predictor
	input wire branch_prediction_actual,	
	
	output reg [31:0] pc_new,
	output reg take_new_pc,
	output reg flush_pipeline

);

always @(
	prev_branch_prediction,
	branch_result,
	pc_target_prediction_actual,
	pc_add_build_target,
	prev_pc	
)begin

	// La predicción fue correcta, sigue pipeline normal (leemos el predictor de saltos actual y tomamos decisión)
	if (prev_branch_prediction == branch_result)  
	begin
		flush_pipeline = 1'b0;
		
		// El predictor dijo que se tiene que saltar
		if (branch_prediction_actual == 1'b1)
		begin
			pc_new = pc_target_prediction_actual;
			take_new_pc = 1'b1;
		end
		
		//El predictor dijo que no se tiene que saltar
		else 
		begin 
			pc_new = 32'd0;
			take_new_pc = 1'b0;
		end 
			
	end
	// La predicción fue errónea
	else
	begin
	
		flush_pipeline = 1'b1;
		
		// No se tomó el salto cuando se tendría que haber tomado. Hay que saltar ahora al target de address builder
		if (branch_result == 1'b1) 
		begin
			pc_new = pc_add_build_target;
			take_new_pc = 1'b1;
		end 
		
		// Se tomó el salto cuando no se tendría que haber tomado. Hay que volver al pc anterior + 4 antes del salto 
		else 
		begin
			pc_new = prev_pc + 32'd4;
			take_new_pc = 1'b1;
		end 
		
	end 
		
end

endmodule