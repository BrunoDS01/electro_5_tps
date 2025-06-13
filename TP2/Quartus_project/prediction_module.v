module prediction_module(
	input wire rd_valid,
	input wire [23:0] rd_tag,
	input wire [1:0] rd_counter,
	input wire [23:0] tag,
	
	output reg branch_prediction
);

/*
	Lógica de la predicción:
*/
always @(rd_valid, rd_tag, tag, rd_counter) begin
	// Si es un salto, el TAG coincide y el contador es mayor a la mitad (10 o 11):
	if (rd_valid == 1'b1 && rd_tag == tag && rd_counter[1] == 1'b1) begin
		branch_prediction = 1'b1;
	end
	else begin
		branch_prediction = 1'b0;		
	end
end


endmodule