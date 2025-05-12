module concat_funct(
	input wire [2:0] funct3_,
	input wire [6:0] funct7_,
	
	output wire [9:0] funct	
);

assign funct = {funct7_, funct3_};

endmodule