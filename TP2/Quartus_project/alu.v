module alu(
	input wire [31:0] a,
	input wire [31:0] b,
	
	input wire [9:0] funct,
	
	output reg [31:0] c
);

/*
FUNCT TABLE

*/
localparam ADD = 10'b0000000000;

always @(a, b, funct) begin
	case (funct)
		ADD: begin
			c = a + b;
		end
		
		default: begin
			c = 0;
		end
	endcase
end

endmodule