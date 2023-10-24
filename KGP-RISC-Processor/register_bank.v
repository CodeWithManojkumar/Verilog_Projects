module register_bank (
    input wire clk,write,reset,
    input wire  [4:0] sr1,sr2,dr,
    input wire [31:0] wrData,
    output wire [31:0] rData1,rData2
);
reg [31:0] regfile[0:31];
integer k;

initial begin
	regfile[0] <= 32'b0;
end
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
			if(write && dr!=3'b0) 
				regfile[dr] <= wrData;
			end
	end
    
endmodule