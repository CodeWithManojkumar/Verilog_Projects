`include "4_bit_adder.v"
module four_bit_adder_tb ;

reg [3:0] a,b ;
wire [3:0] sum;
wire carry;

four_bit_adder u0(.a(a),.b(b),.sum(sum),.carry(carry));
initial
begin

$monitor("a=%b b=%b carry=%b sum=%b",a,b,carry,sum);

a=10;
b=15;
#1;

a=2;
b=13;
#1;

a=11;
b=12;
#1;

end

endmodule