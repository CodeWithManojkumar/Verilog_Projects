`include "gcd_datapath.v"
`include "controller.v"

module GCD_test;

	reg [15:0] data_in;
	reg start,clk;
	wire done;
	reg [15:0] A,B;

	GCD_datapath  DP(gt,lt,eq,LdA,LdB,sel1,sel2,sel_in,data_in,clk);
	controller    CON(LdA,LdB,sel1,sel2,sel_in,done,clk,lt,gt,eq,start);

	initial 
		begin
			$dumpfile("test.vcd");
			$dumpvars(0,GCD_test);
			clk=1'b0;
			#3 start=1'b1;
			#1000 $finish;
		end
	always #5 clk=~clk;

	initial
		begin
			#12 data_in=143;
			#10 data_in=78;
		end
	initial
		begin
			$monitor($time,"%d %b",DP.Aout, done);
		end
endmodule