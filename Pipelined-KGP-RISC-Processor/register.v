module register 
#(parameter N = 32)
(
	input wire clk,reset,ld,
    input wire signed [N-1:0] din,
	output reg signed [N-1:0] dout
);

	always @(posedge clk or negedge reset)
    begin
        if(reset)
            dout<=0;
        else if(ld)
            dout<=din;
    end

endmodule