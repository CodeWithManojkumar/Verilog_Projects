module BOOTH_datapath(LdA,LdQ,LdM,clrA,clrQ,clrff,sftA,sftQ,addsub,decr,LdCnt,data_in,clk,qm1,eqz);

	input LdA,LdQ,LdM,clrA,clrQ,clrff,sftA,sftQ,addsub,clk,decr,LdCnt;
	input [15:0] data_in;
	output qm1,eqz;
	wire [15:0] A,M,Q,Z;
	wire[4:0] count;

	assign eqz = ~&count;

	shiftreg AR(A,Z,A[15],clk,LdA,clrA,sftA);
	shiftreg QR(Q,data_in,A[0],clk,LdQ,clrQ,sftQ);
	dff QM1(Q[0],qm1,clk,clrff);
	PIPO MR(data_in,M,clk,LdM);
	ALU AS(Z,A,M,addsub);
	CNTR CN(count,decr,LdCnt,clk);

endmodule

// shiftreg module
module shiftreg(data_out,data_in,s_in,clk,ld,clr,sft);

input s_in,clk,ld,clr,sft;
input [15:0] data_in;
output reg [15:0] data_out;

always @(posedge clk)
	begin
		if(clr)data_out<=0;
		else if(ld)
			data_out<=data_in;
		else if(sft)
			data_out<={s_in,data_out[15:1]};
	end

endmodule

// PIPO module
module PIPO (dout,din,ld,clk);

	input [15:0] din;
	input ld,clk;
	output reg [15:0] dout;

	always @(posedge clk)
		if(ld) dout<=din;

endmodule

// dff module
module dff(d,q,clk,clr);

	input d,clk,clr;
	output reg q;

	always @(posedge clk)
		if(clr) q<=0;
		else q<=d;
	
endmodule

// ALU module
module ALU(out,in1,in2,addsub);

	input [15:0] in1,in2;
	input addsub;
	output reg [15:0] out;

	always @(*)
		begin
			if(addsub==0) out=in1-in2;
			else out = in1+in2;
		end
		
endmodule

// CNTR module
module CNTR(dout,decr,ldcnt,clk);

	input decr,ldcnt,clk;
	output reg [4:0] dout;

	always @(posedge clk)
		begin
			if(ldcnt) dout<=5'b10000;
			else if(decr) dout<=dout-1;
		end

endmodule