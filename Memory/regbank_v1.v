// 4 x 32 register file
module regbank_v1 (rData1,rData2,wrData,sr1,sr2,dr,write,clk);

input clk,write;
input [1:0] sr1,sr2,dr;
input [31:0] wrData;
output reg [31:0] rData1,rData2;
reg [31:0] R0,R1,R2,R3;

always @(*)
	begin
		case(sr1)
			0: rData1 = R0;
			1: rData1 = R1;
			2: rData1 = R2;
			3: rData1 = R3;
			default: rData1 = 32'hxxxxxxxx;
		endcase
	end
always @(*)
	begin
		case(sr2)
			0: rData2 = R0;
			1: rData2 = R1;
			2: rData2 = R2;
			3: rData2 = R3;
			default: rData2 = 32'hxxxxxxxx;
		endcase
	end
always @(posedge clk)
	begin
		if(write)
			case(dr)
				0: R0<=wrData;
				1: R1<=wrData;
				2: R2<=wrData;
				3: R3<=wrData;
			endcase
	end
	
endmodule