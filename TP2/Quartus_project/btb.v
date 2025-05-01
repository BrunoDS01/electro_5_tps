/* BTb (Branch Table Buffer) */

module btb #(
    parameter ADDR_WIDTH = 6,  // Ancho de la dirección (64 direcciones)
    parameter PC_BITS = 11    // Ancho del PC (11 bits) (12..2)
)(         
	input wire [PC_BITS-1:0] pc_fetch,
	
	input wire wr_enable,
	input wire [PC_BITS-1:0] new_pc_fetch,
	input wire [PC_BITS-1:0] new_pc_target,
	input wire clk,
	
    output reg [PC_BITS-1:0] pc_target_prediction,
	output reg hit
);

localparam TAG_BITS = PC_BITS - ADDR_WIDTH;

wire [ADDR_WIDTH-1:0] address_rd = pc_fetch[ADDR_WIDTH-1:0];
wire [TAG_BITS-1:0] tag = pc_fetch[ADDR_WIDTH+TAG_BITS-1:ADDR_WIDTH];

wire [ADDR_WIDTH-1:0] address_wr = new_pc_fetch[ADDR_WIDTH-1:0];
wire [TAG_BITS-1:0] new_tag = new_pc_fetch[ADDR_WIDTH+TAG_BITS-1:ADDR_WIDTH];


// Creo 3 tablas con ADDR_WIDTH entradas

// Tabla con PCs
reg[PC_BITS-1:0] btb_pc_target [0:2**(ADDR_WIDTH)-1];

// Tabla con TAGs
reg[TAG_BITS-1:0] btb_tags [0:2**(ADDR_WIDTH)-1];

// Tabla con los valids
reg btb_valid [0:2**(ADDR_WIDTH)-1];


// Inicializo en 0 la tabla
integer i;
initial begin
    for (i = 0; i < 2**ADDR_WIDTH; i = i + 1) begin
        btb_pc_target[i] = 0;
		btb_tags[i] = {TAG_BITS{1'b0}};
		btb_valid[i] = 0;
    end
end


// Actualización de la tabla (a definir)
always @(posedge clk) begin
	if (wr_enable) begin
		btb_pc_target[address_wr] <= new_pc_fetch;
		btb_tags[address_wr] <= new_tag;
		btb_valid[address_wr] <= 1'b1;
	end
end


// Lectura de la tabla
always @(address_rd, tag) begin

	// Chequeamos que el tag coincida
	if (btb_tags[address_rd] != tag || btb_valid[address_rd] == 1'b0) begin
		hit = 1'b0;
		pc_target_prediction = 0;
	end
	else begin
		hit = 1'b1;
		pc_target_prediction = btb_pc_target[address_rd];
	end
end

endmodule