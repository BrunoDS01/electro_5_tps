module mem_latch(
	
	input wire rd_memory,
	
	input wire stg_clk,
	input wire stg_ena,
	input wire stg_x,
	input wire reset,
	
	output reg rd_memory_out
);

always @(posedge stg_clk or posedge reset) begin
	if(reset) begin
	
		rd_memory_out <= 0;
		
	end
	else begin
		rd_memory_out <= rd_memory;

	end
end

endmodule