module register (
    input wire [15:0] din,
	input wire ld,clk,reset,
	output reg [15:0] dout
);

	always @(posedge clk)
    begin
        if(reset)
            dout<=0;
        else if(ld)
            dout<=din;
    end

endmodule