`include "BCD_adder.v"
module BCD_adder_tb ;

reg [7:0] a,b;
wire [7:0] out;
wire carry ;

BCD_adder u0(.a(a),.b(b),.out(out),.carry(carry));

initial
begin

$monitor("a=%b b=%b carry=%b out=%b",a,b,carry,out);

a=8'b01010111;
b=8'b00100110;
#1;

a=8'b00001000;
b=8'b00001001;
end

endmodule