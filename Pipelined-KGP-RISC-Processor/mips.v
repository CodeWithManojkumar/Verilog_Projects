`include "mux.v"
`include "mux3.v"
`include "mux5.v"
`include "register.v"
`include "register_bank.v"
`include "instr_mem.v"
`include "data_mem.v"
`include "adder.v"
`include "ALU.v"
`include "signext.v"
`include "condition.v"
`include "controller.v"
`include "forwarding_unit.v"
`include "forwarding_unit_id.v"
`include "stall_control.v"
`include "flush_control.v"
`include "load_store_bypassing_unit.v"

module mips(
    input wire clk,clkbar,reset
);

// Define wires used in datapath
wire readim,pc_en;
wire [31:0] pcnext,pcbranch,pcplus4,pcout,instr,instr_out;
wire [31:0] if_id_npcout,if_id_irout;
wire if_id_flush;

wire [31:0] rData1,rData2,imm,offset;
wire [4:0] rs,rt,rd;
wire [31:0] ReadData1out,ReadData2out;
wire [3:0] alufunc;
wire branch_condition,alusrc,regdest,readdmem,writedmem,regwrite,memtoreg,jump,pcsrc;
wire stall,if_flush,flush;
wire if_id_write,pc_write;
wire [3:0] id_alufunc;
wire id_alusrc,id_regdest,id_branch,id_readdmem,id_writedmem,id_pcsrc,id_regwrite,id_memtoreg;
wire [31:0] id_ex_rData1,id_ex_rData2,id_ex_immout;
wire [4:0] id_ex_rt,id_ex_rd,id_ex_rs;
wire [3:0] id_ex_alufunc;
wire id_ex_alusrc,id_ex_regdest,id_ex_readdmem,id_ex_writedmem,id_ex_regwrite,id_ex_memtoreg;

wire [2:0] forwardA,forwardB;
wire [31:0] aluin1,aluin2,writedatadmem,result;
wire zero;
wire [4:0] dest;
wire ex_mem_zero;
wire [4:0] ex_mem_destadd;
wire [31:0] ex_mem_result,ex_mem_writeData;
wire ex_mem_readdmem,ex_mem_writedmem,ex_mem_regwrite,ex_mem_memtoreg;

wire forwardC;
wire [31:0] finalWriteData,readdmemData;
wire [31:0] mem_wb_readData1,mem_wb_readData2;
wire [4:0] mem_wb_destadd;
wire mem_wb_regwrite,mem_wb_memtoreg;

wire [31:0] wb_writedata;

// IF Stage
assign pcwriteen = pc_en & pc_write; // PC enable
register pcreg(clk,reset,pcwriteen,pcnext,pcout); // Program Counter Register
instr_mem imem(clk,1'b1,pcout[7:2],instr,pc_en); // Instruction Memory
adder addpc(pcout,32'h00000004,pcplus4); // Adder for PC + 4
mux muxbr(if_id_npcout,pcbranch,pcsrc,pcnext); // Mux for Branching

// IF/ID Latch Stage
register IF_ID_npcreg(clkbar,reset,if_id_write,pcplus4,if_id_npcout);
register IF_ID_irreg(clkbar,reset,if_id_write,instr,if_id_irout);
register #(1) IF_ID_flushbit(clkbar,reset,if_id_write,if_flush,if_id_flush);

// ID Stage
assign rs = if_id_irout[25:21];
assign rt = if_id_irout[20:16];
assign rd = if_id_irout[15:11];
register_bank rbank(clk,mem_wb_regwrite,reset,rs,rt,mem_wb_destadd,wb_writedata,rData1,rData2); // Register Bank
signext ext(if_id_irout[15:0],imm); // Sign Extend
mux offsetmux({imm[29:0],2'b00},{{4{if_id_irout[25]}},if_id_irout[25:0],2'b00},jump,offset);
adder pcbranchadder(if_id_npcout,offset,pcbranch);// Next Address 

// ID Stage Forwarding Unit
forwarding_unit_id forwarding(rs,rt,
        dest,ex_mem_destadd,mem_wb_destadd,id_ex_regwrite,ex_mem_readdmem,ex_mem_regwrite,ex_mem_memtoreg,mem_wb_regwrite,forwardA,forwardB);
mux5 readdatamux1(rData1,readdmemData,ex_mem_result,result,wb_writedata,forwardA,ReadData1out);// Final Read Data 1
mux5 readdatamux2(rData2,readdmemData,ex_mem_result,result,wb_writedata,forwardB,ReadData2out);// Final Read Data 2

// controller
controller controllerunit(clk,reset,if_id_irout,branch_condition,alusrc,alufunc,regdest,readdmem,writedmem,regwrite,memtoreg,jump,pcsrc);

// comparison block
condition comparisonblock(branch_condition,if_id_irout[27:26],ReadData1out,ReadData2out);

// Stall Control
stall_control stallunit(id_ex_readdmem,writedmem,id_ex_rt,rs,rt,stall,pc_write,if_id_write);

// flush control
assign if_flush = pcsrc;
assign flush = if_flush | stall;
flush_control flushunit(alusrc,alufunc,regdest,readdmem,writedmem,regwrite,memtoreg,flush,
                        id_alusrc,id_alufunc,id_regdest,id_readdmem,id_writedmem,id_regwrite,id_memtoreg);

// ID/EX Stage
register ID_EX_rData1(clkbar,reset,1'b1,ReadData1out,id_ex_rData1);
register ID_EX_rData2(clkbar,reset,1'b1,ReadData2out,id_ex_rData2);
register ID_EX_imm(clkbar,reset,1'b1,imm,id_ex_immout);
register #(5) ID_EX_rs(clkbar,reset,1'b1,rs,id_ex_rs);
register #(5) ID_EX_rt(clkbar,reset,1'b1,rt,id_ex_rt);
register #(5) ID_EX_rd(clkbar,reset,1'b1,rd,id_ex_rd);

// ID/EX Stage Control Signals for EX Stage
register #(1) ID_EX_ALUsrc(clkbar,reset,1'b1,id_alusrc,id_ex_alusrc);
register #(4) ID_EX_ALUfunc(clkbar,reset,1'b1,id_alufunc,id_ex_alufunc);
register #(1) ID_EX_Regdest(clkbar,reset,1'b1,id_regdest,id_ex_regdest);

// ID/EX Stage Control Signals for MEM Stage
register #(1) ID_EX_MemRead(clkbar,reset,1'b1,id_readdmem,id_ex_readdmem);
register #(1) ID_EX_Memwrite(clkbar,reset,1'b1,id_writedmem,id_ex_writedmem);

// ID/EX Stage Control Signals for WB Stage
register #(1) ID_EX_Regwrite(clkbar,reset,1'b1,id_regwrite,id_ex_regwrite);
register #(1) ID_EX_MemtoReg(clkbar,reset,1'b1,id_memtoreg,id_ex_memtoreg);

// Forwarding Unit
// forwarding_unit forward(id_ex_rs,id_ex_rt,ex_mem_destadd,mem_wb_destadd,ex_mem_regwrite,mem_wb_regwrite,forwardA,forwardB);

// EX Stage
// mux3 mux3A(id_ex_rData1,wb_writedata,ex_mem_result,forwardA,aluin1);
// mux3 mux3B(id_ex_rData2,wb_writedata,ex_mem_result,forwardB,writedatadmem);
assign aluin1 = id_ex_rData1;
mux alumux(id_ex_rData2,id_ex_immout,id_ex_alusrc,aluin2); // ALU mux
ALU alu(aluin1,aluin2,id_ex_alufunc,1'b1,zero,result); // Arithmetic Logic Unit
mux #(5) destmux(id_ex_rt,id_ex_rd,id_ex_regdest,dest); // Mux for Destination Address

// EX/MEM Stage
register EX_MEM_resultreg(clkbar,reset,1'b1,result,ex_mem_result);
register #(1) EX_MEM_zeroreg(clkbar,reset,1'b1,zero,ex_mem_zero);
register EX_MEM_writeData(clkbar,reset,1'b1,id_ex_rData2,ex_mem_writeData);
register #(5) EX_MEM_destreg(clkbar,reset,1'b1,dest,ex_mem_destadd);

// EX/MEM Stage Control Signals for MEM Stage
register #(1) EX_MEM_MemRead(clkbar,reset,1'b1,id_ex_readdmem,ex_mem_readdmem);
register #(1) EX_MEM_Memwrite(clkbar,reset,1'b1,id_ex_writedmem,ex_mem_writedmem);

// EX/MEM Stage Control Signals for WB Stage
register #(1) EX_MEM_Regwrite(clkbar,reset,1'b1,id_ex_regwrite,ex_mem_regwrite);
register #(1) EX_MEM_MemtoReg(clkbar,reset,1'b1,id_ex_memtoreg,ex_mem_memtoreg);

// MEM Stage
load_store_bypassing_unit loadstore(mem_wb_memtoreg,ex_mem_writedmem,ex_mem_destadd,mem_wb_destadd,forwardC); // load store btpassing unit
mux loadstoreselect(ex_mem_writeData,mem_wb_readData2,forwardC,finalWriteData);
data_mem dmem(clk,reset,ex_mem_writedmem,ex_mem_readdmem,ex_mem_result,finalWriteData,readdmemData); // Data Memory

// MEM/WB Stage
register MEM_WB_readData1(clkbar,reset,1'b1,ex_mem_result,mem_wb_readData1);
register MEM_WB_readData2(clkbar,reset,1'b1,readdmemData,mem_wb_readData2);
register #(5) MEM_WB_destreg(clkbar,reset,1'b1,ex_mem_destadd,mem_wb_destadd);

// MEM/WB Stage Control Signals for WB Stage
register #(1) MEM_WB_Regwrite(clkbar,reset,1'b1,ex_mem_regwrite,mem_wb_regwrite);
register #(1) MEM_WB_MemtoReg(clkbar,reset,1'b1,ex_mem_memtoreg,mem_wb_memtoreg);

// WB Stage
mux wbmux(mem_wb_readData1,mem_wb_readData2,mem_wb_memtoreg,wb_writedata); // Mux for Writeback

endmodule