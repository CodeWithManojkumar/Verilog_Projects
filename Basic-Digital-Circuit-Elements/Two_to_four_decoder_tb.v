`include "Two_to_four_decoder.v"

module Two_to_four_decoder_tb;

reg [1:0] t;
reg en;
wire [3:0] t_out;

Two_to_four_decoder u0(.a(t),.en(en),.out(t_out));

initial
begin

$monitor("a=%b , en=%b , out=%b",t,en,t_out);

t=2'b00;
en=0;
# 1;

t=2'b01;
en=1;
# 1;

t=2'b10;
en=1;
# 1;

t=2'b11;
en=0;
# 1;

t=2'b11;
en=1;
# 1;

end

endmodule