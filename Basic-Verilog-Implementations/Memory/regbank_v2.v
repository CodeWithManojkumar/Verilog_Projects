// 32 x 32 register file
module regbank_v2 (rData1,rData2,wrData,sr1,sr2,dr,write,clk,reset);

input clk,write,reset;
input [4:0] sr1,sr2,dr;
input [31:0] wrData;
output reg [31:0] rData1,rData2;

reg [31:0] regfile[0:31];
integer k;

assign rData1 = regfile[sr1];
assign rData2 = regfile[sr2];

always @(posedge clk)
	begin
		if(reset)begin
			for(k=0;k<32;k=k+1)
			begin 
				regfile[k]<=0;
			end 
		end 
		
		else begin
			if(write) 
				regfile[dr] <= wrData;
			end
	end
endmodule 