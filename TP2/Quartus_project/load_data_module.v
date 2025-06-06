module load_data_module(
	input wire [2:0] funct3_,
	input wire [31:0] address_target,
	input wire [31:0] mem_data,

	output reg [31:0] load_data
);

/*
	FUNCT3_table
*/

localparam LB = 3'b000;
localparam LH = 3'b001;
localparam LW = 3'b010;
localparam LBU = 3'b100;
localparam LHU = 3'b101;


always @(funct3_, address_target, mem_data) begin
	if (funct3_ == LB) begin
		case (address_target[1:0])
			2'b00: begin
				load_data [7:0] = mem_data[31:24];
				load_data [31:8] = {24{mem_data[31]}};
			end
			2'b01: begin
				load_data [7:0] = mem_data[23:16];
				load_data [31:8] = {24{mem_data[23]}};
			end
			2'b10: begin
				load_data [7:0] = mem_data[15:8];
				load_data [31:8] = {24{mem_data[15]}};
			end
			2'b11: begin
				load_data [7:0] = mem_data[7:0];
				load_data [31:8] = {24{mem_data[7]}};
			end
			default: begin
				load_data [31:0] = 32'd0;
			end
		endcase
	end
	else if (funct3_ == LH) begin
		case (address_target[1])
			1'b0: begin
				load_data [15:0] = mem_data[31:16];
				load_data [31:16] = {16{mem_data[31]}};
			end
			2'b1: begin
				load_data [15:0] = mem_data[15:0];
				load_data [31:16] = {16{mem_data[15]}};
			end
			default: begin
				load_data [31:0] = 32'd0;
			end
		endcase
	end
	else if (funct3_ == LW) begin
		load_data = mem_data;
	end
	else if (funct3_ == LBU) begin
		case (address_target[1:0])
			2'b00: begin
				load_data [7:0] = mem_data[31:24];
				load_data [31:8] = 24'd0;
			end
			2'b01: begin
				load_data [7:0] = mem_data[23:16];
				load_data [31:8] = 24'd0;
			end
			2'b10: begin
				load_data [7:0] = mem_data[15:8];
				load_data [31:8] = 24'd0;
			end
			2'b11: begin
				load_data [7:0] = mem_data[7:0];
				load_data [31:8] = 24'd0;
			end
			default: begin
				load_data [31:0] = 32'd0;
			end
		endcase
	end
	else if (funct3_ == LHU) begin
		case (address_target[1])
			1'b0: begin
				load_data [15:0] = mem_data[31:16];
				load_data [31:16] = 16'd0;
			end
			2'b1: begin
				load_data [15:0] = mem_data[15:0];
				load_data [31:16] = 16'd0;
			end
			default: begin
				load_data [31:0] = 32'd0;
			end
		endcase
	end
	else begin
		load_data [31:0] = 32'd0;
	end

end

endmodule