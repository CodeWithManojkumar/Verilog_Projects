`include "Two_to_four_decoder.v"

module Three_to_eight_decoder(
	input wire [2:0] a,
	input wire en,
	output wire [7:0] out
);

wire en1,en2;
assign en1= ~a[2] & en ;
assign en2= a[2] & en ;

Two_to_four_decoder u0(.a(a[1:0]),.en(en2),.out(out[7:4]));

Two_to_four_decoder u1(.a(a[1:0]),.en(en1),.out(out[3:0]));

endmodule