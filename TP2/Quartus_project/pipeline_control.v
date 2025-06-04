module pipeline_control (
	input wire [4:0] rs1_dec,
	input wire rs1_used_dec,
	input wire [4:0] rs2_dec,
	input wire rs2_used_dec,
	
	input wire [4:0] rd_op,
	input wire rd_used_op,
	input wire [4:0] rd_ex,
	input wire rd_used_ex,

	output reg fetch_halt,
	output reg dec_halt,
	output reg op_halt,
	output reg ex_halt,
	output reg wb_halt,
	output reg mem_halt,
	
	output reg fetch_nop,
	output reg dec_nop,
	output reg op_nop,
	output reg ex_nop,
	output reg wb_nop,
	output reg mem_nop
);

always@(rs1_dec, rs2_dec, rd_op, rd_ex, rs1_used_dec, rs2_used_dec, rd_used_op, rd_used_ex) begin
	// RS - RD
	
	if (rs1_used_dec || rs2_used_dec) begin
		// DEC - OP
		if(rd_used_op && ((rs1_dec == rd_op) || (rs2_dec == rd_op))) begin
			fetch_halt = 1;
			dec_halt = 1;
			op_halt = 0;
			ex_halt = 0;
			wb_halt = 0;
			mem_halt = 0;
			
			fetch_nop = 0;
			dec_nop = 1;
			op_nop = 0;
			ex_nop = 0;
			wb_nop = 0;
			mem_nop = 0;
			
		end else if(rd_used_ex && ((rs1_dec == rd_ex) || (rs2_dec == rd_ex))) begin
			fetch_halt = 1;
			dec_halt = 1;
			op_halt = 1;
			ex_halt = 0;
			wb_halt = 0;
			mem_halt = 0;
			
			fetch_nop = 0;
			dec_nop = 0;
			op_nop = 1;
			ex_nop = 0;
			wb_nop = 0;
			mem_nop = 0;
		end else begin
			fetch_halt = 0;
			dec_halt = 0;
			op_halt = 0;
			ex_halt = 0;
			wb_halt = 0;
			mem_halt = 0;
			
			fetch_nop = 0;
			dec_nop = 0;
			op_nop = 0;
			ex_nop = 0;
			wb_nop = 0;
			mem_nop = 0;
		end
		
	end else begin
		fetch_halt = 0;
		dec_halt = 0;
		op_halt = 0;
		ex_halt = 0;
		wb_halt = 0;
		mem_halt = 0;
		
		fetch_nop = 0;
		dec_nop = 0;
		op_nop = 0;
		ex_nop = 0;
		wb_nop = 0;
		mem_nop = 0;
	end
end

endmodule