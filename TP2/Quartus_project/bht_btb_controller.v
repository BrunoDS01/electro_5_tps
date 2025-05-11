/* BHT and BTB Controller (Branch History Table AND Branch Table Buffer) 

Ambas tablas se acceden de la misma manera, por lo que se unen en un
mismo módulo RAM (64 filas y 32 bits por fila).

Se accede por PC_FETCH y la salida es su PC_TARGET asociado.

*/

module bht_btb_controller #(
	parameter COUNTER_BITS = 2,
    parameter ADDR_WIDTH = 6,  // Ancho de la dirección (64 direcciones)
    parameter PC_BITS = 11    // Ancho del PC (11 bits) (12..2)
)(
	// pc_fetch: PC a leer
	input wire [31:0] pc_fetch,
	
	input wire [31:0] bht_btb_ram_output1_,
	
	input wire [31:0] bht_btb_ram_output2_,
	
	// pc_fetch_update: PC a modificar su PC TARGET asociado.
	input wire [31:0] pc_fetch_update,
	// pc_target_update: PC TARGET a guardar.
	input wire [31:0] pc_target_update,
	
	input wire is_branch,
	input wire increment_counter,
	
	input wire clk,
	input wire reset,
	
	output wire [ADDR_WIDTH-1:0] address1_,
	output wire wr_enable1_,
	output wire [31:0] wr_data1_,
	
	output reg [ADDR_WIDTH-1:0] address2_,
	output reg wr_enable2_,
	output reg [31:0] wr_data2_,
	
	// pc_target_prediction: PC TARGET leído.
	output wire [31:0] pc_target_prediction,
	output reg branch_prediction
);

localparam TAG_BITS = PC_BITS - ADDR_WIDTH;

/*
	Lectura de la RAM:
		Para la lectura de la RAM, es necesario desglozar el contenido de su salida.
		Luego, tomar la decisión de si se debe realizar la predicción o no.
		
		[10:0] = PC_TARGET_PREDICTION
		[15:11] = TAG
		[16] = valid (es un salto)
		[18:17] = 2 bits del contador de historial
*/

// Asignaciones correspondientes al PC_FETCH
assign address1_ = pc_fetch[ADDR_WIDTH-1:0];
assign wr_enable1_ = 1'b0; // No escribimos en el primer puerto
assign wr_data1_ = 32'b0; // Por default, mandamos todos 0's a la data del puerto 1 de la RAM.

wire [TAG_BITS-1:0] tag = pc_fetch[TAG_BITS-1+ADDR_WIDTH:ADDR_WIDTH];

// Asignación de lectura de la RAM a los campos correspondientes
wire [PC_BITS-1:0] rd_pc_target_prediction = bht_btb_ram_output1_[PC_BITS-1 : 0];
wire [TAG_BITS-1:0] rd_tag = bht_btb_ram_output1_[TAG_BITS-1 + PC_BITS : PC_BITS];
wire rd_valid = bht_btb_ram_output1_[TAG_BITS + PC_BITS];
wire [COUNTER_BITS-1:0] rd_counter = bht_btb_ram_output1_[COUNTER_BITS-1 + TAG_BITS + PC_BITS + 1 : TAG_BITS + PC_BITS + 1];

// Salida de la lectura
assign pc_target_prediction = {{(31-PC_BITS){1'b0}}, rd_pc_target_prediction};

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
		Para escribir la RAM, es necesario realizarlo en 2 etapas:
			1) Al recibir una señal de actualización, se deberá leer la RAM
			(El segundo puerto), para poder actualizar el valor del Counter
			
			2) Modificar los campos que se hayan que modificar y escribir la RAM.
		
		[10:0] = PC_TARGET_PREDICTION
		[15:11] = TAG
		[16] = valid (es un salto)
		[18:17] = 2 bits del contador de historial
*/

// Asignaciones correspondientes al PC_FETCH_UPDATE
wire [ADDR_WIDTH-1:0] address2_in = pc_fetch_update[ADDR_WIDTH-1:0];
wire [TAG_BITS-1:0] wr_tag = pc_fetch_update[TAG_BITS-1+ADDR_WIDTH:ADDR_WIDTH];

// Output de la RAM puerto 2
wire [COUNTER_BITS-1:0] wr_counter = bht_btb_ram_output2_[COUNTER_BITS-1 + TAG_BITS + PC_BITS + 1 : TAG_BITS + PC_BITS + 1];

reg wr_estado, next_wr_estado;
// Debemos almacenar el valor del rd_address2, para leer en el próximo ciclo
reg [ADDR_WIDTH-1:0] address2_prev;
reg [TAG_BITS-1:0] wr_tag_prev;
reg increment_counter_prev;
reg [PC_BITS-1:0] pc_target_update_prev;

// Actualización sincrónica del estado y el rd_address2
always @(posedge clk or posedge reset) begin
	if(reset) begin
		wr_estado <= 1'b0;
		address2_prev <= {(ADDR_WIDTH){1'b0}};
		increment_counter_prev <= 1'b0;
		wr_tag_prev <= {(TAG_BITS){1'b0}};
		pc_target_update_prev <= {(PC_BITS){1'b0}};
	end
	else begin
		wr_estado <= next_wr_estado;
		address2_prev <= address2_in;
		increment_counter_prev <= increment_counter;
		wr_tag_prev <= wr_tag;
		pc_target_update_prev <= pc_target_update[PC_BITS-1:0];
	end
end

//
always @(wr_estado,
	is_branch,
	wr_counter,
	increment_counter_prev,
	wr_tag_prev,
	address2_in,
	address2_prev,
	pc_target_update_prev
)
begin
	case (wr_estado)
		// Leer el valor al que apunta el PC_FETCH_UPDATE
		1'b0: begin
			wr_enable2_ = 1'b0; // No leemos
			wr_data2_ = 32'b0; // Por default (aunque no escribamos)
			address2_ = address2_in;
			if (is_branch) begin
				// Si es un branch, hay que leer y luego actualizar
				next_wr_estado = 1'b1;
			end
			else begin
				// Si no es un branch, seguimos en el mismo estado
				next_wr_estado = 1'b0;
			end
		end
		
		1'b1: begin
			// Actualizar el valor al que apunta PC_FETCH_UPDATE
			// (en el ciclo anterior)
			address2_ = address2_prev;
			wr_enable2_ = 1'b1;
			next_wr_estado = 1'b0;
			
			if (increment_counter_prev == 1'b0 && wr_counter != 2'b00) begin
				// counter, valid, tag, PC_TARGET_PREDICTION
				wr_data2_ = {wr_counter-1, 1'b1, wr_tag_prev, pc_target_update_prev};
			end
			else if (increment_counter_prev == 1'b1 && wr_counter != 2'b11) begin
				wr_data2_ = {wr_counter+1, 1'b1, wr_tag_prev, pc_target_update_prev};
			end
			else begin
				wr_data2_ = {wr_counter, 1'b1, wr_tag_prev, pc_target_update_prev};
			end
		end
		
		default: begin
			wr_enable2_ = 1'b0; // No leemos
			wr_data2_ = 32'b0; // Por default (aunque no escribamos)
			address2_ = address2_in;
			next_wr_estado = 1'b0;
		end
	endcase
end

endmodule


