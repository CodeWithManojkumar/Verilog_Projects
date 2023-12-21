module wb_forward (
    output wire [31:0] rData1out,rData2out,
    input wire [31:0] rData1,rData2,
    input wire [31:0] wb_writedata,
    input wire [4:0] rs,rt,mem_wb_destadd,
    input wire mem_wb_regwrite
);

reg readrs,readrt;

always @(rs or rt or mem_wb_destadd or wb_writedata or mem_wb_regwrite)
begin
    if ((mem_wb_regwrite==1)&&(mem_wb_destadd != 0)&&(mem_wb_destadd==rs))
     readrs = 1'b1;
    else 
     readrs = 1'b0;
    if ((mem_wb_regwrite==1)&&(mem_wb_destadd != 0)&&(mem_wb_destadd==rt))
     readrt = 1'b1;
    else 
     readrt = 1'b0;
end

mux muxreaddata1(rData1,wb_writedata,readrs,rData1out);
mux muxreaddata2(rData2,wb_writedata,readrt,rData2out);

endmodule