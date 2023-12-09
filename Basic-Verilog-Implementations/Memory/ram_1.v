module ram_1(addr,data,clk,rd,wr,cs);

	input [9:0] addr;
	inout [7:0] data;
	input clk,rd,wr,cs;
	reg [7:0] mem[1023:0];
	reg [7:0] d_out;

	assign data = (cs && rd)? d_out : 8'bz;

	always @(posedge clk)
		if(cs && wr && !rd) mem[addr] = data;
		
	always @(posedge clk)
		if(cs && !wr && rd) d_out = mem[addr];
	
endmodule