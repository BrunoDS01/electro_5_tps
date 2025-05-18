module ad_latch(
	
	input wire [31:0] prev_pc,

	input wire [31:0] pc_target_ad,
	input wire [1:0] flag_branch_ad,
	
	
	input wire [1:0] prev_counter,
	input wire prev_valid,
	input wire prev_branch_prediction,
	
	input wire stg_clk,
	input wire stg_ena,
	input wire stg_x,
	input wire reset,

	
	output reg [31:0] prev_pc_out,

	output reg [31:0] pc_target_ad_out,
	output reg [1:0] flag_branch_ad_out,

	output reg [1:0] prev_counter_out,
	output reg prev_valid_out,
	output reg prev_branch_prediction_out
);

always @(posedge stg_clk or posedge reset) begin
	if(reset) begin
	
		pc_target_ad_out <= 0;
		flag_branch_ad_out <= 0;
		
		prev_counter_out <= 0;
		prev_valid_out <= 0;
		prev_branch_prediction_out <= 0;
		prev_pc_out <= 0;
		
	end
	else begin
	
		pc_target_ad_out <= pc_target_ad;
		flag_branch_ad_out <= flag_branch_ad;
		
		prev_counter_out <= prev_counter;
		prev_valid_out <= prev_valid;
		prev_branch_prediction_out <= prev_branch_prediction;
		prev_pc_out <= prev_pc;

	end
end

endmodule