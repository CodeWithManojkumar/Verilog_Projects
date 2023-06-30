`include "Three_bit_greater_than.v"
module Three_bit_greater_than_tb;

reg [2:0] t0,t1;
wire t_out;

Three_bit_greater_than u0(.a(t0),.b(t1),.res(t_out));

initial
begin

$monitor("a=%b , b=%b , res=%b",t0,t1,t_out);

t0 = 3'b000;
t1 = 3'b000;
# 1;

t0 = 3'b100;
t1 = 3'b000;
# 1;

t0 = 3'b010;
t1 = 3'b100;
# 1;

t0 = 3'b100;
t1 = 3'b011;
# 1;

t0 = 3'b001;
t1 = 3'b010;
# 1;

t0 = 3'b110;
t1 = 3'b010;
# 1;

end

endmodule