`include "mux.v"
`include "register.v"
`include "register_bank.v"
`include "instr_mem.v"
`include "data_mem.v"
`include "adder.v"
`include "ALU.v"
`include "signext.v"
`include "condition.v"

module datapath(
    input wire clk,reset,
    // Input signals from control unit
    input wire readim,ldir,ldnpc,
    input wire ldA,ldB,ldimm,
    input wire [1:0] opcond,
    input wire alusel1,alusel2,aluen,ldaluout,
    input wire [3:0] alufunc,
    input wire seldest,regwrite,writedmem,readdmem,ldlmd,
    input wire selwb,branch,ldpc,

    // Output signals to control unit
    output wire [31:0] irout,aluout,
    output wire [31:0] writedata
);

// Define wires used in datapath
wire [31:0] pcout,npcout,Aout,Bout,immout,lmdout;
wire [31:0] instr,pcplus4,pcbranch,pcnext;
wire [31:0] Ain,Bin,imm;
wire [31:0] destadd;
wire [31:0] aluin1,aluin2,result;
wire [31:0] dmemout,memmuxout;

// IF Stage
register pcreg(clk,reset,ldpc,pcnext,pcout); // Program Counter Register
instr_mem imem(readim,pcout[7:2],instr); // Instruction Memory
register irreg(clk,reset,ldir,instr,irout); // Instruction Register
adder addpc(pcout,32'h00000004,pcplus4); // Adder for PC + 4
register npcreg(clk,reset,ldnpc,pcplus4,npcout); // Next Program Counter Register
adder bradd(npcout,{{4{irout[25]}}, irout[25:0], 2'b00},pcbranch); // Branch Address Calculation
mux muxbr(memmuxout,pcbranch,branch,pcnext); // Mux for Branching

// ID Stage
mux destmux({27'b0,irout[15:11]},{27'b0,irout[20:16]},seldest,destadd); // Mux for Destination Address
register_bank rbank(clk,regwrite,reset,irout[25:21],irout[20:16],destadd[4:0],writedata,Ain,Bin); // Register Bank
signext ext(instr[15:0],imm); // Sign Extend
register A(clk,reset,ldA,Ain,Aout); // Register A
register B(clk,reset,ldB,Bin,Bout); // Register B
register immreg(clk,reset,ldimm,imm,immout); // Immediate Register

// EX Stage
condition cond(selmem,opcond,Aout); // Condition for Branching
mux muxalu1(npcout,Aout,alusel1,aluin1); // Mux for ALU Input 1
mux muxalu2(Bout,immout,alusel2,aluin2); // Mux for ALU Input 2
ALU alu(aluin1,aluin2,alufunc,aluen,result); // Arithmetic Logic Unit
register aluoutreg(clk,reset,ldaluout,result,aluout); // ALU Output Register

// MEM Stage
data_mem dmem(clk,reset,writedmem,readdmem,aluout,Bout,dmemout); // Data Memory
register lmdreg(clk,reset,ldlmd,dmemout,lmdout); // Load Memory Data Register
mux memmux(npcout,aluout,selmem,memmuxout); // Mux for Memory Access

// WB Stage
mux wbmux(lmdout,aluout,selwb,writedata); // Mux for Writeback

endmodule
