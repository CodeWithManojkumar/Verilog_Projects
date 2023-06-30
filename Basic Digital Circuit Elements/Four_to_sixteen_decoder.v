`include "Two_to_four_decoder.v"

module Four_to_sixteen_decoder(
	input wire [3:0] a,
	input wire en,
	output wire [15:0] out
);

wire en1,en2,en3,en4;
assign en1= ~a[3] & ~a[2] & en ;
assign en2= ~a[3] & a[2] & en ;
assign en3= a[3] & ~a[2] & en ;
assign en4= a[3] & a[2] & en ;


Two_to_four_decoder u0(.a(a[1:0]),.en(en4),.out(out[15:12]));
Two_to_four_decoder u1(.a(a[1:0]),.en(en3),.out(out[11:8]));
Two_to_four_decoder u2(.a(a[1:0]),.en(en2),.out(out[7:4]));
Two_to_four_decoder u3(.a(a[1:0]),.en(en1),.out(out[3:0]));

endmodule