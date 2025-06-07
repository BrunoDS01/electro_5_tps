module mem_latch(
	
	input wire rd_memory,
	input wire [2:0] funct3_,
	input wire [31:0] address_target,
	
	input wire stg_clk,
	input wire stg_ena,
	input wire stg_x,
	input wire reset,
	
	output reg rd_memory_out,
	output reg [2:0] funct3_out,
	output reg [31:0] address_target_out
);

always @(posedge stg_clk or posedge reset) begin
	if(reset) begin
	
		rd_memory_out <= 0;
		funct3_out <= 0;
		address_target_out <= 0;
	end
	else begin
		rd_memory_out <= rd_memory;
		funct3_out <= funct3_;
		address_target_out <= address_target;
	end
end

endmodule