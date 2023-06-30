`include "MUX_2X1.v"
module MUX_4X1(
	input wire [1:0] a,b,c,d, // 2 2-bit numbers
	input wire [1:0] sel, // one select input 
	output wire [1:0] out // mux output
	);
wire [1:0] p0,p1;
MUX_2X1 u0(.a(a),.b(b),.sel(sel[0]),.out(p0));
MUX_2X1 u1(.a(c),.b(d),.sel(sel[0]),.out(p1));

MUX_2X1 u2(.a(p0),.b(p1),.sel(sel[1]),.out(out));
endmodule;