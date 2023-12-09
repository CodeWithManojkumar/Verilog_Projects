`include "Hex_to_seven_segment_decoder.v"
module Hex_to_seven_segment_decoder_tb;

reg [3:0] test;
reg dp;
wire [7:0] out;

Hex_to_seven_segment_decoder u0(.hex(test),.dp(dp),.sseg(out));

initial
begin

$monitor("test=%b , dp=%b , out=%b",test,dp,out);

test=4'hd;
dp=0;
# 1;

test=4'h2;
dp=0;
# 1;

test=4'hf;
dp=1;
# 1;

end

endmodule