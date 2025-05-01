module fetch_unit (         
    input wire [31:0] instr_in,
	input wire stage_clk,
	input wire reset,	
    input wire stage_ena,          
    input wire stage_x,   	

    output wire [31:0] instr_out,
	output wire [31:0] pc_out
);

reg[31:0] pc;
reg[31:0] pc_next;
reg[31:0] instr;

always @(posedge stage_clk or posedge reset) begin
	if (reset) begin
		pc <= 32'd0;
		instr <= 32'd0;
	end
	else begin
		pc <= pc_next;
		instr <= instr_in;
	end
end

always @(pc) begin
	pc_next = pc + 32'd4;
end

assign pc_out = pc;
assign instr_out = instr;

endmodule