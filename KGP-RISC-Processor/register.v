module register (
	input wire clk,reset,ld,
    input wire [15:0] din,
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