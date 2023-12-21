module register_bank (
    input wire clk,write,reset,
    input wire  [4:0] sr1,sr2,dr,
    input wire signed [31:0] wrData,
    output wire signed[31:0] rData1,rData2
);
reg signed[31:0] regfile[0:31];
reg signed[31:0] regData1,regData2;
integer k;

initial begin
	regfile[0] <= 32'b0;
end

assign rData1 = regData1;
assign rData2 = regData2;

always @(posedge clk) 
	#2
	begin
		regData1 <= regfile[sr1];
		regData2 <= regfile[sr2];
	end

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
			begin
				if(dr == 5'b00000) 
					regfile[dr] <= 32'b0;
				else
				regfile[dr] <= wrData;
			end
		end
	end
    
endmodule