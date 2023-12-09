module Two_to_four_decoder(
	input wire [1:0] a,
	input wire en,
	output wire [3:0] out
);

assign out[0] = en & (~a[1] & ~a[0]);
assign out[1] = en & (~a[1] & a[0]);
assign out[2] = en & (a[1] & ~a[0]);
assign out[3] = en & (a[1] & a[0]);

endmodule