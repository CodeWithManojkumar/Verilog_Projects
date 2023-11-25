 module mux
  #(parameter N = 32)
  (
   input wire signed [N-1:0] a, b,
	input wire s,
	output wire signed [N-1:0] out      
	);
   assign out = (s)? b : a;

  endmodule