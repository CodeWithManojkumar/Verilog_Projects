module register (
	input wire clk,reset,ld,
    input wire signed [31:0] din,
	output reg signed [31:0] dout
);

	always @(posedge clk)
    begin
        if(reset)
            dout<=32'b0;
        else if(ld)
            dout<=din;
    end

endmodule