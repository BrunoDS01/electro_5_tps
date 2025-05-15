module bht_btb_wr_data_builder(
	input wire [10:0] wr_pc_target_update,
	input wire [4:0] wr_tag,
	
	input wire is_branch,
	input wire [1:0] prev_counter,
	input wire prev_valid,
	input wire increment_counter,
	
	output wire [31:0] wr_data,
	output reg wr_enable
);

reg [1:0] wr_counter;
reg wr_valid_bit;

/*
	Lógica de actualización del contador y wr_enable.
	
	(Si una vez es valid una dirección, lo será por siempre)
*/
always @(is_branch, prev_counter, prev_valid, increment_counter) begin
	if (is_branch) begin
		wr_enable = 1'b1;
		wr_valid_bit = 1'b1;
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
		wr_valid_bit = prev_valid;	
	end	
end

/*
	Asignación de elemento a guardar en memoria:
		[10:0] = PC_TARGET_PREDICTION
		[15:11] = TAG
		[16] = valid (es un salto)
		[18:17] = 2 bits del contador de historial
*/

assign wr_data[10:0] = wr_pc_target_update;
assign wr_data[15:11] = wr_tag;
assign wr_data[16] = wr_valid_bit;
assign wr_data[18:17] = wr_counter;
assign wr_data[31:19] = 13'd0;


endmodule