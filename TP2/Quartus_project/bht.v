/* BHT (Branch History Table) */

module bht #(
    parameter ADDR_WIDTH = 6,  // Ancho de la dirección (64 direcciones)
    parameter COUNTER_BITS = 2   // Ancho del contador (2 bits = 4 opciones)
)(         
    input wire [ADDR_WIDTH-1:0] address_rd,
	input wire wr_enable,
	input wire [ADDR_WIDTH-1:0] address_wr,
	input wire counter_update,
	input wire clk,
    output reg taken_prediction
);

// Creo una tabla con ADDR_WIDTH entradas, cada una de COUNTER_BITS bits
reg[COUNTER_BITS-1:0] bht_table [0:2**(ADDR_WIDTH)-1];

// Inicializo en 0 la tabla
integer i;
initial begin
    for (i = 0; i < 2**ADDR_WIDTH; i = i + 1) begin
        bht_table[i] = 0;
    end
end

// Actualización de la tabla (a definir)
always @(posedge clk) begin
	if (wr_enable) begin
		if(counter_update == 1'b0 && bht_table[address_wr] != 2'b00) begin
			bht_table[address_wr] <= bht_table[address_wr] - 2'b01;
		end
		else if (counter_update == 1'b1 && bht_table[address_wr] != 2'b11) begin
			bht_table[address_wr] <= bht_table[address_wr] + 2'b01;
		end
	end
end

// Lectura de la tabla
always @(address_rd) begin
	taken_prediction = bht_table[address_rd][COUNTER_BITS-1];
end

endmodule