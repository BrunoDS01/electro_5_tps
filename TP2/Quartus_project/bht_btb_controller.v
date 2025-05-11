///* BHT and BTB Controller (Branch History Table AND Branch Table Buffer) 
//
//Ambas tablas se acceden de la misma manera, por lo que se unen en un
//mismo módulo RAM (64 filas y 32 bits por fila).
//
//Se accede por PC_FETCH y la salida es su PC_TARGET asociado.
//
//*/
//
//module bht_btb_controller #(
//	parameter COUNTER_BITS = 2,
//    parameter ADDR_WIDTH = 6,  // Ancho de la dirección (64 direcciones)
//    parameter PC_BITS = 11    // Ancho del PC (11 bits) (12..2)
//)(
//	// pc_fetch: PC a leer
//	input wire [31:0] pc_fetch,
//	
//	input wire [31:0] bht_btb_ram_output1_,
//	
//	// pc_fetch_update: PC a modificar su PC TARGET asociado.
//	input wire [31:0] pc_fetch_update,
//	// pc_target_update: PC TARGET a guardar.
//	input wire [31:0] pc_target_update,
//	
//	input wire is_branch,
//	input wire [COUNTER_BITS-1:0] prev_counter,
//	
//	output wire [ADDR_WIDTH-1:0] rd_address,
//	
//	output reg [ADDR_WIDTH-1:0] wr_address,
//	output wire wr_enable,
//	output wire [31:0] wr_data,
//	
//	// pc_target_prediction: PC TARGET leído.
//	output wire [31:0] pc_target_prediction,
//	output reg [COUNTER_BITS-1:0] rd_counter,
//	output reg branch_prediction
//);
//
//localparam TAG_BITS = PC_BITS - ADDR_WIDTH;
//
///*
//	Lectura de la RAM:
//		Para la lectura de la RAM, es necesario desglozar el contenido de su salida.
//		Luego, tomar la decisión de si se debe realizar la predicción o no.
//		
//		[10:0] = PC_TARGET_PREDICTION
//		[15:11] = TAG
//		[16] = valid (es un salto)
//		[18:17] = 2 bits del contador de historial
//*/
//
//// Asignaciones correspondientes al PC_FETCH
//assign rd_address = pc_fetch[ADDR_WIDTH-1:0];
//wire [TAG_BITS-1:0] tag = pc_fetch[TAG_BITS-1+ADDR_WIDTH:ADDR_WIDTH];
//
//// Asignación de lectura de la RAM a los campos correspondientes
//wire [PC_BITS-1:0] rd_pc_target_prediction = bht_btb_ram_output1_[PC_BITS-1:0];
//wire [TAG_BITS-1:0] rd_tag = bht_btb_ram_output1_[TAG_BITS-1 + PC_BITS : PC_BITS];
//wire rd_valid = bht_btb_ram_output1_[TAG_BITS + PC_BITS];
//wire [COUNTER_BITS-1:0] rd_counter = bht_btb_ram_output1_[COUNTER_BITS-1 + TAG_BITS + PC_BITS + 1 : TAG_BITS + PC_BITS + 1];
//
//// Salida de la lectura
//assign pc_target_prediction = {{(31-PC_BITS){1'b0}}, rd_pc_target_prediction};
//
//always @(rd_valid, rd_tag, tag, rd_counter) begin
//	// Si es un salto, el TAG coincide y el contador es mayor a la mitad (10 o 11):
//	if (rd_valid == 1'b1 && rd_tag == tag && rd_counter[COUNTER_BITS-1] == 1'b1) begin
//		branch_prediction = 1'b1;
//	end
//	else begin
//		branch_prediction = 1'b0;		
//	end
//end
//
//
///*
//	Escritura de la RAM:
//		
//		[10:0] = PC_TARGET_PREDICTION
//		[15:11] = TAG
//		[16] = valid (es un salto)
//		[18:17] = 2 bits del contador de historial
//*/
//
//// Asignaciones correspondientes al PC_FETCH_UPDATE
//wire [ADDR_WIDTH-1:0] address2_in = pc_fetch_update[ADDR_WIDTH-1:0];
//wire [TAG_BITS-1:0] wr_tag = pc_fetch_update[TAG_BITS-1+ADDR_WIDTH:ADDR_WIDTH];
//
//
//always @(wr_estado,
//	is_branch,
//	wr_counter,
//	increment_counter_prev,
//	wr_tag_prev,
//	address2_in,
//	address2_prev,
//	pc_target_update_prev
//)
//begin
//	if (is_branch) begin
//		address2_ = address2_prev;
//		wr_enable2_ = 1'b1;
//		next_wr_estado = 1'b0;
//		
//		if (increment_counter_prev == 1'b0 && wr_counter != 2'b00) begin
//			// counter, valid, tag, PC_TARGET_PREDICTION
//			wr_data2_ = {wr_counter-1, 1'b1, wr_tag_prev, pc_target_update_prev};
//		end
//		else if (increment_counter_prev == 1'b1 && wr_counter != 2'b11) begin
//			wr_data2_ = {wr_counter+1, 1'b1, wr_tag_prev, pc_target_update_prev};
//		end
//		else begin
//			wr_data2_ = {wr_counter, 1'b1, wr_tag_prev, pc_target_update_prev};
//		end
//	end
//	else begin
//	
//	
//	end
//		
//end
//
//endmodule


