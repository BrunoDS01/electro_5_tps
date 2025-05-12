module operand_build(
	input wire [31:0] rs1_data,
	input wire [31:0] rs2_data,
	
	input wire [31:0] pc,
	input wire [31:0] imm,
	
	input wire [6:0] opcode,
	
	output reg [31:0] a,
	output reg [31:0] b

);

/*
OPDCODES
*/
localparam OP = 6'b0110011;
localparam LOAD = 6'b0000011;
localparam STORE = 6'b0100011;


always @(
	opcode,
	rs1_data,
	rs2_data,
	pc,
	imm
)
begin
	case (opcode)
		OP: begin
			a = rs1_data;
			b = rs2_data;
		end
		default: begin
			a = 32'd0;
			b = 32'd0;
		end
	endcase
end


endmodule