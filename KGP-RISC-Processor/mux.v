 module mux
  #(parameter N = 32)
  (
   input wire [N-1:0] a, b,
	input wire s,
	output wire [N-1:0] out      
	);
   assign out = (s)? b : a;

  endmodule