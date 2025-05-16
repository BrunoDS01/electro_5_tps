module fetch_unit (         
	input wire [31:0] instr_in,
	
	input wire [31:0] prev_pc,						//pc anterior en caso de que hayamos saltado y no tendríamos que haberlo hecho
	
	input wire [31:0] pc_real_target,			//es el que viene de address builder, lo tomamos si flag_real_branch está en 1 
	input wire flag_real_branch,					//flag para tomar el salto, de mayor prioridad. es el salto verdadero que viene de address builder
	
	input wire 	prev_branch_prediction,			//es el flag de predicción propagado por el pipeline

	
	input wire [31:0] pc_target_prediction,  	//es el que viene del predictor, lo tomamos  si branch prediction es 1
	input wire branch_prediction,					//es el que viene directo del predictor
	
	
	input wire stage_clk,
	input wire reset,	
	input wire stage_ena,          
	input wire stage_x,   	


	output reg [31:0] instr,
	output reg [31:0] pc_next,
	output reg [31:0] pc,
	output reg flush_pipeline
);



always @(posedge stage_clk or posedge reset) begin
	if (reset) begin
		pc <= 32'd0;
		instr <= 32'd0;
	end
	else begin
		pc <= pc_next;
		instr <= instr_in;
	end
end

always @(pc, flag_real_branch, prev_branch_prediction) begin

	//La predicción fue correcta, sigue pipeline normal (leemos el predictor de saltos acutal y tomamos decisión)
	if (flag_real_branch == prev_branch_prediction)  
	begin
		flush_pipeline = 1'b0;
		
		// El predictor dijo que se tiene que saltar
		if (branch_prediction == 1'b1)
		begin
			pc_next = pc_target_prediction;	
		end
		
		//El predictor dijo que no se tiene que saltar
		else 
		begin 
			pc_next = pc + 32'd4;
		end 
			
	end
	// La predicción fue errónea 
	else
	begin
	
		flush_pipeline = 1'b1;
		
		//No se tomó el salto cuando se tendría que haber tomado. Hay que saltar ahora al target de address builder
		if (flag_real_branch == 1'b1) 
		begin
			pc_next = pc_real_target;
		end 
		
		//Se tomó el salto cuando no se tendría que haber tomado. Hay que volver al pc anterior + 4 antes del salto 
		else 
		begin
			pc_next = prev_pc + 32'd4;
		end 
		
	end 
		
end


endmodule