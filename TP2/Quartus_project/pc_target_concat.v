module pc_target_concat (
	input wire [10:0] ram_pc,
	
	output wire [31:0] pc_target_prediction
);

assign pc_target_prediction[1:0] = 2'b00;
assign pc_target_prediction[12:2] = ram_pc;
assign pc_target_prediction[31:13] = 19'd0;

endmodule