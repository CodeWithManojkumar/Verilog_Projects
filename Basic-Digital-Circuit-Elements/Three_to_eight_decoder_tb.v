`include "Three_to_eight_decoder.v"

module Three_to_eight_decoder_tb;

reg [2:0] t;
reg en;
wire [7:0] t_out;

Three_to_eight_decoder u0(.a(t),.en(en),.out(t_out));

initial
begin

$monitor("a=%b , en=%b , out=%b",t,en,t_out);

t=3'b000;
en=0;
# 1;

t=3'b010;
en=1;
# 1;

t=3'b110;
en=1;
# 1;

t=3'b111;
en=0;
# 1;

t=3'b101;
en=1;
# 1;

end

endmodule