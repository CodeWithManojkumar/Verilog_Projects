module COMPARE(lt,gt,eq,data1,data2);

	input [31:0] data1,data2;
	output lt,gt,eq;
	
	assign lt=data1<data2;
	assign gt=data1>data2;
	assign eq=data1==data2;
	
endmodule
module condition (
    output wire y,
    input wire [1:0] opcond,
    input wire [31:0] a
);

wire lt,gt,eq;
COMPARE cmp (lt,gt,eq,a,32'h00000000);

assign y =  (~opcond[1] & ~opcond[0] & gt) |
            (~opcond[1] & opcond[0] & lt)  |
            (opcond[1] & ~opcond[0] & eq)  |
            (opcond[1] & opcond[0] & 1'b0) ;

endmodule