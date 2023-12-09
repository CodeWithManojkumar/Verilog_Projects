`include "mux.v"
`include "mux3.v"
`include "register.v"
`include "register_bank.v"
`include "instr_mem.v"
`include "data_mem.v"
`include "adder.v"
`include "ALU.v"
`include "signext.v"
`include "forwarding_unit.v"

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



// IF Stage
register pcreg(clk,reset,ldpc,pcnext,pcout); // Program Counter Register
instr_mem imem(readim,pcout[7:2],instr); // Instruction Memory
adder addpc(pcout,32'h00000004,pcplus4); // Adder for PC + 4
mux muxbr(pcplus4,pcbranch,pcsrc,pcnext); // Mux for Branching

// IF/ID Latch Stage
register IF_ID_npcreg(clk,reset,1'b1,pcplus4,if_id_npcout);
register IF_ID_irreg(clk,reset,1'b1,instr,if_id_irout);

// ID Stage
register_bank rbank(clk,regwrite,reset,if_id_irout[25:21],if_id_irout[20:16],mem_wb_destadd,wb_writedata,rData1,rData2); // Register Bank
signext ext(if_id_irout[15:0],imm); // Sign Extend

// controller

// ID/EX Stage
register ID_EX_npcreg(clk,reset,1'b1,if_id_npcout,id_ex_npcout);
register ID_EX_rData1(clk,reset,1'b1,rData1,id_ex_rData1);
register ID_EX_rData2(clk,reset,1'b1,rData2,id_ex_rData2);
register ID_EX_imm(clk,reset,1'b1,imm,id_ex_immout);
register ID_EX_directaddress(clk,reset,1'b1,{4{if_id_irout},if_id_irout[25:0],2'b00},id_ex_directaddr);
register #(5) ID_EX_rt(clk,reset,1'b1,if_id_irout[20:16],id_ex_rt);
register #(5) ID_EX_rd(clk,reset,1'b1,if_id_irout[15:11],id_ex_rd);
register #(5) ID_EX_rs(clk,reset,1'b1,if_id_irout[25:21],id_ex_rs);


// ID/EX Stage Control Signals for EX Stage
register #(1) ID_EX_ALUsrc(clk,reset,1'b1,alusrc,id_ex_alusrc);
register #(4) ID_EX_ALUfunc(clk,reset,1'b1,alufunc,id_ex_alufunc);
register #(1) ID_EX_Regdest(clk,reset,1'b1,regdest,id_ex_regdest);
register #(1) ID_EX_Address(clk,reset,1'b1,address,id_ex_address);
register #(1) ID_EX_Branch(clk,reset,1'b1,branch,id_ex_branch);

// ID/EX Stage Control Signals for MEM Stage
register #(1) ID_EX_MemRead(clk,reset,1'b1,readdmem,id_ex_readdmem);
register #(1) ID_EX_Memwrite(clk,reset,1'b1,writedmem,id_ex_writedmem);
register #(1) ID_EX_PcSrc(clk,reset,1'b1,pcsrc,id_ex_pcsrc);

// ID/EX Stage Control Signals for WB Stage
register #(1) ID_EX_Regwrite(clk,reset,1'b1,regwrite,id_ex_regwrite);
register #(1) ID_EX_MemtoReg(clk,reset,1'b1,memtoreg,id_ex_memtoreg);


// Forwarding Unit
forwarding_unit forward(id_ex_rs,id_ex_rt,ex_mem_destadd,mem_wb_destadd,forwardA,forwardB);

// EX Stage
mux3 mux3A(id_ex_rData1,wb_writedata,ex_mem_result,forwardA,aluin1);
mux3 mux3B(id_ex_rData2,wb_writedata,ex_mem_result,forwardB,writedatadmem);
mux alumux(writedatadmem,id_ex_immout,id_ex_alusrc,aluin2);
ALU alu(aluin1,aluin2,id_ex_alufunc,1'b1,zero,result); // Arithmetic Logic Unit
mux #(5) destmux(id_ex_rt,id_ex_rd,regdest,dest); // Mux for Destination Address
mux conditional(id_ex_immout,id_ex_directaddr,,addressrelative);
adder bradd(id_ex_npcout,addressrelative,pcbranch);


// EX/MEM Stage
register EX_MEM_resultreg(clk,reset,1'b1,result,ex_mem_result);
register #(1) EX_MEM_zeroreg(clk,reset,1'b1,zero,ex_mem_zero);
register EX_MEM_writeData(clk,reset,1'b1,writedatadmem,ex_mem_writeData);
register #(5) EX_MEM_destreg(clk,reset,1'b1,dest,ex_mem_destadd);

// EX/MEM Stage Control Signals for MEM Stage
register #(1) EX_MEM_MemRead(clk,reset,1'b1,id_ex_readdmem,ex_mem_readdmem);
register #(1) EX_MEM_Memwrite(clk,reset,1'b1,id_ex_writedmem,ex_mem_writedmem);
register #(1) EX_MEM_PcSrc(clk,reset,1'b1,id_ex_pcsrc,ex_mem_pcsrc);
register #(1) EX_MEM_branchreg(clk,reset,1'b1,id_ex_pcbranch,ex_mem_branch);

// EX/MEM Stage Control Signals for WB Stage
register #(1) EX_MEM_Regwrite(clk,reset,1'b1,id_ex_regwrite,ex_mem_regwrite);
register #(1) EX_MEM_MemtoReg(clk,reset,1'b1,id_ex_memtoreg,ex_mem_memtoreg);


// MEM Stage
data_mem dmem(clk,reset,writedmem,readdmem,ex_mem_result,ex_mem_writeData,readdmemData); // Data Memory

// MEM/WB Stage
register MEM_WB_readData1(clk,reset,1'b1,ex_mem_result,mem_wb_readData1);
register MEM_WB_readData2(clk,reset,1'b1,readdmemData,mem_wb_readData2);
register #(5) MEM_WB_destreg(clk,reset,1'b1,ex_mem_destadd,mem_wb_destadd);

// MEM/WB Stage Control Signals for WB Stage
register #(1) MEM_WB_Regwrite(clk,reset,1'b1,ex_mem_regwrite,mem_wb_regwrite);
register #(1) MEM_WB_MemtoReg(clk,reset,1'b1,ex_mem_memtoreg,mem_wb_memtoreg);

// WB Stage
mux wbmux(mem_wb_readData1,mem_wb_readData2,selwb,wb_writedata); // Mux for Writeback

endmodule
