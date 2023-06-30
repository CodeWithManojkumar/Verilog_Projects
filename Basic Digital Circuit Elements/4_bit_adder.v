module four_bit_adder (
	input wire [3:0] a,b,
	output reg [3:0] sum,
	output reg carry
);

always @(a or b)
assign {carry,sum} = a+b ;

endmodule