`include "up_down_counter.v"
module up_down_counter_tb;
reg clk,reset,en,ctrl;
wire [4:0] out;

up_down_counter u0(.clk(clk),.reset(reset),.en(en),.ctrl(ctrl),.counter_out(out));

initial begin 
$display ("time\t clk reset enable ctrl counter");	
  $monitor ("%g\t %b   %b     %b      %b    %b", 
	  $time, clk, reset, en,ctrl, out);	
  clk = 1;       // initial value of clock
  reset = 0;       // initial value of reset
  en = 0;      // initial value of enable
  ctrl=0;
  #5 reset = 1;    // Assert the reset
  #10 reset = 0;   // De-assert the reset
  #10 en = 1;  // Assert enable
  #50 ctrl=1;
  #100 en = 0; // De-assert enable
  #5 $finish;      // Terminate simulation
end

// Clock generator
always begin
  #5 clk = ~clk; // Toggle clock every 5 ticks
end
endmodule