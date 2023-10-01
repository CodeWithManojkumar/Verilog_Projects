`include "ALU.v"
`include "register_bank.v"
`include "mux.v"
module ALU_regbank_test;
reg [3:0] mode;
reg en;
wire [31:0] out,ALUout;
reg clk,write,reset;
reg [4:0] sr1,sr2,dr;
reg [31:0] wrData;
wire [31:0] rData1,rData2;
reg sel;

mux m(.a(ALUout),.b(wrData),.s(sel),.out(out));
register_bank rf(.rData1(rData1),.rData2(rData2),.wrData(out),.sr1(sr1),.sr2(sr2),.dr(dr),.write(write),.clk(clk),.reset(reset));
ALU uut(.operand1(rData1), .operand2(rData2), .mode(mode),.en(en),.out(ALUout));

initial begin
    clk = 0;en=0;reset=0;sel=1;
    #2 write=1; dr=5'b00001; wrData=370;
    #5 dr=5'b00010; wrData=4;

    #10 write=0;
    #15 sr1=5'b00001; sr2=5'b00010;
    #25 en=1; mode=4'b0000;
    #30 write=1; dr=5'b00011;sel=0;

    #10 write=1; dr=5'b00100;mode=7;


    #10 $finish;

end
always #5 clk = ~clk;
    initial
		begin
			$monitor($time,"%d %d %d %d %b %b %b",rf.regfile[1],rf.regfile[2],rf.regfile[3],rf.regfile[4],write,en,mode);
		end

endmodule