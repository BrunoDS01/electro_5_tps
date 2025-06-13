module branch_result_module(
	input wire [1:0] flag_add_build_branch,
	input wire alu_branch_flag,
	
	output reg branch_result
);

always @(flag_add_build_branch, alu_branch_flag) begin
	// Si es un salto incondicional, se lo debe tomar
	if (flag_add_build_branch == 2'b01 || flag_add_build_branch == 2'b10) begin
		branch_result = 1'b1;
	end
	// Si es un salto condicional, depende de la salida de la ALU
	else if(flag_add_build_branch == 2'b11) begin
		branch_result = alu_branch_flag;	
	end
	// Si no es un salto, no se lo toma
	else begin
		branch_result = 1'b0;
	end
end

endmodule