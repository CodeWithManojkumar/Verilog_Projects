module COMPARE(lt,gt,eq,neq,data1,data2);

	input signed [31:0] data1,data2;
	output lt,gt,eq,neq;
	
	assign lt=data1<data2;
	assign gt=data1>data2;
	assign eq=data1==data2;
    assign neq=data1!=data2;
	
endmodule
module condition (
    output wire y,
    input wire [1:0] opcond,
    input wire [31:0] a,b
);

wire lt,gt,eq,neq;
COMPARE cmp (lt,gt,eq,neq,a,b);

assign y =  (~opcond[1] & ~opcond[0] & lt) |
            (~opcond[1] & opcond[0] & gt)  |
            (opcond[1] & ~opcond[0] & eq)  |
            (opcond[1] & opcond[0] & neq) ;

endmodule