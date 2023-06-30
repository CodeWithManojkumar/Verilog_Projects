`include "Binary_to_Gray_code_converter.v"
module Binary_to_Gray_code_converter_tb ;

reg [7:0] test;
wire [7:0] out;

Binary_to_Gray_code_converter u0(.b(test),.g(out));

initial
begin

$monitor("test=%b , out=%b",test,out);

test=100;
#1;

test=51;
#1;

test= 200;
#1;

end

endmodule