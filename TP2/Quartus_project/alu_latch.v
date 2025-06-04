module alu_latch(
	input wire [4:0] rd,
	input wire [31:0] c,
	input wire save_to_reg,
	
	
	input wire stg_clk,
	input wire stg_ena,
	input wire stg_x,
	input wire reset,
	
	output reg [4:0] rd_out,
	output reg [31:0] c_out,
	output reg save_to_reg_out
);

always @(posedge stg_clk or posedge reset) begin
	if(reset) begin
		rd_out <= 0;
		c_out <= 0;
		save_to_reg_out <= 0;
	end
	else begin
		if (stg_x) begin
			rd_out <= 0;
			c_out <= 0;
			save_to_reg_out <= 0;
		end else if (!stg_ena) begin
			rd_out <= rd;
			c_out <= c;
			save_to_reg_out <= save_to_reg;
		end
	end
end

endmodule