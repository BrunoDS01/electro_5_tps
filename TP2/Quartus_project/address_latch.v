module address_latch(
	
	input wire [31:0] prev_pc,

	input wire [31:0] address_target,
	input wire [1:0] flag_branch,
	
	
	input wire [1:0] prev_counter,
	input wire prev_valid,
	input wire prev_branch_prediction,
	input wire rd_memory,
	input wire wr_memory,
	input wire [2:0] funct3_,
	input wire [31:0] rs2_data,
	
	input wire stg_clk,
	input wire stg_ena,
	input wire stg_x,
	input wire reset,

	
	output reg [31:0] prev_pc_out,

	output reg [31:0] address_target_out,
	output reg [1:0] flag_branch_out,

	output reg [1:0] prev_counter_out,
	output reg prev_valid_out,
	output reg prev_branch_prediction_out,
	output reg rd_memory_out,
	output reg wr_memory_out,
	output reg [2:0] funct3_out,
	output reg [31:0] rs2_data_out
);

always @(posedge stg_clk or posedge reset) begin
	if(reset) begin
	
		address_target_out <= 0;
		flag_branch_out <= 0;
		
		prev_counter_out <= 0;
		prev_valid_out <= 0;
		prev_branch_prediction_out <= 0;
		prev_pc_out <= 0;
		rd_memory_out <= 0;
		wr_memory_out <= 0;
		funct3_out <= 0;
		rs2_data_out <= 0;
		
	end
	else begin
		if(stg_x) begin
			address_target_out <= 0;
			flag_branch_out <= 0;
			
			prev_counter_out <= 0;
			prev_valid_out <= 0;
			prev_branch_prediction_out <= 0;
			prev_pc_out <= 0;
			rd_memory_out <= 0;
			wr_memory_out <= 0;
			funct3_out <= 0;
			rs2_data_out <= 0;
		end
		else if (stg_ena) begin
			address_target_out <= address_target;
			flag_branch_out <= flag_branch;
			
			prev_counter_out <= prev_counter;
			prev_valid_out <= prev_valid;
			prev_branch_prediction_out <= prev_branch_prediction;
			prev_pc_out <= prev_pc;
			rd_memory_out <= rd_memory;
			wr_memory_out <= wr_memory;
			funct3_out <= funct3_;
			rs2_data_out <= rs2_data;
		end

	end
end

endmodule