`include "mux.v"
`include "register.v"
`include "register_bank.v"
`include "instr_mem.v"
`include "data_mem.v"
`include "adder.v"
`include "ALU.v"
`include "signext.v"
module datapath(
    input wire clk,reset,
    input wire readim,ldir,ldnpc,
    input wire ldA,ldB,ldimm,
    input wire [1:0] opcond,
    input wire alusel1,alusel2,aluen,ldaluout,
    input wire [3:0] alufunc,
    input wire regwrite,writedmem,readdmem,ldlmd,
    input wire selwb,branch,ldpc,

    output reg [31:0] irout,aluout,
    output wire [31:0] writedata
);

reg [31:0] pcout,npcout,Aout,Bout,immout,aluout,lmdout;
wire [31:0] instr,pcplus4,pcbranch,pcnext;
wire [31:0] Ain,Bin,imm;
wire [31:0] aluin1,aluin2,result,aluout;
wire [31:0] dmemout,memmuxout;

// IF Stage
register pcreg(clk,reset,ldpc,pcnext,pcout);
instr_mem imem(readim,pcout[7:2],instr);
register irreg(clk,reset,ldir,instr,irout);
adder addpc(pcout,32'b4,pcplus4);
register npcreg(clk,reset,ldnpc,pcplus4,npcout);
adder bradd(npcout,{4{irout[25]},{irout[25:0]},2'b00},pcbranch);
mux muxbr(memmuxout,pcbranch,branch,pcnext);

// ID Stage
register_bank rbank(clk,regwrite,reset,irout[25:21],irout[20:16],irout[15:11],writedata,Ain,Bin);
signext ext(instr[15:0],imm);
register A(clk,reset,ldA,Ain,Aout);
register B(clk,reset,ldB,Bin,Bout);
register immreg(clk,reset,ldimm,imm,immout);

// EX Stage
condition cond(selmem,opcond,Aout);
mux muxalu1(npcout,Aout,alusel1,aluin1);
mux muxalu2(Bout,immout,alusel2,aluin2);
ALU alu(aluin1,aluin2,alufunc,aluen,result);
register aluoutreg(clk,reset,ldaluout,result,aluout);

// MEM Stage
data_mem dmem(clk,writedmem,readdmem,aluout,Bout,dmemout);
register lmdreg(clk,reset,ldlmd,dmemout,lmdout);
mux memmux(npcout,aluout,selmem,memmuxout);

// WB Stage
mux wbmux(lmdout,aluout,selwb,writedata);

endmodule