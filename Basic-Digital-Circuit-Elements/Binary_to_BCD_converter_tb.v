`include "Binary_to_BCD_converter.v"
module Binary_to_BCD_converter_tb ;
reg [7:0] test;
wire [11:0] out;

Binary_to_BCD_converter u0 (.bin(test),.bcd(out));

initial
begin
$monitor("test=%b , out=%b",test,out);

test=34;
#500;

test=50;
#500;

test=255;
#500;

end
endmodule