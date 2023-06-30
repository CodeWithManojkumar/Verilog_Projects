`include "MUX_2X1.v"
module MUX_2X1_tb;

reg [1:0] t0,t1;
reg s;
wire [1:0] t_out;;

MUX_2X1 u0(.a(t0),.b(t1),.sel(s),.out(t_out));
initial
begin

$monitor("a=%b , b=%b , s=%b , res=%b",t0,t1,s,t_out);

t0 = 2'b01;
t1 = 2'b11;
s=0;
# 1;

t0 = 2'b01;
t1 = 2'b11;
s=1;
# 1;

t0 = 2'b01;
t1 = 2'b10;
s=1;
# 1;

t0 = 2'b10;
t1 = 2'b11;
s=0;
# 1;

t0 = 2'b00;
t1 = 2'b11;
s=0;
# 1;

t0 = 2'b01;
t1 = 2'b00;
s=1;
# 1;

end

endmodule