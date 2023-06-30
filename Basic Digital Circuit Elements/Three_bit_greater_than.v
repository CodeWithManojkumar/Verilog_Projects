`include "Two_bit_greater_than.v"
module Three_bit_greater_than
(
	input wire [2:0] a,b,
	output wire res
);

wire p0,p1;

Two_bit_greater_than u0(.a(a[2:1]),.b(b[2:1]),.res(p0));
Two_bit_greater_than u1(.a(a[1:0]),.b(b[1:0]),.res(p1));

assign res = p0 | p1;

endmodule