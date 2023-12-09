module MUX_2X1(
	input wire [1:0] a,b, // 2 2-bit numbers
	input wire sel, // one select input 
	output wire [1:0] out // mux output
	);

assign out = (sel) ? b : a ;
endmodule;