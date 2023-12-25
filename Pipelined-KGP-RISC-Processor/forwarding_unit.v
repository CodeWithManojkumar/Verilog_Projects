module forwarding_unit (
    input wire [4:0] id_ex_rs,id_ex_rt,
    input wire [4:0] ex_mem_rd,mem_wb_rd,
    input wire ex_mem_regwrite,mem_wb_regwrite,

    output wire [1:0] forwardA,forwardB
);
    
wire a1,a2,b1,b2,b3,b4,x,x1,y,y1;

/*
forward A : 00 : read from register bank
forward A : 01 : read from wb_writedata
forward A : 10 : read from ex_mem_result

forward A
-----------
00 : default
01 : ex_mem_rd == id_ex_rs and ex_mem_regwrite == 1
10 : (not of 01 condition) and (mem_wb_regwrite == 1 and mem_wb_rd == id_ex_rs)

same as forwardB, use rt in place of rs.
*/


assign a1 = (ex_mem_regwrite == 1'b1) ;
assign b1 = (ex_mem_rd == id_ex_rs);
assign x = a1 & b1;

assign a2 = (mem_wb_regwrite == 1'b1) ;
assign b2 = (mem_wb_rd == id_ex_rs);
assign y = a2 & b2;

assign forwardA[1] = x;
assign forwardA[0] = ~x & y ; 


assign b3 = (ex_mem_rd == id_ex_rt);
assign x1 = a1 & b3;

assign b4 = (mem_wb_rd == id_ex_rt);
assign y1 = a2 & b4;

assign forwardB[1] = x1;
assign forwardB[0] = ~x1 & y1 ; 

endmodule