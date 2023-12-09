module MUL_datapath(eqz,LdA,LdB,LdP,clrP,decB,data_in,clk);

	input LdA,LdB,LdP,clrP,decB,clk;
	input [15:0] data_in;
	output eqz;
	wire [15:0] X,Y,Z,Bout;

	PIPO1 A(X,data_in,LdA,clk);
	PIPO2 P(Y,Z,LdP,clrP,clk);

	CNTR  B(Bout,data_in,LdB,decB,clk);
	ADD  AD(Z,X,Y);
	EQZ  COMP(eqz,Bout);

endmodule

// PIPO1 module
module PIPO1 (dout,din,ld,clk);

	input [15:0] din;
	input ld,clk;
	output reg [15:0] dout;

	always @(posedge clk)
		if(ld) dout<=din;

endmodule

// PIPO2 module
module PIPO2 (dout,din,ld,clr,clk);

	input [15:0] din;
	input ld,clr,clk;
	output reg [15:0] dout;

	always @(posedge clk)
		if(clr) dout<=16'b0;
		else if(ld) dout<=din;

endmodule

// ADD module
module ADD(out,in1,in2);

	input [15:0] in1,in2;
	output reg [15:0] out;

	always @(*)
		out=in1+in2;

endmodule

// EQZ module
module EQZ(eqz,data);

	input [15:0] data;
	output eqz;

	assign eqz=(data==0);

endmodule

// CNTR module
module CNTR(dout,din,ld,dec,clk);

	input [15:0] din;
	input ld,dec,clk;
	output reg [15:0] dout;

	always @(posedge clk)
		if(ld) dout<=din;
		else if(dec) dout<=dout-1;

endmodule