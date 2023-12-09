`include "Four_to_sixteen_decoder.v"

module Four_to_sixteen_decoder_tb;

reg [3:0] t;
reg en;
wire [15:0] t_out;

Four_to_sixteen_decoder u0(.a(t),.en(en),.out(t_out));

initial
begin

$monitor("a=%b , en=%b , out=%b",t,en,t_out);

t=4'b0000;
en=0;
# 1;

t=4'b1010;
en=1;
# 1;

t=4'b1110;
en=1;
# 1;

t=4'b1101;
en=0;
# 1;

t=4'b1001;
en=1;
# 1;

end

endmodule