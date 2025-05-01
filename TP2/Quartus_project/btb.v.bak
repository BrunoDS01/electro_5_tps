/* BTb (Branch Table Buffer) */

module btb #(
    parameter ADDR_WIDTH = 6,  // Ancho de la dirección (64 direcciones)
    parameter PC_BITS = 11,    // Ancho del PC (11 bits) (12..2)
	parameter TAG_BITS = PC_BITS - ADDR_WIDTH;
)(         
    input wire [ADDR_WIDTH-1:0] address_rd,
	input wire [TAG_BITS-1:0] tag,
	input wire wr_enable,
	input wire [ADDR_WIDTH-1:0] address_wr,
	input wire counter_update,
	input wire clk,
    output reg pc_prediction [PC_BITS-1]
);


// Creo dos tablas con ADDR_WIDTH entradas
// Tabla con PCs
reg[PC_BITS-1:0] btb_pcs [0:2**(ADDR_WIDTH)-1];
// Tabla con TAGs
reg[TAG_BITS-1:0] btb_tags [0:2**(ADDR_WIDTH)-1];

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
	if 
	taken_prediction = bht_table[address_rd][COUNTER_BITS-1];
end

endmodule