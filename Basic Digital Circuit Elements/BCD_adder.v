module BCD_adder (
	input wire [7:0] a,b,
	output reg [7:0] out,
	output reg carry
);
wire [7:0] p;
wire c;

assign {c , p}= a+b;

always @*
	begin 
	if((~c & (p>9))|(c & (p<=9)))begin  
	// if sum<=9 and carry =1 
	// or sum>9 and carry =0 
	// then final answer is incorrect // add 6 to it

		 assign {carry,out}= p +6;
		
	end else begin
	
		carry=c;
		out=p;
		
	end
end

endmodule
		