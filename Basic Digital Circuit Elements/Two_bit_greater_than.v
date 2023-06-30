module Two_bit_greater_than
(
	input wire [1:0] a,b,
	output wire res
);

wire p0,p1,p2,p3,p4,p5;
assign res= p0 | p1 | p2 | p3 | p4 | p5;

assign p0 = (~a[1] & a[0]) & (~b[1] & ~b[0]);
assign p1 = (a[1] & ~a[0]) & (~b[1] & ~b[0]);
assign p2 = (a[1] & ~a[0]) & (~b[1] & b[0]);
assign p3 = (a[1] & a[0]) & (~b[1] & ~b[0]);
assign p4 = (a[1] & a[0]) & (~b[1] & b[0]);
assign p5 = (a[1] & a[0]) & (b[1] & ~b[0]);

endmodule