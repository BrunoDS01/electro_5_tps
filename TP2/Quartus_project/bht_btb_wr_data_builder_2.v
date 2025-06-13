module bht_btb_wr_data_builder_2(
	input wire [31:0] wr_pc_target_update,
	input wire [5:0] wr_address_in,
	input wire [23:0] wr_tag,
	
	input wire is_branch,
	input wire [1:0] prev_counter,
	input wire prev_valid,
	input wire increment_counter,
	input wire clk,
	input wire reset,
	
	output wire [63:0] wr_data,
	output reg wr_enable,
	output reg [5:0] wr_address
);

reg state, next_state;

// Para mantener el address, el tag y si hay que aumentar o disminuir el contador
// Para luego de haber leido, para poder escribir
reg [5:0] wr_address_in_reg;
reg [23:0] wr_tag_reg;
reg increment_counter_reg;
reg [31:0] wr_pc_target_update_reg;

reg [1:0] wr_counter;
reg wr_valid_bit;


always @(posedge clk or posedge reset) begin
	if (reset) begin
		state <= 0;
		wr_address_in_reg <= 0;
		wr_tag_reg <= 0;
		increment_counter_reg <= 0;
		wr_pc_target_update_reg <= 0;
	end
	else begin
		state <= next_state;
		wr_address_in_reg <= wr_address;
		wr_tag_reg <= wr_tag;
		increment_counter_reg <= increment_counter;
		wr_pc_target_update_reg <= wr_pc_target_update;
	end
end

/*
	Lógica de actualización del contador y wr_enable.
	
	(Si una vez es valid una dirección, lo será por siempre)
*/
always @(
	state,
	is_branch,
	prev_counter,
	prev_valid,
	increment_counter_reg,
	wr_address_in,
	wr_address_in_reg
) 
begin
	case (state)
	1'b0: begin
		// Estado 0: hay que leer lo que estaba en la RAM y no escribir (si es un salto)
		if (is_branch) begin
			// Si es un salto, hay que pasar al siguiente estado para leer lo de la RAM 
			next_state = 1'b1;
		end
		else begin
			next_state = 1'b0;
		end
		wr_address = wr_address_in;
		wr_enable = 1'b0;
		wr_valid_bit = 1'b0;
		wr_counter = 0;
	end
	
	1'b1: begin
		next_state = 1'b0;
		// Estado 1: hay que interpretar lo que se escribe en la RAM, a partir del estado anterior
		wr_enable = 1'b1;
		wr_valid_bit = 1'b1; // Si entró acá, es porque es un salto válido para predecir
		wr_address = wr_address_in_reg;
		if (increment_counter_reg == 1'b0 && prev_counter != 2'b00) begin
			wr_counter = prev_counter - 2'b01;
		end
		else if (increment_counter_reg == 1'b1 && prev_counter != 2'b11) begin
			wr_counter = prev_counter + 2'b01;
		end
		else begin
			wr_counter = prev_counter;
		end
	end
	endcase
end

/*
	Asignación de elemento a guardar en memoria:
		[31:0] = PC_TARGET_PREDICTION
		[55:32] = TAG (32bits - 5bits -2LSB del PC que son 0)
		[56] = valid (es un salto)
		[58:57] = 2 bits del contador de historial
*/

assign wr_data[31:0] = wr_pc_target_update_reg; // Se escribe el PC target del ciclo anterior a la lectura
assign wr_data[55:32] = wr_tag_reg; // Se escribe el valor que llegó en el ciclo anterior a la lectura
assign wr_data[56] = wr_valid_bit;
assign wr_data[58:57] = wr_counter;
assign wr_data[63:59] = 5'b00000;


endmodule