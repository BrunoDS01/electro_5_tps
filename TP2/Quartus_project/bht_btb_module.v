// Copyright (C) 2025  Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus Prime License Agreement,
// the Altera IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Altera and sold by Altera or its authorized distributors.  Please
// refer to the Altera Software License Subscription Agreements 
// on the Quartus Prime software download page.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 24.1std.0 Build 1077 03/04/2025 SC Lite Edition"
// CREATED		"Sun May 11 00:39:33 2025"

module bht_btb_module(
	clk,
	reset,
	is_branch,
	increment_counter,
	pc_fetch,
	pc_fetch_update,
	pc_target_update,
	branch_prediction,
	pc_target_prediction
);


input wire	clk;
input wire	reset;
input wire	is_branch;
input wire	increment_counter;
input wire	[31:0] pc_fetch;
input wire	[31:0] pc_fetch_update;
input wire	[31:0] pc_target_update;
output wire	branch_prediction;
output wire	[31:0] pc_target_prediction;

wire	[5:0] address1_;
wire	[5:0] address2_;
wire	[31:0] ram_out1_;
wire	[31:0] ram_out2_;
wire	[31:0] wr_data1_;
wire	[31:0] wr_data2_;
wire	wr_enable1_;
wire	wr_enable2_;





bht_btb_ram	b2v_inst(
	.wren_a(wr_enable1_),
	.wren_b(wr_enable2_),
	.clock(clk),
	.address_a(address1_),
	.address_b(address2_),
	.data_a(wr_data1_),
	.data_b(wr_data1_),
	.q_a(ram_out1_),
	.q_b(ram_out2_));


bht_btb_controller	b2v_inst6(
	.is_branch(is_branch),
	.increment_counter(increment_counter),
	.clk(clk),
	.reset(reset),
	.bht_btb_ram_output1_(ram_out1_),
	.bht_btb_ram_output2_(ram_out2_),
	.pc_fetch(pc_fetch),
	.pc_fetch_update(pc_fetch_update),
	.pc_target_update(pc_target_update),
	.wr_enable1_(wr_enable1_),
	.wr_enable2_(wr_enable2_),
	.branch_prediction(branch_prediction),
	.address1_(address1_),
	.address2_(address2_),
	.pc_target_prediction(pc_target_prediction),
	.wr_data1_(wr_data1_)
	);
	defparam	b2v_inst6.ADDR_WIDTH = 6;
	defparam	b2v_inst6.COUNTER_BITS = 2;
	defparam	b2v_inst6.PC_BITS = 11;


endmodule
