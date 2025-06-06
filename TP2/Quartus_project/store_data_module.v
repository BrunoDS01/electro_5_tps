module store_data_module(
	input wire [2:0] funct3_,
	input wire [31:0] address_target,
	input wire [31:0] rs2_data,

	output reg [3:0] byte_ena,
	output reg [31:0] store_data
);

/*
	FUNCT3_table
*/

localparam SB = 3'b000;
localparam SH = 3'b001;
localparam SW = 3'b010;

always @(funct3_, address_target, rs2_data) begin
	if (funct3_ == SB) begin
		case (address_target[1:0])
			2'b00: begin
				byte_ena = 4'b1000;
				store_data [31:24] = rs2_data[7:0];
				store_data [23:0] = 24'd0;
			end
			2'b01: begin
				byte_ena = 4'b0100;
				store_data [23:16] = rs2_data[7:0];
				store_data [31:24] = 8'd0;
				store_data [15:0] = 16'd0;
			end
			2'b10: begin
				byte_ena = 4'b0010;
				store_data [15:8] = rs2_data[7:0];
				store_data [31:16] = 16'd0;
				store_data [7:0] = 8'd0;
			end
			2'b11: begin
				byte_ena = 4'b0001;
				store_data [7:0] = rs2_data[7:0];
				store_data [31:8] = 24'd0;
			end
			default: begin
				byte_ena = 4'b0000;
				store_data = 32'd0;
			end
		endcase
	end
	else if (funct3_ == SH) begin
		case (address_target[1])
			1'b0: begin
				byte_ena = 4'b1100;
				store_data[31:16] = rs2_data[15:0];
				store_data[15:0] = 16'd0;
			end
			2'b1: begin
				byte_ena = 4'b0011;
				store_data[31:16] = 16'd0;
				store_data[15:0] =	rs2_data[15:0];
			end
			default: begin
				byte_ena = 4'b0000;
				store_data = 32'd0;
			end
		endcase
	end
	else if (funct3_ == SW) begin
		byte_ena = 4'b1111;
		store_data = rs2_data;
	end
	else begin
		byte_ena = 4'b0000;
		store_data = 32'd0;
	end

end

endmodule