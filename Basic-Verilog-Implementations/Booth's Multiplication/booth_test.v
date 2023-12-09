`include "booth_datapath.v"
`include "controller.v"

module BOOTH_test;

	reg [15:0] data_in;
	reg start,clk;
	wire done,res;

	BOOTH_datapath DP(LdA,LdQ,LdM,clrA,clrQ,clrff,sftA,sftQ,addsub,decr,LdCnt,data_in,clk,qm1,eqz);
	controller CON(LdA,clrA,sftA,LdQ,clrQ,sftQ,LdM,clrff,addsub,start,decr,LdCnt,done,clk,q0,qm1,eqz);

	assign res={DP.A,DP.Q};
	initial 
		begin
			clk=1'b0;
			#3 start=1'b1;
			#500 $finish;
		end
	always #5 clk=~clk;

	initial
		begin
			#17 data_in=17;
			#10 data_in=5;
		end
	initial
		begin
			$monitor($time,"%d %b",DP.A, done);
		end
endmodule