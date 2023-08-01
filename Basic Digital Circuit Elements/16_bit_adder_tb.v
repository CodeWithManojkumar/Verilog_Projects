`include "16_bit_adder.v"
module sixteen_bit_adder_tb ;

reg [15:0] a,b ;
wire [15:0] sum;
wire sign,carry,parity,overflow,zero;

sixteen_bit_adder u0(.a(a),.b(b),.sum(sum),.carry(carry),.sign(sign),.parity(parity),.overflow(overflow),.zero(zero));
initial
begin

$monitor("a=%h b=%h carry=%b sum=%h zero=%b parity=%b sign=%b overflow=%b",a,b,carry,sum,zero,parity,sign,overflow);

a=16'h8fff;
b=16'h8000;
#1;

a=16'hfffe;
b=16'h0002;
#1;

a=16'hAAAA;
b=16'h5555;
#1;

end

endmodule