`include "MUX_4X1.v"
module MUX_4X1_tb;

reg [1:0] t0,t1,t2,t3;
reg [1:0]s;
wire [1:0] t_out;;

MUX_4X1 u0(.a(t0),.b(t1),.c(t2),.d(t3),.sel(s),.out(t_out));
initial
begin

$monitor("a=%b , b=%b , c=%b , d=%d , s=%b , res=%b",t0,t1,t2,t3,s,t_out);

t0 = 2'b00;
t1 = 2'b01;
t2 = 2'b10;
t3 = 2'b11;
s=0;
# 1;

t0 = 2'b00;
t1 = 2'b01;
t2 = 2'b10;
t3 = 2'b11;
s=1;
# 1;

t0 = 2'b00;
t1 = 2'b01;
t2 = 2'b10;
t3 = 2'b11;
s=2;
# 1;

t0 = 2'b00;
t1 = 2'b01;
t2 = 2'b10;
t3 = 2'b11;
s=3;
# 1;

end

endmodule