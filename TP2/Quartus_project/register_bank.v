module register_bank(
    input wire [4:0] rs1,
    input wire [4:0] rs2,

    input wire [31:0] data_in,
    input wire [31:0] alu_out,
    input wire [4:0] rd,
	 
	 input wire save_to_reg,
	 

    input wire stage_clk,
    input wire reset,

    output reg [31:0] rs1_data,
    output reg [31:0] rs2_data,
    output reg [31:0] data_out,
	output reg memwrite
);

reg [31:0] x[0:31];


always @(rs1) begin
	if (rs1 == 0) begin
		rs1_data = 32'd0;
	end
	else begin
		rs1_data = x[rs1];
	end
end

always @(rs2) begin
	if (rs2 == 0) begin
		rs2_data = 32'd0;
	end
	else begin
		rs2_data = x[rs2];
	end
end

/*
	Actualización
*/


always @(posedge stage_clk or posedge reset) begin
	if (reset) begin
		integer i;
		for (i = 0; i < 32; i = i + 1) begin
            x[i] <= 32'd0;
        end
	end
	else begin
		if(save_to_reg) begin
			x[rd] <= alu_out;
		end
	end
end

endmodule