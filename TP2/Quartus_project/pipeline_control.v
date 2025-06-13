module pipeline_control(
    input wire [4:0] rs1_dec,
    input wire rs1_used_dec,
    input wire [4:0] rs2_dec,
    input wire rs2_used_dec,
    
    input wire [4:0] rd_op,
    input wire rd_used_op,
    input wire [4:0] rd_ex,
    input wire rd_used_ex,
	
	input wire rd_memory_op,
	input wire rd_memory_mem,
	input wire flush_pipeline,

    output reg fetch_ena,
    output reg dec_ena,
    output reg op_ena,
    output reg ex_ena,
    output reg wb_ena,
    output reg mem_ena,
    
    output reg fetch_nop,
    output reg dec_nop,
    output reg op_nop,
    output reg ex_nop,
    output reg wb_nop,
    output reg mem_nop
);

always @(
    rs1_dec,
    rs2_dec,
    rd_op,
    rd_ex,
    rs1_used_dec,
    rs2_used_dec,
    rd_used_op,
    rd_used_ex,
	rd_memory_op,
	rd_memory_mem,
	flush_pipeline
)
begin

	if (flush_pipeline) begin
		// Si la lógica de saltos indica que hay que hacer un flush del pipeline, }
		// como eso ocurre en la etapa EX/MEM, hay que poner NOPs en los latches de FETCH, DEC, OP/ADD
		// el resto de las etapas se tienen que terminar de ejecutar
		fetch_ena = 1'b1;
		dec_ena = 1'b1;
		op_ena = 1'b1;
		ex_ena = 1'b1;
		wb_ena = 1'b1;
		mem_ena = 1'b1;
		
		fetch_nop = 1'b1;
		dec_nop = 1'b1;
		op_nop = 1'b1;
		ex_nop = 1'b0;
		wb_nop = 1'b0;
		mem_nop = 1'b0;
	end
	
    // RS - RD
    
	// Si la instrucción debe leer algún registro, y no es el registro nulo que nunca se modifica
    else if ((rs1_used_dec == 1'b1) || (rs2_used_dec == 1'b1)) begin
        // DEC - OP
        if(((rd_used_op == 1'b1 || rd_memory_op == 1'b1) && rd_op != 0) && ((rs1_dec == rd_op && rs1_used_dec == 1'b1) || (rs2_dec == rd_op && rs2_used_dec == 1'b1))) begin
            fetch_ena = 1'b0;
            dec_ena = 1'b0;
            op_ena = 1'b1;
            ex_ena = 1'b1;
            wb_ena = 1'b1;
            mem_ena = 1'b1;
            
            fetch_nop = 1'b0;
            dec_nop = 1'b1;
            op_nop = 1'b0;
            ex_nop = 1'b0;
            wb_nop = 1'b0;
            mem_nop = 1'b0;
            
        end
        else if(((rd_used_ex == 1'b1 || rd_memory_mem == 1'b1) && rd_ex != 0) && ((rs1_dec == rd_ex && rs1_used_dec == 1'b1) || (rs2_dec == rd_ex && rs2_used_dec == 1'b1))) begin
            fetch_ena = 1'b0;
            dec_ena = 1'b0;
            op_ena = 1'b0;
            ex_ena = 1'b1;
            wb_ena = 1'b1;
            mem_ena = 1'b1;
            
            fetch_nop = 1'b0;
            dec_nop = 1'b0;
            op_nop = 1'b1;
            ex_nop = 1'b0;
            wb_nop = 1'b0;
            mem_nop = 1'b0;
        end
        else begin
            fetch_ena = 1'b1;
            dec_ena = 1'b1;
            op_ena = 1'b1;
            ex_ena = 1'b1;
            wb_ena = 1'b1;
            mem_ena = 1'b1;
            
            fetch_nop = 1'b0;
            dec_nop = 1'b0;
            op_nop = 1'b0;
            ex_nop = 1'b0;
            wb_nop = 1'b0;
            mem_nop = 1'b0;
        end
    end
    else begin
        fetch_ena = 1'b1;
        dec_ena = 1'b1;
        op_ena = 1'b1;
        ex_ena = 1'b1;
        wb_ena = 1'b1;
        mem_ena = 1'b1;
        
        fetch_nop = 1'b0;
        dec_nop = 1'b0;
        op_nop = 1'b0;
        ex_nop = 1'b0;
        wb_nop = 1'b0;
        mem_nop = 1'b0;
    end
end

endmodule