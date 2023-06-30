`include "Two_bit_greater_than.v"
module Two_bit_greater_than_tb;

reg [1:0] t0,t1;
wire t_out;

Two_bit_greater_than u0(.a(t0),.b(t1),.res(t_out));

initial
begin

$monitor("a=%b , b=%b , res=%b",t0,t1,t_out);
// t e s t v e c t o r 1
t0 = 2'b00;
t1 = 2'b00;
# 1;
// t e s t v e c t o r 2
t0 = 2'b01;
t1 = 2'b00;
# 1;

end

endmodule