module memory(data_out,rs,rd,move,in,data_in,clk);

	input  wire move,in,clk;
	input  wire [2:0] rs,rd;
	input  wire [15:0] data_in;
	output wire [15:0] data_out;

	reg [15:0] registers[7:0];
	reg [15:0] data;
	wire enable;
	
	assign enable = (move|in);
	
	assign data_out = (enable)?data:16'bzzzzzzzzzzzzzzzz;
	always @(posedge clk)
		begin
			if(move)
				registers[rd]<=registers[rs];
			if(in)
				registers[rd]<=data_in;
		end
	always @(posedge clk)
		data<=registers[rs];
	
endmodule

module memory_tb;

reg move,in,clk;
reg [2:0] rs,rd;
reg [15:0] data_in;
wire [15:0] data_out;

memory u0 
		(.data_out(data_out),
		.move(move),
		.in(in),
		.data_in(data_in),
		.clk(clk),
		.rs(rs),
		.rd(rd));
		
initial begin
        clk = 0;
        move = 0;
        in = 0;
        data_in = 16'b0;
        
        #20;
        move = 1;
        rs = 3'b001;
        rd = 3'b010;
        data_in = 16'h1234;
        
        #20;
        move = 0;
        in = 1;
        data_in = 16'h5678;

        #20;
        move = 1;
        rs = 3'b010;
        rd = 3'b011;
	
	
		#20;
		move=0;
		in=1;
		rd=3'b100;
		data_in= 16'h0303;
		
		#20;
		move=1;
		in=0;
		rs=3'b100;
		rd=3'b101;
		
        #500;
        $finish;
end
initial
		begin
			$monitor($time,"    %b",data_out);
		end

always #5 clk=~clk;
endmodule