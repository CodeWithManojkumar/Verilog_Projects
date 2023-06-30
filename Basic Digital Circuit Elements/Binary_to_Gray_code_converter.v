module Binary_to_Gray_code_converter (
	input wire [7:0] b,
	output wire [7:0] g
);

assign g[7] = b[7];
assign g[6] = b[7]^b[6];
assign g[5] = b[6]^b[5];
assign g[4] = b[5]^b[4];
assign g[3] = b[4]^b[3];
assign g[2] = b[3]^b[2];
assign g[1] = b[2]^b[1];
assign g[0] = b[1]^b[0];

endmodule