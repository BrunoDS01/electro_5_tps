module decode_latch(
	input wire branch_prediction,
	input wire valid,
	input wire [1:0] counter,
	input wire [31:0] pc,
	input wire [4:0]  rs1,
	input wire [4:0]  rs2,
	input wire [4:0]  rd,
	input wire [2:0]  funct3_,
	input wire [6:0]  funct7_,
	input wire [31:0] imm,
	input wire [6:0]  opcode,

	input wire [2:0] instr_type,
	input wire save_to_reg,
	input wire rs1_used,
	input wire rs2_used,
	input wire immediate_used,
	input wire is_branch,
	input wire rd_memory,
	input wire wr_memory,
	input wire shamt_used,

	
	input wire stg_clk,
	input wire stg_ena,
	input wire stg_x,
	input wire reset,
	
	output reg branch_prediction_out,
	output reg valid_out,
	output reg [1:0] counter_out,
	output reg [31:0] pc_out,
	output reg [4:0]  rs1_out,
	output reg [4:0]  rs2_out,
	output reg [4:0]  rd_out,
	output reg [2:0]  funct3_out,
	output reg [6:0]  funct7_out,
	output reg [31:0] imm_out,
	output reg [6:0]  opcode_out,

	output reg [2:0] instr_type_out,
	
	output reg save_to_reg_out,
	output reg rs1_used_out,
	output reg rs2_used_out,
	output reg immediate_used_out,
	output reg is_branch_out,
	output reg rd_memory_out,
	output reg wr_memory_out,
	output reg shamt_used_out
);

always @(posedge stg_clk or posedge reset) begin
	if(reset) begin
		branch_prediction_out <= 0;
		valid_out <= 0;
		counter_out <= 0;
		pc_out <= 0;
		rs1_out <= 0;
		rs2_out <= 0;
		rd_out <= 0;
		funct3_out <= 0;
		funct7_out <= 0;
		imm_out <= 0;
		opcode_out <= 0;
		
		instr_type_out <= 0;
		
		save_to_reg_out <= 0;
		rs1_used_out <= 0;
		rs2_used_out <= 0;
		immediate_used_out <= 0;
		is_branch_out <= 0;
		rd_memory_out <= 0;
		wr_memory_out <= 0;
		shamt_used_out <= 0;
	end
	else begin
		if (stg_x) begin
			branch_prediction_out <= 0;
			valid_out <= 0;
			counter_out <= 0;
			pc_out <= 0;
			rs1_out <= 0;
			rs2_out <= 0;
			rd_out <= 0;
			funct3_out <= 0;
			funct7_out <= 0;
			imm_out <= 0;
			opcode_out <= 0;
			
			instr_type_out <= 0;
			
			save_to_reg_out <= 0;
			rs1_used_out <= 0;
			rs2_used_out <= 0;
			immediate_used_out <= 0;
			is_branch_out <= 0;
			rd_memory_out <= 0;
			wr_memory_out <= 0;
			shamt_used_out <= 0;
			
		end else if (stg_ena) begin
			branch_prediction_out <= branch_prediction;
			valid_out <= valid;
			counter_out <= counter;
			pc_out <= pc;
			rs1_out <= rs1;
			rs2_out <= rs2;
			rd_out <= rd;
			funct3_out <= funct3_;
			funct7_out <= funct7_;
			imm_out <= imm;
			opcode_out <= opcode;

			instr_type_out <= instr_type;
				
				
			save_to_reg_out <= save_to_reg;
			rs1_used_out <= rs1_used;
			rs2_used_out <= rs2_used;
			immediate_used_out <= immediate_used;
			is_branch_out <= is_branch;
			rd_memory_out <= rd_memory;
			wr_memory_out <= wr_memory;
			shamt_used_out <= shamt_used;
		end

		  
	end
end

endmodule