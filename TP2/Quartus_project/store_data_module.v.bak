module store_data_module(
	input wire [2:0] funct3_,
	input wire [31:0] address_target,

	output reg [3:0] byte_ena
);

/*
	FUNCT3_table
*/

localparam SB = 3'b000;
localparam SH = 3'b001;
localparam SW = 3'b010;

always @(funct3_, address_target) begin
	if (funct3_ == SB) begin
		case (address_target[1:0])
			2'b00: byte_ena = 4'b1000;
			2'b01: byte_ena = 4'b0100;
			2'b10: byte_ena = 4'b0010;
			2'b11: byte_ena = 4'b0001;
			default: byte_ena = 4'b0000;
		endcase
	end
	else if (funct3_ == SH) begin
		case (address_target[1])
			1'b0: byte_ena = 4'b1100;
			2'b1: byte_ena = 4'b0011;
			default: byte_ena = 4'b0000;
		endcase
	end
	else if (funct3_ == SW) begin
		byte_ena = 4'b1111;
	end
	else begin
		byte_ena = 4'b0000;
	end

end

endmodule