`include "Priority_encoder.v"
module Priority_encoder_tb ;

reg [3:0] test;
wire [1:0] out;

Priority_encoder u0(.in(test),.y(out));

initial
begin

$monitor("test=%b , out=%b",test,out);

test=4'b0001;
#1;

test=4'b1010;
# 1;

test=4'b0101;
# 1;

test=4'b0010;
# 1;

end

endmodule