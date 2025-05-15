module tag_latch(
	input wire [4:0] in_tag,
	input wire clk,
	input wire reset,
	output reg [4:0] out_tag
);

always @(posedge clk or posedge reset) begin
	if (reset) begin
		out_tag <= 5'd0;
	end
	else begin
		out_tag <= in_tag;
	end
	
end

endmodule