`include "datapath.v"
`include "controller.v"
module mips (
    input wire clk,reset,
    output wire [31:0] writedata
);
wire readim,ldir,ldnpc;
wire ldA,ldB,ldimm;
wire [1:0] opcond;
wire alusel1,alusel2,aluen,ldaluout;
wire [3:0] alufunc;
wire seldest,regwrite,writedmem,readdmem,ldlmd;
wire selwb,branch,ldpc;
wire [31:0] irout,aluout;
    
datapath dpath(clk,reset,readim,ldir,ldnpc,ldA,ldB,ldimm,opcond,alusel1,alusel2,aluen,ldaluout,alufunc,seldest,regwrite,writedmem,readdmem,ldlmd,selwb,branch,ldpc,irout,aluout,writedata);
controller ctrl(clk,reset,irout,readim,ldir,ldnpc,ldA,ldB,ldimm,opcond,alusel1,alusel2,aluen,ldaluout,alufunc,seldest,regwrite,writedmem,readdmem,ldlmd,selwb,branch,ldpc);

endmodule