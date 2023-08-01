module GCD_datapath(gt,lt,eq,LdA,LdB,sel1,sel2,sel_in,data_in,clk);

	input LdA,LdB,sel1,sel2,sel_in,clk;
	input [15:0] data_in;
	output gt,lt,eq;
	wire [15:0] Aout, Bout, X, Y, Bus, SubOut;

	PIPO A(Aout,Bus,LdA,clk);
	PIPO B(Bout,Bus,LdB,clk);
	MUX MUX_in1(X,Aout,Bout,sel1);
	MUX MUX_in2(Y,Aout,Bout,sel2);
	MUX MUX_load(Bus,SubOut,data_in,sel_in);
	SUB SB(SubOut,X,Y);
	COMPARE COMP(lt,gt,eq,Aout,Bout);

endmodule

// PIPO module
module PIPO (dout,din,ld,clk);

	input [15:0] din;
	input ld,clk;
	output reg [15:0] dout;

	always @(posedge clk)
		if(ld) dout<=din;

endmodule

// SUB module
module SUB(out,in1,in2);

	input [15:0] in1,in2;
	output reg [15:0] out;

	always @(*)
		out=in1-in2;

endmodule

// COMPARE module
module COMPARE(lt,gt,eq,data1,data2);

	input [15:0] data1,data2;
	output lt,gt,eq;
	
	assign lt=data1<data2;
	assign gt=data1>data2;
	assign eq=data1==data2;
	
endmodule

// MUX module
module MUX(out,in0,in1,sel);

	input [15:0] in0,in1;
	input sel;
	output [15:0] out;
	
	assign out = sel ? in1 : in0;
	
endmodule