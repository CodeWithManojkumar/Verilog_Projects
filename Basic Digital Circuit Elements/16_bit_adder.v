module sixteen_bit_adder(
	input wire [15:0] a,b,
	output wire [15:0] sum,
	output wire sign,carry,parity,overflow,zero
);

assign {carry,sum} = a+b;
assign sign = sum[15];
assign zero = ~|sum;
assign parity = ~^sum;
assign overflow = (a[15] & b[15] & ~sum[15]) | 
					(~a[15] & ~b[15] & sum[15]);
					
endmodule