module forwarding_unit (
    input wire [4:0] id_ex_rs,id_ex_rt,
    input wire [4:0] ex_mem_rd,mem_wb_rd,
    input wire ex_mem_regwrite,mem_wb_regwrite,

    output wire [1:0] forwardA,forwardB
);
    
wire a,b1,b2,c1,c2;

assign a = (mem_wb_regwrite == 1'b1) ;

assign b1 = (mem_wb_rd == id_ex_rs);
assign b2 = (mem_wb_rd == id_ex_rt);

assign c1 = (ex_mem_rd != id_ex_rs) | (ex_mem_regwrite == 1'b0);
assign c2 = (ex_mem_rd != id_ex_rt) | (ex_mem_regwrite == 1'b0);

assign forwardA[1] = a & b1 & ~c1;
assign forwardA[0] = a & b1 & c1 ; 

assign forwardB[1] = a & b2 & ~c2;
assign forwardB[0] = a & b2 & c2 ; 

endmodule