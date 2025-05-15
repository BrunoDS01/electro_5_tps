/* BHT and BTB Controller (Branch History Table AND Branch Table Buffer) 

Ambas tablas se acceden de la misma manera, por lo que se unen en un
mismo módulo RAM (64 filas y 32 bits por fila).

Se accede por PC_FETCH y la salida es su PC_TARGET asociado.

*/

module bht_btb_controller #(
	parameter COUNTER_BITS = 2,
    parameter ADDR_WIDTH = 6,  // Ancho de la dirección (64 direcciones)
    parameter PC_BITS = 11    // Ancho del PC (11 bits) (12..2) No incluye los 2 LSB
)(
	// pc_fetch: PC a leer
	input wire [31:0] pc_fetch,
	
	input wire [31:0] bht_btb_ram_output,
	
	// pc_fetch_update: PC a modificar su PC TARGET asociado.
	input wire [31:0] pc_fetch_update,
	// pc_target_update: PC TARGET a guardar.
	input wire [31:0] pc_target_update,
	
	input wire is_branch,
	input wire [COUNTER_BITS-1:0] prev_counter,
	input wire prev_valid,
	input wire increment_counter,
	
	output wire [ADDR_WIDTH-1:0] rd_address,
	
	output wire [ADDR_WIDTH-1:0] wr_address,
	output reg wr_enable,
	output wire [31:0] wr_data,
	
	// pc_target_prediction: PC TARGET leído.
	output wire [31:0] pc_target_prediction,
	output wire [COUNTER_BITS-1:0] current_counter,
	output wire current_valid,
	output reg branch_prediction
);

localparam TAG_BITS = PC_BITS - ADDR_WIDTH;

// PC = [000000...00 | TAG | ADDRESS | 00]
//      |31        13|12  8|7       2|1 0|

/*
	Lectura de la RAM:
		Para la lectura de la RAM, es necesario desglozar el contenido de su salida.
		Luego, tomar la decisión de si se debe realizar la predicción o no.
		
		[10:0] = PC_TARGET_PREDICTION (de los 13 bits del PC, los 11 más significativos)
		[15:11] = TAG
		[16] = valid (es un salto)
		[18:17] = 2 bits del contador de historial
*/

// Asignaciones correspondientes al PC_FETCH

// Address de lectura del PC_FETCH (simil memoria Caché)
assign rd_address = pc_fetch[ADDR_WIDTH+1:2];

// Tag correspondiente al PC_FETCH
wire [TAG_BITS-1:0] tag = pc_fetch[TAG_BITS-1+ADDR_WIDTH+2:ADDR_WIDTH+2];

// Asignación de lectura de la RAM a los campos correspondientes
wire [PC_BITS-1:0] rd_pc_target_prediction = bht_btb_ram_output[PC_BITS-1:0];
wire [TAG_BITS-1:0] rd_tag = bht_btb_ram_output[TAG_BITS-1 + PC_BITS : PC_BITS];
wire rd_valid = bht_btb_ram_output[TAG_BITS + PC_BITS];
wire [COUNTER_BITS-1:0] rd_counter = bht_btb_ram_output[COUNTER_BITS-1 + TAG_BITS + PC_BITS + 1 : TAG_BITS + PC_BITS + 1];

// Salida de la lectura del módulo BHT_BTB_CONTROLLER
// (0000...00 rd_pc_target_prediction 00)
assign pc_target_prediction = {{(31-PC_BITS-2){1'b0}}, rd_pc_target_prediction, 2'b00};
assign current_counter = rd_counter; 
assign current_valid = rd_valid;

/*
	Lógica de la predicción:
*/
always @(rd_valid, rd_tag, tag, rd_counter) begin
	// Si es un salto, el TAG coincide y el contador es mayor a la mitad (10 o 11):
	if (rd_valid == 1'b1 && rd_tag == tag && rd_counter[COUNTER_BITS-1] == 1'b1) begin
		branch_prediction = 1'b1;
	end
	else begin
		branch_prediction = 1'b0;		
	end
end


/*
	Escritura de la RAM:
		
		[10:0] = PC_TARGET_PREDICTION
		[15:11] = TAG
		[16] = valid (es un salto)
		[18:17] = 2 bits del contador de historial
*/

// Asignaciones correspondientes al PC_FETCH_UPDATE
assign wr_address = pc_fetch_update[ADDR_WIDTH+1:2];

wire [TAG_BITS-1:0] wr_tag = pc_fetch_update[TAG_BITS-1+ADDR_WIDTH+2:ADDR_WIDTH+2];

reg [COUNTER_BITS-1:0] wr_counter;
reg valid_bit;

/*
	Lógica de actualización del contador
	
	(Si una vez es valid una dirección, lo será por siempre)
*/
always @(is_branch, prev_counter, prev_valid, increment_counter) begin
	if (is_branch) begin
		wr_enable = 1'b1;
		valid_bit = 1'b1;
		if (increment_counter == 1'b0 && prev_counter != 2'b00) begin
			wr_counter = prev_counter - 2'b01;
		end
		else if (increment_counter == 1'b1 && prev_counter != 2'b11) begin
			wr_counter = prev_counter + 2'b01;
		end
		else begin
			wr_counter = prev_counter;
		end
	end
	else begin
		wr_enable = 1'b0;
		wr_counter = prev_counter;
		valid_bit = prev_valid;	
	end	
end

// Asignación de elemento a guardar en memoria
assign wr_data = {{(31-(COUNTER_BITS + TAG_BITS + PC_BITS)){1'b0}}, wr_counter, valid_bit, wr_tag, pc_target_update[PC_BITS+1:2]};

endmodule


