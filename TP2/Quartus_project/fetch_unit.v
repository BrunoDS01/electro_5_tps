module fetch_unit (         
    input wire [31:0] instr_in,
	input wire stage_clk,          
    input wire stage_ena,          
    input wire stage_x,   

    output wire [31:0] instr_out,
	output wire [31:0] pc_out
);

reg[31:0] pc;
reg[31:0] instr;

always @(posedge stage_clk) begin
	pc <= pc + 32'd4;
	instr <= instr_in;
end

assign pc_out = pc;
assign instr_out = instr;

endmodule