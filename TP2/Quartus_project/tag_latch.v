module tag_latch(
	input wire [23:0] in_tag,
	input wire clk,
	input wire reset,
	output reg [23:0] out_tag
);

always @(posedge clk or posedge reset) begin
	if (reset) begin
		out_tag <= 27'd0;
	end
	else begin
		out_tag <= in_tag;
	end
	
end

endmodule